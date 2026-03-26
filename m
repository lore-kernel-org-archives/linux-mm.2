Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910F3103A9A0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB626B0089; Thu, 26 Mar 2026 03:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5CAC6B008C; Thu, 26 Mar 2026 03:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73706B0092; Thu, 26 Mar 2026 03:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9670E6B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:18:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3905E13C0ED
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:18:55 +0000 (UTC)
X-FDA: 84587362230.12.7B6651E
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id 924C4C0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:18:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774509533; a=rsa-sha256;
	cv=none;
	b=LmImuSTEDbM5iX4nJKzEXKv1p7Y7K0WDjrddov+pug+Sn4ZXqVwT8HoBXLyScnzp1cJmRL
	tlH1wH0YXMFI66hRtSa2PVbBUJD60gBZWpGh6eHd4oO7vmr3hQiEbAVAauxdUFvbqAaqw9
	pgYIqKk+l0wzwf1jjB4N1cL1ogLmHq8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774509533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OU44xkEKQdrWR9RjZgGOFTSXdoLcrY8edn8b2UVmgJo=;
	b=PzuGmL5uNUU+DOB1HpY9fBrv+fJrS7cfilzXtVXeN4+5UilIfH3GdGDr2Cs5tEZquyQJb4
	lYtaAuRlLIAq8At5qD3E1t6+6eF7thy+ferhn1R5ObVs4b3mEChk5t/Turm7XuWB5kYZJM
	gUjARGe8K/8iBa8uaeomi/wL+80GzQs=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4fhFQ05lJMzYndlL;
	Thu, 26 Mar 2026 15:14:16 +0800 (CST)
Received: from TA010.hihonor.com (10.77.226.208) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Mar
 2026 15:18:43 +0800
Received: from TA012.hihonor.com (10.77.228.68) by TA010.hihonor.com
 (10.77.226.208) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 26 Mar
 2026 15:18:43 +0800
Received: from TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c]) by
 TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c%8]) with mapi id
 15.02.2562.017; Thu, 26 Mar 2026 15:18:35 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Shakeel Butt <shakeel.butt@linux.dev>, "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko
	<mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes
	<ljs@kernel.org>, Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis
	<emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, Matthew Wilcox
	<willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, Gregory Price
	<gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, David Stevens
	<stevensd@google.com>, wangtao <tao.wangtao@honor.com>, Vernon Yang
	<vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, Kalesh Singh
	<kaleshsingh@google.com>, "T . J . Mercier" <tjmercier@google.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan
	<surenb@google.com>, Meta kernel team <kernel-team@meta.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, liulu 00013167 <liulu.liu@honor.com>, gao xu
	<gaoxu2@honor.com>, wangxin 00023513 <wangxin23@honor.com>
