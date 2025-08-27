Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48DFCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069588E0002; Wed, 27 Aug 2025 14:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019B68E0001; Wed, 27 Aug 2025 14:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71728E0002; Wed, 27 Aug 2025 14:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D47F18E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:14:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5053140790
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:14:04 +0000 (UTC)
X-FDA: 83823336408.17.26DAF34
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 303D640015
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:14:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UL3EpedB;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756318442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FdUaVv5/q92fEJn4ngmJCNwvS1NxjHxx36mqmnqPgHE=;
	b=hpigVQBeV60VVRnShi5WENi+UPI8S9tPBjYcTJuFJxUamv2i4jn9vYgm5mB2e3zeAw3+p3
	ofPlWOv2iQwbvBj72PxXqRNwvT3tCyJzBWqEaEeNPYaxwT4zKZf4/f5O5w8YCxw/cm+2JW
	ypOcF7OWKi0mNxeHF50Oi41Zs0BhTSw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UL3EpedB;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756318442; a=rsa-sha256;
	cv=none;
	b=lLA4LNacKOhTDB4od5Fr92did7Jzp3QqrWTF5fH5UEZOi98evB5ulTwK+ZsICknj1ZoNcO
	qN8h38UBa548RHsECYVLchgxSzVApKEzhNPNwQ4SbgYBsIp+dFF5tU309p2pp1XPxFwANT
	fQT2h5E9HrKTStqvRD5aLLuE5FFzr20=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-771e15ce64eso148254b3a.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756318441; x=1756923241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FdUaVv5/q92fEJn4ngmJCNwvS1NxjHxx36mqmnqPgHE=;
        b=UL3EpedBK1LFR/oQuHpxVulGSpEzqsIuuAF2NZCYO4hN0ark59BBOzcCaQt8HZ1VxV
         uJwxNbufTW5H8zLeJwHPEy4uFMPDPC8svT5k345JXd7nJ4n8AMEvmzKgihnU4+pegJ7c
         WW9Ykf1VMjlbdUw6Edl7M/hRWWrGxHPL0zDUeB6YVOMR1Vc2DSrnhQIRuKnv/PEhvEVJ
         NFnB52tYJhM0nSazt/Y6jiorYzsN6ppqPePIu8YxPFNucHK/WQiQ9Z8MPlRFCrmWGV1/
         yOkvh2MvMmdv5uAx3JXI5ZfHf4YXps+RaYvG/pcRInrYSrDVi5UhFFmfWRb95zUjvQja
         Ukwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756318441; x=1756923241;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdUaVv5/q92fEJn4ngmJCNwvS1NxjHxx36mqmnqPgHE=;
        b=Xo1tpYOmArA1+afrP1jRBbTvLXORf28iW3Gf9fBrHsiFNiJyRNSdOuBeJkTyadPJLU
         qku/jDEkWHem4F4PvSm1hwAO0NkgIHgDxTvby+FjNlSAHAuQI2I0SiGCUAWHYLDTtxwE
         +fO6JnjZBAjIKBfqmO0QjhpPRxhSaheBNZoaPXEtlBRtBixrNxyN+VaDJlTZ+tSBD18i
         F6jimVDHFnCNLB4sOLRacdkYZ+HgUc6uVzfwcZnqgUdCyo6kZWOTj932pNX+eGIrRnSF
         p1fD0fVe7Z6gI4tPe2d648qUqfWsyz1dQ+1dz2JOqeP6ajhrWO2kGojwIkYIwGJDlA3q
         JPug==
X-Forwarded-Encrypted: i=1; AJvYcCWPXi7NawFjDoTmADp/35oC4J11clIDZCXPhTwYTM4QuFjqC9UHWluM3K5Xc9u9eMBk+IogXufCrg==@kvack.org
X-Gm-Message-State: AOJu0YydEO6NmsfoRgGRtldw+xohot+w6I0UcyE2OibN3t+E7rJSnl+M
	QHViFTlX7/VIfenTE5reaAoJ9BmeQQqE/SNQ9RTfMaSqtXU8xj0bKxgO1coBNMHfdjQ=
