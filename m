Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5DDC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760836B009D; Tue,  7 Jul 2026 19:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7312F6B009F; Tue,  7 Jul 2026 19:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FC36B00A0; Tue,  7 Jul 2026 19:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2056C6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:43:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DC75C396B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:43:12 +0000 (UTC)
X-FDA: 84963609024.28.98134FD
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78021160003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:43:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JgCZThLq;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783467790;
	b=MWPWtQfvlpbSIeeQNAOh7yjMPZWp7hrD7DFvc1br/26SYsx7r0StUoFgKcsCjUloYhbhoW
	CfY27ak+kF2QHcGqmgGDeVE7o9zm5nsPUqFKue5FThgXnEFP2Eb5K+xuiHh1CVVQjmTnN2
	H0ECruNUHMN0RqAUceIU1xO/d/7ySlI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JgCZThLq;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783467790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3UVaE4mni4e0wrMPZkd5SybFeneup4yLV+B30RBW2c=;
	b=JNhb2nysOcJfsyQxzGG05lc4CnWNB6ckqRlTPidWmTlhuKYarSaz1EwzUb1LDERk4LPxZ6
	2xflPVolXYgCtbIVDPBxfakuWtZ1qamusKtp9JAyl8yXqRMLtZx2fwyi2JTvRcZAAV9gMZ
	t3uAf7TR/IFCtSbxEFcmDcQUzrRnNZU=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so1814805ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 16:43:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783467789; cv=none;
        d=google.com; s=arc-20260327;
        b=P+QSXzeQWY/ZPH+eJo6HyV3x5DtGdEreaIEzrbkh0OIZNhfuAHz/BVcSqB2vXeNczO
         nqeB0bxY44TWmalsnHt3iriLaLduahgQb6uFSI8CPUJj6ezusx2tgQX21hFmiB7tbjP3
         L8sHl6vNLseBndNcC0/QW/7Q28Ktt8ZoNH2l8pREziL7UdwSv76pJXZQbFlPZ9Msr5i3
         SJh1CImsWpWrtVWz29REOL68/3NA16VvdDgdW9jF+resu8zSV5Dw1a8rfj40RiK+GURI
         KqT83CRc664jNPrT13inMiNC+EDvPfKUvikWaDNF7BdPnlX3Oxc0v/bPLg3Sv/UcAKG4
         m1VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=n3UVaE4mni4e0wrMPZkd5SybFeneup4yLV+B30RBW2c=;
        fh=cNcO1B5jZxYGe1HDR+QtfnITiG/aPAOR+h61yNQ+4Y4=;
        b=CCE++1W+AL/19300KyL0xeKwSFRpjgS16O9hoD2nv7DUY6uumbUbSJ78A3A48Jn5qH
         DIZ90Wld+cnF8oAUMwp6B/5/1ed0k/8dtOTPUFVR9Bl9eBDicrJRox324DuGpeyGQW3c
         OOE5xXEiuhl3LDQqKz6yCLWOX6JNYqRmPw88v82LhdVeAB6v4kFlc/v/Ub4Uax4RI/Af
         GKTsLLopmSXH33OgF0JCT61xrhxK3wIsIsfH+PmQb+zQDGG+2bD6P91mNpVq49jAuDwH
         GBAY8HwcR2GhgtLaubS3MifiGV/t9mB6kMStKYqayJMQvDRk3f3fdDVdHL0H5IKRlJmd
         26hQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783467789; x=1784072589; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n3UVaE4mni4e0wrMPZkd5SybFeneup4yLV+B30RBW2c=;
        b=JgCZThLqxHR1eAvBjUZQSvL0LFXovctCeR12nlBfpZ1Jm1bAcNDViGbSwDwtpfWoi9
         IqzQe1F9tIq1CviHX2DQKfJHDvLhfPkPoqdbuKBBwhAveoWrVHMa0v1YCPnreahWqvKu
         7sFKDH+0aS/YSqSfEJX8/HKhRe+Tly3OqbhtuZifTW4lZ/02SXjVY0hd+Vfl5nZMwjoe
         rNLvYgBAB7LBzMTbFAZZxeTqWRjegKVIq8dTiYAPPCdULIu928Y7yv7HH8l6SixWj1Vg
         s1CVb3HYib0B8koX5frCjcH3O64dm9LMLldgs3rB2OtFYG7KqHKrdskHerZcPlaWENNU
         498A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783467789; x=1784072589;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3UVaE4mni4e0wrMPZkd5SybFeneup4yLV+B30RBW2c=;
        b=M15DtQnjMuBY0ouEEhtu7VbqClA/TaqQhdBoi1CDbshNi3D+nRX4zJ7lqCCDq/SH+o
         ypzFLsE3OKmAEmqzYqmPvuwfpU1Z/jXzIffTGBR0otVgHqIXXcBZuiC06Ajq084WJ8fh
         Tjz7YUcthrfN8CvRogYjJDCqAaRTUiG0uiNqDFwFfGWFVtyEUBueV2UycR+PmXQq3O6i
         aYcUDl6gU/I8gsx5JzWGFJVRH3GmY5cP1xH5ckEMTvmjNMSQsbPUJygJjwEaZjSae5o5
         BDRAMi/UXQ7TWJkjS7vYJj0NHV8DbLbVTZNxDK7zOMXE2LvM1LRR9x9CtfqO7P/pE7Mw
         32Eg==
