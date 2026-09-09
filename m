Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26C8C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5DE6B008A; Wed,  9 Sep 2026 06:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D968A6B008C; Wed,  9 Sep 2026 06:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC2C6B0092; Wed,  9 Sep 2026 06:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA0576B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:52:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03AEF12017B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:52:16 +0000 (UTC)
X-FDA: 85193909514.21.6F09882
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5D42F1C0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:52:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnvljVq0;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788951135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37DfUJIr4F+/OARye+gkW7xxB93nw/YNoB4aohgEgcQ=;
	b=3m80Z+XJfp22HxK7HWN59/5CQTjBVhVqBDL9rxriLgDMlvZ/rEA0LqjGLYDS2VwxxjsBJf
	9bHh2bYZq1/VecEePgwesRgxZ9LxyAbSsgXqs93gL2mrYdetABl98DcUn7pZvySjdKWbqU
	dxN/LDFGT/jdswaNo6Ljq3tTwlZoE8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788951135;
	b=GtADzJ9p6Oy7qLZe6GhJK9yr465jXn9R7RHHv75JdICLXJb+lM09ShqCpvzEHxoICZ2PIp
	tJR23jlwFuvxRZ4tWzSvit5MH2YOO8B2A5C2dLgz4zajo/6oWsMsJZEVk4CF4f6E7XE5wL
	KRiukt7TbR95hAnK+qaPUioZgadYoZI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnvljVq0;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nLf/lRHoFum5m+0lJCGEXaO0612ccjY4r0VU9eyNeEs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788951132; v=1; x=1789555932;
 b=cnvljVq0OO91PYbdYyvIns7BqFCjXF4akHP4++eztNzzXt6kYoLT9z0A2Hf8NDwRyh+QIByt
 kNaom/wZbi3JgLq0ruOd1SK33i01JOYZtGveZSETlPOedeBqHS4ej2fp+kaNrHFdjBIL4qX4/WO
 zIOYt8utbzG3LqBbEQLTX/S4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5d49b818eb55d532;
	Wed, 09 Sep 2026 10:52:01 +0000
X-Mizu-Trace-ID: 5d49b818eb55d532
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [RFC PATCH 2/5] mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
Date: Wed,  9 Sep 2026 03:51:56 -0700
Message-ID: <20260909105157.1627242-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903182943.662461-3-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ya4ou6wsy555jt1yo4srzh99i8d9zo99
X-Rspamd-Queue-Id: 5D42F1C0006
X-HE-Tag: 1788951133-687941
X-HE-Meta: U2FsdGVkX1/gsAB1hhJEtxWEbrrGcxr81ObDWb+fDiPq9XX1WRTXNTXu/fSYumxjhnIVe2IC/yBTED9pNXO24wAeMHmp3MDF8gCN/Ipizv1yyZWLbg/mPVOgA6m+l0oZY4Xa+Br4+4mYyLGIFCrsPaXbI/x75yG2n1hl06l4YQu2a3uuIv/bfM+MHYp5+lBxooysaXRfaFV5CMaFE8+2m5vvKttfr8CaDbd3INKIoTaBchGcEuJio5ToWfAkYRXrI6YjdobiKWipWMsSkLllwAw5OL+Vs9B9xf3p6V7BwFd/hDTqeCBZiKr73l6Nz960odV5G+Dn6kMVxv6BPrsYA1hrsnas9pq4SlmtDCxEmqNYcUVB7rFBDYP9ychEKRGAj9Io3EiuTDfeAbP/BzlilDuRwD/BVaD1e/F8NFRLnxMvSnICnIo86mLPGIE8NkAShLQ1FTzHnJ0dKIlr2fLQm1uSAi2rCi5utvGogxF+HuhJQv4zZGHOaQREG8lBDYkEKwZhFKoZpBLLG/HtAJLLdKNlegHmIy5M7RxSIfV5WrK7tk+56B4sTdRvQy8o3yyOEQqkmUXx1TmEauKOdpZGyfTYPorQvRm1X9rNa1q1pt5frrx+ThwWoyOiSk0kXmUeVB6so4QBPMVysps0hew7PETYmyqaR2I4+6uejSWk3C/j/lr6aP0x8//KpcrxGgePMOxvj7Kf8Pxh5tZpttt4mc+V+02l7SIG+f/uGZ+nVtlWDZe8uwL2UEz+f+Zn03O1Twb9K/H8uJ0HoDNLQZbVMMgBI4OYg0d8PxW6sfoHT5SN79Mx3kbsh5RLyWOlEI5jMtgsWYPX/JBiiVKPsRp8r6GMqxhKHX1m+YHX7+0iXpeVMVImJLFAY2ijq5IVsvHVqvlIm9nhJ2YnlqamYeyA3MGJ+y7VQAl8lMgcE+c8aK4Ys6cDqgfxOZFYlpwDPvnkbsxt5XKty6XhxJQrKNY
 vSjq5Cme
 saHzwqp+EO6mVd0y0rE3mewPTpfjD5lnRJFBNxp3+YLdGPHPzE9gbheOzjDweOSZfvx8p7HD+BfunMmF/vPG3iVGLl5Hvk4kr6vcx8vJ4Ge2RLoMGwAsqjJZEOysEKYRd7WEngQ9f2ta6XWs1C0afjbNN1hgp8gNVzJIwBZrnJVnAkvOapqea+x/BiAYFG2AdDbHT1/W0bjCQmfxtxM+X+jFILnQJTFVDV96DiJ98Is805tRVA+/felfiYMxR/vUXtqd1twuAXcFXkK01U39HlTmMfA70kf197/N7qfY+GSNM9Xk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 19:29:40 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Every way of dirtying part of a folio through a mapping ends up at
