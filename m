Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7357DCA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 03:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B0D6B00AD; Sun, 24 Aug 2025 23:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932EF6B00AE; Sun, 24 Aug 2025 23:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F976B00AF; Sun, 24 Aug 2025 23:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 729096B00AD
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 23:04:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF46957C03
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:04:52 +0000 (UTC)
X-FDA: 83813787624.17.1F17312
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9EDE740009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:04:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756091091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/ZyKyb3PYCT+J0ggUYrRCpaNcwhspcF9XqlGkZzy0w=;
	b=6C1ZZvLHo75lOJ3uGbAIXEek9LjcQVnaXKecLSmrgagUfTX0/ZtCZA4AX2kEV9OjqrPLbm
	H/VCZXvSTFXWKsz6lzGQvVudYmWq7XjqMiiYVGJ3j6TEZf4YU3Io8T9Ant8X7oxWUQ1RTs
	RkbPoes75YrekRxcjiE3Mg7vdzbqQSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756091091; a=rsa-sha256;
	cv=none;
	b=PHJtdaLUykKPQBgrR/fLKJWwDMDFAAwoSigTSGxZVmqi7HCY0CiX8vKuz6JyvJHraR4hJu
	dzQ+Fqj7umOp26vZGdjoohFkQuFCCHFnBUMqNOrT5yBC700FKV68XRtBWGpYz5C3zXwtkW
	+dqOhHT+GszvudUmAMigxZtga804UAU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c9FyH2v90z14MWR;
	Mon, 25 Aug 2025 11:04:39 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F012180B58;
	Mon, 25 Aug 2025 11:04:45 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 11:04:45 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 11:04:43 +0800
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on already
 poisoned pages
To: Jiaqi Yan <jiaqiyan@google.com>, Kyle Meyer <kyle.meyer@hpe.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>, <tony.luck@intel.com>,
	<bp@alien8.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<jane.chu@oracle.com>, <osalvador@suse.de>
References: <20250821164445.14467-1-kyle.meyer@hpe.com>
 <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
 <aKd1K3ueTacGTf1W@hpe.com>
 <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <14a0dd45-388d-7a32-5ee5-44e60277271a@huawei.com>
Date: Mon, 25 Aug 2025 11:04:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F527M-x=UeB0tN_sjCgp_YP_8yLkVRCLP2dLO2bzXrqWsA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9EDE740009
X-Stat-Signature: 6cmywief9i4z9cdn8immmgy56xro36ee
X-HE-Tag: 1756091089-459349
X-HE-Meta: U2FsdGVkX19KemttozUE9vVYhjueq2RZqdK/pWyYpPKrdCvTvym1Xw5fpYfXbamQJmOUvuPF75rJYqoccWRSAk+nXMNl2U/ctpw6n8ruKG11Vkal8G370ZaO/TaB+xLv7QcKN0NglJ05qHw8i0fbxFy4iE7ugVLqmM4vzJeIsHZW9dbKdygSqWd9F4q2vpq41orFl+D5VgmOcLJ5XyPOq43dALl+hEOssAPZqz+cwvJITwJ7Ad9Q7qJz/0TVYXMId9vSwGyoB091fUspQFut+lYMIIKbdtWNV7oJAPg7moHMPpAJKPEgLp1iPWWWdahruOorKqf/RTLCrdCDHO0L8nEjTK3oVAmri4mLtXFH7vB8+9ZFrWETNiueEvLXNWm1xVHmPIeL7Y9v2u2RWp9yr6sAvTXyn70JR0i7GLkYQAtNFNB1o0jPeLm65eNSCrGrD1F0pfnoxdOtmATFdbj6DttD6sDYJjSA9IhphqvqKmaaBeqhLGRCxy+qtB2P98r4Kr1o6/FzzOLIm1LzIDfxG+WVLa03QpE3oTvKeHNDXy1pYNQPfUPRXLXYLCa997Oisek0nlUnO3mYESTBS1o+I/a5nk4MsH0dEmpdRWX2rdS4GBqABdBsK6EOEnmFqQnAZ5hJyjLThL4RXVBcdM66vigd1htQ1ETVZ9bIY+gkHC+heHHZmN+YT3Qvwxvfnk1gCDmsQmZ/nutNatrZ6hBpTW7xl60inv0YOe4R2/ixu+SrhHt5kmJyDKLXCqay0Lzm3+lCQgPIVjVvNnMCk5lIEFPjPdeBCf1gYhvnAsjVjYHDQb29tDLqLJ5FmmbVgi2NFALQsPgeDG9G5U/RM+dGkluZAbvruEvLUBUwNgWptqpF+fGUkv9lJlXlXuCdyHT9HnvecJSV79dN3jgVSOxdbynr0oy9xMr8FALpvgPAVaxXZg3LyFG9ywi0RCLO+wn4Nppi0tO2kpHfTDilymF
 sF22sNOE
 VkbIDxHOWMDpWc+jBXRZNk+gxTi8mVA61Yt3uhmK7ZFH5x1Zqkb2ciGE9dhbaMn/0keI03X3XpiBm1VfyYBoxOUd32JmmNMbibUJ2MSPSvTcHYtXpsMwlbF1FOVXAuWtJwwqFicJaR+qxSVv7aPdRh11WsoYWCcSvKvntblUQRMOKbtkXUqZZEKT2QnGSo4gtxzamZK/fE80ZA9NWozpukCUJQoqzbd1pEvEZGnvCJ3mTBZ67YStc9moTRFHhD44XHLpn9wJo1bzHiEhEohZZPv495rKzCm0PPmH6IFIYi8gaxPLtAWdwPxYIv1g7YIZIY9rFTTeWtZ4wQKZCZNWMDA7mnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/22 8:24, Jiaqi Yan wrote:
> On Thu, Aug 21, 2025 at 12:36 PM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>>
>> On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
>>> On Thu, Aug 21, 2025 at 9:46 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>>>>
>>>> Calling action_result() on already poisoned pages causes issues:
>>>>
>>>> * The amount of hardware corrupted memory is incorrectly incremented.
>>>> * NUMA node memory failure statistics are incorrectly updated.
>>>> * Redundant "already poisoned" messages are printed.
>>>
>>> All agreed.
>>>
>>>>
>>>> Do not call action_result() on already poisoned pages and drop unused
>>>> MF_MSG_ALREADY_POISONED.
>>>
>>> Hi Kyle,
>>>
>>> Patch looks great to me, just one thought...

Thanks both.

>>>
>>> Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
>>> but changing action_result for MF_MSG_ALREADY_POISONED?
>>> - don't num_poisoned_pages_inc(pfn)
>>> - don't update_per_node_mf_stats(pfn, result)
>>> - still pr_err("%#lx: recovery action for %s: %s\n", ...)
>>> - meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
>>> in memory_failure and try_memory_failure_hugetlb
>>
>> I did consider that approach but I was concerned about passing
>> MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. The message is a
>> bit misleading.
> 
> Based on my reading the documentation for MF_* in static const char
> *action_name[]...
> 
> Yeah, for file mapped pages, kernel may not have hole-punched or
> truncated it from the file mapping (shmem and hugetlbfs for example)
> but that still considered as MF_RECOVERED, so touching a page with
> HWPoison flag doesn't mean that page was failed to be recovered
> previously.
> 
> For pages intended to be taken out of the buddy system, touching a
> page with HWPoison flag does imply it isn't isolated and hence
> MF_FAILED.

There should be other cases that memory_failure failed to isolate the
hwpoisoned pages at first time due to various reasons.

> 
> In summary, seeing the HWPoison flag again doesn't necessarily
> indicate what the recovery result was previously; it only indicate
> kernel won't re-attempt to recover?

Yes, kernel won't re-attempt to or just cannot recover.

> 
>>
>> How about introducing a new MF action result? Maybe MF_NONE? The message could
>> look something like:
> 
> Adding MF_NONE sounds fine to me, as long as we correctly document its
> meaning, which can be subtle.

Adding a new MF action result sounds good to me. But IMHO MF_NONE might not be that suitable
as kill_accessing_process might be called to kill proc in this case, so it's not "NONE".

Thanks.
.

