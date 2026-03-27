Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F7610BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286E46B009B; Fri, 27 Mar 2026 02:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237E06B009D; Fri, 27 Mar 2026 02:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DA66B009E; Fri, 27 Mar 2026 02:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2F3A6B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:22:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 982751A0F41
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:22:09 +0000 (UTC)
X-FDA: 84590847978.07.B0C8A7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F07AB80004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:22:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HuKG1FNm;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUdjINZoNVch6+sOeqy8LWhXDr3ouTjLkLcmKzPKSb8=;
	b=l7DDug3eUCG8MdwnP988r3GkyZ9Ye5xjrTEfcpGsW35tJcfy58ce3AZRO8m2ypkEbErHwe
	1yo9dHiOL8Nz0u2NrNNNPuwnBYImDkuADe0Zg4FSBdgCZtYu+PO/lu7+NFlplQt/XvkTyC
	SN0p9jlPZwqe1jehcq24HIWAmWfG+kE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HuKG1FNm;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592528; a=rsa-sha256;
	cv=none;
	b=tnB1szIRz8HuuPFc1n1SvB0k33JpRKhTcoHECB8F3i7q5lYUoln9VJ/4nNH7yHq9bik77J
	T6kisCl+K+LJMJ8igTt8D3jtpsWRbTe6QJWSxmMDVyUt1nXVYiFswexYXloh9Ze2sPUQQZ
	KgWihaewFIWzWPeUTzoGpU11wu0dHd0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6226861843;
	Fri, 27 Mar 2026 06:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52B8C19423;
	Fri, 27 Mar 2026 06:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774592527;
	bh=aeNmQfb/c67hDWg4rtLcLfHH+y4dTvZgyPlO0jG+7ZE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HuKG1FNmfcGzUE3o6IaHiNv0KbKQCxTODzf5MuiGNIIPwVwUBUWIsr24i4gr9Vqmi
	 tzDviZvVuLQN75ror3J5dROFKbHzbND3QRc78tr+09+oiIna2RMZFuFfK+LJlZ4xi/
	 6oCxcLVz10zVeGX1RAxhfYWs3VG/0RbAgN+9N3ek=
Date: Thu, 26 Mar 2026 23:22:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 teawater <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-unstable v2] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
Message-Id: <20260326232206.4a8a16461527d16ef8c2e8a5@linux-foundation.org>
In-Reply-To: <20260320020745.833792-1-hui.zhu@linux.dev>
References: <20260320020745.833792-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: q9jtk35ijj1ofmyrq9etfrneg9s86nrk
X-Rspamd-Queue-Id: F07AB80004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774592527-845492
X-HE-Meta: U2FsdGVkX19INLQbicV+pwiBWhIG6U8K8H1nv9aPYkFBwdGS93cuLMhL/KqcJvBDGnvUR8P1+acY8fHhcSCZbN0Zk0eO3UdyXycq4lhc/bRkZ7JUqpGBjPmaf/i6CVNdPN91P10dnPBGdmcj1X6cLVztyn229/0+QV3iwfnfneJioCCOtKuvjxDt2VJ3hgVUUWsmflMmo5lwPfUXWvEgobfZ6Kl2MMiHdtwdfCTD575+T6uHHBsnPzz42m9jcVm1H2SIKVI6emonVBav10bcttGB8NibR01B7C8MWsn+6O9Kc4WbZjzHM/QGuIoLQH8jU3FSrzPq6ykrg9A6h7Y3q2A1tlZztioJQKMAL1HdrHKxdAEw/ku5Vkwo0+E8G2SyJ7W/2l59jaH73LD/vcZL+qtddbbPVS566I9ASG6NtrpCVq0lUu3qwEec4GJ7eROhHTkRQ+GaxhARy+tpG5dpN6j0egJ/6q8SZv6cmiddcZRiXQpjtHln5H6M4rRXFkMNY8IGbzMC4GisNX6d8KyCzLK66G9aUj/x5+5cznmwsQ1JQLcDSJFard6j1yuB81P4IOj74aVs8/thZe/mdXQDkgTWobKcxX6YIRuIPb4QoZHh+QL3/l6nK2FKvqEb9ucic6jdWCa6vRwBH0mkHiUbSsKomy95PyqoZUtN3/Yci2EO40f6OhS+Oh7wlxifBBluGyHm1kYS95mxT/zuGFUuuChtExyvzqHT+FJGl5aahLPcmALPKgLVRojidXf12ioU1skY+KMoriQMP0dqdbkphC3qfnToN8UtAOSgULszCWKUlv8sPibwS9cV+xUD4DiYoy8edB1ovhvj8LOYcAy/G+wH5mT4nyDnuAFCGG/qXNXNOZyj6Wq+Oq2ZzZ3bpQxiOBTMRpdx7luGSzafTXqN7vmMHLAj8RfIeh74FCFEywVWjkbAOQKcBGz6g6N+DAXkOKwN0N4AV+JAZGCxUQG
 IIFjZNJA
 Q8UIBtMn9gm3TeGYDrCYvouULjiSqhRxpdFq8pO/4jq9r4G1vCooC673AQOkehOZqCV6N5pDi9Sc/0/X3T3+YZKS3zTWCxeeUD9EazSODLTQ9PMWa+hIjELYDNpRW/Z+1xm8/593z7TS+TYVyTa76SH+8b0Sj+bbJHOJuQ3xPmzrnxYg3jEIshiv6BaQ8uLRyd+cN2jdZ5DO+LqmksQ3QOT/Fns3rrfNMLaCAxvPFcVB5WNkZDrG7Peb+7vuyKVu9PrlLp72jMkfTtk4+BI1HGAF63B+rcgDVHgQA//KC4552PpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 10:07:45 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: teawater <zhuhui@kylinos.cn>

We do prefer real names in Linux commits, please.  Can I rewrite this
patch as From: Hui Zhu <hui.zhu@linux.dev>?

> When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
> hook __memcg_slab_post_alloc_hook() previously charged memcg one object
> at a time, even though consecutive objects may reside on slabs backed by
> the same pgdat node.
> 
> Batch the memcg charging by scanning ahead from the current position to
> find a contiguous run of objects whose slabs share the same pgdat, then
> issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
> the entire run. The per-object obj_ext assignment loop is preserved as-is
> since it cannot be further collapsed.
> 
> This implements the TODO comment left in commit bc730030f956 ("memcg:
> combine slab obj stock charging and accounting").
> 
> The existing error-recovery contract is unchanged: if size == 1 then
> memcg_alloc_abort_single() will free the sole object, and for larger
> bulk allocations kmem_cache_free_bulk() will uncharge any objects that
> were already charged before the failure.
> 
> Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> (iters=100000):
> 
>   bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
>   bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)
> 
> No measurable regression for bulk=1, as expected.

Could memcg maintainers please review this?

Thanks.

