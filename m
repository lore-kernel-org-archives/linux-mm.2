Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A84C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550EE6B00B4; Thu, 23 Jul 2026 03:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB8A6B00B7; Thu, 23 Jul 2026 03:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8DD6B00B9; Thu, 23 Jul 2026 03:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F39046B00B7
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:49:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55D4AC0427
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:07 +0000 (UTC)
X-FDA: 85019265534.09.1F2F640
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A42B20005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:49:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KkVqvoLP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3cMdhagcKCN8KZFTDBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jyescas.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3cMdhagcKCN8KZFTDBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jyescas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784792945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yaa4cCuGB/KMi/unBxDmfPea8S92ERyZzt4MyrotbI=;
	b=tHVbrMGWzJzz2nwcWwZin+LTy/wY13WH745Zjl1pmUdpgcEoIuyu9pKmjINVUzbTnMOOCS
	fJWBtDWzEIATiC/n/JxiFdWEhkUKxY1ufpi+xoKF5klY1mibXUDlnlIL4vkvVfRqaLSDGq
	0zCsVnOFvE3OMqsDyVaI51AZEAFjeZ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KkVqvoLP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3cMdhagcKCN8KZFTDBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jyescas.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3cMdhagcKCN8KZFTDBTHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jyescas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784792945;
	b=UsK0oWm2RO4AOFCJMPYzOLljuviWnNeV21cwMTh9xaloW8T7SkJT9tiZaERIzxt1dHyaRQ
	M7lUPLqRbOWA0xfOD5LnR7aiLr0iYWquMOOMRhDwVraa3mSFSo4asanwT6FBLPPsLnR3kV
	+xWAyA/0EOcCLalxtiLG1k6tkD1Rr5E=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cce14a21faso3028705ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784792944; x=1785397744; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6yaa4cCuGB/KMi/unBxDmfPea8S92ERyZzt4MyrotbI=;
        b=KkVqvoLP2ob4/pZFyVLZJ/5YmDU3uuiQPuer7cNxQ46aPDfRmnV9ldfwjlcCpgI+1s
         COUv9PcwmGY8c0A0Odqc/2QJMNZJNI10t0darZNmP8Iqkw2oJXBz104HaXowYtb8Ys8q
         jhbiqgj3o4wP2DYgAjMu8FhuGMcX567VZ1sPrcgj+Ko40Ib7l567BMOPhAU42N/yMw++
         L7zoDgbDlDTQNmhEp8A8M/poc/OoyAnhklpyAo6XtQpuqy6VOzMQAQDOxqU9i4v6+8rD
         aYzH0XyWm4dtn7xlUtmkIuYfGOraAZ7lFh84F6Tc9bg/xSS8LM+3QUxecRCZV7Lg+pbB
         627Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792944; x=1785397744;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6yaa4cCuGB/KMi/unBxDmfPea8S92ERyZzt4MyrotbI=;
        b=XCflP63h0Q3DjaNgKFgR1fODrYGv2hrO+SUw0+LNtW8FL+Hn7+KahYw0ICP5hElcpu
         okbZM+W+MoU7/os0nHqj6tc3OFiPtRAykYRqkuZ9pumbjgsmBkEvSRQ7k25A9AFYbnu/
         9o1fMXNGbuPPmivHyXllgQ7NgCdV8aeIQZj3Gy5S4oaRqsx0UfeP3VaRtfV/zkRjZ5ZE
         SMZ1WnOzchc1ne3p6+dJ1ap/ddjArZMUoGyQeVmN/MQFRXBDCmh2stkRkRf4jq+hLjse
         bi2a9o1kvx7hjplRkKjrLE/00C1Bj8KYlp8QN2Nc1t+Qk9ckTyMjIrgr0U8u8XGvefBC
         QayA==
X-Forwarded-Encrypted: i=1; AHgh+RoznPiNDDsMlXg4N1eG0rlC6yxM5tlQlY8E9gXDccR9tvjhmqa9yiyzA3zrTUJbQoojCH3fbKlkSQ==@kvack.org
X-Gm-Message-State: AOJu0YxHFFZtVcLt3rwDw8w6ZuoU8Z3UaQushoTf0Es1dRbirGO4R+AR
	EfH8yT7dhhkH/QlVGq4Pz6VsS1NFVRvtjr1wyW23zSLbuEj1kccly0A9xQG7kqGPfywP3/4Oe0x
	76kP9z68rBw==
X-Received: from dybnw12.prod.google.com ([2002:a05:7300:e70c:b0:311:5a71:d53c])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef04:b0:2cf:b23a:3e68
 with SMTP id d9443c01a7336-2cfb23a415bmr503015ad.25.1784792944076; Thu, 23
 Jul 2026 00:49:04 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:05 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-2-jyescas@google.com>
