Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF7ECD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2C66B008C; Thu,  7 May 2026 05:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9CC6B0092; Thu,  7 May 2026 05:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0426B0093; Thu,  7 May 2026 05:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8526B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:40:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33E5B8C898
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:40:44 +0000 (UTC)
X-FDA: 84740129208.26.9AB3DA8
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 428B4100003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:40:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kPaGNybq;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778146842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GHLHxbWZMeODD7NZR/2u5e4BofCNB2jQY/FhKfcUTY=;
	b=edsa24KmTopVvx1bfCG0FLHP6o8JPYbJHwL9e1rUC8aBIqEsTdjRkz8LIfQAcBl3BNKKSc
	AHEpnkhK+nH0IYBSYXRPJvlSfo1t6hBxzM0IBrrUAIRCobUQy3uW82aDFSP3N4eKy7I1TI
	Z7im8c+9BIVsp7dP92Go2H3HRv4W5d8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kPaGNybq;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778146842; a=rsa-sha256;
	cv=none;
	b=5ifwkrWpBvV18lSr4yMyPU8fM4dGa295rr1ZW9qyBY5fAOsr3tyraxHpYHydoSaaKQzC5G
	lc6WI9E69hUlj5yRMloVdEn81FiCPK8j5Rj3ASA8O0oyNQrFPGwZWUDDHaXuvc9BH1KuI1
	wJhbdKezHldHY+RevlPQZGxEDL2eq5k=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ab46931cf1so12636445ad.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 02:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778146841; x=1778751641; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6GHLHxbWZMeODD7NZR/2u5e4BofCNB2jQY/FhKfcUTY=;
        b=kPaGNybq4p+zjIDGM8xDlQUWSz9IUAHNbIyOndQ8wWWLyWm4Xqa/cncWoWEutRVcI6
         6A2dvf79QXYDW3QmR8/Pv23Y6QvzU6YQZpy64L2R44JPHa7V6yXLk/O3G4X1TdDiCNZ0
         7QhFeEn1ctlIxIhsgUY1s2CV4ZJygUNVL7QJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778146841; x=1778751641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GHLHxbWZMeODD7NZR/2u5e4BofCNB2jQY/FhKfcUTY=;
        b=rV2s1Spyzw5hhRtI8YIb1aUbtSYt78GRHlDieEyLuqYkIb1e1iuYrlTaHzb1aRKzm5
         +W5e2G0CoWF7WVtRtDR31vowh9QgRHh4xQsctKSImXh+O+QWRnh3PHaVGiie4BjuRynL
         LsPXF6S5SGPv4gIySGfntz/ugS6LLqOpO+YsqSKYftA+Zjka/I5ev6ZEZaB2amkvx8ZR
         dolJIG7GIHDDzJ3Al12QJkf5LKP7nj8SXFrW3cVnVQnDRBE9iK8dBSEmjWagaNoi70U/
         Xsx1fCbkeIRctOs5Fjit8XaEDsVEaDN2COQckmyuk/z3oi9pGbC0azeG0602ntwE8HJW
         lXVA==
X-Forwarded-Encrypted: i=1; AFNElJ+sjX92gUxpZI1DpsQRnooHlBT7hfY/kKBuRIBavaM+hka2woSas4vLDcfE+ZDQS1jaFlzW7hsJQw==@kvack.org
X-Gm-Message-State: AOJu0Yw7kS0Jl+KKHz3ht4XbhfDLCA751hHkwWFdLa/w2IoIVceq6UNR
	vOP9wvp5MI8rBAvCHtbfeP7LjbZ1sbj29u7CCtbhAM9dfhhgkFeJCewVcfEbvrWLrQ==
X-Gm-Gg: AeBDietQ4CIuBtotuXz/gcDCJ31UTopabem9Hld/WW71SjfceFt/0ytOQVLgPil99ph
	vWDwTVSFFhtFOOu5yXj+zoX3TJByylA5nY6xSAKjBqMHS1UWMQzCnM9Uw3nGqfxgVHbFWnYb6Y7
	laSiadwaB4+hGa3MQu4FBBn9JqQrnfd5afUf9nn6g8RXLOX3lrjWAwdwmDTcIT8An0uotdc5G6K
	GBDQGx87Bb9MtrM9hQ+ojRHLC9bcG3gVDDs7pmlpD9xiQyBl4QRVYJg8oVkER1bqAr2cLIvxoOT
	+iOQqnp+DXGEUWN143rq0B1+qTZTuDtpEIsUpDERZWnknR8KDX9yrypbFsQ9qv2J4fX/1GwRv1G
	soHWAsTZ5LNK7bzIEfCjH9015SViKJP8MsoYDuurnrAluyqcogsoY1PwWrJFO4vxUHZTA9mZ67S
	PlqtE8mKMWrxbSlGPcPhAR5hfoYs+pso1HvM3JLXSfaE+2OvvSUOQCEsKQy6QhKv2OIfWAWK+Y+
	g==
