Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A67F9CD3445
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E686B6B00F3; Thu,  7 May 2026 19:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19966B00F4; Thu,  7 May 2026 19:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07466B00F5; Thu,  7 May 2026 19:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC5A66B00F3
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:39:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51EA540318
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:39:01 +0000 (UTC)
X-FDA: 84742241682.20.A203870
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C13E040007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:38:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZNOUwtp1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778197139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxOaCtDEyB8uhSntRFp/mcI2KTDn6mNddeAsgcXbG1M=;
	b=tjCWr6OY4GqdZISoLWBQl/LeBQBQ7wDMD9gccjhaKu6r7ErKw14BBHNDQel0MhSn8Ru8VK
	B/yMntSsbWY5X2Jq7yBSCsg+YBmF67Y5y6dVAfwFtTDxUuwc/1U9g/yWF3lfoJ/Zgfu5j/
	YxUqKq9udLi+6bxdZHBb5at9VtIsbJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778197139; a=rsa-sha256;
	cv=none;
	b=KhR+IRPlCVE3vFXKWo0rWpP+UWET/3fz258Mu8uhYeyNfzsrrAnSLpQp3P5kvSxMgBXBpY
	Hhk36VE4TMdnGzw4FQc2UNNHvOb/YXpojaVFgK8eaJv5rOEAYoPbg/+2b7cmUlz2sl9T3I
	ZxrMNUIfT9LtVKQYULpWAJYi+2iASX0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZNOUwtp1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17F386024D;
	Thu,  7 May 2026 23:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A2EC2BCB2;
	Thu,  7 May 2026 23:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778197138;
	bh=t/0r+a5SS9vq5VHgMQzgBaeM4k6BgPKTI7KxhCYwGEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZNOUwtp1CjdLv0dW22CWiHYQ8nzOLCE6vt/a9MS25dy/y1WSPCMXIoi/kvfeoUPPU
	 Dgl7GXzQOwQieo6+ohEcZ3RxtHQr+j4Ar36EkXKUSfcJFcsFBxkaT46GUZegGh4sg+
	 ep4LhqQWAWcasyUp7RuO5UaFLv8X87KbT2InaXuw+IcBONk1CSqwksKZ4sj7YHDARd
	 246mYPy4ts9uMyBdCY5JOdsa4mXshLsJuRxl8G2R6FJscgxsorwqXIH+2eIV+aw4B5
	 E2ekS9/cA0mK4MVIa5iA0++dyCVMdmxxem+oEcL1U/8skkkqexmEEOPNM17pSU/8S7
	 FoSzfUm7Kb/3Q==
Date: Thu, 7 May 2026 16:38:57 -0700
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Richard Chang <richardycc@google.com>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com,
	liumartin@google.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: fix use-after-free in zram_writeback_endio
Message-ID: <af0ikdGzrjLzrZl3@google.com>
References: <20260504123230.3833765-1-richardycc@google.com>
 <afoc5qLvK2PDQKb-@google.com>
 <afw2919RiZje9xzq@google.com>
 <af0YtJOLGvO-LJow@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af0YtJOLGvO-LJow@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C13E040007
