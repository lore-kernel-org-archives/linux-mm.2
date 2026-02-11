Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADAEE9E2E2
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 11:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F376B0005; Wed, 11 Feb 2026 06:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC9E6B0089; Wed, 11 Feb 2026 06:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BED16B008A; Wed, 11 Feb 2026 06:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 689BD6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:29:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11B29160335
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:29:49 +0000 (UTC)
X-FDA: 84431956098.15.D8251B1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id 049BD40014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:29:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770809386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tGcK1hYv9mcpJYVg9pR8Ubgzc1VQ3Rau/mBwAZ22FMY=;
	b=48ssAOkgwGlWeAExaZHd/MfP+Kr0GH2sqmhJxxKeVgWfL5dAO8M+45+9+rwH95MRGfvQzi
	TwKKbpuKLlGPgsqxu/XZAdI5ZIO0STCwyFQqMg3ytQUBm+Qww03lsbssIkiT/QKndlqT0g
	7RrHmW5RdRyUVHMPs1VRM845Fzx1LvM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770809386; a=rsa-sha256;
	cv=none;
	b=2pAP6aMYwag6y2+jR76JxzVwVOO/KXjjfdxnx0Q9XooGZELp7NykK1ehgVVR2Q0OO8o5sZ
	SqGvn028U5eqpFx79szYOBZEs3K9yOnCDAfmLzzfSvEtlUDkzcv7Nq9F/WDf7QQKSzrqm+
	4iWSSgvfF8lATPI5bfiS62BSujtwL6g=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f9x5P4Dc3zJ46Zy;
	Wed, 11 Feb 2026 19:28:41 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 04EC94056A;
	Wed, 11 Feb 2026 19:29:42 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Feb 2026 14:29:41 +0300
