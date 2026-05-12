Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD9BCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF936B0088; Tue, 12 May 2026 10:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FC66B008A; Tue, 12 May 2026 10:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56C56B008C; Tue, 12 May 2026 10:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0A8E6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:17:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56F3D1C0DCA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:17:19 +0000 (UTC)
X-FDA: 84758970198.15.81331F5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id B39114000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:17:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I8WEnaFd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EfMDwtW/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I8WEnaFd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EfMDwtW/";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778595437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YV9dwbMdeWpR0O86ddpJ8WHFsca7tswi+2GTZpS3VFY=;
	b=z54Zo6H96rOWJYrpPTXV+mbEALR1bW1T0/TvzJ+YTmUcM973Ae82lHn8LbmVLN7P4PJJNr
	vyHMDZIPxNRhaF4M7aK8R+7NpQo4WG5GSMKUeOGKB4g3KB75SuqFsqH1MTVz61ND/GVRk8
	AmcldWX0VX25tHzrk+xDUy0Ng+GlE6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778595437; a=rsa-sha256;
	cv=none;
	b=60EIqbC689Z92FbFfr0ehqFRd6kEJWW4RL2tXgdJWzXlQTJA6l+U7W8dIJCOiMpwzs4A3g
	4Ug58HTgzYrxHHZvjeZLqBrFz/fd1wkDnRblaAZB+WfYelUZ+fGHB5kIyzlTSXzATn5cIB
	kvXyO44aYvwCr5GpqHr7CGCo5v/Ub88=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I8WEnaFd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EfMDwtW/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I8WEnaFd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EfMDwtW/";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C7A06C280;
	Tue, 12 May 2026 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778595435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YV9dwbMdeWpR0O86ddpJ8WHFsca7tswi+2GTZpS3VFY=;
	b=I8WEnaFdTPdNwmoQa8aJZ2ElQGNi+4HDybh3mtVgNN0L2aIFkKFSZ5ZaRpf6LWQemXjVVy
	oMaljFQUiRWh0aDgW2NovUuZs1l8E0FgYcs5EDKj5OXuTe/ciqZXqKvfO6iXfo85asUhBl
	NBwZGVcWDy4cyZxF8kGt3rc8FkIhdfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778595435;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YV9dwbMdeWpR0O86ddpJ8WHFsca7tswi+2GTZpS3VFY=;
	b=EfMDwtW/v2EmK2XCAjpePv3KesAFFWtgAqa3Jzs/AqdV1bwYllcm9S1hhVCgxyLe4tsFT0
	Gz7E3IWOncYc7TAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778595435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YV9dwbMdeWpR0O86ddpJ8WHFsca7tswi+2GTZpS3VFY=;
	b=I8WEnaFdTPdNwmoQa8aJZ2ElQGNi+4HDybh3mtVgNN0L2aIFkKFSZ5ZaRpf6LWQemXjVVy
	oMaljFQUiRWh0aDgW2NovUuZs1l8E0FgYcs5EDKj5OXuTe/ciqZXqKvfO6iXfo85asUhBl
	NBwZGVcWDy4cyZxF8kGt3rc8FkIhdfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778595435;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YV9dwbMdeWpR0O86ddpJ8WHFsca7tswi+2GTZpS3VFY=;
	b=EfMDwtW/v2EmK2XCAjpePv3KesAFFWtgAqa3Jzs/AqdV1bwYllcm9S1hhVCgxyLe4tsFT0
	Gz7E3IWOncYc7TAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1D26593A9;
	Tue, 12 May 2026 14:17:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KioDO2o2A2rNBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 14:17:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 959C8A07B5; Tue, 12 May 2026 16:17:06 +0200 (CEST)
