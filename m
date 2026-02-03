Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52DCE87821
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E7A6B0095; Tue,  3 Feb 2026 08:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC286B0096; Tue,  3 Feb 2026 08:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2946B0098; Tue,  3 Feb 2026 08:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2226B0095
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:03:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FCC41404AE
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:03:14 +0000 (UTC)
X-FDA: 84403161108.01.8005FFF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8AB75100016
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:03:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770123792; a=rsa-sha256;
	cv=none;
	b=5ZZKjSsocz/Nt7u+7ENzOZcqkcA34tGNx9YWd2MY9rJdydjOkEVbCOcFPC6J5GzN8SKx90
	NQlT4LB5IEAWoodDPocj8JocmZfZpTEjaGtnt607WKyDKnwqDuIQB9vkevkPiBzxQd49kd
	TYNJQBpTz+rYpdb6zyD0nLcP7qX6Tus=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770123792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vqS/+WKw9jqsghl5w3uhGAMhCNrkd1e92em90hJbskM=;
	b=IBbwD3SdGwFyDkTeG3OMTvaernUVase9Ump4jZlvcMH+L7GFwknBV3VQmR1KWakDOFqW80
	71mkT3ju/9DZEDLvmoamS7utUPHs1J0i8/72Kr6yiRw42m40OsQGejBN+wUOtDusAWXdYA
	6Pk9k/S/UHdiS+ryBRLaijpBA1SnNH4=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f53Y64lVFzJ46bg;
	Tue,  3 Feb 2026 21:02:18 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 11ECF40571;
	Tue,  3 Feb 2026 21:03:06 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Feb 2026 16:03:05 +0300
Message-ID: <56e9d735-d728-445d-9d5d-f044c9fe53b2@huawei-partners.com>
Date: Tue, 3 Feb 2026 16:03:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260203011020.67357-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260203011020.67357-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8AB75100016
X-Stat-Signature: ttze9jhucbrucsssokrj6bgmtz3we8a7
X-HE-Tag: 1770123791-296072
X-HE-Meta: U2FsdGVkX1/+asqDz4lXI6LepQen6xSTDV0xpGA58HS4LHKxVNmX8r4gEoNDXDidOM0PpQyrpZGdgDZInaHV7wp++xNhserQllXHzYOhHd8FYpMwWb3poiik3ICXliB9vNPJGsh6JRj5RKyqms2dpiI8rorzIX0IwBk0iMPGak377tpDX6IIVduXsCXqVNagbs1mtblFb9eA1BJj/x+By/XorctzCeagEPtXe7opRZv1uzbJv2d6/j9gHFZTD9JN3gVHLpFX9SvCyrQlWqdfA/Snw8d5j+U8Peqn8lbJTOqDoFW2t+142XdkbwhFgT3bN9sr15DULetjJqfLoHkc34e9drLGfjrAm0nMDm4bBHh05PwMHUkVEpO4EZs9DiG6ZKwAkVUPOusNer9KUTRtKgtPjnfFtjL+GEHMv4+UXeUaunAVEoaq23F/UUAe+bmb1F0kkVivw6FPVwxDCsIxpZ99eh/leBH3okTVWOC4KB46iGuiWP8kog8MKOTrTDkPYGd/XhIvxi8awaHa0y/SRajcIeTljSySxD8+smVLiKGcZEAcWd+5OGl6xOXoWBc8+CHhBUlhaBObgB9UHSB29H0Fut9zfJI9/nzVHkeRKiAyv1YivLxGaUxo60S/qqWdYzYG0DeoygHe39qh+uJ4Eu0aUN8DqHnARGDURrRitqjrZUi0M+eoDRO7fMGdDD0zMuN5Vp6KGriTRrON1DqPnfuRm3al1OtMwie5TpKUzc/G1N6IlQ5AS88roV6kojqvv7W7e97BaAG2Dwq9G5sucroNkA9f79ZEW9wuoxhKZtqZYFOQhdoCz8Rx1mS8LnBdO7yHNp2PW8VzgCNTAERy+yJ3A73mqC5OAXzhdshef/pR6PCb8b3rNOE2Unzavus4Q19NfOAtKIkJJiA2iq4DL57sDdYV4FteHuFfgwn9xhJ0TVzQRjZfUrbs89O5YuMUCtuT5vWSexWUz91G9VB
 +zQcSkTD
 4wDDoF1S5OO6D+g4LdBod+GxRnF/JPkQeOn6bcAKhaxFsqB+c+fNYbTRXTeouUpPef7pwy9vL5h38228KIqvYg6hEm0mn7VTECSErpsa5VILQrFZ3Bi/Emm0FIHcs8kl2q4wDjVurZJFgvi3/USEGyW5RQszEU+6fD0BVPAGUwzyWj40PCkeGZihGykEVv2EosyAEaDBDM0a7nhAxNNIlappdK1ygkSjPUtG8wsEHkgUaPKlojSHmNBpOThT2TEH8cfbdoPjy49QTqTVhOHmX7Y4dbE4AbgU29NFGZTEnpwU/72ejptJK4zpD3a6RdPFwkZWBRz8gv4vyOiNzPqqpaasm8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae!