Subject: RE: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Thread-Topic: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Thread-Index: AQHcvJtycwbgDsD0AUiXwTFgs8EFdbXAY5Wg
Date: Thu, 26 Mar 2026 07:18:35 +0000
Message-ID: <12a0c8c9d12040fa8d23658ca57a8760@honor.com>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
In-Reply-To: <20260325210637.3704220-1-shakeel.butt@linux.dev>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 924C4C0002
X-Stat-Signature: cbjo633nrmpj98niit1oha4x3hfzaxdq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774509531-392129
X-HE-Meta: U2FsdGVkX1+J6PIJawRwhUH6cK+FGjQKBno6O0PHMqSnaFJ29xRtPziNcS/icdgz3dPAvtPb0uPb+YUCpEBg05paM4pT1FvtrOY+IcQt47QhoihYVI0ZSI5Fzj2kPsjsvqmfTVmnzt6CEcEBhhaAGO63l8emQi45qymbDcyGPdzPcoIwn2NTkXsZ8ma3dz8hWqKcZQwRFvhDaxVjqz51R7nWpd5FOaj1I9k9PCHt8HRY54ZSSN3ILDfrt1m4Z7uzRsOAdZnfrlm7/1YI+KLNZnJECHykZLV9flht2oMYYQHIAF4KY9UIsjm6UpTk8bWLQg2rsvvYp/voVBnxvePew7n3tydKHBUXv9iSp/YvTqTW6H2sRMLV6eiQ9moPG4IcIvrDLscz7hfUbuH2yrGUDU4bfg7JoZ46OsBOAo8WpIuht8dXointgaR1rDLT+pxMeMoKUikHEXRVGAUS/8Y7hllScHvlkcz/YSL1KD8Kkbm8xGtCLcCX42y1RVyDJlq6LcJFHYUFPno1njs/0UlJv+SPjTDUDERsLDrfAwSiKHySJNkgFPTTWMtEtXRSqmuRnW7PQyOjwCsZPvb4hsy5DQFjO8AuEdnBKEIA1Rf5alAT1BOQu0aAEVegt671TfRI+gyTStuILHPTmkQZoqWZfb8HG4KYpVs0AYDgFgaFWkB0/0PugzSj2qh1njl9/h477RBvI+z+32VFbat7xTR2FMbR9Gnswa8wNe9HjBMw/YEg9VnLm/GVvvhSMvHrj9CUktO+X3zH4RE4JucT11gi1LRitpBZjZ1PbEJvoVK2UBCNFK2NO6/m0Au4iak0eU3Sroe7ugRfUdu6i2uk7dxCbJV1lZREOkSRt4A3YHCPznMcD1lkOvFda9qJ9sZYBQtMlAMbW74MbgGzN3UXuB1Rdq0B6NDnLXFtfwX7Tpr6xjE1T0MjS3g+Hdn0whu1C+23uCz6LebVx9u1AoqWXqO
 yg3T240h
 U+y2oHCv8QU6XgejKWNRjMZ8nPoprtU2ZNcBTeQEFBuJGLLYzW7EWsvSXbqDWeCnhHF+9PDbZ0BjFPEy9vSx4w8WTP9k0Y6SizsxgeSq0wSdAdvwupovQcNN4u5QXLeYHK7Q0Y9VnbD7aLR+Co8128Hjw8nxrKkyKybpipeZuelI+7FLovlskBpWxJrRzWn+CmoqelOq6x2g5A67FVr5iiiQQnwq+JCJ7LHjLGYQYwkydTxWN2mdaVeJMTDhhfSW1oHrhtb1r1h+itS2KTEYBBsbUgtVy4k4mLU3gmauKvYTDXVO5tSqIWAPGLXsOZWL6M1t3/DSkommza7070PT1VmHKzuEBjiIkTuK+tSppF4w2v0BnxuZUXp1g3MLT1fAPORbckLrT03mNblmh1HGsAH6pehobntY+bSHxOwL0gLWjHB9EokIoryrj8iL/tzC/TVjmTRs/4h0TGWqXg9iTIxXx5dnXEYS/KzvW9jphd5rc4hEuQ4sG0Ja/lUSXlcqGz2KjYeLvi1wvKn8KntgMVy7PYARcyO+k6jaTqqmRP5Eslb87PRXpAQ1zDGZIWZsh8W1qwoaFSr6eAbtNoofI5lpKlc/HTTRoIfDH7vM7uFCcXIslWN1hFA9zTi6auZcbJeRm9ngf+3qC3x2TvldKjYxFffEdwI/U43fd50aTMPSVVPLsk1WqOmihlQ2RdrDfQNHQBhzqfnasf4uO48OPzcFfvteSZhts05NzBoXIe6R6UgF9zlQ7Xkw9OfbPVt+FnkX5iM8YOyrmhIJNMvqa1pytBC0oSJrqgFpMRYRS1dmXDTxkt7lk2dlbrjWBvzgBnfMN+SwvBU13MzvotPJjE8myeMGZjwk3gQO/M6QUaIKsAJJEZnaqD/t+5XAhjMfM4AyNYuWZKv46lg73wbzhdLJ/u3LaX6mQSaYE4xd/AlAS19pdcTQktrMH309z+5FPYw6t2gFBc5cyqh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: owner-linux-mm@kvack.org <owner-linux-mm@kvack.org> On Behalf
