Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CD1606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=djM7rVZO
Received: by kanga.kvack.org (Postfix)
	id 63B2E6B0977; Wed, 25 Nov 2026 05:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBB56B0979; Wed, 25 Nov 2026 05:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4170B6B097A; Wed, 25 Nov 2026 05:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C59A6B0977
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:01:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8940E160D9F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:10 +0000 (UTC)
X-FDA: 85473198300.15.1B47A2D
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA11A140010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=djM7rVZO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600868;
	b=U5UOHdNw/PZ2zkEizxywanf8SB5hPczU0Albz0s9RwhQVIJhsC7MmyXFz26FGTDceDXpbs
	pnU2y5vxtAVaQfjdXbsEMp0nOEUKJLrGqX+5tvSz6Sm5CFBvfTSAwWd+kT4iZEJy7VoBry
	05o3ZEp2zVHGSIZyJOb+8TsQ5pgiSRM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRa7glS2jxBPu47ZJigvnqW/5smKMZXYDTqtBKYDhyg=;
	b=2J8sNJ7xSZM5io/x2jltsSAHEQk8LanAfFdMaWvDWtDdYHu49Ru/CGajiq2yLfSnIVO3uq
	SiN5xyaWX6y2+efL1WqGf1+5rKTtzqehrtf+bE6zBlNtevOffdYSNzW54xRb1b5vNyNkzn
	x7aVFGZv5sw9WW75Bz1Z0fy1rl084Xs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=djM7rVZO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so49291085e9.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600867; x=1796205667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRa7glS2jxBPu47ZJigvnqW/5smKMZXYDTqtBKYDhyg=;
        b=djM7rVZO6MHiMqkOTQ1yugmsJfOBrTd5713o6Je8uwjjjmw0NMbMjB0+q2XLd2LFen
         QEJFTOAkql8Diuv6MQuhggJ48crlnZXZkd9I8DtnhWB+acyI9UQ+Z09qD9WuZ6qgmJfk
         xS9jwVm/mxg9IBMyIdNkd/Tt1pHMdfMd551Z9Ng6XM/wItGgeMNaOlj6DjDlo7g2dxJp
         Q/5dJ78OVMRzEUawJUkB73fyX9TbDiSWVp5YzLiVSda4IZyAm/j7jJBWLWdQk1rGEc99
         jzXrQ3rxCZ8jYs52yi1BBliCEO1Jn9d95AkLzpT0Xaj5q5auCmz+Ae1qVR3mjSkYbS+g
         M/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600867; x=1796205667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SRa7glS2jxBPu47ZJigvnqW/5smKMZXYDTqtBKYDhyg=;
        b=WnvpQ2CsFmOUeUJ+YejknrgfMxw015DaV+Ve2t6wtlf1V5wrF9dGbUD2iq7IxaDSsF
         bk+f2BXAgFancj+WtiM5fLV8oySWHqCT9+msR90yHlr9NUQsEIhx7w0J/FwFeAazU00L
         LqonP9LEM7HxWH7zFgoFxkfTF8PzTMrLhGVP2jxcMv8wyqCTB03XiAn5OwIGKqj9/nJC
         N77lAEwjWFSRASz5TWYPCFe6/6BV7pMJ7s9EL7NVI0lI+KphN5AgYV/OjM2B7/8WyxzM
         jefZ61xjQC5Ea7EweOEG50cxKHVULkdlXjZsdfzUs47yeVSLuwDikgWK6tWa0Y8DPtXp
         1uAw==
X-Forwarded-Encrypted: i=1; AL+hErFXpW4CruzQp4ULP9ZYzMX3lkt/YrnTxHV+Ls/gxdu4YdCCyec1ENapiljKgGAimi5g/jlxDfyuAQ==@kvack.org
X-Gm-Message-State: APuU4Z+zXI+7d5tpS5fFKD8+ypblivD//HJtReu7NRJvakgAAgkT+iRh
	lJ3+TFv3auMPDEah3KdPTchgcWZf5IZHiR19zL8bwERvFtgClLnr9KJ5
X-Gm-Gg: AZFdTZfe5oOVPriDILgvBQBUviIhbuDNR6OPTJU5/HE3wLh2n6ujsMKxV4RRgSdzYet
	r0LGkXPuE2rrPI4yduT90v4NrnqVktGbG1vRNP4jCxb6fVafYuB6Nw22FRkRC5TyzBhADNgcuQ6
	fhThF2N2v0P0irMBOd/rUhtFPbdylpgHqGIw+F+hCAuy+UKlSo9wF8ZwewZt+npguX4tqEppwMY
	G1yRPwZ5AIC239C7ExZP/ddwTYUX9JLan6W0Cp7x6cgmVvpbXrCeDqGw59oMp5m3hqrZJjQNL0Z
	NGJ1S+pgj9GzSmpp2TEF0uDvb2Oi8KTgTUFMaQR9YeuuoQsusvLjO0pKThiLtY4YRMIayaEQsYk
	4nUvZpKTIlWHDbAtONNhvsZvS1/bwvUSjAj3HQjWJbXHr73fWyQhshEeoPNkb7Rne85eq4KA3A/
	4nl1Qr2ExKBEHghOti/gYITAHS1xo7a8ceKh0ZAXAZ2+zTVqPMb/DIQuh1QoMsJmd/2ei777tt5
	bGjMr+VOxO3bFhbx2QSeqvwLXxbt9H+XOUfUuUPUTzvJAANTf9GRVrYU5T2I1ftGaBJmT9ZqrIF
	Nvcx/pawRu6HAw==
