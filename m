Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E52C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA5A6B0088; Wed,  2 Sep 2026 12:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2386B008A; Wed,  2 Sep 2026 12:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAD06B008C; Wed,  2 Sep 2026 12:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7426B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:16:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A67D416028C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:16:55 +0000 (UTC)
X-FDA: 85169325990.01.E5A76AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 886AC14000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:16:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GzQ39Lln;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788365813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYVnLyOaTgHPP6xz/UHsXg+cvDAjK8CW3IzfuxYWXPc=;
	b=zKKxs32GlZ/ecvGMwSBfQU6mRsA+T73lwuTER80VMDKe+uEKdcZTk2FVGWWmeOVJpJO81S
	UwzWHGHXjCOtwLrzKZcPslFcZ7SCCoJdXg2kLlhhRe0z0DgvSlmpUYuYsCob0VQh/NyOcG
	1FwrwGolS6q8PJ5gEhP93v3g9KAurv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788365813;
	b=lsnSTaNvX2EMbvbbiSNGqMFJNjI23U63EgXfvnvuRBAkI6Uq3G8w+01Fl9pdvs8DrgiE7F
	sGzfmAl7pQFMmFQDm2DvicuYhVIPCXdlWxuv6eM5QcJyXyBOZclCvVBxgCRb90xwJzvsNG
	yeMJGT2G1Ps1QuEsG1a4OJbArhvSLls=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GzQ39Lln;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9862165C;
	Wed,  2 Sep 2026 09:16:48 -0700 (PDT)
Received: from [10.57.81.239] (unknown [10.57.81.239])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CC9B3F882;
	Wed,  2 Sep 2026 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788365812; bh=gSEvBp+KCkXzHc8dbTVfAUkWIju2bmeIwgUNZoB5Jt0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GzQ39Llny2ZuYBIRxqfmTLFB8+xgcnuApQeVF7Znpj2TjYxDzgeaV37nuH25mn0rx
	 KqEIpkSwP29+sHWsyfh1SSc4Iuv7/CcNnzDIC/mdocDoDWU2tgWauk+y1MvmzYSMU+
	 40g6i1Xs00gK1gmyV5Y8FC4PEHfJOL8ZxTLS8jno=
Message-ID: <8e9f7967-710d-4548-89c4-8e5ba46d8714@arm.com>
Date: Wed, 2 Sep 2026 17:16:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
To: Dev Jain <dev.jain@arm.com>, Karl Mehltretter <kmehltretter@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901131823.15799-1-kmehltretter@gmail.com>
 <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 886AC14000C
X-Stat-Signature: 81qxdhcuiz8muwpjemq9pjecbur5awjt
X-Rspam-User: 
X-HE-Tag: 1788365813-681376
X-HE-Meta: U2FsdGVkX1/29ekbdbgw3/wq4kYyHlLnndEez/5y+kus1VxSVKynZr223yyCeCyfBeqfsmRZ0BhCO1cerubUdoytzpMbmmAhDrn9hykP9/u8xYGfA4IPZdDGyLcDf8R6g9wyRnyEOtIW0ia3T4urg/IEUZJcpARPjhqK7SbYpcn//jHeqtRA/BBjZyyMY7UkYT/pV/3/5llgyM9EPlnBwrlwVXkQjH9kQ4kij/CGtF8q9iahcFkJ1wNd/B+h4r4yORbaW8Q6elz5gsa7cnYvnMAb456I+Hzkb0QOTCVQyD78dD1RmvYNFJX/435AmrJTILz5ljh7c3DR1Sd8DbFE/ogdRB5ODrNk2McoMUzOUNSOxQvatkM9gGuV/sS/K4UHOd5Psiv1qjptOZT3nEJy9x1iqdZVZnuKxs3ye8Xa4kVMkMfbYe1KmWfVeKKRMgZyjkp7QNtKgTFmr/NJH23u/wWj0TOzCYuV5mEkbU3U+1Qke8FG9go/pasRKaFoNvKg18vZCSWW6Xsxdhv5IBzWJrhGuGe7NhcsKirjA7aTVl0Vv2oF+JGiR+ZwyZPxh4C1wgiqlLpkVioBTWcsGdOO5pryk8POI/v8isQ6dU2h1XMlKynFMAochPUSJsc0WQANFDqQRTDdHaQ/oP2UZHwL0BHHOD2tXp+wJNw7PPUlYosctUUEFtXOnOXnvLPEjR7sWPbmrkcJd4fFiCuIGzmY9RBOGUijXMj2B3YvGIFlE0frhF7h9/rwN/KT6sl9XuoVZCfhEJSCgVbkeS9PrJFl5WuHGGc2y6etXzPfH0op3w7IUQRwTSjoDH4yerkuDHmYszKNDeMabN4SHphaAAkPLwljsFxNDd2Y7yFBGWzZs1EwbFFnk6oJGEHOciAMUldqyf6MNcv4ixVc8SFtN+xfHRHQdfnzCgUhp4Kf9qBTf8y0W/+cdQJR/GqwqdbISjVEFEUsn8zUwpoNn1WB11k
 vISWEmSr
 8mu9O2fvlqtIGETo6fZE2fBOrV5TiT7vGZ//vyJUWWfkOLDXk3fT2rnjqSG454z6AsE+vNZ9NuXi6fAdCihOrIUpRy8scZo3Sb8pv5P9V3CdypAvkNq/mjt5CEbqlEQx6Lticw196oJA/sFiwQ27b0Z1gem0pa7OTPR5+ZGNQA8sP7okr19gjvno+EubWQY5QKJfbwpwjacuV7xLwaOd+vDFHzWHmuXeLM+WQ7QDX/5ydUgtdP5dQgLrn4+xWpCV25kopvpMU8S3AZBLO3kfxXW2zW0d5mP9iKYhC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/09/2026 15:46, Dev Jain wrote:
> 
> 
> On 01/09/26 6:48 pm, Karl Mehltretter wrote:
>> huge_ptep_modify_prot_start() clears a hugetlb entry before changing its
>> permissions. For contiguous PTE mappings, break-before-make (BBM)
>> requires a TLB invalidation after clearing the set and before making any
>> entry valid again.
>>
>> Commit fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from
>> get_clear_flush()") removed this invalidation, relying on the deferred
>> flush from the core code. Commit 410982303772 ("arm64: hugetlb: Restore
>> TLB invalidation for BBM on contiguous ptes") restored it for
>> huge_ptep_set_{access_flags,wrprotect}(), since a deferred flush is too
>> late for the break step. The modify-prot path has the same problem.
>>
>> Use huge_ptep_clear_flush() for contiguous entries so that the TLB is
>> invalidated during the break step. Leave huge_ptep_get_and_clear()
>> unchanged because it is also used by teardown paths, where the deferred
>> flush is sufficient.
>>
>> Fixes: fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from get_clear_flush()")
>> Assisted-by: LLM
>> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
>> ---

Is there a user-visible bug here? Or is this just AI-assisted hypothesising?


> 
> The transition happening here is:
> 
> old_prot+cont -> zero -> new_prot+cont ... (i)
> and then TLB flush.
> 
> Arm Arm rule R_JQQTC says:
> "For a TLB lookup in a contiguous region mapped by translation table entries
> that have consistent values for the Contiguous bit, but have the OA, attributes,
> or permissions misprogrammed, that TLB lookup is permitted to produce an OA,
> access permissions, and memory attributes that are consistent with any one
> of the programmed translation table values."
> 
> This implies that a live update like
> old_prot+cont -> new_prot+cont then TLB flush ... (ii)
> 
> is safe. Which should also imply that the transition (i) is safe,
> since the configurations the PE can observe for (ii) is the same
> for (i), except that in (ii) the PE can fault too, which is fine.
> 
> Upon discussing with Ryan I got to know, he was implementing the
> contpte stuff for non-hugetlb user mappings and that basically
> drove a clarification on the semantics of contiguous bit and
> this rule was added.
> 
> If you see currently for non-hugetlb mprotect() we do not flush
> during contpte teardown.
> 
> So if the above reasoning makes sense, I can infact audit and
> remove the flushes in the hugetlb helpers.

I agree with this analysis. I believe it is safe to elide the intermediate flush
in this case (as is done in contpte_wrprotect_ptes()). And I agree that we can
likely remove some existing TLB maintenance in hugetlb helpers.

Thanks,
Ryan

> 
>> An instrumented QEMU detected the missing break-step TLBI on an unpatched
>> kernel and none with this change. A fork() control exercising
>> huge_ptep_set_wrprotect() remained clean. No user-visible failure was
>> reproduced.
>>
>> The QEMU checker was exercised with 4K and 64K base-page kernels. The
>> patched kernel passed the LTP hugetlb tests with both -cpu max and -cpu
>> cortex-a72 (16 TPASS and no failures).
>>
>> Testing on Neoverse N1 hardware would be welcome, as it can use the
>> contiguous hint and can be configured to report TLB conflicts.
>>
>>  arch/arm64/mm/hugetlbpage.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
>> index 8e799c1fe0aa..bb53a04b73b2 100644
>> --- a/arch/arm64/mm/hugetlbpage.c
>> +++ b/arch/arm64/mm/hugetlbpage.c
>> @@ -517,6 +517,11 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
>>  pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>>  {
>>  	unsigned long psize = huge_page_size(hstate_vma(vma));
>> +	pte_t pte = __ptep_get(ptep);
>> +
>> +	/* The break step for contiguous PTEs must include the TLB flush. */
>> +	if (pte_cont(pte))
>> +		return huge_ptep_clear_flush(vma, addr, ptep);
>>  
>>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
>>  		/*
>> @@ -524,7 +529,7 @@ pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr
>>  		 * when the permission changes from executable to non-executable
>>  		 * in cases where cpu is affected with errata #2645198.
>>  		 */
>> -		if (pte_user_exec(__ptep_get(ptep)))
>> +		if (pte_user_exec(pte))
>>  			return huge_ptep_clear_flush(vma, addr, ptep);
>>  	}
>>  	return huge_ptep_get_and_clear(vma->vm_mm, addr, ptep, psize);
>>
>> base-commit: 786262be6048deab760f68c8acc2c85607165894
> 


