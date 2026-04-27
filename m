Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EE6FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4565D6B008A; Mon, 27 Apr 2026 08:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405926B008C; Mon, 27 Apr 2026 08:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0326B0093; Mon, 27 Apr 2026 08:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEF36B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:46:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BAAF1201A5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:46:36 +0000 (UTC)
X-FDA: 84704309592.12.6BAC64F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB9A21C0009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:46:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y6E9ltri;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0I9oYAuq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y6E9ltri;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0I9oYAuq;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777293994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PD32WU/9Tw1lL09UECl6fy32VpzfuwRNALZweCagXW8=;
	b=3zTOisfvX6tZx+oeagpHMkaNvQLJRlpweIlTmxsKZX+VhHQxEtXUF3Ccrai18MxyVQ76xd
	BGocF+BclNdBZjkT/RdfPJ6OChyPJu0VCQ7ZLSNhgCU/VY+25yIs1ZZfRSMxIUIFq579NP
	tob0fhG9Ev3SU9/kOln66h3TfoH3IfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777293994; a=rsa-sha256;
	cv=none;
	b=4bbM/OyA62C+Nz0ZMrwmVwf9RQZPuWBkd1N2HTCXk0iBEEGpYOln92DxAS0eeZMHbMusjI
	EJU119RunmwmgPP6TbasJT/fP0VYfBx8TnwgJ9HT9BZ3Nj2oZzoBh1mO3YSs6pVL7XTsB8
	P2iGmhhl2m5C5ZIuONOBox3rN/U6rNs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y6E9ltri;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0I9oYAuq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y6E9ltri;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0I9oYAuq;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 062F26A842;
	Mon, 27 Apr 2026 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777293992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD32WU/9Tw1lL09UECl6fy32VpzfuwRNALZweCagXW8=;
	b=Y6E9ltrict6s8aFYhrzz3ERlVvuCGh8mxmOxpJT2FPmLppe9MeqnK7RvrGqG/i27NViWpQ
	Gt4styeM+URnFkTLTaxduh9YsvnjDY9wbk8fBRKoD/uq4VVbeG60IumaTYkZN4ivsBCYOV
	TSTh0U6oo7Yn9JE9OyaMpvJZGvlH5xM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777293992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD32WU/9Tw1lL09UECl6fy32VpzfuwRNALZweCagXW8=;
	b=0I9oYAuqjRzTzsl/t/DyRx8PNyEbpNgZmExj+2o9yz7U4IZyuh7mDwoTVhNTkxPMpOhAvD
	OkxSAQLbWvxErwBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777293992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD32WU/9Tw1lL09UECl6fy32VpzfuwRNALZweCagXW8=;
	b=Y6E9ltrict6s8aFYhrzz3ERlVvuCGh8mxmOxpJT2FPmLppe9MeqnK7RvrGqG/i27NViWpQ
	Gt4styeM+URnFkTLTaxduh9YsvnjDY9wbk8fBRKoD/uq4VVbeG60IumaTYkZN4ivsBCYOV
	TSTh0U6oo7Yn9JE9OyaMpvJZGvlH5xM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777293992;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD32WU/9Tw1lL09UECl6fy32VpzfuwRNALZweCagXW8=;
	b=0I9oYAuqjRzTzsl/t/DyRx8PNyEbpNgZmExj+2o9yz7U4IZyuh7mDwoTVhNTkxPMpOhAvD
	OkxSAQLbWvxErwBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E934D593B0;
	Mon, 27 Apr 2026 12:46:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2pnpOKda72mjKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Apr 2026 12:46:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A7D6FA0AFF; Mon, 27 Apr 2026 14:46:23 +0200 (CEST)
Date: Mon, 27 Apr 2026 14:46:23 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <7567kwydg2x7lp77xloxk5hjaar3k2xvbqqaro3k4hu4fncww5@yo2rmkrxlhkv>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
 <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB9A21C0009
