Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0141ECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6186B00BF; Fri, 12 Sep 2025 11:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE216B00C1; Fri, 12 Sep 2025 11:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCDA6B00C2; Fri, 12 Sep 2025 11:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3991A6B00BF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:11:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF53B5B967
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:10 +0000 (UTC)
X-FDA: 83880936300.22.9F17CEA
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD6B5100014
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=bPCtJIrw;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf14.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.181 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689868; a=rsa-sha256;
	cv=none;
	b=4pZIrYCgcT5qBKqq5HrpI9qM1mBSXkWIsOdAYYGUGjMXrrFw0ngbf7OnOSpmFLiuLNNGHN
	hTNIoMnuzCNBtaZA2oIgzoOzqz7efU6O1hz1ovmbkRz4HhsMo40gn8oKQQCnaZxZ566O3Y
	fO2mDja6F7WJcyT+K8fbex1P3vIu+js=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=bPCtJIrw;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf14.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.181 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgoQ+woT/93cBsRw8kKeoK5/i5b3BJOE5ioHeOB3mNE=;
	b=Gx5Y+8uJbv0Tldtmx2kiRXuK1wpoy4RULI17ElnJbTfkX2qRdPUsb0t5XjmSLabo5eHZt8
	8+KVkJobsN1iE8GuVIB9Ay7R9RnWxfPuYx6rvv3b7GSDBJENSNPHpWepxMenWe/e9Zw6ma
	YIGJXg/Ww8Xx5ueUOcOvSK8l2IyT2nM=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-72e565bf2feso14087587b3.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689868; x=1758294668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgoQ+woT/93cBsRw8kKeoK5/i5b3BJOE5ioHeOB3mNE=;
        b=bPCtJIrw6YsnSq4Dx8KNpfnY1Cp6UabbZ61vPsmxh1ZNeXMH1/txTTEjUJvFtzZcKO
         0kVsRDkXvnPH/+qFBduYZS0PC2SLk5dfhxE8BifsmBVe9lBW8kn8QyyyZfZNnjD79JWa
         m5WrRiwVm3QXIOARJmBwdyDoWLi6b0F9MxYyCK7gObK/C9CmVglBHeTV5XjB4YcslpI6
         Nq1+QBlI615vJwRPF8/C1fFfI7/EiLixGjrjZ0WXSRAZHxsq5azehFQnw7M6HaV2+0Uz
         x8iORnYfzymJ9jsn8B8SSg9nFsg3yjFX4ecl9T9/nyhcf9seSj40ewJYLXhDLfwrrjGE
         EoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689868; x=1758294668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TgoQ+woT/93cBsRw8kKeoK5/i5b3BJOE5ioHeOB3mNE=;
        b=tT76dgZiRh8r0mn+6wfMmC1VztiEQNVRNds/TQI1xNjxMaOUc+hOYIj7bOr5tUQILH
         TbstvufvOpezBeiQ9HIOc+0PVacvEecXYBqGLlaCwUsw3amZhQR4oOB3jiE4Yua8j1a1
         FvzXTSCGtwHX8OY/oFmeY8U0JYqLdcR7Zy3rnocjY+5vYVTXl5qI1ULAMpw8xi/vUPKy
         zBTZ89wrO3m7YerDxdiA/ZbMXFI+28+DlIQv5vVQKfWQTL/ALtSa2omgOd1SscrM1Tlq
         k9ckG+vNCZOqZf5X6UH3xSeJEifPnIdmeq1u8qi04lQ1CPvpTauw6CDyh0tQdY07+kS0
         i16A==
X-Forwarded-Encrypted: i=1; AJvYcCXyGnVGpiXVr2zTD/2MtQ/cXLYc1G4/baONSsc0eBHA3wNlJAruMI226bHrjL/Np0SxTOfw3+Jurg==@kvack.org
X-Gm-Message-State: AOJu0YxmLwKMnaF4hzWA/LzqKHxgmHgcthZPHq4JQB2L0pGUj+XH5HMG
	uit+290JUH4sgL+t12MmauM/+Kj57DMvaCGzP6Iv9wuKpHes88C2ii0OTtn6WdwaKv8=
