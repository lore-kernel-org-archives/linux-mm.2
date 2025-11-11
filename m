Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D92CCFA13
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 02:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582428E0007; Mon, 10 Nov 2025 21:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532DA8E0002; Mon, 10 Nov 2025 21:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449298E0007; Mon, 10 Nov 2025 21:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 326068E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:48:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E9CB8924
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:48:35 +0000 (UTC)
X-FDA: 84096792990.07.9D7821E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0ECFD4000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:48:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sSNpu3UL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762829314; a=rsa-sha256;
	cv=none;
	b=6u4QgDKA4SSR7cC7LJbmFGpgj4hvKN5ukdR50DCU+iCuuFJ7Y3eAx3SJ9XpZ/aI1DmPWDI
	cDMwuwz1zEcfkbJbixSbNoY7AsVPDRfMtGzB3lqOn0+m5NoW3lwaJt0PumQQGgppY3vMf6
	e7lqTBP7d1JniwJv35cgQZGwkJ5HCWg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sSNpu3UL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762829314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpTvE8Rrz+iBUsvxU9XIT/WrbpcwDHgcPlPzJcVRRVg=;
	b=gN64ucV+R1TWDP6tcOhPRz6LN6yD2vZrrbgDMnNp43sxudiFHSVWI99fchcX1lBNnZGtim
	5BcktsPWRUikNtiI36Q2jN4Ov8cxEKpjnziiDQmqEQEoUd4GZxRuzmkbgQOtHuNZTQyua6
	H1JCIJXFlsJ/Rjqv24jQzlbsvx9rHSs=
Message-ID: <99429fb8-dcec-43e7-a23b-bee54b8ed6e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762829311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vpTvE8Rrz+iBUsvxU9XIT/WrbpcwDHgcPlPzJcVRRVg=;
	b=sSNpu3ULY/cNZ+A4d1Y0Du9gO2K+uzrWXWaVLZBN9O3nQ5viEcBh0vrqe9DZsCltNYRmqV
	RgokJpqGWgDlp/Zqq4NqdHIH9q0Ot8CaBEYqU5PzvmQwGyBwEsfXaHCCluEmksz7CSBvsd
	LSerrPmk/XUPXcmgWytmEMdbL7oWrFM=
Date: Tue, 11 Nov 2025 10:48:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo> <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
 <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0ECFD4000A
X-Stat-Signature: tkgqn9uthhm4h7g9bmx37i8wqm39i3fq
X-HE-Tag: 1762829313-18945
X-HE-Meta: U2FsdGVkX1/VeLrUS3Uajl5tozPpXPCcik0M+GlBeEPuhHfYoB0nMeu0Kew5zTuOakJJO6gpt/ueXTkLc6DRYMjt4ePmET0Nq4E8C3G23awO8cXTzgB301FWg/0BRBjBX6kkYGknYwghVTkZGRD83TPsA2uxGgEhGLZZWVrQjoLO2mCA5zXTlhhMb/JMvGVV36lNssjQmgmCjMmIVOA26FrNq7LKcXR9AybxThACjfJlCwb4RPpujDGfkZiNAdtChJdeH/f73UiLqS+JqOIllMn19pvLRLF71Zzs6BnLsFkHhmrlxeYz8jKMsJhIE+UpLpdEqAsWNN+/5z6OlBX4Lh9UlR2mwwcyjW6oSzP6ahbhbyNvccwWVLbFaKO9EobBAPHukQ4TRiDoyMppGBb8siW8q0Ri4q4TyvMy0b+S1PgfipWxImsuLwVsGrfdcOzHjNQPCG9/Vuvvnc6D37UEyim2LdDCnNDGBrKPxQ1U/61HCsiBDdlFyRi5J1b8mxefBXoHPIMh+N/FHrlZ0QNMJ3R+KFGnHap0hW7O8PBbFN0qJd/a1qJrmUuQwV+gIpwL/7T1X9rN2Q7QoVT68W7jSCUB4APyNbNI5RziOxxKDUnvy2V5x+/b6jzvOU5SeSxQaPWGzuY32TDg9odzA1gfGTkwRLL+NS/6TERBnyG7wDH7tkpDoTsxrT+0PduHOPEbFwO9DQSQ3vTahmBYUMJ6mRfG6hXX6j+WM1S81eAyEd/silHP3KBAkDKb8+26PGAkFBGKAOkznobQ0VFdI2vZEj7YE9h4bzFnCIudH8BmehYG8VGIfSPn8iVHRWMeRui/EZiZlWuYsYnBw/JfF3kI4zpBa69irmHO1fs8EhNB6wcmEQoiF8xVf+VAtTM0HMFhKTuUHL9zeGR/OOLOn0sKbjKXiWwVmVWWwPklZgFw15/SgYNQv/ooEk0/jaQyGlrxiAhwyQ6xeUrLMlAqH9F
 pf0rNb7H
 GNIdAx0pC0LzpcV31+2v6ARpasHKbiqmHdTd7tMzgeN34AXqhahkE8GArw46ZDYR4pSMfqCRZoNKz3HY/6PSpj5MjX/yqasEZ/zCEGoe6GJYTddEnz3TEIt5nG77XLV6JYLGo4Jg9zMfz7r0BRD15O6B4xIi3kgt9nuNEp+xEov1/Wm/BSuoWpmk5hjZkQvdW9ZKBqt7uCc3EyCYgu6XuMMnS9ZnA1g3LWaULrNEMlrEQq+E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 11/11/25 10:39 AM, Shakeel Butt wrote:
> On Tue, Nov 11, 2025 at 10:23:15AM +0800, Qi Zheng wrote:
>> Hi,
>>
> [...]
>>>
>>> Are you or Qi planning a follow-up that converts spin_lock_irq() to
>>> spin_lock() in places where they disabled IRQs was just to update vmstat?
>>
>> Perhaps this change could be implemented together in [PATCH 1/4]?
>>
>> Of course, it's also reasonable to make it a separate patch. If we
>> choose this method, I’m fine with either me or Shakeel doing it.
>>
> 
> Let's do it separately as I wanted to keep the memcg related changes
> self-contained.

OK.

> 
> Qi, can you please take a stab at that?

Sure, I will do it.

> 
>>>
>>> Qi's zombie memcg series will depends on that work I guess..
>>
>> Yes, and there are other places that also need to be converted, such as
>> __folio_migrate_mapping().
> 
> I see __mod_zone_page_state() usage in __folio_migrate_mapping() and
> using the same reasoning we can convert it to use mod_zone_page_state().
> Where else do you need to do these conversions (other than
> __folio_migrate_mapping)?

I mean converting these places to use spin_lock() instead of
spin_lock_irq().

Thanks,
Qi


