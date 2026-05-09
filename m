Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23A1CD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081936B02CA; Fri,  8 May 2026 20:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05A056B02CB; Fri,  8 May 2026 20:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1D16B02CC; Fri,  8 May 2026 20:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8E966B02CA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:20:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96B311C0F73
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:20:18 +0000 (UTC)
X-FDA: 84745974516.27.0A93721
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C59662000B
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:20:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1dDhbvF;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778286017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xB1dH1h4NApUS9pDhHGy91E+sFibpguYlPIQl/vgPnE=;
	b=yN8sNNuVaoC/sb8D8LS1FH0agAeZnGKZKIJ5hKO5oRMhRaDjpGrd6YqZ6VOhx7ta/zTXrK
	8VFL4VxOrQS8+T533f5dPf+yDy5Y3jzeFLW3AW7SSMNelGLxizurT0lfOZur3QEJ3/vm4s
	BzKgL4yb70sGqhur9PEoDtGG234ht6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778286017; a=rsa-sha256;
	cv=none;
	b=QEfC0ed9qu6LmIyWB6YU2HbqwTS5gOiq+h9TmAuaOmxRKolBKI3EeOUBYMtQrJRbY2m1lZ
	sZZAm+JVrgngnA2fROxkVxrY9GDVioUHyzsS4m2XRjMidOf+wflck75tGy+C3nOte88Gjt
	5Xu8yZgOYAfsjM7RKBoy05KG8ZemQjs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1dDhbvF;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F19340D8F;
	Sat,  9 May 2026 00:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA10C2BCB0;
	Sat,  9 May 2026 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778286015;
	bh=5zM3V0nZSU9IeZvcOjJ3n2OX3NPDX1oav0rcmh7h2Xw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t1dDhbvFuFX23JsSoB5Lyv80NW8H46rIxg7hj0aDBu4xB9SceckWgig2M8wuG76G1
	 5eQFiMikbZQluIe36kjPj/7+1XLSgwrOxshHI8t1r4mkfSyNJtVksmt1bCysj8vEeR
	 JbT7uThDJR1SwJJd4XLLeIWh2eBPfBHB5+TqZxPE=
Date: Fri, 8 May 2026 17:20:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike
 Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ritesh Harjani
 <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 2/2] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-Id: <20260508172014.8265ddc0220ff7e4d54674ff@linux-foundation.org>
In-Reply-To: <20260505-dontcache-v6-2-66463805dd6a@kernel.org>
References: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
	<20260505-dontcache-v6-2-66463805dd6a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C59662000B
X-Stat-Signature: tnajduxhyffp79bfx615o4kudny3a8n8
X-Rspam-User: 
X-HE-Tag: 1778286016-519812
X-HE-Meta: U2FsdGVkX19HMvAWyrlNaNfKwdFFjExKf7HmU3qCo9cx/P5ZVd1cJZ17UjBVr6Ob/XY6DF2Vtkyl9cKWDJl400fOBm3mDILy2Y+ZuG4bUy56pKyYn5PTcDBNLETYcHqVWieINmA3WW6jgU0tfgc7NjUvf+RAfuMk+HR86ogsmW0smA1N3/Yzy7nVhxq9+tbxT125q5mRp0FItdOb0dG+2NZ1qNbR4070kU/YrA5Ck3rAkcKzN59BTd6u+QwN//P8RaO/yEe3b10Yiqdof08jyghpYReviLB1CCVFPmxlEV0TOYETrfFzAhnUxNXSB5tcx8gLqlotzg3r3OoO6bPChrcMSjgXvaxDt6AH3BP1biiS9TkBhc9D2821CTMPo9EwFMGkSNLX8QcLie+6uNiaTkkhDsR6KJCK0DOykAH9lXBRVuVUsx58S2d3eK9FqISOqMo2T0j+/pn28e1kcDXfr2+1n2mxZq3FHUXkXqO+ceT03NoKC/ymCFmQqJZKxz6LGWfaiBFiVvAOfgHDh62KwWIKQp+kv1cCLxZJwfpASqdkUAqLk1O05dm7nEn99F9TIj7qp9Nynd0QxJFqDjFVc1jQLtle1lRS8jhWhn+rrZvuM404L+UyLF4cseLWAWuH58HSlPUy7UcTzQu7HgVBE0D5TLlY4hFPi6zs0TmWCmcSTFGchjXAP3knJlETJi8ob7qDu4HKZNG++e8NJFPgaS+4RzwgQ4n/bGe3EU1q7hqnb2uY313mZmI2I0KvbJnunqFyHgk6S9lgFkmXeDQqyi3EmP0fLqivNFmhpteJf0WsevTXGkK1cJnye1nN03rtEJVahZPJwla3TU4ZWgEkt0hy0RSue7hDYX6OYAstaoctqXQjmrZRtkZw8Zf+oGSWBuXJIKFMF75HF16PiPWqdZptw71pEFcV4riqKUpv8LndDYAp6ks3n+uuyZzOaR3cmdakXApjTLnh4zmk8wf
 4pnFwneo
 9fGVnMcZoKj5F/AE2pjGK/qPc6txL4XeXaVT6NJf8O4N2sSzWpijigNjMu+V4SwCaPLarnW1tkFDK2joJpqeODMz3LaUOsR4PedjQU61ip+TE9QC6/yH5DrFe9cldo7yVo2GPSRp96BJMX5J/y3jgCzVfYZ6YVz9GoFNzE2ig7znwmIrA8K41qd4+qWrfbuBBY9yKGEPvC9i24XwrhKMgs6xelJZINp662EIirfaB85gm84uIQXLyrpUfzfzH1S33fVIkGWT6v/qvtFOtIYKdZY+8qZHBcKK0pvQZHRBNVgXepcqdaibvt48NiM/cP4LSp/5Y6mxQh7vqesvZYpgmpMWZwYFOr5iMtEgu4DP2nltz539gUapmGrgND6z+GO/dfN4HJsy4UvOmHbk4q3SUUwGLyIbDeEJMJ38sLtXDcpIAdhrPmPp2cmmgmhwh5M+pLmY1L3JJ6f8WZu93G9ed0QksHCT+7W7EcpWc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 05 May 2026 20:59:49 +0200 Jeff Layton <jlayton@kernel.org> wrote:

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
> ...
>
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
> ...
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

Geeze, is that the best you can do ;)

Sashiko seems to have found more stuff:
	https://sashiko.dev/#/patchset/20260505-dontcache-v6-0-66463805dd6a@kernel.org

