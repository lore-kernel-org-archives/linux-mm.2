Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC5DE9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1A36B00A9; Fri,  2 Jan 2026 02:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B800E6B00AB; Fri,  2 Jan 2026 02:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F536B00AC; Fri,  2 Jan 2026 02:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 998446B00A9
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:03:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C0641A86BF
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:48 +0000 (UTC)
X-FDA: 84286133736.02.BFCAC3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF3DA100006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:03:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WXMa09yB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337426; a=rsa-sha256;
	cv=none;
	b=Y1sFFeFSC214xvWx8p2d86PVkcg+uCNeGtrWuGpaNkmP/EeYtAv6tW2V1qylbBhpfD+A4N
	e/QZ8MCTWN8eVl+BaIWqXYQzuyisCnHXjdsPq0HyaSCUVRWC/FwPeUlyd3HTa/muxltZWl
	wbm+aKje2/JQk+YiKfsuL1lh3uoCrL0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WXMa09yB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zKPan3W2SiqdNPRYPzd7IYJCfxuO94gDNri2EQoJXk=;
	b=PRJ65dPDo/CCapHW8+U4lGJV9i6N9wlMMet3fCC/6n6mwdcmx8725atZxLR6CJ0XztA2uK
	bNlyHgn9b2raV6LnM2QNNc8UHWe50aNPPp6Hxt5VLrbIDC7WGk0xd3aetq4ZFqfFSLlEbw
	R3baVe6KyXC9iW6Wiw40qq/d/J1Vqc8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8AE543386;
	Fri,  2 Jan 2026 07:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC80EC116B1;
	Fri,  2 Jan 2026 07:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337425;
	bh=7cRQHQcJTxCSxc9tvl2G7dMvx0rutizHF89BihPwSeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXMa09yBg0tSjYHq9f9IeN1blNFAUX5LPbmAcZXTIcLFIhw3wDjAOleJmx/F17HYv
	 DR/XhO43ZicM0ZzN/IylLOlc6TIvzzYw30yLyImZYlnIZOkfgkXLPeKS3KmqjXhef6
	 7Xqozq3RTQUIwv95IOKdrcgqsq7QTcmppbXQJr2NFgNTpEMaAaxVrHTWJemz62cI0e
	 EI+nC09iXbdxet8WSVPNLPNmYPWpC8MthdMNGYVSvRQn8uLJUVipftJdPEOnMLgFJC
	 Ffthwjks+FE6Yu/bSgN4+CtYSegAgdS1XujRR8oHw2GikpOK4R9aMTfMNz2zM8aM6W
	 fysQUznA4UdgQ==
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
Subject: [PATCH v2 14/28] powerpc: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:50 +0200
Message-ID: <20260102070005.65328-15-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF3DA100006
X-Stat-Signature: zndexaz3rheu6h85wpwcqprgy9ke1ysz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767337426-899824
X-HE-Meta: U2FsdGVkX19dRsMZFkz28xM6Jb1dleXhgO6FWh245P3t14ofxjQE/t3gWGORSYmziocEfZfp9CacmYst79DFuyJxOXa2GXcQ40Pr2nj4on4h24kANlMB+z6Y4VqCgNHnDq8aINqoGEYKbbbAcKDRyVxcdfgqOc9G2evAU4vTsFFjlkJVQP2gRPKcT6hmaISJ16IwPw4TcjsYHmlpHHfJMjwkLQlvp1h7Lb99Ke4+KKPMloEdKHoRI5Pt6SKSE+7TmsfADFEOxFvfu9T19129ukcuWaSHSbXuy6QpZaYonjZXLGDlAZVS7cLaCHqYiRMouWdSk1p5H90Tj4vdN17ibABbcWsurIZiIDB8m9MkQ9oGnoePK/TJlBn6K2zDnJcygkYxl5ZF6oU1wIwqTV+rPPDOmn2F/17FCMsRZ5uwDiTtujcYNoS7NhC1CtXHg9qk5/4657Nog8SDyOcu74xzrYZ/8Zp3QGRWbEL8bZHZ9PJXIHRd9XAokTp8fGzdePMk915hX3EeUBvvn+BqvVM0vg4OKZybN5LEVQYNUwq9pMXn0Wr4fPTOw6hUU0DTKV8fNiWY09xQMZ4H6k0ckrVCu623uH0dec5H9oJ5Teg0UW9MwAxlsDFDYAwXofK6eN0CEvEh6JMJZsfuVKbXVpfaoZxUF6h9lERQgPtOygx1XzCZXPbaUyvGAeVhAgCUDcCnEPfbhg7wZlEHtRxa5PFhGbFFJEjusHXFu3t43bX0PwtnA/ndyLxO1g3Hf1qBCchXqG7j+4xaiLyGE0uHCsx5IzwmhLsOjqN2a4smO0Atacp3xvcFLOJJUi1HyTo1d8TkcBe9HWNVaYz+N6pLFY9O7drDix5aE089i6KsrYJjozm7VWfvWY7G9zxeO+oK2Sw0lW1GJF/safSFIUTgZbTAwwpY7RHwoe7Rv0ZRDPiOx+o6OqubemWnFHUR5o92Syi7CtbFFn9bQZmpuiuQKCI
 eC+8tWPt
 FrijzXnpM424kxgzC6zF636br2H+2zqFiOaJIb1BYHG6/apWx2kMg7TLlLbHfXUNaF0r9OaoNullyXeJAyVC0afHSR1VH+S9otqWXmuvd8B/4e6zzJ+njsMG1CxmUlbUsNb8dT9L2ZXt0j/vlNBycXI74dB8zlg45R4lBCVt9UWKC4J/JhA8M69IlYMb8pN0uKRq+ZS4hhyUPBsiveIA3oWyH34kDD8mFtEeO57cZOhY0FGsaq+GLnQEWqQNkVUU+jNoNggtEu27tLfjRe8eoCu0HLQ==
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
---
 arch/powerpc/mm/mem.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 3ddbfdbfa941..32c496bfab4f 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -221,13 +221,23 @@ static int __init mark_nonram_nosave(void)
  * anyway) will take a first dip into ZONE_NORMAL and get otherwise served by
  * ZONE_DMA.
  */
-static unsigned long max_zone_pfns[MAX_NR_ZONES];
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+#ifdef CONFIG_ZONE_DMA
+	max_zone_pfns[ZONE_DMA]	= min(zone_dma_limit, max_low_pfn - 1) + 1;
+#endif
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#endif
+}
 
 /*
  * paging_init() sets up the page tables - in fact we've already done this.
  */
 void __init paging_init(void)
 {
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	unsigned long long total_ram = memblock_phys_mem_size();
 	phys_addr_t top_of_ram = memblock_end_of_DRAM();
 	int zone_dma_bits;
@@ -259,15 +269,7 @@ void __init paging_init(void)
 
 	zone_dma_limit = DMA_BIT_MASK(zone_dma_bits);
 
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn,
-				      1UL << (zone_dma_bits - PAGE_SHIFT));
-#endif
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
-#endif
-
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 
 	mark_nonram_nosave();
-- 
2.51.0


