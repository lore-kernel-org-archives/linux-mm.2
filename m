Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE31DCD4F58
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA24B6B0005; Tue, 19 May 2026 03:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E535E6B0088; Tue, 19 May 2026 03:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69166B008C; Tue, 19 May 2026 03:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6B376B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:08:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 701B8A0238
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:08:50 +0000 (UTC)
X-FDA: 84783292020.04.55B3C22
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA96716000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:08:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779174528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3u8PBIZIGpTS7JAG86j6LW3qck3lT5FRFiQojdND3JQ=;
	b=XDyEU/amepGgwJNGeuVtx2bRhHx94/d/YPGU7HG240kDZk2OtSX++kwDMA4PG+whNPWGSx
	cTtXNN8NTmc44QgTIf+1lbF2LnMgTHjhdZSR54umz00fuKU4iStdDlh44GRdZZPPvVzd/d
	JGjr+3tVk3m5gv1a4axHNmEBS//SbCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779174528; a=rsa-sha256;
	cv=none;
	b=rPKWYrad4tKU3f0qbUZLiUVAJu6qWqQU1GrfKrpcdDndaXThjwErvoWjCY88iCNVsolM/7
	DIFlLoHchbVpvHQFc746phVnVTzPdxmEc0n2DJrB2755GEJGvHPoLtwRvVppsOF95zZVYO
	/O8MGcYnwqM+snP97158xbvvi3cgAmo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 May 2026 16:08:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 19 May 2026 16:08:35 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org
Subject: Re: [RFC PATCH 1/2] mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip
 zero-filled page check
Message-ID: <agwMcxlf91I1ZzFU@yjaykim-PowerEdge-T330>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
 <20260518073455.2495934-2-youngjun.park@lge.com>
 <agwDnPXJSDIjGkpC@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agwDnPXJSDIjGkpC@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA96716000B
X-Stat-Signature: ny4a5q1ag9pefwsfjgeztgcd3gh3x31z
X-Rspam-User: 
X-HE-Tag: 1779174525-976785
X-HE-Meta: U2FsdGVkX1+7kuXKJQ2ZV8yUtaIw5wc1/Z8qyoYL9QZP2hkEkDOhMm+KFVL02m7w9mYbYBHuiFYvIOYD3LBhmE/uPUqlzN2Jf6yY7TO9WSotA+YqTwAJumIbPi9+N8Nm0cI5BglIKbHY9a81P+Ih47IOvJPa++DmRyQNwsv2Jr9Tga5Y9c+2J6gqGS1YAQgMaMyUuJwXau4uoZK5Z5nFuuMQS1q71I1sJKN4ao6riBCqvMiESTZ+efTwPmnfozUnH6fKt3+8Z/7JT5uYcmBzc2TeVKLIQAQ548my3A7XfWdGk+z28G8kHMJEdbCilugQzuxCW4vSp1J03ZW4X0dFtBZUgoNKfmCnhoB59P8AQbrmCH7Fm8zCKE9QPehrNbMTmw6dH2dtLnllzodozUOUC5MI1BwTwjQPuWlBxAQHmXMs7z4hWj8rfsn/D4bs1I75RmE45nTtaAZ/KJoyl0fNt/JY+/bJEnWrl/65Q5pxcvZdv0FDkTJ246FeqgZy+Cj4k4sAu1EFZ5MmIgfd3wue8Gnl0RZGkW6tHKtyeofI95hgJfolw38m1SSFucwyCeansbFxdVTC8NbjB5IeV6hxuB5kqav4mwhbSy5BIDdCup5D3P0+Swyht9W4Dm5GBBgUWo97QHCRjrcHJM+fDELMqQ2eAypNjZOezg1zK3ghGI6G3HezppgdH0OnQKfJb4KdBzWfOUyGVZIv7LKCtnoc88WzzyYvXr8Z8UDUq+61h4a4yR6sEmLAIQ8BrrGnp1cTBiObfSUmhA2MLIqLc2Tl5zxT+yUuRhPZmz+0zhwSp+ysIXAtYBszqu/u8vannhLCqhn4g5w7OGOfWT0gT8Dk8l6UjydmrYgwssEMQAxUJd4C0cmlq+sBXQ/Jr2rvV/7OGAfDDW58VOdd0Bn4wyKukYjPcuJh9uXrSoZ6Ys//kJwt94ixHUAwuD9cKyWop5hEf7KmdMbb/7lgHOC1GpZ
 hNNExTwV
 aWYE/cuniWdILMUbICfriON+nfF85VpIVEZAs4tkZWpbkj1pI+sTgNP9isNY5IEG3uUefeaSbOoM5qRAh7yeVM4HjSXRzXS9kafA+uNp5DmCdQzkRk5UlsdJiwjOzI3IoPWAIjCvCyTfWkMB497339zvadR1sfa2ZdNlhVvZsQcXoehFQfkqtAO1kpxwbG67b9JC0S/FcvtnTwT7nhGUrcsm4MRq9S4MyF6pgvxuyEJmmebacff5Mr7b+OfB03ILTJV/KcesUuFKepgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 11:30:52PM -0700, Christoph Hellwig wrote:

Hi Christoph! 

> Nothing in this patch ever sets the new flag.  And I'd rather not

I defined a new flag that can be set at swapon timing. Is your concern
that there is no mention of the user-space flag setting part?

> add new weird bdev hooks for zram when we really need to consolidate
> the compressed swap logic in the core swap code.
 
Are you mentioning we consolidate the same data pattern logic (including
compressed swap) into the core swap code?

I am curious about what direction you have in mind. I can think of three
possible approaches.

- Handle it in individual devices

Can be optimized for each device. Currently, the swap layer
handles zero pages but not same data patterns, causing a mismatch. My
patch aims to resolve this. If we prefer this direction, we could even
remove the zero page check from the swap layer and let individual swap
devices handle it.

- Handle it in the swap layer

Add same data pattern checks (currently only zero pages) and
integrate compressed swap logic here per swap device.

Cross-swap device deduplication becomes difficult. Also, for zero
pages, it occupies a swap entry even though it doesn't use physical swap
space, which is inefficient.
And for same data pattern check, swap table needs some more bits.

- Create a higher layer above swap

cross-swap device dedup is possible and eliminates the inefficiency of
occupying unused physical swap space.

But, Relationship with zswap, might not satisfy individual device needs
due to its general nature, and requires extensive discussion?

I wonder which direction you are considering.

Regardless of the above, I would like to solve this issue. How about a
compile-time solution? For example, adding a config like
CONFIG_SKIP_SWAP_CHECK to enable/disable this logic across the entire
swap layer.

This way, vendors and zram users who select this option can solve the
problem mentioned in the patch. (However, if using zram + another swap
device, the other device would also skip the zero page check).

Best regards,
Youngjun Park

