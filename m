Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD98FCAC58F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2240F6B00AB; Fri, 12 Sep 2025 11:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB8C6B00AC; Fri, 12 Sep 2025 11:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAD56B00AD; Fri, 12 Sep 2025 11:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7DA96B00AB
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D23213BDA3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:24 +0000 (UTC)
X-FDA: 83880934368.20.9983DB8
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0341A0014
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=V8Ug3FTj;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUEgobPFH+EGZPcli+Ra4q+x5D03Vw2x1oq0a5Xuvco=;
	b=kf4w2dAVB563fGbjLQG865pWSV4wnvtNK3MbwfjfpxMz2wmSenZx1TocdmPCWrOLnCJ20w
	SeZE0DHySZTKcRq61H753WQiEERg/O5ymlIkn1wG9mXbkLtbjXIlKEIWGUgmSsscAqWKMM
	XKXChluByuLpXSJ8XvRFTei+6m/yzQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689822; a=rsa-sha256;
	cv=none;
	b=l5tIUqQMcXPH+AbMY5uZRDowyh1A6KdzUppgw004MZyjsMXbXzbKUkBHhU7Xq+A/OsNgc9
	ISBcjoF78QODsIOyhHzk67gy1eed/Cb1PSs5INQqSXVCt3tJR38IJeen9KPTOzEiRObbuk
	Y3Mfpdnboi/E7NlgdTN49gX62oRyoOU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=V8Ug3FTj;
	spf=pass (imf25.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-723ad237d1eso18643247b3.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689822; x=1758294622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUEgobPFH+EGZPcli+Ra4q+x5D03Vw2x1oq0a5Xuvco=;
        b=V8Ug3FTjECxqtSfYwc+bkOA3Dw7ctUzkk8gu4kxqt0E3/YtHladLUVz4v5lFhm6jNM
         0ypt+uq3Lqhe6QEmX7VtbBYWIvlNIZaEKcpxfiYHQZYWrJUh7IcvPVRJFZuR84SX4M/G
         rT3aVD8fEhQTNdf9gNw7vGe9VV234Xx6LIvFmU1fTjTeTq8f7C80XDh67VtUoWQDvcm6
         QhFju64StcsP6t5Ei1UBMa73ltJYT+hF0LLrJ5T88iGY+tMmG+RmkvYSDpDY26ZyS/q6
         iJHqULQVS1+kmfGFzJCVX3VsvjW08ZMY/8qF6eiUFF4K11/zX9LWMEU7VQKz1Q/bubsO
         Z+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689822; x=1758294622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUEgobPFH+EGZPcli+Ra4q+x5D03Vw2x1oq0a5Xuvco=;
        b=ml6/u04icznmFWJ96EPF6VOzD/JNJZ0oOpvkNTo9clWliaOC9IxbZRu9Ywzv+0Rjoi
         PLH78xpVqeKo5gDcS4xQe2LAtO/VlLi/J1/7r5vS6e0L35X7oE12bMwADqBP0wClO8pS
         CXwjjI71keQQ0m9M/p4wd9jWISxQozABCJ4fhQ/incqiKvAhWl2YtMTS/pLyzTlvYoO7
         mSg5LBqvVqLVuM0UGqRp4m1RfqJIuOLlbguRt1U/y1jjLyQL8HkuxlZ9Xf7pvcY2/4IH
         Zb6qK5VNCyNvR85//Nu4WMCI23Z1pqegeWeXXMY5nIfuPa/R6HNnMHm3dGS5zCzBRjXv
         PIKA==
X-Forwarded-Encrypted: i=1; AJvYcCUz3r5Vz6sT3s5iWCAeV3BVrT+d2F9iiI3w5gGttMfXNUJJnK5/QQESvbiSnoNZwGEtsNYAiQPIxA==@kvack.org
X-Gm-Message-State: AOJu0Yw693HldbdRD2Y4Kzk06Pf8Po3ODI1XrB6hpAOxvhPHpWun/Lfj
	eBEA8bAA68/hg9YfiZ3iL3S2w4K3EgSUccAevwlDTj2DnIMXYc89CdoAMhrLxlZMQS8=
X-Gm-Gg: ASbGncuf36zcbQTsaQ8H/vmrEHINLRLR946wh4UH7YsKdbLKKk6lB5VRFJwPqmYPGD6
	gI+uSEGaXWCpJxFGH7jblISSD3pqo1+eDgzHuaDqZBB9hj1IdXyfWWQ2VHh6u+PwGDp0XJSP5R3
	BQYviF3R1ljto2aKzfnVNJM9yeyKL7qw/HieIT8P5X2KMtihb+MdeKWng6ZjdoAFWGXACazV886
	D2p9QdtxtENMWwNp9Jyd8det/8Mwsq8qEUWzj5Hf9LCr7oO30Gemd+A8UAs32VMqSCsEAUTfy6X
	TPvIc73pGXBZIRRU7+0dXRQMz41St4M0AgksJZpekELc+1kLB5ZGXKOYWu12ahaZyzkv3/DBUv8
	6LEKH8itJ1bYq6IRb/RXHLJ5g0Vm5+f8zgKtsGGCpO9Yb
X-Google-Smtp-Source: AGHT+IFfoHeq2qxhWL+Mgo2uL4H24h0IQUACTuuF5mx/FkiDr6oqL6RZMT2GVhdQdeu/Vgit1i7NzQ==
X-Received: by 2002:a05:690c:94:b0:71f:e154:7aa2 with SMTP id 00721157ae682-73064c04bdemr29570617b3.25.1757689821531;
        Fri, 12 Sep 2025 08:10:21 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:21 -0700 (PDT)
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
Subject: [RFC][PATCH v3 06/16] kmemdump: Introduce qcom-minidump backend driver
Date: Fri, 12 Sep 2025 18:08:45 +0300
Message-ID: <20250912150855.2901211-7-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9w8b3jhj8fxfyxm5qd9wk4abc1dfm8jq
X-Rspamd-Queue-Id: A0341A0014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757689822-93188
X-HE-Meta: U2FsdGVkX19BdkAsYSjOe0H7VF6VEpToeRQqK2iMMrxi5OIjNYcBauOTwGiY+8Tmpt1oar4G+e/yPyfPm1KhG4pxuJJC2SgjudwNqrQYXrate5l6eQk0Y+sZWz9RELGGEta6qISQUYQCY/DL0X7pcQfkIw95RfzXU4oMoPHCqmApgYceySrcafYWfgyHWrfSpQe6HEE0fK1hvVQBcerqx4DAZ2l7uH7AED7BLSOiXHDzeMEnqDD1o04CiLmSG22/ISeo1IX2GkttnjOWflc9oWTCzun349yQCPJ7tx1oRFQCPEPnSEVgQ0CBIY04ORkla/6AoClZnJ0bx+t3VD7vBgvzNurUMfEoSrpnP39Vc2DmFeLcMe3nebwN/YgD71A4KSdWaVK9d120BwwsM4Fnht3JfODP9WZUT6MhFeYF788Ap9wYfcvFONYATqc/ak+Q1jvb9laINZ+jiGNfl9yX573SkVYhz6Zrnr2mam/7mIYFU+pAc+LGwDGoyHo2lzL0i3i/5hBewS0PXBJdNfEp7fALC3pnP+A97JSD310rLK7l+R8qrQCfjfnWCMCtXWYG2T8xMQbkd1Fk8Q3FtjDtoyKD2YV0MYgzq/HSj9aolkrJvKYPy+tyvAwSNl0B+FG1UyIVul/+hv54D7dGxNLKlkc1uV0PP84DDMFlcu+cnDPQ+kxW+NwWXPGPS/jrC7NMeWjaKt5GwOHx/3TWR9ybGIXKDMzR6FhlyC19D1V8LFAxuteuVhudMVZ//h7kFTib9c0gHwYe5w4y4/zjxEErkES8zKKS+KIC7borntTXvnELlqLFh8Q8JQgGCuox6jkiF9nLRvGXjujoSKCqhFex8YWGqsNrqiSEgOAgx2Dkm9NK/x6XP66Xy2RK8nrxCTBJwPpwP/6nBn6g4Gc6rTM9KY82ljO+tG/+OgwncnfyWfFar/Wzln9SXe9rZSLRF1YpZqxQdVvgTO93QOh1lud
 4iY778Wz
 mQEZYMwEUof9n079o06VnDbEUqUscMPM1WZOaKRNFAOr30uDPl8M3R8KYK7lI/fPJdi9PwJXxO6/CoIOtYiKz31PF2mN6VoM6GvNJr2h8z4sLQ6GT32AmCadyDf4vSs7HAKBXIgL3c2cvcozvOPI0yIF4HtTicCumX+WcvpmXucqcc8bHfJt1eTMfsNmPXZPeOcsQpZccTwLDdJfDwEf9DtDDWUjG/GcJV9+7X3jdN2a/RLYwc/0Kswfa3QOD7FWqrxwJta8LBGrtrjGXaROGatBahlpCZ+DyQdQYhEyeYgGPD5zUZCpLAynFz0qbXdyQaN9jZ6TskzbyN73xxsO7ztgYEpz0fO/TWIdL1McF6hLZfPleOKkaGVQZX7UU09kQs3sJG+mCgLWqnS/h4Q3RbQMI5Lsd7s6Z66loCxpsQV8S9Ci3Sc5Ur6V74RVgPDYSETYKPdB9RBe+kRjvMqdxJvehB4rZ3Q5xcea92B1XDzyujuuvGunbeuxRrt7SJIUvxCLs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Qualcomm Minidump is a backend driver for kmemdump.
Regions are being registered into the shared memory on Qualcomm platforms
and into the table of contents.
Further, the firmware can read the table of contents and dump the memory
accordingly.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS                 |   5 +
 mm/kmemdump/Kconfig.debug   |  12 ++
 mm/kmemdump/Makefile        |   1 +
 mm/kmemdump/qcom_minidump.c | 353 ++++++++++++++++++++++++++++++++++++
 4 files changed, 371 insertions(+)
 create mode 100644 mm/kmemdump/qcom_minidump.c

diff --git a/MAINTAINERS b/MAINTAINERS
index fc8cd34cf190..8234acb24cbc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13818,6 +13818,11 @@ F:	include/linux/kmemdump.h
 F:	mm/kmemdump/kmemdump.c
 F:	mm/kmemdump/kmemdump_coreimage.c
 
+KMEMDUMP QCOM MINIDUMP BACKEND DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	mm/kmemdump/qcom_minidump.c
+
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>
 S:	Maintained
diff --git a/mm/kmemdump/Kconfig.debug b/mm/kmemdump/Kconfig.debug
index f62bde50a81b..91cec45bc3ca 100644
--- a/mm/kmemdump/Kconfig.debug
+++ b/mm/kmemdump/Kconfig.debug
@@ -26,3 +26,15 @@ config KMEMDUMP_COREIMAGE
 	  for debug tools are being registered.
 	  The coredump file can then be loaded into GDB or crash  tool and
 	  further inspected.
+
+config KMEMDUMP_QCOM_MINIDUMP_BACKEND
+	tristate "Qualcomm Minidump kmemdump backend driver"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on KMEMDUMP
+	help
+	  Say y here to enable the Qualcomm Minidump kmemdump backend
+	  driver.
+	  With this backend, the registered regions are being linked
+	  into the minidump table of contents. Further on, the firmware
+	  will be able to read the table of contents and extract the
+	  memory regions on case-by-case basis.
diff --git a/mm/kmemdump/Makefile b/mm/kmemdump/Makefile
index eed67f15a8d0..6ec3871203ef 100644
--- a/mm/kmemdump/Makefile
+++ b/mm/kmemdump/Makefile
@@ -2,3 +2,4 @@
 
 obj-y += kmemdump.o
 obj-$(CONFIG_KMEMDUMP_COREIMAGE) += kmemdump_coreimage.o
+obj-$(CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND) += qcom_minidump.o
diff --git a/mm/kmemdump/qcom_minidump.c b/mm/kmemdump/qcom_minidump.c
new file mode 100644
index 000000000000..604a58240c20
--- /dev/null
+++ b/mm/kmemdump/qcom_minidump.c
@@ -0,0 +1,353 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm Minidump backend driver for Kmemdump
+ * Copyright (C) 2016,2024-2025 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/soc/qcom/smem.h>
+#include <linux/kmemdump.h>
+#include <linux/container_of.h>
+
+/*
+ * In some of the Old Qualcomm devices, boot firmware statically allocates 300
+ * as total number of supported region (including all co-processors) in
+ * minidump table out of which linux was using 201. In future, this limitation
+ * from boot firmware might get removed by allocating the region dynamically.
+ * So, keep it compatible with older devices, we can keep the current limit for
+ * Linux to 201.
+ */
+#define MAX_NUM_REGIONS		201
+
+#define MAX_NUM_SUBSYSTEMS	10
+#define MAX_REGION_NAME_LENGTH	16
+#define SBL_MINIDUMP_SMEM_ID	602
+#define MINIDUMP_REGION_VALID	('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
+#define MINIDUMP_SS_ENCR_DONE	('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENABLED	('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+
+#define MINIDUMP_SS_ENCR_NOTREQ	(0 << 24 | 0 << 16 | 'N' << 8 | 'R' << 0)
+
+#define MINIDUMP_SUBSYSTEM_APSS	0
+
+const char *kmemdump_id_to_md_string[] = {
+	"",
+	"ELF",
+	"vmcoreinfo",
+	"config",
+	"memsect",
+	"totalram",
+	"cpu_possible",
+	"cpu_present",
+	"cpu_online",
+	"cpu_active",
+	"jiffies",
+	"linux_banner",
+	"nr_threads",
+	"nr_irqs",
+	"tainted_mask",
+	"taint_flags",
+	"mem_section",
+	"node_data",
+	"node_states",
+	"__per_cpu_offset",
+	"nr_swapfiles",
+	"init_uts_ns",
+	"printk_rb_static",
+	"printk_rb_dynamic",
+	"prb",
+	"prb_descs",
+	"prb_infos",
+	"prb_data",
+	"runqueues",
+	"high_memory",
+	"init_mm",
+	"init_mm_pgd",
+};
+
+/**
+ * struct minidump_region - Minidump region
+ * @name		: Name of the region to be dumped
+ * @seq_num:		: Use to differentiate regions with same name.
+ * @valid		: This entry to be dumped (if set to 1)
+ * @address		: Physical address of region to be dumped
+ * @size		: Size of the region
+ */
+struct minidump_region {
+	char	name[MAX_REGION_NAME_LENGTH];
+	__le32	seq_num;
+	__le32	valid;
+	__le64	address;
+	__le64	size;
+};
+
+/**
+ * struct minidump_subsystem - Subsystem's SMEM Table of content
+ * @status : Subsystem toc init status
+ * @enabled : if set to 1, this region would be copied during coredump
+ * @encryption_status: Encryption status for this subsystem
+ * @encryption_required : Decides to encrypt the subsystem regions or not
+ * @region_count : Number of regions added in this subsystem toc
+ * @regions_baseptr : regions base pointer of the subsystem
+ */
+struct minidump_subsystem {
+	__le32	status;
+	__le32	enabled;
+	__le32	encryption_status;
+	__le32	encryption_required;
+	__le32	region_count;
+	__le64	regions_baseptr;
+};
+
+/**
+ * struct minidump_global_toc - Global Table of Content
+ * @status : Global Minidump init status
+ * @revision : Minidump revision
+ * @enabled : Minidump enable status
+ * @subsystems : Array of subsystems toc
+ */
+struct minidump_global_toc {
+	__le32				status;
+	__le32				revision;
+	__le32				enabled;
+	struct minidump_subsystem	subsystems[MAX_NUM_SUBSYSTEMS];
+};
+
+#define MINIDUMP_MAX_NAME_LENGTH	12
+/**
+ * struct qcom_minidump_region - Minidump region information
+ *
+ * @name:	Minidump region name
+ * @virt_addr:  Virtual address of the entry.
+ * @phys_addr:	Physical address of the entry to dump.
+ * @size:	Number of bytes to dump from @address location,
+ *		and it should be 4 byte aligned.
+ * @id:		Region id.
+ */
+struct qcom_minidump_region {
+	char		name[MINIDUMP_MAX_NAME_LENGTH];
+	void		*virt_addr;
+	phys_addr_t	phys_addr;
+	size_t		size;
+	unsigned int	id;
+};
+
+/**
+ * struct minidump - Minidump driver data information
+ *
+ * @dev:	Minidump device struct.
+ * @toc:	Minidump table of contents subsystem.
+ * @regions:	Minidump regions array.
+ * @md_be:	Minidump backend.
+ */
+struct minidump {
+	struct device			*dev;
+	struct minidump_subsystem	*toc;
+	struct minidump_region		*regions;
+	struct kmemdump_backend		md_be;
+};
+
+static struct minidump *md;
+
+#define be_to_minidump(be) container_of(be, struct minidump, md_be)
+
+/**
+ * qcom_apss_md_table_init() - Initialize the minidump table
+ * @md: minidump data
+ * @mdss_toc: minidump subsystem table of contents
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int qcom_apss_md_table_init(struct minidump *md,
+				   struct minidump_subsystem *mdss_toc)
+{
+	md->toc = mdss_toc;
+	md->regions = devm_kcalloc(md->dev, MAX_NUM_REGIONS,
+				   sizeof(*md->regions), GFP_KERNEL);
+	if (!md->regions)
+		return -ENOMEM;
+
+	md->toc->regions_baseptr = cpu_to_le64(virt_to_phys(md->regions));
+	md->toc->enabled = cpu_to_le32(MINIDUMP_SS_ENABLED);
+	md->toc->status = cpu_to_le32(1);
+	md->toc->region_count = cpu_to_le32(0);
+
+	/* Tell bootloader not to encrypt the regions of this subsystem */
+	md->toc->encryption_status = cpu_to_le32(MINIDUMP_SS_ENCR_DONE);
+	md->toc->encryption_required = cpu_to_le32(MINIDUMP_SS_ENCR_NOTREQ);
+
+	return 0;
+}
+
+/**
+ * qcom_md_get_region_index() - Lookup minidump region by kmemdump id
+ * @md: minidump data
+ * @id: minidump region id
+ *
+ * Return: On success, it returns the internal region index, on failure,
+ *	returns	negative error value
+ */
+static int qcom_md_get_region_index(struct minidump *md, int id)
+{
+	unsigned int count = le32_to_cpu(md->toc->region_count);
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		if (md->regions[i].seq_num == id)
+			return i;
+
+	return -ENOENT;
+}
+
+/**
+ * register_md_region() - Register a new minidump region
+ * @be: kmemdump backend, this should be the minidump backend
+ * @id: unique id to identify the region
+ * @vaddr: virtual memory address of the region start
+ * @size: size of the region
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int register_md_region(const struct kmemdump_backend *be,
+			      enum kmemdump_uid id, void *vaddr, size_t size)
+{
+	struct minidump *md = be_to_minidump(be);
+	struct minidump_region *mdr;
+	unsigned int num_region, region_cnt;
+	const char *name = "unknown";
+
+	if (!vaddr || !size)
+		return -EINVAL;
+
+	if (id < ARRAY_SIZE(kmemdump_id_to_md_string))
+		name = kmemdump_id_to_md_string[id];
+
+	if (qcom_md_get_region_index(md, id) >= 0) {
+		dev_dbg(md->dev, "%s:%d region is already registered\n",
+			name, id);
+		return -EEXIST;
+	}
+
+	/* Check if there is a room for a new entry */
+	num_region = le32_to_cpu(md->toc->region_count);
+	if (num_region >= MAX_NUM_REGIONS) {
+		dev_err(md->dev, "maximum region limit %u reached\n",
+			num_region);
+		return -ENOSPC;
+	}
+
+	region_cnt = le32_to_cpu(md->toc->region_count);
+	mdr = &md->regions[region_cnt];
+	scnprintf(mdr->name, MAX_REGION_NAME_LENGTH, "K%.8s", name);
+	mdr->seq_num = id;
+	mdr->address = cpu_to_le64(__pa(vaddr));
+	mdr->size = cpu_to_le64(ALIGN(size, 4));
+	mdr->valid = cpu_to_le32(MINIDUMP_REGION_VALID);
+	region_cnt++;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+
+	return 0;
+}
+
+/**
+ * unregister_md_region() - Unregister a previously registered minidump region
+ * @be: pointer to backend
+ * @id: unique id to identify the region
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int unregister_md_region(const struct kmemdump_backend *be,
+				unsigned int id)
+{
+	struct minidump *md = be_to_minidump(be);
+	struct minidump_region *mdr;
+	unsigned int region_cnt;
+	unsigned int idx;
+
+	idx = qcom_md_get_region_index(md, id);
+	if (idx < 0) {
+		dev_err(md->dev, "%d region is not present\n", id);
+		return idx;
+	}
+
+	mdr = &md->regions[0];
+	region_cnt = le32_to_cpu(md->toc->region_count);
+	/*
+	 * Left shift all the regions exist after this removed region
+	 * index by 1 to fill the gap and zero out the last region
+	 * present at the end.
+	 */
+	memmove(&mdr[idx], &mdr[idx + 1], (region_cnt - idx - 1) * sizeof(*mdr));
+	memset(&mdr[region_cnt - 1], 0, sizeof(*mdr));
+	region_cnt--;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+
+	return 0;
+}
+
+static int qcom_md_probe(struct platform_device *pdev)
+{
+	struct minidump_global_toc *mdgtoc;
+	size_t size;
+	int ret;
+
+	md = kzalloc(sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return -ENOMEM;
+
+	md->dev = &pdev->dev;
+
+	strscpy(md->md_be.name, "qcom_minidump");
+	md->md_be.register_region = register_md_region;
+	md->md_be.unregister_region = unregister_md_region;
+
+	mdgtoc = qcom_smem_get(QCOM_SMEM_HOST_ANY, SBL_MINIDUMP_SMEM_ID, &size);
+	if (IS_ERR(mdgtoc)) {
+		ret = PTR_ERR(mdgtoc);
+		dev_err(md->dev, "Couldn't find minidump smem item %d\n", ret);
+		goto qcom_md_probe_fail;
+	}
+
+	if (size < sizeof(*mdgtoc) || !mdgtoc->status) {
+		dev_err(md->dev, "minidump table is not initialized\n");
+		ret = -ENAVAIL;
+		goto qcom_md_probe_fail;
+	}
+
+	ret = qcom_apss_md_table_init(md, &mdgtoc->subsystems[MINIDUMP_SUBSYSTEM_APSS]);
+	if (ret)
+		goto qcom_md_probe_fail;
+
+	return kmemdump_register_backend(&md->md_be);
+
+qcom_md_probe_fail:
+	kfree(md);
+	return ret;
+}
+
+static void qcom_md_remove(struct platform_device *pdev)
+{
+	kfree(md);
+	kmemdump_unregister_backend(&md->md_be);
+}
+
+static struct platform_driver qcom_md_driver = {
+	.probe = qcom_md_probe,
+	.remove = qcom_md_remove,
+	.driver  = {
+		.name = "qcom-minidump",
+	},
+};
+
+module_platform_driver(qcom_md_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Mukesh Ojha <quic_mojha@quicinc.com>");
+MODULE_DESCRIPTION("Qualcomm kmemdump minidump backend driver");
+MODULE_LICENSE("GPL");
-- 
2.43.0


