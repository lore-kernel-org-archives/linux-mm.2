Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE0FE9410B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54416B00AC; Fri,  2 Jan 2026 02:04:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A281F6B00AD; Fri,  2 Jan 2026 02:04:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921166B00AE; Fri,  2 Jan 2026 02:04:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82EFE6B00AC
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:04:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 122A913A99E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:17 +0000 (UTC)
X-FDA: 84286134954.23.2BAE201
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 79713140008
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzgeyCu4;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8kExoTLliZANVxlSa71PKoJV58jVF11IqoI4S/DqkA=;
	b=zz27xV/89BVVHz/7JIOw4tOKSSWbyF3LKSViI59kYeN/jOqHxOM8rXeDBLO5Hz6QgpD+is
	38AWK0gPV75+e58wD4d20+SDkEaXtkC8XiPoQB3nOnc/y29QCpDB/lZ7oNzA3YhBSOPbHT
	+6DimMumLgVlwGi3u9IpPhWTPTrStUA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzgeyCu4;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337455; a=rsa-sha256;
	cv=none;
	b=HHc6rMc5xwHXQRwJdNG1wxLBMOLSnnLJdt96QhCblzLC8Zk87clBCAYnLqCBKRueMo3nRg
	UvUJySZJv1QRLL0Fe3oHiS9e7tyW0yJpp8ZRsf69pfl9jIycC7x/dL64XIBcAqossQfjRk
	DZVTXKva8QCTZIE7DgduEekdjZCy/CQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE0CA60125;
	Fri,  2 Jan 2026 07:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9489AC116B1;
	Fri,  2 Jan 2026 07:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337454;
	bh=hFJveYfaCrIw0+iDVEP3vQL9fd/XBHyX+JYd2Rm0RhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzgeyCu4tQubrTKtvs34G1LIbvPSfWcug9h6n8ZnurA/OZo0SL4EiW+RhJfIMsVbN
	 6qs+6wI+dAhn4AXYB3TCsenNnM2pD9lgkbKN8HUEkLaTXaERBE4eH62J2otaLZPvvo
	 YfvsWRC4P7RMmakWoZYfT/7eJLOcmiZchjlXHXyJHM/9dD7DNryMUZcig74jKnnp7O
	 Eqkmozvn5OkGUKhT26ipcF9xHIodKB9ZSsrSF+gY+nHDbiWFN81dgjKg2jTAywYSyv
	 FAv2UuNc++l2TIFLmhufUSCXUdrPJ79EA9gNVdKL5ZjVooYOcrw679Uo1JZYEQHezQ
	 wesYIpKlfAIPA==
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
Subject: [PATCH v2 16/28] s390: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:52 +0200
Message-ID: <20260102070005.65328-17-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: q7es8pdi8xz56m7eyy8179kk6hwtffzr
X-Rspam-User: 
X-Rspamd-Queue-Id: 79713140008
X-HE-Tag: 1767337455-94940
X-HE-Meta: U2FsdGVkX188TSun9Dzl0XJgh+KlOYhGGc5VBJuYPPsBfIPSKDekq2hZ/KOpkmw9kPE11DRBHMCiHvVcLkw93SuMgT8NRz5SHn2TOXOSGIb2p4EuLwCWtb0t2V2VU4Uih9zPekrvRVOg6gluzH+9xQ6uK0TczKUh4bYQrSx88PGu0xMIdgE8V9OO9TctiWYBYdPcjH6LJ0IVI2cbQW04wkd1maPANcV3nJrNHiU3ZRQYhropsz4goJwXYrE6R+q6IsmYB88KzxKzuN4ZKg3B0jP/n+4azkR9ARpCJ2WMAOO8AjJMsBqgCCgfQ4epnyqTpxSQ6YQWuNxkaE9IZZ0ZiODRYb1twbcHRRHW7DNNv+XkhfI5ibEHLHZPHt/8eUUutLfMErmGpjaXkROrisc7yxSiMtslbMAQN5DZWvFmaptBV/ez3/KwbgI4kyF82xvAIjCfzretaoIJq5duJZ2e45YkIoTw06uB7fJ0x7RpiK6n6juH/tLgEtAqHOIALLZNEnHoAWIHoNU37bnz+HiRNWmeZwwxETO0JKPzJFmT14445bNyg8Iptq/CKQpZt3EyRg0OOJbWuLVASR5QSOTFnEKPzUqv6ziYmH6bhYFvC42Eo0SwB9BTXhe4jpEBF9KZkcfzzwqDQZ00dE+z9VZHm4YlfbpT7ILWsxbsrSgVoI9Iaepuar+wY8YajZaGF85h3cgskJSGr44r9WZ/z3y5cjXO/wkVqtxc2yw9Bl/DOhDUFtCxWlM9lmEJhfkChvhxx2wLRbTMc+ZAUEaznZ3aBEUvoGaYvNTEPFrHliyMY1qGu1MvqHPI+x+OliJ1iLcMj917Nn3MUs1HbLQrnirCZA234Efi8VVfEE+09H3Sqpe0LSNdoMHg+pgkvr36SowSER4ArT452rNClRGt1T7Nxa1OlF2Yb6WHyA2AvfnEDG4J46efIZ6v61cQdfhuNYVO2pyqbbQHtBfpnHqWpE6
 sjZUTZ/O
 19t1/CW5vY09W9iWl4pa5aBv9PUw5wfb0hgOYwjAyjYIhYoDcInO/FkuZ9wfsxuPreVpuUqS6fcvbUu2Cc2T1dalnAOpd1loCpNLLvb6IGiBKKdGibh7soQmYTKrcnrdOCjDnr6R0Bo9HT/FYm0JmTdgLgbojv6TFZHqJF21/Ml+BRPOPSeHPczB1fHYWXvcwzfeIzxp0mmL3DNYO6VXEIruo6qxNUZwG91muFTGmMr+p9vKygEYIlBizKdi9iY/IY5hWJ2kdiuUhZaGmYMTKNoufmw==
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
 arch/s390/mm/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index e4953453d254..1c11ad84dddb 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -86,6 +86,12 @@ static void __init setup_zero_pages(void)
 	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
 /*
  * paging_init() sets up the page tables
  */
@@ -97,8 +103,7 @@ void __init paging_init(void)
 	sparse_init();
 	zone_dma_limit = DMA_BIT_MASK(31);
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


