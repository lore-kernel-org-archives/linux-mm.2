Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0F9606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=s6BX8a9h;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uN4oYGZL;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=p/LYOaxX;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qs0l/DFN
Received: by kanga.kvack.org (Postfix)
	id 6939A6B05B3; Wed, 11 Nov 2026 06:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BFB6B05B4; Wed, 11 Nov 2026 06:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BAD6B05B9; Wed, 11 Nov 2026 06:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8FC6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:45:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D102A0283
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:45:55 +0000 (UTC)
X-FDA: 85422659070.13.6358482
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2C5ADC000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:45:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s6BX8a9h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uN4oYGZL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="p/LYOaxX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="qs0l/DFN";
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397553;
	b=cuC4RwY+RNJ85SplLQOvEfj8aquvV+NasH0/lfkoWm8CA2kVYWWdFqn+qTmuIZNOb3bYZF
	Q47Qj6u53YTqGBjU21/rR7oHIOkCPlL37c4NuQ6OmA0GT1eQaFSGJpSMOaHDb2lBWHhODS
	8Jb6DK2d/PQrZiqIntP6nVYJiSC8c3M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s6BX8a9h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uN4oYGZL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="p/LYOaxX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="qs0l/DFN";
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOeckYZLzpTjDlCSMcNe3YCWoDCfaX4IlNVrhqCPTQo=;
	b=Is64U8Xj2qBm+VqU+maendLOULh70chGBD3/hW0FH89Lc8Ow8cpGE4sAQ/Kwzntdpav24z
	A6Ncv9zRotREUgmyOPhFUHJYtvtqxkDFFm+x1hKYFOYXfI5kqzAiyf6ZiV5dv3iA7ebP90
	u92xrsbym35eDNnYK9FeM7c+bgpk8B8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75B821F458;
	Wed, 11 Nov 2026 11:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794397551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOeckYZLzpTjDlCSMcNe3YCWoDCfaX4IlNVrhqCPTQo=;
	b=s6BX8a9hyHYJk3Z5UpX3ucmxqVW5naQK2EWnRYF/JMtmoRkByYLUk5tDSYZvmVCSGWX6/P
	jrCFXRM0CEkSlDISMW2Q+yqOXRteM0VsFqKpkqSti7OkDj5MEr+lvxOlVZ9ipQwecRmh58
	YURDtKaDb8l65cCYOdmyBrhX7FmpYKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794397551;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOeckYZLzpTjDlCSMcNe3YCWoDCfaX4IlNVrhqCPTQo=;
	b=uN4oYGZLgkd3IFxs1MztgB9Bh/RKewnj+HvoiAKdUlTPHCRYIXvxuIjTYguaSuY7vrrPmy
	42ILGHyNz+9AEtDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794397550; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOeckYZLzpTjDlCSMcNe3YCWoDCfaX4IlNVrhqCPTQo=;
	b=p/LYOaxX/ZvF0hJsvCX+detet60BIfid09glgP58k23wnP4rA/a3w5dhXaYGiv/kUOdqOq
	/h1DCLSOvf7eaVtSfbT1KlwOZAHiWjY2CP/t8wtmWOfp3p400bmiuB+ryaf4nvXb0QsvDs
	TK1pYPng2R77A39d777twj6U0sLbgGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794397550;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOeckYZLzpTjDlCSMcNe3YCWoDCfaX4IlNVrhqCPTQo=;
	b=qs0l/DFN/ahzoaaymot81rtIOJjFLzB6z19dAQQ/lmkvX8JJZA6gHl2B6LD2ByU2/n/Qne
	4GdNozEoBxAmevAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4ADBB1339F;
	Wed, 11 Nov 2026 11:45:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tIsdCm5V9GrfZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 11:45:50 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CBCD5225EE; Wed, 11 Nov 2026 12:45:45 +0100 (CET)
