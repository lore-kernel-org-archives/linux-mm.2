Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E14FCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575B26B009B; Fri,  5 Jun 2026 17:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CCD6B009D; Fri,  5 Jun 2026 17:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6EE6B009E; Fri,  5 Jun 2026 17:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 262AF6B009B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE178C17A0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:30 +0000 (UTC)
X-FDA: 84847125300.21.6B62980
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id DE5BDC000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=US+CHoN3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2vGSHo9hdkHiErFpk6jdcKlA83TnjxiiQnZVrYQBSY=;
	b=FwSAoEP5cmR7QsaCCuqAUAL+skm7z72Mj+jxBVE+r7flnKzC+PTuGsj8bEL/J45PReVrEH
	/b15R/yWomtZDTXYDCimuNLQXQY9xx2I9USna+s1opma/5EbZO9+MxLznDUXwB+HQvuVxc
	4wuXfhIdJP26yv3af3AoT2Yqlt+QxI0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=US+CHoN3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694368;
	b=abSWx+o80Li+pkTPoDVWHmp6sq+FwuzTLeJ9YsqvZSgVT2GipVwsJATy844A8m6hCPGaqd
	wAEDqiL+r375ay/0M9sUPFSbL1cjtGobLy3pJ4Ycevah/ULI8gPpZP2D5MKDC6CYaCEB+H
	0g2wC1PBiOHUVAeIvSLEAJBaP5MfxSM=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51778069c31so18155711cf.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694368; x=1781299168; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2vGSHo9hdkHiErFpk6jdcKlA83TnjxiiQnZVrYQBSY=;
        b=US+CHoN3sXJsv3xcSy4eY0gyaV0fCSvDdi7+zeXspTuIQruh6ZVxmfQneC3k6V2LkL
         pplBC5Lt1l3GVoUgvTx3kOoyRN3EkBq8o39ysHdJ14SSOo86hYRBPQoRLD5gJMGBa7Mu
         Q+YlbRjUoMAIswNSHiB+POrJjOKnVCfG8bceVEcQ8jdDeAHpjOEHwk1LNWMjAhHlurKV
         exR/xTn53KXY06OS72LHAPpXbNlr/ePb+cQwS6Eve/+PbU5WY2TR+dK3zch1qo8I2jgZ
         QL4jptgM9Yqu4zB353c/LJOp5hls4UCtNACRDiNpLeRNB+uqdNF2Dl7xhZgO6Jmd2Dwk
         QylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694368; x=1781299168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P2vGSHo9hdkHiErFpk6jdcKlA83TnjxiiQnZVrYQBSY=;
        b=FN/5LrWlpijIUQrpaZnDshvzLGzsL618B12jgJRc87FDSXtu6ZmHk4IUGc8qMCZfaC
         C0RBe9+ZHhfbzsvue7tJsBn+/IOK0mMcAELeW6qEoUG2bU7auvH1m5Q3YxD3f1h/7NA1
         ypljdB/EuISK48998RvM3jG5+TOQhHT7UUuWnj7h7O0u2LUBjFNCgTPP8IIzNNaQwLC9
         z16ETzlRP8j1eJqOqwurMHuZx0NdLWwr86N8TEsxxfENEjKcEtHlQKDYYZ0JJkn70oon
         D2d393PDiL6lR2mxLZ9b7gsNal0wG9b8SIEuknjB3NyqtZeXSebdDmYnQDLr7GR0ic1f
         MmAw==
X-Gm-Message-State: AOJu0Yy/S3v6W5QMTvJsxNY+IlAcytqOLsdOngjh3swljgSx6xgt8KMj
	xllUPEMyGkdvBD15gworCpxBSiBaLsVXMdRf3qGAoaufb+QSUWJa3n19yzwL3zEjaCqe6vNee5t
	AdrMUfGjYGg==
X-Gm-Gg: Acq92OHAWNFNjAMMQ6WIQD0DRASsBPi4Xq/TwQFWOYCfe6mR2tmZRxD32zAl5WqZ8xC
	wVf/9RYtvUeCLtr5Gl183JrdvlaeZFvADjgN57/21LGb/1vQdJWSQgM1xDyWzVtSILpzsBm34pc
	qMB1V2BBbJeYpBABY6qEhbxb7RmeGUA41wcLbJ4sbIDVkfx9w9vNKhsEt94eWEh0wkWm9BH7IX4
	TnpkVtBxPdhft8GX8JPvDqJD0joAoX9TkxfyiYZsUreSyDPE3GS2CQA4QrVDwkPr0mRJEzUPZHZ
	rTnxyjZz52WTLfyeIwmT1C/g0t0EdCsg2T628skTjSDjSL/fzA7ZRAckvRcVPUAL3FIpeuWyCRA
	7uizdt3+Bx1nYVx69kq8tWNACgszljknn5HrtNK/AUS5uFsLDuzaE6+sJ6lPtMe63BCC4spulRK
	KdY3qgcCuITfbMoCmVKv9pfmLV5A9v24BHyI8oAFG7VNNIdJ8GMhiBlTYO5U2B27yTBrW9dNQa3
	laSiaisUeC7V6pyBlcx8FCn3ijN0E275Q==
