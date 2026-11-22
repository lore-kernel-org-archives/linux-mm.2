Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3769606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sNyiml/z
Received: by kanga.kvack.org (Postfix)
	id EBA5C6B05CA; Sun, 22 Nov 2026 07:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91886B05CB; Sun, 22 Nov 2026 07:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80A06B05CC; Sun, 22 Nov 2026 07:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A58186B05CA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F8C81A06A7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:41 +0000 (UTC)
X-FDA: 85462734042.20.D752C92
Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34889A0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sNyiml/z";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351719;
	b=YMsGEhFjUPjD9EytFnbuT2NfMjv+XxdE1ZkIHNgxmUW1pTmebGw0BK25BY4F6MR7deOiwN
	dcfqoSVff3mhYxVAuXnOCjAREV5D/1tWr60/QMfQrbDvSxcH5JqqFQbdvLOZph3Qm6asdu
	wQiLEar0/KoMa/+Zwpf6H+EuKcx7rxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5mb4gMdHpZJzXBSqlC9XMwKzG9tss4cXHWRmV8y1PM=;
	b=KJMVVdM19vWK6NQN/VeeMafB2LBqsdd2kVHb2F5i+IwscbzjpyPzb5RCp75UGmvDLMOubb
	phYOQHmv68uJYcZLuUtk76+OIRI49SoN0G+u4dT2aeTWJoVK/iavlr856DkhOkpbTcqqIP
	dED40FDji6b22faBle9dTdGaUYTveA4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sNyiml/z";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.109 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YOz2z0C4QkUvUxcWScNP+zuGI/wOQjQ7nmeOF1TvXg4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351714; v=1; x=1795956514;
 b=sNyiml/zpkM2ycBaiGQXFs1ayJPtXjwyrTEnKxG6llJrRwUZKcX4Y8HU/WEcnwXiZRBuiZy6
 iOk/e5J0FgjQsMETuhXw+HBVLaWWDQdGrZ8+42U/3VZAI4QIjNJmC/bmVYRAPk8X+7Hs7YOXG5Z
 CnrArj2vjC2WGLVeaUEgHggA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6a9c451795a40c91;
	Sun, 22 Nov 2026 12:48:34 +0000
X-Mizu-Trace-ID: 6a9c451795a40c91
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 12/14] mm, swap: add debugfs counters for xswap
Date: Sun, 22 Nov 2026 20:48:12 +0800
Message-ID: <20261122124814.3489077-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122124814.3489077-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122124814.3489077-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34889A0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1hj5ruxq1wz89oouypz5fthxgampqfsr
X-Rspam-User:
X-HE-Tag: 1795351718-920294
X-HE-Meta: U2FsdGVkX18yry+Dkcyiq9EfVNFravU3efw0UDUHabCIi2l2FCA+jHmHRI2IsSkpY86QvVt67+ZbLlSYC35Nhw4vBwN02tYNvt2l+RXQEy9jwINIXkgWmwb0PaQqcFMkeNlFINn/tqmcOfwZQMEhfY5pLbrDltfdPgCjZEzQU+RBwOIpZtjmybj4qSDsMtAKqgu6kE/15os10U4gQ1yrWRqIR9ZYaFFoHrev8s554g9CZTWAg6mX8KkEaAb5EW9YqdTuyXox0hnn5+tIVRomT1eYS7FudGk0PGVtyYuECqEFjGPnwyBNcRTdT4z7u7wgFN/7tJLfnhpj2I10tzRPEvFQEs8BYwQqFNTyXDINyRrAD2E0UIZ5yqfn88VsN5hIPi/1Pygz3BQ0JZ6S8wjnevygHiCIcv+8TwjNRgG64j/s9kOouDf9qofSxHI4Lst64CsnwOOhiG+hl7C9bE7Zd5AQL/I5JGLCzfYHfgltmuMDeQyGHARMTqvgkmaY9Cus1p7N82/j6gqmql9WPslFII979Kt7IiiupED5/41FwaLrAcOsIAwX5wMO9Dn35v8Ojk+Y+cIRBdX+9AhojE4Ie1p+DvyqJdIw+LZFpO/Odg3utsC+saWf02QvDp9IglW3qvG6wU2WwcvWv0wLpNEgCOq/2uyUibP1+n/as+haiu3QdyUZdiCK4SlbxO/6aIowGhdaI0NyVHAC2xuhN1pgPdE9zqBGdEeWclcrKdrMP+HJNA+xEmHqp+MVNFWj2jd445ES9Kw9SN/DyFowrjgw17cWMNJqvxrSzqZ1xeQyB2wOSRomNshVKiXcNgQVh8Sdb+JuyncdEJISG275df4c1Gv2Ce+7T+dLstrc4vKOArmzBWC3VAUeyIE+mvP+fg9hhpls5/PH86Tsd4Qq1juttZl9x7x/TMAdxah1BGw6RveSY725/5sSRa2jCCT4uYfb8L/bP5pGbioeG/ruZpR
 Fn0gcBhO
 puTfkIrnKsouX0Akoj1KM0myVEjSOT1V3SjeT+TCIsNp44p16nil8nszxsAl6y38Wk8wmLu2DmZngjPuXuhIK68kHX8UJ5gGydMpgGetj/0Oz2U9UYUtpEjs35TCnv9lFnUIYgkmQS8RRTnj1q0BCLqwE3pRtPb4ctwxUatE+qyjauhOdIXyKn8ekzh+O/ghtwJLC4RWy/CT+zaVf/RfWfTRiiKhAwYtZdHg/o1NS0dL3VAfgLolpV+pbVOV05D9qY4WzKFCyc3i7F6boBbshv95QLO42Vz4/Z51JoVkRClIHuDH1uPCiSkewx7mZ2X3VtjjPLpXV2FWg1DA5ea1PNYPC4ockFtO/LKgVjrxnpTnLFiPIck5FKf9KQBDKQhuCnbSbeyxpVDSWvEW+hkt432QcFOo9OSZRIbudMSuZ9F0GremUZSaR3KuftsRFKPtFxeoKpYq4JF3bFp+8b44xeAi8kvs/aiPoHShzhb0GT8eu7RKTG6q3OXZs9NBWkczOOZQZN7WtpRGFhFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

