Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8D6EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789D76B00AF; Fri,  2 Jan 2026 02:04:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D276B00B0; Fri,  2 Jan 2026 02:04:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657E96B00B1; Fri,  2 Jan 2026 02:04:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5823B6B00AF
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:04:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 253931A0392
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:46 +0000 (UTC)
X-FDA: 84286136172.25.F3C5A36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F5C5180003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:04:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwqPmn4I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337484; a=rsa-sha256;
	cv=none;
	b=MDPkVlZ/eKVUL9mt9IHOBd10fZ7VKnrH68Bj+u6AHsAJwSFTHIHIBSWueKVO7aJawcjZHc
	c8245k58aX9dpFf7OQSTe2X7u0BVIBDazFszvEeLdQ9CZKeNOsyPumJQ2cEqxIDBmZuHet
	HhivIC9AJ0HwjMJvVNjH6S9IKOiip80=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwqPmn4I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCeW4b5bx6EOK5QjFUW3uRjrRx8sG0IrVuSe7S4JU8I=;
	b=T2QUQl+IID5e7tRqOVPLyqCGolI+k2jbIQs7uMJG82eEnbhVeYi5kMW5pW2geyRv4ZpQtq
	rBzMEj6Mk7UMDQ+AXnOyvS/8MgcBLWIEOJN7/9YLDXNxx41517c3C7vttCzrAEptoDUFMD
	YZUCDEFSayNt1KmTm8XICkskFoTmuuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6618543396;
	Fri,  2 Jan 2026 07:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6103DC19421;
	Fri,  2 Jan 2026 07:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337483;
	bh=oB6QCqWGlUcVzO7N8KoxEGaOaNJpg/wuZYHeNsCpdgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwqPmn4IoPX+byBLRHKkXpdQ4s2ijbsHhTbUl7kcznd54+NDLC4FuxMupYGdnAHSP
	 duGYgsXyK3jACPgRBkEJNITSYDW9QStPNEbdUqf43L+KGtz/EB2UizR45rMFn3ASUK
	 3tBzY4ayH3t+D6BAHPlHoQ+02+nDdwyWgMTw57eooHix1B353uhhyHt674/kdm8Eir
	 zx1Z35Ec90QAV18RcIt0HxrS7J2P5bglr/X1TgL4gKo91jeWB+yx/mmzYSlBKHjs3O
	 lx8SHuNSAJvY3QbtPwoLKMpv7CgSw+K1ZBV32pHVnbxu7CPsjQrgs1+xBrxrtDeB2m
	 gQkLbCHFWihRw==
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
Subject: [PATCH v2 18/28] sparc: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:54 +0200
Message-ID: <20260102070005.65328-19-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F5C5180003
X-Stat-Signature: eqtbzgcuispuoctke68jbaunz3my68a1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767337484-424409
X-HE-Meta: U2FsdGVkX18AkdT0ivtFA6Qctk83HC1P1eVqu1Ku/fIQn+F1c1wYxmN6aSbEfrfUa874QW7hyoJ4lKA5icw1wv29lmT1skvthKsa/Rxz2fpu/SEKsngBGdN3UppitRpfqdszVvxXMlxSrqwPUaZHZ+iR1SQUi3R09VLSouDBoL28VwuyOxt2oqz1EtKv5yhEBXTqopjx0T9HBUaQCXUf04apCN9QJzsqfIgYIXLht7SDrbyXrefr5d+kQ1hN5AotKkekFMa5C+c9GMcvNYeV83lf8fn4FPCv5bReDkZ/ntXWKPhIpFMt/+JDhlhT+XP91Hg3dENhkcc5r+Wrq3Z6FGdOC8MYs82+mq/nCjlie0PIgxO1Q3TAfJQ4vNQwrug4xqAyWb1sI6P6FskJNYGN/d9BX1Mmq/ps9S0UEveb5uqIFsDtpL0T7hcBk0r7bd56zYSC64t8lFXgxNz3VJVZoM1t7PQljG2ikS9pkQgKw1DreAaDPncP1aTx72srkA1aIR7We3GLafUBlHZfvWywtkkQNchOVBEhp6pKzC+r6/UNw50gVfts3uDhCqVPLTg7xic9YpTYs4fV4YtZCyzOzSKO98ixBVhistRRKyOF292ANqvTLR9gqV/B9h1AA0GUJqbD3A9UjlZ9+6e62L6yyoo/1kLyWcoHch7pADKBO8D9D+LGOmr16Q/kSnXttHAmhlgD0roNMkYiGbJd/WdnyIsndenPEoCZSsmzb6HlzTkUu3q8Fi+CLQy4bPY42pHa2979+P2J1tcqjT/iRxylYS8Ha7PFL2JghfJrRdDGem+7MdVQwxi9smd8jz4VZvEl/bZ9HowSZtRBrrth2EwKqwxAASu8zsAhNyD+pak5n+wIeXQCrMWvI+P1/9n3WInCE2IC7qbvQ8r7odp5O37mv/S1lzL3zeNTEE84B5fGDoUKeccLG23FNPgfHHPphjGdvtde5bG6Y1ZaYC5XlOi
 Z6SoJJYd
 nfWgSXcylFyQfHl+ejZlfkZEWhWdKiQo3qhh8t7k8tgiSshox2F2/kHcDn/5PEDoeygC5f6wQu1l/5ffDPEDRmD4CAxKjSx/58gIGQEYNMLITv+iMksHTA0zXV4wTsOFAkTC/IxQmAb3DRyP1NFg2UpAn2TqGMEGggtbX+BJCU0Z+eBAQp6ls0t0MF+JAZJS2mPEAJO7bTLnpg9+A8pGycEmb//FX076o0qKIj43u6Cekv59NIYiEZ4VTOXwdlTP/7KS64qedJLIHLL7/7SXCtZNp5Q==
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
 arch/sparc/mm/init_64.c |  6 ++++++
 arch/sparc/mm/srmmu.c   | 12 ++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..fbaad449dfc9 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2279,6 +2279,11 @@ static void __init reduce_memory(phys_addr_t limit_ram)
 	memblock_enforce_memory_limit(limit_ram);
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_NORMAL] = last_valid_pfn;
+}
+
 void __init paging_init(void)
 {
 	unsigned long end_pfn, shift, phys_base;
@@ -2461,6 +2466,7 @@ void __init paging_init(void)
 
 		max_zone_pfns[ZONE_NORMAL] = end_pfn;
 
+		arch_zone_limits_init(max_zone_pfns);
 		free_area_init(max_zone_pfns);
 	}
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index f8fb4911d360..81e90151db90 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -884,6 +884,13 @@ static void __init map_kernel(void)
 
 void (*poke_srmmu)(void) = NULL;
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = max_low_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
+}
+
 void __init srmmu_paging_init(void)
 {
 	int i;
@@ -967,10 +974,7 @@ void __init srmmu_paging_init(void)
 	{
 		unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
-		max_zone_pfn[ZONE_DMA] = max_low_pfn;
-		max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-		max_zone_pfn[ZONE_HIGHMEM] = highend_pfn;
-
+		arch_zone_limits_init(max_zone_pfn);
 		free_area_init(max_zone_pfn);
 	}
 }
-- 
2.51.0


