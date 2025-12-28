Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2F6E92724
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586716B008C; Sun, 28 Dec 2025 07:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550DC6B0092; Sun, 28 Dec 2025 07:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446BE6B0093; Sun, 28 Dec 2025 07:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 345DC6B008C
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:41:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFF2713BC50
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:07 +0000 (UTC)
X-FDA: 84268839774.10.411B4FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FC8620005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:41:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3xxAC9y;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4qD+cVO4njaR2WMTsE5cyiXB7W0CbhxQFlHvnJsSI4=;
	b=flnKuSUSHs+B+DrX57t8sxrFUlif7aAx+uqFnyM+bIHRxZ0HD4i5yOlArYVw4y5fBxGfAW
	y10Gm5g7OOBcBq/+mGtootdyhhqw2AkdoB3jqN34mx8g3SBoZGN/8gdxmDAp+VzdWeVG7J
	eOaT9KIL0h4jfgKxZmwJ2oDh3eetkv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925666; a=rsa-sha256;
	cv=none;
	b=cgXGw7EEPsZ1LTh3Qea6kNwfFxRiSVCiAOdH8qBxxLy6hGHEJXVEEcbEXWTDxzB1HipM0y
	P1p6Kmx9yPTZUK623jez857kXeiGQzpdW/ra/ROWGqSmh6jolT7Ljr/fZt3ninZuk3X54r
	XHcPe5lFszl0bZJ3T9pEvd2Ic51/quk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3xxAC9y;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE5F9600AA;
	Sun, 28 Dec 2025 12:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ADCC113D0;
	Sun, 28 Dec 2025 12:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925665;
	bh=sY65/RaZssilanqAkKMZORd+RGdNjje1eX8P0rlpw6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3xxAC9yYJldcaI9CW5HdZFsKaIhXOs3RKw+R5Lo//mlmsZgZlShsXbbbEVSQd7YA
	 bMehhr0xf8GWVrAGCiCKPypO+pRDio1AnUEQIebWoWBbOHlFaUGIVJZfzRNubW0uHx
	 MeYBFDVT7e/YjcVN+I8OX+Ps4M9e6vCnrQY26l/j9WUBZhfqmFeb2LTZI/UGM24NMH
	 plWqe0SpmBn4PszXdoUfV9Ad/mF90eeHiKRn+EgiV6/5ZmOZksbvcGLQDSaTQCnmCp
	 aywnwsI1i+Tw5CR6pIwl01InAR68MIZBnjpmwsb5YzVjpJd2Sq1IvvHEwhtZZhU20q
	 aD+aUhIyRHBdQ==
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
Subject: [PATCH 03/28] arm: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:33 +0200
Message-ID: <20251228124001.3624742-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8afmmjd8yb7y6mpje3obn6w3t8y8ubts
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FC8620005
X-Rspam-User: 
X-HE-Tag: 1766925666-779890
X-HE-Meta: U2FsdGVkX19E7t+GkLcQaZX7S1UEDcol5VRQqLoJJavIRhJ4Jh0UCMR7PTaNpWReL4JWO1TwV05pjgoHcOmdyFNg4p5PEt94Kc27Cl2a115+SY6EilS2DjIRWiqf67H3P8DOjRIirMJXZ/0pIWS2KxgtH7OO1KthqQaMGfY1aqRCA5zfai6BoEkZMJ+hAnsvjOQD4q3GEKPB+TGxVkjyIResBlr637NBK2npERmCi7hoHSwbr1CALz1Svi63j/RiVaRUZuVON8akHzSEOG9oPCgb4n2kAkyLgVdfdNh7RRvMUI5ywdF+CufWEDVZEeiTEX42MuGgSA8a01Xr3jQsVSj/BMMkNQOYd6nKt2SHmY5Axy3DEjmStS+ItBCNmE/NMTetmkqrxSOECNkhUZGBYt1Os1mDriAaSQslQCz4AYQbr9SsWPPATkdgCplh2YpsEHTZGlONQLE43rFuzin0oMn8t//ohpqVEsVS5Tx45j+b2WqClL5DLLpo/opaHBJ/upjoZ07fy5q2hlmYzllAk3RH2UvST0f1nZoqyJ6bGx8IQBUOOb+V9VopXyIv8qEkXmBGa8DCgB628okrJ6p7NlmW5YnhDRq7aDoYTAE8841PKt3IdvgoSTsZalp8ziMXxIsWIBFZlzeb8VksOmrMed4+ngYz2EIUK2+1bq8ihd1kkZ++9iXDgNhMCMxfvzXoy+t5o7Ohebt5MEBim5yIwueKfn7YhXPVYkd+15ShlxQGtrAeF6P/pjW7BNKRrcd3ZG5kipKO6Rf30X4dClvvSZ0M1jUKHo2mqEhvCNPSqQLxDoEX+mv4v/DudTOPJZjfUV4WqvihbIdhuRToHehQo4Ne1MrKjPelYpbBTeI74xt+0PA3Fv4J4A/ioewxZaa5tDi32ba9cu3HyfmxDea6G8PDvM6/1rTtYi8c0Tz/uSSYRbA+w7vpjWsH+obPHcdVBl4d0w8hD8phgtcOcM2
 63ufeUnv
 bthpXu+wXjuNAH7dGWBYfMDBjh0GpvRQWFE91nTdSAkn1tWgECPfqXHUxBgy9fT0qn2kB76SV66108HjpiBiJgYFXrZR1hpOnfKBHYJIRZ8e+13bdqLEhbPzyYEDSMcd4xFksYEzk3VCTLZgn1VIEND9paLcdaQE3pxUwBn4ShMyuEtzIxRC2uZi98n7xI5RuxSxm2vKAlDND4qOw9NhthcNBXgg8YROB6zCy5z/0H/e1m52KccVPJisxlu1590vrM84M1uUIBCa2n7KGbpgsg4CJbQ==
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
 arch/arm/mm/init.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 54bdca025c9f..bdcc3639681f 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -107,18 +107,23 @@ void __init setup_dma_zone(const struct machine_desc *mdesc)
 #endif
 }
 
-static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
-	unsigned long max_high)
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
 {
-	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
-
 #ifdef CONFIG_ZONE_DMA
-	max_zone_pfn[ZONE_DMA] = min(arm_dma_pfn_limit, max_low);
+	max_zone_pfn[ZONE_DMA] = min(arm_dma_pfn_limit, max_low_pfn);
 #endif
-	max_zone_pfn[ZONE_NORMAL] = max_low;
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
-	max_zone_pfn[ZONE_HIGHMEM] = max_high;
+	max_zone_pfn[ZONE_HIGHMEM] = max_pfn;
 #endif
+}
+
+static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
+	unsigned long max_high)
+{
+	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
+
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


