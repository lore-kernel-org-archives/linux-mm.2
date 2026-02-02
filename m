Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6235D172AE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2C16B0093; Sun,  1 Feb 2026 19:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55846B0095; Sun,  1 Feb 2026 19:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9696B0096; Sun,  1 Feb 2026 19:55:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7FD6B0093
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2070D8CB09
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:35 +0000 (UTC)
X-FDA: 84397698630.24.6E46854
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 37E09120007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GrzW6WYH;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiaAYLnp++F+oMGcZPU7KISbq82XKW6g9VibgjyCto8=;
	b=DXbV5bcSCsRb+QlOlXcRG1lAIKn7sPRPaSFEnrCydoRN42HWqD7r39y2rerUtE0vy6yXIe
	Io4IOMoOTs+Y2W6sIbBh/Fos/VH7+eOMaFGlt6+SXHaEirtfrvxpfqKqEAhX4LYFMBFmE3
	fKpZ+VdaibfuEd888IU5sq+X9AGBpJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993733; a=rsa-sha256;
	cv=none;
	b=C5s0eMuSoJKBGh3PpZtTnXCCukYQ3fsV0ywS3TmRKnn7eJ+x6QvuYbpCdj53WDa4NfJXY6
	N4MMcED+PpxLiFCLP6zJwoFk2zuNfER0EWNniodHUp/NTN6Ha3+tjw7LhxfJ0hH72qRxFI
	R8cj1pH3Ts0Qr3IzVOnbitIQO/V0I2I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GrzW6WYH;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cfd95f77a3so2600404a34.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993732; x=1770598532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiaAYLnp++F+oMGcZPU7KISbq82XKW6g9VibgjyCto8=;
        b=GrzW6WYHcDvPbBL73s/8iFMYkswRy5Ot1mVFZ2Q7v4KhyYkmHnmJdYMGMlMVRnJiXE
         SHX7EGTylc34oQ4b4svjhRkFgiaOjakq84UuTzTQEEbvVe0ZRcMwYGdOtvuUrTA0+ldi
         3qoV790908PW/tMJWj+4hQOUyGhSNtGpNjxrq1UnWF5PtDvIomG+GqgGnVOIDE0HBV4w
         CAHR4cD9246gKNP8v9QrIga1s5cuFGqRgCI8cMsfz+FyhBKAcOBGCDR0UigeQyB6j0TS
         +wG8D7xt882PzLI60599sXF3F/tiwj5WWv2svyuEZOSu/7OU35MqBscAKVk9D6rozjQ9
         qg9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993732; x=1770598532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SiaAYLnp++F+oMGcZPU7KISbq82XKW6g9VibgjyCto8=;
        b=nk0aP01c7dCn0k0v+K1I6ZeLUaMHDLhvslY7BzUUUR3mKBceQW960MlZ9XyBCS9eTe
         Sxe+aXEjNXHnJdY1SIVxqI305Qs8VQ2xlbSKJw8yUeAh+1JHMiYJsILWdKiV4cWuAXX3
         6PZt39H3aPbILlWiLF1tkN5q/wnPCVWK8Fa2CIU3FVCQ4TgqQNbNRlmzzl5d4cFQLvp0
         Eahnhk5ZWS6DlKH3fcUyhrDJSjvEdeqDkmM8JzW6jufNgJmRl9g9r410o6ze0RPk2wnM
         sU2Ck782WNvMorAKHKZIrHRjokXIWAZG29m+f5HhSOoKV2ogtRqDjs749GXM6lFIg+ag
         ytHA==
X-Forwarded-Encrypted: i=1; AJvYcCXIx+ZZAAG5RxVdpu8rd8wVjjQ1/ClYfT2RMa0xxk7D9VvwJBWGttWnDhatxMjV4F+7ny7AQlFH+g==@kvack.org
X-Gm-Message-State: AOJu0YylH8vI778Xxal4vm9Mq9+gRaPkZIcGTRG8Iyz6lhZO4+rkVXeF
	E1Fp+ULIiGyEzKgejhHV9WwoeXfEyoX+9kay/6khkvl1Rnx518NrcB/3
