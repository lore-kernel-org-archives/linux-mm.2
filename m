Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B65D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D706B0093; Sun, 11 Jan 2026 03:22:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FADF6B0095; Sun, 11 Jan 2026 03:22:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6AB6B0096; Sun, 11 Jan 2026 03:22:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F14616B0093
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:22:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCF461B548
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:26 +0000 (UTC)
X-FDA: 84318991092.07.7906E0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C08280013
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7lICoEa;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9EN8P3acoDv0e0P4EVIlls8TUWgxf/J3foZHd7o2bM=;
	b=uvWmFrE5dw0nFlFPh9lgEFRDXqvTd5wl4PKQ6zwBSectCIvDDgKqXSQXMHXuXFJSMAu/XP
	nfaNWWoXEaCUxzz5p3ME86dYE/00giK4VpDzHfvvkp6MupptHhpD/hQIVuq0KQJ9Wbkj8F
	spMiwiYAdpGFgQ/DCN+faIZJokYFXVk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7lICoEa;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119745; a=rsa-sha256;
	cv=none;
	b=8IA6jd9EjnFSPGP6ye5tCrYuUUjZvscFZuwCZbCpQWWYc+rAMcQ+ezD27UlOSabqMUh4cN
	R/eBAKNIzETwfTxwA/wP1LzFGXkwo6Xl37hUjLZWX58ZffecjYcniA9i483yhQCp908+nI
	JTOeA/EEMMs8P8fncguMinmGnO66VV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8612860127;
	Sun, 11 Jan 2026 08:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B3C4CEF7;
	Sun, 11 Jan 2026 08:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119744;
	bh=tQxK3c7Hkef7Ih3mT/PwmwcYPHyFic1JpOQ4F9wr//s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7lICoEawjuGlfAsC2qFFo0dYZjPTTHf6ZsKHEUok91SlgxJeaE0+xUcEvDNupyt3
	 5Br9cYXmHoDXcMAya3BF4ypvrXlUGSih9s9+iBDKvjwhuneZTRDmN8ONDbWct/rDHQ
	 5QoYlxyIJuLHIwjKBtJvt0vr+DnaCDPdkgGm0WnDnqGt5kiFGneMx+DwA0ClLjLb/V
	 /wEtIezdVvzMPd8UCllgRT69ka6QmeOMOK8t6oMkgPq8KwqkbxZp11vTvUC5GGqoAl
	 ayAX9QigC5taTQ49Jj6N2sxw6qFmAMp9L7M3/3wbbjKYkatCZdLZOULWFYtqCB5Eas
	 /JSzikIr1W04w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Klara Modin <klarasmodin@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH v3 04/29] arm: make initialization of zero page independent of the memory map