Date: Tue, 12 May 2026 16:17:06 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v7 3/3] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <w4cgah3okfq7lhcbsts7sstlixekx33my4i5qq7xwnez725jdg@ckni33bdw4qo>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B39114000B
X-Stat-Signature: e17uandfb8o48gm9keo9fqy5y5t1sapw
X-Rspam-User: 
X-HE-Tag: 1778595436-80471
X-HE-Meta: U2FsdGVkX18xlcjMoBRGyfR2iYgWg+uaA1u98XJpwY6g5ZaNMAkmil2QwhNi9fkdHIrSY5+ee2906RRatwOUW0I1b/qOTx6u0G3qS0JXDUpS0E0G9h6IgQyGLAYWQevPMIeEGwasxuEp2B2snKDxVZK0zJ3IXmt4OOlzLq228d9wCxnOo3k0tuy3gF3G3oDjnpKeoXmlIOOD29ttt0NtrOPXumLJCVHRMQwgAaICHYQRCla+YXogO2KNDBH72qfdcwWJLrHWxFI4unKv6r9VTrcYe2f0q/Vygu0uxEfoqyCjHNpljaijbnzv4gLc+RT+gy45RP/2VwBNzrr86q38h5qT9zpdY/adeDuyHTE4dpOOQfkeyXL1dI7Tk9jJFmDAUG+swv9tDAwVShnoIWr3BlI3ookhWCp0OuY0k/CZS0waTfzo/V3TSmvSN7vDzb0i+EjNRJOHgBrI6qwcNrDA2vYngI97LSw81MI7puJbQOQ5GiOWWOSQ6sIvMMxFeEJSk9KzwQ6x0E/0isZQcZhLpy/uCXJldRqr/r+07CQwHEfS/Pd67HJxpPehJqMJUvAUUjC+vDYKO6FzmzVpTt11EiSgepz2p+2kdkJ80hdzqQ4gXmG3vynBiCw8N6kdi3prc8g3y3gK5c5Xi3fcwm9QBT2YFc7FZ1A0mraZN7GHTUls7QtwavbXNM4I3cC/jR56hQsmFeWU8477jvRWKbF6E3x3lK02f31Fp3DZ3xdAlR9pcNi8Avm6UorgKk0cx8DpV/dmX0bli9oG0AqmtMiM+w2Qa2zJK+5WHoVN6jPqDPkE0pXHj+hszgXlZlqNNgxEVcEd2OBfCijTdojZSOnoubouf/WJz7snEqY7wE4kymks91ZF6fu5TxS90GDOvQP+m2fT9Q0II8eBLNMdWIOkfMOOyyzeARqdtPrljBbrCByyVJspoKu0zV8BkQECNvhJPouFk4rvS4CjJEtZHIR
 CYklf+a2
 DTlHbjJXRYJ/6RxsjD+8zkG56EPbgb89jFtxlQj0qUmuhThRrm0pnPkqf2VUy1e5yUQ9Mb9MnY3kUyuTQOO+gxQu3S8eyc9+XN0leACNzpQpes8ApQ/q25x078sQwMgt5YlB6E6pOHM0B5N/x1vLTHT/O+nXiBHS5ydcbdes/jCEnGSSWqyh+sKDi+TZScTsBrWIRFAyvmP/LT4sVYBsFwZJwZYSeybwa+k2STJqVs4iDfEkmobD28/I9lup9J8xoFUOkRw4wi4GQMNntc/kPCB71WD2JbXAvKDs74qoERdPo5TEdH0Ou2jCwEIaS9QTPbYWiYHOsNpPSfRoASQL9qot0cff0SItTK7WqbTQNslTf29dM/PvzdpWz65/6zESFP5luLuBQjMqqCOHYDPH514kDI/IXblnhQ/4Q7kQUrAzG3fsI2gjlWQ02OgMckmhU3o7Q7BsFGBG83EtTVLrYK2RFTSDnillEUC40ptPCj7+RTDzduAu7/UW0mUwfrU3KLre4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 07:58:29, Jeff Layton wrote:
> The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> filemap_flush_range() on every write, submitting writeback inline in
> the writer's context.  Perf lock contention profiling shows the
> performance problem is not lock contention but the writeback submission
> work itself — walking the page tree and submitting I/O blocks the writer
> for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
> (dontcache).
> 
> Replace the inline filemap_flush_range() call with a flusher kick that
> drains dirty pages in the background.  This moves writeback submission
> completely off the writer's hot path.
> 
> To avoid flushing unrelated buffered dirty data, add a dedicated
> WB_start_dontcache bit and wb_check_start_dontcache() handler that uses
> the per-wb WB_DONTCACHE_DIRTY counter to determine how many pages to
> write back.  The flusher writes back that many pages from the oldest dirty
> inodes (not restricted to dontcache-specific inodes). This helps
> preserve I/O batching while limiting the scope of expedited writeback.
> 
> Like WB_start_all, the WB_start_dontcache bit coalesces multiple
> DONTCACHE writes into a single flusher wakeup without per-write
> allocations.  Use test_and_clear_bit to atomically consume the kick
> request before reading the dirty counter and starting writeback, so that
> concurrent DONTCACHE writes during writeback can re-set the bit and
> schedule a follow-up flusher run.
> 
> Read the dirty counter with wb_stat_sum() (aggregating per-CPU batches)
> rather than wb_stat() (which reads only the global counter) to ensure
> small writes below the percpu batch threshold are visible to the flusher.
> 
> In filemap_dontcache_kick_writeback(), set the WB_start_dontcache bit
> inside the unlocked_inode_to_wb_begin/end section for correct cgroup
> writeback domain targeting, but defer the wb_wakeup() call until after
> the section ends, since wb_wakeup() uses spin_unlock_irq() which would
> unconditionally re-enable interrupts while the i_pages xa_lock may still
> be held under irqsave during a cgroup writeback switch. Pin the wb with
> wb_get() inside the RCU critical section before calling wb_wakeup()
> outside it, since cgroup bdi_writeback structures are RCU-freed and the
> wb pointer could become invalid after unlocked_inode_to_wb_end() drops
> the RCU read lock.
> 
> Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
> visibility.
> 
> dontcache-bench results (same host, T6F_SKL_1920GBF, 251 GiB RAM,
> xfs on NVMe, fio io_uring):
> 
> Buffered and direct I/O paths are unaffected by this patchset. All
> improvements are confined to the dontcache path:
> 
> Single-stream throughput (MB/s):
>                         Before    After    Change
>   seq-write/dontcache      298      897    +201%
>   rand-write/dontcache     131      236     +80%
> 
> Tail latency improvements (seq-write/dontcache):
>   p99:    135,266 us  ->  23,986 us   (-82%)
>   p99.9: 8,925,479 us ->  28,443 us   (-99.7%)
> 
> Multi-writer (4 jobs, sequential write):
>                                 Before    After    Change
>   dontcache aggregate (MB/s)     2,529    4,532     +79%
>   dontcache p99 (us)             8,553    1,002     -88%
>   dontcache p99.9 (us)         109,314    1,057     -99%
> 
>   Dontcache multi-writer throughput now matches buffered (4,532 vs
>   4,616 MB/s).
> 
> 32-file write (Axboe test):
>                                 Before    After    Change
>   dontcache aggregate (MB/s)     1,548    3,499    +126%
>   dontcache p99 (us)            10,170      602     -94%
>   Peak dirty pages (MB)          1,837      213     -88%
> 
>   Dontcache now reaches 81% of buffered throughput (was 35%).
> 
> Competing writers (dontcache vs buffered, separate files):
>                                 Before    After
>   buffered writer                  868      433 MB/s
>   dontcache writer                 415      433 MB/s
>   Aggregate                      1,284      866 MB/s
> 
>   Previously the buffered writer starved the dontcache writer 2:1.
>   With per-bdi_writeback tracking, both writers now receive equal
>   bandwidth. The aggregate matches the buffered-vs-buffered baseline
>   (863 MB/s), indicating fair sharing regardless of I/O mode.
> 
>   The dontcache writer's p99.9 latency collapsed from 119 ms to
>   33 ms (-73%), eliminating the severe periodic stalls seen in the
>   baseline. Both writers now share identical latency profiles,
>   matching the buffered-vs-buffered pattern.
> 
> The per-bdi_writeback dirty tracking dramatically reduces peak dirty
> pages in dontcache workloads, with the 32-file test dropping from
> 1.8 GB to 213 MB. Dontcache sequential write throughput triples and
> multi-writer throughput reaches parity with buffered I/O, with tail
> latencies collapsing by 1-2 orders of magnitude.
> 
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

