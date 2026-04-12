Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267CDE937F6
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A9D6B00A5; Sun, 12 Apr 2026 13:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD116B00A7; Sun, 12 Apr 2026 13:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BBEF6B00A8; Sun, 12 Apr 2026 13:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0776B00A5
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:43:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5E0B8C6E8
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:22 +0000 (UTC)
X-FDA: 84650625444.03.ABACAB4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8AD7CC0007
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FCALKoAo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="R6s6/rPi";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FCALKoAo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="R6s6/rPi";
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776015800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YmowN5FH0Kg0mhxzZsHNC6X9cqrKQWei1fJR8Huzcs=;
	b=aw1zfI4kG8T74cISKsbHx58d6Uhed264wNH9EE+mYpPbjALLFT0SZNn9boWG1/c9bNmyqE
	/evo3mhEY9bWtyoXjMjUYVxaWsfnzp8UoMtZl4hWiwJ0nz1m5XRCD6gCIZsltTOMz3h2Ee
	h9zOH/DaoZuy/jxPg54qs9c8ypR4Czs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776015800; a=rsa-sha256;
	cv=none;
	b=bbjIQhKK9uhi1HMrG1gHZzNZnuR6jm1XR0zlvpswyDh0YGEA4dHuvDvVqGqLuMhIS85IJz
	vyLRwmsTaKmHjRlu+0ucG1Uy1hb3BU2vSTLnaWSoa8XQwQ7EmxcqO57PVH7kq4uVYmkaWc
	wOien9CS+wEXIDaPZlVDCfaTV/7UoZU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FCALKoAo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="R6s6/rPi";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FCALKoAo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="R6s6/rPi";
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AEEFF5BD85;
	Sun, 12 Apr 2026 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YmowN5FH0Kg0mhxzZsHNC6X9cqrKQWei1fJR8Huzcs=;
	b=FCALKoAopvvuIaahjF6Hlaljhy4ZVBYgzZ+q83vY4tTTFr6SyVlll5F6K4IPS2PgTHU+uY
	x0A1QNBEab0oLxDXKnV1lgsT+yitSB5MqTFl/tlJ6tyrhccbVeWyEjWUcP73Copgkgn8Xs
	+twjdbk9Xqq9o83sscmatGlfuizUn8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YmowN5FH0Kg0mhxzZsHNC6X9cqrKQWei1fJR8Huzcs=;
	b=R6s6/rPiYD4W6Ta4jyOWgHOV7PPVjivoTuKYszaxdnMCqsvvx7K4cKkhJiCezIX0OikRbB
	UieUFhzX+Bq/OWBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YmowN5FH0Kg0mhxzZsHNC6X9cqrKQWei1fJR8Huzcs=;
	b=FCALKoAopvvuIaahjF6Hlaljhy4ZVBYgzZ+q83vY4tTTFr6SyVlll5F6K4IPS2PgTHU+uY
	x0A1QNBEab0oLxDXKnV1lgsT+yitSB5MqTFl/tlJ6tyrhccbVeWyEjWUcP73Copgkgn8Xs
	+twjdbk9Xqq9o83sscmatGlfuizUn8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YmowN5FH0Kg0mhxzZsHNC6X9cqrKQWei1fJR8Huzcs=;
	b=R6s6/rPiYD4W6Ta4jyOWgHOV7PPVjivoTuKYszaxdnMCqsvvx7K4cKkhJiCezIX0OikRbB
	UieUFhzX+Bq/OWBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 378574AA4A;
	Sun, 12 Apr 2026 17:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qIEMC6bZ22miRQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 12 Apr 2026 17:43:02 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH 3/7] mm: Implement folio_pmd_batch
