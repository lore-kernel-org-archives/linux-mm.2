Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514CDCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8186B008C; Mon,  5 Oct 2026 05:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468866B0092; Mon,  5 Oct 2026 05:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F1B6B0093; Mon,  5 Oct 2026 05:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9946B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:03:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B00D1401B5
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:03:57 +0000 (UTC)
X-FDA: 85287985314.05.16197A9
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FF64140005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:03:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UgIMrKyp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791191035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lg3JTsD4Fv1cl+EWpET5q4ztDTVbrGh6J6Dc7vTY9rk=;
	b=oyxVLiytDHzQpWwDAFz87XG6v049psUqwkFd9NqYjK74IERCf2NOkkO1dcu8bIC3q5NpEv
	aXMJTLX47rW9Ly7zDh7N6JHg+xsEKigj80+IG28KsQEHgiKkmY27W+77lUSIdI5dcMY8A/
	+rqyTAjsxRPKgoRovIjoFOEfNfFRUQo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UgIMrKyp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791191035;
	b=XedQFRS3UbW6mYkHaJt+Y1RWUbsu3SH2tHrOS5xsz49KvjmBITL/wLhq2u4QRJQhSwQFby
	bBBO6uWgwwce2Up9znOQ5YaGd7wRYr5uvfq6CLYruB/Y8lOMD3bDkI2TXMlxNfDto7dGrY
	ocvEGFBTvfTKwLZOdlCSu57h6Ngu54A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791191028; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=lg3JTsD4Fv1cl+EWpET5q4ztDTVbrGh6J6Dc7vTY9rk=;
 b=UgIMrKypWcATpv6vSBbvAAFYmMdYtrXSLSlI0Galx+1zzASPvGO5DERI8DbYJRyBPNH8GZ
 bpz5/XnP+RhKLeaJJzLs8eVBLDeviS5tlQypC0yq/w2Na2sxgYIv7pyJWYdyH0JiHz5Xcl
 LK0jwSbJ+0OwkksE/ShQO3eUYfDa8MWHniW5CMcj/APA9BCIcx3Za7GKU5IJy5rAjSfoCj
 ZaNQURmTluHXspwnZJRDAu4KEyFKuCn7A6SF2GBUSnrlNqXfgaObYRm3aCj3Q7OkpIXCVt
 byyMqMiF6XIXSXmZ7WLIqqkoyuneADCLChQwNbQANU4eIGgHVHGWvSkAxeVPWA==
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Mime-Version: 1.0
In-Reply-To: <arzVaC2IYkqSb0_U@gmail.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ac367f2+93518e+kvack.org+lizhe.67@bytedance.com>
References: <20260930064308.58159-1-lizhe.67@bytedance.com> <arzVaC2IYkqSb0_U@gmail.com>
Cc: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Date: Mon, 5 Oct 2026 17:03:28 +0800
Message-Id: <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
X-Stat-Signature: oqpiberybpqfm5dqqfwxxqctpe5guzq1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8FF64140005
X-HE-Tag: 1791191034-5762
X-HE-Meta: U2FsdGVkX19l9w02n3m7AS++qDtWEHOwuzRkOG7ucOK4Pg8SPDUsq89vK2vYeVGS6QAyNyng3Y1mFrLiLBjNh0wGGqM19SqzpIKqZS10E5fMr1A1IkLYhc6YjQr96ff0duthwrAKUPXsIpce8rkK4pgSVhdf22Hwq3ny8mgy7k4UC0F+D4ukbGZw6oQoxGDAfeRP4KS0XjuG3XzpGYm17Dkc3jNSLBeuPVKPP4wATclnXpvNQfubXhf9EPZjm9M2bgtHxjCqZBeYMFmkzZceCUchqi6UOohm3C7MBts+tV4krmdN2OwQHgFcJ+Ry3z2HTGUvB+0WoimXPwmEuz3zkBglGazP1txSkg+YfGI/KN5wxy6RcRlencakduTgv+09fNpCvSFk+Fcs71697/ztRrpGH1EVrbD/6L/Ood/OukFTYisXskEL+ZXPBCVfIgys/n/3HhLf4lG8ZFs441nqOHLEzjgNMsv7ycrQmpzH/C5/lpWRtukYvQoONclGYa/NdDLoWZU3vuSHpOxn5oAq3XPUWEjKq66/zvEN7T94keuNfO4p9edviJrhBanrAFf62kTr5+wfP15Z2TXle5Vs18Itez47ZQsGYy5XUryj4YDgt5NffVZjGGmrjgnjcwRhpfePDVxcKjU0y8nKFplX+owrmaHozShNnvXRuoFTJEudIx5fAsme5wJF9YJsC92vRByT+zSo1XeBM1d+YQh0dxs0DDpq/mJY97WbrFHmYf1psIIJ2dHhgDVVz/f5LyATcxB3Iz1aesB52a6sl+il7UMPfclFeZpxUop+SNBNa4H4v5GZ2kb9F+ZB5NcHrYNs/n/XiV8HpNHynduiSlDCLW4kZmmajoQomD+jP/6elxo78WWtMIAheY5qOXQT1UzOHrI1IPZPc/sojB07a2Wwx1n1jlTKKc+cAjfWHuhHVhiKQ+GDvb+CRmJzuj5GuOf5JgHwQe/dadJvZvbCWrr
 dixGDvJI
 zT0N1SniF4aViUScMiWiXPY7sXHCX336AVQ/R+8AtW4JUCaDkvQaxIhjuYCmO6xF4hyFgKRdv4IDkDL/h+he1dLHuq/OkTTu4Mdk6i0MfaY2ePkrAZmDCkKFtEw9eTzhY+Jv596BvHymGhabHc7lKdS+w08sPYJ8s6J7yrDpOzGn6XBfvqXCxuLg8EN/4a2n3qyvAxQDDfYZe5TH3gfC5gG/l7QXTZHbe/OeD4NL3lyShH0lD1tH3khffJDYk07tLXV0vNnz+1VHwNyAUZkMJ5qJATFJF9ZpSVdIxz835DCRi5iPoYk4RMz0O0XSsTZDeE+lvZq/Zuc5ekxQlCP93UfUlXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 5:31 PM, Jose A. Perez de Azpillaga wrote:
> On Wed, Sep 30, 2026 at 02:43:08PM +0800, Li Zhe wrote:
>> huge_pmd_share() always takes i_mmap_rwsem for read before looking for a
>> shareable PMD page table.
>>
>> That is unsafe for callers that already hold the same mapping lock for
>> write.  In particular, move_hugetlb_page_tables() takes i_mmap_rwsem for
>> write to prevent truncation races, then calls huge_pte_alloc() for the
>> destination address.  If the destination PUD is empty and PMD sharing is
>> possible, huge_pte_alloc() can call huge_pmd_share(), which then tries to
>> take the same rwsem for read and can deadlock on itself.
>>
>> PMD sharing is only an optimization.  If the read side of i_mmap_rwsem
>> cannot be acquired immediately, fall back to allocating a private PMD
>> table instead of blocking in the sharing path.
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   mm/hugetlb.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index cea25773a6c95..75631101a6807 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -6995,7 +6995,15 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>>   	pte_t *spte = NULL;
>>   	pte_t *pte;
>>
>> -	i_mmap_lock_read(mapping);
>> +	/*
>> +	 * Some callers already hold i_mmap_rwsem for write, for example
>> +	 * move_hugetlb_page_tables(). PMD sharing is only an optimization, so
>> +	 * fall back to a private PMD table instead of blocking on the same
>> +	 * rwsem in read mode.
>> +	 */
>> +	if (!i_mmap_trylock_read(mapping))
>> +		goto alloc;
> try deadlock is not a fallback here. both callers already hold the write
> lock, and that is enough for the walk, so sharing is never attempted on
> these paths.
>
> hugetlb_change_protection() does thr same thing on the uffd-wp path and
> is not in the changelog.
>
> and no Fixes tag either. does this want Cc: stable?


Thanks for the review.

I agree that holding the write lock should be enough for the walk, and
that avoiding PMD sharing on these paths is not the right direction.

David mentioned that Oscar was planning to send a proper fix for this
issue, so I will wait for that patch instead of moving forward with this
trylock fallback approach.

Thanks,
Zhe

>
>>   	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
>>   		if (svma == vma)
>>   			continue;
>> @@ -7024,8 +7032,10 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>>   	}
>>   	spin_unlock(&mm->page_table_lock);
>>   out:
>> -	pte = (pte_t *)pmd_alloc(mm, pud, addr);
>>   	i_mmap_unlock_read(mapping);
>> +
>> +alloc:
>> +	pte = (pte_t *)pmd_alloc(mm, pud, addr);
>>   	return pte;
>>   }
>>
>> --
>> 2.20.1
>>
> --
> cheers,
> jose a. p-a

