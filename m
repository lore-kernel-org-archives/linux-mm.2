Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF3C606A329
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB836B0333; Thu, 22 Oct 2026 23:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CA36B0AD3; Thu, 22 Oct 2026 23:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144886B0AD7; Thu, 22 Oct 2026 23:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D620C6B0333
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:36:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A2491402CB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:36:18 +0000 (UTC)
X-FDA: 85352478036.04.0E26C90
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf13.hostedemail.com (Postfix) with ESMTP id 69D8420006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:36:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792726576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ifxDBexjlAFq0DGvf8En0rkTMN3cr12jODWP2ATNHg=;
	b=5djGaiAaPwgNDtb7sOO9b2SeuS4lRx8y7/lVfmghb5RXjB3nn+k1pclBjk8qrOTH/spplL
	PHL80f0Rt07mhCeWWizlJGLrU9r0ll95qPQAmz6jkfrpVvgqPR2OoX43kuDFYb+pTON4QX
	2bHGG9D4KKgWZKmz/ydFFboY+foVzyE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf13.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792726576;
	b=f/W1BF5w5z7/VjUkH5a1Dvo4FzHUjTkGykBAEIHocqxeEG88kf7qSifleezIXq4z2cALvL
	UQk7qWI33AIYlyS/QW9Tl+Ge2EUPrIY82Q/um06+y8DRIWnuahRbkquJvUjPGhLSMdAsry
	YY80d8aL7QlUxLLClkl75TAzaueH0w4=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4j9pZq5dFdzg1cQ;
	Fri, 23 Oct 2026 11:36:03 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4j9pZn1qcCzg1cQ;
	Fri, 23 Oct 2026 11:36:01 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id D2A051655;
	Fri, 23 Oct 2026 11:35:51 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 23 Oct
 2026 11:36:01 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Fri, 23 Oct 2026 11:36:01 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Chen Yu <yu.c.chen@intel.com>
CC: Tim Chen <tim.c.chen@linux.intel.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Juri Lelli
	<juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Phil Auld
	<pauld@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"jianyong.wu@outlook.com" <jianyong.wu@outlook.com>, Yuan Zhong
	<zhongyuan@hygon.cn>, Huangsj <huangsj@hygon.cn>, Fengyu Wang
	<wangfengyu@hygon.cn>, Zhiwei Ying <yingzhiwei@hygon.cn>, "justin.he@arm.com"
	<justin.he@arm.com>, "chen.yu@linux.dev" <chen.yu@linux.dev>
Subject: RE: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Topic: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Index: AQHdNiA3jheQVPdvikWpN4gB9aTKG7a3i1wAgCMFioCAAQKWYIAAjPiAgADjB/CAAIHNgIAF/bTAgAVsM4CACnnIsIAAKraAgBcFEeA=
Date: Fri, 23 Oct 2026 03:36:00 +0000
Message-ID: <854b5714024b4d5b97be916b740ce003@hygon.cn>
References: <20260827122816.756234-3-wujianyong@hygon.cn>
 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
 <da32ba66d95fd88869ba052f97698b9a4d6c3dc6.camel@linux.intel.com>
 <09261c8222994a41a04ace5f342475df@hygon.cn>
 <ce95ec57af9dfaf4d9ed604ad7337441a543f538.camel@linux.intel.com>
 <f6ebab3d0e44412dad17ac64a3b93339@hygon.cn>
 <112e526b4013e23c70adf5b8883db8e75358b473.camel@linux.intel.com>
 <8a0c239b5bdf40c99b645087dec8fd18@hygon.cn>
 <2a120db1b0c052eb88dcbc2ed1de6027a16542b4.camel@linux.intel.com>
 <4d2b5dede1f64350ac17ea9d0a5428a1@hygon.cn> <asfGTaJjCGMLW6fp@chenyu-dev>
