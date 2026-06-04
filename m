Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFE6CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D5F6B0088; Thu,  4 Jun 2026 15:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F73D6B008C; Thu,  4 Jun 2026 15:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30ECB6B0088; Thu,  4 Jun 2026 15:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7186B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:30:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4BC71621D0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:30:54 +0000 (UTC)
X-FDA: 84843222828.04.B0A6F98
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id D64D8C000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:30:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ObOC8E/s";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xX4TZ1Ou;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B49iZUXG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AnHU30aD;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780601453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUhs7nHrVwVahKP19CONWmvueVUZvVfuS2bIUip09cI=;
	b=LGqXUCiiUjz+42u49eZEoACtNEGQo51bqnWWxdJaD15ugiTPk3WyqtEwo4G2gP0vLi8fo7
	6A7C8kXXtSGVIFMo7gmYwQXX8MyaQw+LXecAgRKvZodyURI8hYBRC7F6OlM/vUWjEn6u+H
	6vMNmwitfGcc44i0opp3xDPZABxw+vI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780601453;
	b=SdPFGo4nwCLYgUVUm8BenbmdjhpJruUOr7alYlFjG7Q+Plce/keW/dJNhI986ow09h60WF
	1XCML7/turMfXdfOKkKjjCb6BbTQSUsohYg4hG/XFxueRMoCUd7iaTvSh0bbmYUQH31MSS
	UWz+7NDwWolrP2/vWDWTlMspI/1ybMw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ObOC8E/s";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xX4TZ1Ou;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B49iZUXG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AnHU30aD;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 464576B059;
	Thu,  4 Jun 2026 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780601451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qUhs7nHrVwVahKP19CONWmvueVUZvVfuS2bIUip09cI=;
	b=ObOC8E/s242xs8rtpTwzGe9x012+MvEF7x7lQ/QR6XNWcecL57OHhrtEeWyPsgfJtouwRm
	r/n42gf9UvuYj4IifaJnQeipfVgy1n/hZ7i61vVz/u7Txos8K5VRPBinNolwzswD7pdZGP
	YpDCiqRQZOTcXzEL4wHJ8e8d2EVsuuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780601451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qUhs7nHrVwVahKP19CONWmvueVUZvVfuS2bIUip09cI=;
	b=xX4TZ1OuGwffZQhiUWMU1DTM3tnSvWvkm1rBX7PCU4Q8hfRmnKjirqbGaF1vpkFnnuitz4
	nO+jU2qDW+3uXKAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780601450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qUhs7nHrVwVahKP19CONWmvueVUZvVfuS2bIUip09cI=;
	b=B49iZUXGW6b652AdBBs53WABYQQo1Bm8iuEVubc5CLhv/8Ln12qK/PewKxT3ks07cc4uF+
	XO0AKg+pBd4kdBET20ErmxBMU28d3CblKOW3xFJQyhz59r2RADADOBIwfdUVluvGoa+XfU
	3Ij6F6sgc5OJmnmrbkVt5HNnc8J8sgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780601450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qUhs7nHrVwVahKP19CONWmvueVUZvVfuS2bIUip09cI=;
	b=AnHU30aDHDytjj8TvaarlGVKqeukhTSpUIVKkDU05ex2/Yq+QWZvQ9FwxAjxVaum5/Ln85
	xVYzWQntN/Jy31Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F15B1779A8;
	Thu,  4 Jun 2026 19:30:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w/EYD2XSIWpsEQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 04 Jun 2026 19:30:45 +0000
Date: Thu, 4 Jun 2026 20:30:43 +0100
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
	Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v7 1/2] mm: bypass mmap_miss heuristic for VM_EXEC
 readahead
Message-ID: <aiHR2GIhaAh_9ycw@pedro-suse>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
 <20260601102205.3985788-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601102205.3985788-2-usama.arif@linux.dev>
