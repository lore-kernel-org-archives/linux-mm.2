Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACC2C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896CE6B0092; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7806B0096; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AA46B008C; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 315F86B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA3D8801EC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:04 +0000 (UTC)
X-FDA: 85168872768.15.B4EAA32
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf31.hostedemail.com (Postfix) with ESMTP id EAF3920002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VFXbj+lH;
	spf=pass (imf31.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ow5+5zT/Qz68HwOR7hge2aByrndRNdMarakE/QBZiCg=;
	b=gylfZk2yHFPWehaykmEL04fjBZWJLvUUa7x+JMs23Kavq2DqmO0mnh/dxReYzi3Xpvar5q
	tov3wBVAS2ZGelyfbtf3Mztj6DapdwByFzz1y3ErIyjg3YhV3ywGl6p7CqBlaaAb2QZl6c
	94SzCEiYb5u7QM27RQ0E0lqATTt0wog=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VFXbj+lH;
	spf=pass (imf31.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355022;
	b=GxO66V9oTdRDvfNE8SywbHrUhWpgc2fm6t0sAWWoXO4PrQ1JMnbv2hJWFRUNj7VwHgmDvq
	tLy5PWsARURlsOM/zZUEXRIKpxnJk97Qafmlp0/uGBTHijvtgEHOIDQwFFkuWlZCT0dmr4
	/oFKsNHIjrMkY5L4yQU0BJNnYxc8K9o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ow5+5zT/Qz68HwOR7hge2aByrndRNdMarakE/QBZiCg=;
	b=VFXbj+lHggagP9n/+yQoCKVOFSLN5qmHvAnRjc2SuoDmJBsGdpPCXwi+W2WH7xOFN+Duw+met
	4pa0nh3ChZr4eZ/gMFSfxyKgyVzUWeIRpZU2PL5uAcSir8zGNthTUTV+CBUW+Cfiv++XPqmCWGl
	sjTRNDtuTETjbI1+REajJNU=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hZjf663f0zmV7C;
	Wed,  2 Sep 2026 21:06:06 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D00940586;
	Wed,  2 Sep 2026 21:16:57 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:56 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func() check
Date: Wed, 2 Sep 2026 21:16:52 +0800
Message-ID: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: 5cpib7pot76mn6k3y4pp9qgszxtw99ym
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EAF3920002
X-Rspam-User: 
X-HE-Tag: 1788355021-894258
X-HE-Meta: U2FsdGVkX18PrM986B92Kmu2cgHEd/C7hcvDprD3qNpWANicdLODMrSJDM3BAr8b31Q4pj2mGI4C9D9Zd0A1M/HHnYKQEPCfPqLj3THJIRLfqLU/PwyMa0YnuMYcWl/eyTNeVRe9MtMWUHGwpCXHMkBRvjK6A/2HEO+aps9YD5awK+gQ0Foa6Z6fyMUwOrfdGh7ldCE9w+JePUQknMpjgDrE50437JDUIvhXzeJuNDAXnCpsk3ZX6pqyDnInNs+vXcgEh4jIEDR7vN04l6pBGhYXDqqJEkQMdpepZrZjllr6UtmQQVFoqdWen934sq5YVZVn0y4e6yuj8WIpDRbZBTF5BUISMvbumCiMVoJeKb5DcbIou7smmZXxPz15i+btjIzRNn/pU28tLPVEqhXeN+bb8S4dnzd8VY9t3NIuWhbn5/VJd72dqZlabYd/CQJHy7HTC7FmOwmMo6+RB+MunxAXz5lKqqr6JUkfrD0Jeec5+uZVUmshKvT0m8Ej2H9cik2ZAuWdt6VBer/cyUZYx8zdqu+6zr/s8SPl+dg1ifalcQV70jkPYvjNTZwau81DrVJyWu43egBDmjxXV1VfkXfYg9MQXZy0Y5fmCkqd/Fy/fhBIXgTc34zvzpNnlGx1Wt4fzn5xMcmvRAjiP6xrDWULTv9M2Vj6a4bnYJZFL12QPoE3FN2CWD/SCVjuGlKgqnEbPDc41KdIis+6AvreaHVyQWlY05AL+zuxziklvBRf45ipZP2liAQDOQGT7e11E+LLWTTHXv3OgfvS0eU91EvLweyv/QpXRoDpq1x9EkAu9dMOf7cEHFP7WSP9wZZzq6wnK7cQTATE/Jksf2hBeweO7FDiMN6g8Gg3JC4anzPIdlK0Wr1YVxdTNaT51inAFVVPrsfFvRZsAc6U0EPQYZfILCh9v8PGKJxbKlrbkJqXJ3s7mBiPkuFQwRIOA0CLGZQj5qcpIUvFktrNWZm
 wvTkHtUp
 vTCa51CDV6gxZi+fXYdiHUZ+Wdh/Ow0DSi8f3j6A9/bqAYicAbguP5DsE9Gwvrc+HqPD0rI68HiscRzCx0OkFf8P3B60VjZyFbHTGM2s4aanl3jUuQ49OD85CVge6n4QaVXh4RBM0Zcv5VTFJepLmQep+YSsHip0745gR1Oa8JLmWudM2w8eQb0wbObN1nmNeSP1y1dwciO/fycIpSAqvsjhCf+WPLzwVFUewKdDfHJBJJVVVh2y3JoUlmNQqB8NEfF42igUS+5Ji8JvNNFv6ts58Jh9D09MjslLc56GeAIm4+sLUggfvIX+yyTvcX0YqVyA5b24HB3qXBKBHWXJK7o+mqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preceding commits removed the last consumer that propagated
PF_KSWAPD beyond kswapd itself (XFS btree split worker inheritance).
The only remaining setter of PF_KSWAPD is kswapd(), and every
current_is_kswapd() caller only needs to check whether the current
task *is* the kswapd thread, not whether it inherited the flag.

Replace the flag-based test with kthread_func(current) == kswapd,
freeing the 0x00020000 PF flag bit.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/sched.h                    |  2 +-
 include/linux/swap.h                     |  7 +------
 mm/vmscan.c                              | 10 ++++++++--
 tools/sched_ext/include/scx/common.bpf.h |  1 -
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b3d47a325cc..86394121b6c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1809,7 +1809,7 @@ extern struct pid *cad_pid;
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
-#define PF_KSWAPD		0x00020000	/* I am kswapd */
+#define PF__HOLE__00020000	0x00020000
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
diff --git a/include/linux/swap.h b/include/linux/swap.h
index a72ecf12c00d..fc290e29e4a9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -25,12 +25,6 @@
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-
-static inline int current_is_kswapd(void)
-{
-	return current->flags & PF_KSWAPD;
-}
-
 /*
  * MAX_SWAPFILES defines the maximum number of swaptypes: things which can
  * be swapped to.  The swap type and the offset into that swap type are
@@ -339,6 +333,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
+bool current_is_kswapd(void);
 
 #ifdef CONFIG_SWAP
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 07ba86634b84..775d3f71a9de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7468,7 +7468,7 @@ static int kswapd(void *p)
 	 * us from recursively trying to free more memory as we're
 	 * trying to free the first piece of memory in the first place).
 	 */
-	tsk->flags |= PF_MEMALLOC | PF_KSWAPD;
+	tsk->flags |= PF_MEMALLOC;
 	set_freezable();
 
 	WRITE_ONCE(pgdat->kswapd_order, 0);
@@ -7518,11 +7518,17 @@ static int kswapd(void *p)
 			goto kswapd_try_sleep;
 	}
 
-	tsk->flags &= ~(PF_MEMALLOC | PF_KSWAPD);
+	tsk->flags &= ~PF_MEMALLOC;
 
 	return 0;
 }
 
+bool current_is_kswapd(void)
+{
+	return kthread_func(current) == kswapd;
+}
+EXPORT_SYMBOL_GPL(current_is_kswapd);
+
 /*
  * A zone is low on free memory or too fragmented for high-order memory.  If
  * kswapd should reclaim (direct reclaim is deferred), wake it up for the zone's
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 76f5e025e107..3e095343ae84 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -32,7 +32,6 @@
 #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
 #define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
-#define PF_KSWAPD			0x00020000      /* I am kswapd */
 #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
 #define PF_EXITING			0x00000004
 #define CLOCK_MONOTONIC			1
-- 
2.55.0


