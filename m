Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB16DC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22DF6B008A; Mon, 20 Jul 2026 13:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2F36B008C; Mon, 20 Jul 2026 13:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4366B0092; Mon, 20 Jul 2026 13:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0A4E6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:52:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 142A41A0266
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:52:44 +0000 (UTC)
X-FDA: 85009900248.06.8ED7CF8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9460C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:52:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pgyz1YhP;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784569962;
	b=WlCWOuV6UQ36huEnSKx96FMeIpAVDH/f3zXrSIIEdos3VlAP2A9fiewjMNWEPzwlhJOQ8k
	FVMThdZG9iubcwXoTahtaqfuLP+mEzU8ArHIwG8ij7GLOX2ZQLglQ3mcqJzth9qsB9kYHv
	DQCe8T06wIvHFV2Czkz4e3dUhe5j6CM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pgyz1YhP;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784569962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TR847jKAnLLFsDzkJBbc4JtjIxFdfXosjkxGIzB/344=;
	b=rA+bpTbxuRb3VzCpPUDo/scJlGF9ihDocjoZvxRJLx/XVbo/wq0qGVSDg9+BCTvkhA+OaE
	rBourq/y/8/ZrOTew2jWCw1tAvfw6wX2zZSv99GCpDOvPnDh6aOBkomhndFZqXtZ8HnatP
	ERpZzhQ2+L1JLVg5X2xPj37oJDNQBs8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=TR847jKAnLLFsDzkJBbc4JtjIxFdfXosjkxGIzB/344=; b=Pgyz1YhP+1QCN+yvoqIhCvJsgZ
	Vku7FPO3C6ENm6LxLklvHlmnCqXx5TX224a51MBQhn10peY7b5XcCjBunFF2K6rETht6B+bsYqB4Y
	5RiaVNBDazOw+qf5wwC/dxGyQuO6wG5lyfPYgPF5sXVHpOBTfnpwtl5j8RxvCPdVfaQ5hIno5b5eX
	x/aXvnXXmHZ3Rx59JGcV0J+APS8gIb8dAGwuclvNrsFEgeoIqSv1Rb5fjskHhI/LlPQIOH2jf3K6a
	1uLdDaYaZnMoJoL0qgpL8UH4jF6WLgzXcg2x9KtFJWkm0H1jOwgdWXm4Hua4YKVKC361UVC7KzTSa
	PMo1oXxg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wls9r-0000000BRPP-0YTi;
	Mon, 20 Jul 2026 17:52:03 +0000
Date: Mon, 20 Jul 2026 18:52:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	iommu@lists.linux.dev, loongarch@lists.linux.dev,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Message-ID: <al5gQgnBCjNCSD_4@casper.infradead.org>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org>
 <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B9460C0002
