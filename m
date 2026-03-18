Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF72FCD0A1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 03:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5506B00DF; Tue, 17 Mar 2026 23:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD626B00E1; Tue, 17 Mar 2026 23:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9E46B00E2; Tue, 17 Mar 2026 23:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB9C6B00DF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:54:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2459140514
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:54:23 +0000 (UTC)
X-FDA: 84557816406.06.FC8FE72
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8DA30C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:54:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b3YYwuWX;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773806061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+WGZrU/DRb/8XeHXR/FFoErm1oycPqp2GvNyARcRqs=;
	b=lORnX5lRnhX0ZVcc/XKGN7hDDbcxaoQCwEpST986JMSqqp7MJoq7zkHYwTRjDE1oG0ezM6
	TIiR2kgTGzcQlMQCvLpfg98N9SYWLLn3Sn47sdllzJbXQKxaWckHM5g0PjugvL3WnM+tHq
	sWVktaTHMRV4kDuGQCsESz1ZJVj54fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773806061; a=rsa-sha256;
	cv=none;
	b=m4/gsOS6iK2UMIKBP5190HcSacNVWe9hk3pQtY+pJYQY012ovLec0+hKVw4KpabN+v8AeP
	n9ak9Gpbu8NNjUNsIxkXpZamAIlILBVs8YhIfIsXxL1Of2EucQSd0y9BUvvWviYl5Jb8IY
	bQWTadrVi/DkkkwQvylK0dtiQmL1FDQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b3YYwuWX;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 17 Mar 2026 20:54:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773806057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D+WGZrU/DRb/8XeHXR/FFoErm1oycPqp2GvNyARcRqs=;
	b=b3YYwuWXAhetgcUmgQveGxcELliMiAg+KJK1jmkgFjlWjTfHolPjyxXchRmOLhFMjPgTII
	9gDp3lM2GCPZRhWoGWsolV5wzW/Stx0r5VDwFaVmLd+PiGMvRwG/IN5c28Aw0DOijIF7Ma
	mjG/dFyf/nipPm1fWuN1Xx+XI7Mt5AE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <abofwUe6Lz_Qap1x@linux.dev>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <20260221163043.GA35350@shakeel.butt@linux.dev>
 <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
 <aaXM58EsMtbGri2B@linux.dev>
 <aafe6VXoCLlajp8b@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aafe6VXoCLlajp8b@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DA30C000A
