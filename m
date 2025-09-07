Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE33ECA101F
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 17:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF436B0007; Sun,  7 Sep 2025 13:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A865F6B0008; Sun,  7 Sep 2025 13:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C3B6B000C; Sun,  7 Sep 2025 13:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 781E86B0007
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 13:40:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E14E9160820
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 17:40:00 +0000 (UTC)
X-FDA: 83863167360.09.28C141D
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0AD2420008
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 17:39:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757266799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/NPu1TbqdbV47JB02VcG81ReauvFzynMCtpZaKo+RU=;
	b=dcATvH0Ey+9juFX7cUR9B+z7qA1NRKXi55HCeEyVHHV8n+Lvua1UYag7cZKLcyRZX0r+07
	epvlxKja4e8ypvrE/p3hiko31aMhkIXnhT/1viA/vEw3kRtI4//Ptk8TT0t6hJTu26H+Xi
	L4iem4hGxSzKMT277kNjtYD829oXXvE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757266799; a=rsa-sha256;
	cv=none;
	b=YWqNumPrPUcAMojcnsklHpHhLKDRQnDxhbhUWwlxFJj1AcjyEc1WdmPUE/wjZrTcW6I2lo
	SfMfPXTkjc6+hAj9gv9zlmIjJnL65UfLsMDgJIVjPQ1b3YWxwRENWtzgOXk+6OpKd2Yy7Y
	EW5efOI0Rj+8v85sloy88ZK2tdT2KAc=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 8 Sep 2025 02:39:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 8 Sep 2025 02:39:54 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aL3Dav4RLvtLliYC@yjaykim-PowerEdge-T330>
References: <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
 <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
 <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330>
 <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330>
 <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
 <aLqDkpGr4psGFOcF@yjaykim-PowerEdge-T330>
 <CAF8kJuPuOWUEMg6C9AnAA-mddgHRjuMVqURrbk6bUHxAmEvgFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8kJuPuOWUEMg6C9AnAA-mddgHRjuMVqURrbk6bUHxAmEvgFQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0AD2420008
X-Stat-Signature: fb9akqhxo778ahiyaw74tjs4x8oqfry4
X-Rspam-User: 
X-HE-Tag: 1757266797-404582
X-HE-Meta: U2FsdGVkX18Vs+41C8xzXeoW/hcznO9GAmVVF1vOGTSUa++/sqIKoi5yn9FllSdlZ+dmJeaPT7tUC4jHrbs/pqsR6FZsv2G4H/T1JLgRP4I3GqUGOT11LF1lEd6n2wwebOyt4u5yi1d6+/jBd1CmoeZzIhZawwoUALRE6igT8IkJEa8JQFqh4ueIn5S78+A3erSIExFTbMmDt8sqFfWa3ExRifNLXlgi4wM+i+PT4ICU59sBAr1b2lTYOhFRO262InlamHwbj01c4b7R7LhkZET6jL6Qet/aKoJPy5n6YHGHmTH2KWQu+E/4h6yZgV3Aevr4DC0nSBfmWMqfxguxbYwVxey7DSATeRFInR9XssuY2FVkLXRUiNU0mf2pRoEJQFykbJ4nCDKIPBsdlhkgZGshm5TOH6XtObkSLqoOJUwbggQv4Av3Ccpi2x4K83NDclbb2yEcrDyVUs5SzzYcEvroxJ0J2N3JeN1QCvL3ET5a0y3ouIojyUrmbQvqNU0b2tenoJHHbgrQLf0W2KXkfEcK46oSVn1+iH6wmCspvm81l/VQ7lQ1NS57tIhFh3A2KnVT4KA9tzsF8tvTC9yN/IIPS+HKlckHmJrObnRWadwGB6eODwXe1uHt5zak6AHsj1fSaQG7p7GZ3l+Gqx16tQ1LLEH9P+zRmz430SB5ZXP6CL2+6TehAsN0g8NRO7ep6jhLOp0v+FUnxnqRKQiEV+Tndg3eOm6pOXJiNIZGfl53f/OH4TRp+kSahl70FcxGmBIFglC8GmB4zTGTMBo2hdgmGrSopba+6N6F8Pr1d+BPDOFpSgTJ/0fBCl9/dQZMHEX4ti/hPcufS9aNuESRFp4GNketiGW2wJhkFmDYo6HkpKo/Sn9fC6XsDm7UTxPxkNosNSd7FiTG/73d6IJFRZ47UahUOkHcp8rgeamWv6rqaXanfX4UCINq2IoJrcBkcDRRHzSJlG4Dj/Xsbpe
 OOg0kqPZ
 9K94hzqvxOdMGmLCp+Y5dNpb6MqmmEMYP/vUp+I4UqzYY9ohbNDmjtTgWNrwpEjjPpTxNnyYRl4GomKcpcEt5qzyeV3c/wA+KOIjgqLA6+R8n6YFjygHbvUfSNPh0hnWCwSy1pNe7fgd3hV5sP8sImutNtiYRzFlyFuXzoNByFFRgljy5W3jA9iEsA8QV98N96qXGesOLJwASGCQIC8OQdyRz7201U63AnumAreh3v61+IAAKV9bwF/eUJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Chris Li 

