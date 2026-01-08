Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899A2D1D495
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2C56B0096; Thu,  8 Jan 2026 15:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90A36B0099; Thu,  8 Jan 2026 15:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AAE6B009D; Thu,  8 Jan 2026 15:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE9F96B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:46:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EB4AC17FB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:46:23 +0000 (UTC)
X-FDA: 84309979446.16.97B44F8
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F48710000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:46:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rBu8xA5R;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767905181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwgM57cBzuIgAiPMK5GxhnYsXF2RBvqFNs+qFbak5h0=;
	b=XU82ymcQ+YvGyX8fgjcnXN0C/z1Qk98pRb4JvGINZ/SkkoYkSAJ9vm1mVBhbtByqqNKZqJ
	xggD+z78cXRmJcOm5ops9I+Ncu4S/w04/SRlZQrQkJ2mVuf2vmOC8hwyDYeGvIXtUH0nQF
	eOKo++wC8doq5uGc9wUPqLcIJGq7zxo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rBu8xA5R;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767905181; a=rsa-sha256;
	cv=none;
	b=6N9aOF8a8BllBcYGNv3rESmtL3Fgd4d3x4vYxJdeBnvUSdGF9hj9ZOqqbEYsLjQ/t9lA39
	YNTnrfoMnEK5ctK+K0qZqQZaNPTrOw7m/zqGa9YQP3M2/MNr2ZqHzL6ccz6cQqnKH5Xl+h
	I1H/J9s9x3XYScz9fekEkfb5bGsMjvM=
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3e12fd71984so2531382fac.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767905180; x=1768509980; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwgM57cBzuIgAiPMK5GxhnYsXF2RBvqFNs+qFbak5h0=;
        b=rBu8xA5Rwsp/NDDarkQGNU3RQ1KMM7865D20dQ4Cs/F7vA35AMtBjN0thMz8lMEw33
         pHf+L4K9cCrqF0IHw4fbdMthBylKv60z7YaI/xPcBNGBPlWhjYUplMqqECDDImVlbPcj
         hQWquiFiJ29bZNvoZGReVQVGGCIa1ukZ1HPeyiQsahcQme35KEa1Fvudy1z8cQruGZ//
         DAnp9OqqzFepCEs3+RO901QrNNe3uVjrvaGkD+SoEkDWCKmHwMWpaB1HSY+66jBQ48C9
         Yuys3H6U6INGULRJxyimjfRM/r6FACTJE6SFYVbIDg+u9JcHe1qSVaqM5fFzugywMOjI
         doSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767905180; x=1768509980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwgM57cBzuIgAiPMK5GxhnYsXF2RBvqFNs+qFbak5h0=;
        b=s36PqKif5g/qOkHDZvjL0k4Y0Q8uSgztoOWmH0UOvT8KvkUtqj6y+d26+J598feUGG
         HoZjUcODsse+Wy1BYM1TgTzTe42rFmLaN0iPDEIPYw/r66purryrSSqMr4tGBqWSWSId
         GUMNiVZaVS15VUjg/JQJl91CtE1zFzupenbXsYaXoxMxi2sbrOMfdzSx2fZgEs4xu3e3
         MtkF1erQx0FgwKzHJnbwPaCTpvicyuZqdXMRlQF5iZW7JtRlKtyiWJMFp+FoREHlhlDo
         62qDKwagZOuulifpHYeY2g364rok3HWZPVPLuTB+6q3al3zET0UVuVNJPLkwt5RwWROq
         odpw==
X-Gm-Message-State: AOJu0Yzj4rG9k5/Ep0N1QGNWewI+ck6UfEgmm0y1egJc6z37Uonh+e6l
	ZnjSpatN9yqVGSqeXdxqWmNnUrjclBNg8XuAg6031yE3sRiE0aCnxeihEaHkHRAP7M7uhMS8Zcv
	KM5qN
