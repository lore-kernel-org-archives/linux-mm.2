Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6314BC624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4EA26B00BF; Sun, 22 Feb 2026 03:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA776B00C1; Sun, 22 Feb 2026 03:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44626B00C2; Sun, 22 Feb 2026 03:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A97E6B00BF
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 440DD13B0E5
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:28 +0000 (UTC)
X-FDA: 84471471336.18.53B5DF8
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com [209.85.160.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 783E31C0008
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="cnw/wXjb";
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.195 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGuT6RhCP5I7NLb1YN0up3Sr68HZnKNB2ZvPCLs8MH8=;
	b=WA0UOouq2NVav7n/FQUN3iffRzJByU+OsI0rcj01NFBGOJElI3MOlF58tpkam3k6IXuoUU
	vGtWSkRR+XIUHsls0dyKJQJfwoiJXBARfP5Q4xnRxHzWnu7FNtnEJSXiF+Xn9fkiY0u8Fi
	aC/nHA2W9BMmQ70xLpBmOcdWBF9oHtA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="cnw/wXjb";
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.195 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750226; a=rsa-sha256;
	cv=none;
	b=8lLHGXyh25R8ZODdoFxKdaEm1njt+QElC8D2liGxqi0Yp1pAnQLtukRUOJ3oiQzlBCXbOm
	dSGmpspWKeBQhs3l6rVc+hgZwNUU713/pxaTlkmubVrKBUo06xdOy7sp3QH41eMCvxva2k
	NTAbGp1qE2SWbcv+2mhTspUQ49VNRLk=
Received: by mail-qt1-f195.google.com with SMTP id d75a77b69052e-502a789834fso29525791cf.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750226; x=1772355026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGuT6RhCP5I7NLb1YN0up3Sr68HZnKNB2ZvPCLs8MH8=;
        b=cnw/wXjbbQqkBNg6xO11DqUPhbHe5M6ZchWMTuQbYOJllmKKyrOh9VDPlzwpNY2uH8
         090e0nwLAg3kRcD+P5a7f932UyNQmtQgziLfG72my+RGaS7E11Z6rH+rWriWPy6R3wum
         GWSnmR8WTGQ9Fe6padEVL7kuiAfWzt5DLEldc5qD39/YII6r5lqUge4xlIWiSC1bAIof
         NwN91Y+CHIeszbb0b+M52kwFzA4GHiORVOcE7s0UHvacyAWaAFy4hjOpeD7HNSVBivJ1
         eW5F2V4YT0YNyKTl4ImATXnuL/kBp5RwTcfwfgpGcbX7yXnG9RBiFMlJD2cDazI7i0b7
         jjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750226; x=1772355026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EGuT6RhCP5I7NLb1YN0up3Sr68HZnKNB2ZvPCLs8MH8=;
        b=VYNeWGFb1dvV48rFQmTGD4dZDHsgge26SCdCONbIJA/SnBsjUsw+z479KBWQwyEl5r
         4E5rbw/2P6/BrdKcCOdDLwE7qMKC2loz8Jz/8nDuhWH9IpGt/7tbuwRW2wufC0IMZCUd
         otZ6cplFOWlYOYERAEQrcON39UI2e0+lWRSJlw8Nll2GbqdlVUjKRB3io4j5EGaSGeAy
         88tqlisd7K6L19xnNIBaQj8cSYKT66A59PKpf8PeSaTtAc842cmxuTyzV6dHBYrtz5N5
         ugFCSt/x2j+37028RQLBRxHb5sYkSILDTRXBewQzZLbx9HB5zUjBIIPU3nk2DpsOn6GS
         vs0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVH98QzOfA0gTgtgIjX6BNjha/xraZhVgzsIAmcsFb2Dw1MucuKRxtS0P5W8c1RTZhV+vN9PwHsHw==@kvack.org
X-Gm-Message-State: AOJu0YxvdPzs95Epu8E9y5vQc0D1er3MAWle8tikantT1g8v1R3oqQJ0
	ZShJsqZiqvqG6zk++tQYA95Wzyph/g0IENnn036h355HFWFIrs3QSs/mulqZMIRf5Sw=
X-Gm-Gg: AZuq6aIAeZN7MBQmuT9IX5OwxmduWCAH9olyxlyVmm2D4Vt4NsaZoDDHWbt0+ybNTvW
	syk0izUcIo6oTRIcON3+sMJhQ7ZknsELNQeigl80DCqGYFD7OxvHuQWKRaiiE7lqy8rGENbw2Ou
	tfHWVy8HmGXKTlz4jMH8lDFUGspwv9LmUP7CThcBlxo/I/cvzOLsB2yaA5WrsH+w2Pob+IwOw4T
	m1ZRidLeFoG4NI/E6cRNtelLEwVSmGDRUexZYf84nF7R8+IYyZ1HsiZFzbH3I5oF/adHn0XT7vH
	o1dbSnbi3kIn4oAbcVyJDmIpkrpJ5V+nBAv6RSM8s8z9RxVmc4OuUwQcjfKr+hucB7j7TbvmwZr
	Ps3a4bJ9htqwCi3P3jfBi6vj+9UIRjj1qSKK7qlwZLK3dF1zbXduZneqRsTbfABoFgdfMIrvfNV
	9D4jkCCDsDF7YgHymeHmpg7wB3iLyC0IRs0qReDiiY52gdH5JtRRArmjH7Mvx91QChOiqWB529w
	+qWteuui5gjOPcXTuzmhoo0MA==
X-Received: by 2002:ac8:5f8a:0:b0:4ed:b94c:774a with SMTP id d75a77b69052e-5070bba6830mr70961981cf.5.1771750225498;
        Sun, 22 Feb 2026 00:50:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:25 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
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
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 24/27] cxl/core: Add cxl_sysram region type
Date: Sun, 22 Feb 2026 03:48:39 -0500
Message-ID: <20260222084842.1824063-25-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8xafhersnwnoteuw1jg5wxmpqcenohos
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 783E31C0008
X-HE-Tag: 1771750226-918621
X-HE-Meta: U2FsdGVkX190ikWs+2mBIWutSyCNz4ijajog4h+Tiacvhpmtam4u4mqliqPgQKuSCEusDuemezGU9gzrhLWvzTeawJCo7V22nW0sqORzhSaQj4ZWOVqg2/HOmx0xMFaWwFc4ouhnWyksoc169TDcLYyUVtUeMm7XlktAKGqhWwt4xZzAjEki+pNHcbO5WnTaBv0OEYj62r+29GhNkpjJzpkmJQBi6ZJeEXW/Vob9464snt4Pk+rjiqqdxjHK1e0AyXKapDrVOuWFQ7VIDuB4DdjCivRe8UGkSKKhlwTK3CHRm92xSYO58qMqOCS4EFtfvx7ijpkBg03Is3yIDy6mXOMRcYgplgRJMdQeX3gENw0V7BQzDGw99/mxemLOCvD3G1j8rsel56b3SflkZ7FU7hFNwYgc8j/p9CLusncw7JHnVamwPawN9uBAf70FkOWlTss2p1+rBUs+icIPv1HhB004ubpPigff76XRkWT9d7YQkBl/xavw6aWbqKTrJLPcDU/nZl63TVXrQ0Sy8B7O2z2wm3eH2vWkHboy3//3/xzzjr7xzH0sOMgXFtOv9OuNcDhNegvOGcIimtl3pRByGv0tpj2/uPT2jmClwX+pfc5eK7MCDWjeZoD1/I5P9yqlmBmJTfpXcB1VSs+xepd6MwDWZu0I65jbMu61XXL8V4LMzu3IUoRRbjR0w4skKfJLeUDmHOc0GggMYNpUUDU3txFEBVhUm59TDgVHX3AVUuyB/nz5PljWD4pAYEhXzNGBfkHs5jfGh349/ZGQZwfqaOYsyev27aMIOaS+sOdVaZ+XdhNujJklO5PPdU+4UnAmhapsxDp8QAPFNMIjH+RipXqcXPlx3efFk5gGBq6+uf+s130hxLjQn+HySp9lHJO5kK3KKINMD0SNsQe7V+y5jVwaotvubpLhIWGik6ChlnjJ954asAzKmizcKk9rkhVTSN9KR8U1J6CsV92UnDb
 WahdHbiR
 BRgVX7ak5FxcvOAoUYsyzMNLlNACHH6WoCvbZWyHHfugKlBScliGY3uLCBz27IO7inOuhtaO4z9PRrAaF1nZbqTLajKUeZqsqykMYygXc1OozAnrVg8hGJraKBAdQlEPA81MvpMR2hTnrcaIxVli2ZYiIsCWEONrzZXRdMQfPlN7I636fNvq7vNUwiqlwB15RwOBw4MjLKUpxEqdz5OG3isRhvLVF3HfErA5+jKek+tHArL+ggsRheYu+dpmK+AB2AgAWYL1QH+Rdxl+31/BkQHPfRuQB/mmhiyuDnxuqsw2EI01GSBSG73b6Te2i0ZHB/KoPbaguFju97n2iuH8R68I9mhRR7yc1p8eHB6Xb98oeyS4fq3wjojv4MOj+k6NF7NRzyN6gaKYyIGWdbdm6OFIzDxIk2630+RazwP+py99srObJybdlG/1z5lal4hgaX2xv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the CXL sysram region for direct memory hotplug of CXL RAM regions.

