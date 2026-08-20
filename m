Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA71FC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8143E6B00A0; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700CE6B00A2; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5533F6B00A3; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9366B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE8F31A0115
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:16 +0000 (UTC)
X-FDA: 85121492232.02.8F5B19C
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4D65C0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787226915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C/kxv2l64N2dsUb7Izh2onZ3qGsefs2ZruKFvbF65WM=;
	b=UFnJYgBkYB16AOQ3j1SnWYti/h1YGpFO6/8cCTldaTaozVuzBzgnUqko4AHfEcfcXw8pLk
	GqdT1Dr1D5/ytmQ6Mm/2PSFmiqBf0ZOKo9CDW0mHxyzAlHxg2frfs0MIsf+JvMchAVxij6
	npBrsJwzl8+Jjb0a4oPMqFNQC1Y4pOc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787226915;
	b=mU7/xJiTW2ylFdM4lZ7peHr/fOYGfbXgPy162MY/t6jZTJy8qHND1LRSHxmWhYcGoBYaCY
	+iJcjut5ftbv7GWWMHH32HQBxm/5nDJRBRTLWxzNMZ5wfwYbm8ZtWhrrPYhAtu4hpyTYyU
	RRVGv1qm+GlZpysn16zy+o7OsrVG1WU=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hQhgf4bfyzKHMPB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:54:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4F9F84058F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:55:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP1 (Coremail) with UTF8SMTPA id cCh0CgAH99Ib64ZqI3IEDA--.64911S3;
	Thu, 20 Aug 2026 19:55:09 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 1/4] mm, swap: Fix potential NULL dereference when trying a sleep table allocation
Date: Thu, 20 Aug 2026 19:55:02 +0800
Message-Id: <20260820115505.20027-2-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260820115505.20027-1-shikemeng@huaweicloud.com>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAH99Ib64ZqI3IEDA--.64911S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJry7uw1DJF4kJw1UKry7GFg_yoW8CF18pF
	n5KF98Kr45Jrn8Gr4DA3Wqq345Gw409ryDGa1fWw1Iv39xXr4xWrnFyrZ0vF98CFZ7Jryq
	grWjqw1Uua1v93JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb2g4DUUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Stat-Signature: rzho9xyh6iy1up8iox97o8scp68suzpn
X-Rspamd-Queue-Id: B4D65C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787226912-280786
X-HE-Meta: U2FsdGVkX1+y/BfcnYcvzsLJJ8DJ0KgtcTMV0DCW/molgh/a2m0Vw2U+2456cgPoOaKnH1kyOsTWkB4lSNuOSXrX+WfYVYDeQbqUZAKnqoBA60sVcv0KThQrRicbIWWax/94rPlHBGLQn5d1IkXKmxq8AFR3TU1vhRLO6d+ZH7e94LWUgsKUSW/X5Gk49KAn9Fr1JndkqXwEMe3IE8lOLQzkrlC2krNaWJfuU83odVUfGNKVuIAzHA2Qb0VgGimsPNBzW8m7R4XdH+stSGjb/hnVJKKPgOOTc2+YAW09NoMkvsESk/6z7qD94v4WRId+BAiIyrK7f8qY3CrXRYRtX4K6GJKM1JB+evfscB8ZRskHH+9mc7XWpCvixJgFA8kxMDaou3rFQox11KQPI7JS345olInWBFZbU50ZA4eZwoE5mkUPSZJzZkSJEk89CsNLQgUYFjn4qqWnRXsziS0+NXl1nhHVEGzjlUNrlJ5TJbtxzbIVXE8X5pSwX8uL8mgfVoIB6bJ2nOSmP5l49xH5tTFxxqeU8yPy7EbOWad6C0/u2zuvNWygLDKqcmbqKCwcK1cQV1T2cfVZYtx0DiLkfBNeTpyx4ns7sYMXwjR738i3ffnQ1+hJfquN5GVIZayx0MUj8fU2GrRFFATyB36wzCKq+ZFRA4SRoI9pDhxP0uBarPL483X1ScUVp8NWBFNW4oAYKULdXPyiQvEl/iiCHM/GKQ880iqaS97eVRjhvOeAW3x2goCfaieYxvqKogmcEePcSXmk7zQYjFMfuquWhrFr5Li1XG7pJaTd91Hkkoa5dH9F3Updys+M3ORiPO8C7bxdYJAmao+YdlPd9TpYMDqlCyVFczibyC4ahB3agA7qrFbqNGGheyd7Eza7KblBYGY+a0SieKQpOp2I7Wo+2ZjHik15RXPR3fZ8wvNtaHTaMgRWpuXBMRB1JsmZCecChhXiCTNevk0zf41XVos
 eC75H0/H
 e/yfxzzoxKWLJBEV+wGd19ukps5pBOVrEkg9VtekjF9+F63+S75vveKcbNb6seZVc49MuvGM2EzDfsn0JM4z/+e6H2qKq+VuiZUelqWm8UrtppbiqXPYCO5XcDY6i1S2Mi6Xr
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

Fix the issue by making tables visible at end of swap_cluster_populate().

Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 mm/swapfile.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 615d90867111..4561c864f806 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -466,8 +466,6 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	if (!table)
 		return -ENOMEM;
 
-	rcu_assign_pointer(ci->table, table);
-
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
@@ -487,6 +485,12 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
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


