Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA8ACD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 06:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34C58E0007; Thu, 13 Nov 2025 01:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5348E0003; Thu, 13 Nov 2025 01:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADCB8E0007; Thu, 13 Nov 2025 01:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94F728E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:00:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 508CE12E379
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:17 +0000 (UTC)
X-FDA: 84104533674.09.306FAD8
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A047140007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="LbsdJ/ix";
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763013615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gf9JnjFax2bSnrfFfDZ9xY36eEdwvySsRzLc9kWlr7Y=;
	b=Q1wzH08VWF7gv2NNmSTkjUiWK+2jGX5sREHUfGbuZaoN2X0kR3lWxCfNUpHNJahwqOTQ/s
	fOA2r8ej9JpQQWP3OHiiF8m3iQA02ZfIk73YcUjvz4HaK/uV01F9tR0Bry+1DnkPG+aP95
	g8zhzIcU8lCyXGdPTGULVdxotr+iNsQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763013615; a=rsa-sha256;
	cv=none;
	b=wCTlRe/4fJR3vwjDqRKAwdl3+8jOdJZqvSemPHaa3bXOfViLKvq37bRfkUh6bZUoEyoy32
	BWmNE242EAqti3hZg2H/TpPOnjK7ao9RUz3s02jd/sfrWznWp1HSu7Ku27DyBSnrHdPGuP
	fnmEO00/Hib4zdadCQPtfyjrFptI8ZU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="LbsdJ/ix";
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7a9c64dfa6eso290023b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763013614; x=1763618414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gf9JnjFax2bSnrfFfDZ9xY36eEdwvySsRzLc9kWlr7Y=;
        b=LbsdJ/ixu0W/h5fVN0LBGf+ZjGYv3u7LeVhTpXFYhayixrgqe65c1+gLAvSfgDKa9y
         ml7GQXAI1oCMdc/df1bxaoFGoxNupyKxALqXV+ixzTlhGrcZ3dFHkh86xC8nsED1sWLY
         wR/yFtnpDXORA4qaGPqlNExaIIYW6hBf0WIuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763013614; x=1763618414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gf9JnjFax2bSnrfFfDZ9xY36eEdwvySsRzLc9kWlr7Y=;
        b=Q6aVzVAyRXkGa+pjXDI0Zjc0f0JgF+S3b/SorqfmLdqXRUxsf4gsRCs4f9khlMO96c
         cfzwysMEkuyvvRVGzUE/OEiNf6YMWyd9ouauLp0IlDFmXd52HhO0UvdBCsGPYjogLgRa
         wfhLEktiWoSTdFuLlM59fyWqN18HElZ9ka6dRMfsj3rRb0BVIy3edeJ60tQKdN8Lc8Yr
         FCXgXY1LdGJ22kdddFekXzqH4JVISuY8fYLFXUBrw5D0ortQAB2N91Ybb9iaYKl9Rcbm
         xlL6EoHV6dYpAsZMUx/ET9+A7DGJcLaUVYJRRZhRfi9PgzvLGGMjg3wvtH1S7foonhtp
         3bPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIBac62zw1B8YXFLIS8qoewl6aKNwtRg0MUPjn8JS8cbKTCavNbhypIRs7G2vhZWefpFjikO6UEA==@kvack.org
X-Gm-Message-State: AOJu0Yz3TPbo2UJ40Zt+rokqBELlGqU8yaxA79iQQsMm22/KdxHumw2V
	jJEPIWrbecrveZhwRtGev0hxKz5Ybff+t6VzNy16aFGRmRjRfEgqntVUEUffzNWejg==
X-Gm-Gg: ASbGncsCU/x/cu+/L1pJ68Ew4dibEAMKmbqXaaYDntVA2o9VFN/AnrPQ87+FSdUwWYk
	4881SPbvJ4jugXEodIp2sNH1PO0vyJB04dOMbVp0gVQkiXZxgq8dbx131hT9jGUgOxSiVc5v89G
	CrDm86jt44CgF1UHrIJTIwLwiv56NfKndjExiT6uFT97991wHc94lpri59kLBtNQfMeLc1Z4gnc
	Ou2qGTkeN5iZJpi2/xX8ZgFkBYobqb7fVe/wa0V3UUNdFxmipprVO4+G8po6mkoC5rbhYdaMYFs
	S6yBt9Lvwf+4QwizDY/fot21kxg8F5sZwCYcRCxcHbZjGEsH3dhjmgMTaJi1IVAHBOeG9j6lXtr
	vTdaMx5e/gdZGlVY7rHGHQsqbTXrr99G2KHe57o2oGArNmvaCg3pYRodJaXK+8ZNAom6ru1I+9j
	NESS+fjLYzTjpXhkxWNMmBsPg4gOyLzTiqJY1zhQ==
