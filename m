Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C6ECA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 07:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817DE8E0028; Wed, 20 Aug 2025 03:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7D58E0011; Wed, 20 Aug 2025 03:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDDE8E0028; Wed, 20 Aug 2025 03:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DECB8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 03:12:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B1ED1384CC
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:12:56 +0000 (UTC)
X-FDA: 83796268752.10.EA67D04
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F77580008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:12:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755673974; a=rsa-sha256;
	cv=none;
	b=YPL7QW9gQv2wnHuOKtM/nbSSov0dm4mITV1g2LvmrWWLNdd0Mfm1ghSBR+u2FXtv51J+Nx
	FJ0wkBGKHnJkkCHgfcrj95aRLdzcE5xycGA42AKVEUOHR3GmW9qyMiVJbKVXZnJA3/97+R
	nBK0PU+OWZ0mJtVKRnw715jNrG5OvnU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755673974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2C6r5BJpglJYzz5+EWJhInfvCmd+vFPmp3AQ+FGdsg=;
	b=WtrTwdC3wTAjqXlqLEHFwHfCCaNhG6WgKoIXpK2MzjjVOVc4g8Jk37TOmTCSljXry+bfZ8
	nohrMIt8gt6myKvvDvyWmb1ITrIYlyMhGTrm0D5jdXg1htFW69a1qYaoK37Ha5AqdxYcNN
	v64KKBebbL4aMeStJj9l3EMqbrt1brE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F09681D31;
	Wed, 20 Aug 2025 00:12:44 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4938B3F58B;
	Wed, 20 Aug 2025 00:12:49 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	scott@os.amperecomputing.com,
	jhubbard@nvidia.com,
	pankaj.gupta@amd.com,
	leitao@debian.org,
	kaleshsingh@google.com,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io,
	david@redhat.com,
	yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v5 1/2] kasan/hw-tags: introduce kasan.write_only option
Date: Wed, 20 Aug 2025 08:12:42 +0100
Message-Id: <20250820071243.1567338-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250820071243.1567338-1-yeoreum.yun@arm.com>
References: <20250820071243.1567338-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F77580008
X-Stat-Signature: 3fmrcfmg9c5t6hybsayw3fkwyzskwza4
X-HE-Tag: 1755673974-918520
X-HE-Meta: U2FsdGVkX19qRUDlVqpJN1yIIlFI7ByH9UMjkjkvBROHtgJ7yaKGXw4Z4wQAyZxE/0r1sgvKnX5h2d7n0hLVQ1LabHrDZnCdX3UuO/uEuT+g82enR1cxBbEFjiVtli7pHFGXpyPuT/ZXZu9hwJvBYDV1HZEJn+iKXuz9K5C0k6iv7ve/huvz83vJARivvLfWMKUFCHLyAZfT4EL1W401oINgqzO3tk4p/tpzUf9LpmMefrJ6CdXArsgYAUwqJjlSGTQPfzv7g2SdsoSIeYkoix9U7+ZaDYui/sQ4a0X8bq167GdRCX7EFF7aaIB3QPNtxp7SCkezF6uEv5WtqWrAd/tvqvNsTPNbmpPdmrbq6Zc2kdKGnaYlBPgepqKbiH2PmZCuHq3P9cfHFtfGwtMQv4w0vW6Ic1kso6oPXKw+Jw5MRCxDdDuHb7jwAOR/IgSDbUbfuK5JYcnzLHrN0AIgBUoLAZcUyL0SknRWrmeEY7qN2xhNr5Dk3OKUR9L+OACZoS4XP1cPVPZ8mRH8tlL1xoto+DfAToeDX2DLs7ucKy8WxBYNanSAISjACtgqGLyVV0Y4baIO9/pIhVJ5emS5zzAThW25EyQ0By2B9N4/zFSv0W97GZfpU5/8EM4y3L6oWX7pXRpyydNu+6dJLBaNAHicYmh4uDW8ENcuwwTfi0qMO23iLXCodMhASNPHFFaVxaasN5Lh3i+Cc2fbj/O8nY/DeB1Vl/OhSjiZsib+++OheDgqYt/JPtkGIbq8Ks6qkOJATNcr0SYkdxzhivD9xA1j+bBWb/YSQnh1wPAlZ9+U7o50LPyccFrVL3BoqJALBPIszOX0mPzbnz8SNKt14iOvYPSnuVBJ6lQv5pv+li74AWIOfAxQ8SfbmU6vtHxoL8UbtRj1qnl9/Pe4zpPqdDWLWu200vK76/PMqVp3MwyYLKNDp0neslUzfUwJdygfKScYVuwIlC3nIvRDo/H
 9UANjs6h
 Tnjd1VBJn25uHue9JGV8lcWRpTq9q1/pm7m1dnFv+p2M2NuB5BfFiIycbNnH/XGoZpKliBHWzI61b5VPawdsZmLJTaPGPnmibgzr4iIOt5JlijP0b+HdugXCtqzSr2XeeZ+g4oA5YHlLFcoWdrFxiYHYbN4WRDsxeQmmuwXr9VTvpIsMkNMfdmiej9X9vBT/ptqgD4AtbT6I8MT2+q1ANi8ZDgF4SpFeIPylpTQkuZZIuoH7p3ry/MxkFXHswFWhXaRIkOznu+2iJg0jPnQZLwzq+OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
