Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0913CDC19C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AAB6B0088; Tue,  6 Jan 2026 08:28:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2CE6B009B; Tue,  6 Jan 2026 08:28:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528D36B009D; Tue,  6 Jan 2026 08:28:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CED26B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:28:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2CB88C042
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:28:04 +0000 (UTC)
X-FDA: 84301617288.23.1DB260A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6E1014000F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:27:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767706083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KQzPpkIuj0ak54TrSIWyLS0jmADk18wf4pTreALtfkQ=;
	b=PwY3TT1F0+ESn8a+IKUwvHf3jmpRHrtnV73wV7WoD7I6KaDoO8MUVcC3bhY0SxsZCYF2N1
	iV4GPrYVRaFDoeGPeGyHMjGgt0gF0b9j1H+7yzLbGs1chScynlIjGv5nNt+qaIjbPjsfUP
	6yWPgZ1s9m8JzTzOuXnQ9un8JZbzN2Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767706083; a=rsa-sha256;
	cv=none;
	b=6wwr2ydVpd+KPw5yIXqq99d8Xt69xIXD4HUo7icLnOZ4lgNJMC3+6CZ8RBmxTSj9vFAQJt
	NaEGgmrqTkY+xtisxIBCrP+UXEGjG5CVn9RxYtnEqGmLQjNQQi/sjvKfEtUSkoet7xglcp
	4wlcvpMiS3nxrt3duNIpTjOgci0ME7k=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlsQF6pq4zYQv4T
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:26:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8182A40574
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:27:46 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAHtfXPDV1pXzxeCw--.1359S2;
	Tue, 06 Jan 2026 21:27:44 +0800 (CST)
Message-ID: <c8c2d782-e67d-4f4f-917d-6cb198fe1175@huaweicloud.com>
Date: Tue, 6 Jan 2026 21:27:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC -next] memcg: Optimize creation performance when LRU_GEN is
 enabled
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251119083722.1365680-1-chenridong@huaweicloud.com>
 <20251126171513.GC135004@cmpxchg.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251126171513.GC135004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHtfXPDV1pXzxeCw--.1359S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CryDXr48tF1xKw1rWF45Wrg_yoW8Ary8pF
	Z8XayDKa18tr9xKrs7tr9rWayFyws3Gr1Yyr1DKrnrZw43Aw12kFy7CF1UW395KF4ku3y2
	qFW5Xa4rtw4UCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6E1014000F
X-Stat-Signature: r56fp7n64y8suettmaudoc5exegb1kpc
X-HE-Tag: 1767706079-91918
X-HE-Meta: U2FsdGVkX1+4kVx/hxsl+mLsaWkB/YwvZ04IBRIyCYCtRlZUdJqzzinR73mZ1nz8eezG+B3x31D1lqVZfBvPV91BdpnOC0CheOL9H53ndJfOh8PtqVMT/sP842WdBHwF2tGDgYGttfCLBSimG8vqmdaxe5w78L8A9x1rTmkxBaM5au+qQh75eZqy6lpTaE9/CSFR3lmtJeb0a+cRoQl+qtQjpL+r2qlUg4E1sMYeLitilh997IPTMR+zEMBLmM0KJYih1bJRLSC5U3xLSJ7JET54x6M/8KKxuXe+mEmR7+9zgt/g2HCkMlz4EA6AtvkSZIpJdw3EnRLdv46m3ZAa+/kF6yQP/8K+MSubsW+0q1Cz/ubGzCQoKQayY9+Id+/iK7Xh3ZW+rtWi66r/d9J4XIKv9TSpkbhA2A0+s9dvHjBC5W40jcuDAT2kclE9dgtNNVH+tJlUCSFcKK7gUXMY6sHvPJHJ4bPu84lUbdt6pfp3rXB96hXrC8z6PCDu0Vy3/MlnlnX6lxu1B4U/Cyr5Se6T4Tes9Jo7M/JHHn5YW90K705XLJAOXtKPNcGlT3BKO9TLDIBbAvGZ+Wg0I+GVNaCWa90GbzmwCesMq9ku+KHeNehK+5HYl92c9LQIteEkdEyTp5W+xZ9guo7Y0H+F7rD+UqcAJ9NK9KC4TDXu6I/9EZ6bNyxTj9cgedCW9U0tVN14ZQnE42C9DvCP1dlxJVKXgztoo8GD+EYhERDmOkupVbwuMJx4A52N/330Ns78nwduOut3FYY41QBHx5zoPakNYoLnk21L9PiY0CxU0nu8fSmnXqBGYNvZ7LSGxdGS/g6jm4n4MAwjqm6FFIObmmhQAt6Nx+cvYSB1KIlcFdG22hLvcOqhmnLaJKio/2IfrOSV/1Qfx05EVO0DHlOnv4HkMicuAbgfyG4GJsCKbNVVDJ09iyi/EJ6STQFrO1YqrAjcqyQCBo3tCRWAjcu
 Y2KYhOsw
 Zq7/fVmnGEOvKyYvX2kApjSU++B/myhYj8qjItTY16ATBiJjRFgxYetrbcJrQD//8/aXdM5Td/A5zzmDdlJHhF7su8DvyhaXs5wpgDh+NDgGL8N55kbVFuzQOzxIG10+FR+swiJQKybNuoNXhUMFSsuqGv0+g5mZ3irOUhZfPI66OOUMa950KP24xG+LouSvzdRemGR7e6zVqzfkd0j7HjWsk3KyzyMZ2UZTMgrKXC1II8ec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/27 1:15, Johannes Weiner wrote:
> On Wed, Nov 19, 2025 at 08:37:22AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
>> when creating a large number of memory cgroups (memcgs):
>>
>> 	# time mkdir testcg_{1..10000}
>>
>> 	real	0m7.167s
>> 	user	0m0.037s
>> 	sys	0m6.773s
>>
>> 	# time mkdir testcg_{1..20000}
>>
>> 	real	0m27.158s
>> 	user	0m0.079s
>> 	sys	0m26.270s
>>
>> In contrast, with LRU_GEN=n, creation of the same number of memcgs
>> performs better:
>>
>> 	# time mkdir testcg_{1..10000}
>>
>> 	real	0m3.386s
>> 	user	0m0.044s
>> 	sys	0m3.009s
>>
>> 	# time mkdir testcg_{1..20000}
>>
>> 	real	0m6.876s
>> 	user	0m0.075s
>> 	sys	0m6.121s
>>
>> The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
>> which traverses the entire list to find the tail. This traversal scales
>> with the number of memcgs, even when LRU_GEN is runtime-disabled.
> 
> Can you please look into removing the memcg LRU instead?
> 
> Use mem_cgroup_iter() with a reclaim cookie in shrink_many(), like we
> do in shrink_node_memcgs().
> 
> The memcg LRU is complicated, and it only works for global reclaim; if
> you have a subtree with a memory.max at the top, it'll go through
> shrink_node_memcgs() already anyway.

Hi, all,

I previously attempted to remove the memcg LRU [1], but this change introduced a regression that
increased kswapd overhead significantly.

Now circling back to this issue: does anyone have suggestions on how to address this problem
effectively?

[1] https://lore.kernel.org/cgroups/0b8ea26f-71f7-4f6d-b0d6-7d42e087a7ed@huaweicloud.com/T/#t

-- 
Best regards,
Ridong


