Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB0FCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA768E0009; Wed, 12 Nov 2025 05:53:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AE48E0002; Wed, 12 Nov 2025 05:53:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B7C8E0009; Wed, 12 Nov 2025 05:53:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED9298E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:53:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A0ED58FB7
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:53:44 +0000 (UTC)
X-FDA: 84101644368.21.D62686F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A408160008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:53:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SnuugUs6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2g3IQ7Cr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SnuugUs6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2g3IQ7Cr;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762944822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdJts0YerqvsGbnAyfaCLpmo7zmoI6SztVNRu9g+40U=;
	b=t9Z9MVE6Hjw4P6mNnZ5NLJPX8E+iNISSmyXoHHRMtt8LpPBo3bFxN4GLvXdlOrHk17NCMc
	luMXcZnDuXC5hE82xc6Zot/t1/53NtGs+HnVVxHSISA9SQsa0X8aMZcUPI2N99BAcEazt+
	qaXSz/ZfygsmGWeW9st+p25zGV5RZpc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SnuugUs6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2g3IQ7Cr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SnuugUs6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2g3IQ7Cr;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762944822; a=rsa-sha256;
	cv=none;
	b=KWi/3kT9aMrmRl/HugjXxgf+AltQYi1JK+gHRXnIHuUs/wM6Mt0fFv44v0ZjOzO03vFyTm
	DH1YAmQ9Ji/oaejjdYCs4M3Wj4JiLaeqchT7uqVF+/vIqvDb5x9x4VHm8LmDglGsDyzyuJ
	hIayGrxgVzFnIxCyqf2UfkOU7hjV4rM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D4F51F45E;
	Wed, 12 Nov 2025 10:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762944820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OdJts0YerqvsGbnAyfaCLpmo7zmoI6SztVNRu9g+40U=;
	b=SnuugUs6s1i1G+ha+hOQ/OmhxQf1kpNet502wtDhpCQIM046YZQm/kYEr2XO7CmNuNHOSz
	SvWC03cxUvmrbX09Ka9nD06/IQbvmtBaVrGVwwSftI+YJ9LSrW0dk+eaAJzabm5VGcUTz0
	lLqEz1dcNViXOO7Fqc2Kk/SrWgD8GiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762944820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OdJts0YerqvsGbnAyfaCLpmo7zmoI6SztVNRu9g+40U=;
	b=2g3IQ7CrieoVjAWYQ8/aQ/uUl3/ZY61tFT/tLgOfjhUUXCtuznNcjwTCxJuhL5IYeAcXwX
	Xk1BQuKZ6Kg0tFBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762944820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OdJts0YerqvsGbnAyfaCLpmo7zmoI6SztVNRu9g+40U=;
	b=SnuugUs6s1i1G+ha+hOQ/OmhxQf1kpNet502wtDhpCQIM046YZQm/kYEr2XO7CmNuNHOSz
	SvWC03cxUvmrbX09Ka9nD06/IQbvmtBaVrGVwwSftI+YJ9LSrW0dk+eaAJzabm5VGcUTz0
	lLqEz1dcNViXOO7Fqc2Kk/SrWgD8GiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762944820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OdJts0YerqvsGbnAyfaCLpmo7zmoI6SztVNRu9g+40U=;
	b=2g3IQ7CrieoVjAWYQ8/aQ/uUl3/ZY61tFT/tLgOfjhUUXCtuznNcjwTCxJuhL5IYeAcXwX
	Xk1BQuKZ6Kg0tFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A4853EA61;
	Wed, 12 Nov 2025 10:53:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id crmgCTRnFGn5VAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 10:53:40 +0000
Message-ID: <dec19492-bc23-49a0-a2b0-1cd8b5c7726e@suse.cz>
Date: Wed, 12 Nov 2025 11:53:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mempool: fix a wakeup race when sleeping for elements
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251111135300.752962-1-hch@lst.de>
 <20251111135300.752962-7-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251111135300.752962-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A408160008
