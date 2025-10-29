Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D68CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1E28E0021; Tue, 28 Oct 2025 21:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282338E0015; Tue, 28 Oct 2025 21:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B308E0021; Tue, 28 Oct 2025 21:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 008B68E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:32:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F27249A95
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:32:47 +0000 (UTC)
X-FDA: 84049427574.21.2FE933A
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf25.hostedemail.com (Postfix) with ESMTP id A40E7A0008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:32:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BiChO3hh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761701565; a=rsa-sha256;
	cv=none;
	b=zFFUjkbHmuWg8AUvEW53TmRSA6P5B/Brwm+E7OBIdKYlDZQ2sE+01JnL/QNXlRRsA1SFc3
	CuSmHQDR9t7iE9FfCZBwsnN1hPUSq4Pp18zMSAc51IjGBFNrf3uPUm1kXYA2g/pyHeggI8
	2qCXbdmxm5FYmVorZZCGGZi9t0KCrI0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BiChO3hh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761701565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3RjBt8zeIPQKLHLasDxZWnu3ZJLAQippsYalBaaCdQ=;
	b=8lnxlu5p3BdHnzLo+dJzsmh4iXDWC8qHzxMNX6BuUNbkH4hyntqpq+shrnzU0/+98muZbJ
	GP1J1jqtJ6cyGyOq/u1buoiwU/+Spo/LTc5MpEUlOapxi0T772kW7+Ps+zFpRiEYJGQBYd
	umkVEgvJICn7iMBs++h0r8IP8MSnmTY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a3RjBt8zeIPQKLHLasDxZWnu3ZJLAQippsYalBaaCdQ=;
	b=BiChO3hhDBOjuIKhCpJghRePDqtttnYUvUpE52W8IFnSvPGwZhRJnTtdpVy0kOmulbf/qnd0D
	nrBjV4OmRCd1q0MsXF6n5bSUS9osinJi8dQQl+cTt0JjmbtK/lkGco3ZCv22akfkjlI4lQkYxFm
	+X0RQNoSUqwIZeQgzWscvZE=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cx8qb2VKxzmV6g;
	Wed, 29 Oct 2025 09:32:11 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id F06FF1A0188;
	Wed, 29 Oct 2025 09:32:39 +0800 (CST)
