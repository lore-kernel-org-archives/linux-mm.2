Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6067CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1116B0096; Wed, 29 Apr 2026 09:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8316B009B; Wed, 29 Apr 2026 09:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5BC6B009D; Wed, 29 Apr 2026 09:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17FE6B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:52:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 198791C0351
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:52:37 +0000 (UTC)
X-FDA: 84711733554.02.A3917FB
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id C39E040006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:52:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="VAAvz/C7";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xppRCqAQC4xKx5jzTnW41eBchdpaLIr292ff3JfaZWA=;
	b=6MdZdX6OxTk6h+U2h3Ff4Ok8k73w9T1oQjecfipjXMp62OMuQL7KvM/e0rSYQUnM4iNsfs
	O2YUxXB3I7MJ94gnj/vgyDv7v3hqDogdXnzzWzKK2rhJXN35EMGbruyAYw4PKXURbB0YWW
	zB4zN4WIAVBRHCTgsIv3MS2zpctzJMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470755; a=rsa-sha256;
	cv=none;
	b=SnTCravH6Qt4eUtDrD+htNDOL9TFmFbtrdPKkR064WADbvd+ArjWHxGJY0LgDRJj22biZj
	/liuVyR99GWzKymJdixBkQDB1BEinm0tQ5taA0eS/LaCEf24Ey0ldtvo1bDY4YeVCFoA+p
	2+ESuQ5eR4ut6B5yMV6DM0sqZy8OxxY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="VAAvz/C7";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43cf7683a28so8392564f8f.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1777470753; x=1778075553; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xppRCqAQC4xKx5jzTnW41eBchdpaLIr292ff3JfaZWA=;
        b=VAAvz/C7eh1CYZT0Nx3pBlxRNl7qBVy3q6GAQgnR0lRhi2YXZ57DN4rI6dODR0q35v
         A/r6P2bCME56UO20Lybdc4CSLUuaQau1dWXP1+D043L6cDokFInE9yqi/lHMp+Ecdl8f
         n/g8LYMkNdCZaIiQ9bwfcuHcyUP66XdCWQAg005JYrHXPU2QR2FBQIh3uyfg4OAV+I5Z
         eit0fmrPA7Sukt2UonJXv/nYD1onf/SOb3YobSm9BiDqP64JGlPfcDzPJtIKXtcnjWig
         8qOKgxAnHs6lzHc03gmRWemSBw13vlqLGefgX40HpFIgszNVijek5okVDclXVU9aOgzM
         Ooig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777470753; x=1778075553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xppRCqAQC4xKx5jzTnW41eBchdpaLIr292ff3JfaZWA=;
        b=PXeJcLrMh6RJ2LzKiDrMfYSZbXtVL+R/Ype0/OwFHzQHxlHVLQrSbPV5gF01FI3BmR
         /USbxZm/SERjOKTDmSQoa2lUdwfaRED2H0CuCgSuK190dlRwmkRs9hSXusEjqZtN96fO
         bGL4NPa8MOMCOkI/8Ja9pKebrasL/Kg8NB3DL/bm1NfSrkguL/cJT7wTq+qR2t2cT+vI
         /XPsie7baX59daKJq5yFWICQ7CrBhtIqgLEBFVp/rFbF3DyV5qei9TinZ9yC0r2khmXf
         pTTdAt4ZSG0rjUObBQGuttXdvz4ptfPi4pEvoNcAZaLGXZfE1GFq3Qdr6eXXjT7cgRSy
         zS8g==
X-Forwarded-Encrypted: i=1; AFNElJ/VS/BLxI3ScsutP3I30j0aZZq5U43lkVo0JRYWvzmUK0p6ll4qpI7MITXrCLbxkGoihVj3ILg9XA==@kvack.org
X-Gm-Message-State: AOJu0Yz+OYr6iNK85vXZtJaa/g7f1aAaHNFyIIB5P1zS3QgnVxjIycpA
	kLiD/ANAacbYZXOE/ZddkpyZrv6P/hjzlU6wgG2PR9bLinQCPlT8PO6sRJUZc1H/lGg=
