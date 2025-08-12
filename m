Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499ADCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7D08E0139; Tue, 12 Aug 2025 09:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFAC8E00E5; Tue, 12 Aug 2025 09:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAED98E0139; Tue, 12 Aug 2025 09:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBD5D8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:30:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 840B2116591
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:30:01 +0000 (UTC)
X-FDA: 83768188602.22.28A54C1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DD8A40003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O5ms1iwj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005399; a=rsa-sha256;
	cv=none;
	b=4t3BiDdW2w2xzRvI9hSgAlTKaU8GPfqVjDMt/72sPlac/jabeUOBAIeCtSuvPL0RKv1dI4
	jzO+gd7aQqDlRiIH2qzxqItPTM9lHNnUfnlCp+GKabuk3W6m+e/JTRs3hWYgId1DxxRbCa
	kkZSwVN3rr0VmlfghSajDumeFWAmVwc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O5ms1iwj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJiZK/ZPyG3ykxKNSXW3kYtWo0Nz0Qcpx4tZ2otWEt8=;
	b=cI5ZdBipYh7+7Ps7G2zVG25sZu/YIroCum7AOtF1NA63yBM2vycsmr/YET3jMtgQ1yjesk
	ZXPRgwAH3bEEU7tFghSET2EPlrmbpM2AQb7ML73gszbual5Br6wwvurkmCYBxtXPN9L8ky
	fHf4EBl2R2RhHrdIDotxdcLH+t1QDl4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005400; x=1786541400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s8GTuO6BhzUjxSM1kGBYFltc6MUMI6BMbrDsjAC5xo8=;
  b=O5ms1iwjG+roKdf7o/OWqgTTck3ipMoXK6NJ0Lu2BHGZke2pJYkAKFPl
   GvLSTbPa9j12QGqg0MXD5x9y1JRhRynLyNPC2tHcyyPRZCSylXkVrFwtx
   /93S68K9N5xi2FwYrSGnLb7ME9VzaMdfqNIJGr4xtV0PBu7j2vJRPHQ2Z
   iLNt7tXqSNyYr+nN4HHsiIt6l6YbDKhgeCZfx6ljinMbZVb5r4iehLMSx
   7ou4unJMtrgXxuoCmLD2pkaZfqM0ub1C5ZvCfGzPmtqLWIW7DGaCuG8lc
   Hnlfp//pjeA5lp7ReYyaXeBMV4K0ia5IbXeuyMaikueVWoHMRlbNU7mx5
   w==;
X-CSE-ConnectionGUID: GA5SKVQ1Qki9mgB+bITfaw==
X-CSE-MsgGUID: O2DVIkZdR3mvrsOpm4JswA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903876"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903876"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:29:58 -0700
X-CSE-ConnectionGUID: vu28n5RXQyCx06dXuuNJDg==
X-CSE-MsgGUID: KI/7/IerRmiIwK8D24KJGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831619"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:29:34 -0700
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
Subject: [PATCH v4 13/18] kasan: arm64: x86: Handle int3 for inline KASAN reports
Date: Tue, 12 Aug 2025 15:23:49 +0200
Message-ID: <9030d5a35eb5a3831319881cb8cb040aad65b7b6.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DD8A40003
X-Stat-Signature: 4erakk5kk9jdqgyk8ipyy9ahfwbyxah1
X-Rspam-User: 
X-HE-Tag: 1755005399-158827
X-HE-Meta: U2FsdGVkX1+x+DYGZ24h4M0LB3bYMD9vEAi631dpYJDsqlrJCi5OC+4GXXJ2P1vzGYfTsGbfAkHaXVb37nKACmCkyJDvnlJ8o9wsWP701fwFy5GYs9e2E45LCwSSB6gQ5kzpJxg7kp0BYN+21DCOOChpa0+5FZH2DZGlXzJqewJmIZqoIVjom+b77MsNCTIhPYORrch0owUbqNLqHbTEn/gignTGJJ+tEH/abW4kc3t/ohffvLUsv2N2duB+xF11vExob3wxJkP2GgG7IkB9mXbcLlYbERSdHuK7asdUG6V6TRZf0A2ygxEDp4qsPakNbUxHtvnnppJTrnP636shSSHQIPDTQc9UXuk862GFHfSYuRiYRN89bT4Q2Ovsjh8kApEYUYULbstiJscSxODQNcXSSLHAsS6x6AlncN34KeXLsOdIq1rQzfA2AwRFdWdaYbH4b9tEI0sRvqSZ7vHaSzf+FLBdQ/nJZUhnXEbLBIwzyfLT/J4vHswGvWzP1wOSLNy09sDXPUHGISWlQknscjrUuqV1Qb3E0HivaaEShaqinaeaL/8tr0en2VmWD8nTjQu9mS/vyr1U5gVIM40JoUQF4A/JqXaSsXiSVXex5l5JAoIKxICrmKj5+gOTdHtOD1uwWNEgvr3UA0rW4SvBC3+0hWy8wDbKepl7R4i+shc9sQQFIa+5TkFMlVybBjAjCXtpjTLhENta9E/Xyo7gj9/9/0PQWGP0hW8IZEfq2tJS82G37ViMiwGUz1DecnlS6pRNIhJxUMuG9wvlZsYyyZ6D5WCw+6X02DCh/bQ2KByjhbQUESfuXYbORBLn5QAXKWIfBZWWyDMsfGkanfoepqE6U8Q5cLPjxkHZIXzirci1m3UROi1ZIyAvxtfdCSFD2ORJHC6goOiQEUTEDyN022DAGba575bA1Eq2qRPv8AlgeJnrCxqrWrps9JnwjD46yYTRjkR7Z0g2F0+09vS
 +Q7pRDhS
 7TTa0U2qSnzOo3eZrtq7Xonhdzc9mcpnSsTVQiPshsqlBHI2Tjcbjxfec+XizdCTkmsSynYJvLfxacC0FSB8DM7dbW3tKW1V0cleSYnAvnsm/HgBDsb3SK0usvC0HI/mtAlnMm/dmYy7qLMVED70fkrgff7ma5AaRiRgt0NEugbg0JpT6z7txNZx6pztvNzxp5qt+OnXdsZruT5us1V0Bz2g7w5SCm57m+fVebyDSS4H0E1flZGg1oOLRTjyXeJms/uezcN0PgMqOq8pYquLgqfOBew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inline KASAN on x86 does tag mismatch reports by passing the faulty
