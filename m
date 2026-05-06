Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6E6CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 10:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6F06B0005; Wed,  6 May 2026 06:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897DB6B0088; Wed,  6 May 2026 06:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786C36B008A; Wed,  6 May 2026 06:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 691926B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:43:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B92A2A016B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:43:46 +0000 (UTC)
X-FDA: 84736659252.20.1A4EA74
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B0FF4000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:43:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUno8sSZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="I/nJMp1g";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUno8sSZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="I/nJMp1g";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778064224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKJJpKo4selPgwo4u799sd/7fHc43w/Qqia5bTZ5JMs=;
	b=TjnPChdKavsrZQ4FTr5hFDROZyJEEODQYfpTAujwiYpzEVkxy1ZzRUYhh/jYWssPVPkDG7
	IcFPz+aDYViE/Njoj1qA30IOZCFZL+ci8tzTquMfTgWjg5fmvnnlDHqWODogjjxH/sVVLE
	paz8sjnsSewwBaOGX3do3mMqq3ceBAI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUno8sSZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="I/nJMp1g";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uUno8sSZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="I/nJMp1g";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778064224; a=rsa-sha256;
	cv=none;
	b=aZ3nfwxHAXgPxbZAbTVet8WHkyyGXXlcjQPOu4VrqV/eoy9cnmafvXxXIj1awLLf9HLpKb
	aY308DuiaUgAGc47hssGD2sxtLj/jdq8vGI8LGTP7FAX/pS5VM2F2Sk+XyMBvnlpDDBSMY
	CLAoUtUBKJMaQzsMqq4nwXXVOkW9Y5o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 915256BC44;
	Wed,  6 May 2026 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778064222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKJJpKo4selPgwo4u799sd/7fHc43w/Qqia5bTZ5JMs=;
	b=uUno8sSZwIpQbbKuT+Tn7b/O5N5bNyYny+2bMvjIX6zVv/42mcjR2UYMIGvd3SO/eaFE1H
	WWXI7+vBtlqejaCFS8ps8lC90puyicZ2Zs8X5jrwIy25FeGV02rqxd8ywtnNZ0uaLE1zDM
	Q1lVLz4etWtyXWcF8Qxy5ov+4V7iyQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778064222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKJJpKo4selPgwo4u799sd/7fHc43w/Qqia5bTZ5JMs=;
	b=I/nJMp1g4XU8KNu25pVJlQSo2ySwu5a9X+yT6JssYpfQlbpODY8P3DdLglkXEAwAyfI97T
	V3YUrDF3rSFSQNBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778064222; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKJJpKo4selPgwo4u799sd/7fHc43w/Qqia5bTZ5JMs=;
	b=uUno8sSZwIpQbbKuT+Tn7b/O5N5bNyYny+2bMvjIX6zVv/42mcjR2UYMIGvd3SO/eaFE1H
	WWXI7+vBtlqejaCFS8ps8lC90puyicZ2Zs8X5jrwIy25FeGV02rqxd8ywtnNZ0uaLE1zDM
	Q1lVLz4etWtyXWcF8Qxy5ov+4V7iyQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778064222;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKJJpKo4selPgwo4u799sd/7fHc43w/Qqia5bTZ5JMs=;
	b=I/nJMp1g4XU8KNu25pVJlQSo2ySwu5a9X+yT6JssYpfQlbpODY8P3DdLglkXEAwAyfI97T
	V3YUrDF3rSFSQNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73C28593A3;
	Wed,  6 May 2026 10:43:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iL/GG14b+2kQSAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 06 May 2026 10:43:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C8142A0790; Wed, 06 May 2026 12:43:41 +0200 (CEST)
Date: Wed, 6 May 2026 12:43:41 +0200
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
Subject: Re: [PATCH v6 2/2] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <yz5zorwpe5vunerb6wn4jv7sdumrkfe2jcvo6cnknk465kn4wa@g6fw43s7qb4a>
References: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
 <20260505-dontcache-v6-2-66463805dd6a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260505-dontcache-v6-2-66463805dd6a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B0FF4000D
