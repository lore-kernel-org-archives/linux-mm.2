Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB27C87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885C78E0233; Sat, 16 Aug 2025 00:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836AA8E0006; Sat, 16 Aug 2025 00:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BF98E0233; Sat, 16 Aug 2025 00:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6386F8E0006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:15:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD360140348
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:15:14 +0000 (UTC)
X-FDA: 83781305748.07.8BC148C
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 27BE4C0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:15:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aCIFT63H;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.219.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755317713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUehadT0V53VE6Ngws3FvMAkJvl7sJD5MGU+DK0jxI4=;
	b=JxmObp7VyP+7uj6KfIVb0ALQmGJgL1Q6Ntdja3EqjU8W6rarb5vh4FPFIsV9D6OTpLEZpc
	vHNqXTxUeKV80Cy9gq9jlZV3zH/Dj9sjMdrTv9GszpokOrVQA9vSpS/cEp8V4agBQy7cYP
	Fp6R4VQLRUzb1nEURZq7bXHSHXLyjhI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aCIFT63H;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.219.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755317713; a=rsa-sha256;
	cv=none;
	b=PUbYdmeTFhelertitDBoLqD2T5d8IbHvRTomag+YNNkIkyQ5oCbPEcAigCM4xG24mmXIDI
	CVMJ/C+HZgDkV5DPr9jz67lBu0k54O9Qzs/qmJSi7tnh66oEZiTBlcRqG+f8kVCchyf9Xx
	XYOYQ897HI1pYAHh+Yf8vDTaNkHPEK8=
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e931cc2ab5fso2170999276.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755317712; x=1755922512; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KUehadT0V53VE6Ngws3FvMAkJvl7sJD5MGU+DK0jxI4=;
        b=aCIFT63HMg170IIpLbYq0ELNZhduFiX1+GBoAZJTotOrjHFJtphrFO6uA0NZ3hhaew
         w+Z+TDyD8TlLaJ3HLi7gSNxSWZl1FRXR6JoC9ERnj60T1rK2zMT/Lh+u5H8oaJoGPbDJ
         ytSj6jvEhz4s5GjmCV83UIUDi2T7QJe8Yk8tymI3OMNG95oYt1ukARn6d2Nq82rJ6HtK
         oDlk0ALQQ5BoIKpYx3fqaydeI+Jhgvtx5R3PAOnTKXapUHUB71sYJhsyDWdaQdxB6i+L
         D29YQ3u6RY5ISZ6j2DjlDue/z1KnFbQSSzRvDnjUI+4/MJDT3HoCB7aoymH/aDJVN3Mh
         gX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755317712; x=1755922512;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUehadT0V53VE6Ngws3FvMAkJvl7sJD5MGU+DK0jxI4=;
        b=xKOBkOGrSGqs1uzd6GFPjmGeJFGf/QPgd1Hf4FmtZuwrT5braABKBKloNxVhmuls/3
         4KdiTG0ZFrFqzpXgLCX/Ay7qTS7fg9HZYroHFmFtwFGn7zKMbZhxUGeFNgY1gYuGyBuK
         IC4KrphYXDHWAocZpjeGYtLLakA4L1FzOpUauFVTexX3HnRYaT2fJS88h4ydoSXeXb3r
         WR4awh4kkJ/MtoDxNziArSgOQhpdJDA8t1Dpi1ViDRoKAcU0y9kUnmCV5zxerjmaSpa1
         JFVZgiFJ64wiu0HBeMLVWSfTAj+KQ7LjuaPPrawRCxFLXatkh6Q11ZkxkJoL3b3HTvUf
         IcNw==
X-Gm-Message-State: AOJu0YwwWPOobouNz3tLnq2mF6nF9kp++cm+IC8X6LoJJN1Ot88D1Ayu
	DsgN7u7bUatBdZAAHh5LCU+ZO8y8lWSzPKCN7/YD/w0k8gNZIdo/sxKRkXiNQPHa6w==
X-Gm-Gg: ASbGncvJ72JCstwBY1Qsf6pMsmIM1jEbodgqvh1PUnQzwxz8LbtQX81tBu41r/U+3De
	JJPVAnRTMG8nTeLp098X1las4SitOGPOEeAB2KErEnuRqUul7aWgrNB/egL9CqJxtH2lAr4vlb9
	D+uG6fBUPPiy6oIdDALbfxfXSKO0MupavlPuXYR50uzRkPzb4xAIQj0TcHZTEluqDfYM/bPH2bQ
	11iANsY8DtguTlBqv10U8E2AFrfrBJKLUJwa+neL5mfJN7JrljPHzAJsspfjLu+cxf1eAY+0wL1
	JN5V/MpRxNv8N4c8twO/T2guh4DNl1QEmKIiHQFlUAN3K2DLvMe5gqSIAUmrZiQKaCP6kA/lzur
	82XBKdf/UmNWF3D+efbfeol2deBi9X/vm7xdxlI6lwdYApWsw+/vUfRQVMT0ANqiLng38eI52+J
	NQAOY4XsNbftmodh8vwsZbJ+Zw
