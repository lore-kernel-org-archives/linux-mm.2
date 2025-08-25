Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CABC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872F68E0072; Mon, 25 Aug 2025 16:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823F88E0038; Mon, 25 Aug 2025 16:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C58A8E0072; Mon, 25 Aug 2025 16:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545BA8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:27:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F100118B03
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:27:42 +0000 (UTC)
X-FDA: 83816415564.08.59F1E34
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id D962D40004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:27:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gmkAaZbK;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvLwRIAhBi7gRgPiOgwd9SrdmrLVz29BtT7bdQhwA2w=;
	b=Qmpgzo17ZwTG72iZHvi1EKdOJ+AJ7ISyQDQo+Tzaa9Hlx5uu9Xyg2LjAE5jr0eH2tGIqhd
	wfjbR0h1iwT7GO6N8V8gJEjy2CS/Mxs6kMCH+H4T3kqeHRqGl8ar4FQnJloavc1DU0gnAV
	eXL7hg8F1c3MCmt7xZWwMZCszbsegms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153660; a=rsa-sha256;
	cv=none;
	b=Rum8Yp6wK5/AeRXW8N8LLCn1ROr8X8rinrRipJyhOAC6LZwDk4ghU6nxb9PWn/FEW95vpD
	iQ3Hdq8UseGFbi9HnGshQ73ChgyMwbZhr0HulUuYeNTXrqJ9n5cjr9/xa6ctCi/pu2gZGz
	d3UN6+yaoR/s5Ekh7dt4NhovrumevIU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gmkAaZbK;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153660; x=1787689660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9btPod/IO2FaFXfiYLwQ5U98OelzVVYGtVTnU0SMiM=;
  b=gmkAaZbKzCia38IVe5jubx7gFImaxof0cf3dOSkS2kNe+pZtI/Thz+dn
   hZZ5Vp4FcZfznJuuTRD9ErGyeHkQyjqaXvr2By5lkUUc32QcuI+zCejdg
   dduKs7H32VpgWZzhSbGD4AkpE2HskKCMMv2isg/C+/2R75JnTTNVx+lkU
   4jem98ozgwEDzR7t2sMdjCqSyxwGYWBcs2xbgAm7UvY2cWMukCmtxQur4
   M/0y+1weLeaAlDv5hVA9Bl7/TWbz38tLcIbewsACv+3FziPioQHhpK3xp
   4Wvgy7gNqjfOChCh/zD46F243Zy40XdDr6tIQYtKfR+dKPtS+9psHMYns
   A==;
