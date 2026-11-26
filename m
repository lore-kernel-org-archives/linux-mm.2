Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF01606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zl+CRlyx
Received: by kanga.kvack.org (Postfix)
	id EEB756B0617; Thu, 26 Nov 2026 06:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2286B0618; Thu, 26 Nov 2026 06:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD81D6B0619; Thu, 26 Nov 2026 06:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCAB26B0617
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:22:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56709120CEA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:51 +0000 (UTC)
X-FDA: 85477032942.27.37D1DD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A65911C0009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zl+CRlyx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692169;
	b=P+dKhdhrxwOXq5zsrqLmgE6mLeFShGKQyQWYwR3BGb2jsA+Vfpk24JmqbqZ5Yq//4GSWPZ
	Ty8YjJzO2wW4iBDYVJIT6fyQh0wJHGtpCsU3yCjgvUfREXcbGYk5+qcx0X1+b5+LnlLbTs
	9m+d0gGvaFRivfmvlXE+AXfQHq3VFos=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WYcKE+tNEbcV6PVwG1N7LpHdq4HcIVT1zq0dfG4sec=;
	b=1vz5NLE7HCt9wAMBDwYejGTWWC6dZqMtef5qSlM15s7SaKW8ZmEgx/Is23BNz0MabjkaY+
	a2eabxEcGdNUTlhbJXUci2y40syhUewffDcDjXOopsjO3xPjJgxq+RKQSdyDodypPaoCyQ
	kWVkNpaoDp+6NseqZKLiNiSCxFK8vlY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zl+CRlyx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EB9560D9A;
	Thu, 26 Nov 2026 11:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB421F000CF;
	Thu, 26 Nov 2026 11:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692168;
	bh=6WYcKE+tNEbcV6PVwG1N7LpHdq4HcIVT1zq0dfG4sec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Zl+CRlyx2I87IdbB1JjDCBPiNmKv4bM3IAC45ktE5s3I91L2jmCmRUoptnipGkKgl
	 BUE5kN97wXFLUC85uzwNpJJy7KixHU2IXlqkidLGKe+3woRJZHzcPXmlb+AxWDuKBB
	 UPGryb2k5YbIZxUqTu22JWldXgFR2GhweHJsnywyofX6FCMS+197XcSD+PpDSV91di
	 0Robh4VbtGiy65suWKd5uGtTAUBp0SYHIy2Y2NU+abhtWG5slvBzvF2XW7wLKh3XBs
	 MK+nfJOsSsKaW0gMv9BnXjO4gNsLD+feKOCcYwglUygk2LWwCivUbj7eMLAOX1Qa1b
	 ua3YBSB8LM7wg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:15:05 +0200
