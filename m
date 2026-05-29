Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58479CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDFA6B008A; Fri, 29 May 2026 05:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95516B008C; Fri, 29 May 2026 05:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABBB6B0092; Fri, 29 May 2026 05:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 978586B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:47:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4993640DCB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:47:13 +0000 (UTC)
X-FDA: 84819979146.29.75EBE93
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FDE94000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:47:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HGWjvJ7k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PBIn0Exj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HGWjvJ7k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PBIn0Exj;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780048031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3Mx7+vtImpwG4SUbS85lLpmAFW5jV+p+rxF61HIx7M=;
	b=l7S6JQNsYmDqE3ha7k9IeD3h+YjvDtr4CGucxtU9ATVOv3tsftKVTXZAlpqEbF6BzzPrwL
	sSsWneKU4zg7PGSbRlWOrr1WhR7XHQ1wtOZpFzOSjgA4KcITzwvjeGfuf7wmCgbJaWk+nR
	lF4CqPY64qkGGh9HQxFDAXEueyHdjTg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HGWjvJ7k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PBIn0Exj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HGWjvJ7k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PBIn0Exj;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780048031; a=rsa-sha256;
	cv=none;
	b=q/5nwTfsr49IgiCYNNrsovk5lyFvxIOqGm5Gk3qtcJP2kXljfnKOjWKm380pgl8Id29znH
	aMfk0U5H1mTHE5Ton8nMQ9FZ7rGxYmHQWXpR6mrxvtVdQ6jchltyNaes+JkcJwFieTqStm
	rMHJMqMxzbYkrfhonGGZ+OXbJEemPL4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B51776AD6B;
	Fri, 29 May 2026 09:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780048029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3Mx7+vtImpwG4SUbS85lLpmAFW5jV+p+rxF61HIx7M=;
	b=HGWjvJ7krjEkXrJgISz6Jki3tMYkNKr1W/Q5L2cQQeTufVF5blzAJVsGARnZ6PKnTiWf35
	J7Za4HjC8X9DiNfW7hJ/g+/Tk/q/B1cUrdG6HgQRNcw1DwniwgbH+9zc5ZApM2um/iR+ku
	d3HjYsQNbEnFe+VcmGVObpsbg7hQ9ZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780048029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3Mx7+vtImpwG4SUbS85lLpmAFW5jV+p+rxF61HIx7M=;
	b=PBIn0ExjslQJyXzZPLnj2gbseuq37EaYuCGteX+fFnPce2Symkakm1vO7vO3STEvux+wcN
	koujOSmIG+w8MxBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780048029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3Mx7+vtImpwG4SUbS85lLpmAFW5jV+p+rxF61HIx7M=;
	b=HGWjvJ7krjEkXrJgISz6Jki3tMYkNKr1W/Q5L2cQQeTufVF5blzAJVsGARnZ6PKnTiWf35
	J7Za4HjC8X9DiNfW7hJ/g+/Tk/q/B1cUrdG6HgQRNcw1DwniwgbH+9zc5ZApM2um/iR+ku
	d3HjYsQNbEnFe+VcmGVObpsbg7hQ9ZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780048029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o3Mx7+vtImpwG4SUbS85lLpmAFW5jV+p+rxF61HIx7M=;
	b=PBIn0ExjslQJyXzZPLnj2gbseuq37EaYuCGteX+fFnPce2Symkakm1vO7vO3STEvux+wcN
	koujOSmIG+w8MxBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56767779A7;
	Fri, 29 May 2026 09:47:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HtzNEJtgGWqFZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 29 May 2026 09:47:07 +0000
Date: Fri, 29 May 2026 10:47:05 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	"Liam R. Howlett" <liam@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com, 
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v6 1/2] mm: bypass mmap_miss heuristic for VM_EXEC
 readahead