Date: Sun, 12 Apr 2026 19:42:40 +0200
Message-ID: <20260412174244.133715-4-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
References: <20260412174244.133715-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: 6bkx5np8jyxbjt1uo6ufebktquqoo1s8
X-Rspamd-Queue-Id: 8AD7CC0007
X-Rspam-User: 
X-HE-Tag: 1776015800-300792
X-HE-Meta: U2FsdGVkX1/rtgxGD7B9kgHKj5N3xb2MA8wKJD9HQLd8fKgQtweImCa2kaEYxnXtV92469b5zmh0wyjHY5yUXe+9q9zrjgppNFFYotJBxtcElWUr2KCjZeS83z46TD4QUzviRLV+hEIgaLfofVc3UQv9j7TVCfvi3aPRu6FP8uj28OcYPYKv0yNuKAVoibp02eN9EBxO04srKi1P3//p0rnm/r1rQd0gBXifT9xt++KGK6LFkc4WrVRbswjl+oqqGpg6bflptNoOkyJ8/U3q/4IZoRdiJuCNbiaJHeHpA+XHhAW57PXsImEZPlocjeCPQLPBLtE/L509cmTybM+yE8OcgtzY0rNazARy6Y4DxsI55fH1aUtvca4jFfP6b6jaIRs1uezuUNNAcKlZdL2rNJmshIN8QRBKqM8KzE8bbyn4AMl/D17IOwdpkyKBQDterAj23+8oxvsN8Px6JmQ2DfvJXe1n36HXhHAGLNCVKu7vaK8kJy/1TyZQEmtxepNNVOpPpPQ3VHZo1Uhec8/gQEIL2Ox9FAWu3lghmB/GBa1vQyxoabrOOMjwWBXgyznSQRP7o2ZIKSjIJbf9d116V5NTTUwhuKTSBkm7wRGS3F2tfKQ/yaWsa1m5/SX+zIF/okUSuVBRzCCcm8hgORoc/kKKyf8X5WRAN0/hLB977GzC31ng4KKycOKPKPPb5rf6cX6WmCtIeYXo7BBvY1L0gOKNSeZMoKh1srd10JYX/x7g9HyHFq0VgIBuFSJw9UtJlH1X9wqCwXOElnMi0E1Mjt/rJfV3hHakwrJfyY/y12XffWDSnvr/1xidzFvgtaQAIVdm/OGUVx13JwjAh4JvH9vuqMINT1sfjdIWt+vj00dS8StFHNdSwVEYrq3oEuNrVA0I3f6GL3jDJwP72EQ9yrm7Ytttc11isk+cakp3ehCFCN6A6YqBHu6XJodyJAOse4ZZZrqwe+VeUSAKsi5
 UJsNlQKA
 5Sf9YIs9D/EcFI3s0R8YGpj1X9VZ9c0qnlGZjvfrP9VgNq1XoJBRaRQ7bd24g6umyPv+WcZXeZr/W5M/ZaZACt4eBpV0iUCke7/kY5kdhbW7OIsKznCH+2/hk4ZNH6SITL6dlivrTgB2/7FRgSAHtmi4u5P01rySCJMSMpwpHqbTitsaIZbQeCEolL2TXfHGY3rR15YnqnNkeKS0khMJfuA+U0CS464g5rO/vdUKNo63rYDNon42LvsxDQJhP0ph6NUqQDIlQsomecmv+XUiCSy2srwpXunkYwqly3pVue1wrIDHVqsIU2iMqQxnSuI3sfOaDq+VQPr6tMwgHQqachpfu8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB can be mapped as contiguous PMDs, so we need a way to be able
to batch them as we do for contiguous PTEs.
Implement folio_pmd_batch in order to do that.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/arm64/include/asm/pgtable.h | 19 ++++++++
 include/linux/pgtable.h          | 30 +++++++++++++
 mm/internal.h                    | 75 +++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e42ad56a86d4..5b5490505b94 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -170,6 +170,8 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 	(__boundary - 1 < (end) - 1) ? __boundary : (end);			\
 })
 
+#define pmd_valid_cont(pmd)    (pmd_valid(pmd) && pmd_cont(pmd))
+
 #define pte_hw_dirty(pte)	(pte_write(pte) && !pte_rdonly(pte))
 #define pte_sw_dirty(pte)	(!!(pte_val(pte) & PTE_DIRTY))
 #define pte_dirty(pte)		(pte_sw_dirty(pte) || pte_hw_dirty(pte))
@@ -670,6 +672,12 @@ static inline pgprot_t pmd_pgprot(pmd_t pmd)
 	return __pgprot(pmd_val(pfn_pmd(pfn, __pgprot(0))) ^ pmd_val(pmd));
 }
 
+#define pmd_advance_pfn pmd_advance_pfn
+static inline pmd_t pmd_advance_pfn(pmd_t pmd, unsigned long nr)
+{
+	return pfn_pmd(pmd_pfn(pmd) + nr, pmd_pgprot(pmd));
+}
+
 #define pud_pgprot pud_pgprot
 static inline pgprot_t pud_pgprot(pud_t pud)
 {
@@ -1645,6 +1653,17 @@ extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long ad
 				    pte_t *ptep, pte_t old_pte, pte_t pte,
 				    unsigned int nr);
 