X-Google-Smtp-Source: AGHT+IHp9IXN06D8mebQBN6tkE/wcqbW6lp5Ww+zQ+/vmvl8yV7qM7Tl6bPvXkuBPsDwKSfwvVl0LA==
X-Received: by 2002:a17:903:94e:b0:297:dfae:1524 with SMTP id d9443c01a7336-2984ed45b64mr81617845ad.16.1763013614136;
        Wed, 12 Nov 2025 22:00:14 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2376f6sm11463145ad.21.2025.11.12.22.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 22:00:13 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/2] zram: introduce bio batching support for faster writeback
Date: Thu, 13 Nov 2025 14:59:38 +0900
Message-ID: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j9tskuytfw388faowtpau3tcupwn3456
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A047140007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763013615-799529
X-HE-Meta: U2FsdGVkX19PxOtL0H7clNDS0hCF5MlF1J9lQREqyZEWBnHOkT5dZ68bowelbvpAlKWb0KpeK+CrObyvwmDESLYFxiaI9fM2d5VHLMBur+2zXDrj0jqY8g73A++tnRVd1TV894Rqpn5TxiJXsYHDASTQhlx4FY8tH53lBmiJuVvGRa+J2P7PcCYQXr1Xlc1Z9bgeFaLIyPqo7tW4iwZfGzG3EIra5jsjjmHk8p4bLZseQxGAfReXDPHeXz+w7vT/+UIQemNxby0jnR/Im22beV83j5d/ZBHlcwqeiEHYyZSxvkh8aRDlrbZU3KPVW2H6iGAUvoY7PLaO340ojhqN75U2+IAvioYeZarYk6oJipTR/VYsQ6LvyJtXd6r6b5nt8Kak/i2klXkYT1eImjadBpZ7TvZEbcDpOsX1J84ZROjnX7SshDJjnhU4jy08EMZF7TXj8xiOFzeAs08NFuY3g0nmqHEZRDcpHGQScjACHKzoceeuQBsQiMeaIed0H2je59Q0WUTbVGiPcMEsc5DxRzP0nU0h+pGu5f527Foz92VTV7ZA/KaI/d//TdHnTzMo9mjvDsZ5ngq4qVu+k6w4SSxN2bV+0I9luCW2/l8G+wlcGG6JlrMDEFZTzBzRhYps7z91c/4yJ2n+39mSMB42tmlg1IHzdNlGk/ubbOMVxOb+FMIvObpneaPThoxK0ghmtZ+9uQCqTQFQx/toumLTZQ5OlipaVwYxvVRGuKeAvRDita7BOfMKwjUctlZUJA305z9wkC8Wsssj4qFTeEsjPayK7+re++QeQUyM9CTPO8bP8B40gGuwm+QLDQ+EDGaykke1U01ij9ihiyBM4cdVAZ25TXrEbZdK41fBIqeZt18eSISynVwjT+5j2Rb3ummsS0VibsMziBBzEQx+zvftLbgHTdkNXVYGdZfHEXwUnWfduS0qTWR2V7j4dayn0F4/zp0IjBnrGjQHnqerQ+J
 nZWvrE8C
 eXPQFYtFnhJ1iA9ccvKf9xalL5/bQr8cy4ODmi2apH+HJ2kOn27H4Qto5oUEMMyIqLQuBpHBBsc+2FcKyPnpcU7KzsH8+EuFd1giMRZbn1BSSTlnx5QhNcRkmHy8Dh8sAJIvJEOs0nuxZwyc+qTjXDt7lPs02bFtC6Uf9zIfUa5jFTHFxnL8ZhEmD3ptvULsrMoi/HUtla31S5qRagBbFAHVbww0lDRXyX9UzZLT4MTwUFQfUxMnKUbr7Xu+s8Wo6Qeed5Jy+Npc51bAS46I8ifAIZO8EZfjLaZpNsbrH+9MJzHZcEwN+zvyoiPjhqTfsZORdDDOa3mbLkF/f5Zos8+ug1elT/T1Pekw4hYtAWEl0jIHBTNg1xYfo1n+zwBqeV4S7/CslDvEm+x7jByPihn3/RsAAIR3GOD8OJ6lfsxY6T14Q2WXmVAjevQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yuwen Chen <ywen.chen@foxmail.com>

