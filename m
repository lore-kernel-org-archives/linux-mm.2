Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A05C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132256B0098; Tue, 22 Sep 2026 06:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109146B00A2; Tue, 22 Sep 2026 06:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39C16B00A4; Tue, 22 Sep 2026 06:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0D236B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:12:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 505801A03E8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:12:17 +0000 (UTC)
X-FDA: 85240983114.12.50FDF14
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 483E6C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:12:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jqIdH4Q6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EtmhcwJL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Hz2OXK42;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=M+BtSL9c;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790071935;
	b=8byrbtBk6OLo20xeISCVRtYz9jDFYDBmiIde/RxFvzmePl3emy4HRbYOQR3PFiHSCzDrWn
	g705mbFNJQsEzmUJ/Mfvhrecg/IFUpvT2h3uxxbDPVRP9p4eOIZORpDFsgKBjExu8AKQ3g
	/K0RLKajmKtO8oq9Rfom1zOe+CQoj4s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jqIdH4Q6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EtmhcwJL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Hz2OXK42;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=M+BtSL9c;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790071935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4V2W84nnZxZtsNLlJYzmWJXrEP0iK8clXop5+Bi29YM=;
	b=S/zJfQo7lqv1nkiRtP9f2Mn+6MYdpCViuGOfrSUUBIWIS4hvMRj9QfGQQZNCjq+0z46c40
	bBw5KKUa8N4LV9P4ipvPshR0iy4Kg6/Qc+wR6rgtsN0muFJ1qESBxTzFfrx/bgSODVd+a8
	ei99ehG2kEfDbKXrX8NqOMzFXAhXj0o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 99FE621BF6;
	Tue, 22 Sep 2026 10:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790071929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4V2W84nnZxZtsNLlJYzmWJXrEP0iK8clXop5+Bi29YM=;
	b=jqIdH4Q6tJxawmvcDiwlcQAq3m0O3CQyCs9kSSU4Q7mhSNtMiPh3jPjKWPk/T7DIXu8SsH
	bazakabGgOM+9sAtQxqOOw1Rhf87NTbCUIN0G+JxlNH0nCwwymD3H+QyrmpER0Bl/ydSzE
	g2bQUtE3raIbD32dG5XamvIHmzpDx7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790071929;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4V2W84nnZxZtsNLlJYzmWJXrEP0iK8clXop5+Bi29YM=;
	b=EtmhcwJLKOGJvdHEPn+hdXgNEw7TbIu+LOzjSBpVWCH6uALQ4lOgdEvm0qwTqjysFpRfi9
	MP6c/cuWhWJMZhBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790071925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4V2W84nnZxZtsNLlJYzmWJXrEP0iK8clXop5+Bi29YM=;
	b=Hz2OXK42rVLTCxsOsLAVeEBwSg0oiwfqZJ3JC1N0xa5BSdeeMieW1KlQ5efaeXK9UjYasP
	V5AaceXaYxpspqwKPeApJVC77KFER9YxajkEhB8cidfsUBdlusq29EZSh9ZnMmf3CQWlc/
	87EWDe1kz99N8iYE6PFSySWEWHhTlWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790071925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4V2W84nnZxZtsNLlJYzmWJXrEP0iK8clXop5+Bi29YM=;
	b=M+BtSL9czFqWAAJUSt5EqlMB7CKZiyhY+XEsU0po3W212ggTvnYkrRlYv5dQDdtOZYF1rO
	iPE3SzQyU7Sie/BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC5D0136D9;
	Tue, 22 Sep 2026 10:12:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I3LsGXFUsmqrFgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 22 Sep 2026 10:12:01 +0000
Date: Tue, 22 Sep 2026 11:11:58 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 5/7] mm/slab: Provide kmalloc type fallback for bucket
 allocations
