Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A104ACA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5896B008C; Fri,  2 Oct 2026 05:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C746B0092; Fri,  2 Oct 2026 05:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4442F6B0093; Fri,  2 Oct 2026 05:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 124396B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BA291A066A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:11 +0000 (UTC)
X-FDA: 85277114622.26.81E956E
Received: from mail-pj2-f25.google.com (mail-pj2-f25.google.com [74.125.227.153])
	by imf17.hostedemail.com (Postfix) with ESMTP id B167E40007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UrTwiQpk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.153 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qd05crYEDf1zOBsfrx9KiTFMAUGQioHKS/Nf5VbEp9U=;
	b=tmg09+rKIx7SQYfXKlk5xxnREEN7YaL++GE199ALwsz1M4p1ewu99CYbcDmEDJHWtEIJ9t
	Y94655NStJOX9FlvCiITnE7xzgKdPjU0sBamwIHdXpPNC9wA3Q2IyAHEKtT48+/frY1s6k
	wqgEi2rYuShoqzWu4hGJOgSOB3SRAqk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UrTwiQpk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.153 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932209;
	b=U/eFXdDGddvW/czUz67AeWBEu9bPbHqT84hiSZGI6QF0+Gx/5ZHSnt/ZiaChNV7sMkqo5D
	wMwIp5KgrwiIMaNGzS6xYFfjoNWWpHnLVBz7IXy8nzRWClrgdUBBzsG/sJvkzYcOXeB/6d
	A+rR6wO4iLGnsFeayC0NkdNIIom6HVM=
Received: by mail-pj2-f25.google.com with SMTP id d9443c01a7336-2e2e688de2eso25184225ad.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932208; x=1791537008; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qd05crYEDf1zOBsfrx9KiTFMAUGQioHKS/Nf5VbEp9U=;
        b=UrTwiQpkpGDuIHbqbEgUzdwxLQ+9otZEK71dotQEXh+QCTzVVW6B8wjyOhcG9xvrGn
         HaGA+iL75ENqk4FVT9z4u58PO+DjeVCGBQK0GnyMRvYnYXpHvpoSPyEbnjp9tSKMizlK
         ed4LHBtdk+KuzrPnUhNt3mxNJT8JMRhY8/fTDbOGiTJ9wQpiPOw2QQMCk3albGMcCZiG
         uXLQar4mSynVgQxwq6fWnP6Mja2F4VtppaMy0usIbQhDVq2Hh68cKlU5nacbSbxWQjUn
         YpY0T7uzwIGrIQcDosNcPui/iQA56vAuQsbgEC3WBXo+RZYXLBSIKOVYKZ0UTqgEsetF
         TYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932208; x=1791537008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qd05crYEDf1zOBsfrx9KiTFMAUGQioHKS/Nf5VbEp9U=;
        b=sFfdYMtpa8C3mxA3bUkK7Tle7EcTMUbVbP5QKvLDm8SG9kpPzayGr5QEH1qXaKMxEQ
         iNbz3AwlIqR+N+Q29H+xoAtRJdhmLGmhs7cvhY1ViAm0Tt8zp2nUic/EOG+jsrCvLVyp
         vDq/62XxcckX8ADhHlOedGr670b5vfNAPPonaE5yO4oTLPVzj8rjfvETw3zB73u6z822
         o6j/Q/hOSmoErFcHLErs9xAvzQqfIglBw1pvVhbjjjjBIXVRLUjMvBioGQ1Px5IWzDZE
         6RtYz7rp53QUIlIlk5ti54SrXrhVCysqQ0HyPa7dN6v7vT+9aGkBAThoYYn1/gzfh7hx
         t0uA==
X-Forwarded-Encrypted: i=1; AKwUvBzO17RRgj8cpOT6xiP5tEh3oK0C/Zo1oZQvbTFCukQLcIZUecB+2RcRhrMcqFuf/PMdeDnKTKQEPg==@kvack.org
X-Gm-Message-State: AFq9FYJlG/nJQwgOpnqNHeYpDAVZgZQV0oGxtn7qKzW61rNcwtD0hupM
	1I9bgZSPtQBEOpwT9WrIs+U8v7q+jbIc4nnvUtEA8M9jLFVxrluyIAEC
