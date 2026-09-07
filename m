Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA1BC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CE26B009B; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7936B00A1; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EBD6B009B; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F41486B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:14:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90FCDA06CB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:08 +0000 (UTC)
X-FDA: 85186404576.03.B85F780
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id E07A840002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788772446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42a8F7io/6Zh/Q/VtOBdUl7MJZ2a8UML1HfPTPTVzyQ=;
	b=WsZ04C8RjZZ5fnHIBGgp/15Y2C2a5z3ZRkoWJxjNvt03j0RAcwAQq18UDnb1vSsa04iKPS
	8tqvrJUWhWo8KDQv+c9cJQezuh9dqxa1scdKlxKQ3Zu5V3oP8iwrvFYlvhnfOZhA2EzJxH
	ZoTSbm8AJW6lczxj9b82mcQX2wT5WsI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788772446;
	b=uJPpVvnJTc/Dasy5dfXjZxWaeZ236ZbWQO6JuGsh2X+JHG9y/weqzdORGf+pDMyuYUY1oZ
	Ly5kUWBbAhPD6MJCDjAiH4VtE/H28TYcFC1uJ2zyRyBK5q5CMBkWj8MJRQFvdeS6BmUkqn
	nVBdP6VzXkiP3BlZZYOjRc/uT1qC3W0=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hdhDr6NYZzKHPQ1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:13:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D6FBE40561
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:14:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgCnZbNWgJ5qMElGBA--.7816S3;
	Mon, 07 Sep 2026 17:14:00 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v3 1/4] mm, swap: Fix potential NULL dereference when trying a sleep table allocation
Date: Mon,  7 Sep 2026 17:13:53 +0800
Message-Id: <20260907091356.53026-2-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260907091356.53026-1-shikemeng@huaweicloud.com>
References: <20260907091356.53026-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnZbNWgJ5qMElGBA--.7816S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF4fXFW7WF1fCFWfJF1fJFb_yoWrWFWDpF
	nYgF98Kr4rXr9xWrsxAw1Dt34rWw4ru34DGayxGw1293ZxXrWkWFWxAr9xZF98CF97Jryq
	gr1jgw17uF4vvwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbn2-7UUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Stat-Signature: 47giutx1usituitstx6seddeeqrayg7r
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E07A840002
X-Rspam-User: 
X-HE-Tag: 1788772444-170512
X-HE-Meta: U2FsdGVkX1+awrVhFhghE6FMevYZUAlHliC3vxzenKN39BKf2THpGZYNYcJQA1G7aj0Dn6WgoNLHkFtqMsREyFVN2HAwY7N/nZgovSVtoQwkz3vY3BP0KWg4KRIBNV14wj8djAEQIPVKG3r295Qvi4oerpYuvmbjH1nDCPTbkgK7dA2cLELix0nHMing0Cq0txak5J9sUIiC0ctfucHTbMbn8ZIiQFHd0DZKCi55VeOvwvuMt8IsU5wfz29AY4dCnsN5npF5Zk7m5pWsGET7CKNvLnS5KqPkworJAk0NMoVlxl6bG6NR8lhgvJnrsLhAblah+emo+G5yZjFdt5mxf2PV+m9SxS8Wk94GUPekqYs0NZQpv5vMNJ4uKbSJnRH4zcZBYtzL8NKe0oMKSdLftK501JfXUMVy65cdMY22+BH8yIYVDdZADwhf26SsAm8JkgsN3kPeXAnrHIKrhvbfeqeVnaZmBpwgqlR9vBxQbABmj96VFBJrjjk2Ybyu5Eq1ur3vdUrpSmuJ35HHbu/ygMBqCvDxlchB2cmoqGwoMggtbafkQXp8eb7xc6YcXa/e0+BLE1m3KnsuGhpDY/gdA0yfV1kcAunzf1WrvrQAXVw3gf0WCSMJ5zVcfm4DdS7ItzcvQ86A5JegiEnbLPWicHqhedbObMY66hd3Kav78f9K3YTuBIO9vgVh1Ay+4q+Xv42GWIVvHE6weUFJHiHa0eOpE/OdPT2wOpJlZIAkDI2ZilQzF0Qi0cIn8zco2IUCT9F/bZ8hgx5H3tUgualOPEcMM6F9ygJZImwWyNFkL3tqWKEZku+pQSyFjKJ6GZvL6h0DLZpLZvpAbYUNIRlx24Ask2Zub7riFDHGoLC+YvRZmAyzM6diLwdwauEYZPrkKVb12WGf3FO/w8BYs58sm3e+yYeJqWAAAxZWo+WEyuusk4pflQgvcoeVQx3vhzuSdCwqpJ5JOdVRWYLFc/B
 irNROZ8r
 gLsFpco6Y2NBJd6MjUz1iYmgGcXhxqrJgRBvFA+ug2vEzC1jl9NOxiBBkCUeWPkMRwkrXAmBabGuw7Fms43tkhcsbEUOBeRLaZYf44dNjaidwJv1h0D2UvuT+Kaogn42QVwQl
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

Since memory order guarantee between ci->table, as well as between
ci->table and ci->zero_bitmap, fix the issue by making tables
visible at the end of swap_cluster_populate().

Current memory order guarantee is as following:
On write side:
rcu_assign_pointer(ci->table, table) will offer release to ensure
zero_bitmap and memcg_table visible before ci->table.

On read side:
folio_alloc_swap
 swap_alloc_fast/swap_alloc_slow
  /* ci->table: protected by cluster lock */
  swap_cluster_lock
  cluster_is_usable
  ...
  __swap_table_set
  ...
  swap_cluster_unlock

 mem_cgroup_try_charge_swap
  ...
  /* memcg_table: protected by cluster lock */
  swap_cluster_get_and_lock
  __swap_cgroup_set
  swap_cluster_unlock

swap_writeout
 swap_zeromap_folio_set
  /* zero_bitmap: protected by cluster lock */
  swap_cluster_get_and_lock
  __swap_table_set_zero
  swap_cluster_unlock

Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 mm/swapfile.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53bf01d5f7f1..45b6154f85ad 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -418,6 +418,17 @@ static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
 	folio_put(folio);
 }
 
+static void swap_cluster_free_count_table(struct swap_table *table)
+{
+	if (!SWP_TABLE_USE_PAGE) {
+		kmem_cache_free(swap_table_cachep, table);
+		return;
+	}
+
+	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
+		 swap_cluster_free_table_folio_rcu_cb);
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
 	struct swap_table *table;
@@ -437,13 +448,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		return;
 
 	rcu_assign_pointer(ci->table, NULL);
-	if (!SWP_TABLE_USE_PAGE) {
-		kmem_cache_free(swap_table_cachep, table);
-		return;
-	}
-
-	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
-		 swap_cluster_free_table_folio_rcu_cb);
+	swap_cluster_free_count_table(table);
 }
 
 static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
@@ -466,14 +471,12 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	if (!table)
 		return -ENOMEM;
 
-	rcu_assign_pointer(ci->table, table);
-
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
-			swap_cluster_free_table(ci);
+			swap_cluster_free_count_table(table);
 			return -ENOMEM;
 		}
 	}
@@ -484,9 +487,16 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
 	if (!ci->zero_bitmap) {
 		swap_cluster_free_table(ci);
+		swap_cluster_free_count_table(table);
 		return -ENOMEM;
 	}
 #endif
+
+	/*
+	 * Make tables visible to cluster_is_usable() after everything is
+	 * ready.
+	 */
+	rcu_assign_pointer(ci->table, table);
 	return 0;
 }
 
-- 
2.36.1