In-Reply-To: <asfGTaJjCGMLW6fp@chenyu-dev>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69D8420006
X-Stat-Signature: pxp9mmtuwszqokpe41kujmpmfihy4nfi
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792726574-932383
X-HE-Meta: U2FsdGVkX1+xIRBOuupvneMDmpHMT8InUxm4rnv6mh4Fcjb4mDkTgCBzBLS+dhPixzfzyi9QvSR9E6mxVkgdXPvxZLFRMbtpccY/fWsvKzRRFtikFGqT0C+kd8C1M/nBQGFttgDdUIKP7b4vSUZlKegb+sarQ/Xcj1QahAjcnjRabeC8JKqH+6gUYBgfHiQUJ6x3FwLiU60tHARv7JCnCy5bPS3Idx8FHWOsUAKj1J6IEISruSUjkZQqIcoGpeP3MzFSubY5LlCKmlv1yijh+r0PNN7Dco6AdP2u+zMzwOKHn4N+tYbgPPI3U0zxmifF9wa37GntooIUgvHDIM7aJWWVhGxRBvj0gdsCv3EuD3PK8ANCH9dlO28ZmY877p25DovHHUmgGh6YhMmZuWon+ea9j/jOhozL8gDY0Ey/p+PWGBBoABqwf4iHumc54ivJrUFZ87njmVtdjnvrMz608lM/RRwqxgJrROd5Syu62AbHJV+J4tE6wN5I1Vf4lT4npgL5/1z3CvjQf8DmDjE9N2+a0vwHe/L5nF4CdgXClNdlA/g1SNWlhsts/4DzyK6RJurFfXZXe4GXjrrgSU6VBWkvGyHH08DShfQokH1/VS4Rgd9h13csr+uP8Gw8i5ZYZ4WnYCPJYKPYy3rRWMIHlwb87TJ7hIeGdqSeI5vvAXkcVFXH4bfvUn+h11VZQ4sBtyRVwv7C6zZGQL/qtuWbrNI+04S9zzOrVjKfF+gkhUmeryKzA0Pg0q3xf5YxaCsXcYcLSKuH1XQJiXB+8LULfQxwYZexWd2UMtfnmHglqbtMfwF7wkMpvPRxJt8H+8rEcMdjdSunNm6tyfcodrt7i1DedmnhDptwtElD5/R4e2cKtJOgEmml6TCUBhjptlW9UyVNWS3f9janHrDcEc9k/JF6z4UoBRcwTiFweogk3MUSt9zgvO6tqaF+BR2Iewj6NzN9uItpKAcT6sKkj3p
 TEm33HaP
 h2VF6XEKlcZEOBv76UTyjsoMGZ5mYejBf+aTMNaMXBhmqwAOUAq9hUYxyneYardQqET8nA9AdLCWQEugozejPzfkxF6cQlLERjttepprnrhRSarjdr+0My+H7aCUOuBj9xOhjmeI2khIiBLjxuf6z//NGX6JaQGroMoWxttlidk4ZNYvQP9QrZm/Jiu6E/XA8wrFAgS7cofb5xqLvgTqHr/XaANajej6mL7rJIUFNp8+dM5COvbGY+f9exHLf7XCI5ROcDhsxkz2SgRwteN3SzH1HiEvo7wg1SJPePhCRJn7pYlq0fSaJK5wu421+gkdI5thM1/WlVhGWfdnGSuL9a7BU4nw4iEUCQJlnJA/JA6U/2u0TQ6TUcW1GMYMM5+93QrdmCqs22Q3p3nJ8z2IG0lWvQJHiv8aPv64zoWQ1WSW5IkGUIqMFO/Tedpj0DRtXDox8zdmIsh//7b7YfjO+qIp6gknbMcpU6kLdF6OyM1LNlLRaNUJ6JHelDDECD5uWgHqvPfoW3vBaz4zxFF58cn6IWQacQa1+SPJDRj2i9uDfRKi5Wen9nZoOZVuJcmjc2rqZG1593GJ2R6OLlJLsY+p/W8smX/vyF7xfxuMhObk0A/E9vwi/ksIHIEZ3YyNLmrlKwxDuVmQn6wJmVGCSxXBwRAf9jXI823JVleSv7EOQOZjAg7W7pm1rtnvlJRGp3eFVwUMXrW8evVtzmMviQhd4PRovpKalSWtDSn624rM3smbjHa74EI4+azky1IWpTk9kVjG4S7sR4gkrk1FrsbhTHcZZOthOeVhH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chenyu,

