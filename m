Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18CFC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 19:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8879A6B007B; Thu, 23 Jul 2026 15:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839BF6B0088; Thu, 23 Jul 2026 15:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777756B008A; Thu, 23 Jul 2026 15:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50DD06B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:16:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1C1A120186
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:16:32 +0000 (UTC)
X-FDA: 85020997824.12.84F8B75
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 184F84000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:16:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KmLYeQlC;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784834191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5nDKrftDKjVFpbDlnb9u23fdFcp7Wp7gMahhMU3wz8=;
	b=ejoy3XrMxcPlg9SsSEZJD9QLi7a4pk8IWiS5bDv/CTvNtYKgXRzmyvNhmzJvAwLGuoMHoB
	MuxsI+xzwPKzkP821Vdw0iaJiNklcG/rAlG6Stok/B0IsbcKFJ5xM0lpZvI4GZ2EcHB24t
	OP0Nt2zgv5wrTaU/q7ZCIMG5zD+wAL4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KmLYeQlC;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784834191;
	b=OoiqojnNoM5+oBrndMqjTPTi47dx9pRRu+IdJCDDyeXn/v51drg230RdLi5pTn73ixtULZ
	3krU9reUAp2Konl7Anjxzfd5J53AnqFcg4srpRBPc2XSmXcW9sn66gLIHD5b5h6UE177g5
	RtZj3nNzk/me8NVCbwsVsMSFn+fLM2M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x5nDKrftDKjVFpbDlnb9u23fdFcp7Wp7gMahhMU3wz8=; b=KmLYeQlCB86DthodQOp+hSyUAG
	XQVw5+8fUjAzoAEhO9AafbsotRE/XtarK8FASdy4CEr++Oq6681/EYkL35WSQikQtOfwQ1HrYbiLG
	oywjbwATJdTk11p6uTx/mfjyaArJJHNGaXBgzqD4JjyVJCd4t3qLtnSVVLzzJSkDMxjLuAeiMeSpU
	aj3fzFNKuw/+BGcy0MO3OgSAVY5qooDEAGw3eaMuqPD9YuZwVzWc8IxlhZPUyUdVrFslLNy+BcwRU
	nc/9Cud1OdEaX6PUNJFtnTV6K57VtIWgjNwJayhnoQV/cRT1YaQwOXsz8PmaRzEMWP/KX9nq+BH+I
	jKj62ENA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmytv-00000001G6Q-3BIi;
	Thu, 23 Jul 2026 19:16:11 +0000
Date: Thu, 23 Jul 2026 20:16:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
	ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>, youngjun.park@lge.com,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 10/11] mm: install PMD swap entries on swap-out
Message-ID: <amJoe_iRHEaMdo9i@casper.infradead.org>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-11-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722152043.2273289-11-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 184F84000D
X-Rspamd-Server: rspam01
X-Stat-Signature: p1b46sh54mp4qkd7app8tb3s5n8itufd
X-HE-Tag: 1784834189-148112
X-HE-Meta: U2FsdGVkX1/QBtR/ug4ar3+NdVSiG3oygLmFfinCd0c1Gn7pTXJC1SBzmX9wPnFeFx1p4uXdMl3t8tBmVZRgvetcJv9eDHRXWNzWZo/kzrwrbdCKqJmrZQAsElPg01T3+tx6jLanM1YItYTnpvlEQsa5avZ3oZdx35MIlHfzyXDengPSzzpd1kwDP9kCWbPAFr7QlasxsH6kfWrmKChTrld2TN1tsz28/yINSgrl6Ne+kkntk4uRa98RU/WlnkA+0uzoKzOKZN/lP4kPA383x2ZkZBgzhdrSwssXZ6a6ZcGWYdeDPQimYDjOo73KF3glMWBWuH88UZFRhjv5qxKI/DPdWfpjs040FkgjgrhRI34Wd3VasF+MterEX87WDmcSjr5y/oPeu5CZ7dUOxE3FaNLmFbMqTqzIBCQ2e4/7shn6peWSdcWGrtUyXp8qIQNYeiZ63PxWLMNomIun6ffvpCuZJ0S4kpnO9UGayWvn5hoZV1Bv2IUlweoIPFbV9GyEyBtH/o4a1I1t7LqbwzvArfsbwU/2ylXnxVAabX0HUpux2yMOM17xJeqrJ5jqdUXW9XAotAvXEWWWjjGYoP/2urBanWvBLM9QlgqVbCu7r3WhhiTbuPQqudndpDLEVgB4PTqxg5ezC+cYQLgxk4N7BvlBmRrJkGsrmDTTthqQoVIOZmWQQ3mK6y5Wg+lXypRGABQcro7l3A9T7JqeSWV9g2zkqIGGGBWIaBP659gZuUUC82zAYpxodWiGkJivQxQQfIW4m48ZwkVzdAgEz92gUXHvzqDLATtl+vJ/OvTWwjZNnNV2QJPBFyO+JQLei0flvgId40LMGu25qGI/QFS81FYm222p/xd7j2u2KWiBtY/yjmoAiS8KYZCSKjztgRqXJtKx6hArctaC9Uplu/gmU/PyZgD+8MgzP+QTAzbcs+OXUG5OySyvzgammH0l7UNJR6PvHraSMQrtr+3MpZh
 XXgQsPsn
 OmFW12aeUk4ms5WRJkJrSPVnEF1z2kR/20moMu9Avyq6eI0/OZ2ltrDeXYsX8SOLYK9KpE+m6xu3oYWrARQyGHR6H5NLW/zJxkLZ6wPN3OLyFCO7+BBCdK/oJget7DEbk4PbdsM7PxhhAgGJl7DWoOHRrBGaVd8WoLj2CLkSeiavB7PgINByGWxTco1bhA+T7KSpslvWHBfk7+GcYMpaAwt98q727XmGXNeqsaYf9+vvpgmFk5plsgFcjIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 08:19:41AM -0700, Usama Arif wrote:
> +++ b/mm/rmap.c
> @@ -2282,6 +2282,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				goto walk_abort;
>  			}
>  
> +#ifdef CONFIG_THP_SWAP
> +			/*
> +			 * If the folio is in the swap cache and we're not
> +			 * asked to split, install a PMD-level swap entry.
> +			 */
> +			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
> +			    folio_test_anon(folio) &&
> +			    folio_test_swapcache(folio)) {
> +				if (set_pmd_swap_entry(&pvmw, folio))
> +					goto walk_abort;
> +
> +				add_mm_counter(mm, MM_ANONPAGES,
> +					       -HPAGE_PMD_NR);
> +				add_mm_counter(mm, MM_SWAPENTS,
> +					       HPAGE_PMD_NR);
> +				goto walk_done;
> +			}
> +#endif
> +
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>  				/*
>  				 * We temporarily have to drop the PTL and

This makes me sad.  It feels like we're bolting more complexity onto
try_to_unmap() instead of removing TTU_SPLIT_HUGE_PMD entirely.

Ideally we'd just cope with folios of whatever size (including
PMD and PUD mapped folios) and only handle hugetlb weirdness when we
absolutely have to.  Similarly, we could split PUDs to PMDs and
PMDs to PTEs when we need to, without the caller specifying
TTU_SPLIT_anything.

Is there a reason we can't do that?

