Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0812EC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 12:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED406B0162; Tue,  1 Sep 2026 08:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6936B0164; Tue,  1 Sep 2026 08:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0048C6B0165; Tue,  1 Sep 2026 08:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D01436B0162
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:34:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EA15A040A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:34:13 +0000 (UTC)
X-FDA: 85165135986.25.F9C08BB
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf27.hostedemail.com (Postfix) with ESMTP id B3EE240011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:34:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788266051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E+Kdsurt9s5GaQOrQb6srKJUmJBr9vDVOUNZUBneq6Y=;
	b=NaOcKz8KkX0F50XEWBFtGiP59vkyiAHTJglv/3fK4cou4bX3oZTM4jday5mN0kc/oThn9C
	yxoClAL00A5w0ojReU7kD0huEWD0rKnRZSaEg+IfgncWovywPysZ0I2FiuwwwhPVKVSGZH
	qj22keaFwYZRFXrjK7C0gu29qdk+0WA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788266051;
	b=TZlWpQM3kEHZz76nwu0hgryvM+gwPPEkvh27asnDEnKrcKrVP0ZrrF6jQJ9Q7ssecQNczC
	El5DupN3nDtU8Mz/AGGxKQpQ4ljKVajVOp2xs3dAkMpNat0Jm1U3G2chJGQsbmINJGTOuP
	/08ZflGU1QBwyO1PRTrVsjOyKcFFszI=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ4zf4DtTz1PGD4;
	Tue,  1 Sep 2026 20:34:06 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZ4zc1rRHz1PGCm;
	Tue,  1 Sep 2026 20:34:04 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id C6D60B355;
	Tue,  1 Sep 2026 20:33:58 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 20:34:04 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 20:34:04 +0800
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
Thread-Index: AQHdNiBG+fpHPMsZSUaXodgYa50Q5ra5A3GAgACsSKA=
Date: Tue, 1 Sep 2026 12:34:03 +0000
Message-ID: <e92cc24da4c94d6d9d20383921adf5da@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-13-wujianyong@hygon.cn>
 <20260901101607.GG776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901101607.GG776954@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: krpsgazr95uywef8yhmqiru7zbjc9bf8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3EE240011
