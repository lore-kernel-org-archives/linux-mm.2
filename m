Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA0CCDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD366B00B0; Wed, 24 Jun 2026 10:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91416B00B2; Wed, 24 Jun 2026 10:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0416B00B3; Wed, 24 Jun 2026 10:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E06A6B00B0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB94C1403BB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:10 +0000 (UTC)
X-FDA: 84915111540.10.FA15EB6
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0495A10000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rhQWDjPh;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313089;
	b=4cIP/AD3Ae+XbyV7FSabXBe725cjiYKraDtpW/NJtopSIaHPNgVMZqq0DgqoHP/WLmVUiU
	5kKJDlGNIQiBQLuVtePzo0WgHrcS+iWPmXlc5WYvt1iCfeCaZTB+Cu15E1Ecz0bx4FO20H
	0oJePI3F0EQ56k0v0+oeVMpiUfp3MYU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnCbxW9XzGA16mXvyVagPlrUc6bIGxDm63u9PSaRfE8=;
	b=g9Fkb1FPg61os1S6Vi7BI2vcKVXkyrGcCTtHACDcUpiFMcjYoOrvEdn2zr3wDmIVGYk+18
	DGb1yFjdQWAlgjOXfZ1Z3CvyYvqvBcuE2PuNjUyuWYDms2iLIGFI3VFUu/9y1bwYhkMKyu
	YQdkYeGyJ36UN+q75ljCVpkZQQ8o9dQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rhQWDjPh;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-519eedc30a3so10733861cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313088; x=1782917888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fnCbxW9XzGA16mXvyVagPlrUc6bIGxDm63u9PSaRfE8=;
        b=rhQWDjPhpOGc9rQ4QIKomxf5B59GFu6D3XyQMS1RHhraBJ3dlHBxmFPQQTg5WB1NcH
         faa1h/UDKhpAFcE7R7RF96bUTLgAhmU7RWehUv6DFcBXP0vj0exAX/ZXOVfJp14ueLKm
         By0iG7ZkHs9Wc3Opk7rYTGZ+mB3Mtd6EhKOo96LA+hwcsQIJdZVCpMTLlJb/WGjGQahI
         6rkQQpCJPuu+8ED3yTJMCBFoLKf1fqihiGpg+ofKl9mBPHkuVD61tCzZNLR3k5hKESw6
         yJWqFslIoj99uIChcf6TUNbUbriQ4512lcXeuy4LUHxjI1ogMU5FaB9aVFPm/5e7gtQ7
         XUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313088; x=1782917888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fnCbxW9XzGA16mXvyVagPlrUc6bIGxDm63u9PSaRfE8=;
        b=pLs25VbUEkOHSq31+0vMK4mhj8CrA0jaQ+2c0lo2XFdRIJCPfpw9jvoupF6KCvO9LV
         TreEGJL7IOs74O7cwIlepfwfYZ3I1QsA4AdHajlyMqRZqs+bsNBj0mloAoWNEfoRitdo
         xatBjxNpYIsXhrUeETCDhFgO2gtrbXICAJA6uBfdzELGlsRn4V6URJjJ9aO8U0NIchxR
         x9pSKEKOq6x1366WDkmmkdfJF3zIQ2aLIz2q9dIhS0/WPaTt1hLztGRXgIEaOVWtlKXY
         eNLlUQ5MQoA794npQqiGO6XycEgIB3zTFu1K9ZnKlC78cEcvdr8gImoGeMccoop8Zj8E
         TWLQ==
X-Gm-Message-State: AOJu0YzFO0jtqg5Jwl/a1ltdAJ0RcGDpZutgZwfeeAH8JLCJt5ALHGO3
	5fyMtDaovjEtp+uu+QGuU3YeMdEaSLZn/7UgK5IqTYD1d67Wyx49LFHHOxUfG+gr4/jzxfpAGUb
	rm4VO
X-Gm-Gg: AfdE7cl5V7nDwfIt0/cJYUTu2Ytt8SxBOYTUgqpVn5no2uCZgF/RFbUQ2s22BvaHH8g
	B3s80LpQEuEd7dTiWNdN2KyQAhj8UvpxYhJINjFizr5Q0yA0w3VInhg4ErZYgluiDQX6UvQTii5
	yKdVVew5izM01DG7Wr9ZuU2zkHKyRwBKQF/y6tyQM/0j5Ca+ej5Q8fW6UBZ9aIkq7Eshiu7s5y+
	9yDQb0cefG2WeSXRTm4+z3JE+1kT4kaWj1CKp9VKbzwO9DPpVHe0GH5/Hcneh5xbUEDJvgvYMww
	7eGIXok3icldhF38dEX65RGIFrx3E475QoJgu95zKZ6KzukpZU5BGbhz8av8wzVsq/LlWs3KLvQ
	H5sbteH57lVfllgH4acPAMbi9Q0DVGvmRehSKf+AAgqGdoJFK5CbUWb6vXfG71AQEr+K49euUMe
	KuuNLn1wPqUEysQvgaM/wUoBe0Zjis1p4/Y5AzqYitf5Ot9VY+jJajJy/hFy2DWX4j0gtnVTLSU
	w==
