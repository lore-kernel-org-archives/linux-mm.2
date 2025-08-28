Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FDECA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9088E0018; Thu, 28 Aug 2025 05:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9BF8E0001; Thu, 28 Aug 2025 05:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198318E0018; Thu, 28 Aug 2025 05:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060868E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:50:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A61F9BCD48
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:50:49 +0000 (UTC)
X-FDA: 83825697018.28.A089018
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0F32F40016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:50:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtsLfDMM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWMmShU4ImOjLSMeztpkWV2T1IIAbIIXzuHR+ONfz1E=;
	b=aH3ThimPXKkJ9Qb/6rXlbIPVA1z/4K2fTik9e29o7vLc6F8hviteq8AaTyU5qMHBECJt4G
	WdoAJN46VoVLbYrTD7GT2Th0HI4NEI2xsu+hHyhiX3Qr4k538uXcEoLlPKQldm0mXDnkk5
	BJgMWFlwuQANCCbOAncLIKC6sCwJ3Mg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtsLfDMM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374648; a=rsa-sha256;
	cv=none;
	b=oQYKVm5EntMX2JZjEO8Ru9xqaOxkiBxLAZQfqe69Iz9jPtlZ+BY93QfbL7w1tPDFIUHqdQ
	Ux97gPO6xXBrLYiBjn1DY9heiHkRNzP8RaP88sy87V0goE1QAibETwYw6Zrzcc2qyLzTho
	MxTzi+Oz4icUR2F7DwLKjavOio+0jw4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9D12602CD;
	Thu, 28 Aug 2025 09:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2032C4CEEB;
	Thu, 28 Aug 2025 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756374646;
	bh=nsd/srhjb2GA1BGIBjZu6MLWkDZmOCy2pcy5zHmDL74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VtsLfDMMLPSn8X7FB1qyNCklBXX9jl5VJY1SBRcbhOVICoFXA67QPx/qy7W6dd3vD
	 yfVYCeZ9qxnPjnysPEtIFtXsq9TpqQ7ht02VkXWKJSH5mhi7sLsK8f6czjwjLvDknI
	 EM7JLLbBT14GmJfNk3pIinT5sdlwUfUTxOOuJcXPVeVRMUQIKLsvsdrWX0j4LVT7gq
	 SCz62qpwpxFqTRTlUURPRhZQBzchubGPagz85CseSPu0lif/72BG8k0aV+YX0q1VLD
	 e4NAgp3YEZ2oeqsVUxXVdVb/8ObVWHiurodKtnBRh0zfOBY24G5vDUPm3Vou9eV7r2
	 4uhT7unkY+MBg==
Date: Thu, 28 Aug 2025 12:50:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	catalin.marinas@arm.com, alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com, dave.hansen@linux.intel.com,
	corbet@lwn.net, xin@zytor.com, dvyukov@google.com,
	tglx@linutronix.de, scott@os.amperecomputing.com,
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com,
	mhocko@suse.com, ada.coupriediaz@arm.com, hpa@zytor.com,
	leitao@debian.org, peterz@infradead.org, wangkefeng.wang@huawei.com,
	surenb@google.com, ziy@nvidia.com, smostafa@google.com,
	ryabinin.a.a@gmail.com, ubizjak@gmail.com, jbohac@suse.cz,
	broonie@kernel.org, akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com, pcc@google.com, jan.kiszka@siemens.com,
	nicolas.schier@linux.dev, will@kernel.org, andreyknvl@gmail.com,
	jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 07/19] mm: x86: Untag addresses in EXECMEM_ROX related
 pointer arithmetic
