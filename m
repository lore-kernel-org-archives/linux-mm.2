Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD8B106289E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31136B0098; Wed, 11 Mar 2026 09:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDEE06B0099; Wed, 11 Mar 2026 09:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B826B009B; Wed, 11 Mar 2026 09:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4FD6B0098
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:10:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DBF1B6CA0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:10:27 +0000 (UTC)
X-FDA: 84533816094.04.AD5A3DF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 41160C0016
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:10:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773234625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIt3LSLvTE8qLL7xcLPMmbqSPbWXw/G7btx3kQ2ldpE=;
	b=fG4sWzFzqFJvjTiUIGUasa/EK7/fGPbMC1vpvDErthnmzSaBC/k9o9tfQv3Q+iKOs976FN
	rGAPQ3kqz3ynTdhP2UGzE1GqSlBuzxHuijZJQ3NaVwFiZeNwAA0YgCpm7PUn0mknye6Ehr
	YAU7BUYzlB530GDumFyepoiIw4ujdh4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773234625; a=rsa-sha256;
	cv=none;
	b=eQYdtqxkKf9p1S95n1tPm/RhcEYbYI/VS+KQXgncwzozkF68aC/7S1hXbHcgrin7dYeOv1
	5X1Myu2WoCIdTwherVe6C1B4D1cRpt3+k81uyvEFVRy790p4sX5iRSdfMDTR8RRvMAr/yi
	vR53jZ9H+e8VoEik74kuYPjoHtOBAec=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWB1c3Kw7zHnGcW;
	Wed, 11 Mar 2026 21:10:12 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F04F4056E;
	Wed, 11 Mar 2026 21:10:20 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 16:10:19 +0300
Message-ID: <013c9fcd-bdeb-4508-8495-9ce9cd65b578@huawei-partners.com>
Date: Wed, 11 Mar 2026 16:10:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/4] mm/damon: Generic context creation for modules
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260311005759.90440-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260311005759.90440-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 41160C0016
X-Stat-Signature: s8zcw7b7r1s5idz7gde1am6u83qwmfr8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773234624-882081
X-HE-Meta: U2FsdGVkX1+AB2DVXTPyv0bok54slHp0ZEkq/yKwFKQINBRFMOdj2A4X+2hbuzjUgSQKWit60+5t7qicR8tGrH1jO0biQyriDObHx6QQ6wE+7zdsfo8x5IxBnIKcHeNDvYyvUq1IxAwl+JHPJiKU3Wqa9S6U/IvF6MaDIy24YjQEkXo4pSBz4RqWunsVjZKMaO40tP4EfOQ/IT4rHkKIa51vFMw3MJX9T1ujTXo0b/c/f7uBhJ67mkG4D/UfVHBPi+SRyEfVThqA1oW54uVsBqvjFXrvXgyqugxh6Da4WzpU3380BG3DYmQuUcQ+xgTaW1EIbdHcZ5tbx5EOfbeTQEHQ4J500tUz6a2m8EtmAVmcNHBqNbft9MdVjhS0LgdfrvMo9Bc+smY9Sm5+LUAbMmcfNc/GRw6JbtoWbuGq1/dn7WMFD/LOIpVpueTrvhIz23Oo282ngpEN+teSX+E3EIIW4KTzfuo5ncoN0wYvYnefNzfPkLAJlZInrXboPgWiZKPIgwmTq7laAFkwhJanJHoDiCESXhxoqNVFmqAKioj9f/2c7foQpFsybptBYDZfYVAKIpkoymAGoNFVUPbrProaT4Qphik2+UDvB3Bx9K42BnuyJnt046j5VtBsdqqpcoKiY0Z6wCEO5xyBCeXSCPoc7pR+EVc3fgBqRamaRBUB0hNZxjla1Iv2Is/i7kvzG44x+J2inN7rFwYLRALarWbzTGlwApz18SYxMz6F0Er/NRqRPHVMATtOj62LMLBlq/620USiaJIfdMGim95r/vBMS49nZHCJKB5L3ATnmFEjTF6VKmzOFHY2IfyMOpOvyc/M8acEDJ1Tm5zu/3+1LFyvAAmVf3clbicphM8ynW/HoZPK75FGCmZ2uFrlKQGuci6/18DZJgrr3QiyDgXMJpBhpPA+M0I/8xK+ve/QoyajH1mpixmtFjG2Wwn8PqNqin8joRI7vhJWBJI8pk1
 KXR/dtPh
 j0GXmjhV/Yxn+s5GTLw8KGZJW0tn4+uEQCmyL+wqgqWP7BvBuodELz/qK0rtol6Oux/Zs7oCLsDUjwr+GnH4SxLw/73ruOtPX3EKJhZL3/OTIxz+UD6C0YcNaL62xy437L933c8Mi9fE3cRvipnQ68GvQrGU5Ta1nQdaizzsfaOFbYBJOJyPaOknm7l2TW7B5U7d3tOXZiFJ/EZMRgygXBVRxsg7KE0PVOOi9SiRdYeIM3Gvft0EIy1HPPgXrLS7gaQmtjxEovBHjX0yT00nv78zQcyRH8Erx29wNDN10CvAmhW1MuNdY/MIdag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/2026 3:57 AM, SeongJae Park wrote:
> On Tue, 10 Mar 2026 16:24:17 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> It is more elegant to have a generic version of new context creation
>> which receives the mode as a parameter.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
>> ---
>>  mm/damon/lru_sort.c       | 5 +++--
>>  mm/damon/modules-common.c | 6 +++---
>>  mm/damon/modules-common.h | 4 ++--
>>  mm/damon/reclaim.c        | 5 +++--
>>  4 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
>> index 7bc5c0b2aea3..143ee0b21da6 100644
>> --- a/mm/damon/lru_sort.c
>> +++ b/mm/damon/lru_sort.c
>> @@ -287,7 +287,8 @@ static int damon_lru_sort_apply_parameters(void)
>>  	unsigned int hot_thres, cold_thres;
>>  	int err;
>>  
>> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
>> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
>> +				DAMON_OPS_PADDR);
> 
> I like the name of the function is becoming shorter.  But I'm not happy with
> the fact the resulting calling code becomes longer.
> 
> I understand you are doing this extension because you want a version of the
> function for vaddr.  What about introducing another dedicated function, say,
> damon_modules_new_vaddr_ctx_target() ?
> 
> And you can avoid duplicates between damon_modules_new_{p,v}addr_ctx_target()
> by implementing internal function, say, damon_modules_new_ctx_target() that
> receives the damon_ops_id.  And damon_modules_new_{P,v}addr_ctx_target() will
> just wrappers of damon_modules_new_ctx_target().

Sure, I will do it.

Since this is some generic code not related to the module I am working on,
maybe I can move this to a different patch set that we can upstream. What do
you think?

> 
>>  	if (err)
>>  		return err;
>>  
>> @@ -479,7 +480,7 @@ static int __init damon_lru_sort_init(void)
>>  		err = -ENOMEM;
>>  		goto out;
>>  	}
>> -	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
>> +	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);
> 
> Ditto.
> 
>>  	if (err)
>>  		goto out;
>>  
>> diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
>> index 86d58f8c4f63..ae50b2fa3a86 100644
>> --- a/mm/damon/modules-common.c
>> +++ b/mm/damon/modules-common.c
>> @@ -14,8 +14,8 @@
>>   * @ctxp:	Pointer to save the point to the newly created context
>>   * @targetp:	Pointer to save the point to the newly created target
>>   */
>> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>> -		struct damon_target **targetp)
>> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
>> +		struct damon_target **targetp, enum damon_ops_id mode)
> 
> Nit.  I'd suggest 'ops_id' as the parameter name, instead of 'mode'.
> 
>>  {
>>  	struct damon_ctx *ctx;
>>  	struct damon_target *target;
>> @@ -24,7 +24,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>>  	if (!ctx)
>>  		return -ENOMEM;
>>  
>> -	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
>> +	if (damon_select_ops(ctx, mode)) {
>>  		damon_destroy_ctx(ctx);
>>  		return -EINVAL;
>>  	}
>> diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
>> index f103ad556368..379b49c6a617 100644
>> --- a/mm/damon/modules-common.h
>> +++ b/mm/damon/modules-common.h
>> @@ -45,5 +45,5 @@
>>  	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
>>  			0400);
>>  
>> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>> -		struct damon_target **targetp);
>> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
>> +		struct damon_target **targetp, enum damon_ops_id mode);
>> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
>> index 43d76f5bed44..24786a58683a 100644
>> --- a/mm/damon/reclaim.c
>> +++ b/mm/damon/reclaim.c
>> @@ -197,7 +197,8 @@ static int damon_reclaim_apply_parameters(void)
>>  	struct damos_filter *filter;
>>  	int err;
>>  
>> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
>> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
>> +				DAMON_OPS_PADDR);
>>  	if (err)
>>  		return err;
>>  
>> @@ -381,7 +382,7 @@ static int __init damon_reclaim_init(void)
>>  		err = -ENOMEM;
>>  		goto out;
>>  	}
>> -	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
>> +	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);
>>  	if (err)
>>  		goto out;
>>  
>> -- 
>> 2.43.0
> 
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