raise of tag check fault on store operation only.
Introcude KASAN write only mode based on this feature.

KASAN write only mode restricts KASAN checks operation for write only and
omits the checks for fetch/read operations when accessing memory.
So it might be used not only debugging enviroment but also normal
enviroment to check memory safty.

This features can be controlled with "kasan.write_only" arguments.
When "kasan.write_only=on", KASAN checks write operation only otherwise
KASAN checks all operations.

This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
with other function together.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 Documentation/dev-tools/kasan.rst  |  3 ++
 arch/arm64/include/asm/memory.h    |  1 +
 arch/arm64/include/asm/mte-kasan.h |  6 +++
 arch/arm64/kernel/cpufeature.c     |  2 +-
 arch/arm64/kernel/mte.c            | 18 ++++++++
 mm/kasan/hw_tags.c                 | 70 +++++++++++++++++++++++++++++-
 mm/kasan/kasan.h                   |  7 +++
 7 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index 0a1418ab72fd..fe1a1e152275 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -143,6 +143,9 @@ disabling KASAN altogether or controlling its features:
   Asymmetric mode: a bad access is detected synchronously on reads and
   asynchronously on writes.
 
+- ``kasan.write_only=off`` or ``kasan.write_only=on`` controls whether KASAN
+  checks the write (store) accesses only or all accesses (default: ``off``)
+
 - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
   allocations (default: ``on``).
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 5213248e081b..f1505c4acb38 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr, u8 tag)
 #define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
 #define arch_enable_tag_checks_async()		mte_enable_kernel_async()
 #define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
+#define arch_enable_tag_checks_write_only()	mte_enable_kernel_store_only()
 #define arch_suppress_tag_checks_start()	mte_enable_tco()
 #define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 2e98028c1965..0f9b08e8fb8d 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag,
 void mte_enable_kernel_sync(void);
 void mte_enable_kernel_async(void);
 void mte_enable_kernel_asymm(void);
+int mte_enable_kernel_store_only(void);
 
 #else /* CONFIG_ARM64_MTE */
 
@@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asymm(void)
 {
 }
 
+static inline int mte_enable_kernel_store_only(void)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9ad065f15f1d..505bd56e21a2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2920,7 +2920,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Store Only MTE Tag Check",
 		.capability = ARM64_MTE_STORE_ONLY,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
 	},
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e773844889..54a52dc5c1ae 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -157,6 +157,24 @@ void mte_enable_kernel_asymm(void)
 		mte_enable_kernel_sync();
 	}
 }
