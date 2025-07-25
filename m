Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92CCC87FCD
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5E36B007B; Fri, 25 Jul 2025 04:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD4C6B0088; Fri, 25 Jul 2025 04:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195626B0089; Fri, 25 Jul 2025 04:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07CB46B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:47:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BC4FC0664
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:47:27 +0000 (UTC)
X-FDA: 83702158134.21.355EED8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id CBF6DA0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:47:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OeLHhU5W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H6JB0ign;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OeLHhU5W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H6JB0ign;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753433245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5mIeEJNHmWKWW6RsIhmAZfORXEks3eAgT6/5b1hJfA=;
	b=8jy4NqXUSY5T326rNfJ4uMJATG/mznyCApqolsfKWc6wOr5zpOcjO1tElsvP2xJeySoSsE
	FQ3+1EPZVF25SVBxDsAHCLRmlzzdAs/TnCoEWew/82HHLgdLksop3LfG7Ymiv5SBVNd4Of
	sxGun47+We0Hp0UsO0hazOXyq3eeXsk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OeLHhU5W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H6JB0ign;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OeLHhU5W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H6JB0ign;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753433245; a=rsa-sha256;
	cv=none;
	b=7D+SSX78ruFnZwc9CS8d91tsWbMXKh/bqvamMv83MGI17HGaVMyl4ykfLIf0dIwxsw+vG7
	viocS+aVa1mR5supP9+al1XHJmhcZ7qfEWN9tBOAaaJbC9/KuQ1LR9cfnHVkGZo6egF6uk
	VxX25906rJKk2e9pMYLNMLLzkI1bj4Y=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E36221A21;
	Fri, 25 Jul 2025 08:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753433243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b5mIeEJNHmWKWW6RsIhmAZfORXEks3eAgT6/5b1hJfA=;
	b=OeLHhU5W7pddrGKH9n0Kw2zZThDZLvbNWRDl4To7QSqwXfFTxefGi8mlWjV/wVOb40ZxQD
	Uuy3SSVDdQvYGIYSnjhl8dG6sUP0JitOGOC19IVUWWBGqAQp29dDTDrSMzlmDrdMsclsKZ
	BDHXD+NcZr/g2luOiLGgRgecEW5dwjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753433243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b5mIeEJNHmWKWW6RsIhmAZfORXEks3eAgT6/5b1hJfA=;
	b=H6JB0igneF3C7jdz8fjy5FGwvQ6PItTy1u2C5m8dgvpwJXQiWhAmCAuS3AAIQJgO+9l4r8
	f6qn5+qnQVw79JDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753433243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b5mIeEJNHmWKWW6RsIhmAZfORXEks3eAgT6/5b1hJfA=;
	b=OeLHhU5W7pddrGKH9n0Kw2zZThDZLvbNWRDl4To7QSqwXfFTxefGi8mlWjV/wVOb40ZxQD
	Uuy3SSVDdQvYGIYSnjhl8dG6sUP0JitOGOC19IVUWWBGqAQp29dDTDrSMzlmDrdMsclsKZ
	BDHXD+NcZr/g2luOiLGgRgecEW5dwjs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753433243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b5mIeEJNHmWKWW6RsIhmAZfORXEks3eAgT6/5b1hJfA=;
	b=H6JB0igneF3C7jdz8fjy5FGwvQ6PItTy1u2C5m8dgvpwJXQiWhAmCAuS3AAIQJgO+9l4r8
	f6qn5+qnQVw79JDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F37FF134E8;
	Fri, 25 Jul 2025 08:47:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GFkLO5pEg2hKZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 25 Jul 2025 08:47:22 +0000
Message-ID: <dea8645f-9f2c-40f2-bf39-f51c767d07bc@suse.cz>
Date: Fri, 25 Jul 2025 10:47:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 2/4] mm/slub: allow to set node and align in
 k[v]realloc
Content-Language: en-US
To: Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org,
 bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
 <20250715135815.2230224-1-vitaly.wool@konsulko.se>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250715135815.2230224-1-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CBF6DA0002
