Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F8ED73E89
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BBE6B0092; Thu, 29 Jan 2026 16:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F9A6B0093; Thu, 29 Jan 2026 16:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9BB46B0095; Thu, 29 Jan 2026 16:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6DE26B0092
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:05:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F4EBC170C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:00 +0000 (UTC)
X-FDA: 84386231160.26.1FE6E80
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id C3E5540011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:04:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WYvVSsa/";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alwv4SGOFS63mWmVzbrgd9Xf0He8PRBJ686/YkdtOI4=;
	b=nBlDZkAxm6B6J0CrjXdqiU1nwindHKeCji1Qltks/JkSjn+b+KZNAo0x1wYYdTOr6L77B0
	8YaT2z+WMlZphKcd3k3Qum7sOmZhi0v3NSLzWG/d46CCdRZuyKeRf9dPUe5rBbPAPsB1nm
	7dO7gJqG/fP2B1gyQ0f6KsVzEGA0biM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WYvVSsa/";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720698; a=rsa-sha256;
	cv=none;
	b=Eg75lSrvJsBjbxeP5hPeNRW9/lt3DQYoDxWmEBMf+nUim12P1e8xQm05AFRoGkg0qU8tnU
	8NChXxczuQ+TwzxbMBmxW4dNrfmHjtdXcdSxmsBxBQwg9UALyBOT4CzXDNhL0fRjq1EbRA
	l6yMUgX41qdiLevnawsLaQh6GidgX4k=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c5349ba802so140093185a.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720697; x=1770325497; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alwv4SGOFS63mWmVzbrgd9Xf0He8PRBJ686/YkdtOI4=;
        b=WYvVSsa/y/TJXYVTzWCXiQ13Z4fAfeAfaj/qEU5qODCCf65qFLdx7vdx06vq94QrlL
         JxrIdkPyOd2HqRIMJBvYw4wxztxY+hDhl4wCV3NqEzCjAKukEWSjdCngq9JOXmAYjra1
         0xnMw1zNJr+Vte9coiEqN2THJd9cFS0ILk0tXfs0iSizY+iXCsogOlsZP+E6MypX1Utv
         WxjL/tByL0SvnVh59nHNdvF/ziFIotU2LyAk6Xuozt4YtfD1I0e8MZS51pLtg6HOP8TJ
         NLLiFzKZ2/MAUK0W6nnluLL+GKhCn8ZOAWQCMdfS4l3Q855DTS6u8zWIx1VnoBKDN3F0
         miKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720697; x=1770325497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=alwv4SGOFS63mWmVzbrgd9Xf0He8PRBJ686/YkdtOI4=;
        b=EYn8ZUr2fAeZlkypaYIo2pFwSQOWNfp5hAaMdRhW8pig+9DaEc8P3zO0/DfiDA/rIq
         XtkPVdN7EUQ9wO08DCU7lDfKhtTeUcxFNaKnCu9d0cqTs4JYaLmIrK2KkhH+/K+tFMm0
         8t+ZRMm3oDGrNI+XnRlIvgCeuLk80uiA8vrwTwCczm+d33pFmyouxnhv73ShEpVV+EhX
         5uWKb1W0KATh3UFO8/UpS97N+DizvdibQ2g+VwqKCLt4I5Q5AjdH9ZQJPauTryMuCPTm
         XWveMNxZNS1fYiqu/+iuLKQbU4u5dP+xlng84mOUzTP64gZhc88zckl9Wn4WTsJ5zm6s
         3saA==
X-Gm-Message-State: AOJu0YxgmPaKB4KnNocEV/0oc3daifLESrTwpsAodOjsjM1jX6T7O6IP
	BdKCK2esgZ+Wa3tNwIH3mGunTNttXaDpwwOU0ztqRKmcXnn3AjuknJQdva/JFwvjPK63qQFIDF7
	nBg5FYK4=
X-Gm-Gg: AZuq6aKGsFTl6LbGiZVa4/OyldQJCeywQUXH49PSy+QNcbBXAmy/5tr8PaLw+JRWIZI
	P/L5btewuDdGLgcKI78h8Ql17/i57X/kJAUdlTbY/UJVQg56oP0oSurZGTtSsdOqjZevWJelzXI
	xcC7k/0Jur3XR82mRhrYIVg1xtL4SKouUPiGAR77HZP0EQ1H+TF6Dbyqi3L2+gxB7MxkVdJ63Vb
	YSaYvtWpzlNuqHkFnisGwV3dU6GeINSLLv3peYFNW4G/bx/rlRVxfmPb4FxzjAB7W5O53GT+KQP
	jGwovR3TOCOX500iBjq83FniPJbsHTzJlbiFFaqWSfcwHZAHI7ny5HY58IwfWCyOyXF18wTNBUH
	7chRea9mRjraP7mlm/p0OsArkTaV6e4K9/SVb+WjNU4BsqjbAahQi0ZfTlaxo/BB2deK4hx+OLN
	fkLjaE+ERAvsgcUHvLXU0uh0wgEowMsNZp5qiu49H5x8v9utUvmO5WWS609n2HfoFlANZfzSBJG
	0c=
