Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C918EC55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE6E6B0093; Wed,  5 Aug 2026 21:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFE76B0095; Wed,  5 Aug 2026 21:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07BE6B0099; Wed,  5 Aug 2026 21:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC8C6B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:11:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D131A068B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:12 +0000 (UTC)
X-FDA: 85069065984.05.9DCB5A8
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id C593440009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UMlWQYmc;
	spf=pass (imf01.hostedemail.com: domain of 3Ld9zagcKCBY5K0EywE2AA270.yA8749GJ-886Hwy6.AD2@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Ld9zagcKCBY5K0EywE2AA270.yA8749GJ-886Hwy6.AD2@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4V9Y8fDSG8MVV4W0n0bDz/rhN/ammIKgNJCb1TELSuA=;
	b=ZC1SzrDY8K18CXsMygT9LCHo/CfGazpkU6tvqPNiTAczBtuc0JPgCzH6GFQp1WPIxIYx9L
	lP7WB27/MCvjNVEaGZRMBltW2y1Okb7IlCFhxs9Mb2GHpJxFSuw3g3uv+PmGahnUhQP1Se
	iAcStqte9unBheQo87OXAvc1zI1bRRw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978670;
	b=lE4yj8RYXft8rUBg6WpsZDzyq+qWlq7tfAX4OBE3Zs/hxn+3pY52gC6ANmm6wpIugQJ8p9
	/6yyeftlYxDDe8hVUxA3YpWj0xWR4cyp6t7bomSmU/Jo+smPrFkkrveSuUcUhlywOXnbNa
	4xHPkPGMAUBIiqM1g0d53Law5AgqAKo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UMlWQYmc;
	spf=pass (imf01.hostedemail.com: domain of 3Ld9zagcKCBY5K0EywE2AA270.yA8749GJ-886Hwy6.AD2@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Ld9zagcKCBY5K0EywE2AA270.yA8749GJ-886Hwy6.AD2@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so2165059a91.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978670; x=1786583470; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4V9Y8fDSG8MVV4W0n0bDz/rhN/ammIKgNJCb1TELSuA=;
        b=UMlWQYmclqAMtwvhJCvUlZ8qBIQbvZEU/dDWmSEQ7tA3oF3XxY/PxiO+K5mehiCEnW
         YbUcHhUS2/t/sXZ5KxbzbZiuRWGNomyudv0HM+tK92McuM9blvm3A6teyVFD1DAKAkxL
         a3huqXizRudTGF/Lye4Ix0ooUy2eSywbRXnvM96bFWqtP07+1xakdwiJY/REbJESzV4X
         ziVLE2SRKK6DMJyG4bRAuvedM2dwrnGDYQBjZhgzyE3dQV8KusPPFUogYXRXjYGsQclm
         +tqAIacDaWby5pJIcMVcty2gmAv5QXnoNe0c+MnTiPCe/jKJfmc8P72tLAK0paNXRA2P
         yhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978670; x=1786583470;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4V9Y8fDSG8MVV4W0n0bDz/rhN/ammIKgNJCb1TELSuA=;
        b=NVW3yWd7qV7bVban23HhnpU10zhkTmg9IlMMCZ8KPXaFjCwlXBz0SpgSEdGgYZMOx3
         L7ac3JfBOw6czJRzX+GYZ4msPmPCgTdTzLwesW/j6NCit2z7yY9bIc0rFmc9fmB8kFB/
         ComOZnAro2j8MMg7ZtjvbPhUU2rkfNPwX8wtIbZ5DUk8edjg/wVHGjKOf5aSsaVLUHjk
         uGc6UIKAqE4Mz53kVQQ58PH+K3XB5Gjj9Xh25ZaBGj/6h/waS9Qo7FJybk9YAMqImCMN
         vKCA611kC74ep1cVD4lFLpyOMdrSxw0CJc7ip9ziwV7OKvNpu186pRF6TvN54Gz59v01
         a66A==
X-Forwarded-Encrypted: i=1; AHgh+RqudJNc+L3wdgySInS/bb0fRJSy+X46F49ymfTedjjRkBH9JeR7r0mTSk09+tcTiISQf5OwE6TkdQ==@kvack.org
X-Gm-Message-State: AOJu0Ywc+y8bfZ4BwPUAYHjAuw893YoLLrN7sNoZWE9e9yJ3k92FmR+h
	HdpICMh9rgCJGiNMVJZT7WCvLXyIkJOFv6P7Qdg/rLpm9V62lCbF2hWpolXbwR+6OQR9AtdlckS
	YJzQxkuVXsQ==
X-Received: from dly27-n2.prod.google.com ([2002:a05:701b:205b:20b0:13d:1da6:85cf])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d84:b0:381:5bd6:eb19
 with SMTP id 98e67ed59e1d1-3903c5dfd9amr10541054a91.18.1785978669221; Wed, 05
 Aug 2026 18:11:09 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:02 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-2-jyescas@google.com>
Subject: [RFC PATCH v2 01/16] mm: Page Alloc Hogger module
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C593440009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jida5xxi1np4dquof59h5i8zyiq7gth4
X-HE-Tag: 1785978670-640067
X-HE-Meta: U2FsdGVkX1/h/HdphFgUMIu76zTGSFYYKJ5/G1OURS9IMmLpN05K/rXSrKx+FS1mmOTtAVxMwRscwe0eedRRoaGWvKZWufkQ5P8pRpuK6fZBVvBsMuqodlJmGDvBDq5FOoNScxVbmVnTBCwncHDQmGKp802JMBxe1m9kHrZ9RwFW86nO3SDt3qzVNXJ3cjf8hQ91ZAokS6O5LS1myv6iPA7ZvJw+IAVDNac4I3ikNwrZEVR6el3SpeUNhAs0+1S+zTwToRMqoBLS1Yaevy0mmixvo7Rk/lULNWMXFLmmG1OzbB03aQhAxkMUQ0I9o0WpgBDIeCHYh8JzC28nc7qjRZjK3ELQzjoh61OVMWLZhsFPiPqOgfhc0Jx7eBnElYyfQ6OTsyoAGhE+qnMXPIffk0PbVcear+N5UJaMiFmAWTRnozjWdRTMlq11aHo4UM3fkZA48JIP5ma0DySGCi4mN9JLn1FNYM6+w/UOScyuCb2SSQHrYj3dN86gY4f9UFM97kBXpgptSfuaZhmkCbSZW+DffaDLbpeG2PZ+7Ha2ted0hHcHReGRMHFp3EDHK74tKq9+gOUJZGFNzxz7rkxMQ+z25oGm8KDn4mys+WuvSnmRlLJqgcDUBOU5n5sR23qaPKVCQfv+9aUGbalheymDweWw2mtiqmPFRkrmp6p1qpWqc7he2oGumdb0/jSw64nrWtj84RUKurhsv+7xPh4UtcDpuUlEyYYDzIjdcSXoZBdgqfG8U0+UEw3bUGyO0vm7v0XqR4tM8M8Lwrim/vA19Bgj2iM0Kqs2me208mxm79YH8jtvlwHT+xEJQfWlH6lFAyeDZRi1OLEfhiA5OtfV8Qfj/2O3gQBagy7MQy9EJMulWCFBxMfq/5vs2IE6PMJpXD+Hh2F2YcebEF35pZgXjGMF7N0s+OZfjNRkvnx9oF78/mFsVbV13B5gW3etFtViVI3hx2Ekdt5RRr3tB2c
 2xOaW/WQ
 pjKmoKRZyOZNehlJZJM/0NZDhErwbRv0uxkUMcU+/OGNxSfY0EYRjwfYs6iYysQ5QrxFi/OkUiHihcvmvBT3vPKbPE9cMA6bS+Lo7pfxh5/FMBDcU5cUuz/FOd7IMoV/SnUde9Gm3KR7p8kXABZ+GMCVlSxHAXrZi5WLZnT7Z3iK1xUp1BIIw5dnavNghitDuyqg0ADICyiLO2wvEwRj1xVasdP5TORs8+4MNiEQW+1Z28H0pTHK/qiFi6hub5XkdYEGWuwHKEInAqmgTiKgpVQE6ulbJkiGZWP89cuTw6zhrc1QhyenYXZv/3lUeamHn/pcQ/B6S6AOkxUK9QRSmQb//SJNTwhP0oQWCfpXIgPBN8/fMfL9+I94enqwpNYFoQBhTXJ8sfJ26GGtS/MZl0lKT54FjzFrgp6OoZqxiaiGeaoQPAXTuLWrqEWAELAXqm4Qa9XFQxhWDoPMhwprnxlLkU1Sv3Q/5jgZmiyYntfW2B+RmvqVBEXMYzK7m/mRuDj7cB/UyQUGQvDv5h+iNqFJ2cGDqjtNMyf6UYWgw5mo12JO2jksIGd77Srjq4d7FS93l3z8rOkSEgS2kMgO2RhwybFweXIv0X2yPBFqfv9xcF+AEFePTjpFKX8ld5uNcAcenB85FJ5roExot1vyWkizUr3tyOFWUKhs4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch contains the skeleton for the Page Alloc Hogger. It creates the
"mm" dir that will be the base directory that will contain the "free" file
and the "node-<x>" dirs.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Change to a tristate module.
	- Fix typos
	- Use static for the mmdir declaration.

 mm/Kconfig.debug       |  12 +++++
 mm/Makefile            |   1 +
 mm/page_alloc_hogger.c | 115 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+)
 create mode 100644 mm/page_alloc_hogger.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 7638d75b27db..bad8a606152c 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,15 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config PAGEALLOC_HOGGER
+	tristate "Alloc pages from different nodes, zones, migrate types and orders"
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
index 000000000000..1d31e981920e
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
+ * will be created in <debugfs mount point>/mm" directory. Under this directory,
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
+static struct dentry *mmdir;
+
+static int __init page_alloc_hogger_debugfs_init(void)
+{
+	mmdir = debugfs_create_dir("mm", NULL);
+	if (IS_ERR(mmdir)) {
+		pr_err("Unable to create mm directory\n");
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
2.55.0.629.g250fe7f194-goog


