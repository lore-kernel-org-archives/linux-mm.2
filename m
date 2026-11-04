Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E090606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fyTV59mW
Received: by kanga.kvack.org (Postfix)
	id 7FC3F6B05B6; Wed,  4 Nov 2026 08:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD106B05B7; Wed,  4 Nov 2026 08:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA2E6B05B9; Wed,  4 Nov 2026 08:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5629F6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:56:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB9561406F9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:55:59 +0000 (UTC)
X-FDA: 85397585238.02.057D12A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4296EC0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:55:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fyTV59mW;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793800558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1La6srXM8X/sIag8bKohAPdLipW0D+7qqlLp+GotLXw=;
	b=XbgT6zgKKNkRjJQvbrGDja7TmnzhkFrifeJJudvcN8g30tL4p7eQMwRhvbgX4Uf55MGtlv
	LVXjyN5zV2t5iYkboggm+KtTRU2/8l/2nm9lNyLaOD+APzozbs4vlDn1rKwOQ88dgptN6S
	2wMl7wJpx/8RifTLPNyXutYR5VL9RHM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793800558;
	b=HawjTAbQz9sVYrvMxfv82DeH6LVXgmO4lDDkxWjeKrliwH+SrIlXvHXrY79asYn7P3zS6m
	j0qvHVV4QuLd0zrcXB0kry1mjiVqivVrTGkBmIJhN28dIvmoguYkfMn6LQpvTKO9RAqnMB
	5HpqbQIPcHW4vgm03NYQ+cI9jTijq3U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fyTV59mW;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6BB940496;
	Wed,  4 Nov 2026 13:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C6A1F00919;
	Wed,  4 Nov 2026 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793800556;
	bh=1La6srXM8X/sIag8bKohAPdLipW0D+7qqlLp+GotLXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fyTV59mWbSB5r4WN7LjlGdDpQLQRh7hjEPnfTdCHa6YIFWvDcWEvB06eYk88OSzsT
	 Ww0bcXPS0BYyI8PRW0YSVj6s+ZOwLablr0X8a/e4eh3KEanqY/34HFwJ+1eSxaIvH2
	 kw1wwOKjwSfk0GpaGiC9I5m+q+RWQg2VxdumiiJgqIRow5+Ym8/1CFPyNNvGkCzep7
	 fXpgSGmpuv2+8vVuparIdANfXIw4wJZ8e4wGkJHq+4lQSyedTIVx81CTGBdYowjCi9
	 P3BCuVmRI61bmD8CpcGzkotpiZtAcdjzGf5yYO6U67lPzEq1f4tTgAN3KPaSZm/JIh
	 D/4mDEJJgjyCw==
Date: Wed, 4 Nov 2026 13:55:51 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Richard Cochran <richardcochran@gmail.com>, "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
Message-ID: <aus4ag1KxpuBNSP1@gremlin>
References: <20261104013139.1341582-1-bobby.prani@gmail.com>
 <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
 <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
 <287698ab-76dc-4aee-8e6c-db1f5d18974c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <287698ab-76dc-4aee-8e6c-db1f5d18974c@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8ij4f7m5p5f13qrtzesqkadmti8zwh3n