X-Received: by 2002:a05:622a:248:b0:517:760d:48ea with SMTP id d75a77b69052e-51a61b2a185mr56005681cf.18.1782313087785;
        Wed, 24 Jun 2026 07:58:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:07 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 6/9] dax: plumb hotplug online_type through dax
Date: Wed, 24 Jun 2026 10:57:41 -0400
Message-ID: <20260624145744.3532049-7-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0495A10000A
X-Stat-Signature: onjq1dkbn4azz1rcsd45b5ffrqpyby8x
X-HE-Tag: 1782313088-494294
X-HE-Meta: U2FsdGVkX18tjWQ75x0yE6yl7LnBu+6wrH3Ek3ttLKfoF641UmetIjONB/9MuiOPvspGzdtR+UPfue++BMAevl1UuGhb94tTiJ/b7sS1ECbyC/OCGjYJAFoc/vgqGq2r9kRY5gumFKGmTbrUINCeQ4TeDlWnh763cCgodwE7Lb//FaEw02EkZe/Zd7Z1mGYkPL5RA3N8sa/uRfQAKaH89N79YIFjz+D4AMwMTyHFG5d6y+EiYH4OOb9Gbk2ot1xc8HCWPhtcKsKkO2sCTl5HCPx/LwMCwCLeWPJyVV6s6GMX8Z+Cb+7y2tHjOkZGf4/s3sbqbEiIITTDyF/34qxfFBDD+UnsbSXUAoCeVuZp/maGnBkNFcGT+HoqzzLRYyUbVKlo0uZAS8DkNdaW6Vm2kCQG/D8lqaLWVR+g9Crs7xP2uEuNPmNPkIpW1q1DaeXVZy3k+YFfyASyfLP8g+TS1m2JzvfA4eU3q/jPYeAKFeVcdH1u3DWO7GXt9W6OdRfv9F4nDsFRAXebP2lvoYmLkATGurslLxX1yDedKjqcZDhZhSzG6e0HWli+KOI3YkrjstRp1EvV9PhdJj5AZL5/6AXKV7Lxqpt38w3YK3LdgFvdAHhkPS6ziv/HewFUktJJLmIQ80DATSeaUDIYvXKh3CWrUzHqx9saeiBAcagtqLGOEgsPr/DF/bNp9naNf7zoYoS1i561ZA7qAKiKEkqZdGGSzkjftKyDFQoLoN1ZyIuYhhx0oVne4FgKCs4s6I6ZqVS9EIEJS5MobixL9P7IPuxLJ7fOHlPbE4EDZ2SmF4HWyA+jNWyzRyV07tnSjdWVgmfVgL9KO/XOIibfy6vIjTQXWlmMikkrYNE9bhe1I8aVTKr/+DShwQJGEgywMVXQmmNknrYNwhLlDZPHFZucoUJwjTN3lmbB+xOE+3YulSO87L+/ApcIkQJDR6OVsQF49OitxzvnKhpOkhW8MF6
 1UAfLVzu
 2+p5ud6WWMBMSXF6KsYRAz35NE1Mj3NAc0sVMalYOORF6ePRA+gPs1/uS4Q97VbsQBSa0ArepVut9n5d/ZOhGZMp8aOParBl0mKdpxBao46nMG/RN4c+vG/gorgD0fdAf/TbaxdEitXQfdevn3NPjM4fN0oN4Fsen7Iv0vJcqUjioxaFPZGDALtI6FOg8mqSUvQIsnKXkth981sEiUSRiGqYPLBKq0voAzZY6KJMptbNb1Uvs+1E9Y9lysB4uXEj3hWWWoTMX3xf+Xr1abu+hZiTgynp++Wi7so9kPD1GhZRb3QqeCarIHYpS9+avfDI59o96M9NmuFUCUaDsPivvRu2TMQiw4jaRRYVwKJvMNn02pLPhLmnfZVFysg==
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
index 5909171a4428..f3c9dae5de6b 100644
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
+	enum mmop online_type;
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
index 81e4af49e39c..ccd77965fe3e 100644
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
+	enum mmop online_type;
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
2.54.0


