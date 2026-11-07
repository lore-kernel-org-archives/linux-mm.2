Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E13D606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GlIPkA5U
Received: by kanga.kvack.org (Postfix)
	id 306346B05B3; Fri,  6 Nov 2026 23:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6666B05B4; Fri,  6 Nov 2026 23:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC4A6B05B5; Fri,  6 Nov 2026 23:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC19D6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D18F1C2DB4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:17 +0000 (UTC)
X-FDA: 85407051114.23.F7C1FBF
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8615720003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GlIPkA5U;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794025935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjmiDhGTyjFqhaR2vuKwqHt93n+hCHkzTadeMRKHv0k=;
	b=ZJmRE5N/+fSO3yPjslRy8zfvs4iCdzWLxBg7A3luj1yrYpG9rNYloRKIg1+xgW1m7uE0ti
	VWM6cL7rMFqb/oOw7TGWIGm1jyQFMsvQ4LM9xS+7vyKzA1iPCZ35+WAFD1nNr/8bHIKdH3
	05Icg/KfZOnBO8g/A/3T3DYWNTU7sAI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794025935;
	b=jlekFQofi9u0CzHUX2UwqaIJLQTnwUd8UIPUmIwuT+1B5Qw5RSsxUP3IGWXgVoty7G7GUN
	uWax6HBk3w+sYmagLJVr7MuXfKY/kAMr091S29EnbL7JQ9zfH6MI7XFEt2kFrK/KSf0xRr
	YWIee5eeZjzUjXCpUfVXkycIAdjCc7g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GlIPkA5U;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so664650a91.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 20:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794025934; x=1794630734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EjmiDhGTyjFqhaR2vuKwqHt93n+hCHkzTadeMRKHv0k=;
        b=GlIPkA5UepTLMYGwWOM6ugakctusZcpo+w8c4RpFVU0AccOt7tASqbGPhb7iudYn0r
         I3KaiAIoOs0YWYzqK6aFFkuzD09A8BIGAxzidsHvkab0JS13x73gZxRgb9FCmbLgLUyu
         PrNswPw3gAv4W/GADthc99GMo4opo0q279nO/7cYPFod8QCEZ3TKr4GSnX4RZfDi62av
         XGL19XvEPcrxCwhKSb2/aiRRGvfRBEo8oMQSnEqX0E5woVwfe9aaf0hbGklcTqvIm5q9
         iXfkvJf99QIFK+H93uyfJ2Vv7dmJr6OOWUwExSk4xSrnQ2K31y8oChdFDGBijYK798a1
         dbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025934; x=1794630734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EjmiDhGTyjFqhaR2vuKwqHt93n+hCHkzTadeMRKHv0k=;
        b=WYPIiF0JK2Lu2HiXI32O+zZSsICTBRtWCYC6ot7lnSqeN+PVEhAI+MtgRkkcIYOPu7
         G3CFdeYedaw5M5270A8X8zhzynEcZw8Xx23RsTgD0ydX6npcM3TsfZCIgPc97xulBhh7
         /Fwx07fsAVxCchw38z2d79aK4qSbF1/35PfEwPSQ95pVECyl78FZ1OWsuwe9Ua9gO/tG
         PdSdGH0YzKru5SDwSrGQw0nwI2jBMzx7zJGEfipOtXZuFoHcdF52LzKWrJp1yiUQEWvo
         Re8gq+hf/cDMGgNpeVyyebSAXlTqSMfYPtONPFM/15K8gARYty1ed3FvSoBChlDze2Uy
         9UHQ==
X-Forwarded-Encrypted: i=1; AL+hErHcMJ8jj1uL4nBhGD840Nyd940fqFo1BN9v8H6skIpHU8DelsjSYmAm5Qsgt+2btTn09k2YEQ8hXA==@kvack.org
X-Gm-Message-State: APuU4Z8EozTzJr1iPSamUg4jzCJoAiNtk8qD23lqGBP+yKHb/wljscr7
	pisnxow1YzBjdbmRvCoLT9FTx22UQlBhi1vYkym9NxWGUPvj1fWo1zvZgW0LDfL4Y2w=
