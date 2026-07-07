Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AC9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3936B00A3; Tue,  7 Jul 2026 10:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794B76B00A7; Tue,  7 Jul 2026 10:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683736B00AA; Tue,  7 Jul 2026 10:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9C26B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:46:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A84B71A0497
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:46:08 +0000 (UTC)
X-FDA: 84962255616.23.781A472
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0839E100006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:46:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpkPQxRV;
	spf=pass (imf05.hostedemail.com: domain of horms@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783435567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38uJr8hVPGVJpV7RT0QtVixAplTyJQKOmyP/3Wvejkk=;
	b=qY3h+NrKsi84N5MQg2aSTcSJFLzeChAgCfXq0LfYjchvxYokcfEihLeDRsWMqPQ8SRTgoT
	iYQ8oEThCkkiAiMC2gqwKftiT8dbYZJtnnecybycyDpFcHcSjguLFBXy5hdnNNW6OxXzZC
	+wE3s3X+4eSGHeoJq7rovjJerIY02Bg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpkPQxRV;
	spf=pass (imf05.hostedemail.com: domain of horms@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783435567;
	b=rP+RYnjWnrlBdYPuiZwBwbQPKAn/TVcYyVP5IHSln8HyZmog2yFBnSd3DkF4B10jyjSkRK
	/PO8ClBEuXwAopHK7NCg5dNNKHLj4rH3kHFRkXXOquhiV1bhji3m39sPJl5OnCBu6FYJnf
	DVlpdHR9VYuLXCa1WVhqwWfDDs7br9c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 876DB60018;
	Tue,  7 Jul 2026 14:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2066F1F000E9;
	Tue,  7 Jul 2026 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783435566;
	bh=38uJr8hVPGVJpV7RT0QtVixAplTyJQKOmyP/3Wvejkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BpkPQxRVjX7WXA/JEprOiZavYtpKUwCoXkGlay8OFTxOO3pBbm4Srga6ztyH+1G9J
	 lK186j+V1CMVof8L6JnsbKESfM9aIozW2Fx5vLrzsSg8fNxMP82rXmD1RvGKwxmWTR
	 toZSpjPZFfeMKf8ftXcFnxIWjZ59vBwOUbLfRcTdXK9hM4AdfUY23GHcs17g8mi4Km
	 sYOaH1qvo7ncsQHtpLwY+T5IIOGF8UlSyExgMxbNm0iIpp7tzTLzlWINFiO2aFZki5
	 mTuTothfBivZ9KvlFwlGUoGRccKPFG9tF5Q8RAWeV0x0tDP9G04KiXwRTm3QUUMy9E
	 m4/nOvrkforfQ==
Date: Tue, 7 Jul 2026 15:46:01 +0100
From: Simon Horman <horms@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/net: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260707144601.GH1364329@horms.kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0839E100006
X-Stat-Signature: e1arx7jaz3tj5xiczm8wtit4j4oprcci
X-HE-Tag: 1783435566-610935
X-HE-Meta: U2FsdGVkX1/0wZIlOG0aERpD3lJkvwFhrN830zpJ3RXrXbye2HdvsFZLMwfecD2ZOJ1vhHKVc4qTV+5M/fU+2l17RQZJPnt5RBl+vq2c1PAn+wXc37uNdWWDHx3fh3Ur11RYfR9dIytKrMrYBdFPt+eXhhaU+i2NpR7vltu3Vhn/LNAFJt57+0WEiyhd+LJ8FjW+UUsFVX42usynq1cCtDqJlLgBoQj+6nInTNw3Ob77KzCsP2l93SvF0xouw3j308HRE1fLaj5ELE2F9VybSUt1TMwkMKowSx8MCXzr/zrS535WVlg0dfcY8CoHhWYY2Bveuu3w79SHjkV+qtpQsFU3UD5dSDi4KfDOuMakhcph4eDBG4eO8xpNU63Scl9X1Bns1t8woenjHgMGI0nbnUQjNqkJb40HkjAgf18fWVCiIwq5JEMPlHlu41Om7JSXCqrU+qwSUy95GAxPbalg+aQPvdUYvQVbmo82bqjkayVhFtSM/6TYMWqBgUSa9ie4PWdkeBZqSf3JUOkMWN9K6G4CWsGZraW+5WedU70zjaE23rv5UYSBsvvO/PRXsXC1pK/bli7tJI6tqWzKFBAAbe3U1HAFhw2cqfiHCWMk4w9oxa/VArxTyqur7M3JNMMvj+Z2hCiRwHC2zxy/egT0qifFFjo5cBKpBPwCEpCKc4wj6VESaYWkPVL1aT0lF7fj0VPrCmAFE/A4tDghJ1HzZsg1zfSScN35A6pbid6F/7iypECwmyz+AMx/Hiy6g+t1jliFeCaFw4/8/s4fr32/ABelnXvFq1/Uwe2pmJjtcdfXZOfYQJ/ADQuJUmvlJO+is9o6ymretWalShA0ESU+rZVfHdpF+vMyFVkqcpTMeYrRXtPJVUGGyzdJyjW6IBt4/h36VybQzoTBSFdNMAx5MNrVpJlvRO1q15FwYYVyFpGAfw0Uih0+vyarEB2HGPSrbldgLVQxPrBxIjWYzsx
 UuI2qL0q
 HJVk3ws+5z3kd88KNNK9RuxgFEkgQMdYqvuI/DiB2FW4CM55L+G4DvY1Dn9FjXYmZm6EKfpZgBNoSqfoyzsLowuxNT2hTaKnjKOPFKwVN1LwljgPYsatPwk+sFGeBFLBB7CQrAmUGjC7bsi276GhGfuaUzIvwE/B2Aljh9haC22QoVaCdmZYjhHlMwqaajfBUxD7qjvNbyh11lVlvBCJM8bDFNreAIIXSqkIkQclWbBRYyKEei3Q36Fzhr60BX04SrglN2pmLqlXuBe9hgJ2ZGvVIl2qdgms6aD4iML2x51rSUz49GlhiiuKbC/dZ8FEJEwdaPpNgZ+5NJcCXuVsdq63IR6wK3KZegu7TxSYdbTg0tNfJwQmpan2Su2DAcowEOH2GusvpHyVy3SgszC5sTh5uWS79yZgV/9hvVgnOd5KnjvrkWAFN6/JLzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 04:59:09PM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net-wireless
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/
> 
> ---
> Changes in v2:
> - split out wireless drivers from a larger set 
> - use kzalloc() instead of kmalloc() + memset in b43legacy
> 
> v1: https://patch.msgid.link/20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org

For the series:

Reviewed-by: Simon Horman <horms@kernel.org>


