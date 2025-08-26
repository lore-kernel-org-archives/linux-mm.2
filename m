Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49AFCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE498E00CE; Tue, 26 Aug 2025 08:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D968E00A8; Tue, 26 Aug 2025 08:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA488E00CE; Tue, 26 Aug 2025 08:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7B358E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:16:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52D9A1A07CA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:16:26 +0000 (UTC)
X-FDA: 83818806372.15.0725787
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 86E6E4001E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:16:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WTljuCaC;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756210584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gI8Rkz2xs2TNrO5rkZwGpMdZoPF3RS/IxewK8Qap8Ak=;
	b=hTA71JTIcOlELPaoxG6ycgSMJqEB+7Sa5MJuyTzIFhDUraMhIXg97x/o+BBUz4LpKO7RDn
	76Bp7+X3Zo8n4PDHjrHjwDgPGCYNvLCIjKa1GUQl1HPJ7Bcbo9Fpr2d2/f01VLfMANwYyf
	SUP20pgkFFJSkkesRriLQQKn7Rkh4do=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WTljuCaC;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756210584; a=rsa-sha256;
	cv=none;
	b=68Ru+wKm4wjOg9PF2uVDOHMdOeq+eNSFA335BffmZ8BdHSS8wXyDffQtKJQwplVKXNC3ns
	jtqwNEdoemHhK+ZA8RFsrJLt9+qdm1GgZ+tAcjKHhDDDyjYqTvYjUSiXHMRXRGuVA+jHgH
	Fxl+X1Iihj0ImhUExP/HceH96wGAMWg=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2445806df50so41967785ad.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756210582; x=1756815382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gI8Rkz2xs2TNrO5rkZwGpMdZoPF3RS/IxewK8Qap8Ak=;
        b=WTljuCaCWDNqpA2Y/cPkSQMyUcyz2+ywnHaHPSfTNSekSU2XGc95i2KUH1KvYLHtKh
         WmG9KLAcJRrNCrrpvmhfAxka4sTeta+av3FDMwDQuBCzR9BxDMUsUU4ZCH32k/7pspf2
         6GZSbEyZ5cyITHVujssiyiFduSiBt1f0gi/zWYNorm1d1S7W+8XwhlZf7gPrrTyk1Jt3
         d4E4w//9qpCLFBgOuta0WBrmPm4/tIc3yb8kyUtWcp3CFTOvLdNRs+kuxy31OMezgpnA
         YncG9I00WOnjONNogmXGqx1ISneWTdZfRUtALmW350dBU9cbIjzrp+622KYDNGDtVwJq
         ASLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756210582; x=1756815382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gI8Rkz2xs2TNrO5rkZwGpMdZoPF3RS/IxewK8Qap8Ak=;
        b=hSkvnweUfD6cUrc75mffYH5FoQjTDLylJ6AML4IlXQRot3af2A1Yp9kEn3vt+Xx3s/
         rtee0wq3ORXFIFrsfqdyNBaK3ztXrs3sGJhITtZRavy1lrONjXlH3/BE0opEE2ASSdP8
         ZimpSUj3gUFMAQnSbptDS0YI3TVZOLjPw+Tz/gELy1pe4P49cdgrgRyuhb7s6rMQnn7C
         gybjCWC8rkUzEmGhTsumaAkCj29ypwL5Wk5jHBmr0NZGiAJ4TBVLBuYxggiTuzyVbB+h
         zQQw3UlvhgBhbwjO2DGfNWQ6OaY3rmAbcA99dklTjhNom0eECFB4DPMbeDVN5LRgDpMn
         Rttw==
X-Forwarded-Encrypted: i=1; AJvYcCURjwt514ZoJhdMrgF8h2+GaQLvy4cMlzEkwrxk5k33ucd1q/1TJ2D3ah+bRy94YormWDukcK5fng==@kvack.org
X-Gm-Message-State: AOJu0YyrH7irkBdO2MWquJaVvq+2wJKl75PILVguMGK4zpR2dKAHMZRC
	9VcWbASTyh1nOJKiYYWDhSJc0OgsbZ62+JwgopzZz4o4YuOYmRaG/7YtHzyDgDuviEE=