X-Gm-Gg: ASbGncu5iZo+ECWJYXUyJ05aVP2mwsuSUnHpOZvW/SCny1VaH2VmKLdpIkYjRdGwhyi
	wzIcrk0LnHneflT+49EhUDzZ1eqwRSYqEOCydMlO75TjVEkO9ymted5IcJanqIkEip4URqrJOlw
	r6lWQHS8OApZdctuJXff4jScF7Y/i9WPVDo273SW8HdVTh30VnGwLgaoop033sfARClFP7p13RW
	9xFZJxBXI25bP3vuQbYq6MBp3pGKv3LbbFpPdv5jF9h97wvEMrya8m9mlE6ddAcgE+5g776SAyE
	OvfZZupVyAfI+aq5cfFvthDaoD5EI2NTX8+crGPZhyQj/xTEYidFVwtLcvPUz8er/jL4+Q071lb
	3qTa5
X-Google-Smtp-Source: AGHT+IGCmZr0Zre+3COOBtEP5LaYvPBToTS9DePQeYSQkW3zFjmEengazb3hEGUo7UDhLeBVUJPbug==
X-Received: by 2002:a05:6a20:7f96:b0:220:10e5:825d with SMTP id adf61e73a8af0-24340ad0a52mr27608359637.8.1756318440578;
        Wed, 27 Aug 2025 11:14:00 -0700 (PDT)