This region eliminates the intermediate dax_region/dax device layer by
directly performing memory hotplug operations.

Key features:
- Supports memory tier integration for proper NUMA placement
- Uses the CXL_SYSRAM_ONLINE_* Kconfig options for default online type
- Automatically hotplugs memory on probe if online type is configured
- Will be extended to support private memory nodes in the future

The driver registers a sysram_regionN device as a child of the CXL
region, managing the memory hotplug lifecycle through device add/remove.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/Makefile        |   1 +
 drivers/cxl/core/core.h          |   4 +
 drivers/cxl/core/port.c          |   2 +
 drivers/cxl/core/region_sysram.c | 351 +++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h                |  48 +++++
 5 files changed, 406 insertions(+)
 create mode 100644 drivers/cxl/core/region_sysram.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index d3ec8aea64c5..d7ce52c50810 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -18,6 +18,7 @@ cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
 cxl_core-$(CONFIG_CXL_REGION) += region_dax.o
 cxl_core-$(CONFIG_CXL_REGION) += region_pmem.o
+cxl_core-$(CONFIG_CXL_REGION) += region_sysram.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 6e1f695fd155..973bbcae43f7 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -35,6 +35,7 @@ extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
 extern const struct device_type cxl_pmem_region_type;
 extern const struct device_type cxl_dax_region_type;
