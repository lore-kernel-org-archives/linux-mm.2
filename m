Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35A3FA372B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FBC6B0093; Fri,  2 Jan 2026 02:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFE36B0095; Fri,  2 Jan 2026 02:01:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E6E6B0096; Fri,  2 Jan 2026 02:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2FAC6B0093
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:01:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A943813A2A8
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:38 +0000 (UTC)
X-FDA: 84286128276.28.A4E9B65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 27AB920002
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:01:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jKMirO/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337297; a=rsa-sha256;
	cv=none;
	b=xxvPJB6qRX5jviZHHaCBa+hZvHpMiaizokxgknnjsYrt5tV5Kh97RQSI8rZ45JhixnPwkx
	lbfguzLEBlBpserzaI2avXf8rey9FOU0nkRykwKeFIr4ZCbCwknsreh/K8ND15arB35BlU
	V6rdgwVaNQjolUVJMGGHyF+jM44etP0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jKMirO/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYVousDSpw+811qLPmYYO+fHKcpA4yVaAONn/C+5QeM=;
	b=lY5uL4AwxKqJQ58UbXqv1G+f+gw9HkyLJIyQwn4cT4ePWyVJlSBjICQWD4hgwnaNsH8dOA
	9u9aX5j8ekJhTXbxovwMb7fmJ6wZ75nUbuqeLscvzreaGfe6VKR8T8L5oibfzK3A6ezXnx
	4NiQ7iTcMxR0lH7iYuhMIMQ0JTIAdWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85BB160017;
	Fri,  2 Jan 2026 07:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626DBC19421;
	Fri,  2 Jan 2026 07:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337296;
	bh=beem9LtRR1HHqRgL6PattJCY9S8i8ATD31bTRr88sn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKMirO/VuTg7k/DrwUhdWDqifrgFVKcZxjR3ngObsepKAUunHyot4zCyt4dbuSd/r
	 e8hg+giPXhpyeaesjjegSYPKpxLKNutC6OgDnsUOcv9WekXd+NB/AKiimQ9/mqBlv8
	 KlScv9DH/Nq3I8tdNl74MxiqcD3aAM6FCfxhT4H7mKg7ixaPZ+3fILSKwLRmLkM5hx
	 kysdZHAQiUMqmxsOZVYFQkemEYLKJWnM1VBLRTbuj7W90M9DavJ9z5GCk3Ez3M75pA
	 nX597Xg69ltfgiS52uEQG5kNsR9io22pRfGDTHSAzWoLyLsgooMbRZSv3J+2WVEAAS
	 pKICEEyQYsm7Q==
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
Subject: [PATCH v2 05/28] csky: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:41 +0200
Message-ID: <20260102070005.65328-6-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 27AB920002
X-Rspamd-Server: rspam10
X-Stat-Signature: s318dm9yj5wmryjfiz9i3uubt646otzo
X-HE-Tag: 1767337297-974360
X-HE-Meta: U2FsdGVkX19sYqzlqhSUq1HpwI0lg4D46gBnR/bcsLyQx0koiVLyX2YI8GBzmhbL/muw7hgEaMRvoZY+A+PU/qokRRa6IsNlrfa8MiRC8GRDBVClsJaK3gz8mEK2I0wpFQE9Knm6HJAZxOYKATll/hReeFBIc4XxIYQX6tIA5rt4GcdTQ/FxpT6s2SKoQVFMsLDWudoTMtX2M1KgA/LX/lT2NmCNgje+gz7XLoXccpnHGpJQCUeCn7Zz2o+xysWfmPl6/Ah/Ltj5gF4nYxbsqZwYV/ZaemSOn7U+nzos4wffwPFX7uif/T8V3uVYsWhtERpxXcATcLzVVKVQ/mkEM9+L75CcvR4hHi4A4JboH07YXoIf2cUOHgLR1Nt0Wo68ukA9wp7NOXzkBDEdYab0ZSpAFvzFyuGu96XnOzO4KgSoNQC8fa/tXvJKcbDtmHoDarexzXFo1DU6kDc06DY8+ILCZzx1TWMreip8Y928VSK4p6rnTpfYsg8x/Z3sWBWkBqtEjBxkPQIvToUunRK6LaiQAN8hFRpihUtVRhOg+7qOoI8rHKxxo6NitzkNNV6Pml6y/MQVzhiQEZ/3U4dmj3X03RhDVWxn/Q6Mzf5XgiX1onrD6h+/7HCVcvx4blYcJCJKGSAsBEYc/0mLeRSz1/MriZfMALEdo1BeZFyJvGjDLGwV1T/wSsIufJ6VUnYl+63pW3knrZqtgdm+rREkaicT55VmC5hAvUoMgL0IFaByDjikq2N5mKgUhHGo8JU4FA2PwmdGAZerRyn6iMQ/Uf+u+z7ER9x2H/+zW9Im4t0SbSScHMUaKL0BqTQ7Rwd/TWriWpb1rl6IXxwQLLSxGrqk2e4eYfBP9cHkIijBy6kiGtFn8kCXxAQULwORSOhKCCMMf/rRFVJMBhPKCNPLMmi/DqkV6NfjmPap8gNEPCDQ2+5eA0IhA9G3+4A50H9DMy3GuA1ad/XHwTzIlzK
 VLt/TrzY
 3zEt3b6kOgr/Sr1WcCbmAm87ndgxoYYdMK6hOpUFYvJ84SERjaK4Pm3H0Wjdp2rIjP/G5JS4yv12NsT7JM0rf/uTGNjPmUl+80ZjcfQ7p92BmsXu2HXp8g6OO1DdD6QgnyUELYa4AOxCCgDLSBT+GF93mFSNesT6gZWGIa8CbQPTaC6/bN2Ous3cU2seYIFp51/9Zsvw/pSuUFiJcHF2kOX9XkAhHsjnMG4sn5mOQYKFT9cJR3T8GvZsKYbLudLgKf0WM1klD4ZZXeGzY4ep+DT0cNQ==
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
Acked-by: Guo Ren <guoren@kernel.org>
---
 arch/csky/kernel/setup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/csky/kernel/setup.c b/arch/csky/kernel/setup.c
index e0d6ca86ea8c..8968815d93e6 100644
--- a/arch/csky/kernel/setup.c
+++ b/arch/csky/kernel/setup.c
@@ -51,6 +51,14 @@ static void __init setup_initrd(void)
 }
 #endif
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#endif
+}
+
 static void __init csky_memblock_init(void)
 {
 	unsigned long lowmem_size = PFN_DOWN(LOWMEM_LIMIT - PHYS_OFFSET_OFFSET);
@@ -83,12 +91,9 @@ static void __init csky_memblock_init(void)
 	setup_initrd();
 #endif
 
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
 	mmu_init(min_low_pfn, max_low_pfn);
 
 #ifdef CONFIG_HIGHMEM
-	max_zone_pfn[ZONE_HIGHMEM] = max_pfn;
 
 	highstart_pfn = max_low_pfn;
 	highend_pfn   = max_pfn;
@@ -97,6 +102,7 @@ static void __init csky_memblock_init(void)
 
 	dma_contiguous_reserve(0);
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


