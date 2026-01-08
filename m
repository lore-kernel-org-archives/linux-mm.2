Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9515CD1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E025F6B009E; Thu,  8 Jan 2026 15:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD61A6B009F; Thu,  8 Jan 2026 15:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9B06B00A0; Thu,  8 Jan 2026 15:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB86F6B009E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:39:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B4971A029D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:39:17 +0000 (UTC)
X-FDA: 84309961554.14.6CDCCCB
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id A236A180002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:39:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h0z57Wzu;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbAJPMgZOoJSjKjyh3GK6UyuoBx+8LBWNLKG00C3DPA=;
	b=HAaSQfEgnICZ2XLw/gKKtPPv9zTey6LILZrk7ZSJaRmMlNZ828AwOCjUJaQkDJGGl8fXzJ
	ozpgk6nUNW89bCMcY1qedXCzuGwdlWK02aRBNMa13BqLBr9z0ihZCD5qk5Ubyn/VJgS0Mi
	LqMRNTsEQ7Nlu+4b902dfRB4We9RNko=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h0z57Wzu;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904755; a=rsa-sha256;
	cv=none;
	b=eOLwcMp87GGQCzJUd2cP9EOK8SUBh0hF2+b2Yyz17WJP+UU46/oJBqfYow8NoC9nIp/liZ
	41rB47Go3h9/fNUhPlkj93wEr7q9w8tWXsdJ65ohNFM5IwebP/lM3Qgug6sxsSkAXc3m5o
	FQOU6/orhzuuC/Zb9awfJeRmgyopdIM=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88a2ad13c24so32552186d6.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904754; x=1768509554; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbAJPMgZOoJSjKjyh3GK6UyuoBx+8LBWNLKG00C3DPA=;
        b=h0z57Wzu/W3ktm2AHpf13tOzBIJTa0R+fCyy8EjkUECvqdauRhiz2Q8V8iimtRgkdA
         YUornYuAO62QPyhOIO1IKcFNZinQjAAZuW+qw64Y6zpzymQdyS4n9tcSApABY4n2J6V+
         qY+3SfLq2MiVZp5Tuay61P1WuuOYegZUpMur4S5LAebK2GVFbYTwnD5jq85ARb2t8w+n
         qSRG2oyRGySRz199LvWQJLv5KmwP125lpruZvUmcskK16jNZ409+6vXLvDZerWjBH70C
         xWNpYNo0g9njJSUC5VSdw19SlCyrIGGHuXpIbP/QOjZJAHSCT1iVj205796OEzbdPoFG
         Cyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904754; x=1768509554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hbAJPMgZOoJSjKjyh3GK6UyuoBx+8LBWNLKG00C3DPA=;
        b=RFIsL9gU/nfjPrqIKfC9oSSESsW7z7AyjXJkKplCVv/vUa3WiJzsxI4T+KvtUCd8g8
         w7CMxtodePMZkE7NnP86cG+zLzJoNBNgXSF/K/5k4+IZwVSEiOb+2e8i+GhBtwj42GWR
         Wkxif/tZig4ENnc7uVlUGGe64756ssaohSbDwXA05h73bPTcA8C59bmJSiZr9BdQgCwl
         ZW+aDvFvOCNJlcn3ZW+tyFbC1pmtk3uI5M2DnTrMVeMoJPa+iabL/RBpy08KKKRyP2zf
         NmdM2vgfYucDRPweOzv/CauiydAbJ5IpSHCd03Jkpvne9Ql4vjYGjq9wLMWlc2sCPPJC
         Ov+w==
X-Gm-Message-State: AOJu0YxEq+woTai5AvzacX3i4rHPbkN9p4g4rlqjqz85PrZKlRakJXDQ
	gsDhJOydVL0QeetlEmv5NsxerdibT5YGqpf0/OG8gigSeDTS7hWDCYBYmTerMLc3kbDFSeWD74M
	KwBqm
X-Gm-Gg: AY/fxX6suMp5CKr0fL7wkIFHWRD0ynvKMHTrCCyMsnHqesppF9VB/R4jX/CAqnuUYjI
	IlVCFjgXcsM8DzZqqxkfoEJiXTHEuozN8BR62GCw/V2iybeRBF7okJwhc2icJUY9IS7DbBlyHhX
	dTRKsiw1PwjfJDvfAIkvf8lF//gCAL+7Oa6MhYhtJjGgQIk+pUJu7f14/fEMU9eZUHHTlmfVvNe
	5EQP9ZTtftG8soz/vRL4QjJLpuS6tC7nzLxkA9lHCMSsyc1P+XT7IXSUoYOENXgiGIH34z+oT38
	63Y/eoVncXRhPt/Tx+mGWVnqXbQOMfAWGSUpCx0gNXjd0vHmWHrwKJ07TVOC1HND9JrOyBT7CzI
	3iOy3B8AotpkxPn31ifNG6eEMpQfXPMIR39s+oRhLDcQMGSaF+89+mAN6/1gHiJe6OAl7mOOWi+
	I6MEsoonIAootO5PRAwrYjfczN1hkgFDjenwxy57crtqWO9D+5g8qoOQV9jhPtACqkcFzvlI8FN
	wQ=
