Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A4BCD0421
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 05:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878686B008A; Tue,  6 Jan 2026 00:25:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A0E6B0093; Tue,  6 Jan 2026 00:25:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75BE86B0095; Tue,  6 Jan 2026 00:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 635DD6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 00:25:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFB461403C6
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:25:50 +0000 (UTC)
X-FDA: 84300402060.24.19DEE58
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id B15F640002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:25:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="IbmOCT/e";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767677149; a=rsa-sha256;
	cv=none;
	b=XZ8+I1EAOfdFdKKP9BMze1YPtMCsHi0JlRVvyJK88ODjeFltkf3rBWk5NylsLw+csKrIJ+
	xodAA1safc2/yHpDiRaw03tTAJZ8tPrR4upCDS/LJCxnfk8uHGeEPLqYN2nrXigpr2YiwX
	jKbOFsfKP0c39/tRKy9/J3M8gAtU2WI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="IbmOCT/e";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767677149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qScMDy8mz80NZ8SjOwgc1YriWtALcRcs1IwrYU/jNo=;
	b=RRLpHvLYMuhmieTDw/hInJ7AtpL5lJIyoArEjTha2Ivm7qkpKmV0EHkvFU/XiXRsd2wi1u
	bCi8QgDL2w+kzWAnI18NsLCE9fubtOoRqMEr87UQZmCHQMdkatt89FQBobYINzWXxMIgmz
	OtP5Qzv+eo8wzyVN5Wa+hxn+sW0PsSY=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767677144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/qScMDy8mz80NZ8SjOwgc1YriWtALcRcs1IwrYU/jNo=;
	b=IbmOCT/e8a1pAevtWnDiO6JIJGso9sPNLtpDd2GQpMzpGtPvsaxNapWBckGntWrwF+EjKz
	rONtdvkzcnMOQLXpP4iNDMQlSchWAyj/5Sq9QOtOV6tBm7uD3n5M9z9wD6uthI1S/QwHtF
	k70TruFeqtl9143WknkiV2egqDB7pUM=
Date: Tue, 06 Jan 2026 05:25:42 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
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
In-Reply-To: <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B15F640002
X-Rspamd-Server: rspam03
X-Stat-Signature: f4rizz8zt3jpiini1x5z39dwqshnsm5y
X-Rspam-User: 
X-HE-Tag: 1767677148-808921
X-HE-Meta: U2FsdGVkX18aPsw5qRAGMb+3EkuYJGWB+EH05ULgIxzYaePOjlspnoeCrsmMB6sg6SrqYcgc27jLN0sekO07s+piMqeVwQG3Ao8D3VV1Atbr6aWroSCq8RkcFN3afsSYEjS+xiHUuppT83kdwJ+CzdEY6sReFrKqLS6fhOcvnKZjnzlGplubGo1Osk5qmJl4bITPpji2BE6txBjt8lA1M+tLMNu7KQOjTH/msqTePAC8foAqxyYsdjX1MzAiRJB0Z69MD3Kh0+rEbGoGZYaVTKJI4UUSJyWL/QRJAPM3L4jRi4XG4JMuG4PGnZ73kNyIWZ0uR13T1Hay56u5i8GMha5oe2U2dtijBW3hG6tDo6Er0BHH1uoTLwyBhRpXR9Xb6QKtFCM+IEZgk3ZE7VtX3qScC+u3pG5r83MJAjCOm+fYKWqAFMOVcrHqHuSscz0T8ZzsRvaVaCamfZIixVEL7p/3KwEU2gWl16rxIoh2PFNe2QcDJ9kSvRqT7OMP8sLoeqQ37s1TnblQict1zy+b00nBuIRIrnO2YKrCbhFBMukWIxl3cRM+RhTfosBa9DW6EK3TcsTWOWsIvW7svLNpmAG/+sCQlfCYng2b7bD1LQd7snAPfqHWy/DW4znjc34VQ5rMGARTT7p3akFn/J7muOTSOVZpWJ2D+/62oOs8CpFAAjeUL+Ez5ayUWiAjfpn10MAAz5VYq1E8j2NKd4h71DNxgoeNd8w91ftN2dBBToxixOcYeQ3GfF1ZceX/DUIyQeceYYE7VeIeC1FykhLXDq1ey8ivjU6ubtDlVBgtbJgjvLVnPSOTSOXjG0CcSs/ajPw+/ktUg7CHNp9sq2Zk+DrYf1xwRVFcmzV3AXXUqYa9HDRf8IYFb0fpkN7A24UOoFYMciVf/xorXFw7Rx1E+PrzDgbFxABFhz5xPqY9TCBl/GGz73FuRB2Cxg9ylzvqi+Fh8axRNjBwJHkx1r6
 8BdbvbuW
 OEIaPs4CwWVicpS731ncf/3QAi8jkAp+VnRhh/ZH0pd3RFWvtiKU2oSmyqFMblVL8PQuDqIAk1KAmrkaHzi2QcWiKIlOvbF0K4Kyy5jJJGcRBEdO0ZDOeo8dqdUkVRFmk5/dHfWGA+FsM7dMVG+Y5A7BMXQhW1Iheo5i8qJIT5tK9DQs5oAcflpkRkLKFu5MkDbnDow0OB2xTXXwZDbD80HgHAbhsepeOi/+H7Fs9YxwHqcA/wvIy966EKTdq83dj4PgLsEm58DlvfxjPSKe7uoQHR6/3IG7EO3kM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 5, 2026 at 12:51, "Shakeel Butt" <shakeel.butt@linux.dev mailto:s=
hakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux=
.dev%3E > wrote:


>=20
>=20Hi Jiayuan,
>=20
>=20Sorry for late reply due to holidays/break. I will still be slow to
> respond this week but will be fully back after one more week. Anyways,
> let me respond below.

No worries about the delay - happy holidays!

> On Tue, Dec 23, 2025 at 08:22:43AM +0000, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> December 23, 2025 at 14:11, "Shakeel Butt" <shakeel.butt@linux.dev =
mailto:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt=
%40linux.dev%3E > wrote:
> >=20=20
>=20>=20=20
>=20>=20=20
>=20>  On Tue, Dec 23, 2025 at 01:42:37AM +0000, Jiayuan Chen wrote:
> >=20=20
>=20>  >=20
>=20>  > December 23, 2025 at 05:15, "Shakeel Butt" <shakeel.butt@linux.d=
ev mailto:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.b=
utt%40linux.dev%3E > wrote:
> >  >=20
>=20>  [...]
> >=20=20
>=20>  >=20
>=20>  > >=20
>=20>  > I don't think kswapd is an issue here. The system is out of memo=
ry and
> >  > most of the memory is unreclaimable. Either change the workload to=
 use
> >  > less memory or enable swap (or zswap) to have more reclaimable mem=
ory.
> >  >=20
>=20>  >=20
>=20>  > Hi,
> >  > Thanks for looking into this.
> >  >=20
>=20>  > Sorry, I didn't describe the scenario clearly enough in the orig=
inal patch. Let me clarify:
> >  >=20
>=20>  > This is a multi-NUMA system where the memory pressure is not glo=
bal but node-local. The key observation is:
> >  >=20
>=20>  > Node 0: Under memory pressure, most memory is anonymous (unrecla=
imable without swap)
> >  > Node 1: Has plenty of reclaimable memory (~60GB file cache out of =
125GB total)
> >  >=20
>=20>  Thanks and now the situation is much more clear. IIUC you are runn=
ing
> >  multiple workloads (pods) on the system. How is the memcg limits
> >  configured for these workloads. You mentioned memory.high, what abou=
t
> >=20=20
>=20>  Thanks for the questions. We have pods configured with memory.high=
 and pods configured with memory.max.
> >=20=20
>=20>  Actually, memory.max itself causes heavy I/O issues for us, becaus=
e it keeps trying to reclaim hot
> >  pages within the cgroup aggressively without killing the process.=20
>=20>=20=20
>=20>  So we configured some pods with memory.high instead, since it perf=
orms reclaim in resume_user_mode_work,
> >  which somewhat throttles the memory allocation of user processes.
> >=20=20
>=20>  memory.max? Also are you using cpusets to limit the pods to indivi=
dual
> >  nodes (cpu & memory) or they can run on any node?
> >=20=20
>=20>  Yes, we have cpusets(only cpuset.cpus not cpuset.mems) configured =
for our cgroups, binding
> >  them to specific NUMA nodes. But I don't think this is directly rela=
ted to the issue - the
> >  problem can occur with or without cpusets. Even without cpusets.cpus=
, the kernel prefers
> >  to allocate memory from the node where the process is running, so if=
 a process happens to
> >  run on a CPU belonging to Node 0, the behavior would be similar.
> >=20
>=20Are you limiting (using cpuset.cpus) the workloads to single respecti=
ve
> nodes or the individual workloads can still run on multiple nodes? For
> example do you have a workload which can run on both (or more) nodes?

We have many workloads. Some performance-sensitive ones have cpuset.cpus =
configured to
bind to a specific node, while others don't.

