Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0558FCD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 18:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D15B6B009F; Sat, 30 May 2026 14:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282516B00A0; Sat, 30 May 2026 14:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170D66B00A1; Sat, 30 May 2026 14:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05D626B009F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 14:02:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 850081203A5
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:02:18 +0000 (UTC)
X-FDA: 84824855556.17.AE5F99D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 552611C000D
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:02:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ecihxyzO;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780164136; a=rsa-sha256;
	cv=pass;
	b=8rgoxpzu13z9uUMh7F71n27I8TWygJrO0jnEDk2jFXBF/K3FR/oKgASk7MCdqhfeXv8RpD
	yMj2dCoECGkYTc0whqq4SgZjdjl8T1cIrw34qcpamn20F8SqL8D9Wjz3EiZSIs64sKl8Z2
	rA09HS7by+BMjyWU5Z45UlxlC4ZYuLU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ecihxyzO;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780164136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ga18sFo9W9MUc2fn4OlM42GAS8XhXOzY2C140cpNYs=;
	b=HceGuNk9rb9+XjiOKzf7n1Tz4zDDkIJasErdpDpkH14zQdvuUF4RuITCSlxfWmAJexEVyj
	0+FvmxFyGTZKxIypbkv4UJ+YeApF6Ajs9DcUOVqtET/TNYbpvjMFu8fsnEwEUfO53IcS3g
	kiT7VmYpRyWfqk9lgtQl4pkERaBYEOM=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490a7a34493so114955e9.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 11:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780164135; cv=none;
        d=google.com; s=arc-20240605;
        b=NMTr1Mr5dg6xza8X+fzaZBm5CvNe1oqq75maEA/p2aM/7MsIKTlxDacm7e7Zph/odx
         8ContK8EMYbpxNTO2w7BBGZq3mQPgKGBZwN41A6FIdGPkrk94uEVBNvgFpITjZUmq36w
         9kHwXy3E5vIm9vbTBERTlncz9loXKn+vVvQIJ8It1J7/784d09GlZgzaZ7JPA3DWpz8M
         nJ/Kicyxz1CowbtHRx69stC7TbgofhXJPaN3N8u1Y5GHAG60xpV66+aCASRVJeJ5Qzo7
         aTU77inHB/0sy8lgVYTQiX/BE8XH/HSaYKMPBy7m9GQVjN9MQg7/IELcPcnEQ/e1GRVR
         /GHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+ga18sFo9W9MUc2fn4OlM42GAS8XhXOzY2C140cpNYs=;
        fh=br+bUqFHjT0FPZ/gdLVAMbaJ28+bb89KESUfoga8dhY=;
        b=FeC/DaVR0WG6gzCvRqaWOBErsFjhIl879YHAz4rQHydNZYJUzLpssceoG/mcGZ2r52
         rWHlQ/ETJbHicrZo8GAbxEm5w851MnWWKLGdp2pfKJQ+g5lF5dQ6+3HLzmVvlnztlE2Q
         I3wdsYR5ZHurWApqA+2L0Bt3Fjc8X8cvcJoEd8uka7/NnF1+bq13nXQXxAh1R1FmO4Lo
         lYVBW3Ah8VdRkXHh+Fqyj5FjpIr831nztnBtwpF/Pj/w35wR7raBQu67cRWscXeaRNKo
         ZQo1d4dhRG96oZEixbFJfhiEYrALW9B/lcXxHoxZCThPAi8ZPRy1+95CpAesa56sDyk1
         Tg2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780164135; x=1780768935; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ga18sFo9W9MUc2fn4OlM42GAS8XhXOzY2C140cpNYs=;
        b=ecihxyzOVVHNcgFFB+k1tgqWuOQORcahskofFT8L7TGYs0p9KL6jPCL0BPfY6x0IuM
         5mUfGYiTKg/uV15rivmhXfHbekZvWLVStKIjd5zg1JX5Ao+mdmEc7+0jteITMDF1ni5k
         KzGaafdVbzVXFq1Bw8CWauEh0yIkDKWVxJSL2JfKK18kwJdki6DDdS61deDNe3/I2VUp
         CrFzDVIeEMUHXYKKrrcKSFwO4AVC6+mTnmdCT2dmUUT0Ro0x3myjAlM618DxH2zVOAmN
         qVVmC1/VtdFxESPO5rhNH22XaDdeTOLC6o8GE1jPWB5g4IeNK2QIYM0ChZmLJUki1N+D
         PfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780164135; x=1780768935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+ga18sFo9W9MUc2fn4OlM42GAS8XhXOzY2C140cpNYs=;
        b=Hb6gDxBKIKjc8ZvCzCPUchfNp2kR7Zsz5tRcX4iSU4Go8F9e5VwuXhiWYltt1hV4JN
         4iflAOh5J1r+awFrNwt4qz+F1/f+ImBYOAqzd+9UKSU2mNlHFfOSKJg5v5JYo/CQ8AHD
         lu7LUXF1rch+vdi/RZMGGlvDGxznnkkls/Bv8Mby29+IAUqjh/t4w9hQ7H7OFB4pRB9z
         L+JVoedldxIumFzODiB5Rs7aMwzJ9DhreUIzL36BjSLIdhpx+MeUfxdRK1sOJs54LM71
         SOx1oR8Rjzicchamp6Q9rQx5XLXt6n41gyvX3utkcDRhAtWf7CiGCfHYcMlkm25w7zCE
         /tpg==