This patch with Christian's simplification looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c                | 63 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/backing-dev-defs.h |  2 ++
>  include/linux/fs.h               |  6 ++--
>  include/trace/events/writeback.h |  3 +-
>  4 files changed, 69 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 32ecc745f5f7..77d53df97cc3 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2377,6 +2377,27 @@ static long wb_check_start_all(struct bdi_writeback *wb)
>  	return nr_pages;
>  }
>  
> +static long wb_check_start_dontcache(struct bdi_writeback *wb)
> +{
> +	long nr_pages;
> +
> +	if (!test_and_clear_bit(WB_start_dontcache, &wb->state))
> +		return 0;
> +
> +	nr_pages = wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
> +	if (nr_pages) {
> +		struct wb_writeback_work work = {
> +			.nr_pages	= nr_pages,
> +			.sync_mode	= WB_SYNC_NONE,
> +			.range_cyclic	= 1,
> +			.reason		= WB_REASON_DONTCACHE,
> +		};
> +
> +		nr_pages = wb_writeback(wb, &work);
> +	}
> +
> +	return nr_pages;
> +}
>  
>  /*
>   * Retrieve work items and do the writeback they describe
> @@ -2398,6 +2419,11 @@ static long wb_do_writeback(struct bdi_writeback *wb)
>  	 */
>  	wrote += wb_check_start_all(wb);
>  
> +	/*
> +	 * Check for dontcache writeback request
> +	 */
> +	wrote += wb_check_start_dontcache(wb);
> +
>  	/*
>  	 * Check for periodic writeback, kupdated() style
>  	 */
> @@ -2472,6 +2498,43 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
>  	rcu_read_unlock();
>  }
>  
> +/**
> + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
> + * @mapping:	address_space that was just written to
> + *
> + * Kick the writeback flusher thread to expedite writeback of dontcache dirty
> + * pages. Queue writeback for the inode's wb for as many pages as there are
> + * dontcache pages, but don't restrict writeback to dontcache pages only.
> + *
> + * This significantly improves performance over either writing all wb's pages
> + * or writing only dontcache pages.  Although it doesn't guarantee quick
> + * writeback and reclaim of dontcache pages, it keeps the amount of dirty pages
> + * in check. Over longer term dontcache pages get written and reclaimed by
> + * background writeback even with this rough heuristic.
> + */
> +void filemap_dontcache_kick_writeback(struct address_space *mapping)
> +{
> +	struct inode *inode = mapping->host;
> +	struct bdi_writeback *wb;
> +	struct wb_lock_cookie cookie = {};
> +	bool need_wakeup = false;
> +
> +	wb = unlocked_inode_to_wb_begin(inode, &cookie);
> +	if (wb_has_dirty_io(wb) &&
> +	    !test_bit(WB_start_dontcache, &wb->state) &&
> +	    !test_and_set_bit(WB_start_dontcache, &wb->state)) {
> +		wb_get(wb);
> +		need_wakeup = true;
> +	}
> +	unlocked_inode_to_wb_end(inode, &cookie);
> +
> +	if (need_wakeup) {
> +		wb_wakeup(wb);
> +		wb_put(wb);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(filemap_dontcache_kick_writeback);
> +
>  /*
>   * Wakeup the flusher threads to start writeback of all currently dirty pages
>   */
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index cb660dd37286..4f1084937315 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -26,6 +26,7 @@ enum wb_state {
>  	WB_writeback_running,	/* Writeback is in progress */
>  	WB_has_dirty_io,	/* Dirty inodes on ->b_{dirty|io|more_io} */
>  	WB_start_all,		/* nr_pages == 0 (all) work pending */
> +	WB_start_dontcache,	/* dontcache writeback pending */
>  };
>  
>  enum wb_stat_item {
> @@ -56,6 +57,7 @@ enum wb_reason {
>  	 */
>  	WB_REASON_FORKER_THREAD,
>  	WB_REASON_FOREIGN_FLUSH,
> +	WB_REASON_DONTCACHE,
>  
>  	WB_REASON_MAX,
>  };
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfb..df72b42a9e9b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2624,6 +2624,7 @@ extern int __must_check file_write_and_wait_range(struct file *file,
>  						loff_t start, loff_t end);
>  int filemap_flush_range(struct address_space *mapping, loff_t start,
>  		loff_t end);
> +void filemap_dontcache_kick_writeback(struct address_space *mapping);
>  
>  static inline int file_write_and_wait(struct file *file)
>  {
> @@ -2657,10 +2658,7 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
>  		if (ret)
>  			return ret;
>  	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
> -		struct address_space *mapping = iocb->ki_filp->f_mapping;
> -
> -		filemap_flush_range(mapping, iocb->ki_pos - count,
> -				iocb->ki_pos - 1);
> +		filemap_dontcache_kick_writeback(iocb->ki_filp->f_mapping);
>  	}
>  
>  	return count;
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index bdac0d685a98..13ee076ccd16 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -44,7 +44,8 @@
>  	EM( WB_REASON_PERIODIC,			"periodic")		\
>  	EM( WB_REASON_FS_FREE_SPACE,		"fs_free_space")	\
>  	EM( WB_REASON_FORKER_THREAD,		"forker_thread")	\
> -	EMe(WB_REASON_FOREIGN_FLUSH,		"foreign_flush")
> +	EM( WB_REASON_FOREIGN_FLUSH,		"foreign_flush")	\
> +	EMe(WB_REASON_DONTCACHE,		"dontcache")
>  
>  WB_WORK_REASON
>  
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

