Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E8DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685348E0007; Wed,  3 Sep 2025 06:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C488E0001; Wed,  3 Sep 2025 06:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5992E8E0007; Wed,  3 Sep 2025 06:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 489468E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:18:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1A7F59D3C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:18:10 +0000 (UTC)
X-FDA: 83847538740.09.233C516
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 997F81C0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:18:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756894689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ65Befhlr72Ia3ZmnOetqt80T+UP+YkUCseLmOi+mg=;
	b=za/NyR4eGgJTJJlLCkeYa757px3yH8Oz+AXXJnLEG2DFqSIChyhvGkOYStxRiFoufdM6zt
	X1ZiVkiitkSd16bGHOwUdsBP94n6XcGWcMM156sfdyqCAvUWxXehVclUWr0fnIMDYI/Iky
	r/atAhAE9LeM2zdty7KphScil5H8bYo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756894689; a=rsa-sha256;
	cv=none;
	b=KQ/jfyXX7/UAjcxiAGuKIV0yO3afsrtJnej72IlFW5b9YmaD+WeCChsH0VHeUczKukbtbz
	LoO4oCtT3+6fptSR9Y49GN8ts+RF8PAVFh5KzFlOWOO/pNc3FiEaHcm7o6PfYhEwL12u62
	WBnCy5ZauVv4htDXxSY7QTgY6xqExKc=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 3 Sep 2025 19:18:05 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 3 Sep 2025 19:18:05 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aLgV3YF9uds7LC9T@yjaykim-PowerEdge-T330>
References: <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
 <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
 <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330>
 <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330>
 <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
 <CACePvbU2iqLyjc2uR3d=56S4A-N4P7k3oUnwA-6D=TFfQ17jBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbU2iqLyjc2uR3d=56S4A-N4P7k3oUnwA-6D=TFfQ17jBA@mail.gmail.com>
X-Stat-Signature: 9196s7obhbzgdknk5w4gqt8qjpmzgri7
X-Rspam-User: 
X-Rspamd-Queue-Id: 997F81C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756894688-740716
X-HE-Meta: U2FsdGVkX18TcQi1eRr5t2M7F6NtXqKdorpg8lBxm9BlPAm8t4htG/36m55W66BWMMG8/pMusWvZM61Vyl8fO1Dp3hmTv3E1EX2LO1bdzj0V7DvaBZoxBHRHPnY2oJOHx8wutl3BXHytco3WQiHG/2UvVQx++RvgJmIb1NQLbV3Tw3bwJ3wewpK35WskyCk/WB0y8I4AYXy0F2/RK3Lgcy8rB2z+wJhFOyD03yzO6/50Osk+LxGAUfOaaNdcajrXG8yVeGOZYvLVFn1SDJZdUQaizArxwtUMFcVnjfEwuzLXUlzTEigY40t2UCt7Cd/Q987sE+r+m21uq2kdMKsyiIpSHPGlob48X0n+JvxSKRjVARgtf6WLcPddBrEyH41Tls2qkgWZq8+UTWkTusemGQibiGPScJ2XdzFgBehRe74AgdwKKllAuDNELKJiids+WkVp47h5gXqh3DLoB5wtpZHsfUI0/kcPKgum5hzBuawj7xK4FLsR+y/ZChGYB52XH0qRkUes+lv7CDCyGxWnOC3nWse05m9nb6nL2aO2PgsOntVE+wQqf4P01uDnNVdgHQE8ZzHqvcnn9NKxdDLj9pmf0V6n0jLv5Gn3pD+cJovaHV9FG7FxNVXz3Y24HZ6vb9LBOtqJIC55aEMKLiYn2p2zXXYeNe6pCPEfkKM9m4z2MgOhrw8bBZuYQfBO9xw49QNxITwVYCPHj3xNsnMXJj4SzgmJzp5efymW7i6bI2gkG7Wk7n058cUvI9cINv2HhZykyHlUXTXo2lWChO1DPu5vW4jjcqaDOflbtdFUkwXDVaY7TvFRKnLqz+O5i36pco6xkX6XcXubTb2Mm6v/e9a7+Va907GYQc+BxEuarduoem/cp9ZQQfpSFQ41DMe/Jzy91YkMelSNChAU96bN9r1qSsk+vTyU/EeO/NpDXLNF5LfPI3uOubjvrwOiVAPRpBuoZq1Ki1zBR8fAo9k
 BkOiLgiH
 WB/AJOc0NEiMfBr0T62KRwE0wlkr5FdyTaCjhmddkI3iqgDo4j9yGvgMHGconw1WRDP4RhyG5BE5+R47QlKcC/pRoK7ENmYcsdQZZ69UoK0SfXPZY6vCi+k2ISbdOeqq1tPKF6+uJwPleaWtoJ952umZiW8DaH+H9rC5JgW1yLqGljg4ehXRJQxQpjQuSLlHZuu7yZmUaXeMPar/8AsIgTLJU3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Please accept the sincere apology from me.  I was grumpy, sorry about
> that. I was under pressure to be somewhere else but this email is
> taking longer than I expected to write. I let my bad temper get the
> better of me and I am sorry about that.
> 
> You might not have realized that the proposal you made has the same
> kind of buggy behavior for the usage case where the change of the
> parent and the child gets it.
> 
> One side note, I do want to rate limit the new proposals I have to
> defend against. On the other hand, when you make a proposal to change,
> you have no way to predict where I will consider it good or bad.
> Otherwise we don't need to have this discussion. My hash reply is
> uncalled for and I realized that now.
> 
> I am over it now, let's put this behind us and continue our discussion.
> 
> Best regards,
> 
> Chris

Hello Chris Li,

I received your mail and have been taking more time to think through the
discussion you raised, so I had not replied immediately.

Looking back at my proposals, I realized I kept sending out questions as
I was trying to align fully with your view and bring things up to patch
level quality. Considering you also have many other topics to think
about, I will take some time to review this subject myself and focus on
reducing communication overhead.

Over the past week you have been quick to review and very engaged, which
I greatly appreciate. I feel happy that our ideation has aligned to a
good extent, and my frequent questions came from being motivated to
bring this up to the same level of patch work as before as quickly as
possible. In hindsight, I realize this also reflected my own impatience.

I am also in the process of clarifying my thoughts by working out the
aligned parts at the code level. At the same time, I am considering how
this connects with the points we have discussed so far and the areas
where alignment is still incomplete.

Once my thoughts on your last review settle, I will send you my ideas
and any remaining questions. (almost done!)

Thank you again for your thoughtful reviews, and the respect I
have for your guidance throughout this discussion. 

Best regards,
Youngjun Park

