Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7128D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17ACA6B0089; Sun, 11 Jan 2026 03:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13BE96B008A; Sun, 11 Jan 2026 03:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0287D6B008C; Sun, 11 Jan 2026 03:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E744B6B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:21:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 711531603A7
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:21:41 +0000 (UTC)
X-FDA: 84318989202.23.FBCB21C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 11638140003
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:21:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKsFfy4h;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119700; a=rsa-sha256;
	cv=none;
	b=w4I7lutSnyvhznVqubjqKuG3I6JELzc1HhmL4Uz8a26cdmjpnVUJ+XBvV9uxtALxLtaic2
	t4bFf1MImpbRiwzZcML0b2T6u7JovvE5YNIdDt1tcIxGad14huwJQAcnjhxtdlKGWdl0CI
	gA0KigBEZMlUrfbso33sm+zm9mFmX0I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKsFfy4h;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMSeghU9mFb/iSGNjAJ2/WETrT3nayTRWjrK9prgUyE=;
	b=Gku2DhK1mKdwaZmCJt/6C2E7zBbG5DgfgsxpGKVXmbNlqfO23UzbQi3Iy6AygRZuFeuePi
	0uopBE1fo1VqsBVktcslNTDJU+wrDwGM6ZD11JKgf1Q+dwsBRDn4MQW4lxl6V5FI0R4HHU
	H1oIjJAZnkdDTjK8QN1wZKmTXZChTKo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2928960010;
	Sun, 11 Jan 2026 08:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F81EC19424;
	Sun, 11 Jan 2026 08:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119698;
	bh=KgO7SaOs49km6xau9XjjDmzydPHNaHbDsqRu17wGsEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKsFfy4hncm+FQF9ArIXoeLTO/v06DCp8sXjb1/J7bQiazwbZMdpHIy9QotlxdrKv
	 cKzwRylS7hXf12+BEXaXStZUkeCwmqdBGWQzJ9yqdLS95oD2cS0pSBfDrcKw/dAkej
	 56RV0+FAFYsa39zRWlT7ql3sObFpMCuLtdFkflVRr4BAKpyPWA7tvw8HwpcQSyv04q
	 jpHzxotVHj204aEr/qLLNW0xVwVegN9kaR/1lVEctSggjpdCZQ9WegpvTuhQU3MJ26
	 pU23I8xS42R0TrNytKEIX7DhURcabHaDeWfPtsCINu3tImuaarWe0Jtqcs5M33w4wE
	 HXtsM6RgI0KhQ==
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
Subject: [PATCH v3 01/29] alpha: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:35 +0200
Message-ID: <20260111082105.290734-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11638140003
X-Stat-Signature: sxigykju3e6s5p4n37unwtpusrfnubik
X-Rspam-User: 
X-HE-Tag: 1768119699-918899
X-HE-Meta: U2FsdGVkX1858CXNCpGGdSj60N90FhoUfks6jq6hCZv4hn+Eg6AY+4PJwXB3RKajXP6wcPnW5wV2EE0VnJebPiinPRX2FsjSDkGwPWdydBJy+Q6v0IHhJ3UfrFIlIjh10P/r2LutnLXVYmkGhlOKdvJG+T/lgDdosFDaq+ol58ogeNqwt7aTpzS//autiPZKA0bvI5BIuhRrpAgvkZgjFZkyqO7YID82/HxNCZOCs7r/XBaXYBpwHbNDrcat0Gew50cTe0foWiGJKrqQAKA0pHUO7YuyzJEfhtM3MYnajvcmWTXbCHv6+TeynChczEyYjEO4G8DWsoeWZRnbQcMvvxtUTenT6EIXkv8U4BBFEk7Qyq72uIc5yWFx3D+JaLdsVF1cyGGqGztW26Y9PYQVt+kATIa4m7anhG5Ow6uqW4dz7bersyrcEiohN8xiQUL8Qhw/xpIkdRjrGqdhocJhiU2LZiJGRxXBtuqycPbjJfouA+m+iXt5hfVYoV3EHcVKwK0fBKRRCSv+ZyMJhdofeVvzD7hbI1QPHUkZloJZRuMeNff92NWjA74bMJs+WuTiazp/mG3RzQtiSKUh+Cmh2w3OSdaFVDWVUdsFWukTdw8LO7lDJDcVgHlGn6H0M5mJAOTquppUlFTP+ap/26yxAbbNKvRDjZCY9Zlu7+CehBSF8HK143MekdCjknCNGBt+qaadT5Lns9rKtUT+o3CYFmjXQGXzH95tueqYqSnnNZ1drfCp6tO53LnnGQgYmPuyufIgXzdPSCkV3I+HzzWaVZJFZ/BZbWrwhk+lYS9To2lJMQwoblwA5oiIEnxJQrKxQt/rkPKXPwcmqaUQNZhboURQkOoebHUxHcDw/O2PTBD8/61hsmLE6GioB7tdYSYKMejmk+4Z16ueSG8AmHfygE8G6zoAco5gu27P8o/lok4C9bCqq6vWINhfoaIi5a4vEeCezbaMn/TxtmHW1x3
 NPoAU+Xu
 ONPOCOz5nX8aPL69Vz0lZfNBVOiNSMz1VKH1btHOca+PoK7KfXyJFrY/lWLZ30h7U1bP5MF4q5DarGxJoVDmAJEYAuUY9Mmb/T2YjeSKIaPH8qkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Move calculations of zone limits to a dedicated arch_zone_limits_init()
function.

Later MM core will use this function as an architecture specific callback
during nodes and zones initialization and thus there won't be a need to
call free_area_init() from every architecture.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
---
 arch/alpha/mm/init.c | 15 ++++++++++-----
 include/linux/mm.h   |  1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 4c5ab9cd8a0a..cd0cb1abde5f 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -208,12 +208,8 @@ callback_init(void * kernel_end)
 	return kernel_end;
 }
 
-/*
- * paging_init() sets up the memory map.
- */
-void __init paging_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 	unsigned long dma_pfn;
 
 	dma_pfn = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
@@ -221,8 +217,17 @@ void __init paging_init(void)
 
 	max_zone_pfn[ZONE_DMA] = dma_pfn;
 	max_zone_pfn[ZONE_NORMAL] = max_pfn;
+}
+
+/*
+ * paging_init() sets up the memory map.
+ */
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 
 	/* Initialize mem_map[].  */
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 
 	/* Initialize the kernel's ZERO_PGE. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..628c0e0ac313 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3552,6 +3552,7 @@ static inline unsigned long get_num_physpages(void)
  * free_area_init(max_zone_pfns);
  */
 void free_area_init(unsigned long *max_zone_pfn);
+void arch_zone_limits_init(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
-- 
2.51.0


