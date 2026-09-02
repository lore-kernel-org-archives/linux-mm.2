Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE83C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8676B0088; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43DC6B0095; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958886B0099; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 593B36B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:17:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D99B21201FB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:04 +0000 (UTC)
X-FDA: 85168872768.04.1463AC0
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf16.hostedemail.com (Postfix) with ESMTP id 083E618000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4yWgN6Ji;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMutdLgk3E5wynZZWQtCn7gpgPrrKwjYS6nAK+VT9Fs=;
	b=TTrk26jUkZbed6/apnrzK0pSXfVrwdA9j/5RpKbWdIM3Ua4RV7djgUg9VJ7Tym9UE8wzIU
	fvoOc9GGm7J+VvdQs8aeZv+1JuMo+db31SK+IJb6BWz0FHBY6Gr8KSRIPJnmQoMiFs9uA4
	brFXZvQrjNR0WAbgRMMby5/15jJy0Zc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4yWgN6Ji;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355023;
	b=T6iMLtdl9WhP/rdVULJrJDoWRJvbAWjgxuzZED/0xTResVzXUiu7/o4MdW6OW94tmczi6A
	82PE8FcnAyjeelKd67Us9od5xS/vLjKvKJRtEReorYJtu8QFq0uBnnW4dC5GWOiA2cwoFm
	llMGGloRtknQPUjEEoO43sfaOzU06N4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FMutdLgk3E5wynZZWQtCn7gpgPrrKwjYS6nAK+VT9Fs=;
	b=4yWgN6Ji+pHgL66Tyv+Pt77YqPukAmGoBSzl5v4R65ckzp0UVzPnbqeLlchftp40qqfRVot4Z
	2ZRwspAsOcgeVFqX5YMlApaiQQg/fJWcH8YGibc2ccDZmQbhIqZs3Xi5VBZWOy5hjR2dtHz41FH
	sKO8x2guDQ5cD05eT0Grjig=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hZjf81NP9z1cyPY;
	Wed,  2 Sep 2026 21:06:08 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 9CB424057C;
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
Subject: [PATCH 4/4] mm: replace PF_KCOMPACTD flag with kthread_func() check
Date: Wed, 2 Sep 2026 21:16:53 +0800
Message-ID: <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: p1y6awksw6jps1wz73c1x74ray158iox
X-Rspamd-Queue-Id: 083E618000C
X-HE-Tag: 1788355021-282011
X-HE-Meta: U2FsdGVkX1+Kt+PgpHsVaazi2LAGFft5Qd1gdPZydhOQIsgqx+9o7NMtjB92yh///Gj92SHikCCISoT+emxZYKPyhTqyk6Sme/UwsDxt8Gdnck9+ZTj6pgCaNrMemfJqiH4/TkNkb/FrzAOu+bpgNdF3LIpvNlwt7MvtTR21NnqAfaPxmTIM2qrpCQ6SGcl1yF5GCC/y56VZ8k4wzbITBtLSKybGTWD9UJ+/1k5dBUQ67AxoNHM0wLb9eeXV4UqsrAW7WB984ZUQSqzM8gByQ+3sCp82E4wYKwn6HmCfOIovx8MEHLDdrW9IN1qHWhC4keM9IfNkckwuSOvyJotwQnLxhGBRNzIfTvBwG83KdoZeF/D1xAyEEVJ53bZ5WANTEAbuluzP10CJFll8bcc/C4BB+pf6v6jwZQKaZsiG1bLUW5aEgMFuY8R4aeJvvQPDmSH2DJLoAQqUVTKXtiJ1hQuR3Q5nySb316ATbOh7PieKkXphlDmJqOL1Kb/EO/PbNpYF9L007HEfkycr2k4/wt43zhnpRoYJOhNPZXBENCnF2df4j0Y1XjeQpR2YaY9U/0IpiVY78wxRPNVf1AllZZclakMrZ52cPlIIO0ekcc4D+2hVOydQ2MXYbaEocwaYxVTD2Yf33Z5iVVcnANdkeaokWFVk3UTgV3r9q+IvLjkbfku6C/FllPt5IKyOdfCfULo/ZxJFg98VLccu8R/lAobczj53FGU7PB2m+3MWZjNJLCpwXPZG2uZ8TCpZf0ly8mpHr9FDFXcQmcijTvj8xV0VNxpdPK0IHH+FalDiM4jAiPRLKXVx0stuEvllFbqBg0hdTzEOD4aGuDqluF9ovBqf7CA/xpizR2HzgoxXwSivqF9ZmuMpyYMVNMCe3hp3E9RKC4XKIv0BUua+Gtls3/b2Nqz/jhrDfvKyijRUKzwSL45rW3KLDYwZeQb3h91viOCUCN1Is6lSXN52CxK
 yAqn1wGe
 S/0JIAfyDwzEtI8TujgC/J4nrZmb2f5/aTb9fynTG9ron/hM8DBJSKRqOt51wCizHFkS7J2xSa5CoED/ktWZDP4JDYrzOaWtVvCQtQs4XnOIbRA2vS3jTZu7UIja+t13zVc4jablqukCxZ/3VcMNZCQHAzCYGxw2AeVwq075icAS0LfY3UzRWDlAGJ4t15FDZgvGthD8FT0HMmHTkT7EgumSbewf0vwRaIg3/9GRiI/XkOZfOPtvibG8G6BBV/bM6zSb4I+torRowoWZDqZp4LCXBHzrrqfWDsGaApahVlxm3U9tC/yE9XCxkDNyTBoAAdYqmcqdV4nkNoAKVRgFmu4DSlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
