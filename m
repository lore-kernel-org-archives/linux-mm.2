Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0526ACCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B27C8E0014; Tue, 18 Nov 2025 02:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462F68E0010; Tue, 18 Nov 2025 02:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A7D8E0014; Tue, 18 Nov 2025 02:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 186F48E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D201714040E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:18 +0000 (UTC)
X-FDA: 84122904516.26.A1E9251
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id D8FD11C0009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kL8PDjal;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5u1M/RNJpcZCCpiReIhVBJ0yK+614L9bZ4KnDOH5PIM=;
	b=Hu6FAY2UB2z+zajzEWvgtsepzHFT1HLFj6oQB7lg2EfH1V2kidFuwU8VLWtJ1GvS6yEnL1
	kA1qT+k1WrRGiN6ab/PmPRTcNQIbKIUyTF/K1OyL5Mqmo71E+rAPndmNhISrDLX8I/z6fY
	UVJ28jia3U0QxKXLUQU3IFV3IMyqv2s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451016; a=rsa-sha256;
	cv=none;
	b=LBQcUC0h01mg5ECYSTDTJ2sDVi19FS8HGCIatXHz5IHQbdWHvvparA8IjsM52KD2kGVnDH
	efTVCTig6qVUrhw/mSvtvcONoMCNZ2RXO8/5HWqdVevNP/dsPO71r8kKOk4JlhKVQvqk2c
	6zsJJyVeSgZMetDWhCyA+mvblsQLeno=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kL8PDjal;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29516a36affso60955515ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451016; x=1764055816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5u1M/RNJpcZCCpiReIhVBJ0yK+614L9bZ4KnDOH5PIM=;
        b=kL8PDjalyVB0oH3f2/kwQ/X319JSObQZtiBAxYDW+VpIE2KexErmRs84zgKNGMfHxU
         g1iOOlnopbHxn61COQHzWqHtdmFyePDmGha+1W7EHg149OypnvueGSx6U9vN4km9fWOe
         erHO7rAl+DApxKKUTZEoMoVXNLr8tpsZUpVho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451016; x=1764055816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5u1M/RNJpcZCCpiReIhVBJ0yK+614L9bZ4KnDOH5PIM=;
        b=WTFdZjnWuah/T6YGiJa1U/Y1a3/5+NMQhNoB0a9dmgJ5ZwxaojmL9FZBv61NckEZyF
         AxIzvUl0h+ao8uOJe7G5f92bLwyWbTv8Bplk/8OpLngrqjvq2B77ulzmH0XWhrIYQLXo
         GR2cHN86zVBntedqNahjxCyg+w/2ceSbAMHN9z0UzwLesoocZ4/ZgfrkETJHR8rt4APQ
         3QSf+k9YUTGnHnydhAvZeAM6Lppk3WzSWf1+1XUgVldgWUnvDShG9ezsOQjJLJ4VHrH2
         qBrSsnfGd2X3Dt8++pM9YbZ0b/JTvyLKbH4/AFfm375hqme86RdvrKiXhkyjHUclttfT
         foDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiN8PkHN3X8r5knbKGBCgwhNhUWaNz5J9SCvUlXhpJjNvHeAM0dKJzVjvcVKV6xpDl1AmkgddggQ==@kvack.org
X-Gm-Message-State: AOJu0YzqOrTtRoCCCFr5HR7aTamZPUCnnmZtvN/rRUvqufOkF6KWrXvG
	kRhQUdGOdTyQb6OjKyV8p/wTBSAd8EYNe+K2qToeQSuj3USwvCQFWSDMwTZpYnj+XA==
X-Gm-Gg: ASbGncvpFHiiDST8yJ4O1lZLbA7Fntfg1iIfTfCt2cQqTcgL4dKshir/zEN17uqa25E
	q7QG3oQpRmuAiQjdX+d4ygzzojCdF288UZqp4BgogLno3Ohm89xh2xgGSJPUH91vGOet5PYDaQ5
	6760frnbVUq9dvk2YDxbLs7jD5B/r1dC+eX9t4MG8NN6Rck8OCLERizY8d/VCVMenYZETGj1kfH
	ZSRe5VkC5n2a8DjbY4ghrreFI9tWDF7ZGRfNXeK/Qki0yuiCDB/V19qWqA5tH/xqrYW4cGHa2Re
	EfD2cIJkCIqBS2KwMa602mzUvWgSPIaYo9Klvd4ppMr6iRWOXzBIyChp2b/P2SXiEb7wTOVZsMj
	wd/Gx4z5kNQS1xQniyPE1v5zV387FIp1IxIoa2jX0ndmOZ4VCQlbS0Y5StwM9C+TQdbqgFkfBLj
	0GpVN799ZM/S+G9urmkzrFA9kaznCURvibvE6fuA==
X-Google-Smtp-Source: AGHT+IE2nS4O+t0c13YVruIc3FV/xNqE1bbo8AUtB4eocoaK5GqSzVHPBqEVxhfLx/QcNvlT8HcnUw==
X-Received: by 2002:a17:903:94f:b0:294:cc8d:c0c2 with SMTP id d9443c01a7336-2986a6d6d75mr172478765ad.27.1763451015679;
        Mon, 17 Nov 2025 23:30:15 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:15 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@google.com>
