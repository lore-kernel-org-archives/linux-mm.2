Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE33C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23269000BD; Wed, 13 Aug 2025 13:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3C2900088; Wed, 13 Aug 2025 13:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74009000BD; Wed, 13 Aug 2025 13:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA0FC900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:53:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 654C7137F34
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:53:48 +0000 (UTC)
X-FDA: 83772482136.24.52A0606
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9846A8000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:53:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755107626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jqxOFgCfRl5wZ83QA7FvuO3ex3Ygy/hpF6Az2tCTtf8=;
	b=ETkwNd4qT+Uaw/cLWEYcot5iNpOfv7UBujFzG7XpclZ/JK7LhqR1wNRqrkvW8tBGa16+pF
	oDD6l9TGzLDbefrd2XPFQ53dz3pyrVguk8rgbu/TRlP8I8Q/BFzOCP9MJ626f/UdgTh+TH
	Yf3kUYw8FXiYxN2emvOHfHxSLFxigIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755107626; a=rsa-sha256;
	cv=none;
	b=LYaPQKkkdywW05SQUXyh+WtVFTdU9x0GxfRZNFBYbiQiODEj03CtSVVfYWj3ZL9nEROvVm
	EI4vNwPsmfhZGm6EbrjKmsdYzHxSVzFELpN3WXMK/ik9t+zsiMjw0XbVexaUtPv+j09HGC
	lpeADc+wZxrlAAXAtakXW2QO0Q5SVAo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D8C814BF;
	Wed, 13 Aug 2025 10:53:37 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C8493F5A1;
	Wed, 13 Aug 2025 10:53:41 -0700 (PDT)
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
Subject: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Date: Wed, 13 Aug 2025 18:53:34 +0100
Message-Id: <20250813175335.3980268-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813175335.3980268-1-yeoreum.yun@arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9846A8000C
X-Stat-Signature: ynrx7drdcrfghytp9oixftnaktrfkqfe
X-Rspam-User: 
X-HE-Tag: 1755107626-445121
X-HE-Meta: U2FsdGVkX19ktwDUarkjIrYQOQCiD0TjDUFcZxaF2N7kDyYN7Wi3tgfup+jQLcbA97MLzuNtrhbJH/tWzCe9Q9hd7PKyAJrP5qTNKJMC4VQp58U7IaeONuKK26tSKJGiq0WkPV0xuTWOJYOCby4KSbmNsku38udcaSg4KvFfzQtdUZmdu7W7vqPkZ68DBboJkOuw4OsWFqV6dBxW4oFYekYlok0jv54LyIwI4dZKpwbpslVlidardu0mj3cTcq9tM9qlV+ZYvV8vQmeMhcg3qYEYJt/3QITc3wN+FVhzYrmaT8iTIhaAm4a2UGsgNtpQyFgyRAlm/018s6g+lRbtn8AnHLZdXjvNq7JY4dKk4ufpnzW4SdpcCK3XrI3le2d7+EFqgVHUnEOLwgPue9aRdTjB5pIF/b2wIHdrj46u72T5cv9s7G6L2kuR6tkReLkfldc5LeXoaAvcQtCbSNn0YF8Q9iBfx96TtUmiMStDgCdCPjdMvqVfJ9/wdaUVAjReR1RaxCwUDcDM+2FWYNwA7HXy1PC+AdsWpoAdRQmced4uVSWWcRbQaeP71z2kF31tm77owAp/ejX9ae/7AQqgLMR3Mzni8h77QJem1VAX/V0ZQwjyAJBCAPVjvMLf+cJaPzrFfkyTikXNdKOh5WAR2OUTrhgXDz4Fl4ucRlaGBGx/kTnWRhJ7Wmo2cd1EcrlfJC96gaPuiu5xIrvRDvkP/VqeFpJ4WqmrmYOGNpM311i2RfCgNyz6hfpjD08fO/lVaiGkVm9GUifuuXU/NuqgntLVQ2qyoYB5me+BCEb/p+LPRzTkRQ585PoH9HOYq+/5agz7Mq9JwYUxw3OY5F7vojM0vvjtmvUNzxTqCayaFa781GJBoDzRCe0vEKKq8tch5vl7s71Lza6dIzv+DlcRd2jIPqxD0ZxRKQBiCYidlyzo+W/P6k+DujxL/B2mSsvbIbbYweLFewakMOvERkk
 8kXnK1Ti
 o9p7r0LN54kjtgucb1KNFGp9G/m6bV+yks88GVVRT9seLHcMRmJ0mWBUzWP92P0dQ5tWkeowbLceGQyh5E/oMInwKzSZJpcNSruzt8eKsRoax+eAE9oUsmzLu+ZAh3eJPo/BCXbq33wnC7hHjR78Z8nPOu4Kxi1hyWvcDjkPjrzU+MDvPofTqtcNzBqcHmpbUNBx16Nd9FJir3YaDYoY1HtjmIH7UWCnukjaVYGYIqxOka4nUxbLqdyPX5KiXJxB6LwWvrFNVbwWQunHxLbhSk2kbOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