X-Rspam-User: 
X-HE-Tag: 1788266048-357058
X-HE-Meta: U2FsdGVkX1+zLoq8K6+TVZvg2q5etSromzGVzQrYXJZzMERrCs/mPr4d3ZVBsVcr1O60rkCnaafDy/FBwbBBTRQ8nFiM6R12N+hYsLOVHPavogASQ1qaiblSAtis+XpE298US6eo3rDUcOFEo7x3mHK01tbI7KdWU35hUcWW/XV/2ISn4dNWdYzvVwB3FWDdConrZ6HjxFkGMzT975x4lmleDZGu1TdkWh3vk8NmSWyugMcKBVnlnAlQeg7/VEtnpL+VRr3OCK90p1HxPyt19tRyG3lbTVGwxYz0YTUSHVYXhAaIwYPSGeNP5ksezKX8sQ8i3FKh2ohSWtWpQA7jrKde3x1IGSV5sAX2G0zcMUyqI3/f5BCLerPwa267P+c/hVjlPUb27rdMajg4IXG6L/quBzNmLCM5RfQss1qucDUfOvNwxzUEpqaw1d4tUJki6MHCoE9Ew+H29eqFoTdbtz1VDgdQ3RLuW5zzwGWj5iNAtMoE5VjMlAgmvvsPvyNf9X29nKGy12n0qPe3LRgCyyiJNd3Q16PbZTYzzLyCOsoXgclmR4RWnN/1rRjZEpCUeqAfIrBxh4EC06hNStBdeSzlptBLBGcXX56r5wbv91c6v9dMU8IOzpGMu31bFNhsJz2Yr5cMJgP9ZB+PcsKVh2gjnKpNFlKlEZkcWDfOLugW+URl5rPIFdmM1jwvaxiXM6iNkQ2pYiZsD7VZbELBVx5A/toJwZeskFzOV8PW5m93I1dBoLLgQKGKNxpg0WHeR66DFpMLwYqNZ4vzTDwrUqrX1Xpco+pIke5wwrU2zH++TscxOtM6UqGTlGAeS3nogz0zd8AEcvhyiRcOxm5KMLPpDjmt9NmiOF4olqCH+hlrrd34p/r/TSJvicFQUm1FGoDo8ietFPhVF6FKFzhgXcKTlCBOB+czfPANGfg9K3eTj7pwZkw8aLAFfTmAyxxKjDL8VQWebweREQ0spja
 Sx0ltCjv
 FfU6E8acbe2H6Lvi9csNiZe4+iud+nJdedSEGwCxsTP3OiBYFmVjP09T2xmcc5sYARhBZu8GCiClQrE8nYVCSa+q8IX+nxtv5HLLQieONNRcbCbbp58+UfaWDrJpw1t2wLalwv9eN/qRWclziSjt+rFOYK/wtQlCGDPDfldIBTGnSLU8DDsQ2lSnvfbuQZOhEW+Tmk/dtIMKDQltjeR7oIrrhpYbC14c5N1BOptMKT9W5LbGOtjtHB2TxEb7Fo9Ovp440lMQYbaxnOtzSX2fJpFxe0Ah1AJiHeCUQsnVj6DXUoSdPeS95F2ujd+RZ+WoKP0D0hyM1kJZPP/BXS9qgfhfCyGZcYZplk0hZB7yZd2HDf3X47KSVIsujnU3jAbaRAgkmyPiCxTi9OWUxWvZNe1kzP0mhMPL1mkTGWP8o8G95USX0k2734+wNuNpkmYrNnEDvygz7D2TIrtgE1UWdIxoiGC0ulGgk8+BAa+DLKyAksMc66gzCfgo5GKb7qZM/ksBUOfIsNXu3dOWgVC8gt6li0rQYGJks6V6sn0pRlHLMlxuO790qmRhSMl2ELFcG5F6Va5cTh8YqfiTjOAFGGIvEi52z9SK0vpwTuOw83xCloff+ZNlZy9sDK0mGy9vKM6/QTS2hpyKH1QRWKKBCDPU0n3DdMg1qZSJYw1cJlGtLzdG6BC3CxDeKMD1dE7KbGT+isVFOlkSB8MAJXG04pc/qRx+U6LACjVuQLwLbPjUKLCmAqnLqmPjVjgtX24kFYCr8rVBvSg1rXbppJFhQq+/nYG4lkTZQBmy/q3h82/7gTCrddFUUXc4nqZ6BGQVor4fTHjwJ9N2u1MBpYl9NRTI5LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 6:16 PM
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
> > +static int get_affi_llcs(struct sched_domain *sd, int src_llc, int dst=
_llc,
> > +			 int *affi_llcs, int *affi)
> > +{
>=20
> > +			if (src_llc > dst_llc) {
> > +				affi[j] =3D clamp(src_llc - dst_llc, 1, 1024);
> > +				affi_llcs[j++] =3D i;
> > +			}
>=20
> > +	return j;
> > +}
> > +
> > +static int get_affi_numas(int src_node, int dst_node, int *affi_nodes,=
 int
> *affi)
> > +{
>=20
> > +		if (src_dist > dst_dist) {
> > +			affi[j] =3D clamp(src_dist - dst_dist, 4, 1024);
> > +			affi_nodes[j++] =3D node;
> > +		}
>=20
> > +	return j;
> > +}
> > +
> > +static int calc_affinity_numa_score(struct sched_domain *sd, int src_c=
pu,
> int dst_cpu,
> > +			int *affi_node, int *affi, int *last_node, int *num)
> > +{
> > +	int src_node, dst_node, score =3D 0;
> > +
> > +	src_node =3D cpu_to_node(src_cpu);
> > +	dst_node =3D cpu_to_node(dst_cpu);
> > +	if (src_node !=3D *last_node) {
> > +		*last_node =3D src_node;
> > +		memset(affi_node, 0, (max_lid + 1) * sizeof(int));
> > +		memset(affi, 0, (max_lid + 1) * sizeof(int));
>=20
> This and..
>=20
> > +		*num =3D get_affi_numas(src_node, dst_node, affi_node, affi);
> > +	}
> > +
> > +	for (int i =3D 0; i < *num; i++) {
> > +		if ((unsigned int)affi_node[i] < nr_node_ids)
> > +			score +=3D sd->numa_counts[affi_node[i]] * affi[i];
> > +	}
> > +
> > +	return score;
> > +}
> > +
> > +static int calc_affinity_llc_score(struct sched_domain *sd_cur, struct
> sched_domain *sd,
> > +			int src_cpu, int dst_cpu, int *affi_llc,
> > +			int *affi, int *last_llc, int *num)
> > +{
> > +	int src_llc, dst_llc, score =3D 0;
> > +
> > +	src_llc =3D llc_id(src_cpu);
> > +	dst_llc =3D llc_id(dst_cpu);
> > +
> > +	if (src_llc !=3D *last_llc) {
> > +		*last_llc =3D src_llc;
> > +		memset(affi_llc, 0, (max_lid + 1) * sizeof(int));
> > +		memset(affi, 0, (max_lid + 1) * sizeof(int));
>=20
> ... this. Why do we need the memset()? AFAICT the get_affi_*() functions
> use direct assignment and the sum is limited to the number returned.
>=20

Yes, the memset is unnecessary. get_affi_*() assigns directly from
index 0 and the sum loop only reads the *num entries it returned, so the
rest of the array is never touched. I'll drop it.

Thanks
Jianyong
> > +		*num =3D get_affi_llcs(sd_cur, src_llc, dst_llc, affi_llc, affi);
> > +	}
> > +
> > +	for (int i =3D 0; i < *num; i++) {
> > +		if ((unsigned int)affi_llc[i] < sd->llc_max)
> > +			score +=3D sd->llc_counts[affi_llc[i]] * affi[i];
> > +	}
> > +
> > +	return score;
> > +}



