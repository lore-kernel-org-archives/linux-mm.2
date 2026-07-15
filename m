Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BC6C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5CD6B00D1; Wed, 15 Jul 2026 09:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65C46B00DD; Wed, 15 Jul 2026 09:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D786B00DF; Wed, 15 Jul 2026 09:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 960E06B00D1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:47:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 080551C0029
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:19:08 +0000 (UTC)
X-FDA: 84990764376.03.CBE96E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40C6E12000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:19:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TSyiesxW;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9sBwucW0H+Ur8B3pqY/4qV99s4uAuyQMfEzLRIRZkM=;
	b=sdsa/xfAhRPefPp0wmQuSb9t7qWZmKEje/DMCSmoAm9xHJRDWxLi99naOCgHDCBX8quWcw
	5V47N9ydjpUi7ooO4Ks9AizNjlZ3faJjIu0SOef8Vfsm1SCMSIv/ZDnkgqsSWIu/9RZT0a
	wGkF7y5fQg3Rp6OFgBlkG0zzWl7F9rc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TSyiesxW;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114346;
	b=x00bUU8RsqZoxbS1Zbl0DElVQo1ovsO7sdq2IykK4X/uOZYbGBy+7YAHtWdRLLmip8TQvN
	f4IBOysX69Qmi/Brfg7idm9Xl0wgps9mF0NB1YLYCx+QBgT3RiTL0engTnnj8YJkJY8Qdd
	xYmre6vXNPUnnWhHqbsrDknVFIopwQ0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23C991477;
	Wed, 15 Jul 2026 04:19:01 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5602D3F915;
	Wed, 15 Jul 2026 04:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784114345; bh=FASJfRiTYqPOAEgL4yWBpkca2p01JpG0G1APx8Od+GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSyiesxWF+4lR5EXk4mJ8aedDhJdaZr5m6Ev+e3nDI2m73M0OUfsk7FB+lhm5eOtu
	 +ssIUymltMwxLBuDjFjNmuScj5fBtfHkZi6H0MeKLaBRTZhXaitWiZgodxES19d3BN
	 eqw+Zq1ohFviuknmQalmTbW1tD/w//s76UbIdHfk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 2/3] mm/memory: batch set uffd-wp markers during zapping
Date: Wed, 15 Jul 2026 11:18:35 +0000
Message-ID: <20260715111839.1667914-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715111839.1667914-1-dev.jain@arm.com>
References: <20260715111839.1667914-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40C6E12000F
X-Stat-Signature: 9hjoy8hwnndfoj1e164abrbmswuiag9u
X-HE-Tag: 1784114346-690058
X-HE-Meta: U2FsdGVkX1/mmMBIjiIft4//nPUnBXO3+939emcGJziSJEyotG31PxOuOMbm9z/RLfp92BapQOLYCrHcQCt8jyce2hLWk1kJSd/1a9UxkrmYD3tPLtsEkk17GL4Hc87Fr9QvCvQ4ftmAkPhr4yO7m256Il2OiQhHRVdKNIyRPtyjzxn9TdrMPGzDvZIeINBYbswkTPHrgveDRP92xtcyIuAI3f8KCX8yMbqYTrE8q+M/cmwHG+2LGqSXLJyDclkM+h6HLB2+WyA0hPkFiHzPsmvRpSQgsoPDxnZkD1VGpg+bFr+8yQTKJgF7STYILScJxESlciesFiu3nWVwl3kK+bYykReroi7zRG4DUTVeBX4LdR1eMwMPVtX6ciDeg3u952rqMex7idxb1ptJoNWwi0GkuT6bLkMq9JUaIhSROBDAL/pOWUF+W4lD666a3bOa/eV7jlUPqH0oBZxRlBuZztm8jAJLr45JRaVRc1q7L//q0HD80/VGb/5srnVgk3zQSL7iglLNfunxOarRtDFBUeOdPp+ND6w3lm5dCcOkjYvrerT6AtyM7EOKEJu2i7M9M3Sci98o8b/YxJ9SVYvpXeta3m10AGgbhhpNG6XtWJ4DYzkonv1Z2Izn9mXJlhu0w9clu5NQv/AcwxDVvFQqW6VlA/MY+p+eDm5O3rAbSjLNAefOTcAynnApCsYvXiCw/trymA+TDk2BeubJbbTwkhn4/j5ljD3YzrRNNVPuqi6x6ay8NM7Y9J8+SdYMl4mIsn1Fk9wH9/++n9jtYgfkriI1j3/LViPb2nb4NoSOm9JEG7zSR83wp83FSzI4m9+VAlefr7I+zfMMzj1gId2IFntaWuqPb36y+w0ed8LT2Iv0DsvCwaiKiJ5d+WU75c4iAppT1GLclg9xrGcu0HfKzo35OWougMFK4SB5CWhyed8Hc/2XA762jHpYWKGDhgAy2Fpl0/6vtAa7PWyx5R+
 74bZ7S2x
 3MCarYaHaplcPmAu+h0OCBHxdzPLmIrHjoVARrERGZUQdha63ZhV1oCpMDCQWXf+P6cGru4cqZ5qfCW2gizyB8XNfPfMWk6/l7gIPP+CsQsy2XX4y0HmlgncUKC+bQhWX2xNDdiLrwSzRBSFMIkAXT9pd2hEkxYZCPrhumfV5C8L9FJqpadk/pJ2m6XxWO0mBiueDRvyq9BvbSW5Snmq7tOgMO/wuzaJuKWTsbzMOBqP4imkLD0NaCxIE6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable batch setting of uffd-wp ptes.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch or swap_pte_batch, therefore