X-Stat-Signature: u1emjsri7z656m6hcxefm3da5ejqkugh
X-Rspam-User: 
X-HE-Tag: 1777293993-4776
X-HE-Meta: U2FsdGVkX1/gPDLL69Rdenlo7WzkikmE2puFyAvbrIiwy9Uvb7+7QKX08YOv6ulpU+KoVBTp6gqytwSpGXWG+lgRudfrjhDbDC7cR00xhPpjrl+aWj0zce9YSBBDqUAZ5MEf0FsopNXAkywnwktmDH3XzyCzzbW59Qio/LEPHOJO4WUSHarYXo1U9tSidkdpD2e/Jg9Va2fp45pwqz1oiM29X0gqpKXCXqFvYx/81Itt5tQ4PNS7ncRKfs/BlByAoR3q+79TFhdYOeGLGfYHJNazJ9jH1kEgSLsW6sobLH9kYRtRMcbbtxgX0jJagOTauX8miZwRFXOsjyk3fkidqynwTCCgVFnZVTz0uB01CpY9/LWbvLQ3DgqyKBumC+LmQ1ZZKORKZscTkSrsnGX0q7QKBsWU01CdJay1T6WUIDrI6nchqdoHiPPkUDhZ+0vpAA4OhmPNd7m+YXIAPh916SvnPlpgkivwoyPjz612ewEpacD/rqKfB2jfJXRNWznns+3LWZnkTYUehO2XBee99jvk5v5PiwkbXt8tDm6fmH2wGLZAh4FBMjXaBWMWPebRJEjh5gvGl5zI7irG40HpnjaPoEMMC15NspKxazDRZ5WhuD8Gjn8KxqYTJpDS8sQuKF85E/vZavlkhzrEG2i6cr9NZo0e0Fl82V29sUu8GgfvWviy3aiaGApbm+M/IjIzngaghWUe1DeA4+duYg+aCBEUP2ZTnX6wp6P3zEVIYc2xG1VhF6VNehKBwmlrWo2o479hpaZi3VAk6yRSuIpIZRqkl8agv9Aj4/Oet5RK/O5M4nOIqsuHg0wKhFmSHppglW+pmw+33fSjKGDC01ORwy/vuC3BpPA/lpHPa8v/rdHQeu7M21K1wmxad5/xW9+mgBLDAZEIWYFswkvF2Kd3aIwlCQs9FFqPHVIs0sl78aEIN6GVs5QNXMQO5HolquwNkh1dj9AFyW5X0DFqpOd
 j+7ImKjP
 GX2JUujxxTomof/YZwzZWXojArFSGNKobJKCToyvTAphrCDjQFeTJwGYtlhTk8x8lcsrqPZJcS/uGQX0J3BJpRqJusz2hQ8lDxToISp97/rtpkd5F65+9CIJjEB3FBQzd+jgmjvtp1o+SsYZpAJCqhraY/w+R5kmB36BdWu9fxdGoM8HzLn+EQGmJ7yUo+yd65qOD3xV2F1Ko+HNSGzxybd5URAZ7O+kNS0f918zhXenFil6rI4YrOxQn13mdXBwmlETNsSYLKZaVLm0U6r2TouefhoS/O+rr/oV6sowrtT5pDQXuvNpr2WT4xpq94UEQoVqzI/9UFXkPFmKF3dDdWazoEt5/AKGc30bAoAd08b0XvWqp7t03K6MGEh9mnwplpeido+JqgYWyuoZ/PfDTZx8Elkwuz2pEldbWA5Ow1H77eC/qbWcjTjHardXh4D98nrQ83HTfdZ5F0PKlsy7j/J0AlG3F1O8HefiZmIVJYnaV5kpSc5GjUzIUgC9aMqBq+f8y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 26-04-26 07:56:08, Jeff Layton wrote:
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
> the new NR_DONTCACHE_DIRTY counter to determine how many pages to write
> back.  The flusher writes back that many pages from the oldest dirty
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
> dontcache-bench results on dual-socket Xeon Gold 6138 (80 CPUs, 256 GB
> RAM, Samsung MZ1LB1T9HALS 1.7 TB NVMe, local XFS, io_uring, file size
> ~503 GB, compared to a v6.19-ish baseline):
> 
>   Single-client sequential write (MB/s):
>                        baseline    patched     change
>   buffered              1449.8     1440.1      -0.7%
>   dontcache             1347.9     1461.5      +8.4%
>   direct                1450.0     1440.1      -0.7%
> 
>   Single-client sequential write latency (us):
>                        baseline    patched     change
>   dontcache p50         3031.0    10551.3    +248.1%
>   dontcache p99        74973.2    21626.9     -71.2%
>   dontcache p99.9      85459.0    23199.7     -72.9%
> 
>   Single-client random write (MB/s):
>                        baseline    patched     change
>   dontcache              284.2      295.4      +3.9%
> 
>   Single-client random write p99.9 latency (us):
>                        baseline    patched     change
>   dontcache             2277.4      872.4     -61.7%
> 
>   Multi-writer aggregate throughput (MB/s):
>                        baseline    patched     change
>   buffered              1619.5     1611.2      -0.5%
>   dontcache             1281.1     1629.4     +27.2%
>   direct                1545.4     1609.4      +4.1%
> 
>   Mixed-mode noisy neighbor (dontcache writer + buffered readers):
>                        baseline    patched     change
>   writer (MB/s)         1297.6     1471.1     +13.4%
>   readers avg (MB/s)     855.0      462.4     -45.9%
> 
> nfsd-io-bench results on same hardware (XFS on NVMe, NFSv3 via fio
> NFS engine with libnfs, 1024 NFSD threads, pool_mode=pernode,
> file size ~502 GB, compared to v6.19-ish baseline):
> 
>   Single-client sequential write (MB/s):
>                        baseline    patched     change
>   buffered              4844.2     4653.4      -3.9%
>   dontcache             3028.3     3723.1     +22.9%
>   direct                 957.6      987.8      +3.2%
> 
>   Single-client sequential write p99.9 latency (us):
>                        baseline    patched     change
>   dontcache            759169.0   175112.2     -76.9%
> 
>   Single-client random write (MB/s):
>                        baseline    patched     change
>   dontcache              590.0     1561.0    +164.6%
> 
>   Multi-writer aggregate throughput (MB/s):
>                        baseline    patched     change
>   buffered              9636.3     9422.9      -2.2%
>   dontcache             1894.9     9442.6    +398.3%
>   direct                 809.6      975.1     +20.4%
> 
>   Noisy neighbor (dontcache writer + random readers):
>                        baseline    patched     change
>   writer (MB/s)         1854.5     4063.6    +119.1%
>   readers avg (MB/s)     131.2      101.6     -22.5%
> 
> The NFS results show even larger improvements than the local benchmarks.
> Multi-writer dontcache throughput improves nearly 5x, matching buffered
> I/O. Dirty page footprint drops 85-95% in sequential workloads vs.
> buffered.
> 
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

