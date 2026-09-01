Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2700C624D1
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E9E6B00BD; Tue,  1 Sep 2026 03:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7706B00BE; Tue,  1 Sep 2026 03:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBFD6B00BF; Tue,  1 Sep 2026 03:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81A726B00BD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:37:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB060C0370
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:37:35 +0000 (UTC)
X-FDA: 85164388470.13.2798199
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8DCB020004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:37:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf31.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788248253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idrQ73kwv4S5/0jMgAlSIU6uQg9mX3ir4nWJY+LoBS4=;
	b=jG5fCUaH4/2qQ9i+XH232XiKG480pm7YP756l1eFfqFHumCbVWjZTXWkys2MtapVNSELls
	RuPj4Q1MaZ/XuSewCdKKpEJK87pqYR2p5wwRfGfiFqwzjRjRLPgxxDI3hSEOCFgzYSlzj6
	b+funNDPz6SV51LqjD9N6U8z1sGCbfk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf31.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788248253;
	b=hHYYLfYbNuHrsdHdiUWd6vd9ksrbgX9mRSmnPwAP9l7nMBJRxerw306rdzE1p/199pblnY
	Mr6gpoEb3v13gABU5sd4O2ciij49gR3tJrMpa0303jCwm2eY5BMxPfGbU9hMGQTVRj60PK
	TuBhZiPQpHNTAi9Qawn0V3xPT9KnKts=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYyPM5ShSz1PvqX;
	Tue,  1 Sep 2026 15:37:27 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYyPM24Chz1PGD2;
	Tue,  1 Sep 2026 15:37:27 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 7F17E31F55DC;
	Tue,  1 Sep 2026 15:33:36 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 15:37:28 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 15:37:28 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>, Dietmar Eggemann
	<dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall
	<bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
	<vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, Phil Auld <pauld@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "jianyong.wu@outlook.com"
	<jianyong.wu@outlook.com>, Yuan Zhong <zhongyuan@hygon.cn>, Huangsj
	<huangsj@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>, Zhiwei Ying
	<yingzhiwei@hygon.cn>, "justin.he@arm.com" <justin.he@arm.com>
Subject: RE: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Topic: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Index: AQHdNiA3jheQVPdvikWpN4gB9aTKG7a3i1wAgACO1RCAALYwAIAAigwQ
Date: Tue, 1 Sep 2026 07:37:27 +0000
Message-ID: <c1c4cf3afa434a3e90768444e57703d9@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-3-wujianyong@hygon.cn>
 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
 <ee97dce1db374f50b8e87e51ad133d96@hygon.cn>
 <20260901071322.GX687043@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901071322.GX687043@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: z16rom9z9qkxgeq7bcqz3e8yew63caqk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8DCB020004