X-Gm-Gg: AeBDiev4eIoqd3HKnDvHuklvkFef2dzIbyeftg/+doRUqC1X9gtWBWEXmcTNA9Ln6BM
	u1jZdl4JKTiJ2vfIoFMgWF6ubfaDIzGgRXLOzWf3r0K70UOiMOlNxwqJSDpfl7BulBuSHjZiO1b
	KLMv8BfnQfcvbOtYSXBdBNmkrTZq7krl05lFhL0tvl0//NzL51bkFiEZwsQwEgnSu+kdK5pafbZ
	rBAh5Tw8ulxyd4xlm7ovUfd+JO0Y23vTzDZrKGJangWFLSEaNx1YYMaGhm052PhXhTI2QUq4dFa
	3F9eUg0yTIki1eY3AAgv1+4VYUIu4zf54XGVLHNetQr7m5FI638Us5SJ0MTK3DTA7QnhSVSgmxG
	RZzd1AGlvAQzrwyf71ZdF6nCBXmG2REUHf6yQLH5zWimV7jpFr5kD/wj6RNlUA9QywaYXPOD9DP
	E9NMkXbc+CSP9OLW+SwPdJlaj++iRkQg==
X-Received: by 2002:a05:6000:2582:b0:43d:6787:9933 with SMTP id ffacd0b85a97d-4478e9931cbmr7296792f8f.13.1777470752934;
        Wed, 29 Apr 2026 06:52:32 -0700 (PDT)