X-Gm-Gg: ASbGncsWgkgzF//xFFcteGpP2CjrqA5HUXgBlQHDssNDxiH0qtT2AvMEnYdtE4ejKyX
	2HIefbJwZTEqIVTFq3xyk5zAR2NxdtGXAmBflhIpAGywiP9X18K7E2+dUUhgUKnTbdZsr/A4DoX
	zQga3Hub+ZQhVHFWKgoLOA4xRM/Rr5pmToPJQ1kVN9FrVFy34AZoMtgBa4gJWgDsUbks1PF1M0x
	WS41mIf6DxQs+xOVT9pw3iWY76akBprjobmartLBR6MlluKe1Cb4hcZJfjApHyqcY46pcor+eNt
	h2AdxouPS0BHlaH+C90TXa3I+5BMt3m/Lu+bhgBtNDii4Lh26z2lJuXlRPSg+nzK6fPrjJv+mHz
	fOD1nHH2Zov+NLquqsS20h9mipkLrhHti9Q==
X-Google-Smtp-Source: AGHT+IGUcGV4IM3PVToM3wIMhJFlncT19Inxpe70tej0adAKBemPa7cOoqolhGXuc6qPV6B9GeZ9vg==
X-Received: by 2002:a05:690c:f92:b0:70e:2d17:84b5 with SMTP id 00721157ae682-7305f99fd82mr33784177b3.0.1757689867582;
        Fri, 12 Sep 2025 08:11:07 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:11:07 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 15/16] kmemdump: Add Kinfo backend driver
Date: Fri, 12 Sep 2025 18:08:54 +0300
Message-ID: <20250912150855.2901211-16-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD6B5100014
X-Stat-Signature: yuz9cnbfkw57mwoktwdy1jwytkfn45rj
X-Rspam-User: 
X-HE-Tag: 1757689868-203221
X-HE-Meta: U2FsdGVkX18hzkwBiM9zivgKYK0aTrfFOVQdWRD8b5hbOiyEDShkZlURpqxXSmhiRRwbhREyXjch+sNk+V2yx5oEnQfHZn44YnRPy4ZOnQbsNPWVFP6mESJkdP4D2lfm6wBTqa9Inu7+b5oZpIT7qo+Fk1OP0w3h88MdI4pn7pYxE1924hwgak71TEfdgZECPyvoRJyy11MIHCps8opr5kuPxKha2IUGn1iu+FBJYuLe9PMh3MVhFQnlW/g1KhFiuR5iQ6l1f3bdOx+HWHEfOjiMqOTyHk2QJ9S/dTwEApUzjvfC8i3Wg5UAksQGLzkXwOPPHdhw4yX06TrDUEWUCZ5THZlTAfZ2faQoadVdhInLJWtuxHXfIqhetYcsTzph903rY/yfzLm6LWHp5gOQOqNgjqsWSSmyQC8PrPgzk5YUfaA8lkC/6ie5nimGoTYlm7pcFkJxnTCvUAt0Qil/wAqpwV1NK9i3ha0Vlbe2W0eeVp8tGAHXsOIlodJxcyN1tRNl3mbZGjWr7uHf6k08Zv1rHqFCBt7tW2e1e/u2vnyMOq+A7ruz59vBKh6PLSFXYFahA37EsQ3dIjMToknhPaEPfXfylZcovbGqYRIbX6/DglHI5rB3MWGy2Rq59KbxXK1MxQ1pgwhuy6TkXRonbeSLb2GIJVNYA5oLExtb4Uk1qng8qLr3rzPGXu8jHlKxwhzIhg4AcCPF8zpvXgS1iySFzapOIHHw+RZCbuXbYGVktvqPGy1RWbC3cLlUBRzW5ULiJokvlornNmbWw0FViinCtXiJ9Uzy44o2LKynjVYkOa/YA3FexnPnSLL45i+r6AK5bpToDeW6H2y7+wq9DU3sTRUyDi6t6s/WcQmwwnTJkPoRAv735K/gXoMOhJX2AxocufOjFF8voYR2zbwmgtVAOXf8oTnqLhFHxPfK5RFsYjxfsKLi4cuKWHXLyaXQBGEqFZeQKqJoMzURBng
 4ROJlRIz
 yaVFhMb3un35PC8/6/a5wPL2iU/ySJiEPzbWmxenzrFDF2Nyc9TcmXVqBB+aed+xRwZrD3CmBfgvv7UdMgTHk9mdgMIgjlZlSi+FhohdjvBLitxJxoUY03MVhxDBrQZ24bDKxMi5Ti6TZoSO6M6cCQMWTxF4i1CTR9n64mfrM0o8O5z80n9hY7VvgIJHfGnh39Jr3seRnYxbLLMPs3Zlczj5JD5z8jNSS6YXRwFpzooaLGm++pYQqG8x6/NhnBvyIIaZ4XArl0JtV0rP3oBKjxiRwbF7MEUbauqSa/8cejzxqNCS4aoP5JnacbsBh24vUg4BUrDWxKig0IwmROP+kUMzwaDbOEGDLckmSUw3dtwngdYkuOVWQKsVDasgIFZCjsQtKFBsCjPuVwadTlttofoUStX9wMm8EAdqYCx9+zr2D+1/46XLbRV9hp0wCf3E2Q+Av
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Kinfo backend driver.
This backend driver will select only regions of interest for the firmware,
and it copy those into a shared memory area that is supplied via OF.
The firmware is only interested in addresses for some symbols.
The list format is kinfo-compatible, with devices like Google Pixel phone.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS               |   5 +
 mm/kmemdump/Kconfig.debug |  13 ++
 mm/kmemdump/Makefile      |   1 +
 mm/kmemdump/kinfo.c       | 293 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 312 insertions(+)
 create mode 100644 mm/kmemdump/kinfo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8234acb24cbc..65d9e5db46a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13818,6 +13818,11 @@ F:	include/linux/kmemdump.h
 F:	mm/kmemdump/kmemdump.c
 F:	mm/kmemdump/kmemdump_coreimage.c
 
