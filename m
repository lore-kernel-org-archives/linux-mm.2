Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07ACDC5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 01:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81586B0092; Tue, 18 Aug 2026 21:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59396B0093; Tue, 18 Aug 2026 21:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96806B0095; Tue, 18 Aug 2026 21:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9341A6B0092
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:55:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20D1EA2CE7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:55:25 +0000 (UTC)
X-FDA: 85116351810.11.8C5CADA
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	by imf20.hostedemail.com (Postfix) with ESMTP id E03CC1C0002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:55:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vlwdm8Yh;
	spf=pass (imf20.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787104523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq8nFtIFJtAYAl1YTE6HKGgkGD/lIo/KSny4MN0wPCw=;
	b=XRAKrYW3ldRDewWB0+2PAf7HT88reyXXt1V+1kfnr5uflDdIBnJW22NNhsxUf4EXjO0xAQ
	Ph3EMT100U1tO1yVSx+ClFMlwQUNC5Fe1P8KEcR3uqYlpljxJS5jOsQz97MV8U+60JAf/A
	yXSyeFSysMJLeRSWCSWI3LgrYI5Z0YE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vlwdm8Yh;
	spf=pass (imf20.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787104523;
	b=4ND+SRCNBGaRGF0o6J7BupHRMZybOO1WpLK+Fq+xbTfoSiniJFt7ykYYmy2qtChffgGmvI
	vaymacff5PkJP9HS5fL8RPzEO+vO2TqcrN1nUzhCLxjMNJu0/T5M4txxbWMIgujxisKO10
	27rKFJ0DdQJdAuCt2ir55LWGt8/UA3E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cpjSziAa1QWsebCg8X2khZdcgAgtgosPRo76uTwvxEE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787104521; v=1; x=1787709321;
 b=Vlwdm8Yh+PqEUzqCuUlJWdMTNkkYSykqPv/uqRvVyOVb9pxKOpDmhf6u5tjcLVSTx1sPjvLe
 K+9V6E+W8Dczxp7M+xse1nY0Xy9ZXbRVKV+EokW7pW7qglf5RBq7zJxJcIXrpkpwckccwTkbyUl
 /9KelDzBZLpcmVkgIUSiAOrI=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.22.64.46] (118.201.124.118)
	by smtp.migadu.com with ESMTPS id 86b40ab8aa26f951;
	Wed, 19 Aug 2026 01:55:11 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <581a7675-61e3-4418-8a98-e2ba6e3c6d81@linux.dev>
Date: Wed, 19 Aug 2026 09:55:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add cond_resched() to free_pud_range()
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260818134934.92354-1-leon.hwang@linux.dev>
 <aoRnnWIUrZbh2uL6@kernel.org>
Content-Language: en-US
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <aoRnnWIUrZbh2uL6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E03CC1C0002
X-Stat-Signature: 3ipwka38mx8wndjrttix9iq8xa4f3xk8
X-Rspam-User: 
X-HE-Tag: 1787104522-620517
X-HE-Meta: U2FsdGVkX1/I1Fs7Bv7mgMPozI+kAjWcquV3nuqLVpuYWBEnVrvOaQCa9RLlEfO/F1+W9WDglin860yojMexsAw4Cor5GGXV9bGRfXrn+cwVc7IepP9jr/sBXeHtG3tWRfD98kLZNEl1ZBWs6wHbNbmtWuX5WZAWu2JAacysFumQiKAKvKEWFOxA/chEAAZXosYmbkk8aEvWBUCT0Jb3AKYFmRdpphthZ17z9wbN7t1JIO1fe5wpqhqTB/n1cl0wexaG5HCrszssHk6ftds3MUOZ9cW7W/StEVw1jpt+zX5MWzQwVApv7l8dpq+IZtq2GIwuxOSwydziT/1asyqYy8XyK6HC9O9I1bH9nFsBuD4hhLFX/c06Sg7cLJllo4QehnIiq8wAh+8bFHRDihHPRsZvtEnVsnnmMiEUDmJYqdHyGxmj/gDzKlZTk9wVOqY7R+73Q0bdm8pui2I09KoHBPwBzN7IhdQCyRuUQHuvUY7xJUUon3LGS/cVK9qX+6p5lQE4jaHBk9qO3EF3xhMtoaw7pqX5bPPEoTFeW36cr0HBMaMnr6ogcBwskTrZYXJo4s9JIlnzyXt6khxPGvhBi4f+OjyopTqxLOXMmM9kJd69BArPP9Ch2P54lpYKfFukv9tZUNSzt9FdZpX9rU+I+GG1hHoMy08+Y1v94qmyCWx0tzOgSyHsorm7wX+ugi96ZbK7FfYmYMLfU5J7cw1CQrnv3YP7GR1Zk/r8kfwjITkwT+SuNaz0kS/TdiSDceipeu7XZKsbXpQXhrXO4gYsEoOLTj8pXSrXzDXkIv5MHcJpl1w2jzH/ybeLUsN+ZMzuRviOe41D8y8gMKDpYBXTilAHOi1Yl4X9/q5A1lB+Re9v53ivIMJwruQBNLBxD9e8g0GGe7NaHD73pZkgW0a1YkQg6d9FA63OY2v0DasAbZNqS1KAnjOKcf4l3EiJd9N9v33bdq+3dSmES8mG60J
 atrDXdUX
 rdnMgGyJzyF6fdUdTzKL1jr4Y5y58jdQz4L7HRHanltkYPkXb2/g7k+PJoUBhO+33qBmvXZ82aNgua0OWEzw2EXB/w6eF0a13UGT1c9vU4aqHgPbPdjd0SqluO/t2zDwOngw+YusXoU8d4KIAsgXUmYgPBFeQaPoXar6khFXrOCt5EXW87Fz33FlRzJE9tsyLJaje4oXci3cMCt0Ur4EYSbtc7do/x73fc+a4788C0XFKVJ6PhFkN9yiwPb9wa6LWkFXVYTkPyfjU19ANaeYYvJ4I2/bEHyjqudPZosFvN38FRZKEOHsaIFntmGnH0u6jaEid
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/8/26 22:09, Mike Rapoport wrote:
> On Tue, Aug 18, 2026 at 09:49:34PM +0800, Leon Hwang wrote:
>> Packet receive timeouts were seen in production. Tracing showed that an
>> exiting process with a sparse 2.5 TiB mapping could remain in kernel
>> context for over 20 ms without reaching a scheduling point while
>> freeing PTE page-table pages. Hard IRQs could still be handled, but the
>> per-CPU ksoftirqd thread and other runnable tasks could not run during
>> that interval, delaying NET_RX softirq work queued to ksoftirqd.
>>
>> Like zap_pud_range(), add cond_resched() to free_pud_range() so
>> ksoftirqd and other runnable tasks can run between PUD entries. Testing
>> with PREEMPT_NONE showed that the maximum interval between scheduling
>> points fell from over 20 ms to below 2 ms.
>>
>> Reported-by: Lance Yang <lance.yang@linux.dev>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
>> ---
>>  mm/memory.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 4134ac607ee0..68c15449de07 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -231,7 +231,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
>>  		if (pud_none_or_clear_bad(pud))
>>  			continue;
>>  		free_pmd_range(tlb, pud, addr, next, floor, ceiling);
>> -	} while (pud++, addr = next, addr != end);
>> +	} while (pud++, cond_resched(), addr = next, addr != end);
> 
> This is really obscure, can't it be in the loop body?

Agreed. It should be in the loop body, after free_pmd_range().

Thanks,
Leon

>>  
>>  	start &= P4D_MASK;
>>  	if (start < floor)
>> -- 
>> 2.55.0
>>
>>
> 


