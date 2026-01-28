Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4FBD35664
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 01:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4296B0005; Tue, 27 Jan 2026 20:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37576B0089; Tue, 27 Jan 2026 20:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A438D6B008A; Tue, 27 Jan 2026 20:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 904B36B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:25:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4C6BC1880
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:25:48 +0000 (UTC)
X-FDA: 84379630776.01.D7B89A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DCA8180006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:25:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3l+vILW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769563547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHRYewl1j9RxJcC+dWP7hOEqWotJLBJJIfWnak02ma8=;
	b=FROxX/AgWbQHcxq+TtI0fUVf67WfdothCpR7DbuLeW0D63j/L6aKNAKMcA40y3S7sc+anH
	H5X0uWT2tapBUkNXhB2mQWoxriNlT8q0CQ1gJgRglsjdCeHiamjOO0yFgkrI7ft32KzE1s
	+k5fkDps+goMGCNv6H4fq1hszYh+ssM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769563547; a=rsa-sha256;
	cv=none;
	b=pfz1yZ5IXQOtD8uGyNM6cgX8h/vdKWpI52LOrJP+QEyDnSu9Bzrd8szSUvksLZScEZVyNA
	XY82cEnf9DVygSdLYXo3a6KZ+Mk70VXyK3iTa0MAcCjlQa5ZAPjUNBWdGOrAJunkQ+K1ar
	UVJek74YJ95OMvz+fnAz04Bc2VzTrI8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X3l+vILW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A03CD60007;
	Wed, 28 Jan 2026 01:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E5DC116C6;
	Wed, 28 Jan 2026 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769563546;
	bh=e0W8b/lJMt8akxgb08koUYI+7WMv1CQDwZ7pqzCYq+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3l+vILWzCwLTGPzcFHOMrhXMzBS2ehHyHZijgbcNTZme/C1fcdnaz3E8yx0haBfY
	 kq8Ii/3BH3ciKInZOK1qs/aZmDONw2WxG3hGuq3v9VExXV2tfGSdI9wQXCaxhSw4x8
	 FzWML7wzZvVOEc2wReYY0AShnmYFTUngIu+0DyeVp6fUEFAHVu4OFZh6PEe6xxqpxZ
	 4wYZ5cc5+IcU5q3xOvQ0MFNlbMcFXi0govjucAWLHDNyBixplRImvn4vGiBCkQUJAJ
	 PAAWc2tAt9dOGPL+1mTR6+S9aJfULMd4IoeKbeukjfvKNC/rmiYqtquMTlIi4oCI2j
	 QK6K+b1OggHsQ==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for PA-based migration control
Date: Tue, 27 Jan 2026 17:25:37 -0800
Message-ID: <20260128012539.72119-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DCA8180006
X-Stat-Signature: jztyucgn86nwzdcm33wnbc4mz3ns6hjx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769563547-407582
X-HE-Meta: U2FsdGVkX1/vT39Sz26IWIaAUb41cEtuxRBjzY4e162D3KD3ky22wNnj9OO2UcRz+vVWjDA/yONRp5eFNauex3Ik0Q+bf4/HcOpvOKN2hJir/dr+W1cmp2gsu31pW4/AHH0Fp78xhk/1l6iNrTVeUFh5T1x6nHG3LBsYvw2vqCkoYcgWoRtVU/q1atyAZ7sswwRW5lsczqtcifhAvSFkXeMYtn9dlwfzeiBEOufocpxcnoENtMUIJcmLrpLBJkVXKvD85/JwWdispwA+VzBz4NaKx5pBbDH4KYBSimoqdJK6VacTY8354fyl6G4InSAe6/TotC8vyAAFum5e7lIZqpHElqyEI4vUu1kw13aRrvNunO9BzWMqSGrhwhM3URIBiNckDxwNtHmsN9PUtmwDA4juzJIYQWjTm7pi6aPrPhxwfK/9ifrXIZa978e/o8ODZvwqrjK3XhDQCyAeqlD5va5spas//neWk2v0vo476hmUv/GpYK5qEgNfBWxMXdbEpgKkJy6g7B3jKehehBjsbOXWe7VEQ5BwXEdtOf2+48MR82bPuf2N2iCYFe8yNe5TTYa/cziNtCV3ZXvphJqNKFmItGwYkNwNA0wgtxFPXT+LG5T1g3eiqY9qwVFEex08ieQKQK1hGcz9v+9IWpBbBYkjNtFQA5KXKbbtVzIYGxtx1V4x9pSEYHXoI2TD7yaq3aBq+6xoyVZ5N+rQmUOAvwX3WE24IrH0NBu5ylP0ydIjjxodPMZDZTjcbup9RjWhMR6MmDGXJy26GLQIgh+7fD29BrzuoSMLYNd9odPLnzvxWGDeLZUgj5P9i5dMAXNU0BorY79qyGXqvdJyvrPhhcB47XRrhPuMRCQGPp+zhj984zb2+OkkMjU6+SKI6IqHOC503g97N7/qA8yACHNcQvvS4wXMKpyFieC3EealEh3EcTDSIkUjDX6Y4bdfhB2rHHyLcmR72XrxzkDS5tD
 Zv1va5fK
 IiPb8gX7VCO/CM+6wM0pm/AtZXor4bmUSUsBoy06106Lb82Ignj/bl5d9CY0zWOk/zK5y8eC92aSAWl/Q0VWM9fRvgpDc3p/k7VSUrH8uw4hviFmCu5ccjnJrdv3DQX3WC8t1olIaBjL7q1QR4ix+OkOiWPDc6ePqrFBY13e90P/wv7b+wA3I/z+Y3I1W3dMrVP4rT3yM6yffbfTHEZfXCB2kHLmFV2jD79qGc6pp6U2Ni28KKn+ZWiyqDHFSei7P7iFG86l5JJwrstnMP6pPnfkpQMaSUKrq1KVzp1YbiHF7Dg9CE/MZMKWHbD+6an4Y659zmQ/lGS3UcQejmT9//5ot68PpvDESrBw7mhehNnyPVGW11lQr+AuHGu+1amChF5w5Tnast8awSlAhEQ7/glysmRA6xyuC62WO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 10:52:53 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Fri, Jan 23, 2026 at 5:50 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Cc-ing SK hynix folks (Honggyu and Yunjeong) for quota auto-tuning behavior
