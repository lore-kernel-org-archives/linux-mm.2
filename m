Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92590C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906A96B0095; Mon,  7 Sep 2026 23:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B78A6B0096; Mon,  7 Sep 2026 23:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7586B0099; Mon,  7 Sep 2026 23:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6656B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:56:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8319A4490
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:56:02 +0000 (UTC)
X-FDA: 85189231764.29.95CF9EF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1AD8240004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:56:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xnmbl50I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788839761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sz3IhUKKAL3B7/uUvafH5XnIQ+JFZCBkf/MrLLBgC8M=;
	b=xW0S0MG0Hhcx7lwwpVORWLq6p1uuzxewdtO7w9DjM2Cp+JDWUOFrbxmiNE+Fl0YzJcMtqL
	vhn0zBslKq7i8/fEzPwft61C9Mw9hZk9nQUvwI/fhHw1ElqulfNl14MeC9d7C6nUvJeMd6
	zlHvCdfFnSA4ixtHU/WCo1zvz4L8mnA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xnmbl50I;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788839761;
	b=UURCk2XOcctiYQlqrdb1bWlX+jJC983stdsr2CdtZqEoPG3VCLyVeIdQxFAjtogwR0UQoO
	ex2nfGaewaLrDehH18I5ApcUoJpERBbwXvhvdB2B/hEjdQiC+o86J45qeI7N3d8lxb6eq1
	H4pVy9APXuV6EQ2D5rcQeFc2lx10Kpk=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d6d28aa26cso24992445ad.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788839760; x=1789444560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sz3IhUKKAL3B7/uUvafH5XnIQ+JFZCBkf/MrLLBgC8M=;
        b=Xnmbl50IF5PnLSHCpVB4Isr+5s0LvulNItvAvmgNM64kijr1A7g1jTWI5Ts75QiBpy
         F6y72oryn8Q5ZNuAHaFC2DFsIlOrLD6JFETCXO8iaoTyzmjUtmB5e/HP9dRpOUFkgJpa
         2SVkDHrmje2PaCy7QvPbQfyBHNF8I0R7hrTNm1bNm+AMNn36rRxHkA7mJC4vLEP+mIls
         AT0TA8mPIyZlUNtmNihdzRDCrGQhxwCQY8ebbBrfKVFN0f3QxQn4mhPc6HQUEMj6b/79
         t6n04uku6fwYBh//pWZWkW13fMCCikJHCy20PlasTxchvhnil1651HhoDTilBjMY27My
         6qEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788839760; x=1789444560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sz3IhUKKAL3B7/uUvafH5XnIQ+JFZCBkf/MrLLBgC8M=;
        b=L7OKIjx0NIZzmx+ReR6hVk//dWco/4+uzFQvdYsqZ9YZrPuoXKFkqvKYNvpKv36Yk3
         uKBhpVWbDNXPGb6CHzVdNnRif6/8eYy6vaC0zUhp8v8UVw4QtO1+yhpvhxu6/j6IWh4h
         j+kK+bfFP8JfzT6kVHuh8UAEOChujAPp4qnmznMU9gk3qfg3qwyH0r0F3AxlEj/mqfIV
         wEG8ST9VqhOpQoBsK6HY0RGGxqNIKxnPdWA1NZdKb1tgLlqiDNec1FnqcKDKO4W7jQO3
         u/ncAz6bV83LqtxF4IV6RvJ7p7vCFkLv7hjrD2oyouPkCGcnIhXGc+vnjyudR3Mrywsd
         OGAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzdbQfIHA+Qb5iR/VXgESr35TWL0/kSxrBmTpHbGK73qQmyD1lCTQehlpIf7cxNeAbiKDHS34o3Ew==@kvack.org
X-Gm-Message-State: AFuF++m95vAkBEbnDBO5PHIC5ILYt6h2y1YAhzaL3LnjWsQCXSO5VAdM
	/qTcgz9pCY44aRzQdt0R2JU/KCxHuNG/CN6BX/w7LEi0MXL078ysOvdZ
