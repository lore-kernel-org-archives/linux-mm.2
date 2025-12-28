Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFF5E92724
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B776B0093; Sun, 28 Dec 2025 07:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966126B0095; Sun, 28 Dec 2025 07:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868CD6B0096; Sun, 28 Dec 2025 07:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73F906B0093
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:41:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16196188C54
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:22 +0000 (UTC)
X-FDA: 84268840404.13.51FD0AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 606E140004
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cnFF8D+y;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925680; a=rsa-sha256;
	cv=none;
	b=g65J1x6NNbj07CoVVMv8DnTPmBgUckA4oMeQoXoOGOtiC7DGnPW5CsdHu0b7tM3XGTxUZK
	GpGpAp7fFI9oUZPVFp9Wo6Apcl7u3seZkaygt86gZBd4ipGlB356IilcC4Fv5bEPotbZ00
	3ggVDDOvUwlUed0gNkkgzuLZTJrRG84=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cnFF8D+y;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXj0Z2NgAtnlunEa9AvDDLLh6y0q3hS/njeAcboUK1o=;
	b=VinsXsxqReoDjEihin1EBEASDucblXGJhYW6LZbUud8ZcGe17YoVBSuiMbavN/0Qm6q+Uw
	2LzBJgERHUJvyvtj5G0Pr+nd+XjYnfjb3L2EJAkGF2esaBljvQOjBWZZlNkVyYiq7gbTcJ
	XRvLzcsgxs2EMRpqVirf9I+pBqc2Edw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B1EC40E20;
	Sun, 28 Dec 2025 12:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF3EC16AAE;
	Sun, 28 Dec 2025 12:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925679;
	bh=djQarGwsnsMGImsgSQVJ5sD5jo+ZigjiDeQZakHIJZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnFF8D+y5gEh9w2QuJR83XMdbXSjXAklg3EQgCL1XvXDAGgxiYyJJ66WbBKyqdzb8
	 dcyzX70MvM4Q6Cd45SRj2nfZpZjaj9QgrnQH66vqPkpxUq4Vs1/VDh58aAfkC/+PZ1
	 /Anha5l4LkVcIDBp+xKPIoYndtqWDvTZ2ZAjBmEa3RGusip9SNeC3ZO1qFpe3g9gJH
	 hZqzEJrBRCRd8FsbOjS0j9dekuwPf3R4VjAZ8gf36RaKFnfmQA547CQZs5Ze2ZXiLG
	 UY+neOi/lhd6frDKiGf18Qa10nRCydhK6Rgzaarmp/8fpoVSYTEOeKTAGwqh+nRUWu
	 Q264AvWO/nLOQ==
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
Subject: [PATCH 04/28] arm64: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:34 +0200
Message-ID: <20251228124001.3624742-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 606E140004
X-Rspamd-Server: rspam04
X-Stat-Signature: uq9s9kakynbc65k64iqata8uyd5bxn5n
X-HE-Tag: 1766925680-116873
X-HE-Meta: U2FsdGVkX19XD0zaGBFHOZnlF0Jg+kI0WfWh/aWIpbOTzAH6A0lNl1RXjA3D8ZrBYLLjytPlfdqaqd9x5LLBaqSud4VhcTKlN36pZ4b7GYYIuNhI3FPCZ9k7idz9R8685zmONAbMXx1foM+fYNxITmtLd8AcujEtkq82yoSXab5bAaEcLoBmAaCCBE9wUR0tciUOoS6RbaLzYNsC6plONuhu4n3HgV2ssZUBs2yiNmi4zb6VtEJbQs7ECnhr8T5ycFGZBF8DGA+jSvTMn4XOSd4Ms7a3GJ+6CWLAS0WY0jLVWex/j7tHLYtc1zg5ZFxjYqJ541fUQreLOZMciAX3MQVhr/3mjhhk69U+KvKIWyAEW2tAH6NPPqN0mmRhz/7Zfnm//pkfnOSODHxVzm5UloZEx3W6/DBkQwcPsey+NFHtKX/4VwK8TB9JY5hdQQNmRNdwaaKqBgm6TyLDmh0dtJbnXomFWwDyvMZ4Lhd4162sd1/PfXfH3xBYKUTHKJHljEgG2jmbJXIbxpyS5QpIJqL2INBvsHlgzdO3jWzB1B9fML9iNsxbxuhaT0dLq/6okwU6JojcyYaWx4RYYm+GkXzUlp/fxXgrD3yxnmgmCjAo6S1zIxFGWrvtU6Lklma9BJ3vm2yQBDITIPswkp7GhRXgi5mbkQ16iyHQyRGetHVEFxi04pKxVg89DyXba318/aH04/8wJLIKFwaLlG7At6SmvJ6NI3Mzulmyt/q0cbd5gMsbiMpN8igJ7ldxvZT935kAMkrDFKslveCEibJ2BGedEMtQsoU7EC4pGBCpAjERO+urapzZxD/mByWdE0O2mHpF3v9xF6qN++JgaziR2m4tLpI4W4NtoeekimttPypgxlAjA54u+UFlLuX+XAvbplGREehoYrGVGfViPJJZd5TALDnhER9bJcACE6RuVcJHrIKuBpQM5tP3j7YkrMgm6ljI07sXvqplYzP2kXb
 WjcgAFdz
 UxaDOsfZZ8aneTM5hWvvusOBIf46DpV5I8adfEqVQMQYxHFoaBuoshKhdX+g1Xb2ELqOvmvauYzEpWMz5eTfHJF74TvW23v20dwwVpjusJe775ZLCsNQZPY+JfLTRxdlETIBF3epi8gxPJghK9grkDiKTk5goHQ3Kyq5EgoEI1OsIzK2DoMlwFIJHcyXDK6i6rqvjYfLCNjVdo2/SWRDWBLCWmo8KGlydYXFVA2yvyFeg5MUGWV/pKyGXwlrGw0DkuHXa2NiCCdzUeqpZl8T9sDmu1A==
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

