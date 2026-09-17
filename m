Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97E5C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A196B0099; Thu, 17 Sep 2026 01:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2886B009B; Thu, 17 Sep 2026 01:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7FA6B009D; Thu, 17 Sep 2026 01:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC63A6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A1D7A4946
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:01 +0000 (UTC)
X-FDA: 85222127802.04.A166286
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 549EC180002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:29:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bs6g3WIW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789622999;
	b=gSTym3H6sGzLrrox0FlMuClOTouMaGai9O8K+zQ4wEC3SIoU+xX9DEIGGHwap67f3uTmEq
	u5kktVg0michqdi3wgJYjDdaR72tSYYo7wFzhMcGYcttArium5E0TQJvPpnypEG4rhCt3t
	Jc7yz9U5Nt0Dpb3ho9A8Gnl8KI8QMHk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bs6g3WIW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789622999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qf2/Psgvj1EaockCLCoqTAU5YfPvsk9Hzwk+BcXGZSE=;
	b=xxJu/Escy1cAisI7ldMm8/NjRaZQjGerxPZyzhJ9A/mKlaRfQazR/Cr+0vP4H5tpEoMiEu
	/2NHuP4zE3GA3dJ1QmhPCYkxjQYZNWQPpmbuEt7Q0aK+GCerrxy+/taGQ7G+8N5w8E/Jui
	3mPq4v6unZbc0ttBKX5SiuAkdxRexsQ=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so291257a91.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789622998; x=1790227798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qf2/Psgvj1EaockCLCoqTAU5YfPvsk9Hzwk+BcXGZSE=;
        b=bs6g3WIWNMJy/eUeqUhYHw760B443dDYc6h1XMLFiYxY/6u6zNjcNdZUzh7aor7zuG
         fe0jpCA1a1qwWoRyN60php3hPzoNQHsWygVHG6wUZ8XHb2xcbijZs9QhxfC/8afgk9+C
         Dt1hutK7PLf3bPlETlWH5vo8NyMGeUq25jF7wXu/dElOqk2ZmLsmzmix23jh/KPBtlkn
         0UVEBnjhXQtb6fbflubUMN08MojJfiU7QEGzdvFj55LD/V8NdiUqPYjbftOKzFleMTob
         fKsEDBqZw6Trnej6cPH4c5JaDbd28CQfDtaMSG9bdPYJxnltww0icL1hifICEEP+Vqkb
         34+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789622998; x=1790227798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qf2/Psgvj1EaockCLCoqTAU5YfPvsk9Hzwk+BcXGZSE=;
        b=kyM/so/WrSbQJCmFgGIrkxDDKAfgM4TuAY4B+8x+s3vOPNwB44c113RuHX7JpWvIoN
         4CWtHFbAncEiedLti+bgsfjHbRAop5ruA+QbM6TcXxoon6cbQ4139Nc54BLrxFRMG1Pi
         yLYv85gIAaewuqS1ZP/wKpKJ9W1MsH7iruZbtaejjB8ld94XNlMf/d5Osh139VgHoVNP
         cDFnSdHHybrhfOoHe9sv2WxozjvhLlVZcELNjTABrou/w+6nCOmnncNXqRTyovM6LMAh
         +tMn6hAOcJ6eNwRgOvTi7dv4t9uBVMr/KQFbxpreDTRg2gykmE/oCACUY66q9PeZGYS5
         jiiA==
X-Forwarded-Encrypted: i=1; AKwUvBzXRQnjZ20knZQKd6iQ2TIq3KUxESg0vBPrUqGU0I85UFcGIWObEJzLMZawGFpcK64ePctMXoBr3Q==@kvack.org
X-Gm-Message-State: AFuF++m/vUNaB+nQrK3dQuZgqdDugfsH44XhTf+WynPyzrCAvvDw+DsK
	ucr80kfN0aD18b9sK7sTJrl+ihjq+rXyoqY7PUEB76QdBF69Vc7yB97b
X-Gm-Gg: AYBFou1nBPoI4QQe2uMn+tvQDKUbkDLLmsd2msL+aLgoTK/se0WN4wDM9Wirmrj+4oU
	cBlwNRitqWloDVpRAeM1su5HowVY2NFdS7XKbvaPHnomsaQqQdT0g6ORuAfmKglGNCHviMLnDQp
	KSyeUmvZUGxIvSL0TP/9RfnM8004mYTubTfKqqwoyixukp2fkl4KSaDB5j8p05RlCZmZwtEtX3W
	vIhushYpY5OuQSFB3BoDCJGea+VKHs0GcwjRFqCSp8Sp7Zi5D46M2o1ok7Hiy2xqtvC3FaIg+Rn
	ybzCXkGB3i2dm3hG7NScHRzRD0dNZlJcQjZRQKGyojepQUe4pxJSZlLP9dbTFbtqdz/DMG4mM6w
	1W8fa36Ez2xzsoKN5vuSTSaXPJoePAM8sWQcjfmIkR5qrrTZWw9pW8mGz8mCAYdIpg99qpMJ5kw
	/oy+P8a3rESiTVw1IvAtvbAT7StuJeBVWvhkHI0J9zS6srFbQzOj+9flH2QLeciDGL5WTXgnH1r
	C/tMlt2SSppYMkFtRkKq0FB9Ns=
