Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D006CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E966B0088; Tue, 23 Jun 2026 07:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FC96B008A; Tue, 23 Jun 2026 07:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435896B0093; Tue, 23 Jun 2026 07:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8106B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:02:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82D40167096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:02:16 +0000 (UTC)
X-FDA: 84910888272.27.5D672C0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 81E5880016
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:02:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CHN+T5lu;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782212534;
	b=b9E1GPFRgqRIrQ/dwSpYZh8OU2QEMcoL3lTZSHDquEWSkdofUeN9xM7sobV6SNCh5jhiWJ
	oM5lo00vZyzYYbla+bZ8KmUU96aNXdrjY9H/npNgDtuQ1PFac8eWRSdNt1fQZ4mOKnQRRH
	5HqqRKHh0htnLb0IuagFYrbcKzQB/Fw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782212534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJ/TFjGz9/DEinmkZepeeG9TrmCfiFJujx696mgwKjY=;
	b=II5OWoZHBos2fgMwVcQgpQ54LqjQI/dtVMY/H6N2RnfQmPilOasQYqsu1NqhRAw5PTfOj7
	P45EZmHyM1o3NsBb2ggkR0fmnCbPf5YH45Z0auGdc/yhil14BF8LOLRI62FkVD4iu5+efK
	BiswObeFRdS69KmuOY8495nFXQZAWSs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CHN+T5lu;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAF6A1A25;
	Tue, 23 Jun 2026 04:02:08 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 503EC3FA1F;
	Tue, 23 Jun 2026 04:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782212533; bh=GA3eOKpoCqLuIqNPyhGE8RvBfQeG+XtuuDwgEsGyDMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CHN+T5lu9uqaWBlfC9XFYIP9gEtNlbd59Y5tDsxyeLKVy1rwTNvHuq9K/lycDrFMG
	 /eqxhJkf5W/Xu6D5Pff1URRz6EBcV1hauD5rYy6HsUlFaLAxX2pqjusjtxaobEwNKl
	 Fq8fBa4BNccam4GgZEevNwMdTnmYTM2ziuGYs9so=
Message-ID: <40576470-e0e0-4e7b-b9bb-be10944f75d4@arm.com>
Date: Tue, 23 Jun 2026 16:31:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/12] mm/rmap: refactor anon folio unmap in
 try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-11-dev.jain@arm.com>
 <645a5246-0f9b-4b93-9483-e6bba35f037b@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <645a5246-0f9b-4b93-9483-e6bba35f037b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81E5880016
X-Stat-Signature: yay8oa1p4ehkjp3qp5jrfzdou93g5cn3
X-HE-Tag: 1782212534-807879
X-HE-Meta: U2FsdGVkX1+Goa7N6Yok1mi/OtD6wg+gbCu/BEyd6HN4olVfN/Rje2J+SsEWHpRn1GlnKXsI+7OsyoCmOe1HfXX0xdeiwiceVFDh6A/Ip1TjaO1njAyUglTDJy9c3uo6GoyEmhGaedur+B/13ba18KfH0O/xQbkiI+YiyAPxklsnv867M+OjQe983S+fjJQTYutgdQqOFhLO5y+jF//zYcvWd/m1xW+FBBN1zJ4f6XFSZsr99HoeuHmROVk2l1Y++wYT3kax79FLzkZQuz3XsflJgsfo4/baF8NOEULREa2qWPA7T0g2SDtG8+Txheaho9HCQJmfq+EjKFRkb+PdhgPJwLXpdVSJTW7xfEdkB7Kha7OmJu1nDd0ZgYCgKxEM/A1GPsxG0rjucDnfxbBzAtJT6FlchgxmnMRXCglVLIlF9/k0zsF+HAg74KdW6xCNfPYcLBW46p/KCWVRU+rfU3cDCGZF66JYpSs5Ecjp5pf4S9TsH4f5M0Xd91syl0BgfzPV9Lya/Zzm2RS3GaNrE6i0t2gTSHtLM9OEFVX0XlomYRX8n4xDFFsY3eIhW8BDqZliUJKhdq/SFvYDYS+v5k2/QpY+BH8a8XTFmqvNJi7ei9L2MHg0OmdZAEyEy4jT38MnBopW9NBXSKdMGmTHHASGpH4Ft1hgeET2rAUgJx3AQ2MpOJ1t5BfdlB8QBJCMBIGu/RTVlmDumJA56xiSqfYSSccQNgPzOe/NIEj8WZZfnhNfKiddw9xm1x2Qe+XFdobXnfOYtZmk4QSUR8wQ5R1Yzpmm3DWvVLvZDE4qieUHnq1/Nyb6Fny8TO1C/v6GGb7A5ynPAirVIeZNZ3Qbu7tGL4u93HnLSIC5TzXjlHLefG4NMMXiWqie+/Sbx+KTELQaIWUfXvtvXe9jY3fq7WH/HHfmwCFCXqmbvECKUTn8bSdHmVwHXDv2F14NlaFjDpVXoQRepbXME1u2pFa
 0fVVTl6l
 ShO34Iv57JmN1SyYmaHcPmFYNAxEhmhjibsB+cJ+LpW+6kn97B+od1AFKjqVpLGrehqo86peXp3mLEKw0J78Kds5mAu8qFRZN3oeiy6uHuShYFVcfu1XJAj+bpo55T1DJvU8et+buWDQjKEtR7WJp+ksvOwTqIveVn+yWlIfwBhU+zwIlxdVbv2HHlOBq21UoEgjO/7im50+aeNR55FCpghJ22Hqmge6w+hDQbKiHZwW5P+crwiAfbkWR51Gj+YY40N5IntBQxhlMU7YHsZxYHy5QIXcCVA74oc9pB5o1giqNRh0IsWxGFElQVJ31lQStoXcePvrqtVMiGy34lYPvOHtbrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/06/26 7:40 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> Refactor anonymous folio unmap to ttu_anon_folio.
> 
> Given that the !folio_test_swapbacked() case remains in the caller, should we
> make it clearer and call it
> 
> 	ttu_anon_swapbacked_folio()
> 
> Or alternatively, factor complete anon folio handling out (incl. lazyfree handling)?

Hmm I'll see if this can be done.

> 
>>
>> No functional change intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 116 ++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 68 insertions(+), 48 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index c0e385882f562..b1639bad8e27f 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2136,6 +2136,70 @@ static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
>>  	return true;
>>  }
>>  
>> +static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
>> +		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)
>> +{
>> +	pte_t swp_pte = swp_entry_to_pte(entry);
>> +
>> +	if (anon_exclusive)
>> +		swp_pte = pte_swp_mkexclusive(swp_pte);
>> +
>> +	if (likely(pte_present(pteval))) {
>> +		if (pte_soft_dirty(pteval))
>> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +		if (pte_uffd_wp(pteval))
>> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +	} else {
>> +		/* Device-exclusive entry */
>> +		if (pte_swp_soft_dirty(pteval))
>> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +		if (pte_swp_uffd_wp(pteval))
>> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +	}
>> +
>> +	set_pte_at(mm, address, ptep, swp_pte);
>> +}
>> +
>> +static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>> +		struct page *subpage, unsigned long address, pte_t *ptep,
>> +		pte_t pteval)
>> +{
>> +	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);
> 
> "subpage" ;)

I'll change that.

> 
> Can be const.

Okay.

> 
> [...]
> 
>>  		} else {
>>  			/*
>>  			 * This is a locked file-backed folio,
> 
> Happy to see that function shrink a bit ...
> 


