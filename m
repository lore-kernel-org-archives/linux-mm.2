Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433C8CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03316B00A8; Fri, 12 Jun 2026 00:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBEA6B00AA; Fri, 12 Jun 2026 00:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CACB6B00AB; Fri, 12 Jun 2026 00:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79B6A6B00A8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:45:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E61B407A6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:45:09 +0000 (UTC)
X-FDA: 84870021138.03.72D6A09
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BD2F140007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:45:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dyprqNRX;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781239507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaKJ4a3hvN1JQ5ZyWHns6rbJ1fTSdq6LuK2dwO81y2A=;
	b=jaXeS829PnWJ0EqGHtoHXeJvcUdDei1MGF+XCfujG5lhyGJVxUPfJm0eJXwn1e9JmpDyb+
	by9ith/m3SefJdWN94yZScSagYJXqPE7LC2/raiqliGnIdOe/Ik4+IHuIMams4Rl1MWeSu
	ogGlx0vUjViRsCTL/Tz5+4vv0cq8f+8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781239507;
	b=VsnP9M/fOik39QfMMb8qo/TgB6dUhqhrBG6NBIqGxqzG+qiRFd+nzh7NsMv3pEs8Ojw7rr
	zcUQseCnZ+ilwQkJ+4WcPJJ7F4iVULFt79LLYwlGJ3/T7JY9ZRsE5+fRzvtsU45TN3DnJW
	4qno8n6Skc6l483GyiVZi4lg7TQU0ug=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dyprqNRX;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5263B2E91;
	Thu, 11 Jun 2026 21:45:01 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6A98E3FAF5;
	Thu, 11 Jun 2026 21:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781239506; bh=adMGJ7PXZloqurqObpZQmC4xZiFQ3So5xjocDZ6UB6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyprqNRXfh9wVKf2O2t0oY3N9NZr2vJGqiN+CzR4ogevyLghQcFeqWH+CH6APm3GX
	 ZX6ZCMglBYa+Nsi28vNnVLgYd7ZSS3Yymcm7FvevGna/IiGmKmLZKE1D/XZ92HG1ZO
	 R4nwE7x14jL8zdcxhGbU84hVARQ1ZI5lZut0W+Qw=
From: Dev Jain <dev.jain@arm.com>
To: ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net
Cc: Dev Jain <dev.jain@arm.com>,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	kaleshsingh@google.com,
	21cnbao@gmail.com,
	david@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com
Subject: [RFC PATCH 2/2] kasan: hw_tags: Add boot option to elide free time poisoning
Date: Fri, 12 Jun 2026 04:44:24 +0000
Message-ID: <20260612044425.763060-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BD2F140007
X-Stat-Signature: t6c9yis59wgy1d71zn45411xwufsw1x8
X-HE-Tag: 1781239506-849543
X-HE-Meta: U2FsdGVkX1/WRKWwZXJ97EjaVjTh8hg+tZmv736GKcNbKjdxQUJ52XvDUORzFf1dPOu6/4UIBltlXspfVT1AUoPnSvWRZtnmFOPag0vKtSmXOr6+s8KK0xq1kTbdQU2wtHjmWkKdiKJlfkfVD/h72W0clEDyuFNQFszzscfZf5U4sAB32GtA2I6uX9u2d7bvwNmE2rPZnF0Fyk2kRLwIMjdByOnL5bcfrTpMoWtHzzfg5JEXQjMJHEoXxVId0zzodjFMROBHPjo1VgbnS0pRGngdTEhLVLDHZUcjlIZ5m27Uj7mx1WeueVRHMgVk7iLA1io6ii6Gezcovx074ln+t+UUnbj8FuRKOdBP2nZUa+hNWubF4W2GbFh5m3joTFQRoQsHfp61VaaopJQMz+FlmShcPakQmdmbHaKTcCkQTXMzDX5M0y6sdTRdJUQw3I+g1Z9Ww+qc5m7f4C9QmDRWgUUybYo235komE/tZFFH7Z+8vYW06MwGFykFIr1/JqK7qUgQNg02am7sCl+Fu4/jnyGQXrzY1vnST6Ut66CPmdZsu4oCFcDsnpi0aeNt8OFBx7ec0ssHmzwuEz/3ZeNIqmA6+2jM8hl2Eg1vEBqCn5CcFuEYTc/N221AmfpAyY1b7ThzZjWYcAffluky6Wx906QmcJ5LmvxjCPIYRwpfY4RJrI+7NpBT4yH/WAMoFPHIoVzWOO6vlQ5D2iVoxNyrFTOTVMPutaODwsyouDw2RKyVsnFNihkspIvXZbckHloiAeDRn+IkLj61W3Tvrn2foLwn0I8I5jgFsXt0Pkt688WGhXtWowZolg0kWCgHysQFiVVzthQ7q3U5IGmj4ridjLDiGMS7vZpS0crA9OlqaWNDhW6EvDH9FfucionGBeLSG4iu2XKDrZYF1dcXWunxyUDgU6hWnK2dNgrLKg31yz7T+slaGj48Bxu6kIs44TLg2FbLT9F7kDee+4KHHhg
 CUzoRrHP
 Ex6GIGlLB/seRDInr/dykZtkw0fkzvKjk0DPLH8VpmY6ULK88U2Pf0mJysouiZeMmPip2EQjJjzkfNv2zgMZulbZO9+IjwMXZw+4yf7lTxVaJqhFci6Ki6KS3lj06ch4PGQ/Vq89xxzwvXqrAI/0tm4LOEGUjpNC2yw6tugcI5X0873UrBYgWEa2Ewvy/elhDcob34ZnAJaPBlv/zuvFrwbbkR/Wc5CU9xmjaxd3g7Xmn2v3IBg8svh7b/aY5WI9AwBOPx+xHjGA/02SlypP4O6pNQsB/znXTx1swu1oukWi9xR/en4dg+xKp+yjvws6r//nyrELR+yNvF1vCmHxizPOJrpVHG8eR73GeOyeWt+ZNlcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a boot option to tag only at allocation time of the objects. This