> Of Shakeel Butt
> Sent: Thursday, March 26, 2026 5:07 AM
> To: lsf-pc@lists.linux-foundation.org
> Cc: Andrew Morton <akpm@linux-foundation.org>; Johannes Weiner
> <hannes@cmpxchg.org>; David Hildenbrand <david@kernel.org>; Michal
> Hocko <mhocko@kernel.org>; Qi Zheng <zhengqi.arch@bytedance.com>;
> Lorenzo Stoakes <ljs@kernel.org>; Chen Ridong
> <chenridong@huaweicloud.com>; Emil Tsalapatis <emil@etsalapatis.com>;
> Alexei Starovoitov <ast@kernel.org>; Axel Rasmussen
> <axelrasmussen@google.com>; Yuanchu Xie <yuanchu@google.com>; Wei
> Xu <weixugc@google.com>; Kairui Song <ryncsn@gmail.com>; Matthew
> Wilcox <willy@infradead.org>; Nhat Pham <nphamcs@gmail.com>; Gregory
> Price <gourry@gourry.net>; Barry Song <21cnbao@gmail.com>; David
> Stevens <stevensd@google.com>; Vernon Yang <vernon2gm@gmail.com>;
> David Rientjes <rientjes@google.com>; Kalesh Singh
> <kaleshsingh@google.com>; wangzicheng <wangzicheng@honor.com>; T . J .
> Mercier <tjmercier@google.com>; Baolin Wang
> <baolin.wang@linux.alibaba.com>; Suren Baghdasaryan
> <surenb@google.com>; Meta kernel team <kernel-team@meta.com>;
> bpf@vger.kernel.org; linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Subject: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory
> Reclaim (reclaim_ext)
>=20
> The Problem
> -----------
>=20
> Memory reclaim in the kernel is a mess. We ship two completely separate
> eviction algorithms -- traditional LRU and MGLRU -- in the same file.
> mm/vmscan.c is over 8,000 lines. 40% of it is MGLRU-specific code that
> duplicates functionality already present in the traditional path. Every b=
ug fix,
> every optimization, every feature has to be done twice or it only works f=
or
> half the users. This is not sustainable. It has to stop.
>=20
> We should unify both algorithms into a single code path. In this path, bo=
th
> algorithms are a set of hooks called from that path. Everyone maintains,
> understands, and evolves a single codebase. Optimizations are now
> evaluated against -- and available to -- both algorithms. And the next ti=
me
> someone develops a new LRU algorithm, they can do so in a way that does
> not add churn to existing code.
>=20
> How We Got Here
> ---------------
>=20
> MGLRU brought interesting ideas -- multi-generation aging, page table
> scanning, Bloom filters, spatial lookaround. But we never tried to refact=
or the
> existing reclaim code or integrate these mechanisms into the traditional =
path.
> 3,300 lines of code were dumped as a completely parallel implementation
> with a runtime toggle to switch between the two.
> No attempt to evolve the existing code or share mechanisms between the
> two paths -- just a second reclaim system bolted on next to the first.
>=20
> To be fair, traditional reclaim is not easy to refactor. It has accumulat=
ed
> decades of heuristics trying to work for every workload, and touching any=
 of
> it risks regressions. But difficulty is not an excuse.
> There was no justification for not even trying -- not attempting to gener=
alize
> the existing scanning path, not proposing shared abstractions, not offeri=
ng
> the new mechanisms as improvements to the code that was already there.
> Hard does not mean impossible, and the cost of not trying is what we are
> living with now.
>=20
> The Differences That Matter
> ---------------------------
>=20
> The two algorithms differ in how they classify pages, detect access, and
> decide what to evict. But most of these differences are not fundamental
> -- they are mechanisms that got trapped inside one implementation when
> they could benefit both. Not making those mechanisms shareable leaves
> potential free performance gains on the table.
>=20
> Access detection: Traditional LRU walks reverse mappings (RMAP) from the
> page back to its page table entries. MGLRU walks page tables forward,
> scanning process address spaces directly. Neither approach is inherently =
tied
> to its eviction policy. Page table scanning would benefit traditional LRU=
 just as
