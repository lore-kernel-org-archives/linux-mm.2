Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40952C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454D66B00A4; Tue,  1 Sep 2026 04:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404F56B00A5; Tue,  1 Sep 2026 04:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4526B00A6; Tue,  1 Sep 2026 04:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02A756B00A4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:05:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 831361202C1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:05:31 +0000 (UTC)
X-FDA: 85164458862.12.5E57FE4
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf14.hostedemail.com (Postfix) with ESMTP id 971DB10000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:05:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249929;
	b=HtcwgyVYZLG6hTqcNZfrMH7Ygb1X5zfac9P2W9NwdDqg257SXTtiiJWKxFRQACW8+Y4wYV
	MhS14M3aMlUBqb25pI8c2biTZ9gC/+VzqoRKpmBGgBfJ4Nrs6tXhE0u0mw5USQxS5+uoDN
	VsyB99HG2qEMoPOWu6IcUNhBzjzSEuw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jD7bRA02tR5mZVZR6PjCiBD5mj4nvAerKdmI0B4KnJQ=;
	b=5qQqjeUl/fZ0BCvsQzSOCbV7CkqRXkonGR1xZUxIeJFT8gEvSgby8oCKqvSgDRu7VwZqO7
	I0STsQ6qj0V6cR8XhTKmFS1AkLmf3X2OMuQ2Tw09tvLGu6NWuuvs0GbUm/Q28sy04Gtt9D
	k6WZX7Euu/qVguZmziRyIWxWuIP5SRo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf14.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYz1Z6Qwmz1PvqY;
	Tue,  1 Sep 2026 16:05:22 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYz1Z4T9pz1PvqY;
	Tue,  1 Sep 2026 16:05:22 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id C830F30004D2;
	Tue,  1 Sep 2026 16:01:30 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 16:05:22 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 16:05:22 +0800
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
Subject: RE: [RFC PATCH v2 07/23] sched/cache: Prioritize preferred NUMA node
 selection over LLC selection
Thread-Topic: [RFC PATCH v2 07/23] sched/cache: Prioritize preferred NUMA node
 selection over LLC selection
Thread-Index: AQHdNiA/Gl7/wvc7qkaJjcGUBBSfi7a3pS6AgAG8IqA=
Date: Tue, 1 Sep 2026 08:05:22 +0000
Message-ID: <82a9b1c118424a48a0b70439ddae6905@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-8-wujianyong@hygon.cn>
 <20260831132229.GL4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260831132229.GL4120091@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 971DB10000A