reduces KASAN MTE overhead, the tradeoff being reduced ability
of catching bugs.

Now, when a memory object will be freed, it will retain the random tag it
had at allocation time. This compromises on catching UAF bugs, till the
time the object is not reallocated.

Hence, not catching "use-after-free-before-reallocation" and not catching
"double-free" will be the compromise for reduced KASAN overhead.

Keep this as a boot time feature to prevent building two kernel images.

To implement the feature, we need to effectively render kasan_poison()
redundant for hw tags case, but keep it working in the case where it is
used not in an object-freeing code path, but the redzoning path (which
means, poisoning the tail end of a vmalloc or kmalloc allocation).

We achieve this by overloading the poison values for the hw tags case: we
define the four poison values as 0x0E, 0x1E, 0x2E, 0x3E. In kasan_poison(),
if we arrive with KASAN_SLAB_REDZONE or KASAN_PAGE_REDZONE, do a bitwise
OR on the value of the tag to make it equal to KASAN_TAG_INVALID.

If not, then, if init is true, zero out the memory and bail out.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 Documentation/dev-tools/kasan.rst |  4 +++
 mm/kasan/hw_tags.c                | 43 ++++++++++++++++++++++++++++++-
 mm/kasan/kasan.h                  | 23 ++++++++++++++++-
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index 4968b2aa60c80..b0c30584b5062 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -146,6 +146,10 @@ disabling KASAN altogether or controlling its features:
 - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
   allocations (default: ``on``).
 
+- ``kasan.tag_only_on_alloc=off`` or ``=on`` disables or enables skipping
+  free-time tagging (poisoning) while keeping allocation-time tagging enabled
+  (default: ``off``).
+
 - ``kasan.page_alloc.sample=<sampling interval>`` makes KASAN tag only every
   Nth page_alloc allocation with the order equal or greater than
   ``kasan.page_alloc.sample.order``, where N is the value of the ``sample``
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index c1a2b48808ed7..a392e34d11e3a 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
+enum kasan_arg_tag_only_on_alloc {
+	KASAN_ARG_TAG_ONLY_ON_ALLOC_DEFAULT,
+	KASAN_ARG_TAG_ONLY_ON_ALLOC_OFF,
+	KASAN_ARG_TAG_ONLY_ON_ALLOC_ON,
+};
+
 static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
+static enum kasan_arg_tag_only_on_alloc kasan_arg_tag_only_on_alloc __initdata;
 
 /*
  * Whether the selected mode is synchronous, asynchronous, or asymmetric.
@@ -63,6 +70,10 @@ EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 /* Whether to check write accesses only. */
 static bool kasan_flag_write_only = false;
 
+/* Whether to skip free-time tagging. */
+DEFINE_STATIC_KEY_FALSE(kasan_flag_tag_only_on_alloc);
+EXPORT_SYMBOL_GPL(kasan_flag_tag_only_on_alloc);
+
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
 
