Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BCDD25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0D06B00BE; Sun, 11 Jan 2026 03:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E6E6B00C0; Sun, 11 Jan 2026 03:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70BE6B00C1; Sun, 11 Jan 2026 03:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3C526B00BE
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:27:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E67E1B57C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:27:44 +0000 (UTC)
X-FDA: 84319004448.21.E447DCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D460F20002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:27:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cucgyfK5;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768120062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBBKJwrcTjhhjxH1pyy/2Lv9SOwm9YyMZRAlSFGYa0Q=;
	b=BjUqTgVCvU4u2Zi9i2lNXYCf3JlKm3Y+ycDry56Cia7LmhXwIFQxwYMBloTDGXs79V0k8G
	aGlsxbsVZY3aj+VaovG8cbXzcn/WvCR487YtowVhsKHN7Wr798k5yS/xuElXCpfEItuoi2
	NAxy3HXkKW1ozntgHz641evMDnSNVH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cucgyfK5;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768120062; a=rsa-sha256;
	cv=none;
	b=XXO36XdwN+YbAG0V2ribXqwmdEi9uSAvVKw4X13eOSwi6eg4S5BmYrBiA1Zx68yDu6dMdm
	hrDvKnQUdM/lpPBQVhzxrZKatkkNfnDhZ9J4YzcHoyC21Kf2PESPMU31xCb7N7BViaFmDU
	ysOsfsZyIEU7bUXuJ20DGyciS7q3lfw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EDF460121;
	Sun, 11 Jan 2026 08:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B0AC4CEF7;
	Sun, 11 Jan 2026 08:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768120062;
	bh=zd5p0i2OlJkjqXnS1oV6Bjn1onLoj8/4tNSvugcI3Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cucgyfK549u/HKU9sXOhtGyxmUzXaeQo6OcfMmBauoICa2ALqFD4CHcgssCffdtz0
	 jNR5GmojmKPSKMXaxzTVfIKcpg4AhT3GBI9gKFSlU99+ajBqkW87jen695O6x8QgyW
	 qqFORooblG61KNiQrUz0ViZwhnArOqE+rUf8POn7T1L4C49wdI+cVoEUkJVPyN1phL
	 DB6aLqdi3kVV0WLbCcSIvN7kGg9TuKq12+ybRyVObguRL0q+vGXwqyNaQkOT629PZh
	 4zn7LMoAz8MYeLMbgJf6kw8eNAuufEeYwPLbjRlaWuHnzdOzixI9umBE0hkN04bQGL
	 GyVogLrYtnLyQ==
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
Subject: [PATCH v3 25/29] mips: drop paging_init()
Date: Sun, 11 Jan 2026 10:20:59 +0200
Message-ID: <20260111082105.290734-26-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D460F20002
X-Stat-Signature: uodssctodymxk31otqe744rptijz7wfq
X-HE-Tag: 1768120062-372511
X-HE-Meta: U2FsdGVkX19QDYg1z/34p36bQObKMO83Cyhw6JsGZ+PMoGYaJn/xBfkX/Rqu7aRpud/JdYETIimCw00cvVzp+Eugrh5nUyawD0qYjPkvejIzamZGdztDn19Yru6bU1GiaVdFyAkPxsxoRSb4clzJjNH+aa9XN9bcTXT7e0HkJtLfCutkjTEbYHiZgeN1+SRMQWlQTmLoSNu5aCtt01qMiACcPoEuLB44/AQQnQV7wK5LY1vbl9LaMMGrcDJZzI5woqKSeqYDKThVdQDY5xJ4gfURW4GP3s3C1zbpJX1ZbMeNvaQDfCsWn9YGbiy8emWu/MswZXcTVjaOksnyTP8PmGUUM+o95Iq/YkaEJFg2FtsS6/TCE8Za0m4VnpAZziaGuK4cd+er5ShojODslGMYxU0SdGPgmXBqdkOdrqA86XwMOxkCy9730JsQjZvWRvutz2hk10VZ4TLWmJEBlsa00RMrqUQbs/0uvANny6e7a7ZVOa3KpmXR5eBBgURWO4gvinrtYj6Oz/UHaMEESrowmJM3/OD6oyP+XF9TBUxcHjHjk53NPTvy/gGhinRwmQ/GMY9aCR3Pd0+scNaVDPFgvNMTl/uRKBG3/tIfQKKUTSBt33xnRWKGXKTiyb/GXbKiKMpt8maM++f7SBLEteYhPzKvga8Vqf88TB7KZyExVNoQwJJC7BwFIZ2bo8vT7TeWrrhPFvSYN7IE1RLxrTkmuc3J0nfSBUTzh11/39VrFNdv5oy1os//MAcK7Z04Rp7GPTibTKWjXNMFsqZJh8l4dpzxGitTMWiOtVgyBRkxTccgS/8i2X7Uq+vi4Iy5GIgXCqjj73OK0NRN4i1Hegcgbl7yUnBkhXQ3xqHE/8d7/08vj0ntBW3uKjOULWCSUgZSyiq4DDOb0oVXbJ/bSJ763/aW6nA1SpHTUlcknf1/7JccR90q0AWhS9lUJiH45vwAgOQmzpx9T3egu6nXHoj
 iwP50No9
 kSPdvxqYbzi6qTsEi75g29RUSSDRWlddG0KM4e2vl9p12EFLn+s8O5tdMsMsgkPVUo4Wl3KuyXJjkehAm34QGLl/fzU7/npxb81uHrFdxqBrT6Cd8GrW1y8MTiDeftbbyRZcspoBzaMO+Zm0eaA94taR2CUhPOQpxlmqaUraNqqgtk1afjt6Vyyjg7cFfAH8bU8GYlRpvTn2QL5HbdtG8ffoWjmXye0Eyh/FwN236H8VBzXCbl13DVgdevNH+O+6jh2nCi/aqo5DiShPLH5sWLe2mrjoZQq2HewHcCo2JcHuOYvOvlWLVm6XBMVMd8cgMiUI+cRtrWO5o3TOgzlmXEpfas4pDOt8ReJhY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

