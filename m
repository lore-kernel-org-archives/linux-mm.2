Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4D5EEB57A
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34606B009E; Fri,  2 Jan 2026 02:02:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF216B00A0; Fri,  2 Jan 2026 02:02:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901BA6B00A1; Fri,  2 Jan 2026 02:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0AA6B009E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:02:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 533D71A0376
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:22 +0000 (UTC)
X-FDA: 84286130124.13.697BAD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FEF2180005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:02:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgVfRMOP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337340; a=rsa-sha256;
	cv=none;
	b=xbtjlFKydvitCZfIVx1q9DTFV3+pD/fn1gJgtw9abXkJgoFrHiiGCJ37leM13OXbZqgXCH
	DvR/TgBxRss/ur9R/lJQJ8qgRVS7qLW/2Y7zNs1df7+h4tlrNVo2i1kOevqDfW2hVaKDGL
	nk6mWOl3gROiPCbh8FfwHUhVonSMZ0k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgVfRMOP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJatOTiXEPNp/W52LlXUaW1EIsFN/BNV7MmBuJg1xZQ=;
	b=BUdF3AZ1E9Y+gX67YR/JQszo8yHf+kZd2kkv+SMMTWrB5jDBIh8vg1m0X0jS/Ame2s3FfX
	Un8YXYk5hUBeNi4uB6YZbV5UPInm/lWUtjSo5+7DzC/UdbTr4DoR+dA6foKt/6z2A+Nxut
	7dUXkblNpnerHEXhh7qXJzddEXQDF9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5C4D417BC;
	Fri,  2 Jan 2026 07:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C2DC19422;
	Fri,  2 Jan 2026 07:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337339;
	bh=qGV3crV7vYfN1DCsmhF37VWmOXuApg3MmNmGXJVotqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgVfRMOPs1HT136LQlxti3CjGqTiAYYJHHhtujbmeeW9b5Sp1uzqGIqNcaFKtEYaD
	 gUmONK9l5FeSIrhyFOIzw67O8yh8iZKtBESs03lQBObKmxcbhraIYFS3aMlk9cEYI7
	 UQZCAbWMn28QX2knHvCNY0hoM7rRnorxLD1hUlMhn4nvfhTTDVvqdCBfWuLVwntHPn
	 D3vo7BUCLsuI0NFNIALchXt/QJhsX/uYfd5qmIcvxrNCz/vI6hg+EVI9NGaui2qCrN
	 wI/OqtpL8AlxnLMhaisftFHIoT2W/7a7/Vyg9nZsG6O2ocQDHVkFf36gQ0LssTm0rp
	 3nnspmYHu59yA==
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
Subject: [PATCH v2 08/28] m68k: introduce arch_zone_limits_init()
Date: Fri,  2 Jan 2026 08:59:44 +0200
Message-ID: <20260102070005.65328-9-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FEF2180005
X-Rspamd-Server: rspam10
X-Stat-Signature: mfjkzk5ao8yax18s9xhg41h8ekrth551
X-HE-Tag: 1767337340-280740
X-HE-Meta: U2FsdGVkX19MLMR5bHKjto30bobQi4vvz9MKUVWqORw6cecZvTKkgNeeclSBELp7+94rrWWghPUKHV90po+4NNhrXqkTOO9NgCI3+RP3hqyNouadqKADX8yJc6d/oAn9/PdifwuoP6xOXmePhx7AYkjqPmrwQrIUOZ8FC4GFdDTv3kZV387Vu3sdttvWGyssKc78rYrVKASW9R3SokOzOfayQta2aVZ4VFYMmdgcObhppw/bVjd+3SWpr2R34iuMPIWNgGX4DWZ+0H4/CCXvfTmFGKI5M+g/iCumc0dC06btvryzXntbI9Ry+e4Goo1hm0w+qG8Q2y+9rLNyKNXbUN09VjUsnXTVtZr9oGcsDcv15P9GxjtWkWx1rPgCmJLooHl7vXox8y8Vtt9DciMDadMh11VQWwvHyIh1FpmJ5VYFK6hIiIlQhxTOFejUbjpQC5WJGujy2EpHhFzdyYky/7w2TedaGILFENfRNI/GF3yCeby0BevPMBJGBObcedRvdcGVQuV8DtI6v8LQ39/VjcXAYHWpRjHsTgtpew6OWQPi5cPBzNxYazK2XNICnyxrXGoza65pgJmHshCsf1no9Hwaey/6axESU/yquIa7+cT/tXPdq8pWQq7qJ/ydXl4QcGMVrmXDimnLwom+pMCCQ0zHh1crnT0QM7i5xPUkKWlZzNXFnzlaHTqZIEU65DjPlHi6OdcXMkC/l88TTTNijHzfAc9dQ/G0dK+Dp6dHkie0phRIP4wtPPz8uGMjBxx4LGZ+UJ3qGK/Gd8yhe1wxZjDruMoG3+KxsDNMflsvVDSfLlKApC3ZYaHN65OoVOab+ShY9BRb78JLQIsvWgeOaGbMXXLU2AyobXceioQeYFxr+Osoh/TblpK9ERINqgaTatKYwrT3ZVcTimQeo4yXP7N2Qk2kAJ8LWaeh6tzObXEV/542pHfhcqeLjylDxFaRFy5xz93YxWB2WVzuYY6
 E/3oJFz4
 KrVI/cVjy8U+PdMmlh9ZIJejHcayjS3PSffzzlPmxb5MgN4EG4TF/jgZSZqxokuXjLehY+1igy6CQjzjAoRQLvmpbLeaYPRVJxcLNL1gZtHyauLuzsy1SuM6lCM4jNp1eXRRz5VwmvZDt06PrXJj8pCxl3bJLtBskASt5OJZNvmjxx3OMFFDMEq10B+6quc403WjKWSL0Z50MU0RBElDqIzxBxYrnbAuOGvhJHEYYyoYd5nIOPTKSbIC8nyllkdcBUA5U6ExhIjjJaVQNv8ms9/yJQg==
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

