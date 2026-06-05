Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63FB7CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC306B0005; Fri,  5 Jun 2026 06:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765EA6B0088; Fri,  5 Jun 2026 06:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D7B6B008A; Fri,  5 Jun 2026 06:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE9D6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:26:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF663164476
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:26:04 +0000 (UTC)
X-FDA: 84845478648.10.1646F51
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1174610000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:26:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780655162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ciQ2oDQLw0MbG7A9kcyJ+1XOsuZ2rw2D3whGS867BJU=;
	b=VDJtzyUticiV5KdZ1Vfriv2alU83rLeB+uk3Od/KyjpHWc5Uqg80shK0GVKpVakM2xmcRr
	h9VlDWeX5P6djGc182fpErat5W73QYorNjNLo5hZlm5TWLbwdlj3rA5ZJ919tTBRv2imJm
	64CG8gakhB/fzJrpP07tzAxZ6pRk+EA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780655162;
	b=gaA5nHG1mUQmv0sbVT+GAEk26VQ2Y9rM6rmmd0Vi0GgKH+bCbuVxI/9RP2clBj3Ddv3oNO
	OZP/cOAf8U2BK7YaJ+AGBayXtOCvzJruSet870KFiOARDVlRe0FULykF2mSY9WGAHXogfm
	J7kqId/zRyte5/MbJu42mcLjV8mAEP8=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWyJJ0hzSzJ4692;
	Fri,  5 Jun 2026 18:25:52 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 21DA140571;
	Fri,  5 Jun 2026 18:25:57 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Jun 2026 13:25:56 +0300
Message-ID: <9f9e2159-5a6b-496f-9633-fa06c0217948@huawei-partners.com>
Date: Fri, 5 Jun 2026 13:25:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/4] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260605013406.83441-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260605013406.83441-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 1174610000E
X-Rspam-User: 
X-Stat-Signature: fihkiargjw9fkganusu9ds4bwasyreoy
X-Rspamd-Server: rspam09
X-HE-Tag: 1780655160-914711
X-HE-Meta: U2FsdGVkX18krWQHbceaDLm8Jb7r0GywuIagNbnZzkQ0HEaZ9VfLPwGtQQjO/RAx8QDBfvZAVa1D+/u7dDZuu7yayxk5KSj+rfkWDfQ3CPfMVHx2l/hGFGngXRPm286bngMYF5NC3oAI5iCJYBBhyLJrZmfyIferOv1F7Bx7ZFHCv7qjBPI1dO4i7sktKQM8dCZxnvXwCotgeWvxQn2SkrvERIUrN/YEcLWuabeHMIB8X1W7eJh7S/dexRAttltYD/Z74X/SU/+bmoepXwXjtkHhT4ZbsG9JGIfxcvo8JANlKKs20HQQmXDekyjsGkUbtDae90cW5OKtsIrivnoozl3b5OcRz+SRbCjNPwdK3pgpNZwtDYVtFGOArq4kNXxvHUkrAX2aKx19Hfzy7BtQf0koljiS6f8eszsxdm54D+oQc3SD8viSU/2MLmqCFAwCIv3WP3FCthi6k8BOTtQ63S/NlgClK3OoVH69LYvg/+6M+SUNBvlsKuAfvV9E93t5RCTxQsRLQ9lIFgYIzLKpMq0yyKiPvPLyzk9vn+scbeLv+rskycAubo6B8eWjhmcgqC/4Q8O2nYlEE2JytBo1fUYAk6lXwV+t8PpTmw+jUC9L2m1CaF5HbrM97r2+vW+l6jWHLEF9CyoSTo73j/qZujk7dixd7ADInsGe/rfgfDmjyCKE0nlLuYf4TJFTkh4iK3oAZhL6mGG58w/c/kxqpqdbF5xhUIoC0mjWuKKPbR7dL3Q3mmwiT69IMVX3jYXCkeV1/mUUlzBA/d1wB6MIfb5OjD0++IPmXeLHJoYv3Hi4YkCKFcrPFrjmi+ut6FS4fB7HnfwrPy/Lb0OjHXalEXba9ZlDw4Zh9Q4/JNbK616YHJadIhucovf5aUsYgecn28GbT9UCv6TwaF4gVYjOHxb5TZ91sOCf4lX5ILootJ35eeuUK3/7CrBwk0KKf86zUcQ5NcyoZR7YxoDcLuA
 DbvkaO1u
 fZgCsnEpaXzeJM1MhNLzuT3BJf0oLR/puYDayI6KjHm7pV5tkVWh3sPLuf2QI3p5xfEnQuya/2SdxMjrGzF4qFUqfVhGpw4Y3++WKQ9W5R+1G4C5aWXAo0W2wAucKWLEFdKybDFCJS3e3skmr5u5MiNNW/A2ktCuLjtWVcxJ0a6Lbb8HEls/faPhvCuiOiBTkkSTMQFA+ChM8oHqAYIGJ3UmPEDD0wbe9l8XGiIGiOC+x+LleFKw5TcYaHQijXYGoSPFccMwCcoBhM547GqpVItgb/QqNzl+ZnGC/1jym4XU00rNu+wyevmT3FIQs0c+gZLFaC7DpYOnhmfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 6/5/2026 4:34 AM, SeongJae Park wrote:
> Hello Asier,
> 
> 
> Thank you for revisioning this great patch!
> 
> On Thu, 4 Jun 2026 15:03:33 +0000 <gutierrez.asier@huawei-partners.com> wrote:
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
> 
> We can do process level control using prctl(PR_SET_THP_DISABLE) [1], isn't it?
> I think the last above sentence is better to be reworded or simply dropped.
Yes, although you will not disable it for all the processes except onein the system. I will reword it to make it more clear.
>>
>> Solution
>> ========
>>
>> DAMON has now a way to autotune some of the variables and adjust quotas
>> automatically, so that DAMON is fired only under the right circumstances.
>> It would be nice to have something similar, but for huge pages.
>>
>> A new autotuning quota goal[2], damos_get_used_hugepage_mem_bp, is
>> introduced, which checks the huge page consumption to total anonymous
> 
> In the previous revision I suggested to
> s/damos_get_used_hugepage_mem_bp/damos_hugepage_mem_bp/ and you agreed.  Seems
> it was forgotten?

Actually, I changed the code to damos_hugepage_mem_bp. I forgot to update
the cover letter. Will do it for the next RFC version.

>> memory consumption. This new quota mechanism reuses current autotuning
>> architecture.
>>
>> A new module is introduced to demonstrate the use of huge pages
> 
> Let's clarify it is a  sample module.  That is,
> s/A new module/A new sample module/ ?

Right, I will update the cover letter.

>> collapse autotuning. The goal is to collapse hot regions of a given
>> process into huge pages. The module launches a kdamond thread for a
>> certain task provided by the user through monitored_pid module argument.
> 
> Following other vaddr based sample modues' pattern, what about
> s/monitored_pid/target_pid/ ?
Makes sense. I will change it.
> 
> As I also commented on the third patch of this series, apparently it is not
> following the sample modules' pattern but that for non-sample modules.  Could
> you please rewrite in a more simple way?

OK, I will remove a lot of the module parameters. I'll use the prcl.c as
an example.

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
> 
> Any reason to set it 5% ?

The database was not particularly big. This means that I set the target
too high, it may never reach it. Not all the database is hot, actually.

I will make it more clear in the following cover letters

