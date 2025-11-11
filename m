Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB8CCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548FD8E0007; Tue, 11 Nov 2025 02:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8CB8E0002; Tue, 11 Nov 2025 02:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F4F8E0007; Tue, 11 Nov 2025 02:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D92B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:54:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB33812CE33
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:54:00 +0000 (UTC)
X-FDA: 84097562640.28.BD12EAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 148EA180010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:53:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762847639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nWRqTGneQN0CeRifWND5UyhaViKn9PRsnWUbMNqFe6k=;
	b=zzZ2WZ4hYGVBGkcZWHuJZq6F/V/cWZtoIGe9K7eVQvNUktcZVYhn3qm8CbnGRIbT9+C/Ho
	k7ZXS7Wt813JvDUZiyoo9jdLYqSch2DRNV0oGyX7pxhbIQ3+ZuF+Cm/ylMHQETOg4TZpnm
	asbzhdZZcPsl/EDqutAMYnOV8vuwDk4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762847639; a=rsa-sha256;
	cv=none;
	b=6uCWCmE0vJW4RpCh3V3WSCg1pJuUb49lrqbTiC1iWxyq5qLoOAHgwwRLyWlqeGMHBg7tOq
	3Xtx1tcTEL/ab6wVLTheHUx1JiFUbBDy/d89Bh8oFozDCQ1hDxOb+VDuxB1PRC9L5pHzqT
	jKfUG1Nnf294lpz6l3KeZ3ft3nE72iE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 979562B;
	Mon, 10 Nov 2025 23:53:50 -0800 (PST)
