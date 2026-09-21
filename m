Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4C0C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79BA26B00F8; Mon, 21 Sep 2026 06:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B4E6B00F9; Mon, 21 Sep 2026 06:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661816B00FA; Mon, 21 Sep 2026 06:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1C86B00F8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B713EC012E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:09 +0000 (UTC)
X-FDA: 85237469898.14.1DBFCD8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC2A11C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RapZB+cy;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p53A/KaQIOjsMct9Of5uOz5LABGxXt3L3/IO4LJKyF4=;
	b=pagPM1TnPo2iZSDpR/r0lcYUvifKTk2YX1u7nzxPYsqDw2aog2ECpPKxjf4wzI3vpOB0yy
	J10/zEe4hbLNVGu+7ESb8C/B8WwNlkiX03CZKjVQQrkeTBv8NG2oIXnn04ewzab84bA99w
	SSB3gvXG0I35oP8M8Ec2sj1QZLwYoN8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RapZB+cy;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988288;
	b=z9ddEIb3Ut2P62SXz37VSf6jNGqTrAZvy16UTDyGyounkH8pNRbsMs5c5eICvGshzVz17F
	QY5o3L0wy6Zy61HB8Y8tWmV6QY7kOC9/VuMFO21mu5xDHTWiCAesvfyHYZ0QGnhWuAQoKJ
	nvmt6SpRVkp73og1dWsp0QuSJCo403A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A52AF1CE0;
	Mon, 21 Sep 2026 03:58:03 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5BB13F86C;
	Mon, 21 Sep 2026 03:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988287; bh=QT9fPVqU5/4s3W6imYoTDQhJSgG9AGqR+95WBjnEkEc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RapZB+cyvYCqcKuvvXP8Q5zCAZ8HtO5VfaCyq+X5aXl5qtuACKqvDvIUWmBHExBam
	 zJtjhHKa+kKgXxR2PFLZdBznGeftmCGqlKRKH/Meqcz0kAc74vnCVEPpb/p/GT8OZQ
	 nnGLTw5FRGFiKQx715GBOH6ozV8GlMY9H1RMMOo8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:35 +0100
Subject: [PATCH 13/21] x86/mm: Introduce helper for checking direct map 1G
 page support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-13-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>, 
 Sohil Mehta <sohil.mehta@intel.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5614; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=cCsKnjI6qzm+njvp4POS4T02dkWd2WA7n/CKoGzKwuk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1R2L2UpoT9CAW2mhYF4L0pEeRV4+Rs981h3
 CWikwBSbGyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUQAKCRBt1cPRWsUx
 MwunDADTJF7Ucnl/y729ahXOh1c+4bQ17vWVJkTrbFm8evuZKa1BZQ1DJXx5lXQnN2dTlpT7HX3
 RFq17CtruESXdlm6fvsVMCx7BC2Hk/5varLSUEUD/USUM2ZFeJ5tjlPCfb10U6fFT0ZBusn9MZj
 nlnQfAV2nO8pa2iusqKGpXXdUFXVXI1doy+8AGcFEMlc9X1+2UfTHYFLC5/7gjghQUX0WSoW6Yg
 vatDG4UA42ssMXj3CIfFaS8+zsK2RNTPDMhELkhccaLuPoG0YHHHDp14BrmqS49ZU2TrZ06Aof5
 +9FE+RnthbyGI/nJVcLFDppo0wfLK1apIBJVEwMgxmpPAbdh0O5KJ/Jy6Sz2cf2gQJYFy28LcQe
 9FpQRoZgbkspXZeONETZOq1JRpFmftUCjsy0MMLMi7OgxA1ZYWogZ7ehZe7UnX9wJGGuLEjWdxZ
 7vKImHWTNVCMFmS6RLqnAnx1JKcEZDVAPkafX7IaDBPOBJcSHJ1X1BVTjt4S0e/v9iAiU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC2A11C0005
