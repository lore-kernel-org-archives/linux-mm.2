Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB31FED3F5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1016B0005; Fri, 24 Apr 2026 14:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C787D6B008A; Fri, 24 Apr 2026 14:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E856B008C; Fri, 24 Apr 2026 14:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A86026B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:32:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 505C840265
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:32:22 +0000 (UTC)
X-FDA: 84694294524.19.8DE3DB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8EC5F40005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:32:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HkmEng6M;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jqSWhEIX2bPMbp36EqZ4/QLgTFG4v/NvxQj9EFkSsY=;
	b=AMQykAJQn7uRcveBIglIQBmEL7SrSvX0+OuGV/O4La5s+QF+oR5euap+oKCnyzxSIWlhcV
	Ny6GAfpEIsi11WpcYSQ/wccqtrZ0NV/taK6G1IGYjYVX32W77vnHPYRad8eHvZbL3siqUc
	OZqtsfwhFgNBd1NVpE/s9HgqrQrkuC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055540; a=rsa-sha256;
	cv=none;
	b=FtStTlUAFs8fY6UgISdGK3x4XKmH5lFtwAXF7JWeFIJZRKuyrxMD42UCQ+hzei1DMbd5gy
	CfoSLJsGvAHyqGh52ZV63Igy5RKVpVxN76ynvzoiyUEqV/bdR7gC6x3Ky3148DqjZmiuIt
	+rZRZt8Dcqlg8lNY/8k2Bq7uRQdtuRw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HkmEng6M;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15E4635BD;
	Fri, 24 Apr 2026 11:32:14 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D64543FAA1;
	Fri, 24 Apr 2026 11:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777055539; bh=QKB3JZ7g2c9VEy/es5AGCSmsO1y75sbX2AXFlGxaubw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HkmEng6MQ0mN5UA/B4zvsQ7CuMkuqsLgFOq/mDQ61S+yV+9yLVau+m1EwCf8rBaKn
	 yJGqU/ulj3zjqHHthJDAF3df4Dg0IsiIC5cW7GeUiLq9O+bCPmUqYVENOByDeOMzxB
	 4Y4FOiydJWdwx4jFtRbrGsriNSaedpyBC82UGk4Y=
Date: Fri, 24 Apr 2026 19:32:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: arnd@arndb.de, kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, tglx@kernel.org,
	usama.anjum@arm.com, mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 1/3] vmalloc: add __GFP_SKIP_KASAN support
Message-ID: <aeu3LU2X2P-Ue9ut@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
 <20260424130157.3163009-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424130157.3163009-2-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EC5F40005
X-Rspamd-Server: rspam04
X-Stat-Signature: t7yqo53ozqy7yopqbddrp6ox7bexwc7w
X-HE-Tag: 1777055540-467059
X-HE-Meta: U2FsdGVkX1/EZPBUcLKq79F6CVxyMPZ4UWx9RZ4VUbmaA1w+dGQe3OHlH7JzTRP1kuLMtBQ+H7s/J4DQazdr6r2+6enbov2ANkCIs0eSt3AxExG0DIssaKGuBdxYlmnGrPR8epwPZmbctBL+zI3Tx87jGpVRb3/LOsOFUZbtHFNc2JpL67prC0cbdeO2ssHlzYseiIXCGuGAPGGEpanrJK1bSxDoZrY7jxR/0XRJ7WLYDjkEbv2LkxsGqliqDya2Q2zh1JsfDeedbVz40ByGpnXhNF0ygRuzh4GKWesOktsiwsmnAaUdV6XOG47w2DvEhpVYdcTm1SfkoeRRide8z4YEaO6vgF7ij9RewsQd0HMsJ5dLJ84opMZfNGXF3IKkCIU5eIGTbvR34O/6lXI95dio4aq1h8I7cGF7OLthLVWNBO/gjxPMvL0dmqh5au6mOJb6z1V8qrjpTtpj7UR/BWC3Q1oe0GchJ14Md5j0C+bocGxcb4uzdiA97VoS0R1k22yoGGkHgvLyz0Z6PsqCVKgQYo5gZ7PYYe1BKzaiYYmRpZhkqC6jTADu7Edk+8U17KExM+iNi1/dDGCeyQPU0q/hxrGm/xaeGIzNQrVtkOrVy8x07xiXAJ754psKWsdQSZjOhu6EZQoPPQzgtfmVYUTNRuXux1d8fMGnUzlqKVoJDP9/CQt0gpCLLXJ6g2j0+fhQPAIRmm3TSCqehNMHUK4XuaqMxYLMwTyx86XQxUqTMak1PVlRaSCPi97Mq2baJxxYL5dGfpRVhZb08lUW0vaaM2gsCPu4QWQCKvvly/sk6Bbam00CoBHiP1PmLTVIaCowrwrGU9SE4WGR42Sb36ygLWAf7Yi+QYriW3wKbEg+dAWQyl6m6FXfgPRZxU/Hg1shTuoZsjhtZNcKmOAOqVCAVebrrTLzOjSymA+ZPZRJyWJMTCydEb1VpUKZ3NUOUKh0/8/iuJn2grfYm8H
 qY0SPtbJ
 UI27TmP6MAArExJbS7qsIRaoiMKlox/8P9jNNZ3SfeE1sOaD6cxjOc8QXuTgfOKzOPRNVloEbdEdBNn4AVPT9QjB0U0j42lzbyw18fL7WeIz9qG7AEe3u3DRey1J+9adkTiFY7DdhvXN85x2xxevakZ4+W2GA0zuxt/MVLNaVn8Ozzk4luoaKKhEZOd+GPOOz4bvN6bJF/sa/XBttSW2ziFzyWJU8fUmbGTq0WBV3aFXdUMpJVGEjEKkygmNdiTL3OO9j6bkNqk5WObOMFl9oOmGT1yQVUFUS3VGg+05BDkDNBiEYoheCt+lBtoWflnnIDqUKhevX6GpvnsvL2kscvERyUAGKWAgcFVTwjHvH+9U3IlPIS8urJM6uXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 06:31:55PM +0530, Dev Jain wrote:
