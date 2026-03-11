Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45DDF106289C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312A76B008C; Wed, 11 Mar 2026 09:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0AF6B0092; Wed, 11 Mar 2026 09:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD016B0093; Wed, 11 Mar 2026 09:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB05B6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:09:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D0FCC0A89
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:09:05 +0000 (UTC)
X-FDA: 84533812650.11.B8C3BEC
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A83A20017
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:09:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773234543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZp3zIyDBnJQYUFTOZxRpIvQ8NXkAeW9k0Eu2wPii+I=;
	b=8sAHafMX2RZR2TLIJz/2yIwe0mtKtLHmFRiHirYshWuILJhYuj83jfCKQ84XI/DZkHyyJ9
	ZSecYR1qCR83+tvyj3zksIyju7nzVwHX/vhCRbkoqFW6BApLcvrMCGrOKVTbrS09+hwRXF
	QFanPBy+VMbtiF9WjG6hvhZdWzrdFDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773234543; a=rsa-sha256;
	cv=none;
	b=OiIgPs8E8GaOAVZ+wOuTnQYZ1w3g9UTQgLpTmRf7XUmlhceus6Id5RyfJDuJ37jmh7fd8p
	Uz+koPXMU69x0YTWeqm1uKIk++Zf54VgaCeJVVx0DmdM+gP7Yn3BSUZkcpO0IxfZK851UA
	UYVgvBgT+cz/hobunfFLYZSalKQxF20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWB0230yLzHnGjV;
	Wed, 11 Mar 2026 21:08:50 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 23DCB40587;
	Wed, 11 Mar 2026 21:08:58 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 16:08:57 +0300
Message-ID: <577a2b92-3507-400c-acbd-32c914d374b7@huawei-partners.com>
Date: Wed, 11 Mar 2026 16:08:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Support hot application detections
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260311050701.91686-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260311050701.91686-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A83A20017
X-Stat-Signature: jyq7fxx49pnwwfpo1gzi1co7f58esa7x
X-Rspam-User: 
X-HE-Tag: 1773234542-697147
X-HE-Meta: U2FsdGVkX1+hC1iv0mzf5M/lo2TGdVZ1FcNUS5C75s/hpRxSuHcSGA/JMt0ONzYfPRGJxDrQWir5InaM65It7/fsJsMilVWKQ0mkvPjlACYGanD+7ZJ3f57LpnmIddBne9W6azakhcDOpJ4bkYkisFykHYT33G9+GoY/4TpjCI/imsLKYrGf1ev2Gfv7Xrwc2EV6oQvi0QucezwU1I4pHc+p5rEqsIhGiHXAJlXdB9h04uZENb7zvDrbC8ThyJ0leJjUG3GdAlWkwpCtJbQ8YXtAMp8IJQLovrNwIDRB1+Te3VmP7vfqBfZPpU/X94U98bStS9VrwirKKIU2Dxru8WyqTaSnYVq/4LEgcIKCOGBdlKe4GrEenFK/f5QfWX6S27EpP4wWaBrZCG+9H9swMEUD/KLsX5beEqLXlnXBwmGQvgsGHjdzgkq9IehEfUWy1HLeh5r9Tev4pX0+L6Yh9Xdl3dhcEMY0VU6lt/lCV5EaOmoCLO0w7fVacYcgQTcR42I8tf/vNu59vnXQXqvrxmYpdbAI+aDv0ledxxmg4wzXhV5DBOfPF0URxTkb4G/AdvOTDA2Dz80rggzw9GvlXKoxnYB7CKDXeepoYGEgC3hlJgdTfr0ot5nSPkaAYYqjz1FY2IOD5f7DCsWW4ZQ/g5FQyeTuvYuio+m/XA0J+K81aP5j6EAeOwVKhu1aEB2o1huX8fCqGT/sRpswvF7TQpF21aRiqiJ38WulPxozALnqNvHWaT86HLSDZAdG6dq/Tm3H2dmgpNJ/auDROaOmV94HXfFFVlP6SSeQYly5UMqaAW2ee7M9zOVopuS5YsazX7+Gdj6QbHQLTDWKl8CAecI5fXv1G0/Pxr+LpPHN+sBhwFaZ7DI8BnM23EvAB6t+bVpBcazON6+udVtTJvr/IPQtXhx3/YTlk0LEaiZITwQbrTNVAV1OSMIUzPTG51anXv9aAX4nOYf+a1M5etv
 ONeUdpmC
 Q2LdZw+eApBqC9824UWUx4b+PKRMtGGEoU49cFU8s7NQoeGR/qb8HoJFKoe40VbaA8BDWdU9k8Qpl6VTjNX9/OAM5M3y9LP5m5T9aG2Df5MGixhS4CUL1y5+DXC0Rboadt6VcKxT2qun+1TP+bw/lmr2uzHBzbKIgQTCqdnuTBe51xnmQ27v/LtOhtLSXEbSsphT9nXCIqXYoWd82CPbvnUWO3WA8azC+4Gv6j4jzRXq99SUk+eb6xYNotAlqk6Ou26oJeeSHwYkPlX+svmK+EC0yIReEBjwYQ09w4cWF2xbEVY5xCrGc3gRst5DqhYw+0eh4s1BwYRu+wdpsJtsKXwFQiZ489h3FAfoMqM9Guh7PxBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 3/11/2026 8:07 AM, SeongJae Park wrote:
