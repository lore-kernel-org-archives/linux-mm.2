Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613B8C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B226B00B2; Thu, 27 Aug 2026 05:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522256B00B3; Thu, 27 Aug 2026 05:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4382D6B00B4; Thu, 27 Aug 2026 05:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24D0C6B00B2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4069A035C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:58 +0000 (UTC)
X-FDA: 85146570516.09.1AAEB30
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0F3A80006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787824017;
	b=JyLKeOqlDnyUfpyrrLwiZ60kf7IH7kAxq6eHPSInbOPB8lsnBW8ghaGdBgDmCxwopuEztU
	GxJOeZFyzzb5TA4p0y4wBlGo4/JVoD6HrUOQnMvfb5bYlVOV02Hz/uGSR/4Q2IpFzgObTP
	3qDmsuQzu610GNq5F3+72e5LyTU/6Gs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPa0kRGbKwae+hODultCrLUVhSuhnf3mKHB5P2hSoL0=;
	b=iWUT9X3S0zEsHesPRhJUeBftSTTHISrgWxbpcidVtCq6wQ/iWndiuQ10/a5UfSHg5O7jHM
	4wcKIFyKs5QmUmQW96vAcpL6/+DyiH7ikyU9HoOQCmpkIIvbVk6MPjepeUFz5ila/ausnB
	1qHBUqztzMYwBIMRLUAPfsoK+g73bmc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dc4479b2fc1e8339;
	Thu, 27 Aug 2026 09:46:55 +0000
X-Mizu-Trace-ID: dc4479b2fc1e8339
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
Subject: [PATCH 16/16] mm, swap: allow setting xswap device priority at creation
Date: Thu, 27 Aug 2026 17:45:06 +0800
Message-ID: <20260827094509.1016740-17-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w53ioq8zp8p6jimexjmcimzazjiqq7c3
X-Rspamd-Queue-Id: C0F3A80006
X-Rspamd-Server: rspam06
X-HE-Tag: 1787824016-799792
X-HE-Meta: U2FsdGVkX1+bnSj1m6PdNO5wtm4WPlumNJmS0VC44JfoYRrKhpaZNIjqPi9U+NWf5qTrbfXoDulZX2tNVMVewzHY8+Z9gKGv91zpZU69uSMOU7806xCEsYyfVii9E7LGrPFQOF0Ry+QXoL/o73XOu4l+qNHXEO2zkLVk+7yvohqUGgfOqNcacwHxzIBDt9M7IJccOIjR0ozF7vKFD+yfMnAQ4GLMWUFuIg2W67mZvlpAvRGHPE/9zLNqZZAsXSURPSoBbzMuhn8Tz6gm9G5C+PklkNDUcGxkBSTnyGXu14h48ahl5sEwTup1Olox4ESNwBSm1/BkxV7DdAfVlfYPoILnXY5Gg3nKskjPacXtOzaW+wHQsrHmyxHzr62QuvqsnOY/lSg4+VMSaE2lAA4dttHL4MOvz3s5z7fgun0nGobajKWBVIE3+XzwsXJlg/20tK1/5CFcHySWMbu5PGbDHXGoJ6P74Pm/hGd4jZnrZx9hFOaF14qKHYkIU/ZGLGdO/rWRomqrb9pIvvAElsSwMQPPilw4NycV9He/EbmUWMXbO9XZIbysXi/K8G7mMXfTdBZXrF/LtKuWpfBUm22ik7pD5zebLUGnUmRKvNh3uehcUxfMmFM5CG2cxlEx5tYy08JLkuF7v1y9h5hvX+UeeiQTry0q3hXq+Dgs0iOgq3/XkFjHEv41sf3GfdacVeKe0sDcKca7ta6kYKFxhbLw4oUaNjj65psiMdKUIi+ckC+QLs285/V9X5yD6gJ2M0bxhqIC6OZqhw/ho6xmahPSYUwds/G9TW5jqvbloAmS7MFDY9Zq69WV/OmN9iJy+CEiQAzIQDKqe/yotEoGDFbXKqIn3tTELhqHb/ZoPxzHgGoqz5+egWTApE5TkCkKwWvOoXTzISA+njS1jNXHfq080OVgfrIDsA7sYGGimHj1lXSaoXqZNCuZEAHNJYWdkip9t7E1fwY15aqOlR2kA6J
 lwtxZDD3
 t7coyL0xDJcbT8aHdw+c6EJ6LVoP58LKbUWV9z5o2I3824d6l9G3lXJHC4v3GJdnUUYrHEzaHokdIDQRLmAv3a2+OQZYizZzkKiWr+1W2q8jz7wE0l0b+amIWuXkGXf6NDbiB88vB1Zy5QX397i/BVcrgvooeA+9Y4sTFnk2gpBrpAnhafjLbi60WHZ71qQhAPVl90R8pAnbahiMgEpAKWZvnZEE8SvMtdh0o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let the create interface (/sys/kernel/mm/xswap/create) accept an