X-Forwarded-Encrypted: i=1; AFNElJ+uB1QrqY1tWFTboquZG2e2kRRrL6DTlxUF036V7Okjsq+P42Icq3GJNnmShjRSck/rC/QM2+wPjQ==@kvack.org
X-Gm-Message-State: AOJu0YwhFrFpcI3px12eqP3JJGNJY3h9/H/K82dbyapQvRwLIyM9VpfZ
	OBd/mpmJnnJll9UUwz/35s7yTCNIqXs0Pb5Oba7rhpiidV1aFlrvfGgiEiHDebYhAwmxmjB4KDI
	Rv4vf7o9GnOKTzkBiPeAB4VliqQYedr4=
X-Gm-Gg: Acq92OGnqbNCdjveDZLqDjVIJU/ypWzCFnDM4ixA1cv0UBa/as2r7IMurAM91sAh5P/
	4ffbiB6JuZu8rgTDYGn895VPM/dvMZ6OSToAUDyjt4uM5Y6ukYbQrzGVk+3iMH5MD6LJiyxPihR
	9nkqGfYpoMTCaspINO+r6f1FIqNo6BBwmi9mlAbV6B+9oOV5U3BEEOmn9k+4hmYwVs3X5ZL3eFX
	0JiQaFcUWwHkmhQZYUpjtzUVnukoSf4J7vUOxHMVUJKvpqd4zeJhbkJRoZFqjCY9Dlt5PUizTN7
	ctzGbO8qp98QF3LjKeNLY65lkJsTY+u9n2DM9kacCyukBuPeJg==
X-Received: by 2002:a05:600c:37c3:b0:48a:79d8:a8d6 with SMTP id
 5b1f17b1804b1-490a2a2713bmr55746815e9.7.1780164134577; Sat, 30 May 2026
 11:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260527062247.3440692-1-youngjun.park@lge.com>
