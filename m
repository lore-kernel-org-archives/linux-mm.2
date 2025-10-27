Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 247E6CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8566780080; Mon, 27 Oct 2025 14:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807508000A; Mon, 27 Oct 2025 14:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F62E80080; Mon, 27 Oct 2025 14:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF078000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F220B139F56
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:03:06 +0000 (UTC)
X-FDA: 84044665572.21.F991C50
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8AD2100015
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:03:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=exbRg4+J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LxTCIe5O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=exbRg4+J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LxTCIe5O;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761588185; a=rsa-sha256;
	cv=none;
	b=IR7bPPUsVjwbmKgDHsZA7JoD7q42Fsi9srEIs6gCUeaC7Zf3l4vmJ5os+iEh/qJHS6XUpg
	bhKL4A0gfJv5QbBGggqvqNb9qbp3JMuyXF62PFkpr09denkuYI0jnnlMox11fxBh/Dm0Gq
	mEfdf+6R6z4wzR7L0yaGXMcsJc+FNGA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=exbRg4+J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LxTCIe5O;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=exbRg4+J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LxTCIe5O;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761588185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jk5+m10XlK1s3icZeuaHrY3mStGnMyLsBgtxjhMazEk=;
	b=Ete5b16jFuEfZ3mVW4cbqd1FoSGZU/GTKXoBDMvwfuQcCRjjIfr48FAc5h7lobFOcq8xj1
	J4rhsu1622WEkZY08EBdD3uItliFJ0vofp0Ccr5saUzMAHu6tPInMHzwOTc0Dp+UXrFOIz
	B3P56WfuYAf4fSzV8lfsmHPVtLfLBOs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 318C621264;
	Mon, 27 Oct 2025 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jk5+m10XlK1s3icZeuaHrY3mStGnMyLsBgtxjhMazEk=;
	b=exbRg4+JajOyKu+vxkCJrht6n4UXAMCtAbE/QyEj9ZO7oZ6n2KBrROU0xspGwJ18Ri8rGy
	NPlQUM0CEmF5HLQOhj05LmSaQimV0NArMxZpOzRS3MpAUKB2tAovtr9SBSu+DU6AWbwqvl
	cu096xCA1cGiHfN03pRPNkZGFo9VMYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jk5+m10XlK1s3icZeuaHrY3mStGnMyLsBgtxjhMazEk=;
	b=LxTCIe5O6mGFJi4IJNwYoX/XRcHs6MTWn/nepjdY8XtUxIZCX42VHoo29HwS/MQsbtN39N
	+u3D5Fd+ofzEHPAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jk5+m10XlK1s3icZeuaHrY3mStGnMyLsBgtxjhMazEk=;
	b=exbRg4+JajOyKu+vxkCJrht6n4UXAMCtAbE/QyEj9ZO7oZ6n2KBrROU0xspGwJ18Ri8rGy
	NPlQUM0CEmF5HLQOhj05LmSaQimV0NArMxZpOzRS3MpAUKB2tAovtr9SBSu+DU6AWbwqvl
	cu096xCA1cGiHfN03pRPNkZGFo9VMYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Jk5+m10XlK1s3icZeuaHrY3mStGnMyLsBgtxjhMazEk=;
	b=LxTCIe5O6mGFJi4IJNwYoX/XRcHs6MTWn/nepjdY8XtUxIZCX42VHoo29HwS/MQsbtN39N
	+u3D5Fd+ofzEHPAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A8F3136CF;
	Mon, 27 Oct 2025 18:03:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zAnnBdez/2g7bgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 18:03:03 +0000
Message-ID: <fa1262ef-4960-458e-bcb7-2da16e385435@suse.cz>
Date: Mon, 27 Oct 2025 19:03:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/17] slab: Remove folio references from
 build_detached_freelist()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-11-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-11-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 5rwy8g7po6zx9t84kxba7b1jgtf9qmgd
