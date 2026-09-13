Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B00C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE766B0096; Sun, 13 Sep 2026 03:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890BB6B0098; Sun, 13 Sep 2026 03:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD596B0099; Sun, 13 Sep 2026 03:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 550A16B0096
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:50:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0EE616060B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:36 +0000 (UTC)
X-FDA: 85207966872.07.A91A038
Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id C7B0180002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rjZ95sOBowjHoyZMjlpuXCzstFJWyzcBeaSx0gcpGtA=;
	b=133O8n9Kav2R6B/4Z7K8xtp1qJIiLfx/foT3l72v9noryUtqha7COfDkJ5JGU7hCxwU1zm
	HWD3HhRGnjC7lVEaFRS7ekGTZxsepQe6sna3z+VBmylxyCecxEZe/EpuvvVtIdvADDyj35
	3KVa63yqGmY9cApnCSbxc0CSbXeMcfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285835;
	b=6VU9eWk4rS9q5f44he+fhrs/pejof/x4N/K2yZNXKapPblqYId3ULBCI3dqODm0LrGl8vf
	6eZ/Aqj8rC5d1uiZvhKQHru9+rQjz9xzU2O3arVbzcRVMfUus98dWJrUVhNivJwnoUPCON
	6vcWBQP+9/zu4uhfKQpzFIEn2fBxBgE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4fad34b801982382;
	Sun, 13 Sep 2026 07:50:33 +0000
X-Mizu-Trace-ID: 4fad34b801982382
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 02/12] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
Date: Sun, 13 Sep 2026 15:50:04 +0800
Message-ID: <20260913075014.1732524-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wwc97ieres15g7yxss7c7m1qf655both
X-Rspamd-Queue-Id: C7B0180002
X-HE-Tag: 1789285834-31354
X-HE-Meta: U2FsdGVkX19wRSTlebnPX0Qmyvjjvg5k1JuB6XgXlQh4SCqSo6+P4ivlFnAUEg0juX5nFhScn7fQ1DKLdYrIIfqdMv2QzwKVWT1Fuhj6K8G21kfgAS3/UtScGNMT8Krerpg0Wanh5SNymoXa69T7rCiXeA9Ly4qTTh+JVDlKO4x/UoH1G07cBCuNPz7+SctKUTNS9VW4i/A6SXVn+8Px9CMa6DuJWVEp6FSKIAZwT9xRyQTb6BlO5udHUSAsA1PMKAUzQXWqsx1LkOC30jLJYsMc7w1uOvID9eBiduL0jM4V0AjAqoj/4DHQKvaQcfhTkTu68++UKRP8gU5YT5dlcSbiupsrt+f58w1o2oLsSUYtzY12lETS0+/78uV7AT4U2C948T5GP2ZT8CHB5xbBaYyPjJRw3d+ajEXMO6JMShLoOaF/bQhusqGKDHBdjkjcFzNDxJGSOpNJEf1m4yZCGFcFqK+yxQltT4EpYZvcgxcYjhiL687Jrfz0cq8AQwcLzqxpfoJAC2y63qre4dwfWnV3I6/Twf8Tz1W4J1V/taYeXWItZa4Y4Ni9q67RQBOs4qX6BZyJtUsyYQGQhLyrOksH8hdnE/3Ihi3o4vX3oaGhIqLS+54o392aPPy3hDDA2dGFoj0Jz8Sg8+S/qW/ZDXP7Pi1FdQ3kUhZzYkw65LgVxfqKEV8NsCiiemxwLlXm96spsJPC53Y9qO+zJjVV4meP+lUNyLqLprATYCGq81YM3DtgBTRoc+HHeQ13bzPPrar3yOJ+YXJZUqygEXpGMmjdFXDZ40494UAREnWjRyrDLKIMnDj3p1QNaR/GV4MQWdujWsRzCZBgUFYlqsLlF0+Cao2i1ZtMveyfvCdjO1+78OqNOgPIdn9Q9W+bikU36qsRhlkzkG1za5E7vSVeGhoD/yZYtIvQbn0I0HiprpZSYXqDUIJTNSk9Ol1g6j4uZ5mzrCDcsP9O9VCj5Gh
 CoCwUjVD
 HRKiFv/sE9q7B1pmDAEPgkT1pftn8RstnNMzqg6Osl02GvceR9lhHz1zBnS6Ifg9wvzU25UKivD0scwIXJyY7rNk2Uonwx2vsxqJfFv1xGpLbmK49dUrhtjuQwKdK8TaAdUH3Hel0gOBEwwotKPDLeLUXuzAsUKjNmi/rUnKR5hVMaSLtCAe/Fmb1h7A7XYb6bK1D35/5hqU+7nQ34udy3GVn6UcxyIHy4LXIWMN/6wErasv5ABPhNuz7Y25nnTjc58/qycrbcFArFIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add CONFIG_XSWAP Kconfig option for extendable swap device support.
It depends on SWAP && 64BIT && ZSWAP, since xswap devices are backed by
zswap, and on SYSFS, which is currently the only way to create one.

Add three fields to struct swap_info_struct under CONFIG_XSWAP:
- cluster_vm: the VM_SPARSE vm_struct backing the cluster_info array
- nr_clusters_max: total number of clusters in the xswap address space
- nr_clusters_mapped: number of clusters currently mapped (lazy grow)
These fields enable lazy vmalloc-based dynamic cluster management.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h | 5 +++++
 mm/Kconfig           | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 787fe463dcbb..09ecef1b5e90 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -248,6 +248,11 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+#ifdef CONFIG_XSWAP
+	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
+	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
+	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+#endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..e9837c0f5d8a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -122,6 +122,15 @@ config ZSWAP_COMPRESSOR_DEFAULT
        default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
        default ""
 
+config XSWAP
+	bool "Extendable (virtual) swap device"
+	depends on SWAP && 64BIT && ZSWAP && SYSFS
+	help
+	  Adds support for extendable swap devices (xswap) that decouple
+	  PTE swap entries from physical backing storage. The cluster_info
+	  array is backed by a sparse vmalloc area that grows and shrinks
+	  on demand, avoiding static pre-allocation overhead.
+
 config ZSMALLOC
 	tristate
 
-- 
2.54.0


