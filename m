Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C1E606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m9CHwZ5n
Received: by kanga.kvack.org (Postfix)
	id 342336B05B2; Mon, 23 Nov 2026 03:15:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319076B05B3; Mon, 23 Nov 2026 03:15:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2559E6B05B8; Mon, 23 Nov 2026 03:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04C706B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:15:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90546A0865
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:15:58 +0000 (UTC)
X-FDA: 85465675596.23.CE76D64
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	by imf23.hostedemail.com (Postfix) with ESMTP id 55CB2140005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:15:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m9CHwZ5n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421756;
	b=ogcc4l/MBXZ32YXVsxNUB9VAZka3bK5HMP8f7mH2Z2bp6KrcxhVzj4W0pJUDi05lws32mN
	uWwWbqC57RooicbeZoMglcOWFghF26f0LqhTN170ZsjAijtbyws3TrwZoEdbvjKCNYmMWS
	30LADmh6xgVZIgErHO3MZh4rTBdJDFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8ePjRGfYYLpqjroOmKpsQeQavrsi3h/4Ejiryunluo=;
	b=tNLyRQqlPa+OzsCLn6I1etW7aydXrjWGqak+0AWwlJPKPDWjspU6LCOFFR8m8+eAH4xksK
	jcG4S+RaUM/MjZpciDWcxgRtDHLz/aWqMeXOB4IeHUWK92M5xqeQ25DrjBmUEByW6qeURy
	UEYngIWqfPU5DIvHoKo3alp3MX0s/+s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m9CHwZ5n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nb6PRjiri+b9vY92PXaXr/1F1lf0xUZy2r1/mAPDNz4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795421754; v=1; x=1796026554;
 b=m9CHwZ5nJEfDr91H0pyk4z0d9pEy+GuGQGq8mR/ehouqsIEM12/M8kf0ozZDnw717bDoC/jV
 uCWoFSUsqaLXdQH7On3rv/s4F+h5XgVngROdd2WojXE35QZkD26Kd8OwoFXLvDWWTyK2+ExfKds
 9hLtnq1A/BcqFIeztXH1acK0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2427a9aaeab9286b;
	Mon, 23 Nov 2026 08:15:50 +0000
X-Mizu-Trace-ID: 2427a9aaeab9286b
X-Migadu-Flow: FLOW_OUT
Message-ID: <10263c9e-2d58-4149-a3c4-df9cac11b041@linux.dev>
Date: Mon, 23 Nov 2026 16:15:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] mm/mm_init: verify zones for
 template-initialized pages
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
 <20261120100856.16929-2-songmuchun@bytedance.com>
 <240018e0-02c1-401a-a979-3f867526191d@linux.dev>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <240018e0-02c1-401a-a979-3f867526191d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55CB2140005
