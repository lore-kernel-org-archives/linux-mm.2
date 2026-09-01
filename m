Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DC9C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572836B00BC; Tue,  1 Sep 2026 04:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A1E6B00BD; Tue,  1 Sep 2026 04:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460FA6B00BE; Tue,  1 Sep 2026 04:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC186B00BC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:31:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66A0F14035A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:31:43 +0000 (UTC)
X-FDA: 85164524886.27.6D812E5
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3235040002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:31:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf17.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788251501;
	b=FxK50aXmIDyEYQFpKPRsb7psAA7u+aiO1u5nuAVNEz8XKxtMjNQay8hYgmLeUn8qJXZBtW
	ulZxnJjXtLwRDgb3Poo9UN//GMr/wXgNcdYv8pTa7TwcoRKfF8GL73dD+UEf179MXosl0R
	oUBZXfQFq4XGTHU9FaMjChSYwUAbp1k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788251501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4dXuQi6Jk9Z76VcireLxucjmD32filYi4k2zaMMbLA=;
	b=rmJqBwn269mX257Li+Ly7PnfIYGCj6xuDDiIUaXdpyLrbPTTnm12RqO+zTVkb13n4elqgb
	z7bHmD8tFbT8UZzLRuGwrchXLVS0ex4iJhci7WI5PwVfCSALLDoyIjSbAFY1R2QiiWyjeT
	qz56BW1BgkQ66r7fh7lU9MCocKpF0zY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf17.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYzbt0QLfz19hDf;
	Tue,  1 Sep 2026 16:31:38 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYzbq5Y43z1PvqV;
	Tue,  1 Sep 2026 16:31:35 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 87479B351;
	Tue,  1 Sep 2026 16:31:30 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 16:31:35 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 16:31:35 +0800
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
Thread-Index: AQHdNiBA7oAH9eDim06x96D0XIAuLra3pasAgAHCg5A=
Date: Tue, 1 Sep 2026 08:31:35 +0000
Message-ID: <8eb55be5c1e9497c9f34f15436b9d665@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-9-wujianyong@hygon.cn>
 <20260831132414.GN4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260831132414.GN4120091@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: 3235040002
X-Stat-Signature: gz4abg9f4woydbetrpawzsqggk5uss17
X-HE-Tag: 1788251500-765309
X-HE-Meta: U2FsdGVkX18JTr3xlD4LjIEOp12HlO7qMsJYyq1/LeLlnlekKtoeC52BfvAgsTCzCoqZKEn7dJ0+on8immo/26HYoDVjfCatoMMT7tpGYOmx84pl9Amgz1MReSn3OBiuL6twPFUxy9bPJLGMs24cRkq8e1sAiQ+t+1b8bvQ4/BrgePrJUQiI+Qi9QJv8dBmMvvRDSapnWvn+bhauKkNECFEOq3hQxus/6z+/WfJuH8VmXEmQb22B+ubyFFsxkXhSanNXrQz/8zcp0KF/bS8J4vUxiJ6phOW1y2zjPUSv8CLyJyLmV8aaUwIM6ZsCj4DTh4VhKoHsQUOJQvfr8z8Q/sn9Ejxyk+YNPOxtJWn07qB020uGQegEiblO2j+eokT2b09Uq57hZeCt2UdUKnRdj1c+wlEobqgFXZLuwAxWofs5Eg3xgaacQ9o9MlU4/atKxdWfN2/KO73sOEA5NXegAihT67drBkFBg3MZOkqE4QvZ2ZXbhHmnZglrULvb60Bx7dzTkBE5+oryX8pypH3Jarh1XQZRfEE4nVCiz1DFmLLFwZXV285NtlqFc+V5M7Db9MbuHo+Cmx+7yqrSCfe5TVaNAzrTon/zK/bn4Rq/9NKAyXDZ6xFDJ7bPhZTKn5dANLzpQZQvPiCrNxI3XrUy3dhh+te2QLhYkaUvxBzwzRejoT8Ai/qzH0mu1Azn4VcuMo8P8yySCwAJ7d4atCEswZEPNRTbaytNHw8nRQmZ2d79sgGOQFRLm03gFO9a2IkAjaBiIr1FnkGS/NftWAMQG4lcVi5TcRfdSrmBAFQdatQpec/BrIog/9WnukYO/P2L0+5iEqQpsGwg8LsK1BIkOO1RBXc0Owfip2qGT6R+LJjV46u3cXMOCVVyNHZL7aPGtmWCCgqv2KiPhe+AMYZqIsxYdcjKwJZRv3xs39uUow4zsvCAmyA5WQVABAZYkA9yCm81rxuKULPUEXMRKsK
 3s9259R7
 ypYL7EsHcNjDe3CUe/UPAg5XxSgzTjwNieHbojRvEwpLINlVsmKNmmxMbs/MnvYtAf+42p9/WW/eFSORpY4qvGi0J4khL2K4JrTkxs8k/xgJSHpuWnlORhxmF27Qs1/4DkuZYTz9pLnApt4s1B8hWUHGullhJNkvcmPj//YkFgL/bgS9EcfXDIcyOW+l6OkQUM7AHEEcykmfeC+aYk/WI1ohN/tAxLVaWDmntO87nMDSD1FyVgS0ehHuDjGgQjlDhvOLo2aKLIwB3ybPgUhzKMQRR5wDlJFQRUpbi3ATuAwL82aqBOaaQiCYUZ/e0qDdiwhKVLiDOrxOs2w9u4SrwUul4G1Tjn5ZuqtDb+d9yIeMfye0Ft1f6jrQmUfk39U5NVm0ovApS9bq9G8iFUTFTxAEFu4XW6U55mERNlY/BydOIzR3WiyCNCpOOXRNBcfLs9ENWMreO1Fed3y+wtA7udeXUFkUqzecQXxeR+OsL5EymdSVSP1ixAfqLcKcXnpaZXcPEV2AUqJbRUHLHEHDNu+ZVvm1bGm92M21L/a2H7yDSb0eY/nNW1r066da8EiLy9X1VcnIAcvgniPI3THCegcaY3YDep3mADVor0YUfzSmXkk28TnoMCnNZPfI8ffXBeyAWHvwpuj5BbaquB0u5Q3TL2VHTbHDrrc7BRalu7MCurB63uKODY0TtApZKTVGy58Lsh6e+9oidyfevtxlOar9nvhgqqVcE+TnZ/af5+GIk26MA4ZjTy1GMUyAZIRAgQ3JuGX8JiuInz7wLt760O94LxYa9VTTwT3CFaaF36gm//N61yO9ClA04RmvLkDUiTDchyaHBt9O6HHDbZDiaGGMYWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Monday, August 31, 2026 9:24 PM
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
>=20
> To what purpose? Is not the node occupancy the direct sum of its
> constituent llc occupancy?

numa_counts is used by the affinity score in patch 12. It holds, for each
NUMA node, the number of tasks on this rq whose preferred LLC falls in
that node.

You're right that numerically it equals the per-node sum of llc_counts.
The reason to keep it is granularity: NUMA-level load balance scores at
node granularity (numa_counts[node] * distance_delta), while NODE-level
balancing scores at LLC granularity (llc_counts[llc] * ...). Maintaining
the node aggregate costs only a single llc_to_node() lookup (an O(1)
array read) plus one increment in enqueue/dequeue, whereas recomputing
the per-node sum would have to walk every LLC of a node each time the
NUMA-level score is evaluated.

Thanks
Jianyong


