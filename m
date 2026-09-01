Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AB38C624D2
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B1B6B015E; Tue,  1 Sep 2026 08:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C156B015F; Tue,  1 Sep 2026 08:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDBA6B0160; Tue,  1 Sep 2026 08:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07F436B015E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:23:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 866C6A40D0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:23:45 +0000 (UTC)
X-FDA: 85165109610.19.6D08132
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9241640003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:23:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788265423;
	b=FT7azSoeVdjuSrLanZfc8hTEzR/gRFUZcKNbKcT9D/wlxLllKVEwkXh2CO3VI9mxEBifc2
	FIwX3xwxG1/YmX8nV4aSEv2e9C9MOdNgKccvwIFfnT8E984xzYhqG40Mcu3SmBPUmXxiAJ
	8FUJtcpSBGlqoE/3SOpSZryo34ZqEW8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788265423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BcoU+6jXW3haCoP4tJGzewo6qNqs1ZQ+1PxLqEtpCbM=;
	b=v/S+0PSegL1taL9iuzy7aGviUrcKFScm7hHBMDeV+xCDu8abfRNPvAwG5fO5WaDxCPAEOy
	1BlPevXqivGAdji9jHYnkwKn7E2CX3Zw5Zyw4MPbTJXiV0+DRw26+Tzu8o0emdC8wq//fL
	gPzZqMBFw2RD+05aX5cLgxsrcVoPUbc=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ4lZ3qqrz1PGCt;
	Tue,  1 Sep 2026 20:23:38 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ4lY1Cj5z1PvqJ;
	Tue,  1 Sep 2026 20:23:37 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 0C1653104808;
	Tue,  1 Sep 2026 20:19:46 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 20:23:37 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 20:23:37 +0800
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
Subject: RE: [RFC PATCH v2 12/23] sched/cache: Introduce rq affinity gain
 calculation
Thread-Topic: [RFC PATCH v2 12/23] sched/cache: Introduce rq affinity gain
 calculation
Thread-Index: AQHdNiBG+fpHPMsZSUaXodgYa50Q5ra4/pAAgACsOzA=
Date: Tue, 1 Sep 2026 12:23:37 +0000
Message-ID: <97476ef46a42491f83599fac8fe4c8d6@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-13-wujianyong@hygon.cn>
 <20260901095840.GR4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901095840.GR4120091@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9241640003
