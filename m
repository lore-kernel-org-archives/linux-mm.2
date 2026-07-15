Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C82EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094ED6B00D3; Wed, 15 Jul 2026 09:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D046B00DD; Wed, 15 Jul 2026 09:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77596B00E0; Wed, 15 Jul 2026 09:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A75916B00D3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:47:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3E5A1C0032
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:19:01 +0000 (UTC)
X-FDA: 84990764082.04.1A3CE18
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CDB26A000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:18:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uKHK81Vu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/VBhPK01MeYx6vLCmjfrGoLn5wvn70sO6Tn27zDnhk=;
	b=CLahY3lLSpvDx5GHWNeulC2yiwKJWaWwHrcfxup56CVCQO96/XVd75kyFWlPqgOq8JgnRS
	K06aXZhN0sbKYsqevkCT1jObK9c5UJJ5P9LYi0EGVhJ2h1d8vQC6yK8t2u63xGuUZYPaNi
	6iGv2RO6y0bwLtO/bV4YsdgN3DbCwvo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uKHK81Vu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114340;
	b=RLhoQbBYouZDEA6DzL7EAZyVzilBjBBanLiKTnEKUz8s1NLnuxmD9RdVUD6KC63p4fnJWD
	AVaGZrHzcwrucT9zYzjA18KzJnL0UVsVbLklqCL9NMIG1rldK49ie9WwRhfQepnJa04uj7
	xVmScGAGpy5SXpkMT3fsqnYFsQnOTss=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8284D2F;
	Wed, 15 Jul 2026 04:18:54 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B4BFC3F915;
	Wed, 15 Jul 2026 04:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784114338; bh=M7nWun3z+db3sBAe7iYaXrTLAK9O6JS/QNOYDD0lRw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKHK81Vughycr2Fec3IOhaO6pqa5BpmtEOeHailq6wIswGpOLQ4C+aaS9XlvZ0xbi
	 nEHkhqvkygf3VZQBfxA4v7HvSZi4GAEOBqlquC8V4znMgkmNArWBoC2zW38CKyjnwH
	 /FUcGpSp76LzA+o93S4NTnGtMkhs3dE+dUq+rIrU=
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
Subject: [PATCH 1/3] mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
Date: Wed, 15 Jul 2026 11:18:34 +0000
Message-ID: <20260715111839.1667914-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715111839.1667914-1-dev.jain@arm.com>
References: <20260715111839.1667914-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CDB26A000F
X-Stat-Signature: rxbid5jmgi37f9k3yzxm8hsz9kfbasnu
X-Rspam-User: 
X-HE-Tag: 1784114339-49067
X-HE-Meta: U2FsdGVkX1+OAUCDNm53W+RvCThL3MPQI3NDV6J4QJF5vLjwqOJ9REZk9iL7SpvEpUmcUXEC0ScGXqTvLWqj+0HKIJDaI6Mds6K7BDYPt8FOdSE36/bMHxQAm7eMXqFErb2CQ4EyIOnSTl6wtJ2GEVujSYIBib2kBeAls5PGhLvXTxSLoQDU8fFrsLrtK1BPlwq5Z/HlGt+p3urE16npePUVjqS8F/GNB8+s157fhVPw179arMrF8ZvJp0R+WRCD7McFR3U+4sZBwko+Nqj7T1dGZb3mghJ3mNzO+sq5vv91C9znbMAMb6lxXVpwkjtXaThVFRSkXhcSohhl3GLeqOk1NZ99X8a+IPlm4kBzelTEEobeIcoXHdGMk55G/Yp4Sr0nL6naYfmBfes8f3Su/HZ3NbeImA9J4NkEBP7UxZK/7H8m9dp42WUgtzA8VGPd1Ozgej8uyxo+xLW6I8Hds8ei8hpTLjQgMJNEWnkXFJ354EqbqNVHNOsZWgSA0mpDfnI0V0tepxQQxJA68AVrDmp6VcHuESakzYRMHFb+gp14IQHyEjkuPwP4PdoZxp100R0dJfaTUt6YwU/TX8Urv/baBExTQcBID4YOqk3yS6umefZd5W9riOpFufOqG/9DmJmpyOM7vwrTGy/yBcWnWWEjiPGGyU8OFBYbNUm043iTMsnf/wuYrrOadKTyVtvoA5gbdRW6xdm+7NlQPhMsfwotZPbE9FpztdXi8jztC059qDUTe/nYMkcs5TPqW9UuJ7GGQ0BAX+D36a34G/HukXK442496MXzzEX9NiTll8Ez1rxgFVd4GtIi4psp3qEmWQEh5yYKKCK8F00kEwiGUYg/1HdjxlN02ylHHmv19dGk4HpHl2N6jsh5FHot4iyqdzQiEdqlZfbcNM3/Nf+VJz1Tb7y1R+buXIeHzkRH2bWLMTn+B5g4G0Kmg806cPYsJ8cCAB/7XnfSKI6+Mmz
 jJdiZDsT
 HnWGjKHM/9iDJX73MOoNfY/4MX4cL3wAcDzmffeDErZGs/U5dRiFyAkrWpHoLFlRl1Ta3EX4Bb2PC3lLh2IHVsjWF2PagTa9HLJEricCfk+IzwnGYuY1Ov7z1sJ7UYvfjfoj8B+3jgOakSMdj6CzYHy/v0c9Nm5pVxjcIHguc7hlxholm1o7S05OBX6DylVrUpIZsYBtxiWRGa51A62VIZMPWLecTxljdA1oxKSDvcUNIJEK8lccn0dVqpaJEq/H3WK4TDIWjsn/N6bXwbxJCN4cE+wBJfPZ7bDJygxyq9pNCSi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_install_uffd_wp_if_needed() has grown too large for mm_inline.h.
