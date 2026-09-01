Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2EDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A1F6B00A7; Tue,  1 Sep 2026 02:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAF46B00AA; Tue,  1 Sep 2026 02:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0126B00AB; Tue,  1 Sep 2026 02:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF9A6B00A7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:57:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5F2C1202FC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:57:56 +0000 (UTC)
X-FDA: 85164288552.05.DDC2396
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECA96C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:57:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cS+8sQaSugngJZa8YBoL8r8A0iK/dHZHJRVDhKWCB9s=;
	b=2Ni43/7O/iemwXix5JC8TuhvLtwkqcqB93hDLrb/o3RsX+rFvyiwBaK3b1Tta7IUaq3IFN
	efq9/K7tuPZT27M5pzwRFRtN3iNzm1zYXgZRhR9fmrJiXUhcipKkb5L7sjQwzUSfMNgd56
	F4xXg1sFhFi/s7W5CiRbQqQ6O1z+gZ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245874;
	b=EjqlXJy2R+cK9hPGQT04o9uOnniPS8RhZ/Ox1YgNcptJ29O21CmkCZfWvLsedO/Rd46dgV
	l4uwRFvvPYPYHquyHhA67vct/t2z0kg4nLI2u6nvFWEJwHlO7z6IyM7SPg2AG8M9F1TbFI
	3BfR11X1TGcLHWtPXZwZ2KhX/TEQvgM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf28.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYxWY3qdCz1PGD2;
	Tue,  1 Sep 2026 14:57:45 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYxWW34y9z1PGCm;
	Tue,  1 Sep 2026 14:57:43 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id AE13330004D2;
	Tue,  1 Sep 2026 14:53:52 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 14:57:44 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 14:57:44 +0800
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
Subject: RE: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Topic: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
Thread-Index: AQHdNiA3jheQVPdvikWpN4gB9aTKG7a3i1wAgACO1RA=
Date: Tue, 1 Sep 2026 06:57:43 +0000
Message-ID: <ee97dce1db374f50b8e87e51ad133d96@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-3-wujianyong@hygon.cn>
 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260831115004.GF776954@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: jgkwedywfcoau5efa8oaas47qnez73p7