> Hello Asier,
> 
> 
> Thank you for continuing this work!
> 
> On Tue, 10 Mar 2026 16:24:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Overview
>> ----------
> 
> Let's make the legnth of the subject and the length of the underline same.
> 
>>
>> This patch set introduces a new dynamic mechanism for detecting hot applications
>> and hot regions in those applications.
> 
> Seems now you offload the hot applications detection to the user space.  If I'm
> not wrong, you should remove "hot applications and" on the above sentence.

You're right. I was not sure whether changing the RFC subject was right or not.
I will change it for the next RFC version.

>>
>> Motivation
>> -----------
>>
>> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
>> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
>> fragmentation and memory waste. For this reason, most application guides and
>> system administrators suggest to disable THP.
>>
>>
>> Solution
>> -----------
>>
>> A new Linux kernel module that uses DAMON to detect hot regions and collapse
>> those regions into huge pages. The user supplies a set of PIDs using a module
>> parameter,
> 
> This sounds reasonable to me.
> 
>> and then, the module launches a new kdamond thread to monitor each
>> of the tasks.
>>
>> In each kdamond, we start with a high min_access value. Our goal is to find the
>> "maximum" min_access value at which point the DAMON action is applied. In each
>> cycle, if no action is applied, we lower the min_access.
> 
> So, this patch series introduces a sort of auto-tuning of the hugepages
> collapse hotness threshold, that implemented in the new module.
> 
> We already have a sort of DAMOS auto-tuning feature, namely goal-based DAMOS
> quota auto-tuning [1].  Have you considered using that?  Of course, it might
> not be able to be used as is.  Some extensions, e.g., introduction of new goal
> metric, may be needed.
> 
> Yet another approach would be implementing the auto-tuning in the user-space.
> Because DAMON parameters can be updated online, updating the min_access from
> the user space should be doable?  Given the fact the module anyway require
> user-space control for feeding the list of applications to apply access-aware
> huge pages collapsing, I find no problem at user space driven auto-tuning.
> 
> If the goal-based DAMOS quota auto-tuning or the user-space based auto-tuning
> are feasible, all the controls can be done using DAMON sysfs interface.
> Introduction of the new kernel module might not really be needed in the case.
> 
> We have DAMON modules in addition to DAMON sysfs interface for users who want
> to use DAMON for a given specific use case with only minimum or near-zero
> user-space control.  In this case, because it is already aimed to ask the
> user-space to feed the list of applications to apply DAMOS-based hugepages
> collapsing, it seems a new module is not really needed, to me.
> 
> But I guess your use case might have some special restrictions that really
> require use of the module instead of offloading the auto-tuning to the
> user-space or DAMON core.  Is that the case?  If so, can you share more details
> about it?

