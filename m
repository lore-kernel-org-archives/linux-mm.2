Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAD3CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68D26B0005; Fri, 12 Jun 2026 07:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C197E6B0088; Fri, 12 Jun 2026 07:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1646B008C; Fri, 12 Jun 2026 07:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD506B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:08:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38C9D40145
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:08:12 +0000 (UTC)
X-FDA: 84870986424.30.6EFEFC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 79EE720002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:08:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SKJ4XRDm;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781262490;
	b=aX9hDiV4owwyy7+N1QqDKSgr7sJwaYO6H++Yp1ir1VTWpRdLOsewDeAC6i509Jwv0JM4/h
	1O5lZBG3QIrdAf00Bhivw6HoiEYj9nAl9dq5IZxnapHOqDSOzyCzVFWNBpE9r/lE71Rtes
	TS0jfY9A6ZgHOUjxD9Szs2XKwKOdBAU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SKJ4XRDm;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781262490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPM+ofoDT7OwP6EPF9T/WLKHhKdWs1UI7b0Z8Ec18eA=;
	b=fWmnkP63oT7flcOF5lISueGxFY2zxt0WItsEa73aEWKWeW6yQPYDv6ryttTpV+XD0gj3bC
	8UeSLUS8FXwFvbFN4MLPqKoZ2fkVA5fp9hktHWEZ+gpCH6a9lRZ/q7gC00Utqrok1BcS2X
	7PIuGulLxdlXkT9aWu6sOHiaaebQsxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A81496001D;
	Fri, 12 Jun 2026 11:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF4D1F00A3A;
	Fri, 12 Jun 2026 11:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781262489;
	bh=UPM+ofoDT7OwP6EPF9T/WLKHhKdWs1UI7b0Z8Ec18eA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SKJ4XRDmQILjWaI8kvfTb0FVmvLRTBOaOQWepscAkVlk5PsAB+W7Rn0IbRTsuKghc
	 E7Q2HYYBLar5Wrvpav3lmSaDLwkCfIHsgYH2KKXw4qqr0U1YmJpCC/RTaVBPvhK30T
	 EI0VRspNpKBRddZTRCUGCHBWeVLGikp1d3HRNMt2ieyyW16Syr29mBZSW3OChCebD/
	 B6RSHNqQcAAtdDTMxuoZ0/fezuRqa3he8ArOWgV4BRyXcJph+Ae5OOctJ8CAoaBQVm
	 8TMFgfVLJF1MKGNNnBS5M3y/RbUSGDlKleDYomJGhzxPFpPf90yRXY/RBVEhx+MqyB
	 bSFd82RlFp7sw==
Message-ID: <fc57bb9a-4564-489e-8da4-65068b5283ae@kernel.org>
Date: Fri, 12 Jun 2026 13:08:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 3/3] mm: Replace pgtable entry prints with new format
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Petr Mladek
 <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
 <20260610043545.3725735-4-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260610043545.3725735-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 79EE720002
