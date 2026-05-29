Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E95CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE776B0005; Fri, 29 May 2026 05:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448276B0088; Fri, 29 May 2026 05:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30FE76B008C; Fri, 29 May 2026 05:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE126B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:25:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDF721A0ED2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:25:30 +0000 (UTC)
X-FDA: 84819924420.19.671D943
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id B58D880005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:25:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtxIo8qF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tsPPUVIV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtxIo8qF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tsPPUVIV;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780046728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oz9cjV4jibtvDaGmO2uMuiN0egNoZXNvT5/OvM8OCCY=;
	b=7z9r5YD+FKFDZZmukxF0fCfbzj85Gm5hcqhcL5fowbBhQrigjlfM+nu1VSaW7NgFsrrv4P
	TaseSmjI0RWe8v9SH5KUxLSgEr9QPXoQ5lDJt882GCVGkxyQIHyr3O8zhIiyFAaqcGOmlk
	Ioyy5ArAPQEfCxRb7lMdYTof7X1HMWw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtxIo8qF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tsPPUVIV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OtxIo8qF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tsPPUVIV;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780046728; a=rsa-sha256;
	cv=none;
	b=29SBbthpNZ+K/zqV9cjxhx4DPsj8S3AO4badKSdXwhvv0pI+/5aAOa7mbZmsrQ9zgGCqjD
	2YWaU8rjajIS3dpaAtRPVqHCyBUyX++x3Hmsz5uJI32ad/oBasnqQBHaktAhBW2YaVNeol
	9xHhGxkp6GRymD3tm+mL5Id9nC7MfKA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17F1F671CD;
	Fri, 29 May 2026 09:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780046727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz9cjV4jibtvDaGmO2uMuiN0egNoZXNvT5/OvM8OCCY=;
	b=OtxIo8qFScTD6SXe5IFVEWaSDTgTswmy4v1qbhEY4Malp/xa4b9EaLiJ/xC+22456aXlbA
	4warMxV3UyfRQInGilwDdKFUSsKJOroZhsLvE5h4HpN5yvcLgZz0K2Bf1M+MXyYqclQqe3
	DOe6bxSe/snUBH7Nyw+fU7QqKcYMqAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780046727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz9cjV4jibtvDaGmO2uMuiN0egNoZXNvT5/OvM8OCCY=;
	b=tsPPUVIVUtExKCHnRSzKDNbtIg5YFTFmJG4UN/cDIZlEijygpiAh7oinWll2oIdfvHbKvh
	aA6Ebglt7CQa1VBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780046727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz9cjV4jibtvDaGmO2uMuiN0egNoZXNvT5/OvM8OCCY=;
	b=OtxIo8qFScTD6SXe5IFVEWaSDTgTswmy4v1qbhEY4Malp/xa4b9EaLiJ/xC+22456aXlbA
	4warMxV3UyfRQInGilwDdKFUSsKJOroZhsLvE5h4HpN5yvcLgZz0K2Bf1M+MXyYqclQqe3
	DOe6bxSe/snUBH7Nyw+fU7QqKcYMqAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780046727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oz9cjV4jibtvDaGmO2uMuiN0egNoZXNvT5/OvM8OCCY=;
	b=tsPPUVIVUtExKCHnRSzKDNbtIg5YFTFmJG4UN/cDIZlEijygpiAh7oinWll2oIdfvHbKvh
	aA6Ebglt7CQa1VBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 495D8779A7;
	Fri, 29 May 2026 09:25:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JOuRDoZbGWrnTwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 29 May 2026 09:25:26 +0000
Date: Fri, 29 May 2026 10:25:24 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, 
	akpm@linux-foundation.org, mhocko@suse.com, vbabka@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ahlameE6FBEZj_gt@pedro-suse.lan>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528132917.81123-2-kaitao.cheng@linux.dev>
