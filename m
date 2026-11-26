Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F42606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oK4AqxJG
Received: by kanga.kvack.org (Postfix)
	id BD95B6B0604; Thu, 26 Nov 2026 06:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1646B0605; Thu, 26 Nov 2026 06:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6EA6B0606; Thu, 26 Nov 2026 06:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4756B0604
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21C1B403E2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:16 +0000 (UTC)
X-FDA: 85477028952.22.33A2353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 758421C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oK4AqxJG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692074;
	b=iv3k4EYjx4I6pOqgbqutubrT2dG7tNNrILOG1I2ixsCes40KRMybeBt9rKAKdEks6K+VWw
	K+4q3KlxAf7BwG2syQALF1O00XyspT7lezl+vvBbZQhbCJ5NY7k8zzKuhA7Fqq0QVyMrFu
	HS+5pKALYhnJAr9tC9Fd/Rg1R0JskRs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acVZadH+VFBFC1d1dLbutXfDJETNRTgRtEhv1loN3Kc=;
	b=ZVC6MHCsK8F6QaWAblRKM3l6+K3F98ZXF3uFOXkkjOB4XmM0C3ESMhw1dFQcf9hMU3Loj+
	KdVgRmn0oH/4PdAPIGs9hNvGCIlamEXFUuiwI1/Ban9T17QX1aaTbxrM8bpF7Ytt16bymo
	51MZMMeKItSuQ+hfAVP4ERnCjR7m4po=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oK4AqxJG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 174A66338E;
	Thu, 26 Nov 2026 11:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F331F000F0;
	Thu, 26 Nov 2026 11:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692073;
	bh=acVZadH+VFBFC1d1dLbutXfDJETNRTgRtEhv1loN3Kc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oK4AqxJGy9uqp40xlP/Jc0iEDwgFDT9uMRNK+Zl8qcl8G0bhKbCFVgHRfykGfNWh7
	 rtJNH451csTci9e1tSOqJ5qyT8T6vptgOd9P041BiJa0SV5y21pqGOAEXr1+d+1WCS
	 cIpdBKH1Fy/CULw7Wl50ENc3s+c3GzFxSO5iYs+XhEAWpLIAX9icNKRJR3koOxCV0Z
	 mHqfTR7sjYIttOG7RyHW9UfPkEmc9uo53WuWB6vqHW+ROeoi9ZN6xtbRTt34C0QJDV
	 AQKxlsm/4KiSBcg5omjktitzKas7r73CDVkNZYMMMl3IfwUGRR6riIvMyHQ81TcoJ/
	 UqKiSDECBOiuA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:55 +0200
Subject: [PATCH RFC v2 42/54] riscv: count the mappings of the linear map
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-42-723f1e33c3d8@kernel.org>
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
X-Rspamd-Queue-Id: 758421C0004
X-Stat-Signature: zscnbgtoi5xp91jw4sjfj73nwkygi55j
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795692074-325703
X-HE-Meta: U2FsdGVkX19vcikrXntAWO62Hzk4Ts40LC06077k1nRsj3sSw5QsjrQphel2o+SJNRBh0sCk8+BQcL5z3+caGRM0FUgbnJ5kK2wjyTaOVNqgOUh27UVj6lByp+7eMxje4WgJ00zFoFILSGZgCaVuof2zrGuFcb7KkqDLaPTEnba9ETlY7IvnhpJ2puokufxYKM6jhcLkWdjwgxe7GQUPJwbnlTLxG73Hc8lwk8skeI431FZ75wCKwcLeDu51rra4Z71ID8GXbZMEuvt+hZDeUhBrP8cZShRqkpYKb1nufparvz97+QMXc5xFhmYMiarbDqkAyzhXj1mcav3YAC0ykTkBTFBFItf1iwLQVoTWl1cakLl/Cfj5ZpwGtfWg7ffKtUYIuRuLn0NifL9+/H3+3WGI9nzxue+lEWkQWpziVhsHNnS95wzo+dHgWMfBXHPzKLHp8IxxN3nD6XsOMIOEHAQalGYIuCqS6oyVPA3NOF0kqFer58Q7IPWp+lVL4/dppulUmF8bowVQI+dduQxPOCNi5UoqGD0OszjDOHmm8E5D1JR7AVu/unFmFhqb8kiRnNA27WGS+sndBEw0u+xa3/zkmdC7YGQH5q/4v+GEzqy4aN4OnhvpAkgVp0lzCSqStMcgygOHVV1zavT2MYNZrAKwHnNLpGamjAu1jzgbaoUfvK5c6djZL9eRJ5E5V3t+YUVwyB3+GNk2pK+ix4ke1oYCXCZhCXV7ZOOTH1BIZU59hox7tV/uBB2FN3qnFZr+Lvd1F5spX/g0y2jQ/FruGyfgShqVFPJq4CW8s10ovS1HXGXRQFVGdzyQGI3Ga+KfdQwmjgfNRpcDJrowGmof6DgN7i1nHs9DTVXtRdVdrYajxp19LPIHbeCfq9RaLdz9Dicbp+39fy9L6wFXNLk7lByzDLkeYd0U6VQ6VYWKt1ceKeC7Mpg0mP8Lk8KquBCQSM6iodo4oV4BN+76sXN
 mjfdA7R6
 ZIV11DkSUyNK/4rVBwkHyh2tdzGz7DwFmKopFsPx+MGbi58XB8GechyNq/0cgTqgGA3gLYRf2X9KyjfowfYwtUfKffejkJUF76yDHHQI5V2V7n8rq0hP27rFYF8htcAuw49LbCqDBCNL4/9UIKgx5CxjJ9v/c/gj5J/evtwrMji5WGt5kUXWIxx3FE6P228bttbUs5Wi+zX0bUgDiraJMeuLFbd9eRvygt4HOP21V8aL2QbmGesgcboASYkcpYfi0w9m+Nz2XyqGzOqo6qtH6x2l/30WygAQe0pfPEp3uwCxBa5TiqIgnOQmtHjOXUq0Y4xjnz2C/0LEiYvOhjpPcj7DiWW1kdL96GhCrEt+yAi5A7JO8IjEQSYmciRPtaCd3wo2va+fNip6xJtbm2DypjjNMYKLLOJQAvhJmrk0WDgHPWjGgtcBZTxkwWKlAHFvoCqOHxaNfRQILXEYFB6NYyelB0KdrUH6ngk9P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The CPA core keeps a counter of the linear map entries at every page table
