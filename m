Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48998CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32CCB6B00E5; Thu,  7 May 2026 18:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCD56B00E6; Thu,  7 May 2026 18:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F30A6B00E7; Thu,  7 May 2026 18:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2336B00E5
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:56:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EB95140638
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:56:56 +0000 (UTC)
X-FDA: 84742135632.01.8846144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D96C61A0004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:56:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWRvLF1M;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778194614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgZh2hKTOm1z9T8yI8NCNBhkeFcRl1EMSvwwsaEx3GU=;
	b=YXpl/0vHajLrI4iDT3buQ7V3PrBNI+EAZDYOpBrevzWQuSt3SdoG1fofg9aSWKeYiR+r03
	LOXTH0oaWDJ9adh7igaVXxsyvUpDLesgyyeUrJgBz+gPx18qBvD2G6P3Ftr4SYHGbOBZYk
	lHbDyAB9zhRmUd1lySHtN1bCLASzoNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778194614; a=rsa-sha256;
	cv=none;
	b=gx3NideJRq/dPOOgjvmZoX6JmOuIEfqh6LtDFiUGKytK/cvH0HjQ7paK/OogIUIMOJ/pYp
	jeZDFl2wbHJHe3k1EwXaTpNemiXrffR4n8lvQdekkXohqkGXqmmLcVSDF7ZdqYiqjMM4ul
	Xxnz3a5uHyuZam4VdSdK7dOP932/fGk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWRvLF1M;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3717A60181;
	Thu,  7 May 2026 22:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A56C2BCB2;
	Thu,  7 May 2026 22:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778194613;
	bh=TnN/p2pnrI8ykyd5PWac+TWYJgt6p+yj+9CxJJm8xoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KWRvLF1MJF6ryQ4WTtpODsGPa/oRYen6vVh3cq/6vRARvX2mqP90ztD1CfqrRlZne
	 rJsBKjryno7yUmISyiEX90zqib23YRw0NQHsMRYmXDdcRDtDIj0PvyNePSSPtIpIOE
	 c8bV/56SrC0AnOVyC8rn/iOa5Xe0YT/quqGa9OX0uc7oOymX763n1Og7QZ+co3Ym1L
	 AecDHYC0rzKzY4Av4eiY5fBpnA8gWCNRphuMPxRAYz8xp9A7gufP9+G5qkhnQWSus4
	 fijp19qtlK04RK4ulfJK76kWAYt6c5Ba7f7D7cjJdc/o6BfTHylCW22VZbwVUYSMHE
	 ow38pnkX7sJJQ==
Date: Thu, 7 May 2026 15:56:52 -0700
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Richard Chang <richardycc@google.com>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com,
	liumartin@google.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: fix use-after-free in zram_writeback_endio
Message-ID: <af0YtJOLGvO-LJow@google.com>
References: <20260504123230.3833765-1-richardycc@google.com>
 <afoc5qLvK2PDQKb-@google.com>
 <afw2919RiZje9xzq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afw2919RiZje9xzq@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D96C61A0004
