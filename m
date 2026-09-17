Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B311C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE7C6B008C; Thu, 17 Sep 2026 01:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5B16B0096; Thu, 17 Sep 2026 01:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95D96B0098; Thu, 17 Sep 2026 01:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE45A6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:29:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E150C0220
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:29:55 +0000 (UTC)
X-FDA: 85222127550.04.4F431AD
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64FADC0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:29:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HtAuWVE7;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789622993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMxiXZ3VjT6yairvAxeBbjdHvNVDdfswnxYz1hMIZxE=;
	b=uu929oBvjNWnUkYWefFhrerYXNtiVRf3x1ng9FxcGeBud4c0UlhAM00ZdCaBuShyILNMki
	nUtBR3olf7VHBb1jtTSVnTwewPdyLogv8W6Svd6TU2oiRG2Oc6JROAfda9A04ev82lDRgs
	Ju9kVhnoSCaUOo6KFJPJALiQczx1mDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789622993;
	b=OR3Ze5Xkakd88V/KgGV0oaih3oc/4oIyq7FWg2Fc+7ZPbXNFVQKPpucQqrDaodByrQzo35
	/i16kbLYOQrweoXbO0OLdRWdihWdVwpnnZlPP4SuYwEW2tZJOEEBe64LwM4V3B/eC1iSbK
	J22kiFbzqBGUMA4/AB/kf515flGmyus=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HtAuWVE7;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39d654f02baso348789a91.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789622992; x=1790227792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aMxiXZ3VjT6yairvAxeBbjdHvNVDdfswnxYz1hMIZxE=;
        b=HtAuWVE7vqC2f9ggfdDD9bM+EsOYJLO5ES4KPon+yxP9dX4F7bt5N1TWbsNtgJxrXM
         xZAgfjfnasT8c21xV7RcaxOeA3SWf6jDUZH9zuLbXaY58Qfr/1qRezTfnCf0btXWs6Yh
         GzOG/0APQHBBg0P6127RtZ+sIXN0X2T6JUeDT5mcmCtEcPw9VIKYjlqtnBu+jKsitfwH
         g1i6NokzJEIz67ATZUT71rqexQbv63Ap15/Mp5+swaTVo62zEZ6w0f0BoG1KAh3ohUJR
         p4+oPnXbdCftEbe0qppU6JVM39hyBACheLo1A9xyLfo9hkBpMbMNG7wnH8+uO2VnjJRe
         K4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789622992; x=1790227792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aMxiXZ3VjT6yairvAxeBbjdHvNVDdfswnxYz1hMIZxE=;
        b=TlCBmbQjQl0p6dfvmf35c1DoEOvK9Oli1vvrDxs5D9ImT8+P5NWYlwmgIuD2AnIEd2
         ny6QgHF2OqaoYnU3T1UhgZTDkKDL7uMx1pdY/Fc8lqFjO5PbLQ7JHg9EjNSA49E5hB3H
         7xdz6KbqHqs7MsHJEP0uVNn7oKGorIumJ9a8UoaK5WmZlIFqXda4GYasinyXDRw8pz4z
         Cl2f4C56lDruhD11biNPJk52nMcdmS8up3vAJ8x9tp+kdK8WNWs3eWkMWeU8PyUSjncl
         Pf2wR3a8QRJqSF5o9AXCOTq+B12J+IWB2cAd29tWXtCC6fdW3dK5ESRwh3xvvbhMiBsN
         8rdA==
X-Forwarded-Encrypted: i=1; AKwUvBxAc2mOUFH6lF7fnj2XkIIs7gLCWmBdZyH2rTormww6mSKtqS1sREpZm4V/CDzZMZHzCpAHDRwsIA==@kvack.org
X-Gm-Message-State: AFuF++l/GjKsDzGqNHk9qhcicYfyFyjU+nVAzLamgGAsnX/ExvCI65/C
	wSXWwsd10UyRBy+TxBktTOlpVDrc5h36NiIXUUhJIJAqvbNj3Wf81hEg
X-Gm-Gg: AYBFou0ErxBe9W8VjTwWEcMbe6jlNUs1mMY8OQP/0CPoPhZ06l7R2ZOR8TMh8IfbV1C
	tdOmEa0CL6/Nz3Q9j6NyCibJ3398w2y2uU6acizsP7powlHF/h29hbNyNesIwC88kYqxWQaqhcg
	TcF4xsSLaNYHPMf4INmT5LEhgmd/TxxwZDiwuCMG562yb4+THMhVxD+P+7SZRQeuEQALUzr1Qnx
	EcaMZ+C6/ySGxJ3ZawhXAsyvm+7X2rRGddXx3PF3OnbzU68AcB8jjONRW9gNz3yEWMbKxxFBPr6
	p56NSoXRWOn+ktaEZhj4zV/P82XH/EVKdea/AYnI4jGoZdyUqj22QM0vsfgLnXhaRieLqddPTfm
	JaYdIqIu+VoqJGJ4Da9lykh9ySRkKaIT4gYJ1TmKYnnJN7ixeA1KPEBx9izffec/dl5YCMWo7DO
	i1/t+hrtYEH8RSZwwRtvQBz6H+fHANji/k6dXoMJMu/3YKvN5v49/4qRoDMuqc1E1hJWbFH+rG+
	C1icojVp3W567+gnYP/FozLEj8=
