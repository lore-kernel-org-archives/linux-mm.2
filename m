Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1EDACCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 02:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1134E8E0026; Tue, 28 Oct 2025 22:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EBEE8E0015; Tue, 28 Oct 2025 22:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027C88E0026; Tue, 28 Oct 2025 22:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E09658E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:03:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FAC5160637
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:03:09 +0000 (UTC)
X-FDA: 84049504098.06.231F3E9
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2762F40016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:03:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ykAmuVZh;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761703387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eK4vDSuRTOhJF4MJ84IKuDsgIzYi81R9gWmu7j/t3U=;
	b=ovMw6R7lNn7p2Dc/hEZ8FxH+XQqJKsu9DQ9FXfDsLms0kjFlYk0sGyzxGQmy+FOlN1NzDC
	qZVt5Yo2+LfN2zcqeaR3qhLt/72hnMTl/ZodSi0pYycWYrKcQj3suUXIoKWkO7n3Xo6954
	HYuMVR3uCosrXVp8mqSltfZTS4HvN5s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ykAmuVZh;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761703387; a=rsa-sha256;
	cv=none;
	b=cuYi+n0j+1Z+oLB8dlkT9yKSwtYyIsujgJG0KgTUv7Gn5g5JZRmCirT7mxDnRybDiYrfxl
	yJ1sRR0tNbBL9pljn6urKrEgKUUBj/C8Ydv4bCQ14RcsjFAOfr8yqbzHeHCkAbsHI1khDZ
	rbxudoYEJ8To5nf5bKjCspVSIVfuaZE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+eK4vDSuRTOhJF4MJ84IKuDsgIzYi81R9gWmu7j/t3U=;
	b=ykAmuVZhMSyM5Iky45LoxzvpXZJ3wHa2hOshvGtKHvA2nQyir2aHEYnSo1IehVSuXBgb7m4Ew
	QChnPxMkYaJStFl+t5lShcqGvdSKsYce4XNF/VuOJiWpx+jtbDPn8J7Q/MpQDTjS9JWZWFPh1Eb
	4cm+bG+sHj81lHDuPuyQGjQ=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cx9Tx4Cxsz1T4HJ;
	Wed, 29 Oct 2025 10:01:57 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E4F6180B67;
	Wed, 29 Oct 2025 10:03:01 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Oct 2025 10:03:00 +0800
Message-ID: <75364faa-4cce-4e0b-ae43-dc725e6918da@huawei.com>
Date: Wed, 29 Oct 2025 10:02:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/stat: set last_refresh_jiffies to jiffies at
 startup
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20251029013038.66625-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20251029013038.66625-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2762F40016
X-Stat-Signature: jwupx1hxrfmc3i7iju4xk54k8s9bx7ay
X-Rspam-User: 
X-HE-Tag: 1761703385-19660
X-HE-Meta: U2FsdGVkX18lp/W5Psq+tgT6jYNOMUSN6wXfJOc3zKFlywTGNOMQksh8rOjqoMa8VzCvzW858Uv+gpiBCZgjBO+1eUXWODN/jEpS65/suDDTV5qxxM+G4GPTUSb5czaB7cOU83hpghCvFYNYywVw3aPxXE6ZgrDmBVUnNh8i39mynJ+lEMJ0Pp2bLKX6G0ndkg8ViqfF1NoUM9RMVSiHjrm4B6zUm8lK2n53JVRsGPnSlNRfguOWtkQrxSMQtuIBN4o6tgGYjLP2jjdGejhkLg0XVAWzHU98K/JCVfTvBZ4XVlvd9jkK87mCgkdPuSVPIqjErBxOzhmaGeSvaNzUllAa7vXn98Y0eo/9PX3Je+MgjyDD6FR0XfM8ejUcVVeFqMNO84p2C+rL34otaqFHup1ZAH9dH6ZcawkNuh3SkqdS0aBMDgMTn0QeXar4b5cpVE+NMsxXmgjZ+M49JTmsnObOYAPAI76L/r5arU+CK9iFjAfqnN7ku4OEHRK9xSaX5Nwci2/USUQiDqXQvXhur0jS2Toa00pxF9cZumOg56v/42YcaWHxmLUdOjxY4NVDbmOlEzKvpD74bl9J/OQ3NERvgitGWatIBeanSIQikHsgRUaitRQ/X4skD9RjZF4WIuNAwJRKg5rqdSaQP8Y5W/mlB8ykLAkd+p12YZayLOclkYdr5/jN5JYQ4X1m0C5xq1TMBUHPjO2dVaBYL3Y9wNNKkaYGxZDUCLgBWXTr21dNmsTtVbMLYlZbWeYNpfAlaH2Stx8Hrs/o4ouxKnUoPlz5rh76kElrtRzOsUXlA/xO5yBkgiXn+fk9dPUT9hAYvUVvtkkYvgmTnhs8cwQdijY3cw14b+JuDjsD4hAZwf1icKGNlYs+Hco5Ces3qvbbrxnbuAOWI2roFfg4gvUs1xkHPbGMaUEamh2Z77bexzNwOSB6PQHiL3TZdN/yTgDZfqiZhklF7kIxgVysxsl
 MBBPQrpX
 /7SUU06083xEj8TSP4vzFJFOSvLbiQj/Xpy822OhAd1F50//mP1ySVHNpG/k0HRdlEecrDLJlDfHFeg9j0dRKsz9xSNdYRvw6Ct2ersL7BW12MUXeTnuj2QZapmu90FxB8TFxJg5rVPmUy7wKcs2x/Eg5BC6Liap1wlqsIWiMxFjXdaqwjNiarAvESev/0KmKZJl5ty6p4HeE2J13anFKF5xIExs0Y55hqqfrE6R1HquxanbeXHw8bzB6Nubg59Nli/+29VXSe4S1c6xI69hJTG7zwBRtyR3cdVcT/UOsb6JLXIPWA+Vqia0rc3WCheoKcKVGF+xS0DjhCUjQo2IihfeYkd2zSxspJqSwJP21gK4sN3TF7hFJevvHdbe+WaSYQJ/eJdqMJXDFwDq75d90+bUoeOWueJrGjIBqAi5XwCKEewpKDgosZoDBT76OVTpMxF9IQt/tIOcKxUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/10/29 9:30, SeongJae Park 写道:
> On Tue, 28 Oct 2025 07:32:49 -0700 SeongJae Park <sj@kernel.org> wrote:
>
>> On Tue, 28 Oct 2025 07:19:14 -0700 SeongJae Park <sj@kernel.org> wrote:
>>
>>> On Tue, 28 Oct 2025 14:19:27 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>>>
>>>> In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
>>>> avoid unnecessarily frequent stat update.
>>>>
>>>> On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
>>>> jiffies wrap bugs appear earlier. However, this causes time_before_eq()
>>>> in DAMON_STAT to unexpectedly return true during the first 5 minutes
>>>> after boot on 32-bit systems (see [1] for more explanation, which fixes
>>>> another jiffies-related issue in DAMON). As a result, DAMON_STAT does not
>>>> update any monitoring results during that period, which can be more
>>>> confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.
>>>>
>>>> Fix it by setting last_refresh_jiffies to jiffies at startup.
>>> Nice catch, thank you for this patch!
>>>
>>>> [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
>>>>
>>>> Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
>>>> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
>>>> ---
>>>>   mm/damon/stat.c | 3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
>>>> index 6c4503d2aee3..6dc3e18de910 100644
>>>> --- a/mm/damon/stat.c
>>>> +++ b/mm/damon/stat.c
>>>> @@ -132,6 +132,9 @@ static int damon_stat_damon_call_fn(void *data)
>>>>   	struct damon_ctx *c = data;
>>>>   	static unsigned long last_refresh_jiffies;
>>>>   
>>>> +	if (unlikely(!last_refresh_jiffies))
>>>> +		last_refresh_jiffies = jiffies;
>>>> +
>>> How about doing the initialization together with the declaration?  E.g.,
>>>
>>>   static int damon_stat_damon_call_fn(void *data)
>>>   {
>>>          struct damon_ctx *c = data;
>>> -       static unsigned long last_refresh_jiffies;
>>> +       static unsigned long last_refresh_jiffies = jiffies;
> Please ignore the above suggestion.  It will even not build, like below...
>
> .../mm/damon/stat.c: In function ‘damon_stat_damon_call_fn’:
> .../mm/damon/stat.c:133:53: error: initializer element is not constant
>    133 |         static unsigned long last_refresh_jiffies = jiffies;
>        |                                                     ^~~~~~~
>
>> Actually, a similar issue can happen again if DAMON_STAT is stopped and
>> restarted by user.  That is, if user stops DAMON_STAT just after
>> last_refresh_jiffies is updated, and restart it after 5 seconds or more, the
>> time_before_eq() on damon_call_fn() will return true, so stat updates will
>> happen earlier than expected.  Shouldn't be a real problem, but better to avoid
>> if possible.
>>
>> How about making last_refresh_jiffies a global variable and initialize it on
>> damon_stat_start()?  To avoid unnecessary name conflicts, the variable name
>> would also better to be changed, e.g., damon_stat_last_refresh_jiffies.
> But, please consider the above one.
>
> And I just realized a similar issue exist for next_update_jiffies in
> mm/damon/sysfs.c file.  Please feel free to send a patch for that if you
> willing to.
>
OK, I’ll review all these issues and send a new patch set once everything
is ready.🙂

Thanks,
Quanmin Yan

[...]


