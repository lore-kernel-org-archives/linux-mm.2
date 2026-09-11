Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B0AC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC36A6B008C; Fri, 11 Sep 2026 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D750C6B0092; Fri, 11 Sep 2026 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C898E6B0093; Fri, 11 Sep 2026 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABCF76B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:58:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AC6B120137
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:37 +0000 (UTC)
X-FDA: 85200729474.17.50A7C02
Received: from mail-m609.netease.com (mail-m609.netease.com [210.79.60.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5234140002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXHqOK/AablWY5xphxIvXv9y8/1ByvZUWItTNKs8/bA=;
	b=1kBqwvTD3irYIuA2Mo4qvScIucssSRmQN4I0F7zUv/Esuj3E1QcXJMFgGowYU29vT17aKi
	0MP4SBzWjcUr9Mmc0WCepkyVplj2ZmQ5luxznaxmcfEj5nDFmBcjieBJFaOiEwXBCsAsz2
	krbEJ7qHJxfw2vEpVxB8+oXvBmhYVV4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113515;
	b=rbh98HACAzjC0BhCtGPGO53VEbjQJqmfWOn5EMVNHQPX69hKc8c3Nf7IjkjkRJ0CVr2TT9
	/j/tu5/An9RcrfxNSk/ewkzvqKS7o2d7IM1vveM9M1zWrfWrhcDJVkOuxtwmGvLkcPkkNH
	66oaaZs3SzQTqcpdMAcXSdFXlQaQkhE=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ef640672;
	Fri, 11 Sep 2026 15:58:28 +0800 (GMT+08:00)
Message-ID: <d8d34e16-57fa-48b7-93a9-afbf4b950ce6@easystack.cn>
Date: Fri, 11 Sep 2026 15:58:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
 <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
 <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
 <b8e23456-00af-4097-a769-210a087d2b90@kernel.org>
 <22D1EC4B-FBCB-421E-B8DA-345B5F3505FB@nvidia.com>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <22D1EC4B-FBCB-421E-B8DA-345B5F3505FB@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa08f79a0bc0229kunmf7504aa32b18de
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZH04dVk9MGklKShlPS04aS1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5234140002
X-Stat-Signature: nqcayjoz7n8j8dr1o36n5jn6gic5hyj8
X-Rspam-User: 
X-HE-Tag: 1789113514-124474
X-HE-Meta: U2FsdGVkX1+LJDhJYTvDWwjzB/ZeiwaN/NSaODjtGCRhBxev6zXrrX5XmvgmVfc4KEOisqs2pvDgdG4XfUT6NAMUMEGQoUGeC3RtJEtbZjYqmphRuJCgKOiCfwAzksxjQHKJ94djQV89/QX7+i8GZvBwsayuDbVImcRpP7FR83WjXLtloSRFAfRyBfHOPOYYiUjK3LyXvxXMQrD433sJ2IMiIY/k2rbKR0+JqN6nDnp+LlFR/oZVZUwCpBc7Y14sWPJaDrtlakQYZM111WMyQG9GnvfMcoobmYQabbySUDVA1AIEi35Y1NvQx5rFoaDzDLdyw0IErOUYb6rkb0LiQ2RpCbwPg+kn8hQyRg+M+EjA+O7Mv5wLd5uT7pxkHprqxMjsBz6cMI2eT5/SdKqIXCiAzUWCnH0PmxhwD4j9Do1vPOL34CYkVw05NEQNjqqF07N73W7b0G+YH0LtMLA+9iro0chYbK5VXBrI0ETkRT6sepgl1qjaMiT+9vsGWS27Ppb4DsfB0i/D+yXgO6PII+Ey77VClEC6bmPsZgkp28tSrOLNhVeRpXiy4ISG3e+tm4K5k5NjDNWgbznh0leQLUSIw5ITjXDHvt4hidi49/FOvR5/F42q1GREIEe2M+V/5TYYrIBWzMiRD7L8ws8JLS306dL8x/hyNbSyB38juOavBpSTQPFao+wCtfAbme5OOsu8WxI14O+4FUDvGtWGZHWUUZecfGAKw/ZmEBtDW3xyB5LZfxcDt48OAy0i9M+dVjycc1dPHnMRkr0QkuMWwMCYM+Y61bsRDHC2vOnAmO1qYB2OzNl3iRBvLyZolmKcHwLhZjWl9iE7sqNtqjHac4rA7pV5Qmsnt3lvFJG5t5+KXiPfm/hdBkzoB2AyRKDSgI+91FbfV/t9fUa8pymYTy3DmBt7DrXngxXfhKNuZ2jRw7ha6+t8xwtNzTThELBxPLr77xlmoWr0y8ZGSOs
 G3dWoxAq
 Q3ZSh3EZJJ9xxse+NXQxgoRSIfNfOrYtwma3SFh5CJJtMgNbrQwXQgD3q67lEggTcJBbR3cYKhTnCOFn8YrpLMYz8O8h6nKQunengpCLW4sHCjiORJN1ZokvgQ8vIkVcfPK283+P2yWC0EhzdNnxigkfWx2PX0ebJ+kLmMJiIyBfiF6KIIBi9bDmQogHz7io7SAwobIcZJM5XmrFzrT5qHNVd36H1PeN7qjeiT2XBL8xMAX2v+MF2F5usWhIEoLppMj5k414gNC85qQglyHZnc8FD9R30zLiC3SIdC4Ks6klhz4FaxCRXZRmEp0Ox8elbeMabtlT3xYvlZyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/9 23:54, Zi Yan 写道:
> On 9 Sep 2026, at 6:28, David Hildenbrand (Arm) wrote:
> 
>> On 9/9/26 04:35, zhen.ni wrote:
>>>
>>>
>>> 在 2026/9/8 22:30, David Hildenbrand (Arm) 写道:
>>>> On 9/7/26 10:26, Zhen Ni wrote:
>>>>> This patch series adds process and memory cgroup filtering support to
>>>>> page_owner. Following the previous series that introduced print_mode and
>>>>> NUMA node filters:
>>>>>     https://lore.kernel.org/linux-mm/20260707115411.1714314-1-
>>>>> zhen.ni@easystack.cn/
>>>>>
>>>>> This series adds filtering capabilities to page_owner, allowing users to
>>>>> filter output by specific processes and memory cgroups. Users can now
>>>>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>>>>> memory cgroup path. This makes page_owner debugging more focused and
>>>>> efficient for tracking memory allocations in specific contexts.
>>>>>
>>>>> Targeted filtering provides significant performance benefits on large memory
>>>>> servers by reducing both execution time and output size. By filtering at the
>>>>> kernel level before reading, only relevant page allocations are processed,
>>>>> dramatically reducing the amount of data that needs to be handled in userspace.
>>>>
>>>> page_owner is used for debugging. Why do we have to add kernel code to make it
>>>> faster?
>>>>
>>>> How much faster are we talking about?
>>>
>>> On my VM with just 2GB of RAM, the raw page_owner output takes real
>>> 0m6.178s. Filter it down to PID 1, and it drops to real 0m0.286s. Handle
>>> mode takes real 0m0.938s — roughly an 85% speedup. I've also tried this
>>> on a 1TB server, and it's very slow. The numbers would look even more
>>> extreme.
>>>
>>> You're right that execution time isn't the main concern for a debug
>>> tool. But that's kind of the point — I'm trying to optimize the current
>>> execution flow of page_owner, reduce unnecessary overhead, and make the
>>> tool more user-friendly (especially for servers with 1TB+ of memory).If
>>> the user only cares about a specific slice of memory, why dump
>>> everything from the kernel side and then filter it all over again in
>>> userspace? Might as well filter at the source.
>>
>> Because it results in less kernel code  :)
>>
>> And less kernel code is good. Unless unavoidable.
> 
> An alternative is to add BPF hooks like bpf_iter to do the filtering
> and by default, when no BPF program is attached, everything is printed.
> 
> 

I’ve also thought about a similar approach—perhaps a new bpf_iter type
that could iterate over all pages by PFN. The advantage would be that
you can fully customize what you want to print and what you want to
filter. However, doing so would require refactoring the entire
page_owner, and I’m not sure whether it’s worth pursuing in this
direction.I’d also like to hear everyone’s thoughts on this.

Thanks,
Zhen

