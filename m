Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D58F106ACFE
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23A26B0005; Thu, 12 Mar 2026 20:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1306B0088; Thu, 12 Mar 2026 20:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3666B0089; Thu, 12 Mar 2026 20:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 799816B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:08:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0349FB994E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:08:28 +0000 (UTC)
X-FDA: 84539103138.02.1FB09B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5FC9240008
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:08:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIQQpLJJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773360507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlWPa0RzgWVG92m9Hbu+Ig8KeL5p7SSN2O0kDFTLxbk=;
	b=08bbcV0E9RNZmt0CEsoSEHb+032dkCBzrRVqH4aMUy7iaCdgxMmBXv2HtZtu8WaDO6oHb1
	NveYKkBFjDNH49qb87efJSvhlah7JGB9kbeGqE8GdnUOBW2pIpg2kXEbJMMqbz/txtIWxb
	g+D2oeRZ+3RNyApJxchAV8I8B/l4gQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773360507; a=rsa-sha256;
	cv=none;
	b=4tS5VviBOUN8evtDTvGPXVf5gJ5V6SGD7C15OAW2x6PgSJH6pJKEvPIYvVd8x+4lYwiVMQ
	6fAk8GA3QETMZAzKckwq/qZU61kZlEBFkRKwq4gkTn6HCuxmJmWPd7xkM2310YQW4Fh9qY
	xfq8unP1zh8pnKgNA+jkyIBvWutWY3o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WIQQpLJJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD16561334;
	Fri, 13 Mar 2026 00:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283E4C4CEF7;
	Fri, 13 Mar 2026 00:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773360506;
	bh=gMjwXqVB/Ml9Bor9TZ7ZxiScejZjlcWNGhUfeVmJzDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIQQpLJJMbnXEf95oreZlQzkeII68QkGLl99vbHrevNK1hzF8jtqxajW1I3LIX4nE
	 0ZOb3dAmfbVnweQ9NCf3ON7UdMtG47UWd/6ouqSeMNVlQ3su3UOUB0DlCfOl7AgJxM
	 UppmzDssFYuzwXklRXbhJNmAPfppODtOtHJIiAKHNrJr53u5ite/0veE0D7ivwQyM2
	 skUTbOPxtHiJePix9BMH3pcgJGlfQpNdl2AUpFRDAt+qZuY94ysOsiXACKMesVfq2R
	 VUtZHhNbf00GESpeEBoF1m0EPFSA/SCzJBLRecYuxyJXAJ5vuvuh/IemICFGFmtJVx
	 RCYzD/4EcpOxQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Support hot application detections
Date: Thu, 12 Mar 2026 17:08:16 -0700
Message-ID: <20260313000816.79933-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2a6c346e-6604-407b-9d52-1cbe15486b66@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5FC9240008
X-Stat-Signature: i5qn6odr34jumtmkow6xd39ah7cosw4r
X-Rspam-User: 
X-HE-Tag: 1773360507-216748
X-HE-Meta: U2FsdGVkX18HQ2gTaAxYwRVJBAsKP2IOTRHng9sjcVEl9Crg6B+92soqDQERwF263o5ugQgw20qvSgNI7so9X0aoKmBw7EXYZ3HmC93zTM0sUKiYPshi+J33fFIH5Jgc7ONoke1ZXUpKbkNlzW40OzAedqOQtCJxTbrKiRMMtRN4LoNbzbxsWJscHzx9VltrCA06ONTYdosY3j83928fH/i/vJ9lS4bY1OnQ/GVw/A/bzrlhM6mltOjdfKWpJXu9zWy3JJA9Z1HrphgFrUYuVgsOZhEiR1KXIn3+exDme2VMyZ5ubY/9bZJVEOsbayBuFokJHTBiQxDbTicsMI8PCggo0wM+fm4wYBr+MWcI/xw9sLJTIWXn7F30gMUb8tPK5WwsG5VfmPfuqgY9X5VFXTHBpZIbnvyOEx4gX/TvbC9HFoza/v2WLdomStc6A8rbWnAUXcEIQ8IUy90yV1MxcoM7Ai7wpN5wkMyzCZlO6hUbNUIoankWcCdLEczWX5wGis3o6tKZbxanptnvKfeif8CsxVAZlYAnGihSmLdOKLNjCLjhEMW46zqOL7JhMcn5fRYSimOkbQ04sUPeEMa3l8MWsImCj4lWBGLly3tt1fKeS2ZpvG4D9+lvQfOSCXfEygRa26cEfULoiD0atXAuiB6Ch9D1718zpKY8Or42x4bSgL/X5zyccbt+7RJN2CqYXaNmgm4+4/kd6nB7Do/WEkBVZzHMsUL/9XB91zmPU5Bdu2M4KN2TvE4DU6hLx5T6TGzisGq3lvMjDarnUqAYvawAXyL7aBpvMxZW0GI4wKN3XN1/Seg5TFCjkLC00PDHlj5teNIXkRJVWkURLaDJHRIL8ubv+5vkKtcY3Y2MVLKg6EhQ+jhgUgRAdfYfBaqrQ9Qk2mE2KG4O8YoROuGjLeg3jqbbfYhnPxo/6GWyhklCDgcdZLEhx2o/J808bWTcHMlIGOi1+2gGEMlU2Iv
 BltvoInU
 2lkkONyegLws9GhNgrNaYz3Fy3iJYfjlXfB6FCHOACQ12omtZD5nCCF/OQ4743qPEKok9eYBvz8ObwjGEf72kix52hr64GesRY1rexlY+ele/KcL5rNdJGgNOtMJB0GJDa4uvF/vZ1N1eb9W6e72Nd2O8qHDrs1MVx/+YuMRphiajgqLJg0e2oht5pfjs3O1v/MCHRWq2sFb2+k8C9QgK7Xy/M5H8TZnGSNGW2/aIdIMn+0n8dRqlqAt8riB290gRUH2POyOGKNqqNgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 17:42:35 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/11/2026 5:39 PM, SeongJae Park wrote:
> > On Wed, 11 Mar 2026 16:08:56 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> Hi SeongJae,
> >>
> >> On 3/11/2026 8:07 AM, SeongJae Park wrote:
> >>> Hello Asier,
> >>>
> >>>
> >>> Thank you for continuing this work!
> >>>
> >>> On Tue, 10 Mar 2026 16:24:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>>
> >>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>>
> >>>> Overview
> >>>> ----------
> >>>
> >>> Let's make the legnth of the subject and the length of the underline same.
> >>>
> >>>>
> >>>> This patch set introduces a new dynamic mechanism for detecting hot applications
> >>>> and hot regions in those applications.
> >>>
> >>> Seems now you offload the hot applications detection to the user space.  If I'm
> >>> not wrong, you should remove "hot applications and" on the above sentence.
> >>
> >> You're right. I was not sure whether changing the RFC subject was right or not.
> >> I will change it for the next RFC version.
> > 
> > It's fine to change the subject.  Please feel free to do so in the next version
> > :)
> > 
> >>
> >>>>
> >>>> Motivation
> >>>> -----------
> >>>>
> >>>> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
> >>>> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
> >>>> fragmentation and memory waste. For this reason, most application guides and
> >>>> system administrators suggest to disable THP.
> >>>>
> >>>>
> >>>> Solution
> >>>> -----------
> >>>>
> >>>> A new Linux kernel module that uses DAMON to detect hot regions and collapse
> >>>> those regions into huge pages. The user supplies a set of PIDs using a module
> >>>> parameter,
> >>>
> >>> This sounds reasonable to me.
> >>>
> >>>> and then, the module launches a new kdamond thread to monitor each
> >>>> of the tasks.
> >>>>
> >>>> In each kdamond, we start with a high min_access value. Our goal is to find the
> >>>> "maximum" min_access value at which point the DAMON action is applied. In each
> >>>> cycle, if no action is applied, we lower the min_access.
> >>>
> >>> So, this patch series introduces a sort of auto-tuning of the hugepages
> >>> collapse hotness threshold, that implemented in the new module.
> >>>
> >>> We already have a sort of DAMOS auto-tuning feature, namely goal-based DAMOS
> >>> quota auto-tuning [1].  Have you considered using that?  Of course, it might
> >>> not be able to be used as is.  Some extensions, e.g., introduction of new goal
> >>> metric, may be needed.
> >>>
> >>> Yet another approach would be implementing the auto-tuning in the user-space.
> >>> Because DAMON parameters can be updated online, updating the min_access from
> >>> the user space should be doable?  Given the fact the module anyway require
> >>> user-space control for feeding the list of applications to apply access-aware
> >>> huge pages collapsing, I find no problem at user space driven auto-tuning.
> >>>
> >>> If the goal-based DAMOS quota auto-tuning or the user-space based auto-tuning
> >>> are feasible, all the controls can be done using DAMON sysfs interface.
> >>> Introduction of the new kernel module might not really be needed in the case.
> >>>
> >>> We have DAMON modules in addition to DAMON sysfs interface for users who want
> >>> to use DAMON for a given specific use case with only minimum or near-zero
> >>> user-space control.  In this case, because it is already aimed to ask the
> >>> user-space to feed the list of applications to apply DAMOS-based hugepages
> >>> collapsing, it seems a new module is not really needed, to me.
> >>>
> >>> But I guess your use case might have some special restrictions that really
> >>> require use of the module instead of offloading the auto-tuning to the
> >>> user-space or DAMON core.  Is that the case?  If so, can you share more details
> >>> about it?
> >>
> >> I haven't figured out how I can use goal autotune to change the min_access.
> > 
> > Indeed, it is not a very straightforward feature.
> > 
> >> Your suggestion about moving this to the user space sound good.
> > 
> > If it works for you, maybe that is best for you :)
> > 
> >>
> >> The idea was to stop lowering the min_access as soon as collapses occur,
> >> since we don't want to lower so much that we start collapsing regions that
> >> are not very hot.
> >>
> >> Maybe you can suggest a better way to do it. Maybe with autotuning.
> > 
> > I will add more detailed suggestion soon, by tomorrow or a day after.
> > 
> >>
> >>>
> >>>>
> >>>> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> >>>> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> >>>> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> >>>> which needs the correct vm_flags_t set.
> >>>
> >>> This makes sense to me.  I expect DAMOS_COLLAPSE to have some advantages over
> >>> DAMOS_HUGEPAGE for some use cases, similar to MADV_COLLAPSE vs MADV_HUGEPAGE.
> >>>
> >>> From my perspective, this patch series is introducing three things.
> >>> 1) hugepage collapsing hotness threshold auto-tuning, 2) the module for running
> >>> the auto-tuning, and 3) DAMOS_COLLAPSE.  To me, it is unclear if the first two
> >>> changes are really needed.  I will wait your answer.
> Yes, I tried to introduce those 3 things. The problem is that I initially found
> goal autotuning quite confusing, so I kind of implemented something that behaves
> like autotuning, but doesn't use DAMON's core algorithm. 