X-Gm-Gg: AYBFou29d6/dvNM9g2/9VMCUGikauiccpP6EJJYQFREjmzw94hprAUfnRu7jWJStcEx
	CiRsmFoLNEgeTMwWM773OVPrVFaDBG/QLGxVP3LQDR4sglKD2i29Fwhc9aum8H1KgiMWZTda62B
	PvmZzoxaNFu4E6sjFDtChDkd0xGpGYFkcbkYmFPrCKfcPjiKMmAATvP7cM5XfvVf4dNpsAPqgR8
	lKtjlhEw4U6yXjKzBHllaSzPJgcUZcGx3DjJC7vaJ7SiMRucsxFhFj5BNXJG/c+9AmpM1InuQW+
	r8c/2ngmXHVf5aJTcOc/NKgKF0CtkAj9shbLHOLFPylb39g0PzLfyuugGFk7PNanhn3lb7omFU/
	nlJjyPzQUTUW6lgji6Bh6ySb8US+m+/0DJya0lVKrKV4aR1gqiwvOakoSGmLYDnq2T761yflwPX
	hI5+ap4hAgKzv8BAl1YWVgwcvcWlljdS7TrvfJDEjX5USxALUYaoA/u3BNg/u4KcI5UNIi9681q
	nGHRDJzs0Pt7CuGE8NRZuzQBqNIL0bgjfE=
X-Received: by 2002:a17:903:22c8:b0:2d7:5ebe:a588 with SMTP id d9443c01a7336-2db126d6e31mr380270745ad.13.1788839759881;
        Mon, 07 Sep 2026 20:55:59 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14aeaf74sm51899295ad.81.2026.09.07.20.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 20:55:59 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v5 1/2] f2fs: complete dropbehind write bios in task context
Date: Tue,  8 Sep 2026 11:55:42 +0800
Message-ID: <a3c3c000656d3655512c979d2b0c803ba4ab2f99.1788795700.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788795700.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <cover.1788795700.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sbab951w3mschmpuzgrajxrenwjmxyb7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AD8240004
X-Rspam-User: 
X-HE-Tag: 1788839760-797307
X-HE-Meta: U2FsdGVkX1+m1w6/GNduzX58mdR2p3wA+zMqmEbUYfB3JScHMK3TW0SEMjfCKoOtpVa3MUzxm1YKq9hlwmnlEjkbI9Bc4ncva41HnchKT8a2hDUSZpH18g0qrLmRUVMvpWnhCSIAREk21QX9huGzvnD5JhnPNWxELIWepFej7wDDSOGdIo+Wf+9VLzhKGTPDnFXjStA+GVpNAvcnUi5soagk8sa/idFuERl6zAuTIrnM5Pqeth31kfhZ4F8PfG/ccPRYwbaiZiHQoBZILbSln0jBc6UX2TdvkG3UvChbVYafbtVhVGqoHpOUGNS0hnCNK7yZZUDrVYLHyRVRL9cJCtFpNOsbFy8ioTDrMjXAVBPOr7TUgV9yreI9UmQdp3IzP3fS6UKIowAgbCqCqGnD4SXU4oUg7s4+NN+BJPAMtFHkcjpQWc6LgtMIiRFdhfLCnxv80xLKU/Hydi/7RgagScs1xH9ilTBrYH7aUBU3u+dh/fnrbaTdqtUOi6n2dwEC+UnSDN2tjsJWW2YZXMQgtr/NUjWyzZmv/9NRW/t/JkSAW17Db/boN0UqqqJPYLrK6N3HtweCo2DNsWcMNfc6EVcwUtfKorDL1huyib8rG2ttFnwsW27Dl3OyDclScGrkonX6Cu6bG9Na9yxcmP6B3wSiALancuLphdNqcHAnPscYXUYO/IotW96YprWgYHJCpmglDGhWvrZjSaZAoWYLCfLIKZCFPp4zv40ZTxgWKZzZ7YNUQDyOq+SbnDqEzV5/zE5qpwHVKvEaijKosc6qv12abolxXjHd3DMvco7eDpHIuPs8JJC9HFLggtlDVypf3dRAm3KhBxtlPSuGThQH5BpOCjxo7m8Zi+yGPBwnFREb4KJGGdHfeiKmJ4W2cEpZ2Hi03iY1CBRagnDR1eX/BRB9zxBNGhDbipya1febMd68cbrylfP/TzF6jIvLN7M0s7TvezL/00kKvyFWr0d
 O7W1Fu1W
 HiqM9wP7BLdypQLha6BtXNk2XPbmotAqqo/Wqo/+QwRLVPKXtL/097xcnIS1Chr0NB9ZwqVdQavNFgB+eClv7W2mVBQHLIaVLJ7le4l1bqi6TJSsblCNN51xXcAKXPod19OHY8L14EVcLx95KAEguAUq5e6xJmHGA92PeQIMLfpRHbDC0taxH4b0keE1SOc59MtvPen/8YC7RhEWhiK8h3GvExHxCe19wQCtLUrkQ8gU4ZoIwPu1mP/qpmF1tNy9qCebCKIH7Zjqcy6cEOGS8rffw5caAB4G9oRfJf7/bf5viDJM8XjrU7X7U8HH4c419SpzjaARf+9kq8Ldrmu91x+GblIUFH1L3abpKkpsCQ8uVicT8kn1V+2sjdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Buffered RWF_DONTCACHE writes invalidate dropbehind folios at
