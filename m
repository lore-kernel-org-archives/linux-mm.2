Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB92606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OaAyXkKQ
Received: by kanga.kvack.org (Postfix)
	id AF8F56B05B2; Tue,  3 Nov 2026 22:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8966B05B3; Tue,  3 Nov 2026 22:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE7A6B05B4; Tue,  3 Nov 2026 22:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 645916B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:22:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5E674063C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:22:34 +0000 (UTC)
X-FDA: 85395989028.23.E994621
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C0C520002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:22:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaAyXkKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793762552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWCFdcjUisnGbX9eq6UHrpBovt78PAdZKtud0fjPZzU=;
	b=pUWLF22Bl8SgSN9VVCowKgJZHwXnzrKt/LEyCXY/AqYH2ni7VAxL8Fk1PPsYVl7zy9qKtO
	vQQPLZMiYEXPkhv40Q3yCbOXVZ8tw5HaNqoR5KFgte5laQzgyIEluAPWXbhcWT1ZVyiBZx
	IN62Vd/8WgYh3qYgzGC69zrUyLtXGu0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaAyXkKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793762552;
	b=ZUWKSqntRA5mjnGV+xTaWGgZ+4krNgYkP+RdEHEZ6hKy6BEMOdlx67R8UYm1JaZn03v8Y7
	Ugo4fW435ErRZDoZ/sNXJnBVkHGlSYymnQN255dvXYm61MmkstcGfi2hz113RrvCZIbP6i
	mG7zaoKJgxVa0DrcdYDjBJ/mKEymfHE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E26E343F8D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94AD1F00A16
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793762550;
	bh=qWCFdcjUisnGbX9eq6UHrpBovt78PAdZKtud0fjPZzU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OaAyXkKQDVaRqOtox0bAyPP7k4UrH5HsY8Ra0sVkUlpLe1/FsofiFRKQVo3PfP6iu
	 uH8O+RlK/jDvUm1z3UespIMOj/0uC1AipSpHOg0x3QxJZriOfJQDIqJ1aP1Md1MxUu
	 nUADCDXu1wqdRh8noXbrTNk9ocHQs/u4Fa7wcbC/UoqrTBmxBUI4MdNf0yTNsUUzkH
	 Vyqu53OAuR1oVoHYkdE/YyTTNuHsELEAE/vu+Fc0dVvu4QCRIKsBdwAH9wdknibOvq
	 8i8KUGsZwMTP7WM7m4m4mZWMbVPYrGsQf1+rKUU363gJucg6haAJ9UlaqyagneLu/n
	 WqP9r1+9aheaQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f30660e69so21382085a.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 19:22:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw4S5PuQkgstwwslmEXbZiA48184geHAeZeWnYdn7HEFfTE1QhJsGItrj0TyIHGLFqrlvQI61aVlw==@kvack.org
X-Gm-Message-State: APuU4Z+KeVrks9KMG6ck+30wXRX9eK/iWh95VK/gJZ7xDj3H1yUE6RAt
	B0t+6jcCIRr6GVYhfNlCRAmlstHGcw5k/fLD6+o9FvVzWBd0iFGsXM4hqmJX4edxX3s+f+H09Ei
	/49vNwG4aoJKlV1mlFGRox6D+98ZFVW8=
X-Received: by 2002:a05:620a:6495:b0:93f:571b:c733 with SMTP id
 af79cd13be357-944216f2a98mr2641078985a.13.1793762550012; Tue, 03 Nov 2026
 19:22:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com> <20261103113711.1832834-3-max.kellermann@ionos.com>
