Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E83D6CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 01:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC198E0009; Wed, 27 Aug 2025 21:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CD68E0001; Wed, 27 Aug 2025 21:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE248E0009; Wed, 27 Aug 2025 21:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB91D8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:38:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75BBC1DEB2C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:38:43 +0000 (UTC)
X-FDA: 83824456926.16.747EC60
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B88210000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:38:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756345121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thXyW3uosvik73Ad3yRD+N5OxXSCSfRL2zVA6E01guY=;
	b=sXnsM6WOUI8tdUd4J41ZR7JX2XQKNetKcgSd6JUVXvjuLVWNYgZDbNYlcwE5RJkloUvBo0
	TQSBfAn7IVRFJl2hvZyrDW7kyexfVCutIZh1ILMwAG3g7C4qrBv4pJkyC+qvwm60hbM2PH
	sFMQyZ9E4b2+saHrObQ+JfS5HI/nD3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756345121; a=rsa-sha256;
	cv=none;
	b=MThzkL0qAX0crTnWYUr2mEgfWjaccwX5Wu2VKCMzpi0vxw03fpF4RCXcOaHuczJDpESf2E
	WfpvIBBd/ah/uL/X0EJCgSime9qQtDwP2ETpmB0e93zU0ArpFmtoF+DDFNZpq845vqiq+d
	X8fq31eSQsQDpCHqAUimT5FgT/VqsTg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cC3r93xGmz2VRHr;
	Thu, 28 Aug 2025 09:35:37 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E1DE1A0188;
	Thu, 28 Aug 2025 09:38:36 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 09:38:35 +0800
Message-ID: <2c0477d5-217e-40fa-aa26-1dde19280779@huawei.com>
Date: Thu, 28 Aug 2025 09:38:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>, <kernel-team@meta.com>,
	kernel test robot <lkp@intel.com>
References: <20250827180743.47876-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250827180743.47876-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B88210000C
X-Stat-Signature: 3ndnp6suxcdxk4ss6b9jy4de81tbxe73
X-HE-Tag: 1756345120-174381
X-HE-Meta: U2FsdGVkX18vSinu6vFYFStGbeJQD2sPmsGj29OxSboHy3T0uDjahl2Ov4lISM9KKglVYUqo+oOVp7QEkztt2FjXHjyIIiIIC8KsxaalipIo2Pwwj2e57Q6a0hwNEU3O0Eww9WCiE6bggY29eKZLyh1zsgqu2EgawaNk2whIrteeCYPMJQ6ld691JGtLUpVWJn2AHXwdtkK8J5uob9EWYRVjQ+e9COMFOOmfHz3oOWwpRDhHnAAW4MKvCHndWYqywo9wDIxPLGuxjR8SGoInupelX6PsYKtpZOLxLG/zr3BG04J2YDbh4dU8SHmuvm8L2aHQO+7Y4kXIty5Je2x5qXacHbzEWrw1HomkNT8E7m3D5zM8MdQztveemPNfj3BcsX9B82073YtfuPYp8N7alEUBwgwfBKrktxphpEKnBkuVkTeJoyUFDCe6OqEoEr13x7EAwon9u4zy9cu/efxmykOgiEbsOrbmBkUTmLKKN2c4kMhp3WZLz3qsSPchpMe3cHiwM87eALuLF8EDPyZQ4Old4jF0CMBDpDhovouKzKEFYqfWqaMCevIppurnrJY7ez/D5GyZTE1wTt9ttKnZivRPdW6kmzULJGmaFS1uXovwkOpeat99FRkzcFlO6Xx54o1MAuGGPvPe4DgLCNbqWPTElgHYeNhizyBosaKkq1ESsc3Bhb1FZQYLfXsktuxci2B5PDc1PyHIbzwaQkYeR56zAkX8WrBAgvZPDpmpJBsgR1hA8MQ3tP/hXk9vTFQCnRbtWVOVrQwz9KWqe8KC83RXnwN/V2uA0T9zAeSLN8wzs3TUpl7A/1naFgRzsFH0SkcPs5Aj4no3hqBRZg1U7vJ/iYtuv+h8TVWJ8izdRl/iQi+UFAolfow9exj3OuIg/gzY+RRspgBoeYVOr6Tyq33xwPklFEeCgfWP6ii0yHGLZZhyrHir2vgCzaPm9X46deISo2qVT8myAB2X6rz
 GXYb+l1r
 d/Z57LPosOhW3lnLdEnxnGFCUlE49jR2EDOoxwGySaIFz5pxKNPCs6fgCrjayJue25BUG1wot1nVObeEAXVAR8dEJA5QDON934K/BSL0V3lw9uvmay28Sb3U9ezn21alQt0puvLp5lmAI7D1plWmb1pmUo+61Jy1jE5TxQlOcritV2pEJOnhwdYhM711vTabZuAd8hFmDm6BF1MQHxWIYNCBZN6cDEMg2aq4B2wRDzMJ/rmAp2TWoahdGj12aDqy8APCRmu2EzgkTUR2N+tN/c76bSz22yzsXSdea6qBcFmTSAU6YRk/70PfyVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/28 2:07, SeongJae Park 写道:
> On Wed, 27 Aug 2025 19:37:38 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> Hi SJ,
>>
>> 在 2025/8/27 10:42, SeongJae Park 写道:
>>> On Wed, 27 Aug 2025 10:21:41 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>>>
>>>> 在 2025/8/26 22:21, SeongJae Park 写道:
>>>>> On Tue, 26 Aug 2025 12:51:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>>>>>
>>>>>> Hi SJ,
>>>>>>
>>>>>> 在 2025/8/26 11:21, SeongJae Park 写道:
> [...]
>>>> Please consider approving this fix.
>>> I'm yet in travel, and I'd like to take more time on thinking about the proper
>>> fix.  Quanmin, could you share more details about your test setups, both for
>>> the compiling success case and failing case?
>> Apologies for disturbing you during your travels. Please allow me to explain:
> No worry, I'm the one who would like to apologize, for delayed response :)
> I'm back from the travel, btw.
>
>> When CONFIG_PHYS_ADDR_T_64BIT is enabled on "i386" [1], the phys_addr_t type
>> becomes 64-bit, requiring the use of the do_div function. We are in agreement
>> on this point.
>>
>> On arm32, if LPAE (which we intend to support in this series) is enabled,
>> CONFIG_PHYS_ADDR_T_64BIT will also be enabled. In this case, pa / addr_unit
>> will involve 64-bit division and similarly require the do_div function.
>> Obviously, such link errors should normally occur under these circumstances.
>> Unfortunately, the expected anomalies did not manifest in my previous tests.
>> This may be related to some incorrect adjustments I had made to my local build
>> environment quite some time ago — though I cannot be entirely certain. That
>> said, I have since cleaned up the old configurations and ensured the current
>> environment is clean and normal. For now, we have confirmed the actual problem
>> and its root cause, shall we focus on fixing it?
> Thank you for sharing the details.  I wanted to better understand where the
> issue happens and not, to clearly understand the root cause and make a proper
> fix based on that.  I think we can now focusing on fixing it.
>
>> In summary, after introducing addr_unit, we expect that any 32-bit architecture
>> should support monitoring of 64-bit phys_addr_t. Therefore, we can consider the
>> following adjustment:
>>
>> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
>>
>> Or at least adjust it to:
>>
>> #if defined(__i386__) || (defined(__arm__) && defined(CONFIG_PHYS_ADDR_T_64BIT))
>>
>> I have thoroughly re-validated the feature functionality today and confirmed the
>> correctness of the aforementioned modifications. Therefore, could I kindly ask
>> you to consider the aforementioned modifications when you have some free time?
> Thank you for the suggestion and testing, Quanmin!
>
> I was thinking making the change for only i386 is right since I was mistakenly
> thinking the issue happens only on i386.  Now it is clear I was wrong and we
> have at least two cases.  And I agree your suggestion will fix both cases.
>
> But I'm bit concerned i386 and arm might not all the case, so wannt make the
> fix more generalized.  My understanding of the problem, which is enlightened
> thanks to you, is that not every config supports dividing 64 bit with 32 bit.
> And div_u64() is suggested in general for dividing 64 bit with 32 bit.  So,
> what about making the if condition more general but specific to the root cause,
> like below?
>
> static unsigned long damon_pa_core_addr(
>                 phys_addr_t pa, unsigned long addr_unit)
> {
>         /*
>          * Use div_u64() for avoiding linking errors related with __udivdi3,
>          * __aeabi_uldivmod, or similar problems.  This should also improve the
>          * performance optimization (read div_u64() comment for the detail).
>          */
>         if (sizeof(pa) == 8 && sizeof(addr_unit) == 4)
>                 return div_u64(pa, addr_unit);
>         return pa / addr_unit;
> }
>
> Because the sizeof() result can be known at compile time, I think it shouldn't
> cause the linking time error, and I confirmed that by passing the i386 test
> case that kernel test robot shared.
>
> Could I ask your opinion, Quanmin?  If you think that works, I could post v3 of
> this patch series with the above fix.

Great! I believe this approach is better. This modification is more generic
and eliminates the need to deal with those messy configs.

I have also re-validated based on this change, and it is working correctly.

Thanks,
Quanmin Yan