>>
>> The table below shows the memory consumption over time. Gaps in the
>> timestamp means that no changes in the hugepage consumption happened
>> over that period of time.
>>
>> +-----------+----------------+----------------+----------------------+
>> | timestamp | total mem used | huge page used | percentage hugepage  |
>> +-----------+----------------+----------------+----------------------+
>> | 0         | 4721188        | 0              | 0%                   |
>> | 28        | 4216848        | 4              | 0%                   |
>> | 37        | 4189912        | 38912          | 1%                   |
>> | 39        | 4195188        | 47104          | 1%                   |
>> | 55        | 4111612        | 51200          | 1%                   |
>> | 59        | 4137012        | 53248          | 1%                   |
>> | 60        | 4137052        | 55296          | 1%                   |
>> | 61        | 4156832        | 57344          | 1%                   |
>> | 62        | 4136920        | 59392          | 1%                   |
>> | 64        | 4109872        | 61440          | 1%                   |
>> | 65        | 4119108        | 63488          | 2%                   |
>> | 66        | 4145532        | 65536          | 2%                   |
>> | 67        | 4134544        | 67584          | 2%                   |
>> | 68        | 4158244        | 126976         | 3%                   |
>> | 69        | 4124276        | 204800         | 5%                   |
>> | 70        | 4100680        | 333824         | 8%                   |
>> | 71        | 4095540        | 462848         | 11%                  |
>> +-----------+----------------+----------------+----------------------+
> 
> What is the timestamp unit?  Second?
> 
> What is the mem used unit?  Byytes?  Kiloboytes?
> 
> I also remember you mentioned you will compare the numbers for more setups
> including module disabled case (baseline) and THP disabled case.  I think "THP
> disabled" case was my typo.  Maybe I wanted to say "THP enabled" case.
> 
> Is that still on your TODO list?
> 
> Given this series is adding relatively small change (assuming the sample module
> will be simplified), I wouldn't strictly request all such tests.  I'm just
> curious about your plan.
> 
>>
>> Performance:
>> Baseline -> 18,162.45 transactions per second
>> Hugepage autotune -> 18,211.82 transactions per second
> 
> So, 2.7% improvement!  I think it is not bad for this simple approach.
> 
> Could you further elaborate how the performance is measured?  From when the
> transactions per second measurement is started, and when it was stopped?  Are
> the numbers average?  Mean?  Or something else?
> 
>>
>>
>> Eventually, the amount of huge pages reached 20%. This is consistent
>> with how quota goals autotuning work. We are more aggresive when the
>> quota is less than 10%, and less aggresive when the quota is higher.
>> At some point, the aggressiveness just fades and no more collapses
>> occur.
> 
> Could you share more hugepage utilization change for long term that captures it
> converges to 20% but after that doesn't increase more?

Correct.

> Also, have you tried temporal quota tuner?

OK, I will give it try.

>>
>> TODO
>> ====
>> - Support page splitting for cold hugepages.
> 
> This is a future work out of the scope of this series, right?  I think that is
> better to be clarified.  In the previous revision, I was reading this as a TODO
> for a future revision of this patch series.
> 
> Also, do you have specific changes you want to make to this series before it is
> merged, or dropping the RFC tag?
> 
>>
>> Patches Sequence
>> ================
>> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
>> Patch 2 -> damon_modules_new_vaddr_ctx_target
>> Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
>>            and the new VADDR ctx creation
>> Patch 4 -> Documentation
> 
> As I commented to each patch, patch 1 looks good except a few trivial things.
> Patch 2 seems unnecessary.  I hope patch 3 to be much simplified and wrote
> again following the sample modules' pattern.  Patch 4 seems too much for a
> sample module.
Thanks for the feedback, I will work out the patches.
>>
>> Changes from previous versions
>> ==============================
>> RFC 2[3] -> RFC 3
>>   - Module moved to samples
>>   - Change autotune to monitor total memory and hugepage
>>   - Added performnace benchmarks to the cover letter
>>   - Bail out gracefully when trying to start disable
>>     the module after the monitored task exited. This 
>>     issue was discovered by sashiko [4]
>>   - Fixed typos and added quota_sz to the documentation
>>     discovered by sashiko [5]
>> RFC 1[6] -> RFC 2
>>   - Rebased into mm-new
>>   - Use DAMOS_COLLAPSE instead of DAMOS_HUGEPAGE
>>   - Fixed an issue that returned silently an error when the PID
>>     didn't exist in the system.[7]
> 
> Thank you for continuing this great work, Asier.
> 
>>
>> [1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
>> [2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
>> [3] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
>> [4] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
>> [5] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
>> [6] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
>> [7] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


