Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C6DEC1EA4
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435546B0092; Thu,  5 Feb 2026 06:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CD66B0096; Thu,  5 Feb 2026 06:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2086B0098; Thu,  5 Feb 2026 06:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7C36B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:29:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA9D0B9AF6
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:29:11 +0000 (UTC)
X-FDA: 84410181702.18.50C91C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EAB2540011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:29:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TErJNjE8;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770290950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdCHm7L8lwf7aRhlpKNDP+CdejUQkLHCmEL1Z845I+c=;
	b=uHOe8PsUdLZDPXe324LIURDfUr6X7thFi/hBNWHl5FzXouDlbW0sIo2rJhnIXS71RzMOD1
	PMXBihLWqzs1MLyXfpAvbCdhaX0g2urR0KKWoD/mDFIMaROAJ9MI+6jCGDmjDdQZCb9hDA
	n7xre0XE+xFtKR5K8WpLebusAz5L4n4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TErJNjE8;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770290950; a=rsa-sha256;
	cv=none;
	b=Lr75sVi9bmO3v4P+drjdnUTqK47UYLZi1ThGZlk64PJz4kvO7T1iY453BgP50wkDDN7k6z
	HReyO2rA6mDr1deDNNvGFPRff9b8BJmd+xXxew1oW/9l6+kFAYrU+hN2TOnEKNN/y9QhwC
	7KR/UlZBFQ+u88OSStneuEKvCNfRqQ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E747643F5E;
	Thu,  5 Feb 2026 11:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC0C4CEF7;
	Thu,  5 Feb 2026 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770290948;
	bh=2/W7EuzY4IMz1l8dTAG8zDYFwg6ODtMAuFP1RhD14yg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TErJNjE8pXU4ioIQCFsthACI6+zDq1vR8hHb/krS4FphhCRmeqBignuwxhDLkKMG2
	 zYrsIOTECc6R8LAreh/EKZInDFtcsTbAzM+Zl1oGmI9llY3hIM3JkrS2uZJfTkjzls
	 AkSyWmqy0rQcaScr000OthMqsWsqVY6YoPauWmt9FqyOcIydViv1APJW5TQ3rfuAAk
	 z7YnJMUYRpdGgDYKg1+471b2e+Z8jHqPfxmhwN8jI+GCDmz5rgGvb3k7ymsmhDoXfr
	 JQf9MmGbhpaSujGrHIp3fNOYXxJN4qN9j5H6b+LEfCSAHyATQWXh0P3IR1rIbC4yKm
	 dEUlh/7irNDsA==
