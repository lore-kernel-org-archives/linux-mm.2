Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF8E60A261A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dylggWgL
Received: by kanga.kvack.org (Postfix)
	id 2F0CE6B073E; Wed, 21 Oct 2026 12:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA786B0740; Wed, 21 Oct 2026 12:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E3A6B0741; Wed, 21 Oct 2026 12:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3BB26B073E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:12:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 170FF1205CA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:12:30 +0000 (UTC)
X-FDA: 85347126060.08.8ACB8AB
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7208EC000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:12:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dylggWgL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792599148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GoVehwAITRhrgajbGanUnUkbvqRYmp8dDi3iasZVBaU=;
	b=uFeOe4fSyFKlW0+zZDztEG7WaxOhb+fky1IKOKbVXA+a/kpgz9lwZtVIw56WXso6Ln2YEQ
	Zd8FbdJNlTc4Uwq/HaXJ4+Ow0A+9E7VsYr4Lwh1koGzdvm34JopST9QFwdcNTirdEsJcXu
	Ctot2/l7Zeju5H/j3UUrf24VmvsqzX0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dylggWgL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792599148;
	b=yCTBefFE1qVM0vq2A/NS5erwoC2aSd2POY2mECObBuIlJbPWBB4DvBOFx/bvuXic7zJSjV
	kI42EqNs/1DpKVtWl/he77l3+ZyfX5ogBQ6gKWzhdx9JNTBdVkOOB+WCj7V/GKOAUedtou
	7cdfg+6oPBJnsTAOEaUQcMD9hfnRxwM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QBsYVKIHXnHNdGjvTGIafzE1KeV3pLi8mLpEmKZblfo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792599143; v=1; x=1793203943;
 b=dylggWgL2eO76s8PTrSlgObTWVR3Mn6SSrzgy9qF+ujgeGSRohPFBUXyOJRmpR+T8hRqajPD
 Xz5I8dTXVckEdiZE9/0gvnoKI93OodqdwrAOaCr3vj3qijiQUDaX5wo+CKsawQSEEBNzKyL40UI
 oRVvFMebZlhUlHSzkGL1Pv9M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9724ad12acec2d11;
	Wed, 21 Oct 2026 16:12:23 +0000
X-Mizu-Trace-ID: 9724ad12acec2d11
X-Migadu-Flow: FLOW_OUT
Date: Wed, 21 Oct 2026 09:12:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
Message-ID: <atjhiAxEyoP48e0X@linux.dev>
References: <20261020200730.250189-1-joannelkoong@gmail.com>
 <atfrhsr6bft4t7SI@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atfrhsr6bft4t7SI@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7208EC000E
X-Stat-Signature: air5d7kp3twwgirazemuqy9sx5tefxy3
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792599146-806031
X-HE-Meta: U2FsdGVkX192YFI2AyIBjYP7CwcU2SgF94NB3ocnVM3xLkSh8I+J2/vgieVnJyQuylyNoebfJh779D4nJ1MIqod+BiUeuqAKBfT83sGWSMjovSqC61SjEOGWXPR7gsLhWjsvS40eHJRf8cVHh3GmvRVFOVCZipd1N/nhkzuQwrgYDNmjQYMW05t/EtfncWuY9dIbsHJnm7cGgOq0esazSlJUTyYBP3V8ULuDRpV/aToRbA05FD+ko3FwyaAerch3HOoI46UZQ5fedppx8wDJc//Dqex3f6r+hTw0nmrqNr6phogwRQWyMHWSQ8/ko0uaOs0FnaiQIbBtQzuxTRVO9maegZ3grm35lPHl77xMiNQ8bvw7/eWxpQIkAHhKI4V7Tq+ItJ5o0imYGVcyRlhcUZIHG7Sbvw5isw5VKYnaBGfZ713+/7etpMpx4N+HWIzP5qKHPldkEQQDVDRdrhZTJrY6wa2dxaFeESZRTWDKgGf7GKkiCoc9iwXQ6XeKzY4pJZCJmfCxX1QntXO3BqXYM7ywHgq32xGkJTpc7x/6PW7K01G+49SMGfBx8T7KGroej8f/zzZjZgf05B2GSk5CsikAIyOFJ3optz0mvJOBJ/9ZhT3HHGfoOqQ9+zSWEvvuxXtYafeQ2uzYDy6MkGwWOoklROYjLMm2dNZ1HLf55A2Xot3OGA4CEcCNvHz20/EqVLbUorMDa4CQjzpJu1LdwUex4TrnFtggba0WWgOdecx67qnfimURUpneiSpNQVOObkekWeypK//pmmUw7KFKB+TClOx1Sj/CDNu/f9sASKoGcHvMhXG9rqDXxYQCsJ7gdiVtH8T1keoqPdY8V3V/ZM7/TM7qcBXaaVAnVQn81EE+0VvIthQwNB6rbe7N2GRuugpFNFl3q26U9fN2oTipX5e4YFoCmG0bUAYwJ4lOTVCt89bPwufLOP3Dg7BV/5f93bD73Te/0id2xWlmldh
 5ECLObPB
 1VmnCTAHxPvSauq+i90l485Jb/nrRwfvpj8hTaa7Nut0fZhjS1OIrndQQ5XX9GX1X9RCNLhINITuZufqTH6gR44nHykK2CUxBAVctLzF7e3P8P/8Bc00pLzDYGOPKa2AXjfKBWflB5H4W24bOtxUAMUMLdhIR53z/IGDfWWg5YhE/tjXwCzo5H9o7yCRejgRI/N589XSeIM6Je2ExD3z5jEkB8F4D2G7+K1bhY4KCmm9iQBd5pukdvF+yB5fprbwyVCP3/pQRopyXvSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 03:35:59PM -0700, Shakeel Butt wrote:
> On Tue, Oct 20, 2026 at 01:07:30PM -0700, Joanne Koong wrote:
> > Every memcg lruvec (per-node) stat update reads the memcg and
> > lruvec_stats_percpu pointers in the first 64 bytes of struct
> > mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
> > (such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These updates
> > are extremely frequent (eg these updates happen several times for every
> > page that's faulted in, freed, dirtied, or written back).
> > 
> > The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> > on a different cacheline from the lruvec, but on CPUs that do spatial
> > prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines are
> > fetched in 128-byte aligned pairs. Depending on where struct
> > mem_cgroup_per_node lands in its slab, that cacheline can be paired with
> > the cacheline holding the LRU list heads, and the lruvec->pgdat
> > cacheline with the one holding lru_lock.
> > 
> > When this happens, every stat update also pulls in a copy of the LRU
> > list heads and lru_lock cachelines, which are written to constantly by
> > other CPUs under the lru_lock. The stat update has to fetch them from
> > another CPU, which is unnecessary overhead since the stat update doesn't
> > use the LRU list heads or lru_lock at all. But even worse, the lru_lock
> > holder then has to invalidate those copies and wait for the
> > acknowledgements to come back before it can do its next write, which
> > makes the lru_lock critical section longer for everyone waiting on the
> > lock.
> 
> Can you please reproduce on a non-intel machine?
> 
> Second, can you try the following patch instead of your on the intel
> machine?

I see there is also removal of access of lruvec->pgdat from stats update
function. Let's break up the patch into two. One will remove lruvec->pgdat
access and the other one rearrange the fields in mem_cgroup_per_node (I prefer
rearraging than removing the lruvec stat pointer).


