Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF21C9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 18:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F126B0088; Wed, 23 Sep 2026 14:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B184C6B008A; Wed, 23 Sep 2026 14:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06E46B008C; Wed, 23 Sep 2026 14:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBE06B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:29:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D32F5A6D0D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:29:10 +0000 (UTC)
X-FDA: 85245864060.07.FB76851
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id BC379180006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:29:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dQiVeOwy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790188148;
	b=SuDaP8oY9We4iHzzQU7gIjRvhs2cUpIZPTyF4gHUFa5sRKrSZWjCFpWg98sP+AJ2vVaw45
	amcSigdrjdBm01p4zdeVzHQfa4xeG8IpmxaaraYsyoSqyyzfNKNulNsXxYYsXoDBMyffOL
	BCW8luav28o2NuiF1qR9W4ouQ5kanwI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dQiVeOwy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790188148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJRggr8Jo+4xnYriufpWi5ZTOCU71H6VyNEQvZD3g8c=;
	b=OYWqNT22WoWbYHi6e0q0YaOlDnhiSwmEAZH9gUB227ZIL92VUvxdJzRK+XhV/cahAazExq
	bJ714i771h5RrN+l1Z3/UqxbIs1fNNkgBGYluqfurzzAowZSvp03J9Lc5qUF1bysFjyqpC
	FGmvjwUR6roRgxigBpHxdBdL9zMkL3g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790188148; x=1821724148;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=E+5H6Hkg/bzB1vGeLXUZfraHnynICvJ3BjbD8z4M9VA=;
  b=dQiVeOwy52MCpBDXhbQ6VW0UqAroi3wNJmltEJ72FnBXiWXBM05d7+4J
   QgOMgyISp8YXXYXsbeBTZOaDLF2jNIx8+6qEoftqDfifO/0Xx8VotaGJw
   w1S7Slpx8vzXgLEnVV09cspuwbu0PGe/zQM2wL+YZxDeR0Gkn050pqKUe
   pT/B9TfDRZT4tGS/hx+7zBaGCqpOc5AXFd2BYVfuddKl5ANnnzh7/hPG8
   /JpKO1p2wTDyTsUiUer9zqlQzD01ockUrUcvxhksbwb1WPLKb8W6M6zpt
   6Q2KlJCvdy8/1oANPi9f3ZeJXioTaqMQ17foCnl7RLfJ2BzDpT0iqUWQx
   g==;
X-CSE-ConnectionGUID: QPpNYAWyTgWqyBv1zefj4g==
X-CSE-MsgGUID: ++WdgW24QmOK5TCZsx4WTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="94735407"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="94735407"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 11:29:05 -0700
X-CSE-ConnectionGUID: GQ8QUU1bRyimf5Xjg38kZQ==
X-CSE-MsgGUID: CjwF445XRACo36KlNejzMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="301675316"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.110.121]) ([10.125.110.121])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 11:29:04 -0700
Message-ID: <ce95ec57af9dfaf4d9ed604ad7337441a543f538.camel@linux.intel.com>
Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jianyong Wu <wujianyong@hygon.cn>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu
 <yu.c.chen@intel.com>, Dietmar Eggemann	 <dietmar.eggemann@arm.com>, Steven
 Rostedt <rostedt@goodmis.org>, Ben Segall	 <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider	 <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Phil Auld <pauld@redhat.com>, Andrew Morton	 <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,  "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
 "jianyong.wu@outlook.com"	 <jianyong.wu@outlook.com>, Yuan Zhong
 <zhongyuan@hygon.cn>, Huangsj	 <huangsj@hygon.cn>, Fengyu Wang
 <wangfengyu@hygon.cn>, Zhiwei Ying	 <yingzhiwei@hygon.cn>,
 "justin.he@arm.com" <justin.he@arm.com>
Date: Wed, 23 Sep 2026 11:29:03 -0700
In-Reply-To: <09261c8222994a41a04ace5f342475df@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
		 <20260827122816.756234-3-wujianyong@hygon.cn>
		 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
	 <da32ba66d95fd88869ba052f97698b9a4d6c3dc6.camel@linux.intel.com>
	 <09261c8222994a41a04ace5f342475df@hygon.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: konc3meo9mpe5chz76uznoakwatjn3qu