Message-ID: <e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com>
Date: Wed, 11 Feb 2026 14:29:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260211065914.68174-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260211065914.68174-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 049BD40014
X-Stat-Signature: xzwozuktxdasmzbfwphccpj7srkaxicq
X-Rspam-User: 
X-HE-Tag: 1770809385-970194
X-HE-Meta: U2FsdGVkX1/1PJyTu+shn/OxXBCJEppL6ww1nUApdJWEMPJGXalxKmEO/PszfZBYiDnIIwDfGQlWPhXzHJmrrlvwTMWo4Lxh4xVd8bvocJItHEMh/oAnSHrTOAKGaAYVKcJzpTVdRe+4wccsIECSc+clxWnOQTM+m+KMfpZwfzWV5IF4SzBq0UE+2ohc3HjfJX3rZlZztazgSsXd8WZxW4BSEnVoYPnKu3xDYRXVEeYmjD6zIcNx+NNL2AKlyLS0LX/u3PXwIyjXBOzdZ9x2i5nEpbB9AyKypl7wbc9fYY0b8xt1sj4dzGqc/Mrsq2B0YYzPE9WWVYMNIBETC/su+VmJw537f1u+0fMzBGAoIgb/kCeGIBZlg0OoUFSks8BG3LroxgLhFlF0iu2uUDAvom0FNUfj23up0Qc8fQr2j40SK1tZOqyMg0jw+4Vw4uii7ntThzoD1bkNCFFlC/o/DOtTlztgMr/Ae1vkqKpTj7n9bg4dFlwEp5zc/MyuuebMOlYYAITZaXblKVo6tm0XVVRRiBM5jQGUGGDStBcSR/qoBhUSK6nYiw+vns/r+Fw0DmgIVI+PVP+a2yVRsKOqsbzjXL0BXAaSO5fGL1LjPoUChxkaGQZSyeQXSJpxEO05P7+E8hXKK7wCMlOPc9GO+W+8GFmv9BLAauGg7Jkf3U0sWnuJMPZAvjkDFXHTDklq7BZB81lAQNHZeXnjD4+/Obyl0CmmCdYOlQ+QIlCrxnLz2U8kFE8hTNKxQu0ZWs9B++3sEfFBO+gv2wr+nwgDWQZoKSo5jzWi1z5KZB1AzLPxwPAnVbSMp7ydDA9y0zyI0X6z/88wQhEJsi0NN2+lr6TwD7r5oyuG6EdWMxuCzsLB8QABc/ve0J1Kcl3p1cl9FT4pE3K4fla7LLpMeJnX44TtM+wIa7RB804kcHNSjsQk6bNNt00mkPbplIuqu2t4agEOPUViCcvJKeddmYe
 nUUqbbnx
 5w2QWKtVTWGtxOQN9dWsER0C/H+duo4gmj3Z+P0up4NJ5BUCpYcCPHXBHKyVkXB4VaWhR/MFa5+pFDs1rkMP+MT+YnqduIY6KOHTmHuEDTcOoV8dqlcdwEk/yL0HTDOsewTaBLEXV0IR3vY6J644zlSz15UJ9UXGMEncrjjl/UuWseQBt0I1WGtSG+7pywXIEexcmPuZGJSW325PhszSHECZBY4qvpv7sVlo/dljj87HSc1/X8Z5CW5jxbvKN/Hm0cE3A3h6PL+PSg1LxukDbb3U7XAWfz6ivsf4kSX+vW+SFtIrXzjpRGyuR9lrJLBa1JaUdQ1KRoRwe5gY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 2/11/2026 9:59 AM, SeongJae Park wrote:
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
>>
>> In each kdamond, we start with a high min_access value. Our goal is to find the
>> "maximum" min_access value at which point the DAMON action is applied. In each
>> cycle, if no action is applied, we lower the min_access.
>>
>> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
>> collapse synchronously and avoid polluting khugepaged and other parts of the MM
>> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
>> which needs the correct vm_flags_t set.
>>
>> Benchmark
>> -----------
>>
>> Asier Gutierrez (4):
>>    mm/damon: Generic context creation for modules
>>    mm/damon: Support for synchrounous huge pages collapse
>>    mm/damon: New module with hot application detection
>>    documentation/mm/damon: Documentation for the dynamic_hugepages 
>> module
>>
>>  .../mm/damon/dynamic_hugepages.rst (new)      | 173 ++++++
>>  include/linux/damon.h                         |   1 +
>>  mm/damon/Kconfig                              |   7 +
>>  mm/damon/Makefile                             |   1 +
>>  mm/damon/dynamic_hugepages.c (new)            | 579 ++++++++++++++++++
>>  mm/damon/lru_sort.c                           |   6 +-
>>  mm/damon/modules-common.c                     |   7 +-
>>  mm/damon/modules-common.h                     |   5 +-
>>  mm/damon/reclaim.c                            |   5 +-
>>  mm/damon/vaddr.c                              |   3 +
>>  10 files changed, 778 insertions(+), 9 deletions(-)
>>  create mode 100644 Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
>>  create mode 100644 mm/damon/dynamic_hugepages.c
> 
> By the way, I proposed [1] an LSF/MM/BPF session for access-aware THP today.  I
> also mentioned this patch series on the proposal as one of potential discussion
> topics, and Cc-ed Asier.
> 
> I just wanted to make sure that the proposal is never a sort of implicit
> request to hold the progress of this patch series.  Please continue discussions
> and revisioning of this patch series regardless of the proposed LSF/MM/BPF
> session.
> 
> [1] https://lore.kernel.org/20260211050729.69719-1-sj@kernel.org
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Yes, I keep working on this, I haven't given up.

I was thinking about your comments and about the overall idea. When you
mentioned goals and autotuning, were you referring to DAMOS_QUOTA_USER_INPUT?
The idea was to adjust the min_nr_accesses for region and I haven't found a way
to adjust the damos_access_pattern using goals and quotas. If there is a way to
do it, it may be a good idea to reuse already existing components.

Also, I thought about moving part of the logic to user space. What do you think
if we leave the hot application detection mechanism in the user space and we
keep the THP part and autotuning in the kernel? Maybe this way we can move
forward easier and eventually merge it in the mainstream.

-- 
Asier Gutierrez
Huawei