X-Gm-Gg: AZuq6aLzaaiwbHbj1T8fPpybO+yJm8+KA9n0Fe+mbvgjJH5LAZ3cvd1uiKAhTyvpBkp
	mL30nxGjq/AtnYWy6XnD5covwqJlUSnEY8EsOI18ngD+gtIScSjgdPXBO+S0h8iAiXTrBvUrjmb
	ReoJVVyzvJbHiwrak85/t2aHq9XJ8PBmjlOaSnJ8Lo062R/MGuj7FKiaquDTwZs8zDTDCDp1vqz
	53QGoN1ZFnLHvTNBFPwNBW283OIhNToreKhwEafOuYxxLdq4CqF+8eHk6nzItjY5T6w+QG5nGzO
	ruSAHY7UqMk+fkEMghmM9isbZdXP0ARfEaSorPMvb+h46bozu/VVZCBZL93FOZLI6qod13rmkWm
	WeQn/FMdn6n0qbhzWAFiblbI/SXzqp6+bOrj8k90lB3vzfTt5eNndlODNOWDE+qqHJwNkfIEIxh
	0wSBfV61Mw
X-Received: by 2002:a05:6830:63ca:b0:7d1:8e24:724d with SMTP id 46e09a7af769-7d1a53d3833mr6441202a34.38.1769993732151;
        Sun, 01 Feb 2026 16:55:32 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d1a6dd4423sm5572396a34.28.2026.02.01.16.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:31 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 04/12] mm: thp: implement PUD THP split to PTE level
Date: Sun,  1 Feb 2026 16:50:21 -0800
Message-ID: <20260202005451.774496-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37E09120007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1sajwit65nrwnqbtquo1m18ru7ygxnfn
X-HE-Tag: 1769993733-434877
X-HE-Meta: U2FsdGVkX19We8TteT/Tr9R51S0JPjkkBTud1Cly3CcYx7TSOkiY60rVwpHik11sfoIi0U55Vr0E5Gmt8yoXMcjnVXIc7IuDTWNVzeX2l131taLesJD4EL456/i4xPXvWuMtcyGvcbFH+rQYqn+iAtMcNKeA3J6bzGLAXoryFqV+SSVkJKnvgDkDJ6kkpsBh0Yo2o3nDnfv77JndviqxxbLS8Y+KieLuI+SXiM/LKRF8pjc/5cxeIMbrkg/ijWTkz0NS94V7WQ5FW4yqcSbamFvfJzyXuw7VfIzGb1qYgq8+SoOSVE05zwg+OOY02Si+5LtBuprEVoME2PltGNX1/iQ9IGfiwmz7odDYplJ5EhOeA5OG3NSVuSQYn6cSqbfsCvpLpdooNa5Bso7oK7B1NZLW/m4Fo1UK54vg+LdJh6W0qdurRSmzdKSNVRaqWiJVUzCSQzxPXkcK9pG9nCVxx6yzA/voIq08mthrw61VKKH9X4XWCYWaM5qLbXNtiMYEYExCHcPaadeej3ECV3+8VrNfaC5ediJZpeSdmoPftclX2TEamefQzUG+O5S+UjlTMq/O/wgk8p+FvcnJ2TY0axdWdIqqvFfEPbeod2VQZu1vWkRpRQUH21HGXWRtkqY5KSbw8WbewUx2qssSJF1o8KgLap7Oy5bXRp8ZFqXlFJ2BqKUCY+zsrwLr5SNxR4kxu4ComogwP4qqC2kIBOV+5Xs0M5R4/W09w4wnvyvCFu/DyPdgrkNOECw2zuuW+kE180NI7QWZjfpuR1fUHFx2D+Vm3Cyp1cPqdqcg63PJRhzMnZdBRNUv/YVteJPV/AgiAFxLVxKGWEpRaAxTTrGWXIYSVJIBKrgvQ6UUsqRwRe8YQ+6BxmPXsTeuLIB+sPImdY6oEnEGua+JzyMkustb1rbMw1yXVmLNqLii8cd03K0tK2XDB0Bv7KJg7s/HR2wfPCUTmTJJtWPr/nYw15U
 V4djptw+
 k3IGWTOqrji0smhf8P1I0cvHN92A3kxPImLuUCaZRWcBwE5/6rz8d5xbAYDhtEVizkS2yi+NmLtyDslb8zD2W1m/yvv30EfMjSROWKdSQx1D/lK9/40qnq+L68/9B0t0ZYFqFsoiOjy1LKKaUa0D9yndwvRmAcOFzIgIrJfDx/eROt7EdwXlb1YWVOR9eC5+9fwo7507gDy769VnDLa/vzPffA1KY5dmis/a+A7vdi+da6YTkDZeK607m9urewbiKKaNlYG8yKQ52sBWSti4KuqSb93EWCddY0RNrZcELKbCONFRfZISzubr1hyxkDYw6TtheyfqaIPYI6N3po1ziRpMrAdZrzqk5PZVvZENfsFP3/Xin3eEDUn0+PGrQmgDch1FQ7iR8qCekOFM7+dyW5mKUG77FgCTdme5/NZOKufMhZLEcjye30+6gegJLw94rvm9fNEc/+/qHh0JPtDoibZ+fArrR6Sg82y7wWgu5czzoXcP6gjV2haIuAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the split operation that converts a PUD THP mapping into