The mapped range and the grow count are not visible from userspace.
This makes it hard to check if the grow thresholds work: we cannot see
how large the mapped range is, how much it grows, or how much free tail
it keeps.

Put this information in debugfs. It is a debugging aid, not a stable
interface, so it does not belong in sysfs or the ABI:

  # cat /sys/kernel/debug/xswap/xswap.stats
  type 0
  clusters_max 2038783
  clusters_mapped 255
  usage_pages 91456
  tail_free 16
  grows 3

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 69 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5d9e5b6f2bd6..9daf0ac40c39 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,6 +246,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
+	struct dentry		*xswap_debugfs;	/* mapped range and counters */
 	atomic_long_t		xswap_grows;	/* grow operations so far */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 213b66bb1d6d..462efeef887a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -43,12 +43,14 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/debugfs.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+
 #define DEF_SWAP_PRIO  -1
 
 /*
@@ -79,6 +81,7 @@
 
 static bool xswap_should_grow(struct swap_info_struct *si);
 static unsigned long xswap_grow(struct swap_info_struct *si);
+static void xswap_debugfs_del(struct swap_info_struct *si);
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr,
 			      bool link_free);
@@ -3455,6 +3458,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 			}
 			spin_unlock(&ci->lock);
 		}
+		xswap_debugfs_del(si);
 		vfree(si->cluster_info);
 		si->cluster_vm = NULL;
 		si->cluster_info = NULL;
@@ -4087,6 +4091,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	mutex_unlock(&si->xswap_lock);
 	return 0;
 }
+
 static bool xswap_should_grow(struct swap_info_struct *si)
 {
 	unsigned long mapped = READ_ONCE(si->nr_clusters_mapped);
@@ -4138,6 +4143,68 @@ static unsigned long xswap_grow(struct swap_info_struct *si)
 	return nr_new;
 }
 
+static ssize_t xswap_debugfs_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct swap_info_struct *si = file->private_data;
+	struct swap_cluster_info *ci;
+	unsigned long mapped, tail = 0;
+	char tmp[192];
+	int len;
+
+	/*
+	 * Count the free clusters at the end of the mapped range.  The
+	 * xswap_lock keeps the range from moving under the scan.
+	 */
+	mutex_lock(&si->xswap_lock);
+	mapped = READ_ONCE(si->nr_clusters_mapped);
+	if (si->cluster_info) {
+		while (mapped - tail > 1) {
+			ci = &si->cluster_info[mapped - tail - 1];
+			if (READ_ONCE(ci->count) ||
+			    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
+				break;
+			tail++;
+		}
+	}
+	len = scnprintf(tmp, sizeof(tmp),
+			"type %d\nclusters_max %lu\nclusters_mapped %lu\nusage_pages %lu\ntail_free %lu\ngrows %lu\n",
+			si->type, READ_ONCE(si->nr_clusters_max), mapped,
+			swap_usage_in_pages(si), tail,
+			atomic_long_read(&si->xswap_grows));
+	mutex_unlock(&si->xswap_lock);
+
+	return simple_read_from_buffer(buf, count, ppos, tmp, len);
+}
+
+static const struct file_operations xswap_debugfs_fops = {
+	.read	= xswap_debugfs_read,
+	.open	= simple_open,
+	.llseek	= default_llseek,
+};
+
+static struct dentry *xswap_debugfs_root;
+
+static void xswap_debugfs_add(struct swap_info_struct *si)
+{
+	if (!xswap_debugfs_root)
+		xswap_debugfs_root = debugfs_create_dir("xswap", NULL);
+	if (IS_ERR_OR_NULL(xswap_debugfs_root))
+		return;
+
+	/* One device, so one file: /sys/kernel/debug/xswap/xswap.stats. */
+	si->xswap_debugfs = debugfs_create_file("xswap.stats", 0444,
+						xswap_debugfs_root, si,
+						&xswap_debugfs_fops);
+	if (IS_ERR(si->xswap_debugfs))
+		si->xswap_debugfs = NULL;
+}
+
+static void xswap_debugfs_del(struct swap_info_struct *si)
+{
+	debugfs_remove(si->xswap_debugfs);
+	si->xswap_debugfs = NULL;
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
@@ -4360,6 +4427,7 @@ static int xswap_create(int prio)
 	 */
 	si->ops = &swap_bdev_ops;
 
+	si->xswap_debugfs = NULL;
 	atomic_long_set(&si->xswap_grows, 0);
 
 	error = setup_swap_clusters_info(si, NULL, maxpages);
@@ -4371,6 +4439,7 @@ static int xswap_create(int prio)
 		goto bad_swap;
 
 	mutex_lock(&swapon_mutex);
+	xswap_debugfs_add(si);
 	si->prio = prio;
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
-- 
2.54.0


