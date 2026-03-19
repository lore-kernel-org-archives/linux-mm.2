Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F21221088E70
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3425D6B03D5; Wed, 18 Mar 2026 23:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2EA6B03D6; Wed, 18 Mar 2026 23:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E21C6B03D7; Wed, 18 Mar 2026 23:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5EE6B03D5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:49:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A358FC1845
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:49:23 +0000 (UTC)
X-FDA: 84561432606.06.529A7A1
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id D958CC0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:49:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CSxnPTfR;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773892162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/TVqouUGbfIurHs4KmCF5QDFnRGSjDBtw8/+7JcMGzE=;
	b=HKJndoaT0ALCImihtxQXPXQZxE+1oq9fYxZJ0+8fWvqNEVdoio/sjFtUwAvGgvSiUe9S+r
	GmcCVhb18l2KD9yzpUpCrp6Ie6w5XZ11tamMOo3Cx7C659f67wOqvCFSRNjVBGhKS8lDHf
	DKivS7BQFKObhT6I1uywRcTVle5uMEY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CSxnPTfR;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773892162; a=rsa-sha256;
	cv=none;
	b=lgFuRc+iMyA7biXlQfH1TA2AaQ2a5dvWfLJxXcvzWyJtVQVc5dkk/HvzN4GHWWc+UXsfe5
	YcAsaR4EPSYXz+ibiilkL0qDS6kksw+HmNbVQvwrpdVYRQsvDUwXmtD851cS+R0QL+a56z
	QUGGCucryiDkkY3g8gt1MxeCMb4xTcQ=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82a07738118so388852b3a.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773892161; x=1774496961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/TVqouUGbfIurHs4KmCF5QDFnRGSjDBtw8/+7JcMGzE=;
        b=CSxnPTfRib58GPVT/fbbzyF69zkGlxeMQiGSJPTGDmG4W/5/F31G9Tkwekx4Vo4fd7
         YI5PiIInD259dQYF3uvjUmGIWb0ZRV3QpZPaUT0lrAbRR06pbBBdKnHFXc+95ZQhuTnh
         gJAtuHKQzIcIgaCwjLum2ZB7Q4B2X+ExssW4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773892161; x=1774496961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TVqouUGbfIurHs4KmCF5QDFnRGSjDBtw8/+7JcMGzE=;
        b=b91fLgrMu6iUber5lEXHBWLrvOIm9R/U6c4l756sIGeud2OuIEM4BGpTM13v+WxaWV
         2quB77ISRZkxMcv1RaKcH0JAXHim8j7tL7StlQ3/NEN1x+Ifco/+c6zBzmrkGTRDGdAZ
         86Gb6OXEuXxhncUJpD9KC77NhFcjotOTcGLUixffvMM0FDcT49uo3MOhOpXKBnF2whaj
         RX/HVXor0CNklM23KR6mX+p6lF06ZK/rLRNBriyOkq62TcKK8RSeyWeiZ7J0Klp3JWnL
         PBBsk+ma6Akspk+f+cKQRQpRtsW4hkOT3JrRhzK+m0mkstIp4dIylE8DqE6nW/lOjTFM
         453g==
X-Forwarded-Encrypted: i=1; AJvYcCW7nZV7G906Lwrh3ubD2k1Ma8S3dGwjNOY498FKY/69vNCO8GO6K0fT24FnpMK4zzAO8okob+8I3Q==@kvack.org
X-Gm-Message-State: AOJu0YwWY8q46diP8ui4TYjcteJ0XgYesMXjCPo2J1RnPczQvkDANnD2
	pwxpHoFXsXB+aigb38crBaM8E5wkAAJSw8h/VtQbDXrgSnOiEhVJ4r0DAdcnMcreFw==
