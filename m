Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D76C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71B76B008A; Fri,  4 Sep 2026 10:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22346B008C; Fri,  4 Sep 2026 10:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10E56B0092; Fri,  4 Sep 2026 10:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82CE36B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:52:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDDDA80182
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:52:14 +0000 (UTC)
X-FDA: 85176370188.21.5B83563
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 38F6B140013
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:52:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJD4MJZR;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwQzg2jEwGo+36T57R0zDsUiTlf1aTzJz1Ht0vOr634=;
	b=fBpH5biHKkOzmDqw7/Ll3OwJb7wFsENvz4mDv9TaUiTTT8HFvI3HSWZZDtO+WSyLvFA/0J
	JvbTavTrZbgZKUlL+jwdmrPVolI3SE5nIqF+ze3qex//okk5ufy4ej1X5KWfFYiKuZL34O
	3HWMknok5HYStY5FfH7cPn589tShBVk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533533;
	b=HMwH1IRZSaJdRZHoC+4oB56pIeLCIDKLi7T1VeHRwuP9Fh2hXUq3Ou5KY+Z9b8apnLobaR
	aRls8Ppi8Q5J8N6rX7E1AVkv4gEcRdESL84NRAJbDrRslefXy5p8P6mw9je/EgXpv39Dew
	HqfU8h4jHeFgkzsQO6o8jdsT+piX92o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJD4MJZR;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0437941FE8;
	Fri,  4 Sep 2026 14:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9AB1F00A3D;
	Fri,  4 Sep 2026 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788533531;
	bh=dwQzg2jEwGo+36T57R0zDsUiTlf1aTzJz1Ht0vOr634=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dJD4MJZRh25gKn1nsYZg1uaVLWJzXKYzmcpljcL5Mdbw+te3eMDvlsfSG9Bm+LauY
	 1PMYKdnizw1riPMM2zZVYBgaVIA7EtVJ8cov43aSLdyL2qOcmfIFD1DomRZ5O8h2yf
	 EFyXQv6mrObBDLRyCl/6eeK6rs2bzgC/U+vZqiS5JNr9YtAB13QZMQDTi7mXnTL7sn
	 ehioRVm6vFTKuzq+wmx2FoDPEws7k6y4ifeBcZityJdsRQ0vZzJwGD8c7gGtDnNyIM
	 L/RZfe3skN1RH/lKdBdkvfW4QdyAKjCn7jG3Qs9RVNbw6NvzkNADqAY8B06W6aB3e3
	 tVtFPdJOSG6NA==
Date: Fri, 4 Sep 2026 15:52:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: Mike Kaplinskiy <mike@recall.ai>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v1] mm/madvise: prefetch private file COW swap entries
Message-ID: <aprY-BekgYlsK-Y9@gremlin>
References: <CABeknB82T0d3VUjz6Xwcdfa8spHvNzO6tZNTMwjJgF00EwrWWA@mail.gmail.com>
 <D758D1DD4372AF8E+20260904100919.2139680-1-zhaozhengzhuo@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D758D1DD4372AF8E+20260904100919.2139680-1-zhaozhengzhuo@uniontech.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38F6B140013
