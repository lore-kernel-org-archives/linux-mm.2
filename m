Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E353606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=CyCmsMsS
Received: by kanga.kvack.org (Postfix)
	id 58C846B05B7; Thu,  5 Nov 2026 01:13:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564FE6B05B8; Thu,  5 Nov 2026 01:13:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B956B05B9; Thu,  5 Nov 2026 01:13:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD806B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:13:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4C251403AE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:13:00 +0000 (UTC)
X-FDA: 85400047320.06.6BA1BFC
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE8FD20008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CyCmsMsS;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793859178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKRQNq+YvdEons4PssMSMvDyZ1aDaAIj0dg+GEUgY+U=;
	b=Qpmd7sxrj/YfoRizbFeVGWX/v1Voj9lzBs7YcMdInKTizt/JnrxJUmdrnjkQB/OaEl80Wl
	zrOVMpVTIKWp9cqQZQJGJrrtkZogj1msLeZNlwXSlZuPPiZjKo4gpBQuRP/bQCYDEP6/jo
	Z9u+6L3tk6Q+UBY0OGFPlXwaetOHCl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793859178;
	b=HYLd7G8JhabEG6r7gYoV0h+Hx7J22snHj64RhwdR80tgh9M5B5ciPNT5jzbaot6lRXzt4c
	eP82z4c3ULj/DYzzmzfyFZPjCb2L/Bfw0KxCGmiDxVYWBRdHAarBGp+g+uOq6Km3Kp+V5F
	by/1hRCNUia6SC/pYyoAEX8Vg3sdoZQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CyCmsMsS;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ac78f4c10bso662424a91.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 22:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793859178; x=1794463978; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kKRQNq+YvdEons4PssMSMvDyZ1aDaAIj0dg+GEUgY+U=;
        b=CyCmsMsSNs699P37JiMGDX64Ni9uCLji6ilAvIafuwSf5V5q/YzK4PumYciqckZwec
         dWVo/z6yoZEcM2KwWSsjDzsxaaOPT/apkvi+k8TIZR6sWchi/0fk/7AJQ0t6SOWCphMJ
         o+D9J4veHiJwy5+tvsJ4NIGVKVfRaEjF8bkQaETL5WN3iSGV9kL0ItrH03dmyb+Fwyr3
         mWOwSSYnU1km26Uh0RffA7iFKmFf0AXmcHipZAuRK7wXDwAx3j5pQ5x1TDWXkf8srMwb
         Vltcy8At1hgdN2XML8JC2boLym+wjZRFh0ViCndVRSdAX7Oap/3Fr8pg7E9ijs9/zZpG
         yApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793859178; x=1794463978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kKRQNq+YvdEons4PssMSMvDyZ1aDaAIj0dg+GEUgY+U=;
        b=BwT/bOF+Ia5G6p58rUhnw274ZVZrqrlBCMxdNIYvpDi6Xi5MLe5CPqYHWWUeEXEJWh
         am3SRBVCrJCYWOLbpvtbCAKEE4hUHwbgUxf4UDZhZ/LVBcjrizXisP++PDzwmkpRvB2s
         pegV4+ucRuWTMdzo2405rdfMR9qNvISk9S5HQaha+Hl1KgZUJs2UxTVnOx7tiD4EcrUL
         HDLs3mHWvoCtlkkyyvdcDgGss5xW4VD6ZgauTncpX01izUPCgOrGkfYZxSBKOzBkf1gd
         FatSk9728ADRBUix82q6ZUFNYWjSb+ftWInXdDA/xw7hbNJ7wJTCNIJmJ+cuqaEfGgcf
         4Uig==
X-Forwarded-Encrypted: i=1; AKwUvBwxXjkGiwI33uAr+oOaSV/Z3MibIj+ipfcEV6tHFIY1rrmikHWxXKSViEAbDYq4Pvn6fOmCUaYfCQ==@kvack.org
X-Gm-Message-State: APuU4Z/5zo1/i1wcpH9+OznwNikswDgNL9FAjZ0oN96ROnc8esK4FjRN
	fEFiJ8SQwkUeaq9s0jEMSX5/v+2XhUbAbayk1yrmQ3/ZXe8k4eL90JmgEMFNAObaz5w=