X-Stat-Signature: xz9am5adm7wk6qhyytegsiidx19thfic
X-HE-Tag: 1778064224-147676
X-HE-Meta: U2FsdGVkX1+0gb67R3kInM/jNxuZA2eZsGEullLc4BfQCX2g9KCML35lUqFDJ0M6Hu6w/6rKZRdPA3CjLdGsxUY8ZDXGYH9yiC2X79qBNYBgHcrBP1RjT67yULKeVYqpLe9j1eByDyXIgS5VFSPxEpxfStW8DoXt0b+xZUffdfs/yb2pinh/WZAtUFvlGHbZ4yH6Z+mzUiB+b73VFWFPnHCoZK7rU3ecAVobOqf5KTWiAKpOF1bff5fgH0Jh2vdwn/1I9y8IqbgGEl8zG8JtbSci4VxV4Zoy8g0sxc/UpvtGWnClk4PbChccdY9jGHKY2+Ebv/5bHMiZyRHcIP4EbHNtQ+srwUtEpafn4ymoYwkbs+thxHkh9vbwLh3MGJaysrR9/3qWWnrwxtn53QbCu1IYBxu+Z3Zq9aMiZaSsj0oCKG8WF0E8mu8N7wa5uRuiQf3NZMWU2JccaV6rURQGEgJSLZEPR/sGtmkRtChdsxIzIVaR14Vjtx/HUVZqGXBTo3cLLRwZMGeBkl8hWRG2UbGrMQ+/3cQXsT9/RP/Hc+m+m3utYy4lR9Jqd7Ea4WqZy5k/IyYSyyh57HZ1xeCH7aCApXbID1Tv9v5R3GoAsXKekc0RWAFl9y8VsPB+lhwGLSbkwlh/+KsYoKTIl/pyobvLQ7PycfDFDL8eLwglMIdTMaN/aKhyKmwMpjFmO8ykNOAKDk5UU85nwUPxdwKCgJ1keKiHweCtzh5XLc7iotqzB7b/bWwpj52k83PhYPVenYUb3mrFr9XThX4aRId29GX8ONJUMq4Kw0/D/N2DmFaidswXRyI2itBH7f/Rcv4haRAykwxwoNbKNv0lPS5fG5I4df3+grKyuRIcViK3l4N58aPplSzliggLupOJw9qKyJVx0YEjS/mfjIiG3Lqtp3zW4/aRPAB8+OjjMe4IXCtHGd4gbBdCUeLTKm8uTBxyATTcrxV2GuVSEqYQvrL
 lSIHe8pc
 pD7m+Upkp8X3t+4DrSNNZ0dqS3g2VipbcWmblkohvsvApLC61G6tOb5lSMCcPDtn3Wm8fQc+gXDMrPwHEzA4J767LnHOUkvj7JyTUqNiuxL1BThG3mcf98VJceIknrr6mDJxYvOw3I4m/Uk1w+cTcw2VWwIxN1OJBKw+Vjvd5aKu9NQk6AVCiTQlcwZOriNm7sSIqNA0tNjCTUCiOrmVSlD+jEI19lSw+ya/2U1iYMmM/XdzZN+UokgppyukQnIKItJZlOMH4Nk3cbEsq3dFqXSJxSRgwj6fEHnk2UeyQeOEe8aa2+Hte2uM3JpLESeh5j4quMcCx1gEI5qtCSIXFhtW7S9WkiQm+a7rwEXT1GC4m/qTRNmz8zonGfr9wb5fOZrS6kWLVIq0toA0u5/YKPEyYMdMJOETdtHEetzIOovlbEIEniHKyPdPUp5d1G6V5jrlYUuambo6uo30wLRMFnioC1RFXeG1A70uBgC+tYe3Q62QvoGKDM7eoBvFUihrzkQ5J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 05-05-26 20:59:49, Jeff Layton wrote:
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
> be held under irqsave during a cgroup writeback switch.
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

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c                | 59 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/backing-dev-defs.h |  2 ++
>  include/linux/fs.h               |  6 ++--
>  include/trace/events/writeback.h |  3 +-
>  4 files changed, 65 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index a65694cbfe68..faf15cf84c68 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2373,6 +2373,27 @@ static long wb_check_start_all(struct bdi_writeback *wb)
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
> @@ -2394,6 +2415,11 @@ static long wb_do_writeback(struct bdi_writeback *wb)
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
> @@ -2468,6 +2494,39 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
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
> +	    !test_and_set_bit(WB_start_dontcache, &wb->state))
> +		need_wakeup = true;
> +	unlocked_inode_to_wb_end(inode, &cookie);
> +
> +	if (need_wakeup)
> +		wb_wakeup(wb);
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

