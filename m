Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16E31094483
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598656B00CE; Sat, 21 Mar 2026 11:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7416B00CF; Sat, 21 Mar 2026 11:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1795A6B00D0; Sat, 21 Mar 2026 11:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 015256B00CE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C219D1A05FB
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:22 +0000 (UTC)
X-FDA: 84570391164.20.5D2F50F
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 326EF1C000F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FEWYOz8f;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpXtFQ1E8PxzzJ3jH0sASsMe/zJtVJUABHrep2C4jPI=;
	b=2A3iWhTePI2MGk7UK48XiXHnRb8z51MvWeADVTEWzpA2+ZLREn3wE6ZSs0DOUVhDpamFDh
	rPtmqoHcYoipYU/Ydwp8ZupC2ekixo9DOAlC3X7dDuUhNJJPW1Uth6/uXBs4EoyCmcnVDv
	Zl3Tz3ZE+GOnM+Ea8Ov5tGWKzsXxb7o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FEWYOz8f;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105461; a=rsa-sha256;
	cv=none;
	b=Sz0jtUqUvYCJtNIabMSfg3ssE3FYFNU4YfTaQY80AvwrrNHDU/Mv0U/TbBK4KwGbiehydQ
	uht1JqdURj8NzMWMdyRKGcX6wYAsQZHmzlwlc8docxv/abrBrOlWUgDvzyDAcGigKm0YYT
	Lwxt0gNiIuskx2a5n5HSvOwsiuNtlEs=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cfc2d1fdbfso188852785a.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105460; x=1774710260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpXtFQ1E8PxzzJ3jH0sASsMe/zJtVJUABHrep2C4jPI=;
        b=FEWYOz8fMhEpx5bAuLxK+CeqmMuVDB5r3liBLgM3OqYwCUWZUjvxvXZHCznB3K9Yy8
         6rk4AxjvAkfEbtM+SsUsa4hkO3LAZMG27kiSj5O3Yi0Y5GQf3van8PqPFMxDnAzKkX5G
         jAS8/L8PY8XvYNMHTCDsJoKUVyk5DS1+PJFV0UOLYoX7Te86Tat28VO7kxkgNTzVY7jV
         KWzLb6N0krT8Mv4WZwD3cltzBacblxTF22j6FWVIRZvqIpRleCTBD/0R/eOHXpBNBwIT
         N57wVCOFsBTgyRH1rrLSFikyqzC9ciVUMAc9TDfPJQrAvFt/oOjhj4Xu+7xAvTkmlVDm
         a+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105460; x=1774710260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DpXtFQ1E8PxzzJ3jH0sASsMe/zJtVJUABHrep2C4jPI=;
        b=RMFCaqPCG/jp10v4YsdZaa8AN4bBJQDk7LJHwCKZkPBFYXlXxp5wmpM4RuhFKKW2KC
         vskgU2trUpTCKiHZ0Wm9xEQo/DRdK/AijMGy0KT0q5uU7Wr/bqZka7M0h/kcx6UjvpV9
         2lUQ6Yy6W0iQinX5tsL0CgNv6JUzHMUCw03dhm840sO+uDVyc9WcZzPx10EJyxvHr6Ii
         vpYuNnP5gUta6X27kJDaH2hdzNY0lUWOU2i7/a6SXLQS+8cLgORJ7EobE3S3SePDzAgc
         CQStM10mZttGQwIqHO39AhnNwphHnyNsr6hG/MRi1uzBHUepSa7WgaEZPIU3vpKiNrEt
         u6bg==
X-Gm-Message-State: AOJu0YxUtuJIZSsClgEx8oKAPzBGtfyiGf37ZDh82riMp5zif7iRdUcX
	rJptMPJK6TNhjQQpThKNgYtgvuGF9RZeFsyBjHsKu9mrPAdT/vs8Oxt1DNT8HyvTKwwFmtzhw4i
	n81qb
X-Gm-Gg: ATEYQzyaMNjahLWH43uTd0RZAtk6/phVochRVQRXpDlD8CWK3Di23/DPdW1T0rbMXMt
	Y7tCAUhBMrJMlNSQx3TkZt8MFyE1g6j43FBsEFfY3a0UKfhPTwMsOlTKlxR/sJKGOh/ccbQMSoT
	oro+0sTL6/8V3/ZIHnofVdVaNvpIQ/D0M/3LWyMmwaekP08brkavDSqrsGV5FqnbOj2tw4Q6ksN
	BjzsqAOmZq5q7wIghHqDNJP2H16lFk3c8LaoqfCJg0RCOHHW0GJNBeT7l6IxfKBswO2hzvr9iXT
	rTUv0PTsDCTfZ5pCwFNJgrq30BXbKq/D98iMus0V7+hTClPbqf91oRjbzFo7T5f0ANoyaJrYQ54
	yUaoQ0V6U09Bo/01jQL4gLUxijBLQTcvgy/Es9oWttZWnXDGCdTvhMGRnieLej0vLbts65rvcAU
	XpXa0KZUY48yHcsxPODxk0/s7cr3TIm6tlA4JjXH2CxQuDEmwY5q9UN8yhKlR8XLLrFYQNs0Tpr
	FIallGJyRCUWlk=
