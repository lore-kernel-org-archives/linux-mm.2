Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B444606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPltpBH5
Received: by kanga.kvack.org (Postfix)
	id 3192C6B05B0; Fri, 13 Nov 2026 13:41:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFFC6B05B9; Fri, 13 Nov 2026 13:41:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6576B05BA; Fri, 13 Nov 2026 13:41:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E83BD6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:41:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70D97801B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:41:09 +0000 (UTC)
X-FDA: 85430963058.06.31EF2E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F8431A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:41:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPltpBH5;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpptrgK2l80VgLjm5xpa2pL7+GMcRlYHRpTi5z7EAjU=;
	b=MzY8B//ie6Wu5YvCbTunRgTMd4qhfnOtrpzqKWZIrLMvf3widp+Ac5itaZMEVopwoMtyqK
	kuz8HIWosR+8y1zVLkN4EvVRnZW/4d/zfHNVT+DLw38hM7945dk85r/YwQImoSa2ohVigP
	7TytcxXjspX3Bdh9Ue5w0LBv/o+X0nI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595267;
	b=IsIfFg/94gm1JqS9fcGS5/yJrJ6sCX0sJ+7CJGWlkmhj/KfwQrOANNFi7Wo2pJALrl54Jp
	uFoYVo+5TKEu8zP1ogk1t1D1r1+XMiJ8JtzK7KfA+44RIVH8i/me86hc6eCje12viRcEuF
	LVbrobx90Cyn27HvgQk98cK3zJHnhZs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPltpBH5;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC6EE4374B;
	Fri, 13 Nov 2026 18:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050CF1F000C5;
	Fri, 13 Nov 2026 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595266;
	bh=XpptrgK2l80VgLjm5xpa2pL7+GMcRlYHRpTi5z7EAjU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=UPltpBH5YLh1QQnrefheBr7BYwXIXoWGQCLJA1Zdq5XfCsvRTcbVSjBjmckRpr6gj
	 p1mSYPsTCxeL93RU9a6/RHPQeqqwzwr71lDQiLJigcyNIASreO27Us2sljcDA/txMt
	 l9bN2KgqB0xysRCnnIH+h6RnzBFZZAb6oDHgThHQMshrJd32N32hC55ooTjVb5ir1K
	 J+cJ2azt+UXtcfuPAbjFaH4x3AFFdzQWl02/ZP8G92warfRjI97NymrClN1xsJeVkn
	 AWqDLNOI8WVqN8AUUxubqgV9rG1I2dgahcOH4WA8R5GfCoTQQfmm+rFiJ99iLkA16e
	 J64/nx+9hlzyQ==
Message-ID: <8b186ea8-7a3b-4bb6-9354-de4b8892799f@kernel.org>
Date: Fri, 13 Nov 2026 19:40:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] mm/mprotect: keep writable entries writable on
 permission upgrades
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
 <20261105165004.2663799-9-clopez@suse.de>
 <60c4f0a0-e3c9-42dc-b2e0-0860ab6e30f0@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <60c4f0a0-e3c9-42dc-b2e0-0860ab6e30f0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x1x7c5hhd6kfg1w1ibe5cdb6rwfhrgxc
X-Rspamd-Queue-Id: 8F8431A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794595267-224781
X-HE-Meta: U2FsdGVkX1/vOqsc62cZhiwR7Qp1GHO8elpKRbSpWBkcOgpXtO+FRT0bCFO8zeWVJ6yea1UzAVTT5DqUNPbTcjcEWduRCQw2SE5h9CNZRM/vAcFnV+nQAjLFbdLkHnx6lRrR1gM8yfxK+dxIb8kVpJr+Ddhq+thopI6f06KlyPFYiGEVX9uiqPuSQkpOAudGCqF3Uqloj7zBc8A9XmiDPreDw2dNugKcQXVv7K1mp4FVFBHdvuBl/Chik9hYEmjr4m0kW5UOMY1fmoqNnYRKCI8a6JtVDjxaUdnhDWbQSW+s46g/iSdSjjcn9M4JqerdBRFeq78hmS9l/9PHX3lR36QUWdgB3V7qW4PdIj2abArFw2pwjNV7Xr1eJuIZzj1zXpjEx5LWS5eTeN6h8AX6xNtU7asGWYyEGvJdvO3P31ytvB41HHxWB4SHrMWUU+OcdKbRqrM/6Idk/qKz5OqPbCOzUdX2IhwJNbRdbXsbPAk1+qQVVjDzjsEBjNeLVNI8sun5ypIqZj9YGg+bE2hwDI2TbpyPYu87sVM0l8b/f2/o92ddTkWYCswMS2NiSvsFqz+L0DVPScpdHd6lG1QqXAHcebNBFIWqf6QTi/BPuzQbFhB2plza8tQsY5EEn8z6fkFJI0g732qc4BreuOsljSyOWLSB2CKeLG5AEp8r9ZKE8Ijiixtbt+Pi/DFwKaiZJ1dZCR2ETUg1K2V2QfrgHhKD17En1Ur7a3hboMNChG74mEH4BAGfKOXCy25ihVef7A+mfYQXeiiqIBd+N1SeGPeBez7cD68uNP08Cli4ZdQRQ4HNV5kxD3HnFDmAz8l8trr/+OcEFUWuhdFYglzbo/6g8dLPhjMmFhO6yMc3vIXEkDU39pYJ09crWxZy9sl+8SWXkV2l6Vv9Zi6Z6VjvC7U0AglOj4x4kj1/PG+JpXg2gOfOX349ltm8wau+yd1B3zo6DCJMJGcd4FJQPmc
 rcNzS3zO
 9dMFYkiuhRttJwc+JGRHg1VN1c55i4mDWIgx+2fYtU6axKr5QbBRhGx7dzaCrmh4jFjT8I4yDhVVjyk3jAw+4eHTGDZoIpnZiUI57n5fBJrD4pPaguPf41/1T7RalhsaYxgnZ5x3ihRUQ13Gi5sCTYIWwJhGEy6GtW8fM+offomXcafaF5uVWYrb8DLV900B5EwFVCGR69eGwCAqDe7G+eQk2LUkyHtv7dI/F60xbysM4l/8suU8Tpgn7dBsLS84LXf6vzW5nuun5MQw/41j0geUm7l7TGNJGbhwq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 18:06, David Hildenbrand (Arm) wrote:
> On 11/5/26 17:50, Carlos López wrote:
>> change_protection() applies vma->vm_page_prot, which lacks the write bit
>> for CoW and write-notified mappings, so it write-protects every entry
>> in them. When an entry would simply be made writable on fault without
>> further checks (e.g. dirty PTEs in shared mappings, exclusive anonymous
>> pages), MM_CP_TRY_CHANGE_WRITABLE makes the entry writable again to
>> avoid the future fault.
>>
>> However, writable entries in shared mappings that are not dirty still
>> become read-only. For example, a uffd-wp unprotect makes clean shmem
>> PTEs read-only even if they were never write-protected, e.g. when they
>> were mapped by a read fault before uffd-wp was registered. The next
>> write to each of them causes a fault that only restores the write bit.
>>
>> Now that MM_CP_PERM_UPGRADE indicates whether mprotect() only adds
>> permissions, change_protection() can tell, together with the
>> userfaultfd unprotect flags, when a change revokes no access. Keep
>> writable entries writable in these cases, at the PTE, PMD and PUD
>> levels. This is consistent with the write fault handler, as an entry
>> that is already writable needs no write fault.
>>
>> Signed-off-by: Carlos López <clopez@suse.de>
>> ---
>>  mm/huge_memory.c | 7 +++++++
>>  mm/internal.h    | 7 +++++++
>>  mm/mprotect.c    | 4 ++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 506e1e61c0fd..6e23d0e4ae66 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2809,6 +2809,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
>>  		entry = pmd_modify(entry, PAGE_NONE);
>>  
>> +	/* See change_present_ptes(). */
>> +	if (mm_cp_is_perm_upgrade(cp_flags) && pmd_write(oldpmd))
>> +		entry = pmd_mkwrite(entry, vma);
>> +
>>  	/* See change_pte_range(). */
>>  	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
>>  	    can_change_pmd_writable(vma, addr, entry))
>> @@ -2885,6 +2889,9 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  	 */
>>  	oldpud = pudp_invalidate(vma, addr, pudp);
>>  	entry = pud_modify(oldpud, newprot);
>> +	/* See change_present_ptes(). */
>> +	if (mm_cp_is_perm_upgrade(cp_flags) && pud_write(oldpud))
>> +		entry = pud_mkwrite(entry);
> 
> That looks completely hacked on. We do have can_change_pud_writable() below to
> make such decisions.
> 
> Whaatever you propose here is either wrong or way too shaky, sorry.
For some reason, your reply neither reached my inbox through CC nor the
mailing list folder through the mailing list.

I see that you send a v3 where you keep it simple for now, good.

>> 
>> That looks completely hacked on. We do have can_change_pud_writable() below to
>> make such decisions.
>
> Okay, for v3 I can pass the old entry to can_change_{pmd,pud}_writable()
> and return true if it was writable, after the existing write-tracking
> checks (uffd-wp/soft-dirty). For PTEs, can_change_pte_writable() is not
> used on the change_protection() path, so the same check would go in
> set_write_prot_commit_flush_ptes().
>
> Does that sound more reasonable?

Let's keep it simple for now. Whenever we mess with protection changes
there is the chance that we mess up and cause more trouble, either now
or in the future when we change calling code.

>
> Whaatever you propose here is either wrong or way too shaky, sorry.
>
> The idea is that MM_CP_TRY_CHANGE_WRITABLE relies on the dirty bit to
> make entries in shared mappings writable, which misses clean entries
> that were already writable (e.g. shmem read-faulted before uffd-wp
> registration). Such entries can stay writable, as anything that relies
> on write faults write-protects the entry first.

Right, but that should be optimized separately with a clear motivation why
we even care about optimizing this.

Not hidden in a patch set that tries to achieve something completely different.

-- 
Cheers,

David


