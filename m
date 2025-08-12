Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1CDCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0518E0132; Tue, 12 Aug 2025 09:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8668E00E5; Tue, 12 Aug 2025 09:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297228E0132; Tue, 12 Aug 2025 09:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 175F08E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9E8D1A0303
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:41 +0000 (UTC)
X-FDA: 83768182722.22.CE6AA04
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 81E9A40006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L+LGP85a;
	spf=pass (imf11.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZI4hLWymuooglNAw5L1xAkAf+4ihyWxsZNVV22uwkY=;
	b=TmHZ38tGoF0434RXJdRYlSFTkhtHgWkIRCzaAGr/3fXu0x1XxI350GNa50q7fdWF4PGf/m
	Q6Mb8Ij8hQ2JR1wX4yjjay8IB7FX0lNPfc01LgMG6dxCPngPLO+q2Uy04BUsjS41VvF/wv
	aFViSQIofFTgh5SbITToPCztJ0f0k0s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L+LGP85a;
	spf=pass (imf11.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005260; a=rsa-sha256;
	cv=none;
	b=ThU0IasNgRS69r77XctRYNqZ886xtDzdk5rtPp0A9f8x0hdagOArVvdCmHLVfFuGg3SWE2
	zAtPEjnvXqYI/lpAbJnI+elzeitTr8k0RFIoWbO3D2mXLUZmWLnrmEFRHUkRFIoCCoNOL9
	h9QzEyW05VIAQCv2IGo2DWmeQr08IFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005260; x=1786541260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WytGKsbpVx+YjGfDckn4ztihfy/XnHxiwtMc2ueYMYI=;
  b=L+LGP85alfWS2LanLsShitiahDbLftGu7ZecMK0HXqFNaSw3HO4Iip3I
   m6NwRizP9z4xuMZ+882UPYJJ03fNabxlypK/CRQBGgh6BnIeBRYCp/XCR
   9t9q72HQBBHKv9Q3G9yma8IcF0DvCSQdevDDt6GaS3951q3p9LCQauh/W
   zDHWM/o0ZZX9LzHAjnWHLXPel1Bu10Anh1jk//fSfeMAdkBKlQz+YbYHC
   A8+vzyl9M+baH1yOdgwWKnhlndEw3meGpuGAir+0Pey2RITTIq+p00DiV
   IeGiYDpDxB3MRd3gUquvPDAAy5VmN8cl0sWrBU/N3PoBGytPH1A2SXR3g
   A==;
X-CSE-ConnectionGUID: 4xyVVan+S0aJ6lwYAbFT4Q==
X-CSE-MsgGUID: NfdaGpPlRc+MgkzeRLmeBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903519"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903519"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:27:38 -0700
X-CSE-ConnectionGUID: 7sr1bGkITqqOrRUhUWybYQ==
X-CSE-MsgGUID: Oy2/bGKxRJGKw5AHGzSS+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831445"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:27:16 -0700
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
Subject: [PATCH v4 07/18] mm: x86: Untag addresses in EXECMEM_ROX related pointer arithmetic
Date: Tue, 12 Aug 2025 15:23:43 +0200
Message-ID: <aa501a8133ee0f336dc9f905fdc3453d964109ed.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 839qijjriqaex8b3fu51i7yi1kyeq99h
X-Rspam-User: 
X-Rspamd-Queue-Id: 81E9A40006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755005259-224593
X-HE-Meta: U2FsdGVkX181dHsmKnjM9O5Xf0zzWCDIrKDoagjgCDM56m5gyFLq2OCrZh7za1+7SNAnr1iHlwLrZqoieD8TWallF2n86JHh9jkiySqaIYoviMDF0hMG4xkItaKXOZaJiRV/be/1R8MyACE4V1idaUxILV+2zIYsyvruJLjhiyrF982QiHCy4yYdvhkcLUW0fdAYfNeTI/O0Q9mjz1xWcYk/TY1sv15gmtphsjiA8ddK7n5nQjpyiYJfVt/978kcgohdgXnj/V3dFDdu3j1imxHYRWZsn9/ZiqZaw/o5l150nmG7o0VMZ29imzuNmD+/eK/OWCUGderTDhCHlOFZpfM2lKERFrxSzo9N3f1AuSAT1voVbGJtxR+hzt/BIsc60bZpSs4XxQM2VZWpItfuvFYYcgl97dPepVWHPkOY+ZCWGqKefodexyawtVz90ld3kZXdkJ7iqAh2oEYKGfrymqGs0nIG7cJmUGTfVH4plvluhK3LkxKEQlkKs6X/Hq/71zJVmX+q0tOBuLoyZwohbtiTVdieRdkAAtMqtJEyb5nEo/UP+z8jUeLqlaeDgC29TVTMawkB3q1U5lDxyECfRuFivQefrjf4arTXcxq1PrQwwRJ9v7YKje0/X0gSFnL6oiJhZBzsaOcy++0fhQDY2OSKElrugpy1AWsdcrKEu1MRl1WTLdWBjr0Mzs7FDbBhY6e84NgMmbDKD2w5BnEsmMvLPZ/UVCiKU9VXTEpIVdB5KojLoQ5oMxOiQbEmpu5/JuR/tb+qcVKZGZ0dG4vkKtJFXOBuBByj+67+HBAZnl1Djv7CLn8y2iD+22TpbsZg4a6h/VV+yEfxkcdSPJU7FGvIAp1N/P4FElcuHT6Nw5rLskIGh9uSn7+XAeJ8u3o3E/xUeuBzFjXelDwIpHQPoDaremoMrDsqL7riGfvX65cv4pKzhRZaWMhtaOyioIdKY5Vtpg20rjSJjMOWxk+
 kWXY3pjK
 tjGl0bwFgCjpuaZoA5DZtOavA6YnZpcB1C8qguzqcBKn8ee6mUPU2a2f40sud5AzTIGjhYPZewS4ohSsxX7lm1MN6bOnMacAHVpnm7MQKJgvT+EaZ65IWx/3Gk8taZ0UxE72G/D8spjA1IFowI8JWoYkE0M2RdRSo8NFIl3rcpT2waopgHo/9Hz0Jw5EaLFGxjxzqGMSL33TzZTrofCxARn44wAdRSor5LP1dDJtO4dHm2l/4/abrLUsTtRRlTgD0vzFoJssIZM4gfGJAB8AD3y5ezW8mxvYM1EKzZAKEjr7ZwlU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
Related code has multiple spots where page virtual addresses end up used
as arguments in arithmetic operations. Combined with enabled tag-based
KASAN it can result in pointers that don't point where they should or
logical operations not giving expected results.

vm_reset_perms() calculates range's start and end addresses using min()
and max() functions. To do that it compares pointers but some are not
tagged - addr variable is, start and end variables aren't.

within() and within_range() can receive tagged addresses which get
compared to untagged start and end variables.

Reset tags in addresses used as function arguments in min(), max(),
within() and within_range().

execmem_cache_add() adds tagged pointers to a maple tree structure,
which then are incorrectly compared when walking the tree. That results
in different pointers being returned later and page permission violation
errors panicking the kernel.

Reset tag of the address range inserted into the maple tree inside
execmem_cache_add().

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add patch to the series.

 arch/x86/mm/pat/set_memory.c | 1 +
 mm/execmem.c                 | 4 +++-
 mm/vmalloc.c                 | 4 ++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8834c76f91c9..1f14a1297db0 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -222,6 +222,7 @@ static inline void cpa_inc_lp_preserved(int level) { }
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
 	return addr >= start && addr < end;
 }
 
diff --git a/mm/execmem.c b/mm/execmem.c
index 0822305413ec..743fa4a8c069 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -191,6 +191,8 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
 	unsigned long lower, upper;
 	void *area = NULL;
 
+	addr = arch_kasan_reset_tag(addr);
+
 	lower = addr;
 	upper = addr + size - 1;
 
@@ -216,7 +218,7 @@ static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
 static bool within_range(struct execmem_range *range, struct ma_state *mas,
 			 size_t size)
 {
-	unsigned long addr = mas->index;
+	unsigned long addr = arch_kasan_reset_tag(mas->index);
 
 	if (addr >= range->start && addr + size < range->end)
 		return true;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..83d666e4837a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3328,8 +3328,8 @@ static void vm_reset_perms(struct vm_struct *area)
 			unsigned long page_size;
 
 			page_size = PAGE_SIZE << page_order;
-			start = min(addr, start);
-			end = max(addr + page_size, end);
+			start = min((unsigned long)arch_kasan_reset_tag(addr), start);
+			end = max((unsigned long)arch_kasan_reset_tag(addr) + page_size, end);
 			flush_dmap = 1;
 		}
 	}
-- 
2.50.1


