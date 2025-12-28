Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0104DE9272A
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5245A6B008A; Sun, 28 Dec 2025 07:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF466B008C; Sun, 28 Dec 2025 07:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0306B0092; Sun, 28 Dec 2025 07:40:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 274376B008A
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:40:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F7CBBE685
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:40:54 +0000 (UTC)
X-FDA: 84268839228.18.CCAF02A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6925780008
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:40:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhVU7m6a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766925652; a=rsa-sha256;
	cv=none;
	b=uNSpBaSPKKoY6U7+cE9A1EfRfKaIT3+Xomt6VU7a6FbdjnXCQFStCAKEZb2ARTHH1r4Dij
	uBR3x7fgLfRNPXyyQShqFV2QaUVakcjEnS8Q2a8ERJszkASw02ZqCN+dWJDTogurTkt7XY
	fcoAQ1ruDqLa363dhsRpkF8om8szG8s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhVU7m6a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766925652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5gBzVEKGZBYJG6a1xNcNq9/H+kuM96Zeopb+7R3cQ8=;
	b=YI6NEs6DQJ2iaNvUPqpd+5yMzfop9cUS+RYjo3b3m4nA0he0aoLTRVCzfJtlGwxh1gliPt
	wqfsCTH1Cm8SiO09RWekSCpfzjQWHEJE84M16Hge10yD3jBkIgoZ+6rlNVRVvOkNCCcBGu
	8ZHbwB8DPMpIDwWLWEjwLILWX0dz8tE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D0454098F;
	Sun, 28 Dec 2025 12:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAFFC4CEFB;
	Sun, 28 Dec 2025 12:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766925651;
	bh=2qjSzGfqzjt078/1pNLigg8dFf1Az5AvC+tppJFEDck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhVU7m6aMNTawbMgUYHYAGWf8tGvLDWJQnrYR9M9iZEDtX9rUa6AkiSPgLsKGpHEu
	 yqhg7rauWEgFfzeSjajMBB35m0wYexkotTqL86Fr8KzxxLKjSPwpwTRy6/ZU+JswRx
	 w9CA4wIctpL+HLRH8FdDCR/Zi/H28EoHxdzHxR/0KwaQ3XnPArjAXjmL6/E3kX3KCA
	 hRlv0cjWbs2iPZsWPWQkiY1piHErzRLSCgcfsrlIPlkZiX+FNt7Y9rx+tUYQd81TYz
	 ZDGhdTCcXHwVcM7pnnpQz7HoCD2XoFV9cVUbPQqPJaOgkDuhJ6/H1rQE7Q5NtaHsre
	 Dfp85vgM1xv/A==
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
Subject: [PATCH 02/28] arc: introduce arch_zone_limits_init()
Date: Sun, 28 Dec 2025 14:39:32 +0200
Message-ID: <20251228124001.3624742-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6925780008
X-Rspamd-Server: rspam10
X-Stat-Signature: 3k9it55jmphs9p6wqosbrntpe6nnfz31
X-HE-Tag: 1766925652-701950
X-HE-Meta: U2FsdGVkX1+R+rqcWFIARET1xBV3F9jv1eCI4xFa4++lh1XMXIptoP3VLbSOmBl+CfHXHho+Z3UnjM/V3BEOzkBm0kQdaIYKXikcBGO8Mlr1UvkfvE07twpmdox4BOzJO0WO7wW6Ih2FmxuxAeq8OFLJIwoTb4LqfEqBlVh2G0SMu0gm5WUVnl4j++EGMSuQiDMUb7PzWrKl6Hji3oIYeFzCaqmiJJNkzcn+Rgk54vQU0VQfd9PDHG7EohEjgrreTjeLwwIYiPX6A3EOzmClDpgAFlWN2kTUsUUJdOMX8l82iXU7FFq8K2HWVehni4I3BlrAutXLT9Br3YSkUGAFE17Tf1+ViAUW38XQxCbU/0Zwec+bQsybYdRsTBjQj+iT887+yhHFKFI+LRmGW2wy4MdbEaMMq9DI0shk593/ScniZv5ZUncF+N+Pv5fu5hEmTSN5qIktBxPezTBpoS8+HZnGk+WYO8aIb5buNCxtaeECt/eRgOwU1G4I4Ine2z6AQaD2NYZbIXaFR/cMVwd6LoYvBI0B9NQR5/i6saFZ9wrJ9nLlyyImfmHnQdqlszCcatIMTbmPeEDtjtbGB16BHv0zS8ej5eQD0f7LS1L49JQgSKxUUh231FyDVzCyDs5W+op5QDplp2gQRY3AhqrsCq8TRP6WoPe1T3gm78BGmk2xT7WafNkCvIyFD1Ay2vrYllPBmHnWeRCEpq7t5oBx9sgq4SNDwdnIMD0xwQmv7Z2kHXWUIHAZwSfoUNxtUIaZx9GrTVplVCWEiv8yjHIdnNzX07wKr3GRY5/2LX7sEaOcC/YjiafcnrHHv8nJKchbZayEfLi2Ap34/A/5Q7nih0iQUPyPo/FFKpOtVvxMpRZmroMj4qcQD8jEaMJ5hVIjmtlZdfq9+S2OdKOxbwOTwgvlg32L0iCyjEPsoTDAYps3VY1pSXCL1RUhowkcBm5FFlv8KbKkEoWOT353K3R
 8uvV9tsM
 pJazZK5L6qB2/gF2tVruXV9aEDxxVahKtva/KpYTRbUAgFq+6PsA3PE2UXH/SbGbbOOC8tlEx6NJP6TE9TTK8zuPRVUYG92B/FL/iID0m7Mbn1HXkNqKxhffSd0GoBD8Eo5kPIC2otYoLaTpJa28DoxRRQiWIwyAe5+SdQsvvQQEvbe3oNVRDtPPSvRlF8F2Lhgced2+mxfhVwMSVw8e0+jWQhBTTK9rRiwlv62kKImSrwrCK8+CnEd/HzPT7MStcAffdEOwsrNKRTbe+7rQ9l1SSOw==
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
 arch/arc/mm/init.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index a73cc94f806e..ff7974d38011 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -75,6 +75,25 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 		base, TO_MB(size), !in_use ? "Not used":"");
 }
 