In-Reply-To: <20260527062247.3440692-1-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 30 May 2026 11:02:03 -0700
X-Gm-Features: AVHnY4LlgsaObV8OzPDPf_LpIqaNKpOQFAb8yvCAbXMYYoaNetnSwkLdSigY-MI
Message-ID: <CAKEwX=PkiWdgNtoHberaXafQDoDngw5kycfaXeU22MnrXBoAXQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 552611C000D
X-Rspamd-Server: rspam03
X-Stat-Signature: bxr9seffdqrf9d4sdf1rfdyw7sgygwhy
X-HE-Tag: 1780164136-71326
X-HE-Meta: U2FsdGVkX1/R7G/pfI6B5936haFel/4aLBw5JbZo69ShXjPCbJ/ywaRPQrfMifkBL1LKXlC6XhiBtp6N0vdmZ7HCH661QoiG33vXLyI6C5x3ZGz7WsVx5mupGvAWITU/Dv1PZjLqQHfHcy+NUKYWgLVd57O7QEX5XM4tHxJTuE2sl/OWFxuRMUkC69CbU0ZqdIcPT8WlmgpSxiNvL83j25AWvEiV1sjckGd4J092hbXO8EhTtC5je3RHAuESm6nPFU4EODOBjME7CkY3ow5ss/J9pIqognc96h2GBTig3Ah0LK9srFqTR1Wyac3BJyYnwgzhsDRuDfAMpXUKfg37mKS7xNQLwvu0Jci2204xjq6sajfj7JeGrX4lazU78BDi12DAAiI5QD0pRXC7KuUIlNu3tmts+Eq3qQWmM0zq1O9eBUfAN3jk80CTaKwSsTddt+/l+Oc+7E41ANdPswlSWSa3ymSaoBJdmM6lp8bVttPzepXRipvuAJSdk4CBW89ScCWF5uEEU5y/yqwFihBC9lIgvcq/sj7xxj6TK4xULYhtriu0i4DWIq1FDD9L1mMFBDtSFOgcTDMs8FaKv40GKGguGtirMUCBIp/rl8PjhWYs8oS9hD14oJ4Lvd7KzGxDNtSEIipRURpArWOfRsYXgsmiGIyA6HufjRfm60h8VK7Az1iAp79n8Psun6WIho2eJK+50oa54uyKnMay2dZH1fUop9KXxA3ujEDeSiMgIrgZpMaCt012ONwJvkwxYibMveMe/lnYY0R31u469kRt0tT0p1EcV6fc8uUERcKOgeuzPdlIsGq4ZXJSQutn823aaYkHlcXFtkw8vU8CkfWpbO+gSlHBJ5iKiR7J+AGitX4yNlGEpqdZdD5uB41q2uDFHB8e/JFXIuaIemYqr7ihoGe/4LTAYaBInfQJybp/jG29TTazHJF58FJkV92uEstZ/IdnQqKwnklLHd0WHPA
 Hr47PfCs
 no7WLCBDLHsjBhmEk54RbrHspPhp5i+xLTQ+7wE6/NAaMFzNAiQ+fa3RBXcvUgECyJrYVoSyNNNvvNUezbXrhG8RjxY8ULI5AuQbkOBisigTTvoqaPSLqbUAu/RIH9sDMbkjFkkkKL+IA3JlT4S9DF+L8YuMKpSyAsgDeYHib8H8SGxzpSJKdGTkDVD7m5o1THa3x3Jjy3zbJGGq1RqC3YO5DLXlkcFeQCi/XcAbdvHpBwmoYJCQdBnI2PliHNGPMRveC/SRvHLS/5QnbMl7UFwU6Q9kAyDmmc0CDBL8sv2/T/rd7YO3tbqyHS7rR+CPWZwTnyrwr5K00VP/Z7aZGwfwL9LXsxoylfOS0865i1AmtB+rBuCBo6n2nibh4Fi01p0KL+FAmdGy7JW71/lWz9Bd6Tl1nkrp4OBBom+jxCkU4IaMxGgUgem0Ohwwa/0p93pWCmdfXQuRtP3GxQextqqj8CRmnhi+tpmZiK7r+CMnQLKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:23=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> This is v7 of the swap tier series addressing review feedback.
