Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECDBC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B7C6B008A; Mon, 31 Aug 2026 05:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33D56B008C; Mon, 31 Aug 2026 05:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F756B0095; Mon, 31 Aug 2026 05:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4ED16B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:44:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CD28A3B92
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:44:11 +0000 (UTC)
X-FDA: 85161078702.12.E7AF3E1
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf07.hostedemail.com (Postfix) with ESMTP id 87F9F40004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:44:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf07.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xELKN6p0Sp+9P1iEAMDXmRRpX8TZwE7fV2x6wZYzeX0=;
	b=PhX1LNkG5XzcSWB0lFnABQtRYYoLlfBSPVfOkf+WOzBL5DMSX8K88IkUs74OSlub8hcZNW
	Z6Bo8227+UchoOeLibTMSs+rwIjUMulYVZiFokdD4Wj1UZGNlGdiuydk03J4TXmS90TlKV
	6JJgi4570cN1fOoV365oBhz+q6jPaqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169449;
	b=48rc7V/7NR+DlIV/Kj8llTgblwwhLFALiXExBnWcgiffV/MPyipqKk0caekf+dDyU+rkea
	cYtZByiaryLu4q8FYa+Thg3lmE6P9IvMT5U/tQjZZIK76kMyuxb7EaB1anDgv4Qwi1e78d
	fgo93MGaqU3FnJKMRtjB32qjl2iSBdQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf07.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYPFr55Fhz3lk13;
	Mon, 31 Aug 2026 17:44:00 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYPFn5Kbpz3lk0r;
	Mon, 31 Aug 2026 17:43:57 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 937EA312D305;
	Mon, 31 Aug 2026 17:40:08 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 31 Aug
 2026 17:43:58 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Mon, 31 Aug 2026 17:43:58 +0800
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
Subject: RE: [RFC PATCH v2 01/23] sched/topology: Add llc_to_node() to
 translate LLC id to NUMA node
Thread-Topic: [RFC PATCH v2 01/23] sched/topology: Add llc_to_node() to
 translate LLC id to NUMA node
Thread-Index: AQHdNiA1S4sPkM2eVUS9eLXgGPoHhLa0UJ0AgAOVqnA=
Date: Mon, 31 Aug 2026 09:43:58 +0000
Message-ID: <2ddfaa8335fc41f0be394de683013ead@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-2-wujianyong@hygon.cn>
 <20260829103102.GE776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260829103102.GE776954@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87F9F40004
