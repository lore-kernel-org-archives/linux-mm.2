Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4637DFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 23:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97EB06B0088; Mon, 27 Apr 2026 19:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92EDD6B008A; Mon, 27 Apr 2026 19:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845756B008C; Mon, 27 Apr 2026 19:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECC76B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:57:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F240E402F5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:57:50 +0000 (UTC)
X-FDA: 84706001100.03.C6013F1
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19BDF180007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:57:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MNqYSNDO;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777334269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HK3fGTvUSK6Pf6uv4CRxer5Mvc4QTCiYiSwv9+Xo7Nw=;
	b=AhoCdSO2jONhNPwOY63lnG1VVT2BZynIi7dSf3UbpkVNKRff5k1o8GO5KpYvyVderYm93P
	FmzljukHxHTRp1liD5vY778vRP6TK+jN2aAXM/5NgfY6vW7artt0Gwc8S5TsC+LfxMAJZc
	b/OWo+bmlZXz7N01UL5HfS8cS7eA7qw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MNqYSNDO;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777334269; a=rsa-sha256;
	cv=none;
	b=4jbGP7J6V2Pr6RTuNioPkgcRJvdG45qXhAC87D+y/hnLfRhcJyfSPe9wlfaj+18q//wxfN
	I1SAObWClasVJfVYkBmLDvfgkXolZfq+8bd83s2rznki90PIhrV534IvRWauAkljGkQk0G
	jMnoekGfMvZmW/6ncHLq/kuCAxl8AqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777334266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=HK3fGTvUSK6Pf6uv4CRxer5Mvc4QTCiYiSwv9+Xo7Nw=;
	b=MNqYSNDOTerfl2yHBbZx+VMPp+ShXOiifuwVn+lqfA/DSUrQqVSlqIwqv5TUYPvvsHSctR
	VXohM5a8eXd6MKN386ljv/LXXta5LZjMX+wBqdh+AXNj4xIZiAISIAxPziMRybdC515Vvl
	xh0aw5nQTZyo+7G2Y+Iof5+Libe14mI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Vlastimil
 Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org> , lsf-pc
 <lsf-pc@lists.linux-foundation.org>, Daniel Borkmann
 <daniel@iogearbox.net>
Subject: [LSF/MM/BPF TOPIC] Using BPF in MM
Date: Mon, 27 Apr 2026 23:57:26 +0000
Message-ID: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19BDF180007
X-Stat-Signature: d7qa38z4zrk43a8gjzpcgk1citz6xg9s
X-HE-Tag: 1777334268-60319
X-HE-Meta: U2FsdGVkX18LvRmPvihVy0O5l2aFQSwO7rYPWS5MafxlIJiE/i1fBtLuMoqn98dllivIfB6qSUOEBdLRr3O7lU7tB9+ZMmWpuzDjdWOy/DWMXtwv4we1+vvZYoKcMvpVhgAso85dt93r5eXwqi42JeG3FbQo8F+UIfuwukDLViJFbPryEKlTiLh4Wtdkne2CkzFNU0De+SwB0qtNs2c+0C/vAGQdxqwD0mSa2qfpRZxZDWfRB8fqwv2wgRKIspHBm6UojqpXGclQm/4O8naKG6YtjMQkVnkTY2576Hp9gczgwfZlA2z3vbmCr38KpGnreig5yq/I0rHn9qVFfLIe4PuPcWrud3fl5R+JuX9GssDw5YTbypGJPvCHhFoIFU608tFRss5HbQFCJDagYyFmMsws1jGV7dd0eP5CmFrp4sXukshWNKcDnPBVyqmbshQMpawE61FHHhzD5ufmijHhLHXRLFbL25hvPgjWX628CnniIY4XwBMNqybkPuuuzPihSF9roDSERC8scUruFin/MQlH9SoCSrDiEhAr0fEjxD5na/YXBxHwb5Dj7J/frXCi60zBQKWwg5mUc4XGv1yQ+PdgMJAmx3pGeBz7iaahZIVL03blc4fZGetDOapJyCDy53g/opSXXlW+ZgEP3bfkbTG92nBl50X/vwIilQvegWv72Ta4rei+9hRlzrVvSoSVupJNur3FdnpEOhT7eiMAD9eSElEkWZgdPTvTCESdD2bxxlwBod58lKTGsFHcjFMmuWebgAkogEhehjDDPv5bcp+SKREGHor+TGLIePdA1DrXYa/RCqRkNqaxOcf29E0ZoRGBt3l+i0AbmsPX0AqkWHdpIXsieptddA5gYthKgzvUd3em3SdSkMo3K1SQ11ukUbk++eEVtfvg1uh6qpu+iGxkrvoCWYFkWU+lE9I/FMNQtshokrc36HrJSXYkgLqyEMKdAZDSca4SvRE9kDl
 qSBWjmUO
 JRvnxBsBXzECx/lb/XF8WXXkmZIdXdh1RGUwi80vodCuqFL1xq+FbIpJuDF5JbTRfl30dF6N16f4AINZ9NUtFnvsNZz1/4WiIIWugsl+sY6AmXpOdKd6sbT/YdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[LSF/MM/BPF TOPIC] Using BPF in MM