X-Stat-Signature: 9kbrr1tzfuq1kxt7pysegyydeyk18fe5
X-Rspamd-Queue-Id: B58D880005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780046728-16250
X-HE-Meta: U2FsdGVkX1/fM26zZGWQpkwnsZtwPSx9LzWY1TRAUcHf4u9iQrv9gCp+r/2uXI5WN7B0KSpxnosySZxcef8w6qqT10JcU6TSFVTmJq6l8JvvFaoc5aF9K5bqcqfs9uBYOV19L4MCkau5hfM/9vetuf7ZznmtYsclt2r3LUhyeWvtT2ZJdFiDGj9ls+/iin/YltUwlDnFytM/KdvnrcFRPZcFUCiLWVmIU9dzhkNJH9ZTHpS4/VBjPERpjxM/ZabWXhb1kFPbSvFbis4bSxoSX5xJiZodWoqzCebTOXL8cbkaR+kdzfkm1o/aH62HgJyHW7gX1Cm20vgeztxK8QxnkKGQuKITvdqo93qOV6r71o8abDWJsy1Vd/Z4tth5JawYyDtDA4HkefFXgSUhUUQmcscwyAJWdFNtQ8oy+XiQyf20WZc28LyG2ufXq6rOFqlZrwbGkSoD1hITp31hkT1J8afF2D9PkGqn0f7IOZ45DVL8ZE1M34c/l3uRQ2h2voY+FuyAY35kEuKc5UcbX01GgF7DQtSFWXyqqBlE/1E5F7zTbqddLNVvUJNprfEoYhKM1ys3ExYIQzySwBCtjmfg5euZ5MC66/eEi9QwgUI3fGS68tDBnB89tTuPoBjDkmu4UkJBqruh00LSp9C8lEd02SngBdCIOGnOIXNxhi3JeJflsfx0mXy0CaXTU3xH+RfN3KOCYTMOqWKOk87wqTGwNi0CEHnop8A8Puoeihfg5Dx4BGzcLg0A8HuAOQSOTSeVLIaYuqkOBNlNmOZlcFwszCeUB2x0oN10hGpnwFS7uaPjA3lry5WvLpKLr09FLbbjapG+aUMyWurp9d8mz3F5UZqHi2PaaxkWZCGAISFN5IRuH577GK2SaKdE7y4VY9MJgo+ulnJOB3fFO01OvU+r3Dtl0pwnPcp1bx6Nr1mbw/V9SykF3Obn+v6/jmilxX06hwW74J2w/hhowjJAvTY
 +hBlQRn8
 zVNaLmvlUQDi+VllYhiOaBTG3ZHOpf5an/+MKzLAWXvt8jU7BudV0nb/gYW6GMrZzo+ko90rdl/1Px/+W3wyump3GzfE6r0dn5y/bSOJI7ey59wJ1JSlC52XWrczFaozTzlxQkYlO51e7vKRH+nxhaAUJ9/LSac4E9UvE1oPTMcLqxErOe+f5ANyp9l7UdcoEX4yotet+MePxVgUhQkU6OxXRXa+cKfhyG6QBKzWbZA8jcPCb+3iv4/LtzPlnyi5OrSaX5uON5GpC3jU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:29:16PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
> passes it to the backing percpu allocators. This preserves GFP_NOFS and
> GFP_NOIO for pcpu_alloc_pages() and for the initial pcpu_chunk allocation.
> 
> However, the chunk creation and population slow paths also call helpers
> which do not take a GFP mask and perform internal allocations with
> GFP_KERNEL. For example, pcpu_create_chunk() calls pcpu_get_vm_areas(),
> and population can allocate temporary metadata or page tables while mapping
> backing pages. As a result, a caller which explicitly uses GFP_NOFS or
> GFP_NOIO can still enter FS or IO reclaim while creating or populating a
> percpu chunk.
> 
> This is problematic for callers which use GFP_NOFS or GFP_NOIO because
> they are already holding filesystem or IO-path locks. If free chunks are
> exhausted, the percpu allocation can take pcpu_alloc_mutex and then enter
> unconstrained reclaim from these internal allocations, defeating the
> caller's allocation context and potentially recreating reclaim lock
> dependencies.
> 
> Wrap chunk creation and population in a scoped NOIO or NOFS context when
> pcpu_gfp has the corresponding constraints. Leave ordinary GFP_KERNEL
> allocations unchanged so they retain full reclaim capability.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")

I assume you _did not_ observe this in production? As in no reclaim path should be
insane^W daring enough to do pcpu allocations?

> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/percpu.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 71a85d7245c7..1bb38467390b 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1778,6 +1778,23 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>  }
>  #endif
>  
> +static unsigned int pcpu_memalloc_scope_save(gfp_t gfp)
> +{
> +	if (!(gfp & __GFP_IO))
> +		return memalloc_noio_save();
> +	if (!(gfp & __GFP_FS))
> +		return memalloc_nofs_save();
> +	return 0;
> +}
> +
> +static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
> +{
> +	if (!(gfp & __GFP_IO))
> +		memalloc_noio_restore(flags);
> +	else if (!(gfp & __GFP_FS))
> +		memalloc_nofs_restore(flags);
> +}

I disagree with this. We already have gfp flags, they're already passed to pcpu_create_chunk()
and pcpu_populate_chunk(). It's their job to respect the gfp flags and
Do The Right Thing(tm). Can you fix the problematic places? It seems like it's
mostly the vmalloc backend that's problematic.

> +
>  /**
>   * pcpu_alloc - the percpu allocator
>   * @size: size of area to allocate in bytes
> @@ -1901,7 +1918,12 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  
>  	/* No space left.  Create a new chunk. */
>  	if (list_empty(&pcpu_chunk_lists[pcpu_free_slot])) {
> +		unsigned int pcpu_scope;
> +
> +		pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
>  		chunk = pcpu_create_chunk(pcpu_gfp);
> +		pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
> +
>  		if (!chunk) {
>  			err = "failed to allocate new chunk";
>  			goto fail;
> @@ -1931,9 +1953,13 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  		page_end = PFN_UP(off + size);
>  
>  		for_each_clear_bitrange_from(rs, re, chunk->populated, page_end) {
> +			unsigned int pcpu_scope;
> +
>  			WARN_ON(chunk->immutable);
>  
> +			pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
>  			ret = pcpu_populate_chunk(chunk, rs, re, pcpu_gfp);
> +			pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
>  
>  			spin_lock_irqsave(&pcpu_lock, flags);
>  			if (ret) {
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Pedro

