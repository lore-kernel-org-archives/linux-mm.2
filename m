Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC36C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 22:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF3C6B008A; Wed, 15 Jul 2026 18:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138806B008C; Wed, 15 Jul 2026 18:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027416B0092; Wed, 15 Jul 2026 18:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C783F6B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:00:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C6AE40323
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:00:29 +0000 (UTC)
X-FDA: 84992380578.26.45B14A0
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 61739140008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:00:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I2g36dOW;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784152827;
	b=JHQ4b4hnWlkmsVelA1wklQzF9iAYWRuh7y5pC82rQnA8PIH3tN3Df6QxPhxQSNhmoza03G
	bDUEGq6/urhV2T7EwxkAjIE13ujohw1l2+GWYqKRT0RnB/yEJOXTN3gkdzkbAQ1D3+AD6H
	2nvMpyrKRePB78BtspqE9zhMCra0E0o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I2g36dOW;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784152827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OlkplaR8GgK13ho8tmV45hljbLwqCV78az1wZPy6dI=;
	b=1Dtr7oBSlaVnb8QmeX9N3grLIU3F1QjTKjqUSfWcrfH07uKxsI2o4+eDtW3u9TOAZGe4ue
	vMeibFhL5HbRuOjVCicmeESHcfBnUG5xqpHZzMWnkbDLomZNo9//Zsa81AJxMSppA41Eu2
	DAk1hAGTwRs0Rt2G+foIaztawoik1oI=
Date: Wed, 15 Jul 2026 15:00:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784152825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0OlkplaR8GgK13ho8tmV45hljbLwqCV78az1wZPy6dI=;
	b=I2g36dOWHmLPrOUFZDp+GK1CJyMsEDtzLMDeQeyMYqsYAoPixeHzlU+0hVAtYrnS0ded3Z
	OBckUwSsmvwrAjQnYCTkQnLz9iTqMeWlwrbuv3yRaCGNGHtM4pRBoDH5E391/205TxacKw
	Fe/9FXCqvEh9ygk51xr89BL33yxsmuk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm: fix reclaim storms in defrag_mode
Message-ID: <algCyuQCfAAzkrM3@linux.dev>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <akWwg0irlanA_y1i@linux.dev>
 <ak_fl7Nq0DHmQd2K@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_fl7Nq0DHmQd2K@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61739140008
X-Stat-Signature: pn5s5oqjrqye4r4u3n48x4ejbpsmdsce
X-HE-Tag: 1784152827-270318
X-HE-Meta: U2FsdGVkX18aHtiJv9ESeqi9JkskGURYrdia4eKrD/iAodSM3r4TcLMPZPtT+DZi7ABH4ZrloR7XcmjUf6L/wtfi2cfzv25hOaQn3Qdvv5qFHQ1MQWsLTYRv3OTIrIJTzKa+LVsLkra6UdlPi1Yax7xV2fYDUxFBIEwtH5r88VXvHKvZTqd21HfIaN6N6XrFXni3HiMmswH9DtbsovbbZZ5IiVsEigDeakdRt+/KlW7aWbVh7NgxzVfjQM1iL3nbOGgGOuFLNhR5p84IWSaTdZzSVtTltP/1QV7i3glPeJwZ3t2hMgb1R7zJiwBjXu1xzYuaFM1FzO8EuflrtuY345YZCNwmT1gbGtHb68rNWbxaQPOHkmUkIKRbW8sIJphJhXc+J5y/D41X6z8ipPR+F5fTdEGriWH5gwu1uYUIYoHtDv/wr48hm8wFlnYepheCUyR8od40of6ahkm1TC6HPHAyfkfAfNv6y+kUzlZUQMAZxoUg0Lv2WJ53acXTyzlepvXm+BzNOxJ+LdS7O6O7SwczmjifQeV77gSCTfyeYWttYL4I49WgH9WoPqJn1Tg0hHmfpykEjvoN+yuxWcdqjMyKoOXjdiJyVlDhFmC5qRnfXQwnAxl2ZXb1FXbC9QHyfgoPPz7px4WDb7ZNpX0YI3xDHcxV1UD+5mshbSpCkue6nJTNKATEOf5wppOLKbYvN3xr1k9g3M1HquZOfFYVV2qVrzcXp1daae7IX/mCid2uPO6SUuENv8+FZkhPFjHuhAmkMPZ7eQhZVS1UMEUfpwMKaLnROEOZQekQ3bOH6BuhQo4yqNQnG7GiXlFEMwLgShMylo7YDA8e1KAEP0f2hdUCpbnsF/lDdaMk7Pxzh1BxGy/X/QZqoHUF0Apc5fn1iX1BYrSVRDVZcLVrukqI+dVrtc18Hka36GxJwxlyAxUVBZhEgeDZQEHw+fof2h51Jnm8gqI/Di/fuqbxOQe
 ml1bQzAB
 a6C2iVVKplUF0E1Pr2KPKMW0bxZstMcB/QAjIqqM/ZHk7vmstgnQhuEqdwWooAjOTk3yVknDIDwukCXtP1Peazh8VY8H/yUe9Sjb8hDghSmkFro6ARwzUpHqn/P74DnnmaTvYEhiZhd42oZpPsHaepg219ygEzc0vJTGHPpCdVarqcfiCDTrZttLeBNcYaIJre4s9IQwTIPX5mgPJ19LQEMWrLVlntq0GQ7ok56cUm663mJXpEpxcmWxf7j4xfdtXTRHn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 01:51:19PM -0400, Johannes Weiner wrote:
> On Wed, Jul 01, 2026 at 05:31:11PM -0700, Shakeel Butt wrote:
> > On Fri, Jun 26, 2026 at 02:21:16PM -0400, Johannes Weiner wrote:
> > > As we deployed vm.defrag_mode=1 into Meta production, some workloads
> > > regressed with recurring pressure spikes and swap storms (which in turn
> > > triggered userspace OOM rules on pressure and swap utilization levels).
> > > 
> > > Tracing pinned this to non-movable 
> > 
> > allocation?
> > 
> > > requests spinning and reclaiming
> 
>     ^^^
> 
> non-movable requests :)

I was just asking if you meant non-movable allocation requests.

> 
> > > unproductively when kswapd/kcompactd are overwhelmed. Direct reclaim
> > > predominantly frees up pages in movable blocks, but those requests
> > > cannot use that space under defrag_mode rules; 
> > 
> > Do we have these rules documented somewhere?
> 
> Kind of. The crux is that defrag_mode enforces ALLOC_NOFRAGMENT in the
> slowpath as well (whereas vanilla just does it in the fastpath). So
> it's documented to the extent that ALLOC_NOFRAGMENT is.

Ack.

> 
> > > and it is unlikely to
> > > free up whole blocks incidentally for __rmqueue_claim() to work.
> > > 
> > > This series fixes it by making non-movable requests participate in
> > > pageblock production in the allocator slowpath.
> > 
> > Sorry after reading above sentence I didn't get what those allocators will do
> > things differently after the series (I still have to go through the series).
> 
> Let me add:
> 
> [...] - meaning, they will invoke direct reclaim and direct compaction
> with pageblock_order.
> 
> Does that clarify it a bit?

Yes, this is more clear.