X-Received: by 2002:a05:620a:254e:b0:8c2:faed:ded3 with SMTP id af79cd13be357-8c9eb349005mr136193485a.89.1769720697462;
        Thu, 29 Jan 2026 13:04:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:57 -0800 (PST)
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
Subject: [PATCH 4/9] drivers/cxl,dax: add dax driver mode selection for dax regions
Date: Thu, 29 Jan 2026 16:04:37 -0500
Message-ID: <20260129210442.3951412-5-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C3E5540011
X-Stat-Signature: fyarrftgx8ebznw51moun88hc644nfw6
X-Rspam-User: 
X-HE-Tag: 1769720698-447203
X-HE-Meta: U2FsdGVkX1+Zc0CzAve+O4j6S4MX0ZXou+nJZWseTlM1263lgAqMloQLy9KaxG+rhAwws9B16coQjD3zygdYep7sgzlbITcr0QK+uXUu4jv260i3Nu6VKxsRchemJz09KVM1o30LMD8jDYjJLsqs312u/Eth8/YONLztISLVMqojzAANTJbXgXxXg4y6skr+a9fi72AmQ2rve4WuTy2KMIvo+YrkitFDpWNkQforKV6p4VqcXX/Fd79Qp56HvawNqPIfZwnaFEfKnyYERCLtnJ4ksy1f3YpvC8oajMoNiJW2dpWzXVLD8wyMkVRYPtifKMiGUzZ6WDftmwWYg31fQ8lZCKOYkhBLqqfR0+ZzhuqIWA+pDubpgLyuZ3ZbMFFHRSnEopsEqlZALGGpmE+lehQ/+SlFRrjEV+6aHUBZzAyEjLoFCZT5RdhMDvQoE0FoTvfihnWOaNNJQi+6iB1Sjj+4z2xxOJUS1D9IK0UAYIdLO7HQT4j/XTfBz8WzlzBb0gvTtQEhujmTMTlX8wXHkW09y0SRrklCLlK1F4rDsl3enCjhwMmz5bQRjb0mNIjsUYGPzxS4E0rRA34ilyK13cOjeRsy91v2lwpwInfL4d4IZeF/C5ixZ18ZwedCg7LJhq83/HLy48yD9Pe2zAw3yF2vJolHS7sK1y19HXR6mC3v9J8egYmObuoWONb8zEgn7vQHKGdHhl/WJRSmpZ/w6DRq5FSTnACAH8vD/qKmPvjh5BDE9dSfsQHCnsS0LjU/i+gTKiUmimxacYLHpRDOfj5+WT4T/G60g3K7/0F65bnBJGN7/bebMNRU6an3KHprUFZd9D6xMcCUr0U6MdYrkoGXUC6qyVzhH2lDfgwumQauysnW3XuuAFvWxdb7rOuqHpi5V2nYW8ifmfqP2w51/lHBnSefsZxQe+0idoY1kN+sRRYvm1eufEOkh6kIObg9hI3WX6eVXHWzyXCITPp
 IH+LCkI5
 WCcUow8HOaPH4xoSRZvVEYjQ3KbPtEofD1I51LaPWQr6oOCs8ZJJHfiuI3Rp0fZEF54ft4WOQeYAU/t3CGu8frOFOd3f7ddlx7/n+h+JTnTsF2rVA8q/PTwMX/+/IV5rvd9vBZzHgMVWQE62JMKhaBeKWdt0GAG1gL149Y2pP6/HavD6sePbqG1A5X0XIHAM3mSOiE08SavObsK/beOYw+Y4Ju2w3of3w1/L8CNPxJ3M8fci45e11i4AVw+ZqYX3Dm5nTeFdg0dPCyP8Ini2ujMxsRxlinj2XEz+T02uQojUJ8p9fqeFB35EKhvARrBVM7L5FKRDdHZpVlFzuV2T0DqgKQO36zy4jghRXVaZ1urp18VEenq08x5U5CIF7b7BInKIn62mJbgyj8ms=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CXL regions may wish not to auto-configure their memory as dax kmem,
