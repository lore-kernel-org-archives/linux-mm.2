Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F05C624D7
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34456B00DF; Wed,  2 Sep 2026 10:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4636B00E0; Wed,  2 Sep 2026 10:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE116B00E1; Wed,  2 Sep 2026 10:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C04D6B00DF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:46:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 105C412022B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:46:47 +0000 (UTC)
X-FDA: 85169098854.22.F0C851A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id C89F680006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:46:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jvI70JcD;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788360405;
	b=8IJH95pSdLA7+FNpQAxee393hu2EvExu3lIzHzYzifuzOOBjfk3l8P0bO5JNgMRt36AJcg
	QmdC7H7/83HlVSDcMTHQWDB3Z2nwAICUKdmTvxiw32eAh1lhFAKV2eTiunCSocKumFI2/q
	h94ROwO36nBlTFA4Jm/TnpgVQzFRJdc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jvI70JcD;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYU+O8tH6ddjuKuIyKG0rIQmm6c4dFEaktP1321/JLM=;
	b=eL9UNFNwY2QKqvN4PeS1+UqKEhteqoZcCdRLY+P9r2NZN70tKadJw2pMrOJHrbNKat/yDq
	3WnlAYxbYA7jSG4D64UVEfoBA6sTBhCbb2rs1Vu1b9VMuTAAa7aNxvapyu0I6s6Ip2eUjw
	E/jftBqYOnURaAsvybb67VDfSfrc/6s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC121165C;
	Wed,  2 Sep 2026 07:46:39 -0700 (PDT)