X-Gm-Gg: AYBFou0eHbTqAmCHguxEjrzNmf50SI70wOZXGFL2q9jeS0YFZBHXBkahXugyZze+EP5
	bJiGmOQjWAFaGSt6RayZNs3pCeVhXKGflLgup6idOTWVJjZ2LY1DVoVZ8DG0B0unA6lrDq6Mz8i
	yOFO1XwBV9T9LrAQdneqTWkR9n3gg+U7yYaukaz//jvAw997aURl3IzLCBRsS+jlA7C+tDWtYAv
	cS83VVT7fjWQj7BrI6fonOuBg4mBoV0aH3oZw6vhWwqFkHQbNHMAgxPj3Xg9rPtWkvszBsoLrMu
	vZI9rQ7kxWOGiZdtvWfso4w9lbDba2U7PBPIv585iX3LRh0ojfyuRDZJs1R1Yju+o9n9T3+8dg8
	uW8/bSmgX+FQgGqNh9ivDUnacEmxsO/K2g9DxFQR7vkP/YfzPoZcUIfAsvkPuPxdD92lejbNLAI
	i7V1lSjcOdEyDFIPIBAOABZ3CLkbe5Xce8Q81kmgqAe2/AlIllF9px9lO8+ZrwrdHprb+99bagB
	vvAjvPNqE5fcrq0onqZJQ==
X-Received: by 2002:a17:902:dac2:b0:2dd:68a4:170c with SMTP id d9443c01a7336-2e49b612e9emr18357635ad.11.1790932208496;
        Fri, 02 Oct 2026 02:10:08 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:06 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v10 02/10] powerpc/8xx: add pte_set_huge()
Date: Fri,  2 Oct 2026 17:09:39 +0800
Message-Id: <20261002090947.869220-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sp8fnxhqojnwq4qnzuzgg9siabz7tx3r
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B167E40007
X-HE-Tag: 1790932209-575249
X-HE-Meta: U2FsdGVkX1+MydChPBHO9/4LLUg6PZ5Olnq4snAGnzLZeoCM+F2BiwCflYkBEK1gTsQKKx9bHPnoOFEBO/Eh+QxT2N3FTFwWeiLNFH8GOCVCJ/XJflHesZRn59OuB2LfU32RFh3kxvvMXsCPF4UODMBw3BXlJGqUTkRKTSTMwBc6fsJmRdxplaxBknqV2MZLzt8uQ7r09VUBv8PAOeZRu3j2asb9TRmHqIPlyMLu8Oofd9lRPu9l6olpnUs3AXR1YKG+NxsbfXQQZt0nh3lD1Xq121/R+JzQGiK2wEiiq/NuviFBoUMnfUFIzFmRSDkPfXXG2QCGLqRTzG0AqERIby24Bp0yP+ftsr18Mkd3Vz+Xrv17qOCBLF7pOU6vR645dpEBe8Z3VAL6tTuCwxNeKmbMvgU3mGfqLCov82+8djdiqo7gmeJbawepqLdoN8xOUrIE5Eyaz2iyahCPQySN7E9hcevo5uEeQ8npOdH0+Rx/AAnFpIq3DTbQWtMPexgTvBUp9DxanUVlruysHdpiYCFcPN7r76orSgd08dKwyeEK73TxZRobGm8EXogMcn70SAFZzs3v+x4uQMKEbGmqHlt0A3nbmNq8EWSJo9sZAGPkiPDrSy8xD8ljNFmQnN1TFwNwAZtc1FmYJVBcFCyEz/no7OFWV5UbyLiq30sdw55h+UOhnA2w7RYviWgT76q9e0TocIyycEDEOC2bNgCL00yU6q/ey6cmhKN9YiJQfp8s8pcusCXhdcriikL5tB1dVXfgU6PXBmG1oD4iCGPobRQeTx/TISxPStHR6YE+//g4KTC5244gwPqBnZT8m6zUoukg2jly9bQOwrPk2z02zIME7RS4bnk5hQu6OVt5Ogl16u9aA13Hzy8KGcMAAebAkUEmdwXs2PJfU92pwRvA7ivYhoDosCEyHCkLzSii7fqjNAdbWihOGs30kaJKr5Sp+Yl6AIF6/g2RLXizhm7
 jRRoxJ8Z
 VvALHKqMgezZHmqZJf1EUYNadfHhDVdXD75pvd1iPiQAz1BU/cRTxKRMOO5ecUCGSA8mnHiYt6sklk/czz+9jMq0aFzpSNiJeyCu0rlHgJn9aEJIa+6PjL5LbsarstY3v8Rdkf4twrclsZfCon5BWfEkIVeWwZFMJdHo7hmBfAaO3zx32xJ+CuuhSimFNFNBO7GWdT0aVlqUfiiMoKrGbpiy0WIXLR8XudoqsOy2MrD73zTMDo/xWv76YWjfeoO8zo4AmYfLk5zEQptGuj6EaDGr7HowbChOuBNUXbYGehjALdJ0LQWeqeip9tsplNCKHA96ImPQeZF6F/n9SQc0GjgbvraB8YRKZLacoJFOR1K01IJhA/n4Vm+LKRTDCoyy19rhkxiAt2qs9Mk0/35usMROGDISZEGqM/pjSt3qwslc7fguWBBpt25j8bzVdv95/EsUBhZ53ETVLek7UjnMnaZ+n0orgyHJ8B73KAQ5MQc5OKt/5X4khxchJmKSfyQTofsoKB4HHFb2oxhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
