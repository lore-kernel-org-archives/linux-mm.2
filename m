Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2791ED10372
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 02:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20FC6B0006; Tue, 25 Nov 2025 21:19:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2566B0008; Tue, 25 Nov 2025 21:19:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7AF6B000C; Tue, 25 Nov 2025 21:19:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFA116B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:19:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63CE11326C8
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:19:43 +0000 (UTC)
X-FDA: 84151152246.18.BFD7394
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6A16040013
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:19:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764123581; a=rsa-sha256;
	cv=none;
	b=xfUrxoWpa79Os0TnlVl+yHT5W6nrEKPNc0Gwk/csCMdS59pZCjRm4VDTMQrFwOLHmShQaF
	JEmj+y1gVHUbzIW6zNj3c3lm6BtfR4YkhANG7I3YCl975NLl8XQkiHCy4ON5tieZhF5bfq
	72bcVlnFQ+NL0AnhP6GtxDC4+F7mwCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764123581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=gv1Pt6KlqxUPynAmAYbg7sp33lqFGIPkEAMOA2hlgVU=;
	b=4JZJHMxVXeh0QszNv2xrCAovEawv52dcYYNnIvC5BcnhPKcHaxjBHw51xRkROWC3pLm6Ak
	By7gSqnn2ivq4oC/PUPmfZdybQI/xV+Gr9GmHbvofzdSJhTHORo897A2HkEOoYpi6bQd0U
	MfzekCvsi8lDsmxEhFcKs/Gxsa0T/wg=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dGNXK5XW2zYQtxy
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:18:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id EA9331A084B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:19:32 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgBH8XepYyZpRnwmCA--.22181S2;
	Wed, 26 Nov 2025 10:19:32 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [PATCH -next] memcg: Remove inc/dec_lruvec_kmem_state helpers
Date: Wed, 26 Nov 2025 02:04:35 +0000
Message-Id: <20251126020435.1511637-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBH8XepYyZpRnwmCA--.22181S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1rGFy5tF48AFWruF4Durg_yoW8Ar4UpF
	srJrWFkayUXFyYvFZrKanrCryUua1xGr4UXrZFgw1fAasxt34FgwnrKFZ5JrWjq3yFvr18
	Xaya9rWUWaySqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU0s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A16040013
X-Stat-Signature: p3nmnhns6ppbmze13u6ir863abjwq19d
X-Rspam-User: 
X-HE-Tag: 1764123577-480663
X-HE-Meta: U2FsdGVkX1+i4yOEIjvQ5+iU70t+CkhTuqm5kiVD8+eP9Yzhn8se05Jw9oeRbVJg51M824YctNoPwr3dCpAfqsTSKq9QJV/OjE66e57Jjf4aGXsPNrWH4/tfC1sbKcz2uM9T3GE8VpiwXGp6qfNJ6QRXF97fTOZ3b1B65Uf0XPInWySzn3ka45htdRIoAeSJLST9Fl8Xm0PJSZnIl5aCpUNl4lq+lTj7a/7hEa1vFGBAvaMKs6a0HKIkkkBHLzms32NcvyNZwZmUgtScVXRQmIE2Q4PqXvSliRrw8ekUR8aITgYMUinQ57zZbff3jC7WY3L2zigGwXIuscc1//8TRemuYUPEOPKjNn8A47yRrEN+B+lWbziG5w7mk0LCPBkpW4I3MiJYX41SosWQUHqCmLkraPOxGnMKV8fkdt7WroKOacaVfjeu6NayPh6P0mtNqNhi1sjN2UdCaSL6PkEnsK3XYyeqaeVIhMmorDrv7cTmA7Bru8JZndbxnAeATwHCiaXAEdAsf/hHDNdacyMcBh+GNISU8PykXwsiyPIO/a3w7GOHLmIwBr8wkBUuRbG6ZFytC2CMy5AJ6csewVVljoBhOfZjm9Y6S0MiCuumSMipFK4SjjFpQEbyjUr2P9fPrRQqhnnq0ZxXEAQfVx2aYXybbwpkguj0EJGDufwJ0HNAWgMCABnd7/oabFb6fXezpw40cy6uGqg04AT4qXtJ02w+76eJUWWVW8LRoBbsc7blseGU6TkpCtU+XFi75nPyvXqhl9bDxYw7h4glY8dSDoKggv3Leo24cBYWSdHyD85e3WpUEurTiohxYqD+HENmwwjt7OIfRx1/6aijlnyDymydFWJtgy5j5Nen09KSQj2LB2J/VmkTIVtm1yIsQoEJZDVdJZgW3gDVy2ASROj7AD+MUSE0uoioEmDEE+UGqtYqo88Tldgr8JpgpZW4vyWDFa/N6GGhd833kfdxVVm
 4I4JHe29
 kPaRjhi7CTE6JYnSDzcHEFTONR2T7IoZAiWoNvtL9XNXCoLCVW0Rf9l0W9ee2NR6yqVpthHNuRgZBAWy988Dfiumop5T318CIS1xLcUNaL0MrhfTTl5M7yN+9YVBOJIlLn3BCn0Wr3XBLZL6U6x82/y6m/RYqMtE9doPBAMxt/DLbvVIeViSylp4L9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The dec_lruvec_kmem_state helper is unused by any caller and can be safely
removed. Meanwhile, the inc_lruvec_kmem_state helper is only referenced by
shadow_lru_isolate, retaining these two helpers is unnecessary. This patch
removes both helper functions to eliminate redundant code.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/memcontrol.h | 10 ----------
 mm/workingset.c            |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d35390f9892a..0651865a4564 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1452,16 +1452,6 @@ struct slabobj_ext {
 #endif
 } __aligned(8);
 
-static inline void inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
-{
-	mod_lruvec_kmem_state(p, idx, 1);
-}
-
-static inline void dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
-{
-	mod_lruvec_kmem_state(p, idx, -1);
-}
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/workingset.c b/mm/workingset.c
index 892f6fe94ea9..e9f05634747a 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -749,7 +749,7 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 	if (WARN_ON_ONCE(node->count != node->nr_values))
 		goto out_invalid;
 	xa_delete_node(node, workingset_update_node);
-	inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
+	mod_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM, 1);
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
-- 
2.34.1


