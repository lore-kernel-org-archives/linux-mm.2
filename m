Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E24F30296
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 01:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD066B00F0; Sun, 15 Mar 2026 21:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B086B00F1; Sun, 15 Mar 2026 21:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C306B00F2; Sun, 15 Mar 2026 21:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 836C26B00F0
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:54:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E267E1B93C7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:54:08 +0000 (UTC)
X-FDA: 84550255776.18.9FCBC59
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A462180002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:54:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QYSQnc6m;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773626047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gYqr+vB0yDmh6RC6NbmJZwyMtP41pGo8Z22GiI8XtgA=;
	b=0kYlqk/xHrVAp0EISOuGo2EBS6Qpk/8OZZ5JjHHoznyRgHqGqeBBVAq3t7j7Xt7zk9UNW7
	IwisUWx7ibNs2eEIc5S/Cxovccg4cGdLCsNELPyxflDlzVoETJ1LBTW1hjTpLE6RNQP5V9
	d0SpXGyx9riL6etqH/D7VUdyOYOJrao=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QYSQnc6m;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773626047; a=rsa-sha256;
	cv=none;
	b=yJaqDH3OYFF7aTsmWkLay2AdeEFjAx/pvl0NlrY2ALPd3w62xOD8YK4wqkE7IXycqPHgQX
	fEsgouiIKMVnMrSJ1mpRZprHfbe2hrzpi64OVPKIz+IlSL4wrJFIXjSCsWd5ejcM8aUuAs
	MiY0xGTFn5op3F8zR1DOpeXd4bAR6V8=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c739561f0d3so2482786a12.3
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773626046; x=1774230846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gYqr+vB0yDmh6RC6NbmJZwyMtP41pGo8Z22GiI8XtgA=;
        b=QYSQnc6mHLgUk9EP8bh77AFNmhuj+flCA/oU3MCv9pMLpf4SFbugKusi0UTgWntmjw
         XadwksX98UwXfbhoYH2Y+OSV7EEQQtLKXJ7aV7H8J24kEXZTEp5X93jJlRgT89F9U03f
         KjSOWZPPyPTWZ8W2NsocXNW9F4lFEyLTOf/aY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773626046; x=1774230846;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYqr+vB0yDmh6RC6NbmJZwyMtP41pGo8Z22GiI8XtgA=;
        b=IrObsCNBGc8KOOBFqBYQSih7EjZuDYAun56wZHJUv8ztq4QUqnlG49P/x8xrCWf7FM
         7lXQxxDbfBBpk/8l1sD5E8SZ5oe1vrPxtWbh17RZFw5LssAFAMVBrCmO5JUPrLA/kTC6
         2JBaCdsu8sbkH2L95DEZH5KeiP+a7o5wTlUeG5c34L7RRF5YlOa/yQKjlepTDWAS9AHt
         7j04e5SWWd5NUK1z/mWju8IiaLvJ3F+raORq8OTamy9mbnuCUB+GxMOD1PRKNrCaqacp
         pX5n0HZMsJyFaxP7IpfNOqBHUxgAUCIjd2wcrD1QEsCF67vKHrqHkXJRSLX4kWF/8lAf
         t4Eg==
X-Forwarded-Encrypted: i=1; AJvYcCW6f2mbU+jKbTzq2o51XuG+2KOj3puUvFjZi1IxvXRYdTl881wgCLoglDaJD0g/L+bFgUzlCBF5fw==@kvack.org
X-Gm-Message-State: AOJu0YxWPG7VaTncgDUQY8LxGmDG/HFJaTwJqK2Y8NpGJajh6WbWbLu0
	wrPLpzLeTzV+3dDi60s6T05SWcWHawbiWFpZjR/LDEa0jBMBZ5bdVXLWP2LH808gJA==
X-Gm-Gg: ATEYQzx6y3xrZOIUzjXrurOnDV6CPUPD1JuEW0vcZ8TB9+BhYWGt1LzUI1jF6fPk4eH
	38WlDumaLVWr/jOOtPQ//TpLXj+WoGcAI2jPvpqRkQPPJSmY1wF4bTf4gFz8sTMWpP2FmZLQd4u
	u9ZAJvN+UFg92l6mrGKHFuOOTd46IUlhRa+W7GtG6+sW79DG3qQCmAzSS1bpRuNsHJkFL5ENwkQ
	yvbchrj4/pu7BBLUejemUWvXhbCN/ZOH2O0ODgsHxPdYu5QDdMQRnZOjsHgPSgRPz/8cj4hrjtP
	klHZKFrMjCO/Wh44ReVGm+fBOzA+OEmoFvJtk3NxIddD1Nx9wZK2baiCwQv7p9hNp1yhBwTE3Q8
	PosZ/kJvIGFtHMzyis1KdsRRhZX6mHolRl2Bd7doosxj7r46lm+N4XEAAGCKvszR9kzxh5YLsDt
	XlMjTURPB/TjUDNbjaPPXBQIX0bGKCa9s4+xzERJXHdNocyCMusQh88m1gTQ5ioZb/M6CpbzhJi
	OcidUak1UoTyw==
X-Received: by 2002:a05:6a21:6f8b:b0:398:82ca:cf69 with SMTP id adf61e73a8af0-398ecddc6c5mr10663047637.65.1773626045779;
        Sun, 15 Mar 2026 18:54:05 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:b3b1:8c6a:2e95:3888])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07268aebsm12286440b3a.23.2026.03.15.18.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 18:54:05 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Richard Chang <richardycc@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zram: propagate read_from_bdev_async() errors