@@ -154,6 +165,23 @@ static int __init early_kasan_flag_write_only(char *arg)
 }
 early_param("kasan.write_only", early_kasan_flag_write_only);
 
+/* kasan.tag_only_on_alloc=off/on */
+static int __init early_kasan_flag_tag_only_on_alloc(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_tag_only_on_alloc = KASAN_ARG_TAG_ONLY_ON_ALLOC_OFF;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_tag_only_on_alloc = KASAN_ARG_TAG_ONLY_ON_ALLOC_ON;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan.tag_only_on_alloc", early_kasan_flag_tag_only_on_alloc);
+
 static inline const char *kasan_mode_info(void)
 {
 	if (kasan_mode == KASAN_MODE_ASYNC)
@@ -270,14 +298,27 @@ void __init kasan_init_hw_tags(void)
 		break;
 	}
 
+	switch (kasan_arg_tag_only_on_alloc) {
+	case KASAN_ARG_TAG_ONLY_ON_ALLOC_DEFAULT:
+		/* Default is specified by kasan_flag_tag_only_on_alloc. */
+		break;
+	case KASAN_ARG_TAG_ONLY_ON_ALLOC_OFF:
+		static_branch_disable(&kasan_flag_tag_only_on_alloc);
+		break;
+	case KASAN_ARG_TAG_ONLY_ON_ALLOC_ON:
+		static_branch_enable(&kasan_flag_tag_only_on_alloc);
+		break;
+	}
+
 	kasan_init_tags();
 
 	/* KASAN is now initialized, enable it. */
 	kasan_enable();
 
-	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s)\n",
+	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, tag_only_on_alloc=%s, stacktrace=%s, write_only=%s)\n",
 		kasan_mode_info(),
 		str_on_off(kasan_vmalloc_enabled()),
+		str_on_off(kasan_tag_only_on_alloc_enabled()),
 		str_on_off(kasan_stack_collection_enabled()),
 		str_on_off(kasan_flag_write_only));
 }
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a547662..4fa8abb312faa 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -33,6 +33,7 @@ static inline bool kasan_stack_collection_enabled(void)
 #include "../slab.h"
 
 DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
+DECLARE_STATIC_KEY_FALSE(kasan_flag_tag_only_on_alloc);
 
 enum kasan_mode {
 	KASAN_MODE_SYNC,
@@ -52,6 +53,11 @@ static inline bool kasan_vmalloc_enabled(void)
 	return static_branch_likely(&kasan_flag_vmalloc);
 }
 
+static inline bool kasan_tag_only_on_alloc_enabled(void)
+{
+	return static_branch_unlikely(&kasan_flag_tag_only_on_alloc);
+}
+
 static inline bool kasan_async_fault_possible(void)
 {
 	return kasan_mode == KASAN_MODE_ASYNC || kasan_mode == KASAN_MODE_ASYMM;
@@ -145,12 +151,17 @@ static inline bool kasan_requires_meta(void)
 #define KASAN_SLAB_REDZONE	0xFC  /* redzone for slab object */
 #define KASAN_SLAB_FREE		0xFB  /* freed slab object */
 #define KASAN_VMALLOC_INVALID	0xF8  /* inaccessible space in vmap area */
+#elif defined(CONFIG_KASAN_HW_TAGS)
+#define KASAN_PAGE_FREE		0x0E
+#define KASAN_PAGE_REDZONE	0x1E
+#define KASAN_SLAB_REDZONE	0x2E
+#define KASAN_SLAB_FREE		0x3E
 #else
 #define KASAN_PAGE_FREE		KASAN_TAG_INVALID
 #define KASAN_PAGE_REDZONE	KASAN_TAG_INVALID
 #define KASAN_SLAB_REDZONE	KASAN_TAG_INVALID
 #define KASAN_SLAB_FREE		KASAN_TAG_INVALID
-#define KASAN_VMALLOC_INVALID	KASAN_TAG_INVALID /* only used for SW_TAGS */
+#define KASAN_VMALLOC_INVALID	KASAN_TAG_INVALID
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
@@ -478,6 +489,16 @@ static inline u8 kasan_random_tag(void) { return 0; }
 
 static inline void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
+	if (kasan_tag_only_on_alloc_enabled()) {
+		if ((value != KASAN_SLAB_REDZONE) && (value != KASAN_PAGE_REDZONE)) {
+			if (init)
+				memset((void *)kasan_reset_tag(addr), 0, size);
+			return;
+		}
+	}
+
+	value |= 0xF0;
+
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
 	if (WARN_ON(size & KASAN_GRANULE_MASK))
-- 
2.43.0


