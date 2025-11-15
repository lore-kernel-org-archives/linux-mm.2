Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE0D2CE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A848E002C; Fri, 14 Nov 2025 21:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5521F8E0005; Fri, 14 Nov 2025 21:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4689C8E002C; Fri, 14 Nov 2025 21:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3108D8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:35:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3B3359E6E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:11 +0000 (UTC)
X-FDA: 84111274422.18.A4F192F
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7CF5180002
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dgSLkZiB;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763174109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDuiyI7gsQ5VgD6HO9f1c14cghPHCJ3yiw8InVJ9Pb0=;
	b=ba7HkZq9MLKAzzFD2SGfqgWKQpFsgJbqhMzqWcIqodRPIMEXH7XHcs2Lqh4QfM8o5NKBBA
	yOKsqt02joBhcy7eVfQJ9J7B/xqOlk2VNajN42VSS0TBe/kRtXNsz6YCa1DTeQIiRGETj3
	irK7erPRNoHirhR8Ak1fjVgYxdoSm0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763174109; a=rsa-sha256;
	cv=none;
	b=iGm8iMqbPOIe3ofc9C2csQAOWXNExnWNKoM9v+HGQ4vwdi1R8tBpggCAKd4MIDB9nXXJFe
	mTuEmuwaXEO/3AXvmHLecrfrLLmr6YQplMOSJ8GjzSN9phlpEtylvMd9H/W6dRcuQ4MjHL
	8SyOWvT10gT4fpng8lQJnTjWCVNCZUE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dgSLkZiB;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2984dfae043so23527865ad.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763174108; x=1763778908; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dDuiyI7gsQ5VgD6HO9f1c14cghPHCJ3yiw8InVJ9Pb0=;
        b=dgSLkZiByIeWPu1BXr2qXhCj6nGVNssBsvi4QMBFJbp0/tDzxF734zvpBZTAo+kpYt
         0SyrogZBUYw3z4/ziAUEzgkcTgh7V2wQQZWozSm5OxnvoJ551ud3phD9ADCTHcRa3Xzx
         qZaZbivT2T+SlbKTmcgzl4zjqPQ9XsItVwlwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763174108; x=1763778908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dDuiyI7gsQ5VgD6HO9f1c14cghPHCJ3yiw8InVJ9Pb0=;
        b=ChK9dwXhhoqdWUG5n/zSvB5BDsyCukN/kSw4eeiXeKwd79/RTl/DL29XWoEntFZrpM
         37J4jowNaZxiVfU0bmJSvA/Q/SOItGKwdlp9HMHgmVd1/4282wNms8Ntd8Do0iT3lX/j
         YzULMrbc7Ikw5/iwtQ3M8Xk1APwYdnNPLjjDme0ZyPXzMZDiZZniexBc6a4WUVmqYZGe
         BU+pikIKeqsrF9Z7r2iyILHoL2sZv40+TICHAPc+E8ZW4YHiffhH2FAHYJLUACDdjNFw
         wK+IVkd/UYPWDt+RB09Oy+zu4Vvj+vKEJdEw9na9Vt5WV9JFg1CJAOchBjt1X9a7/HJT
         Q2OA==
X-Forwarded-Encrypted: i=1; AJvYcCW5s39L4jtf+0fC2swsdPhWSDCJixw/zLlpJFy7plUv4ArKOgPJRAhQXVG5CmHzw1D+TSBs8lsrEQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1VYb/Oj+R7z31t6YjbAc1U8jedOmN8ihOzt27TREi1zhxvfov
	08vdXt51XzKnDMDroaiCgKLXFeQp/d7T74yIaPEtAijLkWn0frBkRSGzJbOMxgZPOA==
