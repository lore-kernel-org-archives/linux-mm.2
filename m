Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53AD6CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B9D8E000D; Mon, 10 Nov 2025 22:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625928E0002; Mon, 10 Nov 2025 22:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECFE8E000D; Mon, 10 Nov 2025 22:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A98E8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:29:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF0AD140396
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:29:19 +0000 (UTC)
X-FDA: 84096895638.29.E3400F8
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8280E20005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:29:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U51cVDT+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831758; a=rsa-sha256;
	cv=none;
	b=TWUX38mM4JI08eDzIV5bF7fpOEaIf9EtSP5XGQtkykOXPb0NyWh3osTWj55KZy5T3R4h9W
	kpzhRKzdwD3i3vxcxWTqlxuF4hyVhXT3moCHTuMLsgwO1eCBHWPZ+r+Qkw00r6bDWzFyYg
	HbDjG3bHo+VPN4m3MRgZaTetJ69vWr8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U51cVDT+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4Gwun/4Q7PEKmKnOLx/o5MXaYbKvzj+YtrVyTMLJUI=;
	b=s4oq9c4P9vDa4I3gg0iJvUyaNeD/DcW/j5HVAv9BxHPoWDyF+k7dhaHtMqiIpt0UhmRXZ8
	jgN5iOFyq+Vx3QA/JhH7iuxTinrWLdAfJax0IsZlFHSoDWWw5RCoWNhsJ5MUAqWK3QaewY
	UaiLosb3JK1Z+cJt15uNDKvRa/JXqTo=
Message-ID: <b2750e21-2853-414c-9552-4f7faac12afd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762831755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N4Gwun/4Q7PEKmKnOLx/o5MXaYbKvzj+YtrVyTMLJUI=;
	b=U51cVDT+HoQJkqGpZyUh24NPRj8r8kB9s7IFPlUaPzcFECva7S0Za+l8wdZrgWmjPfgS9X
	sSk5DXMwygzYLR9y19gvsioIxANWmk+n4/q0Cg1JMGOY4JFs9V/Rqu1YROgCP4lqMFD6I8
	3RF7Cs0QV6cRRGItbLSkpv3V9yP3X8k=
Date: Tue, 11 Nov 2025 11:29:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo> <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
 <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
 <99429fb8-dcec-43e7-a23b-bee54b8ed6e6@linux.dev>
 <hgf4uciz7rp2mpxalcuingafs5ktmsgvom2pefjv3yogel5dh3@7kkwtrnqotnc>
 <982d6b8c-53e7-46f3-9357-afb85319d0a3@linux.dev> <aRKq-JOzoCW9kKMz@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRKq-JOzoCW9kKMz@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8280E20005
