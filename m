Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6A3C44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 06:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDDC6B008A; Mon, 20 Jul 2026 02:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEBD6B008C; Mon, 20 Jul 2026 02:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76666B0092; Mon, 20 Jul 2026 02:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A65896B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:55:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D22EA0734
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:31 +0000 (UTC)
X-FDA: 85008244062.13.FEF7832
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 744641A0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Qaff0VTp;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784530529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7c1Yk+hHQ2HDxf57jb6CPNcpr+lJLwgpPJM0hV6Hoc=;
	b=R4OV2YB2/9ifm54lgWNL3YSzVTc098dpjBlW09XTgDOy4xKcyezTkKfCB2W+VcxOQRJXGl
	Z8aUz8eAvVx5ZDZVlG0idN2DJNV95OEMY3RCXL83156TMUU4II4PHsqFTbVbFggz5P81mP
	JgE+D7ILq3IF9Xvha0liwBf+D8/LtiE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Qaff0VTp;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784530529;
	b=OezvhC1iquDZBJZCxWmxBCZiuulTSdOvA9vKppgWl6YsmdKcstmhxbx/hMQ5DA2N8OpRno
	BHn3Pd+OIuuWkuXxK7+gIv78Xox3pXpbnq7SbOKpfV1RCjIBfHgpSa+Hg3OXU/CdskYTva
	xNFKRoipjVUtKZ+Dqm62UpzynDY8quk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E8031516;
	Sun, 19 Jul 2026 23:55:24 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4F27E3F66F;
	Sun, 19 Jul 2026 23:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784530528; bh=x+kolBURkoz37XH2+zAgPHsgQcy0+7m0YaymnTdJ0PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qaff0VTprT/uptOom7N3m2o1wCp0o+NkCLqF5iaRvywGvdKWuFND+F0Pw1SF9HkcK
	 4sBQbnSEonmOtBPVtMQEGBXOPhYrB8lc8E8ijTlnnb7yULC0xYsop13Q4+CtKl3q+e
	 1rLTJnWy7LNGkaZLACiWro5kMo3Ygm8x9XolWf8c=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 1/3] mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
Date: Mon, 20 Jul 2026 06:55:05 +0000
Message-ID: <20260720065508.2695106-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720065508.2695106-1-dev.jain@arm.com>
References: <20260720065508.2695106-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 744641A0003
X-Stat-Signature: 7skek5d6zajx8wwqiwr46sxzeqpfssnf
X-HE-Tag: 1784530529-864479
X-HE-Meta: U2FsdGVkX19I2+d75Oau5TU5DxxHGyet7qRz9wMPBg+IBs5hnqWvxXtqaU+QTuo/Y4V+nNVqv2xdnhdTdjBXHchGVMnB/Mm51LtQ3O5s8QewQyIV57uAqGaVBI2JqXby0Hpc5kwKUCXrgaA5wWxnQGfEapVhV6qlmOFmgNdsIz67vyjBAiY6vaVOPGr9gX7kJW3d2Q+URmuRhVS0Q6mpnXrDYkMWE0WDpKnQ3huT9jR8iF7gM0t3oiveuXULvTA1wWXHoRueEVjXAMOfuA0lnpwvdyOjWA3YHI8PKBkPn4buuMKoPjThQKaNjNpGOoTiAvFM/bhVTtmuU7XPM6uzfulUPnE27xfA24uiLgvtXPs2Pg+/JY1vpquL2WOBYOWj7zelsiDAXH2Nwq4aBdZ3pH5+2RkjealPDn4/OHdmUT9+qSWyfh8GBw9xuiZoCB7/4r8yPc7cmMrIjXZv+L/emK4QYFIaCk8MZf0jBzuL23rCNkfFwHonxlZXarYJNAo1zwOaw4rsr7QlTnfSm1StOS/CfiF5uFtXwn+EiZNSn7m11OTggEKp87p3YDcKeU4aP72oGZCN35Q8EtzvLCXuMonGdP1m09gjj46f9AXNJUGx5MfTKUYnO8rbjhqzUovkwThWiBmDlX873exmSxfKxbfV4ybX8wUBL3R16NfgwWT8ThByQBZPuQw3Dul9EOr0kOLQklZJc/o/mHNp1xeA/TunRdUiyWSP6KDp08M+yA7zXBYv3MhKlebJA26z5zClO6cEVEymeXlI73H9iszJgjJYS9xkJzLYB5+PxXMh8PEzOXHaSCD6rf3/w9lDQdQPqGAfV6Lv+BLfHsvNlQi8jKNTCCg1nHe5moo2EWVzxgogQ9RNNb3OQ9CGofPXpwW8J1cP1wZY+AnDZ9Htd2bkUJ6FXWGohbA2XtkwsNC9TIAixLCnsDuTUYLdvhFRDXO3rz/F7BDFug+RhCsjWmh
 wBGhIEda
 7cN3gmAzOUc0LHNgcqR4RwqEdltc3VJGbzxZZgVDlHSpyVYo4xp7JfEbsNYldJ6RJ7+73qlw+MIX6hI3RjJLWVEMzf4JL4wjAC9QgSLoqRv7rDZF1YAp5OsMtzSI8Gn1B9yZGeKknphaG5c+nmB42ATkwZ1ZD7qdiOfANrQn3gkecnlW2tsmdAMG1NGU3p7vvQ1DvRrTFEJGcAElpoS2wKA9JvcKujJiGa28bTw5s3DgujHz7YgkR/PaalvaUR/uGDAacgKTGGSyUW7EQvP+Cxlr0HXg5Q3GwPvpnCpowArgzsDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_install_uffd_wp_if_needed() has grown too large for mm_inline.h.
Move it to memory.c.

This helper is only used inside mm/, so declare it in mm/internal.h
instead of a public header.

While at it, convert the comment to kerneldoc and rename the local
arguments from pte/pteval to ptep/pte so the pointer and PTE value are
easier to distinguish.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm_inline.h | 53 ----------------------------------
 mm/internal.h             |  3 ++
 mm/memory.c               | 60 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 53 deletions(-)

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
diff --git a/mm/internal.h b/mm/internal.h
index f26423de4ca28..b6a3589a61c1a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -276,6 +276,9 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
 #ifdef CONFIG_MMU
 
+bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte);
+
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
 	atomic_inc(&anon_vma->refcount);
diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f6920..6c0c4c774674a 100644
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
+		unsigned long addr, pte_t *ptep, pte_t pte)
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
+	 * with a swap pte.  There's no way of leaking the bit.
+	 */
+	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
+		return false;
+
+	/* A uffd-wp wr-protected normal pte */
+	if (unlikely(pte_present(pte) && pte_uffd(pte)))
+		arm_uffd_pte = true;
+
+	/*
+	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
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