X-Received: by 2002:a05:620a:4055:b0:8cf:dd4b:8a53 with SMTP id af79cd13be357-8cfdd4b9250mr167236585a.30.1774105459722;
        Sat, 21 Mar 2026 08:04:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/8] dax: plumb hotplug online_type through dax
Date: Sat, 21 Mar 2026 11:04:02 -0400
Message-ID: <20260321150404.3288786-7-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 326EF1C000F
X-Rspamd-Server: rspam08
X-Stat-Signature: otko57fo4in3u7ef4oj43sy7dj5he934
X-HE-Tag: 1774105461-890572
X-HE-Meta: U2FsdGVkX1+SGlBZBrdw5VB6ub/mc0BfBFSJ17WbIlbNcOxPPnzLepWmzVYqK+aM0hM7OvlpC80+ETAYX0bPqW+ffeSQlNxG9N/79McJ+g50+Xft1aNdyZAu3MK3ERvCxYWEiKAyprfakve9LEwHcfbl5yHtGoxwL5U1YaEsKHqtc3KeH2MYHLzP01HtIVPChof7psBVfOCIB++JbrOlJ1gRktYoWY+nptHoT3GPaMZu9hyb8Uw6OHVW8s9c3UBygc4nh81FcJ10LkEedEnz/WULV8zAKDgY0OPLhBLIaCLpIdzEM0EEIMQUHFjQjakMCkkdzITEaklB1C94141D1IRSH778i7mabGVEzbEacZndE1/SHI+7ZoNH5i6tXdv/zPDhdhQVmVPMUn0TDksi9kk/qVYt55C7Ru9t4nYQqgRYLbQ7fFXA7APOx3c6t5DpzsUfkxg9AchIRtUta3DhSrYaWyYAlFpxEMgIJigSlQuDFdLoXGPcxdS1aoRpwE1pdUkWRqAtosg0g5NpAEMOduF/K+p//bQAhn55pXh4geTslz8oj2ElO0mWBzwZ2dJUFhJKDHoaMi2RSOuzEYIYnf0xI6bhmYh5ns8pY44up873QWMbLHci+QSl2UWHb2NjSEiENUW9P5oceA/FJz89o3KMva/h6EOBkmHg+L3K3doKfCYNDlYJp0dIa/ZyBhMeZdpQvDW8662kAt9whXE6TxOhW6SDApAalrqbAEBgNkrK87nkKmPqHxHH1m2WuZLFAFbWZ0sNBMjs+ialx+DZiAB8U/0v3yFDG77yFpk9qNtVbs/xNDdSJgJuUNZ+Z+OzbsyU5HtJRAaXXiINpKAE2YSNNVgMWvI8RCXIOD4cINmkS6op2XcL+MzCEOpzOIWnSg5XNwLzI42g0F2kGHN3VioR8iIvu6/gA1L9sAhYLCUpcu7uru4/Msf5oqxrxi8Sf/z5JFoNN4eccW2pnXA
 KAYk9KME
 kXJZcANQLXQztX+hIwHvK7D9vXJ+q6FiKtcT5w/a63pf68Bo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no way for drivers leveraging dax_kmem to plumb through a
preferred auto-online policy - the system default policy is forced.

Add 'enum mmop' field to DAX device creation path to allow drivers
to specify an auto-online policy when using the kmem driver.

Current callers initialize online_type to mhp_get_default_online_type()
to retain backward compatibility and to make explicit to the drivers
what is actually happening underneath.

No functional changes to existing callers.

Cc:David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         |  3 +++
 drivers/dax/bus.h         |  2 ++
 drivers/dax/cxl.c         |  1 +
 drivers/dax/dax-private.h |  3 +++
 drivers/dax/hmem/hmem.c   |  1 +
 drivers/dax/kmem.c        | 13 +++++++++++--
 6 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c94c09622516..2c6140dc9382 100644
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
index cbbf64443098..f037cd8a2d51 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -3,6 +3,7 @@
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
 #include <linux/device.h>
+#include <linux/memory_hotplug.h>
 #include <linux/range.h>
 
 struct dev_dax;
@@ -24,6 +25,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	enum mmop online_type;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..d6fbec863361 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index c6ae27c982f4..734fb83f5eb4 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/memory_hotplug.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -77,6 +78,7 @@ struct dev_dax_range {
  * @dev: device core
  * @pgmap: pgmap for memmap setup / lifetime (driver owned)
  * @memmap_on_memory: allow kmem to put the memmap in the memory
+ * @online_type: MMOP_* online type for memory hotplug
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
@@ -91,6 +93,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	enum mmop online_type;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1cf7c2a0ee1c..acbc574ced93 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -36,6 +36,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 798f389df992..d4c34b2e3766 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -16,6 +16,11 @@
 #include "dax-private.h"
 #include "bus.h"
 
+/* Internal function exported only to kmem module */
+extern int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				       const char *resource_name,
+				       mhp_t mhp_flags, enum mmop online_type);
+
 /* Memory resource name used for add_memory_driver_managed(). */
 static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
@@ -49,6 +54,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
+	enum mmop online_type;
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
@@ -111,6 +117,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
+	online_type = dev_dax->online_type;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
@@ -151,8 +159,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
-- 
2.53.0