address and metadata through the INT3 instruction - scheme that's setup
in the LLVM's compiler code (specifically HWAddressSanitizer.cpp).

Add a kasan hook to the INT3 handling function.

Disable KASAN in an INT3 core kernel selftest function since it can raise
a false tag mismatch report and potentially panic the kernel.

Make part of that hook - which decides whether to die or recover from a
tag mismatch - arch independent to avoid duplicating a long comment on
both x86 and arm64 architectures.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Make kasan_handler() a stub in a header file. Remove #ifdef from
  traps.c.
- Consolidate the "recover" comment into one place.
- Make small changes to the patch message.

 MAINTAINERS                   |  2 +-
 arch/arm64/kernel/traps.c     | 17 +----------------
 arch/x86/include/asm/kasan.h  | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/alternative.c |  4 +++-
 arch/x86/kernel/traps.c       |  4 ++++
 arch/x86/mm/Makefile          |  2 ++
 arch/x86/mm/kasan_inline.c    | 23 +++++++++++++++++++++++
 include/linux/kasan.h         | 24 ++++++++++++++++++++++++
 8 files changed, 84 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/mm/kasan_inline.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7ce8c6b86e3d..3daeeaf67546 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13167,7 +13167,7 @@ S:	Maintained
 B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kasan.rst
 F:	arch/*/include/asm/*kasan*.h
-F:	arch/*/mm/kasan_init*
+F:	arch/*/mm/kasan_*
 F:	include/linux/kasan*.h
 F:	lib/Kconfig.kasan
 F:	mm/kasan/
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index f528b6041f6a..b9bdabc14ad1 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1068,22 +1068,7 @@ int kasan_brk_handler(struct pt_regs *regs, unsigned long esr)
 
 	kasan_report(addr, size, write, pc);
 
-	/*
-	 * The instrumentation allows to control whether we can proceed after
-	 * a crash was detected. This is done by passing the -recover flag to
-	 * the compiler. Disabling recovery allows to generate more compact
-	 * code.
-	 *
-	 * Unfortunately disabling recovery doesn't work for the kernel right
-	 * now. KASAN reporting is disabled in some contexts (for example when
-	 * the allocator accesses slab object metadata; this is controlled by
-	 * current->kasan_depth). All these accesses are detected by the tool,
-	 * even though the reports for them are not printed.
-	 *
-	 * This is something that might be fixed at some point in the future.
-	 */
-	if (!recover)
-		die("Oops - KASAN", regs, esr);
+	kasan_inline_recover(recover, "Oops - KASAN", regs, esr);
 
 	/* If thread survives, skip over the brk instruction and continue: */
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index 1963eb2fcff3..5bf38bb836e1 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -6,7 +6,28 @@
 #include <linux/kasan-tags.h>
 #include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
+#ifdef CONFIG_KASAN_SW_TAGS
+
+/*
+ * LLVM ABI for reporting tag mismatches in inline KASAN mode.
+ * On x86 the INT3 instruction is used to carry metadata in RAX
+ * to the KASAN report.
+ *
+ * SIZE refers to how many bytes the faulty memory access
+ * requested.
+ * WRITE bit, when set, indicates the access was a write, otherwise
+ * it was a read.
+ * RECOVER bit, when set, should allow the kernel to carry on after
+ * a tag mismatch. Otherwise die() is called.
+ */
+#define KASAN_RAX_RECOVER	0x20
+#define KASAN_RAX_WRITE		0x10
+#define KASAN_RAX_SIZE_MASK	0x0f
+#define KASAN_RAX_SIZE(rax)	(1 << ((rax) & KASAN_RAX_SIZE_MASK))
+
+#else
 #define KASAN_SHADOW_SCALE_SHIFT 3
