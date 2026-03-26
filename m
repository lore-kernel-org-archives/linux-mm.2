Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F30D10A62D5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B3C6B0088; Thu, 26 Mar 2026 09:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5126C6B008C; Thu, 26 Mar 2026 09:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F7E6B0092; Thu, 26 Mar 2026 09:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36DD66B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:44:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C80D9C335B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:44:34 +0000 (UTC)
X-FDA: 84588334068.10.936DFBC
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id 205C2160003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:44:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JKnh8UbE;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774532673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHs1nX261KI0Bcg1Nf//oeXdKIr+A9JzQ6d3yV5ghDQ=;
	b=zU08OTfoJJMlXSx8VAj2aZKpZ7q8sX5qR7vfuF0EsO1pUyVuevtVmk1GPJnY5bKUaaDvsa
	UhIpK+Bct8cN/n3NQYnW1+vIqKekMLE7u4xZ9mm+6ldMLanVLOtPy4iiXU/R278XrBmYjA
	5Smjt8tNtdyTIbKFs+LxroZtQxicvzw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JKnh8UbE;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774532673; a=rsa-sha256;
	cv=none;
	b=aHybDEkerkExvSBAPVIgHoxsf7au0yYwG2taJn3SZ1C0htCgismVcvDbqO3m1E+b2qOWqz
	JdRcJgZfZ0zlrZOUHKa2vvuw4tmRBGZ1EqZnYEN4jbN2MqUlN18KeSrfmTWfV7bU5rs4Y6
	ZBaHKqBIoVnGCti+Fs7kZMJkcbvOTu0=
Date: Thu, 26 Mar 2026 06:44:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774532667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FHs1nX261KI0Bcg1Nf//oeXdKIr+A9JzQ6d3yV5ghDQ=;
	b=JKnh8UbE2TxNQo7XZDsJ3d18TsjVhK3/RocXZOnwJCCpGvOzWmX4GWO+GfqBWTHmHdWXKY
	v5IQUm1sFyGvotbOTuYWFXW20cz5O5tTB2CG6XsZzB1SDtPaplNpmaa2A9eClfS4FF/P5Y
	vvTcQVQy9uinU12Qeg9RpNfAlh29z/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Chen Ridong <chenridong@huaweicloud.com>, 
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
Message-ID: <acUzMdxCDfbuyv9J@linux.dev>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <acTcStxrTCWAN6Dt@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acTcStxrTCWAN6Dt@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 205C2160003
X-Stat-Signature: 8m6pg6owgtwfshpz19opwsqb9y4q3dtu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774532670-589614
X-HE-Meta: U2FsdGVkX1/q3KZ6KsRR6w0lx4M2JVi1/o+xLOK81x/UPlsRTHtNM0kAEwI0BSJXf41I/5wDKFdCXbd1u9cjf81MR205EZQfbng8Lh6KOSANc3vKdlo3XxsD8TereW3xdz3ouvhygyTYA5ZFS8JSCos+M6Kc+MUVjOgEsFjfz6teXHf+65VbpzkCI8EV4b1l9c7IRomPLECZVcB1vup0KoO4iwj/ImbJvxlNKf7rTRDgXIMwugbfBc+pT5KRIz9272bzbHQ2vjTSePz6tTk/CfPeWvz2HMmkLxwqoXZ/izB9MWR+yQhJ+eNAGKtXBeEKTxxgAz30bZoWZoqJ2vukVuydjIrQdQrRpWNA8N7ju6brboBp2mFsLzs+e7K/wDKxEPjR9ePl9qvHqTSkLQtcZgIYiGYQZvjM2FMHhLx2xv6+aA3mt0mVVlGiskCr6fcEQu0Xalwr6MzJyc0GJf7qFTKgPTeo9qrVIMIqf7M74lgekl2j6vYjKCyMPS+7X92WAcGMyly9jZDicT3BuVWWx+oTUES5GA7vqS76RRppPaqI4akVioi4ufAm1z9A+ziRTj95XL7k2aldq9+zo/LWhaCj2ptx1nFUjVss0WbOYeOnR6iSCy2RIDDVGzz7ZUiClFUZbR4wW+pk00KlAsEqtrdtbQ9y+ffdYCJvmxOCUpJfxjA6pgqnnn4ccWtvJiWHN56NDuY+3Ccrhgw5Wu+cauTI1byP7F2FJ+YFKiXHJggHuUSgz+LFV3xLSG1mEs7BdoXkJ1mhLK+2mmw/hC/p6WhcaUXXVDnBeV0Q6kCrQYmp6ZLmteFM+l0S5WDeHyHC1ZySPBWxH0sZArIkMuK4RdAu3EDar54bwq5UzWC4zD2tn6jNpTES69X9R2iI2L2mAizgGe4Z6saNFxV37kYyOwSqhWrT7uP8VW7uo35NXJO6th5Pl/W9lsyD7BGevS9uF1lCM+I4N2T7VKdUvVy
 5XMTtz+3
 gXDFUcq6IFYWhsuYMUrN+NDwVpx7LalfQJxAG5Y/7WKKECz5L5hZXH/IsSgEUBwivDLXgwiYadXt71Qh9Dj1nkKbi9FsiCm75mchYmQGQGkv3S/6jENJN7dJo1Pj+bxDUB0/iwBOYZRNmlCpfDvDOaDCsEJK515L/RUKQsSRoOdn4ToavoumUKcjI1wz00NCUaJNIkowadnacACQm6TsC/RQyBo1uM6s4IJx43YxBNJTGFuKi7Ix25GLT9qV9QSprcUhJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:12:10AM +0100, Michal Hocko wrote:
