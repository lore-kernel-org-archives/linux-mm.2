Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA215C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D836B009D; Tue,  7 Jul 2026 02:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935066B009E; Tue,  7 Jul 2026 02:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D306B00A3; Tue,  7 Jul 2026 02:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7C76B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:29:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C83DB168BDD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:29:22 +0000 (UTC)
X-FDA: 84961003764.04.10BEFB9
Received: from mail-m824.xmail.ntesmail.com (mail-m824.xmail.ntesmail.com [156.224.82.4])
	by imf03.hostedemail.com (Postfix) with ESMTP id BD27220002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:29:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783405761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXuPxdGo+K/EbtXbhcQEwjQvgO62RZh2uz1E9p8wcos=;
	b=pWnshoqE7rl1+xgw9b5RM1ZPsNmZNIljEgBSiJDJjZSrxEqwZgRWMJpIr0SzfzKp4c5lMF
	lZSkgtprpkHK+ZKdjVhe3rnmRHjCzGjJH1aG2kIJa6MI0OHBNg08bx1BebLoWb12xIVUlT
	1vUli34kdtvu0iYoHkn3g8Lr8CrO9bw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783405761;
	b=SeUiOXUmF70Ff8+v/o3vq8y9XRaJh5c89Df+OeCrYyL6dj7WvXeYrfnMM1HZdKXsyD3pKA
	zz2BRaZymInLoFYpoSWaRmmgX4wHU2L3Xgl9Kct4+IhSbdhVBt5QSjmksMm/MEnjIyFonr
	3XPI8eKIQGN5x+syk8lGg6t9VuXoTBA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c625bf4d;
	Tue, 7 Jul 2026 14:29:11 +0800 (GMT+08:00)
Message-ID: <d7a48a78-3792-4a45-8313-bd5d7ed102e4@easystack.cn>
Date: Tue, 7 Jul 2026 14:29:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
 <d86d309d-9f5a-4d63-afb0-dc4016fe1ded@linux.dev>
 <49526116-ce35-4447-bd98-f5f0ca12d92a@kernel.org>
 <f7bd2660-374c-4b2f-a274-8fd46368abea@easystack.cn>
 <16e9bcf6-3e7d-44e9-8b07-00a694c8e493@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <16e9bcf6-3e7d-44e9-8b07-00a694c8e493@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f3b442e1c0229kunmab920514456ba
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGEgdVh5KSEIaSx4fHkNLSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD27220002
X-Stat-Signature: gmenz8q8nw17de83obny5kxj75ndxwtw
X-HE-Tag: 1783405759-988117
X-HE-Meta: U2FsdGVkX19GPeQ1v35cU9+epv6bO6ahhafMl5H4989FDc2up7NCz6faFxG2UrC9Jvv7h4kfrMKbOyfu2ownRC9WqaimO/mCBeh6E1coVGMc8Kp2YeaHHk9VrvXg9IpY3kkkvtqY3JHoxNwzy8FvAIB20s2e+k/0GN2J8DGjoUCCeTXPEw8qOGYRrgbPz/J4hXhFbZZX/Iwa7vHlf5udZ2kCr29rJhjsd0skEjkeqsDLvzSjGvNl46DC1ZZntj0DlXjvq5wqNbGaJF/Fjb0o19K2hqExFTN/nfG4aqn0OEyRc1wbNxBXigiZINGj8Yaqshpk3eSolc9XZirgfM0+IuIFlSamRyTSzzeNX42Fphlz4Dw5XuhyHRUMsVwpPWY2n/OD3g2RX0EM0mpkYNY+zQkr53RLVz/Bl840HEV7kxWedE4hohAqT7KJs/cCh4f9tsKSDt+8SOEYy9J5uaL8tOrVIEt10IbT4vlvDQFT1HkU43IDn0AqOqKl1zIamSqv4aiViN4RWcNMygodkzDrvPr3rJ83GMgsgQbIVFlTb8PB+tHCY3sEv+zWqhHAAIwlT9tXY9CZLK0JwfjTNV6j9ge0DOCLYN8OlMZhIkUtjeMVnUfSvUyZcwD79d7YaL2vuT2C8lp44j0Z9tbH/YBi7AdVEPS8awnKvFuHuoC75X9j1ulPPIyyY0IKmGvZD9okcY62ycVPK2377ZPoJgcwavu6S0fjIsigoKJbsU692UdNovtJR8HTTfM8egu8DT6m43vA/SZopPKJhXIYbgORNx9aRPeGR2a7uXkmPxLqa+fhoH44HbfWupdAvc3W/HR7nf+7pOp466gF9qR1x7jbfFO52wWGopVl5bui0XGAOrQzzcj4ysgXaojL+qIg/0dz9z0BOuh6B/uulOnlNUhDCZm75kvJMYi6MoAnhQqvZ5+5Uzpx96pU+/zz4wBS3lKnwqyC6tewgk94+cA71g/
 H6dhTQi3
 cOECeM584akG4fsWVS2TJJLRgXGnT7ozMt4XgAm9mQicTrIFI9fldsLE4+AtuDhw1xQt10oDZ18T1Fw5TEAcaoyla1NcGUvrvlf+SxQBvGqQA8Qv1UGa4MO/thESvTcadIEJ3dgf30mO39Y3nvQ1Uw1MAAxxs6BayGGVLSg0cWA2U27BRoihWmScBmKAqz31JykevJ+t5U3+uMIKThFD3bA50wZdo/7tb8d2G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/3 16:51, Vlastimil Babka (SUSE) 写道:
> On 7/3/26 10:14, zhen.ni wrote:
>>
>>
>> 在 2026/6/29 17:30, Vlastimil Babka (SUSE) 写道:
>>> On 6/29/26 04:59, Ye Liu wrote:
>>>>
>>>> 在 2026/6/25 12:30, Zhen Ni 写道:
>>>> Hi , Zhen
>>>> The spinlock in struct page_owner_filter_state is unnecessary and adds significant overhead in the read path.
>>>>                                                                                                       
>>>> 1. Per-fd isolation: the state is allocated per open() and stored in file->private_data.
>>>> There is no cross-fd contention possible.
>>>> 2. Hot path cost: the lock is taken for every single page in read_page_owner() and
>>>> print_page_owner(). A single read can traverse millions of pages, each paying
>>>> spin_lock_irqsave/irqrestore — including interrupt disable — just to read a mode
>>>> enum or check a nodemask. This is measurable overhead for no real benefit.
>>>> 3. No practical race: nobody writes filter config to an fd while simultaneously reading from it.
>>>>                                                                                                       
>>>> Suggest dropping the lock entirely.
>>>>                                                                                                       
>>>> Just my take though — happy to follow whatever the other reviewers prefer here.
>>>
>>> I agree. If someone is writing (updating filter) and reading (getting
>>> page_owner output) at the same time from multiple threads, they might get
>>> inconsistent results but that's getting what you ask for. Importantly it
>>> can't cause any crash, AFAICS.
>>>
>>>
>>
>> Hi Vlastimil, Ye,
>>
>> Thanks for the review. I understand your concerns about the spinlock
>> overhead in the read path.
>>
>> The spinlock does have its use case: it prevents race conditions when
>> multiple threads share the same file descriptor and call read() and
>> write() concurrently. While we recommend users use the page_owner_filter
>> tool, we cannot exclude the possibility that some users might directly
>> share the fd across threads.
> 
> Yeah and they will then get inconsistent results even with the spinlock, we
> don't have to prevent that.
> 
>> That said, I'm open to discussion on whether we need the spinlock. As
>> Vlastimil noted, the issue isn't severe enough to cause crashes. My v8
>> version didn't have the spinlock - I added it in response to review
>> feedback.
> 
> It was in response to sashiko. Those suggestions are sometimes useful,
> sometimes not. It's good to consider them, but critically, and not implement
> blindly.
> 
>> So the question is really whether we want to protect multi-threaded fd
> 
> We don't.
> 
>> sharing or not. Because, the overhead is small in non-contended cases
>> (single-threaded usage) since there are no competing lock holders.
> 
> The atomic operations are still expensive and unnecessary.
> 
> Thanks.
> 
>> Thanks,
>> Zhen
> 
> 
> 
I'll remove the spinlock in v12 soon.

Thanks,
Zhen

