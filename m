Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05360C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9D26B00D7; Mon, 13 Jul 2026 12:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A866B00DA; Mon, 13 Jul 2026 12:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59916B00DB; Mon, 13 Jul 2026 12:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86A906B00D7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:23:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32FF7C1276
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:04:47 +0000 (UTC)
X-FDA: 84984075414.15.F464C75
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90CCD10000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:04:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=UqJBN4ay;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9Fqmkl6CbtPQxMQx8cGZjneYfYjBfmp4tGHW/CFDxM=;
	b=kYUw60gGSONL5xAo0kjo5YHcRkdMfct+JPazTHw8S/eUTNDYKxDRTE9HMuo0PYMXCH2NMa
	esB0FRsUF1s0OqvYR/4yxbB50dTEoD6E5tVwt4x0WO7oxF+nR2CbGfVcgxDjQaeiNW7XD8
	c8HSknoNDwtXTAQUBN+qU3f7SIekp64=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=UqJBN4ay;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955084;
	b=cjs2bcDitKhoo6Tvb9IBgON53eqWKWa35w5NsndR/cW4LTtH9yZcMMcJxgO69eVqcdJfmS
	rs66V9f0hpyzvXcQ4r37AICfpYyEZXda/XXRbqFu9s5E6HDW4n71gFS3+7yrEIU+cVZoZL
	bcZ7n484j+as9WAPTok6XpsFWL1AJ3o=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=g9Fqmkl6CbtPQxMQx8cGZjneYfYjBfmp4tGHW/CFDxM=;
	b=UqJBN4ayDf0ubAkxqJomhndX66B1Mwrkf5i2H04Zz9hkLo2tw50dVJ+KzCu0ADrKuH0oOWEJ4
	30r6lOx9o+kDUkGMB+03xP+Fnw6TJoH272kQRggKPexJR2uTBjCSnotQiiwKjnk8RyZhLRpLOoC
	LNogEDSEGOO4mAeZ7TbnWgg=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gzQhF1HxZzJ4688;
	Mon, 13 Jul 2026 23:04:29 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 45E7D40569;
	Mon, 13 Jul 2026 23:04:36 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Jul 2026 18:04:35 +0300
Message-ID: <6c871730-f6d7-4990-a836-1a734ccd2bd0@huawei-partners.com>
Date: Mon, 13 Jul 2026 18:04:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SJ Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260713144513.39596-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260713144513.39596-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90CCD10000C
X-Stat-Signature: 4ppb7njgk7qyzrk3dq6asihuxdijr8dm
X-HE-Tag: 1783955083-706701
X-HE-Meta: U2FsdGVkX182n9En9hHhxWsu41LN8dzkDXucenEaRw6pJBRmdapT2VGN7S9JaZuLs5xRcMDop85dRZIMVso7NHRtFf2r6AljWh1iQxeQoXlAmQqXPmNKlY/d3oZZHI0VODaxo+BoIFPyH+H+nKn1bh+yADUK3cXJ68+sD1ErdOwqWRwO9tCiLB5EgZGx8Qi7nJvdWHjcLDcG1HqXlMg68ZvA5NJUirxDyY3l+1oMlQe6Yem71QylxlulTuqKANRDJgNYJSO3HvnaZa+7jxBGmUNYH/qQ+TVwDPYsXiV1azfPRMCtao5WhtEZF46Ocajx5N8OvPEbM6ZjFDT+4Gg5HUsrewaLTvpyfTZjq+Or5P0I3gFbEItCsHAZMEPI8Zp4nQ9h8l4QEZEPvlbijlxlngXGN+GzyRDWyTbrMJsyTWVRrQPVUYFxOViv+4ThfJtmjenPTfX85B4DZv+QuyOLNxz41elsQhDlP2aC0ezEpyqlwzQcT9pbCpmgeAvjos4dneu364W42Scbj8DTapGgWSjbzOoHxNeaJ25HnUAbAo3coTGY8BvCkRhg5vXZl/rTTERpjrCiJG01/g0oeJEQF4lrWXlNuFwdDtVygCx1HmbIkHeHB5cBMcgFswI6+VSKDNTDugZRxEio51zKY3wQjYBJ9mD60N0in9gRlGSR8MzSaCUDU2MaUyR66CehXI5q+/Lpvp8rVGpItl1F6u5oTIiaWq4cNHNJNErH7x4tzhb7F4Pt2W6hFeM9i+ZPnNnyl1VysTdF85eWEQvEGIemi2mJgHqSdha8UzI/c18XScA9rWjVn03Rbu4DK2Fptgq7CX02NInw0lW/NkkO97B4xoyVE1TdP1x5zUg0JY3VeDBrECK+fNhKFeLkETQGD4zb8GDYlY2p5jyqnNGLxOuQl1YqRPIALV76loDVGGycDkLBJQ/Qvy9OuiST1bHc3AxPRL/ByakCJ/l/p0AN4bX
 FfVVjOXr
 ZauX841wWMRvloSC+MCV2jbPmaL+1/3qO4Yfc5PAXCXJJkOVy99ifiVP23qQFLyEjbfG3K/CWQbSG60mRqfesU7XsGaxG24BswupuKa5daPOVHYzaPpEA6hvMh/Zhys6iVxA9qXeJ38iD6qVC+4jolnwi9vsfO1G4HcEtUE9kJZVQSpJry4rFbuqXQ6nNh0JRoe1XT6mcGPOgnLLHhsplUEgUCITGAF3BVG16UIyew/ln6XPlR+CjXaihc7iZBzz92HTYE52xXcKu4Wx4St7v4EKiAx6KHABuqvlRMSo8ZUeleSKfS2jYk+sOZZVlfPRFdGkbJjpuheHxR7j+Fvu0nyRM12jCk9pagn5bqG2oMC4Njx4uvd6du5CueH/NNf0Z94HS6EhFn0iO/Dt0qGyrURc7Bl933Ig5LGfVxROzf9uXJ80jl8iklXaUpZ5L6pK/PtGY8EQPU7olR2iRV0YdCVcfRBvkKgZluLNv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/13/2026 5:45 PM, SJ Park wrote:
