Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19471C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630958E007C; Mon, 25 Aug 2025 16:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E12B8E0038; Mon, 25 Aug 2025 16:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9278E007C; Mon, 25 Aug 2025 16:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 362D08E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:31:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12D26B9E89
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:31:15 +0000 (UTC)
X-FDA: 83816424510.03.41012FB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id E991514000F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:31:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cbDXQGmi;
	spf=pass (imf23.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qByZNR5hO3dUXGXI9QaSwPLK/rlDhrexMNx3Hyo52Qk=;
	b=g3MODvJGWjGpEi1aDxz9AFVZq1r0OpmbYDH4IQifGB595XCm2BkeK8tiBbQGWHvOugy2om
	OYOcrqj2OaXVttRLGZGSuYLGMuvkE091Qz5+GcenkoNY2BkCUxSFthf9zpplOkOeElJuIc
	TfO5Vl38QZYOBP2+ihb9lxeOP2XFCpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153873; a=rsa-sha256;
	cv=none;
	b=T7QFSv/nFILlyA9U6FjCHMb1mw14oSDNAXa1Cv5Vi9ZqM0CTcvJ85TNOWCLM62AcjPHP/0
	I1V75kw398iHKOBrJABwSSlq5UPxkoLhnd6f2sgiq1U6ekioYEZKm00GSB2KGy0yuiPhv8
	4V63L056Dlup8oy3TRROTgD8LFxa7NU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cbDXQGmi;
	spf=pass (imf23.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153873; x=1787689873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J8CXiM6R9Pwi3hQrlGW0UyxoKzu/ihlIQqlipezAJ2A=;
  b=cbDXQGmii4cEiJVp8nXgo+j4WMvnr/kCGoDjBSgh2hPoPm6e/qGYwQCH
   F8yMdowvexuuUu0u2r6eRxvwfSQ7O7CSxwalweSTqTVwKZIpxtvGBjhWQ
   pCRFOr7/naetrI7DzNRXfsmH5Al8cSjaA1Uzgmkd/gkXaWwEf6nH6qI1P
   tOe1ylNISuKgTiRs0mRopUqHbQ3KPXbVC9eBecFESdcyJTjMO6owgJXCj
   YlXajNaWOYC1s6Hpyny2VtH0fzmLmi+c5g0s84rMtBtQPglADiyQaoVzb
   7G58YDa1nIqymm4VKpP+1qD3rwY57d2HnfQB/N9dVP8BIwniUEGG1ZZPh
   Q==;
X-CSE-ConnectionGUID: lgcGYhSRRgi3QWzfFPE5jQ==
X-CSE-MsgGUID: TDZ/17PCSu6YY8JA4TTopQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68971106"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68971106"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:31:11 -0700
X-CSE-ConnectionGUID: MQA+TzInQqevwz5W19OOTw==
X-CSE-MsgGUID: GAgjeP88RDmDgTZRoDSocQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780957"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:30:49 -0700
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
Subject: [PATCH v5 16/19] kasan: x86: Logical bit shift for kasan_mem_to_shadow
Date: Mon, 25 Aug 2025 22:24:41 +0200
Message-ID: <169510f5490cba60916b144398543a489c31e2c1.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E991514000F
X-Stat-Signature: n99dikh7aeg7ixjazsoxdq44jjyaggkw
X-Rspam-User: 
X-HE-Tag: 1756153872-381798
X-HE-Meta: U2FsdGVkX19k5cyDGkBOfvCqcansU/uxXJ2HNF6KYiWriFRwG6NeXbI/fqTCYxwyzRxe3/wBDaB46NR0xnuIvbTpBSyD955JAPhDPHtwoojqqaEUDpNoM3pdSw8qL4FlR9OxHRNTL4XwHmezFB3mfEALaP+nlQUgjxpuinkRnmz3LsNgMdzw9mrFUt32vziPipJZm6vcl8l5w15nl0JscR6BQwLPadiFhchmPDCJWBCxez3nwhaBegsbvcXsuogs8ZaWTY0kAyXZLsOA/rPQk5yjyXR01DrDOTnZL19FiX/j+CF/LnpENMmt4vH//iVSTY4NtKInrgAygyeFQIdov/tcA+2IaxDFq72n7OeDXast8t+Sav864iPs+3JZpjOcRnAItfF/fGdMzJQYOL+9/+jk9QUPlj+3bbS6TsjCJLkLSl2IyKPairy0xdl6hIShDtp6x+0l62st68mbm3P6tey9M4t8tP4dH2BoV2jqC5awXSCqRTmI17fuYGl+wIeP6sc/ldQhBv5WfymsY9iiZxlq1cv0dyHY24VRbd7T0nc1FGki6kELr5WUjKElGu21LcbGUc4JeE8eMwkLaXG9hQAuUv5b55eo469Zj2G22qqd2H5X0ZVmAPb6WqOwnUEMbHW4Ou03rDIHCy9BiKcvlxDvMD69XcTTZ2jgdfrdc+I97QRSwhR/wW5kRtBXF3bMikSWzmIZ4Gz+cuY8668z6R+Czp6meMoLAhd0Ht4/rJUbcb41u9MsZkQCfzPH2UKMberfmvR8x16FZ1utxtVRS1hMcUkPw+/feqYz2xfgNtywT5LpNzfzm2I0b3+ptXPJP+TMis2k1vUHTrRDS6KKuhIm17Y+aAmGNbD6dh1ZWsGbkeQqqGWUXuI7k+jpcvWqDoBEeClNKjQ+eB2HyebcF+Ww5ZnGnmB4gK0KMzOQi+xZcJ1ajWQp+ZI55VxnWOsX+LAClMq3adTyhzJRVlF
 7f1OI+ZT
 ilN+WRdVyHGJixSPGqwa9aPvI/j3nBRfwDHXIjzha25ajzBjGOdQzPDKaCagXdrA+skcAaIgxVMdibhIk48IMi7crSslukOamCl0IWapF+BABjSymIC0o+MddH0vQKeIIqab+Dz/ukXFwVDQhf1IIGgcak+H387NPYk74McicT95/mIxaNteYPD7n61P/Srs95RMmR2R87rNemSZJEiCwiTVM6Xm49+69j7eBxxPFNMOnA+6enFK2QNo9bJ97ZsP9DYMsubkfCt4k5v4oWxZMLV5d/3wP9pU28OzkAxnuycVr/BefVh01OPkEDSFVngF9qr5NSS56tF6j35r0e7cRYdgB3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While generally tag-based KASAN adopts an arithemitc bit shift to
convert a memory address to a shadow memory address, it doesn't work for
all cases on x86. Testing different shadow memory offsets proved that
either 4 or 5 level paging didn't work correctly or inline mode ran into
issues. Thus the best working scheme is the logical bit shift and
non-canonical shadow offset that x86 uses for generic KASAN, of course
adjusted for the increased granularity from 8 to 16 bytes.

Add an arch specific implementation of kasan_mem_to_shadow() that uses
the logical bit shift.

The non-canonical hook tries to calculate whether an address came from
kasan_mem_to_shadow(). First it checks whether this address fits into
the legal set of values possible to output from the mem to shadow
function.

Tie both generic and tag-based x86 KASAN modes to the address range
check associated with generic KASAN.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add this patch to the series.

 arch/x86/include/asm/kasan.h | 8 ++++++++
 mm/kasan/report.c            | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index 5bf38bb836e1..f3e34a9754d2 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -53,6 +53,14 @@
 
 #ifdef CONFIG_KASAN_SW_TAGS
 
+static inline void *__kasan_mem_to_shadow(const void *addr)
+{
+	return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
+		+ KASAN_SHADOW_OFFSET;
+}
+
+#define kasan_mem_to_shadow(addr)	__kasan_mem_to_shadow(addr)
+
 #define __tag_shifted(tag)		FIELD_PREP(GENMASK_ULL(60, 57), tag)
 #define __tag_reset(addr)		(sign_extend64((u64)(addr), 56))
 #define __tag_get(addr)			((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)addr))
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 9e830639e1b2..ee440ed1ecd3 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -648,13 +648,14 @@ void kasan_non_canonical_hook(unsigned long addr)
 	const char *bug_type;
 
 	/*
-	 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shift
+	 * For Generic KASAN and Software Tag-Based mode on the x86
+	 * architecture, kasan_mem_to_shadow() uses the logical right shift
 	 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
 	 * both x86 and arm64). Thus, the possible shadow addresses (even for
 	 * bogus pointers) belong to a single contiguous region that is the
 	 * result of kasan_mem_to_shadow() applied to the whole address space.
 	 */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) || IS_ENABLED(CONFIG_X86_64)) {
 		if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0UL)) ||
 		    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0UL)))
 			return;
-- 
2.50.1


