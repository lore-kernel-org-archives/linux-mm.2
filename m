Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C353CC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CCA86B009E; Tue, 11 Aug 2026 14:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4116B009F; Tue, 11 Aug 2026 14:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1276B00A1; Tue, 11 Aug 2026 14:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4A16B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:39:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C887E401D6
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:39:03 +0000 (UTC)
X-FDA: 85089850566.25.BEEC53D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 168D340005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:39:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bsq30oIX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of "SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786473542;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=do2XKhDCxgRyux4sbGO+SL+POHJmP39DxWYxzqtT9Lw=;
	b=Ig/lRYQmSynKUZkwbFs5w9BPKc5bSwZCVSpu2+BbjFrdzZoMQR3DWxfuOxgwFgH10YAi3U
	L79LETw/p9zRc1WJdAzrHZ6Yj7lti/D+fxKCXeP9FiP4dVnA49e6rbntYK5501JJFchS44
	9M3UUR5kMqAMHuB4dnEpbSaCmSWWGSE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bsq30oIX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of "SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786473542;
	b=8QpQxmNXSc4XYh+DU4X813Y56v4/UFTFntOcZUISXRJo9EQiR4EgcEcmP51A+uxZCXDw2J
	k/3PcOyh26gnTJEOHvPVB25pSUr/KTfQ+mW/nfcxJ2y+HE2HcMKzE1hUPGjGBEmZ6ZCg+F
	gpCzcuZ+mEd46HySoqRGXgEdE06H9Dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F0CA407F8;
	Tue, 11 Aug 2026 18:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287E01F00A3A;
	Tue, 11 Aug 2026 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786473541;
	bh=do2XKhDCxgRyux4sbGO+SL+POHJmP39DxWYxzqtT9Lw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=Bsq30oIXhtCGipX2jCZP84ZNtzuM8tFQ3L5GV2brb1g9D4/D81M+YkOXerdUs0ZDm
	 03iIxqptAvt9OJMyT8dZrRnesKqppvP1bCc3klOPzFXQdw3Tj+8Cex21Y9F41fiQP6
	 fkax0rNyxxHPz3frRXLXT/7pY2ode3Afw4Ju+GaNbkiERm9XFiEN6kUkxRjLeY/rTm
	 I3oa0HAkc8mNvuu6emrgVl6qZdVYQY9ILjQheCjVUhdgnzsTX0E59Oxe4DfWBNBoj9
	 qp91mZuE0H1hsstPext0uX1OffjetvnRJxGjzkKY4h9BeE9V2+2SgtGsbDRz/HUkkQ
	 vQn3lekeyLeZw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id EC26CCE17BC; Tue, 11 Aug 2026 11:39:00 -0700 (PDT)
Date: Tue, 11 Aug 2026 11:39:00 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
Message-ID: <2a402225-57e2-4d5c-ab2d-7d8724b86246@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
 <anqnkZceNHyvbR5S@linux.dev>
 <e019296d-43f5-47bd-ab49-6dfd1d8da0cb@paulmck-laptop>
 <anthYiiYPuUYbj1Q@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anthYiiYPuUYbj1Q@linux.dev>
