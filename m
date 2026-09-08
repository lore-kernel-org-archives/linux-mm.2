Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4490AC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425A16B009B; Tue,  8 Sep 2026 03:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC096B009D; Tue,  8 Sep 2026 03:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312066B009E; Tue,  8 Sep 2026 03:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7DF6B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:43:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89D96140413
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:43:32 +0000 (UTC)
X-FDA: 85189805064.30.AC2AA95
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf26.hostedemail.com (Postfix) with ESMTP id 08B2714000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:43:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853410;
	b=WMgwrFKDsuQdKo4cI220yJs1crwKCgY31YbEp2rqO2EXh98nVr3i5ly7I/InZ5MCClUVGR
	LUoQXm/FSvyRbZnmjvGO8kgpz4TYyDJXpv8V4F+RfsWG96TdYMsf9otBMOWYnzXAoVKFSY
	+QKNAGtAgTMJVG0EKHQdMmHB6Hu0zwU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Q/vJAJj03S5pA2gqPN7KHZ5XejH+Ef2FdpdIzyqs8Y=;
	b=cRNtB+QzbQCZwgfbVu2x/MGmZhhqp+Q5xJ0YcXlgvy/L2DqcnxzLy9CEipCE7P5ElxDz8X
	zvKtM7z8CCvOkN7NgzujY5S+ALBITROMRkk8H5CXZT3BdA+4nKE02v6Myaq1xkdogaZZeY
	Mp0BJFDR36uaT5Mw1PAjlPAksS2eh2I=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hfGBv4PwRzVcB6;
	Tue,  8 Sep 2026 15:43:19 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hfGBv23GPzVcB6;
	Tue,  8 Sep 2026 15:43:19 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id F06E330A6E44;
	Tue,  8 Sep 2026 15:39:14 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 8 Sep
 2026 15:43:19 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 8 Sep 2026 15:43:19 +0800
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
Subject: RE: [RFC PATCH v2 20/23] sched/cache: Estimate utilization of the
 whole thread group
Thread-Topic: [RFC PATCH v2 20/23] sched/cache: Estimate utilization of the
 whole thread group
Thread-Index: AQHdNpMnbRlIzduVrECfPaikBnRoA7a5TZ6AgAsO2lA=
Date: Tue, 8 Sep 2026 07:43:18 +0000
Message-ID: <3994638d89da4fd58365cefe62ff94ed@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260828021156.785662-1-wujianyong@hygon.cn>
 <20260901144449.GJ776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901144449.GJ776954@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: 08B2714000C
