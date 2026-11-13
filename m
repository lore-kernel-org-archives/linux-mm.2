Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF33606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Y1lF3dl5
Received: by kanga.kvack.org (Postfix)
	id 038C46B05BC; Fri, 13 Nov 2026 00:31:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0107F6B05CB; Fri, 13 Nov 2026 00:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69156B05CF; Fri, 13 Nov 2026 00:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA50E6B05BC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:31:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C58801401A7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:31:51 +0000 (UTC)
X-FDA: 85428974022.28.49BEA4C
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf20.hostedemail.com (Postfix) with ESMTP id 80EE91C0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:31:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Y1lF3dl5;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5ccHDNjOaQuKoYDwy7TH67pGGdmawXvtZ8kWuEfWxQ=;
	b=TDT+qvyqLNXyuDxcLgcWwiS+paKqNjxjsYagiJQwqceJWjtr2OMNcz66u2dHdp10IdxkeA
	+3gydq5yiVh+/aqHlq7+ZM1Lwd5saMCPxMUciX5n/1+/9MjSfbA6is3idgp9saRg+xj199
	5UmjpO0FlGIuXdxbaQCRaik+77IGCio=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Y1lF3dl5;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547910;
	b=5bNEFFXtboKX61vCZShkGyd96jNripnJzxu5gxvxpqTcAKwYsxXQItYhWNjMxRtppKLShG
	4uX4dPywq7EDXGTxXyS0b5+DKxdYY1ehf/eRNksSj+Rc2pwnUGoJRQibEMo4wP7jlkM6cW
	qRzbjPnORkNam6USa2v6RIHo/YxOL0w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794547905; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=q5ccHDNjOaQuKoYDwy7TH67pGGdmawXvtZ8kWuEfWxQ=;
	b=Y1lF3dl5TaiELZi0tiVzujuhI9AVB4lgqX5pHIvRAuZAYOidfrKBMcdMxGjHhq2ryj/msYyWZylmT0csu1e6fJb0PzxnSFN67zGcZNbgDGPqN9fnMYuYsX8UGLvRyhezs7t2HjYcFFOhXyLU4LEiHrUIGM4BOB4HhR8Z4IF8/uo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEe41eT_1794547901;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEe41eT_1794547901 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 13:31:41 +0800
Message-ID: <319d4cc3-93a9-46ad-9d03-ceb22d0f0aa2@linux.alibaba.com>
Date: Fri, 13 Nov 2026 13:31:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, hannes@cmpxchg.org,
 kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, mhocko@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4y82CKoLx=HC8zUpHz+qwT8sNHjqT0bbrfLuCRYrWR1iQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4y82CKoLx=HC8zUpHz+qwT8sNHjqT0bbrfLuCRYrWR1iQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a9jfr5kx99kpq1e3w9a3rzb3fgidbcan
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 80EE91C0005
X-HE-Tag: 1794547908-266780
X-HE-Meta: U2FsdGVkX1/ks6L6pqwxRmrFbpnhYasx34ZhCtas0s6JUTHd9ecbuajKw/VIqTrVoC/zMK0l35hjEjqNHlPyOchF500rBwN6dGqVsvh4rIFDUNMHquwM/jIVxyY4QCih+2icDXNV6R2jP7hpvTEENIi36WCYY7iGQEJm3PKdYRzZRr0SB6+fGP0HADx8ze8Lkg34ORCFhO1dzAeI3T2CZOOl3NGsaLLYQ5pNN+fKItihfSH3u78sEgGNGsEh6lXGWixBExIUx0kXEkPJy4HGYdHXlhyDxAN7/wQVrue2Moosq3PjF4vWdId5aizQpcckJtIOU7Tri+ZXKiL21a3UGKlRH5jDYYbCdBE9zUMazZOBnmKNuq7LeSJvS3FqE10FXSBnmeMrHcTm8aCACJaim2WLqPD+22NDbZZzcTmKet6vBc+SuC3MZDja1IbE35IcB5KPK1MLYyITLn2tFvJ4jzKlU2agK/5/EJ40NwiTznG0De/m+4O0aB9hHDRo31JMJ+d2C/592r28g3DVPJvq3aMHFXepdVBBopLM0JHwviYUQY4j1vfSxe+g9pABmwbQROOu/QYH3c0eY1f/q01F81E3nyEsjLddcBCxHUdNPRKHBr8hLqYLaah3ES6Pt6Fv48DvYENEPje3/lOPv07NJFYKELRy2d1zAX/FIkrxovIHPVCGZTUSONdWEQkRg4JNJdoGw0l2T8Gwy+2hhVjyTMCWB81Y6A2g7wTIMtlJq1aNIHnui5br2PS/8i/ZwmL5a0sHuhCpUYsfYu9fjFScHYtiQXAeYLNOXLGr7X4n6APsxnuylFPsYjE8n9gWbfOPABmSVuOIYrcSno9Kdvm8ky2w4JIt/6y3rvJmsUjNu2E2VES7p3j3GNcEL7iAyNx74mZVQFiK8VrVZDVE/eZWwk/q2DZAvDNwS/dMOyYN5PstNR44BG8SEIAYcRbsPDg/rcFEj+y0AazhsNkccXt
 VhnntC1P
 68ncdypld8HSLzboMj4iSIX0t9pyROqVb5MIAnVpqCDjyW3S6+qGIHf+w2JG3aaVLCwA+IEKzkH3kQPaICEsSGPbn3ixl4iDgy5S4QkcxR0ONx1RYUUAgU3e5gCOgeRFVPWTavxjySAj+HS1fZbKY/OVJeVYAhqK0iDQCtHIQIhgZ7Y1JJULUkUdlENbBTfCQn5vFVcg9hZ0rspzdEdZoxcJaJgV08X29CvgW5DEnhHYIoRxztosmInu4Hk/ptbfK2g8sdrhU5xAjN/Q6Ey+c1C68ousT0znD+NOw80v8cUeeZ245Jqa+QI52EaFt3c5Q1hijbBsHPu0wAcv2ro0icjFOfxQqhufmdb+BdQbhW+i39Ht8rGwNMFRpxE9LJnKob+/Dd1oEzhpgNzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 1:01 PM, Barry Song wrote:
> On Thu, Nov 12, 2026 at 7:13 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Use pte_table_clamped_end() to clamp the range to the PTE table and VMA
>> boundaries when batch-checking young flags, making the code more readable.
>>
>> No functional changes intended.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Based on mm/core.git for-next branch.
>>
>> Note that this was found while reviewing David's series:
>> https://lore.kernel.org/all/c31cc8a0-c098-4784-a843-f13f51914094@linux.alibaba.com/
>> ---
>>   mm/vmscan.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 5495d9be90e8..804d4188e7b4 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4470,7 +4470,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>>          walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
>>
>>          start = max(addr & PMD_MASK, vma->vm_start);
>> -       end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
>> +       end = pte_table_clamped_end(addr, vma->vm_end);
> 
> 
> We don't have pte_table_clamped_end() in Andrew's tree yet;
> it's part of David's patch:
> 
> https://lore.kernel.org/all/20261111-pte_table_clamped_end-v1-1-2dbe339c487a@kernel.org/
> 
> So we're not going through Andrew's tree for this patch, right?

Yes. I think David will pick up this follow-up.