Date: Sun, 11 Jan 2026 10:20:38 +0200
Message-ID: <20260111082105.290734-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C08280013
X-Stat-Signature: 89hhi7chygophkraja48tai6ga96k46t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768119745-516762
X-HE-Meta: U2FsdGVkX188UuyXLdZqfm3rL49TYCJtBKw9u58IYA16/y0h2tzSLbAudxq2KPiyP8bFQmcavJiD4jLGlGHNKDNh66bJbuzLUF2O4DJu+Pd64EM5ABy6/N8soAeZR0FKBiLIV3NegaMKAnTQf/ZYPRhtQzwqqugBhoM1YRM1C0k6DYUQt1HRYtxtkO+mrC3EAAm1niAOyoxOCl73+RDD8GulhgptKeIzL2TQuOXpyMV6DEAPqixrs0VAlfe+JmDA4vhgjHx2tlXzAifs8RuAgV0EhY/HR0y+SK4Y02JYk4PsNO5sNg0ksBLEo+7cDNiorucMKErpMdrdBQNOkSgEU0BzoJtoGzoZgxeXIKM3OzwacrtPfsZfBGTZSB9IXDBzRHLiIpdDwcfvtE0cCaPyyFpHbk/lUYJler+xUJOzE4Q4kndsd6rGzWmy8+tTFGEbTF81KOblSDOF0n1LGTzikC3/dMD6kLzfDwTDEmVVI07suv4S1GVDP45+Xab/imePqBXWP5hwqWWbgsna8goKFaQq8RY28qx/Qpt+mslHbgeMOpvf/v21/j64JVQcQnnb6KThKt7x4aEj6PXN6QjhZBugdfbZEJOEr1am4gnCYvBtDBsI9Ng10h5i1yf25f/Jk0yI6J2v16516pZuzDYi15jf6ywRPM0mzmgjkmrSyz3m48BcBOs5ksj26ACT8ncFiJalJaARVYLgc9pl82suY+dAbrCe7H/Uap1ineeRh0texcEGOWGH/WR5dR9b48SeHX1rj52281JPAANhudxuJAHzGOvw65/hMeUD9+k1MniS1fuPG22/8EZ2888Yqq/adVoGtxUXeqGGCIDy5OK6QYfLXaPaA+NiPDXD3/bzd2zqX7Oz/ErBQtQ57m9PypVZuRhI+jru8pwkewBL7lHFh8RDH7I/II8/xsg0Da8s5LYuZgQzpPV8WUDegYAEilXB7H4ZWW7mockAmz8ZkpI
 R2OiXncO
 3kQ+TkOLy7yggYLgicGRCS6xypmHn4kuakLXo8DouRdiYvo3E/h47v519kW2S4zY/ObbJYXQQES9c2PMALN23rmYXOf7ueNO02hiChSC0kK8MMbTSm4sj4AVmLYT/ef6IFdRpUJYIa6sZ0If87CVgC3FxuSlwH2vRefxLLI/tnZjVU7hOju3t+OFLDkPe3PjGdqM/QNszcQquUmZYIh7+LbtWZyMd8r8v1O5FY6I0seuowb172Dy6fRcc2AQRGT3KblDJS0bBh5IMWYLb2SwJJUwNDfuL8XQHEccDPpHaRopYOXupMhPPs6CByAGUlV0lQjzsm4stl+7ZNYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Klara Modin <klarasmodin@gmail.com>

Unlike most architectures, arm keeps a struct page pointer to the
empty_zero_page and to initialize it requires conversion of a virtual
address to page which makes it necessary to have memory map initialized
before creating the empty_zero_page.

Make empty_zero_page a stataic array in BSS to decouple it's
initialization from the initialization of the memory map.

This also aligns arm with vast majorty of architectures.

Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm/include/asm/pgtable.h |  4 ++--
 arch/arm/mm/mmu.c              | 10 +---------
 arch/arm/mm/nommu.c            | 10 +---------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 86378eec7757..6fa9acd6a7f5 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -15,8 +15,8 @@
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-extern struct page *empty_zero_page;
-#define ZERO_PAGE(vaddr)	(empty_zero_page)
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 #endif
 
 #include <asm-generic/pgtable-nopud.h>
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 8bac96e205ac..518def8314e7 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -45,7 +45,7 @@ extern unsigned long __atags_pointer;
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
  */
-struct page *empty_zero_page;
+unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
 /*
@@ -1754,8 +1754,6 @@ static void __init early_fixmap_shutdown(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
-	void *zero_page;
-
 #ifdef CONFIG_XIP_KERNEL
 	/* Store the kernel RW RAM region start/end in these variables */
 	kernel_sec_start = CONFIG_PHYS_OFFSET & SECTION_MASK;
@@ -1781,13 +1779,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 
 	top_pmd = pmd_off_k(0xffff0000);
 
-	/* allocate the zero page. */
-	zero_page = early_alloc(PAGE_SIZE);
-
 	bootmem_init();
-
-	empty_zero_page = virt_to_page(zero_page);
-	__flush_dcache_folio(NULL, page_folio(empty_zero_page));
 }
 
 void __init early_mm_init(const struct machine_desc *mdesc)
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index d638cc87807e..7e42d8accec6 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -31,7 +31,7 @@ unsigned long vectors_base;
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
  */
-struct page *empty_zero_page;
+unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)] __page_aligned_bss;
 EXPORT_SYMBOL(empty_zero_page);
 
 #ifdef CONFIG_ARM_MPU
@@ -156,18 +156,10 @@ void __init adjust_lowmem_bounds(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
-	void *zero_page;
-
 	early_trap_init((void *)vectors_base);
 	mpu_setup();
 
-	/* allocate the zero page. */
-	zero_page = (void *)memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
-
 	bootmem_init();
-
-	empty_zero_page = virt_to_page(zero_page);
-	flush_dcache_page(empty_zero_page);
 }
 
 /*
-- 
2.51.0


