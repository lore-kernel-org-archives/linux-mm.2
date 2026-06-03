Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461EDCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB9A6B008A; Wed,  3 Jun 2026 08:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CB36B008C; Wed,  3 Jun 2026 08:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982416B0092; Wed,  3 Jun 2026 08:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 861186B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:20:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F5B81C1757
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:20:14 +0000 (UTC)
X-FDA: 84838508748.04.F1011BE
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40152100004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:20:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MkxB/4IX";
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780489212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVPf2HxnOSeDo+U9qlfy4aat8ZJ692PaW/P5vPj0roc=;
	b=0X/vmTIzH3qnZKV8NeNdL2SCO8ULagh4lt2/Z+4Q2TWS5Uinci3F64MXsEDlDjIwrnKD+J
	Z5j5PDPVTOA1XvJ34T+Y/fTjWJzWn8HuHSWcrJFGRrHiSLVdmfEodRAPKKCUB7Lio5mbUY
	bxVmyVfoyHaD92AOIuDQm7kXPNn4Vf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780489212;
	b=MqRaa1yo3rQp3UE+cterFv6mo+QjRxjSYn0vxk61Tvz0jv66BOe7nPn+envuUHXE0Xl6nj
	+UCdg+p2k+Be6MLYTDO38/r4wmFT+Wpj1mTW5ZpxbilUT3+kUZuZdMdvip4QGS2gL49LVA
	xH8TG2NHLcyS6EYBWIniQZKy1SJwNZM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MkxB/4IX";
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <ea70f2cd-0cca-4703-973c-6f3344ac345a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780489210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVPf2HxnOSeDo+U9qlfy4aat8ZJ692PaW/P5vPj0roc=;
	b=MkxB/4IXntiepknr2HPty4AE/U6fUgJTQXWGd/DQzxZkMcFotDK0S4I1PROFNjE83/wgaY
	fOzGvdJSZVKI4IPaZKPvt9cMJaUNvGT/c24R8FMu0qsaXcvxvrVZs4D0ceLlN05uSOga8E
	5eGLLSIMksIxNpQw4dGLg9m/HWOR6m0=
Date: Wed, 3 Jun 2026 13:20:00 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pfalcato@suse.de, vbabka@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org,
 kernel-team@meta.com
References: <20260602172247.279421-1-usama.arif@linux.dev>
 <aiAY9FiHthu_CwIC@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aiAY9FiHthu_CwIC@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40152100004