X-Stat-Signature: 35j9i6a8c9yw11rghr5o83mzjzgjthj9
X-HE-Tag: 1788265421-196532
X-HE-Meta: U2FsdGVkX19/bjspj3XCZGBr7XPAZ8BpQZV18ZIjQrx0yROGtP/glYVfJ3N1pfdUzgHZ42V0f8XA55xuIlm2p458zLDenxfkQ3mWJGyhgKswYt4hxHNDyKlNy3H7HKItvFYYL5zoYYwySWKYgm/kK/r2AVL80HBFklPB0HD+FYMO4dggPR+ZBQBLrv/eziISnGh7FqHQ2n2PF5DY81rZJDCIWBF3RH5wKIrN/HuqdNKllZKlhM3FtQglwDqen2bb22EzfhRUrinI0Nd6RCpk8HyZbeKjboLoSt57GVy5jLMERO0PTAuwPRfMrlbnPPSDeWzSpym11TxkoB+4bIo8lRIciVx82jNwFiAl/zCPqjvRIuWbWh6H+Ubmvl9C+CXtIf7xxz19UnJaiIOv6/ezb3EMU1S3CuOJuUAuPs1kDH/VKRb1/hCslK1QHf/VoJdThFgvfSD7BkyVIlQVBLTUaPGT4FrF7fFq70UWvShS64GBv9IW04yDyyEgocRzaOLDuUoYv25BgGDTiEIoigN/ndhhHzSossWpSIkSpmD+JHedrXhSGhsr8/mmJ3EVCDSeBFKVHaAECipy01frbTk1pdRgDz6ma4WNtf4oE+alhrrpgClwhtr8dHSmB+FVe5FXL8IfLenY5XM9n4FRPkyZc6qctG6Cgh+RqSiwZSeOLBkcJuIE3eYlkDsg1+V9L/eX2iZcjU1L8LAngtgJEd53QSomE65hQZX0mRbFEK7sh51jnxuRs+M+rWYnRK0dWDNIybr1BmlqjE6asM0PeLvnAUw64wX8aILxonCHGW3PGkUxhFOjH/oPzh0lcTeYtrg5VRi67QvVfaJsAvVtABUPtdO/g2zfAe0zXet1EJ2BkYgWRbZhRjT9txsZI9dgIrUoibJK+bXArVLK0T6gsvKZlnoevXxy92VYYoNEGqkFsrtDaDwUmAlhulSJ3L9nMsIivSm/Z0msnFbAS4d8M7u
 ys3o1G9h
 6QKTUtu2+egUSYlAvxEa8UTX1E/URvQ9xNa8VFJ7UpDXsmCdaq7Ilo15nac6mpt36oaM5d5AAr2eqw5ptHd+qP00W4JgNgrnHC80IhjoDuQ+nDOm+8sJbxkAYQTHxvXdV/cHSpdEJopK+FnMOFAzlbbkJxljzeihtXHIl+Pl+BoLB9Cc9HLDX7UTsmYaQZWf/4XID1vvvMTZPo762Uh+2HnN+9eEF/c9zgwFy2DdPpOyEgNG9QTe4lahuPDKNDHwm0k0O+13D9t/MknT2Wjkssy/NXGjZXp6IYR/j4dX0mSnbbFdrQiiS5EStUw123Z4K7drkkyBhyC8xVZuWhKdt7DWeWJgExUVfWFm/fgQ9udB+2rphSjxAK07kTnfPdmAg16zkUkhOrDwHU5YMuDBnIr+JDf3Is8iggUso4lVFumix0hNmDWH9i1JUqfPVqoKiKxrV5aiECuyGcZp9f7C9r3pdlyzzMahpZwXic+lLHYXwAXvJIgyIkqOKXhpzoP3Kbg+Rs1cwASn0fCood9wSe3aSjDh32UAzqtazK6VXiMKiUVFl9o7gA28+8AFEFSXS2TQ+yQA8vLHAl64nxIENLGeeZ4KZh/E4u7dQG0XzisDRRhfo+uviu1jnR65Z46njvU7AUD6dHd+ikAOMrL4U6GqhRUz7Re/JwQC+rhHidSC/WFZYV4uaKuU5DIrpbsDdP6J0FQYuXP4He7Pn3nraH5QtXu5Ou2tHV9qjv5lUg6H4jP/yfnngb3wQcysJtwknXbKH4VHg5v0KVOKYnuc0JWhKMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 5:59 PM
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
> Subject: Re: [RFC PATCH v2 12/23] sched/cache: Introduce rq affinity gain
> calculation
>=20
> On Thu, Aug 27, 2026 at 08:28:05PM +0800, Jianyong Wu wrote:
>=20
> >  #ifdef CONFIG_SCHED_CACHE
> > +extern int max_lid;
> >  /*
> >   * Record the statistics for this scheduler group for later
> >   * use. These values guide load balancing on aggregating tasks
> > @@ -11998,6 +11999,174 @@ static bool update_llc_busiest(struct
> lb_env *env,
> >  	 */
> >  	return sgs->nr_pref_dst_llc > busiest->nr_pref_dst_llc;
> >  }
> > +
> > +/*
> > + * Get all LLCs that are closer to the destination LLC than to the
> > + * source LLC inside a NUMA.
> > + */
> > +static int get_affi_llcs(struct sched_domain *sd, int src_llc, int dst=
_llc,
> > +			 int *affi_llcs, int *affi)
> > +{
> > +	int j =3D 0, src_dist, dst_dist, cur_node;
> > +
> > +	if (src_llc =3D=3D dst_llc || sd->flags & (SD_NUMA | SD_SHARE_LLC))
> > +		return 0;
> > +
> > +	cur_node =3D llc_to_node(src_llc);
> > +	if (cur_node !=3D llc_to_node(dst_llc))
> > +		return 0;
> > +
> > +	for (int i =3D 0; i <=3D max_lid; i++) {
>=20
> This isn't safe. max_lid isn't stable, you should use sd->llc_max which
> matches the actual allocation size of sd->llc_counts.

Yes, max_lid isn't stable. But get_affi_llcs() receives env->sd, whose
llc_max is 0 - llc_max is only set on the base sched domain (rq->sd).
Since calc_affinity_llc_score() already holds that base sd, I'll pass its
llc_max down to get_affi_llcs() as a parameter.

Thanks
Jianyong



