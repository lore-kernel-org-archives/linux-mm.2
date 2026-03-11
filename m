Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235A6112583A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3CFD6B0005; Wed, 11 Mar 2026 10:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE42E6B0089; Wed, 11 Mar 2026 10:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0336B008A; Wed, 11 Mar 2026 10:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC0DF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:46:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50A638961D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:46:29 +0000 (UTC)
X-FDA: 84534058098.08.DAD2E9E
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4A61A40007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:46:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EV3Nv7B3;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773240387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lqxt3+98LXnQUiUM1k9vne7JM+5GQLArojh167aHDjw=;
	b=ukaunXukdbyJ4PMleEwjgmvEaDMUuqswhmec2MJzor11qZX0ncTiSjplyYcgNEnqSpKIRj
	pI7DO2axjj6OKdBlhR9i2aKaTKnm4JocUnZgFUyUywqMaKTht5KRs9PNhRdlJoO9rI0Uad
	3CqM2fumidaFsfn8wZTk1o7WQJ6Ymc0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EV3Nv7B3;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773240387; a=rsa-sha256;
	cv=none;
	b=T+J2Orx8jZj7T8YO7MavnwFzLvgQ9qyVk/RkpJFOPfKPl0E7hu9pv48F4yHvnkM6pxmOD/
	U03CAXtE711/ep9NIL48e8oaal2T8LlV6t3/cCn94RjtDTWkpnhxKfLETyfcX0R513PFwX
	QV/5a8HfDufRMz1QD08tU2pT/vv6Nds=
Date: Wed, 11 Mar 2026 22:45:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773240383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lqxt3+98LXnQUiUM1k9vne7JM+5GQLArojh167aHDjw=;
	b=EV3Nv7B3dDh/w/HQscqjSxzv0UlCDHy3aGkKU38zdQhrRUOiy3D32xyWQurdEp0iMzButd
	i1IT4RFemLDY8rgxNVXtgCoNyNF8RyH4eS2lWFG06J2wFdtqKANSxnd8Nk+pKyCaGN0eBh
	CryR7pE59n51UlwDBL+S4wjD9+6Q34Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Qing Wang <wangqing7171@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <thhmlnu6phtuucz7jo3xoqeiv64rs4ynkt63qoxvtwgfh3aofw@lo75dus27vyk>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311093617.4155965-1-wangqing7171@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4A61A40007
X-Stat-Signature: hznaqsjx6ngcwepe8cpwkmwobmzr1mjq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773240386-640812
X-HE-Meta: U2FsdGVkX18v2RfhbWaFgPH3bOoputD+6YBnrBXs3lx6pT/QtaLQavmEyQUOL0VESbunY1c8EAVD3fRA1s47YnUpJwwL56/5a+y55cQQ6ZSqaXz/P7QmD0nGqHbArCYTUbgNCbFdnD9SYJ7SuLapC8YfvaBV4WBCiG19+GfzN/XSk/ExCM4phJzbplNOpIwg3R9FWAVmRRAQJslMSh8SnvwFTuX5p93pbIhMuA4pSfBj9C1TAXlzE2bTlWIsZcNNWqrFHx0CgmJKqg9/K/LgC72yRRux6xPnuXE9Mmt+8qUrtfkYMea1+L2c1y6Drwed8Et9+lxbNj1k7k8XeL/q3vZ5JQa9mv5rvW66HFG9iuUtwzYHYtNe6/BXiEA9gA7vU/9mxwtStaUu/jeoWfDc1pWjuE3C3SJePly1dcsCV0Gi6qlDFOqCNqTUlCNOrTMFgbMEWi1FnuP0Ntmq7pnQa4aDQKm980eb1Zp4v9xtY08St9pSWjhRXSzqly3Ok0sLyZetlBKtAPnwiLhau49/Q0LV8EIcRLQ9Kjm3V8iSJhV4pWh5LgG6IqL2cpLDk7ySqo9rnFgbDKHdIdVRdplcin9tp40amTWOMYSQkG5zsa80iLY+vapPb3aDnU3o8+EZYcgyoMQmmAFUaThLsST3a0eRn160T+SHIEDVjBP+vD3WfE9IDbvSnxqn8RPnMUrYLFQW/gCwx3eH8ZMH7tAQvheWolpKc/h0ZVZD2XapnNmtb1dZLq5+BU4N/QcSVXqasr21mOvT9WvKAGI1GhMN9SKC4F9s0/lvcKRmNvLO7rWKb9vTEuVvp3PfFfrrgoIytHOH1n2HHHEKMj/vNSM1RXErBqMds7gSI9BqXNDq1/sSQBBj2tI1I29m9iVYQfr3yMj2Y8sCQ3kQAFdRjOy/tZjOh1ydVjj6ALdj7TZgY12DImF8E3icHG9Wino3X5SDEwcfl2hakjUCXVDGXxd
 8mag1MJw
 VirJmvu+wV8VEeCbPvCi8yTigknOablWBjm7j9hyxo9my03OiYqoXvKLO2XvUKCUBKqZVbkdLNEEpzNYGO/6AigCXmTBuVDtKSTNe6eTOcM67GcxEfmQCLK7sTpYe4zB13EkQ78zcnyz6aj2YJfmLLzgRpb6HozAFBN8dTBq1mN9XrDCU8c3PanL+HD2/iVLpuWRimJAioAqA8Md3KXP4/B6G3G4NgePHSw7VeqdeA+PO1ZYIKSByz2yg9qQtlpE21mqk1Cq/qNwgj6ZhQtyew5M24Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:36:17PM +0800, Qing Wang wrote:
> When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
> but need to fill 10), it will update sheaf->size and return -ENOMEM.
> However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
> directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
> causing the partially allocated objects memory in sheaf->objects[] leaked.
> 
> Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
> free objects of sheaf->objects[]. And also add a WARN_ON() in
> free_empty_sheaf() to catch any future cases where a non-empty sheaf is
> being freed.
> 
> Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---

This fix looks good to me.
So feel free to add:

Reviewed-by: Hao Li <hao.li@linux.dev>

I also want to bring up another point here, although it may be outside the
scope of the current fix.

When I looked into the refill_sheaf() path, I found a refill failure does not
guarantee that the sheaf remains intact: refill_sheaf() can partially fill the
sheaf before failing. This non-intact behavior propagates to its caller,
__prefill_sheaf_pfmemalloc(), which therefore also cannot assume that the sheaf
is still intact after a refill failure.

However, the comment for kmem_cache_refill_sheaf() says that "if the refill
fails (returning -ENOMEM), the existing sheaf is left intact." That means the
behavior of __prefill_sheaf_pfmemalloc() - where the sheaf may be left
partially filled on refill failure - contradicts the API contract of
kmem_cache_refill_sheaf().

Maybe we can add rollback logic to __prefill_sheaf_pfmemalloc() so that it
provides intact semantics, preventing the non-intact behavior of refill_sheaf()
from propagating up to kmem_cache_refill_sheaf().

-- 
Thanks,
Hao

