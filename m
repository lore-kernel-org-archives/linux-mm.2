Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5411AE9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0256B0005; Wed, 11 Feb 2026 10:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D246B0089; Wed, 11 Feb 2026 10:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689416B008A; Wed, 11 Feb 2026 10:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5444E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:09:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05BB414045A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:09:13 +0000 (UTC)
X-FDA: 84432508986.10.86B5308
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E200C0012
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:09:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4nWvANk;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770822551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXJ4LU2nkF4qJHIJYRsMrgM5n5UtAbQvh7PaDQNAEks=;
	b=d6spqPJoNVwhdyXUByqADGBR/DCkPjYdU0zI0Sxoc59mF63N2FqlV2Qiznb+C5qD5XEFfn
	zsSgQFZf5ZwjN2RFyDmne0wtO1fYkRCdBZBLQUOb0vkffI9gvxX5PCdPSbm1peErQKC3WD
	kklhKWSgGdpqWmSinj+Us3XYXfkuyHo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4nWvANk;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770822551; a=rsa-sha256;
	cv=none;
	b=EHIrT9zVtyO8SqTc/tCjLcqvsE8gmBplZWJIrn5QFZ3/a/xpZbYK00wkU/FD1TfOgIKT99
	aT7BSfn3UhKDyZepj+kDAKCMmJexNKBweZhKedypB8Ya8AaJlLcF/+6Nkze3RN5sO+LT0v
	oYjNowFXtcs3UaKrCHQvAkiWGTd0Vys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F00460053;
	Wed, 11 Feb 2026 15:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200FBC16AAE;
	Wed, 11 Feb 2026 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770822550;
	bh=kidemfEHfwA/RaeWaMvfBYTeQqC+AQw/P+YNx91uzmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4nWvANkBzrOKUXI1x1jpjzjzGphxi6Y5PKgMoqdjdUwXbIzzhp+ixpZ61VwuhvGm
	 VZnyO9GlHj6OmKp3WOd+3RodKuckpjTC9PBYoVRs9Pke9EZM5qHF9YOF8AFeZ7yy3P
	 IgEWJ6b7jpO3L3z7o5b8nTK8njzwbIf0Qg9jlMtRIQAjglkz38RhLKwXUa3uENTDus
	 hkIgxvlO4LTSRs/daYJ3KsXohI0MyFCynoZDB1VvWRtmYo3sVQs6DYXRlkL21GO+ds
	 Z/Lbm+fE5gf9HAsYoVzIXTRpqvDLMZMfbjTQAYik2t/n0sr5CeDk5TPKeDvvFKi1QJ
	 jRkwe2ZJk2e7g==
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
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
Date: Wed, 11 Feb 2026 07:09:00 -0800
Message-ID: <20260211150902.70066-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: cypbd8hut9ai48rbg776fp9ownjj558q
X-Rspamd-Queue-Id: 4E200C0012
X-Rspam-User: 
X-HE-Tag: 1770822551-53074
X-HE-Meta: U2FsdGVkX1+V1aBJK9y/fHibVfxy8lMM67Al6usQ1AnzCUGjmDVhkwDMOW1WYukKGDVYwDNj7lAWFrjShl2J5v0JA4okeN5LCjiGBuU4oi+iLCkoHMLZKh241z1iPIUTRq1TBvn0f2QjslhoiUMySqQg2ozl//E4Tpij9g/GWYB90cEdRdjZ72rExLXRt1Lyl6+nvDVoSt43v4xcFX0pYHjBhZt2xOOd+EcqmqqI5BqxNoq+cBMThPXVJmVqFruWlVqhSVyRmYVz2ETyg190cZHqCAtLQ5H/6Iwu9ms/A1Y/tjn3o+Lx9dCHhVPjHqcwVWnThs3HFVZf4pdAatIOpI4CBuqXRbXd9QmgaHZY4I9N0EVaCoS/znfIqa+zybTas7oFep6+9AxnuF7fUQTQppwIr0pXk5LpvKD16pw4C/66O+emfbmNRhuK+bUMrpR4Nh6h4eM6wHlcktEdanT7ucaJzC8b+SX6fbt2IjxpJXla+0H+pu8c8ABHvQJZDSNj3nPbeUBuCbJ+uC3ro6RluTm3Ihu/LUj9Akgns8Cx9rEbKX2phGsdO7187uXQtxVAxFMJnAVrPNZHd+MQwVglAg5W/jlqPhxGntONe69yB/QYJgTUeiLt32DNg0xInwMtoedk3ERTMJ2+ejscAPqONtmdN7Ah2F+bNHwkcFRKkztZarBSgdEF8kmelT6hdGGmqrITEn7MYsW+zx1G52teKAktLyr/jw8BPKCihSgcJMr2ykcbe3ZCSROw8nKHtwTVZAqb8Yxp4gmq9u4HKL2hWUue+3To7OSozZ38qINoDz2huq+IDuB1M9Cag9qePqWWHX3zLPoMgL4NUucKwdH5LbPoMXTSNkx/IZbhLf3XLD8IWPnXPX6z3fg9zI2NRI8lwe3lkCtkHf+9mhNJ2A5B+5uIl8m0zjiQJL8LUy7EzyMyaOCwenMJ4jQpFgkt2WOPjFTGDePKqtx8jqoFTEI
 mVtBSI/x
 cwWL4T8DEyoReF6sZzel+0lPX+m80K5U5Rpq+BU37vcyrgmQKIp4PYhPu7bgmhQEJX0qaMYXP1aWN6Y8o7VMKes3ZWa2QAfhl+BzqWLSsQQO80FRb3vVhtnfVItxqBYNIniyqINuuY454GWZrF3fjm6m5Xkkx+EKrYxPi8Yqj81GbVurS/6dIZxal8A+OH+Byei1IAyw1LCR+aimZxj6eyBhQ3leKRD5ok2EJEPoaa+t/AK2bq36j7LnfSsi5YOZu3k+FNy6oaUxl0ke5CR2Q4ABnMv+DByoRHjp8TOSh7v5/96sUMawWKxfZtnc97ParBh+JEbpg7yN4whw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 14:29:41 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SeongJae,