individual PTE mappings.

A PUD THP maps 1GB of memory with a single page table entry. When the
mapping needs to be broken - for COW, partial unmap, permission changes,
or reclaim - it must be split into smaller mappings. Unlike PMD THPs
which split into 512 PTEs in a single level, PUD THPs require a two-level
split: the single PUD entry becomes 512 PMD entries, each pointing to a
PTE table containing 512 PTEs, for a total of 262144 page table entries.

The split uses page tables that were pre-deposited when the PUD THP was
first allocated. This guarantees the split cannot fail due to memory
allocation failure, which is critical since splits often happen under
memory pressure during reclaim. The deposited PMD table is installed in
the PUD entry, and each PMD slot receives one of the 512 deposited PTE
tables.

Each PTE is populated to map one 4KB page of the original 1GB folio.
Page flags from the original PUD entry (dirty, accessed, writable,
soft-dirty) are propagated to each PTE so that no information is lost.
The rmap is updated to remove the single PUD-level mapping entry and
add 262144 PTE-level mapping entries.

The split goes directly to PTE level rather than stopping at PMD level.
This is because the kernel's rmap infrastructure assumes that PMD-level
mappings are for PMD-sized folios. If we mapped a PUD-sized folio at
PMD level (512 PMD entries for one folio), the rmap accounting would
break - it would see 512 "large" mappings for a folio that should have
far more. Going to PTE level avoids this problem entirely.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 mm/huge_memory.c | 181 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 173 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7613caf1e7c30..39b8212b5abd4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3129,12 +3129,82 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return 1;
 }
 
