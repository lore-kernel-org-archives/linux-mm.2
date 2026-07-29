Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF05C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47436B0182; Wed, 29 Jul 2026 11:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F896B0183; Wed, 29 Jul 2026 11:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34AC6B0185; Wed, 29 Jul 2026 11:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A76E56B0182
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:04:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3729A16073A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:04:54 +0000 (UTC)
X-FDA: 85042136508.16.9117A27
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1CCE420015
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:04:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="qlDYIMD/";
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGG0okGsZow/JjukelG2rrmQwz8JWbz8nuI5lxe/ZxQ=;
	b=hgqMRNjqsaEFzvnqViW+xPHGuWSq5fknODAcWRYDIR8svAguK2c9HVw40VGcZxcqczuBHt
	5N1lMQ8vTjzp1v93zICFngpvBP7AsvYICLLZydCedpcqrYOdTSfLmNLscu7nlZFRkSFNSr
	TfSBuDKdYNb2pXstDDyb+1cRAc1dL1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337492;
	b=d2j97ZLw3PBGi9650VVf8PD9x0JTIXVkorJlg3oCprwU+Qtk9ilYnlWZ9qZjRaddKPDvcT
	LGUpqcNYqMzOyj037V/TwngRDDl+EL8/gn8R8wLCM5VZxE8X7eP/Cbp/mOQfedB8lOPx0h
	f2U1B2OdHHaCAkK63EVBQ/UE5wUL8kc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="qlDYIMD/";
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8efb708b1a0so6600316d6.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785337491; x=1785942291; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jGG0okGsZow/JjukelG2rrmQwz8JWbz8nuI5lxe/ZxQ=;
        b=qlDYIMD/3UUGq0eZfSL5hZTKhKZg7FJo/s107im3fBPy/dzuVTtM/H5RvFzDDGg7TT
         XPuhrDcHIM0CcDaJtoCR2SxfTLJvL4e9mChSIDsEarlrNuVuU30WD0mFY76hrWcqsmCL
         /+ccpagVlbB5jP6im2ffxfcZivmMutum6VCOG6nSjlh6Spd/J5xRvZ0BKJ8JUtzL1Y0H
         Rl13DuNay/dUbw2wH8a737hra3JKM3RhDUa7qoUFAE2WDhwt+/buPKHRMBm+v5Yy2yF3
         A7KnqA2X5CluUVB4PsaKYMbYZ110nILvh3eSGUaDJ3OL/Me1dRDJJb1x+lXmqaht4KJm
         zI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785337491; x=1785942291;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jGG0okGsZow/JjukelG2rrmQwz8JWbz8nuI5lxe/ZxQ=;
        b=RANaRR7lwdNixepz5H+7i6hb5Lc7FdXVc40uGsLWmVpGp8paYaUny1GRkQrzbLejRZ
         zp53+EZJx49tIaDqNaGG86J14q0rAHQHFEyiGQJskHFK6F7MHxnoMEWEzShSMk04l72C
         Y5nlhaZkreHWLbvHuasQ2Svv8DLHC8+WLOs+gTH60zNQFTUdLKZ7ZsCOkUH1GPzrR45C
         RyGtvdj7RHZmrX4roJyfZWdHMV/bv5YkE4K6kOblkqr0oBey6C1fjGEwziX191+JPLmR
         SlRc7s4V9GTMa/Eg8TnXIXBr+NHUTA824zL0xvqTHbOVffVbGBMiKGDekYstvY/8w/xp
         vSGg==
X-Forwarded-Encrypted: i=1; AHgh+Rqjy/JiOBn/rYJpzUQHl01AmQ3P9IMwLTCS+ufNNRuIJDFVMRScljaKVElRjzNzoG5A1ljzLAOS+Q==@kvack.org
X-Gm-Message-State: AOJu0YycJkEjcBCWdo9Bo+BEFSmMdPjTWcl+J457J8oBrotLmkz6meV0
	Jl/0LjC3dw7NSsoMTK0Uvyfl0tt7aczs5d1Ye3ahYg997M6XgHJ8dE50ILbMHbr5VA0=