X-Rspam-User: 
X-HE-Tag: 1788248251-597376
X-HE-Meta: U2FsdGVkX18CjvOWb3rj+Xc+kkK58D/HARYdAYdLWN12hkTeYhT42KnpHOyiRKaAkV1lUYX3uJ3DNcoMUoT/4XymgCChvcc35h4Qb/xHiHw8ThzSZ2pW8KUAEqsXlGdloC3KmRMh/jAs/ccicTs8oRUbL4Sa1ejOdA/0ZRJmcyEtW/UECln+aXm9A592UOByWfYNzCFzFn1P9umDMTd/mdg3nAL8HUCcm35WSLCYZ9Iu/MwAz/zCJyxKpW8VWsQCPFLXiATw7fTLWaegsSKnCRsxBTRfbAIsQbXpkr7qlSfXq4V0NSTiAlSTbS+q5OPUh1IfFdMSmCZ39X+z3L2Yo1JxTBWrTsag4cvZciRpKOlzRFTtLobRmKjtlnc025H5gorTo3pgAg+mqkyrBaqG9Ot8kr5LJY0t2fD6+SqBbGpVTrB+HLOq/CRMiQc1AYFhzRBK3kW/MnJAlDpSfK1cqTZB26WVh/9qXLnGeKerdjwgmqc21aWxgXUgCkCVa5JJ58MWFLt8Iq8s2XJgPMRJlpV2XY7SE07smEE6S7zfN6S82UDAu6+wJzH2hCNSxLlCVXh7/xnplB1Sraa5jKFkhTqWwy74Br+V13U1Tlp7+0qBBAPjyEws6k+KE4h0Sl7ul/SBhi2fRNR0/JeUPMZV4Fcmx193f3iZJ2l7ZUfnNsQ7n5ZK6ZLwj1qyKWYksMNqEQjzmWoyWIClfcW0PDXHNY1Ml9cAQRvZcUSv3iOE09NXb7ZU8HOaOHJMa3nYLV64M/syOa5F6494DyqyqNBEbHHvF2qt/Rjee0uESqEhz9tjARr4C7ma6cZc6WcmlzFd5UmRy/tdjRKqnu+bCeA56UZEttVJQnv2dB18foZDY8Ocp/fvl6LCPc75F64BgS1daDffH/nVdXwqepOx/2Q2/kXGHV4pTio7RweWPPmXQjglwhVOCfPknmyJOTqBrP7lO/xYrqjmBX+FHIiR8bX
 Zlz7xk5Q
 hq2ADkS7tktVPtl72WmcRZHwY0LGzdPpLASEGBL62Gs/qXf29DZ7Gw8bxTr3JN449SD1GzInQeH8kCQj8ZFmksgm7/ZVdHOxyE8q4wtfQdOdRmbl+JaO6O66wPwWfZSG1+6B7a6eP7Fh3zUpCLeIyl7F6vSgMjvhNiG8snT0bKCpaZMU0DrAl3+E8iz8AoTTs9jOgDiVsRSOiJHJR46ZCsr8J9nQ5IWNX057iPIbayWMxf6RW3zjOIw7zjgMqw/Z87f4NFAQza+bRZ7aTsuWsNUASLHKpogZbfBeiZ7HYW9gV552cLfg8H8v/zIzzXnB4myPeWkEK5jDgLtKNS1Bmxjgco6YDzCSKh3EhMJfP+3qKv69OyQhddS8joOohGsWlqM1OC1vJuUIvfyrBKQI3524wEFd8R+Nl0BbGrl2p9A3C0oBFJqCkBSJnKMjy8G2uSSUmbMO3zVDc7maoyppLlJhRxIJXMx0omJWDCzcXnwuswZ3Mo0+Zs/7wDqLLOdksz/A+coSbaqj2sxm7z1vQFO1B7bQPYJHmifFttcBSstANscxAErOzEiZTG/ZmtcjcZnecf3ZNH18lMBQ3FsDAS8i/xadnMS4cQ6IWHXOQmDMFrlxaAO1qD+yY8X+0IVIUdoFRYsFzbA8BB1FdKX44s3X3Joi2mdylr98IfuWfrmUGSlYnYD69z8OZfEn/tBg2QkZj/8lfsQJv3SY+vqoq1wumW4Redo9LGukv/1S2Nw/zxMAz/XUtiqLCSiGmBWWDuZ76oXaAUYIoMjFWq+LghlHZaUJzqTksDrP7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 3:13 PM