I haven't figured out how I can use goal autotune to change the min_access.
Your suggestion about moving this to the user space sound good.

The idea was to stop lowering the min_access as soon as collapses occur,
since we don't want to lower so much that we start collapsing regions that
are not very hot.

Maybe you can suggest a better way to do it. Maybe with autotuning.

> 
>>
>> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
>> collapse synchronously and avoid polluting khugepaged and other parts of the MM
>> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
>> which needs the correct vm_flags_t set.
> 
> This makes sense to me.  I expect DAMOS_COLLAPSE to have some advantages over
> DAMOS_HUGEPAGE for some use cases, similar to MADV_COLLAPSE vs MADV_HUGEPAGE.
> 
> From my perspective, this patch series is introducing three things.
> 1) hugepage collapsing hotness threshold auto-tuning, 2) the module for running
> the auto-tuning, and 3) DAMOS_COLLAPSE.  To me, it is unclear if the first two
> changes are really needed.  I will wait your answer.
> 
> Meanwhile, the third change seems reasonable and not necessarily need to be
> blocked for the other two changes.  I think separating the third change from
> this patch series and upstreaming it first could also be a path forward.
> Because the change is simple and sound, convincing me would be easy.  I'd be
> convinced if at least some reasonable test results can be shown.  I'm not
> saying we should drop the other two changes.  We can keep discussing those in
> parallel.  Rather, upstreaming the third change first could help finding real
> benefits of the other two changes, since the testing will be easier.  The
> decision is up to Asier, of course.  I'm just sharing my two cents.
> 
>>
>>
>> -----------
>> Changes in v2:
> 
> Let's keep calling this "RFC" here.  When you drop the "RFC" tag, this might
> confuse some people.
> 
> Also, when you add a changelog of a patch, adding a link to the previous
> version [2] can help reviewing.

Will do it.

> 
>> - Previously there was a mechanism to automatically detect hot applications.
>>   Based on SeongJae Park's feedback [1], this was removed from the module, leaving
>>   it entirely to the user space.
>> - All allocations now use kzalloc_obj.
>> - Since the user space provides now the list of pids to monitor, a commit_input
>>   parameter is added to allow changing the pids while the module runs.
>> - Renamed the module from dynamic_hugepages to hugepages
> 
> Thank you for doing this, Asier.
> 
>>
>> [1]: https://lore.kernel.org/all/20260211150902.70066-1-sj@kernel.org/
>>
>> Asier Gutierrez (4):
>>   Damon_modules_new_paddr_ctx_target. This works  only for physical
>>     contexts. In case of virtual addresses, we should  duplicate the
>>     code.
>>   Support for huge pages collapse, which will be used by
>>     dynamic_hugepages module.
>>   This new module launches a new kdamond thread for each of them. The
>>     purpose is to detect hot regions in a given list of tasks and
>>     collapse them into huge pages.
>>   DAMON_HOT_HUGEPAGE documentation
>>
>>  .../admin-guide/mm/damon/hugepage.rst (new)   | 186 ++++++++
>>  include/linux/damon.h                         |   1 +
>>  mm/damon/Kconfig                              |   7 +
>>  mm/damon/Makefile                             |   1 +
>>  mm/damon/hugepage.c (new)                     | 441 ++++++++++++++++++
>>  mm/damon/lru_sort.c                           |   5 +-
>>  mm/damon/modules-common.c                     |   6 +-
>>  mm/damon/modules-common.h                     |   4 +-
>>  mm/damon/reclaim.c                            |   5 +-
>>  mm/damon/vaddr.c                              |   3 +
>>  10 files changed, 650 insertions(+), 9 deletions(-)
>>  create mode 100644 Documentation/admin-guide/mm/damon/hugepage.rst
>>  create mode 100644 mm/damon/hugepage.c
>>
>> -- 
>> 2.43.0
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning
> [2] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