X-Received: by 2002:a17:903:28c:b0:2b4:64cf:e8f8 with SMTP id d9443c01a7336-2babc859054mr19200625ad.2.1778146841053;
        Thu, 07 May 2026 02:40:41 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:7ba2:1dc2:ed3e:1484])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2babaac3576sm20701395ad.4.2026.05.07.02.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:40:40 -0700 (PDT)
Date: Thu, 7 May 2026 18:40:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com, liumartin@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: fix use-after-free in zram_writeback_endio
Message-ID: <afw2919RiZje9xzq@google.com>
References: <20260504123230.3833765-1-richardycc@google.com>
 <afoc5qLvK2PDQKb-@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afoc5qLvK2PDQKb-@google.com>
X-Stat-Signature: bxqtg8aetp8iua9aumoickmtaciim4hc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 428B4100003
X-Rspam-User: 
X-HE-Tag: 1778146842-858596
X-HE-Meta: U2FsdGVkX1/uC2D6MCQ9OZAyhSioD9WHZ6SmTVadDVRpR2OqxuseB95sfiTme7c+kHvRRrSdYrXMI7fKvC0iQ3PW9wYtiMJEPtXJpxS7Q5dBw8tJJubNsrEcQ9rsEOaWNONyLZfS1uJowtpUluKpEHQiQ3rs58r9E6pwoDkZOnvbKhJlOauR8kchekW8Q3Kr0C0nRZMCXdCYCxgufa1oovR/alghL2mK5u+F2nkcpetxeaCpNkc/JirLyHS7A79c2s0eq/xwJ2PAPz+xNAUB6LgxNvGotUSVofPjaKw3eAIDDHzFMzqiI0yj/b65ZvH5+gzkvtMS9bbQX7LeV0ccpq7XYyPK5lqMSI0f2E/qqgQI5f3/eFVyHzbcMDwJMLtuxEYXZMZPsNnVcpTGJXEZdyttN/0ipOaMS6aTKMiSCtYKjNC7kt9bRlbmNKJFCyiYa25iHqZ1OnkIkNW4COcs1QjjwUY+RTQaXbKqTh6WQYIXyS3G6R+UDx8+34mkfuE+jsY3pyJ22p2Ci52dJKeoXPfQVvh2HEbRussjTyHwT1O/DQgR2/bWq5CMgGggPcemQSZMczffgOMjO7wqsB+DQDeIOp4/+WDBouqVNMHrUCZOjHMvoSEvUhII2jBb+cZ7D1VtMZkydCxUod5SaRj5yvl3bSImf/eSUwkKyQaSCOXKgeUAyKXj4mc6AlDsa0lRP8uDEJE9Q48SLuuAoyuHiv5/SbN169o/5p+nqgJTaGCIXQ0qKjo1p4FFC5YXGOdISGkxzYlZVWyxtpgmVFYi91d2C/VhRnVpc2a7+bg+zbKI7fzmKI9bYY8rzPW4Dk0C9H9V70F8/tobKOhRTYnKBSZPSW2DSoD1Bml8LlFv81jMe3+yzcpfTS3bsLULA4ichQx0nQTpqJNxVA7GwMGTzGwhakg5ZGU5bz+mbt58Bd71wHl9zmkN5irKHFNvt/bluqUl/+xUZRgO5yeIEcK
 laim5nFw
 DJN/yPC+JyAIetlCRwPu18Tk0g1vveYwb1aGOF9vks1K3Zqm1xTzSJZ84jf5EgGDSHOqO+H1M08F/oeEI2Bsiu02Z7KhtQwE1RrZkLTucAbKykETj1IpNZS3+AGLx/RCnLDb4GV6A7fzs6lH92Lwnmgzrv0BuY6TSNtN7dECmp/A1zxberSFOltPFC53uPh/3MSZwxxi7qebbyzPO5d2Hr/DkFwvhVsxAHjTwFXFYkSXGUK50wo8XMNTsZtDAh8KTzMhoAjIZMpm0+wF5Zi1bCFGYS9EgT9Km5A33QLiSxcYDNIlS+yUwdpfxszUXKVaSMghjRX+rRR7QXUvusl6c4tel3VeNP+P0WLzZ98Pc/PJz6CHvpM7Y8azuQy3q3NExhxacJQFyMkRNm/jdUjxYhY8s4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/05 09:37), Minchan Kim wrote:
> > @@ -966,9 +966,8 @@ static void zram_writeback_endio(struct bio *bio)
> >
> >  	spin_lock_irqsave(&wb_ctl->done_lock, flags);
> >  	list_add(&req->entry, &wb_ctl->done_reqs);
> > -	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> > -
> >  	wake_up(&wb_ctl->done_wait);
> > +	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> >  }
> >
>
> I agree this will fix the issue, but using a lock to extend the lifetime of
> an object to avoid a UAF is not a good pattern. Object lifetime shared between
> process and interrupt contexts should be managed explicitly using refcount.

->num_inflight is a ref-counter, basically.  The problem is that
completion is a two-step process, only one part of each is synchronized
with the writeback context.  I honestly don't want to have two ref-counts:
one for requests pending zram completion and one for active endio contexts.
Maybe we can repurpose num_inflight instead.

> Furthermore, keeping wake_up() outside the critical section minimizes
> interrupt-disabled latency

So I considered that, but isn't endio already called from IRQ context?
Just asking.  We wakeup only one waiter (writeback task), so it's not
that bad CPU-cycles wise.  Do you think it's really a concern?

wake_up() under spin-lock solves the problem of a unsynchronized
two-stages endio process.

> and avoids nesting spinlocks (done_lock -> done_wait.lock), reducing
> the risk of future lockdep issues, just in case.

I considered lockdep as well but ruled it out as impossible scenario,
nesting here is strictly uni-directional, we never call into zram from
the scheduler.  Just saying.

> It definitely will add more overhead for the submission/completion paths to deal
> with the refcount, but I think we should go that way at the cost of runtime.

Dunno, something like below maybe?

---
 drivers/block/zram/zram_drv.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ce2e1c79fc75..27fe50d666d7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -967,7 +967,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 static void zram_writeback_endio(struct bio *bio)
 {
 	struct zram_wb_req *req = container_of(bio, struct zram_wb_req, bio);
-	struct zram_wb_ctl *wb_ctl = bio->bi_private;
+	struct zram_wb_ctl *wb_ctl = READ_ONCE(bio->bi_private);
 	unsigned long flags;
 
 	spin_lock_irqsave(&wb_ctl->done_lock, flags);
@@ -975,6 +975,7 @@ static void zram_writeback_endio(struct bio *bio)
 	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 
 	wake_up(&wb_ctl->done_wait);
+	atomic_dec(&wb_ctl->num_inflight);
 }
 
 static void zram_submit_wb_request(struct zram *zram,
@@ -998,7 +999,7 @@ static int zram_complete_done_reqs(struct zram *zram,
 	unsigned long flags;
 	int ret = 0, err;
 
-	while (atomic_read(&wb_ctl->num_inflight) > 0) {
+	for (;;) {
 		spin_lock_irqsave(&wb_ctl->done_lock, flags);
 		req = list_first_entry_or_null(&wb_ctl->done_reqs,
 					       struct zram_wb_req, entry);
@@ -1006,7 +1007,6 @@ static int zram_complete_done_reqs(struct zram *zram,
 			list_del(&req->entry);
 		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 
-		/* ->num_inflight > 0 doesn't mean we have done requests */
 		if (!req)
 			break;
 
@@ -1014,7 +1014,6 @@ static int zram_complete_done_reqs(struct zram *zram,
 		if (err)
 			ret = err;
 
-		atomic_dec(&wb_ctl->num_inflight);
 		release_pp_slot(zram, req->pps);
 		req->pps = NULL;
 
@@ -1129,8 +1128,11 @@ static int zram_writeback_slots(struct zram *zram,
 	if (req)
 		release_wb_req(req);
 
-	while (atomic_read(&wb_ctl->num_inflight) > 0) {
-		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
+	while (atomic_read(&wb_ctl->num_inflight) ||
+	       !list_empty(&wb_ctl->done_reqs)) {
+		wait_event_timeout(wb_ctl->done_wait,
+				   !list_empty(&wb_ctl->done_reqs),
+				   HZ);
 		err = zram_complete_done_reqs(zram, wb_ctl);
 		if (err)
 			ret = err;
-- 
2.54.0.563.g4f69b47b94-goog

