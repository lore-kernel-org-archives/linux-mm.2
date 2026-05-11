Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEACCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3B66B00BB; Mon, 11 May 2026 09:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAF36B00BC; Mon, 11 May 2026 09:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1676B00BD; Mon, 11 May 2026 09:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7B36B00BB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:24:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A97ED140134
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:24:39 +0000 (UTC)
X-FDA: 84755208678.01.6638868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DC2A11A0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:24:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozKRNnPS;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbZCgR7/bY8+IqBuy5fc8gZ2DQ3bR5YMGrFhSXG9bLs=;
	b=dfXfDCZNmlQHZYI45x57UeUddlLtc0zLgwA/jOKXDGXeRG9H0ogeIkkYSEin5/8mtHrbps
	vkvwJr6lMUPH2p+wBaLQTVib9gfxYAB6E2SLZJ8pATRsZy1Sz2t1clGmjDh2fyzaTkjXUB
	+E2vK1zBY9NBL7ypllebQBTOoFX6SnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505878; a=rsa-sha256;
	cv=none;
	b=hf5B5R+jAoVkwG2LM3/iIrtVazJhvI8MNPOsTo4LAcZUqYrfTHru/F8+j/a07uYpFPEGGb
	jXdReSiUenrPjz1oBSLM0+sOqpjcJVC1diR+6Q+XiEPf68LKDAi58ybCMge+c8dRE7psBe
	ON9/cjOs7ouNCzxdG2eWoW4InwfwyBE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozKRNnPS;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC96543FE2;
	Mon, 11 May 2026 13:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8D1C2BCB0;
	Mon, 11 May 2026 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778505876;
	bh=45Jm/PhkxV5J5go2T8hXkU65Az6gpJJzXMVog7W1o6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ozKRNnPSby6dVKr1OyOOJp34eF/PUQ8m2BzMnJ3UDjBp3qh6WIVAD0AfZSzokF8vv
	 iusOSSnCgeqQu/uiPKo8dUf/W5HXUepK2cjSA+lvfAg4adXt4btHWV19kZzxFXc1iK
	 66oJSJK8g2l4uJSvQsHxw6ct7Ju1Ost5dAhb0KXLomY82vQncGzhZbPJETTHpNsRFC
	 JNQ+iYrHR7KgIVBNUuwRlfKMhM6iPqFkz26EryuL8OruTNDtNRrhl8gFhCK0bVF71e
	 W8erm/gQ+BE9YczlLPDqyQ+eL14u0K4PUpwPgXEHLe/G9H1jLbqW6wFqj0PTzOmaas
	 k7mb4m0tAWahg==
Date: Mon, 11 May 2026 15:24:29 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
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
Message-ID: <20260511-zusieht-amputation-efe8b5058cb7@brauner>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260511-dontcache-v7-3-2848ddce8090@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC2A11A0004
X-Stat-Signature: sp9dw3rjqktbrh981pxkc1qcjjebcwub
X-Rspam-User: 
X-HE-Tag: 1778505877-985227
X-HE-Meta: U2FsdGVkX19ark5XBHnmmb5VXbK5fns1+v4iHXlwbtoYd/+UiHsSYi+UxroeUCch1e7GD+q+rIrHUE25KhKHmzPnOY0qUPsRYvrdLdtaG8I4MdjkmOZgKJi8phNlfHdJyVjWGP8LRNhd1Xk9AEc7DYZleKft9gd+y3a/tJveQ5e+TSAS6ocMcM9dQgITh77T69MVbjZX+bANBc2GfRkUjIYk6M/ol1U8YY07+Q4NTHvQySjOd1xrcmUmQAQST3n+IcCB/zrKnhyJePz4HujQzT9v1E54XhlQUcIjbe+C+TcBF5VhT/B8PZkwDXo+Pn6oEnQ3VEXH710dpbFP2W4+tp/bR5JX9Ojs7B0E+fLV9ooYYquDIPE/siJjRbGy9Fkw7V5iIUI724qXyiOpLOfQKgVfBF7vxhUXttCOUCSfTRdc67P+34iV1/m2XIijPeOCB4/P/hjgeQxmbT9PEqINwMHTfMEStXGPKfIgTYRf3HtkHy6VwKLt7nfwhp7tIFjrRcmQORH53GpGA5nriZit93mg5xJMHlrkv+HKK2VYLooed6kOJai0MMoDnQBb2FSrOlHxVmkjY6GAdRt/nTHtkClz1yOn+8URSkBwoMjMlZGlfLrWUjI+u1spQG136pXXQLl2WmsdqefVibFqbstx5NXH/HrgyJLJyWVmV3USqDpUUp6wR15wTdfPNEbMAIC5jXhw1B+N7PHVG96ARoDzBbzYqhikTAIUVqydvxHj9yQRaHuf3bLqe7xJ4QW1Umq1duchEDU+VF/ranH36SWnHxoA+7fGt0Yml2Vj0YyGtj7z8Hb+vNxnih8IWW/jA4O7i5oM0cipbUaSOxyqKm6dvZm8rSA5AWCvOU4ycTo1npLx3EFVk4PXrGsFMBUrdj9/85/9hjlLwApR6Bcccr7ppWxxIJCwjlfa0R9DIsWdBhLc1W4HAvFdLl7SksRlhxX3STMRJ9YsDkZECIJDAun
 TUYnl9r5
 ywyBPW2rA374UhZ2l8nxzkE8vQqyxB7+/7528C+8J6fllDW0m4rUIjUkTLfTJaSWfSFoIByDUVS6PEWlgXUK71biQOadCk+A5RJ3cK5jLUGtmNULet2m9vibBWjg6oEkOKGxTE6LZNgNGhkhzw1i7JPB2kUXZ1ilVmBla0YJdkmNMw3WCY+YWMNwdOBdxnUWRYxXWXE2JRCMqNdmI/OnshovaJpfDx6MNNFF9xhiDMLZ8L74UY7/WStS1FlATM1kDv94WEGVF+bhTMshi2rFO0ywLUdRxEaGTsm56JgEqvQhfvzyeTSqLq+GPWxylr430S5DBb+B1o5vZTmAi9H+uZaYP3dAtSRlwrfGhHMxAG2hYDPMMe1WgZcIG9xjrtnklKOFuO6tbFCnDnt7IxJjUrecwPNsXAH6oNBl8KYgMvfr9RJLtzsJhkxpa9uubZJ9MZAJGhInSa1nWDzi9OhWaOe7rJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 07:58:29AM -0400, Jeff Layton wrote:
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

Doesn't test_and_set_bit() return the old value? IOW, if it sees that
WB_start_dontcache was already set it'll return true? So you can remove
the test_bit() call, right?

> +		wb_get(wb);
> +		need_wakeup = true;
> +	}

Actually, I think you can rewrite this function quite a bit:


> +	unlocked_inode_to_wb_end(inode, &cookie);
> +
> +	if (need_wakeup) {
> +		wb_wakeup(wb);
> +		wb_put(wb);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(filemap_dontcache_kick_writeback);

void filemap_dontcache_kick_writeback(struct address_space *mapping)
{
	struct inode *inode = mapping->host;
	struct bdi_writeback *wb;
	struct wb_lock_cookie cookie = {};

	wb = unlocked_inode_to_wb_begin(inode, &cookie);
	if (wb_has_dirty_io(wb) && !test_and_set_bit(WB_start_dontcache, &wb->state))
		wb_get(wb);
	else
		wb = NULL;
	unlocked_inode_to_wb_end(inode, &cookie);

	if (wb) {
		wb_wakeup(wb);
		wb_put(wb);
	}
}

No?

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

