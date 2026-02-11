Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A611EA8125
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889006B0089; Wed, 11 Feb 2026 05:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836FD6B008A; Wed, 11 Feb 2026 05:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736A86B008C; Wed, 11 Feb 2026 05:32:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 634106B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:32:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 141A858475
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:32:17 +0000 (UTC)
X-FDA: 84431811114.15.E24B72D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57E9A4000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:32:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TFe7/nLN";
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770805935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fVTXwM0zNvbjsVMJfP4P1PkSZuOtnuFk6QAlesaSE0=;
	b=Mk42b9cdi0Uyn5fJcQM7QSJmYN0Lq2hdLLkusP3xLCYKVJ0qrdUYBHRaySFscHATGTAjkx
	g5npupqa2tyHAT714APSoyOe1QC6YyvYdzRpSNcraVFQKy9bzQ2uXwXc1gXh+twkxnig91
	pBhKZV0gn8t501C9nU4wIxUaP5I55Jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770805935; a=rsa-sha256;
	cv=none;
	b=YrBn/PhfKgRAVx/iD5GgrZVzoJy437QvwNT0wYTyP+vjjwF5xM5g8PS56IBwjoVFwa6md4
	2oSDF8zUL7jl/h18me2UjrtezkTCuNCXdStVeNuvRrH0YXvDjKbxiOQASBXAaDZWMpWPeo
	lbpE3QEFFPJWtg7xYiIggWRae1IPI6c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TFe7/nLN";
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7659543D75;
	Wed, 11 Feb 2026 10:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BD6C4CEF7;
	Wed, 11 Feb 2026 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770805934;
	bh=IrP0HcvbxJyr+QPUUgTWRvTOZExBIyn/P520HSFeTE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFe7/nLN+rKkMzW67S9vCNdZrax/kPne+WpMF87k95gqGlUzqF+fR5WSEUhJQdT3j
	 pPxb8u1Ax2zDRwbXDSOUkXQnSyyGT9ATA7S3mMXNx2TRCmDY+UML8uqdt2x5uN5KOn
	 Myw0c7iyqZfsQ6nIDluj/Ct6feChieIpAVe31sKpg0gTQ8BQT8IA1FdMJRou60J6Id
	 rBVyOi00C1KINFPks7VJijlaVTWk5jn2wnNxzaifUW5ZIAAy72z1/aL01QcnnfNWRP
	 Oom4Kb7P8HeZb9qPQLur3tBkv0FhMqGVt2yWCiPLRGAsku2RHRh3DuKoejRqRBa2Dx
	 Gdc7juu6vCfng==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v3 1/4] mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
Date: Wed, 11 Feb 2026 12:31:38 +0200
Message-ID: <20260211103141.3215197-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211103141.3215197-1-rppt@kernel.org>
References: <20260211103141.3215197-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57E9A4000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p7wfmkik45j5kp4ydpfqo85ornw5nz9o
X-HE-Tag: 1770805935-568169
X-HE-Meta: U2FsdGVkX19FUlr2ffPJwi4jpuz9pK5klnnJybsNGwnc/fwbtWDN13X5LSlzs+x8bc2gn1Z3zISNUZ86P+xPZ7s1ESR2ApbQbmvxGto0osxghQBCO10fN6s8/9im2uUMfgpZJgycCDsWmcZv7xHLgwID3Kt9CWmFpwvWqgB6OAv8zVR4vvS9fzYggofLxawvq8nXyaI8EZLbff5LipiF3IxUjVPtdXh9tMsztHVMxkEXCz2iiZVSPP2VuloqEUG4PpDahcQXpzmyTPXvYMvL+alTZ+xES49NAOIaOwbdDeLr/boQnX6AECQjD78EraQnu5mJ496etL2FBX6Jl2SyEQ4534Bznc7dmqj+SDRNg8Oc6iu6ZnThaXqcq1iSt+muW/cV7gK5z6OE5OqgMxvfSNwLPu5ho9l/tCvltz3vH+Jv2U6j7KMrescD2YrMuDRCXJBLVtK1+RtOIyacmnISMGVPpBiK2iq/iQcgJwvjvknKI1XY2o3LRHboODkl10JdHR7jg0Mc5BXsUvGPOOa/SWf/eWD6zhLqNL0ex3cYizBO+wEtA7keE/4Zt3aQYDiE1cQZ4DQkDViSIxnWK4L5/tThBH09qqZYgKzbLQ+uiYaL3h+LSWUUQ0rHcqJJjsdXjxzA4DAW+uWMsEEbidp3O9ARovSDeGYiFvxb57L2sP7FEaJ0fsWNOjoA7+4mes/QGrdoA9HSfgnXguPeAHGg72Az4X/A3eXJO4T6x6ckCjIHfUt0s5pA4AQ9nJkr0YhgauS811EuRhI7wZJHedEnJKMTVUIuLLjHMCZrZjEeTY/98NNPViymU8f7kX+ltV8dH9KkyKQJ87vIddy20IonvPn6WydhVq2qKbXs5RW2DORHj9w8LPDefVLHbZdhEeMeslz9ubOGyuLt0xuRlMjuytzIpf9R8maaTTMoVsKWDIMGufh5YTuK7cBAHD5SnoInRCfLxOiCBX998scIhQ3
 XjwrGBGH
 9Rk4I53W8/cot9RD7Nso/gtYw38ctX3ChkIdik8r0b4DrWjpGtiGt6Ztv0j98xj2NOySKoANPKlPTlWR8WKmCj0tlh8ZLBM6RXxPfCCNCYchnegnDbq5ZbA3qGLLrEoUY/HgXaJq9Twmjwzq5ZNihvY3t+FyE0uIIipy/kYcslBBPJzBemWPrUFswCbrXGnNRjmvpFGCtOJURivX8kAXyFmyE/yGI8XSc6FQV29USo/lrhOxNAVVALkUTGN6yJ2DbfGjAs7bz6gyye6c6fMNrstS7tNj4Ua5nCn+gme74W7PBPH59NdANVmCOv3FNHWs2Ym3a5qJQJQ5oAFgb7Vf8v/v38vFMB5ZwYP777Whn/V0c09I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

