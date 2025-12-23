Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5438BE6F06C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 08:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E126B0005; Tue, 23 Dec 2025 03:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBEE6B0089; Tue, 23 Dec 2025 03:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F300C6B008A; Tue, 23 Dec 2025 03:22:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E16036B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:22:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D931C0986
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:22:50 +0000 (UTC)
X-FDA: 84250044900.10.D37D329
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C64D180017
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:22:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LWGKu27t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766478168; a=rsa-sha256;
	cv=none;
	b=G4ypiOaA7N+uWSspdEhzxnFiWCokoNqDBIR/FvnblEl6geS39jDcDJm0r6ifud1PXPCVnp
	nnVutEXuQF0R8Zj/77PYAMlfblrTUy6K2LiqBblHeB5QXYjQ1Qx/RddlUqlP+Pt0YFeBvg
	mnzHKCLhmsMQl+mhSGywlh2qEgkY11o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LWGKu27t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766478168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8DrPyrW6XtxAjggK1JgrO3+7taqgHLHtwdI/kQJR+w=;
	b=6Cp9qN5J4s4KT84cAW0FEDEZWz86BjPfBJCp5ivEX/8ojyWf6LUoG+1oMl9M/zk5KLwCKW
	zNy+GQJtlcYzHwtiT0gd3UM0Q6H0qgz0hcV3olSCnXrHRurEbNKtbTd/4LLVY1ysegxkX6
	O0fZ6qSwQ7jhryDBZatEQBjqGvLwLew=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766478166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g8DrPyrW6XtxAjggK1JgrO3+7taqgHLHtwdI/kQJR+w=;
	b=LWGKu27tPvA6G/BvHlU1qcMpvMeL6oZcoC6wVaQUt3k4Les05DwUlFnp7Gjahu1gLH5WZB
	oktQErFDkcBbaLo98juzOcKkUlZauT477Cg0haR9+Kg1nX4zilo1MYpXCXp8yhoogkl1m9
	FMaczIARJifLFdHGoGEQC+QIpX7I384=
Date: Tue, 23 Dec 2025 08:22:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C64D180017
X-Stat-Signature: 4df6j5kkjofgmbae7owz3dcei65muijy
X-Rspam-User: 
X-HE-Tag: 1766478168-409914
X-HE-Meta: U2FsdGVkX18Lth+6jordcIQzAjuI7qkboi3ABkdksVf4TcFCug3NjY2hkOPZWeuMOIKqdTmHfvD5AjWHZVAw2/iho5+e/1WXelzmhcvzG4FQmESuB9zJH3kdMvsuYgfhlziC/XquiNv984CPIFdSKJrE5sGSw0GeLztnL3rHp2vgoPXkW17GOF8OAf17e0O6HZmD1EhaNPzp9lr9f3V3/9CgiSifZydJSsgvnwAw4pN3hMgGr0PCHZljxplnO0+yaYx8s0SDyOS7LgPPQDtMIBF+a12SqSCU6xKOijUHY7ewyYfLnNLUCA/fYJrtXNhqt8OSxcvSp4VQ8RH3N/4lQgQDmMdYeeiOhTBDTnIxU96t6k/l5/rYJ9c+ylaO+vD83BxlxFwFOMNAtLr+919keDspmeK7ktnERKCWTxXUN9ijGsba3/5jvAQKSwC3RGhDcqDND9pp6wn1DkEtIcIF83NNrEseh1Stzl7CcH4ORXTrXW/jyBDRfqJcGFSBZV0y1oD5iek7J2Gtx0aahgxLeT8MCcequIRCChzRLBN1kCB1EMN5zjiiED/RUxqn07kHWwzi81Q9N23t6OPHuyLsrgP4igfiWpiAtT2N5aU9pa8gP0JM11jKTAMPOaDb73NEKOxhT2OgJLJGOnN+nfMkwntXE6PwIsvmyrTnki5wucR0gE5IVgozTq+KA6xU4sftMeH1C/BNws8dmEoM+NLwtggldbA3lq4aLY8e4weyhBZJaVtR0ublM2IdiyNYy1CrgsCjgUR7QZCh74OSTHLN3M5doYewIl9mLKDuXYuXoIyjotwfL89H2VGBtvItSuDLHOGFfn357onbmSfsQLxyyHgEUcIc9QEtPEoL+IB6SeRX4GVcoexPrIZy8/M/0ltlWrhljAiPupyYVG7RV+e+49ANpUX2vMLqwgG6A1TX9m6h4i9QOE2/GNBIQ6pjtm1Yi1uU8D5Hwm6Fvs1Tkp3
 2yJDYcTQ
 ygBumKjKbUUmK+T2NyI9negZmUtXwN9EDqk+JNPctP/LyvpVpzDmmzwYQ8A9NT4hzmYkP/oY5N2LUYmcmwRTPneAx7Ouf8me2yhO/8OXSvapy19ZxZp/mWkTR7sA0kKBIcceG/bpU8kyzV1mLdwbskyNBDDfc0VrIpiRD5vyDIU9HI2zBdazG9epqBr+fzBPpwgqu1iksUOcUZ/jHrI/UT4LXKxPy2qI11o4IPJY785fX5VrHO4nBwsbzyMmVp4LJmfknC0iWfc4Ea5esZOuZiDq5lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 23, 2025 at 14:11, "Shakeel Butt" <shakeel.butt@linux.dev mailto=
:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40lin=
ux.dev%3E > wrote:


>=20
>=20On Tue, Dec 23, 2025 at 01:42:37AM +0000, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> December 23, 2025 at 05:15, "Shakeel Butt" <shakeel.butt@linux.dev =
mailto:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt=
%40linux.dev%3E > wrote:
> >=20
>=20[...]
>=20
>=20>=20
>=20> >=20
>=20>  I don't think kswapd is an issue here. The system is out of memory=
 and
> >  most of the memory is unreclaimable. Either change the workload to u=
se
> >  less memory or enable swap (or zswap) to have more reclaimable memor=
y.
> >=20=20
>=20>=20=20
>=20>  Hi,
> >  Thanks for looking into this.
> >=20=20
>=20>  Sorry, I didn't describe the scenario clearly enough in the origin=
al patch. Let me clarify:
> >=20=20
>=20>  This is a multi-NUMA system where the memory pressure is not globa=
l but node-local. The key observation is:
> >=20=20
>=20>  Node 0: Under memory pressure, most memory is anonymous (unreclaim=
able without swap)
> >  Node 1: Has plenty of reclaimable memory (~60GB file cache out of 12=
5GB total)
> >=20
>=20Thanks and now the situation is much more clear. IIUC you are running
> multiple workloads (pods) on the system. How is the memcg limits
> configured for these workloads. You mentioned memory.high, what about

Thanks for the questions. We have pods configured with memory.high and po=
ds configured with memory.max.

Actually, memory.max itself causes heavy I/O issues for us, because it ke=
eps trying to reclaim hot
pages within the cgroup aggressively without killing the process.=20

So=20we configured some pods with memory.high instead, since it performs =
reclaim in resume_user_mode_work,
which somewhat throttles the memory allocation of user processes.

> memory.max? Also are you using cpusets to limit the pods to individual
> nodes (cpu & memory) or they can run on any node?

Yes, we have cpusets(only cpuset.cpus not cpuset.mems) configured for our=
 cgroups, binding
them to specific NUMA nodes. But I don't think this is directly related t=
o the issue - the
problem can occur with or without cpusets. Even without cpusets.cpus, the=
 kernel prefers
to allocate memory from the node where the process is running, so if a pr=
ocess happens to
run on a CPU belonging to Node 0, the behavior would be similar.


>=20
>=20Overall I still think it is unbalanced numa nodes in terms of memory =
and
> may for cpu as well. Anyways let's talk about kswapd.
> >=20
>=20> Node 0's kswapd runs continuously but cannot reclaim anything
> >  Direct reclaim succeeds by reclaiming from Node 1
> >  Direct reclaim resets kswapd_failures,
> >=20
>=20So successful reclaim on one node does not reset kswapd_failures on
> other node. The kernel reclaims each node one by one, so if Node 0
> direct reclaim was successfull only then kernel allows to reset the
> kswapd_failures of Node 0 to be reset.

Let me dig deeper into this.

When either memory.max or memory.high is reached, direct reclaim is
triggered. The memory being reclaimed depends on the CPU where the
process is running.

When the problem occurred, we had workloads continuously hitting=20
memory.max=20and workloads continuously hitting memory.high:

reclaim_high    ->   -> try_to_free_mem_cgroup_pages
                   ^      do_try_to_free_pages(zone of current node)
                   |         shrink_zones()
try_charge_memcg  -              shrink_node()
                                     kswapd_failures =3D 0

Although the pages are hot, if we scan aggressively enough, they will eve=
ntually
be reclaimed, and then kswapd_failures gets reset to 0 - because even rec=
laiming
a single page resets kswapd_failures to 0.

The end result is that we most workloads, which didn't even hit their hig=
h
or max limits, experiencing continuous refaults, causing heavy I/O.

Thanks.

> >=20
>=20> preventing Node 0's kswapd from stopping
> >  The few file pages on Node 0 are hot and keep refaulting, causing he=
avy I/O
> >=20
>=20Have you tried numa balancing? Though I think it would be better to
> schedule upfront in a way that one node is not overcommitted but numa
> balancing provides a dynamic way to adjust the load on each node.

Yes, we have tried it. Actually, I submitted a patch about a month ago to=
 improve
its observability:
https://lore.kernel.org/all/20251124153331.465306a2@gandalf.local.home/
(though only Steven replied, a bit awkward :( ).

We found that the default settings didn't work well for our workloads. Wh=
en we tried
to increase scan_size to make it more aggressive, we noticed the system l=
oad started
to increase. So we haven't fully adopted it yet.

> Can you dig deeper on who and why Node 0's kswapd_failures is getting
> reset?
>

