Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D8A606A8B5
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 03:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ckspue12
Received: by kanga.kvack.org (Postfix)
	id D832D6B00EF; Fri, 13 Nov 2026 22:38:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31A26B05B0; Fri, 13 Nov 2026 22:38:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A586B05B1; Fri, 13 Nov 2026 22:38:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4D46B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:38:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B7AE160340
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:38:30 +0000 (UTC)
X-FDA: 85432317180.14.D0B27F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 715B840006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:38:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ckspue12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794627508;
	b=gTax2In6s2SSEIOAEqY5LUZTF6SUcF6mg5gP5AWVmVLM9PNDC63wpCUZGMSPZFLjwCRYo9
	G3VWt9ggm1laeVqdlGSzo9kFbs5EJfXYlU1SxWFh6UMGvs3lDf7ZliKeYILqrcjcCeub1W
	fJeGACpZsrs6+LRNucAa+OyRCIDchDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794627508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yU/5BPJ2TQOxgYVVI8HlorlFhoWXcWnPPL8fgZ8lABI=;
	b=AEyGACh1eAnaGHcCtQBrNmhwu+2gdrOp3IfpBadWtI9lkhQ/uiDOQEC8ykSODatX43r9VS
	vGNQjiYGRJV8FECKctkA7bwfHKdBXADUHpmkyMSBJIKC42GTnPqS0bNX+BNWHiGUtUa7lV
	lAAUua2Pr1rBuAH0hYG5Uj9VhvLWdYs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ckspue12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC2D0609CE;
	Sat, 14 Nov 2026 03:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95471F000CB;
	Sat, 14 Nov 2026 03:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794627507;
	bh=yU/5BPJ2TQOxgYVVI8HlorlFhoWXcWnPPL8fgZ8lABI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ckspue12vhtoodYEOl81nD3fwNQ/qoegECvhTq8vaJ+UbCR+wKH1UTuwbk7sAWGza
	 VL0hUZB87GCd6EV5jOWkMr7zAClDVgNA/0g1t6fZQRLlktqV7qKUjC/rM3B8C51/dh
	 fCL8Y21AYDytFPuxUczkPTHQ1RgrTBU0b6gdT5M9zKHFOdU6SNjoa7kP00JxBOYLH4
	 FA2KtMqlzpQohSAowkmIHngmDEz0JmFi3pOLDVKgbLOdnnwY+Xag/Taqeat85bPRRl
	 dRFSdPd7+2vogdN/w3sz1NZDXn7oIqDm7aIDZejDwgf3VCCheVfOdKSgyJoNSfx6MX
	 IZP9e2DuBSv/g==
Date: Sat, 14 Nov 2026 03:38:25 +0000
From: Harry Yoo <harry@kernel.org>
To: Felix Hoffmann <f3lix.dev@gmx.de>
Cc: Jann Horn <jannh@google.com>, Matteo Rizzo <matteorizzo@google.com>, 
	Tamas Koczka <poprdi@google.com>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Flush virtual-slab work before cache destruction
