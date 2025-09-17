Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16A1CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FC58E0031; Wed, 17 Sep 2025 11:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510F28E0003; Wed, 17 Sep 2025 11:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426B78E0031; Wed, 17 Sep 2025 11:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 307D58E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:01:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7ECB1BA385
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:01:19 +0000 (UTC)
X-FDA: 83899055478.24.5A6253E
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id AFB6120025
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:01:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="kx/oGDwo";
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758121277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nKi4DW8qyBYaf77xdVpB7O18iAFKaONnRRksjJMXexs=;
	b=BweRti8zOfKX3lfx8OvYPHiNlKYWUN7hWLbdV2mjfA+TSGuA4A4zKDsVrSHEMPuxgRji9l
	0e5HPW1mQW8vqvCtwSubIDrOXsrwFCj+gxl39jtwScnZia+OK8x0qy+T12d8sok4SLV0VX
	nmGxhYNhXQ8/4zLx/PSHTaocBJxsFlQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="kx/oGDwo";
	spf=pass (imf13.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758121277; a=rsa-sha256;
	cv=none;
	b=SN3weutePSQtly3SVzzX00dsQNwwvCMLslDDAgl5nuRgtGwS8oaSOUdrQLIdkl6XGdpzMN
	h3Jb7RFAMdx8RgJTkmGhlASNGJZhEW+2gEpLx78aSrMZWAWl1NCwtXFBXbREJkEUNM+/Zr
	xvdGcxAF33cm37yepuz5iF4NLc8aN04=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77459bc5d18so5352529b3a.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758121273; x=1758726073; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nKi4DW8qyBYaf77xdVpB7O18iAFKaONnRRksjJMXexs=;
        b=kx/oGDwoQABtknL+mNxDCbxrhbXJblFXGarVrcGVV3/W3KbIm6Nkyc14968yJGSN13
         crUzR/FUW9wnLlOLI7LKzI610yKmDc7ausROoXRHN/cOXbhPtI0nggMXMBUPlZIiUkgs
         4fKE7uVl8PbSFaXI7M+w3mM+kef1FFiJFOeWCRRCsK9w8ZI4Er6M83fIMrMRy8CKG4In
         Vhd54cL2pw1CzSUzYXWL+8Pxiwg5O1LANZNvEjNQWoQQRwLp5IYp4U4KYZ5Sd4nTBNiG
         Ea6NlHljz9ZQfgZXg9jaXeRf67zTNGMnkGmWIprlI2w6DRWhslXhkMR0V9vhNSbpmACc
         /gHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758121273; x=1758726073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nKi4DW8qyBYaf77xdVpB7O18iAFKaONnRRksjJMXexs=;
        b=AaogEiqSiADHuJrXWLtuprsKVNGDtxQ9AnbVPkxbnmOszyE7aVrqgrZhlTYo1NH4rP
         00kREjaDoA0Z9lv5UhxcA0CEvhRL/xn5gJvQrmNNjJ71DzJG0TzhmmLXcikWYxAY07eb
         oetAgnTmSeP8AnotZUsQxHcfYTEKseLnV9R4Clvc1cB7ErvlnrH5DQhrZry+LPIi9XhS
         iq5azBvobWMoHa2lgdyVGTy5tz+qi1zjw3Jv2YzX/7UrAJP3U69fjoFFdirHi+3UfJoO
         ikhF6ijMbRaeTUpq4uIX/HTCd0jrz6oTj2nhpwCZVsxgUaD/aSIIH80GTGZ5B93yaZkA
         9PhQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5NtZYYA+xELX3uANOS7kG3qRjsjpmWcQe/vRkOh4+0e6A/SF9+P0i7dJaGbI1i9COyotGXIofWQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6lb8RxcnWO3lo4uXB69pxOuE6oephtTYeCR7Xd/4jtUCyVhcx
	mfKHwNuLaSN3jDKogwH6dnTYw5A9aV6M5HDZKmqn8CWZs8s5XqbpWcKZe8F+BNMudF8=
X-Gm-Gg: ASbGnct3vyC5495nXm0DH2LyrnXf5pIkAYOIWZgF6LgIDG68q2ZAKCZZUyutpjMDbq/
	Ghi6yyCi9MYVOi7yAcVHhd7l2vc67znXjTokDEdzTgJpYjIsGqM3UrADbizD2n+eHsqKsj8P4IE
	ErPwVqqHlT2tkWR7yC3TiTTZLjSYQAdF9ZbZztRWw6Zo3ub2qH15m1Rn2H8xylm4u6C0bt0Xa4W
	ywge5Dfv5Dw87aT9/NAstg2i8tHLeHbVlnzzg/UtK48aUb4aa6poixbBbXiI8Uj/nE5CAgoGh9m
	Q4xpnLIfQ30c2Ni7r7OTrJUjN9eZK7oRj2IX/1UMnXwQtYQFmAViovUVZw+rtHm8Fc/uEGMdgvs
	DeI8NbrLYMo1o
X-Google-Smtp-Source: AGHT+IGJwBbOtEp0InL0OKeRFFWcoGgPbuAseDmMt/h9ezDlSGJtszPfcPLWmvgcsKk58q22XTzLUQ==
X-Received: by 2002:aa7:8891:0:b0:776:f2cf:7ea2 with SMTP id d2e1a72fcca58-77bf99505afmr2995944b3a.27.1758121272431;
        Wed, 17 Sep 2025 08:01:12 -0700 (PDT)
Received: from localhost ([61.171.213.183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c478d4sm19344959b3a.99.2025.09.17.08.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 08:01:08 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: jack@suse.cz,
	tj@kernel.org,
	muchun.song@linux.dev,
	venkat88@linux.ibm.com
Subject: [PATCH v5] memcg: Don't wait writeback completion when release memcg.
Date: Wed, 17 Sep 2025 23:01:25 +0800
Message-Id: <20250917150125.331701-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AFB6120025
X-Stat-Signature: srha1og4m9zreka7ma51t444s4p3681j
X-HE-Tag: 1758121274-375186
X-HE-Meta: U2FsdGVkX1+xYOuJL3LTIkRjic3UOfceDviq87WS2ZHc4jIPjSK7APld0Aq2TZUzQHgzOipKYdvdV5bxI67uDOejZL8EeaBrdzGNVDnA8X9MikxrE06slGfTCqINEEBBvvN29iHTNdcbzP6XsoSndrtA9PYG8BzEBCgjxcOs0Pa9k823JPfFtEGR3FjIyU5JfxhpsfKWzR9yL7BetemCLlykRc0SdCAiVv2yGMyAPzc1xZiNmdWvpY0Cho1MmROEh5YdMiayJUp8UVjDUHaUgZqesRi7dMjXprwmP2erf55xlN+u4hRd1fMGSrfh9WgjVSsGfaidRAYGDZ2ATlLSy1SKRx58q7G3ddKWfQp+5UMlXhl0lM41POXv4rpMuDen6rCzlI1plP4ET10JxoE8c9am5MFEeSbnqENWvBUZC55LGx0yJBU3Th/OzTpX49Dezyg9BY4RTIdwaUcNtsDbWYO94eALbL5d/KhZRhR5MDBYEOl3+AcDza0YX9qK/cFkVKPpiQyqdekvrDVPqlfEintT1rNw7FPGcpLWRSNogKYLETueLU3gW71T1+Q08jdglssihyx2LsWTf/Nwu4BNaJSwnOu6jokAqBoBjwur6M2p+qJdGGQZBVk6zdwrJMS8zcuariib16I2RJDlVcWJBH2sDsHZFuXtQs069RWREYjReUfHW5VWAhsalj/jeEUokiuaOK3iajPArd5mld/3mePU8qmmZvZsi6J0pFJSDeo1h4jtF7415w5VTlTho9AtaCnBGtEvYLZCuqkbKJ747yUlMT9C4IRNF3UsrQIfejC9yQKgcn8vIFIcwJDERaCIKVFAyFss0PfbSoVHvYG9ibBzHDb4TCIHrLhKhwS/OYMK8oeFJayvBhxMLOefx8+r5SOXeX3zTRu6n0W+McctsSbV/C8wfILcErWSRWLnfV7hpuHOjVs7cV4o8y048uTOSZOAn1iFOdtY/sHwe6u
 bLdL7o+l
 wL0BV2P/dt9sdx7pULqgDaGGlyiXNX1fS6bXafhJB0mF9TMpqcyNLZPrYE7jDYIKag4hlUlLGTaw2zNlOPpnwqGZfQQcYEpCq5FuO41Nmsm4AIGZcRBeYC/ljnnq3rpNY5ebf0VarnEyx8TX668xU2TRIaMsgP58VWw5M3mEwbMwpjSOwVs0AGuw2Gu3eVeBsHHQbZMEcvlbL5y80J/VtSjjsVAwki7DQzFGxGnvLoZaNJMdfOz7O2I0AHQcaY9rsnwF3X4uozZYB8O/GlWPIOuVZ5kyHn/SagbL5ogpi3WJCtvQOLmhgAjyuv8zc/sKPc8BDxTQ8098H4y6UV1Wjfgm7+nZj+jdX/xyelYtVCDplSGceBZBiI0dd8Q==
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

 include/linux/memcontrol.h |  7 ++++-
 mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 9 deletions(-)

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
index 8dd7fbed5a94..35da16928599 100644
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
+			list_del(&wait->wq_entry.entry);
+			kfree(wait);
+		}
+	}
+	spin_unlock(&memcg_cgwb_frn_waitq.lock);
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
-- 
2.39.5


