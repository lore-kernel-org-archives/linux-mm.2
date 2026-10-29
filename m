Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD23606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V43TEX6F
Received: by kanga.kvack.org (Postfix)
	id AADB96B05B8; Thu, 29 Oct 2026 03:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EF96B05B9; Thu, 29 Oct 2026 03:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974576B05BA; Thu, 29 Oct 2026 03:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75A3B6B05B8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:45:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A3EFA1248
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:35:56 +0000 (UTC)
X-FDA: 85374854712.18.EE737DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6AC74C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:35:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V43TEX6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793259354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Epe+yalr0ncnNFeZXalmoB1ngEy5h1+ZCqluOO5m08=;
	b=FyuUpnbXhkjuApfcXZD0TgxS4nIyxJRuwUg3CSghaOBnoAA5YoP0XBMEu70diG4HveDyBu
	N8HAqNn5UGsa6KK+9BJHYXQrE9qwmgUZS8/fVKD6PgFFIi4hCipOQb7D8awFatzz7BLjnA
	6ZiTpv1NxRsB55waSTPsTvAdmIAq0CI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V43TEX6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793259354;
	b=kWPA2NP1TwDMBu349yFDOeifWCsYr0bOPraj825XOxvny5aPXUx/Fr5co5nEZSEPZDCT/m
	uJFyFrIbO6zWYluNjZJN2DGiCWMnWGHguJbcwRZCc+2ZuKqcvlYlxk1U9K7ir9MrvRLa8C
	rdJ8/pRnZxZwcp+plcN+4BmRMnJBDKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E663760211;
	Thu, 29 Oct 2026 07:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135EB1F01825;
	Thu, 29 Oct 2026 07:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793259353;
	bh=0Epe+yalr0ncnNFeZXalmoB1ngEy5h1+ZCqluOO5m08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V43TEX6Fw8eQjHoTKHC2CRjnughswM+IkpybdsCO33FGiISABle3TSCUtdt1TfgZq
	 3sAW4vI1itqPrr1APjhXZ2+WNM0GpELOy/iz6lHNCH1x67fMMjVvCPM1iCzBjpztZZ
	 +vANLaBPjgNZl6lOPZE8fT+fb7OJAXTU2/WYUH3uId87pAVR1tYrLsK8H0iiPVA2LZ
	 RvESoKXHo76HJUx1MFCdBo0JlI+nULCC7LyN3AtDbTITDzparVWWDKdwpAb700rNdu
	 sPBVj66V4DQodubdnKCLyPjO0hDmKnJ5Aah5iOhJOFbUSgfy3jwfoG69l66HZYPKI6
	 Rb9qyByArGDbQ==
Date: Thu, 29 Oct 2026 09:35:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	graf@amazon.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] kexec: do not place the next kernel in a
 fixed-address CMA area
Message-ID: <auL3UW2InVqYU6Fs@kernel.org>
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
 <20261014145731.3431527-2-radhey.shyam.pandey@amd.com>
 <2vxzh5i5orbv.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzh5i5orbv.fsf@kernel.org>
