Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677FDFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 18:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B4F6B0088; Sun,  3 May 2026 14:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63BD86B008A; Sun,  3 May 2026 14:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A8B6B0092; Sun,  3 May 2026 14:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 442986B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:17:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC19B1C1434
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:17:39 +0000 (UTC)
X-FDA: 84726916638.24.5079539
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5862820003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:17:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jgUTA6M0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dLFIdEgZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jgUTA6M0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dLFIdEgZ;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777832257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmFj4O1Es2noDuOq46EGI+8PrLmWpzUtMFyktWCCsH8=;
	b=G9N4IDiJX4rNEQRQp+AFqhlG5QAZxL3SSaiCbB/Sw3Tcm4Hfn+WwId5CdxuqcEWdtdihsD
	fAilz7coHzi2IAwRt0e5kywoBX3J+7AQX5ywd2/PYKDNNE9NUyMHNbPD0EOPEMcBsJ/WDS
	oupmF4sEtGe96J/a5nBCEOwlu1+PUak=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jgUTA6M0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dLFIdEgZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jgUTA6M0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dLFIdEgZ;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777832257; a=rsa-sha256;
	cv=none;
	b=X1NdyvNFmBQuODZiBTXUkCaI1wrCrdM8WEHC62CoEhil3zlByIOlw6+cTy2wIJYqnAEqv8
	cXAZKTNvPfSJmdyLYCWKMXqc5df9C7w5uOUKs711RM14Wwk6RsesYep8LptARSsWRAcOE6
	b4l9QJqvQrr0uatIo+QCbYxXZ0zNuCY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A50C56AC16;
	Sun,  3 May 2026 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777832255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EmFj4O1Es2noDuOq46EGI+8PrLmWpzUtMFyktWCCsH8=;
	b=jgUTA6M0EiYoQ2T58qm2XgxG/B6DwUXdDBJcRb2FV1qSABBx8rt926TVPlE7Po5McKyP9J
	l3Qjbt55oFvdGZFX6FjW34PqaUS3TuGDw/l216nad0/zLfMDLr6wx292PyzgQ9+gygwLaw
	CKHde2S6Q24M+aY0aT8tnC1pUC0cLAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777832255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EmFj4O1Es2noDuOq46EGI+8PrLmWpzUtMFyktWCCsH8=;
	b=dLFIdEgZToLYUlDU6J1rBQT78DPq9pnewh4QgyFVIwizK8wzxDNGY8dnRDTDEZI7E0Ct+s
	9BICQbhHD2w8AVCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777832255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EmFj4O1Es2noDuOq46EGI+8PrLmWpzUtMFyktWCCsH8=;
	b=jgUTA6M0EiYoQ2T58qm2XgxG/B6DwUXdDBJcRb2FV1qSABBx8rt926TVPlE7Po5McKyP9J
	l3Qjbt55oFvdGZFX6FjW34PqaUS3TuGDw/l216nad0/zLfMDLr6wx292PyzgQ9+gygwLaw
	CKHde2S6Q24M+aY0aT8tnC1pUC0cLAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777832255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EmFj4O1Es2noDuOq46EGI+8PrLmWpzUtMFyktWCCsH8=;
	b=dLFIdEgZToLYUlDU6J1rBQT78DPq9pnewh4QgyFVIwizK8wzxDNGY8dnRDTDEZI7E0Ct+s
	9BICQbhHD2w8AVCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8444E593A7;
	Sun,  3 May 2026 18:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JnpOHz+R92kmFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 03 May 2026 18:17:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C0932A0791; Sun, 03 May 2026 16:45:58 +0200 (CEST)
