Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6BDCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37696B00BB; Tue, 26 May 2026 07:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FA36B00BD; Tue, 26 May 2026 07:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25696B00BE; Tue, 26 May 2026 07:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6116B00BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65C391A03E6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:44 +0000 (UTC)
X-FDA: 84809323368.27.8046F93
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D0C914000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="THS/riMi";
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0KoELKRRwmDAfahfJTUc+uIobAEiMIKaEk4W23H/VQ=;
	b=tgAKMAry6PBOrtSVBwrPBf+zIEE78qrsCIa0kKBfXIlMCfWSA1Kl2vdAtZns0zUGd4PxRQ
	mhAlkpgqzG21DE/N3cycyOH7Zw2QWTHrt9jOGpOM1NsO3Du5CWItn5T6MNEOPzOOzY0z33
	QuJB+/LhytGCvdyK7nZE2K5DiqlyE8k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="THS/riMi";
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794322; a=rsa-sha256;
	cv=none;
	b=bYS8E4OfnZUFul2LrIUpCUQaKHI0Ec4LYKGWeCHhMxF15EAbHUBpeOQfJOvyjCUIasAAXB
	uMAu7+steG++iPRWr3CAE6CYvvvIOQmvvW+/AFKrEREdKW1NR5h1le8Xt4d5C72iQC21ZR
	hY9kSBMJGO1MRYFS9IWJdW/qE9sLdtA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89889169C;
	Tue, 26 May 2026 04:18:36 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC66F3F7D8;
	Tue, 26 May 2026 04:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794321; bh=1IVD5j1CEJNPyQPo469MFlwKHyDekxyzAgV8ZeSmEgg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=THS/riMi7C5yQcst131e6BfWvHZ4j8Q20HLkik52Zm72DsWMl/F3IYHE37P+hWzP9
	 2QaD6gtm46vGTqYNVC5VpdhA2x4NweSGQMu396+ImDEXFL7P4m7fJJ3qrF9IML03vP
	 BdsU/rSjQON0gBzdNwW7FYvfQPOi6TnNT9Fhjff0=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:09 +0100
Subject: [PATCH RFC v8 20/24] arm64: kpkeys: Protect init_pg_dir
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-20-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1970;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=1IVD5j1CEJNPyQPo469MFlwKHyDekxyzAgV8ZeSmEgg=;
 b=eLwx8ZM98HqZWVbBPTdulrsM8wMwYsZj4yX7k59cAfxS1/a1XsaaZ1mq+NT0nBuxniE8ugJ+p
 5p/YyudMugbAID64kvNWLERxI8zOLDYmfP09kHVZYs82bE1iYEQfIv9
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: cd3zi5hns68tp8cuyqj9r5cuircmpm7x
X-Rspamd-Queue-Id: 7D0C914000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779794322-763966
X-HE-Meta: U2FsdGVkX18XeqXcvvprIkTPpUNRZ2HGSc+ygSaRd4obAwgXuafXRY0/BI+7pKriZ4ZFTo8HhBRPvD6qMVT4wEzhaG8QVTtDn3AiAmuvs5KjYH9r4a2j9wjtsJmnLkGWLVQr9/WInpIsITOeN1WZ51dICtNDZCyRxSWwz6O8EiieRN54cQ/Ex9W1STO25fgjRs6CqAqQzauhFxcsdZcLMHtYUWvdVX7xc/zXmP6yKPK8CIV36djxvy6p3MsUOCby6y8XfT/Z5JeqhU8e0vJHlh3U3AKo41oiXf2w5VbHJzakhbpZB6kxAbZk5CPL7+wFXRJhu7MoWK90WMd6AgP9t4K4DFWp9OqligXjFRUx+eE+cdNVY5MlYhs2MwZu0ekbJhA9fiZzXr3c4w8SE9j8KsDgVSR2MpIOaXfK8xica7I31siboAMj3ASXN4rknUkZ0zUYdKwWC8uV17Q8eHzzYXY5EAny8tarx8vcrU6iy1yPYOwIeNPF7ZXV3k8+TGI/dPbVzB/ObQbyL7odZYC80PorNjiREDX9vc26TTczv3DL9nf0RH7YlTPtzH98HWsx+vSWLOsGXyerOnY3ZUTK1a4b6vJk9h7aGyuyyzuOq4sTdR/Ix0ii8QwKStRi/rhOF0K6omAG4yOfGTNGMF9mbj6qzjNNCADp6vAwmHgj8YZgasf0qype88dAwu3OaFOQVt7jz6qFqPS2EMzp16MBai6YeSCYWTjYe2rctoTlt9eWEgiw7KxaPncyAL+oZmje8D98ku8SRo20vdI8i+Q98+toBWxJJT2ck13xMKaFXIx1SfJPRDobbJWbT1enfFfDoaOncMBEjSrCc/21Bc36ZhJIXaZjsuzV5MbAoPBJhLQ/OHybPNHPUVNDGhTKfDcyUUrB+wnIyATbVKG8eEHybS0ECnS7lW+EeSw9kpVQBJQHNIbk47NFAUOuax4Ujf5J7DC0GYmzl00plw8Op/A
 j2FL4HIB
 tHw7ymyWEKSTwnNaSSaaMaYbdTbThIQOdkhk/20uDmCmvZpSAw0PdgpXPucvua/yyQoVmT9FlSlszQ3nH/pOiMfFnwo7Ms/8WTcPlnq/b0BLKZf/bLPjTvMayM37zKbTJN45VqUQ/xCctCCjWCfOLCrcJeouutRjHEl3BtePSQHaYRfhS6/rOF1J9Uy9FlSEiUyw5B38OhdlkXuV/isRbeZeOywU6aP5F+BwQRfqYUJOfR5Ozg0JUpFjJ1X7IfwM6HgfWGxarzDLrsqR90fr2O1SIkMo/CvPOdX/mwf5Uozw6J9M=
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
 arch/arm64/mm/mmu.c             | 13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index c1daab643195..382ae27532e3 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -64,6 +64,13 @@ static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
 
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
index a9cc189affd8..072500579c94 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1055,6 +1055,19 @@ void __init mark_linear_text_alias_ro(void)
 			    PAGE_KERNEL_RO);
 }
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+void __init arch_kpkeys_protect_static_pgtables(void)
+{
+	extern char __pi_init_pg_dir[], __pi_init_pg_end[];
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


