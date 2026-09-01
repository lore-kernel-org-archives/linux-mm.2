Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579E3C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B896B0088; Tue,  1 Sep 2026 13:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BFE6B008A; Tue,  1 Sep 2026 13:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C3A6B008C; Tue,  1 Sep 2026 13:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF3246B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:37:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F3071A04C9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:37:20 +0000 (UTC)
X-FDA: 85165899840.23.DAFEC30
Received: from mta1.migadu.com (out-67.mta1.migadu.com [95.215.58.67])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D3ECC000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:37:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y7GCVbGI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.67 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788284238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XOYZSTmEQnVU8KlDzTJ5aH2mhlAFFry1TrLDBd8Z1Y=;
	b=MlnkPwccHyo3UUoH3zqEbOSn9WUSfyCKtwSeEc/DqaWE+6miECKHhcrxSa/O/CvEP/8STk
	wrWsP/lS5Z+BZkIBNWnd7ddxnc1FIXy9+W4DQ4/7YFqZK9Usps4SgxOyHiLSVLUzFpu3bt
	IIaI+ZS68grRIEhCw4QFcpc730WrQK4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y7GCVbGI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.67 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788284238;
	b=4wSUGnQ6dGlEISQexFb+UCTbzWKdSeYoqEryztMonXPn1TX8SW4UtedfmjI5M0kB9GDnA/
	ZmNgGPAS34FI3Beh1H5dSbI23cpCL7ey8IOfj8qcRehtIPfM7zQxYfCB1PrdNPK3ibe2Qj
	H53mPcU+0sXDZ3Pyn/eE0RSSYoyUZzM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6zo0vD0WrMxDTrLkYi5SZlZp0oHj/c0Lu7P8MC3D64I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788284236; v=1; x=1788889036;
 b=Y7GCVbGIEXLYVUd79jHtVQQqb+uBUWPuth9NYQmo6v5EAfHQ7tZSk2S6fa+0ez6f00vUj0nd
 aBFMZZR2tPO4xr3NjVhOh7PxBHZHxGuzip0tn0zpHpPGmn09eLJrd1mrL3q061ELjFruiaqFdoI
 CTFnd7yCBk67B0NrKgluxrng=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c386ce8340dde776;
	Tue, 01 Sep 2026 17:37:16 +0000
X-Mizu-Trace-ID: c386ce8340dde776
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 10:37:14 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
Message-ID: <apcJgcFLHKZfI40m@linux.dev>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
 <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
 <apZVe8UHZ1CNo4r1@linux.dev>
 <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7D6V4eTZJ1Q1Xf2J6yTCq=JjvzT-W-HHX6EnMfzm3BK1g@mail.gmail.com>
X-Stat-Signature: u91pbqocjx3y6p9qcbwxrxip5fj3a94m
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D3ECC000B
X-Rspam-User: 
X-HE-Tag: 1788284238-361117
X-HE-Meta: U2FsdGVkX1/YXaRhCKpDnFNTMDUbfhKTwmPX4UQnWuAEZAJSLkS4yGST57d73iD3jIxBE3Gasjt4mB61OOMWGL/0SBDg+wbSyUVWk3QXsamSYMJt/4TI6yLvF26ksMnybxkoQEAMaZdXQomOcnlWqf3TGoGoMl9AxyzEK1ufufiKG/B8OFdj5GHv7YQ5ZKdknjYuewIPih9nzgfXTNs6mq/hgwo2I+AiIUwGN3hDjtDL85zfbABqftvudaJZHkn+XWKFwctJnN+MdUXi9zVKMlcO0s1LNFlA+v/UBdzEthfjkNj7UxjUUawrH7IklI9hd6003mF/koBtgXJHJtgUL++vdGTZsTVE023VuLWBH3Mw6ogMNTJesr/v9WonC0HbjJKTU7AcmVeNpABSlkqrMiVYhhEvBglZ2gRGn206tg+0lli04Hrmh9Apbke0JiXIAt6Ip8MnTW0Izn1uxbY6IaOFHa52AaWEsYCvXw32XY8X3VHRngt2uFRyiilO83rfH/0lm7+cm2ziUGk+y1LtEUDO3Tgs6Piwk5vYIglf5GFMJSCbR3kBBvpOm3iHHnTE6VewDi/d18gv+VSGOZplw+uSadVs1J3xf8pwi7XVZdLbkS2zTqxqPR9O7u/3Pcsn6fZqoEmKMDt3JCsXQdU7mSROjkz5GCZdFQcDxKdU4P9p0AFSqki0BJSV/nq16Gq7rCUW9r9mif+FzvH11VD8Qx2BWdthhyoPIYhHuaXhKDwxpKgI/nQTk/60CSasH9BtwNK9sBgrTCx55CZP90z4rcB4AgUJSDWy6iZwnN17iQJCdNKnmC8gJy2okCIUi0Dj3TDnSjx58aFQAyjPvQNX4fjKoNWoIqG3cJ+i/65xIcUeGJC9QSkT1ODhLZKiQQzKcSwLkv3e1135/fly6m4nTMUqwf0m/46CPnWnWJHMuLqztiXzXd3xCaTZO+39au1dQVnohtzRtH7q1OMCqOs
 d57tSmyW
 pY0IMhQpn7ncymHkC3xG9zxsoSs85KNeOqsdJwICTi4pzzgtr7OV17wHxYXaItIXUWp3fBC5O4xcvzsRJP0kWmWepArEeE+e4ezNbpFBa+97LAKiLfc75RKt95UmD0p/56F0bFtKsH/TClDAZOIbtBq1Pg+2H52nL/CklXhyptg7R4sqFnDHLbZ2ukw1eZIkwA8FqNGGIr5URjJtDyLZI30dMBIy8xqLTDDIgKlFVILaS4yu9SNMz57gTKGtW0lzw47Lvm71OgSFBkJsZES91uD3dGWm8KY5+LtZ8NoqPTkf/ZyslsBSL6AUvjvy83wRee6mNuOCR7wFeA2wsZ4nUKuPJTeNbjlnou8DCfKWxvNMkVulN/NrCOfURAqkACmP8C6yujjcGqx8ul+P64Y8k49EdXcoI95IWMoLB+ALOiPevDY3vMrdNR1FhitkixE7JprMt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 01:20:33PM +0800, Kairui Song wrote:
> On Tue, Sep 1, 2026 at 12:38 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Aug 31, 2026 at 02:43:31AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> > > introduced a sanity check to catch memcg counter underflow, which was
> > > more of a workaround for another bug: lru_zone_size is unsigned, so
> > > underflow wraps it around and returns an enormously large number, then
> > > the memcg shrinker loops almost forever as the calculated number of
> > > folios to shrink is huge. That commit also checked if a zero value
> > > matches the empty LRU list, so we have to hold the LRU lock, and
> > > handle the positive and negative deltas separately.
> > >
> > > But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> > > for lowmem requests when memcg is enabled") already removed the LRU
> > > emptiness check, so handling the deltas separately is no longer
> > > needed. And if we just turn it into an atomic long, underflow isn't a
> > > big issue either,
> >
> > Why atomic long and not just long?
> 
> Long is fine too; I was just trying to be defensive. The original
> check was a defensive design for leaks or races, and atomic long is
> more immune to race conditions. See below for the other conditions.

Unless we really need it, let's stay with "long" for now. As you mentioned below
this is busy/hot path, no need to add overhead of atomic here.

> 
> > > So let's turn the counter into an atomic long and check at the reader
> > > side instead, which has a smaller overhead. The underflow correction
> > > is removed: a massive leak of the LRU size counter would indicate
> > > that something else has gone very wrong, and one should fix that
> > > leaking site instead. Besides, the updater-side sanity check is
> > > unlikely to catch the leaking site anyway: if a folio was removed
> > > without updating the counter while other folios remain on the LRU,
> > > the WARN only triggers much later, from a likely innocent callsite.
> >
> > Do you have any data to support your claim that updater-side sanity check is not
> > that useful? Also can you explain the motivation to move the check from the
> > update side to reader side?
> 
> I think I described that in the commit message. Commit ca707239e8a7
> introduced the original emptiness check. The goal was to fix an
> over-busy reclaim scenario: upon underflow, an unsigned long returns
> an extremely large value. The reclaimer calculates the page number to
> scan based on that value, and thus enters a busy loop trying to
> reclaim much more than the actual usage. It's really a defensive
> design or workaround.
> 
> And later commit b4536f0c829c just removed that emptiness check,
> leaving only the underflow check. So at this point we are just
> defending against underflow. Currently, I don't believe there are any
> known leaks or underflow issues in mainline, still purely a defensive
> design.
> 
> Reading these counters (mem_cgroup_get_zone_lru_size()) is much rare
> than updating them: the only readers are reclaimer - per loop, each
> loop will scan a large chunk of folios. Or during reparenting - per
> child.
> 
> Writers, however, operate on every LRU folio.
> 
> So checking it in the reader side is much lighter and cleaner code-wise.

So, one motivation is cleaner code?

> 
> Checking in the reader side also tolerates deferred accounting false
> positives: if a folio is added to / removed from LRU but have the
> accounting happens later, that's fine, but might cause a temporary
> underflow (there shouldn't be such usage right now, but cleanly the
> oldest commit I mentioned is trying to catch something). It should
> just proceed without performing extra operations on the counter or
> raising a warning on the updater side.
> 
> The underflow won't affect anything besides the two readers mentioned
> above (reclaimer and reparenting).
> 
> Besides, I don't think warning on the writer side will help catch the
> real leak either, it just adds overhead to a busy path. The folio
> triggering the underflow is very unlikely to be the one leaking the
> count. And if that leak is actually caused by a race, the atomic long
> change should cure it.

I think you are going and looking too much into the history of this warning. I
think you just need to explain that the current warning in the update side
already can't always catch the actual leak and is costly. Moving to read side
make the code cleaner and warnings will be at the location where the consumers
we care about are going to consume it. Also add couple of sentences on behavior
difference it will have i.e. warning on flipping into negative vs we will
continue to operate even in negative but only warn on negative consumption.

Another question: why is this patch part of this series? Just some orthogonal
cleanups or are they related?