Message-ID: <179462737686.1463521.17920259642574913474@kernel.org>
References: <20261113221330.162567-1-f3lix.dev@gmx.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113221330.162567-1-f3lix.dev@gmx.de>
X-Rspamd-Queue-Id: 715B840006
X-Rspamd-Server: rspam12
X-Stat-Signature: 3aritm9cpwci434p1hmpz6d8euhdc4r6
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794627508-336918
X-HE-Meta: U2FsdGVkX18dbt9MYHudes2OvFV7Tlrf4WY7zPgDWb5tlSITjQiy4kMkXS7S3qE94kgeIhTmXQHbaQeA5fZ67YBkLEyN2TbaPPdzBD+c0ooe6GNhE0DfpshLSEVe7ybao9MNTwcipRLBVz4lkk7gwjLIrj04pgjH8Bnn2DxVwzLPkfM4sTYkQ4nb7FOpe+qzP4N9DJh6G5dCVKtoBm5ZYEw5wJJ9W8X9JSHPnuVJU4AsI6IPdUeeUPFyYED86FBYjLv3/HhSruJQxPr6BHh310Oz4Jui455jc7IlBdWsGratYd8c7jKv6D5ZF+sbaA5hjWLnAkNOm30ASchnit8X5oltB7ZWPau8WjxBXH80rcRakD8w96GSGOXOo3LLgCpX5gUCzhhPiWsj5ncQ85yuDeNjvidCTgYxyi5v0NMj1olAy/U4LrKegr2X9+1kIwcttBP/teuh/egjJ8XnO8hThd/yUse2/mG8uPP3ZhizhdPqH87OGCSwiGcjImWhROmEwIHX8O5bi09/R1g+e0gEa986HMSSjb04vDmqBTee1N1izrZwXn2dnflYFp1NAIcozE1UubGPh4Y0+7IjnljhbOMgkSl+ERtklK6QUvmjiU5DYUzDPEF+mBNQHK3IEImtt+Mk3W85I+s6OonaffCUpoH+4/tKnpXHDH9ODtMsV1DPyq6s3KYo58ojTkEhqZijZZYR15bY6l8lxKr9PNt15k1Cp4zS7/wFktp57h6GQFX8nJ38VQ0R6I9NzkoIHlFvANLO5D0oYq8VubQVL9DwLvKZvjbQ6Ly4eI9aw8B/zy9wII6r2zySL0aU+rJQQM9vuv4df7I2HeON0tPh5G7Ceo9Pn/C7YIJLjbeCYTn7rfiADL0ej4tQAswQRXdwCtnz7brYWySFZ2WoH6tH20cwpz2fMbKSqkOrMmbb2uBrNeI88M91AO50pjP4NArjv+PCK0mT0gBKEbaBVxkl2qR
 PCAQAmFX
 9R8qh7/814kWyneC2Vq2eFtPkeLRhtYUYIlJj64HuJ/bzxc8UWC06fYkDhu9BeZIRjAmamsexuxYxlwsDB18weSdqLR+YsFB/VIh8fx0ACBtM+fRFeX754zjzmX5kQb5RKaeafJNeyXm+/Gqm8QYtf6R4YoKWDkTZGKXd9xNxzTosrsZuv4ESAxT/pNfm5jSAhkRKMxEeuthWKFd7piCpvLZ5YBCjT7ftsbpCCi+YtiBs7sz6oUSNlnIQmpzjKph/3W3rb4yfrxgWzoONlavGtmO3c7kS9ZJBOSJgKPdiEkGEojRDP6sHIF8OOrLYOe62wv50CP/yUjPikJftXm6M8bYLIY+GZbjvPvw6J9Z4eLTnPkYAzE1V1+YFnKmbtxew0f30ibGUEF3KmWlF0YJNps1Yfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Felix,

CONFIG_SLAB_VIRTUAL is not in the upstream kernel.
Maybe you sent a patch for a downstream tree to the upstream?

On Fri, 13 Nov 2026 23:13:30 +0100, Felix Hoffmann wrote:
> Under CONFIG_SLAB_VIRTUAL, freeing a slab queues it to
> slub_tlbflush_work. The worker later follows slab->slab_cache to take the
> cache's virtual-slab lock and update its lists.
>
> __kmem_cache_shutdown() can report success after the last slabs have been
> removed from the cache's accounting but before that deferred work runs.
> The cache can then be released while queued slabs still refer to it. When
> the worker runs, it dereferences the freed kmem_cache and corrupts its
> lists.
>
> Flush the virtual-slab worker after confirming that every cache node is
> empty and before allowing cache destruction to proceed. This drains both
> queued and running work that can still reference the cache.
>
> Fixes: 0d6f38b78adda ("mm/slub: allocate slabs from virtual memory")
> Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
> ---
> Tested on x86-64 with KCSAN enabled:
>
>   - on the unmodified SLAB_VIRTUAL feature kernel, a stress module that
>     repeatedly created, filled, emptied and destroyed a non-mergeable cache
>     triggered list corruption in slub_tlbflush_worker() and panicked the
>     kernel almost immediately
>   - with this change, the identical module completed 10,000 cache
>     create/destroy cycles (81.92 million allocation/free pairs) without a
>     BUG, warning, KCSAN report or panic
>   - the fixed KCSAN kernel and the external stress module build with W=1
>
> The reproducer and complete console logs are available privately on request.
>  mm/slub.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index b4c64b2bbd334..dbfd42b31a0a2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8541,6 +8541,11 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>  		if (n->nr_partial || node_nr_slabs(n))
>  			return 1;
>  	}
> +
> +#ifdef CONFIG_SLAB_VIRTUAL
> +	/* The TLB flush worker still dereferences slab->slab_cache. */
> +	kthread_flush_work(&slub_tlbflush_work);
> +#endif
>  	return 0;
>  }
>
> --
> 2.43.0