X-Stat-Signature: e51b9o7bupijfq87of6sgxbz1oajnitj
X-Rspam-User: 
X-HE-Tag: 1778197139-411307
X-HE-Meta: U2FsdGVkX19i9TEjk4QBWOG3b3GKnwfb6AJc0jPEH4aaSu6gxxX8jWlmly326YpPIi5TOKjhS6zeApA8acglQ2QSLP8TBB5X8CaK2MEerfpXtNZDaLrRCccuchbvDWb95UaXTX0AJsHXxfhqKUOOGRZ4JcechXIc8hM4ksh2vDwdoq7+wpdVDJ8Lj0M/beL05B2Zrgq3Av9+JkxFUh7dO/lPTPHQtH3xd6IxZemTnX0I5qblECWFO4ILXqhS9M4Hk7OLfSbBR3QD3xZMEssFZxxf341bBLzqxJPTSgrG4EutM+DboFfTZZt40A91IiUH8fLMZ+bgdfUF/J7m4L8LOAMxnr8lnInlxEq1i7ogJL3GWnVrxLwSZD1LcStEmLgh2BzbagN48diVM0KT1B9ullk796BhjsKpRps9nl0/HC0p43rCI1rzG1FiIIwfDewy1nCR59QtMStWf84gqenhxQ7VqXW4DyrGKjHmK/gsBTGK9pzZXKl6/WI9NhqMp9vNTOK6090N5J4uv4hR0Fie/4zEfQGsFgrLdw3ZV/kSBlmvRXtyl4ilsCMAqgXiaXylMuOHRQRprY5t/82VZOJtZ3IQSYyit+Exfd62HWjuro22CGfQt0966fWNfg1j5JSxlFT1v73b6fXFaJyfrkhnHYyT9cwiBhSvzoJpTiTyNyQ46QvO20gcGTNLIcwQDF6nEaF8XJJNy5t52dc0/hVlZgNkSgRwunRWP0tmL2YMlVtZRI1BjhhZlS4EPoQw+NEHj+rSO68WMXC38D9jQV7icIFjuTbJlNkdBsdJmMZrEolfMQarkZE/lNALmvQEbo3P7PfEp9DkMw/tmLeKE5rXjYrZdaXKMMBwGrGISYFhoWu34ZTiBaVpYZoPy+sDLzwLGs1nsi0WzwhXuue5BNei7gTyllSb8il4JoZ8B+akN7Ots/O/nrVr6/6z1n7qMopOdNoE4TaWQntMGjPFzQa
 156JWywp
 rmkD9oKryO/q3+1359vMW36U/vSLOaXpqRYf/rYQAY/8gmWOsVfHXxaFxW5CtBqCDG+2jlBNpklA0umaXh8gu1jclpHkqAI6TAmaL6n0hadLbm929d2qVWIQyf/1Oiqp4N1NnALZXQN63CVjXqadBzfhOk1pj4SpQPXyhSFtVDnFnqUhi+YXfhsiFKIcmeCda6rPJ/3lT+cJ5H6Yb1hfBsVXz3+Lx6ysAB0Nv9/w8aVJi9fxJ4t9n9r+NgHgArl9AFH6g2TsZIXwnhWmUuLXKtzesieGC+FAdVI2a1V14Ug0TlBbhxH1xUkgw15g7uQzWKAGyEhr9ruSZT6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 03:56:52PM -0700, Minchan Kim wrote:
