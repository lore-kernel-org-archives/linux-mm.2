Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13940C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132D56B0088; Thu, 24 Sep 2026 11:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3C06B008A; Thu, 24 Sep 2026 11:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BD96B0092; Thu, 24 Sep 2026 11:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE7C86B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:46:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F189A042A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:46:18 +0000 (UTC)
X-FDA: 85249082436.17.8F47BD8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf17.hostedemail.com (Postfix) with ESMTP id 72E0340007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:46:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RDdrIsSO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790264776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB5IToX1mrhtHSOFBF5/UhvzwKQBZ1KaprAe4S6LDUA=;
	b=2UpQHXcQlPm3dwfAegfDcrKkxS9/nKVw/NRkpKkwncI1QpbJVkXte/LHDK+y00zstA5eXf
	GJ/MzO1NIXxdwEiw17Pdox8T/R1W1HFUjVWhCd3DsS/AGQn5M3B4jRTILKfyYbHBzG32va
	SGaAwJaWgc6f7KYB8ETaITkB1b6dYEw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RDdrIsSO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790264776;
	b=SdssM3BKWqc4nPk4luEbN/TaN9OZ5CwCgFsLmyJyxv/90ppN6a+PJTuCHXVijNnI5ZNVne
	01D7b5MLOxcnbin/OVkGOg3UNooySRVP7a2c8c8soR+Xe1PD4MdXDt223B/HMM2Xzwyb+A
	vQnFHpxc44lSwUywqGaqMtk3vIDdT0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790264775; x=1821800775;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=nebAgd+oc/9pxolDcsX4SlSOFmTaJAYhDJSCFrW8+R4=;
  b=RDdrIsSOs3kbk2UhAwHQFXFwo/gySfyKRHkgLhpCVpRwn1Pik+FcT8KE
   3zuAcqwAI/nO7SQjKlZqNhh6nqsGuiBYuxarEWo9hiiuM9vmjMmfWoY/t
   3FgSIUyAhgOjAYVfnakBPeSDG5N3bolGgi8yvkMaIYO/mEw9Bs/mLV8wU
   21my8+IUKhb2VDk6kZAs8SRWjZwFAXGXrWrTgPTLX1uWHEk3CbpzZGVpf
   9vGUcFFzSZUr0KUMSQQn9BA8Lycwu3n74ZUAERSiSEiPhshEPpk3J+ij4
   PrigAXVrSe7SJ+1sH26ZXdyAXa2C6cMvAce8kw2xh2/48l3J6n9yiEKeS
   Q==;
X-CSE-ConnectionGUID: ULidfHilTNyq/MwV6QJQ+w==
X-CSE-MsgGUID: MpbEz5xzQfCFQkzP2n2vXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89811274"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="89811274"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:46:14 -0700
X-CSE-ConnectionGUID: Cs0jxIVAQDC3lXFF74IA6A==
X-CSE-MsgGUID: XnPMUumxS8SuMKgym8GSGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="273283537"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.110.190]) ([10.125.110.190])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:46:12 -0700
Message-ID: <112e526b4013e23c70adf5b8883db8e75358b473.camel@linux.intel.com>
Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jianyong Wu <wujianyong@hygon.cn>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu
 <yu.c.chen@intel.com>, Dietmar Eggemann	 <dietmar.eggemann@arm.com>, Steven
 Rostedt <rostedt@goodmis.org>, Ben Segall	 <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider	 <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Phil Auld <pauld@redhat.com>, Andrew Morton	 <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,  "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
 "jianyong.wu@outlook.com"	 <jianyong.wu@outlook.com>, Yuan Zhong
 <zhongyuan@hygon.cn>, Huangsj	 <huangsj@hygon.cn>, Fengyu Wang
 <wangfengyu@hygon.cn>, Zhiwei Ying	 <yingzhiwei@hygon.cn>,
 "justin.he@arm.com" <justin.he@arm.com>
