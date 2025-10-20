Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B33CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B178E000E; Mon, 20 Oct 2025 04:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B948E0007; Mon, 20 Oct 2025 04:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631718E000E; Mon, 20 Oct 2025 04:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EAEA8E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:05:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6EBF5B2BF
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:05:56 +0000 (UTC)
X-FDA: 84017759112.06.E941CD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C555140009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:05:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RorPQ5ol;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760947555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQz87CQCR7nEfb2O028+GBtmwHCB0SHAP1SZSbYDhlc=;
	b=Q7j7ka1uWec/Rb2ps4P+iUxFs2VmqoLVh8bWNPvsAhPaQMiXkE/UGgNEdvChiIp3DAv3x5
	VZJwrblFbllpTcf+M8mRjXqLcJcYyOtD0VqcOVr6814S3yBIwK9JGgaq1+AdG+yMAJ5JQN
	HQzqXMr5gqQdE1BkY01xVbOi9b9vXdA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RorPQ5ol;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760947555; a=rsa-sha256;
	cv=none;
	b=TocxuSebrOq1IDJgFOs+n4uKrt8lczFYIryFQqpSRitgizyFft6ITFi3fq2TD0nbW5qT7G
	ZDsF6sn4cXFHtDq0yTno2NwLKppKpXiiGtB0Uzo8WZe/IvAuIDYLc290D3AScS4iLcW9lj
	Lym5zGY6gj1w5d10LXfOPkUGfWkSEmk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F4A260555;
	Mon, 20 Oct 2025 08:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AC4C4CEF9;
	Mon, 20 Oct 2025 08:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760947554;
	bh=rXda7spHoPBZ+btkYMydEsdxIcZXVOZHXuPQfGL5NOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RorPQ5olAs/Pyghkzn3Qc8h10zq3G79fwC1hL8SfRWZb9JgJbZWZsx3QyuBAuZhwQ
	 C1pNEdrWswDJ/U1+Ggy6ILEYWd99LIk6R1hdOqrP4sXWYKO9i7qz2dJyUEr1B3lrhf
	 UYJRcNABMc67F7U0tQR/iMO1gUOg4Tci/IGLfMczunIcDga+dIX/gDtgb8+UHrsmsD
	 pkSGFCN7LagnLRbPFB3utcBqN8bA0jptZQSAm9+VdUZx75mWv4I4/dUaPyhrVkPv3w
	 etGxXmQyQ35MZu+MQQAby00aklXEEhMx9yUpIY7rVOE/JEFD3jw9azZUII1W2dJCY+
	 1aZYlWJKxnePg==
Date: Mon, 20 Oct 2025 11:05:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v6 10/10] liveupdate: kho: allocate metadata directly
 from the buddy allocator
