Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1FD8C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01AB6B008A; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB29E6B008C; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA12A6B0092; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 930E86B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:51:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0403BA07FD
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:51:53 +0000 (UTC)
X-FDA: 85255446948.18.5DAE27D
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6E6CAA0005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:51:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of tsbogend@alpha.franken.de designates 193.175.24.41 as permitted sender) smtp.mailfrom=tsbogend@alpha.franken.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790416312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EhbrncNdDAoUUYp8NrR6OFqMx/oVJWYCVe964Sc4Tuc=;
	b=15OrjiqduImaT4bBayg81zFvZ64vp2sycH5RkW7fDTLFbRpS+KGlWw3NtbCrnO7DDbZZrg
	fp9LsXiTKNKk+y3tUq0FG2T061nfY7mOZ1gdLxV+qCZuYmleH1W0TMA7To8TmmzQ+aNXVn
	G18MhjWNPbz1h4t/efhJ40dJooZfhig=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of tsbogend@alpha.franken.de designates 193.175.24.41 as permitted sender) smtp.mailfrom=tsbogend@alpha.franken.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790416312;
	b=JFdyinEQQTT1UKguMu4hi4bOgD9aud8ehRP544X62qGVxnG0V9qJbW260wWL3fRDVzSlXz
	IZVvWLIgeNsXsSP5ZlPJDd4q27J6y9amWdmvBrnbTZR+8NFM3UTa0ZoIJEZjjEVMb9QJGJ
	0LUlR/QM532A7JFjg9qZO9YnZmiBZUg=
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1xAP4O-0007LD-00; Sat, 26 Sep 2026 11:51:48 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id F3309C0C0A; Sat, 26 Sep 2026 11:35:58 +0200 (CEST)
Date: Sat, 26 Sep 2026 11:35:58 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Orgad Shaneh <orgads@gmail.com>
Cc: linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, osalvador@suse.de,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: mm: align hugetlb mappings in
 arch_get_unmapped_area()
Message-ID: <areR_hMi-gEyUQ-0@alpha.franken.de>
References: <20260915071329.15125-1-orgads@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915071329.15125-1-orgads@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8eky79ynzd1ch6y11espucnbstzs5hii
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E6CAA0005
X-HE-Tag: 1790416311-344218
X-HE-Meta: U2FsdGVkX19IdMdqlmZWWwdMfN9CVNeR+8kJtetS6yk/cR46SfZMvPU7mj0VDP7NHIyM9oF54LkDwFyuC8uL8po2oQpy4qt6g1EdR76Mu+nLbhMNb2XPQUD9KyV2xqk7y3brSOIwhGlledPB1nEnP0eOGbcZEP+zdlTmaQ7J5+VhzI37T1tojEuEAINsFIuzMlGbOQ72fOauW6GGVU2TYkVWQW7UsT/2yJokArAINqk487nN+UYIL5Hd5LNvL8g9Uo4Rik1TcCi+fNR/vWw23V30Xkv3u+G4Iug2c1xNG5JANOp8ghwJLSIfHckWoxeE+VkjRVCpZsIitroq/waHuseRuA0FHN6DcxFV3gzFZpHI3X4TKuUT4Wxje6oF01MCWpXtznJVgfyrQw/E89cfNb0D+ImBP3Ox24gX55eTM7iBbJ56rLs+SDIj/NgrYdCyvxt96Lz0g5jDLn73xPgB+qgUIwUKGYy0si5iZ1yKaqWYyWkK2S9aLJaKz7FtnguSC2bEF4nsKFq+ZCMtB8DyyD78IFw3sulVsHV2anZyarYPxx1457cc56E5KLa9C7KWqpDuWHn16vfFwOclMK7E4q4oT/dPhiTub7JGvxInT7HxyUvMT2kwnXQ97GRwY29oC0d1rRmlugVIirMH2n+YowbkUT9eTxq6zCCq5ZEBiyQyIuK3EMVgXlPoZi73N5UYURUXVUsaLMp0jZLFjmmbg0v5ueJfSuv2NqGXI5x7I8Me8IJ15Tt9DpHEN1w7d99SPcpskA/+pavxqP1TEVUlRZHJpwLrV+R1KGt3R5h4wMtmM28CuRs2Jrp2CeY3GRT3c3hGwa4II1My1p/rocQyKGMpRGNCoRVQ2r5c3uS7YmkP/LtTsVq1R4TFyNKOXii/Cfg9va+1Pjn0uI0TKuchacl6Ry3AAvmfg1FQwNIDp8iDgGyYA97thwVRSjDXYasJYq1amMmbBntPe6hbt9q
 s4mbeUaw
 3HfPAGvEwDdMbhOKHSZBPdPxDALTeLILVBJ+jWSGZjmr+6QUsZRZbR/P5t3S+Quc+xhU1LSqjY5xAgh7nE41a9dWDACDO61tBpvZ0BdYDxi9SKlEj6xLItot9ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:13:24AM +0000, Orgad Shaneh wrote:
> Since hugetlb mappings were made to go through the architecture's
> arch_get_unmapped_area{,_topdown}(), every architecture that implements
> those has to align hugetlb files itself. The generic implementation and
> loongarch do it with huge_page_mask_align(); MIPS was left out.
> 
> A non-MAP_FIXED mmap() of a hugetlbfs file therefore returns an address
> that is only SHMLBA aligned, and the kernel then installs 2 MB PMDs for
> a VMA that starts in the middle of a PMD. The consequences on an
> Octeon (CN63XX) board running a process that links libhugetlbfs with
> HUGETLB_ELFMAP=R and HUGETLB_MORECORE=yes, all within a minute of
> start: the neighbouring 4 KB page table is clobbered, the TLB ends up
> with overlapping entries ("Caught Machine Check exception - caused by
> multiple matching entries in the TLB"), process exit trips
> BUG_ON(start & ~huge_page_mask(h)) in __unmap_hugepage_range(), and
> freed pages leak into unrelated kernel structures (oopses in the irq
> maple tree, in pte_offset_map, ...).
> 
> Do what loongarch does in commit 3109d5ff484b ("LoongArch: Set hugetlb
> mmap base address aligned with pmd size"): when the file is a hugetlb
> file, use its page mask as the search alignment instead of the cache
> colour mask.
> 
> Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
> Cc: stable@vger.kernel.org # 6.13+
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Orgad Shaneh <orgads@gmail.com>
> ---
> diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
> --- a/arch/mips/mm/mmap.c
> +++ b/arch/mips/mm/mmap.c
> @@ -9,6 +9,7 @@
>  #include <linux/compiler.h>
>  #include <linux/elf-randomize.h>
>  #include <linux/errno.h>
> +#include <linux/hugetlb.h>
>  #include <linux/mm.h>
>  #include <linux/mman.h>
>  #include <linux/export.h>
> @@ -72,8 +73,11 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
>  	}
>  
>  	info.length = len;
> -	info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
>  	info.align_offset = pgoff << PAGE_SHIFT;
> +	if (filp && is_file_hugepages(filp))
> +		info.align_mask = huge_page_mask_align(filp);
> +	else
> +		info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
>  
>  	if (dir == DOWN) {
>  		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
> -- 
> 2.47.0

applied to mips-next

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