X-Rspam-User:
X-Stat-Signature: m965zwcin84fjstsdqhpzjg6nf44fswh
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795421756-676033
X-HE-Meta: U2FsdGVkX1+sazZgREK9zQNTx+CwfRqBPHs8NLoKSZ7ZHaKmaLK9eop3kZ0dUnVXCuFWZvRaseCMi5XdPiHV0MsJ4lPWGMLJU53l9Zekhcjcm5DFTQGnK0r2wUALWzlLz6p6iZB84h2jS6e2EVx4MUX/3rFRK5oLwGDEY2v/HK3HFFsJuRBD9bNN4ieFHexzksrHPL691Uu9suPYC8zWMBGhnMYY63+h/r76jTeyZ+JkHehx8JTFqeCMZjnwNqI3wi7NKa3XDhaSEDV/b1kO4dhEY2ltiNyf/1ivHs0t1anpV+UwQiYLzJ7iz6VE7HTbGE6YQ81zTqJwsrOSWw5NqGbtp9rkFGDKoDnZyIXC5AgNqDjKPhJVL0ViPMqk5BgLwqOzPqWc4qz76YS9GVcnVFgVrhDw8CFSpif/MPgQ//2KXddcPq4116b9mDcxi/r8Mbn+jWRClsAD5hH2/GcWAi72jKAc7TSXgHwGe59MOpwFvUu6RSvHqsXTeuhXKI3POSIScdz/UEpNWzBwE9g9Wo6tqr3rxstPePqywIBsNk3jsZFju1z21t9EeuZyXQX+DhLe01daBQ5sdI7DZQt9jJ1cDO+ShG120EpmjJuL6/FLwTRWW6SPhKXTsAclMorxfkqskeZ+fL/aEiU7rUx0QA9kYQcBdEH0DEexoO8H3/oH2h1VVMA6SQ0uxIjgmPqBIOG+ORKApzUafK6fQj0R0H1I9QL38z+pRahSTS09KI/b9nmz88Pd6tXZ3xymIaIIrRpn03el28h7VVUTRdLy/dVmYxetheg7Lr4kdwQUD4OrQQmMZ/OKEepIwlvOA15Hm409Cgl7hl849v9xxLQQ58bHRgPUau4et6f8Z/vDJKJhvjQ0/TV+u+Yr1Fm4vhTzn15EfePhMaOKKQ/ZRIUQvwdznEu3fuf4TgofeoFhjlx0VK5rfR/i//VtdO2pOrQkZl00EkzHYX1klrTiLrf
 c1UQTXJT
 tWYBvRulLqrQzRxsoaJnAXed4Cl6X5YjDUmsY0g3g+/MXqAbeA+5M+ciJDF4op0UYOEEKgvhZxlog8vkvfBmnHHmmRpAPOTQSQBSoJOxhPhYUvT5d7P9hALITovDfRIm7aMtJqCv77pwAwPdX1LQoCiG96w4nYC8rerDQCKsOkuOrBNDN+Vkehpzv9Lt9BxITRIRVJWrSutcKDH1HYTHcnhuuacoW9B2Yy2iH8Jzt+2/J5s6Rv1iMp1/85GhaLlQbLAcIhIAkuatDB93bElmh/CSp2UILshLEJTlHqVPhBYnutqBnO6JFzhYeEnB5G9E+Gw3VJtbC3nhmHamPouGAJtu+iEO+Kozia0eundLbdHMt9CKIwwZeQBoHoz5kErc43V0FzUMM0JUFLdFwJ+3h1fGjkc3qG1SISESJsEUxzT3bubwec2v5noQuigkcNZJVAzRoSZH1Bms3FByqdp+30tRhB1gwNNzjukxxBg+uKOWLfYK0OnRGAPtF/z8LXtZONE5M2ZOH9vRMnPnwl0+nJW4Lqtx3w52amNh7pwOi3V0F3I96NPwBWx+GtmNQgZUBH0rCIBHILhd3+NRDZKMPev5CmAV7YvpDwX71
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/23 14:39, Qi Zheng wrote:
> Hi Muchun,
>
> On 11/20/26 6:08 PM, Muchun Song wrote:
>> Template-based ZONE_DEVICE initialization bypasses
>> __init_single_page(), which means copied struct pages do not run the
>> vmemmap zone consistency check.
>>
>> Verify each destination after copying the template so the fast path gets
>> the same validation as regular page initialization.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v3:
>> - Retarget zone verification to
>>    zone_device_page_init_from_template() after integrating the helper
>>    series (suggested by Mike Rapoport)
>> - Collect Reviewed-by from Lance Yang
>>
>> v2:
>> - Apply the zone verification in memmap_init_page_from_template().
>> - Collect Reviewed-by from Mike Rapoport.
>> ---
>>   mm/mm_init.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index a9d848c92678..0129152b74d8 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1082,6 +1082,7 @@ static void 
>> zone_device_page_init_from_template(struct page *page,
>>           set_page_address(template, __va(pfn << PAGE_SHIFT));
>>   #endif
>>       memcpy_nontemporal(page, template, sizeof(*page));
>> +    vmemmap_optimization_verify_zone(page);
>
> For PAGE_SIZE-aligned devdax, dev_dax_probe() leaves
> pgmap->vmemmap_shift at zero. When section_activate() populates a full
> section for this pgmap, it records compound_page_order = 0.
>
>   memmap_init_zone_device() (pfns_per_compound == 1)
>     -> zone_device_page_init_from_template() (each template copy)
>       -> vmemmap_optimization_verify_zone()
>         -> pfn_to_section_compound_order(page_to_pfn(page)) returns 0
>         -> vmemmap_optimizable_order(0) returns false
>
> With CONFIG_DEBUG_VM and CONFIG_VMEMMAP_OPTIMIZATION enabled, the
> section-order lookup runs for each copy. The zero order makes the
> condition short-circuit before either page_zone_id() call.

You are right, but we really don't care about the performance of a
debug kernel.

memmap_init_page_from_template is used to init a single page, just
like __init_single_page does. Therefore, in a sense, the template
version should be handled the same way.

So, what do you think?

Thanks,
Muchun

>
> Once patch #4 splits out the base-page loop, could we put this check in
> the compound tail-copy loop? Like the following:
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -734,7 +734,6 @@ static void __meminit 
> memmap_init_page_from_template(struct page *page,
>          memcpy_nontemporal(page, template, sizeof(*page));
>      else
>          memcpy(page, template, sizeof(*page));
> -    vmemmap_optimization_verify_zone(page);
>  }
>
>  void __meminit memmap_init_compound_page(struct page *head, unsigned 
> long pfn,
> @@ -754,8 +753,10 @@ void __meminit memmap_init_compound_page(struct 
> page *head, unsigned long pfn,
>      if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
>          nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
>      /* Initialize the tail pages from PFN-independent template page. */
> -    for (unsigned long i = 1; i < nr_pages; i++)
> +    for (unsigned long i = 1; i < nr_pages; i++) {
>          memmap_init_page_from_template(head + i, pfn + i, zone, 
> &template);
> +        vmemmap_optimization_verify_zone(head + i);
> +    }
>      prep_compound_head(head, order);
>
>      pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,
>
> Thanks,
> Qi
>
>>   }
>>     /*
>


