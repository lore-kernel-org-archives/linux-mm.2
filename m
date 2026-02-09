Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C18E81BCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE3B6B00AF; Mon,  9 Feb 2026 09:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5216B00B1; Mon,  9 Feb 2026 09:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BEB56B00B2; Mon,  9 Feb 2026 09:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 688D56B00AF
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:41:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E93887807
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:41:29 +0000 (UTC)
X-FDA: 84425181498.10.8D6DCFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 87A0D1C0011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:41:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APyMK8Xc;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fVTXwM0zNvbjsVMJfP4P1PkSZuOtnuFk6QAlesaSE0=;
	b=N5xBaAj7lna5raddfKT8/+jMhKcidLEmzo6nFiKMBPB+dtA0T1SFRfstL3y/Xig4c+oplG
	i7ftwvLYs6yEk5T1DHdrbG0ux9jOk829ogsCi62LLndeDJOv27zN61+z0pX8hzpFQnomMa
	/44sOXsCOHwK08hr+N0McnOQ+exX8ns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648087; a=rsa-sha256;
	cv=none;
	b=bYj8Dd5WDo/Mf+ZbjIT9jDlAl2N+ULZXmkIX+x/1HZd6RUKTb3PyD3Hs5gS6KbcuBjbXtH
	sE1b2FwcpyWQlbl411AswFU4bGABirZeCvzpRQ0EWtiwhCaSUKwITqtlUxBXYv+NNAi1Dx
	4TaXEpynCjCUDLQ7JGgeKIcpHb6FacE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APyMK8Xc;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA41A6013E;
	Mon,  9 Feb 2026 14:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BD7C16AAE;
	Mon,  9 Feb 2026 14:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770648086;
	bh=IrP0HcvbxJyr+QPUUgTWRvTOZExBIyn/P520HSFeTE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APyMK8Xcr0Pj/4H/7ScdM60IKK2Af+gkFXGdQhPjdHsnmzLsJm02Nchy+jJL23anM
	 bNBnoHk9xK2QiZTV+rQY/KLwerxB3VnzQfxzTkQc1iH70KMN3Z0GuLpljati7S0tf8
	 ls86zRd33YVz+J6pURgPRqvGX5Q/n+dPhzCqdL5yV63J60pinW1+OsSd3d1xFDgsvS
	 6up5zQsE5HXsLq3bdag17WhUQCgbBwXYJxsH7xLXV9rnrG9HIsZoWR0mYcQZNF9Lk2
	 3fCjxQBhoGvtiYzXnS5lcX8tXcaTibT8zTyCBbpHKv+p0HdsmTNf1IjvNxObtwAPb6
	 sxyY+fXDu7Mnw==
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
Subject: [PATCH v2 1/4] mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
Date: Mon,  9 Feb 2026 16:40:54 +0200
Message-ID: <20260209144058.2092871-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209144058.2092871-1-rppt@kernel.org>
References: <20260209144058.2092871-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87A0D1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8exf1mkc3eitjb9u3prxoey1yrp1fd5h
X-HE-Tag: 1770648087-719907
X-HE-Meta: U2FsdGVkX1+1SjXtlP28KxOdJV4buuu/FBjov3ROADf91aHldIGlurrzKiD5gLYKxygk8lujvd9/ED6HbuXCKs8PBa7Osx1TNsVfcSEh6bOnJJR0w0TnzIjYntHqCPvpl0Ew29EHo2M72RNVt0Rf3hlJk1RnWWgRyjXRFoCGY+rfCRfIjli5sUHnK6V9PgWZ5hf+kk/dKm1G5nGzq8gq4TT8Dd0QP2TWXWhTkuedfObEp+hlL02/Mq7LHgRJvQwycQlNgZpYlNKqySUMpf5vdnRAO6r8g5/1BZ+fIIaXHbbUQ0ABHuRP4xhlxqZmptSKNuoybSltcsYOJd2R1sXPHh2gdP52G7rlwUZfxy6Fl2o9h17cH/PQIJfTvdC4YV4pfHJ3RphysSCd+dZJt1D9s1DZmo6a9xxD9PzMKKfTKM/3T6adEmbjUINkhuaOYeQtYAkzIgsHNXEugN1j8L0S64+GimCUibdUXLk4soVCfnxdHohEGlYKYs6N8k8kAsK2rqypuEjkNgFoch2Q1yaFl88EmQguhd6+tcFwQBuGq+zcWdKAmk/SCh0gnFItjtwC1XdTOleCtWTLr1Ift76PReooc2H9vtfFN9162prhEGmoFdxc6ryUck8Pqnt0zwQ7Fe+O+xpuzepxEgpk/9MOx0GNsl9zgbuDu57cwr6A7B3VQtx71dJnCDi4esd7rOQbQpuVIPN4y7xnMESHCLZW9hkUcoz9AJZm/7T9ckAMlNPUqCmT8WQ1xcfN9FPE9I4syGCWirKWrEPvGU2HY5UqMWqjCXy1fI1qOUl9msoo9lb/QjGz2UPAJjOr/p7dC6auT7Brwl9DcfWnr+5HpS/caOKn4L3USF3MB3/VIwPIVRGB7nSPX6rkX/Yht+tEW3Iq5eRFMKeRrcogx6tyB8QIaasHxkyiZ/Yq5hrgCcCMl/cJsG/DRVulJdQqgPcLbVhB2PCnKYyTNVDoxjDbj8+
 v+yUWY7b
 +c8JsHyaRczb6eul9xag8CTAxG5TZiX39kOA3tuIYifydsVNSav9DkeO76G7UYSNP/Ac8m6LeR0+b0F3mQUrO/wKwE/TJuop70x30k1FsQ5nmhcxs+YL0biBgcu2iW+mN41aLLd6gg7uxn+i3f/9Qz4Vh8SA3zrayO38MDpV7/lFF6m5n2dfzUfBm3s9L/NSxgcukcJFnGTy9oc3Z9uR3b59bCEIqzYnpOSfVZh5P0BUJtIlgn9XOtp7CxoY9Rs5k80MLBpzR7vbpdUEJ6byelFeCTMCP5UJSJhiOHh7O5ULMr0EzT44DnNK3bDB5ehWSQhLbGh9jJlsXFurVBsu0Ril08lMtgmHlSJbp
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