+
+int mte_enable_kernel_store_only(void)
+{
+	/*
+	 * If the CPU does not support MTE store only,
+	 * the kernel checks all operations.
+	 */
+	if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
+		return -EINVAL;
+
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
+			 SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
+	isb();
+
+	pr_info_once("MTE: enabled store only mode at EL1\n");
+
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 9a6927394b54..334e9e84983e 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
+enum kasan_arg_write_only {
+	KASAN_ARG_WRITE_ONLY_DEFAULT,
+	KASAN_ARG_WRITE_ONLY_OFF,
+	KASAN_ARG_WRITE_ONLY_ON,
+};
+
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
+static enum kasan_arg_write_only kasan_arg_write_only __ro_after_init;
 
 /*
  * Whether KASAN is enabled at all.
@@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
 #endif
 EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
+/* Whether to check write access only. */
+static bool kasan_flag_write_only = false;
+
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
 
@@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
 }
 early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
 
+/* kasan.write_only=off/on */
+static int __init early_kasan_flag_write_only(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.write_only", early_kasan_flag_write_only);
+
 static inline const char *kasan_mode_info(void)
 {
 	if (kasan_mode == KASAN_MODE_ASYNC)
@@ -257,15 +284,28 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
+	switch (kasan_arg_write_only) {
+	case KASAN_ARG_WRITE_ONLY_DEFAULT:
+		/* Default is specified by kasan_flag_write_only definition. */
+		break;
+	case KASAN_ARG_WRITE_ONLY_OFF:
+		kasan_flag_write_only = false;
+		break;
+	case KASAN_ARG_WRITE_ONLY_ON:
+		kasan_flag_write_only = true;
+		break;
+	}
+
 	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
 	static_branch_enable(&kasan_flag_enabled);
 
-	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s\n",
 		kasan_mode_info(),
 		str_on_off(kasan_vmalloc_enabled()),
-		str_on_off(kasan_stack_collection_enabled()));
+		str_on_off(kasan_stack_collection_enabled()),
+		str_on_off(kasan_arg_write_only));
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
@@ -392,6 +432,26 @@ void kasan_enable_hw_tags(void)
 		hw_enable_tag_checks_asymm();
 	else
 		hw_enable_tag_checks_sync();
+
+	/*
+	 * CPUs can only be in one of two states:
+	 *   - All CPUs support the write_only feature
+	 *   - No CPUs support the write_only feature
+	 *
+	 * If the first CPU attempts hw_enable_tag_checks_write_only() and
+	 * finds the feature unsupported, kasan_arg_write_only is set to OFF
+	 * to avoid further unnecessary calls on other CPUs.
+	 *
+	 * Although this could be tracked with a single variable, both
+	 * kasan_arg_write_only (boot argument) and kasan_flag_write_only
+	 * (hardware state) are kept separate, consistent with other options.
+	 */
+	if (kasan_arg_write_only == KASAN_ARG_WRITE_ONLY_ON &&
+	    hw_enable_tag_checks_write_only()) {
+		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_OFF;
+		kasan_flag_write_only = false;
+		pr_err_once("write-only mode is not supported and thus not enabled\n");
+	}
 }
 
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
@@ -404,4 +464,10 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
 }
 EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
 
+VISIBLE_IF_KUNIT bool kasan_write_only_enabled(void)
+{
+	return kasan_flag_write_only;
+}
+EXPORT_SYMBOL_IF_KUNIT(kasan_write_only_enabled);
+
 #endif
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e64..844eedf2ef9c 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -431,6 +431,7 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
 #define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
 #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
+#define hw_enable_tag_checks_write_only()	arch_enable_tag_checks_write_only()
 #define hw_get_random_tag()			arch_get_random_tag()
 #define hw_get_mem_tag(addr)			arch_get_mem_tag(addr)
 #define hw_set_mem_tag_range(addr, size, tag, init) \
@@ -451,11 +452,17 @@ void __init kasan_init_tags(void);
 #if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_force_async_fault(void);
+bool kasan_write_only_enabled(void);
 
 #else /* CONFIG_KASAN_HW_TAGS && CONFIG_KASAN_KUNIT_TEST */
 
 static inline void kasan_force_async_fault(void) { }
 
+static inline bool kasan_write_only_enabled(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_KASAN_HW_TAGS && CONFIG_KASAN_KUNIT_TEST */
 
 #ifdef CONFIG_KASAN_SW_TAGS
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