level and displays the "Breakdown of page table sizes used in the kernel's
identity mapping of RAM" in /proc/meminfo.

When a large mapping is split, the counters of the split level and the one
below are updated as well as direct_map_level2_splits or
direct_map_level3_splits event counters displayed in /proc/vmstat.

The initial updates for these counters happen when an architecture creates
its linear map.

riscv doesn't seed these counters, so the CPA core cannot update them
during a split, and the split events stay at zero.

Count the linear map when it is created at boot and on memory hot-plug and
hot-remove.

Report the counters in /proc/meminfo, as x86 and s390 do.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/mm/init.c     | 20 ++++++++++++++++++++
 arch/riscv/mm/pageattr.c | 15 +++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e1bcc3a16129..b466db515ee1 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -28,6 +28,9 @@
 #include <linux/kfence.h>
 #include <linux/execmem.h>
 #include <linux/vmemmap-optimization.h>
+#ifdef CONFIG_MMU
+#include <linux/pageattr.h>
+#endif
 
 #include <asm/alternative.h>
 #include <asm/fixmap.h>
@@ -1201,6 +1204,15 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	pt_ops_set_fixmap();
 }
 
+static enum pgtable_level __meminit linear_map_level(uintptr_t map_size)
+{
+	if (map_size == PUD_SIZE)
+		return PGTABLE_LEVEL_PUD;
+	if (map_size == PMD_SIZE)
+		return PGTABLE_LEVEL_PMD;
+	return PGTABLE_LEVEL_PTE;
+}
+
 static void __meminit create_linear_mapping_range(phys_addr_t start, phys_addr_t end,
 						  uintptr_t fixed_map_size, const pgprot_t *pgprot)
 {
@@ -1214,6 +1226,7 @@ static void __meminit create_linear_mapping_range(phys_addr_t start, phys_addr_t
 
 		create_pgd_mapping(swapper_pg_dir, va, pa, map_size,
 				   pgprot ? *pgprot : pgprot_from_va(va));
+		direct_map_count_update(linear_map_level(map_size), 1);
 	}
 }
 
@@ -1599,6 +1612,8 @@ static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, un
 		pte_clear(&init_mm, addr, ptep);
 		if (is_vmemmap)
 			free_vmemmap_storage(pte_page(pte), PAGE_SIZE, altmap);
+		else
+			direct_map_count_update(PGTABLE_LEVEL_PTE, -1);
 	}
 }
 
@@ -1620,6 +1635,8 @@ static void __meminit remove_pmd_mapping(pmd_t *pmd_base, unsigned long addr, un
 			pmd_clear(pmdp);
 			if (is_vmemmap)
 				free_vmemmap_storage(pmd_page(pmd), PMD_SIZE, altmap);
+			else
+				direct_map_count_update(PGTABLE_LEVEL_PMD, -1);
 			continue;
 		}
 
@@ -1648,6 +1665,9 @@ static void __meminit remove_pud_mapping(pud_t *pud_base, unsigned long addr, un
 				pud_clear(pudp);
 				if (is_vmemmap)
 					free_vmemmap_storage(pud_page(pud), PUD_SIZE, altmap);
+				else
+					direct_map_count_update(
+						PGTABLE_LEVEL_PUD, -1);
 			}
 			continue;
 		}
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index bb8629da0d1d..22826ba688c3 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -5,12 +5,27 @@
 
 #include <linux/pageattr.h>
 #include <linux/pgtable.h>
+#include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/bitops.h>
 #include <asm/set_memory.h>
 
+#ifdef CONFIG_PROC_FS
+void arch_report_meminfo(struct seq_file *m)
+{
+	unsigned long levels = BIT(PGTABLE_LEVEL_PTE);
+
+	if (IS_ENABLED(CONFIG_64BIT))
+		levels |= BIT(PGTABLE_LEVEL_PMD);
+	if (pgtable_l4_enabled())
+		levels |= BIT(PGTABLE_LEVEL_PUD);
+
+	cpa_report_meminfo(m, levels);
+}
+#endif
+
 void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
 	pte_t pte = ptep_get(leaf->kpte);

-- 
2.53.0


