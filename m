Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B9DEEEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01226B00BB; Fri,  2 Jan 2026 02:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8EA6B00BD; Fri,  2 Jan 2026 02:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0F26B00BE; Fri,  2 Jan 2026 02:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79AF96B00BB
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:06:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A1D61B13B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:06:12 +0000 (UTC)
X-FDA: 84286139784.16.AF43ED3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8642120005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:06:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k6xIa9pj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337570; a=rsa-sha256;
	cv=none;
	b=DEQqHTUFjjkDRZiF2eWyuyVFkDJ88HRziG40Z6Saodi5Nt7fulTdL61rSU+BSxE4dihQu2
	dUOjYc/lx9eDtZsAAeVHlF/dEwxQPE90t1GtZR8+yCcIMVJRTIa9SsoL3XdfcPQn9P4fdr
	FK8f+6v2vtOi9Pcq0IdQmVszo8boCrU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k6xIa9pj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBBKJwrcTjhhjxH1pyy/2Lv9SOwm9YyMZRAlSFGYa0Q=;
	b=Be7BrcRobdPRV+ckXo+m3hscs6lJteJ3BVZBvMzBa4i3j7x0lNfyWFHCqjVmqWow2mw9wW
	hbeEKKn5KByrzLW2vEUHpak/7Sx7hD0OCPO9iyrOP7zui7GaLhlN47dB5KC82ST7zJPpM9
	xdoxVjce1wp8K7ZQDVy5WMJHl6EXbxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EA8660125;
	Fri,  2 Jan 2026 07:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B65C19421;
	Fri,  2 Jan 2026 07:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337569;
	bh=zd5p0i2OlJkjqXnS1oV6Bjn1onLoj8/4tNSvugcI3Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6xIa9pjCtCSQ4MEY+klZMN3iRgZ985DjHASz2H4MKg2hd8RyCy922ngxS24iE1lw
	 8P8/5PYe1x3bAWaZCcScML67yT9rLEFUsV4COtpPUYwhUDsh+Jn/3cpYJLBBz+DHhE
	 dnw5dCuK3w+PlKe3tcLhKB1Ah7GScwDoOQXRdR2a4IoOOdgHS5iZ3wQVGgBX9yWIxi
	 iupTebDm+mgtGPSdC9FeNmiOce5WvnUQQLf//vlDxlPesb9MjTzIKZKEzZMDAGEFoY
	 3xR/SS0Jb2B13/a41swfwUi0Ki7LdZABivWX4zFEM6qL/M4y89OMdP11qiGgSZEtlk
	 Mg9pvdj/PlvtA==
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
Subject: [PATCH v2 24/28] mips: drop paging_init()
Date: Fri,  2 Jan 2026 09:00:00 +0200
Message-ID: <20260102070005.65328-25-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8642120005
X-Stat-Signature: onofa67yuqsdy3r5g5nastptqaous9ix
X-Rspam-User: 
X-HE-Tag: 1767337570-748123
X-HE-Meta: U2FsdGVkX18BziLbeBCf4ExhBUPl/biLEDudPNiGy46oiCrI196xtCaLlQDX62C54x8ux1HXpGY8/nDWDy2jO//NFBg9+flIkEyAqYtXbLcKgfa92TdW+J6pHndVNEbDVrGpnThJhwwt12WA9OwRtADVWNHOpe/UY7hVmG59SmQ16IC9JYTsXRMTnYoYtehSN1qUgGjp705tZcXKFCN5wDqEL5cjenw4KjaILeZx6j1PBk7sCwmLiEr3lBOpaRC/XctcBUmIj9MHE7JgfamyzGWGMNDLiLPkmHfZMtyHRF/2T/6/g5pYgoOU2mBXAYJb+pnm2rjpa8XcJMCCshcDrnDKonW9wPH/eqi7/pBaClVsn+DoQdINjKkb+HgNYpOCYB4KyMsg6BGZV/R7r0yJe+jRQfjcF0CQXTv21SHLcJ3TPbe9Ok87amuVjw0AAnm+yqq8VjWZJAMhVujtNbg3zgy7MxAtbpMuIX2X8i2kgqSEOCoZ+fH4Bm+n8egdvyjD3MdGvsbXrK6mLnP+JU0r6XeFuuxKiPQMx6D0PMYkR9l9AL8A81EA89cy0uloaW81IvIQYEAT7f5m7wqJI0SyH3NVEzZXe6PmWFDyz2UC4mrkMFrvAqQIjDg6tB13S/dbHOwOSpGnmBghTHE3OTgk5CsCsa9VcFzET2J9IGeE5NoGmcqYmfS+od5MYcxojgfGQIu30zBJ6SJL21sGTO149OYqE3AdDRrD5J+n3Kef8itPuwd5LbLX6Q3XgbGu45a31ffaqT3M0cpYreeWgDC7DVpHaZ7Zt5OrVFX8WljD/cmBttnbRvU9PgabKAw+eGwDRAUTWRkQnCy3VYEN1JNEWQAb5fi0JcqCCGhrSS0qqyJIo25XMArKbuMqMGAppCvg3qfrE+H2pcet7er23OsKtxYovBH28l+f6+KYTrAXsbNCBvpWe/P58gPqKhKsWoQUbATdHh7XDyjkWCr0f0s
 yWrxmnjw
 EuLGY
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


