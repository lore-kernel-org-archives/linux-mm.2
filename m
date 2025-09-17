Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CB9CAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AAC88E007C; Wed, 17 Sep 2025 17:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B6D8E006B; Wed, 17 Sep 2025 17:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1716B8E007C; Wed, 17 Sep 2025 17:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 033038E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:30:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 766FAC06A5
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:30:07 +0000 (UTC)
X-FDA: 83900035254.06.A4B8687
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CB6880012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:30:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ikYd5v6B;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758144605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TTKGc8yUnIOhZLLz3jZrfDJbgKc8bNDWHQlSBE8s81M=;
	b=rtRvG/q+z98zseyVx+DHSSdqiE+MbsS64Qu3JmB8qtbvCzIDrbEy7OHOQKKRwvnBG5ye6F
	wpItavTEGZ/DDd/kaBNzdxrzt8VP/3jhFEu4qLFZRHnheSTaCULHAi2XArUkW9+J+iQQvd
	4R0ch60tcHkWdy2xDhKvwrrZ+OFsloI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758144605; a=rsa-sha256;
	cv=none;
	b=rPq76PuIegQK4clIS977f3cpOhqeS5dXyPL5zXUm0/ThCNVanvgNPp+RYggyv0/7ZjQoN/
	j8XuY8hfaSr8Oq+AhI7C1aDVU4jbIV0a7P4FLnE4UXe/zQgP9VMpC1FnDr8E9s+y8pxJbb
	gQxKbtfyj6pT6ES3VgJuS9MEf8XiIyg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ikYd5v6B;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3306b83ebdaso8502a91.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758144604; x=1758749404; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TTKGc8yUnIOhZLLz3jZrfDJbgKc8bNDWHQlSBE8s81M=;
        b=ikYd5v6BSwUcSauqwRgNnwOdYFypdsOsuVMmOLyhLfsFFbTrMUX19eozXEoMeWkzeX
         S6b1UnoQveUjNLBI/Ji2/iRfueJNkrZL8hgLXCEC70s+IaJkzEp05ocTUKf0t9SQxGAG
         bvunHEVAGEXHsFWLsdPp9dDugrqbiZWRZhuY6BmwG5uSKGGNzfJhQssgBTi+YmKfNL9H
         tfMjnu6+Cplw0L+G4xLB9FEl59/Ug61uGztSvONcVKVnbewqlwle4E6CaeA6OzBKjB/k
         Yo+PNcZ67jv3wEwWuCS4taJCBuXxBAlDAROtG0AevIhXs+8TKUi/+xtyj4HfpRFTPqe+
         auZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758144604; x=1758749404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTKGc8yUnIOhZLLz3jZrfDJbgKc8bNDWHQlSBE8s81M=;
        b=qQwTVvfX1sa35zXSSG1H9oAZ9oiW6oyHruT1ZRufHnanEEw9LWSyYJZrxAwSaWocWn
         GofLMjZkF1X7bvYI67SMqOwJOQHwwHfx7odzKPH3VTGVmoNCitwqOzu3pI5JHQsIILcp
         3/y77BPOLhBdDdbtFbXuFnlPgDpzvSQfcgEiC1Jz4dRg6tonkBzU1JKwI8gBdE4OWoyh
         Q6QDoGOua4vaS2kSowgSa9IkEj68NUQR1ErLfseKXDFFbURJyKK4BNWr8hYAPskqgBzT
         0LG87MfBZaCLxe+nBZND3p5DBNtFSCW8QxL5Xt2utC5HHrqDVhxWXA9WupUh6f3VsM4j
         7U3g==
X-Forwarded-Encrypted: i=1; AJvYcCVLZmBw0xTK4xaE6ENvPB4ldFTxCN1SigJ2+GDFeMWmxRdbEeeGTxAahck+7zBrTUydEUkjyA16wg==@kvack.org
X-Gm-Message-State: AOJu0YxEwGhWJTNz7uu9oSHnaB+ppPAewODu5dqkAgXDQYD05ODt9UDJ
	05btgOk6Zspx3uUDYlumjpL3OTBQSNTt7buDLBwEnDrsME+3qZ+jAgpDBkCb+GfKa6ssPqGjbbK
	QkplaevCHiQ==