> folio_mark_dirty(), which has no way to say which part changed, so
> a_ops->dirty_folio() dirties all of it. A filesystem that tracks dirty
> state per block then writes back the whole folio for a single stored
> byte.
> 
> Add a_ops->dirty_folio_range() and folio_mark_dirty_range() to pass the
> range on. The new operation can express everything a_ops->dirty_folio()
> can, so folio_mark_dirty() goes through it with a range covering the
> folio and a filesystem needs only one of the two. Filesystems without it
> dirty the whole folio.
> 
> Use it in folio_clear_dirty_for_io(), where the page table dirty bits
> were being turned into a whole-folio dirty. It now collects them with
> folio_mkclean_dirtymap() and hands the filesystem the runs that were
> dirty. A folio that is not already dirty still dirties whole, because
> the clean to dirty transition needs the accounting in folio_mark_dirty().
> 
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/fs.h  |  3 ++
>  include/linux/mm.h  |  1 +
>  mm/page-writeback.c | 87 +++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 85 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 072d8cd09a0b..1d98b6c0b880 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -406,6 +406,9 @@ struct address_space_operations {
>  
>  	/* Mark a folio dirty.  Return true if this dirtied it */
>  	bool (*dirty_folio)(struct address_space *, struct folio *);
> +	/* Mark [off, off + len) of a folio dirty */
> +	bool (*dirty_folio_range)(struct address_space *mapping,
> +				  struct folio *folio, size_t off, size_t len);
>  
>  	void (*readahead)(struct readahead_control *);
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 87feaa5a2b78..7628262c17e1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3337,6 +3337,7 @@ struct kvec;
>  struct page *get_dump_page(unsigned long addr, int *locked);
>  
>  bool folio_mark_dirty(struct folio *folio);
> +bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len);
>  bool folio_mark_dirty_lock(struct folio *folio);
>  bool set_page_dirty(struct page *page);
>  int set_page_dirty_lock(struct page *page);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 6c9c7ba89b8a..39b54c25a9fa 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2751,6 +2751,21 @@ bool folio_redirty_for_writepage(struct writeback_control *wbc,
>  }
>  EXPORT_SYMBOL(folio_redirty_for_writepage);
>  
> +/*
> + * Hand a dirtied range of @folio to the filesystem.  ->dirty_folio_range() can
> + * express everything ->dirty_folio() can, so a filesystem that implements it
> + * does not need both, and a whole-folio dirty comes through here as a range
> + * covering the folio.
> + */
> +static bool mapping_dirty_range(struct address_space *mapping,
> +				struct folio *folio, size_t off, size_t len)
> +{
> +	if (!mapping->a_ops->dirty_folio_range)
> +		return mapping->a_ops->dirty_folio(mapping, folio);
> +
> +	return mapping->a_ops->dirty_folio_range(mapping, folio, off, len);
> +}
> +
>  /**
>   * folio_mark_dirty - Mark a folio as being modified.
>   * @folio: The folio.
> @@ -2782,13 +2797,39 @@ bool folio_mark_dirty(struct folio *folio)
>  		 */
>  		if (folio_test_reclaim(folio))
>  			folio_clear_reclaim(folio);
> -		return mapping->a_ops->dirty_folio(mapping, folio);
> +		return mapping_dirty_range(mapping, folio, 0,
> +					   folio_size(folio));
>  	}
>  
>  	return noop_dirty_folio(mapping, folio);
>  }
>  EXPORT_SYMBOL(folio_mark_dirty);
>  
> +/**
> + * folio_mark_dirty_range - Mark part of a folio as being modified.
> + * @folio: The folio.
> + * @off: Offset of the modified range within the folio.
> + * @len: Length of the modified range.
> + *
> + * Like folio_mark_dirty(), but tells a filesystem that tracks dirty state per
> + * block that only [@off, @off + @len) changed, so writeback can skip the rest
> + * of the folio.  Filesystems without that tracking dirty the whole folio.
> + *
> + * Return: True if the folio was newly dirtied, false if it was already dirty.
> + */
> +bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len)
> +{
> +	struct address_space *mapping = folio_mapping(folio);
> +
> +	if (likely(mapping)) {
> +		if (folio_test_reclaim(folio))
> +			folio_clear_reclaim(folio);
> +		return mapping_dirty_range(mapping, folio, off, len);
> +	}
> +
> +	return noop_dirty_folio(mapping, folio);
> +}
> +
>  /*
>   * folio_mark_dirty() is racy if the caller has no reference against
>   * folio->mapping->host, and if the folio is unlocked.  This is because another
> @@ -2844,6 +2885,41 @@ void __folio_cancel_dirty(struct folio *folio)
>  }
>  EXPORT_SYMBOL(__folio_cancel_dirty);
>  
> +/*
> + * Write-protect every mapping of @folio and hand the filesystem the parts that
> + * were dirty in a page table.
> + *
> + * Without ->dirty_folio_range() there is nowhere to put per-block state, so
> + * any PTE dirty bit dirties the whole folio.  Same when the folio is not
> + * already dirty, because then the dirty transition needs the full accounting
> + * in folio_mark_dirty(), and for a folio too large for the bitmap, which the
> + * page cache does not make.
> + */
> +static void folio_mkclean_for_io(struct folio *folio,
> +				 struct address_space *mapping)
> +{
> +	DECLARE_BITMAP(map, 1UL << MAX_PAGECACHE_ORDER);
> +	unsigned int nr = folio_nr_pages(folio);
> +	unsigned int start, end;
> +
> +	if (!mapping->a_ops->dirty_folio_range || !folio_test_dirty(folio) ||
> +	    WARN_ON_ONCE(nr > (1UL << MAX_PAGECACHE_ORDER))) {
> +		if (folio_mkclean(folio))
> +			folio_mark_dirty(folio);
> +		return;
> +	}
> +
> +	bitmap_zero(map, nr);
> +	if (!folio_mkclean_dirtymap(folio, map))
> +		return;
> +
> +	for_each_set_bitrange(start, end, map, nr) {
> +		mapping_dirty_range(mapping, folio,
> +				    (size_t)start << PAGE_SHIFT,
> +				    (size_t)(end - start) << PAGE_SHIFT);

folio_mark_dirty() clears PG_reclaim, but mapping_dirty_range() doesnt.
Do you need to clear PG_reclaim here?

> +	}
> +}
> +
>  /*
>   * Clear a folio's dirty flag, while caring for dirty memory accounting.
>   * Returns true if the folio was previously dirty.
> @@ -2875,9 +2951,9 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		 *
>  		 * We use this sequence to make sure that
>  		 *  (a) we account for dirty stats properly
> -		 *  (b) we tell the low-level filesystem to
> -		 *      mark the whole folio dirty if it was
> -		 *      dirty in a pagetable. Only to then
> +		 *  (b) we tell the low-level filesystem which
> +		 *      parts of the folio were dirty in a
> +		 *      pagetable. Only to then
>  		 *  (c) clean the folio again and return 1 to
>  		 *      cause the writeback.
>  		 *
> @@ -2895,8 +2971,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		 * as a serialization point for all the different
>  		 * threads doing their things.
>  		 */
> -		if (folio_mkclean(folio))
> -			folio_mark_dirty(folio);
> +		folio_mkclean_for_io(folio, mapping);
>  		/*
>  		 * We carefully synchronise fault handlers against
>  		 * installing a dirty pte and marking the folio dirty
> -- 
> 2.54.0
> 
> 

