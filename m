Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0F8C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3434B6B009E; Fri, 25 Jul 2025 12:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CF26B009F; Fri, 25 Jul 2025 12:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2319C6B00A0; Fri, 25 Jul 2025 12:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 159326B009E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:47:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2BF3BBC32
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:47:05 +0000 (UTC)
X-FDA: 83703366810.13.84221AC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E96C180005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:47:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="RPe/GuXU";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28DW0cse;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="RPe/GuXU";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28DW0cse;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753462023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6rgzcM42r6bNwWrNmvNxe4rewMivcbP9MWQ4KWmjXQ=;
	b=mnogkV4CPac00BGtEi8NT2RV3GLmnt5zOsZ0BD6fMaTuqXl8XuoOlnkgXYXB+KZAJgBpaD
	SHAyah+ds/8R+qXI1Lkl71Mh2kbu8leyDCWPGOY5RefuxV03k7ceRQrVe6+FSicnfsbLEa
	D3FLPliwkPD0WDo63XYOAepBMsbAn7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753462023; a=rsa-sha256;
	cv=none;
	b=hQtzqlp46shuhekIsqSw5F9/LGN6CrL7XLAvK8pcWdmiDh6FoGu+GpIjh1yDeZ6jRCbRlF
	Vv5PZzB2TtYi0VxiYGdTQz0gODfiVnOq9osTLXMt78z7/kcb5Dek+tf1PSURgcD222v1hT
	iooCgLEvD1zr+nsVQCOhXDA2mhBsx1g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="RPe/GuXU";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28DW0cse;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="RPe/GuXU";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28DW0cse;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8048E1F78C;
	Fri, 25 Jul 2025 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753462021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j6rgzcM42r6bNwWrNmvNxe4rewMivcbP9MWQ4KWmjXQ=;
	b=RPe/GuXUzXjAcbFcMm+vNtrov952mlsyQb6KVQwCox+l3f9HQqAOYMYL9Nsd1DpzPj9vo9
	9LGLWnM6aZ6Y07ryXiyZqAGTt75jxM//DRLIxgkfJ98yitisRU4lrjF5PgWzreH7843bWD
	hQW8u7W2qzYCOkvemzDosx/MdKlPuYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753462021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j6rgzcM42r6bNwWrNmvNxe4rewMivcbP9MWQ4KWmjXQ=;
	b=28DW0cseOpZGtgrR8i5LN7voYD2K/3OfmxEb4dEGj24N7nqx4Ps+Kvmd9x/56yJAKZvF61
	AOBqpMrgEINuZYAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753462021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j6rgzcM42r6bNwWrNmvNxe4rewMivcbP9MWQ4KWmjXQ=;
	b=RPe/GuXUzXjAcbFcMm+vNtrov952mlsyQb6KVQwCox+l3f9HQqAOYMYL9Nsd1DpzPj9vo9
	9LGLWnM6aZ6Y07ryXiyZqAGTt75jxM//DRLIxgkfJ98yitisRU4lrjF5PgWzreH7843bWD
	hQW8u7W2qzYCOkvemzDosx/MdKlPuYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753462021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j6rgzcM42r6bNwWrNmvNxe4rewMivcbP9MWQ4KWmjXQ=;
	b=28DW0cseOpZGtgrR8i5LN7voYD2K/3OfmxEb4dEGj24N7nqx4Ps+Kvmd9x/56yJAKZvF61
	AOBqpMrgEINuZYAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CD75134E8;
	Fri, 25 Jul 2025 16:47:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v0c2GgW1g2gcfQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 25 Jul 2025 16:47:01 +0000
Message-ID: <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
Date: Fri, 25 Jul 2025 18:47:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity checks
 if object is invalid