raise of tag check fault on store operation only.
Introcude KASAN store only mode based on this feature.

KASAN store only mode restricts KASAN checks operation for store only and
omits the checks for fetch/read operation when accessing memory.
So it might be used not only debugging enviroment but also normal
enviroment to check memory safty.

This features can be controlled with "kasan.store_only" arguments.
When "kasan.store_only=on", KASAN checks store only mode otherwise
KASAN checks all operations.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 Documentation/dev-tools/kasan.rst  |  3 ++
 arch/arm64/include/asm/memory.h    |  1 +
 arch/arm64/include/asm/mte-kasan.h |  6 +++
 arch/arm64/kernel/cpufeature.c     |  6 +++
 arch/arm64/kernel/mte.c            | 14 ++++++
 include/linux/kasan.h              |  2 +
 mm/kasan/hw_tags.c                 | 76 +++++++++++++++++++++++++++++-
 mm/kasan/kasan.h                   | 10 ++++
 8 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index 0a1418ab72fd..fcb70dd821ec 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -143,6 +143,9 @@ disabling KASAN altogether or controlling its features:
   Asymmetric mode: a bad access is detected synchronously on reads and
   asynchronously on writes.
 
+- ``kasan.store_only=off`` or ``kasan.store_only=on`` controls whether KASAN
+  checks the store (write) accesses only or all accesses (default: ``off``)
+
 - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
   allocations (default: ``on``).
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 5213248e081b..ae29cd3db78d 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr, u8 tag)
 #define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
 #define arch_enable_tag_checks_async()		mte_enable_kernel_async()
 #define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
+#define arch_enable_tag_checks_store_only()	mte_enable_kernel_store_only()
 #define arch_suppress_tag_checks_start()	mte_enable_tco()
 #define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 2e98028c1965..3e1cc341d47a 100644
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
 
+static inline int mte_enable_kenrel_store_only(void)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9ad065f15f1d..7b724fcf20a7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 
 	kasan_init_hw_tags_cpu();
 }
+
+static void cpu_enable_mte_store_only(struct arm64_cpu_capabilities const *cap)
+{
+	kasan_late_init_hw_tags_cpu();
+}
 #endif /* CONFIG_ARM64_MTE */
 
 static void user_feature_fixup(void)
@@ -2922,6 +2927,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_MTE_STORE_ONLY,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_mte_store_only,
 		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
 	},
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e773844889..8eb1f66f2ccd 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
 		mte_enable_kernel_sync();
 	}
 }
