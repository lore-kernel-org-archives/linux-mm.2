Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F930CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 07:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C65D6B008A; Thu, 18 Jun 2026 03:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276BD6B008C; Thu, 18 Jun 2026 03:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165E16B0092; Thu, 18 Jun 2026 03:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E81B36B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:45:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 776981C2E1F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:45:15 +0000 (UTC)
X-FDA: 84892247790.16.4E8EF40
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E75940007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:45:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ozKxIvFA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781768713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcdVk3SD/kQ6YP1sw609Ns7BDds+P1T+xzsWO6YjCAw=;
	b=RgG5oWLPFi9iaaeiIStLp+fPB4y562bNRb3uw7yzqdzjC9CAKVTJU3QSMUyAjMQr9ZE8kH
	BiqlEsTQzzVCUIbaGpxSd+qao4w310BdGTm18GzfiWvQNLgz/EUtEKQqhv2L5UcBEHX7Eq
	BzXZghrQuHJVW4Gw4z7zTMfuNQrbfHE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ozKxIvFA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781768713;
	b=eD/u+NU8DQUHbL2ikI/NrHeLzQEvpKeuQk9awbdM/OOrBXt+7z8LaZX+GrBgkHBddCP89p
	CQY/j3LBkRYcBLa+KOD8q1AMfaCDDHuOkxlRbXLncYFj2eDnaxZYvc2UxiX7gbprD4VHjc
	7grAf87OnJn3J7PHqD8FfLcjyRDihWM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781768707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gcdVk3SD/kQ6YP1sw609Ns7BDds+P1T+xzsWO6YjCAw=;
	b=ozKxIvFAUa6h8qFuqox1DC8GyPRZZujiOfjuuDrQw254LRyIDKt4OZLamnPy4oo5heYBWX
	S8iykcBIf8u8heJCx8X0llJ2A76HqkDqGhJZLr8N5wB1N3++onJa/MgXpoGpDXSP1/p3Yg
	h66F2AGBEaiRsFWs5KiOiHrtLEsGoPw=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com,
	david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
Date: Thu, 18 Jun 2026 15:44:49 +0800
Message-Id: <20260618074449.24974-1-lance.yang@linux.dev>
In-Reply-To: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E75940007
X-Stat-Signature: de3g6zakrhc1f5gtnzd1k3gfsb4fkr4j
X-Rspam-User: 
X-HE-Tag: 1781768712-868633
X-HE-Meta: U2FsdGVkX19zuSHmU5LRy979kfOqDvxkU11GF5SOxSEn2vsRaIGv5XCZpQtu/y+eutXUvsB96aJOec7Yi5Lu+thVVBBktisNJUnqS9UO9RIqT7Yaj8Cgn8kDfNDXdue8H8FVRAheFFdm7n04DdDvQDjKBdkaDD3Cb8/93GG3bKyhxVBj0vCpcmXNDQ7r/ITMcoVRlIO678kitiX7hz5ZYomXs4KcndkSuV95tAYlmN8R3UIlxDLPJ+M9Zy/AIdQzCh8+jcoIUOuvKNbe6/NpbL2bEw7VLZQJNR7/7J7s8astoHIaAt5wHaCk8VsuYC84DAku7lWXlB/Cd6BE2OKVVQsmga9I+pkA/wI3IdvihzXdXKD+KgmDSLsRKb5eulwoIoNklqwZtAo9atrINRLQYcNd7kpLF0cffeFi/s76M2nAbGGKI4bQOPOSF7hpDl9iS2qyvrYFlBIMEWkCMfg8m2zUz+bvGV5aI1yt8gT36jesiuUU3LcbTeHd1HsJJ985xQa5cpOl4nmr41JYqXJUuuOjcam4F4CcM4SngwNrQiuqE+KY1Fw4hctqQ5n+YldbzqZGTQKzWvC+tPDdeat/KVyshTKLZj0KV9j0o7x7wMCKlW41M/KtEOjdVuofypHVzdefqfLMH4cTjbDMG6Sc39D6zrfZ/sf9ZraZccIIbNBJu7rihFNVfQazvgcm+2FDXGCxqIsOCqAVbJdhptevFT2Lqa1MpTmllyAzgFaTr6YBgN35ArTslFW7b1gUOTmShhu6crfieGARwl8qKChnS1RnrECA/LHwmu2dNJ3bFjfL/WAde5RuGfV8iyBJAgWrcuTgklBHe0d9jz4h46K6EyYTl9WqWbEwcK5Ip3LEkeYtV2ROiWufL7eb4jbY92KvxOJgjHkB9SGcwLC5NUK9fJT0eqo82YvUtceq6OsRC9um+1okR5MPXIA4XeuWKonytyjyqqmQLwzm9sBuAV6
 SLTwSkO+
 X9wCs+v1OI4BVxo/7x3U59+SUlqH+YIIRDnPVYHU4trPGh7FuN09Ce3fK1+lwd/poG7UiYXI2SFII03/qlxEWzMh5nEAdj6HHGG5btBXhmdEj3JBswF6bXaQcIn1sv1xl5Uav+RbbRuLd3CsfooqffHfqf2myHvWFC0PEVczPQnNVp/8nRXjHxWwO6CR2JAtMIhdWsHu7c9fVwTcGHdzlBCHXAYewpq2m87B1WG7jv05v7PqAlJ9HkZus0nFpEG/r4E0u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 09, 2026 at 04:16:47PM +0200, David Hildenbrand (Arm) wrote:
[...]
>> ---
>>  mm/rmap.c | 203 ++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 121 insertions(+), 82 deletions(-)
>> 
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 430c91c8fe2ae..06ab1158d4cd1 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,121 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>  
>> +static bool __try_to_unmap_hugetlb_one(struct folio *folio,
>> +		struct vm_area_struct *vma, struct page_vma_mapped_walk *pvmw,
>> +		struct mmu_notifier_range *range, enum ttu_flags flags)
>> +{
>> +	unsigned long hsz = huge_page_size(hstate_vma(vma));
>
>Can be const.
>
>> +	unsigned long address = pvmw->address;
>
>Can be const. But do we even need the temporary variable?
>
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	struct page *subpage;
>
>a) subpages do not exist. It's just a folio page.
>b) subpages are irrelevant for hugetlb, just drop anything that deals with them.
>
>> +	bool ret = true;
>> +	pte_t pteval;
>> +
>
>Worth adding a comment here, why we don't need a loop.
>
>/* There is only a single mapping in a VMA. */
>
>> +	if (!page_vma_mapped_walk(pvmw))
>> +		return true;
>> +
>> +	pteval = ptep_get(pvmw->pte);
>
>Should we now properly use huge_ptep_get()?

Right. IIUC, on s390, the hugetlb entry stored in the page table is not
in the normal PTE layout. set_huge_pte_at() stores the arch huge-entry
format there, and huge_ptep_get() is the helper that decodes it back
into a normal pte_t.

pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
{
	return __rste_to_pte(pte_val(*ptep));
}

>> +	VM_WARN_ON(!pte_present(pteval));
>> +	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
>
>No need for subpages.

So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
derived subpage can be wrong.

Cheers, Lance

[...]

