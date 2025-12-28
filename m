Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F10F0E92724
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0976B009E; Sun, 28 Dec 2025 07:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB2B6B00A0; Sun, 28 Dec 2025 07:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB5B6B00A1; Sun, 28 Dec 2025 07:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1E46B009E
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:42:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF4D6ED8B6
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:17 +0000 (UTC)
X-FDA: 84268842714.26.245A13F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6368840006
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:42:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JG4fyb9H;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJatOTiXEPNp/W52LlXUaW1EIsFN/BNV7MmBuJg1xZQ=;
	b=BabqitI074NuMQM6vVmSBj6py4AsvrZIlXZtDIMp+hdTlnJfuWnG97jduww1Fl2JCsyN3z
	XSvkPzYzrC5xCzPwQCMnwzW3+32zXNLayW1XmoDn9cvSH1ZLLE7LF/SLCNfwC0/QRxGMWL
	usCESKTmSLTarMtsKuf3iV4UJzLTtD4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JG4fyb9H;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925736; a=rsa-sha256;
	cv=none;
	b=kFsqXLwKOkmhq8usoaQSAdEOu17KsVCHN22vMipG9MBJyb6SYrfMuGu6ugHfOY7Vwx7CpN
	1uzhJWiVechPtJ/aUWfYM7PhjBNHV7fXWbP/NTqKEkyHDyAjLD3TIltHhRjV9XsvNDJxmG
	B/pW9PQ55Tw7xK7VNuLZmUljQOjkm3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2E26439B6;
	Sun, 28 Dec 2025 12:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C9AC16AAE;
	Sun, 28 Dec 2025 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925735;
	bh=qGV3crV7vYfN1DCsmhF37VWmOXuApg3MmNmGXJVotqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JG4fyb9He83CXx9yabJ1wYRs95IfVNB2F586zi15zCd1oNMacH+6znZ+ceKQNfrjx
	 +eEr/AdmSp+H6pVP0U+08wQCx51U84RT2GE26vxy/u14qcmZxaO7/IU/klSevnk8lA
	 vM0pVSQsLZxPglXSMVb7/hD3lm54KyOTx//USUlQkU1glusRU8S4mDrDjLgXCn7xSo
	 DKDwYDHlsd1BLmX8x4wKtXILnIiP77e+5+1B+TOY7FeKhNOo3J1JwxAr29ouMLQoI+
	 5rsEd2gotTkEQ5pwtj0IiqueuPgvAF9w6W+R0W7LI3FnHuera9SImC6lMLPkR6NFTL
	 hrnrQ8sndZQKA==
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
Subject: [PATCH 08/28] m68k: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:38 +0200
Message-ID: <20251228124001.3624742-9-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: et38bfgjg8tw4xguutgpjpq94r6kztth
X-Rspam-User: 
X-Rspamd-Queue-Id: 6368840006
X-HE-Tag: 1766925736-150028
X-HE-Meta: U2FsdGVkX19st2q4lWwpL4IxWQTRF2PWmrBYJKhJ61cRkpzExuO/IFzwv56+5WIxEmvzWRq3wBdMAnHOPUgwYW3+xKhh+5DyUqFC0vPaWOPQLfW1jNWXXM1WEdv3gugTdgjzzcU+4qod780tpSSfwMxm7hy7Kid0xE+VuIr4Eh0JUB9Ubxm/07V0XUyV8xXsIWC0IH6fdXhfcIEJqTpBNgcxePNIWgDw/TXdOsaZ6LEWKkl9w5lZ1BluKcTNXoRImBnRh/WwV5ERVbGCrFRNdgTx8ZX9RNsR9QMnSM8c9s0+jBJ66Cc6PKmGJ6jenHHRJxSpdD9TtekZ8mSr+6iBz70nbyE2460r26E4qV5uvwB7piEW9hcRiT7YUjYq4gqzaVH/9N1Q5mCDODvBRQEP+aMAC8I/QSModNu2HXz5ZpkJoP2orMa/CpJmSEydse86uDEg8VDmftc282S5GqT4yIU/MDRmpbh5L3ZEB6r4oJtKZTN4hbsOltJABRo5qqMTVPZKf5VzZ5Xq/NRhx+vSB0AM9WuZ8V8igV1x7ZPlhQnyYixVFB1UGpMn52+Qz5dDMv+zi7z//r1nrJDFHHKD7aYnZT2ehh87oAKcMoLHhpVxbEEOCwNQ+guZA/5YUkkfM8PB0eOtyY/NEe3piV62n6dXugq88cmKsX+8DxwJLPKZNq5tyT1QlL3hwkxZjgd2Ja/ECNaKvhIV6pnqEPM9H5aC/ahhlerQbYFtOhAlfHB/Jqn/lQhIfbaimxN6RxdSP9jhI1h5tXAMHw53VA6QfWFVXmko7xSey+rJwnn9Ovaw40029SJzWraoAXXY0tyNz541yJihEVBI+HISgLYchFv3y6Je+YVjOKnTNYdudohcDZUk+Z0g4wUMW0bpfI3ZLPUDin6blWXxZKGbBTLcy09wQREqh3Y2QxXSPuBbLLmiECEiBH4zKdDgzq7EhPkOiOGwq1nq7jXxACFCe1I
 vm5y80WK
 HyNyz
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


