Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BDDE83EE4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3256B0093; Wed,  4 Feb 2026 02:31:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C616B0096; Wed,  4 Feb 2026 02:31:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F5C6B0098; Wed,  4 Feb 2026 02:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C62766B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:31:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7080E1A071C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:31:43 +0000 (UTC)
X-FDA: 84405954486.01.D1F2DB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C4AB440005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:31:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eLzhmU/v";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770190301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQeD//g7qTGSUf0Euogkk2UB+un5n4tdYik9/w5fH7E=;
	b=b1rudT9JQbG8z2qu0v5yJQhjfAc8Q8PGPVS8v0BSPDHheCFF1jeWq0PJ4GL7DEt/ZMGyvg
	ZmJIq6CONF/qnoDi4T7CSVe5MnD6sKA4eO5EqrtqQRD19XoM+V1AULp4+l2uvsArnPlnT5
	DB5M1oekV9srhJq557Lk4YDUWcHgkXs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eLzhmU/v";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770190301; a=rsa-sha256;
	cv=none;
	b=UtKYQoTYHuIKJ7AVi6quf/ymJmNbYnYkMCkKh/OJoW9PvF1I75T3DIcVfpYmr2FD1rZ9ag
	a49aaeVNQouNULN+XC6tB8I08vzjPhKtd1SrvxPGd8vgpwxybWJcOn3MB4cv6Pl0ZetWHX
	btaYNf8Idaq+pcNvmwTJv/lO3Nt7IkM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 383A660010;
	Wed,  4 Feb 2026 07:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD87C4CEF7;
	Wed,  4 Feb 2026 07:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770190300;
	bh=h8IFr3hAC3Re7Gtgad9D9ErBYgAe1ei2FUSAKZYjjM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLzhmU/vh6ibnUoQIkKF4n1DxSPWw1DfbD9La3zxbhOgTEVxFcSZzvL6jb9IRp0kM
	 2gU/cVFQd5dF9sKT+eN4nY/uQxDplOAMY/y/Bvo8kSJAcUYSRvDeP7MBME4ILFTkkG
	 BRzmEJd9LlvViVTmsGOy1g6Pk793bzFKKR98yff9xyeZzSxLoOZuxIS/dj4XnB6srk
	 dYE4w4s7tnR0z16XGOhM6ldkBUCc8tbWnbAT1PYAsDm6ry/Qu7cior/cD2kRXQ0UJ5
	 cmyplZxx0R5cMCUiJx3ogXvtAsrOQzgeyrMRJo/XCKdxQix0X8ImvwhkvDdJCss5o6
	 G6OHWOgpc5Bsw==
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
Date: Tue,  3 Feb 2026 23:31:32 -0800
Message-ID: <20260204073133.16471-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <56e9d735-d728-445d-9d5d-f044c9fe53b2@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4AB440005
X-Stat-Signature: xhxenm43pcz3dknrhc9r3mktogfzkow3
X-Rspam-User: 
X-HE-Tag: 1770190301-2125
X-HE-Meta: U2FsdGVkX18tzvJIKeho6np9f3er+By2AfMFOeZtebLSICX+rdzquEW+Te3/UE6zFRqtujAmn/kb9jcN/YENUu1JwawS0lcTaVDQ5mCRu1eb7PuqgxFxZ9D4dO4+tMCyJodKTgIK/G8Aqgahj9G5qyue/QTgEVr5NPlJjEI5hvYEuWEsGgsakSJO/7NGUEysolQlpQ01uiAc4TiesPGm8Ij1H6wW5DM40GshHYyvI9FZccD22qNJiA7GSL/Fmm3GcXMTybdutnDeBgGzHq9TWB5T24apMUh0G/C4RVXfMm1vRrW1CJlR4gJp0kpGNJJbmc5xdJCPLgG82FzL4uJoNKLr627hOPziBCO0IUAc2us76aX/61NMJA2YNrvbG7LTp8c6uPWUwJvg/uUoJtyDDlseaXvYK2CKW8VtpCKaQmGr7VQdJFr7+Kf+BW6+0xNQyEZ5l1Xeiri60Iz1v0vbt7nMLeTeKebLYeI3619fSBCEJlzMVXN03uHbdWSAMwGNHqM2Bkt/neriZeyqYadKa/c6+d9fRVvF6I7h1/l7j+qpSt9NDNmu5PrMzaEyKfy640nVU50fmw3tt85cWAjpjbJ1NW5wMbVggnAYRQ/cN02hWS1yHbNnMmGu2Wq/iOqCGiuO8EarSTlseFhHR/i0S+ceZdMM2XPEZHDbb38ohkgVgSdBjE1UqglNDpF5QYR1ebRjXqpZSqMfjH5IcuNWI3BSV4MfqjNCuJ4vqnBHgFQkH5ga86/cvdsF+OpmHXA2FK/t+SdzPiG3pODd75IOO7s5kM7uilSyTk//suM8Lq0xKzXJDkHNN/uMBDGfW/KnfO5/SlPNT7kN2FxxBpd1AN2sqzXo4/KNiT5g8ceO5mvUffMAvZOuhoJmPOuvEEhgCEvdM85vcXyEGkP/3+mM3BO8VAbm1EkTQTdkzVoe6S6+jJ6aQngAuqqxRNYjgUDPz2CSbXAwmrBAx61APeX
 FN/DD0dr
 k901QME6feigcatWESHxJ5xbzKJKMj6fLPclgBMHeWkbpv+dixFrWKcdyZO3EmBlAqy45NJTjdRyMKy0qhkMkO1HOFVfZQ60tsFnpGtFrm3jHvgugy/73fXjYGluQx4WKhH7AFQgKawj82206JKs/UNczur5d3BUVBZm0RCFL5k/Du1Q6TQScO8hreTlu4g2EKkYzABKsoSEY4HNDGUzROEh51rhMN2NeKmyk23ByW29cQ0RRXvYKWThaTBttNBASMm6uQlY8eoW469o3m4Ib3vRZvw5kc1DRZJjz+L/96qBII+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Feb 2026 16:03:04 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SeongJae!
