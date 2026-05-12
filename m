Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65470CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A736B0088; Tue, 12 May 2026 01:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51F76B008C; Tue, 12 May 2026 01:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EE56B0092; Tue, 12 May 2026 01:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A984E6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:19:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59A9516039C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:19:36 +0000 (UTC)
X-FDA: 84757615152.25.940AE99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5980B40002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:19:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UjdeBelh;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778563174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+z+g2g9WkuJIQKw087JAJMht2K4uY4Oi6ZWbxnL92HQ=;
	b=ziDT2pqCgm0ToOAext8H+p30N/Hzk1bMfPVNYkLjnotZU4ID0wFw4mLoCEoQaicuNhvjEG
	DJQA91m7brmCGcLEiob0wlo2X8l1EFUk4wcQNIxf0Solj9KDds5Ug0xt+LLEaCmg47w6jm
	OHJ4/EqtaJdbXXFoOW28Z3+VwrbhbQ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UjdeBelh;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778563174; a=rsa-sha256;
	cv=none;
	b=ZzjmEGSV2gx0nO0x4IMWHmCv8jXhypb/z1cA/PY2gcb7JpmnuKQHQorCOhugesf6p64Ozs
	sBFvuSPqk8YGyUiT3aypBSWVFVgkiXReJ/tBZ7VzQCY+kASqwe++EHHokpRf+TW9NtWwGa
	Vlb7NghZuyICQqgj87Z6Hn80vVxhjBg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E102E1596;
	Mon, 11 May 2026 22:19:27 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F16B3F85F;
	Mon, 11 May 2026 22:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778563173; bh=2b1ps3KVb7VArKGFg5XYi66Xz4LpF6CRKZwL2J02jeA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UjdeBelhGwAguT2JtQTly8n9m3L9n9wml9JvKFu/JYSzM5VPZzxEIrqoKIANtALi2
	 //IsyzP0qkyqsHrq6GcZtjoyImMSEM+iqMzsTqKfq5FKzL8EEgw+6QGHMoSmmAWf9V
	 ntQnmO8mBX/KDCtzWwbuZSuuxwIPhC/0Ksha+/l4=
Message-ID: <6fa2581f-0df9-4cfb-a00c-d2cdbe86aeb1@arm.com>
Date: Tue, 12 May 2026 10:49:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm/rmap: refactor some code around lazyfree folio
 unmapping
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-4-dev.jain@arm.com>
 <ff178d28-6a3d-4981-800d-aa9e050a7f45@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ff178d28-6a3d-4981-800d-aa9e050a7f45@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: frr7gwhzkxcdohuu4a5wy7rrg9xnph7p
X-Rspamd-Queue-Id: 5980B40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778563174-421202
X-HE-Meta: U2FsdGVkX1+MfFzcivvl4CdqvDaJGmE4gg5YQjTG2Lyz0OF/FdIEKX1NwWzNjfje/iXttjUwDavdI80/LEsMCMl6IM7Siyfp7i8xFFjXGG76pKoEbev7EbYF5XRCSw0+0310xCU7JW9RI4lC1DMizM6gk6etCowSSoQJPDGFf4b9xnvwCHuvGrdfugX8JaToZDunU23UjYBwt3NuUWm9HONtbtffKFqKptUXAIZqGxUs3BdIb6WO6Pp9IqlzS0k8vrbXeCdV1UNuNiqaivCioY4L8omgTH6pFCf9TGrwg9i5CDFODxX3kZ/jvnM66NKzRGnHspZJ+ZsZLevMbqDnTF0aXfv0oCDiMst4YWFsUKtLfa9yguHrZhlz43uhA2GCu82Jzbd/VFslkJIi1IDP5ilO21u1hs1Y2Q32AvGd1PK/yMtY673aqc5bhE2CN319rI2m0m8sy+AEPumjPZNdw2/0VmGRinGBmHlF4XL9+bJnobwDtaoex/mi8sMk94PMBsrRG/+Lbe4+Ll3XPtP0IuwTENsOHDsZfNe3LmgeeGlL6/UPrwDrHs9fxvKLNNHK4qgNQ9nN8M7/r7Prqw/AIGHOlH3ZE+jRF6z3EoJwVJZbUDN6HWhMBTvFOsMwKHU5caqztI7k9Yp0z/GIKVcJOzhrIxqtvd6l4/qHmmirRJ/2Vf/53+/ZqT8ae1QFXFK3NvdpZbCs7gsLvrgXR+D5yQ7zDgZhZmjxdYYfjs5ozjOT6kz9XGi+aaawgxck4mFpZeShaGmoatuu351aWJXYoWPrVjTJjmLt0MQ36L7vbRwDlrx94iGwCw++NCFvAajG/hi+zAQ8Bi6nAHVrlg3kn6k01hClIzxxkTmyJeyRNTs4RSXPmWngnCPLbyC7kCdsVOcJNU6eI5qGzG9N8h5fW4flXJ60Uda/SrvGNdAfTcJ9Iy+TMaETHCOFImJXZcI3V9ZXRfeR17vwldGTt1A
 ZaMVfAeR
 CXnvNDarS6+NuvIstLR1tx/5By8K6o8HbeIlPSL3X2OW8HdN3mRARal4/WYnOlQgiReebzUThdkSjztVdmdZFNYdvY8dcX0cJqwq+nvjED8Iu4/Tkq1Vtvah5WE/KBiulafen6oOn13YekrwBcsUsXIZFVloXmlvd1rCdZb7qTki5Ar3A1EEoGiG17dyghFigNeaauFs/8off1LUnlAzXAl+CE7GSwqcOSG3jHDrDijjza0txi84sRUeSi1r1/CgK/ZBIhNDSH+DNAUAbSJil8r1gC94tRAKTY3Qp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 12:58 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:44, Dev Jain wrote:
