Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053EEC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F1D6B0161; Tue,  1 Sep 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0746B0162; Tue,  1 Sep 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0060F6B0163; Tue,  1 Sep 2026 07:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D256C6B0161
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:55:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBF83403B4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:55:30 +0000 (UTC)
X-FDA: 85165038420.23.0E32A54
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf18.hostedemail.com (Postfix) with ESMTP id D37BA1C0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf18.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788263728;
	b=rUzgOvg2xg1MxTXRrHrBtm8jHZsvIcJ1Q+dv458fFl8ZXDkfIldzvaSviaN/QY7CuOL+SI
	ny4ITEYLT3ZY1/hCGBDAOhvfa+J//E1p2W9se6kO/7Mdzq8DJEsFM/XU6//Edvf/3psw/i
	rwI/MR3YU6iuU+fhWhJ4Y9pnx9hCaq8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788263728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aqpSGOeISijYkJV6CPPeNVX8Tnb+kGMbPDxN+MoQoJg=;
	b=XBsoXzfxSQljRHmZEoPKj2ZXt03pHueEybgmchkgcAKhKRTBtP9Meacfm9ZERL0tXRipj7
	VuwIwDUsHi9JMfhypS4EgzEeA2BAvX4EgldBasZzb4QDDRYwsyMk6bXM+3P548+OSI9BQM
	Xo4D10tN54xQKR0RmH2UAqZvynefKx8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf18.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ46w2p96z19hDf;
	Tue,  1 Sep 2026 19:55:20 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ46v5V5Zz19hDf;
	Tue,  1 Sep 2026 19:55:19 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id ABDCF331318B;
	Tue,  1 Sep 2026 19:51:28 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 19:55:20 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 19:55:20 +0800
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
Subject: RE: [RFC PATCH v2 10/23] sched/topology: Add per-sd scratch for the
 load balance affinity score
Thread-Topic: [RFC PATCH v2 10/23] sched/topology: Add per-sd scratch for the
 load balance affinity score
Thread-Index: AQHdNiBDy0ERu3mi6UyRqHFq3CjCPLa43gQAgADGn7A=
Date: Tue, 1 Sep 2026 11:55:20 +0000
Message-ID: <474b22fa14554c4eac6f8d59edfc678f@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-11-wujianyong@hygon.cn>
 <20260901080210.GP4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901080210.GP4120091@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: D37BA1C0003
