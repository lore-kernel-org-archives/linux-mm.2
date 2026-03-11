Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870EF1125839
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917996B0089; Wed, 11 Mar 2026 10:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF6A6B008A; Wed, 11 Mar 2026 10:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB916B008C; Wed, 11 Mar 2026 10:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 581E66B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:28:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA15B1B6FA9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:28:48 +0000 (UTC)
X-FDA: 84534013536.16.891CE1B
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id F051180003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:28:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MWKkzPWQ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773239327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMglndSp+PIHHlEAetwjxySW2nxoKP5bwJuh4e/DEyA=;
	b=F5FmTezETHnO2PuBFhJUFkA1J5lUSYJaCnSNPeBZ5NUFtd8GW0FSNgwzlOAg7wr76GKtyM
	U/2ZnWIntA5WuGj1W92IBP5zCZe7C0qxRxsrFDEcbw3dGV7evVMoLXa9JepUpzCfB7thVh
	mZ17sKhgxQRV9LUB6v9byTRPqy0NvqA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MWKkzPWQ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773239327; a=rsa-sha256;
	cv=none;
	b=1bHarUjWOwSpLIB157hlA6/smHCUG7iQ/9joK1f+UiQvJnCDOiuknXaz5cG8od4uWtvD7u
	0SyaJ+UqiFolVwjyI+PUttK3UK5BuGd0v1Wnt1lHpPNMSCf1maGRXPYhhrbqjBojs34MR5
	G+NEAUXp23dVY8w5GBBhjOr5YTBC4Dw=
Message-ID: <3048ea54-1691-4098-90ff-ffb78dbc5cea@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773239325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rMglndSp+PIHHlEAetwjxySW2nxoKP5bwJuh4e/DEyA=;
	b=MWKkzPWQs48gIU3QM3JULAIUosOcv27xYnp/KCpC7CHItK86o/YW0GWfjF9GPrMPeebwVl
	dWO+ojK2bM3nHepkXamJm+CykbpdtS5wrsGclhkuA8G/mvYack1QHqHQOjlWoA76B/JOIb
	OycSVKTH8VjV0N+gDzUyGn2rmPJ9a2U=
Date: Wed, 11 Mar 2026 17:28:41 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm: migrate: transfer large_rmappable flag in
 folio_migrate_flags()
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260311132342.3193160-1-usama.arif@linux.dev>
 <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
 <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
 <eb83276f-60f0-47f4-b164-998a2f11e817@linux.dev>
In-Reply-To: <eb83276f-60f0-47f4-b164-998a2f11e817@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F051180003
X-Rspamd-Server: rspam07
X-Stat-Signature: r8f8tbchoezhxonbwxewp16sd79js9qr
X-Rspam-User: 
X-HE-Tag: 1773239326-385805
X-HE-Meta: U2FsdGVkX1+G6rUzh8HNa0haoBNPFfs37393Qzzmw6C5e412gQfGYDDJ8JMiqZBv2K0QkfNYr8Yt4RRaqaPfIiA9KIBKVo2pXU0G+Ri7K6IlqqMTEw65w7RaZZt0kdWLAXKRk97QtVuf06CthW7erhOq7Pfw0KFucC6RJ9ttFK2K3+dn727hNP/a3gsACQ7uo05cWTb1RuBEPqUOSdq7GGANcE5kaduxgIVTOwRcAq6srr7m5nOeiUkHf0JVvyB0eZoEkTJMpJ7h4Uh0Lc9MR7TyO33vo0tcf/CHJ60GeuNy/bYFKMUWgxuk+vG86XDBg7TjSgEJXDXfjcK6Mu/8lzzCr4TWAaklRuQHhaIUoEhU5YvRtZs8V4Z814Q5un2KQE0oeJBDzypJzIv+rb3WyWltx0bFxbicwqFZm1q70rbDZktY0tXivNToMZ2hATnw7BsXsrn3vbKLFEemIHA4zlcUXLbVYfbKqgQab+8lmSr6BCdT5Tbf/e+wdHwBT/iT9WaMUvEnBJgVRaWvat1W8rYO12kMLVfOUjb6TYzj/w7NgFqhugRzRvyr2jMOjR0SfUgCFuXcGudIhUqsw7BxoTotyTgfie8B/9y/7EFwEflAa/a4a1LAByaUVEk9fuqy3s5525NbbdJWc2q3lieXbF0DPWwfZ0jor8k2lg7sHAQyvCr5JpYpNtdQcO43x5s00T31gYX0Mts0c659I1HlAH0/0zNhd15b3/XUMIpo3Fx7gTvhTGuCCIdMqvEhqutdKwAT8DYFRtoq5R4ggeV+QZ409F8zx8Cz2b6xvJvKHMFpfutk2nanSmM28IG3Qf7++vE5UMkR/wcIlUoVIIZhTkOssg1GVPCauqzu+I3sL/oxtxVRav+QCeR4DFKmgtf9ZVg8uBl3y87U2vuRhKdEBmxAO/9+MHnEhQuvdSWr0UGkFm+wqRF/ZuSY89Mg/seiGFLdf/0bgN0r6EjCmsI
 PQ3AG8Fy
 s1slaNpG9PCf4e9o4FxsOYf34mwVkhQYK8kUvw/owE2G0C1e57PcksifZ5Yhy/kSS07rhfaxWMmBu/O4jt+5XI0oBKHHyj8Qsl8B0X+OGLXqOIJfuZSaEmQY0QHYUawsqmQwnHW+6Jk/UAbD2fraw/iiMLdoPo5ICylzSaMd7elftV6fJnZVmcf3EkOMndCpppLZKcw1qdp7kURBdCcXdFVny8rufNeKyfaxtunN3EyGbQcmDln6WedyKonG20MGJKa05QP2PCdCtQUVm/xHpCmcADtZbclB22xyYM0pKankctaWDEaAHG0XO7q6CwZTTKLGcibS751lQGRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/03/2026 17:24, Usama Arif wrote:
> 
> 
> On 11/03/2026 16:38, Zi Yan wrote:
>> On 11 Mar 2026, at 9:33, David Hildenbrand (Arm) wrote:
>>
>>> On 3/11/26 14:23, Usama Arif wrote:
>>>> folio_migrate_flags() transfers folio state from source to destination
>>>> during migration, but does not transfer the large_rmappable flag.
>>>>
>>>> Migration allocators like alloc_migration_target() and
>>>> alloc_misplaced_dst_folio() use __folio_alloc() directly without
>>>> wrapping the result in page_rmappable_folio(), so the destination folio
>>>> never gets large_rmappable set.
>>>>
>>>> This becomes a problem when a folio on the deferred split queue is
>>>> migrated: the destination folio can be added to the deferred split queue
>>>> via deferred_split_folio() (which does not check large_rmappable), but
>>>> when the folio is later freed, folio_unqueue_deferred_split() bails out
>>>> early because large_rmappable is not set:
>>>>
>>>>   if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
>>>>       return false;
>>>>
>>>> This leaves a stale entry on the deferred split queue, leading to
>>>> use-after-free when the shrinker walks the list.
>>>>
>>>> Fix this by transferring large_rmappable in folio_migrate_flags(),
>>>> consistent with how all other folio flags are handled.
>>>>
>>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>  mm/migrate.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 3380021fd3db..ee1c7bc851dd 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -846,6 +846,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>>>  	folio_copy_owner(newfolio, folio);
>>>>  	pgalloc_tag_swap(newfolio, folio);
>>>>
>>>> +	if (folio_test_large_rmappable(folio))
>>>> +		folio_set_large_rmappable(newfolio);
>>>> +
>>>>  	mem_cgroup_migrate(folio, newfolio);
>>>>  }
>>>>  EXPORT_SYMBOL(folio_migrate_flags);
>>>
>>> compaction_alloc_noprof() does the page_rmappable_folio() at the end.
>>>
>>> I'd assume that all migration allocation functions must take care of that.
>>>
>>> It's a responsibility of the folio allocation code, not folio migration
>>> code.
>>
>> I agree. The migration allocation function needs to give a folio or other
>> types of page matching the original one. Do we want to turn this into
>> a WARN to make sure newfolio matches folio's large_rmappable state?
>>
> 
> hmm its done in compaction_alloc() and alloc_migration_target_by_mpol() but I
> dont see this being done in alloc_migration_target() and alloc_misplaced_dst_folio().
> I think alloc_misplaced_dst_folio() is used by NUMA balancing and alloc_migration_target()
> by hotplug and memory failure?
> 
> I am not very familiar with migration code, so maybe I am missing where its being done
> in these paths?

ah no ignore me :) __folio_alloc_noprof should set it. Thanks and sorry for the noise!