X-Rspamd-Server: rspam06
X-Stat-Signature: ni53urow44dkewakeysc6fcrqj7z7ktp
X-HE-Tag: 1753433244-114737
X-HE-Meta: U2FsdGVkX1+4WzTJQCiXeOCerf5FhXqMsb2fIVGjMn5qIfKheD86RAjgFMzAdK1cS3fmdjOexcH/pigrlEip7VCzSbkWgydobyQdCg2Jzjh9eS+tgYn7GpVKl0Fxl10pxy9uG0dJSXBsDh5Kk641DiW2Vrs5SSdxgEq69SH87OWkETrM+Yebmt+VIwLIaeJZeXZKVNyhpaPM+BNm6ujYg9YJQd9lqGrJunMiJNevYk6u8dFeWXQe1im/UKDH2I1unPk7vsOlHvCTlRDagGZtaeU2Hf7lm6VgocXuAv5Gd1X9UKF0J4U8YUawSvAyicmTXP+upAl2Zr1i+RBEkzK5+evKcH/P4mgmAiVFvQDh585Dh4Zl/EvNFsx3N31MQzw3tPiiNlbd5aPpmT/HRFJRrR4fjc+lY48x8J7UDoEt6DlMqnIwRoxb0kdjTARJ1KlpAyHjCWFwVmRKJ00/pt9SnQpl0Rke+M2YUfVcizEFBSoBCigITwcLFRowFLcWDyza9UIN612+aOL0hcjIbnT2v+oUSW78vAbtTQq5GEe3sc/Hr6GcAONh6jwYBz2Mg4lwYpo3VXxSX6TTRU9gtNsTrdPhrxuUn0x1fam+LVdUDcpxDVBIrCy0y6O5j1H4IH5vu6v5ztcR426+RigBRspDyh6I3UKoFEwfmMA4HZZkwTItfUKpiHu3hpAupgUFfEu7ksSopjn9g9lXGcJIM2kR5YoWjdiBRi7a6VyHKRVXWFtV6N50nna65c28XdCy3gopW/DXpEhkNv2OyW32if0tJmdoKK+mmhPdF5sgIfItSOS+tYakW4/G6WMfhdXg+qIWmkMHI2Yp8K72T1ffaPbX7I92NHNbfm1PtQuB8i8x/SIkDAv0vs+0b8591vIPSQVxorNUklyKpD7rZY+j+tOxwcFb/E9N/itmG69esrUeOLjsycvVZYxauYlZf3Aov3gtXJkZSRbvcvea9Qxsx1l
 /UEC1zzS
 C8ms22KZvzWaxTIomucncodDxiYHOZ3X1s90QWe1d4g5K9y4evRaLIo+frTdQA5rBfE9JoPQTjK5IPHIIxirvG619eOPLGbtfQKbHlA5ENT88TNMyOZfd3pWpHQ4UWO4PXmEkvVpe+NpXasF7njKAYyZsMehYVW0PRLSoXfJ835DJb1HBzWwZuqR/l9RQ95L9gu2NnGwsbY/rc/uTadpJm0uexV9dBxGEzNKnBjWhdynjfcp5So57/s2rcEGjDky68owDUQTTnatajDFRwWPhwllgOjYRyl/JzPku
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/25 15:58, Vitaly Wool wrote:
> Reimplement k[v]realloc_node() to be able to set node and
> alignment should a user need to do so. In order to do that while
> retaining the maximal backward compatibility, add
> k[v]realloc_node_align() functions and redefine the rest of API
> using these new ones.
> 
> While doing that, we also keep the number of  _noprof variants to a
> minimum, which implies some changes to the existing users of older
> _noprof functions, that basically being bcachefs.
> 
> With that change we also provide the ability for the Rust part of
> the kernel to set node and alignment in its K[v]xxx
> [re]allocations.
> 
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
>  
>  /**
> - * krealloc - reallocate memory. The contents will remain unchanged.
> + * krealloc_node_align - reallocate memory. The contents will remain unchanged.
>   * @p: object to reallocate memory for.
>   * @new_size: how many bytes of memory are required.
> + * @align: desired alignment.

It should be better noted that only alignments up to those guaranteed by
kmalloc() (with a link to its doc where it's described) are expected and not
arbitrary ones. So we don't give the wrong impression here.

>   * @flags: the type of memory to allocate.
> + * @nid: NUMA node or NUMA_NO_NODE
>   *
>   * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
>   * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
> @@ -4946,7 +4962,8 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
>   *
>   * Return: pointer to the allocated memory or %NULL in case of error
>   */
> -void *krealloc_noprof(const void *p, size_t new_size, gfp_t flags)
> +void *krealloc_node_align_noprof(const void *p, size_t new_size, unsigned long align,
> +				 gfp_t flags, int nid)
>  {
>  	void *ret;
>  
> @@ -4955,13 +4972,13 @@ void *krealloc_noprof(const void *p, size_t new_size, gfp_t flags)
>  		return ZERO_SIZE_PTR;
>  	}
>  
> -	ret = __do_krealloc(p, new_size, flags);
> +	ret = __do_krealloc(p, new_size, align, flags, nid);
>  	if (ret && kasan_reset_tag(p) != kasan_reset_tag(ret))
>  		kfree(p);
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL(krealloc_noprof);
> +EXPORT_SYMBOL(krealloc_node_align_noprof);
>  
>  static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>  {
> @@ -4992,6 +5009,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>   * failure, fall back to non-contiguous (vmalloc) allocation.
>   * @size: size of the request.
>   * @b: which set of kmalloc buckets to allocate from.
> + * @align: desired alignment.

I guess here we should say something similar to what I suggested to
krealloc(). The "size >= align" check below doesn't mean the alignment can
be arbitrary. It would be incompatible with how
kvrealloc_node_align_noprof() works anyway.

>   * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
>   * @node: numa node to allocate from
>   *
> @@ -5004,19 +5022,22 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
>   *
>   * Return: pointer to the allocated memory of %NULL in case of failure
>   */
> -void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> +void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
> +			     gfp_t flags, int node)
>  {
>  	void *ret;
>  
>  	/*
>  	 * It doesn't really make sense to fallback to vmalloc for sub page
> -	 * requests
> +	 * requests and small alignments
>  	 */
> -	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
> -				kmalloc_gfp_adjust(flags, size),
> -				node, _RET_IP_);
> -	if (ret || size <= PAGE_SIZE)
> -		return ret;
> +	if (size >= align) {

I think it's similar to the check in __do_krealloc() in v12 and not
particularly useful. We don't need to support align > size for rust anyway?
Does vmalloc even honor that?

It would also be inconsistent that kvmalloc() would give you this
possibility of size<align, but starting with a small size and size>=align
and then kvrealloc() to size<align wouldn't actually work.

> +		ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
> +					kmalloc_gfp_adjust(flags, size),
> +					node, _RET_IP_);
> +		if (ret || size <= PAGE_SIZE)
> +			return ret;
> +	}
>  
>  	/* non-sleeping allocations are not supported by vmalloc */
>  	if (!gfpflags_allow_blocking(flags))
> @@ -5034,7 +5055,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
>  	 * about the resulting pointer, and cannot play
>  	 * protection games.
>  	 */
> -	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
> +	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
>  			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
>  			node, __builtin_return_address(0));
>  }
> @@ -5078,10 +5099,12 @@ void kvfree_sensitive(const void *addr, size_t len)
>  EXPORT_SYMBOL(kvfree_sensitive);
>  
>  /**
> - * kvrealloc - reallocate memory; contents remain unchanged
> + * kvrealloc_node_align - reallocate memory; contents remain unchanged
>   * @p: object to reallocate memory for
>   * @size: the size to reallocate
> + * @align: desired alignment

Ditto.

>   * @flags: the flags for the page level allocator
> + * @nid: NUMA node id
>   *
>   * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
>   * and @p is not a %NULL pointer, the object pointed to is freed.
> @@ -5099,17 +5122,18 @@ EXPORT_SYMBOL(kvfree_sensitive);
>   *
>   * Return: pointer to the allocated memory or %NULL in case of error
>   */
> -void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
> +void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
> +				  gfp_t flags, int nid)
>  {
>  	void *n;
>  
>  	if (is_vmalloc_addr(p))
> -		return vrealloc_noprof(p, size, flags);
> +		return vrealloc_node_align_noprof(p, size, align, flags, nid);
>  
> -	n = krealloc_noprof(p, size, kmalloc_gfp_adjust(flags, size));
> +	n = krealloc_node_align_noprof(p, size, align, kmalloc_gfp_adjust(flags, size), nid);
>  	if (!n) {
>  		/* We failed to krealloc(), fall back to kvmalloc(). */
> -		n = kvmalloc_noprof(size, flags);
> +		n = kvmalloc_node_align_noprof(size, align, flags, nid);
>  		if (!n)
>  			return NULL;
>  
> @@ -5125,7 +5149,7 @@ void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
>  
>  	return n;
>  }
> -EXPORT_SYMBOL(kvrealloc_noprof);
> +EXPORT_SYMBOL(kvrealloc_node_align_noprof);
>  
>  struct detached_freelist {
>  	struct slab *slab;