X-Gm-Gg: AY/fxX5AqbbP0kBDUkide1b4v16yioC6Q7jjefVsmOngouVL5qSedViz2FQvtv2Dy6c
	pmiYRabRzkRWd4VCfVMbWzKsEcwDswn9l7Ae5MCJ+gFpMOPjAg9uVvg1y9ySUGIyox2xXZ0Y5vJ
	gyTB1psg3mcBlFPO7YgHrgeJRGz4kMLcSlAAUNOL3tDTba50lWQHSmvIlpxHvK1MH1VcxfFiTxY
	TO4Z55ocDpwV7yfKZhplgd4MVz0aZY4YVOVniFidK7FsajoFfG1Fjhd0OxLCaM3if3FYf9Q21+T
	pVbE2qKRNhY3X6tkflC2c8ni29eE9JniMzgXzel4drh4gata8/EhYUKqqhPSjoFfJu4f4Jd3keE
	1Z5BssNPKf2CN9AvOiQJ34i19c9HI+wYuj25sq9uHcWUW27ZlwQOnzc4t5HC4AQ2iiRRME1dInH
	5nbnBDljIW1I9ykUIGznEp1AczfNiqL3+dtycNlRlfCfWdTyPJtQEVoKxOG2rJdPhRC/nDAoMQs
	Jk=
X-Google-Smtp-Source: AGHT+IEohul7eh/tCSXsk4Ov9Y1GsfVyXy+u/Ko/qY44ZfRMGDZ1/y3sswNjUUv0CUGvS9SQKMHaSg==
X-Received: by 2002:a05:620a:1a9d:b0:8b2:d6eb:8204 with SMTP id af79cd13be357-8c389416dbfmr982794985a.71.1767904744299;
        Thu, 08 Jan 2026 12:39:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:39:03 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com
Subject: [RFC PATCH v3 6/8] drivers/cxl/core/region: add private_region
Date: Thu,  8 Jan 2026 15:37:53 -0500
Message-ID: <20260108203755.1163107-7-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zg4mgp7npcdyigxpbp5smjbjduywearz
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F48710000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1767905181-510707
X-HE-Meta: U2FsdGVkX1/47brLdCRnixeWwEKeHWipTllcF0bgPw5KSPP343UexNTY0XlBCPtu6T13BCRXgzFKxl+W+gXKr+aJHggJJ0rdFTLGeypjViBqBeUE2QkST3KRtYqxn34Ijtp/jJocCsAy5lKq5MQ0H6H/tDrRMGa7fLVDZw43AsSzo/p/9d5Gkzu2hTGfshrFCtpu6mNbelJQZ8o+dEa4yNUhBvPHnQWbzTxCku9TDXHXTdIg+ElvGuF52nv3YGf59YJpuuVT9j3/bQ+DynoBsQWuNKLqXTDM1Q4et7VpM3hrnfFOm4KnjeB7d1jFLb/TPC28vBT7HQRk/+COvDk2rlzwMXOnwzVz0KS6Y7RLufUWH1QZVgPnilbH5yd8W+9KcEm1TBYNJOxrSCIOtch42WO4YYReAYEbNDRHAeCZ9UcqpbgKLuG0zihARhN17V6z5wSLvFNB98hUvG0vYsestovACv7R3XtCmYV+IqpSRVT41Ku1gsam4jCupjzELjeQRkCm2uxpG8P6uzCHG4Dj6GBrdCi9DNFPbI219FoFEVLv2Wz3lgy2a+aFzKcZy7rIsnbmxe2oSuCuY0EvipKsFAwcw0WWuaUgnhC7iglHwXCDnyp4NnHPNKtgoDsMRHe8DaKYTzXvJpcoQb7bRXVgBJt4Y5OfqYzOfmo30N0pjxv5JgMWE7DdPa4q3NORP8lyq9ui2Oxx5QBjo+pqAk/oGWXnJ/YRl8S0KS9xXaVitSOHvDrhAMpj99eehRsirCeYkxtftVsDVnBTMvfG8PuC+ZgI2pt/lsuFcm79Oyoy7V3Crfh/tvRnOrV9soXMs8WvnSXZSOWKOWoJRpqLDo5/z7mOKqEPDMv9VLU2QdRHIVAqSwKrdAGTkjcPC6t8uw0awqH9ERw17/oB86oDiB3RkNQy7c+7STcFI8ZwgChev45HNR5SZpDmXWr6fh+/DjXyKgcwwU/PMXDC/I/4Asq
 /VnAw5qm
 bEbrya7rxtTgooTIRQDYEwKOqTnHsBT5JLRsThoRf3oHBGyj+WpBEMMQPnINVlX48wn7sjp4CV1cMLZqzBMGtk3xUeCcjO+PNgUDVaRMaoihuPSLcayHuj3QZ8nGCYRLVF+lFvuR5W0jxJ5Tg8nOqZhp7RpiyzkBzPeJpnjzCpjnyrCczgcvWyDth8xidbjYWOT4q6cgSpUX8JaDeykANobzTyqnnuH54y94+pFqp36pMWllhVW3IyawcAyEn6B6XEoWcGIJJmLysUOnJGWGV3xC7OyGBkJ+V0r/rr+PtzW6ZuLu/4bniqHWhlcEZ3pYbwwXoc5Juo/lRuytnmluM64xz1BFNmj0AcXB5SOO9PRrKR6O4r2xQt4ZLh5mFW8/XInt1xvfcOezNpaUNCZoL5KoQ1UVMzs9yz2CddTfGHkFtN44=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A private_region is just a RAM region which attempts to set the