X-Stat-Signature: 9jbkp46kem81jd65qzqfbethr4fn6qtb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762944821-521502
X-HE-Meta: U2FsdGVkX19wql4fthpeg9M0xrA7Q3UCM3k4B/BztSLKi8/4zTacf+RXfP/jTmVVjaLSd72JRqGrydOyu0xONe/KYUxnuEy5KkwVDDqMSId5tSh5NI9SR9vg8aLIxk47mhDPNDW+5gMA9+nq5LF+yEPdMZfNK7zaIVlCEPSdMTg7RVpLoeBi0FFrrbohDdoUC4xC6Y2CjrMc88Biv/ZkOKqeSuVH8zaFvmbVeDc4Piqb9/a1p9OtElsxhfdyurzs+QWPhEU163Sa6uCgj4ndi07j8hDvrITPErVXxjvopJY1WKu+0/scM76P2lkWkbgK/1cl6PQyV6poiD59bcPaZPaNEAUo+nKla12iws4OTy9zNb9m9jogBgPYiDNnBQ7sXKSKJNa8ALmPYx0oJnAC/8fJ8rl3/xvDg/ydzXOqD0eyIAqE22ILVgLm2YGwg2xD8O7dFsF/4EBgKKSvXKRucvyN7M/WSJlm+fpErQDmFCdEF5u7xIN9WgTEeE8zIt1TiQTJEt/v3sDPt5k4vrGtL96b8PEn9BirWDXD1woy4jPF3HJor+Pr30HlQF1iaMs2Yl2h4zZQb2o8lyVV+VsWtd3v600ClzYtmgFgeQWyDNyYkNSBdeBX3gvwGjR33kLhYTkWh505wVIfg23pwH5DujusOXmnhrk/kJMs1xy1XoId1IGQtgqUD3fEd+5q3VNdX8XGrY9cJQ/AGPzV+lq1BK/kT1QkvR+lh1haYQ2loS5xCMjZwAxfmWLFMdZm2LYaBxrBkYepvc0vBSp29G3opZceMZVX5TLAmoBcaU9HE2mW+GjcOC0szCfiEISMS79Mg1HQp8R68rtnZp7Gva1WPsle+5pAm8onEh5a1/LxYO1D1U0rA7xI20EV/wDsmIafJ/TnV6J/6scsHpM+8UjyR05TBDBKtEH50CEtuBV+j+/VfGvkDfSOLZAjFAQggGmQ7rb3eF1xb89lNRwegL+
 Vc/j+s5e
 p7af6kgKa6aDoqLGa3tFfr/B7V9c/ohlA8x4fFmpl6y29kZ+edT5fBUA0JzYJzftCoHsD9psa5SdlMNQ410Ow4G0Enbi2cNCEOBkDETmMNH1JCW2D2YMzUUWu7fbNo9WPqRrlLO85QgtlEBdjPRkMTec5SupQKfFS2L2m04oWJCx2ZyJC9LQQlxPLNetfjRib4angH1oCmQgZroSv7j7Yi7Oy4GM0ehXq7CvLbSmDrMbtbLirs+dZxoyK72wgxqkBmTCc6pWioqpio33guV0+xEA+Iu4TjPmnpr0P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 14:52, Christoph Hellwig wrote:
> Waiters always need to re-check their condition after adding themselves
> to the waitqueue, as otherwise they might miss a wakeup.  Check
> for elements in the pool and use them before going to sleep.
> 
> The workaround mentioned was probably due to this, but seems genuinely
> useful for other reasons, so keep it and update the comment describing
> it.

Thanks for looking into that historic comment :)
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/mempool.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 850362f4ca7a..8cf3b5705b7f 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -388,6 +388,7 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
>  	spin_lock_irqsave(&pool->lock, flags);
>  	if (unlikely(!pool->curr_nr))
>  		goto fail;
> +alloc:
>  	element = remove_element(pool);
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
> @@ -406,13 +407,17 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
>  		DEFINE_WAIT(wait);
>  
>  		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> +		if (pool->curr_nr) {
> +			finish_wait(&pool->wait, &wait);
> +			goto alloc;
> +		}
>  		spin_unlock_irqrestore(&pool->lock, flags);
I think the race already cannot exist, thanks to the pool->lock being
unlocked after prepare_to_wait()?
The freeing path can't bump pool->curr_nr without the lock, so the condition
you added can't even be true, no?

>  
>  		/*
> -		 * Wait for someone else to return an element to @pool.
> -		 *
> -		 * FIXME: this should be io_schedule().  The timeout is there as
> -		 * a workaround for some DM problems in 2.6.18.
> +		 * Wait for someone else to return an element to @pool, but wake
> +		 * up occasionally as memory pressure might have reduced even
> +		 * and the normal allocation in alloc_fn could succeed even if
> +		 * no element was returned.
>  		 */
>  		io_schedule_timeout(5 * HZ);
>  		finish_wait(&pool->wait, &wait);


