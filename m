Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6D9D340AB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BCA6B008A; Tue, 27 Jan 2026 11:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8001B6B008C; Tue, 27 Jan 2026 11:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5CC6B0092; Tue, 27 Jan 2026 11:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0C16B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:35:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 021F9140238
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:35:55 +0000 (UTC)
X-FDA: 84378295512.28.9DFD0F4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9710C40007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:35:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C9LNtLRM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIbSkU58;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C9LNtLRM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIbSkU58;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769531754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bESVhnuM2/JGiUI+4dFhJMsy3Jx63pH5+SvwI6o2Tpw=;
	b=0pVT6P7ZQQA08F6grVXMtUAgmu7WmxP+PF8CwZsiq47N3hPclZWRP7yQRvuxMdpjjGJd1f
	nNtmR2zTc028edwL8PBQtegLFmTaXh9sa8032y9dO5+b2wfXefdW4F0E6qKZUo+9D/D8tu
	QqrifDUNSLULx1eAsBwyYhD7vSJotIo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C9LNtLRM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIbSkU58;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C9LNtLRM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIbSkU58;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769531754; a=rsa-sha256;
	cv=none;
	b=ktWe0jJV+7rZeRfA2I14jlY7/B9FQM3TjJnK6nxX0ClLyaC8tTyAcbF/YlRzzMXDJQ6WkC
	+bXmuPGn1u3xo7SX+1lt7o8qYFQ4uXiTIKIfL1reWhW6jJhOyFqdm4cStfKJKKFgpkbI1W
	8woYH9QjLPpC5H1aHTzkzJm6jgXlzTw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73023337CB;
	Tue, 27 Jan 2026 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769531751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bESVhnuM2/JGiUI+4dFhJMsy3Jx63pH5+SvwI6o2Tpw=;
	b=C9LNtLRMKZ5QsCBKg6+/+1vSMyiEzKCV/a/YZNpS2mi5p/JG38MJUe56eRSbdACFcqIvGp
	Ji6miZyYifaanPvwmQDXbg3pOKR5RLf2SLFRoWJgIeKg5o2zocvpwq3eo1yNztwYmtpuhM
	qC4xbrJsvkY1Vvg3H1MtjbhGQq1U+Qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769531751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bESVhnuM2/JGiUI+4dFhJMsy3Jx63pH5+SvwI6o2Tpw=;
	b=TIbSkU584Bl0S/ISqttDbVL057X5n1a+GF6+wzOp7KQ8JPEMO5QJd2odcJxXWgPf3DjipN
	lfsMDfBNWiBa1OAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769531751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bESVhnuM2/JGiUI+4dFhJMsy3Jx63pH5+SvwI6o2Tpw=;
	b=C9LNtLRMKZ5QsCBKg6+/+1vSMyiEzKCV/a/YZNpS2mi5p/JG38MJUe56eRSbdACFcqIvGp
	Ji6miZyYifaanPvwmQDXbg3pOKR5RLf2SLFRoWJgIeKg5o2zocvpwq3eo1yNztwYmtpuhM
	qC4xbrJsvkY1Vvg3H1MtjbhGQq1U+Qo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769531751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bESVhnuM2/JGiUI+4dFhJMsy3Jx63pH5+SvwI6o2Tpw=;
	b=TIbSkU584Bl0S/ISqttDbVL057X5n1a+GF6+wzOp7KQ8JPEMO5QJd2odcJxXWgPf3DjipN
	lfsMDfBNWiBa1OAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5020E3EA61;
	Tue, 27 Jan 2026 16:35:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EOcuE2fpeGlAQAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 27 Jan 2026 16:35:51 +0000