X-Gm-Gg: AYBFou2id+WZm9H9vq/aj8IjB95zPV81oELMhmy00mqrj5QKxOQDZw8f1jHU0h1LCHN
	YWqE6+k4wrC4l11X2zLiYVa0vnbwq24bvtkrDh6RR5K5Elr8tR9Nzp3wWuA8w5zz+TrK7HWAbUS
	UY7srHNm7HhXLTr0CxKmQ5S3ms3M75pgd3d/0c0zEsN+WGBeXbQ9Ry/WYBBBQ/puqqe4g4SNMBq
	uhjoqB5Bfzx1TcMnNjIdsPMM0LSa6e8vVGMIdEd82Lgu7N+nE8GCzQxaNWUMLCWOu06T7NUG0d5
	idMfY1hs6s4JMapqqdpiBalILyxTQwUwS7kFq/qeLWMvcdpX5b5GlD50GK7o2f88qb94fAhm6Pe
	PROssFA5CrDwJg9S9bUQiDY7XBj+Pl9U1x3k1da1g2EOAtzXmd2oADjGcBXtfnkl8xLdJCNpIst
	x+eHzZwQXHUN+4/lpshrFZHgIR94vT2fl5HFmlDRPDUss4fy+JJZGRkjnOROPgiZhNILsnXXVgG
	Bq5O9vGgigumkqHWi1gZnlnAONW81aySTspN37lLaz+ibOIc0KwlbENiWfs1YdfBpqh3Q0QXOct
	VCZPtgz2VYThQGNH5I+fIuIKYNsz35ygduI3mhUT2zyJyibQPM+vVhSJCJCo
X-Received: by 2002:a17:90b:28c4:b0:3ac:8897:7baa with SMTP id 98e67ed59e1d1-3b0db7114f1mr4190441a91.40.1794025934315;
        Fri, 06 Nov 2026 20:32:14 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10584b66bsm1578451a91.14.2026.11.06.20.32.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:32:13 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Date: Sat,  7 Nov 2026 12:31:19 +0800
Message-ID: <20261107043122.25650-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107043122.25650-1-songmuchun@bytedance.com>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: cykgp6gf3ddm8cz8p16s7jdp19xghpiw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8615720003
X-Rspam-User: 
X-HE-Tag: 1794025935-358208
X-HE-Meta: U2FsdGVkX18sLGpoCVibk0XRphyVuu+l76FhoInntPkKzTHJOa5hHRAu6JWVfOrNn5ukR7DQVOkI02eyL8C3V4mojYeosNbA2fQQtGjBp0z9iM96/aAmDgKTb1wFtenBPzNFmSuPvdanvdgy4sYdiKHYUnWFfxp0Qd/zwxWiQt/YQ+OIknI4r6kjQPHWq26T/AamkhPWo8zPwFA7NUyiwamRssOrAhPrmC1sKQXiI1uYXCc85eGkhNueBLvJQ+bT44nxAjij1v5xr2uWqafv7Tlm7olSEJ96lzwimkWRrneV0oGoow/oyz3yFKfewHpoinZsEtE51JtcvpyO7p+hZIzNMoaDltcsT+dElfarE3pbqzUIVxtAcnJUev+eGvlR7B33KlyeLJ9N+P9QLF+fXSWSrWAORkDUqxg0Fa8yeimMjM3t6iZ2ZJCW2Fdete8JYNpaP/j9Rea40ppq3vnYb10VFHS5oTnq3ipY+Xb7XL8HoeJ5uWsnQoyErzVFkVPF+R91zvX6AzR+uEfke2uq4g66xPHyIJM2lwITwc9r4L3/C37P7ksCLHlknuFNxOgNesi4Ey5HzdWcQ4xnUAtHLVSdjW5IcTeWHtUqjBiFeLKACBMTiq+Dnad4QZPPl4mFiqiU1wcBeY2Iv6Jyd3uXUqbhB3ZJwwS3s14uiGJ5hBnlRED248hexX8lnW0sqsrSNJiyn2U7Tzi/dB5UoKDRU14LM5M47LOHOkGOXYm5ABzo27DNsKK/r+BL5Xz4ecSFMvYi382EKF3v+MJb0Da2/Otx/qTVKsUf1525DVzprEzteSkDeeVArlV8GkAqBq66EweXrH7/TgCd66lo+YngnTKvWzaI2HOgbe5k9a9ohvwkj5EiBPyYmVzWQAtTg/DSJArmObTOkUNDBafoFDzurO681v8L+5Mo4ekrBNMKsGpVPGSyFIjgWnKi1k29ZKjj3mEuGbEMSvEXOsQxnRM
 QpqonIcW
 yq16gG4MUOsFBBC4Fr1OhSvAXgBHrc0TmI3Nv5vOQmixOLORBI1XtmYRnfvEgSn9W4TgNXPl9vGqwNF11VqBPpwHVzMNdkNbq9iy+Yf3LJdnrEFStN692h7pKbJxPCTvwhWXWrkU3nCg+ecxTfxqeFNtefHGRUgkOyvbSUaFDAcUi473S2tbkzHH36/z36QltNdkZPF5C/b2/E5WD1lCpUBzcCpL7itDisxOVTwGyRakaQJdYf4S7yvVdgFgbQz9cnYva/Zh7GrTnN2wMkDMQwqGAdfL52Kz5VOevcUstqSE/8OrCEEyx7YjTCGo0Lgpu42I5HUTDOAXPiHBt5EN4nU1nW+25wva5AnX3H22npPPhksmD7wyJVyY3DCf5Go79h6thlX2KVKZeSS9lmU/pOAYF3v/Lr7jlZEgdcb9ICNhbbQIU3MiSmK6fo+FmKdgcVLTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Whether the optimized mapping can be used is now decided in the
