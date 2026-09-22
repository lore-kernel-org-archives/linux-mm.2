Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A35C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED976B00A2; Tue, 22 Sep 2026 07:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5DB6B00A4; Tue, 22 Sep 2026 07:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCB26B00A5; Tue, 22 Sep 2026 07:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBF836B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:34:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC50DA0471
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:34:41 +0000 (UTC)
X-FDA: 85241190762.17.F2D1023
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D45880009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:34:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iszbwzU8;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790076880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+DYFUAECSNtX1wNQ7IinAiwAu6YjDlxAqYAsmi/u54=;
	b=NdLT3lpTtzJhT/6qCMojN76BWTQ4RwF7GkmfZfpkfPYtetypf7Jop9QvfbKrajbGwHT1Hv
	5imZ6g3CMCLbIc2TYz+yWRg+ecj/7S6hjCo87Pc7QOS8jOgyb/wC4B/lOHMRfhg5cOjkWx
	JP27liRQ9cCedFARoJzKMpS0/KRk+mg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iszbwzU8;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790076880;
	b=jTuXVZY/aFRZ4PLnQPHqUEX/D5OgT3nj/VYnvn96e0rEBcPnMRDsI4cbUD0KuOUB2wxLVb
	FxA5jhtXOJKqOMkbcmkhnRk/4vay7pYayYhb6EDloovVIcz56Op+iQxMFKkhOEqCqKKppN
	f5CmRSGouGPtRDzfM148HCM6i8ytdJE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NN747W62S3d/5Yjf441AnlRml7ayVS4UCAQNtupGVWY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790076874; v=1; x=1790681674;
 b=iszbwzU8dZcsypAXPI3zPdjeKIPiMr10POceGbHGsf/NitbJtDrA4jvc15WwpjpVFzBU30xy
 DzaucNqCt5UsnmWLhkLZN6zcUaaZCrf4J3JqUXnGs9so0cOhbtSbK9o494u7NxAsNRj8m65frT5
 BJti3IGuPu6c89KmF+fMlolc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 29b45f507b2da17a;
	Tue, 22 Sep 2026 11:34:24 +0000
X-Mizu-Trace-ID: 29b45f507b2da17a
X-Migadu-Flow: FLOW_OUT
Message-ID: <9ac5cba5-0044-4f57-9ec0-d5631b7b178c@linux.dev>
Date: Tue, 22 Sep 2026 19:34:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm/sparse-vmemmap: support device DAX in common
 vmemmap path
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-3-songmuchun@bytedance.com>
 <dad55fc6-56ff-4375-893b-938404238ca8@linux.dev>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <dad55fc6-56ff-4375-893b-938404238ca8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D45880009
