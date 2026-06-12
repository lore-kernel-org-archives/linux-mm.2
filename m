Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953FCCD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 00:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF896B0005; Thu, 11 Jun 2026 20:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996DA6B0088; Thu, 11 Jun 2026 20:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ABBD6B008C; Thu, 11 Jun 2026 20:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4006B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:56:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D09C9A05E7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:56:40 +0000 (UTC)
X-FDA: 84869445360.21.D40B381
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3FDB440004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:56:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0emxHqC;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781225799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3kfnuMEeb5/mrVusiQhac4POy1/ixgY7y13y7pSyz0=;
	b=vpj41GL1BKTVLlimQ+LRXjhIARDQI7fNREugQLvTOeBe5vHBtjw8Fdtdluw54SXSXErqXD
	Wb1H1bGcMqSVZFh1OmHGExavn8vLe+Bi6PcGEn5gGTsVW+gGsddVrOms2PJBi3UNod9U+w
	4Cm/l7DiXcvhAc06h3cAqKbljXuHr20=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0emxHqC;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781225799;
	b=OGcX/AZ32zrpj+Ev5u5VTweWCTiG2q8Xyvw/qdBlXHRn8vhcJMafMkG1M9cCz7Fd3oQmwv
	Jc9koVwChinK5Xt8gpPYG4l4THdEITpAsY6N+8vQtm3rQZ0cGyYTlcYn+LZTuzxO+9TbIR
	K4NnYrLclEOqeFBUvIudf/97bVcvE14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC80E600AF;
	Fri, 12 Jun 2026 00:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255171F000E9;
	Fri, 12 Jun 2026 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781225798;
	bh=i3kfnuMEeb5/mrVusiQhac4POy1/ixgY7y13y7pSyz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0emxHqCf+PaOSTWXWqIs3a9/OijNhQdir/3EJM0kQVueh+wBhWX0Cz4ZHdGm6qnB
	 Nqfv+oRwDzBwJK0HnyJ7Jy6tJ6bz9M4jN7M/ecwuYVelQMbr2/hbiBtpIpDr3jLWG2
	 7vHnTwhYLEFKXllJQl24hs3EAumcuYPAiPMsigqbiiEXvLFW5+gXcIn9lc+4fbbEE+
	 1aY9ep78jQKjzmWpSItJCWqfGOhq08A7a69CyXfOxgC8darvDd45+W3veaPIBP1WAx
	 AStwblsxQG5lyJcEmvPPptVMLKdh2FzAMxn8xIlGvPtGKcECwzbi1f8kNwXh+IB4gU
	 4xACwnn3gAQCw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
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
Subject: Re: [RFC PATCH v4 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Thu, 11 Jun 2026 17:56:30 -0700
Message-ID: <20260612005631.83964-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FDB440004
X-Stat-Signature: 88smgoofun4a68zfztdmeacwyk4wwaqh
X-Rspam-User: 
X-HE-Tag: 1781225799-337141
X-HE-Meta: U2FsdGVkX193GWhebOsqEH4sqCAINl1fQL8kXbD7Xudh4rrI0jHhl5cuWtJ6+P67tQRa2KaZXawtbgLOmQ7qTifBPcbaqIY2Hvw0yiV20qjyExe8OOMm8xQiFkEnTdF32rhydILAdfTRGxZRWwtLlIyIpdlH7aoicN9Mj642BLiP5FHyHlc8F8AdAXoFK6jhKLhPQThm73YLd+sZNsD/ERngBkvoRQFGsPmxe69SIPOWbzTELhV8cK876tNN5QTov6gWL0kP1lkIymbg69t7vOHhxgxr74pcfrBVG9VADGBh+siuR3qiURsgxJwWISmRMGSWVGpgmh2XYD3cUM72kDIJlQoZc59fMAlF7EUSUrc6+SzjXxlU2qUEk/RiLMSjYW5+ug4fzZtPWZl1igYF1ODd1SBIAJZgN2RXqWAzwrRf+NTbcREp1Wokjoy53PcV6zTltrWBU2Fog5v/yUS/7X6jd6qOK5K0lByQQFIW6pkTqjVpqs1xtNLUeuQkB8efdcQBSR7Q4IM1Xo+0UXmvgZPtUyVoxjqvA8LGBS3zsQyWG2WEOwwkz37qwCbYfdc0M+V77z86z8wY4rm/vEsz2VaHJTI9rwpZJu97LpS829txWeWfDYPJI0UTNvQos3oVFKcosyxltQTf2q0ryO70E6QIXtmV1xR7VEzqWiZdZ8eMMt899SylivVh/rTskapeI8z+CUSrptRRKsRXQPTjwcBo2J6wL0iP1rIHeudWcA+vX4PVoJS55tHpuR3lBRvbbhHie+n1ovQJqhhVnDpz3wGdQut7TpzxBcRktCg2J3OaLA6UBPb6I9nBF/G3wVIbmvdw/qc3CNDlzl8Plr+wyvx0r94wbXh5HCQYPKU9Uh2CVrHm00wKf5VY0r7ltQ9hCkdOSDrcsaYIIpBblYHrdPOLXxhLKIxi827alnqSdoWrSEO6AH+CdGRgWgGoS2VlmzyANPiD/YWvTMWsMU1
 DV6os5gT
 AHioZS/BMXUjtdq2v/HoACHPfYKnZSm2vDFUwl2D/rHlYBWHJWStPsGlByy00bfdf8UIBdB0pMJGq6u+pD47MyWh0SaezOccoD2WPfFa3fle1liay9TUDTsSkOVRCn6oIG2QDd7Eb8jgEq2LOqijzpPwQwuEnNYBG0h8GHfep97Uzk6TC0zVpjstKPVsj1qeyrYPvh5FejKpd2B0JuJOZKdZ4iofXbrFuNDa16uD3SmM/HfNCK7xkvTy7dUW74CBe3GiJ6QhFfVH30MI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Thu, 11 Jun 2026 15:02:40 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ========
> 
> This patch set introduces a new autotuning which allows to collapse
> hot regions into hugepages.
> 
> Motivation
> ==========
> 
> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
> misses (or hits) is to use huge pages. Unfortunately, using "always"
> in THP leads to memory fragmentation and memory waste. For this reason,
> most application guides and system administrators suggest to disable THP.
> 
> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
> However, there is no way to tune the settings. It will collapse all the
> hot regions that meet the access pattern. If the server is a bare metal
> database or big data server, this will also lead to eventual fragmentation.
> 
> Additionally, currently THP is set globally. Ideally, there should be a
> way to control which tasks can use huge pages.
> 
> Solution
> ========
> 
> DAMON has now a way to autotune some of the variables and adjust quotas
> automatically, so that DAMON is fired only under the right circumstances.
> It would be nice to have something similar, but for huge pages.
> 
> A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
> which checks the huge page consumption to total memory consumption. This
> new quota mechanism reuses current autotuning architecture.
> 
> A new module is introduced to demonstrate the use of huge pages
> collapse autotuning. The goal is to collapse hot regions of a given
> process into huge pages. The module launches a kdamond thread for a
> certain task provided by the user through monitored_pid module argument.
> Hugepage goal autotuning will automatically adjust the aggressiveness
> of hot region collapses.
> 
> This module also has a user autotuning knob which allows the user to
> adjust the aggressiveness of page collapsing.
> 
> Benchmarks
> ==========
> 
> Huge page collapse autotuning was tested in a physicial machine with
> MariaDB 10.5.29 and sysbench as the benchmark framework.
> 
> The hugepage module was set up in the following way:
> 
> # echo 1000 > min_age
> # echo 1000 > quota_percentage_hugepage
> # echo $(pidof mariadbd) > monitored_pid
> # echo on > enabled
> 
> The goal was to achieve 5% of the total memory used as hugepage.
> Since the database was not very big, we may not be able to achieve
> high amount of huge pages per total memory consumption ratio.
> 
> The table below shows the memory consumption over time. Gaps in the
> timestamp means that no changes in the hugepage consumption happened
> over that period of time in MB.
> 
> +-----------+----------------+----------------+----------------------+
> | timestamp | total mem used | huge page used | percentage hugepage  |
> +-----------+----------------+----------------+----------------------+
> | 0         | 3044.988281    | 0              | 0%                   |
> | 22        | 3160.207031    | 2              | 0.06%                |
> | 30        | 3250.90625     | 4              | 0.12%                |
> | 69        | 3781.238281    | 6              | 0.16%                |
> | 71        | 3822.226563    | 8              | 0.21%                |
> | 72        | 3846.578125    | 10             | 0.26%                |
> | 73        | 3852.402344    | 12             | 0.31%                |
> | 74        | 3868           | 14             | 0.36%                |
> | 75        | 3881.84375     | 104            | 2.68%                |
> | 275       | 4194.175781    | 106            | 2.52%                |
> +-----------+----------------+----------------+----------------------+
> 
> After second 275, no more pages are collapsed into hugepages
> 
> Performance:
> Baseline -> 18,124.1 transactions per second
> Hugepage autotune -> 18,163.64 transactions per second
> 
> TODO
> ====
> - Support page splitting for cold hugepages.
> 
> Patches Sequence
> ================
> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> Patch 2 -> Module that demonstrates how to use
>            DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
> Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
> Patch 4 -> Documentation
> 
> Changes from previous versions
> ==============================
> RFC 3[3] -> RFC 4
>   - Simplified the module
>   - Removed unnecessary parameters
>   - Renamed DAMOS_QUOTA_HUGEPAGE_MEM_BP to unify the
>     naming style
>   - Switched to DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
>   - Updated the documentation
>   - Removed new interface for context creation with
>     DAMON_OPS_VADDR

Thank you for keep revisioning this patch series!

I think now we are aligned on the overall direction of this series.  Let's add
the new metrics with the sample module.  The sample module's overall shape and
size looks reasonable to me.

So I think now is the time to start making this series be more seriously get
ready for the landing.  I find some parts in commit messages and cover letter
that not correctly updated for my feedbacks on last revision.  Particularly
tests and future work parts,  and sample module name are not addressing my
previous feedback.  I therefore skipping review of quite details in this
revision instead of adding same comments again.  That could be ok for early
stage RFC series, but let's move to the next stage.

From the next revision, could you please take more time on addressing all my
previous comments and updating everythings including comments be consistent?
If you have a reason to keep some of my previous comments not yet addressed for
the next revision, it is toally fine but please clarify.

Also, I'm not sure if I asked this same question before, but ...  Could you
please share your future plans for this specific series?  What change you want
to further make before dropping RFC?


Thanks,
SJ

[...]