X-Rspamd-Queue-Id: B8AD2100015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761588184-493649
X-HE-Meta: U2FsdGVkX1+NQB5VMMFz0CbF2ttlSWjZ/u8JBiWYxBOWuxDB6DNPyYI3mFtsh3YwocAB4JgTXvNfCrNFXMF4oOxIm4Rt3diQzrFL/K5sRHQon1h5URk2e6u+HUhqNELbB2UeSyNo3jjxkVEbM0WSgpaZOEjjjolLFMq4o3cp43rW1rKbEkP3T4SNilwYKgvLEqbzxTXLnLRR0Fv7gy4JTYqVdETJawr+rS/tkZIYKu1Ox1UxvfORmNCOPffrPi4XLRN0CzSmm7eRkdxufrz2EbGsI4G69ljMy4VrFvj6LhXRtNMWQ7zWl5EPqn4k+E8D3S4NOus5LrkScE5C/i3GfrciOMi4bVwiE0ovqG2z7BCSMMhjTI9hjJDlpkBCo70t0fql7FBu4+q6TlE3cEpRpMnawJQXfIlKDpR72ZJjNm4d1PGjK3fGFrLgiDHgGB29c68NUx0McVY/3Ya/NGq5kzdZf6oSkZnFvC6P//pa/EvmKCze9zVJwsyAW6qGPZHmS4T3hjVJS5Ig1BEQn/iooEg7Mf6ZScXldhSZ3yJxxqdUvQIIp8WbJdvAXKlHkjXW9tTj6iF6LaqFTbuxzCRQzqKqEkPXrLKoYTK/2CJD33WRnSaZhIQnsOXq2lcp/frevZnud3maKrptRIzYo1R4pLP0Dj02NGPDoQmIgIfI4c2kBL2ZZXIuQs5KGG8QS/VNeIu4qdhPvl3yzXaVDKMx29EIsjNTBFkV8CW3jKfQBct8N0yE507k1pMC7xDv5Hg2ofk2TNoCGNTzpdwzErcZEjYVUPwhalyYK0nxcFkbNUsFuqVEhmj6jjbRQrcqSobCD8yBpg8dLfLqvwfnRmU1MSAVsxFnJSHU1GnQzUtRtsl1eN3gsl45R/LHz2fQfn1/3xl1kiS/d9C4nX0oOmtYcrMRKNbinMah26lxCoIWGl+DUF0Ycw1sv7VSNklR8pziLJnzR6KnDmD+DkrTcZP
 QPB4KuS7
 8Q632+PZv6oGbqoc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> As with memcg_slab_post_charge(), we save a call to compound_head() for
> large kmallocs.  This has a slight change of behaviour in that non-slab,
> non-kmalloc pointers will now cause a NULL pointer dereference rather
> than a warning.  We could add that back if really needed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Ditto

> ---
>  mm/slub.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4e282e7782bb..e72016ff0236 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7244,23 +7244,23 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
>  {
>  	int lookahead = 3;
>  	void *object;
> -	struct folio *folio;
> +	struct page *page;
>  	size_t same;
>  
>  	object = p[--size];
> -	folio = virt_to_folio(object);
> +	page = virt_to_page(object);
>  	if (!s) {
>  		/* Handle kalloc'ed objects */
> -		if (unlikely(!folio_test_slab(folio))) {
> -			free_large_kmalloc(&folio->page, object);
> +		if (unlikely(PageLargeKmalloc(page))) {
> +			free_large_kmalloc(page, object);
>  			df->slab = NULL;
>  			return size;
>  		}
>  		/* Derive kmem_cache from object */
> -		df->slab = folio_slab(folio);
> +		df->slab = page_slab(page);
>  		df->s = df->slab->slab_cache;
>  	} else {
> -		df->slab = folio_slab(folio);
> +		df->slab = page_slab(page);
>  		df->s = cache_from_obj(s, object); /* Support for memcg */
>  	}
>  