target_node to N_PRIVATE before continuing to create a DAX device and
subsequently hotplugging memory onto the system.

A CXL device driver would create a private_region with the intent to
manage how the memory can be used more granuarly than typical SystemRAM.

This patch adds the infrastructure for a private memory region. Added
as a separate folder to keep private region types organized.

usage:
    echo regionN > decoderX.Y/create_private_region
    echo type    > regionN/private_type

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   4 +
 drivers/cxl/core/port.c                       |   4 +
 drivers/cxl/core/private_region/Makefile      |   9 ++
 .../cxl/core/private_region/private_region.c  | 119 ++++++++++++++++++
 .../cxl/core/private_region/private_region.h  |  10 ++
 drivers/cxl/core/region.c                     |  63 ++++++++--
 drivers/cxl/cxl.h                             |  20 +++
 8 files changed, 219 insertions(+), 11 deletions(-)
 create mode 100644 drivers/cxl/core/private_region/Makefile
 create mode 100644 drivers/cxl/core/private_region/private_region.c
 create mode 100644 drivers/cxl/core/private_region/private_region.h

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 5ad8fef210b5..2dd882a52609 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -17,6 +17,7 @@ cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
+obj-$(CONFIG_CXL_REGION) += private_region/
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1fb66132b777..159f92e4bea1 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -21,6 +21,7 @@ enum cxl_detach_mode {
 #ifdef CONFIG_CXL_REGION
 extern struct device_attribute dev_attr_create_pmem_region;
 extern struct device_attribute dev_attr_create_ram_region;
+extern struct device_attribute dev_attr_create_private_region;
 extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
 extern const struct device_type cxl_pmem_region_type;
@@ -30,6 +31,9 @@ extern const struct device_type cxl_region_type;
 int cxl_decoder_detach(struct cxl_region *cxlr,
 		       struct cxl_endpoint_decoder *cxled, int pos,
 		       enum cxl_detach_mode mode);
+int devm_cxl_add_dax_region(struct cxl_region *cxlr);
+struct cxl_region *to_cxl_region(struct device *dev);
+extern struct device_attribute dev_attr_private_type;
 
 #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
 #define CXL_REGION_TYPE(x) (&cxl_region_type)
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index fef3aa0c6680..aedecb83e59b 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -333,6 +333,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_qos_class.attr,
 	SET_CXL_REGION_ATTR(create_pmem_region)
 	SET_CXL_REGION_ATTR(create_ram_region)
+	SET_CXL_REGION_ATTR(create_private_region)
 	SET_CXL_REGION_ATTR(delete_region)
 	NULL,
 };
