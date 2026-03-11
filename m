Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 531CB106289D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8481F6B0099; Wed, 11 Mar 2026 09:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8EE6B009D; Wed, 11 Mar 2026 09:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722DB6B009E; Wed, 11 Mar 2026 09:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BED26B0099
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:11:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFBF11A01DA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:11:17 +0000 (UTC)
X-FDA: 84533818194.30.3F1B798
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF7A8A001F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:11:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773234676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aB8bB87GXT5l61YUdgvdLYmu8krexDzk3Lgvx96XokQ=;
	b=lk1nwW2USOLIHxwwnkNCIQJ85We5BolAE8tbVVLY6U7ZJeOCmxStC4zGbDiDrW4JetOHeT
	VmJNsyIupeXHr5WUOZNOuDITrMLYAbLGz3+c/E3biKGxiXoC1jdc1aT9bwOymPbIgU4Ltt
	RPaZuZvmprhzXvR6szd21QojjJvF95M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773234676; a=rsa-sha256;
	cv=none;
	b=v0Ur0lN59UJpJOyJmlX07ZnCl7abfmTis7Jm+D7OOIsI7Psw8LYjoHAC61ccSZ+cP00n03
	pXC0q0wmp966PYi36/ljEUDZ8xOKWPSpwZSnu3ItL1CJgmuXycq8fW06o++tCLfrm/iXlp
	ePgjMsxfUISb2Wo3PhCGWdY7Q8xB95c=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fWB1v2vZKzJ46Yd;
	Wed, 11 Mar 2026 21:10:27 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id A1FA440086;
	Wed, 11 Mar 2026 21:11:13 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 11 Mar 2026 16:11:13 +0300
Message-ID: <0c3068da-4dcb-4bc7-a762-2f529cb5abc2@huawei-partners.com>
Date: Wed, 11 Mar 2026 16:11:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/4] mm/damon: Support for synchrounous huge pages
 collapse
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260311010222.90548-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260311010222.90548-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: CF7A8A001F
X-Stat-Signature: ztz8qspkh81jptiof4eatebpa7ksp8ej
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773234675-384777
X-HE-Meta: U2FsdGVkX1//8+rqCinQ5LJJ4XlpNWUQGQx0RzTbjJ+d12gaqVP671pMAwRr6zt6kGoOKz8d19XPefUQI9Gvobm/yf1RfQ2sdUeXP3Mto+3HhhS9xEFbpdhFOLmzBoAwWYeTu2krtbxx8VQo/N6fJfZwFyYAj9XdoZlM2BAk3D5WO5Fwhrz9rrrWGuT7sqBVPQjZPSHCJLP+uyc9UvXgyfSxSEARV6VBZY3Ut2+M4AcnvxlmATjSGp85ErihsA64Qy+teG8nP5Uyb6Kg4DNmqYrB9uCDOnGyhPVJavGeYjgUS4a23D1+cVqMXoSYf/mAejWgYHP8c82ykABtUDo63+6tSlXN16baG/Y4bS+ZMWidx9TEUwMejwf+OV9ONr116yKW2sGA96YSIx8jnU2mYDsGPDwHA7CZJOm7SB0YZ5z2fl63H0S60kdz974BL7bMz4DkYpZoR2I/hEHrmyl3TKdPLDW7jr4ief4Bq6lvHOUiKNF+d+acxG6U8ouc1t2VtU3Wneb7doCwEDl1oyJN8BMwndA5o6RENH7W5Mg9YiAc3TE1hGf0t7LP47aBj+BhS2z/gz5z5LKmPZH7iBaBcDESgcKe1bF2xyBHh1pOAhyQaov7SoiQg25zGy+yYRnP6f53aY9igAUTZyOxlYDyGci+ynIvxuLtj9kC8LHSgdVYF5ruW+Tc+LTH9cJVqlepxdNejaf07JL0hDgh1LR/6e7ZHCFmPyQ0HHQFivO+J/e90DiI6tPK2PqIm4+i2QTt6O0XBrqUisvrcr9Wo+Qfv8ndqmxhN1UWxilxuwj+PprWst7Ge6yGAyWCE0A9D31UK0E/QjfHipscdYOkpANDPWvB39C83jbiYVF7szmel11I+Zl3V852j2GDBYIaasn3WPxgLpo+X/4LjtG+PW05NviDzkYLkIZSTIl5b8ukq+Uk9HIrdxOwzWhD2thozUa1chD7ggjAdQLohGfAcRN
 BCjWl28j
 2E0/7z76DRh+efQa/sbgjekar9ADV0Z8JFuBpXn8P46dPAZbMCUaZNd3kUmQNEZ4IesmH3y1wACTmyxCpFNLfwY1Lq/ZNBQC/s8vXr66GtDLQXobzr5gDWPSD3Ux2RF3m1E1NYOCt9fvX3DQv/TlEHcR2PXBAK+pmr1MRmBd2/T0pOhnddiITpwz8+qRuPKdnoDAUr4FxPBBdQkZ2gJ+Uc68dcSd7l58bdBRW1/CXZRn2acJG0Q+vOoeyR7/aekQv4WUk8p6equYQhi59a6WbYcpgJSbFDNrkvrNUHYULN/68tKzUOHYnfASmAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/11/2026 4:02 AM, SeongJae Park wrote:
> On Tue, 10 Mar 2026 16:24:18 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Please add more descriptions of the change, including the motivation.
> 
> I assume the motivation is similar to MADV_COLLAPSE that aims to make
> synchronous and therefore faster huge page collapsing impacts copared to
> MADV_HUGEPAGE?  It would be nice to make it clear here.  Also, if my assumption
> is not wrong, adding a test results showing the benefit of DAMOS_COLLAPSE over
> DAMOS_HUGEPAGE here would be nice.

You are right. I will make it more clear in the cover letter for the next
version.

> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
>> ---
>>  include/linux/damon.h | 1 +
>>  mm/damon/vaddr.c      | 3 +++
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index a4fea23da857..a9cf17b9e8fa 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -142,6 +142,7 @@ enum damos_action {
>>  	DAMOS_LRU_DEPRIO,
>>  	DAMOS_MIGRATE_HOT,
>>  	DAMOS_MIGRATE_COLD,
>> +	DAMOS_COLLAPSE,
>>  	DAMOS_STAT,		/* Do nothing but only record the stat */
>>  	NR_DAMOS_ACTIONS,
>>  };
>> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
>> index 729b7ffd3565..36791a9a1094 100644
>> --- a/mm/damon/vaddr.c
>> +++ b/mm/damon/vaddr.c
>> @@ -969,6 +969,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>>  	case DAMOS_NOHUGEPAGE:
>>  		madv_action = MADV_NOHUGEPAGE;
>>  		break;
>> +	case DAMOS_COLLAPSE:
>> +		madv_action = MADV_COLLAPSE;
>> +		break;
>>  	case DAMOS_MIGRATE_HOT:
>>  	case DAMOS_MIGRATE_COLD:
>>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>> -- 
>> 2.43.0
> 
> The code looks good to me.
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


