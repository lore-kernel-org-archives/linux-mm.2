Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2B96606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2K3sPPk
Received: by kanga.kvack.org (Postfix)
	id BFBF06B05E4; Thu, 26 Nov 2026 06:18:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3336B05E5; Thu, 26 Nov 2026 06:18:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1436B05E6; Thu, 26 Nov 2026 06:18:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 884366B05E4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FA63C03FF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:53 +0000 (UTC)
X-FDA: 85477022946.03.1570DF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4DC851C0011
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2K3sPPk;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691931;
	b=oG1hiWQQDHtHx+gNoMjqcHazNrmza2RlEnjDBOs1Ha+01IdR091ZE4S+Q1xbmbSzjX900s
	2X2uGZ4ruQIJ/4yGve6zWhbROvVMbyOg9pLuLcVRLoz9sWMZgI8CW7JORkIrOLNPHxE8Nw
	9tIex1/8Gtyz2p6Ed4PZ/8sGoJGOZoI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRZMtIW2MugvkVR76yuHAqsoWEOAtNfsgb89NvFPOYA=;
	b=V5Uqv76zt4Q/99RRBhPDG03Fr0cqnskrSauYT+lpXROJOuimb6IiylmttWtQWyyYSUvKJf
	AVCaFY/LLv6KJLY8yx3XDrDAhEUbo9bo0VZI6dDsQ5l4cWXk4MNsS0qn3xU72J/sV49lSe
	IWWtAI4aAJRJV0HKKOptZRxBPDOs8W0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2K3sPPk;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7585B46595;
	Thu, 26 Nov 2026 11:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF021F0093C;
	Thu, 26 Nov 2026 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691930;
	bh=iRZMtIW2MugvkVR76yuHAqsoWEOAtNfsgb89NvFPOYA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M2K3sPPkN2wjX6UdoOPOB2E6NUYjuFP15lUtDNCRv+M/AT7W+/1be2jTXCi9creoH
	 Vzn5fE3niCZeSKPAlOKUP59TBuOM2jyn84PEm3o2JjxvL92JC1v+DF1aOJp/wZCLxU
	 BGxgZLaI7KM4V/6wwCMbPH4d6LuJgcXYKH20w1pUpVHn2iVMiFl4ufwHgkiV/b2RKY
	 V6i4f9hqQEk1nzPH/e7OcvKNvXrlJAj/fDk4sXrnFnIFmTwvfajSMnfXDoY0oCLVBh
	 wPKWGNke9HHQH9EsrEm9pqWJph6LvPyxT1ODI5MHz+0XZaOknNB6zAgZcm+gvF8Q10
	 Ig1ST0p/2W1Cw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:40 +0200
