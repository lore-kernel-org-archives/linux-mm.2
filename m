Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604FB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJzrcT9e
Received: by kanga.kvack.org (Postfix)
	id 61C5F6B05B0; Mon, 23 Nov 2026 10:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCBD6B05B1; Mon, 23 Nov 2026 10:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3746B05B2; Mon, 23 Nov 2026 10:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEED6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:36:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8078120290
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:36:12 +0000 (UTC)
X-FDA: 85466784984.18.9FFC814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 063D8100008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:36:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJzrcT9e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795448171;
	b=F2PAyLjRlfIiCx14cWs0m+FY7TFOZ8BqfME5njSERNlNDQyWqH/KYQtWj/zCFKOBlrTJcN
	ugOdXlJjkEkC53TAlMd8jc9+/IRSuOLYdFBzocJKG6ieaxUQfztC/1goLvHpXyG4iBzuWv
	mh7Ebo5oebnAT4zcS/Ol6Vs/VDv6NKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795448171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+N93dfL1tS4vcORykzmFFgpIx1SWzI8NCvELJJ4qcd0=;
	b=Sl3ixDle5QBG3z1olSHZJegkpWvKNHGFg9frK4ir1MTvthYLOlNxgySdIeCgRMETuIgRMR
	bbe3+Wy/d2IWqwKcFpjSUh0UGbvmM4SuoWJRvSueKDOqT7VdG4vySLTdCiclPX0egAnbgT
	nUTqFd3vzwsVt+lKhg4M7KG4uhFsmAw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJzrcT9e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72D942456;
	Mon, 23 Nov 2026 15:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD1C1F000EF;
	Mon, 23 Nov 2026 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448169;
	bh=+N93dfL1tS4vcORykzmFFgpIx1SWzI8NCvELJJ4qcd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJzrcT9e/7DPR395fu2ht/DhVdesdi7aWR9+JQfaBM7llt5JPXs0pLQXpe8jkukYs
	 6u/VYUmPrVSDW60ljr4xuXs5jJb0FrBXWo3cxP3HY1g1pt3SECgpRMzVk5I3G42OEz
	 p+qBpQPPR5pSkM41CpIo+fEZk+m0QAqandp3uEkzJxN4c4tKtFf549ZyugT8uQKO2P
	 b069Q1VyBsXwoC56ZxAPQd4ffvRBiJuGoIgMzxAW5DxhAnfBcmyPi3IX/U7G3BRIHM
	 w7mC/K0bpNWGMI6kjrXZFnIwc/3fUmuCq440Gq0qLSBl8YMunma2zzGThmH0hlM8ua
	 jQbU5gqFwk6GQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Dawei Li <set_pte_at@outlook.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/sysfs: skip registration if DAMON core init fails