Currently, zram writeback supports only a single bio writeback
operation, waiting for bio completion before post-processing
next pp-slot.  This works, in general, but has certain throughput
limitations.  Implement batched (multiple) bio writeback support
to take advantage of parallel requests processing and better
requests scheduling.

For the time being the writeback batch size (maximum number of
in-flight bio requests) is set to 1, so the behaviors is the
same as the previous single-bio writeback.  This is addressed
in a follow up patch, which adds a writeback_batch_size device
attribute.

Please refer to [1] and [2] for benchmarks.

[1] https://lore.kernel.org/linux-block/tencent_B2DC37E3A2AED0E7F179365FCB5D82455B08@qq.com
[2] https://lore.kernel.org/linux-block/tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com

[senozhatsky: significantly reworked the initial patch so that the
approach and implementation resemble current zram post-processing
code]

Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Co-developed-by: Richard Chang <richardycc@google.com>
Co-developed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 323 +++++++++++++++++++++++++++-------
 1 file changed, 255 insertions(+), 68 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a43074657531..92af848d81f5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -734,20 +734,206 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	submit_bio(bio);
 }
 
-static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-{
-	unsigned long blk_idx = 0;
-	struct page *page = NULL;
+struct zram_wb_ctl {
+	struct list_head idle_reqs;
+	struct list_head inflight_reqs;
+
+	atomic_t num_inflight;
+	struct completion done;
+	struct blk_plug plug;
+};
+
+struct zram_wb_req {
+	unsigned long blk_idx;
+	struct page *page;
 	struct zram_pp_slot *pps;
 	struct bio_vec bio_vec;
 	struct bio bio;
-	int ret = 0, err;
+
+	struct list_head entry;
+};
+
+static void release_wb_req(struct zram_wb_req *req)
+{
+	__free_page(req->page);
+	kfree(req);
+}
+
+static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
+{
+	/* We should never have inflight requests at this point */
+	WARN_ON(!list_empty(&wb_ctl->inflight_reqs));
+
+	while (!list_empty(&wb_ctl->idle_reqs)) {
+		struct zram_wb_req *req;
+
+		req = list_first_entry(&wb_ctl->idle_reqs,
+				       struct zram_wb_req, entry);
+		list_del(&req->entry);
+		release_wb_req(req);
+	}
+
+	kfree(wb_ctl);
+}
+
+/* XXX: should be a per-device sysfs attr */
+#define ZRAM_WB_REQ_CNT 1
+
+static struct zram_wb_ctl *init_wb_ctl(void)
+{
+	struct zram_wb_ctl *wb_ctl;
+	int i;
+
+	wb_ctl = kmalloc(sizeof(*wb_ctl), GFP_KERNEL);
+	if (!wb_ctl)
+		return NULL;
+
+	INIT_LIST_HEAD(&wb_ctl->idle_reqs);
+	INIT_LIST_HEAD(&wb_ctl->inflight_reqs);
+	atomic_set(&wb_ctl->num_inflight, 0);
+	init_completion(&wb_ctl->done);
+
+	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+		struct zram_wb_req *req;
+
+		/*
+		 * This is fatal condition only if we couldn't allocate
+		 * any requests at all.  Otherwise we just work with the
+		 * requests that we have successfully allocated, so that
+		 * writeback can still proceed, even if there is only one
+		 * request on the idle list.
+		 */
+		req = kzalloc(sizeof(*req), GFP_NOIO | __GFP_NOWARN);
+		if (!req)
+			break;
+
+		req->page = alloc_page(GFP_NOIO | __GFP_NOWARN);
+		if (!req->page) {
+			kfree(req);
+			break;
+		}
+
+		INIT_LIST_HEAD(&req->entry);
+		list_add(&req->entry, &wb_ctl->idle_reqs);
+	}
+
+	/* We couldn't allocate any requests, so writeabck is not possible */
+	if (list_empty(&wb_ctl->idle_reqs))
+		goto release_wb_ctl;
+
+	return wb_ctl;
+
+release_wb_ctl:
+	release_wb_ctl(wb_ctl);
+	return NULL;
+}
+
+static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
+{
 	u32 index;
+	int err;
 
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+	index = req->pps->index;
+	release_pp_slot(zram, req->pps);
+	req->pps = NULL;
+
+	err = blk_status_to_errno(req->bio.bi_status);
+	if (err)
+		return err;
+
+	atomic64_inc(&zram->stats.bd_writes);
+	zram_slot_lock(zram, index);
+	/*
+	 * We release slot lock during writeback so slot can change under us:
+	 * slot_free() or slot_free() and zram_write_page(). In both cases
+	 * slot loses ZRAM_PP_SLOT flag. No concurrent post-processing can
+	 * set ZRAM_PP_SLOT on such slots until current post-processing
+	 * finishes.
+	 */
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
+		goto out;
+
+	zram_free_page(zram, index);
+	zram_set_flag(zram, index, ZRAM_WB);
+	zram_set_handle(zram, index, req->blk_idx);
+	atomic64_inc(&zram->stats.pages_stored);
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
+		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+
+out:
+	zram_slot_unlock(zram, index);
+	return 0;
+}
+
+static void zram_writeback_endio(struct bio *bio)
+{
+	struct zram_wb_ctl *wb_ctl = bio->bi_private;
+
+	if (atomic_dec_return(&wb_ctl->num_inflight) == 0)
+		complete(&wb_ctl->done);
+}
+
+static void zram_submit_wb_request(struct zram_wb_ctl *wb_ctl,
+				   struct zram_wb_req *req)
+{
+	atomic_inc(&wb_ctl->num_inflight);
+	list_add_tail(&req->entry, &wb_ctl->inflight_reqs);
+	submit_bio(&req->bio);
+}
+
+static struct zram_wb_req *select_idle_req(struct zram_wb_ctl *wb_ctl)
+{
+	struct zram_wb_req *req = NULL;
+
+	if (!list_empty(&wb_ctl->idle_reqs)) {
+		req = list_first_entry(&wb_ctl->idle_reqs,
+				       struct zram_wb_req, entry);
+		list_del(&req->entry);
+	}
+
+	return req;
+}
+
+static int zram_wb_wait_for_completion(struct zram *zram,
+				       struct zram_wb_ctl *wb_ctl)
+{
+	int ret = 0;
+
+	if (atomic_read(&wb_ctl->num_inflight) == 0)
+		return 0;
+
+	wait_for_completion_io(&wb_ctl->done);
+	reinit_completion(&wb_ctl->done);
+
+	while (!list_empty(&wb_ctl->inflight_reqs)) {
+		struct zram_wb_req *req;
+		int err;
+
+		req = list_first_entry(&wb_ctl->inflight_reqs,
+				       struct zram_wb_req, entry);
+		list_move(&req->entry, &wb_ctl->idle_reqs);
+
+		err = zram_writeback_complete(zram, req);
+		if (err)
+			ret = err;
+	}
+
+	return ret;
+}
+
+static int zram_writeback_slots(struct zram *zram,
+				struct zram_pp_ctl *ctl,
+				struct zram_wb_ctl *wb_ctl)
+{
+	struct zram_wb_req *req = NULL;
+	unsigned long blk_idx = 0;
+	struct zram_pp_slot *pps;
+	int ret = 0, err;
+	u32 index = 0;
 
+	blk_start_plug(&wb_ctl->plug);
 	while ((pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
@@ -757,15 +943,34 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		}
 		spin_unlock(&zram->wb_limit_lock);
 
+		while (!req) {
+			req = select_idle_req(wb_ctl);
+			if (req)
+				break;
+
+			blk_finish_plug(&wb_ctl->plug);
+			err = zram_wb_wait_for_completion(zram, wb_ctl);
+			blk_start_plug(&wb_ctl->plug);
+			/*
+			 * BIO errors are not fatal, we continue and simply
+			 * attempt to writeback the remaining objects (pages).
+			 * At the same time we need to signal user-space that
+			 * some writes (at least one, but also could be all of
+			 * them) were not successful and we do so by returning
+			 * the most recent BIO error.
+			 */
+			if (err)
+				ret = err;
+		}
+
 		if (!blk_idx) {
 			blk_idx = alloc_block_bdev(zram);
-			if (!blk_idx) {
+			if (blk_idx) {
 				ret = -ENOSPC;
 				break;
 			}
 		}
 
-		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
 		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
@@ -775,67 +980,41 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram_read_from_zspool(zram, page, index))
+		if (zram_read_from_zspool(zram, req->page, index))
 			goto next;
 		zram_slot_unlock(zram, index);
 
-		bio_init(&bio, zram->bdev, &bio_vec, 1,
+		req->blk_idx = blk_idx;
+		req->pps = pps;
+		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1,
 			 REQ_OP_WRITE | REQ_SYNC);
-		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
-		__bio_add_page(&bio, page, PAGE_SIZE, 0);
+		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
+		req->bio.bi_end_io = zram_writeback_endio;
+		req->bio.bi_private = wb_ctl;
+		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
-		/*
-		 * XXX: A single page IO would be inefficient for write
-		 * but it would be not bad as starter.
-		 */
-		err = submit_bio_wait(&bio);
-		if (err) {
-			release_pp_slot(zram, pps);
-			/*
-			 * BIO errors are not fatal, we continue and simply
-			 * attempt to writeback the remaining objects (pages).
-			 * At the same time we need to signal user-space that
-			 * some writes (at least one, but also could be all of
-			 * them) were not successful and we do so by returning
-			 * the most recent BIO error.
-			 */
-			ret = err;
-			continue;
-		}
-
-		atomic64_inc(&zram->stats.bd_writes);
-		zram_slot_lock(zram, index);
-		/*
-		 * Same as above, we release slot lock during writeback so
-		 * slot can change under us: slot_free() or slot_free() and
-		 * reallocation (zram_write_page()). In both cases slot loses
-		 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
-		 * ZRAM_PP_SLOT on such slots until current post-processing
-		 * finishes.
-		 */
-		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
-			goto next;
-
-		zram_free_page(zram, index);
-		zram_set_flag(zram, index, ZRAM_WB);
-		zram_set_handle(zram, index, blk_idx);
+		zram_submit_wb_request(wb_ctl, req);
 		blk_idx = 0;
-		atomic64_inc(&zram->stats.pages_stored);
-		spin_lock(&zram->wb_limit_lock);
-		if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
-			zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-		spin_unlock(&zram->wb_limit_lock);
+		req = NULL;
+		continue;
+
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
-
 		cond_resched();
 	}
 
-	if (blk_idx)
-		free_block_bdev(zram, blk_idx);
-	if (page)
-		__free_page(page);
+	/*
+	 * Selected idle req, but never submitted it due to some error or
+	 * wb limit.
+	 */
+	if (req)
+		release_wb_req(req);
+
+	blk_finish_plug(&wb_ctl->plug);
+	err = zram_wb_wait_for_completion(zram, wb_ctl);
+	if (err)
+		ret = err;
 
 	return ret;
 }
@@ -948,7 +1127,8 @@ static ssize_t writeback_store(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long lo = 0, hi = nr_pages;
-	struct zram_pp_ctl *ctl = NULL;
+	struct zram_pp_ctl *pp_ctl = NULL;
+	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
@@ -970,8 +1150,14 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	ctl = init_pp_ctl();
-	if (!ctl) {
+	pp_ctl = init_pp_ctl();
+	if (!pp_ctl) {
+		ret = -ENOMEM;
+		goto release_init_lock;
+	}
+
+	wb_ctl = init_wb_ctl();
+	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
 	}
@@ -1000,7 +1186,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1011,7 +1197,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1022,7 +1208,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 
@@ -1033,17 +1219,18 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 	}
 
-	err = zram_writeback_slots(zram, ctl);
+	err = zram_writeback_slots(zram, pp_ctl, wb_ctl);
 	if (err)
 		ret = err;
 
 release_init_lock:
-	release_pp_ctl(zram, ctl);
+	release_pp_ctl(zram, pp_ctl);
+	release_wb_ctl(wb_ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 
-- 
2.51.2.1041.gc1ab5b90ca-goog


