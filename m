Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25405CD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC8D6B02C4; Fri,  8 May 2026 20:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884886B02C5; Fri,  8 May 2026 20:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A7A6B02C6; Fri,  8 May 2026 20:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 692B16B02C4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:08:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E74DC1791
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:08:17 +0000 (UTC)
X-FDA: 84745944234.20.1F5023B
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id E76BD12000A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:08:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qAKKnhVe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778285295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hAe5AS8Ymjlp2Wl032hmQa+iD3KTwFf8efNYcRmY7E=;
	b=MegFFVpRT/cz6W0ATCCTc8614LEisDw/XHrYzLDCy7ItD08Gnv0SmO6QyQ/KqO/mD9gqD0
	ybGMmNpEn/GAVFsyPt34k7mVuOQW0tdZmWExp8TY0up3sWZouVVskGDM4iYZrfWAxqcstA
	Le4STzHv6/IwfE7u3KmV6U7KPCMBpLk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778285295; a=rsa-sha256;
	cv=pass;
	b=SrkV/0z9/fZMgcPFfMwAP3Lo5P0qNKpN71LvzogwHix3Qx3tB+4DqHk9B/SWyrMgZ3pXiK
	2H+1LuvM38pkt7dh3b/yIqgY60TMYYe0ONQRVKI+Uf4r411wDz4jmG146rK1aSxCdUCCzA
	U6iS7diut9+nexRUNIiO76J4HAe+OPA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qAKKnhVe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-44ccbd3290aso1916342f8f.2
        for <linux-mm@kvack.org>; Fri, 08 May 2026 17:08:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778285293; cv=none;
        d=google.com; s=arc-20240605;
        b=aJdULZcc3yji8vNxqnJx8/2q5OvyaF/5Iu2PuBEQ6z5dAc/Bg5bXz1VY5POWJNTgGh
         BggrkIIImnvy1uJzq3JOFNVaEoblnX66U4ihZfumVA4NQWDQ+zN4xWB1a/utqVU3lWaA
         i/SONMQG45l7qh5HGY4xhWo7OojExJ+Mqc3+Qe8odpOXMxnUoSq6/J39hn+Mf04hjJjt
         Y//01QMriERKNVr7rqAWDYPApf3e9Xnm43tn3z/sebFfr8rGa89OBm6Bl7q6392lLbNW
         NoJB0CdFJZm5RcUMpQldpnfOaMlDpXJ6ykQgYgDDaCfORfWOFudmH/P+/rimmfKCzzuB
         UFcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2hAe5AS8Ymjlp2Wl032hmQa+iD3KTwFf8efNYcRmY7E=;
        fh=8hCXfsyQoOy9Fx30AOtWWG188rHS3nBGiLkSIr+iXoc=;
        b=Ph78WHYbitmyWAzhA2dJa8Em8vP85jOmRdnHCBDa4gJ2TSsQkeE+tI0eDL1kl7r+i1
         fYATky1Dlh6I2XMMTtAriMP5Nwf9MgWU8BBUSnsBA0kCvaL5zlg4a54OXXExRobgy3UI
         9zCbff8kvz8FOyJUX7PS3Gor5GflT8Lvnu39fhKoqx5aSAteKLE6DSMHzNXvBZ8xHKLt
         HJ/41WpDaSmryOX10j0nLozgrPTeqf1zNQnWIyiWHpWxRLENFHZRJUwsNfa3RIvmPv1s
         mRtGIplawOUjfjYACB01wviPoz78Vo+1RpasNLyCtK837bKXzoVkxZizdRehhyNNHJQC
         eyqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778285293; x=1778890093; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hAe5AS8Ymjlp2Wl032hmQa+iD3KTwFf8efNYcRmY7E=;
        b=qAKKnhVeSemssF8PO0bff2JA2QXW6aChM24s87lA6HPYrOwyjB7SHdqrM+IMV7XQrx
         Zi4rVDEqA7cboP6zcYdmRO4GF9YbEYbYpLCXKPdnslL943AXT0mBKo0elveristcozYM
         nS3JfBfyypThoAGcabxavw0HGYe97/WHZttwEAoLrbAAh3iyrdMGF/TWpTEz054e4E0O
         oTFr0n7lHaXi71MVpGG1AGhuhDupGVv0xdtXU2fKQ/Y40sK/BAfiQfV4X5bVFEP4RPau
         y2JYfjzwQc5xVIHXkeCyjpngsBMcjyxbDYvbZcDbEal0xF42D+35Mv4h3p+zSj82+1Z6
         wXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778285293; x=1778890093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2hAe5AS8Ymjlp2Wl032hmQa+iD3KTwFf8efNYcRmY7E=;
        b=GqTcIedM1Quk06x5i7sbpkvgTKWPl0c7FLxgaOjE9lL6KqbZMbBudsYTTqOGlmBS/s
         GSqCSf0P2zS+iwUcBS/BOWImO1lljzRFlAT6RQsq/gp/1wv8pM2M6V63q6JXdUppf+c6
         GynBKIrs5EpqIKp/k4Ip7ogFFgddZgtL04Eii3B1PDd5EEDe6cn06WCwKC7h5fVCxdX8
         DUYsVKWvYrvTLPmNEhDt6vfJoY1wt5Cln15qNRaQonXGXSW990JZMzy6WlZPrxzErUPk
         TvytXOOg+2+Vn7C/6E9kvzh18Suci8Vw9j/1t5wUPAdVogyr/NUienti3BbGQEJ6qUjE
         B+dQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WRVY72ZqLlDMADTuESN7ZduRmTK4pxwY4gF9DhRxGsTyZDV9PyuaXEdgOtn625cFA/1CTNc0Nuw==@kvack.org
