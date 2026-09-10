Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11574C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81536B008A; Thu, 10 Sep 2026 18:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A338E6B008C; Thu, 10 Sep 2026 18:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922AE6B0092; Thu, 10 Sep 2026 18:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 672216B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:34:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07479120272
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:34:23 +0000 (UTC)
X-FDA: 85199307606.09.D7B6044
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B9044000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:34:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mcaqD2yT;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789079661;
	b=jFNJVTmsw+U5d7wfr3O7qY3Ytj3seNbIzjyVvq3ffAB0r3ZPMsLmnrkAXtqbZHXKZo/35d
	AMexmy8vB2c4fIDnvK9JNjWuZAOruzfulgXCMWiMILxlVqaxA1oGu/x8+cFvOabPPQugOX
	U+nnUq8tjhrz8kjmzdHeynM3gu1cLe8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mcaqD2yT;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789079661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7GGU2eTfZOysjm89mBFxoCWklcmpL9zk6i94bDBeG8=;
	b=12iWwDZYLW1WcpVyU0DwJ0V+O9ZRjZo/AbxXLCb3ZpKxBQ5/s6RoI4jKdWckjF72LO9EV6
	EoKqzTe48CoqmkC//+4zbWdeu7w3KjmuovakhjjW6ZEcdtBNLqJLidd9XvIPayIQNgvlT8
	hb083mhZIlsOCS/YZOgPl3VGiJzeeAo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1022C60200;
	Thu, 10 Sep 2026 22:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5921F000FF;
	Thu, 10 Sep 2026 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789079659;
	bh=t7GGU2eTfZOysjm89mBFxoCWklcmpL9zk6i94bDBeG8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mcaqD2yT8CwlBMGZAEzwF9g1AG13LrO0OZyUCYv5NPuDFxEfmb8eKSK57i5VPTjI5
	 E8ijKCbrJSJGtxPIsvChsitXOOLKL+tLhZ7LFMD3hddl3ngo4by88iP7BQYJdqrRkC
	 VdYyy05Ln03NV2tuYLtpwQh4J4G5EbQwx3HPVzXk=
Date: Thu, 10 Sep 2026 15:34:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, Dave
 Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed
 <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20260910153418.e818710d3c35aa075f1156ab@linux-foundation.org>
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B9044000C
X-Stat-Signature: 877ts5zck65n5ibi9318ncr7ukbnuj45
X-HE-Tag: 1789079661-676635
X-HE-Meta: U2FsdGVkX1+4sigmZMxWbrS9eMwiS4mSQyQF/Wv4gzs9l90jYbZnLz3SPlGO5EKcCjD0MGk6r9yXaI4bRb3o8mHOxDVr+MuXvfBML+EGiFswq1beUmhL7tRc/KDNKbUKWz6rDyTU7DJpMaKCgy/6jGG/3CGgbCnS2Rc/lBcNFJMyh5WtcEkAON6G7t9KlSox83m00doQw6T2yC30Mc392C7HRg42clZ2bXdajcy3n2oTvNGAqYS4xWBlld6DBBxt3b9fpuN3L3yiJeumNoaZr79VKa8bOfCRT8YPNsF/P2R8L0kbABVKy2a0rc0Xo9mVbnsqU08dIZPS4AtnIf/kFpCezZMOlTLkbS63q8dfYMm2Fcf8hMCQQGKz8SLJb07gTf4mox/oZIOR7mZlX55QzilOOHzdb5viF+lbogYAj1MTthYw0VMdybogI+xcx1W3C8tQ+oQzwvhBUFBjTR0N2KVQGo4bzOvnwvOx1dflEqnLwWKBeNfzVH/z6U1SSUb6s/sgZoFN5Ze7kByfaJwXFii7h+MKBSo+I+9nBU3PSJ1wmpllP66hoAE74Gw/K0IXzgku1acHtTvZ+4EwzhMRwn/LAWA7oKMqWPYw+C0AtcgW6D7qUU80VzsA0LmhwrNJY+qu64NFJzzR4fxuXw5Ck+p0kanhphuzIWuWZEFl9XYiKv/BkBxp014s6uZ17AiC6LbO0Ofa55DpL+5E/5wjVIUL6f4dX2LhliufqdZyHqVZFBrodedGvKwc4xN2IWM0/PHUHwbDG/lgPA3OaEQL6vAFt+0vcerahz5uvhy970bInfnFtVbQYDczln0hMdUud09M0VMoHXtnF+GHvVRtnyCzK/Lu3JRiMqLx7dBG38YP5gECqSbnHU8ElYfUaYt6COlRvlUT26QZMy3GfVHvmSoZL3Ni49uG6i1kyKoUUopWTQ5Messbznaq04fWW8N7CUA/kQGeBXenyyfB1Ew
 vevsEvWm
 CWV9JAL18/cPy753XYnBbfegVSrX1nmCQzxOCH+/Ie7ZdZHaeTxQz+otTLyogetPcolZ7fzFMKdPV6A1eI+Exv5NHlNP8LTxBrl/8gIhKanYHZHIg74Gr1rfZrX5tBDDOoPhS8+Hz7lt1cRHQ58FVzDSFTOEQkwAvBugr9SlMmEv4yfKiFFukmyG/a3Jq0rrOQEgwEALcm53+cQfvXxza5rK9Gm9QE+t+oZByWERBtjieAz1a+PgvEndZiOzJIkRVR+n0vjRDmGVNcBzRr/41erT66HnbqTKKF/r2J5ksnk4lbcqDCHoBtACA9nBulfu1oNrCMHxymLtx8eU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.
> 
> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
> limit-induced reclaim of a cgroup neither splits its partially
> unmapped THPs nor writes back its zswapped pages.  v1 of this series
> [1] restored the flag to fix that.
> 
> However, as Sashiko's review of v1 pointed out [2], the flag alone
> is not enough.  __list_lru_init() also collapses every list_lru into
> per-node lists under nokmem, so even with the flag restored, the
> objects of all cgroups share one list per node: the per-memcg
> shrinker bit is only set for whichever memcg happens to repopulate
> the empty list, so pressure in other cgroups may not even trigger
> the scan, and when it does, the scan walks everyone's objects.
> 
> Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> list_lru"), THP had fully per-memcg deferred split queues embedded
> in struct mem_cgroup, working independently of kmem accounting.
> nokmem only opts out of kernel slab accounting; THPs and zswapped
> pages are user memory and remain charged to their cgroups, so
> per-memcg reclaim is still what these shrinkers want.
> 
> This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
> memcg aware under nokmem:

Thanks.

It seems that Sashiko still doesn't understand that memory allocations
in __init code are considered "can't fail".

	https://sashiko.dev/#/patchset/20260910080722.3961351-1-qinyuntan@linux.alibaba.com

otoh, failures in the functiond which hugepage_init() calls might be
caused by things other than ENOMEM so I guess we shouldn't zap all that
cleanup code.

Anyway, that's unrelated to your changes.

I'll save this patchset away for later and shall await reviewer input. 
Please poke me in a week or so if there hasn't been any, Things are
crazy lately.