Received: from [10.174.177.149] (10.174.177.149) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Oct 2025 09:32:39 +0800
Message-ID: <19e22163-39b4-42f8-99b8-1be9ffb1589b@huawei.com>
Date: Wed, 29 Oct 2025 09:32:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/stat: set last_refresh_jiffies to jiffies at
 startup
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20251028141915.49989-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20251028141915.49989-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.149]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A40E7A0008
X-Stat-Signature: qhf31b7xgetxcjxui9pir97ewiea6f45
X-HE-Tag: 1761701564-224888
X-HE-Meta: U2FsdGVkX19NGvUE+WmmkNxFM+xl3IP8Jl8JSoOKTDC8aF7CLCPF9rPaPiOQgV1lsaStx76R1eYK7FDwabF8DjOQ4gouvjN2heEIVoqP9LEhjdtg3gIgIzwNcfJBchy9d0p+lE1m2Ror7jAZrjljvLtO6V/EHKlItmGHQfmXp2yfYX5TqBiOznYmPWoKrI4Kmge1AoDDAqMHcgoUcGVTa3s74AMOxARPMBJH9r4wZe8HKHf3cM0zyKBqgZXBZsLMNPf8jpGEoY19F9Eg2lzUbIKt9GjiB2U/LSVssFtIxCAvkt16f4lcMqcJOvEcvZH3Chz+9taOGxwxitS2W/qHrLSgoI0DdYpVXsjGuAuoy+U7ZN5FAIBUj6FU3snqE9/1Yq/+F6Tp75dbpTbGhS4YI7enlWfKUnUIgTWDvrTGAJ+cYk3S+mguwsOYtVNUF2IURaPlRtlJYjtAGvMweLfdBVv8KjRcB6Zp7dnEUlU4gBOHBolqupHdpaOS9wpaWTX0OX8HogMuU1+wi9jWVrx7tRVOvoFY5Zx0xNITgJSHfJ3y8TsIKRqCHa2bzalGuuVv7bSZtNBkw9KipgtiufaqkgKxNhO242ERZjmxKC8GKpSXJNfZZE9w447UEqiApG1XUDy4ycNphfKxFzz4y+r7zlI1OTlGnxR09Dwj3dCyN4HFLWzCn1lQID2KqsUUflpLBdqFdSqn+Cqm1MFays0/a1JbIMqZmTLoSMmGnM8kP0qevRe+znL9M+xTbjWfI+fU6K/8oAVi+i20afXUlOCMhqv75RLSGhAze1luAr8vzV1SmXVBbVWfD+wPvRPcD6x4J6tSvWY/fb+w6bLBOUn4Zzo50GV6Ic48fn4aP0SOc2cXCHN2f+bYBx3H9+n/sBjMq7jNnDgh+E8LsC+tFqznp+Rv7dBH126oiO45bePfp1f7og4TL2c4cds5yfp5b9TrJCumcRGMd1tFp3mgvzS
 jukf5nVJ
 Cs6JrV5FEbmihWasj+iuNmG1p7Br4uv4j4dj0kjoahqD7f9Mee6e3ii5rnsefcHZp5dkrqcT31gwRbh7JKrcr3gJHYJSpn1L3C7MnHX4CMP24psTFv8WQ1rt3CCbi2A1tDH9I+/CmtLRTePuxsSllprYMliRNK8l1MU4yB88LOJaFHF5KtMM1OxMLgHEbnQANHc+RorqYe+aG3L863vP6p8L5FoxTXnP5/ziieKeY9i71x+kww55rlGFfNVyV3tE6YMJE5elgeNvMX905A/RvE6wAUlQM2bmMft0Fj76WV/lN1yodevbvke+izfpiOOGI7CxvwtX5AQQpEkODspKYq0KX9EF60YEUf8dTkgfLNAWT8CBNGKks5Rrvit7pnVa1BaZBXkvuGu5HcgKHEHcfyEGM3Kq8dTlCYzD4+ODZtO4/pN7F4QfcIhHq/2fJY48OOzeHeFD6XNPVxOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2025/10/28 22:19, SeongJae Park 写道:

> On Tue, 28 Oct 2025 14:19:27 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
>> avoid unnecessarily frequent stat update.
>>
>> On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
>> jiffies wrap bugs appear earlier. However, this causes time_before_eq()
>> in DAMON_STAT to unexpectedly return true during the first 5 minutes
>> after boot on 32-bit systems (see [1] for more explanation, which fixes
>> another jiffies-related issue in DAMON). As a result, DAMON_STAT does not
>> update any monitoring results during that period, which can be more
>> confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.
>>
>> Fix it by setting last_refresh_jiffies to jiffies at startup.
> Nice catch, thank you for this patch!
>
>> [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
>>
>> Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
>> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
>> ---
>>   mm/damon/stat.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
>> index 6c4503d2aee3..6dc3e18de910 100644
>> --- a/mm/damon/stat.c
>> +++ b/mm/damon/stat.c
>> @@ -132,6 +132,9 @@ static int damon_stat_damon_call_fn(void *data)
>>   	struct damon_ctx *c = data;
>>   	static unsigned long last_refresh_jiffies;
>>   
>> +	if (unlikely(!last_refresh_jiffies))
>> +		last_refresh_jiffies = jiffies;
>> +
> How about doing the initialization together with the declaration?  E.g.,
>
>   static int damon_stat_damon_call_fn(void *data)
>   {
>          struct damon_ctx *c = data;
> -       static unsigned long last_refresh_jiffies;
> +       static unsigned long last_refresh_jiffies = jiffies;
>
Thank you for your suggestion. Well, I actually tried that before, but
found that jiffies is not a compile-time constant,|it| is set at runtime,
while static initializers must use constant expressions, that's why the
current patch is modified this way.


Thanks,
Quanmin Yan

[...]


