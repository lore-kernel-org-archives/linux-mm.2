Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB80C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BADF26B009D; Thu, 30 Jul 2026 05:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B856D6B00A2; Thu, 30 Jul 2026 05:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74566B00A6; Thu, 30 Jul 2026 05:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4076B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:29:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17C021C123A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:29:54 +0000 (UTC)
X-FDA: 85044921108.18.73E94D6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 60BF840005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:29:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quoNc9N+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vNeyHlcg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=teqsqB2y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Jsr0tjOA;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785403792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enV34PhtzVgKGVfi6OO6Bhrs4AayeYPibuMx/wjb0X0=;
	b=CUseRP8GZ6Gi0xy1ojr3GMwVlJbgCipq8hxVdnmZm32mglFzgvfBJOpd1RcpYsu/hYOGi5
	5DeLik7S61SxYKgtFpOmX0nqVb6YhZca7wOL1CWDUNmbeBe4QYGK3fDMZhTgixEYj2ZUle
	0dFdTFsc3JaKOdsR35JZSMx6zN/jz8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785403792;
	b=utPemRbqEFxlurjkhH1puOIu8sdPMhDBU3GFEOaTzG91mrqaEXpbZid23py8fgys6jHjkV
	pNyHYKZSIa7Y3ZemrRljM+9A1+8YJSDrHTax0C33MB29hWBaKQy8rlIBLbTk52cjgufjJ0
	Uzf/cFaxnSlQU9SQqBpg3JxNXSZcyoc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=quoNc9N+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vNeyHlcg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=teqsqB2y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Jsr0tjOA;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A184E3E8F;
	Thu, 30 Jul 2026 09:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785403785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enV34PhtzVgKGVfi6OO6Bhrs4AayeYPibuMx/wjb0X0=;
	b=quoNc9N+9kkAYgWrmvy1o7qFh6Xv8DH5wdqRMvcrDbE6pdCgjqiu8Ys9lreEzPSdyGbksx
	LtpCbus6Npaa7nkzikkGL81g2GjQpmV4NziHrlYcd+/wyDEmdwNE+deqMaq6WxnuRavvXW
	FurSvkdkl6HVlWYgaYvD5MGGHRkP/iY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785403785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enV34PhtzVgKGVfi6OO6Bhrs4AayeYPibuMx/wjb0X0=;
	b=vNeyHlcgHah8IRGIpsjwuskJEWswsRbbKJA30ggSN5b6BvlLa+wE2p90pyyu842PwJDZkL
	03rFPS+FO7mh48Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785403781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enV34PhtzVgKGVfi6OO6Bhrs4AayeYPibuMx/wjb0X0=;
	b=teqsqB2y0TqJYxmBFz4VrFsZR/TWitcoseD4sRRgUFoaDmkc3uQTlqd6H0Y7nTP6O64Fc+
	d8bPeGruttewhfwkNoNmdfiWb3bKmWTipn2UvHHlrHxXpPgkF8DTXRbvqZFS1urpDrPT1T
	WNy8o/wXqujDZ7Nq5B3IfNTmZS4A2A4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785403781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enV34PhtzVgKGVfi6OO6Bhrs4AayeYPibuMx/wjb0X0=;
	b=Jsr0tjOA3H8XUvMu+it4g/9k/cwpjky8ibGhMgj9lpLsVIxM1wIQ0yl5dpKQ2b6DH8Mo6q
	mGRCwiYgit8QIjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EBBA779CC;
	Thu, 30 Jul 2026 09:29:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uJ7SIoUZa2r8dAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:29:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 34AABA0AAA; Thu, 30 Jul 2026 11:29:41 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:29:41 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
