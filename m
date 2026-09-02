Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79760C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8636B0088; Wed,  2 Sep 2026 03:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379F46B008A; Wed,  2 Sep 2026 03:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2911C6B008C; Wed,  2 Sep 2026 03:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBCF06B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:11:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60752120756
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:11:58 +0000 (UTC)
X-FDA: 85167952716.11.AC85289
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5445F40002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:11:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788333116;
	b=FLHGfg8yS5Zk2frcn/2cW92sjQdjQ4wmNdtun/XRWIavgmNVkUSrneaT8nB/N+QaqnZkPp
	ru/tY9d+r16nBHcU77fVKHDID/3BfbT2UBcW/6jSt6moyjKW/bPzNtVsrKZocB+jqq00zO
	yaSeHOODTz2uqCsyIbM5vqOUp8JIxWQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788333116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yoRaE6nVraYAxXPdqQmVPBanWhtTUVBc6uj3ATGtsQ=;
	b=3JMuHBA/w6Blb/3vLMOoNXvV3oUGOFYVF3CtvBlbl/9kBF4JGrBGPRJAPz+7BoPh6fzq+L
	cJltL59p+mO5tQIKZEoa9xrHT6tqEvg01Sn9d0fgFLHwFjtof6CUyyMO6CZ0N79QDZdpFc
	HZfXtE0biOzG/JgoaXsDusUmzmcAvo8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf27.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZYnK5qycz3tlrP;
	Wed,  2 Sep 2026 15:11:49 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZYnK0Ln2z3tlrP;
	Wed,  2 Sep 2026 15:11:49 +0800 (CST)
Received: from cncheex06.Hygon.cn (unknown [172.23.18.116])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 6BFA91547;
	Wed,  2 Sep 2026 15:11:43 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex06.Hygon.cn
 (172.23.18.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 2 Sep
 2026 15:11:49 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Wed, 2 Sep 2026 15:11:49 +0800
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
Thread-Index: AQHdNiA3jheQVPdvikWpN4gB9aTKG7a46tIAgAH5vHA=
Date: Wed, 2 Sep 2026 07:11:49 +0000
Message-ID: <eb0d68d8cd744eb9a364606065b3e6ee@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-3-wujianyong@hygon.cn>
 <20260901084800.GI4121339@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901084800.GI4121339@noisy.programming.kicks-ass.net>
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
X-Rspamd-Queue-Id: 5445F40002
X-Stat-Signature: tymxs6op4j9nz5wmn3rhzwfttym586cz
X-HE-Tag: 1788333114-125748
X-HE-Meta: U2FsdGVkX1+Hhe6OrS7QJzsj6WSqFsLKvFacPdbT5TMHOC+nhq3uumbDVlwnKspra20tRVQ+5PIOfkQ5d/IXdrNcXMDQFXR4LnATVs2wUUoCzHHKlECGQPtw4zu6SEdWPMJIlcsfpOj5aFMVrGAwDCPB025+NpVmWR6yub96kfr97YQZMyvrTGtjArmgSY5I/fcB1FrFcVa2U9uq75v573kmfwlOa3M2E9+CkX1tU328S9iQjewKqng9KLPkCrbvmEmohAXf9CvwYj6n7WqAnH7dm4EN9sE53VBYQvKkljtXXm/FMO/a8D2odjMuMTW0B1cm4VX2U/JhquWpOBCFtcXTu5lU/5Hto0ZT4fATckUtTMUGIvoUYcZJMNO82lkNLgogN163jJzphzSAuHiB2merVVKR+hgqXZmp9wmtrAmgIeAlsCdRWUGKJMe5MinJR5W513cGCBwR3BSDtRbipzK40+RizZmnutxmsLcsZev9vuvn5aVsxA8/mTC6qCn87yc7a1yWrOL5iD4B+G03CH6PmOVJFE50ldd8K6p/ED6eIC6kGxlA/KYPwCmVTbH1C/OaArS64dKC65nqsb0m1T9cfMRvi7DvSxRtbFnPDmPGzXI+pQxTzBTuksZAhZnr4+hCjApAW8vZ2VudjjjW8wsyUV7pKYI+gcqb91yqIsArSR59eJKJd/DqWD1BmrbBzuHJmA61SUSW/8PC6X4T3/r11XJ/RYsfC0l4Evd6eQfpF7O4FWuUzP9ENZEMBAyg3nWy4ilyWbnaVaEI/uglOx6GyNQ4vBQuioAy2yJxiaGfIg3ZPLTCwun6mzP13uAkeXygQZ440x/frDVoFx//zsJ1FuCXSJ/w8TkCEZPXTbdvQS4cBUZ4NOc/r4igJn5hZbp/Uh5ejLPovOBfTs78MDN/g559JKrO58yFLz/4z1OLXbl/WIIdIgn8qzpdsJ82o8Ft5yBrzs3XOJbVzmg
 QUP5JUYq
 Smpe+K3oXQWc5ac/8b/MvqfwblM6XoAg+DFT8XnWcrpFo0mr64+wbdQ1joR+wGzn8OAWkZpi69TYJ66AG6MEWJA8HYn9lja6PpODj6E3Ri9SD4JTb74o/PrbRJ72t6VtNbGx4dhK1piEU0yJtTfshqncqPF2fV7MkfFABn+sE0Nknr3gSVrsy3n/PjymHGjMPPXCcLFhMEn1RYdhFc16K/iNvW/Ee0tfOwAC47/hOKXDeuVxHnAIdpo7SYnd8dEypr5Pid3TobyPqC4aHfquf/BbDK7Q8g+kCpPecldveWOl/+vVdKSZiMf27Yo2uUp607Sl/d75JZjKMwJU6YJGtPUWxYHgXK505BTI9Gu8K/4iugsKxixnklaEleVOt0JUPkjbVTVn8LVJbkCJ8fXtzo9Q+0Nri+y5uFB22vKJXDzYnUInjvgC0A3b9mraN2LVXTgnr7HG1O15r/hphKL87xlh2CLpuyecm17V5vXcRaaob/6wROe3UjEIF3gy5/B10vgFsyiLus6FJzzNFiAHylNEBLU7TOnAzOcW0Xn+oJOKgurlFrr0R1KV9aBh/l5Fkp91aXFZlEFc3kyc8EhnHn0MTDz0U0+TQ9En+Yd2Ezl4GO+FoVIcP10UZB2IB6VNGBd6sL4iRttC3nw9E1jTC5XIJlKJd3wS5dyW90b2E4rqQb5CDcPU+RX4nJ2tkW75vlMJfXhMbLiJXoDl1R5wKwyjmd9embh99leM4Ygzinan6Xf0MQ2TiDuAeIY6MiH1JY5uOHYDKktgJ/O+ZogQNxFx9Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 4:48 PM
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
> >
> > Each row of this refined NUMA distance matrix is sorted in ascending
> order to
> > generate a unique per-node affinity sequence. This sequence will guide
> > thread migration logic introduced in subsequent patches.
>=20
> Hmm, I wonder if __build_all_zonelists() wants to use this, rather than
> the unmodified distance table. This would ensure the node fallback order
> is distinct between nodes.
>=20

That is an interesting thought. Before building this node distance matrix, =
I
tried to reuse the zonelist fallback node matrix. But I dropped this idea w=
hen
I found that that matrix is not symmetric.

After searching the code, I find that build_all_zonelists is initialized mu=
ch earlier
than sched domain. So, it seems it's not easy to let the zonelists use this=
 refined
node distance.

Thanks
Jianyong


