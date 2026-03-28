Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A60710F3DF3
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6A46B008C; Sat, 28 Mar 2026 15:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D8B6B0095; Sat, 28 Mar 2026 15:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C939F6B0096; Sat, 28 Mar 2026 15:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB9016B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:15:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 54904E02E0
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:15:04 +0000 (UTC)
X-FDA: 84596424528.19.558D593
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A2D640008
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:15:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BT71pfxZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774725302; a=rsa-sha256;
	cv=pass;
	b=4Gvq4LbsvHPAKPlmOXyU9rqXip4Fn2EO2UD6J7PZGJlFNuIrxw1rN2voFzJJ56yM0Zd29c
	yYX7aPsx58AHynNn6S8FTUfBE9XRUb0rOXh4FLlv3hUvxZ1e5GJX7M38NAFwzFq6oGKprL
	u1C1ESXVbtk3Bc1+3ZM4cICBTfCcto0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BT71pfxZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774725302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+sk8WRKvQbmoH5rT9yfaKyI+WvTZYoSy8ctBX2ZCl4=;
	b=Sn67ny7de+srkvqBwyDzkDkZdOJGIHBHHyAQWntPL8tX+isK3yp98GdueimEO57W/5x+b3
	e3mWzHXLG+Iy4yp6M6Wr9j5sjt4nxYz3+pgAZne9wDK84ZP5YAYJ54gdGCUzy2ntVDgxwM
	ly6vavioKrY6346KXeGBjM/Bd3fyOJU=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509062d829dso437391cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:15:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774725301; cv=none;
        d=google.com; s=arc-20240605;
        b=eBkJT7K+yjflrj8kbQN5ovA2qPHPE1UR5SJ5Iam7hnIzCETBICmAj+RLZH9hm9oBBy
         +yaYj3O+gmX84AqgDkNaQ7cqsD6wdF2I62QvghUJcilNqCfUYLyIPDp3hADrwM8wkf44
         gj8d40A2xNi/+r/n5+8WdQAmeu7viwO110ZcX1CRZBjjBOPFQVjezxlpayjxihh8PFD9
         2mUIS4HKGusvu8QQLt7KX/YM2NaXClWZCS6CsPiIIM1Q7JipWjaGxD9O3SIiaXfWzCTw
         VXhnTlrKZaarrrlEanedsZkrZ+InNovjcMjbyresoXPfkdc707NCR6E9iYyM2JFC73bs
         4fBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r+sk8WRKvQbmoH5rT9yfaKyI+WvTZYoSy8ctBX2ZCl4=;
        fh=+lZBl6mk8YFTL8l6jJ/ltBrQe1XpWgq3wMpRWIVLwkU=;
        b=OBeog7euu7CDFDdEKYp8AjKHgtXY7M6EHvFb2L5tYDdK0vFHT3rTtdyToqzy1VUT1D
         glYHYESRn0UWc7G7c2x8TS64JYvw1B9leRua1/ANRBFU5UdDhQaNb4r4sxys4waDEUaV
         4OFHHzfUuBhA5TWMTqASQIXDBF2kZMLXicgoz3MLSFSbjC+yCMcXnwziV4LocZd/RIQr
         D0/V4yy+BwrCpYy16FJlTW57UV0VE1HycCUfxKuhuOsELRYL3AcId89wEzVBBqKkEDOu
         ycKvzXmAWsEjv8wPpO9pkAodnZjGO4LmDdXe3SuexYGbTDXoWJmIxwnf5MvdFQdQmiFS
         p21w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774725301; x=1775330101; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+sk8WRKvQbmoH5rT9yfaKyI+WvTZYoSy8ctBX2ZCl4=;
        b=BT71pfxZ5UhIncosZ6hEBNae9MaNRzQ8mQ3EUeRM+2EsS3jrqs3bv8pJFT4RS9EtHn
         weeivsP9UlVKc0Z2HA2FQdIZ26U79vUunVlOfD3T6qTqq32/l3zaspNlq0DN/qds4HPZ
         876PZ6GG1Ij+rVFQPZlFBV3zsujICPgqfwDTxhZ9lz84ca9jv+1Ej/XzJNJqi9fOxcEI
         Tk5MTL4cgGG2lZAySPS262mE+1ee3GcORLLLl5J6ekFzMUh0AMk9dSPyNTaoszkApkOu
         vsEdg3sa8v2gDIoFK68ZF3ZZ19rFZyJl4xRGlQnzF4D29Ai02d3RlzMbCdt6Lhr/1XET
         gpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774725301; x=1775330101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+sk8WRKvQbmoH5rT9yfaKyI+WvTZYoSy8ctBX2ZCl4=;
        b=SWwokXtKnb4N92K6MhN4/0/rDx4fhucnGHBDbmF6j8YfWWBMt0wBVEw3H2AbgDI3jy
         E5+20DAw3J37yYoBLwkFDc51xlsH1KLoCryi2Dn6gYnHX3fm6QhXCedrWjR0tP9kINnh
         u+Ef+3XP8I3BpJWUxRAETc+GhFos6/g/X1WkQK+hmapiyaPbtwHouyuDHwQ5NxdS5LSE
         3FL0A3tYUrlm7fGjUSw96PrEVsrro/vobuwct+ZZvG8z+aB28ilWiQF96bvM6yDOqof6
         C8Q2cvJ69Pou4VO190o9o0fZ4+bMUtCiRtXstRsx5EjLaKJQEygj4XaTHZlKN7r/K38p
         LvwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAzeTIE+Lpyk9mI/DVmjInsSVVP21nzOBwSkxhsSLJsSlEhv17pn9iTX3TTNEe528upck/Vig+rg==@kvack.org
