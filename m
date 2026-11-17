Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D748606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 03:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IFQyfyc4
Received: by kanga.kvack.org (Postfix)
	id 4443C6B05B4; Mon, 16 Nov 2026 22:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4D46B05B5; Mon, 16 Nov 2026 22:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3716B05B6; Mon, 16 Nov 2026 22:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0691F6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:13:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D71E16024F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:13:50 +0000 (UTC)
X-FDA: 85443141420.06.63FE6B7
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6DA16100005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:13:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IFQyfyc4;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794885228;
	b=mrETMIEg21hKq3HnaA7JH/pxiL0dRa05ZoULWSnCepV0D3ydZ/0gv2VihteYCMZ2Y8cOvw
	/6Wc9sURzbJ5hY4qWFBPyQgGPJDewLUwpEP/muE1+QcrMN14z/PrZevMXlWCCMknJE3Qr5
	mKRvPgGfkBX2qzjHpksFfWDp/DvUIfU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IFQyfyc4;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794885228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Henz0FrWmmxzwoavWH1AFferz9Sy4A9czKO41x1rhs=;
	b=qAm+NrBEaFbvu86RhfUmFd+Sso8CXnbI+fG0cY21Tt/zvOL6Vn1CS7Y+gjuvfiLkmGtVMw
	VoSq2HUvXEObhGvIvqKYWnIQAWFfbeXe+Us6lqB/xHvykeI/RB97xdY1qJg3EnMieJ4MOl
	nEtfvzncNxkMdAJSV6vDHs+e1Q+NFw0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R3QFMBD/atgM6V8xogzigzWPQmqYHpUv7HSFT3n7u58=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794885227; v=1; x=1795490027;
 b=IFQyfyc4sDt7Ud73LHiVUEWq8Soo68ERr2KoZoU8Z+GOwWqFBoogM3CuJBqsd+C9zbvckxb1
 qwZHNlPHTRN0PaLcr9XNOodg3JwOOM698v03nWbU2bWeMaGx6v6Q9fSTirWDIGKE2nZhJ5nAk/Q
 ohseESwX2PQGgp0XeoVeBxK4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bf6838e5dd8e88ed;
	Tue, 17 Nov 2026 03:13:46 +0000
X-Mizu-Trace-ID: bf6838e5dd8e88ed
X-Migadu-Flow: FLOW_OUT
Message-ID: <44fc03e4-a545-465b-a7f4-174be2038884@linux.dev>
Date: Tue, 17 Nov 2026 11:13:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/14] mm/mm_init: factor out common struct page
 initialization
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-5-songmuchun@bytedance.com>
 <179482576829.2379196.2091312590305150578.b4-review@b4>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179482576829.2379196.2091312590305150578.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k17ohb3brjchf76fohuup5kgb84456em
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6DA16100005
X-HE-Tag: 1794885228-793218
X-HE-Meta: U2FsdGVkX19KosbYf7No0ATSnoKxxoTZCr+rcG3tkrIJ/YitSHE1yIpAxUN6RqHsaHaFAU0kCQHAIOg+Nk/XNnYd5bCSB9wC187bHMbL5hhop3nIXgAv60Xu3QiWWqOMYzc1cddei/jTcpUgAPaTABHpdnWp2ILb3MLS5oMvcqn0/th80IMKh2hpSaV07frTK9vt/OkqTkWbPlwp2nBDHzefoITVl3O9q1nT/Bv4P/oSom0OE/EZIQYo7Nzv6yxRH92ONxhZfYQZVk0e2yNWeAkHshDsXxk8QJf6npAIXoD13BXmNwD4Qmcj6h32XGopeIiPg8fU5nzup5Nc5uEqzu8Z4CqxcS4VdPDY79OEDR3osbj/sR+4rX/IHMFZebhH3O+99NT6zoL1mkIRNZho92cz4Ml2PWLntqJ9CaZU3N5fRuQdZpx5jJd5ZGEdQTcfpdIaiqrJYrqtZDH8TEegzshuSeCngjEW5Q0mPMkH9a7UZC863BeU/EXNW+gL5lK3wkxh7l8deXnaU+CdK1+LYDKikLiPsxiTBDwGVMZEJadWJ8hpokIixbg3sy0gjtgKazER/IAmci+db3Tjot0HQ0FetnvvQmKSjB+vKMcWGA0w2C7sSIdoGDU9BbP+9hyUMUraUnRsrWt8PA+V8VblUgJbmmrc0970JL6cgjbrwNU0goxn32M4JoDK8p8XEG8MjVe/ODMA9McEG1voL278xmNgzKfZDo0Y4QOPl8o3X/I2fXQK9niU0wbMUhkvO3h1iVwL0wPLSb3PwVYnOhawRUinklGAslpUoJluZbWaVCzvvInFWtpE9NI1zGkPub0QzDV9hnQ9VqUdw7kY/8ZyzyfIrgCOpIqU6LP/uy7RlfuAoUK4owoWVwx/udhZVwfiMwrU1HvCYq39gmGUvEPhTCstjvKlliCRJ4m0W/Lsm6JavDU7rPEKGGm1iRdoN9/S2zZ3LnfNUoNRgBPpGkn
 s+1B7fDF
 SsmjA+Hh18QyevOxbfJESNK0Byd9UJB9Iwtfr0uhx+byhJcD1v+8f4yi+oJLC/sAMiHa9QNE+y2qiMGhfdutM7UhDrRcKB63xAjvsI28Ft1uMfPn2G9SwiCG5HIvAgQn1AA/2r/Ax4b7QoHEmukg/IFpGM6L2UpRLP+LZeKJqJx0rJmbzC2l3kdzVAWBrExwvMi/Ir2dzquBnyS9aEhuwIEa2R8bzdWCXeYNZZEOEuLAX5VUtEXOYcDWOg2y08r5IHKIW3ZR0Pw3N/bv9aZMUPbkTMrzK+sxoFQcM3G59HDEiU3Id1FehrQ6qvbWqlnCma/juOOU7OIGk5Aw4iLWRPxkbstmlSZhMqiUFc+ahaPQRDRbOcxXOxa6L5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/16 18:42, Mike Rapoport wrote:
> Hi,

Hi Mike,

>> Several struct page fields have the same initial values for every page in
>> a zone. __init_single_page() initializes this state as part of its
>> per-page setup, while the shared vmemmap tail path open-codes only a
>> subset.
>>
>> Factor the PFN-independent state into memmap_init_page_common() and use
>> it for both regular and shared tail struct pages. Keep section-, PFN-
>> and instance-specific initialization in __init_single_page().
>>
>> This also initializes the last cpupid and KASAN tag for shared tail
>> struct pages consistently with regular struct pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2:
>> - Remove __meminit from memmap_init_page_common() so HVO shared tail
>>    pages can call it after init text is freed (reported by Sashiko).
>> ---
>>   include/linux/mm.h  |  8 --------
>>   mm/mm_init.c        | 22 +++++++++++++++++-----
>>   mm/mm_init.h        |  1 +
>>   mm/sparse-vmemmap.c |  7 +------
>>   4 files changed, 19 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 77b5d450fe45b..2e182498898ec 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3022,14 +3022,6 @@ static inline void set_page_node(struct page *page, unsigned long node)
>>   	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
>>   }
>>   
>> -static inline void set_page_links(struct page *page, enum zone_type zone,
>> -	unsigned long node, unsigned long pfn)
>> -{
>> -	set_page_zone(page, zone);
>> -	set_page_node(page, node);
>> -	set_page_section_from_pfn(page, pfn);
>> -}
>> -
>>   /**
>>    * folio_nr_pages - The number of pages in the folio.
>>    * @folio: The folio.
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index af3b81733193b..d0a11989bd249 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -602,15 +602,27 @@ static inline void vmemmap_optimization_verify_zone(struct page *page)
>>   			page_zone_id(page));
>>   }
>>   
>> -void __meminit __init_single_page(struct page *page, unsigned long pfn,
>> -				unsigned long zone, int nid)
>> +/* Initialize PFN-independent fields common to pages in the same zone. */
>> +void memmap_init_page_common(struct page *page, enum zone_type zone, int nid)
> I don't think _common adds much here, memmap_init_page() would do.

Naming is difficult. I'm fine with memmap_init_page.

>
>>   {
>>   	mm_zero_struct_page(page);
>> -	set_page_links(page, zone, nid, pfn);
>> -	init_page_count(page);
>> -	atomic_set(&page->_mapcount, -1);
>> +	set_page_zone(page, zone);
>> +	set_page_node(page, nid);
>>   	page_cpupid_reset_last(page);
>>   	page_kasan_tag_reset(page);
>> +	atomic_set(&page->_mapcount, -1);
>> +#ifdef CONFIG_ZONE_DEVICE
>> +	if (zone == ZONE_DEVICE)
>> +		__SetPageReserved(page);
>> +#endif
> Can't we keep this in ZONE_DEVICE part?

We can. But I put it here because there are at least two places where
we need to mark a ZONE_DEVICE page as reserved. Handling it in
memmap_init_page_common is simpler — it reduces the number of places
where we have to set reserved individually. Otherwise, we would need
to explicitly set reserved in multiple places.

>
> If we can't, __init_single_page() sets PG_reserved for ZONE_DEVICE pages
> and the
>
> if (zone == ZONE_DEVICE)
> 	__SetPageReserved(page);
>
> in the MEMINIT_HOTPLUG part of memmap_init_range() becomes redundant.
>

Good catch. I think I could remove this redundancy next version if you
think handing it in memmap_init_page_common is okay.

Thanks,
Muchun

