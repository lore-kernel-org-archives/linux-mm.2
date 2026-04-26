Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD94FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF676B0005; Sun, 26 Apr 2026 08:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FD16B008A; Sun, 26 Apr 2026 08:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7901F6B008C; Sun, 26 Apr 2026 08:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62EB76B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:29:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6403C1F3C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:28:59 +0000 (UTC)
X-FDA: 84700636398.22.F874038
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 086E2180002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:28:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pd/oI2vF";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777206538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NoepT3Q0mYj7Eh9Qf9FM/WnqY0umZ1qAEGlF4rdBbJI=;
	b=sGMXmDlfJRUwuuGM7IwywBU8XCHAO7guRMQA/N+tRUzmTXMTzdj9yvzPMDzqH8vHw6gMR3
	X62UDOXIAY7q33rSB5z1n34iDmt59MfCn16tM81diZKfTTMsZq5n/wg3/nMKmC7lroo9o+
	25w1kYNVLfYs6fbK0I7dHfQMSEJKsOI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pd/oI2vF";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777206538; a=rsa-sha256;
	cv=none;
	b=lTzdn+546VrfrGKA2CuoDM/X1lGsSEg+i50V6iycRrALEHLlFMlx+SVXBELm7mLlQZMZte
	8tayeJ/8aaIAbO/5MmJskYnotIQL/R2o8CYSBLp3e48vsDiwTjVwnLE7DMbrmJLht7pNUJ
	9qvBWiZ5dtPAFqYsxTfGEljaj3ebVcI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5E3543C20;
	Sun, 26 Apr 2026 12:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC24CC2BCAF;
	Sun, 26 Apr 2026 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777206536;
	bh=02nQF9ZDfAItP1KXDmKfzZAP87rtizrXoyjxQHVV1Lo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pd/oI2vFFB+HvfCXWQ9ze+KoA9goPh+V2E3V47FrYlGPUBFTWKP5yPWjE+3q4B+vF
	 AXILaQ5GKEgCuYadV/AHE82lxQFGnBbR9Xikmm/8GYi6uV9Woh5zSzM5vRlzN3/HTo
	 /ngwKUrDSYMY+RdfdcklSJdbNM6LMt+yQ530jXA8=
Date: Sun, 26 Apr 2026 05:28:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike
 Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ritesh Harjani
 <ritesh.list@gmail.com>, Christoph Hellwig <hch@infradead.org>, Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-Id: <20260426052854.8372fb9d4c616f16a8aa0a0f@linux-foundation.org>
In-Reply-To: <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
	<20260426-dontcache-v3-2-79eb37da9547@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 086E2180002
X-Rspamd-Server: rspam06
X-Stat-Signature: sdfxn1d4hf4dd51kbr3ng6au3wro3wxm
X-HE-Tag: 1777206537-668870
X-HE-Meta: U2FsdGVkX1/oCXrkdcYDGdLHVLfqYA4WPcNatZc54UOFx6Ds0l+wIQl938VipW741D0vmuaXSfrk36q8ebL7oiGAN/BweSOwX1BknoZm2s6mfv3WZxdZcsGWH9QGa87VaHHjMRTjb6T86/ddqe1PpWeaxG//RY2XKKs8MjAqREYulIDhjTr3zhusx5ylwAYsNnPChNwXrY8v7l9bfy4RqbERGb3rKlgmNJW3BPgJSD/HBjqxEwFFQLzSleafHr7Xm9S0rolPhygZgwoIIj0WMzZCXy7h7iMWRQoXd0PI/CJ6JroqP5ocaqrQtiAuJS9SpGYQAxSrUsLjSVwqMn2CRS/hCgMBgFEJYSBwyLFCKeogjCrkIgt7rr0JmqaMDGKX87NjPgfDjOSjIWkSn3rVz4gSjkWDY+0ITQl2QuAHmKaDt592VVspneBZ1bSAbryTqF9I16AoFAXIu0Q3BdC9ojab5XlNrHC9WLNJseUxyUfRbCf4kuCiTYKlbGVEN3urjhrY0yFA7iEz1vID5iOLx9sUFXyfN/yr6XtlSQIA9kEfxr4it4H+98/WmN2/6iFT1def/iM7JXPQTF3D6yjs9hQ2PyFD+5DoFdjpUZ4hZOYIgqZnMkG6PqQ4keibBolss5xh7hOt3QQfTzw+cf3p66b74rkSnGeQ16uTHvxQ9rryuKfuijTb+cplh0Kh8m3+0++HlARA7nagwbk9uhSLYDIudcpq72MLFpMhEMSNR19XU2q8+FC+yvbLpdpd0hFA4OeyCP4QrX2I7V6t59uQlHqYOH+l4Ygs7/T2dQQgzS7+FaF9zC5lAfOrblpCghTPhYeYWkddMR+U/NiTPAI2SA+65uM3b/q+CkY8kOgDrHeMJlVMMoAoKKa+7x/XLAjGn6ns1prkB9x44V1o4jhJiNOo6xSFtGglNNIlwzghsST4YX/aLb8pnY2ktrKtr52k2Kf28+AxKCK5wfYguWd
 qj6cETDG
 h5JlxEioZqX6jaaVmpYEtCzZIMkqX0VYwm4QRbSuzrNsuDmrbJ+1JVjJ7tMDHDnt2J1dDKxRA7eMV41wwAaqX4GrZIJuWlpyHbVHnM4UHWnWChaEMMb9RtBnuFE1L6whM5fG+LSmcMkF9YMcDUMo/hwM1rccDiqaxT2Q8ctaB5DRnSXJIHxyXSC5q5ePVXMoDS7UweQy3HWatdaG/pd29K39XR4c1L5W8kM1jIRVyx+/PHFJzYpLrL86AzGsc3QtN1q1lnGkz0ZVoMWCjmMx2ULhcFCE6FVel7WWUHLfJXZG4Q8srfR+sJaD86g1tKbXA+aLoUcgqaDO+I8DNy5tZC+UAlZjQpoAs2NxuEP98hOe6rRkbIjZFSaiCgsF41LNVefDk3oH59P0XYqRVXDDAbaVBk/QJXnLu+YuS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Naive questions...

On Sun, 26 Apr 2026 07:56:08 -0400 Jeff Layton <jlayton@kernel.org> wrote:

> The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> filemap_flush_range() on every write, submitting writeback inline in
> the writer's context.  Perf lock contention profiling shows the
> performance problem is not lock contention but the writeback submission
> work itself — walking the page tree and submitting I/O blocks the writer
> for milliseconds, inflating p99.9 latency from 23ms (buffered) to 93ms
> (dontcache).

So in the current case, when generic_write_sync() returns, all that
memory is written back and clean&reclaimable (or freed?), yes?

> Replace the inline filemap_flush_range() call with a flusher kick that
> drains dirty pages in the background.  This moves writeback submission
> completely off the writer's hot path.

Whereas after this change, that pagecache is probably still dirty,
unreclaimable, waiting for the flusher to do its thing?

So is there potential that the system will get all gummed up with
dirty, to-be-written-soon pagecache?  Is there something which limits
this buildup?

> ...
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

These results look ambiguous.  Sometimes better, sometimes worse?

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

Ditto but less so.

> The NFS results show even larger improvements than the local benchmarks.
> Multi-writer dontcache throughput improves nearly 5x, matching buffered
> I/O. Dirty page footprint drops 85-95% in sequential workloads vs.
> buffered.

It sounds that you like the results, so OK ;)