+extern const struct device_type cxl_sysram_type;
 extern const struct device_type cxl_region_type;
 
 int cxl_decoder_detach(struct cxl_region *cxlr,
@@ -46,6 +47,7 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
 #define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
 #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
+#define CXL_SYSRAM_TYPE(x) (&cxl_sysram_type)
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
@@ -54,6 +56,7 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
+int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -88,6 +91,7 @@ static inline void cxl_region_exit(void)
 #define SET_CXL_REGION_ATTR(x)
 #define CXL_PMEM_REGION_TYPE(x) NULL
 #define CXL_DAX_REGION_TYPE(x) NULL
+#define CXL_SYSRAM_TYPE(x) NULL
 #endif
 
 struct cxl_send_command;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 5c82e6f32572..d6e82b3c2b64 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -66,6 +66,8 @@ static int cxl_device_id(const struct device *dev)
 		return CXL_DEVICE_PMEM_REGION;
 	if (dev->type == CXL_DAX_REGION_TYPE())
 		return CXL_DEVICE_DAX_REGION;
+	if (dev->type == CXL_SYSRAM_TYPE())
+		return CXL_DEVICE_SYSRAM;
 	if (is_cxl_port(dev)) {
 		if (is_cxl_root(to_cxl_port(dev)))
 			return CXL_DEVICE_ROOT;
diff --git a/drivers/cxl/core/region_sysram.c b/drivers/cxl/core/region_sysram.c
new file mode 100644
index 000000000000..47a415deb352
--- /dev/null
+++ b/drivers/cxl/core/region_sysram.c
@@ -0,0 +1,351 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Meta Platforms, Inc. All rights reserved. */
+/*
+ * CXL Sysram Region - Direct memory hotplug for CXL RAM regions
+ *
+ * This interface directly performs memory hotplug for CXL RAM regions,
+ * eliminating the indirection through DAX.
+ */
+
+#include <linux/memory_hotplug.h>
+#include <linux/memory-tiers.h>
+#include <linux/memory.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
+
+static const char *sysram_res_name = "System RAM (CXL)";
+
+/**
+ * cxl_region_find_sysram - Find the sysram device associated with a region
+ * @cxlr: The CXL region
+ *
+ * Finds and returns the sysram child device of a CXL region.
+ * The caller must release the device reference with put_device()
+ * when done with the returned pointer.
+ *
+ * Return: Pointer to cxl_sysram, or NULL if not found
+ */
+struct cxl_sysram *cxl_region_find_sysram(struct cxl_region *cxlr)
+{
+	struct cxl_sysram *sysram;
+	struct device *sdev;
+	char sname[32];
+
+	snprintf(sname, sizeof(sname), "sysram_region%d", cxlr->id);
+	sdev = device_find_child_by_name(&cxlr->dev, sname);
+	if (!sdev)
+		return NULL;
+
+	sysram = to_cxl_sysram(sdev);
+	return sysram;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_region_find_sysram, "CXL");
+
+static int sysram_get_numa_node(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int nid;
+
+	nid = phys_to_target_node(p->res->start);
+	if (nid == NUMA_NO_NODE)
+		nid = memory_add_physaddr_to_nid(p->res->start);
+
+	return nid;
+}
+
+static int sysram_hotplug_add(struct cxl_sysram *sysram, enum mmop online_type)
+{
+	struct resource *res;
+	mhp_t mhp_flags;
+	int rc;
+
+	if (sysram->res)
+		return -EBUSY;
+
+	res = request_mem_region(sysram->hpa_range.start,
+				 range_len(&sysram->hpa_range),
+				 sysram->res_name);
+	if (!res)
+		return -EBUSY;
+
+	sysram->res = res;
+
+	/*
+	 * Set flags appropriate for System RAM. Leave ..._BUSY clear
+	 * so that add_memory() can add a child resource.
+	 */
+	res->flags = IORESOURCE_SYSTEM_RAM;
+
+	mhp_flags = MHP_NID_IS_MGID;
+
+	/*
+	 * Ensure that future kexec'd kernels will not treat
+	 * this as RAM automatically.
+	 */
+	rc = __add_memory_driver_managed(sysram->mgid,
+					 sysram->hpa_range.start,
+					 range_len(&sysram->hpa_range),
+					 sysram_res_name, mhp_flags,
+					 online_type);
+	if (rc) {
+		remove_resource(res);
+		kfree(res);
+		sysram->res = NULL;
+		return rc;
+	}
+
+	return 0;
+}
+
+static int sysram_hotplug_remove(struct cxl_sysram *sysram)
+{
+	int rc;
+
+	if (!sysram->res)
+		return 0;
+
+	rc = offline_and_remove_memory(sysram->hpa_range.start,
+				       range_len(&sysram->hpa_range));
+	if (rc)
+		return rc;
+
+	if (sysram->res) {
+		remove_resource(sysram->res);
+		kfree(sysram->res);
+		sysram->res = NULL;
+	}
+
+	return 0;
+}
+
+int cxl_sysram_offline_and_remove(struct cxl_sysram *sysram)
+{
+	return sysram_hotplug_remove(sysram);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_sysram_offline_and_remove, "CXL");
+
+static void cxl_sysram_release(struct device *dev)
+{
+	struct cxl_sysram *sysram = to_cxl_sysram(dev);
+
+	if (sysram->res)
+		sysram_hotplug_remove(sysram);
+
+	kfree(sysram->res_name);
+
+	if (sysram->mgid >= 0)
+		memory_group_unregister(sysram->mgid);
+
+	if (sysram->mtype)
+		clear_node_memory_type(sysram->numa_node, sysram->mtype);
+
+	kfree(sysram);
+}
+
+static ssize_t hotplug_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct cxl_sysram *sysram = to_cxl_sysram(dev);
+	int online_type, rc;
+
+	online_type = mhp_online_type_from_str(buf);
+	if (online_type < 0)
+		return online_type;
+
+	if (online_type == MMOP_OFFLINE)
+		rc = sysram_hotplug_remove(sysram);
+	else
+		rc = sysram_hotplug_add(sysram, online_type);
+
+	if (rc)
+		dev_warn(dev, "hotplug %s failed: %d\n",
+			 online_type == MMOP_OFFLINE ? "offline" : "online", rc);
+
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_WO(hotplug);
+
+static struct attribute *cxl_sysram_attrs[] = {
+	&dev_attr_hotplug.attr,
+	NULL
+};
+
+static const struct attribute_group cxl_sysram_attribute_group = {
+	.attrs = cxl_sysram_attrs,
+};
+
+static const struct attribute_group *cxl_sysram_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	&cxl_sysram_attribute_group,
+	NULL
+};
+
+const struct device_type cxl_sysram_type = {
+	.name = "cxl_sysram",
+	.release = cxl_sysram_release,
+	.groups = cxl_sysram_attribute_groups,
+};
+
+static bool is_cxl_sysram(struct device *dev)
+{
+	return dev->type == &cxl_sysram_type;
+}
+
+struct cxl_sysram *to_cxl_sysram(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_sysram(dev),
+			  "not a cxl_sysram device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_sysram, dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_sysram, "CXL");
+
+struct device *cxl_sysram_dev(struct cxl_sysram *sysram)
+{
+	return &sysram->dev;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_sysram_dev, "CXL");
+
+static struct lock_class_key cxl_sysram_key;
+
+static enum mmop cxl_sysram_get_default_online_type(void)
+{
+	if (IS_ENABLED(CONFIG_CXL_SYSRAM_ONLINE_TYPE_SYSTEM_DEFAULT))
+		return mhp_get_default_online_type();
+	if (IS_ENABLED(CONFIG_CXL_SYSRAM_ONLINE_TYPE_MOVABLE))
+		return MMOP_ONLINE_MOVABLE;
+	if (IS_ENABLED(CONFIG_CXL_SYSRAM_ONLINE_TYPE_NORMAL))
+		return MMOP_ONLINE;
+	return MMOP_OFFLINE;
+}
+
+static struct cxl_sysram *cxl_sysram_alloc(struct cxl_region *cxlr)
+{
+	struct cxl_sysram *sysram __free(kfree) = NULL;
+	struct device *dev;
+
+	sysram = kzalloc(sizeof(*sysram), GFP_KERNEL);
+	if (!sysram)
+		return ERR_PTR(-ENOMEM);
+
+	sysram->online_type = cxl_sysram_get_default_online_type();
+	sysram->last_hotplug_cmd = MMOP_OFFLINE;
+	sysram->numa_node = -1;
+	sysram->mgid = -1;
+
+	dev = &sysram->dev;
+	sysram->cxlr = cxlr;
+	device_initialize(dev);
+	lockdep_set_class(&dev->mutex, &cxl_sysram_key);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_sysram_type;
+
+	return_ptr(sysram);
+}
+
+static void sysram_unregister(void *_sysram)
+{
+	struct cxl_sysram *sysram = _sysram;
+
+	device_unregister(&sysram->dev);
+}
+
+int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type)
+{
+	struct cxl_sysram *sysram __free(put_cxl_sysram) = NULL;
+	struct memory_dev_type *mtype;
+	struct range hpa_range;
+	struct device *dev;
+	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
+	int numa_node;
+	int rc;
+
+	rc = cxl_region_get_hpa_range(cxlr, &hpa_range);
+	if (rc)
+		return rc;
+
+	hpa_range = memory_block_align_range(&hpa_range);
+	if (hpa_range.start >= hpa_range.end) {
+		dev_warn(&cxlr->dev, "region too small after alignment\n");
+		return -ENOSPC;
+	}
+
+	sysram = cxl_sysram_alloc(cxlr);
+	if (IS_ERR(sysram))
+		return PTR_ERR(sysram);
+
+	sysram->hpa_range = hpa_range;
+
+	sysram->res_name = kasprintf(GFP_KERNEL, "cxl_sysram%d", cxlr->id);
+	if (!sysram->res_name)
+		return -ENOMEM;
+
+	/* Override default online type if caller specified one */
+	if (online_type >= 0)
+		sysram->online_type = online_type;
+
+	dev = &sysram->dev;
+
+	rc = dev_set_name(dev, "sysram_region%d", cxlr->id);
+	if (rc)
+		return rc;
+
+	/* Setup memory tier before adding device */
+	numa_node = sysram_get_numa_node(cxlr);
+	if (numa_node < 0) {
+		dev_warn(&cxlr->dev, "rejecting region with invalid node: %d\n",
+			 numa_node);
+		return -EINVAL;
+	}
+	sysram->numa_node = numa_node;
+
+	mt_calc_adistance(numa_node, &adist);
+	mtype = mt_get_memory_type(adist);
+	if (IS_ERR(mtype))
+		return PTR_ERR(mtype);
+	sysram->mtype = mtype;
+
+	init_node_memory_type(numa_node, mtype);
+
+	/* Register memory group for this region */
+	rc = memory_group_register_static(numa_node,
+					  PFN_UP(range_len(&hpa_range)));
+	if (rc < 0)
+		return rc;
+	sysram->mgid = rc;
+
+	rc = device_add(dev);
+	if (rc)
+		return rc;
+
+	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
+		dev_name(dev));
+
+	/*
+	 * Dynamic capacity regions (DCD) will have memory added later.
+	 * For static RAM regions, hotplug the entire range now.
+	 */
+	if (cxlr->mode != CXL_PARTMODE_RAM)
+		goto out;
+
+	/* If default online_type is a valid online mode, immediately hotplug */
+	if (sysram->online_type > MMOP_OFFLINE) {
+		rc = sysram_hotplug_add(sysram, sysram->online_type);
+		if (rc)
+			dev_warn(dev, "hotplug failed: %d\n", rc);
+		else
+			sysram->last_hotplug_cmd = sysram->online_type;
+	}
+
+out:
+	return devm_add_action_or_reset(&cxlr->dev, sysram_unregister,
+					no_free_ptr(sysram));
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_sysram, "CXL");
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f899f240f229..8e8342fd4fde 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -607,6 +607,34 @@ struct cxl_dax_region {
 	enum dax_driver_type dax_driver;
 };
 