All three variants of paging_init() on MIPS are wrappers for
pagetable_init().

Instead of having three identical wrappers, call pagetable_init() directly
from setup_arch() and remove the unnecessary paging_init() functions.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/mips/include/asm/pgalloc.h  | 2 --
 arch/mips/include/asm/pgtable.h  | 2 +-
 arch/mips/kernel/setup.c         | 4 ++--
 arch/mips/loongson64/numa.c      | 5 -----
 arch/mips/mm/init.c              | 5 -----
 arch/mips/sgi-ip27/ip27-memory.c | 5 -----
 6 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 7a04381efa0b..6efd4a58bf10 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -101,6 +101,4 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-extern void pagetable_init(void);
-
 #endif /* _ASM_PGALLOC_H */
diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index 9c06a612d33a..fa7b935f947c 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -56,7 +56,7 @@ extern unsigned long zero_page_mask;
 	(virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) & zero_page_mask))))
 #define __HAVE_COLOR_ZERO_PAGE
 
-extern void paging_init(void);
+extern void pagetable_init(void);
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index d36d89d01fa4..7622aad0f0b3 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -614,7 +614,7 @@ static void __init bootcmdline_init(void)
  * kernel but generic memory management system is still entirely uninitialized.
  *
  *  o bootmem_init()
- *  o paging_init()
+ *  o pagetable_init()
  *  o dma_contiguous_reserve()
  *
  * At this stage the bootmem allocator is ready to use.
@@ -778,7 +778,7 @@ void __init setup_arch(char **cmdline_p)
 	prefill_possible_map();
 
 	cpu_cache_init();
-	paging_init();
+	pagetable_init();
 
 	memblock_dump_all();
 
diff --git a/arch/mips/loongson64/numa.c b/arch/mips/loongson64/numa.c
index 2cd95020df08..16ffb32cca50 100644
--- a/arch/mips/loongson64/numa.c
+++ b/arch/mips/loongson64/numa.c
@@ -160,11 +160,6 @@ void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 }
 
-void __init paging_init(void)
-{
-	pagetable_init();
-}
-
 /* All PCI device belongs to logical Node-0 */
 int pcibus_to_node(struct pci_bus *bus)
 {
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index c479c42141c3..cd04200d0573 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -415,11 +415,6 @@ void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 #endif
 }
 
-void __init paging_init(void)
-{
-	pagetable_init();
-}
-
 #ifdef CONFIG_64BIT
 static struct kcore_list kcore_kseg0;
 #endif
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index 082651facf4f..4317f5ae1fd1 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -410,8 +410,3 @@ void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 }
-
-void __init paging_init(void)
-{
-	pagetable_init();
-}
-- 
2.51.0