Subject: [PATCH RFC v2 27/54] x86/mm/pat: prepare the direct map counters
 for the generic code
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-27-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DC851C0011
X-Stat-Signature: 39gjkqcnecurft9jg9u3en8hj3oxg6ty
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691931-527406
X-HE-Meta: U2FsdGVkX18zMkYQfMMcRC41YAs5hkc9fs0AQ1TN4wbMhRP3Bc2fhws3nYlQrK4fGxQRbjvLYGGMplssKurOl/x3q1mX8UjYKcBW/bqcKRsB5sO0WLf5PjQvpeZLhn1xqmfHapULbEK8JHLJT6S9IvuEi4MH8G9UUoSk/18zrRlnmNnyr41DCK7BRmQKp4ZW8nM2vWImgaSO6gD+xXP7M4EAjFTymH+31XYaKoB+t2JvNl7y716rWa3kPu5m7Z0UTbuUO7oS49ce1BD/93wnlxq0AFYRdOQ6h/Y0twNxRn7xodvtX7mlwp0QrHClAJJrCrIKlkebBIGyppEVlSKgv4i3f8Krtq1VCEgIGDfzigEPbJ48BpJG91jQdUIOrG93/TRB7/L8buw3Obhfv1k71Wzwac5msab5Xr5v1Ew6Xr+2y0GTrtbnYabA/34TCIcgSfOw2/mitR2r8Ib/XBXlhPEVJBxtyMqgSAxMXfls4Plqyt8qu1N8wVSDpiMkb/n1XSl5/A6OCsMWTplzm+cnvN0Yc15cLaVNSA+sTOstJSHnCpLb+4A8GaNkkulFAxQiZrygRtaQoB5+D94DobNIu95OHQYXm2ONOYuhTsXOWVPr5TGbDHI2xZFzwvdp+RZtzyQAyGWtrkAki7urddL3UGBE5lFqpiCam5VeDthoaRrlw+P8aEentV9VhDIUvj15+nAfWOdgEuID4jHtmSRHW5+0O0JRqIin+qVvPeP1rJC3g6n8bwyefYXhpsHTL6x4GizrTvZBAGqCS4FG/D5/4oBo777GY88xkC+ZJRE7USzC5iN+eRtcPpJOY04O7YaJNGauM66FXOJsbr2UpXg3ffgN0TuyDOlbkZ2EyWJvErqk21aP2FnTxfF0WsB2DDWHxQWExB8hmoPLT/IWBo51Aaxn87GNO0Pt7MkcWSYefLhlkZ/gzur6wuH4+Gqu/k0Bo+I4BM4LXhLpysN2HII
 HjYq5oL1
 E7dxxUTA8g/7s/P8/TF9tSf29HSHboN67xlIpUL0rkzDj+ONNYzabMbkijchrzsPFfAOEToAW6jXF3vLhTD3TiZM031aKk3L3zpw3vH2frpvXswdeloK/W2O+9CUmADFk7gW7EbaFdevmLqm3J2sEqwbZcli6pp2lSL3gWykQUB+DlYUkJL3YPNHHGXWezlGdTVLEEv7SrGshIOkR6VYyA0CYU/nBkTDFAixRplrIM5KmTSfKu99I8xVJ2uJp/Jq1MJr4e+rWM3MnZJ6Vt2cErYACu5iYkvgGFGIntP4Hxj+CFscfoUk267MMSxXDQc7J+GpjHrbfnvX9NxOZr1chLzkTRnonQZ+97kPNpIFjNY1k0UKVfjUeg8OpkcSbjccnmoBxjB8dm8x5ZPoaM6EWinEH1noEqI3emTYm2Y1uv9ldUeQDgKl2M39b/IEwf6KmiUGEzS6KM7i15R4r1sWyQqRr63LOf4xjwr+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The direct map counters are going to move to the generic CPA core, so that
every architecture that uses the core gets them.

Prepare them for the move:

* rename them to direct_map_count_*(), which better describes what they do
  and does not collide with the update_page_count() of powerpc and s390
* declare direct_map_count_update() in mm_internal.h, where enum
  pgtable_level is visible
* print the DirectMap lines of /proc/meminfo in a loop over the page table
  levels, so that every architecture can choose its levels

The output in /proc/meminfo does not change, except that 2-level x86-32
booted with "gbpages" no longer prints a DirectMap1G line. It never maps 1G
pages, so the line was always 0 kB.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/include/asm/pgtable_types.h |  6 ---
 arch/x86/mm/init_32.c                |  4 +-
 arch/x86/mm/init_64.c                | 14 +++---
 arch/x86/mm/mm_internal.h            |  7 +++
 arch/x86/mm/pat/set_memory.c         | 92 ++++++++++++++++++++----------------
 5 files changed, 66 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b1a669e775f4..60ee4209c528 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -551,12 +551,6 @@ enum pg_level {
 	PG_LEVEL_NUM
 };
 
-#ifdef CONFIG_PROC_FS
-extern void update_page_count(int level, unsigned long pages);
-#else
-static inline void update_page_count(int level, unsigned long pages) { }
-#endif
-
 /*
  * Helper function that returns the kernel pagetable entry controlling
  * the virtual address 'address'. NULL means no pagetable entry present.
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 1895a71316c2..d9e835aaf912 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -367,8 +367,8 @@ kernel_physical_mapping_init(unsigned long start,
 		 * update direct mapping page count only in the first
 		 * iteration.
 		 */
-		update_page_count(PGTABLE_LEVEL_PMD, pages_2m);
-		update_page_count(PGTABLE_LEVEL_PTE, pages_4k);
+		direct_map_count_update(PGTABLE_LEVEL_PMD, pages_2m);
+		direct_map_count_update(PGTABLE_LEVEL_PTE, pages_4k);
 
 		/*
 		 * local global flush tlb, which will flush the previous
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7587b8ef88bb..e2592ed2d905 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -508,7 +508,7 @@ phys_pte_init(pte_t *pte_page, unsigned long paddr, unsigned long paddr_end,
 		paddr_last = (paddr & PAGE_MASK) + PAGE_SIZE;
 	}
 
-	update_page_count(PGTABLE_LEVEL_PTE, pages);
+	direct_map_count_update(PGTABLE_LEVEL_PTE, pages);
 
 	return paddr_last;
 }
@@ -592,7 +592,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long paddr, unsigned long paddr_end,
 		pmd_populate_kernel_init(&init_mm, pmd, pte, init);
 		spin_unlock(&init_mm.page_table_lock);
 	}
-	update_page_count(PGTABLE_LEVEL_PMD, pages);
+	direct_map_count_update(PGTABLE_LEVEL_PMD, pages);
 	return paddr_last;
 }
 
@@ -680,7 +680,7 @@ phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
 		spin_unlock(&init_mm.page_table_lock);
 	}
 
-	update_page_count(PGTABLE_LEVEL_PUD, pages);
+	direct_map_count_update(PGTABLE_LEVEL_PUD, pages);
 
 	return paddr_last;
 }
@@ -1116,7 +1116,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
 	/* Call free_pte_table() in remove_pmd_table(). */
 	flush_tlb_all();
 	if (direct)
