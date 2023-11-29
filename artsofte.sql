----задание_1
select client_name, payment_date, max(value)
from default.payments
where toDate(payment_date) >= toDate('2023-01-01') and toDate(payment_date)<= toDate('2023-01-31')
group by client_name, payment_date;

----задание_2
select if(manager.department is null,'Отдел не определен', manager.department) as department, sum(value) as sum
    from (
        select manager_email, value
        from default.payments) payments
        left join (select REPLACE(department, '  ', ' ') AS department, REPLACE(email, 'n.', 'n') AS email from default.manager_departments) manager
        on payments.manager_email = manager.email
group by department;

----задание_3
SELECT
    id,
    value,
    client_id,
    client_name,
    payment_date,
    manager_name,
    manager_email,
    CASE
        WHEN cnt = 1 THEN 'Новый'
        ELSE 'Действующий'
    END AS client_state
FROM
    (
        SELECT
            id,
            value,
            client_id,
            client_name,
            payment_date,
            manager_name,
            manager_email,
            COUNT(*) OVER (PARTITION BY client_id) AS cnt
        FROM
            default.payments
    ) AS subquery;

----задание_4
select
    formatDateTime(toDate(concat(substring(toString(period), 1, 4), '-', substring(toString(period), 5, 2), '-01')), '%M %Y') AS period,
    revenue_by_month,
    revenue_cumulative
        from(
SELECT
    toYYYYMM(payment_date) AS period,
    sum(value) AS revenue_by_month,
    sum(sum(value)) OVER (ORDER BY toYYYYMM(payment_date)) AS revenue_cumulative
FROM
    default.payments
GROUP BY
    period
ORDER BY
    period);