Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47AFCCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00A16B0099; Wed,  6 May 2026 05:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2176B009B; Wed,  6 May 2026 05:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7FB6B009D; Wed,  6 May 2026 05:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 895706B0099
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:45:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51A35140744
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:56 +0000 (UTC)
X-FDA: 84736513512.16.46D677B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 853CC16000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="jPrZ/bLc";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdsvZLEUAtlcPkMQVU3JdQjgNoFOumFqKaaG52yB6z0=;
	b=YVICkV63Psytw1aX2SQbx0vNcJqMyWtyqLNlEBmHA8oH4CttEXn9UU+XrkcTFJz7i/2K7K
	kq+29UQjm/wPJSqkFTJ9XmxS7cqoUJXzxe8TkOqb9Dbt64bn5gU0DJoJZMAViOnPvFG0sT
	Cf1dvZaNarFY5xyl79YQrloC2GSuhgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060754; a=rsa-sha256;
	cv=none;
	b=msmOAH1mHT85Hd/tsZ+KwSjA3Ta0lW+9ERnPusvGXBD5rCBZ3tvZFQDMuf/VkZzpYWp/Qg
	soRUGboEYMec/hSg3vZVfEp+0PJyzqRj4t+HnsAJydreDKmwkJ/shaagfjop7+OFWcqEp5
	6wI8VD+2lj9r0bOcY4dCsHwEUgBaAF8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="jPrZ/bLc";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39B94337D;
	Wed,  6 May 2026 02:45:48 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A6BFB3F7B4;
	Wed,  6 May 2026 02:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060753; bh=3HkEN59qGwA9AEBO9cGzUKiZcsljeK+wx7Sw5pbA9Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPrZ/bLcoYOFivLtwCgE8lA9g7fjdUB+WrnEtiShUM3iRN6TrCP8+23mIRR1wzsgB
	 QjAGMDabR/gCPHALCB+HRvCgQP16I7KDKv7EtkhwP3Xxfxhj9vyErTYs2jDEv014DU
	 K7xHxaq2jmZQQfuJt2E/BYS9COTBj2Z2tIWj2o3U=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 4/9] mm/memory: Batch set uffd-wp markers during zapping
Date: Wed,  6 May 2026 15:14:59 +0530
Message-Id: <20260506094504.2588857-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 853CC16000B
X-Stat-Signature: dzoxqfsjye8smnnoqabgof67rdwk53hr
X-Rspam-User: 
X-HE-Tag: 1778060754-838422
X-HE-Meta: U2FsdGVkX1+P0VZtOFSfvOmnNQv5XwhrSssWyvfTDlIzMG633DTQx3K2r3pZirKJaC1Y5CKpXruCkgRP6AwxXykc5k1ZSLb+3ry0ZdAmSaSWeJXyKaUxjbwf/1uCHb7gjcXx/unO88fHKYL0JrZKJnr9vCc/0ipuIMXslceUMx988BkDPHcdFHxcxkO3+g6/1TR+Zxr2SCUK30wvOx1Y3Cs8j+WHzjqsqcvsDlEffTF8NADuCvIsZPd40tfZyEaBpXujbp/U6HTjZVXEuXAe7uZbesKS6EFjuJkPReq+1bYbQX51Gwh2NEKUtUcWl+QMbyRBWJSzT0zGhk2bxPFNsLTSKNt1IkXIzhcD05lhErHNZD+LhLW3/0k7sxZ460dYOqn8zUUOZSbWGYqLpgzzxGoS/TfN16FyckaR7r+K0y5IqXQ5+FFCWhR94zW/9d8pLfya1MC4FIphlsZuSU0EXJeSAJqDTq7BJ0vl7e/o9lCTKz/e0AIacf+m45czP7k5qORlcWfBrmNXyjYMMK7R70yjOtE9dNxT3/SwfcsdkmNh+5PtuFmMYEMiBgLsGQk5/7sJZOg35s+h8By1wQE/nBdD7FEYsYOnhZ0GBsXxvM9l2UlUgl7SdB5M9jnFTqOjMFdWV+dtd5jpA65zoYMNODie8uShdUjvXPxgvaSTgqWx5fFHWtsiZx+IFBNzF16Xqynt73V5W1p4BLSZkccuYpVVKOnehQJe3LEkP8hW1obdlGuj0lbChjqKSK1Jl+qGB4gnj0rHa3I2mP5t5DMbzdXsbWD0dBl0gPZiCACdSS5d3lSVdAU24cw6pOaEePKv4UrVzjZXO9OIEUmuiwPi7rQu7Qti4+npjzDL1jk6qmAhgsnqB5N0FyGzF497Nvnlcj+bndgtwE1Prh5N0AhwDSdA/51772xuUzxz9B+gE8//DVZxrXiftupJZqeoMa1nX+Fg5SUYEu3YMco3ZFt
 lW3DHIeh
 8INhSq38KvwlQXjMW8UA1+OD8Hpvrm23L3YSh0PZM18IxUQrdthV8KqIyw0z1KEgAISRuvmZp8ezsgtvdc0jeDNnUQL1hwv0/hMe72BVM56GIBi8cuJlWXKp7SnlPqZkoMyu0PvImMDOsYSU2W/okmFe7hpycKdq/vuFMwZjgQ/BE1+d0F8xdZaQpKJWX5dhsgnjL8CsOg24aHE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for the next patch, enable batch setting of uffd-wp ptes.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch or swap_pte_batch, guaranteeing that
