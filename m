Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D076E9272A
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A709D6B00AA; Sun, 28 Dec 2025 07:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27716B00AC; Sun, 28 Dec 2025 07:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951196B00AD; Sun, 28 Dec 2025 07:43:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85F3A6B00AA
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:43:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C94E188E78
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:42 +0000 (UTC)
X-FDA: 84268846284.24.0AD3994
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0F0FC0002
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:43:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LP6Pi7q2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925820; a=rsa-sha256;
	cv=none;
	b=1MW2VZuUpi/I655/V+Xq2bca8ZXpreALyU3fPSBeEI/Z3GaznirR91GA/J5yjUh5XlgAQi
	v28Lgaz7iXh5WBlBPedHuVCUwXbT7qiUrntwkqLTd6JUDVx8eQOQ3T1qtNa6EPe9zRDN9h
	LaQEflhC8IBY4d2FXZyRc1StADAFYK4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LP6Pi7q2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zKPan3W2SiqdNPRYPzd7IYJCfxuO94gDNri2EQoJXk=;
	b=yAppVNl5AAOKQDZGA9IXHXHg3ZgwcWGwY+LRdjZmxMK1zr9SQ8LJ9UHmBCDWEhLtitaWWS
	xY/DeiTqe950b8SjR1b6kNr0jT2Vi4g6GbvTekow3xSN0LnSucBvF2RhY9yKUDVTZWnUAH
	yjKT1P+x182zhvmdpL6WGgnUCcB/ufw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 260F360121;
	Sun, 28 Dec 2025 12:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7F4C4CEFB;
	Sun, 28 Dec 2025 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925819;
	bh=7cRQHQcJTxCSxc9tvl2G7dMvx0rutizHF89BihPwSeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP6Pi7q2igL6PUSX6cq6nr/WZsu2Wb13tJjQ5VlJAGAwLsN9O3iS/edLWoCMW++IP
	 pXmDirq5lPXQLWTWgnKn217//jKO0KdDGFYlWEeT4DKKzQvEQsSAwso468aZvXfDvZ
	 EElsZFcEk7O4YNQTlL0LdCSltf5xVBIifCpETvyNO6S1s+ag4AAjAPXbIzaYDmhp3y
	 eMBhBignxwcNwEskwkSoCFgd479kIB5Fd5n2rm1759zPplZ1aQkf3qL1UCGavX8r0h
	 fcaDmc0VHvF551YRkgh7ytcKd5BKvje5v4AUVoTvEInEZvhAq1WSt2HB3WG/kuS6iL
	 2/MXl0roCRhPQ==
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
Subject: [PATCH 14/28] powerpc: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:44 +0200
Message-ID: <20251228124001.3624742-15-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0F0FC0002
X-Stat-Signature: 5m4rs4684o86ub4gkaink9ytnbgoehim
X-Rspam-User: 
X-HE-Tag: 1766925820-89883
X-HE-Meta: U2FsdGVkX188M9ONA2bP/j4tW3dm+W8eiUFbaT6DjVEquJGiTDuL2oAXkVhvRy0WiSn+JYqlC58dQtonCgFLqWhCVDj/ZgFuBWn83M1frmKyH2XH9dUEXxlIk9g9psEO2nr4kOCqZh4MinEzXciSWKmYTqtgmQwHtL7fsAjvAq1hepczqtU30g1S//F0wDgd2261zeIk8yddXYe1lKiSFgbavwQ0T0m/r/khRL9Sa7myUalSDQgd0eY+ektuBsnDWubAYv03uWBnxct8/v1AyAt80IhZUAGdLnbYfp08NuwnziWyT4DjGYCRukzfVAGM07+Fo4g1rxTK3YcUIpKqZB2Kf9CmBZsecFGefACeyraz50AFsCFQu2N8rldlWq0xWDBbmeuxO5ku3UNPD5FR6r0vZ9rGjBRh3dfy9UInzGmMXFNYq1QI4YopjMbVkXPBGf6oO7+u+rCLv26rAlIKJJ35ykl9ituaeRmPMhNL5yvKVHppTc66l9wpp1HeUIY9WqCjMqFBKln5bFIl2xByKNFcD8ID5janYoXN14Nq7LXHdHQJttWnpIe2WZ6/hk2lnFgV1811VMEpg8cQeaaNy54sjBR7BJhfMUQGkoBczNAZiZrJcDSx/dCmdjFh+spIrmcMCBdvXhS+R+dp3Zp7eo+mDL7Z8ocjfN1uuD50oTBTkUrFjoWO6A4VCjZXRMg43JVb1OwHidxeKz5scv37jGcsKvqu9LaojSyzdHZoJb8HhP62vVebtW+U0bHlRaR2EOYdp/tXRUXbaQkGmikBorGNL6fsL/uvKYj64XPlp/nZi56L5LaJxjs7tDi/hLvIBikk6vzh4/q+fcLfkAovE5zOE+DytyRCuSGTWI3fMmr3FWXXN8y4xSEFKply5Tp3hXRf6JuqOwFUYmR/MtwQWYCgAoVVpnmRzcJj7aVqpRX0GKeCw1MoyrSKUvSQq/tuJnlejeJUuLo4dkfl36/
 fgUXaAH+
 jvpQYsD75TW1z0K7w95CjNTG1J0M0CrIQe3yW7E5FIuagpVcZ3RBhY2ur/mWIdelLqRkhgXV0XNCK1aFbuxZxTX5A6sdqf3zurgn+4dN7fIa9DgihxiXDBe7GkQwgkK2tk40Ka6yomTCq1k77wN2jGqG1+0gM6Y9E55JyPwrlCPNXQZjexLrukUZ9eHZuKREmzdR7jtCb/CIgHXsLnG9kAIJm+VOCubuX+BfhnWifvHlaE7hfEusQgzrZC7Z6Wo5yUKa3Zcg6ld2oFu2vDLsAbIVMig==
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


