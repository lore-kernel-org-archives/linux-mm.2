Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD27C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C834E6B00AC; Tue, 22 Sep 2026 14:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33D86B00AD; Tue, 22 Sep 2026 14:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A536B00AE; Tue, 22 Sep 2026 14:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF376B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:39:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 165928058A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:39:09 +0000 (UTC)
X-FDA: 85242260418.28.595614C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3307A000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:39:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KHd+mcY/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790102345;
	b=wi9sDRktY3NjO+rfpD4Lp0CfYQpEPVgrxIRRhrR/D7zkJwXX13O+/LW/yFJrYAJRt+hY9G
	Hy945PggiBBbG17t8mrjbYbmbBxbZ6s+Kc376PKMtjbOqQUha3TZIuRAwSXf25aBOJFnfw
	dEN11BTFmGeJa5MbIooM0rUE1eopvlQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="KHd+mcY/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790102345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5z5XdObk2cDEQEZY6QuG6DL6NpztjYLY4pKwFE9SDA=;
	b=AwLeG487fiaDsnjdl1P6gmWZ8g2GJPXOjisziYNHlRIHKuJ48rLQ8AOf2m+558thC2J8N4
	f9TBAHp9DmVUicnxOZWOfkqLXDXrA3Vsgcgna2geby4Mnm+L9wavy1OU2eTScEfTGsSzS4
	XDzSAsEZskMvsqVxASXXoQ1L4BGglI4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790102345; x=1821638345;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HuG3XnawN8dKLAFss/ijwZ7TG4b3UZXI4qbSUN+0OPA=;
  b=KHd+mcY/o+4EkP1Zk3ByRGN3LFt8GjLkFCp7OksfPymbbMe+9NjA+Pi5
   NsGv9E8KiqR4NMGcwZD7mSTpxtvrNV0PvzXNOHmCxePtoyyGC68rNqyTc
   VePnbabxwQZWk6IJmuNKonV3vsekBn8f72Fu6coPxq7v744bnX531SUJw
   0r/1AaXFAoeCCwoOQzElkSKaWE8akGNoh3t68kUkgdVyYTm+K5S8dzH+b
   LDTF7v0w6Un/ZeyDYxPg4nrcd0lH3pNR7Zyz68hCn6tHJu8hTWzgvuRT2
   pGYC/0BY0AjZx+hdQPtYjf9ub64Hv5aZKL/TE+8yaGrvw6F11Ga+iZBsv
   A==;
X-CSE-ConnectionGUID: 2iY7yMSNTD6rMUsLIzHgLw==
X-CSE-MsgGUID: duQf/X6cRaeME6ZJDouyQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="78288193"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="78288193"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 11:39:03 -0700
X-CSE-ConnectionGUID: Tel5TxJaQgeAHuE7Mt7fLA==
X-CSE-MsgGUID: 7neKGePaRW6cJa6EPTvv8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="278015642"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.110.39]) ([10.125.110.39])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 11:39:01 -0700
Message-ID: <da32ba66d95fd88869ba052f97698b9a4d6c3dc6.camel@linux.intel.com>
Subject: Re: [RFC PATCH v2 02/23] sched/topology: Introduce a NUMA distance
 matrix with unique distance values
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu
 <yu.c.chen@intel.com>, Dietmar Eggemann	 <dietmar.eggemann@arm.com>, Steven
 Rostedt <rostedt@goodmis.org>, Ben Segall	 <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider	 <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Phil Auld <pauld@redhat.com>, Andrew Morton	 <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, 	linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, jianyong.wu@outlook.com, 	zhongyuan@hygon.cn,
 huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn, 
	justin.he@arm.com
Date: Tue, 22 Sep 2026 11:38:59 -0700
In-Reply-To: <20260831115004.GF776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
	 <20260827122816.756234-3-wujianyong@hygon.cn>
	 <20260831115004.GF776954@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: zug4uofskogy6tfzzak58rqf7o76tsog