Date: Thu, 24 Sep 2026 08:46:11 -0700
In-Reply-To: <f6ebab3d0e44412dad17ac64a3b93339@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
			 <20260827122816.756234-3-wujianyong@hygon.cn>
			 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
		 <da32ba66d95fd88869ba052f97698b9a4d6c3dc6.camel@linux.intel.com>
		 <09261c8222994a41a04ace5f342475df@hygon.cn>
	 <ce95ec57af9dfaf4d9ed604ad7337441a543f538.camel@linux.intel.com>
	 <f6ebab3d0e44412dad17ac64a3b93339@hygon.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: 7racwa9mmb8hoktuez6an7csskqfanq9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72E0340007
X-HE-Tag: 1790264775-499489
X-HE-Meta: U2FsdGVkX1/yBneEzT4TJpoqQynO1tRABcRbb4v6C8Qzk8A0v3nDziYzLUC6x22SOAGVv/zQJPSm0WWiIz4unSdfWksFrJ7zvm9ux106SmxOAyh/x9+uYcX8NLcfRzypMve7onHoTiL6+gnDbpLX+VYUkJ0t6UobLULKDSHd6ff+oiwYa3FisUD50xDgdw76pHDH1wuJxuIXz3WaneLxzPHvvAhYY6L7bdhhrDns+99DrjQYGuRc4Egvba1BaVDGGX6XcG/07oChy8WekLRzZBPUhuEMcfaO2EF0fAj1CtGUpxIbL2VPttRirfp78JNd54+E342OKQDTR7puvOwFdgwZczaxiMdHUUjQzOlp16z/3h1aVxRTRhpJx/x3bK0JFyDo45RMF4jEneJjVaMYuSq0R8oCQA0bDPPzWMSl9xXLUAOTnCk0dRV2J5hzLgcKRdUvG5dPqMFXiBVjZJr/YMVmfbeGcLTutFY0ha3kVk+KzAhiD+9vXWfsNmAMpz8tWbI/B+bCiuBEWdwIN34jvVvJ/T987YRVhVbEAL11QENaDpIeWnmTUjx/qEqBRvSU2LecsWd1IGOMjmSSNDzjx5De4w17kMPH1cTwVlX1NeG/6/ooOlDrrllwuTzXpPxKnpA28P4JxIgH80wBK8aWNTNgOwF0TZtBQEJ46p0d39CkPGD1DhdYfs/CIq9pjn7IFZIFm8WMHquP3EXgFdUs/zH5OQ4Fxfe9U8UWMj1HzSgMs1tU8BuAmvkHzueUhz4ShT0VkXZELiZy15IgcjZbGP1uOE92GLRU0XB2YHYerehEALxK6zDvkHMLZjAs2D6Q+5QNuxc77sNMKF4f11mKxjEwh/y0SFW/EGGx3fHdAoUJ2zg1S4OT02TQrr4J51DsjlP4gaYCTMu18S4EsqxWy3iejZYnjWzPNOwd/Ebt5LzEU/4z5aibvSTehaWVXCHO7utEBQM2i8lmqIIpXH7
 p3NqLPbS
 SlUlM5MHHtEr4NK4Co/+ygd66JJNmtMw2yuJArM1sVvqj3eqXGCeMLGLM4gdKD6KDOSzXSLvb3IigciD8hiC/+QPKUV25cFJBIc2OmdeYBJhPIAoJq4daCO/4t8gRQpTn66RaQvfFIQzQ8GpKI75OkjQy8vQjvj0l79kc7NGsiIH516bKecc+kTdtBfwopcZc5axfIsF8jY2xt22e7KpkKRA9jwji1Zu472/WuSR2Eb+Q7mPp/UusZOhkTPQYBmk9amj9Euj6Ar5P0sEv/xxfqyoIRyuJn4saY11nWMNoS2pDNvtfXWmfDNK9GYdFuudW49NJlqc3mVM2gqFWaWxYjcMetHk0MXngS/U+/QkZj6BBNMprVp+j2DlsfMo+0XlN9eS4LTfkI2SdVitpwBCSwinf1wjTCMesaNQB6kA5yEE6lOJ5hxnI0o0x6+7wkRFCEUWcdnTXVGj/CI2vQAFnWrJ7xhRtOgPbYwwmhQ8ruxmKniC9q2SD/SJElXes0gdMHCEHY+hn0gXbUiEDePuzzT3GcMDFPvPCopbchQ0hWOjsRTWkhbg9LgbPQTN8724tWNjhcOUaPXhevkRoGLTtKjgMxuvSJODtX8McMIYrA8K2ZqU7RJKb45eSEhM6t6gkBEhe3p7cjw/1uUO8QAm76ob/Lah40BKO9CFp/d2RE/PFxY+jP2SQC5B+eRyVQkxbjB2Qr5mes5LQRgnTqIa9LeYoFd48oe9gIqEf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-24 at 05:41 +0000, Jianyong Wu wrote:
> Hi Tim,
>=20
> > -----Original Message-----
> > From: Tim Chen <tim.c.chen@linux.intel.com>
> > Sent: Thursday, September 24, 2026 2:29 AM
> > To: Jianyong Wu <wujianyong@hygon.cn>; Peter Zijlstra
> > <peterz@infradead.org>
> > Cc: Ingo Molnar <mingo@redhat.com>; Juri Lelli <juri.lelli@redhat.com>;
> > Vincent Guittot <vincent.guittot@linaro.org>; Chen Yu
> > <yu.c.chen@intel.com>; Dietmar Eggemann
> > <dietmar.eggemann@arm.com>; Steven Rostedt <rostedt@goodmis.org>;
> > Ben Segall <bsegall@google.com>; Mel Gorman <mgorman@suse.de>;
> > Valentin Schneider <vschneid@redhat.com>; K Prateek Nayak
> > <kprateek.nayak@amd.com>; Shrikanth Hegde <sshegde@linux.ibm.com>;
> > Phil Auld <pauld@redhat.com>; Andrew Morton
> > <akpm@linux-foundation.org>; David Hildenbrand <david@kernel.org>;
> > linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > jianyong.wu@outlook.com; Yuan Zhong <zhongyuan@hygon.cn>; Huangsj
> > <huangsj@hygon.cn>; Fengyu Wang <wangfengyu@hygon.cn>; Zhiwei Ying
> > <yingzhiwei@hygon.cn>; justin.he@arm.com
> > Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA
> > distance matrix with unique distance values
> >=20
> > On Wed, 2026-09-23 at 03:14 +0000, Jianyong Wu wrote:
> >=20
> > [snip]
> >=20
> > > > >=20
> > > >=20
> > > > I think what we really want is an ordering of caches within
> > > > the same NUMA node.  So when one cache is full, we can
> > > > pick the next one down the list.  That is essentially the
> > > > net effect of the distance de-duplication.
> > >=20
> > > The goal of this series is to provide a system-wide LLC affinity
> > > ordering, rather than only an ordering of the LLCs within one NUMA
> > node.
> > > Maintaining one large system-wide LLC ordering would be expensive, so
> > > the ordering is represented hierarchically: a NUMA-node-level affinit=
y
> > > ordering, followed by an LLC-level ordering within each node.  This
> > > patch only deals with the NUMA-node-level part.
> > >=20
> > > >=20
> > > > So how about introduce a llc_next array.  We will initialize
> > > > the array such that it will return the next LLC in
> > > > the NUMA node.  So for the example that Peter has above,
> > > > assuming C0 maps to LLC id 0, C1 maps to 1, etc.
> > > > then llc_next is
> > > >=20
> > > > 	    c0 c1 c2 c3 c4 c5 c6 c7
> > > > llc_next =3D [1  0  3  2  5  4  7  6]
> > > >=20
> > > > When we come back to the orginal LLC we start off with,
> > > > we know that it is time to move on to a LLC in next closest
> > > > NUMA node.
> > > >=20
> > > How should the next closest NUMA node be selected when multiple
> > nodes
> > > have the same distance from the current node?
> >=20
> > You could use some other means like node id or load in the node
> > if there's a tie in distance.
> >=20
> > >=20
> > > That is the ambiguity this patch is intended to resolve. For each
> > > source node, it disambiguates equal NUMA distances and produces a
> > > unique node-level affinity ordering. An llc_next array can describe
> > > the traversal of LLCs within a node, but it does not determine which
> > > equidistant NUMA node should be visited next.
> > >=20
> >=20
> > Agreed that llc_next only covers intra-node traversal and that you stil=
l
> > need an inter-node order for the equidistant case. But I think
> > sorting each source node's row by (distance, node_id)
> > already gives a stable total order; the node id breaks the tie. You can
> > also break it by node load if you'd rather balance than pin. Either way
> > no new distance value has to be invented.
> >=20
>=20
> Yes, using (distance, node_id) pairs is a straightforward way to order no=
des,
> similar to the memory zonelist fallback node sequence. I once considered
> adopting this approach, but dropped the idea after realizing it lacks
> symmetry.=C2=A0
>=20