X-Google-Smtp-Source: AGHT+IETJUC85zNJ1zZIUFzv9QwdWQGaYClNK785q5YOPJAvYLx3d5ypHJ/HCEokjoFg0FJKBiPjgg==
X-Received: by 2002:a05:622a:124f:b0:4ee:24b8:2275 with SMTP id d75a77b69052e-4ffb4913960mr88384181cf.1.1767904754417;
        Thu, 08 Jan 2026 12:39:14 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:39:13 -0800 (PST)
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
Subject: [RFC PATCH v3 8/8] drivers/cxl: add zswap private_region type
Date: Thu,  8 Jan 2026 15:37:55 -0500
Message-ID: <20260108203755.1163107-9-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A236A180002
X-Stat-Signature: ri1xu8f1w9xj1qrnkwsip7crqd4bxkzq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767904755-646498
X-HE-Meta: U2FsdGVkX18r1a3TuozQ4Vm7bJEVADe7ty4+AftzM/laXmS+gNWGkFjPa0R1Su2oODBFfX3oSa1LaZYpWnMlk1ZmKDyla2PGxfPR1RJodB6APtmzVN6qQ22lcOKxyqeAqes3FMscAP70vJMylRPLkwdHnD6EJOO1luYL0r/T3NBX6zVQRqOoCXZsdS9eG5lrb3nOF8X+T3bUUUj3Hk/zzpYOQCL9jGhclWCs+V6lJHJTwW9CVcoV14ZynoPGQ1UhN2JrdPsCcGP2Oj/+oeFI8Xy0ggaySQyT+4rJzM7TzHYM/fB+72YAOtIYkXqrUyXmZ1UI02RS+eXZl7lU3QQ5YjexWP5rPH7HEBK55DzuFTkXb5dvGNZGHAUrTqrnh6IlzNJ816yMASAf3SwUrVAl/sFBpbjSdMof6gaWLVxuRSqq/0hNKcW3C5vPcZvrAoecOZp+5pAZpd7pDMGj9GqQcdGVMnJV5LGzWEoDt2u5iUjWEbh2wO5G10r4iv5F67u/KnrrJxuxZE5NoL+npkARIRW3r4mNQxDPsNlhd4qtMsvsxeugpDzIwA43KWYye6oBgOTcLXO82pVMMIRtJB9tt2V/23tnPTRbhGRUllkaaeKArfi93AOWtWXEpSXFrIfHj610JPS+mEqjFhZUEIJemHN+ZODxG6bZzczKU0l2udI5V7DcHia+PFt1a7R2eYbAHh8uRQvR9QQF0PRMvoEWN/TLF/pFhfzGvbRnGar/z6f8MYqWDt0t1a1vs0SK4L0vqQj4PbVr4fsBLMi9yGZDgJjQwYbLl6HXjLOG1wkK/+4A3EY/mg+oyLbwMpxiJcMhbZfUPI0fOGgQD5Dted/1DJTDLSjKGGEdx0NFl1/A/kgvoOV6/4kQixaYPAvVbbVdmekLgnKny+HSQ6VmWVxJqTElrQWEAxzI28X881e1sqyMGrKftXOH1ZUDLLIdVypSuTASHqLNa2813MMfR0Z
 CvBD/3v4
 kp64KwB/C2G952Iwa2SyVKZPt8kE22np+g9fQvQjtwGF0W2YE+CMWH/QFyuHcmlIDonLCy3jCG9x61BUuAcWHIrB3Wpnzj9D3e11cQ+41wqBht2yALd+aQ0WSlvGYUG2GKcKvY2awINtvX9z2JcN6rI7faJ5osQ1XBd0/TmnW3DUPvLCsv2opfIKymCCwo7bW7L8HoAPbLLCIKKu/zd/LB3uyr2OYZtDflyAs5a0ZVMYrORkEn23pJudpPe9YhHA/RXE766deL/14iyOJqe517BX17eEHJBcSP1rQimK1SYCqa7GD+sY9bE9VOM+wXOsCuyBl5lI1QKGHcUxhdeaZ2O68X7rHltBCzJ8tOA804zPg9ePwM5Egk4iyEE1C/rNq28a+S7DvwMGntiunpFj+w1lobaFF/Lz3QKYlC8epcV5C2J8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sample type of a zswap region, which registers itself as a valid