X-Rspam-User: 
X-Rspamd-Queue-Id: BC379180006
X-HE-Tag: 1790188147-923127
X-HE-Meta: U2FsdGVkX19FyJrX1PTGlZCGbzHE7bXOoFcD4QuvKGHJvNfrv7p54zjAqI1On0qmKOewY8eN1z5QWnzMQQQ+ZX7UqGFkjiuM1XkBgW1qhR8Cg7p1aC8zi81WaKU7ONVr+5avYDMk/mW2Y0lCYvY6Fd6J636I57dePFsN9HDHaYr1oQAMQAl7xRcEAZNXGpV+vASeXG8uCW7wxJ/hs98Nh2mZ72waGA7wTD8Me1mJMM53odlDV7dRqIb0Ho1VUeevAejHkpo3RjgbkiyWEKD6FI8G/M/5keS5V1TE3/kIFW+Ha4qgzX2ZbKPwaJXf7f4xVmVsOluF+5Mv216XiDry150f0rJZfsbDDN6tO+bYI1TlH9TI4rT1iIPT6Ntsl7bBFbzsoMcYSaxbxY3N/i7wtF4LrO4NAlwlamTdmD+KpRRhN3hYJ0OhfKF+HIJOCc5CKJxtKTYfXdWQPmm3AQxKoIldPNPgYT32gJBW47ktNUN5TMvwsisd9k0Xn6eIjd8udFnhPTqotTLGJHf2VQpoVhVYt8vaVggM+peuNiL0jbVBHF5f3E3deDqr+MfuremCvsx8dkNQs20pauuE0HMcMrvI4C9OXGNJXtT9dcYnj7wkIFpzKyq0NWTB8rRXWOEbsPZJ6KIloxgK+jNdOP7y553Tg2WrYqCfK90jdf19raEwwQqKt2AhhHnncCTz8NLd/pcOvRmKLFqnsxovGWw99oHEtWU+SUZAU/mha2yfZC6VhJ7Nzh/RjJ+ArBredtIDqQbPNTcy5kBtCdekUmmlnaXozg228t7gckjzoQcwZmbxIPKpfdG39SgpD0tqnJoV1rRTXB05BIIbK+Gs9y1q+xUL8cboZU5bcyRbQcR78n3yWWf0xyx441iybu0Ymu6kq5/qXI6DJIMNPaWGoaTkjDxTEEAlcHXV44fDmw2C8dW0J6AEhi0tEBxPth9FhJEFLyE58yR8rknC+eYZXWU
 Jjms5yc2
 XztbcVtzRU6HqDK3J1O+aKc7VnmV5IXo6J4bg74PDIx7hcDuIuasfudXQeg+mV/QrjkpdImfCTRx0pPi8cIeF7aykgy/OL2fvhyXr2oxwwlRd2BSaFdZoXzvAhP19z/n0xjHkwcpukM5bFpFnH7+a4UOcLLl2AlSmjRiDDl00cZDudly1MMUUnpdQG/ucki9V/VvItjVe9EuGAoqwwjPTSgVoDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-09-23 at 03:14 +0000, Jianyong Wu wrote:

[snip]

> > >=20
> >=20
> > I think what we really want is an ordering of caches within
> > the same NUMA node.  So when one cache is full, we can
> > pick the next one down the list.  That is essentially the
> > net effect of the distance de-duplication.
>=20
> The goal of this series is to provide a system-wide LLC affinity
> ordering, rather than only an ordering of the LLCs within one NUMA node.
> Maintaining one large system-wide LLC ordering would be expensive, so
> the ordering is represented hierarchically: a NUMA-node-level affinity
> ordering, followed by an LLC-level ordering within each node.  This
> patch only deals with the NUMA-node-level part.
>=20
> >=20
> > So how about introduce a llc_next array.  We will initialize
> > the array such that it will return the next LLC in
> > the NUMA node.  So for the example that Peter has above,
> > assuming C0 maps to LLC id 0, C1 maps to 1, etc.
> > then llc_next is
> >=20
> > 	    c0 c1 c2 c3 c4 c5 c6 c7
> > llc_next =3D [1  0  3  2  5  4  7  6]
> >=20
> > When we come back to the orginal LLC we start off with,
> > we know that it is time to move on to a LLC in next closest
> > NUMA node.
> >=20
> How should the next closest NUMA node be selected when multiple nodes
> have the same distance from the current node?

You could use some other means like node id or load in the node
if there's a tie in distance.

>=20
> That is the ambiguity this patch is intended to resolve. For each
> source node, it disambiguates equal NUMA distances and produces a
> unique node-level affinity ordering. An llc_next array can describe
> the traversal of LLCs within a node, but it does not determine which
> equidistant NUMA node should be visited next.
>=20

Agreed that llc_next only covers intra-node traversal and that you still   =
                                                                           =
               =20
need an inter-node order for the equidistant case. But I think             =
                                                                           =
     =20
sorting each source node's row by (distance, node_id)                      =
                                                                       =20
already gives a stable total order; the node id breaks the tie. You can    =
                                                                           =
               =20
also break it by node load if you'd rather balance than pin. Either way    =
                                                                           =
               =20
no new distance value has to be invented. =20

