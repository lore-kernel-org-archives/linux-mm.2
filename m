Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB20CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5348E0010; Wed, 24 Sep 2025 08:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD028E0001; Wed, 24 Sep 2025 08:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9998E0010; Wed, 24 Sep 2025 08:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACDFC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:48:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D18A140821
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:48:33 +0000 (UTC)
X-FDA: 83924122506.11.4792B84
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 673A8C000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:48:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="IfoHwq/I";
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758718111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csGzN7ITFwXhWMh/RaKjq9M87J1ZtN3tzt91FwMGJYc=;
	b=b/qupe6V5KZbu/EQ9d6ZQDKksRIQ+oxxqen5i4cnkIIo5pk09BhSGT4QLrN/1d2P3uZ7et
	WgqJVfftVcYya13YQt19/OGm0IjoJPC+Gx2FrBijWrBjyfd95f5Dtbj9JD+PmyGfTC4X1U
	G0+6795l+0LATRFmG6202qbEzqr5jkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758718111; a=rsa-sha256;
	cv=none;
	b=lY3AXJRi2OKdoNtr1+le0bq3lESzqWQZmGg1O2PD2kWqLWL/lWuBTILi+Fo1qkSC7koBYM
	A4ABD4+wPh0dGTU8gAotyy7DCYnzImWQapzLuzJWIZVyXhfhx3JCn/mDCUKuGUclzeyYrk
	rve4yAlkuAspPG/Q9oPYC5tCt/66ME4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="IfoHwq/I";
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c07073f2-96b7-4044-94e2-b41a2f8ca633@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758718108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csGzN7ITFwXhWMh/RaKjq9M87J1ZtN3tzt91FwMGJYc=;
	b=IfoHwq/IQBZPRqQ4ISbsT/VJvaDGntnyP7fTCR8NlNmtCkQd4wXYZQFC0/Fm2GwRJ2f/tv
	urWjCgrciJGntAq2OwXCmTXpg21vW7XrF2SjIHc22X9l8wWL6cH/CUhzcHzBKVwH7hSXeH
	eDqHQ2kuv7+qScnJhzjnlhG6y6BhmSA=
Date: Wed, 24 Sep 2025 20:48:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] arm64: mte: Do not flag the zero page as PG_mte_tagged
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 Gergely Kovacs <Gergely.Kovacs2@arm.com>,
 David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>