-		update_page_count(PGTABLE_LEVEL_PTE, -pages);
+		direct_map_count_update(PGTABLE_LEVEL_PTE, -pages);
 }
 
 static void __meminit
@@ -1162,7 +1162,7 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
 
 	/* Call free_pmd_table() in remove_pud_table(). */
 	if (direct)
-		update_page_count(PGTABLE_LEVEL_PMD, -pages);
+		direct_map_count_update(PGTABLE_LEVEL_PMD, -pages);
 }
 
 static void __meminit
@@ -1196,7 +1196,7 @@ remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
 	}
 
 	if (direct)
-		update_page_count(PGTABLE_LEVEL_PUD, -pages);
+		direct_map_count_update(PGTABLE_LEVEL_PUD, -pages);
 }
 
 static void __meminit
@@ -1228,7 +1228,7 @@ remove_p4d_table(p4d_t *p4d_start, unsigned long addr, unsigned long end,
 	}
 
 	if (direct)
-		update_page_count(PGTABLE_LEVEL_P4D, -pages);
+		direct_map_count_update(PGTABLE_LEVEL_P4D, -pages);
 }
 
 /* start and end are both virtual address. */
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index 7c4a41235323..8e461ae43d5f 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -24,6 +24,13 @@ void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
 
 extern unsigned long tlb_single_page_flush_ceiling;
 
+#ifdef CONFIG_PROC_FS
+void direct_map_count_update(enum pgtable_level level, long pages);
+#else
+static inline void direct_map_count_update(enum pgtable_level level,
+					   long pages) { }
+#endif
+
 #ifdef CONFIG_NUMA
 void __init x86_numa_init(void);
 #endif
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 08dc69317931..36d63119df71 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -90,17 +90,33 @@ static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
 	return __pgprot(cachemode2protval(pcm));
 }
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_X86_CPA_STATISTICS)
+static const char *cpa_size_str(enum pgtable_level level, char *buf, size_t len)
+{
+	unsigned long size = pgtable_level_size(level);
+
+	if (size >= SZ_1G)
+		snprintf(buf, len, "%luG", size >> 30);
+	else if (size >= SZ_1M)
+		snprintf(buf, len, "%luM", size >> 20);
+	else
+		snprintf(buf, len, "%luk", size >> 10);
+
+	return buf;
+}
+#endif
+
 #ifdef CONFIG_PROC_FS
-static atomic_long_t direct_pages_count[PGTABLE_LEVEL_NUM];
+static atomic_long_t cpa_direct_map_pages[PGTABLE_LEVEL_NUM];
 
-void update_page_count(int level, unsigned long pages)
+void direct_map_count_update(enum pgtable_level level, long pages)
 {
-	atomic_long_add(pages, &direct_pages_count[level]);
+	atomic_long_add(pages, &cpa_direct_map_pages[level]);
 }
 
-static void split_page_count(int level)
+static void direct_map_count_split(enum pgtable_level level)
 {
-	if (atomic_long_dec_if_positive(&direct_pages_count[level]) < 0)
+	if (atomic_long_dec_if_positive(&cpa_direct_map_pages[level]) < 0)
 		return;
 
 	if (system_state == SYSTEM_RUNNING) {
@@ -109,44 +125,50 @@ static void split_page_count(int level)
 		else if (level == PGTABLE_LEVEL_PUD)
 			count_vm_event(DIRECT_MAP_LEVEL3_SPLIT);
 	}
-	atomic_long_add(PTRS_PER_PTE, &direct_pages_count[level - 1]);
+	atomic_long_add(PTRS_PER_PTE, &cpa_direct_map_pages[level - 1]);
 }
 
