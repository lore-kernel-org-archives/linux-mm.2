Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 143A5C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D96B6B0098; Wed,  9 Sep 2026 06:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1638B6B009F; Wed,  9 Sep 2026 06:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B876B00A0; Wed,  9 Sep 2026 06:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C55EB6B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:12:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11A97160171
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:12:22 +0000 (UTC)
X-FDA: 85193808924.04.D277DE3
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB86480003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:12:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jfGA6Ns4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948740;
	b=5XQhqiDD/9n58HqFuzQR7KUElbw72895+daqvEo2o2TBEE3xKCEPSJdGDp6rBQkP4tTtq9
	27bUZFvJ/FzBzrdfX+BszThpJ3P7wv/GeJhFDT9EwhkzwiNAHFEAxTMLyMMjgdlZebrOz+
	gSdvmDAHDZEFb5243w7ESkqZv2reI90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jfGA6Ns4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKexNK0CR0cTtqh/JRly0pwf58bWyG2h3e8xfqfXvMU=;
	b=BXF7rojzeBNjPQVZSeG97W2BleXMhBY3e/nvURyYNC5ob3NmMmvInZaPJe4gdAfm0MGaUM
	4jbQGbtVwANJlGn3qjY1gxAA0EEHjMeOYXYx3VWEpzQFHjTf11ctGcmL2femQ51pefBPSP
	Zlb2oVcMLnQw0W1HYlmkD7jNDmbzYlI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SUb2T8Szd5lQADcRkFmfOpjvj3cL/MOp9zqZDunQQQc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788948736; v=1; x=1789553536;
 b=jfGA6Ns4fWme+TvRv+Umhz2FneXp8Ee5AdFcBHRZr7/ku1cH+sSF5ySdy7eDuF1NBHhUPOzI
 CTLbZzGH/Vn/TWod8QE9fw9/u2KEzd+TNjZnKmKTtlOLLOM3rK3y10cuLz5jRRwxGmDSCsp7juG
 Nt5Ds7jCleQLtcvcFhg5jcL0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 82308e7dde90318c;
	Wed, 09 Sep 2026 10:12:15 +0000
X-Mizu-Trace-ID: 82308e7dde90318c
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
Subject: Re: [RFC PATCH 1/5] mm: let folio_mkclean() report which pages had dirty PTEs
Date: Wed,  9 Sep 2026 03:12:10 -0700
Message-ID: <20260909101212.894871-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903182943.662461-2-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB86480003
X-Stat-Signature: s8zjn9b1axuko7p1sjn8tbzoip31px4n
X-HE-Tag: 1788948739-566298
X-HE-Meta: U2FsdGVkX18jeVL1BECJGnDPSAcb2kLVJ9iql9BttALrNykMFnZ4nB9d9F3bd8ySZuFm14uH8thLJ08rTC197j2Kr76MFFKpBd6fi49c2dnQdGPX0Tj21yyfLXRzpxLN3rUZP+q596d1L0mLpV+v/X0TSRXfFh666C7VfLLCBHJ++FJoG3zLPFqBYEaDdQVb9CMQyrFKxPYOit5MDhDUKY7yeL34wQ/qI3hTlhpJvmOAm4Ul+MszhPdVz6ejCf/2r40xpLG/nwk96EbPcPnB3B1fLccyQGYGSc2VuL2HbRzZFzA5kvXTT7JbMXfzvamm62ouFn5mrBE+FU9N6mq/wCOPbP+1EaB67tET7C2cMsuhD87IyzUSvjPIQsl6ZLKVK4XmEh+2k/yPoZNemZgGLqoJqdAAJvd9j5uPVFWPMByyEpxUZigHdVx8PUNaZ73PxGOvBbSQ8vvt8s0uU/S75PyOSTVkuFr+LD2sitb43Q1EzNf8K9r6J605vOqLvhw6T3WiZdtpbJ8dxFCj8Zf+6N6gDPRbR5+qZC91ZEwE5voznMHcx+dDvvmUIYNmStLxEnBQh7kYZBiTa0LOMR5NjuzYnO5ufBgby42LRY3lFyAmYlIo/LmKq4HpeLkCym1z2JeirlhFUublFfn4Jc9dboqs7uZo6WhKvFpAdy2ZfvfeMrYg6J39xzXAvO5RV3/Xsg6rNJ1QAwwadFviNLT4BYxq+eMJkuqAu9tjUJP8AvSb8vz0pbkLg818tawa7BiEpWbSw0L7UFaiFzm1c5Aux9B00LPMEngSt9x3zTOUCLW9XQ7bweGt4xYjkJM4q07IOf/xd4/6LAhbnlaBkd5QqIBcU0nsWzPEZL94Cv7/nwlH8rHgaVIRGRjykiVgJvyEPGhWYpNeCNe2h9IgwQZCZykBqKSHCzMxKM/uFcmBe4nE9/G6mKyawfAATrvAIC6FBbOgaffWtLGpj+crFda
 Xs8tgjMP
 z0kEcgIScWK7WQ0PX/fZE1P99vFWxY6/Pu0swR4VkGLT7LDCEN7V9CPiS7F3M3sG0ASnDLXpzBarzfkDXF2P+vdyLAKYkTk5rAdB6dr67YoGpZL64hbYZA8mhhbHS/knYOHG1hRPDGNxnC7cAspQ7UhOz8LZoFkdBrgNbKNHjFravynGz1NvooPulUnvzMCfm3ofxZH2b9Lev6vBabDme8cvRp2+BqUw6wEeAmokoAtT0gwUrNREZQwhHMHPuAHl4ExuktSR+W0pZ/snn/z1MJOVWnNXrW+2by/5dfhXJQAuEIqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 19:29:39 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> folio_mkclean() walks every mapping of a folio and clears the dirty and
