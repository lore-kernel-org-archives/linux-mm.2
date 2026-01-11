Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD52CD25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497536B009F; Sun, 11 Jan 2026 03:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465336B00A1; Sun, 11 Jan 2026 03:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3506B6B00A2; Sun, 11 Jan 2026 03:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23AD66B009F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:23:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2E65B8A5D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:23:26 +0000 (UTC)
X-FDA: 84318993612.28.09A2A45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E526180004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:23:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aRGBg6QW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119805; a=rsa-sha256;
	cv=none;
	b=mjNMVpgv8Moy1jiQEqVPNA2EZyjxYx4knrHtY21OgkyqTGAr46d9Wso34EAON0D+N0a9w9
	euITM1mnIVx5eZQHwbmbdKfNNrlt7oyCsxMlSY467s087amvQ2SuUMh8jrFyEeU7B0tH9s
	hC6QloyyVVkmj2vjfQ8cweoIVd+CJbY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aRGBg6QW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfcqmLQbnSJvVIv+k+pxkWmR5Wm/caGZYknBWk1pJXo=;
	b=PzgcKcN/zaxvxSWHcd75w3KLwWwoWxZr7EbPtVcRB6Vv/FBF7lTHYY4aEyA2kNwSmM5fYg
	b5QBY02jmFgs+jDY0Yg2fvmokcv2VMkWzeozXub4P5IRnYSrmxR7NivkUPyKH4Y+GHC7IA
	Aam8eyLDONZWgYhAeZO/OF0nZcBkOpA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1033960122;
	Sun, 11 Jan 2026 08:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229FCC4CEF7;
	Sun, 11 Jan 2026 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119804;
	bh=3bBcyNtfu29ffLXJ+V2J2og1TMjw9NsnHxGDp+htXro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRGBg6QWrfdw7symPdIfdeBuEObPt3i9tEb12+OCo6mXZGBjZXCBQcNSrZuUzbZg8
	 PCO5UhVWdvknheOMi+PNJHEombMZMaFBDSNZ32iPSV1o17p4h1FaEH1C/CiJLr4Uo3
	 j1ptOQDM+v3irPHu2xEaMAyDNWgRyFeg/GVpJlHgHuj2XNSJ4ocgxp0wWYpHIUlz0V
	 yax5qnU/gPDf3ITT9DtMQulB7ID0HiJYXy98x5uh5/0Ouuae5hHH/gAgW1Ez1ZBkzC
	 4YGj+Uf0x2zu9bXzfakCQ/NLzF0O+8VrgxXcA88JLftjppFp+8BUbvbua+VSjqZ8u5
	 x69OyH7O4BEow==
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
Subject: [PATCH v3 08/29] loongarch: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:42 +0200
Message-ID: <20260111082105.290734-9-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e9s3qaqf53qruyh9cxgrqb111zms6p4o
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E526180004
X-HE-Tag: 1768119805-120657
X-HE-Meta: U2FsdGVkX1+sLVA9O+seMf1a1aIM4IpRLdhdSoe9Gg8y4dRH2gSAHkwYiOjnruMxIP5UEpGube5gUqnndxtFNz0lEq4yjaYxjaVSK8P5ODRozBdWpLDenRXVwpqNGRvMS7rYlVDMDQJeRq1w/kSoXH4Zz7eLKxW/wxLpb8OrdR0Hnk+CGaC9kj3da0+Z9ZtxtK+gXlGC3kBCg8UYl8URted04noX75r+erUXYhBRLizOjA8s34nk7YUBzJVPqQ8yVIZwG7i69+6xkV8DqBXmEE2HXem/0/IxPaMkPITzmzfmOUDzhPvZRoX0PvDm6mgOlgzL1gBlZCKo8ucnjlZ0PrikKrhiZLqSmh3rM597IBI61P8D4gcZz1Y7xdeq7l8sENxmLSGB+xabRwvBErNlFm9/5YoFZ4qlzpSGGH/9d0dc12Wz3gfJDrz0C/A0xGan1jFlzuNVeDyqVJtR3raYfcdJIvABtaqgzMXbPKQBE7Bf0vOxQvkDMyAD1F4WIgCBdBZuFbBtTZvSPER3M2m86/bKlD4ifPIC5fFlutIGczklDcFtXytcO2nbFJBmNh/owiDojuprv/PkgarNF1d09l27Ls6ZvqI0kwGIfx1oMcWIJjqxQfjtjMWFHlm4vb9ckdKR3GPXi2edCHapwKe5fA8+QjztMHYZqoKY4mm0hPzhusBuKCzEbC5MQJ1N5+729WQXpA4dubr2/MD8yB511pjUMu96EKXlAUO25UimMhcLIyjJ3eP+XVItL/DfR9kcJMR2VbIUNnoWw9xrf0yvBYt8WNfhh92HaMw18+4AuxJHR32Wx02BJ8wVG8srNBTuaoe+ZDmbhhim7BHrjCajujYbSuhQ2ve28dBB79yDlPz0Ffn6xhDBAFdQ3DoWYANmLCKT8H357t9DFnEVrCMKGB2FJY9ZrmBq9WxOpYjgkCF2SjZJbzX0ui6PKhlADqCBiTEDuILIEtmaYjqs4OE
 EFYEk2Qj
 VzE3KWrG9jq73mkwJQXMia2vBch4rsvz8ZT6wgvhauBFLmmj1ij+pbubIO+pjzWUppPWDKWMFc2VxIcI=
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
 arch/loongarch/mm/init.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 0946662afdd6..17235f87eafb 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -60,15 +60,19 @@ int __ref page_is_ram(unsigned long pfn)
 	return memblock_is_memory(addr) && !memblock_is_reserved(addr);
 }
 
-void __init paging_init(void)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+}
+
+void __init paging_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 }
 
-- 
2.51.0