X-Rspamd-Queue-Id: ECA96C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788245871-394452
X-HE-Meta: U2FsdGVkX1/7sCBzM3FNBz9qxsnKD81Dpyy735dZrc0Wlkkhb/IdQfIaBk4MZKtCH7hxFbraDx/hsypn6tGn1Hxf1WOTu7tgIswBBPGlI2JkMLdd2tqiQ3Xm3AYr5DQOXgtnXM/fZKfSYcsLPhR/YDP51uwpv/e+YN4bKhW2ZVznzJL+JrB2ABio+DzisU10XUj0SdaMSlGA0n/xSamynf7Ccc6Z4PFrBxpfyIVpAoRljF/Ks7A5JSG63fIqyjyuPzRp6p33p9K0qKTIkcSj18yBEdCqRU3rotiKVvyS86M7MsraBDJ1GUFIlZqfvpkCC26VWGPDDWS6lIsU8T2phXVwfmggh6Oi7pO3CADaf4sYgrIWB4DnZfCiIBtqALs4N6b3Vw3AN0idTFnwxsQI/lWsnzvnrr/i1TusJo3REToRxOoWYVCNL5eq+PdaoMb8FtCDk/M/ZbvSdzjLn1lCLg90adM8qLkBccvse+EFzwekRjuLVGvg+vqcH1rXtajR6MZDgJNxMkHvODKD6S+q4ljXAezj1bJgfgKPYgKy3GrhCKaHCusACwXpycZbOj7cMQLaWZK+AR/zoNFlvadFMNvwXoGXkIOHt0dk1tud0ATKCN+axeEbX0vjt5gNSdvkWtqTb814/o+TBUKIQ4/T8Tj93lu63d6/Il4TpSBx2aD5HeN/v2IjEBrmXCa6hKpEUr/WNloitPBEybSNjFP1a95c2PJMPkez8mtFoxHu+rYo7rR6yqQa4RDNQGQuEQ8zs7oSEiYga57AwfAOSh8eLnxI3Hy2RCWE8GxVBXECxySCbURA4y1A4xhwsNOLYuQBBG5EBY0ZMni4xtmpgrrscRiCJyfLHZl7lq9HGIne40hRU+LsptDemfYV3VhNnkvHPqqS6tbGIR+A4Ly8jXpOfAc1r06dzAV1U8/iLXsg3eIjTovgfG2FnITzN/TOLKhDULnztunT0d2kTn/zXtR
 APlAytXp
 HawWWZlnwqf96de97kmsJbb0VD5ShggwJxvomAavTAqVXfXwFWqmO1zzD2Hc8PnfmOcAryYogYiNyWmJqtPqrQSjGa3vWhHefyLYgm8NudFQnICZbrofJUiGHVqJJf15IwtiMNGiXkKyg/iiXttVGMzgeJCki4btvfF4Vf7wtSx5NjjREByRZEZ2Ul5sQX388XKvMPMOYMnxH7xOQL86g6MJWrsjyZqN8JiZlRhToElZaAdR5cH2XFzXd/zF/W0PeYv0E56+florR9UHeROVAAiDVDHGOmY7p/C01gzSvr5xrXytPCX8NLPjFD/aCOWjnzDDhbBUP0fful6+JVeNAtH9xVhEBBDau8gapxoqL8Po6RKGwXldVsnS6qB7uEUtoPPqhRFoa2urrnhv+sxOthok98wrJjwFhrP5+LYinAQlXBJQSq+9Pc9WLpzg7TasXuCe6KlQXxs5B5+KRMa56+9/lGx4V9+BQSpeLLRYM1l4DDYiPP8pxE5MFJ4T7TYY5d8VYG8QyFIejsJrrjZZfZtTNEiYpS1PHIAF22mbzmUJ+MDQ1uqQO/9fdPu/CdeViboY5tebo0p2xUa20GUdeQfpIGulSPD7pmovjT/Z5BnbTVx3w3xyqf4CifN5takzH0bedcvJHpMCJCqzDA6LTHxcSqKrBpCSJlsL5NwCtPV4kji8j+0XdcVYg9T1i84fASZitUCyy/cog4pN+Uy+8E1b4QchOJK2IL+BPGUXaZoPpIIJkinN2Dm6OPS8muCfzq8do/XQebuVeKKgE8zSU5SwJ8CD2YifmJdzh41rNEe3dQX2Cf5+1AfY3xZ+voZUhQF6GoD3amY1+S90ugNzk+WfOHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Monday, August 31, 2026 7:50 PM
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
> Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA
> distance matrix with unique distance values
>=20
> On Thu, Aug 27, 2026 at 08:27:55PM +0800, Jianyong Wu wrote:
> > Builds a refined node distance matrix based on the raw NUMA distance
> matrix
> > provided by BIOS. The refined matrix preserves the relative ordering of
> > NUMA distances, while assigning distinct distance values to node pairs
> that
> > originally shared identical distances within each matrix row. This matr=
ix
> > is exclusively used for cache-aware scheduling and has no impact on
> existing
> > NUMA topology logic such as sched domain construction.
> >
> > For example, consider a system with 4 NUMA nodes. The raw
> BIOS-provided
> > distance matrix may look like this:
> >
> >         NODE0  NODE1  NODE2  NODE3
> > NODE0   10     20     20     30
> > NODE1   20     10     20     25
> > NODE2   20     20     10     20
> > NODE3   30     25     20     10
> >
> > Multiple duplicate distance values exist within each row. After the
> > deduplication step, the refined distance matrix becomes:
> >
> >         NODE0  NODE1  NODE2  NODE3
> > NODE0   10     15     20     30
> > NODE1   15     10     12     25
> > NODE2   20     12     10     15
> > NODE3   30     25     15     10
> >
> > All entries in each row are now unique, while adhering to two core
> principles:
> > 1. The relative distance ordering from the original matrix is preserved=
.
> >    For instance, original distance(NODE0, NODE1) < distance(NODE0,
> NODE3),
> >    and this relative relationship is retained in the refined matrix as
> well.
> > 2. The matrix remains symmetric across its main diagonal. Maintaining
> >    symmetry is critical to guarantee consistent pairwise node distances=
.
>=20
> This example uses Node only, but the code in question is specifically
> aimed at Cache granularity; might it be better to use a cache example?
>=20
> A little something like so (I got tired of prompting Gemini to generate
> more complicates / less broken examples)...
>=20
> Pre:
>=20
> Cache |  C0   C1 |  C2   C3 |  C4   C5 |  C6   C7
> ------+----------+----------+----------+---------
>   C0  |  10   10 |  20   20 |  20   20 |  20   20
>   C1  |  10   10 |  20   20 |  20   20 |  20   20
> ------+----------+----------+----------+---------
>   C2  |  20   20 |  10   10 |  20   20 |  20   20
>   C3  |  20   20 |  10   10 |  20   20 |  20   20
> ------+----------+----------+----------+---------
>   C4  |  20   20 |  20   20 |  10   10 |  20   20
>   C5  |  20   20 |  20   20 |  10   10 |  20   20
> ------+----------+----------+----------+---------
>   C6  |  20   20 |  20   20 |  20   20 |  10   10
>   C7  |  20   20 |  20   20 |  20   20 |  10   10
>=20
> Post:
>=20
> Cache |  C0   C1 |  C2   C3 |  C4   C5 |  C6   C7
> ------+----------+----------+----------+---------
>   C0  |  10   11 |  20   21 |  22   23 |  24   25
>   C1  |  11   10 |  21   20 |  23   22 |  25   24
> ------+----------+----------+----------+---------
>   C2  |  20   21 |  10   11 |  24   25 |  22   23
>   C3  |  21   20 |  11   10 |  25   24 |  23   22
> ------+----------+----------+----------+---------
>   C4  |  22   23 |  24   25 |  10   11 |  20   21
>   C5  |  23   22 |  25   24 |  11   10 |  21   20
> ------+----------+----------+----------+---------
>   C6  |  24   25 |  22   23 |  20   21 |  10   11
>   C7  |  25   24 |  23   22 |  21   20 |  11   10
>=20
>=20