X-Gm-Gg: AR+sD10QDkNb7Cb39tqMCQWAD+d6lNFakkkQelBI097FbCLMAatTmFuBlWj5ua4ds+W
	F2dHkbaBMJr1SnhLNxCGIWl7UhulF5cLcZTPCOgVRyww+SkkQu0X93rqT58GQtCzYrggnW9Nsqo
	qrYnx0iqqn0d9btjiqoYRPuA1Tquui1xSkcTHSb3gz3PPJnXWFujPuBDSnLyttMh2D1EIjgMsDL
	YibF51wizMms+Wi5pqORNmIoTOvdVJaAxRXtQ3EKkW5FR2d3rOUCLO0Cv/8N1vBwtEmZLuKZ1UQ
	otHEXTMBZFjcHDOxxkY8adv0QtwQAbjUQvTuGSenw9JA6syd8C1HkMRWVpcr9bJhXKI6e/kh046
	LJRl6p0wln+tDLGTh1QNaGjKurdGMhEZZfOPJ9A/NE/Cg6rNJ8GZzJIT+/ofP8es2qFvOFmn2SY
	x6UvQDInLAw0A/KqLIgWmKU2PCEEpmTGlqFNaPrGUTr+W/FCQshFTDWZQn5X4=
X-Received: by 2002:a05:6214:5f0b:b0:907:5228:67d3 with SMTP id 6a1803df08f44-908173492b6mr71417526d6.44.1785337489138;
        Wed, 29 Jul 2026 08:04:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc496f7sm26096536d6.3.2026.07.29.08.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:04:47 -0700 (PDT)
Date: Wed, 29 Jul 2026 11:04:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
Message-ID: <amoWjOnPayHVQU9v@cmpxchg.org>
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
X-Stat-Signature: a5fxd4bxifjm5o9sx5qktuopjr9fxzzi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CCE420015
X-HE-Tag: 1785337491-808037
X-HE-Meta: U2FsdGVkX19Edgmlg8SIzRefn3gicnnSAE00z0S+ORy283bqvqEy9IBT8brLHvkluob4dbFyH8x2M4tm0ZVR6+HfBBYiQdqOAjVOiMutFRWmqF8JUV/7ySJ1KEyer9OtSTGhm2cj6XJkiElN/c5sPKAvWJXCyBoQAdG0XTOrDCwaBScfAKsSV/cDv9bxKeP57wip+ByhO2MzCp7SE6AT8XhJXhK+SOSYhuEL7BHsgB2PwUpZ5u0LzjD/4YhBGfz1g9O1Pi/ruKaHK22MvRSt+6kXP3UzMubeLTTYR2Apx/L5buce2Umlakh/xj8k8E41QXpLH4F7BqmjMbVF4OFFRk+c+SSR+zQdiKxQnpKFBxjGD3Q1Cd6CQAsbB8vH/LkHrDV3RH4q+CNvjc/JyeKb5M3RnCiJyvIasEXNk1D8LHX8RJV5U2p6xV2HxkOMOg51pPKK5ow9CwwdgmMJLVPPb/TVEQ+DIuhVlEYIHk0T9gcynX6P+n9NFc8UUwlm8xQKDX0rqyBS5gUThHjINTH1U7DRppazUfSh8WXB4XpsXtxbSUFO0rIW/8vs+cYRvOEFYmnb3Sl0oW+urmtflEnDIZcdVSHIYWyHgRqWjCPvLPO5ZqNmCVbgMox4BkQB+Rni+upeHcdZRN1QrSweqnjUnc4yUdJu92nvuAKfiGmMZQnFrpyVDdukWZWjGM7qsxRRYsYX+JzPpz7BPGxQverLs4mT27ai/35En4BTbbqU8PdhD+/HA8/hN1WdT/HsYULrG05nKAJu51d+ALuM66JfhtOiACn1tPtJarxKNw4xb0wNvtHwOySV2DBQoW8mwxEm71RTRv4YGJPqBvsES6XkCMvnixpan8lBAUDtFUTNsBBEbKJYqokXet4KB/JJXFCyz9P9G4EUlCsZfpPXJtQFJ0xtlWWlXf2fm2qBKXWKEzlgQwB81YgXfS8b2kprslOyXZGgcawXLOmqoAa+klC
 6gCCF3Qz
 j2PbpPYh/NDsIZ9YQMB8GVYt98FNJP32HLre7aNQHN82M2TksvGKTOOZGqz6+H6tRT4ZXK6q8X6DD5M+0kPZKjLl2drw9zPf84p0gO4+TWdIHoMtD0tSxwPxlgA0FnvEkTFHPsh5VAVsp8AYOJ5UXdEpeTQ3peb2b9+UZZIRJFFf5Zi9cPTVr6bVbVVWMt7VejtakBzHC+FIrnNOzvM0m4baQNl5wWeiwELVzH6WlunkRoG3BsiswIxrxzfiYKZshSIHPo5R9O2eFqp+vdh8xJcWF6d590dkW6y2VerszswKTXLDhXovWHY81xbEt0s74Bj3Tu3PPdEype1UYp74VviREq7gIXPyK61KfTaPTC/h+/lBOf6mvnYCfpXPCqTmzCWWHUouWugE0UfKKgoJKo8mhdFD9fks7idRFxs1TmDyafpplsi1G0o4G55tyvvnv4ZKvmO9PHDUK8mu8l0ArBOg4pDf3viJEYsIxk09zIkR9LiYBJLxPipoJuO8F3uKmEK7Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 02:38:53PM +0200, David Hildenbrand (Arm) wrote:
> On 7/8/26 19:52, Joanne Koong wrote:
> > On Wed, Jul 8, 2026 at 12:56 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 7/7/26 22:17, Joanne Koong wrote:
> >>> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> >>> to the deferred split list at fault or collapse time. As a result, a
> >>> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> >>> the deferred split shrinker when the system is under memory pressure.
> >>>
> >>> Add anonymous mTHP folios to the deferred split list so that if there's
> >>> memory pressure, a zero-filled mTHP can be split with its zero pages
> >>> remapped to the shared zero page and then reclaimed.
> >>>
> >>> To minimize overhead on the common order-0 fault path, the
> >>> deferred_split_folio() call is guarded by an inline folio_test_large()
> >>> check.
> >>>
> >>> Suggested-by: Usama Arif <usama.arif@linux.dev>
> >>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >>> ---
> >>>  mm/memory.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/mm/memory.c b/mm/memory.c
> >>> index 6637c5b13c9b..441d918e3dc0 100644
> >>> --- a/mm/memory.c
> >>> +++ b/mm/memory.c
> >>> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> >>>       folio_add_lru_vma(folio, vma);
> >>>       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> >>>       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> >>> +     if (folio_test_large(folio))
> >>> +             deferred_split_folio(folio, false);
> >>>  }
> >>>
> >>>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
> >>
> >> I had a session [1] at LSF/MM about having essentially all large anon folios
> >> part of the the deferred split queue.
> >>
> >> (1) I don't think this scales.
> >>
> >> (2) I suspect the shrinker should make smarter decisions of what to scan/reclaim
> >> first.
> >>
> >> I think this needs more proper thought.
> >>
> >> [1]
> >> https://docs.google.com/presentation/d/1RfKWCY1AMVns-WLn-QdAWbI2a-rA7fbFyh7XD1Wn5BY/edit?usp=sharing
> > 
> > Thanks for the link to the slides! Was there a conclusion from the
> > LSF/MM discussion about the future path forward for deferred splitting
> > or is that still being determined?
> 
> Sorry for the late reply. Unfortunately, it wasn't clear yet if we could
> reporpuse the LRU, whereby we would just naturally benefit from the LRU cache
> (soon) and only manage pages on a single list.
> 
> The concern was that we might end up scanning many items on the LRU to detect
> splitting candidates.
> 
> I am not 100% sure if that is a real problem.
> 
> As raised during the last THP cabal, my gut feeling is that Johannes might have
> an idea on how to improve things here.

