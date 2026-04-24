Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC13FDEE59
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 01:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702F06B0088; Thu, 23 Apr 2026 21:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3C56B008A; Thu, 23 Apr 2026 21:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3746B008C; Thu, 23 Apr 2026 21:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48E736B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:42:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBE89140680
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:42:55 +0000 (UTC)
X-FDA: 84691750710.10.7C42047
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21B8A4000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:42:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHk011y5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776994974; a=rsa-sha256;
	cv=none;
	b=11dS1c2eLL6qOMGLjc2NDE0Za4oZspLHgsheoIxS3dIdi5grDqbowd7bkGlGjwYySJW1oB
	wWZ5pzHwavrCXhLo+2zsWbljOAai5Qa5ZRuZ+BRLMn95zUrVgbfSRo4LvuWkYAg/+yzDQ/
	MP4CY/LTgr4zmK5EKUga1y1uUOz9q+Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHk011y5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776994974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/q2HQawH4gS8WtM0N9MclymHaTvpj9p5Uu+SoCUc2EM=;
	b=yTp5Eh+/8YpJzdeM34OafyWttZdfp06JdzHplW+2MNZXm8sSW623rPsvwGrWjZiJ+bgdRO
	IN1cGImNpSZYtcgUn/PN5Nddsye0pRuaWxJdDyJVoJQt6xJpmp55MoVzfQpVFTCeT+IR9c
	1Unfm7ia1dwT81BCN7OBNbPf4ogDukI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 644FA60018;
	Fri, 24 Apr 2026 01:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E81C2BCAF;
	Fri, 24 Apr 2026 01:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776994973;
	bh=QSSazNTuZnTtnxSTAVV/omqIibexYYaHVv32vSM+ju0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHk011y5Tu5pSPb+NUNCFvmb5kjhWiRIURuxLfWuBxcJebDoo+a0ykEL9ct3C7Jey
	 +c82I/dZUSZsQx4+psoG9KYEMLmbiQAjitXTa8uhHpLxH0BPF9VLfK4FR3GHWRhelY
	 uj/wUW06lIxYLsNTnvCnj/cpymNNASFaJMbonzrgTEhq6yAUGBPn1icEiZuwX8JRiJ
	 wY7TridOAebUl6K/IcR4j9eSgxMGxxI1ABsVvIiB0PHuEYMEatHbPeQIvn9aHIOr1b
	 3rX0yZ1bL8AskzLOAY5FvcoD03cI/BUBqHhZtwTb0/+i9qsxBLkyVLiii4ZvLKbacJ
	 n4Ghapr0tMD3Q==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/paddr: prefetch struct page of the next region
Date: Thu, 23 Apr 2026 18:42:45 -0700
Message-ID: <20260424014245.1124-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260423122340.138880-2-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21B8A4000E
X-Rspamd-Server: rspam12
X-Stat-Signature: 6jx7o8q6u53sthz7b4gfnzehjwq475ma
X-Rspam-User: 
X-HE-Tag: 1776994973-447919
X-HE-Meta: U2FsdGVkX197hEdAPL0bPpwZkyxh/DEh6TItchHEA0Rc1R8rzWhLP7Zom6T0eCCX1qz3JY65T0bH2QbKrE+yGJZhP+/GgWJRfvoCxVPp7UP7GKAgLGhJrkcZu5NWo1W3EFfvArEOOLL62/nEl701OYWIe9lC1Q8qetlCjuCjMv7hz+NXh0KJVUPmMPAy6KBMJdCHOv7OiGWO6ZuZtJnJDESdx7D0quTD2zrbGA8kYcgzfzVjxEGW/aNeQbCCLR/Rc9agovKcbSm0IZVOQxOztAYP0CIKa4ZhoPCht1MyyI7oje8eW882WxFRkx1Fis0YsGsRHnsPOFkLyYmejPI3fPR0afpG7OZfHinlus8xuNcxDbne79wLZMtBN3UwwfdLXyiaO66Sk1Zbcfkn8rsVRgyzGbDtMgZbQnsS0OFvJt2Lr1CLgGzXj6hTGzyigrmKCSTW9SA9Y3NX3FtSwv55sm1aJfdKkhTKFfOvH5/YnCcu59ARIBBPF/uIUjvLGt9+87fUvYdFQCkW8jANDhUlIud7vM9BoljB8XbPgA7jj20ZEQJFk2gfzPASgG2gkK2+Nk8DDY3OPYRp5kgXwWXk3vJOKLAZLJaPzdD3t37kz2gDDCCcFstHYN8dx08gfuF0A98CY6QPJp6h66KbnurXmzc45jK8Y7oR3udqjEoXtbqr9GZ3ZGDwS/QYGmWyAKbqOhU0huzeQ5DRw6ugBRhKaVul9i56XrsXDxCpEsWR8Tr7dw68qJX/hHCLA2BecADi8pCfvpZHmjU7ARwOGi1DJeF9WTJmxhcuIwUfy8DZi+XTJwohJKfClv7a8mvDPKPjNxnfLcK+ioVG0GE38fHsFeCDn5gLlqOpIx91KVzqL83D04e9Z/JajeFnLlLbCr2ipICL3eORSaAJpOr/wcNNxYWY/DJ8/E8PN/1W2Si0XG4GVDwvAH/S3Nn5gUgG5IBfu0UWdrzdwnSC4ocUijV
 Zv/mdplz
 AwlkF3c3xPLN2wSrkRhRJy5cWC0kRZwzdOwAa7Y0DdwwT7qGcuGmFPBw/QeHilw+3fJzGHBstMzSJJUjBUuqqMw7xeSjs/DXAnwS9FdySxpQ9+SjJc2NBXQhAhLH/mdjlDKitfPfE5tnI6j1y06eXbaPENih547TGCiqIFyshPLSS+1PpBY0q8ToQeDndIlA6LYAovjD6CiIHgEbQWC7oxg7lLkC9oamuN/+X1a0vTJ3pD2evtZaJHqUjR+J2aCoV1RDxRLDEHpq6Sl9rw5PBi/mQWHQfHo7QfB2F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 20:23:37 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> In paddr mode with large nr_regions (20k+), damon_get_folio() dominates
