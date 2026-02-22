Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F6BC624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D85B6B00BD; Sun, 22 Feb 2026 03:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A1C6B00BF; Sun, 22 Feb 2026 03:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E956B00C0; Sun, 22 Feb 2026 03:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3196B00BD
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3B4FC22AA
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:24 +0000 (UTC)
X-FDA: 84471471168.04.BCA0628
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0845540010
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="L36/B7Ym";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTSr2egiGZrzh+7+ZlbqD5qhC+A1cnXWqtUesRojnlw=;
	b=htfHFh7hePEkg7mMQV7UG4rXwuqOO+XQ58KT8y2LuQaG0MeqW7fyWm20zmqdDkHxFZYH02
	Vc7olnckzxWlWdsdBhEkfQNCl2GVZZ0T+vuVa4R66nPobLi5L1IIVq3XtoDqFoTTIRmUck
	crTVTn32k9y3K0408HoYHJEXBR0WLIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750223; a=rsa-sha256;
	cv=none;
	b=l2TdXQgGlihM8sh9apJFSt0A4AMDe39i2y0tLufamhJFHsYHcg9ZpdNxSGSpmE1lC4MF3s
	q3ojFTG7fIeKE4Mbg7+NVnK6M+fuEqChUEWuQFMMa+PMdltqRFeFn12/3/LcR7JQ+3S1U3
	ictBICwiAO5XgW3Wa66SmOWvW6ZzXIA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="L36/B7Ym";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50698970941so37366841cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750222; x=1772355022; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTSr2egiGZrzh+7+ZlbqD5qhC+A1cnXWqtUesRojnlw=;
        b=L36/B7Ym5ejbjymW2Di8iu8OGFLxPPjfM5o/8j8jkpmU0/s4wluPATzFCFEpf5OmLy
         n27FHSRTktWQ27W1HUajEnNvtjK0CqDlfxJ4+49ihN1MZNiak/PDWW8wEZtrO7cOgrdF
         AYg3fNZrXKy2lLeyvZhTPOUJqS7prXi2M0bGGjlLN+cOSpAmavoVlmnm+Bc2kZ+Vc/2g
         YCl7Hk6Ym6bGSPsSV1R5rJS4BakxtsDzjsgIbbv61wlz39BXY0PEDnGchBo/en4IJkr/
         MjHJ2BotKPhq7uzQYHRsjOqRgqlls7PEmeIkWwSaY2B8pmL9lnp8ibN3ztUUwmxlXJY8
         OBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750222; x=1772355022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VTSr2egiGZrzh+7+ZlbqD5qhC+A1cnXWqtUesRojnlw=;
        b=Otn1tArM9l0BznUT2/HmlJ1cMU+F0tudNfTFTrZgfG7qf5ZIZl6tB8PuiNQooq841R
         Be6SMHApbbR50Tt0lK6X7oZ4vNAHKK04qVEVMEOl3nhiSxkfJE3/6ncXig6j4y7fKhWW
         V6YrYaK7QOa5W17drupz/ONGCQ21gGaaCYkYyhQ7f9d0TzaHFvodoTRUTa0q5H59QOXo
         9PS98zSMN9YOFBWURmO8bkPMvHp5un9X+bpqRCN4rXUbikBgKLFxPgOQO/+mjml33HAc
         yL01ji1uaiOHyr3fELQBF7QrRLFxD9pMZQsCmzQCj2psTtMKcwnLYIvvTG1HztC3kBYH
         ZsWg==
X-Forwarded-Encrypted: i=1; AJvYcCUq4TbdvuxOhW34+lZb3yyMYrLT9iVI+PRysC0o/k/CYtJ1tRSYr3f+peXT6D8HLlDf7GNI53fPWw==@kvack.org
X-Gm-Message-State: AOJu0YzNsdy+DRusGg3rQh1s2TBOJBPoyDfJMrtjJdvjgLbRtPNErd96
	JD1Lf6k4Ny0CjS51ZTIxGb94mkSmjcSvReBT0kIMN/isVPxQYSgc8mo0qHIUL6XUKsc=