X-Gm-Gg: ASbGncsZGpdt8RpXrG7wWMrpmGX6OpvX8nHtONP+VB7q/vQTKtduD2C5Jdzzg9oQrCg
	0vEPywm1tnGCBUnNzsZCz4pYNeQT79fqT7oX9OJs/KlHvVsaXBRkI9/P71puZlgg2JNOrW7D1Gf
	jM1Opts0Bl9ZyasalfX3xyq3AlxgXd7mnCzJhHW1v5itv2AfrzslTn5o2jtvvQKZ9SxOngyGBwl
	v3+l0ZLuyKARweU6W0HAkFpbD/MZWVZlpnxV79vEdg7XJbkoABXPUx5hKrte5BJMtKKsU6gKoQh
	5LV3q8Z4y+PeLrcAmVoVwqt9dUetQwVqw3hoo/sQs9h3kLvhf8+RK6S1NkCAq6OzKEB/C78dW4U
	o4jJUKFe1OXK7it/wV1pt1jJVJY2HppjzKrsSbEUxyA==
X-Google-Smtp-Source: AGHT+IGDhJnULOHslKrpZ1PH63RDEs3+poCntiJ1uXWg6h4a4Y8H/NO/ci03aY1C2K79gg4IrkFAmA==
X-Received: by 2002:a17:90b:268b:b0:32e:32e4:9775 with SMTP id 98e67ed59e1d1-32ee3ed1932mr4707208a91.12.1758144603506;
        Wed, 17 Sep 2025 14:30:03 -0700 (PDT)
Received: from localhost ([61.171.213.183])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-330607f0deasm407961a91.23.2025.09.17.14.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 14:30:03 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: jack@suse.cz,
	tj@kernel.org,
	muchun.song@linux.dev,
	venkat88@linux.ibm.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Subject: [PATCH v6] memcg: Don't wait writeback completion when release memcg.
Date: Thu, 18 Sep 2025 05:29:59 +0800
Message-Id: <20250917212959.355656-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CB6880012
X-Stat-Signature: t6f7mpfyb9bwrjpxfewz6z4jpsn6xum5
X-Rspam-User: 
X-HE-Tag: 1758144604-807814
X-HE-Meta: U2FsdGVkX1+JZ5NxU0ssHo5ztVg0uDITsMtcXe5rh9vOog/mfqfzaJNx5QU+d5jnwSLjDMt6a1M2c+ViQ4T3VTDOyV0ZVBKxnIG3BFuuk1zVD5xTark+Ntc4/Tp//zrL44W9js5Xxbv4oDXVARcpJgDuE4mJF83wDjpa4gzPkN3Lwm4gf1U2aG0Xf6F8fnz4lMY2W/QXnfhrqkgaZRQjCDGKGT5ZIUj4u9811BjfmM9QShz5md/PAF+SsgwzCx5kAwyqN+ISxcy2eOWxNCLsY3sbgW8XdnHxGSIH1dniTLR9MbbwDfPAZAL6QmE2bD00RA2B0+Tc/ChfsMBHsHsm0S6TBJqa40HdKVOE9S50GzUT5TJqvOzEOIU6gqPGAvXuDd2wJy4Pvg18MWBTp/du5sOQ6cyKzh86nSWqg5ts51M6CqC39AH1qnMzLpmkeKgyKgil62xQPpwt+qfXHYKP7LyoE9hcWlx2F5SybFL9xKNQWBrDiMzTXn9GwzzFkRjjVBwHa3UydC5nSd8up1z3GMQj9JL1dYXMd43t5aU2kDni42Yg834ded0egV3S+QftjdTOJ8jZNRldurHwG3R8j1VQNlPHOQXP5NzMTu/jBIZehIeG90H6tzHr6+DZehhXrSCokmbECeJg7Sir85viUlSx8+yI/OGIsFSQyT6nPJqpyMs5MWAve5g1lPNBy3BX2hWU0B1Bb7+I99zp/NIhnSRIgnm9Y9UlBLi1ZhSHBD42HvadjsyW4PmvZu05AXG9I5P1Qgx0urnQ2x/Qfde1Nf3LLgVfkI9klFJq4T9RlmfaobwltbHB1+vkELhji3mGIHce76AJFpVQuqJqTO7pAyhhZAKNl7OXfFR2X1m4LBa97EAeHaqP97As+g9hYRnIhVHjMpRovHY/7C3mCVo30fFfZGpJfB1z5OYe73MCIzzGdY6Zw/3zZUQrm2lDbCyJeDudWk4tYAoYlikohJx
 W3G7vInP
 2s+MGOE6toPF9+FSpGmlsMvSUoJKcbqGKi/5rLnc58ZYh9ufSK5eDYaFLehCm/SiuyhCDUK4RCG22B10lPrXAyXtiYA==
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
  Changes in v6:
    * Add comment to explain reason and usage of 
      struct cgwb_frn_wait.

  Changes in v5:
    * Protect operation on wq_head with spinlock.

  Changes in v4:
    * Check done->cnt in memcg_cgwb_waitq_callback_fn().
    * Code cleanups as Tejun suggested.

  Changes in v3:
    * Rename cgwb_frn_wq_entry to cgwb_frn_wait.
    * Define memcg_cgwb_waitq_callback_fn() only when
      CONFIG_CGROUP_WRITEBACK is defined.
    * Embed wb_completion into struct cgwb_frn_wait.

  Change in v2:
    * Use custom waitq function to free resources

 include/linux/memcontrol.h | 14 +++++++++-
 mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
 2 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..1568121d25ca 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -157,11 +157,23 @@ struct mem_cgroup_thresholds {
  */
 #define MEMCG_CGWB_FRN_CNT	4
 
+/*
+ * This structure exists to avoid waiting for writeback to finish on
+ * memcg release, which could lead to a hang task.
+ * @done.cnt is always > 0 before a memcg is released, so @wq_entry.func
+ * may only be invoked by finish_writeback_work() after memcg is freed.
+ * See mem_cgroup_css_free() for details.
+ */
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
+	struct cgwb_frn_wait *wait;	/* tracks in-flight foreign writebacks */
 };
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..110937c3671a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3459,7 +3459,7 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 		    frn->memcg_id == wb->memcg_css->id)
 			break;
 		if (time_before64(frn->at, oldest_at) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    atomic_read(&frn->wait->done.cnt) == 1) {
 			oldest = i;
 			oldest_at = frn->at;
 		}
