Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2861CC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9B26B008A; Wed,  9 Sep 2026 15:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AF16B008C; Wed,  9 Sep 2026 15:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A916B0092; Wed,  9 Sep 2026 15:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5A4B6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:03:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C47311402FE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:03:23 +0000 (UTC)
X-FDA: 85195147086.28.D487D47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08977120013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:03:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aADKDxRu;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788980602;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AErWR7vucLM7Tga+zO6Gil5K2nYfIKbJaptyhsoLRXE=;
	b=F6mEWlkAFSxRyu4+wZtxgpahOTDPxl1WVev3YrAksxU10AmacQlQUYajRZRUTwAhuguZzE
	DR7L7HiE4mgFm36Yk4VnU/rP0qznZdj1/meAOJ9D4QOrfS9TQYCYsJpErYaTcKNDj4NdUd
	wc0CFMuK4GvBQVvmfyTAk0MIZbzxGV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788980602;
	b=v7Ku3QowaS+AXMCeFN7SReS/W962WA1H/BUhnRauJws9H7U3tM0HPMQ0uaTOf3QJAZ70vF
	kufNid4MF032jn+Zek8z4oW0exBuCziejq35Tk0iUXzeeeI3pVzaDazsjMkSZCuG9AbyXb
	mznTlL6WoEC+jvPtmV37Rw+2hpXsTa0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aADKDxRu;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=B23o=HB=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 478E7601EF;
	Wed,  9 Sep 2026 19:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8991F000FF;
	Wed,  9 Sep 2026 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788980601;
	bh=AErWR7vucLM7Tga+zO6Gil5K2nYfIKbJaptyhsoLRXE=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=aADKDxRumdTzR//o4YXfDT7LkMdzRDMU+xa47yvoTtTp8OE7XZcs/dZzoDOkO7+dJ
	 ah/VujNCccgP86+HXxrpKnnYRUHTg9zGWFlYyLcFWi3DR3E6YmZkaReH4EqthbJnFz
	 bFaC+N/N1Ijd8IaOtm8HWkg6FatUTvWKrl6jTw82yecUA3rSXWmPRRlFUfcJNJ0NBW
	 wI9AgYc8nQ5bN9CfGus6Uv2ZVxYVru+jWGmBPC2fZTsJSc8xc6LD/ez7/sRJzuVBGm
	 qjp0EzaVMCJ8dAm1OSUDBf5e+uw7bL26+EdUpJFXWO1oidxIMm2PTssGx2OqPxOSlX
	 OJnROI/qfpyWg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id B05C7CE086B; Wed,  9 Sep 2026 12:03:20 -0700 (PDT)
Date: Wed, 9 Sep 2026 12:03:20 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <16d13239-8911-4597-bfd6-18aa02135137@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
 <aqGilhgcEd0qaHjI@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqGilhgcEd0qaHjI@slm.duckdns.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cxr61yb4efrcj48d4a5yn114cf19yrn4