batching is correct:

1) all ptes belong to the same type of VMA (anonymous or non-anonymous,
   wp-armed or non-wp-armed)

2) all ptes being marked with uffd-wp or all being not marked (same is the
   case with the pte_swp_uffd_wp_any check)

3) uffd_supports_wp_marker() is independent of the function parameters

Note that we will have to use set_pte_at() in a loop instead of set_ptes()
since the latter cannot handle present->non-present conversion for
nr_pages > 1.

Rename the function to cond_install_uffd_wp_ptes.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
To handle nonpresent->nonpresent transition in the ptes, we can have a
set_nonpresent_ptes() (in my unmap series) : if !softleaf_has_pfn(), use
set the same pte value to all ptep's in the patch. if softleaf_has_pfn(),
then add a softleaf_next_pfn() to construct the next softleaf, and
pte_next_softleaf() to call softleaf_next_pfn() and preserve the
wp bit, s-d bit, etc from the previous pte.

 include/linux/mm.h |  6 +++--
 mm/memory.c        | 64 +++++++++++++++++-----------------------------
 mm/rmap.c          |  2 +-
 3 files changed, 29 insertions(+), 43 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a71341c44655e..94e0a92bc70b1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5406,6 +5406,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr,
 		bool uffd_wp);
 
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte);
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma, unsigned long addr,
+			       pte_t *ptep, pte_t pte,
+			       unsigned long nr_ptes);
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/memory.c b/mm/memory.c
index 98b3ace15cef2..5d2b567b383d4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1676,27 +1676,29 @@ static inline bool zap_drop_markers(struct zap_details *details)
 }
 
 /**
- * pte_install_uffd_wp_if_needed - install uffd-wp marker after clearing a PTE
- * @vma: The VMA the page is mapped into.
- * @addr: Address the page is mapped at.
- * @ptep: Page table pointer for this entry.
+ * cond_install_uffd_wp_ptes - install uffd-wp markers after clearing PTEs
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
  * @pte: Old value of the entry pointed to by @ptep.
+ * @nr_ptes: Number of entries to install.
  *
- * If the PTE was write-protected by uffd-wp in any form, arm a special PTE
- * to replace a none PTE. NOTE! This should only be called when the PTE is
- * already cleared so we will never accidentally replace something valuable.
- * Meanwhile none PTEs also mean we are not demoting the PTE so a TLB flush is
- * not needed. E.g., when the PTE was cleared, the caller should have taken care
- * of the TLB flush.
+ * If the PTEs were write-protected by uffd-wp in any form, arm special
+ * PTEs to replace none PTEs. NOTE! This should only be called when the PTEs
+ * are already cleared so we will never accidentally replace something
+ * valuable. Meanwhile none PTEs also mean we are not demoting the PTEs so a
+ * TLB flush is not needed. E.g., when PTEs were cleared, the caller should
+ * have taken care of the TLB flush.
  *
- * Must be called with the page table lock held so that no thread will see the
- * none PTE, and if they see it, they'll fault and serialize at the page table
- * lock.
+ * Must be called with the page table lock held so that no thread will see
+ * the none PTEs, and if they see them, they'll fault and serialize at the
+ * page table lock.
  *
- * Returns true if an uffd-wp PTE was installed, false otherwise.
+ * Returns true if uffd-wp PTEs were installed, false otherwise.
  */
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-				   unsigned long addr, pte_t *ptep, pte_t pte)
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
 
@@ -1726,13 +1728,14 @@ bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 	if (unlikely(pte_swp_uffd_any(pte)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte)) {
+	if (likely(!arm_uffd_pte))
+		return false;
+
+	for (unsigned long i = 0; i < nr_ptes; ++i, ++ptep, addr += PAGE_SIZE)
 		set_pte_at(vma->vm_mm, addr, ptep,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
 
-	return false;
+	return true;
 }
 
 /*
@@ -1746,29 +1749,10 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
-	bool was_installed = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* Zap on anonymous always means dropping everything */
-	if (vma_is_anonymous(vma))
-		return false;
-
 	if (zap_drop_markers(details))
 		return false;
 
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
-
-	return was_installed;
+	return cond_install_uffd_wp_ptes(vma, addr, pte, pteval, nr);
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index ad820fe86f7d8..2f938d0ac6953 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2345,7 +2345,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.43.0


