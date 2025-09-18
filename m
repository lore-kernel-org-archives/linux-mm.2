Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1C4CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0DB8E012D; Thu, 18 Sep 2025 18:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998708E0068; Thu, 18 Sep 2025 18:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AEB28E012D; Thu, 18 Sep 2025 18:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7620D8E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:13:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E147119F1B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:13:11 +0000 (UTC)
X-FDA: 83903772582.16.21981DC
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D8C320009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:13:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l4lyEqMa;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758233589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lo8pzMCC9mbCED52NwkyFdYylycaU5rZrxRgzH0GnhI=;
	b=2UL++2Ug4sBsemcYI7a1PSld1aT8QybEwnvFGgUwWNGqGooDd2OV0pvH8AupMTgeXParPA
	6VCVZM6n5wj4quvKed0hBQa2WkEmm6dc8H+PMrig3VnNoPxVDA0XDmpbj4ocUuLvImv9Db
	uumzVv50PEMELnGc2FDws6mvPqX421U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758233589; a=rsa-sha256;
	cv=none;
	b=kjOUDKnkvc8wbXgjRClWHD3J1xc51s/83nZvOj8UAbylMkY5lh6OezOMcj7Z3e6bHRCL9v
	HI6Sx0786EEAo+HRdyaFsbwRZw61pnT1apMnzszVbTtDZIMLfX9CaWKXIVyHuQJ1muosG+
	FDg6OSa0jEYYhkSPyF5kNmxVUdov2eY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l4lyEqMa;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758233583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lo8pzMCC9mbCED52NwkyFdYylycaU5rZrxRgzH0GnhI=;
	b=l4lyEqMa99j1WPDgD2pxL0xZO6+pvCtZ0B4/46l3Xz7B5YUvF8OQA7jfjKMp0eAjTvSDWK
	gEBeBUYuLZFs8D6JvPRmuKDcvNs7JYun5oU2S4O1+TdN+JUEqQjhJGHf/b1kTXaU7XyY31
	peV+oVyT02ipeiVhAcOJnI6ez0TVr7c=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Frank van der Linden <fvdl@google.com>