target node with mm/zswap.  Zswap will callback into the driver on new
page allocation and free.

On cxl_zswap_page_allocated(), we would check whether the worst case vs
current compression ratio is safe to allow new writes.

On cxl_zswap_page_freed(), zero the page to adjust the ratio down.

A device driver registering a Zswap private region would need to provide
an indicator to this component whether to allow new allocations - this
would probably be done via an interrupt setting a bit which says the
compression ratio has reached some conservative threshold.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/private_region/Makefile      |   3 +
 .../cxl/core/private_region/private_region.c  |  10 ++
 .../cxl/core/private_region/private_region.h  |   4 +
 drivers/cxl/core/private_region/zswap.c       | 127 ++++++++++++++++++
 drivers/cxl/cxl.h                             |   2 +
 5 files changed, 146 insertions(+)
 create mode 100644 drivers/cxl/core/private_region/zswap.c

diff --git a/drivers/cxl/core/private_region/Makefile b/drivers/cxl/core/private_region/Makefile
index d17498129ba6..ba495cd3f89f 100644
--- a/drivers/cxl/core/private_region/Makefile
+++ b/drivers/cxl/core/private_region/Makefile
@@ -7,3 +7,6 @@ ccflags-y += -I$(srctree)/drivers/cxl
 
 # Core dispatch and sysfs
 obj-$(CONFIG_CXL_REGION) += private_region.o
