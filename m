Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27731C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088E16B00BC; Wed,  1 Jul 2026 10:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0399C6B00BD; Wed,  1 Jul 2026 10:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A186B00BE; Wed,  1 Jul 2026 10:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9FAE6B00BC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:09:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1ADD1403BF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:09:13 +0000 (UTC)
X-FDA: 84940389786.07.FBB0337
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C282C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:09:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ytyg1HxO;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914951;
	b=1RF0mDTi3qbqODMOf0yHztn8i3DC3JYlDBfRo/bjXr0iXE7QONuLz8+1ijA2Kl5gYaeBuv
	2C0lV7mm7ARbLAtJesNk6p1Usqe9sNYvYLOKOOcN8l8cn/qKM79FcWsBBXq91HXJ9pxuLJ
	rgouBy07Qdvn7TAqJJrYarcIHqNTTDg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46MFV16NDHBS0YYz/g1khsqLQgu2b556MgiPh6BwUuk=;
	b=ti2BwImfzWbcSCQwzaYZLDhKFlBDK5t6bQKyprUsVr1tfJ7DiIMqEKsFOv5JazFP3lcPpR
	SVNG2phY1XwqZxVbEf6k2HdbQvxXu7aDHW67CIqU3Ds98z8/BrwShIhhIfLf1HQZ0C0HQu
	PEngmCt/Bd50rBVa4gZicNAChc+td2g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ytyg1HxO;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <00056bd9-265e-4e34-b11d-c63307b8857e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782914948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46MFV16NDHBS0YYz/g1khsqLQgu2b556MgiPh6BwUuk=;
	b=Ytyg1HxO0itBzI7rC9Gtmx+Hlg6ch1f0sI90RD2I04Afvb0gn8YCXIOwhr43ANQdABmoiD
	l8sNjjNAW3C32tuu3ZKXXPdEFkD0QjIZyXhDNy4poT4gL3pRV+++Fal7P2LP78mEFd5BxW
	itvBjXS5TkbL70UnplFsFv8EydPaPns=
Date: Wed, 1 Jul 2026 15:09:02 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 5to1n1gikmish6ab17kef9oipfa8ae14
X-Rspamd-Queue-Id: 2C282C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782914951-718684
X-HE-Meta: U2FsdGVkX1/+6a0sjGq1HCcNnlHhhUe/Ul6vzY3HawAdN8EnP3dmHLpl0k494BVMPzHP3zBRrmTyBbw4hCoWQEHMEVTA4LAiQ/afq+2yIwiC4eXPjzvXqY9BCR7XpT7oTiTygvxlJb7CodKQgZ+cbITxTynZQDyldxm2d+xZj+wZiogLoOehpnxz5QdprJ178zgaDdgrsfZRj6o5Xk7RkhdG1E7sLIp+kPuNiMZD7f4HPy7NK5b4hxUsx/EuYxhxKOg40RYoxFUF1hlmAIq/68oB7CvEk6jbnQzpX1Fy7X+x3ryLWl+wOyUY+zS4xwYXZOUO5y3PI99vRlxjCAksciAOCozyiTR3Kua7f8vp8RvnEfXcTmfpFUTXUWs0y862XDwLRsS1EqjGWtonYENpNXMuJxpPRAsEL9c5AHuXnXJkwepJeiyOhwiQf5jSJXlqxXB7hF2oO+p44XAicLRZZ6SVDgOk3UN8Cl12+duQXlQJ/I0LxRGQpqQvimQbaOOtQWu7kU9hastN1+tOAVAZxNXRBVXHGrsOLWVsiuY1TOYBIqLZ0ol8c/G8n1NgUQPZTvkUsi+RsRkI7wBH6gGQk2p9KE7iF5wWwiFTB7yTG6zWZ9sAUeyxWcacXUrUvUcspFUlE6KlTnpAc+aOzcHpAV45TvXNHyr+uamDwuMFGYhp9rmo5bbqCLOCBVbAUb8YvYglBRzxiYQ4gzJAX2XVnHjudjItgGhITnEGSK/7jGqAS2dXqqQw6DQTN7cmlFeaSuh0krBIIHPgUTPmQwrYj9dqmo6bvmk/GH19ccsIJy/zGnjlTo4l2SwxAGsFWYbLzWFICmXc7jB/RbOEQurX0Z+KY8rgsVrrVS7yrH6103NaRwyBrBqGOvOfQwZWgO3j7O2co7AUG0ZYZymu4+bRp2VhLRYoQZ2MMo+CRYLCMrnV5ylJaNkaBEZOhjo1cEtZs07RbkcxThOlw4C+SN5
 CF1yRe14
 +4BAFJpEh3TXvUVVgR5qy5v2270AvbDFBmhcJ7Zf26kttlSFAfn9GinzdZG0wN/kUs75Fwtkuuh9mvi4WqOTgUYvORe9JGTbI0XQg3lwc+QAdOSgVc1uqSPUTMk8DjvmFsSWMkDCAkYHsnZzq2BE6ytV/N1dPOPgTZqdk9C/PbBjw/lrOcZ6oMlfRMyRne7TEiA+x2BSVkDYM/6qk0ygoOcXIDXFAZYAxrmuCJpuB0Cspvbcrfu+lJQbzMwnbPmdYW8W4Q0ZnPju7UYO6KfFuI/V1QNnGzqNJw37gdbJgvM8WdfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/06/2026 20:50, Andrew Morton wrote:
> On Tue, 30 Jun 2026 09:34:37 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> This is the preparatory part of the PMD page table swapin work. 
> 
> Thanks.
> 
> This comes reasonably reviewed, so I'll queue it in mm-new.
> 
> Why?
> 
> - Human review coverage and AI review make me believe this isn't the
>   final version at all, but I do believe this is something we want in
>   7.2, and getting it under test early will help to push it along.
> 
> - Getting it in there early means that others will base their work on
>   material which will probably be upstreamed this cycle, so this gives
>   them a more accurate base against which to work.
> 
> Sashiko did find a lot to talk about, some of it pre-existing so can
> people who work on this code please take a look at
> 
> 	https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif@linux.dev
> 
> 

There is one pre-existing bug pointed by sashiko that is not related to my series
that I think needs to be fixed. I have sent it in
https://lore.kernel.org/all/20260701140638.840773-1-usama.arif@linux.dev/


