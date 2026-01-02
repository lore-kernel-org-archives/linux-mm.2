Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB67FA3729
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27516B0092; Fri,  2 Jan 2026 02:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2996B0093; Fri,  2 Jan 2026 02:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4F46B0095; Fri,  2 Jan 2026 02:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1376B0092
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:01:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6684258892
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:24 +0000 (UTC)
X-FDA: 84286127688.01.AF31853
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7FCCA0012
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YfFbGR66;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXj0Z2NgAtnlunEa9AvDDLLh6y0q3hS/njeAcboUK1o=;
	b=lBDyd22rGa1vbiUcMSJW7sn1GrTlYpa1ojkaO85Y9IX47ebxRVOU00X1wNxzLQM5YSwbJC
	pD31VQf5V4+FBth7pmBU0g5OiKNfau1zRTxNj3YBnbJT/dxOkQk3gUoALCHXruqdxSf5bL
	zRsK9fVVaGCidCkubu/5+TOzWaODU2w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YfFbGR66;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337283; a=rsa-sha256;
	cv=none;
	b=05c4CSDwcimZaR97gFvB+zE9SS3+vRfU0DLee/VdNFm6chdGqwHICEh3UoRGu5hWFqKhEA
	uxmvWplL34xUpMC6940m0TXnAji1le+XNUZdyHQPyycE7RWiG662euFMJwgw24POY264Xq
	FIfQmo15NwP+GwW/LHF5l9DbawWEQu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 063C7439EC;
	Fri,  2 Jan 2026 07:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E256C116B1;
	Fri,  2 Jan 2026 07:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337281;
	bh=djQarGwsnsMGImsgSQVJ5sD5jo+ZigjiDeQZakHIJZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfFbGR66VHayErTkQoIoUIc4G3/Zokhn15LvFAqjzKw26utOu1LBn48hs2H6HzNQq
	 enWDeSBA/K3oa8124S39Ky2QzRfQWKFy5skfNoCEkG9sz9vKEVoMX6gEHdOtbCXbst
	 YovEdBmAC4uGLaHGNAqP3BqXeZF+EKxoW8SDO9IcHD6qwesn+Gli/x6/TpHAYsUlrD
	 UCxGtUCULcfUxhXrs9KtImo/ip7nUbo9TQd43s1ekjsaSWhD1ejl+EXFJWf86KxJTp
	 WhffTvUE+ThhBNL4rEwUFZ6nXbB9jltND/rGE7Zw/xtewRIoZJM55k7N+y1oDTnXyg
	 wl/J8tjy8RWJQ==
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
Subject: [PATCH v2 04/28] arm64: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:40 +0200
Message-ID: <20260102070005.65328-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: k5njrstzmygrkxeuz33foxmww8zddwg7
X-Rspam-User: 
X-Rspamd-Queue-Id: D7FCCA0012
X-HE-Tag: 1767337282-695206
X-HE-Meta: U2FsdGVkX18cDj2/eNYhoTuLImC+vbEKp3oRjzwD1FMeUJkD8yDTO1OYFtyn5T/xKXmY9kz4859qvEL2/dCTvsmVMdLPGxJYJw8jgnxOPxX6w1AJRJpnkW94VkhURteivVaph+li6r37HkaO+nfmA+N4j3KRnqvA8rueP4WV9kpDAqdJZxUh+8WMwIUtqKOo5vXSVsxKifW06tN6ZnG4TTyk2VoqLFBeAyygiEekEhQTs72mL94S2Eptr4Q01eY6DqXA4IBxTmzoyXqh9Kol5rBntIavLmvg8EkXPM7v+nH/eMRLaptqDFPBzEkX27A7L5dUV+x6H0PkRWzVlvAe8YtObWKj5Wn+11ZNZBSmNpEa7ZXgdDwV8/sMEsT2qqZngGodUo+fbkbDbrz/Rl58FC77zUGqebdqztKO+Ek6vBL14dbpd3E5DONsfHhPYjzps+Fk0SDhnJm/kvlYoj6KQFZncV6iU9L539mkZUj9H2t9YhH+LLp1OjqgghWufh9yHGcabRUokte4OCrUiUFMbVinuVzV/iBPdHRz54QAttawGdEruMyH/maP6zDvAUYXGo68Rk6SYH77mCCcuWgOuAoTE4YkNPUwM+mOMpfTbk/DJGylLlqAD7XEBJMLKFw5zNQyml/jTZzQ4PGQxYPbCqbWzEIfqed/n8xEBDIY3uevT07NT9QzFrmYI2zDD0KmARRG6C8/AReo+f4eKmH4jIFabUvbRkPKbjRJTyFz7wF1UKPnVzskTyONFN/GPjmj48gCVKpFPp/E9XvhysQHy1C6hM7KXShdrPkdaGbGe647BKEk8b0zkxo1vrW5sa15CmtCpk+UKUdDKBL3NOaYVuBCQpw4NyJ7LMj4Qu2H2QCu2s7nt7bYx4krPlZrO/d7nNz5KFUAAdRVZVL08NYvXV63RyS1OQWNMiVKlZk9CRfl3C4DZdh3ea01QYxqGg+6wjhE1iP1jMSdQAtM4F1
 z3ntGpjN
 xu913vsNN71bVWeE=
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


