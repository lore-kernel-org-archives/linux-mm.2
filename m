Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00E3C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767CF6B00C8; Tue,  1 Sep 2026 09:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F296B00CE; Tue,  1 Sep 2026 09:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E236B00D0; Tue,  1 Sep 2026 09:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3701F6B00C8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD80240411
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:32 +0000 (UTC)
X-FDA: 85165265304.05.4A60706
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf11.hostedemail.com (Postfix) with ESMTP id 94AD74000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf11.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269130;
	b=csaHUQNeFU21Qoi+1jQn98grFQnlnzAbyMi7AoC9yYPpcVnsoeJ1pvUCSfm3qr3fMrDWqg
	pM7G6ri0ZcskB7E23cT2UsswUu9hlCaowN8+bscZdlmT2eF6IR7AiggcZ/ZEk9TJjhqCIR
	46IxOzvcP/q0hH/JHEMC+AITo5sKHbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PFGcAm3yDHmzGLpdn1wLQuFL5xxF0Xbr8fuHk1+xZ7U=;
	b=zI36NwhpTll9zzqh8sDBoYkdTDiU1YkKDkPrRBdbvSCUVxoeP5wWB5uzuZLJ/phKw1sooX
	3WR8ru47KU4ACFByUeYJfK9sg1gmEdc24lxxAYdFxSrrUPrk+HwAMi9bX+c1X996ATok6C
	k78hetCwE22dRVEoMPxsomZaujoW7QI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf11.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ66q65M4z1PpLT;
	Tue,  1 Sep 2026 21:25:23 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ66p2cBZz1PGCm;
	Tue,  1 Sep 2026 21:25:22 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id CFD2FB357;
	Tue,  1 Sep 2026 21:25:17 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 21:25:23 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 21:25:23 +0800
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
Subject: RE: [RFC PATCH v2 14/23] sched/cache: Drop prefer_sibling restriction
 for llc_balance
Thread-Topic: [RFC PATCH v2 14/23] sched/cache: Drop prefer_sibling
 restriction for llc_balance
Thread-Index: AQHdNiBKk4QhTa7ViUqzXSOXSWPySra5Bx6AgACzrPA=
Date: Tue, 1 Sep 2026 13:25:22 +0000
Message-ID: <a064643f494b45c9bb0b8290308a1329@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-15-wujianyong@hygon.cn>
 <20260901102917.GH776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901102917.GH776954@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: 94AD74000E