X-Gm-Gg: AZuq6aLv0URT2+KG0+eyo4psjmUDaS02n8UECJTU3KIy9AASJkV8crNo/95mtpU5nC7
	DnrVKPZIrU+DcOHVHTZ+XnKzfsUuDirc8iCpmdstIN3ekoU7vvkxfQ7NlwhAYcFcTF57gyeuH9x
	J3JZhNLXSr1ihWpfafGJ4GwqnEsiSijaZLKWC4AMSF+n0D5nNHg71B3vwq6YJSoqd2f3EUgSQ15
	6Q0rDwebLcdE1jiLoyxUne1jIkT9ah26i/unOGsrmO1460dYruzGhBLnE1FWA3NxWOOKG7fUyyz
	KnJ+C1JNvJA4v0X82FnZNmO53kU/naPCbpX+UtE+Et9SXekt9qVUTFA+PJS2P5DJx2BhH8/7Thy
	T/CHbyZw34h9fBoNUrRWNakcYP4omItpD8PCF62/UuhkZROyVMP2EGTrCX4GB4jEUopY2ysjXRV
	yqNItEgHxjKxw2uelza/32BGqFfP/yLdj8/rUeS4P+BWoR+cPq7kdtnxWwpk+cNr2I7IhjS5PSj
	rFb3cxDhIl7xL8=
X-Received: by 2002:a05:622a:96:b0:506:bc9c:e140 with SMTP id d75a77b69052e-5070bcfa5d8mr76045201cf.71.1771750221945;
        Sun, 22 Feb 2026 00:50:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:21 -0800 (PST)
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
Subject: [RFC PATCH v4 23/27] mm/cram: add compressed ram memory management subsystem
Date: Sun, 22 Feb 2026 03:48:38 -0500
Message-ID: <20260222084842.1824063-24-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: j5s5bqjobcu4ih6cqk9xgo1bn8fugc8f
X-Rspamd-Queue-Id: 0845540010
X-Rspam-User: 
X-HE-Tag: 1771750222-251237
X-HE-Meta: U2FsdGVkX1+XjyST9Y+OkSzf9XAV6XdED7m8hzDOqZYNgjF8NpU/q1xOlHl94eLpnlso54yJ9UAVhQT/8hsb6MmeV+j+stGKxEeKh0G/+ZwN+88CkR2Sx1KL4AoK2iXqe4tVXXttm8Rf3RMIkoClA687R75ea4DkO6ZJIcOp1bWBKQ0VyDG3drIWP2drW/jzR0slcZ02u7tfFGWWCLd8NViZ3F0OI5ZmfYmzw7dePsDnUQvQ9DwKEAfwWfVqRFlwZKKFdANWGalOthass/YNAWlP9XHcmGvtiTVbvWxlZgMD8jgVW0wRimX5V3Mu5ZzbCBx95/kHT0/b4quLF1FS3B1GicvVV9Y5F7pe9IvltqguIKjVgT4zWBzhbevp2uEomuNmXcD4MI+CE9M/W8QbjLQyjukq+5HQ+0WSR8o39nyP/inO6p/4PJjNqCSNAG0vFbOVAtwvPvaUPbGPBFjnzSTrXMnIufys/Ogao3IBatYCCiHmizQtxGsHWbc6VoeDyfBDCV4nroKXLwa5F5jWxV/LL14pV2gEyc7cKJSsqIiF4IZfDPPwOPVStNrNjJ2mTCLW+AvG7uwrzwbiD0BIx5+gUn4WZooAgwU1+MhyQ90O3dSoR1XHcxvRN2ze+8CL/2dTaUA5L9O2E6h4XDf+oz4GoiFALUHfbPstL37GczIOLZ71pwGgdBbHTtLV7gihEgGKr8iZWbxQRGCjFWNUGdt55H2jYlhvSfM/SX0eezwiX6DlQIb7fg2LkEaTxYZ24UwiORgxkystrBb1FsQ14U4W89It9nvQX3hQj3Pi/WrH2boxsfNLe04xZNbV31QQpjp0NP21peR2oGSK2681z2XOtuzAoh8AHyEYDgIL1VfTh211SRQZicHH/bCSA41Zc7HPYoxUazHjXTTFtM16aPYfwpmBp8JGkWF8YWlwfR+OaM59+ikerPmU2h+/f2CrknxuwE/Jx0G/ZgkPDJk
 jRkS8KHx
 4AIeQT5+F6Gq+o0P7lOwymq7tj7Dwmge9h2o5+fDh5oTPg2X/BDqk7y99+H3QFHVALngZ90/ePX9vzZYQj0SafJpGmExN5dPjBKMAjl2vxF53rkTfYzWsfhAqmBM2vkyJKFf3/p1y6LznbPfctwlU4bA2IZaZNoldf/Su/xjErZFNpxXfjaKKtlb3KKiI9Y8NL2RoLM5qZ3KogQxPeEfdFVfJ9k87lruxEMvVt7qaetYduJChsyuXzzTlGo/ssnnDrasJ6qawzaayeFldclSjDvnsMj5DNHo5i+oSA5dZfQ7fzboR9+gk29Y51XtwASAv07bGkl8hS42RJ93OzWnr3yAnU0X1tbKyheRz8jQ6mMYAd+GcK1t9LsagFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the CRAM (Compressed RAM) subsystem that manages folios demoted