----------------------------------

Over the last decade, BPF successfully penetrated into multiple kernel
subsystems: started as a feature to filter (out) networking packets,
it captured its place in networking, tracing, security, HID drivers,
and scheduling. Memory management is a logical next step, and recently
we saw a growing number of proposals in this area.

In (approximately) historical order:
  - BPF OOM
  - BPF-based memcg stats access (landed)
  - BPF-based NUMA balancing
  - eBPF-mm
  - cache_ext (BPF Page Cache)
  - memcg_ext

There are some obvious target which haven't been covered yet:
  - BPF-driven readahead control
  - BPF-driven KSM
  - BPF-driven guest memory control

Despite a large number of suggestions only a relatively small feature
(query memcg statistics from BPF) made it to upstream.

It looks like using BPF in the MM subsystem comes with a set of somewhat
unique challenges and questions to be answered.


Problem 1. In-Tree/Out-of-Tree BPF Programs
-------------------------------------------
Historically, BPF was created and used to create relatively simple programs
which implemented custom policies, which are arguably mostly user-specific
and have limited value being shared. So keeping them outside of the Linux
source tree was totally reasonable. In the tree we had relatively simple
programs which played a role of examples, tests and documentation. But with
the growing capabilities of BPF, more and more complex BPF programs and
sets of programs are becoming viable. Arguably sched_ext and specific
scheduler implementations are the most complex BPF interfaces now.
Sched_ext developers decided to keep minimalist reference schedulers
in-tree, while production-grade schedulers are developed outside.
There are pros and cons: it allows for much faster iteration but
at the cost of fragmentation risk.

It seems like memory management maintainers (at least Andrew Morton)
are willing to see production-grade BPF programs in the tree. It solves
the fragmentation concern and brings more attention and collaborators,
but somewhat eliminates the strong sides of BPF: speed of iterations
and easy of the customization. And some of the programs are simple too
business-specific to upstream them (e.g. and OOM policy which relies on
cloud orchestrator logic for the victim selection).

So in practice I expect to see both in practice: policy-heavy programs
will live outside the tree, while generic mechanisms (e.g., BPF-driven
memory tiering or cgroup-aware OOM killer) will live within the tree.
Keeping complex bpf programs in tree requires some help from the BPF
community: we need to decide where to keep them, what's the maintenance
policy and potentially ship them with the kernel binary.


