Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C0AC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0BA86B009E; Tue,  1 Sep 2026 04:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC366B00A1; Tue,  1 Sep 2026 04:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F90B6B00A5; Tue,  1 Sep 2026 04:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD226B009E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:15:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBC791202D6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:15:00 +0000 (UTC)
X-FDA: 85164482760.28.D819E32
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id EDE97140008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:14:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf23.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PoG09Vl0bgmh7n4wLCnW9G5IzcKwIJgJ78kMpI8xoNM=;
	b=sLOCvxzj9Ds4DRUEufKdfX2JQb50MqAc93s2EGbSjPezJq0ucMh6Dawb/DVh0x5bBLFkm8
	b+3vwZ9T/PbuZPAFdDQ+PkJNhGqueo0MPn7hAgiReqYOb6IqGkZq+EXtC/Ehw9FQeeS6L5
	df/R5RxTMr3AGOEkIHRjlbZHT+Fu484=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf23.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250499;
	b=FDUTRajtIX2MjZURbwgbNLKvIiouyebBhD/WOA6UCW9ZcHnZyTqEQzOW9ak0BRXLN4u6lk
	6D4wu1Ewq9zNHvtF8bdlv/tbECe9HSacwnul5oe8/rZHcK1ZhQI7/euvmZsxz6HkXsYROo
	GcouseaS9wUAPm3CF5xNIlyNnJqHbIc=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYzDb6jm5z1PGD2;
	Tue,  1 Sep 2026 16:14:55 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYzDY5LFnz1PGCN;
	Tue,  1 Sep 2026 16:14:53 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 8A73B16EC;
	Tue,  1 Sep 2026 16:14:48 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 16:14:53 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 16:14:53 +0800
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
Thread-Index: AQHdNiBA7oAH9eDim06x96D0XIAuLra3pXGAgAHAgtA=
Date: Tue, 1 Sep 2026 08:14:53 +0000
Message-ID: <20587720d03445f7bfb9f25f4b4826df@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-9-wujianyong@hygon.cn>
 <20260831132325.GM4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260831132325.GM4120091@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: csstwg39pguauwtknkjpc3i53qowuq87
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDE97140008
X-Rspam-User: 
X-HE-Tag: 1788250497-96210
X-HE-Meta: U2FsdGVkX19MO0yw40vdGJisXKNsurxuZeFkCBxp+Mt3H35C+EbOh23NLEs5QPbjdA7E3l11lA6TKvg9cfFKTNaOEceSsano9vRPbdZYvDdkBKXb7H/ckR/93NQslJ3fO8AnMfsgAN/SDzXJ0ku01x4wC9eDx0/4qe1lA0t9DUywgyqJFjroSsATtdsImB0BMXjvuNTFTgT4YrPjITbwrUUWOzkKs931ozXSVqaFLMSUjEl8uXdYZmnJYNeWiQYaWJTEMx42r2bpmEFyF6tPAukA4A4GJu58JQtdtrUv9FZuiKdVUraoO71r+GdswO3iAJQMy14T/V6gw3o2oFtBx8t10zPVnPP7NeB5yRfQadFNsGRw3CD7qMFVB8+coORNP429DiPdajYx/NsuHel9LORw1289xr5Msxbo/Y0ZLh+mNHwxXpLeEaQkZdYqVrP7P+xmLvTbpvf54ktlLfEyoAr2xVwjTfA680ohjlJtqEl4eT9uMKvqHcl67q+KByZgG6notVhCPnW4nr8zcSBs6vHmOtXfQ0AgVeyWZcT1gFc3MTZnn+Wg3TJ3JG8VsxgFUAnM6N/gu5klLSmq8lNvJZFU1WHLbFPvmFmjoRaxHNwWZWiDS5x0g53MgkodIyDhhZb076yzkkPGRMA/LoVHWem4KIZFA+Qw5z/od6F/SFG2ir0E2DLW9Ycb/y/lz0XMxM9gwtlEb+VW06qocJODtLtIhLsF0uQEUypftP+/VH2R6DMNEKNFp20xgeuJof5cMh+5GnjHKB6YMblynVlcTdmdjyTolhYVw/tgCTb/TDreZbbslRJv/90nsbEysCS9PGfCs3g+GGVAfhO478nlysd9/lp48ZKgFVvqPiHPIFaqg/+QF9/vEVxpcHJI/B9DEbpTOogBLRn+JyhScj5erXh1K6lJwL19PfvAJGOACEj2xTGPSVmAsXBRfAhsetYnAG9jmmmpxch3pRye38z
 awOM11VM
 sTfGrwc32WteDMQcNmysiJnA3CYK2z+hZRtlUhp4xmaSYivGqofNNWJziFJEkjRBth0yIk4877lVNFB9uBjoO2lI6wh4Z7NyeunNBZNqz+4DKH/h9jbTbTDyID9f2AkRRp6PfBuJHY8XToH3eL40FSrcwE0pF0Iyb7ocrhFmJ/257bxUiG/iBuxdfVuK2tvYoqJuLmssVziVnSmKh6yy77JBOsLBj9w68taInt4YTZZRa9CZOThNG6fShxeX/pwBvzHmWd1B4LOYhxeA9w3h2XYCcpjNbKYLKPAYPblXHxUBihwJ2DXicP6KNSC5EiA5ev14brCO1hOAgQQzfiHtes95TC0ff9EADxbOXIEempU8e6BCgnQA6gAxeCdmz5XJDPVIcLaoCSi+dHKgEcfgvRVsG+7Y+iqw5BIu6P4nU0+ca8z5PbzrIZWhSPO92o7CBno+myOLncx0SnBCBhL8Iw7v6Vopy7c66GBOEROJcO9OSCnBTlxYeBuVHJvHQ5GTeFj5K6kkTT49sYhFKJTeHjSUp2SKJ8WYu+FIsyZeCEarypeM2rVMZPSUIzl44zWlLBmEe8f3adKY9eZ9vMFx4HOInIpyGcHQvAhw9zPjl0TF5ibVGRvB0N/4T0BpAR0617JXWHjQBptljVdaxsaeOPjMtNdq+5PEma67HqTAnoE0N15VG9yVKZ4hHyVZpsFYO+CxJI7eRg0K+SMJigcO4zs4cBHkyWulGJqjfzfo8ky2/RDFqYei9SeLL6yxw8jYQfKn5SiccGNqiTkGg0Q6uqAk1Y1gzJitJsX5XqF6Sl4ZRXvoHCmxX3aBPezzXGzQuQidvH7tvnEzkIRo1yR/WUmbjfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Monday, August 31, 2026 9:23 PM
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
> On Thu, Aug 27, 2026 at 08:28:01PM +0800, Jianyong Wu wrote:
> > Like the existed task LLC preferred counter, sd->llc_counts, introduce
> > sd->numa_counts to denotes the task number that prefer each NUMA
> node in
> > a certain rq.
> >
> > Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
> > ---
> >  include/linux/sched/topology.h |  1 +
> >  kernel/sched/topology.c        | 33
> +++++++++++++++++++++++++++------
> >  2 files changed, 28 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/sched/topology.h
> b/include/linux/sched/topology.h
> > index b5d9d7c2b8ad..b31d2cf16592 100644
> > --- a/include/linux/sched/topology.h
> > +++ b/include/linux/sched/topology.h
> > @@ -121,6 +121,7 @@ struct sched_domain {
> >  	unsigned int llc_max;
> >  	unsigned int *llc_counts __counted_by_ptr(llc_max);
> >  	unsigned long llc_bytes;
> > +	unsigned int *numa_counts;
>=20
> This is missing a __counted_by_ptr() annotation ?

Right, I missed that. numa_counts is sized by nr_node_ids, so I'll add a
numa_max field to struct sched_domain and annotate it with
__counted_by_ptr(numa_max) in the next revision.

Thanks
Jianyong


