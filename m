Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAB4C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EE26B0857; Mon, 17 Aug 2026 20:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8BD6B085C; Mon, 17 Aug 2026 20:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2136B0864; Mon, 17 Aug 2026 20:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5FEF6B0857
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:32:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BDFAA052D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:32:51 +0000 (UTC)
X-FDA: 85112514942.02.066EEBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A435440002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:32:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ie6L51uf;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787013169;
	b=AaHUHSTgkgNXrPn5HOdoIHLpkFapgqqmR5M0RhOjSy/cd6XBvJVvffaeitQJx21dSEBqh1
	d74HR3DhJqPNyoDw6nQeUAIoZmLEyLHYldaEwDlVhb6eZhZ4Es3Y2c0m/TXMssN6N/7Or7
	JG+zp4aBz1MuZRf67e1WyHIBzauZDRw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ie6L51uf;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787013169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAhtcjiaFVrE0ywuLRW1Px4yu/0k1kE0rELQe/mJriA=;
	b=cJVgtjHfcz49coQdg1jABgaTij6HSe+W9tfYYYw1Lee1SsA8FWox6rB9iXnZN76UmJh7ZL
	62i6q9fblAegZTgghOhEeh/a2KUXWZxUnVCiK3LI1JRD/zxp1StGtajmPEVyZQS2p4D+99
	4t632z2V/HR8C88+xcXUXp59pzAuEm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C70C601DE;
	Tue, 18 Aug 2026 00:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBBF1F000E9;
	Tue, 18 Aug 2026 00:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787013168;
	bh=pAhtcjiaFVrE0ywuLRW1Px4yu/0k1kE0rELQe/mJriA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ie6L51ufym0dAHEYODXHB2J0HJZF6QeEQ2IpjdW36OMH+CwwrPS9rRkBxlraiBxSo
	 4O7/VXaNY4jctmVCuSm+K+UU1drxfv8gnc/qj4xZ77752KBWQoV5lkY4pH01x8xttB
	 kDWhQ5eUqdOeTpezt8zx3yzzUKjQz1tQ7fWfnE6aGMRtl+jgTrlhMxIHmXoRJDyrUd
	 cxOhQ7aV7Bjuz1Y+N9C4is1kHmozJp92+DruyjMp6W0UFTIgiDOLfV55stYTg/4Lkt
	 y6nFIidmOhRRJ1QgD52A2njWq2UcWkLau+pUGgxOVB69PxNBdmzaXJAGO+ORTTV3q6
	 zCQ0qQanElyGw==
Date: Tue, 18 Aug 2026 00:32:46 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <aoOoAYNxCX0dmJn7@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com>
 <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com>
 <DKNXALH7DITL.349JD9B5RM4EH@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKNXALH7DITL.349JD9B5RM4EH@linux.dev>
