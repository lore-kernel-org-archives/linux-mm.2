Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CAFD172AB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7E86B0095; Sun,  1 Feb 2026 19:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73DD6B0096; Sun,  1 Feb 2026 19:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8C66B0098; Sun,  1 Feb 2026 19:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94CB56B0095
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62053160A02
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:36 +0000 (UTC)
X-FDA: 84397698672.24.4CFC057
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 802AA140002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DkLtRXEw;
	spf=pass (imf26.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxuUiLfYi20Fha3ulkW2hqwY4wzmXAQF/uDuddDWXP0=;
	b=SDvgc0H+/PBXaG75dAkvfGrbEHr4baakt6gw+HjIru5TvyUJbApFuUsJKCbSwH99cyeoTm
	rQO6j/kVA3JBMwphTI38KqvZelJrqbwHmcjrbSRr4Pn4S6Fh4wxgmMZ4thFAoN/oflglKI
	I4cAsVrmfTrumOKG+aUkILScZynfceQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DkLtRXEw;
	spf=pass (imf26.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993734; a=rsa-sha256;
	cv=none;
	b=jQW6z/DTr+og8avLhu6nvmJOaXiJhq4sUq+yBS861j+d2gpdzIslCJXTH2hjXXjbQOf+Oa
	ibB/PqIeIBjWIt3QHXTe/43jLXxKvdTJ9NM2AQZF6mrZ+2nGfXm0ErdBYE/b6hTu9WT3dX
	IIA68aF6HCeDrbd6K/H4Jr9svp/VSDU=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d1890f7cefso3323850a34.3
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993733; x=1770598533; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DxuUiLfYi20Fha3ulkW2hqwY4wzmXAQF/uDuddDWXP0=;
        b=DkLtRXEwKWCRGZ0SidvK7fb08HQdBrRzFx/PfEMQzGRUlzQAKXZ2CABIUrazWfIsZo
         4DH1pkzWy4dpveMns/26npmL5RbceFf56pfc2j8E0pJB5Mfa8FRAn2jcDnSi59dBDyou
         lkNFXZdPb1hzpc1Xh520+YryD3RIMJwY5dxAZOVVA1DRJcvzFiOtHUvU+bLfzLF1/qvi
         WoaLQ0xOAaNkPkkmIR7aFeOlglXSRyFKacqEoIzNpUcYb7rGn86kzwxUDbRdUoruhRKr
         zguHO39WL745TSCswtMoqakHnkdkC25eNnnnHxip6lHT5YxA4p1otNsTTBAK/PZ8zehh
         r26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993733; x=1770598533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DxuUiLfYi20Fha3ulkW2hqwY4wzmXAQF/uDuddDWXP0=;
        b=iTNPzyKGlD23zGabF1X7jUiZ5zLn+BcKaqHjquET1xg7L67Q6m9giUL14psxsU9qCC
         Hi/ayyM0VeeDa8ZX+zCpEQyxDxr0Jm0rAGPwsFgjEbG/0j4EwZml0CJM9bpdP89qcrHs
         q4K9gTzRvfL7QwtI/LmA2OdtL+Syr/lks/tFK8M8S8A5bs+o0tNDl7LZrfFJml6G2TRB
         w/bq7pn0mLpLOAY/MPKS3hCi107A1O6anQCS4kgICdxi8NbIxFs0PbvFTbXG0o9ypb7z
         ukPH+VcMTF450NhC/Mce/APpYXsdD1bpdLo0gEbq2YBAh0JRKOR7MTZSLtObJ9HTMKW8
         S6/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVilovo2zM9vuD2fr3h2cblMGAmbesDkOLw7PxiVGQVla17Q82etHN677rrYCHp9AK310OZugbHpA==@kvack.org
X-Gm-Message-State: AOJu0YwXh8+Z5GUeWIKFOXbm4XZJlj8JH9fG3Z0lI55H9Nc/BmcK3V2D
	vlsPe16BcmLs8ki4I7OZAjMglG2O0kaB3CTbGA+qgSM2RtGzY3YvEjGZ
X-Gm-Gg: AZuq6aKOLian/QwC/Q3EBNWBAIQKbqo6eUEdZsEUB1AWq3FLr18eIZv7h+GQdHjb35t
	50Jn0mqxhHh9SvuzYLMchfcwu5+900uYqTTJSAnpqJOiKmM+HShSo5dPr6ULWmUrK3Ljxln+9+h
	PA0lBzuzAZFH/kr6+Ik8fEbugKndsTfD3f53K45tKdzJEO1kj55qmqeBE9j/pK3YYfPpi02k4L7
	6qMbGnaSv/8sPVkkRufyCkqdTCgI+9xAmxN7yEe866v9PFfh4iB0l/63JIi4uX9uH2PP/vcMGpx
	iHCSXRCK/pEpXByoYiJizvX1D5G+PMXhTITsuc9KdEuim2IWA1IQLJ/9a5MIyxQT41LiV1pBecv
	hDnARmlQu0djPhSighCLzioUQqBk5Pg7eLyF1uWL25EYjjIddc6gg/arQgxviXDNy9N5spYVp1a
	f8v4FouCIF
X-Received: by 2002:a05:6830:3112:b0:7d1:4d70:736e with SMTP id 46e09a7af769-7d1a535482fmr5803898a34.35.1769993733426;
        Sun, 01 Feb 2026 16:55:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c69bf4csm9760188a34.9.2026.02.01.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:32 -0800 (PST)
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
Subject: [RFC 05/12] mm: thp: add reclaim and migration support for PUD THP
Date: Sun,  1 Feb 2026 16:50:22 -0800
Message-ID: <20260202005451.774496-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6k7kexk936fsz3bbke8ms1b1rms4ksba
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 802AA140002
X-HE-Tag: 1769993734-746568
X-HE-Meta: U2FsdGVkX19ideA0QjVtW8pyz8j3CjcJy9HrMHJncKy8z+RR9AK+vvgn/3j45NMdho55ve6PlvrMmCpX9VntHTc9pieBSe7q3VrwWYRxzNO80B5UvvanGtlCKuy/uDfjvN/rRqAHoygeXjFP4ewSjJ5c7M7IpjpdLNjwoqHIZXgr+n0h7DcQ9E3bgeSWCSJEckqF6g8ROUflWsInIo7trwrHR4fLysjJ016g+7zqECSKj1gwHVhTEVBQJeWoBUIxDcDhWEqQQbZRnNT1grFY31wIOA24LMdXSz/nQJcDcHU1tKFIfp5eL3BR99cPUoRVp2EYOhC0Uy5+0qa/CXj5mI06DooIpFHKAwh5iU421K8ZD1NUlqT5sHaxRb+r3IevuVFUK//UuYFlYEVUNVknVryIDj1A4qwhPKgZzf1IbGiy4p0ZbthTC86arUd2RC/F7tIY6v7ZEGWAauHf2WjZbKGPikvcYQf+3Ep+cfKN1XkpbkJSK6KPRvynxENevJR97Ztyg4UQk36zCEQ0Dg+ZiHzl8xiRxf0f5+WSKvQVCweFDi9wpaECVTykdE3kqRtv3gSh0SN5T5WEAtCKZpVY5pZJcj+ePb89aa79IZeYHOjJhg0yFnVJjDE65DaMYO6+uA5wEr259yWkS3uexkuRM4Le9grWdS/alymuC9DqRXWO2FVw38Mbl701Wpdj44Xot98O+DnK6k2uoTd+mi9gUp8YdmF+y5SSHaszNbrMsDeLJhuKjPiwKgn4iJtEJ1svOdQqxTNCI6KyrLHnt0aqUQV2z/HO7KJBLbAGqzFM8qu2xb8ct0OLj+F7oXNBtOInR7VyYnzKpWXBY7YT771E9vNnn48uvYb/X0r/5ALKDSSGzSoj6buVKxYkhIQD7uzFSRyQhV76x4OKBXxhEIcXslsH9vARdKqa6pEWj6RT2TpbxUa+KnIAcGPSC+DxwvEwIZ5C63ZbuFrt0FOYMoe
 2n9gDIHd
 Hxp0RVvAFRCR47w43or1MwrK0SMlN7puVJYB2efcjqN00ZW3cM/WVwW9mq617kG1N21yPTvgoRTCCu9MO+wCCzKYl/1JFkH5ZbYPwcdDNuqYKCXdyfYxFHPrHk5366nW7DPhC8bCazItLPc2MyYmEX7B9DZtcuFybBuy7gP/ZJhMrxiPVy4vAQA2tyMqI/G4fM2AvIxKgshORwb9liLT2oV/QDjfR/LyPHjJhQZar54tYmdP1nEFWJGcNWyoOx1Uk83VfwVWK7gjCur9S1wHyuUUCxULReBrOfMFCUtr94dpe/9HBgoawdHIVn0TJQWCf1lS+RXLDgIMWr4ua5sRkPCfCmzmMf64E1nWpaAm+y3soNJNgUOBmGTZyqnGMD7AFaX/4+/UVUiA0QyKEuhboAPfnRhITJrM/TcrgKlM+QL5/NY6f4+J4hXv3RX89Tar5qNE0G6Sg0mjhcX3FsQ+OrwmEoZFUuYz298jHNShX8kUP+SqUBcxbgVU4gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable the memory reclaim and migration paths to handle PUD THPs
correctly by splitting them before proceeding.

Memory reclaim needs to unmap pages before they can be reclaimed. For
PUD THPs, the unmap path now passes TTU_SPLIT_HUGE_PUD when unmapping
PUD-sized folios. This triggers the PUD split during the unmap phase,
converting the single PUD mapping into 262144 PTE mappings. Reclaim
then proceeds normally with the individual pages. This follows the same
pattern used for PMD THPs with TTU_SPLIT_HUGE_PMD.

When migration encounters a PUD-sized folio, it now splits the folio
first using the standard folio split mechanism. The resulting smaller
folios (or individual pages) can then be migrated normally. This matches
how PMD THPs are handled when PMD migration is not supported on a given
architecture.

The split-before-migrate approach means PUD THPs will be broken up
during NUMA balancing or memory compaction. While this loses the TLB
benefit of the large mapping, it allows these memory management
operations to proceed. Future work could add PUD-level migration
entries to preserve the mapping through migration.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 include/linux/huge_mm.h | 11 ++++++
 mm/huge_memory.c        | 83 +++++++++++++++++++++++++++++++++++++----
 mm/migrate.c            | 17 +++++++++
 mm/vmscan.c             |  2 +
 4 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a292035c0270f..8b2bffda4b4f3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -559,6 +559,17 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 	return folio_order(folio) >= HPAGE_PMD_ORDER;
 }
 
+/**
+ * folio_test_pud_mappable - Can we map this folio with a PUD?
+ * @folio: The folio to test
+ *
+ * Return: true - @folio can be PUD-mapped, false - @folio cannot be PUD-mapped.
+ */
+static inline bool folio_test_pud_mappable(struct folio *folio)
+{
+	return folio_order(folio) >= HPAGE_PUD_ORDER;
+}
+
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 39b8212b5abd4..87b2c21df4a49 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2228,9 +2228,17 @@ int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		goto out_unlock;
 
 	/*
-	 * TODO: once we support anonymous pages, use
-	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
+	 * For anonymous pages, split to PTE level.
+	 * This simplifies fork handling - we don't need to duplicate
+	 * the complex anon rmap at PUD level.
 	 */
+	if (vma_is_anonymous(vma)) {
+		spin_unlock(src_ptl);
+		spin_unlock(dst_ptl);
+		__split_huge_pud(vma, src_pud, addr);
+		return -EAGAIN;
+	}
+
 	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
 		pudp_set_wrprotect(src_mm, addr, src_pud);
 		pud = pud_wrprotect(pud);
@@ -3099,11 +3107,29 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 {
 	spinlock_t *ptl;
 	pud_t orig_pud;
+	pmd_t *pmd_table;
+	pgtable_t pte_table;
+	int nr_pte_tables = 0;
 
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
 
+	/*
+	 * Withdraw any deposited page tables before clearing the PUD.
+	 * These need to be freed and their counters decremented.
+	 */
+	pmd_table = pgtable_trans_huge_pud_withdraw(tlb->mm, pud);
+	if (pmd_table) {
+		while ((pte_table = pud_withdraw_pte(pmd_table)) != NULL) {
+			pte_free(tlb->mm, pte_table);
+			mm_dec_nr_ptes(tlb->mm);
+			nr_pte_tables++;
+		}
+		pmd_free(tlb->mm, pmd_table);
+		mm_dec_nr_pmds(tlb->mm);
+	}
+
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
@@ -3114,14 +3140,15 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		struct page *page = NULL;
 		struct folio *folio;
 
-		/* No support for anonymous PUD pages or migration yet */
-		VM_WARN_ON_ONCE(vma_is_anonymous(vma) ||
-				!pud_present(orig_pud));
+		VM_WARN_ON_ONCE(!pud_present(orig_pud));
 
 		page = pud_page(orig_pud);
 		folio = page_folio(page);
 		folio_remove_rmap_pud(folio, page, vma);
-		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
+		if (vma_is_anonymous(vma))
+			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PUD_NR);
+		else
+			add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
 
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE);
@@ -3729,15 +3756,53 @@ static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
 		split_huge_pmd_address(vma, address, false);
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static void split_huge_pud_address(struct vm_area_struct *vma, unsigned long address)
+{
+	pud_t *pud = mm_find_pud(vma->vm_mm, address);
+
+	if (!pud)
+		return;
+
+	__split_huge_pud(vma, pud, address);
+}
+
+static inline void split_huge_pud_if_needed(struct vm_area_struct *vma, unsigned long address)
+{
+	/*
+	 * If the new address isn't PUD-aligned and it could previously
+	 * contain a PUD huge page: check if we need to split it.
+	 */
+	if (!IS_ALIGNED(address, HPAGE_PUD_SIZE) &&
+	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
+			 ALIGN(address, HPAGE_PUD_SIZE)))
+		split_huge_pud_address(vma, address);
+}
+#else
+static inline void split_huge_pud_if_needed(struct vm_area_struct *vma, unsigned long address)
+{
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			   unsigned long start,
 			   unsigned long end,
 			   struct vm_area_struct *next)
 {
-	/* Check if we need to split start first. */
+	/* Check if we need to split PUD THP at start first. */
+	split_huge_pud_if_needed(vma, start);
+
+	/* Check if we need to split PUD THP at end. */
+	split_huge_pud_if_needed(vma, end);
+
+	/* If we're incrementing next->vm_start, we might need to split it. */
+	if (next)
+		split_huge_pud_if_needed(next, end);
+
+	/* Check if we need to split PMD THP at start. */
 	split_huge_pmd_if_needed(vma, start);
 
-	/* Check if we need to split end next. */
+	/* Check if we need to split PMD THP at end. */
 	split_huge_pmd_if_needed(vma, end);
 
 	/* If we're incrementing next->vm_start, we might need to split it. */
@@ -3752,6 +3817,8 @@ static void unmap_folio(struct folio *folio)
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	if (folio_test_pud_mappable(folio))
+		ttu_flags |= TTU_SPLIT_HUGE_PUD;
 	if (folio_test_pmd_mappable(folio))
 		ttu_flags |= TTU_SPLIT_HUGE_PMD;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 4688b9e38cd2f..2d3d2f5585d14 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1859,6 +1859,23 @@ static int migrate_pages_batch(struct list_head *from,
 			 * we will migrate them after the rest of the
 			 * list is processed.
 			 */
+			/*
+			 * PUD-sized folios cannot be migrated directly,
+			 * but can be split. Try to split them first and
+			 * migrate the resulting smaller folios.
+			 */
+			if (folio_test_pud_mappable(folio)) {
+				nr_failed++;
+				stats->nr_thp_failed++;
+				if (!try_split_folio(folio, split_folios, mode)) {
+					stats->nr_thp_split++;
+					stats->nr_split++;
+					continue;
+				}
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
+				continue;
+			}
 			if (!thp_migration_supported() && is_thp) {
 				nr_failed++;
 				stats->nr_thp_failed++;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 619691aa43938..868514a770bf2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1348,6 +1348,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			enum ttu_flags flags = TTU_BATCH_FLUSH;
 			bool was_swapbacked = folio_test_swapbacked(folio);
 
+			if (folio_test_pud_mappable(folio))
+				flags |= TTU_SPLIT_HUGE_PUD;
 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
 			/*
-- 
2.47.3


