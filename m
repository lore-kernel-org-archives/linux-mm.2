Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF5CC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059BB6B07E9; Tue, 18 Aug 2026 10:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0308D6B07EC; Tue, 18 Aug 2026 10:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89566B07ED; Tue, 18 Aug 2026 10:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D106E6B07E9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7075940287
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:09 +0000 (UTC)
X-FDA: 85114582098.23.843C53F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87CF8160005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="pwLkjCs/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEbQ7HaKthnkMylW+2jSP54OBQRYCmZCNDvb89+sBRw=;
	b=lS/iYaTj4loUlu4Ee7KjHWQbBKSJgECmJFQKllNpz+Yk5PLnvRc1XBBkZcVUygLsccy4M0
	TiVpPUAUQiO5II31Uf6alO3QdTZ6Dgo1+CcgIoKujdWOUeJX7UEe8q77UvLm/aLTsUx2Ie
	gBa5r9jlVhkKKcyEyN/XYoErX+yfJsU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="pwLkjCs/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062387;
	b=r2tBWJ7wBeny/sENv4VnD6DzDnoOsMsqZunYzqA0Yi138GDl1UZtkEnzh7dPor5nxpS3Tt
	/zFQtrGe0aNNnpVNxqs6QGY2SLqkFnL5WKv+zO2Xkh/dn8a+kgFxbBn6uAj/lwPxn1d/QV
	hiKklZhp/4oCV8O8wDrtVYEKwaintMk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B82BD19F0;
	Tue, 18 Aug 2026 07:13:02 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 047FF3F85F;
	Tue, 18 Aug 2026 07:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062386; bh=3t05Fw3A+f9MIyDqdvDITJQvHNjExASbPyfBJcI1LuQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pwLkjCs/AMgJE4mllrRzROMnSh51AWur/Cz8aO9KEJaEvhRykqmxkrolfnlet/wDl
	 Jixap6kmpzZqUUqudL01g7v3AlITmPn3FpaeDVEJ41r+Q+6VYINlnMjYEGaR5D73IF
	 2nvDbZG7GwFeyOlA4XC/9+Kjq6eWiKgdjrhQluoY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:03 +0100
Subject: [PATCH RFC v9 21/25] arm64: kpkeys: Protect init_pg_dir
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-21-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=1908;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=3t05Fw3A+f9MIyDqdvDITJQvHNjExASbPyfBJcI1LuQ=;
 b=py/irnu2oGc01DHweeRBIz5AEoTp+/gX9Q3vCQ9t0ecqfHJqabMsorRVFPwluZkU7iTiQ7nbh
 0CbEMDQ0cTUAUua6Gls52MN+1metgXlLMKlCJsb1Z8NO6zAvEFvZ6P/
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: bu5pn5xrk3npe9cs3k5ej8qscpt3aumz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87CF8160005
X-HE-Tag: 1787062387-602228
X-HE-Meta: U2FsdGVkX1+aqsWJanAryy3hCcW34kbBRzJ5lPnb+wZZChoRtdzTB1LHkGv8SAczNfcOIPOOGZLd82W13hbCbMZbOiwuJEX0rt8PzkW9ct7K1M0QTRdpVxHgsEzI5jCDFCbMWsXq8a97I5dZDTCBzRYTpyC2fv4fA6SfioMx7g3s6YsC5HCc8xYXrt95qYwQ9eck4F1Dn47bUBYlwIoz5zjb0RtyoJsk+cSN03u6zTUXUoc7t3N2AmxxlOaVpMjeem2yROhZY4z03LCF7s4mB14Eidq5cengjVlM135WRstS6ydacO4whZCTXcoLoW2huxyV1PQAPc9STgvESKZjmBi9rD3vp+yEWZCRX1grdY0MrrjMA3GTdGAOldF7JMFczNznBI6YoNEcNkCclp3g52AKwJiFzJaHmY6uryrCe8MDzRRFyJ7mX0VZblGjX4FNbv+gc95WM9jCnGBY7TWii54YOtfAPbam7SXsQj8S6+V38MBaiyVPUQrpj57EW3qGEb5hZ5FLvbfFuSraJ6AoxAC/zMKz8jETKvPeedGpMfD807Rh7kx8z3AN+tbLWR8iqsEoMyuPFiOV1KWggIPiU5EegJvGY/t22Iy9l2CE4Zlpjp6YAHm6s3DH2Y4ZBxfb0lrPKD3ZSpAbykzaAs/mJN0gxX5Je9Gf+9xNiGwMU1AZYxQlW6iky3HgSyOlDm4PJs3w3Ihr/Ge+fmLCzmF9SlZAGld88+jl6tbKvqNYqG3sPXlBuABiV1gpA224jTGXwtf+dZp1RTKL5o0NlP4zhsxCtKm1HQSTU6tCSWbWOXOB12BMywdxDGCpjTTj1NhwWPblTtdX7JA371cT2yZkau7Ec6X5eysBU0V4Be0GdHPytXHelrXkyisgmmiKSDgysiDlap7Rew++H/tYVVgMMYda8lFd5KQHotYLjvNUZ40WnEyUrLhun7j8zf1FEvhe3aWuHh6LrV2osT0I/mA
 MEbDyoth
 uj4WINMxM4OnISfd4jH5DFoY6+2j4DU6kz+JP6J2z3KVXkgobalcgrOmjOTo8wff98GYLIL3LGdI1XAIBd53BEbNUDmdC9zedVdi5rJ+2uB6dt5TKGWA7h5WcFIp800EcvEbSCT+YNI4eoucC78W0NotO5DjB3LxcsnpMtdpd78Xrj15s7x6iPJu2dej1kMN8K4Q9ovEM+8eBQ90CY3giEjdwXJgax+xLlYypzQuqF+kzmXvUwqgjujbZEdEI6kVytG7j2u9/OhD2eHov97i95QM+7u45GvowwBnRN8N4GADvmm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kpkeys_hardened_pgtables is enabled, protect the page tables
that map the kernel image by setting the appropriate pkey for the
linear mapping of those pages.

Most other static page tables (e.g. swapper_pg_dir) should be
read-only both in the kernel image mapping and the linear mapping,
so there is no need to change their pkey.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h |  7 +++++++
 arch/arm64/mm/mmu.c             | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 00e7e5956794..7747af54fd38 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -72,6 +72,13 @@ void arch_kpkeys_leave_context(const struct kpkeys_state *state)
 
 #endif /* CONFIG_ARM64_POE */
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+
+#define arch_kpkeys_protect_static_pgtables arch_kpkeys_protect_static_pgtables
+void arch_kpkeys_protect_static_pgtables(void);
+
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_KPKEYS_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ee972c78e45c..472ad0f8f002 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1073,6 +1073,18 @@ void __init mark_linear_text_alias_ro(void)
 			    PAGE_KERNEL_RO);
 }
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+void __init arch_kpkeys_protect_static_pgtables(void)
+{
+	unsigned long addr = (unsigned long)lm_alias(__pi_init_pg_dir);
+	unsigned long size = __pi_init_pg_end - __pi_init_pg_dir;
+	int ret;
+
+	ret = set_memory_pkey(addr, size / PAGE_SIZE, KPKEYS_PKEY_PGTABLES);
+	WARN_ON(ret);
+}
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #ifdef CONFIG_KFENCE
 
 bool __ro_after_init kfence_early_init = !!CONFIG_KFENCE_SAMPLE_INTERVAL;

-- 
2.51.2


