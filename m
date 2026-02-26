Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741C3FD45F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908F56B0088; Wed, 25 Feb 2026 19:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA506B0089; Wed, 25 Feb 2026 19:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC7A6B008A; Wed, 25 Feb 2026 19:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67E836B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:39:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03F4216016E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:39:49 +0000 (UTC)
X-FDA: 84484750140.09.9204981
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 421C7120008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:39:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kw8Z446L;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772066388; a=rsa-sha256;
	cv=none;
	b=YXc2NGbvi3bwxLUjaLjMwvRFOwIgYqUsheTsFu5es21PJrYNDrxqOwoHpvgcuEce7xxRVY
	WZvycneIycavL0f/j7BCnTGR31Lec9yCjW1nRR5X7J+ComOeiAukkDfOtysmyHbsTPciAC
	EZINE38o5u09mb/18/9cvnQOGwCJlBs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kw8Z446L;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772066388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74Rq9waJ5OaEku2bqnXV7KbpQK3SQla0Hez/s/7rAu0=;
	b=qP4E8crWjL5M24Fr9ZtgmfBuhNjiXOu+DIIXM9jNJoDnis0coGnoMKCBK7pzKDV7hjAHsi
	7Cci0cvqAHdVCppkUntjR7DMpgDr0l55hww6Jr8PibWqQ6ElN3iBy4UBmgEh8Hymq6Sgjd
	uk+YI/yvMk/Ov19bvN6WCD2JSBIvQPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 300F844495;
	Thu, 26 Feb 2026 00:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58D7C116D0;
	Thu, 26 Feb 2026 00:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772066387;
	bh=ARTPcSrgUSDeZ5aaEMcCmyrM2w97b2lJEf161Z+GogQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kw8Z446LHFulM7Ynb3GVAIBS4yWtXYfSZuj8K7sOXNN4Vc1OowpzfTvTp62gIZZga
	 H/kvXaWO+3ey7eKkhh+voQIUlCyqfQd+nfCGpP9zz1aMU2SefH8KmbSlKvfN7ZunEq
	 nPmuzvANQb9Awjoku2i9L2Io4An7jF2uUSANY7OViiPtnOaSeSp1er443Dnp2Kp2N5
	 RMAl5Wq2fdHvjy06FiJB+9iHAdI4OHGVVRzWVzi9msFILb/5mfv7f/SF9Z/Zp4Pheq
	 bbCTT5FDYuhlC2SYlifyGVusspXuTwVw+SLzcTWIKR6WsXfRgD24sD2Tj7GWZF7euz
	 2vFnxVFSRkmGw==
From: SeongJae Park <sj@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] tools/testing: fix testing/vma and testing/radix-tree build
Date: Wed, 25 Feb 2026 16:39:43 -0800
Message-ID: <20260226003945.7145-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225233111.2760752-1-rppt@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 421C7120008
X-Stat-Signature: bwrht3caqnx3o783888kahd1wsu4d4p8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772066388-153695
X-HE-Meta: U2FsdGVkX1/GvfSpYPT8KBuIdmWW6DVaKw2BaFrbPD7OsaH+Hv6S0E+QdH4sXW8UcM1J69QJhZxqilyQ4z81ew0NlosAXT2egCy5zzu9ug8lrwQTxG78CY9KwLtHb/4wOg0rxaJNRb6uU+EX14rQrzpdiKLXo23FM0KXjCNrOdzsaxIt398cvYnBKoACvnvyPi4lLO1qEUQvDbWQpggjWPFTj1aEuOOHquygy61ZIJ1f0kV1LqWUsDkz1fVWF78SJU/Xw1tSYnO9Udo15oRL7UUSo6y5bY13/DSXx38fIcUkz6oLDRhhhz1FSb7hSF/A3i4D1M8VfMGV/xZK5qDYwBNZ6uB12tRYz+OHLIenmJEFnsLCpoJXrd24kEvSKyTCrE3R2+yluN81FijQWZCXFhH2USBr+1WqwEXX7yzTR387PxKSA4Q3yylLk4fhbQSmH92RQ5abTfA5QOWSinpydLXiUqMHT6kqR69L8Qov4VwWUCqA50j7zrXwW+Kr+j5NhYIpiKUEeST0SSY/0kTfGrRr2HNrU/Wmi+5aIQMnPSWuyLdmdSgHRPilKfBnnzuF9/h4ekkENfxpsIkGt3LEeA+43e03X9mrnT9Dy5uV4gLabXITKE/ovIiuk+3yam5nCLfyKA3hZvudu87bRU3eXojIaU5yaRZpgypVATvw3MWPV8r9JMNP8iM3wGKPK2sqcZ8sqVWoUanWo7MN+QF/nNFZMVCK7c/EijaVa0bshCAr/BDujZlFfHdelEVkCx46C6FpomoidVGq2T/bi0q/6pF1fbv+QejB8OmlZ3sT24kqWZ1X42y0I8zNj08weqTJsrVm4fWmp6eNlEHMfsC3r87cLtAoR1h6No6O429Om6DsDnCQuITma1IJovJiHWR/4x9Hz40zHNrdPOR8qG0iAR+Dv/L8rz6cZB9+dHyVyPpC+bzAWWzJnGNOWe+rs86YRfXSMkWI1hR2Os1TeQO
 4U52oADw
 5vPHCFk9y1FhM2zToCsHa2pCTm/2qwH6DIjL4vjc/63jyri6UTfcIDpTEThQjhpG2SsxVMLrqTacqrVkSdTVhEeaf7XrMVFxV6E9XLG4rkCO+wpAblWDSLOBjAE+C8Z2EQajrfRDP1QrpD4gC3UIE5U0npQ/kfbtUcgnZgQ9VFm3+kqrb9pXsv4XbnahTlpIvCLmRc3srKt6eU2ATSMfpSu0SH7Jym24CDrcW1Jadf29fXCK2AtFS56aSy2pZsRiqBY5gyTa92EDYajw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 01:31:11 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Build of VMA and radix-tree tests is unhappy after the conversion of
