Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445FDF34C47
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B496B0089; Mon, 13 Apr 2026 07:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C706B008A; Mon, 13 Apr 2026 07:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AA86B0092; Mon, 13 Apr 2026 07:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8806B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:57:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDB338725F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:57:47 +0000 (UTC)
X-FDA: 84653383374.05.417E832
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf05.hostedemail.com (Postfix) with ESMTP id DFB06100007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:57:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rrxT3npE;
	spf=pass (imf05.hostedemail.com: domain of yangyingliang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yangyingliang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776081466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N2hsu1XgGKKp0f7imiVwOnA9Wx7XWP12pLWakH4tpxE=;
	b=mY/qsQXHm+YyvcMp3yRshG6wr4tg8Y5NO/KV2cx/6yOpozZrMMGmd4BywmpP5qlXzmbCHq
	xyYb5X4sXYjN+jMX1aqkS2yrRAUjHv+mTWNn2zazG1Wz9dcueCDTwmPqWIDnb721GjW3WP
	gRcPVXbJRd0Hrg0eaZQQ+FVdyqV/nQ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rrxT3npE;
	spf=pass (imf05.hostedemail.com: domain of yangyingliang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yangyingliang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776081466; a=rsa-sha256;
	cv=none;
	b=fa3oFZJRlxCr/nfC5/MpJ0KkZZZwaW2I+C5ogjTZrCxsU598iY+E4P7uNM1eh+5LfzaZsc
	u/9whXjInpVJ6JEQURs5ZH34ph6xYbSyK2MFugMP5fLA8WXK9Uc/9RRshZd5jdSnnce5Xl
	HnXlJfdojKo2DFO/sOCjVOwfeTe/Pf4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N2hsu1XgGKKp0f7imiVwOnA9Wx7XWP12pLWakH4tpxE=;
	b=rrxT3npEG1rPDv9YwYxhNHGSCkp5W+BolP72RSDTvHNtHP8f1Lw4Ui6IaeXBbVrk/e73AbkyG
	T0YLingRqKo0FmPyy+uJeBYMDjImUoB0pwVGSypcLzQ1YG3hCZhIQv4pe3AusyMVaaCH//qxDFb
	Bp3ASnlcd8s3y6dvcYd9naY=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fvQjN5rpmz1prLd;
	Mon, 13 Apr 2026 19:51:20 +0800 (CST)
Received: from dggpemf200002.china.huawei.com (unknown [7.185.36.244])
	by mail.maildlp.com (Postfix) with ESMTPS id CC81E40574;
	Mon, 13 Apr 2026 19:57:40 +0800 (CST)
Received: from huawei.com (10.50.87.109) by dggpemf200002.china.huawei.com
 (7.185.36.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 13 Apr
 2026 19:57:40 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<yangyingliang@huawei.com>, <hucool.lihua@huawei.com>
Subject: [PATCH -next] mm: make sure freeram is smaller than totalram
Date: Mon, 13 Apr 2026 19:57:36 +0800
Message-ID: <20260413115736.1237680-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.109]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200002.china.huawei.com (7.185.36.244)
X-Rspamd-Queue-Id: DFB06100007
X-Stat-Signature: 7pf1pequmjun7fuh8bwuab4wupb1rhf1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776081464-172333
X-HE-Meta: U2FsdGVkX19MLBCiKlgNuaRlKVjVNqx71b5lEBLF+9WAnkcmZOoQZIZLvcMaUQRZDHRzrczcTIS8IFNjLVvMGQmHs0v9plWT6LoHLrIa+12nvrvr6o6Ykj/GASgUJTrGxQ8fOfhbxuSWl687Pj0Vvv0sU70RsC5VSYeg9HWXVXpTcms6khdd5aefUH9eHSmqtXu518ZHWdXm7bYAAnAS/aBCvpgwHHV19y/zvSLdNt8X4sRAzS9o76LT1/SSONrdkf2zvoA9LgbniMY7KDNpDc45Tnn06b328DWpM82BOn9By7pWVHaBPHmiz9+6l+IlfGFlZbyrGAdxXu4t/jfb2yHOpKZ6RVvBA24LWB73ev6cGgZ7jlOBTF85gchvXr0/ekbpLdn6It5WMqkbGl9sv1asKFZTvV9beKfE8Q5ptbdAZFls+WEM9TuqCCyG7yEiJ6oJhnZt+uaBYbn1pSNX6LmNqyLPSIR+XmX05MeJCUKS0LG+Y8DqjUpAhwrv2mw2WQ5hteaDE2ccxRkdYIsBq1ROvAOTFZykUy6JvMqEvh5vZiIJtrPkQuY9qLGwe/+cpRttuFzW/gF8CRUy4yThEINyn/qJ+6V13coYXsypK4Rd/fNNKcBGU88TM5eHROa1PXAtK+IVQuIzZ1xDK1l64DLiqHgbKjov3NwrXykFydyJYo88fSM0oBBjLCS44GXZ+tKDNwvz8qAMk54Uq+xvJOQVeBcH0CLnKkVcCdZDVOd9UbY0eJfixtXv5E3VJnyf4y4f1U+/rPwJs5SPB53BKrf4DgyC+P1My4yO/obcKUzKo93ECz7RilfTuUlvpkvvX87SZbjfR11YYOkUWG/zbGunrI8t1MZqYvFQd47+nh0rxKI+aklYEa0/aFBRlssIlBU7MuRz4efvKdJWtoB1dfgjOhJIfdhMYWD2p1Y0UYIu4GZ4Ygjl0ujgfR6C+6mr1Nvj9my48ZLiwacGSkR
 SsciOFAE
 vddp41b5ND/B/n34I2xQoIvVng62kMWPW1DJ/zS3CJyLSRqs8mjR30ib+CcbFzVjmUNnPn3e6kNRCKg9kHJRXcWOK09X2b20zrclrdbYBuFCQmxjI5XpRNPGhQz1KMMMH8BSZJslV4IGa7LqJlNvE6qm8biqA4c+To6zvKyhU93NMGz+cm0YiUKQp9hg4nlAbKfea4gXfBNgTVD+WHZrjCmRFXJN8v/Kgc7yXn3j5SXsMbNtS8j3B1sh6W0mmTYY2dhTZmiZ3yMCnnInZPbEaRiB4OmU7e8KVh0zt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory stat is not done in real time, it have some gap with
real value. In CPU-less NUMA node, the values of MemTotal and
MemFree can be nearly equal, the gap may cause MemFree bigger
than MemTotal, it leads MemUsed is negative which print as a large
positive number.

cat /sys/devices/system/node/node17/meminfo
Node 17 MemTotal:        4194304 kB
Node 17 MemFree:         4195552 kB
Node 17 MemUsed:        18446744073709550368 kB
Node 17 Active:               52 kB
Node 17 Inactive:            320 kB
Node 17 Active(anon):          0 kB
Node 17 Inactive(anon):        0 kB
Node 17 Active(file):         52 kB
Node 17 Inactive(file):      320 kB
Node 17 Unevictable:           0 kB
Node 17 Mlocked:               0 kB
Node 17 Dirty:                 0 kB
Node 17 Writeback:             0 kB
Node 17 FilePages:           372 kB
Node 17 Mapped:              320 kB
Node 17 AnonPages:             0 kB
Node 17 Shmem:                 0 kB
Node 17 KernelStack:           0 kB
Node 17 PageTables:            0 kB
Node 17 NFS_Unstable:          0 kB
Node 17 Bounce:                0 kB
Node 17 WritebackTmp:          0 kB
Node 17 KReclaimable:          0 kB
Node 17 Slab:                  0 kB
Node 17 SReclaimable:          0 kB
Node 17 SUnreclaim:            0 kB
Node 17 AnonHugePages:     79872 kB
Node 17 ShmemHugePages:        0 kB
Node 17 ShmemPmdMapped:        0 kB
Node 17 FileHugePages:        0 kB
Node 17 FilePmdMapped:        0 kB
Node 17 HugePages_Total:     0
Node 17 HugePages_Free:      0
Node 17 HugePages_Surp:      0

To avoid this exception by refreshing vm_stat, when MemFree
is bigger than MemTotal.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 include/linux/vmstat.h |  1 +
 mm/show_mem.c          | 10 ++++++++++
 mm/vmstat.c            | 15 ++++++++++-----
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..6a7d2f3757b0 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -259,6 +259,7 @@ extern unsigned long node_page_state(struct pglist_data *pgdat,
 						enum node_stat_item item);
 extern unsigned long node_page_state_pages(struct pglist_data *pgdat,
 					   enum node_stat_item item);
+extern int refresh_node_page_state(void);
 extern void fold_vm_numa_events(void);
 #else
 #define sum_zone_node_page_state(node, item) global_zone_page_state(item)
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 43aca5a2ac99..dc8d2b6056d3 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -106,6 +106,16 @@ void si_meminfo_node(struct sysinfo *val, int nid)
 	val->totalram = managed_pages;
 	val->sharedram = node_page_state(pgdat, NR_SHMEM);
 	val->freeram = sum_zone_node_page_state(nid, NR_FREE_PAGES);
+	if (val->freeram > val->totalram) {
+		int err = refresh_node_page_state();
+		if (err)
+			val->freeram = val->totalram;
+		else
+			val->freeram = sum_zone_node_page_state(nid, NR_FREE_PAGES);
+
+		if (val->freeram > val->totalram)
+			val->freeram = val->totalram;
+	}
 	val->totalhigh = managed_highpages;
 	val->freehigh = free_highpages;
 	val->mem_unit = PAGE_SIZE;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..96a2e03ec83e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -881,6 +881,11 @@ static bool refresh_cpu_vm_stats(bool do_pagesets)
 	return changed;
 }
 
+static void refresh_vm_stats(struct work_struct *work)
+{
+	refresh_cpu_vm_stats(true);
+}
+
 /*
  * Fold the data for an offline cpu into the global array.
  * There cannot be any access by the offline cpu and therefore
@@ -1024,6 +1029,11 @@ unsigned long node_page_state(struct pglist_data *pgdat,
 
 	return node_page_state_pages(pgdat, item);
 }
+
+int refresh_node_page_state(void)
+{
+	return schedule_on_each_cpu(refresh_vm_stats);
+}
 #endif
 
 /*
@@ -1970,11 +1980,6 @@ static int sysctl_stat_interval __read_mostly = HZ;
 static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
-static void refresh_vm_stats(struct work_struct *work)
-{
-	refresh_cpu_vm_stats(true);
-}
-
 static int vmstat_refresh(const struct ctl_table *table, int write,
 		   void *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
2.25.1


