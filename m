Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A277CC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7A86B00BD; Wed, 29 Jul 2026 10:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897AB6B00D6; Wed, 29 Jul 2026 10:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7396E6B00F5; Wed, 29 Jul 2026 10:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E766B00BD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:59:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9510180684
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:22:44 +0000 (UTC)
X-FDA: 85041576648.11.B1119AE
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf03.hostedemail.com (Postfix) with ESMTP id C479E20006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:22:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rT2w4J14;
	spf=pass (imf03.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785324162;
	b=RtvOjzngh2FnP5iWqgSSSC618EevvHwDOR+Y7R1I0jqalNZCx07jh1okamyPzl8tLjyr1e
	j4tG8wi0WJimmIq+awBOP0gwXGHdzXrK3ybV4WOzuBxJNeR7Tu4jfmF2dYYhgiLwQKso+1
	PxLkuPMv808pGm/X7SkBxLjf/TdoeDU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rT2w4J14;
	spf=pass (imf03.hostedemail.com: domain of yujiacheng3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yujiacheng3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785324162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq9RcTPQukrz44sSQPDwwqwbVc0C7hhnfU9ii4SNZfY=;
	b=Tg2QOuROrwHCRSxcMoAleSyzDtjHnQfcxwx2LclVu8ATYLleiubJE4+xjJkHnm8s+dn4jG
	bSrGkRQBQvhCNwGNy1ZNynvur1N277Vb++DBY7g6esB6b7uX0yMPl+0haIZW38K31FcrNp
	DVJcA7QD0RT2Hib0zbmc2Ry55IqVR0E=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Yq9RcTPQukrz44sSQPDwwqwbVc0C7hhnfU9ii4SNZfY=;
	b=rT2w4J14eUS2GClp77ZiNXc7mj/P5T2aqIW9qZcCpNFwr7JPKAEZZpyC/3N3YCZ5CWZfJ7qQL
	ARJrPAQGKJd9Q7uhsvGUbvq3Ih6VU/7J11WyVjy074cRsuHZ1Je0NJ1dZh6tO257C6vSiSMXimk
	NqfSrlWEXx6GH7no99mjM9I=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h98ns1bBJzLlXF;
	Wed, 29 Jul 2026 19:13:05 +0800 (CST)
Received: from whupemo500009.china.huawei.com (unknown [7.152.184.116])
	by mail.maildlp.com (Postfix) with ESMTPS id 41B39402AB;
	Wed, 29 Jul 2026 19:22:32 +0800 (CST)
Received: from [100.103.109.247] (100.103.109.247) by
 whupemo500009.china.huawei.com (7.152.184.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Jul 2026 19:22:30 +0800
Message-ID: <b3ea698b-95b2-4f5d-ac20-e9e5cdf08712@huawei.com>
Date: Wed, 29 Jul 2026 19:22:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] params: fix charp corruption on allocation failure
To: Petr Pavlu <petr.pavlu@suse.com>
CC: <samitolvanen@google.com>, <rusty@rustcorp.com.au>, <hannes@cmpxchg.org>,
	<yosry@kernel.org>, <nphamcs@gmail.com>, <liuyongqiang13@huawei.com>,
	<linux-modules@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20260728085518.3865621-1-yujiacheng3@huawei.com>
 <dfe25916-0f2e-44ed-8f49-d7448a0e28fa@suse.com>
 <c9643f86-f196-4c99-8129-2314a33a990f@huawei.com>
 <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
Content-Language: en-GB
From: Jiacheng Yu <yujiacheng3@huawei.com>
In-Reply-To: <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.103.109.247]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo500009.china.huawei.com (7.152.184.116)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C479E20006
X-Stat-Signature: hktex6kye7q71ib4sohbfxz9pci4tgwu
X-Rspam-User: 
X-HE-Tag: 1785324160-60069
X-HE-Meta: U2FsdGVkX19ITnzog/+4vcxcBpZOWx9/X/3vD6lEYRl9IbOc4gUdiemIdj/4QlYD5Iefzxt19VFfCb1vQfNrzbcq+dRJG4IMi639+YVS5pqtdzqJaTdjT5z9SbpcTR/ozjZCpQFLoSsbQumEgkbJiNJjnyNvKtwOIbz+2XizrauuWY2NZmuXravtturGSBQff9H5TSY/0gVaD8eQaLPUKbL5XAT7HuKdSkqfM0pwHhpOiM6/MtPBskU02IAcjOcF4BgaJB5oEYtJmrTcJAYGfKwPyV10TgCpjf6xBSX2lCc9eRhGDQt9iJJBd4Hi9AGbSF3YQdf2KLqjvyRSFzosCy7R7/oFGP3GfA9su5bFSvr7X9PG6gArtMZg0s6dpTvkrQ72zsNKDEGrrPfoJa6DuOB1Ug6SIO43cCsJSZccqgiwqhyw6T8/bqOZKh1fUXn6vl6PAktuTupK99w6vtfsSwfMpDKm3PrpotkExv0VL7+EPvffz7JO3my+DEaJyeLHvVQ08cbxJ553Rts8YkqWZHoc4TwAc++QPvhh2DVPvDVUHPSr5JWOobsyhk3nG0S9qK71vS8Rt66+WLuzm4BgmMG4P1ShG3HqehTlXRgdGKh9d5deryu1TLYQFj+v72ovwKT1QeGcN165hgQznkzPPK+cPoPlNKHfIXV882KqNlu7FJAHuIno2AFaGY/42EzNlOyTb8t5qq+HLp0UdfHS3QlXz+38ONT6Y8zSKAgKnhrkMSOyth46+RyY7XMG+j2eC9zcgduCSMPKf0jJwMU6+jKzaO3qCtCKZGTyuB0XdLOK5KQo1uDj4GByVL0oJ/YN7DMPsxUrewBqRO3UtT2dE9wcrJSVhXHrMJ0Wz7PposJScLMYueSgvuHaiVd2kuH0jnnAZBwl1r30PvuagZKljTsd4VsS7wt0c4FabHIWHCnHnfqL9Yah8YURJUP6Rb9gBUfHTWbzCI326Sv4UTg
 au/VhFdX
 cAxHSg2A47mv521B5pAuvgKxiNbQYIW82+PgZvUYaDeCrgA6wN5c8rILJDiyxoFcSdg1txxi1k/bw14K3AvLIOvi5RU5t5cooiXxKs2qV58oYDduDXPWMPW8dYGbA16qlNIfckZX9Np4Wy16b5x6Z9AREe7eu/lIWhuzpo6mfPqZZvK/DOfZaTGk0oQuORTK7Ne5p/PggEwVIGyoFwSdgTQ2mDxc4GtUO24kwtWflht7IG20yetEE9v92wgKaK/HxxH9kVTULkn2XexBVGYffLYutgiKfwqNDFU/Prs4g33tZ7tj446HuSZ+AqdpePMUPNJhopTsSqT3OT9nFMx+UN9KwcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/07/2026 20:57, Petr Pavlu wrote:
> On 7/28/26 2:22 PM, Jiacheng Yu wrote:
>> On 28/07/2026 18:46, Petr Pavlu wrote:
>>> On 7/28/26 10:55 AM, Jiacheng Yu wrote:
>>>> diff --git a/kernel/params.c b/kernel/params.c
>>>> index a668863a4bb6..e4f2b71dde1e 100644
>>>> --- a/kernel/params.c
>>>> +++ b/kernel/params.c
>>>> @@ -261,6 +261,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
>>>>  
>>>>  int param_set_charp(const char *val, const struct kernel_param *kp)
>>>>  {
>>>> +	char *tmp;
>>>>  	size_t len, maxlen = 1024;
>>>>  
>>>>  	len = strnlen(val, maxlen + 1);
>>>> @@ -269,19 +270,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
>>>>  		return -ENOSPC;
>>>>  	}
>>>>  
>>>> -	maybe_kfree_parameter(*(char **)kp->arg);
>>>> -
>>>>  	/*
>>>>  	 * This is a hack. We can't kmalloc() in early boot, and we
>>>>  	 * don't need to; this mangled commandline is preserved.
>>>>  	 */
>>>>  	if (slab_is_available()) {
>>>> -		*(char **)kp->arg = kmalloc_parameter(len + 1);
>>>> -		if (!*(char **)kp->arg)
>>>> +		tmp = kmalloc_parameter(len + 1);
>>>> +		if (!tmp)
>>>>  			return -ENOMEM;
>>>> -		strcpy(*(char **)kp->arg, val);
>>>> +		strscpy(tmp, val, len + 1);
>>>
>>> What's wrong with the plain strcpy() here?
>>
>> Functionally, plain strcpy() is fine here.  The preceding
>> strnlen(val, maxlen + 1) either finds the NUL byte within the limit or
>> rejects the string, and the new allocation is exactly len + 1 bytes.
>>
>> However, when this patch rewrites the line to use tmp,
>> checkpatch --strict reports the following warning:
>>
>>     WARNING: Prefer strscpy over strcpy
>>
>> Since the line is being rewritten anyway, I changed strcpy() to
>> strscpy() to follow that preference:
>> https://github.com/KSPP/linux/issues/88
> 
> I don't see a benefit to using strscpy() here. The length of the string
> is already known and the tmp buffer is correctly sized, so using
> `memcpy(tmp, val, len + 1)` seems most appropriate to me.

Agreed, memcpy() is more appropriate here since the length is already
known. Changed in v2, thanks for the review.

> 