Ordering symmetry can be resolved by looking at (distance, abs(node_id_i - =
node_id_j)).

> For instance, node_affinity_distance(A, B) is not guaranteed to equal
> node_affinity_distance(B, A).

node distance is symmetric if you don't modify it.

>=20
> The dedup algorithm can enforce this symmetry property for the resulting
> node=E2=80=91distance matrix.
>=20
> > > > This will be storage efficient and more straight forward
> > > > to use than maintaining an artificial cache distance matrix.
> > > >=20
> > > > I dislike the artificial distance matrix also for the
> > > > reason that there is no guarantee that there are enough
> > > > available distance slots between two nodes.  Say if I
> > > > start with
> > > >=20
> > > >         NODE0  NODE1  NODE2  NODE3
> > > > NODE0   10     20     20     30
> > > > NODE1   20     10     20     25
> > > > NODE2   20     20     10     20
> > > > NODE3   30     25     20     10
> > > >=20
> > > > and there are 16 LLCs in NODE 1, I will run
> > > > out of slots when I try to deduplicate as
> > > > only 10 slots are available to fit 16 LLCs.
> > > >=20
> > >=20
> > > There is no system-wide LLC distance matrix in this series. The
> > > de-duplication is applied only to the NUMA-node distance matrix.
> > > Consequently, the number of LLCs in NODE1 does not affect the number
> > > of distance values required by this patch.
> > >=20
> > > The algorithm also takes the available distance space into account
> > > when assigning the refined node distances. It does not simply insert
> > > one value for each duplicate into the existing gap between two
> > > original distance levels. The distance values are adjusted as
> > > necessary to reserve enough space before the duplicates are assigned.
> > > Therefore, the algorithm cannot run out of available distance values,
> > > regardless of the number of nodes sharing the same original distance.
> > >=20
> >=20
> > Fair - you're right that the dedup is node-granularity, so my 16-LLC
> > example doesn't apply as I stated it, and I'll drop that objection. It'=
s
> > moot anyway under the argument below: if the ordering uses raw distance
> > plus a tie-break, and the score uses raw distance, then there's no matr=
ix
> > to pack in the first place and the "enough slots" question disappears.
> >=20
> > > In addition to providing the node-level component of the LLC affinity
> > > ordering, the refined node distances are used to calculate the
> > > affinity improvement score when selecting a source scheduling group
> > > or runqueue during load balancing. Please see patch 12 for that usage=
.
> >=20
> > This affinity computation is where I think the dedup actually hurts rat=
her
> > than
> > helps. The score in patch 12 is
> >=20
> >     Di =3D dist(src_node, i) - dist(dst_node, i)   (kept only if Di > 0=
)
> >     p  =3D sum_i  numa_counts[i] * clamp(Di, 4, 1024)
> >=20
> > so it reads the distance *magnitude*, not just the order. Feeding it th=
e
> > refined values manufactures gains on exactly the node pairs the dedup
> > perturbed - the equidistant ones. Using your node matrices:
> >=20
> >     raw:                          refined:
> >           N0  N1  N2  N3                 N0  N1  N2  N3
> >     N0    10  20  20  30           N0    10  15  20  30
> >     N1    20  10  20  25           N1    15  10  12  25
> >     N2    20  20  10  20           N2    20  12  10  15
> >     N3    30  25  20  10           N3    30  25  15  10
> >=20
> > Scenario A - a locality-neutral pull gets a fabricated gain.
> > Dest CPU on N1, source rq on N0, 5 tasks preferring N2:
> >=20
> >                   dist(N0,N2)  dist(N1,N2)  Di   contribution
> >     raw           20           20            0   5 * 0 =3D  0
> >     refined       20           12            8   5 * 8 =3D 40
> >=20
> > N0 and N1 are physically equidistant from N2 (both 20), so pulling thos=
e
> > tasks to N1 buys zero locality - raw correctly gives 0. Refined scores =
it
> > 40 and the balancer may drag all 5 over chasing a gain that isn't there=
.
> >=20
> > Scenario B - two physically identical options get fake-ranked. Dest on
> > N1; candidate sources N0 and N3, each holding only N2-preferring tasks:
> >=20
> >                   raw Di   refined Di   after clamp(.,4,1024)
> >     X (N0)        20-20=3D0  20-12=3D8      8
> >     Y (N3)        20-20=3D0  15-12=3D3      4
> >=20
> > Raw Di says both are 0, i.e. locality-equivalent, and load should decid=
e.
> > Refined ranks X over Y purely from invented deltas - and the clamp floo=
r
> > even promotes Y's fabricated 3 up to 4.
> >=20
> > Note the dedup only ever perturbs ties, so the skew is confined to
> > equidistant pairs - which is exactly the case where there is no real
> > locality difference and load should have been the tiebreaker.
> >=20
>=20
> My intention is to distinguish equal node distances and give a definitely
> task move direction.=20
> What we want to do is aggregate task to as small area as possible. If N2 =
is
> Preferred node, and N2 is saturate, N1 is the next node of N2 in the
> affinity node order, it's natural that prefer N1 than N0 for task aggrega=
tion,
> right? Thus, we should give weight for task in N0. So N0 is more likely t=
o be
> chosen and migrate task to N1. Consequently, the task can more likely
> aggregate to N1 and not evenly spread in the two nodes.