X-Stat-Signature: 5roygenfd1yikf6d6ucciczucgoz3ob1
X-Rspam-User: 
X-HE-Tag: 1778194614-809012
X-HE-Meta: U2FsdGVkX18d94FLH2gesx2ZUiL0cKtpWy7BCQnG4HuQTovAk98bad75rYLKtwkOa4yQ8eKWWbvB9/ATRx2DcUSTJLgAu+LlsJaUKzFWDTS1CXL/YJs4FO68R0P7TJI4f/jrB+96ouWI9O38AqVGt3B/ipVyQODVY1al+O9TfFDHo2fwPMp2OJFwmRCIg6CdQi8QXHw04WxZB2d4LtGqscDzmm7pVpnhq9qWEfL8RPZfpCDUkBzeLftQfYGQlTXHle1i7/gxcpJhueHBGDHr9BJ2C5B6T48crKXUAX2O8RQYrvk28nOvQ3uCBkFW6DnOgjCT7qrzQIeWNR2ty1tcFYim5Gzbc7bwLr0h1xr3qQkplHXSEeRDAcGgykAijSPS+B4+Oso/Y051D+7u2CXVH6oj7uk0i0YwXEv78Ey+nf5AvNZQDNYVYZCEbV6B6Ke9fey01a8XQq/502vr4EUn7i0Ty9mdh9V5JsJl62/uYTvMGDnf8AUr9cWqiXuec9US9u4Yzqv5/u2P3yhWsn5PMlk5Aq9B8H4Gbxn7wdmRaBZu1pFKJ0gkFkEmgvMdfDxA8fkgR86Mr7UiEt3dDZTj/otzfxmxEg3JH+GZfYCW3V5bk7Au+ZsByEGdpTTMD0SCn7bYzznqNIduAGB8vSm+w7eh7Ypq/+/astXe4DAp1vFZwvEmAiiEE6aGh/clh3BFYs29O9pUQ4ANkktAhtOaM4FvG/Y8ovLVZayOzgdunBgd40VwEXU+CWcjcSjdm1aZpnZvQR5kSve0vEgAFa5NOmKNQJ7s55WM6RgANvaZJjCCzAO4qJFELOv7X7nSmuNgZBdvR6mOkL41u36X5Pj8TkkSRcWjlNsIcgOuG+FuWAWjYim8kpu4Pgqyft0kjqzE77O8O0mbKWIDhf1yQU30cy6et1Mabie5EVuf3Xws0/BO7x1JlVg8ou0AJZJ/hGHCZqb3FV49c2FlcVU/qrK
 SFyL1LmN
 nH8pRDM+xN5nt2OTfe/hsei4YH68BEsnMxNM9J+jVgr90cdebB1vqaLthCzUZ2K7sFO3oJWu4XjWwCOoflL10ekbRg1S8CzwhZFs2ltwrlW4/rUE+v98qGnbfX54itv3c6HdYPYKVIzXwxW6JjJ0+X5NHVQj2JMN+qECtfwoQ5u9/LSKcync9HRsRVR8JIXOYJcO4hhhqDcxTQXVuOezJSaMeJDVGEHUUHrBXve1zbf66CSqC4FooGnXLcFtRCVPKtzb4BFoLbQEhDSFCulurmNHoF1dHxkwOXrAsygAlBt1fT3pU4HZfUXTQXZf1dALoWzrxG7xzg61Y7tA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 06:40:37PM +0900, Sergey Senozhatsky wrote:
> On (26/05/05 09:37), Minchan Kim wrote:
> > > @@ -966,9 +966,8 @@ static void zram_writeback_endio(struct bio *bio)
> > >
> > >  	spin_lock_irqsave(&wb_ctl->done_lock, flags);
> > >  	list_add(&req->entry, &wb_ctl->done_reqs);
> > > -	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> > > -
> > >  	wake_up(&wb_ctl->done_wait);
> > > +	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> > >  }
> > >
> >
> > I agree this will fix the issue, but using a lock to extend the lifetime of
> > an object to avoid a UAF is not a good pattern. Object lifetime shared between
> > process and interrupt contexts should be managed explicitly using refcount.
> 
> ->num_inflight is a ref-counter, basically.  The problem is that
> completion is a two-step process, only one part of each is synchronized
> with the writeback context.  I honestly don't want to have two ref-counts:
> one for requests pending zram completion and one for active endio contexts.
> Maybe we can repurpose num_inflight instead.

If it can make the code much clearer and simpler, I have no objection.

> 
> > Furthermore, keeping wake_up() outside the critical section minimizes
> > interrupt-disabled latency
> 
> So I considered that, but isn't endio already called from IRQ context?
> Just asking.  We wakeup only one waiter (writeback task), so it's not
> that bad CPU-cycles wise.  Do you think it's really a concern?

I don't think it will have any measurable impact; I was just pointing out
a theoretical one.

> 
> wake_up() under spin-lock solves the problem of a unsynchronized
> two-stages endio process.
> 
> > and avoids nesting spinlocks (done_lock -> done_wait.lock), reducing
> > the risk of future lockdep issues, just in case.
> 
> I considered lockdep as well but ruled it out as impossible scenario,
> nesting here is strictly uni-directional, we never call into zram from
> the scheduler.  Just saying.

Sure. I just prefer to avoid adding more lock dependencies without a strong
justification, to prevent potential locking issues in the future.

