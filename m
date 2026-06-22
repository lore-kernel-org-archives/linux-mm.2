Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B99CD98F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 05:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B106B0088; Mon, 22 Jun 2026 01:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C8E6B008A; Mon, 22 Jun 2026 01:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB976B008C; Mon, 22 Jun 2026 01:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1FE26B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:03:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61368A0575
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:03:21 +0000 (UTC)
X-FDA: 84906355002.18.BDE93EE
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38464100004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:03:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782104599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c12N5nYGOWpE3YJPxTmno7tj9xtFK3W1IzQoMcBl35Q=;
	b=cueSI/NEFsNpx73jXqgcvdFgxNZxE0PxvTvDx7Bid5D7UzejaCghzO44WW4kJjhC7pSWkJ
	e9cex7euXu0W6sV0T7k9PvTzlMN+JB+CoIhXVipUCWx+MMMF65gC9t2lw8c8IVfrlnbg3h
	8M4SAvP+5KRr9+QuG+wrttvQmrApHdk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782104599;
	b=dwod/z5rmBtjw08BUXjxE3dJujfz0Lf5nnCsN6wDvJbyW0lMDkBH8h4JqN00LLkpBMOnx/
	CuZryObdv4i8cz8nB6xPxeJW4aYfCyl3vIniAqrpWg3/702Gxx605sMK87UuE2kzyuYIlq
	KV3BriCDG6cQCDI8Iue8gJEd2G2nOGg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 22 Jun 2026 14:03:13 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.154)
	by 156.147.1.121 with ESMTP; 22 Jun 2026 14:03:13 +0900
X-Original-SENDERIP: 10.177.112.154
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 22 Jun 2026 14:03:13 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	mkoutny@suse.com, baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ajjCEWN6IwNJLv4j@yjaykim-PowerEdge-T330>
References: <20260620181635.299364-1-youngjun.park@lge.com>
 <20260620181635.299364-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620181635.299364-4-youngjun.park@lge.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 3n4iujc74gkske34ae8mts5h87g6dim4
X-Rspamd-Queue-Id: 38464100004
X-Rspam-User: 
X-HE-Tag: 1782104597-611699
X-HE-Meta: U2FsdGVkX1/GgoVFV/ORqzRzofXFwuglPz7PdpPyzq8DUmzJuim1G4pGijr+oWQJEEsOJoD8Ao4336ykR8bj0xYsDCiM2Ugp5r28Iykv7eCKpVyRaDQ6w1lk1/jTHgwR/XQ6WlczMQQvINCOWfUVzzPgDNfjvB7jX4fIDyhVzAANy/VYDa2BIkcaDxNXQgOOQzTovwEuG5c6MjmKmaHk6Dj3YUfxu47GM4WQHJA2yxQEG7X864kV1Da4o4zlizf6dqWyi4N2kY3Gg1c48Q6DqgwELUw7ALJ/ih7PFlDFksCRWO5pV/GibN7I1u1ojaIPn8HCmOhnfgndYEYgw1Nzqbnq4SgooZwSfhppHq/iT5+Wx5YtIQ9SavW0OBlCjwzUGWxxPY5zqRBcsmdmfmUK0lBXzUgebGMoVGk7QolBFB4g4c3tohVhm8Cnfm5cyAeMCHacXjM58YsXiaic2Vkw/uiZfJM5AdmAZ6AI8HBeyNvfsT4cNjMZvamnPBDbLBt8/vqbJv6IPeZm+0usJtveP/lEYMNiW3u6Hzo/gCDbWzQu5ySQvax2zuLyZ8E7FdJbMBgf7Tymhgtcpg8NfYDPT2MzuGet9WWEVX3sRLFU1nZvMPmbo/TRm7KJMG0DkhTETVpu0UwPtxlRpJsCMJi7ZfJMO4v8WtY4xdeo7uFIN99mHR1UMgLaAYFIEz/xkdJ8ascyI9YnoUltKvq+DBaN75Uxe7XEGPGqhgV4p4U9544fs3k+EJV2XcUMzyvSDNgs4edymI74Aw6Kg/1N/oJ4ye1Sc4LIbEkgfxzpQ1M4HGsAMMwyzUX8RBBueBOIsyqIPTSLBALmDplvML/zqC4BzRLA6PWMaY4HbTIQjjTJ2qtRA3WkSkLHc23Jy+F50b2Yc2ZIZQoDaHdzgh1fHlh7Dq55k8x92iF7nnb78LKXx7VMevsqcQS1BLCI4ymbbbOg0cjq3oC3KK/uwDpyC/t
 dnomae9S
 YfyBfEvQT9KdklKsStnzKIkjsOUz/q1uaKLCe/gcGB/3GIqM9aXaPEmWfGGd4/jlZTcclD4K9n39VEbuonnChGt4k/Ctnao9G5xvon3dFbGbr1KnRHygDYUeuB3vrybjRStxXIbVSl6c6zc1b8GH6Q+gobFp7iOHRPgO95yVOR/XWXFQZXLGg0yufIdbh6Pfi3laMshGFPo41wfWT7DpWpoabPg758sKq9lXTLWfsDSVylerDnxO4DAQnSFvzWRIJJeIJalQVIjRxDRmMvmrN5RWm4LmTdJK9yhUWIMykkuFlHsZdxcu0lZ+5OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

https://sashiko.dev/#/patchset/20260620181635.299364-1-youngjun.park@lge.com?part=3

Regarding the Sashiko review comment, I don't think this needs to be
fixed. It is acceptable for the effective_mask to be stale on a zombie
memcg.

The zombie memcg LRU is already reparented by the following patchset.
https://lore.kernel.org/all/cover.1772711148.git.zhengqi.arch@bytedance.com/

the effective_mask is only needed on the swap path. Since
swap I/O rarely (if ever) happens on a zombie memcg, leaving the stale
mask should not cause issues.

(As I mentioned above, there is no need to fix as I think.
But somehow if we needed to fix this, there would be two alternatives.

1. Fix it at offline time by setting it to SWAP_TIER_ALL_MASK. However,
   this approach would break the parent tier relationship.
2. Change the memcg iteration routine to use css_for_each_descendant_pre
   to explicitly handle the zombie memcg case. This approach would
   safely preserve the parent tier relationship.
)

