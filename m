Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E865E8FDBE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716696B00BD; Sun, 28 Dec 2025 07:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA316B00BF; Sun, 28 Dec 2025 07:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5576D6B00C0; Sun, 28 Dec 2025 07:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F43C6B00BD
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:46:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D684D13C503
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:02 +0000 (UTC)
X-FDA: 84268852164.13.0618321
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C5C44000A
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sfjQZ4Ma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925961; a=rsa-sha256;
	cv=none;
	b=4XKoI4nQHtVOb4hiMk0sbaZRdCGexyEAvRy3385b+RxJ1dnm/cF427B+V0ZEOBidwcdNjJ
	P5z2a3LNAm83FaxzrUtMsnstUso7JPhlVaZffh1UGxrY2LxOltrU/bU8KtcxJSc19sb3rd
	9ONwTDMaK1Kb6R/C09vy4jiyWfFIwRE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sfjQZ4Ma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBBKJwrcTjhhjxH1pyy/2Lv9SOwm9YyMZRAlSFGYa0Q=;
	b=M/Sikr8AdoabgZahgGaXX+LH0U18u7pZ/astfNmow6x85Uo3Sj9roUtzjP8ImFmNHNwEmD
	5/jmh9nr38uzyNQlogAUQ1j2dojAQcmzkFcJi080uv6UdyN8yFgxCXDVdk47dWzhNGe8SY
	MKwe8FdNi0TU43NEhsWkSn7GDDfv7GE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59337435FE;
	Sun, 28 Dec 2025 12:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37A8C19422;
	Sun, 28 Dec 2025 12:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925960;
	bh=zd5p0i2OlJkjqXnS1oV6Bjn1onLoj8/4tNSvugcI3Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfjQZ4MaJbYdgWueLdXcBmDVU38OdK56kgVm+DeDe8fqmqjt1fCb6ErJZO9P1rIEt
	 GRJeqLqBy0TlDwsKktTLsNK6umjRi12aUfepLg+2ZgTGR4HU1zTAT8cadFa1bbcPqk
	 Hq02jezoVzB3ovYJaouQxYn4EhXEyd4p42VaB8FalDOHjiuDHtBmE8SXFzsb3Qybvs
	 zT2EI02+yjpeL+u6PNj5jGcA5nKlMhyKwQknu5W+D7x1RuSUvncx+6LFSDf0i+7zI2
	 faRLXte7BWgSIT3A3h5I1dHTU7z2ib/JULlm1VMjgFv4M9KdIUcHy4u9xMyfE/W3EK
	 7OoAMM9Lvwh6Q==
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
Subject: [PATCH 24/28] mips: drop paging_init()
Date: Sun, 28 Dec 2025 14:39:54 +0200
Message-ID: <20251228124001.3624742-25-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C5C44000A
X-Stat-Signature: skkr9rq5sq5unp5sy56u9mwmpaks4doq
X-HE-Tag: 1766925961-436732
X-HE-Meta: U2FsdGVkX183HC3uzRCb+1whQUTe8d0Pw7Hnkoo4B3Nqs3UbaVUT8xdsNxaX3P+cs4PskBdDpttkYcN7NvexiUTJITG/eGfYTqE23QxsedYUDkqyzJYEtlUcmYJprvhUspzi/V7F8mXm71Kc7IRCFaATKVHx6BIblnhdTT4Wq30dDFwGW795FCIsZRo11SFoIORFXtZktNyF8ZYrctBAh7Tk1jRUbZ8IzK8FgBsDIaVJ6BXTJ7bIPj0rBrAd3S7nkMQO9TG+QqxtGnvlk9KRWzKwsiUc/VAQVrpNrNoe6DmdBU9VnHownMkmCJXOSnb/czLu0+kTg02LsBTstBIuWbAcxj7PubeqQs74jlzkQONHg5eiLTErcixU2N6TIm916LxePFrJVeWFv9bKdXIUvHIQ8hP/GUOFGChzD01agXYhYAfmtsoNelbdJ4JGa1cn+UfUXFR+2nI/5MhiHtqym3bc73PN4pbyE4vCUnayymrHcflkAYdw1MeqXZJdq5AVKttlVe4FLnM8F+FciAhwUVPOyxVkzwlrC/aECf+YXGmyBI/HNl7J8no7uoTFXWczMzbf/SkHsxMnFITJI0Z6k46F06P+sbefxoz2kQi2sl8TMTb+/jJ/kgNpjZa7/dMHYnAcL0/F0RmasSs2Srn1jFy3IJqz5mRYixPUcq1Yx0cylazGXyaf2vDeToeqP5JEnjkCD/cL+vyoCg3vFKwEfaonEoWCKKwqgcn9S9bo1Bk8v2uK1JN4uLPrTw0DTXaCEfBwOi/ZRaY7u+qQNfcAbHjtu3v2FXWA5ahLt9sfrG/b25YcggUWyGy6rV7XuJoU83gwPGR/tIq1kRUsSRdzFuNpt0F/uVuzcAatfYuaSUJyqspxi+h1Xq5dfgCz6dMyIaN/nim6TfMNKZCdDXTeQw1XDkKuTZVZqT6I0pRb3U3WWQMR5tu8pPbJtZhQ6ottgGXU2+Gsmc4yOSCR0Dy
 2ugzpkX6
 OxbpXY3rvE2l0HeI=
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