Thank you for your thoughtful and quick feedback.

> > If you remove the
> > swap tier. the range of that tier merges to the neighbour tier.  That
> > way you don't need to worry about the swap file already having an
> > entry in this tier you swap out.
>
> Should the configured mask simply be left as-is,
> even if (a) the same key is later reintroduced with a different order (e.g.,
> first → third), or (b) a merge causes the cgroup to use a lower tier it did not

Let me clarify my concern with a concrete example.
Suppose:
1. SSD → tier "A" (31–40), HDD → "B" (21–30), HDD2 → "C" (10–20), HDD3 → "D" (0–9)
2. A cgroup uses tier "A"
3. SSD is swapped off → tier "A" becomes a hole
4. Tier "D" is removed
5. Tier "A" is reassigned to range (0–9)
6. Then a cgroup configured with "A" cannot actually use "A" (0~9)
7. Later a new tier "E" is added and assigned (31–40)
8. A cgroup now configured with "E" refers to the same numeric range (31–40),
   but the meaning has changed compared to when it used "A".

This feels unintuitive. I would prefer invalidating the mask if the referenced
tier is removed, so stale references don’t silently point to a different tier.

> I think my intention may not have come across clearly. I was not trying
> to propose a new optimization, but to describe a direction that requires
> almost no changes from the current behavior. Looking back, I realize the
> ideas I presented may not have looked like small adjustments, even
> though that was my intent.
>
> I see. We don't need to jump to implementation details yet. I can help
> you resolve the swap allocator internals as well. Let's have the
> user's visible behavior settle down first.

Ack. Let’s settle user-visible semantics first and defer allocator internals.
We can revisit per-CPU cluster cache handling as a lower-priority topic when we
move to patchwork.

> I talked to Wei about swap tiers a bit. Add him to the CC as well. He
> made me realize that we need two level things in the cgroup
> "swap.tiers".
> ...
> For the operation, each tier will need two bits, including the
> default. One bit select this timer off, one bit select this tier on.
> e.g. we have 16 tiers including the default, then all 16 tiers take up 32 bits.

My understanding is:

Per tier (2-bit state)
- `+` → always on (bit 10)
- `-` → always off (bit 01)
- missing → inherit from parent (bit 00)
- `11` is invalid

Default tier
- `+` means inherit parent as the base
- `-` means start from zero (ignore parent)
- missing means (this is the part I want to confirm) nothing?

So in my view “default” is an **inheritance control knob**, whereas in your
explanation “default” is also a **special tier** with its own 2-bit state.
Is that the right reading?

If my understanding is correct, I’m also happy to adopt the interface format
you proposed.

Over the weekend I kept thinking about it, and your proposal looks like a
more flexible interface. It also has clear similarities to how cgroup
controllers are added, so the format seems acceptable to me.

I have one remaining concern about cgroup semantics.
The inheritance and resource model we’re discussing seems to diverge
somewhat from existing cgroup v2 conventions. Since we’ve aligned that
this effectively acts as QoS control, it also makes me wonder whether we
should proactively propose a doc update to the “Resource Distribution
Models” section so the concept is explicitly covered. This may be me
being overcautious, so I’d appreciate your view.