X-Stat-Signature: 3pngkgqzrpzczof3c8hdey9xws3iojed
X-Rspam-User: 
X-HE-Tag: 1784569961-737060
X-HE-Meta: U2FsdGVkX19+R1s1LNJiLsbsx1Fsre9vxNaloxeWXE2WXXioQE9Q1Nm7UXyk41Kg+6x7yDzDQImXaEAqxbUHt2ctiDIqKjl3Z3vA7rGAEKTzstiOjF2UW+GhGacVIRCkI8fBOd2k7gY6HNiDLuCrBWKzB08hdPof+z7AeUjEC8TcMeAMek758agx1QR9wgSnE7afKAx3qUiJh2roYziXemuNnAU2bTmi/HU8s71nnfWcj2i63mWugEyE169O+1XbNTgY/6ywWsCZd0Y7Y6yCplLQ+2BWsD9Q0KIbZznOGd1RBM2TtXh3M/tAhOP+3pqnSwVXKWFtw+7n1bpk+6eYvP+ZvaOl8PPxSFt/yuIcxAub4/QY2rrZISkQ7+yrOd4X0txm5vprwRhWOZ3dZH8sLmuS9G9BeWXdivo1m/rZ6JnK8k5tKxPWnnNHMOCMDG6ShFXwtzbeZgjrQ4NDe3A2eE8f9K6oNgFAMqsZ7wXoAEPRek8v8xN+uLoA/IVnZNpsU/WkrJGasu8sYolG8kuFCUf+Ii8Z+ye4hDG5TLkPTQseU7a9fO67JIffjcjTh/6tAZD1kXy02GL2Y61gsb8W1eAwe6iDOMVIV84ufiqzLoJ3NLCbUR5zhStjE7dWLAknEkIW9OLt5klnXQKqm4pTa6MHZfi08DkmBzU/xDe7ARoMSCOFYxmffCNS3NMKzCxn+pAjRpjpFevzso48N7/w/vTO4IumuGLbiuW5fAEFc7uTNXAEvAG1aED4cLVsrdIZaE/fpv/c3R7vPe8au324my/dJaGGYmXmihPZw9sSM7BVRQZOqzNav3naUb7ldbl+TDSpum8vwyq+jFx6hZJkWnWpgBrIftCAfyI3Gg083cmvS4R3hhL2k04HMa+oRonNYTmvsG3RyRpXmD9LO8GHP82UptYeuFN98gppVaS8DDUcEcSBfNe4ORfOfTQl5A0ERKPRP/QEmtJTqFeR0Qa
 0F015kWh
 G3Vw4MLvSiiSdoS/SI1oRM/AnvPZaLnrWxewWPxfvFU7fH1LqDImcKBtncgwUKLytmPPEoV3bXZP9sFHFs+sGsm6eYYC6qj5IX8pg88ixZ9/X3o2kTzwJrs83okWsgZgEQN48a7X7lxKK0DxSCeo3fnqezJokfXAY/D2KFVGQ/v9VKGOEehFTizCn7Ddd4LECEwq7tZp2a4o1dJlDlVMSq5IicRQ02BGV7PDHCziwPDfQcJjZIqGoXsrJJDpQ1DyMMi3asTP2bCQSu8CegFSsT6KMAMBEzqG3vQKQ83fhV0O7+karDMbMxRRKALTD3B7dHkbhJVT3/DhvZxkBpnz9dGiCTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 04:57:37PM +0000, Brendan Jackman wrote:
> On Thu Jul 16, 2026 at 4:48 PM UTC, Matthew Wilcox wrote:
> > On Thu, Jul 16, 2026 at 02:30:10PM +0000, Brendan Jackman wrote:
> >> There are no external users for this surface, reduce the scope.
> >> -struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
> >> -		struct mempolicy *mpol, pgoff_t ilx, int nid);
> >
> > Hm.  So what we're saying is that allocations which respect mempolicy are
> > only for core mm and not for, eg, device drivers to do.  Is that really
> > what we want to say?  I don't think so, because that's inconsistent
> > with having just widened __filemap_get_folio_mpol to allow guest_memfd
> > to specify a mempolicy.
> 
> Yeah I agree, mempolicy definitely seems like a "public concept".  All
> I'm saying here is this specific function doesn't have any external
> users so it doesn't need to be an external header. 

I don't think that should be the metric for moving things to internal.h.
To me, internal.h is a signifier that these interfaces should only be
used by the MM.  Not that "all current users are within the MM".

> ... With the ulterior motive that I want to add a new parameter to it
> that actually _is_ mm-internal. Namely, alloc_flags, so I can add
> ALLOC_UNMAPPED to implement AS_NO_DIRECT_MAP, i.e. the next iteration of
> [0]. So basically this is
> about trying to extend the allocator without creating a GFP flag.

Yeah.  I'm not sold on the whole alloc_flags thing, but I'm too busy to
sit down and think it through properly to get involved in a proper
argument about how it should work.

My entirely unresearched and ill-considered opinion is that the __GFP
flags should _be_ the ALLOC flags.  We shoudn't be translating GFP flags
into ALLOC flags that are what the allocator actually uses, the
translation should be done at compile time.  So if GFP_KERNEL and
GFP_ATOMIC need to be composed of different flags with different
semantics, then we should do that, not invent a different set of flags
that special people can use for special purposes.

> So I'm envisaging if an external user arises for it later, we'd slap two
> underscores on the beginning of the internal one, (with the alloc_flags
> arg), and then bring back the public one as a wrapper.
> 
> Does that make sense?

We have a long history of people just moving stuff around in patches
without knowing what the intent was if it should be moved.

