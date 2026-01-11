Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EEED25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98F86B00AD; Sun, 11 Jan 2026 03:25:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70136B00AE; Sun, 11 Jan 2026 03:25:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C816B00AF; Sun, 11 Jan 2026 03:25:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B748F6B00AD
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:25:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85F155882F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:13 +0000 (UTC)
X-FDA: 84318998106.03.AFF4ABF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4EA6A0011
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:25:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJT6JCU7;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/l0u3Hxe5VmGHjW0jp1QC8gVmA78/lu+jqaojRNk7Q=;
	b=EUwcl3j9zN6ti5Wc+IsWfAN1X6Jrw1HBoJdyQc8Z06A2N0CaitCcO+GhdJDjruQircfKPQ
	/XBry7QHSHLD5qph/nVPyrlvUt+po7qM2DuBFfEf2qWolLstDRjAooj4BSH8E4kdnnStqz
	ZxS1eCEf5GcBaSZPpt0vgJR9MMeZQ2s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJT6JCU7;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119912; a=rsa-sha256;
	cv=none;
	b=Y9uJsS4EAj0IfHiQSCNuiNr8+JLYMUMKqrHdRevaMeBmC8KySWLgpWtUCeP0EMeGYKoKrZ
	u17NzDrkSFzewsHYxkXmIhQg/NX2ED65bpPMd1bwsJ9LJJdMOkp4h56lJxgLTvuroD0Y5w
	FMwNI8BO/TU54UvDqf2J5vD4tuWpGJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B72CD40D98;
	Sun, 11 Jan 2026 08:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F417AC4CEF7;
	Sun, 11 Jan 2026 08:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119910;
	bh=XLJkxze/zRljNiS2gjyXo20G7bby5TmrPlX4304F60E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJT6JCU7l1lxqyEUTX5FYSwW/ezRfbB5BhOsON2tIsFgcB6KzvRLR+VnOfjUnNUli
	 1Df8EMUsXpuMWNMEAA9p52WCryPzuB9RbNl4/dSrDVNn62F060YueIkx8RUqzMLl6f
	 BhWB9bOPubZIrl7G5M3hr3fwWW14Tf1pPvDElI9X6i/zDAFVSfmNKdnay9gRKvt/PL
	 Xp0l0kOl1v0LyjjDmg+r8L2t3wr9KtSAMNHGmCC+QweHEL3NWWYl1TRj4kT+Dh+ak9
	 au2MTE1nA096UC962hgd53ExdFcUsGJJZA+dyB8GHK3x3h15Sno3iINFa4dPcVEyf+
	 kN9pkH6svLtFQ==
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
Subject: [PATCH v3 15/29] powerpc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:49 +0200
Message-ID: <20260111082105.290734-16-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sprnis3axqy57wfrfsjod1wwij1q8q7u
X-Rspam-User: 
X-Rspamd-Queue-Id: C4EA6A0011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768119911-850902
X-HE-Meta: U2FsdGVkX1+ZHB/ianx+3HwxH1F8nXO1dlDu9cWIzAQ0a95OXhYilodbTFXrmJRivVglE/j9tbsTZZ+wn4FitqumJmjkIMeyKiLWG+P4dgGO+c4WKv9VZnEGxHTRoK8IGAMRZ52Gp0irBd+QRQFzmtVYCTe9tBtl2jQSAzUmNv9BHBnVL7VXKPtlZbpKBYzykBo1YWWQVeleK24kWsKKlhiYbn88z77WYYFhFk87yIBOwzFvpYaa+YTryQdhZ/vstuBXIFHW7VxZ2LBZXsfm2Q+CWw4YMNKAdiI/XDIIUZ+ZyZwg3g4OM2QKRV1XNUHwAjArJHiQDPhaH46rYaBjVyGLt8LH+BGjNXlXYH+OR154cBo5E8GL/9DVHMsPe+uWFL3rr2YGd+J913y4IJ+nMjvIPC6exP6i9IXnuxf1aLObmOXC66C97g5UHUgCvfGKnEVqPMadLvMicZ2SPvS0OBiWvh/E7ErsezcVoAv91avZK8J47M+mkLWbxN0Bb8LHJU2OIu5V8rWLUbyT1rKKklEy+OXgQ7P5jzPxZtWHu7/t8HTLs1IN1qiqxnuDzK9PhODZxk/SvG+8oHBNql7P0yV75dcnJGUNrFKMjZDfOVn9aGIXamf24fusK/vIf+Mjt4Z/UGiFbiHx3Siv9KkoIfhJqPF57rB672+lwFs34vU7K5w0miWOutIS4jAskCRfVoUhSduiOHau0gVPFmWYBrz6JAu6PMWGjsoXs+6c8bDkVZh4oSqXcOkN1f5XlgsNglRRUylaSs3hCxYN+Bgue0DKhQp4+LSQmuyk26q4FqeS7g1cm/+uDtWhrAGS5w/wKySo21k03n1nz6TUS4Yyx6OCMBhXrRBERya0XOIozs9X8LrbzQe0lHUd/DTTkyjpQcXTZ4smAHUUxAAMyESPwzHXPHp7AsOmpylCd3mK+/DHOpTNOWkp8hEMYjCLlX25irNTdf/Yf3ZP+rs1rQ/
 pkZvkLGB
 cmHYghT1GEwgnq8W3Q5muLIurfyeLpnIODNhD4RHT/+SSsODvKk2ZE2hbZ12c9CkNSdVj6mAvHJhDE/h8ppEHKiZeVHdGfRHM5bpsfzLyIC8XyV32F34iA83XKJWz5XvB2qJgVexOCXN9ZZEN3jg8czH0gCPKyZ/AI2+ENgnCFzCvbsXjSn4+I9xnSGwHTHryavpRozuU7aFFPhHcugbJXJiDlbLwTBYpKgkv8S882wtJmUR0GmtxeXV2Se18p/5XxEVB9aV2Z90qWpPHDO4dNiQvoM4jyzTipLAAzKPivnm+mPzoSszgeHslMq5cNuaBMIjpBd5it0IzQ7noPHNlCEc1p91bHb8MEY/A
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
index 3ddbfdbfa941..03c05ec56041 100644
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
+	max_zone_pfns[ZONE_DMA] = min((zone_dma_limit >> PAGE_SHIFT) + 1, max_low_pfn);
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
+	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0 };
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


