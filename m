Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59CF1C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C046B0088; Wed,  2 Sep 2026 01:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D8F6B008A; Wed,  2 Sep 2026 01:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C836B008C; Wed,  2 Sep 2026 01:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85D316B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE2191C25D4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:08 +0000 (UTC)
X-FDA: 85167738936.27.DD5F42F
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F88120008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328026;
	b=3ip3ov2u3V+a8NqgmQm7M4rYOGfbLoKmckgxxK85Y5NM48Ghcgz8EqS0EtuUjLOpzd+S2h
	x0DSZucMMUlEJW2hYJ/RhY2btj/cSduPkZw4G5PsqgFk5XINnOZkwXYtn0XFJo4Ti2GT4u
	piz2fJfTBgcoOaJKokRncI8k/HzTjog=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2W4Q/rLWt4Md0SbaDYpTxZcdhP7ethihgOHY7r7KV0=;
	b=8rExnebOfuqKSN3W2EpKW3tYT8rFuRScLkhi7wUZ04y9MHSbeRVyQVi37oeNB3KiiYJxu7
	fcZk38pBdRl1QyHEg3MFjwCSHlV0omfl5/6tUgp9pIFoaRdeowoMVZD5BprWGSLd3aPVtS
	rXuBF3503sZ3rXU3ybWfEbs4Mx1K0mM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZWvT2gDjz2LvWy;
	Wed,  2 Sep 2026 13:47:01 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZWvQ4pSJz2LvX2;
	Wed,  2 Sep 2026 13:46:58 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 28E3116E4;
	Wed,  2 Sep 2026 13:46:53 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 2 Sep
 2026 13:46:59 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Wed, 2 Sep 2026 13:46:59 +0800
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
Subject: RE: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
 migration decisions
Thread-Topic: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
 migration decisions
Thread-Index: AQHdNiBFF6wQCkMonke4aXPvTe8F7La5GKyAgAG3MCA=
Date: Wed, 2 Sep 2026 05:46:59 +0000
Message-ID: <89add08a0761429a851196d7ea5a10a2@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-12-wujianyong@hygon.cn>
 <20260901113207.GZ687043@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901113207.GZ687043@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: 0F88120008