architecture-specific vmemmap_populate() path. When PowerPC has to fall
back, such as on Hash MMU, it can disable optimization for the populated
vmemmap range there.

Add section_vmemmap_optimization_disable() to centralize this fallback,
use it in the Hash MMU path, and drop the radix-specific
vmemmap_can_optimize() override.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Move section_vmemmap_optimization_disable() to mm/sparse-vmemmap.c
  to avoid the LoongArch header dependency (reported by Sashiko)

v2:
- Add section_vmemmap_optimization_disable() for architecture fallbacks
- Use the helper for the PowerPC Hash MMU path
- Include vmemmap-optimization.h directly (reported by Sashiko)
---
 arch/powerpc/include/asm/book3s/64/radix.h |  5 -----
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 10 ----------
 arch/powerpc/mm/init_64.c                  |  2 ++
 include/linux/vmemmap-optimization.h       |  6 ++++++
 mm/sparse-vmemmap.c                        | 17 +++++++++++++++++
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 8452a2714cb1..df67209b0c5b 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -351,10 +351,5 @@ int radix__create_section_mapping(unsigned long start, unsigned long end,
 				  int nid, pgprot_t prot);
 int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #endif /* CONFIG_MEMORY_HOTPLUG */
-
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-#define vmemmap_can_optimize vmemmap_can_optimize
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-#endif
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 2924604fbb38..63f369d296b4 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -978,16 +978,6 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	if (radix_enabled())
-		return __vmemmap_can_optimize(altmap, pgmap);
-
-	return false;
-}
-#endif
-
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
 {
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 0e777d7dc332..7329fcacdaf4 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
+#include <linux/vmemmap-optimization.h>
 #include <linux/swap.h>
 #include <linux/stddef.h>
 #include <linux/vmalloc.h>
@@ -281,6 +282,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	if (radix_enabled())
 		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
+	section_vmemmap_optimization_disable(start, end);
 
 	return __vmemmap_populate(start, end, node, altmap);
 }
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 858311a71b0c..22e5a322be0b 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -63,6 +63,7 @@ static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 }
 
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
+void section_vmemmap_optimization_disable(unsigned long start, unsigned long end);
 #else
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -79,6 +80,11 @@ static inline void section_set_compound_order_range(unsigned long pfn,
 {
 }
 
+static inline void section_vmemmap_optimization_disable(unsigned long start,
+		unsigned long end)
+{
+}
+
 static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return 0;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b8b55e12f5ba..57aa5c2d8034 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -232,6 +232,23 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 
 	return page;
 }
+
+void __meminit section_vmemmap_optimization_disable(unsigned long start,
+		unsigned long end)
+{
+	unsigned long pfn = page_to_pfn((struct page *)start);
+	unsigned long nr_pages = (end - start) / sizeof(struct page);
+	struct mem_section *section = __pfn_to_section(pfn);
+
+	if (nr_pages < PAGES_PER_SECTION) {
+		VM_WARN_ON_ONCE(section_vmemmap_optimizable(section));
+		return;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SECTION));
+	VM_WARN_ON_ONCE(nr_pages != PAGES_PER_SECTION);
+	section_set_compound_order(section, 0);
+}
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-- 
2.54.0