X-Rspam-User: 
X-Rspamd-Queue-Id: F3307A000B
X-HE-Tag: 1790102344-858099
X-HE-Meta: U2FsdGVkX1+zb38MeA9AmWa2QCNXIWPxjiL5jSzBsJFEh3A+gOFTSr0IY48BRTQKGMOPYk0uANcW3MZmVIF96Et9jPLm4/8qQOL+XzaFL1EOKXYPOfDxJoig4HRfHQHeeIlTdmur6VMYvt7cDcuwZucrA05HhSOvnfRUqHKOu3ok/qulrrPIcyyqmkTrJaVsqZykFkdOqqKHbd6k7sTByuZe1wxycGOg531iMxlOiPh2DKhnae5MebBBViZ3JrHDHnCh9x/R3/gTwFB2wJj76uPxp1pOOiGAQjKP0pv6iwRv/wnR5LnwboBamK/Sprmstu3TGqn4yT/U1huFN8NSSLrb2im9/b7r0R57RizVJba+uZrMUP+ZYKXJVONW2v/cHiWVOmd92bvuKY3dDV88Jh1Io0RqcNWsAU+dw0PvWVoJrBZ58of09gfmuXenkKdiztlvMtUJGVGLx0MP8VXbCxJm3DzUpRNmQ+MtL4bqI20Cwfa1mFTyiawJ89t+xdIwA18upYCUpyPfUM6WhXYzhlbeO7DndLtTmdV0YZoyhyVEiszrI9Wsu2/Yipu3PGo1Q/AS2WPrQis2/R2sSGqB15bqRkXKPKuBCFaLmVj2oWU0jF7uzLAbDqdU8mGyESZIAmeTytQ8mPBPapbKv9A4XwJPACu/Fj5k+rFhAjacnBalchkdC3l3lp5mM2ezRJMFi6WlEPb39TiSceB1ZNosGGFWBkE0EpRFEepk1qPuZk0kzNaO2SVLLV4O4eF0ICql+JdaGmk5r9PybbJHqvKt94Obezq6lBmWMXduiqjM/cg+Bv2Dir0xrsT8tYos7Ip1blt5WpvEOx8Q1KbmAO/sUjpil099gM+Qb65uRRzrhrSz0VPWVuA1uTU+OSK0Tuw2yuTXcyWkaDo+RVIArUC95TLIZwjlO3AxGE18S8u0HvUdaFE3NUgzvIBtRbE3g3qce0BlLEzTO3QXqc1e2/m
 auys5niU
 Kt0wNuDcY/LYnzY7YHcmC9go78cDJD/TWjEtW4IyeoZ5z2m7tGCqqy3VuS3rdsUqTGG3pxSHaF/SKLMDCHzyTI9HykZ+txBfunyAQCaExI67CrRaRCOfM19OrGWkLGkiZR3hPPFbRL8AGPrkmNM2w7qXxIWHE0RSdVftfC7YMQjKxE8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-08-31 at 13:50 +0200, Peter Zijlstra wrote:
> On Thu, Aug 27, 2026 at 08:27:55PM +0800, Jianyong Wu wrote:
> > Builds a refined node distance matrix based on the raw NUMA distance ma=
trix
> > provided by BIOS. The refined matrix preserves the relative ordering of
> > NUMA distances, while assigning distinct distance values to node pairs =
that
> > originally shared identical distances within each matrix row. This matr=
ix
> > is exclusively used for cache-aware scheduling and has no impact on exi=
sting
> > NUMA topology logic such as sched domain construction.
> >=20
> > For example, consider a system with 4 NUMA nodes. The raw BIOS-provided
> > distance matrix may look like this:
> >=20
> >         NODE0  NODE1  NODE2  NODE3
> > NODE0   10     20     20     30
> > NODE1   20     10     20     25
> > NODE2   20     20     10     20
> > NODE3   30     25     20     10
> >=20
> > Multiple duplicate distance values exist within each row. After the
> > deduplication step, the refined distance matrix becomes:
> >=20
> >         NODE0  NODE1  NODE2  NODE3
> > NODE0   10     15     20     30
> > NODE1   15     10     12     25
> > NODE2   20     12     10     15
> > NODE3   30     25     15     10
> >=20
> > All entries in each row are now unique, while adhering to two core prin=
ciples:
> > 1. The relative distance ordering from the original matrix is preserved=
.
> >    For instance, original distance(NODE0, NODE1) < distance(NODE0, NODE=
3),
> >    and this relative relationship is retained in the refined matrix as =
well.
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

I think what we really want is an ordering of caches within
the same NUMA node.  So when one cache is full, we can
pick the next one down the list.  That is essentially the
net effect of the distance de-duplication.

So how about introduce a llc_next array.  We will initialize
the array such that it will return the next LLC in
the NUMA node.  So for the example that Peter has above,
assuming C0 maps to LLC id 0, C1 maps to 1, etc.
then llc_next is

	    c0 c1 c2 c3 c4 c5 c6 c7
llc_next =3D [1  0  3  2  5  4  7  6]

When we come back to the orginal LLC we start off with,
we know that it is time to move on to a LLC in next closest
NUMA node.

This will be storage efficient and more straight forward
to use than maintaining an artificial cache distance matrix.

I dislike the artificial distance matrix also for the
reason that there is no guarantee that there are enough
available distance slots between two nodes.  Say if I
start with=20

        NODE0  NODE1  NODE2  NODE3
NODE0   10     20     20     30
NODE1   20     10     20     25
NODE2   20     20     10     20
NODE3   30     25     20     10

and there are 16 LLCs in NODE 1, I will run
out of slots when I try to deduplicate as
only 10 slots are available to fit 16 LLCs.

Tim

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
> > Each row of this refined NUMA distance matrix is sorted in ascending or=
der to
> > generate a unique per-node affinity sequence. This sequence will guide
> > thread migration logic introduced in subsequent patches.
>=20
> IIRC greedy has significant worse bounds than many other schemes. This
> would result in more unique distances than strictly needed here, right?
>=20
> Since this is all on slow paths anyway, does it make sense to pick a
> slightly better algorithm in order to reduce this bound and get better
> results?
>=20
> Anyway, let me continue trying to dig through all this.

