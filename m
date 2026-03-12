Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B07106703F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 14:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05D66B0088; Thu, 12 Mar 2026 10:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD1B6B0089; Thu, 12 Mar 2026 10:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06B06B008A; Thu, 12 Mar 2026 10:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD4B36B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:42:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 758AE8AB0A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:42:42 +0000 (UTC)
X-FDA: 84537677364.20.142C3E6
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id DB1024000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:42:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773326560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5MpEgXZM2RU+4IMYDviCY6ylONLGtZnlx0+GdH2avk=;
	b=4/pP0mXLav1aOodDcXE+XJBf6LJjc/mq5v/yXf+Jw6VFwkw9cClzXUyNE63FLF3sLsbUAY
	jNRziZhDvK2Agrj9OQfcP/v7vj2fcBO+8qXXo0MP/Ng7D7UHmVDabPKdbp/ygn9DNOnXXa
	WMy8ZrSu9hlmWJCpasCkXXEboMBRdxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773326560; a=rsa-sha256;
	cv=none;
	b=QanOBjGpAVeLk4v2bTM9gb4izO9LBd6vwYNH9/36/VpKoHrglKsyUO2L34ieEDa/Xm7vdt
	ID8nZAovVA9kSeLew8ZcePDGwDmtkcQfjmMHM96wsmpm5DsGrAfak4N0MVgBmxw0feDY7i
	D8titZSEsx8ta4kfAo9gP4vuBlqvt9M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWr1b0B1FzHnGd2;
	Thu, 12 Mar 2026 22:42:27 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D017E4056B;
	Thu, 12 Mar 2026 22:42:36 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Mar 2026 17:42:36 +0300
Message-ID: <2a6c346e-6604-407b-9d52-1cbe15486b66@huawei-partners.com>
Date: Thu, 12 Mar 2026 17:42:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Support hot application detections
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260311143912.96834-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260311143912.96834-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: 7itwmpcbo6dyxr95q47bkju97g4tqk9p
X-Rspam-User: 
X-Rspamd-Queue-Id: DB1024000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773326559-915912
X-HE-Meta: U2FsdGVkX1/M3ZBMwdnuATownUyDvtxjj8m9wKlkj88ao7KgcbHYIbRPnQHEdF0Hfgn6DEqdRUcmIejZNb56L+rBjAi0OP6GkRZvbfymkVKjYWoKO2huQWyZoMFVKjMOEdFIPz58J19HOI/AF0ZJ1q1UuvU0mrvfE+Dp+ABvdCDBSkR7iPeJkZQ1E94UZWjeGkzL0ueqjPp9ujNpyqHNptkotohSVcM0hBtYVyyH6e8e02j40ylyGcvtrLSvO1gnJc3k0Uc+s1iy3cQ9jkY9/kQP+RMwv6Ua0Scttck+zyoSP++8hhcrr+mcKWngIhWKtbIO6rqWGl2bR2AmXyzHpQZfQVpfSAJ04iJ09ATaAIwTWno6lhBZs+N0jNQBVOASIE8WSI1FVLSKjA+QWIhvlhqSEoWGm0pkvDcXSaB7EX4+OwRuq6rduCxEyWgNCRhY/U//01NnJNirLcEXrZtVIZ1Z9bLu9e76v6YYRrOg7TVH5CBckh5jRC021+m93PmoZ0D41sDBUgYOkEQoPPLxcVSFDJmzGG3je3bGVhsaWGUYLxdYWkvIfqhuTS0NVNPS+a05u1dyoOq5FUo8W70WFS4QTbDEtsRKI/bWWDrwwMYar8G7OKYFZ6CAC07+aGC3mPS6afhKLQkbcZgP71E/nletOS9j0RXKRA8VnXqvk2ZvKxBFbeCkLjp3ZYURsrb30ikicKT4M9eZb8QR83OqbS1vhO/TsPybatr6TedR85GM/3hFlNhSmSxBzQHxF58S9m5oq6rbM9brK1uwLjUYtn63SJTykXa41GMQJhGNgDJmsbZnHyVi/wlje3Y4ebTQNIIVwRwnvJBjYxkUyek2B5IFSHeUjutu6GJX3R8pGbg6ije1iCCU+6qc8cEgrDFgDFj9IP/ws+rVQwpmwquSnwUWhR2D6ClXhzpGLl19w67YZHYH1LkRRmuW3g0YOsZDLYxluGyxIlqGPpDELHh
 BpERXTjZ
 kR84h8wX7Qw08hFYymvb7Pu/IpZ8TPRCBqkf9fnND4Zs39SgrWlJjex9lBQwXT7ZtMrVSOxvO+sJaUOEYAxBbd1eNN+eY1Wx3EdHOZh7B2/sIOffzR+8dwEXWw6MIOXI6NLriXQc6cqLs+7hq92NwCzls4wzik5xJBFO5BZuuO0XfWd0Ivm6c39fWvik4Lkgxv0SuPHwRmUA161DwxKAibzOT7AU8l+lh2Pcw70R0F1YPkUVVhFeEp6Y/zYoCuDknQENwfB/WvdmZQH+CdGTQFCJLvPW9+BUFwzJd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/2026 5:39 PM, SeongJae Park wrote:
