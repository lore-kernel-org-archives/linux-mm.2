Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99782C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947656B009B; Thu, 20 Aug 2026 05:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7526B009D; Thu, 20 Aug 2026 05:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D326B009F; Thu, 20 Aug 2026 05:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53EC66B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:04:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAD33C06CE
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:04:06 +0000 (UTC)
X-FDA: 85121060892.27.6789DEF
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB33FC0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:04:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xp9GE9wP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787216644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oExxjzXiHGazt71Y4n/rEbKzM/ZM2sZkh5PRvbSPVRk=;
	b=wbB7mH7vb2fTqfH0Zgjd/lHCWfFNZjksuj3M7rYLe0GysWtYdlKmmnntWMy6LRlK8pcR4+
	3IngI0/KIideG+CPWXH8KyLMUqgKIeqjjbe1MdxpywbvdXZ9LrVIG+3QBL3MgO2tdF8rc1
	gID3A1RPICnt+5hbaAJFZCnK7H7Ou8A=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xp9GE9wP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787216644;
	b=Rbi6bKrBZXDPYqx5so+HmuMuSS6R0+OnCS+bTbFC1q4z5u4In9oh89xiJB5GebLoDzPof+
	AnCvqsw+u1BuvUMAZVWdE29tjsKyGevB10fRj85A7LoEyBKj5yyy2Urc4eWnxjFvxdSlky
	eTKOj7vz+lk/fcIy6j2kfqCvu405krM=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso1341413a12.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:04:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787216643; cv=none;
        d=google.com; s=arc-20260327;
        b=mPJnNwTTXIEY1nFypH5dAL6NCQQNteI10IhAndKIVTytZToYasWIJz8tdgXoM7OLxu
         NXwbmyJznjLqQDGexuU3GmENec6FLeYtYCNDQQbdhrel0ny0ap5vlX9QcEtXlgs/xenv
         MNWAjVZMvzMBSknseupZAKdap+M9LDBFUoutIEGgr8x++7R03YH83XcjvJJcaFt31kSL
         8JjopeT+WWfhFZXOh/nqSiB0nWgFegcFqnVXfA9q2VeBkJRMy8ZHkGfOknVJmyuwWsVI
         2fUjUX/3XQ7+NJReaPbLv1oQwrpwSMnyRY/uAAmT9bOP+04l6og/nV7xIhzPc+9E6HUk
         eVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oExxjzXiHGazt71Y4n/rEbKzM/ZM2sZkh5PRvbSPVRk=;
        fh=r9h4tb4cpQFriuNVX2Za4ROlR8uvvn5RN8JgXrmveKw=;
        b=X0NeieBydB6LrGCfeY9/71tJ/iZhpIDOL1HJfdhyGcchLF5t4zqW8LgB5WG+kVKf8s
         jrdXFqOG0/NptU4Y+0ACDAAEgDUgdNF84m7FxsyLKkVHv4aV1xcJItlKiKU/ySAcieuJ
         MhOeyW9bampS5KKwD0GoSheLsjEtvPsAO7x1J9uKiyvBbQRH5r2oteDIFFnbxsplKYTJ
         HfbqJozXbS/clpyEu9fpOI/u+FfAZbggkEN4+oeHLqFVdmypOQATuAnFvFpIXyOVk674
         5j/wlmUDF2yiuN8yQUb1a2Ugl4ZRpc/vSuphpPYjpsH2nEnukLTbm9OWGTV80cVKlnZ1
         CaaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787216643; x=1787821443; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oExxjzXiHGazt71Y4n/rEbKzM/ZM2sZkh5PRvbSPVRk=;
        b=Xp9GE9wP5wIXyFUcXncXvXW7FDBlmvn7fzuZ4CqRy0w2bIH+WvBCGoe2ts2N3/pLqW
         1KOHyjQuLCqNSSAFKqhP9HhhzPYI26H/EUit6tKdoRvVzoA32mOqI7rXXZ1oOe7NXi+E
         EF77hfe2DpEMBY4neuHk48DL+P7dXXZR87VvVs6xhOYQXmzArfhZ1QKd9I0T1MTL71YB
         Y1O+Xfaix1OEl5lHaQn8rlNpZOKD4rvaH3VMn1cbqm5MAPbaDUobDZoKFwCU/AdcpZnK
         p5RlZpePLk68HX8k7eslNbKSSRYaIB7QKlhcoHlbKeZezcP5cBKTt4LWQozjIVNtqnnB
         bERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787216643; x=1787821443;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oExxjzXiHGazt71Y4n/rEbKzM/ZM2sZkh5PRvbSPVRk=;
        b=SBUZKVOgmVKCp6FTy12/gOSQS+lbFnEodslMRB+PkhIhNE8tDA8VvAoKyFLQe89TWA
         S7gcK28DvgxsAniSztmTWzoLVv07MKMRmV1wsqU0KO6ZXme1pPL8rba1Nqf++N/LLI/R
         FKKcTWAu16mHkGZhS4Zz3pwQHPBZr2qlZ9iHWVE+xjSBKEbwu1CEqiAIAw+sU6t7Mona
         xvkAjWbqde4VpdOR4DunUxt0rzQOJtYnkIT/KW3YKJKxEKnvTudbdNA4SV97fyA1XIrq
         nGizF5PrMYOgFIX+PL2s2fnTp/r7GzmX83f8H7wlGXBwieDLgOQLfuozcqP/5eU7S6jc
         XmGQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr64waDocfnNaukMiwg8wSL+ySS6T/bTAt87/3YtH0w0GjxUlTscTwehta+2hQVvZKKHcCfnjqJsg==@kvack.org
