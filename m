Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D55C79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A84B6B0197; Mon,  5 Jan 2026 11:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F226B0198; Mon,  5 Jan 2026 11:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E686B0199; Mon,  5 Jan 2026 11:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 167A76B0197
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:46:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE0151A01C2
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:46:51 +0000 (UTC)
X-FDA: 84298489422.28.938D932
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D17B2000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:46:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1/1r/KF7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vfZrxLdI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1/1r/KF7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vfZrxLdI;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767631609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BbgkS5ORMgbzsoj2tJDrX7KFBsx2OdqqnsNHutRsfE=;
	b=QiCsY+Ls2bj5LAR/R+jhgdNxHd5RFVIjZiL3SBoUadgVMdMqC6uv74/N7vl6eBzwCC5mzi
	ckZ5hxr/F4MgR8vP3xsylfmpeZfwdyi0BcJ9LoP5TqYkEpTmf4y0wOZp1gtQ4HZy0WzYMA
	6AYKlxKTfeeVnNa5n8bIJr/z9eVhlBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767631609; a=rsa-sha256;
	cv=none;
	b=H4WDBcfgEsU7IGwRZfNl+2aMpdQosIwGtCdXNnl4NPSEHZdcBY4fMIv+u9o3qXEzNuexE+
	S/Mhx3sf2XsrmCman+f0WWKoXg8HESRIAWHngLW180K2JoG+bYSq2f9VYlxVyF5PJIyx27
	B7loACZeRYwgzbZ4Q725kZbtlS+5xgE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1/1r/KF7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vfZrxLdI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1/1r/KF7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vfZrxLdI;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E6245BE55;
	Mon,  5 Jan 2026 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767631607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4BbgkS5ORMgbzsoj2tJDrX7KFBsx2OdqqnsNHutRsfE=;
	b=1/1r/KF77LaFMblOegPQzp6XEbWTywlB+yXrwy2s8bDmm/fObjJTcqm4LV7R3NIG81P8Zx
	ao36vdPaySDYzXEP9yal2Abg3IoNUWGqjY2sJAI2GGbLhNZKkANXZJ7IQo3PZFaTz77/vh
	RsY1a8eFYacr4j5k9ZwZE59tDe5kWnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767631607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4BbgkS5ORMgbzsoj2tJDrX7KFBsx2OdqqnsNHutRsfE=;
	b=vfZrxLdIhw6Rsg4TkdBySiHceCw9wNh9VSKow51U8lXMWPgjknb0pnTwGkPtGJxAvLY4Rf
	t/zZCy8iXHG2TpBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767631607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4BbgkS5ORMgbzsoj2tJDrX7KFBsx2OdqqnsNHutRsfE=;
	b=1/1r/KF77LaFMblOegPQzp6XEbWTywlB+yXrwy2s8bDmm/fObjJTcqm4LV7R3NIG81P8Zx
	ao36vdPaySDYzXEP9yal2Abg3IoNUWGqjY2sJAI2GGbLhNZKkANXZJ7IQo3PZFaTz77/vh
	RsY1a8eFYacr4j5k9ZwZE59tDe5kWnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767631607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4BbgkS5ORMgbzsoj2tJDrX7KFBsx2OdqqnsNHutRsfE=;
	b=vfZrxLdIhw6Rsg4TkdBySiHceCw9wNh9VSKow51U8lXMWPgjknb0pnTwGkPtGJxAvLY4Rf
	t/zZCy8iXHG2TpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 713FF3EA63;
	Mon,  5 Jan 2026 16:46:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7JpHG/fqW2ltIwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 05 Jan 2026 16:46:47 +0000
Message-ID: <07c4f991-ae41-456d-8e7f-287bf8676c9e@suse.cz>
Date: Mon, 5 Jan 2026 17:46:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
Content-Language: en-US
To: klourencodev@gmail.com, linux-mm@kvack.org,
 Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org
