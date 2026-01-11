Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD029D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E96E6B0095; Sun, 11 Jan 2026 03:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6F36B0096; Sun, 11 Jan 2026 03:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2FB6B0098; Sun, 11 Jan 2026 03:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC9DB6B0095
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:22:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB3B91403A4
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:41 +0000 (UTC)
X-FDA: 84318991722.22.A777427
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 370031C0004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lw1lU3Ew;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119760; a=rsa-sha256;
	cv=none;
	b=JHQ/asKGxq009m8oO0TJz2RCcUqkPilLeGdqVGoxPoe5VemcHEmcQAscezo8N42cKk+sRe
	UvdZLxG7Lq9FvAKubdacsob9MHz5/omqPojl1O0WnlHMg8F1oXOP8FyUNFLWTN+YgR79SD
	EiR+FsaxEGAwyaM+MbMy28poGxx1UsQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lw1lU3Ew;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXj0Z2NgAtnlunEa9AvDDLLh6y0q3hS/njeAcboUK1o=;
	b=wI4EKk63DEOMR7BMzBD87jkv08kcDwtkYy7vnj1STHMColhk92Kx0NUDCASgb81hhxyTCy
	bnVLHCDcvZAT3UqzefpGDwPqfYplvVdGQALIFGFnP5hFKH82EYU9MURfb0zckraBlpU1cm
	40q9Wy0RK197NiUTxtAFQvlmTnbdV+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5E5D60129;
	Sun, 11 Jan 2026 08:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA77CC16AAE;
	Sun, 11 Jan 2026 08:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119759;
	bh=djQarGwsnsMGImsgSQVJ5sD5jo+ZigjiDeQZakHIJZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lw1lU3Ewc+dtv3vDYJfQvcR3SFOO3fNdQZbUcukOU8uBYk43EPjoMNLHvS+ZVTXFY
	 kFiAwsUS0cL97IqVcj9lfrxTQhOT2vwhsvZsYZ978UiUZIG/ymSeKzXUMCvGav2t3T
	 vM5MZTJCCtREKdgx/Ctorld3QmD4G38UlxAV/FKOUGToSqJ9W/z041Qg3ZqaKRg0C6
	 0pqyd0jXlvxFbMeJVINiPfxlP57E5VlMoy0DwyzLHcSHXAWp+XP+b3aDLtpYYqQcns
	 gv9MGzAi0TPrvCroxyxabPW1rlLFsb8P84S1OTpkxsCAf7ZizWZpxO+8YyP01fxPJX
	 jR8BRtnoVff+g==
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
Subject: [PATCH v3 05/29] arm64: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:39 +0200
Message-ID: <20260111082105.290734-6-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cn9keigr7o9yow9r9anai8szubxhwmkj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 370031C0004
X-HE-Tag: 1768119760-653418
X-HE-Meta: U2FsdGVkX19ZLNvd+g2DwEbwADA8HFuZhHYWti55TNnlArl6dl9hDRFI9OjswSlUPNrbZYlLwVKib1/m6S5CRMhg9F5hkRUezc1tpAGY26b3ZO4zj1BhHnNEgTAqzHF0FL/fHuTUSXskLS6qwQEL9U/07WM/E+US0FiNEKdYz8Wet51hfYiND3ynA0+p4h6IywuY1fXBJ4p1izGnXD7aQIdtfqZCgvi6hhBLswGWajLIiqVgvA5advk1LjcaWD7w/rA++MCiDNDOyE0gubjjWiaMlnxrenZ2hsuXAquqVqYnsKcVnrHd3vpUu4ZzYppGpb27DTeSs/pcIdgI+i5jH0kROGYNczv2NrnhSmZY7JwN4dKs4TRAPbWy0t4Nn9dr/nWpVnVU5z42W0w1/MdtEGCm2R/XIJht9noloFv+zku/batJGZGHgzd3ZBVcA9zuxcgMp7iTOfUx7SR86AWKzIEzpkzwqa7euRSweaiJ5abbyE1jrzkqDVCA5B8esjIh90QxtOSuXNQEP0Pocex1L+0pBNqXCWL4I9r2VOFrS6IWFnJsOvotTEO3bW5Kp9Jq74ZLIvwPBeyoPipt4/KEVCrFg09OQbqAR1M+14R9NBMOn9fAYSdsmOR7iqlh27IkE5uKWFC0K5/7OgYMhuUKxcYz8BZjzl+RD/W0+sawdAARAk65v1ySjGrBJeaD5u0rZot+0nVP5i3dINIrN86fsqK1wzv0t18LYj8P2s/3flplPkI4N8B8VTQlNJoXvFMgGymVBJZCG+QBLHTsJP6CuoqP+Deurm3Gm8XHy1Jp+irWTBB9GOlrFzhLu7Y3mHrdMAmoakf8nuKNXJIW7r8GZnoGc5GQolJmHlcqhmpcO5eFJW1vItjZ7mVAykViRvql+RdWjntVTxERRTyUAbHmoyCaBTIs9uXfQVLnB3eNuGkXeskEkTNSKcf45n1W+DgAcPhwYGLMys9EX/7TrOi
 EU60Vi6O
 +Cmog4GbFCb8JEuGI4dCzz4/uByrqvUNZn+MORa+GS4VWg7SvQzj+O8GYmkScDtXzpCsm28yL4iMmSLZtCubdoUanHZIzkvE8HPjwt/YRsYyyDooycT9V3WLK6OTzLYriDZJqFcsjf5gFS0z6qk/pR9levMHj5YYVYYDB6cE8O1xlbmf1JV0QpsD+paR1sgkO66eMYEbPykr/D/5Xd+BdzHPrQ6k0+2h1eOXCsKVLHlGQ/6mNLHsa3aDZ/T45KXCXDz4yQozeUiR8HZehX8vZ7g032iJxiATU0zzwfrjbb9pIy8gIKP2ic1tMb2XNCT6J2YQ5Mt4ZtN5MIlMk4TYv4ijW0VHe6hi45Iko
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