In-Reply-To: <20261103113711.1832834-3-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 11:22:18 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wYYiHvDj4Bqbp_hg1H9-WsZvEBJ9h5eNdX-Kuib_f3DQ@mail.gmail.com>
X-Gm-Features: AclHuK-AvYEfhHjWxuMhWnm_a9S3p2tuGRCOJc6VKi5CiT9DNeNzN9Ic67jOPpM
Message-ID: <CAGsJ_4wYYiHvDj4Bqbp_hg1H9-WsZvEBJ9h5eNdX-Kuib_f3DQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C0C520002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3ob4p1bupa1c58zou5opjybokfytgk1b
X-HE-Tag: 1793762551-375102
X-HE-Meta: U2FsdGVkX19J9zESYN+otyqiOn4sLtU4UqzcYQouesr+8WOmjrT+npoeGdNheOod8PxBwWdenUTaue4mpWrUYhDKXdPW3nx9wbhq6eAuGQPi3zEs9PzjkLGS5PPZeJGKf3aRpg0rij1oDqp1K+JX3wglktk/0F9Q3jkjvhg7TJ45g1Tq6dF1eembpsunixHbyEKBZHmL5wcGLUADJYyNqksYNHx64oGbNT0fF0aPIAm2feCuxa9sAhb/zwctEDS95kZKxzLCryiiQQBs/ELwK0dS2bZnM4V2jpSwa1QAOklK4ca5qiP1EcTpx0vB7oZ6X7mU2CtHPIYP0vmX2Lvu0LAJYjJ5zifpBDMwQDawHq7vcYB0LWmbVeNXYNr7hSw4dOOVOLEemoYoZdkZQLullTz37f4HrYgd2AEdKSVuVl+HW9vwlfq5ZdMhPQ3IoIdb6GIEMLG36Lxhp9vxDjFaf9y62hHEUveqa3aOXLI8SjYfMMhopMw7CDiS7p2xmyAPJxfrd0M8TYFadTXHyqrPDajW/ZL0/WRsjD4JYgixjxnTsCctPVD8+FeNwTc3cxE2m/dnz2YZ7AkooeT861G1ge/CvR2fcLBdeAIeVqJ9l+QNMW4qDYfMqFBCgbbSVUGhLn7JIlVjHXl5vPkzZQlvn6ZOzHw3M1CrRUP6AwiVWdmRuuqtxcmM8wDoSY3jYsBE6Rn0fXURxIxGV/yHWIXZYcSTjqcHyj6y06ianQgIWM5+UOD+jlnZCZGOPD84d+cn8v4ye3UG+8LLYxbrBtEMnyv5FyNbgHPRM0YGVs2/muIueuHDwzSreAz3FwWnW5PVfZxnAaXUZ9qtXEEp32f4bh7txzkuNOF06pIHMCK7VxjEIdUiHyrneDP5QUa93VVuhn19/Y/Q/VdXl99Anovyu6v+rCSM8qcBQ03Dv5Yu06Ee/MzTFbG/vbV1zlwCn5xMZMV8IriREjvrv3MzL6A
 P3K5rHWe
 JHN+oM9YA5KMhfGa64SILwWuI7Qt/qlrfTnZQ5nQAv8/mT5Gq6LkKc5i85PPMKRszR9PccwN62M7BCl1eOd/+iTi0Ia8MvhdJFUzVfUGSmBV0ZqCjbaF4BeW9BXtF9lAHHYBhb3RInAr2aerry9iLzZlsw5gNnJTSDGzy9fYEVCn9bjMoHqRUBhPt5IBEErI1cBF7d22Vj3OOx1LZmt6cnEx4ce/6g/LQKVOOwM0XinrmbSoTFMksXlTcpMtaqj7QGfF4a/pU4bCU8Z0YhJjsPBRycw2Qab2YKLb9nYbcOO92LvxLdGi+GBV1clzZHLhm7IGPBiiLQ9WGXRDFxxsreWtkp2n0TYEBvjFgtJI2qOjHI2Uu9r18UpUSbkB2HFNYLQkiQjazfJHCj24MPChUYNRWtwoLjlDLygTWwVDRBKYXSin26cnWxT/rgRVpYo9lUoNvNJ8QeFNLYvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> Preparation for the following patch that adds tail caching.
>
> For simplicity, hlist_nulls_del_init_rcu() is now always used, which
> is also valid during rotation, because the entry is immediately
> reinserted under `memcg_lru.lock`.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  mm/vmscan.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..aed56d452881 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4556,6 +4556,29 @@ enum {
>         MEMCG_LRU_YOUNG,
>  };
>
> +static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
> +                             struct lru_gen_folio *lrugen,
> +                             int gen, int bin, bool at_head)
> +{
> +       struct hlist_nulls_head *head =3D &memcg_lru->fifo[gen][bin];
> +
> +       lockdep_assert_held(&memcg_lru->lock);
> +
> +       if (at_head)
> +               hlist_nulls_add_head_rcu(&lrugen->list, head);
> +       else
> +               hlist_nulls_add_tail_rcu(&lrugen->list, head);

T.J. 's patch[1] has actually removed the needs for hlist_nulls_add_head_rc=
u
and it has been in mm-new branch.

> +}
> +
> +static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
> +                             struct lru_gen_folio *lrugen,
> +                             int gen)
> +{
> +       lockdep_assert_held(&memcg_lru->lock);
> +
> +       hlist_nulls_del_init_rcu(&lrugen->list);
> +}
> +
>  static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  {
>         int seg;
> @@ -4584,12 +4607,9 @@ static void lru_gen_rotate_memcg(struct lruvec *lr=
uvec, int op)
>         WRITE_ONCE(lruvec->lrugen.seg, seg);
>         WRITE_ONCE(lruvec->lrugen.gen, new);
>
> -       hlist_nulls_del_rcu(&lruvec->lrugen.list);
> -
> -       if (op =3D=3D MEMCG_LRU_OLD)
> -               hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->me=
mcg_lru.fifo[new][bin]);
> -       else
> -               hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->me=
mcg_lru.fifo[new][bin]);
> +       lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
> +       lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin,
> +                         op =3D=3D MEMCG_LRU_OLD);

Also, MEMCG_LRU_OLD has been removed as I replied to you in v1[2]

[1]  https://lore.kernel.org/linux-mm/20261028010611.3929937-3-tjmercier@go=
ogle.com/
[2]  https://lore.kernel.org/linux-mm/CAGsJ_4zQh9HrvgaqD32_A=3DbSdqmPqP4oV_=
SxMXMEDBrHe4jjhg@mail.gmail.com/

Best,
Barry