> >=20
>=20> Overall I still think it is unbalanced numa nodes in terms of memor=
y and
> >  may for cpu as well. Anyways let's talk about kswapd.
> >  >=20
>=20>  > Node 0's kswapd runs continuously but cannot reclaim anything
> >  > Direct reclaim succeeds by reclaiming from Node 1
> >  > Direct reclaim resets kswapd_failures,
> >  >=20
>=20>  So successful reclaim on one node does not reset kswapd_failures o=
n
> >  other node. The kernel reclaims each node one by one, so if Node 0
> >  direct reclaim was successfull only then kernel allows to reset the
> >  kswapd_failures of Node 0 to be reset.
> >=20=20
>=20>  Let me dig deeper into this.
> >=20=20
>=20>  When either memory.max or memory.high is reached, direct reclaim i=
s
> >  triggered. The memory being reclaimed depends on the CPU where the
> >  process is running.
> >=20=20
>=20>  When the problem occurred, we had workloads continuously hitting=
=20
>=20>  memory.max and workloads continuously hitting memory.high:
> >=20=20
>=20>  reclaim_high -> -> try_to_free_mem_cgroup_pages
> >  ^ do_try_to_free_pages(zone of current node)
> >  | shrink_zones()
> >  try_charge_memcg - shrink_node()
> >  kswapd_failures =3D 0
> >=20=20
>=20>  Although the pages are hot, if we scan aggressively enough, they w=
ill eventually
> >  be reclaimed, and then kswapd_failures gets reset to 0 - because eve=
n reclaiming
> >  a single page resets kswapd_failures to 0.
> >=20=20
>=20>  The end result is that we most workloads, which didn't even hit th=
eir high
> >  or max limits, experiencing continuous refaults, causing heavy I/O.
> >=20
>=20So, the decision to reset kswapd_failures on memcg reclaim can be
> re-evaluated but I think that is not the root cause here. The


The workloads triggering direct reclaim have their memory spread across m=
ultiple nodes,
since we don't set cpuset.mems, so the cgroup can reclaim memory from mul=
tiple nodes.
In particular, complex applications have many threads, different threads =
allocating and
freeing large amounts of memory (both anonymous and file pages), and thes=
e allocations
can consume memory from nodes that are above the low watermark.

You're right that multiple factors contribute to the issue I described. T=
his patch addresses
one of them, just like the boost_watermark patch I submitted before, and =
the recent patch
about memory.high causing high I/O. There are other scenarios as well tha=
t I'm still trying
to reproduce.

That said, I believe this patch is still a valid fix on its own - resetti=
ng kswapd_failures
when the node is not actually balanced doesn't seem like correct behavior=
 regardless of the
broader context.

> kswapd_failures mechanism is for situations where kswapd is unable to
> reclaim and then punting on the direct reclaimers but in your situation
> the workloads are not numa memory bound and thus there really is not an=
y
> numa level direct reclaimers. Also the lack of reclaimable memory is
> making the situation worse.


> >=20
>=20> Thanks.
> >=20=20
>=20>  >=20
>=20>  > preventing Node 0's kswapd from stopping
> >  > The few file pages on Node 0 are hot and keep refaulting, causing =
heavy I/O
> >  >=20
>=20>  Have you tried numa balancing? Though I think it would be better t=
o
> >  schedule upfront in a way that one node is not overcommitted but num=
a
> >  balancing provides a dynamic way to adjust the load on each node.
> >=20=20
>=20>  Yes, we have tried it. Actually, I submitted a patch about a month=
 ago to improve
> >  its observability:
> >  https://lore.kernel.org/all/20251124153331.465306a2@gandalf.local.ho=
me/
> >  (though only Steven replied, a bit awkward :( ).
> >=20=20
>=20>  We found that the default settings didn't work well for our worklo=
ads. When we tried
> >  to increase scan_size to make it more aggressive, we noticed the sys=
tem load started
> >  to increase. So we haven't fully adopted it yet.
> >=20
>=20I feel the numa balancing will not help as well as or it might make i=
t
> worse as the workloads may have allocated some memory on the other node
> which numa balancing might try to move to the node which is already
> under pressure.

Agreed.

> Let me say what I think is the issue. You have the situation where node
> 0 is overcommitted and is mostly filled with unreclaimable memory. The
> workloads running on node 0 have their workingset continuously getting
> reclaimed due to node 0 being OOM.

From our monitoring, only a single cgroup triggered direct reclaim - some
hitting memory.high and some hitting memory.max (we have tracepoints for =
monitoring).

> I think the simplest solution for you is to enable swap to have more
> reclaimable memory on the system. Hopefully you will have workingset of
> the workloads fully in memory on each node.
>=20
>=20You can try to change application/workload to be more numa aware and
> balance their anon memory on the given nodes but I think that would muc=
h
> more involved and error prone.

Enabling swap is one solution, but due to historical reasons we haven't
enabled it - our disk performance is relatively poor. zram is also an
option, but the migration would take significant time.

Thanks

