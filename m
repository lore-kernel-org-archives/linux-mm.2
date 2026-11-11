Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CC5606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PnVgkc9J
Received: by kanga.kvack.org (Postfix)
	id 0A7166B05CB; Wed, 11 Nov 2026 03:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EB06B05CC; Wed, 11 Nov 2026 03:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE766B05CD; Wed, 11 Nov 2026 03:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C26796B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:42:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD1B84023F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:51 +0000 (UTC)
X-FDA: 85422197742.24.847ACF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0977980002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnVgkc9J;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794386570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9TlcmZOHl4GDK38pDne6xs3KrODI10b3Bsj+fs2XwA=;
	b=aoqWHURh9himp89q1CxO8EqgzH9NcdsjcZPlZodAMxlrPTisYHxZ8UVxGNA+pg5kR+VlFy
	CFpohXGBHGHBTDkEYdcbqbta9bcMzEKTq00mLb+zcATCXQHDLBKlpDlwCUXAwgSwXS/qiZ
	QYKCGHfV4huBVcdKdv0XtXeUDHEuKw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794386570;
	b=RjKgybeImsGAmqMzZxg2SptRJM6AZb+S6sKqmzbXuo15my+AB733jtufIJvHUSpcebMHjE
	bAJpg3W47zhGwkyl8uw1bri6yzw9jRBs4iRu8VTtS5O6x7pMdz8N2f20/Hs9DE/CsfI1+I
	ksdQpZyAGqLp+AN/x4raCJFeR+EJ/r4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnVgkc9J;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FA1A61CE5;
	Wed, 11 Nov 2026 08:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39811F00A0B;
	Wed, 11 Nov 2026 08:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794386569;
	bh=J9TlcmZOHl4GDK38pDne6xs3KrODI10b3Bsj+fs2XwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PnVgkc9JqLBFSG0LJoC7O/CKjwo/iFu8jg1I6tlJ2K3MdRuUwj4p3Fdt9Pnoofaqj
	 WLhKes4xiquvPFKfUJDXgD/zwr7etoWMZhP2V+msyAfvlSAkmYBKYDMBU6qmfePqcg
	 AvZJ+ZfQgiipiLLRy5gP7s5czGjlErYEAMwbiLXuGF2h3IhIRkOM1EOmKvS78PoJ3p
	 yi+srwCCcegYJ1lBPX1MILZPLYHbHz7HnfFSHCD2YyC7kjRSynAFllcQy9m18npqRD
	 c1i4Dx2spI63nDb8GeMeu3yzZt3YZ2v9aRE5J4YksdhL9lEyXKf0WTGTDqTDb0QuX5
	 +53E20EfgvT6g==
Message-ID: <79a14b15-cd1c-4345-bcea-c13e2ed73973@kernel.org>
Date: Wed, 11 Nov 2026 09:42:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: Genericize x86-specific cmpxchg16b comment
Content-Language: en-US
To: Tiezhu Yang <yangtiezhu@loongson.cn>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, loongarch@lists.linux.dev, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261111011108.29311-1-yangtiezhu@loongson.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261111011108.29311-1-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: dkqoxy3gafokq355xnt15gma18zgu87k
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 0977980002
X-Rspam-User: 
X-HE-Tag: 1794386569-126181
X-HE-Meta: U2FsdGVkX1/Bw1lpF4gKWykgcxFmMZWLWujVPQx3yWSbCS8gknnWXInhPskAjiXMpWsOtxB1SMAo45WHr2bEDfxRz24E/GmqKJ1i5H+c+9/p5zysht2jEW7LyY7tbXvBzaHeCWXOFjEqjqUJGpComOKdTpnTQKfd75jctmxN3kG0dI9cL5onbiNRqC7fNk9Vn1WD5MfI8NJ5jUs+ewGjeJEOL+tksgYLnUu6K0RhhxVfhtXucpQ7qoyrIWbLr8qN/iajYiYr3p4CkUtRXq1hohxFauJgvA0+cidQnNTLMINNoUQYD1pYwj3t+fcgE2mttSlM4fiuUcU6VB+LRv0xTBFQS5fJK7haRLB9JQfD7cx8RURhysC6Tuy1oMZ0C3qXEArgv1ZyV7jr2pPAFDy02wgX50z+u397U+xAFPacbPDVn9ueF8705cNWwsmm0ZS/Y0BQ9hg5S2uS2xfbpbPfKKWE/eZwy0OnmtT6wvpdIFi8abkRK+VOxIlJ3yfGd/qqnhPBp1Rnrq78eb8edB3gnyMu6fxyxlIgWbBVNJv1FM2gLKG6NtcrdES+PunK7x5+xAFQ/0Ef6Pj6umKgFTc01BEDjVFFOXuJV2bk+U1CWbGZ3JzL/DGf0izxJf8e/bSCI+A8AnPmLqCohn0poV5mdoFN3K6fICt568eNeug+CMaDPfihN/+Mspet5DTMEkOEt9Oq5xLeOwkjpWElb5bhcisajMryGPHxHfW5JDH/FtXSSwycILdTdlT5+6venuaueKtTtwzf5MI0F7/+8XcuvISfX6XoyEHL7aA/Wnp/jofiZ4Fa/3pICYj7nKw01aJQrgPvmBqLhSUqxvtkFQHn4MJAp3qShWKj+Z6UCjikibIfTOxfLkInW/djnj0J3r0LgppElZKuFLCGymIQif587xUwc0Qgn6ntNNVMoh1Fr6LV0cZ6KfAwDhzk9Ch/VIVqbeY8IRXgl3N8H0iueg9
 H+8Twk/e
 7vBzuGwjAXkTmfdz6RxJoWpbFby6euamZXC9puTDFQQJVR4onfM+8FLcymzz/8TBd4JWxXTdxwKRNwgXXJI03e2bl4zPcdoZkAG684e1KLCHxbi9KBS2OKIg5uhnsaRJ9Dtj4XzdK91Yv2gg5ffrG7s5sAWB72WlBFeHur+hHnFDJO3X00lqU6tmLZc4yZ75JBQLRnrNvXBIn+JJq1mC96UZCOsuj8tsim0WvlVgJWjSvm/2AQeu/2GmjO5VcmjiPT1FD1zlWtv7YJ73Eo+UElPPyww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 02:11, Tiezhu Yang wrote:
> In __kmalloc_nolock_noprof(), update the comment from x86-specific
> "cmpxchg16b" to generic "double-width atomic cmpxchg".
> 
> Suggested-by: Harry Yoo <harry@kernel.org>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
> v3:
>   - add missing Suggested-by tag for Harry
>   - use shorter commit message as requested
> 
>  mm/slub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c7526c..090302f1daeb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>  		/*
>  		 * kmalloc_nolock() is not supported on architectures that
> -		 * don't implement cmpxchg16b and thus need slab_lock()
> -		 * which could be preempted by a nmi.
> +		 * don't implement double-width atomic cmpxchg and thus need
> +		 * slab_lock() which could be preempted by a nmi.
>  		 * But debug caches don't use that and only rely on
>  		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
>  		 * to allocate from debug caches by


