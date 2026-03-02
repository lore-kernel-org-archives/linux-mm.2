Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4A1EB363A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5EC6B014D; Mon,  2 Mar 2026 16:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654556B014F; Mon,  2 Mar 2026 16:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5600C6B0152; Mon,  2 Mar 2026 16:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 429D56B014D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:43:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B689BB838A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:43:34 +0000 (UTC)
X-FDA: 84502449948.12.8868B4F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5FA3140013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:43:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w2hfoSkZ;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772487813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60cRX5EV0xvioD8lGyLZx9fxgEd6hl9DNCuFCdZHzUg=;
	b=UUKsicVa0VteH3UWr+Q6Vjr5cYxPMk2fggtuty8kiqgX0AXZsA2CX8O/Ox4F0Ggfg1Ke5Y
	0vCqxfqH2TeV+G/UWSzxxNShX1LTgur7ERESQq4pRcQC2uORLGOViU5Iy8Sx3ddMfn7Ckp
	LcCSBzKgXeL2XRhJk8Z2oNvBW9x+Iqg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w2hfoSkZ;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772487813; a=rsa-sha256;
	cv=none;
	b=qW9DfMluu+Et8RidDvRkpSZPF1r+wJEOFzAU2C+CahG8YKVJWvYJcjCDuR3WA8uLTXXlqV
	RJdzIlSYNPP1lKSlkvK5h3GOho8KhI+U+XGuGeyKjketsRCzX4u6AbRTejuL8OoswAIJrs
	pHmeEug9BcXxtAMyutAeSQeq4sVMRqg=
Date: Mon, 2 Mar 2026 13:43:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772487810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=60cRX5EV0xvioD8lGyLZx9fxgEd6hl9DNCuFCdZHzUg=;
	b=w2hfoSkZ+A+JXyvdUbdWY4XkQwvehuRVQsgGPC3rEdj6XT1nX2Ma7VaHzvagHdP6jN6Pjs
	+ZVOP439zTVDKHrE5g8s2qpifFRWVa2cmxO68HK6rwsbZgCPQce1GWLPD/Ou+Djh9cSlYU
	oje1PcZXy2d3cCcEStF6vWOY7REGZI8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 1/5] mm: memcg: factor out trylock_stock() and
 unlock_stock()
Message-ID: <aaYDO-0Q--7q0eot@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A5FA3140013
X-Rspamd-Server: rspam07
X-Stat-Signature: z9ko15f1s5xzwzc8i735oqxyxias3974
X-Rspam-User: 
X-HE-Tag: 1772487812-87038
X-HE-Meta: U2FsdGVkX19URdkBmB4BdxZER781Vvc2uFO6+TBS2dJSAZOiGugCqCjrmFRJExgbcS/k665EDWlwTp6tTgsyUGz/kRVgTA9WSvnLYFgBUK1NwLZzfZfeVYWWjHRqYx5VNphNf69uhtu4h2857jBa6B1UnCtGasajKfHFBSTD5BGFKJFE1kE5NJIFtHetA9EF4+K+vZ49vkR6DOSP30oG6mHv/VPe3m6PK9m3oM59Zxw4jhar19hqriwbW96kQJGaniI2cLcJWBCmhK1vVR/qbo4XfR8coLMSScs5BeIDDmPGL2qUO/56Bpe/H2Hy5gtAFkdyTccuHF9c95sTNb0rRcWVpC/iy6Olv3wxuWLLMKxibLsXImNolo7mtQdrtq3xXHgY70UU5TevMaIzOMh1ROK+izPkquJgzJ4RPHONIRWXhWcyo2HYZgXPU/cHIsE55flO9Zr3jnCUBHycWbsZigiPOVJjRgZYrwYxmycMVoLwRQif6pZvOQVumGkwayCSjPzOdfqO6wauLlYRx8Y3NS1F0ubrdAILVkMkwo8kDQgBTB8PtFZEFvEymrFz65KcgCptiRSM/A0q2eVrLzgsWFrs+VXShiqudRI6K1Y//EbIva2VbbIffqq1uF+9zk1+9JMrWgxpj/Hgc7hGbtSnOcVKk7qlx+ml5dsAluy+MPUXWotxeLlL1yBJsGzyH2bYo3741yyh6NXnIDHdWO6iilRTQEXWRo2FVE8aprNVofgefktgKjKXtE0EEymxX+4Dh7g7VWQa3+ASQJya+8nnS8mzABPRIQbb9vx2Wd1ozg8fvVFxvhpuOz+Aeg7OhEh4rNfHpSKW4Nqqn0JeO8PxCFVeUONxiTxVqeZtSVC/MXjE3vYKKD36qrlLpDBEddGWZySZUeD4ZTsiGnudOxpSkBh/alvAulxJFmZxg5rtCmVperf30u+/q9EitMWJACc5VeZQAbpttJkwy0JYWFZ
 fJMSdIa3
 +cRFPZDbaW9O0L5d9TXYtUFCS/Ov6S2LDYVwfbj1qHMy40zZEGQiF42RuSx3lfgN3uilEjqu5Hcq3MLTwgFHy5UdoFsTN7+lUGykHPq/Q6XgDVW3FvhiGRFPpqIQn0ko2wu6s2NeSFGsSMZ/1hWI8kvA5CN+A8zsFTWePQC5Eh1puRd6TM8ckd5E4RzE85UWVscacBi8X2Bj3C0KDe91CU4WveFcA6FFIgRhlokeSXVC4Wv6y2ALAFjnw3CoV6hnPxXuGVPqg/7uodDBrcPTQqxv8MMxBBDeUrYh9un4Czm1sLmPAevRLQgfBJAu8QAhcRb6IWqSfHtJ1TzXfI8MNMgMYMxKQqbVkk9BnzPqLpbGRhmu7QwNPRJ9OlVHNpDyPwE3uCBTmm2O+9AhQwx8LgXM/fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:14PM -0500, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Consolidate the local lock acquisition and the local stock
> lookup. This allows subsequent patches to use !!stock as an easy way
> to disambiguate the locked vs. contended cases through the callstack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