Subject: [PATCH RFC v2 52/54] arm64: count the mappings of the linear map
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-52-723f1e33c3d8@kernel.org>
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
X-Stat-Signature: 3cj1mka6sdcrgk3x1qsno8661edkdiw9
X-Rspamd-Queue-Id: A65911C0009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795692169-66890
X-HE-Meta: U2FsdGVkX1/jo5kdrZ73Ofez5cpSEt3z4VT0AggdChnxT+RaFFediEGfrARwKZhpnfJjTbJBlQBnBkBP4TOQQ4ct1zyTiZNy8/QYZ/DzDljtyka02QIzsLHvCSerCmtqoK6c+5E92hBOuxUFDHHluATzfJ739lYh0WAEPBef2y0rmnqfM4SbEkBUakOdgIVzHbDhE1o9EbHPwp+oSykDwkGHO55VJ1y8krZHZAzf2BHbrWCgfeIhJNADrKO9RChuL1hLzEY3FTjZbDtN+0NT22oaQaVuLDBRwCv0akDpFoyE2++MVC9ianXy7pMVeIdt7Mpvd57SP9wTWL/4ov995+s/YnF4F2TThieX/uydUkM4Hz+FZidGzDoXpjfvv2zmKndWu+g5hT2t9pxCobWe0W5hKMpS2zUIu+v59OA66KwWevmv2uk1kVrWU4kfCrfTsPsIeNWAKXQStTpAI/RviwHXFwE2QevFkFhO+K6fBAg5O+g6FyVgC2YeQoY4c0RfI1YTZAdXvrvJhNAPsRjV+Nt4ON7KoGxPzu0OLlS30o/M1UUpgD/XHAtk19Ez+18ldU1bE4/rvJqvlXpU9JrcK80qzLs4/inbKtOQIyoKPsU2oR3mnSIDmisMq657K4r2Kp9VM7Vf4zNWCAUYbPRYf1FVbZaxqeBfNGgPiO5L97LE6ymDJfa5U+SDxCWgOtFE1Igflu9+WSFNcm020yBd88s3xRUyQmX+D9SEzCZKSMzN8R3LaMwnOEx9afp2JwOOaX/TlJeRQkacDjlI3MRh1YEYp8Gyr63UXGjQ/2IFpVKsPSJdUPMsmG3VignJ9icvSHFu2azSk4noHs88okDkHpWcLL6XZ+cGSjZYTlLk3mzcBnaqz8ijqLrQcTtv6rXHwUmybiteKRwXpAVwTYJz3t/b9i5qz8R9K7Vj4jlg19zEN4tb4Wh1shJ1DtDx/67lmkLUrSscwNDgyKniLU1
 oysDKjJl
 qFHDtcBVWxt4/hf1NhgxSZdN8oqIAyzqlA6pBVhBoAogcdmlngozn9CqKDukxwtsTSZQCyXaTo1PTxtQ8zFqd7ZsmiBeM+YlL744wxBjoUdqJYPb6ecQAGUdPPrmfX22nKvJxsqDO2MllxwvwfN+855gCLiQkCxq/cagd414fy40sez/06CCVOnpb/anFrIe2p2zNykbKw7ro8xpf2SvYnjsh3uFnyPrZB9nvtTVtRFpY/ld9+JWgfE0T8wjEybuV3X0ZvN2sY9YFmr2zkSXDEzbZi4E1Y62S0UpLF19IBUaahnsx3aFvzMivh6ZG+sk6ZZzEfKauF1IB1YwVUgxTP6q1MtY7k1OTOEw7uRpl+h+Ze2Pdq7wgIjMfjrdGvuC/mkpmNpR2XUZyZdR7B5iZRQ3kgGaiPw3s1TLIpU/bPlcNzOxgM+dYfOd4mJ1lv1JjMY0cCctb8pyrqGfH2OGCNab/CzVzjGe4FmYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The core keeps a counter of the direct map entries at every page table
level. A split moves an entry to the level below and counts a
direct_map_level2_splits or direct_map_level3_splits event in /proc/vmstat.
The counters start from what the architecture mapped.

arm64 never counts its linear map, so the core finds no large pages to take
a split from, and the split events stay at zero.

Count the linear map when it is created at boot and on memory hotplug, and
when memory is removed. map_mem() maps the kernel alias and the KFENCE pool
before it maps all of memory over them, so only the entries that were empty
count. The split of the linear map at boot, when not all CPUs support
BBML3, bypasses the core, so count its splits as well.

Report the counters in /proc/meminfo.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/mmu.c      | 28 ++++++++++++++++++++++++++++
 arch/arm64/mm/pageattr.c | 13 +++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 40c5ac95f574..c415b81fb6f3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -160,9 +160,19 @@ static void init_clear_pgtable(void *table)
 	dsb(ishst);
 }
 