Subject: [RFC PATCH 01/16] mm: Page Alloc Hogger module
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A42B20005
X-Rspam-User: 
X-Stat-Signature: tunghj94gpyiwzcixipj7ukc9hdsx3g9
X-HE-Tag: 1784792945-249128
X-HE-Meta: U2FsdGVkX19J0HVv2VwvYYYNjKfJk5q1hVkcmJKEjnVDINSkR3fRbxmFciNDWh4DR7kVDWDvwaehK9SEK2Kieqs/h9JpH4xMj7yxaO50+b6+qH1VojQPr6QsyhLSAG1JpJHD84t57usOc4b9Zx/Wr2jsj3YfzFSkUFSX3bfHI4RzjngkN3ofdX7fK4gEWJgZQJUl1Ais8X+Yd9gvXCSMg4FV8APT0Moe5UkT4EbDzbDz7bO8AT0OVRiKPLF614llX7Y7EmdJNfmf08XGEYQtX9YQXPgBRq4BS+SHVPE3Xn5zlhIEkTqCkX6wEF94V3ltfssvLETYdvc7Av3xfZnUpC4VXN24f0fOhTEKSbVcxe9RvFL3ztXGoUz4wZIcX/8NK5la3bsCG6b8tyUpshcIvwce5Hp+GLCt9h7p7ruGCZhdu9Evs84JcVSDg6yShRJO9ukzDkcE5cEO137YoCo+6g4wv4DW6xjv1tVp/WZhcSyowUVhJJk5yE+HVN+/kkE5IFLU3SS6GnNV3NqZKrWhafgrdtnvQQ1A6bl1vqhvart1kudVk5Xsyr0D70+OPaa4biLbNvm9cfwQxs4KKgbJHU3uJtuvhBoxwCyAN7aWR1fbtigeQhczHIqVDN9gGKiz822hi628kLuQDTXvjPXumRvA+wT7mT9in44MRJTRj6ioz80rvJruaawsSAcTconIRJGOdq7wki9NBVsmqFL9E5uSleUiKkSMqYXKmD2wAdiWzn4NMvRevRm2TugiBmZ4xCxzJAD6IPgEyAhUZ0pe6xyKvgdX+gV7OIWu0Kqcovy/8bqPfMLBD72xXMjh97I4q9XbXFQ9vcMWLKMgbk9uAIIJMB4GwdpttU2ohkbAMxbPI8DDhRjmUSqKmSg7VaY89iSzuZanLTLZ3geFvdlAfb8pMeSoZzP2S1/Y/5YD0hGwsXBMHKsQZzU2gYSsP5CUGEwaXNmdIU6kK5RIKKf
 rcjYzDdZ
 7RVPocQDaE9fbL+R59qvGyk/SSGoAGQcae/xeKMu1RtgTsm86HLYSVYxltAIGtGxQzbRfcOqQAo+MgoLUNcD2UBqEnvneCUILWJFMqGjb2D3XJTxw/P/qypKUL/M6Dar/EdNAOtXV01+tewPxhRkfq/NREpJh3EAUYeQccLlnXIF+taqUVJnUA2oBgGuT9VqoNjbkU1rOYd40w1ujxsOxWQhFTS0Ydt833Gg2F2vGwHhEf/sXnhS730KTG9KhVageUZ4Ve0xD4lN8KIJfPt2Tcbi0+SwzX9wc8y5qBo4Yw8q4ieTUHyrWDMgdoou1PzksKGpUBOKQWwHZp3yB5rFGcu1ZUaej4zqgHTrwFf/5xzoh+PZq794l8pkmy3rdnF6HloWFVn49cD3jdXzpLuM+TwLKKrVWt6cctNmNkqosWlxm9ecBH5iVShnIrRMEnZqhme4AIT2DB2MbXacOnJCZzYsAEluFVFo6BXeOBf7nK8VUZrIAxc+ko7wmjHabHf78ucCWwW9wqKXGBgHwxdvuJXjmVA1f9bXSdSJJMjv1/s1+r8wqOdTE7NCEUCfTU9JMFMvZvjrWqPZHWLKPgQSe7LWVPimxpMOUC6RrwncuBUlN3mYD2WBtCsc1IHVt+WDuxXJKO5upUSIiq0Kw0hn0ycLS6q0k4yottssC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch contains the skeleton for the Pagei Alloc Hogger. It creates the
"mm" dir that will be the base directory that will contain the "free" file
and the "node-<x>" dirs.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/Kconfig.debug       |  12 +++++
 mm/Makefile            |   1 +
 mm/page_alloc_hogger.c | 115 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+)
 create mode 100644 mm/page_alloc_hogger.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 7638d75b27db..c8fcecdca6ac 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,15 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config PAGEALLOC_HOGGER
+	bool "Alloc pages from different nodes, zones, migrate types and orders"
+	depends on DEBUG_FS
+	help
+	  Say Y to alloc pages from different nodes, zones, migrate type and
+	  orders using the debug fs filesystem. This helps to generate memory
+	  pressure easily. This is useful to debug memory reclaims issues,
+	  OOM triggers, page migration issues, etc.
+
+	  If in doubt, say N.
+
diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5b..b48f2ac6ee80 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -133,6 +133,7 @@ obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
 obj-$(CONFIG_DEBUG_PAGEALLOC) += debug_page_alloc.o
 obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
 obj-$(CONFIG_DAMON) += damon/