> kdamond CPU time.  perf annotate shows ~98% of its samples on a single
> load: reading page->compound_head for page_folio().  DAMON samples a
> random PFN per region, so the access pattern scatters across the
> vmemmap with no locality that hardware prefetchers can exploit; every
> compound_head load misses to DRAM (~250 cycles).
> 
> Issue a software prefetch for the next region's struct page one
> iteration before it is needed.  In __damon_pa_prepare_access_check(),
> the next region's sampling_addr is picked eagerly (one iteration ahead
> of where its mkold will run) so the prefetched line is usable, and the
> first region of each epoch is handled with a one-off branch since it
> has no predecessor to have pre-picked its addr.  damon_pa_check_accesses()
> just prefetches based on sampling_addr already populated by the
> preceding prepare pass.
> 
> Two details worth calling out:
> 
>   - prefetchw() rather than prefetch(): compound_head (+0x8) and
>     _refcount (+0x34) share a 64B cacheline.  The subsequent
>     folio_try_get() / folio_put() atomics write _refcount, so bringing
>     the line in exclusive state avoids a later S->M coherence upgrade.
> 
>   - pfn_to_page() rather than pfn_to_online_page(): on
>     CONFIG_SPARSEMEM_VMEMMAP the former is pure arithmetic
>     (vmemmap + pfn), while the latter walks the mem_section table.  The
>     mem_section lookup itself incurs a DRAM miss for random PFNs, which
>     would serialize what is supposed to be a non-blocking hint - an
>     earlier attempt that used pfn_to_online_page() saw the prefetch
>     path's internal stall dominate perf (~91% skid on the converge
>     point after the call).  Prefetching an unmapped vmemmap entry is
>     safe: the hint is dropped without faulting.

Sashiko raises [1] a concern about this.  Could you please reply?

> 
> Concurrency: list_next_entry() and &list == &head comparisons are safe
> without locking because kdamond is the sole mutator of the region list
> of its ctx; external threads must go through damon_call() which defers
> execution to the same kdamond thread between sampling iterations
> (see documentation on struct damon_ctx and damon_call()).
> 
> Tested with paddr monitoring, max_nr_regions=20000, and stress-ng-vm
> consuming ~90% of memory across 8 workers: kdamond CPU further reduced
> from ~50% to ~40% of one core on top of the earlier damon_rand_fast()
> change.

This patch feels bit complicated.  I'm not sure if the performance gain is
really big enough to compensate the added complexity.  As I also asked to the
previous patch, could you please share more details about your use case?

I will review the code in detail after the above high level question and
concern are addressed.

[1] https://lore.kernel.org/20260423192534.300CEC2BCB2@smtp.kernel.org


Thanks,
SJ

[...]

