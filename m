Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7DE1CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B408A8E0005; Fri,  3 Oct 2025 22:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B179E8E0002; Fri,  3 Oct 2025 22:37:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2EA38E0005; Fri,  3 Oct 2025 22:37:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 937118E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:37:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 320B845543
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:37:51 +0000 (UTC)
X-FDA: 83958871542.01.32BCB31
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46B724000A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:37:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IO2KSUrz;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759545469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtsI3lx2659ed28Hsfe3yffVn1tmzg1sTkqeGJ64sdY=;
	b=dIYw6eNWLg60HEfP9fvwyKPsA2DyzXV8XAy5Xh7usBTwbb8sU89Ls5hZUz2e4+59i8p0LT
	FfeiWBQcsanCg2q77LLwq80wYsgEbjZEDEhWiqCUO/ySIJNg+TdnBjvZZOsAgZfTRAdbHG
	0W/MpQ18vjcEystQtmOiuu/YzdDjzxk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IO2KSUrz;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759545469; a=rsa-sha256;
	cv=none;
	b=OI17SNcGwHI8RFb7p/7rnlQ7uNbAcO+/307FJrSnbiGBWKkvABHjm+RykmNLgVKow8eEw1
	qtO9sf0JwvKwN6qAsQsTNrVig+QCNN4WtC0edGfYlYKop4tyGPHNBZN3cYmWPtrO9/NMtR
	ebJi0Q/G/RhDaG0DDihJSqbFO7OYYJA=
Message-ID: <6c4be2e8-04f5-49c6-9055-cef033716c19@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759545467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZtsI3lx2659ed28Hsfe3yffVn1tmzg1sTkqeGJ64sdY=;
	b=IO2KSUrzq3V4cuTh3UvbNkBrJC37Pe4HdjZa1lIkRq+QI5SWpv8888ULk3oRQ/d9QYS8Qm
	0dZg+eRRrT2guK4KsRhzfCQtFhiTwyE1bDA9xwVDVDKaG1ZxVGh47HBeZecDDyD59xJk14
	O2bQfUuPDvgjzk1F/Oo+VzJwxOfh0+Q=
Date: Sat, 4 Oct 2025 10:37:32 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 wangkefeng.wang@huawei.com, stable@vger.kernel.org, ziy@nvidia.com,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com,
 baohua@kernel.org, akpm@linux-foundation.org, david@redhat.com
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
 <20251004020447.slfiuvu5elidwosl@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251004020447.slfiuvu5elidwosl@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 46B724000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7q9uis65iac68pdjj7des3n9ufhyc1mh
X-HE-Tag: 1759545469-647346
X-HE-Meta: U2FsdGVkX1/d9YuOV4saC9UoORvj0Dht84DxtFc3fmeVzjYQmV6Xg3SSPq+o020JoRGNSzhi/OnOOVYyenQ4n4bTZqf3QIpOlqx3D92U1bbP8rkmIFZvcgPu4BgPAB2hRpOMJGb5HEnBG9jaXl+J4E4j0ktxFXbjOHeGdcsClyKd3H5vLmusd0BGsVl2FNMu+CtHyyYnLNQCaIlaHYZYWIq4T3/VKXnyUQtyjyYlvCgJg8eet/AtIZVSGDh6Q8HnFfAeOa8jlNBVamlU73y+sh9TZQDMeMJB1W6gdN/EInW3bWa2zwK93DCEjcjz12ZCo9wtpYFFdbI6rVy0Am63BdAV/+Tu2Cw3yMV13kJ3T1PwNsGjbgMkXBdQrvBnR32InQ7+z4Ll/9WIbTjt0/0BKasjHXGbqPbwDWa5bJsk6W+zjaoqf6wGqE4Y/hixrqu6xNyNE7ebP0Mumo7zZaWm348jOzmuiBvgcdo2LLZRYPpi5i4dqAG/I9aE098E7M9bCHzn1PiOlhjADQmMGNj/oCPPCQXjWBezsEkIRq8M+7GHYX32nkyp4hjF1+83iJpna42pdhaLq+uwH0cvJgm6tE8+t5DtzmjyI3sJTb0l8hcef/ZKgcax05vaVcsxJXUouXqNU+4mk1WMUCd4cn/ZLo1zkdAOzUlF8hf3o++IBUVKbYsOmmV41vFAuEmmDIu1hVqusb1m1GYQNMTVmvo+VxWWsbfpZj1ZF98pTALvpNK5E7gvSQFFJhp+QfZkw3jtAT+Yt04aYSk/sXRymkMxOzZ9m67+shwOoSZeTr1C3nuJ4leEkele5oEaYNCAeKxiKs1uTWX5x9gdCfAnqjEDVFcZFuIBpZrwalW4U1SwSEha96LsEO4F19ZRbNqVLRWTtNlGgKG3VyX4OAq9RzraXQuTMtnH1pv7TP+piita9YHGeWbFioMugcAEXm7bVWKcjgT/7f5FSCBrYloF2Dy
 J+g3/QEq
 O1wEKGW1z3a+wtDpDpAuh3/UwwG9ct0IOkAF7GVwBpmdgx1bjeUqdvhqfjtdU16kaFfCWQYtvxGEKpP5oOxv9edgm6awuLdASm1XHZncNBvcyH+KvXc4L/131D+9gmuKbNirlad9M5CMO73v/54epDOdr+Li6OeBF/XJHtiekYHuk3BSAB5ImLwMqbXP5SCXyvQ+SfcPSgZLtUbJrOs/SWqedn5stAxOh/9tISrB+/PELC8TY4xgjNl4x3I3VLPGigejsfMoz1dWFaWcA3TVcoiNiFHpWzQk+jIRV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/4 10:04, Wei Yang wrote:
> On Fri, Oct 03, 2025 at 09:49:28PM +0800, Lance Yang wrote:
>> Hey Wei,
>>
>> On 2025/10/2 09:38, Wei Yang wrote:
>>> We add pmd folio into ds_queue on the first page fault in
>>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>>> memory pressure. This should be the same for a pmd folio during wp
>>> page fault.
>>>
>>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>>> to add it to ds_queue, which means system may not reclaim enough memory
>>
>> IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
>> started unconditionally adding all new anon THPs to _deferred_list :)
>>
> 
> Thanks for taking a look.
> 
> While at this time do_huge_zero_wp_pmd() is not introduced, how it fix a

Ah, I see. I was focused on the policy change ...

> non-exist case? And how could it be backported? I am confused here.

And, yes, 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") was
merged later and it introduced the new do_huge_zero_wp_pmd() path without
aligning with the policy ...

Thanks for clarifying!
Lance

> 
>>> in case of memory pressure even the pmd folio is under used.
>>>
>>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>>> folio installation consistent.
>>>
>>> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>>
>> Shouldn't this rather be the following?
>>
>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>
>> Thanks,
>> Lance
> 


