Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928C2C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB776B0095; Wed, 23 Sep 2026 02:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934FD6B0096; Wed, 23 Sep 2026 02:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8240E6B0098; Wed, 23 Sep 2026 02:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55A6A6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:28:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86FCD806E6
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:54 +0000 (UTC)
X-FDA: 85244048988.16.6C833F0
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id B48201A0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:28:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EVUZfL36;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qd05crYEDf1zOBsfrx9KiTFMAUGQioHKS/Nf5VbEp9U=;
	b=1vqh+4Wfe34dZ9z0+svELbR+L77c2WdoLJBkigJk4C3nSqGyR3si9lB1TAe6YME1snfuWl
	5sYmzMLNngrxSsYYfkAzYVlEUC1gyJoRWH3kWFV6xjf5GDOl7dzys8h4E40WMOQt/AGrdy
	qeHMYj+xg2QwKdyGDgCkJ51YkIOq1Ro=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EVUZfL36;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144932;
	b=4qmQVlmdXsN8WtdFLRKQbChjfbDwg7jezTi0hSLLM2xY9MjqGyhdpMpyIXwHibTVirrhK9
	UnGZbUpwZYPY3PMIObrj8PSPTc1rEOoJ1eIkRcpQLc4tSWy8kEKrB8HPY1oKwtW1PoFAWs
	dFuP6108VT04KIi0/88w3j8cRfwNvp0=
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2df4c9d14b8so1832445ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144931; x=1790749731; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qd05crYEDf1zOBsfrx9KiTFMAUGQioHKS/Nf5VbEp9U=;
        b=EVUZfL36pjlDZ7sUTbQCgMTXuuiQtkGayIuZsXGKmAlOm3I7bB+hNW+Bx/ASNZCgbw
         f2aKfBfcFDRssLC9mxB9if4ZzRsT1dB232xWZPfNojGRPLa23aUiGwy0lUtMJYwazX84
         re9Ckj/gNK/THirkkna/ooK3EQb1keMbzHwjzE23xpqpJeqEQpOLKBqsPxACOVPQo060
         mzjBY5SKI3kPOfXYE3VdS6z0XqLpukIpbf1pjXItHLXj43wtoH/1Ez3LGegFZoxLtIRb
         wzn5+uhPPj01Vp85LUdcbUji4aIl1xNK7CDsjFfnHUAinmz3X6FcJWpSkDD+iO5C/0Kc
         EWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144931; x=1790749731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qd05crYEDf1zOBsfrx9KiTFMAUGQioHKS/Nf5VbEp9U=;
        b=nLJ25iuGKEH6UJYuaDyCwYiOql2GaNrwSuLpgikDhzi1pc6C5hVmN+5A7eFEl8rdUN
         PyU8QUT2UmfUpToNppKeFnc+6/QIqOS2G/+njuYeO1AYnsKmaIzixEN9/AydoKtnruLG
         4MIcf2oIYbfCUbIAbHsGVhn2TMDEV3SXDVQozOaarvHxBH1MI0tEOr6IFR9SPo4aDyeh
         qbz8hzExWWM8iDOuCJGsHHYkLLx0WdtI6VaprjUMquUOxn33RVbFgxIeU/K5xhLsZrUV
         vKRNaOfSLYTOMFvH+eZRSFnRB1qCbBoR/gD5qZXkcFpO+pG6hgyvZgsqvLSNj3bfhGrv
         ffIQ==
X-Forwarded-Encrypted: i=1; AKwUvBw68AwPY3LpFPQpO3oV3CIWLvscCuDu03/FOKUFb4r3I1onGegRzqERtbKJ2fFfryH7YCJtvW23MA==@kvack.org
X-Gm-Message-State: AFuF++lU49w44gBwtbe3GdvNb2X5R4tPtSOaobs5rO65SwhRT9E68Ug/
	NmtJ74B9NTvKoVTw4Y2MQcIpcfNe2ol8SO/1uf0zdS2pDKQBH/4BttXy
X-Gm-Gg: AYBFou1ejMBhM0wmR0r1iMNG1gxfu2TM7QvZGrYyuzNHXNw1QzyEPcXq6xrtoGyuj3n
	vkZ7u2Mqo94hwGLq1F47zWPon6ShLzeG4HU56Jxy1npOP3lsqF/JF8CdqsytDfpBaP3KIg72/EC
	bxl3pyBrGUFtCNXqyzeNtH3ZF3yCk+SnN030FDcsSvvp+6YvDfjUWatKBk/7ZgBSJP3BeMV+W2r
	jm/AWi6gJ9yr8GJQEjkIW5ffjPW2jV20UvOlKs8/QNG4E/aK0P3EX7SezcOAuiy8z6edrQSbfIH
	Fb4S9gnL+Q1vnlneNyqVBsCEbj1gvjUeMMGbC7UBBVUP+kKteg1DbTebHUL3GsyPC+I6egzu1EM
	Il7VwzwE1aj5z5oU8bsNxMxHAJIocjlEUYktqczDVQ2rYC+QEEjcX3lRvjBpEnxsAHmeU1pxAM9
	zY/y03gCu7b/WRjWzmMHLP2colRwhlRbm/BQfawatCL6jJq0JBRLxgAX9vvBvFaAM+NK76WtQdx
	cYzIqIoGFfvASXoeyuWzw==
