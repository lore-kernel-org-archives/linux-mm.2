Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14D8C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 10:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8EB36B008A; Wed, 22 Jul 2026 06:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3EDE6B008C; Wed, 22 Jul 2026 06:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07096B0092; Wed, 22 Jul 2026 06:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFC2F6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:09:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41AA880455
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:22 +0000 (UTC)
X-FDA: 85015990164.21.B4E08A3
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8D7EF40006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwUBfWfi;
	spf=pass (imf27.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbZilrAwqWoZrYkJoelEKIE52CQ/nyZ9NXOXJK2xQqc=;
	b=Lw5mf+py9dC7laSqdwHCyvoG4y8hqnHD6wUsj9uYppHSaDnWjJFQOmk9awBzLJGU/XXAh6
	4hqN4DI+UHyLvkVJPParSLRZozag5+3Z36btYw/gz6lkS+IaRb/Jy8+SUi6faVpHT/FHu2
	gaK1AJlRONp8i77x7O8MeV0LLEX8wlU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714960;
	b=ul3VhSe9S8JxYrinUsIppeYguMNYNDHFIYmDrMOpSqIBQg+qND18wJQoUpTpZPNG0CVmy0
	spLQqE++Yf0hu9vaonl+aE1n2W/KOr087kXVD+McwICLkMkBbBDMaks85qlMIbarvxVKhF
	/Rc5W/wjGx/vTantLlgoP8WdbyQjqjI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwUBfWfi;
	spf=pass (imf27.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784714959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WbZilrAwqWoZrYkJoelEKIE52CQ/nyZ9NXOXJK2xQqc=;
	b=cwUBfWfiB9fmshkStpgd4bVyiAfog5aucP/KUrw1/tUCotII604KFRILL7bI2bIN7F6Tsl
	EwzpQT+q5ifTKbPLFHjvaSL+gUUGgDdFE4puhkjre6v/GukjzPu2dx/OX0SmWxzbntXbnq
	bPZ2eF4tFWBqJZZF6I4nr/bTS8KrIPM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/8] mm/khugepaged: factor out page cache folio reading
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
In-Reply-To: <20260720142913.846902-3-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-3-pfalcato@suse.de>
Date: Wed, 22 Jul 2026 04:10:38 -0600
Message-Id: <178471503895.281396.10308212257898921197.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D7EF40006
X-Stat-Signature: ters86siws1meq5grg8tnxy4ir8yie1m
X-HE-Tag: 1784714960-56894
X-HE-Meta: U2FsdGVkX1/KxKjMUdZkbBHYsEkdK6NuvPedjPoIghKgs3agSVfK118yREWE8CMq7NbVnJeGOrHRGeLR1mRX1C7eo3t/M7ilvtm5EyDC6426CCrHZHBbgIvieCcKMa/0BwsnHC6dQDXsQARXfIkMe76C8AUidpk4xpBigirusc81O/SSHL7od55R400r6tUV3X7ghxvPjVuD/0G/GChtcBZ+sldZd+Og/FH4h3TRjPEoWhoyK7LnOJZ+VmSY6DD5ukJhCPM3+foz4HHxCpz/uJmauvuIkfZ1tPt6wx4ui3V5oMi1g8U+L3dnmFCUOljSCVu+ibFGmsBimsHJrUUbriLXdttY2uPk5YGEwKhrEfTTgxjUt2iQWzM5HOsB2KbJB2BxEpuXdVmkuDgTV6B3qZu2ze0AxCA+tU8Rl4XMeM4mPmHjRufL0Gqy4Sm0pnxdJsTR5tmi1eq8bXZ7Us86lHy2Vhs+bxWQhIJ/uhkvpU8kQA8YjiRLO1l9ucVAbZvDGtBkrnIN3ahHqTHoyS10bHtjeB9jP3Moee5SlBWDtZUma+ZA19W4kHavNv9VzbwR/jvY9auqM8usNT7YRn5G7DipPmRbsMsfW1Fxs4mHqcYsSdogGok5BG+KfxIqlv5AWoRAAwtUc/6vZFIPF3biselqoXF+/dd3vuOKBYmM8joaZd8r9LOC7V7TSaZ18URgRsk1Alj4V1AlcOX58lkUQg2582LJK/1cQAwURbXfkiqsYxGUL9N6CZrIuQnMb6vXYY15nyjANjTluPj6xRJaWiFfoJJM87/XgUwjKT417OMxdgKzlq8X3zIGZV2waNiDJyI8uDn+vgNvjf7xV8vuXr+cBpjGXqO3r36Eia90i5I3pdxsT3828PMnnilcincliE7hmA3uvZfQV2KVYT6bCzOuGmQTpg5T8dSD3G0yof+Ul3ZnOU47dQyQ3ik9q5H2u9zzLsXTmOOJHOdzb52
 6ZIxG4EP
 ZYUdICp5KintfHqJgmn5McjOzckY0k/zC2AcizulygktqbT0AzJLrFoCWdhezCOfRvFVxwkLJSCj/Zvw5uNRJm7BuKMLBGzyZaAYf6smpIia2f8aCoEpCfEFkwUv8dBzIv4jguyFRCMXQRs6M2HF1dhSB5H/9vMj2z6bzfLYjNJMPGHOk+IKbneQj7NNxSXv8xL7ureVyTHvo8l0gmQc420ETjJUZyHZ6aPAeZMTL4akpxN9tsOnust/A0frjNgvVU4/ynQKZJh5YHKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The two mechanisms (shmem, filemap) are quite similar and only change in
> subtleties. There is no need to have two variants. Factor this out into
> its own separate function, shared by both paths.

As I stated in my review on (1) I think you should first hoist the
prepare+isolate into a helper, then later do cleanups like you do here.

The flow my patch follows, leaves for much cleaner (and shared) error handling.

Sashiko left a comment about some locking issues which might be why sysbot
found.

https://sashiko.dev/#/patchset/20260720142913.846902-1-pfalcato%40suse.de?part=2


> 


> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d4de507ac001..4cc6917a55c7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2230,42 +2230,63 @@ struct collapse_file_state {
>  	unsigned int is_shmem : 1;
>  };


>  
> +static struct folio *collapse_read_folio(pgoff_t index, struct collapse_file_state *state)


> +{
> +	const bool may_bring_uptodate = state->is_shmem;


> +	struct folio *folio = state->folio;
> +
> +	if (!folio || xa_is_value(folio) ||
> +	   (may_bring_uptodate && !folio_test_uptodate(folio))) {


> +		xas_unlock_irq(state->xas);


> +		if (state->is_shmem) {
> +			/* swap in or instantiate fallocated page */


> +			if (shmem_get_folio(state->mapping->host, index, 0,
> +					    &folio, SGP_NOALLOC))
> +				return NULL;


> +		} else {
> +			page_cache_sync_readahead(state->mapping, &state->file->f_ra,
> +						  state->file, index,
> +						  state->end - index);
> +			folio = filemap_lock_folio(state->mapping, index);
> +			if (IS_ERR(folio))
> +				return NULL;
> +		}
> +	}
> +
> +	return folio;
> +}
> +
>  static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
>  {
>  	struct address_space *mapping = state->mapping;
>  	enum scan_result result = SCAN_SUCCEED;
>  	const int is_shmem = state->is_shmem;
> -	struct folio *folio = state->folio;
> +	struct folio *folio;
> +
> +	folio = collapse_read_folio(index, state);


> +	if (!folio)
> +		return SCAN_FAIL;


> +	if (folio != state->folio) {


> +		/*
> +		 * collapse_read_folio() got a new folio. This folio is locked
> +		 * and ref'd up. Nothing tricky (dirty, writeback, etc) can
> +		 * happen, so bail now. But before that, drain the local LRU
> +		 * add batch. Otherwise, it's very possible folio_isolate_lru()
> +		 * will not succeed.


> +		 */
> +		lru_add_drain();


> +		goto xa_unlocked;
> +	}
>  
>  	if (is_shmem) {
> -		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
> -			xas_unlock_irq(state->xas);
> -			/* swap in or instantiate fallocated page */
> -			if (shmem_get_folio(mapping->host, index, 0,
> -					&folio, SGP_NOALLOC))
> -				result = SCAN_FAIL;
> -			/* drain lru cache to help folio_isolate_lru() */
> -			lru_add_drain();
> -			goto xa_unlocked;
> -		} else if (folio_trylock(folio)) {
> +		if (folio_trylock(folio)) {
>  			folio_get(folio);
>  		} else {
>  			result = SCAN_PAGE_LOCK;
>  			goto xa_locked;
>  		}
>  	} else {	/* !is_shmem */
> -		if (!folio || xa_is_value(folio)) {
> -			xas_unlock_irq(state->xas);
> -			page_cache_sync_readahead(mapping, &state->file->f_ra,
> -						  state->file, index,
> -						  state->end - index);
> -			/* drain lru cache to help folio_isolate_lru() */
> -			lru_add_drain();
> -			folio = filemap_lock_folio(mapping, index);
> -			if (IS_ERR(folio))
> -				result = SCAN_FAIL;
> -			goto xa_unlocked;
> -		} else if (folio_test_dirty(folio)) {
> +		if (folio_test_dirty(folio)) {
>  			/*
>  			 * This page is dirty because it hasn't
>  			 * been flushed since first write.

I agree with Lorenzo that this leaves a very ugly intermediate state. As I
recommended please combine prepare+isolate into one stage, with two helpers
for filemap and shmem, then do these kind of cleanups.

-- Nico

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

