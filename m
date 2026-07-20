Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD17FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC5B6B0088; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C336B008A; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A946B008C; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26F2C6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A06081C0996
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:52 +0000 (UTC)
X-FDA: 85008290304.08.A5E458C
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 915D91C0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1MDZeBS4ncnLHoTGFfX2XlxgiJx3/3BVJ97UUXUi8ss=;
	b=iCjH9aH6x91mk9DimCmI62xMea3mcTTncbvKwUicWXoZU3yVzORe5vSkbzu28cp6wiN5ya
	o5x10N2GX8trlTMzzmesR+7QvalzWktLN4aS9sF1dryw97sUDgRhLcMfMRhNNidne56USI
	/pF1f/AFzmGebwFa/HJBT34FhXC8KrU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531630;
	b=EvFeU4+xKwjcB1dg9D5d/00NkTgBxLPg+6XNIK36XZaxWjyEbZeqZLASFkslfySc56vYFt
	Q7TQDshTREmqM8g/dBfIjaRpGbpGF0aPqYCO746U1MtZbookFFloqHHgNf4lIJg/AHuiJm
	15Ibmgy0CUrlmlmKPtSrYLR7ngGIHSM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h3WvM1QFTzYQtrj
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 660E64061C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgAX4qKnyl1qax5+Bw--.27530S3;
	Mon, 20 Jul 2026 15:13:44 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mm, swap: Fix potential NULL dereference when trying a sleep table allocation
Date: Mon, 20 Jul 2026 15:13:39 +0800
Message-Id: <20260720071342.50742-2-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260720071342.50742-1-shikemeng@huaweicloud.com>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAX4qKnyl1qax5+Bw--.27530S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF4fXFW7WF1fCFWfXF4kCrg_yoW5XF1kpF
	9Yg3s8Kr45Jr9xGrsIy3Wqq34agw40gryDGw1xGr1293ZxXr4xXF1DCrWYvF95CF1kJr90
	gr1Utw17ua1q9wUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUHc_fUUUUU
	=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 915D91C0007
X-Stat-Signature: ynzrippyuf48mwygsjhgrqewo1caoh6g
X-HE-Tag: 1784531628-241218
X-HE-Meta: U2FsdGVkX1+eZ4LAwHrWdN8AJ33xhTwOnQD+5n134MFWX3TSdVPOU6sdUdqJegG/ld6fDs/8XLwd+42GfuZHh09QpDK9Ikn7pk3fO8YVv8WYQzYo44YKOvzPxTLdAuSJ5JzeCQUkysyr1+r46jv3xNIKF9+YbnsKC6aQXxEojv++LrpeBT1vvsXQTC7Dv8FbdlIa0d1z6cCYL0vT54MBM1blkua5MbOeLCR5zUivFdo2ZTrZTMDvYH0Vhb7g8ULHvPP/AL+OQOHOKVE6BPKsaiNHcBqe84TqM0w5hPhMkDWNJ5QN/gMitBEUZIkN/jMkHSqv557mIrdkoKOV1EzUWR4dGL4PMFXXEGEp/8K/A4Xpc982k5T6qWNWmQCb2BG8Otl7gjm/vBwcpx4a7HWWbkt7iAbxYEN2xbmYbEBL7wOzly6pgrkNJBqyHzZ44NIWDlkWkjZAkoWLEtTQ18KSEnH1MVBIx+6hYBv324U47bZbXleBLz3aHLV5mTQrUvof4kNX1H3k7voYFXPZJJ4A83eUcfo4R5G9F/ZoHvKlnLjUJEjoteZbsxhlSIsfenBgJRPHL9leR8R3UdKf3LxPHwQekAozPP4K5jlIIxSByVz5O26bCOADzk/+IJtpXQD2oCj7y/wKn1t1YfTUtlR/9jf0lBQ4ksO4x1R5dw5Lx2tqDxcYDBYWgrk/IHECgsbDogkO08fRxK7ZfqF7zz84gVslvfCu/etpY5dPGdn5PmTzHiu70GbeSO8AkKv3HWYmGYAWSFeK0UeRkOcnE1M0MHFIQcFd+9hGkdRNnf7agp7i81J1G6JqFAZt82dolYw5ZY1bk6sZthNxyme4ZKpXWeHwvH8X6PvBjps6vA+FyUCVCXVR7gsa3x7siUW2szSBtLkvD4Tkv0yq/naILguMnEuUfgghckwOtKLgWsaX6zm14p0A6hgP/J3QusrEvz0cnDL60SzgQ3tjKxzwhs5
 NyUNoqNq
 /LG8JFQplVJpiHb5AHU09NAG25r6lG5wPY2ZggSxeikLvPRcSWxejesvimX8O+xzD2OEwBayFRUBYH7cusSMtDK076rFw68hTR2M1va0ujyKiMbrgGtywkK/AHs/BNzz/zoMn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The root cause of this issue is because multi-tables are updated in non
atomic context. To be more specific, the issue could be triggerred as
following:

swap_alloc_fast         swap_cluster_populate()
                         /* Try a sleep allocation */
                         spin_unlock(&ci->lock);
                         swap_cluster_alloc_table()
                          rcu_assign_pointer(ci->table, table);

 ci = swap_cluster_lock(si, offset)
 cluster_is_usable(ci, order）
  if (!cluster_table_is_alloced(ci)) // ok
 alloc_swap_scan_cluster()
  cluster_scan_range()
   __swap_table_get()

                          /* free table when more table allocation fails */
                          ci->memcg_table = kzalloc_obj(*ci->memcg_table,
                                                        gfp);
                          if (!ci->memcg_table)
                           swap_cluster_free_table()
                            rcu_assign_pointer(ci->table, NULL);

    table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
     atomic_long_read(&table[off]); // NULL dereference

Fix the issue by updating allocated tables in atomic context.

Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 mm/swapfile.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 615d90867111..d29062d9c3cd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -490,6 +490,20 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	return 0;
 }
 
+static void swap_cluster_copy_table(struct swap_cluster_info *d_ci,
+				    struct swap_cluster_info *s_ci)
+{
+	rcu_assign_pointer(d_ci->table, rcu_access_pointer(s_ci->table));
+
+#ifdef CONFIG_MEMCG
+	d_ci->memcg_table = s_ci->memcg_table;
+#endif
+
+#if !SWAP_TABLE_HAS_ZEROFLAG
+	d_ci->zero_bitmap = s_ci->zero_bitmap;
+#endif
+}
+
 /*
  * Sanity check to ensure nothing leaked, and the specified range is empty.
  * One special case is that bad slots can't be freed, so check the number of
@@ -527,6 +541,7 @@ static struct swap_cluster_info *
 swap_cluster_populate(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci)
 {
+	struct swap_cluster_info tmp_ci;
 	int ret;
 
 	/*
@@ -552,7 +567,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+	tmp_ci = *ci;
+	ret = swap_cluster_alloc_table(&tmp_ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
 
 	/*
@@ -573,6 +589,9 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&ci->lock);
 		return NULL;
 	}
+
+	/* Update tables in atomic context */
+	swap_cluster_copy_table(ci, &tmp_ci);
 	return ci;
 }
 
-- 
2.36.1


