Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB6CCFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 11:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC3F6B0027; Sun, 30 Nov 2025 06:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3B16B002A; Sun, 30 Nov 2025 06:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510C76B002B; Sun, 30 Nov 2025 06:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEA76B0027
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 06:32:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDBE05132F
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:32:31 +0000 (UTC)
X-FDA: 84167060502.06.80C6C09
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC5174000B
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 11:32:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector2 header.b=Fe+6TaUQ;
	spf=pass (imf27.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.37 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764502350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOYHCzYNL4IW5t7SZZIqadgltwGQwxY9WRxQSDt5CGo=;
	b=OUNQ5dQF/NohxL4W1AnDwt4OGIvZBQxky+I8iNZWC2GX/qJz0aBGgfx5mhuKH0H1X7+991
	cWlWPYJXBpXYpfOhQG9wWoB+zO5ga12AyNNyFCKdv1X1Bdu8cpkqnzb1xCYEmVAKiYWRut
	GqqaMib7QkZnxO3KD70Gvupr7QVvQSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764502350; a=rsa-sha256;
	cv=none;
	b=YYrE7EcnIN4pkGb9u/0F2bbM5ELlgTYU/VKgOzejZ4B5WELbf9ATUzv0khv6KdC3i2RT4R
	hPhMW2ZcAhnNbMhIYwQ/8uYxnFkWSF1kXhAq7WA/khjLKqevfITImMekhZQb1fQ0Z4Cdp3
	NTRE5vYgxzZdNaIPoSlywATWMzltAS0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector2 header.b=Fe+6TaUQ;
	spf=pass (imf27.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.37 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vPffG-004aJe-Ks; Sun, 30 Nov 2025 12:32:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector2; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=AOYHCzYNL4IW5t7SZZIqadgltwGQwxY9WRxQSDt5CGo=; b=Fe+6TaUQl1tgB7LkFOGd/TPUBb
	48vqLZdA+0z2SvwylZj6S40Jz9eB4MgI4piGqjaN/PaPOjdbaw+A8r1KJoQgf5w5recbeDL3zljbP
	rXGiao4q4/U2/zkDKODDKo3KqrnYXdF5aiIX7rOQnWJFM4NthXqLtaKpPBye/pql+cIkF7MaWHmno
	n0zEmVgdbHTA7zDrfI1Xorl3nIKMzbdZ80bLsbxAElzvMdqtfUpeUf3ppIOW1s++SAO4QFvL8WL66
	UhAGcNxz4CTA+j8BLsFcgia4ZT4di0iEjGb9csrlyu+k3beNl66A5JlDSUhHumDlBsWUh32+dJ5xf
	K9WUkOgA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vPffF-0000ec-W2; Sun, 30 Nov 2025 12:32:26 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vPff5-0051X4-CY; Sun, 30 Nov 2025 12:32:15 +0100
Date: Sun, 30 Nov 2025 11:32:13 +0000
From: david laight <david.laight@runbox.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130113213.40c8e7a0@pumpkin>
In-Reply-To: <20251130030146.GN3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
	<20251126185545.GC3538@ZenIV>
	<c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
	<20251129033728.GH3538@ZenIV>
	<20251130030146.GN3538@ZenIV>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: h49h3f4okn41eztgb1qd6y1u7d6gmj9y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC5174000B
X-HE-Tag: 1764502349-259922
X-HE-Meta: U2FsdGVkX1/pmtREieyr1G+Ik66szH72m712ipwE0GA7Q1jPURA61i1TDtEgEVoxCNwYeu0f8xt0Wp6+n99xCJCE+UU8ooiO6a3Q3GruvtE+3Pz+pGxhSIeIowVHn3v84V2gHUNhtnFgewimI7wARaqzZwUnhfMYIAjxMMhQF676NnMZVdvtbr1feGY2duzBRHvImYdHPIu52NUr4prlEZu7X2/IEDn5QZA+O7y+Adpr9Jn5fap4Fiy5NjKkJ7ipRdHdSsifIMEPf95/EZrRADXoH1v/9j+bf8ibclctAoiZRtqR3b/d9V5l+93n994z3OLoZo30LlstlrZtUnArcYZv+/J3y7efR2mfWtUvmW6jsyH3heofbvbFhojV/JTDrUDcSKJzXhnawnSk6IpoO6+L0xKq+NwlfQ2vRu/mp2xO42A6vRbllkvwgmEUojqPkDq3dyMiWIQlLRliEBl3gI8U8u5QH9S3M9JyIT9HNW1gDxAw/aZ6HQEFSYRhUYHwKWRYPbGI72xTTs/SKd/IkU24oHiiR23Y4O2GaPs0KupPB1IgrINq/EM6/gvF6zuMl1SeF5wENqFsn+in5J10XD+aXO7WZyqBy2eeeViil5PiiXWgKJlXyjWxIooPiBP+L57oe5NVAd9EfJV7ROQ5rIYYNBI0iC/zgNP2lTSePpAc1rwci/V+7x9KA4b4CIIb0Q1XqbFCkyBOT+HWPsPh3uBqtaov71qY1pGmIbyo9bV5xVY+8vKwaeLFTtrET4SJm0pgTRyT2ORPp4grbk21clKcnVEUSXlPkLjwQbJr018WjWHM/J/p56hmJndH15WPrrDE/oEt0oCHN+V+vwO//LYMKlqYIzE/0KLqL2obwycYkpFffAB33sJkOB9AAICHCheiqZX3DHBZvzrCgxCSFftyHjAQYsPC/NulwhxDEBJ6wkgrb3zTRLz8XRQJqLKu8RpbQR5wlYYorXppnou
 PZr3YO9y
 WB7/DkCC3UR00wy8a/rYjzJ5zT/6R8o10HkC/Za9OouK8E+jZQVrccILioEwoggqNKKsk4IHJHy/5oPLhHlH5M/K6iO/fLnTU7ENZDl5DOCnXEvM1Y4eT8b2ssl31+hqqTQ8uIslT/3Z5Gkdx00ErdBlWRecyx4SvOWR8eD9WYcdzTO9dI1eYF+aKpAh8vc2plfQqyA+G/dXy8eLhzK3+hMYBQSI7tOP3BzMRbo9q01M65BoKMgQC8lhB2lXZ40BgPC86ZxIsAJXKBJZQ1rwlAiMWNDSRYEkFqbc7lw6aQzYJU8sirFco0jKLmWERgpy4l8R5u5i60/tgGaodcolxp6B/4fb6foek2aPpn+TmDrj9LrN7FQC/Mumx60UG3+VHqVwgML6pXI7vc5HHIM6bvbRwCiIrEKS+4bBa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Nov 2025 03:01:46 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Sat, Nov 29, 2025 at 03:37:28AM +0000, Al Viro wrote:
> 
> > AFAICS, 32bit arm is similar to 32bit x86 in that respect; propagation
> > is lazier, though - there arch_sync_kernel_mappings() bumps a counter
> > in init_mm and context switches use that to check if propagation needs
> > to be done.  No idea how well does that work on vfree() side of things -
> > hadn't looked into that rabbit hole...  
> 
> BTW, speaking of vmalloc space - does anybody object against sorting
> CONFIG_ALPHA_LARGE_VMALLOC out, so that we wouldn't need to mess
> with that in alpha page fault handler?
> 
> Basically, do what amd64 does - something along the lines of (untested)
> patch below.  Comments?

How difficult would it be to allocate the pte for the next 8GB on demand
inside vmalloc(), and then propagate it to the per-task page tables.
That is a path than can sleep, so being slow if it needs to synchronise
with other cpu shouldn't matter - especially since it won't happen often.

That should be moderately generic code and would let the vmalloc limit
be 'soft'; perhaps based on physical memory size, and even be raisable
from a sysctl.

Likely more use for very large x86-64 and arm-64 systems than alpha.

	David