+#endif
 
 /*
  * Compiler uses shadow offset assuming that addresses start
@@ -35,10 +56,15 @@
 #define __tag_shifted(tag)		FIELD_PREP(GENMASK_ULL(60, 57), tag)
 #define __tag_reset(addr)		(sign_extend64((u64)(addr), 56))
 #define __tag_get(addr)			((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)addr))
+bool kasan_inline_handler(struct pt_regs *regs);
 #else
 #define __tag_shifted(tag)		0UL
 #define __tag_reset(addr)		(addr)
 #define __tag_get(addr)			0
+static inline bool kasan_inline_handler(struct pt_regs *regs)
+{
+	return false;
+}
 #endif /* CONFIG_KASAN_SW_TAGS */
 
 static inline void *__tag_set(const void *__addr, u8 tag)
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2a330566e62b..4cb085daad31 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2228,7 +2228,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 }
 
 /* Must be noinline to ensure uniqueness of int3_selftest_ip. */
-static noinline void __init int3_selftest(void)
+static noinline __no_sanitize_address void __init int3_selftest(void)
 {
 	static __initdata struct notifier_block int3_exception_nb = {
 		.notifier_call	= int3_exception_notify,
@@ -2236,6 +2236,7 @@ static noinline void __init int3_selftest(void)
 	};
 	unsigned int val = 0;
 
+	kasan_disable_current();
 	BUG_ON(register_die_notifier(&int3_exception_nb));
 
 	/*
@@ -2253,6 +2254,7 @@ static noinline void __init int3_selftest(void)
 
 	BUG_ON(val != 1);
 
+	kasan_enable_current();
 	unregister_die_notifier(&int3_exception_nb);
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0f6f187b1a9e..2a119279980f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -912,6 +912,10 @@ static bool do_int3(struct pt_regs *regs)
 	if (kprobe_int3_handler(regs))
 		return true;
 #endif
+
+	if (kasan_inline_handler(regs))
+		return true;
+
 	res = notify_die(DIE_INT3, "int3", regs, 0, X86_TRAP_BP, SIGTRAP);
 
 	return res == NOTIFY_STOP;
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..1dc18090cbe7 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -36,7 +36,9 @@ obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= debug_pagetables.o
 
 KASAN_SANITIZE_kasan_init_$(BITS).o := n
+KASAN_SANITIZE_kasan_inline.o := n
 obj-$(CONFIG_KASAN)		+= kasan_init_$(BITS).o
+obj-$(CONFIG_KASAN_SW_TAGS)	+= kasan_inline.o
 
 KMSAN_SANITIZE_kmsan_shadow.o	:= n
 obj-$(CONFIG_KMSAN)		+= kmsan_shadow.o
diff --git a/arch/x86/mm/kasan_inline.c b/arch/x86/mm/kasan_inline.c
new file mode 100644
index 000000000000..9f85dfd1c38b
--- /dev/null
+++ b/arch/x86/mm/kasan_inline.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kasan.h>
+#include <linux/kdebug.h>
+
+bool kasan_inline_handler(struct pt_regs *regs)
+{
+	int metadata = regs->ax;
+	u64 addr = regs->di;
+	u64 pc = regs->ip;
+	bool recover = metadata & KASAN_RAX_RECOVER;
+	bool write = metadata & KASAN_RAX_WRITE;
+	size_t size = KASAN_RAX_SIZE(metadata);
+
+	if (user_mode(regs))
+		return false;
+
+	if (!kasan_report((void *)addr, size, write, pc))
+		return false;
+
+	kasan_inline_recover(recover, "Oops - KASAN", regs, metadata, die);
+
+	return true;
+}
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 54481f8c30c5..8691ad870f3b 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -663,4 +663,28 @@ void kasan_non_canonical_hook(unsigned long addr);
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
+#ifdef CONFIG_KASAN_SW_TAGS
+/*
+ * The instrumentation allows to control whether we can proceed after
+ * a crash was detected. This is done by passing the -recover flag to
+ * the compiler. Disabling recovery allows to generate more compact
+ * code.
+ *
+ * Unfortunately disabling recovery doesn't work for the kernel right
+ * now. KASAN reporting is disabled in some contexts (for example when
+ * the allocator accesses slab object metadata; this is controlled by
+ * current->kasan_depth). All these accesses are detected by the tool,
+ * even though the reports for them are not printed.
+ *
+ * This is something that might be fixed at some point in the future.
+ */
+static inline void kasan_inline_recover(
+	bool recover, char *msg, struct pt_regs *regs, unsigned long err,
+	void die_fn(const char *str, struct pt_regs *regs, long err))
+{
+	if (!recover)
+		die_fn(msg, regs, err);
+}
+#endif
+
 #endif /* LINUX_KASAN_H */
-- 
2.50.1