Sorry for the confusing autotuning.  I will try to make it better documented
and simplified.

> > 
> >>>
> >>> Meanwhile, the third change seems reasonable and not necessarily need to be
> >>> blocked for the other two changes.  I think separating the third change from
> >>> this patch series and upstreaming it first could also be a path forward.
> >>> Because the change is simple and sound, convincing me would be easy.  I'd be
> >>> convinced if at least some reasonable test results can be shown.  I'm not
> >>> saying we should drop the other two changes.  We can keep discussing those in
> >>> parallel.  Rather, upstreaming the third change first could help finding real
> >>> benefits of the other two changes, since the testing will be easier.  The
> >>> decision is up to Asier, of course.  I'm just sharing my two cents.
> > 
> > I'm also curious what you think about this.
> 
> Sure, we can upstream the third change. I will prepare a new patch for with just
> that diff.

Thank you!

> 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> 
> The use case that I had in mind is pretty simple. Few admins use huge pages in
> production, since it leads to memory fragmentation and waste. On the other hand,
> amount of memory increases faster than entries in the TLB, which means more
> TLB misses and more cycles waste. My goal is to balance this. Improve performance
> in applications while keeping the amount of memory waste due to fragmentation to
> a minimum.
> 
> Imagine a database server. The sysadmin would like to collapse only hot regions
> of the database task, improving CPU utilization but without wasting too much
> memory.

This makes perfect sense to me, thank you for clarifying.

Nonetheless, I think there could be devils in the details.  For example,

1) How we find the application to collapse hot memory for?
2) What should be the hotness threshold for the collapsing?
3) Should the collapse be done asynchronously like MADV_HUGEPAGE, or
   synchronously, like MADV_COLLAPSE?

And I understand now we are aligned with below answers.

1) User-space may know and existing DAMON sysfs interface supports that.
2) Users-space may know and existing DAMON sysfs interface supports that.
3) Should be synchronous, but DAMON doesn't support that; DAMOS_COLLAPSE need
   to be upstreamed.

As I mentioned above, I think this makes sense.  Looking forward to your
DAMOS_COLLAPSE patch!

> 
> 
> Today I sat down and review the damon code. Given all your feedback, I think
> this I didn't use the right approach or I didn't understand you initially.
> My suggestions:
> 
> 1. Implement a new goal type for autotuning that uses huge pages.
> 2. Implement a module that uses this new goal type.
> 
> Would this make sense to you?

Yes that sounds like a nice step-by-step approach.  We might need to discuss
more about the details for each step, but I think this is the good direction to
go: merge obviously beneficial part first and discuss more/revisit next thing
one by one.


Thanks,
SJ

[...]

