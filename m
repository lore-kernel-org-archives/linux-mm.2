Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E669CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 01:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042D76B008A; Tue, 12 May 2026 21:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A4F6B008C; Tue, 12 May 2026 21:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A046B0092; Tue, 12 May 2026 21:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA06B6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:42:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69793120666
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:42:37 +0000 (UTC)
X-FDA: 84760697154.26.3AE71A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC08440005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:42:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/K5AxpU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778636555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjVfEF00QdJiExfPdpXFLHO+h3t1wyKab1OxwOZYPjU=;
	b=t/aGZcN2L86pmWSOBYWbiAL8NzogFp0XczjYHHjPTySVhGGsH10r/fNGOFeEClzzQdXIbu
	hPUcuRpX0nzckMHQFLtmt6kWyuQkPSQ46NIPsnUPeIseP4A3oH84yP9zvdaLMpiuESnkpv
	ncSoVlyrrYN39knTxs0uF2MRbR1lUy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778636555; a=rsa-sha256;
	cv=none;
	b=rVGho0EgVofQwe2IMf1Q1S76+sVzoKQ1fdOWWTqEh0uw48qrzDjXREWwW9f+3ZXlLcPetn
	z+c+aSnxv1DMXHoNwJV2XNbJAGTEM29pSGpd7qGOEHuiC3H76sUVQWaUZmwL5A+WlgxRdu
	dSScRPmkjjTVkml/Gh+fGRJT7Q6HGdU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="a/K5AxpU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2429760120;
	Wed, 13 May 2026 01:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753FAC2BCFA;
	Wed, 13 May 2026 01:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778636554;
	bh=HthjHhB0D6u8+NyQJ7bO+IK1oh2mtXAmYaHrf3QurKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/K5AxpUXDre3ob0iYRDnr1eaoUgqtSrMA0OnO9BP/KjYxwKoGGZHfXqYshBiBH5D
	 eSv+UwAF/zkFAYsPyM1O7We9ekGU0hmnxbTeIMf5PVQXXW+eGOu7oHLpRCd97ma+bH
	 QwmxCL1/yMFhSIHGHXC7PecDgd4pcmXXkeO/jKpwftMXeDXT+Co+QIbEpz/6pTZoUv
	 n10T2YAVDpbIojInwwPYjSi3Ezz19k+gh2mBSiOZrQ3M936cXOmfbxuX4tQpsepo96
	 LUzrPjSx8voyIYiuOJPx2+7Aq70ECO7ZJkXXPKP10n3I9/OLkI4Qk8cq0Z2ZaAxUhs
	 6s3h+K65ewHnQ==
Date: Wed, 13 May 2026 10:42:32 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Levi Zim <i@kxxt.dev>
Cc: linux-mm@kvack.org, rcu@vger.kernel.org, bpf@vger.kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Amery Hung <ameryhung@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
Message-ID: <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
References: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
 <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC08440005