+/**
+ * struct cxl_sysram - CXL SysRAM region for system memory hotplug
+ * @dev: device for this sysram
+ * @cxlr: parent cxl_region
+ * @online_type: Default memory online type for new hotplug ops (MMOP_* value)
+ * @last_hotplug_cmd: Last hotplug command submitted (MMOP_* value)
+ * @hpa_range: Host physical address range for the region
+ * @res_name: Resource name for the memory region
+ * @res: Memory resource (set when hotplugged)
+ * @mgid: Memory group id
+ * @mtype: Memory tier type
+ * @numa_node: NUMA node for this memory
+ *
+ * Device that directly performs memory hotplug for CXL RAM regions.
+ */
+struct cxl_sysram {
+	struct device dev;
+	struct cxl_region *cxlr;
+	enum mmop online_type;
+	int last_hotplug_cmd;
+	struct range hpa_range;
+	const char *res_name;
+	struct resource *res;
+	int mgid;
+	struct memory_dev_type *mtype;
+	int numa_node;
+};
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
@@ -807,6 +835,7 @@ DEFINE_FREE(put_cxl_port, struct cxl_port *, if (!IS_ERR_OR_NULL(_T)) put_device
 DEFINE_FREE(put_cxl_root_decoder, struct cxl_root_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->cxlsd.cxld.dev))
 DEFINE_FREE(put_cxl_region, struct cxl_region *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 DEFINE_FREE(put_cxl_dax_region, struct cxl_dax_region *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
+DEFINE_FREE(put_cxl_sysram, struct cxl_sysram *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
 
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
 void cxl_bus_rescan(void);
@@ -889,6 +918,7 @@ void cxl_destroy_region(struct cxl_region *cxlr);
 struct device *cxl_region_dev(struct cxl_region *cxlr);
 enum cxl_partition_mode cxl_region_mode(struct cxl_region *cxlr);
 int cxl_get_region_range(struct cxl_region *cxlr, struct range *range);
+struct cxl_sysram *cxl_region_find_sysram(struct cxl_region *cxlr);
 int cxl_get_committed_regions(struct cxl_memdev *cxlmd,
 			      struct cxl_region **regions, int max_regions);
 struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
@@ -936,6 +966,7 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 #define CXL_DEVICE_PMEM_REGION		7
 #define CXL_DEVICE_DAX_REGION		8
 #define CXL_DEVICE_PMU			9
+#define CXL_DEVICE_SYSRAM		10
 
 #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
 #define CXL_MODALIAS_FMT "cxl:t%d"
@@ -954,6 +985,10 @@ bool is_cxl_pmem_region(struct device *dev);
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
+struct cxl_sysram *to_cxl_sysram(struct device *dev);
+struct device *cxl_sysram_dev(struct cxl_sysram *sysram);
+int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type);
+int cxl_sysram_offline_and_remove(struct cxl_sysram *sysram);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
@@ -972,6 +1007,19 @@ static inline struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
 {
 	return NULL;
 }
+static inline struct cxl_sysram *to_cxl_sysram(struct device *dev)
+{
+	return NULL;
+}
+static inline int devm_cxl_add_sysram(struct cxl_region *cxlr,
+				      enum mmop online_type)
+{
+	return -ENXIO;
+}
+static inline int cxl_sysram_offline_and_remove(struct cxl_sysram *sysram)
+{
+	return -ENXIO;
+}
 static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 					       u64 spa)
 {
-- 
2.53.0


