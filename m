Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DE5606A889
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=OtMqYC2z;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1I8zO6gV;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=OtMqYC2z;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1I8zO6gV
Received: by kanga.kvack.org (Postfix)
	id 00F106B05B9; Thu, 12 Nov 2026 08:09:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F280E6B05C0; Thu, 12 Nov 2026 08:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17516B05C1; Thu, 12 Nov 2026 08:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC4E66B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:09:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ED45160552
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:09:34 +0000 (UTC)
X-FDA: 85426498668.29.A2138E3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17550C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:09:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtMqYC2z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1I8zO6gV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtMqYC2z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1I8zO6gV;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KYHiNGAlN0yYggrYF+rSLXqgcLA2MtdXQ0xmmdU52E=;
	b=B3+jJ8eSAApDzmMzgy79t8g523GN4IBiEoirTk/Ecm5AIkro/CgVFeB8Ankwyx1CYEaDfG
	r0Z6Dy72Wm6bJ/8ExiyLIlDhp1FV2WHAUmvNX7ctm24KZznJB6K5gI8R+VrKL3r6CtjpGs
	d66ZZh9/kQ1dAdlhyKVwdTz4mYjBgws=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtMqYC2z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1I8zO6gV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtMqYC2z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1I8zO6gV;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488972;
	b=yhQBLri58+i+H9X0GhPIiATZZoRUS2o2aBBUKT8f9FWfOCnT4RZBFd6r1GR9JQe0r7axjS
	Ml7TNwSfySwc6k+MB1B6fbg4ztlYw6ER0viiwMjkoggjxiFqF9ljUoAAr6kbPrr0uS+8tZ
	HSzK1BbFL11SkhruU4GILlFw6enhKr4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C62521BD9;
	Thu, 12 Nov 2026 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794488970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KYHiNGAlN0yYggrYF+rSLXqgcLA2MtdXQ0xmmdU52E=;
	b=OtMqYC2z8lAR+sTWFvtR9GHIzJFEx8jpOkZifHd79hYM1IMd9wr+howbxV3GfovYDh8yB+
	ds/3oLgJO88PMImS7YMGz2aXbONZjla3mtJk7xdpoUfTxUAToKqIMRYeRc6ferQktWsPby
	wssXVgCeGOtocwbmJ2BSerFI10a0ghU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794488970;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KYHiNGAlN0yYggrYF+rSLXqgcLA2MtdXQ0xmmdU52E=;
	b=1I8zO6gV9peWwgHk/psh5fLhYvjdUD0Ciql6/HEgvNh6hOswbVrFNhcn8A757xYHzDsJJs
	bqlMCbZq3mp3MwCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794488970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KYHiNGAlN0yYggrYF+rSLXqgcLA2MtdXQ0xmmdU52E=;
	b=OtMqYC2z8lAR+sTWFvtR9GHIzJFEx8jpOkZifHd79hYM1IMd9wr+howbxV3GfovYDh8yB+
	ds/3oLgJO88PMImS7YMGz2aXbONZjla3mtJk7xdpoUfTxUAToKqIMRYeRc6ferQktWsPby
	wssXVgCeGOtocwbmJ2BSerFI10a0ghU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794488970;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KYHiNGAlN0yYggrYF+rSLXqgcLA2MtdXQ0xmmdU52E=;
	b=1I8zO6gV9peWwgHk/psh5fLhYvjdUD0Ciql6/HEgvNh6hOswbVrFNhcn8A757xYHzDsJJs
	bqlMCbZq3mp3MwCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABF15134A0;
	Thu, 12 Nov 2026 13:09:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4SpmHoa69WpFbgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 13:09:26 +0000
Date: Thu, 12 Nov 2026 13:09:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/9] mm: limit pagecache folio refcount when splicing
 into pipes