Date: Mon, 16 Mar 2026 10:53:32 +0900
Message-ID: <20260316015354.114465-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A462180002
X-Stat-Signature: xkcws7iaf17gjcfxaihniux8faubgrda
X-Rspam-User: 
X-HE-Tag: 1773626046-562039
X-HE-Meta: U2FsdGVkX1/5AlonEK3Qqw+nn0wTcOr2QlXYd7xYVPTToIsc8ZGMX1Orm0+PV2CdZdBOanNd8FH/4gY/3ioJI8E90WJ4p4/Dh+SA6FECbtl2kEEonZ+tCkIRaJFP59X9ulTJ0vuw+PiPvYvG7E1ZgMzMX4TBByjg2zug16IMzx6rSG1uiU/WK8/78R9YuOO555m92pizHDFxwHNori/UzTwLu9txWHiNMg3A6yEQjj09D4pxt2FMlFpsSfzBlINKf+odrTS/Z2d217EWr4RC4uU/9Fe9XvsA1MoUgL9/4X6nRxAN5Rigfaa7KuyiuwOEF3llxuBZGgSs94mUz3BY+hByziK7xUxMJ8LoiAY5C0BBE6BEJeA9rx8w16zzw6HNe+TSgOpIAn2R8MB2b0+8MlXmJDZpM/Mk9uHBx+2ycmWsi8H+C3p57S6DfgpybNe/ZxesyMlISdAZUWsO4lBNe2N9ZQnwfk4EIjtxfUdabRZKHs8cdvitIDuUvz1zV7O1C3fsQ1WDcGEYUUZWuVYZ+zGbMiU97T7ZAE3W2ZNaePly7DdozRMxtatll9H5fzBgJP5q2WpO8Pd5jjmJ6bTyiQLepMkb4dZQSB8EHYqzCrOw1++OqCv77phcFsThDT6W/p4c68+weWnwWp4zWBkon1qHd6++KO+oTRI0Dhg5pCtZ5/kHyqZMpXh/XBMYfTgW1yt7kVTVOvPSyBZ2aW31t/z4ysZVpBEKeA4CyMLQkTsgI/sMz1PnMpfqnnbUCw0wLn2F1FJxi+DkifR7QQ1Ox8cbLJagodxboKGw2AfVNG8N3VygyoVbYw33JK52MEtuTXCZ+WEzwDC5fmH93z79ij3GO5pJTxhlekNAysmBik1+jrD5soHuATaj7Nr04/V5Z5zZVfzkIkVaCbTTqSJAw1/ZhQrz9qibJEVQz/6x9XFrs+CPnZCuN2iIChZuw4IkK5FmsmSItD4BUxNxQco
 PKNbyjtW
 zDpwzX4H8gb1VfDsMziw1miYcnekJYlyJ9xmCPG+poL/3+tEtlbv1cvzb20rtTtgGzq05kP1xSDz+psm+n0b4r+Qf2/ELjft+qo/ZpHI3b9mf1upakhpCr6lK9uMiZCHElmHgswuXLkmehs+k0svTSAGCJMkpPQy45YPN8kmfLfPA8B44vCuU3H5opqlP8MxhpkKnufcQGCvwBaDBGwClQm0pRJ5bMKMf0Vt2d8TONHEcNOultPb1M4FxU8ChlQZsoh6KB2V+H7pWzgcA1theP1PyuXFyEFgAM8YwO5pBv8c3cfNRx5Dg6dmOyvhG03pESemqYZMe9tFVn+oHIqwVwhv8aFjD515vcmJCvQj6Rzrt7NCczwQw7yrHkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When read_from_bdev_async() fails to chain bio, for instance
fails to allocate request or bio, we need to propagate the
error condition so that upper layer is aware of it.  zram
already does that by setting BLK_STS_IOERR ->bi_status,
but only for sync reads.  Change async read path to return
its error status so that async errors are also handled.

Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 63f71371a7e9..b47cb1d99144 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1445,21 +1445,21 @@ static void zram_async_read_endio(struct bio *bio)
 	queue_work(system_highpri_wq, &req->work);
 }
 
-static void read_from_bdev_async(struct zram *zram, struct page *page,
-				 u32 index, unsigned long blk_idx,
-				 struct bio *parent)
+static int read_from_bdev_async(struct zram *zram, struct page *page,
+				u32 index, unsigned long blk_idx,
+				struct bio *parent)
 {
 	struct zram_rb_req *req;
 	struct bio *bio;
 
 	req = kmalloc_obj(*req, GFP_NOIO);
 	if (!req)
-		return;
+		return -ENOMEM;
 
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	if (!bio) {
 		kfree(req);
-		return;
+		return -ENOMEM;
 	}
 
 	req->zram = zram;
@@ -1475,6 +1475,8 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio_inc_remaining(parent);
 	submit_bio(bio);
+
+	return 0;
 }
 
 static void zram_sync_read(struct work_struct *w)
@@ -1523,8 +1525,7 @@ static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
 			return -EIO;
 		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}
-	read_from_bdev_async(zram, page, index, blk_idx, parent);
-	return 0;
+	return read_from_bdev_async(zram, page, index, blk_idx, parent);
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
-- 
2.53.0.851.ga537e3e6e9-goog


