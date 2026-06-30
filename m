Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A27C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EA56B00B0; Tue, 30 Jun 2026 17:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0BF6B00B1; Tue, 30 Jun 2026 17:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A606B00B2; Tue, 30 Jun 2026 17:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42D456B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC7DEC0426
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:03 +0000 (UTC)
X-FDA: 84937844166.18.0476734
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB54020006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rmCGcl0H;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854341;
	b=e1J8avbcGhUJFjKuIHBdw4Oj26npoihVhMrlusB7EJ7BrXUNxBbEIZRqsOv0aRRmH5vx5I
	51pytnP7fVQ0u2d2lI6fGCtPmpG9yXGaDvgb8b1MPpXhxwztJOd+qxFgGw45BYHOjv42WV
	mAKdaN37edUaqOuskKp/BExHmLqK0Pk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IP2YOjgAZGfrsS4LZXJr3sh6H3JBdzwvDSe5f7yamI=;
	b=fQwBb5E4n6xw4oe882sTshB18Io23gQ+im//G+Gplo+U3nzkNFg7RT7wsg6jKg7opByiEi
	QZU6WIsBM9vtmVA+yU4ZmhGmcN2H0l5fHukXRtrg4p+CtX1Qhkizx8xVBHgBu/0GIx83z2
	VUEgrHqmTQnYFD0gYnBbDEih4k4dmk0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rmCGcl0H;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-920f33347f5so444288285a.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854341; x=1783459141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IP2YOjgAZGfrsS4LZXJr3sh6H3JBdzwvDSe5f7yamI=;
        b=rmCGcl0H0xkt6D4vpS8CFO2GBQURatdFUt7EgBqCCiNGHWMR6eZjqy1CCIW+H6TNwU
         8ZuqzU7I9mdoM1NChZTwzVDu97CFDTEwbYlH84EcIUK5eReWvASg/+oSElv8PFQEa/y3
         33WAxnDnWxEWxzSJ0ObO8WQ0LLM/64rQUNtVGTkhZWrw87fUpZB/1UyvMzKXrC87snel
         sypw7iXKiTAdnUlNgysgYZHsZyMbKakFyyoqFrba/2e88wvV1IvSWE4sAnrCmx4FI59U
         OEMKa2s/yCYYEtjbjy6vgMRDfopYe6Tsf7SAPa3C3HL0etVJR2q4VO9YrxXRZUnbMops
         nUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854341; x=1783459141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1IP2YOjgAZGfrsS4LZXJr3sh6H3JBdzwvDSe5f7yamI=;
        b=hQ8zeslLPmqZ20CUvUQJEmhInHlHp5KBKRN7Fdmuzu1wCBkKlwJwymfbct6CzDcqv6
         SV4lrOKdhN+Tvo1JaPGVs+ktXLz1q2620G18gRj1yg5wTKSZqLSyBY0AzlFoMdeJG09w
         SKay1YpTMBGvi4LM9VmV++O1Pn2GHjVvvGwTz9gGh8xFupoFAhSSYrCEo7rEgryL7aBt
         Lw19DdmrJyJfU9aAvHctUANHD+c1zFSpckp8swtGVj+WKfQjFtM6igtGvmnNtWCFgB+/
         jKIzrhsp/6RnbBjM5xVQJOJcOtD74WiwiPXPL8qX/+d5Q3bfKJQuVbf6WhF0c3CpsTfp
         gOfw==
X-Gm-Message-State: AOJu0YyrPKvhtVyY30uvuTBGM6DLq73MHH+VeIkQyPFfEHU6WKNFitDc
	Ig82B2m8zORdud6//y3p7bGFCTDt0AkJySbogne+l7Wj7XfNKQn48PxsThA1qiIsBe4queNSSO9
	7Qm+y
