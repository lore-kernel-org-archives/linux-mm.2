Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8D1D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2929C6B00B2; Sun, 11 Jan 2026 03:26:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269546B00B3; Sun, 11 Jan 2026 03:26:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F766B00B4; Sun, 11 Jan 2026 03:26:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 036E56B00B2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:26:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE0961403AF
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:13 +0000 (UTC)
X-FDA: 84319000626.01.83F5F06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1663E140008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:26:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FCgoY/zC";
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768119972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCeW4b5bx6EOK5QjFUW3uRjrRx8sG0IrVuSe7S4JU8I=;
	b=0N427wT7F/jvmlcID8vvDG9tkMw0u5Yx2UOhWpK/QQy04z/spsJbnmF4/gHzJjcMj/5O2M
	zN+8cx6/8gVuTiTJLr2axI+EYFu4DCU34nu0GkfW5MGfgn2YwuMD3dezMdWfw9u3kzdPI8
	3IXzqp8fbGEnDRvWPrwVLEGGivtoDas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768119972; a=rsa-sha256;
	cv=none;
	b=a1SdPRMsx60PMQwJzerX92YU5xNgqIhUyGDAqB7b3EmCRfreY3TK59bS2V0zao5pbcYaJo
	jUZ6mkzP6DJt3pRI2HU74VkAQ+fqzozL5zRScb9F2Ofi2PR7iPDVKCflLGR3CPFUYilinE
	+tyl/JvvLSQuGG49MEJ1bGOOImhzD/0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FCgoY/zC";
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B90743473;
	Sun, 11 Jan 2026 08:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7D0C4CEF7;
	Sun, 11 Jan 2026 08:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768119971;
	bh=oB6QCqWGlUcVzO7N8KoxEGaOaNJpg/wuZYHeNsCpdgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCgoY/zClmOALMEzX+QGECEEPV7T3L6P2l9SJuYtZBPLJ0TU7r1JmDmqmaOzlixHM
	 V2rn3TYFVY0bqHoDWhb0Gj662NbUSm1dBp81NYzRwzFZJGLo074/Se+IAyPFQ5leeD
	 PEsGh0XhkssNIwxce06F8DAs2N7MD0DYVETwqgDoFv+EtygOCimB4fbNvfrSxKyFgx
	 S9yGG1o2zhHPeqEfMleqAcgNBmPU9z6tzpBp7Fz2bq5tBLCcH10svoJMb5cEN8OLnE
	 b5siscAudenCVtmXNMhWhsVWfArzA/VV4IitFVVdWbDv49lESg6nfy6O7xkz2LhaAa
	 g0n4y+0e0Pw/A==
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
Subject: [PATCH v3 19/29] sparc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:53 +0200
Message-ID: <20260111082105.290734-20-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1663E140008
X-Rspam-User: 
X-Stat-Signature: rxtuottpodgx1dbbj3i5nfk8gb4zmawq
X-HE-Tag: 1768119971-312469
X-HE-Meta: U2FsdGVkX1+W5pDo85bIpmnGOWdPrw/xFdTk6ImUQsoWj3Jh1DGJm29trg1oFNBTK8nMw3ubRM6OdMpqsJLN0IAW1J+EtLmTHq83Nvv9VFOCROgj8o6GkUqz+miA6C/BS/jToTHHkW2V3z+5qrfXvmqfT7SPhmIWRmnNoQvGFNdRzdQfakBbxvc+9A90TvA2voz5sh/BbrlncNDuo5aj55GtE4UOUEuzGVUKpqfkxaB0v7lL0uLa3zRQt77sskQu6jgz4Yn+o02sco7MH0k14BmI1Ib6ThvrVLCp5DHRR/9MUTNeS8Kc7+wHQIQfGjK2Gbgz37rQ0cEZz04m/1ieGuhM3FOo5viuCdO+U/URM8DruirNRfGipDrgHla2EbExYyFW+O8d46/TFbFV8MxkkquZOcPLlAuvsYfj0BzfMEImdyYTaj3MecKM2rrU9AnIBBwLUSFjJeQWS0Zv8eHe6a2Rfb9L4zr/g4a7NVUe+9qAp/aW5DKp08bm6qdZw+4zueOiXE6CgJuEjhZo7wUzaR+TKWr9h7zxfRkJKiLZeAt7xvPdaEMhUE0pj0cF/elkFxIhc+eEVYYWgvPJ1PD9nXNGdVbf8c9gTJ2XGnPVi8np2yVyAFLBHuZ5rXRIhKeUjNienwFxWYr3pS0YpLk15BnKlaxkbuONVwWP/ZZFcOxSKUYV7Qsed+UmxbWuKeFU4eBtt42S7kTvD0rczO3VwpbYEF3DXBlnabmtyBj9AFH90Pn8tOE628LCELaNfpQhaus/fvQ4E9SDZz84hru35cA6balcTzkuhvA9PZfdwkIkIvXv5znewkow761toGhgmDjFx/PRsSejm3OrDFKfALiUSXD56wpc/fdG+tp8TTPRaBVlmpvGJn5J578ODZN6LRIlL9xSB3qZVoDdGgLqzGSXzKzVg51kA/RA7fcKl8/rhKWnuvrEFtrZ+2dkn6b2kzlWXBKrNcPZmIMmCmE
 cXat0JOp
 BrtBsRK66BpwKwmHNfIdSyKawSyisK7Z6wNbhURWlopDwQtaRnPluKmZ4sN9ZaD2OgEgj674K+6EXEUI27RXgaNYSA2b6FNI9uFeehFKQ/jiDXMWkMeRlEyrpMTut4U9MdF6ARvHMA575XJoghB1El3LYDh8cwYiSfOZfzX/+2Ayc/oV4OsA84+dqyZUkcDiInXgeAywsBf+yjidTooPt7TrUvxeQHd9eVXCRiAqjNIxw49iKQYr8UrqRABp7JsB//yjuj0KGsDnv71lCelgcU9hbLehqfiHnK08QSHNzV/gTkKXyBZdPzRawYDJh56uSJSkSTUkmaFH8MhsrW34kAoPJg8UreRmE5u1J
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