+/*
+ * Structure to hold page tables for PUD split.
+ * Tables are withdrawn from the pre-deposit made at fault time.
+ */
+struct pud_split_ptables {
+	pmd_t *pmd_table;
+	pgtable_t *pte_tables;  /* Array of 512 PTE tables */
+	int nr_pte_tables;      /* Number of PTE tables in array */
+};
+
+/*
+ * Withdraw pre-deposited page tables from PUD THP.
+ * Tables are always deposited at fault time in do_huge_pud_anonymous_page().
+ * Returns true if successful, false if no tables deposited.
+ */
+static bool withdraw_pud_split_ptables(struct mm_struct *mm, pud_t *pud,
+				       struct pud_split_ptables *tables)
+{
+	pmd_t *pmd_table;
+	pgtable_t pte_table;
+	int i;
+
+	tables->pmd_table = NULL;
+	tables->pte_tables = NULL;
+	tables->nr_pte_tables = 0;
+
+	/* Try to withdraw the deposited PMD table */
+	pmd_table = pgtable_trans_huge_pud_withdraw(mm, pud);
+	if (!pmd_table)
+		return false;
+
+	tables->pmd_table = pmd_table;
+
+	/* Allocate array to hold PTE table pointers */
+	tables->pte_tables = kmalloc_array(NR_PTE_TABLES_FOR_PUD,
+					   sizeof(pgtable_t), GFP_ATOMIC);
+	if (!tables->pte_tables)
+		goto fail;
+
+	/* Withdraw PTE tables from the PMD table */
+	for (i = 0; i < NR_PTE_TABLES_FOR_PUD; i++) {
+		pte_table = pud_withdraw_pte(pmd_table);
+		if (!pte_table)
+			goto fail;
+		tables->pte_tables[i] = pte_table;
+		tables->nr_pte_tables++;
+	}
+
+	return true;
+
+fail:
+	/* Put back any tables we withdrew */
+	for (i = 0; i < tables->nr_pte_tables; i++)
+		pud_deposit_pte(pmd_table, tables->pte_tables[i]);
+	kfree(tables->pte_tables);
+	pgtable_trans_huge_pud_deposit(mm, pud, pmd_table);
+	tables->pmd_table = NULL;
+	tables->pte_tables = NULL;
+	tables->nr_pte_tables = 0;
+	return false;
+}
+
 static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long haddr)
 {
+	bool dirty = false, young = false, write = false;
+	struct pud_split_ptables tables = { 0 };
+	struct mm_struct *mm = vma->vm_mm;
+	rmap_t rmap_flags = RMAP_NONE;
+	bool anon_exclusive = false;
+	bool soft_dirty = false;
 	struct folio *folio;
+	unsigned long addr;
 	struct page *page;
 	pud_t old_pud;
+	int i, j;
 
 	VM_BUG_ON(haddr & ~HPAGE_PUD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
@@ -3145,20 +3215,115 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	old_pud = pudp_huge_clear_flush(vma, haddr, pud);
 
-	if (!vma_is_dax(vma))
+	if (!vma_is_anonymous(vma)) {
+		if (!vma_is_dax(vma))
+			return;
+
+		page = pud_page(old_pud);
+		folio = page_folio(page);
+
+		if (!folio_test_dirty(folio) && pud_dirty(old_pud))
+			folio_mark_dirty(folio);
+		if (!folio_test_referenced(folio) && pud_young(old_pud))
+			folio_set_referenced(folio);
+		folio_remove_rmap_pud(folio, page, vma);
+		folio_put(folio);
+		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PUD_NR);
 		return;
+	}
+
+	/*
+	 * Anonymous PUD split: split directly to PTE level.
+	 *
+	 * We cannot create PMD huge entries pointing to portions of a larger
+	 * folio because the kernel's rmap infrastructure assumes PMD mappings
+	 * are for PMD-sized folios only (see __folio_rmap_sanity_checks).
+	 * Instead, we create a PMD table with 512 entries, each pointing to
+	 * a PTE table with 512 PTEs.
+	 *
+	 * Tables are always deposited at fault time in do_huge_pud_anonymous_page().
+	 */
+	if (!withdraw_pud_split_ptables(mm, pud, &tables)) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 	page = pud_page(old_pud);
 	folio = page_folio(page);
 
-	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
-		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	dirty = pud_dirty(old_pud);
+	write = pud_write(old_pud);
+	young = pud_young(old_pud);
+	soft_dirty = pud_soft_dirty(old_pud);
+	anon_exclusive = PageAnonExclusive(page);
+
+	if (dirty)
+		folio_set_dirty(folio);
+
+	/*
+	 * Add references for each page that will have its own PTE.
+	 * Original folio has 1 reference. After split, each of 262144 PTEs
+	 * will eventually be unmapped, each calling folio_put().
+	 */
+	folio_ref_add(folio, HPAGE_PUD_NR - 1);
+
+	/*
+	 * Add PTE-level rmap for all pages at once.
+	 */
+	if (anon_exclusive)
+		rmap_flags |= RMAP_EXCLUSIVE;
+	folio_add_anon_rmap_ptes(folio, page, HPAGE_PUD_NR,
+				 vma, haddr, rmap_flags);
+
+	/* Remove PUD-level rmap */
 	folio_remove_rmap_pud(folio, page, vma);
-	folio_put(folio);
-	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
-		-HPAGE_PUD_NR);
+
+	/*
+	 * Create 512 PMD entries, each pointing to a PTE table.
+	 * Each PTE table has 512 PTEs pointing to individual pages.
+	 */
+	addr = haddr;
+	for (i = 0; i < (HPAGE_PUD_NR / HPAGE_PMD_NR); i++) {
+		pmd_t *pmd_entry = tables.pmd_table + i;
+		pgtable_t pte_table = tables.pte_tables[i];
+		pte_t *pte;
+		struct page *subpage_base = page + i * HPAGE_PMD_NR;
+
+		/* Populate the PTE table */
+		pte = page_address(pte_table);
+		for (j = 0; j < HPAGE_PMD_NR; j++) {
+			struct page *subpage = subpage_base + j;
+			pte_t entry;
+
+			entry = mk_pte(subpage, vma->vm_page_prot);
+			if (write)
+				entry = pte_mkwrite(entry, vma);
+			if (dirty)
+				entry = pte_mkdirty(entry);
+			if (young)
+				entry = pte_mkyoung(entry);
+			if (soft_dirty)
+				entry = pte_mksoft_dirty(entry);
+
+			set_pte_at(mm, addr + j * PAGE_SIZE, pte + j, entry);
+		}
+
+		/* Set PMD to point to PTE table */
+		pmd_populate(mm, pmd_entry, pte_table);
+		addr += HPAGE_PMD_SIZE;
+	}
+
+	/*
+	 * Memory barrier ensures all PMD entries are visible before
+	 * installing the PMD table in the PUD.
+	 */
+	smp_wmb();
+
+	/* Install the PMD table in the PUD */
+	pud_populate(mm, pud, tables.pmd_table);
+
+	/* Free the temporary array holding PTE table pointers */
+	kfree(tables.pte_tables);
 }
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
-- 
2.47.3


