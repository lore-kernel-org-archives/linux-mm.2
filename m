Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782DEC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7006B0107; Tue, 14 Jul 2026 11:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8884D6B0109; Tue, 14 Jul 2026 11:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728EC6B010A; Tue, 14 Jul 2026 11:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40F6A6B0107
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:16:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9F021C03FA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:16:24 +0000 (UTC)
X-FDA: 84987733488.24.600663F
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id E613B180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:16:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ULJqt+qf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042182;
	b=RjIdWI/gu+jiVfgB59H2LlLO7I5lsMzp37ADhhC+HArAwFJOgteUaxmHBNqhBRc7vvivrD
	30kuCKHvo3hna+iZ4imYlZGo/YGTybYCk5KwG6rCktUMQIPfEAPEIzOdvSyDKwN4hNBlS6
	z8jg06w8BTah5T2vhWifpKsza84cZzM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ULJqt+qf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwuFYnIFntaeyFiFTCtuOmdD45sxN5bbxj7Gff2yTa4=;
	b=XPaT1NA5LIgImaOQhtRGJ9xsB1/nz9/J9T0XtJ6SHA5VB8fK9UtL8aaFjQGhyceN4qTW7v
	e1zdqNqoGNkPuM8RNUB3W2aNz9CSyeWl57NnVuiogls/TOH/8hRyFRKytDs97SW6v0CU8y
	frqaqyTJPRdyBzLlZsJ6lYSsIm/H36M=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-37e0a189b0bso997627a91.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784042182; x=1784646982; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fwuFYnIFntaeyFiFTCtuOmdD45sxN5bbxj7Gff2yTa4=;
        b=ULJqt+qfAGzQfg83r0kQd6bz0iRNkvPUtjmJl6uRZhOHEVdKG/VmXg/Q9Jmbo0W2UF
         4U09k56IXzDGavjJ398Tm8ZIsa0mNidFE9Zx0uYUzsyxncgEXtxwXvNRU1RAjDphpG33
         HRo0j/QcX42vCJH8Ep9PBPQdNLd7/tvM/lxjYVlmDDkajCVQ8E3/v7n+I9eyIp1vVN1H
         hjgYpbFzShxRf5m78gNEGw+80E3MtreQzcbd+tPsoHs9y7kdDWT+w84vu0bWCbcbkUvp
         831eYDs6F19/clq9msblm3OJpvIvewmApaF0onSm4Coqv8myldsT+tQVvQy7xACyVUbO
         XckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042182; x=1784646982;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fwuFYnIFntaeyFiFTCtuOmdD45sxN5bbxj7Gff2yTa4=;
        b=s4r5DfZy7rjf4KbI63QweItAoWCWD+I59qWknGHDmUjIZp+Obd9l9UzDSUnkcJPd5e
         U7EWGE6f6jgp9UWjLqUxhVXNbA26IIZlnKMJolrZlS3HOEYveTRiIAj2PdBqWaCW1ybz
         g0wf9gp7ptMN9W6l5Ui1KDaZVWtNy2vrlTJTiPOgB6P2I+WiyChlDkdLb4C61yYdG4sr
         To0sRbhCuAuK6k1+2bIdJ9caVXT7/+4JNHbwLypJv5X2w8cX4XNgp7CG0NZSo9gw8TeZ
         l69xeY8QFYZczOEae8IkxOI5zPLShUmWNjjge+rXNeEywvcRRHMn5TpFw+ZfrWeZQom0
         BUcg==
X-Gm-Message-State: AOJu0YwGhUad/ZmWC2R1ki6WIyhMBLYURS5bwYJpTrfurevdsQiO3uDN
	QjFf1jB32E/YgOY1CqShpMfoQc4CSLx3q0tjY0KHM18mU0iHs2Bowh1T
X-Gm-Gg: AfdE7clbdbXVCD8pydO3Wq7phEZiyYugodQ/aWNG0KEDiaIyESaeBuDTyFzuYrgg+Im
	rZoG2zy85jazAENwFEwlzk4bZLazz4ZUvTWL/lG3Zl+/VpTpEDXc5KBlRC6dA3dKyJ+eBi/UETT
	PkjYq6yqhuJ3G/0TTa1lLFzIsmdpOX4aTtqVE7EJM+9Dm+V4himfLafg3n0S/BM/i+bni4piOdm
	y+bgu3ftPIt3KXRcafccdIG+xgoYmTm+GV4sm96lp+kpFOH/FP6ylR2YWWXQecaiyPEwyCQBSOB
	PXfGsYPUntG7CRGIuJeQjYVPbMymIbMZe2wFHy1JgefOP2pX1FZRz+XpKNmDLGOyOOZpnbbTjHY
	YSxFko7GTZKc92idR4/S5S91Ufrdsof97KA74vn66kblKx3wINvWilJyLW3cmGMCb0i1/hGFExX
	GhWR6sRbCtk77zdQemsLkerPNZSxi/dqGENY/PkCztYf4L