X-Gm-Gg: ATEYQzy2XLqm2qKIgxvlksMAV0gtwY6J/QLpeHKwj1UuN7InP+u+7W74xGH78Ncncrh
	+H1r9+JKRTrFNIInhw7eAVdqeGMt284tQjk5MjXJp0hTv5jRnnpVeYFwt3RgBuKxt/kBqGVfWQ1
	CJLBaXcVSDhWI9iWd5+W3CKpx0TqEwkbmUySWyLhHcTmT2c5JNRXqe9H3H+nPlrGTLV19xWiaF1
	CeVAz8mMcLa2hRDz6YvQYFR022Pv2RTgEYvpUApMY1/tOjVgjf5LUUzcvol12ssLEddxQZ1fqY0
	G0+R6Foqz7fSHKClE8OyuUzo6g2nAHqme3/ED6fNjgN/A+7Ajt2AHA4y1pv4LFkNI6wz6fP8mSG
	wuAURsn6WVYqMWFR5UrsddyMUOIVvJyvcMlPE7sjnaLprvLfk6Og5S9z29JORIblwPOosj0vosU
	kt+nILI5b9pYlHIQUDvB+QrrqKMszx1D08OktJlRZDP07Me4VAwZxKi6KSoBtu/eMyaipMxHIq5
	Q4Ei6Rqkkzm0w==
X-Received: by 2002:a05:6a00:98a:b0:827:2dea:8840 with SMTP id d2e1a72fcca58-82a6aee8af9mr5419132b3a.56.1773892160688;
        Wed, 18 Mar 2026 20:49:20 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:13e1:7517:52f3:cfc8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6bbb985csm4240566b3a.38.2026.03.18.20.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 20:49:20 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	Richard Chang <richardycc@google.com>
Cc: linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zram: do not slot_free() written-back slots
Date: Thu, 19 Mar 2026 12:44:56 +0900
Message-ID: <20260319034912.1894770-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D958CC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: zpcfniy9a3ou9q1gmmhc5cp7w59r93i8
X-Rspam-User: 
X-HE-Tag: 1773892161-701140
X-HE-Meta: U2FsdGVkX185pvpRsZnElELWz6GAchM4cQewZp8rm6XP5w1rwL+VA+NSXk9VpvJZu0QTK//MSthETmOA9VMvmCuGS/ht8zzlRFW69NXFXCCZ79WXA2fKTviJE27jMIi9d4EkdktztOnWx8Tv66iQNTBzHAOuxRl9kiBk0CPVNqK7c3eI8QMXWOurw1rX6mIgXaxcnUQaYVL5DYPZOqcp4jG0y5yM1yGElT1qwbvRGpbA8O1i+CQnFigz9e2JG+UthKfoj/4IkDbhTEqVzuq9uHfPjf6T5QL83wKDT/Dd17kpYG7C0MhkLheAwXHLkq8PJY7Cilo9vbN1mSvoi7U5Q5VrDGprHV8NnzFf9WU/WErYJNgTMLZVDbYEjrxE2hpvv8w8J+4BZbOE41d4FA5J2bQX21cLeFy8Z3OMOP9zPi0a0+X/6ayOFcIqHOKqfXNib73tRGBRPcI59lpGhtY4GsUIIYEM3ae8aUgtZAaqpDqWRWTi3SyP8eln4Dc+jjLV1pBfzFrB1rXxpJmn6cPh87AYxeZ2swg/R8PRRj91rs0DaQnSZ/tPIGjgFIMaExzY3c9Ey74LTtcXR4nLLtlq+J+TPhf+61I26Fl3mg3dKYE0FITjdjCkC6QCjnYeRZysf0uUJlcA0vuxr/cIJqFa4mxHeGCXOCcFBRGrLJzUErME9I2cY7auzPIhixD2oW21w03P+g2uFkkFEKUI4gkX+Ngd2qKhO+IT4aGxsFewAZV/eSTOywP8HTl6cs0KH/d8X7qPp8glARXHWKgwSUgvhPjL6J14hPEtDH0e/ft9rKIlhOzUQBYH99/SYdMk++2pu+reakM6nYc9Rua6KLHjwjnCCJ34GvxabNILqxfSmQxIRU1gyYNnQo5FvqZI0VFs2SYcJc9nEng+0AaILqzYo1kQLAuaEjYm0kF845oVw8tsJLpO8mZ/dXm3YZZ8ZVs/Dgv/cbjkQkO6IEATyOs
 p5CTg8Ck
 01wR1cVO83yeP15igxkKtQrLFHGSuh8MRcRUsuaAMWYwnlXHhxYQmd+cykqGLW9znTaVf+d8+FAUo8NUZ48SAznbQ8PkllCbBe35sA+xEvVvJ/GyDSdB4cQcc8yyRgSD4PbNW9lExjVN4bIBL6gQ79U2TR6XDFGnj5GzA8h4xGnCbvNuPh1v9L4HMTWVl8lfLjTgf+koWIpqe1O8Et7YZSX+wintFujFsZgu+6TZxNux9ZQohxkhca8thHRRys23eTCQ92kUoirAlu9R2HLBa+GJx0i7ZrV3KYWV79yXZ2InUuLS+kRAfFIYSiWT92gjxfgkLgxGgCmZLCv1vGeBat4RITMcjpat7Vr42
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slot_free() basically completely resets the slots by clearing
all of its flags and attributes.  While zram_writeback_complete()
restores some of flags back (those that are necessary for async
read decompression) we still lose a lot of slot's metadata.  For
example, slot's ac-time, or ZRAM_INCOMPRESSIBLE.