X-Stat-Signature: tiwmm9h8497wjkznsdjspwqdo775zdyp
X-HE-Tag: 1788269128-57954
X-HE-Meta: U2FsdGVkX1+hSZs+x7vRE5ciqQaHngqOEhtyqIUBkdmk/lJaUktI074f7+OEJ0myX9VqjeH8V6rbVlnQyrEGwsy1XF7E0STS20uNdcGgAqHRJV1WnwWC4RsRMeBmy6DFoEv56zIloU0nvABDojZtOPDaS+tr6nYbwb7GGh6jVSNbf4B2bkcFaqHenfau9CIlUX0C3jELbVieHcvx8Kr9YIBbpeMGtwoFeQf7VU5gP6o3wTcxrV6/iGkReXAcRnzNKM3F1u1m1fEdq6BmU/bfzuhCKMGvPLYcrWd6OYu4520CXEBVZqKLnlipdSGgZH3Feijf7OxFKRJqJzv04Gu59QYH/vt7MMyNiwQ5LwzsGLpm7iC3S+YX8bp0qfEyIyYuQxY6RqhVWFd834CKcdikqTV258AuZ+2gYHY1xPPfa/P7cSoE1hDbTWyx2FNByfUjDL6fsq3FCwhwPCyLlAWPDzQsaMsR/cdItjip8RR/KaJCN1QDouC6EGIiBx4Lc/pwQqYbnNtI9itDr1l1EMHPXgkP1BgHYzlCFPIt3qlqTMlWybwh68OVZhtThDrp5w0IcqV7O7jDqH2PlvD3AjYgd22AN35UvULUc+P14rh87sAmNvkQwP1EGMQNSFg3Ihvx5oriQk9ILmrE4V8iMQPaZE4CG8AMYmtVPupYVRrL/FOUNnTDjxaczBZBwahJOTmEetBxEUebqiW63lRsZUf+7PlDb5uwe8cX/3//9xjTy9QGg3Mkq/NjCAGGbl6VkRm1O9iLpNRs0IT/aAzXnqz6+pA+GTQFl6qlR7b4TbkZNfAk78zoJ21Rcb/lm5VmAFuyfBVwoNRXiGxoq6cgozbsHyQ1JwkjswHk3crv14RQDNRi760ddnsHY/Yz/f7NSzHL5voKlsLnNm/wPDGcmJ1rrN0e0/xXsWjKUINtBNuWeA2C3RDPtRdBzb5+0WvayPE8Xujq7j+oRrrscttl3Ar
 gEDc9c0k
 AJa9PArFAQ90UOMdgtH1asw9HSpAAqfstGIHHGacm1yavrInJv4E5djSgPU12ubzn2ee5ILvffvm+El1yNRc0M4iACscIxr70uZxCagxtq0bPkMl1UFHxVpvi8gwcuJrWeyDO26WoJ4bxxCUg1hHbbXCp7RDtjiSJU0omhlXldK5b9nKJTw8qkndWEnG0u1QHU2MxxxOROtB9TVMAcQ+9KVXUl7bbJXsvInydRH9/MUf8SyHuf7Rq1Yai3Fb0TkjSS48Hf390FSgzrObrmJIplUjaMoJBt0qE9B31DUMip6b0Y3mzPFGNAoMBaiPIvLE9clivnXQCZL5ia0P1qVlmCjYyAVKtiQeE66ocyjepaVIvvU07quTkidtA+UDis82jLzuO9BDGBhhR6igGvIHMUzkQbavm0WCUQkgJ8zf4SOXwcADpkcUMlN+Yp7+12DJMh0cyLlRNLiXYwd6RpQKjcplD52Kmbri4KkiMsWiZPLedgSGGj5E9TsB5ggB3+Miu5QB18xAMmWwvMB/DQRC/o9g8jzbXAfHUCy9fxbNEWH5EP/GGRuOiHWTTu3OfhlFGc9dT+//qbTdALRfnYNf+t2/xFevpGbQ2GQlj3ainKaCUypSLn1yoCJgsOqP7ZfisP7FSbIqeEFyQ+hxuiA2nAv/hME21R+qBNhu0Mpz4QRCXU7OQNWOOmL6hcFP/HVV1GwdQOI1KyYkkdM33q8rcrTZ03D6Au1mJ8itrbGac2HZza7/dYLiqCfkyXyFz5O5KtiZFcqL+SfPww/uuHNv0R+XK9xfmWT5BI8r1W/cy5xYUUgGpFrifwBVge1P7R00xxuNnvRspm/W3JP/hrQQOOy+X/8mOqhT13yo0gIhSlXJsdt2PPbSn/8f7ogN0Ps5MypwjLRMxo7Y9R0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 6:29 PM
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
> Subject: Re: [RFC PATCH v2 14/23] sched/cache: Drop prefer_sibling
> restriction for llc_balance
>=20
> On Thu, Aug 27, 2026 at 08:28:07PM +0800, Jianyong Wu wrote:
> > group_llc_balance performs balancing across LLC and NUMA domains.
> > The prefer_sibling constraint unnecessarily limits its scope, so remove
> > this requirement entirely from the branch condition.
> >
> > Signed-off-by: Jianyong Wu <wujianyong@hygon.cn>
> > ---
> >  kernel/sched/fair.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 584297528a9e..5c35a43e5e38 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -13274,9 +13274,9 @@ static struct sched_group
> *sched_balance_find_src_group(struct lb_env *env)
> >  	 * Try to move all excess tasks to a sibling domain of the busiest
> >  	 * group's child domain.
> >  	 */
> > -	if (sds.prefer_sibling && local->group_type =3D=3D group_has_spare &&
> > -	    (busiest->group_type =3D=3D group_llc_balance ||
> > -	    sibling_imbalance(env, &sds, busiest, local) > 1))
> > +	if (local->group_type =3D=3D group_has_spare &&
> > +	    ((busiest->group_type =3D=3D group_llc_balance) ||
> (sds.prefer_sibling &&
> > +	    sibling_imbalance(env, &sds, busiest, local) > 1)))
> >  		goto force_balance;
>=20
> Not sure about blanked disable. Maybe only disable when cache aware
> scheduling is present and enabled?

The prefer_sibling bypass is already limited to cache aware scheduling.

group_llc_balance can only be selected when llc_balance() returns true,
and llc_balance() immediately return false when sched aware scheduling
is not active. When CONFIG_SCHED_CACHE is disabled, the corresponding
stub also cannot produce group_llc_balance.

Therefore, the changed branch cannot bypass prefer_sibling when cache
aware scheduling is absent or disabled.

Thanks
Jianyong