X-Gm-Gg: ASbGnctzd2I8lUM5nSkRYLcFN+FEwNLMwM1NyBUADVp8jgdsg6PcoeYlbLVy1hRG0ks
	z2/UQAoBJ4pVMsxDK3zgb101d+U0tqAsDm/QbjRQ0AyKWJ8VHGgdlrF48Y9H/aqUpJBC2xJ+NT+
	Vx9vjtOO44iawzQfvmvsTJnJ9qVuOyXS9j9wc7QaIGqFHFjs6vytSPHK032KdK/cNlPuyjpZpF+
	Ios4SNO++CfLIMzTM2t0dBLR2i8VLsu6s3F/x1hS9TuajV5paGjaJ6GrgQivZhuLSQacl5F3xvV
	Dc18x9QIbQo+WKzO3wVqzkEiE3ksDoai8X4QqVFcPhgyHFTYEymJNotnxzyyhwv/5E0v64iV29W
	cYVQ/Cl6+An+NzI2ieDwe6DRdwg6X9g==
X-Google-Smtp-Source: AGHT+IFqn3VtdQOuMTY/ZFF0B1ec+ONaoq3koATTk6iUYsrDd3VlLlXjAabCYWVUIup+ISfCqmsHZg==
X-Received: by 2002:a17:903:2f08:b0:246:3583:394d with SMTP id d9443c01a7336-2463583555emr192356195ad.29.1756210581656;
        Tue, 26 Aug 2025 05:16:21 -0700 (PDT)
