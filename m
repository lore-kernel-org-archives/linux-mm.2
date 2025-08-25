Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B8CC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFAC08E0079; Mon, 25 Aug 2025 16:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB088E0038; Mon, 25 Aug 2025 16:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A735A8E0079; Mon, 25 Aug 2025 16:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF5C8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:30:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3241359624
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:30:11 +0000 (UTC)
X-FDA: 83816421822.27.A18D7CF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 16EAB140005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:30:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="i/qPBn4k";
	spf=pass (imf26.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153809; a=rsa-sha256;
	cv=none;
	b=IjpOiSBVKmJZkhuibIAO3V5IsXGzznI9MYTTa6Oo8h26zxjwAjPEUfMWLkiTX0u0k29Huy
	iUA+LPUvIM4APmqTbjQxuW8Z7Lq4OxKUa46WNrAty9nV9sPTte03Egh5zKzS1MDLtRQqli
	VbSmph4knySrICdHU+tmXAzS3fwKF8g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="i/qPBn4k";
	spf=pass (imf26.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0YCoxoZqLoXaL5waUCXEhDq4RCJHfZGu425YupVVaA=;
	b=61Ymv9zwCQzHEd1PAfyGyymEL4LWwh9pL5DM4Va7X1nDsc4KwEiPxRuqPIDeLjjI/lHorg
	7e3OaHWAthoXNYFgUCXFTAppo5bYvETKkBjWlmDpJXC0h45DyJqewQ0NT5cJCgyb9suAtm
	H5cOinBDkcZX78im1sjG3QAgZJPcL6Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153809; x=1787689809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wCUttCeNVNt2cxw/+y56mfzdcewM6JgdgPOTwEP1rEY=;
  b=i/qPBn4k/Vf3GwNVvldYJkX630sgDXhD1X/apl+cqVT8uG1Gb7vswJEh
   aaKVymErTWGRUi3qkNBLuD4daNlWlEphenUzktFImjehhk2FRuOsplbI4
   AgTuufvj09WtXsKcdtzMQ8gyStbjBcl+mYoRGgNcH8ietPsU8GtAZ5+CL
   cFHOP5Kml34gVA+/FkuKJ2mwBu6pHsVp6U3zdxzcJeH4OimN9e4FcdyVv
   mbKnxUMk3rBdItr1l5irB7tq0dnegAj+owLHRoTiED6VAQ/w1jvzrojEH
   l1pA3U40SykYTShU1e6jChi+wS+85KqXSSRhd+gme+9ffD8MqswqigcTn
   Q==;
X-CSE-ConnectionGUID: dhOuDwVJQH6LGGgRgR/8Qg==
X-CSE-MsgGUID: lUHlXipYRtim+FkD3k+cBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970910"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970910"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:30:07 -0700
X-CSE-ConnectionGUID: vVb0osiSTzynXkLiboYB/w==
X-CSE-MsgGUID: DrJ+CdCFQni2g9dVLCwjCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780722"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:29:44 -0700
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
Subject: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
Date: Mon, 25 Aug 2025 22:24:38 +0200
Message-ID: <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16EAB140005
X-Stat-Signature: h8sequn91qkeo4rkyzhrxshio4rkfsxd
X-Rspam-User: 
X-HE-Tag: 1756153808-680954
X-HE-Meta: U2FsdGVkX182qjDPyUjrqOS21rS3+55PzL+oSo9mIP2yZbWacmZgTHqzK8Ov6ctldmsWC75DLwDHR5LU55OnvTMDTyq/t6XU6iwLW/gLbhmUyqzjflfg7y0HOvc2GOvyvFqhtCYt1zCZWP7/KHc/DNyhTasmFA0rxQuIukZKF6j7DeV+C7C11uF2JQh5xzcdw8v45QXRSUBfahLxtLJJtGj9tTlA4JQfNI5ufxEwkSrqcD2zveiR7ku1lWuMdu/mIedeKJcMlJ9JiZ0EXC+9bXJ1RFblncIriSVoe3WGfQqUdng4HtgodI4PJJQhQLCJnE+HcAjs9V1SnCuV4+t1AqI5m8biob8HWxVthzQlvPfdqJQpuC9gUPgmCP70Z19rHKT9bvtg1y/1yDR8o7zNtynXbYJZpg8RDzqJpXXVD1pPQRkt42Yqn3rW3F7dzy5uMtyyUMjqhB+eEDT7f0MVAqb+Yi5ScFvhVvoOHYRa3i3lYE/JKlzM7K1aZjmCt3mlZZqiGVQtL3PRBi2F9U14bqbESAoT/fjQ2I+tk1a1dInFIRmpkw1TNw0zk8/vD7FUVdRelY+EguBINMDo8c6+bIB8Zcnb1pjvNC/vqjyK2XlYiMghnPBHL7y6X71kyeUrc0im5Iq7CCc4vMa/1pnxk0lzG4Z9ED9EUGONDLmYhaLhOSaY4KoyK+TAWNH7u6atvIMrms3SmHYHh5ijiDxUXRhvOni0dnblonf24RRxAe55/rPsQcsSFLVs1FFGo/bMKJdr+bXH/VlxcHyby4TlvgOc2HRFkqWCagIUP6KsSYRDuX7ApRuj4oT8q+8G6tbG9EfUSB3VOznNz9mmYZeH7s5rsyjzizN31RdQbrsB46Sx31QRcgoGpYRbjWjs5IZ8x5FYUq+LgtHdOLjUEbH1IkR4ofl5QLu/aggx6ULwkmM2BNnhgMgOnI1sjg3h3zaeROfI7LugA9tInw2rW0Z
 cdPTunzm
 DxXAvbSrSpXyAfux7QF1S7lvXjAJxwStTH+EgWqxnzsuRQxjLahXIt7HCzxCaFQgawFDtEWe6wtREzdf/TCRkk02YKdh3kmHz9NhJ4BqvQY+IEu+bOocLaBOhXOtHOV3ec/NTVdrFwbkoBeTk86hZQzm27oHbniYD4YegezgyX6yDiVtfVG+yX16RB2WliHDi/rZ6ShGeJ+UFZjDIt/th38A6bdXGSaUct7So5RmFyPg/HLVfiS8MmmMnh2igOEj4IJw/7EcTqQSLaBcal7n4VvdydA==
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
Changelog v5:
- Add die to argument list of kasan_inline_recover() in
  arch/arm64/kernel/traps.c.

Changelog v4:
- Make kasan_handler() a stub in a header file. Remove #ifdef from
  traps.c.
- Consolidate the "recover" comment into one place.
- Make small changes to the patch message.

 MAINTAINERS                   |  2 +-
 arch/x86/include/asm/kasan.h  | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/alternative.c |  4 +++-
 arch/x86/kernel/traps.c       |  4 ++++
 arch/x86/mm/Makefile          |  2 ++
 arch/x86/mm/kasan_inline.c    | 23 +++++++++++++++++++++++
 include/linux/kasan.h         | 24 ++++++++++++++++++++++++
 7 files changed, 83 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/mm/kasan_inline.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 788532771832..f5b1ce242002 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13177,7 +13177,7 @@ S:	Maintained
 B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kasan.rst
 F:	arch/*/include/asm/*kasan*.h
-F:	arch/*/mm/kasan_init*
+F:	arch/*/mm/kasan_*
 F:	include/linux/kasan*.h
 F:	lib/Kconfig.kasan
 F:	mm/kasan/
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