X-Stat-Signature: 95yx5r4z84w7k466euw5mjfnx61qtdzf
X-Rspam-User: 
X-HE-Tag: 1773806061-959644
X-HE-Meta: U2FsdGVkX18hN7jrAFqFzq3RSoEm0nvQK00juNb+VCI0KfhDsUtH8x2e9aPQeWSCCKs60EVe6TTTjeQczp/FRghoi5fzecUxXyaYgZ8Eq2/qHh56NpiTi+NKM6PTuZzRZj0BkxihMsMgi0onU4YtJmJlTVvDvHowiPgqGEVxYzGyn8cLhvDf2YKx2hGBEKAAy8HiDQ5nmQRnr/1L2Cvt69ifUVJcyvNg8WD5bmWiSQAzDbXCsc/p04LT3sKKy14DEFAFpICi4rPWHIwmv0HY7BLrR39HUtXb/LSxLcHgE8d0BKpTye72MVqF0x0i3opwIifE4ub+RuQvHMVlpmv5Qs6OpLg/2d3SpQ1qNvk31rq9s0lt3/N+4zBEyEHMsrr4BGp0CQWHMw9ZfjtqS9l0A/B5VyyPhNvdZsI+NsZHigcOJ5RR9rRMIQxHz3fHzfZOlAH+HjtRhtO1Eshzm50c1O6M8AEwG1+mudQDM5udWw+4kwb+pP4AIR2MzG35aYEqwhYipi2k5XQb8Jg/47jMFgmgV4YKlOqCB4ctx+76G1lZ0FMC6SrD4EvQ4BHoi5SrnoFfAQOFvRQJTjgk9/J7I6EDK+XE1jWcWG81Isky3VwQnqtM+SGIzzad2LW2vbOdmbCoSblBliDgtoZjePzbhB3VBBfQMUetRfAQmB9UCeVeTej9UoudBFU1cO3+mn2FhWXv+SpftvJ3GNIlCD3sD8a/YyYWAaJ2Wou9cyTcGggpJXEyQD1Hs97vpe7yJZrObsMkVGTEOWs63yDc68noKdh6cKTKQ7CU4x8xdKrOUsBYjr2Os/rYyO7kB9mXYG4ADjrEUZVl1BGNOtQxl5KZOn++Y143TZLLAI80u6ry3ft7ecpBpM7DJ/sSDwBRV2Kw0komIpQNJThKKyBEkmkcgp2iJxkne0KI7NYSze5l1l2vjRJWoBwAkNCcNs9z5SWBGTiTN/FMt2WVY8Y85Dx
 MXgzEX8z
 w3uPyuKCtXrnMoMcxYFOQMgyZN4DBvV1sUbzPnOQFoTmpIvNtNGy7jCkDE0tkM+yMhbMEksYRnYQ+Vu/3JNGwCScY3CHyDvAoiwS08Wze3idBeJ5W7dAguvp5x6zGYNx39THfryp6nyP4PFemPehmmC4A0/5nAyrbQ5qW+v/oHXcWhsluX5Cd/OIKWWyNw7xgwm7MrA+PFY1oxjeMYsqhkXI05HCL7UCzshmndHOv3jLu9cDAqtlfJ9AWvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi YoungJun, sorry for the late response.

On Wed, Mar 04, 2026 at 04:27:37PM +0900, YoungJun Park wrote:
[...]
> > > - You already acknowledged the use-case for assigning
> > >   different swap devices to different workloads. Your
> > >   objection is specifically about hierarchical parent-child
> > >   partitioning. If the interface enforced uniform policy
> > >   within a subtree, would that be acceptable?
> >
> > Let's start with that or maybe comeup with concrete examples on how that would
> > look like.
> 
> So, just to clarify, are you open to discussing this restricted direction?

I am open to all options. The only thing I am looking for is we have thought
through the pros and cons of all the options and have thought about
extensibility of the interface.

> 
> To reiterate, this would mean enforcing a uniform policy for all children
> within a memcg where the swap tier is configured.

Give me an example on how this would look like.

> 
> For our use case, this is currently sufficient.
> 
> We deal with memcg's tree itself as one workload. 
> This workload can use its specific swap device selectively.
> This is my view.
> 
> Chris, would you be okay with proceeding in this direction as a starting point?
> 
> > Beside, give a bit more thought on potential future features e.g. demotion and
> > reason about how you would incorporate those features.
> 
> Regarding demotion (assuming you refer to migration based on swap device
> tiers), I don't foresee issues if we apply tiered swap devices per memcg.
> 
> In fact, the 'tier' concept was proposed specifically as an abstraction layer
> to structure hierarchical swap devices. Since the current direction treats it
> as a unified tier view configured by the parent memcg, features like demotion
> should fit naturally.
> 
> Regarding future extensibility, I would like to add:
> 
> 1. From the memcg perspective:
> Applying memcg in this restricted manner minimizes complexity. While future
> expansions (such as complex tier inheritance rules or handling setting
> differences between parent and child) will require careful discussion, the
> restricted approach avoids immediate conflicts and side effects.
> 
> 2. The swap tier abstraction itself:
> The introduction of swap tiers primarily enables swap device assignment.
> However, this abstraction also opens the door for extended use cases such as
> inter-tier migration (demotion), round-robin policies between tiers, tier-based
> VMA swap, or even per-process swap controls in the future.

These are good examples. Just show how the proposed interface will be good for
such features. No need to implement any such feature.