> 
> On 2/3/2026 4:10 AM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > 
> > Thank you for sharing this nice RFC patch series!
> > 
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
> > 
> > Sounds interesting, and this high level idea makes sense to me. :)
> > 
> > I'd like to further learn a few things.  Is there a reason to think the top 3
> > tasks are enough number of tasks?  Also, what if a region was hot and
> > successfully promoted to use huge pages, but later be cold?  Should we also
> > have a DAMOS scheme for splitting such no-more-hot huge pages?
> 
> No specific reason. This was just for the RFC. We could move this to a parameter
> somehow.

Makes sense.  Depending on the test results with 3 tasks default value, I think
we could just keep it a hard-coded default one.  If it turns out it is not
working good for different cases, we could make it a tunable parameter or
internally auto-tuned.

> 
> In case of a region turning cold, I haven't worked on it. In turning hot means
> that we collapse the hot region, we should do the opposite (split) in case the
> area turns cold. I haven't thought about it, but that a good catch. Thanks!

You're welcome!

> 
> >>
> >> In each kdamond, we start with a high min_access value. Our goal is to find the
> >> "maximum" min_access value at which point the DAMON action is applied. In each
> >> cycle, if no action is applied, we lower the min_access.
> > 
> > Sounds like a nice auto-tuning.  And we have DAMOS quota goal for that kind of
> > auto-tuning.  Have you considered using that?

Maybe you missed the above question?

> > 
> >>
> >> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> >> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> >> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> >> which needs the correct vm_flags_t set.
> >>
> >> Benchmark
> >> -----------
> > 
> > Seems you forgot writing this section up.  Or, you don't have benchmark results
> > yet, but only mistakenly wrote the above section header?  Either is fine, as
> > this is just an RFC.  Nevertheless, test results and your expected use case of
> > this patch series will be very helpful.
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> 
> Sure, will add the benchmark results in the next RFC version.

Looking forward!  I'm particularly interested in your expected or planned use
case, including why you implement the top n processes logic inside the kernel
instead of putting it on the user space.  I'm also interested in how well the
test setup is representing the realistic use case, and how good the results is.
That will help us deciding important things including whether this can be
merged, and if some corner cases handling should be made before or after
merging it, earlier.


Thanks,
SJ