X-Gm-Gg: AfdE7clvGzMlUoytmCxaRuviJIyLR2udjWYb2pmOb8UdJTwCWE6X9P41rJRdefspA+H
	mozb98Q9ZCH0bwQqA+8ZeK0M5x2xo++tzqUUZ4Kg0KbZrW3XynDJ97INoZ1Yd0vxO//NTQl1IWF
	xtf2hmLhFfsZzzyh5lJuzLIr3d1QwU39MA8hJIJ/frjpLK2/Whq5GMXPNnWwQkzv6lwfDk4G0Z1
	vPIkdU8h/YF3jLXokR+zLUez0CDYYQzX7ccCiexY/0lR6pCParfbLrX2FKC6LNPCe51ZJQ0b6h8
	x9kbSNdUpV0+wPETRlbIQGuhHq6J5J7ePpCTFbNQ35FI3u2PRh4e+tl/h7ODbJV/gVI4iFM3rjG
	QDV4GU2DLp1c7BKPb6hQo12i2n4mW5XFyrQteBQi/e5/CErTalSTOR8TjL7OYF4okQEYk7F3W34
	mcJqEu463eJRPh3cGAA1oKsxSSuykXWAeX3gzjaoUEmEstwYMB4GsylodUPg8WSqvTnJ3BOZTlM
	f2ksBfqPMul
X-Received: by 2002:a05:620a:17a5:b0:92b:6805:eae5 with SMTP id af79cd13be357-92e6d92926dmr414099985a.66.1782854340864;
        Tue, 30 Jun 2026 14:19:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:00 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Date: Tue, 30 Jun 2026 17:18:39 -0400
Message-ID: <20260630211842.2252800-8-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB54020006
X-Rspam-User: 
X-Stat-Signature: 3w4zuw1zcz8c4cx8zxfukmwuurtqw6um
X-HE-Tag: 1782854341-3499
X-HE-Meta: U2FsdGVkX19+PPqH2a2IliB4rKMUPEKBozElQc41IXhWtcvywEaqsDJFX961OfNakNgTGhHZrfeo64Y55oyRlkQfv+jdX2DbsTEnswwDrK6e/57BZeMzvtoiLE68L/ggq5uDBUZdslOeGveizxxMYjRwedreyqwweal40hrCE4lM3RF1QxTE+XEq6zGsUp862g+p7Fh6feWGtmmNxEKfE211UqidS8yQXDbSw2vpn5b0lXnVM+Mv9h6uUODvTCbxpMC5YQg98PdTv0zb52cF6/ZglJhWYjIIS1AHMiUiIDrOE1cvsBVHjkSeIv6Re4GVlH1/dVglr3sSMFDhT/9sNLqum9Zxna+I9h78o91I74k5xMr6PhezGdMxnwsLBkqaTnrc3V9zNP2WhKudXBjIsVfyRAZ2fPOnavCfcwRgRJiOqrwOJChy7LNG3eegrsBGS0Jn8XIbD7zhvktMeSOQ8+JaZbL5Qj0blB9qvpwHxZyM2XgyBDje5gHsjtY5O3vnBLlxVRpUoi2pwgt+Qkfy8cSlGwKDV3Nd7op8lqM+cXJeM0qL92M+KLJ9c3ZtyRm81xsNUQasNJrzWgRgLTf0u4N3SC+Vxk04XOFSQUIxmpBezbkUG/sdGQ4D/JGnAvp05NQvWfWTLzW3ttPVrnxaeOyUOLZHzS9fKfzC/4tOai0Ue0/FNFg4Vjj0aywJAcSIiZgTVdftcsKkNbVVCceZg6Uz2cNGWhOFXO9ugmrlAjG7VyGB0m+BwNbThOldnFA9Qjq6q/XISX4jr/f69cTj2mpQ6KRwlyGhSoQimqLA1Gm5yfyqnRraZpHdB5yTucfRqLOdNsGdccMCeKVm2xRHZ8lzmjG0m3YXNVcOvL9hsrXmw6DTsRfRu6yin1i5HyJk9CGS2PrUzpGapxdghl1OavMPTjLoNV3UpkGOECy+x1yvn+QJJljN7ho38ar4jZgKLq98kTQfzAZ6595BrW1
 uHQVjYJp
 S964UJJhBlva17xldYKYYrpozS8dHruYXaXAa/9oCGztSyirc/BfncAePqKBLWvsYFfqHT4+KqFcehOnj/ESQGRekYwQrC//XP9MKtlUcJ8XCEHrwmIvI2oS3u47bnlGWs1pWlgj927OBLLMjh1dgWgX7kcjE/Ki5NylsxT6Ma4dbLttKXH834r09yYE35LeJ/9TzZWkDNNXPQFvmbKE2q3QFFclzOKy8rqeYhGOm/3Qs10EGkUOaGuUO/baRxz8zW8oHom1GPQ5rmslNdR7kUA936AuvV5oCd65Mqbntv+5mqd2ZCQwX05YKfmlYrYBfby6uZB/Q9XToSfIvrhX5JeCh21+R24GJuRLsYb63OLJfXzk4/3UvQ3tqqp2QCi/74GZi
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