X-Gm-Message-State: AOJu0YywuulwAQaJPdRTVWIk3pPnJ5YwgGzX9YFzkAH7lo0nNHl6E/mb
	+oqoPoiyZR6XJYNF0eES/VBhET5td4YeS+GTrlyO/kYyAgsjM8GGR8FepluwFQj3ED32Adi0BzS
	zY4hjk2EbMRgA7ixGer7ZFn2hVTnUFCRvFe7nUhF3
X-Gm-Gg: ATEYQzyQGOboV3/082teGDwXdyLgZl9Ajf4t7ZhvCw6Ap0BZ8KROF2A+lqfiNhW32nh
	edD6I5owy7z0n9F7gv210docKM8eXrXmtz2V1/EX9UgI9stNdOi8bJSHomt+5YsETqnjCLAhu5i
	7ZW33y7JOZcXArwTYQ6I92QrJgsqWtNHmU2w2OdS5FkDV1/xjVTu3AzqgoZfNz1nIKbMCWAQf+o
	OW9Nd/sG4F/sgeBJnYIoAY9izl3x0BevUJZzKmIdhzJmTMWKaz/z25cmy2ifNQvxatHP6t8wMsO
	nzWcnHL9tEuy7CuW
X-Received: by 2002:a05:622a:514e:b0:509:2cd4:b705 with SMTP id
 d75a77b69052e-50bb2642158mr11485211cf.4.1774725300596; Sat, 28 Mar 2026
 12:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <71f576a1fbcd27a86322d12caa937bcdacf75407.1774029655.git.ljs@kernel.org>
In-Reply-To: <71f576a1fbcd27a86322d12caa937bcdacf75407.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:14:49 -0700
X-Gm-Features: AQROBzDtZS7kaqeCpwSHbYohE5Qy3ea4N22JQUi_2SOrTMxf5l80cHLw0a-7lkQ
Message-ID: <CAJuCfpFZ6Uy01tH1rPgXxv7RcvgFVrCF5L7ap0H8ZgP9n4LhQw@mail.gmail.com>
Subject: Re: [PATCH v3 07/13] mm/huge_memory: deduplicate zap deposited table call
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 88xrpy1kd73mjwn315triim1aoe7zzzw
X-Rspamd-Queue-Id: 3A2D640008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774725302-958655
X-HE-Meta: U2FsdGVkX18djQSq7OEO3Ft9QsluuJt5iY/FVpYQ7CFQAI8II60P2n+cg5vJ3Ig1RvncGN5OMV+hJ+kQYbs1CKtvI4IzF45ac0ttmSmn183lbGo7nB5Yo1GZPkPbPIPzrkkxI11w+d3/bKZXigc2JBzATrBFjybGTMYyvDp6KZ8oHeCyx0ymfHoOlyjM9exSE4KyoRbQosN0H7/1a1maGxRG2N1Ihiw5C1U8uU/QT5EICTEpAsxRW9IdBnt16ZeekdlxQV40mVJl+t2gyGWA3P5h2C7ZRVMCC8GqU6JGVHX+nY6I/gBrz5dELJE7eNVUbz1DgIp1B6b6QHdijxr+d8OlG7R6ahzT4S6aUHDpzIZ3J+3W1DUSOlx7eMCJ3Klr2igZMUygKxzuOtlXBFXj8iftwZBpv6usVSO1QO3TkBrKIF1T9izFbUTEJUQ9np0ZGwDEhSIvBvrbZDH25wPysyQXTQ1pJVO8zh0DszFX9LQv0Gh4xn8ZwW/WdloSS4XVVgnGEDASOpJscpcjvRifh2As4rcoV7pA9Nq7r2eSACH9kmemK0mQ+UATYcUL5/zYnsCZV13zyRXh8r62QdCJGOHc3BwGddSf4GYhbS61I4dyx/OWAej56GBmXmrwNGgZj2V1MGM2X+S4gEIG11A+Uwt5xqSChaoVqhJ0RsSTzS7N3JH5vfq+LuESuBmC/S2zFqLht6ItBgkG+RtI+xm7j1dfEWaWPaKPbRtXgTTbjqFvljqeLSz3lQ3xHpXGChTn+c9ISZ8efh4PSzCWesRooEQbUSw8HNomUlZTIEvXz8zcBMGIGfKfTEjrXIEzpihV5jmO7VjhZ3sGODMYkMSiVLTJJFoWlnaauNoDvHDw74RlqrtIgvicxhqgzgi+CxYToWqQdBkSaxXp+ieQu0u4qxtnjBVH/bK3XAt4lFWp82lLTu9PkGs7egbUIkB/p78fx/KbK9Pw7Q6qUF2psae
 RgD756ms
 UB8Z2o6OCxWb0yiKWn2/T5cWYe+7YcgRa20BmfpMw1Py+2Oe0D6DrCXZGHpdheKBint5N5ebN9o1xCNgCDoEPXgK6ebd5vY/Jt0KxhKsexnytx4mKxqzy6snxE5uBqM+saP8a0vVGBrcb2herADUQ0m3d0y4RFLb87koaH6asFl1N24bkQuDuvmuYVGUdXolbD4Kjs7r7HWptA1HcVGKonm3UL3mlX2zddMIZe82ZdQH9xmdvzIFWtWRhFRS5HURtxl/1B5sMaTvLwIJPt6n6silwYz2IYE40E5suRUnctqVjq1UqaDDbvw/57nWUOmA7WGu3EH+ehjcwXHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> Rather than having separate logic for each case determining whether to za=