X-Stat-Signature: ks3r5z3uh316zsphjsadtsimnkz7kec1
X-HE-Tag: 1788853408-732613
X-HE-Meta: U2FsdGVkX1/4HWBfbEGp/M4YgoZr3Wp0os+cfmcikTP8FCbUzVPgNBF81ZBpwvlCYSTVQMmcOIFUikX+j5f81u99jb7UEY29fhtFHPcg64sEZIql1sqAfUgP++EYCCKjQCalQD1D/yBwU4lTzTf/iv+YthP49i6vH/5Sw0q6OwNDIMtf9hOZS7b3uT8Q7h6G62qpZvRG9xVZMENvLxLyNn/E2YvXcMiYUrFhhn89YrrJo+Zr2AuBiCKJ5FqYMY4t7VSrSF6YQ74Ou7Do8Yb4WX00dZWdlSFirgUKXZeEGQOx78cL8k+7wjB/lQPOMMppZI0xiBaDd73fgsr9nDJOFKhG0svCsHdqB3YEyiNReVlBRXNB3//0h2Gm0IcNYvYkdM4gFptsyyVGrh8qMMhgzLu4KDwh2nk1m4fQqwfWcCCw6eBkRMhNXTsXftSTq9Ub1u50mqbrzBg46kyiRQd5jqigYbpHPT07vKR+bfzcp5Aez0zD1ZoWkilP6A0WIRCebCOAFJldwMdfj9OipZ4CoPfOMQUovyFXBT4Vfvomn96rQjrnRUNoxSqC5UmydlwylhvBoOjstGrHgYxw/MBYsqKsuVkHLtatWMqGd0zPpD8EmFqpAuR4vLp/Yi1uMOyCtf8maD3oHOrSv/ZDng1Ws0AxsGrSyHiR9o0oZjsnodf4sTwXQPp+hBaxIpS1ITBuTqBKamSD/II4gqMiaDnkXqQzxrFJtKXVidgqHAbTXkDDvhYKF669FZXSGE9D2RmJid7Ok+WOSmPpZPQgB9RVR9NXDkaUElkkHTxc0+V2TUbN/p3wlm/DQ7KZJbGI6lG7mip/kFY9RNaUvhZAVJSiLat/u0hGXsbu/dwBECdvfzB6SUFXqECvtQU0g7FRUXn3bFCY7vo05/GJ8zOgUsXJAkUBiF5S8+lUzH+PZlvn6NLw5FdTPocEi5SlmRp0y6w6Vxddn4e8ZK4ejNaid4t
 3hNSG2Wk
 hW5WqNMnu+QrJUUXSwlgxCyLDHZB5gK9IXr9IYX/MCOJaSR5ZAtfJXVdwgI8HBcU6ZQasFhqFpgmCy+u5fnD24pgYGojGvun/KtF0kBTtJ1OXDpZJ1SncGVifaXFQW6S24JpuIw5ZxVBT9IIaC/5ruJdRiTazo6j6yK+//3X0VGjx22Y4/eMTCmb6XScspEdPO/JuKOYATvxy7MrVuZ4DlUqPviXql6nu9Nfl5KbBopxwng7m25ZvVdwwegK9Ql8XzGou+MYDjZ5wlB00gjzJ65HeyADXYyDAfAOOwycRzFYpSmC9WSZvadlZAFnqRRjVMnJYgIdwyrYwxw+RkO2Bugjz9ulHfRYS4SNyyGthutnXMMy2HE+YeLn2KU7bN/zHsMPhZ3dLssvadiYbQntPf99zSMuqo+GEjmAak9V1ZiB7uFLouyRXmr/oQtdy0mba99b8AF1tBavkdgmnxxxuuDn7yxryRM3eiSMMPIbAkteyKbv/U34VIfkdgvlKqKepJu2MWoqn3ajWBoY9Dm3aPM3R347cewYEiZJChGPXCZ8RIPvEg1CJ5AxF4wi6+m2CKVqTuYzzbC5skSjS+8UF+wERXOHnDDLQl+5TiMXKGCHc8JQ1GJvzX65BYy7PxdJr01HRQW6C7xZHD6JEj7F/CfE+JWPv4uvFLt6ZxkvesL9hBeK/e949r3fFTagpazb4pGnbaXH1E2UKkNVSVL8II+PToMnkyfWd6bjn4CcDdcNzRTQzts050Njv6brqHFXGYXJ6mgjB7M2fmD5RNRyjB0QBNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

Sorry for the late reply.

> -----Original Message-----
> From: owner-linux-mm@kvack.org <owner-linux-mm@kvack.org> On
> Behalf Of Peter Zijlstra
> Sent: Tuesday, September 1, 2026 10:45 PM
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
> Subject: Re: [RFC PATCH v2 20/23] sched/cache: Estimate utilization of th=
e
> whole thread group
>=20
> On Fri, Aug 28, 2026 at 10:11:56AM +0800, Jianyong Wu wrote:
>=20
> > +					mm_util =3D mul_u64_u32_div(cpu_util,
> > +							min_t(unsigned long, occ, NICE_0_LOAD),
> > +							NICE_0_LOAD);
>=20
> mul_u64_u32_shr(..., NICE_0_LOAD_SHIFT);
>=20
> will probably generate better code -- I *think* the mul_u64_u32_div()
> ends up being inline asm and as such cannot optimize the divide
> properly.
>=20
Good point, will fix.

Thanks
Jianyong