Received: from localhost ([106.38.226.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-246687a59b1sm95376665ad.42.2025.08.26.05.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 05:16:21 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	jack@suse.cz
Subject: [PATCH v2] memcg: Don't wait writeback completion when release memcg.
Date: Tue, 26 Aug 2025 20:16:18 +0800
Message-Id: <20250826121618.3594169-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 61mtnxnwunf8qkqrg5bqtxnkd136914j
X-Rspam-User: 
X-Rspamd-Queue-Id: 86E6E4001E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756210583-866615
X-HE-Meta: U2FsdGVkX1+bkKC6v6CEqFUvHXEc93Vih8kjj+0QsmG/WBrdoNQvgV1KXIye2G1eA6Pbhh+xMjd9QEqSZfP8AfFZH1k/Iq2NQTEvx89kwXVmkHundsaJWtFe/nQdGASpK2ekwSqoBW7KGAXQfp0XLqpN/ybTaP39LDMD2ncyoVu+CZn4NTNR8lQzkbcTw/1OUdIt1i8C+wiLaQha4ALB5D+CzfZ6mGA6SKWp7O8s866N+Z/Yl01l1sZgB9rNKmWP0hGgPkXceMoSddO6+LRydovt/Z337jhaJ/Sj3SMkWYFRNZ2ul9akp39zDrD38IJAd2rcTVY7Kwut+KHb8YeIRq+B79Fyk/7nX0Y3rUmbRPagww2RSTAP6ACqtYSfSbQu/pGMEVQ9qn2vH7hh+IyoRWM7JwCOMZNYu2yju9c4/vbXmHVbVdlpshgCYGt6ZHPHTUIDAGRBvKhOf8lu2RGa8vzcdGztQlsk06LiUgY7l3ypQv9IYwk2HOCAEgA70rk11Y2fV2R+O+XPwc7+0z8arbWitJTzafvnmtdV8HR5CtTplhRbjKObC3Yu5Jcl+7QRq+YqfJAOVk8zcEY1USNvLQDwXQUBT07cJrUKLAeCpfzCSM2671+ierU7dSVCobLd+sNvM8LnmJ1hkbi2jW5PbvOpxv1iKvsEAEwABLcLKxNCFI6kysk78PQ2+fN7m+gWVfO43s9ZWGjJA9shq8Gi40NI+UA82LNSLfABX+r5gqDlC+b/nCF2DiE6UcBj1DBTr0em6V+Vrju7lWGZB+G6urc7IPCTdE+WpjtlQBtekhTUpjQjg6ydwVwwbw4GPH6i6JV5UlYtqguR3uG7nbCkoPEsuN/qA8FZCOBhnWcToeY9/ZjhpL4Adpt9DDQVa3IqFw+B98N7MwZy3f9O+ulY9K+VXhDODbklSL2qtg3BqaHsCIIU2vhPmN4jxxImULq/EadRLO4nua6YUPKq7IV
 v3L+lOVt
 swozV2nuRfgK3/lfYQLunYWRHU6yJkXJvay/S4LDQ56HaOJORvqVCdZGhXp0kK6c0p0CyYZN0qx9bUO/t2Fh6YdPUkfof/Kr32xpqoLJd7eoO3yQkluS0ojzq9p53KRt2XpSJpynbrKicDVtOivU4inMfHEKZka4x3CJoMDfmCbDQvN4iJZBZTp5eOMP7Tn/89zgws05i2kLspHHzX1CCO7MEm3Z3bzOtiVR4fmVeeE0fIcCVx1ASH6BMJd7rjsqXh7U0hS+u8KBSxmBFkfmu761driviVx3+zB3Ugfs+rKKxIRcF/EVj5bZu6QgHREinIXB/
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

 Changes in v2:
  * Use custom waitq function to free resources.

 include/linux/backing-dev-defs.h |  7 ++++
 include/linux/memcontrol.h       |  8 ++++-
 mm/memcontrol.c                  | 62 +++++++++++++++++++++++++++-----
 3 files changed, 67 insertions(+), 10 deletions(-)

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
index 785173aa0739..f6dd771df369 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -157,11 +157,17 @@ struct mem_cgroup_thresholds {
  */
 #define MEMCG_CGWB_FRN_CNT	4
 
+struct cgwb_frn_wq_entry {
+	struct wb_completion *done;
+	struct wait_queue_entry wq_entry;
+};
+
 struct memcg_cgwb_frn {
 	u64 bdi_id;			/* bdi->id of the foreign inode */
 	int memcg_id;			/* memcg->css.id of foreign inode */
 	u64 at;				/* jiffies_64 at the time of dirtying */
-	struct wb_completion done;	/* tracks in-flight foreign writebacks */
+	struct wb_completion *done;	/* tracks in-flight foreign writebacks */
+	struct cgwb_frn_wq_entry *frn_wq; /* used to free resources when release memcg */
 };
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..b47f3972c1ed 100644
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
@@ -3702,13 +3702,26 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 	__mem_cgroup_free(memcg);
 }
 
+static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_entry, unsigned int mode,
+					int flags, void *key)
+{
+	struct cgwb_frn_wq_entry *frn_wq_entry = container_of(wq_entry,
+							struct cgwb_frn_wq_entry, wq_entry);
+
+	list_del_init_careful(&wq_entry->entry);
+	kfree(frn_wq_entry->done);
+	kfree(frn_wq_entry);
+
+	return 0;
+}
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
@@ -3763,9 +3776,23 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	INIT_LIST_HEAD(&memcg->objcg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		memcg->cgwb_frn[i].done =
-			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
+
+		frn->done = kmalloc(sizeof(struct wb_completion), GFP_KERNEL);
+		if (!frn->done)
+			goto fail;
+
+		frn->frn_wq = kmalloc(sizeof(struct cgwb_frn_wq_entry), GFP_KERNEL);
+		if (!frn->frn_wq) {
+			kfree(frn->done);
+			goto fail;
+		}
+
+		wb_completion_init(frn->done, &memcg_cgwb_frn_waitq);
+		init_wait_func(&frn->frn_wq->wq_entry, memcg_cgwb_waitq_callback_fn);
+		frn->frn_wq->done = frn->done;
+	}
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	spin_lock_init(&memcg->deferred_split_queue.split_queue_lock);
@@ -3775,6 +3802,12 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	lru_gen_init_memcg(memcg);
 	return memcg;
 fail:
+#ifdef CONFIG_CGROUP_WRITEBACK
+	while (i--) {
+		kfree(memcg->cgwb_frn[i].done);
+		kfree(memcg->cgwb_frn[i].frn_wq);
+	}
+#endif
 	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
 	return ERR_PTR(error);
@@ -3912,8 +3945,19 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
+
+		if (atomic_dec_and_test(&frn->done->cnt)) {
+			kfree(frn->done);
+			kfree(frn->frn_wq);
+		} else
+			/*
+			 * Not necessary to wait for wb completion which might cause task hung,
+			 * only used to free resources. See memcg_cgwb_waitq_callback_fn().
+			 */
+			__add_wait_queue_entry_tail(frn->done->waitq, &frn->frn_wq->wq_entry);
+	}
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-- 
2.20.1


