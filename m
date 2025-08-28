Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A483CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961096B000C; Wed, 27 Aug 2025 22:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938396B0024; Wed, 27 Aug 2025 22:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E4D6B0025; Wed, 27 Aug 2025 22:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 704B86B000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:53:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC271C0957
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:53:47 +0000 (UTC)
X-FDA: 83824646094.16.7C98C83
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf29.hostedemail.com (Postfix) with ESMTP id 81365120003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:53:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756349626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtTb7Hrp8laFmFeofhPLdBX0m4too6Oyp2xbzadp+2M=;
	b=xm3ixCDi92TE8jVrgZ5GfUS3/4vFW0KJ95WApG9GSoboHI/ItFiwlnIEFaNwyS6kJHymRi
	bAppDkVgw0cZX7Cr06yesTJ4Au4XUZmznZdjFSdaF1qGoiBtsyachp4k5O4XKMqlCpA70X
	rylpg76gYlV0FpfVF2lgE/k0egYzTWw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756349626; a=rsa-sha256;
	cv=none;
	b=01hcSsB3/1MKWldml334QWbkRjcTHU9JcTyyTU/e1kyc4h2aGB+sjZo7Z5/tRPhjDf2y4x
	J0cpuIEUIOg72XF42FYTlZsUiI223KT6bY4lHP69bEChnJXun5j+hpFZEDblHJMir56tF+
	XtAhe7p3nKI+zOg3Kl0kXuKs+Be7Was=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cC5T52Wwpz2CgHR;
	Thu, 28 Aug 2025 10:49:13 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 91C2114025A;
	Thu, 28 Aug 2025 10:53:39 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 10:53:39 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 28 Aug 2025 10:53:38 +0800
Subject: Re: [PATCH v3] mm/memory-failure: fix
 VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory
To: David Hildenbrand <david@redhat.com>, <akpm@linux-foundation.org>
CC: <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20250826075710.278412-1-linmiaohe@huawei.com>
 <5eb5dbc1-274a-4932-8c77-8000509deadb@redhat.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0f0a190a-9a69-dbfe-6964-a0574cb5fc8d@huawei.com>
Date: Thu, 28 Aug 2025 10:53:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5eb5dbc1-274a-4932-8c77-8000509deadb@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81365120003
X-Stat-Signature: hxz4ytmgu4g4ebri8xmpo73exohqhwgi
X-Rspam-User: 
X-HE-Tag: 1756349624-974249
X-HE-Meta: U2FsdGVkX18UU4jFceS5IK68J+/Y8DljrNrKFH5xrxY6X9+O2EHZ+2Oho3tEBxvzQIuKg8F8eCZjnDuXmrdR6rkbfmpeU2YZTkaN9yyNkDlJZR0igWb05pA3JBpc3hjUrTJfjbFAy5lvSUT75NzSCDFXu4MxL1QdGOYVVNe3RJfHdpaV+0S/DmQFtkkvv1QV5CTCn0GmOc41eD+7kqF1YHqf68IMoRWDfva9RSTp0cY1SRDATPA+wPcqtX9sSImH0hoXMPQovjH7X+RwMZWn9tRBduRtZkmTYmV7e6+HO6iJLq6+9rr9jkK6avj6LnyNqpRAs0ZDwKihQgXo059G5iqi+ZT7ljAnuShjyDT2dOhsTJzQ957WZuDt8ki40aVThlyxuR0YuUwCQwwoppu3lEealQ57tcufUu0FTkM/IAzjT0d+1yPDasejpRiBS+Natt7HWnQ/uKqGYzlR4dl/dxioWxBvckRi26+leLhTwS0QfeDtmm29klXwbVXHHPyqXEvT1pUely8oVadMdQTD6733fX+pfYTLCEHqF1RsbxMCGeM6HZLh3boWLZGsHu5OoUt9FSBD424JEoyd5COavTWFOW0JxbYNq0L9FfhxVWwFoNnKC8n95n1rmpDZZnMRD9iudKr5u+hpk6+FHGbD3hTOzRvVf38XHE36OqQysOG/kKqprCYxDFDG+/xxWbOf4G/XU4LPcj3H+ImplKMJojd2uJceCV1GbaLEYlLgqkQVID6LgMvoyP4wt0TEddEd3IqHV7UyIXPfK6h+EB7oM2TFE0P/VXTDQFMem9OjEZEdf2jSezNoIz9aiX0hDHJygnG/tfp3JBTf2RXCFOEfkbd1zkMLxxa7Cx2lR41dDeOi18DK14q7haQV24JuDCfaUWqv4bc3XD4oEJZLEVBxCVGzn7OVjrzjR7FktH7aqT/1X6cQVvnlYoxhz2hRG8OurVyw8c5ESfFqKyi1HQK
 XHq3OceI
 YkvPrJd4y3u4ffQM8pTJ+JAarmYQByEY5L2EIjNBEMpbhJzjcLQWMaK+IfFqtJmMqIai0AyjQArrdWsBWsJRWOzgRJUHeKgUaFzjbxI8BJ8cBTdUU3EGIYKUsmJ6oAYvG3tHsvNLusBtYl8r5dsxcPtoqtxOVxH9+LVlG8Z8WUNznPE5VzNb4TXfLZjCscPIXTntXg/+WM46429cIDTLqpS6Av1pWvqQ2x8j7EakeRF9hqguBaJKlo2+yee1UkzHZxIF7emf1MT6c6rQYF6pc7ucnKTT6s2uHJszVOLW3qKhWTF4/wFpUX6Wn4Lk09RRk3qyJ+9mis4WgChhM70Ia8DLeky7P+Tn2f6sDZuWwCNBGSTrLgyfuZR8pD2x4WxbrkoGrtQoTwh7VZI56ImhTjiK8WUmKo7sRs4gAyJ+AQigtCwwtifaZmvuL88QoEb6BYPygYU89mn+ht4s65uthLJNt225vLtPwVGFi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/26 18:58, David Hildenbrand wrote:
> On 26.08.25 09:57, Miaohe Lin wrote:
>> When I did memory failure tests, below panic occurs:
>>
>> page dumped because: VM_BUG_ON_PAGE(PagePoisoned(page))
>> kernel BUG at include/linux/page-flags.h:616!
>> Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>> CPU: 3 PID: 720 Comm: bash Not tainted 6.10.0-rc1-00195-g148743902568 #40
>> RIP: 0010:unpoison_memory+0x2f3/0x590
>> RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
>> RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
>> RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
>> RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
>> R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
>> R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
>> FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
>> Call Trace:
>>   <TASK>
>>   unpoison_memory+0x2f3/0x590
>>   simple_attr_write_xsigned.constprop.0.isra.0+0xb3/0x110
>>   debugfs_attr_write+0x42/0x60
>>   full_proxy_write+0x5b/0x80
>>   vfs_write+0xd5/0x540
>>   ksys_write+0x64/0xe0
>>   do_syscall_64+0xb9/0x1d0
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f08f0314887
>> RSP: 002b:00007ffece710078 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f08f0314887
>> RDX: 0000000000000009 RSI: 0000564787a30410 RDI: 0000000000000001
>> RBP: 0000564787a30410 R08: 000000000000fefe R09: 000000007fffffff
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
>> R13: 00007f08f041b780 R14: 00007f08f0417600 R15: 00007f08f0416a00
>>   </TASK>
>> Modules linked in: hwpoison_inject
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:unpoison_memory+0x2f3/0x590
>> RSP: 0018:ffffa57fc8787d60 EFLAGS: 00000246
>> RAX: 0000000000000037 RBX: 0000000000000009 RCX: ffff9be25fcdc9c8
>> RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff9be25fcdc9c0
>> RBP: 0000000000300000 R08: ffffffffb4956f88 R09: 0000000000009ffb
>> R10: 0000000000000284 R11: ffffffffb4926fa0 R12: ffffe6b00c000000
>> R13: ffff9bdb453dfd00 R14: 0000000000000000 R15: fffffffffffffffe
>> FS:  00007f08f04e4740(0000) GS:ffff9be25fcc0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000564787a30410 CR3: 000000010d4e2000 CR4: 00000000000006f0
>> Kernel panic - not syncing: Fatal exception
>> Kernel Offset: 0x31c00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>> ---[ end Kernel panic - not syncing: Fatal exception ]---
>>
>> The root cause is that unpoison_memory() tries to check the PG_HWPoison
>> flags of an uninitialized page. So VM_BUG_ON_PAGE(PagePoisoned(page)) is
>> triggered. This can be reproduced by below steps:
>> 1.Offline memory block:
>>   echo offline > /sys/devices/system/memory/memory12/state
>> 2.Get offlined memory pfn:
>>   page-types -b n -rlN
>> 3.Write pfn to unpoison-pfn
>>   echo <pfn> > /sys/kernel/debug/hwpoison/unpoison-pfn
>>
>> This scene can be identified by pfn_to_online_page() returning NULL.
>> And ZONE_DEVICE pages are never expected, so we can simply fail if
>> pfn_to_online_page() == NULL to fix the bug.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> Similar to
> 
> commit 96c804a6ae8c59a9092b3d5dd581198472063184
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Oct 18 20:19:23 2019 -0700
> 
>     mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()
>         We should check for pfn_to_online_page() to not access uninitialized
>     memmaps.  Reshuffle the code so we don't have to duplicate the error
>     message.
>         Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
>     Signed-off-by: David Hildenbrand <david@redhat.com>
>     Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")      [visible after d0dc12e86b319]
>     Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     Cc: Michal Hocko <mhocko@kernel.org>
>     Cc: <stable@vger.kernel.org>    [4.13+]
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> We should likely just use the exact same Fixes:
> 
> Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")      [visible after d0dc12e86b319]
> 

Thanks for your information. Will add it in next version.

> 
> Not sure about CCing stable. This is a pure debugging feature (depends on DEBUG_KERNEL),
> and someone really has to trigger it manually to provoke this. So I would not CC stable.
> 
>> ---
>> v2:
>>    Use pfn_to_online_page per David. Thanks.
>> v3:
>>    Simply fail if pfn_to_online_page() == NULL per David. Thanks.
>> ---
>>   mm/memory-failure.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index c15ffee7d32b..212620308028 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2572,7 +2572,9 @@ int unpoison_memory(unsigned long pfn)
>>       if (!pfn_valid(pfn))
>>           return -ENXIO;
>>   -    p = pfn_to_page(pfn);
>> +    p = pfn_to_online_page(pfn);
>> +    if (!p)
>> +        return -EIO;
> 
> I think we can just drop the pfn_valid() check now. pfn_to_online_page() implies a pfn_valid() check.
> 

Will do.

Thanks.
.