X-Stat-Signature: z3wgswor4zy39hzgy3w8sbed1e4r41pf
X-Rspam-User: 
X-HE-Tag: 1789988287-147606
X-HE-Meta: U2FsdGVkX19+6IbuBfRJFNgZdb6FmPzLnAY2YwzrffJwSy/4jTinNW3jfrQVWoE1g5K4GGqEi5Srd7s197JSljWCciZFnQVPD2H5uYEMDnzKYztsSohTBGajjB1jVk43eLfAhNPJQAKBxD88bdg11J1eEDvTAVZWMQqOHVpY9oPsRvEa93GvmMVwqckh9kqY8r1XQJEbKBOcpQATN8cA4Hnv06WqI6qyEW3PSnyvvTyhF7+0yXDtdJU3OpBdFic3d+FnvIX7tSjJw2QGi5bPHsQGnprF2PTNePxyLECYln1bNnZx0Nj02jX89VEwrM/QiFdz6nVoKXsQ3X6rX+NguH1fOH3oW+KCX/6RoxUhU7SOZIGmg7pEYfM0n5ngXBCvZG+93hqVRWzjOQETR2xhadLAAD+0TdTdLCRaXol6KzHx1apW4zR0+HR7OG9B9Gl8mWiGY8cG2VcBXYNuEn80h6dUPh1sIQB0BQEyataYDSkLfNDYzH+mW0B+yZPYRR6DOBrzYhCum2eqRfYCsiMs3XOfGoLd6NM/TnH4tYXZ81SC9QuqAlxaSUhfKhELpv9ZhXCIFPNoNXo3pqdX9dwRi2JsvxZA/kC+sJ0T8j7Y7p44PqMDqSVHQuQAIAHezC6C0ZPT7bXoF4+3VlqISXNfzhRBL7hEKPwr6evY8FnvsXifzMtlxS2TwA1hxpL4745M36rMhz2b8HUeh4Oj34K7BNK9WZY0CcSLVnSfTLvxYSl3Ia2wFaVT3SocTu1L2Q53V7N3gwqI414s+bNpVXtlVL5GaUwYKaNVgsud/svYf1oACDFuCw9MWuNQfHWGYzBYqh3yeQkazkxn6ntEM/KODJkHMDw2cVxC5Een4r5o/2jC7bzfLLBlync5mfg+9EJvoAYZE9a4s+xxOFpgkuewfT6dftWI1FRDLXBbJbNm2ml5EOMTddDlpSsO88vK7k9bbV25tTBc9EmDQ+s4FoO
 AcMcR+Ye
 Me3p6h4P/bFWuAiVED5opx5rI9iJFLPlBMKS6kn8tmZHXQUaibx7Sn1iRhrPK9pDJMIDir8MLqLfr+0obFmiXeaXePmRpymw24OfgaljE8g8sVSqO9ZvQUpHlveAmSnDKSAXFp/EV6Qo0IurK7sTjCJm7FmcVdKPtXopHFuQMU9+gPAz9tAOPxUfng29acq1pvHXuVcVSAlZc0yihYrUu/AK7zjwV7gaBy1EehoeMPS1uFnZpcjE5IZ/D5Uh7BNX4iTDAY8ZhZCHGhdLYpKsqIMjgGF7cT2QZcV2eZlk5dUZYQ9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

There is an existing variable (direct_gbpages) that says whether the
kernel can and should use 1G pages in the direct map. It is driven
by a bunch of other machinery. At least:

 1. Hardware support for 1G pages
 2. Kconfig support for 1G direct mappings
 3. Kernel command line overrides

Most code just checks the 'direct_gbpages' variable itself.  But there
are cases where 1G mappings are compile-time disabled (via
X86_DIRECT_GBPAGES) and 'direct_gbpages' is always 0. Unfortunately,
that constraint is invisible to the compiler.

This opacity has been historically functionally harmless; it only
leaves a bit of dead code. But, there are plans to tigthen up the
compile-time checks around folded page table levels. The build will
break if that dead code appears reachable to the compiler. Making
the compile-time config visible to the compiler fixes the build.

Add a helper to replace 'direct_gbpages' checks. Check the Kconfig
option and base CPU support before looking at the variable.

This lets the compiler optimize things better, especially
collapse_pud_page() where most of the function can now be optimized
out when the PUD level is folded.