X-Stat-Signature: 3sdfpe5r5kgokawsbezphus7permgake
X-HE-Tag: 1788533533-262530
X-HE-Meta: U2FsdGVkX19iNYzWKz2XLlnHTWH/2Sd/mobpNJbBirlqp0qgTUQGXfxXsDkQOJxToEuWY3hR4Oj6G/Ay/rL0UPZqwzklX4Dnb3xfeb5TpPWcC5LmqJUMtONgjkFbsZvWjBWz1Y/ombF8nLW+JyNjQvbhSvIu7cfx4e5hCeXHc9JbFdE/xJ6uwB43Gl6PEOyAzSddtpbk6jvAROP2WwOzOXOLULBJFqCy8eVaqhnjcmcaXU93FsoymGlNNs5U/11O8QZSAqBl0WdyoXpGWs5alLOLv999LodTB6fej7xGygG3t6Pp+QEDOkay2pNpoYsuYbKKqBJTPxNZoPYo/lAk1fSwgJVbCdHf5q2M+SvV32PVIFaG/A1eCeSKVZpob5ZchKgiG1XhLXYXed5b8RnBwd4Ao7J8xj1WMo8btQFrBA8hPjWGpTK4jmqtlqZ+Tl37D0p6oWMKsNIaoHMiMKjOynsJddu/vU7Ij44SkODOSvBa6hkfy3PUbVC/O7CLBNAYNE9jdAB/oNtN/F5OPjR/LKZCoE+ZTuNKp112ins1GhfAqhgYLxsnLMh898CaM7CqplhIN2+yJH+veCokM5g/D8RQ/0XI/QJoFBtg1ll5hr02R8jw1YOV4JZ53ip+JZS7BPWEl/06Q7DDjMTaPvSWqR6SvF5U2rx839Ynp5QvMkNqJIUawYYUVd6pQzPSLP23CNURhBUS0zTC018naWxaNPpH3wYWMqWu+PF5FuVwq2dOTIa0cmy/+sIl/xpIdg/OLVG7c2Fi7eoqoOiLVzy1lzIesig92Z/X+XtKakKIUu5i8XXYO6I1NEIrR/JlKSV4ARL4DjL6hPRlERpHK4xqu+3FLzBy9KlIjq+YEDC/AaGYPy0egVXRgj7rBIx074ZPbcCRO3d2ibbFbKRmm5YVy/4AJLPPGd/OuorVzia/b+vFcdkqNxluxfI6Sw4gvRDPVRXoMIwAdqzXrE9eREk
 WbD2r/co
 RJs+fmFZyrUKFidke5fs7OMtBcBUwI7wo6zE/k25cmpM+bJSfNTJXwmLk6TsH9zDS2cjVBCT8dBelyg1Gb6fcBNH5VrkyNXQmTMnp8qgDWq7n6+L48jimKC7bu8llf3ejcGCMhIbXDkH+MY16SHcBMNvHEOY9zuEtksyOP5hOMBjH3F7AfhQS+0wHxbndD/YEUfsDYYKEL02Lo4NCQfS2qrUFqTUXwBPrfyoSdM6JftXy8gtQ4n70v7p2USXS7+RxKIkWET5UboQ04+NDsrPOAfSQoLLVFOyUk4wzmxfqsinBpi/k+20Q0MzfSQix3bnmbMmYYhCgVWETQFjVm7GNsly6GKQF55+x8cs05AgesXUEL4FSOaLWi+2YcT6Gbi6IflZUzdi0+Kowd4Ga066g3ftx9xKm3KAt1MWYPtxmjrwv1tbmMKldp1gucx94IIdnYzEgK7kOi3TRR4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 06:09:19PM +0800, zhaozhengzhuo wrote:
...


> Fixes: 1998cc048901 ("mm: make madvise(MADV_WILLNEED) support swap file prefetch")

Fixes totally inappropriate.

> Reported-by: Mike Kaplinskiy <mike@recall.ai>

Missing Closes tag.

> Link: https://lore.kernel.org/linux-mm/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

(Very likely) missing Assisted-by tag.

Please follow kernel procedure.

https://docs.kernel.org/process/coding-assistants.html
https://docs.kernel.org/process/generated-content.html

I already sent at patch at
https://lore.kernel.org/linux-mm/apm68kgHC0NK2zVI@gremlin/ before this one, so
I'm going to take care of this thanks.

> ---
>  mm/madvise.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 73c2901b9adb..96cbce6c7f8b 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -193,10 +193,16 @@ static int madvise_update_vma(vm_flags_t new_flags,
>  }
>
>  #ifdef CONFIG_SWAP
> +struct swapin_walk_ctx {
> +	struct vm_area_struct *vma;
> +	bool swapped;
> +};

This is silly.

> +
>  static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
>  		unsigned long end, struct mm_walk *walk)
>  {
> -	struct vm_area_struct *vma = walk->private;
> +	struct swapin_walk_ctx *swc = walk->private;
> +	struct vm_area_struct *vma = swc->vma;
>  	struct swap_io_ctx ctx = {};
>  	pte_t *ptep = NULL;
>  	spinlock_t *ptl;
> @@ -223,8 +229,10 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
>
>  		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
>  					vma, addr);
> -		if (folio)
> +		if (folio) {
> +			swc->swapped = true;
>  			folio_put(folio);
> +		}

This is pointless, it's not a good trade off.

>  	}
>
>  	if (ptep)
> @@ -297,10 +305,22 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
>  	loff_t offset;
>
>  #ifdef CONFIG_SWAP
> -	if (!file) {
> -		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
> -		lru_add_drain(); /* Push any new pages onto the LRU now */
> -		return 0;
> +	bool private_file = file && !(vma->vm_flags & VM_SHARED);

This is not correct. My version uses the correct CoW predicate.

> +
> +	/*
> +	 * A private file mapping can contain anonymous COW pages. Once such
> +	 * pages are swapped out, their PTEs contain swap entries even though
> +	 * the VMA still has vm_file set. Prefetch those pages as well; file
> +	 * readahead can only fetch the original file contents.
> +	 */
> +	if (!file || (private_file && vma->anon_vma)) {
> +		struct swapin_walk_ctx ctx = { .vma = vma };
> +
> +		walk_page_range_vma(vma, start, end, &swapin_walk_ops, &ctx);
> +		if (ctx.swapped)
> +			lru_add_drain(); /* Push any new pages onto the LRU now */
> +		if (!file)
> +			return 0;

General structure is OK, but again I already sent a patch.

So please no v2, I will handle this thanks!

>  	}
>
>  	if (shmem_mapping(file->f_mapping)) {
> --
> 2.43.0

--
Cheers, Lorenzo

