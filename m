Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB78FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAF36B0005; Mon,  4 May 2026 08:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C176B008A; Mon,  4 May 2026 08:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491B06B008C; Mon,  4 May 2026 08:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 381516B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:33:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D99E2120196
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:33:10 +0000 (UTC)
X-FDA: 84729677340.10.F1A2260
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 167EE40005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:33:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W3Pg9XwB;
	spf=pass (imf12.hostedemail.com: domain of 3A5L4aQoKCGAPGAF8PBWAAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--richardycc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3A5L4aQoKCGAPGAF8PBWAAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777897989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e8/CDtnGvalUzgGFzgyiRHcKrsHnUrOiavCD5LiN7Ac=;
	b=O3+kgYkG0O+TcTp25bdpY5ZktRxpSPokGAA4K/+iZaUNlfj6nQxso36MrEcIDB+DB8JVtp
	0vPXEOAwl+vJJ3MYasUBrcnQsOjL6ZYSvf49B7t2/jZRqE0EYt7GmztoUg9D2l2Lb5Tm0F
	zpi9t5Hr8U8QwCMcXRNR9B2GdSqUXzs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777897989; a=rsa-sha256;
	cv=none;
	b=s3UGdDQeYxnXtDS6fqObrcdIrZgs/z8vrbryt30M+H6fSpSGG9p56SippVduqDjOJSrdwV
	cWDp5yt+vA7+JHq1XxWWwB4LCydDX++oj7abUgBxuwhDttuaVh3oY/fq3StMKIk5IXxSAY
	EUphh38NONge6dyeJs7bw4tobqr32QE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=W3Pg9XwB;
	spf=pass (imf12.hostedemail.com: domain of 3A5L4aQoKCGAPGAF8PBWAAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--richardycc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3A5L4aQoKCGAPGAF8PBWAAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--richardycc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-837cc5bc6deso432899b3a.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 05:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777897988; x=1778502788; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e8/CDtnGvalUzgGFzgyiRHcKrsHnUrOiavCD5LiN7Ac=;
        b=W3Pg9XwBRTp0z0qx431XT6hPtxgOfoO9xSR0yjxrYNsITq2N9lDEcirEWmA1hjZ2fM
         sxgV1pRlrOaIx2Uq1yCCvLqTWc8wSdN4gMLkmBsT3CZs5jmFopUCQFT8ylP12Lt3O3lG
         7VcqMvQl3gFb+HdkKKKDrUKB/YorLbU85EMJ1rQWUsZO4mx7c4+vlQ5I8ycVtR3DX0da
         CQ3d1CPtT9wHjA8aIqleCBCgQ6oH2eJPr99OPD8+DJa4LWuNXdD4f8gUI6WPfpLkHKOu
         6rHGf/Fj8/TbZioOmwgfd3ZHbRyKb/2n1FwPBayB7rbOzWnFY5n2k5FqT7XEj0BEzWYH
         BUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777897988; x=1778502788;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8/CDtnGvalUzgGFzgyiRHcKrsHnUrOiavCD5LiN7Ac=;
        b=eXSZDQgkBb5ad4QDLO8RS588nfrpOF7IMB7D8Bxrzsvw+SUh3b26v32xVF2OuEhBmX
         oFg8r4fl1olX3HlBjZ9YjbABK5smsux3+Vxdy1zy2w4BR2rmr2VPC/UE3iW4jpry7kIn
         yIPswVkbV0MHH7OXbKtRxcQWsekCOTMUwQrm6VAQ8G+AIkcQxgjRWqq0ejBfgjD/lzge
         poRSfc6DqudkQKpW0iB3BI6ZvXA3ayh1HGylrbttpM6IW3CJL9kf2fR1bKq5ZErkKdw4
         5D/jQmqLSLaTLrMvExBD9QQPYx2yEFit9RGg/m2YFDtNOtDAcVViE0IDiObBbUzPrfYT
         lTEA==
X-Forwarded-Encrypted: i=1; AFNElJ9v7FEo34dWvd4cD1n6QTSCoQZn189iYgKjyQXXfFM9sa9wE3OpODQS6UmFQX53s4BokQ7sa05d9g==@kvack.org
X-Gm-Message-State: AOJu0YxZ115AsaWp0VNWwwPMei3UeniWbJEJhqW+6u+1hkTvswzKviLn
	4wGzfO7/XSJqVmQWVJC1BF4C7yLn/7M1WreI/xdb3D4bMSTEQ5EKZMlfhEEoehffB3zbWda28Zw
	8TWh+Np8Qt0DlfdGwwu3B
X-Received: from pfblu21.prod.google.com ([2002:a05:6a00:7495:b0:82f:86c3:55ba])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8ccb:b0:835:3c9f:1a15 with SMTP id d2e1a72fcca58-8353c9f1f13mr4332851b3a.25.1777897987531;
 Mon, 04 May 2026 05:33:07 -0700 (PDT)
Date: Mon,  4 May 2026 12:32:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504123230.3833765-1-richardycc@google.com>
Subject: [PATCH] zram: fix use-after-free in zram_writeback_endio
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 167EE40005
X-Stat-Signature: xha1geyj4gqcw5ja71fmb8i5k79z3s96
X-Rspam-User: 
X-HE-Tag: 1777897988-594840
X-HE-Meta: U2FsdGVkX1+nkrB2y2cCELVvAeU15Ddg3Jr36FYficz4ml83w3toTdjhUcz/QPFJUGiGMehaGNbNzPdGwiEI13a/VspM1amauqiPK2KSkrFNdN+pyptPp9qc+Ut9T0fxPs7Vzz8Dqv7Ll757R+ax/EMHADxSemEzYM3CoJ2wrO607A7P02Ry1gM9nWZ/wPlaK9OqgxuRH5+R4om1wfO9ohgxYBOC4cxtGN0/6sbV1CXh7PjQbugXkYFzweIuIhZWMSPFMuhGJpsjvlYSXhdHAQfUYLeoyOYtlOoSMhqyY0+UTlNmVue8DojNC559BOu3b7vl4h9IG63LYAl3kZ5TrAxayvNYoOyWlgP6UbM/pkfDvu+w7zCChurq1xLHx7wxBpv8lEwZQHEf7PTERxNz3D9IVUAJby7EbX09OBVgAxESEnZ8uXys0prU/vxkUdbi1iMoRvd94unYQHRcvX0Mq/T8N/BM2bKrvpmSF5x0uXC3gaPcoUMu6tnXqA+d7nNVAsKFqSDzfcJs1tuHjEYCZKnko9sOWEIsntsI5IWsbkKcfsTV11kWf4uSqCYHg8VlcnBpZnGb5EXZWiRshdINTgA4wIZRLBdaL828IwUdKwzS0pB90GxtHlPQMBkvo91zn4lOoVzD00eS9bibNYW2RqYJ5Ct2Tooc3VdqlA+5Jo99H2YKSkLmyCTW17CVNO2Fn+Q+TsQyhXp3kgFuVWifgdv9tzuBFgmjRv3yLnQOMpDba5XafRBURtBHi2MvEXAEbE0ZMRAg4glHb1VJFoIo2CK6l0z1Ag/o09X6xgNbhbkL/YtfUq4vmZ4pWI5oIL2K3poKMa0IwVxcwTW7CP32newjQfvGRQ0iYuAXvkrlwni8eW9PW9JKYZPVtg1wo0Ci/qpajietdL3aO8KtY1tYmSe+bdZMQeE+5DD7w3QOVoMQcZfOD7F1bVGjEGjKIIE3vTfimi5T+uLGK1YJEKO
 S0JWbi2V
 FA9FixnmQjio6hRB66GGHAV+ympjSeSasvGSzSE847bsock7b6uWVRV+jtTM/JXT84KTRbfNHQSZNbklWo+RlzNgTnyzWYuKVYC2qJ2o84G/bw9Bx99W7+FAn9vc9TjV19Ax8ypo5XcGDIAzDCSGrMtYpGD8ja1coHrh4jtJ7QAR66+CKLzQitw4Zx/qb6WeqieKzVkqbWlk39DfcgcFGkC1WcAwGINU+7HX9s0K/LENax4kHllsdRGMDFJLyV8UFfxZ5UY/xGF1b5xKJ4P/GEO2181QLTwECEViqxpeAHDAws7FKBxuF5z+iPNF4WCUix1g4GHHhHkP1zSIzBq118apd/z06NsaedSOHuFrqzbPmS0nDsGN3EFtVmm9jDOuYs/2/tqL6nb+v4eyMvjgCYH6RAzreW4fJHcGmqtFpYnOgbXajRipvS3I49sUmahizJmmJSgrK9+nc40xlWcHeTCJc4+ivUNtmcFSAJvTyF6m0irqk8GyRjI9uApOPV0GKQePqNtOw6nHq/41O18X8ISTrsY0+08vcpbl/hd4PBwjZdLIT/bvNcL6a97r8g0f/Ke5JhL2XJiLXCa1OepiSBLa2Kb6odDttwKHK2tBq8O7ytfvXaMv5kqcUiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A crash was observed in zram_writeback_endio due to a NULL pointer
dereference in wake_up. The root cause is a race condition between the
bio completion handler (zram_writeback_endio) and the writeback task.

In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
releasing wb_ctl->done_lock. This creates a race window where the
writeback task can see num_inflight become 0, return, and free wb_ctl
before zram_writeback_endio calls wake_up().

CPU 0 (zram_writeback_endio)       CPU 1 (zram_complete_done_reqs)
============================       ============================
spin_lock(&wb_ctl->done_lock);
list_add(&req->entry, &wb_ctl->done_reqs);
spin_unlock(&wb_ctl->done_lock);
                                   while (&wb_ctl->num_inflight) > 0)
                                   spin_lock(&wb_ctl->done_lock);
                                   list_del(&req->entry);
                                   spin_unlock(&wb_ctl->done_lock);
				   // num_inflight becomes 0
                                   atomic_dec(&wb_ctl->num_inflight);
                                   returns to writeback_store();
				   // frees wb_ctl
                                   release_wb_ctl(wb_ctl);

// UAF crash!
wake_up(&wb_ctl->done_wait);

Fix this by moving wake_up() inside the done_lock critical section.
This ensures that zram_complete_done_reqs cannot consume the request
and decrement num_inflight until zram_writeback_endio has finished
calling wake_up() and released the lock.

Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
Signed-off-by: Richard Chang <richardycc@google.com>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aebc710f0d6a..a457fdf564f8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -966,9 +966,8 @@ static void zram_writeback_endio(struct bio *bio)
 
 	spin_lock_irqsave(&wb_ctl->done_lock, flags);
 	list_add(&req->entry, &wb_ctl->done_reqs);
-	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
-
 	wake_up(&wb_ctl->done_wait);
+	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 }
 
 static void zram_submit_wb_request(struct zram *zram,
-- 
2.54.0.545.g6539524ca2-goog


