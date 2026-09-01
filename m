Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DCAC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0396B00D3; Tue,  1 Sep 2026 04:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0F66B00D4; Tue,  1 Sep 2026 04:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8016B00D5; Tue,  1 Sep 2026 04:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC856B00D3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:42:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E81DC0380
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:42:06 +0000 (UTC)
X-FDA: 85164551052.24.DE160AC
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf17.hostedemail.com (Postfix) with ESMTP id A79E440006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:42:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf17.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KNgv1Uu7jpoFtkLPKa1otCXispNoaKRAhLQuUIgljV4=;
	b=Cyou4N6NvrscarcraM/uvfdjVg5PAFeNDRBbHDHoBqfPZdlFVkoiFMiAiAKsQuCBYgx6O0
	Qp/EXcPmgvcYETdb+q3L1q5oPQAJXI5W47yZcNbq5pCQFhaHYKAj8d5KBHatgDY4PGYjVV
	UZT+B7grgb0llL9ZN22lmx+hiC+QZ28=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf17.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252123;
	b=buk+WJWCDtR2yqF2NR3HbqQKh5lU7JccPzmkezqy52AG1QlGxF+J+FfTQOQbDDgntQoUJ0
	awLXTb7DXVT3rvUONqLlwwrf07RXAQfDm/BK1LZ90hUG/80dympn8rQ0D0uCUMGpAbaWkv
	xFkO8fdJKp6SmURJhS+oPL7aYAOVyVE=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYzqq0w4zz1PvqW;
	Tue,  1 Sep 2026 16:41:59 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hYzqp5ztfz1PGCm;
	Tue,  1 Sep 2026 16:41:58 +0800 (CST)
