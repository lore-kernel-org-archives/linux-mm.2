Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B1CCC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 04:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF506B007B; Tue, 21 Jul 2026 00:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F8B6B008A; Tue, 21 Jul 2026 00:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8B66B008C; Tue, 21 Jul 2026 00:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2CF16B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:21:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43E6DA03DA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:21:20 +0000 (UTC)
X-FDA: 85011484320.24.BA958EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9480240005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:21:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iarXXAPp;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=qbYt=FP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=qbYt=FP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784607678;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMHccTkWfwnMZnE8iTx+9aXqPgPG/0UfrAZGeol7M0k=;
	b=2z/4FEMndQANczV7NVYfPmmQdFUQqUJX2iy8PI+5k7MG9U4Kdtd9xYA9R6IHp7ZaRbruNN
	7OQWRCaL3ACmljEhbviPhOCUmuWRknGY5aLrn5XRL4bmYRd7aiFTV/E4NQfUdoTcunwOi9
	N+ztZsxnZxkeZqrupwiSJL5Qhk0hDI8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iarXXAPp;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=qbYt=FP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=qbYt=FP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784607678;
	b=BKw5lGuauk1GIKfLdnJxXzUPjb1UjQVbpV9nSKLEODWQ4wGsexVljeFKno0wf5OSzp58C0
	tYiCV1Jq8FzAbzB7i1VKq400ZpioGZcIRUE5FPJ7pqiicWxFssQAn/XeoDV21l/yzFHX3W
	noy6BnLJfurnoh7NoKqYrNT+1slnRnk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D92C960A61;
	Tue, 21 Jul 2026 04:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A301F000E9;
	Tue, 21 Jul 2026 04:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784607677;
	bh=dMHccTkWfwnMZnE8iTx+9aXqPgPG/0UfrAZGeol7M0k=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=iarXXAPpk5grgNiNHJ9+0ORfs+eqwINWGlhJV23J0hy9Oh6vOPKEQEcGJJEfpsbQJ
	 99slihQd1VusX1ACoiVNMkcamd34VXv4ji1rTbAw0kOFQpagTXV1+T4AiSFycyVNeG
	 fwRr5qcfoUkuYyl+7NvukQqJ0df6dFAYy0ff8+3BFxBLQJzhVMUbIWWrFiF+xtaEXR
	 zoYQ6qidCneViV5uuh/Ikv9xz74AZNUKqCgxSurdDPCCWK+QYfx+Rh1vo7SARh/j4G
	 CwGUo4apsDVdu77gJx8WEYfUJnWJwjWBeWjnFlRsCNFb+z73d0y3a/5SWpWBJQqwVE
	 FaewjKVP9QIIA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 505A6CE0F85; Mon, 20 Jul 2026 21:21:17 -0700 (PDT)