X-Stat-Signature: 4j7mqedwzopedokrmhq3qf5q4wwx1mqm
X-Rspam-User: 
X-HE-Tag: 1778636555-394406
X-HE-Meta: U2FsdGVkX18urFIG1g8W7Vdc14HhSGx4AvG+3crnlgg6eDyphe2nfFFsfWjFYrUh42//fonlDXLgsXWtxU4anV9deo4fj6dQ73V565N33uR3okFxeeX+G2eZ8CywLzlLE0jzGGsgOE7FOuqA+Hfj+95BwkzsO+dAIh2CXxbDmyErG0NXiDJX69Hz+5UI6NLpktUC9V/FiCLMyVuHkZo271tI3wrC45SdZQjRcn3jh3fakwWWlyDEAAWrWiaHf9WSkF1E5NFlUn+7ZBnysNUhY0phWRGED4h+FPsA7353V9EvR1z6isfGy9KplMMJYXGWR3jLcMaVHgdPuEw2soCZBLGMaf7OUJt4D8LBUu9hjb1tmaH0w22+aiQTUdXiBZs7x6rWDiBBGRkQ3kx4Ld+gvEVV/sWFho2rpo6b3lx+hxpe1tWZ7Y+TLoSElDJJqHLg/DUPakMnzZrlOsV1VutuFN8G8I3k/7gTOMICKVnJmMRI8Aqc8xARFrjSQggN6CFKT5/Gd7YqRJ2/tKa7/Qc9GL30NsIcQeLjXHcAGEiXO1jVP3zENIiS6lrRIEcE1rRau7th3wQbSqLBHncJiLubeptAluKDqFkciL+tRaZjgdKKagAWIIrI/LbZw8gVvLyvX9Cl1uMd/nEgW8o2Eaemfk41J9toPsAwMeO53aEcO6EjxYR2CfhPSEjwK8Ui/VEoV5zfpr8oFHwHfst5gf/wC6lSVm7qIif/fQpCF0ZCjKAZQsNckTS0IE/HjQV4kEYbRf8hWu1x0uT0Vdkhwby8zjWsRmjJZhdEnN6gSLV3akJym99LpBauvq6O2Od44ILOT6BvAojZv7ggAfe91Sngc/AEVcQQVktqUiWSFuqmlhV0otB57orrAwPQDk4IWTTG7APm1W9QDAG7cBmUlq6xi1R2sOZ/EnSTdMOeV31w+CObQMq85NpptPHKHbd8YQxLWLiB3hqoaywkuA+mkh9
 OKZRTiQR
 4hlTIvCoAqh8swG1NSP3NWFeZM80xAb+YLDST044pQC0NrdSV+4GdYnyQyiB+z8a8tsy6s1puElRNsP+2PxlmyV9sTg/WsStfbFK47TSRFVu3qtlNgZPpdqffvEWFnGCO/pU1JRFgQ0CBnN/VHnD86dACQlGho4Yquvhg9MaB/KG4HkKWl1RPwhOnF1HyRgDy3X5juxBUGe8z/cRhM7+IEKA9BqSO8itdzlXfogkuf5A563M/hsaNN4wFnFMHkighG1gA9MDEjlIh4O+FcsweQi1NK/WyUytvyqueLTPCxvZ8UwPn+8PpRUwwVr8WwOUUCiEMKy8woPl8Ii1q8MEORBHuHeBPTnA+8Sbwm1QbrvqAEr3OgIYLpzZ1Lx+oJo56L9utO+P+kZottQqEOrjCGwoEKloCgJJrb0+sQI5zYbaBaGC02+Ceed020A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 09:46:33PM +0800, Levi Zim wrote:
> On 5/12/26 8:25 PM, Harry Yoo (Oracle) wrote:
> > Hello everybody. This is a follow-up discussion of
> > "kmalloc_nolock() follow-ups, including kfree_rcu_nolock()" topic at
> > LSFMMBPF 2026 last week. Unfortunately, many RCU folks were not there,
> > but we can still discuss over email ;)
> > 
> > The slides: https://docs.google.com/presentation/d/1kpaLd7D1dwRvIqRwQfSjJVVJL0CC2gwb-AV56yCMqXw/edit?usp=sharing
> > 
> > I'm copying the slides here to make it easier to reply.

[...]

> > The end goal
> > ============
> > 
> > - Drop the BPF memory allocator
> > - Avoid preallocation as much as possible in BPF
> > - Use kmalloc_nolock() and kfree_{,rcu_}nolock() (and friends) instead
> 
> By using kmalloc_nolock, a regression happens on architectures without HAVE_CMPXCHG_DOUBLE.
> For reference, currently only x86, arm64, s390 and loongarch selects HAVE_CMPXCHG_DOUBLE
>
> For example, this has already caused bpf_task_storage_get with flag
> BPF_LOCAL_STORAGE_GET_F_CREATE to always fail on riscv64 6.19 kernel.

Ouch.

> I attempted to fix it in https://lists.infradead.org/pipermail/linux-riscv/2026-March/087159.html,
> but as pointed out in the threads, the approach is not sound.
> 
> After that, I thought about using the BPF memory allocator instead of kmalloc_nolock on such
> architectures to fix it. But I haven't got time to implement it.

Oh please, let's not go in that direction :)

> I don't know how could we fix it otherwise after removing BPF memory allocator completely.
> Could we find a path to move forward without causing regressions on architectures without HAVE_CMPXCHG_DOUBLE?

Probably we can. Could you please see if this works for you?

https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=slab-kmalloc-nolock-without-cmpxchg-double-rfc-v1r1-wip

-- 
Cheers,
Harry / Hyeonggon