Received: from [10.163.139.162] (unknown [10.163.139.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC2563F882;
	Wed,  2 Sep 2026 07:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788360403; bh=4kU6Krr/DSsOOXv7Su9Lbn9NoAbl1D9sLwJpgDYFVDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jvI70JcDjiBJBSzybsRgh2PieiSUiVJBFEdooazcZU6T5xFX1kVI4K0rNLoO5rZ7C
	 CWRj3jIQFnuyBFv96ufuwwBCeKU+nTGj/gCBnt3Zy0B/UOjmPa8TQrFnDorqKajuwQ
	 9N3rXcYDbqICpZhxQm6nR2RvB9KmJucomXGwDR4Q=
Message-ID: <551663b9-d031-4755-af7f-dc6c22524b35@arm.com>
Date: Wed, 2 Sep 2026 20:16:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901131823.15799-1-kmehltretter@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260901131823.15799-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zukm3cpktwzg1dy5oe3strqkd4g6s55t
X-Rspamd-Queue-Id: C89F680006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788360404-425527
X-HE-Meta: U2FsdGVkX19W5A/uY6jNHcdGMDAxImf8qXPKZqc4fp3sWu08b/TTUxKw6Ni0dD/+MypqA8STkm/rfgWDbVGh45GIcSDCG5ujh5a6udjGnT1aAw4XD+bK+zTtnH1FhkcCw+yx1o3NJVO5/t1xfBNRbgu7ouQjpTc2T8+zxA+EuHFlTcm4tBJA6obWpzxM5KIRr9hMD55Gw+iqDV5ckWwOz9cjfmT5XTb2EEKcrfukXpJF8iglu4F93Tg/ocPFQhoeteoRji3AVakAjYhpxiPSVaYUL2D6MQyWVMOCs2LAhjhE8h8bdPQDquZx5lgMOGCx5zAjzMisdpzm4WHuigaaPwkQ2nGqSrzq4OcbWDDADNjqq4Vrh84GJ7fmf5EXsVoSKBB674jnp7dJBNFYIJoKbA9EHjKBzjGimx0RKQL/KxJJczylq28WvhJAuiNW/gm4uiFjv5Ece7tDigHHDM6qgI31uGNHv7pG6d4Is7TohrfeV0spFY1aHYD077YjbEu7bwsos6RglezPTVUxAFNuvshgboloS7T1PQpfXnKtbLzuOOWrBzKx3bYzgBc1jxOWxR181hJQE4PkL7AhESsq7u3aInwED6PnRIGvB/AAVpUP0iF5adOk6gbcPufVdhDR16ljOHwXpfM6eOL+kDErlObVRy0hOwM402+48T6rjQje3TcRSEtwRkDl73Hh8LFLVX7oxcWU+Lle0MPM49bpQLmPDkvewku6+cSBbaX+yXLK0hAixqT5bbDZC25NsOsJodefdAYqnUJ/2smOQT2wLoAQnfnh6HEgx1wUMrv3XKblipcXurCmRWCwUBmA74ZJ5v62AGSItA7HNcC4zB6phV1e+I69AyPeGuhv+U8dzo3O1Em07wDFBuLNPQ2qiSx5lbc5xmttcrBrMtdnDdymOhH3IXeXMx+yrRYDFJTq0qXbMiXbVLmUEvDncmUCMW87cH9MWBi/tqbfaeTOUGU
 p5YZkpRt
 D+pVrn/Qfl8Youbg/SVzGwO/bvCKD/M3MW6O3YM6FNfqMsdV2pNrgqP+aERbYX2Q48iaXVZw2iB5LlQS8FI4A6Fp6dq6YIyEYlWd7fInOVMFyF9JO6FN1hdvo++Zxap7D+MT1eTOK3icgSbi4ZpfHgVufavQPUVYZp2khKtQf/QU9jKqn5czs+77h1LlFE6pH2oBilzE304WpJSTV5WldJchtHH5XP6YCxdNrDdgXY9gqZU9Fkr1BihwoqIzKesZRCaOZq1iJNhNjwBam6cCbnNZXOW1rnJsM7wd2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/09/26 6:48 pm, Karl Mehltretter wrote:
> huge_ptep_modify_prot_start() clears a hugetlb entry before changing its
> permissions. For contiguous PTE mappings, break-before-make (BBM)
> requires a TLB invalidation after clearing the set and before making any
> entry valid again.
> 
> Commit fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from
> get_clear_flush()") removed this invalidation, relying on the deferred
> flush from the core code. Commit 410982303772 ("arm64: hugetlb: Restore
> TLB invalidation for BBM on contiguous ptes") restored it for
> huge_ptep_set_{access_flags,wrprotect}(), since a deferred flush is too
> late for the break step. The modify-prot path has the same problem.
> 
> Use huge_ptep_clear_flush() for contiguous entries so that the TLB is
> invalidated during the break step. Leave huge_ptep_get_and_clear()
> unchanged because it is also used by teardown paths, where the deferred
> flush is sufficient.
> 
> Fixes: fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from get_clear_flush()")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---

The transition happening here is:

old_prot+cont -> zero -> new_prot+cont ... (i)
and then TLB flush.

Arm Arm rule R_JQQTC says:
"For a TLB lookup in a contiguous region mapped by translation table entries
that have consistent values for the Contiguous bit, but have the OA, attributes,
or permissions misprogrammed, that TLB lookup is permitted to produce an OA,
access permissions, and memory attributes that are consistent with any one
of the programmed translation table values."

This implies that a live update like
old_prot+cont -> new_prot+cont then TLB flush ... (ii)

is safe. Which should also imply that the transition (i) is safe,
since the configurations the PE can observe for (ii) is the same
for (i), except that in (ii) the PE can fault too, which is fine.

Upon discussing with Ryan I got to know, he was implementing the
contpte stuff for non-hugetlb user mappings and that basically
drove a clarification on the semantics of contiguous bit and
this rule was added.

If you see currently for non-hugetlb mprotect() we do not flush
during contpte teardown.

So if the above reasoning makes sense, I can infact audit and
remove the flushes in the hugetlb helpers.

> An instrumented QEMU detected the missing break-step TLBI on an unpatched
> kernel and none with this change. A fork() control exercising
> huge_ptep_set_wrprotect() remained clean. No user-visible failure was
> reproduced.
> 
> The QEMU checker was exercised with 4K and 64K base-page kernels. The
> patched kernel passed the LTP hugetlb tests with both -cpu max and -cpu
> cortex-a72 (16 TPASS and no failures).
> 
> Testing on Neoverse N1 hardware would be welcome, as it can use the
> contiguous hint and can be configured to report TLB conflicts.
> 
>  arch/arm64/mm/hugetlbpage.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa..bb53a04b73b2 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -517,6 +517,11 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
>  pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
>  {
>  	unsigned long psize = huge_page_size(hstate_vma(vma));
> +	pte_t pte = __ptep_get(ptep);
> +
> +	/* The break step for contiguous PTEs must include the TLB flush. */
> +	if (pte_cont(pte))
> +		return huge_ptep_clear_flush(vma, addr, ptep);
>  
>  	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
>  		/*
> @@ -524,7 +529,7 @@ pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr
>  		 * when the permission changes from executable to non-executable
>  		 * in cases where cpu is affected with errata #2645198.
>  		 */
> -		if (pte_user_exec(__ptep_get(ptep)))
> +		if (pte_user_exec(pte))
>  			return huge_ptep_clear_flush(vma, addr, ptep);
>  	}
>  	return huge_ptep_get_and_clear(vma->vm_mm, addr, ptep, psize);
> 
> base-commit: 786262be6048deab760f68c8acc2c85607165894


