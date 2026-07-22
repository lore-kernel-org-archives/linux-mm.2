Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD2FC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 10:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1A96B0088; Wed, 22 Jul 2026 06:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BAD6B008A; Wed, 22 Jul 2026 06:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343786B008C; Wed, 22 Jul 2026 06:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00B5B6B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:09:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 872E480447
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:17 +0000 (UTC)
X-FDA: 85015989954.27.8F3F7FA
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FD3B4000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vOr9kTcd;
	spf=pass (imf01.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9ZHitasBPd+89xCAjhNNqu5X1u0tuqYIkRhsSlZ8EI=;
	b=KUK2l3oxQw8XHaqcPuxjmGtMtdzCRYo6GjwCUamephcbgWLDdGfcmm7gqwpfO971jhjv0n
	iCQi4Q4+A2jbgXomMENQV2dVv0WVPSctzuPi7+EKZzRpdvsjhs0wgmBl0tcA1+5KcpfOjV
	2TPx5Mh2RHspdC9JF13ZM/g1HuREggQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vOr9kTcd;
	spf=pass (imf01.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714955;
	b=RZyrVnAFxqLPf1GZkhnqS0aarDSOWKvqDR9qYQ/Z1yveyx91PtfvJ60ahi9RvAA8WhkbEQ
	133Bpdcc/vC5EU5RRR1ByMji9K85BSzpnULWyqoX7ZE9rK4dZHT8wxYusAMwuwMyk0TC32
	cg0531LHy/0PlL3FA7dqXKs+fKFmbKo=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784714953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9ZHitasBPd+89xCAjhNNqu5X1u0tuqYIkRhsSlZ8EI=;
	b=vOr9kTcdoFznC35WRGHl+qTLrZ/hH/4I+xNFVBrqu1iQGFg23ugJxT5FqESameluilfhL2
	PLPEyCv2GNK9FUA4uJtwOfB9Nqgbo2tYG0wvsBr18KYvaFR6o86Ye4slk6ZhAAy0aT/1C/
	lOcAnK4zMEXNd4Ile8plQ+4u2JnicIU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] mm/khugepaged: separate out windy folio logic from
 collapse_file
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260720142913.846902-2-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-2-pfalcato@suse.de>
Date: Wed, 22 Jul 2026 04:10:38 -0600
Message-Id: <178471503895.281396.17089759639940764659.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FD3B4000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 3e9qy6f769fh7syx8uzuwdtx9ktuente
X-HE-Tag: 1784714954-970299
X-HE-Meta: U2FsdGVkX19YWREX0j3XE/evG+YaYea6TNZy2bj4CnqbANOyebQElktmT3L0Vznds/8mhFP+IKnBlTC3TOySDYH++SX4J/d05fTOGpMODTjvH4i7vkSX9cctm1WgwBwnqoLfeQlAw+YDba16uX0AXK2J8AjPab0BD3w0+yvFgKmP1EZo0R7b/5WWjlc+RBvNsjhD7EKNRYwgHCU3PnHa2u6cye4KbElGyXASFePJ+i8L7/jyTvMev+hyONxOljoJt0E/WKjrsSGLDYFbATRapYmFQJcXf8Uag7FEDLEW5eclyWgrJwJJgmWzD2Me9nC9/HX9HZVuHeVtEPu/iDIe6hEAn2q+TDPg6B3LS9xmyAVmRk57/LeczogEparMFoCQYBEIGT6CKeXIzJioc/7KxSTrDDPxkGoW7aEFNo3iQueZ3N7efqBYvi8EvIrVs/jPlBAOVvL1yPNmt+nQTzRzlrBhwjlAR4xsIe5kSrqmFGA21JnHFonIeTqMg7eWjI3nsQch/doTkTrRGUxWFeWQnlUFL782/y31qzwHOgoQl4gf8AasMCX/G/1EhyOYobRg5diE8n5vb+02nV+I7jkfhVoQUr+nVFTPXoyJ7Es8nA9mWP7UygvcnxSbm0kQJLS8PoFNCf0upCaWJMYHpbJe90JUY3tRJMuFZ3o8vckW2P0iFXGQSuEYxXPiPJGg4geqELcX0lEDFwd/N4KjkYRKql2AJ6MGFs513Xi0BsDCRceWtknX9IYnb9a4cqarLXTjYcxFMbF4T/pMM3X35/dmTsUIY90dI9p/2qdVZmTA5LU02ZeRLRzx4x9HjmvrrbLW+0c9kCzxN7I8s88GwbQoOtgvV/IHyLO3CvMtcDKOduEI21zCdOKbO4D6xOoeI1dcgxVdLwaWrEfU5yda/hsNvVz+63GKlZohw0tx5e0e8E3hj83A9Ff+Wjqarj89GYzaPiGeLhoZtbzhUmsGhly
 Ph4I9/3V
 VhszuCxhHSoBkQX9hFYZV/ARD/sBTFN575DY/mH5OPy7TWdBrWnnlSmPbucPlbfbJe82YC6zN9yZGQDArP/aTUiTSCh+4Nki3O4BEsHb076/LJ7zlUY2un7KGwBidxyR1zvfBrN8dYGIo5mTmCkxPlHY+QCNv+hLhZ45vuIsZtWGAZl1SxhEQ70fwcCX04eGk46D4DLoYz7x7Ivrlx+yAYDxEVcDp8JxWB8ZC+NhKj743j5ft0vzJgeifq3fUafNRdKqi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Separate out complex folio-related logic from the main collapse_file()
> loop, and introduce a new helper struct to help marshal arguments back
> and forth.

Hey! Since we both have a similar patch, I will note our differences in
approach here, and then comment inline for your changes.

Overall I think your series is a good v1, and tackles the most complex patch
in my version. There are a few things your patch does that mine does not, and
vise-versa.

You seperate all this code into a prepare + isolate stage, and call both from
the parent collapse_file() function.

What I did in mine was a "check" stage that handles both of these stages
together; however, it is also broken down further within the check stage into:

collapse_file_check_folio
 --> collapse_file_regular_check_folio (filemap is a better name)
 --> collapse_file_shmem_check_folio

the two child function help reduce nesting and make the code much more
readable. then the parent function handles all the common checks and
isolation.

I didnt use a helper function, but I think its the right approach.

overall I think your approach is better but should match the same flow as mine.

I dont think you need a separate isolate stage, as if you match my flow the
check/prepare keep the error handling much cleaner (see my patch for an
example of this).


> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>


>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 27e8f3077e80..d4de507ac001 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2218,6 +2218,92 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  	i_mmap_unlock_read(mapping);
>  }


