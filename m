Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A932CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA146B00E5; Fri, 29 May 2026 13:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7536A6B00E9; Fri, 29 May 2026 13:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6910A6B00F8; Fri, 29 May 2026 13:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5829A6B00E5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:34:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0855B140176
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:34:46 +0000 (UTC)
X-FDA: 84821157372.23.C26B474
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4B9B280002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:34:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dIHMmeyl;
	spf=pass (imf30.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780076084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mA/wSXvnzaFLyBu6mpFQS3mrr4Pq4o/pVqTj7FF8Rpc=;
	b=d2z3iTomR4LZ78+zABC7nK0MsUwYzwHU52SDSjsGhOEqxJZ6EyL0y3E9bOrMFZ/7V44E2R
	3ajRGGMDXeQ9BQ/wvFA3NhuinxZzAo1hF/XImiNHpiDY75untnt/j/FdT3U7gagoW6iGk3
	z7AgWqZ1/dN1xpgl0DgGzMPOwBIZufQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dIHMmeyl;
	spf=pass (imf30.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780076084; a=rsa-sha256;
	cv=none;
	b=EWr+1rtdUKdLVhOvUIvOh0nOCuRnnB3Swl1Z2RLcaP2gvIttyvhsCJJr7iLfAL7xfJVj8I
	7AAjyFW/oGt3fH7tlD8YsNi1ZZb3LxkPIOfqacwfKOHFBESUcXkVC4Zjjwp6yNtz9L+e7Z
	GP+vAKCotvsU4a0aTP1HySIYSESJZn8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EE7B44724;
	Fri, 29 May 2026 17:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F57F1F00893;
	Fri, 29 May 2026 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780076083;
	bh=mA/wSXvnzaFLyBu6mpFQS3mrr4Pq4o/pVqTj7FF8Rpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dIHMmeylOq5MWUgqcV6cJduFvFXbZ9gggbTGpRsf8yqQofigkJGwMiMHUomt8BbwX
	 UTjpQ5OsQRm1SNtpYd4AwPyP2+yqhfQCBOJUws+zh1rpj26jP1ynwGsvt3sPMQxfaL
	 BKQo2ktSt/KGxbcgj55b8dYfG3ZSo4cqdO9S5ky1LFNDvtRFt7If6nC8TIeHtnPLni
	 +S02xVS28/9xA7StPjQp55zdHH68c1/Zg/7rkYe8jPVDRBFjW8lLWjv12ZO/dDiHql
	 EFGngsjnHjcLCoFnNVIisaJhz/qWPm61r7hfpFGBjubc8iSb5Fz3bXRgvJQ/XQrfCF
	 i4LsJ2ZwSmbQw==
Date: Fri, 29 May 2026 19:34:36 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <ahnOLCyOwGV1Yp5J@localhost.localdomain>
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528075507.1821939-1-agordeev@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B9B280002
X-Stat-Signature: 6d3z3ojw77ii43ggw7b4g9eap819mmao
X-HE-Tag: 1780076084-778711
X-HE-Meta: U2FsdGVkX1/mbBcwjbhisO/muwgndiP0ezLkU2421dmPDxrfiEYpP6Aorj+h4SIhhQ5eQLXXi9+YXf+gjSWwFl5I04ZDwTIn0cfLkkVP0K0csGMzC7V5Xrpj8grSKj6bGqD4zMYJYzBvZFill8rlXh6hpHYmvoqYBSNE51kaYvTdc9/bT90c4tcceUFpfPyJ+T8CSQVLSfB1/kqELd6P+xy45hTe3TkhmFY0myNo9hxxAuqhjaVOYGWWK11moGofjr1NgwKJdZS3R3MnkGqk5JBSI0Wi5tUCBn9M1nDkfRELgVUwwTPtjFv5TalyGfw7bfRzh0vD6uR/V00HYBM/tIfyoqeFPy2DmmzasVVfMIt3nW2lJJcRgmtaKNF5jzcjusRmRfEO0fo0ae1qF/phoKXbXMWA7xKDrpogX+BoBBcDk/tIvVxhBlRZO7hYrbP5Za7APCEVKpgvCqY0nav7ROhPevcStJq1uz+k9puko5Z7ZzGowpuN4FhdUNAD40VeybqQjeHscEdpa8al4WZKzHV0YuoxbNeGt3H9qea7CQGvat8VbJPPyd4Vh+50C9IbxgiKn3+EVbOc0EVG16sXjpOGZLQbvuZwdY5MH+yYHyguYDpRS2yob2iqeeZGr7hrCU3x9O48qb1acgghRPOEwrd0n1UWo6zMVF5m2x8Dthh0tWTk3xAEQuZysRZLsX7nyfk2spD9eTVlhcrinjtU4Aiq+PNLmGv0pfHsrxzljjfFfnG3IMFOUPrUmJ7ByZODYJ1ufUZV8gkldY/mgci4xffCjv2cPMhCCbFOOaiVbh6u7mLNGbWpYXMYli+1ofVoMJCZU3GervA6VeAfAsFe3r0ZzbnQG4uvUwfQBb9KvtuG47ZxX/VFyYPzIoqWJUFotMZvAazgNZzJeFTAHKAzzpYu/1elIRwereULTNw2SxCuv0jufSo0tTAFx/nfbOa+cW9viRLronQ2WFptFYd
 5n3PuJ5z
 51LRh8BfxV+pcrI39L0dZJ0kcJfSKZ99qVAHL+o79DQG8ecI2sK5Jq2z0KT8hkwopeijYnYfEUJ9LUqMWdwmDGzbOSXE4G5Mzf2gTmqJkgUhcpzxtYxoS20DDi48eodh5cvIjK1GM2IT9+6eqOL7flutW+rvg7Mk9FQZXp154y8AhKK6LTUcfUBJyqV4nF5D/8Yokq6pIK4g8q/I1zTlG0vNL7XGep+VJSa+4frmcIo6SGWhUMmZQZofVpVlietFgXG0t7mSdCQOLbS8PCxxANnClaBlPwOeR6SH0YhAaSXhsiX6Xdalm/uRgVPglR4cJI9RdJQHH1Un4sqg6lIcyr7sJbxsUvxcB3FIsIu/f6/65iGUmV7odp50aOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:55:07AM +0200, Alexander Gordeev wrote:
> Switch from ptep_get() to ptep_get_lockless() accessor for
> PTE reads when no lock is taken.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>

I see Andrew has picked up the patch with the amended changelog, so with
that:

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

> ---
>  mm/page_vma_mapped.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..2ccbabfb2cc1 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>  	if (!pvmw->pte)
>  		return false;
>  
> -	ptent = ptep_get(pvmw->pte);
> +	ptent = ptep_get_lockless(pvmw->pte);
>  
>  	if (pte_none(ptent)) {
>  		return false;
> @@ -183,6 +183,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long end;
>  	spinlock_t *ptl;
> +	pte_t pteval;
>  	pgd_t *pgd;
>  	p4d_t *p4d;
>  	pud_t *pud;
> @@ -310,7 +311,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -		} while (pte_none(ptep_get(pvmw->pte)));
> +			if (!pvmw->ptl)
> +				pteval = ptep_get_lockless(pvmw->pte);
> +			else
> +				pteval = ptep_get(pvmw->pte);
> +		} while (pte_none(pteval));
>  
>  		if (!pvmw->ptl) {
>  			spin_lock(ptl);
> -- 
> 2.51.0
> 

-- 
Oscar Salvador
SUSE Labs

