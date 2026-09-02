Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B8B3C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595E66B0092; Tue,  1 Sep 2026 23:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546C36B0095; Tue,  1 Sep 2026 23:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45EBB6B0096; Tue,  1 Sep 2026 23:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 175446B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:20:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84CB91206EB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:20:53 +0000 (UTC)
X-FDA: 85167370386.05.9D14819
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21D4DC0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:20:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RB6lHacI;
	spf=pass (imf28.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788319251;
	b=KI2SGxVPXXvHBTybcYQTmckP+SWw+kiU9GqjezM06jNeEYFhVr1e+xORcQ++VF2Re/u4Bb
	u0vNbipoz8ybMGkqGlIJa8fPpx0fOYs9nY4NgC/9f+dC/xWYPvi4Cr3xUnGKottKZutoBm
	EwkYEpbDk/MG0jhH8VwfO3IMmI+psx8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RB6lHacI;
	spf=pass (imf28.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788319251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLAjDGuF8OXoX4Kx5ZvQEJnyRPp4ec5ri2eE/T7xMg8=;
	b=QdaFVIZD1mlLjqhl+Svpl3qtwR1lY8bi+Zd9sJDKuU+KW+1A7RiKlIYx+hxdp2rial/C8s
	GkNUbiUg6/VnbRa730/C175n9Mbm9qf+bKaNS+g6RuEkyJorVMy0rsXI1w3gy53f+OJOiL
	4ybYpUy5X5b9HRY38ULOFJ2na/jv/0w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788319246; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OLAjDGuF8OXoX4Kx5ZvQEJnyRPp4ec5ri2eE/T7xMg8=;
	b=RB6lHacIhSzrMcD4AolxPf4x/4t7TL5rrRKvD1Hw9nAKn91sEg+hrEEZdNjaDW7JkRCtagl8n/Sy7cDZSCErqbmwd8XNOQKtwCcVqRp3AOnc/g7hRGFY/r5V35WKi6G0mePFVMO61hOtDWzT8TNeACb1mNuS+GOm54mB5OL00y4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XAB4.Wb_1788319242;
Received: from 30.178.84.37(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAB4.Wb_1788319242 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 11:20:43 +0800
Message-ID: <cc69f57b-47f3-4842-829e-df1d49158884@linux.alibaba.com>
Date: Wed, 2 Sep 2026 11:20:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Xunlei Pang
 <xlpang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
 <20260901102913.5c571bf153bc3830905c6770@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20260901102913.5c571bf153bc3830905c6770@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ouzihuqt3n36cuz5s3ic6q8gacquttox
X-Rspamd-Queue-Id: 21D4DC0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788319248-901542
X-HE-Meta: U2FsdGVkX1/Tp4bmpkp2o5jDVx/nMlAKqRlygCKuKHXq0ukJCke12E67C02dXKiBt1cztJJSXv+XbnnrNY0amucQ53LlNqdnPg9/io346rXpnUyIHiw04StP7EwajZCoM1w8DuAN+uAyPXQ+j3de3EcLEOvY++fMjIlmnss5j44lwACLTFeHtavW2ff/dnH2lOkhxHI5roIuf9qSyM0kFKyb98X5RnuWFh8G239rszSrr90A7v1Rg0Eg/7n2bnJ7BPSA++cBU9EdmqdEygeNawAQqeHkIFWK8eEwcTIO2nUqO5V4qGbK4lYR9OyKnNBI8+eLGKqXkmD0homVbDlxS1Y3WODHqaI+TYmzhkwXYi2pmyhfnV9qnd5rvxVFLLmmIhXq5FZwgbI0EqG8S2JGhv+dVHbdolj6lopASaY+n4lEnbu3UiH5696s/UeVz47Uj/gEEjDj2tp5WGW1cIwQwnYIi16Ejix4Kz2lsBI6whxPns4tXG6Mlht3Tl8ocuxE+U1QJPMiqecztbxBzdsquXYBkDgy/BRs5K+YdxaJ1sIE1EkkzVWfcPtRNWJUeWBhdnscAp6BDtKWzs0/l5Nf4596pJaA2Yhm/gWDez6Q+N3B0UTv669IcPMjM7CqRjRXP+BHumMxrIsWGh/lJYkpOjqLIS7wLZDlAU/HGBYpfVfWd5shv+4/tN2DqpkuAx5jcpiAPpUYN2AL/H4DIxqtllavJyRwhMapdY+3/+RHTfS+qLuGHrL+u7ah9jzsZ7BfWmCKiGSHB+SRWjApoZx41Io1jRb9CAceknNQ5g++AYrfIhLQy/sLJxqdxwKKWFuxAkfOAYNcptonC/dgny/p461aQREIyMJZbK/KyIUe2xYCeQDIQ/OMu4wUuEIQQWSZ603M+iw9ZPr2vq/YTLpnTx0Bp3MMBfZCgMWizLLzcgyjqoC9i72oSzgseFULSuf9geDLh8sCxA9HkRcclJG
 muXacQqR
 aMhjZVzvKTIxPlkGeDQ1+nN9dKKyT0fykW/9Cc6N89/KUQlC8ffCl3xwT70KIFiSCTyRQGmD04ybqCNloTJkEhStWe+IfdyX7/tQlS/gFikw53jjpAUFPnTTu2zCCwl1QFtEIY8i5iOWdXVPQGjx5Tfg/lXLHdvtV+oP45HPK7Sa+zZ1fcJUIhfBY/iRVepQRMMzENBHTWfRcG5oWt01vS2L2W1Jvayy7qLTPmxZbAiGNaLgWXYn/ydFTi8cEeS730RgK7cCuR+J2PCmlYCzYmm56SSVv5hM62ZdWb1gaDg7+7pRYtPuwFyY1OoMk3P/liVhv/3m+FaDodYn6oDOHOCpaOImqye4rQcElXLRN5E9w8t0KLk4McaznMmgAGt8UDuNDrxPQIeckjpI0sYFyybJ59FqJ5IYSHqR9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

On 9/2/26 1:29 AM, Andrew Morton wrote:
> On Tue,  1 Sep 2026 19:51:04 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
>> With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS
>> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
>> back to a non-memcg-aware shrinker.  On this fallback path,
>> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
>> valid id belonging to whichever memcg-aware shrinker registers first.
>>
>> __list_lru_init() copies shrinker->id unconditionally, so every
>> list_lru backed by such a fallback shrinker (thp-deferred_split,
>> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
>> up with lru->shrinker_id == 0 instead of -1.
>>
>> Under nokmem the list_lru collapses to the shared per-node lists, but
>> __list_lru_add() still calls set_shrinker_bit() against the memcg of
>> the added object.  Most list_lru users are unaffected because their
>> objects resolve to a NULL memcg without kmem accounting, but the THP
>> deferred split queue holds user folios, which are charged regardless
>> of nokmem.  Since no memcg-aware shrinker can register under nokmem,
>> shrinker_nr_max stays 0 and every memcg's shrinker_info has
>> map_nr_max == 0, so the first folio added by khugepaged triggers on
>> every boot:
>>
>>   WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
>>
>> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
>> and expand the maps, there is no warning; instead bit 0 is set
>> spuriously for an unrelated shrinker.
>>
>> shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set,
>> and all readers inside mm/shrinker.c already check the flag before
>> using the id.  Make __list_lru_init() do the same and fall back to -1,
>> so set_shrinker_bit() is never reached with a bogus id.  The stale
>> shrinker->id itself is left as is; cleaning that up is a separate
>> topic.
> 
> Thanks.  I'll queue this for test and review.
> 
>> Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
> 
> Worth a cc:stable, I assume.
> 
>> ---
>>
>> Verified on a machine booting with cgroup.memory=nokmem and
>> CONFIG_TRANSPARENT_HUGEPAGE=y: the warning fires once per boot from
>> khugepaged, disappears when nokmem is removed from the command line,
>> and no longer triggers with this fix applied and nokmem set.
> 
> That's useful info.  I'll move it into the changelog.
> 
> 
> Sashiko thinks there's a problem with cgroup_disable=memory as well:
> 	https://sashiko.dev/#/patchset/20260901115104.2944996-1-qinyuntan@linux.alibaba.com

Yes, the observation is valid, and it turned out to be a real crash
on mm-new, not just a semantic inconsistency.

__list_lru_init() only checks mem_cgroup_kmem_disabled(), which
covers cgroup.memory=nokmem but not cgroup_disable=memory.  With the
controller disabled entirely, the lru stays memcg aware while
folio_memcg() is always NULL.

On mainline this is unreachable: the only caller of
folio_memcg_list_lru_alloc(), folio_memcg_alloc_deferred(), bails out
on mem_cgroup_disabled() first.  But the shmem unused-huge shrinker
conversion in mm-new ("mm: shmem: make unused huge shrinker memcg
aware") calls folio_memcg_list_lru_alloc() without such a guard, so
booting with cgroup_disable=memory and writing to a huge=always tmpfs
oopses immediately:

  BUG: unable to handle page fault for address: 0000000000000488
  RIP: 0010:folio_memcg_list_lru_alloc+0x41/0xf0
  Call Trace:
   shmem_get_folio_gfp+0x1cd/0x7c0
   shmem_write_begin+0x5d/0x100
   generic_perform_write+0x89/0x2a0
   shmem_file_write_iter+0x82/0x90
   vfs_write+0x256/0x410
   ksys_write+0x61/0xe0

The faulting address is the offset of mem_cgroup->kmemcg_id,
dereferenced on the NULL memcg in memcg_list_lru_allocated().

I've verified that checking mem_cgroup_disabled() in
__list_lru_init() fixes this: with the lru collapsed to plain
per-node lists, folio_memcg_list_lru_alloc() returns early, the
inode is queued on the per-node list with a NULL objcg (which the
shmem code and obj_cgroup_memcg() handle fine), and the shrinker
still reclaims via the global scan.  Same reproducer runs cleanly.

I'll send the fix as a follow-up patch shortly.  Since the
triggering commit is only in mm-new, no stable backport is needed;
it may make sense to keep it ahead of (or folded near) the shmem
series.

Thanks,
Qinyun Tan

