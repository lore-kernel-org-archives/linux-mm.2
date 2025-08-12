Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B67ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28FA8E013E; Tue, 12 Aug 2025 09:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00888E00E5; Tue, 12 Aug 2025 09:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF10E8E013E; Tue, 12 Aug 2025 09:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0A328E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:32:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66EAC1A02CF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:32:00 +0000 (UTC)
X-FDA: 83768193600.02.8AFC9BE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37139160013
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:31:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BvCs7dxe;
	spf=pass (imf08.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9dZ7HYFm04sYh+3FqLYILOU5ulghIY66izoMMIko1I=;
	b=07ECWviGLGRsfFc+znvTsMYBkhUxr3CWvhfBIfNpOt+Kh59i10d0jKZkEUD9/G3J+Kbb3J
	uPdEbwAT5SHQHBgCGV8/v9S8+E3fccyakm3HhuK53fsUbw1/9rixcXV7KKovhQeS2yza/G
	rwvXVs+dBWoa6pLN7JLWG3qGxcGEr8I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BvCs7dxe;
	spf=pass (imf08.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005518; a=rsa-sha256;
	cv=none;
	b=hCvHuKGooo48Qb3zCw7o9THrrm5FI5rjkmVrBo1iN5kw+j4Ac/ClV9wjpH2WVQBRougUaP
	lRVi1WDT5QjjEPc9yb2gqA9ESlV9ubp5X804vET4EtdFS8LDEBYtKl0rJfWbCZN8a4ES6c
	93nHirtA1b5/FmV5Uix2E3QHwkk9oZU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005519; x=1786541519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vl29c6D1eR0f0U4vY2WrG9uFQFyXVuYuiDzYnN2VaZk=;
  b=BvCs7dxeahxYboCZmojBIuouvOGg4gMIZpUQQFFHWJX/z1zF9GGjmlW2
   X4BCMW0vlmEnzwcMQ5IgqVyf4sC52WjFb2vjml+ZgmP4limPvPgy3lsZO
   qYVTW3hbaLJWxlp8rt+3C+xgaHvbdickvZNiYZQQ4KDlYNP+BZnj6ZbqR
   /InZUyUps7gePABqszrFwfO31sSN8Hlde1QAIVw3XpS/7XGBY6Tgr4Dag
   kLfMMa1Qs9cCquqj8Vy1rit1sGPlBKj5mxExc/acbBrsQwbsp0KAr77SU
   XpElpnNyOvwd/TxAjRITUJAdiCddpWCiAMq6UtA8+F/4bmkkMtaItW6or
   g==;
X-CSE-ConnectionGUID: iCiuoYQrSFKM6H/FC1N84Q==
X-CSE-MsgGUID: lTeK8G7ASzCyyxUMyjM0Sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60904230"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60904230"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:31:57 -0700
X-CSE-ConnectionGUID: uGwnKofIQG2MO3tLlIilYQ==
X-CSE-MsgGUID: HOOQUTfdSZuSH6R+h2pTMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165832158"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:31:31 -0700
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
Subject: [PATCH v4 18/18] x86: Make software tag-based kasan available
Date: Tue, 12 Aug 2025 15:23:54 +0200
Message-ID: <414e258b828b4710966c3864aebc7a9bc598eb4f.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wnjbuoma5swodifi8ephqo5nnjgh9ex4
X-Rspam-User: 
X-Rspamd-Queue-Id: 37139160013
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005518-722147
X-HE-Meta: U2FsdGVkX18VqarSyD1WESni3rJF7EPCcbvhVST7TDuX8xcx0/6YaPivhgJoAJpa9kpH2vh0lFFtdald2AJO5o/7H66TCtmb3QuZWfcVUPCtFP5MHAaGGShxS+tjjeY7PBzzS3P+naynUOM5iCss6Gv27v/Muby9fGmycApybMm6SGJVTw++cKusk3jvF+GucJIi4fqwtTIMqhm8Gz7kc4k0GqG2xypa96ufXrTlL91kDwzXpEoZ09r8OTpPHAYNfcmTqHBspIQGiJmlX2iw8j5b3ME62gjQkfUf4UA6ELaxtLutbVbX8u75DIfJC4M0ytaPT6WHJ0lg4SpSRjFdBTwRvlXpN6dTBjjxLpizpMafgN79piezOP6uYcznCkwGfgZoQm4pto3pnrdts7P/EQLwQxs4lIMlJiG28yYsrgJuDoOAnbjcZEIOY4bxOZ1CVp5dSib1lOOpEbJGHTbRKGB9fg1KYkeN449nQHkpmWrSF8IR2JYermLSRRNBCe34poaekdvBSxbinXnd2AADHG8fgRU4mNivk/y3Ydy55HPjym6knNFR+YgJnVgsZHa3vhL2bbckpqUqgaH5g4XO3j5x09Ay57So8bsCdB32lTEC+4PP7fleIWxipmFMCvMvUQNw/5/6MeRNv0LZrB+06+/DPuhQ922GHj7broW6APkfGE/UkjA4SHf8C93PI9MAS9nnR2J4qGXLS1ylbhtGt5EosRqOMpq80wxfwpcA9pfQ26D1vLTs1uXykZ9klNQ5xCbIPDlspDg3lWrBn1zVBYxyhpzCGvtkEPNwAOBKQoO8l8cbjdYATtF8Rlo8RSM9sW/10ReDuIzoqQTEZyoFN/4qy7ISUSszg/llZNtIYlBthzTsW5pJWLyLSh474L9JE6tzNwcK4CVAJgvGMdVoM4ITNsVojWtXDIqdAJh/ensC0Q1/4YFoSqjeClXZxASILA5rTs7iLd/2vuzr/71
 XQRbuXRs
 C1h/CDoT4QLfOAoATSoiSGVBzPUHWEPGL+2E0gNK85J4r0Ja2ttYAkp0G/+FZEy10m6cWYxxoYwmTC41P4XCSo63i97ipIaxKo+/DbtBT0VBT5XQs0AUVVOkPZhG+Wo1aY717u6DWzZTXsSV+LVnpsErkP6EuepQjlKHiaKhtWCV9WzYUTmcpQv4yUPuQOCABSHdw4UZI0cdGBFI0ljL2PgKv+ps0Z/3jqNJe8Ox8epWWP9c28uMrf7VCFI9LzNyYlaER
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make CONFIG_KASAN_SW_TAGS available for x86 machines if they have
ADDRESS_MASKING enabled (LAM) as that works similarly to Top-Byte Ignore
(TBI) that allows the software tag-based mode on arm64 platform.

Set scale macro based on KASAN mode: in software tag-based mode 16 bytes
of memory map to one shadow byte and 8 in generic mode.

Disable CONFIG_KASAN_INLINE and CONFIG_KASAN_STACK when
CONFIG_KASAN_SW_TAGS is enabled on x86 until the appropriate compiler
support is available.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add x86 specific kasan_mem_to_shadow().
- Revert x86 to the older unsigned KASAN_SHADOW_OFFSET. Do the same to
  KASAN_SHADOW_START/END.
- Modify scripts/gdb/linux/kasan.py to keep x86 using unsigned offset.
- Disable inline and stack support when software tags are enabled on
  x86.

Changelog v3:
- Remove runtime_const from previous patch and merge the rest here.
- Move scale shift definition back to header file.
- Add new kasan offset for software tag based mode.
- Fix patch message typo 32 -> 16, and 16 -> 8.
- Update lib/Kconfig.kasan with x86 now having software tag-based
  support.

Changelog v2:
- Remove KASAN dense code.

 Documentation/arch/x86/x86_64/mm.rst | 6 ++++--
 arch/x86/Kconfig                     | 4 +++-
 arch/x86/boot/compressed/misc.h      | 1 +
 arch/x86/include/asm/kasan.h         | 1 +
 arch/x86/kernel/setup.c              | 2 ++
 lib/Kconfig.kasan                    | 3 ++-
 scripts/gdb/linux/kasan.py           | 4 ++--
 7 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/arch/x86/x86_64/mm.rst b/Documentation/arch/x86/x86_64/mm.rst
index a6cf05d51bd8..ccbdbb4cda36 100644
--- a/Documentation/arch/x86/x86_64/mm.rst
+++ b/Documentation/arch/x86/x86_64/mm.rst
@@ -60,7 +60,8 @@ Complete virtual memory map with 4-level page tables
    ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unused hole
    ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual memory map (vmemmap_base)
    ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unused hole
-   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory
+   ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory (generic mode)
+   fffff40000000000 |   -8    TB | fffffbffffffffff |    8 TB | KASAN shadow memory (software tag-based mode)
   __________________|____________|__________________|_________|____________________________________________________________
                                                               |
                                                               | Identical layout to the 56-bit one from here on:
@@ -130,7 +131,8 @@ Complete virtual memory map with 5-level page tables
    ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unused hole
    ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual memory map (vmemmap_base)
    ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unused hole
-   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory
+   ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory (generic mode)
+   ffeffc0000000000 |   -6    PB | fffffbffffffffff |    4 PB | KASAN shadow memory (software tag-based mode)
   __________________|____________|__________________|_________|____________________________________________________________
                                                               |
                                                               | Identical layout to the 47-bit one from here on:
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b8df57ac0f28..f44fec1190b6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,6 +69,7 @@ config X86
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_CONFIGURES_CPU_MITIGATIONS
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
+	select ARCH_DISABLE_KASAN_INLINE	if X86_64 && KASAN_SW_TAGS
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
@@ -199,6 +200,7 @@ config X86
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if X86_64
 	select HAVE_ARCH_KASAN_VMALLOC		if X86_64
+	select HAVE_ARCH_KASAN_SW_TAGS		if ADDRESS_MASKING
 	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_KMSAN			if X86_64
 	select HAVE_ARCH_KGDB
@@ -403,7 +405,7 @@ config AUDIT_ARCH
 
 config KASAN_SHADOW_OFFSET
 	hex
-	depends on KASAN
+	default 0xeffffc0000000000 if KASAN_SW_TAGS
 	default 0xdffffc0000000000
 
 config HAVE_INTEL_TXT
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index db1048621ea2..ded92b439ada 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -13,6 +13,7 @@
 #undef CONFIG_PARAVIRT_SPINLOCKS
 #undef CONFIG_KASAN
 #undef CONFIG_KASAN_GENERIC
+#undef CONFIG_KASAN_SW_TAGS
 
 #define __NO_FORTIFY
 
diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index f3e34a9754d2..385f4e9daab3 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 #ifdef CONFIG_KASAN_SW_TAGS
+#define KASAN_SHADOW_SCALE_SHIFT 4
 
 /*
  * LLVM ABI for reporting tag mismatches in inline KASAN mode.
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1b2edd07a3e1..5b819f84f6db 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1207,6 +1207,8 @@ void __init setup_arch(char **cmdline_p)
 
 	kasan_init();
 
+	kasan_init_sw_tags();
+
 	/*
 	 * Sync back kernel address range.
 	 *
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index f82889a830fa..9ddbc6aeb5d5 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -100,7 +100,8 @@ config KASAN_SW_TAGS
 
 	  Requires GCC 11+ or Clang.
 
-	  Supported only on arm64 CPUs and relies on Top Byte Ignore.
+	  Supported on arm64 CPUs that support Top Byte Ignore and on x86 CPUs
+	  that support Linear Address Masking.
 
 	  Consumes about 1/16th of available memory at kernel start and
 	  add an overhead of ~20% for dynamic allocations.
diff --git a/scripts/gdb/linux/kasan.py b/scripts/gdb/linux/kasan.py
index fca39968d308..4b86202b155f 100644
--- a/scripts/gdb/linux/kasan.py
+++ b/scripts/gdb/linux/kasan.py
@@ -7,7 +7,7 @@
 #
 
 import gdb
-from linux import constants, mm
+from linux import constants, utils, mm
 from ctypes import c_int64 as s64
 
 def help():
@@ -40,7 +40,7 @@ class KasanMemToShadow(gdb.Command):
         else:
             help()
     def kasan_mem_to_shadow(self, addr):
-        if constants.CONFIG_KASAN_SW_TAGS:
+        if constants.CONFIG_KASAN_SW_TAGS and not utils.is_target_arch('x86'):
             addr = s64(addr)
         return (addr >> self.p_ops.KASAN_SHADOW_SCALE_SHIFT) + self.p_ops.KASAN_SHADOW_OFFSET
 
-- 
2.50.1