but the current plumbing defaults all cxl-created dax devices to the
kmem driver.  This exposes them to hotplug policy, even if the user
intends to use the memory as a dax device.

Add plumbing to allow CXL drivers to select whether a DAX region should
default to kmem (DAXDRV_KMEM_TYPE) or device (DAXDRV_DEVICE_TYPE).

Add a 'dax_driver' field to struct cxl_dax_region and update
devm_cxl_add_dax_region() to take a dax_driver_type parameter.

In drivers/dax/cxl.c, the IORESOURCE_DAX_KMEM flag used by dax driver
matching code is now set conditionally based on dax_region->dax_driver.

Exports `enum dax_driver_type` to linux/dax.h for use in the cxl driver.

All current callers pass DAXDRV_KMEM_TYPE for backward compatibility.

Cc: John Groves <john@jagalactic.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/core.h   | 1 +
 drivers/cxl/core/region.c | 6 ++++--
 drivers/cxl/cxl.h         | 2 ++
 drivers/dax/bus.h         | 6 +-----
 drivers/dax/cxl.c         | 6 +++++-
 include/linux/dax.h       | 5 +++++
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1fb66132b777..dd987ef2def5 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -6,6 +6,7 @@
 
 #include <cxl/mailbox.h>
 #include <linux/rwsem.h>
+#include <linux/dax.h>
 
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index eef5d5fe3f95..e4097c464ed3 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3450,7 +3450,8 @@ static void cxlr_dax_unregister(void *_cxlr_dax)
 	device_unregister(&cxlr_dax->dev);
 }
 
-static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
+static int devm_cxl_add_dax_region(struct cxl_region *cxlr,
+				   enum dax_driver_type dax_driver)
 {
 	struct cxl_dax_region *cxlr_dax;
 	struct device *dev;
@@ -3461,6 +3462,7 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 		return PTR_ERR(cxlr_dax);
 
 	cxlr_dax->online_type = mhp_get_default_online_type();
+	cxlr_dax->dax_driver = dax_driver;
 	dev = &cxlr_dax->dev;
 	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
 	if (rc)
@@ -3994,7 +3996,7 @@ static int cxl_region_probe(struct device *dev)
 					p->res->start, p->res->end, cxlr,
 					is_system_ram) > 0)
 			return 0;
-		return devm_cxl_add_dax_region(cxlr);
+		return devm_cxl_add_dax_region(cxlr, DAXDRV_KMEM_TYPE);
 	default:
 		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
 			cxlr->mode);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 07d57d13f4c7..c06a239c0008 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -12,6 +12,7 @@
 #include <linux/node.h>
 #include <linux/io.h>
 #include <linux/range.h>
+#include <linux/dax.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
 
@@ -592,6 +593,7 @@ struct cxl_dax_region {
 	struct cxl_region *cxlr;
 	struct range hpa_range;
 	int online_type; /* MMOP_ value for kmem driver */
+	enum dax_driver_type dax_driver;
 };
 
 /**
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 4ac92a4edfe7..9144593b4029 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
+#include <linux/dax.h>
 #include <linux/device.h>
 #include <linux/range.h>
 
@@ -29,11 +30,6 @@ struct dev_dax_data {
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
 
-enum dax_driver_type {
-	DAXDRV_KMEM_TYPE,
-	DAXDRV_DEVICE_TYPE,
-};
-
 struct dax_device_driver {
 	struct device_driver drv;
 	struct list_head ids;
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 856a0cd24f3b..b13ecc2f9806 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -11,14 +11,18 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 	int nid = phys_to_target_node(cxlr_dax->hpa_range.start);
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
+	unsigned long flags = 0;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
 
+	if (cxlr_dax->dax_driver == DAXDRV_KMEM_TYPE)
+		flags |= IORESOURCE_DAX_KMEM;
+
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
 
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, IORESOURCE_DAX_KMEM);
+				      PMD_SIZE, flags);
 	if (!dax_region)
 		return -ENOMEM;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index bf103f317cac..e62f92d0ace1 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -19,6 +19,11 @@ enum dax_access_mode {
 	DAX_RECOVERY_WRITE,
 };
 
+enum dax_driver_type {
+	DAXDRV_KMEM_TYPE,
+	DAXDRV_DEVICE_TYPE,
+};
+
 struct dax_operations {
 	/*
 	 * direct_access: translate a device-relative
-- 
2.52.0