X-Received: by 2002:a17:90b:2e8f:b0:380:8b14:d8e1 with SMTP id 98e67ed59e1d1-38dc7b3f8ccmr13234040a91.24.1784042181685;
        Tue, 14 Jul 2026 08:16:21 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313b4b97661sm49794403eec.7.2026.07.14.08.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 08:16:20 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:16:16 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ning Sun <ning.sun@intel.com>, x86@kernel.org,
	tboot-devel@lists.sourceforge.net, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 14/22] mm: set page table page type when allocated
Message-ID: <alZSwAM4pwmMOeaD@fedora>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com>
X-Rspamd-Queue-Id: E613B180003
X-Rspam-User: 
X-Stat-Signature: 7n3m1hea7fx43m155hw195rcchdk5dei
X-Rspamd-Server: rspam03
X-HE-Tag: 1784042182-721992
X-HE-Meta: U2FsdGVkX1+Isi6/Y9u6Ms5mBIGamyevt/EIZrvB+Ey7mPZ7/5tI+71UOM4pdJDA3OZZwJUz7am4N8mWfhNhy61czE0oU0iKr96ehqEXtEAtTFHf2gPicb0xqzTC2CW0hYNSixBtXR/hDfvJJKkFcb9Ea6HEOYVfw8V1Hzzu1ZPro2LeilToI68JFvWaWodbCIhjIFay+bvnGY4i7TdeiwN1pk8hGou/vS+VjZw79W/U3MsWw6bZU5tbouJs/kDou7qR2jeEMbpWhpcf3bt2ttcIobehzI8tCS5q46ox/zgcmPsTMJlvMdO47XBbDndWLN7sH5Jcb0SsW6xxfoI1BoaJDIZ5VsTTk9OiA+tXniCb2oSel9rJ4DUvRd+upPwNFr0ZKTZpdGIJ5zPKjdJsZkLObGaXjvwyFWzW1hvDnxRM0gmlMw0oy0Ngcej88G54dDCnIkVey4ycTeFNC7KmpFHitKzNJ0XF7AiDsPgFtMATBIJXNemk32FAfV93xfMctISRtfuhi+sgXn3UzLjvmfU3YXdHE9RLOp293aCGUU8JCZ/EIaEEqfanYo5+FeVNzquDDaALKpswNfOQRE82yiqv/YBqiymTIBf44j/96olySuZcYbT9/wsGbPP6mFAJYZysjasLf6C1V9b/lbLJrMt9cempAYXZBHn6Hm46W9LrDsnrZGPSkPwGmlnM4EMDF7AFw+k/jloGDHhIc65BKY841VRKNKbn30U03IDlyYaonaIBA03DSZ+OMLxriHPb2HlFGKXRohQ5Qg994UzlexMKvLS9ao+/ViNzrbxPtxXklg6sOJmxtFHWKBva68JjJulqZ/v4Ztgu7L/Guhcv+7irS3o/2/I6TUFtq9Z+aULZuk4VdzwYcUHpeNRax6qawLiJbn58RgyZRt3e1SnZo9dzJpzySDFD8IKbPgDLBpLz7dHenmQ8dHuUjqOoBmHsw9M4PGkZ0pmg2CT7qhF
 3+0UsWtF
 4gOrC30pdVMI3srJ5MR75Gh6zQ4DyATAMbIosGbr9HFTHQVDZ0S5ULZBtTuFRYWJ/tNojWukHJNdrjLyKeWwaPMY2RfOegREt0bvYuaHPoF53FrTkZbMwM9KyCo2AIBwjNZPUBI+Fe+WJHJckC+Kb+WQCI9bW69rB1cdoBcg26mL5yT4kAdh1TFWWrWCJD/0yMwD0YWV8YpJMe+sSbuCsigfRjiv2VwLHG7DHzprmy2Z1lkcbdmpuHUntTGJN9xqLui9pJK+QxINoXgOkJVvTEIykEuGu4N+71op3O2tQ/k0q3cLvIM4r/7a7H0bSbfwROxwJx/P/P+/bGlFkg/WKl35HoOOpm7en0ilcqaRMdlXA/ZLShgCDpQg5/Gw2TW861xsKCRL7wW0UJknltfy2qYDHigHPNFrXJY7iW+oH+MKSlBy8noj/1jFnxHEbcU67xJolgWlNVKZWUP10/zWe5n4z8K0HNPZDmpTXFEMwv6C4SZ002Zt+9kLKF2KYh7ydMhoHDvwbgUWWH91ncoFcIm+2zgB6kHVFbAqzh8SiJRhglQ9jJ2cXTLelqKmNMtZdj9ZARphEOXjxgHRDcTeixWEVuSa+2lBXvipKkyWjXjXQ5a5ihSlotohA2/1piwgrMr+IZorngxot69Fx9vFBh3lhBZ3wVBneAII554c+DSxl/QA7U2/+xVR4UyIRgbCWAmw7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 03:04:03PM +0100, Kevin Brodsky wrote:
> As a step towards removing pagetable ctor/dtor calls for kernel
> mm's, move the page type updates from the ctor/dtor to
> pagetable_{alloc,free}.

Thanks for doing this patchset.

We should switch over from __folio_set_pgtable() to __SetPagePgtable()
in this patch. Ptdescs and folios should be treated as distinctly
independent of each other.

Eventually, we want to replace the memcg accounting as well, but
there's no existing API for that right now. Lets leave that as is for
now; this patchset is big enough already ;)

> __pagetable_ctor() is now empty so remove it;
> pagetable_{pud,p4d,pgd}_ctor() will be removed at a later stage.
> 
> The ctor is normally called after pagetable_alloc() (and dtor before
> pagetable_free()) so this patch should have no functional effect in
> most cases. Where calls to ctor/dtor are currently missing (e.g.
> x86's split_large_page()), this patch will ensure the page type is
> set correctly.
> 
> This patch is based on Matthew's earlier implementation linked
> below, with the difference that when freeing the page type is
> cleared in __pagetable_free(), meaning that the update is delayed
> until the pages are actually freed in the
> CONFIG_ASYNC_KERNEL_PGTABLE_FREE case. This shouldn't matter in
> practice.
> 
> Suggested-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Link: https://lore.kernel.org/r/20251113140448.1814860-4-willy@infradead.org
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  include/linux/mm.h | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 361a0d7b74c5..94f0fb1c662a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3684,6 +3684,7 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
>  	if (!page)
>  		return NULL;
>  
> +	__folio_set_pgtable(page_folio(page));
>  	lruvec_stat_add_folio(page_folio(page), NR_PAGETABLE);
>  
>  	return page_ptdesc(page);
> @@ -3694,6 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
>  {
>  	struct page *page = ptdesc_page(pt);
>  
> +	__folio_clear_pgtable(page_folio(page));
>  	lruvec_stat_sub_folio(page_folio(page), NR_PAGETABLE);
>  
>  	__free_pages(page, compound_order(page));
> @@ -3799,19 +3801,9 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
>  static inline void ptlock_free(struct ptdesc *ptdesc) {}
>  #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
>  
> -static inline void __pagetable_ctor(struct ptdesc *ptdesc)
> -{
> -	struct folio *folio = ptdesc_folio(ptdesc);
> -
> -	__folio_set_pgtable(folio);
> -}
> -
>  static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  {
> -	struct folio *folio = ptdesc_folio(ptdesc);
> -
>  	ptlock_free(ptdesc);
> -	__folio_clear_pgtable(folio);
>  }
>  
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
> @@ -3825,7 +3817,6 @@ static inline bool pagetable_pte_ctor(struct mm_struct *mm,
>  {
>  	if (!mm_is_kernel(mm) && !ptlock_init(ptdesc))
>  		return false;
> -	__pagetable_ctor(ptdesc);
>  	return true;
>  }
>  
> @@ -3917,7 +3908,6 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
>  	if (!mm_is_kernel(mm) && !pmd_ptlock_init(ptdesc))
>  		return false;
>  	ptdesc_pmd_pts_init(ptdesc);
> -	__pagetable_ctor(ptdesc);
>  	return true;
>  }
>  
> @@ -3942,17 +3932,14 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
>  
>  static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
>  {
> -	__pagetable_ctor(ptdesc);
>  }
>  
>  static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
>  {
> -	__pagetable_ctor(ptdesc);
>  }
>  
>  static inline void pagetable_pgd_ctor(struct ptdesc *ptdesc)
>  {
> -	__pagetable_ctor(ptdesc);
>  }
>  
>  extern void __init pagecache_init(void);
> 
> -- 
> 2.51.2
> 