to N_MEMORY_PRIVATE nodes via the standard kernel LRU.

We limit entry into CRAM by demotion in to provide devices a way for
drivers to close access - which allows the system to stabiliz under
memory pressure (the device can run out of real memory when compression
ratios drop too far).

We utilize write-protect to prevent unbounded writes to compressed
memory pages, which may cause run-away compression ratio loss without
a reliable way to prevent the degenerate case (cascading poisons).

CRAM provides the bridge between the mm/ private node infrastructure
and compressed memory hardware.  Folios are aged by kswapd on the
private node and reclaimed to swap when the device signals pressure.

Write faults trigger promotion back to regular DRAM via the
ops->handle_fault callback.

Device pressure is communicated via watermark_boost on the private
node's zone.

CRAM registers node_private_ops with:
  - handle_fault:   promotes folio back to DRAM on write
  - migrate_to:     custom demotion to the CRAM node
  - folio_migrate:  (no-op)
  - free_folio:     zeroes pages on free to scrub stale data
  - reclaim_policy: provides mayswap/writeback/boost overrides
  - flags: NP_OPS_MIGRATION | NP_OPS_DEMOTION |
	   NP_OPS_NUMA_BALANCING | NP_OPS_PROTECT_WRITE
           NP_OPS_RECLAIM

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/cram.h |  66 ++++++
 mm/Kconfig           |  10 +
 mm/Makefile          |   1 +
 mm/cram.c            | 508 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 585 insertions(+)
 create mode 100644 include/linux/cram.h
 create mode 100644 mm/cram.c

diff --git a/include/linux/cram.h b/include/linux/cram.h
new file mode 100644
index 000000000000..a3c10362fd4f
--- /dev/null
+++ b/include/linux/cram.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CRAM_H
+#define _LINUX_CRAM_H
+
+#include <linux/mm_types.h>
+
+struct folio;
+struct list_head;
+struct vm_fault;
+
+#define CRAM_PRESSURE_MAX	1000
+
+/**
+ * cram_flush_cb_t - Driver callback invoked when a folio on a private node
+ *                   is freed (refcount reaches zero).
+ * @folio: the folio being freed
+ * @private: opaque driver data passed at registration
+ *
+ * Return:
+ *   0: Flush resolved -- page should return to buddy allocator (e.g., flush
+ *      record bit was set, meaning this free is from our own flush resolution)
+ *   1: Page deferred -- driver took a reference, page will be flushed later.
+ *      Do NOT return to buddy allocator.
+ *   2: Buffer full -- caller should zero the page and return to buddy.
+ */
+typedef int (*cram_flush_cb_t)(struct folio *folio, void *private);
+
+#ifdef CONFIG_CRAM
+
+int cram_register_private_node(int nid, void *owner,
+			       cram_flush_cb_t flush_cb, void *flush_data);
+int cram_unregister_private_node(int nid);
+int cram_unpurge(int nid);
+void cram_set_pressure(int nid, unsigned int pressure);
+void cram_clear_pressure(int nid);
+
+#else /* !CONFIG_CRAM */
+
+static inline int cram_register_private_node(int nid, void *owner,
+					     cram_flush_cb_t flush_cb,
+					     void *flush_data)
+{
+	return -ENODEV;
+}
+
+static inline int cram_unregister_private_node(int nid)
+{
+	return -ENODEV;
+}
+
+static inline int cram_unpurge(int nid)
+{
+	return -ENODEV;
+}
+
+static inline void cram_set_pressure(int nid, unsigned int pressure)
+{
+}
+
+static inline void cram_clear_pressure(int nid)
+{
+}
+
+#endif /* CONFIG_CRAM */
+
+#endif /* _LINUX_CRAM_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af8..054462b954d8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -662,6 +662,16 @@ config MIGRATION
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
 
