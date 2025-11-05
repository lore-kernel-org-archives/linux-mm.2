Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100CBCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4C68E000E; Wed,  5 Nov 2025 10:12:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6949E8E0008; Wed,  5 Nov 2025 10:12:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D308E000E; Wed,  5 Nov 2025 10:12:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF9A8E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:12:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE7A11A012C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:12:33 +0000 (UTC)
X-FDA: 84076894986.09.C043F5A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6ABAF1C0012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:12:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vOPg+LHG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3fBDLO1F;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vOPg+LHG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3fBDLO1F;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762355551; a=rsa-sha256;
	cv=none;
	b=yGAxEOMODdIeagUylVfbcuYl89TGm0Fn8/J/q85qMDyru2StaLZXVvWkAghED9MdxUcVIl
	dkPfqRaF8NdAC7GE2Rfmc5JsLXtAiCAimBYl6LMDxRR8diHQmGivfSK1XQ4BPGWTRVQLcC
	IXmFTMd5C9H1Ejn3cKjxyO2qWdSHKOU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vOPg+LHG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3fBDLO1F;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vOPg+LHG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3fBDLO1F;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762355551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwBH7iM0sPxUEaHRpT+jUi+gGcVAjv29IOeKwGDaXZs=;
	b=3Ua7B1+0fOuMZaCSWDiAI9Ty1J7xmMvdFxcXwmZgWCc4yqAIZ6h3FKy07/kZRRlH/Llt45
	sCBtIOj3fNaQy4gvAUdyQyw0b71br+IfJuz5QbTeVaqTO2sd8G+ztzbnATDc2wmsZ4DX8A
	bl5TbOHaBkffOZjtzDECOBt7YuJle2k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D37AE1F393;
	Wed,  5 Nov 2025 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762355549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iwBH7iM0sPxUEaHRpT+jUi+gGcVAjv29IOeKwGDaXZs=;
	b=vOPg+LHG7W8Yk1HS6Dsqqv3MuWG2XGmqog16SM/nz7u6dEMJPe3i9AhFhwP/WfJVXmvQcV
	QWH4iMuF1SSTkpoQe/WLl/HtHn4D7b3y2PCeNYRSq3zsRKURpLzDnArWbzFfZtLKKvzbKk
	QuWyoiheskgZBExMQm9+VQqcZ4b5XfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762355549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iwBH7iM0sPxUEaHRpT+jUi+gGcVAjv29IOeKwGDaXZs=;
	b=3fBDLO1F7aXeoa1qyCsw7hVXRdwyz8+2qPyK704dPWdvmcYFcrqpQGEUIV0fpFTM3pjpyw
	BPMYDGJJBtmN/qBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762355549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iwBH7iM0sPxUEaHRpT+jUi+gGcVAjv29IOeKwGDaXZs=;
	b=vOPg+LHG7W8Yk1HS6Dsqqv3MuWG2XGmqog16SM/nz7u6dEMJPe3i9AhFhwP/WfJVXmvQcV
	QWH4iMuF1SSTkpoQe/WLl/HtHn4D7b3y2PCeNYRSq3zsRKURpLzDnArWbzFfZtLKKvzbKk
	QuWyoiheskgZBExMQm9+VQqcZ4b5XfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762355549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iwBH7iM0sPxUEaHRpT+jUi+gGcVAjv29IOeKwGDaXZs=;
	b=3fBDLO1F7aXeoa1qyCsw7hVXRdwyz8+2qPyK704dPWdvmcYFcrqpQGEUIV0fpFTM3pjpyw
	BPMYDGJJBtmN/qBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B30C1132DD;
	Wed,  5 Nov 2025 15:12:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mI/pKV1pC2lFeQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 15:12:29 +0000
