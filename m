Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C020ACD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4CD46B0093; Mon, 25 May 2026 01:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6876B0095; Mon, 25 May 2026 01:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E2B6B0096; Mon, 25 May 2026 01:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B23326B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:24:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 791A01C0136
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:24:37 +0000 (UTC)
X-FDA: 84804802194.27.FFFC564
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id E0BF9180003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:24:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Rt95io/l";
	spf=none (imf16.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779686675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=F+qcx171PO0iY44USb9zp7y86yRvqPfz1FP7DjlNcFg=;
	b=5unbcYfUNxltcidM+TMgREdTdduOB1JDjaDIRX5nhJ8zOdmp1kF5FgMXCowMBAfM+Quuoy
	S/1arFNBbLAL/NhlwgtL/apfsR60NepUWAlAzY+QnXxytsw22kWFzOWCpOaCO3oFloKxTu
	ra2qYD3cOYqT3d5dHWyOQcmtwG4IOXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779686675; a=rsa-sha256;
	cv=none;
	b=vu+bFP6ZPtoO1pLMJSj1fGVrW5pgBfXAR23WwZCPYr7fNchp5MTOgW9yfLv7iEm+k3/YnE
	1e1+oj+ILz/Rk7N3JEXqWP8VmB9+BjY9gYRbN864ogFdI7Mqx9pHfjMIc1tfYlz5rdzwtA
	mI00Ue/T4Bk4h6NzU+PsDIwbwy+NTlM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Rt95io/l";
	spf=none (imf16.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=F+qcx171PO0iY44USb9zp7y86yRvqPfz1FP7DjlNcFg=; b=Rt95io/lcfqcGRpo6czeBwHio9
	pVjQgDqUXSWgaqWn03gbxnKW5IUsmly2MGIC/fJ4G7eulQgYIaBn1xTPRq+W1IjFrgWC7pY+mLsQN
	4Ub3I59Ib67qY30TB1t+q9Rx2D2t9VQTwmz/y6kwJP2aGmlMk4s/aKbESqKYzAM9bDSZO5+8vg6m5
	RKD6guac98ljA4y9c84c5BCt7TTgVEDAY1+F/r1vvoteXW9m5F6qIYTD+/d35A05w4CVQL/DYGMTR
	IRXDvPvHQtfZbcgHko93BD7Gp7NXBY/6Yf0JIFdW/3r/YPPp3l0UlRV4LaPz8v3E9BQFfMZn7aKDC
	JE+JaPEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNni-0000000GJk7-316n;
	Mon, 25 May 2026 05:24:30 +0000
Date: Sun, 24 May 2026 22:24:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ahPdDtu3vXfNpb__@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea6fc01f-5cb7-4a04-9f92-bbd2791fea51@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Stat-Signature: fswznchfubmdedhq63c18ent3nbewzug
X-Rspamd-Queue-Id: E0BF9180003
X-Rspam-User: 
X-HE-Tag: 1779686675-257969
X-HE-Meta: U2FsdGVkX1+80pgF9sT7WnKDeftS21fgjP6KIEopGpJQcQWr4A3ULMChZ8BG4k+fj85Dd1b5PGsUHsEDK5APnk0jZoR/Me+apFlq2ENn+fXq7NbdRw2cJPuiE7hKzATicOi2XmwTjc/P0IPAs1Bbv0SxQYktE4AcCJAGxsJszUL0YQTpdKRf+ycNVEJviH2wjW+r2rJIHV9ZyXaLUwrf1i2SNS3SSC3fdFt/w2yjjTBpUhplJ17pIlHy2s82Wu808c6kJSp53U+8Do7UJy8dorNCLelm+qan0/kvW3hKt2UESI1dIpPCgzVNvM6iMEkKHLVqa8GktQFCRkjUlTDVSham40AFBU3gCnf5AsCnsoNuxn1Eyp6dpUiCdf7bb7o2x7sYDVSp6GeEySRXThkTyeIivr5UgM2USZqJyWTnWA7l2ywJ9TIoyBxw6ajmtmKIV/GUeFj0fgBD2DZY1AYT/avU7bghRT+Cb/LiqVKrxXrnVGBtd8M0P7KWiLM9t4nhJzrwL6zKvkOJ/uBcSdnwGo+qY0nGpeGAdR4pOMkX28se96vMLjyWDGzt9XijMLFk919AuidrUzizsvfqMkJLDO+hvNcwIXDjqtrz0khJA8b3rUhOJgtwfETycEKQ9PW8spy2trf+Nz4qu26t2PMfCbAnVCUJKx/Bu+5LgYhnwNCU2NXWo6gRx97UrqBqHPrPoZwFKtpe+3BJ7Ev0mVMTJLJGhdfWnqGkizdjzyraNJhBtAZihoY9XG3nr3khFuVDfvNCjOdExAFIfQT2Bls4r4vZmnQ3JoH29tQhJaugc3Ev71PXKrWvU80m+K1FqcHKCfe3hupX5LLU4QH1UVkqpfeCZGHOIpGZsFfEWZ2iRKM4nV+aEql3sRN7jif6GwqY0zLbFaIcMHUvBIqydSuxmH8gjzS6HFg1x25F02zGwDjBXcgJoN52apq37qMIKpNeOJj4sKmF4ycr9p/Gwxj
 YzUAT3Dh
 /+D0+IEjwGx13AMDaMqCCpqL+h6ZMonretchR8oBtfp7jJMg+sfavxG0lYVBbmXeMFPvsKUGXP2iNgdcQN8NkKiU0QYF8t0CeNvrDBadSfg+RPAqMsElfQATSNlQBYDilUKAoPtlgP50SMtmwq3kTpRaOwl2yVGnGAJiTl9C0Sc/7jPhoz6jFkCF/MzsRlhGDddhA66066gg6WVOln+gYa+ciuzP7EVYB5BJSFTzFHXBvu8phsRG8h7VzIsKOL8+6GCiJDGjlp3wiG2znq6FBboopXnfrVZbNQcChsBXWNJoaXam9pq+l4iXrC2HjVgSWgIIQNrP3zfIUKUlpzE+5n9/Te0b7ICc4uFx6NVvfV3YJdC4aZb33leBxNAQ+3ZGu9aeBHhUB7w/C1jT0p2Dl03pThJ4Ovz2MhJjN3iLUp+MWZU88KFrHq0Bsb5787zUCxgk6MJGXoRpiBzFVoWEjKKvSKCCUz9ghDCVUWY9NEcpLb5cHA1LENpQclQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[adding the PREEMPT-RT maintainers and list for one and a half questions
for them a bit below]

On Fri, May 22, 2026 at 07:09:59PM -0400, Tal Zussman wrote:
> > +		while ((bio = bio_list_pop(&list)))
> > +			bio->bi_end_io(bio);
> 
> Q: "Does this code handle bios that do not have a completion callback?
> If a bio is submitted with the BIO_COMPLETE_IN_TASK flag but has a NULL
> bi_end_io pointer (like some flush or discard bios), executing
> bio->bi_end_io(bio) directly will cause a NULL pointer dereference.
> The synchronous completion path in bio_endio() checks if bio->bi_end_io is
> non-NULL before calling it. Should a similar check be added here?"
> 
> A: Every bio that reaches this point should have bi_end_io set. There's no
> point in deferring a bio without a completion handler.

Yes.  The only bios without bi_end_io that can end up in bio_endio
are those attached to passthrough requests, and deferring them of
course doesn't make sense.

> Q: "Could this loop also monopolize the CPU and cause latency spikes?
> Because the work uses a 1-jiffie delay, tens of thousands of bios might
> accumulate under heavy I/O load. Processing the entire batch sequentially
> without yielding or calling cond_resched() inside the inner loop could
> lead to scheduler latency or watchdog warnings on non-preemptible kernels."
> 
> A: With PREEMPT_LAZY as the default, the worker is preemptible, as per 
> Hillf and Christoph, so this is unnecessary.

Yes.  Sashiko tends to spew this a lot, which is odd as there were clear
recommendations to only do this absolutely if needed even before
PREEMPT_LAZY.

> > +
> > +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> 
> Q: "Is it safe to use local_lock_irqsave() here when called from an atomic
> context?
> On CONFIG_PREEMPT_RT kernels, local_lock_t maps to a per-CPU spinlock_t,
> which is a sleepable rt_mutex. Since __bio_complete_in_task() is specifically
> called when bio_in_atomic() is true (which includes hardware interrupts or
> execution under a raw_spinlock_t), attempting to acquire a sleepable lock
> here would trigger an "Invalid wait context" lockdep warning.
> Would a lockless list (llist) be more appropriate here to avoid sleeping
> in atomic contexts?"
> 
> A: This seems legit, but I'm not super familiar with PREEMPT_RT. I don't want
> to switch to raw_spinlock_t, as it seems like that would add unnecessary
> overhead on non-PREEMPT_RT kernels. I think switching to use local_irq_save()
> (as is done for the per-CPU bio allocation cache) should work.

Adding the PREEMPT_RT maintainers for this as it is above my pay grade.

> Q: "Does creating this workqueue with WQ_MEM_RECLAIM break the local_lock_irq()
> protection in bio_complete_work_fn()?
> When a workqueue has WQ_MEM_RECLAIM, it spawns a global rescuer thread that
> can execute per-CPU work items during worker pool congestion. This rescuer
> thread executes unbound, meaning it could run on CPU B while processing
> CPU A's work item.
> Since local_lock operates strictly on the currently executing CPU, the
> rescuer thread on CPU B would acquire CPU B's lock, while popping elements
> from CPU A's list (derived via container_of()).
> If an interrupt on CPU A concurrently calls __bio_complete_in_task(),
> it will acquire CPU A's lock and modify the same list without mutual
> exclusion, potentially causing list corruption."
> 
> A: The rescuer should run on the same CPU, not unbound, so this is not an
> issue.

This is another area where the PREEMPT_RT/scheduler folks might be able
to help.

> static inline bool bio_complete_in_task(struct bio *bio)
> {
> 	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> 		return false;
> 	if (!bio_in_atomic())
> 		return false;
> 	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> 	__bio_complete_in_task(bio);
> 	return true;
> }
> 
> We can use the BIO_COMPLETE_IN_TASK flag to indicate that it's already
> been deferred to the workqueue as is safe to run.

Would be nice to avoid this, but yes.


