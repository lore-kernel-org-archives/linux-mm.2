Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0005CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A068E008C; Mon, 11 Aug 2025 13:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A8F8E0045; Mon, 11 Aug 2025 13:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820A28E008C; Mon, 11 Aug 2025 13:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70B958E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:36:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06248160240
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:36:42 +0000 (UTC)
X-FDA: 83765181444.29.06BF86D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4F0A940013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:36:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+31wXn/low5JC7UymuA++AaJ/YjM9ZTp4UXMP2CfMoA=;
	b=m1uCaf/o3i+tUQ6a4CwkU+3IQN6pf+GNCfmeG6XyWpYd7tMGobO6ZyE4s2yiJoKY+2w79Y
	83VZQrvU3chRHxQan5b3lVSDc31H7xp3NWchVjnzZ0hNWf8cPHLS11QGQbQYP9NSNTgWMF
	2ECVd0I8ac/ZzwZGVBtwx6G1quMrMsQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933800; a=rsa-sha256;
	cv=none;
	b=MsipvfDrmj7Jjf0zNXijgARwOBA6K4QCx42nsbY+ZCnyaNnAYCODSCgIwqpVokJc+s3dEZ
	dB/SYTfck0zSXyfXGgcDmcWyRMBhGLS2vG7+/uefHB2S3v/QOI46ULHkpxSHFU4zGNfkwq
	O7m21RqEKa3m3jfa0azcAQPu2nvLNKc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C99A22680;
	Mon, 11 Aug 2025 10:36:30 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0E3AD3F63F;
	Mon, 11 Aug 2025 10:36:34 -0700 (PDT)
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
Subject: [PATCH 1/2] kasan/hw-tags: introduce store only mode
Date: Mon, 11 Aug 2025 18:36:25 +0100
Message-Id: <20250811173626.1878783-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811173626.1878783-1-yeoreum.yun@arm.com>
References: <20250811173626.1878783-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F0A940013
X-Rspamd-Server: rspam06
X-Stat-Signature: dfrgu5b8s5zey91qqtzce67riy9pkjbc
X-HE-Tag: 1754933800-734824
X-HE-Meta: U2FsdGVkX19edxUbbAJJ5YzNgYpKc6MI3GFWZigTwrxc4lebCIWi5Oi1FmPujoOjM52I44DnVNbOQuXJBs2MmGLHSW6f04CDlALxzUi7JgA40rhVq74lwXojHBzS6PalOewnkO6okxagY6mlPm+PSMYzhkUsX6ZEMITSgx9j19eT6v8IJW3LYO7cnwIhGloLq/M5I2Xy/78a+1TwcPlTD1GHFaZSSukcK82ol/SLrWiyBlWZnqHdGYtI7X9axH0UgosRA6Cj713wh5lkOBRmckinSiMfJ5m6wxyrCu86moBO7GZYFVXNdVZ+sxufHwyWUCRoRk82qFpt7Ffa30iLFpoTCK0iqKAXRAybW6V8PwAA0h0084aDTqTTkMOebAuuifG7OWmP6IyzMiwlEAhWrsdfa7mnZjZfVjVt3DuNXE0kPX/2bOOcqjs0LGzO3MHzYoyxQ4kYM1zEhvQl1f+CK5WKIhTH/M52h0NlZ1Xbc7nqUFDHUwVmmNaj01Yi4wkWimvzUmdZZd1zkDeXZXZ3pLkIGL+2GFQSjic5Di6ZZNC6Rxi+lynIg0OiYKBP4il1Mo850nDWLBpJisDt4zZ9uesWc5o5f4AZk508vhieYytSFC/xcmaFqeT5C40Zb/lzwYfCRl++Enphf7JBV/BUQguDCdXihKxPtRiOE5vQq8GkiVOMlWO3YqOOFG8HqbRiCDZsmjLDqvKvRfCU+7o7Wr10BZ9XLlmVsIlypKwi5muvYGcJvG7Jml2FKMauBxfUegOKptAg63jqaSdN9sJWeVuvEK3UbtBDOSvDvpvNKxS215qj6UcWGSTOU6yc+jOc2Tc4wLb4pDL9znVLJfvomtC36Tw2zQGTKR3GMEoivWbNhzgRE3vwj5ixNyTve3Ts4H5HDpGDtbxUk5tIxz/gAReknj4fiA8062IICXyFLl5xfzfbHxP/OpuREEC/pALW5TVznmTQlCGRL1OKXR4
 TY+D7Z8Q
 Zl4Zp2U5dztIKCM2SuWnXsb5DQJ++BZE8/1NtxVwGjQeEk8YPvjNmCts2uPl+39hiaOqyzyzkWtodxxcK+yBchCz8MpASRDcK3adkss5JYmv91CsXpvkQrv51pzWBCFCYBwwBMgq9MM/DRO7Gfv+zhMOAeiBCBwZHce6ekVAaBT4aErlgpqRyhOWFyocqxXz1ysU5y0tGrdBUJUbLbv420/49w+aCVI7nIURv
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

This features can be controlled with "kasan.stonly" arguments.
When "kasan.stonly=on", KASAN checks store only mode otherwise
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
index 0a1418ab72fd..7567a2ca0e39 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -163,6 +163,9 @@ disabling KASAN altogether or controlling its features:
   This parameter is intended to allow sampling only large page_alloc
   allocations, which is the biggest source of the performance overhead.
 
