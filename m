Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1305FF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0620D6B0005; Tue,  7 Apr 2026 13:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0393A6B0089; Tue,  7 Apr 2026 13:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8386B008A; Tue,  7 Apr 2026 13:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAA7C6B0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:31:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 429F214092D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:31:07 +0000 (UTC)
X-FDA: 84632450574.13.B54CAB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 82D871C0007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:31:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvMycR5S;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775583065; a=rsa-sha256;
	cv=none;
	b=e5ybOI9MxPMiD3n2xwNc8YaQhjl+Yu0/3zbbsdA8dK6qK+l/9RrGy0CTuTABTwwLpD8j91
	jQoUjaneHYkMheRnoNA7yMj6ZNgL/b0tfBTn8JUMT2Vi33Uu1w4qzkxHznEGhH3GiMV3Qq
	2H7hy60aro8S14yMak1QiUglloxR2ps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775583065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XjU7ixAHBBgp26Ic13sErTcuyUYjU6EtWtjDnf5xNI=;
	b=T4bkDjnTDcXAJ275O7CcNCVJNix3fIDOkcmKAxF1ImzcypYeXU/lC2Liewb476T9TUYmaN
	ABQZZ6PV6IeQ7d7cWDbxYJrTsM2RY2/cSjjLbgSyWm8UrMjRoFqyaY4lt0dtCO6Kv0zzNS
	ZhpFzDU9edaGll1OFjeRzkNFooLATMo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HvMycR5S;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D37744070;
	Tue,  7 Apr 2026 17:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC102C116C6;
	Tue,  7 Apr 2026 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775583064;
	bh=9UAvXMMrNqXTrDUMWeRlzPfgVWlg1yCmofk6uQ4sAWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HvMycR5SUvIjTLAwEDuh8RGK4jHzG3y00DReobjmFlfJ34ND91by7Bwk7Xe2BYw7Z
	 R17BPs8mIv4KgALr90d0mvREbxORfIklhY16OBwEVD/0TQ/IbDslpE/VMYb2DWbJx1
	 9YuXDwU/GiZQSOs7RUTWCWDhcrHFF4PdDgqbF2zn9gusDlWS9A2CH5u7qy7gh6SsZ9
	 LXiJUhcyRJmUhMy8SmoeQzYKw2AJwLAHkRmfvBio2x4r6vfywzfm99Q2EbYo1is2ZS
	 s7X0nGgGH2T34KJ/ehg96b+5DXj0hp+DnDyEi94lQlANXzE0slw4jrOlgOzXVnJKKQ
	 2ohrkEKfSnbuQ==
Date: Tue, 7 Apr 2026 18:30:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <adU8VnzlLw9JUHB3@lucifer>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
 <acbgIKuwDsPvPjdF@cmpxchg.org>
 <adTonuzmUc2AzUhp@lucifer>
 <adU3P9fk8h-AmEp4@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adU3P9fk8h-AmEp4@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82D871C0007
