Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09EFE87839
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285AE6B00B4; Tue,  3 Feb 2026 09:25:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2517E6B00B5; Tue,  3 Feb 2026 09:25:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1677C6B00B6; Tue,  3 Feb 2026 09:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 053A36B00B4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:25:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 939921404EA
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:25:19 +0000 (UTC)
X-FDA: 84403367958.17.4822599
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id B045DA0016
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:25:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770128718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mVP/It2tFjYqnbQaiYI9VXaDpG0AypbPTzyvuoIbiyY=;
	b=BX78ZYjc69URTLNpKaoqxt1JdEFakEIkGTd9AfwKGhgd5dxK8okLDyHCKWcFRUToTNiTDa
	PUnB/uwY2pqUZoR4HCQXMZkRkLbzWFz7jcEc3ZuBxKbDoF8rg/nVuwSlhkBxzJllqZ0dSo
	Kx7LHyumEhOuRnGstLd9RO5Nh7dr4Qo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770128718; a=rsa-sha256;
	cv=none;
	b=Xoy0MmZ+VrTqKkKSTctJ/Gw098w1kpHKug5Ux3feLuOpyK4A2HcyMrMbT11bVn0ea9duWx
	JTv/dY52Qv8ILKJ8nX0dShC3/ld3lakF+Cc8fspuLK172x2ohplhvvqCdzoMjkGUVj/2hc
	vl2so8LzuO8s4JcEHB4YiMxpXxy382c=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f55Ms2qPqzJ46CD;
	Tue,  3 Feb 2026 22:24:25 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id DAA2E40569;
	Tue,  3 Feb 2026 22:25:12 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Feb 2026 17:25:12 +0300
Message-ID: <af4f3e15-a306-4728-b5bf-1deaa700c99b@huawei-partners.com>
Date: Tue, 3 Feb 2026 17:25:11 +0300
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
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Stat-Signature: kk9qbf4n3x9qyp88mo8b9by58ya3xr99
X-Rspamd-Queue-Id: B045DA0016
X-Rspam-User: 
X-HE-Tag: 1770128717-333928
X-HE-Meta: U2FsdGVkX19KxW2aeGjwHM5fJVpfbwv2FPm0CxOyXCEYXiRdra1ORx+Lwgkoh+ypq7WvNWni72J+EK8MWH6f6x1cVZiEijb1ldfbU7YOljZnuyQc8HrQnD+bfC2zjQbD9qPJI4bomwOwAtGEFUaB2syVHIXlRs941dWpDzkUq3ZrXsGqPdy2VTaw8nuFCrJJ219rNQRa0WY0h859zV+ROey11Nv9bbUfKkQ/ELTKMG0GLgwTR+P7ZS0Kp+wzZl0fvTsLsfMpqeZoRLQPJdXo+tW5rGbUi5N77sz27EO187UI9936N4hlnQSC+r5vAY5NjjWQ4cLHcsDZ/K/X+d3H8lmVzzirGkcSnqSmWWtGiktx/f2Lix8LVahng34V0ppgxPUOlNtJfB+qvcZkklSnZYQglohWnaHwGiZl2j9cDOs8o1Z/bkkS9pzMb7olne1kUNAQxDSUQ80f9MWw0NbXfIliQzONGBOsrxKLEmJXskppO9SnsGxrGproUa9nKxadjAly96z4qFcb69I79JPGMyuogBXSkw4bTilh1rAeVukxu6ZDPW+WzCwLltY98nhZA6iqGdMcFn6FPP/mOjx7Pq28+Fw5Ev4QmhKA6heWtLV1j/c/DCYbWzUzbLMdixCm6VGKLJzAIlWTSzdEQbXe9ErQjjykqmZSvMatD2kcCi4nGGNXaDCKOiDEHr6ksL+7ZDoAr97eW0Av5eu28zPc/6WOVcFcSmjG9i0JhZZn/1vBnm20uEgnVDnNRBfW98WUELEVamAtyqRweAU5D6D9b4vsHRbnzM8TGvJaMeALe+y1Ou43AvTdrOcQDE+CJ5Yq5A5IQiRxubNFuH4Dq8UAEkrnTVjNv2YqrPMHnCgZB7So7b/5DvAY2I8tnanlKplAv3+n74adsRrkHep5QDhAzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SeongJae,

Thanks a lot for all the useful feedback.

One thing that I was not sure about while working on this patch set
is whether to have an external new module or adding the logic to 
damon core. I mean, the hot application detecting can be useful for
all other modules and can improve DAMON performance. What do you think?
My implementation was module based because I tried to avoid changes
to DAMON core for the RFC.

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
> 
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

-- 
Asier Gutierrez
Huawei


