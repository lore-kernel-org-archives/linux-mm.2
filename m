Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FCB6CA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBBF8E0119; Tue, 26 Aug 2025 22:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C8A8E0105; Tue, 26 Aug 2025 22:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9368E0119; Tue, 26 Aug 2025 22:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC1DB8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:21:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27ABD1403F8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:21:51 +0000 (UTC)
X-FDA: 83820936822.06.029CB42
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id E284D180006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:21:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756261309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oSuyUg30w+atq2QwGut9Ty40YdY4EABYx9thD6Hw6eE=;
	b=8iYJvqoaEVJupYhXsRFBWdFTUbcAEtETxjzkr2ty5i30ujJcJsPZIGNRI31ppbC/I7LK3m
	NuzjHOiI3A5A8xSahUko+NOcjvXqRXMbyrlCxvagnlgnZsRDttjwvikQl3/7pRMAmFGHo3
	cMwJUxi5DOr8P4RkdsrIIezQ9skUpf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756261309; a=rsa-sha256;
	cv=none;
	b=RicmDZFOyCt0dlQTvYlu0oGCeS1xnTPCnKNQV1UHiPffwFPQ/xCQvlGKGaNYEyHttsX9wT
	w8vN2tFmW1zPfsXF6S1Z4LzhH08Irl0PFx7un2iMTRGoe7nqL9JlGB5zlzFJ6VxJaCkCdX
	jU4i72+0HmFMbCLc8qoprKzE2/0p/1k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cBStj6npGztTWx;
	Wed, 27 Aug 2025 10:20:45 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id A172F1800B1;
	Wed, 27 Aug 2025 10:21:43 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 Aug 2025 10:21:42 +0800
Message-ID: <c8c3d0d5-e9e1-44de-8722-1e7d09786b51@huawei.com>
Date: Wed, 27 Aug 2025 10:21:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>, <kernel-team@meta.com>,
	kernel test robot <lkp@intel.com>
References: <20250826142155.53632-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250826142155.53632-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E284D180006
X-Stat-Signature: jbaare6yopcfcnxqcikt7y37uptt1d88
X-Rspam-User: 
X-HE-Tag: 1756261307-213152
X-HE-Meta: U2FsdGVkX18Wxlk+wUB/Iq+TaV2M8VxNwUFI1HcYjEzgX9IliwWKQoh7dfSsW2G2gqPIoJKsFJg4aN9SoCklTJAfKHZHalpFXgnsfPgXRpSMUtfb8K9TegMNK3Ct3/aG5VSRS6FS1h8UkP7Z6S2r6kLS3V1ySZQ+wpA8dzmgh/7Gg5gBJCsJeDHYy3iHc2yDGXovKSQdVVCg93+clCN/plcoFHQOG7w6vPWEFIcLzIi2Louy4RZ2jfF125717W/eHcifKDgudLObVBIDyOffQuzlYHM5agf+XuHAo5dqaUagf3A/7G6X1crox+m5wQptVkJ62Pq86EjK+lMt5smkH0Bm06G7DY6hv5NUynfr8FncaGQ+/3TILfBfbSSnq9u1Mc+GhhOsxq4mFiwqf55UqUsf8fQhxukAtXRf4rUhoLtHA8Cfk6eokNeaiDytiaYVDmtS8sLTGhMm/N1VwdHA2vNz8qTCiN/gNHdNfGySLuF+uYO5/ZlESAOJkbZYmVPMPmlAS6UoDjtGOO2SDRiI0mGaAi/gTguwfP2U7+uVXFYbDsKh1xMnsx6z88K2UPgkQLdqqiOJdNGgniaSUUei3teVaGPVKVs9m00ZKRhFsT4CkKAQ/SNSUwQTJyF0NLU2QCe1l/H1x6pD01mnmQSGnRTQJs45MQKfZxtBvovsEnBthcIXBHEDRVQrYHhh2+2j/Tz5CPr4TqPKeTrB3KX2a1cut10+ZGccoWgS29j94ueKu4diZOFs9+mmE8COcNF7gBz/IiprJPib+qnst2Q9DlsBR2e5R0PIovi8dy4vXv4E1aLR6NZE+YXWm2LnVOmsYsud6gXHIZpdv+fKnhnv8rFjkXY0xxthQW0Xsatl9qP3zfRvpyme8dH2sxmNHEhqY7EOll9qeudJ9o41Z8eHk+A06w2YGg7Nny4C5qK7CLgx/zcU60baQGmCT9b/wDuY214YOt0lsvVQU0m/O9O
 X6eJrjmy
 PH2+aT8ya2Zz7pzL+uRfAB47r5Id6v35BP1+69SRst3b4XBZ1gjtSDZVrmEo0UUW5CI+BPTDLK+Cs89NOESl+Yu9GVZ7aHl8rBFeeHs2vnWizlPZ/MVcImhYKFTqKLR8ong5bRzmgCbnpVq/ccxgrDirUR/JE6/sbxcUV8ikayjiZYTi4rlEVmalYG+b5YrOXRD7Dnl9Sx10CoOb9tRgoIaGs8aqwTt3AizL8QU2VYSeRB/vNFlxuXslDWRzZQxDsPbmfChAUmzeimNAE5InWL2XfvO5PDCCvgQnZiNOSUYlAijAU5hMlR7u6d1PfEFHYWjmrcK3b3tEENNPIIewLtY9kjY9y5Zn9MKiUi8Gn3FD2DXM7BaNzT0DUS+0uWAFCXWAd8zBDlBbah3s0AqIBNrET22Uqlu7+lXt5a/3Rh8+2xhjLamw+Y4lExbBJoY7OENOem0inP/iGEFKTNqOOwBCytO/3p82gQx3ZV/hwKULGUT78HQKBw6w6Uqe9WpeKRvhezIZGC7AVUSklU9RxBTm5xTwBW8xT9K1K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/26 22:21, SeongJae Park 写道:
> On Tue, 26 Aug 2025 12:51:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> Hi SJ,
>>
>> 在 2025/8/26 11:21, SeongJae Park 写道:
>>> [...]
>>>
>>>>> ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
>>>>>    From hackermail Thu Jan  1 00:00:00 1970
>>>>> From: SeongJae Park <sj@kernel.org>
>>>>> To: Andrew Morton <akpm@linux-foundation.org>
>>>>> Cc: SeongJae Park <sj@kernel.org>
>>>>> Cc: damon@lists.linux.dev
>>>>> Cc: kernel-team@meta.com
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Cc: linux-mm@kvack.org
>>>>> Date: Mon, 25 Aug 2025 07:41:33 -0700
>>>>> Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
>>>>>             return value
>>>>>
>>>>> Otherwise, __udidi3 linking problem happens on certain configs.
>>>>>
>>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
>>>>> Signed-off-by: SeongJae Park <sj@kernel.org>
>>>>> ---
>>>>>     mm/damon/paddr.c | 14 +++++++++++++-
>>>>>     1 file changed, 13 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
>>>>> index 5fad2f9a99a0..09c87583af6c 100644
>>>>> --- a/mm/damon/paddr.c
>>>>> +++ b/mm/damon/paddr.c
>>>>> @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
>>>>>     	return false;
>>>>>     }
>>>>>     
>>>>> +/* convert physical address to core-layer address */
>>>>> +static unsigned long damon_pa_core_addr(phys_addr_t pa,
>>>>> +		unsigned long addr_unit)
>>>>> +{
>>>>> +#ifdef __i386__
>>>> Can we use the following condition instead?
>>>>
>>>> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
>>> To my understanding, this issue happens only on i386, not every 32bit
>>> architectures.  So I think i386 specific condition is better.
>> I understand. However, the aforementioned general condition is essential,
>> and we should propose a new patch to address this. After introducing addr_unit,
>> any 32-bit architecture should support monitoring of 64-bit phys_addr_t.
> The issue is that we cannot divide 64bit values with plain '/' operator on
> "i386", and hence this patch makes it to use do_div() instead of '/' on "i386".
> No such or other problems at supporting 64-bit phys_addr_t is found on other
> 32bit architectures, to my understanding.  My understanding is that at least
> you confirmed that on your arm-based test environment.  So we don't need a new
> patch to my understanding.
>
> Am I missing somthing?

This is because I seem to have made a mistake earlier: I adjusted the local
compilation toolchain. When the __udivdi3 issue mentioned above occurred, it
reminded me of a potential problem. After switching to a completely new environment
for testing, I discovered the __aeabi_uldivmod linking error in arm, which is similar
to the __udivdi3 issue.🙁 To prevent similar environment-related problems in the
future, I suggest adjusting the condition to the following:

#if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)

Please consider approving this fix.


Best regards,
Quanmin Yan


[...]


