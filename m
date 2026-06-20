Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC49CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 20:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16FB6B008A; Sat, 20 Jun 2026 16:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEF66B008C; Sat, 20 Jun 2026 16:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D066B0092; Sat, 20 Jun 2026 16:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 691976B008A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 16:03:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F06531C4957
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 20:03:05 +0000 (UTC)
X-FDA: 84901364730.26.ED31141
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 623C68000F
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 20:03:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hgh3Z7pj;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781985784;
	b=3MFsXxc7nPBX8ZadM1isj3wU2iKmGVx7n5e8qaddAyatCosTyKl9KEi34bB6Ya/OUA2E/l
	qDyG9HvqD6CJfdCme+QJf9/MVYfab4noNi2m4cN7yZVdPiV8/LCCVl53JP96hMcHUbbX2d
	IJFsylAVbzkbzykMcGgQKy/n78wayGc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hgh3Z7pj;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781985784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V/nAeifB5VEq/rPpwRtE8xn5fnyyOaKygkoYbZu20k=;
	b=nhvA1yBiG0qJ3yswAQkrm3V2Gyz9Ikd10ihML84+LHy+UW1XtbHA3MciuLzr0vYmWsemkS
	4KpPpJdrLNHA5VwbB8rpOMkikmjrl6KqPSe9imGb2ojbg2Q4mfm5vC7ORehdXTNqy5KpT6
	nhwnisQ/vhfo6j7sF6UpuduXiJJ4fcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1C09601EF;
	Sat, 20 Jun 2026 20:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6138D1F00A3D;
	Sat, 20 Jun 2026 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781985783;
	bh=+V/nAeifB5VEq/rPpwRtE8xn5fnyyOaKygkoYbZu20k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hgh3Z7pjw+UqlX/kTDLsD6kuW2iTXPImdkFUslNcitwLzbGesmdX5UYIei048SYoh
	 hsOcQ+TGZDUm77p4OOH9NlUufOvK73nOeWPg7MYtpkmz2jQhadUHncUVzaIvjEWVXV
	 jfHCQzsI2X3082DjjcFsuHHNhJ1gbtKsDs1JBAlsxVqB+jmn9omBly8Z/HveO6QjNJ
	 2yVQ8amfLAiYwlm2qfQJO7Gmrfxt6j/kdlMTOOGAT0L4OyYbYj2td2yEiiAEETwklO
	 9Czcr9uGdsiWg2R+2sCEna9pEeJiu8BaCy/X4OVaWUnoDUpjzLgFi+GWzr3DZp4b55
	 zTS2mZNCuTnaw==
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
Subject: Re: [PATCH v1 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Sat, 20 Jun 2026 13:02:54 -0700
Message-ID: <20260620200254.82414-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <665a31f2-2a42-4caf-be62-8429dc225f42@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 623C68000F
X-Stat-Signature: bkyo8upj7o5ei8mbgdny1jjxgxdsrkrh
X-HE-Tag: 1781985784-62283
X-HE-Meta: U2FsdGVkX19wROSAoOzvU4+qOyB06E1QOmczil78AvT+I3WyLJh8md5125Tbu0znFOmbg9v7B3zQwEI5oABMLjVkuL7141Yi1Cun5JtVuaNCoUeVMETMI/rAvx3FNuOcoUwYEL0Xj8PDzScFiPLjivRfM6XwknxvzigWczS79gibLo/eclC5ZpllL8WcTohLNn+CPEunzWYoNjP9ypZCfmZ3/4XcGrBzE+Ts7q/efT8iANCBCWmKH2u+QoqzHsN5/olQouKtiSchABThNQHSF2Cv5HAeLoSJFaz+nRdZMc+iBfIVIs7v6FDhTQ4aZJRxWTr8SNXT6hkgKalGTVhF0uLmhpTQCYUqhQtAICABE5/RVEvw/cMkmBS1CKrM1+DbrUfpsCXhHrxY9tUW2vpg0oL2Pg0WMWBNfOfvHlgGd8P9346qK7ERurdmSYmDTcJgpOOZ16WHjiFT1OS2wcaoXQpomBHkJMKoIR9YjBCRZsVPKnvkMyLdaLCPiDuB9SngAGC8THF/f3LYehed2267+9AabQiXM5Gk1sIGkQgwqE6mSgS5yqS22Tbf1F5eXoe6Dnh+UpHxMrasdPv0K1/9+C2vBgK0heXnQfjX3gbRtsMTzyz9vyGlz5f7Ecs2vU5F576bQWXHAWigx/XE+v3HnQlh3QDCT+rGTzryR12DHjQZb+vEvu09Z9lzkRRDLxeOPjzX+trdbhl+WYxVY72sLWRGjgyleKTp0wceFMWn8TWD9pSFb4vWVxawYa5mBQU6Lr4Y/feUjk4NOPf/VGwMzUIZG29meOu/oaf2a2AJCKuifxAd6Zu0f6Tz7fmj82RqEFbrqyL6UTNkzkFLYQB0YLFVB7PIRIlU9kkQDC4PpPf91ds+/9RwSIhbw6OyI7SRrnGktXSS66I5mvKwhF9WGWoVE7A0d87W1g+xlIYmZZ2zlBGG1IW/1HWZ/WN+O+9Brw5wbxuw2Xw9RfLKrmn
 F3mg5hUb
 RMintlugM3XPuBZmvr7MW1MkXKIXweNPzg6rgAXyUPcFDDxwDw/Vuiu24xLnspfoJWM0xcUt4dd3+qIn7sB8PTZ/TrSUruzS3ErVdyLMngKigO039+q5GdhD62bqrGdSGImbIiUi8Du2Yfyz4mOsvez/S+qeSH5o9F8bSliOtRyy8HFkbKVStZ80sLIVfCsk87dK9zBs8Sr720uaifKcbw3LBpbXvIUDogkTzRSUMhxVh1z/gToF+B7zMHXrkKd1RDxQa0m6SyDuff15b2kFrEarlhyL2+7jkjMh7p0MK6hZ8cugCOCJonJoHAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Jun 2026 20:11:46 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> So sorry, I missed your email. I just found it. Sorry for the late answer.
> 
> On 6/17/2026 4:44 AM, SeongJae Park wrote:
> > On Tue, 16 Jun 2026 15:03:13 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Overview
> >> ========
> >>
> >> This patch set introduces a new autotuning which allows to collapse
> >> hot regions into hugepages.
> >>
> >> Motivation
> >> ==========
> >>
> >> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
> >> misses (or hits) is to use huge pages. Unfortunately, using "always"
> >> in THP leads to memory fragmentation and memory waste. For this reason,
> >> most application guides and system administrators suggest to disable THP.
> >>
> >> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
> >> However, there is no way to tune the settings. It will collapse all the
> >> hot regions that meet the access pattern. If the server is a bare metal
> >> database or big data server, this will also lead to eventual fragmentation.
> >>
> >> Additionally, currently THP is set globally. Ideally, there should be a
> >> way to control which tasks can use huge pages.
> > 
> > Could you please reword for prctl(PR_SET_THP_DISABLE) like per-process control
> > cases, as we discussed [1] on RFC v3?
> > 
> >>
> >> Solution
> >> ========
> >>
> >> DAMON has now a way to autotune some of the variables and adjust quotas
> >> automatically, so that DAMON is fired only under the right circumstances.
> >> It would be nice to have something similar, but for huge pages.
> >>
> >> A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
> >> which checks the huge page consumption to total memory consumption. This
> >> new quota mechanism reuses current autotuning architecture.
> >>
> >> A new sample module (SAMPLE_DAMON_HPAGE) is introduced to demonstrate
> >> the use of huge pages collapse autotuning. The goal is to collapse hot
> >> regions of a given process into huge pages. The sample module launches
> >> a kdamond thread for a certain task provided by the user through
> >> taget_pid module argument. Hugepage goal autotuning will automatically
> >> adjust the aggressiveness of hot region collapses.
> >>
> >> This sample module also has a user autotuning knob which allows the
> >> user to adjust the aggressiveness of page collapsing.
> >>
> >> Benchmarks
> >> ==========
> >>
> >> Huge page collapse autotuning was tested in a physicial machine with
> >> MariaDB 10.5.29 and sysbench as the benchmark framework.
> >>
> >> The hugepage module was set up in the following way:
> >>
> >> # echo 1000 > min_age
> >> # echo 1000 > quota_percentage_hugepage
> > 
> > I guess this is the quota goal?  What is the unit?  I guess it is aparently not
> > percentage?  The name doesn't sound like very consistent or intuitive.  How
> > about hugepage_mem_bp or target_hugepage_mem_bp?
> Right, we agreed to change the name. I will correct it.

Thank you.  Because we agreed to drop the module, this could simply be dropped?

> >> # echo $(pidof mariadbd) > taget_pid
> >> # echo on > enabled
> >>
> >> The goal was to achieve 5% of the total memory used as hugepage.
> > 
> > I guess this is what the above example is setting using
> > 'quotta_percentage_hugepage'?  If so, it means the unit is 1/20000 ?  Is this
> > correct...?
> I actually set it to 500. I will update the cover letter.

I think changes of this series is matured and very close to land.
Discrepancies in the cover letter and commit messages are my concern that
blocking this series.  Please keep everything up to date and in high quality,
from the next version.

> >> Since the database was not very big, we may not be able to achieve
> >> high amount of huge pages per total memory consumption ratio.
> > 
> > I believe this patch series will work as you explained.  But, it seems bit
> > weird to show a test result that doesn't demonstrate what this patch is aimed
> > to achive.  Could you increase the size of the database?  IIRC, you were able
> > to show the percentage is over-achived case in an early version.
> Actually, this is what I got using the TEMPORAL quota goals. With the regular
> quota goals, it actually over-achieves the goal.
> 
> Is this an actual bug in the TEMPORAL quota goal?

You mentioned "Since the database was not very big, we may not be able to ...".
Based on that, I was assuming you will be able to make the goal achieved, by
increasing the database size.  Now you are saying about the goal.

Do you mean the database size is not expected to contributed to this result?

Of course TEMPORAL goal might have bugs.  I find no clue from this datta,
though.  Do you have some evidences that make you suspect it?  If so, could you
please share?

> >>
> >> The table below shows the memory consumption over time. Timestamp is in
> >> second and the memory usage in is MBytes. Gaps in the timestamp means
> >> that no changes in the hugepage consumption happened over that period
> >> of time in MB. The total used memory is calculated as
> >> mem_total - mem free. The huge page used is calculated as
> >> huge_page_anon + huge_page_shmem + huge_page_file. The table also
> >> shows the huge pages to total memory ratio.
> >>
> >> Hugepage autotune benchmark:
> >> +-----------+----------------+----------------+----------------------+
> >> | timestamp | total mem used | huge page used | percentage hugepage  |
> >> +-----------+----------------+----------------+----------------------+
> >> | 0         | 3044.988281    | 0              | 0%                   |
> >> | 22        | 3160.207031    | 2              | 0.06%                |
> >> | 30        | 3250.90625     | 4              | 0.12%                |
> >> | 69        | 3781.238281    | 6              | 0.16%                |
> >> | 71        | 3822.226563    | 8              | 0.21%                |
> >> | 72        | 3846.578125    | 10             | 0.26%                |
> >> | 73        | 3852.402344    | 12             | 0.31%                |
> >> | 74        | 3868           | 14             | 0.36%                |
> >> | 75        | 3881.84375     | 104            | 2.68%                |
> >> | 275       | 4194.175781    | 106            | 2.52%                |
> >> +-----------+----------------+----------------+----------------------+
> >> After second 275, no more pages are collapsed into hugepages
> >>
> >>
> >> THP (always) benchmark:
> >> +-----------+----------------+----------------+---------------------+
> >> | timestamp | total mem used | huge page used | percentage hugepage |
> >> +-----------+----------------+----------------+---------------------+
> >> |         1 |    4489.320313 |            184 |         4.098615986 |
> >> |        15 |    4581.871094 |            214 |         4.670580984 |
> >> |        30 |    4757.742188 |            376 |         7.902908253 |
> >> |        45 |    4937.574219 |            558 |         11.30109595 |
> >> |        60 |    5147.867188 |            728 |         14.14177898 |
> >> |        75 |      5407.0625 |            918 |         16.97779524 |
> >> |        95 |    5668.796875 |           1040 |         18.34604455 |
> >> |       105 |    5723.839844 |           1056 |         18.44915352 |
> >> |       115 |     5736.84375 |           1072 |         18.68623317 |
> >> |       125 |    5732.042969 |           1088 |         18.98101612 |
> >> |       186 |    5753.601563 |           1184 |         20.57841488 |
> >> |       246 |    5746.398438 |           1280 |         22.27482159 |
> >> |       306 |    5752.128906 |           1376 |         23.92157795 |
> >> |       367 |      5772.5625 |           1472 |         25.49994045 |
> >> |       427 |    5832.019531 |           1568 |         26.88605536 |
> >> |       488 |    5813.246094 |           1664 |         28.62428277 |
> >> |       548 |    5807.621094 |           1760 |         30.30500736 |
> >> |       598 |    5841.253906 |           1822 |         31.19193292 |
> >> |       669 |    5982.160156 |           1854 |         30.99214918 |
> >> |       931 |    5946.605469 |           1868 |         31.41287933 |
> >> |       981 |    6020.207031 |           1896 |         31.49393352 |
> >> |       991 |    5988.445313 |           1910 |         31.89475566 |
> >> |      1011 |    5988.570313 |           1926 |         32.16126554 |
> >> |      1032 |    6016.039063 |           1936 |         32.18064211 |
> >> |      1575 |    6057.289063 |           1968 |         32.48978181 |
> >> |      1606 |    6026.167969 |           2000 |         33.18858702 |
> >> +-----------+----------------+----------------+---------------------+
> >> I ignored some points to make the table shorter. Anyway, the amount
> >> of memory consumption, total and huge pages, is a lot higher than
> >> with DAMON hugepage autotuning.
> > 
> > Could you further clarify why it is, and what this means
> Memory fragmentation. I will add information about memory fragmentation
> in the next cover letter. >>

Yes, please.  Let's make the complete story of the benchmark.

> >>
> >> Performance:
> >> Baseline (no THP, module off) -> 18,162.45 transactions per second
> >> Hugepage autotune -> 18,211.82 transactions per second (+0.27% improvement)
> >> THP always -> 18,388.3 (+1.24%)
> >> THP madvise -> 18,179.25 (+0.09%)
> >>
> >> Improvement is due to lower TLB misses
> > 
> > So this result says THP always is much better than the Hugepage autotune in
> > terms of the performance.  Maybe you want to claim Hugepage autotune is better
> > in terms of the memory efficiency?  Could you please clarify further?
> It's better than THP "never", but worse than THP "always". THP "always" is worse
> in terms of memory consumption, "always" is worse.

I think it is arguable, but yes, please make the argument clear.  We can
discuss only after that.

Since we agreed to drop the module, you may need to do the benchmark again,
using DAMON sysfs interface of 'damo'.  I'd encourage 'damo' path.  Extending
it for ddamos_quota_hugepage_mem_bp should be easy.  Let me know if you need my
help.

Because the change is simple, I wouldn't request you to show clear performance
benefit.  But I want it to clearly show the functionality.  That is, by
applying the new feature, we should be able to show the hugepage memory ratio
is controllable.

> >>
> >> Patches Sequence
> >> ================
> >> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> >> Patch 2 -> Module that demonstrates how to use
> >>            DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
> >> Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
> >>
> >> Changes from previous versions
> >> ==============================
> >> RFC 4[3] -> v1
> >>   - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and
> >>     functions to damon_sample_hpage_...
> >>   - Make the module depend on TRANSPARENT_HUGEPAGE, since
> >>     the module will need some THP functions anyway
> >>   - Removed documentation, since this is just a sample module
> >>   - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from
> >>     damos_sysfs_add_quota_score
> >>   - Added a short description of the module in Kconfig
> > 
> > Thank you for continuing this work!
> > 
> > [...]
> > 
> >> [1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
> >> [2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
> >> [3] https://lore.kernel.org/20260611150244.3454699-1-gutierrez.asier@huawei-partners.com
> >> [4] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
> >> [5] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
> >> [6] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
> >> [7] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
> >> [8] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
> >> [9] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/
> > 
> > [1] https://lore.kernel.org/9f9e2159-5a6b-496f-9633-fa06c0217948@huawei-partners.com
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> 
> SJ, once again, sorry for the late answer. Please, disregard my new patch set, I will fix
> it with your feedback.

No worries.  Thank you for your grateful continued work on this.


Thanks,
SJ

[...]

