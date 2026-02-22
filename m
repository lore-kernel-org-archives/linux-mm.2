Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A808C624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6316B00C3; Sun, 22 Feb 2026 03:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1916B00C5; Sun, 22 Feb 2026 03:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B866B00C6; Sun, 22 Feb 2026 03:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDE136B00C3
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FBFC14062B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:36 +0000 (UTC)
X-FDA: 84471471672.18.A09A5A5
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id AE61C1C0005
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=To+ulPFU;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750234; a=rsa-sha256;
	cv=none;
	b=ws+WqoVDxEKJlkSPdK3WKqSmGmGV/wbgdM0KOIyQRGkanC7HNKhJhW8l4oYb9awmK1YNu/
	hCc7n82X/aqxnHKasy0eVXxNCzEMaJD49LcsQ8rHSASxUaj6QxEE0GX4BwYd2PRRBkjyco
	4jTGNOahDkKiVG7XT9/62Cocg/QeKN8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=To+ulPFU;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYiMdgFVvusXEx98vFRcNZk0pTiGBH9Jq4UQYwtGtaw=;
	b=2QYf/zIE08N/1uaU84D7Hws0jlUywlwHNJYN+8bPyIv0QB+79xGDRf8xyTTjlKNI/fwjYj
	AiPBP5d9wduG2TBg+CbUWmLubwcL8peMqz19iZDUhIkieF92+GHmOWo1d2MtcZlVHL4EOU
	VmrTqYOHC+kkCM/X1oqqOl8MMl6FaPA=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-506a6cf8242so28982921cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750234; x=1772355034; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYiMdgFVvusXEx98vFRcNZk0pTiGBH9Jq4UQYwtGtaw=;
        b=To+ulPFU0LW7KwVvihb8PQpoxiSM9LXWsztWc/jD8UNvMXGGohCzsztDkpHnPourpn
         xdXyyAoIum9KFpRlP523R0X0lkBHFX9y30wFHHvorxLZ1KeitJcQQIT3VMqx4wc0NvvV
         PcXTRF/54k0R1qsXs+OXcT2ypj2caGTFGWI5zFSTmNISXQ4sNxfDkmwVvlL+PsUNUzY4
         iT++MW6nDPVbCjVOypmEKZTSt0yytPdyYugblXWfp+t/VVBrsOiqCKmjnDBCc0eMgOl2
         sKeBBBIqhGngJTlb99ELTiVhWFJPA5mD9y93u/h+vPpVyZ+hGJ8UT/F4awnnwvuI4aOI
         ImIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750234; x=1772355034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYiMdgFVvusXEx98vFRcNZk0pTiGBH9Jq4UQYwtGtaw=;
        b=ha9K9vYhU7skK7/eU3ZSwiVkCHBdB2/UoKl+bNMye2yzXoDxNgQRu5yRtOi25ohj4x
         S1QradWUbcGdSdFHOoApCC3+PrAIL7G9r2TG9V3doKc1Y3/G73tLG2KmWY61/7r5xIFx
         PvU1WsQ03+u+kcNMmgaziv8MCKWjg48l8s2G/E+OP6Mp0W5wPjD6KUYnfxn+Q1FtGiCJ
         2JYTmOR00qzsjYxJRfcT8X/x5AXI7bGey3+mWuC9WD8Btvob93Y/sBa2nSghfQTks3WH
         mnxfS3HI/qu3K8+HsJwYsdy5OYdA+bRwYagl0HzVdj1K4f++Zj+/fhctnRLCdsYQU803
         +jFw==
X-Forwarded-Encrypted: i=1; AJvYcCW4aLbXp59aLn+fURmUe99YMvue+5XZpM3iTeHqN2V3RrwLHiidYfwBO13qO7976D459rOVuCqiyQ==@kvack.org
X-Gm-Message-State: AOJu0YwKajJad4lQ/mpP1IFg1UZ83B7Q3Kho3In/hOPW8V5suhAnuYMT
	K993Ijug/7OYG+/lLXemFI5CwToVjX6WcXYtiurj+MUXodDbNYOpU4wfEQ9ihqzUQmQ=