X-Rspamd-Queue-Id: 08977120013
X-HE-Tag: 1788980601-51114
X-HE-Meta: U2FsdGVkX1+ZI9zWnzINGGY47DbEXVHfWIuC9+J4AtybbPTBaH/nyYBZNNWmYbfKI15dfazxxEcFdNB4NQysehL4NdFLsDKngOk4YnZ+CqTQtN11b0dQVz5MEuzENPnP4tUi/TjoEAymqwZLCiFHhnlv3iAHBBn4RbrEJ2KrlTw20+czOeWPjgOr4RZDXz9QvXImsrjJRKrI/xq6rYMAWXs4IjDjJTdMWjRwLcDK315aPuUPV2W9R4Uct9DGAxRCxOb/c+S0NMGFsalTJvenLeZLOQcbaJ32WqG0/GpS0MgBP7SUhTkK2yBv3JR51LUY33sbDyR60jpqgT/+2zqIb4nOni9YiaDvBsmmngoCFkB/jTaK8OPQxBuEl9jCkypmPq9doXSdZWsf6yMV1aw6XVrPIuX4nvbQp9YSm2bv5kKuBVOk4w9d1p9L2lgu7VZ18lFdJNo3iQhaM+jn767AO1dJjVklkueol7vz9v9pRYhK3PskE189yeAKCV/mDMs26rTX8jODYrDfiJuT5bLqgYE2rGjl4W4reTZ2kogVpJyLMc+lBjhC+ubXfWnRJoTZisxUd2mj1zOULb8gGS+i2vn+kf04f5fmtEUjE7N6Aa/O7xSQ7g0N54J30tYnGMgWU/PnUsQ/J38xpDRAaFcrqpWnHjhz123eM6e5te9XNtcXhBYAM9e5Om2J1HNfkJtpu3XhSoGQdVj8T/gFg/wxn34U5PKoC8tWR5YLb9zigyaBpnGHSlGXC+3XRec/9Ypq0ybwER0O8WnwAIHu1skNbGktjQ0ZJS5iJD0gBJakhVj6Xl8cIKXMSihWzbcpW3BYyQD9S7mEiMX0KpC5PkHrS07DCwbetBEe6y0CIWwesdSMUq41DnHosCJP6ZqHt1PCWZZ8N6p3VegIAjHuYmJG55EaoUKjxD/zZcgFBHarask7yscE5oaWQAUjv+1GTZ5q8j94PXKHMgrXe4ywbr2
 cBgQSq98
 tgZ5oV6AWXGcb6GJp166jebwUEucywk5VagkFpXil6+25XgE7reube2lrNIO/OkwvAhRPXTFSedNtPrx5iFh7hEcYvbFIUt1JHpDASmcEIctgbW0Y+PM2yOyXCgFtNhxODv4hgpwxLNEU+vqfF8lDrt2VUhK+MXgXzNvPNe5//j7J4agQ/WEvomCBSGrajV7IU7yHI4ejhRuXcIbTsuRrBijOclN9WErBn7vmPQCUza79sGkVURmdBL93drSAP+dPBTR8WtzdI/DRYpxQGaiuNGy5c+itg1zPpi0QnpLrZB/CtnJFEu6nXYyam4qXhgXULDgG90d0yrc1mFcty3aCwJeSfrGuLk3XNxMYud65adK9hMBz8ht5WClVEJcBnigsqlisTjgFyvRqR/chO50V5KU5BWvG/tzgEqTDaK+FVjAH1me0ZuzlY52pEGBEFgs22A7hYjFfH0HkF3BfAh7UFbhsvIVjveLlPGCDwhjA1awO1yDotp6EvVS5QYNJHBlon1mS5fcZpWXvb5s07KRwo+hSwxpczskNzKxkCg1ZZ8ONtK8Ofg+eRSdYDqgppC7c/TGuafxJBJ2yp2+cRPsj8KPechR9heS2HWTmL5iz+5wHpdu4SxVNtDRHXWNF+v5kdOZ3BoT6uIq8lm24dKsCHEMhMIgf5DG4mMgT9aV89+pD1Hx83iD0Pkx4Y6k+h6tSXNFgIBED3amprOMH+kMqKr7IMmgVrNPKprL5NWNNDpXTQcynGBC1urhBI/6oW2HsjFqhka32VE3ln2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 08:16:54AM -1000, Tejun Heo wrote:
> (cc'ing Paul)
> 
> On Wed, Sep 09, 2026 at 06:01:07PM +0000, Josef Bacik wrote:
> > cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
> > cleanup_offline_cgwb() until it returns false, with a cond_resched()
> > between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
> > nothing: _cond_resched() is a plain "return 0", and under
> > PREEMPT_DYNAMIC the full and lazy modes disable it.  Since commit
> > 7dadeaa6e851 ("sched: Further restrict the preemption modes") those are
> > the only two models on the architectures with PREEMPT_LAZY support,
> > arm64 and x86 among them, so the drain loop never reports a Tasks-RCU
> > quiescent state.
> > 
> > A worker draining a cgwb with millions of attached inodes runs for
> > minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
> > dying cgroup's writeback domain for over 11 minutes.  A BPF program
> > unlink (bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
> > unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
> > waited on that grace period while holding the trampoline mutex, 42
> > tasks queued behind it in D state, and the hung task detector fired at
> > 614 s and panicked the host.  Any BPF or ftrace detach during a long
> > drain inherits the drain's length.
> > 
> > Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
> > anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
> > loop because if we have many small cgroups cleanup_offline_cgwb() will
> > return false and we will never call cond_resched_tasks_rcu_qs(), creating
> > the same problem.
> > 
> > Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
> > Assisted-by: LLM
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> > ---
> >  mm/backing-dev.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index cecbcf9060a6..18e999053bae 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
> >  			continue;
> >  
> >  		spin_unlock_irq(&cgwb_lock);
> > -		while (cleanup_offline_cgwb(wb))
> > -			cond_resched();
> > +		do {
> > +			cond_resched_tasks_rcu_qs();
> > +		} while (cleanup_offline_cgwb(wb));
> 
> The patch looks fine but this overall seems fragile. cond_resched() was
> already marking "stuff that can take too long" but we need to use
> cond_resched_tasks_rcu_qs() if it can take *really* long. There gotta be a
> way to make this more maintainable. If always doing tasks_rcu_qs from
> cond_resched() is too expensive, can it be be gated behind something cheaper
> e.g. some tick based test?

This is the business end of cond_resched_tasks_rcu_qs() in preemptible
kernels (in which cond_resched() is nothingness):

# define rcu_tasks_classic_qs(t, preempt)				\
	do {								\
		if (!(preempt) && READ_ONCE((t)->rcu_tasks_holdout))	\
			WRITE_ONCE((t)->rcu_tasks_holdout, false);	\
	} while (0)

This is pretty lightweight.  Adding a jiffies check would likely make
it more expensive.

Or am I missing your point?

							Thanx, Paul

