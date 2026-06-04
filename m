Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B743CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B1F6B0005; Thu,  4 Jun 2026 15:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAE36B0088; Thu,  4 Jun 2026 15:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D009B6B008A; Thu,  4 Jun 2026 15:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C08B96B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:07:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C2A21A0268
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:07:12 +0000 (UTC)
X-FDA: 84843163104.30.FC8B623
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7D7012000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:07:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X95QMe1D;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780600030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPNx0ceI7jZ/wZ7ZeuZoSeTQHDWTmdvA1iGMDZOoaVw=;
	b=2zL3nUpl+IpZTt31RLOr7Qe4h/TqLMmywMafYeKb8S31L26xXob9I5TmKvp0uZe6ceYNGs
	h/njRpQyKvgdX0qCAnbf3SXf0T6o+hRmXVhAGhGBg4UxYedLu8ajHi/of8WbV89IDDeMDs
	VVb/CznhbGYHI1Zs80lVB+EDNvkaYrw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X95QMe1D;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780600030;
	b=3omdjjWW6Goe6gNROkPpXAnxHT//fXEEf44G4ygUMwzEP6bdQLDv7thx7zyOPCExlG1/j0
	xHeCZwANVrMfvdynasTnm+U1kyeeRHmIZ8aA1FqVoncXl0qikFLz/MXrDVcMkgStCl15Dd
	vXq1CmenhMotOC5BEG1ImLzu4YGhssc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23DD460052;
	Thu,  4 Jun 2026 19:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F391F00893;
	Thu,  4 Jun 2026 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600029;
	bh=tPNx0ceI7jZ/wZ7ZeuZoSeTQHDWTmdvA1iGMDZOoaVw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X95QMe1DQa/bJlL5J7XNBmh5eWEZZpUvPc5iH6tAfn7srWo9BFzIMrHrRCpQqEYT7
	 yIS85dWrunomN7GvekNplK3OwKOtRGBKYDkIpVnVNS4kCOZH8lG3DsRoXWUrG1xTKX
	 PvIP+1YCFjvAqfzbl503rus1E0k4bL1Lh8whxHQo=
Date: Thu, 4 Jun 2026 12:07:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, Uladzislau Rezki <urezki@gmail.com>, Pedro Falcato
 <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>, Michal Hocko
 <mhocko@suse.com>, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2 3/3] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
Message-Id: <20260604120709.445c027637b3ad72ad13279a@linux-foundation.org>
In-Reply-To: <20260604113101.89510-4-kaitao.cheng@linux.dev>
References: <20260604113101.89510-1-kaitao.cheng@linux.dev>
	<20260604113101.89510-4-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7D7012000C
X-Rspam-User: 
X-Stat-Signature: wa946ns73rfq67nc3gy3ttyq9fzttuhg
X-Rspamd-Server: rspam09
X-HE-Tag: 1780600030-524591
X-HE-Meta: U2FsdGVkX195CM5fxSWlpddrEtffLh8gQb8AzRE6fVLYU6kZk5egvfejj7NFeRzV127nD8HodGnOzyds0smhFP2GN08gR1W5yXpnBVi/lJoKvDbMaqE0hxkyOjzRNO3Nsjq0FEJ/b3P0NIUGMI7fhRuiSN2pBAksJIojuyPR9vFg0DyC17Vx6+00Ton0H6MWg+Scifh+HKkEzkNVD96By/tQy7SoSgDzhKcAsXPxBe3P39+bgpUo8uu4dHUw1ZHsE/p1xfNu3IheM4f7Q1NkAQUyEQC8ljA5i/gH7PwI2nki7KccERsSkoJXD7t2rLXrvOiyze6Y1E8dspkj6DwO1y74XiNHg9SLPLKD1hlRLv/yPfeymM39ZG6f/o10KZvKT0cNLze6WEK4XeqFMsQUcsKAJkpABojPtRcQZHfu5p7YCLIinEgCVJB1/pjMUZA9ROgwLbQhlPlr0XnoGkdT+UtrTJffiymNgGO7Vxrq/iN8OFO3dq6CyImDx/YVfDNExICZrLW+QaBB5MOyhwJpuIG1KEVnyEK9uZ7dMUcHKpP+KFpX/3eSyWNFC69hN0fRGEsorgZrSFQ/zITgf+t4n71zEpbbWglB+LIgxiL8cs865D0dpLK5F8qu+Mpy7fAT4P3wKMlNPLIVGtRYZ5gD1GxAe+yGSgPADvzvyO3pbMCpdRIDtfQqFawBOgSriMiqxClXUs6SLEfUcr4pPVrKQxKVYh7QbnvTXhR5KGYigfOtIcldZbF8UaHonlrGwWspfJUPGBjgrJM1FpIRLi6axiUzsmL8ogFSB2snaPY4qSgQBl8Xofc9QCDitTtBxNlv+Sn/H1emAsW1jPsVFxoGZvGjAJzU6DWFGclbo82NUsxp9cZMrTirYKNZsrl0riBn1x97bAMpPKn3DCm2XQSBR1FAMGFkSWK0X6yzU8XuKO02U3BrYgWcb4zVfqXyBObEJpyrf9YU9pC7omOFsVC
 UchjxHPl
 I0sX7vMySiM3a6hiwb+LhhqQepE0t0WxKuMIHMJMwwDyrSlgKHOCRjkB3xaatvUi35p2Y3qLOzyjtV/qBSZyHfC9Am6rTlugwnBZ6A3EOKU1QrkiEORyv2AbsdG2RYxNdRQzIl1viUXzfhGEMtX6SFnTyvBZjtzAiZrnR15MQRrZr8hNkDpWrVW/LWmhcxrKRx/NGrYD9/+SsFrI09ECrXblQlUP57se+xrNCln0vAsT8mpAR/n3pkyJ8bZ1Nw+rmBfntvP95hzFrPEnnOPHMIOr9n52PPH2Vaa7TUIBMbYB4jOJvNVxlVQyKnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Jun 2026 19:31:01 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
> failures, but it also makes the mutex visible to callers from constrained
> IO/FS contexts.
> 
> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> pcpu_alloc_mutex. Since the internal allocation is not constrained by
> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
> 
> At the same time, Thread B may already hold an FS lock and then call
> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> pcpu_alloc_mutex and block, creating the reverse dependency:
> FS lock -> pcpu_alloc_mutex
> 
> This can still form a potential deadlock cycle.
> 
> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
> The public allocation still uses the caller's GFP context to decide whether
> it may block, but the internal memory allocations performed while
> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
>
> ...
>
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1726,9 +1726,8 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>   * @gfp: allocation flags
>   *
>   * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
> - * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
> - * then no warning will be triggered on invalid or failed allocation
> - * requests.
> + * allow blocking, the allocation is atomic. If @gfp has __GFP_NOWARN then no
> + * warning will be triggered on invalid or failed allocation requests.
>   *
>   * RETURNS:
>   * Percpu pointer to the allocated area on success, NULL on failure.
> @@ -1749,8 +1748,14 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>  	size_t bits, bit_align;
>  
>  	gfp = current_gfp_context(gfp);
> -	/* whitelisted flags that can be passed to the backing allocators */
> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
> +	/*
> +	 * Whitelisted flags that can be passed to the backing allocators.

We're supposed to say "allowlist".

> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
> +	 * waits for the same mutex.
> +	 */
> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);

AI review
(https://sashiko.dev/#/patchset/20260604113101.89510-1-kaitao.cheng@linux.dev)
asked why we're currently removing __GFP_NOFAIL here.  There are
probably good reasons for this, but it would be good to describe them
in that comment.