nfs_release_folio() to not deadlock via kcompactd writeback") so
nfs_release_folio() could detect kcompactd context and skip
writeback.  The flag is only consumed by current_is_kcompactd(),
whose sole caller is nfs_release_folio().

Replace the flag-based check with kthread_func(current) == kcompactd,
freeing the 0x00010000 PF flag bit.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/compaction.h               | 11 ++++++-----
 include/linux/sched.h                    |  2 +-
 mm/compaction.c                          |  9 ++++++---
 tools/sched_ext/include/scx/common.bpf.h |  1 -
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 66a2f70e9e01..691c09f0a697 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -81,10 +81,6 @@ static inline unsigned long compact_gap(unsigned int order)
 	return min(2UL << order, COMPACT_CLUSTER_MAX);
 }
 
-static inline int current_is_kcompactd(void)
-{
-	return current->flags & PF_KCOMPACTD;
-}
 
 #ifdef CONFIG_COMPACTION
 
@@ -103,7 +99,7 @@ extern void compaction_defer_reset(struct zone *zone, int order,
 
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 					int alloc_flags, gfp_t gfp_mask);
-
+bool current_is_kcompactd(void);
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
@@ -120,6 +116,11 @@ static inline bool compaction_suitable(struct zone *zone, int order,
 	return false;
 }
 
+static inline bool current_is_kcompactd(void)
+{
+	return false;
+}
+
 static inline void kcompactd_run(int nid)
 {
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 86394121b6c0..eb12ff4cea6c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1808,7 +1808,7 @@ extern struct pid *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
+#define PF__HOLE__00010000	0x00010000
 #define PF__HOLE__00020000	0x00020000
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..4994e200bbec 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -3197,7 +3197,6 @@ static int kcompactd(void *p)
 	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
 	long timeout = default_timeout;
 
-	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3254,11 +3253,15 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
-	current->flags &= ~PF_KCOMPACTD;
-
 	return 0;
 }
 
+bool current_is_kcompactd(void)
+{
+	return kthread_func(current) == kcompactd;
+}
+EXPORT_SYMBOL_GPL(current_is_kcompactd);
+
 /*
  * This kcompactd start function will be called by init and node-hot-add.
  * On node-hot-add, kcompactd will moved to proper cpus if cpus are hot-added.
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 3e095343ae84..807ef881ce2d 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -31,7 +31,6 @@
 #define PF_IDLE				0x00000002	/* I am an IDLE thread */
 #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
-#define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
 #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
 #define PF_EXITING			0x00000004
 #define CLOCK_MONOTONIC			1
-- 
2.55.0