@@ -362,6 +363,9 @@ static umode_t cxl_root_decoder_visible(struct kobject *kobj, struct attribute *
 	if (a == CXL_REGION_ATTR(create_ram_region) && !can_create_ram(cxlrd))
 		return 0;
 
+	if (a == CXL_REGION_ATTR(create_private_region) && !can_create_ram(cxlrd))
+		return 0;
+
 	if (a == CXL_REGION_ATTR(delete_region) &&
 	    !(can_create_pmem(cxlrd) || can_create_ram(cxlrd)))
 		return 0;
diff --git a/drivers/cxl/core/private_region/Makefile b/drivers/cxl/core/private_region/Makefile
new file mode 100644
index 000000000000..d17498129ba6
--- /dev/null
+++ b/drivers/cxl/core/private_region/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# CXL Private Region type implementations
+#
+
+ccflags-y += -I$(srctree)/drivers/cxl
+
+# Core dispatch and sysfs
+obj-$(CONFIG_CXL_REGION) += private_region.o
diff --git a/drivers/cxl/core/private_region/private_region.c b/drivers/cxl/core/private_region/private_region.c
new file mode 100644
index 000000000000..ead48abb9fc7
--- /dev/null
+++ b/drivers/cxl/core/private_region/private_region.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CXL Private Region - dispatch and lifecycle management
+ *
+ * This file implements the main registration and unregistration dispatch
+ * for CXL private regions. It handles common initialization and delegates
+ * to type-specific implementations.
+ */
+
+#include <linux/device.h>
+#include <linux/cleanup.h>
+#include "../../cxl.h"
+#include "../core.h"
+#include "private_region.h"
+
+static const char *private_type_to_string(enum cxl_private_region_type type)
+{
+	switch (type) {
+	default:
+		return "";
+	}
+}
+
+static enum cxl_private_region_type string_to_private_type(const char *str)
+{
+	return CXL_PRIVATE_NONE;
+}
+
+static ssize_t private_type_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%s\n", private_type_to_string(cxlr->private_type));
+}
+
+static ssize_t private_type_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	enum cxl_private_region_type type;
+	ssize_t rc;
+
+	type = string_to_private_type(buf);
+	if (type == CXL_PRIVATE_NONE)
+		return -EINVAL;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
+		return rc;
+
+	/* Can only change type before region is committed */
+	if (p->state >= CXL_CONFIG_COMMIT)
+		return -EBUSY;
+
+	cxlr->private_type = type;
+
+	return len;
+}
+DEVICE_ATTR_RW(private_type);
+
+/*
+ * Register a private CXL region based on its private_type.
+ *
+ * This function is called during commit. It validates the private_type,
+ * initializes the private_ops, and dispatches to the appropriate
+ * registration function which handles memtype, callbacks, and node
+ * registration.
+ */
+int cxl_register_private_region(struct cxl_region *cxlr)
+{
+	int rc = 0;
+
+	if (!cxlr->params.res)
+		return -EINVAL;
+
+	if (cxlr->private_type == CXL_PRIVATE_NONE) {
+		dev_err(&cxlr->dev, "private_type must be set before commit\n");
+		return -EINVAL;
+	}
+
+	/* Initialize the private_ops with region info */
+	cxlr->private_ops.res_start = cxlr->params.res->start;
+	cxlr->private_ops.res_end = cxlr->params.res->end;
+	cxlr->private_ops.data = cxlr;
+
+	/* Call type-specific registration which sets memtype and callbacks */
+	switch (cxlr->private_type) {
+	default:
+		dev_dbg(&cxlr->dev, "unsupported private_type: %d\n",
+			cxlr->private_type);
+		rc = -EINVAL;
+		break;
+	}
+
+	if (!rc)
+		set_bit(CXL_REGION_F_PRIVATE_REGISTERED, &cxlr->flags);
+	return rc;
+}
+
+/*
+ * Unregister a private CXL region.
+ *
+ * This function is called during region reset or device release.
+ * It dispatches to the appropriate type-specific cleanup function.
+ */
+void cxl_unregister_private_region(struct cxl_region *cxlr)
+{
+	if (!test_and_clear_bit(CXL_REGION_F_PRIVATE_REGISTERED, &cxlr->flags))
+		return;
+
+	/* Dispatch to type-specific cleanup */
+	switch (cxlr->private_type) {
+	default:
+		break;
+	}
+}
diff --git a/drivers/cxl/core/private_region/private_region.h b/drivers/cxl/core/private_region/private_region.h
new file mode 100644
index 000000000000..9b34e51d8df4
--- /dev/null
+++ b/drivers/cxl/core/private_region/private_region.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __CXL_PRIVATE_REGION_H__
+#define __CXL_PRIVATE_REGION_H__
+
+struct cxl_region;
+
+int cxl_register_private_region(struct cxl_region *cxlr);
+void cxl_unregister_private_region(struct cxl_region *cxlr);
+
+#endif /* __CXL_PRIVATE_REGION_H__ */
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ae899f68551f..c60eef96c0ca 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -15,6 +15,7 @@
 #include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
+#include "private_region/private_region.h"
 
 /**
  * DOC: cxl core region
@@ -38,8 +39,6 @@
  */
 static nodemask_t nodemask_region_seen = NODE_MASK_NONE;
 
-static struct cxl_region *to_cxl_region(struct device *dev);
-
 #define __ACCESS_ATTR_RO(_level, _name) {				\
 	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
 	.show	= _name##_access##_level##_show,			\
@@ -398,9 +397,6 @@ static int __commit(struct cxl_region *cxlr)
 		return rc;
 
 	rc = cxl_region_decode_commit(cxlr);
-	if (rc)
-		return rc;
-
 	p->state = CXL_CONFIG_COMMIT;
 
 	return 0;
@@ -615,12 +611,17 @@ static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
 	struct cxl_region *cxlr = to_cxl_region(dev);
 	const char *desc;
 