Message-ID: <75e1f8a6-19c4-4fe1-9ab8-e732a5fdfa5e@kernel.org>
Date: Thu, 5 Feb 2026 12:29:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>, Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Frank van der Linden <fvdl@google.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
 <7d246914-6077-4dc1-bbcf-8dabbe6183e7@lucifer.local>
 <2B979847-CED0-41AE-AEB1-BEFB267B1E14@nvidia.com>
 <9c1809f0-8c8b-4eb1-9ec8-6c00fe3097f1@lucifer.local>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9c1809f0-8c8b-4eb1-9ec8-6c00fe3097f1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: esje5c8b8ow1i7rsjwyk73r9x11gm8ys
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EAB2540011
X-HE-Tag: 1770290949-45345
X-HE-Meta: U2FsdGVkX19oyzu9IWoseQ5Aqz10ZicmyJ4/8qUk974EeHAX/oP1F55bfSRWEQezumfHsc+xofcQw6d4IZ/QPu3gKV2umXTbyG61VMYopZ0eu+INcwmI7ZB627I8X97WfdeGwnLM1H0B7cgnou0/8Y1lXwxxpHBXFnsS+cxFalGTDcMS4lc39UWmiUmgSAMkJsbbJfUfF4sG6z/sxqUiomLIQNPtu9uMsA34stJKf8DolGRcm39mF9gd4xgf0ZgYgjiJqG/FbhgyAZTymwVed98ktkYGV9YXp33T5mUDnZVLrzdY+3FaGY5J60eTSMqDbHhqVihghDEZmlXk1xwTD/7V7giW51Uz8fSbUPQYtfbbxwJaonaw9b5wCmIF2Pl1n/SMhTYDWow6Mi3FbuwJPXfB15Auii5j15lWIKG24y1uzkkdwgiuqmTqkCVJeqq9OXZJh3uuW8ZUMaCZa34xE7pJ9Hc16GmrLopWre97jFJIC0fqnCT1blgtdkphfgc+WIIhsTM+/KzopDKyLkk9hqQH5Z6YY/cAtFd5FeAHLSeE32vno1682hnP8WRMp9GHf6y7GQzk0L84nq40GYiVbboJV6f5/3tFBHgh6F1AGJ8B7+UrgWLar9bKsySyuyKi7lX7vmN6B/Zlt6HJE5gEc45bOVgB+9mSko4uOZpjiL036LnKYcDZRNIRcLhJF8OU2VVXltL49dk2ik9HGoVl4dcPZEtCQts0T+2rDrpTSWFs5K+nlPttg/Wi/94svv6yvBviQQCmw76/XCGm5BZqAsL1YU3jwPo48T3RdCI2ZJQQTprGTO0K8eJGpXBfYSXuTSVzrnjX1YLS8Ux3A0pTbU707jfCw88SbL4Yv+A89RpJJbMUcmOCwqgu5mTlgWe+stPCXCdq8NzeGM4yFLr9sFuesS5LStFJbYU+m2iFHLL0ZJDzZtDYbkKKVTdZtaCl8afllhpKFMyDICRJJhy
 JcudM5w9
 AMR7N0+jLKy4C7/LyjLD8YlnazHngWUAbHpaJPfvhNe+TRK3PzUzB7ETibXQVIQ4eqB1elH5438U/M9RUlBC1mgmhsmq5i1T2fGn+OeY1pVX8bHFO9laTxh9SfJcada3PtIzB/LyIO8BLqoMWTSbf/ELE6zwZ4BdzydwSkN20BRFWqvZFcwx7Ftu1wb7cQS5tagORRqVq45xks+QAQYro6+1lMVr6M1m4MYZyJUodM6O3AUn0VVm/Ui8nXKaBJnFiATfg2FdOioj9eJHRsETkwaIhBjNe63UUxmCaHPGgoG/tjVbjYsd0s9Pm87pL9yU794+pJSLeXIALF7W7Kv75Pd0unQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 11:56, Lorenzo Stoakes wrote:
> On Mon, Feb 02, 2026 at 10:50:35AM -0500, Zi Yan wrote:
>> On 2 Feb 2026, at 6:30, Lorenzo Stoakes wrote:
>>
>>>
>>> That link doesn't work?
>>>
>>> Did a quick search for CMA balancing on lore, couldn't find anything, could you
>>> provide a lore link?
>>
>> https://lwn.net/Articles/1038263/
>>
>>>
>>>
>>> I'm not really in favour of this kind of approach. There's plenty of things that
>>> were considered 'temporary' upstream that became rather permanent :)
>>>
>>> Maybe we can't cover all corner-cases, but we need to make sure whatever we do
>>> send upstream is maintainable, conceptually sensible and doesn't paint us into
>>> any corners, etc.
>>>
>>>
>>> Could you expand on that?
>>
>> I also would like to hear David’s opinion on using CMA for 1GB THP.
>> He did not like it[1] when I posted my patch back in 2020, but it has
>> been more than 5 years. :)
> 
> Yes please David :)

Heh, read Zi's mail first :)

> 
> I find the idea of using the CMA for this a bit gross. And I fear we're
> essentially expanding the hacks for DAX to everyone.

Jup.

> 
> Again I really feel that we should be tackling technical debt here, rather
> than adding features on shaky foundations and just making things worse.
> 

Jup.

> We are inundated with series-after-series for THP trying to add features
> but really not very many that are tackling this debt, and I think it's time
> to get firmer about that.

Almost nobody wants do cleanups because there is the believe that only 
features are important; and some companies seem to value features more 
than cleanups when it comes to promotions etc.

And cleanups in that area are hard, because you'll very likely just 
break stuff because it's all so weirdly interconnected.

See max_ptes_none discussion ...

> 
>>
>> The other direction I explored is to get 1GB THP from buddy allocator.
>> That means we need to:
>> 1. bump MAX_PAGE_ORDER to 18 or make it a runtime variable so that only 1GB
>>     THP users need to bump it,
> 
> Would we need to bump the page block size too to stand more of a chance of
> avoiding fragmentation?

We discussed one idea of another level of anti-fragmentation on top (I 
forgot how we called it, essentially bigger blocks that group pages in 
the buddy). But implementing that is non trivial.

But long-term we really need something better than pageblocks and using 
hacky CMA reservations for anything larger.

-- 
Cheers,

David

