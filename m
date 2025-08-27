Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275F9CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E71E8E013C; Wed, 27 Aug 2025 07:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597D18E0105; Wed, 27 Aug 2025 07:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADF88E013C; Wed, 27 Aug 2025 07:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37CB38E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:37:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7C63BA5AD
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:37:49 +0000 (UTC)
X-FDA: 83822337858.01.0D5591E
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf24.hostedemail.com (Postfix) with ESMTP id B2A8818000A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:37:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gt5O+ZmGDKEjh9HTw1qKL7NQ7DROREb3Rq6uY7MePrQ=;
	b=KctTU7p7FhegomNZyVEH/4ImOqp7B9MhPEmN8f9wphrMWBP1I6WBMusHmEgRRJovw9G/J0
	8TQNccOKm2kpsKnPtVJS+tXj8h0seNEd5gruV42bYCfbTg78rqaa5HExdlS2RLh5ywLbSq
	BE6ZxUms07OR+hcwZtrsv5YfU8o6iqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756294668; a=rsa-sha256;
	cv=none;
	b=UWhymKoYs/dtuK/ugWGxB9/wKI1v6WEt94E6iOedbqG1L7KC/oieiMeMNi1la91vRsig+A
	ZkEI8YUhWv6kMDcTjjZx49Y7lI+she582QX6Ve/Q3wN3SkggboJDgFbTAUsuzxOLPCTxPF
	MlH8FxIYUpGnEazSKfPjUjF01vKz7n0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cBj8C41csz2CgNN;
	Wed, 27 Aug 2025 19:33:15 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 70EFD1400D4;
	Wed, 27 Aug 2025 19:37:41 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 Aug 2025 19:37:40 +0800
Message-ID: <890b1575-abab-4b3c-8953-110e1dd3f9ed@huawei.com>
Date: Wed, 27 Aug 2025 19:37:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>, <kernel-team@meta.com>,
	kernel test robot <lkp@intel.com>