X-Stat-Signature: 6gesmhrugz76b841stdmejpqbccaw6r8
X-HE-Tag: 1775583065-790514
X-HE-Meta: U2FsdGVkX18RWM/3QHlYnu3bwLoDNpHkvb5J/+bd2Sjmel1eUYnKNFUJjS008UfirnxEccGOjBqRo9CPg15XBsaE38f+3AmejI91kwkJDB44+bMWNzNcdvQFMu+LdJUrOn89wYhTd5nGBaOSCL9ihq55l//bnVGkjdZplrsKuEb5pE0caJNJwcHl28/zP+sS/mIxayF6Q8ldlwMzzdXGzwkgMvtEMo0xd9Lf/qWIYZAitWUGBOwm7nwwwJeJbqPjqkM0cCpI9ki10zC/Gl9VQTR5UHd84Ol4CcVYLmjoCiHnbLHBi3m1kvxKAB7ZeYeSa3RUorJpbxEqDrHYsHVmwJsIWYnBmqGeZF4ZHy+jzU98x2ax3eXwnDmlN+lZfsS84sHd3ZXqQWqoUWlRxV4gGBtYRD007LIwUMcdbGqMHJeTzkp4Inolh+n28uA3LW92YJAn/+EFz9EcMo/LeGw7orE1Z02dDLoZdmBlIaEWcg38GxyTVi9Uf5VkpnG74eFv1leGhc7isXO301PJgHyq9z6kckX5RtQuhTrnGgG/GJzzxsxCm0Xfl5tRcDbnMPGHJYP6QXjMtFfdfrDVyGqLGzEqWHVp8tb52ykTgqIXTI30SE32d+Hnq5LIYzTfjzGOU8aGLF1FyKr4ysW92cD4R9ZizzWJptgbGcjGbO7v4XzPFawKCjuGMF2rK4M73BvGEgWWznpqXR+JiXgxDns6rNb7l/czoMi81MtwXf6x2vsRpEo+TLbUAFCic9OmBgqsKgtm02cubEh9JSZUI4sXl6WenwJHKUaK2CqEscbJmbDDZtTmvzJtvBiNaoJ0c8xiN3PtGx6gkPHhuOEAVndPx8oIGZ4tUHWQhjX2Gx290F+n1MbX74wLHNWDgHC5Apot+fJUak1Y8V0aVaiumW9TpdSSxIgjY1RoRnl3Mz1frnBKo0vW+YGf09VBuOPSSLzYCHvaQXH/mE5O6oUlYFH
 e8JkROLP
 332zllafePZFoAJTRy2LTbHAO0JeU+1rGkVfxF4j1CKpjAA+xOJxy+XfTSSNRLmjjEjUmOS4kFIKF4+60YXq+d6FrlIl0ZoEd8gVA5U47G3V6KQkp5CFVKjbpWbjZSAGV8neOsGBXT4C56UuA6YOW3+vivD6HOOjh1rgdjRZbsLl6fclVTxZ4hydsGx5ZBhY8sZQPkuiDmOd+kdnk2ekLCpK5mN86t6fomOJs4RTKiwctOYOj2XGTD2YCnnfbiUZA0Qc5Ua9sZ39S2oE1+h0UQs3UnGaZ4RoRp9TTuDOotERcvL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 12:56:31PM -0400, Gregory Price wrote:
> On Tue, Apr 07, 2026 at 12:36:36PM +0100, Lorenzo Stoakes wrote:
> > >
> > > And the current code structure makes it difficult to whittle down the
> > > differences methodically.
> > >
> > > IMO modularization is the best path forward. Giving people the ability
> > > to experiment with a la carte combinations of features would make it
> > > much easier to actually production test and prove individual ideas.
> >
>
> ...
>
> >
> > In a possibly, fantasy ideal world scenario *puffs on dream pipe*, it'd be
> > amazing to somehow isolate the reclaim code in such a way that we could
> > instrument it for testing purposes.
> >
> > E.g. if it could be invoked from userland, or UML, or _something_ and then
> > faked out to have a certain configuration of X NUMA nodes and Y GB of RAM
> > with Z processes competing with total observability of what's happening in
> > the algorithm that could allow for really robust controllable testing and
> > regression tests, as well as possibly some form of fuzzing for broken
> > reclaim scenarios.
> >
> > *Puts dream pipe down*
>
> *picks up the pipe*
>
> At risk of being shot - this kind of stubbing / functional testing is

*nukes entire site from orbit, it's the only way to be sure*

> somewhat trivial work these days via <pick your favorite LLM> with
> reasonably well designed interfaces.

Though to be honest, I did ask Claude to do this with some code before and was
really impressed with how quickly it came up with something.

Buuut I've generally found the code LLMs produce... terrible? Really terrible?
So I think you'd want there to be some level of human improvement there.

And in any case, maybe doing things this way will struggle to really represent
real world cases (lock contention etc.) but OTOH, being able to simulate a high
memory pressure environment with certain parameters even without [the rest of
the kernel] interacting might still be super super useful for diagnosing issues.x

>
>    ( read: probably not with the current api n_n;; ).

*gasp*! But yeah, also yes.

>
> So to get there, we'd need to agree on the refactor work and interfaces
> that make it possible to model the scenarios outside a running kernel.
>
> If we do actually want to move the core to look like:
>   - vmscan.c  : core library
>   - lru.c     : standard lru
>   - mglru.c   : mglru
>
> Might as well consider the functional testing question as well as we
> decide what those interfaces look like anyway.

Yes, adding unit-level tests would be hugely useful.

>
> *throws the pipe into the bikeshed*

*Dives in bikeshed to rescue*

>
> ~Gregory

Cheers, Lorenzo