X-Rspamd-Queue-Id: 4296EC0007
X-Rspam-User: 
X-HE-Tag: 1793800558-737662
X-HE-Meta: U2FsdGVkX1+vKEAJXZEzR4z/i2QTkyUR7anmY7DjzaRXn1f/puoM9VDy9/28S4m74WJO/Ct246mnzlAtr53neGEK12ygVWhdb42sM2KTa9npq4Eu8M6YKybyMrO9yC0IDIofiDe5DMT8nMgRSF3qAuHkXk+IyA1kX44npLB605JwjOmzX7QuU1ibk0jZNxRLONv/eZ79iQc4drMfjJDr7SaroI4UotJ/9sZRV6CeHkjdf+aSrztNwp54rTWMUT2FOK9pR1BHkDvb1si1rUn4jwWMcZS3AXZ8k/7FlZmLI+6ijVEYkZtnZfbFgXFeeEBXKxpSn9nAK35/FBcJIgJrFOxe9DSAu/EoPEYMjh70vdlENNGYinPBDDMMnsTnCiYU02kALR21VlIeoup8UO8Glj9u/8oPA4rS2EdCo2TjbWiv6/FSYFU3dpF0Ly9Stiky+TSGyMBZkYfs4PQECJF64vdUKzrxomghTF8CsBw6f+3pNGnZpgpFPUKl+MSuC58XtSvNA/ag/toS++K2ScmMAUnQ0quK/AoOL65havwKxnMnKryMBkBVkDJM9MUGKQxgVnI2KweYKpcGX8BAnK0z6MZvhFYV1sFWpzSc/7r+J4eHAICreG8Fmu8IJYGNaViFKJFIwa2IPskJ0m9v6kMFFOJfkwrQlHOLnF42PT/UB7825iTM3ST/D4pbAhWOZS31E+hKjW7Ru68Rp4se0N1gZFLJkLta8GOZ9rGIzX5Sakpp1vntWKYcPHGKNrV1lv/LCOaJDb+gemsYlbrnlQUcHDClRHLH67QtTkpR9dIhB+hyjRA6DJYy9LYknJ3zju4xV7pbI+7nKyII9KuHucomOQD5NdB4X0bwOixxWtOsCHTt0od3kN5eJBBIngQfpA37LbyvxzKFAUz6WBBhv61eVqVXLekwapOVQW1wgrc/sjGQoBgFnST0YPaMF2g1LGOsr4biPPY9j505D6RBoHa
 Q6sx4XL3
 AgZDOficoOKtQaYTIc3jOl2biNbfOp5X31c77C/YEe1zlyoa9f+2EsZHEWBGTJzXjc2rVRNazXCXOmb40BGuy8u827mrDoDZWrX/MSZwveow8rSqDAzK529L0Tyj+br31e+Kl7/LUyCIhcAR/MrbCemN4zZ772leOHLyNqXIFczlQ/p68Ta+Wdcb4cEgM8v1+bEe5U9KdgtIf0pv8pqP6uwpdiK/fxZQFh2favemBOMiOkBrvcJpz7PZNqEyARPN1XKkxqXbICiXsmbnEdTreMU34t2UfAE+s+xhsXBidTYDXR3f43K0ks1rsyM0V40HyuHcfBB5Ijrf6OyrYybMlDwJG4yPXBJZXuYN8avtIE7aRagwNmEY3FKshCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 02:37:39PM +0100, David Hildenbrand (Arm) wrote:
> On 11/4/26 10:46, Pranith Kumar wrote:
> > Hi David,
> >
> > Thank you for looking at the patch.
> >
> > On Wed, Nov 4, 2026 at 1:16 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>
> >>
> >>> In an arm64 page map/unmap microbenchmark with 20,480 minor
> >>> faults, simulated cycles fell by 1.54%.
> >>
> >> Thanks for the patch.
> >>
> >> While I see value, I am not convinced this is the right time for this
> >> micro-optimization while we are busy with other things.
> >>
> >> This needs a better evaluation: 1.54% in a micro-benchmark without knowing the
> >> stddev isn't particularly helpful.
> >>
> >
> > This result is from a deterministic simulation, hence no stddev.
>
> Ah, I'd assume even a deterministic simulator would have some variance due to
> preemption, TLB flushes etc.
>
> But the bigger question is: which arm64 variant is simulated? I'd assume it
> might vary heavily no?

I mean 1.54%, theoretically is even less convincing for me :)

In any case for something touching a sensitive memory barrier operation to have
a stronger argument put forward for release ordering being suitable than simply
stating it's fine in the commit message and updating a comment.

--
Cheers, Lorenzo