References: <20250827024244.58979-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250827024244.58979-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2A8818000A
X-Stat-Signature: 577cw8iykqzskktkcez9m5788jf85pxt
X-Rspam-User: 
X-HE-Tag: 1756294666-964413
X-HE-Meta: U2FsdGVkX18LnuEqa8PgodpGMGKpf7KKwKEwOIescF/D4tCYdxQMsQHP0Y1tniHk7Dh8xZJ23iq/8ZCTugur9shUVMx/0mLHE60xtVecF/IZ8GjTt4jeZtzbllOjxkUuMzkmuThJQwxQAe1cN4ZxB0E1FtJfF+nUPgciMd8TPAkeM6B5642UzukM2NI4FvYC6bVAuZxPzNL8uombz7SR4PVVbQD+y3YFTexwKDnSEBpmBmqUAkwYHeWU2mg3rWa2QOvYzC1jAGpN1Qs0ohiKDR5cjDVtWzKM99uemN8il/notegDZVz7Ms3TYzRxuhWNhW7/bbXixH7nXuADsE2KB3Z8qh7uzHrETS/M6paxni2ixVbW0nia06mhBWk6M3qvE5HSZvL+a6QDAAVprtz0+L2Zqr00XFWIrgh7hJRN95SmEWp2yC2rXIXSBi+h5F6y0syrM/ZmarpVKjzTfNNrzHUUlUUdVFCgOcDn5AsTrCnOcd+ma04WCIidHYfr/kanJPk+yZkSRjpXYxvQyGkwBXwVcJuiEMDPBlax2HFvJMc7PdbaAwyvYDvtM2Lbmls3Qv5LseQw/DHONlXbr6/PzvxFGWLrBCO6eFyAxI84ZGYs8peuiEHrDF16h5i8uhXV1L2QqOVQReaX/k/WvIrsGi7p2/R3qvwzqfvcMUv1d2shCHVtk1mQ2usi06xqf9gnj6c0Sn+HVDc8u+VprHa1q/DrGk/j57nL890dJIQqyhPvyChnioHug3ay8py68IC5OgrmA/7F+dHbpCsNZALfxuoDFDc8mg7NAhN3qX0h9VBXKmH2EHofU27XqQTBUtZiag5UnzVZCIXeLwF4kfEaIEC/DIKBzMogo9wF88Swg+hrDYw5AS1lF6bCmQZErXz9wjGsz800f/KkrvTX7oxgC9ryGkK2SoUBbZihUq3DIbg3y1Up/7dE/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/27 10:42, SeongJae Park 写道:
> On Wed, 27 Aug 2025 10:21:41 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> 在 2025/8/26 22:21, SeongJae Park 写道:
>>> On Tue, 26 Aug 2025 12:51:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>>>
>>>> Hi SJ,
>>>>
>>>> 在 2025/8/26 11:21, SeongJae Park 写道:
>>>>> [...]
>>>>>
>>>>>>> ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
>>>>>>>     From hackermail Thu Jan  1 00:00:00 1970
>>>>>>> From: SeongJae Park <sj@kernel.org>
>>>>>>> To: Andrew Morton <akpm@linux-foundation.org>
>>>>>>> Cc: SeongJae Park <sj@kernel.org>
>>>>>>> Cc: damon@lists.linux.dev
>>>>>>> Cc: kernel-team@meta.com
>>>>>>> Cc: linux-kernel@vger.kernel.org
>>>>>>> Cc: linux-mm@kvack.org
>>>>>>> Date: Mon, 25 Aug 2025 07:41:33 -0700
>>>>>>> Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
>>>>>>>              return value
>>>>>>>
>>>>>>> Otherwise, __udidi3 linking problem happens on certain configs.
>>>>>>>
>>>>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
>>>>>>> Signed-off-by: SeongJae Park <sj@kernel.org>
>>>>>>> ---
>>>>>>>      mm/damon/paddr.c | 14 +++++++++++++-
>>>>>>>      1 file changed, 13 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
>>>>>>> index 5fad2f9a99a0..09c87583af6c 100644
>>>>>>> --- a/mm/damon/paddr.c
>>>>>>> +++ b/mm/damon/paddr.c
>>>>>>> @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
>>>>>>>      	return false;
>>>>>>>      }
>>>>>>>      
>>>>>>> +/* convert physical address to core-layer address */
>>>>>>> +static unsigned long damon_pa_core_addr(phys_addr_t pa,
>>>>>>> +		unsigned long addr_unit)
>>>>>>> +{
>>>>>>> +#ifdef __i386__
>>>>>> Can we use the following condition instead?
>>>>>>
>>>>>> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
>>>>> To my understanding, this issue happens only on i386, not every 32bit
>>>>> architectures.  So I think i386 specific condition is better.
>>>> I understand. However, the aforementioned general condition is essential,
>>>> and we should propose a new patch to address this. After introducing addr_unit,
>>>> any 32-bit architecture should support monitoring of 64-bit phys_addr_t.
>>> The issue is that we cannot divide 64bit values with plain '/' operator on
>>> "i386", and hence this patch makes it to use do_div() instead of '/' on "i386".
>>> No such or other problems at supporting 64-bit phys_addr_t is found on other
>>> 32bit architectures, to my understanding.  My understanding is that at least
>>> you confirmed that on your arm-based test environment.  So we don't need a new
>>> patch to my understanding.
>>>
>>> Am I missing somthing?
>> This is because I seem to have made a mistake earlier: I adjusted the local
>> compilation toolchain. When the __udivdi3 issue mentioned above occurred, it
>> reminded me of a potential problem. After switching to a completely new environment
>> for testing, I discovered the __aeabi_uldivmod linking error in arm, which is similar
>> to the __udivdi3 issue.🙁
> Thank you for sharing this.  Then I agree the current fixup is insufficient.
>
> Andrew, could you please drop this patch series from mm tree for now?  I will
> further discuss with Quanmin about the proper fix and post next version of this
> series with the proper fixup.
>
>> To prevent similar environment-related problems in the
>> future, I suggest adjusting the condition to the following:
>>
>> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
>>
>> Please consider approving this fix.
> I'm yet in travel, and I'd like to take more time on thinking about the proper
> fix.  Quanmin, could you share more details about your test setups, both for
> the compiling success case and failing case?

Apologies for disturbing you during your travels. Please allow me to explain:

When CONFIG_PHYS_ADDR_T_64BIT is enabled on "i386" [1], the phys_addr_t type
becomes 64-bit, requiring the use of the do_div function. We are in agreement
on this point.

On arm32, if LPAE (which we intend to support in this series) is enabled,
CONFIG_PHYS_ADDR_T_64BIT will also be enabled. In this case, pa / addr_unit
will involve 64-bit division and similarly require the do_div function.
Obviously, such link errors should normally occur under these circumstances.
Unfortunately, the expected anomalies did not manifest in my previous tests.
This may be related to some incorrect adjustments I had made to my local build
environment quite some time ago — though I cannot be entirely certain. That
said, I have since cleaned up the old configurations and ensured the current
environment is clean and normal. For now, we have confirmed the actual problem
and its root cause, shall we focus on fixing it?

In summary, after introducing addr_unit, we expect that any 32-bit architecture
should support monitoring of 64-bit phys_addr_t. Therefore, we can consider the
following adjustment:

#if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)

Or at least adjust it to:

#if defined(__i386__) || (defined(__arm__) && defined(CONFIG_PHYS_ADDR_T_64BIT))

I have thoroughly re-validated the feature functionality today and confirmed the
correctness of the aforementioned modifications. Therefore, could I kindly ask
you to consider the aforementioned modifications when you have some free time?

[1]https://download.01.org/0day-ci/archive/20250824/202508241831.EKwdwXZL-lkp@intel.com/config

Thanks,
Quanmin Yan

[...]