X-Rspamd-Queue-Id: A435440002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y9ac4b45qryr6s4o9xj854o1a9ymgpsu
X-HE-Tag: 1787013169-123653
X-HE-Meta: U2FsdGVkX19AbYAmgzxkundyRWt+iAB7wEIUbO2zBuALBy3YUx61I9masjZIWrkAfs0ph0FMIcnId5CtPlgxVy9zZ6oE1Ezfjc5sst25s1UfnwW33sCNWpzMT40511bezIm3W3zk1EUhEmDFFvr2/pBIwK6w7YjjSUfxGfrnYlIWv1IgtN94azxH3AMrMxsPBPQ4UOLnKiYcqKPx5JhgJ53z+IRku+o2BcxolY/ha8k8RxYZrHNl4HBw+vVMNuvH66CfN/Z1RaX/P6KhUjGBCiHGjTqJUmcly+7cFPx00X0Y23NIqqpopBwCWzNhuGdO38fVv9FWkhFRSxnKqyVNN5kfKnchhUoWdkCdnzLSimlqME75FaFIfTDKJ5ecmucWOh/F/Qb/u9utKx/hJoNfiQ5VXCK1s4nfP6HnC6f1qoF9Jozlbf0KuKa4Q+q2d7CUjEDi6vNu44m06Ov0md+UVhM4DguGVeHubDuHhADJVISzTq1FPXfcDQaQVKwMVOfknlsaoldcqGt29w1XjdmkgG2dIj4mLsQ8589Nf9nI6XaftnG5vxZxeX+xvZpJF//aIKorVdNGIwOhwZqelVbhOgeoXASmULosh8bW7Zk7NBMesNn6Iu4GFBBMRa76RP9telMXkxQVtZdfatNFXgPQk8SLxFEXmr8ixpomeE4k/GooaJUG7GsSRzS+QI8fvs84+GtxX5JwM2H7aZxFTgHlxWzOTb7pqOW2xm9fsukMMw5JKbOjL2SNSCjwo/9Pl2Y64r2lD4Ie7iz0inL5MX2hSwsV3lYR79fdteoB0MRavcC48uNK7If4d/W04cq9HPrD1zjyZy6GCYZr0tNGdfdjaOQKPpJbQmN779SwVZRBMvzzhRzc4WOeTfYpEnSnzZlJGmpJz5gZxbnOybjWCIOvktGr37khd+1XIQ0J1ndD8xda9W+BzmSPT1vNkP8GREeEv5llMzyrpUleR8VpcBN
 E9/kx03D
 VvRz7BJdY470lcOljUGG4wdj2giXg3FHV1KKCEij6vuQxI4xWUOy+NzrukZKxmIoNilTqu8Og0QYwnV5+1B3fWVdaxkbi7hykmr1KaSYSnHk7taprroUK8xMv7RQE75U+xpWz3LPQH4M5ekavelnswlwdCmUMm6kTnW1zSjIs46nlZgj5fRYEKITQJ4UXfMH9ySXZM/0OlyhOvTFbHBGKTs+NAWofx8cGjddO3BuHDtdDPwfuRpkLYgC1IhzSTZvuJlVG+arJJVuLkIbGB7AqR6cH5i35FMih97TvLXRkno0ffwNJaOlRUW9guCatL7bidIXO0R12zENkCUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> >> diff --git a/mm/mlock.c b/mm/mlock.c
> >> >> index efa6716e4dfbd..045b6779440b1 100644
> >> >> --- a/mm/mlock.c
> >> >> +++ b/mm/mlock.c
> >> >> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >> >>  	int ret = 0;
> >> >>  
> >> >>  	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
> >> >> -	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
> >> >> +	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {
> >> >
> >> > I don't think this one is correct. From commit 1507f51255c9 ("mm:
> >> > introduce memfd_secret system call to create "secret" memory areas"):
> >> >
> >> >   Since the secretmem mappings are locked in memory they cannot exceed
> >> >   RLIMIT_MEMLOCK.  Since these mappings are already locked independently
> >> >   from mlock(), an attempt to mlock()/munlock() secretmem range would
> >> >   fail and mlockall()/munlockall() will ignore secretmem mappings.
> >> >
> >> > Seems like secretmem pages are just mlock()'d by default, hence the
> >> > check here. Maybe this also works for guest_memfd, but I don't think
> >> > it's a generalization that any pages without a direct mapping should
> >> > receive the same treatment here.
> >> 
> >> Ack, yeah this sounds correct to me.
> >> 
> >> I guess you could argue something like "the reason secretmem is
> >> implicitly mlocked is that it can't be reclaimed, because there's no
> >> direct map". But that doesn't generalise IMO, you could imagine letting
> >> the user say "remove this memory from the direct map, but I trust my
> >> swap system, you can swap it" and then use the mermap to implement
> >> reclaim.
> >
> > Exactly, I don't think no direct mapping implicitly means unreclaimable.
> > I don't think you actually need a direct mapping to read/write from
> > disk to memory?
> 
> Oh. I never thought about that! I suppose the DMA is gonna happen via
> some other address space, either it's via an IOMMU or it works directly
> on physical RAM.  So the kernel's direct map is irrelevant... Is that
> universal though? There must be cases where the CPU's mappings still
> matter...  Umm... needs more research!
> 
> (Don't think this blocks anything in this series though, let me know if
> you disagree...)

I think we probably just wanna keep the secretmem check here instead of
generalizing to all unmapped pages being mlocked?