Notes:

Use boot_cpu_has() instead of cpu_feature_enabled(). There's no
required/disabled features for 1G pages themselves
(X86_DIRECT_GBPAGES is for kernel mappings only) and the
static_cpu_has() infrastructure is just gets in the compiler's way.

This makes 64-bit build marginally larger (20 bytes in one compile)
and 32-bit builds less marginally _smaller_ (~700 bytes).

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Tested-by: Yeoreum Yun <yeoreum.yun@arm.com>
Link: https://lore.kernel.org/all/20260902-dummy_ptxp3-v3-15-5d8f5b17c25c@arm.com/ [1]
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
---
 arch/x86/include/asm/pgtable.h     | 14 ++++++++++++++
 arch/x86/kernel/cpu/common.c       |  2 +-
 arch/x86/kernel/machine_kexec_64.c |  2 +-
 arch/x86/mm/init.c                 |  2 +-
 arch/x86/mm/pat/set_memory.c       |  6 +++---
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d5f4917c1edcb..c7adc00d49863 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1163,6 +1163,20 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLER__
 
 extern int direct_gbpages;
+static inline bool direct_gbpages_enabled(void)
+{
+	/* Check the direct map config option: */
+	if (!IS_ENABLED(CONFIG_X86_DIRECT_GBPAGES))
+		return false;
+
+	/* Check the CPU feature: */
+	if (!boot_cpu_has(X86_FEATURE_GBPAGES))
+		return false;
+
+	/* Check the command-line and early setup variable: */
+	return direct_gbpages;
+}
+
 void init_mem_mapping(void);
 void early_alloc_pgt_buf(void);
 void __init poking_init(void);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c7352827f491d..4693ba98ca380 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2660,7 +2660,7 @@ void __init arch_cpu_finalize_init(void)
 		 * Right now we don't do that with gbpages because there seems
 		 * very little benefit for that case.
 		 */
-		if (!direct_gbpages)
+		if (!direct_gbpages_enabled())
 			set_memory_4k((unsigned long)__va(0), 1);
 	} else {
 		fpu__init_check_bugs();
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index c3f4a389992da..0da0e89f2611a 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -257,7 +257,7 @@ static int init_pgtable(struct kimage *image, unsigned long control_page)
 		info.kernpg_flag |= _PAGE_ENC;
 	}
 
-	if (direct_gbpages)
+	if (direct_gbpages_enabled())
 		info.direct_gbpages = true;
 
 	for (i = 0; i < nr_pfn_mapped; i++) {
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 079f8c7e9e3cd..f0f4a06584c61 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -251,7 +251,7 @@ static void __init probe_page_size_mask(void)
 		__default_kernel_pte_mask &= ~_PAGE_GLOBAL;
 
 	/* Enable 1 GB linear kernel mappings if available: */
-	if (direct_gbpages && boot_cpu_has(X86_FEATURE_GBPAGES)) {
+	if (direct_gbpages_enabled()) {
 		printk(KERN_INFO "Using GB pages for direct mapping\n");
 		page_size_mask |= 1 << PG_LEVEL_1G;
 	} else {
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index a1a061d995b31..261dda5f9f57c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -128,7 +128,7 @@ void arch_report_meminfo(struct seq_file *m)
 	seq_printf(m, "DirectMap4M:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 12);
 #endif
-	if (direct_gbpages)
+	if (direct_gbpages_enabled())
 		seq_printf(m, "DirectMap1G:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_1G] << 20);
 }
@@ -1315,7 +1315,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	pmd_t *pmd, first;
 	int i;
 
-	if (!direct_gbpages)
+	if (!direct_gbpages_enabled())
 		return 0;
 
 	addr &= PUD_MASK;
@@ -1697,7 +1697,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
-	while (boot_cpu_has(X86_FEATURE_GBPAGES) && end - start >= PUD_SIZE) {
+	while (direct_gbpages_enabled() && end - start >= PUD_SIZE) {
 		set_pud(pud, pud_mkhuge(pfn_pud(cpa->pfn,
 				   canon_pgprot(pud_pgprot))));
 

-- 
2.43.0


