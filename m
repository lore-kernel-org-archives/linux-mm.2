Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE85606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K4tdWnI7
Received: by kanga.kvack.org (Postfix)
	id C7ADC6B05BA; Mon, 23 Nov 2026 03:25:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B5C6B05BB; Mon, 23 Nov 2026 03:25:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1ADB6B05BC; Mon, 23 Nov 2026 03:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 872506B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:25:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0005FA84A6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:25:18 +0000 (UTC)
X-FDA: 85465699116.23.7D86F0A
Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	by imf25.hostedemail.com (Postfix) with ESMTP id E217BA000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:25:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4tdWnI7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795422317;
	b=cNn1Ip033KFfuAxUX09LC3Gu3Qu715HlqRClwo3+XbOohDsSxGz9w5z6ZYx35lZ91/inF1
	nr41w3ZRfDUdGBSSOQheTjOd0vQXWiNlFfs9aXZHckpU7b1kFV2p0PGG+yfuSjXAasTkSd
	/inaoZ/T7PJdziiLkmPgTymsUNqH61M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795422317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YkplbXySmaATV+c/q6e7xLQY22MT4Kz4HxoeelC/D0=;
	b=WuKyKmLmdxpz3P+0nYhyBANK+Q/v5wELdYo4eiVTMNRuPH1vW0eqt98f459Z5b3sgnIHok
	WBt89a04SHyWZxG/5GB0w2qT2oJso25mbkXQkUoL168/n6VD+MgeDcEJv5OxEYZFkPdpWu
	YOwc2NJ1gNtV/aB9kuoP3glnBXIqif0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4tdWnI7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.198 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l4Q+B3ckN95O70apojBJmX15Pn2GOJj1UkSRM7DYdlM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795422314; v=1; x=1796027114;
 b=K4tdWnI7VAaOpGFYykIOHfraLSZpvDCbo4InoudFv3P5AUuX3dru72rbEbJ6Bz6yqjUSV9jW
 jwFpqdz7hvbsQDEU5+IuJMhaTjjWKQKypul1pV3Gru5SAThd4I0mUmtXFvqga8+kBn79vbhYWg+
 VdqgRbudRCYd7k1p1/Azwttk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d3238756a42eef48;
	Mon, 23 Nov 2026 08:25:13 +0000
X-Mizu-Trace-ID: d3238756a42eef48
X-Migadu-Flow: FLOW_OUT
Message-ID: <c861d701-09f8-4fc1-a527-e4efd911ef5f@linux.dev>
Date: Mon, 23 Nov 2026 16:25:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] mm/mm_init: factor out common struct page
 initialization
To: Qi Zheng <qi.zheng@linux.dev>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-3-songmuchun@bytedance.com>
 <a3add5b9-a69e-4e06-b91c-c23db9b6e1ca@linux.dev>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <a3add5b9-a69e-4e06-b91c-c23db9b6e1ca@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E217BA000E
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-Stat-Signature: ss9ywtmz33poh6rzxamzo4q3eweh8nhr
X-HE-Tag: 1795422316-523320
X-HE-Meta: U2FsdGVkX1+zjTq+RClRKbpqEgdPhg/FogapEZ+QDhMEi4V9lyyzlp8ockjykYc5JySLdtFl3EHsjk1/L/sskWkDRxnUSjRKyZ1yA6BvF8sGa5vWR8fb/k4wNyn3Ju+ToCFPHw/PXJ6KOfdAUU/jPLMSkJXCwSPdI+hrnPJO2cQHsDTEHbSmELqZlVotL2EbzRkxmsdYaJ2Tgn4Y1Cqg4frs0QWD4CZxQooSHvjuXsryXD9bSq/D2FUY2YhRnSR+unCZME63YOdHmwgORS6R/mlCIjUojrBiLDK0EvjB9eXjEv/6xDaiRDen5uTl7tWahoik4Er68bKYoUnmTAAc4Kb2HzNj6NofaEOvkFa/7GzOQleGmv41xbDIWqpdRRIiW3LtIJ347iG9J58iUnxdCo9NwMIh5suq4Lw5xjUleseD0XU11fAkTuSmBdqnHiTC9ARBhCMrfWe31+CTJAikMOvBU12e21lGW0ltfIAzqYeRR4h9qfm5jOgmCeZxRGJT8n4N62GTcO+JFTSV4fAT/8bBYyk6YmM7zIpQWfe5EWzuxKo+w8N/4AF2mCrfWAnIjMmrbd9Z7jioNnqMwO01CD7Vr9Cgbji3eAn8ypc+dR6kMU8ou50CX0HEaBS3eCa8vd2gsbwhQHchS8WEb1jFekR2IRUOQjzNoPIA42xsjs+sy7XepwLeNmsnZKz3njVKYmCzMgUGx+1BHEdOU5Ug5BLcidz7ryQsSaSykrsEM2VD+dwnEVVn5Aq2/YnV2R0EeeuVCOvKxTMEUiBau/t8M61Kj11jy26u7n0NMi+3sekBVqPvC3pNZk1zFoWvOc4N8zOPjoqOX/OczZDvF4YefeXGvjuaeckkKxr3kcoSD8VfS05dBb4hXXFbDTKUlHeyRANSxH6aThtNI4U2NQuU7hqS6mqchlV/bqnp/IrITvOepbeQvGwb14xM5HyJ1/lsluGcdnzjaMwWP/0J5y2
 rDreUdDY
 M5F10LTcm8i3VSUoR8YhA1pI0ipkmEtObUlz/Bb+2YweG+6eghPW3Mor6TZfaGZfdMePsVctQXoVYGMTq4liR1STKPNhGwksfgJ86mRIWPRI41t2tjnTHmwO2ugtfj08mVKtFNbxPq7xq4qeVVoxHJjk+ck6/oqp3ZFrnjiGzfrpj7uRhHMMfip5NIV6GBoqmvhQxdTTK4Ps50mg2CmG4lezUD3t4+o4KjLPGLMmbt6qM9pish/sTJMuJNwUs4eciuDLKv1CthxV3xPo4VLDU876IJ+M3uRGBEagQrSELk6A+sbW3l8QNGAkxxXlffNQZYSjKWjbSgsilhc2R2PwWyJ1vBKFnSY2QfE9aAT+l6NpAyuutG4+4eR11O7VxqvMV4/dcA+mH7sh/8teTgw/3D01OassOMEWB1XGz3J/D/LqM/vyLJs0RQfSqWavUTAiFGXneT3igxVLK8MpV3McLg3yQiIQVAbE6iVdL1b+ivExdvujxDezPs7QcRpkVOS8ly9wDGIallvHCw8YmgmwBpckgXyoR7BVB0kuS1U3NpMHo+Q4LbrHT36KMvY4ly+Showj5tbATFOBjcoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/23 15:00, Qi Zheng wrote:
