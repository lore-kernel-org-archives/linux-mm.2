Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B67CD59D71
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 16:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAE26B0008; Fri, 12 Dec 2025 11:18:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2516B000A; Fri, 12 Dec 2025 11:18:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8D36B000C; Fri, 12 Dec 2025 11:18:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDA836B0008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:18:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73F49140224
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:18:53 +0000 (UTC)
X-FDA: 84211327746.24.9730EC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id AE336140014
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 16:18:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765556331; a=rsa-sha256;
	cv=none;
	b=otaY7BaNH4i+I/RuUZzf0EiOQ+IlZn6J8/0QzSmEmzGflb1Xk5UB7LmmKunHlE3YZV07Ns
	q8VZBtFNXjq1hYFK3GxEwdvBOI/bf12f7nL6ZPZYnu3W1etjXnml1xGoyKJlliBY9ZJquW
	Lbf2GFtGlvalspWCBKUrvX2/UU8yzpw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765556331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7CziZgx+9HCd1BDJXjJel6IzSJfW897C201ynhyS8o=;
	b=cz5UKzp/nOE/KBTZqI4EVbYrCkPfwzjr39/cSlgn8Jsd07ID/P3bfPjBx4tMTu+pz30vkk
	uS4eAk18ABL94eP8/ZvsKC/8j04NEX4tLIeEYkH7a/H1PM8+Fj66MpNRtX0tQgXgJ3Xav2
	WoBYS/go2Of4PuPVcqIhenl/hYmCPHs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81B46165C;
	Fri, 12 Dec 2025 08:18:43 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AC4203F762;
	Fri, 12 Dec 2025 08:18:45 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	kevin.brodsky@arm.com,
	dev.jain@arm.com,
	yang@os.amperecomputing.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
Date: Fri, 12 Dec 2025 16:18:32 +0000
Message-Id: <20251212161832.2067134-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251212161832.2067134-1-yeoreum.yun@arm.com>
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE336140014
X-Stat-Signature: iibb6azr1wsjc6a8yhezszcr9kskjju7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765556331-129318
X-HE-Meta: U2FsdGVkX1+KSVR4rBZkK6m6EubKwD/esG//VgJykWD79DHglHwVAfC5LSPw65a4oEjdcDs0wnQxNE9htqh2IR0uay457wmiIM76gl8LLI1P1CnkTVu5lOKeVeBPD1f95YTsqcO/G/iTGDSyJXbP1LBKjcQHoMuOW9/xtVqUr3uez1Cs9BTJQdeOeYHABONQYSMvv/hhPyGtr6/9z1QLRiOEKzXGoFJmj049AhqWurC5sgKIwPc9Z98UbbwLj7Q/bwlDlsO9zDWbN50DnFo/OBHlMA0d6ihVy+REi2juVsBcybmlpeVRgFwqBW4YESaFYIzZAs8zrExpdbD7lHkDwv7qWfHDblF8wHahkMaQ1XQU5qti5OboOcYhThLLHmm1hjws4cdi4uXsdjl3Ie1yz5DSRNzaoJl/k2XcJmQMIBBs/w8+SV0jU++GChp3beK8xUSnNV2Bhp00QeGb4tXqqP49fbQ/4e4trxVmbPaQ147yEErx9ARq5oSchQX5TZhecOvYrpmDgjheluy45j/qbuAgvBJw8CbCYtY1u/gVm2BqJFvDscbfvSFxezeP9d77CSTi6TJ9Rq66XZefGPS/FjS2TjG0ON7FAx5mS8kOtH7B2I/jdmiSxjxsFOgObmPjuncau+z3sESwr2DNLdpSBa+3dJh/e6f+EUqcqiImQYVrLxJr6g4kyicqxMswop0d34vgbPLaRFKXwd1+DWkIK+IjoIGaLQMWMCuf0xJm4dNm0rJ3w55mx2JSeKW7CfyXca6gYvGcJ2j/8o67kTJWZv/SbpfP2B5sYqCtRNV0y3SSGlyr/adNuUX/dncZkB0STleWwbKjsopquxLnYgT8DK8BZ7jmctW/QueFzw7xPCOHApF+48tjXTkluovkF1Kd+/7/icbrnDteSuIFSaWDjzlfzUpL/7NUO7sGX0haaW7pjkdWpf9BvdBRvjsfbGsoLeDn7+atDLFfeNfKvFM
 D3cQkRPq
 cYXeI4hbhZguEAJeMs5Jawfe5JvmP4z1T8Fk6Eb3c0LXEhCLWkFpncr50jNXWaDic4RBCMk8bfbf9Y3btk8jMv94iacESRBwp6u+P9MlBCFCrKAxtwHZXRR/1795EOwh7Nh22hot8e1FBoxBXHKxFIbbS0xyR6+4ELYoE3fc+wNuEvPVX5LN+NT/fVhIUc1tYgeEUwOAz1AZAeSeOX8dep/ewDfnpzuv4eRuSI7Rz/lVd5lrLOsI/LZRjk65TgVSDHqE4AehuE0HPP2NDVmqDy4E43A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

