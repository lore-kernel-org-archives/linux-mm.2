Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE005C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 06:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F096B008C; Thu, 31 Jul 2025 02:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11B26B0092; Thu, 31 Jul 2025 02:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF556B0093; Thu, 31 Jul 2025 02:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 888F76B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:51:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 184F680968
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:51:03 +0000 (UTC)
X-FDA: 83723637606.21.254AA48
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5055E40008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:51:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IvhpilKV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3VBKLaAoKCO8iZTYRiUpTTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--richardycc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3VBKLaAoKCO8iZTYRiUpTTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--richardycc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753944661; a=rsa-sha256;
	cv=none;
	b=m13MA1LGDyXqRVS8Ri+7t1XUI6/eNvXouT9ip5FZB8Nnw5aoFzLGBPLm38v+s+jf1OIj8z
	SU50ykxS1JBnjQyhFIYwI8grD63od7DisoyNJwOgPZWX7JTBk6oPBG84rrajlQZ1/t7CDU
	F0FfHU/Yx76jh4UORlvsGFZW8LZLIJs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IvhpilKV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3VBKLaAoKCO8iZTYRiUpTTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--richardycc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3VBKLaAoKCO8iZTYRiUpTTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--richardycc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753944661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S355pAkI7NEC7JgrgQtUxkZyhDtDgj0z6R5QsB/4a/A=;
	b=eqVTzw0iOn8iu4AKKIBtNlUhyraAGa1x8uGa3n4L2t7wQxn31Uep3JdOUdoGHk0n1XK6nj
	azcuEXxTIxgvfQiFvSV1H50QS8QSMbVf41u2ai1i4FD6Cssuvp7NpVHGaGuBXzwkRB+dmH
	JQz3MeDPp2EYZFQbTV3p8wM3sU+HkT8=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74d15d90cdbso725485b3a.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 23:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753944660; x=1754549460; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S355pAkI7NEC7JgrgQtUxkZyhDtDgj0z6R5QsB/4a/A=;
        b=IvhpilKVyzKV+h61XNu/WSznSjuTxQYtzgmqmLB7yR0dOUmzMxbWyGELmcxxyLQN1A
         47VBA2Br1bdzJuV9p2hK1DLrpRmd3Ofrsa6Cmi44CSA5vFKOkmnEiUSozPXOM6UEB+81
         DhryI0n3vozs2KMO6FAwHrOsngQbZH5okqMH4bnD1LGbicuZmwg/kG2cW92yV/WO5Is+
         ljnCLx2zIBI7K87aD7piipNcrAW4YXWU0cW8X3LPejVR0fuCH43+VaNWJ7/VyKwUAaV7
         HyS3v47tK2SnmggmfTzzeWsCXSSLhEDaJ3clibcEzlasc7MmHcZCEuBHlmlglA/1Cre+
         YHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753944660; x=1754549460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S355pAkI7NEC7JgrgQtUxkZyhDtDgj0z6R5QsB/4a/A=;
        b=JITgzus+T9Bc6dgc3it7xXNFhmns5+IozldNLc1jChUem0kEJfNBBsMAuAVGyjRfR0
         9TgByUZzVdCmJhJfyd7Y6cEx95zjVtjn0o6MfBkyC8/Yc2aEss7YciF9f+iUNDulR0zZ
         pSsI/UnP4p1QxnMZbMG2vj1U9ZbEVRzvnIwgEgH4ZYCuGK9FNWpz1q3gPNLsyBgBpRRr
         T8U8PhjK5d/YWZ4jJatL5Wo5IjoQvtS5ekwGDWYI4gHR1T7hbHeImfWIcYDTdEuB0Of8
         4n6m+ISpsGh3fhElrwrb1rAjMsy0fGthembG9rd4qrdrF2iaVwRlYI/N4Y0S+R/GC6RD
         +Tpw==