Message-ID: <aPXtWDPGHA2kCg32@kernel.org>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-11-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018171756.1724191-11-pasha.tatashin@soleen.com>
X-Stat-Signature: iiktux87fdbtjtzyrsguhb6rdjt8n41u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C555140009
X-HE-Tag: 1760947555-304666
X-HE-Meta: U2FsdGVkX1+kv0R+7/FWtfCgSP9qGXGHMOcYQa6xq/6/jRQLIsWnJKZl6/A8F6KqaNS4wK9vW3jglOEcmqWE0GsYAx7LXfPuNr2P8B7hrsXe5Ii6Cvqrxw2VcZmZYPuEljJ+HysXgLXDzZqo06m0gVJGsAG0YMZxHKkngDeXfydxmoOr5sGjX7+aMYKFLZIW3wc+KxQD3qSG0Oti9I45Z2BwfUgt5AatzyC1CtfS1XjKTW3YTr5nmsi57YQzmvCbAclr6gSqFK5ufLN0cs1wyCru5LAFY5OeSEIBLIBYhd+EdIPb+n1OJsQg3/6fBNQieXddJImBni+oTwXLUIAyuJB2nQdHG7syVSSoRj5yJuXNaAe/09cFWnllfAU7FDULl9YES4bcY1J3SOlzMURobcyo9SMnl353XFa8ttBEsFCyeNGGlejzqwCmw1wWWdYifQEM+h+MXHBbirXcznMDaUX6Re9iWHBQEpa7x0D55omM+hGYm0mwCuonjox4Curf5pNH3imhqKeS2XpX6vuzz1Pz2RXCAMKWTbqnBsnP5GpAr27G0QZelLXiNWsWWSy3aT1yL9BkwQBv5OdGC6hX62B/eMy2OW62QbpIR4tWxi3ouG2dLTk9edD34YszCwSfz29gZSHTY99wkcFaGvra2JmZ5xvafdubBtHxCBPJ9/aub1to2rAmW0CrLA9eJKCKdHpjgr/dejQHgIDlF6cnY8QWEVdWVjgSrPygyq0iXUpASlaslQsdUPyKI10CJyA08bgybkETxxsWE150aR8oO/hGnLiDPRUMol863BiKJdfF6lCvjsSP+EgeV4cyi19rhJTKIT13J1rOU8THxgbEEKSIorZP1fp2SMST/fRU+bW70v+uF1lcrm2nyAwnWtrDAWs2vOdAeD3P6UeCfUWeUBHDFCoaoVQXpdJxcz03kyG+mZhi317BXuoT2OdbV08QGwuFJmyzbkiOXoAVTbB
 Xm/dCTjJ
 ZGFYW0p+IxWIhuL+vYOo/cjbvapFQNJY0E1PqPXoFFqYDukYRVY3DUt5zExxZ879sdLdtM7VdCESKAJq/oxFdrhLXKMvsjrk3gyyaYE2x/bxzBkxxCimd82aB5cvdEAvNt5xatYvgmZUhyx2K4sGRpC4OWUXmh0/lW1pp81AfNJ7MlxQkYRZX+w8H5ETKcxGsSgax1wsw8Ptwvphq+6vSf8YYrr3FJAHZNxYw4DmsafBa4KIxI9baRQ/W93Q2CxvN4CMDimPqecx1AgHyb1tV1Y+q+GIY1Ii0Glllq7XRgBM9dvM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 01:17:56PM -0400, Pasha Tatashin wrote:
> KHO allocates metadata for its preserved memory map using the slab
> allocator via kzalloc(). This metadata is temporary and is used by the
> next kernel during early boot to find preserved memory.
> 
> A problem arises when KFENCE is enabled. kzalloc() calls can be
> randomly intercepted by kfence_alloc(), which services the allocation
> from a dedicated KFENCE memory pool. This pool is allocated early in
> boot via memblock.
> 
> When booting via KHO, the memblock allocator is restricted to a "scratch
> area", forcing the KFENCE pool to be allocated within it. This creates a
> conflict, as the scratch area is expected to be ephemeral and
> overwriteable by a subsequent kexec. If KHO metadata is placed in this
> KFENCE pool, it leads to memory corruption when the next kernel is
> loaded.
> 
> To fix this, modify KHO to allocate its metadata directly from the buddy
> allocator instead of slab.
> 
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7c8e89a6b953..92662739a3a2 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -132,6 +132,8 @@ static struct kho_out kho_out = {
>  	.finalized = false,
>  };
>  
> +DEFINE_FREE(kho_free_page, void *, free_page((unsigned long)_T))
> +

Just drop kho_ prefix and stick it into include/linux/gfp.h:

DEFINE_FREE(free_page, void *, if (_T) free_page((unsigned long)_T))

>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
>  {
>  	void *res = xa_load(xa, index);
> @@ -139,7 +141,7 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
>  	if (res)
>  		return res;
>  
> -	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	void *elm __free(kho_free_page) = (void *)get_zeroed_page(GFP_KERNEL);
>  
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
> @@ -352,9 +354,9 @@ static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
>  static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
>  					  unsigned long order)
>  {
> -	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
> +	struct khoser_mem_chunk *chunk __free(kho_free_page) = NULL;
>  
> -	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	chunk = (void *)get_zeroed_page(GFP_KERNEL);
>  	if (!chunk)
>  		return ERR_PTR(-ENOMEM);
>  
> -- 
> 2.51.0.915.g61a8936c21-goog
> 

-- 
Sincerely yours,
Mike.