References: <20250924123528.1536835-1-catalin.marinas@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250924123528.1536835-1-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 673A8C000B
X-Stat-Signature: f15obbbmkuczof6w7ksuw8f9ft3r9fo1
X-Rspam-User: 
X-HE-Tag: 1758718111-476040
X-HE-Meta: U2FsdGVkX19Vf9sGJeEy7r72syZW1lnMhiVsrKEStVDHS3090KgEIeNhnksk3i9DSUbiaYFecaF3tn3c6t2o9l160K47eEAfoALwCPePhWNeavnVK7XJ6QXwBbNPi5n1TwrDw3G3Q9DunOow0NDBfXIgdZR47xhausIP3KMrRY+9mDsbTnW5ONnNjpuN71MrFSmtYwTHlD34M4KyNCqittm6FyZosla4TotUQCVGf215rPkLJMPCR+1eWO3vWqrEzXb2C90g+Q5H0S3znrkzOtsyfpzlREzp2L/r+EgCRtr3wS3Euv1MS03s1Hu3Q1Dbmf/QVVjkxgczGzqwb27uxljs6jKQYaqA69gBMTI0sBc2ri1yzavL9X9JMDpyT8CIY7+FqPulGv2LBzWfR+EAysvT9n9G61esXJW7BC41WGcUyUVKfcOnt5CIWUxaqbl0h68Kr9+TMTeOwkuGqS2vV5rBrhamnj0gIAXYVScF/7QIzsXPiFI8UWT30co4YczAq9IeF+zped0IuCFGGw+pBA74yqcQpN5EmuuKce+O8GTJHk/CoznipUGb/r0SrDbEriIqs46+rEgpncDHkiEUdrnA4Zzd1vzPgRBbOh410JZIhrkWdmyIh632oMzecI/9ucwzELpkt36QnOPtNsdYAZ5LUZkROisLsFY/7x1LwR6dVkzKJSOyhkWRMhnjiLfrMAmtvpkDcC9P6bhNCawbLAuuT56ZZEI/Klpu3KpgSrg4gRtXvLpRf5DNjdotlfKOika9bAZuuF9Z081EWfIrs/H2XXygcbfN+ToYw2K/zGZkDq4BKlsqt6uhDo/N4fnq4HLhxNruOImgSZKmHaoMqrWVQiJi874p75jHf52DKNKsdGAfDA3fATBGpJJtLNPiChIEV+ljM/5FFLK9VUz5Xgu/UYODaHEy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/24 20:31, Catalin Marinas wrote:
> Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
> zero page") attempted to fix ptrace() reading of tags from the zero page
> by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
> also changed the ptrace() tag access permission check to the VM_MTE vma
> flag while turning the page flag test into a WARN_ON_ONCE().
> 
> Attempting to set the PG_mte_tagged flag early with
> CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
> d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
> have the flags cleared later during page_alloc_init_late(). In addition,
> pages_identical() -> memcmp_pages() will reject any comparison with the
> zero page as it is marked as tagged.
> 
> Partially revert the above commit to avoid setting PG_mte_tagged on the
> zero page. Update the __access_remote_tags() warning on untagged pages
> to ignore the zero page since it is known to have the tags initialised.
> 
> Note that all user mapping of the zero page are marked as pte_special().
> The arm64 set_pte_at() will not call mte_sync_tags() on such pages, so
> PG_mte_tagged will remain cleared.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Fixes: 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page")
> Reported-by: Gergely Kovacs <Gergely.Kovacs2@arm.com>
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Will Deacon <will@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> ---
> 
> For reference, discussion on page merging here:
> 
> https://lore.kernel.org/r/aNKJ5glToE4hMhWA@arm.com

Cool. LGTM.
Acked-by: Lance Yang <lance.yang@linux.dev>

> 
> The deferred struct page init problem was reported by Gergely offline.
> 
> Given that we've had this bug for over four years and it was only
> recently noticed, I think we should merge it at -rc1, give it a bit more
> time in -next in case it breaks anything (not likely but you never know,
> MTE interaction with the mm code is always surprising ;)).
> 
>   arch/arm64/kernel/cpufeature.c | 10 +++++++---
>   arch/arm64/kernel/mte.c        |  2 +-
>   2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index ef269a5a37e1..3e9d1aa37bbf 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2408,17 +2408,21 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
>   #ifdef CONFIG_ARM64_MTE
>   static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>   {
> +	static bool cleared_zero_page = false;
> +
>   	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
>   
>   	mte_cpu_setup();
>   
>   	/*
>   	 * Clear the tags in the zero page. This needs to be done via the
> -	 * linear map which has the Tagged attribute.
> +	 * linear map which has the Tagged attribute. Since this page is
> +	 * always mapped as pte_special(), set_pte_at() will not attempt to
> +	 * clear the tags or set PG_mte_tagged.
>   	 */
> -	if (try_page_mte_tagging(ZERO_PAGE(0))) {
> +	if (!cleared_zero_page) {
> +		cleared_zero_page = true;
>   		mte_clear_page_tags(lm_alias(empty_zero_page));
> -		set_page_mte_tagged(ZERO_PAGE(0));
>   	}
>   
>   	kasan_init_hw_tags_cpu();
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..63aed49ac181 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -460,7 +460,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
>   		if (folio_test_hugetlb(folio))
>   			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio));
>   		else
> -			WARN_ON_ONCE(!page_mte_tagged(page));
> +			WARN_ON_ONCE(!page_mte_tagged(page) && !is_zero_page(page));
>   
>   		/* limit access to the end of the page */
>   		offset = offset_in_page(addr);


