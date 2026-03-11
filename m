Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1EA103E2E4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42F06B0005; Wed, 11 Mar 2026 17:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED016B0089; Wed, 11 Mar 2026 17:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF876B008A; Wed, 11 Mar 2026 17:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E28E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:36:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FF78B9383
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:36:23 +0000 (UTC)
X-FDA: 84535091046.10.707CF3E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 97C3020002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:36:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTIWSTrJ;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773264981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Telfpf5ptlGpB/om4pC5uPZFX+x6oNBegoretK0UrkE=;
	b=Q0M3s/zZF7/thhbVIbn2+MhLe40MMoZsNsCFwf5y9/N8VpoRcRk8sLTYB43xMwhF3IliwN
	obADqEh1bhNmhdTFEhUYpvrvg/dHz7k2aTctoXeGKmddlGWM1pXtnczBB9X3mgJ1PmFNK5
	iduTuYF3zjAFxJmnvCaurlx6mZYG8ng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773264981; a=rsa-sha256;
	cv=none;
	b=NRIqCnljt+8Cca+roAMYoh7CWSY0xtIjYC+JUkdZqqPoAKC+0Hicf/7qR+BeyBlpOHazHU
	KXg6c7YihEIV6DNSBGIBeMb7GghykWjo/zGKkgYjZFmwhNzeT3duskFa3lbGof7icROiel
	rRT8owZBTaWsFDBNoQDhm7ffefaAGhg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WTIWSTrJ;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 11 Mar 2026 14:35:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773264975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Telfpf5ptlGpB/om4pC5uPZFX+x6oNBegoretK0UrkE=;
	b=WTIWSTrJNE/IH8KAHN4q6P27nFGK3ez/6AduhtafzWVM2kHwhzgvWyg3lqR4of8XKkrgfW
	m8ZXwdWVbuDEouJn7z57FXHM0Opn/jUXqzyxQkSBC1o0LeZRCQaovR0fruTt9ZtvQXY8JG
	yfdxyedVzx8yQu1uB/i8i2YiG4TwzV0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Thelen <gthelen@google.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, Emil Tsalapatis <emil@etsalapatis.com>, 
	David Rientjes <rientjes@google.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abHWslV0KmjF7x80@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <CAHH2K0ZBJV1peAZVZC9Lm=rFRzSfxsvbrxRjyB=+0xkHGRcdLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHH2K0ZBJV1peAZVZC9Lm=rFRzSfxsvbrxRjyB=+0xkHGRcdLA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97C3020002
X-Stat-Signature: cmgx3ejdy5f6usafqkaa9hdemsqjb58m
X-HE-Tag: 1773264979-145522
X-HE-Meta: U2FsdGVkX18ni2T+v5saDLYdYRShudkHmVNcCZw52lyzAnlrjq9RZs1J1QeES95Irim2UMXo+QgBKjEEZ238XPNfX1zbD+EGCYaNpMkgkdtKSW8qijgn+pq0DzQu7nK2zvCoue6Y9IW4ZQiMwzuZPYBfOWQjKKaKzIeOeKs5xHwt2krFnaVwZCQgwvxe4wuyrd8UKTaO9EH9qXKICKzxK6kxPT271HU84Eeqh4MmSklV5ThYnmCVtR1BvQTSWVWPjjVVvTT7RwlVm1rYmPFElKoPK7Zj3Y5T2oSLTiD/G9+is9Ucl+mMoK74zDt4JdM+sEsBbtApdFCh3TL99RnNbEvwbPFL/qlxFB71TRuDufVrWSawRdhUTUgddAYdTgCvXugxwJ9pL1EzauTdq2+8nlEU+GeaFNQA5yjA26lUdLexXfyAcX4zEcUewkvNptTMYRIF5C5yf4Ilom6iIMMBK0I4oc7ZCoF6zAEhtJEZxhG7TsB0HbBq9EZUApHYUC8xQLi+GiaBqgM2IiHOhSIJfNtYHx+G+Rsattstemnm5PgBx9R+owntgY1QJvt21QuMgKbpgLgYIF9Kd+UI9AKhCRCrFzWwO0YMn49U+surHrB9Bi9sc8yD5fgXryvklRz5EGAePI8oI/Ov2ZGDR17oMzzcji8nmx7L5h+3+4KuC6ltYK9wwJSRS/MVBtOJi28ntiByP2nmJ1HuVOgUk4wYneYw/Qz/nzNRUMVqydUrLNV+HAkhBK3GGo9Dz/n392THB5qOxot3JWQe2TKQIjRUhOaQCbdui31yoKuW8Al/R7tptQfBxy4bNRIp6jNGfqxZZGaEWFjWvrcAPyNbYmNFQUXeQHynVkXCGEE4tYozLymVWH3TZOfHniaDsg0+had8r4PtWixmgO+kGLUggZHplfsljJhZGMfkab3m7EPw0556AIWvqMyTiJE38G8lRLrdJYsjuaqr1DxwNXBGa9O
 G+PFSfg0
 noidqlRRw+DUM9gLG0XAOK8xM6j5WaJrmq+5KG3kOt3Lopl0GjH0I9TJd5/WSd6qayhiOyDU270ypBfRsrHNwwliSmYP5n+7/jCS4Jc3uTTHylS5d7d3lPQI/vUjpavO5wcgkWjRR3qnug3KPC03M0xhbt49SFOXQBF8pgxvn6bhahQvpKS8wAWAWXPtohllx0RpmK6qH3k6+RHuSfkgMhebjRLs1p/5iDa4xIr1zy9tUbCzZhkBmMBfOOzJCDZQKhsLoXeP5VkKzpYqc9KrOgps8oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg,

On Wed, Mar 11, 2026 at 12:29:45AM -0700, Greg Thelen wrote:
> On Sat, Mar 7, 2026 at 10:24 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> >
> 
> Very interesting set of topics. A few more come to mind.

Thanks.

> 
> I've wondered about preallocating memory or guaranteeing access to
> physical memory for a job. Memcg has max limits and min protections,
> but no preallocation (i.e. no conceptual memcg free list). So if a job
> is configured with 1GB min workingset protection that only ensures 1GB
> won't be reclaimed, not that 1GB can be allocated in a reasonable
> amount of time. This isn't just a job startup problem: if a page is
> freed with MADV_DONTNEED a subsequent pgfault may require a lot of
> time to handle, even if usage is below min.

This is indeed correct i.e. protection limits protect the workload from external
reclaim but does not provide any gurantee on allocating memory in a reasonable
cheap way (without triggering reclaim/compaction). This is one of the challenge
to implement userspace oom-killer in an aggressively overcommitted environment.

However to me providing memory allocation guarantees is more of a system level
feature and orthogonal to memcg. And I see your next para is about that :)

Anyways I think if we keep system memory utilization below some value and
guarantee there is always some free memory (this can be done by having common
ancestor of all workloads and ancestor has a limit or node controller maintains
the condition that the sum of limits of all top level cgroups is below some
percentage of total memory) then we might not need memcg free list or similar
mechanisms (most of the time, I think).

> 
> Initial allocation policies are controlled by mempolicy/cpuset. Should
> we continue to keep allocation policies and resource accounting
> separate? It's a little strange that memcg can (1) cap max usage of
> tier X memory, and (2) provide minimum protection for tier X usage,
> but has no influence on where memory is initially allocated?

I think I understand your point but I think the implementation would be too
messy. This is orthogonal to the proposal but I would say a good topic for
LSFMMBPF if you want to lead the discussion.