Capturing the system default would otherwise break the ABI, because
the system default can change - but we would be statically assigning
the value at device creation time.

To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
the current behavior, while providing a clean way to override it.

No behavioural change for existing callers (still the system default).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         |  3 +++
 drivers/dax/bus.h         |  9 +++++++++
 drivers/dax/cxl.c         |  1 +
 drivers/dax/dax-private.h |  4 ++++
 drivers/dax/hmem/hmem.c   |  1 +
 drivers/dax/kmem.c        | 11 +++++++++--
 drivers/dax/pmem.c        |  1 +
 7 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 492573b47f66..4a03b323b003 100644
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
@@ -394,6 +395,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
 			.size = 0,
 			.id = -1,
 			.memmap_on_memory = false,
+			.online_type = DAX_ONLINE_DEFAULT,
 		};
 		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
 
@@ -1527,6 +1529,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->online_type = data->online_type;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 5909171a4428..3bc76bc0a145 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -3,6 +3,7 @@
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
 #include <linux/device.h>
+#include <linux/memory_hotplug.h>
 #include <linux/platform_device.h>
 #include <linux/range.h>
 #include <linux/workqueue.h>
@@ -16,6 +17,13 @@ struct dax_region;
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
 
+/*
+ * online_type sentinel: the device was created without an explicit online
+ * policy, so the system default is resolved when the kmem driver binds,
+ * (not at device-creation time, which would freeze a stale policy).
+ */
+#define DAX_ONLINE_DEFAULT	(-1)
+
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
 		unsigned long flags);
@@ -26,6 +34,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	int online_type;	/* enum mmop, or DAX_ONLINE_DEFAULT sentinel */
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 3ab39b77843d..1a7ec6212213 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.online_type = DAX_ONLINE_DEFAULT,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 81e4af49e39c..902e922dc4e4 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/memory_hotplug.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -79,6 +80,8 @@ struct dev_dax_range {
  * @dev: device core
  * @pgmap: pgmap for memmap setup / lifetime (driver owned)
  * @memmap_on_memory: allow kmem to put the memmap in the memory
+ * @online_type: MMOP_* online type for memory hotplug, or DAX_ONLINE_DEFAULT
+ *		 to resolve the system default policy when kmem binds
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
@@ -95,6 +98,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	int online_type;	/* enum mmop, or DAX_ONLINE_DEFAULT sentinel */
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index af21f66bf872..2de3bc925172 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -37,6 +37,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 		.memmap_on_memory = false,
+		.online_type = DAX_ONLINE_DEFAULT,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 592171ec10f4..0a184c0878dd 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -72,6 +72,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	int i, rc, mapped = 0;
 	mhp_t mhp_flags;
 	int numa_node;
+	int online_type;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
 
 	/*
@@ -132,6 +133,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
+	/* Resolve system default at bind time in case it changed */
+	online_type = dev_dax->online_type;
+	if (online_type == DAX_ONLINE_DEFAULT)
+		online_type = mhp_get_default_online_type();
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
@@ -172,8 +178,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
index bee93066a849..e7adace69195 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 		.pgmap = &pgmap,
 		.size = range_len(&range),
 		.memmap_on_memory = false,
+		.online_type = DAX_ONLINE_DEFAULT,
 	};
 
 	return devm_create_dev_dax(&data);
-- 
2.53.0-Meta


