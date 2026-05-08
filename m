Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77BECD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109666B0276; Fri,  8 May 2026 16:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA5F6B0277; Fri,  8 May 2026 16:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBEB6B0278; Fri,  8 May 2026 16:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDFFB6B0276
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:13:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 889D71C0899
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:13:11 +0000 (UTC)
X-FDA: 84745351782.24.31C09D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B82A9C0005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:13:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IDOUuD6l;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lZBmU7tQwtByDAPF3duERWvfOme627cjki2OB58wtU=;
	b=siqMUNUh+zvycIlWo9oUIc5YI1pm4uYVOBmOF+s4Rg9+v2tjlpx1GC2u49XnS6nkB9MqiH
	jeE0OJrkVqwAGq67AeVLaxJyKts9e50bkBldZJCL49Gbx+8BDo1atYzRLbJqr/wV+sRnzH
	xUgJDv1UUkp+94T4rvfBgcvEjxAGjvA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IDOUuD6l;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271189; a=rsa-sha256;
	cv=none;
	b=Pej4A4700CYH4wanO7aHSnh1A529D676snusMwIyD2bMCnYsIioQ0xx2TI7s4Rpho2rGIa
	WgykKT8KHenTKY+6s2SAutA5YmG/lFAh1ZWCPEtY8094REmJfGbb+Wb6ANsXWTw/+je3vB
	zBD6Hr0OKydNYwnlLgyirY9dy1Y5QlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3162560252
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD531C2BCF4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778271188;
	bh=ctngZu+aSAHhDu3PSjz9OJb24VmabpcYprQlPT4iRQM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IDOUuD6l08tpao6KddG0HnQQ+2CBWwKcCOhbwnk+AgSNvoGV4nBoZ6PvKcVM70CX/
	 yxgNyGNVflIbUau5zlPW7EGSsuRJuJENJ1NATtQy6ujr6z4o4nkfJvPBSHXgDv03JY
	 FVjYXI8/kOENaRqs03a6EnuVWVkvgSdP+Yy6BayVznnAO3n14rmOLjJBytFtLDRJ6/
	 SJ3KxIUybj3B8wjNtwAuB3WytZ2XmiImYYkmfyz8o5PCcN9jSSqR5z6OxjDcTnn5Be
	 4tBkYRr/VTDFbZiy+wei2TtJYMJBaMm4ql6iT+UVHDVSH2jMmocrEUkqIOOUODYbSv
	 NTAyfiC/8BWGg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b9358bc9c50so393943066b.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 13:13:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+s8nwEudUIdtvjv38a9D682b1q4Qmf1+R2sVJwl+hFQYlS3a8TZo9QfAaA8pNF7ZeCC+OQWqnj6g==@kvack.org
X-Gm-Message-State: AOJu0Yw7O/cqqYnVZr0gCp3176AvuXC5gFbnfGPEh+G6FeYxSrIOW7Dw
	Eaim4HzH7AiPgVWXIEAF0hCaDqZPXG0LZOrTlnth+f+ruxCQvOOFxijIqKWNoQ7TlaAd/N1RXlD
	mSLde/hIkXjK7oxtna7xOCQgRYWfy45o=
X-Received: by 2002:a17:907:1c2a:b0:ba4:a7a3:d03f with SMTP id
 a640c23a62f3a-bc56dd1a4a5mr752154166b.27.1778271187725; Fri, 08 May 2026
 13:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
