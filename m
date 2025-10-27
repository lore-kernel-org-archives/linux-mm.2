Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AC8CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A5B8007F; Mon, 27 Oct 2025 14:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1928000A; Mon, 27 Oct 2025 14:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0718007F; Mon, 27 Oct 2025 14:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1448000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:02:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B78E814020E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:02:01 +0000 (UTC)
X-FDA: 84044662842.14.3A5B3B3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0CB7C80010
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:01:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dPQ8HV1j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Uxeba3W;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nB8zTDOn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9gbpXbnr;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761588119; a=rsa-sha256;
	cv=none;
	b=cBQ6Ac3Qc/ok4v2zVQqnyAxaoJ8tESiGSNv5f3HgRrFX2Ug7C1/l6Yr3X09IPhjPpLBMze
	Z020S4rDjJk6tDX6+OuD3uQj7jvOqVl6hraoYHfvQDhIGeaakZvBR+FZ2AJqDSiWZ5I/j+
	SCrdizyzgZYUXjt5UBc7yT6nBMGx/1w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dPQ8HV1j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Uxeba3W;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nB8zTDOn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9gbpXbnr;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761588119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3I6GIs3odhz9yYpU9aEJbTFTyNdZKSwTGpYgZXJ4OAc=;
	b=lUWll+HFhSpSVZ/1vsLdulN8FmgHG9vXO279f3uMTZ4K4jaRilEo3tOCRJm/rtvORfjWoM
	3ZdndFQOwmtnUHFQ8MNZnzr1GfNiBQ/qJ5rtu8I234tOgBdNsZqB99GEbvmCujSOcLHOXn
	3xddBkufeM8OWoL2Nj8pigOy0yQgFJs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C11821A3F;
	Mon, 27 Oct 2025 18:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3I6GIs3odhz9yYpU9aEJbTFTyNdZKSwTGpYgZXJ4OAc=;
	b=dPQ8HV1jG7PtaIKHeqqLK+v4Ei7Q2g/owaIxTQdJC7wQw5Q+JcGDnwsh+kNEoFhBOw/Ly2
	wMw4PIyxlihsd3IOqPW/rXd/dPcpNSBLvXl2EuoNp55H9dqW7yvx1A12zLal/fdwngre/l
	jM/wC+7QB3IBPKB599S/tM7mDdZJ4jc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3I6GIs3odhz9yYpU9aEJbTFTyNdZKSwTGpYgZXJ4OAc=;
	b=1Uxeba3WAR8QeOifDOxAl3EOQV2S9ak6Qec/mfeuSWDO4S5iY4rCe2zsRo6vN9hFE/hSGF
	n2vIutgCLXcWXKCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761588116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3I6GIs3odhz9yYpU9aEJbTFTyNdZKSwTGpYgZXJ4OAc=;
	b=nB8zTDOnTI2Qaef//GS3bcbqE4Ib1cksL1x+b/kpiBr5IB3glHejKcGQcKPQsBDhHqYR6e
	BN9uUDwgaNI3WJEGMSHi6f83v6/FfduPfRp8qCeiwXFL33UHevzcvGLD+4vse54KPCbcya
	ym3wF/1lMW59byjsF44QcPEtjNJGMAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761588116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3I6GIs3odhz9yYpU9aEJbTFTyNdZKSwTGpYgZXJ4OAc=;
	b=9gbpXbnrNzc7ETd/pXIM/gyhWIRQGbiKafg2Jsey8GW0Y4Dkplsf4DTIiODczxB4W0O1F5
	DI2Q+bUnpVUzkoBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24D5C136CF;
	Mon, 27 Oct 2025 18:01:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNa/B5Sz/2hmbQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 18:01:56 +0000
Message-ID: <aeccd94e-50f8-4c9d-92fc-404a6091dc29@suse.cz>
Date: Mon, 27 Oct 2025 19:01:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/17] slab: Remove folio references from
 __do_krealloc()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-10-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-10-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: ngoukw6shnqiqd7xn6zq8nzwq1t3rtmf
