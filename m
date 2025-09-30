Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B85CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3D68E0028; Tue, 30 Sep 2025 02:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ABD78E0002; Tue, 30 Sep 2025 02:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1B28E0028; Tue, 30 Sep 2025 02:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD168E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:51:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F150C11A79A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:51:43 +0000 (UTC)
X-FDA: 83944996086.28.28C08D0
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id F35E8180005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:51:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RcLHUDPa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759215102; a=rsa-sha256;
	cv=none;
	b=g80AtC8jjVCmzNg8BUix/6VuEGtGA64JCFhFPuwufs4IqCTtNq8EFW4HV9np6PZA53u1tx
	HiczSisOTMI7VLWz6X41OJQHB2Pe3L24VsokjPhhlg85s5dX2JLg11irPgkMTPFH1efhTi
	HGm/decjbE7ftrmv1p3+aCcmWC7tnOE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RcLHUDPa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759215102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGN6BMSkXgx6PB6NEFYkeWWUVlKsILAVHZBwRtmuzRI=;
	b=Mg8h72GzkyRhrHBCI+xWTQseX3BgrCtv4dqNdCMuI4g6CnnxWpCS0zIzVC1Ih3qKyW8+n+
	4jiHuA1+7+B0zZbJBjrPSwBCHvSvHLD+08iZQnuD7+ubgNqQ0i2/I1nGVjfBQqnydsEKu1
	flWK2OzlKPuYeev7YnpLGxO5ImyLiIE=
Message-ID: <2ad95cd2-3a09-4873-b6c4-1e00a88dceb7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759215099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yGN6BMSkXgx6PB6NEFYkeWWUVlKsILAVHZBwRtmuzRI=;
	b=RcLHUDPak47T8AShrEH2BQNBqjOkZVnsG6DDUI6CgHbkDdkuF/qi+GBb1hVpjXJOcJs5tI
	xqTja3a64qobHcaFO05TFcvfPnaKyOLYen9dXJTqom6mF4e0ZJK5KGMDeLEpv6UJRpFGye
	CckGYTS2op4N2qbq6P99hGEv6fuQY/o=
Date: Tue, 30 Sep 2025 14:51:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
 npache@redhat.com, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, usamaarif642@gmail.com, yuzhao@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <20250930060557.85133-1-lance.yang@linux.dev>
 <026a2673-8195-4927-8cde-f7517b601125@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <026a2673-8195-4927-8cde-f7517b601125@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F35E8180005
