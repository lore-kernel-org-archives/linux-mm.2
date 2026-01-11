Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98DE3D25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9976B008C; Sun, 11 Jan 2026 03:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097AC6B0092; Sun, 11 Jan 2026 03:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8136B0093; Sun, 11 Jan 2026 03:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBF386B008C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:22:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C4DBC1B40
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:11 +0000 (UTC)
X-FDA: 84318990462.06.C588120
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A5561A0008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:22:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NN3lChfw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119730; a=rsa-sha256;
	cv=none;
	b=4sicaeBpTna5CgBR/Q5FZBnA7duPwXlhNndIEzWvhcOT8tlqt/7SpAkst1FmpKxqqEMrpE
	he4CR+ZmDgPlzldLJ0MNeDUQkbOjHbJX7J/8MWxCVecsDMWq3AZc1dH3mr9i6Y8MC20htL
	b/kkjFsLrdhTy0ayQ6dOQpm+QwrNBkM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NN3lChfw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4qD+cVO4njaR2WMTsE5cyiXB7W0CbhxQFlHvnJsSI4=;
	b=vRH9qomYuFaM4u6znp2A+UOaPM3vMBkdSQ46l+deCw9DuV3E0VRvDNA7maAFBD4RcH5mzi
	LRxiBdW5n3da6oaHwQDBaz/3ULNIdeHwnq89F0vm5E9KBS4MVKSjqm9w5QQuCeBjuQPZEB
	OK7Oizspk53YPBiGYVgvNynUUEcBSP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66FD260122;
	Sun, 11 Jan 2026 08:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A040C19423;
	Sun, 11 Jan 2026 08:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119729;
	bh=sY65/RaZssilanqAkKMZORd+RGdNjje1eX8P0rlpw6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NN3lChfwg5P6LBJKzoLfcvbBwFyTjkbv176l7MWDDNEKfmQNsV9FdXu1iTB1p18r+
	 Qv6MGq+z4lJwgINv6l/GKUiPw4NesyjwjpepHwiPwzlDjiMWa+i1USjl07fz2MRYop
	 Sc1LrWnu0Gc+BgNj4gzJRCHsWYSYmNHqJ3aaEPjVk5qnsYr4znc/0zqFTfi59zJAq/
	 ukCr7ZSzjxeYp7Kp6yUQVQxDk+q26sRhrXb+8OmAOZtQsY83a4N26iQ4g710XJtgiL
	 iBzYFgAYbnZnLVEHpBAgxrkx8ozQkpwEdocd+bhVIEyIcdzpSjZYT6uJOIy5GXGxNb
	 0PvoDd12p4x0g==
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
Subject: [PATCH v3 03/29] arm: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:37 +0200
Message-ID: <20260111082105.290734-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0A5561A0008
X-Stat-Signature: son4t8cq89obxzzykt38tr3ppw1oyty7
X-Rspam-User: 
X-HE-Tag: 1768119729-787062
X-HE-Meta: U2FsdGVkX1/j9IfoRF/s8f2cgzP8a8u7nCW76DJEk9avMsbg/yoMaqYnMMlcbfVDsZNXHZWTgM758KHXrWsXIyJCKSu/lA3Kk4F0KUlsKi4hK/ZCNrnsrvKfFYtgSjJ7s8yKfDmOFHzFT+j1lxPU8w1oP6wZQUiTvWHR0OwshLcoIQi1YmFAW7W8LTMrJ8yO+yV17OHAAd2mp0N1iOshE3jNgIP7e2tAkqO1ReSIZpOuI6ByA0otMEd+Vx6LVUUokN+AoAbBlXl2Cyll3eHLYTirVRPPUXdeQNqi4qcxYHr6EngmPU6siqaeZCHmVzfWwr6fjUPE2RZ+U9lDpnDvUVheJXvHo03hSS7qqCILYJ/9u5wUJ7+k6BYKO+Fq+hR+fvkDBXnNM4gU86FMRMUdzEyPb0Q7iEjtfJBU78GfJqTt85KbFDbBUEAvqe8scWTEtwH6InC3QfXVRjrvZqzZCMEtSTunkDF+GF7fgdZg7N8Rd2kYr1OdU6jXTtFrxKBerX0PxcF0Uy1o6ykCb2lStFHXTIflqynTDg2xxDzqzC/3MYx8H0pQVxxmbGMmyNyDnZpyOR78jmP3qE2QJMaaqLTalp6xVcv2iLdb15FrMr3yjK/qo1dLXLtiWVvwyDh5lLNzvcsvEmL6hXArbzu8Pqpb3KopCS59A5Lym2jzx3RxVxcGcQ2sJajatL6KxaCfgtamxPk2vj0sNcE5lwcX01Fvz9tuXl/+713m5NSWAX0pDcs1Zg0dFJj5LwA2c6UN+eigCvVQROAK+RPoM+dVjNfAfwcNNjcL6HYLh20Jl5t8Icnm4xIkshxwbplp7o9sS35bKG0VYtWN9fZ6go7lGG4UApX5cZI43XgrFpUqGIR9lE1pedj0pmZbBFtdGlJPJb4xx0IoKDvOmI/Jfu6HgkyEZp8y6y+S5We373cBmtzc/8Rn7CfT6jPQ5hrTXJlJGWBHfXQzBZ9iepZZTj8
 jNQfGoiX
 rMFKi85P2iTFmVbYq4Y8NYm4lDY9B6EQHmPV83/8iFYYQ0ay0JSbjAAtJZlZWzj+POpzL2r2TMSMS2bOrGZEp0f9Goco/L599Szq0nMp5sYMimNKzhGuz+Nt7wRBLPCgDJ6UFGKWPfae3ZlzriucndAiNy1h8YLlRRPzJHPsij/ttZ6RKQBa0Rkm7UYtoJZXtxn1ZSCrx0pMcUL8v7g2U+1cpB5F6t6Z1msH+xWwvmWiCzJJUrfYPxniMQvHKT+itKJCzqgANNlfVGDu27pjIdopEdt1da93MHJhRRDYfiAfdnmePlOWb5lCZX1/HXuDQ6VTyyBqVRlzSZ7v4TrmPIZWL8mzl/3YYItU3
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