Received: from localhost ([101.82.184.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcf04b8sm2593013a91.26.2025.08.27.11.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:14:00 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: jack@suse.cz,
	tj@kernel.org,
	muchun.song@linux.dev
Subject: [PATCH v3] memcg: Don't wait writeback completion when release memcg.
Date: Thu, 28 Aug 2025 02:13:56 +0800
Message-Id: <20250827181356.40971-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 303D640015
X-Rspam-User: 
X-Stat-Signature: qexauhduzyixkt9t4ge6mdi9mn9zbx86
X-Rspamd-Server: rspam09
X-HE-Tag: 1756318441-402869
X-HE-Meta: U2FsdGVkX18kqR1vcfyAG2ctg/42SeXW9RArwnYVECH+Bg3bm3D4C86eWmqKq+mNNxUmjIJ3JcaE/KMIAsYiq7kEIy6+ubfqHEeBY0x2zx/anjYOOPZKTFHNk3ecKQKol3RCTXEZmAPQZXCVsrudpr8HKtp9dhCJdN/vaQsFxVe0G+qQ8Uw3VhUTij4TqL6CE0jCY0FyzhQS6mtcUhk9sXPqqp4TnsDrwU2nh74RyFPAgojM0L5S0hadcUGnxaAM5rjVS99jtnbbQbnl26jPybcTQufMXTN9FNeg9FTxMPWGNSOrRpUX+ZNYn3+GimmtxOz5A8B7n94PXJOMkstHw8cnWR37k1p4wAOr+HOvNora0Z7nAzevJeqw9bRWWkea2c+I5KeLAJUmejcHsdyUkR1f+lqVgKpnwhaSwqQ14NNxtZiojwKzkCQAqJSGfDfATYc/XB4n0ozp9t3+XgmeBo7ZY8/zyoJkYLIFS7s8kxX+Ox3uWwIYX4iit9WAVfWgkyXfjJ+3RWR9RjOKpWjt07ViTC0gWi2Fqm7JVecx5RDfKeY2L5aMoxRcWu6e0HYVUcXbzT/5A5dhwVxJuZPzqHhfG54wAqhDxFjfsiE7lqzuNEtV9BcC93yul57Yxir6DgSvGCBh9QZO4M9eRZlr7s9Mwrn3GZx383KELNAQoYMuozbfY9wmfsb6s6TWSoeE/oZFOmt68j+ioRYEkR9Q4cRGD52x1FLAWula0dUKnZk5FtElxP6WEtba7U/5+WBtnFCzMJLMW4dOyfSjNq04wBDK0FNa7Vacreg/1Ix+9o9sv1maWRk65EtRPQWa8D6FJ5XmmPMqbyX4zWrmn9vbP9EWCEatnUzwNVAUWl7RhU3ILc60xUN5vsE7iFDQocXLxbyuutTBZqq9OuBB2ym7BaHzdSs1g3J+LZgbD/8fR7y6i+9LuUXeqhM4d2uySTuiwSrUjpn7shHQ4BN0HRz
 /1XPEeCp
 0kwdDe4vCWEKtjgkKfQp8y/blEDVD5LddKW9A0zR6JLWmpDtDUHJjbxnkKSyGsmQ2rmh9TASdRcKvLig0HMPb3DM4awXb3Jh962T+UZr24gHVfOPiC8zwetTg2kSY9nPyn4e5VFTDEDmokZdmgep2ryVRQsjDIoDFeozwvOTmd9BnxkZWTfClFuayOIQKrQpzMEfcYceAY1mft/y+cjB6cTwNe55B4NCq+gSc15H0NPNDWhSAAn2e6cTxZCOgDpoRsfT0o8p/onM3ZLiyOgtU5TLNxAxahL4kRpaxkZgJu1tYJfsTbylCqdxwAGWz7YbqfwvS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently, we encountered the following hung task:

INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
[Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
[Wed Jul 30 17:47:45 2025] Call Trace:
[Wed Jul 30 17:47:45 2025]  __schedule+0x934/0xe10
[Wed Jul 30 17:47:45 2025]  ? complete+0x3b/0x50
[Wed Jul 30 17:47:45 2025]  ? _cond_resched+0x15/0x30
[Wed Jul 30 17:47:45 2025]  schedule+0x40/0xb0
[Wed Jul 30 17:47:45 2025]  wb_wait_for_completion+0x52/0x80
[Wed Jul 30 17:47:45 2025]  ? finish_wait+0x80/0x80
[Wed Jul 30 17:47:45 2025]  mem_cgroup_css_free+0x22/0x1b0
[Wed Jul 30 17:47:45 2025]  css_free_rwork_fn+0x42/0x380
[Wed Jul 30 17:47:45 2025]  process_one_work+0x1a2/0x360
[Wed Jul 30 17:47:45 2025]  worker_thread+0x30/0x390
[Wed Jul 30 17:47:45 2025]  ? create_worker+0x1a0/0x1a0
[Wed Jul 30 17:47:45 2025]  kthread+0x110/0x130
[Wed Jul 30 17:47:45 2025]  ? __kthread_cancel_work+0x40/0x40
[Wed Jul 30 17:47:45 2025]  ret_from_fork+0x1f/0x30

The direct cause is that memcg spends a long time waiting for dirty page
writeback of foreign memcgs during release.

The root causes are:
    a. The wb may have multiple writeback tasks, containing millions
       of dirty pages, as shown below:

>>> for work in list_for_each_entry("struct wb_writeback_work", \
				    wb.work_list.address_of_(), "list"):
...     print(work.nr_pages, work.reason, hex(work))
...
900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
1275228 WB_REASON_FOREIGN_FLUSH 0xffff969d9b444bc0
1099673 WB_REASON_FOREIGN_FLUSH 0xffff969f0954d6c0
1351522 WB_REASON_FOREIGN_FLUSH 0xffff969e76713340
2567437 WB_REASON_FOREIGN_FLUSH 0xffff9694ae208400
2954033 WB_REASON_FOREIGN_FLUSH 0xffff96a22d62cbc0
3008860 WB_REASON_FOREIGN_FLUSH 0xffff969eee8ce3c0
3337932 WB_REASON_FOREIGN_FLUSH 0xffff9695b45156c0
3348916 WB_REASON_FOREIGN_FLUSH 0xffff96a22c7a4f40
3345363 WB_REASON_FOREIGN_FLUSH 0xffff969e5d872800
3333581 WB_REASON_FOREIGN_FLUSH 0xffff969efd0f4600
3382225 WB_REASON_FOREIGN_FLUSH 0xffff969e770edcc0
3418770 WB_REASON_FOREIGN_FLUSH 0xffff96a252ceea40
3387648 WB_REASON_FOREIGN_FLUSH 0xffff96a3bda86340
3385420 WB_REASON_FOREIGN_FLUSH 0xffff969efc6eb280
3418730 WB_REASON_FOREIGN_FLUSH 0xffff96a348ab1040
3426155 WB_REASON_FOREIGN_FLUSH 0xffff969d90beac00
3397995 WB_REASON_FOREIGN_FLUSH 0xffff96a2d7288800
3293095 WB_REASON_FOREIGN_FLUSH 0xffff969dab423240
3293595 WB_REASON_FOREIGN_FLUSH 0xffff969c765ff400
3199511 WB_REASON_FOREIGN_FLUSH 0xffff969a72d5e680
3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00

    b. The writeback might severely throttled by wbt, with a speed
       possibly less than 100kb/s, leading to a very long writeback time.

>>> wb.write_bandwidth
(unsigned long)24
>>> wb.write_bandwidth
(unsigned long)13

The wb_wait_for_completion() here is probably only used to prevent
use-after-free. Therefore, we manage 'done' separately and automatically
free it.

This allows us to remove wb_wait_for_completion() while preventing
the use-after-free issue.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
  Changes in v3:
    * Rename cgwb_frn_wq_entry to cgwb_frn_wait.
    * Define memcg_cgwb_waitq_callback_fn() only when 
      CONFIG_CGROUP_WRITEBACK is defined.
    * Embed wb_completion into struct cgwb_frn_wait.

  Change in v2:
    * Use custom waitq function to free resources

 include/linux/backing-dev-defs.h |  7 +++++
 include/linux/memcontrol.h       |  8 ++++-
 mm/memcontrol.c                  | 54 ++++++++++++++++++++++++++------
 3 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 2ad261082bba..6c1ed286da6a 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -65,6 +65,13 @@ struct wb_completion {
 	wait_queue_head_t	*waitq;
 };
 
+static inline void wb_completion_init(struct wb_completion *done,
+									  struct wait_queue_head *waitq)
+{
+	atomic_set(&done->cnt, 1);
+	done->waitq = waitq;
+}
+
 #define __WB_COMPLETION_INIT(_waitq)	\
 	(struct wb_completion){ .cnt = ATOMIC_INIT(1), .waitq = (_waitq) }
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..24e881ce4909 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -157,11 +157,17 @@ struct mem_cgroup_thresholds {
  */
 #define MEMCG_CGWB_FRN_CNT	4
 
+struct cgwb_frn_wait {
+	struct wb_completion done;
+	struct wait_queue_entry wq_entry;
+};
+
 struct memcg_cgwb_frn {
 	u64 bdi_id;			/* bdi->id of the foreign inode */
 	int memcg_id;			/* memcg->css.id of foreign inode */
 	u64 at;				/* jiffies_64 at the time of dirtying */
-	struct wb_completion done;	/* tracks in-flight foreign writebacks */
+	struct wb_completion *done;	/* tracks in-flight foreign writebacks */
+	struct cgwb_frn_wait *wait;	/* used to free resources when release memcg */
 };
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..d9d8b3cc82d5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3459,7 +3459,7 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 		    frn->memcg_id == wb->memcg_css->id)
 			break;
 		if (time_before64(frn->at, oldest_at) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    atomic_read(&frn->done->cnt) == 1) {
 			oldest = i;
 			oldest_at = frn->at;
 		}
@@ -3506,12 +3506,12 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		 * already one in flight.
 		 */
 		if (time_after64(frn->at, now - intv) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    atomic_read(&frn->done->cnt) == 1) {
 			frn->at = 0;
 			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
 			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
 					       WB_REASON_FOREIGN_FLUSH,
-					       &frn->done);
+					       frn->done);
 		}
 	}
 }