all ptes are the same w.r.t belonging to the same type of VMA (anonymous
or non-anonymous, wp-armed or non-wp-armed), and all being marked with
uffd-wp or all being not marked.

Note that we will have to use set_pte_at() in a loop instead of set_ptes()
since the latter cannot handle present->non-present conversion for
nr_pages > 1.

Convert documentation of install_uffd_wp_ptes_if_needed to kerneldoc
format.

No functional change is intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm_inline.h | 34 +++++++++++++++++++++-------------
 mm/memory.c               | 20 +-------------------
 mm/rmap.c                 |  2 +-
 3 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f05..6f7ecede2fb45 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -566,9 +566,17 @@ static inline pte_marker copy_pte_marker(
 	return dstm;
 }
 
-/*
- * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
- * replace a none pte.  NOTE!  This should only be called when *pte is already
+/**
+ * install_uffd_wp_ptes_if_needed - install uffd-wp marker on PTEs that map
+ *				    consecutive pages of the same large folio.
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
+ * @pteval: old value of the entry pointed to by ptep.
+ * @nr_ptes: Number of entries to clear (batch size).
+ *
+ * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
+ * replace none ptes.  NOTE!  This should only be called when *pte is already
  * cleared so we will never accidentally replace something valuable.  Meanwhile
  * none pte also means we are not demoting the pte so tlb flushed is not needed.
  * E.g., when pte cleared the caller should have taken care of the tlb flush.
@@ -576,11 +584,11 @@ static inline pte_marker copy_pte_marker(
  * Must be called with pgtable lock held so that no thread will see the none
  * pte, and if they see it, they'll fault and serialize at the pgtable lock.
  *
- * Returns true if an uffd-wp pte was installed, false otherwise.
+ * Returns true if uffd-wp ptes were installed, false otherwise.
  */
 static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
+install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma, unsigned long addr,
+			      pte_t *ptep, pte_t pteval, unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
 
@@ -588,7 +596,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 		return false;
 
 	/* The current status of the pte should be "cleared" before calling */
-	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
+	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
 
 	/*
 	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
@@ -610,13 +618,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 	if (unlikely(pte_swp_uffd_wp_any(pteval)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
+	if (likely(!arm_uffd_pte))
+		return false;
 
-	return false;
+	for (int i = 0; i < nr_ptes; ++i, ++ptep, addr += PAGE_SIZE)
+		set_pte_at(vma->vm_mm, addr, ptep, make_pte_marker(PTE_MARKER_UFFD_WP));
+
+	return true;
 }
 
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index 0c9d9c2cbf0e0..f14311c4d2001 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1610,29 +1610,11 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
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
+	return install_uffd_wp_ptes_if_needed(vma, addr, pte, pteval, nr);
 
-	return was_installed;
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index bd4e3639e26ed..b17dce752a1ea 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2266,7 +2266,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