Date: Wed, 11 Nov 2026 12:45:45 +0100
From: Jan Kara <jack@suse.cz>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	William Kucharski <william.kucharski@oracle.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH RFC] mm/filemap: fix lseek() skipping a new large folio
Message-ID: <wkpls4kiwl3ktyu5ekahlchabnaqq45o4tgv26cmrs552ljse4@oczec23ankdt>
References: <20261110-lseek_hole-v1-1-c089c960b846@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-lseek_hole-v1-1-c089c960b846@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Stat-Signature: sikgihn8rexxdqgnqcae9tsc77ejfif7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C5ADC000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794397553-114883
X-HE-Meta: U2FsdGVkX18i3DlDIOjPS/M6scdQNFnBQ6xKTYbs+DOWQgyzduzRDvKL7TIyt9l5g0uQzv59YlOx8jXN26CCKA7hJgKtcqg2LPE8VAdQVzV8nXcwO5CqR+nzTIT6LwBBZTm6js7U+ZFCqD1yoHuZ7xeSzgva9Rt0JNd0MRYyTjSKjqkGfhADdatlovT+96cMhCQmuocM50ZdPaM0Jppc37fWheobwpzreXAyuv2Jmu+5nMhrygzVsxfpgT3EtEaAHhDAkJnUgKEiyPwZg4b5i+c4/yLnN/1SFnjaaxdewP/pZjO++98S3SzzoyB84MaChoaHmmtbiS+8NNk8nUUcUK2DghgL+ErsT7PbKSS0ugncAGlHfbjEjcd/VwjKOeumTJ06d0vohG9K4ohT171q3QPLsH3wJVm20wM+/wHprAZMAlWZFDk1lj7BV4T3Zjj51tEHCWpjgs5cbfc9nS0fDAfNl5Lj0Hvm5GLDN/JJrcKYHpi14zeIwqVW1+jDBG311ahjEA9v3MTJ0R0z0p6TJCWOHza4C9NaodfWJfyXFVOaTNvsEfc3aoj52tYmgYsJg1nNctrJKT6gzSj3OaAA3z495Ms1yeAkpKjiPD2vxwZF2LfNTOjkrZdHLp9UQxflFMmuG7GWa8yOqVpaOpZZVKcXy7wy7j9dTMBMFfzh6b2DXtoxH+eTPBnUhN/bC5JGDbiC7GNcq2dmnZGfdcPHJWl1UKI+1aOVzqUwXChU7uVEYlx4licyuNQFOwKU37GrUsPQEKCeTdEwby6DGZu3GQ3i9OV0tFjLCqcJu1rbY4s9jvHcrw8a+Li7zCZjVzj80nI3NEOH1kaACcesY2HzM9eqNH0pwnKiSEcShP/iQ96dfqttmkTfEpWDigrOQGUFn1Wwf/qTmR9LlIRbXUgVSpfdOpprPzbkhX5SCm0yhzTx8MXo6iksDxiAQsrpMFZtlwz5E1oo9pFgFHxrZJI
 BLoeILRx
 rARkjqT/OROftD5f/iF6NQGGHPbdstGst21x/qmD7gDMbPIXCFoyL/wfO9jZ0hyQwxIVF8a3MX+STn805X3YqDZX8hlDec+V17f9wQc3ac0p9acpYLyzks5S8s3M33m4WGMyisuDyG1S+cPDs3J+FuQQ4BonbQzZsGZVby1N4gzrnqbUTS7tEov8Z8cnFLEa+A/7sIAIA6EMrrNsNZWtvmL1gKDFEbL013dIQJ2SWKM4igeeZafbeRnzyurpdX1J3WRBh55e8dzbjq21FzTkAftTCVYke0aU/iQ9xXEwE8f2ycvMuWur1PraeOtes4KiWOhIhzk5BXGBdPgr6RsttGijZjZqWyg5pYf1mzK3iOIV6ISg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 21:33:12, David Hildenbrand (Arm) wrote:
> mapping_seek_hole_data() walks the page cache under RCU and only calls
> xas_set() after entries larger than a page. Between base-page entries,
> it continues the walk with xas_find(), which skips sibling entries
> to return each multi-index entry only once. If a large folio replaces
> small folio entries between iterations, the slot holding the new folio
> can lie behind the cursor. Skipping its sibling entries then skips data
> that has not yet been examined.
> 
> On tmpfs, SEEK_HOLE can then return an offset inside existing data.
> SEEK_DATA can skip data after a fallocated page that is not uptodate.
> 
> For example, assume a 2 MiB tmpfs file backed by 4 KiB pages on x86-64,
> with page index 63 fallocated but not uptodate and all other pages
> uptodate. Index 63 occupies the last slot in the old xarray leaf. A
> SEEK_DATA starting there can skip that page, then race with collapse of
> pages 0-511 into one 2 MiB folio. The next xas_find() moves past the old
> leaf and skips the new folio's sibling entries in the parent, returning
> -ENXIO instead of finding data at page index 64, or 256 KiB.
> 
> The inode lock held by lseek() does not exclude collapse or swapin.
> 
> Restarting the xarray walk after every entry fixes this, but increases
> SEEK_HOLE time about 24%, when scanning a fully written 1 GiB memfd backed
> by base-page folios in an x86-64 microbenchmark.
> 
> Instead, use xas_next() for adjacent indices. Restart the lookup from the
> root at the requested index if it returns an empty slot or an internal
> entry, including a sibling entry. Also restart for nonadjacent indices,
> invalid iterator state, or failed folio validation. This avoids skipping
> unexamined data without restarting each lookup during base-page scans.
> 
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> I'll be more than happy if someone of the pagecache folks wants to take
> over ;)

This looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

I just find it unfortunate that we have to play complicated games like
these for such a simple operation as sequentially iterating over all folios
in a mapping. And it is not a first bug of this nature trigered by
compaction. So longer term I believe we need to provide saner apis
shielding pagecache users from these nasty details.

								Honza

> ---
>  mm/filemap.c | 38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 648f783454c3..87c583509567 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3233,6 +3233,40 @@ static inline size_t seek_folio_size(struct xa_state *xas, struct folio *folio)
>  	return folio_size(folio);
>  }
>  
> +static inline struct folio *seek_get_entry(struct xa_state *xas, pgoff_t index,
> +					   pgoff_t max)
> +{
> +	struct folio *folio;
> +
> +	if (!xas_valid(xas) || xas->xa_index + 1 != index)
> +		goto restart;
> +
> +	/*
> +	 * A lookup within a multi-index entry can leave xa_offset at its
> +	 * first slot. Restore the slot corresponding to xa_index before
> +	 * advancing.
> +	 */
> +	xas_advance(xas, xas->xa_index);
> +	folio = xas_next(xas);
> +
> +	/*
> +	 * A concurrent collapse can replace the next slot with a sibling entry
> +	 * referring back to the slot holding the folio.
> +	 */
> +	if (!folio || xa_is_internal(folio))
> +		goto restart;
> +	if (xa_is_value(folio))
> +		return folio;
> +	if (!folio_try_get(folio))
> +		goto restart;
> +	if (folio == xas_reload(xas))
> +		return folio;
> +	folio_put(folio);
> +restart:
> +	xas_set(xas, index);
> +	return find_get_entry(xas, max, XA_PRESENT);
> +}
> +
>  /**
>   * mapping_seek_hole_data - Seek for SEEK_DATA / SEEK_HOLE in the page cache.
>   * @mapping: Address space to search.
> @@ -3263,7 +3297,7 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
>  		return -ENXIO;
>  
>  	rcu_read_lock();
> -	while ((folio = find_get_entry(&xas, max, XA_PRESENT))) {
> +	while ((folio = seek_get_entry(&xas, start >> PAGE_SHIFT, max))) {
>  		loff_t pos = (u64)xas.xa_index << PAGE_SHIFT;
>  		size_t seek_size;
>  		u64 next;
> @@ -3286,8 +3320,6 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
>  			goto unlock;
>  		if (start >= end)
>  			break;
> -		if (seek_size > PAGE_SIZE)
> -			xas_set(&xas, pos >> PAGE_SHIFT);
>  		if (!xa_is_value(folio))
>  			folio_put(folio);
>  	}
> 
> ---
> 
> base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> 
> change-id: 20261110-lseek_hole-4a9eb450d473
> 
> --
> 
> Cheers,
> 
> David
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

