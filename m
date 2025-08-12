Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CDECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD9E8E0131; Tue, 12 Aug 2025 09:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAB78E00E5; Tue, 12 Aug 2025 09:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDB68E0131; Tue, 12 Aug 2025 09:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 646808E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAAF582204
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:19 +0000 (UTC)
X-FDA: 83768181798.04.01B6FEC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id B804A4000F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fo0Vm+Cg;
	spf=pass (imf27.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K2KDerpzPX7U8bmSLlP0LUJqVmYwFaKvvwSlmusGeg=;
	b=dXn2fcwHd81TGgU1aLvS9bXufGdq1LDvVd8wzQ4/sExHzcA6EcdEJZXec/mKvC+xlQEZZ/
	c0KxAqU+dgzUo3Y/HcAepGItC/aSqlpLC8tO0mDsLa6TCW9v8dya3Qyl8iQ7bAuG/Lp+93
	HXDhCa2xiFprDY/48rL4aVKcG65bakA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005238; a=rsa-sha256;
	cv=none;
	b=NZS8An8ywA3TZMMxV/i8FxbtNqWkIws0P17OQFtOIhM2J9aGALEhoJqSx/CDRpvWB3Ja1+
	8Cd0WO2Zid9ciu7dubbXHarO+ridzK1K171ugU3IJulBGvO6MTHc4G1jHc9UMm9Gn8tHqq
	vUgH5UgomxPBpZj1gkXJkroh3lco77Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fo0Vm+Cg;
	spf=pass (imf27.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005238; x=1786541238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a8brDXoNQXGsX0O3+U1wqzz6qH0YVwQ2IYUmoUvYEIA=;
  b=Fo0Vm+Cgv2xRxiSOTgYYPQfWq5G2niXASlxfNuFP0Jk35f8B13CnHJVp
   chtRalOYmYbcJ3wPD+hEDoeuH8fOAYZ/D5EKQz3ufU1S3nySYIUN3kaf8
   5xFdY09ItYwfqyMLGciDkX9cVwuvtK4B9+ZtGyN9DgEdE1QHOxck1cGxU
   mh0h67u2/6vzqVo8zwnW4hYyA8zTCBTencL+9sH15nZwjxqgzu2XNOy44
   F7WDDQCS+eKjGx4eAQOPpHu7M27ZgkbJ88KPVvqdHYAiCOr+8ikXa5O4O
   at+TXbkjYm48sC/4S60SP5GB80Kcr4cT+4BGnzJQPENljXTdtGgovVu+1
   w==;
X-CSE-ConnectionGUID: z7f8rZE5Q8i5+eGF9s5Umg==
X-CSE-MsgGUID: 54b1tfVFQBiLE4mCtiWXSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903478"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903478"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:27:17 -0700
X-CSE-ConnectionGUID: wC4pRigPTk65sPn+FhCwlg==
X-CSE-MsgGUID: 65CUt4VoQ8Opy1+rKR26tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831425"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:26:55 -0700
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
Subject: [PATCH v4 06/18] x86: Reset tag for virtual to physical address conversions
Date: Tue, 12 Aug 2025 15:23:42 +0200
Message-ID: <01e62233dcc39aeb8d640eb3ee794f5da533f2a3.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B804A4000F
X-Stat-Signature: 4kw69b1kqsauxdjiegii3dcwmoaz63ex
X-HE-Tag: 1755005237-729448
X-HE-Meta: U2FsdGVkX19eEyy0Lyb1USNwg9aep8dvtqdOZZRkLtZMUhz6k3l0tzR+qNTAd4hynxcJsfeg6kMzh188R270ZTV1oMc+pPhzCOZW+jM2AjTjb9778thEJWg7Oqow5veI6U95Xk3m3r5aTQZetse4lNVVhdxQP5/3NxvZBpTWyngXMQaqroH7AHJEX41fmMNyUdOU6xk8miO0b8gbKMfzreGewpfzwNVB4pPKijszD0cHDLt4Od3YKKsXE8R5pU21Vr5wXh1EgZ2LoFPnoL8TBKKEgzQ7vJmo/4UxK4QUhbyadHVN3MOT4bVhUl9Nh7EmTur6ZYC2d1RH/Xxu7ybJT093O6BTjMmFSRHo3FlWPjoqCSjoeLnuIcE+fje3HwB3bdbSW5J8Vm2P7KCuWYt5iilQ3PbiI1RzRnxogLYciHhg4X/2KOGv/UIsYOMIVB8PaPI+Ywr+TNEO6WeXIowr8TNKmkRdp8iS6QH5BULtLXmgcsxXi0jlv61odDm/GM4zB1dE4cD7HCFZQYk9iKUzsePgiSKjMrUz4mb5q6mYQM5igUgSPFOSD4Lcb7+WI85P56wBFnYaqcOu28WOxNqYF4el8uE9MQwUTz+mMv8ClaCcGuGJXuhNjIwVcntc/DycGhuefMFskN+ppVMbCuzr5fMg5jBENIvVJfGpWg6GGANM+iEsExopPn8lpYwUteW86KgsN5MrEnwklx39BzY7WekSHC/Ym2ukiIEAkJ+NzEb091kc1u066GjdOcHonQvOaw23ktfNZxIym9gSqNHOamr8Scu5XJp48gvWTsOlGjdz6TlbBQD4eeiL6kax0p7qOu0KKh5Vs+FWAykG5vuuwyBZoWKhaKBu1gLzmkdxmugUB3gCzSCKFq4vr5VgH1RULvf+5RwmZI8cf7/zUoShdr0VTEFeyn4z42Ellxp2AOwT3+EgaKg839FdXjy+kAzNF84IpMxp95vk44nzbyg
 2/+x5l2Z
 if1LquX6/IbBHMOsnjpEII9a/ujR5nRDSQ9gVbkb9WwgcI8ej47ApTv0CBIyBFGuJ4Y3Rg5nmc8sbg072Xj0GTVGeL2fEJcAUAxqP97jigCkZDS7MSKvJSGI9qZwfRyYIRoFKKFGLpmZGlrbMys3+YsUpBAM3qtyXvPCN6V90ne7BV1ZvgrEXDFZwjFum64+FdH3oFQBmy2yseDlvlxaotpGkiWcEvdUjeAU448BgxQvMp874VvhRXynQkV2ZDJdtOTFu
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
Changelog v4:
- Simplify page_to_virt() by removing pointless casts.
- Remove change in __is_canonical_address() because it's taken care of
  in a later patch due to a LAM compatible definition of canonical.

 arch/x86/include/asm/page.h    | 14 +++++++++++---
 arch/x86/include/asm/page_64.h |  2 +-
 arch/x86/mm/physaddr.c         |  1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..15c95e96fd15 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -7,6 +7,7 @@
 #ifdef __KERNEL__
 
 #include <asm/page_types.h>
+#include <asm/kasan.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/page_64.h>
@@ -41,7 +42,7 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 #define __pa(x)		__phys_addr((unsigned long)(x))
 #endif
 
-#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
+#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(__tag_reset(x)))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 /*
@@ -65,9 +66,16 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
  * virt_to_page(kaddr) returns a valid pointer if and only if
  * virt_addr_valid(kaddr) returns true.
  */
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define page_to_virt(x) ({							\
+	void *__addr = __va(page_to_pfn((struct page *)x) << PAGE_SHIFT);	\
+	__tag_set(__addr, page_kasan_tag(x));					\
+})
+#endif
+#define virt_to_page(kaddr)	pfn_to_page(__pa((void *)__tag_reset(kaddr)) >> PAGE_SHIFT)
 extern bool __virt_addr_valid(unsigned long kaddr);
-#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
+#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long)(__tag_reset(kaddr)))
 
 static __always_inline void *pfn_to_kaddr(unsigned long pfn)
 {
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 015d23f3e01f..de68ac40dba2 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -33,7 +33,7 @@ static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
 extern unsigned long __phys_addr(unsigned long);
 extern unsigned long __phys_addr_symbol(unsigned long);
 #else
-#define __phys_addr(x)		__phys_addr_nodebug(x)
+#define __phys_addr(x)		__phys_addr_nodebug(__tag_reset(x))
 #define __phys_addr_symbol(x) \
 	((unsigned long)(x) - __START_KERNEL_map + phys_base)
 #endif
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index fc3f3d3e2ef2..7f2b11308245 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -14,6 +14,7 @@
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
+	x = __tag_reset(x);
 	unsigned long y = x - __START_KERNEL_map;
 
 	/* use the carry flag to determine if x was < __START_KERNEL_map */
-- 
2.50.1


