Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8573109C05D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18EE86B0088; Wed, 25 Mar 2026 16:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FBC6B0089; Wed, 25 Mar 2026 16:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056786B008A; Wed, 25 Mar 2026 16:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E885D6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:26:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B4C75BA99
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:26:40 +0000 (UTC)
X-FDA: 84585718560.20.3C5EAEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D0AAB20002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:26:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uD5iE6Sj;
	spf=pass (imf03.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774470399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVJ3eZgqE/AC5KtSkn3uMydjBYBtwn4S3cMw8+uNFXw=;
	b=eTWUdM/+XCdXdnv3SfZsdbbDYKd7iptzfInX/2VR4hfjYvfp/EI8xTmlOG1bEioqd2YKKw
	jgbzMZ8M9d7SB1GZQUFXZmSd9SgfORWXFGW9NXhKLKGgm90jhxiATtms5oIMNPSpcBiL3p
	6jmIz/2rIyyWGzo3MZOp1YYa/ZKmAu0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uD5iE6Sj;
	spf=pass (imf03.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774470399; a=rsa-sha256;
	cv=none;
	b=A3yVdfjzDmVc+CFF2E07lyEe0XsR89tQ/JawqkOyH/PUBZStBV4Kx7awO4jo5dhtmajVSe
	bEfdUc2qv9krJh2RXxmNzUJ3/GCFqDFUkzioNR7pM8eF+sOfFAj+NoWNCUEesLPOFOIn5h
	4TZFH/scrij3dA4J5Iq5xpRImqw2HrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C296B436A6;
	Wed, 25 Mar 2026 20:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A580C4CEF7;
	Wed, 25 Mar 2026 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774470397;
	bh=9288nGTYu2PySycaWl6yYADhv0GQ8SwE+yNWJslpqHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uD5iE6SjH9WPG+cYdKim6O8OR5sTVTPtHq+SWQB0fE4gy6fDWyg5VERw0RBdt39LV
	 feFpMZN1GedzzBxHW87hlZwsy58LhN9KHpA7Hi/redu99FWpLsM8Qz0G8n7RoUxtJy
	 rvE05dlBbG52qcahxGlHOP2GbjiPMYmYtSO5mjD+9M+LCiWmI40IaZTFIwkz2n0STL
	 oTdKL6dI8ne31KxPI53rWozgN7njx3Fyl29r6+ZDEwUXQ01S4y+HaaQb1ArdGSUB1K
	 dsf23HhFH2v+p1HleKK4oWqgDxumGfqfutXLzuzwOQmmIuZTa7igIt6uOpGTY9th0v
	 lHK4BJH35ihKw==
Date: Thu, 26 Mar 2026 07:26:26 +1100
From: Dave Chinner <dgc@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acRE8pp6HxjK7Z74@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
X-Rspam-User: 
X-Stat-Signature: mhk1jbionbu4z5dp6xjaiwhqitr8sjbr
X-Rspamd-Queue-Id: D0AAB20002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774470398-608359
X-HE-Meta: U2FsdGVkX1/Ts4bnaoK8KC2s/Iu7+QEMGpBAbIevScj/G/xqyPCeM6icVdE+R8uPqOzZoo4nZBK4TllG1pybLMMkn/ZGUIdZe300/hWxw4lxOllIdnGuINxZL8CY1TCjiEVBtC4loXgAte0plL20CC0TTrYTFpofl3GF2AcQX+2c6o5arg16xK1nbdo2NQpyt+FF8etNabmZ+D4E2FKMEJ2dMPRwOYwzz0eN161FGOSJwFBi7N/xBG/jS83Q8Z0496beC3m9aqX3CW8/XSseX1YknzaiVXWMeV3qhgGE3MrdGiE7+ouheMP+k2TohBvM84W1dzcXsUigG2tnbJr+lI6odDHvWHklEqZnIdAO7bNG6GinCcEkddVIyNPWTkIYmQrn/jCP2q8YH0rhKzrIN7vFS6+MG1G5ekG2jTGILwP7Tpvhbqth44Gzo9S4B7V2QfmeTRQODLRUrZBZ51mnqc8RRNdmQOagwBuUMR9qZKTig/skbxR9z97p10JJNasGE3n7TlzqMgOnoyme+/r+zm0HnuoEpJSgWUV1P6+ASFSkMa5WInS+fYbGnfNF3stx89L1HSTuI5O0GMl+O5X+Ddeg42ANcWG3rgbb4GXmZWYdLW26/U/a7GJsoLHHLUafAa9Wbp09BTYJLfFIybhDjfZ7V/l5Y6FnhDjaewsraVc3BCXiua+c0A/O4NLZ9hrefb59W1aqLylgItw0OGZTJPdPMbrGcPUOIp2xpcAQB3YOcWWIKzofdmVQa9wHOluMZDOOtbyh6hGMfTSvZhl8AZwep/RFavLJnte7VkwSnVeIiIt8EJXH5VX33k6/EIeBtdzcCYEuIFe88kG07CW7PeH2Bf1E33lJodAL6yv4UrZkCv06xCqukHhFGEWDT/VApxHzgiCZI0+fC4bC4JkM2pZoUECnNc3tLij4q3Bc+Q9iB+kuav9AHjiKNzfPmsKC4FhRqElWN5quB8c8jKk
 BiGHVp28
 4SueChjxyBbAfaU5fE6GHud7VSPIMcY8Y18OFyb4UhOnaiVgxQug2oNqsDsh9GjUZhlyelt3NWva4laDsIvXzuKfgPb1FEmJlcBqkXrDo00yfDwW6EtVsAxP2cCKB9+b8Iwn4kO+JQ4B2mxeoIRkRVPxjnlb7fduf0ZBKgLa8xHM5XkJkrmLyMYk5hlL8hGcLx7/Uy4qCzoAHET2ChtGBGwsJp2rSDPKnGoXYgKYfd2FqzIQYfeBJZkpNPPcw6YNafrz7SGo2oo0RqxuzJvS9PTmaqT8eoMnnY0njvc1qV/DnCqfUTHqzj5RVRdbLdFi5qkelFQYJP4YmrvUfuxecT6zizA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:43:00PM -0400, Tal Zussman wrote:
> Some bio completion handlers need to run in task context but bio_endio()
> can be called from IRQ context (e.g. buffer_head writeback). Add a
> BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
> task-context completion of their bi_end_io callback.
> 
> When bio_endio() sees this flag and is running in non-task context, it
> queues the bio to a per-cpu list and schedules a work item to call
> bi_end_io() from task context. A CPU hotplug dead callback drains any
> remaining bios from the departing CPU's batch.
> 
> This will be used to enable RWF_DONTCACHE for block devices, and could
> be used for other subsystems like fscrypt that need task-context bio
> completion.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  block/bio.c               | 84 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/blk_types.h |  1 +
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 8203bb7455a9..69ee0d93041f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -18,6 +18,7 @@
>  #include <linux/highmem.h>
>  #include <linux/blk-crypto.h>
>  #include <linux/xarray.h>
> +#include <linux/local_lock.h>
>  
>  #include <trace/events/block.h>
>  #include "blk.h"
> @@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
>  }
>  EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
>  
> +struct bio_complete_batch {
> +	local_lock_t lock;
> +	struct bio_list list;
> +	struct work_struct work;
> +};
> +
> +static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
> +	.lock = INIT_LOCAL_LOCK(lock),
> +};
> +
> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct bio_complete_batch *batch;
> +	struct bio_list list;
> +
> +again:
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	list = batch->list;
> +	bio_list_init(&batch->list);
> +	local_unlock_irq(&bio_complete_batch.lock);

