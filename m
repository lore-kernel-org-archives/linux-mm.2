Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C3BF8A140
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A172C6B0089; Thu, 16 Apr 2026 03:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7C06B008A; Thu, 16 Apr 2026 03:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840076B008C; Thu, 16 Apr 2026 03:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 706476B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:58:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1677A8C3BB
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:58:59 +0000 (UTC)
X-FDA: 84663667998.07.F8A9B80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57CF9180005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:58:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6VM3cym;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776326337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aSf+KVIKRHkoXBZHiLtxscIggCjYqeYu02pRUUdknk=;
	b=Fv6spyy2XXX9gOZ3rcBtboAsSGc+JL8XGUPRfpqbpiWVghOlB2j/H+puX4vCV62qTYZ87L
	RqQlDoYXl2c0SyWvlSTLtGjBxFPq5ePQEPsWuaFfTkge5iynEJB0pFKTmL/UOfc5CpCr5K
	J6DN617PPpGQAqh/HXCuIuJ6lLOQBSM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T6VM3cym;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776326337; a=rsa-sha256;
	cv=none;
	b=a44dDbt89xeTJB7vzOsE32Y5Waui8JQz5xNEeMlsVUlD6DwUlPj56/cGpIioANaUNkO5Fo
	lsHloFGxWj1gykCu+C4/9bdDDSWcmcC+B3wBe/kan2Jdwc44+QmKsfiO0IcruKDUUoGCzJ
	7ghJSopAv9NtfWckTPVxwnrpnFd5C3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A490E60123;
	Thu, 16 Apr 2026 07:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A98C2BCAF;
	Thu, 16 Apr 2026 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776326336;
	bh=0xcsvlEekecRgfRp93ckj3It0PB+yjoDAhI+3QvwcRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T6VM3cym2aazdlCBuDCI9WJAbEA9HNf4tnyLhAPCyEFaRhfVqE9LmjrcYaiVYb0O1
	 HSllhasD1ZO0ku/RcE5iq0SyGbyiB40iYmwi7I2gl/SdaMFRhKbPf0bbjMcRKDbo8M
	 M3dlZINgadJnh5YTONIVrSq0ScEtMs3QszSF5JWzoB+S9+LkqXYBhhEzp7vik0KxSZ
	 uka7n5quKkUAQdPCl8djRQwXEUrnYbJuHd7/PWo9r5JmEu72sY+t4Fg0guJA+YiX3e
	 S2ziNA0XqOaSPwO2z08UlGvzfKXeibJnCHIHR/kkcm6Jc9cCysOexpNRogiXcQq5PW
	 JxhSq6XIwTYkA==