X-Gm-Message-State: AOJu0YzR6oQ+PmhpZF/U09EXyF7rpLiD+NNvY77rZ5KhX4DPcz3SBc47
	gWbMZLJR/HwA+wJtz9btIq7dNA8uCHiYrze6kgUM7S5CzffYtym3Lh5hRNSpVrYGI96d2PIshoa
	2NGGkuJnGBOnkjjE7oGnC963EXu9gEak=
X-Gm-Gg: Acq92OE9lck7LBeTAz1VIbUMzeHyU61/dybDeld5nNGj4JK3PspQP0ejoPVpxibFxUX
	TPR/E1Eak3wpykiZP/Enwz55aiootrZi5rSQt7K8kSC1y6m4mfHm/pE754v/UbAb9r9dDbpkpIk
	h6H9hbiEznIQGblDNgAOY4Ilxe7mBn9lr6Yk5jCAsHlzJFIwMIidmqojHIyL+OzVRT9R2GxNx9Q
	oEJe6gvGWnZ3U02L+WYoLOlnHCRI3+fK5gyeaoz5pRlRTFTAOBX4W0aka7+Mgt6murgnzIbQREk
	PE+Xr7dkGj35HqqLF7nVtlwVJaU/PeLs0vKA3g==
X-Received: by 2002:a05:6000:220c:b0:43d:77f4:7145 with SMTP id
 ffacd0b85a97d-4515bae9147mr23715114f8f.19.1778285293382; Fri, 08 May 2026
 17:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