X-Forwarded-Encrypted: i=1; AJvYcCWpaMxexT3dDhkRNXl6qQGNSG3fdzaBuLN9JDn+IZtX7+pADTAu8z3evd7YCftge+mL9z8yF4dDAg==@kvack.org
X-Gm-Message-State: AOJu0YzwqoW/9merHkzyvaX4DM2UkWj3S7Ja6UdNr1biFuSYZSuiJVy3
	X+IzkW9mFBKQ7Up4rsJzooTivh4ugtRkgsHfq5odjsiYoVnbhHoRwv6gjALHBYm+rLWE87ctaOn
	5RuoplRIRXz2qd5h6cWWT
X-Google-Smtp-Source: AGHT+IFMUHJAFt8LKadusLSxWtpDyV1hCcQ6KorKLDjQu0fTBgiS1ZlW3Ro3SPn2MxUk0sYyQq397lMznVYTEcB5
X-Received: from pgah15.prod.google.com ([2002:a05:6a02:4e8f:b0:b42:2a6f:4fcc])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2450:b0:233:951f:a572 with SMTP id adf61e73a8af0-23dc0d58b95mr10119563637.16.1753944660091;
 Wed, 30 Jul 2025 23:51:00 -0700 (PDT)
Date: Thu, 31 Jul 2025 06:49:48 +0000
In-Reply-To: <20250731064949.1690732-1-richardycc@google.com>
Mime-Version: 1.0
References: <20250731064949.1690732-1-richardycc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731064949.1690732-3-richardycc@google.com>
Subject: [PATCH v2 2/3] zram: add async writeback infrastructure
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5055E40008
X-Stat-Signature: et6hpdygd7r7umk4fcts65y9s953w156
X-Rspam-User: 
X-HE-Tag: 1753944661-473270
X-HE-Meta: U2FsdGVkX19XyxpOAnfFuwCISGaqQWWow1qAS/wvN67h/qFYXEpekPheQk55pozwcEkSFO4uLf417Ewy4N5wuITzElpXCd0cWdGootaFhzL+bq2UVYt8/eydd+pX+tSWHXDyPP8U5KBgQ1cz40kM+EaZ6C//ZQnYFaV2iqlCZ61R4eU1zxYtzDraAKMCMhIz4TegUYJ/1KkFOLiLMmzcpeQ6kFM4HUPz3TYbAYXVc0kT52rmBD/8NHJ+edG/WCqkssaPFNwe9QBXE8Xy54p/T0f8kQ2wgqQFm38DlIRCIknLQvdO3Eo8kmLLfEvxZZXbBKSnitdGiCilaMU1NVxrHMSfzKztJLuxWy4sxUPshkbCGSudyxQvJx37e+J4dfY3K88BQw/ldUKObnNeHc3SGZas2b4raFDmTTQexIXu/ohODjilKRK2A0ASq9yoaw+1OkU854MJYcB9xIGYjBQDWNImM8R3CHL9B4rDkTvNbfnIuAVCt2kYBvaObzt/CoZf7f7g2HxoQKiaXAF1hknvgNgLJGixI2W00IDShGoQ7Ni/vH2SE4KonTNFWKxXjbQT0/JeBgG4Lbh12keeJXrnGWRgHTJvDYh9pUcV7GkoJS/KwoKKru7tE8Kfh/Ut6Tz+OLc+RR2p/sMoufPechKMoYeq5GWbrFeW6i4wTkD4o8GB2qM9mAjbXHAou42HMvACD25ArJoVMT0hXBqvqq5wFISKO6LSjIjQL0/I0VE3ROoXBlfc7taZoMRsTVpUSVavQQPwZZvv+iwbGccc4WOpCI2f47szyHDo7treWfUL+V/VHJkKnob/nHVdh656SMoWxKp/x2EkaspsTAUV3sF00Lpf1u0qlHV2T5JoHza0NPk3Q63Vup7p9C3BJVJzI+lmkFJaCBqX4zg1RJAsKHq7N1B9N3ye0+rAki3uRCUC/SB2EDMSs1lfWqPe57ReP5pu8SJHkxV3PNE4Tv8JoJS
 t5V0zF8U
 5zk8qbH8LHrB+apS+FCReFkeaCtraNgcrf/K0f8+z6rKhA6gTx5+1v1l+J/5xaLOc+XU6LEliFIrIytbY2Wuo0V3DL8bYIUuRIWZGDJJ/zfOZ+2dlokMEYM3518Lp9MEYABMWGoczABa/TUSuugUhV3tpnn+McuYR9scwnq9YhGhoIJgaMpg/it5Of2iCuZCm77l4vu1YSkmq9P/On5Bglb0sVd0zDwNFw0bhF6hD6rR5sbnGkiwFA0/nlCAOxgwuRM8gDQsbKe+yeJTAXaO4WGS7pWiAwKJZktRVoFHzVePSYAFYSIV0ye+2ez0dj/42Jp63IjpGx0J9Q6SOqhxom3JIEOg+nT9pMdp2G/I/xQSB9b53d8M3BI0RhUMZ/acogTfELZfKcrrYRyEfsoUd20OS8BzSUUKQDoPPELFcBauAKpEbc2RK2uMqsSh9J5TMgl26ZBNvSyigFwY6/sqOR/batIn/a2q9IJWffmD9GyavsGxxOB3ZMBIF1LGsvXpgGg5X3G78dozVM/UfXidhfnJ8EC9rG6XuN43Y1MQRNoWvcRvrILVaNxi+KEo2cUlpU1uchiXEE0j1VB86Oqrg3P1MsZMvocPHZfV8Bo+2nZL7vF3OdpRpm2SXOrnKPcRvckQj9+wFh06ZTB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the necessary infrastructure for performing writeback