by reusing set_huge_pte_at(), a HugeTLB helper gated by
CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to HugeTLB
internals it does not otherwise need.

Add pte_set_huge() to powerpc/8xx, next to the existing
pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
PTE and writes it into the backing cells directly, without going through
set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.

No pte_clear_huge() is needed: 8xx does not implement
arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes the
PTE-clearing branch.

In practice PPC_8xx selects HUGETLBFS unconditionally, so
CONFIG_HUGETLB_PAGE=n does not occur there today; this is a decoupling
cleanup rather than a new configuration.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |  4 +++
 arch/powerpc/mm/nohash/8xx.c                 | 29 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index e2ea8ba9f8cae..1ee3f8f0de974 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -235,6 +235,10 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 #endif /* CONFIG_PPC_16K_PAGES */
 
+#define __HAVE_ARCH_PTE_SET_HUGE
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size);
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index a9d3f4729eada..2518d2a6bdb41 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -220,3 +220,32 @@ int pmd_clear_huge(pmd_t *pmd)
 {
 	 return 0;
 }
+
+/*
+ * vmap PTE-level block mapping. Sets a present kernel mapping directly,
+ * so unlike set_huge_pte_at() it needs neither CONFIG_HUGETLB_PAGE nor
+ * set_pte_filter() (a no-op for non-exec kernel mappings).
+ */
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size)
+{
+	pmd_t *pmdp = pmd_off(&init_mm, addr);
+	pte_t pte = pfn_pte(PHYS_PFN(phys), prot);
+	pte_basic_t val;
+	pte_basic_t *entry = (pte_basic_t *)ptep;
+	int num, i;
+
+	pte = arch_make_huge_pte(pte, ilog2(size), 0);
+	val = pte_val(pte);
+
+	/*
+	 * Make sure hardware valid bit is not set. We don't do
+	 * tlb flush for this update.
+	 */
+	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
+
+	num = number_of_cells_per_pte(pmdp, val, 1);
+
+	for (i = 0; i < num; i++, entry++, val += SZ_4K)
+		*entry = val;
+}
-- 
2.34.1