Message-ID: <arJSz0r5u_78NWKe@pedro-suse.tail5790ac.ts.net>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-5-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-5-kees@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 483E6C0004
X-Stat-Signature: x66dupikmwu3io3whroqxyxrxku1ytwi
X-HE-Tag: 1790071935-59998
X-HE-Meta: U2FsdGVkX1/m4WBIPqjhcOHqAKpb4nXoTE91/9XKfqqF9CMtoYqs9AZ9LJ7xzfq3Z2j6oEdFsMhpligVtEwWXIHuW0jP53byux4UQ75Bvrmoyh6F0pSSCoQzHKwjOQBMla3sHr1fz/1YxuCitgdiopNZMR4ruuaIp2i4BXvWNkq1xfr54cQR55XDKxhBa5HTqAn26eXsM77BDhnoFd6+92Rzgzg0f9vWaZECGsVzn7+Uud4+93EGhu/HAyLKNaxaLWjnWJJVVYh1j55nuGivlF3gnww/aX4dDaVMc3cn6tkO4NJDCkiCMiHU7X+sPByfjmqzPQT7sLD6nCcINhDMfcNvR6S8Kfyx+tZOhFo7W5N6+H4qZR+yFe7s9gquCUHwFq7XrQq2Hocd4KnBRjHaZrSmzSpnyb3JTqNd0ioDkzhGghdAQkb11RrhcWSEbnnHk67uJ29bfTUt3mUh5sl4DCpYeDS6HAyratzgLjkSVDKh0QImENRRfa5czgutJixylvSa7DIdhZtMBwv3C8y7opi7ivKhoEd2G6V7fpHwy5Salw/AVgzPydPiSQwD9+6N0/kgOt2rBn/zyLTmnHwUfQwN3K+7p0QcAFmTrEuNJeJOTnN/xfBdeiGbJgwJVlNtOHsRta6/V68pGbF4jlb9NWrAdAbud0GkcIumu7L6LvqPpQGdGJDQS7tllqcwWkxBGqSvkGKsxtLnbCRzSzzPvUhZJ/lPztB+dQhn4LEj8xWVxHlsMv1d2RRVR0O2nZCWbilp7uqmuXzD6GjbHD4fLdOcrkxrxH+18zqNH4FpCk6XNnEVJ3AWUX654P6Nfx5j/P6yjj7P7T+GEhFMWQI1/K3UdZ+0thCIjp2A7iiJ1fBxp0M6UM+mM7s/QKJJ48nQZSw+xAIPouigyuvvagjn+eyFtsSZLO6h75kh9auno/BtLhguHyfSqq83DzrI32wiae1IiydJhkT6qefEEW7
 Kc/szcnX
 BuRHqPalDNZF/MpO/0YfP/4llRSe6C2bIa68opAbv2CtH+KUnVJ/JOAb+8RzJvmHp5+Mc1pnkVUKCnarGQDrBIlGf2/RfrvZYTfLBS6p6R3qcuIi2DcECGqaP0OAu1N7xEN7laPyXIXDq4wk6ihBS7iheXUHuLM+wx08d9IKKHNdUTxoybqioRoNPFjlnGDXTNeKJQIlfBmRHdAd0i37iU+J2kstEktXSA0D6kkoyOMof5eIf+pFM7pwd5yXL1/R5g2ClPcRV2FMInKmRoQBVO7DL7f7eVcY7C/YK7t/HQU9ykPgm3JC7JBbLehLKZmKAPi5pQO/cFzUPRQ1XftM0jiWoXj4qscxr5T1odsMYtiKtwsjBMNZuM0qkQjkff+sOV5hK+bfvUQu0dVSutux7d2DimMwYEcxIgxT4jKP318w+jHx+EOinFT11emsYl3oYgU1hMJfgEKpJir6zDK0qADLc5COVQ0LCrRjXObhd1ZqrRbto26yUE8QUZ+k/hakj7cPQTmBLs/TLOYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kees,

Big thanks for continuing this effort :))

On Mon, Sep 21, 2026 at 12:58:16AM -0700, Kees Cook wrote:
> kmem_buckets_create() clones kmalloc_caches[KMALLOC_NORMAL].
> kmalloc_slab() figures out the kmalloc type the caller asks for, but
> then ignored it whenever a bucket set was in use, returning a normal
> cache regardless. This would be a problem if a caller asked for GFP_DMA,
> __GFP_ACCOUNT, etc. None of the current users do this, so there is
> problem, but it makes adding new users fragile. For example, skb data[1]
> needs to handle GFP_DMA (rarely) and __GFP_ACCOUNT (often).
> 
> Send those allocations to the general caches instead so nothing breaks and
> regular allocations remain isolated with the bucket. The kmem_bucket_type
> enum contains only a single item here, but will be expanded in the next
> patch.
> 
> Built and tests pass with ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Assisted-by: LLM
> Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: <linux-mm@kvack.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  include/linux/slab.h   | 13 +++++++++++
>  mm/slab.h              | 23 ++++++++++++++++--
>  lib/tests/slub_kunit.c | 53 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 87 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 18a2351f9084..ab9ab3d34847 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -742,6 +742,19 @@ typedef struct kmem_cache * kmem_buckets[KMALLOC_SHIFT_HIGH + 1];
>  
>  extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
>  
> +/*
> + * The kmalloc types a bucket set can hold a copy of. This is deliberately not
> + * enum kmalloc_cache_type: the KMALLOC_PARTITION copies are all "normal" to a
> + * bucket set, which already separates what they were there to separate, so
> + * indexing by those would mean up to KMALLOC_PARTITION_CACHES_NR unusable
> + * rows per set. Allocations of any type not listed here are served by the
> + * general caches.
> + */

This sounds odd. Is there a good reason why KMALLOC_PARTITIONs are kmalloc_cache_types?
Perhaps that bit should be reworked instead?

> +enum kmem_bucket_type {
> +	KMEM_BUCKET_NORMAL = 0,
> +	NR_KMEM_BUCKET_TYPES
> +};
> +
>  /*
>   * Define gfp bits that should not be set for KMALLOC_NORMAL.
>   */
> diff --git a/mm/slab.h b/mm/slab.h
> index 8fd6835e4235..7f1bfee83b92 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -421,6 +421,26 @@ static inline unsigned int size_index_elem(unsigned int bytes)
>  	return (bytes - 1) / 8;
>  }
>  
> +/*
> + * Which set of buckets to use for the given kmalloc_cache_type. If not
> + * handled by the kmem_buckets, fall back to general caches.
> + */
> +static inline kmem_buckets *
> +kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
> +{
> +	enum kmem_bucket_type btype;
> +
> +	if (!bucket)
> +		return &kmalloc_caches[type];
> +
> +	if (type <= KMALLOC_PARTITION_END)
> +		btype = KMEM_BUCKET_NORMAL;
> +	else
> +		return &kmalloc_caches[type];	/* No set holds a row for it. */

Hitting this case sounds like a bug in the kernel. WARN_ON_ONCE()?

Otherwise LGTM.

-- 
Pedro

