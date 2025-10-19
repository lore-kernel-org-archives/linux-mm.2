Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4073CCCD1A7
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057C18E0010; Sun, 19 Oct 2025 02:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC008E0002; Sun, 19 Oct 2025 02:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4618E0010; Sun, 19 Oct 2025 02:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C83F88E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6176DB9879
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:11 +0000 (UTC)
X-FDA: 84013856262.16.DF2A30D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75D94C0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZPY6bCqY;
	spf=pass (imf28.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0wsGtkMDP+lGhx28p+RHXRkJ0fALFx2Ca8PburHIFc=;
	b=i8YZdMvvi456vS23lHORVlMyf6NbkNw94UBPbgGgpeWYePQ14gyqgD3OYnKZpi2jl0lMzu
	J6gZDwrToxbCcjskm+SHOar4+mnIJ6REFMLAaza4C2A8YeSXbUD4wT0pIni9F+DPWVO+hI
	dDk8RoTeatYK1xD36i5cGCfmYhumUi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854629; a=rsa-sha256;
	cv=none;
	b=aH2PJ1S8vTPjJe047NiT21iBzzrdTapd4czuUnM+9+FvGbQu0gSZQLGwC8eTdp3K3wJsvG
	FUAPAWu9mQMlxk25IdEi1dJVDhdcLDIX+byOtvcGLpCkAy4NtLtuuzgxHWHQsU3f9f0qEl
	o/5Hz3zqXuduoFfKxVZAubFZXpJgEXY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZPY6bCqY;
	spf=pass (imf28.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27ee41e0798so52960595ad.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854628; x=1761459428; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0wsGtkMDP+lGhx28p+RHXRkJ0fALFx2Ca8PburHIFc=;
        b=ZPY6bCqYNqSNwR1ATaJNw8uI1ELcpiJj8I18FLmW6M34syzJ4IkkPX0Xc49UNyaTiV
         6sr25pa1QdIHBLL4wubF+K1DdTS4jlCsUsBKHwaGLgkH8YPqVGsE+9Nam36/2H9+7Pts
         U828ydXllpb3VXkchXPzMjii4ZNQOayMTh0LYWMK1QTsjr1wFCngUKEoLpFWpzRyJIY8
         iKTaX2EfsWoRkvlxZR1UgpAT8aPF5aeLDmPliBT9fIshG+uOhg4FqRPER1tSklJM+D7U
         1buvZQsKGrd/lLQ0iyT7RgdRlvVm2cdwPZ8RZ/hPJAKCT0uYrq3FdB08kF3btlJ/n5Es
         poSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854628; x=1761459428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0wsGtkMDP+lGhx28p+RHXRkJ0fALFx2Ca8PburHIFc=;
        b=kT9EmokPesMv/VMKV44gKNgsUOWG6gGTd+qB/KPwc4AJEfykLBDSMH4wKj1zOtR/jm
         bUg6xhC0yAhdK9dQCmDNcoFxt3Kxh1ygIEUqzOmvUzhuI+wWs60Cym6v848n3H1kjVKi
         7Kocb03mNEdm42ZXXCcpVtl0mMe40Pv5XCwW5NrT1nhJX2V7Gl2IgVInakqJgGAKU5x5
         bDRwfcVSH2gJp5WxDN5nUTvu5eBn3U3HYS2hihDkP+qnMXQaaf66Cw/Wz0zpuqAtZBd1
         vGPKT81EkJM2E1opcLb4B9mCwn7d9UMZhrJawy2F08r/HaHuHUDV/ruJKYs0QPRusQA3
         dm5w==
X-Forwarded-Encrypted: i=1; AJvYcCUhddUztyA2Or+yjjmobSQWsdQiF7/eEgsne6kZBnxm6pAo9/M1L6c97hY1hDqrQ9/hqxW5jFMVXA==@kvack.org
X-Gm-Message-State: AOJu0YxNno+2jQWVXG6CoyW/7CRdsOOBbudYbe8TMkHnYto15ZJ83zVn
	B/8BWNMPyedCSDVabgVnJHLcheoUBs0NkkYweBGhuiZLZ+06O5Omximx
X-Gm-Gg: ASbGnctkXAidI+qQPoEUa6WTTtLr4XOch6Ie/C1Xkugu5jlSVNhg/UX0Yyhdsi5xxGA
	uHC7xiMmFWa7l4oELsoCZD17KVOFZpudm1I5vHy6iRGud4rlUOBXnmtBDy2m3jIqmRLVhDVXmqb
	d6Ykd/9c2tNnutLl38NnqprUAZxfi1jN6/L9CFqOK3m5lyz/sOmlnJRwlqYlYs+l8518kmTacZJ
	CuABSUkp5FEHpYxgAFcYapGwsuMHL0rLja9GE5n8LvGn3ziduEghOhEoT84yis1/njLOz5swouE
	MnLcnYk5UTZCKL7jKJIzz7h7dEXdVwaYkjGh18quQe8cd1cpYzRR1Z6d8s2A/0sQ+WXolNKDSmx
	fsqmwn1KuEFjtOhP6yhceIkNN0jHjcsq6++yagV3HoDtoGx98OuQHjGg/Gf9bqVkiuGMaPqqM7X
	BlRV8Y
X-Google-Smtp-Source: AGHT+IGu67uE2s3blbKf/o2fKnuxlQtS3znzk8IIHkaEnUlKNNl2NW2CaX6Hyb7Xbj4GWxwVqCqcDg==
X-Received: by 2002:a17:903:230a:b0:290:c3a6:822c with SMTP id d9443c01a7336-290c9d1b50dmr103427605ad.15.1760854628322;
        Sat, 18 Oct 2025 23:17:08 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:07 -0700 (PDT)
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
Subject: [RFC Patch v2 09/16] kexec: Integrate multikernel instance management with kexec subsystem
Date: Sat, 18 Oct 2025 23:16:23 -0700
Message-Id: <20251019061631.2235405-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: fgsp5xibnkpp5jwphcpca5esfwjixoke
X-Rspam-User: 
X-Rspamd-Queue-Id: 75D94C0002
X-HE-Tag: 1760854629-399312
X-HE-Meta: U2FsdGVkX1+8fhN2qZaX28LyHaJ8H0RO4FD9VBMuCJ6tJ0c7NAsMG3/xfjExsLLUQWN8xhI0GEizJgALHF2w4vX08vkgYf255G3G7MIpX12pLeQQTeXCs6c6inMcEtbono/FEh7HH8BWrnxz5GoirpN6n5rk/wFFWEFvzHv9L8+8YQhHlySOGCPOfYkJD2FNWFu2aM8kUyscTdxfg7F3uBnUJXHU4rlQJZ8JsQV4KHkXwX96lfCXglqbs9IHiLgpbvzvHPalcWmSWLiBIJUyRIUYO6fVuTlZpYeWr5QjE39lbk8gHdfDVMQQf1zXLSA4GypkoZkP/sQlaHow/hI3qCoSaGx4+GVEp/9gVvcj6qpV9xYs4lBKPUrPLCik+hlziX4HNH0Hse5m6FRgg1Gp3i7czyEK9OuXpMPCboVHC9Q0Z/yulb0ng4dp8JU473ucxcLceg5YTM6VAA4psyufLO6zeQNPtlW80MXxxdXRy3ahn7bscwTEM3r6WGO5elxodR7SWhrSYNJLxndqRxitVoy2WPTgVQAGDwtKvq68f6mDq8ZBCBBBSIjoe7DnxMTe/d+ae4u6YzQzAc4rXlrWp/GssdfId46vtdzZAgWrthVIt/IVpMYq94V6thryUg/q231XDN1StIQaF0LyE+S1C6/XeYpITe7/YTxMW5dJvht+7TpzjYrG3GamEBmtiq2C9xUUxseS6tIRmF3Hk9AvGV1U7cZ3GnMFShiU/TjIhbmacn0Nc7Qxuj23cwsCqKRtdIF+PXT1jer/+hKbXF1AqoeOnlV4+OJIOeLATHtnA1p5/02IwVs1nvL6se+GzOjLxeQi7eS+XFN37hcTOztsLYqoA0ID0I8Qg0HLLei1GySp5g3TuxM57DNCszISu1B+evGTqpjR3fCpYf8OYtWxdcLHTjsJHZW9b+NMVaLTINh6pU/7rv09zfi2gGaTQslVZsrLrcU9Q80PkF/odTI
 9XeklGtC
 r+R2kTPxnBrxslZVVT5t4MtPdy3m63gyTXJc67YYUgR09jM84YowZEX6BkM8ZA6MuD7PwHp1RT9r4OXUa2dTjC6eD68N1fp7tTOd/2Yz06SG/8pKjynAvd+mPtjSnVQapxknMX4HvwfHy6JGCHNTsS2Q7/gvIrx1O1W7Lvx52ZEjc7r5wvNH3p5Mty/pBGMHAJjgOTUi9bWc2Vo5GsY+ktBbNj8kKn2SLqY6bOm81nMl3N2tqFWwrF486Uqoa2YKtMdMnXZU5t0YGUgt9QOJ5ov4YcWVNg66SnV2sOIescNlX5zzJSNTwgVnr04Idt1rv2/jNVu9vQxr0yNtfSeuIlryEtbgnA88DPyD5QLWn+FuYRVlRpBq0OG1WH/ij2IwItv6CdFd5PruMd+TQxU7+aEXLgmB/21n/v+f4lhJA8CUqsFRcrzoRKZ92tS98sLIxHCucbvPxoRiVI6vqoCRlNsOaZNSFylvd09I/EFRHzbsvBZvK7gOgKzHwHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Establish bidirectional integration between the kexec subsystem and
multikernel instance management, enabling proper lifecycle tracking
and resource coordination for multikernel operations.

This commit introduces:

* Enhanced kimage structure with multikernel-specific fields including
  mk_id for unique multikernel identification and mk_instance pointer
  for cross-referencing with the multikernel instance management
  system, enabling proper state synchronization.

* UAPI extensions in include/uapi/linux/kexec.h that define multikernel
  ID encoding within kexec flags using KEXEC_MK_ID_MASK and
  KEXEC_MK_ID_SHIFT, providing up to 2047 unique multikernel instances
  with proper bit field management macros.

* Multikernel image lookup infrastructure through kimage_find_by_id()
  that leverages the mk_instance system for efficient image retrieval
  by multikernel ID, replacing CPU-based lookup with proper instance
  management.

* Refactored multikernel_kexec() interface from CPU-based to ID-based
  operation (multikernel_kexec_by_id()) that uses instance CPU
  assignments from device tree configuration rather than manual CPU
  specification, improving safety and consistency.

* Proper resource lifecycle management in kimage_free() that clears
  cross-references, updates instance states, and handles reference
  counting when multikernel images are freed, preventing resource
  leaks and dangling pointers.

* Updated reboot syscall interface that accepts multikernel instance
  IDs instead of CPU numbers in LINUX_REBOOT_CMD_MULTIKERNEL,
  providing a more intuitive and safer user interface.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/kexec.h       | 10 ++++-
 include/linux/multikernel.h |  3 ++
 include/uapi/linux/kexec.h  |  4 ++
 kernel/kexec_core.c         | 75 +++++++++++++++++++++++++++++++++----
 kernel/reboot.c             |  4 +-
 5 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 69877db5360b..5e9e9ad1dfeb 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -132,6 +132,7 @@ struct purgatory_info {
 };
 
 struct kimage;
+struct mk_instance;
 
 typedef int (kexec_probe_t)(const char *kernel_buf, unsigned long kernel_size);
 typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
@@ -434,6 +435,12 @@ struct kimage {
 
 	/* For multikernel support: linked list node */
 	struct list_head list;
+
+	/* Multikernel unique ID (0 = current kernel, >0 = multikernel images) */
+	int mk_id;
+
+	/* Multikernel instance cross-reference */
+	struct mk_instance *mk_instance;
 };
 
 /* kexec interface functions */
@@ -441,7 +448,8 @@ extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern int kernel_kexec(void);
-extern int multikernel_kexec(int cpu);
+extern int multikernel_kexec_by_id(int mk_id);
+extern struct kimage *kimage_find_by_id(int mk_id);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
 
diff --git a/include/linux/multikernel.h b/include/linux/multikernel.h
index 75cbb316d565..c65d39a66b84 100644
--- a/include/linux/multikernel.h
+++ b/include/linux/multikernel.h
@@ -102,6 +102,9 @@ struct mk_instance {
 	void *dtb_data;                 /* Device tree blob data */
 	size_t dtb_size;                /* Size of DTB */
 
+	/* Kexec integration */
+	struct kimage *kimage;          /* Associated kimage object */
+
 	/* Sysfs representation */
 	struct kernfs_node *kn;            /* Kernfs node for this instance */
 
diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 346e0ff4e663..82a562ae6ac1 100644
--- a/include/uapi/linux/kexec.h
+++ b/include/uapi/linux/kexec.h
@@ -15,6 +15,10 @@
 #define KEXEC_UPDATE_ELFCOREHDR	0x00000004
 #define KEXEC_CRASH_HOTPLUG_SUPPORT 0x00000008
 #define KEXEC_MULTIKERNEL	0x00000010
+#define KEXEC_MK_ID_MASK	0x0000ffe0
+#define KEXEC_MK_ID_SHIFT	5
+#define KEXEC_MK_ID(id)		(((id) << KEXEC_MK_ID_SHIFT) & KEXEC_MK_ID_MASK)
+#define KEXEC_GET_MK_ID(flags)	(((flags) & KEXEC_MK_ID_MASK) >> KEXEC_MK_ID_SHIFT)
 #define KEXEC_ARCH_MASK		0xffff0000
 
 /*
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 449096060fe8..ed5c97b4531e 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -40,6 +40,7 @@
 #include <linux/hugetlb.h>
 #include <linux/objtool.h>
 #include <linux/kmsg_dump.h>
+#include <linux/multikernel.h>
 #include <linux/dma-map-ops.h>
 #include <linux/memblock.h>
 
@@ -255,6 +256,12 @@ struct kimage *do_kimage_alloc_init(void)
 	/* Initialize the list node for multikernel support */
 	INIT_LIST_HEAD(&image->list);
 
+	/* Initialize multikernel ID (0 = current kernel, will be assigned later for multikernel) */
+	image->mk_id = 0;
+
+	/* Initialize multikernel instance cross-reference */
+	image->mk_instance = NULL;
+
 #ifdef CONFIG_CRASH_HOTPLUG
 	image->hp_action = KEXEC_CRASH_HP_NONE;
 	image->elfcorehdr_index = -1;
@@ -594,6 +601,16 @@ void kimage_free(struct kimage *image)
 	else if (image == kexec_crash_image)
 		kimage_update_compat_pointers(NULL, KEXEC_TYPE_CRASH);
 
+	/* Remove from IDR if it's a multikernel image */
+	if (image->type == KEXEC_TYPE_MULTIKERNEL && image->mk_instance) {
+		/* Clear cross-reference and update state */
+		image->mk_instance->kimage = NULL;
+		mk_instance_set_state(image->mk_instance, MK_STATE_READY);
+		mk_instance_put(image->mk_instance);
+		image->mk_instance = NULL;
+		pr_info("Freed multikernel ID %d\n", image->mk_id);
+	}
+
 #ifdef CONFIG_CRASH_DUMP
 	if (image->vmcoreinfo_data_copy) {
 		crash_update_vmcoreinfo_safecopy(NULL);
@@ -1393,26 +1410,68 @@ int kernel_kexec(void)
 	return error;
 }
 
-int multikernel_kexec(int cpu)
+/*
+ * Find a multikernel image by ID using mk_instance lookup
+ */
+struct kimage *kimage_find_by_id(int mk_id)
 {
-	int rc;
+	struct mk_instance *instance;
+	struct kimage *image = NULL;
 
-	pr_info("multikernel kexec: cpu %d\n", cpu);
+	if (mk_id <= 0)
+		return NULL;
 
-	if (cpu_online(cpu)) {
-		pr_err("The CPU is currently running with this kernel instance.");
-		return -EBUSY;
+	/* Use mk_instance system to find the associated kimage */
+	instance = mk_instance_find(mk_id);
+	if (instance) {
+		image = instance->kimage;
+		mk_instance_put(instance); /* Release reference from find */
 	}
 
+	return image;
+}
+
+int multikernel_kexec_by_id(int mk_id)
+{
+	struct kimage *mk_image;
+	struct mk_instance *instance;
+	int cpu = -1;
+	int rc;
+
 	if (!kexec_trylock())
 		return -EBUSY;
-	if (!kexec_image) {
+
+	mk_image = kimage_find_by_id(mk_id);
+	if (!mk_image) {
+		pr_err("No multikernel image found with ID %d\n", mk_id);
 		rc = -EINVAL;
 		goto unlock;
 	}
 
+	instance = mk_image->mk_instance;
+	if (instance->cpus_valid && !cpumask_empty(instance->cpus)) {
+		cpu = cpumask_first(instance->cpus);
+		pr_info("multikernel kexec: using assigned CPU %d from instance cpumask %*pbl\n",
+			cpu, cpumask_pr_args(instance->cpus));
+	} else {
+		pr_err("No CPU assignment found for multikernel instance %d - CPU assignment is required\n",
+		       mk_id);
+		rc = -EINVAL;
+		goto unlock;
+	}
+
+	if (cpu_online(cpu)) {
+		pr_err("CPU %d is currently online and cannot be used for multikernel instance %d\n",
+		       cpu, mk_id);
+		rc = -EBUSY;
+		goto unlock;
+	}
+
+	pr_info("Using multikernel image with ID %d (entry point: 0x%lx) on CPU %d\n",
+		mk_image->mk_id, mk_image->start, cpu);
+
 	cpus_read_lock();
-	rc = multikernel_kick_ap(cpu, kexec_image->start);
+	rc = multikernel_kick_ap(cpu, mk_image->start);
 	cpus_read_unlock();
 
 unlock:
diff --git a/kernel/reboot.c b/kernel/reboot.c
index f3ac703c4695..bff6d3603a17 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -718,7 +718,7 @@ EXPORT_SYMBOL_GPL(kernel_power_off);
 DEFINE_MUTEX(system_transition_mutex);
 
 struct multikernel_boot_args {
-	int cpu;
+	int mk_id;
 };
 
 /*
@@ -807,7 +807,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	case LINUX_REBOOT_CMD_MULTIKERNEL:
 		if (copy_from_user(&boot_args, arg, sizeof(boot_args)))
 			return -EFAULT;
-		ret = multikernel_kexec(boot_args.cpu);
+		ret = multikernel_kexec_by_id(boot_args.mk_id);
 		break;
 #endif
 
-- 
2.34.1