References: <20251223231054.16061-1-klourencodev@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251223231054.16061-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: duhfron33ytyu58kgaf84t1tgi69p9eu
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D17B2000B
X-Rspam-User: 
X-HE-Tag: 1767631608-684069
X-HE-Meta: U2FsdGVkX19DgjMqf2GOwSXBG3XYnWHbMDDwb6telSwFcWBhLuaTfsb2lFBFPwF43ZeDuS6ioWnF6iDyWpNUUlLVfLZuMdRn08kLx/P+OFxv6bUo9HFV0eN9MXs3+hg5FczjL3G7EWxbn++ouVIK37D0SafGxq82F6pLMK+4LE+UbMHEParzJZvkjDcpofmSkvA1kwZHWNR5pJPug3u/hYHRpiTDtYVBmLT3hHJ6CJaUiouBEFM3pI5YlZxQQIRCRQFk+qApvbibb7dxBTaHjmNTAklSfVBgLwk7sAsXyhszX+9YAC8vbRc4joeIOVUckex6WUX5+H/wwbn4xZDBvmc6JhJyju7e/Ts2lGA/q7f38LSsNGyhzsOEkgV2l06Hf2OO9YY7ePsPxx2rf3TFbKmHfhK5zdT/4xeK7iL3rA1CbHmV5EGh7YWXRtzDCkwP07fPckXCgPIIFoO/FItRpkVCUMQFWDKBbqu2FDWC+eAFiTrh92cAyVYD5kY/6NVJpEvRbBOhyERlVfj1dnV69Myt/6wDuQx81rcZuGM7BOG4NQwhz5/ghqQLj8Q1cRMJbgaNN9Nw/EBDs9NICV8hg31jXKpZyjPxLDimOcw9F/fUEh3iBONSEHsjzO5UoZ7IEAhP85FVdqRW2kxnYuqXxEkXEHbziZ4ZOgqcwVLJjBEdqvObNDBE1L+rn/CgEZVSbcu3pRU+yUwq0I+IT+NQHYNHU6kku4bN1KhagfyO5K5FWViIjKwQANXs/56/yGJrTi0bRHqiu0JtZuBLYQlULS4u1EpYTcfngTmnRTlezlnr4VAjacwL8aSgbzEOb3RkWBVYU6GiY7X4qW1etJtwMiPianzNHmBJe5eg/LfrK/V8TLbmX+U80be4BCNPbqVbJzf1HQGqruui4qR8IQJ06gkHlf/I+p5XWq3HOzTM+IN22ubFZicIra5dAco399BdENCNS0VnDIrk76vq1LM
 8l5SEDsL
 i2IWmRzk6Y/hCOn/fDMZOplieVTEUWuJN84L0GGKWZdNl7YiI9D5wPNJGJJ8dwNhUHyMFyb4g+DbL+cCcV3FZiHI/6pt0Eod5iZJ6tIkTia6+j0ZvgbTdeM2pX7QDKjqk3lvM6hIuCvYaw5jtmYQN+kCxT+Z+t11YOAR5qb2RPh9/DRq5awbpZfjToGhjIG1AlENIyeagqwec4H+awC4a+VAXW3anu2d8HXTKt+X8UNnNg1BrrJaCVfeOoyJKqn5pHHQwRHulnbQO/rIljWbkwaII7AUhTC5Bha4A+68Yz1UE06tej4CwgBIT5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 00:10, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> This is documented in the function comment as "...and sets their
> slots in @elems to NULL.", but it was not followed.
> 
> We need to follow the NULL assignment, because elements newly returned
> to the pool must not be touched under any circumstances by the user.

Well alternatively we could update the comment if no user needs to rely on
this. Since it was modeled after __alloc_pages_bulk()/release_pages() and
release_pages() doesn't do this, we could also avoid it for perf reasons.
Christoph, what do you think?

> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---
>  mm/mempool.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index c290e5261b47..1a2060304fd4 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -674,7 +674,8 @@ unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
>  	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
>  		spin_lock_irqsave(&pool->lock, flags);
>  		while (pool->curr_nr < pool->min_nr && freed < count) {
> -			add_element(pool, elems[freed++]);
> +			add_element(pool, elems[freed]);
> +			elems[freed++] = NULL;
>  			added = true;
>  		}
>  		spin_unlock_irqrestore(&pool->lock, flags);
> @@ -683,7 +684,8 @@ unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
>  		/* Handle the min_nr = 0 edge case: */
>  		spin_lock_irqsave(&pool->lock, flags);
>  		if (likely(pool->curr_nr == 0)) {
> -			add_element(pool, elems[freed++]);
> +			add_element(pool, elems[freed]);
> +			elems[freed++] = NULL;
>  			added = true;
>  		}
>  		spin_unlock_irqrestore(&pool->lock, flags);