Do not slot_free() on writeback, instead clear only those
flags/attrs that we need to clear.

Fixes: d38fab605c667 ("zram: introduce compressed data writeback")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 39 +++++++++++++----------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1b0e1c02ece7..5ecc4ba40e9d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -917,9 +917,8 @@ static void zram_account_writeback_submit(struct zram *zram)
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 {
-	u32 size, index = req->pps->index;
-	int err, prio;
-	bool huge;
+	u32 index = req->pps->index;
+	int err;
 
 	err = blk_status_to_errno(req->bio.bi_status);
 	if (err) {
@@ -946,28 +945,13 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		goto out;
 	}
 
-	if (zram->compressed_wb) {
-		/*
-		 * ZRAM_WB slots get freed, we need to preserve data required
-		 * for read decompression.
-		 */
-		size = get_slot_size(zram, index);
-		prio = get_slot_comp_priority(zram, index);
-		huge = test_slot_flag(zram, index, ZRAM_HUGE);
-	}
-
-	slot_free(zram, index);
-	set_slot_flag(zram, index, ZRAM_WB);
+	clear_slot_flag(zram, index, ZRAM_IDLE);
+	if (test_slot_flag(zram, index, ZRAM_HUGE))
+		atomic64_dec(&zram->stats.huge_pages);
+	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
+	zs_free(zram->mem_pool, get_slot_handle(zram, index));
 	set_slot_handle(zram, index, req->blk_idx);
-
-	if (zram->compressed_wb) {
-		if (huge)
-			set_slot_flag(zram, index, ZRAM_HUGE);
-		set_slot_size(zram, index, size);
-		set_slot_comp_priority(zram, index, prio);
-	}
-
-	atomic64_inc(&zram->stats.pages_stored);
+	set_slot_flag(zram, index, ZRAM_WB);
 
 out:
 	slot_unlock(zram, index);
@@ -2030,8 +2014,13 @@ static void slot_free(struct zram *zram, u32 index)
 	set_slot_comp_priority(zram, index, 0);
 
 	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
+		/*
+		 * Writeback completion decrements ->huge_pages but keeps
+		 * ZRAM_HUGE flag for deferred decompression path.
+		 */
+		if (!test_slot_flag(zram, index, ZRAM_WB))
+			atomic64_dec(&zram->stats.huge_pages);
 		clear_slot_flag(zram, index, ZRAM_HUGE);
-		atomic64_dec(&zram->stats.huge_pages);
 	}
 
 	if (test_slot_flag(zram, index, ZRAM_WB)) {
-- 
2.53.0.851.ga537e3e6e9-goog