This is just a FIFO processing queue, and it is so wanting to be a
struct llist for lockless queuing and dequeueing.

We do this lockless per-cpu queue + per-cpu workqueue in XFS for
background inode GC processing. See struct xfs_inodegc and all the
xfs_inodegc_*() functions - it may be useful to have a generic
lockless per-cpu queue processing so we don't keep open coding this
repeating pattern everywhere.

> +
> +	while (!bio_list_empty(&list)) {
> +		struct bio *bio = bio_list_pop(&list);
> +		bio->bi_end_io(bio);
> +	}
> +
> +	local_lock_irq(&bio_complete_batch.lock);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	if (!bio_list_empty(&batch->list)) {
> +		local_unlock_irq(&bio_complete_batch.lock);
> +
> +		if (!need_resched())
> +			goto again;
> +
> +		schedule_work_on(smp_processor_id(), &batch->work);

We've learnt that immediately scheduling per-cpu batch
processing work can cause context switch storms as the queue/dequeue
steps one work item at a time.

Hence we use a delayed work with a scheduling delay of a singel
jiffie to allow batches of queue work from a single context to
complete before (potentially) being pre-empted by the per-cpu
kworker task that will process the queue...

> +		return;
> +	}
> +	local_unlock_irq(&bio_complete_batch.lock);
> +}
> +
> +static void bio_queue_completion(struct bio *bio)
> +{
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +
> +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	bio_list_add(&batch->list, bio);
> +	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
> +
> +	schedule_work_on(smp_processor_id(), &batch->work);
> +}