X-Stat-Signature: qpb9n4wg74zrcx9d3g95j3c5haaeqfmz
X-HE-Tag: 1788263726-25376
X-HE-Meta: U2FsdGVkX199gD/MrkYn6RY3FGPpjwyWmFjHRh7bEZ25K4BcQ3LxHQWRyRKwv61fsYDzpef5uYr5djCeEVfoPc/jGa3WoFxcVJs6m1PKgFGoX0P1SFpHuDyu1UEJWBkj5mTXt9YRhmN7Sq9uoJzUTjX+l1788XbJXnRS75qGEOAU92lNG73fhdB8ar7VuE5dPtIuTj3xexB8W1WB1y/zeZJ/alykyRNZqMs1SfVspulKU8Q1nLa5eMf5ryUNxxWdRurLd8U3fRxLoNDpV9nPM0WQ58c3MKn6VSUHNG4SwDZbbOH/esaZ6EyRMdSvtMS5liUslEnbUmSQIwj+T7Emgr8X/j3d6cfvOPwPu3MFeNREO042cqjs19kDpGeQVyXNriCDCz5f0le9AaT2eDrRsa7uGWLC7e5zrl8Ff9HnwRP6LvGvdl8dMNkC8wQtwOFbnL58keGslUh+hxymvFqJqCMVJlTywACXcyl2nUcLo/efCvAXFeEgFUC3OmiEinYi3RdtomRDJu1F09DKg7deWZ1Ds45DT6x+cTTo1GuduXcuCxndH0ubp4IBrWTK+1FogXBPg/ULOHRiUmGFHUlZuIGWCPHRfLMVPB9agA8oYBtvqhjDE/woislnQVwobKTGqPBojcJHNorYR2BlmIDV4++8TrGSRrXY1ybl3+Lw1IaSz39k8w4P9U9kFcD75D9/V0QmTl8OZZwXzPZq7J3idd+uIjuIKYVNQvPNu2GQrfbboMatb3CUPHs9zy1/J9/uCyj7IRC2hGbwpOMuX6uF9rlwiANls7XB/tOydRrW7zZelWFbdhxAoN9AiMJzhTLRMRBDUHSJGGi4GtbpScNZMJZYcyL9HPp81vX5pntudMfH12Bce1OtsS6K3ZQvDgtI1pHhbJ4Nr4Y6vkx1vgvxXsjc742sx4ShmskVPAEOApaSrfRx6z4tvgE96NI94PgZ8H+kvyocXmtDgw1/mdR
 UbPUJVue
 u6BP0Qd9NUidXh3ZiNzrQE3hEL0aShdnYMCLusfpjbhW688O9vjiBYmz/2JaEmUcdHN5X8blp7LbuFFstUUHPMWluM38xAnh67xw5wVGjsKEVcscbhSMd2G7qRKYeK8lZ9b7H2YCr4gzvvdBzUt3piQy6QNfg5lMrNshCJ85whevOc08Nh9iXzGyTvHNjoHgYUS5s8hIVgfhZhFGtIBZ1rB7CNhuvLkI5f6E1G3nj3T6fLdnpHX4Yw6cpm9VJaGlsgVu3KONoiiEat9j8wF+kCj9igrt/xIFflfpAhWGYW/xIuWAnEVFvPFNNhPFGNaHR/0InQj49Zbl+ZBQknXzXOWi5lStexqSbbH1PWpFsgSiZ2S8EiH0a4m9CIzXJp42Y7zwcFD5UtJ0RtAaryV1oW5+ETRchWKOL9PXBP4c64pDxJDrif5WdcvDc+KAkIN0L9BkJVfWar3qoMz8hisNii68NCdAebDPVlJe6wJ9SwbxpzmuWuM+4ZC5Kg/flBMrEw2uVxGRQeSxFSwA4SwIwM/sN7pqshACLubJcVGNbc/K0LML0vLjZZrdmhRz31MoYtyHNNlrPJ/B+e8hcfVwXYBwk+eWYS0a2b+Ap0o4ZpGpqSlNoK0B/TXDUMGB+AGcQ8McjNwkq3WD2vol79eczBjlijQAs14Erg7bVbPXMeV0OAN0m82YQw6lt8cdgOcBGcC5Zu0gZt2huY5nQlHg2VOp3NLSDXsuu6lzEvX0LPrYJMjiyCC3aA9MveSVpQ/V3lviFOXl65/tP3bbwyLQ+D3A0Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 4:02 PM
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
> Subject: Re: [RFC PATCH v2 10/23] sched/topology: Add per-sd scratch for
> the load balance affinity score
>=20
> On Thu, Aug 27, 2026 at 08:28:03PM +0800, Jianyong Wu wrote:
> > The affinity score computed during load balancing needs two small
> arrays,
> > one entry per LLC: the LLCs that sit closer to the balance destination =
than
> > to the source, and the weight of each. Their size is only known once th=
e
> > sched domains have been built, which is why the load balancer currently
> has
> > to allocate them on every call.
> >
> > Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
> > ---
> >  include/linux/sched/topology.h |  6 ++++++
> >  kernel/sched/topology.c        | 28 +++++++++++++++++++++++++++-
> >  2 files changed, 33 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/sched/topology.h
> b/include/linux/sched/topology.h
> > index b31d2cf16592..569ff562dbdb 100644
> > --- a/include/linux/sched/topology.h
> > +++ b/include/linux/sched/topology.h
> > @@ -122,6 +122,12 @@ struct sched_domain {
> >  	unsigned int *llc_counts __counted_by_ptr(llc_max);
> >  	unsigned long llc_bytes;
> >  	unsigned int *numa_counts;
> > +	/*
> > +	 * Scratch for the load balance affinity score, llc_max entries each.
> > +	 * Only the bottom sd owns them, like llc_counts above.
> > +	 */
> > +	int *affi_ids;
> > +	int *affi_weights;
>=20
> Per the below, these should also have: __counted_by_ptr(llc_max), right?

Right. These arrays contain llc_max entries and are only used when llc_max =
is non-zero. I will add the missing __counted_by_ptr(llc_max) annotation.

Thanks
Jianyong
>=20
> >  #endif
>=20
> > +		p_ids =3D kcalloc_node(max_lid + 1, sizeof(int),
> > +				 GFP_KERNEL, cpu_to_node(i));
> > +		p_w =3D kcalloc_node(max_lid + 1, sizeof(int),
> > +				 GFP_KERNEL, cpu_to_node(i));



