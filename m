Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B64CCD1AB
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3218E0013; Sun, 19 Oct 2025 02:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4E08E0002; Sun, 19 Oct 2025 02:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844528E0013; Sun, 19 Oct 2025 02:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 732A98E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3723147F44
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:18 +0000 (UTC)
X-FDA: 84013856556.27.92273C5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4E87A1C000A
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gq+3kwtB;
	spf=pass (imf20.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIzBYAq5cauMEng/8nrVC1spI8sxNqVcm1FTDbL64Gs=;
	b=L9KgQ/VS7njqj9oAjBzqciFQSEKpN2rtXCtuW7XzlvcEJ1KcPEslw9PvtDgPrcxhJ8XPK0
	QhK9KnLSv1Iy/jMnJ484NGEObci7YUh8MpUcH4LXmfDKpPR3xQOCNEfIDPDdGNJ5hOJZLl
	RvNOnR9NZSfjIlIiaeAMl5QcWOGeO0M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gq+3kwtB;
	spf=pass (imf20.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854636; a=rsa-sha256;
	cv=none;
	b=zzjScRe/lP4svc1oYmvQQMB8yZsPMuDZEMMso744bQV1+SbsMRoAn5SzI/IzmeGDSzuaq+
	GIBhVLSLyuK24C6rLc7cnXimZgEde917iy9hoQ5sXOJbFsDdMZwXsH+AQAY566II4OvWXG
	Socf+3CqRGY4xGvY2iljBD1Y0QNZqGw=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7835321bc98so2925145b3a.2
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854635; x=1761459435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIzBYAq5cauMEng/8nrVC1spI8sxNqVcm1FTDbL64Gs=;
        b=gq+3kwtBuTHuHYVg4mbY52IImSny9cwpWMx2Gze+b+CLcHK7mA4C3VLUT/EMksFege
         pg5f5e/mHYoj7h8oZL8mmHMvhNqWCmAmadEM5a74c6DMMQU33u5kAEPk00QWIXUbQcyu
         7eXEVabCw/hN6whhG/jeR3wOP9hkP3UCRaPNh7Q+rOinBRK/F2rEQtnjNGCqUzkDN8NQ
         vE+/3s0D+Yk0fyP1E0g7y36N+0blgCxW6cfwUR96zli7dB1lrOSj2lg+C5Wbebw6qJ3Q
         7bcCzPWfp80AxkOGDd5CdmjwVbgCFAkFEdm62wE9CxzQCV40gzoj9AzENK/Mk9KYRGGK
         RPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854635; x=1761459435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SIzBYAq5cauMEng/8nrVC1spI8sxNqVcm1FTDbL64Gs=;
        b=R9Spkm3Ol5xx3tjmcczZMVVuWQuhXSJF1wQOV6mrM1PjcVWhojPLZvfBAdN0wpgL8q
         6Q0pOxhWQv+8DqEfVy7U9l5/L6nJCYXwPvCMbuGZu6WgIOO+ZINCGmpHXU3zEy/69szS
         OwHiLKz1B23WW7s/cq6dR3Z4wDJL+F4I77BhI3taxcimkBPhBo4mBlTWAdOB2d1Wm6Q/
         IK6qa9EPBx94AHowZaBtDaVQKF3j5/SA9+XTnvBtynmUSBsBxjrG2mDTwJgyKv8Epuvs
         Zy1YSpu4BRwlJHUg6YWnAoFcx7tKgJZymMOa+DkCWD5I0YMoAHURGPxhg3j2R1t7ETod
         QfOw==
X-Forwarded-Encrypted: i=1; AJvYcCXiIwgYr/4TIuM+WJNDTTsOc8Ndok+wpDQizTW3X4PDiliiZBtKGFG9/OfK6BqxC/yhR3U/TiICkw==@kvack.org
X-Gm-Message-State: AOJu0YzdHdmqKos1HlwsYPl7Ok5nsMfiIPsfA4NKvJkz0iYkVn9iREPy
	N94aQZlbvFW30Jb/+lJalmi7Kl3AdBMMYuMDqZeb4eISVpw/rlXVbZ9d
X-Gm-Gg: ASbGncsDCSdZ5Lbw9H/axl+NabouO0eOoGySTSnk9qcTB3XwvFWgtG6Niy6sHfyCgJA
	CJPjpl5X/R/QbCcN60WYA7eL+AisKMEaEjltkh6YW+VIDXD8wSaSQsUq8ZIQXOLWQaUk+NUvtcL
	5lwFTid/T5SK5SW2cFNE6f4EsWJ8QlKfqnlFjWs6UdNn/YSIE28Q5R8LFxr0fj68kRUccjkuNOZ
	F/U+RocfEAWdWfWB6VL+7wwE4pwwuo/awy+TbI/KQQxdQOx7E6VVsp5nTyzfiGgBcBBVYyW5PZG
	SgCyiFQlsXgFqnuDqDs21OD+F8Kw6+lv+nOLP+7WwiRNApKKUPM3S36WWlrhAm64eIljk+iR4y+
	MhMq6FL6cVDq7bduYDA2JYDPs6X3zlYOgmIkMbUD2L4mo7Ozo2oxknAFHelmLvVUOUPWylFNPyf
	+h2jUf
X-Google-Smtp-Source: AGHT+IHfF4hU8/QtsMDLLQvEjqsCa8w0BBb+2CNnqIZAGSLrLtnMeBv6KtywAED8Fp+17ZtBPczCAA==
X-Received: by 2002:a05:6a20:7355:b0:32d:b925:4a8 with SMTP id adf61e73a8af0-334a851519cmr11699864637.3.1760854635123;
        Sat, 18 Oct 2025 23:17:15 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:14 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 12/16] multikernel: Introduce per-instance memory allocation interface
Date: Sat, 18 Oct 2025 23:16:26 -0700
Message-Id: <20251019061631.2235405-13-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bh6q36se78fzf4ykuyzy9mchi1ygsia6
X-Rspamd-Queue-Id: 4E87A1C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760854636-617821
X-HE-Meta: U2FsdGVkX19+KlJW91pVF1d4r5daghIFCfDk783noHSt2MCgOW2uWXoVFCUS5tnLfwn4LTjryaKcyC4NiLOAztLndgGSkEf10iebvpjEkmaSk3Mg0mN1II+yZsaz3ECKfNnkOjQ2/wTXtPsc0x60K+ZZ6A91nUrBolWuvnDLqhRwlN7/ug0v2pYhL/umSkEwOunDBto+Z/nREXLDfEJQ4JzPmIuKslohh/YvYJLwgIwpO2CKwatVFYdghqvmP/ejzOr33ha9KndlRtSyh//jJ+BRR72LtAVMIXlu3d7pNBtZv7vvQ6woq3fnlebhuqLDYQmWJOARNy7zFuPwYUugiFcg/PmCRMzxmD0xK7cNe/xDXAnF7fFzbhBK0Gumog2Q0MUveCpZ15aBIRUI5HPdh/yD4jYTCn3/SPV41PCMO5sZ2jyWw3h8DtKKlYGpoPA7qdlV8QQhyvXbrm9+lwBLpNoYj2SjOmyIT3DmV074aFga+kL1opoIQDdcrV3ONGihpDqlTwedsxwvbmmMFejrnKAmVz9XZ8OpSRho3ShCWo5C2FSRH4t7kxEx3IqsWGmZUsUnJnoFIolLFGNf8I0ibC+XniDIE5KtIoqBV6mSqu+zaok+2SjTifPO/Xp2YD2/+GC/X4X4njQ8pzmBLEJJUlO/1ywcWJQT8uRjM8mJZm1tF2UHX231TzhvVNdQJXzuzJqwWDOJvYE1rP5xX5mCu8RrzhwRDQ1vl5o5ZpzWe/pJ/YwOIE/0u8t3+TNlZcPs36RlYPJmp/sEj6/3eL7BaBvZlfjElbQ3bfoDOBIldHUICKNT+rS4IKzovVX7U7iBuW+/QMMWTjOBg0x+FFLlODMg5RKdvwvkegeXXsGWbvlrzdEAIeQepyD9ebybBkaG891g4Y33lprjS5Oibay3B+K/a4PKNtdf4iDG41UXrj6Jpv0GIpArafTS7fWUOiTSm1iPsbySFBXsnr2uYDo
 Eyr+lWyu
 O3t2wfSQrbiX+ZeF6O4n3jgvYmKXhjewByIAnypQGlBZ5dVJCVg0ECmssCLLBpurnyeP5t0ltMNWeGy9hy9sJ91dpJrUkwAtkeOf6jGOL9hiXwGp/ytTV97gBuyROtRDn0alOV/9WWvQB83yHx18STfziWa4es8zEWIGmNCy3f5HasHq+7TTi/Xzw6c2DkZhrKqERALj6xopVXDIRskTLrwQ3atsNZJr/0YKTqj9n667YgrPjZpo4rWj5vNse8F8MOL6yQHACdR3bBUVJtTHdEPqSCUVMbw2oxMQtPOaK1W2qqvg8IGbj7P0E51Sbkm1UtrFWOT56SLkIPJPtW2xC9Hsf1KyGlQg2zh7rASvSYMEc0BXx9rhoNFSREFOdllAr0jrm6kzx3w9l/4QVPsfgJiGkzJ/LBbkWy8dTlxYnvE0wCW1OSRPpp7OQ/30fXM6SGtaTpIf5tlI7hYg1GSeHR+qEVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add virtual memory allocation interface for multikernel instances,
providing convenient high-level functions for memory management within
instance-specific memory pools with automatic virtual address mapping.

This commit introduces:

* Instance-based memory allocation functions (mk_instance_alloc() and
  mk_instance_free()) that provide virtual memory allocation from
  instance-specific memory pools with configurable alignment support
  and automatic physical-to-virtual address mapping using memremap().

* Kimage-based memory allocation wrappers (mk_kimage_alloc() and
  mk_kimage_free()) that provide convenient access to instance memory
  pools through kimage structures, commonly used in kexec code paths
  for multikernel operations.

* Automatic memory mapping infrastructure that uses memremap() with
  MEMREMAP_WB caching policy to provide write-back cached virtual
  addresses for allocated physical memory from instance pools.

* Proper error handling and cleanup with automatic rollback of
  physical allocations when virtual mapping fails, preventing memory
  leaks in error conditions.

The allocation functions complement the existing physical memory pool
management by providing a higher-level interface suitable for kernel
code that requires virtual addresses, such as buffer management, data
structure allocation, and inter-kernel communication buffers.

This interface enables multikernel subsystems to allocate kernel images,
initramfs etc., maintaining proper resource isolation between multikernel
instances.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/multikernel.h |  6 +++
 kernel/multikernel/core.c   | 98 +++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/linux/multikernel.h b/include/linux/multikernel.h
index c65d39a66b84..79611923649e 100644
--- a/include/linux/multikernel.h
+++ b/include/linux/multikernel.h
@@ -280,6 +280,12 @@ int mk_instance_reserve_resources(struct mk_instance *instance,
  */
 void mk_instance_free_memory(struct mk_instance *instance);
 
+void *mk_instance_alloc(struct mk_instance *instance, size_t size, size_t align);
+void mk_instance_free(struct mk_instance *instance, void *virt_addr, size_t size);
+
+void *mk_kimage_alloc(struct kimage *image, size_t size, size_t align);
+void mk_kimage_free(struct kimage *image, void *virt_addr, size_t size);
+
 /**
  * String conversion helpers
  */
diff --git a/kernel/multikernel/core.c b/kernel/multikernel/core.c
index 52bf8e38206a..ee7a21327ea5 100644
--- a/kernel/multikernel/core.c
+++ b/kernel/multikernel/core.c
@@ -7,7 +7,10 @@
 #include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
+#include <linux/io.h>
+#include <linux/kexec.h>
 #include <linux/multikernel.h>
+#include <asm/page.h>
 #include "internal.h"
 
 /**
@@ -403,6 +406,101 @@ int mk_instance_reserve_resources(struct mk_instance *instance,
 	return 0;
 }
 
+/**
+ * Per-instance memory pool management
+ */
+
+/**
+ * mk_instance_alloc() - Allocate memory from instance pool
+ * @instance: Instance to allocate from
+ * @size: Size to allocate
+ * @align: Alignment requirement (must be power of 2)
+ *
+ * Returns virtual address of allocated memory, or NULL on failure.
+ */
+void *mk_instance_alloc(struct mk_instance *instance, size_t size, size_t align)
+{
+	phys_addr_t phys_addr;
+	void *virt_addr;
+
+	if (!instance || !instance->instance_pool) {
+		pr_debug("mk_instance_alloc: instance %p has no pool\n", instance);
+		return NULL;
+	}
+
+	/* Allocate from instance pool with alignment */
+	phys_addr = multikernel_instance_alloc(instance->instance_pool, size, align);
+	if (!phys_addr) {
+		pr_debug("Failed to allocate %zu bytes from instance pool (align=0x%zx)\n", size, align);
+		return NULL;
+	}
+
+	/* Map to virtual address space */
+	virt_addr = memremap(phys_addr, size, MEMREMAP_WB);
+	if (!virt_addr) {
+		pr_err("Failed to map instance memory at 0x%llx\n", (unsigned long long)phys_addr);
+		multikernel_instance_free(instance->instance_pool, phys_addr, size);
+		return NULL;
+	}
+
+	return virt_addr;
+}
+
+/**
+ * mk_instance_free() - Free memory back to instance pool
+ * @instance: Instance to free to
+ * @virt_addr: Virtual address to free
+ * @size: Size to free
+ */
+void mk_instance_free(struct mk_instance *instance, void *virt_addr, size_t size)
+{
+	phys_addr_t phys_addr;
+
+	if (!instance || !instance->instance_pool || !virt_addr)
+		return;
+
+	phys_addr = virt_to_phys(virt_addr);
+	memunmap(virt_addr);
+	multikernel_instance_free(instance->instance_pool, phys_addr, size);
+}
+
+/**
+ * Kimage-based memory pool access functions
+ *
+ * These provide convenient wrappers for accessing instance memory pools
+ * through the kimage structure, commonly used in kexec code paths.
+ */
+
+/**
+ * mk_kimage_alloc() - Allocate memory from kimage's instance pool
+ * @image: kimage with associated mk_instance
+ * @size: Size to allocate
+ * @align: Alignment requirement (must be power of 2)
+ *
+ * Returns virtual address of allocated memory, or NULL on failure.
+ */
+void *mk_kimage_alloc(struct kimage *image, size_t size, size_t align)
+{
+	if (!image || !image->mk_instance)
+		return NULL;
+
+	return mk_instance_alloc(image->mk_instance, size, align);
+}
+
+/**
+ * mk_kimage_free() - Free memory back to kimage's instance pool
+ * @image: kimage with associated mk_instance
+ * @virt_addr: Virtual address to free
+ * @size: Size to free
+ */
+void mk_kimage_free(struct kimage *image, void *virt_addr, size_t size)
+{
+	if (!image || !image->mk_instance)
+		return;
+
+	mk_instance_free(image->mk_instance, virt_addr, size);
+}
+
 static int __init multikernel_init(void)
 {
 	int ret;
-- 
2.34.1