Received: from [10.163.74.35] (unknown [10.163.74.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF90F3F63F;
	Mon, 10 Nov 2025 23:53:56 -0800 (PST)
Message-ID: <4f7a1501-b10a-4047-8823-a31a68813424@arm.com>
Date: Tue, 11 Nov 2025 13:23:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/7] pgtable: Remove uses of page->lru
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
Cc: Vishal Moola <vishal.moola@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-5-willy@infradead.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251020001652.2116669-5-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 148EA180010
X-Stat-Signature: mir1eecy4nt4md8j3bixt1gxqbabr81r
X-Rspam-User: 
X-HE-Tag: 1762847638-792784
X-HE-Meta: U2FsdGVkX19/SYj01fbEjGVgHT9rt3EpK7T+YOuDdJcXgWvhZsSyn5+1OWn/g64GFTT4tHrmq1oeLYn3JUHwAJS1yBVeaFM/1rLoxqdA9CzzJ3DG2IlNFm11Hwup6xwVjv+5Upru+xI0LTwasOAYknINONjI1M3lskxO/txR5e+3cFxyMNHt+QRN0AiZtbufA073tnC2mgElv/xz8QnkUj55A12mlJZP1xeH6eIzD1sM2wk43fPLJM3I8uaI6DYMyV7V1ixU3oBqBknJY4PwUdK9Hh/7TeWnOTa9yMgH6+K7DGEhe2Np1F8Y5Z+DBERQV0WOlqTSHQKFSd/G+lwxtZdvxsYVYMFDf2TKrFL4EoE2ulD3ch3NF1LgkRbiK9FwgWSy78ZgYJFPFdvRMpu5TaGb81ZUBa8w5TC0LUzcxVRhMu0AOWZV9S6lSQQFpmzO//00fNzDRW0bGpAKuX0ShGsYlv4MlTbO/byqgF1JpQw7IuT+RR00Y7iCKndM/BeLapqIpCZvriDrHTV68Jf/IA2T9RkYrfAXkFT60FWrNODtrwzzaMem6v+wAzxGA2mc7iSQLzMCreKGVFmUnFK4CaFWvt9n1kUA51tmotTDy1R/Hn43xhq9AmLm0IjeSL6pzskLc7MYIggnFlmCrm48Jde6S80w/m3cFjLNrvhAPtRkoFpQULbwdJM9fi72KeTVoLwEK/EvI3e4w3hLXYw+hFsS5qMk5Izi8wMaO4VfTXMlKzaLXxmfsZT4QfYpAc40Pwzjz6GXtsUV5oSOom+Gur4oARu2F24BVBk9LSVwZvYpIUWNytTKtLynOSnCQTGHA+h0+edlyhUHaS49bLqLbMzTy0v5q5P9tDChPW24prXS4nJYiIGMmym85wKfF4pqJetM6DiQpc2TnUPk2OVe8GBAylAHl11XZjOzugDO9UDBGGDjvQvaxfsp5m3UrzAaVUiTG02j7FZnUY4yXN5
 /sUjz2Gl
 KGhWLd6rCo6e0+zTC5FFkIyr+gPQqMsB0pNUENgvmWHgj0trE3NJ0H+DfrpprTsSYfhRE9FIw0q27ZUTek1EQYkqc5ks/U5jduS2V6QC3rCt7LArOFdqYX8uCg62Q/z85T9BzumSmuCLunfySmqze1CpL4/PEh49KsqDtsIz7lDOPMUEw6AACQ+mfMs/UaDyqQRuJoyP0RD/zqYuuOe8GvjfVloMCgj4Zh5qd/5YMQ5NoaXvRYxIiajuB1djC+Qrsz6Di+flsB7REvvbxq7ZQxOfA2b5oua91q4a9+EesfwZqCSqKJEgGfRLyTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/10/25 5:46 AM, Matthew Wilcox (Oracle) wrote:
> Use ptdesc->pt_list instead of page->lru.  These are the same bits for
> now, but will be different when ptdesc is allocated separately.

Just wondering - should a corresponding TABLE_MATCH() be added untill
those above bits in page and ptdesc remain same.

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -584,6 +584,7 @@ struct ptdesc {
        static_assert(offsetof(struct page, pg) == offsetof(struct ptdesc, pt))
 TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_head, pt_list);
+TABLE_MATCH(lru, pt_list);
 TABLE_MATCH(compound_head, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
 TABLE_MATCH(__folio_index, pt_index);
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/pgtable-generic.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..f40bab9e6c46 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -164,13 +164,14 @@ pud_t pudp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
>  void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>  				pgtable_t pgtable)
>  {
> +	struct ptdesc *ptdesc = page_ptdesc(pgtable);
>  	assert_spin_locked(pmd_lockptr(mm, pmdp));
>  
>  	/* FIFO */
>  	if (!pmd_huge_pte(mm, pmdp))
> -		INIT_LIST_HEAD(&pgtable->lru);
> +		INIT_LIST_HEAD(&ptdesc->pt_list);
>  	else
> -		list_add(&pgtable->lru, &pmd_huge_pte(mm, pmdp)->lru);
> +		list_add(&ptdesc->pt_list, &page_ptdesc(pmd_huge_pte(mm, pmdp))->pt_list);
>  	pmd_huge_pte(mm, pmdp) = pgtable;
>  }
>  #endif
> @@ -179,17 +180,22 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>  /* no "address" argument so destroys page coloring of some arch */
>  pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
>  {
> -	pgtable_t pgtable;
> +	struct ptdesc *ptdesc, *next;
> +	struct page *page;
>  
>  	assert_spin_locked(pmd_lockptr(mm, pmdp));
>  
>  	/* FIFO */
> -	pgtable = pmd_huge_pte(mm, pmdp);
> -	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->lru,
> -							  struct page, lru);
> -	if (pmd_huge_pte(mm, pmdp))
> -		list_del(&pgtable->lru);
> -	return pgtable;
> +	page = pmd_huge_pte(mm, pmdp);
> +	ptdesc = page_ptdesc(page);
> +	next = list_first_entry_or_null(&ptdesc->pt_list, struct ptdesc, pt_list);
> +	if (next) {
> +		pmd_huge_pte(mm, pmdp) = ptdesc_page(next);
> +		list_del(&ptdesc->pt_list);
> +	} else {
> +		pmd_huge_pte(mm, pmdp) = NULL;
> +	}
> +	return page;
>  }
>  #endif
>

Otherwise LGTM.

