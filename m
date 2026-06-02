Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A498CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D6C6B03D1; Tue,  2 Jun 2026 07:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EF66B03D6; Tue,  2 Jun 2026 07:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DCB6B03D8; Tue,  2 Jun 2026 07:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5B716B03D1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:14:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B3A9C2B56
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:14:14 +0000 (UTC)
X-FDA: 84834713628.08.384DB2D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 330DD160007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:14:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CBGWsGjf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ejSlTx7R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tsftKb+W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=laW7hGPV;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780398852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj2dTLHBTtJmxWAHjjC/JAoIXX1S+JjAURhUmTJMA5Y=;
	b=osVA/I3rXeReAifusvuNZiE9ezAIB6egKeT3lbuI29IC3/c8Xt2wT9JgDljKu3UB5Y3/n6
	ZaTDGP4Zg9UQdC4bPFhepYeeS1HnEmgAtr00dUiYnyyu8XYs/t855GDU1l8SnrCHqEspCK
	GRGe+xIHO5bPA57c+n0i3MzlLiurM5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780398852;
	b=JJPC3nMY8uxCQ7QhlZe6g4fYoGwK69oXCa5bUjs76F+MKmcmNOZWnNjA4qyw65iB69SfjQ
	OjbeJoWExUBgyFDv2CdkR2VnQQiJXyPP/ntDBbm74PR2S4GYqj/gCt2cZtcx7es9QhL5UH
	WSOK6To9aQYAKO+syLu0Rrs1XOjb+sY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CBGWsGjf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ejSlTx7R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tsftKb+W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=laW7hGPV;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 622C26AAFE;
	Tue,  2 Jun 2026 11:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780398850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mj2dTLHBTtJmxWAHjjC/JAoIXX1S+JjAURhUmTJMA5Y=;
	b=CBGWsGjfnDxJIyL6p7b7wnwzwF4lPO73dMch8UF/HBIV4nI1QDhY/3h1uf/DF2EIsJXBR+
	ytZiiL/9uB+AboDqxs6f6RTlu9G6/GOwzRVaMu9GAIUXQkn4JhN4ceSg9ni8oFUF9H6zfA
	XcZ+6IOhaSeZmmN92rojJ8PsBGo2HQU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780398850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mj2dTLHBTtJmxWAHjjC/JAoIXX1S+JjAURhUmTJMA5Y=;
	b=ejSlTx7R71Y/OQSYP6ds9AHIooLXhHxB/DxJs4KC/y/9CtuqIbOEd7dJ0xn/4AQc4wldhx
	RD+jQ+02+N0Da5Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780398849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mj2dTLHBTtJmxWAHjjC/JAoIXX1S+JjAURhUmTJMA5Y=;
	b=tsftKb+W7mmTMWmVSkXFsfdsrkKZt6YmLILo8gYUI6/AZotLEy4LJlSHTl/MUgVcbbrp4F
	BIhRvr8WZqo/a+t/DM1DabB01jUX/VFhxYlBhVJ2CaXDlaKso27RaYtjSsvo1hNkuPx7r9
	zKYKCyKfDNy1AUprB8/V4u1FaYrCQ2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780398849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mj2dTLHBTtJmxWAHjjC/JAoIXX1S+JjAURhUmTJMA5Y=;
	b=laW7hGPVyumtc9e2Vxg5ohsWyBGkNz9p0RwIeUUUJmK119/NZpsydZIxRlmdo5nakYxi7T
	i9A+c0usCfSb0PDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 563C2779A7;
	Tue,  2 Jun 2026 11:14:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jMoGFQG7HmqmNQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Jun 2026 11:14:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E0B6EA0EC1; Tue, 02 Jun 2026 13:14:00 +0200 (CEST)