> kzalloc() to kzalloc_obj() in lib/idr.c:
> 
>   cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128   -c -o idr.o idr.c
>   idr.c: In function ‘ida_alloc_range’:
>   idr.c:420:34: error: implicit declaration of function ‘kzalloc_obj’; did you mean ‘kzalloc_node’? [-Wimplicit-function-declaration]
>     420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
>         |                                  ^~~~~~~~~~~
>         |                                  kzalloc_node
>   idr.c:420:32: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>     420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
>         |                                ^
>   idr.c:447:40: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>     447 |                                 bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
>         |                                        ^
>   idr.c:468:15: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>     468 |         alloc = kzalloc_obj(*bitmap, gfp);
>         |               ^
>   make: *** [<builtin>: idr.o] Error 1
> 
> Import necessary macros from include/linux to tools/include/linux to fix
> the compilation.

Thank you for fixing this!
> 
> Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Tested-by: SeongJae Park <sj@kernel.org>

> ---
>  tools/include/linux/gfp.h      |  4 ++++
>  tools/include/linux/overflow.h | 19 +++++++++++++++++++
>  tools/include/linux/slab.h     |  9 +++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/tools/include/linux/gfp.h b/tools/include/linux/gfp.h
> index 6a10ff5f5be9..9e957b57b694 100644
> --- a/tools/include/linux/gfp.h
> +++ b/tools/include/linux/gfp.h
> @@ -5,6 +5,10 @@
>  #include <linux/types.h>
>  #include <linux/gfp_types.h>
>  
> +/* Helper macro to avoid gfp flags if they are the default one */
> +#define __default_gfp(a,...) a
> +#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
> +
>  static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
>  {
>  	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
> diff --git a/tools/include/linux/overflow.h b/tools/include/linux/overflow.h
> index dcb0c1bf6866..3427d7880326 100644
> --- a/tools/include/linux/overflow.h
> +++ b/tools/include/linux/overflow.h
> @@ -68,6 +68,25 @@
>  	__builtin_mul_overflow(__a, __b, __d);	\
>  })
>  
> +/**
> + * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
> + * @factor1: first factor
> + * @factor2: second factor
> + *
> + * Returns: calculate @factor1 * @factor2, both promoted to size_t,
> + * with any overflow causing the return value to be SIZE_MAX. The
> + * lvalue must be size_t to avoid implicit type conversion.
> + */
> +static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
> +{
> +	size_t bytes;
> +
> +	if (check_mul_overflow(factor1, factor2, &bytes))
> +		return SIZE_MAX;
> +
> +	return bytes;
> +}
> +
>  /**
>   * array_size() - Calculate size of 2-dimensional array.
>   *
> diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
> index 94937a699402..6d8e9413d5a4 100644
> --- a/tools/include/linux/slab.h
> +++ b/tools/include/linux/slab.h
> @@ -202,4 +202,13 @@ static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
>  	return sheaf->size;
>  }
>  
> +#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
> +({									\
> +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
> +	(TYPE *)KMALLOC(__obj_size, GFP);				\
> +})
> +
> +#define kzalloc_obj(P, ...) \
> +	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
> +

Just out of curiosity.  Is there a reason to not copy the comments from the
original (include/linux/...) for the above two macros, unlike the others on
this patch?


Thanks,
SJ

[...]