+KMEMDUMP KINFO BACKEND DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	mm/kmemdump/kinfo.c
+
 KMEMDUMP QCOM MINIDUMP BACKEND DRIVER
 M:	Eugen Hristev <eugen.hristev@linaro.org>
 S:	Maintained
diff --git a/mm/kmemdump/Kconfig.debug b/mm/kmemdump/Kconfig.debug
index 91cec45bc3ca..ff88bf8017ae 100644
--- a/mm/kmemdump/Kconfig.debug
+++ b/mm/kmemdump/Kconfig.debug
@@ -38,3 +38,16 @@ config KMEMDUMP_QCOM_MINIDUMP_BACKEND
 	  into the minidump table of contents. Further on, the firmware
 	  will be able to read the table of contents and extract the
 	  memory regions on case-by-case basis.
+
+config KMEMDUMP_KINFO_BACKEND
+	tristate "Shared memory KInfo compatible backend"
+	depends on KMEMDUMP
+	select VMCORE_INFO
+	help
+	  Say y here to enable the Shared memory KInfo compatible backend
+	  driver.
+	  With this backend, the registered regions are copied to a shared
+	  memory zone at register time.
+	  The shared memory zone is supplied via OF.
+	  This backend will select only regions that are of interest,
+	  and keep only addresses. The format of the list is Kinfo compatible.
diff --git a/mm/kmemdump/Makefile b/mm/kmemdump/Makefile
index 6ec3871203ef..1ec94ee6c008 100644
--- a/mm/kmemdump/Makefile
+++ b/mm/kmemdump/Makefile
@@ -3,3 +3,4 @@
 obj-y += kmemdump.o
 obj-$(CONFIG_KMEMDUMP_COREIMAGE) += kmemdump_coreimage.o
 obj-$(CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND) += qcom_minidump.o