> To: Jianyong Wu <wujianyong@hygon.cn>
> Cc: Ingo Molnar <mingo@redhat.com>; Juri Lelli <juri.lelli@redhat.com>;
> Vincent Guittot <vincent.guittot@linaro.org>; Chen Yu
> <yu.c.chen@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Dietmar
> Eggemann <dietmar.eggemann@arm.com>; Steven Rostedt
> <rostedt@goodmis.org>; Ben Segall <bsegall@google.com>; Mel Gorman
> <mgorman@suse.de>; Valentin Schneider <vschneid@redhat.com>; K
> Prateek Nayak <kprateek.nayak@amd.com>; Shrikanth Hegde
> <sshegde@linux.ibm.com>; Phil Auld <pauld@redhat.com>; Andrew
> Morton <akpm@linux-foundation.org>; David Hildenbrand
> <david@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> jianyong.wu@outlook.com; Yuan Zhong <zhongyuan@hygon.cn>; Huangsj
> <huangsj@hygon.cn>; Fengyu Wang <wangfengyu@hygon.cn>; Zhiwei Ying
> <yingzhiwei@hygon.cn>; justin.he@arm.com
> Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA
> distance matrix with unique distance values
>=20
> On Tue, Sep 01, 2026 at 06:57:43AM +0000, Jianyong Wu wrote:
>=20
> > > This example uses Node only, but the code in question is specifically
> > > aimed at Cache granularity; might it be better to use a cache example=
?
> > >
> > > A little something like so (I got tired of prompting Gemini to genera=
te
> > > more complicates / less broken examples)...
>=20
> > Originally I tried to use a single big LLC distance matrix. But once I
> > realized how much memory and computation time it would cost, e.g.
> when
> > calculating affinity scores in later patches. I dropped it in favor of
> > a two-level scheme: the first is a NUMA node distance matrix, and the
> > second is an intra-node LLC matrix that only encodes the LLC distances
> > inside a single node, so it is very small. This way, both memory and
> > time are greatly reduced.
>=20
> See, that would've made good Changelog material :-) But yeah, fair
> enough, the matrix will get rather big I suppose. And going to
> triangular matrix storage will only save half, while you still scale by
> n^2, so that's not going to help.

Right, I'll fold this into the commit message. And agreed on the triangular=
 layout - it halves
the storage but stays O(n^2), so it doesn't really change the picture.

>=20
> > > > Each row of this refined NUMA distance matrix is sorted in ascendin=
g
> > > order to
> > > > generate a unique per-node affinity sequence. This sequence will
> guide
> > > > thread migration logic introduced in subsequent patches.
> > >
> > > IIRC greedy has significant worse bounds than many other schemes.
> This
> > > would result in more unique distances than strictly needed here, righ=
t?
> > >
> > Yes, Greedy edge-coloring is simple but can't guarantee to get the
> > optimal result in theory.
>=20
> Right, so the theoretical count is :delta: or :delta:+1, but the greedy
> bound is 2:delta:+1. But IIRC (and I really am not well versed in this
> particular area) there are algorithms that are still relatively easy to
> implement and get better bounds.
>=20
> I just asked Gemini (so take with a big pinch of salt and consult your
> algorithm book) there are simple algorithms such as Eulerian paths, that
> exploit topological constraints, such as hypercubes or 2d meshes, to
> still reach :delta:.
>=20
Thanks for the pointer. I'll look into Eulerian path based coloring and che=
ck
whether the per-tier subgraphs in our topology are regular enough (hypercub=
e/mesh-like)
for it to reach delta. If so, that should let me tighten the bound without =
much extra complexity.

> > > Since this is all on slow paths anyway, does it make sense to pick a
> > > slightly better algorithm in order to reduce this bound and get bette=
r
> > > results?
> > >
> > This matrix currently has two consumers:
> > 1. it is sorted to build a unique per-node affinity sequence;
> > 2. its values are used to calculate the affinity gain in patch 12.
> >
> > Therefore, when changing the de-duplication algorithm, I need to
> > consider the requirements of both Consumers, For the first use, any
> > symmetric matrix with no duplicate entries in a row is sufficient. For
> > the second use, however, the actual values and their differences may
> > affect the affinity score.
> >
> > It is not yet clear whether using a more optimal algorithm would
> > provide any real benefit for these consumers. I will investigate
> > whether a tighter matrix can be generated without introducing too much
> > complexity, and then decide which algorithm is more appropriate.
>=20
> Right, fair enough. I'll continue trying to digest the series.

Thanks, appreciate the thorough review.

Thanks
Jianyong