Message-ID: <aLAmW-UV6hv9k1LT@kernel.org>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c773559ea60801f3a5ca01171ea2ac0f9b0da56a.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c773559ea60801f3a5ca01171ea2ac0f9b0da56a.1756151769.git.maciej.wieczor-retman@intel.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F32F40016
X-Stat-Signature: wda7e7zhw64m6xcw44buhjkj8wsbiz3k
X-Rspam-User: 
X-HE-Tag: 1756374647-774321
X-HE-Meta: U2FsdGVkX18gDFeSeQyk/n31qYjPWnff/WbC26YgGpdIseNtFMLgv6p8EVjYmALhL6rpWOJuH2GnbxpM2GzulWNawczbkDiAWChu2/iO4xXRXP+hHx60CKOY7FJduLSVTh2wDXm8m1W0137etmBk2j0KckADIZo1xRRUfyVLT5jBdZSSPUTeN1vF07kdYGKgmacXeh2cQHt6tBXW5kWelgDQZzLrM2/0vAqzNNLdmKjRMbOPd/wzCF0tbTxxaiCyUXh7Cb80yFGlIHm1X5jSzAvmvnNAIQhZP5qM8dxn9pxLbxCMP+OXLsNgIexl3/Bb6b+wXMrMWHLuEX3kSFcPrNe+6L00MO9jHOwQkn+gCxORrZMTIC5rBFg+0Smw6C6bn2XX4oIx6BUYLzF/1LGDAsu7YR8HBy1Pz9xf//wtFDP2YeM1kqDjrcEV/MGvI0zJGCQt6N8NZ1FZyHW0XPp0kI0c+AbXQsy6YqLM0B38zhNiUiNanikp7QO2YKud1KTAJidw7Iql93lOJz9STEt1FkibY4HA1cpBHWLvAIiKCvwKcLhBJJMWamT3HjphuLbtPXcxBdMtglkRbXORf7kWCwJ9vyrziW9XHHa6pNbuDlACtvIL2befMLLV1ryv8fsoyRSuyh8ontcSPJoSGlalSSnA4SbwEwka538wqpeLnvpkub7/vhd+412k6j5af+HbYkV10LT7NUE/KqcUSmWxVphgl4o2PpG0njvbC3B/nU/5Yv2+TIUyOIPKAXKHfCZdq/pxh9B1oeCKamxGJQdZ2AbrIjyhv0QvJkMtqI9gy38sPo+wN2QIk09xrHkkNDNAolQbgy7UnK46UvGU8g84iBR8q5WkLw3zyEhoyfru506LaNRAdb7/hKZKbzAGhxY94NAdrDihUJQxRpuAhaxIfzXg+1bEku0Zd+c91uhrvyGwbtmsTK7T+P0eZrqIzww0gqpuzbxfncVg7ufTV5s
 CPLherKh
 RTb2vIVh4JSo9Yajh332VahFP4/6Q3oezR+XnFyfC9/Oglm2C5OB/owQPOowdYMBd5ErT2d4vVU63mt60s1AJvfnQVwSWyy2w/xDgyE7575yfP/5V4W1cjkEzjEOinvNGQOD8FpcUbFHkS+y4m7OwvgX7zvhcc1T4D6SMnp7wnj+kxPVaklqXtIpXZ27RwklQ94SU1gsFUBV1MARpZcMAO+JO9jHo06qARnAWlcxNlwTA1CZ2QxhzFJbEUUbx1sB71iyVDx9Y9aNJ545n4I/EqrwpNhe+FLdzlvoyqBFvnZ6u09ICVpO8MxXmwi023qD/gOkixSpBp8BnXgxRlAqhsIw/HpmKo9AYTRn++ykIRRSu0wIIRtKHFc71wnNKpqauDRgvu42swyeEDjFzYOOthB4beQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:24:32PM +0200, Maciej Wieczor-Retman wrote:
> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
> Related code has multiple spots where page virtual addresses end up used
> as arguments in arithmetic operations. Combined with enabled tag-based
> KASAN it can result in pointers that don't point where they should or
> logical operations not giving expected results.
> 
> vm_reset_perms() calculates range's start and end addresses using min()
> and max() functions. To do that it compares pointers but some are not
> tagged - addr variable is, start and end variables aren't.
> 
> within() and within_range() can receive tagged addresses which get
> compared to untagged start and end variables.
> 
> Reset tags in addresses used as function arguments in min(), max(),
> within().
> 
> execmem_cache_add() adds tagged pointers to a maple tree structure,
> which then are incorrectly compared when walking the tree. That results
> in different pointers being returned later and page permission violation
> errors panicking the kernel.
> 
> Reset tag of the address range inserted into the maple tree inside
> execmem_cache_add().
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v5:
> - Remove the within_range() change.
> - arch_kasan_reset_tag -> kasan_reset_tag.
> 
> Changelog v4:
> - Add patch to the series.
> 
>  mm/execmem.c | 2 +-
>  mm/vmalloc.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 0822305413ec..f7b7bdacaec5 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -186,7 +186,7 @@ static DECLARE_WORK(execmem_cache_clean_work, execmem_cache_clean);
>  static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
>  {
>  	struct maple_tree *free_areas = &execmem_cache.free_areas;
> -	unsigned long addr = (unsigned long)ptr;
> +	unsigned long addr = (unsigned long)kasan_reset_tag(ptr);

Thinking more about it, we anyway reset tag in execmem_alloc() and return
untagged pointer to the caller. Let's just move kasan_reset_tag() to
execmem_vmalloc() so that we always use untagged pointers. Seems more
robust to me.

>  	MA_STATE(mas, free_areas, addr - 1, addr + 1);
>  	unsigned long lower, upper;
>  	void *area = NULL;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6dbcdceecae1..c93893fb8dd4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3322,7 +3322,7 @@ static void vm_reset_perms(struct vm_struct *area)
>  	 * the vm_unmap_aliases() flush includes the direct map.
>  	 */
>  	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
> -		unsigned long addr = (unsigned long)page_address(area->pages[i]);
> +		unsigned long addr = (unsigned long)kasan_reset_tag(page_address(area->pages[i]));

This is not strictly related to execemem, there may other users of
VM_FLUSH_RESET_PERMS.

Regardless, I wonder how this works on arm64 with tags enabled?

Also, it's not the only place in the kernel that does (unsigned
long)page_address(page). Do other sites need to reset the tag as well?

>  
>  		if (addr) {
>  			unsigned long page_size;
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

