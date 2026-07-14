Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B38C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39EC66B00C8; Tue, 14 Jul 2026 15:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FA46B00C9; Tue, 14 Jul 2026 15:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F706B00CA; Tue, 14 Jul 2026 15:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 024026B00C8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:51:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 684361A04D6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:51:55 +0000 (UTC)
X-FDA: 84988427790.18.CA907D1
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 533381C0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:51:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xbEaUCOX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784058713;
	b=7fN4VdTnF2yUNGBGqOTg/eSpa0bIh9rK7vtChP8crv062Ildt3d1ubUHq+oPix5KCf0LUa
	qLDOaaEs+49p1rt3QzaWkGLYgIWoDOut4DobtLWSLeKaSxowQ5L4o3FlfMCVZFt77cqFtu
	s5ymNoR8KS/aaVfZCw+53KxNTPlpOj8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xbEaUCOX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784058713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cuoijzz0rTY63A4da4n+CjQ+9RFOuE3zmPGDmmxWI6M=;
	b=4two6/oFAcbLmE3nDbpTASF2qhW42g4bjfbMJsmjKgd/dxqeHM7ss0aDF+2oZj7dg1sfak
	xNtBugnpKYvQq/VftyQL9KOgcnB4jrZCpDVlsNGMWqUjaupmvD6mBMdvER9vaOZCkHEsUu
	WOkqi4Ct1IFDUEVTWrbxo/AWRZDEGZk=
Date: Tue, 14 Jul 2026 12:51:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784058710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cuoijzz0rTY63A4da4n+CjQ+9RFOuE3zmPGDmmxWI6M=;
	b=xbEaUCOXuxx8FfZYpiWNatKkOn8twLD8coYe4FO6wtqEyxg+Xc5o0DpNmmhZq091tIF8d+
	DgEzCKaSTpgZl3w6bv1b4wdJ4vO/M/B95cjJk4wLhxu5e80JY+rubyvjdOYeWuf0s9uOAr
	k3jZZEiWpz4kF5sfNDvVwF0yHk0V/hU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
Message-ID: <alaTQeiiTTmKLngu@linux.dev>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
 <20260713113901.GG276793@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713113901.GG276793@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 533381C0005
X-Rspam-User: 
X-Stat-Signature: hukzdnzfzro56jhyrxzhk44ej7ser68u
X-Rspamd-Server: rspam03
X-HE-Tag: 1784058713-457177
X-HE-Meta: U2FsdGVkX1/0ZphbLHhEmPNDZlZHkdMJpPVVMz1upgGG5/otOzbJAdT2ZFD1sEK1Aa6n3uofH75G6WBzYTPzHuqbouNMgQB5YauBJQ9Vx/WzQhyrjBgYU1eqLfPToxNeVw9OYH2R8Qz4YQtMgXl4kC4kt9pNkbsHnydDUiqRnVNLX2qj1M+JF8npSGQvUGLOdsqqRPWaBmhfKlepY3x38YPkhr8jIrzne7hxhQgmWZSLNyN8JOlAUkErrPMt39YB5BqSfR7Vdj+ZMhvjnNhsqw6oKGSz4OHmFl0fIof4AXCvoSFZo7aQLRCtyLqyjSDlLlou8oa+HssrzOLmuPeYFheNWqMsoIlaiZk52mDfUrpC25w+sEp20QPMtUjL6/moF/U0gxG6kaFifwaI34n/1FV73o7kTzFMw6yOs8og+1yNvYAEFU7HpMD2LgOlJwNGpgvhMFQSuRjDvpttNykniT6RRQYSNg8IR9Wc3LCd+ShvbMNx61oKg8NWQh0EohYQUDfQMXG57jCJGL+Lv5OFnQBAL9i8YhShzBXiKF5Z1iTY3SJUW1JFslxH5p+TOu9n1SnzD+xcHCzq+JPTYy0LCanP0rt2BL8jRiMz8JisxDivLLg1hdnKtfTUzdniRF9ytYj6Lm6l3SWgIqrw1POdglfW+oTZSx8GVAby7lSGAd78olEOx+RADVqKpo88R5sdWZGZFtVTB0U6VjvFE+vTzGfRis9R9G+gZX+CxNnR32zlEfh9IL6PQ5lCFFYxxt22ZH6bfAvK7QvPZySPqu9xbxB6RmdOrYD9tPJQckJEXDTYxtcOabmgvVdTexqO8HypwmZ0U3uKvEa2vjW6+j1M0R4O9pOO7zwNabA7Ul6bw7BkD9dXgN2WwUG2doaBJyICuNsaJkPMKekWMILHdtPn0vnuzwxrekIrf8O1e2w5BqNA8NlI1k0NmYWXb+RY3LBZjLY3/Czmzv0Smedp42V
 wiveoaYB
 CP5E96EKQgjQ5ZJT37j8ZuKIsH6EDDUBKDGeaetKsvrFQEneL+w2+LaUmLqGr5ctLZL2JJFZcH9An+Q4k9o51X/5yVkLtaC4Du3AdZHtDryqxAKIR0z5Rj5EbwwtxV9WPleC+CdIlZT/zIoSWwEPSz4h7HAGXCXwWTAADjqkLKDpyJLFBia6JC4BmRBkpjxaNT3OsVqCvHg0fUbr1d/g4EKmh1o34zMBSoobB+Jkj8sw6V5AD49e4EXyTQ57nsN+5+JxtozJAYiZdLDRL83mEow0pPNCFa5CAfkU8nOQW8p76edo1S1M2l0q9vwmUxVV/stD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 07:39:01AM -0400, Johannes Weiner wrote:
> On Mon, Jul 13, 2026 at 04:50:53PM +0800, Guopeng Zhang wrote:
> > From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> > 
> > flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> > the corresponding state_local[] counters unchanged. Local kmem and
> > slab statistics therefore miss updates collected through the NMI-safe
> > atomic path.
> > 
> > Update state_local[] together with state[].
> > 
> > Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> > Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> This issue affects memcg1 but also the workingset shrinker.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> And we should probably CC: stable # 6.15. Shakeel?

Yes it makes sense.

