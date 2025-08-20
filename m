Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912FBCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D018C6B00CE; Wed, 20 Aug 2025 04:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8B26B00D1; Wed, 20 Aug 2025 04:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79316B00D3; Wed, 20 Aug 2025 04:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A30916B00CE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:46:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F250B9435
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:46:03 +0000 (UTC)
X-FDA: 83796503406.24.78D8A21
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE3AF1A0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:46:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755679561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QeWeHQIoEVv7rI+h9UnMfu8IX5dCC51VbvFDM91FRzw=;
	b=BNftRVBGFqgM6UndcXwlojKrZ5n2HfRVl8XUHeVKqSMMcxR9v818aXZkHIJ7j3w+FsCJrQ
	w+SDgxnEcpPi1I+ZoPF95Kg6N/Iqs/AD/4+MvS4SbCfffq5L+dLwDnqflh3spjgfZd+AG4
	GmP1eaJattue5c+SsDcz6lu8euF/x+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755679561; a=rsa-sha256;
	cv=none;
	b=BA8X23FVZmGSzsQWvFhM6ySLocxbR/4SV33p2bnVFEMJ6tyvgHhDA1PoIeut8PQalRKzpJ
	R11Uz1KQGyIPOzS5PbGXKrujyWjmjzMgX8x4rzArmwZuUjxGnr7ZMsMfswN/okGLPkv4gw
	Aj6pamT4tnYjWjNsr5IWiDFzBULt+i4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6Kg41xqNzPqZQ;
	Wed, 20 Aug 2025 16:41:20 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2AD2F14011A;
	Wed, 20 Aug 2025 16:45:56 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 16:45:55 +0800
Message-ID: <6d054831-054f-446a-a82f-239913a9deaa@huawei.com>
Date: Wed, 20 Aug 2025 16:45:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 13/16] mm/damon/sysfs: ensure valid addr_unit
 setting in damon_sysfs_apply_inputs()
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250813170224.6128-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250813170224.6128-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE3AF1A0008
X-Stat-Signature: ecbjhzmakfu4rr1n3th8jxoc1de1exuu
X-HE-Tag: 1755679560-226452
X-HE-Meta: U2FsdGVkX1+ooBZj1JrX/xGY1dH377WYhmeF3HN0wSM69wkAGQJmclB6bAcBWeUuiMoSjkM8AwCSPDQqcO7D5PNrWYBwqdfCnrPeD+V0esLAwDB85sp0VWBFwxe1SuJNoJoB1iz6VZxErHozOymCAzZ/pcRN4hyCtyD486h/ZR+UdRX17PGG3AKqYuI4G/G4Js0vflfVQehr5AxHVv9/9MzBV0zKWNZnT8USX3Q/ezSWwVwVhHm7tzq0AFGTJa5RaFB7VEL12ohY4AQFYNAzxCMQAWDLVkzsAsdUpwSUIDvZwOdyy+lQ6Gf1eqNvTxqD/e7Cxpbv5dzHzK6IZ7pFJGIqoD9C+TjN30Rq+yFkYoQ3SVaYiJ4psASFzZkxw1ISKBtop9v9EojSYrI8n24oINagZNANk9SCZsx0o96z6FFwGax1Ow7/G925k+Atht1LP0av4xUpE97XZhGpTehKDM6LvDPfaG0po5cDfuTZsGYNOZt19VTaV9K802x61GYLgseUcHw2uRBXiVqGShBie3hxun30dOWr+W4FtW8of3mVt9/Qzdy4Ri7hzKggHg95+aucPfo72OWo7HCia0tT3JpDnp9xjOD+LULJ3D/9qItI3LON3Ct5cgAVmsrFNCUgYX9H+HPROI/0J73Qo5/0e9CgQ1AI1h4GzqxUtsFGuiWCOZz60rv4ZKikUvVLDuf8OEpd3OLdAUG8dkYNxxlVj03EPTAb7vfNT1RIwQh2mGGW9pnvdkHw/l/vxeU6YQ6m0BEtNqU22gmhc/xUu9kGUogGlF0FvZP2J8BY0Z84Bp2wMxDK42N8rDggRs/bAr8g1FvC1PWOHDPrWFAgA4XIEQ5LIg0l8ZWFbvh7UVA6gmGb1lfbYRDyIGY0U3bcMAQ7t3XgPI2xYpeM6+L8HOsRcutSyrKsd/i+P5le4PGieh3lGQJOPfEUSnaa8xGdRMh0SPjbKY78mcf68sERDY0
 L6hSyfrs
 suYfl9vJ6v2NUE8BjEXX1aPjoLJ9TWBn8i2QaLwRLjMikF20EOOhAtVRkoBCvQS5Va6HoHd6Q4qlezSO9LBCtMfahIa2kTAY0xs1tknIc/aL1F8uykedx9R/2nMXJyRCeCgvKNES+Pzpv7AyeqtXhL3oReVh95voXNsnoUriWldgGjWMEwJ4hKDVvvfn0W+m25UlS5Pr0x05n/iZQ/hbafH7yYPs7lryILxRtrdN/ln4kP/7TdUUsDw3k+eexD8ybQuKbQ3QFN80X64Ty2ijYRDL9yWXAd8tfIYHcTukzoBpbQh2xBBm0aCkhmwojexwglv3r2ji68aoJ2T7q/bxfxeb8Wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/14 1:02, SeongJae Park 写道:
> On Wed, 13 Aug 2025 13:07:03 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> By calling damon_sysfs_turn_damon_on(), the execution of damon_commit_ctx()
>> can be bypassed. Therefore, it is necessary to prevent ctx->addr_unit from
>> being set to 0 in damon_sysfs_apply_inputs() and update min_region to avoid
>> potential issues.
> Nice catch!
>
>> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
>> ---
>>   mm/damon/sysfs.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
>> index bea782b0a711..122824776c1d 100644
>> --- a/mm/damon/sysfs.c
>> +++ b/mm/damon/sysfs.c
>> @@ -1422,7 +1422,8 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
>>   	err = damon_select_ops(ctx, sys_ctx->ops_id);
>>   	if (err)
>>   		return err;
>> -	ctx->addr_unit = sys_ctx->addr_unit;
>> +	ctx->addr_unit = sys_ctx->addr_unit ? : 1;
> So this is fixing a bug of the seventh patch ("mm/damon/sysfs: implement
> addr_unit file under context dir") of this series, right?  It is better to not
> add a broken patch, and then fixing it in the same series.  Let's squash the
> fix of the problem into the patch.  Don't forget adding your Signed-off-by on
> the patch.
>
> Also, since sys_ctx->addr_unit is initialized as 1, the value being zero is
> user's wrong input.  Let's return -EINVAL instead of making it silently
> success.

Thank you for the kind reminder! The relevant changes have been integrated into
patch #7 of the v2 series[1]. It's worth noting that we've already prevented users
from inputting 0 at the source, therefore "ctx->addr_unit = sys_ctx->addr_unit;"
has been retained in the v2 version.

[1] https://lore.kernel.org/all/20250820080623.3799131-8-yanquanmin1@huawei.com/

>> +	ctx->min_region = max(DAMON_MIN_REGION / ctx->addr_unit, 1);
> Seems this is a fix of an issue in the 12th patch ("mm/damon: add
> damon_ctx->min_region and damon_target->min_region") of this series?  Let's fix
> it on the patch.

This set of changes has been integrated into patch #11 of the v2 series[2].

[2] https://lore.kernel.org/all/20250820080623.3799131-12-yanquanmin1@huawei.com/

Thanks,
Quanmin Yan


