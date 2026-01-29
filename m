Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7775D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4FE6B008C; Thu, 29 Jan 2026 16:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6186B0092; Thu, 29 Jan 2026 16:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBA76B0093; Thu, 29 Jan 2026 16:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF8B6B008C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:04:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E800B7FB7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:58 +0000 (UTC)
X-FDA: 84386231076.28.7B1E42D
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 870AE4000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eewqFcA0;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CRGF+/n1V2R5uGEqix6U/LES5Uojp7M/qLfKImGPj8=;
	b=PbtJ/tJx261k/swMHbwZQtN8wy8c2JvSAkjESKx9Wp/WtfliDQlCZZbs6rlpf2FJTqcAQF
	NmKe51rT4M4IO/0eRFomRTn7dIN4pDxJUFGr4cMOBMAHM9RbHWUxMYv1NmE50fBB7fPSrt
	3Psm0cEXkaN8Vm2e7Y1sZQBClvqAOSY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eewqFcA0;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720696; a=rsa-sha256;
	cv=none;
	b=Z5zLNyNiceJJeHVNWurzChnnE7NcOqOP1krlDEyUkoOiIFRfvJA09+Ld8zzQouRCUxOjBg
	yk6h30YJAlSsZsc1BeXryZqeLJKLTccX4cYtfdXTpJGAoqgx4wduaXksv9vCoGHxfjNl7c
	GcbcCqMfeD7PTo5/ZXhJ1Jql0Rfd+v4=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c6aaf3cd62so151114085a.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720695; x=1770325495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CRGF+/n1V2R5uGEqix6U/LES5Uojp7M/qLfKImGPj8=;
        b=eewqFcA0hv14LjuP9aZ4FXtE0pXkFlWy3P2CndXntQY03Bjv5mGlYhEfcS8DgjCusp
         3gC5ay/ZERLSvAnDk/NMlPQfP1NJazHr7f3OM/naqR1m67n3Hh1a289HHBWm6uji2CUQ
         vuKN7iBv8ng4nQJylOhW0GZMU/21xdqNtmTDeOhFv4CzjfYtfZ3cPeyFh0k5RfCMH9Gg
         4zsksw/N1ri1zOVUPOxcKd4UD7cL6VA2yJ31g+KeIOEBzhjCKsdYZrZsjFAPNE5jaZH3
         MZwS1IZgDsy4X1kBaQFcc43pSRqj3hzLP7I7DfCTwX1p22UJYMzRWJCc4lOfPOr9+egd
         YSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720695; x=1770325495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+CRGF+/n1V2R5uGEqix6U/LES5Uojp7M/qLfKImGPj8=;
        b=k2RhKOT8v7WvfxSEjCncV6wUrXMeg770tx2fcNcZlTguth/TANZcXKuE4zocWMscA4
         KIKEwkpZa36+ty462BnxhTR/bJhDPbSu50XG4VIa2NN0r62zdXKRFYC3fK3ssPHGU/Cc
         KIUATmn1sOYNoqf95MKPmByylSaDEkSTjHOmiYJgD2QDjaQJaKHrEaDmoZzkXWMUPzyu
         g6DgVU3S91hxcvD5zLoa28BLmwSbHFeaGrFENo1OjsEUFN5iVRGRF3ND3UIIcb2xoCW8
         7EAH4qLzyEMhLlXdNFe8qnRWD1XXM7z1qYA77PuZgxZG0GvqrHetBdKicfn08uvfIPM+
         W+mA==
X-Gm-Message-State: AOJu0Yw1HovChrxbl2ed8H9ofRfWrYMeqMBx1D8d/y2at6pnX3a9exoG
	g96ygfVKkPg2tbvZTfupD/TwDy7nC5mvmgo9ZOa/fZb4J1Sjzyb+eBhHhRi7qwpKKFMn9Hj5/Aa
	F5Q/2z0Q=
