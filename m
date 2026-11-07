Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064A8606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DGFFDOYI
Received: by kanga.kvack.org (Postfix)
	id 36FA46B05B3; Sat,  7 Nov 2026 08:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E0E6B05B4; Sat,  7 Nov 2026 08:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E87B6B05B5; Sat,  7 Nov 2026 08:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6C76B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76C7380363
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:18 +0000 (UTC)
X-FDA: 85408457316.21.E04027F
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8719840009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DGFFDOYI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqN7aZ8iVALpTxJjSlPOIKNge5VZrwlYvXTmPXr+N8o=;
	b=6i4cKDEeRMtWFDdkc01D83JconhwPNBVZ+WlXJ+GXv7FO2za1zuB8dDM61LzfudpZ4pbaH
	VWOWZv0OFMKEG5xtKfThOxv5AZ2DPjAGhIX6FFgDItUNyhaIx6abo4oF9sdTkykeEnyaJ8
	DyJMqSzBBJT6ocpibBon4IuXA6itKmw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DGFFDOYI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059416;
	b=mCqROPofsEYimWWHA1/9mhIs04M5mjuS05jPawtUfxCdUyFxM8vYexWhVit1+JzfDLW6fV
	TLW8gtHOoj7QMxGAyUQyKTN/G03NG56DDsDbR70VIchq5TheL5X8vJlZj6mk2Fdw5JV03j
	4pPfVkT32270fR2HTZ2J5xnCWC02LS0=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-37071c0f42aso2118620eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059415; x=1794664215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aqN7aZ8iVALpTxJjSlPOIKNge5VZrwlYvXTmPXr+N8o=;
        b=DGFFDOYIqioIMdeFC3ItQoYhFe3dFmcyL8itQdw6N0aFvqFvhpjaotTZwvtrWxBYEU
         xgtHnXu+oA94twitx4J2qU7hOBnzLR7VJ7q6Ab+ne1tuVpUqSOxiEvZ1iCjvQk654JPJ
         DpgdZmoZpRldrFtsjvWHVmqIf1UVKBeK3qexABarV3FHtd2eOjayLWOGlOnF3gLbpeKm
         BPV5m+/thJa4MdiBfTQ5uRAUn4Ej8mCySIocEr6jP4Hy8tFglMrG4VokAhGJ1KltU/Yd
         OLQ39NtvZQ4CQuX/ALSHKpHyHhjL9zfHvt3oWvOJicXtK+nKGSR1Y2Eta+WsFRZOeUJe
         m9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059415; x=1794664215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aqN7aZ8iVALpTxJjSlPOIKNge5VZrwlYvXTmPXr+N8o=;
        b=2t8nWqGrqOlc4m3IvuvqIa6p7DuQGGekLkjHU8b0nBrSrso2S3nX0M6gWor2jBmp3n
         DXcMjvg+qGy+1/obBRwMEdILhzDyp4hO9Gr2IRoN0DNLEL9LtStcc11js8ul3DRExhzm
         3ubReesLuylqamvZM/PjxwXd42FUTLbi3J2I8hP2qEnKhR38ertXfWNju61eN6otn0X3
         b7w3sfRvyC2lxV0u5pWUFhJ9Y/TQ+iWxQqj/yCqw0lYDdbzP0DpKxFvDYS8RdemAXIpw
         PaOthyW532M4kHrVZ/H2yjj9Jrx31ewUxoOPasOLIZ4BZHfZEAw9EhDHQjquTs6nzJ3j
         yYRQ==
X-Forwarded-Encrypted: i=1; AL+hErGfCe6mrlKtIU1cm7+vd+fAG9fKBq/1QeNEb/I4fH7g61fqmNKbXYBrWRIlUEjrCWKv0+ZVvfRpEA==@kvack.org
X-Gm-Message-State: APuU4Z/v4a7GsdAIjpEHcLejqyGhhpsKlbNkHYY+I14ZZ11mB2WOQYrn
	sN4A2fxnB223RMwHsWVLXQu60/GcKFf7p+YIjtAWv0qiohh8m2bC0INN
X-Gm-Gg: AYBFou1SmByHFuxKwLLXJxCe5tcNfJmvM/yhKazXSoGEw4HzTjjRIECHvbn102wdxoq
	8t0eptHBwqPBZZ07FetL5ZaMCHtdUzBQL1QVV2fIu+MeORRY+c8rmGBol5cQBDat8vqmmnMeg1U
	5jsJtqD7GWg5qNx5jb4u6QxbLXQDPO5ppb2zfuOTowfvnmItnuDUH2FHCtn2p/dZrosw5RylVkU
	2hhXSPbY/32OLUukN+KqgnhhjtYWkavgmFK5ersA5kG7SV/6CRjXOKwKtSNop77is3RcbmMczVL
	5kuy03muskgmMes+1+QgGYHPmx79kh6ZS82L6PcRwMw2PMk/jXjLexcSQm2j520vVyDE4vuAqJI
	bNBiX+PAz23/uWNzXUs87d1CN57/hAoxNvvgznkwEYjKbx3WHuTKYHpwL2PKkkw0hRL9iKvya6N
	skN28H4gLN0XLJz1BvSgCdhSAQULEC/23nxEfNPC8YvtE0voJCcmg2Fqbl4DptQHD0QUzKc07eR
	90iSgol7faPb0q4cakEU3MUCw+McJyrUDFJ9HRFMKR4R807KCr+wU2YgzMfGlit0yop5TSLjx2a
	O9KUoPq07HC8JX5b2Y/sFjLlzAKXQoknhyDYG0oAtMZqAKjaMdS3LmRnyw==
