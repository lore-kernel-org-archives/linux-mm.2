Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E904DC44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 11:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1976B0005; Wed, 21 Jan 2026 06:26:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445046B0088; Wed, 21 Jan 2026 06:26:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350FD6B0089; Wed, 21 Jan 2026 06:26:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20BD76B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:26:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC2A9BD171
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:26:15 +0000 (UTC)
X-FDA: 84355742310.06.8AE4D4D
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf15.hostedemail.com (Postfix) with ESMTP id F4044A000E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:26:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bTZV01Al;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768994774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EI3PnO2ne3zU35Poebf9UA7r2AUkoJbbfNXfGukOLUk=;
	b=os3S1vrvvbIvCvMjgSw9sBpWpvmrzH1uEXRDc159iWaJiYmjnXcydvV3vFEvGLgJ8LYUzG
	DwvKxoF4rNBUzm7gCVgNUJKwfEVItKILd8x5lgKuCfQreywZGhVKyz0K8NFmLxV5NnP2Tn
	b2Tn84FTC/UPgQdWFZqJ7y6ZtA0G89o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bTZV01Al;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768994774; a=rsa-sha256;
	cv=none;
	b=CtnH+e2z5EFnFpzloq2VMq4h9Yg5sq+z9eOq7uaUsDh+4uH5ppOCNTCy7q9guwJSQRCU3g
	WNs+/aCA5JV0FJao0JZD/2Uo51R6QjMSOJt2/unRbvVD0Gu42gpPvCKQERrOiL+WTMx/hK
	BTcpWzTdYyq56IY6zG4OXHbQ/b4waFQ=
Message-ID: <7c49e382-9f67-4a49-a884-47c96ab348d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768994771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EI3PnO2ne3zU35Poebf9UA7r2AUkoJbbfNXfGukOLUk=;
	b=bTZV01Ali7NQ0Pn3QESP2LOgMVmYpkdVmP4rBR66PxR0itj/VUlFqvpJ/itCWXVTp/Yjly
	hYcwvqrg6rdDvmyZPbRY5TWkftQgGasc9tH1Qb4lQUX49dDOldHGUpXA0Me9bIi2XY0TRB
	lcUlt1qpotSi4uKtUn0n4jB/d1Kw/5o=
Date: Wed, 21 Jan 2026 19:25:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
 <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
 <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
 <moupi2ch2cpuyrurthk66igh275ks62pltjk2zfngxozj52oxs@64lxvcgh3ays>
 <37734a82-1544-4015-b4dc-30583441a7ba@linux.dev> <aXCIsLQMSdQ2GNc4@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXCIsLQMSdQ2GNc4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F4044A000E
X-Stat-Signature: 98yhkuwb5fdmj7oxpi6cganeajzcfcds
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768994773-704775
X-HE-Meta: U2FsdGVkX18qncG5D4qhuMAqMTmBmOsD0mqHT0XNQBvVUja6C/CWIcBDrK+cAslxbUor/ii+7hpk5PVkqpclUWaBvcdNN1K9YHzhrMzGZ7i+kg4KhckXSUT+mUyNt9kIIQxyyjPJ7R3TB2rjqRj8FQXzHrh8W58n09wdI3l5sZEFYVREZkmDRRoSfMzkQM1A4Iyd4jRoUGDGhbOSL0pFKZyaOVBq6vnIkogsbwUrU+xfH44su1/aRDDhJNP/NxcMUI4PCEvUtfZGnEqLMFkUOpgiFXRgwo12U9y2seOw8EFBUsmc11MvLcdlaTRZT4RYxgLtkRUS1qytT6m+z1iC2dCQpMjL5k5T4OWLWZ+JngOEQ5am98P+TwxP60vbzP+U+5q+WiaKzC+MMAW6hZFPNmnbfaMpBfVJErFDihfEnEkYHEVvQthjL1k/POWQnPcVUJeFN9dOM+9W0kTDn60eJPaOTB6Y117A7zTRi6W3zTa9CCxF8pI/8IABx2LeoyIkwFdZHd8JVQ1VD1hwVeh/82G5UP6asAa6UV9yX9VWfCmP5pe3P5dIzCxd7XAaPrZMrp1lY0v6mof+uvPI+U9S8QvlPpgpkbnwIB9UZXkQfK1pIpBbo8ttwIu9tn2mRSX9HfZJ7vpMfyM+KGUFPFUQmBCYHFQpbIakKwlABdnx3lPCStKUlcBRHGPGjGp59C2jUKmYgv/8/avoUPr2hh/5lBFy9REPnvWJFgd7GfdWIuZbVJ037Lrk4lmtbO563qf01VUDrRR+RM8uYFhPu8Y42WP9uRWKmzBRttP5XuTAsvbEo6YMCl+ykR5+DzAaTVYXF7r2RTYEwR6qyHzo0sEilRCPoZvr2C0NkvLFnMUMxqecHg6XIGaLswpHWYvHuJQ6/qqjFjC3n4u30lS1jEHyNGZkVDZYObbB3OKG7Wkswx3qymxh5A+1mQnPDIxRniRpuSivcEIF4DFK0p+aVA/
 Hb3vs2se
 lhW6x0ODGemHSeYWnQ94PWwq58ltK5O1ic2l6ajcFix7YRvahPZC5KOI1iu5Jtfidt64ijl/5H6REwRPwIfcEQ/y3vp4FormF+TyAG80/qfQYk/2umGYrBuhqwSEoD8/E7d4Rgm2W8/yEM08ZdFS08H70Ps1JWwQTEnuEARqX7v8S3nG7ZKKVxtJXO2bXw0CtF3NsLqyjHvC1T5HeC7raqpZXBzT7oxCcWOheZE4G/HKxS7Mk9EzhFl8e8mFX2juaRJyB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/21/26 4:20 PM, Shakeel Butt wrote:
> On Wed, Jan 21, 2026 at 11:43:50AM +0800, Qi Zheng wrote:
>>
>>
>> On 1/21/26 2:47 AM, Shakeel Butt wrote:
>>> On Tue, Jan 20, 2026 at 03:19:00PM +0800, Muchun Song wrote:
>>>>
>>>>
>>>>>> No reparenting local stats for v2.
>>>>>
>>>>> It seems that lruvec_stats->state_local (non-hierarchical) needs to be
>>>>> relocated in both v1 and v2.
>>>>
>>>> Here we might need to elaborate a bit. Specifically, in the function
>>>> `count_shadow_nodes`, the use of `lruvec_page_state_local` to obtain
>>>> LRU and SLAB pages seems to also require these logics to work correctly.
>>>> For SLAB, it appears that the statistics here have already been
>>>> problematic for a while since SLAB pages have been reparented, right?
>>>>
>>>
>>> Thanks a lot, now it is clear and yes it seems like SLAB is problematic
>>> but now I am wondering if it is really worth fixing. For LRU pages, how
>>> about using lruvec_lru_size() defined in vmscan.c. That would at least
>>> keep count_shadow_nodes() working irrespective of LRU reparenting.
>>
>> Do you mean calling lruvec_lru_size() in count_shadow_nodes()?
> 
> Yes but I am mainly brainstorming. We can keep the reparenting local

OK, I will take a closer look.

> stats for both v1 and v2 for now as it is not a performance critical
> path. I am more worried about the stats update path where upward
> traversal of memcg for CSS_DYING can be costly and I don't want that in
> v2.
> 
>> But
>> numa_stat interface also reads lruvec_stats->state and make it visible
>> to the user.
>>
> 
> Not sure how this is relevant.

My mistake, please ignore it.

Thanks!