X-Gm-Gg: AZuq6aLhnGtus+wQnJfUzOqvHuZ3afjABIw8wBJiEcJ9gvwOt3XEFHh51daEfuQCAAX
	CV6f9r2V+lCXRmjlvf4DENiB6c+4KkXBUJWlLT5w7vZZ41NI83KeltkZ3QgWqBTqK/6dPrDEhRn
	UYbWWs+ERR2WYY/eWCT2CvKdEGb7a2YvnFCv/rgfIFqRhZ3HT+kKTE+LK4nvMqQhW5w0pfGYh9q
	UMQ6/K85f34CXuk1a7T71bBwEMSAF7iwNxUBGbvMuEOlHTBjyLsfdJSy5gnMqC0tzc0NmRID/xZ
	PV4tK+hADK0f9Lw3h0tRn8XW/h2UjoGoliwu2gcISOSiVbLIKNaWFVnwuGVMASI5jNwCt1fuIF3
	Spt9Aydx6ejHa2IMAnqvBI1ZzC948l58lNYxiPo6oJobUy4thdpAIMfFQYS7vLmBkW6lMCpKUKZ
	l4gzuEIbYcrkSqsnJA7oydPxkm8ZjnapF6ye8TZ3nRVXBi/QX+gIVQwM78tGeb21uTrugC0pEg7
	GciCBtDTVxuX1w=
X-Received: by 2002:ac8:5711:0:b0:506:21ff:af13 with SMTP id d75a77b69052e-5070bba24cemr71385411cf.1.1771750233590;
        Sun, 22 Feb 2026 00:50:33 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:33 -0800 (PST)
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
Subject: [RFC PATCH v4 26/27] cxl: add cxl_mempolicy sample PCI driver
Date: Sun, 22 Feb 2026 03:48:41 -0500
Message-ID: <20260222084842.1824063-27-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1d4njxgx6omb8u6yqjsyc5s3i6hzo9qn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE61C1C0005
X-HE-Tag: 1771750234-338703
X-HE-Meta: U2FsdGVkX1+Qp4yAKBr39NOHEMnwkqWsG9zV9/4ygSa77RTUdlft92SiROnSGrLCL00dBnj/8iGS5RDIkZUFrviDArpyBixkhIaJ+HoiIZOHk+7UB29spcPYfv4ygPEKM5AAJTdds4/nIz13/XMxFtUXr12s+0C2kg+idO2fZAmIGYBwjv3eOpz4fc+TgmA/TuRQPB5w7LrGkW9jHcKdG2u7WOdGUQrHD5gL23QbRXJW+5avCu5XSu+0YDUN7Z9QMlWQzNwNwMEbslvOj/NIaarssW3zy9PaszqoD37wmMlYJ7ytnPJkRLbVu+JSKsYkFHX+LIpcP/IP2EOz3p0qG+g8ZWuUoMk6P8Rc7MC9AzvKo8ncwViIe+tjQvtXbHSulgJ/JMIF9OVop4JEyBaQLidBk3lIyCJhsk8JP/xdCRQRgwtc2YxETab0MJlq2OCe9ip3fvY6IjGbER4PK7r/9b61y9U1YCc7GaMHVLwbmykc0UAkxMIfx/6/5WXcQZsZe0kpMAgdkN4rFTJuSR2qP2xX8JPjrxeTpwNPrhFIuto1DvahZqiZ+NOY5EHUwkaBsRH3J0gpwJhd3b8Ouhsm7eACBWgRAee96jd7SmLRnVxIeN2zB5EsxL/skO966JQkFHTFEvOJsm/tGVt0BRUUPKunnEQdQtGTl54ZkLQYXwj4c6ZvCBbo5pvELGHSLbFJD41GBwp5MDFhCQPa+75Eq5tbdHNRNL/MlEJSS+PFQnjuk61SMjVFrxuRtLATjbnDsaCnY7qh3Q62Xp1krWAx4bSMGOoaHgGAF3GWoJPYuUn1N5fUympF91y9wt6DJq2BGPwmekKClFI8ARv16DJvtZHMti+CwbuND0yYgcQ0iJvLifsEvRRCoG7Tb0H7xpBQ7KijZJAD9zsTCAULt7uXq49q9JBzX+oVtuMIyS6NV8TJLkyudrb0cwuZgPLho0+FhSL+Y3BWuyq5hysTAjE
 3dBMQHxs
 N9cA1YE4fR8K7xyRiAguhIqnv/4u8Y3g1xq7zvW1Z4QK0lhNukAD9LO9Nvd2Ib0kv+LLsmIe2du5ufb1fpTqpYvygBXLEUXh7kSADsCo1zZq1FJYy322fK9mASOFKPn1d+Z9MZh/MlDr5utKnwXfxguweK1exQ91JWSnVol8u3aRUb5AIFCttWAZ009hsaISnhCEsjbORQkF3mp7+1r9w6CSXuriueuQ4k/o8a/4EWPfHUsGy5YJdd62L3hqjLFXE13+6Qr78QehWLvweqU2V0OY0AACk8HTSBRYgw5ulWcKWduJBGBW7ScRyK3rh8DUtieHhjea25kYHh7NDUSBBqufkU/1RSqks11eZ95nva1/u3SGouiWnBB19c4MJVq+rfpx078nLhaGwCDRJD64OboWD4/QVGya+vFkHnFxU81Y++UG/BlAjng+a6EogAZ/21NQj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sample CXL type-3 driver that registers device memory as