Date: Mon, 20 Jul 2026 21:21:17 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9480240005
X-Stat-Signature: 3xzptinaapmogo1xewid3xz6uht91zxn
X-HE-Tag: 1784607678-382287
X-HE-Meta: U2FsdGVkX1+Gv+6sfAlBZQhFKtiPQ+Ztr4L6KJ+PXReU0b92Bv5xbJ4J0j1q8lfQFVe98nIICP9JdEwOWNiNo82ydzdV/RKO8m43tX+zDXvL0s4vgPH5qftHIRqGAVRVMDexAhup762AoGdEqDeRAoDAPk5Ht+YY3PZy8eBIfZirKuyT/D+9N4jNsWlT61gwiqt2XBkNnsEGwe5aZmgamKBML555N0Cucyis1rm2Kyx9AdNk7rgrWCi5gj1nNekQXeWSp0LeL6iNjXGR35vkm8QzbWRTBhyVCu+qBMjwMhz3TkeIx+QAVEC+KVTDW/xzxRCTfTsDj01H2GGJ1IuhqZVxF+KlFV9GbfCDqGhJl4d+6W5MFdOw7/C7Si9WtFw964W257aVxNZ1wcbbgKN0O7a57tD1T++t9aFrMJ6T3Lcvl1P9KRrSYS5Letu0OmBYONTXdge2n05GxNFmb/D5PY31wY+GC7Rxkl200qMHxMNShfbKghM6MsDrQD9ei51ASkrXWxcn9ziST35aQdElG9UJwKNcvCQ6uBuxkWW2GaZIPoJH7IPB5qErowRtovQ7sTnE0w9B7f+gqHxobmvuXOQ46xDWfY3w7WOcJ9TET46UAyiIIEaX6kEg/98ny38CwEiv9A5OmVEro6KB5VJRXdLkwg7idaqul6I6IQoanYqolC8S8D4Zknb84zJdgL+z+d7YLpoPbUUAOd4GzWhdGI4Y5Ma6xLNOge5a7G9TYOfKwy2kM8/Nx/UgdYdWkKaOX0AASBTlZ5QXri9nL1oz6X2e2UuyxIcGRF0wICMlSH9Z8gk8nPtZXKFxAGF5lzSGGz0Zi8lJHZd4vqZkHuxG+c9IIGGeIdOuqqkiKWyd4X5nTklD38JK/zI3k0ppNxVPysPIylot6Svv0wSTk5yJKe0ndg6wVK4iLYPHmjJVekmsM9L9lOYvqQXvIyPqZCnUr/7vLfFuIoR2AREWPb+
 A+Iic8L7
 NHGewle6weB5mzTflM3TwanY0KcWWDFAAmTLT+8cREPE/CA76IdCnW+2r9h2nC4FgJAs7RdzCP4p1JcBX+hRzsBpwTQ3P+9jWW4KcoLk/CjJ44yWg0yGJJhBNg8ttc+f26Gfc2RUJySFFHG0hO4a3973jokwr+VoCt3B0MDIOlLHyYZ2Mtp1DF+e6MRRm1qfq8nYQG7CwHHNzbzm3CrmrEy/p5ENTWTe6YwO9WoyDj96xjHl/Ksuw9ateIBra7J7hK4+vsXDEDV+OG4o//IXjG0bTQVbAQIa7ELmdEgzLT9ERuqnB1JAlWDwOrb1gDvJTir0JI9EOZVz3pATGcAgKjRjHp9CXgxHhH2vOMe6drnYuqP75Z9pzTf4bPRaCF18id8lhO0gjs62AteuZavAHaUt2Q1d3aB7vKjVYJrXVEUZ0ba8YHZAbDTvtg0MQ3ZPqTKgo61IdrfjyPcoUeS8lvQ6RmsXDS2dSCeMiOgEEefksy7PHDy57pMFRFvoAf+/1TSazpQbK7jyY56af2sCvcVDT9+0y3Y6orwhUE2avefzrq0mYiygV/hY/SjNMsd4T9GZzLjLaXif8af2Kh3G9uuImZtELahlLB8FcWc31bsMBduYTGu4dZzOBmPj+dlVezYUUwZH2MqSbrn7XPIoWU7iQ9PYLp53ZaEnB03biM0gIWEbfeYLtX4nHYJOnewi1t9XcOnA+fLpp2edp50/mptZX9EWh3NQ13+1HnJ++iHv023eSH6v6HlQ90HYAua9EPQ9/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:39:17PM -0700, Andrew Morton wrote:
> On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > kmemleak_scan() can run for ages on large debug kernels. It was
> > causing some soft-lockups which I got fixed with commit
> > 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> > stacks") with our beloved cond_resched().
> > 
> > I've got the fix above deployed in the Meta fleet, and now I am seeing:
> > 
> >   INFO: rcu_tasks detected stalls on tasks:
> >     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
> >      scan_block
> >      scan_gray_list
> >      kmemleak_scan
> > 
> > and, worse, blocks the callers waiting on that grace period. Here a BPF
> > struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> > call_rcu_tasks), is stuck long enough to also trip the hung task check:
> > 
> >   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
> >      __wait_rcu_gp
> >      bpf_struct_ops_map_free
> > 
> > Then I've learned that cond_resched() is not an RCU-tasks quiescent
> > state, so, we need to use stronger primitives.
> > 
> > Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> > reports an RCU-tasks quiescent state as it proceeds.
> > 
> > Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> > quiescent state for task rcu").
> 
> I'll add
> 
> Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
> Cc: <stable@vger.kernel.org>

Thanks to all three of you!

This adds fewer than ten calls to cond_resched_tasks_rcu_qs(), but still
more than doubles the number of such calls outside of the RCU subsystem.

Which is most likely just fine, and in any case absolutely should not
get in the way of Breno's patch, which after all solves a real problem
in the here and now.

Nevertheless, on the off-chance that over the next few months or years
we start playing cond_resched_tasks_rcu_qs() whack-a-mole, I figured it
would be good to get a head start on writing up alternatives.  An initial
draft may be found here:

https://docs.google.com/document/d/1s3fn29SCTYVw9jak4iraNIVQR59Wk5C6_I-_eu-MfQA/edit?usp=sharing

TL;DR:  Should we get into a rousing game of whack-a-mole, alternatives
include continuing as we are, making the existing calls to cond_resched()
in turn call cond_resched_tasks_rcu_qs(), decoupling mutex-induced
hung-task warnings from synchronize_rcu_tasks(), and various
not-so-practical alternatives to RCU Tasks for trampoline synchronization.

Thoughts?  Especially thoughts on other schemes?

							Thanx, Paul