Received: from cncheex03.Hygon.cn (unknown [172.23.18.113])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 9620391CD;
	Tue,  1 Sep 2026 16:41:53 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex03.Hygon.cn
 (172.23.18.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 1 Sep
 2026 16:41:58 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Tue, 1 Sep 2026 16:41:58 +0800
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
Subject: RE: [RFC PATCH v2 09/23] sched/cache: Account percpu sd task NUMA
 preference
Thread-Topic: [RFC PATCH v2 09/23] sched/cache: Account percpu sd task NUMA
 preference
Thread-Index: AQHdNiBCJVRJ7kz1s0edST4cJKOnbra43ACAgACSGvA=
Date: Tue, 1 Sep 2026 08:41:58 +0000
Message-ID: <5098b37beecd4249b49eb0942fc5058b@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-10-wujianyong@hygon.cn>
 <20260901075457.GO4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901075457.GO4120091@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A79E440006
X-Stat-Signature: c18wehacqthuoz5dfju548o7aymascjm
X-Rspam-User: 
X-HE-Tag: 1788252121-431505
X-HE-Meta: U2FsdGVkX1/d2HjPhGLPEqhWoVye7KYPKkgac52cJP1DyK7hlJB/x7GwHm8iQZO4cRtRn/rzgxM/JcFhhjFQjf7dsPkaZYv1WigSM2nGme1zRGQ9mq9zeo0y5vfhNOaXZ1Qo6qArryhPaFEm6bO6ogCM3UaH2+tW2HIrO9ebMrM+YMxOQ+SRqDCajrHsq7xUzMWFCIragAW6a6k83M+CIIdD/eqsYkmIYn8jJe/3oQtWv//Fhb7Ya58Vk12RJnUwhYshR+TYMdih6qGuw4OShssYDpQtbb5dcBtJe8IcqiHaVzlnW7nFNRJ0pZtpQC/rzywBwUpRNCC39jHY3ZV21lPIYhUs8XSm9VSbZ7hpesLY2dxY/R4wGkuWyDrOJNp5LkDlZ/vPzsb2NXA5E7FwhZgEQLylwyZR0jnXp/1flOErga/8w7olW1ETzCupElnG//YKCHbnUf/eCqsV2MufXKOY20v7SbfPxqqhy1qEcy3xI47QCBxjsZ/ufP9G/fNNwmuStyNDIZMq4dtxNZPHVXLEFHWK1PJn7JonqMZktQUZ8ZyjgP23v4cFEQstbDqwKFHKB5wltMrzK38IaCB3Z0VjqhzHxfF0dMLAJrp6UPGzAiP5uYyqJSdh/OJ4lkeUrQJzA1HQDTQEJwI7fsVsfID8BGhbUKQhYNbYQQTX2lJ1/iE2nVfY7UXHCSYpqH+gHlSx6AjV4Jl3uQLb6qNj8/+b9k/tepcJFzPihoP73FUFnNTYiTtUwWqUN/BhBUGF1Aaubxtc8uMw4dX/By5zZMyeoOYUgJt6BMkpr3xgaAeeDOQtg4/g6TubgzS9vtj5bRf3zJKprx8zpa7i+ax1W9Z9yb7ScfjcfS3XOBtFn/K4xXGW6tptjMPqxaj4W89QPK3XWOsY0z475j7xPmBNXOJ8X48GsCauo8gq6CW9mD00jUvUjWXbVN107NXH+0WL5BKUJKwir47U8AnF7KE
 KRnabDwA
 VWSIYonn2gLqamk1yd+C7sPJf93FtZZsqWSCNLMdtpDZ6CaeITaC/ZyA4qxZ/R8kETSrjahPmQkx4iugrKsrRFXHZ9rw5+l4gw37Z6lWvFe9vamQC8+QTlIlCYr5EitgR9vp74aPMFpwSubUQu1HFe6ZOBOO85sXFzYNEPR5UN194F6goMRgFSMxOXjgVEhex6tNcadTvUccZDCd0jB/WbPm5P1Djhkmpg9d5Xs8DGDWiUggosyJmI0G22CdEsw92tZZrm9/ZmCeRrowFd2Pp21cq3+Ao4o+8WOMDRjVBNqoW/Vjcec/ThZLbwZXE23gX9y76HDSqwunu6ccxee/bUCYNB4NgXaDz3OLm508ImeDs5Ti0zCumZYxdGScsHwy7cwzrqS0ttXqRrIaj7oUJAPWokdyFAUena40GhhFcbSoAbUQBIYkJo8eP1pYFp/ZqDsCa3zXhPN3ZVtf3HzM8jWv5DVR2i2rq+/tvWpwFvH9l99X4+RLzqYBS882ZfAMWJVi8NClg4AbpL7FHwhCNa9Azo4jdcrHImJvyCfJXlzZ/TNqIUbiv/ZQZjFW9F/BNGGM4806MFsuRzHSPdPvErWzew4VBScLld3H019XS4TNEEm6Li9t59wVB9lHaEpTJUN/Xj3PvS/eo6JKE3rTB1E0IhMc5D5XS6BiH/FkKzghxy3EeDRlF1WShGJvbazvbCZmfjp3rdTtfgryWCoOxHz3NFkWnx1FvhwjH+KoQQvneYnm6aKA4tdyuKt1Ko6a7mYczzMHR7PwpW3g+yQ1ptYT1Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 3:55 PM
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
> Subject: Re: [RFC PATCH v2 09/23] sched/cache: Account percpu sd task
> NUMA preference
>=20
> On Thu, Aug 27, 2026 at 08:28:02PM +0800, Jianyong Wu wrote:
> > Account for per-NUMA task count preferences within per-CPU sched
> domains,
> > mirroring the existing implementation of LLC task preference logic.
>=20
> So in general I would really appreciate a few words on *why* you're
> doing things. I mean, I can read the patch and see what it does, but I
> cannot divinate (esp. not without yet having read the rest of the
> patches) why you're doing things.
>=20

Fair point. This patch lays the groundwork for patch 12's NUMA-level
affinity score: that score weights each NUMA node by how many tasks on
the rq prefer it (numa_counts[node] * distance_delta), so we need a
per-node task count alongside the existing per-LLC count.=20

> This is esp. important for large series -- or series that do complicated
> things -- or like this case: both!

I'll document this motivation in the commit message.

Thanks
Jianyong
>=20
>=20



