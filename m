Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206CCC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC6C6B0092; Fri, 24 Jul 2026 06:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1939E6B0095; Fri, 24 Jul 2026 06:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0828E6B0096; Fri, 24 Jul 2026 06:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3BE46B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:01:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E2761C075F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:01:20 +0000 (UTC)
X-FDA: 85023227520.24.A426DE9
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8372F80015
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:01:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wKO0ndI5;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voqrEg3r3e9QhelQXK6ZueYqOeWiNE60rZ7RF6AjkmM=;
	b=jBXHZN9JlRe2Au8Sj/9PJAW0iDPusIxxFWTzFC0m34+hM7bL+9HusE+fuuDLzZ7ay9ggam
	WJfUsOuii8D0d5vUSWn0haZA+C/XpuMAV9AHS5/WJzCkFWmDk0ay0pD/0jqVlyzzWFEkL3
	6ZX+bxZ/VT8JY85fELshv4FJCqXme94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887278;
	b=uf1n7PnMxwGWgZeHF4GbRA5rVIkhrkNOfciSW4A/gsBMakoaBZ+PT6Bma6h9sYE6OWQQ3A
	Pgo27tSKmCvpP6nsV81WMlqHR0kNYtM6+bmKQ/NlAECkpq7X2gx7R8sFnkIND21m8ax6Bj
	W2mKoLwsaBpAAImqj8Gp/RQN5j8/rP8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wKO0ndI5;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <aaf20fc1-4e7a-4240-821a-e93342191830@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784887276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voqrEg3r3e9QhelQXK6ZueYqOeWiNE60rZ7RF6AjkmM=;
	b=wKO0ndI5P+SxBerYGRpL88BFHfWrfZiklFQfdL4AfajNHGU+zPOEIB1dJgIRvZjfDlfDY4
	zOGJEJshTj2ua5hAIzz0vfPVhZGaO25Y7k0ary/pB4hJVFn3WUKpH1bSbMdkrnH94oSjkm
	HCSSUODpDEChX8PDpTJpkxizIfNQ8qE=
Date: Fri, 24 Jul 2026 11:00:48 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 01/11] mm: add PMD swap entry detection support
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-2-usama.arif@linux.dev>
 <a3f9dba0-8ec9-413e-82a2-75f4f90911c7@arm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <a3f9dba0-8ec9-413e-82a2-75f4f90911c7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8372F80015
X-Stat-Signature: 8dmctszccnnz1tjsgr6jzanseyspe4on
X-HE-Tag: 1784887278-117694
X-HE-Meta: U2FsdGVkX1+4CQD9PT1lLt/lEXLDTG4F7BAARyjPFaQYH+TBxgkwGtQsEiCL9gy6sk01SnbS8GecTLZpMD0VSY4FOBpGp7Pe+WMFFHN4bZjs1Rd1gTs7oR/K/9kIi8NUnNAhoT1rnwzfvPKXNKgm8bp54C4mJRBRsJhMsX1bmr7+Ti72JcwV5+CwRqQPwtj+KLBEDxrzeV0A/ZoSUYgWC64zPe3B5EzdaGZi4CuMM+Njstb5Pffm6BdPWMjU2S9R3eH9YzOQ1IzZO54tZtiowzbZ8wZkgJMTMolVwew4MnIuGkXW6codUiHmo/wHlpkmRGdqGVOGPGnvE0lxHh91jZH9TEWc2DrM01utUwDSAh7XoI9TJgjAjeQgh+OyaJ7FjfcGb8V5Xd2fZnKRBQi9hpFsQwi7wqngxJyVysKzZNkAQlIzMKXftGmrC+YHp13vyLXU7h/5H5JfFOjdCQn9sU7Z3aVIXl80RyopfZdK3X6y0gDBK+OSglpRGgzdlPFuSN3YNJmpcQYa0ExF/h8xeaJyEMJwtG0M7p6BnfpbEeNUDtXed83FPRSo6mtNn11KfbRv1RcAZCozP2pyqnRqUpxryAfqaFMq3vtWR9et4N5MIT9Z9Vr60wFlhBFpfdU/b6IW7RohhcZmY2/wccd8V+I1yawh5OFj/iunJhu4+oFw9FNTYJ1+vk1mgRTK5VTvG9kGjysYWSfp3oiPs1P+NmLDdUnlzkJwyieyOB4zJnJ0aB/Dumvkue5Gx38As+JcXoNdnuicjw6gAUWzAjcL8Xi6c01xsdHyePL4UFMxSg42Todp6pEDOqw6QLUGYXDX67af3DxWzlKvcJ80OUlD1lVwVbac7agojJa3/La99EDCGElNsjv2yR3TEtqm81AgpkvI6DWdN+Mj/99/CX9GMZd0oK3N7TB99cv4AajroeJhzBK/JIzPYYLxQDskMSxKVGhiZVZpCEh4RN7Unog
 3trsU0YV
 8XuIhWBUJCn/JGzpsqcngg2PNBqO9pyjR7xBOQjEBc938/K4bc3Oyen5Au6q+pKN8Xwq14j0utFfDSwT9pxoPzGzHgS1PlKZPY4RNXGcRwp3ua1FmA1ZkHyN5Aq0MCmvNnpOPBpp5Vmm8vaw13jlIPUrtIXKDE9HqNrNrXYZQCLKJA91YqhgvPtYTvFot1+i6TBXHUnr+ajKSuH4XVirVssjYIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 07:10, Dev Jain wrote:
> [------]
> 
>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>> index 4c1476ae3234..8397193ba399 100644
>> --- a/include/linux/leafops.h
>> +++ b/include/linux/leafops.h
>> @@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>>  		pmd = pmd_swp_clear_soft_dirty(pmd);
>>  	if (pmd_swp_uffd(pmd))
>>  		pmd = pmd_swp_clear_uffd(pmd);
>> +	if (pmd_swp_exclusive(pmd))
>> +		pmd = pmd_swp_clear_exclusive(pmd);
>>  	arch_entry = __pmd_to_swp_entry(pmd);
>>  
>>  	/* Temporary until swp_entry_t eliminated. */
>> @@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
>>   */
>>  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
>>  {
>> -	/* Only device private, migration entries valid for PMD. */
>> +	/* Device private, migration, and swap entries valid for PMD. */
>>  	return softleaf_is_device_private(entry) ||
>> -		softleaf_is_migration(entry);
>> +		softleaf_is_migration(entry) ||
>> +		softleaf_is_swap(entry);
>> +}
>> +
>> +/**
>> + * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
>> + * @pmd: PMD entry.
>> + *
>> + * Returns: true if the PMD encodes a swap entry, otherwise false.
>> + */
>> +static inline bool pmd_is_swap_entry(pmd_t pmd)
>> +{
>> +	return softleaf_is_swap(softleaf_from_pmd(pmd));
>>  }
>>  
>>  /**
>>   * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
>>   * @pmd: PMD entry.
>>   *
>> - * PMD leaf entries are valid only if they are device private or migration
>> - * entries. This function asserts that a PMD leaf entry is valid in this
>> - * respect.
>> + * PMD leaf entries are valid only if they are device private, migration,
>> + * or swap entries. This function asserts that a PMD leaf entry is valid
>> + * in this respect.
>>   *
>>   * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
>>   */
>> @@ -673,6 +687,8 @@ static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
> 
> Nit: This function really should have been named "softleaf_pmd_to_folio", or
> "pmd_softleaf_to_folio", perhaps throw in a patch to rename?
> 

Sounds good, will add a patch to rename. Lorenzo any preferences here for the name?> 
>>  		VM_WARN_ON_ONCE(true);
>>  		return NULL;
>>  	}
>> +	if (!softleaf_has_pfn(entry))
>> +		return NULL;
> 
> I am guessing that after the later patches add swp support, we should
> never reach pmd_to_softleaf_folio() with a swap entry, in which case,
> we could add a WARN_ON_ONCE() here. (didn't check if you have done that
> later, just writing this here)
> 

Will add a warn. This was one of things sashiko pointed out to add.

>>  	return softleaf_to_folio(entry);
>>  }
>>  
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 8c093c119e5a..e10a7e91e426 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1917,6 +1917,23 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
>>  }
>>  #endif
>>  
>> +#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
>> +{
>> +	return pmd;
>> +}
>> +
>> +static inline bool pmd_swp_exclusive(pmd_t pmd)
>> +{
>> +	return false;
>> +}
>> +
>> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
>> +{
>> +	return pmd;
>> +}
>> +#endif
>> +
>>  #ifndef __HAVE_PFNMAP_TRACKING
>>  /*
>>   * Interfaces that can be used by architecture code to keep track of
> 


