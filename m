Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2E2C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5126B0173; Tue,  1 Sep 2026 09:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FCD6B0174; Tue,  1 Sep 2026 09:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F92F6B0175; Tue,  1 Sep 2026 09:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0881F6B0173
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:02:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FCF680414
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:02:50 +0000 (UTC)
X-FDA: 85165208100.23.7602021
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2FF4980006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:02:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf02.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788267768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sI0Z4AmXxY1lZ7xDIPNV6mCKNYnkz787wrfj2YigtF8=;
	b=Xq5Y9VHv8+eKeC3SUbuY/gN4+YLqEqxDkpCNcoxA+gzMGdBRfSBhsIs2ltJ3KuW3L7M2lf
	cDRePNxxYA5tf9rTqb3If/Etw+hb9NAd/2K0B65T7WuSrHt64LhAJrsVhFI4I5pGjncaRy
	IrHO+jGHN+bOLNhObBDpkMZDZRNTQiY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf02.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788267768;
	b=QOhB2W3igA40xcYFkHajPL+TKXhsRhSLoZiKGip/y7ozIOhsY7M8hMDoe9vFI8Yi1YB5cx
	F2DI+0WOQjJ7/0CuQkPAG50ytO20syygeFoI895bJJ2PHXy7x5dXjGrAMfX2Q6w4xZRBny
	KL28kyHCJDsY8whZLE3eIl2oy1zb12A=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ5cS5Rgsz1PvqP;
	Tue,  1 Sep 2026 21:02:32 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ5cR38pyz1PvqP;
	Tue,  1 Sep 2026 21:02:31 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 40F5531D0309;
	Tue,  1 Sep 2026 20:58:40 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 21:02:32 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 21:02:32 +0800
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
Subject: RE: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU tasks
 NUMA preferred counter
Thread-Topic: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU tasks
 NUMA preferred counter
Thread-Index: AQHdNiBA7oAH9eDim06x96D0XIAuLra3pasAgAHCg5D//5zAgIAAsU4w
Date: Tue, 1 Sep 2026 13:02:32 +0000
Message-ID: <80ded281acca43a28043b261e850250c@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-9-wujianyong@hygon.cn>
 <20260831132414.GN4120091@noisy.programming.kicks-ass.net>
 <8eb55be5c1e9497c9f34f15436b9d665@hygon.cn>
 <20260901102127.GY687043@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901102127.GY687043@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jgcbazy94obmxmbhixwynngstgr9ufok