X-Gm-Message-State: AOJu0YzE8QNU5xhDg05RUqPEVC5tR4n68drjMmTUr9P+62zwTpKWNTe1
	lUucsJybOYXM7MZS5HbxZ7589qskpS/gBf3/uc1ClrtKjCk/L8oF9H751/yi6n9pUrJquakaNm0
	FzarpDXW4qVOaw8yIJa6kegSwROQ4Rx4=
X-Gm-Gg: AR+sD10i/MJzL5+V487SMEoY4iXQY0GTdbh+3xecsUqUZqxMGvosW2HTdN0u+R93BZl
	7UKt2VdiEcd8dMoXqJskjR8L0U8zV5hXIThECt3ohTJMRQ7Cv7l5d9cQBIJ6MO4DWSI+sSQ9hWL
	NLufLtl2JqZ8vVKIEtoVbN95HDII+q3t4+PVTeZwjloPlJ+Gbx8hAynLA3SHkBdQ1z3WOJYIGEO
	zyUn9FgxZ2XeEcpbt9NDKtye+O17FoXMJzwv1bPlyv1t/u81e49valKk7r5n69TDY5AoR5CgL+p
	82dTsGqGoYLilnZZ6d3XCRpFmSFQxmrQVH+njQQptsWZePpa8kcQ718ZzVxUEZt7AVydqmnGGRA
	j0BRHOLKI3L0=
X-Received: by 2002:a17:907:97cd:b0:c21:393e:6d10 with SMTP id
 a640c23a62f3a-c244d4a5272mr280226566b.4.1787216643014; Thu, 20 Aug 2026
 02:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1787193916.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1787193916.git.zhuhui@kylinos.cn>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 17:03:26 +0800