X-Rspamd-Queue-Id: 6AC74C0005
X-Stat-Signature: 8cyztsktfciw3hqaouqdz4gbjg55spgw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793259354-362213
X-HE-Meta: U2FsdGVkX19DBL+szmmpb5XqjNsV7K+Tlld7dwpNHTX3BWXHcPVnygeYovY3O+maFqhdW9Q4gDfZczkWmhGvpypOGxAX+0aGBzZFTy8Acb0vqBLwYU/6V+R5jdrMrcC4BjxAOtSP1f+9TPJyZZBEWnrPo2E4/wANXHb+9YBc+AgWDXbmtErMywdbISFa9fDySn3lgRa4sSyTgHZj8wGuYPmDsfiIllskYkWZhTdPqK8RnbO13pAmh8f5WxCnAwkwe4GNhPDsFshPxOmItkufM3dljw7ItVNI1u92Elvt6D9eCUVee8N/QiWMZrkjxuz/rlLQsscwjxSEajmkRNd30EAjE1CW9/DlQvPINhVtehfQb8ViS+rHpdf+3XsvIGLoI6TS1oKiIl6slmt/y7EfFe6QAsBeGrAPOJbEhz6zTbb0ZjUZ3wKBvwU5+w11YNipLcTvw/4PXjqTFg34k+UVTQUbzf/75FvfPAaO8GT1v8mMUwc/a0z3bwOZJrwEoZm/fkDDKFeWIePa+Yg6jemX0XsoQ1PXg8jYM/RfsTllWsbcT2qMC5+96TpF2O6HJyg6Qh6+LhEJuy9MQLZFTE9iawOYqR3iuvglGBipW8kc+HOPQsbpIXNJLqgAtXlrD0tIcsvxnDzGOmL5ttJ/66+cb3wR8GcYcWrQPn6/RrLGQ3HxvzgV1qKSi9TCC+OwqGyDxHiP9DZOh+YSr2oMVozoieoyQk1stNfFdllTN1W1gAswEAt/UQVi4LGSNBCBb2SKX244w8uKFqWG5r7STibXoljGWE0LGDvjChWZ6H/gyZo5aMwv2DTPH1ZD2prT/csAQSSoUK7JtDcdt3tX+0A5dB/b8FepV6p9tENVqhL3/lVY6ZiJ/YXvQoTGQk0OC7npoA+ZiY6RJIUTWcxBnF2tu487KddbE5/tgt/NmNaPgwBJizszD/KzJpE7MlbkQ+KnRhezVrs0KL04hAsbDIG
 rjeBC8l7
 0EOUQqaavbWcZOK8SsOOapHMKCU1UQphhBUH96aLjGLC/MCxBNJVdYIJbJIUwo4RcGG8Ge2T16ZV4kKerqLNNqh3f5sedmeVX511iQf5E1zlUfDFs5UX46oL3WT/oeO9L9e6C/c+EmNPmLXFUxk4nyMxhnA7bsZLcEbPImikb+xTKQgAv7LwDY2Fvxdvth3PDAOecjOO9EZrnNFRloK+bvN9ayfIYhGgR2sQggPCGerSOzOmp1rPrxyZmmCyCE03/8oKiqxg4yEgTOr5cTrpoW/Mxx0kySQzA5qp2XANu8JGJUX8Ye7Hgbdze2vWEjHm+UYqvIjJmuI8bkxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 03:03:16PM +0100, Pratyush Yadav wrote:
> On Wed, Oct 14 2026, Radhey Shyam Pandey wrote:
> 
> > kexec_alloc_contig() picks the destination of the next kernel out of the
> > default CMA area, and the next kernel then runs from there in place
> > instead of being copied out. That is only safe if the area will not exist
> > at the same address in the kernel being loaded.
> >
> > For an area whose base came from the device tree, it will. The loaded
> > kernel parses the same description, declares the range it is executing
> > from as a shared-dma-pool, and cma_activate_area() releases the pages
> > holding its own image to the page allocator.
> >
> > Distinguish the two cases. An area placed by cma_declare_contiguous_nid()
> > without a fixed base lands wherever this kernel found room, and the next
> > kernel repeats that search against its own memblock state, so it cannot
> > collide. Record the difference as CMA_FIXED_BASE and refuse to use such
> > an area for the payload, which leaves kexec_locate_mem_hole() to fall
> > back to the memblock hole search as it did before CMA placement existed.
> >
> > This is what makes the KEXEC_FILE_NO_CMA flag unnecessary on platforms
> > that describe their CMA pools in the device tree.
> >
> > Tested on a AMD Versal AI Edge Series Gen 2 VEK385 Evaluation Kit whose
> > device tree declares three CMA pools, the first of which is
> > linux,cma-default:
> >
> >   cma_reserved@800000000     4 GiB at 0x800000000    (default)
> >   cma_reserved@50000000000   6 GiB at 0x50000000000
> >   cma_reserved@60000000000   4 GiB at 0x60000000000
> >
> > All three have a fixed base, so kexec_alloc_contig() declines the default
> > area and kexec_locate_mem_hole() falls through to the memblock search,
> > which places the Image segment at 0x9c00000 size 0x1de0000. The kernel
> > that boots from it reports its image as [0x09c00000-0x0b9e0000] and
> > 14680064K cma-reserved, i.e. all three pools still present and none of
> > them overlapping the running kernel.
> >
> > Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> > ---
> >  include/linux/cma.h | 10 ++++++++++
> >  kernel/kexec_file.c | 12 ++++++++++++
> >  mm/cma.c            | 16 ++++++++++++++++
> >  mm/cma.h            |  2 ++
> >  4 files changed, 40 insertions(+)
> >
> > diff --git a/include/linux/cma.h b/include/linux/cma.h
> > index 8555d38a97b1..2fe66377e5d3 100644
> > --- a/include/linux/cma.h
> > +++ b/include/linux/cma.h
> > @@ -61,4 +61,14 @@ extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
> >  extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
> >  
> >  extern void cma_reserve_pages_on_error(struct cma *cma);
> > +
> > +#ifdef CONFIG_CMA
> > +bool cma_has_fixed_base(const struct cma *cma);
> > +#else
> > +static inline bool cma_has_fixed_base(const struct cma *cma)
> > +{
> > +	return false;
> > +}
> > +#endif
> > +
> >  #endif
> > diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> > index b668ce8d68ee..10e770bcee0b 100644
> > --- a/kernel/kexec_file.c
> > +++ b/kernel/kexec_file.c
> > @@ -28,6 +28,7 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/dma-map-ops.h>
> >  #include <linux/kexec_handover.h>
> > +#include <linux/cma.h>
> >  #include "kexec_internal.h"
> >  
> >  #ifdef CONFIG_KEXEC_SIG
> > @@ -691,6 +692,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
> >  static int kexec_alloc_contig(struct kexec_buf *kbuf)
> >  {
> >  	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
> > +	struct cma *cma;
> >  	unsigned long mem;
> >  	struct page *p;
> >  
> > @@ -702,6 +704,16 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
> >  	if (kbuf->image->type == KEXEC_TYPE_CRASH)
> >  		return -EPERM;
> >  
> > +	/*
> > +	 * The next kernel runs from here rather than being copied out, so it
> > +	 * would declare this area again from the same description and release
> > +	 * the pages holding its own image to the page allocator. Only an area
> > +	 * this kernel placed itself is safe to use.
> > +	 */
> > +	cma = dev_get_cma_area(NULL);
> > +	if (!cma || cma_has_fixed_base(cma))
> > +		return -EOPNOTSUPP;
> > +
> >  	p = dma_alloc_from_contiguous(NULL, nr_pages, get_order(kbuf->buf_align), true);
> >  	if (!p)
> >  		return -ENOMEM;
> > diff --git a/mm/cma.c b/mm/cma.c
> > index a10ea37a261d..1f4d3d48a3bb 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -55,6 +55,19 @@ const char *cma_get_name(const struct cma *cma)
> >  }
> >  EXPORT_SYMBOL_GPL(cma_get_name);
> >  
> > +/**
> > + * cma_has_fixed_base() - was the area placed at an address it did not choose?
> > + * @cma: Contiguous memory region
> > + *
> > + * Such an area is described outside the kernel, typically by a device tree
> > + * reserved-memory node, and so lands at the same address in every kernel
> > + * booted with that description.
> > + */
> > +bool cma_has_fixed_base(const struct cma *cma)
> > +{
> > +	return test_bit(CMA_FIXED_BASE, &cma->flags);
> > +}
> > +
> >  static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
> >  					     unsigned int align_order)
> >  {
> > @@ -304,6 +317,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
> >  	cma->ranges[0].count = cma->count;
> >  	cma->nranges = 1;
> >  	cma->nid = NUMA_NO_NODE;
> > +	set_bit(CMA_FIXED_BASE, &cma->flags);
> >  
> >  	*res_cma = cma;
> >  
> > @@ -517,6 +531,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
> >  	}
> >  
> >  	(*res_cma)->nid = nid;
> > +	if (!fixed)
> > +		clear_bit(CMA_FIXED_BASE, &(*res_cma)->flags);
> 
> Nit: This reads a bit odd. cma_init_reserved_mem() sets the fixed base
> and then you clear it later. Wouldn't it be better to just pass the
> fixed boolean to cma_init_reserved_mem()?

Actually, we shouldn't expose cma_init_reserved_mem() at all.

The current callers of cma_init_reserved_mem() should be switched to
cma_declare_contiguous_nid() that does sanity checks before calling
cma_init_reserved_mem().

This way the callers won't need to keep the checks for e.g
CMA_MIN_ALIGNMENT and we'll have the clear way to differentiate areas with
fixed based from allocated ones.
 
> With that fixed,
> 
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> 
> >  	*basep = base;
> >  
> >  	return 0;
> > diff --git a/mm/cma.h b/mm/cma.h
> > index 68e574b0f951..1bab24033284 100644
> > --- a/mm/cma.h
> > +++ b/mm/cma.h
> > @@ -80,6 +80,8 @@ enum cma_flags {
> >  	CMA_ZONES_VALID,
> >  	CMA_ZONES_INVALID,
> >  	CMA_ACTIVATED,
> > +	/* Base address was dictated by the caller, not picked by CMA. */
> > +	CMA_FIXED_BASE,
> >  };
> >  
> >  extern struct cma cma_areas[MAX_CMA_AREAS];
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

