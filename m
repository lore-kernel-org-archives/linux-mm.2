Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3E3C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9CC6B00C9; Mon,  6 Jul 2026 11:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AEA6B00CB; Mon,  6 Jul 2026 11:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869D26B00CD; Mon,  6 Jul 2026 11:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5734B6B00C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:16:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D763F120129
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:16:28 +0000 (UTC)
X-FDA: 84958703256.22.E066C8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2967140010
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:16:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwnXVctl;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783350987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lQm4M0/xWoS9LXFFnKTrtjlrWXtyC1CrkOk9oblE44=;
	b=IIYU8L0dQ9CPqDXFkOJPL+Igd/tygQ8CkQd89jTN3TgdfXGMPgvl0VTXBjxuN5YEh7LOGu
	imeNAO8wHdHc0XkbhlP+yASztLsng4vGlZeJupzbXxjcFe8dvjxGqKvQYrM1FRg6MA+xgo
	8Mr3J7UQrU2CAedqugn4Y4IbHYBNgPs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwnXVctl;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783350987;
	b=RWLYrzIipxCmYKxIMJhN+b5rLDvf7jz/5vBK+4aMRTdxdjpHFhDmxGz/1omPmw5h2uUzPU
	b9ZDIZ9/j1gCXKHYrKfu730KzeLwuXR0LJI/s1z8cPnBk0wiT/JupBcBLm+rthz5j9SLdu
	PYxG+rH95l87MFUjcz7zs5M7yIHR6Tk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00120413F3;
	Mon,  6 Jul 2026 15:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B0C1F000E9;
	Mon,  6 Jul 2026 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783350985;
	bh=6lQm4M0/xWoS9LXFFnKTrtjlrWXtyC1CrkOk9oblE44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwnXVctl+9mhXP3hLHDuVfd6tM88if14aZt2c7xbu6/zHfDuf7xNtw9hCPuonM6S2
	 dkjxhaAmpcpIhMlHHM7wILmW4Wgv94O2Y/hvFVRqpSkr7+pI9twagd2LRhzuIqJAtq
	 1RRLO0XI4M9gTpTXAS3PoInNlmTeA8/X9qb+rtNU4kaFEh1WDtPVb7LJYEGMqoVMwp
	 L7Wa977+ztcVJSouYstyyy/GKt2x3Tfuk67PE1nyErJMeVKulhq1mC/mJenMATgylL
	 OCwJu8kai9zG8NZ7K4NNqYFby9e+M31sVMSj6kcUC+xhfpW1YWFnb+0ZwZzMkHu5+J
	 VG40B7w8Aa/EQ==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
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
Date: Mon,  6 Jul 2026 08:16:17 -0700
Message-ID: <20260706151618.94372-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a13ae1ad-7dc9-4cf0-8dff-a1ef71454b7e@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: to4k5sxsphifwnx85h4w37imfofknyyg
X-Rspamd-Queue-Id: 2967140010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783350987-630170
X-HE-Meta: U2FsdGVkX18KxatECow7etOm7v4X749shCPrYmPxAAirFvTc0L1o3kgaHac8Qqzvr3mFgcYe9xxn0yI5HfTskKe7e+STBDjFOMRjSSiL71jX/mP2Jk9c35OiQZo1FyskdF1e90Yeae4FS4gUcf5OgUKBrWKqKCCetICvMh+UhEq+dJwxjHhn5QOdDZRlPQtQiwvFnkQvrbd5WSHXkwhckjIW29B77CzmuYaLoLCGOKCSNxpFPqqXmwybe5bLF1LGdzJK86Svn9dOmZqstN11CIe1IN/lF8g9/6OQx/29+4qrFx5SyRW4zfrp/YG7+nFW1SWbN92aFlcsmFZHKyg5+AlsESQzJ/rkqF6dIkM4pNYFIq5ip1dRBdLo1WOfvijKcaG5Epnd3t4STbzQKbODpn1f7u+UIyx1XFQ/4kzVAXMBByiWJ15Ej4esKlF5Hiv+EYWd7snw+LcJbyYZmg6teXJ8Tw+CWbxdZ+HivGmZ4ItkGY8Q7my+h4ocH9Qfpqw7RwNyUPNXU+qmBX/M5sA3G0dCfP4+puaKFOF2//zVDNxIuew5p7UKOqlkyfOpiEgTuiRwt4Fa+8bbYj98p1vuw175jdQ9FIv6w9nIJWK/nDYB2L+fOVLrgw2zp7Y12kJ0Yw58ulg2aXkIjFv/r14lyeSuKMU4qhiVdqnSPDl0sYx69OgXhbr+Y1piAIUHkUMqWRR60ke2dsCiqDy3vLvK/lzYSzOdMZbv4Tv5U/opibg9NnxsOlB1Cz+aFHl4R1vzX0AX2SABqjnjBR/Ufl9goimuPkZVW+7A1gX5pZi3cm2xILfbS+f/KnUgSajyrqGH3mM8xNXVX0dT+OqDR6wx2Lun5zAH1iE5JYcCwmJ/VZ7rydHYsEUOJLbDNgSHz90htwDyh0evZ8dA0KcADmX1tgodLUpNuBvMxJp7RjuG2Z3XcVj+JQWTAiGQ2dxLMcvg0Uj4vKHqT0rYGNDggIS
 lvbYD3q6
 H/gYvNLzoYFXl/8+FapHxo1scO3QMHTRxtlR/SVmI0SQ8AoVZcWgzDe+53sofYfvi5TYl+d/LgLOLsmFvJe0ShTy8YxSMq/NAvq29kQ6+p8os15wCyZPiBgAhmVEhSsvGwZ5NMqoY0ZEwK5S3r+39ukaJ/ARORFnRmIh2N9VU08txl/Gq3eki09fKL0SXVkYE5VKF8xpRqU62AUtYgHUZK8OzcjO8QuYP0OxCQ/2bkE9gnWIeFQixX0RXwBRRsv2gd4ggoJJAzFXC9XxMZ1NM2uiQ2sExViUc9PW+igmMeDZaEuyHvTkx9+XpKnuXePBmFMvF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 18:03:03 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 6/20/2026 8:11 PM, Gutierrez Asier wrote:
> > Hi SJ,
> > 
> > So sorry, I missed your email. I just found it. Sorry for the late answer.
> > 
> > On 6/17/2026 4:44 AM, SeongJae Park wrote:
> >> On Tue, 16 Jun 2026 15:03:13 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>
> >>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>
> >>> Overview
> >>> ========
> >>>
> >>> This patch set introduces a new autotuning which allows to collapse
> >>> hot regions into hugepages.
> >>>
> >>> Motivation
> >>> ==========
> >>>
> >>> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
> >>> misses (or hits) is to use huge pages. Unfortunately, using "always"
> >>> in THP leads to memory fragmentation and memory waste. For this reason,
> >>> most application guides and system administrators suggest to disable THP.
> >>>
> >>> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
> >>> However, there is no way to tune the settings. It will collapse all the
> >>> hot regions that meet the access pattern. If the server is a bare metal
> >>> database or big data server, this will also lead to eventual fragmentation.
> >>>
> >>> Additionally, currently THP is set globally. Ideally, there should be a
> >>> way to control which tasks can use huge pages.
> >>
> >> Could you please reword for prctl(PR_SET_THP_DISABLE) like per-process control
> >> cases, as we discussed [1] on RFC v3?
> >>
> >>>
> >>> Solution
> >>> ========
> >>>
> >>> DAMON has now a way to autotune some of the variables and adjust quotas
> >>> automatically, so that DAMON is fired only under the right circumstances.
> >>> It would be nice to have something similar, but for huge pages.
> >>>
> >>> A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
> >>> which checks the huge page consumption to total memory consumption. This
> >>> new quota mechanism reuses current autotuning architecture.
> >>>
> >>> A new sample module (SAMPLE_DAMON_HPAGE) is introduced to demonstrate
> >>> the use of huge pages collapse autotuning. The goal is to collapse hot
> >>> regions of a given process into huge pages. The sample module launches
> >>> a kdamond thread for a certain task provided by the user through
> >>> taget_pid module argument. Hugepage goal autotuning will automatically
> >>> adjust the aggressiveness of hot region collapses.
> >>>
> >>> This sample module also has a user autotuning knob which allows the
> >>> user to adjust the aggressiveness of page collapsing.
> >>>
> >>> Benchmarks
> >>> ==========
> >>>
> >>> Huge page collapse autotuning was tested in a physicial machine with
> >>> MariaDB 10.5.29 and sysbench as the benchmark framework.
> >>>
> >>> The hugepage module was set up in the following way:
> >>>
> >>> # echo 1000 > min_age
> >>> # echo 1000 > quota_percentage_hugepage
> >>
> >> I guess this is the quota goal?  What is the unit?  I guess it is aparently not
> >> percentage?  The name doesn't sound like very consistent or intuitive.  How
> >> about hugepage_mem_bp or target_hugepage_mem_bp?
> > Right, we agreed to change the name. I will correct it.
> >>> # echo $(pidof mariadbd) > taget_pid
> >>> # echo on > enabled
> >>>
> >>> The goal was to achieve 5% of the total memory used as hugepage.
> >>
> >> I guess this is what the above example is setting using
> >> 'quotta_percentage_hugepage'?  If so, it means the unit is 1/20000 ?  Is this
> >> correct...?
> > I actually set it to 500. I will update the cover letter.
> >>> Since the database was not very big, we may not be able to achieve
> >>> high amount of huge pages per total memory consumption ratio.
> >>
> >> I believe this patch series will work as you explained.  But, it seems bit
> >> weird to show a test result that doesn't demonstrate what this patch is aimed
> >> to achive.  Could you increase the size of the database?  IIRC, you were able
> >> to show the percentage is over-achived case in an early version.
> > Actually, this is what I got using the TEMPORAL quota goals. With the regular
> > quota goals, it actually over-achieves the goal.
> > 
> > Is this an actual bug in the TEMPORAL quota goal?
> >>>
> >>> The table below shows the memory consumption over time. Timestamp is in
> >>> second and the memory usage in is MBytes. Gaps in the timestamp means
> >>> that no changes in the hugepage consumption happened over that period
> >>> of time in MB. The total used memory is calculated as
> >>> mem_total - mem free. The huge page used is calculated as
> >>> huge_page_anon + huge_page_shmem + huge_page_file. The table also
> >>> shows the huge pages to total memory ratio.
> >>>
> >>> Hugepage autotune benchmark:
> >>> +-----------+----------------+----------------+----------------------+
> >>> | timestamp | total mem used | huge page used | percentage hugepage  |
> >>> +-----------+----------------+----------------+----------------------+
> >>> | 0         | 3044.988281    | 0              | 0%                   |
> >>> | 22        | 3160.207031    | 2              | 0.06%                |
> >>> | 30        | 3250.90625     | 4              | 0.12%                |
> >>> | 69        | 3781.238281    | 6              | 0.16%                |
> >>> | 71        | 3822.226563    | 8              | 0.21%                |
> >>> | 72        | 3846.578125    | 10             | 0.26%                |
> >>> | 73        | 3852.402344    | 12             | 0.31%                |
> >>> | 74        | 3868           | 14             | 0.36%                |
> >>> | 75        | 3881.84375     | 104            | 2.68%                |
> >>> | 275       | 4194.175781    | 106            | 2.52%                |
> >>> +-----------+----------------+----------------+----------------------+
> >>> After second 275, no more pages are collapsed into hugepages
> >>>
> >>>
> >>> THP (always) benchmark:
> >>> +-----------+----------------+----------------+---------------------+
> >>> | timestamp | total mem used | huge page used | percentage hugepage |
> >>> +-----------+----------------+----------------+---------------------+
> >>> |         1 |    4489.320313 |            184 |         4.098615986 |
> >>> |        15 |    4581.871094 |            214 |         4.670580984 |
> >>> |        30 |    4757.742188 |            376 |         7.902908253 |
> >>> |        45 |    4937.574219 |            558 |         11.30109595 |
> >>> |        60 |    5147.867188 |            728 |         14.14177898 |
> >>> |        75 |      5407.0625 |            918 |         16.97779524 |
> >>> |        95 |    5668.796875 |           1040 |         18.34604455 |
> >>> |       105 |    5723.839844 |           1056 |         18.44915352 |
> >>> |       115 |     5736.84375 |           1072 |         18.68623317 |
> >>> |       125 |    5732.042969 |           1088 |         18.98101612 |
> >>> |       186 |    5753.601563 |           1184 |         20.57841488 |
> >>> |       246 |    5746.398438 |           1280 |         22.27482159 |
> >>> |       306 |    5752.128906 |           1376 |         23.92157795 |
> >>> |       367 |      5772.5625 |           1472 |         25.49994045 |
> >>> |       427 |    5832.019531 |           1568 |         26.88605536 |
> >>> |       488 |    5813.246094 |           1664 |         28.62428277 |
> >>> |       548 |    5807.621094 |           1760 |         30.30500736 |
> >>> |       598 |    5841.253906 |           1822 |         31.19193292 |
> >>> |       669 |    5982.160156 |           1854 |         30.99214918 |
> >>> |       931 |    5946.605469 |           1868 |         31.41287933 |
> >>> |       981 |    6020.207031 |           1896 |         31.49393352 |
> >>> |       991 |    5988.445313 |           1910 |         31.89475566 |
> >>> |      1011 |    5988.570313 |           1926 |         32.16126554 |
> >>> |      1032 |    6016.039063 |           1936 |         32.18064211 |
> >>> |      1575 |    6057.289063 |           1968 |         32.48978181 |
> >>> |      1606 |    6026.167969 |           2000 |         33.18858702 |
> >>> +-----------+----------------+----------------+---------------------+
> >>> I ignored some points to make the table shorter. Anyway, the amount
> >>> of memory consumption, total and huge pages, is a lot higher than
> >>> with DAMON hugepage autotuning.
> >>
> >> Could you further clarify why it is, and what this means
> > Memory fragmentation. I will add information about memory fragmentation
> > in the next cover letter. >>
> >>>
> >>> Performance:
> >>> Baseline (no THP, module off) -> 18,162.45 transactions per second
> >>> Hugepage autotune -> 18,211.82 transactions per second (+0.27% improvement)
> >>> THP always -> 18,388.3 (+1.24%)
> >>> THP madvise -> 18,179.25 (+0.09%)
> >>>
> >>> Improvement is due to lower TLB misses
> >>
> >> So this result says THP always is much better than the Hugepage autotune in
> >> terms of the performance.  Maybe you want to claim Hugepage autotune is better
> >> in terms of the memory efficiency?  Could you please clarify further?
> > It's better than THP "never", but worse than THP "always". THP "always" is worse
> > in terms of memory consumption, "always" is worse.
> >>>
> >>> Patches Sequence
> >>> ================
> >>> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> >>> Patch 2 -> Module that demonstrates how to use
> >>>            DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
> >>> Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
> >>>
> >>> Changes from previous versions
> >>> ==============================
> >>> RFC 4[3] -> v1
> >>>   - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and
> >>>     functions to damon_sample_hpage_...
> >>>   - Make the module depend on TRANSPARENT_HUGEPAGE, since
> >>>     the module will need some THP functions anyway
> >>>   - Removed documentation, since this is just a sample module
> >>>   - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from
> >>>     damos_sysfs_add_quota_score
> >>>   - Added a short description of the module in Kconfig
> >>
> >> Thank you for continuing this work!
> >>
> >> [...]
> >>
> >>> [1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
> >>> [2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
> >>> [3] https://lore.kernel.org/20260611150244.3454699-1-gutierrez.asier@huawei-partners.com
> >>> [4] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
> >>> [5] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
> >>> [6] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
> >>> [7] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
> >>> [8] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
> >>> [9] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/
> >>
> >> [1] https://lore.kernel.org/9f9e2159-5a6b-496f-9633-fa06c0217948@huawei-partners.com
> >>
> >>
> >> Thanks,
> >> SJ
> >>
> >> [...]
> >>
> > 
> > SJ, once again, sorry for the late answer. Please, disregard my new patch set, I will fix
> > it with your feedback.
> > 
> 
> I didn't get a reply to this email.

I sent the reply [1] weeks ago.

> 
> I will update the cover letter and submit a new patch set soon.

No, please.  Let's fully complete the discussion before a new version.

[1] https://lore.kernel.org/20260620200254.82414-1-sj@kernel.org


Thanks,
SJ

[...]