One comment regarding how the writeback is started:

> +static long wb_check_start_dontcache(struct bdi_writeback *wb)
> +{
> +	long nr_pages;
> +
> +	if (!test_bit(WB_start_dontcache, &wb->state))
> +		return 0;
> +
> +	nr_pages = global_node_page_state(NR_DONTCACHE_DIRTY);
> +	if (nr_pages) {
> +		struct wb_writeback_work work = {
> +			.nr_pages	= wb_split_bdi_pages(wb, nr_pages),
> +			.sync_mode	= WB_SYNC_NONE,
> +			.range_cyclic	= 1,
> +			.reason		= WB_REASON_DONTCACHE,
> +		};
> +
> +		nr_pages = wb_writeback(wb, &work);
> +	}
> +
> +	clear_bit(WB_start_dontcache, &wb->state);
> +	return nr_pages;
> +}

So this will end up splitting NR_DONTCACHE_DIRTY folios among per-cgroup wb
structures based on their writeback bandwidth. This is a reasonable thing
for global writeback where the bandwidth more or less corresponds to the
amount of dirty folios. However with DONTCACHE I expect big differences in
among NR_DONTCACHE_DIRTY among different cgroups not necessarily
corresponding to wb throughput. In particular if you do DONTCACHE writes
from one cgroup and normal writes from another cgroup this will
systematically underestimate the amount needed to write by a factor of
about two.

So I think the stat should be a per bdi_writeback one (instead of a per node
one) which would avoid the need to split the value to wb here.

								Honza


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

