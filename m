Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F17C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F99A6B0095; Wed, 19 Aug 2026 08:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9FD6B0098; Wed, 19 Aug 2026 08:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF796B009B; Wed, 19 Aug 2026 08:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 522AF6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:39:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEEB980539
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:39:37 +0000 (UTC)
X-FDA: 85117975194.16.A9002F1
Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	by imf21.hostedemail.com (Postfix) with ESMTP id 949FF1C0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:39:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GC5g6UdI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.233 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787143176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWCUpVIDPzuqHSVP9xG3cjGcnL4Xb+7VXybcdiWk178=;
	b=1uLOg6t+aAwQ1jTnj/RduSf5ZIKkjNarW4Mv5crxQPrZMDccgWI9H2hDOIQ83D+qMqHAjG
	1ZO3h1zHIlEKM4AiitpSuSBFLUHZ9fS1QX7JC9DfqwGee0n+SNditEQUQXbVLNWTDor5nS
	Wg2vfjYwliOmy1UksvpJYpE5bmvouTM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GC5g6UdI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.233 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787143176;
	b=R5i+EZCO/F+VwjB9gNmpzy0DGSHUskrGELo5CVtr/kMTf24kX+ANM6798ALY6OY2BJgT9V
	Q/4QNJDq4O+3W4l8r5k6OJJuu4HH7AgPtmeR7ithvhQ1hA0hz3CEXKE5XQfbPDapffD9pI
	htWlISuBQF0DI3ufrrAyh0KszfKtKNA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/0QneJV1g4MfxResLf7BWzX48FMJzvzv6CTUChLrIPM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787143174; v=1; x=1787747974;
 b=GC5g6UdIAH+tCxgWyPzCLKp10meDvd9x6w+B4ACF00UNifqAWZtc2zVy+tcHN3klWrB0Tmax
 wiD6Mg9P5tzHa2+UwAnPFVfBE70GF/AKNnRWDhvsAAEfujRVJHAKZieFnsCcjMfeICnYZQ26ejT
 mEQW7ZXV3BfWf4mYRdoYnYQ8=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id d88dfc952275f4b9;
	Wed, 19 Aug 2026 12:39:34 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <4300a9b5-4423-4299-af54-e88bcca5432d@linux.dev>
Date: Wed, 19 Aug 2026 13:39:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/12] mm: add PMD swap entry splitting support
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-4-usama.arif@linux.dev>
 <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cof54zs3ss8bhuq8edwf37htg75cge5i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 949FF1C0008
X-HE-Tag: 1787143175-81182
X-HE-Meta: U2FsdGVkX1879wZd6jFtYmsIUyZ7hcZuDKnlHbrbv5HEbcPrT6PlDvCFeTW4MoYpJEC3jtzJfCBwkN8HWl+GthRNHGkyeveVyq1qDthwvH5n7a8bQlcE9XQVpTpf91e9i02VvTxfVnZp5ua/gUBIWCeHfn/D+ASPopjWIdQPBWusiRa3RyL3qWWdrnC3G+eFdJ/7JOtnrM/8upiNVO2sVtsvyBwjiRZbbd5MfjaAxXYsQxKuz1vSZPB/AyoimMRUUTF85c23si/T0SwLqSdU2zIpyBluKzZeQa74l3gEUfcCvauozDDC8LPAYjWat2gtNuf0tNkCTWFDKfsDCcRvG2R3aBTP7jMQQA7hYK8wbLn9xmpnrrjqkC9B0yuJrbnGYpdyjMH84ClHK+jXjppYRHRcgs6ssmJMjloayM3xuD/YjPOvmqVNKf8PLavhA7/b7ih0WUyNjirV+4k3DF7Qf11bz/Y2qpKAxmntDT7F5KAf9qcYmOs57Oox+EqV5RyxtEok+M47NGQEJoW2r8323Nja+s6KipeX985ZsnSuecveWfdFcyNXIx1ux0hk3Bf3dbJ3Yc80AAPUciviXFO/hODHmhVw2nLFGhUQ9Ki7YFyrOSTKmyYzd0ucC7gf8z4V5zJTKayD1lanbirroVRgfp3GWwEtBH3YKAfjk4dAjN3TC/lwC5O5eRw8jE5QsSRQU2pGbINRPlmYadXrjI4gWzlq9spLPOt+VY+M6aYKJJafZonp+5bzdhp/CBHg8PWziSYqwgiAvMaBdf0Y7TzzB90ZSxh5+rMIEv5Qm+4kRnBOC6zKJJ4MrPpH+m7GESaocXM5+OvZ7k8deuAZEAAdGz9VedoSgZ1ZR0CAs7zkqn7EB3OoiMAZzWU2E4iU5lYHa7Yez1RBmAzSQjtSZ7Yy/Smw20xl05YuqLzdVLKyKiQOs6dy4SqZMGT8oAoBPIPIWAYOt2e/UaVQTdyJF79
 YoqjEJ38
 zndwXvF4RBIY3OaVrYqz7sXdKOFgMv1j04mXZB1qTMULQnDbxKjgibH6eJgi9RyjHWl4RN/YMov92jkxaArvl+pJ/Zzon5v4VbOFtCRgaSgD6r7HJYDG7RrJ0eaBIAxEJTFQTT3SePsNKih5YPnrtGfxDE33/IhHr8a/vgHveY0bYiB4na86y++S1HKS/3zlhOtTSRwEWUppH+fSrTjtEHz3xU2afzu2Tyr7LIsEyNdP3Q4bJ4ezwlfriYMBsq5cCBWnQmuny+sDTURb5Kn4DxpyNwcXaakNTbHFQHF7JoI9kQUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2026 18:53, David Hildenbrand (Arm) wrote:
> On 8/18/26 15:09, Usama Arif wrote:
>> Add a swap branch in __split_huge_pmd_locked() that splits a PMD swap
>> entry into 512 PTE swap entries. No folio reference is needed because
>> swap entries point to swap slots rather than pages. Each PTE inherits
>> the correct sub-slot offset and preserves soft_dirty, uffd_wp, and
>> exclusive flags.
>>
>> The folio_remove_rmap_pmd() gate at the end must inspect old_pmd
>> rather than *pmd: for a present THP split, *pmd has already been
>> cleared by pmdp_invalidate(), and that invalidated bit pattern can
>> decode as a plausible swap entry.
>>
>> This branch is reached from the explicit __split_huge_pmd() callers
>> that hit a non-present PMD: partial-range mprotect / munmap, the
>> wp_huge_pmd() PMD-COW fallback, and the swap-in / swapoff fallbacks
>> added in later patches when the cached folio is no longer PMD-sized.
>> page_vma_mapped_walk() does not iterate PMD swap entries, so
>> try_to_unmap_one() and try_to_migrate_one() do not reach this branch
>> and freeze=true cannot occur in this branch today.  page and folio
>> are therefore left uninitialized in the swap branch; a
>> VM_WARN_ON_ONCE(freeze) catches any future caller that breaks this
>> invariant before the freeze path dereferences page_to_pfn(page + i)
>> or put_page(page).
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/huge_memory.c | 29 ++++++++++++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1b6b0aa2baa3b..a473e85d30f51 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3252,6 +3252,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>  						 vma, haddr, rmap_flags);
>>  		}
>> +	} else if (pmd_is_swap_entry(*pmd)) {
>> +		VM_WARN_ON_ONCE(freeze);
>> +		/* Swap entries have no page for the migration freeze path. */
>> +		freeze = false;
> 
> It's odd to VM_WARN_ON_ONCE() and then set freeze=false;
> 
> I'd just add the comment above the VM_WARN_ON_ONCE() and drop the =false.
> 
> freeze=true really only applies during page migration, where swap entries don't
> apply.
> 

Ack

> I think it's time to clean that up ... that is
> 
> a) Expose a helper called split_pmd_to_migration_entries() that is only used by
> code that installs migration entries.
> 
> b) Hide that "freeze" flag from all other file-external functions
> 
> c) Rename the boolean to "use_migration_entries"
> 
> Then it's rather clear in this code that this should never happen.
> 


Thanks! I have done this now for next revision. The migration choice is now private as
use_migration_entries, the normal split APIs no longer expose it, and the rmap migration
path uses split_pmd_to_migration_entries().

m
> 
> 
>> +		old_pmd = *pmd;
>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>> +		uffd_wp = pmd_swp_uffd(old_pmd);
>> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>>  	} else {
>>  		/*
>>  		 * Up to this point the pmd is present and huge and userland has
>> @@ -3388,6 +3396,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>  			set_pte_at(mm, addr, pte + i, entry);
>>  		}
>> +	} else if (pmd_is_swap_entry(old_pmd)) {
>> +		softleaf_t sl_entry = softleaf_from_pmd(old_pmd);
> 
> No existing code uses "sl_entry". Maybe just call it "pmd_swp_entry"/"swp_entry"
> and below "pte_swp_entry".
> 

Thanks! Will do in next revision

> 
> 
> Apart from that nothing jumped at me :)
> 

Thanks for the review!