+static void linear_map_count(unsigned long addr, enum pgtable_level level,
+			     long nr)
+{
+	if (__is_lm_address(addr))
+		direct_map_count_update(level, nr);
+}
+
 static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot)
 {
+	unsigned long start = addr;
+	long nr = 0;
+
 	do {
 		pte_t old_pte = __ptep_get(ptep);
 
@@ -179,8 +189,12 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 		BUG_ON(!pgattr_change_is_safe(pte_val(old_pte),
 					      pte_val(__ptep_get(ptep))));
 
+		if (pte_none(old_pte))
+			nr++;
 		phys += PAGE_SIZE;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
+
+	linear_map_count(start, PGTABLE_LEVEL_PTE, nr);
 }
 
 static bool pte_range_has_valid_noncont(pte_t *ptep)
@@ -274,6 +288,9 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			 */
 			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
 						      READ_ONCE(pmd_val(*pmdp))));
+
+			if (pmd_none(old_pmd))
+				linear_map_count(addr, PGTABLE_LEVEL_PMD, 1);
 		} else {
 			int ret;
 
@@ -410,6 +427,9 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			 */
 			BUG_ON(!pgattr_change_is_safe(pud_val(old_pud),
 						      READ_ONCE(pud_val(*pudp))));
+
+			if (pud_none(old_pud))
+				linear_map_count(addr, PGTABLE_LEVEL_PUD, 1);
 		} else {
 			ret = alloc_init_cont_pmd(pudp, addr, next, phys, prot,
 						  pgtable_alloc, flags);
@@ -750,6 +770,7 @@ static int split_to_ptes_pud_entry(pud_t *pudp, unsigned long addr,
 		return -ENOMEM;
 
 	split_pud(pudp, pud, pmdp, false);
+	direct_map_count_split(PGTABLE_LEVEL_PUD);
 
 	return 0;
 }
@@ -771,6 +792,7 @@ static int split_to_ptes_pmd_entry(pmd_t *pmdp, unsigned long addr,
 	if (pmd_cont(pmd))
 		split_contpmd(pmdp);
 	split_pmd(pmdp, pmd, ptep, false);
+	direct_map_count_split(PGTABLE_LEVEL_PMD);
 
 	/*
 	 * We have split the pmd directly to ptes so there is no need to
@@ -1424,6 +1446,8 @@ static void unmap_hotplug_pte_range(pmd_t *pmdp, unsigned long addr,
 			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 			free_hotplug_page_range(pte_page(pte),
 						PAGE_SIZE, altmap);
+		} else {
+			direct_map_count_update(PGTABLE_LEVEL_PTE, -1);
 		}
 		/* unmap_hotplug_range() flushes TLB for !free_mapped */
 	} while (addr += PAGE_SIZE, addr < end);
@@ -1458,6 +1482,8 @@ static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
 				flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 				free_hotplug_page_range(pmd_page(pmd),
 							PMD_SIZE, altmap);
+			} else {
+				direct_map_count_update(PGTABLE_LEVEL_PMD, -1);
 			}
 			/* unmap_hotplug_range() flushes TLB for !free_mapped */
 			continue;
@@ -1489,6 +1515,8 @@ static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
 				flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 				free_hotplug_page_range(pud_page(pud),
 							PUD_SIZE, altmap);
+			} else {
+				direct_map_count_update(PGTABLE_LEVEL_PUD, -1);
 			}
 			/* unmap_hotplug_range() flushes TLB for !free_mapped */
 			continue;
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index a2f5266b77b2..5e6782ef4b6c 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/pageattr.h>
+#include <linux/proc_fs.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -16,6 +17,18 @@
 #include <asm/tlbflush.h>
 #include <asm/kfence.h>
 
+#ifdef CONFIG_PROC_FS
+void arch_report_meminfo(struct seq_file *m)
+{
+	unsigned long levels = BIT(PGTABLE_LEVEL_PTE) | BIT(PGTABLE_LEVEL_PMD);
+
+	if (pud_sect_supported())
+		levels |= BIT(PGTABLE_LEVEL_PUD);
+
+	cpa_report_meminfo(m, levels);
+}
+#endif
+
 void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
 	enum pgtable_level level = leaf->level;

-- 
2.53.0