+obj-$(CONFIG_PAGEALLOC_HOGGER) += page_alloc_hogger.o
 obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_ZONE_DEVICE) += memremap.o
diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
new file mode 100644
index 000000000000..dfdc2ee2eafe
--- /dev/null
+++ b/mm/page_alloc_hogger.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Page allocator DebugFS Interface
+ * Author: Juan Yescas <jyescas@google.com>
+ *
+ * This module allows to make page allocs per node, zone, migrate type
+ * and order using the DebugFS filesystem.
+ *
+ * When this module is installed and the debugfs is mounted, the "mm" directory
+ " will be created in <debugfs mount point>/mm" directory. Under this directory,
+ * there will be subdirs to select the nodes, zones, orders and migrate type.
+ *
+ * For example:
+ *
+ *      /sys/kernel/debug/mm/
+ *      |-- free
+ *      `-- node-0
+ *         |-- zone-DMA
+ *         |   |-- order-0
+ *         |   |   |-- migrate-HighAtomic
+ *         |   |   |   `-- nr_pages_allocs
+ *         |   |   |-- migrate-Movable
+ *         |   |   |   `-- nr_pages_allocs
+ *         |   |   |-- migrate-Reclaimable
+ *         |   |   |   `-- nr_pages_allocs
+ *         |   |   `-- migrate-Unmovable
+ *         |   |       `-- nr_pages_allocs
+ *         |   |-- ...
+ *         |   |
+ *         |   `-- order-9
+ *         |       |-- migrate-HighAtomic
+ *         |       |   `-- nr_pages_allocs
+ *         |       |-- migrate-Movable
+ *         |       |   `-- nr_pages_allocs
+ *         |       |-- migrate-Reclaimable
+ *         |       |   `-- nr_pages_allocs
+ *         |       `-- migrate-Unmovable
+ *         |           `-- nr_pages_allocs
+ *         `-- zone-Normal
+ *             |-- order-0
+ *             |   |-- migrate-HighAtomic
+ *             |   |   `-- nr_pages_allocs
+ *             |   |-- migrate-Movable
+ *             |   |   `-- nr_pages_allocs
+ *             |   |-- migrate-Reclaimable
+ *             |   |   `-- nr_pages_allocs
+ *             |   `-- migrate-Unmovable
+ *             |       `-- nr_pages_allocs
+ *             |-- ....
+ *             |
+ *             `-- order-9
+ *                 |-- migrate-HighAtomic
+ *                 |   `-- nr_pages_allocs
+ *                 |-- migrate-Movable
+ *                 |   `-- nr_pages_allocs
+ *                 |-- migrate-Reclaimable
+ *                 |   `-- nr_pages_allocs
+ *                 `-- migrate-Unmovable
+ *                     `-- nr_pages_allocs
+ *
+ * Usage:
+ *
+ * 1. To trigger the allocation, navigate to the debugfs path corresponding
+ *    to your target node, memory zone, allocation order, and migration type,
+ *    then write the requested allocation count to nr_pages_allocs.
+ *
+ *    For example, to make 3 allocs of order 9, Migrate Type Movable,
+ *    Zone Normal and Node 0, run:
+ *
+ *    $ echo 3 > /sys/kernel/debug/mm/node-0/zone-Normal/order-9/migrate-Movable/nr_pages_allocs
+ *
+ * 2. For each allocation created, a corresponding file named sequentially
+ *    (1, 2, n) will appear in that directory.
+ *
+ *    $ ls /sys/kernel/debug/mm/node-0/zone-Normal/order-9/migrate-Movable/
+ *    1   2   3  nr_pages_allocs
+ *
+ * 3. To free the allocation, write the allocation file name in /sys/kernel/debug/mm/free.
+ *    For example, to release the 2nd allocation run:
+ *
+ *    $ echo 2 > /sys/kernel/debug/mm/free
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/errno.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+struct dentry *mmdir;
+
+static int __init page_alloc_hogger_debugfs_init(void)
+{
+	mmdir = debugfs_create_dir("mm", NULL);
+	if (IS_ERR(mmdir)) {
+		pr_err("Unable to create mm directory");
+		return PTR_ERR(mmdir);
+	}
+
+	return 0;
+}
+
+static void __exit page_alloc_hogger_debugfs_exit(void)
+{
+	debugfs_remove_recursive(mmdir);
+}
+
+module_init(page_alloc_hogger_debugfs_init);
+module_exit(page_alloc_hogger_debugfs_exit);
+
+MODULE_AUTHOR("Juan Yescas");
+MODULE_DESCRIPTION("Module to alloc pages to generate memory pressure");
+MODULE_LICENSE("GPL");
-- 
2.55.0.229.g6434b31f56-goog