X-Stat-Signature: zu78gniqprs1jma3ss54qagbr9qbx6ix
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781262490-77837
X-HE-Meta: U2FsdGVkX18l09jwFUR3pASbKKyJiyx69PEaRJ+phVsNoNjXatZ40gv6IpdtW7oSIi2A0QrN0f2LJeAxOJUhKu1bLiX+l++isrkBniIrkLiAzQ3mIuYwPY0Arw2+UIkYYbAOMQePbODStMJhVH6AoblU3RWq8sAXt+6mAIsS6vlPPAeWQsv7kDHm+1D41AxzXGOSSFqb+NRbxic1oKOmQLPbiiVKejlzKvn0e5liEhgQQpFfn3QO4dVBQb7KsmiXsZTJahQ/4APvBlxKaxi+6XiwZNrwjmo0lu+I3p5dDC59vyWhIU3Z0ml/6GlKHZprMWA5SjyBgrBW2A9wsaynaYdYbJTSLfnJp7rC0iUUA/W1IOZ1dnWPxHd9oy3WRfH0cgA/0ZIBdSEvf2LaPP9xTVDXHlyFqk2Imyc22H/eAmHsv/vBqlW6AKVUxnKDc/714xz/fi/E25qPLhKk12AhHMGiBrfZyvXP0a5bYHNwBZru/n/uJpbZ0DaqwOmF9E615N3xdHlf95TjVR4Uca+skwk+9EjIP224nCEeUdyeURGaiqntoquHAqaib3k40RO7KgprR4VKxmK1QeTc2u4ghq/KaL1Ue01C+AzfWLT4zvRuvQL/OJhF0wOjgbc0NnaTGuDJyj0U2A7v6A3OToGKE/o4lqUDPbjix3+hbqRymmVaMjt6fR9J58rlnriHgEX4WnLHzxVvpIRxC5UX82oy90HrG0RRzMCOdg2niVVPbDvpT0I+8VUu6D85d6m2ReOvtH4VKgyf7Q8pnvbLING/oWwJgdgyhtSkgBKajhRZHBJt2YVuyfIwukPXhduufnY12rOifnPX2EHwCi4BKhk3xqS5HAgTzeWyVnl32ych13behM/9woygEoOhvQIdNlg6wGkClfyEx5MNCe537VBDTLv9nCm/AlyiqloMYU31bR39Wf+2MZj8COv2VXQal0GPUbX7OppkqrOVsB5oi88
 vtX+3uyl
 KdolkX9SJOOh5gjHX1lmDK0hHcLVm3MMWv2vF06/aygu2UNMw8Y6CbSYNvnCGSlnj2Q7BEazvjLm3zIknFIAAsHlk1yUFBO2BF7ROb8DrLoVOcQIJqbdrU8avXNXARrPshffFnq6DdgsJqk2VH4WmOpDQs4l8ELRg203iR+HpE/vIw3qUovcc4v8v+WTdsxSf5TlfnrusoE8a+0IH0M3lzgD/MhB7aKi3aY+hWPo+Fi0o6936CXl0O4LJt5gpoCcES9cN+JxClaZwT6Lmn2xlwYg0s7jYmylX6kwSbr8mN5KW93KD4emo/59Rg/OHgFsBwRAmNRSCVy5Y0qC68pyidUY6JZg+uTmWcio0S0FYx/WLFuRmG58I5P7qmE0mAZHEnXoq6KFGVmcXdz8fL+Ic1/RG2B9GY3W8EmE7Ch4VKsg9cJjzbGKkOi1VnhKqx7fDuIzY/BFZm4AdFIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 06:35, Anshuman Khandual wrote:
> Replace all existing pgtable entry prints with recently added new format in
> __print_bad_page_map_pgtable().
> 
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> 
>  mm/memory.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..8a25790f7c24 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -521,7 +521,6 @@ static bool is_bad_page_map_ratelimited(void)
>  
>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>  {
> -	unsigned long long pgdv, p4dv, pudv, pmdv;
>  	p4d_t p4d, *p4dp;
>  	pud_t pud, *pudp;
>  	pmd_t pmd, *pmdp;
> @@ -532,34 +531,30 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * see locking requirements for print_bad_page_map().
>  	 */
>  	pgdp = pgd_offset(mm, addr);
> -	pgdv = pgd_val(*pgdp);
>  
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd:%ppgd\n", pgdp);
>  		return;
>  	}
>  
>  	p4dp = p4d_offset(pgdp, addr);
>  	p4d = p4dp_get(p4dp);
> -	p4dv = p4d_val(p4d);
>  
>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
> +		pr_alert("pgd:%ppgd p4d:%pp4d\n", pgdp, p4dp);
>  		return;
>  	}
>  
>  	pudp = pud_offset(p4dp, addr);
>  	pud = pudp_get(pudp);
> -	pudv = pud_val(pud);
>  
>  	if (!pud_present(pud) || pud_leaf(pud)) {
> -		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
> +		pr_alert("pgd:%ppgd p4d:%pp4d pud:%ppud\n", pgdp, p4dp, pudp);
>  		return;
>  	}
>  
>  	pmdp = pmd_offset(pudp, addr);
>  	pmd = pmdp_get(pmdp);
> -	pmdv = pmd_val(pmd);
>  
>  	/*
>  	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
> @@ -567,8 +562,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * doing another map would be bad. print_bad_page_map() should
>  	 * already take care of printing the PTE.
>  	 */
> -	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
> -		 p4dv, pudv, pmdv);
> +	pr_alert("pgd:%ppgd p4d:%pp4d pud:%ppud pmd:%ppmd\n", pgdp,
> +		 p4dp, pudp, pmdp);
>  }
>  
>  /*


After some off-list discussion, I wonder if we can make our life easier.

I think, even with your patch, there is still the case:

pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
	 pgtable_level_to_str(level), entry);

Where we cast all entries to an "unsigned long" in the callers. We'd have to rework all
that for 128bit entries either way (passing them in some struct instead).

I really just extended what we used to do here in print_bad_pte() before commit ec63a44011d.

Maybe we should just drop the "print the involved page table entries" thing?

I mean, we do have the actual page, and we do have the address in the address space, which
we all print.

Not sure if the actual page table entries are that relevant? Would clean up nicely:


From a1673198f9687b307496903b3f516a3c00f76199 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 12 Jun 2026 13:06:00 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 80 +++++++++--------------------------------------------
 1 file changed, 13 insertions(+), 67 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d4b3540ae659..989f7d6b280d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -519,58 +519,6 @@ static bool is_bad_page_map_ratelimited(void)
 	return false;
 }
 
-static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
-{
-	unsigned long long pgdv, p4dv, pudv, pmdv;
-	p4d_t p4d, *p4dp;
-	pud_t pud, *pudp;
-	pmd_t pmd, *pmdp;
-	pgd_t *pgdp;
-
-	/*
-	 * Although this looks like a fully lockless pgtable walk, it is not:
-	 * see locking requirements for print_bad_page_map().
-	 */
-	pgdp = pgd_offset(mm, addr);
-	pgdv = pgd_val(*pgdp);
-
-	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
-		pr_alert("pgd:%08llx\n", pgdv);
-		return;
-	}
-
-	p4dp = p4d_offset(pgdp, addr);
-	p4d = p4dp_get(p4dp);
-	p4dv = p4d_val(p4d);
-
-	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
-		return;
-	}
-
-	pudp = pud_offset(p4dp, addr);
-	pud = pudp_get(pudp);
-	pudv = pud_val(pud);
-
-	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
-		return;
-	}
-
-	pmdp = pmd_offset(pudp, addr);
-	pmd = pmdp_get(pmdp);
-	pmdv = pmd_val(pmd);
-
-	/*
-	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
-	 * because the table should already be mapped by the caller and
-	 * doing another map would be bad. print_bad_page_map() should
-	 * already take care of printing the PTE.
-	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
-}
-
 /*
  * This function is called to print an error when a bad page table entry (e.g.,
  * corrupted page table entry) is found. For example, we might have a
@@ -584,8 +532,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
  * page table lock.
  */
 static void print_bad_page_map(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long long entry, struct page *page,
-		enum pgtable_level level)
+		unsigned long addr, struct page *page, enum pgtable_level level)
 {
 	struct address_space *mapping;
 	pgoff_t index;
@@ -596,9 +543,8 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
-		 pgtable_level_to_str(level), entry);
-	__print_bad_page_map_pgtable(vma->vm_mm, addr);
+	pr_alert("BUG: Bad page map in process %s on %s level", current->comm,
+		 pgtable_level_to_str(level));
 	if (page)
 		dump_page(page, "bad page map");
 	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