@@ -3506,12 +3506,12 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		 * already one in flight.
 		 */
 		if (time_after64(frn->at, now - intv) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    atomic_read(&frn->wait->done.cnt) == 1) {
 			frn->at = 0;
 			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
 			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
 					       WB_REASON_FOREIGN_FLUSH,
-					       &frn->done);
+					       &frn->wait->done);
 		}
 	}
 }
@@ -3702,13 +3702,29 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 	__mem_cgroup_free(memcg);
 }
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_entry, unsigned int mode,
+					int flags, void *key)
+{
+	struct cgwb_frn_wait *frn_wait = container_of(wq_entry,
+						      struct cgwb_frn_wait, wq_entry);
+
+	if (!atomic_read(&frn_wait->done.cnt)) {
+		list_del(&wq_entry->entry);
+		kfree(frn_wait);
+	}
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
@@ -3763,9 +3779,17 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		memcg->cgwb_frn[i].done =
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
+
+		frn->wait = kmalloc(sizeof(struct cgwb_frn_wait), GFP_KERNEL);
+		if (!frn->wait)
+			goto fail;
+
+		frn->wait->done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+		init_wait_func(&frn->wait->wq_entry, memcg_cgwb_waitq_callback_fn);
+	}
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
@@ -3775,6 +3799,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
@@ -3912,8 +3940,21 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+	spin_lock(&memcg_cgwb_frn_waitq.lock);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct cgwb_frn_wait *wait = memcg->cgwb_frn[i].wait;
+
+		/*
+		 * Not necessary to wait for wb completion which might cause task hung,
+		 * only used to free resources. See memcg_cgwb_waitq_callback_fn().
+		 */
+		__add_wait_queue_entry_tail(wait->done.waitq, &wait->wq_entry);
+		if (atomic_dec_and_test(&wait->done.cnt)) {
+			__remove_wait_queue(wait->done.waitq, &wait->wq_entry);
+			kfree(wait);
+		}
+	}
+	spin_unlock(&memcg_cgwb_frn_waitq.lock);
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-- 
2.39.5