X-Gm-Features: AcwNN1VK52ytPZKTSaeVAVydq8TurxojCzuaBygwVoIpY8-03OBvnKrPm8rxx_w
Message-ID: <CAMgjq7BSy0ReiwsJzDroQUZuJ+W8eakjRdUOyVxSJJDkUo1DFw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v4 0/2] mm/vmscan: fix NR_ISOLATED accounting
 and throttling for MGLRU
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB33FC0004
X-Stat-Signature: pua9mscnpuridqbyjt1ywip6sti3fzhc
X-Rspam-User: 
X-HE-Tag: 1787216644-983637
X-HE-Meta: U2FsdGVkX195/+zAVpileoGHMRM56H4xKmWUPI0/dp9S+UJO8UsvikXbZx980QI6OffMkJUY/+ByqjoUbVh2ldPXGFnsdvM7fl+1pU+IozQNrTpjP6w82cbDdb3ylegPXrdSdnstDmDfGnMYNrbZgHExmthGVwMh0nGRW+8igtqi62I80YEJM9thMUY+NRG3Dw/CEqrmImbbo7wTC5a1dbCVb7o1YAna6OVq99RCyEEKvysgDBF9oOuN7BOkbisnmePRCPEuvkYSIJ+x1w7h5kyN+lQInNO3GhbGLsZQ+N3PAYEJPPBq6Qa8WjseMij19FplKlmnuUavM8MktcLhDOvZq1QfI/TJdEWYJ/H300S6Kc/yo+yUl9LAT02ykr9Ebu8eVYjYYmCyCDp1hfe1Fq4bWkyLOg8CxaS2EnU3rQugYc0HauyTRJjWDWFYc+lT0Ij653BHAGVv18Vk7OczOluK/eD7DSr8Dogi05/BfjEtVrnamLRyHdG1UmfCxk/r3k7jwWdmS1cyP2syifmywsthem+6wGD61mg9Sb75aAn3l1EHqGhL6EFFKeNIMMV1dDh4PhvEFGleMcIvpjG1tzn+DB3XkVYorI+ABIjsJAFuYnqGjAYt/UTwl/utPghL5WU54CI6QEIJklxUZ/VabiVU17tx1Asl413+bAieooeyUeB0W28jfkyy13LpM74EvNCtrM16iuJQq64VlMsyOtjFghQ80Lw3iEYsgKfoSYfUvLqJ3b5gEK/yT0xAx6+pX6WPvoSHf07+1GFwaV7tyexHrH3RF33gbW20UI6Ed+kyq4OHz43Iec3odiWiU6ilON7l7Vflxv2GZ2RdO39WIfXa3a+aw7iEhq7LJLTCeI0yoIRaZzeKs3FUnh6PyNK/QdjAadJeszojnyLdapNmPwiJlNFrLTDWO6zv6QXQ+iZvBDvRbUzRYdrOADho5wKnfWnrI4ip0H2zExB7URR
 oJfme4qR
 8qNEx2B7ZKFbuA9wEtiHbdsbmrLSJsw4mXZPaU0Chbn24ynXkwEm9wQA+VOgv9gK8JYEUcwcn8xfTryOvB4WMh+U2e2PxKnVbBzOQ9e0U7BkAoVQ7sE+xTm5s2zdSnZ9Ggch6P2m2NXguxaggYvluRffrP95fEis7aHc9GL6qQlbFaXYfvTcV1tEUh1y1/bHUCpkCHkhdBf4r+dhh/agK66Lnv+fIbww20GJAD/jMYZarkEyCnckwAQXhMVT6GoTWLWVE3Un0tcNJSMitSvcfzahiapRsPKAWqM8xTvZ7w4Wczp/SSgspDgJTC9tblyBEs44ARU+P86SaNvybB/8yC6uCT5sWC0Il7OJa+do95niD3eq0WBaGGlH5FVwP06Kz/g2KI/2r2nBp28ubwDX5DAUHrQ/Mzj5MG3UhalMubFCCXn/4989qLSRT+Tw3kyavlrX2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 10:49=E2=80=AFAM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>

Hello, thanks for the update!

