Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D41CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700858E004C; Wed, 20 Aug 2025 06:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8DD8E0003; Wed, 20 Aug 2025 06:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6155F8E004C; Wed, 20 Aug 2025 06:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9278E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:06:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF034C049F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:06:31 +0000 (UTC)
X-FDA: 83796706182.29.0BD16D5
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF10BA0014
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:06:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755684390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mT1KpX+qBzrr9j7IhtfheFOCHVRO5UKV8878fxDZ3KY=;
	b=IV2tSqr5XvPNk7tCOjE+qAipQ0D2rCHNWyV089clK5n5nXjaRLFvrWlxWJt8BfoSSNweNR
	mB0Nw625QHJg0H1idUxyEMdm2+n5chc1XeoCB/oB51X+HKFonBrgko/GWAlMo1tKyTO8nW
	bORuqyAFdKEdEbw1IRrNgb3lIji6u+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755684390; a=rsa-sha256;
	cv=none;
	b=XHhb5aXMkB6r8RcQUTkF4Dkn0gfs5rHPVgnCrPBpy2p1fXA6YBEj7OuOy3tFWk5uL4Lr1Y
	rgogNWoq8S5cJHrGvyWfAlDVw9VSEMDxxjn3PAaPrlrqM95qD+PkAr3MlCMsWXVXGT4L8n
	WaoB10ZcrxuXHBBx29NYVV1GXgYx764=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c6MTt6gyNz2gLJt;
	Wed, 20 Aug 2025 18:03:30 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 118B81A0171;
	Wed, 20 Aug 2025 18:06:24 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 18:06:23 +0800
Message-ID: <43c2ce03-04ac-4da4-a9e2-7f1393939d14@huawei.com>
Date: Wed, 20 Aug 2025 18:06:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 16/16] mm/damon/core: handle quota->esz overflow
 issues
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250813171521.6482-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250813171521.6482-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF10BA0014
X-Stat-Signature: jub8cwyz8ta7fzii1r75a81sj8cywtsm
X-Rspam-User: 
X-HE-Tag: 1755684388-424735
X-HE-Meta: U2FsdGVkX18n4F5+x4olXu5ScL9gD9atCf6z6lH/xYASVpql2e9B571JqpVRTxI7JMc5om+esa1FE5kKjuxjTHqXlSolmx1xh0nMjCR/ArpqyjJNTt6SwPYfA89paQtbePGykwpGO6ifcmo+QDupr8xn1Xluekvt+2Ch0Mdo0ZnRBIzI8a06IqbIKst14eRkVqtjxU7BJEjzW8AwOCKwct3TL7v1UFYp2qeCdqKUMDfYTVf2ZbWXsPkaA9GMvw/o81qwfA0VkjxkDgvoPRA0+bQkd3SdJSI2VJN4uYME/rKqBs94L7bA+tP6iuaUGh1ftogM0i/f+oWMoklcJbdseWsmpCO11SikMm/8QJVxSsQ6xiIbSmkrLMQf9lioPbq7zgr5twTzTz5jDgfacOFAKUC6F8L+0Y4nCVdUmmQdPaDVYJ5mZkt1M4U9TVx8gvK328/Ar4RjFA9iP0rh1tChmEkC5k/oinfQvPsPkMZpc/iTLtb/iNkYl+fsHrxLvO3l8yMyJOCOdtiPEvdWycynpbk5af2MCwnFSpLF+nWD1OQ5Pb2EB+zeZojgUlex4g8NZh1lefc5doX4K8GTa+JI5Fxaj6I7n0DP8LxwBGOWfWaNFCA41v+FKxtjfSO5GiGPGhO2sUKr+GJn8l1Hu/aXaxIWZgvPk/yo2sq2tmS2lHOZ+w1f42riXcXU0v2r6U3vCW5BWuRGX59WkQN7MmvVHSSnRG2nozjlHbDzfMhRKFE+XrnLuDsAuG+hO86d9HDbqkfaRiJ8dIbht1yPxQQmk91S42yN7su8lu3iVfSvjacaGhFfgC68QEMW+545DsoiButhqJXM16kMOKe80wkHJS3oUXfzSzAOlMLUBvcKP+7CZhDadKKcdbM0Kav5M6/e4/XtosUBeMVLQFTG9RVNfhYkH9Cq1YOgKgSVYFH1qBlQcnAdoucpyFM4L1LsE1DRrSJNWfTvOvE47JnQkgy
 wNm6Sz4u
 HoY4LD+ghIqaMV6oxDKQUrixT7BaAAjkmuQvX2Bvzjqez3QhMgFPFVbYQkiwkbZyEuL+UXMXqtO9v7jD2qHq2Jrd4izw5YWfvsfFDCY5ixZyWyDmxnl+MnFrPhe0MxWYRpqTRTLli5rqOQZ2+BCwrOYPB2pPYRw6alhsreGKD9WoHEWHT4Hl3ThbHETVfBywqYDEYQm21b9v3z+Y4PogfY+YB5br81do6R8MqY/Jn7lvwVVpfu1YMDUhRpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/14 1:15, SeongJae Park 写道:
> On Wed, 13 Aug 2025 13:07:06 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> In the original quota enforcement implementation, the traffic
>> calculation multiplied A by 1000000 due to time unit conversion,
>> making it highly prone to overflow on 32-bit systems:
>>
>> damos_set_effective_quota
>>    if (quota->total_charged_ns)
>>      throughput = quota->total_charged_sz * 1000000 /
>> 		quota->total_charged_ns;
>>
>> Requiring total_charged_sz to be less than 4GB/1000000 is unreasonable.
>> Additionally, when overflow occurs and causes quota->esz to become
>> extremely small, the subsequent damos_apply_scheme logic permanently
>> sets sz to 0, while quota stop updating, ultimately leading to complete
>> functional failure:
>>
>> damos_apply_scheme
>>    if (quota->esz && quota->charged_sz + sz > quota->esz)
>>      sz = ALIGN_DOWN(quota->esz - quota->charged_sz, DAMON_MIN_REGION);
>>
>> Total charged stats use the unsigned long long data type to reduce
>> overflow risk, with data reset capability after overflow occurs.
> Thank you for finding this issue!  I don't want to change the data type if
> possible, though.  Could replacing the easily-overflowing throughput
> calculation with mult_frac() fix the issue?

Thank you for your guidance, it does work effectively. The relevant changes
have been included in patch #12 of the v2 series[1].

[1] https://lore.kernel.org/all/20250820080623.3799131-13-yanquanmin1@huawei.com/

Thanks, Quanmin Yan