+
+int mte_enable_kernel_store_only(void)
+{
+	if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
+		return -EINVAL;
+
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
+			 SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
+	isb();
+
+	pr_info_once("MTE: enabled stonly mode at EL1\n");
+
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..28951b29c593 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -552,9 +552,11 @@ static inline void kasan_init_sw_tags(void) { }
 #ifdef CONFIG_KASAN_HW_TAGS
 void kasan_init_hw_tags_cpu(void);
 void __init kasan_init_hw_tags(void);
+void kasan_late_init_hw_tags_cpu(void);
 #else
 static inline void kasan_init_hw_tags_cpu(void) { }
 static inline void kasan_init_hw_tags(void) { }
+static inline void kasan_late_init_hw_tags_cpu(void) { }
 #endif
 
 #ifdef CONFIG_KASAN_VMALLOC
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 9a6927394b54..c2f90c06076e 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
+enum kasan_arg_store_only {
+	KASAN_ARG_STORE_ONLY_DEFAULT,
+	KASAN_ARG_STORE_ONLY_OFF,
+	KASAN_ARG_STORE_ONLY_ON,
+};
+
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
+static enum kasan_arg_store_only kasan_arg_store_only __ro_after_init;
 
 /*
  * Whether KASAN is enabled at all.
@@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
 #endif
 EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
+DEFINE_STATIC_KEY_FALSE(kasan_flag_store_only);
+EXPORT_SYMBOL_GPL(kasan_flag_store_only);
+
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
 
@@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
 }
 early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
 
+/* kasan.store_only=off/on */
+static int __init early_kasan_flag_store_only(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_store_only = KASAN_ARG_STORE_ONLY_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_store_only = KASAN_ARG_STORE_ONLY_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.store_only", early_kasan_flag_store_only);
+
 static inline const char *kasan_mode_info(void)
 {
 	if (kasan_mode == KASAN_MODE_ASYNC)
@@ -219,6 +246,20 @@ void kasan_init_hw_tags_cpu(void)
 	kasan_enable_hw_tags();
 }
 
+/*
+ * kasan_late_init_hw_tags_cpu_post() is called for each CPU after
+ * all cpus are bring-up at boot.
+ * Not marked as __init as a CPU can be hot-plugged after boot.
+ */
+void kasan_late_init_hw_tags_cpu(void)
+{
+	/*
+	 * Enable stonly mode only when explicitly requested through the command line.
+	 * If system doesn't support, kasan checks all operation.
+	 */
+	kasan_enable_store_only();
+}
+
 /* kasan_init_hw_tags() is called once on boot CPU. */
 void __init kasan_init_hw_tags(void)
 {
@@ -257,15 +298,28 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
+	switch (kasan_arg_store_only) {
+	case KASAN_ARG_STORE_ONLY_DEFAULT:
+		/* Default is specified by kasan_flag_store_only definition. */
+		break;
+	case KASAN_ARG_STORE_ONLY_OFF:
+		static_branch_disable(&kasan_flag_store_only);
+		break;
+	case KASAN_ARG_STORE_ONLY_ON:
+		static_branch_enable(&kasan_flag_store_only);
+		break;
+	}
+
 	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
 	static_branch_enable(&kasan_flag_enabled);
 
-	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s store_only=%s\n",
 		kasan_mode_info(),
 		str_on_off(kasan_vmalloc_enabled()),
-		str_on_off(kasan_stack_collection_enabled()));
+		str_on_off(kasan_stack_collection_enabled()),
+		str_on_off(kasan_store_only_enabled()));
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
@@ -394,6 +448,22 @@ void kasan_enable_hw_tags(void)
 		hw_enable_tag_checks_sync();
 }
 
+void kasan_enable_store_only(void)
+{
+	if (kasan_arg_store_only == KASAN_ARG_STORE_ONLY_ON) {
+		if (hw_enable_tag_checks_store_only()) {
+			static_branch_disable(&kasan_flag_store_only);
+			kasan_arg_store_only = KASAN_ARG_STORE_ONLY_OFF;
+			pr_warn_once("KernelAddressSanitizer: store only mode isn't supported (hw-tags)\n");
+		}
+	}
+}
+
+bool kasan_store_only_enabled(void)
+{
+	return static_branch_unlikely(&kasan_flag_store_only);
+}
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
@@ -404,4 +474,6 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
 }
 EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
 
+EXPORT_SYMBOL_IF_KUNIT(kasan_store_only_enabled);
+
 #endif
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e64..1d853de1c499 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -33,6 +33,7 @@ static inline bool kasan_stack_collection_enabled(void)
 #include "../slab.h"
 
 DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
+DECLARE_STATIC_KEY_FALSE(kasan_flag_stonly);
 
 enum kasan_mode {
 	KASAN_MODE_SYNC,
@@ -428,6 +429,7 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
 #define hw_enable_tag_checks_sync()		arch_enable_tag_checks_sync()
 #define hw_enable_tag_checks_async()		arch_enable_tag_checks_async()
 #define hw_enable_tag_checks_asymm()		arch_enable_tag_checks_asymm()
+#define hw_enable_tag_checks_store_only()	arch_enable_tag_checks_store_only()
 #define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
 #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
@@ -437,10 +439,18 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
 			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
 void kasan_enable_hw_tags(void);
+void kasan_enable_store_only(void);
+bool kasan_store_only_enabled(void);
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
 static inline void kasan_enable_hw_tags(void) { }
+static inline void kasan_enable_store_only(void) { }
+
+static inline bool kasan_store_only_enabled(void)
+{
+	return false;
+}
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