Message-ID: <844d4076-a250-486e-aa16-fe5149c9d508@kernel.org>
Date: Thu, 16 Apr 2026 09:58:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/pgtable: Fix bogus comment to
 clear_not_present_full_ptes()
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Ryan Roberts <Ryan.Roberts@arm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <fecfcf70436e267968c1c3b6908e51fe49fd9009.1776264097.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fecfcf70436e267968c1c3b6908e51fe49fd9009.1776264097.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gyj1k1u7qx44wnm1pdqnk95qmj57xnbw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57CF9180005
X-HE-Tag: 1776326337-229785
X-HE-Meta: U2FsdGVkX18gvrMdhom+xQTJozSu1CtiyIVu7kiw3Nv7ho1EQ2Y7ZZsLwp0cZdBHRY++yfAIjLXUckEJpwHvUoDM2rQ4p2PB7x2fhJHPxYMm0p4P3mii3DMJk8cia3VRh5Fc3l/Q+x9xwuAQ2z7H/EBX0uf+sxBXLJWPmbb0CNynuPLVjPUe8b9vhgzPbfMdQ3zHKmsUmU+7zsDGcDkYRWCZp88ftSO5q8nqmtVfd6rAwSk+yNMgz00W6zNOu+4O1GNm+WBk/wAmcNHUxRqv8JEbup7cBdLeJXwXNFHsWnbcsRZO36xr7wdrFR80gUYjfsrQT6GwX665sUUtDyQ22bJM2y6DSc/jpbO+SiOo9BuR8o6oLcMWs4H9n2huIuwZQ/nPl6tsexIVacEX0CfgJk6kPzKZexqx+QY+dq7EDLvgm++uMSy+hWujp3cL64YtUDKye2RwbZbjIMtJ2sa/nsNAU1kP8T7O6e/3clIJEveydmyZjQwStfnnKgcRxb8RpVxxz8IK2Gg+62UZYnr5lVlA0Q9g9QtsU+HI2+7Y9hiZikIn19ZzbkZaA6pU//M/EMTu06ziLu1XGdl5jYMXF5wS12ub8+8XMsMTo1BAK3eHabDNtVD+BFLFegBqi+rVaPlSMDzSSShgfzStDCu84H7oyuyxkypCQxi4RHrW86jx4V3xdOe5RAKxrOhghCedDzpA6Vpt7myHL/uLe+D+Dl2BBIKzld2nC0j45a7wUcHXcKv2rZ+aJ2zHhxExwNZ1P0nuVnYgmuk6P/IahDy7DVJcRogzeVFBYonfGlAIvS1MMGUvzPjlIOBcqxgyWLSziMlXi8+NN/H5nNipoHNz/GMvt9hfN0sMd2eihdPPs4EloS+NgoCwnwD8lpCM4XJl4v6JxwvW4qH4QzNf3nYlSJwj8NjdL1Cl7ZgSow4bJsNJJA98sRR21Qc7K1wv9ZEg6MskVY/AtfvUVbMcr4/
 1FQ4z4pj
 iC1UxYvxDrJxS3l7G5UYn5Hh9K0wg0eFTL8KRkbU4YI7PYMQD7yXefwDJ26ufTWyu6Bbaj+Z4cgOl8n+G+EIXj7sAwjMB3QuV7pSeUYS8QJ9eWo+gZu38q+yPZFjM48jE8jSbdIwAg/XbjoqJgYDbx3FKuKtlKOMVUOwt5qAXYU8qwEhbD8fX62myDgyFIWw/0PVebST9ogBvWnFz5thVRkQ4PNPE21qsdefaJEieNR5nrgaW9SwxF+dSbxv154mMSDbExs3XC0MMkqgkSznMDPm9avO9dxB/F7YgpUiv1sNEsxY8PAy+Qpv2T+jpYXFt6BYjt5VCXe6MYUaMC0/4t2+7aF7IKy99I2YcNxfkxl7sbKgx8QELB/soqCATgajnyjvSS64bu+ihC+7l84BSPXUHOLyWhDJHD+OBZigOBhLqnyUi9jd0gPAYAbR9C81RzVkX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 17:01, Alexander Gordeev wrote:
> The address provided to clear_not_present_full_ptes() is the
> address of the underlying memory, not address of the first PTE.
> The exact wording is taken from clear_ptes() comment.
> 
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  include/linux/pgtable.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 9ff7b78d65b1..2b82a71f13d7 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1021,8 +1021,8 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
>  /**
>   * clear_not_present_full_ptes - Clear multiple not present PTEs which are
>   *				 consecutive in the pgtable.
> - * @mm: Address space the ptes represent.
> - * @addr: Address of the first pte.
> + * @mm: Address space the pages are mapped into.
> + * @addr: Address the first page is mapped at.


Talking about pages with non-present entries does not make sense. So both changes
are wrong. Can you find something better and send that out separately?
I don't think this is required for your series, right?


Also, looking at it, it does not make sense to specify "full" when there is nothing
to flush. We are dealing with non-present PTEs after all.

Looking into the sparc variant of pte_clear_not_present_full(), it does

	__set_pte_at((mm), (addr), (ptep), __pte(0UL), (fullmm))

and that does

	pte_t orig = *ptep;

	*ptep = pte;
	maybe_tlb_batch_add(mm, addr, ptep, orig, fullmm, PAGE_SHIFT);

but in maybe_tlb_batch_add we have

	if (likely(mm != &init_mm) && pte_accessible(mm, orig))
		tlb_batch_add(mm, vaddr, ptep, orig, fullmm, hugepage_shift);

And as the pte is non-present, the pte is certainly not accessible. fullmm
is unused on that path.


All the talk about flushing TLBs about something that is non-present for
pte_clear_not_present_full looks weird.


@Ryan, you added clear_not_present_full_ptes() back then, but you were simply
reusing pte_clear_not_present_full(). Does below seem reasonable to you?




From 0899495ba8ecc73273450e58737bc458976dfa12 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Apr 2026 09:51:07 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/sparc/include/asm/pgtable_64.h |  4 ----
 include/linux/pgtable.h             | 28 +++++-----------------------
 mm/madvise.c                        |  6 +++---
 mm/memory.c                         |  2 +-
 4 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 74ede706fb32..0837ebbc5dce 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -945,10 +945,6 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 #define pte_clear(mm,addr,ptep)		\
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
-#define __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-#define pte_clear_not_present_full(mm,addr,ptep,fullmm)	\
-	__set_pte_at((mm), (addr), (ptep), __pte(0UL), (fullmm))
-
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)				\
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 17d961c612fc..b3d6c8ddd687 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -955,24 +955,8 @@ static inline void update_mmu_tlb(struct vm_area_struct *vma,
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
 
-/*
- * Some architectures may be able to avoid expensive synchronization
- * primitives when modifications are made to PTE's which are already
- * not present, or in the process of an address space destruction.
- */
-#ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-static inline void pte_clear_not_present_full(struct mm_struct *mm,
-					      unsigned long address,
-					      pte_t *ptep,
-					      int full)
-{
-	pte_clear(mm, address, ptep);
-}
-#endif
-
-#ifndef clear_not_present_full_ptes
 /**
- * clear_not_present_full_ptes - Clear multiple not present PTEs which are
+ * clear_not_present_full_ptes - Clear multiple non-present PTEs which are
  *				 consecutive in the pgtable.
  * @mm: Address space the ptes represent.
  * @addr: Address of the first pte.
@@ -980,24 +964,22 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
  * @nr: Number of entries to clear.
  * @full: Whether we are clearing a full mm.
  *
- * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear_not_present_full().
+ * Implemented as a simple loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
  */
-static inline void clear_not_present_full_ptes(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
+static inline void clear_non_present_ptes(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	for (;;) {
-		pte_clear_not_present_full(mm, addr, ptep, full);
+		pte_clear(mm, addr, ptep);
 		if (--nr == 0)
 			break;
 		ptep++;
 		addr += PAGE_SIZE;
 	}
 }
-#endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
 extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..0e430e03e69c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -695,10 +695,10 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 				nr = swap_pte_batch(pte, max_nr, ptent);
 				nr_swap -= nr;
 				swap_put_entries_direct(entry, nr);
-				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
+				clear_non_present_(mm, addr, pte, nr);
 			} else if (softleaf_is_hwpoison(entry) ||
 				   softleaf_is_poison_marker(entry)) {
-				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+				pte_clear(mm, addr, pte);
 			}
 			continue;
 		}
@@ -1234,7 +1234,7 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
 
 	if (is_guard_pte_marker(ptent)) {
 		/* Simply clear the PTE marker. */
-		pte_clear_not_present_full(walk->mm, addr, pte, false);
+		pte_clear(walk->mm, addr, pte);
 		update_mmu_cache(walk->vma, addr, pte);
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 631205a384e1..d61d4ba906cd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1781,7 +1781,7 @@ static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
 		pr_alert("unrecognized swap entry 0x%lx\n", entry.val);
 		WARN_ON_ONCE(1);
 	}
-	clear_not_present_full_ptes(vma->vm_mm, addr, pte, nr, tlb->fullmm);
+	clear_non_present_ptes(vma->vm_mm, addr, pte, nr);
 	*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
 
 	return nr;
-- 
2.43.0





-- 
Cheers,

David