X-Received: by 2002:a17:90b:3b91:b0:39d:ec43:3cc3 with SMTP id 98e67ed59e1d1-39e1e2f3e9fmr11172449a91.10.1789622992190;
        Wed, 16 Sep 2026 22:29:52 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:29:51 -0700 (PDT)
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
Subject: [PATCH v8 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
Date: Thu, 17 Sep 2026 13:29:24 +0800
Message-Id: <20260917052933.188679-2-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ox61pnj6pcde5f7sd4kmzmcymg1j9r6
X-Rspam-User: 
X-Rspamd-Queue-Id: 64FADC0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789622993-276970
X-HE-Meta: U2FsdGVkX1/lKcuTlJkVHwgx8KCp2YqNjnYNqm6tOAIWby9CJYayt/jyW58MpzjFHteu64LFZfxx6yUAOYEdCQ/u+euDN/IoNBPHszpO7w3tqJQHSicVuf0389h1B8WWMl191gbuEDSDiPzKr5H+RdU5JlTSL5oICEUQ1zl31AnMJzOkpTboXGZjGaMeS6TxYqjlhXSYL7jlFGtcYyteu0C5mEmZ4KZxeFdaF9kmOwpB6UgDzN8AGSbFOQrRQRFp0AR+WjoPhuFu1k0uXB0bJbE8f2QnHEI0LbOdE9z4spUx9c7TTfqQg694NePALHqKll/V570UFeO9+tCSPAw0SbBMZhRKrZJ4/orNLFu2Lb+SmnfQGwa+Q+u/H06SgbRZO16ksSUJodvLmK5HVlTZa9w5fY1RnQqGsCXikfzRY6/A1xCKSxEc633z+7BsOiWkRDE2sWYeGnUp5n+21iwcm6QP7xVKj2U/2ZBi12nZ1F19p5yW6AfYPSBYzTeFbRlEg4MOoKjEILmsFozMwFJ1/sPX7FI4n1rDqiSHJtlomUkEfVZ1eIZoKDFqFJ6IYm8e5iY5c6Oep2rRx2aJVz5ltIj4Mi2C5GSfoF7eSQB5Y1j9pz3H9nx/etjcvMLBSoWLagxsOaw6ZTtm6LnNEMFW7oK+YrzF178Tjb2kFFmoQF7u67uou3BEZ4jdE0L1apiHPTB/lW/wANpKnZrebe1m5mTZsfZj90bguquRb+Ly1bIDdVU02NLinLS08BI4iAgMDGKh0jMup1Goor09hyOiIjcGRzUDeKXbdFFyAo63ELIcr9cyydlIUAByIcyzYHQSCMfWBsEstci9EGvZWuQjvLi7srx9h+jgtu8ZgwI9WuKUSn43sgPu34sAF3gtyTplKGiIzZgduC7oeE/fk7MfL5VPehSY0WFughi/neL0qh2V44DNPkSx8HPE3dhfUtRAKwJI7mCDIh7JL0fiUiu
 r+aFjdgs
 oHhHH9Rc8FbUZn8Lg2foI+9/NBc1499/yHVbOfcWQczL/S838AFLBFZDaagh6Kp0oVaRngTSmGXRi3qlfXAU1iPzGabF+x3suK3rkVvZqzCvGBMCXY4na6x9BLe0n0SSRH8gPdZ6LF5bCAQl/spMloGFUPGzzLDwYeZlhtFBpH6DefVVHvRBYUqEIcedwhhOV2PtXL/cjHF4TISHrj9W2TT+2usf4bIU6ya2zH5cqk1CGIIBgvrIANYwzXQMwkfPF5V+V63dAbEG4Aeb6sv7JglcIj1wjSOaMmrOBzsj5qaHQpZ8458qcKTNoVJaBSW3u2Ixgo14JGcvBYmb03qoLQY7vT9zl9X5XQiwRaDLocxwX/afE+jmYLofuppnLr+TwUNOBFG9EUdxJpjWkucYodFgGYE6rcjZKhRKZnn7FR5KXZfrMOJYuGb4hYR0Uxkqka3o6Ntaz+9Hr3LMaCCWrTTfi3svSehgPmXF0t/GZm6tGRjHjk9LpBoL1M3q/DstzBLR+t6X/DjQncl/isTCCKSf6Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

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
---
 arch/arm64/include/asm/pgtable.h |  6 ++++++
 arch/arm64/mm/mmu.c              | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d0535..6ee1522fac78f 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1949,6 +1949,12 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 
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
index 92fedf4db9278..93b602a6c68a6 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1872,6 +1872,25 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
+void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
+		  pgprot_t prot, unsigned long size)
+{
+	unsigned long pfn = __phys_to_pfn(phys);
+	pte_t new_pte = pte_mkcont(pfn_pte(pfn, prot));
+	unsigned int nr = size >> PAGE_SHIFT;
+
+	VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
+	VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
+
+	__set_ptes(&init_mm, addr, ptep, new_pte, nr);
+}
+
+pte_t pte_clear_huge(pte_t *ptep, unsigned long addr, unsigned long size)
+{
+	return __get_and_clear_full_ptes(&init_mm, addr, ptep,
+					 size >> PAGE_SHIFT, 0);
+}
+
 static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
 			       bool acquire_mmap_lock)
 {
-- 
2.34.1