X-CSE-ConnectionGUID: 2bPRiviIRamUyvmziYGY4w==
X-CSE-MsgGUID: FIJgwyJaRYub5XIWyM/UMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970518"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970518"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:27:38 -0700
X-CSE-ConnectionGUID: 88rMVBboREqinEplSn4Mdw==
X-CSE-MsgGUID: 3rIVdVdjQ/akH62ekpclSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780355"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:27:19 -0700
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
Subject: [PATCH v5 06/19] x86: Reset tag for virtual to physical address conversions
Date: Mon, 25 Aug 2025 22:24:31 +0200
Message-ID: <462dc78d4d986007e82c12ad57bb6b11f85b19a1.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D962D40004
X-Stat-Signature: co753gtphpkw6wtd7o37do6zjphgxkq8
X-HE-Tag: 1756153659-629753
X-HE-Meta: U2FsdGVkX1/qMHzYby5z9HkkNbjv/NgzaMzxky1d6hcf3zEwxzX6YpmJZLmZQ5W6UcNKhZFRK4PRBJkiA6PWzDNSRUdrXaerf3uTLMjcBUhD15Am2UByeDer/oaLXWvsIaAo10gV32++bbqGIM5FJKwvsCkMstGpWdQ3oXGCYzv0tO0rwxb3IYKslX0rfUMACXkfbJReqfS64Vk5YAt6VGOqhp0SGUpJPZfGSroRS5X8DEJAhUMMh4cWqUh+ghHUSPd/jOkfduiFqcx6U1aLPymudNupHn9Pn2YC/RgEUkE+I6asL+hX36jqsxx9iZxO+1uP2XtWtlJ1MhioWiIZ/tU9+RgB+UP3nSeOJkdo5S+26Bz2ALcghoWMPjgFRPFaY92lInYqnZlZyiCcdKJshdOVwAoIrY2lj/LKREkUV6UzKaBXGglDRf9NPnRYSS2b7CMdBhEMqkH4un2qV0l6Cn6Dc/j2+JnIL9HQujAIscjcqWCJbxuZ8/eAXDVBwqx3QAfgEt7HqzPZu1MGzZvkB/T6u0X2RZPePHrFNI+XBvlYOLi1Q7SpNEcISEsrRDCK9xL/BMDe2xq50wI3azSELoxWkIO39hgFAJF4DpGgdPs9xltHWPzlOKaIDr7IvFkQAIDby1W57H7W3Mo3CzpdYQ3C9FxoqibrbFXNCPisIYZEYr6WRl+lPDeFNf908VOJqL3K8S6fncq1AM7/rbC1qddRb6s3JBxdG8gXtc9knq6BjKc0WPK1bbx+Mur8nCvSYnt3gQtgZhkkJb1bWsYUuuGLvMVsvC24enZP3U1jptJio14lGN0ICe4HzrS2wNcfm/VCY4G0FLarHxrLQn2IFEq1iyVK1NOQLRAsqorHRouZxFjnHRVh3rEgy671COcivI7pd/r+H1+aeEXtG9LDQd5DM5mhMvP4KDg1msKhU8SePzqXA7Fqz8vTYaJd+LRyeikiQfp93cutCGhzFzk
 Ev6IgNNF
 A8k2vcPcpA9ClDSMkpbHMuRgvPZEpUXHqNeWGDkBMBaff5Wf1ngrwyA7mSWUsblz/ZsVHpl8XgOmiQqmUAnTeV+NbzMZ2RNBR16RB5M5EFvATm1qKwMLRFRkKAdBQMoPxhp7hXDYiv+xB86aSkTRDCugYSsu4dwvd7HxdKBx7fpVAQbKDZAAzBerkL/yd3cJb9R9oC7xTFyF1bmljbKTJdih+6gwtmk7RlphDTvg/50lQoz0AIrEd9Rd9mobb69pY2YeL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any place where pointer arithmetic is used to convert a virtual address
into a physical one can raise errors if the virtual address is tagged.

Reset the pointer's tag by sign extending the tag bits in macros that do
pointer arithmetic in address conversions. There will be no change in
compiled code with KASAN disabled since the compiler will optimize the
__tag_reset() out.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v5:
- Move __tag_reset() calls into __phys_addr_nodebug() and
  __virt_addr_valid() instead of calling it on the arguments of higher
  level functions.

Changelog v4:
- Simplify page_to_virt() by removing pointless casts.
- Remove change in __is_canonical_address() because it's taken care of
  in a later patch due to a LAM compatible definition of canonical.

 arch/x86/include/asm/page.h    | 8 ++++++++
 arch/x86/include/asm/page_64.h | 1 +
 arch/x86/mm/physaddr.c         | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..bcf5cad3da36 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -7,6 +7,7 @@
 #ifdef __KERNEL__
 
 #include <asm/page_types.h>
+#include <asm/kasan.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/page_64.h>
@@ -65,6 +66,13 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
  * virt_to_page(kaddr) returns a valid pointer if and only if
  * virt_addr_valid(kaddr) returns true.
  */
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define page_to_virt(x) ({							\
+	void *__addr = __va(page_to_pfn((struct page *)x) << PAGE_SHIFT);	\
+	__tag_set(__addr, page_kasan_tag(x));					\
+})
+#endif
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 extern bool __virt_addr_valid(unsigned long kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 015d23f3e01f..b18fef43dd34 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -21,6 +21,7 @@ extern unsigned long direct_map_physmem_end;
 
 static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
+	x = __tag_reset(x);
 	unsigned long y = x - __START_KERNEL_map;
 
 	/* use the carry flag to determine if x was < __START_KERNEL_map */
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index fc3f3d3e2ef2..d6aa3589c798 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -14,6 +14,7 @@
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
+	x = __tag_reset(x);
 	unsigned long y = x - __START_KERNEL_map;
 
 	/* use the carry flag to determine if x was < __START_KERNEL_map */
@@ -46,6 +47,7 @@ EXPORT_SYMBOL(__phys_addr_symbol);
 
 bool __virt_addr_valid(unsigned long x)
 {
+	x = __tag_reset(x);
 	unsigned long y = x - __START_KERNEL_map;
 
 	/* use the carry flag to determine if x was < __START_KERNEL_map */
-- 
2.50.1


