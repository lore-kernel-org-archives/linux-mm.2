Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD37FCD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 00:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDBB6B0005; Mon, 11 May 2026 20:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4586B0088; Mon, 11 May 2026 20:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1A26B008A; Mon, 11 May 2026 20:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6C06B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:01:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C47C1202B9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:01:23 +0000 (UTC)
X-FDA: 84756813246.03.D1F2BC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4FA9640010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:01:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHJl1G85;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778544081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f42ema8NjpP2wCtvqIrhe3GYY/3gh0Xq9PczyIcpFZs=;
	b=0VMB45a9mOYiOBFO+JbrTOnKRMKI4965/NPGnTsWvp/cc0EnsqvGgs9BLM/IjR5mE2Apjx
	OQMycaq4wQ+jBGuwtVBo08JpVLUXj9F/Df32kMCGwdySuTEoSdritxkirGnVm0XkiWKSby
	/tHLMmYxMwy6FrxTjEYVqegTHU8QUjI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHJl1G85;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778544081; a=rsa-sha256;
	cv=none;
	b=n+mJ8G9d3sO2oTLkYY9HGFykDCYU1HnC08o0qx+seI8Mk8E2nZrMUyDEkhKMeFRkOsZ5g7
	FVXB3OF8YyUdpEYBhbKujOV+jHLFZOy9eNxJmywIR7Svmlfdm1hdr72DTQrO446dOjb6sS
	mNqeUsHS0K6KLaLE5W0BPLCyEK3QAKo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 232A941A9E;
	Tue, 12 May 2026 00:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF3AC2BCB0;
	Tue, 12 May 2026 00:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778544080;
	bh=lxS+xrMxyMqeQ2Uc3VsxxruNoLpj5OEXbZ+YMCjKNdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vHJl1G85/YJp5rqU3eQ4CU0FVvAvkuV1YWkG4jjOTEOanLn5pIPBLwEpUs8CsgtUg
	 nIsF5pdFsR0rdb+kx7eJ1xkDQloOOBGvV7U8JbgygkvTRJm6QmzsVmHAx+NmTOZoR3
	 u8NGZ4tROdEfW7GeWhMay/j7WY+wuTFs4852SbPl2P4O5FBpSHXdF6IEYoH0dEXF/i
	 i+korJYaMRt2NPLp01pjGAuN4FMJfVA4gGLfXLwBj6wBunqCSpBT/YnNoUEz+O6vAk
	 SrKxyfJI3T/rbhi+dhmRa4pkREhnLbxhG5yIBPvmxw5+T/r9snPjrijoilAkkrb7/T
	 uanPaFCXTm+Jg==
Date: Tue, 12 May 2026 00:01:18 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <21cnbao@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to
 accelerate swap entry release
Message-ID: <agJslV2eNj9FLFqI@google.com>
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
 <CAO9r8zO3GrMLDV57aRaiwRvZhwcduihKhc3rBpFGkbZKoq_iSw@mail.gmail.com>
 <CAOptpSPY3YL5VFJW9KKP99Yb17+_rdXKsKj93FdEn3_Zb350ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOptpSPY3YL5VFJW9KKP99Yb17+_rdXKsKj93FdEn3_Zb350ow@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FA9640010
X-Stat-Signature: 3a56mf8opmkzrwd3sau5waofs9kh1oj1
X-HE-Tag: 1778544081-983623
X-HE-Meta: U2FsdGVkX1/piXif9qiQml8ekEWZwNm1hfd29pY9+gNmyfPrtO8zN/+XquiQkGdGMXp98LgIopaZbAK+6EtU2tZ6kRuVzd8tMhez87cd3ffaLh3ibDBN32X1nvFnGwFl6qPLkid5TfEJwut5LNLhsuuXdpPUTOZeivLV3rXQNG2R+puPp7iAppCivwDbRdAG1Z6nAqj3GSCzxW6uDQ9op2F6At5e+poBk4p5WzgCKCg/RPv3iLt4PzBWom9ob8WyW4a1VpPHG2yEqxKTVEjqkc7uAczC62NYfqbiFlO/RxqzjpJwVb3L9m+aPENTmjlO+YjcJP6mcaUE2Z8VOd7u7bvU605RsXA6PEwNkV/DUL2QtKvtTUlLpp/q2J4ABYXVsLe6yBG0cLAdRLQok2Q8eX3S2TgTRNIYDsiQ3u6VLeRLOrBoujz3eOYKAO4x6vWWC6dlT/cf648Krv1h/STSL8GOMzQa9yn3jn04GHYNUHiy3I7wQ+gjPFMUBYrTk8olZld0gT5QQHHWDT368NY0gawnjDuWmpaGDRz+bttG9IVIugkQ5V/s6PSyJb99JQljPGtE9k5JJ72QjJfXL9JLn4yeeZ+tsdyoUxOQ8l0igw2fBD7Cw0mIsF++Q3dqckbDWUk2BHdkLqQ/MDxjTmFXdEMaMYCslxT9urxcFuimvtX41lLSicQWr0XlYHA6u+D4aeY4FYVa4s+MX5tFAD5xHdvH0ueGuQMwp+dzhLwaDOCVRJpWULFS6oCl3i/DPnoiDO5NNtvifhpuW1s8BKk7t1I1aApLOooxR8465grCfB5JjKl66OZlcRQ4SdUCZCmmKlhrtLrGQXFMp/XPy9CL9wgeuGrJeUPPenMjmB+likiZtOnQIMjD6kYUVGvkEVxRZI2WqgIrp0OJBRTYAcEm2/hBzkpCnuVDfRoR8/7wEXcUD2gSHPVsSG9N03B6HPCVsr0kRAPLdmeb4GCFzsR
 K8pp5Skk
 Hkir9MIOY2XKngpxfYaQUtyc6MGqQHvdyqRbX7GwlG2WuF5oh2/9Fk1q+xAExDPu7qQ63EDPwueVuF+nQ7akKRj+PfQJmynRkc1AeFIftiDaLTUDyEgSGB65tyMGqgoKT9ILCmd3rhpL9Mj0dSy+x3teA4k8CY0kH9cId8U4zOUZEMV5wt8oEe1DgNE5d8UpqDWEI/JbqCWrop5qW/AFdTQVOzgcSQIPNu6cDXL1Ozrk0sgm74ptb94hTpYydNVmTEolpGJuxiri1BEGKBsmj+s3xaGUrbyPpbz7S9b1N7b0V9bY1lt3NBfcfiWrxNYi3uXG8y+PmoVxurJ9w0dUxJTK02g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 09, 2026 at 04:32:04PM +0800, Wenchao Hao wrote:
> On Sat, May 9, 2026 at 4:13 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Thu, May 7, 2026 at 11:08 PM Wenchao Hao <haowenchao22@gmail.com> wrote:
> > >
> > > Swap freeing can be expensive when unmapping a VMA containing many swap
> > > entries. This has been reported to significantly delay memory reclamation
> > > during Android's low-memory killing, especially when multiple processes
> > > are terminated to free memory, with slot_free() accounting for more than
> > > 80% of the total cost of freeing swap entries.
> > >
> > > This series introduces a callback-based deferred free framework in
> > > zsmalloc. Callers (zram, zswap) register push/drain callbacks to
> > > define what gets buffered and how it gets drained. The entire free
> > > path including caller-side bookkeeping (slot_free, zswap_entry_free)
> > > is deferred to a background worker.
> >
> > How much of the speedup comes from avoiding the per-class lock,
> > free_zspage(), other work in zswap, etc.
> 
> This series doesn't avoid the per-class lock. The pool->lock part
> has been split out and posted as a separate series, so this series
> focuses purely on the defer scheme:
> 
> https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xiaomi.com/
> 
> >
> > I ask because I think the design here is still fairly complex. I don't
> > like how zswap and zram are registering callbacks into zsmalloc to do
> > their own freeing work, and they fill the buffers on behalf of
> > zsmalloc which seems like a layering violation.
> 
> The callback design was motivated by code reuse -- deferring only
> zs_free() inside zsmalloc gave less speedup, and the machinery
> needed to defer caller-side bookkeeping turns out to be the same
> on both sides (per-cpu page buffer, drain worker, fallback). So I
> folded the common parts into zsmalloc.
> 
> I agree it's not clean from a layering standpoint, and I'm happy to
> revisit if the reuse isn't worth the cost.
> 
> >
> > I wonder how much of the speedup we get by just deferring
> > free_zspage()?
> 
> Below is the perf breakdown, sampled only during munmap() of a
> 256MB zram-filled VMA on a Raspberry Pi 4B.
> 
> Base kernel:
> 
>   # Samples: 491  of event 'cycles'
>   # Event count (approx.): 214056923
>   #
>   # Children      Self  Symbol
>   # ........  ........  ..........................................
>       99.55%     0.41%  [k] __zap_vma_range
>       97.27%     2.91%  [k] swap_put_entries_cluster
>       94.37%     1.65%  [k] __swap_cluster_free_entries
>       88.99%     8.91%  [k] zram_slot_free_notify
>       79.87%    10.78%  [k] slot_free
>       56.27%     5.99%  [k] zs_free
>       47.61%     4.35%  [k] free_zspage

Seems like most of the zsmalloc overhead comres from free_zspage(),
right? I think we significantly simplify things if we only defer that
part. Instead of having a page pool and buffers were we stores the
handles for async free, we can just remove the zspage from from the
fullness list and put it on a deferred freeing list.

We can probably even explore not doing per-CPU and just use a single
global worker with a single lockless list (llist), then the worker can
just do llist_del_all() to atomically empty the list and process it
locally. If that turns out to be expensive we can do per-CPU lists.

WDYT? I think this can simplify things significantly.

>       36.85%     4.96%  [k] __free_zspage
>       19.27%     0.21%  [k] __folio_put
>       12.64%     2.91%  [k] __free_frozen_pages
>        9.50%     6.40%  [k] kmem_cache_free
>        8.28%     8.28%  [k] _raw_spin_unlock_irqrestore
>        6.83%     1.85%  [k] dec_zone_page_state
>        5.18%     5.18%  [k] _raw_spin_unlock
>        5.18%     5.18%  [k] folio_unlock
>        4.98%     4.98%  [k] mod_zone_state
>        4.12%     4.12%  [k] _raw_spin_lock
>        3.30%     3.30%  [k] __swap_cgroup_id_xchg
> 
> Perf of the zsmalloc-only variant (same 256MB zram workload):
> 
> My first attempt for this RFC was exactly that -- defer only the
> handle free inside zsmalloc, keep zram/zswap caller-side bookkeeping
> synchronous. (I would post this version after this thread)
[..]

