Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD134C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8ED6B0095; Wed, 16 Sep 2026 06:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA326B0096; Wed, 16 Sep 2026 06:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE76D6B0098; Wed, 16 Sep 2026 06:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAE436B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:19:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23AC11C2A3F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:52 +0000 (UTC)
X-FDA: 85219229424.19.2B89B1F
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id E910E100002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789553990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIKkUgFUHc/kA+HyHJNa+WYH0NL5ruB1FurJe1WtOA0=;
	b=XxwoqGtzflG+SfkPeNgYDx1RYoqka0HdEgvcyIV23EoF1jKxKGQYvRDxbXvOvn97nOEC+q
	xm2nSYg4gBOVtnYOE3xTK4SGxCdCSibQuAYcIbKEwU7JJoci/4VIFaqEVC0fh3VvzG10UM
	/JUZ1ZLyIWW7BNXktkRQO4Ngrgk7w4c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789553990;
	b=lvaf6dGOIyjMN77IJpRV2OP12xMhl4L1d3U5WdOs4WYE1+B0rPvC78xEOxAtspEIGOFox5
	C8yst1KWRCcrEOgacWbuKEZza9cnaVq+7CNmyQaYuY00EBUbr+g1NWPZxS2oZvaogoawgP
	e9h2FfvrvETljPv3XJH6tjjilX3tJUM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a96bfd4b4d4e7194;
	Wed, 16 Sep 2026 10:19:48 +0000
X-Mizu-Trace-ID: a96bfd4b4d4e7194
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
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 02/14] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
Date: Wed, 16 Sep 2026 18:19:09 +0800
Message-ID: <20260916101929.149106-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8kpbfro7ewyktmfhykoqzwoer5n5cuxw
X-Rspamd-Queue-Id: E910E100002
X-HE-Tag: 1789553989-99363
X-HE-Meta: U2FsdGVkX182Z2a/lGYhInk5bLODG+col/kM63V8flRaoefoDWQy0ssPJd5EGwD408QrsBXMnhEyQJpPzDqgWp/OIxHL20uwjdFkH9I8QILmq7rS9MC/Wj+2LZpwpXF3L+dAoKnS9yXlo+ZdAlvNQPa96DSd5iYsjuFPuJTiHLYo7GiUlQPmtfGL+K6i7WxbyHQf3fjNenr6fJhyq69SHIIDck5KY+gnOMvNC7Xq/1n1OMBFI+0VxQhcOd/6Om3dNxQMPpwR7tnjjD/A0Og48WtakI+CWDIeTBrJn2BGs6S5bJo66WX+gXo2WtaShXi2otnVaSuj9Rw+jIP2Uh4zmzOZ1Imc54xg5T1zw9B7bndo36sg0S6PMmKJcQJaGPjzgs9HzC4zeie6BmmJ6hGiuopFi1QQmdc4bGsLVX0AhuL99TYp30Di/uDrMamSTkLMjoT/sH1NmEaKn/0BOzkA83PfwhVPjToel5l3BReQSxvR+GoD0U8IpHJVZ+cjsuYapRI2ACrVaUMoDWNlOPXUj+LGcD9evk/Eb67YrUamf+9YWPq7fuZst/hmBZBA1+K8GcGUplZ8pdfblU2uiLPfgR+ZfeexDhUQ9HnyAEZ+Y3GMzZKhheIxsXHxs8IRYX1KBomU/eWev1+saZ6Zb9NWUmR5wW3ucae/Z5vRgmWN811yaiRGl0Gz4VrYa6cJ7l17SYoMuh34BLl9JTMEUZQpSk5/IT0RcPkOVtUqzR91vJCDwFAyfpXy1HVc+iC3J3lPhw56Sod4TX8iGfMOaaMcrJXkBMZQJ9RQSTV0raIsUgXVx6ypWsp9gqAo1L9U+dVdibg7P1mUsQeKanY6x0Tp/E7Jlqcomuly1NUhYZ+rj4h26XyTXrOTfGzhtHJFrB+1ofdwp6CiSjFfSqkLjceChDRL9Ffjy3xytNrDZEsOY/dUgH8qIpsLneUMjRKXKNv5NCKDambKl+btCwAopvs
 NDyxClfR
 yptg4P9pzM2qR/DFZVL9K8KSDovrwbGayewDOPbrOhj1h7KNy7iBhJEVvJ8cDJHDLFESYeq9Kqe1EO/LJ5IvK2XV2cHX7CIseKNnoadqgKeJVdwrD/m66+QHPdSD8kRG9iq8ITCyi3MHNufzfAPrUhz9V5Kjll+lkTB/mJJBYiogfkcQOElCtq4cDhBM5QO3clCrAaY3fIU4PgTyrj7l4YtqAbtzPbugQ39Of45cOuSYngQBOGdiQhSciVB9E2qLomHWu6/LPPWeNyuy6JiLI/yj0aBbUNGddQrVIXFPwmmMdJe+6EEwcDxdQjvGFJkf8+hTP6SxNkUP4ObW7ji0GiG4kAKEdcycHXHDi
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
index b4331ca4759a..b7882aac1eab 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -242,6 +242,11 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
+#ifdef CONFIG_XSWAP
+	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
+	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
+	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+#endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
diff --git a/mm/Kconfig b/mm/Kconfig
index c180d40cd671..5d6c7845c422 100644
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