Cc: akpm@linux-foundation.org,  muchun.song@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  hannes@cmpxchg.org,  david@redhat.com
Subject: Re: [RFC PATCH 00/12] CMA balancing
In-Reply-To: <CAPTztWYp2yPsdvFfMm6bVB-juwHM11zKAEty9q+J8gy5d-8=KQ@mail.gmail.com>
	(Frank van der Linden's message of "Wed, 17 Sep 2025 15:04:30 -0700")
References: <20250915195153.462039-1-fvdl@google.com>
	<7ia4ecs59a2b.fsf@castle.c.googlers.com>
	<CAPTztWYp2yPsdvFfMm6bVB-juwHM11zKAEty9q+J8gy5d-8=KQ@mail.gmail.com>
Date: Thu, 18 Sep 2025 22:12:54 +0000
Message-ID: <7ia4qzw3z9y1.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D8C320009
X-Stat-Signature: jmtx7n8x5pw8oau4wkgh3jz1xfxh87pz
X-Rspam-User: 
X-HE-Tag: 1758233586-319166
X-HE-Meta: U2FsdGVkX1/rDxnAvtUtpdf00fQe6NGEeIlpluN0cYYqGEGU4nS3qxLkDfm27fRr2iC/DWZIlsM1cjclygWbt/tZirJ2DTAn2dtoDWhJUdsSrd+n6weE9vhJxdiArZ1SqQyzi77g2Q1Izc6fImZp6rM2e+6OVvT1aGEFqyd87rpz2uRB8ZbeXXqd/hym7/F+Y3GhwlTWEFRp7Nn9aUqCgFjy5mn22ySdculzPN8+uS1ARqNZp7hV9pPPzZFBeDXYrGMbX9DKMwRzfCgwQrCfs+1CBr2V6UuaRQmyAZnFCz8HS8o1lVepj7SFkptfY6F0IOczz1J0J2os80l8uTjaIuGMmWwkeb/W1uyLeUybp4X68O9vQqafInTe7ghQCQUBN+/O/8Lx9EBP2LnPgT3Qr4zlVTqGRgzu7uemIaQW/TQIRx47PP3XVtD4eMqCOwMGmMlx9SD7pv2DxRfQgUDaz8PqCmOZUSaprZnjIohpxq0NnyWebWDpyghxl5344Fzv2JiLBKreY4Eas2P4vwEcSiSbX/Zv17kQDmSHkVYEQQsHJmWjkm3ky5GFSImDrI2XdZ/Sn0zNMqo7YuKy/PAHju4T8uZabqPOuz3pGdiYAwJFq/aftQVNSPNUZOC0Su3R+K3LaHo+/TXLWXrQhLVXkPKXe33mmp/Yk2/NvMNfCtU9CWWmCkW/Pi5dll5394YJzwF4Pe6hLo8ykfS7s3e/Q/MDVZpmdbiKGY5dXaAs3fHqarpA4QTP8PPIPHzjuaNY0+GyTryEC/8/mELMYvw4WMJ76s672wkgLKF0ukyb1Nj3U0H0OLJDuF/DeIAEWTAflRYKJSL3SRd/DkUIYZGy4S0OqDmXCjHx0TtVkvGe/wVoHQlZKcC/Rk/7IF8aibWSOFXq8uVG4byGZSPrCZIWmi2ooQokLW66pxQLAKCV5EjW+syQ/DgUTaRRTJev29UP0PBC40vzTNanCShOHr5
 2G+APv/k
 muIvT+OQaXGMqKbaceDEVKCmqubTsiSBBOdKZ1UcNYQCHo6TVio/Awm0JwReP1XnHYR2nwRM89A9dll2LKU6Y3U9gHybbVbHpio39fG6Ese3NzFhRkZ+dM+t2NWOP02wFo1/ZzoZcZNfIPnWHQjocRxF6/cQcSw5uuHSs6+HXlJpAorGriz4mFNxlzOsyQY+8nBCD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Frank van der Linden <fvdl@google.com> writes:

> On Tue, Sep 16, 2025 at 5:51=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
>>
>> Frank van der Linden <fvdl@google.com> writes:
>>
>> > This is an RFC on a solution to the long standing problem of OOMs
>> > occuring when the kernel runs out of space for unmovable allocations
>> > in the face of large amounts of CMA.
>> >
>> > Introduction
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >
>> > When there is a large amount of CMA (e.g. with hugetlb_cma), it is
>> > possible for the kernel to run out of space to get unmovable
>> > allocations from. This is because it cannot use the CMA area.
>> > If the issue is just that there is a large CMA area, and that
>> > there isn't enough space left, that can be considered a
>> > misconfigured system. However, there is a scenario in which
>> > things could have been dealt with better: if the non-CMA area
>> > also has movable allocations in it, and there are CMA pageblocks
>> > still available.
>> >
>> > The current mitigation for this issue is to start using CMA
>> > pageblocks for movable allocations first if the amount of
>> > free CMA pageblocks is more than 50% of the total amount
>> > of free memory in a zone. But that may not always work out,
>> > e.g. the system could easily run in to a scenario where
>> > long-lasting movable allocations are made first, which do
>> > not go to CMA before the 50% mark is reached. When the
>> > non-CMA area fills up, these will get in the way of the
>> > kernel's unmovable allocations, and OOMs might occur.
>> >
>> > Even always directing movable allocations to CMA first does
>> > not completely fix the issue. Take a scenario where there
>> > is a large amount of CMA through hugetlb_cma. All of that
>> > CMA has been taken up by 1G hugetlb pages. So, movable allocations
>> > end up in the non-CMA area. Now, the number of hugetlb
>> > pages in the pool is lowered, so some CMA becomes available.
>> > At the same time, increased system activity leads to more unmovable
>> > allocations. Since the movable allocations are still in the non-CMA
>> > area, these kernel allocations might still fail.
>> >
>> >
>> > Additionally, CMA areas are allocated at the bottom of the zone.
>> > There has been some discussion on this in the past. Originally,
>> > doing allocations from CMA was deemed something that was best
>> > avoided. The arguments were twofold:
>> >
>> > 1) cma_alloc needs to be quick and should not have to migrate a
>> >    lot of pages.
>> > 2) migration might fail, so the fewer pages it has to migrate
>> >    the better
>> >
>> > These arguments are why CMA is avoided (until the 50% limit is hit),
>> > and why CMA areas are allocated at the bottom of a zone. But
>> > compaction migrates memory from the bottom to the top of a zone.
>> > That means that compaction will actually end up migrating movable
>> > allocations out of CMA and in to non-CMA, making the issue of
>> > OOMing for unmovable allocations worse.
>> >
>> > Solution: CMA balancing
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >
>> > First, this patch set makes the 50% threshold configurable, which
>> > is useful in any case. vm.cma_first_limit is the percentage of
>> > free CMA, as part of the total amount of free memory in a zone,
>> > above which CMA will be used first for movable allocations. 0
>> > is always, 100 is never.
>> >
>> > Then, it creates an interface that allows for moving movable
>> > allocations from non-CMA to CMA. CMA areas opt in to taking part
>> > in this through a flag. Also, if the flag is set for a CMA area,
>> > it is allocated at the top of a zone instead of the bottom.
>>
>> Hm, what if we can teach the compaction code to start off the
>> beginning of the zone or end of cma zone(s) depending on the
>> current balance?
>>
>> The problem with placing the cma area at the end is that it might
>> significantly decrease the success rate of cma allocations
>> when it's racing with the background compaction, which is hard
>> to control. At least it was clearly so in my measurements several
>> years ago.
>
> Indeed, I saw your change that moved the CMA areas to the bottom of
> the zone for that reason. In my testing, I saw a slight uptick in
> cma_alloc failures for HugeTLB (due to migration failures), but it
> wasn't much at all. Also, our current usage scenario can deal with the
> occasional failure, so it was less of a concern. I can try to re-run
> some tests to see if I can gather some harder numbers on that - the
> problem is of course finding a test case that gives reproducible
> results.

