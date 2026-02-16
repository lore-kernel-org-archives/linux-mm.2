Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78684E81A2C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A996B0005; Mon, 16 Feb 2026 09:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8526B0088; Mon, 16 Feb 2026 09:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA096B0089; Mon, 16 Feb 2026 09:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6784A6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:40:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BCEA8D2C6
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:40:29 +0000 (UTC)
X-FDA: 84450580578.04.29FDC62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B2B2A000A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:40:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPccsK1E;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771252827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6ncEFY9DRthK+EHiiH9u6fSKJT+Eb2hiMnPzItZu18=;
	b=jrjSYNhb/YbPGU0NtX2tK4HycbzOg+c8EoIIhCKL06BpDdG9nqEJ3FxaXFZXMBQIFNmt/s
	8QejUwXUjP8FK58kRiSusalh34a/gMeQqfxUCv7rLo/bEtcFxGH6ymSv/IAJaX/XzxpbD6
	QB4eHDUv1pkWDDRGzl3tTH63WFTSe6M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPccsK1E;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771252827; a=rsa-sha256;
	cv=none;
	b=Gt7jvQdpGwZtgdjFTDOtLzHUJhlQCvBuTewqeharHAURC1jbHncsMBFNpCzoM7nYG2IBxC
	H5YKKP051oCjnx2r01oiuu7v2uPCnB9MG+MSCU3xpjje8bHdJHodDt+71fEMPcPzXTsVeN
	9SSXWSlfpWhIM93+8xRMgFR90OJMic8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98F1E600C4;
	Mon, 16 Feb 2026 14:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21217C19423;
	Mon, 16 Feb 2026 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771252826;
	bh=0dFHtqfSyLUzNUO7us0gUe1m4eQDoOg5I6BkTl63JDo=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=NPccsK1EccekekdnMOc7lR5xjGsndNitrLnQZZ+4fL+2oar9yaJ6Lco+rrykkxm7I
	 KvDHAKer8QEYodV6S7JG4PJO+8oJbAXNvgV06FfWDOrjFqZXOYdzRCoMDr1PTyDPDz
	 CfO/RpHK8i2qH+p3WGRQJLcUVzNnNxGFhR7o0gPKDLpArBKi8k9iexqboMba1HOVsd
	 cYkvsmgEqw3hKtK80u9Ce32wbz0pKa8NWAhjDXnpns73AIL67lsArpVZ9Kz4h+Z2jL
	 MDMpX2NX86KLLfegQpMMN2cko6OTcl1ZcQnjIfg6c12kcY0jG76fYHCGUSeWOPgq0l
	 4082RPMfgnBkQ==