X-Rspamd-Queue-Id: D64D8C000C
X-Rspam-User: 
X-Stat-Signature: w1rcko3cpm5z6ee3omnxeujpt1wuw7k7
X-Rspamd-Server: rspam08
X-HE-Tag: 1780601452-795091
X-HE-Meta: U2FsdGVkX1/8YwWwKasg0w7AHSKe+6zBAGvu7+CJYQYjXHvROpv+VdgL7QxehsRdHfYDP2LOdJKjMsjoMQkg41TBgG5K0MD9y3Qc8Miw/CLwAr557M3M5RAf8ZwcW+yrb9aMYg/xcuwZxnN9Hr7YAhcOk8VIhZEO+3EgNaxkW3CnuOkhM1xdg2l7DFoddfijp4bYYXm8b4seoGUPkR2mNaVOrYhtVulNPvwZWlN+XwEchaEMSlfFEAme6jqYH2C92erJuRJ8LlyNpDhnLh/BgxVOW6smot1QDB1qKBBJjLI6LXFb3gUAOIEJoxzncA5KrnYeemy7xQ6hGSMtUrZ53LagXEmUdEvI833gu2I5NUptK3loqp9USXAHwMQpsqMTSDzo/f/v2Srn4yHQFf7o3JE26sPsMwYqoQER6++BHJqZcsAZR0z6TJib0j0A6RVh5irvDBxVvDLMSezyuo9sLDveCL4qaNTozQaRWe9qjeWk33Igr4lj3cnAfYz3pBqHZVzVETsbzsJjGFtURuo5vsBQuktqa+Gj7BnNvDg8oU0rA1ApBKz4amNWQY+5x0G0DfOnSGUtjl9slfsUGIDFENQcbD1Of9jMj7IqQJv+3PQ3ou/uIjXP0g9eImrFHehTZNjI+SD9V3QPg90oOjXUCNFSY739PsZlWyW0593MjBqgGie4Vrivixjyl6g3g2p+07TmqUUY9PDDWWp4OfHw7KdKnTa7NFv6aDicZbmYsrUo8VGYv1e4EwUJFtCeyXp/wsq7Pxuyh4DVEA49XX6ijONK10NlTnT6e7LeBZF1jLLL/nMhXxeleU0wkpFy1w3CXXJIGg2AujmWRbwJD988rfrUTdwkhnzU7LpdMtZtyp1h+WN3i+1GRDlvfXuFOLOz1nDqffkrbNDEFW+ygxibBgvBc/4pDhH1Tb/F24JZavytu+q/CBLnLXx0wNsduE6yTDClF3d7SmNbkoQlFVx
 YK667vYZ
 pYs43IsU4h5g0FrMWNGbVI8U0Fd5ySHPFmUVpysx14dE0wVBbRZRSwIUyasgh65Mqtmlin/FzPE/tPC9hdwBq6sMCS7IGzplTpXVerxJ8Z/Auo/8ZwfVtfTd57cdCpmSWpTO1TtMLyy8xbOcPvV+7wPUJTzzLJ0J/HDvisbdTYmQsiUzGQYOc8Iw4ler4C0s/TLnXi9FdHpbseMg3uu9FBTg+zyTi+ilW6A5yvbLEv1s0+bs6P99WS0D55sLVRJm+iaNuuIWtMadQgLKD7IAV0nYbGnBsoOk5Cqsb7SqKZcH9KrvXrabDPkF73pWpWtd8vMrTGwPZ+B3nLSPHpDCPi5JDd4TCAmsQp93uP6W3biidbsjTeip0CMSkOkGD7y1S8ZszFIXki0VKSK5dKKxhTmRspsh4nJnKxuWgN4EZl83KeKGy9ztUBYu+Xx0Svquvgygf4aa23L6gVRHqY2zs2TwSRHEc8InKR6AHxcoi2g+cgRchxpi6mhaUBTemIcbyiQmlLtRxgcSzCi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 03:21:17AM -0700, Usama Arif wrote:
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

Just a side comment: I really hate these adhoc criteria all around
filemap/readahead. One day we ought to actually write things down, and
write things in a way that isn't entirely mysterious. I might see if I send
a patch for this down the line...

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

-- 
Pedro

