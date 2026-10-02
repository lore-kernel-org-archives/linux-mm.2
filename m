Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57A5CA5FE3
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82EC6B008A; Fri,  2 Oct 2026 05:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59846B008C; Fri,  2 Oct 2026 05:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96F16B0092; Fri,  2 Oct 2026 05:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93AB86B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09B141206B4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:05 +0000 (UTC)
X-FDA: 85277114370.28.E05740A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 390A3140005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Aytu//7w";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932203;
	b=uoCSslDO2MnCYmotaHue31OKhAg+5dU30NGd8CsYUj6nFJaFlfyt2ISpNyE5RRlY0GSYeg
	Axc375FTmIkLKOK8wuCvECy79TZfPKOk6uHS9B0WEwND90+obofsRG/p59u/BsS9e2oDFb
	JA9jb1ipPj6mrx80b7H6E/9KK/hyKwo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Aytu//7w";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZrNUgiHK76eibcbmJczjwEumW62nZKL7vmCqyjldhkU=;
	b=GB0afYkMNcrh6/T41gyhN44CMFCpVrvRJE21QWmkmxoPQLY7VZXgWXmJsvavOk8hYYG7lK
	ou7l+cM7qRxbD9vuw4DlWPPWVxpY+YWUMGALeDmJyx/+LNAQj2PYJj1LedNL7PErILtbUS
	lhP5mSJupVBXgVdMM3Gpy75WcLRoqig=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caced6038eso7696545ad.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932202; x=1791537002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZrNUgiHK76eibcbmJczjwEumW62nZKL7vmCqyjldhkU=;
        b=Aytu//7wbB2g/zkb3FTKB81kPhvEcZe6/k6yu/XCOwp9DfAGXEbgAKNx2aWrr54CLN
         qtH6+XgSVqI0/CMbbQhhOi5mQVAUqwcTMcTwXchNDeC50jA/9wfyq3UAUlnLV7HO9ZTn
         uJCehvBehAWJJnnZK1wfEvmgSvEozN5Eiv854lQIkvnnE2pEB0X+r+407QXeHm+g2VC6
         FeU4fiFdx26bBIyKQV60E7z3dCchBudOOi32c/asD2c6SJGJ38p95770XDAdckAYV7Xg
         DQENQSkk9KaeDwTK5xvj4OR+db/KO1W8vxx72G/svCLQhdYS152aRhI/drSVpZNgKfLA
         qLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932202; x=1791537002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZrNUgiHK76eibcbmJczjwEumW62nZKL7vmCqyjldhkU=;
        b=E8SV1cnawJ17WrUQkMSLMI/kUe4fknGgdSAhhshqpXLmGChKrc/RWM+gqicQPiHyiE
         srP0auwdyWK/P8ofx2Tg7uWaD1ETIsjxN+/RIzAC7WaSA+7n8Lm3VLVqQvw4+x2iS6de
         9A/2fCReWeDm5GFS8f1Qo5InoFvIhCYGTb0gN1ABrlVePFpEonO+X+wPIEeKqZQYFznY
         SQzbVFlUwykRS/rmFsi+Dn5a3hOYqaiL6vBy29RgqzVujEMki2kcyc184+EOQ0snRJpI
         u55m+43lAsn78c9W5MIQuaRy6J8Qs9HRbjwKBy/xa2mVS6etUUhQLD7MHM4RIFUjSnys
         Z0Ag==
X-Forwarded-Encrypted: i=1; AKwUvBwp7cu1chznxv1QuA/fHmWTD4LGrlvIO/3szLmm7MIC428PkyJIIFD23q11Rpe2KwFOpVfyMoJXUQ==@kvack.org
X-Gm-Message-State: AFq9FYIMLAjaCS3efvk6N39X2JrVzFdHlC7lNl8bwzJwKbKi2PPlcUBD
	ZsIXeRuwDguWu8xm20KQiLVZwaXJVJUe32fpXQSMw5EI/oJp6z8vZgr8
X-Gm-Gg: AYBFou1DFR3kBY5o2+weMXZlnp7Mp/xiKQ9hvsStxvAnP6wre9iVoxg2S4j1xJCaG3T
	1mpxBrnlZDeV3qePtfSnf6vlIgNFoDgFIWGoqXJxOUWdccoTgBNJU+im8EXDD54w8eGNXkYenyC
	QZJ7oOSy3qBZ7FWm3iclfiZPPTrRb5Hrh4EvVHEd/wYmJzbkn+yt43jH80Y0l4nziF+IX5eaJzH
	OTHqW3Fx7aUVaO5BQja7mvDB42s/BHZEUEWSdrqO3RKgQgA50+K2MwYdaxK7RQkNshJBZxaXXtm
	dt25kxwEmPrzidviKei1mqJmTe9WO+fxjxngmOv5avyJfCRE+kQ+p2CewB2Lmw+O0mFgURx0alE
	AiTK42QTzmyPh2e1WkVqOPQJF2eHX7fTh5CENQmxcoXLavHgKezqyG0gZxg7XGXXOep5TrobG5e
	/XboQ44BXVCpcc5VMaeFgE0xzWFndUq1N7N7aJUKGmXaNEL/BRBGOOf/NiRRUgyTTSJuAk0Zu12
	3elAaJWDjepalsqU8dMYITFqwLs8HAwLQ==
