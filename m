Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DA7E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 09:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D7F6B0089; Mon, 29 Dec 2025 04:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B716B008A; Mon, 29 Dec 2025 04:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003596B008C; Mon, 29 Dec 2025 04:46:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E33E76B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:46:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 814B5161050
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:46:56 +0000 (UTC)
X-FDA: 84272029632.28.500BAE2
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id BBEC9140008
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:46:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADEric+f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767001614; a=rsa-sha256;
	cv=none;
	b=lRAO1aAc7B2uldCWONbewdEWwHok+PVeE1XNPEgv21zfGOSuIG2hv+psIW1e2/NaP55j0g
	GpyTwjBYwniw5sqeQM9YzvZfU4+VzU/ZhBAWp20zdCZBJPtaMdYu0QSobS/nJ1g6ItQ2mB
	RG3QBD0mXPdieEojXUFp2jqx6qMTc6E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADEric+f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767001614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OKyxTjD0H3g5gaPUdSXPikpKgZJEr/E+X1ne1t0XVQ=;
	b=zfFhqofVaH59axKtN8VLdHSATYc4gKG+HMnpU8vHdxW5BnH0epI79ozHoM/Frb59uH/EVr
	D8wv1Vbm8Ow9gLcIpy0t3HU/il7cgnmo8yNVBTojSiwMUTlIUi8fvh9WkUELV6RyKEbjee
	+Bh+rUeUxs7rL2off+I3BsdnZzauX6Y=
Message-ID: <9bc4b18b-ef3a-486f-a911-f0bde17d0fda@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767001612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7OKyxTjD0H3g5gaPUdSXPikpKgZJEr/E+X1ne1t0XVQ=;
	b=ADEric+fKhdk/4/PBMwv5RLooXGGqJ8T+4VjOhN/w522cWz+MZQsm13YJbhDGEOIPO8CzC
	QAvo0LeFbG8w/k1EzoJp+l6jxm9OzNuNugXTlERmkp4a5d6Ab4S2KrArB9RgAHKKCeP6UZ
	hruzehW/3NpqebHBeaTMA9lloLxmuC0=
Date: Mon, 29 Dec 2025 17:46:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <1264fd2b-e9bd-4a3b-86ad-eb919941f0a4@linux.dev> <aVJDuObeV2Y99em-@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aVJDuObeV2Y99em-@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBEC9140008
X-Stat-Signature: smdrwnxaptdtmirq4opzhhtw815xmc7p
X-Rspam-User: 
X-HE-Tag: 1767001614-45709
X-HE-Meta: U2FsdGVkX18Qz0E2eM6jinCvdBzWQURghxGJvFX6ISvxxwrrbN6DTirrszG0GARWVLzQgHuyaPtaolChKQxj5t+5KM9gPd0jkukSOqczet1qmNZ2jBRle9/IX2PWXy1rvR8cGGpFa1OwfSZvDk//1XjiUIbqkrPcGwE/0adK/ggFgCFQAzkihJmhsQZEwFmZ5UKrKPH8ikY+S2DEx66DwBbk9pNBjjgDkcY3CBIEFgz0FSb9Rjn07UjgNW8GBVs3hblOG1XHoomhw51NoG5LlfN85UEJo2WQI78CMjrvYTc737rZU3dX7mYn2cEotqitDjDVuMwZSV4Yv0MYh2UeliqXj19L1Dnrd3QBK3uginJ3ZiwSjckck3TyVIOOndPq42l7Q4HfNS79O2vj6G3gMCEfy44s7lhMDoFKfuXJw54bIU8RqAuIz5wBEAI7z7y9TfmIFkfp86M6ybuIQeguwqNsmFSHPhSkiezXUr2D2a4qn5JtAid/jLoT8PUa/SqZr/bRmKbz4GntX3uaE4tfFKR8nmzZ7btTpPT0UeF9y2mVnTaq35zurWOVubJgwmBsO+CvOOWSE02WOq9WzWwyYTLivXRl98VE7dS5x+BrTR4jAlYW6A+F8xddLAYALj9RKzc7fP9t/GrtcJYjXCMj4g+Nz3NAkE8fC6X/G6FF3fz/zp2ishCRx9YxcMaYq05IPEvHsC5mMwKU3B2PmRxrWQviCC3ILzuwEPVLJ+Qx4z8aq0syWP8pjEPyyggDVh3zJxoeQ/XsNrEB3Lx+PgH3LybZnJyxsR/g9NViqrLroXl2aAywRsTZxKzMotlTYEJxlNycYio6YR91TnWr/Ipmb5j+uEM7w7Y901tEgTa1fEC99ZvP84eKkb+P5kWOk0ofs74HrrdT0hQ5DMETI3d0rOCL+4RJVEZH5KvSV+uTFWXdpFgBt5Xc6GQjGEHy4Ja0F3dBBr7lZfmR1xSoeUb
 22FdxRR8
 KK16iQMegzkrai89qJbGXEX8bQ7FrvBediNQeriI32MkLbohFWSNCExMhPmSYg30NoIzhwPfdzwdLOHxc60+NlBIRCmwfRS6tEzPKcaTHUiw/lGh6O+FquFewshWwcO9bQw2Csqm4cU6bxXO4wQ5Li4LL9cQekYdl5E8erwPyp4MqIS0awVi87fj0ZZTAEJsNnCDkGRAj1hJCk3WvywtiyvY3gLz01RHziW84g5pEriyDfLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/29/25 5:35 PM, Harry Yoo wrote:
> On Mon, Dec 29, 2025 at 03:48:26PM +0800, Qi Zheng wrote:
>>
>>
>> On 12/24/25 7:20 AM, Shakeel Butt wrote:
>>> On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
>>> [...]
>>>>
>>>> I think there might be a problem with non-hierarchical stats on cgroup
>>>> v1, I brought it up previously [*]. I am not sure if this was addressed
>>>> but I couldn't immediately find anything.
>>>
>>> Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.
>>
>> The memcg-v1 was originally planned to be removed, could we skip
>> supporting v1?
> 
> You mean not reparenting LRU pages if CONFIG_MEMCG_V1 is set?
> 
> That may work, but IMHO given that there is no clear timeline for removal
> yet (some v1-specific features have been officially deprecated,
> but memcg v1 as a whole hasn't), implementing Shakeel's suggestion [1]
> may be a good option (it doesn't seem to add much complexity)
> 
> But it can be argued that it's not good enough reason to
> delay the series; adding support for V1 later sounds sensible to me.

Yeah, I will continue to take a closer look at how to support memcg-v1.

> 
> Anyway I'm fine either way and I'm not a memcg maintainer myself,
> so this is just my two cents.
> 
> [1] https://lore.kernel.org/linux-mm/wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5/
> 