X-Gm-Gg: AZuq6aJOulc4WQn63B+76h3VmT4Y/5U/B95NlZKaf4Wf2KRmOj0z+zwDAcsOm3f47lL
	aHI83mCdGDORKmD3sQDl09+LH5kZ7GlhmYWoUsWFOJS9axPL6yQPIXku2onNXbbkPoV0cqxBlea
	5/sR42b0gHuLig57GucCVJwyheec4bQDrm4Iu+JU5cgLD4/MQ51bay5YzInVCyPi21XD0x3h3rk
	qaOA5phF4M/cSbqge8+h+Tkan7VCeEMiAnQeMI1cMou8w5cu7hfltND9Sl5w8aYyJP3Ngy3fmjR
	Q0al0e7pTqHwvOMnU7sHd+uSt91OsEIQX7b/eP3xw4dRzohUy46/gJ1179waWleY9OjoOiw5VyX
	p92iQixCBKgTLE+NZS+UisrqluMNc28cAJTkSBkptJaXV9wGe3/EQE34CIi7FNOJFF9zz3JG/aj
	ybJntcQxDHRx263T1eC6ka2BcbqH90f8qdsmuwABvXgUsVRVqK/YFjoMHZHaJnWbBxLP6LY788J
	pc=
X-Received: by 2002:a05:620a:17aa:b0:8c6:b2ce:f46 with SMTP id af79cd13be357-8c9eb1fc03cmr152696085a.14.1769720695300;
        Thu, 29 Jan 2026 13:04:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:54 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 3/9] dax: plumb online_type from dax_kmem creators to hotplug
Date: Thu, 29 Jan 2026 16:04:36 -0500
Message-ID: <20260129210442.3951412-4-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 870AE4000B
X-Stat-Signature: znk1xazh5xbfiq9ycmkq6izbgxp8yrxf
X-Rspam-User: 
X-HE-Tag: 1769720696-378811
X-HE-Meta: U2FsdGVkX1+Hp9C+xWYO7qiIOKcA1Ujf8m9E0a9wUM8WkKIeenfzN6/Q2tj7VhN93h6yYVmtBdCnu2vFDLLPGPd7ZJWLteeADhIPUcP0y1tGvaZYqZkkzgJ2Ghwp9nSe+BiNUU44r4wW7a9ul+1RCsN3PsQA0JdI7+UZ7NCFbJtZ0N7NQLc25lcINKUuZJmh426BmDCj9KJLyU8Tn6P2DYsY2fqtoTdWQoLjDgj19oLydhGhZyaDXWlNGZKl3eIOesRueY3AWMD4gAVeyfIjFgMB888PRV2K1HB6kcL4Wd8RKUCG6nA+JJqIZhd1UFRen6zPoIRvVEAgtKaVo0/SUR6BsD/PSW3pM5nBt7mgWTaUerW4oVvrw9AF4y+xDhYzyDdbVidcdHN1pyojKu6az7+jNlwpF9StbKXp24Td5uFK0TUirh57oMTPiIuu5r0q3xOuaqQEMHnEK33/Nou8uuTVqABZBoBwW5FCI6D2j5l1uKyvAe9dOyc7DbRLexkPLEmvxP0KAgM82J9m6g3djGSJEka8osgg8L/VBjxEZZdtnjliU1xOZVGAi2C6xQFj1aAz5CMLEwzlzFeX/3l4c0KNWK/RsmXvmkSLPlEB9mgB6s2FUo/df4fnv5yuBO96m4arH346qBs/KZUPLemI434xQwr6haVktMz+EDN+FXmL/8/pg4mUyzY/aDqePciX9xCRXAXhjXbh1+OWABnAdcENDpdF6aB+hlZjrZc6cjn1siJWA5qNhms5jtwm4yMyhd2Bxrugx0wSTdJsu+Z39hNp3aCj+zpMnhl18H7Ia0ehh0wHvR0TOh5rHaMxq1ildVjY/5FOp2a7e64fMLvsOA77/AtCptf92G7MnFbSdep2fGBH1qDjmox3LafEqOYZc6QU5xLSNmYMrWFE8dTqREMp+2a2mz+/e4zWTDMpjCW5rzG7pPfFH5hK0DBSS9bm9T85IsL/bE2lyAQd2QP
 uD5FQ6tb
 erJbve3fRNNl8dPSPSQJHmV4kOPT6d2uIYmfCaOq15f4ON0UZa1SPFKOmnDF+Q5h+Nu8UrdebY4CDBrclGNXwlGWY7R7aRW72MsSiKwLLAo6evxqKhvwjabc4iEgjxJxavIR6RGDr72Qbnl/adACwN/w3w8JB3meYM7pYHvXVZF1qBDxFXSMxZXKIP7iF2PPOPQzTBlxEdDQIA43OXrEVJTVvcbTpV5R0KgKxlfUQQwXZdj915p+1zttnfjoaEi0wUtLand+4JNgP6ZQukADYM8HWfqaAi1JqxUARRQP4yurNRw9oMbDNSHaelzotJ5WuZR3dFSeRji+4C7mieoDyptKm45A7w7P3Lg67DMv0W2lsVUlFnIOKnT2+/MX1RSxw3UR2pv/Axtdi906KeOrG+Ez71g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no way for drivers leveraging dax_kmem to plumb through a