While on it rename zone_sizes_init() to dma_limits_init() to better
reflect what that function does.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/init.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 524d34a0e921..06815d34cc11 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -118,7 +118,21 @@ static phys_addr_t __init max_zone_phys(phys_addr_t zone_limit)
 	return min(zone_limit, memblock_end_of_DRAM() - 1) + 1;
 }
 
-static void __init zone_sizes_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	phys_addr_t __maybe_unused dma32_phys_limit =
+		max_zone_phys(DMA_BIT_MASK(32));
+
+#ifdef CONFIG_ZONE_DMA
+	max_zone_pfns[ZONE_DMA] = PFN_DOWN(max_zone_phys(zone_dma_limit));
+#endif
+#ifdef CONFIG_ZONE_DMA32
+	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
+#endif
+	max_zone_pfns[ZONE_NORMAL] = max_pfn;
+}
+
+static void __init dma_limits_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES]  = {0};
 	phys_addr_t __maybe_unused acpi_zone_dma_limit;
@@ -139,17 +153,15 @@ static void __init zone_sizes_init(void)
 	if (memblock_start_of_DRAM() < U32_MAX)
 		zone_dma_limit = min(zone_dma_limit, U32_MAX);
 	arm64_dma_phys_limit = max_zone_phys(zone_dma_limit);
-	max_zone_pfns[ZONE_DMA] = PFN_DOWN(arm64_dma_phys_limit);
 #endif
 #ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
 	if (!arm64_dma_phys_limit)
 		arm64_dma_phys_limit = dma32_phys_limit;
 #endif
 	if (!arm64_dma_phys_limit)
 		arm64_dma_phys_limit = PHYS_MASK + 1;
-	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
@@ -319,7 +331,7 @@ void __init bootmem_init(void)
 	 * done after the fixed reservations
 	 */
 	sparse_init();
-	zone_sizes_init();
+	dma_limits_init();
 
 	/*
 	 * Reserve the CMA area after arm64_dma_phys_limit was initialised.
-- 
2.51.0