+- ``kasan.stonly=off`` or ``kasan.stonly=on`` controls whether KASAN checks
+  store operation only or all operation.
+
 Error reports
 ~~~~~~~~~~~~~
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 5213248e081b..9d8c72c9c91f 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr, u8 tag)
 #define arch_enable_tag_checks_sync()		mte_enable_kernel_sync()
 #define arch_enable_tag_checks_async()		mte_enable_kernel_async()
 #define arch_enable_tag_checks_asymm()		mte_enable_kernel_asymm()
+#define arch_enable_tag_checks_stonly()	mte_enable_kernel_stonly()
 #define arch_suppress_tag_checks_start()	mte_enable_tco()
 #define arch_suppress_tag_checks_stop()		mte_disable_tco()
 #define arch_force_async_tag_fault()		mte_check_tfsr_exit()
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 2e98028c1965..d75908ed9d0f 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range(void *addr, size_t size, u8 tag,
 void mte_enable_kernel_sync(void);
 void mte_enable_kernel_async(void);
 void mte_enable_kernel_asymm(void);
+int mte_enable_kernel_stonly(void);
 
 #else /* CONFIG_ARM64_MTE */
 
@@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asymm(void)
 {
 }
 
+static inline int mte_enable_kenrel_stonly(void)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_ARM64_MTE */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9ad065f15f1d..fdc510fe0187 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 
 	kasan_init_hw_tags_cpu();
 }
+
+static void cpu_enable_mte_stonly(struct arm64_cpu_capabilities const *cap)
+{
+	kasan_late_init_hw_tags_cpu();
+}
 #endif /* CONFIG_ARM64_MTE */
 
 static void user_feature_fixup(void)
@@ -2922,6 +2927,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_MTE_STORE_ONLY,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_mte_stonly,
 		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
 	},
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e773844889..a1cb2a8a79a1 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
 		mte_enable_kernel_sync();
 	}
 }
+
+int mte_enable_kernel_stonly(void)
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
index 9a6927394b54..2caa6fe5ed47 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
+enum kasan_arg_stonly {
+	KASAN_ARG_STONLY_DEFAULT,
+	KASAN_ARG_STONLY_OFF,
+	KASAN_ARG_STONLY_ON,
+};
+
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
+static enum kasan_arg_stonly kasan_arg_stonly __ro_after_init;
 
 /*
  * Whether KASAN is enabled at all.
@@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
 #endif
 EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
+DEFINE_STATIC_KEY_FALSE(kasan_flag_stonly);
+EXPORT_SYMBOL_GPL(kasan_flag_stonly);
+
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
 
@@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
 }
 early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
 
+/* kasan.stonly=off/on */
+static int __init early_kasan_flag_stonly(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_stonly = KASAN_ARG_STONLY_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_stonly = KASAN_ARG_STONLY_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.stonly", early_kasan_flag_stonly);
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
+	kasan_enable_stonly();
+}
+
 /* kasan_init_hw_tags() is called once on boot CPU. */
 void __init kasan_init_hw_tags(void)
 {
@@ -257,15 +298,28 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
+	switch (kasan_arg_stonly) {
+	case KASAN_ARG_STONLY_DEFAULT:
+		/* Default is specified by kasan_flag_stonly definition. */
+		break;
+	case KASAN_ARG_STONLY_OFF:
+		static_branch_disable(&kasan_flag_stonly);
+		break;
+	case KASAN_ARG_STONLY_ON:
+		static_branch_enable(&kasan_flag_stonly);
+		break;
+	}
+
 	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
 	static_branch_enable(&kasan_flag_enabled);
 
-	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s stonly=%s\n",
 		kasan_mode_info(),
 		str_on_off(kasan_vmalloc_enabled()),
-		str_on_off(kasan_stack_collection_enabled()));
+		str_on_off(kasan_stack_collection_enabled()),
+		str_on_off(kasan_stonly_enabled()));
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
@@ -394,6 +448,22 @@ void kasan_enable_hw_tags(void)
 		hw_enable_tag_checks_sync();
 }
 
+void kasan_enable_stonly(void)
+{
+	if (kasan_arg_stonly == KASAN_ARG_STONLY_ON) {
+		if (hw_enable_tag_checks_stonly()) {
+			static_branch_disable(&kasan_flag_stonly);
+			kasan_arg_stonly = KASAN_ARG_STONLY_OFF;
+			pr_warn_once("KernelAddressSanitizer: store only mode isn't supported (hw-tags)\n");
+		}
+	}
+}
+
+bool kasan_stonly_enabled(void)
+{
+	return static_branch_unlikely(&kasan_flag_stonly);
+}
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
@@ -404,4 +474,6 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
 }
 EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
 
+EXPORT_SYMBOL_IF_KUNIT(kasan_stonly_enabled);
+
 #endif
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e64..cfbcebdbcbec 100644
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
+#define hw_enable_tag_checks_stonly()		arch_enable_tag_checks_stonly()
 #define hw_suppress_tag_checks_start()		arch_suppress_tag_checks_start()
 #define hw_suppress_tag_checks_stop()		arch_suppress_tag_checks_stop()
 #define hw_force_async_tag_fault()		arch_force_async_tag_fault()
@@ -437,10 +439,18 @@ static inline const void *arch_kasan_set_tag(const void *addr, u8 tag)
 			arch_set_mem_tag_range((addr), (size), (tag), (init))
 
 void kasan_enable_hw_tags(void);
+void kasan_enable_stonly(void);
+bool kasan_stonly_enabled(void);
 
 #else /* CONFIG_KASAN_HW_TAGS */
 
 static inline void kasan_enable_hw_tags(void) { }
+static inline void kasan_enable_stonly(void) { }
+
+static inline bool kasan_stonly_enabled(void)
+{
+	return false;
+}
 
 #endif /* CONFIG_KASAN_HW_TAGS */
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