+void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
+{
+	/*----------------- node/zones setup --------------------------*/
+	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
+	 * For HIGHMEM without PAE max_high_pfn should be less than
+	 * min_low_pfn to guarantee that these two regions don't overlap.
+	 * For PAE case highmem is greater than lowmem, so it is natural
+	 * to use max_high_pfn.
+	 *
+	 * In both cases, holes should be handled by pfn_valid().
+	 */
+	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
+#endif
+}
+
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
@@ -122,9 +141,6 @@ void __init setup_arch_memory(void)
 
 	memblock_dump_all();
 
-	/*----------------- node/zones setup --------------------------*/
-	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
-
 #ifdef CONFIG_HIGHMEM
 	/*
 	 * On ARC (w/o PAE) HIGHMEM addresses are actually smaller (0 based)
@@ -139,21 +155,11 @@ void __init setup_arch_memory(void)
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
 
-	/*
-	 * max_high_pfn should be ok here for both HIGHMEM and HIGHMEM+PAE.
-	 * For HIGHMEM without PAE max_high_pfn should be less than
-	 * min_low_pfn to guarantee that these two regions don't overlap.
-	 * For PAE case highmem is greater than lowmem, so it is natural
-	 * to use max_high_pfn.
-	 *
-	 * In both cases, holes should be handled by pfn_valid().
-	 */
-	max_zone_pfn[ZONE_HIGHMEM] = max_high_pfn;
-
 	arch_pfn_offset = min(min_low_pfn, min_high_pfn);
 	kmap_init();
 #endif /* CONFIG_HIGHMEM */
 
+	arch_zone_limits_init(max_zone_pfn);
 	free_area_init(max_zone_pfn);
 }
 
-- 
2.51.0