> 
> On 2/11/2026 9:59 AM, SeongJae Park wrote:
> > On Mon, 2 Feb 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Overview
> >> ----------
> >>
> >> This patch set introduces a new dynamic mechanism for detecting hot applications
> >> and hot regions in those applications.
> >>
> >> Motivation
> >> -----------
> >>
> >> Currently DAMON requires the system administrator to provide information about
> >> which application needs to be monitored and all the parameters. Ideally this
> >> should be done automatically, with minimal intervention from the system
> >> administrator.
> >>
> >>
> >> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
> >> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
> >> fragmentation and memory waste. For this reason, most application guides and
> >> system administrators suggest to disable THP.
> >>
> >> We would like to detect: 1. which applications are hot in the system and 2.
> >> which memory regions are hot in order to collapse those regions.
> >>
> >>
> >> Solution
> >> -----------
> >>
> >>      ┌────────────┐           ┌────────────┐
> >>      │Damon_module│           │Task_monitor│
> >>      └──────┬─────┘           └──────┬─────┘
> >>             │         start          │
> >>             │───────────────────────>│
> >>             │                        │
> >>             │                        │────┐
> >>             │                        │    │ calculate task load
> >>             │                        │<───┘
> >>             │                        │
> >>             │                        │────┐
> >>             │                        │    │ sort tasks
> >>             │                        │<───┘
> >>             │                        │
> >>             │                        │────┐
> >>             │                        │    │ start kdamond for top 3 tasks
> >>             │                        │<───┘
> >>      ┌──────┴─────┐           ┌──────┴─────┐
> >>      │Damon_module│           │Task_monitor│
> >>      └────────────┘           └────────────┘
> >>
> >>
> >> We calculate the task load base on the sum of all the utime for all the threads
> >> in a given task. Once we get total utime, we use the exponential load average
> >> provided by calc_load. The tasks that become cold, the kdamond will be stopped
> >> for them.
> >>
> >> In each kdamond, we start with a high min_access value. Our goal is to find the
> >> "maximum" min_access value at which point the DAMON action is applied. In each
> >> cycle, if no action is applied, we lower the min_access.
> >>
> >> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> >> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> >> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> >> which needs the correct vm_flags_t set.
> >>
> >> Benchmark
> >> -----------
> >>
> >> Asier Gutierrez (4):
> >>    mm/damon: Generic context creation for modules
> >>    mm/damon: Support for synchrounous huge pages collapse
> >>    mm/damon: New module with hot application detection
> >>    documentation/mm/damon: Documentation for the dynamic_hugepages 
> >> module
> >>
> >>  .../mm/damon/dynamic_hugepages.rst (new)      | 173 ++++++
> >>  include/linux/damon.h                         |   1 +
> >>  mm/damon/Kconfig                              |   7 +
> >>  mm/damon/Makefile                             |   1 +
> >>  mm/damon/dynamic_hugepages.c (new)            | 579 ++++++++++++++++++
> >>  mm/damon/lru_sort.c                           |   6 +-
> >>  mm/damon/modules-common.c                     |   7 +-
> >>  mm/damon/modules-common.h                     |   5 +-
> >>  mm/damon/reclaim.c                            |   5 +-
> >>  mm/damon/vaddr.c                              |   3 +
> >>  10 files changed, 778 insertions(+), 9 deletions(-)
> >>  create mode 100644 Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
> >>  create mode 100644 mm/damon/dynamic_hugepages.c
> > 
> > By the way, I proposed [1] an LSF/MM/BPF session for access-aware THP today.  I
> > also mentioned this patch series on the proposal as one of potential discussion
> > topics, and Cc-ed Asier.
> > 
> > I just wanted to make sure that the proposal is never a sort of implicit
> > request to hold the progress of this patch series.  Please continue discussions
> > and revisioning of this patch series regardless of the proposed LSF/MM/BPF
> > session.
> > 
> > [1] https://lore.kernel.org/20260211050729.69719-1-sj@kernel.org
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> 
> Yes, I keep working on this, I haven't given up.

