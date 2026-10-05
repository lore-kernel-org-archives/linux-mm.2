Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE2ECA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 15:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156956B008C; Mon,  5 Oct 2026 11:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107466B0095; Mon,  5 Oct 2026 11:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37AE6B0098; Mon,  5 Oct 2026 11:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0D7D6B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:36:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 674CD402C0
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:36:59 +0000 (UTC)
X-FDA: 85288975758.05.EEE6ED3
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D23840002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:36:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QoEIM2Ha;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791214617;
	b=w/QUnP8eaPfF5+0XNFzIhj3HL+kx/8vFucvzr67FieVHjS33/IQp9oMVKo8t0XspTwEWQo
	DBL2Apd3jrkzfV4f48mHe8EgkVTcJcbN+NriC665RgFhuiBwPcbZxK27lnIA4jDMzTXqVP
	SKOyh/md7ip8Z7dAAFUPBOb65WPDqh0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QoEIM2Ha;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791214617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUBuiof6DvhZfufyvJ9K9IojiW0eiKyws5GfCSVQra4=;
	b=J00yhLzU7kWvFSenqXZN7mnyJ4tP0wtSDfwIpEYzI0eJeQafeRhTHga/zgveOa87uvC283
	7txwfRuosShAE+klwxeiEQZEkGQJsYyKksOjV1Y1Zqi0Szd8UeG9X+WWGGvzsDxQyLGFjC
	EV/ZlC0GvoQQ2D1H/qlIV4gbYw835JA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5zX+01E1uYtcKNTedIU5E0EoruaCd2DT0fqXgC7ia5I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791214615; v=1; x=1791819415;
 b=QoEIM2HaXyPtk7CN494dWenrpWjsWWgEMg+swUH9vkjcn2co6GeBCNw8Ph6nj8SvPT9DDQzg
 KOULzsPzjm5jNf5CQjkZv2FLUVjTpabtBq3Cl3Yl78+V6HkS+GE7HCDuEHsooEYsxrHW/KwSo8w
 325ie3y0MOYH9BNQaciGz8lE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8941f7e82ec68c72;
	Mon, 05 Oct 2026 15:36:55 +0000
X-Mizu-Trace-ID: 8941f7e82ec68c72
X-Migadu-Flow: FLOW_OUT
Message-ID: <6ad07601-eeef-4fe6-9758-f6936a3bff41@linux.dev>
Date: Mon, 5 Oct 2026 23:36:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
 Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
 toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
 <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
 <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
 <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
 <9459bab2-b373-4008-8f3d-f84b62db5b67@citrix.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <9459bab2-b373-4008-8f3d-f84b62db5b67@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6nwm5qb9zborxpe84yta9gb9zoo6jiqg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D23840002
X-HE-Tag: 1791214616-953168
X-HE-Meta: U2FsdGVkX19IiZqq2kWOIPsIqZ0+h7y41YvEZ1ZaweyV2paIeSFGGHM1TeT26Nhx0qmpmrzuDF0luqQvoOJkyuCH7Q6Te0KvfOKbXiWgNyjftXmB5AduQj7lW0HPAxj/lrBjEFeWtvVTu1b3Q09f4A/Q5+4/MPYnyLsf9KcT6yIzDJFL/QTXwce3yJ2EzqFSo4DD+c9RASKhfp+ylV24eTEVzRHaa3Pzd6dbBKSpDizzVQGNfw7caXdkwfY3M8aPqCTvXqnSuyoj3nyMdQrdQsVncB2294O7r49BbDxwEECVAB8y/gomeXImvq/FRz9MDzEJZoCQuC7T9Uo8yRQLDMKDqUzGtT69SFfRH0jdIdOMM1teMIhiZmmVoHd5JloZtGEBiR1FhNwyKDJ3jnpMIYQgi+IFoQlwqj5bwtIjRR296c3H34gzwJdtoxI2pNB26JYyutxqAusFqcl/CyJl/XGbb6d5UsuPMOKdDLR9/DqSuFTMDotvkwVihBcE2Kz7G2P6aS70yr8pjmArmyJMQ+QUWGD7/wLyZ1fL9rgYARmuwoOFUHrkbIjOlWqhUR2Zh1Q1VX8H5E1XyGFjGQEI2VLG7GfljsJuj51aqOA08t7S2/A5ys/6AGh7hHJLIj1NZZjNVX/9jnmWeJXaT5UjnDB77l8+CpYHIF0hbtWCXOGiM6zv9JT4GszRFnzZP6fkh7pnrCuM+IuGbnVJOSAFxVClig2O9mgG7/p/PbRJ6C//7nm82BTjULMyG8ZFcAaqib6d9BlaEkv1Dpt6wqwsui/syIMuU32JIHF95wIssTdeGvjdchjmR3ctfS8SC0LMla9AFrL9T4rJ68blQILQ5o40iRWMJhLUrHoBCLspkI6sAmIa4Sj+hDFuXYI8AWsMn97x8hp9BILVnyyJUcOtxn0rh5bLKcuicIQtRaG9QMrbMjk422jUZ4BCI80odcogIKijshAFWFA1cFWkhVq
 1QxcV0My
 7Elrq5zmHWh4wBt86taI7BjmqnAfhEwSu5WUznbFi7k9dz440ARiUA3cE+U0v4HUnjd9aEHO0YyT+nWhWuCKS9Ns/3enIREb5YkI9K4y4LvYqzoJLOPM2yVfpB7fZNo9JvrEZvjnJxdyfV4VngFGxBdYJBH2RMDchsHpvRNi639ApJjpeay4YCfS6J8HzebSH41JiIewQQrHXuFvWYgD7raA/wiDYyUn6RAIKZzYow6Qn/dnkK99FFdGQRxgEfmAUor22ApN/+jtCtoQ4MDKDRwkNQKL54EGi347O6VsFDkzHWo1qgtbozS2oD8DFMD4MzyUDz5ngo1vr28HnBW1JfpHqWld46cwI+rSc3z/iKliIkckBuj8zNrbHlaRz0L20aczdobRZAuqLdVCcqDRWEF5jGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 23:22, Andrew Cooper wrote:
> On 05/10/2026 11:12 am, Lance Yang wrote:
>> On 2026/10/5 17:57, Andrew Cooper wrote:
>>> On 05/10/2026 9:32 am, Lance Yang wrote:
>>>> On 2026/10/5 16:19, Andrew Cooper wrote:
>>>>> On 05/10/2026 8:29 am, Lance Yang wrote:
>>>>>>>
>>>>>>> Did you repro any bug related to this? The functionality is perhaps
>>>>>>> underspecified in the AMD manual.
>>>>>>
>>>>>> TBH, I don't have a reproducer yet. Just LLM stumbled upon this while
>>>>>> I was investigating another memory corruption issue [1].
>>>>>>
>>>>>> [1]
>>>>>> https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/#t
>>>>>>
>>>>>
>>>>> What hardware are you running on?
>>>>>
>>>>> That looks like the Zen5 issue, for which you want either the latest
>>>>> microcode out of linux-firmware and/or
>>>>> https://lore.kernel.org/r/20261002211617.1001617-1-bp@kernel.org
>>>>>
>>>>> TCE is a no-op in Zen1 and later, so unless you're on older
>>>>> hardware, it
>>>>> won't be that.
>>>>
>>>> Just to clarify ... these are two separate issues.
>>>>
>>>> I mentioned [1] only to explain how this came up while investigating
>>>> something else. I'm not claiming that TCE caused the corruption
>>>> reported
>>>> there :)
>>>
>>> Please can you answer the question.  Which CPU are you seeing this on?
>>>
>>
>> Which CPU? None so far. As I said, I don't have a reproducer. I'm trying
>> to make sense of what the manual says and what the code does ...
> 
> I'm afraid that if you're trying to be helpful, you've had entirely the
> opposite effect.
> 
> TLB handling is a complicated topic.  What you've done is present what
> is effectively a query about the AMD manual as if it were a bugfix for
> an critical-sounding issue.  You even sited a real bug-report for an
> actually-critical issue, despite it turning out to have nothing to do
> with your submission.
> 
> The patch is buggy.  For starters, you should be checking is whether TCE
> is enabled, not whether it's available on the system.  This causes the
> more expensive option to use used even when TCE is turned off.
> 
> But, AIUI INVLPG only flushes the whole structure cache because of a
> windows bug which caused it to crash on a 486.  AMD deliberately
> introduced TCE to remove this overhead for every OS which didn't want
> lumbering with a workaround for buggy windows.
> 
> Linux currently believes that it's TLB invalidation algorithm is
> compatible with TCE, so at a bare minimum, you need to have some kind of
> discussion on why you believe this not to be true before claiming that
> it "might be unsafe because the manual says so".
> 
> 
> It's fine to ask a question, and even ask "so shouldn't the code look
> like this?" but such a patch needs a very clear RFC or QUESTION tag.

Thanks for explaining! Lesson learned. I should have made it clear
that this was a question about the manual ...

Let's drop the patch. I'll take another look.