X-Stat-Signature: 3zk5azff84t5jnhk7fw8o7hr8z8dh4ri
X-HE-Tag: 1788169447-598959
X-HE-Meta: U2FsdGVkX18GCRSqTqSq2DwYZbFVdpF69wnIStqA1q9Slvl4WagfwmJSGzIpMXMsFythqXvPusxcyjOsLz2X/4fBDRa5QVdmOrlHVWaxfdnXyQmYGd9aWmK9M9S11B9OcNaMO+0WSTIPoPxqOl42N2g1WTMqnvYf6Fd/4koHwTKcCuHZcfoJyVbYAC2ntwYh6WLx1pdHevnKfr70AV8u3Wo5T3khqaWdGGGa6eaFyXjMG7PiJj8ipdOlSligPYvuWVYvYWVGrBPPdVU9zgI81HD096lK+01DqB0hSkJgR0aS/SdrNjT7mBWnCClpxF7VYFNEySUrr2E5l5o5gFqUUtPztiqDcZ62Mpfu6VnXNMHfK8Qsi+PPyikfFc8asLTEIKSnp5geiICXgmGa4bdmAevCDXHIGdXU8gsblFNlnseYpS+DRY3yjIOBM0o/7++F+24efV3q/1dDQzV4ca8U0y27VBPWi+BDpHqTwODtS/GaRq2ZszReAHg06rjmpNmdV/Uf933I3mbSUDRa1azV3wpJdK/8fXK6L8s1AJSlHAT4N+dcbYJzspa92rKVsVIIQf0MAjmcZV+rSdg65m0YqIY6qMVwrQ0YI4tHSesHgoODRR63oGy2DvHN07a7/CnKOA8MAW3hFXXsT8Dd5VblOL+xko/L160/HtQlcjFAcnHmeQzn2BTlvZqgoHwXauCDBXsna4EFmOW6o3uM58tmR+mORbeoJxDjPRlEUe+xEJd3bdYc2xhzcOPzFFRzw0/H8O+Ya1nkW7qMp/+2GPz3LNPd8DBcjrYNAT8nq0iKGWb/iVWEQdJX8NXCRZd9e/4ifdKfbo2UeWvqHj21V83shrpzVSUp8MsThDuwOn8bPR9hg3ass5ouA376uodX6wHvkh3i5hcF+1MtgjIdn11UilmXuU+MUj0zRwBSwf8+6rkBs46HPc3P9kgD3UVrVHwtYnwPXcQ/VlAbv1qs6TG
 gFcZIK7N
 LDiQvQY04LpTff4ecIquegLAI0JY32wSoHOxWUEM54ji/r3u/fpvDqtnKw1a2GbqyEACnxS4JzlvOXM2ht8uc1qv1Kg8JdClj2LNPQPbhVViXGAV2M+ikGE3oIdUBNrVTF8NpxpK1DmqHiOBU8ZxBIgpTVna5ZIVbPyqaLh+822cFT+iS2d/XQwD8VDvhfOHTDMwa8q44CgvojNcReBfD3jDbWl9wCOLGJ9wjNdR7Eni2u/MPR7xDxrMj2l/lR8K04dqXpX5V+gDDDYxXFReD3ehp48C837Cqrd+DdltdmfRbuKuh2nxKSQijfj8o9Rr+ZiykZOrm+2CuQV1cUXIfz0qhYYuov9NXQ1huf/QAjAmDskIibujXx8FsGItKXwS7aQjNANcF4oFD4j/h6EiUnorR/BoBCMs9cubBoLrnGammE1GGk+e7V1iwU7SpBxURgqaotw2CJxh2ozErDGu7Eo/YclEHD+zGfG5vPewWMOHtBeVtr6T3fxsDsUShdxY+PZYIkWLfXYWbaKHEgx6kRA595AAxDvYKr0TDtLiWbHY2T1qDbh9GIAcnODWKzr4fvUgH0xsLlcitKDoDiljY9asOHydrT6FuaQ79B1IH3rQ3LiKor3oAbfUbvw3zeiljqTcHr+3E+VQ5z84z20wOQznZtXu7FqNMFvL2dClVRxe3RjkxcDEXlOygh6URHEKlMACwd+fqgDVKDyqnN3Zmz4VaIoBaQtoH4zBxm4tjThWkV+ewp3F/DKEBTbA+Yd13NODfGqul4sD0RrVVdxCtJ1YacDjuZGw1CysyiLlA7fNbGNC+53aIr/KUOh87cWiBLRq+iwqaJu74b34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: owner-linux-mm@kvack.org <owner-linux-mm@kvack.org> On
> Behalf Of Peter Zijlstra
> Sent: Saturday, August 29, 2026 6:31 PM
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
> Subject: Re: [RFC PATCH v2 01/23] sched/topology: Add llc_to_node() to
> translate LLC id to NUMA node
>=20
> On Thu, Aug 27, 2026 at 08:27:54PM +0800, Jianyong Wu wrote:
> > +static void rebuild_llc_node_map(int size)
> > +{
> > +	int *new_map, *old_map;
> > +	u8 *seen_llc;
> > +	int cpu, llc;
> > +
> > +	new_map =3D kcalloc(size, sizeof(int), GFP_KERNEL);
> > +	if (!new_map)
> > +		return;
> > +	seen_llc =3D kcalloc(size, sizeof(*seen_llc), GFP_KERNEL);
> > +	if (!seen_llc) {
> > +		kfree(new_map);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * for_each_possible_cpu() revisits the same LLC non-consecutively
> > +	 * under SMT (each node's LLCs are walked once per thread), so
> > +	 * dedup by llc id via seen_llc[], not by comparing against the
> > +	 * immediately preceding CPU's llc.
> > +	 */
> > +	for_each_possible_cpu(cpu) {
> > +		llc =3D per_cpu(sd_llc_id, cpu);
> > +		if (llc < 0 || llc >=3D size || seen_llc[llc])
> > +			continue;
> > +		seen_llc[llc] =3D 1;
> > +		new_map[llc] =3D cpu_to_node(cpu);
> > +	}
> > +	kfree(seen_llc);
> > +
> > +	old_map =3D rcu_dereference_protected(llc_to_node_map, true);
> > +	rcu_assign_pointer(llc_to_node_map, new_map);
> > +	synchronize_rcu();
> > +	kfree(old_map);
>=20
> Could that not be: kfree_rcu_mightsleep(old_map); ?
>=20
Yes, that would avoid synchronously waiting for the grace period here.
I'll replace synchronize_rcu() + kfree() with kfree_rcu_mightsleep() in the=
 next version.

Thanks
Jianyong