@@ -3702,13 +3702,27 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 	__mem_cgroup_free(memcg);
 }
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_entry, unsigned int mode,
+					int flags, void *key)
+{
+	struct cgwb_frn_wait *frn_wait = container_of(wq_entry,
+						      struct cgwb_frn_wait, wq_entry);
+
+	list_del(&wq_entry->entry);
+	kfree(frn_wait);
+
+	return 0;
+}
+#endif
+
 static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
 	struct memcg_vmstats_percpu *statc;
 	struct memcg_vmstats_percpu __percpu *pstatc_pcpu;
 	struct mem_cgroup *memcg;
 	int node, cpu;
-	int __maybe_unused i;
+	int __maybe_unused i = 0;
 	long error;
 
 	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
@@ -3763,9 +3777,17 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		memcg->cgwb_frn[i].done =
-			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
+
+		frn->wait = kmalloc(sizeof(struct cgwb_frn_wait), GFP_KERNEL);
+		if (!frn->wait)
+			goto fail;
+
+		wb_completion_init(&frn->wait->done, &memcg_cgwb_frn_waitq);
+		init_wait_func(&frn->wait->wq_entry, memcg_cgwb_waitq_callback_fn);
+		frn->done = &frn->wait->done;
+	}
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
@@ -3775,6 +3797,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	lru_gen_init_memcg(memcg);
 	return memcg;
 fail:
+#ifdef CONFIG_CGROUP_WRITEBACK
+	while (i--)
+		kfree(memcg->cgwb_frn[i].wait);
+#endif
 	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
 	return ERR_PTR(error);
@@ -3912,8 +3938,18 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
+
+		if (atomic_dec_and_test(&frn->done->cnt))
+			kfree(frn->wait);
+		else
+			/*
+			 * Not necessary to wait for wb completion which might cause task hung,
+			 * only used to free resources. See memcg_cgwb_waitq_callback_fn().
+			 */
+			__add_wait_queue_entry_tail(frn->done->waitq, &frn->wait->wq_entry);
+	}
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-- 
2.39.5