X-Received: by 2002:a17:902:d4cf:b0:2cf:b9f9:18bb with SMTP id d9443c01a7336-2df6987811fmr11433845ad.4.1790144931608;
        Tue, 22 Sep 2026 23:28:51 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:28:51 -0700 (PDT)
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
Subject: [PATCH v9 02/10] powerpc/8xx: add pte_set_huge()
Date: Wed, 23 Sep 2026 14:28:24 +0800
Message-Id: <20260923062832.479455-3-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yt63u1wx5byki7zek8n75exnss3zf9fg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B48201A0003
X-HE-Tag: 1790144932-84120
X-HE-Meta: U2FsdGVkX1/5X0S3IltH95L6hEDgiwkMsCD67SVIWm2dDkbr6PpT2tSAzUcLNaUNK3MwmGniMO/yGmo77vh28guMKE3IVFTEYD1Mkodc0YeqlanURLzYa+TmfUymEKvP+p4/NW2eC1BoItz50iD0+OL1OnIvXMJVKKQ8O6Om6TVlpxp2BtzlZalUhWKZVIbnG580rx4LZAA8VHifp5AeHhJ/syKKpGosOvB75OVHM/TQVGqxKUGfO7z/9HYEe+gzx3WyHE8IGJlej5bciKDKLO6dIWXMSJmKUVQ5qnhAAp0QvJhNMFUBMdpQEgnynZ7WpUdsbCUG5rJQHREEkcvy+LTmExTw6+ImGWDN4bD8uvvXk2OHneCuV2UEqTi2Y9P5T2Xv3SNFovRk8z0KkeWFOAMyhLeuqbwjjgIdbRGSbgAwA3oBS+4sjDwcaIWyiI930w3ZTsxccQKcaq2flnTlOaYFEMQnuXbdBQGfYuGJM621HA//AX0NswD02HsOe+cCrMMVm4qWKOCovqZ5H9Ai0m8mhZiPB+euvqMniHtDmkfkNixt1nX6g6053Kt+LJyZV0KwIq0a83y6l1FA0z5/y4YGZshfa9zB48jswyh64vnOa09rxOwY6huAVfSRNdvWRbFKHbJCSPCM6VbY4iYURTMpqGcFw64bUqo27i/bvP6QO/cx8ObNb85eE8C1VNbMfHz/vDUVeN0jo6HyBqtxpL+YIdEJXC03zIPMdUNatJTxE5NP1Zp9619GJOeuonrYZCP7MRLGlIb9m4iKRNUb4KDAvgqz0yXhf3V48QBBwJa3YzVidjVTcCJC7whsHnSq4LFGEcs66fU37UYdc3CAzw2zlDUVwEGl5DJAUWuMA4oFpiFaHB5557OFGJW9QJ0rISi8zXwsTiGpdwa9xfrQg4jVfxEtmAltwFeabw+NO8Hc5xiFKkowjwW6zyqBCFT4P0lKBXthYBOOLtQ7UNA
 NBpynFm6
 +DMJvHi6wJSl4tmFBx42ESvQE/vtKxlrIKnwbtCREBYDttOUIQgbqnJWj19EWd8kLKOyP/4qJUmAXoanFidgpBEh58Gg4dfBnL5Esx+eIfN29ASImz2e0l+SKyqsQHbquZWyve7R9RQY/iH21+jttSqQK5vAWKB4lI9K/p6Mt2v7Wu+SGrD30eZsqFmCgfPT3J4g2iNBuaZb08Ozwh1jc+VjVc5PEiAj1WwMuL8/Ks6dwdZzfz1/y/CoOFUPsxTXkNkR0iUSLa8vsCwt5ryE9kUD2H8g5S5qL3R0lsW8JW1jOZq+JWyPfyWAXCF2ZPtnJJN1NPm2Hr0dyrsGbUrqNjhw2OAfwpVKC37akCtmZHTM8sm7PRS5dosT+mA2FS8jWtLVjhj4xynorA9oiapQnNH/0rGXoh3A1n+6ewvjy1ZY8VRG87EVvQH9XKzUhoQfgne2OntB0QuN5uBHAk3Eitw24hV9suTy0P+6taxKO4K0rsCpR600VjO29et8QibJYNLaWHdHEvk4snW8=
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