Message-ID: <roo3rxpocrjzz66mko3cf4p4thur2w2sgf24cahbpjk3462ext@3jep6oc2raqs>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 60BF840005
X-Stat-Signature: uji73owspkhwndzw7qm53oumxkmpkwes
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785403791-447922
X-HE-Meta: U2FsdGVkX1+PWulnUEzwBnUqxuX4qhl4bImdYNgTEyQcEautfT3cKXFJE3KQVnuf0BB77fGr1oeHNgWbJsgl2nT8nQ/EFTHAR+fA2xa8mxAkFqgXtMTids2ZSlAGYZbFQVg1+aKqMfzB4B9k6mjjx+HJaujY9Je7GUMHo88yFDNeh4v8WK4y3x/ctA3BLLozcRs5DYWi53Ag4K/4rbHv2C7TPqqt0uQU6muKMH1J3fGG49LJb0Ggepi7zQ7Lyy3xv2dificc1aLPjJUVLTnmGxAqTOZKZDNtSsL5G/w7vt3FqytkkSn7iwfZEOAgn9ZL2ItlTUpX/2fa7v9Lr1mSKFOwpmsuquLKuCblSMa4CgxDseacrHrZk+KP3YC0+ZSDeX2B08tvfh/7k/m2r62Tr2zX+cvCGjeDipJSosSL0bWT94M33uNsbOLDH6WATtF12bKcrI5jG57OYSSy3LJU7tnPrZQSdlNN4b3IYCW9S4tr+g6MoirocgWkXue4jfEkaSowp1GbmrX6IJn6L8tprYEWyX77nyVu45yJBdldXAhayTLchIHuHZrh1DI1FB+r40Nw3F0YOCnrUdtIFjfgyD0SnoI4lfb2ODGdG1cL/CeEQJXvtvBI0+F5coikJ3bIrXV1Aft563Bb8T6PbeSYy7FB1XK23S9TTAC7zNerLeUZyMtNXvn8rs5z2GyGqqeT1Ri42fjLBV1BlsUavmSHUZSpuZaXlftSQa3CYNsOF5WokMRkbMTNjruRekbNl/LrwERTIUQmufnr5qErcptVqy1bQTAuypYUhbTk0SS2dqT9Bxvt+nugVfuyU5lskx46+NoZPR9kqRkl/FSj8vA2aumD/K48gV4bTZtHuMvqZAmMItZP9Jpl2Yf2Es8pnwkbXTu/BYMGBGNBYTNqfOH62/0sqN1W7EGatQzPgsRN83wzjVspoL22BzVamUYyoZJmlDScLFtOLIWEwxbpEKP
 cdAbEyeZ
 RrjLpVjcYI6bDAhGZ2YOkM16cIYzaByXB1if4zn67W6JRZ7Wztzm82MjlgndybRxwRVb39Jt8KFGZiGjW9QCnEjEfMv1JvY8e9OkapEvinPcfM0DRjYxTDUOCoBj62kVzjarpqIc5u/OS73u6/Z/6uLfbbYfguB4yJ2uvYsKeWKon/rWFEjCy5DAKtWACj66WtTXTi3+Fji6Uzx4Y0eZzQ9SXrvxz2IpkEn8d+MvTOEIqovc3lPdDE8am4MV+H+akfzVDrYc07Ev16nSGEmw/79wxXx1FDgigAfKq52BbaeRlN/LjzEzD1xwQe9SUAcGfxdcHJ9mda1MxMHUYbWpS//smx/VqcW+xCqEvCc0hfrKAGUXIukpJz2Hd2VltD7Q1wyxUe/8aql53s4uV7nfy8vSj8936A6XYnnKC/d3pzmrLVztaFLURAWzUlSTUah283mVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 30-07-26 02:57:52, Tal Zussman wrote:
> Some bio completion handlers need to run from preemptible task context,
> but bio_endio() may be called from IRQ context (e.g., buffer_head
> writeback). Callers need a way to ensure their callback eventually runs
> from a sleepable context. Add infrastructure for that, in two forms:
> 
>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>      in advance that its callback needs task context (e.g., dropbehind
>      writeback). bio_endio() sees the flag and offloads completion to a
>      worker automatically.
> 
>   2. bio_complete_in_task(), a helper that completion callbacks can
>      invoke from within bi_end_io() when the deferral decision is
>      dynamic (e.g., fserror reporting).
> 
> Both share a per-CPU list drained by a work item on a WQ_PERCPU
> workqueue. Producers push the bio onto the local CPU's list and schedule
> the work item, which then dispatches each bio's bi_end_io() from task
> context.
> 
> Both methods are gated on bio_in_atomic(), which returns true in any
> context where a sleeping bi_end_io() is unsafe, including
> non-preemptible task context.
> 
> Two CPU hotplug callbacks are used to drain remaining bios from the
> departing CPU's batch, while maintaining the per-CPU behavior. The
> CPUHP_AP_ONLINE_DYN callback disables the per-CPU work item while the
> CPU is still online, preventing it from running on an unbound worker
> later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
> the work item and CPU offline.
> 
> Link: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bio.c               | 132 +++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/bio.h       |  24 +++++++++
>  include/linux/blk_types.h |   1 +
>  3 files changed, 156 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 6a2f6fc3413e..a9610950325b 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1741,6 +1741,61 @@ void bio_check_pages_dirty(struct bio *bio)
>  	schedule_work(&bio_dirty_work);
>  }
>  
> +/*
> + * Infrastructure for deferring bio completions to task-context via a per-CPU
> + * workqueue. Triggered either by the BIO_COMPLETE_IN_TASK bio flag (static
> + * decision at submit time) or by calling bio_complete_in_task() from
> + * bi_end_io() (dynamic decision at completion time).
> + */
> +
> +struct bio_complete_batch {
> +	struct bio_list list;
> +	struct work_struct work;
> +	int cpu;
> +};
> +
> +static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
> +static struct workqueue_struct *bio_complete_wq;
> +
> +static void bio_complete_work_fn(struct work_struct *w)
> +{
> +	struct bio_complete_batch *batch =
> +		container_of(w, struct bio_complete_batch, work);
> +
> +	while (1) {
> +		struct bio_list list;
> +		struct bio *bio;
> +
> +		local_irq_disable();
> +		list = batch->list;
> +		bio_list_init(&batch->list);
> +		local_irq_enable();
> +
> +		if (bio_list_empty(&list))
> +			break;
> +
> +		while ((bio = bio_list_pop(&list)))
> +			bio->bi_end_io(bio);
> +	}
> +}
> +
> +void __bio_complete_in_task(struct bio *bio)
> +{
> +	struct bio_complete_batch *batch;
> +	unsigned long flags;
> +	bool was_empty;
> +
> +	local_irq_save(flags);
> +	batch = this_cpu_ptr(&bio_complete_batch);
> +	was_empty = bio_list_empty(&batch->list);
> +	bio_list_add(&batch->list, bio);
> +	local_irq_restore(flags);
> +
> +	if (was_empty)
> +		queue_work_on(batch->cpu, bio_complete_wq, &batch->work);
> +}
> +EXPORT_SYMBOL_GPL(__bio_complete_in_task);
> +
>  static inline bool bio_remaining_done(struct bio *bio)
>  {
>  	/*
> @@ -1815,7 +1870,9 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (bio->bi_end_io)
> +	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
> +		__bio_complete_in_task(bio);
> +	else if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
>  EXPORT_SYMBOL(bio_endio);
> @@ -2001,6 +2058,55 @@ int bioset_init(struct bio_set *bs,
>  }
>  EXPORT_SYMBOL(bioset_init);
>  
> +static int bio_complete_batch_cpu_online(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch = &per_cpu(bio_complete_batch, cpu);
> +
> +	enable_work(&batch->work);
> +	if (!bio_list_empty(&batch->list))
> +		queue_work_on(cpu, bio_complete_wq, &batch->work);
> +	return 0;
> +}
> +
> +/*
> + * Disable this CPU's work item so that it cannot run on an unbound worker
> + * after the CPU is offlined.
> + */
> +static int bio_complete_batch_cpu_down_prep(unsigned int cpu)
> +{
> +	disable_work_sync(&per_cpu(bio_complete_batch, cpu).work);
> +	return 0;
> +}
> +
> +/*
> + * Drain a dead CPU's deferred bio completions. The CPU is dead and the worker
> + * is canceled so no locking is needed.
> + */
> +static int bio_complete_batch_cpu_dead(unsigned int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +	struct bio *bio;
> +
> +	while ((bio = bio_list_pop(&batch->list)))
> +		bio->bi_end_io(bio);
> +
> +	return 0;
> +}
> +
> +static void __init bio_complete_batch_init(int cpu)
> +{
> +	struct bio_complete_batch *batch =
> +		per_cpu_ptr(&bio_complete_batch, cpu);
> +
> +	bio_list_init(&batch->list);
> +	INIT_WORK(&batch->work, bio_complete_work_fn);
> +	batch->cpu = cpu;
> +
> +	if (!cpu_online(cpu))
> +		disable_work_sync(&batch->work);
> +}
> +
>  static int __init init_bio(void)
>  {
>  	int i;
> @@ -2015,6 +2121,30 @@ static int __init init_bio(void)
>  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
>  	}
>  
> +	for_each_possible_cpu(i)
> +		bio_complete_batch_init(i);
> +
> +	bio_complete_wq = alloc_workqueue("bio_complete",
> +					   WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> +	if (!bio_complete_wq)
> +		panic("bio: can't allocate bio_complete workqueue\n");
> +
> +	/*
> +	 * bio task-context completion draining on hot-unplugged CPUs:
> +	 *
> +	 *   1. Stop the per-CPU work item while the CPU is still online, so
> +	 *      that it cannot run on an unbound worker later.
> +	 *   2. Drain leftover bios added between worker disabling and CPU
> +	 *      offlining.
> +	 */
> +	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
> +				  "block/bio:complete:online",
> +				  bio_complete_batch_cpu_online,
> +				  bio_complete_batch_cpu_down_prep);
> +	cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
> +				  "block/bio:complete:dead",
> +				  NULL, bio_complete_batch_cpu_dead);
> +
>  	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
>  					bio_cpu_dead);
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 62a983758e09..a8091a3e9d87 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -383,6 +383,30 @@ static inline bool bio_in_atomic(void)
>  	return !preemptible();
>  }
>  
> +void __bio_complete_in_task(struct bio *bio);
> +
> +/**
> + * bio_complete_in_task - ensure a bio is completed in preemptible task context
> + * @bio: bio to complete
> + *
> + * If called from non-task context, offload the bio completion to a worker
> + * thread and return %true. Else return %false and do nothing.
> + *
> + * Uses BIO_COMPLETE_IN_TASK as a sentinel: if set, the bio was already
> + * deferred and we are running in the worker — return %false so the
> + * callback proceeds instead of re-deferring.
> + */
> +static inline bool bio_complete_in_task(struct bio *bio)
> +{
> +	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> +		return false;
> +	if (!bio_in_atomic())
> +		return false;
> +	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> +	__bio_complete_in_task(bio);
> +	return true;
> +}
> +
>  extern void bio_endio(struct bio *);
>  
>  /**
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8808ee76e73c..d49d97a050d0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -322,6 +322,7 @@ enum {
>  	BIO_REMAPPED,
>  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
>  	BIO_FLAG_LAST
>  };
>  
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