Move it to memory.c.

While at it, convert the comment to kerneldoc and rename the local
arguments from pte/pteval to ptep/pte so the pointer and pte value
are easier to distinguish.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm.h        |  2 ++
 include/linux/mm_inline.h | 53 ----------------------------------
 mm/memory.c               | 60 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 53 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 550fb92957d18..a71341c44655e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5406,4 +5406,6 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr,
 		bool uffd_wp);
 
+bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte);
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b5c4dc0f3fe32..621c8653d8f7e 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -566,59 +566,6 @@ static inline pte_marker copy_pte_marker(
 	return dstm;
 }
 
-/*
- * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
- * replace a none pte.  NOTE!  This should only be called when *pte is already
- * cleared so we will never accidentally replace something valuable.  Meanwhile
- * none pte also means we are not demoting the pte so tlb flushed is not needed.
- * E.g., when pte cleared the caller should have taken care of the tlb flush.
- *
- * Must be called with pgtable lock held so that no thread will see the none
- * pte, and if they see it, they'll fault and serialize at the pgtable lock.
- *
- * Returns true if an uffd-wp pte was installed, false otherwise.
- */
-static inline bool
-pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
-{
-	bool arm_uffd_pte = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* The current status of the pte should be "cleared" before calling */
-	WARN_ON_ONCE(!pte_none(ptep_get(pte)));
-
-	/*
-	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
-	 * thing, because when zapping either it means it's dropping the
-	 * page, or in TTU where the present pte will be quickly replaced
-	 * with a swap pte.  There's no way of leaking the bit.
-	 */
-	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
-		return false;
-
-	/* A uffd-wp wr-protected normal pte */
-	if (unlikely(pte_present(pteval) && pte_uffd(pteval)))
-		arm_uffd_pte = true;
-
-	/*
-	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
-	 * existing pte marker with uffd-wp bit set.
-	 */
-	if (unlikely(pte_swp_uffd_any(pteval)))
-		arm_uffd_pte = true;
-
-	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
-	}
-
-	return false;
-}
-
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f6920..98b3ace15cef2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1675,6 +1675,66 @@ static inline bool zap_drop_markers(struct zap_details *details)
 	return details->zap_flags & ZAP_FLAG_DROP_MARKER;
 }
 
+/**
+ * pte_install_uffd_wp_if_needed - install uffd-wp marker after clearing a PTE
+ * @vma: The VMA the page is mapped into.
+ * @addr: Address the page is mapped at.
+ * @ptep: Page table pointer for this entry.
+ * @pte: Old value of the entry pointed to by @ptep.
+ *
+ * If the PTE was write-protected by uffd-wp in any form, arm a special PTE
+ * to replace a none PTE. NOTE! This should only be called when the PTE is
+ * already cleared so we will never accidentally replace something valuable.
+ * Meanwhile none PTEs also mean we are not demoting the PTE so a TLB flush is
+ * not needed. E.g., when the PTE was cleared, the caller should have taken care
+ * of the TLB flush.
+ *
+ * Must be called with the page table lock held so that no thread will see the
+ * none PTE, and if they see it, they'll fault and serialize at the page table
+ * lock.
+ *
+ * Returns true if an uffd-wp PTE was installed, false otherwise.
+ */
+bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
+				   unsigned long addr, pte_t *ptep, pte_t pte)
+{
+	bool arm_uffd_pte = false;
+
+	if (!uffd_supports_wp_marker())
+		return false;
+
+	/* The current status of the pte should be "cleared" before calling */
+	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
+
+	/*
+	 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
+	 * thing, because when zapping either it means it's dropping the
+	 * page, or in TTU where the present pte will be quickly replaced
+	 * with a swap pte. There's no way of leaking the bit.
+	 */
+	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
+		return false;
+
+	/* A uffd-wp write-protected normal pte */
+	if (unlikely(pte_present(pte) && pte_uffd(pte)))
+		arm_uffd_pte = true;
+
+	/*
+	 * A uffd-wp write-protected swap pte. Note: this should even cover an
+	 * existing pte marker with uffd-wp bit set.
+	 */
+	if (unlikely(pte_swp_uffd_any(pte)))
+		arm_uffd_pte = true;
+
+	if (unlikely(arm_uffd_pte)) {
+		set_pte_at(vma->vm_mm, addr, ptep,
+			   make_pte_marker(PTE_MARKER_UFFD_WP));
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * This function makes sure that we'll replace the none pte with an uffd-wp
  * swap special pte marker when necessary. Must be with the pgtable lock held.
-- 
2.43.0


