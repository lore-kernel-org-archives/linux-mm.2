Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB38F3382F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7816B0005; Tue, 17 Mar 2026 05:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEEC6B0088; Tue, 17 Mar 2026 05:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4956B0089; Tue, 17 Mar 2026 05:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7B9B6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:43:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 617E5140650
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:43:39 +0000 (UTC)
X-FDA: 84555067758.28.27BD105
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A35FB180007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:43:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jMMIDPYz;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1p+obDYRdhvLkU6Bw7fXtU61Kp0oaVZfMO04Y9se3E=;
	b=AY7akyhFRgz4WJi9HEyjSEHOZSTFQyqmHlLQ05rjFPtI7dWWRzWbPRSY1DLeUsXkxEMCVz
	tTsiTUqWyJh9As4sEcqrab+Lx21Fg/9VpAea7o5Jepr+wt/ZCU6GlZfm8V20opiFUSzS1S
	eA0NwYF9b/hV2CF+r46lEQkbS5qrHk8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jMMIDPYz;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740617; a=rsa-sha256;
	cv=none;
	b=7rN7XTfLhofogUHiNPrHkX/j0iK4/o5SDMx7wEYn5FIY7NjH5kJLLaLsXD9Myl9Rm2hmE0
	+zi8A6JdOV3VgoBvHq6Cu7OU6oeD4Hk3ihi/QNE7nEwzXk622AarYo95YRSwwaQD9XNqen
	hDfxBlGCKEVEg0x4pLww5VmwLNMhzhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15DED60008;
	Tue, 17 Mar 2026 09:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C452BC4CEF7;
	Tue, 17 Mar 2026 09:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773740616;
	bh=VBazh1TJ6ZePEH9O1RoZ3eI3wnaMseQRfEN5zO5pzxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jMMIDPYzuhDA5wJ+r7f5TcOPLWdx0xajXRqXJVB6zh0TcJAAFDFFdRf0jApf5hOBL
	 mvgggZdDq2GjlaHbZnRUtRv+W8F+BWRfFhEoOgHVFZ8X1Ly77BS+RYMkzWHqD1+suu
	 s7jfivPg5rIn8E+hpJxogP1QzPAn5rUOkjOAiqbfY9M6M0TFVQvULucpKYMQ1jYdhD
	 m//gl8CEFiN82SMkHXWp/z3NabUGulpKN+WBr8KrcLAZ33tEPHCZf0Jypd6faw64Qx
	 s70OmHm2eXIysuKdIPgZNhbG5oYT9bKKzk/OJT+450+oqfVNNPTXN7ZcCPOGZc2pPK
	 Ap1RRpxkF3mbA==
Message-ID: <f5533ad1-d3a7-415e-a1b7-e4482a177ec2@kernel.org>
Date: Tue, 17 Mar 2026 10:43:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-2-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312205321.638053-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7ybe7db6ze91xdkkydnf3nc3hcsmwxqo
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A35FB180007
X-HE-Tag: 1773740617-443440
X-HE-Meta: U2FsdGVkX1+r9BE3hZvhnb6Gznj/69VRa10Bz/EXXWq/4Xy8U5BcKbTt3eijzJdFcJ4Ya07aWcYczxYaUsUcriWSvQjdtczO1fAO1MCgpvTE0agJdwyNGDRP4k34QbC+qE9LbkNTQgzuktxluHOkPNSojakJpUen1W7dF/jHnO3qcPy1q3uELPkVe4AFRLgAi6LJYyOnl4XKd6DWP734GEc2ukEzUEJvuMY/n3fWt0E1Z4Y5kNutClOyB+ngaeesZ0azX1xakx4jpluOZv/qJFE7SHNBfRLKkVAyzsybHySpKwnlhD94Tegilp/mcy1qL1bPXAAl21Ww/Qf4R33PLobr8eLevQ0qdFsJTP8B3SULPVO26okwS5WQ2bb6y1vLK7TbwAyCTKmmIypBszMyh62SvA35GC5Pq4WVhosOMFzdQkufRHRwlm6xwjZx8z1+QYacguWuVyula/efIvz+V8stmNRWfoBFtDO0fGhSwPVsUlY3hpGim60fQQPlQo7lBeA64tqijEEVYIUva5L7lOhyGCIcDXRTXJgt+RZYUB5VKwIF/FN+c43kp2Wzl71GEANIVNg6vnbelZaADFr15JzIXviw3w5KfxyLhXkmr7DcKEN0nRX2R5zMQcMQjvjrtqQZrUrY+9qp6OWpWWP31jSc1alV/KhN7bus0Oh7jWyx3brDWNM3FrLvSoJWyeiPu0PE/pF/a8KQu38v+nJKA1OCwwY4tXxDX3KY/W0t9vI8EIZ2h5Bw1vJKfCOnwCg9Ni/9LG5mVk/PTpJxGm/3FQTWxzbcKgZIBseiciYcvyN6qX4dCaBi0Q5fteq5g50+vlWJG9MRgI+FMqYoGxDMuf2BTKhK5kSaTn8I9hGPNlCeWLNIamuoph1AoAxxugTHicfzO5bxJyFY5gj7m2cndbuiPecu8Qy9IJgmNuv/I6AXcVK/iabzTLksCQXAsOwxFrFcV2shFFSQ9HEwfe3
 piAdjrNP
 XaKqP8R8wVRpOooPd9hRqIyGYL/vWAGcY2JFr/s1cykDeNKdht/CYoxVxYbp2wRD1UdU/yAAsQby1xuo/ynoaC3uWB9GcTCSTydTjdp+xFZSFKyKVemoGgwc5pw8J0ElJm6LjUDRVQ1rni3OeKJ6yK7eStlKNVofxW4GG3hTJaAmMfSmoMfHun30RR8qit7Go69JSrKl1VUW94oOyKUSMVhD7GPvS4U6PWHLdw5CZIw+1tdYwaTmApL7lnLGT2UIKbKOaya3pSZGWIa1tz3MBrDh2JsysGQyAE43S6xMWnT7eTez03cchjsk789vlM7fAEQPTL+99j7STegA4pfpYAQuYj8QmquoNhY0WALT6M5jA5l2s4G8eAnTxatwlrW6hNjJcZisFMuZ7ZVtHTCj5WDGixvpzKqdAcAclWoCLg39o2EUaw1lPRr/3uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> skip_empty is only for the shrinker to abort and skip a list that's
> empty or whose cgroup is being deleted.
> 
> For list additions and deletions, the cgroup hierarchy is walked
> upwards until a valid list_lru head is found, or it will fall back to
> the node list. Acquiring the lock won't fail. Remove the NULL checks
> in those callers.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/list_lru.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 26463ae29c64..d96fd50fc9af 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  	struct list_lru_one *l;
>  
>  	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!l)
> -		return false;
>  	if (list_empty(item)) {
>  		list_add_tail(item, &l->list);
>  		/* Set shrinker bit if the first element was added */
> @@ -203,9 +201,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>  {
>  	struct list_lru_node *nlru = &lru->node[nid];
>  	struct list_lru_one *l;
> +
>  	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!l)
> -		return false;
>  	if (!list_empty(item)) {
>  		list_del_init(item);
>  		l->nr_items--;

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