Thank you Asier :)

> 
> I was thinking about your comments and about the overall idea. When you
> mentioned goals and autotuning, were you referring to DAMOS_QUOTA_USER_INPUT?
> The idea was to adjust the min_nr_accesses for region and I haven't found a way
> to adjust the damos_access_pattern using goals and quotas. If there is a way to
> do it, it may be a good idea to reuse already existing components.

I was not asking with DAMOS_QUOTA_USER_INPUT or a specific usage of DAMOS quota
goal feature for this use case in my mind.  Rather than that, I was asking
because I am also finding if there is a good way to utilize the feature for
THP.  That is, I wanted to know if you also tried that but resulted in using
a different way, because you found the feature cannot be used, and if so, what
options you tried.

One brainstorming idea I have, which I also want to further discuss on
LSF/MM/BPF is, making a new DAMOS quota goal metric.  For example, ratio of thp
to normal page.  Then, we can setup a DAMOS scheme of THP collapse action, with
quota goal of the metric, targeting, say, 50%.  Then DAMOS will automatically
adjust the scheme's aggressiveeness so that the target memory region to have
THP for 50% of it, in eventual.  Is 50% reasonable?  I feel that's good enough
for at least being default value as long as users can tweak.  But I have no
concrete theory, and didn't test.  Hence I'm saying I found no good but only
brain storming idea yet.  Yet another possible quota goal metric would be THP
hit rate, or THP collapse-causing kernel time increase.

> 
> Also, I thought about moving part of the logic to user space. What do you think
> if we leave the hot application detection mechanism in the user space and we
> keep the THP part and autotuning in the kernel? Maybe this way we can move
> forward easier and eventually merge it in the mainstream.

I agree that could be easier way.  Particularly, adding a new DAMOS action for
THP collapsing should be pretty easy in my opinion.  The expected usage and
benefit is clear to me, and the required change is quite simple (easy to
maintain).  If you have any good test results with it, I find no reason to
object it.

For auto-tuning, if you are saying the current min_nr_accesses adjustment in
the module, I'm not very sure if I'm understanding how it will look like.  A
few questions off the top of my head about it are: Will it be another core
feature?  Or, will it be the module's feature?  Will it be optional?  Why it
cannot be a new metric of DAMOS quota auto-tuning?  What is the performance
results?  And more. So I'd like to take another round of detailed review.

Nevertheless, even with the current shape, if your planned usage is clear,
tested benefit is significant, and you have valid reason to upstream this as is
for your selfish use case, I wouldn't say "no" at upstreaming it.  I may ask
some clarifications and cleanups, of course, though.

So, if you have concrete usage plan, quite good test results, and reason to
upstream it asap, please feel free to push it as is.  Upstreaming easy parts
first one by one would also be good strategy.  For example, THP collapsing
DAMOS action first, then auto-tuning (it may results in the current way, a new
DAMOS quota goal metric, or somewhat much better than what we discuss now), and
finally hot applications detection and more.

Whether to upstream it as is at once or doing it in smaller pieces is solely up
to you.  I feel like I sligtly prefer the latter one, but never a strong
opinion.  Whatever you choose, I will be happy to help :)


Thanks,
SJ

[...]