In-Reply-To: <20260508060724.3810904-1-haowenchao@xiaomi.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 8 May 2026 13:12:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO3GrMLDV57aRaiwRvZhwcduihKhc3rBpFGkbZKoq_iSw@mail.gmail.com>
X-Gm-Features: AVHnY4J5AOuTir0jOtNhvbYTTtEs__nYFSDyU1jMgmuDCshQa-U3e6S9kx4Bids
Message-ID: <CAO9r8zO3GrMLDV57aRaiwRvZhwcduihKhc3rBpFGkbZKoq_iSw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to
 accelerate swap entry release
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B82A9C0005
X-Rspam-User: 
X-Stat-Signature: jmgkbq997dzkqoky1sfhmay5js3eoyag
X-HE-Tag: 1778271189-740533
X-HE-Meta: U2FsdGVkX183MIZP+lxgtfYLJvIiI88Yx13Fs44y7jrDBarXGdzKNoD+74ogRvuu/72lizEKUeeNnmZLfaBD6+zEDZoaNGg0weCJACNnl4hTXXBpB4eP3bkfstQKw+rV5xXNYTDzEreKe9ivTk7WT5QrJo3NE17V+TlTBOn6kKBIVv4xW5ohF6z8si+8FzR4ugOR01goxudoAGZdYboI829rhypJue9sdCdxie7qiWpdDir27Nt1+u+Ee7LFA2FVsVpohsJ7C/rUs0fkzPSHZ9aXScdfUNkZ2hLcB08QORMkZWbFeLoct/XjORhmr2d6b7YmSQx6/x+FpbWljWH2wvAxE+0c6CfoQljXC6lFbA4tvn0L7DwCXdSY4iGpYeXjelIoMPDXV3A1RIsViWJfjd0dg1rmlkJCOHtGzJ9vGlBwhIahDxCEWjEtM7gvpuzBhxYgXaf9A0Fup/2dtShnWN6gLDyox8jFd3henyMHsjeVqJhLgYf8AhxwOSHCMG6AC8n+mWhKGrrIzMXq26zZKE7je2e11C8g0cLeB2QImErZFnnZUycBkWJHviZCfgkQ8vCe5OYDds/nc5ByvtVQlOpV5mb0OorZr7OiL2WSo2P5taqCYk/zbdhbJVzVTNx88+yLqcSnHfHwzG/LDQXfB+i/bxHCQZNBdf2vSa1ci+UzlWfCsX86SbSbddmgj9DTA8oOhX7MTI4WXhbNDNDMgLw6rcVvI5WvvyweIEoiFxwNbMmwiaZVLjMVZVuYnzEklANC+on/K5OLraAqIBwD+f0XLRtekPy0ISfyKlUPlYT4dGeOo4z56fVrrYBvXz7BdPP+1xj9oeqW1C5vnfhR5PeaRSJvGk9scGqNrf5lu8xQ6IM3Biq23e6Hr/0aoJMGtEf/al4gNEJ8zJWffJBBtltUmlmDD9KgSXFF9atO283P0nw/A/Aq+kG6MiImGR2UPQbwaAsRZa7jAnIKwPn
 b9q6BvKq
 dpCn1GzylpiY8BS0HLNbi5JaNbVdwKtGZ5qk8MvfLjzsZyKP5j7xwj41XG/NYGu0L/I7+n0gGkj4QPNHRawZafHB5W+PXGF9UWhh2kyQpXgqCvzFD58lBQlSC+72WqhH4YFD04JkfH4dpyaz7U6GAtjseTbupZoSf7skb8H/4ns0jkXSShwWZMd/aJMpWjTAn3+tv4isM9stAMXdRZPZDgqSXqx/vi076Ik4IsOtGiEZcH5OK4eCyZz0C+JsAkeoIb479DZZKBcBq3HrV84TPRMDaCG3yGiSfGYe5YSf6DM5ydHG4RlhtGIeEP2uyrz33kxBvQ6rlWrUFMBXYkSCTtsn2dWwmKCfLasTvlvswSj6elhoiUpPLPEb/7/ZJ17ogncMm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

()

On Thu, May 7, 2026 at 11:08=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Swap freeing can be expensive when unmapping a VMA containing many swap
> entries. This has been reported to significantly delay memory reclamation
> during Android's low-memory killing, especially when multiple processes
> are terminated to free memory, with slot_free() accounting for more than
> 80% of the total cost of freeing swap entries.
>
> Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
> to asynchronously collect and free swap entries [1][2], but the design
> itself is fairly complex.
>
> When anon folios and swap entries are mixed within a process, reclaiming
> anon folios from killed processes helps return memory to the system as
> quickly as possible, so that newly launched applications can satisfy
> their memory demands. It is not ideal for swap freeing to block anon
> folio freeing. On the other hand, swap freeing can still return memory
> to the system, although at a slower rate due to memory compression.
>
> This series introduces a callback-based deferred free framework in
> zsmalloc. Callers (zram, zswap) register push/drain callbacks to
> define what gets buffered and how it gets drained. The entire free
> path including caller-side bookkeeping (slot_free, zswap_entry_free)
> is deferred to a background worker.

How much of the speedup comes from avoiding the per-class lock,
free_zspage(), other work in zswap, etc.

I ask because I think the design here is still fairly complex. I don't
like how zswap and zram are registering callbacks into zsmalloc to do
their own freeing work, and they fill the buffers on behalf of
zsmalloc which seems like a layering violation.