X-Received: by 2002:a05:600c:3e1a:b0:4bb:6814:7391 with SMTP id 5b1f17b1804b1-4bb8881921cmr344499975e9.25.1795600867092;
        Wed, 25 Nov 2026 02:01:07 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm423898125e9.9.2026.11.25.02.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:01:06 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] mm/khugepaged: allocate page tables before locking the folio
Date: Wed, 25 Nov 2026 10:59:44 +0100
Message-ID: <20261125100058.15200-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125100058.15200-1-azpijr@gmail.com>
References: <20261125100058.15200-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA11A140010
X-Stat-Signature: tgb37gf415yrsbtn5rz1ed8aa1isniy7
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795600868-965586
X-HE-Meta: U2FsdGVkX18903dV4mQEz+pUtvAKPCXVhR3CXS0MLb3+UHM7q5vWBVD7zbni7XW8QyxBhYhX/BufRUV5PkY6cgprQj0iqVSV/NXT0cuJVKjj8sCu+utQQ2CF9aiFC/Rj7vX6ReXvRGN7jn7Im2zLoS4Ei3XJyDFBGYwNS+WGxYnIDKGGeoykz2B/y9yxVPwzgEyAGbe0+EcWBmpJHPs0uK1HG64hZ5AP3K2P0ucxuUvxobUPhzuLZNhNAVF6enU+H+SkK+E6piDJO3ZlB0T1IhBNqFPu5HYjH1LVSdTOKTizb5cv/9+pZ6hTThCFjekyPkjMOALCmEB7OkDBcoonoY17Zeda0Tj7FHsu5iPp93tjBpLJd41AxuqIWkcXfZMDzLQUg82dJYF7oYI8W9JSbAbVf4tQbtQiY1B3CD/tYe6DLWyeYTTygRlKsutQx9Ji1NBLQ38FcodbGm3AbckbuCNMF4JbeLHJsCLU6tCn2keGS8fOq+Fuc0y9Ay/snbBZF7ShbemIDU+0x/3lYwGqtU839KgkdNhBc/WM+Ib8m3iiD+TsoXKTvrgiOgQUmf4JDX9bl4nZNPWjMk2pZ7QALV1FkY8qCHLi+pL6oXOeqfUs0TqIshxIrc6ByMI9AroZOgenvO5h12BhQOBdnOgZMtZJ6wOX32vNevQRDH4dyaHvkKlIV6pF6HfTo68iGZGL7ih+6yySe08ALoi/Mrfa3cNdL1pO7qn/kF9wj+B60mR5TtBNbrMuelpkw9hhExrPha+Lr0IK6OQEsaMU+aeYIGq+22u4t4Jofq8LMpI553ATdmbkTsK60pnqP5p9mmT2Ys+wyIcf9MjSB1/bue8hlWQHnG2C+BU+9ZEdyC8GCXf7mYsQzyW416n/bDzwp7THALxXSFpvTQxNdIX4RfnNl+tr6Lw23BK+cZPS+EnDo12X76BWG0+j+69TQi4WKVLm9rCA39eIqOspUH7SiXH
 OjvA5JL7
 PVr6SRaB6OFbno6I1E8/vckznYpf6pRXPiveiVeuGhE4lwPHGeAXMqrUh6NswyLumr4R2agcEe3YciiNgfBtQECxUwrxdO8pOtPT4l2iVSl7CNyNdce/bDX+eyJVLSJMlcon4jquEEOTlA+hFbAHhRFG0qZAG5Aj3T7OBkI/nF9Ra10xoMRsRsciX2wVldKSJEy5rIxLHWCLr3s411kv96Rt6Ao6kBHmdT9YBXkHxhE9gRdxtMyl+lYyRvrJAZjHwVkZAFHdCi+rZStwVGJemXaTXu79QE/J4BfzVbZVzq5/cZWS/q3fQ1qIYVU2/DgdQ6sFjeOrxyLkxtWaTw4bb/+VG1rBoES0X+wmfcnKdtLIIEOTdEIPkWeSOO/rFaSBYhtkGbI1tj0slDQlr0k1V5VYWmJv5nVZBTsLNT3auRVPmA8BmhOjmj9GlEWtae0Em3xkq9vQucqcvcPOhlqIHktCBaCfryBO17Sx3CSrHO+2qiyoG0p1YaO6KrAPo/14rupWkIILFc/7U7tKhq+OdAvGV2XW8BmKKgkIvy62gj6Ehx16ygevW5+EJp8xm8CMPUo+bTNYbPgAh3ASqXlh0R/g4fAf+g5uTCirwSZ48N49k9AdMNLpdQEfkREQDgFQTGoyF0Vr6OH1heKwz7uSQxPSKdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_collapse_pte_mapped_thp() calls set_huge_pmd() with the folio
