Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3624DCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826BB8E0075; Mon, 25 Aug 2025 16:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7738E0038; Mon, 25 Aug 2025 16:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F458E0075; Mon, 25 Aug 2025 16:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 520EA8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:28:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1705B842BA
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:28:43 +0000 (UTC)
X-FDA: 83816418126.22.A7263E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id D59131C000D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:28:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g3zxc8+R;
	spf=pass (imf20.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNbMRp4NAvF971szzz7CR/2vyv0vBk3AYCxV9Q+eZ04=;
	b=nQFMkTDpx1zZdQpV5erFLEQaK2GHz5Y2IrWd9B+r5Cv6QTl2py9oYmhN0NwAjNObCHmIYG
	iBPVEmcSYoiqK8jzrdLrpZ7QLhlf/J9stlyBric3E9WULG31O35yzZv7OAJhaubclHueb+
	tMVHr/bEjUZAHrdfr4BU2Tb+Ok46Skk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g3zxc8+R;
	spf=pass (imf20.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153721; a=rsa-sha256;
	cv=none;
	b=hscYJwmKqhDGvm/KA93c10/c1DgVTNNPBla+Ck9RiHVO3B3hpxW9H93HnSYIYQePEX2pJo
	GnR8OrUvfoIuc0fYaTf7iuXb+PewHYrVxGt+68bzcCcFvtPnZLf5HpWF5Cm5VMzRwPfqUG
	GrSEzAvJnYuqh7pOuHMMKU2MSUAW0Zc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153721; x=1787689721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c7Af/YAFKCbSIcmDUGPF1EcBvvAVYWDWdLscrGxcJaU=;
  b=g3zxc8+RGAjlkFtqP76vfOXW6VcCHTht8r/4FTw6Dg5S/9cOmaFIW9DJ
   c9kMIXAviNBDKCx9AFTv7BMq1WL0LN2q/9LCbfmwMkaC3BecvkBrqxA46
   E38TR0cq1uONtaI7Rm9+bgKeFsTrC5RrLgk2qSoMZ+NvbPqhABerzp+9O
   9UxXxKZuK2H5UYlNo3rpc5SH9Ubh0qpMXPJxGgr/RuDeyVaUFD36l69DO
   QxCdcwM0gIDXTrWvrvMaG9AmGDXwthNudYP1fvxXDCxfCjsuaEkKSa8dF
   n9JIr2Nk02bL2wOo384Y11BlIIz432li+Jk84vQ5HPhV3NjSFuLQBx862
   A==;
X-CSE-ConnectionGUID: KkNaI7E+TNmZ1CulPUPCSQ==
X-CSE-MsgGUID: isoK9JiWR6Wzm/x8vTJXRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970664"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970664"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:28:39 -0700
X-CSE-ConnectionGUID: ZdrF+c9oTnqXBOaj3/bbCw==
X-CSE-MsgGUID: b88EEwdzTV2GCqGXKxP8lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780469"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:28:20 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 09/19] x86: KASAN raw shadow memory PTE init
Date: Mon, 25 Aug 2025 22:24:34 +0200
Message-ID: <9a7958543abababa30d534c44ba2f26d6bd692d6.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ego16egjhtfjyctk6kokgjgugm4ypxhm
X-Rspam-User: 
X-Rspamd-Queue-Id: D59131C000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756153720-381723
X-HE-Meta: U2FsdGVkX1/33KEQ81ZI2xPe9WvyDf91SAmLkgDor0tdXBAjN23yFFQOSCwFkued4lLkAvz8w4G1uvKnH+LcUh6ACrH2hdYWegwlX93JrelckeltRqMi3L7H9djOVh6vOGTaOPPy0LuG9paQdfNY6V4CLFOjce/DFyVfg9d49+/uR+5ZO3ht7inqUExc/4BQoYFWeSPHhNLZLaLU1OgkOLMImR6uAAWSrSNqT0gT6+WB8vlsqqPJppu+MVKH+R4o7CE83IQ8zyLIrt7XA6Uj1OaX4Eqt964zdHDiD5EGqbhqL2EIvroBtPMbaHatFl8mFHBjKCb3q1JrzRbU9xlcbVI63BRmDQnvdSMdx+Bv1GVVIwmYsx+IVweDzzCo3mqUZWd2W8N4tKfbjdHtCW34mgZ22lfjmmtUxz5pe69lDpw2U7NGXSTaDK30G4o28RcuEWMMwKeD9OVTHKmIm5tfCo047j3aTsZWw9Af3/HAGYuK/PlmfyrE0PXQ3AzXXforcpTCi9cjWWvC9yHDESavdfG5UpZR9V28RBkpkeo9LrheVw3SdFwWQAXCsd2h6ngFGnN6zAhoqFjcRJM5zGMGpqgTnHTvRnJE3/tBMJEiO2P24A3NWWMDQVH/XFwFGZNfIcJPlKMQNvxNgDgePueyHhEBq/XqtG6u9M4bLczBte1W2ShYVgEzsQu3qR68ejuaHInT1NMsDF5EeHDcocj/ObH4IOJ9IpN9ut4IA6HQHJb6rO+0cPkpTuA+IQgq11DuE2CuLAcAdwML3iIkPdSvWKY9M5I1d0kVPOnsaRRq0oN6ujTfeWRgbiU5wlNtGlQksL1pP4SaM7LovIxJC1huG+SNsAS9S6ftuG6D3SAswgPAOk4p/B/eYIL8+r7A9m7F+9U4Ef99eLevCIrxEmBCfMzteuovR5Pzukf2BX72QGk73NVl/zBcJ+PrW/bxaGiTI7RgDYD1d7zXoRrQ1Qz
 IErJDbOF
 3TCCszkxgxtbejP7wFYE07x/jKDMr8QYWS2OP9xQnQPJh3ZXcgA6UgI2IYe225MgPgzz2x7kQXAXKKUyjDxSS/sSbovY68zT2CT1CBqyxAJyxVERXpE3X5lDuRFZ0drhOPFV5U/pAG4XcmcBrPQRevspz72esrbAPRTpcvpgCpe7gia0W/WfcbA/gUtaMwV5UwUw9XMlaU2SltPHyFUKP4Swn4OahMiA2DXKGcPn6QApqR3wn88db2A5T2YqJBFZWylC+
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