X-Rspamd-Queue-Id: 2FF4980006
X-HE-Tag: 1788267764-558294
X-HE-Meta: U2FsdGVkX19Uf3eyb3mPqYY8U7ihxuUPdlZyc2lSjAAiHsUXc44houJbR7VUSz3K15VkCwHuZWDCofvaJu/KJkKx8pw/nGvsSLXnub6lMhCM9HSmIVHkQsDNf8GtaGyWIfrQM1i2gTuMp8vJagSMIqoq3NFMdVzX3pHrOxNTzy7eIng2eXFiNcB8htRuajOC9RYLzPaNnvz6yXI6buNhRK7RoBwFF+S0JcB+kcBmAtId23lpLxRf5qus0r7d8xdvhpulP6YVm86hB0LAf2YKJPqsZAkUG9WvbGvABsCzN9XCNe44Qf54LLEkNNG/7nscErLBBmlNhuOgjHMU5KmV+BEL8Lz7jHWkOuEu9FRPRXuGsbz1ScF036GVeLmeAXZDlwa/HVekPakyLN0if5j/RSCSopKAP/qJwPtBqwSizwFiHiUQU3G70j1zQDjHs5i9D/hwnOfgcAYxHQUfQR7SyI/WTPLaGo+V29ii5+pQkbhsiRYeA4afv6AvtN/BSO5ayb4NEOFvdHT4d2TBht6lukjccjgCezWxNlQ3T/JJ2z3K2jZBV5UrMHNDAuXy8VcancQmoEdfj5nkwAduuV0kfiJSPUs7CRytoFJNGdB7MmDiHz3Ds344FsgbcUD2BTsSxq+qSUDGMjkO2ICLGaCUfuQjZj3v6qNGhqDts7fLscXK1pmfBAbD0TpaRHBXIDacFCckVn8NXTLDH3VXYsVMSaJ1G4Sw/E+eRlCQBcR2ggkqjtcH33SH6Lxm39vMM2n1OljLRwoIwv61RbGp5y5aBKrrEUNYwUkYRob1quiHUkxkKUQXtZnYRsisTLqex3lKys9+KJ5YYUGVFapNVq/c1LWh6FLauCr90Yqt1iMLaQEr2YjO2YOvHwgy7aXGh4M3tUs8aEUWyOS0blq6KxC8909onk8wE0kmbvQWPWa23U6q7SzAl6tTO3ZwflY8pg31zPo2CPV2TaajIDjUZ3r
 iLVWWSDA
 aZaOCdbnolXcYWdbqAA3G1yzv/2RXcbMW71TFUdONOhtz4eV01xbABrKa/mByFXtpWlJ6wsUS/oshxmoFaT4ugdXxILMMtGVzHhnoJPgQ2nD/N4r2tJUY1z/qLcLgpi+Ni2NhwYlSZLjsrwj7JoupJE0LL7i5eoeBO9exjno18GG3O139IYSsghJODQWnPIHeLBl3iXzILSmT/xqrOdqjSWd2J0gzV0F6UqhTejBSTHiRjXl1lOv2R9vr7leWAyhwsIC3nzIzPS5e4rqDe+jz2788Arysmf4dwEK7LpjkY2I0ImqNwM0hm0SlKXQnmFWGNECnKGrStfyAB+HkSXP8O3CVwhGvGH/6dG/30d4vZQ3Mpxc/TB33Xd4TORmwpQl3+u52+3Q/Ct1brKS3+5jWzCoAHvV7ALoJS4fTm0hJzicKhMEPRluJxgoXGsk1g8gnoQf4pCbaZ9Z72TRTTyZ7RLhotU8ijXUedCMRfPPPNyF/Qg2niE7IGYw5Xz9fN6eA5z88HZjmH45BXkjGtbVPAfowCouHZrcgM5q5xrEnRJ4PGl2hliqqia5FSh6MxTgt30XqfnBOFRv1IQEYf6jKiv7TF3wa129Ld6qv3Dsbn1ZBWiz68O5xNhCT7W8rIWlABEC3AYabosQQK3AP3Yil5y9M53+3GIDbPqPSw2hfiLz5UBJrXjIJUjEEQIIsDtFCaw9rbPSw5bmyzEdhaJroi9Vg6qWu7nCrVChTmElG52jF5V0vDXLm+GfXvxK8CkL4JcbDLMrGknlj6QBeYC/eYZBldRt4vYeYbhSZM7GqUc3HvdaGvhE4LtpPjJBf8dLtqCaEfb/XMwYFrwgRlTCZxTyAgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 6:21 PM
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
> Subject: Re: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU
> tasks NUMA preferred counter
>=20
> On Tue, Sep 01, 2026 at 08:31:35AM +0000, Jianyong Wu wrote:
>=20
> > > On Thu, Aug 27, 2026 at 08:28:01PM +0800, Jianyong Wu wrote:
> > > > Like the existed task LLC preferred counter, sd->llc_counts, introd=
uce
> > > > sd->numa_counts to denotes the task number that prefer each
> NUMA node in
> > > > a certain rq.
> > > >
> > >
> > > To what purpose? Is not the node occupancy the direct sum of its
> > > constituent llc occupancy?
> >
> > numa_counts is used by the affinity score in patch 12. It holds, for ea=
ch
> > NUMA node, the number of tasks on this rq whose preferred LLC falls in
> > that node.
> >
> > You're right that numerically it equals the per-node sum of llc_counts.
> > The reason to keep it is granularity: NUMA-level load balance scores at
> > node granularity (numa_counts[node] * distance_delta), while
> NODE-level
> > balancing scores at LLC granularity (llc_counts[llc] * ...). Maintainin=
g
> > the node aggregate costs only a single llc_to_node() lookup (an O(1)
> > array read) plus one increment in enqueue/dequeue, whereas
> recomputing
> > the per-node sum would have to walk every LLC of a node each time the
> > NUMA-level score is evaluated.
>=20
> Consider the trade-off. Adding the accounting adds a cache-miss to every
> enqueue/dequeue, while re-computing the value on-demand adds some
> little
> cost to the balancing (slow) path.
>=20
> If the llc_counts[] array is dense in node order, then it is likely all
> relevant numbers are in a single line and computing the sum is in fact
> fairly cheap.

This is a good point. I was considering the number of operations, but not t=
he fact that the additional accounting is performed on every enqueue/dequeu=
e and may touch another cache line, while the summation is only needed on t=
he load balancing path.

Since numa_counts[] contains no information that cannot be derived from llc=
_counts[], I will rework the NUMA-level score to sum the constituent LLC co=
unters on demand and remove the additional numa_counts[] accounting.

Thanks
Jianyong