X-Gm-Gg: ASbGnctrWtVe50M3TkM4s+aUbh1d4NwnqWMcawiyM/IXA/90tTtp85DPvlOzxRHZgWj
	YY5xZb4FSrlrp7sslW+SuWiMgZd/oAJn3qhgSs7QMFqlNvGYfhRd7Likr1UCAsqE6s2H/ZLj9aL
	QagdiUekP8F2KwssIUWCZzm4H1qobz/rijGg20jaDFGxS+ojghQov/pGxY9JPPVZFNIfFV1hNbM
	DpZKoGWSLnfEYtPatUwkM8rFzTpQJOWHI7FqwyEuxzO0WbbHzNlqi3+jq/Bc0lALWNStniXZofN
	axDrOQPlO6Xtxb1ttZEYsUbzTZFag0tji1mJiaOCvDWwAi3SZKayfyR1AqHFHo+7j0c/6l82big
	EzjygJJPg3unRk3FCVTXb06PYoMP5/XIv8lsIf8f/LJ++E4mbCo7FyLjed6baJbDy3ERQraPRrH
	9Iy8rupubPMm+iLt+rNUJukCj7phuOuO5EbCKWqg==
X-Google-Smtp-Source: AGHT+IEvYlpI8cv2D8grBZnnslzeQuRNQnZnYP9zaGmE6JVvK4J4n6+L8YNyH9j4MxMguvyJ+sXzpA==
X-Received: by 2002:a17:903:2c04:b0:297:ec1a:9db8 with SMTP id d9443c01a7336-2986a7509demr63813165ad.49.1763174108543;
        Fri, 14 Nov 2025 18:35:08 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:b069:973b:b865:16a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1088sm68641555ad.57.2025.11.14.18.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 18:35:08 -0800 (PST)
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
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@google.com>
Subject: [PATCHv3 1/4] zram: introduce writeback bio batching support
Date: Sat, 15 Nov 2025 11:34:44 +0900
Message-ID: <20251115023447.495417-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115023447.495417-1-senozhatsky@chromium.org>
References: <20251115023447.495417-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A7CF5180002
X-Stat-Signature: ham61i3sy5fw6o79k3rto8iokr46uc11
X-Rspam-User: 
X-HE-Tag: 1763174109-218663
X-HE-Meta: U2FsdGVkX1+Qvb8p0TU0RSBCzgGXtg6kimhMv0T10oQsKmZMCBSZbsrrRsHsmj8/8I3K7FphQAEVXA/Fvs0LFOGQALJ0J8Dn0K9nf5DTbEqgM7FpoQOKnOUuB06MdDVrWxbpcWt8mpkMLeEfsf/nMUMeOorEsR61nSmIvujYVbr48PHyE7kJPd6DbROP3YGufEpItz4A2Ap269BWQFxbrVtdGzTF6iShsXff8H72/pEhrpJxtzD1eLYEBDBHY7IT4ABTFgsY76z+9TBcFDfliY3m925oZIFHt+ZQr8i3weLBHV2FwVkKrhK6XnTVmFVZH1O+ts/GanI8loiiGKkqveq7mrp4DLNr6MUAO8SJ4kten6Wi58+OAsdlmGAGHiymBlBWT/ry7YrYa5lliNl9yd57vVLZZxyDVqvbW36CWcJh/RLI8vwrtf9einf25+MxTxF+a5eP+TXaqo6/tNajvjwnv/TUD7LzMcdWLW5kIHdCA7y4b9UaKl39orPOED5VA+ALM1YlliNa8eOjOQag5lvBmotQzT9kQXGlHcP8bn66ChYVkVpco5jfyng/rTk9sytjSnasPtlSUOeKBXMEinvgeXfpTTdv+5NJOZJNN5lXFljhvPVCv01/CTJa7BWqpA28xhxXZ8SW0s3RqlcsgcJWh/s59G3fuUF5t/lNGOZT1sLZQwk1AsARwK3YB4j9PFPdcyJJsyWGXl7gjsix0LWkuMjz3AgGCqyJAiaNQ/5OtVr+EQuxAqNlOYds1DjKmhrmwbESWirJu4kUOzDTgKCvnftBCCaK3/t3nyS+CdQBvXxt7J2ZXszwT89XDO4o1dsFPTbajXEoCM8a/V2mpJ62aRPVQj4O00WyBtNoTvymSAhjwyN7nCNJsWzPY1HQ3nOSdxO/Dly0Z3dJu9t52Hz+vsC6pb42fcfYq792Uuimnz5RlwB/JwXx3GXqv5DCEekfD8OpJezBiDldgeK
 92a3nmZm
 aPx62WnlcvBV2Cjx44KVbEFihlLhhiuzHpurHgTCUkVvB4vj/p2wAW8a2m6W11U6u6uMcCg6PzMU3NKX3Kuyob0Lpd9wB/CpJjAmS04RrepjIR80AriW/Nussl0klvyAwKGa3kO2lpH0+EJhDg1LtFBNXp1YtT2TGdlP53wZCKS2qTFVXU0koXVSFHfGEoIZjc2HSobTU3LHf/mTIXtsg5wdaxxxAnOd7BsF0oLoLNq2xTHKXOKcAtVhnHBNeBE7OFoZ7nT1bxarws/hmkFB0qVswV9ZPQtX/mW7U5UQw2/MxCANmcAtuQCPkde1kuopQK+7PQhgEqDi5eHJH5kHYAf59TxgghdQ/xQMjCYhTHc2BrT2/QR5Kyjz3Mo+Uzu6t3euypUpiGyY7p+ApEifM1uS0Lw/vlN0/GAjW/MV04NIPps26pt3iCEMtvA==
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
in-flight bio requests) is set to 32 for all devices.  A follow
up patch adds a writeback_batch_size device attribute, so the
batch size becomes run-time configurable.

