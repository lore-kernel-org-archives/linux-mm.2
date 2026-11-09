Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CA7606A320
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=KxyNBXOr
Received: by kanga.kvack.org (Postfix)
	id F04BD6B05B1; Sun,  8 Nov 2026 21:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC7D6B05B2; Sun,  8 Nov 2026 21:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF23B6B05B3; Sun,  8 Nov 2026 21:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB6156B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:52:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 508D1805B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:52:20 +0000 (UTC)
X-FDA: 85414056840.29.6590675
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A89B140006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:52:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KxyNBXOr;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794192738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCuez44DIiflK+TgYYvbZf169TnqdyWBhAx5pU0vziY=;
	b=gTeqqUBgBNmE9S9zXAD1L3zdSMQNzwTscSYw4R5lfCaBZ7NvVoNyMLoUP2GeIVi2P4fssp
	DpXwioN2ma9Yu2YHX11SPqTg2Vlb8ljyhIWiYU+WBi/yCrJZ5ktAuZg0GS1rPrBH3Lw2IS
	cwdgFXCtndxzGZDJpU7+3RMk8KVH9hg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794192738;
	b=4SjaWHehrqC0cKWOQlmFO1qCkq1MR9YeRELujH634hP0h/qRXvsAjiMb47yw/8obPS78dq
	7NLBYHS3VP8d1ALn+o2iGg1nFieX9CiIKbwSyiOqRrg0+6CtpjHRPWTY1CovdPWh1ABJa4
	7V6rfGr8sHuGoub4+0WbRDHwgcRyFCg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KxyNBXOr;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794192730; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=yCuez44DIiflK+TgYYvbZf169TnqdyWBhAx5pU0vziY=;
 b=KxyNBXOr2WX+/CCiYXTtCYnYklFW1pXMkg0Soddx2vt2uFSbwwoid1xH80xzBzbNaVmNET
 N2JgyDtddaT54CD+S9WoCnsGUv0jb32pKmQD/xskzNSnVrJNvFcJot6ml2WsRCDdA4rqvp
 zmHioFqb2X1+YDZ8AX787x3oZMdhtWgbB081svwSL8YA9V2EoywRJ2lepwVUVLGCZhL6Ts
 ufxQ4zi47HLD+lthy5VmxDNOkKRXQsZlnSv6Pp4ovdH7hjhXYuqVjWBBBAH7m0rGeQNOzJ
 ZBuh/HQszSBTzyUERX/KtS88cxiPlfjaKS858ZLvmR/auaRSukt8cHGKUVNk3w==
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
References: <20261105120615.16817-1-lizhe.67@bytedance.com> <20261105120615.16817-2-lizhe.67@bytedance.com> <au2tQaaMBg3umthq@parvat>
X-Lms-Return-Path: <lba+26af13558+3b27c5+kvack.org+lizhe.67@bytedance.com>
To: "Balbir Singh" <balbirs@nvidia.com>
Date: Mon, 9 Nov 2026 10:51:52 +0800
Message-Id: <25a188bf-05e4-4f0e-b670-a9dc88195b21@bytedance.com>
Subject: Re: [PATCH 1/2] mm/mm_init: factor out memmap_init_page_from_template()
User-Agent: Mozilla Thunderbird
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <apopple@nvidia.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <au2tQaaMBg3umthq@parvat>
X-Stat-Signature: ouckyk4myt3xakq34uyq9n9cgp8gt5sc
X-Rspamd-Queue-Id: 0A89B140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794192737-496468
X-HE-Meta: U2FsdGVkX1+gRRKTgk+TTjwBsD0W0mulIly4GWraY/1etz7wEqNqrssn26vQXpPYObiniABgm2DYAVg9AAkelYeKY31p7xxQL+z6HBfm+0Nezntx+WPkCRnTH3reBNNZiGPYNg4BE4CGL83v4rerV3dUHMRAjSn6IB1Ajjsow9lZVBMjONCTHTuJ93UJJIalsVFzOKTiilj6Buqh7htH9yLCffi27rFjls8iAoUOBT5+pf1Z2R7g7OdoPZMdCW56YUUTC4m9IZXwKj/BHJ2K+zKd0mXXil4ZPDUjdEHKcjE5QkfXB4BYWb43/hA9V+OcP7oB1Mfr2guzAdictSz/tZuzbsM0Lg4FNMwJACYGFaUXhE8l4w5eM80Z8qaTwvjTc0cardwnouqxMfgSBFonFKMlWm6EKATlQgeqd/jGareqkxSWNPWbd13tPFp4dK9ZH0F03n62qcYd5vMN1/grk/eE6Ex13j7PAYXAfcWggIPUmzH+W634YifwMUIuLhVrVabI55PMbc9tPiCVADo0VnfwjiNX3bms2/vGIawCBXEPZUj72Q7JJ26ieM4/UfbBse2DqXVQQXYtcojD2NrSHhSKYprzFEx2+LtVntbCp3pS0qWJ/+c1co/f0ezg1BspUMvoGgunUmDddO8RuRLoSw0N6vpVbVs4noZKcK1bX0K0+3rGSdn7Sy18vxbHHreUzujKyYSxVW/dYyxOJAzeqohnfSv7MXUFjvblPQ+WgH5PoG6ihWQBqePQTdzmM6/HdoKb4bgvnvFcM/viacNJtvNwo0HMYZoQletptkjp75BP1c8jkXwGRn7bZcQUV5K35VqovabAo77IysEJUVmQZ4rdX2aq1OcnDPqioTmAhDmaDa1bGgwuhTGa0eJdTsEkcDM84i8MbBvWzBvQo0QGpLrqPQYtlptOyB6HXt10uCAA1M+rWZAOCIqIF0c/nNnW2f0S/TNyWQfOItf+jC5
 MLgvLS5d
 X58PKn/TQZj905fJvSrvQzVcTaQLTn6/4vlTq0ZlZ85wVmpn6EuOUzeFOrbhC5BsLfR3nswZDR97pNS7kF6OC/n/4S5GtLgvmbH6KTUGtcC6mesDYBwtEgei/CMydI3KwfNF6G7+V9MYxurfz1RN7MZDPh8+M2hLq4NtjS7kanmB4l5sgKgFffqo67BV2ncpkTYpIzWnCOC9ngRsqry4saofOgMzWdwlSjKIEKXM5Dfni4jDZE4AAM/JZmfu4zq1fcM4TS6NyVh4XS7MQ0aCjuiaGMSgzruzA256Rk4zPG02ejFp+/DDuVjbChRlHDzqUTXUc2wMLil6gRv2edZc96hNjWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 6:34 PM, Balbir Singh wrote:
> On Thu, Nov 05, 2026 at 08:06:14PM +0800, Li Zhe wrote:
>> ZONE_DEVICE memmap initialization already uses a reusable struct page
>> template when initializing compound tail pages.  The template mostly
>> contains invariant state, but a few fields still depend on the target
>> PFN and must be refreshed before copying the template into each
>> destination struct page.
>>
>> Factor that operation into memmap_init_page_from_template() so other
>> boot-time memmap initialization paths can reuse the same helper.
>>
>> No functional change intended.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   mm/mm_init.c | 29 +++++++++++++++--------------
>>   mm/mm_init.h |  2 ++
>>   2 files changed, 17 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 2a0e782a151d..495e20fbdec0 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -625,6 +625,17 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
>>   	vmemmap_optimization_verify_zone(page);
>>   }
>>   
>> +void __meminit memmap_init_page_from_template(struct page *page,
>> +		unsigned long pfn, unsigned long zone, struct page *template)
>> +{
>> +	set_page_section_from_pfn(template, pfn);
>> +#ifdef WANT_PAGE_VIRTUAL
>> +	if (!is_highmem_idx(zone))
>> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
>> +#endif
>> +	memcpy_nontemporal(page, template, sizeof(*page));
>> +}
>> +
> Can we make the template a const? Why can't we do
>
> void __meminit memmap_init_page_from_template(struct page *page,
> 		unsigned long pfn, unsigned long zone,
> 		const struct page *template)
> {
> 	memcpy_nontemporal(page, template, sizeof(*page));
>
> 	set_page_section_from_pfn(page, pfn);
> #ifdef WANT_PAGE_VIRTUAL
> 	if (!is_highmem_idx(zone))
> 		set_page_address(page, __va(pfn << PAGE_SHIFT));
> #endif
>
> That way we don't update template once it is set, if template is r/o,
> then we don't need both first page and template in the caller to
> be different.
I kept it this way to preserve the memcpy_nontemporal() write pattern:
update the PFN-dependent fields in the template first, then copy the
final state to the destination page once.

If we copy first and then update the destination page, the hot loop
would do a non-temporal copy followed by normal stores to the same
struct page. That is the pattern this helper avoids.

Thanks,
Zhe
>
>>   #ifdef CONFIG_NUMA
>>   /*
>>    * During memory init memblocks map pfns to nids. The search is expensive and
>> @@ -1073,17 +1084,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>>   	}
>>   }
>>   
>> -static void zone_device_page_init_from_template(struct page *page,
>> -		unsigned long pfn, struct page *template)
>> -{
>> -	set_page_section_from_pfn(template, pfn);
>> -#ifdef WANT_PAGE_VIRTUAL
>> -	if (!is_highmem_idx(ZONE_DEVICE))
>> -		set_page_address(template, __va(pfn << PAGE_SHIFT));
>> -#endif
>> -	memcpy_nontemporal(page, template, sizeof(*page));
>> -}
>> -
>>   /*
>>    * With compound page geometry and when struct pages are stored in ram most
>>    * tail pages are reused. Consequently, the amount of unique struct pages to
>> @@ -1136,8 +1136,8 @@ static void __ref memmap_init_compound(struct page *head,
>>   
>>   	/* Initialize the remaining tail pages from template. */
>>   	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
>> -		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
>> -						    &template);
>> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
>> +					       ZONE_DEVICE, &template);
>>   	prep_compound_head(head, order);
>>   }
>>   
>> @@ -1192,7 +1192,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>>   	for (; pfn < end_pfn; pfn += pfns_per_compound) {
>>   		page = pfn_to_page(pfn);
>>   
>> -		zone_device_page_init_from_template(page, pfn, &template);
>> +		memmap_init_page_from_template(page, pfn, ZONE_DEVICE,
>> +					       &template);
>>   
>>   		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>>   			cond_resched();
>> diff --git a/mm/mm_init.h b/mm/mm_init.h
>> index 0034e37dbabd..22c465122b47 100644
>> --- a/mm/mm_init.h
>> +++ b/mm/mm_init.h
>> @@ -111,5 +111,7 @@ void memblock_free_all(void);
>>   
>>   void __meminit __init_single_page(struct page *page, unsigned long pfn,
>>   				unsigned long zone, int nid);
>> +void __meminit memmap_init_page_from_template(struct page *page,
>> +		unsigned long pfn, unsigned long zone, struct page *template);
>>   
>>   #endif /* __MM_MM_INIT_H */
>> -- 
>
> Balbir