Problem 2. Performance in Hot Paths & Cgroup Hierarchy
------------------------------------------------------
BPF was always optimized for speed, and it's really fast. However,
for *some* MM use cases, this might not be enough. Especially if we
simultaneously want to keep it safe (see the next problem). Traffic
control programs which run for every packet need to be very fast,
but at least there is usually no state to manage. If we allow BPF
programs to actually manipulate low-level MM data types in a safe way
(e.g., folio's LRU pointers), it almost inevitably hurts performance.

Also, the lifetime tracking of objects becomes more complex: BPF often
relies on RCU to guarantee memory safety, but it's not trivial and
certainly not free to provide RCU guarantees to, e.g., all folios.
And if we do it using reference counting, it's a performance overhead.

I believe that the solution is to provide safe and performant kfuncs
to operate with low-level data structures, but there is likely a tradeoff
to make between performance, safety guarantees, and flexibility.

For MM programs which operate with memory cgroups, there is a separate
question: how to implement attachment to cgroups? For ordinary BPF programs
there is a complex infrastructure to propagate attached programs to all
cgroups in the sub-tree. For struct_ops'es which are increasingly used to
implement complex BPF mechanisms, there is no such mechanism yet. And
it's not obvious what the best way to implement it: there might be
some state on specific cgroup level, different mechanisms require
different hierarchical behavior, etc. E.g., for BPF OOM, it's perfectly
fine and even desirable to have it attached to some levels and traverse
the hierarchy when it needs to be invoked. But for some programs on very
hot paths, this overhead might not be acceptable.

Finally, MM heavily relies on batching for minimizing the performance
overhead, but it comes with it's own set of tradeoffs. E.g. for large
machines with hundred of CPUs which are  running thousands of cgroups
it's really hard to come up with memcg statistics which is reasonable
accurate but also not slowing everything down. If we add bpf on top of
batching, it's somewhat limited, e.g. a user can't implement a custom
batching mechanism. But most likely we can't do otherwise: the performance
overhead is simple too high.


Problem 3. Safety guarantees and fallback mechanisms
----------------------------------------------------
Safety guarantees were always one of the main, if not the main, selling
points for BPF. Otherwise, why simply not use kernel modules? But what
exactly does the BPF verifier and runtime engine guarantee? For networking,
tracing, and even the scheduler, the answer is the the stability of the
kernel itself (no oopses, UAF, or data corruption).

But the quality of service or usefulness of the system from a user's
perspective is not strictly guaranteed. A malformed BPF program which
drops all the traffic and makes the system unreachable over SSH is
considered acceptable. Sched_ext falls back to CFS if the BPF scheduler
is doing an obviously poor job scheduling tasks, but it takes time and,
of course, it doesn't guarantee performance, so a particularly bad BPF
scheduler can make the system barely useful.

What's the acceptable level of service for MM?

Given how critical MM is to the functioning of the system, it's hard to
guarantee the system stability without sacrificing the flexibility.
The trivial example: if we allow BPF OOM handler to do nothing and let
the system deadlock on memory, is it still acceptable? And if not,
how to implement the safety guarantee? One way is to add a layer of kfuncs
which limit what bpf can achieve and also record what it does. E.g.
bpf programs are allowed to kill processes only using a special helper
and a bpf program has to invoke it at least once. But it's complicated
even for the OOM handling, for hotter paths adding such layer will likely
come with an non-acceptable performance overhead.

Scheduler-like time-based fallback is also not easily applicable:
MM has historically had no notion of time, relying on refault distances,
LRU length, ratio of scanned vs reclaimed pages etc. So time-based
fallback mechanisms will not work well without more systematic changes.

In MM, it's usually not trivial to determine if things are really off
(even without BPF). The kernel historically has trouble deciding when
it's actually time to invoke the OOM killer. The effectiveness of,
for example, a specific readahead implementation or a certain reclaim
policy is not trivial to measure, yet it is even harder to draw
dynamically calculated acceptance criteria which can be calculated
with an acceptable overhead. If things are mildly off, it can be
considered a sub-optimal performance. But if a faulty bpf program
is leading to heavy trashing, how to make sure the system ends up
unloading the bpf program instead of killing all userspace programs?

And to make things worse, BPF itself can't be totally isolated from
relying on MM. BPF maps are backed by slabs and/or vmalloc's. How we can
make sure there are no circular dependencies and associated memory leaks?

--

It seems obvious at this point that there is a huge potential and a lot
of interest in using BPF in MM. Answering questions above seems to be
required to get the initial adoption. But I bet adding more use cases
will go faster and smoother.

