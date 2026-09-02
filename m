Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBFDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737596B00B6; Wed,  2 Sep 2026 12:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8876B00B7; Wed,  2 Sep 2026 12:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562226B00B8; Wed,  2 Sep 2026 12:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA656B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:04:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6583D1C1876
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:04:26 +0000 (UTC)
X-FDA: 85169294532.16.793E71A
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D209C0012
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:04:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=scMXcpQr;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788365064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kM7a9Frsz1Licu3YxNXOsYKy3EYmOA2MOCGRwOnd8M=;
	b=x4nRwaA015PFfSp39DyDn2mnPm9eYHJzxaNlUJIaBhFGegHjE4CoNMhh57pkkSV8OlMo6u
	FfhBGVYWiiz/KE3TqtQrrIDRqwhwaImaxkbxBMaKIYuc/RSU9PSdorp/N+Licp07Ctex5E
	O9sVUGVekYgRuDPc+yn0bsfacOsMJqY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788365064;
	b=mvqFUKK6fzk7o7y9RGJKXecQB31DLR0X85TS56lGIhKnNjm/0QHmvXYivZLmEnH5tZBjMn
	w20lHwmdjBTwZ+jta15DnXUXZQqbQF112wvxvVz5sVKdEPqHcpTpCU93RKJecNvZEAcB+F
	gcN3hqU3LuPeHtaVQOeyDnUc9oGsUiA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=scMXcpQr;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-86162c086f8so328207b3.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 09:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788365063; x=1788969863; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9kM7a9Frsz1Licu3YxNXOsYKy3EYmOA2MOCGRwOnd8M=;
        b=scMXcpQrw9w0BK3MA+Pj0/P7vKXz2NfIARNdzUXybp/PtZBnybP6YWDigtY16EVGI1
         LvryogekcHMIsEdZXjJtalEY2H9AE0y+nC5w2N/r1RS432LiY9Szc4Wkwnluy9gH96I+
         RmfiEX1hQviTTPlTSuXif0yxWzguKGLvzY8VzLpi3D4JD4gegaSTFnU3YQ80l9PZlJqX
         1uj208ogKIBnvXJOxcQsqNmKOWHVj+gnpPoZkRpP0mD0rKyMjbBz9P/1n8tZZjxDa4Y9
         jyobQDATbe+oBOkYNz/HfTYEfZEze+d9tZHnamiDTWEzZlMpYT3MXyIAWrwQsx6ypGbw
         aJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788365063; x=1788969863;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9kM7a9Frsz1Licu3YxNXOsYKy3EYmOA2MOCGRwOnd8M=;
        b=S6M7W5eoaIvMa/dhMZEdISITVgzzbwZtGvS6QPegCS24qd4rC8rPrZfohbx5sIbq40
         gbs1pyRNwpi7ydskFP9mZB5Zt1Ze7b1KkwDz0K+0oiVsbA4OOGCryi2yTGAve7qyI3PV
         /M9SyRugRMjPAz2RFZEcoAFMYP3bSn7jCOe9+mwdbbuDiSGmFQOJTalDBjRczRZWWc4/
         aZ/F8Ybfgo3ELRaCulVphtjoTQeRD53N49m01ikq2gNqjjJ5g+FpfUwvpE+ZEDLav1VV
         B+9YYNIOMK8AZNIJVaHTgP4gx5Pbd3lX3h0GIMyzgdC1s48l/ihJxBOLUGAtwc9QZhO7
         Udwg==
X-Forwarded-Encrypted: i=1; AKwUvBwGIgZy+XCkxo9QX82tINYhqU18CAiQ4r6gsxwdPrRK460LuMWLTClplS3qbJiqi2UisMeTx8Plgg==@kvack.org
X-Gm-Message-State: AFuF++nHGycTaif9vphCtgvqhk4xtel6+MAfYD7cPvU99qwnMdvJWnZK
	v+zHKgPFTpEVuIoK/lejls/ymoX0eF8pU56v48ZN3MM8cM+EYKYN8Fw1EReZTZO/G2I=
