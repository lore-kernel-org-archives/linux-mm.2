Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACA6109E52F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2214B6B0089; Wed, 25 Mar 2026 20:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2086B008C; Wed, 25 Mar 2026 20:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8346B0092; Wed, 25 Mar 2026 20:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0CAD6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:10:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CC241B903E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:10:50 +0000 (UTC)
X-FDA: 84586283460.17.C52961A
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 869DF80011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:10:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OMYwP7oV;
	spf=pass (imf30.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774483848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yR8CPRX+MCla1c54IvCJe3qdIOwVb1zd9FVeuuRvr94=;
	b=n4cGHzPq5MEt81me1shg7ZuehU4tmpOB5cLcHXXijLuNNIfHJuFe9rVGorAzZgSRAjdYRi
	QUN13nGb791Y32iq0qi6RNqV7+jrV4ZsZpsBYhVg+P6p84Usu2VU0p6UT8u80NB3js/BPg
	F+VwKEUkesw5q+b0dQsL72xXv4hIXnY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OMYwP7oV;
	spf=pass (imf30.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774483848; a=rsa-sha256;
	cv=pass;
	b=G6+D/VvOiTXkc6gTRa86hvvzYqTUSAd7lqRLqAeCLwmgFvU4nfLfJWBWziczEYdALnyEGa
	StPM+sqrHgquCPG41by7rJgTpz3cs4AnvCG1toesiYDnNF5rtkfdtFvV+xKdrPTv4NMsVh
	H72P2bXQ3fKSTTHoqYc2AGsHRYY+Bd8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48569636800so30135e9.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774483847; cv=none;
        d=google.com; s=arc-20240605;
        b=AP4FX6FJKM7YMrLxGO7mgm5CdD5Y1GjjCbLhaSNirW2KuEFKDdKqHJm8SQfj7XA5d9
         D5nsso1ySVxMn2L1WVXhIp0O3GifbOwA/uFA2ATRqteRp8MpGyDYU038Ot3MpX95mUax
         HM/doVDqQB6VW+ZPntTyv04N459FlgB62zaasT/XMr1aF+nhv2BwL/RfBnaYXTPV761O
         nZq3uPl3KM+B5kmG0MiD3M0Sh9jX7PCiq1eP19GJeBbgZeM7Xk5ZvzqXiXB6wvBFOrcH
         zxWsoNnj9S1LW1L3I3HZ8eN2S8NXlL5lmbRkfildL1YsI+Vpk4CVEj5rJiqXjHK+BJQn
         4F8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yR8CPRX+MCla1c54IvCJe3qdIOwVb1zd9FVeuuRvr94=;
        fh=POieeyJOQAi9KX/+SFBwCKyC5wKbQEX0JnvyibvnlXQ=;
        b=WqANLMuFOKrBrnXIGbEXJvPHFz7aGxAi2wdWMjEnQZQKTiaWXUqfMmq5y5Ffi4xT0u
         Dw035T6FqjTLz0RnTFpR9UfmuOyNp9m2yP9TuDU+XqDNgdpuz1jc4QHuK8i9I9Ny0onh
         f8zPjUQ2yTFaPmTPgqyfrE9F8zx2tJTTq2EqMzbP6gpKltnQPnkF5aXt0Cc9lk7N1yk0
         xMK6MoiVsowqK+KRXE3Vh2DkVVaQSOAcQ5Dfb5m9BYKvWD0B3Qra3AJcj+RGIZL49UEJ
         4Z/brwvd1QTPrzE6qtKaJDEm6lfH0WPoMXaQDKB0F58AHMqXopjpgLGbEzqhowr4rsdD
         nxLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774483847; x=1775088647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yR8CPRX+MCla1c54IvCJe3qdIOwVb1zd9FVeuuRvr94=;
        b=OMYwP7oVs/iHS3Kbwz8gZwt2w7VGzgZy0juqVthXhtQzC/5H/4bKyYOwRbIEvlZgTB
         GlP2mCRcU1SxZj074DOzuSs/byxBsXjy8k4GDE8rUZfYm1oePAO795p5JjZS5Kp+pyuO
         gKMhMhyRPLgDmpa6qriYDTsWSwkHR3IK+SF3IiSZowR2G+HBRmo13T9qXuqMbNAdk3gw
         Jlf8M8gwgi3hjoc0gjiY0qBaQzclPBbz1ngkoPUqepyYiQHy2umDGU5XOM6gTMQDxR7e
         9pta7gbAJm6GfdTrBZ4CXyQJykjFLPyelerPj6jzwLhbSmY4iWOaIlnR6v4qFijU0tHX
         jfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774483847; x=1775088647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yR8CPRX+MCla1c54IvCJe3qdIOwVb1zd9FVeuuRvr94=;
        b=aUnpT93KIDeYW5bW3li7L8N/3uSGVnQPfYqACFYipVVkg8+vYybPNtj428W8wFmV4v
         GarCwH6JFztsN792mZCzXI10xZ2oreO5EfkVcTbzl+d5nMaiwIkGR12t90U8Rme9rOFT
         k+ToKjAvqtETQ3ALL7tHpPYbRb3MDpdI6xGAhuiFaL6N2Qwk6gTKBrH1AoH+gTj0KtrN
         ARlQjdBq6i75oPCieIkJijv6VQDCUSMhyY7TLAg0fCfsQoQtwtx1dsaU6DaEsK9xeOQz
         /FROza87Y1YG5V7dS8s5OjSFOQObqPzU84BBXmp683CVNeWeROXRfrlG1tTJkvUjHBY3
         kOSA==
X-Forwarded-Encrypted: i=1; AJvYcCX+ymnJBbF6hMZ7wlpGtCRzaj/Inltkka2bnlb/LK/Vyy53xEIkJkbDleODFLiU/TZPVBQ2bOib3w==@kvack.org
X-Gm-Message-State: AOJu0Yzo0WMXqqbW/rTpawiQ6lJYmHSp32dVIzesvHAEfqYI1ieGKTt/
	N3AhnqcrLP/TrdJQlkDc5+8i0grslWhQRcejRO8wM5P9JSKTegW49TPoS531GV73iITteVh3/yx
	tuKHMzSdp1CRF1YARtspOSwRhTZG5m0EgctGCHuiI
X-Gm-Gg: ATEYQzxhJR2fNSxCm8/S775WrrY+wtiJ3EYDpUEqGP49aVkX1ImL3TOOxWr4dva70j1
	U2KG6lj8i93WYRAUx3AZ0uMYqTV51oVB1Tllkkz7D/IA7gPPNkK5xai0sVn8voc+n3CR/dWx5j0
	m2ZUtbiZ6CNIPJWxipIlf87cRn8Rrw9zHen+TnwpnQBlmFtr8acc282tNOlvDLIVHOiiKm5m5gs
	/xhNCU10W89qfod6eXHjusnzjOn259j3TwfJolDgRmPrlm2sernFQXY9WI1cMV9xVslaMsJ66om
	iHXKa6o2jmot3kS+/r7sjOdBB9rwXE38iJ/r+QXH9Gi7Lsf9O95hpuJzmXjQ5XNCfHKyPS9tB+o
	uLlik
X-Received: by 2002:a05:600c:9a2:b0:477:255c:bea8 with SMTP id
 5b1f17b1804b1-48720938fd9mr89845e9.7.1774483846234; Wed, 25 Mar 2026 17:10:46
 -0700 (PDT)
MIME-Version: 1.0
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
In-Reply-To: <20260325210637.3704220-1-shakeel.butt@linux.dev>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Mar 2026 17:10:34 -0700
X-Gm-Features: AQROBzDjd7k8G07gelmzXRNjlVKmHcP--nooUDgMHNLNynxjKIo0XEEcejoxIEI
Message-ID: <CABdmKX2T9AmFH4RvShSB_82+_W1fY6fqsAX18C82nOzmTruq6Q@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 869DF80011
X-Stat-Signature: dji68qjq5tsh5t4gr5y95bdm6wornux8
X-Rspam-User: 
X-HE-Tag: 1774483848-164540
X-HE-Meta: U2FsdGVkX19jPvZB+2Bj0SOCE4dFMkIT+y3VtfMV3H0BGZRcDlwztv2Uyjc9G/sAncd9u6uJMW3Du0EwiOs6qpbep49Ro4fdP16me/zLb5EevY1rDtf0cMI+OJp0kt6RD8cKYHPuCCjiFeHkUWqnAuxKBsTnYsWUPGlXfhbM7CJbgkqnaITvS/5yBUvsI9DWZxYkt3lGT1jp2FatnXBCaIiXoHi1YMS8osttV2ikqvEBfKJmpJBIkeDJObfYTB0CFSruQcATkenAD2/Sol2nHfDJ/O4DfRn9msdbQ4dvm6wTx2zA4sUkcuTFov0dv33c7F1+YizufVHYbHqLSMLhfzaY1VyniLQKe/RzENMqT/SyhltJOlO+08HTpqqG0PHlPNQw2asVEu3wnaVYr4jIrr+S7AAFiT44KLsuIW5BgO7CJui6V3t7RcDZmeYHyj0kj4SLlOMVWxPNPw4nQFq/L4s35UVOkBoaxKULF6emaNZYMnJnYwYvRkxX6QpZH7tjYue88FEa5sCu8NfpPFaQVKS4/xhkAgsP5YOipGdHadUOpl1tE/aSUWjM9PUm0utdOQ8770jLRxaYHGQ9rer43oC8ssz6x2+cw2PzQ17HVLzyAvQJ0pHPIYIZUPppaVDQ+qkHXJN6p3iuA5jhOlUViYUG6fPspH5vGGAYFb0qaJPxXo+Uk5TDeT7lhcJDdO2nvrILoQuhx2H2nxKByf47+I83jzfTsHbKplzp9i38qNvJLWHXvmh9sa3yWNjLE0L5x41+5PqFoZm9Oid7Yb1LBBngtPr6ZRiPRn8gpL8Og4F7zxcQZTuazAP8gb7N1sToYIS8jDjj0iRBHMHZ687KA9+0WJr16vxA4h+GJREpVD6N/jcKU5iErYql4MZx4YU+TFryQaSx3M0ir2nbtrEEi6nUvWMOtK5Ju9+OhChGwgQbwdgaMNS3uJLK7ctkV97zCDns+SZ5jiPoRY+/2zt
 iDMeSdl3
 HKoI7nbsJuLhqR/Ama7lxOOxlmOjWEyPtyNDG8k8myZ1YPxUHc63pbWdTMkVdHAT8yPtNwHL9+AGB+Lp4AgREmgfn5Zk9fSp33AVF2vnMc9XyDGUi/M4nkLu6DMwm4lwlrGdVYMsd59pzY3Oo+9azz9KxEFnskhO2UfDUIPOIElG311R2kJaGpCrpDFyi/MsIXKyft94pni6hRna9XdjqtwqgSbrGmEiAAmoJ/2t5ChAqxcMXIeaQOQAQTIJEkJxltEMewBsibsOsIp52sxMbMOmnfrWx5A3wblv92l/JzvpNAjEmB7MUdhDyF976kvn+LgII
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 2:07=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> The Problem
> -----------
>
> Memory reclaim in the kernel is a mess. We ship two completely separate
> eviction algorithms -- traditional LRU and MGLRU -- in the same file.
> mm/vmscan.c is over 8,000 lines. 40% of it is MGLRU-specific code that
> duplicates functionality already present in the traditional path. Every
> bug fix, every optimization, every feature has to be done twice or it
> only works for half the users. This is not sustainable. It has to stop.
>
> We should unify both algorithms into a single code path. In this path,
> both algorithms are a set of hooks called from that path. Everyone
> maintains, understands, and evolves a single codebase. Optimizations are
> now evaluated against -- and available to -- both algorithms. And the
> next time someone develops a new LRU algorithm, they can do so in a way
> that does not add churn to existing code.
>
> How We Got Here
> ---------------
>
> MGLRU brought interesting ideas -- multi-generation aging, page table
> scanning, Bloom filters, spatial lookaround. But we never tried to
> refactor the existing reclaim code or integrate these mechanisms into the
> traditional path. 3,300 lines of code were dumped as a completely
> parallel implementation with a runtime toggle to switch between the two.
> No attempt to evolve the existing code or share mechanisms between the
> two paths -- just a second reclaim system bolted on next to the first.
>
> To be fair, traditional reclaim is not easy to refactor. It has
> accumulated decades of heuristics trying to work for every workload, and
> touching any of it risks regressions. But difficulty is not an excuse.
> There was no justification for not even trying -- not attempting to
> generalize the existing scanning path, not proposing shared
> abstractions, not offering the new mechanisms as improvements to the code
> that was already there. Hard does not mean impossible, and the cost of
> not trying is what we are living with now.
>
> The Differences That Matter
> ---------------------------
>
> The two algorithms differ in how they classify pages, detect access, and
> decide what to evict. But most of these differences are not fundamental
> -- they are mechanisms that got trapped inside one implementation when
> they could benefit both. Not making those mechanisms shareable leaves
> potential free performance gains on the table.
>
> Access detection: Traditional LRU walks reverse mappings (RMAP) from the
> page back to its page table entries. MGLRU walks page tables forward,
> scanning process address spaces directly. Neither approach is inherently
> tied to its eviction policy. Page table scanning would benefit
> traditional LRU just as much -- it is cache-friendly, batches updates
> without the LRU lock, and naturally exploits spatial locality. There is
> no reason this should be MGLRU-only.
>
> Bloom filters and lookaround: MGLRU uses Bloom filters to skip cold
> page table regions and a lookaround optimization to scan adjacent PTEs
> during eviction. These are general-purpose optimizations for any
> scanning path. They are locked inside MGLRU today for no good reason.
>
> Lock-free age updates: MGLRU updates folio age using atomic flag
> operations, avoiding the LRU lock during scanning. Traditional reclaim
> can use the same technique to reduce lock contention.
>
> Page classification: Traditional LRU uses two buckets
> (active/inactive). MGLRU uses four generations with timestamps and
> reference frequency tiers. This is the policy difference --
> how many age buckets and how pages move between them. Every other
> mechanism is shareable.
>
> Both systems already share the core reclaim mechanics -- writeback,
> unmapping, swap, NUMA demotion, and working set tracking. The shareable
> mechanisms listed above should join that common core. What remains after
> that is a thin policy layer -- and that is all that should differ between
> algorithms.
>
> The Fix: One Reclaim, Pluggable and Extensible
> -----------------------------------------------
>
> We need one reclaim system, not two. One code path that everyone
> maintains, everyone tests, and everyone benefits from. But it needs to
> be pluggable as there will always be cases where someone wants some
> customization for their specialized workload or wants to explore some
> new techniques/ideas, and we do not want to get into the current mess
> again.
>
> The unified reclaim must separate mechanism from policy. The mechanisms
> -- writeback, unmapping, swap, NUMA demotion, workingset tracking -- are
> shared today and should stay shared. The policy decisions -- how to
> detect access, how to classify pages, which pages to evict, when to
> protect a page -- are where the two algorithms differ, and where future
> algorithms will differ too. Make those pluggable.
>
> This gives us one maintained code path with the flexibility to evolve.
> New ideas get implemented as new policies, not as 3,000-line forks. Good
> mechanisms from MGLRU (page table scanning, Bloom filters, lookaround)
> become shared infrastructure available to any policy. And if someone
> comes up with a better eviction algorithm tomorrow, they plug it in
> without touching the core.
>
> Making reclaim pluggable implies we define it as a set of function
> methods (let's call them reclaim_ops) hooking into a stable codebase we
> rarely modify. We then have two big questions to answer: how do these
> reclaim ops look, and how do we move the existing code to the new model?
>
> How Do We Get There
> -------------------
>
> Do we merge the two mechanisms feature by feature, or do we prioritize
> moving MGLRU to the pluggable model then follow with LRU once we are
> happy with the result?
>
> Whichever option we choose, we do the work in small, self-contained
> phases. Each phase ships independently, each phase makes the code
> better, each phase is bisectable. No big bang. No disruption. No
> excuses.
>
> Option A: Factor and Merge
>
> MGLRU is already pretty modular. However, we do not know which
> optimizations are actually generic and which ones are only useful for
> MGLRU itself.
>
> Phase 1 -- Factor out just MGLRU into reclaim_ops. We make no functional
> changes to MGLRU. Traditional LRU code is left completely untouched at
> this stage.
>
> Phase 2 -- Merge the two paths one method at a time. Right now the code
> diverts control to MGLRU from the very top of the high-level hooks. We
> instead unify the algorithms starting from the very beginning of LRU and
> deciding what to keep in common code and what to move into a traditional
> LRU path.
>
> Advantages:
> - We do not touch LRU until Phase 2, avoiding churn.
> - Makes it easy to experiment with combining MGLRU features into
>   traditional LRU. We do not actually know which optimizations are
>   useful and which should stay in MGLRU hooks.
>
> Disadvantages:
> - We will not find out whether reclaim_ops exposes the right methods
>   until we merge the paths at the end. We will have to change the ops
>   if it turns out we need a different split. The reclaim_ops API will
>   be private and have a single user so it is not that bad, but it may
>   require additional changes.
>
> Option B: Merge and Factor
>
> Phase 1 -- Extract MGLRU mechanisms into shared infrastructure. Page
> table scanning, Bloom filter PMD skipping, lookaround, lock-free folio
> age updates. These are independently useful. Make them available to both
> algorithms. Stop hoarding good ideas inside one code path.
>
> Phase 2 -- Collapse the remaining differences. Generalize list
> infrastructure to N classifications (trad=3D2, MGLRU=3D4). Unify eviction
> entry points. Common classification/promotion interface. At this point
> the two "algorithms" are thin wrappers over shared code.
>
> Phase 3 -- Define the hook interface. Define reclaim_ops around the
> remaining policy differences. Layer BPF on top (reclaim_ext).
> Traditional LRU and MGLRU become two instances of the same interface.
> Adding a third algorithm means writing a new set of hooks, not forking
> 3,000 lines.
>
> Advantages:
> - We get signals on what should be shared earlier. We know every shared
>   method to be useful because we use it for both algorithms.
> - Can test LRU optimizations on MGLRU early.
>
> Disadvantages:
> - Slower, as we factor out both algorithms and expand reclaim_ops all
>   at once.
>
> Open Questions
> --------------
>
> - Policy granularity: system-wide, per-node, or per-cgroup?
> - Mechanism/policy boundary: needs iteration; get it wrong and we
>   either constrain policies or duplicate code.
> - Validation: reclaim quality is hard to measure; we need agreed-upon
>   benchmarks.
> - Simplicity: the end result must be simpler than what we have today,
>   not more complex. If it is not simpler, we failed.
> --
> 2.52.0
>

Hi Shakeel,

Nice outline, I'd be quite interested in this discussion. It's a
little difficult for me to imagine a reclaim_ops getting us to
complete convergence, but it seems like a good way to start making
progress.

Unfortuantely I got an LSFMM Invitation Decline, so I won't be there.
Take good notes. :)

-T.J.