Content-Language: en-US
To: Li Qiong <liqiong@nfschina.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250725064919.1785537-1-liqiong@nfschina.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250725064919.1785537-1-liqiong@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cwgdd3cukoqdyt41ysaqx567pdw8wzcs
X-Rspamd-Queue-Id: 0E96C180005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753462022-907545
X-HE-Meta: U2FsdGVkX181oOV0wqpAjPYfcKj/st6aVScTd1h2bvCQs5M9jY83+FKChR1gQKRjvSV4zfC5oOWoVwMc7tS6l66IBHGU+6yW+Tj6Qq7UOhFUIERdHBUlM4ksObKLfX4lNi8ZjvOd5YHmuaT8KG4jYyN5dk6QXiNWzuWaTmTG8Mf5MBjesFoKDn2Izb4GZ0b5OWpnmCpdV6cluJ3auMLxTJwqX/DTcuRmN2DPuox+N1VGsCnouMtyW7QoU9XT4IUdEEfPpQfXkReUJkL8qtnO2UYepwP7XQg+/fNNor6RUvsQ5UaZW7eTuKe7iQnS791tptab41vOKrA/yAkKi8c7w0MADgdI9bzNXb+hyXbQsz7wBrxIrbEu9fckwu2k3HCUcYOkLAJfPyYy8YE74id96POECXpE4gSXMIs+ouKwG/gKUU1BO8ldwltO83IU/cJ6TqHQZ8PmBWm7tuL1mNcsr68qQZTZBya4bhjLw9LoqNzyLPcf1GCrRu9XuZoRqu6PsBWbijVj3wu0h/iiBNp2E3ynDdsuyJFLsZUuCqNVHyvWmiDG+yHlh1k927ndchgerBNgPI31Iop91klt1bHFXSAVw/QCj6CuW/vKr3D209Ogbl2UPI256rkJxZp230IQmYRvsKr2IJ3t4VwLNHFAUvWhLpG1bejMK2EQbcc4rdvBHMvx4ng9N6X30jLWjOnyGhV2CwQMoabeWzkVH1BzLwaJQ6xC3PNKHwmy9rh3k1f8WSQsrLwqCTSZJZUHHWaob6VLW1MwqEm/hErXsbj/k2T4/SRzFdCXLr412nSPVXbBM2YHYoqEGZfgt+BlPrte2/GKsdCN/QuLzf4X0TML02qBIKnJVG5+cpDi+V0zzueahJqcnTY2zSXL+Uke5DWGeNI5o/UWb6FS+aLC97pfB3tuFw5Kl9zp+Bfmj5B5eJO+YZnPh+XGu2qRneODHFFSNgP7COqUHXGfuEz5iNn
 hpIg+m19
 gxMxmdbSWp7M4km2N+qWyrhYXcVI+Lg/dPbil0ksOoX49nPSj5qKGqr3eOYcU7w6Morwf3EBu7n55mJVWFKvNq/tbMva9aP0KnCg83qr9r59kCdQ0pPJN7DIX+5K8DOuJO2yB5Ajufqw7un3g0LE7BNYkmINHCPZeihvfbaQeXibdwRjAqHC+us15GBdGyijVFTSPE0X9L3M2F5DP/t5sYsGzKX82JZ9JcofFI2v46n1zb549brW+ldC5xjoj2BEhlRfGjefBlxZ/VPZ1dDDpj/VgshgNGD0ouNgO5dRr3vdS/NF9l1nsPLMwQed3FhKYAELzIZaX/ugI4GVgwnfrLoq4OtMgluQY6wCyX+co64hhaZ4cODynKbr0DylShlFSfjmOWICV2mz9MIci8kLv142Ckw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/25 08:49, Li Qiong wrote:
> For debugging, object_err() prints free pointer of the object.
> However, if check_valid_pointer() returns false for a object,
> dereferncing `object + s->offset` can lead to a crash. Therefore,
> print the object's address in such cases.
> 
> Fixes: bb192ed9aa71 ("mm/slub: Convert most struct page to struct slab by spatch")

That was the last commit to change the line, but the problem existed before,
AFAICS all the time, so I did:

    Fixes: 7656c72b5a63 ("SLUB: add macros for scanning objects in a slab")
    Cc: <stable@vger.kernel.org>

> Signed-off-by: Li Qiong <liqiong@nfschina.com>

Added to slab/for-next, thanks!

> ---
> v2:
> - rephrase the commit message, add comment for object_err().
> ---
>  mm/slub.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 31e11ef256f9..8b24f1cf3079 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1097,6 +1097,10 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>  			      size_from_object(s) - off);
>  }
>  
> +/*
> + * object - should be a valid object.
> + * check_valid_pointer(s, slab, object) should be true.
> + */
>  static void object_err(struct kmem_cache *s, struct slab *slab,
>  			u8 *object, const char *reason)
>  {
> @@ -1587,7 +1591,7 @@ static inline int alloc_consistency_checks(struct kmem_cache *s,
>  		return 0;
>  
>  	if (!check_valid_pointer(s, slab, object)) {
> -		object_err(s, slab, object, "Freelist Pointer check fails");
> +		slab_err(s, slab, "Invalid object pointer 0x%p", object);
>  		return 0;
>  	}
>  