+config CRAM
+	bool "Compressed RAM - private node memory management"
+	depends on NUMA
+	depends on MIGRATION
+	depends on MEMORY_HOTPLUG
+	help
+	  Enables management of N_MEMORY_PRIVATE nodes for compressed RAM
+	  and similar use cases. Provides demotion, promotion, and lifecycle
+	  management for private memory nodes.
+
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5b..0e1421512643 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
+obj-$(CONFIG_CRAM) += cram.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
diff --git a/mm/cram.c b/mm/cram.c
new file mode 100644
index 000000000000..6709e61f5b9d
--- /dev/null
+++ b/mm/cram.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * mm/cram.c - Compressed RAM / private node memory management
+ *
+ * Copyright 2026 Meta Technologies Inc.
+ *   Author: Gregory Price <gourry@gourry.net>
+ *
+ * Manages folios demoted to N_MEMORY_PRIVATE nodes via the standard kernel
+ * LRU.  Folios are aged by kswapd on the private node and reclaimed to swap
+ * (demotion is suppressed for private nodes).  Write faults trigger promotion
+ * back to regular DRAM via the ops->handle_fault callback.
+ *
+ * All reclaim/demotion uses the standard vmscan infrastructure. Device pressure
+ * is communicated via watermark_boost on the private node's zone.
+ */
+
+#include <linux/atomic.h>
+#include <linux/cpuset.h>
+#include <linux/cram.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/jiffies.h>
+#include <linux/highmem.h>
+#include <linux/memory-tiers.h>
+#include <linux/list.h>
+#include <linux/migrate.h>
+#include <linux/mm.h>
+#include <linux/huge_mm.h>
+#include <linux/mmzone.h>
+#include <linux/mutex.h>
+#include <linux/nodemask.h>
+#include <linux/node_private.h>
+#include <linux/pagemap.h>
+#include <linux/rcupdate.h>
+#include <linux/refcount.h>
+#include <linux/swap.h>
+
+#include "internal.h"
+
+struct cram_node {
+	void		*owner;
+	bool		purged;		/* node is being torn down */
+	unsigned int	pressure;
+	refcount_t	refcount;
+	cram_flush_cb_t	flush_cb;	/* optional driver flush callback */
+	void		*flush_data;	/* opaque data for flush_cb */
+};
+
+static struct cram_node *cram_nodes[MAX_NUMNODES];
+static DEFINE_MUTEX(cram_mutex);
+
+static inline bool cram_valid_nid(int nid)
+{
+	return nid >= 0 && nid < MAX_NUMNODES;
+}
+
+static inline struct cram_node *get_cram_node(int nid)
+{
+	struct cram_node *cn;
+
+	if (!cram_valid_nid(nid))
+		return NULL;
+
+	rcu_read_lock();
+	cn = rcu_dereference(cram_nodes[nid]);
+	if (cn && !refcount_inc_not_zero(&cn->refcount))
+		cn = NULL;
+	rcu_read_unlock();
+
+	return cn;
+}
+
+static inline void put_cram_node(struct cram_node *cn)
+{
+	if (cn)
+		refcount_dec(&cn->refcount);
+}
+
+static void cram_zero_folio(struct folio *folio)
+{
+	unsigned int i, nr = folio_nr_pages(folio);
+
+	if (want_init_on_free())
+		return;
+
+	for (i = 0; i < nr; i++)
+		clear_highpage(folio_page(folio, i));
+}
+
+static bool cram_free_folio_cb(struct folio *folio)
+{
+	int nid = folio_nid(folio);
+	struct cram_node *cn;
+	int ret;
+
+	cn = get_cram_node(nid);
+	if (!cn)
+		goto zero_and_free;
+
+	if (!cn->flush_cb)
+		goto zero_and_free_put;
+
+	ret = cn->flush_cb(folio, cn->flush_data);
+	put_cram_node(cn);
+
+	switch (ret) {
+	case 0:
+		/* Flush resolved: return to buddy (already zeroed by device) */
+		return false;
+	case 1:
+		/* Deferred: driver holds a ref, do not free to buddy */
+		return true;
+	case 2:
+	default:
+		/* Buffer full or unknown: zero locally, return to buddy */
+		goto zero_and_free;
+	}
+
+zero_and_free_put:
+	put_cram_node(cn);
+zero_and_free:
+	cram_zero_folio(folio);
+	return false;
+}
+
+static struct folio *alloc_cram_folio(struct folio *src, unsigned long private)
+{
+	int nid = (int)private;
+	unsigned int order = folio_order(src);
+	gfp_t gfp = GFP_PRIVATE | __GFP_KSWAPD_RECLAIM |
+		     __GFP_HIGHMEM | __GFP_MOVABLE |
+		     __GFP_NOWARN | __GFP_NORETRY;
+
+	/* Stop allocating if backpressure fired mid-batch */
+	if (node_private_migration_blocked(nid))
+		return NULL;
+
+	if (order)
+		gfp |= __GFP_COMP;
+
+	return __folio_alloc_node(gfp, order, nid);
+}
+
+static void cram_put_new_folio(struct folio *folio, unsigned long private)
+{
+	cram_zero_folio(folio);
+	folio_put(folio);
+}
+
+/*
+ * Allocate a DRAM folio for promotion out of a private node.
+ *
+ * Unlike alloc_migration_target(), this does NOT strip __GFP_RECLAIM for
+ * large folios, the generic helper does that because THP allocations are
+ * opportunistic, but promotion from a private node is mandatory: the page
+ * MUST move to DRAM or the process cannot make forward progress.
+ *
+ * __GFP_RETRY_MAYFAIL tells the allocator to try hard (multiple reclaim
+ * rounds, wait for writeback) before giving up.
+ */
+static struct folio *alloc_cram_promote_folio(struct folio *src,
+					      unsigned long private)
+{
+	int nid = (int)private;
+	unsigned int order = folio_order(src);
+	gfp_t gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL;
+
+	if (order)
+		gfp |= __GFP_COMP;
+
+	return __folio_alloc(gfp, order, nid, NULL);
+}
+
+static int cram_migrate_to(struct list_head *demote_folios, int to_nid,
+			   enum migrate_mode mode,
+			   enum migrate_reason reason,
+			   unsigned int *nr_succeeded)
+{
+	struct cram_node *cn;
+	unsigned int nr_success = 0;
+	int ret = 0;
+
+	cn = get_cram_node(to_nid);
+	if (!cn)
+		return -ENODEV;
+
+	if (cn->purged) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* Block new demotions at maximum pressure */
+	if (READ_ONCE(cn->pressure) >= CRAM_PRESSURE_MAX) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	ret = migrate_pages(demote_folios, alloc_cram_folio, cram_put_new_folio,
+			    (unsigned long)to_nid, mode, reason,
+			    &nr_success);
+
+	/*
+	 * migrate_folio_move() calls folio_add_lru() for each migrated
+	 * folio, but that only adds the folio to a per-CPU batch, 
+	 * PG_lru is not set until the batch is drained.  Drain now so
+	 * that cram_fault() can isolate these folios immediately.
+	 *
+	 * Use lru_add_drain_all() because migrate_pages() may process
+	 * folios across CPUs, and the local drain might miss batches
+	 * filled on other CPUs.
+	 */
+	if (nr_success)
+		lru_add_drain_all();
+out:
+	put_cram_node(cn);
+	if (nr_succeeded)
+		*nr_succeeded = nr_success;
+	return ret;
+}
+
+static void cram_release_ptl(struct vm_fault *vmf, enum pgtable_level level)
+{
+	if (level == PGTABLE_LEVEL_PTE)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	else
+		spin_unlock(vmf->ptl);
+}
+
+static vm_fault_t cram_fault(struct folio *folio, struct vm_fault *vmf,
+			     enum pgtable_level level)
+{
+	struct folio *f, *f2;
+	struct cram_node *cn;
+	unsigned int nr_succeeded = 0;
+	int nid;
+	LIST_HEAD(folios);
+
+	nid = folio_nid(folio);
+
+	cn = get_cram_node(nid);
+	if (!cn) {
+		cram_release_ptl(vmf, level);
+		return 0;
+	}
+
+	/*
+	 * Isolate from LRU while holding PTL.  This serializes against
+	 * other CPUs faulting on the same folio: only one CPU can clear
+	 * PG_lru under the PTL, and it proceeds to migration.  Other
+	 * CPUs find the folio already isolated and bail out, preventing
+	 * the refcount pile-up that causes migrate_pages() to fail with
+	 * -EAGAIN.
+	 *
+	 * No explicit folio_get() is needed: the page table entry holds
+	 * a reference (we still hold PTL), and folio_isolate_lru() takes
+	 * its own reference.  This matches do_numa_page()'s pattern.
+	 *
+	 * PG_lru should already be set: cram_migrate_to() drains per-CPU
+	 * LRU batches after migration, and the failure path below
+	 * drains after putback.
+	 */
+	if (!folio_isolate_lru(folio)) {
+		put_cram_node(cn);
+		cram_release_ptl(vmf, level);
+		cond_resched();
+		return 0;
+	}
+
+	/* Folio isolated, release PTL, proceed to migration */
+	cram_release_ptl(vmf, level);
+
+	node_stat_mod_folio(folio,
+			    NR_ISOLATED_ANON + folio_is_file_lru(folio),
+			    folio_nr_pages(folio));
+	list_add(&folio->lru, &folios);
+
+	migrate_pages(&folios, alloc_cram_promote_folio, NULL,
+		      (unsigned long)numa_node_id(),
+		      MIGRATE_SYNC, MR_NUMA_MISPLACED, &nr_succeeded);
+
+	/* Put failed folios back on LRU; retry on next fault */
+	list_for_each_entry_safe(f, f2, &folios, lru) {
+		list_del(&f->lru);
+		node_stat_mod_folio(f,
+				    NR_ISOLATED_ANON + folio_is_file_lru(f),
+				    -folio_nr_pages(f));
+		folio_putback_lru(f);
+	}
+
+	/*
+	 * If migration failed, folio_putback_lru() batched the folio
+	 * into this CPU's per-CPU LRU cache (PG_lru not yet set).
+	 * Drain now so the folio is immediately visible on the LRU,
+	 * the next fault can then isolate it without an IPI storm
+	 * via lru_add_drain_all().
+	 *
+	 * Return VM_FAULT_RETRY after releasing the fault lock so the
+	 * arch handler retries from scratch.  Without this, returning 0
+	 * causes a tight livelock: the process immediately re-faults on
+	 * the same write-protected entry, alloc fails again, and
+	 * VM_FAULT_OOM eventually leaks out through a stale path.
+	 * VM_FAULT_RETRY gives the system breathing room to reclaim.
+	 */
+	if (!nr_succeeded) {
+		lru_add_drain();
+		cond_resched();
+		put_cram_node(cn);
+		release_fault_lock(vmf);
+		return VM_FAULT_RETRY;
+	}
+
+	cond_resched();
+	put_cram_node(cn);
+	return 0;
+}
+
+static void cram_folio_migrate(struct folio *src, struct folio *dst)
+{
+}
+
+static void cram_reclaim_policy(int nid, struct node_reclaim_policy *policy)
+{
+	policy->may_swap = true;
+	policy->may_writepage = true;
+	policy->managed_watermarks = true;
+}
+
+static vm_fault_t cram_handle_fault(struct folio *folio, struct vm_fault *vmf,
+				    enum pgtable_level level)
+{
+	return cram_fault(folio, vmf, level);
+}
+
+static const struct node_private_ops cram_ops = {
+	.handle_fault		= cram_handle_fault,
+	.migrate_to		= cram_migrate_to,
+	.folio_migrate		= cram_folio_migrate,
+	.free_folio		= cram_free_folio_cb,
+	.reclaim_policy		= cram_reclaim_policy,
+	.flags			= NP_OPS_MIGRATION | NP_OPS_DEMOTION |
+				  NP_OPS_NUMA_BALANCING | NP_OPS_PROTECT_WRITE |
+				  NP_OPS_RECLAIM,
+};
+
+int cram_register_private_node(int nid, void *owner,
+			       cram_flush_cb_t flush_cb, void *flush_data)
+{
+	struct cram_node *cn;
+	int ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return -EINVAL;
+
+	mutex_lock(&cram_mutex);
+
+	cn = cram_nodes[nid];
+	if (cn) {
+		if (cn->owner != owner) {
+			mutex_unlock(&cram_mutex);
+			return -EBUSY;
+		}
+		mutex_unlock(&cram_mutex);
+		return 0;
+	}
+
+	cn = kzalloc(sizeof(*cn), GFP_KERNEL);
+	if (!cn) {
+		mutex_unlock(&cram_mutex);
+		return -ENOMEM;
+	}
+
+	cn->owner = owner;
+	cn->pressure = 0;
+	cn->flush_cb = flush_cb;
+	cn->flush_data = flush_data;
+	refcount_set(&cn->refcount, 1);
+
+	ret = node_private_set_ops(nid, &cram_ops);
+	if (ret) {
+		mutex_unlock(&cram_mutex);
+		kfree(cn);
+		return ret;
+	}
+
+	rcu_assign_pointer(cram_nodes[nid], cn);
+
+	/* Start kswapd on the private node for LRU aging and reclaim */
+	kswapd_run(nid);
+
+	mutex_unlock(&cram_mutex);
+
+	/* Now that ops->migrate_to is set, refresh demotion targets */
+	memory_tier_refresh_demotion();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cram_register_private_node);
+
+int cram_unregister_private_node(int nid)
+{
+	struct cram_node *cn;
+
+	if (!cram_valid_nid(nid))
+		return -EINVAL;
+
+	mutex_lock(&cram_mutex);
+
+	cn = cram_nodes[nid];
+	if (!cn) {
+		mutex_unlock(&cram_mutex);
+		return -ENODEV;
+	}
+
+	kswapd_stop(nid);
+
+	WARN_ON(node_private_clear_ops(nid, &cram_ops));
+	rcu_assign_pointer(cram_nodes[nid], NULL);
+	mutex_unlock(&cram_mutex);
+
+	/* ops->migrate_to cleared, refresh demotion targets */
+	memory_tier_refresh_demotion();
+
+	synchronize_rcu();
+	while (!refcount_dec_if_one(&cn->refcount))
+		cond_resched();
+	kfree(cn);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cram_unregister_private_node);
+
+int cram_unpurge(int nid)
+{
+	struct cram_node *cn;
+
+	if (!cram_valid_nid(nid))
+		return -EINVAL;
+
+	mutex_lock(&cram_mutex);
+
+	cn = cram_nodes[nid];
+	if (!cn) {
+		mutex_unlock(&cram_mutex);
+		return -ENODEV;
+	}
+
+	cn->purged = false;
+
+	mutex_unlock(&cram_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cram_unpurge);
+
+void cram_set_pressure(int nid, unsigned int pressure)
+{
+	struct cram_node *cn;
+	struct node_private *np;
+	struct zone *zone;
+	unsigned long managed, boost;
+
+	cn = get_cram_node(nid);
+	if (!cn)
+		return;
+
+	if (pressure > CRAM_PRESSURE_MAX)
+		pressure = CRAM_PRESSURE_MAX;
+
+	WRITE_ONCE(cn->pressure, pressure);
+
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	/* Block demotions only at maximum pressure */
+	if (np)
+		WRITE_ONCE(np->migration_blocked,
+			   pressure >= CRAM_PRESSURE_MAX);
+	rcu_read_unlock();
+
+	zone = NULL;
+	for (int i = 0; i < MAX_NR_ZONES; i++) {
+		struct zone *z = &NODE_DATA(nid)->node_zones[i];
+
+		if (zone_managed_pages(z) > 0) {
+			zone = z;
+			break;
+		}
+	}
+	if (!zone) {
+		put_cram_node(cn);
+		return;
+	}
+	managed = zone_managed_pages(zone);
+
+	/* Boost proportional to pressure. 0:no boost, 1000:full managed */
+	boost = (managed * (unsigned long)pressure) / CRAM_PRESSURE_MAX;
+	WRITE_ONCE(zone->watermark_boost, boost);
+
+	if (boost) {
+		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
+		wakeup_kswapd(zone, GFP_KERNEL, 0, ZONE_MOVABLE);
+	}
+
+	put_cram_node(cn);
+}
+EXPORT_SYMBOL_GPL(cram_set_pressure);
+
+void cram_clear_pressure(int nid)
+{
+	cram_set_pressure(nid, 0);
+}
+EXPORT_SYMBOL_GPL(cram_clear_pressure);
-- 
2.53.0