> From: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> For allocations that will be accessed only with match-all pointers
> (e.g., kernel stacks), setting tags is wasted work. If the caller
> already set __GFP_SKIP_KASAN, skip tag setting of vmalloc pages.
> 
> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
> APIs. So it wasn't being checked. Now its being checked and acted
> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
> defined there.
> 
> This is a preparatory patch for optimizing kernel stack allocations.
> 
> Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Co-developers need to sign off as well. See submitting-patches.rst. Same
comment about your SoB as on patch 3.

> ---
>  mm/vmalloc.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b31b208f6ecb3..c94fcb2725b6b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				__GFP_NOFAIL | __GFP_ZERO |\
>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> -				GFP_USER | __GFP_NOLOCKDEP)
> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>  
>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>  {
> @@ -3980,6 +3980,9 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
> + * (when prot=%PAGE_KERNEL).
> + *
>   * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
>   */
> @@ -3993,6 +3996,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
>  	unsigned long original_align = align;
>  	unsigned int shift = PAGE_SHIFT;
> +	bool skip_vmalloc_kasan = gfp_mask & __GFP_SKIP_KASAN;
> +
> +	/* Don't skip metadata kasan unpoisoning */
> +	gfp_mask &= ~__GFP_SKIP_KASAN;
>  
>  	if (WARN_ON_ONCE(!size))
>  		return NULL;
> @@ -4041,7 +4048,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	 * kasan_unpoison_vmalloc().
>  	 */
>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
> -		if (kasan_hw_tags_enabled()) {
> +		if (kasan_hw_tags_enabled() && !skip_vmalloc_kasan) {
>  			/*
>  			 * Modify protection bits to allow tagging.
>  			 * This must be done before mapping.
> @@ -4054,6 +4061,12 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  			 * poisoned and zeroed by kasan_unpoison_vmalloc().
>  			 */
>  			gfp_mask |= __GFP_SKIP_KASAN | __GFP_SKIP_ZERO;
> +		} else if (skip_vmalloc_kasan) {
> +			/*
> +			 * Skip page_alloc unpoisoning physical pages backing
> +			 * VM_ALLOC mapping, as requested by caller.
> +			 */
> +			gfp_mask |= __GFP_SKIP_KASAN;
>  		}

This playing around with some of the GFP flags meant for metadata and
the actual page allocation gets confusing. You remove __GFP_SKIP_KASAN
early from gfp_mask, add it back here. You might as well just remove it
when calling __get_vm_area_node() and we won't have to figure out why
it's added back above.

The __GFP_SKIP_ZERO flag is meant for the page allocator and used in
this function later to actually tell kasan to initialise the memory (not
skip this). __GFP_SKIP_KASAN, OTOH, is used to actually tell both
vmalloc() and the underlying page allocator to avoid tagging. I wonder
whether it would be better to have a VM_SKIP_KASAN flag instead and
leave the GFP flags alone.

-- 
Catalin