X-Forwarded-Encrypted: i=1; AHgh+RoMkX05jnWMXyvti32MSIXElhXYAM6w5N2N0TU9YeencAO/+tIH8lt7RW6Ndhs6S/M5Jby6uhxQlg==@kvack.org
X-Gm-Message-State: AOJu0YxfBQXr25Na9xrvR+wcgK2eWJ8IJ8jR3uThFq4o1pfSaUhFXZjy
	sBiknWtjjXL9KYY7TyKY+MvzMdcOO6rUvwKN079uNCcWqLiFAsxodudAwpMiRwuBR3Qy3X9yCLj
	k6CcgGq6sm0sHv0o7CvuGpWygNonfYOSugMUd1oIo
X-Gm-Gg: AfdE7ckNcYkLvmyZcVfvrQI80/nx3NismRb/r1Ij6WWOvVUCvw4unQtkEoLgztO8Ieh
	bwCAdFRNwGEy4gkqSs8bB7dtoE9hrzcFUSZ9+mPOfon2bcmuywbtgLnJFnJwdpq5s56MRJ7x9qB
	ZT1UIRW/VEHADCRUBPBXeRXbsWYRGYh1weoEv75s+FqtbxAeQaVUJDAE+Xeg87HbkHavq4T8L3j
	4JI43V37ulrrYYuGeUC0VLZbNRB4I++2Y0XaKaI/vOuVRwQi+u7yqaDq3/LUiVq8a0+ro8iqvx5
	ogiNHtZsafJEU5ryy4rbIWKkZ/aLVkMFr0UCKYNDzvh6dewD2KXzL0noUhg=
X-Received: by 2002:a05:6a21:4613:b0:3c0:9c19:65ba with SMTP id
 adf61e73a8af0-3c09c19685cmr5335865637.66.1783467788850; Tue, 07 Jul 2026
 16:43:08 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 16:43:08 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 16:43:08 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260707-hugetlb-alloc-failure-fixes-v1-1-5bbd3a4b836d@google.com>
References: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
 <20260707-hugetlb-alloc-failure-fixes-v1-1-5bbd3a4b836d@google.com>