X-Stat-Signature: fmc3x6w1fhdjayiqcdcoroty3z1f3ues
X-Rspam-User: 
X-HE-Tag: 1759215101-202222
X-HE-Meta: U2FsdGVkX1/GedIit/tJ97Q3VnIeKhUC+SH4wkQdJODna/ql2WIxrHSznXiyD/91rz0OLVchqBFmyiTgKgBUgh+fUSC34YEb5aSjIOZO3urNsxMFF039Ah9HFdbspwGap+WDgKBsEPMLuY5xGCSH2D0RdSOEUVjuZs2qLBbrMUs0HLQxSRfeJ2jNq/BrOHcLwduTTNZrFrB5hzkj6RrVP2mZ1OKSu2yr55on2NKm7aa4M/RD7U2y/F+41sIfG9uDjh4kl2tN5CbeW2NAJHHAEaM9Xp4ODh6MtdRckQ1M60D00+QhqS7PyymmSrpWWOU/5+OPOUtHr2P2m1mmCmQA4Z5SxSG5ThIVLtV8f+yhD4ga+HGtnnG4Equ0+ed4gHTGbvVHcyR9M53+WkX0u/j2/DWfENqmM5nQIWrtWk/nN8mj6vzAnDFQGYzcJwgzgG63v1yHiRih5BLbQNelRaORaROSnxQTu+1oFQv3Vkmh11kgu3OQ+HbvCaLd625fWSZZPLwarK0PKsJaV3T3RJ2wbxp+qz8WZSaMohRcbApd4iljpsvVw+Va6M8ekbjjCWN1+n3yNGSLLi/p2tuJ7L1CGYzSfD9P0vYc7G2f9QdyjLFh+Lf+GDzPxrnj8kcoh5TT8PNqvxXmZWgehGy+KdfmPqE68LLe/oC0p15CAUhft0K7wH1PKykC/rXrCOWAu/T/gkBwlVmvTZbNrPu6BLKLYjGPDPBl8DJMTZVzAdvC5eWlSnkQwSdqfM4Zg6l1ocKwBOV1/5ZeVjiFE/EySaB/8/Wf52jX6hdFid76v63oBvv9BL0lCnV6Lryhc7pVBKGrjyLmxfvzyK3yWj18yToDqECQ6fs0hSjzNvBfpfeYOTG6mJ2sStriINQz7ONWppWiwLKZGq39ddeQMSJjSpSjZ/uxm5PfId5Ml3Bw85L75fiuzMZluwYLOpz8grHHM0X8NG4EDij8n77UIUuVEXy
 ndWKnhRe
 uySoYG3XDjV3MAxw0/Szv66ekeDfsf4cmyyaF7b2c4QVW/Qz4hRLBHpKyO97c3d2CagvZC6/AdfwG1mJL/kfPXGTBfQQZEV+F2pVLyrWXCv1Apu6gS+GeulbjVVN7JAWDoXY67OKicxuFNo49WX+QTb3kYDFRyCF5vyi1rT16kBc5NVHJRfNRMow044MtMUaNWBGZGEYjHrsHbpDBmofZ68IYZyek/LgOFL2fNqZzDyUv7h1wHjrUCAHzZg2XHAySasREGTLVQR48YtKCecLRCZJ8L2u4VBKQ1kQzfkkdV4QVJCJZU6c3Dvh0lL8JLV9sfA2jyqwDPXk6Bg0YdSuWAIuOZrt2Xtq6huez5IdBin5/DurnlZNhWgCbPH1dJLOIQsSK7bypmUKbLGyA3hEBIZrYmJkbQUk0lVUx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 14:31, David Hildenbrand wrote:
> On 30.09.25 08:05, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When splitting an mTHP and replacing a zero-filled subpage with the 
>> shared
>> zeropage, try_to_map_unused_to_zeropage() currently drops several 
>> important
>> PTE bits.
>>
>> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
>> incremental snapshots, losing the soft-dirty bit means modified pages are
>> missed, leading to inconsistent memory state after restore.
>>
>> As pointed out by David, the more critical uffd-wp bit is also dropped.
>> This breaks the userfaultfd write-protection mechanism, causing writes
>> to be silently missed by monitoring applications, which can lead to data
>> corruption.
>>
>> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
>> creating the new zeropage mapping to ensure they are correctly tracked.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>> when splitting isolated thp")
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v2 -> v3:
>>   - ptep_get() gets called only once per iteration (per Dev)
>>   - https://lore.kernel.org/linux-mm/20250930043351.34927-1- 
>> lance.yang@linux.dev/
>>
>> v1 -> v2:
>>   - Avoid calling ptep_get() multiple times (per Dev)
>>   - Double-check the uffd-wp bit (per David)
>>   - Collect Acked-by from David - thanks!
>>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1- 
>> lance.yang@linux.dev/
>>
>>   mm/migrate.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ce83c2c3c287..bafd8cb3bebe 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -297,6 +297,7 @@ bool isolate_folio_to_list(struct folio *folio, 
>> struct list_head *list)
>>   static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>                         struct folio *folio,
>> +                      pte_t old_pte,
>>                         unsigned long idx)
> 
> Nit:
> 
> static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk 
> *pvmw,
>          struct folio *folio, pte_t old_pte, unsigned long idx)

Well, let me clean that up ;p

> 
> LGTM, Thanks!

Cheers!