Message-ID: <39f2d0d3-de79-4e13-a577-83a3aeb5cf1b@suse.cz>
Date: Wed, 5 Nov 2025 16:12:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] blk-crypto: use mempool_alloc_bulk for encrypted bio
 page allocation
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Eric Biggers <ebiggers@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-10-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251031093517.1603379-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6ABAF1C0012
X-Stat-Signature: cf5zxrx9z8o65sa1cui1y9nj7bbjbqyb
X-Rspam-User: 
X-HE-Tag: 1762355551-249165
X-HE-Meta: U2FsdGVkX1/V58wiDUjGo+/6wnnQFye9EJHzQpvNEOIDOUPfDpfjNMbgRIrAdCErDgkmNkC+EdUe7JHdwR0aIHJKM7OBmF/mQBJ+DV0iuqFr4CajNUL524zmeAoqzKSFy/OhGj5ec21DzsvTCFPDzUhykY0DUO0XzPqGv3kzwYQ9eCgV29DPxQuCLzOFFjEe0cxkYRZAtEbOAJYDMataqJiXANgKVr0HoE6ER3YmS67e6ZfB5EYaRIvZ91mcHDRDbD+EOMSaSYctvDw/h1gfdS6xY0DzRjAgAUp19xlQgf8jFiy21EBhyNHZJKTHenFQffbqoVdKPrJpgLwFEMg2sCAFRgYcLcE4gPEyxEIOtuNZ0icb23ahLYq414g1VTMttH16T9YtOjgSkFgyP1M4GSEtLWsnOUF6Ei/2Tw5EdEUC75aQ2WRND57J6386ez6pjq7XgYiWL0lBx3dwTH/wkXb5H5hH5cA9Np22Usjyx4egNiDpttaQiVhBbXKWuGGzjRu7TLMbEzhPlPtSibb4p0jrFRjleksKWjJrFdO9XtqzPHNocp8AqNNj4hD0y1YPg4jx6UNBKz3ALdZZZrzsCuQPVRQKNNbNwdRzMPQ/9QovAM9m7vpvn0eqUhKtkXSWBWB5mPGzRquJppLXHsh8Os43yWwzzKqxSiRx1cdMfjMNMQyBCYYTztfj3AV01/rXuW9OvJ9A6D9wb9jyj5h1rMQTP+/hyE3kEcUD8yzANYS3prK3GFFl07gQryfS2aOTRl9sxevBzikfZj7+r5cmZ4xru0R/SS7h4va3pkbVNKp2nedlrrz492jfiX20qu6gvRsIIRq60imXvqSBg+6lsja6DICvPcNBSfy52SMVF8+lNJzWAGYfpHO/9zYZk35RWbcNMjbbVaOsAdFhNPpXYXsGa81bDDSEP9XF2a5dEO1KxB2Zi3jFmGZAvfl6KIuZKWgBuUW6plg/pZERfi9
 rrA4ny7P
 IPzkjkM2U8AmzIb52YHsg9pBN0YP61wARXb1vlao7N3+LOV6W3bLmQ2PmMFbWeoc8Dt3qLx/6TG2/9acH6BBrnzyvMe9N4q7wUZtA86UNqeuzEnMb4BloEnWRjEBP0zj5hOEswoIXtvvEcYaYedt30whsUiLxCs7G3sTrhebasBbkC21b9L0CIffbzR02Xl/g7Z0eyQPkpHhFR7J98b8gnxa/OL+fxBE+oimbjViPMO8MABUKlXBiJXI7VCuwSKADYb19HfS6yIo0+Zy1Yd6xtUTT9sOPN8wP1YGgV9FoDIB52QwDcs8THehWV51P2SzGC1kYJQNhsymr0hiNykcZNuXbFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 10:34, Christoph Hellwig wrote:
> @@ -192,6 +205,29 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
>  	bio->bi_write_stream	= bio_src->bi_write_stream;
>  	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
>  	bio_clone_blkg_association(bio, bio_src);
> +
> +	/*
> +	 * Move page array up in the allocated memory for the bio vecs as far as
> +	 * possible so that we can start filling biovecs from the beginning
> +	 * without overwriting the temporary page array.
> +	 */
> +	static_assert(PAGE_PTRS_PER_BVEC > 1);
> +	pages = (struct page **)bio->bi_io_vec;
> +	pages += nr_segs * (PAGE_PTRS_PER_BVEC - 1);
> +
> +	/*
> +	 * Try a bulk allocation first.  This could leave random pages in the
> +	 * array unallocated, but we'll fix that up later in mempool_alloc_bulk.
> +	 *
> +	 * Note: alloc_pages_bulk needs the array to be zeroed, as it assumes
> +	 * any non-zero slot already contains a valid allocation.
> +	 */
> +	memset(pages, 0, sizeof(struct page *) * nr_segs);
> +	if (alloc_pages_bulk(GFP_NOFS, nr_segs, pages) < nr_segs) {
> +		mempool_alloc_bulk(blk_crypto_bounce_page_pool, (void **)pages,
> +				nr_segs, GFP_NOIO);

Why do the GFP flags differ?

> +	}
> +	*pages_ret = pages;
>  	return bio;
>  }
>  
> @@ -234,6 +270,7 @@ static blk_status_t __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
>  	struct scatterlist src, dst;
>  	union blk_crypto_iv iv;
>  	struct bio *enc_bio = NULL;
> +	struct page **enc_pages;
>  	unsigned int nr_segs;
>  	unsigned int enc_idx = 0;
>  	unsigned int j;
> @@ -259,11 +296,10 @@ static blk_status_t __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
>  
>  		if (!enc_bio) {
>  			enc_bio = blk_crypto_alloc_enc_bio(src_bio,
> -					min(nr_segs, BIO_MAX_VECS));
> +					min(nr_segs, BIO_MAX_VECS), &enc_pages);
>  		}
>  
> -		enc_page = mempool_alloc(blk_crypto_bounce_page_pool,
> -				GFP_NOIO);
> +		enc_page = enc_pages[enc_idx];
>  		__bio_add_page(enc_bio, enc_page, src_bv.bv_len,
>  				src_bv.bv_offset);
>  