Date: Sun, 3 May 2026 16:45:58 +0200
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
Subject: Re: [PATCH v4 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <oykxd436yv47u2yojrwrp3qdtzekq63hanezs6bwlovot6il2a@266nl5oqnnam>
References: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
 <20260501-dontcache-v4-2-5d5e6dc71cb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501-dontcache-v4-2-5d5e6dc71cb3@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: rb71k3txh884fsdhkrb7i7jmg6bx8w5j
X-Rspamd-Queue-Id: 5862820003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777832257-139601
X-HE-Meta: U2FsdGVkX1/I3chO++068A+YawduM/gpKPD/HDQhBkoBYW+e26unRRsnUajoVdOR3VMiJ0Me/gI2/sqDJbUlz9y9IJ7ygqmyoLycXLEIaZTv43VS45zV1aEm+G83+tQoKFhudo668ygNzFf1qVvd9B/nwioXfpEunLK+f5QzdnSc62HjV2sZ27pHJKRUfIhJy2HP9upPJ+7l2F60rWO8eKtM16UV6Zj3Rh8/gK5QnskXrPzSLu4DwaJNv6ainTRjl1WIuutpnXOGd1XPd2OAYXSVCWLbxcexoO1FxbI/NNp8v6TibI2TTlD6BUVuEXC3EImRQaKPpRfP6nKl6onxHSZS9KcgJlLEtQbH/cEmNv21+wKjahjYaXL52kD5KPU7pItYrPEn8a/JC2eHPG2ijbFtDhvi9EFss3FhHwUUchPONsu9cMx46KZ3fCWkZNpHpSvavXCQaK9YF6mO5blFvLlFYuCtdLqKlpoOiFRrKTXnD4zaMWWEqChTaIxoo2x6dtJQ0SMCOp8+tlNQum+w3cXnmUr+lCfjifdwWX5KOcmwEQqJE5CjSybZJs6oc8cFfhvW9pU8SyEoHsa3Lt3T5axefnNJtjr5Sb0u7UuBCq95VtQoQOJHf75hqp8bIFH2LsdsreuQkUlSGGNX13el72oSCF2t+X/1GCnMCqTtuzn8xo4eK+yP2DtZYQoqEJndfrRMwOYDuIs3jhFybMFvYY0QIWzgfRnzFxgTydxS1CYgFzR/pPYOR/ycq7Ulvr9kSmbo4oqfTGho6trGDz0XsBsQdpX/Ja84SXtLtRfTwVhg6kn8L4ivsu0C6/smmeiPtC/VuZuqUkSWoVFat8Ci972vJ452l0SwLFQ743gKW58mMYY1sD8tHf7U3D2vrQWXAxLdjkD+EdzFYaf6I2CF91NPJhHi9pa2rOlfTTQTMGf74UEiE9D699qW7lC7uwV6GH+Kg8lZxrwjsvwC93l
 vQ/TEbRH
 FY+XhkWEkwg3n8PWUX5MGaDE/W960MJYGossD5bu8IyFQgybqGoKCylSR9Al+pATTcv4ZF8UPn5r5WlqQ/52DD4hpqRLqZmESkQCpGtuBuYVONJzsUEMYeeMqRmO4EbJqgWeA1EB9JbuMBUTXUHhKvQVTgYBfGd9mVen42R1AX+oRpZgMGEtAZcjWvZwj8zBkmJnAMYdv9/Vep2O4SQi23AIlDJrruIcuObte/tOoXFpWaa97JAydi5XDzyYv0dphHX2buyNr2wV0xYDMpVeGpMXMqtMzlUbSovm2k07brdiN8lJDHvHvBhp18zedgWMvsT2/eiU6IKqlWLWHOvKR3RuOHZKd2fPv+XAOLjBqkAOegFNkLm00gJxPjr8CJlWg2fTRWwH53qNpH5WhlAR7Zn2KHRNyZ89NqWzRxEKVUAuVEJ3rOp7OhA31Dg2ArdOnUYYxnpIlWAXFdSgFSrJqPtZL2TCC0SL7yQbIZ9MI6dJdtyAz87xDOcTjZtzMiVKMt2Dy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 01-05-26 10:49:36, Jeff Layton wrote:
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
> allocations.
> 
> Also add WB_REASON_DONTCACHE as a new writeback reason for tracing
> visibility, and target the correct cgroup writeback domain via
> unlocked_inode_to_wb_begin().
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

Nice and looks good to me now. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

One nit below:

> +/**
> + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
> + * @mapping:	address_space that was just written to
> + *
> + * Kick the writeback flusher thread to expedite writeback of dontcache
> + * dirty pages.  Uses a dedicated WB_start_dontcache bit so that only
> + * pages tracked by WB_DONTCACHE_DIRTY are written back, rather than
> + * flushing the entire BDI's dirty pages.

This comment is a bit confusing as in fact we write arbitrary dirty pages.
It is only the amount of pages that is influenced by WB_DONTCACHE_DIRTY. So
I'd rephrase the last sentence like: We queue writeback for the inode's wb
for as many pages as there are dontcache pages but we don't restrict
writeback to dontcache pages only. This significantly improves performance
over either writing all wb's pages or writing only dontcache pages.
Although it doesn't guarantee quick writeback and reclaim of dontcache
pages it keeps the amount of dirty pages in check and over longer term
dontcache pages get written and reclaimed by background writeback even with
this rough heuristic.

								Honza

> + */
> +void filemap_dontcache_kick_writeback(struct address_space *mapping)
> +{
> +	struct inode *inode = mapping->host;
> +	struct bdi_writeback *wb;
> +	struct wb_lock_cookie cookie = {};
> +
> +	wb = unlocked_inode_to_wb_begin(inode, &cookie);
> +	wb_start_dontcache_writeback(wb);
> +	unlocked_inode_to_wb_end(inode, &cookie);
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