> On Mon, 13 Jul 2026 14:30:40 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> Hi SJ,
>>
>> On 7/6/2026 6:16 PM, SJ Park wrote:
>>> On Mon, 6 Jul 2026 18:03:03 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
>>>
>>>> Hi SJ,
>>>>
>>>> On 6/20/2026 8:11 PM, Gutierrez Asier wrote:
>>>>> Hi SJ,
>>>>>
>>>>> So sorry, I missed your email. I just found it. Sorry for the late answer.
>>>>>
>>>>> On 6/17/2026 4:44 AM, SeongJae Park wrote:
>>>>>> On Tue, 16 Jun 2026 15:03:13 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>>>>>
>>>>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>>>>>
>>>>>>> Overview
>>>>>>> ========
>>>>>>>
>>>>>>> This patch set introduces a new autotuning which allows to collapse
>>>>>>> hot regions into hugepages.
>>>>>>>
>>>>>>> Motivation
>>>>>>> ==========
>>>>>>>
>>>>>>> Since TLB is a bottleneck for many systems[1], a way to optimize TLB
>>>>>>> misses (or hits) is to use huge pages. Unfortunately, using "always"
>>>>>>> in THP leads to memory fragmentation and memory waste. For this reason,
>>>>>>> most application guides and system administrators suggest to disable THP.
>>>>>>>
>>>>>>> Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
>>>>>>> However, there is no way to tune the settings. It will collapse all the
>>>>>>> hot regions that meet the access pattern. If the server is a bare metal
>>>>>>> database or big data server, this will also lead to eventual fragmentation.
>>>>>>>
>>>>>>> Additionally, currently THP is set globally. Ideally, there should be a
>>>>>>> way to control which tasks can use huge pages.
>>>>>>
>>>>>> Could you please reword for prctl(PR_SET_THP_DISABLE) like per-process control
>>>>>> cases, as we discussed [1] on RFC v3?
>>>>>>
>>>>>>>
>>>>>>> Solution
>>>>>>> ========
>>>>>>>
>>>>>>> DAMON has now a way to autotune some of the variables and adjust quotas
>>>>>>> automatically, so that DAMON is fired only under the right circumstances.
>>>>>>> It would be nice to have something similar, but for huge pages.
>>>>>>>
>>>>>>> A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
>>>>>>> which checks the huge page consumption to total memory consumption. This
>>>>>>> new quota mechanism reuses current autotuning architecture.
>>>>>>>
>>>>>>> A new sample module (SAMPLE_DAMON_HPAGE) is introduced to demonstrate
>>>>>>> the use of huge pages collapse autotuning. The goal is to collapse hot
>>>>>>> regions of a given process into huge pages. The sample module launches
>>>>>>> a kdamond thread for a certain task provided by the user through
>>>>>>> taget_pid module argument. Hugepage goal autotuning will automatically
>>>>>>> adjust the aggressiveness of hot region collapses.
>>>>>>>
>>>>>>> This sample module also has a user autotuning knob which allows the
>>>>>>> user to adjust the aggressiveness of page collapsing.
>>>>>>>
>>>>>>> Benchmarks
>>>>>>> ==========
>>>>>>>
>>>>>>> Huge page collapse autotuning was tested in a physicial machine with
>>>>>>> MariaDB 10.5.29 and sysbench as the benchmark framework.
>>>>>>>
>>>>>>> The hugepage module was set up in the following way:
>>>>>>>
>>>>>>> # echo 1000 > min_age
>>>>>>> # echo 1000 > quota_percentage_hugepage
>>>>>>
>>>>>> I guess this is the quota goal?  What is the unit?  I guess it is aparently not
>>>>>> percentage?  The name doesn't sound like very consistent or intuitive.  How
>>>>>> about hugepage_mem_bp or target_hugepage_mem_bp?
>>>>> Right, we agreed to change the name. I will correct it.
>>>>>>> # echo $(pidof mariadbd) > taget_pid
>>>>>>> # echo on > enabled
>>>>>>>
>>>>>>> The goal was to achieve 5% of the total memory used as hugepage.
>>>>>>
>>>>>> I guess this is what the above example is setting using
>>>>>> 'quotta_percentage_hugepage'?  If so, it means the unit is 1/20000 ?  Is this
>>>>>> correct...?
>>>>> I actually set it to 500. I will update the cover letter.
>>>>>>> Since the database was not very big, we may not be able to achieve
>>>>>>> high amount of huge pages per total memory consumption ratio.
>>>>>>
>>>>>> I believe this patch series will work as you explained.  But, it seems bit
>>>>>> weird to show a test result that doesn't demonstrate what this patch is aimed
>>>>>> to achive.  Could you increase the size of the database?  IIRC, you were able
>>>>>> to show the percentage is over-achived case in an early version.
>>>>> Actually, this is what I got using the TEMPORAL quota goals. With the regular
>>>>> quota goals, it actually over-achieves the goal.
>>>>>
>>>>> Is this an actual bug in the TEMPORAL quota goal?
>>>>>>>
>>>>>>> The table below shows the memory consumption over time. Timestamp is in
>>>>>>> second and the memory usage in is MBytes. Gaps in the timestamp means
>>>>>>> that no changes in the hugepage consumption happened over that period
>>>>>>> of time in MB. The total used memory is calculated as
>>>>>>> mem_total - mem free. The huge page used is calculated as
>>>>>>> huge_page_anon + huge_page_shmem + huge_page_file. The table also
>>>>>>> shows the huge pages to total memory ratio.
>>>>>>>
>>>>>>> Hugepage autotune benchmark:
>>>>>>> +-----------+----------------+----------------+----------------------+
>>>>>>> | timestamp | total mem used | huge page used | percentage hugepage  |
>>>>>>> +-----------+----------------+----------------+----------------------+
>>>>>>> | 0         | 3044.988281    | 0              | 0%                   |
>>>>>>> | 22        | 3160.207031    | 2              | 0.06%                |
>>>>>>> | 30        | 3250.90625     | 4              | 0.12%                |
>>>>>>> | 69        | 3781.238281    | 6              | 0.16%                |
>>>>>>> | 71        | 3822.226563    | 8              | 0.21%                |
>>>>>>> | 72        | 3846.578125    | 10             | 0.26%                |
>>>>>>> | 73        | 3852.402344    | 12             | 0.31%                |
>>>>>>> | 74        | 3868           | 14             | 0.36%                |
>>>>>>> | 75        | 3881.84375     | 104            | 2.68%                |
>>>>>>> | 275       | 4194.175781    | 106            | 2.52%                |
>>>>>>> +-----------+----------------+----------------+----------------------+
>>>>>>> After second 275, no more pages are collapsed into hugepages
>>>>>>>
>>>>>>>
>>>>>>> THP (always) benchmark:
>>>>>>> +-----------+----------------+----------------+---------------------+
>>>>>>> | timestamp | total mem used | huge page used | percentage hugepage |
>>>>>>> +-----------+----------------+----------------+---------------------+
>>>>>>> |         1 |    4489.320313 |            184 |         4.098615986 |
>>>>>>> |        15 |    4581.871094 |            214 |         4.670580984 |
>>>>>>> |        30 |    4757.742188 |            376 |         7.902908253 |
>>>>>>> |        45 |    4937.574219 |            558 |         11.30109595 |
>>>>>>> |        60 |    5147.867188 |            728 |         14.14177898 |
>>>>>>> |        75 |      5407.0625 |            918 |         16.97779524 |
>>>>>>> |        95 |    5668.796875 |           1040 |         18.34604455 |
>>>>>>> |       105 |    5723.839844 |           1056 |         18.44915352 |
>>>>>>> |       115 |     5736.84375 |           1072 |         18.68623317 |
>>>>>>> |       125 |    5732.042969 |           1088 |         18.98101612 |
>>>>>>> |       186 |    5753.601563 |           1184 |         20.57841488 |
>>>>>>> |       246 |    5746.398438 |           1280 |         22.27482159 |
>>>>>>> |       306 |    5752.128906 |           1376 |         23.92157795 |
>>>>>>> |       367 |      5772.5625 |           1472 |         25.49994045 |
>>>>>>> |       427 |    5832.019531 |           1568 |         26.88605536 |
>>>>>>> |       488 |    5813.246094 |           1664 |         28.62428277 |
>>>>>>> |       548 |    5807.621094 |           1760 |         30.30500736 |
>>>>>>> |       598 |    5841.253906 |           1822 |         31.19193292 |
>>>>>>> |       669 |    5982.160156 |           1854 |         30.99214918 |
>>>>>>> |       931 |    5946.605469 |           1868 |         31.41287933 |
>>>>>>> |       981 |    6020.207031 |           1896 |         31.49393352 |
>>>>>>> |       991 |    5988.445313 |           1910 |         31.89475566 |
>>>>>>> |      1011 |    5988.570313 |           1926 |         32.16126554 |
>>>>>>> |      1032 |    6016.039063 |           1936 |         32.18064211 |
>>>>>>> |      1575 |    6057.289063 |           1968 |         32.48978181 |
>>>>>>> |      1606 |    6026.167969 |           2000 |         33.18858702 |
>>>>>>> +-----------+----------------+----------------+---------------------+
>>>>>>> I ignored some points to make the table shorter. Anyway, the amount
>>>>>>> of memory consumption, total and huge pages, is a lot higher than
>>>>>>> with DAMON hugepage autotuning.
>>>>>>
>>>>>> Could you further clarify why it is, and what this means
>>>>> Memory fragmentation. I will add information about memory fragmentation
>>>>> in the next cover letter. >>
>>>>>>>
>>>>>>> Performance:
>>>>>>> Baseline (no THP, module off) -> 18,162.45 transactions per second
>>>>>>> Hugepage autotune -> 18,211.82 transactions per second (+0.27% improvement)
>>>>>>> THP always -> 18,388.3 (+1.24%)
>>>>>>> THP madvise -> 18,179.25 (+0.09%)
>>>>>>>
>>>>>>> Improvement is due to lower TLB misses
>>>>>>
>>>>>> So this result says THP always is much better than the Hugepage autotune in
>>>>>> terms of the performance.  Maybe you want to claim Hugepage autotune is better
>>>>>> in terms of the memory efficiency?  Could you please clarify further?
>>>>> It's better than THP "never", but worse than THP "always". THP "always" is worse
>>>>> in terms of memory consumption, "always" is worse.
>>>>>>>
>>>>>>> Patches Sequence
>>>>>>> ================
>>>>>>> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
>>>>>>> Patch 2 -> Module that demonstrates how to use
>>>>>>>            DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
>>>>>>> Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
>>>>>>>
>>>>>>> Changes from previous versions
>>>>>>> ==============================
>>>>>>> RFC 4[3] -> v1
>>>>>>>   - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and
>>>>>>>     functions to damon_sample_hpage_...
>>>>>>>   - Make the module depend on TRANSPARENT_HUGEPAGE, since
>>>>>>>     the module will need some THP functions anyway
>>>>>>>   - Removed documentation, since this is just a sample module
>>>>>>>   - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from
>>>>>>>     damos_sysfs_add_quota_score
>>>>>>>   - Added a short description of the module in Kconfig
>>>>>>
>>>>>> Thank you for continuing this work!
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> [1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
>>>>>>> [2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
>>>>>>> [3] https://lore.kernel.org/20260611150244.3454699-1-gutierrez.asier@huawei-partners.com
>>>>>>> [4] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
>>>>>>> [5] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
>>>>>>> [6] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
>>>>>>> [7] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
>>>>>>> [8] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
>>>>>>> [9] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/
>>>>>>
>>>>>> [1] https://lore.kernel.org/9f9e2159-5a6b-496f-9633-fa06c0217948@huawei-partners.com
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> SJ
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>
>>>>> SJ, once again, sorry for the late answer. Please, disregard my new patch set, I will fix
>>>>> it with your feedback.
>>>>>
>>>>
>>>> I didn't get a reply to this email.
>>>
>>> I sent the reply [1] weeks ago.
>>>
>>>>
>>>> I will update the cover letter and submit a new patch set soon.
>>>
>>> No, please.  Let's fully complete the discussion before a new version.
>>>
>>> [1] https://lore.kernel.org/20260620200254.82414-1-sj@kernel.org
>>>
>>>
>>> Thanks,
>>> SJ
>>>
>>> [...]
>>
>> Hi SJ,
>>
>> So, I finally got some stable results which make sense now.
>>
>> Setup: physical server with arm64 processor with 4 NUMA nodes,
>> 1 TB RAM and running mariaDB 10.5.29. I use sysbench for the
>> benchmark, with 20 tables and 3 million rows per table. The database
>> was pinned to one of the nodes, and the benchmark framework to a
>> different node. No network traffic involved in the benchmark.
>>
>> I forked damo and added hugepage_mem_bp support[1].
>>
>> I launch DAMON using this command line:
> 
> This is very helpful at understanding the test setup.  Thank you for sharing!
> 
>>
>> sudo ./damo start $(pidof mariadbd) \
>> --monitoring_nr_regions_range 10 1000 \
>> --monitoring_intervals 5000 100000 60000000 \
>> --damos_quota_time 0 --damos_quota_space 128000000 \
>> --damos_quota_interval 1000 \
>> --damos_quota_weights 0 1 1 \
>> --damos_quota_goal hugepage_mem_bp <target> \
>> --damos_quota_goal_tuner temporal \
>> --damos_apply_interval 50000 \
> 
> So, 50 ms DAMOS apply interval?  Seems quite short to me.  No big deal, though.
> 
>> --damos_access_rate 0 max --damos_age 50 max \
>> --damos_action collapse --debug_damon
> 
> FYI, damo supports human friendly formats.  E.g.,
> 
>     --monitoring_intervals 5ms 100ms 60s \
>     --damos_quota_space 128MB --damos_quota_interval 1s \
>     --damos_apply_interval 50ms
> 
>>
>> <target> was 1000 to taget 10% hugepage to total memory ratio, or
>> 2500 to target 25%. Tuner was also tested with consistent and
>> temporal.
>>
>> Results
>> =======
>> After the last timestamp, there was no change in huge page use, and
>> the total huge page to memory consumption ratio barely moved.
>>
>> Timestamp is measured in seconds, and the memory consumption (total
>> and huge page) is in MB.
>>
>> hugepage_mem_bp: 1000
>> goal tuner: temporal
>>
>> +-----------+----------------+----------------+----------------------+
>> | timestamp | total mem used | huge page used | percentage hugepage  |
>> +-----------+----------------+----------------+----------------------+
>> | 0         | 16945.04297    | 0              | 0                    |
>> | 7         | 17008.69531    | 74             | 0.435071583          |
>> | 8         | 17036.40234    | 194            | 1.138738074          |
>> | 9         | 17017.01563    | 314            | 1.845211916          |
>> | 10        | 17029.67969    | 434            | 2.548491856          |
>> | 61        | 17111.30859    | 584            | 3.412947623          |
>> | 75        | 17068.51953    | 612            | 3.58554823           |
>> | 90        | 17098.84766    | 638            | 3.731245595          |
>> | 105       | 17076.32031    | 664            | 3.888425538          |
>> | 120       | 17071.05859    | 694            | 4.065360072          |
>> | 135       | 17088.94531    | 722            | 4.22495354           |
>> | 150       | 17101.42578    | 746            | 4.362209383          |
>> | 165       | 17097.33984    | 776            | 4.53871776           |
>> | 180       | 17133.88281    | 804            | 4.692456513          |
>> | 195       | 17099.12891    | 832            | 4.865744943          |
>> | 201       | 17103.5        | 852            | 4.981436548          |
>> | 202       | 17077.84375    | 862            | 5.047475622          |
>> | 203       | 17088.16406    | 916            | 5.360435426          |
>> | 204       | 17126.34766    | 1046           | 6.107548562          |
>> | 205       | 17093.84375    | 1176           | 6.879669764          |
>> | 206       | 17142.77734    | 1298           | 7.571701913          |
>> | 207       | 17129.86719    | 1428           | 8.336316822          |
>> | 208       | 17099.76953    | 1556           | 9.099537846          |
>> | 209       | 17149.17969    | 1686           | 9.831374041          |
>> | 210       | 17097.30859    | 1754           | 10.25892462          |
>> +-----------+----------------+----------------+----------------------+
> 
> I saw you added description of all results at the end.  But adding it for each
> result would be nicer for readers.  E.g., you could say,
> 
> "As expected, ~10 % huge page ratio is achieved."
> 
> Or, you could make tables shorter by cutting more lines, keeping the height ~10
> rows per table?
> 
>>
>> hugepage_mem_bp: 1000
>> goal tuner: consistent
>>
>> +-----------+----------------+----------------+----------------------+
>> | timestamp | total mem used | huge page used | percentage hugepage  |
>> +-----------+----------------+----------------+----------------------+
>> | 0         | 16955.24609    | 0              | 0                    |
>> | 34        | 17039.71875    | 106            | 0.622075995          |
>> | 35        | 17022.21875    | 224            | 1.315927161          |
>> | 36        | 17070.08594    | 344            | 2.015221255          |
>> | 37        | 17005.86719    | 464            | 2.728470091          |
>> | 38        | 17028.92188    | 542            | 3.182820404          |
>> | 78        | 17009.47656    | 554            | 3.257007927          |
>> | 79        | 17051.82031    | 572            | 3.354480575          |
>> | 90        | 17048.92188    | 596            | 3.495822225          |
>> | 105       | 17086.22656    | 624            | 3.652064414          |
>> | 120       | 17102.49609    | 654            | 3.824003212          |
>> | 135       | 17081.31641    | 680            | 3.980957813          |
>> | 150       | 17092.90625    | 706            | 4.130368409          |
>> | 165       | 17093.69531    | 736            | 4.305681051          |
>> | 180       | 17053.08984    | 764            | 4.480126517          |
>> | 195       | 17095.73047    | 788            | 4.609337995          |
>> | 210       | 17086.20703    | 818            | 4.787487349          |
>> | 225       | 17095.04297    | 846            | 4.948803004          |
>> | 226       | 17057.95703    | 848            | 4.971286998          |
>> | 227       | 17101.46484    | 858            | 5.017114077          |
>> | 228       | 17053.90625    | 896            | 5.253928261          |
>> | 229       | 17061.48047    | 1016           | 5.954934578          |
>> | 230       | 17097.48828    | 1136           | 6.644250789          |
>> | 231       | 17080.42188    | 1256           | 7.353448347          |
>> | 232       | 17118.92969    | 1376           | 8.037885692          |
>> | 233       | 17100.50391    | 1496           | 8.748280216          |
>> | 234       | 17110.80859    | 1616           | 9.444322816          |
>> | 235       | 17138.17188    | 1736           | 10.12943512          |
>> | 236       | 17060.17578    | 1856           | 10.87913761          |
>> | 237       | 17118.92578    | 1976           | 11.54278034          |
>> | 238       | 17119.28516    | 2096           | 12.24350188          |
>> | 239       | 17098.89063    | 2216           | 12.95990511          |
>> | 240       | 17135.44531    | 2334           | 13.62088908          |
>> | 241       | 17097.58594    | 2454           | 14.35290344          |
>> | 242       | 17134.69531    | 2574           | 15.02215215          |
>> | 243       | 17127.96094    | 2694           | 15.72866735          |
>> | 244       | 17097.53516    | 2812           | 16.44681514          |
>> | 245       | 17132.55078    | 2932           | 17.11362212          |
>> | 246       | 17117.95313    | 3052           | 17.82923448          |
>> | 247       | 17154.30469    | 3172           | 18.49098554          |
>> | 248       | 17145.55078    | 3292           | 19.20031641          |
>> | 249       | 17138.36719    | 3410           | 19.89687794          |
>> | 250       | 17163.12109    | 3532           | 20.57900763          |
>> +-----------+----------------+----------------+----------------------+
> 
> Seems the table bit long to me.  When you add this to the cover letter, I think
> you could further cut some rows.  Maybe showing the rows for ~2% jumps?  E.g.,
> 
> +-----------+----------------+----------------+----------------------+
> | timestamp | total mem used | huge page used | percentage hugepage  |
> +-----------+----------------+----------------+----------------------+
> | 0         | 16955.24609    | 0              | 0                    |
> | 36        | 17070.08594    | 344            | 2.015221255          |
> | 150       | 17092.90625    | 706            | 4.130368409          |
> | 230       | 17097.48828    | 1136           | 6.644250789          |
> | 232       | 17118.92969    | 1376           | 8.037885692          |
> | 235       | 17138.17188    | 1736           | 10.12943512          |
> | 238       | 17119.28516    | 2096           | 12.24350188          |
> | 241       | 17097.58594    | 2454           | 14.35290344          |
> | 244       | 17097.53516    | 2812           | 16.44681514          |
> | 247       | 17154.30469    | 3172           | 18.49098554          |
> | 250       | 17163.12109    | 3532           | 20.57900763          |
> +-----------+----------------+----------------+----------------------+
> 
>>
>> hugepage_mem_bp: 2500
>> goal tuner: temporal
>>
>> +-----------+----------------+----------------+----------------------+
>> | timestamp | total mem used | huge page used | percentage hugepage  |
>> +-----------+----------------+----------------+----------------------+
>> | 0         | 17010.31641    | 0              | 0                    |
>> | 9         | 17063.6875     | 50             | 0.2930199            |
>> | 10        | 17051.75781    | 170            | 0.996964664          |
>> | 11        | 17059.625      | 290            | 1.699920133          |
>> | 12        | 17053.72656    | 410            | 2.404166611          |
>> | 13        | 17082.44141    | 528            | 3.090893084          |
>> | 14        | 17097.22266    | 530            | 3.099918687          |
>> | 60        | 17133.85547    | 572            | 3.338419663          |
>> | 75        | 17149.26563    | 598            | 3.487029784          |
>> | 90        | 17192.07813    | 626            | 3.641211932          |
>> | 105       | 17196.34766    | 654            | 3.80313316           |
>> | 120       | 17221.44531    | 682            | 3.960178647          |
>> | 135       | 17225.36719    | 708            | 4.110217172          |
>> | 150       | 17220.15625    | 736            | 4.274061102          |
>> | 165       | 17223.66406    | 764            | 4.435757672          |
>> | 181       | 17199.76172    | 790            | 4.593086886          |
>> | 195       | 17139.11328    | 818            | 4.772708988          |
>> | 205       | 17185.85547    | 862            | 5.015752644          |
>> | 206       | 17228.63281    | 978            | 5.67659669           |
>> | 207       | 17194.80469    | 1094           | 6.362386895          |
>> | 208       | 17222.77734    | 1206           | 7.002354939          |
>> | 209       | 17177.09766    | 1320           | 7.68465096           |
>> | 210       | 17182.23828    | 1428           | 8.310907907          |
>> | 211       | 17196.77734    | 1542           | 8.966796332          |
>> | 212       | 17205.57031    | 1664           | 9.671286507          |
>> | 213       | 17227.39844    | 1784           | 10.35559726          |
>> | 214       | 17245.17969    | 1904           | 11.04076637          |
>> | 215       | 17240.45703    | 2024           | 11.73982799          |
>> | 216       | 17218.85156    | 2144           | 12.45146921          |
>> | 217       | 17183.63281    | 2264           | 13.17532809          |
>> | 218       | 17217.08984    | 2384           | 13.84670709          |
>> | 219       | 17176.72266    | 2504           | 14.57786826          |
>> | 220       | 17234.79688    | 2624           | 15.22501262          |
>> | 221       | 17221.20703    | 2744           | 15.93384247          |
>> | 222       | 17258.91016    | 2864           | 16.59432707          |
>> | 223       | 17248.64063    | 2984           | 17.29991403          |
>> | 224       | 17227.35156    | 3104           | 18.0178595           |
>> | 225       | 17194.83594    | 3224           | 18.74981542          |
>> | 226       | 17216.30078    | 3344           | 19.42345247          |
>> | 227       | 17205.71875    | 3464           | 20.13284101          |
>> | 228       | 17222.83594    | 3584           | 20.80958103          |
>> | 229       | 17232.32031    | 3704           | 21.49449368          |
>> | 230       | 17269.49219    | 3824           | 22.14309465          |
>> | 231       | 17247.55469    | 3944           | 22.86700968          |
>> | 232       | 17248.90234    | 4064           | 23.56091952          |
>> | 233       | 17229.21875    | 4184           | 24.28432804          |
>> | 234       | 17221.28125    | 4304           | 24.99233325          |
>> | 235       | 17229.37109    | 4424           | 25.67708349          |
>> +-----------+----------------+----------------+----------------------+
> 
> Again, table looks bit long to me.  In the final version of the cover letter,
> maybe we can show only ~3% jumps?  E.g.,
> 
> +-----------+----------------+----------------+----------------------+
> | timestamp | total mem used | huge page used | percentage hugepage  |
> +-----------+----------------+----------------+----------------------+
> | 0         | 17010.31641    | 0              | 0                    |
> | 13        | 17082.44141    | 528            | 3.090893084          |
> | 207       | 17194.80469    | 1094           | 6.362386895          |
> | 212       | 17205.57031    | 1664           | 9.671286507          |
> | 216       | 17218.85156    | 2144           | 12.45146921          |
> | 220       | 17234.79688    | 2624           | 15.22501262          |
> | 224       | 17227.35156    | 3104           | 18.0178595           |
> | 229       | 17232.32031    | 3704           | 21.49449368          |
> | 233       | 17229.21875    | 4184           | 24.28432804          |
> | 235       | 17229.37109    | 4424           | 25.67708349          |
> +-----------+----------------+----------------+----------------------+
> 
>>
>> hugepage_mem_bp: 1000
>> goal tuner: consist
>>
>> +-----------+----------------+----------------+----------------------+
>> | timestamp | total mem used | huge page used | percentage hugepage  |
>> +-----------+----------------+----------------+----------------------+
>> | 0         | 17125.85156    | 0              | 0                    |
>> | 38        | 17081.23438    | 76             | 0.444932716          |
>> | 39        | 17133.11719    | 196            | 1.143983304          |
>> | 40        | 17119.83984    | 316            | 1.84581166           |
>> | 41        | 17116.48438    | 436            | 2.547252055          |
>> | 60        | 17109.72656    | 554            | 3.237924335          |
>> | 75        | 17158.79297    | 600            | 3.496749457          |
>> | 90        | 17164.11328    | 628            | 3.65879664           |
>> | 105       | 17205          | 654            | 3.801220575          |
>> | 120       | 17176.01953    | 682            | 3.970652215          |
>> | 136       | 17172.19922    | 710            | 4.134589816          |
>> | 150       | 17154.96484    | 738            | 4.3019616            |
>> | 165       | 17190.66797    | 764            | 4.444271749          |
>> | 180       | 17177.66016    | 792            | 4.610639591          |
>> | 195       | 17202.01563    | 822            | 4.778509786          |
>> | 210       | 17160.23047    | 848            | 4.941658572          |
>> | 216       | 17147.09766    | 898            | 5.237037882          |
>> | 217       | 17180.72656    | 1018           | 5.925244176          |
>> | 218       | 17179.74609    | 1138           | 6.624079272          |
>> | 219       | 17151.43359    | 1258           | 7.334663853          |
>> | 220       | 17180.86719    | 1378           | 8.020549749          |
>> | 221       | 17201.65625    | 1498           | 8.708463756          |
>> | 222       | 17184.45703    | 1618           | 9.415485151          |
>> | 223       | 17174.21094    | 1718           | 10.00337079          |
>> | 224       | 17174.90234    | 1800           | 10.48040894          |
>> | 225       | 17204.64063    | 1874           | 10.89241002          |
>> | 226       | 17187.82031    | 1980           | 11.51978531          |
>> | 227       | 17145.08594    | 2100           | 12.24840755          |
>> | 228       | 17144.25781    | 2220           | 12.948942            |
>> | 229       | 17171.44141    | 2338           | 13.61563042          |
>> | 230       | 17175.02344    | 2458           | 14.31147974          |
>> | 231       | 17150.30469    | 2578           | 15.03180292          |
>> | 232       | 17148.73438    | 2698           | 15.73293948          |
>> | 233       | 17143.48438    | 2818           | 16.4377319           |
>> | 234       | 17167.57422    | 2938           | 17.11365836          |
>> | 235       | 17157.11328    | 3058           | 17.82351116          |
>> | 236       | 17151.45703    | 3178           | 18.52903805          |
>> | 237       | 17155.85938    | 3298           | 19.22375282          |
>> | 238       | 17188.00781    | 3418           | 19.88595791          |
>> | 239       | 17151.66406    | 3536           | 20.61607543          |
>> | 240       | 17137.38281    | 3656           | 21.33347921          |
>> | 241       | 17165.32422    | 3776           | 21.99783675          |
>> | 242       | 17158.48438    | 3896           | 22.70596817          |
>> | 243       | 17122.70313    | 4016           | 23.45424067          |
>> | 244       | 17151.28516    | 4136           | 24.114811            |
>> | 245       | 17188.16797    | 4256           | 24.76121951          |
>> | 246       | 17150.58984    | 4376           | 25.51515744          |
>> | 247       | 17178.125      | 4496           | 26.17282154          |
>> | 248       | 17130.97266    | 4616           | 26.94534684          |
>> | 249       | 17149.64063    | 4736           | 27.61573903          |
>> | 250       | 17175.5        | 4856           | 28.27283049          |
>> | 251       | 17141.30859    | 4978           | 29.04095666          |
>> | 252       | 17168.22266    | 5098           | 29.69439587          |
>> | 253       | 17158.42578    | 5218           | 30.41071522          |
>> | 254       | 17175.84375    | 5338           | 31.07853144          |
>> | 255       | 17173.60156    | 5458           | 31.78133591          |
>> | 256       | 17188.17188    | 5578           | 32.45254958          |
>> | 257       | 17217.83203    | 5698           | 33.09359732          |
>> | 258       | 17182.50781    | 5818           | 33.86001661          |
>> | 259       | 17194.44922    | 5936           | 34.52276909          |
>> | 260       | 17199.66406    | 6056           | 35.20999002          |
>> | 261       | 17188.90234    | 6176           | 35.93015933          |
>> | 262       | 17204.27344    | 6296           | 36.59555879          |
>> | 263       | 17202.03516    | 6416           | 37.29791238          |
>> | 264       | 17207.71484    | 6536           | 37.98296322          |
>> | 265       | 17224.46094    | 6656           | 38.64271877          |
>> | 266       | 17198.29297    | 6776           | 39.39925906          |
>> | 267       | 17200.13281    | 6896           | 40.09271367          |
>> | 268       | 17204.625      | 7014           | 40.76810741          |
>> | 269       | 17210.91406    | 7134           | 41.45044228          |
>> | 270       | 17203.98438    | 7254           | 42.16465118          |
>> | 271       | 17206.08203    | 7374           | 42.85693853          |
>> | 272       | 17210.62891    | 7494           | 43.54285971          |
>> | 273       | 17202.55859    | 7614           | 44.26085782          |
>> | 274       | 17223.07813    | 7734           | 44.90486511          |
>> | 275       | 17207.21875    | 7762           | 45.10897498          |
>> +-----------+----------------+----------------+----------------------+
> 
> Again, seems long for the final version of the cover letter?  We could show for
> ~5% jumps?
> 
> +-----------+----------------+----------------+----------------------+
> | timestamp | total mem used | huge page used | percentage hugepage  |
> +-----------+----------------+----------------+----------------------+
> | 0         | 17125.85156    | 0              | 0                    |
> | 216       | 17147.09766    | 898            | 5.237037882          |
> | 223       | 17174.21094    | 1718           | 10.00337079          |
> | 231       | 17150.30469    | 2578           | 15.03180292          |
> | 239       | 17151.66406    | 3536           | 20.61607543          |
> | 246       | 17150.58984    | 4376           | 25.51515744          |
> | 253       | 17158.42578    | 5218           | 30.41071522          |
> | 260       | 17199.66406    | 6056           | 35.20999002          |
> | 267       | 17200.13281    | 6896           | 40.09271367          |
> | 275       | 17207.21875    | 7762           | 45.10897498          |
> +-----------+----------------+----------------+----------------------+
> 
>>
>> From this, we can conclude that the huge page autotuner works fine, achieving
>> the target. When using consistent autotuner, it actually over-achieves the
>> target, which is expected, since quota esz_bp is not set to 0 to cap the
>> DAMOS policy.
>>
>> [1] https://github.com/asierHuawei/damo/commit/79ae1a4ab1c012a7161db85a000d14f08fa36736
>>
>> Let me know what you think.
> 
> Looks good!  Let's proceed to the next version of the patch series with this
> great test results!
Yes, I will make the tables shorter. I just wanted to show how the memory consumption
changes over time, but I guess I can refer to this email in the new cover letter.

> 
> Thanks,
> SJ
> 
> [...]

-- 
Asier Gutierrez
Huawei