X-Stat-Signature: yan38o7u3nfpkb4fk9c16gwffd3giuwi
X-HE-Tag: 1780489212-652249
X-HE-Meta: U2FsdGVkX1/KfmpyYHCFJTUk7KD8wla4RIgxnqyLvuN8bTIEA1zda4jf7fqVPNoyfdCkiER8deigP8NvtKNnZP/2BdfoShGtlqh3b/mTGMdLlIFpdtKBsK8GhtLbH+PEQU895Mc284BRvf1JOxofaSjHHrfxpNACwN16Iky2D5rYMrIeTev17jx2gZi5wl+8yg+ptB8oul6seKctUfrwP25jBojtv7Bqgl/GM64lTLymFdsyNTUI4Iuku0EmF8OIadqGuLdlJUcOvWpmhsDgXZz4Uhvjp7WLa9OF+le4gq4pAkQkObHj9J5kRUvjFLFAvPiBCGoFsbCdzTGo9U4t2UY6lU6jVMv7Csc0XbZVHN5Uk//p7KQA44VixpKxX6Dk+x/Wk0Q8r0fef1HOcGLHM5EpegUgwEGWCOkZbE73trevS7IRx5HRp3+3OHcjyaEfRw98/Kk4D4J/m64UzC3EqqBgct5cB+qhPk3ffjUe4J5zNkWnS5c0Sf6mnzxQbSf55SrZFvf/e5C4bDvDfXaL5gJtfCV2eqx4kYJGb3oitBDB0npGD4Ib6FV7NDMGnVtDR9+d3oj6+WompGlyt0Bxn2xvnZDDpG7vIgkfWWnRf83sBa5cAYlVI0kL+0811bVeuavppcixrwJv6XJpqf/ZqFp0+OSaNncIXdaWnfveSLa4qhbc8dwI5OE2MFS76EYmZdNwbp61Ei15+swUo82thd00w6hq+iH4nUSp/XnEac0Aq+lPVU+dhbQsfYTlKza2vwdjwdCTXClXnalwrEB2/GDu2fEkI2JhXKLhtFP9uw8eojlEkpawGTB247YaxJAgRdXzqQ/kB7G2NZvyyr4cwqXBW79EwIrAdzARC0tqM+aGkLTqbNydd57RWeu/TBwZLomgxGVUP9rMSup7jsyOKyRlzTHAC/2GFzbaTrVvIC4yhuceyl7RHatGCaolOirICiyTWaeaIFaD+Mp4hWM
 FKpFs0rj
 aJW0t/SZaNomda/6KXWOV0JQv0Pcq03jUGhr8T7l/L50CcvBc5R7a7XO2dGsuGBEoX4AP/ACnFRhqtZii/YxdQVtuqDsdp7cRAkworT329rxZmO9U/Ml+AGht8fI4ouqb1OczBo1Nh6ZgswNz5GWOVYZCNAMfHfn6dMCsYeBQHBSqROtNQOt1xS3TluPNLSvr0by5cmUp6YCd4yadgo41xTWMntjFX9wN6q9FWg3KJlkEGKLZ0nHy/gFnvj9eLxMg0CpOg+/AT9SEjbhuGeihkn8XJLcDhZCg8ctSuhnz2waJ9doFKeu7WJ6Ze7nujoPDWPnO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/06/2026 13:08, Lorenzo Stoakes wrote:
> On Tue, Jun 02, 2026 at 10:22:47AM -0700, Usama Arif wrote:
>> mincore_swap() also fields migration/hwpoison entries (and shmem
>> swapin-error entries), which can exist on !CONFIG_SWAP builds when
>> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
>> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
>> return, so mincore_pte_range() can spuriously WARN and report these
>> pages nonresident on !CONFIG_SWAP kernels.
>>
>> Move the guard below the non-swap-entry check so only true swap
>> entries trip the WARN, and migration/hwpoison entries take the
>> existing "uptodate / non-shmem" path.
>>
>> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Logic LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> Small note below but I think not a problem.
> 
> Thanks, Lorenzo
> 
>> ---
>> This was discovered when working on PMD swap entry series
>> (https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/)
>> ---
>>  mm/mincore.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index e5d13eea9234..296f2e3922b5 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -64,11 +64,6 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
>>  	struct folio *folio = NULL;
>>  	unsigned char present = 0;
>>
>> -	if (!IS_ENABLED(CONFIG_SWAP)) {
>> -		WARN_ON(1);
>> -		return 0;
>> -	}
>> -
>>  	/*
>>  	 * Shmem mapping may contain swapin error entries, which are
>>  	 * absent. Page table may contain migration or hwpoison
>> @@ -77,6 +72,11 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
>>  	if (!softleaf_is_swap(entry))
>>  		return !shmem;
>>
> 
> I guess fine to do this after software_is_swap() because for !CONFIG_SWAP this
> will always evaluate false?

Yes, thats right. In softleaf_is_swap(), softleaf_type() returns SOFTLEAF_SWAP
iff type_num < MAX_SWAPFILES. MAX_SWAPFILES is a compile-time constant independent
of CONFIG_SWAP, so softleaf_is_swap() isn't structurally gated, but every producer
of real swap entries lives under CONFIG_SWAP.
With !CONFIG_SWAP none of those run, so softleaf_is_swap() is always false.

> 
> Not a big deal therefore I think.
> 
>> +	if (!IS_ENABLED(CONFIG_SWAP)) {
>> +		WARN_ON(1);
>> +		return 0;
>> +	}
>> +
>>  	/*
>>  	 * Shmem mapping lookup is lockless, so we need to grab the swap
>>  	 * device. mincore page table walk locks the PTL, and the swap
>> --
>> 2.52.0
>>