>  
> +struct collapse_file_state {


> +	/* in-out parameter */


> +	struct folio *folio;
> +	/* in parameters */
> +	struct address_space *mapping;
> +	struct file *file;
> +	struct xa_state *xas;


> +	/* collapse end index */


> +	pgoff_t end;
> +	unsigned int is_shmem : 1;
> +};
> +
> +static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)


> +{
> +	struct address_space *mapping = state->mapping;
> +	enum scan_result result = SCAN_SUCCEED;
> +	const int is_shmem = state->is_shmem;
> +	struct folio *folio = state->folio;
> +
> +	if (is_shmem) {
> +		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
> +			xas_unlock_irq(state->xas);
> +			/* swap in or instantiate fallocated page */
> +			if (shmem_get_folio(mapping->host, index, 0,
> +					&folio, SGP_NOALLOC))
> +				result = SCAN_FAIL;
> +			/* drain lru cache to help folio_isolate_lru() */
> +			lru_add_drain();
> +			goto xa_unlocked;
> +		} else if (folio_trylock(folio)) {
> +			folio_get(folio);


> +		} else {
> +			result = SCAN_PAGE_LOCK;
> +			goto xa_locked;


> +		}
> +	} else {	/* !is_shmem */
> +		if (!folio || xa_is_value(folio)) {
> +			xas_unlock_irq(state->xas);
> +			page_cache_sync_readahead(mapping, &state->file->f_ra,
> +						  state->file, index,
> +						  state->end - index);
> +			/* drain lru cache to help folio_isolate_lru() */
> +			lru_add_drain();
> +			folio = filemap_lock_folio(mapping, index);
> +			if (IS_ERR(folio))
> +				result = SCAN_FAIL;
> +			goto xa_unlocked;
> +		} else if (folio_test_dirty(folio)) {
> +			/*
> +			 * This page is dirty because it hasn't
> +			 * been flushed since first write.
> +			 *
> +			 * Trigger async flush for read-only files and
> +			 * hope the writeback is done when khugepaged
> +			 * revisits this page. Writable files can have
> +			 * their folios dirty at any time; blindly
> +			 * flushing them would cause undesirable
> +			 * system-wide writeback.
> +			 *
> +			 * This is a one-off situation. We are not
> +			 * forcing writeback in loop.
> +			 */
> +			xas_unlock_irq(state->xas);
> +			if (!inode_is_open_for_write(mapping->host))
> +				filemap_flush(mapping);
> +			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +			goto xa_unlocked;
> +		} else if (folio_test_writeback(folio)) {
> +			xas_unlock_irq(state->xas);
> +			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +			goto xa_unlocked;
> +		} else if (folio_trylock(folio)) {
> +			folio_get(folio);
> +		} else {
> +			result = SCAN_PAGE_LOCK;
> +			goto xa_locked;
> +		}
> +	}
> +
> +xa_locked:
> +	xas_unlock_irq(state->xas);
> +xa_unlocked:
> +	state->folio = folio;
> +	return result;
> +}
> +
>  /**
>   * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
>   *
> @@ -2255,6 +2341,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	enum scan_result result = SCAN_SUCCEED;
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
> +	struct collapse_file_state state = {
> +		.is_shmem = is_shmem,
> +		.xas = &xas,
> +		.mapping = mapping,
> +		.file = file,
> +		.end = end,
> +	};
>  
>  	/*
>  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> @@ -2298,87 +2391,29 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		folio = xas_load(&xas);
>  
>  		VM_BUG_ON(index != xas.xa_index);
> -		if (is_shmem) {
> -			if (!folio) {
> -				/*
> -				 * Stop if extent has been truncated or
> -				 * hole-punched, and is now completely
> -				 * empty.
> -				 */
> -				if (index == start) {
> -					if (!xas_next_entry(&xas, end - 1)) {
> -						result = SCAN_TRUNCATED;
> -						goto xa_locked;
> -					}
> -				}
> -				nr_none++;
> -				index++;
> -				continue;
> -			}
> -
> -			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
> -				xas_unlock_irq(&xas);
> -				/* swap in or instantiate fallocated page */
> -				if (shmem_get_folio(mapping->host, index, 0,
> -						&folio, SGP_NOALLOC)) {
> -					result = SCAN_FAIL;
> -					goto xa_unlocked;
> -				}
> -				/* drain lru cache to help folio_isolate_lru() */
> -				lru_add_drain();
> -			} else if (folio_trylock(folio)) {
> -				folio_get(folio);
> -				xas_unlock_irq(&xas);
> -			} else {
> -				result = SCAN_PAGE_LOCK;
> -				goto xa_locked;
> -			}
> -		} else {	/* !is_shmem */
> -			if (!folio || xa_is_value(folio)) {
> -				xas_unlock_irq(&xas);
> -				page_cache_sync_readahead(mapping, &file->f_ra,
> -							  file, index,
> -							  end - index);
> -				/* drain lru cache to help folio_isolate_lru() */
> -				lru_add_drain();
> -				folio = filemap_lock_folio(mapping, index);
> -				if (IS_ERR(folio)) {
> -					result = SCAN_FAIL;
> -					goto xa_unlocked;
> +		if (is_shmem && !folio) {
> +			/*
> +			 * Stop if extent has been truncated or
> +			 * hole-punched, and is now completely
> +			 * empty.
> +			 */
> +			if (index == start) {
> +				if (!xas_next_entry(&xas, end - 1)) {
> +					result = SCAN_TRUNCATED;
> +					goto xa_locked;

You can hoist this stuff into the new check/prepare function if you pass the
nr_none through the helper. I think the ultimate goal here would be to
breakdown collapse_file() into a very simple stage based calling convention.

Leaving this one hunk that checks for nr_none in the parent would then seem
out of place.

ie) alloc() -> check/prepare() -> copy() -> validate_holes() -> finalize()

I also did a rollback() function to keep the collapse_file() clean. 

>  				}
> -			} else if (folio_test_dirty(folio)) {
> -				/*
> -				 * This page is dirty because it hasn't
> -				 * been flushed since first write.
> -				 *
> -				 * Trigger async flush for read-only files and
> -				 * hope the writeback is done when khugepaged
> -				 * revisits this page. Writable files can have
> -				 * their folios dirty at any time; blindly
> -				 * flushing them would cause undesirable
> -				 * system-wide writeback.
> -				 *
> -				 * This is a one-off situation. We are not
> -				 * forcing writeback in loop.
> -				 */
> -				xas_unlock_irq(&xas);
> -				if (!inode_is_open_for_write(mapping->host))
> -					filemap_flush(mapping);
> -				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> -				goto xa_unlocked;
> -			} else if (folio_test_writeback(folio)) {
> -				xas_unlock_irq(&xas);
> -				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> -				goto xa_unlocked;
> -			} else if (folio_trylock(folio)) {
> -				folio_get(folio);
> -				xas_unlock_irq(&xas);
> -			} else {
> -				result = SCAN_PAGE_LOCK;
> -				goto xa_locked;
>  			}
> +			nr_none++;
> +			index++;
> +			continue;
>  		}
>  
> +		/* At this point folio can be NULL, or a value. */
> +		state.folio = folio;
> +		result = prepare_collapse_file_folio(index, &state);
> +		folio = state.folio;

I think prepare is a better name than my "check" functions. But i think it
should also handle the isolation code below.

Cheers,
-- Nico

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

