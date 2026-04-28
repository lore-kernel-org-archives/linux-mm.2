Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73007FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA4B6B0088; Tue, 28 Apr 2026 09:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A706B008A; Tue, 28 Apr 2026 09:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C979B6B008C; Tue, 28 Apr 2026 09:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA4466B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:08:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605C91A0174
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:08:20 +0000 (UTC)
X-FDA: 84707993160.05.86E2350
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5E84140015
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:08:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kk0WHjuF01vkNzZLgqz7nsJJvY6cecoDepFCPRY+1Q=;
	b=yfzYFvLxafmbOtXru6F4CHqu2+VwOYMaUUfFVTsfM8Tb00kzR6mo7UbUG75/E/KayA/Yh9
	ZlSmBFwNxSlXslkRo2X5bcjRb4WwV1kCIZuozcjG1TgSc8//WvJOdrOruE7lHxrPJm8BrJ
	dzuW0tDEVV1Y477OgiXL3TkYa08D6Ro=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381697; a=rsa-sha256;
	cv=none;
	b=8Fkez2CfggmOiQ3OoJdkp4xcC+oaIj01rK6QDW9QdPWLgiEX6yr6uVUnTVINxOwOSQuOmN
	PWCD0NAcB9SmGZO7t+6PtW7Z5Euh8i3joce2BG6IJu+89eXXC4D/pLpV+8da2hOiApYscZ
	5BLKDtiRJ9lX/QoZU9EGMSdY9JLtFFw=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g4ghK5MYZzHnGjW;
	Tue, 28 Apr 2026 21:07:29 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 937D740569;
	Tue, 28 Apr 2026 21:08:11 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 16:08:11 +0300
Message-ID: <b9bf118d-05e7-4b2d-9442-8568108eb106@huawei-partners.com>
Date: Tue, 28 Apr 2026 16:08:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 14/19] mm/damon/sysfs: setup probes on DAMON core API
 parameters
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260428004830.113597-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260428004830.113597-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: B5E84140015
X-Rspamd-Server: rspam06
X-Stat-Signature: cj8ewsu3tj9gpn8o863w6nm7ysympju4
X-HE-Tag: 1777381696-457368
X-HE-Meta: U2FsdGVkX1/ZlAgf9dKZXMaUPrGCilZfNPuKerqnJh9GVm1CKiUFLay+ivWn+y05Sd+XomVPvLrkiVKEmQ2g3NFT/ijQQeHP6bWjYL4++RAGI/Yme4OV3OzCPCE4Nq8meQPbH5JbLWZ30fzqGZnYsseJisJyEs7jqO5z/paBjHLln9J7MgFY2LCLfPOco7Q7r2e/t2JkO4Kcs+uEdWyGoDT29y1HoO6wCK2n7RnN0MmyS7IVnhuuZYlPWGgaJ68tGhGjskBMfyQ2BwDypBka5+gqEH5FTNe8sX/A/30JdsdXQYUO8g6vFGKAGpkjBVqGciOvl0oKF6PAOJP35ghnDJJPbWIRI3pzXzeGVT+X2xakdQgw9qhv4FBCpoV6kUW/TkQAb4ljWYaXNYeQ7+7zwK2ujIo/tcTKB966jTh+VB/Rk5yRPOgtxvtAjDOTpw8RfUoUFp2AClCBpDyeuI/ZRptWiRuS1e0q2wpaxAviNvB73td2bHh7l3/gznnm0WMkw48MDbv9V3dsWvJCrYmBOVH4TGsX0wRPByIZ6+bj6kKsBV+p1Ws+nT7ibX9MUxr5WWMUzgTJcSExd0Ey4PAi+F+zsWaN4g+dqdVqQ4nWBLEWYEOj3oHkNRbd0Kn971pt75ShorlkGmdJFbIGc6xp+fknDdzeTk8B5BMUVN9cEaDVIzgdlPM7J75MFMTwB5NK93EIN0tRt4vv5TCTkrne4D9Cchy64qCkko8dqwlXNOGMw/oU8TZgtVS4SgpapyGdWFPr3FdGXFLPU7j7oJ3E8XVqy8rvBMEboggQq06b9aaAIb10ZhL8d0JUxbgyIK5FVbq8sWI928xDiBKen8kMzQ3AkzYLlZ/4ddUnKk5Ym/OKAS43zd/vvS2RUygWFMRyBtNCUbp8/Ggq+Lj1lC+p76EJFrrUwE9DPuNTCPq+5tKBepzMtlSxxOFrgKPIjaVXPqmSPvgZX6pUxi9hkfx
 0R9V+g6p
 OPmO8tI2NHiKpBlDizLtAlc36xzcA9tczlcNwZz7VR4P4fO0CGGhG4naKRRS3h4m4Pqox/T8+O8sMNiYAZpgfItD9i3AVdlrPFB4r1ok4lge9pio1SMh0QVqf4jhrpdrM0jlvTOFKo1pPG2SFqoeH1FBkZ0L8nIplnU/Vr85OVWR2c/Uc17J8Z0P2pW24etNZg1vZfIvd/nuSi3q3817njYBO0WH/Fi6Y9fw34VWf23MI8IOXSu+nKRoz2b0FVBj+a+yu3IsBznHS0pQ5qJbteY8IZ3B4u2Sl2un89Ta5b4Lz34oTcg2EvumSVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/28/2026 3:48 AM, SeongJae Park wrote:
> Thank you for review, Asier!
> 
> On Mon, 27 Apr 2026 16:25:12 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>>
>>
>> On 4/26/2026 11:52 PM, SeongJae Park wrote:
>>> Add user-installed data probes to DAMON core API parameters, so that
>>> user inputs for data probes are passed to DAMON core.
>>>
>>> Signed-off-by: SeongJae Park <sj@kernel.org>
>>> ---
>>>  mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 37 insertions(+)
>>>
>>> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
>>> index 2e0b7eca6bcbf..8007961295d3d 100644
>>> --- a/mm/damon/sysfs.c
>>> +++ b/mm/damon/sysfs.c
>>> @@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
>>>  	return damon_set_attrs(ctx, &attrs);
>>>  }
>>>  
>>> +static int damon_sysfs_set_probes(struct damon_ctx *ctx,
>>> +		struct damon_sysfs_probes *sys_probes)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < sys_probes->nr; i++) {
>>> +		struct damon_sysfs_filters *sys_filters =
>>> +			sys_probes->probes_arr[i]->filters;
>>> +		struct damon_probe *c;
>>> +		int j;
>>> +
>>> +		if (!sys_filters)
>>> +			continue;
>>> +		c = damon_new_probe();
>>> +		if (!c)
>>> +			return -ENOMEM;
>>> +		damon_add_probe(ctx, c);
>>> +
>>> +		for (j = 0; j < sys_filters->nr; j++) {
>>> +			struct damon_sysfs_filter *sys_filter =
>>> +				sys_filters->filters_arr[j];
>>> +			struct damon_filter *t;
>> Move the declaration of these two variables to the top of the
>> function.
> 
> I have no strong preference, but because this function is not very short, I
> think having declaration here makes reading the code easier.  Also, this style
> is used in multiple places of sysfs.c including damon_sysfs_add_targets().
> 
> So if I'm not missing something and you don't mind, I'd like to keep the
> current style.

Thanks fine. I just got used to declare the variables at the beginning
of the function to help the compiler optimize the code. But modern
compilers may be smart enough to figure it out and optimize the code
anyway.

> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


