Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0ED6C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447B78E0134; Tue, 12 Aug 2025 09:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FBB8E00E5; Tue, 12 Aug 2025 09:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E3A8E0134; Tue, 12 Aug 2025 09:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF898E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:28:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEE57160324
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:28:28 +0000 (UTC)
X-FDA: 83768184696.26.5706B10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf23.hostedemail.com (Postfix) with ESMTP id F1A16140004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:28:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g/XAxlf+";
	spf=pass (imf23.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNbMRp4NAvF971szzz7CR/2vyv0vBk3AYCxV9Q+eZ04=;
	b=5D9IPLdHVKXlbqZIwtL5PpcvKE+kxwZBdDmGQ2rvvASm0kNZq0gMdWRcKWSo4asmRZExPe
	Sp5EJmQE+dydYKWZNhrhQLjTgoPHZi/RNkwzGH+ivOfwpCBVQVW2KNEeZ8VEhL04M7fnCG
	DSxd183tFXUxb7BQuBZRgFNA134wncM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005307; a=rsa-sha256;
	cv=none;
	b=hl3n2SKBL6JC+24FFap+t/PAWDbi49ob6suABNT0gCMJecPAVTmJkbJegb+zFY9Day/4BD
	4nCke7UMEp8mIGeU7OUgfRpgsynBnjfmn4nBqO14YwF3SgF9BzTa12oVzXD8hiWwevBHFp
	wyaCiDDyJOKdE9+juK3Cwc808b3F/1A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g/XAxlf+";
	spf=pass (imf23.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005308; x=1786541308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c7Af/YAFKCbSIcmDUGPF1EcBvvAVYWDWdLscrGxcJaU=;
  b=g/XAxlf+vEuQbbRNgE92VzIwo731A2Q3rwr9UR9iWcMp2qBKThXxAZgc
   rq10pjHuUzY716Hdra2r7YjurCmGxt2zg+IoeKYcMS3lghvIqTSPBq+Rz
   /E9Zx7m+zBCAL40EFZgzqKD+5oub2/L3u7SbSf+l8Cjr+ZEno5M3CKQU0
   U5bB5bxCMehNNi0mWb5M6flu9edMn07yavSgXrqc1z2kSl/lzuNeXT/+x
   i3lqsqIGUUqLWPtUYDe+jx+jwRE/s81OE+qqJpoi685E26ed+syr65rzu
   K8RPaHnvK7X+ffBc7OiMLwRYaGHv7IjVayGgi5nWTL1QWaKvYc5Ma9Z1m
   Q==;
X-CSE-ConnectionGUID: V9CamnhySqyonDRfJ5vcWQ==
X-CSE-MsgGUID: HEan9grYR+6eQBx3M/3eFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903638"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903638"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:28:26 -0700
X-CSE-ConnectionGUID: RvG1WbQvQdy6dQLlny3rTg==
X-CSE-MsgGUID: gCS5TnjYQ6isOtqp7VNDUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831505"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:28:02 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/18] x86: KASAN raw shadow memory PTE init
Date: Tue, 12 Aug 2025 15:23:45 +0200
Message-ID: <38129f9031dfefc3e9465a0bf06fd32256cdc157.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1A16140004
X-Stat-Signature: gojs1n7g4sehnru7j4f44qh6uspgqo8p
X-HE-Tag: 1755005306-315279
X-HE-Meta: U2FsdGVkX1+HrzNONYEAjfE3DJnIdH1X+y+iPu04pO0rA5IxPX+uObiJV7dot2mwEgUSOXnb2OAeD35eNayyocASpNqQb60a5+1w02pRKPScMNGceRPUfhe5rvikQ7NE63zqOQ8e73gUPBci0Hi72dI6Q3cDuCMweiO9XLqYH5i1wulNEpc7aeX8XcPUNl0OJF9kTN7hCyDd4jCxLit21moc/E4MkXaBdmJ4d/SXbb0fARU64Y2yBtuGYOVofE2vFIQLTteYugK80SXfeNU6/sD0B30ZESDSbEWrL06/FP8NfOEqTAZPy+pwqohOwOnHkMWeSJWA9m3ZsFSAu7F7AcEAuG7NwwASrxuDSSkB2eKda46eG0HphxhK5iXmtwagyXNA2oKVZxX1HC8U1MU4TgSju66oQ+l/HCuhgLpAG63gdxrGClm5grk2+VQDsQnHP8YYoeOcTlamko/HKsndPNXNzCD3V40uTK4hqygJd29IPpb0BgBKIiWwNQVCaPxCeYAK1EjJoDTFdSgX+FURV4QXJ+jFnU89ja+UUaRco88PRM5zhkqs/V7kYynlKZA2cC3EthSZplgCGhdujTfrmRKCySc+bVFlMDvHrEJQ78+MNeji34F0Sj80s3M71zCi9g/6cwu7klqkrHWhCPDvs6JoRAQuW6ywSPAVeXEPZFLSIXJyhQmExdicraxF4mr0rDW5o5C5uex9C1ZGC52s3nPujalIIe2E9q2LVcaIdYCrMSrDjmF82Rqif7f+SF6OtIWWzNRu+TMMUQTii0ZHx6xXMqXaSxwtLI9qAzV3k+kK1HY2i+0cUr/VcR2oL453r1ylljjQ1gndAyBXZuX/tvrbIfILYbUidmxE+IoqK468vMcVWGRtAGc762yc6KaWHIinSMi1QwwDwvneddWbwE7gKB9w9kCf4T8GzO1gzInMjfgAm9cejvauAHkh04t73utbEPU14fo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In KASAN's generic mode the default value in shadow memory is zero.
During initialization of shadow memory pages they are allocated and
zeroed.

In KASAN's tag-based mode the default tag for the arm64 architecture is
0xFE which corresponds to any memory that should not be accessed. On x86
(where tags are 4-bit wide instead of 8-bit wide) that tag is 0xE so
during the initializations all the bytes in shadow memory pages should
be filled with it.

Use memblock_alloc_try_nid_raw() instead of memblock_alloc_try_nid() to
avoid zeroing out the memory so it can be set with the KASAN invalid
tag.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v2:
- Remove dense mode references, use memset() instead of kasan_poison().

 arch/x86/mm/kasan_init_64.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0539efd0d216..e8a451cafc8c 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -34,6 +34,18 @@ static __init void *early_alloc(size_t size, int nid, bool should_panic)
 	return ptr;
 }
 
+static __init void *early_raw_alloc(size_t size, int nid, bool should_panic)
+{
+	void *ptr = memblock_alloc_try_nid_raw(size, size,
+			__pa(MAX_DMA_ADDRESS), MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+
+	if (!ptr && should_panic)
+		panic("%pS: Failed to allocate page, nid=%d from=%lx\n",
+		      (void *)_RET_IP_, nid, __pa(MAX_DMA_ADDRESS));
+
+	return ptr;
+}
+
 static void __init kasan_populate_pmd(pmd_t *pmd, unsigned long addr,
 				      unsigned long end, int nid)
 {
@@ -63,8 +75,9 @@ static void __init kasan_populate_pmd(pmd_t *pmd, unsigned long addr,
 		if (!pte_none(*pte))
 			continue;
 
-		p = early_alloc(PAGE_SIZE, nid, true);
-		entry = pfn_pte(PFN_DOWN(__pa(p)), PAGE_KERNEL);
+		p = early_raw_alloc(PAGE_SIZE, nid, true);
+		memset(p, PAGE_SIZE, KASAN_SHADOW_INIT);
+		entry = pfn_pte(PFN_DOWN(__pa_nodebug(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
@@ -436,7 +449,7 @@ void __init kasan_init(void)
 	 * it may contain some garbage. Now we can clear and write protect it,
 	 * since after the TLB flush no one should write to it.
 	 */
-	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
+	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	for (i = 0; i < PTRS_PER_PTE; i++) {
 		pte_t pte;
 		pgprot_t prot;
-- 
2.50.1