operations asynchronously.
It adds a dedicated kernel thread (`zram_wb_thread`), a request queue
for managing pending writebacks, and helper functions to deal with
the writeback requests.

This patch lays the foundation for enabling asynchronous writeback in a
subsequent change.

Signed-off-by: Richard Chang <richardycc@google.com>
---
 drivers/block/zram/zram_drv.c |   4 ++
 drivers/block/zram/zram_wb.c  | 114 ++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_wb.h  |  22 +++++++
 3 files changed, 140 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ec8649cad21e..6098c0bb773c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2871,6 +2871,9 @@ static int __init zram_init(void)
 		num_devices--;
 	}
 
+	if (setup_zram_writeback())
+		goto out_error;
+
 	return 0;
 
 out_error:
@@ -2880,6 +2883,7 @@ static int __init zram_init(void)
 
 static void __exit zram_exit(void)
 {
+	destroy_zram_writeback();
 	destroy_devices();
 }
 
diff --git a/drivers/block/zram/zram_wb.c b/drivers/block/zram/zram_wb.c
index 0bc10f725939..63a16dae5796 100644
--- a/drivers/block/zram/zram_wb.c
+++ b/drivers/block/zram/zram_wb.c
@@ -5,9 +5,16 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
+#include <linux/freezer.h>
 
 #include "zram_wb.h"
 
+static struct task_struct *wb_thread;
+static DECLARE_WAIT_QUEUE_HEAD(wb_wq);
+static struct zram_wb_request_list wb_req_list;
+
 unsigned long alloc_block_bdev(struct zram *zram)
 {
 	unsigned long blk_idx = 1;
@@ -33,3 +40,110 @@ void free_block_bdev(struct zram *zram, unsigned long blk_idx)
 	atomic64_dec(&zram->stats.bd_count);
 }
 