> write bits of each page table entry. It has the per-entry dirty bit in
> hand while doing that, but only counts how many entries it cleaned.
> 
> For a large folio those bits are the only record of which parts of the
> folio were written through a mapping. Everything downstream has to
> assume the whole folio changed because that information is dropped here.
> 
> Add folio_mkclean_dirtymap(), which takes a bitmap and sets a bit for every
> page of the folio whose entry was dirty. folio_mkclean() becomes a
> wrapper that passes no bitmap, so there is no change in behaviour yet.
> 
> A PMD entry has one dirty bit for the whole folio, so a PMD-mapped folio
> reports all of its pages as dirty. That is the best that can be done:
> the hardware does not track anything finer for a PMD.
> 
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/rmap.h |  7 ++++++
>  mm/rmap.c            | 56 +++++++++++++++++++++++++++++++++++---------
>  2 files changed, 52 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f00..6fc0a6020252 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -927,6 +927,7 @@ unsigned long page_address_in_vma(const struct folio *folio,
>   * returns the number of cleaned PTEs.
>   */
>  int folio_mkclean(struct folio *);
> +int folio_mkclean_dirtymap(struct folio *folio, unsigned long *dirty_map);
>  
>  int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
>  		unsigned long pfn, unsigned long nr_pages);
> @@ -990,6 +991,12 @@ static inline int folio_mkclean(struct folio *folio)
>  {
>  	return 0;
>  }
> +
> +static inline int folio_mkclean_dirtymap(struct folio *folio,
> +					 unsigned long *dirty_map)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_MMU */
>  
>  #endif	/* _LINUX_RMAP_H */
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1f72d279ba68..aaf45ac79fa8 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1100,12 +1100,18 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	return rwc.contended ? -1 : pra.referenced;
>  }
>  
> -static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
> +struct mkclean_state {
> +	unsigned long *dirty_map;
> +	int cleaned;
> +};
> +
> +static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
> +				unsigned long *dirty_map)
>  {
> -	int cleaned = 0;
>  	struct vm_area_struct *vma = pvmw->vma;
> -	struct mmu_notifier_range range;
>  	unsigned long address = pvmw->address;
> +	struct mmu_notifier_range range;
> +	int cleaned = 0;
>  
>  	/*
>  	 * We have to assume the worse case ie pmd for invalidation. Note that
> @@ -1134,6 +1140,15 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  			if (!pte_dirty(entry) && !pte_write(entry))
>  				continue;
>  
> +			if (dirty_map && pte_dirty(entry)) {
> +				pgoff_t idx = linear_page_index(vma, address) -
> +					      pvmw->pgoff;
> +
> +				/* The walk only visits pages of this folio */
> +				VM_WARN_ON_ONCE(idx >= pvmw->nr_pages);
> +				__set_bit(idx, dirty_map);
> +			}
> +

