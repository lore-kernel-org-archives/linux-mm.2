Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72458CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F4B8E00A7; Wed, 17 Sep 2025 23:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FF98E006B; Wed, 17 Sep 2025 23:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845D08E00A7; Wed, 17 Sep 2025 23:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 732FE8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:26:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E9905B3BC
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:26:11 +0000 (UTC)
X-FDA: 83900932542.27.5EBB6F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EE27180007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:26:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xVgzKPzE;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758165969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFT5cidG4X3yNhl8KIfIN6nKHt7y2A3Lj1WlLYzpHfA=;
	b=Z6xv3szgQ69uSYA1Ga+0s+EAIwjHniz1/Vqv2CsKm5DmZLRT+AxX5n7z9sw0b3vf/zPuer
	PXR9ntqqSav/Xwf06j8ChqkzqCHE98N9nGhD1Yx1bBIFNz61+lOMZ2S1eDA0dqIU1nFVhT
	+Bysp3KJz0w9l2UrDA/LU0lgIf/AoEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758165969; a=rsa-sha256;
	cv=none;
	b=2P7jmzbudk1bKhrB8Zcq1FXR3/BH7AvttxMbMmqjY7wonKUtDmHOovg7nPbY99q0YFY2o5
	Bg6spYbLVtT+Q29kGSxBk6iZ+ZaRT90MKm6o4kkkKhXgbdoU5rCIAFpmnQK6IHk9npPO6t
	VVOlltIUl4l7aZ3+G/8JXkuWrfE0ytI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xVgzKPzE;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D75760010;
	Thu, 18 Sep 2025 03:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB00C4CEE7;
	Thu, 18 Sep 2025 03:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758165967;
	bh=FirTgoA8QKBiq40eS+mg/EDHgGtgRWtep9eREaFgiiA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xVgzKPzEzthbiVN21aMkylYV6iPBCfv/X3+PoKtxmLcP6SqltCn1Mol99vLYS5tj4
	 DsY7p6p+UbDxmgCZTr5k+pw957/Vl92YAz+sgkSM0ENnv1XYmURCjfQg33F/0Su6wS
	 v3KynmH5fVpNewjzXG6gdlGFdT3UsCniUmZU7Rqg=
Date: Wed, 17 Sep 2025 20:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
 tj@kernel.org, muchun.song@linux.dev, venkat88@linux.ibm.com,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu
 <mhiramat@kernel.org>
Subject: Re: [External] Re: [PATCH v6] memcg: Don't wait writeback
 completion when release memcg.
Message-Id: <20250917202606.4fac2c6852abc5ba8894f8ee@linux-foundation.org>
In-Reply-To: <CAHSKhtdt9n-K6KGXTwofpRPo-pH0-YoKFLtEe3Z4CszmNL0rCg@mail.gmail.com>
References: <20250917212959.355656-1-sunjunchao@bytedance.com>
	<20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
	<CAHSKhtdt9n-K6KGXTwofpRPo-pH0-YoKFLtEe3Z4CszmNL0rCg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ox8oxuo7s3fjsb93es6jcfa7bpktotaj
X-Rspamd-Queue-Id: 3EE27180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758165969-426537
X-HE-Meta: U2FsdGVkX19OhsDr8rY3NDLHNxjmq2UGN6QwckNjdCJMMgCMXDJG2JMGoyJidsOFCmya3BvdUjxfhjTY+DrjhVal47TfqLg3dAAji8+mwCwLLtzGO3DrkEIZbAtldZb8IhavFHhD/sdWcD3FshNKQ1dcJP+fJ0sqURzF2BFiVTs7RY8APJgqGZbgHGWVkxFjd11tDlbFj9Fr/bxAuHXABDxxEB8QUlT3QHSngdnnq6cVloowrwUmO8W5Ar0kZ515Eeet52yldf+XKKh6kemETTnwOoyofH9Vp+VXxYW+S9A4bL2HMFNkWUqtP8UVHlr/egLHtzLSqOym/ELCpz2Vzepooz0qNwHKaRZhfhrPfNSTHzF7f6RIJKiYQdeu01h3Cn1Nlhx2H+tMP41rn3fXyf7S0UyE4UTJlMdrH3qsKEFK3+HilP7ZAseZIeKCQs4CbBtz4F3csi9oudVa+vAN+OYyHSmMS8kKenlShydrLzgoPrioyAaDrg/hv/XtAnHrCH6hDE5Y8THEA38v68I2ycMi9m6X90tCL7GimUSTwPCgJVw6Sj3f3JemN1KeGKqXeF0fzqjRTDJ28vezUQiCB3WXTA1MoFe2+fnLbtZvZz+JF2oqU382JUPnhkloEgzlQxK9apYdnebMJFtaRRMXFbAbSX/OON9mgXgQPJWqOeTUh8/SxsU3CR4xX4PRnuHK3WPCBGp1gMbQz42s/De5yYc49xlWzgAMFxwWAhJmv5K91QNktyW8HkEOVQqVWZh0KIHEJQr5MoW030p6q1VIo2QyJePFIbvZOL+juOWtt0Dt8XNEOOyrSiiyRnT88o8ZNWWcEqSvIgc7o40mAQsD0AlxIyaSfk+x2vtcKlpzVxwQOitf+iHZxa5T+XHchO5WHpFG7o9XqfOas70ps7cTlubrxJGZLkNEsTtFnKOPFVp7LemgK4kPVLrN6lUzj1pE+MsUMB9LkvUixTFEb5o
 XDLvV64X
 P+aXysCBAC/N4c6HCXq/gH5RuD6IDgyyWWmv110ERGLncnV6X2ASimQ6ae0K7FuX68lz81805MhYcfZWBVGRUyrT7NZRI5x2kHmC/RcGI7/JRT5gweh/DCVH+ft7zM4NCUVHIrito1CX+LJScELhv5OOpNVFZeQUgLmWz7jYAMxIlPlMOl14kbPfVB+0GSWCVx89exclsqH7LTK3sFPnuKpw0N5gwRkTu8XNkKcpHERCq34dQ3hT/9WbJqOyF20s/gdO/4slQC9cuqj5WxSecWiagDo41iTfHiLpcYidUZvAvgFKL34OmgpGqXNuuTgYkJEt894T/N3iI6GYTSSox8PQFLdG0AMzDLtVhu/WUf1T8ffs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 11:03:18 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Hi,