linear_map_split_to_ptes() and __kpti_install_ng_mappings()
are called as callback of stop_machine().
That means these functions context are preemption disabled.

Unfortunately, under PREEMPT_RT, the pagetable_alloc() or
__get_free_pages() couldn't be called in this context
since spin lock that becomes sleepable on RT,
potentially causing a sleep during page allocation.

To address this, pagetable_alloc_nolock().

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/mm/mmu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2ba01dc8ef82..0e98606d8c4c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -475,10 +475,15 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
 				       enum pgtable_type pgtable_type)
 {
-	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
-	struct ptdesc *ptdesc = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
+	struct ptdesc *ptdesc;
 	phys_addr_t pa;
 
+	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
+	if (gfpflags_allow_spinning(gfp))
+		ptdesc  = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
+	else
+		ptdesc  = pagetable_alloc_nolock(gfp & ~__GFP_ZERO, 0);
+
 	if (!ptdesc)
 		return INVALID_PHYS_ADDR;
 
@@ -869,6 +874,7 @@ static int __init linear_map_split_to_ptes(void *__unused)
 		unsigned long kstart = (unsigned long)lm_alias(_stext);
 		unsigned long kend = (unsigned long)lm_alias(__init_begin);
 		int ret;
+		gfp_t gfp = IS_ENABLED(CONFIG_PREEMPT_RT) ? __GFP_HIGH : GFP_ATOMIC;
 
 		/*
 		 * Wait for all secondary CPUs to be put into the waiting area.
@@ -881,9 +887,9 @@ static int __init linear_map_split_to_ptes(void *__unused)
 		 * PTE. The kernel alias remains static throughout runtime so
 		 * can continue to be safely mapped with large mappings.
 		 */
-		ret = range_split_to_ptes(lstart, kstart, GFP_ATOMIC);
+		ret = range_split_to_ptes(lstart, kstart, gfp);
 		if (!ret)
-			ret = range_split_to_ptes(kend, lend, GFP_ATOMIC);
+			ret = range_split_to_ptes(kend, lend, gfp);
 		if (ret)
 			panic("Failed to split linear map\n");
 		flush_tlb_kernel_range(lstart, lend);
@@ -1207,7 +1213,14 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 	remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
 
 	if (!cpu) {
-		alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
+		if (IS_ENABLED(CONFIG_PREEMPT_RT))
+			alloc = (u64) pagetable_alloc_nolock(__GFP_HIGH | __GFP_ZERO, order);
+		else
+			alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
+
+		if (!alloc)
+			panic("Failed to alloc kpti_ng_pgd\n");
+
 		kpti_ng_temp_pgd = (pgd_t *)(alloc + (levels - 1) * PAGE_SIZE);
 		kpti_ng_temp_alloc = kpti_ng_temp_pgd_pa = __pa(kpti_ng_temp_pgd);
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