> > confusion (not stop immediately after satisfying the goal) I discuss below.
> >
> > Hello Ravi,
> >
> 
>  Hi SJ,
> 
>   Thank you for the detailed review and for Cc'ing SK hynix folks.
> 
> >
> > Thank you for sharing this great RFC!
> >
> > I had a chance to be involved in a high level design of this series, off the
> > mailing list.  I'm disclosing the fact for others' context, since a few of my
> > comments below are based on the previous off-list discussion.
> >
> > On Thu, 22 Jan 2026 20:57:23 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > This series introduces a new DAMON quota goal metric,
> >
> > As I discussed off the list, I believe the new goal can be useful.  Thank you
> > again for making this!
> >
> > > `node_sys_bp`, designed
> > > for controlling memory migration in heterogeneous memory systems (e.g.,
> > > DRAM↔CXL tiering). These patches are provided as an initial RFC and have
> > > not been tested on actual hardware.
> >
> > I feel like the name is not very self explaining what it is, though.  I'm also
> > bit confused about what it does is what we discussed off list.  I'll add more
> > details below, on more detailed explanation about the new goal.
> >
> 
> Will change the name to damos_target_mem_node_sys_bp in v2.

Sounds good name.  But, could it be more consistent with existing node-related
quota goal metrics such as 'node_mem_used_bp' and 'node_mem_free_bp'?  What
about... say... 'node_target_mem_bp'?  Please feel free to suggest a better
one.

