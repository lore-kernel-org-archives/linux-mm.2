Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD18DCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA936B0005; Wed, 17 Jun 2026 08:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B606B0088; Wed, 17 Jun 2026 08:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264B46B008C; Wed, 17 Jun 2026 08:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE07A6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:18:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 647561403BA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:18:01 +0000 (UTC)
X-FDA: 84889306362.14.7AE4434
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACA0C8000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:17:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e74Tc10i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781698679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiUpLWWUi0/Ij99VUFv9W7HFIta4SzxOm+ph3FaGX1Q=;
	b=YaoJ8x7hUts9qV8HF31NQYjrlY4TJ50AZNv8/wJqSJwObjITQNZg+SED7UVJA7+RbhYV8o
	hcxDUlJiADJDKgjPSV5uaIRRgkp7Nv4nn+A5889cPbXfpjDeJi6zbcKI7d/d8CFXKCFcFx
	lDbiX7Q1hqmTQgfMcqxoIq6iisJ99HE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e74Tc10i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781698679;
	b=k0MvcMGweAy/sRlhhmgUd75wwFtuQPhKhwUgBW8B5L+KWyzvd8C+BeCPi/c1Q/V6gdBNVG
	9s49ORvFoGlZYf0vW0r4zz7wmbtSPzwT9CiSSMRKQ3cj8pT6ghesXfBIssyzhQrdT+/iYQ
	Boj8bIc9nDTqE897noBP/eSCwnInjYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF48E6001D;
	Wed, 17 Jun 2026 12:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C506D1F000E9;
	Wed, 17 Jun 2026 12:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781698678;
	bh=uiUpLWWUi0/Ij99VUFv9W7HFIta4SzxOm+ph3FaGX1Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e74Tc10i08lDXN77ibTdKvAmwkmjdWcHOxFVFvRG41VjCayL0V85LOpMrs5XLwwLl
	 HG+TEBp6HJA2lona+dH2siCL26bPknGq2dEOHFW6yzb/kKhhrN/lXw1e0g6e+vdCOx
	 mXGsgyUQf3o4hEz6a9fAfdFUX82g/gqKQKbK6CWmIwTuytWYO2wDcC9c8oN4295KUc
	 chevt5A4Qt86cRyYojKnRHPOVK/tBhEzhUZmYufIBMTPrtcdm3ban2/IKixeU/AmW/
	 pZSKPvmJolNc6AUAbbM6QCg64p6+ts6G4t7Oxk4/1ZAV7KOC/+Hz8zEwobuO/M6R3K
	 IJF2Cu4WDS7ew==
Message-ID: <c6220407-fbdf-47ab-a80c-732e470894bf@kernel.org>
Date: Wed, 17 Jun 2026 14:17:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] mm/vmscan: extract folio_free() from
 shrink_folio_list()
To: Zhang Peng <zippermonkey@icloud.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
 Zhang Peng <bruzzhang@tencent.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
 <20260525-batch-tlb-flush-v4-2-83789d6abc00@icloud.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260525-batch-tlb-flush-v4-2-83789d6abc00@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACA0C8000B
X-Stat-Signature: 4yf933aacagmncf33wiegeukpaxwkyp7
X-HE-Tag: 1781698679-566911
X-HE-Meta: U2FsdGVkX180W9YJAmiEnhw/RGCExeOnrqRmeNsraaciH4tcgZ1Rv4+dElNWSoQprhHjTpursYOH8GapK8CZZ0lcHc6bYbcAziW5SY7hK4jC2Ew1C9RKHSt0QSWWi7diDIUxeYUF+OWKS+HpkZQ4+9jnKliWDAmC+JRvGgn+ZK8qF7ctArSsoxSuPvpaj19PJNBsMVu4efMbIvSghaezu+R4tagmDIlt7pze4Obz+nj1rVhT8cGnqHcDmjrVyk1VrYdDFOrHXW919VV7ocdf0YS5fz2V7Ax2Le/WYaKlMZhTMA/BdIkml0F7b7b4GuSghiV2gpP5eQpWtA6zE/c8BUJ3lr8hYaZ5Q5887QF8zU5iERoM9C4SkDGLERZi6WYS6n0x/dpMN3lVYKzPl6nhxjY057u9sgTb0fc7ernllILv9ghGMJoQ5DOX61lmdS3wodw1HoKoqFXb6LCAuzH094EgcvsGB3JnamLHtatW9StJZs4G132Vd5yKqopxL8+gzWF04vgYPQ7FX6OEKmLDdb3hjvWqkx/YzxLMUDmfpUu2HBNjNEufrEv6ZQ2wTsPIsksmM5K16qElR87jzHXPc1uhEZK1g2dREgsNkjf3U2sJiZ0LURdf7lhrmha0cCyfK8YQQT/bUPL+SmCPrBpPB0SXSgEqNW5WQW1Bz/t0cJkhwOeA1XFAh/ichcxN0f1NqbcgxMu10PcjTgonDRTmf/S/A+BSJmnkXOwOQfhkhB5oID9QQ7oNrXNew9HbO0+G6vbP68gUTI99VGJamtLf9qce72uyWSz8QkhUnyDnPv4nNmOx2LhtZUvwY6AnyqQH+EfbOgetyWJkG4v2nurQR5SK9gsvGFBeq4m1zeiYbPMt9FMa1HPJm2e7VNGgPSXcppPyVIdOsP1XDSOF4zIG2WQmHI4dNKgl8fR1o4Q7ZC+lCJ3cdhiSgO31BucPFAqE/fbsoTNQyVSTUqRHKt1
 eimHSd+K
 s0aZ97VKqJohLX6l/JozqCWYizLlPwQ8nyvFOrAaMo1IAM09sDvu86g8ebBWF0kuXskdReBK1rR3/zXNm3GLzO4XetRBlBTFuGcKyKx2hrydu1f3yeDzOdVpqjGTvIHLnY7Pj21e5AOjKb82Ps8Obb5/0N8ga5NjS7rVr/54KfxEWogINcka+b/G/I1lPdWmro5ihfHcnVr/tPmPX0YdOWxgXV2qbjL54egYXk99CBqNUjppoUwz/CAp2yCrmCITTs5SzR8GzbFNb86FP2Evpv31rpSiUOTGzz0UvHMqJWqI8xnaCySloMVbuOpAPus5h/n6UOhxeDnyauhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 16:57, Zhang Peng wrote:
> shrink_folio_list() contains a self-contained folio-freeing section:
> buffer release, lazyfree, __remove_mapping, and folio_batch drain.
> Extract it into folio_free() to reduce the size of shrink_folio_list()
> and make the freeing step independently readable.
> 
> No functional change.

As you are touching the code, I'll suggest some simple improvements as part of
the move.

> 
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 168 +++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 92 insertions(+), 76 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 886d8b4843aa..b31f67801836 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1072,6 +1072,95 @@ static void folio_activate_locked(struct folio *folio,
>  	}
>  }
>  
> +static bool folio_free(struct folio *folio, struct folio_batch *free_folios,

I don't quite like the function name, as it sounds like something very generic,
when it's really specific to memory reclaim code and does things like removing
the folio from the pagecache.

Any way we can easily make that clearer? I think it should contain something
about release and reclaim.

folio_release_for_reclaim() or just "folio_reclaim()" ? Not sure.



> +		struct scan_control *sc, struct reclaim_stat *stat,
> +		unsigned int *nr_reclaimed)

Instead of returning a bool, can we just return 0 / -EBUSY? IMHO, a bool mostly
only makes sense if the function name implies some sort of yes/no test. (there
are exceptions).

> +{
> +	unsigned int nr_pages = folio_nr_pages(folio);

Can be const.

> +	struct address_space *mapping = folio_mapping(folio);
> +
> +	/*
> +	 * If the folio has buffers, try to free the buffer
> +	 * mappings associated with this folio. If we succeed
> +	 * we try to free the folio as well.
> +	 *
> +	 * We do this even if the folio is dirty.
> +	 * filemap_release_folio() does not perform I/O, but it
> +	 * is possible for a folio to have the dirty flag set,
> +	 * but it is actually clean (all its buffers are clean).
> +	 * This happens if the buffers were written out directly,
> +	 * with submit_bh(). ext3 will do this, as well as
> +	 * the blockdev mapping.  filemap_release_folio() will
> +	 * discover that cleanness and will drop the buffers
> +	 * and mark the folio clean - it can be freed.
> +	 *
> +	 * Rarely, folios can have buffers and no ->mapping.
> +	 * These are the folios which were not successfully
> +	 * invalidated in truncate_cleanup_folio().  We try to
> +	 * drop those buffers here and if that worked, and the
> +	 * folio is no longer mapped into process address space
> +	 * (refcount == 1) it can be freed.  Otherwise, leave
> +	 * the folio on the LRU so it is swappable.
> +	 */

I assume you can now adjust the comments to use more space and less LOC.

> +	if (folio_needs_release(folio)) {
> +		if (!filemap_release_folio(folio, sc->gfp_mask)) {
> +			folio_activate_locked(folio, stat, nr_pages);
> +			return false;
> +		}
> +
> +		if (!mapping && folio_ref_count(folio) == 1) {
> +			folio_unlock(folio);
> +			if (folio_put_testzero(folio))
> +				goto free_it;
> +			else {> +				/*
> +				 * rare race with speculative reference.
> +				 * the speculative reference will free
> +				 * this folio shortly, so we may
> +				 * increment nr_reclaimed here (and
> +				 * leave it off the LRU).
> +				 */
> +				*nr_reclaimed += nr_pages;
> +				return true;
> +			}
> +		}
> +	}
> +
> +	if (folio_test_lazyfree(folio)) {
> +		/* follow __remove_mapping for reference */
> +		if (!folio_ref_freeze(folio, 1))
> +			return false;
> +		/*
> +		 * The folio has only one reference left, which is
> +		 * from the isolation. After the caller puts the
> +		 * folio back on the lru and drops the reference, the
> +		 * folio will be freed anyway. It doesn't matter
> +		 * which lru it goes on. So we don't bother checking
> +		 * the dirty flag here.
> +		 */
> +		count_vm_events(PGLAZYFREED, nr_pages);
> +		count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
> +	} else if (!mapping || !__remove_mapping(mapping, folio, true,
> +							sc->target_mem_cgroup))
> +		return false;
> +
> +	folio_unlock(folio);
> +free_it:

Okay, at this point we should have a refcount of 0. We could make that
more obvious through

VM_WARN_ON_FOLIO_ONCE(folio_ref_count(folio), folio);

> +	/*
> +	 * Folio may get swapped out as a whole, need to account
> +	 * all pages in it.
> +	 */

Likely can shorten to

/* Only full folios get reclaimed. */

Or just drop the comment completely, I don't quite see the point.

> +	*nr_reclaimed += nr_pages;
> +
> +	folio_unqueue_deferred_split(folio);
> +	if (folio_batch_add(free_folios, folio) == 0) {
> +		mem_cgroup_uncharge_folios(free_folios);
> +		try_to_unmap_flush();
> +		free_unref_folios(free_folios);
> +	}
> +	return true;
> +}
> +
>  /*
>   * shrink_folio_list() returns the number of reclaimed pages
>   */
> @@ -1459,83 +1548,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  			}
>  		}
>  
> -		/*
> -		 * If the folio has buffers, try to free the buffer
> -		 * mappings associated with this folio. If we succeed
> -		 * we try to free the folio as well.
> -		 *
> -		 * We do this even if the folio is dirty.
> -		 * filemap_release_folio() does not perform I/O, but it
> -		 * is possible for a folio to have the dirty flag set,
> -		 * but it is actually clean (all its buffers are clean).
> -		 * This happens if the buffers were written out directly,
> -		 * with submit_bh(). ext3 will do this, as well as
> -		 * the blockdev mapping.  filemap_release_folio() will
> -		 * discover that cleanness and will drop the buffers
> -		 * and mark the folio clean - it can be freed.
> -		 *
> -		 * Rarely, folios can have buffers and no ->mapping.
> -		 * These are the folios which were not successfully
> -		 * invalidated in truncate_cleanup_folio().  We try to
> -		 * drop those buffers here and if that worked, and the
> -		 * folio is no longer mapped into process address space
> -		 * (refcount == 1) it can be freed.  Otherwise, leave
> -		 * the folio on the LRU so it is swappable.
> -		 */
> -		if (folio_needs_release(folio)) {
> -			if (!filemap_release_folio(folio, sc->gfp_mask))
> -				goto activate_locked;
> -			if (!mapping && folio_ref_count(folio) == 1) {
> -				folio_unlock(folio);
> -				if (folio_put_testzero(folio))
> -					goto free_it;
> -				else {
> -					/*
> -					 * rare race with speculative reference.
> -					 * the speculative reference will free
> -					 * this folio shortly, so we may
> -					 * increment nr_reclaimed here (and
> -					 * leave it off the LRU).
> -					 */
> -					nr_reclaimed += nr_pages;
> -					continue;
> -				}
> -			}
> -		}
> -
> -		if (folio_test_lazyfree(folio)) {
> -			/* follow __remove_mapping for reference */
> -			if (!folio_ref_freeze(folio, 1))
> -				goto keep_locked;
> -			/*
> -			 * The folio has only one reference left, which is
> -			 * from the isolation. After the caller puts the
> -			 * folio back on the lru and drops the reference, the
> -			 * folio will be freed anyway. It doesn't matter
> -			 * which lru it goes on. So we don't bother checking
> -			 * the dirty flag here.
> -			 */
> -			count_vm_events(PGLAZYFREED, nr_pages);
> -			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
> -		} else if (!mapping || !__remove_mapping(mapping, folio, true,
> -							 sc->target_mem_cgroup))
> +		if (!folio_free(folio, &free_folios, sc, stat, &nr_reclaimed))
>  			goto keep_locked;
> -
> -		folio_unlock(folio);
> -free_it:
> -		/*
> -		 * Folio may get swapped out as a whole, need to account
> -		 * all pages in it.
> -		 */
> -		nr_reclaimed += nr_pages;
> -
> -		folio_unqueue_deferred_split(folio);
> -		if (folio_batch_add(&free_folios, folio) == 0) {
> -			mem_cgroup_uncharge_folios(&free_folios);
> -			try_to_unmap_flush();
> -			free_unref_folios(&free_folios);
> -		}
> -		continue;
> +		else
> +			continue;

You can just drop the "else", no?

if (...)
	goto keep_locked;
continue;

>  
>  activate_locked_split:
>  		/*
> 


-- 
Cheers,

David