X-Stat-Signature: hq1yk946cauwks7imjtifc1thw96oqry
X-HE-Tag: 1788328024-343720
X-HE-Meta: U2FsdGVkX1+pGTLAedlVADyeWIieh7ooEwi6yI8yKrCvNuSb4Jym1rv/R/gMM5x1W+tX2gfv7SRjy8+uIIfnada7racbKBgH6rypeKUKG4G1w9S79bNE6ahCZiP7ovmsghDN7aFwluWRxjc8Hfc+xMxDa0TBgiqyUvL8gsMIPrv9FHYQiZU6bAaMavPbkpGfIU5TO/MR9TCsSvBJRDTG+xIF42EY8DgKtxknsCm7TN7OXZW/TjbMAT3iDoYIFoJxp9nxJNpGpXGuOnagpqofqzTgOxFBVIjQIhzQ2LvPhhhGmuhGtTW5Dzy34wZUafUip8mSOxgSMU2ny/NFjXpQjNihLqKXRuM9yHVmvKogHuFIIWkaLl/DuPgIyGC7cufHj6vO+VKb1AIRdNHOq1wRvkimtdezCgPUjaNBvlDKgI6Xxd0heKIBogn4k5WZWf5vPm62gitJws3hRMTXb89QFw1Nr4Xr2FVyl4il4inIZxsK6F24Of2RxnUYu6YHfrLtO6InrPT2UzWGfP+KereHcVv7J+SOx+q/mB0UhO9hHvnbMulhcpZyzxKAM7WzXBmcjxC1A6ArEgKIX9ILs4PJz1Y2IIZZE+7xm4cCh0HhYXKgMgFrlk0gioYqktBTeDy55J7RdyCFi9SKYQzBkuLNfgyEXOdJVKg4iEfnm80dORpaYxhIc2qjZO8CK5rS0sX/4Z6NtJ6WfwIvlmylXLeNWefSjasNWyXZ1xlJkOSrVVO9DU933HXXe3WIMeHTBjp5oW/0RFbqMiTab43PMDUtUhY9LQLhfWcg3jAFiWfvv398LeDoUzmjDZYL8q+AkUzNGQ+wc27bGhrI61Jp8PWvxBA3AHdLPQmP7SvKGOZu6+bG/SHPxbxf2zLk+PJQeRwBKI7F69DEHARy0aG2KIw36qUZQiRsUB6oXalHH+dXLZRjBQuh07xT4NKb4OQNDZizRi72s6+av/T5aCiSl24
 Fsd4wMua
 Rc3F5At8o2EKzmar6MLs4nX2mZl5wyr7KUOvExBrBjxVoEX52OIq1HTllNC/40yECmS0J4xnchSg5Vqlv2VOiqkCkkDIYDWz5x/P+IgPGhQdat64a0WqeJDfIoPknzRp7aZnZkR31E3sk0/iRNCYjUL518/1STEAeXYMidJlgGHkp5TMxDA5JRehS/TrIs8lqqiWCpgZ40qdgq+QwZcb2xbzydw7bo5Ml/DBH0T8tC86zhQKep19BHI1ZhL3ZfI3fTsBDSi1zO6UltyDiyjn91mzXIlBWy4tDoCyPs05DvD93XvRyt/n97SYAr2KFRy5uPEdP469w6Axb2pkRd3mZ+tDeGfXN7xddslmmXNfqDaSwr2bJrg1nUCw5T4K+Mb/aE1U1ZO6E9lvKsrhBWvcC+re1x0PVq47lH/iazbujqu9Dr3SVWD43jOBC/IE9WCXx1+dReuPec48lHwtjq/FvEKsYs3RI5glLSvxSBjWlTQ9z9YNuWYlwZ0t2THOzmwsQ+0ASE81W7oEhwmkWtEo5boU8MHcvjtlRYX+bieinjPx8Eg3HS2UseJU6e626GVPeYbmJa+9leNQSFTYlmIm3TT3TJU1Z+UN87S3Nt58fqBQ6GeKYAZS/2Vb8glgaPNlwEVCdyzBBOBF0ZT0eljimTYpwv7NETTk3CVqqk8OYkOQq9vTHtgiHADNx4+ChXJRovfbIBI7jLdcciw7CDTnBKGqfR9e+IF4XEpVvTBzT/Ai5+MX+4fl5Duyihx/qFXCa/6yaMvgEH0+7xoeenPL/+r6KGfhxKv0KYazizs0pxP7e5Ht2VoebYK85PjSitna7kVagD1KHI4WNhWWYBca+0gp+jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 7:32 PM
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
> Subject: Re: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
> migration decisions
>=20
> On Thu, Aug 27, 2026 at 08:28:04PM +0800, Jianyong Wu wrote:
>=20
> > +static bool get_span_stats(const struct cpumask *span, unsigned long
> *util_out,
> > +					unsigned long *cap_out)
> > +{
> > +	cpumask_var_t mask;
> > +	int cpu;
> > +	unsigned long util_tmp, cap_tmp, util =3D 0, cap =3D 0;
> > +	struct sched_domain *sd_tmp;
> > +
>=20
> We prefer inverse xmas ordering -- where possible. So please go through
> the code and re-arrange things. Eg. the above becomes:
>=20
OK, I'll go through the patch and re-order the variable declarations into
inverse christmas tree style.

Thanks
Jianyong
> > +	unsigned long util_tmp, cap_tmp, util =3D 0, cap =3D 0;
> > +	struct sched_domain *sd_tmp;
> > +	cpumask_var_t mask;
> > +	int cpu;



