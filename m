Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF0A606EE93
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUwUm4Yj
Received: by kanga.kvack.org (Postfix)
	id A3B8B6B05CA; Tue,  3 Nov 2026 03:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13536B05CC; Tue,  3 Nov 2026 03:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956766B05CA; Tue,  3 Nov 2026 03:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7F06B05CA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:37:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13D8C1C2708
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:37:30 +0000 (UTC)
X-FDA: 85393153860.04.59D2562
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7F47C140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:37:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUwUm4Yj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36ue9l0lxjyreF2KAgVZ/S2Q5NtWJdd1uqKRENrbVrc=;
	b=LOkxb9kgcQxXWEQqT/voet32h81oFs+AGz9hBHaGXNKE9bPad1YxQtQqxC0aRDzJYBWVZ2
	9gmkvJAWkfcOPCBaYQv2kTzwMAj1uPfvJOqr0kgHtlsngcrfbdZlbG012Y9L0migPlFJEh
	CstQ4jc/PQpgQxF1EpxAK2G3iY+8fAU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUwUm4Yj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695048;
	b=8YCYMx0jlkDXPM2OXXskcwm7TokSFxKsO+huF1O85iTvDeEFQccPmauIW9ZwnytLCX1AuJ
	Jkr8NnWgI2O8cjFtGmIerO8IcVAfsNtqLy4vmjEu8TnE21qYsnb7quSPvgua7IOUAhgg08
	fZF0eFQFHIe70cEQ1F2pfVR7jOC+fxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F4A160098;
	Tue,  3 Nov 2026 08:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1721F01802;
	Tue,  3 Nov 2026 08:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695047;
	bh=36ue9l0lxjyreF2KAgVZ/S2Q5NtWJdd1uqKRENrbVrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aUwUm4YjE8yZ8DotXKncj8C+/v6y2l2qeBxMJD7QAKiAlCAfdY8kyLGH1ztvVMvyV
	 sdOVKjuU7ve7ffcYq0mLG5F+l8VjouhdEEMOdvnZO5hsmN4mmhxVpT2IDhB6T6hwm7
	 GHd5lNmqj6ppo+OChkh7KYRTE0/YRrlOiqkwS+oqX2ywjeNDN+iYPB04iugqbhlHtP
	 NiVapLY/XPLWd1zEevrTBvrSKCiyN3x8cWPqww4zT32H+TT2+Mn8oyWsYENsn5Fbc5
	 PhHT1uLMSfC8sCf6sVMyDL0ESyBMCEi4ercOoaNw5oxRvU+hEo+pr+laB7KB9zLawD
	 YH4mrIgI6UIew==
Date: Tue, 3 Nov 2026 08:37:19 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] mm: remove read_cache_page_gfp()
Message-ID: <aumdHgUtiQzkNzs6@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F47C140006
X-Stat-Signature: 3hcfr3cfa4ygdbqfzytheh7meqi3un8k
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793695048-786660
X-HE-Meta: U2FsdGVkX1+OLKW/4AUbNNY2CB5urzhW58ZmF9R6rhCndVjyMEx++744+e0WqAKO7OETeuWkOKFbl6P9hrpiFUw/uDWXc8QRqCd2o+So98TdD6wfdVdxtP0E/JXpAl7M5EggwobmSySNjU7ZjrrXikCZDjDtUIE+pl1EF8nwWSs2AOa8wiMDjP2+vJhoR3Aw+rs/9WYJLU26KgZxi7azdsH8VTaSVCEHN5nsWTapHVW/DG1YYNhkxmOIQkaWyfelNfhxtiwadyztoGm3vwYLAhwCDiv3So/Rng+QhKEm6os8rLpXkfNKRHlAQQycqbwCyOLDYerGyuM3CnxlGfBd/8faqmi/nMhOwJS7nMt41AaUOIXT8Tqj4FkTU1MTOxItsjnd8SCkEyGFr/jM/PW6gqis5LvnfYEVB3+auU+Xz8nwwwPjQWUrNCRtFu7u/d0clbzUeJy14uOBTYtI4pFCBrtOAE+mjJx9eHulJ73VYo4t3hdzpKhlQm0PqewKJCGJ52y20LnMCtZviq4vh9i61pwPysiOPgQjEhR3O+dYCg4EBzSWRhuDyHE8OMOeTOWIz31az0l62KfsF8M0uZHhNppVqdJJokk2Lf4Me/Vn3d+7JJ5EwNYQoXrzI1jh4CkZ0LyWb8z6/MJc0HgmfLIp8NBybCUisdmWlBVuKQo964UJE4aVpKAeTBctYNDPQapxax4B70hxnhDQvA/tqwaj8P9s1GUgi3jCBjBuufSflGa6Kqhc5XtAHEM7CApSUCSMVgXchWmd1cItz9fqDURbE2vmrLbKE+3X+2L8VFfwgfuf1EZObLDUrCfFHWKhp+NmCAKkvkv2gIYFDn7zdOsTh8nZ1aowRUWAGiAnQjnRr+CBHQKmeHXhSChQW1BOSpRMguq+CXwCPn921XZjdhfqjLLu/W7ApJTL5p/5fV6DyKc7bA3GnOD2+bU7G1BipU5tFkY7oDWA/I9PGqrY1Zw
 pQPj9jM+
 kskmH/+UoIZtrhyl++VdvyIBc3QniqQrj4gTd8GX5Z2BdTciYL0IKAn20KjbPzxLAro/pkd7SE5qhCa5RvWXNTFx2CpKUhLMLWfdErzmy7ynghQj1kHbvnc9jbJDUvt8X5p8gG1SOEySuQkgb0MVPS5oJkKdvNGCntRDQpGV61h8gbKyREoBF9Wf0jq6W91vWS4RhVClkGvIhyQAei0epPB1vnQ0pHamYBfswtmSi4XVxuzq08falQcFEN3HZzrqnTAEccbjKoI6nCp6B99mc8mCjffcS4r3PSkYMI453DVzEa5OzEtEE3Re8F/yCGocyY3ToUxgS51kTimLiDm1Vw4ly2ZkVKegz1XWdvtxqGGe3/G/qdDQJpGg/Vkf4QJ5yeXATFmpyyxpsSqzcB4HeFCevlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:12PM -0500, Tal Zussman wrote:
> There are no callers left. Point the comment on shmem_read_folio_gfp()
> at mapping_read_folio_gfp() instead.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h |  2 --
>  mm/filemap.c            | 23 -----------------------
>  mm/shmem.c              |  4 ++--
>  3 files changed, 2 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index a92329805acd..305c99bad689 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -962,8 +962,6 @@ struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
>  		gfp_t flags);
>  struct page *read_cache_page(struct address_space *, pgoff_t index,
>  		filler_t *filler, struct file *file);
> -extern struct page * read_cache_page_gfp(struct address_space *mapping,
> -				pgoff_t index, gfp_t gfp_mask);
>
>  static inline struct page *read_mapping_page(struct address_space *mapping,
>  				pgoff_t index, struct file *file)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1df776907140..2b724d9be94b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4258,29 +4258,6 @@ struct page *read_cache_page(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL(read_cache_page);
>
> -/**
> - * read_cache_page_gfp - read into page cache, using specified page allocation flags.
> - * @mapping:	the page's address_space
> - * @index:	the page index
> - * @gfp:	the page allocator flags to use if allocating
> - *
> - * This is the same as "read_mapping_page(mapping, index, NULL)", but with
> - * any new page allocations done using the specified allocation flags.
> - *
> - * If the page does not get brought uptodate, return -EIO.
> - *
> - * The function expects mapping->invalidate_lock to be already held.
> - *
> - * Return: up to date page on success, ERR_PTR() on failure.
> - */
> -struct page *read_cache_page_gfp(struct address_space *mapping,
> -				pgoff_t index,
> -				gfp_t gfp)

Also eliminates this very weird line-wrapping... :)

> -{
> -	return do_read_cache_page(mapping, index, NULL, NULL, gfp);
> -}
> -EXPORT_SYMBOL(read_cache_page_gfp);
> -
>  /*
>   * Warn about a page cache invalidation failure during a direct I/O write.
>   */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index de838dbb4df8..16b1cc3d8ac5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -6190,9 +6190,9 @@ int shmem_zero_setup_desc(struct vm_area_desc *desc)
>   * @index:	the folio index
>   * @gfp:	the page allocator flags to use if allocating
>   *
> - * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
> + * This behaves as a tmpfs "mapping_read_folio_gfp(mapping, index, gfp)",
>   * with any new page allocations done using the specified allocation flags.
> - * But read_cache_page_gfp() uses the ->read_folio() method: which does not
> + * But mapping_read_folio_gfp() uses the ->read_folio() method: which does not
>   * suit tmpfs, since it may have pages in swapcache, and needs to find those
>   * for itself; although drivers/gpu/drm i915 and ttm rely upon this support.
>   *
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

