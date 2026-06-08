Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F38CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FDD6B0005; Mon,  8 Jun 2026 08:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A1A6B0088; Mon,  8 Jun 2026 08:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE19B6B008A; Mon,  8 Jun 2026 08:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 999D16B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:06:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F3CC140A84
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:06:48 +0000 (UTC)
X-FDA: 84856618896.08.9BE8720
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B8A6D40019
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:06:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCHCu0Rf;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780920406;
	b=Dx+kQa8WBFwsbx/kyJTnGfkRPm7hVD05R+BIE+wVthVz/I1VD42EvX6iThLWbkslnxiD1A
	MedKb7BysH7ENvUSpCvtOM6f/HAB47LMZ7NeP2MbnfPX+gRahqQOJ61hnhCodP7BP5DorD
	do4ZzT/B9oGhkYPtpZgreESnd8HOZp8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCHCu0Rf;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780920406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuEsAZT98ng5/+FP7TodPtIFyatpQDw/YyO8mG4a3jU=;
	b=NRvrBu4I1xl0ADbJIpVqd57uqhI0r3h6oJJUPTbzgHYSWwbMf5zxsTp/e4/T/kncLdKBPH
	9ZeB5kOqKIZP1j0+YmawoEnu8q/xAqAqmHSXKqNesNP9MAQjm/TelrxB818h6O+bWsl+8g
	qHXwdPCZEpuKThvEIVVboic/mfrjN3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ED986001D;
	Mon,  8 Jun 2026 12:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F031F00893;
	Mon,  8 Jun 2026 12:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780920406;
	bh=tuEsAZT98ng5/+FP7TodPtIFyatpQDw/YyO8mG4a3jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MCHCu0Rfs+/nUdC5jERSrBPKpZGsHwoM9PZmyKn3a+auwRpkMP5RngXYDqXaaiPvi
	 3S2OoPhiPVCrkGLqRZa3mYrAyFvnyEIjbXA+VJHa2fv8flyCQCj5tPu/pN6Krlqc9A
	 5IL4jyN1oW9qiYoIID6gc4IdMfygj3A8FVjLH3KHVUxPEzTUdJ6y0zhOKfjbj4wqwi
	 xGvrtpuRw7ogtUvHxljQWY/0lmNSfCpItkxGPNXq7ryxmpb8/QFzqgolZnYV6WJxXp
	 W71w2d61dfYyP9r9n1jQJwI4Ym9uDI/glY8/wOzYfRj8po22/R688DVzhs9cVkw+mH
	 EG63r3uz7431A==
Date: Mon, 8 Jun 2026 13:06:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 22/37] mm: add free_frozen_pages_zeroed
Message-ID: <aiavDqj6my4_uNeg@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <4220116b4d91f3e933fa76ad473106c2e48fd452.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4220116b4d91f3e933fa76ad473106c2e48fd452.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8A6D40019
X-Rspam-User: 
X-Stat-Signature: oij9b5ab84x1z4zaboh3zbxwpq4dpekj
X-HE-Tag: 1780920406-905387
X-HE-Meta: U2FsdGVkX1+vQL4/lcNG5UQEPznZGTg0KCli2rYPZWu2eH+sMq+UobaYSHgOXUUb1FGV4mTXydcf+lBRPaDgKUBhHVX43BTmGUvJoJ1RicZcDFa7L0QfgxZ7+1c9I3qDmilaY7Y0AMqpm9eQlSn18aaxGZ9BO0IcXgKaM+WWvd2wN/OW64OqoocHcadxYla1VSmTDtkZx6wVMxFW91gst9VOmCy+5eeU5ErBpPPIMy/Cw6UKoWCSOIJmZ9dpRlw5FBIkYRhJqP34dYpZJvXpDtIHDSQkV1V7SitLh34aMAXl0tD4egmJE9JQYuseZV8QJK6rO67kGGjRlRf5fhbqkzrzftTxRbNLt0TzjZobOKJsp8sR66N/N1xb9iGossXB8fOYWG92q0ylQJxYF4ZSm1l/NnT2+0rFduTypjDZja+qnkSp5MF3+w7pRrjGTvssSPtEh+Q5YrvfwBl3qZlZ+uedbGPEIjOPnEaOmMn0Jaifyz3qTFHa3/GfwV2TLfzDfyRcwE4VyDTauMQvwbr/7dkQQZbZThzSCYxxHCH9VWt2GteFK4sBZv1mes/6cuuakGW9s6fY9FcZCDMCiVgouJRApbTXg44wsA0sCWLOXr/bgfR6HHs05PZ/OnVFTAf5NhsiI1NngjWrChXpmSy1S6f7AeV7Pn+FtewUHGNDdcjfm/3F8eEe5U2Hk1NApqDTZQ4yHtPtGl2y4G4Hx+fFe8ncL3fXw+cCLsxlyvrifEXQugx/A/Oi7bhcEQbt5OrhPsEGLEZhSD5dIv9kJZ50YnZmaAUOaOdOlhL/0BQL5odjP4EGjuZ6VsOFZ7nFVehocXPI0cIgS4ZLeRGbC0i3vIzNKOlEzB+I6uhIikjqsh6DGTTHtulcoWsosoeAFHhp6ou20SUpmqyUZ+IelTtPWyJQdaCT8+nX/syfLy1KWAwa0veIVUZJSMOH3xcsjgxyF/JY5lVkTOeTKEAA+Jn
 HXWMb2aX
 TGD2LNu8Ti/stlFCJ6cgp/l1DojBJQrHe1qewH0Me+VJINzWZXnkYY00GRFpQWoGraALUnrGFtyGZEC8huYjXukuqeWnJ2TumW4VtjaER6cOrpS8rCImsl817LgiJ3YQZutbOkbze897MaoMSHSHhyg/hj+C5mU4mijlkvpLfQO67/OY4Ta1dIn1oO6v6k/ne2M0RotMmxpJVm18RbocW7vGjz8V1GyFMFQLdnsTVh+2ZgBCRgM4Wh7XnfHmpEpLSopAleFkSKIrQVQxOqyblSUzBcdJ4rGutwOziC3nqa9pR3+JdWv6Lu9NbUyy2ui38i8PSUagen1aj4nIecHjH6GfXhBKwl57c77cN7fmkFL/AVnLq/g5GQSmXwudwhwndL01MmvisChMboEtGPutiQQyo1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:38:37AM -0400, Michael S. Tsirkin wrote:
> Add free_frozen_pages_zeroed(page, order) to free a frozen page
> while marking it as zeroed, so the next allocation can skip
> redundant zeroing.
>
> An FPI_ZEROED internal flag carries the hint through the free path.
> PageZeroed is set after __free_pages_prepare() clears all flags,
> so the hint survives on the free list.
>
> __SetPageZeroed is non-atomic but safe here: the page is frozen
> (refcount 0) and not yet on any free list.
>
> Note: when want_init_on_free() zeroes the page via
> kernel_init_pages(), the page is zero but the direct-map
> cache lines may be dirty. A later patch (skip
> kernel_init_pages for FPI_ZEROED) avoids the redundant
> re-zero, and post_alloc_hook handles the dcache flush
> for user pages on aliasing architectures.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  include/linux/gfp.h |  1 +
>  mm/internal.h       |  1 +
>  mm/page_alloc.c     | 23 ++++++++++++++++++++++-
>  3 files changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 73109d4e31a4..d24b61e45861 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -384,6 +384,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
>  extern void __free_pages(struct page *page, unsigned int order);
>  extern void free_pages_nolock(struct page *page, unsigned int order);
>  extern void free_pages(unsigned long addr, unsigned int order);
> +void free_frozen_pages_zeroed(struct page *page, unsigned int order);
>
>  #define __free_page(page) __free_pages((page), 0)
>  #define free_page(addr) free_pages((addr), 0)
> diff --git a/mm/internal.h b/mm/internal.h
> index 4af5e72742ba..fd910743ddc3 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -938,6 +938,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
>  #define __alloc_frozen_pages(...) \
>  	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>  void free_frozen_pages(struct page *page, unsigned int order);
> +void free_frozen_pages_zeroed(struct page *page, unsigned int order);

This is badly named. That name implies you're freeing frozen, zeroed pages, not
that you're marking them zeroed.

And again, you're overloading 'zeroed' here. Be specific, it's about
host zeroing in virtualisation.

>  void free_unref_folios(struct folio_batch *fbatch);
>
>  #ifdef CONFIG_NUMA
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 21f9e92922f1..008f1a311c40 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -91,6 +91,13 @@ typedef int __bitwise fpi_t;
>  /* Free the page without taking locks. Rely on trylock only. */
>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>
> +/*
> + * The page contents are known to be zero (e.g., the host zeroed them
> + * during balloon deflate).  Set PageZeroed after free so the next

Can we just be specific that this is about VM hosts, I don't imagine that we are
going to ever have a use beyond that, and we can adjust the phrasing later if
needed.

Otherwise it's just confusing right now, you're overloading 'zeroed' to mean
different things and we do that enough in mm already.

> + * allocation can skip redundant zeroing.
> + */
> +#define FPI_ZEROED		((__force fpi_t)BIT(3))

Hmm now we have another flag to propagate this around... this is messy.

Now we have multiple different ways of representing this state... ugh.

> +
>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
>  static DEFINE_MUTEX(pcp_batch_high_lock);
>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
> @@ -1596,8 +1603,12 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>  	unsigned long pfn = page_to_pfn(page);
>  	struct zone *zone = page_zone(page);
>
> -	if (__free_pages_prepare(page, order, fpi_flags))
> +	if (__free_pages_prepare(page, order, fpi_flags)) {
> +		/* Don't mark zeroed if poison overwrote with 0xAA. */

Can we not reference arbitrary values in comments? And this comment seems
redundant.

> +		if ((fpi_flags & FPI_ZEROED) && !page_poisoning_enabled_static())
> +			__SetPageZeroed(page);
>  		free_one_page(zone, page, pfn, order, fpi_flags);
> +	}
>  }
>
>  void __meminit __free_pages_core(struct page *page, unsigned int order,
> @@ -3020,6 +3031,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  	if (!__free_pages_prepare(page, order, fpi_flags))
>  		return;
>
> +	/* Don't mark zeroed if poison overwrote with 0xAA. */

Same comment as above.

> +	if ((fpi_flags & FPI_ZEROED) && !page_poisoning_enabled_static())
> +		__SetPageZeroed(page);
> +
>  	/*
>  	 * We only track unmovable, reclaimable and movable on pcp lists.
>  	 * Place ISOLATE pages on the isolated list because they are being
> @@ -3058,6 +3073,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
>  	__free_frozen_pages(page, order, FPI_NONE);
>  }
>

No comment describing this? kdoc please.

> +void free_frozen_pages_zeroed(struct page *page, unsigned int order)
> +{
> +	__free_frozen_pages(page, order, FPI_ZEROED);
> +}
> +EXPORT_SYMBOL(free_frozen_pages_zeroed);

Do we have to use EXPORT_SYMBOLS()? Why not EXPORT_SYMBOLS_GPL()?

> +
>  void free_frozen_pages_nolock(struct page *page, unsigned int order)
>  {
>  	__free_frozen_pages(page, order, FPI_TRYLOCK);
> --
> MST
>

Thanks, Lorenzo