locked. set_huge_pmd() allocates the missing p4d/pud/pmd tables there,
and on ppc64 with the hash MMU do_set_pmd() also allocates the page
table to deposit.

Allocating with __GFP_FS while holding a folio lock can deadlock in
reclaim. For example, memcg reclaim on cgroup v1 waits for writeback
that may be waiting for the folio lock we hold.

Allocate these page tables before locking the folio. The mmap lock
keeps the upper levels around, and an unused deposit table is freed
after unlocking the folio.

Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Fixes: f8a01513f574 ("mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL")
Cc: stable@vger.kernel.org
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/khugepaged.c | 79 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 93d4a6f159e8..e5adf6960a7b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1822,37 +1822,57 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 	}
 }
 
+/*
+ * Allocate the page tables needed to map a PMD at @haddr. Must be called
+ * before locking the folio: allocating with __GFP_FS while holding a folio
+ * lock can deadlock in reclaim.
+ */
+static enum scan_result alloc_huge_pmd_tables(struct mm_struct *mm,
+		unsigned long haddr, pmd_t *pmd, pgtable_t *prealloc_pte)
+{
+	if (!pmd) {
+		pgd_t *pgd = pgd_offset(mm, haddr);
+		p4d_t *p4d;
+		pud_t *pud;
+
+		p4d = p4d_alloc(mm, pgd, haddr);
+		if (!p4d)
+			return SCAN_FAIL;
+		pud = pud_alloc(mm, p4d, haddr);
+		if (!pud)
+			return SCAN_FAIL;
+		if (!pmd_alloc(mm, pud, haddr))
+			return SCAN_FAIL;
+	}
+
+	/* Archs like ppc64 deposit a page table along with the PMD mapping. */
+	if (arch_needs_pgtable_deposit()) {
+		*prealloc_pte = pte_alloc_one(mm);
+		if (!*prealloc_pte)
+			return SCAN_FAIL;
+	}
+	return SCAN_SUCCEED;
+}
+
 /* folio must be locked, and mmap_lock must be held */
 static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmdp, struct folio *folio, struct page *page)
+		pmd_t *pmdp, struct folio *folio, struct page *page,
+		pgtable_t *prealloc_pte)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = addr,
 		.flags = 0,
+		.pmd = pmdp,
+		.prealloc_pte = *prealloc_pte,
 	};
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
+	vm_fault_t ret;
 
 	mmap_assert_locked(vma->vm_mm);
 
-	if (!pmdp) {
-		pgdp = pgd_offset(mm, addr);
-		p4dp = p4d_alloc(mm, pgdp, addr);
-		if (!p4dp)
-			return SCAN_FAIL;
-		pudp = pud_alloc(mm, p4dp, addr);
-		if (!pudp)
-			return SCAN_FAIL;
-		pmdp = pmd_alloc(mm, pudp, addr);
-		if (!pmdp)
-			return SCAN_FAIL;
-	}
-
-	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page, /* may_alloc= */ true))
+	ret = do_set_pmd(&vmf, folio, page, /* may_alloc= */ false);
+	*prealloc_pte = vmf.prealloc_pte;
+	if (ret)
 		return SCAN_FAIL;
 
 	folio_get(folio);
@@ -1881,6 +1901,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	unsigned long end = haddr + HPAGE_PMD_SIZE;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
+	pgtable_t prealloc_pte = NULL;
 	struct folio *folio;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
@@ -1916,10 +1937,18 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
+	if (install_pmd) {
+		result = alloc_huge_pmd_tables(mm, haddr, pmd, &prealloc_pte);
+		if (result != SCAN_SUCCEED)
+			goto free_pte;
+	}
+
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
-	if (IS_ERR(folio))
-		return SCAN_PAGE_NULL;
+	if (IS_ERR(folio)) {
+		result = SCAN_PAGE_NULL;
+		goto free_pte;
+	}
 
 	if (!is_pmd_order(folio_order(folio))) {
 		result = SCAN_PAGE_COMPOUND;
@@ -2067,7 +2096,8 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
+			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page,
+				       &prealloc_pte)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
@@ -2086,6 +2116,9 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 drop_folio:
 	folio_unlock(folio);
 	folio_put(folio);
+free_pte:
+	if (prealloc_pte)
+		pte_free(mm, prealloc_pte);
 	return result;
 }
 
-- 
2.56.1


