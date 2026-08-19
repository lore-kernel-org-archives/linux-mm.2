Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C8FC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 01:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEC66B008A; Tue, 18 Aug 2026 21:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51496B008C; Tue, 18 Aug 2026 21:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18996B0092; Tue, 18 Aug 2026 21:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 856266B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:51:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DF0AA28CB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:51:12 +0000 (UTC)
X-FDA: 85116341184.21.F83E405
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf23.hostedemail.com (Postfix) with ESMTP id E24A5140004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:51:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vvyil+kc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787104270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5IcNEatytGTPUKYR77GEVkAg5Qjv+lyPMgMLcq91DY=;
	b=0+dYaQjcbRgwNuUlvxUP8V94d+OlMd82vc4opXEFE4rHQIrIbD5dHyI8zh7/2Sco6fC3ZT
	41fpctPgpHEhVOevO9I7EDo2P0E8NMrruOduoKyY5i2VvTRA2zVttNxjcokxTopwQG82to
	F2qU/RwslJylpbBnqW0uGRuLFPsjMFI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vvyil+kc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787104270;
	b=nl2sD4NvWKyjaVQjT3u263lOTMcIGrwRmL05y0bjDklxc8mmgyaAZj1RIGIpRUrgxKi1/L
	q7rf92rh5ZYycp3APr9bh7kY6IkOz433oQkp89PMEeZLiMwNXMPbuXxzgIza4Graw7CMIv
	hk23m0iNflTxwTpEbh5YdsPgRWReD5A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7Iz7QmaZlme6W5EkeBnypYFasClabBBUHorOF1oxkaA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787104268; v=1; x=1787709068;
 b=Vvyil+kcR9SwvrjpZfXy88zbKUIW6mNlJLzxTsWSUzwA5CpKhzwX2lZjMY7cr9tvgbIPYrQT
 zS8ZqKnUUScrmy7h92KUe6fo577zsiES7PRetqHTw3RsaHuFLsr96zJ/PFmNCR54OHhriAQoTUL
 U6SFJuAQnzP6bOZP3/oO9mHg=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.22.64.46] (118.201.124.118)
	by smtp.migadu.com with ESMTPS id 845baff155800fde;
	Wed, 19 Aug 2026 01:51:08 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <2282ba9a-0c6a-4ce3-99ee-517231f515b6@linux.dev>
Date: Wed, 19 Aug 2026 09:51:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add cond_resched() to free_pud_range()
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260818134934.92354-1-leon.hwang@linux.dev>
 <aoRnUxUlgf_kRlm8@tiehlicka>
Content-Language: en-US
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <aoRnUxUlgf_kRlm8@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k3xgzwsba83y4iaqqrhrunbhzmsw74nb
X-Rspamd-Queue-Id: E24A5140004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787104269-614538
X-HE-Meta: U2FsdGVkX1+VExOhBDtDSvzoAqRMRGO5pKd1tEfkMPvXLVwXLWEdCmUdBXgLSsfTIfaoeXnfFmY2yvG3vq1TCcf4FIGFUK2jySH1PJO3VvJZUvRLp6Vf7SlMzdNJhAlOqUG7VwzKPwDrtuEkDSs4bu9PHb/nEnoqAwhpVYQQx+zayg/9jT6WNPdnxKQ4P1mENjbLMhMXHTxu/vz+KERHBhnhloI7YpjFP/xnBNAeuBy3moydraa5qHDOJt485Ju8ufNwOLRnDwUbVEggP95WhyC15hrE0ki/QQpTyHHsUbIWlND4YZwT6onyOoyvnPoiT0KTx/kttCgS8ohrHEJQTfk9kTqIfVtanPJ4OsxqNofrdSgLSls0BEOZ4dO3fkdfw5BEGUHdeTqSB8MQhjBvYIG3XnMJMLCTkb62p4bs+nyKCm8pUOU79oentLHPdzPZpib2Wv4Qeungnh+A1Tcf6Y5zVMv8l3Gtc8pHKMPFWIK34vbCE0l+FO4eKJRYIHXHZrS7NDfBuz/SKrXCYepdj77fyjZVh8NJFptEQbIkkgoAOldWtIqpuMmDFP/lWuL0c9tYM9AtdYpdWSrwwAjkK5JGMCxKnHjSRYWLt1XkKlAqIm58EF6N/Gy7D8tHNjpiUydxUufZwifU3icZDbYYfmS2ViF7GQPPsTTxs4+hR+FJROLxDKFW7R7mkbvVebT+ynU+EMM/AN5ZeGluxH+4rcsf2N3if/W8SUvXxhq9CkAQ9i2En0eLnOw9+JQsnZVh5PYzhfxQhXfayUZa1kSsQmPquZElneGvW8GrYxDDbgC1hDH9lzbvz0X5fmuv3KFkI3TX6DR6tNNqEubibEtWOpyLh+zZOpEDTibIhHrC0lHQyfQ6R2qiPs/cGFU1vx6OTWVZQWU10hxUXhKLAa+soQNK0j7ftKJLn3L/p4MHJSxSfh/oE9cyHAMJFk10p74KEh4wJDFHZ4XridJflRl
 EV0wie+x
 DTFMX3fNZ81gDydgxXeYHOYFOeWjgJ9EjvZlYGU5c+F9adHrRPU5WdrQ7g18an/JrwgDqP+mff2YK14zrkHQbify4mfYAt4aG7pC+ddYx5/xYqbQfS8drFfZD0SBCuJlYHRrvp90aUeMSP+UNaericc7xlktDUsiJn6vC049oM/0MynkZudqPeqVYJosR+b2acC76QwsZK3RMrZ2RxnaY/20ReOwpntgA2VXPfaKyt4oIFfPNhtljESj9dBOZNpa/xNsWZJ3XgHESCzqlnTqo9qBBs6H9NXVxOIxfHplrNEmo/U6ekCVTwMYxq6EN/3jUXaAyue0NCFB6k6RWYfekiBPTzFWMTcsfQX3uWwfviV4QljOtt8yYEuJUQLVc3SStaaWpFyvHqJtOeF6P9E9CfB/xSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/8/26 22:08, Michal Hocko wrote:
> On Tue 18-08-26 21:49:34, Leon Hwang wrote:
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
> 
> PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
> removed. Is there any reason why you are not using full preemption when
> requiring low latencies?

Seems that we have reached a consensus about adding cond_resched() [1].

[1]
https://lore.kernel.org/linux-mm/20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org/

Thanks,
Leon

> 
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
>>  
>>  	start &= P4D_MASK;
>>  	if (start < floor)
>> -- 
>> 2.55.0
> 