@@ -627,8 +573,8 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
 	}
 }
 
-#define print_bad_pte(vma, addr, pte, page) \
-	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
+#define print_bad_pte(vma, addr, page) \
+	print_bad_page_map(vma, addr, page, PGTABLE_LEVEL_PTE)
 
 /**
  * __vm_normal_page() - Get the "struct page" associated with a page table entry.
@@ -697,7 +643,7 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
  */
 static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
-		unsigned long long entry, enum pgtable_level level)
+		enum pgtable_level level)
 {
 	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
@@ -710,7 +656,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 				return NULL;
 
-			print_bad_page_map(vma, addr, entry, NULL, level);
+			print_bad_page_map(vma, addr, NULL, level);
 			return NULL;
 		}
 		/*
@@ -741,7 +687,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		/* Corrupted page table entry. */
-		print_bad_page_map(vma, addr, entry, NULL, level);
+		print_bad_page_map(vma, addr, NULL, level);
 		return NULL;
 	}
 	/*
@@ -768,7 +714,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
 	return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
-				pte_val(pte), PGTABLE_LEVEL_PTE);
+				PGTABLE_LEVEL_PTE);
 }
 
 /**
@@ -810,7 +756,7 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd)
 {
 	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
-				pmd_val(pmd), PGTABLE_LEVEL_PMD);
+				PGTABLE_LEVEL_PMD);
 }
 
 /**
@@ -851,7 +797,7 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma,
 		unsigned long addr, pud_t pud)
 {
 	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
-				pud_val(pud), PGTABLE_LEVEL_PUD);
+				PGTABLE_LEVEL_PUD);
 }
 #endif
 
@@ -1672,7 +1618,7 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 		folio_remove_rmap_ptes(folio, page, nr, vma);
 
 		if (unlikely(folio_mapcount(folio) < 0))
-			print_bad_pte(vma, addr, ptent, page);
+			print_bad_pte(vma, addr, page);
 	}
 	if (unlikely(__tlb_remove_folio_pages(tlb, page, nr, delay_rmap))) {
 		*force_flush = true;
@@ -4812,7 +4758,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		} else if (softleaf_is_marker(entry)) {
 			ret = handle_pte_marker(vmf);
 		} else {
-			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
+			print_bad_pte(vma, vmf->address, NULL);
 			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
-- 
2.43.0



-- 
Cheers,

David