+#ifdef CONFIG_HUGETLB_PAGE
+#define pmd_batch_hint pmd_batch_hint
+static inline unsigned int pmd_batch_hint(pmd_t *pmdp, pmd_t pmd)
+{
+	if (!pmd_valid_cont(pmd))
+		return 1;
+
+	return CONT_PMDS - (((unsigned long)pmdp >> 3) & (CONT_PMDS - 1));
+}
+#endif
+
 #ifdef CONFIG_ARM64_CONTPTE
 
 /*
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 1abd9c52a4f2..6f01d5ed73f6 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -358,6 +358,36 @@ static inline void lazy_mmu_mode_pause(void) {}
 static inline void lazy_mmu_mode_resume(void) {}
 #endif
 
+#ifndef pmd_batch_hint
+/**
+ * pmd_batch_hint - Number of PMD entries that can be added to batch without scanning.
+ * @pmdp: Page table pointer for the entry.
+ * @pmd: Page table entry.
+ *
+ * Some architectures know that a set of contiguous pmds all map the same
+ * contiguous memory with the same permissions. In this case, it can provide a
+ * hint to aid pmd batching without the core code needing to scan every pmd.
+ *
+ * An architecture implementation may ignore the PMD accessed state. Further,
+ * the dirty state must apply atomically to all the PMDs described by the hint.
+ *
+ * May be overridden by the architecture, else pmd_batch_hint is always 1.
+ */
+static inline unsigned int pmd_batch_hint(pmd_t *pmdp, pmd_t pmd)
+{
+	return 1;
+}
+#endif
+
+#ifndef pmd_advance_pfn
+static inline pmd_t pmd_advance_pfn(pmd_t pmd, unsigned long nr)
+{
+	return __pmd(pmd_val(pmd) + (nr << PFN_PTE_SHIFT));
+}
+#endif
+
+#define pmd_next_pfn(pmd) pmd_advance_pfn(pmd, 1)
+
 #ifndef pte_batch_hint
 /**
  * pte_batch_hint - Number of pages that can be added to batch without scanning.
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..8fa0681ff2af 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -269,7 +269,7 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }
 
-/* Flags for folio_pte_batch(). */
+/* Flags for folio_{pmd,pte}_batch(). */
 typedef int __bitwise fpb_t;
 
 /* Compare PTEs respecting the dirty bit. */
@@ -293,6 +293,79 @@ typedef int __bitwise fpb_t;
  */
 #define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
 
+static inline pmd_t __pmd_batch_clear_ignored(pmd_t pmd, fpb_t flags)
+{
+	if (!(flags & FPB_RESPECT_DIRTY))
+		pmd = pmd_mkclean(pmd);
+	if (likely(!(flags & FPB_RESPECT_SOFT_DIRTY)))
+		pmd = pmd_clear_soft_dirty(pmd);
+	if (likely(!(flags & FPB_RESPECT_WRITE)))
+		pmd = pmd_wrprotect(pmd);
+	return pmd_mkold(pmd);
+}
+
+/**
+ * folio_pmd_batch - detect a PMD batch for a large folio.
+ *                  - The only user of this is hugetlb for contiguous
+ *                    PMDs
+ **/
+static inline int folio_pmd_batch(struct folio *folio, pmd_t *pmdp, pmd_t *pmdentp,
+				  int max_nr, fpb_t flags, bool *any_writable,
+				  bool *any_young, bool *any_dirty)
+{
+	pmd_t expected_pmd, pmd = *pmdentp;
+	bool writable, young, dirty;
+	int nr, cur_nr;
+
+	if (any_writable)
+		*any_writable = !!pmd_write(*pmdentp);
+	if (any_young)
+		*any_young = !!pmd_young(*pmdentp);
+	if (any_dirty)
+		*any_dirty = !!pmd_dirty(*pmdentp);
+
+	VM_WARN_ON_FOLIO(!pmd_present(pmd), folio);
+	VM_WARN_ON_FOLIO(!folio_test_large(folio) || max_nr < 1, folio);
+	VM_WARN_ON_FOLIO(page_folio(pfn_to_page(pmd_pfn(pmd))) != folio, folio);
+
+	/* Limit max_nr to the actual remaining PFNs in the folio we could batch. */
+	max_nr = min_t(unsigned long, max_nr,
+		       (folio_pfn(folio) + folio_nr_pages(folio) -
+		       pmd_pfn(pmd)) >> (PMD_SHIFT - PAGE_SHIFT));
+
+	nr = pmd_batch_hint(pmdp, pmd);
+	expected_pmd = __pmd_batch_clear_ignored(pmd_advance_pfn(pmd, nr << (PMD_SHIFT - PAGE_SHIFT)), flags);
+	pmdp = pmdp + nr;
+
+	while (nr < max_nr) {
+		pmd = pmdp_get(pmdp);
+		if (any_writable)
+			writable = !!pmd_write(pmd);
+		if (any_young)
+			young = !!pmd_young(pmd);
+		if (any_dirty)
+			dirty = !!pmd_dirty(pmd);
+		pmd = __pmd_batch_clear_ignored(pmd, flags);
+
+		if (!pmd_same(pmd, expected_pmd))
+			break;
+
+		if (any_writable)
+			*any_writable |= writable;
+		if (any_young)
+			*any_young |= young;
+		if (any_dirty)
+			*any_dirty |= dirty;
+
+		cur_nr = pmd_batch_hint(pmdp, pmd);
+		expected_pmd = pmd_advance_pfn(expected_pmd, cur_nr << (PMD_SHIFT - PAGE_SHIFT));
+		pmdp += cur_nr;
+		nr += cur_nr;
+	}
+
+	return min(nr, max_nr);
+}
+
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
 	if (!(flags & FPB_RESPECT_DIRTY))
-- 
2.35.3


