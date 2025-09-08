Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D2BCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2218E001C; Mon,  8 Sep 2025 09:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852C78E000E; Mon,  8 Sep 2025 09:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7410C8E001C; Mon,  8 Sep 2025 09:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDC98E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:00:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CF4C1387E6
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:00:55 +0000 (UTC)
X-FDA: 83866092870.15.32AEA1C
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11318120013
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:00:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZHVTDzP2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757336453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UEOYJP0r+FFEln8Mu2fBE+f5b200C2wDFYA086EimI=;
	b=8bFv5980wiQMr1Gl6ktVa24FtcN+Dvb9g4T5FdaD9Q+/Yvi13T7OXoW9BezJObhymff8cM
	3CJvhsKhFBpseff9o75JJQEmqI0H/WUi1lFsapYsOxP11gpecBiM/4RRHTUhzj1hQPq6Mx
	1SoHyibjS1iDe98CWVNkrM/hxK/xuFs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZHVTDzP2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757336453; a=rsa-sha256;
	cv=none;
	b=st8kAzcpH7aa0BFMS4vh4lZyIfUAaWUmAd49U+JHML7p/PECVNgwr5kru3+tPzrIVG0cp6
	oBE6ixcNjKFaOFNY15vJn2mELFAnDPUZVk17oecE1Rmg10oeTqP1MtVyGySaMMrCmI/iSS
	HaU75seczuRzyq8Agu42PofNKslARoo=
Message-ID: <2c3d74d7-2e18-4bcd-bbd2-b1b4a65862c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757336450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+UEOYJP0r+FFEln8Mu2fBE+f5b200C2wDFYA086EimI=;
	b=ZHVTDzP2UPiVcytca0ZHAwFNZVGPLOdPOqnYKDdTAzYXFUko3aCbR6tPN+cirWmoPrrj8n
	65LaSZSRpRF3LfaKc/ZtGmLhVuZPo8mhlV7S/FKPPbROvEjqVZZUNfIQtE2WH22/xfk8p7
	MGubcn4ZA9ESmNWa5ugvxiooZfdikAI=
Date: Mon, 8 Sep 2025 21:00:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Content-Language: en-US
To: Kiryl Shutsemau <kirill@shutemov.name>,
 David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
 <9a0c07b9-5bf0-4251-8609-fbaf0ca75bf9@redhat.com>
 <5j6i2o6umqwxabdfncbrdytmvdma4yrraxe6hu4csckcniduya@sm3mlablwbad>
 <f58a472f-4a36-40e7-94d2-229125ae7373@redhat.com>
 <7pmksyuurzi2df5r7d2lpku63rbimjy5e3dzmleb63ik4257ge@2sm7yqfqvolf>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7pmksyuurzi2df5r7d2lpku63rbimjy5e3dzmleb63ik4257ge@2sm7yqfqvolf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 11318120013
X-Stat-Signature: kcirid5pie31ow3rm98h97scm1mnyede
X-Rspam-User: 
X-HE-Tag: 1757336452-892860
X-HE-Meta: U2FsdGVkX19B8EFdibjzqkYABSD7Tlnb3rkq7Pf7v+oGhYhHVsRDAJoK8O28R0WOQXrc28rmTrUZGQsXC2e+Gor+xVZtmRHeQm8uwhGfdyeP5ne9V7USCPbpISR7qgl40/3EfsN9yrDPHd4b7e9iVOAEUV3nShZzaRGhCK0VCyK/9Lq7K79pBvtrMsKLccM6DPURu8QVq2KayDXQz4YycwTq9ZYd8zrqJZiCRjjnSI8y6y94XmmduMfspLAlKmBYPkGloir/a0BvBIWUbtS2bKaAIw8sSDAEfmAAkCG1FUpW/5EnK/rbFhIDZsM8zE4WXlNykdtTPij1BjijwASKSQKA6UV/iRpgypJiV4gVCnzPxsmoznDG50WenbH7f7cTMhN02+xxEijUkWxZfg1ZUD0pSDOc5e3RZLWzfYkHxyiWV+DHzseo3sfOviXgPeEa6Z/MMt+gF4ClixtrNe2eCJIIaDH0qVve4Jt6MHqwuYA1hnwEO31Q9UmTNDTyMMJbbMXCIUFQYaYwBco65/gvGxaDAO4kMRurHgYgDhnfK6CBNCx7ecYJ+IVzmICwn0kNPAOJiDQtFMTqKqzmIwibcsTHwQnKsSAVnhqJjVZMEUdZjd2sihd2KxcAx8SSFeRArfv+RhGDdM8L14Q6HqZdMPSbCacjjDeJBZ58YkcfqS0GQcrUob12m+iw6qbECooctYKYjnI3Jt+fwIxQDIF1X12eEh/V0LKkuZZ1OE2abXbpKZGlJHb/KRSutt4MLUYjGx0BtwkQQFw2HX9FsKmHB3SGXwsT2EyqxuU4Fxd+CWTHum9q+sfieahNhGPmzfZlMCK47opjP9TSrTvkRDKRo8e2CJSH121ZJYjnucM52LE+yqrmN2I2xaqByFZk0EAVcY5b3w/xLBjLz+BYkCyGHg6KCUNuAM6QyfqesHVBgtkhc/s+aavzsN9j7pQacruWDrFjjG8LwPp+956XZAV
 wZTFYsLQ
 ECi/sr5yBk1Ef/8E0toLuf9bK2BGNZ6ZRCwJV/CPL7BscPaESCWiHVRdEQXY3hM0vqY9hDN/UaLKdtFpSEoR1pNt/qWD1rjF8OvTJQWBZ6ysMopkAf5heKP7R8xx9QyOl4s3q4Cjj7TrwyYXkqeHBPRNvmpou12h4ibV6v6XTSoSJ47zhtiyLT9klPqk5rHDg80SVfCXBxdgsyhnN8INq6yMEedJy7QZwyysJ75Nr/BMuNjN0XyFgoHY8TwJuIN7Zrakg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 20:45, Kiryl Shutsemau wrote:
> On Mon, Sep 08, 2025 at 02:04:05PM +0200, David Hildenbrand wrote:
>> On 08.09.25 13:44, Kiryl Shutsemau wrote:
>>> On Mon, Sep 08, 2025 at 01:32:05PM +0200, David Hildenbrand wrote:
>>>> On 08.09.25 12:38, Kiryl Shutsemau wrote:
>>>>> On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
>>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>>
>>>>>> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
>>>>>> it does not make sense to try to detect whether it is underused, because
>>>>>> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
>>>>>> actually replace any zeroed pages by the shared zeropage.
>>>>>
>>>>> It makes me think, does KSM follows the same logic as
>>>>> try_to_map_unused_to_zeropage()?
>>>>>
>>>>> I cannot immediately find what prevents KSM from replacing zeroed mlocked
>>>>> folio with ZERO_PAGE().
>>>>>
>>>>> Hm?
>>>>
>>>> I assume if you're using mlock and at the same time enable KSM for a
>>>> process/VMA, you're doing something wrong.
>>>>
>>>> In contrast, THP is supposed to be transparent (yeah, I know ...).
>>>
>>> Yeah, I guess it is user error.
>>>
>>> Maybe we should make ksm_compatible() return false for VM_LOCKED?
>>> KSM breaks mlock() contract.
>>
>> I was thinking the same and falsely remembered that we would already be
>> checking for that.
>>
>>>
>>> But it can be risky if someone already relies on this broken behaviour.
>>
>> Could be.
>>
>> Staring at QEMU, we have the following parameters:
>>
>> 	mem-merge=on|off
>>
>>      	Enables or disables memory merge support. This feature, when 	
>>          supported by the host, de-duplicates identical memory pages
>>          among VMs instances (enabled by default).
>>
>> And
>>
>> 	-overcommit mem-lock=on|off|on-fault
>>
>> 	"Run qemu with hints about host resource overcommit. The default
>> 	 is to assume that host overcommits all resources."
>>
>>
>> Now, I would assume that anybody who sets "-overcommit mem-lock=on" either
>>
>> (a) Has KSM disabled on that machine.
>>
>> (b) Sets mem-merge=off
>>
>> as well. But QEMU would allow for configuring it.


That's really interesting ;)

I guess it's likely that people are already relying on that behavior,
even if it's flawed.

> 
> ksm_madvise(MADV_MERGEABLE) succeeds on !vma_ksm_compatible(), so it
> wouldn't be functional breakage, but may result in unexpected increase
> of memory consumption.

Hmm... it's hard to argue that nothing is broken.

An application losing the memory savings from KSM might not fit in
memory at all and could be taken down by the OOM killer ;p

> 
>> Interestingly, mm_populate()->populate_vma_page_range() wants to break COW.
>> [*]
>>
>> But if the app later calls fork(), we still allow for cow-sharing pages with
>> the child. (another case of "don't do it", like KSM I guess)
> 
> CoW has bunch of these "don't do it". :P
> 
>> [*] it doesn't do it for mappings that start out R/O. I think we might end
>> up with sharedzero pages in that case, but not sure if worth fixing.
>>
>> -- 
>> Cheers
>>
>> David / dhildenb
>>
> 


