Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067FCC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52F86B00AF; Tue,  1 Sep 2026 03:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03CC6B00B0; Tue,  1 Sep 2026 03:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9266B00B1; Tue,  1 Sep 2026 03:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D01D6B00AF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:44:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28D83C0370
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:44:14 +0000 (UTC)
X-FDA: 85164405228.23.BD93C55
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6785980002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:44:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788248652;
	b=VQS+hVhTgFrI89eXt2lk+HQl5WwX7XJiHT/V+6lnEpONb5ENyWkqKlmEpYO4NPbhRvId/l
	XK699K589y0NCahCeb3j4I0LRiA0Xfp6cb4eOODbtyKNnIA1vIHNl2t1Oo0yY+dFthC3zE
	A5lqs2fJUJkFN3vhKGUGsOkRIl0aSng=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788248652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yY6Y+yJBejTLiAp8PQ80g9KRnOAtMy7HCIws0SlPznU=;
	b=7eaaLpWcEqEtNNTNGV0ZFlEX2u88CGdSgyD1RgKWZseDWyWQ36m3k5/00zme7IZ8N8wMQv
	WP4aIieaH/h8PUWXSjXaSKYQNJUncwX7YJfeAZpebnMr1meKom3ZRBCbyEslEFQ44sq5kP
	5/eadXHXAO5jZqfIfc5XMC5ToCmjSas=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYyY25fKwz1PGCN;
	Tue,  1 Sep 2026 15:44:06 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYyXz6XqWz1PGCN;
	Tue,  1 Sep 2026 15:44:03 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 24A5330004D2;
	Tue,  1 Sep 2026 15:40:13 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 15:44:04 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 15:44:04 +0800
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
Thread-Index: AQHdNiA/Gl7/wvc7qkaJjcGUBBSfi7a3o5GAgAG7IQA=
Date: Tue, 1 Sep 2026 07:44:04 +0000
Message-ID: <62e8081a9432407893fb6a9a8e397d87@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-8-wujianyong@hygon.cn>
 <20260831131643.GK4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260831131643.GK4120091@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: 6785980002