The patch reads the PTE first and then records pte_dirty(entry) in the bitmap
before invalidating the PTE.

Holding the page-table lock prevents another kernel thread from changing
the PTE, but it does not prevent the CPU from setting the hardware dirty
bit.

This sequence is possible:

  Writeback CPU                  Application CPU
  -------------                  ---------------
  ptep_get(): writable, clean
                                 store through the PTE
                                 hardware sets dirty
  ptep_clear_flush(): returns dirty PTE
  pte_mkclean()
  reinstall clean, read-only PTE

The bitmap was populated from the first, clean snapshot. The dirty state
returned by ptep_clear_flush() is discarded.

With range-aware iomap writeback:

- The folio can still be selected for writeback.
- The affected filesystem block is absent from the iomap dirty bitmap.
- Writeback clears the folio dirty state without writing that block.
- Later eviction can discard the modified data.

The old whole-folio behavior did not need to know which PTE became
dirty, so this timing window was harmless. Sub-folio tracking makes the
final dirty state correctness-critical.

The PMD path has the identical race between pmdp_get() and
pmdp_invalidate().


>  			flush_cache_page(vma, address, pte_pfn(entry));
>  			entry = ptep_clear_flush(vma, address, pte);
>  			entry = pte_wrprotect(entry);
> @@ -1155,6 +1170,9 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
>  			if (!pmd_dirty(entry) && !pmd_write(entry))
>  				continue;
>  
> +			if (dirty_map && pmd_dirty(entry))
> +				bitmap_set(dirty_map, 0, pvmw->nr_pages);
> +
>  			flush_cache_range(vma, address,
>  					  address + HPAGE_PMD_SIZE);
>  			entry = pmdp_invalidate(vma, address, pmd);
> @@ -1181,9 +1199,9 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
>  			     unsigned long address, void *arg)
>  {
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
> -	int *cleaned = arg;
> +	struct mkclean_state *state = arg;
>  
> -	*cleaned += page_vma_mkclean_one(&pvmw);
> +	state->cleaned += page_vma_mkclean_one(&pvmw, state->dirty_map);
>  
>  	return true;
>  }
> @@ -1196,12 +1214,23 @@ static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
>  	return true;
>  }
>  
> -int folio_mkclean(struct folio *folio)
> +/**
> + * folio_mkclean_dirtymap - Write-protect a folio and report what was dirty.
> + * @folio: The folio to clean.
> + * @dirty_map: Bitmap of at least folio_nr_pages(@folio) bits, or NULL.
> + *
> + * Write-protects and cleans every mapping of @folio.  With @dirty_map, sets a
> + * bit for each page whose entry was dirty; a PMD-mapped folio has one dirty
> + * bit for all of it, so every page is reported.
> + *
> + * Return: the number of page table entries cleaned.
> + */
> +int folio_mkclean_dirtymap(struct folio *folio, unsigned long *dirty_map)
>  {
> -	int cleaned = 0;
> +	struct mkclean_state state = { .dirty_map = dirty_map };
>  	struct address_space *mapping;
>  	struct rmap_walk_control rwc = {
> -		.arg = (void *)&cleaned,
> +		.arg = (void *)&state,
>  		.rmap_one = page_mkclean_one,
>  		.invalid_vma = invalid_mkclean_vma,
>  	};
> @@ -1217,7 +1246,12 @@ int folio_mkclean(struct folio *folio)
>  
>  	rmap_walk(folio, &rwc);
>  
> -	return cleaned;
> +	return state.cleaned;
> +}
> +
> +int folio_mkclean(struct folio *folio)
> +{
> +	return folio_mkclean_dirtymap(folio, NULL);
>  }
>  EXPORT_SYMBOL_GPL(folio_mkclean);
>  
> @@ -1241,7 +1275,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
>  		.flags		= PVMW_SYNC,
>  	};
>  
> -	state->cleaned += page_vma_mkclean_one(&pvmw);
> +	state->cleaned += page_vma_mkclean_one(&pvmw, NULL);
>  
>  	return true;
>  }
> @@ -1324,7 +1358,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
>  	pvmw.address = vma_address(vma, pgoff, nr_pages);
>  	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
>  
> -	return page_vma_mkclean_one(&pvmw);
> +	return page_vma_mkclean_one(&pvmw, NULL);
>  }
>  
>  static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
> -- 
> 2.54.0
> 
> 