> Wei also raises one very important point. Because zswap is not tight
> to a swap device. We might want a predefined tier bit to describe
> zswap. e.g. the first tier bit is always given to zswap and the tier
> name is always zswap, the priority range can be assigned from
> mm/swap/tiers interface.

Ack. Reserving a predefined tier bit for zswap makes sense.

As a passing thought (not a strong proposal): a few common tiers (e.g., zswap,
ssd, hdd, remote) could be predefined and non-removable, with users inserting
custom ranges between or apart from them. For example, if an SSD tier is
predefined, `swapon` for SSD devices could be limited to that tier—this would
align with grouping by service speed and nudge users toward sensible configs.

> > * **Tier specification**
> >   - Priority >= 0 range is divided into intervals, each identified by a
> >     tier name. The full 0+ range must be covered.
>
> Not necessarily true if we allow removal of the tier and generate
> holes removed range as we discussed above. Unless I understand the
> previous hole idea incorrectly.

Ack. I prefer allowing holes, so we don’t need to enforce covering the full
range simply. 
(I had considered usage making full-range coverage coexist with holes, 
but on reflection that doesn’t seem necessary. complicated)

> >   - Each tier has an order (tier1 is highest priority) and an internal
>
> The order you mean swap device priority order or the tier internal bit order?

I meant the order implied by the priority ranges. In the interface I suggested,
the `-` operator specifies ordered ranges, so a notion of tier order matters.
With your format this may not be needed or not that important.

> >   - Until it is set, there is no default tier.
>
> Does that mean you can't do incremental add or incremental subtract tiers?

> >     (may internally conceptually used? but not exported)
>
> My suggestion now is "swap.tiers" is an operation rather than a
> bitmask. It can include "default", Each tier can select on or off or
> missing so 3 operation states. "default" tier has no name, if
> specified, must be listed as the first in "swap.tiers"

When I said “default tier,” I meant a conceptual tier that covers the full
priority range when nothing is specified. From your reply, your “default”
sounds closer to a *default value* (inheritance control) rather than a
standalone tier. Did I get that right?

> >     Note: a space must follow "+" or "-" before the tier name.
> >   - Edge cases:
> >       * If not all ranges are specified: input is accepted, but cgroups
> >         cannot use incomplete ranges. (TBD)
> >         e.g) echo "hdd:50" > /sys/kernel/mm/swap/tiers. (0~49 not specifeid)
>
> Because removing the tier will generate holes in the priority range
> anyway. 0-49 is not specified in the same as if a tier is there
> previously then gets removed.

As discussed above, we’re allowing holes, so we can accept inputs that don’t
cover the full range.

> >       * Overlap with existing range: removal fails until all swap
> >         devices in that range are swapped off.
>
> Specifically a new tier priority landing in the middle of a tier
> range, the new tier will split the range with the existing one.

If swapoff is complete but removal has not occurred and a new tier comes in,
we can allow splitting. If a tier reference is still held, splitting should not
be allowed. A corner case: a tier spans 50–100 but only priorities 55 and 60
have active swap; inserting a split at 70 (no active refs) — to keep rules
simple, I’d still **not** accept the split while any references exist anywhere
in the original range.

> > * **Cgroup interface**
> >   - New files (under memcg): memory.swap.tier, memory.swap.tier.effective
>
> I don't think we need two interface files. We can live with one just
> "memory.swap.tiers"
> We can list the local one first then effective one on the second line
> or separate with "#"

Ack. One file is simpler; show local then effective. For now, a newline
separator looks clearer than “#”.

> >   - Syntax modeled after cpuset:
> >       echo "ssd-hdd,net" > memory.swap.tier
>
> Need discussion for incremental subtract. That syntax is incremental add.

I think the format you suggest (+, -)
is appropriate from a flexibility perspective.

> > * **Swap allocation**
> >   - Simple, workable implementation (TBD; to be revisited with
> >     measurements).

Ack.

Best regards,
Youngjun Park