X-Stat-Signature: fwg7q7zjfhp646ek6ekq6zh8iexjomkb
X-Rspamd-Queue-Id: 168D340005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786473541-455965
X-HE-Meta: U2FsdGVkX189Cnu7qbKPCu3bYvUlzGS3cEoMGTbfsYjkRZ9pgV7DfhurpbZAxgr4TjI5uVulpl9q/NlOZbAQmroIgIaQH2s3bhx/hBT1stfM4ZyAs3LNgv32oNEfWfxSx5XkbmRveKqcDM+NKAp7/8g+59O/J7HWbhdSgR87vd3Bk47cJ99d8jpa0WcsBz05X2+d1HKcqT+gFmQvVJ3SyG2/tpVPjz9AilACToYC84pi/dY0hPWCKJIHcadmJGj7uxyPlT0/WiHd4pJfBFrS3J96fd4Fr0hK7BSVxxMXkW64wt9uVvpCitrhfze5B5OUqSROvetaxD0dXCIClkU903qg6r2/01vV7RkL9DIfb9t+w3bFFKEYadlRNVdh3iun3amS7JQgzuL1I+EOwGcBUrI4ifsjU/ycNbLQLq3v65Zy38gOMgX2S7LndoiQvhajYOpJ5hbzzgBYggHG4OFEDlbAKhYp9syj9G+LCGPZHHYqV0G4C3ZIwRJ6+GVrG5fueW0mSavV4XJsW/BdfN77CX5lX0RL+0WWpEDLUadTUKrp+jLQ0LzzvfawtYb6jyDDJTHkDC0ezDlWGKzxXG/1PTIZQIKagc1SByZoijPKo42nlyaeK7mm7RvfzH+DAIhYbvLQRdGwil+WuFACIRmVlsfQV7DfneM1ogejhT5BavLMF0asqVp0z16XBzteXrEwJS6QmwQf99+jaysa4lt+SeUkjlqZ4P2qfNarRzlcyudoinw4CshSehw7UvBFOM7/IXnCW4t7Ri8oO/pSXZ/GuL+Z7r9yNdiHOC3rQ5701mBc6OeWwpZ2x5vEGSiP1ye3PllnQLatYEpNv1r1uFbjUW3/YYlQRpHFhjDvHaSGlarGSlUNX754gm7iCuhw7GTuZ1mCrgcJ7yXrYndabKvLYiU+PtGshruGXYFFLQm4sF5JR8mVNEp5xz/BUsWKEJQkh27Vhnc0Hdf35zaXEH3
 NJCg/T7L
 SSIFgvCTILrqtl51FZe+z0YKqlxntHuqCbtgy0lAsGMOfykmE+zMHS3WmcHVYXikWa39F7grcpiSC2uTIwkJ3HAxTKmqAsv6oPcLjRwEa/k6X9mZCUXCW/tXqWJNnpTHWmLOsoBa3gKPnL2Aj4X0zcBD3TjF/n4Dh9WJ7YSPO4/PqHG6EziuLG4R5dqrdVKJkiS9D/MJ20eQZArUykO/MDtYU2TB9NOeIcu6KVKVb8D7vxjH+Lk3x0sfvt79J0cjv1NF3lWj3UhlUDor9ntKKiqAbQ2HuRyAd6VjW9ye8BrCCOMHfhKxD+4dEtGdKne6f3GujFcW6NpNmxUwWg443f5nhxNvCn1MlccgkemNV4wZz5XaurvOs6qmSwAoRcwzNFvlS1BWrtA11CP8eAIJjnuOUgK6QP+KQp5/DVUFQJDPG1olGHud1HCt9lylOl5sjH1XNKjoN0gNM3CJkNR8xZ0PxB6sEYUp3gCqcx8q+oDdFOHRxZFDmCfaRGk7cwI+M3gbgoLaSppdbvdmZXcfFoEApuUJopF136jnCXTQFcQwJzk2iFRx3urgwPjHEztH50UWVyXez8iriZ6DrQhCbP1LOnSZxE+PvvUCmCAt0gWfx7b2Pyazv+vhzBi/pyC7KX5FEnnUNnwbHte7lLUTI+/OaPGaqVNj9exEzwGTn7ChSMORmVwNnNjS3yObQHqDHszJyFdlBr/pVW0MjHhJSzZqalh8s/yvmlUnHX/+z3lmJxCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:54:23AM -0700, Shakeel Butt wrote:
> On Tue, Aug 11, 2026 at 10:38:40AM -0700, Paul E. McKenney wrote:
> > On Mon, Aug 10, 2026 at 09:43:03PM -0700, Shakeel Butt wrote:
> > > On Mon, Aug 10, 2026 at 02:57:36AM -0700, Breno Leitao wrote:
> > > > I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.
> > > > 
> > > >   INFO: rcu_tasks detected stalls on tasks:
> > > > 	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
> > > > 	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
> > > >   Call Trace:
> > > >    shrink_lruvec
> > > >    mem_cgroup_iter
> > > >    shrink_node
> > > >    do_try_to_free_pages
> > > >    try_to_free_pages
> > > >    __alloc_frozen_pages_noprof
> > > >    alloc_pages_noprof
> > > >    pte_alloc_one
> > > >    __pte_alloc
> > > >    handle_mm_fault
> > > > 
> > > > Nothing promises direct reclaim returns in bounded time, and the scan
> > > > loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
> > > > PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
> > > > quiescent state, so the reclaiming task never reports one and becomes a
> > > > holdout.
> > > 
> > > I still don't understand why cond_resched() is being treated as involuntary
> > > preemption but that is orthogonal to this patch.
> > 
> > The history is that cond_resched() was originally intended to be a
> > preemption point in any otherwise non-preemptible kernel.  Therefore,
> > because it is a preemption point, it counts as an involuntary context
> > switch.
> 
> Thanks for the explanation. Is cond_resched_tasks_rcu_qs() voluntary or
> involuntary context switch?

That one is voluntary in order to take care of Tasks RCU's need for a
voluntary context switch.

Except that it doesn't bother involving the scheduler at all, but
instead just updates the current task's state with respect to Tasks RCU.
Much faster that way.  ;-)

							Thanx, Paul

