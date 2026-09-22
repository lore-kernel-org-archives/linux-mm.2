Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED413C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7E36B009B; Tue, 22 Sep 2026 07:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEAC6B009F; Tue, 22 Sep 2026 07:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89846B00A0; Tue, 22 Sep 2026 07:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF1596B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:32:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42768140456
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:32:57 +0000 (UTC)
X-FDA: 85241186394.08.83E5358
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2B96140003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:32:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lqw/VHsF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Bt7fouIx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z7nMRJA3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g82nSuCf;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790076775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=JuQqqLt19gnxO6tRqG3BcZWffKHRRQOJ29HDAhhfYRYLxsG+39s3ou7OA4U6BwH3yt7a1A
	NEaPchmDhgYVsT2jElUdY5XHv2L4EqsdZmPzFot6AgBJrYG7xUIIsp7cbcDASu9YHTuZP9
	9BD3otDsoYLnmfy6P2nWvsp6LMpBALk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lqw/VHsF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Bt7fouIx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z7nMRJA3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g82nSuCf;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790076775;
	b=dDl0eTJk3bpEKCHy8LeFt2uAeRzs+lkmKOjAC5VwOmSPwNvxREhrpCK4WIJGdG2WQgneAH
	+ww/3ZcbeVBlD47SLo+KdTpMA7qwMQ8u1rVQYgieATxBcnRpmvmNeNjwl/BzjUVBsNPYOU
	066htA3HCmPrW0PYnS6UQOxliuU6PRo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1F39F1F769;
	Tue, 22 Sep 2026 11:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=lqw/VHsFOyM1PsjsKWmUnjEAiCZrbCnlFP2c7OK+0emnIHPmzIbSp1YpgckUrEHrz2AjrC
	/aWIoTkEXg8IG0wwc6BsWf1vGj9FIih8N+MsndNSIotYIWQbAi16PyUfu0l/F5ZxazwUu0
	D7t+jRi1ynyV3tEtiFWjEZ2J9nt4SSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=Bt7fouIx/zmaW99whmgqogNbfULuwiK8aUDCtch2h0xdWVV8aNbOOh48S9YFiJQO1/U7I7
	N46r8uF2MkoG7lAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790076765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=Z7nMRJA3v3h9WyGyPMrFub5U360su5GbXavnZdD3x71RC76+r8aj4DqIxF2+lT6vTLsEZi
	tz3IkGHeqZQKzlpmnjbKbwVKmS/uyNNA3TW7nHY7PkNnz7f6/w1Gbg0cju42okiZ0tMzOx
	TTkuY2HSZWOHUN6TVyOA5wO4PVMcbxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790076765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qHNqRhZsY4PDDoaGfo9Y4rMrXjw8S4znraHltHttsGg=;
	b=g82nSuCfFgyI2FLYZDCH/OAHmR7BQZm0QS3txU3OBpo0yR30jLM02PapAsE9RY8V8EeHGk
	Aih5aEjTgmXiYZAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2D60132D3;
	Tue, 22 Sep 2026 11:32:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mNjuLFxnsmpTcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:32:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67F14A13D4; Tue, 22 Sep 2026 13:32:36 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:32:36 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Message-ID: <uo7xgm7zk53f77i6qnrubqbhxf3tg6tp7qscci5nkylifnfahv@nf2xpxbkqwbe>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-2-yi.zhang@huaweicloud.com>