Message-ID: <5e95c945-dbd4-4714-afb0-9546b08ff561@kernel.org>
Date: Mon, 16 Feb 2026 15:40:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] kernel BUG in __khugepaged_enter
To: syzbot <syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, ziy@nvidia.com
References: <6990a57d.050a0220.2757fb.0028.GAE@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <6990a57d.050a0220.2757fb.0028.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x1qwxu9yqq4yj69pgr7k6356ucroki61
X-Rspamd-Queue-Id: 5B2B2A000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771252827-345445
X-HE-Meta: U2FsdGVkX1+XP0j1VJ9UGpL4WmPT0ymNmu/DFtVrc7OMslA3437OnNuseo/daFa1J0vR57ZQvMNTDMVtF2GsyF8ZthMxGnaMMmp3CsX+pXyRAo6vsyq+7K20q+CMgCFqrr6CnOnmJu8QuFPfdkL1XA3stOq88ocPCk+KsRlIM1wUDZIyn/fgp/nm+jgS0bL+tW7uKgKdGx7KdExopxrzsaA2eyIgkZemzmzWx3dIPCtLsdYRFiyMWiMFTCbOK6+3I53oDDF6Lj82Q2IfiLISwkfdhPKxNUw97T40XrA6azluYB6h27zUR8tdR/Xf4v0rK8OxrBhQ0oH6zsBd0geORQmMCG4Urf1GfDn0P5siY6VaVEp9xux8JiLV01BBflHUiw/JaDVK8Sw4RGAYDJrwyaiI59DNXlw6sxVkk3+SAkvszZebY1ldCTW//we7w8NR/8M4peJz4jSARh6LcgVEnIhcfL1aITlhEdWfGeT+NumwIGZpvpiu9NYOJbRKN5E72oiqTglOHxrwVTVKxUgmd3T7MXMs6xLJVncu06F1HZSg7/ndM1ju/QpQjfCWIln9Jex5I63BNk7C2WK8EWp/6cakxDCmmyd51kXkA6Knl9zgL7/qDry/Pk3a1AmTmcF7yyFiYDWRSgeq33rfjobeB1X8HVtp3UdNVfNM8Tkvtxuakqusjp/Du6922/V9tR78es9BkAKfIkUSwCJcydGfCWUzJFewPCryLiRLcatBWpCOnWhYchU5BGkLDm5owOiRNlPKdosKlM59IYfh2x0ethXm4eHQwDot7dSvQ0tCObSdaHM7t6g831jcdsbjqVxxmhf2/z9CTm2EmTq/RYz+F14s+Z5t8t0w6zqJ2P4ejDRV590v1+AKWhbZIdI7Nx3+hZUaYE5mHQmG98SgkzNkIp5HhzGZ5JGlxqNbGlJkC0wI9JRO3vDVUrxlL1wbu+MgsE+7t8vhejwiAokmP1r
 0nDsJpj9
 15mJd2akAS31FSDaRl2wsuZ4NB+JI3iGD4Grfazw2P8p2aqTC6CmuWrLYRSqqSLFdN8t8kVbfxZUp+g7Euj9QCTsStaN5GSGTXH/h0u4Mo4IrEOnIsTFzLZMFs3DxXUK6RWYElh5CthRHMKQ8omd1PPz6kdZ/lOWyEq9R2KS6tIX2sbp7fU7iGUogYOBmns1fjPwiRUHhLixhoJ4zqioN6y3jxskd5TzWmwB/w3MIMfkLYy7Pz7gHkjbjS7NPctOFjxtlJS5op+Dn/i+H07+/FZe9LmBk7mjnlz/VlfCRbC3hA6wogsgIVPQTHIwSN1055ocF85Pnsd0EHPAYhTUNTn0KTtPwZEntBUuuMqGzzcbE4YGDbJOzUdUeadgh9mR9e3TuVmdZMHsFtVTCREBOYlYNFmr30Rrl8Fww30R7Imjya6BJiNk+csxxnqqU2yYKmRt8jiOy1pGvAtjEsAuWftTsiWeCrwXWY56zGpIVxYFfxW0Vemx2aPYPjfyNz+214JNrsD08oRrigh1gh7Y96cF86Z3NjOEuIlxNBUebUb+3R/EhKyHvMwKXqKcxX29Ni/kdK/dEz+YHCdm/5iV1KyeLSPW71gmcdCNgmlEeBfdGAucDva9sJ+fx+nptOdjqoBDkD+uOfO4NE350YQMhOeLlqWcBxGKjzkwqxR/zv/Kno+0DeqlXQeOVDV+LiahWs1D1/cqi2z/auRhpRXlQCZhpbzzxXtIj21cfBOnu0I1q372DzrlZ/1l9yqI5s6Mmk7186f8TipmKHWcsfdpFtcPbQbfX5xh8ZskmChzhOYLteQNJJG6Iw3Xwh44Sktc8fygsqWJEWGeZnsdAgbb8CbGxJXVY88Kp9VYv7epSa6Vb51R2CbU0Nmem/PWTwJPmvBcYIanBmZwh7ODvnzVYMQraNIIa33Slj3NZejOD3YvVYSbvdm0/1Hp/31cbZhmZ2BbB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 17:40, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1e83ccd5921a sched/mmcid: Don't assume CID is CPU owned on..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1169dae6580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=54ae71b284dd0e13
> dashboard link: https://syzkaller.appspot.com/bug?extid=6b554d491efbe066b701
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ed43f42e3ea1/disk-1e83ccd5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d8af54a32588/vmlinux-1e83ccd5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/34e6a8cc1037/bzImage-1e83ccd5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at mm/khugepaged.c:438!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 16472 Comm: syz.3.2372 Tainted: G     U  W    L XTNJ syzkaller #0 PREEMPT(full)
> Tainted: [U]=USER, [W]=WARN, [L]=SOFTLOCKUP, [X]=AUX, [T]=RANDSTRUCT, [N]=TEST, [J]=FWCTL
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> RIP: 0010:__khugepaged_enter+0x30a/0x380 mm/khugepaged.c:438
> Code: 64 7e 8e e8 a8 dc 66 ff e8 93 e6 8d ff 5b 5d 41 5c 41 5d 41 5e 41 5f e9 04 6c 04 09 e8 7f e6 8d ff 48 89 df e8 17 33 d9 ff 90 <0f> 0b 48 89 ef e8 dc 51 f8 ff e9 3b fd ff ff e8 f2 52 f8 ff e9 e1
> RSP: 0018:ffffc9000e98fba8 EFLAGS: 00010292
> RAX: 000000000000031f RBX: ffff888079b24980 RCX: 0000000000000000
> RDX: 000000000000031f RSI: ffffffff81e5b2c9 RDI: fffff52001d31f1c
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000000000001 R12: 0000000008100177
> R13: ffff88804adf9510 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f06093436c0(0000) GS:ffff8881245b1000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff341d3f52 CR3: 00000000319b0000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   khugepaged_enter_vma mm/khugepaged.c:467 [inline]
>   khugepaged_enter_vma+0x137/0x2c0 mm/khugepaged.c:461
>   do_huge_pmd_anonymous_page+0x1c8/0x1c00 mm/huge_memory.c:1469
>   create_huge_pmd mm/memory.c:6102 [inline]
>   __handle_mm_fault+0x1e96/0x2b50 mm/memory.c:6376
>   handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
>   do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
>   handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>   exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618

This is the VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm), which checks

	atomic_read(&mm->mm_users) == 0;

So we have mm->mm_users == 0 while processing a page fault. Weird.

-- 
Cheers,

David