>
> The legacy reclaim path updates the NR_ISOLATED_ANON/FILE node
> counters around isolation and throttles direct reclaimers via
> too_many_isolated() when isolated folios pile up.  The MGLRU eviction
> path does neither: evict_folios() isolates folios without touching
> the counters and never consults too_many_isolated().
>
> Patch 1 updates NR_ISOLATED_ANON/FILE around isolation in
> evict_folios(), reusing the existing nr_isolated.  Without this the
> counters stay at zero while MGLRU reclaim is active, so compaction's
> too_many_isolated() cannot see the pages MGLRU has isolated.
>
> Patch 2 adds throttle_evictable_types() and calls it from
> evict_folios(), before the lruvec lock is taken since throttling
> sleeps, leaving the legacy path untouched.  The MGLRU check differs
> from the legacy per-list one in shrink_inactive_list() because
> isolate_folios() picks the type to scan from the refault feedback
> and may fall back to the other one: it computes the set of evictable
> types that are not over-isolated and only sleeps when all of them
> are, waiting once for concurrent reclaimers exactly like the legacy
> path.  The mask of the remaining types is passed to isolate_folios(),
> which restricts both its initial choice and its fallback to it, so
> isolation never lands on an over-isolated type and a type that is
> merely over-isolated never blocks the reclaim of the other one.
> This way the MGLRU eviction path backs off when isolated folios pile
> up instead of thrashing the shrinking LRU lists - the scenario the
> too_many_isolated() check exists for.  A dying task fakes reclaim
> progress exactly like the legacy path so it exits reclaim quickly.

Hmm, could too_many_isolated gets over aggressive or over passive,
since the inactive number of MGLRU is just a compatiblity shim and
does not have the same meaning of classical LRU? Especially when you
run out of swap space or hit a memcg's swap limit, the anon inactive
number becomes a jumpy random number. Proactive aging also makes the
inactive number become huge for MGLRU. I still think even a "/
MIN_NR_GENS" is better than using inactive value, MGLRU used to use
that as the aging trigger like this:

if (young * MIN_NR_GENS > total)
    return true;
if (old * (MIN_NR_GENS + 2) < total)
    return true;

>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>
> Test on 8G RAM qemu.
> The reproducer confines stress-ng workers in a 192M memcg and swaps
> through dm-delay (300ms write latency) so pageout is slow and isolated
> folios pile up; the workload is intentionally extreme.  nr_isolated_*
> is sampled every 50ms against the per-type too_many_isolated
> threshold (inactive/8), and throttle events are counted via the
> mm_vmscan_throttled tracepoint.
> The test scripts and test log are in [1].
>
> Test 1, reclaim throttling, parallel direct reclaim in the memcg:
>
>                              before        after
> throttle events (ISOLATED)        0            0
>   - from kswapd                   0            0
> nr_isolated_anon peak             0         3166
> nr_isolated_file peak             0          174
>   - samples above the
>     too_many_isolated threshold  0/1088     89/1077
> pgscan_direct            1540044096    858332151
> pswpout                   6299497       725819

The throttling avoids premature OOM and over scan when there are too
many reclaimers, it is not for IO balancing. Because writeback folios
are not isolated, they are putback to LRU waiting to be rotated, not
isolated. So reclaimers never wait on the device however slow the
device is (except cgroup V1 have some special quirks I think we should
ignore), it's mostly CPU bound. I think the mechanism might be a bit
outdated, even for classical LRU.

The result just shows that swap became less aggressive when under
pressure, which is somewhat counter-intuitive. Overly aggressive
throttling will unnecessarily slows performance if anon pages are
actually cold or should be evicted. These results reflect a reclaim
behavior change, not a performance improvement. And I think we
shouldn't rely on throttling for balancing, those are two different
things. Heat or I/O cost-based methods are better.

For example the test you posted, it just stress-ng which only spawns
anon memory IIUC, so when you reclaim file, your code segments got
reclaimed and hence the process stall and has to wait for code
segments IO, which I think it will only slowdown the actual
performance?