Originally I tried to use a single big LLC distance matrix. But once I real=
ized how much memory and computation time it would cost, e.g. when calculat=
ing affinity scores in later patches. I dropped it in favor of a two-level =
scheme: the first is a NUMA node distance matrix, and the second is an intr=
a-node LLC matrix that only encodes the LLC distances inside a single node,=
 so it is very small. This way, both memory and time are greatly reduced.

> > Each row of this refined NUMA distance matrix is sorted in ascending
> order to
> > generate a unique per-node affinity sequence. This sequence will guide
> > thread migration logic introduced in subsequent patches.
>=20
> IIRC greedy has significant worse bounds than many other schemes. This
> would result in more unique distances than strictly needed here, right?
>=20
Yes, Greedy edge-coloring is simple but can't guarantee to get the optimal =
result in theory.

> Since this is all on slow paths anyway, does it make sense to pick a
> slightly better algorithm in order to reduce this bound and get better
> results?
>=20
This matrix currently has two consumers:
1. it is sorted to build a unique per-node affinity sequence;
2. its values are used to calculate the affinity gain in patch 12.

Therefore, when changing the de-duplication algorithm, I need to consider t=
he requirements of both
Consumers, For the first use, any symmetric matrix with no duplicate entrie=
s in a row is sufficient. For
the second use, however, the actual values and their differences may affect=
 the affinity score.

It is not yet clear whether using a more optimal algorithm would provide an=
y real benefit for these consumers. I will investigate whether a tighter ma=
trix can be generated without introducing too much complexity, and then dec=
ide which algorithm is more appropriate.

Thanks
Jianyong

> Anyway, let me continue trying to dig through all this.



