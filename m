Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5BAC61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190FB6B0095; Thu,  3 Sep 2026 22:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167E86B0096; Thu,  3 Sep 2026 22:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5CC6B0098; Thu,  3 Sep 2026 22:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D80606B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:47:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 555DB406E5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:47:24 +0000 (UTC)
X-FDA: 85174543608.12.2C59EBC
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFDF51C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:47:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="VIn8YP7/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788490042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0mchN2Yz1nzmvNj/LwOzWIwDRSSMt3lvAixYcXrXcA=;
	b=L/2eZSMOiXIz0ti6e8QWOkBHENhhWMDBwfSX98V8osXClXd7nMAxLRCEq7F7wMDIIhetsu
	42sbbaLj4fyxnyFCbgfAgQdmXFuG8QzJbnWKRDOLwCCzbBy58H1Bxh8uhMfdpjxnE+J/i2
	8aoTUovq5VnJEkCz/lDr2ssdXrAb2SQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788490042;
	b=thU0lvL4QrcJDFV7pozADCsphtZX60zvCkxj5epJRtEtS0QBWDyaDJE/l/TVnepY3lBRTw
	i09924XlvEl8lUD3i/3EK1P9QaQ1U4h1L6L6tLkypXqQYmqV9RzNRb7/36lRtxXb50yPai
	RH3ejXzcO4wNZdl0fu7lrWJIaHklbO8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="VIn8YP7/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788490038; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D0mchN2Yz1nzmvNj/LwOzWIwDRSSMt3lvAixYcXrXcA=;
	b=VIn8YP7/NODZ6uFxjs4E/vA6GEvZdYxaLHxmiOAdKuECsTd2DT9OSG+mgLrtPkCVlUDzl+5aIKKwUHXKlcMNFd+FUtT3JBKgXrbJiBiGyRCBx/soY1xD6PY93fWq3CG6J6ELkkVMktL14mwP05xcq8ysqyOk+t9KjvXZd2ua6NA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XAHLQyT_1788490036;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAHLQyT_1788490036 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 10:47:17 +0800
Message-ID: <129ecc53-f96e-4a5d-a79c-c05293d815d3@linux.alibaba.com>
Date: Fri, 4 Sep 2026 10:47:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com,
 linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com,
 yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-7-baohua@kernel.org>
 <c1992315-8e2a-45eb-a042-29f1f1725f76@linux.alibaba.com>
 <CAGsJ_4ybQbbxxyz5EU29cckoQQpm4PrQi3W2Bu3Mb22UCjFBrQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4ybQbbxxyz5EU29cckoQQpm4PrQi3W2Bu3Mb22UCjFBrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DFDF51C0003
X-Stat-Signature: rjqt5nnk3px1t7dmkz9fcojbjj1kyoqp
X-Rspam-User: 
X-HE-Tag: 1788490040-793461
X-HE-Meta: U2FsdGVkX1+CERt586wxUVzl3jhIpwc9ODCuGGh3WrEU8PJSxpwjaivombgzaiYQBgYFbV6LSHzxQuvCIVPyv57UgeFE9qlF04FkVphhc9MaIKtcLYvsOzecGQK77K/+im6ZWb97whVPKrmJBKgBpeT8iN8OjAReJaUEVn5/2X1Wh50kxOnr/SXDUFZIXsjMSRJFm+ou21ChZHD11b593ZPzrsBFbkA0ReHIUs2C1NULlkkrNlWfWcJKdV9bdWXGkBQAwAdiSdJ+7Hd0F495Xh4H1gSEjDWhg3iSfJ3Mg9bPsC2Z7Xolh8gZNvzKlZFKCnC/XyKH99j1DA7xaj7XGXCTx6LZzbJUgXXFOEd8aTtMH9mug6k88bYoTx2OIp2tDo1NxRugEgEVZW9hUtMJ8tQ3fANhq1vnI72MXJAiR1xRiDox2fR16LfP+ghRTru3zb6KlG24k3zNTdXrtxdzRdMGVjEnxsUyuZYrRM7Utl9gQ4HPEtOsM9Me2265GNlMJGaPjnpNqSgVD/0SZJ0IiN27g+X3N+pwLDa17uvAIS9UnQSDPTpFUOEdThCKwltcFkKSEd603xyCjYwfIge2kDUCVvVNBJYJ3iY5IaYuizwC64ZBgk8MipV8BjnLlXCyNKBVxZNJxSP1FGn+FNUgEaiChZIMKWM2eu6dcmmWscO+dhTTgDWMYkLieXCWzaLj2yAkU/jMmOh7uAYTNSb9G6bZ4DCWpbZ0tRz52SSKjiArOca2HW2aIWElCjO8PRf0A0kVj34BMHjv4az9KJbMf0VRr4LLYsLuX1Piwa8H1g2CZjEd+obXhGJc6o+pGROCM5P6xNjQqDkJCvcAcIPUw7h+O/ZlGxX/1bNyV+IKEO2CCLUcZUL6jtbZk4TiOkoY2oP/I6ovxcThFfKw94iSzh+MJTKaoZVzcGGx36+E+KQoIbgK4/CsjtuMxvxcyclNPqNypjyR7KAXAdGH1a3
 xbTcQYyf
 Y0GytuKqo3mmSlgvZlC3by22t0FZVkpPMDtxp/9a4NoVPN8HPG7rNBo+w0tXdcPfmNArDBgEjq0AYUSLq2eAbt8+EilMHEXhFDwbhh1YGTSIVnmKf7e/kgILPJ5VUNBCNtKiJPr2x98LeEXv6SwAZxm0VPrcnZJeZTUrw3p4NDxZdKth138iTJJWSqs82YtyJStcCyBrbxlYzRZ8es7NkuNLLXCnZUbE0sGO8RGPQgXQWJOpR3FCTipk/D5CeQjv68iEggGotz0QBBDwPcz8MuAet3pklu/EYM5ceQxgbqa5m6rkM42fnAWyCiTV25lk6udbRP6LwpWOLaXTpugJZK1t4SnxNaR1Smc7tOC+FUWLp6vKflB7A+elNjDJy6fS547hgYRTj5H95oQ66pgCXscbAsKUCIUpJTIYVLWeGuEGkJ4ofMddCUEjWwCrDOGeeRn3M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 10:28 AM, Barry Song wrote:
> On Fri, Sep 4, 2026 at 9:53 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
>>> For reclamation, it makes sense to reclaim folios from tail to
>>> head, as folios near the head are relatively hot. However, when
>>> moving folios from the oldest generation to the second-oldest
>>> generation, using the tail-to-head order would effectively cause
>>> a cold/hot inversion.
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
>>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>>> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
>>> ---
>>>    mm/vmscan.c | 23 +++++++++++++++++++++--
>>>    1 file changed, 21 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 1907a946840d..76dfa9575852 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_folio(struct folio *folio,
>>>                prefetchw(&prev->flags);
>>>        }
>>>    }
>>> +
>>> +static inline void prefetchw_next_lru_folio(struct folio *folio,
>>> +             struct list_head *base)
>>> +{
>>> +     if (folio->lru.next != base) {
>>> +             struct folio *next;
>>> +
>>> +             next = list_entry(folio->lru.next, struct folio, lru);
>>> +             prefetchw(&next->flags);
>>> +     }
>>> +}
>>
>> You did not mention in the commit message why this prefetch was added.
>> Just curious, does it really help performance?
> 
> Hi Baolin,
> 
> Thanks for your review.
> 
> I had this discussion with Kairui and thought it might be
> useful to keep it here:
> 
> https://lore.kernel.org/linux-mm/CAMgjq7AJnWGGH=FNuV7ynXjbffktsDRgdcyagLUJUwJf1ukaJQ@mail.gmail.com/
> 
> It might be arch-dependent. Some architectures could benefit
> significantly from prefetching, while others might see little to
> no impact.
> 
> for my x86 test, it has very slight improvement:
> 
> ***** no-prefetch:
> 
> agetest:
> ...
> gen 100:    2.421 ms
> gen 101:    2.424 ms
> gen 102:    2.420 ms
> gen 103:    2.413 ms
> 
> Total:   248.418 ms
> Average: 2.460 ms
> 
> agetest:
> ...
> gen 100:    2.393 ms
> gen 101:    2.396 ms
> gen 102:    2.395 ms
> gen 103:    2.392 ms
> 
> Total:   245.627 ms
> Average: 2.432 ms
> 
> agetest:
> ...
> gen 100:    2.433 ms
> gen 101:    2.427 ms
> gen 102:    2.432 ms
> gen 103:    2.450 ms
> 
> Total:   249.186 ms
> Average: 2.467 ms
> 
> **** has-prefetch:
> 
> agetest:
> ....
> gen 100:    2.314 ms
> gen 101:    2.310 ms
> gen 102:    2.321 ms
> gen 103:    2.303 ms
> 
> Total:   237.619 ms
> Average: 2.353 ms
> 
> agetest:
> gen 100:    2.342 ms
> gen 101:    2.343 ms
> gen 102:    2.339 ms
> gen 103:    2.335 ms
> 
> Total:   239.929 ms
> Average: 2.376 ms
> 
> agetest:
> 
> gen 100:    2.344 ms
> gen 101:    2.347 ms
> gen 102:    2.352 ms
> gen 103:    2.348 ms
> 
> Total:   241.188 ms
> Average: 2.388 ms
> 
> Basically, it’s 2.3xx vs. 2.4xx, lower is better.

Could you add this info to the commit message? (IIUC, someone tried to 
remove the prefetch in MM, since they found that prefetch doesn't seem 
to help much on modern CPUs.)

