Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C4ECAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 00:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE2B8E0002; Tue, 16 Sep 2025 20:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D59B8E0001; Tue, 16 Sep 2025 20:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAAA8E0002; Tue, 16 Sep 2025 20:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 394E18E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:51:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF0A485BB7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:51:11 +0000 (UTC)
X-FDA: 83896913142.25.A4E0CB4
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id A526840005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:51:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ub44tfdh;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758070270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ix1AngQu9wwr1vHWjycL6FVEsvwg0DoG70fN3uSSsFM=;
	b=52JztWaZLA3fMBlbfUUXbCH3u0JAArtNPPuonBsiFp5aFn6k0kFm+lQZ4ILIMMRVRWvHvK
	nIo43iLffP7idWsrLyUWoV8QbEWn1VqJNmJBi0nbpyAgl+jJVuwD0w7yWzwfRJdsse1hLw
	doj8G+2q7GjoQ80+9KsBa9ykgpSOBCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758070270; a=rsa-sha256;
	cv=none;
	b=qHN/YxfNMxyHdtozNRe+dWcioBaBNPJ6Or83Q8xwMmvcdt+WHd/2lls9XQo9kCYWZWOi5P
	bTz47sI8XfDHejAtxxymKkiEMUBmXoKAEqaZ3uvArpCPE2PY1A1gtc1sc17dahCDMHIonI
	d5xFG6IG8n/TTjtMiMsc0dt1jv7nApE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ub44tfdh;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758070264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ix1AngQu9wwr1vHWjycL6FVEsvwg0DoG70fN3uSSsFM=;
	b=Ub44tfdhevd3WK2x+9vt8V4EzO2QrcDIolJ6Z+ed7sNktk32kP0Vc3BKJCJGSb4doSMY79
	5LMuLyNRneCDUwVIX/3QtKsuUZQfagEzWuTXGbQOXo+Wj/4H0g9bdG7NeF5yaYIRa3ujm2
	4SKJg6Gmo+CU4+HMQChS2dgTLDbr3g8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Frank van der Linden <fvdl@google.com>
Cc: akpm@linux-foundation.org,  muchun.song@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  hannes@cmpxchg.org,  david@redhat.com
Subject: Re: [RFC PATCH 00/12] CMA balancing
In-Reply-To: <20250915195153.462039-1-fvdl@google.com> (Frank van der Linden's
	message of "Mon, 15 Sep 2025 19:51:41 +0000")
References: <20250915195153.462039-1-fvdl@google.com>
Date: Wed, 17 Sep 2025 00:50:20 +0000
Message-ID: <7ia4ecs59a2b.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: upd3wxzkktprxzk4xhri3pdidms63jci
X-Rspam-User: 
X-Rspamd-Queue-Id: A526840005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758070269-419201
X-HE-Meta: U2FsdGVkX18YfMlzDeFZB2U2jvI+F3TOTUfo2Fc0Z4mla9C7xNpOSnaDmw64e9mr2KnS3NzNijdbss6Er1auZXls8FrkzSOngFv0LMkJ2P+M2GcN0xDjUW22TnB+TKmBfynHZLfEsG1a2ep/Ix4NOFsly0pMbojTvpX//6gLf4nQ4hd/WVwgDwIDRP9DtbOYua0f0CbEsNIUFi5MushNvWvcrS2RuCV8IUw89KkuvNgUvv0pg6zLYCscK+4PkNmAv0GltY207uSEv6etTIjbbyn9ArRU6QahT52xVYzFwXMa5+Qtm7Vdt537clPVNYyxv1+CAWmdn4hLoj2ew4v5pEpU7TlrQuJSSjtC3fSiQzD1cD42tNwZbbbyzVccAp8Mk5InCbrRDjl6cGRRhFczxNccak1IdgABvk+p82DjNdTuzEdav4TnzyYVnCrkf0RwSX2gGSHvoBvmvViklc6hetna/ZrGbzSJFeUIc7uShhAXkg5D9NtIkbldbO01BK6GrmKYQV+s4S3tFnsiFr4BlbRJbkC1B2IP29q0lm+IyR/UqrAdPHBzonNnx93T3fXm8feKvNtY5TBKo7vcfBH3Dq21rpp5XxwDCrHoWonJYq40+AtuRFRu8pjuznKmxtnDrs3XaxU+DYVK+XjHQvXW1dJJMJqEUv09b3UJ6MTWU8bUECCp73LF7DfbbeHxhz/yiw9ukbWwBZQ6s+HPRyGHwYbg/U2zSGVIrfMIgtBHNxNY6n3hZw7g+gMIw+kN1GlqCmL9j2FZC/8MniuTk5+6J3JD+mqWfuW0qyoupdKeSAo9wqV8GuOyh0wFRO4eN8t7BHe063FmBnjjopobKJUkLs+Ooe6roFIQ0kg19uZqtDLccXssmRN/gJiBUgAFGXnxz3rr5Sp2ijGu+RNlC/eic/iIirVLsBL7EfsMGYrQK0rCRbXXDW7MEx20FHTeOqRI/PewyxY0N+cSjVobCv5
 zC7sujAY
 wixHI8pxq6cFyrSx9uDfHbHqTojTfwdvxw5q7oohln/fcfTHg5PXMutUVYN0dGpUitFMdtuQnD5At8OsNo06xmt2SyiPOd8/H4loHQoTXspHI4WI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Frank van der Linden <fvdl@google.com> writes:

> This is an RFC on a solution to the long standing problem of OOMs
> occuring when the kernel runs out of space for unmovable allocations
> in the face of large amounts of CMA.
>
> Introduction
> ============
>
> When there is a large amount of CMA (e.g. with hugetlb_cma), it is
> possible for the kernel to run out of space to get unmovable
> allocations from. This is because it cannot use the CMA area.
> If the issue is just that there is a large CMA area, and that
> there isn't enough space left, that can be considered a
> misconfigured system. However, there is a scenario in which
> things could have been dealt with better: if the non-CMA area
> also has movable allocations in it, and there are CMA pageblocks
> still available.
>
> The current mitigation for this issue is to start using CMA
> pageblocks for movable allocations first if the amount of
> free CMA pageblocks is more than 50% of the total amount
> of free memory in a zone. But that may not always work out,
> e.g. the system could easily run in to a scenario where
> long-lasting movable allocations are made first, which do
> not go to CMA before the 50% mark is reached. When the
> non-CMA area fills up, these will get in the way of the
> kernel's unmovable allocations, and OOMs might occur.
>
> Even always directing movable allocations to CMA first does
> not completely fix the issue. Take a scenario where there
> is a large amount of CMA through hugetlb_cma. All of that
> CMA has been taken up by 1G hugetlb pages. So, movable allocations
> end up in the non-CMA area. Now, the number of hugetlb 
> pages in the pool is lowered, so some CMA becomes available.
> At the same time, increased system activity leads to more unmovable
> allocations. Since the movable allocations are still in the non-CMA
> area, these kernel allocations might still fail.
>
>
> Additionally, CMA areas are allocated at the bottom of the zone.
> There has been some discussion on this in the past. Originally,
> doing allocations from CMA was deemed something that was best
> avoided. The arguments were twofold:
>
> 1) cma_alloc needs to be quick and should not have to migrate a
>    lot of pages.
> 2) migration might fail, so the fewer pages it has to migrate
>    the better
>
> These arguments are why CMA is avoided (until the 50% limit is hit),
> and why CMA areas are allocated at the bottom of a zone. But
> compaction migrates memory from the bottom to the top of a zone.
> That means that compaction will actually end up migrating movable
> allocations out of CMA and in to non-CMA, making the issue of
> OOMing for unmovable allocations worse.
>
> Solution: CMA balancing
> =======================
>
> First, this patch set makes the 50% threshold configurable, which
> is useful in any case. vm.cma_first_limit is the percentage of
> free CMA, as part of the total amount of free memory in a zone,
> above which CMA will be used first for movable allocations. 0 
> is always, 100 is never.
>
> Then, it creates an interface that allows for moving movable
> allocations from non-CMA to CMA. CMA areas opt in to taking part
> in this through a flag. Also, if the flag is set for a CMA area,
> it is allocated at the top of a zone instead of the bottom.

Hm, what if we can teach the compaction code to start off the
beginning of the zone or end of cma zone(s) depending on the
current balance?

The problem with placing the cma area at the end is that it might
significantly decrease the success rate of cma allocations
when it's racing with the background compaction, which is hard
to control. At least it was clearly so in my measurements several
years ago.


> Lastly, the hugetlb_cma code was modified to try to migrate
> movable allocations from non-CMA to CMA when a hugetlb CMA
> page is freed. Only hugetlb CMA areas opt in to CMA balancing,
> behavior for all other CMA areas is unchanged.
>
> Discussion
> ==========
>
> This approach works when tested with a hugetlb_cma setup
> where a large number of 1G pages is active, but the number
> is sometimes reduced in exchange for larger non-hugetlb
> overhead.
>
> Arguments against this approach:
>
> * It's kind of heavy-handed. Since there is no easy way to
>   track the amount of movable allocations residing in non-CMA
>   pageblocks, it will likely end up scanning too much memory,
>   as it only knows the upper bound.
> * It should be more integrated with watermark handling in the
>   allocation slow path. Again, this would likely require 
>   tracking the number of movable allocations in non-CMA
>   pageblocks.

I think the problem is very real and the proposed approach looks
reasonable. But I also agree that it's heavy-handed. Doesn't feel
like "the final" solution :)

I wonder if we can track the amount of free space outside of cma
and move pages out on reaching a certain low threshold?
And it can in theory be the part of the generic kswapd/reclaim code.

