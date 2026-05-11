Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BB5CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B00F6B00D2; Mon, 11 May 2026 11:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F806B00D5; Mon, 11 May 2026 11:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E826B00D6; Mon, 11 May 2026 11:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60ACD6B00D2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:05:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED9D5A0191
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:05:54 +0000 (UTC)
X-FDA: 84755463828.28.83AF35B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A5A31C0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:05:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqQRWa7u;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778511953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/nhlxmWYnisWEbfb8AIongQg6krwaJSNFCVRli+Rbo=;
	b=sRoR+buJDzHLtbDIC27YBqe345Jbi4c+vYPTrXTFMQAGPbpOXqGXMaIu57GrikTRH6u6Jj
	4s4kddqaBwNHexlFRw8PFeF+wqV/sdsT/YOToJ5kUGNYEjCRoWnsRCK/CjYdKcltDep4Wd
	MW62jSti3z3U8BM7FH1/TCgiFGgbJ+8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqQRWa7u;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778511953; a=rsa-sha256;
	cv=none;
	b=D+TijfSUD92Yt7lbzTqMFF7LSCSG41N8/FaUE1kC0vn5+hULU5rKsHflnxkgY4ZOOsbviC
	VVPvzxJlG3k+0CEu4IrikeWObs9W1OzeEfHsZzN5KGayhTOb54j7e7ayCH1HyncXuixW29
	uPPtGBheuMh/Hhjjq4rd70Da2tLfQPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15193419E7;
	Mon, 11 May 2026 15:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE152C2BCB0;
	Mon, 11 May 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778511952;
	bh=9nq15krdie2tt10iXFZRJtxrgUilXi8K8bqxQyDmbDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UqQRWa7u5mrpeYBzz6ABC7lL0Eh7sK/6uFPQzj72vk97V5xaN5eICVnBSVDH08c98
	 Y9Hne+nVS/5XQIQhV0db1rG10s1xdPDQ0JNIRe0+4KAriFIqrHbSajz/4ecJYtvXEy
	 7oypcsjdIJQijbx2ChHwx40QlNCTleaVu4M7/iCGoh8Pq+h2Ryjgq3PawRVhlM78Iq
	 T2PP8xidb4t4uYPyvIHkT4hIRrxPauIT21khoYU8ZdbMAyK696MVMomufVtDP6A4PC
	 5ivCwYcPmxcG1Udlb0rys3xhJ6GmAg7wjQtUihyDc8mkpkMAh4m44Riq+sclUNGAKq
	 du/BDGAgumaeQ==
Date: Mon, 11 May 2026 16:05:47 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
Message-ID: <agHmO4i4YUhs3cSG@lucifer>
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A5A31C0010
X-Stat-Signature: 7picqc53qf78ohpkqapjacgapa9wrufz
X-HE-Tag: 1778511953-292541
X-HE-Meta: U2FsdGVkX18iFptGeUgk2fxEcpk42LGatGUGWnAAs47rK4lHVNsuDX4Flih/A23TD3/HQ/saOkUQlBdk5VDgDOaZ8uJyypfd3ei4k1+f2gfQbShecG5xyEJmqhvW2pLzrHxepu1YVYeapdiwqv/Xpl/GgVknPp1vehdAMMBBnM3j5ysNrWE47pMGfUOVfdZls15/GvRckiR1xx+3huRmJPkVv/H9IacbHmkyO5vRxAiWYaJxJKXqq57W2C5F4L6nLjf1B9yRT1xN4ysorcNzsFqICNXyjqGjB8wxKS2IXpl9ty2nG5B7FykUD+QPISXSZX9wEGdTznM1J9W4cfmdp31Jh7aAhRm8IGqxOaAcah7n4XpZEFglmkLMECIKULvhU9vb1pOZonmRKVKqL9iXPaGuUpu+xlUy/5u402g099yKw/uCU1jQJkENLIruIR5ucON5CZ+bLmU1OmF7/UrTlnpDC87ho3fYSxeXbfwOljfwaWu8vb9mgpNgiuPAwz60/n99laslNFvi6jj87FMmDotNdgyOTbm4URtgnc6vrIuiOK98jNNfJB9tDOJfnmkSr0v+rVG8fJQwj/cy+XPyUwNXXcBOdMMWbyCVAe4/dXc/3gwucxCBV8gQ6w8pvUfSoyuDehIneCNPBm0byr3SuBlGyyH7LHEdtk1DdaSf2w8rbG5uB1uXhxcEiEVhmPHHP3XQTLS0o9WYfTjtsWFEPT9a/Sg4JRFyJVxMLxu49wkgl9YcmTnN2EuWpvsrv+PHemTAGzhnG1+KSagKm+P45GIFd59Z/FGfOIm3KXGadaOwAJmO0rFp2HaVxovw7/N0Ygg8gpj+WFMRfZAbLbK3/qN3OL+xE6RPXyKX3U6Mopv3s0mAbRKT5FZ+vLuY4Q5KKb1aDMvxb9hAjYBRvG1mZU5f7JXMjdkmeaBqsbSiDZKbVW266hFYl/tCgnBdzYvFd6+jCpNixJN7fF2IZJ1
 gdsJcDjv
 r3Rifo/PJx6jDsMZ16fgNNMMohe933DGjBbLLfw9NjSDN1lXcUfQtNb5mHdvXRB0CXwe60ehDgqAxDSVKt7rl6ciwj/z+xu1lZ5aKIPAZyr7kiWes2rE2JutpUyZRXy4fQ5IGKE9KPiPSwbYGGcIFDyZBdDHAirbUe4e2rmxcuUCiHfeowbxcCG7GytiS8ZWSaHa0aN+SnmMXCzz1KYvRaHMzZrhQ2OJCjlaNlu1J5kiCmZNhkIP5kjjQEXuz1Ac/YOOuC+7rswMqwIesvABHOBdU11MTmpUSUWiwwcqdg6ibNe3oFblpf+LeRBxLPA6NTepA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 06:24:45PM +0000, fujunjie wrote:
> When MREMAP_FIXED moves a range spanning multiple VMAs, remap_move()
> iterates over the source VMAs and skips source holes.  For each source
> VMA segment it narrows vrm->new_len to that segment length before calling
> mremap_to(), so the MREMAP_FIXED destination unmap is also limited to the
> current segment.
>
> If the source range contains holes and the destination range is already
> mapped, the destination subranges corresponding to those source holes can
> therefore survive the move.  That violates MREMAP_FIXED semantics, where
> the destination range is supposed to be unmapped before the move, and it
> also means that preserved source gaps do not necessarily become gaps in
> the destination.  Userspace can then observe mappings at destination
> addresses that should have become holes.

Hmmm I think it's a bit debateable honestly. The ability to handle there being
gaps is a _new thing_, so there are no semantics to speak of. Prevoiusly
mremap() simply required that you only span across a single VMA.

And the idea is that we're, conceptually, batching up an operation like moving:

|----|     |-------|  |-----|
|    |     |       |  |     |
|----|     |-------|  |-----|

To:

                                        |----|     |-------|  |-----|
                                        |    |     |       |  |     |
                                        |----|     |-------|  |-----|

Now if there was an existing VMA:

                                    |...................................|
                                    |                                   |
                                    |...................................|

The result of iterating through each and moving them individually would be:

                                    |...|----|.....|-------|..|-----|...|
                                    |   |    |     |       |  |     |   |
                                    |...|----|.....|-------|..|-----|...|

So it's not obvious that the source range spanning holes is actually indicative
of the caller wanting an unmap in each of these places.

The only semantics there, really, are that you are going to unmap the ranges the
destination VMA is going to span, which of course this still does.

I would argue that the semantics of 'aggregate does the same as if you were to
perform the operation individually on VMAs' trumps somebody assuming you're
'moving the gaps'.

So I think it's really not obvious that we should be treating unmapped areas as
if they were VMAs and to move 'space' too...

I'm also concerned that now we're changing a fundamental behaviour that users
might rely upon (as weird as it sounds). I mean changing this would arguably be
breaking userland.

Really the intent was to allow somebody to not have to worry about unmerged
VMAs, for cases where the VMAs _have no gaps_, and the ability to tolerate gaps
was added as a nice-to-have.

You also have to account for the fact that a partial failure may occur, at which
point you've done a rather strange, partial, unmap.

Is there an actual use case that wants this behaviour?