Date: Tue, 2 Jun 2026 13:14:00 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, david@kernel.org, hannes@cmpxchg.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm: make mmap_miss accounting symmetric for VM_SEQ_READ
Message-ID: <3apovyh7kutv5qdo5yrcawqlviaeckuyqoirfk55pjwdkmyllg@ku4xvvpgub4n>
References: <20260525145751.2671248-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525145751.2671248-1-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 330DD160007
X-Rspam-User: 
X-Stat-Signature: 58oczhxgs6qejys1cp6d3x8ipwm6c1t6
X-Rspamd-Server: rspam08
X-HE-Tag: 1780398852-987121
X-HE-Meta: U2FsdGVkX18QhXUTCbc3ZjuxiF76cMBgNaenbPOjBOeXw8orrj2lw50qWEwwaGVzPyjd+y/roJHCyJBghrYTQIpALWxiIiScM72DzoqS2x7tpWjhJn1TLx/vzH0RFfNkIa+zT07oH4z1KbcRyGwaWtM6eAxORdHG+PiqlDGRuQ3qHqZQyt4BnvOhMYMNt4EzjA22MUW9aIm4luJuC+E9YAPJEgG50KjA8muLwUQUxcBsgLrXAzJgxd6jSNrVMyR2IjH46qYZfgiO1WTBUbxw5w2djtEjYC1kZwOBImHNTno/DG/7USlnr4PuXAvfn9PIdY28+iKCFlk0o/OOmgXFgcSuUIhyse+ZLPgqitd+hQCjET+9SStSYar3hVOqriA4/Y905Wx/DBah9348Jz2b70mu0dyc0fWkKRm7n3DTAZ92Rg8UlR6+17iZp76WLQi7JVqrF31Lh/cCWHQgMVdhp8jSUikyGbQfo/XH0kTA5XboX5wGJd9EU1PE9eeeyGqnRMV7/7UG36jGrKePAtTGLYkAQUDH/JRNEa9/JvSURBIwUU4nd1uVfAW4DFJkAFmpQxBmIP9aN19Whamk9mtyKXsO7OXCVrFl9UdULuffyU+qomCNR5mbF0CqQWiXpwgthBGVdMLXBFeCbLuidxvPZzD5LdVjMBwYwR+Of51egQrsGs7RONxRYdIJ2qx8TeDOrYTOeHej6UnK1Xakyhno+RVuuBxDpe004km9RCB2zVpc64w73low002YFdNCWz+L/iGgJeTqzU1cl+iGICYPAzF4oJoGB1BHdSxGJMW5mk1lKL9sQiaXDHVQZxlBCidKHZEJNR2WzjbmR9hOyhbx84vjauTmfMpQD4PTJmUTA6KHGZe1lzFkqqrstTmwA28v0YHNY3MKkm5gvrQdOxT5OL0mQqEorBu4ZD/a5bC13EpccpqEEC2om9Eccz9dIbHrhjksNjcyl/FDFIqCH2C
 teEzLVxa
 pg0is6hVUNTi679nsbE9zCEqGfZq0BCjZZvAM4lMgGIC8B99fZXCDzvBxm0o6TsH7KMOVqG75pa1/6mRYNA7kjaOyzFVbRb9yPBH38Tk8hc7d70OmH6eJMibsDlA9x0DUvFcLngNGLq1gCH1nq6kuR+BvMPlRJP8NDAEevxtJJ8i5wk10fqIe0u1xwQOb6vcbue9vcvvXnyFqPT8DLpGqPf9to8EkrB/dT5wAG56FHYsrSXEPylpOnMLm2QUB6eZAqK7ZbFlAKdq8ATCeeA5hbYSIit1HMbmpt5Q6cfV/GGd7RZDt/EcHLHq2s76Weqo1WgNCIeMzD+LL9S+l58EiTkXgFfp1X+aLE6RbNy85ZS+gHPnW/5Sa++DDvrSNWNv6PQLH6CHNUvVEKwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 25-05-26 07:57:51, Usama Arif wrote:
> do_sync_mmap_readahead() skips both the mmap_miss increment and the
> MMAP_LOTSAMISS check for VM_SEQ_READ mappings, since sequential access
> is non-speculative and should always read ahead. The two decrement
> sites in do_async_mmap_readahead() and filemap_map_pages() do not
> mirror this skip, so concurrent faults on a VM_SEQ_READ mapping can
> still drive ra->mmap_miss down to zero through the decrement paths
> even though nothing in the sync path ever increments it. The counter
> itself is per-file (file->f_ra.mmap_miss), so it can be moved by any
> VMA mapping the file, not just the one currently faulting.
> 
> Skip the decrement for VM_SEQ_READ in both decrement sites so the
> counter only moves for mappings that also participate in the
> increment side. No functional change for VM_SEQ_READ users, since the
> increment-side gate already prevents the counter from being consulted
> on their behalf, but it stops a VM_SEQ_READ mapping from biasing the
> counter for other mappings of the same file.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5aaba0d3e81d..cca20e350c95 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3433,8 +3433,13 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
>  	 * times for a single folio and break the balance with mmap_miss
>  	 * increase in do_sync_mmap_readahead().
> +	 *
> +	 * VM_SEQ_READ mappings skip the mmap_miss increment in
> +	 * do_sync_mmap_readahead(), so skip the decrement here as well to
> +	 * keep the counter symmetric.
>  	 */
> -	if (likely(!folio_test_locked(folio))) {
> +	if (likely(!folio_test_locked(folio)) &&
> +	    !(vmf->vma->vm_flags & VM_SEQ_READ)) {
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
>  		if (mmap_miss)
>  			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> @@ -3935,10 +3940,15 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		 * In such situation, read-ahead is only a waste of IO.
>  		 * Don't decrease mmap_miss in this scenario to make sure
>  		 * we can stop read-ahead.
> +		 *
> +		 * VM_SEQ_READ mappings skip the mmap_miss increment in
> +		 * do_sync_mmap_readahead(), so skip the decrement here as
> +		 * well to keep the counter symmetric.
>  		 */
>  		if ((map_ret & VM_FAULT_NOPAGE) &&
>  		    !(vmf->flags & FAULT_FLAG_TRIED) &&
> -		    !folio_test_workingset(folio)) {
> +		    !folio_test_workingset(folio) &&
> +		    !(vma->vm_flags & VM_SEQ_READ)) {
>  			unsigned short mmap_miss;
>  
>  			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