X-Stat-Signature: 4eu9uh58b7gwpo7fq463t5ibuqofuekf
X-HE-Tag: 1788248651-691493
X-HE-Meta: U2FsdGVkX1+3MoCx5RpB1vKmStU7rsgNE8Nqszh8Uo/+er/TEe9tJvwCxqbedWPkHd8jSk/UVq5kgM9D3s3tMHIGX2KYrf8l28zE5dVyuNrcHXb/5jmrjcL5PFOc6zlmRxOnWRFW9b48Gp2NsOfFh9wFnDN/MjWrL1cIyvnGs7s+HG2Y0xVZO6kaoTh02tjbbwJR/eomquB1Z4uke6o/Sucowcw1+hCwKIuVjhSSFaCN29CG1A0bspe6DREr+HHwFg5gS0iviQjn1yWVCRlwqk4nUH5YpCU+3x22JSEUL6szpxl05+RqqHV7y9/MZXQ2mNcGlZuyCIp8LavLDdR1Kzh4luGLutimXvV2dADxy+zmQ2MzsIf0WbTTXxfsGnTH569Ne0aL5DF7cB+QmRaeYy2LBlgLrWz6PMs2/MNAGCkRyOI2Yfm8YrF7O88yT96/3PQNLm7dJbV7L7ofncNIa2EpZjYEp9xhzmQDMgyjf11rhhH9bI+pZl++1urNVpDg6nlNAgw6DWZe0EllheuKs5SXirJSxtvbQXJk19rnsm6Iok9+EBiVZ/f/tpoPTQcsu9CQpBMGSZ05rNYDVfk0kzWLa/C3SzXCTDjtGig89YC4KR5TcRaplPbMmUzOrCDnvzC8JtFLWe5BhxQbxdErvElTXCbdGDxzoFqQaTutm16Juc9Pd+9ndl1K0gZHfsL6mudVqmMJsXeVtaN+ZL3LNuY8UeshD9YhRnfT1vMf0eSWef1qdyYynro9y7Skpi56YcgFEskPSxVBmnC1ZOYR/3+6S2zzEYcbsf5Cz/bOf7G9jllOLKlGB4RwaIKNXf5icvuGpGwwf1PCpvb0WcOMAiha0JguLkEsP1KFcMpAvTCQYc6iiFFjfFBqF+Ac9Nfdu8l8NmopQkD/kGSM8IX+9rL4kUEWruGi17QKd1pjghXN295xPtYWEJSRZ9tI53iWrp9JIfGjOrnLc3BEHhK
 4m2HS9Se
 OIMLMP6AOFaxtVtYPcPtYY0ntWZf4/13auxIWArxYtXNeL0mw6DoATHr2e/tkAAihdaoVGsOtKT7yWeub4LCwnNDiHpgo1yB8t2/IwDdv/K7HaNwD8JxxJbRqhvB9Rf/+waXfNvfXFVrnKeaPZigit9U3ayUCJ67meVA//1NhS/aispz10prZinOJryYE1ifYTQ0h/VjoOQ9xrVu3Jjghi2mUXp1IfOqJAJULIM1mZ0GPK7NyyWD6lwwfB/0Q15b90GPJpiSyZtvp1s9DqMcXBA9Je+b5mnUAtNCOgsbocbxs4FEOGZSo9ReaRs3d1Iwgmy8EgxXtuLjZDGOvni3fDt2EG3CrXJ6glfujPR0LXfSQ+EeuzYlp3G8FaXlItYgUmRPnyAKM6kEh9KJuUEy67tC7+ZmFDEGt3e+/ccVh/08JtMtoGm1UdGm+9K8Iru8vO3kvDAAw0rHZWW/rqreXyWseu5PZr2tc1iFaK5sJeSUMFRnfH5MUT0PMKxmkm2S9VBV3b2Da5hyiwDTM6EOQiA47MRBCqJX2OENqILHCrztMBTiPAFeqEQWXk4a4uOcIEI2CFZX7jwIFoy9ylD+K77VBS65PkeDKPHzOFV0+KZu1cJRE5Tj5tanFeZXyaO1isP17TD90DOeTZzDF9Vtp1AmR4D/EQ6egd8wk+B4GOCiwXkkmdPGZcw490FuBErzLJijzibnH0jnx8AAOoV81FnGtJsOJyJUPQDH3YmzJFQpgd2K4WYcyXZrjI13r/3mEVpZZ7+tjd5wqDf3Rw2gxIWiG/ZXF1Gm/mX1WjEAUI9bR+XA8vpgJg68WzMrCH2mXz2j8nyzZ5ZmzK+kx9Y1n/aSvlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Monday, August 31, 2026 9:17 PM
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
>=20
> > +	/*
> > +	 * Avoid switching sc_stat.cpu too fast. The reason to choose 2X is
> > +	 * because:
> > +	 * 1. It is better to keep the preferred LLC stable, rather than
> > +	 *    changing it frequently and cause migrations
> > +	 * 2. 2X means the new preferred LLC has at least 1 more busy CPU
> than
> > +	 *    the old one(200% vs 100%, eg)
> > +	 * 3. 2X is chosen based on test results, as it delivers the optimal
> > +	 *    performance gain so far.
> > +	 *
> > +	 * Moving to another node takes precedence over moving inside the
> > +	 * current one, as it did when the two updates were applied in that
> > +	 * order.
> > +	 */
>=20
> Comments should never refer to old code that no longer exists. Comments
> are for the code as it is now. If you want to expand on details of the
> transition from one implementation to the next, that's what the
> Changelog is for.
>=20
Sorry, I'll remove the "as it did when..." part and keep the comment to the=
 current behavior only.

Thanks
Jianyong
> > +	if (m_a_n_occ > 2 * curr_m_a_n_occ)
> > +		new_cpu =3D m_a_n_cpu;
> > +	else if (pref_llc_cpu >=3D 0 && pref_llc_occ > 2 * curr_m_a_occ)
> > +		new_cpu =3D pref_llc_cpu;
> > +
> > +	if (new_cpu >=3D 0)
> > +		WRITE_ONCE(mm->sc_stat.cpu, new_cpu);
> >
> >  	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
> >  	free_cpumask_var(cpus);
> > --
> > 2.34.1
> >
> >