+static void complete_wb_request(struct zram_wb_request *req)
+{
+	struct zram *zram = req->zram;
+	unsigned long blk_idx = req->blk_idx;
+
+	free_block_bdev(zram, blk_idx);
+	free_wb_request(req);
+}
+
+void enqueue_wb_request(struct zram_wb_request_list *req_list,
+			struct zram_wb_request *req)
+{
+	spin_lock_bh(&req_list->lock);
+	list_add_tail(&req->node, &req_list->head);
+	req_list->count++;
+	spin_unlock_bh(&req_list->lock);
+}
+
+static struct zram_wb_request *dequeue_wb_request(
+	struct zram_wb_request_list *req_list)
+{
+	struct zram_wb_request *req = NULL;
+
+	spin_lock_bh(&req_list->lock);
+	if (!list_empty(&req_list->head)) {
+		req = list_first_entry(&req_list->head,
+				       struct zram_wb_request,
+				       node);
+		list_del(&req->node);
+		req_list->count--;
+	}
+	spin_unlock_bh(&req_list->lock);
+
+	return req;
+}
+
+static void destroy_wb_request_list(struct zram_wb_request_list *req_list)
+{
+	struct zram_wb_request *req;
+
+	while (!list_empty(&req_list->head)) {
+		req = dequeue_wb_request(req_list);
+		free_block_bdev(req->zram, req->blk_idx);
+		free_wb_request(req);
+	}
+}
+
+static bool wb_ready_to_run(void)
+{
+	int count;
+
+	spin_lock_bh(&wb_req_list.lock);
+	count = wb_req_list.count;
+	spin_unlock_bh(&wb_req_list.lock);
+
+	return count > 0;
+}
+
+static int wb_thread_func(void *data)
+{
+	set_freezable();
+
+	while (!kthread_should_stop()) {
+		wait_event_freezable(wb_wq, wb_ready_to_run());
+
+		while (1) {
+			struct zram_wb_request *req;
+
+			req = dequeue_wb_request(&wb_req_list);
+			if (!req)
+				break;
+			complete_wb_request(req);
+		}
+	}
+	return 0;
+}
+
+void free_wb_request(struct zram_wb_request *req)
+{
+	struct bio *bio = req->bio;
+	struct page *page = bio_first_page_all(bio);
+
+	__free_page(page);
+	bio_put(bio);
+	kfree(req);
+}
+
+int setup_zram_writeback(void)
+{
+	spin_lock_init(&wb_req_list.lock);
+	INIT_LIST_HEAD(&wb_req_list.head);
+	wb_req_list.count = 0;
+
+	wb_thread = kthread_run(wb_thread_func, NULL, "zram_wb_thread");
+	if (IS_ERR(wb_thread)) {
+		pr_err("Unable to create zram_wb_thread\n");
+		return -1;
+	}
+	return 0;
+}
+
+void destroy_zram_writeback(void)
+{
+	kthread_stop(wb_thread);
+	destroy_wb_request_list(&wb_req_list);
+}
+
diff --git a/drivers/block/zram/zram_wb.h b/drivers/block/zram/zram_wb.h
index c2f5984e7aa2..b86de0398346 100644
--- a/drivers/block/zram/zram_wb.h
+++ b/drivers/block/zram/zram_wb.h
@@ -6,12 +6,34 @@
 #include <linux/bio.h>
 #include "zram_drv.h"
 
+struct zram_wb_request {
+	struct zram *zram;
+	unsigned long blk_idx;
+	struct zram_pp_slot *pps;
+	struct zram_pp_ctl *ppctl;
+	struct bio *bio;
+	struct list_head node;
+};
+
+struct zram_wb_request_list {
+	struct list_head head;
+	int count;
+	spinlock_t lock;
+};
+
 #if IS_ENABLED(CONFIG_ZRAM_WRITEBACK)
 unsigned long alloc_block_bdev(struct zram *zram);
 void free_block_bdev(struct zram *zram, unsigned long blk_idx);
+int setup_zram_writeback(void);
+void destroy_zram_writeback(void);
+void free_wb_request(struct zram_wb_request *req);
+void enqueue_wb_request(struct zram_wb_request_list *req_list,
+			struct zram_wb_request *req);
 #else
 inline unsigned long alloc_block_bdev(struct zram *zram) { return 0; }
 inline void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
+inline int setup_zram_writeback(void) { return 0; }
+inline void destroy_zram_writeback(void) {}
 #endif
 
 #endif /* _ZRAM_WRITEBACK_H_ */
-- 
2.50.1.565.gc32cd1483b-goog