X-Gm-Gg: AYBFou01lDqxrMA9Z4WAnX5ewJPdxd9tvUMkE8CIGz5ciNBe93GmlUZRFRbp1QqPC8T
	QBTgoe/Q8Stjvr69FpNPdQ68nioTNxRxyLsLAbWLS9yibU7O05QF84RqJ0AIeJBm3TnvIy9Uk9Q
	q0r7ZtknhUoe+Q4el98GfqYeqMAH6sFFHgF+5RWoIr+oIfSFylUnZZOlaUlrqyGb2Jr9SDslvSJ
	P7H0alxJcQ1NO4XdDQ+73f8w74s3mDUAcyLEFh0RNAWeg5jfD0p92ayzh0+2Fhpi8YLt391Nq6v
	c4seQjiVQJpFbDoQkssLHyN6ORn+/CVpZLf1SDzkt0OtBZL2iHVLa3QalKkSbPYWKlU5W3pp7qG
	MyHgQsXnj/gvJjgZee9EWS9K4VrsKy9UXNaMkiJaeEphxnQgd6qe8wxzGD0yAOBhEMQESMgEMa8
	RalROAIUUAVzys1qECfwAAPZ/fvRlAm4dlZKCjHnF8eMnH4/uct3W9DIyyZxNH
X-Received: by 2002:a05:690c:e684:20b0:85d:29e3:8c51 with SMTP id 00721157ae682-86e6d793d19mr1029097b3.7.1788365062874;
        Wed, 02 Sep 2026 09:04:22 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c10c9463dsm21195937b3.5.2026.09.02.09.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 09:04:21 -0700 (PDT)
Date: Wed, 2 Sep 2026 12:04:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260902160417.GN3004@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
 <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D209C0012
X-Stat-Signature: ejyysamg5xa31hwmepz9g3orofutkixu
X-HE-Tag: 1788365064-458329
X-HE-Meta: U2FsdGVkX1//mryxp4N1RFpKMhNfCOGY8PtVmgQS2coq0P8LGZqScMvhkE9zpU93NqN4dIAGq80Djin2O14R/WI/JBy6ofDR4qtqLXkdr2ZQgLJEgBOFKFewQDW7M4wnqrx85UHTEy/vRZP4THkXTNS2UCXwEooWa0X6Z8kjrzJ2BK0PiuSCsYtK4xuYd6zpxci/N0tHKncbwIzWlRhK5IfX4paAjntLN8Uw8obnzjUPTVDk+HeR2fEf8yahSXHZQ26dceHtylVLu070RW+rHzR/yXslPn+k41SVkuCSbEIlo2fCKuR/heJFQGQn4F4X8xOfwm8nwkGQ38NPxI+nRpTuCxNCKp/B9SyjAZB1k6kfJM36KT/gp1dMTgBAnA0svBNw17v9A/J2RzMAycF+UeWjgomcLLjy20Oz+v4AOvVnCUf+xo9wIm4JQM7RjREwpZThNXm1KY8yFLaPVcw7Yk0OcC6GcN2o2Gp6iLyqOGpmjqBtlKNAWxUO5LPLBZ/TU/homjy8ZFtbK4ezhtKsTdrrd1VRwhPs3IxCdlGag5uAD3CsMNGUXL7e/fo1Ozesv1qK4iwLCvAB/lG1eb0kc4xgarrdNTKwGmUeySxA7PgOwiM7C9KOm80QbsRCN4cJcVi/5PdeulFVXcia7n9lo4uUUkcO+oIWWA+JMQCFcbMRehqfB09A3GbVJ0HX79Bwusb57lPvm8yPiBN1vGsdJTMtBKpjr0Fm1vupe9kY/Ts6sNkduJLIiAL0O3/c6UQokqZLRw8yoSnIArvF19W6G+hwSSJEAMHWxoz6QkzwNh6guJbq8dZ3GDpyu5EKRy61ieCpmXtlqSFswPmSi8sj9KIwvrYoiAEh6KL01O5krcash8KF2Gs1u9Jah8mgl3yBDvorWp+1fREzUdKE/0C9LRsFKB5QwdpXTTHqY6iuB/2XfpGX+pPnsJZEBseWLCQqcJG66kOEFFw2b2d02dq
 ZnHmdCG0
 WJAk6ydDW+E93hadtgcECG/jQ84JAOSoVKVTIDbhavi3pMU35rEgE3fao7NmkwT9B+bsA1oGsP5bL5H7Z15Y8KIjMTe8d+QKH4dqUeTkaw9H0dqNlIQ1+NeFDk47D9Le9KYVgy84/KLZAXTRfpnHuAzjSnQi+Q8+oIRj+4wnjJ++BbP94ZB3PKhVfw+3UPOb73bhyos/WIzWnaQ6q809AML+yr+qgHLznJJkqRJPzHvoLddW7nPm9Xq6+W0IjRde5x+OLcMn2MC0xA9HoDl+w+e5wcbj2DnMJA66adm0oQ3jzOMztU/KOnYH4OB5rdt86pKW5TvXFMO9iXUnUs3ZOjrgC1dyvQ6leBtgNfpMJcEYRCuzjc7iaO2KZEYzVOM8Rc9v/7N3NPo+JPFgRNemgI8iQKHb/wBtI/KZP0SyyBdTz6x4SfV2hD2gUciapGYAH1FgVSU0c5/Pwo9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 09:49:58PM -0400, Zi Yan wrote:
> On 1 Sep 2026, at 18:09, Johannes Weiner wrote:
> 
> > On Tue, Sep 01, 2026 at 05:09:52PM -0400, Zi Yan wrote:
> >> On 1 Sep 2026, at 16:44, Johannes Weiner wrote:
> >>
> >>> On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
> >>>> When THP is enabled, set_recommended_min_free_kbytes() may raise
> >>>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> >>>> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> >>>> heuristic to help keep pageblocks free and reduce fragmentation for THP
> >>>> allocations.
> >>>
> >>> We've had problems with compaction before when min_free_kbytes was too
> >>> small on large machines. Competing free space scanners do a lot of
> >>> work only to fight over a very small set of possible target pages.
> >>>
> >>> So I'm a bit uneasy that you didn't include any benchmark numbers with
> >>> this that prove basic functionality on larger hosts isn't regressed.
> >>>
> >>>> The recommendation scales poorly with larger base page sizes. With the
> >>>> default arm64 pageblock sizes, the contribution per eligible zone
> >>>> before applying the existing cap of 5% of low memory is:
> >>>>
> >>>>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
> >>>>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
> >>>>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> >>>
> >>> I question whether pageblocks need to be 512M on those machines to
> >>> begin with. After this patch, you're still asking the page allocator
> >>> to optimize grouping such that 512M pages can be allocated at
> >>> runtime. Only now you took away part of the mechanism to do so.
> >>>
> >>> If you're using 512M THPs, I would kind of assume it's on machines
> >>> with a memory size where 5.5G for defrag purposes isn't devastating.
> >>>
> >>> And if you're not, it would make more sense to lower the pageblock
> >>> size to the mTHP size you're actually using. And that would fix the
> >>> "excessive" min_free_kbytes issue as well.
> >>
> >> But lowering pageblock size requires a kernel compilation. That means
> >> maintaining two sets of kernels for different needs.
> >
> > That depends on whether anyone actually wants 512M pageblocks...
> >
> >> The ultimate solution is to enable better compaction to generate
> >> THPs bigger than a pageblock size, like Rik's super-pageblock
> >> proposal.
> >
> > ...or whether we can say, at that point, use gigablocks/cma+hugetlb.
> >
> > And then the static pageblock size for the fallback logic etc. can be
> > a smaller, saner default for everybody.
> >
> > Because the point you didn't address: it doesn't make really sense to
> > have 512M pageblocks on smaller machines, beyond the min_free_kbytes
> > issue: Fragmentation events will poison half a gig at once,
> > should_try_claim_block() becomes harder which results in less
> > conversions and more allocations falling through to stealing, page
> > isolation is more likely to fail, compaction locks and operates on
> > oversized chunks which is bad for latency and concurrency...
> 
> I actually wonder why such a big pageblock would still result in a lot
> of fallbacks.

