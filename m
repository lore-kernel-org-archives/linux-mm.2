Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E8FCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76ED6B0005; Fri, 12 Jun 2026 15:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDAD16B0088; Fri, 12 Jun 2026 15:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA466B008C; Fri, 12 Jun 2026 15:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7E2C6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:36:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3810E40235
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:36:20 +0000 (UTC)
X-FDA: 84872266920.19.F5ADF39
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 219951C000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:36:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781292977;
	b=YmHfIJnIl/3qMlzSclgfidactJuZECgvHi7hYAc6XRh+SGlrzB9f9wsiumDM6XWR3UAwXi
	mJiH2lxUlYIBn7I6GgZiVuJ/+fDkex70Yd7fwu5BqeypynHoF2d0wZDciiZQQER/SI8BlU
	orZS1PNIY2t462RiGkB2unLZ2NxYvNA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf21.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781292977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+F2Gklg2ZRHy8aUk5HYnw2ytH0vlpfWGRE0mbWgRvyY=;
	b=7YVXnaZXDQdc52euOHNlLlK6u6HsPQFL3icvm3fuPl0i8DGAXtf6ITdHFgtd7jjaDAmNqJ
	FzlO7pNCtFzmm0EkslzrgCt3Ij/jv8BLB6wTf4uxwwB9sCVGybGMhUdxK52qLwyt04Klnr
	sOJKR7T/5NQ5nybD4x8UoivfFGG4eTA=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gcV9l70Z2zJ4678;
	Sat, 13 Jun 2026 03:35:55 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 31BFB40570;
	Sat, 13 Jun 2026 03:36:13 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Jun 2026 22:36:12 +0300
Message-ID: <abc8acca-5145-4c16-aeb7-4127da234a62@huawei-partners.com>
Date: Fri, 12 Jun 2026 22:36:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/4] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260612005631.83964-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260612005631.83964-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 219951C000F
X-Stat-Signature: g6g9g8igsx79g4cu53oo7xm7b18xswi5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781292976-583380
X-HE-Meta: U2FsdGVkX1/eaoFPBYyPn9aoGVHB0A0PDdx05G0c6DhCHEXmUiF68/1a0t/suqUUFe5V8Po3RjHaL2VHWasvvyhnr5fjLj8kGLtfHZglpvCty0XGJIdlLZMHD4sc24DFng4sWM3Lrcd64B2bYvS2yCqBkhuGiWEMNhLnecc9EiUbgBYtibtJ2w0QfBfLwzYXBDJVng8KrbahpVkocteGhdYKoT9xLPwQgusDxpOoB/G68W4/dMP8w2dUyTliMX+NOOweaUsJ0mOXvnghD1xszs3FPr3nbrn3zNU93X1Ql43CwTn8VgGljKmykajbG2P9zl57GD3eWMaaqY1hdEalGQZY+8tBmpdsdEl4iBCkAcsPO34PQGWCoTyxYNxDUdt10uVyjbA7gri1LTwG0IvP3AQtmS0JidbtrUF0hCONIbu16Rkd1mYhCjhq71jFO4uaNZJb1xu1j45x24dmZ1JAg+phTIENJvGm/TOqZSXJkNdkgsBAQ4umzHA2f7Ijsce9tYRIhpqfaTBVZFJhbDq9pTXjIPrCmpNVwWp24Ake2Jdhgm37CUfFJEZDvW2+dxoXCUwqZQ7pd2ie8z2efbsM9KJ7LuGpzfO2m65fBt1KyyBv6JTNBFKPMN9Kb4fBiETZ99NbMm8gqRbenAY7sXGOqRMETg5+lYltCzSiv9rApeNMbbgL/PONB2YeplgHsfnk3R5Wr3tZwh3p/Vek3QFksokKFtVFIet3ee0NYIxLWFzaxxLDBd2Pj8QOIQbcGRiozqBIXwehHd+dBflHWJ8Czj/U8WaL0yK/Uj2E5aS5lrfiyssEbXo/kGHAZTJIdT5LUiRkcIKPlXJyF3w6GV74vf8xmfViaxb3Jd0YRc/lpZ+bYEHRifjM8mdNNctVOAR76W7O0UR3DvZrVM9u4tkXrGFD280B6t+0zX+dL/ow+dcotresYq2jfsoPCMotisrz40JRrlWHBxIJ+kECzLc
 hDscEo42
 WIV4xkjawwyOfSnAJ9jewM8MG8W7tEASxUzLRt0zxzWEACbP18NU+doZSEPPmr+P7E+sBhZOaLcAc/vCrCvM8XpSw20hSWvtiYTd7Nvn4h6XojBLzbX1puRTm+APnY4XYkFDZbnDVgg1OEUfGAcBYzT2ALSKR6WFWx5cI5Y9e6pn/n1Wzj+FS7+UxDSLCupxVU00jK6Y+AChZ9p61DJuvvfeaX96QUKYiL6xIrunv7LCfq5ZlyfkLLl0LnHn+O6aPuk2uDbbnpakzQol8KOn/D26jkkf8XxF2dKRo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 6/12/2026 3:56 AM, SeongJae Park wrote:
> Hello Asier,
> 
> On Thu, 11 Jun 2026 15:02:40 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Overview
>> ========
>>
>> This patch set introduces a new autotuning which allows to collapse
>> hot regions into hugepages.
>>
>> Motivation
>> ==========
>>
>> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
>> misses (or hits) is to use huge pages. Unfortunately, using "always"
>> in THP leads to memory fragmentation and memory waste. For this reason,
>> most application guides and system administrators suggest to disable THP.
>>
>> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
>> However, there is no way to tune the settings. It will collapse all the
>> hot regions that meet the access pattern. If the server is a bare metal
>> database or big data server, this will also lead to eventual fragmentation.
>>
>> Additionally, currently THP is set globally. Ideally, there should be a
>> way to control which tasks can use huge pages.
>>
>> Solution
>> ========
>>
>> DAMON has now a way to autotune some of the variables and adjust quotas
>> automatically, so that DAMON is fired only under the right circumstances.
>> It would be nice to have something similar, but for huge pages.
>>
>> A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
>> which checks the huge page consumption to total memory consumption. This
>> new quota mechanism reuses current autotuning architecture.
>>
>> A new module is introduced to demonstrate the use of huge pages
>> collapse autotuning. The goal is to collapse hot regions of a given
>> process into huge pages. The module launches a kdamond thread for a
>> certain task provided by the user through monitored_pid module argument.
>> Hugepage goal autotuning will automatically adjust the aggressiveness
>> of hot region collapses.
>>
>> This module also has a user autotuning knob which allows the user to
>> adjust the aggressiveness of page collapsing.
>>
>> Benchmarks
>> ==========
>>
>> Huge page collapse autotuning was tested in a physicial machine with
>> MariaDB 10.5.29 and sysbench as the benchmark framework.
>>
>> The hugepage module was set up in the following way:
>>
>> # echo 1000 > min_age
>> # echo 1000 > quota_percentage_hugepage
>> # echo $(pidof mariadbd) > monitored_pid
>> # echo on > enabled
>>
>> The goal was to achieve 5% of the total memory used as hugepage.
>> Since the database was not very big, we may not be able to achieve
>> high amount of huge pages per total memory consumption ratio.
>>
>> The table below shows the memory consumption over time. Gaps in the
>> timestamp means that no changes in the hugepage consumption happened
>> over that period of time in MB.
>>
>> +-----------+----------------+----------------+----------------------+
>> | timestamp | total mem used | huge page used | percentage hugepage  |
>> +-----------+----------------+----------------+----------------------+
>> | 0         | 3044.988281    | 0              | 0%                   |
>> | 22        | 3160.207031    | 2              | 0.06%                |
>> | 30        | 3250.90625     | 4              | 0.12%                |
>> | 69        | 3781.238281    | 6              | 0.16%                |
>> | 71        | 3822.226563    | 8              | 0.21%                |
>> | 72        | 3846.578125    | 10             | 0.26%                |
>> | 73        | 3852.402344    | 12             | 0.31%                |
>> | 74        | 3868           | 14             | 0.36%                |
>> | 75        | 3881.84375     | 104            | 2.68%                |
>> | 275       | 4194.175781    | 106            | 2.52%                |
>> +-----------+----------------+----------------+----------------------+
>>
>> After second 275, no more pages are collapsed into hugepages
>>
>> Performance:
>> Baseline -> 18,124.1 transactions per second
>> Hugepage autotune -> 18,163.64 transactions per second
>>
>> TODO
>> ====
>> - Support page splitting for cold hugepages.
>>
>> Patches Sequence
>> ================
>> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
>> Patch 2 -> Module that demonstrates how to use
>>            DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
>> Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
>> Patch 4 -> Documentation
>>
>> Changes from previous versions
>> ==============================
>> RFC 3[3] -> RFC 4
>>   - Simplified the module
>>   - Removed unnecessary parameters
>>   - Renamed DAMOS_QUOTA_HUGEPAGE_MEM_BP to unify the
>>     naming style
>>   - Switched to DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
>>   - Updated the documentation
>>   - Removed new interface for context creation with
>>     DAMON_OPS_VADDR
> 
> Thank you for keep revisioning this patch series!
> 
> I think now we are aligned on the overall direction of this series.  Let's add
> the new metrics with the sample module.  The sample module's overall shape and
> size looks reasonable to me.
> 
> So I think now is the time to start making this series be more seriously get
> ready for the landing.  I find some parts in commit messages and cover letter
> that not correctly updated for my feedbacks on last revision.  Particularly
> tests and future work parts,  and sample module name are not addressing my
> previous feedback.  I therefore skipping review of quite details in this
> revision instead of adding same comments again.  That could be ok for early
> stage RFC series, but let's move to the next stage.
> 
> From the next revision, could you please take more time on addressing all my
> previous comments and updating everythings including comments be consistent?
> If you have a reason to keep some of my previous comments not yet addressed for
> the next revision, it is toally fine but please clarify.
> 
> Also, I'm not sure if I asked this same question before, but ...  Could you
> please share your future plans for this specific series?  What change you want
> to further make before dropping RFC?
I will review once again all your comments.

Since we are aligned, I plan to drop the RFC tag for the next revision.

In the future, once this patch set lands in upstream, I plan to submit a new
patch set to add cold page split in the sample module, so that we can have a
full THP support.

Thanks a lot for your patience!

> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