>> For lazyfree folio unmapping, after clearing the ptes we must abort the
>> operation if the folio got dirtied or it has unexpected references.
>>
>> Refactor this logic into a function which will return whether we need
>> to abort or not.
>>
>> If we abort, we restore the ptes and bail out of try_to_unmap_one.
>> Otherwise adjust the rss stats of the mm and jump to a label.
>>
>> Also rename that label from "discard" to "finish_unmap"; the former
>> is appropriate in the lazyfree context, but the code following the label
>> is executed for other successful unmap code paths too, so 'discard' does
>> not sound correct for them.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 95 ++++++++++++++++++++++++++++++++-----------------------
>>  1 file changed, 55 insertions(+), 40 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index a98acdea0530a..bd4e3639e26ed 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,56 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>  
>> +static inline bool can_unmap_lazyfree_folio_range(struct vm_area_struct *vma,
>> +		struct folio *folio, unsigned long address, pte_t *ptep,
>> +		pte_t pteval, unsigned long nr_pages)
> 
> 
> Similar comment: ttu_...*

Ack

> 
>> +{
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	int ref_count, map_count;
>> +
>> +	/*
>> +	 * Synchronize with gup_pte_range():
>> +	 * - clear PTE; barrier; read refcount
>> +	 * - inc refcount; barrier; read PTE
>> +	 */
>> +	smp_mb();
>> +
>> +	ref_count = folio_ref_count(folio);
>> +	map_count = folio_mapcount(folio);
>> +
>> +	/*
>> +	 * Order reads for page refcount and dirty flag
>> +	 * (see comments in __remove_mapping()).
>> +	 */
>> +	smp_rmb();
>> +
>> +	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
>> +		/*
>> +		 * redirtied either using the page table or a previously
>> +		 * obtained GUP reference.
>> +		 */
>> +		set_ptes(mm, address, ptep, pteval, nr_pages);
>> +		folio_set_swapbacked(folio);
>> +		return false;
>> +	}
>> +
>> +	if (ref_count != 1 + map_count) {
>> +		/*
>> +		 * Additional reference. Could be a GUP reference or any
>> +		 * speculative reference. GUP users must mark the folio
>> +		 * dirty if there was a modification. This folio cannot be
>> +		 * reclaimed right now either way, so act just like nothing
>> +		 * happened.
>> +		 * We'll come back here later and detect if the folio was
>> +		 * dirtied when the additional reference is gone.
>> +		 */
>> +		set_ptes(mm, address, ptep, pteval, nr_pages);
>> +		return false;
>> +	}
>> +
>> +	return true;
> 
> 
> Doing the set_ptes() in a function called "can_unmap_lazyfree_folio_range" is
> not appropriate.
> 
> Can we just leave that in the caller? We only do the when we return false.
> 
> And hey, then you can call this function ttu_can_unmap_lazyfree_folio() and
> avoid passing pte ranges. :)

Yep great I'll do that.

> 
> 