X-Received: by 2002:a17:902:f686:b0:2e1:35ec:e03d with SMTP id d9443c01a7336-2e30029e1cdmr33883955ad.31.1790932201968;
        Fri, 02 Oct 2026 02:10:01 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:00 -0700 (PDT)
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
Subject: [PATCH v10 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
Date: Fri,  2 Oct 2026 17:09:38 +0800
Message-Id: <20261002090947.869220-2-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: b83nxiydfu4ar6k1b3113sjg77h7acdo
X-Rspam-User: 
X-Rspamd-Queue-Id: 390A3140005
X-HE-Tag: 1790932203-306691
X-HE-Meta: U2FsdGVkX1/uL7thyvSCYAeYatkF1lNNisq5g0SehbJds/t+P4OvSHKRcAukNWjv59AGLXFjT2W5t1QhAzcgvsi74oqgqSfOtoOji/ct67QB3zrrLvzp/lANe9l5Y8bTrNBZfRbzdmmJtBB2cTzqVkyEJglYLHDVQCeC3BhJD/fkYPmApTqRqk26ocBJO9oh3SXP704guGQ4te4Hu1l6Mx0yo9ENr5+Yhs4rVAOHYtZjKgoq2om+0pqXy8mjU+6ncm5Xl6icxMuO9VPCQ/DjT16QWksQNpIIFge9MV/IKBwX/ha+DebOmNEJUcGfZotxCEOwsEInL8hJSl1HXzuEAx7IYDMPdbfU1QUNP5ISiqF9quZ81B6uCfwY2lQZya8DNcIvhbmJuf9ENP6pv0HlnG0KvsQ2nk5LkkRN1x006fUoiNFH8ymSOr1csZ4I5TsLNOTAiCXJOKtTY7p4VnHohtVJe3383K81z6sth5EvX5uzuLja1Q6G2jvZBZb5gRyGeKSXUbf5g0lsFyVZpmf1l+RhLSlD4RF98AMRYoQXI1ot75avDPX0+wJ+GllRRg063rXYRHJr4pxDYMvgVudc4fuPEKVZb7Y/Pg5Q71/ygpxg67bu2mODKrMRif7cdMGArip+MVmXTjx1pF776Aqma5vaXx5xf977kJQxyv9mEyx8+qR9E9ygDwM4YjCf5nTgko3iDiVj08ecm0yNHVkm9bd6BLDB6C72wHznrTlml/a2gJ/AefMYOUKlYopG9D6nPFmisVlZJQ5EouuWFa/dmTE+Br8UhBAxUkZnFXeIYJQCoqTmM5zV8PcxU5/PpfQLRRMHOSvUUYxZGlCRiuY9z3fwkeFQ0CU6HKbqfCMf6xi5Dl/4wZVW9FZHAQOyM1JeFNAE0rMf55lSDAXsF2xJr6T8t7kIWJ0WtK5659qZxc19tNtcbz7NO5Z4te8Gf8VtTkUDf4ySyoZ+Ppk4yZ1
 5R+s1Dm9
 /vIAPZP2XqSdO7zSV/TILpmI5Aq6v9Fp6UpYyW1vqmHIgRSnUTDWEMNhE0omo1Np+w2cg0AfGQYiOQHg3EvHSexFFasDx1dw9SH103V+DHXiQ04j7LgzwJBl6V8EnXQmoV+Ci82+6kkaKTyinR/fxHUy1tUTIpv7yHtN1NpeXjCCS4yn17yLpDGNMToCD8xE7e3E1pO+BdHxSHw0b13c3cpD9GPzqzszZZY6mFTYfylzdojEH0WfSVLPo/YVDlGnNHI2+U5hTRU+tgxtqm618bWWEvlJI4FB2xryIFlmDZ+QwgSBHO7Kai5CSMNBBKQu/6ExHKtRZJUIXgTHdDt+FwuJTNC9I/HY0aKLDrtcVnrKxQkGXKXcHCfkEDTOseLPQ4M+OiwNSnBo65F1qamQPD+ktvkpirAYkyrjZexzoLwuyUjo1Tj4annZd8Wv8i2Mvljf5ZCZ8vP4fAvfpT3nKXHiaTHY4gyw5pOKsXLoBtQlY4G5i/MPH19nICoBknL8HGwRiZ/pHbnXp68c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels and couples mm/vmalloc.c to
HugeTLB internals it does not otherwise need.

Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
__set_ptes() and __get_and_clear_full_ptes() directly, so they do not
depend on CONFIG_HUGETLB_PAGE.

There is no caller yet: mm/vmalloc.c is converted later in this series,
once the generic fallbacks are in place.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  6 ++++++
 arch/arm64/mm/mmu.c              | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6000905a2e865..9b762eb68cff0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1978,6 +1978,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
 #endif /* CONFIG_ARM64_CONTPTE */
 
+#define __HAVE_ARCH_PTE_SET_HUGE
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size);
+#define __HAVE_ARCH_PTE_CLEAR_HUGE
+pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size);
+
 #endif /* !__ASSEMBLER__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5dc..ae2f15618c97d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1912,6 +1912,29 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size)
+{
+	unsigned long pfn = __phys_to_pfn(phys);
+	pte_t pte = pte_mkcont(pfn_pte(pfn, prot));
+	unsigned int nr = size >> PAGE_SHIFT;
+
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
+	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
+
+	/* For vmap, there is no valid -> valid transition */
+	VM_WARN_ON(pte_valid(__ptep_get(ptep)));
+
+	__set_ptes(&init_mm, addr, ptep, pte, nr);
+}
+
+pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
+{
+	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
+					 size >> PAGE_SHIFT, 0);
+}
+
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
-- 
2.34.1


