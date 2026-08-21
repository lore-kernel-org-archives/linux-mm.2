Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF574C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7B86B0095; Fri, 21 Aug 2026 16:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89166B009B; Fri, 21 Aug 2026 16:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77926B009D; Fri, 21 Aug 2026 16:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A22C6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:37:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 093BC8025C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:37:54 +0000 (UTC)
X-FDA: 85126438068.15.AD2988B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id B7974C000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:37:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BLGSbKLR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787344672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pthRXENN9NJdBkRma4s4YB3RBsLRPXiCqKniEVxmpvg=;
	b=BWlafRX1r1h0KG+EsmvVnJg8xlweo7x+gYZWK22e0iFiArDeGf2AtIQY4WHdS0LqbFZeLW
	LBG401JReGR3P6f3Se46Dhmn2anU7coqNpIZFeQX/V8UuBCvTjMjVbXqNCZHvDLtl35293
	g2pTlk6UZeAgEGDhmE1waawduevZuh8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BLGSbKLR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787344672;
	b=O10BlPm0ZJKjx4yEftWoOb/PpJmRjuak4B0myx6NRTuJQYu5UGkZwUyQonMFoGiYty9fJr
	6MftwVg87vKjtS8i4KeArB8qhBbriNA5Bg0YxzOiSq64IS2+ba/snGWYQg0XjIhRR9O49B
	S40NiEyDIK7uBo68nUQ/oR3GwB33Hzc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=pthRXENN9NJdBkRma4s4YB3RBsLRPXiCqKniEVxmpvg=; b=BLGSbKLRlqDuaTvMf6Z5NSJLvc
	ljNQmA9qmE9AnT9kHg6TF1ss38CPBjVq2tvIwyndaYdhtvpmXFF3HLLZ3+AKUjb7bPaRIGzPo2wlu
	xU7muwpckPOa1yqQllBqQozZAK+cOXA849ZF9l5u7BGKfl0Ogkv68jSxmQtawHku+vYTzbNxp88xQ
	jzqISQGovI7eLLuwkD+a0wt8+XgubOXGk+046A0CxGUtF2hDJDv3bc/K4OSgEfFq3EX4UhIsDPb14
	u+BzJNVcTKTAHVnO4hueWkWukKmQmU5WoQUKklQs82cKdV5l0CkEXxugzGeH7/qmaofTKaZqkhRcO
	6LAkl79A==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxVzp-0000000E3CP-1tVd;
	Fri, 21 Aug 2026 20:37:49 +0000
Date: Fri, 21 Aug 2026 16:37:48 -0400
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 15/19] maple_tree: Document erase and allocations
 better
Message-ID: <ufmfevzbrdg44ovtraidb3xt4ba6uneej6e5rkf5cmkkyp4ubi@3tvzvyj7kh3e>
References: <20260821192627.4085470-1-liam@infradead.org>
 <20260821192627.4085470-16-liam@infradead.org>
 <500549bf86f8fab571424af9a7f3a69bb1a08a5b.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500549bf86f8fab571424af9a7f3a69bb1a08a5b.camel@surriel.com>
X-Stat-Signature: 1pcicy3ifohch4znp39snxra7uq8d35p
X-Rspamd-Queue-Id: B7974C000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787344671-356302
X-HE-Meta: U2FsdGVkX1/fKD/d36M+PJgi++O94rGZi4bDDxTA2NyTrM8TOu3rU3tsGgxCqPr5HhSYAmZvbyj4raWhJHk0yZ80p7c2H/Rw9hL9AeQHq6e0FH+hPBn47W3CCBqSko7wgCFAdbgly67fCixnqoJekfbTpZ6Dr9nEqyc2laPFSRIEPS5IfOEzriPAfJvASOarlgsDiU+qxjVZKdlrsey+bMyQV896TLVK6g6gdwOa29C+hDx1SH/8YwyqYkkmjTvmR1bK8gqTzkFCZIUrFrs1eOC7GrYF7crDp2sVu4q7UedQhIZhoXD3wzEzINS5Em1pCYY0ZlgmaG1abf1uzxa38D/gAd6egsUlyxLc9ylAF7hIyjV9v64qCqq1mQJ6+AJBy+5lqNSEUEubW/H2zMPnPbKQFninlG8RfgPNoqh4qTXhyOMeoZDD6AXr4hNVkgeHgio4fC28zTwPvSVcGI9CVOKb0yZjADwv6nEfELX6NA19Fz/0u7qqCHD5elV08TzH3mbWPLtHbVeWV6GT/ymQxUphoUsszhFxEgczDfdj4lnilgZywsg4dfF1DkTuCOiH86A8eb5/gZXjySejQkWmN1jZa2kp6w2vFKpdxY86AvGoGtrDKjxeWi/ZUp0HF3J94a/ytxzn2vVdxaKdI/e8Fk3wJoETl59CHuCPLimHhd1ydjFglyLh253NuI0ulTJ0ebRYUyu/B8zEUFyJyCOoMPsxlanMqdVkfDIlPBi6VcFB2YHWWGmuWCrhTRszadn1vBQNecoqG/AlaW4+g/257Hffe56xofr2G1fkSfhYDhD46Ef7wDDD2Y5eF0Tvtb8nsTIan50e6Sxd3VAF1levsgX69em7CQel1GsPXIDasu5/dfXYOz5+Q4icgnqtNJ7iqGlxKfOyxTq8tTKcYjY38RUhuCXNevRhdJuEOsR1B/fOae7Nd8ifK8LPyIeB+kfCu+g7nW5wiR6BjKjXJpL
 1wowHM4D
 0HFy9MUc2foprmJzJLoVwGAy1VpqxUsWP9n3Eh+53hIxSCKetUGcH0PTNinctHZkKXBAbM3Vi2qObUDNG44ABemrH3LCtl2xoGQ0EQSFOzs11yXSJF1wHjPxtPtx4XxipPXlP+uwNWwkm39lfv3rwcGO4EGXj34DX1P6LjH7GUctu1kMMeIA/bp8e2eueejPcx79D7ku6ceP7Jo7FPLgL2pZ9F1amnLtdUXCzr+G0QlDQvHm28WlbZVwLOV7L2Lte/020cD6sIpe+BXgs1QJxjGU1mvjLtTGZJTDXk0FRvj2IG+RMLgwxVzfsyrOMbDgglcQ087DHH2cidjlLtHDEj+QnJ/Rr0qvA/AcU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/21 03:34PM, Rik van Riel wrote:
> On Fri, 2026-08-21 at 15:26 -0400, Liam R. Howlett (Oracle) wrote:
> > 
> >  knowing one value within that range, or mtree_store() call with an
> > entry of
> > -NULL may be used to partially erase a range or many ranges at once.
> > +NULL may be used to partially erase a range or many ranges at once. 
> > Note that
> > +mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and
> > cannot
> > +fail, but may need to sleep - do not use mtree_erase() from a
> > blocking context.
> > 
> 
> Do you mean "from a context that cannot block" ?

Ah, that's not clear.

"Do not use mtree_erase() from a context that cannot tolerate blocking"

Is that better?

Thanks,
Liam