writeback completion. Mark these bios BIO_COMPLETE_IN_TASK so the block
layer runs F2FS completion in task context when needed.

Normal folios can safely share a bio that needs task-context
completion: they do not carry the dropbehind flag and are not invalidated
at their own writeback completion. Follow iomap and allow otherwise
mergeable normal and dropbehind folios to share IPU and OPU bios.

If a dropbehind folio joins an existing bio, set
BIO_COMPLETE_IN_TASK after the add succeeds. Classify the original
page-cache folio rather than an encrypted or compressed replacement folio.

Keep the existing large-ATC completion path unchanged.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
An F2FS QEMU A/B ran 80 untraced 1-GiB formal cases: ten
counterbalanced pairs for each OPU/IPU and 4-KiB/64-KiB profile.

The primary write-plus-fdatasync mixed/segregated ratios were:

 Path  I/O       Mixed/segregated  Interpretation
 OPU   4 KiB          1.133       Mixed was 13.3% faster
 OPU   64 KiB         1.021       Mixed was 2.1% faster
 IPU   4 KiB          4.469       Mixed was 4.47x as fast
 IPU   64 KiB         1.063       Mixed was 6.3% faster

A separate 64-MiB IPU/4-KiB trace observed 16,384 segregated DATA bios,
all 4 KiB, versus 117 mixed DATA bios with a maximum of 13.21 MiB. Deferred
bios were 8,192 versus 117.

Changes since v4:

- allow normal and dropbehind folios to share IPU and OPU bios;
- set BIO_COMPLETE_IN_TASK monotonically after a dropbehind folio is
  successfully added to an existing bio;
- add focused segregated/mixed QEMU results.

 fs/f2fs/data.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ebb0275aa8f..fc48a752fe9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -503,6 +503,8 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
 	bio = bio_alloc_bioset(bdev, npages,
 				fio->op | fio->op_flags | f2fs_io_flags(fio),
 				GFP_NOIO, &f2fs_bioset);
+	if (!is_read_io(fio->op) && folio_test_dropbehind(fio->folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 	bio->bi_iter.bi_sector = sector;
 	if (is_read_io(fio->op)) {
 		bio->bi_end_io = f2fs_read_end_io;
@@ -865,6 +867,8 @@ static int add_ipu_page(struct f2fs_io_info *fio, struct bio **bio,
 					fio_folio->mapping->host,
 					fio_folio->index, fio) &&
 			    bio_add_folio(*bio, folio, folio_size(folio), 0)) {
+				if (folio_test_dropbehind(fio->folio))
+					bio_set_flag(*bio, BIO_COMPLETE_IN_TASK);
 				ret = 0;
 				break;
 			}
@@ -1100,6 +1104,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 		__submit_merged_bio(io);
 		goto alloc_new;
 	}
+	if (folio_test_dropbehind(fio->folio))
+		bio_set_flag(io->bio, BIO_COMPLETE_IN_TASK);
 
 	if (fio->io_wbc)
 		wbc_account_cgroup_owner(fio->io_wbc, fio->folio,
-- 
2.43.0