preferred auto-online policy - the system default policy is forced.

Add online_type field to DAX device creation path to allow drivers
to specify an auto-online policy when using the kmem driver.

Current callers initialize online_type to mhp_get_default_online_type()
which resolves to the system default (memhp_default_online_type).

No functional change to existing drivers.

Cc:David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/region.c |  2 ++
 drivers/cxl/cxl.h         |  1 +
 drivers/dax/bus.c         |  3 +++
 drivers/dax/bus.h         |  1 +
 drivers/dax/cxl.c         |  1 +
 drivers/dax/dax-private.h |  2 ++
 drivers/dax/hmem/hmem.c   |  2 ++
 drivers/dax/kmem.c        | 13 +++++++++++--
 drivers/dax/pmem.c        |  2 ++
 9 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 5bd1213737fa..eef5d5fe3f95 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
 #include <linux/memregion.h>
+#include <linux/memory_hotplug.h>
 #include <linux/genalloc.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
@@ -3459,6 +3460,7 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	if (IS_ERR(cxlr_dax))
 		return PTR_ERR(cxlr_dax);
 
+	cxlr_dax->online_type = mhp_get_default_online_type();
 	dev = &cxlr_dax->dev;
 	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
 	if (rc)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index ba17fa86d249..07d57d13f4c7 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -591,6 +591,7 @@ struct cxl_dax_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct range hpa_range;
+	int online_type; /* MMOP_ value for kmem driver */
 };
 
 /**
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..121a6dd0afe7 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
 #include <linux/memremap.h>
+#include <linux/memory_hotplug.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -395,6 +396,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
 			.size = 0,
 			.id = -1,
 			.memmap_on_memory = false,
+			.online_type = mhp_get_default_online_type(),
 		};
 		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
 
@@ -1494,6 +1496,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->online_type = data->online_type;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..4ac92a4edfe7 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -24,6 +24,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	int online_type;	/* MMOP_ value for kmem driver */
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..856a0cd24f3b 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.online_type = cxlr_dax->online_type,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index c6ae27c982f4..9559718cc988 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -77,6 +77,7 @@ struct dev_dax_range {
  * @dev: device core
  * @pgmap: pgmap for memmap setup / lifetime (driver owned)
  * @memmap_on_memory: allow kmem to put the memmap in the memory
+ * @online_type: MMOP_* online type for memory hotplug
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
@@ -91,6 +92,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	int online_type;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index c18451a37e4f..119914b08fd9 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/platform_device.h>
+#include <linux/memory_hotplug.h>
 #include <linux/memregion.h>
 #include <linux/module.h>
 #include <linux/dax.h>
@@ -36,6 +37,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..550dc605229e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -16,6 +16,11 @@
 #include "dax-private.h"
 #include "bus.h"
 
+/* Internal function exported only to kmem module */
+extern int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				       const char *resource_name,
+				       mhp_t mhp_flags, int online_type);
+
 /*
  * Default abstract distance assigned to the NUMA node onlined
  * by DAX/kmem if the low level platform driver didn't initialize
@@ -72,6 +77,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
+	int online_type;
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
@@ -134,6 +140,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
+	online_type = dev_dax->online_type;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
@@ -174,8 +182,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..a5925146b09f 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
+#include <linux/memory_hotplug.h>
 #include <linux/memremap.h>
 #include <linux/module.h>
 #include "../nvdimm/pfn.h"
@@ -63,6 +64,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 		.pgmap = &pgmap,
 		.size = range_len(&range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return devm_create_dev_dax(&data);
-- 
2.52.0