X-Received: by 2002:a05:622a:514:b0:50f:6415:1eb4 with SMTP id d75a77b69052e-51795bbf29bmr79531471cf.49.1780694367941;
        Fri, 05 Jun 2026 14:19:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 6/9] dax: plumb hotplug online_type through dax
Date: Fri,  5 Jun 2026 22:19:08 +0100
Message-ID: <20260605211911.2160954-7-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE5BDC000F
X-Rspam-User: 
X-Stat-Signature: i7uphd489iphxz1pkzkukpfa8p9gym81
X-Rspamd-Server: rspam09
X-HE-Tag: 1780694368-366706
X-HE-Meta: U2FsdGVkX18szzAyEb88pr/zQhDD2rkGXIlTzgIGy9Z4pOV/SGT2tx7S3sjzYLQZ2VOe/X0CGcu4W4vyZadKIemifwB3BIcdqho4QmNF/neV68YYjE+j0BGKYQSFCVK7baw0FI7PWYpmPyD72hLif+eYK1ljza4EEFnJMiK3y3eUBBUqnubH19O5nJ1B3/PqG9EUx3wsXhEqWOIU9NfE1tMmr4m+8fNlQCAgCUEwE4GuM6BeuCS6DmrZeJ10jrIxcN08X20Vl9F3um4gncFbbqd46/5igS4FI03ZOK6BqTDhcmnGa3flKSqNJzYY7N6Q6GgeMyNr2VcY2FZXNtzCX1BTs5DlOiLi9yst6DiRwd7MlsdyjgoxH7ePLJ9uC6uGsg6ENpUH+wxA/DvmMZfhYWqpvIauAZ/mLMiVrrLwBwEJCBgj7FIjGHlDnXxDA1hCl7hCSPQ4FUWDpUzEajZyIjcahtXFuOSxD5kbB8aSL0GnT9VnSLZAK7oVQkEH2afj/Ar1OF0aCU+5dR74JVuf0HDGRsgLfFTCb8BChC0gfd+gE+UE586a9+2oo5rf/HvveDHflDaQwbP6qEegyztwFiA+22fesAoGZKrvaFbwzUpPjtNd5bOjMaUzPB56PekG+mgOIVPSrmNGPrFJ3KQCuHEGKI07wHZXQoFdGpu493TfoHIHEktOxS7LMyJ/WSsJqIg5kq24li2wiOSQ+Z+W0nDmu96Y9vbfF1oWcyB1XOXv4a625fRmnPxTjW7ohCaoe/OWGSluTobqE9+HsELqbciH2JlKntsAC9q+YVK6XfLyc1/QrzZTZQ20oamjuijKWd5+YHq4bV9EhduH58KilQn6RVSR4GWPC33vdjs7DDk/2tvMnL4e/ZGFu0ggTADTE8E2OSA+b9PZHVefPSXk1HzF7jdnC0vpIsSp1EEVPk+YlglmqFe9EAv27Fj+4sipyZVIKuN3C5+o+UUaAMy
 RBN9FaPx
 JRd4JmB3N44tI4vAeUJdsOJ0RjAHBgheBvRX0Xk0MQP0wL4M+wvuPUZNyJnXvbcjfqJbHXH6iX5eTPVwQBztcLwzZPWVRHcKG03fN0OZMr7bDJIdb9F1H6rGLoBSmbqoJW4UyVTzqweE/gzQkHTOngS9iIBflSv4hYlsC5gqVNuYDfjMcJBaH4WOLrpzcoxGYzxSiQ/R+9V/gshkOzDS+c3tw88PduzUWgrbmVBgIphvLDYqtkUBUzu6ReKXED1CxFUppvMF9USbXyZ2uVjzG0YiFZoqr+a6KsTmGsuPjqs10MRJ4WXk9bWPZDzh3RB66IXAhi+RGC9/mj/Ronbd3tvZsM/II4jPtBeMFLyNe94LAcebR5yoNwMDAjg==
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

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         | 3 +++
 drivers/dax/bus.h         | 2 ++
 drivers/dax/cxl.c         | 1 +
 drivers/dax/dax-private.h | 3 +++
 drivers/dax/hmem/hmem.c   | 1 +
 drivers/dax/kmem.c        | 5 +++--
 drivers/dax/pmem.c        | 1 +
 7 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 492573b47f66..6611fe399f59 100644
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
+			.online_type = mhp_get_default_online_type(),
 		};
 		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
 
@@ -1527,6 +1529,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->online_type = data->online_type;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 5909171a4428..c53a9427f8e4 100644
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
@@ -26,6 +27,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	enum mmop online_type;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 3ab39b77843d..0eaef700bb2a 100644
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
index 81e4af49e39c..0787325bc8dd 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/memory_hotplug.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -79,6 +80,7 @@ struct dev_dax_range {
  * @dev: device core
  * @pgmap: pgmap for memmap setup / lifetime (driver owned)
  * @memmap_on_memory: allow kmem to put the memmap in the memory
+ * @online_type: MMOP_* online type for memory hotplug
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
@@ -95,6 +97,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	enum mmop online_type;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index af21f66bf872..0ef6e9ae660d 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -37,6 +37,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 592171ec10f4..41ccb618a146 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -172,8 +172,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				dev_dax->online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..a5f987814da5 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 		.pgmap = &pgmap,
 		.size = range_len(&range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return devm_create_dev_dax(&data);
-- 
2.54.0