Message-ID: <f6b85926-04b6-4c02-a6f2-1e141c9426b0@suse.cz>
Date: Tue, 27 Jan 2026 17:35:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/2] mm/slab: factor out slab_args_unmergeable()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Hai Li <hao.li@linux.dev>, linux-mm@kvack.org
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-2-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260127103151.21883-2-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: hxdp57o1nr5ac3mknwxb6tydfjjr4s1z
X-Rspam-User: 
X-Rspamd-Queue-Id: 9710C40007
X-HE-Tag: 1769531753-84861
X-HE-Meta: U2FsdGVkX18t6+g+EmcNpA7tj8LusL5nZRch55EK8qnCHSdKx1N0ZBh+9S4YFrpGWMqnpn7tBf97cHX+Zq67Y8rCX5lqnan3ymH6tfLUpKxKOs1o1GY9TGiQEHgbwu34v+7tHPAp0cJ90k8qji0z84/rkbBEbtsjXE1LKnngmRA6rLhrEqGUlSjyI16XcuAHX8Q3jUzFDjAdwZJHvg+jrpO4ipCKaFh4ThgXToGa90E6xwYFcRK+YeoPgvKcLGRgy1diqHFbKnpkrquUqzaMiuzZh4cSBKjRwrM9Gcr6CF61UgZFvMyI37GINRv+Q8tQvXzvoeAur5fl1rxE8VevoNg409A/7tyzs08LOR5aJJTnQ02B5p4qV+5fRl4+NemIj2NTi770DnSs8NXdLJQgc9LEytks7yGA3ianyI8RJUzSIqdTyPcwr5m8D4ha3AUvklFWJ1Ipipi4qLweVxQX1HRiKtoohnmez9SvAQ9G4dBCYUeQpDvh8e6Ymd9USZa5lceYif6gcJxAM1Lq0Nj5CUrbx0KgSMsy2RH18EJcklos6+vDpTukPXOer54JE3ZRYLFm8qH4XFqwIG0PMJUPiez+xr3R96B1o55eSuozQc2GGkhQirRw+Z2zczwiNTOmH5BtpjWANikElV5tQlOFgr8oQJKoj4p9nUJNOHu2ZSFVgns6GNG+LRUAMEc7zF9r9yyJsfeigIfmIFYvItI42LpKgp2S/EEe3LtfREiZHZZoOdG05M+ubOzPwGpBChd9MHObgYjQwBV+jT3BfXTc+NU0G2F+SVHUP6Df+0XfSnSd4ZbELXpZtxUxNMoKOw55wvKYrVqsdA9C9v7nrJoJAZQw0PqlSCGbzBJZt1BIW32n6di5c++4hcF0m6xoaStTbUKOMESEBsVp3WwumFEgwdICzq3t8E27l9lz+S3i01Dy85oxlf3Z/m2u6GNthm8Qq+dhvLcF5eisZ3EhW5q
 1XjA3Ncb
 g33oTNhE38UVPcQSz51Zj8yX54x7cG7Y5eEZ4eUj5z0auVpONXncEJh8upmIuE9HSXpJHio8Gzh1SJ0YwJKBIorRZap4EbBK8FhxzMgc+2zGemfOh2mkt3wSwjEFZoHacVbnoLTVTDG38pihwqn1JTsv8SmO17nmJwzQ+IvH4lkW8Axxx7/CNPO5kTfyXB9w6HX33rEwewwMKs0q022UJsJummWLLToKrbKwUpTJiKv31qS/6P2u7DMkcmYFpLnqQJLmP5ZGlLz73LmrTWDHxmAI9WwJbq104sTKYNAlSPOAHaBABeli4t8AZsf+jKmUPbXuN9BRmGRPBcc06j6LKTjPx+FyEGr6hbKY+MlJmxlknan8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 11:31, Harry Yoo wrote:
> slab_mergeable() determines whether a slab cache can be merged, but it
> should not be used when the cache is not fully created yet.
> 
> Extract the pre-cache-creation mergeability checks into
> slab_args_unmergeable(), which evaluates kmem_cache_args, slab flags,
> and slab_nomerge to determine if a cache will be mergeable before it is
> created.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slab_common.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 2e80d323f550..904414c3ebb8 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -174,24 +174,32 @@ int slab_unmergeable(struct kmem_cache *s)
>  	return 0;
>  }
>  
> -static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
> -		const char *name, struct kmem_cache_args *args)
> +static bool slab_args_unmergeable(struct kmem_cache_args *args,
> +				  slab_flags_t flags)
>  {
> -	struct kmem_cache *s;
> -	unsigned int align;
> -
>  	if (slab_nomerge)
> -		return NULL;
> +		return true;

I think this still logically belongs to find_mergeable() and not here, so
moved there. Agreed?

>  	if (args->ctor)
> -		return NULL;
> +		return true;
>  
>  	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
> -		return NULL;
> -
> -	flags = kmem_cache_flags(flags, name);
> +		return true;
>  
>  	if (flags & SLAB_NEVER_MERGE)
> +		return true;
> +
> +	return false;
> +}
> +
> +static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
> +		const char *name, struct kmem_cache_args *args)
> +{
> +	struct kmem_cache *s;
> +	unsigned int align;
> +
> +	flags = kmem_cache_flags(flags, name);
> +	if (slab_args_unmergeable(args, flags))
>  		return NULL;
>  
>  	size = ALIGN(size, sizeof(void *));