>
> Unmap the full fixed target range once before moving the first source
> segment in the multi-VMA move path.  Split mremap_to() into a wrapper that
> performs the MREMAP_FIXED target unmap and a lower-level __mremap_to()
> helper that assumes any required target unmap has already been handled.
> Then the multi-VMA path can call __mremap_to() after clearing the full
> fixed target, while the single-VMA path continues to use mremap_to().
>
> Use a common unmap_fixed_target() helper for both the ordinary mremap_to()
> target unmap and the full-range target unmap.  This keeps the existing
> iterator invalidation and source VMA reload behaviour in one place.  The
> full target unmap still uses the existing uf_unmap_early path for
> userfaultfd unmap notifications.
>
> Extend the multi-VMA mremap selftest to check that the destination pages
> corresponding to source holes are unmapped after mremap().  This covers
> both MREMAP_FIXED and MREMAP_FIXED |
> MREMAP_DONTUNMAP.
>
> Fixes: d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs")
> Cc: stable@vger.kernel.org # 6.17+
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/mremap.c                              | 92 +++++++++++++++++-------
>  tools/testing/selftests/mm/mremap_test.c | 52 ++++++++++++++
>  2 files changed, 118 insertions(+), 26 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e9c8b1d05832..e91fff2ba3ce 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1430,37 +1430,39 @@ static unsigned long shrink_vma(struct vma_remap_struct *vrm,
>  	return 0;
>  }
>
> +static unsigned long unmap_fixed_target(struct vma_remap_struct *vrm,
> +					unsigned long addr, unsigned long len)
> +{
> +	struct mm_struct *mm = current->mm;
> +	unsigned long err;
> +
> +	err = do_munmap(mm, addr, len, vrm->uf_unmap_early);
> +	vrm->vma = NULL; /* Invalidated. */
> +	vrm->vmi_needs_invalidate = true;
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * If we remap a portion of a VMA elsewhere in the same VMA, this can
> +	 * invalidate the old VMA. Reset.
> +	 */
> +	vrm->vma = vma_lookup(mm, vrm->addr);
> +	if (!vrm->vma)
> +		return -EFAULT;
> +
> +	return 0;
> +}

It might be nice to factor this out even if we don't take this patch...

Be good to also update the unmap_source_vma() case to to use it if we can. We'd
want in that case though to figure out if we want to lookup the VMA though, and
then optionally have a VMI... anyway :)

> +
>  /*
> - * mremap_to() - remap a vma to a new location.
> + * __mremap_to() - remap a vma to a new location, assuming any required
> + * MREMAP_FIXED target unmap has already been handled.
>   * Returns: The new address of the vma or an error.
>   */
> -static unsigned long mremap_to(struct vma_remap_struct *vrm)
> +static unsigned long __mremap_to(struct vma_remap_struct *vrm)
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long err;
>
> -	if (vrm->flags & MREMAP_FIXED) {
> -		/*
> -		 * In mremap_to().
> -		 * VMA is moved to dst address, and munmap dst first.
> -		 * do_munmap will check if dst is sealed.
> -		 */
> -		err = do_munmap(mm, vrm->new_addr, vrm->new_len,
> -				vrm->uf_unmap_early);
> -		vrm->vma = NULL; /* Invalidated. */
> -		vrm->vmi_needs_invalidate = true;
> -		if (err)
> -			return err;
> -
> -		/*
> -		 * If we remap a portion of a VMA elsewhere in the same VMA,
> -		 * this can invalidate the old VMA. Reset.
> -		 */
> -		vrm->vma = vma_lookup(mm, vrm->addr);
> -		if (!vrm->vma)
> -			return -EFAULT;
> -	}
> -
>  	if (vrm->remap_type == MREMAP_SHRINK) {
>  		err = shrink_vma(vrm, /* drop_lock= */false);
>  		if (err)
> @@ -1486,6 +1488,23 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
>  	return move_vma(vrm);
>  }
>
> +/*
> + * mremap_to() - remap a vma to a new location.
> + * Returns: The new address of the vma or an error.
> + */
> +static unsigned long mremap_to(struct vma_remap_struct *vrm)
> +{
> +	unsigned long err;
> +
> +	if (vrm->flags & MREMAP_FIXED) {
> +		err = unmap_fixed_target(vrm, vrm->new_addr, vrm->new_len);
> +		if (err)
> +			return err;
> +	}
> +
> +	return __mremap_to(vrm);
> +}
> +
>  static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
>  {
>  	unsigned long end = vma->vm_end + delta;
> @@ -1882,9 +1901,11 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  	unsigned long start = vrm->addr;
>  	unsigned long end = vrm->addr + vrm->old_len;
>  	unsigned long new_addr = vrm->new_addr;
> +	unsigned long new_len = vrm->new_len;
>  	unsigned long target_addr = new_addr;
>  	unsigned long res = -EFAULT;
>  	unsigned long last_end;
> +	bool fixed_target_unmapped = false;
>  	bool seen_vma = false;
>
>  	VMA_ITERATOR(vmi, current->mm, start);
> @@ -1939,8 +1960,27 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  		}
>
>  		res_vma = check_prep_vma(vrm);
> -		if (!res_vma)
> -			res_vma = mremap_to(vrm);
> +		/*
> +		 * remap_move() narrows vrm->new_len to the current source VMA
> +		 * segment before calling mremap_to(). For sparse source ranges
> +		 * this would leave target ranges corresponding to source holes
> +		 * mapped.
> +		 *
> +		 * If the requested source range extends beyond the first VMA,
> +		 * unmap the full fixed target range once, using the original
> +		 * new_addr/new_len, before moving any segment.
> +		 */

