Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C96D4A5FB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 04:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D616B0088; Thu, 15 Jan 2026 23:41:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C736B0089; Thu, 15 Jan 2026 23:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89A66B008A; Thu, 15 Jan 2026 23:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D59966B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:41:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AECB14053B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:41:08 +0000 (UTC)
X-FDA: 84336577416.26.334ADEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2E47C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:41:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kL1nLktg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768538467; a=rsa-sha256;
	cv=none;
	b=2IyU0NuSM6OEq51KTlmEfyYcT6WVB+a8GKyQ/gbXfGoD6LZJW78RLbgGR8rvtNb+SQpf7a
	jwV2kFGN406yZr4o38HTgkHZoscLOLXrQ9et9nUqNZV/W13OGPLHzw83mSeFlHycMTIqTs
	h9QcjeWJxxc4dLR2z+Vmkc5Hba2QvvM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kL1nLktg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768538467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDlH9tX7unbKRHpcn7Hphf6tOM03vv012UyJB8wboew=;
	b=G7CMq4E0VyNHc3q3brQJP9mqzwQ5zmFFV9VVqqqaDSGFSx/P8fztlz6gUQR7p8QotGCt2a
	8QxgsCYi1nEOjMWbL2TqIydtmlLBmdHHcCXOoJacSjO2/ZSQ8I3hPWnFaHiIWMzYaLQoAf
	WrJp/UmQNOlozNP6p8MTGMnHMkoh5AI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E022A60167;
	Fri, 16 Jan 2026 04:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5CDC116C6;
	Fri, 16 Jan 2026 04:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768538465;
	bh=ZpX22eDLuTWlfJ8zNQ8HMDTydSL8IN69+Vb9901rPJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kL1nLktgpPSzsoZkwKWH3GeDy7wYPC21Oo5Rfw6Lo7zSaJ/w1EP4VjBbcTkDEZO8j
	 3HdKlwpvaovQqSM81fyFkVPNczcO/kfAFaS6gV9te0MIERnOTLmyMg8DqKWywfVg/9
	 rDVjaAqCwgD7vBbrt1sNDgz9JYc7qbDkpi3WBEPr8qW8l2Ho8OnNUZGc2yzwNa7NMj
	 f09F3KrlLMVpPDEMeKEewJ/SfMci4K6TRiwPWUm9khhCJEXfln9mcgmg5jz8dmOBOq
	 Lc1SQQbGXNX61tPpRDgQp0HMjT8PN7CVOQFKuXSab4AhlQGfAMLQH37lWR7MUw9Buz
	 mamjg+1UBgElw==
Date: Fri, 16 Jan 2026 04:41:03 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/readahead: try to allocate high order pages for
 FADVISE_FAV_WILLNEED
Message-ID: <aWnBX07vqjKAV4De@google.com>
References: <20251202013212.964298-1-jaegeuk@kernel.org>
 <20251202013212.964298-4-jaegeuk@kernel.org>
 <aS9uod21hG_qq7Rd@casper.infradead.org>
 <aTCJ0Js4X7qlqzDZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTCJ0Js4X7qlqzDZ@google.com>