p
> the deposited table, simply track this via a boolean.
>
> We default this to whether the architecture requires it, and update it as
> required elsewhere.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/huge_memory.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4add863cd18f..fca44aec6022 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2337,6 +2337,7 @@ static inline void zap_deposited_table(struct mm_st=
ruct *mm, pmd_t *pmd)
>  bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>                  pmd_t *pmd, unsigned long addr)
>  {
> +       bool has_deposit =3D arch_needs_pgtable_deposit();
>         struct folio *folio =3D NULL;
>         bool flush_needed =3D false;
>         spinlock_t *ptl;
> @@ -2357,23 +2358,19 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>                                                 tlb->fullmm);
>         arch_check_zapped_pmd(vma, orig_pmd);
>         tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> -       if (vma_is_special_huge(vma)) {
> -               if (arch_needs_pgtable_deposit())
> -                       zap_deposited_table(tlb->mm, pmd);
> +       if (vma_is_special_huge(vma))
>                 goto out;
> -       }
>         if (is_huge_zero_pmd(orig_pmd)) {
> -               if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
> -                       zap_deposited_table(tlb->mm, pmd);
> +               if (!vma_is_dax(vma))
> +                       has_deposit =3D true;
>                 goto out;
>         }
>
>         if (pmd_present(orig_pmd)) {
> -               struct page *page =3D pmd_page(orig_pmd);
> +               folio =3D pmd_folio(orig_pmd);
>
>                 flush_needed =3D true;
> -               folio =3D page_folio(page);
> -               folio_remove_rmap_pmd(folio, page, vma);
> +               folio_remove_rmap_pmd(folio, &folio->page, vma);
>                 WARN_ON_ONCE(folio_mapcount(folio) < 0);
>         } else if (pmd_is_valid_softleaf(orig_pmd)) {
>                 const softleaf_t entry =3D softleaf_from_pmd(orig_pmd);
> @@ -2388,11 +2385,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct v=
m_area_struct *vma,
>         }
>
>         if (folio_test_anon(folio)) {
> -               zap_deposited_table(tlb->mm, pmd);
> +               has_deposit =3D true;
>                 add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
>         } else {
> -               if (arch_needs_pgtable_deposit())
> -                       zap_deposited_table(tlb->mm, pmd);
>                 add_mm_counter(tlb->mm, mm_counter_file(folio),
>                                -HPAGE_PMD_NR);
>
> @@ -2412,6 +2407,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>         }
>
>  out:
> +       if (has_deposit)
> +               zap_deposited_table(tlb->mm, pmd);
> +
>         spin_unlock(ptl);
>         if (flush_needed)
>                 tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> --
> 2.53.0
>

