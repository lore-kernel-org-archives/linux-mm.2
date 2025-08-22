Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C57CA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 01:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DCF8E006C; Thu, 21 Aug 2025 21:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E5A8E0056; Thu, 21 Aug 2025 21:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B245D8E006C; Thu, 21 Aug 2025 21:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A29B38E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:29:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D853138D6F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:29:14 +0000 (UTC)
X-FDA: 83802660228.08.CA43C43
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 11DE040008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:29:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755826152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqneR4OMiJj94GUAvGzQIHoAOso1YSo6DD6Fl8l+VLs=;
	b=Cmk4hopkeoZXmNKKa8gkSFjjC4mGcwZpxDrMbrkXprbOfgkhynFeHln+Qarhic1/oLJkWh
	9xAPhGm3Ve0m8Fcc/WM0nKlvrn84IFBMi/93JkMzzUtw4Ko7Dnd5Zut+UG0FjugnAadwXu
	vnoirtXn93uecsWbP5JLY9ConWNBfIo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755826152; a=rsa-sha256;
	cv=none;
	b=u3OPpJhkskx8L3GdoEllzDMfHTIbwE7DDDVuLWg9Xe+dFHiioLkni/hJ5PJbYAq9Fhhm8Y
	SBybrUTYLwBhhBF60VxPZYaltgUqzEGvPfo1u4SOvpc5HWnyzYL3F5VysUN8mUT7MuT387
	QfY6mst0pidsKjGy4NT5WBhpWguYpBw=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c7N0h06xzz27jH6;
	Fri, 22 Aug 2025 09:30:12 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D1E71A016C;
	Fri, 22 Aug 2025 09:29:06 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 09:29:05 +0800
Message-ID: <8b3f1571-6510-453f-96d4-f365eb10d02d@huawei.com>
Date: Fri, 22 Aug 2025 09:29:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] mm/damon: add damon_ctx->min_region
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250821173320.82616-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250821173320.82616-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 11DE040008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dd19zd5j4kb8g35dqejjn1u8e7dttms8
X-HE-Tag: 1755826150-510917
X-HE-Meta: U2FsdGVkX1+ovVGs7HackXNB8aXAywLBJ6FaTc1Gl1UKywvzcuoMHD/Fz0ClQTfQ+/1GhIDdPXoeXQrlcS7w39Ka7VjZcWZgG9VdbQKr1q/qNMiGFphtzS0xmG87tDO3fEsVNECW50ekccrrN49T3qKbiWN7sZYlnLey3d41MrUiAtO1626LzQdIO0bqBQER9W8zzjAJ65tMR/kyLnPOmntWNDD6wFxO4PPK0yotIL4e1jq3Ql/EElJnpttdF46Y8Be/JwaCLmzzsqL2ODWaXSfyY4oRDsg3Fr9BDRC7nkzJohodJrIKnaWiUuLbYmJuHrsc4fx6b2qiu9FDgCOgG+jJbw/3+ZxtDHqUcQcoz8Cok9tcbbHCJE+Q1onL24tP4wNZf4QJ4K36VMHLqmf1BKTBjEKoK//b94JYnxImj9ni6hmnAI/53FM0fHqgWA+G2BsxAXW77wvB3CUmCY8mble00srJyR49/xiAFNVyb2u+Bnyk+5eKfD8jB7V4sRt5Tnm8+h6MmXCLN5fuqQroaovhmIHWp9AkmN6ADLD4omIjgJk0SjD/EZdZ21u5VrYUJ1nOgXIjmYI3z0IeE3oVZ//vnIIrr3X8UeHFHiOQSkrvx31L5ZOxoo66TPTAS3YlB5mk6/m5hi9F2HqUNM8uUhVr8z7qf8CNGYt9A8r3PHipbQQhaHWfrLdTm312FjZFJ/HjrP8eR0vxDBv8hlyVygNfQkgOT6Us13C3CAj5VAV6SkwJsXratEY2/swPpyte1w5Bxj2wPn1EryQZwi5alaEAGyXnoldq1a47KPJZXiSq56QWwd8938E1Sh+uQRqSNmKfUX/6/tgCqrQgBK0IuteND1sMt7VvABdzuQZbNvXTOrl92KATzGqJEzOmJZkffmhwFyNFVeNuMee9UaTIkkKgRyUV2ga5EvCbdeEWN7Jcgq+HhmxbTP7+QPaFrBfdOeH/yG4OgGpwvb8KWXp
 W7hols4q
 ql5bcbQYch17lOrKs6JcmdwmDDqNgfb1arTB2moUgt4h8nBArxdNM4bjawsE1cVrvuklgxIsRmaJUDyxT6v734Rdvi19hlpL51eDGEM8ajwtoC160bBpRk5wa2reHB9Hk1NsEuHAmWIh4If2jwXRsK/Wl9VqW3xMnvY2Wc/IzsxF9EAmiC0CJr39g0V01tgqba8FYwh8FceRS4Da1TvJbQ+lzi1KP3127SrKgGZiFgxjsx+9Nody5Pi3jIWp1tVMtNXf+sfHww8j3e26ec3MAjMTO1D4QUm5lTZM9Ub+IwzKL9M5AEUJVNCzTieO1Qx9eJuB0T/nr+xMVZLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/22 1:33, SeongJae Park 写道:
> On Thu, 21 Aug 2025 18:51:59 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
>> bytes and cause data alignment issues[1].
>>
>> Add damon_ctx->min_region to change DAMON_MIN_REGION from a global
> s/min_region/min_sz_region/ ?
>
>> macro value to per-context variable.
>>
>> [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com
>>
>> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
>> ---
>>   include/linux/damon.h        |  4 ++-
>>   mm/damon/core.c              | 67 ++++++++++++++++++++----------------
>>   mm/damon/sysfs.c             |  8 +++--
>>   mm/damon/tests/core-kunit.h  | 21 ++++++-----
>>   mm/damon/tests/vaddr-kunit.h |  2 +-
>>   mm/damon/vaddr.c             |  2 +-
>>   6 files changed, 61 insertions(+), 43 deletions(-)
> [...]
>> @@ -1248,6 +1253,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>>   	}
>>   	dst->ops = src->ops;
>>   	dst->addr_unit = src->addr_unit;
>> +	dst->min_sz_region = max(DAMON_MIN_REGION / src->addr_unit, 1);
> Can't we set this as src->min_sz_region?
>
> I asked a same question[1] to the previous version but seems it was missed.

I apologize for the issues caused by my misunderstanding and carelessness.
I will make adjustments and release the v2 version as soon as possible, and I
will not make similar mistakes again in the future.


Best regards,
Quanmin Yan

>
> [...]
>
> Other parts look good to me.
>
> [1] https://lore.kernel.org/20250820215612.86678-1-sj@kernel.org
>
>
> Thanks,
> SJ