X-Stat-Signature: zrcdr8tm76ttd47gf1z5grtaqxk6576x
X-Rspam-User: 
X-HE-Tag: 1790076876-226690
X-HE-Meta: U2FsdGVkX1/Irol6LtcbbabQVQX1eLV6GX3QQRUYGV9maNpICI2t+uzVj0/OLACjStm34xVU531693/RAeWJPFCQbRG2oDIE4hLzY2NM+BRvdbgGj87j8iB6JlQJsev79gBoP9qYQuI8iCi2Fd6EuAEXRSXduaOav6m8pwIqZ7AAAeS4a7BMcC+vbMDliVqO1h1Qp7anXirD8yFnSgreURj63HV+d+r/BDxNa/Y/O8VL0Csjw/IjnwSvZa2rBeD9JRSxzRgSJwlfZ3G9jNzJp1L03FU+1OItRyMd7QSetQLuYA0zMr1vhQVAWLRHg5qszqP9wvkr8VWN1oENHKJaUqKEj4tM9RVaWC1utBBm0s4VJSvNGIl/lG5JfrEY3buJhkLxvg+BNXZwoaqzZHcGX73rvkU4dAwSzcCUM7jTpWn9HInTyfxT6HitsLG1/Q7k1rJ+3+X44PHiM1kb5o3i5EMM6YkzxHVPw+ZWuW492DNookwEh5UJ8BjevLvCsruomSyg85DdDpuvvN7sgHBpvnRgioagBsr212UIiap2bOtWv4wf6RnzXLKugTD3eRAxfdUB1FznbHYTqFp6ii/f9rRZUqPlegsETYlzcxZdzj+Hf/Nq321XzXc1YWZLV5VaWTeg79U6yRKIiq3Se+jqr9ge82EXVe+8dNPVUJl3O0ZHJggyPDxoHjobt3Gm1FA/UMomgWCcYwRm37SGW6x9A3TGKsfcvPzwRPrd2/wP+vo5UThn15ILDkycm+C0Q9qjDmzwD4HWeajpZSvZ/2Qf/DLQoTZmO+puIo+/uxGL/q+SufreVQgMA813hoOK6w550d6J12/chb7tngfhg1C1wca7lm1/FN7In+x1d3EhMgp9/Bs4WWfUojuzjEJbC1rvs671ZX0YRM+uoJPKv2uqgSqZkdODwu+FcbE0OsA7OqwX7u4SBtkmFi94VE07R0LABk62FMAK3xKg6TSNgHf
 F4IGCRhm
 ioJq8yICO3fgMR5mYbmghC8K90D9dBBUf2unuqZvtFAE+49wVJ/nfP+NFXOXwtlFICzg3VOfo9o22Hk4aA1C2w2yRMUWyoQSJ7ekCfW0P2Sm/2b4b46ckyRLDc+Y3uw7ArFpwTeAppqNgVi8qZL4F4OkP1/YzaVuzgEymFmJMZfLUDqERt4UHqg8HWPZDv6kl0xJuRc3CJmgKCK3it27e0OQu7GFk8DU6ktA2tWBwf8VsmMHtZi5snG4/ephbz3Z9cdTayJXKzjamTWgDXIY3zZ5ztjOIvAcL6FoK+goN4tZiBZF2JExnBsS4hA1uzog8Mu0DI2z/1e2HS2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/22 16:02, Qi Zheng wrote:
>
>
> On 9/13/26 4:37 PM, Muchun Song wrote:
>> The common vmemmap population path cannot yet handle optimized Device 
>> DAX
>> mappings on its own. It uses pfn_to_zone() to find the shared tail page,
>> but Device DAX populates its vmemmap at runtime before the 
>> ZONE_DEVICE span
>> is initialized.
>>
>> Teach the common path to use device_zone() for runtime optimized vmemmap
>> population while retaining pfn_to_zone() for early boot. This allows the
>> same path to support both early boot mappings and Device DAX.
>>
>> The backing PFN supplied by the Device DAX-specific population path 
>> is no
>> longer used, allowing the redundant lookup and population code to be
>> removed later.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>   mm/sparse-vmemmap.c | 44 +++++++++++++++++++-------------------------
>>   1 file changed, 19 insertions(+), 25 deletions(-)
>>
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 878d29a4e862..e83821768c12 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -208,18 +208,27 @@ static __meminit void 
>> *vmemmap_alloc_pte(unsigned long pfn, int node,
>>       struct page *page;
>>       const unsigned int order = pfn_to_section_compound_order(pfn);
>>   -    /*
>> -     * Device DAX still relies on vmemmap_populate_compound_pages() for
>> -     * head/first-tail allocation and tail-page reuse.
>> -     */
>>       if (!vmemmap_optimizable_pfn(pfn))
>>           return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>>   -    zone = pfn_to_zone(pfn, node);
>> +    /*
>> +     * At runtime (slab available), only ZONE_DEVICE pages trigger 
>> vmemmap
>> +     * optimization, so device_zone() suffices. Note that pfn_to_zone()
>> +     * cannot be used at runtime because the zone span is not set up 
>> now.
>> +     */
>> +    zone = slab_is_available() ? device_zone(node) : 
>> pfn_to_zone(pfn, node);
>>       page = vmemmap_shared_tail_page(order, zone);
>>       if (!page)
>>           return NULL;
>>   +    /*
>> +     * When a PTE entry is freed, a free_pages() call occurs. This 
>> get_page()
>> +     * pairs with put_page_testzero() on the freeing path. This can 
>> only occur
>> +     * when slab is available.
>> +     */
>> +    if (slab_is_available())
>
> Would it make sense to introduce a helper function that wraps
> slab_is_available() for better readability? Also, it might be worth
> adding a comment to the helper function as well.

Thanks for the suggestion. I considered introducing a helper, but the
two uses of slab_is_available() depend on different properties of the
same initialization boundary. One determines how the zone is obtained,
while the other determines whether the shared vmemmap backing page can
participate in page refcounting. Any helper name would therefore be
either too generic or specific to only one of these properties.

I would prefer to keep slab_is_available() explicit and expand the
comments at both call sites. The first comment explains why early
system RAM can use pfn_to_zone(), whereas ZONE_DEVICE population after
slab becomes available must use device_zone(). The second explains why
early shared backing pages, which are allocated from memblock, cannot
yet be refcounted. Once slab becomes available, shared backing pages
are allocated from the buddy allocator and can hold one reference for
each shared PTE mapping.

I will adopt the following revisions. Does this make sense to you?

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5e0e30c77431..406d6f7918f7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -212,9 +212,13 @@ static __meminit void *vmemmap_alloc_pte(unsigned 
long pfn, int node,
                 return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);

         /*
-        * At runtime (slab available), only ZONE_DEVICE pages trigger 
vmemmap
-        * optimization, so device_zone() suffices. Note that pfn_to_zone()
-        * cannot be used at runtime because the zone span is not set up 
now.
+        * Before slab is available, vmemmap optimization is used for early
+        * system RAM, whose zone can be determined from the PFN.
+        *
+        * Once slab is available, only ZONE_DEVICE memory reaches this
+        * optimized population path. Its zone span has not been initialized
+        * while its vmemmap is being populated, so pfn_to_zone() cannot be
+        * used. Obtain ZONE_DEVICE directly from the node instead.
          */
         zone = slab_is_available() ? device_zone(node) : 
pfn_to_zone(pfn, node);
         page = vmemmap_shared_tail_page(order, zone);
@@ -222,9 +226,17 @@ static __meminit void *vmemmap_alloc_pte(unsigned 
long pfn, int node,
                 return NULL;

         /*
-        * When a PTE entry is freed, a free_pages() call occurs. This 
get_page()
-        * pairs with put_page_testzero() on the freeing path. This can 
only occur
-        * when slab is available.
+        * During early vmemmap population, the shared tail vmemmap backing
+        * page is allocated from memblock before its struct page can safely
+        * participate in page refcounting. Therefore, no reference can be
+        * held for each shared PTE mapping, and the mappings must be 
unshared
+        * before the vmemmap is depopulated.
+        *
+        * Once slab is available, the shared backing page is allocated from
+        * the buddy allocator and can be refcounted. Hold one reference for
+        * each shared PTE mapping. The architecture vmemmap teardown drops
+        * the reference through __free_pages() when removing the mapping,
+        * preventing the backing page from being freed while it is shared.
          */
         if (slab_is_available())
                 get_page(page);

>
> At least for me, encountering this always causes a moment of confusion.
>
>> +        get_page(page);
>> +
>>       return page_address(page);
>>   }
>>   @@ -231,27 +240,12 @@ static pte_t * __meminit 
>> vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>>         if (pte_none(ptep_get(pte))) {
>>           pte_t entry;
>> +        void *p = vmemmap_alloc_pte(pfn, node, altmap);
>>   -        if (ptpfn == (unsigned long)-1) {
>> -            void *p = vmemmap_alloc_pte(pfn, node, altmap);
>> -
>> -            if (!p)
>> -                return NULL;
>> -            ptpfn = PHYS_PFN(__pa(p));
>> -        } else {
>> -            /*
>> -             * When a PTE/PMD entry is freed from the init_mm
>> -             * there's a free_pages() call to this page allocated
>> -             * above. Thus this get_page() is paired with the
>> -             * put_page_testzero() on the freeing path.
>> -             * This can only called by certain ZONE_DEVICE path,
>> -             * and through vmemmap_populate_compound_pages() when
>> -             * slab is available.
>> -             */
>> -            if (slab_is_available())
>> -                get_page(pfn_to_page(ptpfn));
>> -        }
>> -        entry = pfn_pte(ptpfn, PAGE_KERNEL);
>> +        if (!p)
>> +            return NULL;
>> +
>> +        entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
>>           set_pte_at(&init_mm, addr, pte, entry);
>>       } else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
>>           return NULL;
>