-static void collapse_page_count(int level)
+static void direct_map_count_collapse(enum pgtable_level level)
 {
-	atomic_long_inc(&direct_pages_count[level]);
+	atomic_long_inc(&cpa_direct_map_pages[level]);
 	if (system_state == SYSTEM_RUNNING) {
 		if (level == PGTABLE_LEVEL_PMD)
 			count_vm_event(DIRECT_MAP_LEVEL2_COLLAPSE);
 		else if (level == PGTABLE_LEVEL_PUD)
 			count_vm_event(DIRECT_MAP_LEVEL3_COLLAPSE);
 	}
-	atomic_long_sub(PTRS_PER_PTE, &direct_pages_count[level - 1]);
+	atomic_long_sub(PTRS_PER_PTE, &cpa_direct_map_pages[level - 1]);
 }
 
-static unsigned long direct_pages(int level)
+static void cpa_report_meminfo(struct seq_file *m, unsigned long levels)
 {
-	return atomic_long_read(&direct_pages_count[level]);
+	enum pgtable_level level;
+	char label[32], sz[20];
+
+	for (level = PGTABLE_LEVEL_PTE; level <= PGTABLE_LEVEL_PGD; level++) {
+		if (!(levels & BIT(level)))
+			continue;
+
+		snprintf(label, sizeof(label), "DirectMap%s:",
+			 cpa_size_str(level, sz, sizeof(sz)));
+		seq_printf(m, "%-16s%8lu kB\n", label,
+			   atomic_long_read(&cpa_direct_map_pages[level]) *
+			   (pgtable_level_size(level) >> 10));
+	}
 }
 
 void arch_report_meminfo(struct seq_file *m)
 {
-	seq_printf(m, "DirectMap4k:    %8lu kB\n",
-		   direct_pages(PGTABLE_LEVEL_PTE) << 2);
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-	seq_printf(m, "DirectMap2M:    %8lu kB\n",
-		   direct_pages(PGTABLE_LEVEL_PMD) << 11);
-#else
-	seq_printf(m, "DirectMap4M:    %8lu kB\n",
-		   direct_pages(PGTABLE_LEVEL_PMD) << 12);
-#endif
-	if (direct_gbpages)
-		seq_printf(m, "DirectMap1G:    %8lu kB\n",
-			   direct_pages(PGTABLE_LEVEL_PUD) << 20);
+	unsigned long levels = BIT(PGTABLE_LEVEL_PTE) | BIT(PGTABLE_LEVEL_PMD);
+
+	if (direct_gbpages && PUD_SIZE == SZ_1G)
+		levels |= BIT(PGTABLE_LEVEL_PUD);
+
+	cpa_report_meminfo(m, levels);
 }
 #else
-static inline void split_page_count(int level) { }
-static inline void collapse_page_count(int level) { }
+static inline void direct_map_count_split(enum pgtable_level level) { }
+static inline void direct_map_count_collapse(enum pgtable_level level) { }
 #endif
 
 #ifdef CONFIG_X86_CPA_STATISTICS
@@ -175,20 +197,6 @@ static inline void cpa_inc_pxd_preserved(enum pgtable_level level)
 	cpa_preserved[level]++;
 }
 
-static const char *cpa_size_str(enum pgtable_level level, char *buf, size_t len)
-{
-	unsigned long size = pgtable_level_size(level);
-
-	if (size >= SZ_1G)
-		snprintf(buf, len, "%luG", size >> 30);
-	else if (size >= SZ_1M)
-		snprintf(buf, len, "%luM", size >> 20);
-	else
-		snprintf(buf, len, "%luk", size >> 10);
-
-	return buf;
-}
-
 static void cpastats_show_level(struct seq_file *m, enum pgtable_level level)
 {
 	char sz[20];
@@ -1231,7 +1239,7 @@ __split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
 		set_pte(pbase + i, cpa_pte(level - 1, pfn, prot));
 
 	if (cpa_is_direct_map(address))
-		split_page_count(level);
+		direct_map_count_split(level);
 
 	/*
 	 * Install the new, split up pagetable.
@@ -1381,7 +1389,7 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 	}
 
 	if (cpa_is_direct_map(addr))
-		collapse_page_count(PGTABLE_LEVEL_PMD);
+		direct_map_count_collapse(PGTABLE_LEVEL_PMD);
 
 	return 1;
 }
@@ -1428,7 +1436,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	set_pud(pud, pfn_pud(pfn, pmd_pgprot(first)));
 
 	if (cpa_is_direct_map(addr))
-		collapse_page_count(PGTABLE_LEVEL_PUD);
+		direct_map_count_collapse(PGTABLE_LEVEL_PUD);
 
 	return 1;
 }

-- 
2.53.0