> -----Original Message-----
> From: Chen Yu <yu.c.chen@intel.com>
> Sent: Friday, October 9, 2026 12:35 AM
> To: Jianyong Wu <wujianyong@hygon.cn>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>; Peter Zijlstra
> <peterz@infradead.org>; Ingo Molnar <mingo@redhat.com>; Juri Lelli
> <juri.lelli@redhat.com>; Vincent Guittot <vincent.guittot@linaro.org>;
> Dietmar Eggemann <dietmar.eggemann@arm.com>; Steven Rostedt
> <rostedt@goodmis.org>; Ben Segall <bsegall@google.com>; Mel Gorman
> <mgorman@suse.de>; Valentin Schneider <vschneid@redhat.com>; K
> Prateek Nayak <kprateek.nayak@amd.com>; Shrikanth Hegde
> <sshegde@linux.ibm.com>; Phil Auld <pauld@redhat.com>; Andrew
> Morton <akpm@linux-foundation.org>; David Hildenbrand
> <david@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> jianyong.wu@outlook.com; Yuan Zhong <zhongyuan@hygon.cn>; Huangsj
> <huangsj@hygon.cn>; Fengyu Wang <wangfengyu@hygon.cn>; Zhiwei Ying
> <yingzhiwei@hygon.cn>; justin.he@arm.com; chen.yu@linux.dev
> Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA
> distance matrix with unique distance values
>=20
> Hi Jianyong,
>=20
> On Thu, Oct 08, 2026 at 07:35:10AM +0000, Jianyong Wu wrote:
> > Hi Tim,
> >
> > > -----Original Message-----
> > > From: Tim Chen <tim.c.chen@linux.intel.com>
> > > Sent: Friday, October 2, 2026 6:04 AM
> > > To: Jianyong Wu <wujianyong@hygon.cn>; Peter Zijlstra
> > > <peterz@infradead.org>
> > > Cc: Ingo Molnar <mingo@redhat.com>; Juri Lelli
> <juri.lelli@redhat.com>;
> > > Vincent Guittot <vincent.guittot@linaro.org>; Chen Yu
> > > <yu.c.chen@intel.com>; Dietmar Eggemann
> > > <dietmar.eggemann@arm.com>; Steven Rostedt
> <rostedt@goodmis.org>;
> > > Ben Segall <bsegall@google.com>; Mel Gorman <mgorman@suse.de>;
> > > Valentin Schneider <vschneid@redhat.com>; K Prateek Nayak
> > > <kprateek.nayak@amd.com>; Shrikanth Hegde
> <sshegde@linux.ibm.com>;
> > > Phil Auld <pauld@redhat.com>; Andrew Morton
> > > <akpm@linux-foundation.org>; David Hildenbrand
> <david@kernel.org>;
> > > linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > > jianyong.wu@outlook.com; Yuan Zhong <zhongyuan@hygon.cn>;
> Huangsj
> > > <huangsj@hygon.cn>; Fengyu Wang <wangfengyu@hygon.cn>; Zhiwei
> Ying
> > > <yingzhiwei@hygon.cn>; justin.he@arm.com
> > > Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA
> > > distance matrix with unique distance values
> > >
> > > On Mon, 2026-09-28 at 09:39 +0000, Jianyong Wu wrote:
> > > > Hi Tim,
> > > >
> > > >
> > > > Makes sense. So, what about the following solution?
> > > > Given a node affinity sequence, a move from src to dst improves the
> > > > affinity of every task whose preferred node i ranks dst better than
> src.
> > > The score
> > > > is then
> > > >
> > > > Di =3D raw_dist(src, i) - raw_dist(dst, i)
> > > > affinity_bias_i =3D position of src minus position of dst in node i=
's
> affinity
> > > >              sequence, counted among the nodes at the same
> > > distance from
> > > >              i (zero when Di is not zero)
> > >
> > > Do we really need an affinity bias?  I think your intention is to use=
 it
> for
> > > breaking a tie.
> > > If there is a tie in affinity score (without injecting bias),
> > > just use the position diff to break the tie.  Having a bias distorts
> > > the affinity score.
> > >
> > >
> > I think there is a misunderstanding about the purpose of the bias.
> > It is not intended to break ties between affinity scores. I want the
> > score itself to reflect opportunities for aggregation, including moves
> > that leave the raw NUMA distance unchanged but follow the fixed node
> > affinity order.
> >
> > That said, I agree with your concern about using artificial node
> > distances in the score calculation. The magnitude of an artificial
> > distance or rank difference should not determine the weight of those
> > aggregation opportunities.
> >
>=20
> Thanks a lot for working on this.
>=20
> I think there are two level of aggregation:
> LLCs aggregation, and Node aggregation.
>=20
> Your current proposal uses a best-effort strategy for multi-LLC/node
> aggregation. It tries to migrate towards a preferred LLC mask, and the
> size of the LLC/node mask is the "range" you calculated in
> task_cache_work().
>=20
> Take the LLC case, for example. Suppose there are 6 LLCs, and in
> task_cache_work(), the range is calculated as 3 for process P, which mean=
s
> that at most 3 LLCs can hold all the threads of P.
>=20
> The strategy allows load balancing to move into the preferred LLC
> mask/range
> in random order:
>=20
> suppose the util of each LLCs are:
> LLC0: 45% LLC1: 40%  LLC2: 30%
>=20
>    migrate task from LLC4 to LLC1? OK
>    migrate task from LLC4 to LLC0? OK
>    migrate task from LLC2 to LLC0? OK
>    migrate task from LLC0 to LLC1? no
>    ...
>=20
> My understanding is that the introduction of distance comparison is
> because the NUMA nodes are not symmetric to each other, so you need a
> realistic sequence to saturate the nodes. However, this might not be
> true for LLCs - they are symmetric, and you can start with a pref CPU
> and get the next LLC via the LLC id sequence. That is to say,
> dist(LLC1, LLC2) =3D (rank1 + rank2) % k + 1 is not mandatory. Why not
> just generate the preferred_mask by adding the "range" siblings of the
> preferred LLC, and use preferred_mask directly during load balance?
> That seems to be straightforward. So we can get rid of the distance
> comparison (at least for LLCs).
>=20

v3 no longer introduces artificial distance values, at either the node or
the LLC level. Ties are now broken with triangular numbers, which
simplifies the ordering.

Thanks
Jianyong

> thanks,
> Chenyu



