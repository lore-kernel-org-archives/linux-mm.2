Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E3CD606A88D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=an6rnEFH
Received: by kanga.kvack.org (Postfix)
	id 2EFA26B05B1; Thu, 12 Nov 2026 13:05:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FFF6B05B2; Thu, 12 Nov 2026 13:05:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6296B05B3; Thu, 12 Nov 2026 13:05:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB44B6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:05:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A1741C23D2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:05:35 +0000 (UTC)
X-FDA: 85427244630.11.C4BAE2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87670180010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:05:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=an6rnEFH;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506733;
	b=4s32e7bHjl+ofkz2gJH2Ic5pEjnKmoZ4UKQo8al6RdspkascM61gQ4eXblBFOGcnpB3wvT
	QXuAyS4/0vPR0yOrKA00bV5KscysMRC4t09ngPXHHZmdLKv0YfRTcv5KGuiqV9ae2kfkVU
	+I7UeZx4xtAogemYJT22EkNEayv+TLU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=an6rnEFH;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cG8SYyf7w3dlGbNaL5P0O22CIF0Qp5uX3wBmRgVBppY=;
	b=n/BhXwMZMPWE06T7mmxjBXluphrT1yaNgGaFMwO8SWt08uwCeSZfmYfOiAPSBPEPIZJoP7
	Xhft8/JnV1KCnivJ/P60EnTDrv2WW6wYYUAPkVytEeqBXJLcQmvT1viKEaPWJCWiBGzZDz
	Wtw2oVmelOTnjw7Igvcwl+zzqwO11+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4785A623A0;
	Thu, 12 Nov 2026 18:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229B61F000C4;
	Thu, 12 Nov 2026 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794506732;
	bh=cG8SYyf7w3dlGbNaL5P0O22CIF0Qp5uX3wBmRgVBppY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=an6rnEFHIEQfMD7hb2IewvTV/EyagK+WFjhHhGs/7elOcrogcIsxGsV7IEc9I16wr
	 cANtce9G2vgpUy5lhY17FNcwQneKEIcYIY+W5IJ0slGgd16Qk/Qh3Wvfb0zV4chVhc
	 IWjf74UV4A1kTN4ldOCaeItZJzfYiJbdziIksaMS+AIHq/71swxVE3OezZ1iatBt1x
	 mY6EFh67QqtG015uZu6gP3MiS82xe2OjWemIl7CKMV8h3i1bYCNpH9tYb/TROWIPLE
	 piSdwUrsYtmEhsz/5LVnzo3yxJqT7rc1ZXvFCJsvQ/MIJ7Bb3Se55tS3K7ruw2DYyY
	 auQZ8KPUL8o4Q==
Date: Thu, 12 Nov 2026 18:05:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/12] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
Message-ID: <avX_qlthMqypxHm0@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-1-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-1-00713d368976@columbia.edu>
X-Stat-Signature: an1fdqttmzpjqhcgmc3ks9h3jmyszrig
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87670180010
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794506733-303682
X-HE-Meta: U2FsdGVkX18klNw1AQlA30xARag5H2H+SQM81/8m8yJ6/+UBIwRBYzowxbIfft8in/xd58sGqMUQeKkZYVOaB7xHeWad5LqWuSMIMjtk/8EUOF0huP23whLKO/7+ghNu1wwMlLP4QKAuA1+FuLwvJ9xhtc1ZN6qDQeLMtsZIC9psvIINouXsePE0eRKgERNkWiNnAF7mBazHBPqH7b61aGyAUx88HDoHqDEWs7JfsKOT+/hpuROSsHTOUZTBjoaGBmjWHhJucfdISdCNR399Q035dM8hI3uAWWw1HIhcA1hwf+Eq8LLRr9eCIn/tX0dZEI3gZIHPN3KaUN/j2ihZSvIppGAQem04io9pXHxrJMSUzdqHhQwyRrxaikxXwcpJU2dgSrNtkxHClwUZrpksB8d62J9V/4KhPVGUYdLf/eO5Wfz6QFTV3nGe/DeWKria0uysr6it9tKF3dHe+Mz1DomKFDFarJgWJ2JGzci3YUm9cL+rNpf/rkLYlZFV71ANmfpYs0h3SFngvFPWTFnZ/E2n5hKMVNM5LMFAYVWfZP9uKEM8Y3RNUoS8OPak3helGfRofPZ9Pubmlm0WsYd3F0baHz77D1amSk8jxm5/WPUmxGsyNrzOb/rrTDwlc3wv8xg78IxoVaaakBVSYwDHTI/jhAbXoY7yencZ4eGfLNdVGi/097WbM0c5ngjyrlMMy2QDVX2T2D+Ft8K/TObb6aXxD2fqxHCH+A75GNH3lhTO/nKdCro5OXVpq+UKZUCvJZH4rvHYwDS9YdNAqJYYkYgTdYxL2aW4sZJ1c9BTVoeAV01pmamFDn8mx72YMxZxRXwXAtd2Gb4GLq3ZIzXAux+bCIxGLBy3EPjygZ3BTPmuWFU+XJ1npR9JDTVZ4mL2jLY8STzkty5p4gRC4zx9AJfZcwTHJ5c3kD6dUQWtA6WrPvJ8r8JM4BRpXvvzPHN1iZtlDTYzB0PKAfgrK4z
 cQFSHH7o
 EX3lX//PiV1bBELy16Nazj0mgynTllkqwHPmKutmszRKZJ6G6Tm0hR1PLY92iZBL/WzeKwkUqlW7EsLTjiLf8/z/1vm+yYSeKWRuH7j9TcW6WLPaLG3yUlHw4G4Ka6BbhzyDK4iE5OUVjMv0fLJ2I7HjA8+VDM2aBxXNne/6ym8N39zbWY1iTnEjxl8DMcGia6sRYRaG+/W3IBCc/75T/oRtdSgLs7V3n3qw4XA0RT04c85NG9/h9WE6CFSa7UEBssBzcNuaMacse5rCE7VLh/gqK2EI5ykaNkm5ABkBiDbZEfzd8WyzMdYGGzb5DZ9aEULaA9l7XUtrQ+QFZt1ws77xe/D4rmqFWvP7IPasuQ74+R7qBM3lKCAp+p2V8CrIjYpimiMZQifSLx7b+hhnx3UnT2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:09PM -0500, Tal Zussman wrote:
> If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
> mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
> installs it through vma_uffd_ops(), no matter what kind of mapping it
> is. An s390 KVM guest with storage keys or protected virtualization is
> such an mm.
>
> For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
> cache of the file. That is wrong: a private mapping must never modify
> the file it maps, and the file might even be mapped from a read-only fd.
>
> The ioctl can also fail where it should succeed. A missing fault is only
> delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
> an address that did not fault, or can race with a write to the file. If
> the file has a page at that offset by then, inserting the zeroed folio
> fails and the ioctl returns -EEXIST although nothing is mapped at the
> destination address.
>
> What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
> shared zero page can be used, and what UFFDIO_COPY does: only check that
> nothing is mapped at the destination address, map zeroed memory there,
> and leave the page cache alone. The zeroed folio path did that before it
> was moved to vm_uffd_ops.
>
> To fix it, pick the ops in the common folio path, as
> mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
> mapping, the ops of the VMA otherwise. That makes
> mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
> so remove them and rename __mfill_atomic_pte() to
> mfill_atomic_pte_folio().
>
> UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
> if something is already mapped at the destination address.
>
> Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks sensible (also another cleanup in disguise which I like ;):

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
>  1 file changed, 16 insertions(+), 30 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index d65184d9a480..61a712e1f9f5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -531,15 +531,27 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
>  	return 0;
>  }
>
> -static int __mfill_atomic_pte(struct mfill_state *state,
> -			      const struct vm_uffd_ops *ops)
> +static int mfill_atomic_pte_folio(struct mfill_state *state)
>  {
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  	unsigned long dst_addr = state->dst_addr;
>  	unsigned long src_addr = state->src_addr;
>  	uffd_flags_t flags = state->flags;
>  	struct folio *folio;
>  	int ret;
>
> +	/*
> +	 * The normal page fault path for a MAP_PRIVATE mapping in a
> +	 * file-backed VMA will invoke the fault, fill the hole in the file and
> +	 * COW it right away. The result generates plain anonymous memory.
> +	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> +	 * generate anonymous memory directly without actually filling the
> +	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> +	 * the pagetable (to verify it's still none) and not in the page cache.
> +	 */
> +	if (!(state->vma->vm_flags & VM_SHARED))
> +		ops = &anon_uffd_ops;
> +
>  	if (!ops) {
>  		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
>  		return -EOPNOTSUPP;
> @@ -597,32 +609,6 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  	return ret;
>  }
>
> -static int mfill_atomic_pte_copy(struct mfill_state *state)
> -{
> -	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> -
> -	/*
> -	 * The normal page fault path for a MAP_PRIVATE mapping in a
> -	 * file-backed VMA will invoke the fault, fill the hole in the file and
> -	 * COW it right away. The result generates plain anonymous memory.
> -	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> -	 * generate anonymous memory directly without actually filling the
> -	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> -	 * the pagetable (to verify it's still none) and not in the page cache.
> -	 */
> -	if (!(state->vma->vm_flags & VM_SHARED))
> -		ops = &anon_uffd_ops;
> -
> -	return __mfill_atomic_pte(state, ops);
> -}
> -
> -static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> -{
> -	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> -
> -	return __mfill_atomic_pte(state, ops);
> -}
> -
>  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
>  {
>  	struct vm_area_struct *dst_vma = state->vma;
> @@ -634,7 +620,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
>
>  	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
>  	    (dst_vma->vm_flags & VM_SHARED))
> -		return mfill_atomic_pte_zeroed_folio(state);
> +		return mfill_atomic_pte_folio(state);
>
>  	_dst_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
>  					 dst_vma->vm_page_prot));
> @@ -927,7 +913,7 @@ static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
>  		return mfill_atomic_pte_poison(state);
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> -		return mfill_atomic_pte_copy(state);
> +		return mfill_atomic_pte_folio(state);
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
>  		return mfill_atomic_pte_zeropage(state);
>
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