+obj-$(CONFIG_KMEMDUMP_KINFO_BACKEND) += kinfo.o
diff --git a/mm/kmemdump/kinfo.c b/mm/kmemdump/kinfo.c
new file mode 100644
index 000000000000..9f0ec8a1aaa2
--- /dev/null
+++ b/mm/kmemdump/kinfo.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * Copyright 2021 Google LLC
+ * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
+ */
+#include <linux/platform_device.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/kmemdump.h>
+#include <linux/module.h>
+#include <linux/utsname.h>
+
+#define BUILD_INFO_LEN		256
+#define DEBUG_KINFO_MAGIC	0xCCEEDDFF
+
+/*
+ * Header structure must be byte-packed, since the table is provided to
+ * bootloader.
+ */
+struct kernel_info {
+	/* For kallsyms */
+	__u8 enabled_all;
+	__u8 enabled_base_relative;
+	__u8 enabled_absolute_percpu;
+	__u8 enabled_cfi_clang;
+	__u32 num_syms;
+	__u16 name_len;
+	__u16 bit_per_long;
+	__u16 module_name_len;
+	__u16 symbol_len;
+	__u64 _relative_pa;
+	__u64 _text_pa;
+	__u64 _stext_pa;
+	__u64 _etext_pa;
+	__u64 _sinittext_pa;
+	__u64 _einittext_pa;
+	__u64 _end_pa;
+	__u64 _offsets_pa;
+	__u64 _names_pa;
+	__u64 _token_table_pa;
+	__u64 _token_index_pa;
+	__u64 _markers_pa;
+	__u64 _seqs_of_names_pa;
+
+	/* For frame pointer */
+	__u32 thread_size;
+
+	/* For virt_to_phys */
+	__u64 swapper_pg_dir_pa;
+
+	/* For linux banner */
+	__u8 last_uts_release[__NEW_UTS_LEN];
+
+	/* Info of running build */
+	__u8 build_info[BUILD_INFO_LEN];
+
+	/* For module kallsyms */
+	__u32 enabled_modules_tree_lookup;
+	__u32 mod_mem_offset;
+	__u32 mod_kallsyms_offset;
+} __packed;
+
+struct kernel_all_info {
+	__u32 magic_number;
+	__u32 combined_checksum;
+	struct kernel_info info;
+} __packed;
+
+struct debug_kinfo {
+	struct device *dev;
+	void *all_info_addr;
+	u32 all_info_size;
+	struct kmemdump_backend kinfo_be;
+};
+
+static struct debug_kinfo *kinfo;
+
+#define be_to_kinfo(be) container_of(be, struct debug_kinfo, kinfo_be)
+
+static void update_kernel_all_info(struct kernel_all_info *all_info)
+{
+	int index;
+	struct kernel_info *info;
+	u32 *checksum_info;
+
+	all_info->magic_number = DEBUG_KINFO_MAGIC;
+	all_info->combined_checksum = 0;
+
+	info = &all_info->info;
+	checksum_info = (u32 *)info;
+	for (index = 0; index < sizeof(*info) / sizeof(u32); index++)
+		all_info->combined_checksum ^= checksum_info[index];
+}
+
+static int build_info_set(const char *str, const struct kernel_param *kp)
+{
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	size_t build_info_size;
+
+	if (kinfo->all_info_addr == 0 || kinfo->all_info_size == 0)
+		return -ENAVAIL;
+
+	all_info = (struct kernel_all_info *)kinfo->all_info_addr;
+	build_info_size = sizeof(all_info->info.build_info);
+
+	memcpy(&all_info->info.build_info, str, min(build_info_size - 1,
+						    strlen(str)));
+	update_kernel_all_info(all_info);
+
+	if (strlen(str) > build_info_size) {
+		pr_warn("%s: Build info buffer (len: %zd) can't hold entire string '%s'\n",
+			__func__, build_info_size, str);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static const struct kernel_param_ops build_info_op = {
+	.set = build_info_set,
+};
+
+module_param_cb(build_info, &build_info_op, NULL, 0200);
+MODULE_PARM_DESC(build_info, "Write build info to field 'build_info' of debug kinfo.");
+
+static int register_kinfo_region(const struct kmemdump_backend *be,
+				 enum kmemdump_uid id, void *vaddr, size_t size)
+{
+	struct debug_kinfo *kinfo = be_to_kinfo(be);
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	struct kernel_info *info = &all_info->info;
+	struct uts_namespace *uts;
+
+	switch (id) {
+	case KMEMDUMP_ID_COREIMAGE__sinittext:
+		info->_sinittext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__einittext:
+		info->_einittext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__end:
+		info->_end_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__text:
+		info->_text_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__stext:
+		info->_stext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE__etext:
+		info->_etext_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_num_syms:
+		info->num_syms = *(__u32 *)vaddr;
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_relative_base:
+		info->_relative_pa = (u64)__pa(*(u64 *)vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_offsets:
+		info->_offsets_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_names:
+		info->_names_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_token_table:
+		info->_token_table_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_token_index:
+		info->_token_index_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_markers:
+		info->_markers_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_kallsyms_seqs_of_names:
+		info->_seqs_of_names_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_swapper_pg_dir:
+		info->swapper_pg_dir_pa = (u64)__pa(vaddr);
+		break;
+	case KMEMDUMP_ID_COREIMAGE_init_uts_ns:
+		uts = vaddr;
+		strscpy(info->last_uts_release, uts->name.release, __NEW_UTS_LEN);
+		break;
+	default:
+		break;
+	};
+
+	update_kernel_all_info(all_info);
+	return 0;
+}
+
+static int unregister_kinfo_region(const struct kmemdump_backend *be,
+				   enum kmemdump_uid id)
+{
+	return 0;
+}
+
+static int debug_kinfo_probe(struct platform_device *pdev)
+{
+	struct device_node *mem_region;
+	struct reserved_mem *rmem;
+	struct kernel_info *info;
+	struct kernel_all_info *all_info;
+
+	mem_region = of_parse_phandle(pdev->dev.of_node, "memory-region", 0);
+	if (!mem_region) {
+		dev_warn(&pdev->dev, "no such memory-region\n");
+		return -ENODEV;
+	}
+
+	rmem = of_reserved_mem_lookup(mem_region);
+	if (!rmem) {
+		dev_warn(&pdev->dev, "no such reserved mem of node name %s\n",
+			 pdev->dev.of_node->name);
+		return -ENODEV;
+	}
+
+	/* Need to wait for reserved memory to be mapped */
+	if (!rmem->priv)
+		return -EPROBE_DEFER;
+
+	if (!rmem->base || !rmem->size) {
+		dev_warn(&pdev->dev, "unexpected reserved memory\n");
+		return -EINVAL;
+	}
+
+	if (rmem->size < sizeof(struct kernel_all_info)) {
+		dev_warn(&pdev->dev, "unexpected reserved memory size\n");
+		return -EINVAL;
+	}
+
+	kinfo = kzalloc(sizeof(*kinfo), GFP_KERNEL);
+	if (!kinfo)
+		return -ENOMEM;
+
+	kinfo->dev = &pdev->dev;
+
+	strscpy(kinfo->kinfo_be.name, "debug_kinfo");
+	kinfo->kinfo_be.register_region = register_kinfo_region;
+	kinfo->kinfo_be.unregister_region = unregister_kinfo_region;
+	kinfo->all_info_addr = rmem->priv;
+	kinfo->all_info_size = rmem->size;
+
+	all_info = kinfo->all_info_addr;
+
+	memset(all_info, 0, sizeof(struct kernel_all_info));
+	info = &all_info->info;
+	info->enabled_all = IS_ENABLED(CONFIG_KALLSYMS_ALL);
+	info->enabled_absolute_percpu = IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU);
+	info->enabled_base_relative = IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE);
+	info->enabled_cfi_clang = IS_ENABLED(CONFIG_CFI_CLANG);
+	info->name_len = KSYM_NAME_LEN;
+	info->bit_per_long = BITS_PER_LONG;
+	info->module_name_len = MODULE_NAME_LEN;
+	info->symbol_len = KSYM_SYMBOL_LEN;
+	info->thread_size = THREAD_SIZE;
+	info->enabled_modules_tree_lookup = IS_ENABLED(CONFIG_MODULES_TREE_LOOKUP);
+	info->mod_mem_offset = offsetof(struct module, mem);
+	info->mod_kallsyms_offset = offsetof(struct module, kallsyms);
+
+	return kmemdump_register_backend(&kinfo->kinfo_be);
+}
+
+static void debug_kinfo_remove(struct platform_device *pdev)
+{
+	kfree(kinfo);
+	kmemdump_unregister_backend(&kinfo->kinfo_be);
+}
+
+static const struct of_device_id debug_kinfo_of_match[] = {
+	{ .compatible	= "google,debug-kinfo" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, debug_kinfo_of_match);
+
+static struct platform_driver debug_kinfo_driver = {
+	.probe = debug_kinfo_probe,
+	.remove = debug_kinfo_remove,
+	.driver = {
+		.name = "debug-kinfo",
+		.of_match_table = of_match_ptr(debug_kinfo_of_match),
+	},
+};
+module_platform_driver(debug_kinfo_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Jone Chou <jonechou@google.com>");
+MODULE_DESCRIPTION("kmemdump Kinfo Driver");
+MODULE_LICENSE("GPL");
-- 
2.43.0