> 
> > It definitely will add more overhead for the submission/completion paths to deal
> > with the refcount, but I think we should go that way at the cost of runtime.
> 
> Dunno, something like below maybe?
> 
> ---
>  drivers/block/zram/zram_drv.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index ce2e1c79fc75..27fe50d666d7 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -967,7 +967,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
>  static void zram_writeback_endio(struct bio *bio)
>  {
>  	struct zram_wb_req *req = container_of(bio, struct zram_wb_req, bio);
> -	struct zram_wb_ctl *wb_ctl = bio->bi_private;
> +	struct zram_wb_ctl *wb_ctl = READ_ONCE(bio->bi_private);
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&wb_ctl->done_lock, flags);
> @@ -975,6 +975,7 @@ static void zram_writeback_endio(struct bio *bio)
>  	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
>  
>  	wake_up(&wb_ctl->done_wait);
> +	atomic_dec(&wb_ctl->num_inflight);
>  }
>  
>  static void zram_submit_wb_request(struct zram *zram,
> @@ -998,7 +999,7 @@ static int zram_complete_done_reqs(struct zram *zram,
>  	unsigned long flags;
>  	int ret = 0, err;
>  
> -	while (atomic_read(&wb_ctl->num_inflight) > 0) {
> +	for (;;) {
>  		spin_lock_irqsave(&wb_ctl->done_lock, flags);
>  		req = list_first_entry_or_null(&wb_ctl->done_reqs,
>  					       struct zram_wb_req, entry);
> @@ -1006,7 +1007,6 @@ static int zram_complete_done_reqs(struct zram *zram,
>  			list_del(&req->entry);
>  		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
>  
> -		/* ->num_inflight > 0 doesn't mean we have done requests */
>  		if (!req)
>  			break;
>  
> @@ -1014,7 +1014,6 @@ static int zram_complete_done_reqs(struct zram *zram,
>  		if (err)
>  			ret = err;
>  
> -		atomic_dec(&wb_ctl->num_inflight);
>  		release_pp_slot(zram, req->pps);
>  		req->pps = NULL;
>  
> @@ -1129,8 +1128,11 @@ static int zram_writeback_slots(struct zram *zram,
>  	if (req)
>  		release_wb_req(req);
>  
> -	while (atomic_read(&wb_ctl->num_inflight) > 0) {
> -		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
> +	while (atomic_read(&wb_ctl->num_inflight) ||
> +	       !list_empty(&wb_ctl->done_reqs)) {
> +		wait_event_timeout(wb_ctl->done_wait,
> +				   !list_empty(&wb_ctl->done_reqs),
> +				   HZ);
>  		err = zram_complete_done_reqs(zram, wb_ctl);
>  		if (err)
>  			ret = err;

I understand why you used a timeout here, but I still don't think it's a good
idea since the user could wait for up to a second unnecessarily during the
race.

What I prefer is simple and explicit lifetime management for wb_ctl using
refcount. It directly addresses the core issue (UAF of wb_ctl) in a standard,
robust way without needing workarounds like timeouts. The runtime overhead
of kref will be negligible.

Something like this:

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a324ede6206d..28ab4a24e77f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
 #include <linux/kernel_read_file.h>
+#include <linux/kref.h>
 
 #include "zram_drv.h"
 
@@ -504,6 +505,7 @@ struct zram_wb_ctl {
 	wait_queue_head_t done_wait;
 	spinlock_t done_lock;
 	atomic_t num_inflight;
+	struct kref kref;
 };
 
 struct zram_wb_req {
@@ -829,11 +831,8 @@ static void release_wb_req(struct zram_wb_req *req)
 	kfree(req);
 }
 
-static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
+static void __release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 {
-	if (!wb_ctl)
-		return;
-
 	/* We should never have inflight requests at this point */
 	WARN_ON(atomic_read(&wb_ctl->num_inflight));
 	WARN_ON(!list_empty(&wb_ctl->done_reqs));
@@ -850,6 +849,18 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 	kfree(wb_ctl);
 }
 
+static void release_wb_ctl_kref(struct kref *kref)
+{
+	struct zram_wb_ctl *wb_ctl = container_of(kref, struct zram_wb_ctl, kref);
+
+	__release_wb_ctl(wb_ctl);
+}
+
+static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
+{
+	kref_put(&wb_ctl->kref, release_wb_ctl_kref);
+}
+
 static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 {
 	struct zram_wb_ctl *wb_ctl;
@@ -864,6 +875,7 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 	atomic_set(&wb_ctl->num_inflight, 0);
 	init_waitqueue_head(&wb_ctl->done_wait);
 	spin_lock_init(&wb_ctl->done_lock);
+	kref_init(&wb_ctl->kref);
 
 	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
@@ -985,6 +997,7 @@ static void zram_writeback_endio(struct bio *bio)
 	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 
 	wake_up(&wb_ctl->done_wait);
+	kref_put(&wb_ctl->kref, release_wb_ctl_kref);
 }
 
 static void zram_submit_wb_request(struct zram *zram,
@@ -996,6 +1009,7 @@ static void zram_submit_wb_request(struct zram *zram,
 	 * so that we don't over-submit.
 	 */
 	zram_account_writeback_submit(zram);
+	kref_get(&wb_ctl->kref);
 	atomic_inc(&wb_ctl->num_inflight);
 	req->bio.bi_private = wb_ctl;
 	submit_bio(&req->bio);
@@ -1276,8 +1290,8 @@ static ssize_t writeback_store(struct device *dev,
 
 	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
-		ret = -ENOMEM;
-		goto out;
+		release_pp_ctl(zram, pp_ctl);
+		return -ENOMEM;
 	}
 
 	args = skip_spaces(buf);