Message-ID: <avW3v-oLxcHXXNQD@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-2-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-2-318625d63a98@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Stat-Signature: o48q66jiduxqutzf47srwpasedimq3cf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 17550C0003
X-HE-Tag: 1794488971-63705
X-HE-Meta: U2FsdGVkX18qaG9uqTYArDzZS6yHpQGpv4y48sTWImznY4q9+WH6DMW1O9VsC3NKGQNV96u8zbJmxyL84RO5eiqo+V0NYrSdsG83eT1sYYWQhEvot19oSfj6vF9+m72tmzlS5XHkqt9Z4qJoktEJ4ytXS3Owzr2dWU2Zhp3qK1XyD6hfY6PsVCwtJisxkGH/pBDFHOv80ZBQnJdcxEM6NZIXGjI31dVgLdenNrQLDcZFTa+YZfnRiJ0kdKswiOySRmKk5Kgb9moBR7bPQCySu1fGPt7wmwMd7/mXlnGrQ0ytGQLowIHVZhHbcXOUnNmJTGtAPZuURccAE03JaBYWlPyNWwp9UrqXO1bp8+WyvHtbUSC30yNddRcNnuHYHYWI0TRlD/GtOPfQeMvIfcSIDNzLJKpvCZdQuKVx87flex222YhvvAYdLcqxSbmQ5qcWmCt8ZHcm1qRCb76QZs5/fWS99qZzt5VQ+bxMDkf4elHzSjCVcfJX1DZ0MVFUXRW00R4od4fn5VM4pnOgSmPDLhVT4fH+94A/DlWBQCQH/vNyNr9FBva05bPGW8s/4wBNmF3qOlAgKafcdSCl3kDiKDdZCgbnh2cgJsaaGRis4g1ifxthrpPARyjFCGMfMdCPDgjS0hTwaPI2XsWdDKjUi1OUI3KvapOpHsaIG35jp0yzlpVYfey0vPkQj+9I3qXjg2fTfQWjNA2o41PiOHH4Stp8PQjxqiqW+pVZxpkNKuhwvNz2Yhu070R8GUCkBrPRdXoXeTEG9U944dt1wGALGIL+aGuR4QS0QQhaUBuP75ekTySZ8i/Yo/H+5tPuBOCloc/ckgGzMVGx9WdiQ4xh+JmKESfcxWGpY7N6AqSzreiCzWj3GZjyK8Gv6B2n1mQOAZOatkg6vfC6SBTFT5w6PniJfHFlrcT1drMfG85HBYDO8/HhZxIPEUTCNxVNP3WTE51VIYBzdKwy7n+ra3c
 VtNJiCs1
 RPGwCejcZyqIWBpy3fbsrxa9G51TKUv7Spe12XTnHOIuiFQs7mv0vWSzzgTBG4Z0JdMhZZD8taR9GebIP4WiGD7J34YvewOXP+XSfkaLAPS/S19M1qFhw/Qp+T9Q6yPWU+cvMNHN1i8IejgEvjyTAAWDj++nG8b5yIi6FeLGFRZkx3eAgoMAFx+WgvzAnFWgpJawND8OWfvN7PSmWP+af+GAZdsy6LG46Kj5xDCszX1YLEGaVdu4oV2PYlJaUdpobDqLWmbGwqfY5xvlcJFxQR1J5qbXxlFLd1J9p1EPbYfRUoHtDif13xnw+t4+5R3ymB7ai2XbtBvED9K6H0p3rnl8QSlMv5cO3xtMMBx16c/B5cv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:42PM +0100, David Hildenbrand (Arm) wrote:
> Similar to mapping pagecache folios into page tables, let's reject
> additional references when splicing folios into a pipe if the refcount
> is at its limit, similar to how we handle it during GUP.
> 
> This will prevent more cases of possible folio refcount overflows with
> large pagecache folios.
> 
> Introduce folio_get_checked() for checked reference acquisition when
> the caller already holds a reference. It warns and fails on a non-positive
> refcount and rejects additional references at the limit.
> 
> Use folio_get_checked() in splice_folio_into_pipe() and
> fuse_ref_folio(), returning -EFAULT on failure, like we already do for
> pipe-buffer duplication. Similarly, make try_get_page() use it instead.
> 
> Likely try_get_page() should be renamed (or removed) later, as it doesn't
> match the folio_try_get() semantics and is confusing.
> 
> If we hit the limit after splicing some data, return the number of bytes
> already spliced. Teach the callers to handle errors, and stop
> filemap_splice_read() if we only spliced part of a folio, so we don't
> skip ahead to the next folio.
> 
> The check in try_get_page() also covers pipe-buffer duplication by tee()
> and partial pipe-to-pipe splicing.
> 
> Note that we deliberately will not fall back to the slow path of copying
> the folio, particularly as the folio might have an invalid refcount. If
> it is ever really required, we can revisit.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/fuse/dev.c      |  4 +++-
>  include/linux/mm.h | 26 ++++++++++++++++++++++----
>  mm/filemap.c       | 26 ++++++++++++++++----------
>  mm/internal.h      |  4 ++--
>  mm/shmem.c         |  7 +++++--
>  5 files changed, 48 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 3641abb90d6bb..50f41bb287832 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1230,7 +1230,9 @@ static int fuse_ref_folio(struct fuse_copy_state *cs, struct folio *folio,
>  	if (cs->nr_segs >= cs->pipe->max_usage)
>  		return -EIO;
>  
> -	folio_get(folio);
> +	if (!folio_get_checked(folio))
> +		return -EFAULT;
> +
>  	err = unlock_request(cs->req);
>  	if (err) {
>  		folio_put(folio);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6c7c29a086bd1..33bc57342590c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2284,15 +2284,33 @@ static inline void get_page(struct page *page)
>  	folio_get(folio);
>  }
>  
> -static inline __must_check bool try_get_page(struct page *page)
> +/**
> + * folio_get_checked - Try to acquire a reference to a live folio.
> + * @folio: The folio.
> + *
> + * The caller must already hold a reference to @folio. Warn and fail on a
> + * non-positive refcount, and refuse additional references at the limit.
> + *
> + * Use folio_try_get() for speculative reference acquisition where the
> + * refcount can legitimately be zero.
> + *
> + * Return: True if the refcount was incremented, false otherwise.
> + */
> +static inline __must_check bool folio_get_checked(struct folio *folio)
>  {
> -	page = compound_head(page);
> -	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
> +	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
>  		return false;
> -	page_ref_inc(page);
> +	if (unlikely(folio_ref_count_over_limit(folio)))
> +		return false;

Ah nice, the helper I wanted :)

Nit: Having these two functions called back-to-back will result in two
separate loads on the refcount (folio_ref_count() distills into a READ_ONCE).

> +	folio_ref_inc(folio);
>  	return true;
>  }
>  
> +static inline __must_check bool try_get_page(struct page *page)
> +{
> +	return folio_get_checked(page_folio(page));
> +

God I hate this. I never realized try_get_page() isn't atomic, but
folio_try_get() is.

> +
>  /**
>   * folio_put - Decrement the reference count on a folio.
>   * @folio: The folio.
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 0f6d57432a7e5..e6e73e37f3ea4 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3047,10 +3047,11 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  EXPORT_SYMBOL(generic_file_read_iter);
>  
>  /*
> - * Splice subpages from a folio into a pipe.
> + * Splice subpages from a folio into a pipe. Return the number of bytes spliced,
> + * or -EFAULT if we cannot splice from the folio.

-EFAULT is a weird error code to return from splice, et al.

>   */
> -size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
> -			      struct folio *folio, loff_t fpos, size_t size)
> +ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
> +			       struct folio *folio, loff_t fpos, size_t size)
>  {
>  	struct page *page;
>  	size_t spliced = 0, offset = offset_in_folio(folio, fpos);
> @@ -3063,13 +3064,15 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
>  		struct pipe_buffer *buf = pipe_head_buf(pipe);
>  		size_t part = min_t(size_t, PAGE_SIZE - offset, size - spliced);
>  
> +		if (!folio_get_checked(folio))
> +			return spliced ? spliced : -EFAULT;
			return spliced ?: -EFAULT;

I don't know if there's much kernel code out there doing this, but I like
the trick :)

> +
>  		*buf = (struct pipe_buffer) {
>  			.ops	= &page_cache_pipe_buf_ops,
>  			.page	= page,
>  			.offset	= offset,
>  			.len	= part,
>  		};
> -		folio_get(folio);
>  		pipe->head++;
>  		page++;
>  		spliced += part;
> @@ -3094,9 +3097,10 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
>   * Return: On success, the number of bytes read will be returned and *@ppos
>   * will be updated if appropriate; 0 will be returned if there is no more data
>   * to be read; -EAGAIN will be returned if the pipe had no space, and some
> - * other negative error code will be returned on error.  A short read may occur
> - * if the pipe has insufficient space, we reach the end of the data or we hit a
> - * hole.
> + * other negative error code will be returned on error; -EFAULT will be returned
> + * if acquiring a folio reference fails and no data has been spliced.
> + * A short read may occur if the pipe has insufficient space, we reach the
> + * end of the data, hit a hole or hit a folio refcount limit.
>   */
>  ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  			    struct pipe_inode_info *pipe,
> @@ -3154,7 +3158,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  
>  		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>  			struct folio *folio = fbatch.folios[i];
> -			size_t n;
> +			ssize_t n;
>  
>  			if (folio_pos(folio) >= end_offset)
>  				goto out;
> @@ -3170,13 +3174,15 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  
>  			n = min_t(loff_t, len, isize - *ppos);
>  			n = splice_folio_into_pipe(pipe, folio, *ppos, n);
> -			if (!n)
> +			if (n <= 0) {
> +				error = n;
>  				goto out;
> +			}
>  			len -= n;
>  			total_spliced += n;
>  			*ppos += n;
>  			in->f_ra.prev_pos = *ppos;
> -			if (pipe_is_full(pipe))
> +			if (pipe_is_full(pipe) || *ppos < folio_next_pos(folio))

I'm confused. Why does this need to be done here?
 
-- 
Pedro