-	if (cxlr->mode == CXL_PARTMODE_RAM)
-		desc = "ram";
-	else if (cxlr->mode == CXL_PARTMODE_PMEM)
+	switch (cxlr->mode) {
+	case CXL_PARTMODE_RAM:
+		desc = cxlr->private ? "private" : "ram";
+		break;
+	case CXL_PARTMODE_PMEM:
 		desc = "pmem";
-	else
+		break;
+	default:
 		desc = "";
+		break;
+	}
 
 	return sysfs_emit(buf, "%s\n", desc);
 }
@@ -772,6 +773,7 @@ static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_size.attr,
 	&dev_attr_mode.attr,
 	&dev_attr_extended_linear_cache_size.attr,
+	&dev_attr_private_type.attr,
 	NULL,
 };
 
@@ -2400,6 +2402,9 @@ static void cxl_region_release(struct device *dev)
 	struct cxl_region *cxlr = to_cxl_region(dev);
 	int id = atomic_read(&cxlrd->region_id);
 
+	/* Ensure private region is cleaned up if not already done */
+	cxl_unregister_private_region(cxlr);
+
 	/*
 	 * Try to reuse the recently idled id rather than the cached
 	 * next id to prevent the region id space from increasing
@@ -2429,7 +2434,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -2638,6 +2643,13 @@ static ssize_t create_ram_region_show(struct device *dev,
 	return __create_region_show(to_cxl_root_decoder(dev), buf);
 }
 
+static ssize_t create_private_region_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	return __create_region_show(to_cxl_root_decoder(dev), buf);
+}
+
 static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 					  enum cxl_partition_mode mode, int id)
 {
@@ -2698,6 +2710,28 @@ static ssize_t create_ram_region_store(struct device *dev,
 }
 DEVICE_ATTR_RW(create_ram_region);
 
+static ssize_t create_private_region_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t len)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
+	struct cxl_region *cxlr;
+	int rc, id;
+
+	rc = sscanf(buf, "region%d\n", &id);
+	if (rc != 1)
+		return -EINVAL;
+
+	cxlr = __create_region(cxlrd, CXL_PARTMODE_RAM, id);
+	if (IS_ERR(cxlr))
+		return PTR_ERR(cxlr);
+
+	cxlr->private = true;
+
+	return len;
+}
+DEVICE_ATTR_RW(create_private_region);
+
 static ssize_t region_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -3431,7 +3465,7 @@ static void cxlr_dax_unregister(void *_cxlr_dax)
 	device_unregister(&cxlr_dax->dev);
 }
 
-static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
+int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 {
 	struct cxl_dax_region *cxlr_dax;
 	struct device *dev;
@@ -3974,6 +4008,13 @@ static int cxl_region_probe(struct device *dev)
 					p->res->start, p->res->end, cxlr,
 					is_system_ram) > 0)
 			return 0;
+
+
+		if (cxlr->private) {
+			rc = cxl_register_private_region(cxlr);
+			if (rc)
+				return rc;
+		}
 		return devm_cxl_add_dax_region(cxlr);
 	default:
 		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index ba17fa86d249..b276956ff88d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -525,6 +525,20 @@ enum cxl_partition_mode {
  */
 #define CXL_REGION_F_LOCK 2
 
+/*
+ * Indicate that this region has been registered as a private region.
+ * Used to track lifecycle and prevent double-unregistration.
+ */
+#define CXL_REGION_F_PRIVATE_REGISTERED 3
+
+/**
+ * enum cxl_private_region_type - CXL private region types
+ * @CXL_PRIVATE_NONE: No private region type set
+ */
+enum cxl_private_region_type {
+	CXL_PRIVATE_NONE,
+};
+
 /**
  * struct cxl_region - CXL region
  * @dev: This region's device
@@ -534,10 +548,13 @@ enum cxl_partition_mode {
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
  * @flags: Region state flags
+ * @private: Region is private (not exposed to system memory)
  * @params: active + config params for the region
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
+ * @private_type: CXL private region type for dispatch (set via sysfs)
+ * @private_ops: private node operations for callbacks (if mode is PRIVATE)
  */
 struct cxl_region {
 	struct device dev;
@@ -547,10 +564,13 @@ struct cxl_region {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
 	unsigned long flags;
+	bool private;
 	struct cxl_region_params params;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	enum cxl_private_region_type private_type;
+	struct private_node_ops private_ops;
 };
 
 struct cxl_nvdimm_bridge {
-- 
2.52.0