Since all variants of m68k add all memory to ZONE_DMA, it is possible to
use unified implementation for arch_zone_limits_init() that sets the end
of ZONE_DMA to memblock_end_of_DRAM().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/m68k/mm/init.c     | 7 ++++++-
 arch/m68k/mm/mcfmmu.c   | 2 +-
 arch/m68k/mm/motorola.c | 2 +-
 arch/m68k/mm/sun3mmu.c  | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 488411af1b3f..6b1d9d2434b5 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -40,6 +40,11 @@
 void *empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+	max_zone_pfns[ZONE_DMA] = PFN_DOWN(memblock_end_of_DRAM());
+}
+
 #ifdef CONFIG_MMU
 
 int m68k_virt_to_node_shift;
@@ -69,7 +74,7 @@ void __init paging_init(void)
 	high_memory = (void *) end_mem;
 
 	empty_zero_page = memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
-	max_zone_pfn[ZONE_DMA] = end_mem >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
diff --git a/arch/m68k/mm/mcfmmu.c b/arch/m68k/mm/mcfmmu.c
index 19a75029036c..24a6f7bbd1ce 100644
--- a/arch/m68k/mm/mcfmmu.c
+++ b/arch/m68k/mm/mcfmmu.c
@@ -73,7 +73,7 @@ void __init paging_init(void)
 	}
 
 	current->mm = NULL;
-	max_zone_pfn[ZONE_DMA] = PFN_DOWN(_ramend);
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 62283bc2ed79..d6ccd23caf61 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -517,6 +517,6 @@ void __init paging_init(void)
 		if (node_present_pages(i))
 			node_set_state(i, N_NORMAL_MEMORY);
 
-	max_zone_pfn[ZONE_DMA] = memblock_end_of_DRAM();
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
diff --git a/arch/m68k/mm/sun3mmu.c b/arch/m68k/mm/sun3mmu.c
index 1ecf6bdd08bf..fdd69cc4240c 100644
--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -82,7 +82,7 @@ void __init paging_init(void)
 	current->mm = NULL;
 
 	/* memory sizing is a hack stolen from motorola.c..  hope it works for us */
-	max_zone_pfn[ZONE_DMA] = ((unsigned long)high_memory) >> PAGE_SHIFT;
+	arch_zone_limits_init(max_zone_pfn);
 
 	/* I really wish I knew why the following change made things better...  -- Sam */
 	free_area_init(max_zone_pfn);
-- 
2.51.0