X-Gm-Gg: AYBFou0h9qb0HUw49w8SfYezSrXSvL/laIs5TL/p/EBzTSmp4FL8QxTMDnlRwo/YGeG
	TOZbzY9CtqkmrLp0EH4y8n8jDsWhaysi4seRCX2v3dcYWDc7U38VkI+bEItwH9j8VrtrRtdVUwK
	dpMJovCewnZNIJPOND+RgKdaBgvSqRZWDxTLYAM7dbZ8iay7eZoKuKK0q43MwrRmNUxEK2RUooV
	XW2nEJP8EVovbS5fk9ZPY+AUDalh1ws5FCC7u/W79aTLwJX26tP9rglO3O0kU1ZVcJkXDUnSspe
	BIiA4Dm59IKt2ByxAY6jX3R2CKrva/4VXarNiTKDJmFG84lYWTeVzKxl4RuqvYGuseb7G9D11On
	ticFzy/xrlTugV2aOp74jGmXQa/LWqepkkFNAUbpYPcnVNvQB1hUrCkVffBz6+7UprQFd2qAsbQ
	T4NqLGuCXg0xAkGz4XZzhSgMh1H1Y2FeuJLpdUo4LgJcuD19zfoY313lDCA005yAU6NE9w1W/JK
	UULoAniyJafFS1MFZ/qKeeg1+Yqe7xpsktP3OL0BFCBQRFNuunzGuuP/+hrzvYXV0F30IoxM02a
	Quzhjr3LIl24u4i602WDsGtV+d4YwxT1cNoBQDcQ91YjmvcbcoWRcsQ98TJR1bLTBQ==
X-Received: by 2002:a17:90b:380c:b0:3a7:250:333e with SMTP id 98e67ed59e1d1-3ae896f8315mr16195357a91.11.1793859177566;
        Wed, 04 Nov 2026 22:12:57 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323a1fdsm2107528a91.5.2026.11.04.22.12.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 22:12:57 -0800 (PST)
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
Subject: [PATCH v2 4/5] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Date: Thu,  5 Nov 2026 14:12:16 +0800
Message-ID: <20261105061217.13302-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105061217.13302-1-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9gnwwi7q48rtiuxisi8xqdoesecumak5
X-Rspamd-Queue-Id: DE8FD20008
X-Rspam-User: 
X-HE-Tag: 1793859178-101341
X-HE-Meta: U2FsdGVkX19Luje2wR6VfAf5u6PmuFb1bo2IiECrlfRp3MIjFvhspgmHnjc3tzD2ub1Bmax2Zv6fLNwC03jY63yoTyhhNmiMyLqEg7q/SFZPuJOj1yJc93jDGuOWJ07TsC6yH2MlidF3pJvLp9wJioUu8pPLvEvYqZdoKrGrZeE3a2b4GEku91IFh57c1UqDDvuCVw+SeDEs4WzzEEr5xg2P5M+9eJKYrmMbP/0DEapjk/KsVEsDXe/mSxDucrxauUSpQuZIm7gfATvwEQ6MRtGkBtCSx6VgvXdQfuLty4Ax8Dv8K1cyjbO8qQzr5ekWxJkIEzYaSGa3m4/pD0VwAzwD7fLRUCAFdfmJIbKb1ARRqsBx94AVMgI1V2LFt+4YfLXf93Bzr2gKmNuV/ELT+tC4OYjWQGHOCYG9rCVTj7/nKH5VFdwkTIe9f6orCpuXbgv9fApp2kqJDrQRh3ljgzqrhLWPkMlDNUJXyofihGDvCKz/7Mr/eWqGv8XjeLsTvnduS5K+W0OCoOmgakkTEg/hjVQJMC084wxK1WS5VJKQKcf/lrLTcXLXTCBHdbz+g/q6CNT/FCC3s3uqwm+BagWDHvW85crmtv8Jz5M/oVFva8jtYxVlH8K9XdwRwp5brfgrEVTrWu579OW5CDXjlEMGnI7aiGHIFlT4b3S5KlXcE337+lVI8IUXNtr470J9DZC/c7uWLhnc3Kdz4VsGF+xCldbQ3p0kLxTAzCf2+vRGSk5igiOyLdfK+QN0Gw+zwlG9iV4bZaW/rEZCNIXq62JvqvCtGM3jp1y9N1ImqbIYOWCJnPdUq7FzNRKAG+PvHjJtr30Jd4J8/WJ8LWf4JXAafCopGPVb0Fr++eHeP3nxDb8RevyaFgj+926A/gX+NJ21x1BBloNb1hRpIx7D0jdHwEZtErPTtNLf94lOuFd/q/RAYN55OagwC9wybQCJe99Fb5xSnPNNDhLHSGf
 0Ue3+d93
 XTj134hUlkOoyt7BqhWq1r3onBuhYz5/QYlREd/QjGkd251EsHx08IR4Zc4BChhhZNawm53fUQbQcyt1A/R3k7BKA5xjlrAhGbSquubcqUci/c+CyHxRsBbixtC9MaX5+3w+ZcT6ssO8vKgsJHuDME9HFJv535vxWturNXJwY/xcwcG0POk7js2Tfg5c7e3LjrfEl82p0awe4GXeLOVMD9Dy2wbTMHfZobtNFcWJ/SvdR8YwqtJGfZjDtdwiRqlBCIeVg9350uHDCnpLHU6Uy+9ZiDvZSGrxgH+KipWQLpp7BYrhwYKd1BcnF+luB9NyDMjNoM/i2dLSVOC3XYncQcnyQGtW/lTK5XqNgPLEIfyCOBlDTLyEFiSexf04ufe8K2jtXyy/Ro4AkCPn1txUhuoViU7Y8FSNgRJQ8IdS61igPum+3yDoFXqEFFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