Yeah, we definitely want to queue all the pending bio completions
the interrupt is delivering before we run the batch processing...

> +
>  static inline bool bio_remaining_done(struct bio *bio)
>  {
>  	/*
> @@ -1788,7 +1843,9 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (bio->bi_end_io)
> +	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> +		bio_queue_completion(bio);
> +	else if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
>  EXPORT_SYMBOL(bio_endio);
> @@ -1974,6 +2031,21 @@ int bioset_init(struct bio_set *bs,
>  }
>  EXPORT_SYMBOL(bioset_init);
>  
> +/*
> + * Drain a dead CPU's deferred bio completions. The CPU is dead so no locking
> + * is needed -- no new bios will be queued to it.
> + */
> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&batch->list)))
> +		bio->bi_end_io(bio);
> +
> +	return 0;
> +}

If you use a llist for the queue, this code is no different to the
normal processing work.

> +
>  static int __init init_bio(void)
>  {
>  	int i;
> @@ -1988,6 +2060,16 @@ static int __init init_bio(void)
>  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>  	}
>  
> +	for_each_possible_cpu(i) {
> +		struct bio_complete_batch *batch =
> +			per_cpu_ptr(&bio_complete_batch, i);
> +
> +		bio_list_init(&batch->list);
> +		INIT_WORK(&batch->work, bio_complete_work_fn);
> +	}
> +
> +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
> +				NULL, bio_complete_batch_cpu_dead);

XFS inodegc tracks the CPUs with work queued via a cpumask and
iterates the CPU mask for "all CPU" iteration scans. This avoids the
need for CPU hotplug integration...

>  	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
>  					bio_cpu_dead);
>  
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..d49d97a050d0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -322,6 +322,7 @@ enum {
>  	BIO_REMAPPED,
>  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */

Can anyone set this on a bio they submit? i.e. This needs a better
description. Who can use it, constraints, guarantees, etc.

I ask, because the higher filesystem layers often know at submission
time that we need task based IO completion. If we can tell the bio
we are submitting that it needs task completion and have the block
layer guarantee that the ->end_io completion only ever runs in task
context, then we can get rid of mulitple instances of IO completion
deferal to task context in filesystem code (e.g. iomap - for both
buffered and direct IO, xfs buffer cache write completions, etc).

-Dave.
-- 
Dave Chinner
dgc@kernel.org