Please refer to [1] and [2] for benchmarks.

[1] https://lore.kernel.org/linux-block/tencent_B2DC37E3A2AED0E7F179365FCB5D82455B08@qq.com
[2] https://lore.kernel.org/linux-block/tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com

[senozhatsky: significantly reworked the initial patch so that the
approach and implementation resemble current zram post-processing
code]

Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Co-developed-by: Richard Chang <richardycc@google.com>
Suggested-by: Minchan Kim <minchan@google.com>
---
 drivers/block/zram/zram_drv.c | 343 +++++++++++++++++++++++++++-------
 1 file changed, 277 insertions(+), 66 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a43074657531..84e72c3bb280 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -500,6 +500,24 @@ static ssize_t idle_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+struct zram_wb_ctl {
+	struct list_head idle_reqs;
+	struct list_head inflight_reqs;
+
+	atomic_t num_inflight;
+	struct completion done;
+};
+
+struct zram_wb_req {
+	unsigned long blk_idx;
+	struct page *page;
+	struct zram_pp_slot *pps;
+	struct bio_vec bio_vec;
+	struct bio bio;
+
+	struct list_head entry;
+};
+
 static ssize_t writeback_limit_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -734,20 +752,207 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	submit_bio(bio);
 }
 
-static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
+#define ZRAM_WB_REQ_CNT 32
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
+		req = kzalloc(sizeof(*req), GFP_KERNEL | __GFP_NOWARN);
+		if (!req)
+			break;
+
+		req->page = alloc_page(GFP_KERNEL | __GFP_NOWARN);
+		if (!req->page) {
+			kfree(req);
+			break;
+		}
+
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
+static void zram_account_writeback_rollback(struct zram *zram)
 {
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable)
+		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+}
+
+static void zram_account_writeback_submit(struct zram *zram)
+{
+	spin_lock(&zram->wb_limit_lock);
+	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
+		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
+	spin_unlock(&zram->wb_limit_lock);
+}
+
+static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
+{
+	u32 index;
+	int err;
+
+	index = req->pps->index;
+	release_pp_slot(zram, req->pps);
+	req->pps = NULL;
+
+	err = blk_status_to_errno(req->bio.bi_status);
+	if (err) {
+		/*
+		 * Failed wb requests should not be accounted in wb_limit
+		 * (if enabled).
+		 */
+		zram_account_writeback_rollback(zram);
+		return err;
+	}
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
+static void zram_submit_wb_request(struct zram *zram,
+				   struct zram_wb_ctl *wb_ctl,
+				   struct zram_wb_req *req)
+{
+	/*
+	 * wb_limit (if enabled) should be adjusted before submission,
+	 * so that we don't over-submit.
+	 */
+	zram_account_writeback_submit(zram);
+	atomic_inc(&wb_ctl->num_inflight);
+	list_add_tail(&req->entry, &wb_ctl->inflight_reqs);
+	submit_bio(&req->bio);
+}
+
+static struct zram_wb_req *select_idle_req(struct zram_wb_ctl *wb_ctl)
+{
+	struct zram_wb_req *req;
+
+	req = list_first_entry_or_null(&wb_ctl->idle_reqs,
+				       struct zram_wb_req, entry);
+	if (req)
+		list_del(&req->entry);
+	return req;
+}
+
+static int zram_wb_wait_for_completion(struct zram *zram,
+				       struct zram_wb_ctl *wb_ctl)
+{
+	int ret = 0;
+
+	if (atomic_read(&wb_ctl->num_inflight))
+		wait_for_completion_io(&wb_ctl->done);
+
+	reinit_completion(&wb_ctl->done);
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
 	unsigned long blk_idx = 0;
-	struct page *page = NULL;
 	struct zram_pp_slot *pps;
-	struct bio_vec bio_vec;
-	struct bio bio;
+	struct blk_plug io_plug;
 	int ret = 0, err;
-	u32 index;
-
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+	u32 index = 0;
 
+	blk_start_plug(&io_plug);
 	while ((pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
@@ -757,6 +962,26 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		}
 		spin_unlock(&zram->wb_limit_lock);
 
+		while (!req) {
+			req = select_idle_req(wb_ctl);
+			if (req)
+				break;
+
+			blk_finish_plug(&io_plug);
+			err = zram_wb_wait_for_completion(zram, wb_ctl);
+			blk_start_plug(&io_plug);
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
 			if (!blk_idx) {
@@ -765,7 +990,6 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 			}
 		}
 
-		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
 		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
@@ -775,67 +999,46 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram_read_from_zspool(zram, page, index))
+		if (zram_read_from_zspool(zram, req->page, index))
 			goto next;
 		zram_slot_unlock(zram, index);
 
-		bio_init(&bio, zram->bdev, &bio_vec, 1,
-			 REQ_OP_WRITE | REQ_SYNC);
-		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
-		__bio_add_page(&bio, page, PAGE_SIZE, 0);
-
 		/*
-		 * XXX: A single page IO would be inefficient for write
-		 * but it would be not bad as starter.
+		 * From now on pp-slot is owned by the req, remove it from
+		 * its pp bucket.
 		 */
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
+		list_del_init(&pps->entry);
 
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
+		req->blk_idx = blk_idx;
+		req->pps = pps;
+		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1, REQ_OP_WRITE);
+		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
+		req->bio.bi_end_io = zram_writeback_endio;
+		req->bio.bi_private = wb_ctl;
+		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
-		zram_free_page(zram, index);
-		zram_set_flag(zram, index, ZRAM_WB);
-		zram_set_handle(zram, index, blk_idx);
+		zram_submit_wb_request(zram, wb_ctl, req);
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
+	blk_finish_plug(&io_plug);
+	err = zram_wb_wait_for_completion(zram, wb_ctl);
+	if (err)
+		ret = err;
 
 	return ret;
 }
@@ -948,7 +1151,8 @@ static ssize_t writeback_store(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long lo = 0, hi = nr_pages;
-	struct zram_pp_ctl *ctl = NULL;
+	struct zram_pp_ctl *pp_ctl = NULL;
+	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
@@ -970,8 +1174,14 @@ static ssize_t writeback_store(struct device *dev,
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
@@ -1000,7 +1210,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1011,7 +1221,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1022,7 +1232,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 
@@ -1033,17 +1243,18 @@ static ssize_t writeback_store(struct device *dev,
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
2.52.0.rc1.455.g30608eb744-goog


