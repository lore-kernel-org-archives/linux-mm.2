Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4192BF41995
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 17:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7613C6B0005; Wed, 15 Apr 2026 13:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7130E6B0088; Wed, 15 Apr 2026 13:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F0E6B0089; Wed, 15 Apr 2026 13:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8326B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:45:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AA6A1B8240
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:45:20 +0000 (UTC)
X-FDA: 84661516800.30.A7B474D
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id AFB79C0017
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:45:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mlBO/mYu";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776275118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C563PKmBwu9e720CGXp4gDf43TiENk08CsMILQPkock=;
	b=ObeEWmAO4ZipytbPnUwacDbAWL1zeW6OSVhEGIxYZwsyzbtSqdWwmErFswDgeDyKFbKk+d
	85mKnCFjgBkLWy2Jvehf9kuFlkfBrx3QyI+M3VVM1xPVlPIA1rFQWF9JEmgjUG//fs0lKq
	NeUTOHPNpIxhOW2y7EyS99uePORTiHw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mlBO/mYu";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776275118; a=rsa-sha256;
	cv=none;
	b=I00dh+XYtZVhmN4Sqjtz2ARxkAKP73DKQu3TBKaB0EySidPnr2yX29FuWiZS1wBqqTaddI
	Anz2lsdoIBbENVsc7PVt2TsZd5wLXWpTw598X2NVN1SsgqTMOTCDIiGfkTMaAfkQFi3mx9
	WEQl/SQl++YbAIUsdBKDLQJjYnppMvM=
Date: Wed, 15 Apr 2026 10:45:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776275115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C563PKmBwu9e720CGXp4gDf43TiENk08CsMILQPkock=;
	b=mlBO/mYuSt24pu6Q9NZK+FQoFa5e4S7j8OhN8bkeo/zjADF19DoMR0UM8f5kCZ2NBTdlJn
	lhoxYey87BzLhBhHyXroPE4h1+FGjCt3U2VTLIlHGFFy+46Rmi8ZFLviVVeitkNmIJ1hHK
	5SJpHv0NShbHtCSghFl6+zFFd7imAiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <ad_Eo7iQVT-HUkx1@linux.dev>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <ad1QfUWEPSCDUDYv@linux.dev>
 <z6m4h2yamlckbyzh2ey2ixa7t7s6hlzg5jcle4qyebkopkvujw@pcrzrkuycg4g>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z6m4h2yamlckbyzh2ey2ixa7t7s6hlzg5jcle4qyebkopkvujw@pcrzrkuycg4g>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 78nx5ygbwmfdoet17nkpqnpq4axjqx53
X-Rspamd-Queue-Id: AFB79C0017
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776275117-540417
X-HE-Meta: U2FsdGVkX192u5arE5RB3YPNZohZ/W61Prj2ZBIgqknYvWZ/eCsKNVoG+2ae4bYzJ4p1Y9JaGnCS1o7UFcdrTo9Kuy+x8RQ3cEd+JujoB7mJGxy23p6xfOtoofFNh58l+cROG/pgPEw/3hst2ktj+M/nAQkMc0itteTnOIPF+0afGAUf4/KgJzhCB/669pZj+HRst31Ynhgwv/cCcCFTn1xgTgzN1m8xecM2q0H6nd88Pw2WSonSKkQv73YNm1uW59q/BNuQeGJZFVqn1au4fZeEMsXXZLXmQZYp2Ttz6V3sIGX50tkz8OYhofenm2+S9eTHyta3XvJfdRTVlnMqK0CrJBq6Ou46DXDNb2f7Z+k822vA9zthbOzxV7ZOwQ5YyENzpqYZGKVQztUJNNgIAwqSpctwtTScca++fnxezlul/JL19b6qQupKhimwtFBU5ZJywm6Ko/rG9XiJFMB0M/Ey1QnvkMUqjybUBFbMp9h8EWeG7a7iVbzWcBXsC0/WM9iP0WtppBGjMilEDFq4oHQMrtKm6HStqZ22uJ+PVvzbmxKhWZVWl9mYXZZn1tK/HLtQDUUIIWI8af2qA8m7uB8WBNluUbYR8cY/46mTcxuY8AYpCwJtCXHfmA9XQs/Ffxj9Ofou+CrjIiZsYDi30y5NmvvluCIq6CZwj+ht7Xuc/+O0HpBzjCI36hXM47L9pydHoHnSL6dXSWH94xnMjUR3TBqkzaw3T+GhGcD0tUs5CxaSuJhsnY3juHJ9wpWGEVBG8uZ1cD/rZvYR9Pik2mmObPifNFb+WiRgFOAGb3nikkYxydYurBIg5Ld3JUF/Tj4k41kG87bhh/+U1fvVXtr2v94f+Z876g+A3EHKnkiDvaIS4zaSEYB4aZpk7SkIv0c/GwXFQ5cOA8mM2Gcux2OOxwS86CmsCCOpPpNLsILdfg/HySR0cdhcIDg1/mKC7H99bqlhg2YZRGr9xEo
 0xHiH4LL
 mMgD8r1qhIzQEhkEHE8jD7PoSYVEtncr6rlPE5ezQ771l8LEPGbj8KWTK2evH2mo5G4vF29cSC9ql1B50uFtEeeNq3gNUmAQAJEgMAHSzvvM3AwTp4KtvVMJ+IvISdF0LvpbcXO7hXb09sW8MznZwhxo8LS9ZhoDSJL0nKWsS5BSvRtx7OTRLMD9dfQr/+k2AHVDIGxRPpG+1yVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:15:48AM +0200, Jan Kara wrote:
> Hi Shakeel!
> 
[...]
> > Some of these allocations may have __GFP_ACCOUNT flag as well, right? Also are
> > these just slab allocations or can be page allocations as well? And does the
> > caller holds shared locks while performing these allocations?
> 
> Yes, some of these allocations may be __GFP_ACCOUNT - e.g. if we end up in
> fs/buffer.c: grow_dev_folio() which needs to allocate folio to load
> metadata into and allocate buffer_heads underlying that folio.
> 
> Regarding shared locks - it is fs dependent. I cannot currently remember
> where __GFP_ACCOUNT allocation would be done under some wide-scale lock but
> I cannot also completely rule that out. Definitely there are allocations
> without __GFP_ACCOUNT under fs-wide locks.

Thanks for info and this is really important i.e. allocations under fs-wide
locks.

> 
> > > I have been mulling over possible solutions since I don't think each
> > > filesystem should be inventing a complex inode lifetime management scheme
> > > as XFS has invented to solve these issues. Here's what I think we could do:
> > > 
> > > 1) Filesystems will be required to mark inodes that have non-trivial
> > > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > > whatever :)). Usually I expect this to happen on first inode modification
> > > or so. This will require some per-fs work but it shouldn't be that
> > > difficult and filesystems can be adapted one-by-one as they decide to
> > > address these warnings from reclaim.
> > > 
> > > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> > > kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> > > performance reasons. I expect this to be a significant portion of inodes
> > > on average and in particular for some workloads which scan a lot of inodes
> > > (find through the whole fs or similar) the efficiency of inode reclaim is
> > > one of the determining factors for their performance.
> > > 
> > > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> > > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> > > to process them.
> > 
> > This async worker is an interesting idea. I have been brain-storming for similar
> > problems and I was going towards more kswapds or async/background reclaimers and
> > such reclaimers can do more intensive cleanup work. Basically aim to avoid
> > direct reclaimers as much as possible.
> 
> So similarly as we eventually moved direct page writeback from kswapd
> reclaim, I think it makes sense to remove difficult inode reclaim from
> kswapd as well. In particular because I think such separation makes it
> clearer that while you do complex inode reclaim and allocate memory from
> there, there's still kswapd that can free some memory for you to make
> forward progress. And you better need to be sure that there's enough "easy
> to free" memory to allow for forward progress of difficult reclaim.

Another important point that we need memory guarantee for forward progress of
the difficult reclaim.

> 
> > > 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> > > inode, doing the hard work.
> > > 
> > > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > > and they can work on freeing memory needed for freeing of hard to reclaim
> > > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > > they should really be addressed.
> > > 
> > > One possible concern is that s_hard_reclaim_inodes list could grow out of
> > > control for some workloads (in particular because there could be multiple
> > > CPUs generating hard to reclaim inodes while the cleanup would be
> > > single-threaded).
> > 
> > Why single-threaded? What will be the issue to have multiple such workers
> > doing independent cleanups? Also these workers will need memory
> > guarantees as well (something like PF_MEMALLOC) to not cause their
> > allocations stuck in reclaim.
> 
> Well, single-threaded isn't a requirement but in the beginning I plan to do
> it like that for simplicity similarly as currently there's only one flush
> work doing writeback (although we are just discussing moving to more for
> that). Also the inode cleanup will contend on fs-wide resources such as
> journal so although some scaling can bring you benefits it will be
> difficult to scale beyond certain limits (again heavily fs dependent).
> 

Difficult reclaim uses fs-wide resources (and locks) and thus we can not depend
on it to be effective under extreme memory pressure, right? Or do we want it to
be reliable under extreme memory pressure where we will need to provide memory
and cpu guarantees to it?

One more question, I assume it is fs-dependent but is it possible to avoid
allocations (and thus reclaim) under fs-wide locks? One challenge/issue we at
Meta are seeing is (btrfs) lock holders getting stuck in reclaim causing
isolation issues.