X-Stat-Signature: eyws3eg8ykc8rj8zyxb7oe9ki9ao6sfp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2B96140003
X-HE-Tag: 1790076774-933993
X-HE-Meta: U2FsdGVkX18EXiaqK5J6oW6o41Z+ptMB6b0Rv3cvms40vTCgnLbdgP8imX/l8nWzurT4TquCjGy2Sq/oi9R6kMSm/nYKoPv/s3CHDUK82gqNkusPrm4K8EJ46MO/KbhoLDHBdC7qPfzI3/c1+qxPxCoIltIU4MEEht3L1lPMYmOY7S21qdJZNCbh+OwXX7YJZdTHRDzGmwTPSOuPd7HQygFefIseeHtHY15uu8/rBMvyzxrw/UphbD1U77obslf96Uj5hqoICiA4oJWLC0Z6kiJDzyPl31n1k1ZjkdKkigAtH9pnrfB61xySIv6fci62Dqic4YZO7kO89lKC+pWR7T4HA6tsAbaYBxCdznAFAJoy8DeH6IAJDJiP5r0DoWG8D/sCuXJROML4YtAK2uJv7FDVb5cJsCOZWwlCB5M6lxSULC908M+AiVdzVIKMyaEUAKR1tyFncqnnIVkRbtyp6VtBtVb2cbyfDIHmnx/58HUfrFMx7OvB+sFH90A0RBaq9oz0Yeu8ICavY2kLF33ocZYRVKCwZec9hK/SxYAbAnzV7eFtDprpo4Tk4OpVWim7ucb4U2aoRi5GQgpF4q6WacVRgUvUUEsBl+Zykms0UM76cp33g5XPYKr4nIhzHBh5FM7JISyv96bd+OlHWhhb7/KdW2pgYAU3dIxuqWebojhIb9DfOWSlvAZ8JXlnSnme3exNdPzRtLk0XIKWs74NEYWDqjaV7ZqphA9WAeU44WxV1GC7SE7M07se9mDxO0m1LTRxz+6ainP9Yv8vrRk1+nWulS/V5nqaxSoxa4jAf4TvEpGj7EYb/+H+EX/BijeKn8PIS2/ECU0fOAld524KWwkete8fYkEhTSVOeN+UmGHjmXKvw+XwBXrUtRCdhJ605p9Kysg7O6vQ/8bYTpNxZ3tVFKr789NtJ6ZI0x3vzYdVGbUMzyC4+XoGFquVjmpXCcexdpMQPuNags8zeEX
 zkIdtjgM
 Sq6K6HsWMdp1r1iaSAuKTNhje/d3S0jNZPwYogkWdpX5HSnl5RIP/5g8ZgZ+ika6kEpeVgz4/p6Z50ln+kEXoW5nqQP/y4s695iDebXhkKMXdSTdeHHtfncgzbQL8Fkkyy8OOro7bV/w2CkHI30HieaV9x3pdjQFyN0HWB39GF9kKQh+TJdrs3Z3/1q3sQJ40XeoMqBnZFCe3qXBaeChjmXae8TwA819zn0yqcGQF1uOkBBF2b3nKrJhU0SyW60l/l4e1fR22IwMMuCPIdf5fhhVOzK+Pcs6wu/1x2r8GCnmhxHOqoOZK/0H4CXw1earFF49BIoLElTpjwO6m1i1dnExji5AFm4lqRLOmx8Qx4e6EB1nOltDbhEuPwyVGBX4I7q4tjNmVdHy+MnCuW5BGRy87MYO3x6JsNLVi28gpY8t5RHNuur+fzaTb9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 22-09-26 19:07:00, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When the mapping has a non-zero minimum folio order (min_order),
> folio_split() in truncate_inode_partial_folio() stops at min_order
> instead of order 0, so the sub-folio containing a split point stays
> aligned to 1 << min_order rather than to a single page. The original
> boundaries in truncate_inode_pages_range() were based on page
> granularity, so either boundary could land inside the min_order chunk at
> its edge, and the truncation loop would drop that whole chunk, valid
> out-of-range tail included.
> 
> For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
> offset 0 to 36K:
> 
>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>   folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
>   2nd split of folio2 -> [p8-p11, p12-p15]    # success
>   end(old) = p9                               # BUG: p9 inside [p8-p11]
>   loop truncates ... p8-p11               # p9-p11's valid tail is lost
> 
> It has gone unnoticed so far for two reasons. A non-zero min_order is
> only used by filesystems with a block or sector size larger than the
> page size, and those either always write back the affected range before
> punching a hole or truncating, or they carry filesystem private data on
> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
> fail and folio_split() abort with -EBUSY, so the folio is never split
> and the old start/end boundaries remain valid. The bug only becomes
> reachable on paths that truncate dirty large folios without prior
> writeback and without filesystem private data, such as the upcoming ext4
> iomap buffered I/O path.
> 
> Align both start (rounded up) and end (rounded down) to the mapping
> minimum folio order so they always fall on a folio boundary.
> 
> Reported-by: Joanne Koong <joannelkoong@gmail.com>
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/truncate.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..f9625bb4916f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>   * @lstart: offset from which to truncate
>   * @lend: offset to which to truncate (inclusive)
>   *
> - * Truncate the page cache, removing the pages that are between
> - * specified offsets (and zeroing out partial pages
> - * if lstart or lend + 1 is not page aligned).
> + * Truncate the page cache, removing the folios that are between specified
> + * offsets (and zeroing out partial folios if lstart or lend + 1 is not
> + * folio aligned).  For mappings with a non-zero minimum folio order, the
> + * boundaries are aligned inwards to 1 << min_order so the edge sub-folio
> + * straddling the range is kept.
>   *
>   * Truncate takes two passes - the first pass is nonblocking.  It will not
>   * block on page locks and it will not block on writeback.  The second pass
> @@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	int		i;
>  	struct folio	*folio;
>  	bool		same_folio;
> +	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
>  
>  	if (mapping_empty(mapping))
>  		return;
>  
>  	/*
> -	 * 'start' and 'end' always covers the range of pages to be fully
> -	 * truncated. Partial pages are covered with 'partial_start' at the
> -	 * start of the range and 'partial_end' at the end of the range.
> +	 * 'start' and 'end' always covers the range of folios to be fully
> +	 * truncated, with both boundaries aligned inwards to 1 << min_order.
>  	 * Note that 'end' is exclusive while 'lend' is inclusive.
>  	 */
>  	start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
> @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	else
>  		end = (lend + 1) >> PAGE_SHIFT;
>  
> +	start = round_up(start, min_nrpages);
> +	if (end != (pgoff_t)-1)
> +		end = round_down(end, min_nrpages);
> +
>  	folio_batch_init(&fbatch);
>  	index = start;
>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