>
>
> On 11/20/26 6:08 PM, Muchun Song wrote:
>> Several struct page fields have the same initial values for every 
>> page in
>> a zone. __init_single_page() initializes this state as part of its
>> per-page setup, while the shared vmemmap tail path open-codes only a
>> subset.
>>
>> Factor the PFN-independent state into memmap_init_page() and use it for
>> both regular and shared tail struct pages. Keep section-, PFN- and
>> instance-specific initialization in __init_single_page().
>>
>> This also initializes the last cpupid and KASAN tag for shared tail
>> struct pages consistently with regular struct pages. Since
>> memmap_init_page() marks ZONE_DEVICE pages reserved, remove the 
>> redundant
>> update from the memory hotplug path.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v3:
>> - Rename memmap_init_page_common() to memmap_init_page() (suggested by
>>    Mike Rapoport)
>> - Remove redundant ZONE_DEVICE reserved-page initialization 
>> (suggested by
>>    Mike Rapoport)
>>
>> v2:
>> - Remove __meminit from memmap_init_page_common() so HVO shared tail
>>    pages can call it after init text is freed (reported by Sashiko).
>> ---
>>   include/linux/mm.h  |  8 --------
>>   mm/mm_init.c        | 37 +++++++++++++++++++++----------------
>>   mm/mm_init.h        |  1 +
>>   mm/sparse-vmemmap.c |  7 +------
>>   4 files changed, 23 insertions(+), 30 deletions(-)
>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks.

>
> One nit below.
>
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 8883b780b76d..d8bafcd92791 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3096,14 +3096,6 @@ static inline void set_page_node(struct page 
>> *page, unsigned long node)
>>       page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
>>   }
>>   -static inline void set_page_links(struct page *page, enum 
>> zone_type zone,
>> -    unsigned long node, unsigned long pfn)
>> -{
>> -    set_page_zone(page, zone);
>> -    set_page_node(page, node);
>> -    set_page_section_from_pfn(page, pfn);
>> -}
>> -
>>   /**
>>    * folio_nr_pages - The number of pages in the folio.
>>    * @folio: The folio.
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 0129152b74d8..08d6e47bde22 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -602,15 +602,27 @@ static inline void 
>> vmemmap_optimization_verify_zone(struct page *page)
>>               page_zone_id(page));
>>   }
>>   -void __meminit __init_single_page(struct page *page, unsigned long 
>> pfn,
>> -                unsigned long zone, int nid)
>> +/* Initialize PFN-independent fields common to pages in the same 
>> zone. */
>> +void memmap_init_page(struct page *page, enum zone_type zone, int nid)
>>   {
>>       mm_zero_struct_page(page);
>> -    set_page_links(page, zone, nid, pfn);
>> -    init_page_count(page);
>> -    atomic_set(&page->_mapcount, -1);
>> +    set_page_zone(page, zone);
>> +    set_page_node(page, nid);
>>       page_cpupid_reset_last(page);
>>       page_kasan_tag_reset(page);
>> +    atomic_set(&page->_mapcount, -1);
>> +#ifdef CONFIG_ZONE_DEVICE
>> +    if (zone == ZONE_DEVICE)
>> +        __SetPageReserved(page);
>> +#endif
>> +}
>> +
>> +void __meminit __init_single_page(struct page *page, unsigned long pfn,
>> +        unsigned long zone, int nid)
>
>                 ^ enum zone_type zone?

You are right. But actually, I didn't modify this line, this should be a Git
display issue. Otherwise, this patch will end up mixing in the declaration
changes for this function. I think the right approach is to submit a
separate patch later to handle this cleanup.

Thanks,
Muchun

>
>
> Thanks,
> Qi


