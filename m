Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E825FF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FED6B008C; Sun, 26 Apr 2026 08:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76666B0092; Sun, 26 Apr 2026 08:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64936B0093; Sun, 26 Apr 2026 08:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A50546B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:57:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68B9CA057D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:44 +0000 (UTC)
X-FDA: 84700708848.15.2176164
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5337516000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y9N+aXz56XMHlnxqo6ALkeCKfQJpI7gw8DFoQfw8SIU=;
	b=ez3u793TnVTAPXZDwwwlTTcA2E5NQinBi/+YoPXfpfrj8SWjJ31e3JZRV4NsrQhFJ5aRfc
	4P4hBMdlkflA4SK4jEiNBrD9qbYdBnYuulqPwFmEfNewm8WEx4evksMxsrwY5NeP2Qyt1Q
	/v57e6sBsCOyS1/v6ESutTNG3lstCV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208262; a=rsa-sha256;
	cv=none;
	b=afAn1vY6mzRuE3kMSNDd1305ZAezU/ysqTFjP2A+MrjcQd8lCogv6ud9wyL172RpT8TuLY
	mMoW9rnqB493RLoewgt7yf/bOY0QhqBZyzJPUO2Te6hARsseZtJ51RuDkZx3RGtj9UlLkK
	A0+4qcuS4uXKhjP+CmS7VsdcpgHhOFI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 123D26A7F4;
	Sun, 26 Apr 2026 12:57:41 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A351B593B0;
	Sun, 26 Apr 2026 12:57:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +LzUJcQL7mmtRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:40 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v2 3/7] mm: Implement folio_pmd_batch
Date: Sun, 26 Apr 2026 14:57:15 +0200
Message-ID: <20260426125719.24698-4-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
References: <20260426125719.24698-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 5337516000B
X-Rspamd-Server: rspam04
X-Stat-Signature: uo4h6zteh7skpsn3dzkjgdxm7wa1cog1
X-HE-Tag: 1777208262-769332
X-HE-Meta: U2FsdGVkX18BbCMce5dcfdvANCX8J0yVFsBnAsMj0IOFbEtWeIhxaFOdxkuVyV7cMoI9vmASo3J7wqMzVP1Cp7kvhcBhuL3QxdLeabDHjamh/3ORjYjIuKGIJl9uVNaCdr/Mre0PLR3kH+Hnhj65D1TQolqUiJwB1gKQYkRJ1z5Bt3u1URVneOzCmTg/cdFFA6iPssMB5Gin39nEgYPurs4Cz1AtCv1x3fwopK60X6/xEjB07HmvmgrcXuyBj2TwaBqtaGxV+JnwAyfEBdlb6l8/NZzuZtjiURpnPX7JsjTY9JVwHoQhsGwnwDHjWLgxRlhOL14NU1ciFMoHNuEawhKF+214SDNYC4zwLrGBijgytCMXn2S+go+J836HG13boygFYyA9lIAKLQN0y0kpnR5APMMApbfyUcY7Cfb1iWnW8Yj40XoBynjcOI8/Nom6jNMgWlCBB5OkPWuFjlqu08FSQjw+hsqCLwthqEGZWU0S0MEUC2tJc1jLm9ee/upVJQvx26tLbnV5I/oxc4Hzh1NwJTK0EIOGkzg04T0Ur0Nrxi90q46LBFeeTcF19RM2TRu5GuKN6XjESDROMqj4aOTGzkDFO+C1G2GVh54cXNxUKErkgK/586EdAxiL3dS9lEND4UUhZINP4SNNHbbtzuD0Lh5TEzMKCskWB6vEQxAPF/VtP0uJ5ZAUN6nooUnyIjGd5YASDhv9ewmBB7PK0izZ2phxxrbdrLY3+WFDnRfP+fJtBtr+IR3ZDaWkPAyyNLC6EpCtoWzH2DnR0LR7NSGhKSSct2amiHKzymlbKtDgmSnqSwbS/Ij8N9NMia+Tbny0Q/Hr/5ASsmUSeR7nin0J8XGCNrQn66yOaO9TsygbtOonyfGFig+bHbMqfjYEHiJT5o5uUCDhMjiymzaYGcLDUW8onEsZYHa5tBqqB/XI1lHlWqiYQhOrOgH9rsO/hlu5G3HSzcC4sh/RG+O
 G07YpGZK
 r3dULilhtTCyfrgP459bmICW7xxWh5nQ1C+ElvRk/w49lJCLW5Ux+Qn6a2urF2c+KBofkDv6iMjrNU2VQiR00biEsTOwRemnLT/ypdrXTLCOSiJ5wK297SiycWwwrrdF7beJZ0eI4PlELR7l78qjDJcjEJU19WuoTDqs/97bvFO7kXck=
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
 include/linux/pgtable.h          | 28 ++++++++++++
 mm/internal.h                    | 75 +++++++++++++++++++++++++++++++-
 3 files changed, 121 insertions(+), 1 deletion(-)

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
index 1abd9c52a4f2..ab43d0922ec1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -358,6 +358,34 @@ static inline void lazy_mmu_mode_pause(void) {}
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
 #ifndef pte_batch_hint
 /**
  * pte_batch_hint - Number of pages that can be added to batch without scanning.
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..488cb5c1e340 100644
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
+static inline unsigned int folio_pmd_batch(struct folio *folio, pmd_t *pmdp, pmd_t *pmdentp,
+				  unsigned int max_nr, fpb_t flags, bool *any_writable,
+				  bool *any_young, bool *any_dirty)
+{
+	pmd_t expected_pmd, pmd = *pmdentp;
+	bool writable, young, dirty;
+	unsigned int nr, cur_nr;
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