> Thanks for your review and comments.
> 
> On Thu, Sep 18, 2025 at 6:22 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 18 Sep 2025 05:29:59 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> >
> > > Recently, we encountered the following hung task:
> > >
> > > INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
> > > [Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
> > >
> > > ...
> > >
> > > The direct cause is that memcg spends a long time waiting for dirty page
> > > writeback of foreign memcgs during release.
> > >
> > > The root causes are:
> > >     a. The wb may have multiple writeback tasks, containing millions
> > >        of dirty pages, as shown below:
> > >
> > > >>> for work in list_for_each_entry("struct wb_writeback_work", \
> > >                                   wb.work_list.address_of_(), "list"):
> > > ...     print(work.nr_pages, work.reason, hex(work))
> > > ...
> > > 900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
> > > 1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
> > >
> > > ...
> > >
> >
> > I don't think it's particularly harmful that a dedicated worker thread
> > has to wait for a long time in this fashion.  It doesn't have anything
> > else to do (does it?) and a blocked kernel thread is cheap.
> 
> It also delays the release of other resources and the update of
> vmstats and vmevents statistics for the parent cgroup.

This is new - such considerations weren't described in the changelog. 
How much of a problem are these things?

> But we can put
> the wb_wait_for_completion() after the release of these resources.

Can we move these actions into the writeback completion path which
seems to be the most accurate way to do them?

> >
> > > 3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
> > > 3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00
> > >
> > >     b. The writeback might severely throttled by wbt, with a speed
> > >        possibly less than 100kb/s, leading to a very long writeback time.
> > >
> > > ...
> > >
> > >  include/linux/memcontrol.h | 14 +++++++++-
> > >  mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
> > >  2 files changed, 62 insertions(+), 9 deletions(-)
> >
> > Seems we're adding a bunch of tricky code to fix a non-problem which
> > the hung-task detector undesirably reports.
> 
> Emm.. What is the definition of 'undesirably' here?

Seems the intent here is mainly to prevent the warning.  If that
warning wasn't coming out, would we bother making these changes?  If
no, just kill the warning.

> >
> > Would a better fix be to simply suppress the warning?
> >
> > I don't think we presently have a touch_hung_task_detector() (do we?)
> > but it's presumably pretty simple.  And maybe
> > touch_softlockup_watchdog) should be taught to call that
> > touch_hung_task_dectector().
> >
> > Another approach might be to set some flag in the task_struct
> > instructing the hung task detector to ignore this thread.
> 
> To me, this feels kind of like a workaround rather than a real fix.

I don't see why.  It appears that the kworker's intended role is to
wait for writeback completion then to finish things up.  Which it does
just fine, except there's this pesky warning we get.  Therefore: kill
the pesky warning,

> And these approaches are beyond the scope of memcg,

So expand the scope?  If hung-task doesn't have a way to suppress
inappropriate warnings then add it and use it.

> I'm not sure how
> Tejun thinks about it since he mentioned before wanting to keep the
> modifications inside the memcg. Given the fact we already have an
> existing solution and code, and the scope of impact is confined to
> memcg, I prefer to use the existing solution.

mmm...  sunk cost fallacy!  Let's just opt for the best solution,
regardless of cost.


