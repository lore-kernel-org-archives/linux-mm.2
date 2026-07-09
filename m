Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501ECC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6EA6B0088; Thu,  9 Jul 2026 09:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577C86B008A; Thu,  9 Jul 2026 09:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DB46B0093; Thu,  9 Jul 2026 09:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8876B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:34:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8A38140189
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:34:22 +0000 (UTC)
X-FDA: 84969332364.03.AB8AD55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9AF87100007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:34:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TqMFrkLg;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783604061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GR48i8hlkB2Ze3PQTDUSFwKBjcFU+CD3y6+0ixlT14=;
	b=VnpLSPLwCg2UDcnDlQQF2kWyiaB5jXRMIDI46wX1+9s996OG3LvPE3TtQ3SZ/AXfPkpH21
	tkij42Zr4FflpOUo3dT8qBQJWGBUeWaWv6JVy3lzAbb2dcvb+ZBvgrdb74W0uT+3rIQHva
	7IuXyegFZL1syFsPe/kSHBdWw5oRytw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783604061;
	b=5vSaRjzLxCqRoi5jBTT8Tv2ghpM4s3UwZNwCSanZJYxM/mr5Zezbq0H9iEDEMz6tcSn/yE
	JfLswxbtisyx0tDgx2sWrkQHzThgmhRu8DtaphkumlLxPrZM4+aqv8o9Fm+KibU+RlsW9b
	H95VodQjdfL2VFc5nC9JErHGXvNwCsE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TqMFrkLg;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C9D23592;
	Thu,  9 Jul 2026 06:34:15 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B5FE3F85F;
	Thu,  9 Jul 2026 06:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783604059; bh=UCBoGFyvDS7VXUCq7xWi4MDCI+kdI7sbuLuwaKPwTdk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TqMFrkLgbznn2mQhEGHlE2P5owjWK614V8M6f7dmsfN6b/aZqzS3C9G2/3EVQbwL9
	 5nXcygHeAUw+ndJ4HzjTw6LGTQ2XqyTzpnkiahKBKxHqYeq/DwbtR/gsPmPH5aLGR7
	 j6gPVUumSswrNs0QlNddls9HTFGWSTxztXsTCnwk=
Message-ID: <32c60952-4f80-4cd7-8fe7-003262f09a12@arm.com>
Date: Thu, 9 Jul 2026 19:04:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/rmap: add anon folio unmap dispatcher function
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-6-dev.jain@arm.com>
 <50b0de85-0bb9-4d09-b32e-31a3a4661379@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <50b0de85-0bb9-4d09-b32e-31a3a4661379@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9AF87100007
X-Stat-Signature: sy3x91pxgcss5wxmcbugibsn3krdxp57
X-HE-Tag: 1783604060-794262
X-HE-Meta: U2FsdGVkX1/Vg2ldY8BTzADhUKXOd6R67N5/GrSaVGiSElGRptN7aQdLjvevbabuqR77i00vlsPwY9R0PfnwOqlJtl/eDdhQhJYFyHAWz4RmBkfm9aLFes1M8ypETJRYSeBl1Un7T8/aomZ1tAwsEdE8RoItOmIBIE4ykdlm2zPN1DipQzjXs3ADYlHMbMLqh4JRrrfcEHz+xRF/6mPdkdnYOhXt8apm/w/ocWbTxVt3vlnM+jbFrfrt7BhuFEIRpOaJRiKqBGJGTFi3QlbLyzo6tY1s8CooSyMueV7ZhASdrW0VazTx5oDojomLxMJgOKeBEUpsMJe0z+qK3zzgX+TA5UJwibP7tG583UbOWbnNoXc4msnyvVB0FGdUSocMabhaN+StkTM14uJGOj/GoDljr7LkJvVW7BL0vWy5h4tkJBFC1zcKgLcX8CtI8vR2HcWvYJAUHYLj02pEqiPKdmH0gDAj4uUYqOmwxr7Pmiu31peLPpuAo/4J2znwJM3Yj8LWIgHtLY1F8onQQjg1xeJx2f9GM4KKmkrFdpBLzJdHAcjU86s7yUEQN0yUe/rauD1qoYYpmuobON11+zSS7tugp5bVBVc7drWDPKdy3UsXVxO5jbcfh+XkXnzS0tyvKYkqWwRNWSXcPp3BE4+ATcCB9X+tHk+YPF+32EYBwIgQ6Km9uqx7DFIMwu2ffhCcX6J7pswYaEypeSHhR7/W9bDeRFw2CbJHT/CI7TwaSEvW+IwRX0uhjHlSHvsNflRuVo+XnDaefJ5BM2Emc33uNewUJZV04RCPH2NjB2c+Ce9X/oKFX/95MmbmAXx7uyv1riZmqlhCJPfaH0u7CrYfscJdY7fLu4QF4ZVFKZqFz8BgPvGH7E3yPKKuTjqz2JeXm+HeHqdbsLWCoD0uvFCDty+trge7WFkwnrER4EF2jRaBGMqZkqSdEOWoPU+mgopio0pbuv0nDuwb3aKPY37
 GE6BsvIb
 rHvB3q6VUsSKDYTRr7hVaIIS6GPla/wAovZ5IQr5bpXscwGDgXHRMklaXnx+tckpOjfVpva4pZX5+P6uuIc+9mT4aa+3FRwykz26d5hcWrsITLY0hKpXVHpZ7bOOR7eSbobMm328jDWH0YsbvxpxUwMgIfyNbnQ0cvGkP9ESrDxh+e2/gbhoA+WegjevBFBnuPPlO/BZtNcFoEji0qmciL657Thm49Fy8d5+WXLvWonEVxHkU51HSGYWpnE/aX2a0yzY9o/tUcFyXp2J+zw7Ac6EvcJG2681KaA2/nTWalX+qJlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/26 7:58 pm, David Hildenbrand (Arm) wrote:
> On 7/7/26 14:11, Dev Jain wrote:
>> Add ttu_anon_folio() as the common entry point for anonymous folio
>> unmapping. It dispatches to the lazyfree or swapbacked helper as
>> appropriate, and centralizes restoration of cleared PTEs on failure.
>>
>> No functional change intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 59 +++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 36 insertions(+), 23 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index ade78df5be2bd..f021ecd51a4a2 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2171,6 +2171,40 @@ static inline bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma, struct
>>  	return true;
>>  }
>>  
>> +static inline bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>> +		struct page *subpage, unsigned long address, pte_t *ptep,
>> +		pte_t pteval, unsigned long nr_pages)
>> +{
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	bool ret;
>> +
>> +	/*
>> +	 * Store the swap location in the pte.
>> +	 * See handle_pte_fault() ...
>> +	 */
>> +	if (unlikely(folio_test_swapbacked(folio) !=
>> +			folio_test_swapcache(folio))) {
>> +		WARN_ON_ONCE(1);
>> +		return false;
>> +	}
>> +
>> +	/* MADV_FREE page check */
>> +	if (!folio_test_swapbacked(folio)) {
>> +		ret = ttu_anon_lazyfree_folio(vma, folio);
>> +		if (ret)
>> +			add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
> 
> Can't the be handled in there as well?

Okay.

> 
>> +	} else {
>> +		/* nr_pages > 1 not supported yet */
>> +		ret = ttu_anon_swapbacked_folio(vma, folio, subpage, address,
>> +						ptep, pteval);
>> +	}
>> +
>> +	if (!ret)
>> +		set_ptes(mm, address, ptep, pteval, nr_pages);
> 
> It might be cleaner to do that in the caller, where we actually removed the ptes
> in the first place?

Yes.

> 
>> +
>> +	return ret;
>> +}
>> +
>>  /*
>>   * @arg: enum ttu_flags will be passed to this argument
>>   */
>> @@ -2351,31 +2385,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  			 */
>>  			dec_mm_counter(mm, mm_counter(folio));
>>  		} else if (folio_test_anon(folio)) {
>> -			/*
>> -			 * Store the swap location in the pte.
>> -			 * See handle_pte_fault() ...
>> -			 */
>> -			if (unlikely(folio_test_swapbacked(folio) !=
>> -					folio_test_swapcache(folio))) {
>> -				WARN_ON_ONCE(1);
>> +			if (!ttu_anon_folio(vma, folio, subpage, address,
>> +					    pvmw.pte, pteval, nr_pages))
>>  				goto walk_abort;
>> -			}
>>  
>> -			/* MADV_FREE page check */
>> -			if (!folio_test_swapbacked(folio)) {
>> -				if (!ttu_anon_lazyfree_folio(vma, folio)) {
>> -					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>> -					goto walk_abort;
>> -				}
>> -				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>> -				goto finish_unmap;
>> -			}
>> -
>> -			if (!ttu_anon_swapbacked_folio(vma, folio, subpage, address,
>> -						pvmw.pte, pteval)) {
>> -				set_pte_at(mm, address, pvmw.pte, pteval);
>> -				goto walk_abort;
>> -			}
>>  			goto finish_unmap;
>>  		} else {
>>  			/*
> 
> Very nice.
> 