[...]
> > > Solution: bp-Based Target State Goals
> > > =====================================
> > >
> > > Instead of specifying action rates, `node_sys_bp` specifies a TARGET STATE:
> > >
> > >     "Node N should contain X basis points (X/10000) of system memory"
> >
> > I'm not sure if this is exactly what we discussed off list.  What I expected
> > the goal would be based on our discussion is, what the first patch is saying.
> > To quote the part,
> >
> >     @@ -155,6 +155,7 @@ enum damos_action {
> >       * @DAMOS_QUOTA_NODE_MEM_FREE_BP:      MemFree ratio of a node.
> >       * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:    MemUsed ratio of a node for a cgroup.
> >       * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:    MemFree ratio of a node for a cgroup.
> >     + * @DAMOS_QUOTA_NODE_SYS_BP:           Scheme-eligible bytes ratio of a node.
> >       * @NR_DAMOS_QUOTA_GOAL_METRICS:       Number of DAMOS quota goal metrics.
> >
> > That is, my understanding of what we want to achive with the new goal is,
> > letting users to ask DAMON "migrate hot pages of node A to node B, aiming
> > X % of node B becomes hot, as a result of the migrations".
> >
> 
> Yes, this is the intent. Looking back at my implementation, I see the
> mismatch:
> 
> 1. **Numerator**: Should count only scheme-eligible bytes.
> 
> 2. **Denominator**: Should use node capacity, but I used total system
>    memory.
> 
> > But your above description is not saying about the "scheme-eligibility".  Also,
> > the goal metric is the ratio of the memory to the entire system memory, not
> > just a given node.  My quick read of damon_pa_get_node_sys_bp() on the second
> > patch of this series confirms the implementation is following your description,
> > not what I imagined.
> >
> 
> You're right. The implementation diverged from what we discussed. I'll
> fix both the numerator and denominator in v2.

Thank you for clarifying it and sharing the next plan, all sounds good!

[...]
> > Please note that the goal-based quota auto-tuning works in proportional way,
> > preferring small steps and "eventual" goal convergence.  As a result, migration
> > will occur a few more times until it is completely stopped after the goal is
> > satisfied.  Unless there is another scheme that migrates pages into node 0, you
> > may end up having node 0 having a bit less than the 40% memory.
> >
> > >
> > >     No oscillation - migration stops when target state is reached.
> >
> > So, little bit of oscillation could still happen.  Hopefully that shouldn't be
> > significant, though.
> >
> 
> Yes, As we discussed offline, for a two-context approach:
> 
>       Context 0: monitors node 0, migrate_hot → node 1
>         goal: damos_target_mem_node_sys_bp, nid=1, target=4000
>         "Stop when node 1 is 40% hot"
> 
>       Context 1: monitors node 1, migrate_hot → node 0
>         goal: damos_target_mem_node_sys_bp, nid=0, target=6000
>         "Stop when node 0 is 60% hot"
> 
> Each context eventually stops when its target node reaches the desired
> threshold,
> and the reverse direction is handled by the other context. For my use
> case, eventual convergence with this setup could be acceptable.

Thank you for clarifying this!  I'm relieved we don't have a concern here.

> An immediate-stop feature could still be useful for the broader community.

Thank you for the feedback.  I will take more time on thinking about how to
implement this.

> Will test and post results after the next iteration.
> 
> > IIRC, SK hynix people also confused with the behavior when they experimented
> > migrate_{hot,cold} action with NODE_MEM_USED_BP goal based quota auto-tuning,
> > but using only a single scheme that does migration in a single direction.
> > Because this is at least second time it made confusion, if you need, maybe I
> > can try to add a feature for making DAMOS immediately stops after the goal is
> > satisfied.  Let me know if such new feature can be useful for you.  Cc-ing SK
> > hynix people (Honggyu and Yunjeong) so that they can correct me if my memory is
> > broken, or answer if the new feature I described here can be useful for them.
[...]
> > > Why get_goal_metric() Ops Callback
> > > ==================================
> > >
> > > The bp calculation requires iterating over monitored PA regions:
> > >
> > >     for (pfn = start_pfn; pfn < end_pfn; pfn++) {
> > >         if (page_to_nid(pfn_to_page(pfn)) == nid)
> > >             node_bytes += PAGE_SIZE;
> > >     }
> > >     bp = node_bytes * 10000 / system_total;
> > >
> > > This requires address-space knowledge that only the ops provider has.
> > > Existing goal metrics (PSI, node_mem_*, node_memcg_*) are computed in
> > > core using system-wide data that doesn't require iterating monitored
> > > regions.
> > >
> > > The new `get_goal_metric()` callback in `damon_operations` allows:
> > >
> > >   1. Core to remain generic - handles all common metrics
> >
> > I agree this is indeed making the design clean.  But, we already having such
> > exception, like core.c code using 'damon_target_has_pid().  Having just one
> > more exception seems ok to me, unless it makes code too ugly.
> >
> > >   2. Ops providers to implement metrics requiring region iteration
> > >   3. Clean separation - PA implements node_sys_bp, VA could add
> > >      different metrics in future
> >
> > I agree it could be useful for clean support of virtual address mode in future.
> > But, I'd prefer making this as simple and small as possible for the support we
> > will use at the moment.
> >
> > >   4. Optional implementation - ops return 0 if metric unsupported
> >
> > Again, letting core logic having a bit of ops layer information is not a big
> > problem to my humble perspective.
> >
> > So, I'd more prefer not adding the Ops callback, unless you have some other
> > concerns.
> >
> 
> Agreed. I'll remove the get_goal_metric() ops callback in v2

Thank you for flexibly accepting my suggestion.

[...]
> > > Advantages of PA-Based Migration
> > > ================================
> > >
> > > PA-based migration with DAMON enables integration of multiple hotness
> > > sources for migration decisions:
> > >
> > >   1. DAMON's native access pattern monitoring
> > >   2. Fault-based information (similar to NUMA Balancing)
> > >   3. Future: Hardware monitoring units (e.g., CXL CHMU)
> > >   4. Future: Instruction-Based Sampling (AMD IBS, Intel PEBS)
> > >
> > > Unlike VA-based approaches tied to individual process address spaces, PA
> > > monitoring can aggregate hotness information from multiple sources to make
> > > system-wide migration decisions across the entire physical memory space.
> >
> > Maybe you are saying about the damon_report_access() based DAMON extension
> > project [1]?  Since it is not yet upstreamed, and the long term plan is to
> > support not only physical address but also virtual address space, I think this
> > section is better to be removed, unless the DAMON extension project is merged
> > before this patch series.  I expect this patch series will be merged much
> > earlier than the extension project.
> >
> 
> Agreed. I'll remove the references to future hotness sources.

Thank you!

[...]
> > > Feedback on the overall approach and design is appreciated.
> >
> > I hope my above comments helps the forward progress of this nice series.
> >
> 
> They are very helpful. Thanks a lot.

The pleasure is mine, looking forward to the next version of this patch series
:)


Thanks,
SJ

[...]

