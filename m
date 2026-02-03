Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B48FE87828
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7615F6B0098; Tue,  3 Feb 2026 08:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F47F6B009F; Tue,  3 Feb 2026 08:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E2F6B00A1; Tue,  3 Feb 2026 08:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8136B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:04:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED6FDB9A89
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:04:24 +0000 (UTC)
X-FDA: 84403164048.24.2978C73
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id CCC3880012
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:04:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770123863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhNOXdWcnpxCAeda4EqcUYR/qZwc2dBES6WTEtEejDQ=;
	b=lN8f06iWE0jvl5IEoRLrJEnDruHxHljsXafYFltRamiPN2+20TrgoFtQ40R4ZH8BsXMWFD
	c+xzlmzkkE6+1KrfEkU+/YFxAdvYKU3iq1Jxs8eD8fWSkFjmCyuDtElKPh2w8iHbbv9/1T
	r5ei8FzsipLwutYZpD8/2bT0u6WLYEc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770123863; a=rsa-sha256;
	cv=none;
	b=SMv01HYopu7LD+daZIEGiVBzdeoDVOh5h86OzbNNtWZRS8NoRHlYMw6ZjRcTonTBmkLoAi
	969muI9DHhzGMVWRrZmilNM4FPVlGCzBzfwREGYVONjNVc4d8KyrKeyppwqrI+GwGhFR2T
	2HNu0NOgl2L6KQuCvE3Ps/PEmKVSyJ8=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f53ZK1mvqzHnGdW;
	Tue,  3 Feb 2026 21:03:21 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A41F40572;
	Tue,  3 Feb 2026 21:04:20 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Feb 2026 16:04:20 +0300
Message-ID: <38d2f33e-03c1-4b33-8e0e-1a38ebbf3305@huawei-partners.com>
Date: Tue, 3 Feb 2026 16:04:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/4] mm/damon: Generic context creation for modules
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260203011633.67532-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260203011633.67532-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam11
X-Stat-Signature: 54xi57fcxarrf5xgg79whw6g9xr95jfh
X-Rspam-User: 
X-Rspamd-Queue-Id: CCC3880012
X-HE-Tag: 1770123862-910563
X-HE-Meta: U2FsdGVkX1+lMk2aSWesSGNWKv76wE91JUWZqjYgFFpGH5UyxxpMaQk6wiOrOYtMOv2klb1L4Ga4vRpd3eXGvQSHj41NggHkMzNR7M68ayLE9c8nxPJT6JeQFGLw6cbDBuWnGPnjroAwnysrGRU0NsBK1DoAnAMBBvZPU4wu8pKiKSoQbZbBFerVxyoNTWQX+0GGBSIYlS5h9GY7xfhBUI5IsZINeGWfMqxwStTnF71Kc3coS2YVBpzj9ZSd85U62TjE/2MGeqAl92JEQUoexH/Yyj8Ifd4apYrBGAfXgkZBMp3D0D8fqyZeH/m4nQ+Rr9l6mb2ZSFmiPJrjISuOKySQNFJgWuiLJThJhDWFZXMwKJnr39renxYjey/sLUyU4T6pLnkTq0wdV1VdFrMOGe91s7i/3FZqdEmLWP9Wgeb7wH/Et1Q9E5wlmAKhaYP8VtA4dmyK7arOECEnFJXUgHFEPVzQwZAzMGM4pvnmW5BOBg5sXnXXlWvqKFoGYrzw4+2YVICRzxBXhKdvLAtI+pyjnTfpMxY18wIa2EmBnlJ2uwc4kAvy7evAvWGtI/j1QEq6QgGAxoclrIqa4q4pLKokQFXwNOIkNSvw7exKS7Wd+4r6jDBOs1NTJ/6CQ1RU+nGbjJk7M25HETEgKrwKqrbfDSMVebDurKzMLjc2Os8u5FWVqYOx+cBR8kbr0gFW2a1VdSSxuTmKQ1BX48d7KYm43swu9hvKNWrdJjw1eb+r9vEonjRggnYi2IsIfAOZkd4J8JECze01qet/3+Q8va26CH387WsWdLphwtqNvfDvwE/gkIPdBcz7wkY2LbotCqYriVPb/B0rI1/njjpqSJsh0o4bJuEvFyMrEoZaX3GidyOZN29HewnRbJtuRFQlfzhv0xUj3SpmzVxPuYMUNhubovha7Zrwr0t80DKy4ji9+0I4X2slBBps5v6dFaq34+L905o5XKvL6guI6h/
 D8yu4wqw
 K0/1tnLxVrZ8ZhpRLKGG+KVCfUNFmf9R5X8d6slozqm83lOdhU/yDMYwQEWqFp2g1VcbtfDkC4qLJz2zE43oaR6nW3qynkfYqQm7mnKh7bzyh0/hotj8C43dzGTK99xmLx9Q5GV6/FgBSOfe6JR7co+YTxVlsuv0CyVJ7nJw4BoonaHhvifq4dG26sattESFNNAeO3zYy2C3nP5pUD+Rxz7gZFpJs6MZZrQ0EzcvtqfRi8dBCMyjLlaTdPecHGSiL2lCwkz/fUEWHDz10wEaJlwvJtznOKKBJhyfgnklCQdlJqXGVioX/fhP/cQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/3/2026 4:16 AM, SeongJae Park wrote:
> Let's use 'mm/damon/modules-common:' as the commit subject prefix.
> 
> On Mon, 2 Feb 2026 14:56:46 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Damon_modules_new_paddr_ctx_target. This works  only for physical contexts.
> 
> Let's be case-sensitive.  s/Damon_/damon_/ ?

OK, will do it.

> 
>> In case of virtual addresses, we should  duplicate the code.
>>
>> It is more elegant to have a generic version of new context creation which
>> receives the mode as a parameter.
> 
> Makes sense to me.
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
>> ---
>>  mm/damon/lru_sort.c       | 6 ++++--
>>  mm/damon/modules-common.c | 7 ++++---
>>  mm/damon/modules-common.h | 5 +++--
>>  mm/damon/reclaim.c        | 5 +++--
>>  4 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
>> index 49b4bc294f4e..ac34b02dace8 100644
>> --- a/mm/damon/lru_sort.c
>> +++ b/mm/damon/lru_sort.c
>> @@ -201,7 +201,8 @@ static int damon_lru_sort_apply_parameters(void)
>>  	unsigned int hot_thres, cold_thres;
>>  	int err;
>>  
>> -	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
>> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
>> +				DAMON_OPS_PADDR);
>>  	if (err)
>>  		return err;
>>  
>> @@ -375,7 +376,8 @@ static int __init damon_lru_sort_init(void)
>>  		err = -ENOMEM;
>>  		goto out;
>>  	}
>> -	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
>> +	err = damon_modules_new_ctx_target(&ctx, &target,
>> +				DAMON_OPS_PADDR);
> 
> You could put the above line on the line before that without violating the 80
> columns limit :)

Sure, will correct it.

> 
>>  	if (err)
>>  		goto out;
>>  
>> diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
>> index 86d58f8c4f63..5ba24e0ad9a1 100644
>> --- a/mm/damon/modules-common.c
>> +++ b/mm/damon/modules-common.c
>> @@ -14,8 +14,9 @@
>>   * @ctxp:	Pointer to save the point to the newly created context
>>   * @targetp:	Pointer to save the point to the newly created target
>>   */
>> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>> -		struct damon_target **targetp)
>> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
>> +				struct damon_target **targetp,
>> +				enum damon_ops_id mode)
> 
> You should also update the kernel-doc comments for the new parameter.
> 
>>  {
>>  	struct damon_ctx *ctx;
>>  	struct damon_target *target;
>> @@ -24,7 +25,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>>  	if (!ctx)
>>  		return -ENOMEM;
>>  
>> -	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
>> +	if (damon_select_ops(ctx, mode)) {
>>  		damon_destroy_ctx(ctx);
>>  		return -EINVAL;
>>  	}
>> diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
>> index f103ad556368..87d8058d7d85 100644
>> --- a/mm/damon/modules-common.h
>> +++ b/mm/damon/modules-common.h
>> @@ -45,5 +45,6 @@
>>  	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
>>  			0400);
>>  
>> -int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
>> -		struct damon_target **targetp);
>> +int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
>> +				struct damon_target **targetp,
>> +				enum damon_ops_id mode);
>> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
>> index 36a582e09eae..b64fb810e096 100644
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
>> @@ -379,7 +380,7 @@ static int __init damon_reclaim_init(void)
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
> Overall, looks good for RFC.
> 
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