Subject: [PATCHv4 1/6] zram: introduce writeback bio batching support
Date: Tue, 18 Nov 2025 16:29:55 +0900
Message-ID: <20251118073000.1928107-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118073000.1928107-1-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ic76bmui8quentwi98fp8ufzb55jdsbd
X-Rspam-User: 
X-Rspamd-Queue-Id: D8FD11C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763451016-918554
X-HE-Meta: U2FsdGVkX1+NN/6Yb8tFXiCt9yc5MtYY6mkVafzoElj66uL9gptx3azC6DRJzlfiw0x+dZG+GKglZMqx65TD/tmvGDr4GlfbEcV6+JzA5xuqYqQi1X5JI27d3VMfi1NpXteRn4oMVd+fjBHrkp+PIsqUScc/QQbjW7XQssNsGNC4UFE7kIq+lEh/PFdnWhUY1Pl+o7dpISKtpwjSvxPM6b7UEO6BVEbFONNtHdxDHI0glt3970kuu8lQqGo6xu6MnHWRKT+Si7zzTrM92EbLRu1mjD51PoOsQ59D3GQ/E/Qbs0cyyJIBE7zsNgBWrSJLxuEbLPvnht8PR2s5oxFGY+Fp7BTyyceP1Yum0XXO5XNUYn8kVTSSepmAJD9bns1CqA0UZShsHgW43BYdEuLj1mtcZVlAoBtrKqA1afgOrbhtdAkRHxWdWWzgOjRVSfBaGzknM4+LOXb/TCqzj13x1+84ag4OSjcvL6JWh+3pzDm86UsvXEeh6ceQ+6qi3WFBKlB+6OEnOPmVe5GW99pK3j+bpg8N72EheeJxzBL7Ycddm6eqrV4Uuy1nvKuAWrX2a3LqQmahwFXtdZL5q/dUr3GrGU2xpPqjGfD7XWCUHihqb9jGX3H1QUxml7c71ZFD2j+x2S1OqMfjy+ziboqMkySqQRRIACnY12g93eAhNGostQ+d14zV0jvObVT7JXdEf/ryKqIN6NVKxKuRRnIPlSAgppT7WSQuxZqd34lariZJVKxj668cBbNJm2qSyFs1E4+DtXqTA5AhPSKDJdpo500YJQ1rDzzCj6a9rpN7cfE6UzhjAShsr9zbL2+B7C1ocGpYZ6T7BuXKj3LGbGyKrwOyiVB3XiSUD9/22Z2IdcLgMyWWuPTCBFYsx6RE/2R9WTEGv24FysV75yRPvXvC0lTL26F23fqKf0laYBBghewA4jJSK9LbWrtXrPwCiUVnYlMFHX0ZtRqtxX9zpFQ
 Es+LD9c7
 2z7Djsa/0u2GVMnITLnR2PdhADg5zVOPAscrAlfwbeOcXTJEEKjciKqHmw6Rnnh4nqC0yVKhBi/WsqeJ4JxG3oMGyfNnkcaJanP+YoG9UKw6o1QTMesy+ahp4tgvri8uAdDC44KYVAtDJ1NlWkEC5sxeTCvYu4uNSJdEyYucezwigcV5PXYy6K2zMTGZCI1GPnkPw6kLNCkGoRZa7S06wi1yDzVIkJ+7vmaGZnp+TeYbc14/OoXsr8YEfApKjuGWQLsRUZFVKNFyErzVOwac2xmeLl8XBBLUXBtJuofhpTmti7Z9bI63OBevOgJuvf0u43wS9lzJg2HT540OhtqlLW9Sqn9RnIQrXyryKXfdNayioGryIwf7YnwIGUB+FVlGw73PafatRDsegyB4ZBlIESr/7mMhVusZ8zW/Dv2b/AyK17/NoG3JqMUG/CA==
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
 drivers/block/zram/zram_drv.c | 348 +++++++++++++++++++++++++++-------
 1 file changed, 282 insertions(+), 66 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a43074657531..ea06f4d7b623 100644
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
@@ -734,20 +752,209 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
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
+{
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
+	u32 index = req->pps->index;
+	int err;
+
+	err = blk_status_to_errno(req->bio.bi_status);
+	if (err) {
+		/*
+		 * Failed wb requests should not be accounted in wb_limit
+		 * (if enabled).
+		 */
+		zram_account_writeback_rollback(zram);
+		free_block_bdev(zram, req->blk_idx);
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
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+		free_block_bdev(zram, req->blk_idx);
+		goto out;
+	}
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
 {
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
+
+		release_pp_slot(zram, req->pps);
+		req->pps = NULL;
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
@@ -757,6 +964,26 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
@@ -775,67 +1002,46 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
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
@@ -948,7 +1154,8 @@ static ssize_t writeback_store(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long lo = 0, hi = nr_pages;
-	struct zram_pp_ctl *ctl = NULL;
+	struct zram_pp_ctl *pp_ctl = NULL;
+	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
 	ssize_t ret = len;
 	int err, mode = 0;
@@ -970,8 +1177,14 @@ static ssize_t writeback_store(struct device *dev,
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
@@ -1000,7 +1213,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1011,7 +1224,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			break;
 		}
 
@@ -1022,7 +1235,7 @@ static ssize_t writeback_store(struct device *dev,
 				goto release_init_lock;
 			}
 
-			scan_slots_for_writeback(zram, mode, lo, hi, ctl);
+			scan_slots_for_writeback(zram, mode, lo, hi, pp_ctl);
 			continue;
 		}
 
@@ -1033,17 +1246,18 @@ static ssize_t writeback_store(struct device *dev,
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
 
@@ -1112,7 +1326,9 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx) {};
+static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+{
+}
 #endif
 
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
-- 
2.52.0.rc1.455.g30608eb744-goog