nommu architectures have empty_zero_page and define ZERO_PAGE() and
although they don't really use it to populate page tables, there is no
reason to hardwire !MMU implementation of is_zero_pfn() and my_zero_pfn()
to 0.

Drop #ifdef CONFIG_MMU around implementations of is_zero_pfn() and
my_zero_pfn() and remove !MMU version.

While on it, make zero_pfn __ro_after_init.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/pgtable.h | 14 +-------------
 mm/memory.c             | 13 -------------
 mm/mm_init.c            | 10 ++++++++++
 3 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 827dca25c0bc..08a88b0d56e5 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1882,7 +1882,6 @@ static inline void pfnmap_setup_cachemode_pfn(unsigned long pfn, pgprot_t *prot)
 	pfnmap_setup_cachemode(pfn, PAGE_SIZE, prot);
 }
 
-#ifdef CONFIG_MMU
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
@@ -1905,18 +1904,7 @@ static inline unsigned long my_zero_pfn(unsigned long addr)
 	extern unsigned long zero_pfn;
 	return zero_pfn;
 }
-#endif
-#else
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	return 0;
-}
-
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return 0;
-}
-#endif /* CONFIG_MMU */
+#endif /* __HAVE_COLOR_ZERO_PAGE */
 
 #ifdef CONFIG_MMU
 
diff --git a/mm/memory.c b/mm/memory.c
index 187f16b7e996..51d2018a387a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -162,21 +162,8 @@ static int __init disable_randmaps(char *s)
 }
 __setup("norandmaps", disable_randmaps);
 
-unsigned long zero_pfn __read_mostly;
-EXPORT_SYMBOL(zero_pfn);
-
 unsigned long highest_memmap_pfn __read_mostly;
 
-/*
- * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
- */
-static int __init init_zero_pfn(void)
-{
-	zero_pfn = page_to_pfn(ZERO_PAGE(0));
-	return 0;
-}
-early_initcall(init_zero_pfn);
-
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1a29a719af58..dcf9eff34f83 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -53,6 +53,9 @@ EXPORT_SYMBOL(mem_map);
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
 
+unsigned long zero_pfn __ro_after_init;
+EXPORT_SYMBOL(zero_pfn);
+
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
@@ -2667,6 +2670,13 @@ static void __init mem_init_print_info(void)
 		);
 }
 
+static int __init init_zero_pfn(void)
+{
+	zero_pfn = page_to_pfn(ZERO_PAGE(0));
+	return 0;
+}
+early_initcall(init_zero_pfn);
+
 void __init __weak arch_mm_preinit(void)
 {
 }
-- 
2.51.0