Hmm yeah one batched up operation to unmap the whole range? That's not correct
from the point of view of partial failure cases, now you're unmapping _the whole
range_.

I think it's not useful to reference the 'narrowing', I think it's confusing to
use 'new_len' to mean 'unnarrowed new_len', which of course has to be equal to
old_len to even be here.

You'd need to rename that to something sensible, like range_len.

Also that original length might include a trailing space _after_ the end of the
range.

So you might end up unmapping stuff _past the end of the range_ of the range you
are moving, which might unmap real stuff, which is completely incorrect.

Honestly I'm really thinking that we don't want this behaviour. It's simpler to
treat this as aggregated mremap()'s, and if a user needs this kind of behaviour
they can unmap the target range themselves, it's not difficult.

Maybe the real TODO here is to update the man page to make this clear.

> +		if (!res_vma && !seen_vma && vma->vm_end < end) {
> +			res_vma = unmap_fixed_target(vrm, new_addr, new_len);
> +			if (!res_vma)
> +				fixed_target_unmapped = true;
> +		}
> +		if (!res_vma) {
> +			if (fixed_target_unmapped)
> +				res_vma = __mremap_to(vrm);
> +			else
> +				res_vma = mremap_to(vrm);
> +		}

I don't love this, we're taking an already badly named function (mea culpa,
though in <kinda> my defence I was continuing a tradition at least :)

And now you're adding more complexity and more state just to figure out if you
need to unmap here, yeah again, I think the existing behaviour is better
overall.

>  		if (IS_ERR_VALUE(res_vma))
>  			return res_vma;
>
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 308576437228..ebbe1aa42ef0 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -419,6 +419,54 @@ static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
>  	return true;
>  }
>
> +static bool is_range_unmapped(void *addr, size_t size)
> +{
> +	void *ptr;
> +
> +	ptr = mmap(addr, size, PROT_NONE,
> +		   MAP_PRIVATE | MAP_ANON | MAP_FIXED_NOREPLACE, -1, 0);
> +	if (ptr == MAP_FAILED) {
> +		if (errno == EEXIST)
> +			ksft_print_msg("range %p-%p is still mapped\n",
> +				       addr, (char *)addr + size);
> +		else
> +			perror("mmap MAP_FIXED_NOREPLACE");
> +		return false;
> +	}
> +
> +	if (ptr != addr) {
> +		ksft_print_msg("mmap MAP_FIXED_NOREPLACE returned %p, expected %p\n",
> +			       ptr, addr);
> +		munmap(ptr, size);
> +		return false;
> +	}
> +
> +	if (munmap(ptr, size)) {
> +		perror("munmap MAP_FIXED_NOREPLACE probe");
> +		return false;
> +	}
> +
> +	return true;
> +}

This is not a great way of figuring that out, you can use the procmap_query
stuff to figure out it out from vm_util.h, see open_procmap(), query_procmap(),
find_vma_procmap(), etc.

> +
> +static bool multiple_vma_holes_unmapped(char *ptr, unsigned long page_size)
> +{
> +	static const int holes[] = { 1, 3, 7, 9 };
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(holes); i++) {
> +		char *addr = &ptr[holes[i] * page_size];
> +
> +		if (!is_range_unmapped(addr, page_size)) {
> +			ksft_print_msg("target hole page %d is mapped\n",
> +				       holes[i]);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  static void mremap_move_multiple_vmas(unsigned int pattern_seed,
>  				      unsigned long page_size,
>  				      bool dont_unmap)
> @@ -529,6 +577,10 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
>  		success = false;
>  		goto out_unmap;
>  	}
> +	if (!multiple_vma_holes_unmapped(tgt_ptr, page_size)) {
> +		success = false;
> +		goto out_unmap;
> +	}
>
>  out_unmap:
>  	if (munmap(tgt_ptr, 2 * size))
>
> base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
> --
> 2.34.1
>

Cheers, Lorenzo