X-Stat-Signature: a4856r1m41hjsq1ij3ch7autd56grcpa
X-HE-Tag: 1788249927-54029
X-HE-Meta: U2FsdGVkX18MeQHIiUi6JH/8cdmqat7bnlV+bQXzWgkDQWqxUvrN6eNULo2uIj6yy6LvKnF6cP9fnFnTwUmjQ+BLJt0eWNA10Szrpq3LS0u+H9tAM0JDhlukyT/LHLlCpyAk3XVhedMEQler5Pa/1djwTjyIBtLoi9NYCyuLGd6l/MEVyUpI83U0sZoxFqylqG9n+ZSMYZTDx0tLU2k9FRrDju6IoYo/pim/ryrE++ZJry8Vwdlhom+9BnD6ffNdEC+8nj9B3BNZA+apv8T7BrimC4niQ0rlqXTCELfaTD5Q9vfIJJNZx9o0oe1MbY7xv4axcJx4cUeRIfWp8NVKdNgdKEiCvraeO8V/Ll8Y5Chw+7h0wiiDHKmdfhABLnCn3nO1j6EpwfSRBu0ReFaBB6Q5bvzrLIDbReJA7P3lbPVcAA6WERkwY8fdO34O6y8WiDG4nrtFw472+ggaWwXSqmalzK6LKAt2XBueByes1jhpcWwIOIoCnia7o5OyMqXzDxD/hAQ78u9U874KwGNC6TTOKAtIrPq2kexcEnZT5ctn1wZ5jM+wrn+PUqMK+U7uWlxG8O/aflWVRkVMHmqXYSU0nvfsGEw+DMKJmb2ra2m47Igy3PXBbgWd5UAMbLV13Ks7fbs4P+0Vv5XeMN7d1CGMeySzDx3iwq9i1MHgqnaiDci6GqQoclaoj6cP68areUt+o8qpAA990HhnD/mQFkBx80vMMUVOGm8mX7U3SdzlKR4orTWREhQIt/0ezPVXAwZCoIYI+sCF5oBzvZqQjuMu8HBuJP6DfHL4W+2sI6TnRuGzOLccV8ohJ5Gm/LfTdae3tvNfsLjO2cm943RXFAlJtc0E/h9aO75kCTwu5NrVb3d3RamxZyOvltjEnCjA1pU6FElEDA4criskrsgjmftgTSVMfuxu2yyHKHSpFme21B5kxkItcHqeh701rJEFsHteHVMCMDyadF3Cloj
 FFaceROW
 Hic3/8sZ3IjnSGRB8NMmLIcZ3Ibh1PZ4mgve077SVYf15EyFk2RSGhV4j03D+D+qcS0rAztA//eayWFgCPCVwzfMbCMu8QR560T4QNDkmm2i1qI1lw+g1EQ1QBAOz5tl5eRZO7W8IcEmDcxvfVrlQ650ldJs0YcfL42zvspEunyErOjQRRADmimD93M/zy4anQoV/SJZ69NRp2xVC/vmcWvLG/Cr9aPI2Pcd7qN5EQbvjEjsIg5uDekNzuSbZs+5JRi5Fm5+CPhDTdmDcNIFRDkPd0cd+n9TJz/RPGHTkc5gOhzh/pXgE5aWXNt9m+BlN1mzguK05OMkQV4giTjWzJjL9B9x7SUha+fjV+/+jZbPdWTpXsBl7Br5PXAJ6jOZfabBglD5q+azkEiYS9m447OjIrL0zwZbCglI5PYk1LTf8n9IrOg63LBnQ9KRIKU2XpQ6tSjaYIfmDyGAUcpmDrEX+aAuNRkFXBOspGAExHoDWsJ1os8K8aR7hhuazZX1zpuQj6COeHXNd2kk7Gr/PUSMPS2ePZ+AVPYv6V1VHz3WbwD5PE3Uo7vUl33H2E+ybIWmte61COuvdSrpvXTlQWwoOE6i4WYrffVwU7/T5wDoVvkFcGOiXZn1vSgL7YZ6TDyOwoghLqHSBc2fsv15sK87BjqHMjll5lqABeyLy1ocg76YdYa4GK4fMSMwqRz3NKfS18nBBkaKFDdvJ8tFUYRR7OaC2fuSDhCa9eCuGmmbLKp0y7/+aPpIV0csAVv1B8p90qMfWYltYHS0dZKTfJE3flo3PCGZYBsIhtTBwf/EtdarQax7/I8T/6GwGadYIORbhb08Jo0P6t+noWzCl92A3Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Monday, August 31, 2026 9:22 PM
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
> Subject: Re: [RFC PATCH v2 07/23] sched/cache: Prioritize preferred NUMA
> node selection over LLC selection
>=20
> On Thu, Aug 27, 2026 at 08:28:00PM +0800, Jianyong Wu wrote:
> > In the current implementation, the preferred LLC is selected based on t=
he
> > LLC with the largest running time of the thread group. However, the
> > preferred LLC may be prone to frequent migration when the workload
> > spreads across the entire system, especially when the number of CPUs
> > sharing an LLC is small. A better approach is to first select a preferr=
ed
> > NUMA node in the same way, and then select the preferred LLC within
> that
> > preferred NUMA node.
>=20
> Hmm, if we're going to look at nodes, should we not also consider the
> numa balancing preferred node, and perhaps priorize an llc inside that
> nore, rather than the occupancy wise busiest node?
>=20

The NUMA balancing preferred node is already covered by the scan:
get_scan_cpumasks() folds p->numa_preferred_nid (plus the node of the
current preferred LLC and the current running node) into the scan mask,
so it is not ignored - it is one of the candidates. And it filters out othe=
r no
related nodes.

The reason I don't hard-prioritize it is that numa_preferred_nid is
per-task while the preferred LLC is per-process. Different threads of the
same process can hold different preferred nodes, so prioritizing any one
of them would make the process-wide preferred LLC bounce between nodes.
So instead I include the NUMA balancing preferred node as a candidate and
let occupancy decide among them.

>=20
> > -				a_occ +=3D occ;
> > -				if (occ > m_occ) {
> > -					m_occ =3D occ;
> > -					m_cpu =3D i;
> > +					a_occ +=3D occ;
> > +					if (occ > m_occ) {
> > +						m_occ =3D occ;
> > +						m_cpu =3D i;
> > +					}
> > +
> > +					cur =3D rcu_dereference_all(cpu_rq(i)->curr);
> > +					if (cur && !(cur->flags & (PF_EXITING |
> PF_KTHREAD)) &&
> > +					    cur->mm =3D=3D mm)
> > +						nr_running++;
> >  				}
>=20
> This level of indenting seems to suggest perhaps breaking things out
> into a helper function?

Agreed, the nesting got too deep. I'll factor the inner LLC occupancy
scan out into a helper function in the next revision.

Thanks
Jianyong