I think you should get true affinity metric based on real distance. Bias ba=
sed on node
property can be applied separately and a easily controlled manner. =C2=A0Th=
at has the advantage
of setting the bias based on factors like load or others.

It is a bad design to have to tune a hacked up
distance to change the bias.  It is hard to control
the magnitude of the bias and use a similar and consistent
bias with the current approach. The distance you inject to
disambiguate is not the same from node to node.

> =20
> Also, give a preference between N0 and N1 can limit the task migration fr=
om
> N1 to N0. By this way, we can achieve the goal that keep tasks inside N1.
>=20
> > Stepping back, the matrix is being asked to do two jobs at once:
> >=20
> >     - ordering: only needs a deterministic total order, which
> >       raw distance + node-id tie-break already provides;
> >     - scoring: wants true magnitudes, which raw distance also provides
> >       (equidistant =3D> Di =3D 0).
> >=20
> > The dedup is only necessary if one matrix has to serve both - and that
> > coupling is precisely what injects the fake Di. So if you need a node
> > ordering, I'd use the unaltered distance and break ties by some other
> > means (node id, or load), and feed the score the raw distance too.
> >=20
>=20
> Yes, the refined node distance serves both purposes mentioned above. Henc=
e,
> dedup is necessary for this patch series.
>=20
> Both affinity=E2=80=91score calculation and migration control rely on a c=
onsistent
> refined node distance matrix. To keep this consistent, we should avoid us=
ing
> the default node distance for one objective while adopting a different
> variant for another purpose.
>=20
> The only open design question is whether symmetric node distances are
> strictly required. Symmetry is preferable but adds implementation
> complexity, so this represents a trade=E2=80=91off. If symmetry is unnece=
ssary,
> I can construct the node order following your approach using the
> (node_distance, node_id) pair, which is significantly simpler than my
> current implementation.
>=20
> Your question touches on the trickiest part of this patch series.=C2=A0
>=20

I think the design can be much simplified if you don't have to invent a new
distance matrix.

Thanks.

Tim

> I'm
> not sure I've answered your question clearly, though this discussion
> has prompted further thinking from me. Thanks Tim.
>=20
> Jianyong
>=20
> > Tim
> >=20
> > >=20
> > > Thanks
> > > Jianyong
> >=20
> >=20

