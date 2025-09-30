Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEA9CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8487A8E0005; Tue, 30 Sep 2025 01:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FE08E0002; Tue, 30 Sep 2025 01:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CC18E0005; Tue, 30 Sep 2025 01:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6485E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:23:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C07B8792E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:23:13 +0000 (UTC)
X-FDA: 83944773066.25.D096102
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 04F671C0007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:23:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=enkuZ78m;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759209791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtYmqC2JBRU8BJUTWVRUrUQAYfqmfbq1JzJMz9RYCo0=;
	b=yrzKF8CWnPs9o6f0bHm3ixc6Nr2aOs506srkiqZMGyxpho9gbdIDM/fleJxcO7C71VhSB1
	nAHz9yJxrQ/i6CEVJ31qXOPSE1J8oprQ2spUozZ5/noVYfLjYn1DWbeQoVncyC5TfJIcem
	JXbJupKkKnN/WS8diXW14JYf+cWDVcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759209791; a=rsa-sha256;
	cv=none;
	b=KPoottNEXlLYIdi5TcNcvrCrLTkmE0e6Y2zWS+J7ZuM9duhiQ021r86eX3rL3w35GCBhKI
	zPZe3fQLwFp9E/ocieFs/M6suLDWdUNrOTP6H1N0wx1RNTrvOF6VTEvrjkNyfSpdw0hK2b
	22sO0EqBab8QAmyg/k/6ln3zvUatOsc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=enkuZ78m;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <668bfb74-014c-4fd5-a636-ff5ec17861c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759209788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AtYmqC2JBRU8BJUTWVRUrUQAYfqmfbq1JzJMz9RYCo0=;
	b=enkuZ78mJ1c4AdM332qUKwV2XmuDNEL586pBBYXQ3ZlOuOSiahvDsfnUOECdhsvvjwQRed
	mHR4XacLrQv9pX9BQ4gkg5hz1KJ019CU7YpICInUcauQxj8jr4e2fegy41R9M+xOq0kJ84
	1sYIQYLoBGHkLiY9UyCkWYpafbKWsw4=
Date: Tue, 30 Sep 2025 13:22:54 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
To: Dev Jain <dev.jain@arm.com>
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, npache@redhat.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 usamaarif642@gmail.com, yuzhao@google.com, lorenzo.stoakes@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com
References: <20250930043351.34927-1-lance.yang@linux.dev>
 <0c498301-7434-4b2b-b7bc-73abe2057b67@arm.com>
Content-Language: en-US
In-Reply-To: <0c498301-7434-4b2b-b7bc-73abe2057b67@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 04F671C0007
X-Stat-Signature: x3udibrd155zsonwesduf89pwee1y97s
X-Rspam-User: 
X-HE-Tag: 1759209790-894967
X-HE-Meta: U2FsdGVkX18JiCg6Bp7V2BBMib5UeZUqgwdKICg3uLpNCrcOpvI2VVHpTCwDUA5iorqDiMW86IDbzg7GzuQTXApMAiL8qzxcoiIk8mVLR6I6hs+IFxKoQRBwVC/iuD4io9GBbPTqEQKOOjzT4c6K9SbyHkajVTOhxADQxlOlJmlyCXApsIpo8z6MWQMbLfsQl/ZbjweWgUZdowFdiADUBWVln4BNdqo6xr50wJjqx13eVatZ0u+nkEKUvVlzZGuMVO44Wi1eA/V9SVLFZrQMwOijmTGxCrgE8WPzfLbyo1ybebJ+RxCau94zpndUZQ812YWhtEBhTF+LsMs3UXdtu4BXhHMPsUn9zu1J6zVlEQj3ftZmwcxDjJOAsEhIxgdJI2b0vr2LEBZ1AYLKI+xmty0lnCJ5vLd3wMjRc6//u3zMt6RVPwgvpWsPcrCJUZUoPEK3ocymTLkkbFwEmCJ48VCl+EV+HpI3Mr2nk4w0OSeNN/dnymDm9EWa0QC0r/HpjfZum5kCo2tDN7ym1jQ0r/V3o6BNOpd0JDe8Q0sx8Mr8g3tSNXx8EKKK6MQuvLrjpGwae3Suqxr7+nQrFReGVeTlg5YEY27zgbdefaODnkzebSqdgSidFUAVZj6Js109Ya5AU3r6930ENl8Ki16Dx5Zpoxt9jcIHzU3u+9RB4gxxjUh4azmL90xpRBSqtEzHVO0Yh3Gl9sZ970ZrTBrN3Hiix9Ea4d09FQ/JMd6PXk2DLXxU/+VvLY0OXo0tjZTaRDeh0rbfuUSF69b0+NQv/eiSe6cqv9RbPtzLEct2cmIKy0rZ8hWIqEfNeJQthGckgwjuvfu2V/tBOUa5ICbj2SGIt2UndFvYIS69kKDIZxZSpQn2N4zLzD8+dl+pSj2xmq39LbHX/5HJunbwvOKWOQv8ixyWe8QqGJCtn7ieHbY15XL5+/ejag32QNQ0krDX9kYFApB3NN5O4PPYe1c
 fcJ960hc
 mE1PU3uMR4H3oGP6fs1nABBTZ8PFtNZDsCZv7mRG5D4Kd8XYifsWmVlK7QEXXR/FI3hkDWlueJO1YTYm/O5GtXpQuqOWG7SmGSxHT8smhDeP8XsXP7YRggwX0AY8+XU1ZCfImAddT3XfEqw4MGGUyZtXgRegy6XwIK44EjXJIGfycXQIXWrlLopBowfCY0+0bFP5MCNZ9KPyjvk/B+VOoTGp0gLweqLrWw8oc0HbdRPpeGJsgtEAgEoaa7GHDN4r0rXVZEu0Gag3utd70z0vDZYlhwiFMaHTuhY1ykx5Y4KGr8dxtBgh1vACv42OGIrx/iJ3YrfpQO7zjAqoG4tJd+W2ET4bYfZs1mRPW3gr3n0zqMh7+6UATzTlTy4lbUWrhSUkEbA+BIUSqOapdUxPZ7pGzXUTM2ReZ1bZN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 12:50, Dev Jain wrote:
> 
> On 30/09/25 10:03 am, Lance Yang wrote:
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
>> v1 -> v2:
>>   - Avoid calling ptep_get() multiple times (per Dev)
>>   - Double-check the uffd-wp bit (per David)
>>   - Collect Acked-by from David - thanks!
>>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1- 
>> lance.yang@linux.dev/
>>
>>   mm/migrate.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ce83c2c3c287..50aa91d9ab4e 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -300,13 +300,14 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>                         unsigned long idx)
>>   {
>>       struct page *page = folio_page(folio, idx);
>> +    pte_t oldpte = ptep_get(pvmw->pte);
> 
> What I meant to say was, you can pass oldpte from remove_migration_pte 
> to this
> function. Basically define old_pte = ptep_get(pvmw.pte) in the 
> declarations of
> the start of the while block in remove_migration_pte and remove the 
> existing
> one. That will ensure ptep_get() gets called only once per iteration.

Ah, got it. Thanks for the clarification!

IIUC, you mean something like this:

```
diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..bafd8cb3bebe 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -297,6 +297,7 @@ bool isolate_folio_to_list(struct folio *folio, 
struct list_head *list)

  static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk 
*pvmw,
  					  struct folio *folio,
+					  pte_t old_pte,
  					  unsigned long idx)
  {
  	struct page *page = folio_page(folio, idx);
@@ -306,7 +307,7 @@ static bool try_to_map_unused_to_zeropage(struct 
page_vma_mapped_walk *pvmw,
  		return false;
  	VM_BUG_ON_PAGE(!PageAnon(page), page);
  	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);

  	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
  	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct 
page_vma_mapped_walk *pvmw,

  	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
  					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(old_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_swp_uffd_wp(old_pte))
+		newpte = pte_mkuffd_wp(newpte);
+
  	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);

  	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -344,7 +351,7 @@ static bool remove_migration_pte(struct folio *folio,

  	while (page_vma_mapped_walk(&pvmw)) {
  		rmap_t rmap_flags = RMAP_NONE;
-		pte_t old_pte;
+		pte_t old_pte = ptep_get(pvmw.pte);
  		pte_t pte;
  		swp_entry_t entry;
  		struct page *new;
@@ -365,12 +372,11 @@ static bool remove_migration_pte(struct folio *folio,
  		}
  #endif
  		if (rmap_walk_arg->map_unused_to_zeropage &&
-		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
  			continue;

  		folio_get(folio);
  		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		old_pte = ptep_get(pvmw.pte);

  		entry = pte_to_swp_entry(old_pte);
  		if (!is_migration_entry_young(entry))
```

ptep_get() gets called only once per iteration, right?

> 
>>       pte_t newpte;
>>       if (PageCompound(page))
>>           return false;
>>       VM_BUG_ON_PAGE(!PageAnon(page), page);
>>       VM_BUG_ON_PAGE(!PageLocked(page), page);
>> -    VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
>> +    VM_BUG_ON_PAGE(pte_present(oldpte), page);
>>       if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & 
>> VM_LOCKED) ||
>>           mm_forbids_zeropage(pvmw->vma->vm_mm))
>> @@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>       newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>                       pvmw->vma->vm_page_prot));
>> +
>> +    if (pte_swp_soft_dirty(oldpte))
>> +        newpte = pte_mksoft_dirty(newpte);
>> +    if (pte_swp_uffd_wp(oldpte))
>> +        newpte = pte_mkuffd_wp(newpte);
>> +
>>       set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>       dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));