X-Received: by 2002:a17:90b:53c3:b0:398:c0ad:711c with SMTP id 98e67ed59e1d1-39e1e48a517mr11683515a91.15.1789622998238;
        Wed, 16 Sep 2026 22:29:58 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:29:57 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
Subject: [PATCH v8 02/10] powerpc/8xx: add pte_set_huge()
Date: Thu, 17 Sep 2026 13:29:25 +0800
Message-Id: <20260917052933.188679-3-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 549EC180002
X-Stat-Signature: m6hyiqgzb9tbjz9ihkd48ndhdp4pgj6x
X-HE-Tag: 1789622999-883341
X-HE-Meta: U2FsdGVkX19u57HotL2wtr3oaWG3EIFtLcks/juDjX+5TH64MSbIV+H8ogtns4YrNKWE3mEPsT+vmbdQ5FevTS+Cf43IoVyC+tRoNpPvvHKj62AjDfpKJ0Tpm4EhOEOd2B7C0CFtnfN7GYdJM8vFoQe90b2HBsVeDY9tXSB0U/fYkYiIFu5L0K068UhlAV7hedj1YjfK97aA7WwV0HzbYsfOipGoHI2qfcI0pre9GFoHs2uwrEnQCGvMOD1QOv1iXimaSG56Fas84t0Kb308Zl3tCTgs2fdH6YKX/MWK6GNhIV4iyYWW6C2W/LVITvYeZDmKEP4UOIif3asQFIT35ZwPbgkJIcKPVRwt40uQTdSRpOJmiDTkPDU+0x2ioiBEnT2Uw1to761PfiFvKoEaeUR2w7Sr6b2+cnH95QAUuknqCwnIRMv6mhrZv6LHtnAgcWUorg721kW+lhiI9d9okBq8sNPIsn3Lz+0Zt+XRCj5yiiFxsdBhe84DPdoYuYsZV15wjo17xdDrjWTF/3Se5JV0lq0qSjJyb4/2yroXLi1Qcd/UC7nnHcMhRitP3YEVCcXIf9pnMVe4y4pmBxZRIEC1D8eB6xK+eGQMCmPAopTomFyZiVctG1kV4SQVhn5pFNgAETysuUcWovWiPxT11Ro3Xxs8ACZEPwbWorPW3OMbk4+cVKdklQEsQQ1zm+iJcLVa67P+9nO3YiKPAh4WudYquK0q55u1RisaCrcWk8qda8p4AS3hCzFMuroUlSNEvm9yXZdcab7C1J9NKk0QGCuu4FQBG58VVFA6iEjWpSf4vMPgwfSFK8+R6DfRfXNwtvUuTbEjlN8qGvWuiBnPC5F1jXNGBJ/xsYkFFlYjPLlSL7kmdY0yx+EqIaiIqLRmZWXJS2V5r3RHGqymVcHLu6gaxevovKGEcDlr7a30L3ALNemczkDUsVMqLf57lM5S/rs6+0oAz++9EGMOdx5
 EW1YoYIu
 epb4XWsOao7mSlG6w0qyb75htDzy4kHqmjk5h5xwan6pwdgDuDlQH1tNW1pjRifcLEk8FE15bH2Rl/b1NP9wasamKmN1TI6e4UBz6GIieRm8TfapeROsKuDw/5l0Tp7VvGOuXS/B/08uaItgm04+WRrN0gOFv6sILvuKR0z1ifRABpoq4ct+lJbnzqo/Pe8rq2X6811ygUMQyGdx6nnU7by9dr+mHPxz+U/Ok4ijVU7BPn6Q29JLHdS2/RY4b2LCFAKj+MrwRGZsQnhBgc559NtQ2OTk2UvtbK6EvqOSZ4PDeHzZU6wCy95q8KMnhLky/DBFXeOl10ykHDefpklyQIjUfwRct1UlTsREOgrQXdoFNspXPkm5MVQSLm/i/R1GgAMfQzrxJbtX3rG2kimXoJd+EBivbaJBK4ZjM6yQt0u4QaGJLiCbh2rV9frIL5tkl1aY9ZW1pfEht61w7MboQjKYxCyg5PABpR4CZURI/6FbNZHlKPnfhtwsqOXKj6g9lCnxQX14xAVb0U4WFG10jvclbSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

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
block-mapping branch.

In practice PPC_8xx selects HUGETLBFS unconditionally, so
CONFIG_HUGETLB_PAGE=n does not occur there today; this is a decoupling
cleanup rather than a new configuration.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
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


