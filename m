Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D208CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97038E0016; Tue, 30 Sep 2025 02:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EAF8E0002; Tue, 30 Sep 2025 02:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84898E0016; Tue, 30 Sep 2025 02:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A90808E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:56:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C61813B5CB
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:56:57 +0000 (UTC)
X-FDA: 83945009274.11.6112636
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 588511A0007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:56:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=urMmE0Sa;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759215415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfG01hzQ5LV7xxeGPJrJqVr0sMqne+ZV5k1xGDFFNZc=;
	b=rh2Hy7U3OQEGAZdzV0UVNHlI8xCB7wda7BA8FSG6SM8Vqot/jbWpQYb63SCIha6Id4D29B
	6CCW0pbcUu8ma6n0GGZEkPLPOnor2zHVRpvYWkPw5Nm1jvM/jdQkXpVsYWSTRXyK0I8RRG
	S18l1nEeXBFkIvJY7o53z9mK+mamoaQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=urMmE0Sa;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759215415; a=rsa-sha256;
	cv=none;
	b=hhj0eOPVlSQcF8fgVh6K+80A0236WnzvmkSzOJB5haCYJYNZC63w5pBK9fP0VdBPmNGay8
	q00mgq48W4uz8q0iiq808UuBOFCYa0dePE7q3Jn3PnxmEW60GgsO9b2XeITrkvjKKxlc3X
	cOiaAdqeX1k6hAehygLQRnRRkoGkOZ8=
Message-ID: <c034995d-62a5-4204-aad1-f25b982d2eef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759215413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DfG01hzQ5LV7xxeGPJrJqVr0sMqne+ZV5k1xGDFFNZc=;
	b=urMmE0SaEUh8SftuwhdlQzPOOvb/g+hWMEgKhpzoWhqkyWS+xErd05kd+z5yRbtYf3cner
	BbxckRsZzdTcVegmI1yg6suXADJrJpjw8I7sI2fMVfxiJuI9Y99oH0KI70R8DHeBw2IQsV
	/rosrOEv9kqOj0/2S8u/HLNwa11g1bw=
Date: Tue, 30 Sep 2025 14:56:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, npache@redhat.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 usamaarif642@gmail.com, yuzhao@google.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com
References: <20250930060557.85133-1-lance.yang@linux.dev>
 <838505c8-053e-49af-b37b-0475520daf68@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <838505c8-053e-49af-b37b-0475520daf68@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 588511A0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 61nmic5uq4pnd4uzxyxn5ntz7iw4nrft
