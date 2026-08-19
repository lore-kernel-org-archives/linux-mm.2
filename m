Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C4FC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3826B0092; Wed, 19 Aug 2026 08:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9847B6B0093; Wed, 19 Aug 2026 08:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A6F6B0095; Wed, 19 Aug 2026 08:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 637196B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:31:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07A75A3077
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:31:21 +0000 (UTC)
X-FDA: 85117954362.02.5B50914
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE10280002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:31:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8RM31S+;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787142679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MaZp52pNU2YHMavbnuh9omfFFIHGmVebnILpi5GdcI=;
	b=2NO89DVeTJhbhco/xu7rN6hywhqbWV+zGZ8DTezPZjFW2+cy3FqOAPgzNx5K91U2GYqK/Z
	oyhZtBv0T5ZAFlg6luMNfrn68w/PMVtX+/pmMZlr3HtFBaeOcAaqOlL7qkfBgnoU71d4Gv
	KrDtyYR8H9LRY5sTL+zZMoWPgbCSgLQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8RM31S+;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787142679;
	b=vL1/Hq0tEQu0H8Qld4SZnzc8rB1yVXw+P59873Tcl187b4+2VDQgh73EaFVmFP+VERsHIi
	gksd4W7poZP4Gu4NcKFuKqXgFIxOB3J54Nc9720kugqKDMipAzu+zdwkQbGp4lbUCly5Ju
	/Asz+PfdL8b6WVddyz67+akQWMpy2gQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/otDFlr1rhHbSmXliBx4mVZMc6saGUTu0UfzxL4rnTc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787142677; v=1; x=1787747477;
 b=b8RM31S+GrsFhcDwEhFpTN7iMKzN1WcQtXiXHa2RtwNLYSWzi4TmVPP/O77Ei47Cz7yMiUi/
 9tRk0N7dpCb0qHV6ed6QLDmPwr6mSAqfktUxe/MgGJ7en71hf59LuzUx+/Mv8J7JpGZ01YJPdhx
 atgFRntPIm4RM+fV2EtQu3bA=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::4:a428)
	by smtp.migadu.com with ESMTPS id 24c9a4ea09970955;
	Wed, 19 Aug 2026 12:31:17 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <5baead5e-b9e9-4850-9ce3-e48a2e5db2ca@linux.dev>
Date: Wed, 19 Aug 2026 13:31:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
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
 <20260818131202.494754-3-usama.arif@linux.dev>
 <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gorkkwdcg5rfjmeki3ksy933cm3ziktq
X-Rspamd-Queue-Id: AE10280002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787142678-972585
X-HE-Meta: U2FsdGVkX1/gf3Kb5e4W+/uRQ0sftzzjfisvza6OvczEnPOnGRmERL+NeHdbC3oQ6/l1r/zWhxNCuRE0cEDWk/jc1r733YnOcBvY5MEecPHjDdoLkb8KkVyPAUc7LRHLxA1IsZ7Yu0f2VNnmnGJE7kDCjAk6IPiLmzrYNeF7Eha4c6TX7rsYUOTztmVjCDVuw2KxBDH4foLMGaArjNyfJVBTFdCq988PwcPJA25onHhTCHyNL9HmWkRFQtlo0VfQx/xPq0LRaDqr/fiw2Qt6X6jqd0uVkaCMXpb24U5aHMRdvwyP4UuWOs9trQx4hyepEqq9fY8BKFmMfkyLyo0PqLg4+dUL6Xry9jIcxK726v4GmfzEx/hk0cgmyAn5NSk0hdYrn9qI57KtDQiXPSOtFlaq7mxcE+6uZWe3UlGjgyCG8aLRgPwajZqJ+nfg79Ht6f/ryUZdrL2Kr+TK9w8rJ4koqA7usjqo1JwhYgqBXZgGaa2q25iHk13opHqC5B2smvmDjE1gLGhF0/mTYa8Mzr0e8e/IiaRWguPJ7yJbgu5zifNBC7jPOK/Q5RORhsZnHDLFcQgJD8jmmGCUTGr9cECa/9+ZwwiXwE2nQ/eM/0U3pA3TRCsCaGFh8rdsmoxIxPUafocp2oYmZ33WaRzzN+H2xSWfYKkZB8qfhq0zdUDjQ4wH4PMY7nJpa4ti9ggGsG2Zsv34m/zwzzG+k7lx2iw4dRKNS/lvBqASVXdauCK8KS+gD7mxZlQhYKTB3CnjIe9hKRmMN/oUQAIq60sBc+t0fAV/5v3jPVooRLi15b4ct8WKeFLI9ndIrEEB6wY+AA3wDFg1jI1gU/F8RlASgPA0nyH9vbrA2TU4B/H0NoYipoqTCSyQA6G4sX32OvPUb8i0t07Ou67hCl5fttL2w+nTBMy1BPsvTMRHGECOV8x+Yt1IOYN2YvJ4w/kXVfmOAu3TL2Oy/GK3Kk1PCip
 wOLJVYA6
 LUfC5QE2S/5yjaHA4KqnDqN4saiVbeOL0UuXqho0q66p5Xj29XPmA7YSEuPfzrotPlELmgK9PNX0BzBnx1G+U5S9i0qguzD3cuLHdjSMbkDTww2Gv9JAD0CIcNPKPHu2tGF20OFIjT8CxZBcK59KUjZVUb7jHXGfWwUkWbD3YZR5pyAPTOVyrBX3/sUVBgVIJ/Btr2VmhdsNEwuqNxUb8D19MiYID4u/mPEbyAkIR0RkYtEOL4Mc7Dg7eevIqqkomdWxd1POyfoFdVOW4n7TQN8Nw/vwHlYGT4amezxTv+Y52RgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2026 15:40, David Hildenbrand (Arm) wrote:
> On 8/18/26 15:09, Usama Arif wrote:
>> Currently when a PMD-mapped THP is swapped out, the PMD is always
>> split into HPAGE_PMD_NR PTE-level swap entries. To preserve huge
>> page information across swap cycles, later patches will install a
>> single PMD-level swap entry instead. Add the infrastructure to detect
>> those entries.
>>
>> Teach the softleaf layer to recognise PMD swap entries:
>> pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry()
>> accepts them as a valid non-present type. Because swap entries do not
>> encode a PFN, make pmd_softleaf_to_folio() warn and return NULL for them
>> instead of passing the swap offset to softleaf_to_folio(). Clear the
>> exclusive overlay bit in softleaf_from_pmd() before decoding, matching
>> how soft_dirty and uffd bits are already stripped.
>>
>> Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and
>> pmd_swp_clear_exclusive() helpers to each architecture that supports
>> PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc),
>> mirroring the existing PTE swap exclusive helpers in each arch's
>> pgtable.h.
> 
> Ah, for migration entries we still use a dedicated migratetype. I actually have
> on my todo list to move to PTE bits as well.
> 
> (likely the _swp_ part should then be renamed to indicate that this is for
> softdirty entries, not just swap entries)
> 

Agreed. I kept the pmd_swp_* spelling to mirror the existing pte_swp_* API.
Renaming the broader softleaf API is independent of this series. Maybe I can
add it as a followup?

>> Provide generic no-op PMD swap exclusive fallbacks for
>> architectures without PMD softleaf support, matching the generic PMD
>> swap soft-dirty fallbacks.
> 
> No softleaf implies to migration and no swap, so this would work.
> 
> You should extend mm/debug_vm_pgtable.c in a separate commit to test what
> pte_swap_exclusive_tests() tests for PMDs.
> 

I have added this in my series, and will include it in the next revision, Thanks!

>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/arm64/include/asm/pgtable.h             |  6 +++++
>>  arch/loongarch/include/asm/pgtable.h         | 19 ++++++++++++++
>>  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++
>>  arch/riscv/include/asm/pgtable.h             | 15 +++++++++++
>>  arch/s390/include/asm/pgtable.h              | 17 +++++++++++++
>>  arch/x86/include/asm/pgtable.h               | 17 +++++++++++++
> 
> I'm sorry for asking you to compete with Kiryll's series by creating one patch
> for each architecture that directly jumps at arch maintainers :)
> 

I have now split the architecture helpers into separate patches, followed by generic
support for the next revision. I think I will need split patch 7 and patch 12 into
several independent patches as well? This will significantly grow the patch count
which is what I was trying to avoid as I feel that makes it more daunting to review
(atleast for me), but I will try and keep it under 57 patches to not beat Kiryl :)

> [...]
> 
>>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>>  {
>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>> index 7c13c58a5e218..4a6c52974b305 100644
>> --- a/include/linux/leafops.h
>> +++ b/include/linux/leafops.h
>> @@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>>  		pmd = pmd_swp_clear_soft_dirty(pmd);
>>  	if (pmd_swp_uffd(pmd))
>>  		pmd = pmd_swp_clear_uffd(pmd);
>> +	if (pmd_swp_exclusive(pmd))
>> +		pmd = pmd_swp_clear_exclusive(pmd);
> 
> Can't we just unconditionally clear these flags?
> 
> pmd = pmd_swp_clear_uffd(pmd);
> pmd = pmd_swp_clear_exclusive(pmd);
> 
> Avoids these rather unnecessary conditionals unless I am missing something.
> 

Yes, we can, will do in next revision.

> 
>>  	arch_entry = __pmd_to_swp_entry(pmd);
>>  
>>  	/* Temporary until swp_entry_t eliminated. */
>> @@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
>>   */
>>  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
>>  {
>> -	/* Only device private, migration entries valid for PMD. */
>> +	/* Device private, migration, and swap entries valid for PMD. */
> 
> Can we just drop that comment? I mean, it's as clear as it gets in the code
> immediately below :)
> 
Will do in next revision.

Thanks for the reviews!

>>  	return softleaf_is_device_private(entry) ||
>> -		softleaf_is_migration(entry);
>> +		softleaf_is_migration(entry) ||
>> +		softleaf_is_swap(entry);
>> +}
>> +
> 


