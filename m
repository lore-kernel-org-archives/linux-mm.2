Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953D5EFB7FB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24816B00A2; Tue, 24 Feb 2026 00:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED74D6B00A4; Tue, 24 Feb 2026 00:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3AA6B00A5; Tue, 24 Feb 2026 00:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C36716B00A2
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:13:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81E97C1A82
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:13 +0000 (UTC)
X-FDA: 84478181466.25.15AAD70
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id EAF3140009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:13:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909992; a=rsa-sha256;
	cv=none;
	b=38ELLUpCWzTcemsn7GmRdJMQ1pT2OXv+iZy9Mdp+rLQ+md3ghFQv2PrNKgy8fUdsh5tL19
	K1WTa97J82B9euSj/SQEQTy3kmzbZW2CAnk+XGFVrKKFWvAfnAyXbGjfXDBkeVSHd7FOQL
	23NUN4jXdEeHMnDaG0xn9dbQSz+1/MA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h/ybvBATGWJE9Rw+0QGta2Q9ZHlI9+0HCCQxMbYIjyM=;
	b=AcVZc3NFMxQbRu1NNoxlRYtUfQIbdUUk9DmygUAYzInzclTKdhYM+YQNX4xAhL3f1cNGsT
	W79WKyIbCOe8UYhxlzlSoKzs+0qOl8z6r4Rea4l+RHclyAZ8wMGiVWRqKatcjykFIr5hZU
	oTujvMZ9l2kKWzq8RKBgnCxKQxVTxto=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7F0B497;
	Mon, 23 Feb 2026 21:13:04 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D52463F7BD;
	Mon, 23 Feb 2026 21:13:06 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V1 09/16] arm64/mm: Route all pgtable reads via ptdesc_get()
Date: Tue, 24 Feb 2026 10:41:46 +0530
Message-ID: <20260224051153.3150613-10-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAF3140009
X-Stat-Signature: jhdq657b7gr3fxb7q571189wy1duakbk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771909991-58876
X-HE-Meta: U2FsdGVkX1/PZFt7bGMwMdO3RdSj3Iprw2lZT7Tmp+COKiKLn05OevhNfP/Z5erZHs2Cfj5OdFjFKxZMj/ZpBPSfUc4iKOEfd6OBZExHJzweKZ7DLWYuKPVto7DNQWmQf12o5taoYtnaI9pI1wZjnYeORW7oocq4SbHHoP1cTN/S7cDeFxrZ/pWcgtLQ8DDGzUxLDGKSAijLCeEqjrOsZe/c156OhahEL0wvAdFlLEKuVv33ZPO+iYsSM4kophK9J/R/9eSWYTBsLeSISBZXYX6XoKdqcTbgGLAVIFH9PtwYCgagXZ6P96Nx1ETSOnrRQQPG+UiWDf34ToE7ZAObwTXj13EATMTIcFSR8ErjPJxsQx0iJeA+vpMcSEgV4NHpSrrD3jALAi3QV2V8a3Mf36AbYoEA0fjO/OcKmuGRfNLHSkeZXMOwmdVlfSCucEMNeIwEu+vKp7d8wvWBcThNsuzWV4EMm3j9GEUqHc6b2dVk/UZkAytytVMtqvlQMiOkTQfdPqV5g2DLyqpDxmaZ+Z40Yv0hHYPcSKH964S9xfODZSv6qPvWWqdksQ2jgPGQEFdiuwiCZ2bYHle01dsljO+uGLRWnwUeIwJT+UlNuyc1h94dNFs04VQfRJ7Og3BgSY1aSyh9k8QTBHu3pTiWewABTlaA2NFvITLUx4ulMMA89GEpbfAtt53ovjnP/QPwcvjjlBSqPbAH9/ibxTKzSzDqhyZA8p7VCoBZbCjnXmwnND2RmVxACPQ1aWWReOlESfA16wwjVFz7p0jeNAU3d0ssvP/nHfBrGpYk/h5aCYg/1wClMPgelThf1qxU+7SPSkCrJj+6QSu7nGG+TDsyLVqP6zzWeEcv30fQmLVyYbZ6xxPg1wxiRs235Gocpew5NieLg0/JXEgMGMpJWNwI3YAjwZzSFKR389cDwZ3eqe3Yk7WgcYsi7SUDQ9mM3x8s/8H84XbsF6urHkKQAw+
 fv+IdB9L
 fyXfOvTEi4eQ4CU6aDc4F8LE7pidqkMUxqzUa+uoAfqdcez/C1Zt/58Pmc2zwRT2P15/YYG6SuYo76DDgBjf85WxX1wQjOpvVPgnq/8nKSRYWfJoz4RNRq5j5tMigx7K72fVaDtpPa/PXekLPZ/gPhUjFkzogM/kXRnxpMKZA7ae7aHZUCsQMmq9Hdu1fFdP7vxWwW9UEZW7jiZTvrq7RvVtcZ3m5c+nJEIhhdv86WL7LI0H7097GP8FGmq8nwJoujZlGysFVSL3A6g3Ns2Z09hK7IWE4ZNh83zUv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define arm64 platform specific implementations for new pXdp_get() helpers.
These resolve into READ_ONCE(), thus ensuring required single copy atomic
semantics for the page table entry reads.

In future this infrastructure can be used for D128 to maintain single copy
atomicity semantics with inline asm blocks.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 257af1c3015d..804ef49aea88 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	arch_flush_lazy_mmu_mode();
 }
 
+#define ptdesc_get(x)		READ_ONCE(x)
+
+#define pmdp_get pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return ptdesc_get(*pmdp);
+}
+
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return ptdesc_get(*pudp);
+}
+
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return ptdesc_get(*p4dp);
+}
+
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return ptdesc_get(*pgdp);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
@@ -384,7 +410,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return ptdesc_get(*ptep);
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
-- 
2.43.0