On 2/3/2026 4:10 AM, SeongJae Park wrote:
> Hello Asier,
> 
> 
> Thank you for sharing this nice RFC patch series!
> 
> On Mon, 2 Feb 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Overview
>> ----------
>>
>> This patch set introduces a new dynamic mechanism for detecting hot applications
>> and hot regions in those applications.
>>
>> Motivation
>> -----------
>>
>> Currently DAMON requires the system administrator to provide information about
>> which application needs to be monitored and all the parameters. Ideally this
>> should be done automatically, with minimal intervention from the system
>> administrator.
>>
>>
>> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
>> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
>> fragmentation and memory waste. For this reason, most application guides and
>> system administrators suggest to disable THP.
>>
>> We would like to detect: 1. which applications are hot in the system and 2.
>> which memory regions are hot in order to collapse those regions.
>>
>>
>> Solution
>> -----------
>>
>>      ┌────────────┐           ┌────────────┐
>>      │Damon_module│           │Task_monitor│
>>      └──────┬─────┘           └──────┬─────┘
>>             │         start          │
>>             │───────────────────────>│
>>             │                        │
>>             │                        │────┐
>>             │                        │    │ calculate task load
>>             │                        │<───┘
>>             │                        │
>>             │                        │────┐
>>             │                        │    │ sort tasks
>>             │                        │<───┘
>>             │                        │
>>             │                        │────┐
>>             │                        │    │ start kdamond for top 3 tasks
>>             │                        │<───┘
>>      ┌──────┴─────┐           ┌──────┴─────┐
>>      │Damon_module│           │Task_monitor│
>>      └────────────┘           └────────────┘
>>
>>
>> We calculate the task load base on the sum of all the utime for all the threads
>> in a given task. Once we get total utime, we use the exponential load average
>> provided by calc_load. The tasks that become cold, the kdamond will be stopped
>> for them.
> 
> Sounds interesting, and this high level idea makes sense to me. :)
> 
> I'd like to further learn a few things.  Is there a reason to think the top 3
> tasks are enough number of tasks?  Also, what if a region was hot and
> successfully promoted to use huge pages, but later be cold?  Should we also
> have a DAMOS scheme for splitting such no-more-hot huge pages?

No specific reason. This was just for the RFC. We could move this to a parameter
somehow.

In case of a region turning cold, I haven't worked on it. In turning hot means
that we collapse the hot region, we should do the opposite (split) in case the
area turns cold. I haven't thought about it, but that a good catch. Thanks!

>>
>> In each kdamond, we start with a high min_access value. Our goal is to find the
>> "maximum" min_access value at which point the DAMON action is applied. In each
>> cycle, if no action is applied, we lower the min_access.
> 
> Sounds like a nice auto-tuning.  And we have DAMOS quota goal for that kind of
> auto-tuning.  Have you considered using that?
> 
>>
>> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
>> collapse synchronously and avoid polluting khugepaged and other parts of the MM
>> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
>> which needs the correct vm_flags_t set.
>>
>> Benchmark
>> -----------
> 
> Seems you forgot writing this section up.  Or, you don't have benchmark results
> yet, but only mistakenly wrote the above section header?  Either is fine, as
> this is just an RFC.  Nevertheless, test results and your expected use case of
> this patch series will be very helpful.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Sure, will add the benchmark results in the next RFC version.

-- 
Asier Gutierrez
Huawei