> On Wed 25-03-26 14:06:37, Shakeel Butt wrote:
> > The Problem
> > -----------
> > 
> > Memory reclaim in the kernel is a mess. We ship two completely separate
> > eviction algorithms -- traditional LRU and MGLRU -- in the same file.
> > mm/vmscan.c is over 8,000 lines. 40% of it is MGLRU-specific code that
> > duplicates functionality already present in the traditional path. Every
> > bug fix, every optimization, every feature has to be done twice or it
> > only works for half the users. This is not sustainable. It has to stop.
> 
> While I do agree that having 2 implementations available and to maintain
> them is not long term sustainable I would disagree with your above line
> of argumentation. We are not aiming to have the two in feature parity
> nor they are overlapping in bug space all that much.

There is definitely basic set of features which we want from a reclaim
mechanism (e.g. writeback and writeback throttling which MGLRU lacked for a long
time) and it does not mean we should aim for feature parity.

For the bugs/debugging, we always need to answer if it is impacting one or the
other or both.

> 
> > We should unify both algorithms into a single code path. In this path,
> > both algorithms are a set of hooks called from that path.
> 
> Isn't this the case from a large part? MGRLU tends to have couple of
> entry points in the shared code base (node/memcg scanning code).

Most of the code is diverged at the reclaim entry point and from what I see the
code at the lowest layer (shrink_folio_list) is shared.

> 
> > Everyone
> > maintains, understands, and evolves a single codebase. Optimizations are
> > now evaluated against -- and available to -- both algorithms. And the
> > next time someone develops a new LRU algorithm, they can do so in a way
> > that does not add churn to existing code.
> 
> I think we should focus to make a single canonical reclaim
> implementation work well. I.e. we deal with most (or ideally all) known
> regressions of MGLRU. 

Here we disagree on the approach or steps to reach the single canonical reclaim
implementation. MGLRU is a plethora of different mechanisms and policies and it
never went through rigorous evaluation for each of those mechanisms and
policies individually. To me that needs to be done to have one solution. 

> In the initial presentation of the MGRLU framework
> we were told that the implemenation should be extensible to provide more
> creative aging algorithms etc.
> 
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
> I would go that way only if/after we are done with MGLRU unification and
> after we will have depleted the potential of that approach and hit cases
> where we cannot implement new extensions without going $foo_ext way. TBH
> I am not convinced "make it pluginable to solve hard problems" is the
> best way forward.

The reason I have added pluggable/extensible part in this proposal is that I
want to avoid the same scenario all over again in the future. There will always
be some users with very specialized workloads needing some fancy/weird
heuristic. Rather than polluting the core reclaim, letting such users to do
fancy policies should be part of our long term strategy. In addition, we will
want to explore different algorithms and techniques, providing a way to easily
do that without changing the core is definitely needed for future proofing the
reclaim.


