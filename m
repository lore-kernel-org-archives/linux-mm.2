Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C783C10AB803
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025FF6B0088; Thu, 26 Mar 2026 14:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F198B6B0089; Thu, 26 Mar 2026 14:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F106B008A; Thu, 26 Mar 2026 14:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE0D26B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:50:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84C021B92FD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:50:04 +0000 (UTC)
X-FDA: 84589103928.15.A336B43
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70EC5100004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:50:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ocb5rEa4;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774551003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfFEqSk7MC3gXpsizNtYg3OJej5GD4C2LciSFQWJMH4=;
	b=qe81gk6Iuf++fj4wLq+fa2SU+oDMSf8trRYc3fZtkxIjmYEQZ8sQ8Llt96vvT+dpnKqWZe
	l4qmImpDqGijUb0qc1agZlmwjlNetFAzdVov5VPvHzUiiXUVnzmMevv2Rsqqbe6tBEO8kl
	HJS76TWoDRHmtdDeTT+E1fEM9j+wE1Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ocb5rEa4;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774551003; a=rsa-sha256;
	cv=none;
	b=gyvIeVEL75yOeu0VpRchehRwws1rN+itwJCMIIPzbpJOl5qHh/cL7oko0OTgIprwrxec8r
	J5wkOoxq620Kk8f9sNEQoZqyWJBS9+lN65A96VwVcdUKS8cCV6JI2OfQfs8bvSvlfMrExt
	kNJONcyqNOhwIOrRrlqC/XUewJHWqnw=
Date: Thu, 26 Mar 2026 11:49:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774550999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hfFEqSk7MC3gXpsizNtYg3OJej5GD4C2LciSFQWJMH4=;
	b=ocb5rEa4Vhf7dQDm6mOVJ7Q5U9qVntdAcRctK9BW1rf/KGQ9xL1MKFqhwDKXRm7T/yMipq
	G4ymDDV5NeiDv9zIsQf4PInLagFK3TFtd0xlCoWwJuX9ijYGmOogJMLoTFPqS8vD/3azmp
	zePXiGS6hiJn10PTMsJnKraFH8fsipo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acV5d7D7wsoN2aa4@linux.dev>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 70EC5100004
X-Stat-Signature: 6344shidfrrt9p1xy8yt1q7xo3fd9ftu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774551002-838819
X-HE-Meta: U2FsdGVkX1+vJp/vIcxdIsaQyVMqE6/sSDPrVtiRkYr0FYdInosJuTsjs5d3rQgdmCKYuYviNPHsfbIMtbk4p8Loq/VmMNck7p3QWfHnxXHmQsUwF9IiIS9d8/rC3YG+/TcLy5HmKNbt6CqvJKcNgdOTgneVAkpYAb8/MLTcoZDzgQid2cqYjhLxNQKTKznalBrXn5/9AIuwKx0OuGAem80OfUqE1iwAaf+GLpZvkrn1UoY270Sk2QmauYLSMtz4Qbv8IeAWSzPBRhWT1GjiEa7P7KCmMFD2vXk27cstFOjq33X18wIJFD972e4QGD/kfiFcgif0h/INfAvhtxOGwuqnNqvKcmjHTdOZgifE/vKEoa+mmPmMEtiQ8yuV3ThMrP7vNit4gM15AAt16aPAh7e6+ARqfo3PSZFN6xRa975eR/4SNOer19pZMKDNxYUqqUPm6kLaK23cCb1aCGrAMUmjzIh04ZHh7ckmVD7QjqiPXp30PBnmQV8/GSaX8pFt/EF1VYz/Dj+3zCNZMcq4hK3plfpjwKtwD9EXGcKdtOFDsdZ8nJih1EavfGGRo/quTIfEWe9V41q8w/YO2IFnoiCRhDz7HBLmoTpmP7Ys//Jf5dfEkbyPEFGq1D11IUg7YnKPZg5IXZjQEKTz97rXX86K78ElDVc+mH1bIkuC0w6VvaKcjOb3uVoZTSYrTLbmook4PGPNQR+G0JqqQA6YrqWR0wXhvv7AMjKtIrMGFzwtXJiwGq73FaIr3Ah+jAPZLigi4F6VB93SS2LXzzCkfMSBk6vz3GiT/DKyqXylWsKFhw7l+NjqCa6S6Ef4A741mOjtbHMSMGuzwfUcTa4J1MaxxUcdxsw8Ta9X0LpP6U2yEFjn+HOm73hqSon5hCHCL/Kq8aDXwVk8dIO6QKQVSi9Cm2NJOQ8pU27tXc04LFy0N3AbBKypBVLTZYFvnFsDtem+SzLvW6S8grmJUTy
 ko3fvs4/
 3N7Yorb+uSuNUqWpEXOUXqe/Q87vDPoNpXaFKY1wggH75t+Ag0ObDKuOM0oxdx+5/M7dcBwXQgGjndP2lq6S1TyPrYsOJ7wSUVE9GTEdp2sfcXWr+b73AC7tsrYjsShnAKqp1ekD3BSSM6rHXjOQDNJ9BvLZZ2pY6ihPJI8m/3QpwY4iHpo7Po3rbIqOI2jsyRB69OJPNuPo0+7JHT/QI0m4NfFQQalekE0GYSCgrBA+RhmE6b6P9piXNayPKYRwgY0sb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:43:46AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 25, 2026 at 02:06:37PM -0700, Shakeel Butt wrote:
[...]
> >
> > The Fix: One Reclaim, Pluggable and Extensible
> > -----------------------------------------------
> >
> > We need one reclaim system, not two. One code path that everyone
> > maintains, everyone tests, and everyone benefits from. But it needs to
> > be pluggable as there will always be cases where someone wants some
> > customization for their specialized workload or wants to explore some
> > new techniques/ideas, and we do not want to get into the current mess
> > again.
> 
> OK so I was with you up until the pluggable bit :) it's like you're
> combining two things here, obviously - unification and pluggability.
> 
> I think we should consider both separately.

Yes, I should be more explicit that these are two different steps. First
unification and then provide a framework for extensibility.

[...]

> 
> > New ideas get implemented as new policies, not as 3,000-line forks. Good
> > mechanisms from MGLRU (page table scanning, Bloom filters, lookaround)
> > become shared infrastructure available to any policy. And if someone
> > comes up with a better eviction algorithm tomorrow, they plug it in
> > without touching the core.
> >
> > Making reclaim pluggable implies we define it as a set of function
> > methods (let's call them reclaim_ops) hooking into a stable codebase we
> > rarely modify. We then have two big questions to answer: how do these
> > reclaim ops look, and how do we move the existing code to the new model?
> 
> Hmm, I'm not so sure about that. But it depends really on who has access to
> these operations.
> 
> The issue with operations in general is that they eliminate the possibility
> of the general code being able to make assumptions about what's happening.
> 
> For instance, the .mmap f_op callback meant that we had to account for any
> possible thing being done by a driver. You couldn't make assumptions about
> vma state, page table state, etc. and of course things happened that we
> didn't anticipate, leading to bugs.
> 
> So I guess it's less 'no ops' more so 'what do we actually expose to the
> ops', 'what assumptions do we bake in about how the ops are used' and very
> importantly - 'who gets to populate them'.
> 
> If they're _exclusively_ mm-internal then that's fine.
> 
> Reclaim is a _very_ _very_ sensitive part of mm. At the point it's being
> activated you may be under extreme memory pressure, so a hook even
> allocating at all may either fail or enter infinite loops.
> 
> We are also very sensitive on things like rmap locks and also, of course, -
> timing.
> 
> It's not just a perf concern, if we are too slow, we might end up thrashing
> when we could otherwise not have.
> 
> Also there ends up being a question of how much now-internal functionality
> we end up exposing to users.
> 
> So we really need a good definition of who we intend should use this stuff,
> and how any such interface should be designed.
> 
> I mean, if sufficiently abstracted, and with very carefully restricted
> constrainst perhaps we could work around a lot of this but we have to tread
> _very_ carefully here.

Good points and I think we are still at the early stage of defining what
operations these would be. One of the complain during MGLRU upstream effort was
that the traditional LRU is too rigid and is very hard to experiment new ideas.
I want to eliminate such future complains. If you want to experiment some new
algorithm or new heuristic, experiment using the new framework.

I think once we start unifying the reclaim mechanisms, these operations will
start becoming more clear.