I wonder how much of the speedup we get by just deferring
free_zspage()? That part can be done much more simply by just putting
the pages on a per-class list and having an async worker or a kthread
consume them and batch-free them. If the rest of zs_free() is also
expensive, we can do the deferred freeing on that level although it
would be more complicated as we need to have a fixed size buffer to
store them and handle running out of space.

A breakdown of where the slowdown is coming from would be helpful to
understand what to focus on.

>
> Implementation:
>   - Each CPU owns a single-page buffer. The hot path writes a value
>     via the push callback with preemption disabled (no locks).
>   - When the buffer fills, it is swapped with a fresh page from a
>     pre-allocated page pool. The full page is queued to a WQ_UNBOUND
>     worker for drain.
>   - The drain callback performs the actual expensive work (zs_free,
>     slot_free, zswap_entry_free, etc.) in batch, off the hot path.
>   - If no free page is available, the caller falls back to synchronous
>     processing.
>
> The speedup comes from moving expensive swap slot freeing off the
> munmap hot path into a background worker, so that intact anonymous
> folios are released back to the system without blocking. The worker
> drains at a slower rate since compressed objects are small and freeing
> a single handle may not release an entire page until the zspage is
> fully empty.
>
> Performance results (Raspberry Pi 4B, ARM64, 8GB RAM):
>
> Test 1: munmap latency for 256MB swap-filled VMA (zram backend)
>
>   mode        Base       Patched     Speedup
>   single      61.82ms    8.62ms      7.17x
>   multi 2p    94.75ms    54.11ms     1.75x
>   multi 3p    154.64ms   104.83ms    1.48x
>
> Test 2: munmap latency for different sizes (zram, single process)
>
>   Size       Base         Patched     Speedup
>   64MB       14.11ms      2.18ms      6.47x
>   128MB      29.45ms      4.48ms      6.57x
>   192MB      43.85ms      6.62ms      6.62x
>   256MB      57.01ms      9.08ms      6.28x
>   512MB      115.13ms     55.58ms     2.07x
>   1024MB     229.66ms     153.28ms    1.50x
>
> Test 3: munmap latency for 256MB swap-filled VMA (zswap backend)
>
>   mode        Base       Patched     Speedup
>   single      152.14ms   51.26ms     2.97x
>   multi 2p    186.56ms   105.42ms    1.77x
>   multi 3p    205.83ms   153.32ms    1.34x
>
> Test 4: munmap latency for different sizes (zswap, single process)
>
>   Size       Base         Patched     Speedup
>   64MB       37.83ms      13.26ms     2.85x
>   128MB      75.11ms      26.73ms     2.81x
>   256MB      150.78ms     52.97ms     2.85x
>   512MB      303.04ms     130.38ms    2.32x
>   1024MB     599.95ms     287.10ms    2.09x
>
> [1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.co=
m/
> [2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@vivo.=
com/
> [3] https://lore.kernel.org/linux-mm/20260412060450.15813-1-baohua@kernel=
.org/
>
> Changes since v2:
> - Use per-cpu single-page buffers instead of a global list; the hot
>   path only writes into the local CPU's buffer with preemption disabled
> - Add a page pool for buffer rotation: when the current buffer is full,
>   swap it with a free page from the pool and queue the full page for
>   drain
> - Introduce push/drain callback ops so that zram and zswap can each
>   define their own element size and drain logic (zram stores u32 slot
>   indices, zswap stores unsigned long handles)
> - Drop the lock optimization patches it will be submitted separately
>   as part of a dedicated zsmalloc lock contention series
> - Link to v2: https://lore.kernel.org/all/20260421121616.3298845-1-haowen=
chao@xiaomi.com/
>
> Barry Song (1):
>   zram: use zsmalloc deferred free callback for async slot free
>
> Wenchao Hao (3):
>   mm/zsmalloc: introduce deferred free framework with callback ops
>   mm/zswap: use zsmalloc deferred free callback for async invalidate
>   zram: batch clear flags in slot_free with single write
>
>  drivers/block/zram/zram_drv.c |  44 ++++++-
>  drivers/block/zram/zram_drv.h |   6 +
>  include/linux/zsmalloc.h      |  16 +++
>  mm/zsmalloc.c                 | 208 +++++++++++++++++++++++++++++++++-
>  mm/zswap.c                    |  38 ++++++-
>  5 files changed, 306 insertions(+), 6 deletions(-)
>
> --
> 2.34.1
>