> On Wed, 11 Mar 2026 16:08:56 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> Hi SeongJae,
>>
>> On 3/11/2026 8:07 AM, SeongJae Park wrote:
>>> Hello Asier,
>>>
>>>
>>> Thank you for continuing this work!
>>>
>>> On Tue, 10 Mar 2026 16:24:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>>
>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>>
>>>> Overview
>>>> ----------
>>>
>>> Let's make the legnth of the subject and the length of the underline same.
>>>
>>>>
>>>> This patch set introduces a new dynamic mechanism for detecting hot applications
>>>> and hot regions in those applications.
>>>
>>> Seems now you offload the hot applications detection to the user space.  If I'm
>>> not wrong, you should remove "hot applications and" on the above sentence.
>>
>> You're right. I was not sure whether changing the RFC subject was right or not.
>> I will change it for the next RFC version.
> 
> It's fine to change the subject.  Please feel free to do so in the next version
> :)
> 
>>
>>>>
>>>> Motivation
>>>> -----------
>>>>
>>>> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
>>>> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
>>>> fragmentation and memory waste. For this reason, most application guides and
>>>> system administrators suggest to disable THP.
>>>>
>>>>
>>>> Solution
>>>> -----------
>>>>
>>>> A new Linux kernel module that uses DAMON to detect hot regions and collapse
>>>> those regions into huge pages. The user supplies a set of PIDs using a module
>>>> parameter,
>>>
>>> This sounds reasonable to me.
>>>
>>>> and then, the module launches a new kdamond thread to monitor each
>>>> of the tasks.
>>>>
>>>> In each kdamond, we start with a high min_access value. Our goal is to find the
>>>> "maximum" min_access value at which point the DAMON action is applied. In each
>>>> cycle, if no action is applied, we lower the min_access.
>>>
>>> So, this patch series introduces a sort of auto-tuning of the hugepages
>>> collapse hotness threshold, that implemented in the new module.
>>>
>>> We already have a sort of DAMOS auto-tuning feature, namely goal-based DAMOS
>>> quota auto-tuning [1].  Have you considered using that?  Of course, it might
>>> not be able to be used as is.  Some extensions, e.g., introduction of new goal
>>> metric, may be needed.
>>>
>>> Yet another approach would be implementing the auto-tuning in the user-space.
>>> Because DAMON parameters can be updated online, updating the min_access from
>>> the user space should be doable?  Given the fact the module anyway require
>>> user-space control for feeding the list of applications to apply access-aware
>>> huge pages collapsing, I find no problem at user space driven auto-tuning.
>>>
>>> If the goal-based DAMOS quota auto-tuning or the user-space based auto-tuning
>>> are feasible, all the controls can be done using DAMON sysfs interface.
>>> Introduction of the new kernel module might not really be needed in the case.
>>>
>>> We have DAMON modules in addition to DAMON sysfs interface for users who want
>>> to use DAMON for a given specific use case with only minimum or near-zero
>>> user-space control.  In this case, because it is already aimed to ask the
>>> user-space to feed the list of applications to apply DAMOS-based hugepages
>>> collapsing, it seems a new module is not really needed, to me.
>>>
>>> But I guess your use case might have some special restrictions that really
>>> require use of the module instead of offloading the auto-tuning to the
>>> user-space or DAMON core.  Is that the case?  If so, can you share more details
>>> about it?
>>
>> I haven't figured out how I can use goal autotune to change the min_access.
> 
> Indeed, it is not a very straightforward feature.
> 
>> Your suggestion about moving this to the user space sound good.
> 
> If it works for you, maybe that is best for you :)
> 
>>
>> The idea was to stop lowering the min_access as soon as collapses occur,
>> since we don't want to lower so much that we start collapsing regions that
>> are not very hot.
>>
>> Maybe you can suggest a better way to do it. Maybe with autotuning.
> 
> I will add more detailed suggestion soon, by tomorrow or a day after.
> 
>>
>>>
>>>>
>>>> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
>>>> collapse synchronously and avoid polluting khugepaged and other parts of the MM
>>>> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
>>>> which needs the correct vm_flags_t set.
>>>
>>> This makes sense to me.  I expect DAMOS_COLLAPSE to have some advantages over
>>> DAMOS_HUGEPAGE for some use cases, similar to MADV_COLLAPSE vs MADV_HUGEPAGE.
>>>
>>> From my perspective, this patch series is introducing three things.
>>> 1) hugepage collapsing hotness threshold auto-tuning, 2) the module for running
>>> the auto-tuning, and 3) DAMOS_COLLAPSE.  To me, it is unclear if the first two
>>> changes are really needed.  I will wait your answer.
Yes, I tried to introduce those 3 things. The problem is that I initially found
goal autotuning quite confusing, so I kind of implemented something that behaves
like autotuning, but doesn't use DAMON's core algorithm. 
> 
>>>
>>> Meanwhile, the third change seems reasonable and not necessarily need to be
>>> blocked for the other two changes.  I think separating the third change from
>>> this patch series and upstreaming it first could also be a path forward.
>>> Because the change is simple and sound, convincing me would be easy.  I'd be
>>> convinced if at least some reasonable test results can be shown.  I'm not
>>> saying we should drop the other two changes.  We can keep discussing those in
>>> parallel.  Rather, upstreaming the third change first could help finding real
>>> benefits of the other two changes, since the testing will be easier.  The
>>> decision is up to Asier, of course.  I'm just sharing my two cents.
> 
> I'm also curious what you think about this.

Sure, we can upstream the third change. I will prepare a new patch for with just
that diff.

> 
> Thanks,
> SJ
> 
> [...]
> 

The use case that I had in mind is pretty simple. Few admins use huge pages in
production, since it leads to memory fragmentation and waste. On the other hand,
amount of memory increases faster than entries in the TLB, which means more
TLB misses and more cycles waste. My goal is to balance this. Improve performance
in applications while keeping the amount of memory waste due to fragmentation to
a minimum.

Imagine a database server. The sysadmin would like to collapse only hot regions
of the database task, improving CPU utilization but without wasting too much
memory.


Today I sat down and review the damon code. Given all your feedback, I think
this I didn't use the right approach or I didn't understand you initially.
My suggestions:

1. Implement a new goal type for autotuning that uses huge pages.
2. Implement a module that uses this new goal type.

Would this make sense to you?

-- 
Asier Gutierrez
Huawei