X-Received: by 2002:a05:693c:20c8:10b0:36a:30b:5dc0 with SMTP id 5a478bee46e88-36f75838341mr7149731eec.24.1794059415250;
        Sat, 07 Nov 2026 05:50:15 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:14 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 02/10] powerpc/8xx: add vmap_pte_set_huge()
Date: Sat,  7 Nov 2026 21:49:45 +0800
Message-Id: <20261107134953.748622-3-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8719840009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8pmse6sttrcrzfcreks7mm3krd7mbdo8
X-HE-Tag: 1794059416-202503
X-HE-Meta: U2FsdGVkX18UzgHSbSFSw9j5ttF6vWbppzRa1+epi0qg6QW5ZSFifcOR76MY0CnhoKhdgGz9DtB4/AFSoYhppvz9OiyzghWGRl0Y1/F4U2JNSbPe7dhTALAH53FGeux97ss1+HfAaGERB104hatPA+MBSrEeQGNkAX/GBq9Uy1/Gv/Mk0wdrIhlERFnBKSBt4DIVJ/GT6/8jF+eT2sOmw2VeVWpRsRoxvEpTXXjvb8U0sTCew0P+vwTVxDTQqU3BfH7iNy3P7BzWZ7zbZ23UE+NGid2HjUL1Yfm6qnMjumqidg6Y80OiRRHJI14hELurNGaTOrbp7HDD5YVrKiqdUgOIdyLLIlIYE4X5h7m3uymAwLq+72dRiuC3u4sT4IRTO88HNfiLAnk9nvkA9ENSjxBFB0ZSTK5gg/HiHRQP7voNUkpBwO3+JV6L4US28NSOgAJXp+uiXAQ7lxc16ROHjqWGBALA9XAj2Jd8jyIMbzhtYCnJc3AFmH265gIXEM0Wm/4J2SGpChr30HTxlu4Yz7ARDNXxMO8N54aCfO/Ul+8+UBfYCwnY+3Ek99K1OpD++o+/D5nvUWSfi7qAozUbfXKyb06on+ZmDouzPwZa9GC/zabYwrRkJglQfRk6ExtgBmmumT/k50UGDcKVUR4DbzLKpm2JaigPlNS9eZj7gTsP2h5mCAFlfLkut/QkKGvKGCG1bhg5POhq39PZOh2EbesaZyq4GS/wPUWTUkxfoVEt8CgE3PhUZcyS6kn0oUTqANmbEXQl7gCesGccDLhnUSPSUqBLOKVo/JZ1ZMZPNVf9Km/KLEiGpXrnlqCPApZ1rGt41AJl1P8IjVRXIpgXTtB66W7dDi1gbzscDJn5FNxvpskAGYdqRPmPcUrSOTHl3N/UNtumCQCEmN1Fbkg2wVGgET9BzrfjoJ71VxuF8jpJA4weCwxt4OdHbmZ3NGnBb9+i1KlOvgBsLc2NQbb
 j1BQcWP9
 Ie1XEV++4dYzhv2bxy3I5uV91/UGQmZYpJZei3+XfZpca0Mb/IDeh20Bt1CJUsa7QAKgsIobKbOXR4yoDXqouEiNVnHt5ASVNa7RsYUVHO6/iaUQsx7pLP/q9XeDajx1i4yXq7JKUTI6jGNcQRcomI3fv2r1JTfE9wfBfc2sCt7s9WGV2UgrenrqGzPlmFNkS/pCHh/afoH8SUMS3GrBi5hycIE5add1J4Pr3h0+igsQGv1HbXAjb/AazpyeHWJCqrKL5iNaxoRwKFLJSc+9NT3eYqk7BFEGgO8GP/pffOWy9AvnRMvA6EFTLQIgp27p+0/mOxeiO1f7te041vWY/GvQTlHZg6rOFP6gENv/YXMJmze0/KqY8tUV/yhZ777ZJL57gskzXVpiYmNyaMBwK6ffi+duki24V0XI6fJmv1UWTcZTYFPpzMkiaYdEOL7yWhWwDZP8lu4yFWtEP3bqff1/MFCaFY//mPPzJk+/HRToAJxSNcbufA+K/Q2Zy5DlZm+EHGYLsyzYbfNBGOIcAMDaLzLfnHLe1UfO7Kjlqzk1+yUB+RxJlG+IoBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
by reusing set_huge_pte_at(), a HugeTLB helper gated by
CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to HugeTLB
internals it does not otherwise need.

Add vmap_pte_set_huge() to powerpc/8xx, next to the existing
pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
PTE and writes it into the backing cells directly, without going through
set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.

No vmap_pte_clear_huge() is needed: 8xx does not implement
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
index e2ea8ba9f8cae..141336d30cc76 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -235,6 +235,10 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 #endif /* CONFIG_PPC_16K_PAGES */
 
+#define __HAVE_ARCH_VMAP_PTE_SET_HUGE
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size);
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index a9d3f4729eada..b12e2829c08ed 100644
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
+void vmap_pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		       pgprot_t prot, unsigned long size)
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