> The cover letter has been simplified.
>
> I revisited the design (see Design Rationale). Since our use case
> fits best with a memcg-based model, the implementation remains
> within memcg and preserves its resource accounting semantics.
>
> Alternatives considered:
>
> 1. A separate sysfs interface under swap. (Workable. But, it would still
>    need to reference memcg paths, and fully decoupling it would add
>    swap-layer logic to manage memcgs, making it secondary option.)
>
> 2. Making the feature non-default.
>
> Other interfaces were also reviewed. Aside from sysfs and BPF,
> the options involve trade-offs and are largely design choices.
> BPF was excluded due to possible disablement on our embedded
> platform, though future extension remains possible.
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Swap Tiers group swap devices into performance classes (e.g. NVMe,
> HDD, Network) and allow per-memcg selection of which tiers to use.
> This mechanism was suggested by Chris Li.
>
> Design Rationale
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Swap tier selection is attached to memcg. A child cgroup may select a
> subset of the parent's allowed tiers.
>
> This
> - Preserves cgroup inheritance semantics (boundary at parent,
>   refinement at child).
> - Reuses memcg, which already groups processes and enforces
>   hierarchical memory limits.
> - Aligns with existing memcg swap controls (e.g. swap.max, zswap.writebac=
k)
> - Avoids introducing a parallel swap control hierarchy.
>
> Placing tier control outside memcg (e.g., via BPF, syscalls, or
> madvise) would allow swap preference to diverge from the memcg
> hierarchy. Integrating it into memcg keeps the swap policy
> consistent with existing memory ownership semantics. There are
> also real use cases built around memcg.
>
> In the future, this can be extended to other interfaces to cover
> additional use cases.
>
> I believe a memcg-based swap control is a good starting point
> before such extensions.
>
> Use Cases
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> #1: Latency separation (our primary deployment scenario)
>   [ / ]
>      |
>      +-- latency-sensitive workload  (fast tier)
>      +-- background workload         (slow tier)
>
> The parent defines the memory boundary.
> Each workload selects a swap tier via memory.swap.tiers according to
> latency requirements.
>
> This prevents latency-sensitive workloads from being swapped to
> slow devices used by background workloads.
>
> #2: Per-VM swap selection (Chris Li's deployment scenario)
>   [ / ]
>      |
>      +-- [ Job on VM ]              (tiers: zswap, SSD)
>             |
>             +-- [ VMM guest memory ]  (tiers: SSD)
>
> The parent (job) has access to both zswap and SSD tiers.
> The child (VMM guest memory) selects SSD as its swap tier via
> memory.swap.tiers. In this deployment, swap device selection
> happens at the child level from the parent's available set.
>
> #3: Tier isolation for reduced contention (hypothetical)
>   [ / ]                    (tiers: A, B)
>      |
>      +-- workload X        (tiers: A)
>      +-- workload Y        (tiers: B)
>
> Each child uses a different tier. Since swap paths are separated
> per tier, synchronization overhead between the two workloads is
> reduced.
>
> Future extension
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> #1: Intra-tier distribution policy:
>   Currently, swap devices with the same priority are allocated in a
>   round-robin fashion. Per-tier policy files under
>   /sys/kernel/mm/swap/tiers/ can control how devices within a tier
>   are selected (e.g. round-robin, weighted).
>
> #2: Inter-tier promotion and demotion:
>   Promotion and demotion apply between tiers, not within a single
>   tier. The current interface defines only tier assignment; it does
>   not yet define when or how pages move between tiers. Two triggering
>   models are possible:
>
>   (a) User-triggered: userspace explicitly initiates migration between
>       tiers (e.g. via a new interface or existing move_pages semantics).
>   (b) Kernel-triggered: the kernel moves pages between tiers at
>       appropriate points such as reclaim or refault.
>
> #3: Per-VMA, per-process swap and BPF:
>   Not just for memcg based swap, possible to extend Per-VMA or per-proces=
s swap.
>   Or we can use it as BPF program.
>
> Experimentation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Tested on our internal platform using NBD as a separate swap tier.
> Our first production's simple usecase.
>
> Without tiers:
> - No selective control over flash wear
> - Cannot selectively assign NBD to specific applications
>
> Cold launch improvement (preloaded vs. baseline):
> - App A: 13.17s -> 4.18s (68%)
> - App B: 5.60s -> 1.12s (80%)
> - App C: 10.25s -> 2.00s (80%)
>
> Performance impact with no tiers configured:
> <1% regression in kernel build and vm-scalability benchmarks
>

Bit late to the party - working on my review backlog right now :)

I see some parallels with this and memory tiering work being done. One
future line of work could be considering how to ensure fairness when
multiple cgroups share same tiers:

https://lwn.net/Articles/1073400/

I can imagine a scenario where one noisy neighbor eagerly swaps first
and occupy all the space in the faster tier(s), pushing the other
colocated tenants to the slower tier(s). We might need to figure out a
way to ensure fairness here (while letting cgroups occupy fast swap
backends opportunistically if there is no resources scarcity).

