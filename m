Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D53ACA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4A78E009A; Tue, 26 Aug 2025 00:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454128E0090; Tue, 26 Aug 2025 00:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5018E009A; Tue, 26 Aug 2025 00:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 189468E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:51:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7890160623
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:51:27 +0000 (UTC)
X-FDA: 83817685014.12.A387ADB
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F706100007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:51:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756183885; a=rsa-sha256;
	cv=none;
	b=juDi/GCp9Rll2xqg52KtCK49rJlnkm1z9JjySw46iotHN1tUyh/R6d58V6QFrtML+X9MIu
	u1auJ321QewOt8Ow+y27I5ArSoNSalCC5DjVUG1vNG4Jz47XBrwg1k6TM84gU5E+yBmK4x
	1RlZAhhCVhRHMb+Rd0lWj51lqaoSbqo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756183885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4QM+WoTb8pDcH86Cw/St7lw7mD99p+wnTDOnYADp+Z8=;
	b=axgBojVJ/y5qMxp1hWUBTn6B1WNJ4ABBXC5sTVOJTneiPsk+MmMd3drEueyxwDd7ANDot+
	dxQUN49DqZ2hbstPIqbbnyBR9Tw7G+71oaomCMkpwry7t5O2bjxZ8kzwT3O7q0AtnNaxD3
	lcUa3HCdrKbdzVVyq5Cl8OaM7IOIVH8=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c9w9p20mBzdcDr;
	Tue, 26 Aug 2025 12:46:54 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id CB6621402E9;
	Tue, 26 Aug 2025 12:51:19 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 12:51:18 +0800
Message-ID: <464f9f46-6ed5-4a78-8e06-878869f2afc4@huawei.com>
Date: Tue, 26 Aug 2025 12:51:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>, <kernel-team@meta.com>,
	kernel test robot <lkp@intel.com>
References: <20250826032144.49491-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250826032144.49491-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 7F706100007
X-Stat-Signature: eephjfzmp5mcaxm1zb6cjn7a85qechq1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756183884-793191
X-HE-Meta: U2FsdGVkX18+MiqOx+2zTNNmio5PQzzk9VUO5Rn4kTdY1GT9AxRDNGtPnSpvo1G2U9PIJe1/Q6GlhZkL7rqt7NRoC52m9O+gQ+VCM4tc0LJaVdXftpHlzbrt5aKPoDp37OzAXA4SmDEvfFMYEk5juNWT8DR39Lg9MCvVcQw+oBjA4wCaYBqJKicOWlfOsOsxCqfQYa8XJlz78OE8Sa6847CuOxICDDEjT0uCeWLX+1F/3u9rxLbm/3MVkenIU6Ov5+0gsSQge3MsIWdy1T7o9SZ3Sv4eqffJLNoILRflN2RDRlXsTfSrQgAEImlB6qpfkWPGeryRQTxVwyFO4wj/oxsLd3N02zfwPVR8voURoMNBmQnFac9H3d4xFNWzQuK5YO9LSOBFzVL5gErH5NXRfYELQ6xDB6TVqxI0cT36Mqtd4PoUPTgSXErCdZAnwZIFo6L+gENR9ekVpLmmByFcj2HOw7AF+PrO0K/A9Ol6qhybciEDD2SHV+gT1pGQVza6pMrG8uiLcTgHlJYJVQ5kcTTBVHzD5uXqPwssRBJaRCpXZXtNXkBqwD+skylIyW71UXIb9XI4H7vvS5qixe8j+l/m8dQw3c9/pg9wE7EzB9cbul2AuvpNcm1o32lAd6Ixn0XESES1zgS4BL7+QI+bMhB805qbTtZu9Pgcnu54p9eWMHGAVtey8eCF8mTMajg+ETuGBKUwrlq7BwS/PHNGaSSnu4hbkSJeDWdMHqFouyInSniimS7VHteFStTr3GG+6W0BhEJAzssw5ldnWKW5JkHR4myQEHNjpKDi/S7sz7IwqqcdqgdQUi46oiTXcdybwKj7ZUDgJeoL0XvswxVeGYstz8AtnxpWh/nMIr/PRX/2eablkXgiGe9SPIotNTPYZV8YzH7x+zSqSCGlr6ilMv+Y0hhe7EsFRJM1oXnqd/M9FxGdayN6OW7WhtmD8+momKT8JJZcDU0UUMKt06K
 5QRFSthP
 G2+3kNfTpE/mMczkYVjmeLfX/EmfOPPDyegPgNtbhHtOxMz1B8Td47m+qKAWXpv2M9rfKGO48xsOUkPD2FLpp/YqtxVaAxN2uBFUcPkIFxHl68A6tsC/I0cu3INmaNRRc58A0yQSg3Wpi5l+2jlKHmnv765j2NnVVhe1DPbHt0IWI+H+JOo45E7m1SCeM8XE36OdrVVHML05j4eMg6S+pY+3fzB/SpYvjmzisF2cwL7I0tZEeGsPCLOPI1vNsuoIEWndLdyAKVCnRtX3EEZPefEsHlvCoYd/0csqEt2E9PRx8kxwgByI1XzQEG2FRAiqaY+LwYo3ME96QC2yCm8RFjp+RDkA97Dltuum3Nt2mrX3OVyPH2gg3o1iEhZHKW1N7OfcQZMeDgqAlJEQfF6cfChPlqzVc1+PNmycNFoHeJvUPm1492wGQNgOUO1HRzSnU/jVVVS2kORd+9T3S70qFPR/YXnwZVWZ5RG+msNoN5YGyQJsDfqtFa8xuPmphGtSb75Iz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/26 11:21, SeongJae Park 写道:
> [...]
>
>>> ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
>>>   From hackermail Thu Jan  1 00:00:00 1970
>>> From: SeongJae Park <sj@kernel.org>
>>> To: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: SeongJae Park <sj@kernel.org>
>>> Cc: damon@lists.linux.dev
>>> Cc: kernel-team@meta.com
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> Date: Mon, 25 Aug 2025 07:41:33 -0700
>>> Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
>>>            return value
>>>
>>> Otherwise, __udidi3 linking problem happens on certain configs.
>>>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
>>> Signed-off-by: SeongJae Park <sj@kernel.org>
>>> ---
>>>    mm/damon/paddr.c | 14 +++++++++++++-
>>>    1 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
>>> index 5fad2f9a99a0..09c87583af6c 100644
>>> --- a/mm/damon/paddr.c
>>> +++ b/mm/damon/paddr.c
>>> @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
>>>    	return false;
>>>    }
>>>    
>>> +/* convert physical address to core-layer address */
>>> +static unsigned long damon_pa_core_addr(phys_addr_t pa,
>>> +		unsigned long addr_unit)
>>> +{
>>> +#ifdef __i386__
>> Can we use the following condition instead?
>>
>> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
> To my understanding, this issue happens only on i386, not every 32bit
> architectures.  So I think i386 specific condition is better.

I understand. However, the aforementioned general condition is essential,
and we should propose a new patch to address this. After introducing addr_unit,
any 32-bit architecture should support monitoring of 64-bit phys_addr_t.

What do you think should be our next step? Looking forward to your reply.


Thanks,
Quanmin Yan

[...]


