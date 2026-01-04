Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51763C2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 12:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8856D6B0092; Sun,  4 Jan 2026 07:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832D46B0093; Sun,  4 Jan 2026 07:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E08B6B0095; Sun,  4 Jan 2026 07:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFAF6B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:02:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B457414090D
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:02:06 +0000 (UTC)
X-FDA: 84294143052.04.90E5D82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0C6F140002
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:02:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=INT0kxBN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767528125; a=rsa-sha256;
	cv=none;
	b=6FkZyWX9f3D4v1RnbQsZzq2kliJAEF2USGm6vxfHC8YQjJzJ+lWEAAVl9my9HxCNO+f3zH
	P0FmJQek5Y8FtUeWi2cyKRg4Rvfd9jPslPpyQ3p6CQ7To7UkM0mLylAGYSRkdjNOpXtpyv
	5FcExuMGvNy3kL4XEOMa893asK655B4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=INT0kxBN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767528125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CFQ5srPeWoqo1JSWCS2nyReDQiTWkIfIDjv/mL7ZvY=;
	b=qDEwYW1Oalyk5CurhZ0V3lIA/enoDwAscONE5ggkHP9kVp+cn3V/C7yY4fzGJmOpYsPW3O
	jQfA0dmssYsO0d90r/LgRkG68tZfwZoMi03WgnTOPN/m+hTpgnTd2SsBqd1hboYbsPAHFY
	5gwnkVQCEzF+9gioTdxGdZmS4miW0UM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B443941990;
	Sun,  4 Jan 2026 12:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE4C4CEF7;
	Sun,  4 Jan 2026 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767528123;
	bh=4sa1iSi4oDg5XKMoz/YTQfrnb1djTAsHN5WmWDd4u+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=INT0kxBNHgbBEXAA8WBKHyCuHkaVMGgpladnOebfsTa2yzQEYV4mt1yJlN1PwnUNz
	 G4VwNDd1qyIbSlxRqbG31MW/aCW0NgYeMa2AQOcXg9gdLQ2vLQ8cpLRs/OvRLxPgLM
	 zrYw+rbOt3/ZgtPyhC+4awQoJA3/jIoNRc6jn+AQvMSMdpvmZk0yDmwOEIirlcn6Fk
	 MRm98b/tsfvPN/LkKJNqg07jtHRl5wM8VTQcUWaDc+iUxs0zzTGNhqOtNPkcd9CZqU
	 27IV33yAMIJYJGbt3gk6IFngZkbX6GD6/FqDbQgyLW1/3NDufvpgxz5xhJM1ESJUtq
	 0kvgqRIhU453Q==
Date: Sun, 4 Jan 2026 14:01:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Klara Modin <klarasmodin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
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
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH 3.5] arm: make initialization of zero page independent of the
 memory map (was Re: [PATCH v2 22/28] arch, mm: consolidate initialization of
 nodes, zones and memory map)
Message-ID: <aVpWpLV4Dut5Muo2@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-23-rppt@kernel.org>
 <aVhN2NgQEKe0yzva@soda.int.kasm.eu>
 <aVll339wim7dCIaQ@kernel.org>
 <aVlwOyicOLPB9SOa@parmesan.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVlwOyicOLPB9SOa@parmesan.int.kasm.eu>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C6F140002
X-Stat-Signature: aqeeoo9p5gyrbwwp36wjmk948i9ryicd
X-Rspam-User: 
X-HE-Tag: 1767528124-53429
X-HE-Meta: U2FsdGVkX189VVXb8Sa/x/xNHM7D1xrrnP3rqPbjas9I4WbTJnwp1aML4LINKyOP7X3MB7xCoAEbB7DvtEyT4Gp7JUet2QZBKIv5foMtmUUOvS/nlD1EDVDnusGxvx1XccUJvQNVFtXVnYZV/miVVVcUY6ZHYMZgX8jB8WnTwamp0SM4fzNhEhOuMoz/Sxtd3DB48LBc6CEerIsMRIaR+/HAa+6fDDX8GRIE4zH+yE6SQ9hI+b/wTUvjihD3DvHQ/e509V0Ht87hLoJe45emICtSNmJGjLXq6g+ftV83n/TzA8/R2EiQssJOvjC0BBY7QGGYAyHXlKcRJrOQsxcgGgpbAKTsOxAy1pG0IRnxDZdk9nEFfsjC1V9ykgrIGHc5jLSTc0A4zBFZpnD5mf3wMGFROvhAFUZhR1Fw5mlpE4jxn/6HoUh/BGLgo4J6Hz9WZQ5aRWeYoFs6aSylRUhMNNVVrOzhmxyEDwiStctplWANLzWqlrAhfs1pJHdpsJ9pfNNrjYfeZmLEQlbn2GsQkDfReBaohPOpg0ZZCYdRm3N96hz14jmHiXj4SerPPucu33AQGr+kdbRDaT7+PBcWO653ECX17vZ7owCkUduFKj6FM4GczOHNKOyC4X5S2Il8iG+r9rTg2HhIlNh7TVwNE9sp89zHudfaMLqe9JNnc71FJt3FclSdBq5tsc6fK/j1DL0Smx3Ii81OVDudiipC/mNE4IxnSIl0sMy7p4TwD8NLxREF3SJJZYqps2s/qPw67LF9EWhLx64QBnFL7pK55SNHZXoE6CObVFf2Dplpzpdo2774G2iiAW8LD90auNa3B64uh8jhdF1rykjo9avwuLm8o52mqBseH9CRLSdJkEsO1gPssCitmRZ+s2+3JnTFhx+jN2W9ai42FgZtHfwGzLqmluWtL7DwR+lccApYwSi7GyHIpWnchy3GEVfz9z0BnNVW527XyXGp1ReaTij
 y9o8Pit3
 ofJkjmX9FCcfTTv0s/RX+knlZNJgfhrZlR4OB/3mJsfTwrSpIrIlHxpvkRYZteeNzo7Zqdhk9IN8ev9L9GAQnkbYiJd6LSKufdqt1B5PaJOTClO/ZBeUMTFCI1943sDuwqo9StEF+hzXs6Ia4ClZh0ZiMV60hWzSZdkH0XDi38dORfucF4qlZbaUYjU4FJR11iS5WiVymC5NAby40PXA5TckK1HebenP9bqd+8Yt2Y5PzJAoifEnewFamq1Uec9Q2QRRW0xg8yZcQr83rMhPxP///OWZhIYFTqex46ZZenkj2xyDMFXFw6uElISAn+6KtYfUTWqpLReaarUs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew,

Can you please stick this between patch 3 (arm: introduce
arch_zone_limits_init()) and patch 4 (arm64: introduce
arch_zone_limits_init())?

From 35d016bbf5da7c08cc5c5547c85558fc50cb63aa Mon Sep 17 00:00:00 2001
From: Klara Modin <klarasmodin@gmail.com>
Date: Sat, 3 Jan 2026 20:40:09 +0200
Subject: [PATCH] arm: make initialization of zero page independent of the
 memory map

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


