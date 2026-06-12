Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D33BCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A586B0095; Fri, 12 Jun 2026 10:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921D76B0096; Fri, 12 Jun 2026 10:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837CB6B0098; Fri, 12 Jun 2026 10:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEA76B0095
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:24:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9868C02BE
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:24:56 +0000 (UTC)
X-FDA: 84871482192.28.A83CFDA
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1102F40009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:24:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=yN++Ar4U;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="Fw/CS40E";
	spf=pass (imf04.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781274295;
	b=kEVqDOLriI0aReLOMD3cqxmlkZLDf5eov+6atFVc8MoRWm9ehfh+QgLPAQhNO8ERsM3DJs
	4fqhbTZ1wBmfEQ1yX0pjYjHMAERLj658FRNCFcSm976za2s6STk/gcq43wsoLbXX0nqWiG
	I5/XFfg89AOsYGX+jGfwM1fQy5uunmU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=yN++Ar4U;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="Fw/CS40E";
	spf=pass (imf04.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781274295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwVtWQfu240VJ6rqsKtn7HxHk2R31SZbP2CkXTGyVBw=;
	b=RE3DcsmhSO4pQT7Y2UpyiBnx23k/6ceYsC4iFWzRyk6KNOiXGQZtQ1EANQ4ipRPEUOHajF
	KTQC2aGDfSv/S1Fx0UOYD4YgOLY6Z07u1ePN5jiBnBDRBEShYQ9kTGwQ5zSuqPwDVR0RPM
	2ZA+oXu7anbX5ATM6nvXM0+unAXQXy4=
Date: Fri, 12 Jun 2026 16:24:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1781274291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwVtWQfu240VJ6rqsKtn7HxHk2R31SZbP2CkXTGyVBw=;
	b=yN++Ar4UPeFVObgPptrM588vgWIw15P7N4oXqSzIGyFQOf7x7CuItiHn6bBlXUdRbH+axN
	cxeXNn9myH56N2/BOTWRv5I7U8xz2ahAuqxtOjs44Y3LN3KzmtViijfT3xmoFWC3fYywgC
	kdA5dD3bEqw8r/tQcN3waQH5d3f78ixh5AeNCpzcyxsKx5QLrYM81+yA6PadxpruigX+2y
	yMHPec+j0IT3CFCARpo6yNoAGFxdEHrOCyXSCcbTlK8229Y/u0vIU868LvZkG1isqj5X/s
	shtQSjoIxeiw44nTiY3N4xwJaXBVysKjTYpH81IBW6iV1cOjhGLr9CIDNM9lEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1781274291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwVtWQfu240VJ6rqsKtn7HxHk2R31SZbP2CkXTGyVBw=;
	b=Fw/CS40Emarj/k0CM4lLjf3k6omNTZJE0zu0chda+lYYSWq7q5sblGyvvDa0yVi5lfqMRN
	8BnlkiroEJEQ0CAQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Andrey Smirnov <andrey.smirnov@siderolabs.com>
Cc: pasha.tatashin@soleen.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com, Thomas Gleixner <tglx@linutronix.de>, 
	Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_table_check: do not track special (PFN-mapped)
 PTEs
Message-ID: <20260612162031-b4731d21-b293-4d36-8582-26394bd55a1f@linutronix.de>
References: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
X-Rspamd-Queue-Id: 1102F40009
X-Stat-Signature: f4d69173o16tbn1hkhfg85tes7384jyw
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781274294-787144
X-HE-Meta: U2FsdGVkX18KBPKUoEZnx8icZ2R6s3ym14n46qKsr+FTkS2uXqnOJbRxHDvd/x1E9x4goIJvOubvN1Jx+JDNcmxWsb/M+bThqUjPf+PwsR2OO2KWmWAhoGHfc+P6OtpGJRgDoYhKSwhie9BZAoJ33YEZ8GNdpTDsSkSUxxMLO4OjpcItQ8MAFyF89SeGQEl2BMC8AN4SO75WZ6Mxn/g0mi7CmPodq8IKqi9Itdn7gMKyrg0v7DSAbZ4755l5RJdlCfivd/8cl1xpJpMC6VSGCNmhVzWxZ42V25n4FdHJqtDZri3WgmJG4YQ1ki0MRkM7oHgPP7tJyouIZjCwsB+D3AwrKJAHOlTB8fJW4gVdD7rfNnhC1zHwgJZak1npRUts2NWDWPOa2yC5RVUuC0T7oDXEreaWgg/lpqgLI5O+Spi0L5PaAb1Z0cfEoBqAdoaQxFQzCcsEdz0t1QT8ELgndRE7M198IvQLb9JQkm8Idu/mElKJrOZ0Z8XXPFZZ/DIFP/m1omhSmmhOKwpgvIDJpSYE4V/J7chQ3+zMLy1OuhsUNbhnJ9QIr0COHdF/8BZCUuVM7rUxRJP6bZhV1dp+HuEVQYCy9RWDAuVc3I4680aojTCyECvS8RinpoRmThJg/0vAIs3Og52zutRBzzYek+sCjWR3IGg4sbTgTGylPjt49id+syDUToNwk08nIHvFSz70BxVropDI03XY7scQ7EqlavxBycQ9QhrmlvAwow1JLKizwX3gmrN1iDbB/NWh3ZBm6N6xmplb7oxZJMptculxytjWelaQ/30WFh0IK1LpPrm8giB31O5BDCdvW/M7nT/FuQpPjhxwJyWc1cvgW6z/HWs65CizfU8ouciZrXfy09oRiGosA5XYB3otZnGocy0l2hdfAgdtLD9X5bunmW7kEWpA8V04FOR+z1cYI6MlDQM4ZryVwZDpHxv16jlLVqP1ETaZQwRUSMUzjAL
 EhaqSn0r
 hAls1jJz4sTi9njqtPXdQ5HmIAt/x3Pw1NASRyBMQ0DDgu5iHfVkK2E8sAK3zROjaBpHOQ40Wb1mG7OAFwYT/aCQH1UY+Jqt5Ol4Bn+E/Bc22loLnn/MwHCn7rTMFyWXKxnFTKFwpt8HQZMaWnRvX2WtWa6s5ZqIL+eEctbxx85F8ncOqMMIdg+8yrGMFrs6j168oEIO1jmxat0M1/Wvp7jhXD7xkfIucJkCHI0ElXKKJVbSOrWYWJJvq2KglS6h/ErQKyqh9p2oVZZp4tubXUuLfTeXUeW+EUVKDSLHj8zhyxy30hhSO4VridAjpAenkigMiWKHex+vhwB12kW3vSKPJLgoJbBS13SN8/Mns9k1GziGCEA2s4kwwYJP46bICr44vZvbLbSg15smyZ7g9z3+/Zmk6vTL8kcobfaF+dpq+gCQCNednwia7DVXdOthyo3x8feeH3qqcfIpoTBPxDhLr/1cWaZQVFpRDo9b13ZehADWHUnoNe9e1q2qSO0agkUTn5vT9T3l9+Pchg5NDkSHMUhl0Ndwl0sIZGx/GO9R06or6S6YoHyoIEbPykTBtIt4UxEpq89hzLHJ4zrP3eW5WTF05iYVWLLiiLHsYVojFZM0QbUAFbdi7U7UkJjnnzRmZ8EQaWZj5UClWe1xE1fDA8y0xVvSOHnMc2Mz4Z9IxoBFuPfauPJ/KbnPWvE8CyX8QchWhHpF1Rsm6FzUYB7Xbn7DVZniEkm+32V3lalH3n+rE0aFHxM035+Yis/YzBgmJXhtssAG3vIVd59gWtlOAbG0RE85w4tORQqJJD59Q03IyNKhXn3I6lsc5SGcJe4QP941v8qyvKGZptGpZeqzzwnIRmkqmnXjRgtpQlZO9AHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 07:57:58PM +0400, Andrey Smirnov wrote:
> The vDSO data store ("[vvar]") special mapping is created as a VM_PFNMAP
> mapping and its pages are installed into userspace with vmf_insert_pfn(),
> which produces special PTEs (pte_special()). On x86 and arm64 (and riscv)
> pte_user_accessible_page() only tests the PRESENT/USER bits and does not
> exclude special PTEs, so page_table_check accounts these PFN mappings in
> the per-page anon/file map counters even though they are not rmap-managed
> pages (vm_normal_page() returns NULL for them).
> 
> Most of these data pages live in the kernel image and are never freed, so
> the stray accounting is invisible. The time-namespace VVAR page is the
> exception: it is a real alloc_page() page that is released with
> __free_page() in free_time_ns() when the last task of a time namespace
> exits. Across the map / unmap / vdso_join_timens() zap transitions the
> special-PTE accounting is not balanced for this page, so a non-zero
> file_map_count survives to the free path and trips:
> 
>   kernel BUG at mm/page_table_check.c:143!
>   __page_table_check_zero+0xfb/0x130
>   __free_frozen_pages+0x52f/0x650
>   free_time_ns+0x85/0xc0
>   free_nsproxy+0x7f/0x130
>   do_exit+0x313/0xa60
>   do_group_exit+0x77/0x90
> 
> This is reliably reproducible on x86_64 and arm64 under heavy container/CI
> churn that rapidly creates and destroys time namespaces (CLONE_NEWTIME via
> runc / docker-init / tini), and was independently reported by syzbot on
> riscv. It only manifests when CONFIG_PAGE_TABLE_CHECK is active.
> 
> Special PTEs have no struct-page rmap semantics and must never have been
> tracked by page table check. Skip them in both the set and clear paths so
> the counters stay balanced (always zero) for PFN-mapped pages, regardless
> of how the architecture defines pte_user_accessible_page(). pte_special()
> is available generically (it is a no-op returning false on architectures
> without ARCH_HAS_PTE_SPECIAL), so this is a single, arch-independent fix.
> 
> Note that the v7.0 generic vDSO datastore rework in commit 05988dba1179
> ("vdso/datastore: Allocate data pages dynamically") incidentally avoids
> the problem by switching the mapping to VM_MIXEDMAP + vmf_insert_page()
> with balanced struct-page accounting. This patch fixes the still-affected
> VM_PFNMAP path used by 6.18.y and earlier, and additionally makes
> page_table_check robust against any future PFN-mapped user pages.
> 
> Fixes: df4e817b7108 ("mm: page table check")
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Reported-by: syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com
> Closes: https://github.com/siderolabs/talos/issues/13496
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Smirnov <andrey.smirnov@siderolabs.com>
> ---
>  mm/page_table_check.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 4eeca782b888..ee492d5389b9 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -150,9 +150,16 @@ void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
>  	if (&init_mm == mm)
>  		return;
>  
> -	if (pte_user_accessible_page(pte)) {
> +	/*
> +	 * PFN-mapped (special) PTEs - e.g. the vDSO/time-namespace "[vvar]"
> +	 * mapping installed via vmf_insert_pfn() - are not rmap-managed and
> +	 * must not be tracked here. Tracking them can leave a non-zero map
> +	 * count on a struct page that is later freed (the time namespace VVAR
> +	 * page in free_time_ns()), tripping the BUG_ON() in
> +	 * __page_table_check_zero().

As this comment mentioning the [vvar] pages is already stale, IMO this should
not be mentioned specifically. It is also not clear to me why this only happens
now and where the non-zero map count comes from.

> +	 */
> +	if (pte_user_accessible_page(pte) && !pte_special(pte))
>  		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
> -	}
>  }
>  EXPORT_SYMBOL(__page_table_check_pte_clear);
>  
> @@ -205,7 +212,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
>  
>  	for (i = 0; i < nr; i++)
>  		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
> -	if (pte_user_accessible_page(pte))
> +	if (pte_user_accessible_page(pte) && !pte_special(pte))
>  		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
>  }
>  EXPORT_SYMBOL(__page_table_check_ptes_set);
> -- 
> 2.53.0
> 