X-HE-Tag: 1759215415-667770
X-HE-Meta: U2FsdGVkX1+w/iILj+cXEeP4J71hN3HlTcNQeB0l7E1z6mdh2hIkGVUnxLgrwUXp3vQtfnZHd3agKaIia+vXJR1NV5pjhTkXZO9nw6BavWhcZGM3PAM7LRaKioD9P0Mg1gotbXb97hNUwwNClxwpepXiq2KIze4+jVOXu8BaTYhNxsU/e2EG7HMgyhFii2xB37th3X4L4WRXpe/dYOE3vboV+NpNPljLjeP9uxspLbLEu5QHqHIDggBOo0FNVF7xuWznqu+QvSfM+SA49zvlHY3Uyo2VKWlMKm+uWrw9VxMwxyHQtS/djh8fyZDQUlJRLKvEjJAzYvU+mv83rNW6D4xjoD80HMmZhgVoF+GjisD9hSRHmgiYkYkE2otqe3+zHQ0DnSi7JpajQiwYTrSA+cZWzFc3RcrdNKTgnazPW4yBkmZu5OeiNOTXS5RjUhvVc6QHvJVtf0QqrN04xVjujnmummXW5teOqx8ARPQ7lNlZufc8VVWNVNYihRdPvRMC4lWaoypOTuwSPtAPe2aidmprFNs0nH9uRxWLyAQn5IzmnWXCieW72R1aqKBe1KrRJ073OaE2icdEyNqiWyfYjHCvnSNKydhiSllupOrjf8v37cdehwRrrXc6r1HJzBAPs7ZCaw5ZM5Z6Zy6qsC4hUt2j7Qp0FGvS1a4q+hytf9biqurG4RAWScY9rE8IVRIhFTNHXw1AeZdXCa1djVM1hFs1ooBoU5WulLdrwGxYa/PNKfFRZiWVpxsktGwuNOuESO0JnJumPqdGAMFl7ILqeZyNDr4mlTgyUralQyqh1PVgTifGsGmUcE3whvoeIv1L5PWPaplRLZyP+nIvIQamV7aFU81p7NYlLugGxs0c6nUQOpC+sQ9BUVbqegDKg36vpnFhTuvj9S19nVsnlQyX/4LuhIMXOkfGh3+aKR4uqlm79cfrVrfpm3n1I6AiQNiGagMVbRzxsj4eMnaJteS
 5JPmcily
 kv7fZ5aKR4i2sHmY4I1CSzVd51W3XZIyQXbTq5pxB0zqgUsnOLX1f6JSIooh1tsczaB3To75HK9QYkJ+/OlrQNDPaKx/vkbXfKYYo3e0OIQSWcecWZ5epOB+HDRqMpYQF1Up/3aLbJiA9YgjxRr+27mROXh8T+WcfdfOFnNREGJDPy77LE7go4eazwQ4IeliA+DsxeC0/8sUrrInIvsJi40HwqSAl5cKLM8DM9V38s3tKAQVQXCWSLyjbno8R766l04CY8KKWHIMftqtumSEYwq8yeDDlx0HuJbzNH/1Cu82LWqITSsuYodMPLGPoG4mTIfuadO1czq2xVA0whZCLsG0CMGh56RRToHiWFGlNPfcKR4cNkMbbOUGH3+xZV0PKAULpu3c8rUR+/KC4waXtfJ4y11826dxybF4saY4Ghk+hWJa8Of5qs2HSFMYcdCPVSwm9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 14:33, Dev Jain wrote:
> 
> On 30/09/25 11:35 am, Lance Yang wrote:
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
> Could have just added this in the same line as folio?

Sure ;p

> 
>>   {
>>       struct page *page = folio_page(folio, idx);
>> @@ -306,7 +307,7 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>           return false;
>>       VM_BUG_ON_PAGE(!PageAnon(page), page);
>>       VM_BUG_ON_PAGE(!PageLocked(page), page);
>> -    VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>> +    VM_BUG_ON_PAGE(pte_present(old_pte), page);
>>       if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & 
>> VM_LOCKED) ||
>>           mm_forbids_zeropage(pvmw->vma->vm_mm))
>> @@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>       newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>                       pvmw->vma->vm_page_prot));
>> +
>> +    if (pte_swp_soft_dirty(old_pte))
>> +        newpte = pte_mksoft_dirty(newpte);
>> +    if (pte_swp_uffd_wp(old_pte))
>> +        newpte = pte_mkuffd_wp(newpte);
>> +
>>       set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>       dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>> @@ -344,7 +351,7 @@ static bool remove_migration_pte(struct folio *folio,
>>       while (page_vma_mapped_walk(&pvmw)) {
>>           rmap_t rmap_flags = RMAP_NONE;
>> -        pte_t old_pte;
>> +        pte_t old_pte = ptep_get(pvmw.pte);
>>           pte_t pte;
>>           swp_entry_t entry;
>>           struct page *new;
>> @@ -365,12 +372,11 @@ static bool remove_migration_pte(struct folio 
>> *folio,
>>           }
>>   #endif
>>           if (rmap_walk_arg->map_unused_to_zeropage &&
>> -            try_to_map_unused_to_zeropage(&pvmw, folio, idx))
>> +            try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
>>               continue;
>>           folio_get(folio);
>>           pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
>> -        old_pte = ptep_get(pvmw.pte);
>>           entry = pte_to_swp_entry(old_pte);
>>           if (!is_migration_entry_young(entry))
> 
> Looks good, the special bit does not overlay on any arch with the soft- 
> dirty bit.
> It shouldn't overlay with uffd-wp as well since split_huge_zero_page_pmd 
> does the
> same bit preservation.

Yeah. Thanks for double-checking the bit overlaps!

Good to know we're on solid ground here ;)

> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Cheers!