X-Rspam-User: 
X-Stat-Signature: seecqe6of6rg8orwek1q5guhogshrcap
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2E47C0005
X-HE-Tag: 1768538466-201170
X-HE-Meta: U2FsdGVkX192Zt17xMkUvYWLyH83RgE8hiNadCdnEL7zGB2G/78Rx3SPHvZG2+8XE8yrEzPr87wBnyHp+x8y5WtBxdmw/iC2G1DnURu8E1gJn2BC/OxJ+twL/yGPWlvKM/K3fj8+5U/qdb0R2BqR+XAm+FsZsem6VvJWvAthBaVkqQDFzFG9LruXrpNtp5W7OoC/rVH+Oc80gvnAIGhWm19tkN2ArB8IOO+KtTRzY9g+bcN5X+6Tn1b/9SvlBqOP6P1mSONfjFNy8SLzW7kDU1CkJHp4B2gr9JcfaoUVdhrCy0RJwlUZE8USA0lKEKSJk0IKy3N1M82nJntUj4u2Kins3rIPdbuVtocbVPCT9eLF+PqPKjV/qMkQXMYU6RL89+sk72bA6wpcalUREgAsouBWmMx/ljfhuWmXDDF+IH2MvNJbEeyyCqx9gc8ZnhbAeIyqu7cgrR5Fr1J/XOd902MIHui0KCcuGrYxg86ulMDQJ/WpiIdX+P1R4oSUqVsIQ4mPrimkW8+rSabCt8UbTtrfynC3XNuOrgZEdWbGeGP2Kdg52Ge8u8SAzX9pM2EpVLCP6n36lUiSX76NSJyRuqt2wrF1fRgzwfHfhZlc+FzhbVJGnVcBus8qmX6TyxJh6q9TKkW8YdUKm+YvKmHs7KN872gaUw/rYX1Iy8zDrIfDipurwGVK+qXkUFOJ+hWAk4YIwIuDz48R68oKLEcECDgG5UIy3p01YHdoVUhSgXuPmOfb3XYhpvBbAbR0QuDYgoAfvLhCjmbdSzoil6QqDIpIVZl6OShesg7RPEwl7RoxkWaSQLobjr348divbjIZCzfNTFEjX1j266wIe2SPqkgP96SNGETYF7a1EePKvOFT3wKg1H9u6prW7lnqP7TtuRLKBPTDLFWuAU8uzG7VK7VXFh9HKk6Yq1wgW7EcuiRZgP13pTmrScLaYf5iEqF2bJkF7VOJsNM+RYI3Klg
 FVj3btw2
 bxGemlknjDMndjpNUlr2QGUdQPZDhzolDuKqkMsho+yyAMf/KIDu8C29ru2q/avXpwIXHuib0oMk+SLH0rvWiYHBAUlR9HeTakKPr7PpkuVZ5E/OxKGrZx02jq4ZLbdhofHGyO5dT6oeSEIiHkxETTfvXExHnonBQNmawxEtN/wDoY+U8srfrGILRJ2dZtrNIbeq+bzoGXSSHXcMV73BGj8SsroCZL7Ik87EMHJQpzqxLtCQ5couMeUv/2uAJKIniCAooQBvJBj+M/VFzXKFTIK+Bdc67kmC4ZCQdVIP9JNrk4+8YdEA9GjIcU8tfTdQhsn9MlGYsdG/Fa+E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/03, Jaegeuk Kim wrote:
> On 12/02, Matthew Wilcox wrote:
> > On Tue, Dec 02, 2025 at 01:30:13AM +0000, Jaegeuk Kim wrote:
> > > @@ -627,7 +628,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
> > >  	ra->size = min(contig_count + req_count, max_pages);
> > >  	ra->async_size = 1;
> > >  readit:
> > > -	ra->order = 0;
> > > +	ra->order = mapping_max_folio_order(ractl->mapping);
> > >  	ractl->_index = ra->start;
> > >  	page_cache_ra_order(ractl, ra);
> > >  }
> > 
> > I suspect this is in the wrong place, but I'm on holiday and not going
> > to go spelunking through the readahead code looking for the right place.
> > 
> > Also, going directly to max folio order is wrong, we should use the same
> > approach as the write order code, encapsulated in filemap_get_order().
> > See 4f6617011910
> 
> It seems the key is page_cache_ra_order() which allocates pages by
> ra_alloc_folio() given ra->order. FWIW, madvise() and fault() readahead
> takes page_cache_async_ra(), while fadvise() takes page_cache_sync_ra().
> And, the former one has a logic to bump up the ra->order += 2 by f838ddf8cef5.
> I think it'd make sense to match that behavior?

Comment by any chance?

