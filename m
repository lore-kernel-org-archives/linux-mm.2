Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D85FD0651
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBAB26B0005; Wed, 11 Mar 2026 10:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68126B008C; Wed, 11 Mar 2026 10:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D499D6B0092; Wed, 11 Mar 2026 10:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2C086B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:24:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3258E89716
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:24:58 +0000 (UTC)
X-FDA: 84534003876.15.B168405
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2361FC0003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:24:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z0y7nMAQ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773239096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Q6Luiv9qiVEnzjVEL5Hi88cV3Oz/GVyjOjLLRkZ23I=;
	b=2e490rQFe4y4OEAmwfOeiIUCAy6ZuvQvuvsS8IEBHKUMwZmbVjgZgoUBDcRud0wocd+Zvf
	aKtsgT/9uLYwdj3qtITcxXwkfeCOP0eoxgLqSMmSnkiezfXvD9h0bGaTVcPf1C8iVyO1/7
	wF7xrFqATqbtQhcUORV2beEBW9wmHfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773239096; a=rsa-sha256;
	cv=none;
	b=8LTuVqWtP0sPM4O35pwzcTqUk9sNAe1WgUHfodQGm53WKsi+Bpls5NW1jQhloAeOraa1L5
	+7KaqjTe1aSgxqHlXgI/u7UG0ZYCCSxxEIbkU3iyr/0rECnovOTNqUHfKczcvyewxG+D78
	KMAfdQ2d5zIUg6YRGeeBIWLgQcjnk+o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z0y7nMAQ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <eb83276f-60f0-47f4-b164-998a2f11e817@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773239093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Q6Luiv9qiVEnzjVEL5Hi88cV3Oz/GVyjOjLLRkZ23I=;
	b=Z0y7nMAQf6k0KtZFyhCOdCaRdFaGhBDk8Zzp0CYUoTHhwh5K6vchZWkSxaYmfe9RFWyekQ
	cMyM3G+r+YzYPmwgcXqTROWwZ/uPb3IaA2wgpFNFTGSjQBchnQYimWD+0plN110RChU0xz
	yZUCkDQK+bvC5IyRqiLrs9L+2O8cKmM=
Date: Wed, 11 Mar 2026 17:24:48 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm: migrate: transfer large_rmappable flag in
 folio_migrate_flags()
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260311132342.3193160-1-usama.arif@linux.dev>
 <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
 <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: gmja3sye85neto8jb64q6ierf6bhcnfa
X-Rspamd-Queue-Id: 2361FC0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773239095-695320
X-HE-Meta: U2FsdGVkX1834bI4HuKwCRG4EQoWNhgeeawzDD03qWR1eXRnrnYd73/gb4Hrv7FbMdWlWZAmUo3p9yZ8wiuJPMhWG/VK7jRgrhB8WilDKI8cak/jvGMSoROfhP5mkTqvEOCl7QRlO3ZrFmSb9ucce9ZsZaAulo+nwb188hEKaBuRIwP3yN+RtZCAdKijduPq8djgVQqrZy9jx40iIDDhc/j3IFbCFUsnfZ3yrpubp36EFVyxyf3ZZdrOEeamc9XP7X//C0L1PNuqiG+dWqa+6LuVQsmeBueLz/i/I3I9oOXCzaJnY0LYphXjQdVCmQO0vgRghx/tNji8QtmFIBNn2tpgocdnGC8I2W9uhMdf5VvgcjabsTm5KsNivVjWs6iJmH40Buej31PxiLgxp2d6CdEXeKeMGwRPp4YLysP27/YV90a3OKgFWdCn1zXlLmh/ZZhj4mE9O37xSsRB7W16SQmIEvd7zJz97c0ZuBoj4L2xUsCrYWnqRSwOA0vESFbJP0TDjDa9cWbbUzVbgH9W+fec+PAmEWo4egUMaawbV9NPsxFqW1u7OP5UPVgB/vH7/9/tAdiPsA51sWJ29aG9fEwFhprMImCQDwt/BRCb4EfrUokvX3nhTJluNYXTBrwRiWcOt9S+1pK7Iyz1SmAju1a4xBN04PHm5vpoSNgmm5MXAfPr582RT+29hYTzNwKXlYF7YljwuHxLL24gDSdIhbTTbMPmeyAPekz+FzUpEEBghaC/Zr5wRNEWMj45PNswhEMclTDFn8vAoRd5pfwhGYTfLhb9aevL9rtrHmvp61JRKAqe1Wp53MZ4+g9yXx3JU7U9aDlYOSNfqERgDtYmQLenBz5U+Z0k6v4Vq1boPcEbfKE1Gy8XmJSxRfcf+GMF/YICa2NZyTm3njTvxdkBdu85hLI7AQCtm5DZKxhxhI/4udoxDobK1IW0omW39U8uV/NXDghilzo3Kbf/v68
 MZVuC4x1
 TpfnjMEaAiAX0cYYq+upcrhs2bSDNN2n2sbrnAhg7xfVeH6OlUo5HgLHUQH4MQM7hL3UJlHTaXtPhnQnCwqKfZPKb+141KaOuKpC8Zmk9EaTnWHm8ShotCfzhYvCLQwAPIaFLYPjcG9Z2CksYL+vNs/NLp9M5AhsC3kvtmoILqjaUNu2jHdF9V0wlgS34F3Ss13KNiER27WTHEZpmex4hCVnfBdIb2c2y4t1cozN9xpcHP+I7Mfj019ESWTwO+Xzl8nu3zB4Th3UuhwnJPtV/vcLZ85kGP95FbxW0UOKWGSsq9ZLm+rJGRbhJ9Cdkg++TfLyieQDw3TO0Z8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/03/2026 16:38, Zi Yan wrote:
> On 11 Mar 2026, at 9:33, David Hildenbrand (Arm) wrote:
> 
>> On 3/11/26 14:23, Usama Arif wrote:
>>> folio_migrate_flags() transfers folio state from source to destination
>>> during migration, but does not transfer the large_rmappable flag.
>>>
>>> Migration allocators like alloc_migration_target() and
>>> alloc_misplaced_dst_folio() use __folio_alloc() directly without
>>> wrapping the result in page_rmappable_folio(), so the destination folio
>>> never gets large_rmappable set.
>>>
>>> This becomes a problem when a folio on the deferred split queue is
>>> migrated: the destination folio can be added to the deferred split queue
>>> via deferred_split_folio() (which does not check large_rmappable), but
>>> when the folio is later freed, folio_unqueue_deferred_split() bails out
>>> early because large_rmappable is not set:
>>>
>>>   if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
>>>       return false;
>>>
>>> This leaves a stale entry on the deferred split queue, leading to
>>> use-after-free when the shrinker walks the list.
>>>
>>> Fix this by transferring large_rmappable in folio_migrate_flags(),
>>> consistent with how all other folio flags are handled.
>>>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/migrate.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 3380021fd3db..ee1c7bc851dd 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -846,6 +846,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>>  	folio_copy_owner(newfolio, folio);
>>>  	pgalloc_tag_swap(newfolio, folio);
>>>
>>> +	if (folio_test_large_rmappable(folio))
>>> +		folio_set_large_rmappable(newfolio);
>>> +
>>>  	mem_cgroup_migrate(folio, newfolio);
>>>  }
>>>  EXPORT_SYMBOL(folio_migrate_flags);
>>
>> compaction_alloc_noprof() does the page_rmappable_folio() at the end.
>>
>> I'd assume that all migration allocation functions must take care of that.
>>
>> It's a responsibility of the folio allocation code, not folio migration
>> code.
> 
> I agree. The migration allocation function needs to give a folio or other
> types of page matching the original one. Do we want to turn this into
> a WARN to make sure newfolio matches folio's large_rmappable state?
> 

hmm its done in compaction_alloc() and alloc_migration_target_by_mpol() but I
dont see this being done in alloc_migration_target() and alloc_misplaced_dst_folio().
I think alloc_misplaced_dst_folio() is used by NUMA balancing and alloc_migration_target()
by hotplug and memory failure?

I am not very familiar with migration code, so maybe I am missing where its being done
in these paths?

