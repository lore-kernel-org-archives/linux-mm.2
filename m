Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D50BCD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 19:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EC76B0005; Sun, 17 May 2026 15:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507186B0088; Sun, 17 May 2026 15:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4440C6B008C; Sun, 17 May 2026 15:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 395336B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:34:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC3B78DCD0
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:34:46 +0000 (UTC)
X-FDA: 84777914172.28.65B3169
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id A8D3280005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:34:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYSH0kMs;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779046485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMAxYkiLe+6rFdPj4BXY2Sm1CnSl5lwd7zUgGll+LNI=;
	b=Fp+oZ5QMofxDzVr/cK1V3Q5rnfJl9qyZ21CkMkOhYrktYUxr7MgF3lwsq2EzND1CmS1Gzj
	gKNuttmN1DoOZf6u36cLE2VbntkcTDF9r5skRBj9AKSqM0txmHfSPe6c4jq7vUlS0TEMMD
	g4o+xIHskPm8WbvwIQc24b0tQC54rvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779046485; a=rsa-sha256;
	cv=none;
	b=p8R4AFxU5CLk/R/dP4m89faIaiW9lMdPWBzh0SrhDPGxNvBTEKSwMorQQ3MDeJLZlwjf6a
	WuLIsn1Z6LTj+Ma5MjRzbLSV2hDoYHXjsT74FhQmatAqFcRc3EV6Hamk7QBSrGOrntZYce
	zdQEcnmF6vNnK1Gft494R7UoFL1hbVU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYSH0kMs;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sun, 17 May 2026 12:34:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779046482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMAxYkiLe+6rFdPj4BXY2Sm1CnSl5lwd7zUgGll+LNI=;
	b=tYSH0kMsOtzH6hBlheNnNNf6sSMd47g5ItVVvMKyFwyPg9cXN6EyO0UYWh17vOpTHcr+F/
	Y1RkFWSkhCPB7TzPu1m7hU0AVSnbSCx6T+W6KKDwL3Mw41b7MmAgymsUyBB1jt+mEZWALF
	4ggl/OwcTDyCUNJTDbmgXOI9qz68eMQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <agd-gbYnVyaaiLH7@linux.dev>
References: <20260515171953.2224503-1-shakeel.butt@linux.dev>
 <agdnTPXhuepuu7hG@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agdnTPXhuepuu7hG@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8D3280005
X-Rspam-User: 
X-Stat-Signature: 7izpsbq4rcb148z8rf1pgsxczax55wjb
X-HE-Tag: 1779046484-486441
X-HE-Meta: U2FsdGVkX1/Bg1wYUQdF9apVeThWkfvTbqPlfqmk3bL5TV2LDdh9u9aviZBZqHJ0VX+jaJFZoQM8/qs2h/iixdPQUdNTHE8MiZeTxlYogqto2+QF7bTRvQHaMR+66JG5nWAZ1GnQKvV438cZlDFMJo8W4JAK1zvArbuyv/VASeU5yteys84a49AZ6S4bj9rpWyiMD0kmOii7Q8YTwxKJqxvN3z3MqtbvYavLf1K6HdWAu9xGU4Qw8izTPKmBhYNpWdwvSr+eMU/KMe4yj2RLZ848V0rZaStzkNZhm1v0M340QqQipJTRk5RLd1fyEvce1F8ywe86BJzM0+VSSPOvQfRQIQfR14VqipQKjCTZ+RfiLJwJr4iw8WgKMXBVTZT1FNKcuNTCfv0KtEjhPd9bBZsqP+f5Ma0YKdnD871DkCYewwwOr2IO9KrW01bv1kUjbJbfRAKZ1s3uj5dC2NR5EL3XvXQOHGBUkQJ77kSdDerO2JPgpTS12nsZL4HAf383AkCPEVeO6y13i2TTlZ1du0laUbmRq3OwSIyrsklkp99eeATJH/T70wuUhVWnXtoGrobMSu2M4se4ExPZcfPZtTl+fbRqcB03VyJ9lzZ3enhPXRea8yxOoBiJ2r6clwEDL6UdPRQhQBQ+g6Tx7ST5UjebfEWBaJMrUlYPsVqxToT9JsCKPzfhBji81INm7WE7yRudmg+EYm7K928Jg6Z0kky5iLlG8s0GX3JbLTsyIfMCbTEe/vRwOeCRM+duQiJACDNusg5y6pGx/YfWv1kOhcAviGm7AFNmJkY4jucTmEXoNCklGsR6tjwUDwYXM+fr3aad92Rx1JSk1MRDg12y+a2S5dC9UK2eseVmQnvAhndxJbNug/qubfsRQDGHCEELqCCUC/xLDw2Tp4D+B1eafMOZBkMlGfzt7LYLwyIfAA/s8t3mOdnU/05yh9my9HmKnrqgt4X+TVvKdISy9Ti
 Im7fdCy8
 Oi2HhoDTKyZNXUMiHYnOU6eEo1tM7yzEMJ2O4c0ji4nEEfZ8vD/QIKRaTRrnpvRyv2OxL1gk8BaUEIDQpA5WRDbjb6eFAy0XcwqABxUXooTblIfaO6tQWTUGbUnQ2kYM46V/q7rOiwO1lsIK0PA3nTTQHjnpvJoC7ONJoloKDAqvBr3exOtzM8O8+ZgBwgeVnIZeGYBGwFCaxrcCT01TzbH4mrk/ggwnCYLJel4AOfPdZzxqw8SJBBHsCSCgR9P7dImZy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 11:42:39AM -0700, Shakeel Butt wrote:
[...]
> > Will sharing the reserve between per-node sibling objcgs without updating
> > stock->cached_objcg break the page multiple invariant in
> > obj_cgroup_release()?
> > 
> > If an allocation for objcg_B consumes bytes originally funded by objcg_A,
> > and the stock is later drained, those borrowed bytes are flushed into
> > objcg_A->nr_charged_bytes.
> > 
> > When obj_cgroup_release() is invoked, nr_charged_bytes will not be an
> > exact multiple of PAGE_SIZE. Will this trigger
> > WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1)) and truncate the remainder,
> > permanently leaking the page charge from the memcg?
> 
> This is actually a very good point and need more thought.
> 

I think we can handle this simply by taking over objcg->nr_charged_bytes into
the stock.