X-Google-Smtp-Source: AGHT+IEoz5xk2tT5r2yE8JK4nthMMpd7ZQMp3zWO8Q0rCgmw7gen9uSYcCzOmwTuA00q0E6HkEXVTw==
X-Received: by 2002:a05:6902:320d:b0:e93:3c21:cad0 with SMTP id 3f1490d57ef6-e933c21cf24mr2813695276.13.1755317711784;
        Fri, 15 Aug 2025 21:15:11 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933288971esm1104986276.37.2025.08.15.21.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 21:15:10 -0700 (PDT)
Date: Fri, 15 Aug 2025 21:14:48 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Will Deacon <will@kernel.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Hugh Dickins <hughd@google.com>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, David Hildenbrand <david@redhat.com>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <20250815101858.24352-1-will@kernel.org>
Message-ID: <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
References: <20250815101858.24352-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 27BE4C0005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: idr6ujq7yihr9y5jdeddemqrw7s3i9x8
X-HE-Tag: 1755317712-731244
X-HE-Meta: U2FsdGVkX1/cpeuFdrQ6WH4pY7Q+h0AeKbuRowQjWBp9vlH2X4izpHgqiPOH1ayzI2WhgKsf0K5tWTHqfd27uc1SEL3gQFSdHL/ME8AbbfKA1IvztbwxL3HZUqcQ+SRkE5R/bE0Uhq3CrcQs+N7Ziq8IFJvzrxEmyIeuok9XEgBEWJDbkapppM9uTqi3gNcP8Kh4N5/nSwbUWz0SzCyPTFN6SFrmyMH/KMXy4GY7bNPho0rCMW9JuwNGyeoC0U0lKWoctw4A9qLC8qUNS7OjgEnClIOnlPXCCaw6Qo57TAQRG8OjXmQGvid6ayAHQ7wff9aGYUz4llmEMx2H9rfQTiLidIspCHyK6mttDSUZw84Om5GCTZ5rB1OrlUzoIk9SM0jtX8A4Rhb/Oh1wLuvM2VpvFpDcA8hf9uyy/3r1gVt1LbS2pQjP/sPbEVUfYA5NaQEGTzLPe4F1txfV8oj6WzA33DC9FUjC9ttGSD6zjTmVMh2e0lXEmf+o/XUipYPR6d1E2geRLFg6Pj2l6eqYFBg8tdmmEg4OntC1ve52uNcCeVEuxS5OqiamBXfxxsdPeV1JPe8pr3hMrBk62a6+qcRUBd+YfR6dbpOVTaRlUNNTDW5CM3TAIfNbhqSIMnx3551lE/yDPZkxC6ooOMzXNw6HMwRi7Grt+yBHQ7LBXvSKa0jA/CLeGRcX8LlnUwc+DR3toHNGFgMD7PK99d9RJbW1ctOVqofyPCGWmrJiyQZbR//ZxkkabjYh47Kfcwdqc5zdQQP6nOae28GFyP+Ai4Pio4jrZJHQ2BYA8A3HMOz1Um1ilYCqqkgYAYIpydA5iZUAbTNmWJBA8ADNQk+Y9uoJAHts1xxp2XjhF9OZoqREkm3vCZQP1Ujo8oY/jRPsZByD15fw7THCklzdoYbDGnJx1eycDTqDzSiDKT8FR9+OGrdrwOq0ejwdAgrdZIzsLXQ8x08Zyk9UfrWsl/Z
 BTN6APY4
 WEexj8LkPGHKl/Zr2OkD714I98CW6lBI9iJSDk95qSpcR1/15AxLtTmfdCBG3u+A+N0xTu3TlEyzMYt0RcOuLcI+Ea2gJE0AK+fg882nSXc4ICakxfceJmMUuv5BXEDxTPYIgwwq/z+HYbEWRqEr6Wci9aj9Jl8CpLhn7vYD3zJWUYQiH7OaM5CmUyKabbvyOHT34qSFwb4aypZt5F+nF7iAQsXXLJfGaLkEdRzbR5TkiwqNzceImAReloSkrLimypuTgCJ16huX8awmCIN5XdkgJHCg11aR0KIG5R7ZVPrSHmgXzAm4k6D8fZSIE8bGir/OAob/X5ANAOwL8cQ4ave1vm5plWQzSlCKmJm1SKYMrUyHSMj6LrCPywtvFWsFktWg+m+oJeElc6hsTskGMzfmi1KyXLtELv7MYY+HDKfvIz6e0N/j3H1kAt4c2efxjvOQpsI6WOqHcZHcrMvude2pubx0Z/TU4FL8ghGR4dOZxx6d1FjXzb/9jng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025, Will Deacon wrote:

> When taking a longterm GUP pin via pin_user_pages(),
> __gup_longterm_locked() tries to migrate target folios that should not
> be longterm pinned, for example because they reside in a CMA region or
> movable zone. This is done by first pinning all of the target folios
> anyway, collecting all of the longterm-unpinnable target folios into a
> list, dropping the pins that were just taken and finally handing the
> list off to migrate_pages() for the actual migration.
> 
> It is critically important that no unexpected references are held on the
> folios being migrated, otherwise the migration will fail and
> pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
> relatively easy to observe migration failures when running pKVM (which
> uses pin_user_pages() on crosvm's virtual address space to resolve
> stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
> this results in the VM terminating prematurely.
> 
> In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
> mapping of guest memory prior to the pinning. Subsequently, when
> pin_user_pages() walks the page-table, the relevant 'pte' is not
> present and so the faulting logic allocates a new folio, mlocks it
> with mlock_folio() and maps it in the page-table.
> 
> Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
> batch by pagevec"), mlock/munlock operations on a folio (formerly page),
> are deferred. For example, mlock_folio() takes an additional reference
> on the target folio before placing it into a per-cpu 'folio_batch' for
> later processing by mlock_folio_batch(), which drops the refcount once
> the operation is complete. Processing of the batches is coupled with
> the LRU batch logic and can be forcefully drained with
> lru_add_drain_all() but as long as a folio remains unprocessed on the
> batch, its refcount will be elevated.
> 
> This deferred batching therefore interacts poorly with the pKVM pinning
> scenario as we can find ourselves in a situation where the migration
> code fails to migrate a folio due to the elevated refcount from the
> pending mlock operation.

Thanks for the very full description, Will, that helped me a lot
(I know very little of the GUP pinning end).

But one thing would help me to understand better: are the areas being
pinned anonymous or shmem or file memory (or COWed shmem or file)?

From "the faulting logic allocates a new folio" I first assumed
anonymous, but later came to think "mlocks it with mlock_folio()"
implies they are shmem or file folios (which, yes, can also be
allocated by fault).

IIRC anonymous and COW faults would go the mlock_new_folio() way,
where the folio goes on to the mlock folio batch without having yet
reached LRU: those should be dealt with by the existing
!folio_test_lru() check.

> 
> Extend the existing LRU draining logic in
> collect_longterm_unpinnable_folios() so that unpinnable mlocked folios
> on the LRU also trigger a drain.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Keir Fraser <keirf@google.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Frederick Mayle <fmayle@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Xu <peterx@redhat.com>
> Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> This has been quite unpleasant to debug and, as I'm not intimately
> familiar with the mm internals, I've tried to include all the relevant
> details in the commit message in case there's a preferred alternative
> way of solving the problem or there's a flaw in my logic.
> 
>  mm/gup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..656835890f05 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>  			continue;
>  		}
>  
> -		if (!folio_test_lru(folio) && drain_allow) {
> +		if (drain_allow &&
> +		   (!folio_test_lru(folio) || folio_test_mlocked(folio))) {
>  			lru_add_drain_all();
>  			drain_allow = false;
>  		}

Hmm.  That is going to call lru_add_drain_all() whenever any of the
pages in the list is mlocked, and lru_add_drain_all() is a function
we much prefer to avoid calling (it's much better than the old days
when it could involve every CPU IPIing every other CPU at the same
time; but it's still raising doubts to this day, and best avoided).

(Not as bad as I first thought: those unpinnably-placed mlocked
folios will get migrated, not appearing again in repeat runs.)

I think replace the folio_test_mlocked(folio) part of it by
(folio_test_mlocked(folio) && !folio_test_unevictable(folio)).
That should reduce the extra calls to a much more reasonable
number, while still solving your issue.

But in addition, please add an unconditional lru_add_drain()
(the local CPU one, not the inter-CPU _all) at the head of
collect_longterm_unpinnable_folios().  My guess is that that
would eliminate 90% of the calls to the lru_add_drain_all() below:
not quite enough to satisfy you, but enough to be a good improvement.

I realize that there has been a recent move to cut down even on
unjustified lru_add_drain()s; but an lru_add_drain() to avoid an
lru_add_drain_all() is a good trade.

(Vlastimil, yes, I've Cc'ed you because this reminds me of my
"Agreed" in that "Realtime threads" thread two or three weeks
ago: I haven't rethought it through again, and will probably
still agree with your "should be rare", but answering this mail
forces me to realize that I was thinking there of the folio being
mlocked before it reaches LRU, forgetting this case of the folio
already on LRU being mlocked.)

Hugh