X-Rspamd-Queue-Id: 0CB7C80010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761588118-432318
X-HE-Meta: U2FsdGVkX18DkASEEDZNDVB11OJcGjSAwE+4aZJNcRqyG3rm94Jhdnxod5GXDFYrZoj/J8b6kalRI27ISagQHgC8Cx9wcH2xsfcoduANrxoYJ81Jl1yX82oRTvxgAb/10eAzV0O5Dai18dG0MOpNZJkrESFbLSoKszB+w24Vz1mmOt4n8WaFUy4YRThW6ZQMOGD8cAJgtNtugbIvrh+89LprhWa25dVwU5dTZ2AtvcB/zDntoWr+gqA52vR6NfFyq7VBVzDfdTDN5UqLsKszY1PT3e8URVI3d67mAoD/3F8huvHYSxWsmjvkQnBELfXWhG/gsBoKT328DM5YGilx5rvqkHJXs+mxDD5dcBaNb2JU3i52sTpnNDqVy963gZ49xFY67fPHE97qkkOcYYbh69lJLgpCDVMzSmMA0HWh0N2eswYEIZemBZexkoXh+XgP8NQzrUTlWRyu+u0jEoR1XS/ixwOdP5iNF4oOkGaiXS5GHx30MbaBdH6rYr2WI0qUYEWsG1+aDiaCn5nVkxDT4lcF0x2+IOWWT/au/PQEcrstp+RxlM9TEcqoVButG5Ama+t+oU5MNVuddtIQ0c95SRGiAmquutfrQ/rw/eDUoop7bGi5uJqgDXaKLE5SOqp7senqt2M0xB7xewRDc47ZmPqxKQz5U7xsqfCKXCg3cfw6CBmUMZA1cU7OINqGWb7qpG/UMYe9xHWWMzmPV46TJipDSvmpz78mwJrt5cvAr57r4bVJy0jd9jaFtvXVrfXEUWWEdXWlC6cXeam7SHmKGENpKk/0VSeNHm74O9V2kohyCiyD2uuQNRhjPkzmGAI15OPQdjFsWkBwZvXDL4WU08w4RdIO+okYuY8Zx9G1v83u4ScwtLmRcy0h5YvKip788lljpnBzESxKLr8di1Kqw3JsCBqwJxDxN+/P+4B6nME3HnL7pF1yLLeecfoFyydelLi89Llm+GdSH7YIhP6
 gDx8SPNg
 y2rYYQobj+WO1F6jEcZhljIFGNqJfY0831tzrtb9QVSkhuZVHBuJmBj0pM69PqPFwEENRuAFRqXcV7ev3Rj5WF633pSH+PkoKYsyTOrwpUrsr4cyd/9Kzcehw/0vIWiOOWP2wjebaDmy1Q/iyR48ayQbSMohV7lrU2lvVcDB3zww2qwxGNbzXWRdlR+cAmE0nFE2H9DpUoXZJ4ST9/CGF5oRn356bzq1c/ejvnsKDjIrZNiNIPuG1ufpEVWGuB8VIZ2ZzyCooIVbJSlLtxWMDlNKLzMw4uqBASF2zyNEBXEewou/yv3TSgOqTWUoqmdMXeCm85pMZtIgUGXHaNdNb2Ca5Io3z7BbyZ5r7IXKnVxOfFMloFCSeQJf4zFkjGKIMfICRA3xZGyxF5og=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> As with memcg_slab_post_charge(), we save a call to compound_head()
> for large kmallocs.  This has a slight change of behaviour in that
> non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
> pointer dereference rather than a warning.  We could add that back if
> really needed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

This would be another one to change for consistency as proposed to 08/17

> ---
>  mm/slub.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 100ed979312d..4e282e7782bb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6924,16 +6924,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
>  	if (is_kfence_address(p)) {
>  		ks = orig_size = kfence_ksize(p);
>  	} else {
> -		struct folio *folio;
> +		struct page *page;
>  
> -		folio = virt_to_folio(p);
> -		if (unlikely(!folio_test_slab(folio))) {
> +		page = virt_to_page(p);
> +		if (unlikely(PageLargeKmalloc(page))) {
>  			/* Big kmalloc object */
> -			WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE);
> -			WARN_ON(p != folio_address(folio));
> -			ks = folio_size(folio);
> +			ks = page_size(page);
> +			WARN_ON(ks <= KMALLOC_MAX_CACHE_SIZE);
> +			WARN_ON(p != page_address(page));
>  		} else {
> -			s = folio_slab(folio)->slab_cache;
> +			s = page_slab(page)->slab_cache;
>  			orig_size = get_orig_size(s, (void *)p);
>  			ks = s->object_size;
>  		}