Date: Mon, 23 Nov 2026 07:36:00 -0800
Message-ID: <20261123153601.85440-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123-damon-sysfs-init-guard-v1-1-a2a6ca65693a@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 063D8100008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wob19x1e4f4hosrgsch1eoq7z8upszc4
X-HE-Tag: 1795448170-698076
X-HE-Meta: U2FsdGVkX19zg4MHdIXZ3c8IZAGfCQm6FBp8oz1LdS4ZTvpT2uczzmbgDpBr4ImounbsQO2kb4/F0rXRrlc4DI80wEOyAzxG70V87dxFuKECVtdVeg58a5t4ywGN77ck6rIzoSQZapcIO4kIzF+I7+OHiI3cZZJcetUmJYCdafYhcuPhPz3qQHORqNkLQnzIkyZ0oel03J7tqCLpvb3VBoRcj34oR7W6yKcEKfo6e2dkBc4q3ZHWnjArQQeAp9X7Kq54Q0ueoXLkoRxMrumHjLx63Fn+wY/mXxr2k060LK3+52RiQANfRHdE9hzGlqoYRCUriXhtMXp4sQz/yVlyD6OKx/Fi6EgUPlwiNPhUOZc8yq1QYhrH47cvkRgaPQ0tMVGYicqBvhYWfeiW53YXbMRL1Aa66AxwQXAPm6yqZR7MiEshJuJFPHFXQmagp2qMMhfengZovuq/aMKWTLdD77KYHZnnakqk9XpubWxBEy2SMoArlmCwHIFwgDCT1tWb7yR85cXeW8xEfqeYwcQUc+hSzpuQgaQiEkhFwODU+w5Hxc2E0axks0m1hd+0E/cARoe+7wBiPYG5bWW1V30YwIPp61hm71pbuvbdx1X3CClWQd2ikiF4xbbbQVa5AUkHrAuXypsptcO+BrvJSm+lmQu4OK0nZCcFKjWkNYEaXlLHLK8nn4SX5bunuKGfB0mbzNYgMiuY0e9ulXAQTbJJ3OHI9rTqubEq3nbXnE4fhxtsvdCcndWaWexdpKoLjZz0zD2cZF4DBBKypOBFkP5EeTRxaspoWJ0Xdn0QwtHQJsE1kBhqovK1YI789UeGz0mW62pcOg7r16HZZGA7wZAASFDxvCUUFvXwJNXw0shezqq11XteZfe8DQllUH5spG7OSup2Y/asZEYrALEhDZD68e6R/0QJsoHaxrMreVn4THu+fbQJu6Dd+313V/u4c74YdNFputTNYdVBoVjXSZC
 9jQK/LKt
 nusgHTA6lcEeCw7aO/H/4oH2KZfSzU3Sy2tOm5V04B/0NLLMY7YKP3XrsTMB9GiGJHh6fXFYkcJ+8wD+zcMaAoam16WrBQosjEd/qcdChupVGUfPuxNhqRMOjCq+f7kvQHhAKqa0LRhy90EqAaZCqSGQgxEphXL999rA1m6KnR7IvN/37PVNnKVIDxA7NIg4Vtd+DzdmikZK7rd6qqeDQHH1aA+aF9hNn7VDmidbWzyZ0CE/LCyLifloNo5Bypcl6bK7r54OhCrNROtv/GzMcJhvvyzrEPzzNUPw1xd5ndM97w1ZiWIq1vFGwE8ys8jrJNTo5WkX9JSknDqVfPdd37kbUl6bLhItNq4bOskHg9cgCesLafIUgZyyBOl24G27SykzSCySWChZvU1kVLVnIhsESSZhdW/KRAXyXA1q/0+4iLaeN1yxu4Wt4O3fjDOHxoLIV55km0osl8ZOiOIMetp37Gx1fXH6OLTNIkxv7kgOMzncO9kfygZRTrzspf/qB7C8cHTRYM1b3yGaRqWnK91GRbQYSG7i7TU3ubtLf7QLjet7LBmJwpR0vZ7/1OZb5ZWFsdvlZEDHu4dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 18:51:45 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> Here's the sysfs fix I mentioned in the report queue review.
> 
> -- >8 --
> 
> While reviewing the DAMON report queue series, I noticed that DAMON
> sysfs still registers its interface if DAMON core initialization fails.
> If damon_init() fails to allocate damon_region_cache, starting a
> kdamond with an initial region can pass a NULL cache to
> kmem_cache_alloc() via damon_new_region().

"While reviewing ..." part seems unnecessary for git history.  The user impact
(NULL dereference) could better be documented.  What about below?

'''
DAMON sysfs registers ints interface even if DAMON core initialization fails.
If damon_init() fails to allocate damon_region_cache, starting a kdamond with
an initial region can pass a NULL cache to kmem_cache_alloc() via
damon_new_region().  As a result, NULL dereference can happen.  The
initialization failure is unlikely, but the consequence is quite bad.
'''

> 
> Check damon_initialized() before creating the DAMON sysfs directory and
> return -ENOMEM if the core is unavailable.

Thank you for finding and fixing the issue!

> 
> Fixes: a18709442869 ("mm/damon: improve damon_new_region strategy")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Other than the above commit message,

Reviewed-by: SJ Park <sj@kernel.org>

With the above assumption, I applied this patch to damon/next [1] tree with the
commit message update.  I will repost it soon (~1 week) as an mm.git merge
request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