> much -- it is cache-friendly, batches updates without the LRU lock, and
> naturally exploits spatial locality. There is no reason this should be MG=
LRU-
> only.
>=20
> Bloom filters and lookaround: MGLRU uses Bloom filters to skip cold page
> table regions and a lookaround optimization to scan adjacent PTEs during
> eviction. These are general-purpose optimizations for any scanning path.
> They are locked inside MGLRU today for no good reason.
>=20
> Lock-free age updates: MGLRU updates folio age using atomic flag
> operations, avoiding the LRU lock during scanning. Traditional reclaim ca=
n use
> the same technique to reduce lock contention.
>=20
> Page classification: Traditional LRU uses two buckets (active/inactive).
> MGLRU uses four generations with timestamps and reference frequency
> tiers. This is the policy difference -- how many age buckets and how page=
s
> move between them. Every other mechanism is shareable.
>=20
> Both systems already share the core reclaim mechanics -- writeback,
> unmapping, swap, NUMA demotion, and working set tracking. The shareable
> mechanisms listed above should join that common core. What remains after
> that is a thin policy layer -- and that is all that should differ between
> algorithms.
>=20
> The Fix: One Reclaim, Pluggable and Extensible
> -----------------------------------------------
>=20
> We need one reclaim system, not two. One code path that everyone
> maintains, everyone tests, and everyone benefits from. But it needs to be
> pluggable as there will always be cases where someone wants some
> customization for their specialized workload or wants to explore some new
> techniques/ideas, and we do not want to get into the current mess again.
>=20
> The unified reclaim must separate mechanism from policy. The mechanisms
> -- writeback, unmapping, swap, NUMA demotion, workingset tracking -- are
> shared today and should stay shared. The policy decisions -- how to detec=
t
> access, how to classify pages, which pages to evict, when to protect a pa=
ge --
> are where the two algorithms differ, and where future algorithms will dif=
fer
> too. Make those pluggable.
>=20
> This gives us one maintained code path with the flexibility to evolve.
> New ideas get implemented as new policies, not as 3,000-line forks. Good
> mechanisms from MGLRU (page table scanning, Bloom filters, lookaround)
> become shared infrastructure available to any policy. And if someone come=
s
> up with a better eviction algorithm tomorrow, they plug it in without
> touching the core.
>=20
> Making reclaim pluggable implies we define it as a set of function method=
s
> (let's call them reclaim_ops) hooking into a stable codebase we rarely mo=
dify.
> We then have two big questions to answer: how do these reclaim ops look,
> and how do we move the existing code to the new model?
>=20
> How Do We Get There
> -------------------
>=20
> Do we merge the two mechanisms feature by feature, or do we prioritize
> moving MGLRU to the pluggable model then follow with LRU once we are
> happy with the result?
>=20
> Whichever option we choose, we do the work in small, self-contained phase=
s.
> Each phase ships independently, each phase makes the code better, each
> phase is bisectable. No big bang. No disruption. No excuses.
>=20
> Option A: Factor and Merge
>=20
> MGLRU is already pretty modular. However, we do not know which
> optimizations are actually generic and which ones are only useful for MGL=
RU
> itself.
>=20
> Phase 1 -- Factor out just MGLRU into reclaim_ops. We make no functional
> changes to MGLRU. Traditional LRU code is left completely untouched at th=
is
> stage.
>=20
> Phase 2 -- Merge the two paths one method at a time. Right now the code
> diverts control to MGLRU from the very top of the high-level hooks. We
> instead unify the algorithms starting from the very beginning of LRU and
> deciding what to keep in common code and what to move into a traditional
> LRU path.
>=20
> Advantages:
> - We do not touch LRU until Phase 2, avoiding churn.
> - Makes it easy to experiment with combining MGLRU features into
>   traditional LRU. We do not actually know which optimizations are
>   useful and which should stay in MGLRU hooks.
>=20
> Disadvantages:
> - We will not find out whether reclaim_ops exposes the right methods
>   until we merge the paths at the end. We will have to change the ops
>   if it turns out we need a different split. The reclaim_ops API will
>   be private and have a single user so it is not that bad, but it may
>   require additional changes.
>=20
> Option B: Merge and Factor
>=20
> Phase 1 -- Extract MGLRU mechanisms into shared infrastructure. Page tabl=
e
> scanning, Bloom filter PMD skipping, lookaround, lock-free folio age upda=
tes.
> These are independently useful. Make them available to both algorithms.
> Stop hoarding good ideas inside one code path.
>=20
> Phase 2 -- Collapse the remaining differences. Generalize list infrastruc=
ture
> to N classifications (trad=3D2, MGLRU=3D4). Unify eviction entry points. =
Common
> classification/promotion interface. At this point the two "algorithms" ar=
e thin
> wrappers over shared code.
>=20
> Phase 3 -- Define the hook interface. Define reclaim_ops around the
> remaining policy differences. Layer BPF on top (reclaim_ext).
> Traditional LRU and MGLRU become two instances of the same interface.
> Adding a third algorithm means writing a new set of hooks, not forking
> 3,000 lines.
>=20
> Advantages:
> - We get signals on what should be shared earlier. We know every shared
>   method to be useful because we use it for both algorithms.
> - Can test LRU optimizations on MGLRU early.
>=20
> Disadvantages:
> - Slower, as we factor out both algorithms and expand reclaim_ops all
>   at once.
>=20
> Open Questions
> --------------
>=20
> - Policy granularity: system-wide, per-node, or per-cgroup?
> - Mechanism/policy boundary: needs iteration; get it wrong and we
>   either constrain policies or duplicate code.
> - Validation: reclaim quality is hard to measure; we need agreed-upon
>   benchmarks.
> - Simplicity: the end result must be simpler than what we have today,
>   not more complex. If it is not simpler, we failed.
> --
> 2.52.0
>=20

Hi Shakeel,

The reclaim_ops direction looks very promising. I'd be interested in the di=
scussion.

We are particularly interested in the individual effects of several mechani=
sms
currently bundled in MGLRU. reclaim_ops would provide a great opportunity t=
o
run ablation experiments, e.g. testing traditional LRU with page table scan=
ning.

On policy granularity, it would also be interesting to see something like `=
`reclaim_ext''[1,2]
taking control at different levels, similar to what sched_ext does for sche=
duling policies.

Best,
Zicheng

[1] cache_ext: Customizing the Page Cache with eBPF
[2] PageFlex: Flexible and Efficient User-space Delegation of Linux Paging =
Policies with eBPF