It might heavily depend on which file system you're using.

>>
>>
>> > Lastly, the hugetlb_cma code was modified to try to migrate
>> > movable allocations from non-CMA to CMA when a hugetlb CMA
>> > page is freed. Only hugetlb CMA areas opt in to CMA balancing,
>> > behavior for all other CMA areas is unchanged.
>> >
>> > Discussion
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >
>> > This approach works when tested with a hugetlb_cma setup
>> > where a large number of 1G pages is active, but the number
>> > is sometimes reduced in exchange for larger non-hugetlb
>> > overhead.
>> >
>> > Arguments against this approach:
>> >
>> > * It's kind of heavy-handed. Since there is no easy way to
>> >   track the amount of movable allocations residing in non-CMA
>> >   pageblocks, it will likely end up scanning too much memory,
>> >   as it only knows the upper bound.
>> > * It should be more integrated with watermark handling in the
>> >   allocation slow path. Again, this would likely require
>> >   tracking the number of movable allocations in non-CMA
>> >   pageblocks.
>>
>> I think the problem is very real and the proposed approach looks
>> reasonable. But I also agree that it's heavy-handed. Doesn't feel
>> like "the final" solution :)
>>
>> I wonder if we can track the amount of free space outside of cma
>> and move pages out on reaching a certain low threshold?
>> And it can in theory be the part of the generic kswapd/reclaim code.
>
> I considered this, yes. The first problem is that there is no easy way
> to express the number that is "pages allocated with __GFP_MOVABLE in
> non-CMA pageblocks".  You can approximate pretty well by checking if
> they are on the LRU, I suppose.

Hm, but why do you need it? Even if there are movable pages outside of
cma, but there are no or little free pages, we can start (trying) moving
movable pages into cma, right?

>
> If you succeed in getting that number accurately, the next issue is
> defining the right threshold and when to apply them. E.g. at one point
> I had a change to skip CMA pageblocks for compaction if the target
> pageblock is non-CMA, and the threshold has been hit. I ended up
> dropping it, since this more special-case approach was better for our
> use case. But my idea at the time was to add it as a 3rd mechanism to
> try harder for allocations (compaction, reclaim, CMA balancing).

Agree, but I guess we can pick some magic number.

>
> It was something like:
>
> 1) Track movable allocations in non-CMA areas.
> 2) If the watermark for an unmovable allocation is below high, stop
> migrating things (through compaction) from CMA to non-CMA, and always
> start allocating from CMA first.
> 3) If the watermark is approaching low, don't try compaction if you
> know that CMA can be balanced, but do CMA balancing instead, in
> amounts that satisfy your needs
>
> One problem here is ping-ponging of memory. If you put CMA areas at
> the bottom of the zone, ompaction moves things one way, CMA balancing
> the other way.

Agree, it's a valid concern.