+
+# Type-specific implementations
+obj-$(CONFIG_CXL_REGION) += zswap.o
diff --git a/drivers/cxl/core/private_region/private_region.c b/drivers/cxl/core/private_region/private_region.c
index ead48abb9fc7..da5fb3d264e1 100644
--- a/drivers/cxl/core/private_region/private_region.c
+++ b/drivers/cxl/core/private_region/private_region.c
@@ -16,6 +16,8 @@
 static const char *private_type_to_string(enum cxl_private_region_type type)
 {
 	switch (type) {
+	case CXL_PRIVATE_ZSWAP:
+		return "zswap";
 	default:
 		return "";
 	}
@@ -23,6 +25,8 @@ static const char *private_type_to_string(enum cxl_private_region_type type)
 
 static enum cxl_private_region_type string_to_private_type(const char *str)
 {
+	if (sysfs_streq(str, "zswap"))
+		return CXL_PRIVATE_ZSWAP;
 	return CXL_PRIVATE_NONE;
 }
 
@@ -88,6 +92,9 @@ int cxl_register_private_region(struct cxl_region *cxlr)
 
 	/* Call type-specific registration which sets memtype and callbacks */
 	switch (cxlr->private_type) {
+	case CXL_PRIVATE_ZSWAP:
+		rc = cxl_register_zswap_region(cxlr);
+		break;
 	default:
 		dev_dbg(&cxlr->dev, "unsupported private_type: %d\n",
 			cxlr->private_type);
@@ -113,6 +120,9 @@ void cxl_unregister_private_region(struct cxl_region *cxlr)
 
 	/* Dispatch to type-specific cleanup */
 	switch (cxlr->private_type) {
+	case CXL_PRIVATE_ZSWAP:
+		cxl_unregister_zswap_region(cxlr);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/cxl/core/private_region/private_region.h b/drivers/cxl/core/private_region/private_region.h
index 9b34e51d8df4..84d43238dbe1 100644
--- a/drivers/cxl/core/private_region/private_region.h
+++ b/drivers/cxl/core/private_region/private_region.h
@@ -7,4 +7,8 @@ struct cxl_region;
 int cxl_register_private_region(struct cxl_region *cxlr);
 void cxl_unregister_private_region(struct cxl_region *cxlr);
 
+/* Type-specific registration functions - called from region.c dispatch */
+int cxl_register_zswap_region(struct cxl_region *cxlr);
+void cxl_unregister_zswap_region(struct cxl_region *cxlr);
+
 #endif /* __CXL_PRIVATE_REGION_H__ */
diff --git a/drivers/cxl/core/private_region/zswap.c b/drivers/cxl/core/private_region/zswap.c
new file mode 100644
index 000000000000..c213abe2fad7
--- /dev/null
+++ b/drivers/cxl/core/private_region/zswap.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CXL Private Region - zswap type implementation
+ *
+ * This file implements the zswap private region type for CXL devices.
+ * It handles registration/unregistration of CXL regions as zswap
+ * compressed memory targets.
+ */
+
+#include <linux/device.h>
+#include <linux/highmem.h>
+#include <linux/node.h>
+#include <linux/zswap.h>
+#include <linux/memory_hotplug.h>
+#include "../../cxl.h"
+#include "../core.h"
+#include "private_region.h"
+
+/*
+ * CXL zswap region page_allocated callback
+ *
+ * This callback is invoked by zswap when a page is allocated from a private
+ * node to validate that the page is safe to use. For a real compressed memory
+ * device, this would check the device's compression ratio and return an error
+ * if the page cannot safely store data.
+ *
+ * Currently this is a placeholder that always succeeds. A real implementation
+ * would query the device hardware to determine if sufficient compression
+ * headroom exists.
+ */
+static int cxl_zswap_page_allocated(struct page *page, void *data)
+{
+	struct cxl_region *cxlr = data;
+
+	/*
+	 * TODO: Query the CXL device to check if this page allocation is safe.
+	 *
+	 * A real compressed memory device would track its compression ratio
+	 * and report whether it has headroom to accept new data. If the
+	 * compression ratio is too low (device is near capacity), this should
+	 * return -ENOSPC to tell zswap to try another node.
+	 *
+	 * For now, always succeed since we're testing with regular memory.
+	 */
+	dev_dbg(&cxlr->dev, "page_allocated callback for nid %d\n",
+		page_to_nid(page));
+
+	return 0;
+}
+
+/*
+ * CXL zswap region page_freed callback
+ *
+ * This callback is invoked when a page from a private node is being freed.
+ * We zero the page before returning it to the allocator so that the compressed
+ * memory device can reclaim capacity - zeroed pages achieve excellent
+ * compression ratios.
+ */
+static void cxl_zswap_page_freed(struct page *page, void *data)
+{
+	struct cxl_region *cxlr = data;
+
+	/*
+	 * Zero the page to improve the device's compression ratio.
+	 * Zeroed pages compress extremely well, reclaiming device capacity.
+	 */
+	clear_highpage(page);
+
+	dev_dbg(&cxlr->dev, "page_freed callback for nid %d\n",
+		page_to_nid(page));
+}
+
+/*
+ * Unregister a zswap region from the zswap subsystem.
+ *
+ * This function removes the node from zswap direct nodes and unregisters
+ * the private node operations.
+ */
+void cxl_unregister_zswap_region(struct cxl_region *cxlr)
+{
+	int nid;
+
+	if (!cxlr->private ||
+	    cxlr->private_ops.memtype != NODE_MEM_ZSWAP)
+		return;
+
+	if (!cxlr->params.res)
+		return;
+
+	nid = phys_to_target_node(cxlr->params.res->start);
+
+	zswap_remove_direct_node(nid);
+	node_unregister_private(nid, &cxlr->private_ops);
+
+	dev_dbg(&cxlr->dev, "unregistered zswap region for nid %d\n", nid);
+}
+
+/*
+ * Register a zswap region with the zswap subsystem.
+ *
+ * This function sets up the memtype, page_allocated callback, and
+ * registers the node with zswap as a direct compression target.
+ * The caller is responsible for adding the dax region after this succeeds.
+ */
+int cxl_register_zswap_region(struct cxl_region *cxlr)
+{
+	int nid, rc;
+
+	if (!cxlr->private || !cxlr->params.res)
+		return -EINVAL;
+
+	nid = phys_to_target_node(cxlr->params.res->start);
+
+	/* Register with node subsystem as zswap memory */
+	cxlr->private_ops.memtype = NODE_MEM_ZSWAP;
+	cxlr->private_ops.page_allocated = cxl_zswap_page_allocated;
+	cxlr->private_ops.page_freed = cxl_zswap_page_freed;
+	rc = node_register_private(nid, &cxlr->private_ops);
+	if (rc)
+		return rc;
+
+	/* Register this node with zswap as a direct compression target */
+	zswap_add_direct_node(nid);
+
+	dev_dbg(&cxlr->dev, "registered zswap region for nid %d\n", nid);
+	return 0;
+}
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b276956ff88d..89d8ae4e796c 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -534,9 +534,11 @@ enum cxl_partition_mode {
 /**
  * enum cxl_private_region_type - CXL private region types
  * @CXL_PRIVATE_NONE: No private region type set
+ * @CXL_PRIVATE_ZSWAP: Region used for zswap compressed memory
  */
 enum cxl_private_region_type {
 	CXL_PRIVATE_NONE,
+	CXL_PRIVATE_ZSWAP,
 };
 
 /**
-- 
2.52.0