If you look at try_to_claim_block(), you need half of a block to be
free or compatible with the requested migratetype in order to convert
it. When memory is full, LRU pages are scattered all over, and
compaction is not involved (order-0), this gets more difficult the
bigger the block is. You can get into a situation where LRU reclaim
will not clear sufficient room for conversion in any given pageblock
anymore and you're stuck with the type distribution. A large share of
buddy requests then go permanently through the slower fallback path.

Usama knows more about this, but we have seen this on GB300 hosts, and
have JUST started to deploy kernels with smaller pageblocks (2M).

> Basically it indicates at some point kernel allocates a lot of
> unmovable pages that use many 512MB pageblocks and the life time of
> these unmovable pages are so diverse, leading to all these
> pageblocks remain unmovable and free pages spread across all these
> pageblocks. I thought bigger pageblocks can keep unmovable pages
> constrained within fewer pageblocks, leaving more contiguous free
> memory.

The idea is that the pageblock maintains contiguity for the largest
size you routinely expect to allocate.

The page allocator is very passive right now, and it doesn't work
super reliably. But even in the current regime, smaller blocks have a
better chance of containment.

For example, when the ever-growing page cache runs out of movable
block space, it spills into unmovable free space. When the next
unmovable request finds no space, it runs LRU reclaim - which is more
likely to free space in one of the many movable blocks. And so the
next block is poisoned. Smaller blocks have a better chance of filling
up natively, means less pressure to spill into incompatible ones.

And the higher min_free_kbytes, the more likely there are still native
options when the zones are down to the watermarks. E.g. better odds
there is still unmovable free space, you just need to reclaim some
movable/reclaimable space elsewhere to satisfy the watermarks.

I've been working on making this more robust with the huge page
allocator / defrag_mode stuff: instead of falling back and poisoning a
block, invoke reclaim/compaction to produce a neutral block that can
be converted entirely.

It's the same idea as the higher min_free_kbytes and watermark
boosting, but it is more targeted at the end result: readily available
space in compatible or convertible blocks.

But with that active regime, oversized pageblocks are even
worse. You'd pay ongoing compaction work to produce a level of
contiguity that you don't actually need.

> > Seems to me the excessive min_free_kbytes is just a symptom of a
> > deeper problem.
> 
> Yes, our anti-fragmentation mechanism does not work as we expected,
> so that we need an excessive min_free_kbytes to get khugepaged working.
> I wonder why reclaim cannot get the extra free memory instead of
> reserving it via min_free_kbytes. Maybe we need a watermark boost
> when some consecutive THP allocations are seen to achieve similar
> effect of boosting min_free_kbytes?

I'm just wondering what the easiest way forward is to fix the ARM 64k
page problem.

Yes, optimally, reclaim would work to satisfy compaction space by
itself. We've seen it fail at that before, though.

How critical set_recommended_min_free_kbytes() is today is a question
that neither of us has a clear answer to. It's from 2011 and a lot has
changed. However, knowing Andrea, I'm willing to bet he added this
based on seeing a need in testing data. And I would actually expect it
to work better now with proactive compaction, since that has a better
chance of turning low-order chunks of that volume into pageblocks that
can be converted instead of needing a poisoning steal.

It's a change of long-standing behavior for everybody. It has a
regression risk and requires careful evaluation and testing.

Meanwhile, adjusting the pageblock size on 64k page arm configs has a
much smaller blast radius, appears to be the right move ANYWAY given
what pageblocks are for, and makes the min_free_kbytes a non-issue.

