Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB43606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I8byLkeK
Received: by kanga.kvack.org (Postfix)
	id 0B6C46B05B7; Sun,  8 Nov 2026 21:57:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066C66B05B8; Sun,  8 Nov 2026 21:57:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B646B05B9; Sun,  8 Nov 2026 21:57:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3D476B05B7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:57:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 628131405A4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:57:41 +0000 (UTC)
X-FDA: 85414070322.12.60BD6D8
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf04.hostedemail.com (Postfix) with ESMTP id 595B340004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:57:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I8byLkeK;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193059;
	b=XnQ4Lmy1CzJnCP00C2+woJK88ocAXu7nJut4h7Fg6VvnUzEDUEiW0EPtPFpn5WOSOICWi8
	kmDH7/slKePClMO0/VHpifHuySUbyZteUiagEVff3RZNKnR+pT6ibEdni+8B/NQPunPyWq
	jP13JotNXDc1DG0QN/NjkDYCiHyZ55w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I8byLkeK;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwJNxf5rCTAUship/jh+E19aKDon5spv76HcuaGEvU0=;
	b=zoSAlBqpuf9NhbrKPo/J3uhM3DvA3uwVq3ygMEeO+MxsT6FhRQg47x0isviJgXRBMSnm7a
	+bRTV70LAhYK6nkCOHlv0dJgt0gX3wn9LO5qauafa67B2lSKCZ983lo5TAziLPbmmuW1iC
	813DPV+qhvA0KO8P3n6Y4oK4xqKNsxs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u5WrG/yasaWjBHktQ78tjm0ZVxb5BYE57NobquyrXQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794193058; v=1; x=1794797858;
 b=I8byLkeKV8e26R9x/axeTIC88d6JqAaJWmc2v1X3zNoSbxc5GzsqJ5RsezFM+BlRGgJzG/so
 naERNpQyMvNttHnnPVnld5pGPknHctfXbmAzh8w6NXRN6azXloAu2kOY+DQpKuSBiKw9EXbZrqx
 25E6X3fkyWY89AK0Y8bHRFfk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e5337828cc32e4d1;
	Mon, 09 Nov 2026 02:57:37 +0000
X-Mizu-Trace-ID: e5337828cc32e4d1
X-Migadu-Flow: FLOW_OUT
Message-ID: <f062d92e-a016-447f-926f-bd1b1ce7f106@linux.dev>
Date: Mon, 9 Nov 2026 10:57:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mm_init: factor out
 memmap_init_page_from_template()
To: Li Zhe <lizhe.67@bytedance.com>, Balbir Singh <balbirs@nvidia.com>
Cc: osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 rppt@kernel.org, apopple@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
 <20261105120615.16817-2-lizhe.67@bytedance.com> <au2tQaaMBg3umthq@parvat>
 <25a188bf-05e4-4f0e-b670-a9dc88195b21@bytedance.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <25a188bf-05e4-4f0e-b670-a9dc88195b21@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: skgt8r6hftmfijadmhhbcgw8sbt5dkrg
X-Rspamd-Queue-Id: 595B340004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794193059-13318
X-HE-Meta: U2FsdGVkX19QIWfp2PtDoAM1n4pNwRUHKMwzL/IpIsVcLjk20NoFJnZT8pvtIZG9cWquiOTK1Wz3zfZEX7o/80+c8Dng5E45O9lUwX3ArFlLaswY/PJb0dxs4J3+BV0g4FKhMaLfZb8qVVdzMUlL6YJf4QWU9QAL9Hn2qZpxiUpUHy6rXuPCj0N3q1efhm6XbpEapN0SEdd9BSgUAXLwsuqd/kqUTtpOcphtH+nHvInOJhhiNMU8SR0rHFFOgHA86OkuHzxJaLaNKTAcYCEwQScgQHEf0MCmzGkZT39O2YHwPVd9xjJhfvhY6hucJnEts439G2UzRgO+RgJTHCi40kv9gqSGRcXZPcvCeP4MhoJvaq8Pd6Inet19rygOtUKIYGKMYCxZ+Z8YKaUxzVtNq7OEEgP9D18QyE9+BvIurbuGZhYGIqi0Wpi2fGSxAxSbH0HB1cuzq+LNPlsQVS6WeEYKJHkKMSMw3FSha2JtRC9Q1hHp0oGx+Qte+SBXYc+rAALtQpicE4PFt0OHygSRoebj9Q4jBNZsqJ4BCQpvn1uKMcYVJjSI0Jlc/Vye299f+GRNqMYFmjYzPM1FFDAGkbB/PX+S7Uhsv3JVRjzr6NUSAQ83nPfpnIITcjeph/aLP8mK8gWLubg3SlFbgtzW8TtPELO/EAmye+v/cwbmSrsiLdp59JRNodDkRocAax9GkOsrKmE3dsu9WLulAd/1LK/chjvsErTjxxn6SLI0dBdkwsxi/cwO7lq5fe3uVDEMa8BuZM/lww6KVg+gUeNidVkVe6iH4IgS016FV+y6/sPLcuy7fkAFtjfEdLtdcS8lKF+JKW1nVLYpEryFYe/KCW9+UI44wh1nCUnCGhNpz/J2r2FBy9lLa9kGWiYF2+6TiYYeLTDvO04ynpOHe79kvUtA4ssIyNtCHx/tpqBVoBv+D40166GjikwESKbMq2vuRSCeoiSv6wX4ENsxr++
 jU0mhb4i
 WFpw9pGy9IAhqlJreoQdEG2N5HMGUWbPlwnSejLgEOG+1CRbFnbiD3OnO1Wap9KvYpoDjRcPh1HZ4YHi7Yy4lIQE8akXIrDdTSBuXoJu6M7VTTXFo5IxUEXv5eb6UoniR3PLpABBG+MibAJsGaaK3CXaxot5aK15J3xy8BxjGV5jzFSfzF7AvwvVdurWbWa+SLPvEALcSGO4i+Kh9r3VSDsUfezc9Heye+85zcsV/goq6QJzaI0Nd0WbBy1NIBnkIgRnnVzE/ElWEFoMbuonwlknYo34eE//VokeEuuvSdLzg8B6HjQXVBWJndbLKG0vtKvNe5lu4eCXVx38B61uCM7mbmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/9 10:51, Li Zhe wrote:
> On 11/6/26 6:34 PM, Balbir Singh wrote:
>> On Thu, Nov 05, 2026 at 08:06:14PM +0800, Li Zhe wrote:
>>> ZONE_DEVICE memmap initialization already uses a reusable struct page
>>> template when initializing compound tail pages.  The template mostly
>>> contains invariant state, but a few fields still depend on the target
>>> PFN and must be refreshed before copying the template into each
>>> destination struct page.
>>>
>>> Factor that operation into memmap_init_page_from_template() so other
>>> boot-time memmap initialization paths can reuse the same helper.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>>    mm/mm_init.c | 29 +++++++++++++++--------------
>>>    mm/mm_init.h |  2 ++
>>>    2 files changed, 17 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index 2a0e782a151d..495e20fbdec0 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -625,6 +625,17 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
>>>    	vmemmap_optimization_verify_zone(page);
>>>    }
>>>    
>>> +void __meminit memmap_init_page_from_template(struct page *page,
>>> +		unsigned long pfn, unsigned long zone, struct page *template)
>>> +{
>>> +	set_page_section_from_pfn(template, pfn);
>>> +#ifdef WANT_PAGE_VIRTUAL
>>> +	if (!is_highmem_idx(zone))
>>> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
>>> +#endif
>>> +	memcpy_nontemporal(page, template, sizeof(*page));
>>> +}
>>> +
>> Can we make the template a const? Why can't we do
>>
>> void __meminit memmap_init_page_from_template(struct page *page,
>> 		unsigned long pfn, unsigned long zone,
>> 		const struct page *template)
>> {
>> 	memcpy_nontemporal(page, template, sizeof(*page));
>>
>> 	set_page_section_from_pfn(page, pfn);
>> #ifdef WANT_PAGE_VIRTUAL
>> 	if (!is_highmem_idx(zone))
>> 		set_page_address(page, __va(pfn << PAGE_SHIFT));
>> #endif
>>
>> That way we don't update template once it is set, if template is r/o,
>> then we don't need both first page and template in the caller to
>> be different.

I used to think that too.

> I kept it this way to preserve the memcpy_nontemporal() write pattern:
> update the PFN-dependent fields in the template first, then copy the
> final state to the destination page once.
>
> If we copy first and then update the destination page, the hot loop
> would do a non-temporal copy followed by normal stores to the same
> struct page. That is the pattern this helper avoids.

After thinking it through, that should be the reason. To prevent
similar confusion for others, I suggest adding a comment here
explaining why this specific order is used.

Thanks.

>
> Thanks,
> Zhe
>>>    #ifdef CONFIG_NUMA
>>>    /*
>>>     * During memory init memblocks map pfns to nids. The search is expensive and
>>> @@ -1073,17 +1084,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>>    	}
>>>    }
>>>    
>>> -static void zone_device_page_init_from_template(struct page *page,
>>> -		unsigned long pfn, struct page *template)
>>> -{
>>> -	set_page_section_from_pfn(template, pfn);
>>> -#ifdef WANT_PAGE_VIRTUAL
>>> -	if (!is_highmem_idx(ZONE_DEVICE))
>>> -		set_page_address(template, __va(pfn << PAGE_SHIFT));
>>> -#endif
>>> -	memcpy_nontemporal(page, template, sizeof(*page));
>>> -}
>>> -
>>>    /*
>>>     * With compound page geometry and when struct pages are stored in ram most
>>>     * tail pages are reused. Consequently, the amount of unique struct pages to
>>> @@ -1136,8 +1136,8 @@ static void __ref memmap_init_compound(struct page *head,
>>>    
>>>    	/* Initialize the remaining tail pages from template. */
>>>    	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
>>> -		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
>>> -						    &template);
>>> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
>>> +					       ZONE_DEVICE, &template);
>>>    	prep_compound_head(head, order);
>>>    }
>>>    
>>> @@ -1192,7 +1192,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>>    	for (; pfn < end_pfn; pfn += pfns_per_compound) {
>>>    		page = pfn_to_page(pfn);
>>>    
>>> -		zone_device_page_init_from_template(page, pfn, &template);
>>> +		memmap_init_page_from_template(page, pfn, ZONE_DEVICE,
>>> +					       &template);
>>>    
>>>    		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>>>    			cond_resched();
>>> diff --git a/mm/mm_init.h b/mm/mm_init.h
>>> index 0034e37dbabd..22c465122b47 100644
>>> --- a/mm/mm_init.h
>>> +++ b/mm/mm_init.h
>>> @@ -111,5 +111,7 @@ void memblock_free_all(void);
>>>    
>>>    void __meminit __init_single_page(struct page *page, unsigned long pfn,
>>>    				unsigned long zone, int nid);
>>> +void __meminit memmap_init_page_from_template(struct page *page,
>>> +		unsigned long pfn, unsigned long zone, struct page *template);
>>>    
>>>    #endif /* __MM_MM_INIT_H */
>>> -- 
>> Balbir