In-Reply-To: <20260508060724.3810904-1-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 8 May 2026 17:08:01 -0700
X-Gm-Features: AVHnY4KbA6937UtLfw7u1pC6wkI6O7XsgN0-eZFsAMS6V-1aa9ouZXB-HiwqhPA
Message-ID: <CAKEwX=Ood7Q4zv0zc+GCCGtWu2GLVdtod=4VC9151r87AZXpWA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to
 accelerate swap entry release
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E76BD12000A
X-Stat-Signature: fcrbseo4faz9k41x7aqqw1s4bk5inn8p
X-Rspam-User: 
X-HE-Tag: 1778285294-614916
X-HE-Meta: U2FsdGVkX18D0o5E6xZxgV017It6HwRMU6c5OXqxYf/F+k5sEJh0JxAMjRPRN2nzVEG/NyMtt3ZsHPprHrL8lMWYbxFSUirG1zfQUIEBkitYbzeyC9A7KeMp1e+FWC4I9LVCK9IZFOBNSmf63PnNeaZf2W0ePq4nSqT2bn286uUXPjcr3Q5sAuTdQzQgLvGnnWHj1GuvH8jrlkejFaaQ69nLemC43zZhKuKwqZ8qY2RCc8WufkxA7ZoK3JA15ACKrwX4tOrufFgk5rX0smsKyeEy6rb8IL3IowLzUh1kpFV8NflFOXydN0/3pTFEDCe2kFDLTVb+CWZjcQUAgjM/2UXp3gHj6iumNMzJgSzu5dDQTNkfnp7yghkOacZf+txL9DUH32NvhzAjcmuWplZ2gHMryqhCfEi9HEJH5o/zb3bxLGyR8NeYM3Hud5ainDYJCM/ShDROpd34eIBgtPrLgx/CZ6SbSao4Tc68SxclF0rN1XwhhCUBEz80XepodpwjZfo0G+nufFFbBadIK+sfFOuCsIAXcJwnJUQ2x0p0BCfiVwIV2DmzmzxytVPY6GFwClb0vsS3B0tf5rYGqvsvu6p7O4L7sGRX9P6C9R4FVhTqI+B+ld/59qf82HIqZJL9mnD6w3Kz7F5kFyeZFu4wMdAYaGNk2vh4VrrjxnGkIVGKybL3JSw64T0+UMrU0xUa0i1FI+j0ECP9LkClMiQRM5fkmyZvnXBkHS8qP4F8+xq8uSh6YCmkwHOV78Hv4ENcSJr4ovTtDn26wF6LMzQj1ykqwO2ivfIZpQcQFLy50qLjXPrkEnXyS6Wt+fBnWQAFg53RW/P2xiixt22/J0NQavtkrn1yeLPXt6u0F9ToA1a1Qi2bKsacVE0bTT7Q/MR8oE20cyBPLjOFMWJJYlZ5OF5BKKvaVHjgFzQzV5u81AUNuixCsq803BvbkaxfgzXRvpP2LnWi/fkyiUCbO9w
 Az7v/d7M
 3rhX4PgSnaShu2bR6JXK2spmNEjwVdNqQoJANu3OY+tWB2s1dJ4B9BYJ7nz+0zYOAP9kCt1wAY+QerFaG/b47rYY66Sh2TzOs+0CTZH32wpdrsxy/ZvfXKorRJWVlqjZdsNEUhmzX4u3QGa19nI0c2/VoCHblOwm9QiwSxNtaNXFUxgyy9d8cvnktRFbJjlBst4JftHyuqUPoHZQ8ep26dbAF9AR0IK2rsR9zv0aO5cLtkfaqs374pXad7cyZY/ajFS7tLwRIXDgRvb0DqjexpbjJd5Z8ZuDC+mFTgf97lGT7NzBqaBmzpucOux18UdpvsJxOBTwgUGWFlDvSGTJ9bwX18WoDKYfW92UFJQAepXTHNpPC+Xy9W7O6KissV+gl/Ymq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Hmmm, why are we batching at the zswap/zsmalloc level like this? I
agree with Yosry that this seems like somewhat of an unnecessary
layering violation. For example, do we observe a lot more performance
wins by doing this instead of just simply:

static void zswap_entry_free(swp_entry_t swp, bool deferred)
{
    ...
    if (!deferred || !zs_deferred_free(entry->pool->zs_pool , entry->handle=
))
        zs_free(entry->pool->zs_pool , entry->handle);
}

(basically what you had in the last version).

One weird effect of doing deferred zswap entry freeing like what you
are proposing here, is that the zswap LRU will be littered with stale
zswap entries. Seems like you removed them from the zswap xarray, but
they're still linked into the zswap LRU? At writeback time, that will
throw off the statistics used in the heuristics, and will make
writeback go through a bunch of stale entries, wasting more cycles :)
Seems a bit inelegant, no?