> On Thu, May 07, 2026 at 06:40:37PM +0900, Sergey Senozhatsky wrote:
> > On (26/05/05 09:37), Minchan Kim wrote:
> > > > @@ -966,9 +966,8 @@ static void zram_writeback_endio(struct bio *bio)
> > > >
> > > >  	spin_lock_irqsave(&wb_ctl->done_lock, flags);
> > > >  	list_add(&req->entry, &wb_ctl->done_reqs);
> > > > -	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> > > > -
> > > >  	wake_up(&wb_ctl->done_wait);
> > > > +	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> > > >  }
> > > >
> > >
> > > I agree this will fix the issue, but using a lock to extend the lifetime of
> > > an object to avoid a UAF is not a good pattern. Object lifetime shared between
> > > process and interrupt contexts should be managed explicitly using refcount.
> > 
> > ->num_inflight is a ref-counter, basically.  The problem is that
> > completion is a two-step process, only one part of each is synchronized
> > with the writeback context.  I honestly don't want to have two ref-counts:
> > one for requests pending zram completion and one for active endio contexts.
> > Maybe we can repurpose num_inflight instead.
> 
> If it can make the code much clearer and simpler, I have no objection.
> 
> > 
> > > Furthermore, keeping wake_up() outside the critical section minimizes
> > > interrupt-disabled latency
> > 
> > So I considered that, but isn't endio already called from IRQ context?
> > Just asking.  We wakeup only one waiter (writeback task), so it's not
> > that bad CPU-cycles wise.  Do you think it's really a concern?
> 
> I don't think it will have any measurable impact; I was just pointing out
> a theoretical one.
> 
> > 
> > wake_up() under spin-lock solves the problem of a unsynchronized
> > two-stages endio process.
> > 
> > > and avoids nesting spinlocks (done_lock -> done_wait.lock), reducing
> > > the risk of future lockdep issues, just in case.
> > 
> > I considered lockdep as well but ruled it out as impossible scenario,
> > nesting here is strictly uni-directional, we never call into zram from
> > the scheduler.  Just saying.
> 
> Sure. I just prefer to avoid adding more lock dependencies without a strong
> justification, to prevent potential locking issues in the future.
> 
> > 
> > > It definitely will add more overhead for the submission/completion paths to deal
> > > with the refcount, but I think we should go that way at the cost of runtime.
> > 
> > Dunno, something like below maybe?
> > 
> > ---
> >  drivers/block/zram/zram_drv.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index ce2e1c79fc75..27fe50d666d7 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -967,7 +967,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
> >  static void zram_writeback_endio(struct bio *bio)
> >  {
> >  	struct zram_wb_req *req = container_of(bio, struct zram_wb_req, bio);
> > -	struct zram_wb_ctl *wb_ctl = bio->bi_private;
> > +	struct zram_wb_ctl *wb_ctl = READ_ONCE(bio->bi_private);
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(&wb_ctl->done_lock, flags);
> > @@ -975,6 +975,7 @@ static void zram_writeback_endio(struct bio *bio)
> >  	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> >  
> >  	wake_up(&wb_ctl->done_wait);
> > +	atomic_dec(&wb_ctl->num_inflight);
> >  }
> >  
> >  static void zram_submit_wb_request(struct zram *zram,
> > @@ -998,7 +999,7 @@ static int zram_complete_done_reqs(struct zram *zram,
> >  	unsigned long flags;
> >  	int ret = 0, err;
> >  
> > -	while (atomic_read(&wb_ctl->num_inflight) > 0) {
> > +	for (;;) {
> >  		spin_lock_irqsave(&wb_ctl->done_lock, flags);
> >  		req = list_first_entry_or_null(&wb_ctl->done_reqs,
> >  					       struct zram_wb_req, entry);
> > @@ -1006,7 +1007,6 @@ static int zram_complete_done_reqs(struct zram *zram,
> >  			list_del(&req->entry);
> >  		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> >  
> > -		/* ->num_inflight > 0 doesn't mean we have done requests */
> >  		if (!req)
> >  			break;
> >  
> > @@ -1014,7 +1014,6 @@ static int zram_complete_done_reqs(struct zram *zram,
> >  		if (err)
> >  			ret = err;
> >  
> > -		atomic_dec(&wb_ctl->num_inflight);
> >  		release_pp_slot(zram, req->pps);
> >  		req->pps = NULL;
> >  
> > @@ -1129,8 +1128,11 @@ static int zram_writeback_slots(struct zram *zram,
> >  	if (req)
> >  		release_wb_req(req);
> >  
> > -	while (atomic_read(&wb_ctl->num_inflight) > 0) {
> > -		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
> > +	while (atomic_read(&wb_ctl->num_inflight) ||
> > +	       !list_empty(&wb_ctl->done_reqs)) {
> > +		wait_event_timeout(wb_ctl->done_wait,
> > +				   !list_empty(&wb_ctl->done_reqs),
> > +				   HZ);
> >  		err = zram_complete_done_reqs(zram, wb_ctl);
> >  		if (err)
> >  			ret = err;
> 
> I understand why you used a timeout here, but I still don't think it's a good
> idea since the user could wait for up to a second unnecessarily during the
> race.
> 
> What I prefer is simple and explicit lifetime management for wb_ctl using
> refcount. It directly addresses the core issue (UAF of wb_ctl) in a standard,
> robust way without needing workarounds like timeouts. The runtime overhead
> of kref will be negligible.
> 

The other standard way to deal with lifetime is RCU.
How about this?

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a324ede6206d..28ab4a24e77f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
 #include <linux/kernel_read_file.h>
+#include <linux/rcupdate.h>
 
 #include "zram_drv.h"
 
@@ -504,6 +505,7 @@ struct zram_wb_ctl {
 	wait_queue_head_t done_wait;
 	spinlock_t done_lock;
 	atomic_t num_inflight;
+	struct rcu_head rcu;
 };
 
 struct zram_wb_req {
@@ -829,14 +831,8 @@ static void release_wb_req(struct zram_wb_req *req)
 	kfree(req);
 }
 
 static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 {
-	if (!wb_ctl)
-		return;
-
 	/* We should never have inflight requests at this point */
 	WARN_ON(atomic_read(&wb_ctl->num_inflight));
 	WARN_ON(!list_empty(&wb_ctl->done_reqs));
@@ -850,7 +849,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 		release_wb_req(req);
 	}
 
-	kfree(wb_ctl);
+	kfree_rcu(wb_ctl, rcu);
 }
 
 static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
@@ -985,6 +997,7 @@ static void zram_writeback_endio(struct bio *bio)
 	struct zram_wb_ctl *wb_ctl = bio->bi_private;
 	unsigned long flags;
 
+	rcu_read_lock();
 	spin_lock_irqsave(&wb_ctl->done_lock, flags);
 	list_add(&req->entry, &wb_ctl->done_reqs);
 	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
@@ -991,5 +1004,6 @@ static void zram_writeback_endio(struct bio *bio)
 
 	wake_up(&wb_ctl->done_wait);
+	rcu_read_unlock();
 }
 
 static void zram_submit_wb_request(struct zram *zram,
@@ -1276,8 +1290,8 @@ static ssize_t writeback_store(struct device *dev,
 
 	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
-		ret = -ENOMEM;
-		goto out;
+		release_pp_ctl(zram, pp_ctl);
+		return -ENOMEM;
 	}
 
 	args = skip_spaces(buf);