section_vmemmap_optimizable() can already decide whether a section uses
vmemmap optimization based on the section compound order. The DAX-specific
vmemmap_can_optimize() helper duplicates that policy, so remove it to
simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Ignore non-optimizable nonzero section orders while retaining zero
  as the reset value (reported by Sashiko)
- Use section_vmemmap_optimization_disable() for the altmap fallback
- Move vmemmap_optimizable_order() before its first caller
---
 include/linux/mm.h                   | 37 ----------------------------
 include/linux/vmemmap-optimization.h | 25 ++++++++++---------
 mm/sparse-vmemmap.c                  |  6 +++--
 3 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a060a7150401..2fa5ce73b382 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -38,7 +38,6 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
-#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -5366,42 +5365,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
-					  struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages;
-	unsigned long nr_vmemmap_pages;
-
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!pgmap || !is_power_of_2(sizeof(struct page)))
-		return false;
-
-	nr_pages = pgmap_vmemmap_nr(pgmap);
-	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
-	/*
-	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
-	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
-	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
-}
-/*
- * If we don't have an architecture override, use the generic rule
- */
-#ifndef vmemmap_can_optimize
-#define vmemmap_can_optimize __vmemmap_can_optimize
-#endif
-
-#else
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
-{
-	return false;
-}
-#endif
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 5c09da4df4d8..9d9f7a67d195 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -31,6 +31,17 @@
 #define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -40,6 +51,9 @@ static inline unsigned int section_compound_order(const struct mem_section *sect
 static inline void section_set_compound_order(struct mem_section *section,
 					      unsigned int order)
 {
+	if (order && !vmemmap_optimizable_order(order))
+		return;
+
 	VM_WARN_ON(section_compound_order(section) && order &&
 		   section_compound_order(section) != order);
 	section->compound_page_order = order;
@@ -134,15 +148,4 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order
 
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
-
-static inline bool vmemmap_optimizable_order(unsigned int order)
-{
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
-}
 #endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b8b55e12f5ba..71a927d67a9f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -473,6 +473,9 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
+	/* Altmap-backed vmemmap pages cannot be optimized. */
+	if (altmap)
+		section_vmemmap_optimization_disable(start, end);
 	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
@@ -700,10 +703,9 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	unsigned int order;
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
 	int rc;
 
-	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
 		return ERR_PTR(-EOPNOTSUPP);
 
-- 
2.54.0


