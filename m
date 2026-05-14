Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F29CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCBB6B008C; Wed, 13 May 2026 22:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4596B0092; Wed, 13 May 2026 22:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E13A6B0093; Wed, 13 May 2026 22:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20FC06B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:06:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2BC3C1C05
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:06:25 +0000 (UTC)
X-FDA: 84764385930.22.1B2E303
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBCA640002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:06:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tANEEKSk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778724384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgwK++d+KiHykF7iybtMJFLF9OtaIvcBvOsHU3SZwak=;
	b=MpaEyjYegEJztbEGRv1IkjAn3CNMb6uUBjQ9oIVk1mxG2D2KhCoasgsKHXOPxIyqNPOeyV
	W0YQbayq6UsMw10W2wK5rgTVdxvVN3Rz8Tviobs25TWf+4LPHuFE8rvBmcHPE08xQN0pgg
	ZBaatZJIAWxo4jSSqRhYUOHsvonkvZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778724384; a=rsa-sha256;
	cv=none;
	b=X6dQZ4hAMB5IPaCxTIs+m13bkqb+OCQIpVpFPQI+Xv5VYfBAwH7g5tDIlX+11unEgp5o2X
	kOniGA8mvgZBstzAULCIGMe7j1QWnZVp1IbQsDLoJoKKen5f2teGp2SvviM83SfROvDmLU
	yeo1SjR9XwvrFwXaZqv4ti/EPfdv/Us=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tANEEKSk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <e5db0262-7ee8-4a9f-bfb2-c66a86b9ac7b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778724381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NgwK++d+KiHykF7iybtMJFLF9OtaIvcBvOsHU3SZwak=;
	b=tANEEKSkUFW8wAQHH0N22iPB/YMbs9ZotHhr54v0cPKFMGgF43vUDYkbaTxSQV0qIxRLOg
	d1XAADKMuK6hqc8M9Gxvsmp2YfbBLF5IxZcAtWUYfl2GgW7FHV+2PxR+1y3O2BC36ic+r9
	QAAcpDAt04+6g1MSOcUQ8gdPpTR0gc0=
Date: Thu, 14 May 2026 10:05:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Suren Baghdasaryan <surenb@google.com>
Cc: Abhishek Bapat <abhishekbapat@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1777936301.git.abhishekbapat@google.com>
 <9bff01a8-eb97-4d09-81a4-f4dbf9b59b73@linux.dev>
 <CAJuCfpE9_Njy7Tm4DnNin9HEVoqqfKzTRgxYkEEyzm+OCc49sw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpE9_Njy7Tm4DnNin9HEVoqqfKzTRgxYkEEyzm+OCc49sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: DBCA640002
X-Rspamd-Server: rspam04
X-Stat-Signature: gxs93kpy197qqnhwimjf9hm1zjeiuqg4
X-HE-Tag: 1778724383-199633
X-HE-Meta: U2FsdGVkX1+QKWSTvJmd0Q7WDMW/gr3EtdT/yLJ9WshCm9F+gQjab+RFt23xkO/B9eO4HHpvRbLxaDG8gV1S61ECf8a24yzVbYaTnnrmevI7zCgyJxZp6wW1mCpMuZcLPtrWzA/3shB+1VO0LjuFa4PJ8VBU4HEwyTmGr+slC7l1fLv4Ns134PZpWyPpW7J+BrePegS4VV2JvZmHbz88nz+ppwZ5NlZS9nEJCN38xgOY07K7sqz8kxYs9VBZByni78CSuxSfnxRk8G1Ub7LM9cyu34uZ/GMhiDELzXb1xRYZopELH6QXoFE2uCKfFovEMepQYvqjLUFqB5KgNN6MeEmUXuHMC+mKB/O+v3niG8Eu+dFA667Y9PXhYLAk5DCp1NkkSDdoXk6XYhxCKXeyGEGQ8MdfLBLSYX1YruQYsYtKSbR88fgm0loytAeryb6ryHh0uTpoQBwAfILwuOEXp5PAsFH78M2UBDPSGVODwb+dft/mHHvo8hf4g1jgsCkuBK/dSHq37bn8JC6ZFUjB5QeXbZ4lcoXNqLVaVL2OP/11DOiA+Ie5nLjGXI2HAu//vjwcccAYUsDlw56e+bquEwBb/osdO2YA3QYYo1Pi8PCF3H196Lf+4NVm/KJDV+HcsvQbE0B6t1SzcHXeAQI+OmxKvk4yiWNMcOk88+vkluhx4hzlzKC6R1Bc7TCqGto5e72LbfAIkkpiEeHfatbXrlW6cmEixI3PWa69jTSk0zPrZitDzPGj5KAXhrI0yAsF3JDl5s7gYoAJSJrZO15nh6MHQCg4SpdNpulRvgkkmHksz4lPB+gAeHv8/dUBxK8v5dg565ReluPQGzQRML7s6zVLnVTPqfpW5mI5YFJy01wgEyUaTHXXSgIDElq4fcscnVVNvlR98+dJUh5MpnHZZ+8NYPIfKkevPxhk4WifMNwM2jViUdMJG5lX5+diKdqXrIP0vjr3dfLrkFklE7D
 7ETIlV2t
 bOORzqn3cIk9A6omGVpevZ0yUUEOUw+f+4//tqvruLzfLq0F6QfY8+0CgAzXcAvgXLDONF9NBsmXgbT87NW52gY5I2a0cnrshVb9peKPMcyLvNvBMylw2lO4OA39Zx5757GDpGUQyojt1RPj5/ANCQeARgMdOmw0wVx1t+LZoMexWFfkqNo7JmP9d2ACgM1NpvezOVUxLmp4efqjmfTpY0p0xjr3Pk9qDUlVvmV1tvbkcbgL16M0ikuRCRM8ikHpQBj+7vK0PIwne4ybzgV9jhzh8BcZ5M6O+U05SYrVVpRgeXcv34pfanx4iZoFJ3kcXgHNLHfyogEdnltoF715rm3aqY4uhqNRTmNHi41EP++2fwcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/5/13 03:58, Suren Baghdasaryan wrote:
> On Wed, May 6, 2026 at 1:45 AM Hao Ge<hao.ge@linux.dev>  wrote:
>> Hi Abhishek and Suren
>>
>>
>> On 2026/5/5 07:36, Abhishek Bapat wrote:
>>> Currently, memory allocation profiling data is primarily exposed through
>>> /proc/allocinfo. While useful for manual inspection, this text-based
>>> interface poses challenges for production monitoring and large-scale
>>> analysis:
>>>
>>> 1. Userspace must parse large amounts of text to extract specific
>>> fields.
>>> 2. To find specific tags, userspace must read the entire dataset,
>>> requiring many context switches and high data copying.
>>> 3. The kernel currently aggregates per-CPU counters for every allocation
>>> size, even those the user intends to filter out immediately.
>>>
>>> This series introduces a new IOCTL-based binary interface for allocinfo
>>> that supports kernel-side filtering. By allowing the user to specify a
>>> filter mask, we significantly reduce the work performed in-kernel and
>>> the amount of data transferred to userspace.
>>>
>>> Performance measurements were conducted on an Intel Xeon Platinum 8481C
>>> (224 CPUs) with caches dropped before each run.
>>>
>>> The IOCTL mechanism shows a ~20x performance improvement for
>>> filtered queries. The kernel avoids the expensive per-CPU counter
>>> aggregation (alloc_tag_read) for any tags that fail the initial string
>>> or location filters.
>>>
>>> Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
>>> 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
>>> 2. IOCTL Interface: 1ms (sys)
>>>
>>> Scenario 2: Compound Filtering (Filename + Size)
>>> 1. Traditional: (cat ... | grep | awk): 21ms (sys)
>>> 2. IOCTL Interface: 1ms (sys)
>>>
>>> Scenario 3: Size-Based Filtering (min_size = 1MB)
>>> 1. Traditional: (cat ... | awk): 21ms (sys)
>>> 2. IOCTL Interface: 14ms (sys)
>> What a coincidence! I was just about to send an email to Suren
>>
>> asking about plans for upstreaming a filtering tool for /proc/allocinfo,
>>
>> and then I came across this patchset.
>>
>> I have been following and using memory allocation profiling since
>>
>> it was first introduced. It has been very helpful for our memory
>>
>> analysis by providing clear visibility into allocation data. However,
>>
>> we have always wanted a tool to efficiently filter this data to get
>>
>> exactly what we need, so I previously developed a userspace tool [1]
>>
>> to help with that.
>>
>> [1]https://lore.kernel.org/all/20250106112103.25401-1-hao.ge@linux.dev/
>>
>> So this patchset provides efficient filtering of allocinfo data via ioctl.
>>
>> Would the next step be to develop a general-purpose tool under
>>
>> tools/mm that leverages these ioctls instead of parsing /proc/allocinfo
>> text output?
> Hi Hao,
> Sorry for the delay, I was travelling for LSFMM and missed a bunch of emails.
> Yes, we are planning to upstream alloctop tool
> (https://android-review.googlesource.com/c/platform/system/memory/libmeminfo/+/3431860)
> and now with ioctl support it becomes more relevant. Once this
> patchset is merged, we will prepare the tool and post the patch.
> Thanks,
> Suren.

Hi Suren

Thanks for the info! The alloctop tool looks great, looking forward to it.

I'd be happy to help review or test it once it's posted.

Best Regards

Hao


