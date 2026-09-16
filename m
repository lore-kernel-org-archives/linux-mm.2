Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57DAC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FBE16B0088; Wed, 16 Sep 2026 19:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235E26B008C; Wed, 16 Sep 2026 19:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2BC6B0093; Wed, 16 Sep 2026 19:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8B1D6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:36:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 802DB1601BC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:36:46 +0000 (UTC)
X-FDA: 85221237612.21.99C4B0B
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E3B3180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:36:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CSYKYSSs;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789601804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQ2WhXjZQcs7dOdUbW1cFsewyIzIB+WiRGJP8M6lARc=;
	b=V2m067XCZENnzLfsoA4DvOlhiMsE5gFPDrpz0FU2qqchwhjXs+oPEuoUH618wv3Ru8+XPV
	cDb+s8OAB5McGEObKRCwS77l5NDi+JjNoDfXTseDuULyJIvzOEAjFgNDuxgsxnYOWTL7Wx
	fl4uzNK0WISygtZQyspgH8ksuQLv3hU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789601804;
	b=wb++R49ex0lFSVYsewvI/lqWXPewHUR0iyW1Y55q4v0QiA17/FXk2d34Sk6tVnzOMYysX3
	uUXMGxp0KC3BSBaTQ4HRfRjHSFXK3EnvmzTr3CElqWQrpfTHPkMy54r0+jcbkxMkQSmhSe
	UJkbypLs8D7fHxHgOb5A7uSgxZkMoUo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CSYKYSSs;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aIdtu2I76j/DiWgc8Qm/F+IYAetiKvaeuxEq+WvqmeQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789601802; v=1; x=1790206602;
 b=CSYKYSSsHDrr/1LEPdYZWXPkx2B4IGIC3rTUCrNaLWzQkZaEPaVLoInHtvBnH4WsFYIiSUiM
 prnewEIAExPf10/owxuXNg/NELT8M59C4CLsbV7E75+wLIGddNmtXxnjQu+L7Jnd65Wf7xPrQIN
 DO/fmpr5rPWxnsC3u4wRT3RU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4af75b0470ea2add;
	Wed, 16 Sep 2026 23:36:42 +0000
X-Mizu-Trace-ID: 4af75b0470ea2add
X-Migadu-Flow: FLOW_OUT
Date: Wed, 16 Sep 2026 16:36:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, david@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] mm: filemap: move lruvec accounting outside the xarray
 lock
Message-ID: <aqsn7pG3UTECs3N9@linux.dev>
References: <20260916125122.2696271-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916125122.2696271-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E3B3180004
X-Stat-Signature: 91gwpj6wfbn34zafjzy6hjnnoycfsip8
X-Rspam-User: 
X-HE-Tag: 1789601804-500737
X-HE-Meta: U2FsdGVkX18QfNfhJXuI2hLoVsIkRYvyfbYjLkygMxfzBk/snj/foJyvR6Zs7MhdqLsgFGnLF9IX388855fRLT6BZWBbDZUNBlHJEqCnIdimGcsLG42WOQA+PbmbFtPj87kTQ0fsuRcJuTi2NzUTw+tse/9Q94Vd84tIlq5x9/VqXkJo9KwwcZrnJ37CMSSzdLjf0hWMAmI5OEPX8Hx+lE+DYVeaHYrNVDj7BzvBiPWHaBi9TQUlEd6tfqubZTcZSNQ3hnP4CvcQb96Poh1o1TjHziA6Tbu5t+S9PuSvWCuobZsCLeE4sevqFMwnsFqzKuG+jFkZqoFgixeedVWy9Af24JyDen8R7FCg2xQVHlYnJEh6g4Rsf4i1U84VKA0v9S0hIDF7AzyJiYfgHY88bg34eA+2/DmbhvQIKwApf2bMZYVro0XgeTjQedqxoombCXbg6GKUcpjhZ3Z8UmlNba2jBWNuI3nh7W553o2KVuJAtIdOGr5TpNGYHxlMdPW6DPeOfs/1hMf7KL1Ph6FWueWU8KflSyLleFiv4CyoZK8Syrw5JakNe7EFapWjulTfMmUNNm9e4dISdr5vif2MZUcmFI3ShlpV8qRyA5Rs1d6byRDscpiLuT2bSZCSLmBL7qUfWAHa/5BjwbbRf6N0+VScEOOkbKoZdOeLhJfPAvMaRY4mrFPxXxZULekH+mtA5yz7Rn956mLeLpXS4+4wC0CjWpwDhcXLGfRsJMhQCjIZY4GDIA/jdXWjlmeJ3Qvu3wTXulXnZqq8FjuU+u8OPJ1nwrucpu5zMINUQ3VvMIHUgNbIlZBNpdKhr3+eQfyL8YnzWBLeYAbP/FCVA0yDPvzZRGCKUYDs2SKJzlkKjBYlOSaOXQ7a47BuKwAdo6CI+32G2xA2rScMItHIEPg57xFEvj1EYuG+GjZ1QgylKC6bN8BWaln2JHjvy2kxRwbl5SV0lf32ux36+f+nJdT
 cGcwZvW2
 oKwn1kkliGY0L+ciXcJC63FVQYu85S7wbxv85RPLNvEQzZrJa0/IrClQE4Peg3u3rhiaXXcMO9Is6BCNIOhUeBoRW1FJee09FW6iTugftwmxN7TWsQon88L7geLdkX8yvDA1nysRWqCenSx5NooVWNbqyz9IleUyd0JiRNRFF09Pz80HfeudYuNOL2q7LPfgqQZN9lZiFnwIH4WuXJcpMhDj7noAYCCWGwvT56+Vzdxu8WZwhyqXAxU+Shm+qN1LK85Q/oQ2GXu0siU0gXDmVsgWdbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:51:22AM -0700, Usama Arif wrote:
> __filemap_add_folio() inserts a folio and updates mapping->nrpages
> while holding mapping->i_pages.xa_lock with interrupts disabled. The
> XArray insertion and nrpages update require the lock, but the lruvec
> statistic updates do not. With CONFIG_MEMCG, those calls also update
> per-CPU memcg and lruvec counters and notify cgroup rstat, extending the
> critical section.
> 
> Move the lruvec accounting after a successful XArray insertion and
> after xas_unlock_irq(). The page-cache references pin the folio, while
> the folio lock keeps folio->mapping stable and prevents removal until
> accounting is complete. This moves one lruvec update for ordinary folios
> and a second for PMD-mappable folios out of the serialized section.
> 
> In a 30-second system-wide perf lock contention -ab capture on a
> production host, the hottest caller-stack record attributed to
> __filemap_add_folio() had 20,867 contentions and 557.930 ms total wait.
> That was 14% of the 3.998 seconds of aggregate lock wait in the
> capture. Moving lruvec accuting outside of critical section should
> help optimize it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