MIME-Version: 1.0
Date: Tue, 7 Jul 2026 16:43:08 -0700
X-Gm-Features: AVVi8Cdkxy_uLHBGKMtikCwJBqC5wFlF7LuzWe_xURHjVnwiHZs7EJgvhqSZovk
Message-ID: <CAEvNRgEz5tRNi6xYcVv-wK-q4pecpZZa1q+1sUiEk6dnVjYjmw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: hugetlb: Fix subpool usage leak on allocation failure
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 78021160003
X-Rspam-User: 
X-Stat-Signature: pen18u3eoejhh5opcz43xzdnfd6zkok3
X-Rspamd-Server: rspam03
X-HE-Tag: 1783467790-393765
X-HE-Meta: U2FsdGVkX18gTlnam7FmldKMUKHry4E5YayPUGsNSmPqxf9cu69N8Ct4mmgCBGDThrfSNpqQXInE3XAErmJq6SasFkaup5eQMkk1LGkvSb2hUshehsPqNuX9wco6im/+2ikrtIRtKHvtl52CrEIDVzka+bNYsK2WDz3bLccEZIRWENHO9Pm+9lhJcrKWHDCTQ0aczabzv/0MGrlHwqkzf7auF+8wiBmbHIyU3Awnu91KjOzvJbwzZbCNDobmzQVUAsMSuOEZZh3FFhy4d9K/lxXWDJ6IDoS+7giVYMqfNPMS5w/HZTNmXfisB+eVN8n0vFsgmQAXBahnvlxnEZHhZD5w34yjs1B3u9tF4P2rEKRkrpVrt1wdzpgjn8CEhkzvhVfWcuUUcnWjkMiQgMWyWEQNoE4aY3s5EZZ06IKoib08B95X0e648jbqOb0IDSNtX3LiuiYZfYMFcxj/CA4hIRBi5B1Hh9+LavSkr7axe7PskjMfDEYkMBp+tXzGYWkvP4DRG0UWymyZghmfDlU/3jnjAawR8rc8uCzuMVksu74E21rZpqRz8czpqRyFhGvcfYlG6KKGFNMlahtaOLT5Ou3K2CXZaHSnoz03eLxa9wr5InmaV0p5Bspg1tDhDq58WIBR9W7mP6nLZPDK5+2HMx/GJgEjmxbQMGO0is+oOEfhcOS9Fxj7nXMBtL5727efZckMRGNvZLDcwhvgD4pXgoZs8wbafy5s1W8dRCoaB1c8OsIbWHdpDuXvZp51hLDQ6nanoqFZOp2Lxhy6zBAr+Ej0XHwALArFc2EgM+ZGY+0OeI45fuKNrJRX3zZmylt//obpeCc+dYLKLqm2c5KQxof/34yhv1i/+gk/4tx8RQODM66QiMJUtoGdWni/R7v+RLK/hyjUxwox6akahc2piRPF4imgtGhz1OTBFXxriGUYM3qUXS7wLFi0HCER7M91FMPcklRcPcl3PHG7TF+
 tFjV4PPa
 CnPLlZqzMMVvpn+OAZeqaisoYbm3r9Qoh4K1v4hWNUqzvtv+58O75czyrLfrspuAPz0j/QM7S/AqJbKfetydRtUEp6a3WN5iwwY9Vr1BSQmg4Orb1gavsTrKyCipd+aAhx2bAK++RCdYZwvqwm7izzyvzUAFM9hKuLUP8wKt21fUXsVM6DHsNZrtAXmdsiQhNoG+aUpH0E5uQx4v6m80hrH3sBsotY905SJ2IIxLja8Ho1oI7TGZ6/dt1MaTsQ5wY4YHrSSJmKF3Lezss5wHhwcGK7Yq9GQL3XdRTWEyVWf164Dfqf5lud09PK1TkaQ7eq+6BKjrcbWUNNYoY3ybAsRcA3b51o8GNp4EqlUyR5uYbD3vvY3LAc9d36zgtyeqsZdre/iWjlrx6O/6FuggC0vDPUdTJ25WU4ki4RV6FtGHwaJqkxlYiNYw0Mxu1kW5LA0rGfEnd2ZTLug3qy8yFMXgTXl2TRQiVjNH8VrgypqZMs1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
> hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
> was not used, but a global page was allocated instead), the subpool page
> acquired via hugepage_subpool_get_pages() must still be returned.
>
> Currently, the error path out_subpool_put: only calls
> hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
> skips it, permanently leaking the subpool's used_hpages counter.
>
> Fix this by calling hugepage_subpool_put_pages() unconditionally if
> map_chg is true. Only call hugetlb_acct_memory() to adjust global
> reservations if !gbl_chg is true, to prevent underflowing the global
> resv_huge_pages counter.
>
> Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")

My bad. This isn't the right fix, I'm kind of re-introducing the bug
that a833a693a490e tried to fix. Let me think about a better fix.


This is what Sashiko had to say:

Can this unconditional call to hugepage_subpool_put_pages() lead to
resv_huge_pages underflowing?

If a hugetlbfs mount is configured with a minimum size but no maximum size
(so max_hpages == -1), spool->used_hpages remains 0. When the subpool's
reserve is exhausted, the next allocation will use a global page
(gbl_chg == 1).

If that allocation fails later in alloc_hugetlb_folio() (for example, hitting
a cgroup limit), we now reach this error path and call
hugepage_subpool_put_pages(spool, 1).

Because spool->used_hpages < spool->min_hpages, hugepage_subpool_put_pages()
will increment spool->rsv_hpages. However, because gbl_chg == 1, we skip
calling hugetlb_acct_memory().

This appears to leave the new subpool reservation without backing from the
global counter. When the successfully allocated pages are eventually freed,
won't resv_huge_pages be decremented out of balance, eventually underflowing
to ULONG_MAX and causing gather_surplus_pages() to exhaust system memory?

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/hugetlb.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835e..e607dcbb2fc3e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2858,7 +2858,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	struct hugepage_subpool *spool = subpool_vma(vma);
>  	struct hstate *h = hstate_vma(vma);
>  	struct folio *folio;
> -	long retval, gbl_chg, gbl_reserve;
> +	long retval, gbl_chg;
>  	map_chg_state map_chg;
>  	int ret, idx;
>  	struct hugetlb_cgroup *h_cg = NULL;
> @@ -3009,13 +3009,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
>  						    h_cg_rsvd);
>  out_subpool_put:
> -	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {
> +		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> +
> +		if (!gbl_chg)
> +			hugetlb_acct_memory(h, -gbl_reserve);
>  	}
>
>
>
> --
> 2.55.0.795.g602f6c329a-goog