private-node NUMA memory reachable only via explicit mempolicy
(set_mempolicy / mbind).

Probe flow:
  1. Call cxl_pci_type3_probe_init() for standard CXL device setup
  2. Look for pre-committed RAM regions; if none exist, create one
     using cxl_get_hpa_freespace() + cxl_request_dpa() +
     cxl_create_region()
  3. Convert the region to sysram via devm_cxl_add_sysram() with
     private=true and MMOP_ONLINE_MOVABLE
  4. Register node_private_ops with NP_OPS_MIGRATION | NP_OPS_MEMPOLICY
     so the node is excluded from default allocations

The migrate_to callback uses alloc_migration_target() with
__GFP_THISNODE | __GFP_PRIVATE to keep pages on the target node.

Move struct migration_target_control from mm/internal.h to
include/linux/migrate.h so the driver can use alloc_migration_target()
without depending on mm-internal headers.

Usage:
   echo $PCI_DEV > /sys/bus/pci/drivers/cxl_pci/unbind
   echo $PCI_DEV > /sys/bus/pci/drivers/cxl_mempolicy/bind

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/Kconfig                           |   2 +
 drivers/cxl/Makefile                          |   2 +
 drivers/cxl/type3_drivers/Kconfig             |   2 +
 drivers/cxl/type3_drivers/Makefile            |   2 +
 .../cxl/type3_drivers/cxl_mempolicy/Kconfig   |  16 +
 .../cxl/type3_drivers/cxl_mempolicy/Makefile  |   4 +
 .../type3_drivers/cxl_mempolicy/mempolicy.c   | 297 ++++++++++++++++++
 include/linux/migrate.h                       |   7 +-
 mm/internal.h                                 |   7 -
 9 files changed, 331 insertions(+), 8 deletions(-)
 create mode 100644 drivers/cxl/type3_drivers/Kconfig
 create mode 100644 drivers/cxl/type3_drivers/Makefile
 create mode 100644 drivers/cxl/type3_drivers/cxl_mempolicy/Kconfig
 create mode 100644 drivers/cxl/type3_drivers/cxl_mempolicy/Makefile
 create mode 100644 drivers/cxl/type3_drivers/cxl_mempolicy/mempolicy.c

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index f99aa7274d12..1648cdeaa0c9 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -278,4 +278,6 @@ config CXL_ATL
 	depends on CXL_REGION
 	depends on ACPI_PRMT && AMD_NB
 
+source "drivers/cxl/type3_drivers/Kconfig"
+
 endif
diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
index 2caa90fa4bf2..94d2b2233bf8 100644
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -19,3 +19,5 @@ cxl_acpi-y := acpi.o
 cxl_pmem-y := pmem.o security.o
 cxl_mem-y := mem.o
 cxl_pci-y := pci.o