> > This will be storage efficient and more straight forward
> > to use than maintaining an artificial cache distance matrix.
> >=20
> > I dislike the artificial distance matrix also for the
> > reason that there is no guarantee that there are enough
> > available distance slots between two nodes.  Say if I
> > start with
> >=20
> >         NODE0  NODE1  NODE2  NODE3
> > NODE0   10     20     20     30
> > NODE1   20     10     20     25
> > NODE2   20     20     10     20
> > NODE3   30     25     20     10
> >=20
> > and there are 16 LLCs in NODE 1, I will run
> > out of slots when I try to deduplicate as
> > only 10 slots are available to fit 16 LLCs.
> >=20
>=20
> There is no system-wide LLC distance matrix in this series. The
> de-duplication is applied only to the NUMA-node distance matrix.
> Consequently, the number of LLCs in NODE1 does not affect the number
> of distance values required by this patch.
>=20
> The algorithm also takes the available distance space into account
> when assigning the refined node distances. It does not simply insert
> one value for each duplicate into the existing gap between two
> original distance levels. The distance values are adjusted as
> necessary to reserve enough space before the duplicates are assigned.
> Therefore, the algorithm cannot run out of available distance values,
> regardless of the number of nodes sharing the same original distance.
>=20

Fair - you're right that the dedup is node-granularity, so my 16-LLC       =
                                                                           =
               =20
example doesn't apply as I stated it, and I'll drop that objection. It's   =
                                                                           =
               =20
moot anyway under the argument below: if the ordering uses raw distance    =
                                                                           =
               =20
plus a tie-break, and the score uses raw distance, then there's no matrix  =
                                                                           =
               =20
to pack in the first place and the "enough slots" question disappears. =20

> In addition to providing the node-level component of the LLC affinity
> ordering, the refined node distances are used to calculate the
> affinity improvement score when selecting a source scheduling group
> or runqueue during load balancing. Please see patch 12 for that usage.

This affinity computation is where I think the dedup actually hurts rather =
than                                                                       =
                         =20
helps. The score in patch 12 is                                            =
                                                                           =
               =20
                                                                           =
                                                                           =
                 =20
    Di =3D dist(src_node, i) - dist(dst_node, i)   (kept only if Di > 0)   =
                                                                           =
                   =20
    p  =3D sum_i  numa_counts[i] * clamp(Di, 4, 1024)                      =
                                                                           =
                   =20
                                                                           =
                                                                           =
                 =20
so it reads the distance *magnitude*, not just the order. Feeding it the   =
                                                                           =
               =20
refined values manufactures gains on exactly the node pairs the dedup      =
                                                                           =
               =20
perturbed - the equidistant ones. Using your node matrices:                =
                                                                           =
                =20
                                                                           =
                                                                           =
                 =20
    raw:                          refined:                                 =
                                                                           =
                 =20
          N0  N1  N2  N3                 N0  N1  N2  N3                    =
                                                                           =
                 =20
    N0    10  20  20  30           N0    10  15  20  30                    =
                                                                           =
                 =20
    N1    20  10  20  25           N1    15  10  12  25                    =
                                                                           =
                 =20
    N2    20  20  10  20           N2    20  12  10  15                    =
                                                                           =
                 =20
    N3    30  25  20  10           N3    30  25  15  10                    =
                                                                           =
                 =20
                                                                           =
                                                                           =
                 =20
Scenario A - a locality-neutral pull gets a fabricated gain.               =
                                                                           =
               =20
Dest CPU on N1, source rq on N0, 5 tasks preferring N2:                    =
                                                                           =
               =20
                                                                           =
                                                                           =
                 =20
                  dist(N0,N2)  dist(N1,N2)  Di   contribution              =
                                                                           =
                 =20
    raw           20           20            0   5 * 0 =3D  0              =
                                                                           =
                   =20
    refined       20           12            8   5 * 8 =3D 40              =
                                                                           =
                   =20
                                                                           =
                                                                           =
                 =20
N0 and N1 are physically equidistant from N2 (both 20), so pulling those   =
                                                                           =
               =20
tasks to N1 buys zero locality - raw correctly gives 0. Refined scores it  =
                                                                           =
               =20
40 and the balancer may drag all 5 over chasing a gain that isn't there.   =
                                                                           =
               =20

Scenario B - two physically identical options get fake-ranked. Dest on
N1; candidate sources N0 and N3, each holding only N2-preferring tasks:

                  raw Di   refined Di   after clamp(.,4,1024)
    X (N0)        20-20=3D0  20-12=3D8      8
    Y (N3)        20-20=3D0  15-12=3D3      4
   =20
Raw Di says both are 0, i.e. locality-equivalent, and load should decide.
Refined ranks X over Y purely from invented deltas - and the clamp floor
even promotes Y's fabricated 3 up to 4.
 =20
Note the dedup only ever perturbs ties, so the skew is confined to
equidistant pairs - which is exactly the case where there is no real
locality difference and load should have been the tiebreaker.

Stepping back, the matrix is being asked to do two jobs at once:

    - ordering: only needs a deterministic total order, which
      raw distance + node-id tie-break already provides;
    - scoring: wants true magnitudes, which raw distance also provides
      (equidistant =3D> Di =3D 0).

The dedup is only necessary if one matrix has to serve both - and that
coupling is precisely what injects the fake Di. So if you need a node
ordering, I'd use the unaltered distance and break ties by some other
means (node id, or load), and feed the score the raw distance too.=20

Tim

>=20
> Thanks
> Jianyong