optional priority:

  echo "<percent> [<prio>]" > /sys/kernel/mm/xswap/create

A missing prio means DEF_SWAP_PRIO; and permitted values are
DEF_SWAP_PRIO or 0..SWAP_FLAG_PRIO_MASK, being consistent with the
swapon(2) ABI. Like a regular swap device, prio is set once at creation
and is not chnageable whne the device is active; use xswap_destroy
then create to cange it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ae0c549cc9aa..258b52bce438 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -52,6 +52,8 @@
 #include "swap.h"
 #include <linux/debugfs.h>
 
+#define DEF_SWAP_PRIO  -1
+
 static DEFINE_SPINLOCK(swap_lock);
 
 #ifdef CONFIG_XSWAP
@@ -159,9 +161,11 @@ static void xswap_debugfs_del(struct swap_info_struct *si)
 }
 
 #ifdef CONFIG_SYSFS
-static int xswap_create(int percent);
+static int xswap_create(int percent, int prio);
 static int xswap_destroy(int type);
 /* /sys/kernel/mm/xswap/: create.
+ * Write "<percent> [<prio>]" to add a zswap-backed swap device; a missing
+ * priority means DEF_SWAP_PRIO.
  * Per-device runtime size is tuned via debugfs type<N>_cluster_limit.
  */
 
@@ -169,21 +173,25 @@ static ssize_t xswap_create_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
-	unsigned long percent;
-	int err;
+	long percent;
+	int prio = DEF_SWAP_PRIO;
+	int nr, err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	err = kstrtoul(buf, 0, &percent);
-	if (err)
-		return err;
+	/* "<percent> [<prio>]"; a missing prio means DEF_SWAP_PRIO.
+	 * %li keeps kstrtoul(buf, 0)'s base-0 behavior for percent.
+	 */
+	nr = sscanf(buf, "%li %d", &percent, &prio);
+	if (nr < 1)
+		return -EINVAL;
 
 	/* 0 means "use the default percent" */
 	if (percent == 0)
 		percent = XSWAP_DEFAULT_CLUSTER_PERCENT;
 
-	err = xswap_create(percent);
+	err = xswap_create(percent, prio);
 	if (err < 0)
 		return err;
 
@@ -275,7 +283,6 @@ atomic_t nr_real_swapfiles;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -4340,7 +4347,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 /* Create a file-less xswap device. si->max = full RAM; @percent sets the
  * runtime nr_clusters ceiling.
  */
-static int xswap_create(int percent)
+static int xswap_create(int percent, int prio)
 {
 	struct swap_info_struct *si;
 	unsigned long ram, maxpages, init_clusters;
@@ -4348,6 +4355,8 @@ static int xswap_create(int percent)
 
 	if (percent < 1 || percent > 100)
 		return -EINVAL;
+	if (prio != DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
+		return -EINVAL;
 
 	/* xswap has no backing store, it relies on zswap. */
 	if (!zswap_is_enabled())
@@ -4391,15 +4400,15 @@ static int xswap_create(int percent)
 		goto bad_swap;
 
 	mutex_lock(&swapon_mutex);
-	si->prio = DEF_SWAP_PRIO;
+	si->prio = prio;
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
 	/* si->swap_file stays NULL: this is a file-less device */
 	enable_swap_info(si);
 	mutex_unlock(&swapon_mutex);
 
-	pr_info("xswap: adding extendable swap type %d (%d%% of %lu pages = %u pages, max %lu)\n",
-		si->type, percent, ram, si->pages, maxpages);
+	pr_info("xswap: adding extendable swap type %d (prio %d, %d%% of %lu pages = %u pages, max %lu)\n",
+		si->type, prio, percent, ram, si->pages, maxpages);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-- 
2.54.0