I've been trying to reconstruct all the details we talked about at
LSFMM ;)

Going over this again, I still have to conclude using the anon LRU for
splitting is not a good idea. Let me try to lay it out:

(1) The anon LRU isn't scanned at all when there is no swap. This is
    fixable, but requires some re-architecting of the vmscan stack.

(2) With a mix of basepages and THPs, there could indeed be a lot of
    basepages ahead of underused THPs. That means swapping before
    getting to space that is much cheaper to reclaim.

    The current setup isn't perfect in that regard, as the shrinker
    runs simultaneously as the LRU. But it's making guaranteed forward
    progress through the THPs, even as the first LRU pages are scanned.

(3) The anon LRU has folio lifetime, but the splitqueue is one-shot:
    we scan each THP once, and then it's either split and dropped, or
    found full and dropped. That THP never needs to be revisited. The
    queue actually empties as the workload establishes itself.

    The anon LRU ~ splitqueue argument is only true around startup.

    If we used the anon LRU, we'd need per-page state to avoid repeat
    underused checks. And we need external state to not scan the anon
    LRU at all if there are no new THPs (and no swap). And if that's
    just a counter for "new, not yet scanned THPs", a single fault
    will cause you to walk the entire anon LRU before you get to it.

(4) The anon LRU is driven based on the cost of swap and observed
    refaults. These metrics are inherently bad modulators for scanning
    underused THP space.

    Using the anon LRU for splits means that if anon scanning slows
    down and we lean more on the file cache, we'd also slow down the
    search for unused THP space. This is undesirable. File cache is
    still more valuable than uninitialized anonymous memory:

                    | anon | file | uTHP |
    ----------------+--------------------+
    cost to reclaim |    1 |    0 |    0 |
    ----------------+--------------------+
    cost to refault |    1 |    1 |    0 |

    We're thinking anon LRU because those splittable, potentially
    underused THPs happen to be anon. But anon user data that needs to
    be swapped out is an inherently different class of reclaim targets
    than the uninitialized space *between* such anon user data.

    We really want uTHP -> clean cache -> swap reclaim ordering.

    Classic LRU takes this even further. Because of how the page cache
    grows endlessly compared to heap memory, classic will scan *only*
    the file LRU until those pages start refaulting. Using the anon
    LRU would get us a clean cache -> swap / uTHP ordering.

So I think reusing the anon LRU is flawed. It's fundamentally
different needles in fundamentally different haystacks.

If we can agree on that, then the lock contention problem has a
different scope as well: it's a simple optimization issue, not a
fundamental data structure arrangement issue.

If I understand you correctly, the concern is that people will enable
all manner of mTHP orders, and 99% of the anon faults, including all
the order-3, order-4 pagelets, will go through the list_lru lock on
fault, with no batching.

I do think that's valid, but how concrete is that right now? Is anyone
actually doing that? I would have some concerns purely from a
servability POV: the page allocator, watermarking, compaction etc. are
still a bottle neck for high rates of lower orders, as we've been
noticing with the page cache and the optimistic vmalloc higher orders.

The concrete proposal I've seen from several places was much simpler:
I have ARM 64k basepages and I want 2M THPs.

But in that case, the splitqueue looks no different than on x86 today.

My take is that we should add mTHPs to the split queue as-is. Deal
with the locking/batching concern when real usecases say we should.