Received: from localhost ([217.138.75.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b7217afesm5980210f8f.23.2026.04.29.06.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 06:52:32 -0700 (PDT)
Date: Wed, 29 Apr 2026 09:52:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	david.hildenbrand@arm.com
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Message-ID: <20260429135228.GA1987@cmpxchg.org>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <20260429103326.GA1743@cmpxchg.org>
 <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
 <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C39E040006
X-Rspam-User: 
X-Stat-Signature: 4oxdfny93pzx6r9xq5ewk9so1mg448hx
X-HE-Tag: 1777470754-670078
X-HE-Meta: U2FsdGVkX18Y8AXZrSnxhN3gMIzKS6UVHxktV4FI8RXh6Ys7CJ3YCy2F2Lm4ViJi+1Z6j85Gr3FcTF3DFZ5qK3zmj9vDC9DICgKEENk4+LT6h7j20qZ7LNZideoBIyVr48hRWWfqjnfnRekB6bnUuXMbbRd8LJ0F45S8aG0teTosLxnz/YQX3yZKJ+5pJHjJhJWFV5/y8yiFDLIfSSYFx3RQo/jzGlX/XCKRLgn35NylfvHnOy4jeg0O+DyqCiBp+aJxe4ruKMMR8sXFg3XduQB+y4bNIoRSBNnnYQ/mghYrW3FFOahC9MWgZbIDblgPNmDmN0WXyHb2jbfBV89HcMFCrlBwV5/Ea7BLqPTLYIwtq9aw23jRpijxl/V2q1bsQ4CdwBN284hXMiOVf4CBQ604px1zztt0oRDv0qWjZFTnDy4Yx71KTmpykqbwRk4Kvdwek6e4w21ijjH5sClOT60+4AS8KJOYTrlZTllEGN2OMMd5lHy9pGdEBBNKb4nIK7C8SJ5W4MNtTQ4tMuU5tDGAsd8LJqRg2kXgoG0rzG4Bny8RJCF9HSrD1amiRvfeDzoQYTc7DRnhetE7oHOTV+gerXasvFSwtjJxJmAI4vJZ2gmO7muRdLfTK9bnD7G9qWSj9SzfQAp1ltzEAeijHn+J1Z6nxl/pnr1QyHNF0mCKK+luJsbFamJKYPlIWmfKC9vb7NISmIpzRpbE0EXRcESPR/8e0brQtpEPkTZueb74IsqdVppTutVb6tFBbbQ3ZjYvzZvl1PW0aucHwFWnb1i0lRozCBmbDridcNOUE/tZ5NU72wIRshzhVfhZiMPfwT8k1+mDoQkBM9OuawcwwoM2rjixDaaNNTlXV2q0HYL/L4PRE/Ls+xWULa+hRHGZdMPCaVfo1kRxi2hHeAC5XMqgEpevoiextHlamrdNlgGRZPuJwMQ/BYQauHlBS0eUZmV2bDRFWSGlE2fCRw6
 zpLwZZvi
 ht1d1yn5QbhAniP8pYdrFS/ApXq9z99dFGnjhxbsABxqFlQIbZ68cubKbXhflzMaIRvq/5GP96diqfFU4/YiGaePenkl1afC2hV4V9qBcCWiIzM2Sigwj5edWSYEG0s4L5In1rnz2rcT+Z49aXyyOFVr5r1ln6Lki375GUSmD1duFjxek2wqUOps0ek8kEL73ZJW8cPzri1kGCHeuM2I2yo/AGWjezJuk/5KjQGU3chlTk/+3eac5v9qjmNiww80Ztz2lwzleX41DJ9bqmEZokglqzNBQaHo2wr7+e+gnn7BbHKN0vDxBSkzV8K4JTrMXkGRm/3ezOviC4/CmnrY1FLMl1x/sRh94B4SDI4cz4EsXvNyaMSeqK6urzChAKYelP59bZjh35eNHzs7xotlW1wTGVtpbWP7HcZveUuh6eWbhKXpwuQDM7bqzW1FOe9rTQ4frZjqv/otGrElrupejMjA8IElnauYkro7gMLPw6sHt/SJM86EIlGUJXh8b6Ke6ndzL3rpILXYDsznWL7oK7BNWGlass2d4EtvpUWHpNZbsNZFejoxStt6M4Uk3epx1VpifGpuWz7GDBGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 01:31:10PM +0100, Ryan Roberts wrote:
> On 29/04/2026 13:04, Andrew Morton wrote:
> > On Wed, 29 Apr 2026 06:33:26 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> >> On Wed, Apr 01, 2026 at 11:16:18AM +0100, Muhammad Usama Anjum wrote:
> >>> Hi All,
> >>>
> >>> A recent change to vmalloc caused some performance benchmark regressions (see
> >>> [1]). I'm attempting to fix that (and at the same time significantly improve
> >>> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
> >>
> >> I think we should revert the original patch.
> >>
> >> The premise is that we can save some allocator calls by requesting
> >> higher orders and splitting them up into singles. This is a frivolous
> >> and short-sighted use of a very coveted and expensive resource.
> 
> I'm not sure it's that simple. First off, vmalloc has preferred to allocate high
> order pages for quite a while, it's just that the patch you're referring to
> makes it try even harder. So reverting the patch doesn't completely revert the
> behaviour, it just reduces it.
> 
> Performance benefits because those high order pages are mapped appropriately in
> the page table - i.e. 1G PUD, 2M PMD, (or 64K CONTPTE on arm64). So it's not
> solely about the number of cycles spent in the allocator; the HW is used more
> efficiently. vmalloc only splits to order-0 for the benefit of the caller,
> because there are some places that assume they can access each returned struct page.

Sure, TLB benefits can offset the cost.

PTE mapped higher orders on systems without contpte (still many) are the problem.

> And all the order-0 pages of the original high order page are freed at the same
> time, so it's not like we are destroying the contiguous resource; it remains
> intact for the next user (well, ignoring that some will be freed to the pcpu
> list - this series solves that wrinkle). I've heard it argued that this approach
> is actually _better_ for conserving contiguous blocks because it's keeping the
> lifetime of all the constituent pages bound together and reducing fragmentation.

You're still consuming contiguity and increasing competition over
it. That needs to pay off in a closed system, not just in one small
part of it.

I'm a bit skeptical of that beneficial effect. Sure, if there aren't
any small fragments and most everybody is doing larger allocations,
then yes, this could make sense. Although in that case, even calling
the buddy allocator repeatedly from vmalloc would give you physically
adjacent pages due to the way splitting works (although I'm not sure
right now if you'd get the right exact PFN order for contpte).

But as long as there is a mix of allocation sizes with mixed
lifetimes, consuming contiguity that you don't need has a high cost
over vacuuming up holes and fragments. Because now you're competing
with somebody who has no choice but to *painstakingly move live pages
around to coalesce the holes*.

That's the whole reason for the __rmqueue_smallest()-first policy in
the page allocator. It's fine for somebody to challenge this. But it
feels pretty strange to make a unilateral decision in vmalloc that
works around and inverts established allocator policy, with very
little data to boot.

> I've never seen any data though...

Yes. Considering the possible externalities of this patch, IMO we
should have much more data on big picture behavior, under varying
pressure situations and workloads etc.

The reason for my email was that we see this hurting in experiments
with new code. The vmalloc higher-orders cause a sharp increase in
compaction activity, subsequent lock contention in zsmalloc migration
callbacks etc. I wasn't just making this up.

