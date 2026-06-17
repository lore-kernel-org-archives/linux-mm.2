Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39F3CD98D2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 01:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552486B00A2; Tue, 16 Jun 2026 21:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB5A6B00A3; Tue, 16 Jun 2026 21:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA466B00A4; Tue, 16 Jun 2026 21:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF94A6B00A2
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:44:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59EEE1402F3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:44:20 +0000 (UTC)
X-FDA: 84887709480.19.D2CBA11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90C5E40007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:44:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBeQ6XWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781660658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWonmRmFkJNnw1dE2vWsJp6Q2h+STEOSlv5KGccRfYg=;
	b=ZBgL1mx8Hw5T1xFI+mf2rjC3RjuwnB1JbnAeKEDTagDUO2K/vK/TRqcQ0dFPnHMxi6Q6U4
	WttE9Aj3iWUsahkgKr2iiZMwvd0CqT7SeWpktWZUZ9VTO2igEOdGYQoFmautF798InebyI
	XivWyxwEpN3pj5gZX4th5oth3YGeEoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZBeQ6XWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781660658;
	b=FoBi+VcAqH9eKSvaMCMervLVYG912PPYWPl5RqXcdCp3tdNIirJdW2DDDUWNbASZlteDQn
	USe01mVm/ER2kho4u4VooIJT17xrHrOHblMJwTJHAYE35f077CSe63aWRwUwQX68mXLY60
	NRi1MmlLEe0A4cE76BqbhB1Jaj/XwFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75BF643AD0;
	Wed, 17 Jun 2026 01:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6DC1F000E9;
	Wed, 17 Jun 2026 01:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781660657;
	bh=lWonmRmFkJNnw1dE2vWsJp6Q2h+STEOSlv5KGccRfYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBeQ6XWDnAAkx0fqFTRJerXNawV28VFsYo3Itual/Y2Y8kAZRSBf56e4TVTLhkA8L
	 GO4ATNm7qw/Xk67tkn5hnOW45vjtRlWs8D42dUzoybX0dbw5zn2J2jI8ROqs7JfSk8
	 gmtcMNg03E48Ry8aPu22I4lMhKZzTJKnp8Z+0jkfmaXe3W+O90S/FPovA5uFy3Y820
	 UGWDKykK6c4h4nMEcyRu0UIrOKvuAyuKMIH+6DCo2xchHqSUSGEyGAZ+cClvOmul7r
	 OPsj6/9C6KjhcNBe2v40P/vS1cmENg4toaz92kOiNSVXjvHleiSNc62uCtw2WHBJSM
	 6ZoDjs7mmrzwg==
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
Subject: Re: [PATCH v1 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Tue, 16 Jun 2026 18:44:11 -0700
Message-ID: <20260617014412.97819-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150316.580819-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90C5E40007
X-Rspam-User: 
X-Stat-Signature: 5cur3dxowxf33wosdkqxk6rkctunj9on
X-Rspamd-Server: rspam09
X-HE-Tag: 1781660658-264083
X-HE-Meta: U2FsdGVkX18K2lO0jIbjtHuhL69V0mGr6B+vEO5O2ODWcb4cDGNtZshcICwUsNz8DaLs5DDhhk4qCs2U2P1vaTKHD1bfHlGtn3b7+/FXJafJ6DMicZPS8t52EhEUSjEYWLCfTy12oDlqYafm8Q+MeD34bL3jRcEVT5zzZKe1awa/8n0y32lnscA4nSp/is5w9ru2rEa7gwdyT1rd9ny2hovaJfks/Tfaoobj2mhvR7xvgXB1ux9UJrvx9WBWbB4X1ALnelKQuuOe57o0jrjvxctdHLWVlHeeQrjRHMTYziJOjyj1KghVCwz9qGAydGHuED5oZiJBlTOfjhMTJOHM+gWdIvBmqpRnvFoas3Y23ZqdAnjxv5xVrD1AncXRPuxH/NnyO9NuBWvZjqyKcAUQdQR8wQwlP6S4HSsqgs119EzYUNMXiUNVtS2zBy2ZNv5OOzB9HIqJyVXx3/TZAGH9sEmpH67txVXBmkompzgsUYsqkaVpEHlaD+/Tx41rmjU6dMA8kfot1tV3oOPD3PJHzfJ8QVbM1QF9pU1CL5v7Ak/szzsGPw4v7pXrgZoGDMmKruMuDRpSaoZSFtLMv88k9ST+wQxLtCeIvkhF6bzrVgPFTwRJyWVMrOpoYrbXi61LscRptTCPwPvV7pWtdW/0BhFx+aut1ZkVQTHA9t+9nUAAs+TNpFYLtX5XwErEL7dm+XQikoASc+POem7KZNDiCECfJjnknZ7l8MTtiBYefKERjyg2iNiAOvlarYTXdLgE1rBU2g8DTdhqb6b4Wb7QRf6OEFTgSmtGc7uHFaricv9BiC6vsV6pvahardnbey8jaDCECfri0UaBAVpXx+tyKN9NsUI4KYbpjCitDG2T80m/QzdbC/ekmJ6nxvD2HQ20xtTNu1CEYJI9LxDaVZITecwldCqfvfYzhMuhnpZ1QTtbNrKu1jcIKGM5S8ZPGg4JA+qt8+FifzG0S8Cr6h6
 QJEM2+/e
 /26NpUEXTZD3fdsrchukO8aRiZjtiDHji2/gB6L1pnXMHpp42zeO/xUUdI8mS0/nUNHSQHpBspQHTeQV/udyvH1QW69W/PO9FapztR47TDYuDIb57HbnjnO3VF4iS5dreeFSIWG/uYuy/RlnDWNKhfRFlu+sv5XF3YkJFSHr3oCYAvCm3rUQvbMU8zNSz4+0l2GVfPD/On8PiBX2pKRE7j5t7voDHpkSXddSscJ2x4U213k2qgpRDl5Mh/IOFYGLHm5d0GDlYSrdpvDV+eBjTOe3vEwMClxONR8UASJdN0qSxsQQaH3g5pa77mEyw5Zi/6hFj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 15:03:13 +0000 <gutierrez.asier@huawei-partners.com> wrote:

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

Could you please reword for prctl(PR_SET_THP_DISABLE) like per-process control
cases, as we discussed [1] on RFC v3?

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
> A new sample module (SAMPLE_DAMON_HPAGE) is introduced to demonstrate
> the use of huge pages collapse autotuning. The goal is to collapse hot
> regions of a given process into huge pages. The sample module launches
> a kdamond thread for a certain task provided by the user through
> taget_pid module argument. Hugepage goal autotuning will automatically
> adjust the aggressiveness of hot region collapses.
> 
> This sample module also has a user autotuning knob which allows the
> user to adjust the aggressiveness of page collapsing.
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

I guess this is the quota goal?  What is the unit?  I guess it is aparently not
percentage?  The name doesn't sound like very consistent or intuitive.  How
about hugepage_mem_bp or target_hugepage_mem_bp?

> # echo $(pidof mariadbd) > taget_pid
> # echo on > enabled
> 
> The goal was to achieve 5% of the total memory used as hugepage.

I guess this is what the above example is setting using
'quotta_percentage_hugepage'?  If so, it means the unit is 1/20000 ?  Is this
correct...?

> Since the database was not very big, we may not be able to achieve
> high amount of huge pages per total memory consumption ratio.

I believe this patch series will work as you explained.  But, it seems bit
weird to show a test result that doesn't demonstrate what this patch is aimed
to achive.  Could you increase the size of the database?  IIRC, you were able
to show the percentage is over-achived case in an early version.

> 
> The table below shows the memory consumption over time. Timestamp is in
> second and the memory usage in is MBytes. Gaps in the timestamp means
> that no changes in the hugepage consumption happened over that period
> of time in MB. The total used memory is calculated as
> mem_total - mem free. The huge page used is calculated as
> huge_page_anon + huge_page_shmem + huge_page_file. The table also
> shows the huge pages to total memory ratio.
> 
> Hugepage autotune benchmark:
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
> After second 275, no more pages are collapsed into hugepages
> 
> 
> THP (always) benchmark:
> +-----------+----------------+----------------+---------------------+
> | timestamp | total mem used | huge page used | percentage hugepage |
> +-----------+----------------+----------------+---------------------+
> |         1 |    4489.320313 |            184 |         4.098615986 |
> |        15 |    4581.871094 |            214 |         4.670580984 |
> |        30 |    4757.742188 |            376 |         7.902908253 |
> |        45 |    4937.574219 |            558 |         11.30109595 |
> |        60 |    5147.867188 |            728 |         14.14177898 |
> |        75 |      5407.0625 |            918 |         16.97779524 |
> |        95 |    5668.796875 |           1040 |         18.34604455 |
> |       105 |    5723.839844 |           1056 |         18.44915352 |
> |       115 |     5736.84375 |           1072 |         18.68623317 |
> |       125 |    5732.042969 |           1088 |         18.98101612 |
> |       186 |    5753.601563 |           1184 |         20.57841488 |
> |       246 |    5746.398438 |           1280 |         22.27482159 |
> |       306 |    5752.128906 |           1376 |         23.92157795 |
> |       367 |      5772.5625 |           1472 |         25.49994045 |
> |       427 |    5832.019531 |           1568 |         26.88605536 |
> |       488 |    5813.246094 |           1664 |         28.62428277 |
> |       548 |    5807.621094 |           1760 |         30.30500736 |
> |       598 |    5841.253906 |           1822 |         31.19193292 |
> |       669 |    5982.160156 |           1854 |         30.99214918 |
> |       931 |    5946.605469 |           1868 |         31.41287933 |
> |       981 |    6020.207031 |           1896 |         31.49393352 |
> |       991 |    5988.445313 |           1910 |         31.89475566 |
> |      1011 |    5988.570313 |           1926 |         32.16126554 |
> |      1032 |    6016.039063 |           1936 |         32.18064211 |
> |      1575 |    6057.289063 |           1968 |         32.48978181 |
> |      1606 |    6026.167969 |           2000 |         33.18858702 |
> +-----------+----------------+----------------+---------------------+
> I ignored some points to make the table shorter. Anyway, the amount
> of memory consumption, total and huge pages, is a lot higher than
> with DAMON hugepage autotuning.

Could you further clarify why it is, and what this means?

> 
> 
> Performance:
> Baseline (no THP, module off) -> 18,162.45 transactions per second
> Hugepage autotune -> 18,211.82 transactions per second (+0.27% improvement)
> THP always -> 18,388.3 (+1.24%)
> THP madvise -> 18,179.25 (+0.09%)
> 
> Improvement is due to lower TLB misses

So this result says THP always is much better than the Hugepage autotune in
terms of the performance.  Maybe you want to claim Hugepage autotune is better
in terms of the memory efficiency?  Could you please clarify further?

> 
> Patches Sequence
> ================
> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> Patch 2 -> Module that demonstrates how to use
>            DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
> Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
> 
> Changes from previous versions
> ==============================
> RFC 4[3] -> v1
>   - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and
>     functions to damon_sample_hpage_...
>   - Make the module depend on TRANSPARENT_HUGEPAGE, since
>     the module will need some THP functions anyway
>   - Removed documentation, since this is just a sample module
>   - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from
>     damos_sysfs_add_quota_score
>   - Added a short description of the module in Kconfig

Thank you for continuing this work!

[...]

> [1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
> [2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
> [3] https://lore.kernel.org/20260611150244.3454699-1-gutierrez.asier@huawei-partners.com
> [4] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
> [5] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
> [6] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
> [7] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
> [8] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
> [9] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/

[1] https://lore.kernel.org/9f9e2159-5a6b-496f-9633-fa06c0217948@huawei-partners.com


Thanks,
SJ

[...]

