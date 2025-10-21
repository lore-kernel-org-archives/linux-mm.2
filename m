Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0175ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 14:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0C58E0017; Tue, 21 Oct 2025 10:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578BC8E0002; Tue, 21 Oct 2025 10:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5728E0017; Tue, 21 Oct 2025 10:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8198E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:00:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE4E748439
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:00:51 +0000 (UTC)
X-FDA: 84022282302.06.349E49E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id C08CD180012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:00:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N2wRm8Yf;
	spf=pass (imf06.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761055249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nZFcTjd7RKIj1S03JiY9y5f0peW613Ihxf8XSZrzbU=;
	b=ecn9XX1LLZKZ936spOn/iiHbyLG6TGX1oDXNPsgfSM+C/YVWyy0a+dSKrgWWLD0M1rxBl/
	Wu6WGbKmf/KsbrQI4qnO6gqe8zdAvSDcMdSqP20n6isf+Lbsg3nNnn70GvcVL6lnIFz0KX
	H2j2u2P3eL/KxggOaeh9qX3juxkmbJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761055249; a=rsa-sha256;
	cv=none;
	b=BrP/5EutcKjoPaxOOvoK8dcVfRszr26tMwUTKO+nEjRzwyY5HTFaXQjTmp1iWtLH7TmNpE
	xS68//YvHu4wRoq7Yj/mEPWofd+cUtm1S767Ex7mhRg3GUX9qH/X+AoYnChxU1feWD87R7
	OWe7PfDFpyuMeOuui6Elt1TxhUIELWk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N2wRm8Yf;
	spf=pass (imf06.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=4nZFcTjd7RKIj1S03JiY9y5f0peW613Ihxf8XSZrzbU=;
	b=N2wRm8YftuBOdPpfW4sjGGEeCJplxM1h+32RHJb02QWAJvQ/hC4Dq/Vao19vFX
	xZFcNEgBivkwKdg1fe+RbxcbxIvEFZyG0RY++hOpMCV45pk9/W69Rg0X13uSHaNB
	wo4RFJFsEGPDB//oe9IwY/ED26V3ZYZ4Sp79QkqFVKBR0=
Received: from [IPV6:240e:46c:1400:1724:2929:d8e0:886d:7a3a] (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDHTvb_kfdoKgo2Bw--.44574S2;
	Tue, 21 Oct 2025 22:00:33 +0800 (CST)
Message-ID: <122ef241-787d-4e8c-82cf-01ff318293a6@163.com>
Date: Tue, 21 Oct 2025 22:00:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] mm/ksm: recover from memory failure on KSM page by
 migrating to healthy duplicate
To: David Hildenbrand <david@redhat.com>, linmiaohe@huawei.com,
 lance.yang@linux.dev
Cc: markus.elfring@web.de, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, qiuxu.zhuo@intel.com,
 xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016101813.484565-1-xialonglong2025@163.com>
 <7e533422-1707-4fea-9350-0e832cf24a83@redhat.com>
From: Long long Xia <xialonglong2025@163.com>
In-Reply-To: <7e533422-1707-4fea-9350-0e832cf24a83@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHTvb_kfdoKgo2Bw--.44574S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw1fXrW7XF1xtw4UGr45Jrb_yoWftrWDpF
	WxJF4vkr48XFyxW3WIgwn7uryaq34DCw4UKwnagw10kw4Fg34qyr18Jw4rWF47Zr4Fka1x
	JaykXr17Ka1YvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jsR6rUUUUU=
X-Originating-IP: [240e:46c:1400:1724:2929:d8e0:886d:7a3a]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbBgAnt+Gj3hgOvXQAAs0
X-Rspamd-Server: rspam05
X-Stat-Signature: o37wa7tgd7e18ydargxu8rtd4eyko6yj
X-Rspam-User: 
X-Rspamd-Queue-Id: C08CD180012
X-HE-Tag: 1761055248-40029
X-HE-Meta: U2FsdGVkX1/JFzO2k/Zsx945Phd2ZLziYtceVvLR4HQd0BP8dR2B0rx0flQiREdK4ToObG8Bf0s2O2ojmNu4xAl6MgxDD0Rtgk+C9ycAibIZ6MEa1cURzhDu7CHzwMPu6zsZRG4340eBnx4ZQA+TxJPDFJv/dDHqDOjV7wqs6FoklUbiKS8PwmvnmPQsGPzowty/6UsnzyKFzRHYq86fiCK0PbAPFoq9QpZldyzIqdJGL5dld2xN3oTWX2I0GuLEGt4l8vY2pQzi5phpKHDBc+rKcU9gkKHAaESaANnjGo/6QywmHH55RK7PIn+9330N7JfzUUAjfe6MEIczA7dsVpUdQPHSzQYqz8X15c8BrgKNTESXppLlYMmIUTTKxAgfA/Liz/RJ2KniqPcE3A/E+FnkZuFA/PJAa/fv6QvuuqRyvn/fuRLsz+yrLiFWYiZ4KycYvwDq0Y5+ggroYGYQFQyEXa4Nbh9l/QvC9LWoPAuh7oYHYtNwkLe9p7JhqbJUX/vqA4bU8E8BM8vlyJzIEMvYZcjmEOiC5azaaL8qgD4FGA7YQYO94oVcq8j5c8ODTOX2lsL7sEegvlXsfnch2rh2bhiqVlT+tmNjFvzzjT4kDfjkSnL6PnrykVA4vvJ+HT/D2fGY49TOeTSiMjdn2rVGE3aTxqfzFZwu1UZrCBmCU+0DhUu/zKnStqM7MhmbLs1pxIUn9BSErxTCu5Szx45iEDdDeYxkRjqO0B5/0ZpqRdWjMb9eWH8Js1GzFNuk266OS7hy87BP4CPAqfEE0Qj6oa9XkpyP2PcWKToFiHWQ/T7jv4tLywxkQ0ZeZdU6qDPF5QRa+WZPC2SI2kH9ZcELuHZbephYEqckp+Xb+mTckSUF/pLdzr05MP/fgk0SQg02xPYuQTqTiT1aOe9UNy0LLzgcDO1UyWnUVoVlzJKc3CiG9L+cS261IT69lZ13jPkk0/fgsRNe1KNen4/
 rCBl/2Qy
 3ZXI47zwb2JRt4sejeuDj7sQ1fF8VavNcGqHleLfBldveb3niB5B8leys7ai8kVPpwW0mIQL1ipyD0SUEoY+3vXAygTavgRQLWAjN6tUqgUIF+IavLyPwoyiP961fuNjYCFOI5EqPd4Djeo98I3JhNvRpQZAiaoQNaKbvpux5F/6dNDkfqJKlfpZ7LKqisbvKnqziNhSjOk/pneUhG5BuTnDg04keHq/Oi81AAy6UKeZ45YOTWrpls2NKUlB1u31igm/X4YKXbkQZopyMXYXQuXfaiCJPtYgiyhJ6oMwrJYMCC42xHQaycvd/LD8RfITgugekRzi+SOL/GqZvhuI+zSXkUNCNyXz7S7PcyyqYlX2Xmyb+fFyqK0KPWhcngHgiqI0ChxFW/UB5DEvSWr5BaVSoYLpuxlz+mmE9BwEQJNpY1Ud2XgC2S67ahc3qMq5M0Z8+sn8dGd0cRlnAkcSMQSeYqZbMGX7iDqDk6jMZBE1s9z1Z0EG8If7lD8NjcBT5RtmSF5WxM/Bk+lunEJlh3/nLCZXp1hi4Njg4YtoO/ak/7OcVSLhQ7UDvVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the reply.

I do some simple tests.
I hope these findings are helpful for the community's review.

1.Test VM
Configuration
Hardware: x86_64 QEMU VM, 1 vCPU, 256MB RAM per guest
Kernel: 6.6.89

Testcase1: Single VM and enable KSM

- VM Memory Usage:
   * RSS Total  = 275028 KB (268 MB)
   * RSS Anon   = 253656 KB (247 MB)
   * RSS File   = 21372 KB (20 MB)
   * RSS Shmem  = 0 KB (0 MB)

a.Traverse the stable tree
b. pages on the chain
2 chains detected
Chain #1: 51 duplicates, 12,956 pages (~51 MB)
Chain #2: 15 duplicates, 3,822 pages (~15 MB)
Average: 8,389 pages per chain
Sum: 16778 pages (64.6% of ksm_pages_sharing + ksm_pages_shared)
c. pages on the chain
Non-chain pages: 9,209 pages
d.chain_count = 2, not_chain_count = 4200
e.
/sys/kernel/mm/ksm/ksm_pages_sharing = 21721
/sys/kernel/mm/ksm/ksm_pages_shared = 4266
/sys/kernel/mm/ksm/ksm_pages_unshared = 38098


Testcase2: 10 VMs and enable KSM
a.Traverse the stable tree
b.Pages on the chain
8 chains detected
Chain #1: 458 duplicates, 117,012 pages (~457 MB)
Chain #2: 150 duplicates, 38,231 pages (~149 MB)
Chain #3: 10 duplicates, 2,320 pages (~9 MB)
Chain #4: 8 duplicates, 1,814 pages (~7 MB)
Chain #5-8: 4, 3, 3, 2 duplicates (920, 720, 600, 260 pages)
Average: 20,235 pages per chain
Sum: 161877 pages (44.5% of ksm_pages_sharing + ksm_pages_shared)
c.Pages on the chain
Non-chain pages: 201,486
d.chain_count = 8, not_chain_count = 15936
e.
/sys/kernel/mm/ksm/ksm_pages_sharing = 346789
/sys/kernel/mm/ksm/ksm_pages_shared = 16574
/sys/kernel/mm/ksm/ksm_pages_unshared = 264918


2.Test firefox browser
​I open 10 Firefox browser windows, perform random searches, and then 
enable KSM

a.page_not_chain = 4043
b.chain_pages = 936 (18.8% of ksm_pages_sharing + ksm_pages_shared)
c.chain_count = 2, not_chain_count = 424
d.
/sys/kernel/mm/ksm/ksm_pages_sharing = 4554
/sys/kernel/mm/ksm/ksm_pages_shared = 425
/sys/kernel/mm/ksm/ksm_pages_unshared = 18461


Surprisingly, although chains are few in number, they contribute
significantly to the overall savings. In the 10-VM scenario, only 8 chains
produce 161,877 pages (44.5% of total), while thousands of non-chain groups
contribute the remaining 55.5%.

I would appreciate any feedback or suggestions.

Best regards,
Longlong Xia

在 2025/10/16 18:46, David Hildenbrand 写道:
> On 16.10.25 12:18, Longlong Xia wrote:
>> When a hardware memory error occurs on a KSM page, the current
>> behavior is to kill all processes mapping that page. This can
>> be overly aggressive when KSM has multiple duplicate pages in
>> a chain where other duplicates are still healthy.
>>
>> This patch introduces a recovery mechanism that attempts to
>> migrate mappings from the failing KSM page to a newly
>> allocated KSM page or another healthy duplicate already
>> present in the same chain, before falling back to the
>> process-killing procedure.
>>
>> The recovery process works as follows:
>> 1. Identify if the failing KSM page belongs to a stable node chain.
>> 2. Locate a healthy duplicate KSM page within the same chain.
>> 3. For each process mapping the failing page:
>>     a. Attempt to allocate a new KSM page copy from healthy duplicate
>>        KSM page. If successful, migrate the mapping to this new KSM 
>> page.
>>     b. If allocation fails, migrate the mapping to the existing healthy
>>        duplicate KSM page.
>> 4. If all migrations succeed, remove the failing KSM page from the 
>> chain.
>> 5. Only if recovery fails (e.g., no healthy duplicate found or migration
>>     error) does the kernel fall back to killing the affected processes.
>>
>> The original idea came from Naoya Horiguchi.
>> https://lore.kernel.org/all/20230331054243.GB1435482@hori.linux.bs1.fc.nec.co.jp/ 
>>
>>
>> I test it with einj in physical machine x86_64 CPU Intel(R) Xeon(R) 
>> Gold 6430.
>>
>> test shell script
>> modprobe einj 2>/dev/null
>> echo 0x10 > /sys/kernel/debug/apei/einj/error_type
>> echo $ADDRESS > /sys/kernel/debug/apei/einj/param1
>> echo 0xfffffffffffff000 > /sys/kernel/debug/apei/einj/param2
>> echo 1 > /sys/kernel/debug/apei/einj/error_inject
>>
>> FIRST WAY: allocate a new KSM page copy from healthy duplicate
>> 1. alloc 1024 page with same content and enable KSM to merge
>> after merge (same phy_addr only print once)
>> virtual addr = 0x71582be00000  phy_addr =0x124802000
>> virtual addr = 0x71582bf2c000  phy_addr =0x124902000
>> virtual addr = 0x71582c026000  phy_addr =0x125402000
>> virtual addr = 0x71582c120000  phy_addr =0x125502000
>>
>>
>> 2. echo 0x124802000 > /sys/kernel/debug/apei/einj/param1
>> virtual addr = 0x71582be00000  phy_addr =0x1363b1000 (new allocated)
>> virtual addr = 0x71582bf2c000  phy_addr =0x124902000
>> virtual addr = 0x71582c026000  phy_addr =0x125402000
>> virtual addr = 0x71582c120000  phy_addr =0x125502000
>>
>>
>> 3. echo 0x124902000 > /sys/kernel/debug/apei/einj/param1
>> virtual addr = 0x71582be00000  phy_addr =0x1363b1000
>> virtual addr = 0x71582bf2c000  phy_addr =0x13099a000 (new allocated)
>> virtual addr = 0x71582c026000  phy_addr =0x125402000
>> virtual addr = 0x71582c120000  phy_addr =0x125502000
>>
>> kernel-log:
>> mce: [Hardware Error]: Machine check events logged
>> ksm: recovery successful, no need to kill processes
>> Memory failure: 0x124802: recovery action for dirty LRU page: Recovered
>> Memory failure: 0x124802: recovery action for already poisoned page: 
>> Failed
>> ksm: recovery successful, no need to kill processes
>> Memory failure: 0x124902: recovery action for dirty LRU page: Recovered
>> Memory failure: 0x124902: recovery action for already poisoned page: 
>> Failed
>>
>>
>> SECOND WAY: Migrate the mapping to the existing healthy duplicate KSM 
>> page
>> 1. alloc 1024 page with same content and enable KSM to merge
>> after merge (same phy_addr only print once)
>> virtual addr = 0x79a172000000  phy_addr =0x141802000
>> virtual addr = 0x79a17212c000  phy_addr =0x141902000
>> virtual addr = 0x79a172226000  phy_addr =0x13cc02000
>> virtual addr = 0x79a172320000  phy_addr =0x13cd02000
>>
>> 2 echo 0x141802000 > /sys/kernel/debug/apei/einj/param1
>> a.virtual addr = 0x79a172000000  phy_addr =0x13cd02000
>> b.virtual addr = 0x79a17212c000  phy_addr =0x141902000
>> c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000
>> d.virtual addr = 0x79a172320000  phy_addr =0x13cd02000 (share with a)
>>
>> 3.echo 0x141902000 > /sys/kernel/debug/apei/einj/param1
>> a.virtual addr = 0x79a172000000  phy_addr =0x13cd02000
>> b.virtual addr = 0x79a172032000  phy_addr =0x13cd02000 (share with a)
>> c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000
>> d.virtual addr = 0x79a172320000  phy_addr =0x13cd02000 (share with a)
>>
>> 4. echo 0x13cd02000 > /sys/kernel/debug/apei/einj/param1
>> a.virtual addr = 0x79a172000000  phy_addr =0x13cc02000
>> b.virtual addr = 0x79a172032000  phy_addr =0x13cc02000 (share with a)
>> c.virtual addr = 0x79a172226000  phy_addr =0x13cc02000 (share with a)
>> d.virtual addr = 0x79a172320000  phy_addr =0x13cc02000 (share with a)
>>
>> 5. echo 0x13cc02000 > /sys/kernel/debug/apei/einj/param1
>> Bus error (core dumped)
>>
>> kernel-log:
>> mce: [Hardware Error]: Machine check events logged
>> ksm: recovery successful, no need to kill processes
>> Memory failure: 0x141802: recovery action for dirty LRU page: Recovered
>> Memory failure: 0x141802: recovery action for already poisoned page: 
>> Failed
>> ksm: recovery successful, no need to kill processes
>> Memory failure: 0x141902: recovery action for dirty LRU page: Recovered
>> Memory failure: 0x141902: recovery action for already poisoned page: 
>> Failed
>> ksm: recovery successful, no need to kill processes
>> Memory failure: 0x13cd02: recovery action for dirty LRU page: Recovered
>> Memory failure: 0x13cd02: recovery action for already poisoned page: 
>> Failed
>> Memory failure: 0x13cc02: recovery action for dirty LRU page: Recovered
>> Memory failure: 0x13cc02: recovery action for already poisoned page: 
>> Failed
>> MCE: Killing ksm_addr:5221 due to hardware memory corruption fault at 
>> 79a172000000
>>
>> ZERO PAGE TEST:
>> when I test in physical machine x86_64 CPU Intel(R) Xeon(R) Gold 6430
>> [shell]# ./einj.sh 0x193f908000
>> ./einj.sh: line 25: echo: write error: Address already in use
>>
>> when I test in qemu-x86_64.
>> Injecting memory failure at pfn 0x3a9d0c
>> Memory failure: 0x3a9d0c: unhandlable page.
>> Memory failure: 0x3a9d0c: recovery action for get hwpoison page: Ignored
>>
>> It seems return early before enter this patch's functions.
>>
>> Thanks for review and comments!
>>
>> Changes in v2:
>>
>> - Implemented a two-tier recovery strategy: preferring newly allocated
>>    pages over existing duplicates to avoid concentrating mappings on a
>>    single page suggested by David Hildenbrand
>
> I also asked how relevant this is in practice [1]
>
> "
> But how realistic do we consider that in practice? We need quite a bunch
> of processes to dedup the same page to end up getting duplicates in the
> chain IIRC.
>
> So isn't this rather an improvement only for less likely scenarios in
> practice?
> "
>
> In particular for your test "alloc 1024 page with same content".
>
> It certainly adds complexity, so we should clarify if this is really 
> worth it.
>
> [1] 
> https://lore.kernel.org/all/8c4d8ebe-885e-40f0-a10e-7290067c7b96@redhat.com/
>