X-Stat-Signature: n98sncsewircrsp4wy6yoaq7841yjbty
X-Rspam-User: 
X-HE-Tag: 1762831756-974934
X-HE-Meta: U2FsdGVkX1/qd/8o6YSnRpf1avt6EUMd0HwX3xhTN9FIsSSWJwxyL7bq+ACH58S97VOwSoOQXNGvXFwRw99lER9+ZhovcGRqWGR1tuw4/B4mEv1qEovOzRye8UCDCSSrNgXdbqVRvBn9QFRTPxGLDNm3XHM7MRxdQ79eFbdE3RbujrFyKWGLCj5mrWVjG4Gr0qCht0yBNz0jEmzvcuYGTadSxcSclAU5oOS+9vZKbzpquRRcbUVUL4rL5vuu01d0G9tb2ot9/QfaJ+MPE068xRHPM2eExjQrhi+2mo6+iSxKrB67xvzrmaMpqHC/BFlsD3BziMiTQxUN5sOoNSTK8BT5OezMYnyumEfWyXrCIl/r5PmGP3+8UF6AYSGXjmTpwWgJL8OoE4iHhEzeoXFNlS55EfLPSlt9VvUvyWdbvlAvL10wMyfXfuJDOexak4aRv9avwxU4A0kKEYNzGmAX/TGILDNbG3rLM5K54WV3fBeMF9paF00D42c1w6kVyeFwQ31vU6/3N2JRvQ03KvoNN3Ae305qQ8sZJM7CEMHOYdtZv2Rc+RrC30JVOK7KGfv2t8ld4WVEWHqpln+guSOjVknhvgysIRNdqRTnwotl27OBNPgL2LAEqfArFwnh781piIZyV+uWY9COh5xCl+fg4AsAe4RSf4qx3bGsulO1h/GLiwOxZYjvzfQYdro2slGiPoNztjLJ9T+AU1aaWEIIdj4vjchzxKSZeq/R++3hCAp6/AKOw2s8+59m5pmo7g+DtvajBZOxu5dUoidDrGTbDPUrYIyv68UlcIy1k7aqsRwS66DkdgLhMzgO0pERxDhtdyxfgTmyqfGFG1I97zXkSrO70xQPJk/eAdZ0DMkG1k/iZgtReGmFDkl3ukABN3KV+lGCGbvwUzugSJIkOWTTZmqESfMYdKU/5Gg79cGfdfK1L32Ry6wTyoT4ZFF4tGUbNSTZjHSuijWHOyE9Xrs
 jAMp+t1f
 6fJfShRkOarmAUo/uUJ5QayoQSPjP+WCZkYTOngyDrKsnECJnqilzLer1pCIq0linD7Xu2FKmyuvDT71JI7PtEqAuXbp4Pe9fSDbDSiahLYxFiv5rsB6v7N/H3hnduKH8nCPj6y61NbGltjyJeCz4CDlXaXxA0i8F3poeMBgBKl0lv0wVDEq2T2+6/4oRxRL4Icmr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/11/25 11:18 AM, Harry Yoo wrote:
> On Tue, Nov 11, 2025 at 11:07:09AM +0800, Qi Zheng wrote:
>>
>>
>> On 11/11/25 11:00 AM, Shakeel Butt wrote:
>>> On Tue, Nov 11, 2025 at 10:48:18AM +0800, Qi Zheng wrote:
>>>> Hi Shakeel,
>>>>
>>>> On 11/11/25 10:39 AM, Shakeel Butt wrote:
>>>>> On Tue, Nov 11, 2025 at 10:23:15AM +0800, Qi Zheng wrote:
>>>>>> Hi,
>>>>>>
>>>>> [...]
>>>>>>>
>>>>>>> Are you or Qi planning a follow-up that converts spin_lock_irq() to
>>>>>>> spin_lock() in places where they disabled IRQs was just to update vmstat?
>>>>>>
>>>>>> Perhaps this change could be implemented together in [PATCH 1/4]?
>>>>>>
>>>>>> Of course, it's also reasonable to make it a separate patch. If we
>>>>>> choose this method, I’m fine with either me or Shakeel doing it.
>>>>>>
>>>>>
>>>>> Let's do it separately as I wanted to keep the memcg related changes
>>>>> self-contained.
>>>>
>>>> OK.
>>>>
>>>>>
>>>>> Qi, can you please take a stab at that?
>>>>
>>>> Sure, I will do it.
>>>>
>>>>>
>>>>>>>
>>>>>>> Qi's zombie memcg series will depends on that work I guess..
>>>>>>
>>>>>> Yes, and there are other places that also need to be converted, such as
>>>>>> __folio_migrate_mapping().
>>>>>
>>>>> I see __mod_zone_page_state() usage in __folio_migrate_mapping() and
>>>>> using the same reasoning we can convert it to use mod_zone_page_state().
>>>>> Where else do you need to do these conversions (other than
>>>>> __folio_migrate_mapping)?
>>>>
>>>> I mean converting these places to use spin_lock() instead of
>>>> spin_lock_irq().
>>>
>>> For only stats, right?
>>
>> Right, for thoes places where they disabled IRQs was just to update
>> vmstat.
> 
> ...Or if they disabled IRQs for other reasons as well, we can still move
> vmstat update code outside the IRQ disabled region.

Ok, I will take a closer look.

> 


