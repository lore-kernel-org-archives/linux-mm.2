Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E3FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4B68E0009; Wed, 27 Aug 2025 16:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256098E0001; Wed, 27 Aug 2025 16:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CD28E0009; Wed, 27 Aug 2025 16:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1D998E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:46:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3B0C1194FA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:46:05 +0000 (UTC)
X-FDA: 83823719490.11.E2435A9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 18F8B1C0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:46:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ko0J2i44;
	spf=pass (imf20.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756327563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tctTRzMCruhxGok80DE7/KVtROSFG+xyvfaf/L3fAFw=;
	b=eaywnmG/R7pAYDo/HILRyNhEiWbtXffPNlB9Wiq/Wvyta88/EKcuTAQosJtBSNcfqZ5Xj5
	Yd5O1ueHw3oYHr2RD8u1qVkDANinj4h+kHor0x4odtbsJOGN/DNijbXOLnSrT2XT9Ue6uJ
	VWtIyyg5NcsMlIiDW72CQgj4EjPiJRg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ko0J2i44;
	spf=pass (imf20.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756327563; a=rsa-sha256;
	cv=none;
	b=7HDImdBVruK16o4aiw4r75C8R7QwHR69Ky6J5sMDop6al5Hcd2cZt9V3HXDRTYrgfDzXYa
	eXq3pph4fCjLql+GUZ01STKlg8C4/do76jaixCLYWoPqQPDIuVnbol5wA4x0JvuisTb+ob
	ARtXqPgmWZaU/gHW6xfnHNBxILqYnuU=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2445824dc27so2644105ad.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756327562; x=1756932362; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tctTRzMCruhxGok80DE7/KVtROSFG+xyvfaf/L3fAFw=;
        b=ko0J2i44niFVvIBYWAadYDD0pfkifIA+t8ao83Sr2e+4ViQfezfJVpierkGL6rKX5j
         rgALyl3phAhHrXA5A08mANlXu22wroIo5q8FquU1QyW7y6FSqjiqPlp2GJ0qglZeviYT
         r/judAlQcF+BcVG7EuHkCzOFjwGv6K6/Tx0MQ5y8tC4VLS99Ym/IqqWo8QBK1YlXlN4G
         hNQZ4Q9aroqQcqUjks+FIaP5Nc1YzfYaQKzHOPxPxPwJVNHmby0A9sVhIVW7ZfaC5O+P
         kg4X3cbAE3LuL6rg1vMqptoqiSZwANDaTRMsjqQdwFF41XMJZdewIysUI9fbHB3PpZlk
         j7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756327562; x=1756932362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tctTRzMCruhxGok80DE7/KVtROSFG+xyvfaf/L3fAFw=;
        b=kwa0gj5Yik0wgVPkoIGjJzynhrYg+WWDk6LSROYSBnIvasPWb8g6b+FM0jh6o2sno1
         uZjoUopKXyBRCtq3r5aGVuC2l+ZTNiWYwaLm7IGG/kt1dJc92dVXaF8WP/bOEWrYGZkV
         2zhGjUk19lit+sJ2BQTJwyloq4JeTcS/h4TSP+TXz1Y2tb/Y983SBh3KFrwuHQKs3FCx
         Zpn/Ih5Urksy7YRnTggB/Rs0wDHekvlOJEDtk35LxTdOO3Li8udI/pMLi4UCDiCBHS5C
         yyoinfUkq1FDzr6kSU7C0b1YBe7TzDBOhbLACZxt65/BFd8Ehm+Bp1/cLTUTab8jsBSH
         hhZA==
X-Forwarded-Encrypted: i=1; AJvYcCV7lV7KXT/kPydPfLz3Zzt5ipeDm9Kkfm8zkfdzkCl0eG39EC15fbB+Gwbe0qLEs9pMyd8UI42BaA==@kvack.org
X-Gm-Message-State: AOJu0YyjliykwP+GoRRkIXkNFu/nJLkMVAuKRa2/89DoNfRoPyYgwVaO
	js6xedElOMnyPM2C993676ZkRem6JL2MRtB7CRIWuVdyAGppmrwtXpQ4RWn9z+C236k=
X-Gm-Gg: ASbGncv7NtzGC0jpwfmRKKX0rqTCfmLESIWUjVWukbqJG44jlEw6KjFCLwWATqKrhul
	g07yrvkt1yZdfUU4sxrViAU65Pzud1zKuc2kbdrb6+755psbO3NRw/b+/zr4KZM8fyADnxiGUTM
	oRgfoWJdfsMl4nXbAbeUZ1PAoY2FfG4HRtf7Y9T7kuR9LAJNnAXgF6h7aIOusm10JC+VdClTUBu
	No7IQPDJmBSuc9WoXSx7u/DygpboVBW2xMhNsu6z03N1X1pV2O0GKtRvWYBe116RnACglaWJ/LY
	tlp4ZK3FKNQ/dXpxGdJtS1tj/xuPF36RI2OMJAawwucrVlyt1i+fRvHhfwbys8vjO/lMVJPVhP5
	Ex3UyPzVfpb4=
X-Google-Smtp-Source: AGHT+IGaiq+neKRguR3f2U+9fwVH5TXz+ava5fiaIEx1ae57rW8pmGVMxhPsXC8/DWaz+qI5C70qiQ==
X-Received: by 2002:a17:902:d4cf:b0:246:d769:2fe7 with SMTP id d9443c01a7336-246d76933b2mr167232345ad.28.1756327561528;
        Wed, 27 Aug 2025 13:46:01 -0700 (PDT)
Received: from localhost ([101.82.184.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24898a617d0sm26044805ad.15.2025.08.27.13.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 13:46:01 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: jack@suse.cz,
	tj@kernel.org,
	muchun.song@linux.dev
Subject: [PATCH v4] memcg: Don't wait writeback completion when release memcg.
Date: Thu, 28 Aug 2025 04:45:57 +0800
Message-Id: <20250827204557.90112-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18F8B1C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wic3pg8bt67txdbjari9zwpuuj1u4pkw
X-HE-Tag: 1756327562-580635
X-HE-Meta: U2FsdGVkX180Cgc/gpEAvuIJJvydtkRv0/bV1JuuMSjjvZvfjKhtlgyovAurpmX83SYda8gjSVn31v8Jk4eBgzlQZHZC3ktuGQ2L9ukOSiUFxCPyIh17zmJf0QFk4zX66jpWwuhdCnpd5WZdHfEXSDkYNVeD5ZYkQktoFyRKw8+LSXNfkJij8R7v6rW9CtGcnSXueUuCk1BvMGGa6H7Skkq01Jao3iROgH1UOBteXHekNd+Y+2tYS0JkVppYjEVV4V7uLJNxDz7XGZWNMDkMpKsMm0NYvzcL9aFOKkWq5EPhKegQnG2IDG/Tf2UyR3HbnRTZOXyxfChDm+z+TZlu/F4F1goyuD8T55V3Qe99OFWxaGyFGBf7qD5nq/D4gg3hr/CBJsDD9KcGXb7qOHnkU4VOWUbS8tr0FCy/gCEcV5DnhkksJ/NxLE1QNGqVbw26IC80mX25buR/Ryz4+6v0VjIuSCy/knlBzLb5euaEfitbIkW2Se8NBMIvYopFOMzUSC478YmSDlbKTczrzObfseBFZWo3gLUsNH8iO3bYMtv7V1W4X24hE+qzWrC3awkZR8f4NuUzOUJBc/VL8BAgXhSZaUdQGhgx7FNfHDbJ00+A2EmITTV8+dgETvn/QbjekMJF68A3ypqus9bTkPTVhg0PaDapBl/ve2HWrrDrvTA/vzCpnlysyEgVRsSBEjIKA2UgHqaNiodAJAqdlE5aHCoiFC1eRlcdq9Ug7U2EI3mYAElUMWw/OBCKrtVW5m2g9dxFt38mdDo8d3L3/fVQflPpMWysMdh3oNaKRlAKgIFDuFNn+FneGN44SvSw6oLZPXiX26uo21zHXAJ6HXz/fCUvLn8t5fC/bljCWjKojXjogxv5duc1Yao8z7W9/trCAGFNienxfko13kkuZ+b79QSMqPwHULNSTBKHQcbfkB+dY1vJfsNPUFLXdrvgZinF+I2Nb7uTgIGmgTXs4aU
 F4jQFe5z
 h4VIkG8blNj6LaVGO6cCDzPwwwyaKDCgeVopNqUPZsZxbPayCiLs3dWmRV4Tlv/zT3SX16q5Xo2bb5lFUhcZ//sT5rKENMFdCLhiluvnN8A1EV8BczUxP4IV08AN4jZ8mlfcM4Bm7GhhNWLiKOMFX1UNpelPUlvCh5lRaxbgVJMrDHHOtFaBOE8JrHVCaqD9fwjZ1ZhIcm4OUOQ+MZNK315fiT/dn5xBCwFk/YNHqFFn1kXK/ZyATFiVVR9SqtuKYZPvAT/pc21UrqJMLweHDvR/4h1KyENk07fULTYX6uNE6p+pBiBirp4svPg0rG7lz1AZj
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


 include/linux/memcontrol.h |  7 ++++-
 mm/memcontrol.c            | 53 ++++++++++++++++++++++++++++++++------
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..b16bc4bd0ad0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -157,11 +157,16 @@ struct mem_cgroup_thresholds {
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
+	struct cgwb_frn_wait *wait;	/* tracks in-flight foreign writebacks */
 };
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..80257dba30f8 100644
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
@@ -3912,8 +3940,17 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct cgwb_frn_wait *wait = memcg->cgwb_frn[i].wait;
+
+		/*
+		 * Not necessary to wait for wb completion which might cause task hung,
+		 * only used to free resources. See memcg_cgwb_waitq_callback_fn().
+		 */
+		__add_wait_queue_entry_tail(wait->done.waitq, &wait->wq_entry);
+		if (atomic_dec_and_test(&wait->done.cnt))
+			wake_up_all(wait->done.waitq);
+	}
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-- 
2.39.5