+
+obj-y += type3_drivers/
diff --git a/drivers/cxl/type3_drivers/Kconfig b/drivers/cxl/type3_drivers/Kconfig
new file mode 100644
index 000000000000..369b21763856
--- /dev/null
+++ b/drivers/cxl/type3_drivers/Kconfig
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+source "drivers/cxl/type3_drivers/cxl_mempolicy/Kconfig"
diff --git a/drivers/cxl/type3_drivers/Makefile b/drivers/cxl/type3_drivers/Makefile
new file mode 100644
index 000000000000..2b82265ff118
--- /dev/null
+++ b/drivers/cxl/type3_drivers/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CXL_MEMPOLICY) += cxl_mempolicy/
diff --git a/drivers/cxl/type3_drivers/cxl_mempolicy/Kconfig b/drivers/cxl/type3_drivers/cxl_mempolicy/Kconfig
new file mode 100644
index 000000000000..3c45da237b9f
--- /dev/null
+++ b/drivers/cxl/type3_drivers/cxl_mempolicy/Kconfig
@@ -0,0 +1,16 @@
+config CXL_MEMPOLICY
+	tristate "CXL Private Memory with Mempolicy Support"
+	depends on CXL_PCI
+	depends on CXL_REGION
+	depends on NUMA
+	depends on MIGRATION
+	help
+	  Minimal driver for CXL memory devices that registers memory as
+	  N_MEMORY_PRIVATE with mempolicy support.  The memory is isolated
+	  from default allocations and can only be reached via explicit
+	  mempolicy (set_mempolicy or mbind).
+
+	  No compression, no PTE controls, the memory behaves like normal
+	  DRAM but is excluded from fallback allocations.
+
+	  If unsure say 'n'.
diff --git a/drivers/cxl/type3_drivers/cxl_mempolicy/Makefile b/drivers/cxl/type3_drivers/cxl_mempolicy/Makefile
new file mode 100644
index 000000000000..dfb58fc88ad9
--- /dev/null
+++ b/drivers/cxl/type3_drivers/cxl_mempolicy/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CXL_MEMPOLICY) += cxl_mempolicy.o
+cxl_mempolicy-y := mempolicy.o
+ccflags-y += -I$(srctree)/drivers/cxl
diff --git a/drivers/cxl/type3_drivers/cxl_mempolicy/mempolicy.c b/drivers/cxl/type3_drivers/cxl_mempolicy/mempolicy.c
new file mode 100644
index 000000000000..1c19818eb268
--- /dev/null
+++ b/drivers/cxl/type3_drivers/cxl_mempolicy/mempolicy.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Meta Platforms, Inc. All rights reserved. */
+/*
+ * CXL Mempolicy Driver
+ *
+ * Minimal driver for CXL memory devices that registers memory as
+ * N_MEMORY_PRIVATE with mempolicy support but no PTE controls.  The
+ * memory behaves like normal DRAM but is isolated from default allocations,
+ * it can only be reached via explicit mempolicy (set_mempolicy/mbind).
+ *
+ * Usage:
+ *   1. Unbind device from cxl_pci:
+ *        echo $PCI_DEV > /sys/bus/pci/drivers/cxl_pci/unbind
+ *   2. Bind to cxl_mempolicy:
+ *        echo $PCI_DEV > /sys/bus/pci/drivers/cxl_mempolicy/bind
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/xarray.h>
+#include <linux/node_private.h>
+#include <linux/migrate.h>
+#include <cxl/mailbox.h>
+#include "cxlmem.h"
+#include "cxl.h"
+
+struct cxl_mempolicy_ctx {
+	struct cxl_region *cxlr;
+	struct cxl_endpoint_decoder *cxled;
+	int nid;
+};
+
+static DEFINE_XARRAY(ctx_xa);
+
+static struct cxl_mempolicy_ctx *memdev_to_ctx(struct cxl_memdev *cxlmd)
+{
+	struct pci_dev *pdev = to_pci_dev(cxlmd->dev.parent);
+
+	return xa_load(&ctx_xa, (unsigned long)pdev);
+}
+
+static int cxl_mempolicy_migrate_to(struct list_head *folios, int nid,
+				    enum migrate_mode mode,
+				    enum migrate_reason reason,
+				    unsigned int *nr_succeeded)
+{
+	struct migration_target_control mtc = {
+		.nid = nid,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE |
+			    __GFP_PRIVATE,
+		.reason = reason,
+	};
+
+	return migrate_pages(folios, alloc_migration_target, NULL,
+			     (unsigned long)&mtc, mode, reason, nr_succeeded);
+}
+
+static void cxl_mempolicy_folio_migrate(struct folio *src, struct folio *dst)
+{
+}
+
+static const struct node_private_ops cxl_mempolicy_ops = {
+	.migrate_to	= cxl_mempolicy_migrate_to,
+	.folio_migrate	= cxl_mempolicy_folio_migrate,
+	.flags = NP_OPS_MIGRATION | NP_OPS_MEMPOLICY,
+};
+
+static struct cxl_region *create_ram_region(struct cxl_memdev *cxlmd)
+{
+	struct cxl_mempolicy_ctx *ctx = memdev_to_ctx(cxlmd);
+	struct cxl_root_decoder *cxlrd;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_region *cxlr;
+	resource_size_t ram_size, avail;
+
+	ram_size = cxl_ram_size(cxlmd->cxlds);
+	if (ram_size == 0) {
+		dev_info(&cxlmd->dev, "no RAM capacity available\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	ram_size = ALIGN_DOWN(ram_size, SZ_256M);
+	if (ram_size == 0) {
+		dev_info(&cxlmd->dev,
+			 "RAM capacity too small (< 256M)\n");
+		return ERR_PTR(-ENOSPC);
+	}
+
+	dev_info(&cxlmd->dev, "creating RAM region for %lld MB\n",
+		 ram_size >> 20);
+
+	cxlrd = cxl_get_hpa_freespace(cxlmd, ram_size, &avail);
+	if (IS_ERR(cxlrd)) {
+		dev_err(&cxlmd->dev, "no HPA freespace: %ld\n",
+			PTR_ERR(cxlrd));
+		return ERR_CAST(cxlrd);
+	}
+
+	cxled = cxl_request_dpa(cxlmd, CXL_PARTMODE_RAM, ram_size);
+	if (IS_ERR(cxled)) {
+		dev_err(&cxlmd->dev, "failed to request DPA: %ld\n",
+			PTR_ERR(cxled));
+		cxl_put_root_decoder(cxlrd);
+		return ERR_CAST(cxled);
+	}
+
+	cxlr = cxl_create_region(cxlrd, &cxled, 1);
+	cxl_put_root_decoder(cxlrd);
+	if (IS_ERR(cxlr)) {
+		dev_err(&cxlmd->dev, "failed to create region: %ld\n",
+			PTR_ERR(cxlr));
+		cxl_dpa_free(cxled);
+		return cxlr;
+	}
+
+	ctx->cxled = cxled;
+	dev_info(&cxlmd->dev, "created region %s\n",
+		 dev_name(cxl_region_dev(cxlr)));
+	return cxlr;
+}
+
+static int setup_private_node(struct cxl_memdev *cxlmd,
+			      struct cxl_region *cxlr)
+{
+	struct cxl_mempolicy_ctx *ctx = memdev_to_ctx(cxlmd);
+	struct range hpa_range;
+	int rc;
+
+	device_release_driver(cxl_region_dev(cxlr));
+
+	rc = devm_cxl_add_sysram(cxlr, true, MMOP_ONLINE_MOVABLE);
+	if (rc) {
+		dev_err(cxl_region_dev(cxlr),
+			"failed to add sysram: %d\n", rc);
+		if (device_attach(cxl_region_dev(cxlr)) < 0)
+			dev_warn(cxl_region_dev(cxlr),
+				 "failed to re-attach driver\n");
+		return rc;
+	}
+
+	rc = cxl_get_region_range(cxlr, &hpa_range);
+	if (rc) {
+		dev_err(cxl_region_dev(cxlr),
+			"failed to get region range: %d\n", rc);
+		return rc;
+	}
+
+	ctx->nid = phys_to_target_node(hpa_range.start);
+	if (ctx->nid == NUMA_NO_NODE)
+		ctx->nid = memory_add_physaddr_to_nid(hpa_range.start);
+
+	rc = node_private_set_ops(ctx->nid, &cxl_mempolicy_ops);
+	if (rc) {
+		dev_err(cxl_region_dev(cxlr),
+			"failed to set ops on node %d: %d\n", ctx->nid, rc);
+		ctx->nid = NUMA_NO_NODE;
+		return rc;
+	}
+
+	dev_info(&cxlmd->dev,
+		 "node %d registered as private mempolicy memory\n", ctx->nid);
+	return 0;
+}
+
+static int cxl_mempolicy_attach_probe(struct cxl_memdev *cxlmd)
+{
+	struct cxl_region *regions[8];
+	struct cxl_region *cxlr;
+	int nr, i;
+	int rc;
+
+	dev_info(&cxlmd->dev,
+		 "cxl_mempolicy attach: looking for regions\n");
+
+	/* Phase 1: look for pre-committed RAM regions */
+	nr = cxl_get_committed_regions(cxlmd, regions, ARRAY_SIZE(regions));
+	for (i = 0; i < nr; i++) {
+		if (cxl_region_mode(regions[i]) != CXL_PARTMODE_RAM) {
+			put_device(cxl_region_dev(regions[i]));
+			continue;
+		}
+
+		cxlr = regions[i];
+		rc = setup_private_node(cxlmd, cxlr);
+		put_device(cxl_region_dev(cxlr));
+		if (rc == 0) {
+			/* Release remaining region references */
+			for (i++; i < nr; i++)
+				put_device(cxl_region_dev(regions[i]));
+			return 0;
+		}
+	}
+
+	/* Phase 2: no committed regions, create one */
+	dev_info(&cxlmd->dev,
+		 "no existing regions, creating RAM region\n");
+
+	cxlr = create_ram_region(cxlmd);
+	if (IS_ERR(cxlr)) {
+		rc = PTR_ERR(cxlr);
+		if (rc == -ENODEV) {
+			dev_info(&cxlmd->dev,
+				 "no RAM capacity: %d\n", rc);
+			return 0;
+		}
+		return rc;
+	}
+
+	rc = setup_private_node(cxlmd, cxlr);
+	if (rc) {
+		dev_err(&cxlmd->dev,
+			"failed to setup private node: %d\n", rc);
+		return rc;
+	}
+
+	/* Only take ownership of regions we created (Phase 2) */
+	memdev_to_ctx(cxlmd)->cxlr = cxlr;
+
+	return 0;
+}
+
+static const struct cxl_memdev_attach cxl_mempolicy_attach = {
+	.probe = cxl_mempolicy_attach_probe,
+};
+
+static int cxl_mempolicy_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *id)
+{
+	struct cxl_mempolicy_ctx *ctx;
+	struct cxl_memdev *cxlmd;
+	int rc;
+
+	dev_info(&pdev->dev, "cxl_mempolicy: probing device\n");
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->nid = NUMA_NO_NODE;
+
+	rc = xa_insert(&ctx_xa, (unsigned long)pdev, ctx, GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	cxlmd = cxl_pci_type3_probe_init(pdev, &cxl_mempolicy_attach);
+	if (IS_ERR(cxlmd)) {
+		xa_erase(&ctx_xa, (unsigned long)pdev);
+		return PTR_ERR(cxlmd);
+	}
+
+	dev_info(&pdev->dev, "cxl_mempolicy: probe complete\n");
+	return 0;
+}
+
+static void cxl_mempolicy_remove(struct pci_dev *pdev)
+{
+	struct cxl_mempolicy_ctx *ctx = xa_erase(&ctx_xa, (unsigned long)pdev);
+
+	dev_info(&pdev->dev, "cxl_mempolicy: removing device\n");
+
+	if (!ctx)
+		return;
+
+	if (ctx->nid != NUMA_NO_NODE)
+		WARN_ON(node_private_clear_ops(ctx->nid, &cxl_mempolicy_ops));
+
+	if (ctx->cxlr) {
+		cxl_destroy_region(ctx->cxlr);
+		ctx->cxlr = NULL;
+	}
+
+	if (ctx->cxled) {
+		cxl_dpa_free(ctx->cxled);
+		ctx->cxled = NULL;
+	}
+}
+
+static const struct pci_device_id cxl_mempolicy_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0d93) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, cxl_mempolicy_pci_tbl);
+
+static struct pci_driver cxl_mempolicy_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= cxl_mempolicy_pci_tbl,
+	.probe		= cxl_mempolicy_probe,
+	.remove		= cxl_mempolicy_remove,
+	.driver	= {
+		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
+	},
+};
+
+module_pci_driver(cxl_mempolicy_driver);
+
+MODULE_DESCRIPTION("CXL: Private Memory with Mempolicy Support");
+MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS("CXL");
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 7b2da3875ff2..1f9fb61f3932 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -10,7 +10,12 @@
 typedef struct folio *new_folio_t(struct folio *folio, unsigned long private);
 typedef void free_folio_t(struct folio *folio, unsigned long private);
 
-struct migration_target_control;
+struct migration_target_control {
+	int nid;		/* preferred node id */
+	nodemask_t *nmask;
+	gfp_t gfp_mask;
+	enum migrate_reason reason;
+};
 
 /**
  * struct movable_operations - Driver page migration
diff --git a/mm/internal.h b/mm/internal.h
index 64467ca774f1..85cd11189854 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1352,13 +1352,6 @@ extern const struct trace_print_flags gfpflag_names[];
 
 void setup_zone_pageset(struct zone *zone);
 
-struct migration_target_control {
-	int nid;		/* preferred node id */
-	nodemask_t *nmask;
-	gfp_t gfp_mask;
-	enum migrate_reason reason;
-};
-
 /*
  * mm/filemap.c
  */
-- 
2.53.0


