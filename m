Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7711FCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA13D6B0093; Mon, 25 May 2026 12:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52286B0095; Mon, 25 May 2026 12:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41B66B0096; Mon, 25 May 2026 12:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2BC76B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:55:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68D601A0191
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:59 +0000 (UTC)
X-FDA: 84806544438.15.31D1A58
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7666040008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aKW76ywA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sAql24Id;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aKW76ywA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sAql24Id;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLljK19gyH6FPH1FidJAts1LMmk6IsCmEot0Hs+myqk=;
	b=fXiqudXaneDNfUOZWXqsGaqO4ZPl8AMu4Wo/uYDTc8R6vj0o+RJymDLuv5m6AUxVueq7iT
	1CZlzKfuQNslDzUzyj0gPlVckfjvuYz4AwYkRWHdVcDI1A5iTUtq72ILtr0VVXiOCLKQRv
	sNubU6tSLeeYjGVsm07/YCaEajSFQls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728157; a=rsa-sha256;
	cv=none;
	b=JajKLOVRVTRdfzP5aR2mHkStz+hM3R4Hs84zpxP7rpL+G3/nWwScpDlKF3ngyrxrPUsSNj
	OmP9s1dR5trcLYpHnyXNp56DDKpW57QS2VisI7ZhJNm1Ck4z30iMBGWSp9+SxKZMnJJrkU
	039UtyWcFEiw5rF7twXQutqacZbBkxg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aKW76ywA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sAql24Id;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aKW76ywA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sAql24Id;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6A0356BBD6;
	Mon, 25 May 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLljK19gyH6FPH1FidJAts1LMmk6IsCmEot0Hs+myqk=;
	b=aKW76ywAswJI2mh5YjDF795vfzbjL6d08OwANt24uT0WD50UYP3LR8OU+AIXN8F8I//dFe
	I351jcFoNlBgd46KEWMLj7ETQ/m57weD/0QP4KCgRUgtA0qwFh5inEuvtu95iKms4Iksc7
	dSAQj7G85KeGXEqGFpPPYP++RLcB6gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLljK19gyH6FPH1FidJAts1LMmk6IsCmEot0Hs+myqk=;
	b=sAql24IdVL8sOekVyeJInylSG9cX1yt1N5exo4PG/mkJ/45j9INALMajqKLOCikEhXK1kp
	0lC9paySvakWJHDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLljK19gyH6FPH1FidJAts1LMmk6IsCmEot0Hs+myqk=;
	b=aKW76ywAswJI2mh5YjDF795vfzbjL6d08OwANt24uT0WD50UYP3LR8OU+AIXN8F8I//dFe
	I351jcFoNlBgd46KEWMLj7ETQ/m57weD/0QP4KCgRUgtA0qwFh5inEuvtu95iKms4Iksc7
	dSAQj7G85KeGXEqGFpPPYP++RLcB6gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLljK19gyH6FPH1FidJAts1LMmk6IsCmEot0Hs+myqk=;
	b=sAql24IdVL8sOekVyeJInylSG9cX1yt1N5exo4PG/mkJ/45j9INALMajqKLOCikEhXK1kp
	0lC9paySvakWJHDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0703859D4B;
	Mon, 25 May 2026 16:55:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CA81OxF/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:45 +0000
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
Subject: [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
Date: Mon, 25 May 2026 18:55:23 +0200
Message-ID: <20260525165528.184397-4-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: qxh1exfwe3ngig9k3hixge7aj4afk1xo
X-Rspamd-Queue-Id: 7666040008
X-Rspam-User: 
X-HE-Tag: 1779728157-78122
X-HE-Meta: U2FsdGVkX1/uykIvSMFkSxwY0Fx0loa/89/TqE0j2Ys8rV6uVuvvs3NNGZ7pol39bHVaR5NJ0Kg3uBR94lESnLLcJusZo20q5+7EdLqJo/Ph3AyjerZBeS4J09W1jrdamaxUkonh/aU11MAR7MNwUPcP3oRmgz2PFSMkUaWPiC2agDzcKqPsPXdR2ysa17l1TDVI8U9CdMVtVfdbX8xGZqIpw8Ooow2T9F9wbE5NYYO9lNg4frhWYA/ucRPdTrN8F5WrVYTEk1WNAqCLrJKrDnw7djokCo7DnLXwK+/YWbxltLwl6Fj1MFi4ZFZpZkvEjUwtjt7eLSSLBI/TY22U1XtWPGo+pQtIYXP7Sc2gPyF4EiH9Xlw0kCdIvBcStZ9oyoe+j2CQChX04W7R7uPFx9eUMlfQcgns7r/zqQQUghmVeSOS1cncmMo3hP5PBOiltGg28y3cnZ5nZKBmGOj9tGs3m07wFaTHHdk2QXa27B/GpIjEGiWsHVZIsQCjpDDwoYBplVt+fPTmO9quBBaCJZ2/9AKQwZD1PQg0rdMpS01STChe5h6UDemjyg3r4Gajx5pXv5B+KGQ7nlbD4T9OwV/ZBjtV6lRvfY4SNAi2Td7IBMy/lowRqViz1iTsynsZ42UFJJfWGgLhdHFRVLdtnqcetnAH61RfcD/+o3o2voQCTf93Q8CV8IEomHtYqT6kWSuk1sIi8P2XTV29KzBX/Zd+6VxpyZ6SSI86TX8iIa4vYOjJAxtjqNgYkdwZoGZKoYsvdLlb8d/jaU8vON2N0Ehg3ro8AX3kYJSPtv3ggZtQI9sm54fpPSRrFglTlBGyGFXJjferuEz3J2wuE/IGnZ7Ww7XygadPwhibgpdnmYos10JNhXl4PkAPie6NCoTlc9YvrkAkWVN8TkNj0BnRaN5J0rNyKAsJ14J/R/yNQ3iFgX1XCas9vbUaEXU4Yd2O1ErP6MK/lIMqjjWMUzG
 3WvvbaeS
 wR1qc2+qh4nARgQyioGZsrL/ukgp49Squekfe9JxTXwzwqCCPIfkLvULGc+C6Yztl37/EiX7485j/XhR8Aj69fufL7CulREiR4HD0aIvMvB3bYppxicIL6+V3zAGm/e8OUa876cV3lQju6MzXgzwlMmB53JSle5wl2Nqei9Z4suOKxIle1SaRDABgl3ceuE62rWpP9P/Uf/XhKrmynzJ9iolihAu5o6o0kVm+obDh11d6Hi1GR9rt9MfwIl7eBzCatIjUKQf15aYyUJcTs6CxyFe9nSG74Rz8mfWVcHsB56O2viQUlHhQIxd7Gw==
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
index ca0f1fcae7e8..08ae4ee7d1da 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -164,6 +164,8 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 	(__boundary - 1 < (end) - 1) ? __boundary : (end);			\
 })
 
+#define pmd_valid_cont(pmd)    (pmd_valid(pmd) && pmd_cont(pmd))
+
 #define pte_hw_dirty(pte)	(pte_write(pte) && !pte_rdonly(pte))
 #define pte_sw_dirty(pte)	(!!(pte_val(pte) & PTE_DIRTY))
 #define pte_dirty(pte)		(pte_sw_dirty(pte) || pte_hw_dirty(pte))
@@ -669,6 +671,12 @@ static inline pgprot_t pmd_pgprot(pmd_t pmd)
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
@@ -1656,6 +1664,17 @@ extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long ad
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
index 70aae957be5b..f5291f9ce583 100644
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
index 5a2ddcf68e0b..9a0f9e89b054 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -270,7 +270,7 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }
 
-/* Flags for folio_pte_batch(). */
+/* Flags for folio_{pmd,pte}_batch(). */
 typedef int __bitwise fpb_t;
 
 /* Compare PTEs respecting the dirty bit. */
@@ -294,6 +294,79 @@ typedef int __bitwise fpb_t;
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
2.53.0