Message-ID: <ahlgda3xJ587eSCg@pedro-suse.lan>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528165635.2068012-2-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Stat-Signature: idi3x5d559cehijkcziw64ohtasrjfsf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FDE94000C
X-HE-Tag: 1780048031-640370
X-HE-Meta: U2FsdGVkX18F9nhhExVLZPsbMQyFNgFz9RyyeYNK9rGmMTm4e3SPcVoM4uuxGqRQITNHoXJ4nmV/DbrqAel6re7vQL+aIDeACiu1VfG1bIAZabuLvnr5cPPhw+aMgqTlbffsjeRvl0UDFALsLKmgkKycIYKJChqUBEABfgM+5BHKMTS34tBSoPBLDfUDNnMWR+2KquRU3b64S/QPAjvdZzlvWezAtn/tjsiBxEZFxAjc2FGFCqJq8vwsDEhaZUG4X1BDmMbErs2a+SKV4eY53TTA7pnavdCxbYoSu5kdL+LGBk5gQU3tZymfwoqbLWIhQ56/SRuoZn5wuDWx6KYa3J+eVSL3f71BpxCqpexTuKpbYa10L5yyG+FVoN3nYGo6RLgIeExxIwwTIzbXcUpxq/U1VvGpTlW53KtMa4Wnyk7aZqpMls2+41Mvk/n+ZLH5siSk9RUSPFgBxJriUsxVYNtHVN32VAhB4qsAb5oK3ezw6CeUpTBtGB0VngCTqwzKdCV3dHLr8ThqUdrgpBCpduQ25f5SfqreL3EZ3O1oK4FVKbQZ6yWpN+f6ewrpwkN2Mdi4HeckT0qbfmmQBpaOcJRs9GpE4tPZUDi/9iUZq9Xc7yT1eKrwE7YZsa+fyJVy2y1CBGDq4zX4iYj4+Lj+buvuIlyC5Thd3sSxnajC7JKXtuPdouD5hofCdJUSZpx0OK3STBgco/ZnMi7Tg6r37LxBy2Q2sdn9ZRZqmWjMAEb6NnYon5rbAaK6zIMTpJ0LIfjt1PX4JAOtgfBhYxj5x+K41spdC48/ynOpJWCAM9Oj8qxfaz94vQFVoXdyVMA9+bUsOlgGM8SKIMw0HcqpWaKQ9jNDwmBG6/fyyKmPEXjKzVFxNjZFBMnxVbd18jNSQALLBsmti1inkL6rUA+p04rVauKOKuYggZ5JmzVRxCKbCHJdzDhgifa3wpAS4n7/tLW9JWX3JgOnEBy6+/5
 xiZrN/cJ
 bsIziU3Pwra+HM6fmOWk/RCAoFfRw+H37xScegJl8kR9IMJRV+1MYNqG8SYPHNYoKqLBYxovCTLb8TcBhoBFsLrK6HH+U7v25v0uxBYllqqRL4/J+0nYk0jWOsckO+kqha8GNgEdYSeDHRZxelHjD+MpeNcAQDYFo6QQnzzLbBQ8ErEQ6iB5zHR9OMqN/K33trhGe9JTjYUdwNbD2cnP0nro1mLk6GfGW+tAwH+G8DUwyZmSgov2xK37/3JXPrtZF/mYYhgTXwqoiETtnmUFtHqZkCC8lPNzwS/lc6xeoRAhQ4rDysttmWCgyBQHAFuPM6Gtg8yIlAx9DRTjPhp3VLpiKg1YtzJmIXKvdx/Zw3tZFiKPNN2AcuYw/UvrAod8J8Bz8ttwdLG3f75npS3cHOWQMpfTrDT2isqKl+Ho4Yeh9n6lGDdS3oP6sYh7f48tR5Q6U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:55:19AM -0700, Usama Arif wrote:
> The mmap_miss heuristic is intended to stop speculative mmap readahead
> when a file looks like a random-access workload. That does not fit the
> VM_EXEC path very well.
> 
> VM_EXEC readahead is already constrained differently from ordinary mmap
> read-around: it is bounded by the VMA, uses exec_folio_order() to choose
> an order useful for executable mappings, and sets async_size to 0 so it
> does not create follow-on readahead. When VM_HUGEPAGE is also present,
> the larger readahead is an explicit userspace opt-in.
> 
> The mmap_miss counter is decremented from cache-hit paths in
> do_async_mmap_readahead() and filemap_map_pages(). Those paths are not
> always enough to balance the synchronous miss increments for executable
> mappings. In particular, when fault-around is effectively disabled, such
> as configurations where fault_around_pages is 1, filemap_map_pages() is
> not reached from the fault path. The counter can then become a stale
> throttle for VM_EXEC mappings and suppress the readahead behavior that
> the executable-specific path is trying to provide.
> 
> Skip both mmap_miss increments and decrements for VM_EXEC mappings,
> matching the existing VM_SEQ_READ treatment and keeping the counter
> accounting symmetric.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

This is reasonable, thanks.

> ---
>  mm/filemap.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index cca20e350c95..a16b33e0fc71 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3339,7 +3339,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		}
>  	}
>  
> -	if (!(vm_flags & VM_SEQ_READ)) {
> +	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
>  		/* Avoid banging the cache line if not needed */
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
>  		if (mmap_miss < MMAP_LOTSAMISS * 10)
> @@ -3434,12 +3434,12 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	 * times for a single folio and break the balance with mmap_miss
>  	 * increase in do_sync_mmap_readahead().
>  	 *
> -	 * VM_SEQ_READ mappings skip the mmap_miss increment in
> +	 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss increment in
>  	 * do_sync_mmap_readahead(), so skip the decrement here as well to
>  	 * keep the counter symmetric.
>  	 */
>  	if (likely(!folio_test_locked(folio)) &&
> -	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
> +	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
>  		if (mmap_miss)
>  			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> @@ -3941,14 +3941,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		 * Don't decrease mmap_miss in this scenario to make sure
>  		 * we can stop read-ahead.
>  		 *
> -		 * VM_SEQ_READ mappings skip the mmap_miss increment in
> -		 * do_sync_mmap_readahead(), so skip the decrement here as
> -		 * well to keep the counter symmetric.
> +		 * VM_SEQ_READ and VM_EXEC mappings skip the mmap_miss
> +		 * increment in do_sync_mmap_readahead(), so skip the
> +		 * decrement here as well to keep the counter symmetric.
>  		 */
>  		if ((map_ret & VM_FAULT_NOPAGE) &&
>  		    !(vmf->flags & FAULT_FLAG_TRIED) &&
>  		    !folio_test_workingset(folio) &&
> -		    !(vma->vm_flags & VM_SEQ_READ)) {
> +		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
>  			unsigned short mmap_miss;
>  
>  			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
> -- 
> 2.52.0
> 
> 

-- 
Pedro

