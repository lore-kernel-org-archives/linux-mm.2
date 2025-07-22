Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71229C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12D56B0098; Tue, 22 Jul 2025 04:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAFE6B009A; Tue, 22 Jul 2025 04:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E282A6B009B; Tue, 22 Jul 2025 04:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF8C46B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:23:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C5EE802EC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:23:34 +0000 (UTC)
X-FDA: 83691211548.20.1E69C69
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99CA6120002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:23:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vJKu2eJa;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753172611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gUg8+TWMw3s84C3Drw4bZY5zwE2HkLTqpAT+GkOi08=;
	b=pnCU7UMS/FujkcDCBweb1ByyvM2o9UJSEPNgKTkVduokMaHGpiCesJmitDD1oMwWjr9Wyq
	D3pVpY+mTD54HbJUCZwWP2lwnlDYYCyqgaOIoRLK57vblwMN8Fn5KZMOWCk7n1QuqPI0Gd
	elZ+53zqFAnGy5TI5w1rLQbbEfEdWkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753172611; a=rsa-sha256;
	cv=none;
	b=CBgfUGPB2+WlnJCB/6BQv3lcwXrw5TaiALblRwtZdeoxSa4ZlKMZzkREm9E5qYEBvDRGXM
	uU8urhreOMWf8al0o9RTYfkcZFPLRhCyOjtzhydJsqkxz5vj2hz7nQNHf3MdevCmj751dh
	ropUSqb4uS9xqJ6AMxssJqVoQ5DoEk8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vJKu2eJa;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D7DB8A55E04;
	Tue, 22 Jul 2025 08:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65EAC4CEF4;
	Tue, 22 Jul 2025 08:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753172610;
	bh=Y7L/rRO5yyKs2AKEjD3Is669RR4GnyvoU1Va0/d4nes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vJKu2eJataVITCVflCr840wmheOuK4XZlYWs6rrrZpZ8f8334JvjTIPjTBtcg9wmK
	 hR5ceZw2sIh+Bc1ywwL2YvnTVUnnhu5pNNCs4fpc4ayWUqS5XcKkPeUvBsSeB5DxEG
	 0/CXdshl05qh+Ss1Nmh0QUeiSO3LavlTOlLASQnBZnEMPKLDhte/RyXse9forwWwKE
	 o1DDCseBL37p9rIcjs59P5Lc6q3DSY6ZZ9ZZTUuzJvC2FesBKpl29GOEAy1h/BDi/T
	 yLyGxV3knvDunrs7c0b1bDSieX44bXlDNDruNlVmKPYTgNSZqKxMJvWYJOHtQXJgYJ
	 leAGO78mPSmuQ==
Date: Tue, 22 Jul 2025 11:23:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: mawupeng <mawupeng1@huawei.com>
Cc: akpm@linux-foundation.org, ardb@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ignore nomap memory during mirror init
Message-ID: <aH9KfV8XM5fNsR/Y@kernel.org>
References: <20250717085723.1875462-1-mawupeng1@huawei.com>
 <aHjQp9zPVPuPyP3B@kernel.org>
 <9688e968-e9af-4143-b550-16c02a0b4ceb@huawei.com>
 <aHj8mfecDhJJZW1Y@kernel.org>
 <8d604308-36d3-4b55-8ddb-b33f8b586c1a@huawei.com>
 <aHzjOxg_oPp06blC@kernel.org>
 <205873c9-b8cd-4aa7-822e-3c1d6a5a5ea7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205873c9-b8cd-4aa7-822e-3c1d6a5a5ea7@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99CA6120002
X-Stat-Signature: 6r5bjhooj6ymwyxtjbtfu3myzf3su6w5
X-Rspam-User: 
X-HE-Tag: 1753172611-972392
X-HE-Meta: U2FsdGVkX1+Wl1b/g2G2HRcmG3gJ0VPMH0ltyTJ5kSViDsXWKJWo+ZYNNWo/8OJWOkfaenBqupotVX1ganReXZhsOB6VkL95PwKZOTSDYJivYioy8GAyt2EQgEsNPMZmG/fDXH7Ndc2t3GCF0IiCOi+iWNJqivo+DFYCDltVqvkUiakB7JCArZCGi6g6pCnZ4kbdoJ1AqxFnplrzp6UwC5XfUheUCMzP3qIglT7ROIpDOwQM7MbeI5uVpVx9L2RBZu3n7B4rMMX4nBNVF3cDcAq79ippO0aBRR4dO2K4DlzoP8XC6EWymJtifaASEcFeo7YJysXTX1QYloZx0ThK3v/cO+JQUOe+lDi6U18v9MjsE1cD8ndGxKQfKFfmqLJZvJg6LN/M7YXGXl6MDoBOtBZOGsS7aZMayQ6X7WodqO65ipsDjJb+x1hLdt1N9J9uQ/yDIreMdlu/MUNpRtE9HcGbOluskP6DH2ci81zU7IVPmYi909ACD9VjkrhHz8WdmwD2s8pAmCpFO10c6usOKhggFOF1FHVd1aiKFXtwGueaqBVKSChQ+6WfM1xIFjLupzAZZGJGR1xpm7stzdJ6dmOYt1dIXSXHcjYoXIO0V+tBbSUz79dUGEg+mRus9M4LpPSkzlIMywzxrLGEPZlcuu+xKa+5bp7i+ePsL7QGtGkTxNKQi8Jb2pTjnsCGUarV6f6Y7c+iovM96g1bRcfageOKM/1Xbzw7rpL8IiwTwC+aLYe+R9OiydbN6RO9qHQbVUGabEsMpRyT1jK5KScPRijxWFKd7Eqn5n3tZuC5nOA8yDMvgguYPTIqF4xaHHdknC+tIIMz8d8UbERJ7tkkxxYzWUJKtLPrCPmWRNEgkXJsiK8gEEyfmX3FXPttH0XFdPFYuizASfYlopr9whJiqFaBLFf0u84V1Wp2qHzX0UNJBSjYysEk7Lfchd+nqM1BrtLnTnQJmWFb6mWIBVw
 oWxZ3uhX
 EJpqppHF4+wu53Bmi0UB6IqbMwlchHOA3Vm6JjPlAdPhKf2DdmS7IQnqRMXQfHgeoHP0BPZVko7iia48ii8xLfT0sgXfjYDM1AlFaz/TaN+fWN7E/aIYAYlEG35cGfpE16Vv/95yFqvQl2JYnTpkE4jNKcTACJpudz95WSLKrGWqbLh4Z7oPDWRB5wkSp4In3l+H8mVbolkxnakau+Ppicshmf8iBbXQnf2o3VVjaeVs2b266Rob51Zwoqqs8y+8mM5fX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 10:11:11AM +0800, mawupeng wrote:
> On 2025/7/20 20:38, Mike Rapoport wrote:
> > On Fri, Jul 18, 2025 at 09:37:48AM +0800, mawupeng wrote:
> >>
> >>
> >> On 2025/7/17 21:37, Mike Rapoport wrote:
> >>> On Thu, Jul 17, 2025 at 07:06:52PM +0800, mawupeng wrote:
> >>>>
> >>>> On 2025/7/17 18:29, Mike Rapoport wrote:
> >>>>> On Thu, Jul 17, 2025 at 04:57:23PM +0800, Wupeng Ma wrote:
> >>>>>> When memory mirroring is enabled, the BIOS may reserve memory regions
> >>>>>> at the start of the physical address space without the MR flag. This will
> >>>>>> lead to zone_movable_pfn to be updated to the start of these reserved
> >>>>>> regions, resulting in subsequent mirrored memory being ignored.
> >>>>>>
> >>>>>> Here is the log with efi=debug enabled:
> >>>>>>   efi:   0x084004000000-0x0842bf37ffff [Conventional|   |  |MR|...|WB|WT|WC|  ]
> >>>>>>   efi:   0x0842bf380000-0x0842c21effff [Loader Code |   |  |MR|...|WB|WT|WC|  ]
> >>>>>>   efi:   0x0842c21f0000-0x0847ffffffff [Conventional|   |  |MR|...|WB|WT|WC|  ]
> >>>>>>   efi:   0x085000000000-0x085fffffffff [Conventional|   |  |  |...|WB|WT|WC|  ]
> >>>>>> ...
> >>>>>>   efi:   0x084000000000-0x084003ffffff [Reserved    |   |  |  |...|WB|WT|WC|  ]
> >>>>>>
> >>>>>> Since this kind of memory can not be used by kernel. ignore nomap memory to fix
> >>>>>> this issue.
> >>>>
> >>>> Since the first non-mirror pfn of this node is 0x084000000000, then zone_movable_pfn 
> >>>> for this node will be updated to this. This will lead to Mirror Region 
> >>>>   - 0x084004000000-0x0842bf37ffff
> >>>>   - 0x0842bf380000-0x0842c21effff 
> >>>>   - 0x0842c21f0000-0x0847ffffffff
> >>>> be seen as non-mirror memory since zone_movable_pfn will be the start_pfn of this node
> >>>> in adjust_zone_range_for_zone_movable().
> >>>
> >>> What do you mean by "seen as non-mirror memory"?
> >>
> >> It mean these memory range will be add to movable zone.
> >>
> >>>
> >>> What is the problem with having movable zone on that node start at
> >>> 0x084000000000?
> >>>
> >>> Can you post the kernel log up to "Memory: nK/mK available" line for more
> >>> context?
> >>
> >> Memory: nK/mK available can not see be problem here, since there is nothing wrong
> >> with the total memory. However this problem can be shown via lsmem --output-all
> > 
> > I didn't ask for that particular line but for *up to that line*.
> >  
> >> w/o this patch
> >> [root@localhost ~]# lsmem --output-all
> >> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> >> 0x0000084000000000-0x00000847ffffffff   32G online       yes   67584-67839    0 Movable
> >> 0x0000085000000000-0x0000085fffffffff   64G online       yes   68096-68607    0 Movable
> >>
> >> w/ this patch
> >> [root@localhost ~]# lsmem --output-all
> >> RANGE                                  SIZE  STATE REMOVABLE         BLOCK NODE   ZONES
> >> 0x0000084000000000-0x00000847ffffffff   32G online       yes   8448-8479    0  Normal
> >> 0x0000085000000000-0x0000085fffffffff   64G online       yes   8512-8575    0 Movable
> > 
> > As I see the problem, you have a problematic firmware that fails to report
> > memory as mirrored because it reserved for firmware own use. This causes
> > for non-mirrored memory to appear before mirrored memory. And this breaks
> > an assumption in find_zone_movable_pfns_for_nodes() that mirrored memory
> > always has lower addresses than non-mirrored memory and you end up wiht
> > having all the memory in movable zone.
> 
> Yes.
> 
> > 
> > So to workaround this firmware issue you propose a hack that would skip
> > NOMAP regions while calculating zone_movable_pfn because your particular
> > firmware reports the reserved mirrored memory as NOMAP.
> > 
> > Why don't you simply pass "kernelcore=32G" on the command line and you'll
> > get the same result.
> 
> Since mirrored memory are in each node, not only one, "kernelcore=32G" can
> not fix this problem.

I don't see other nodes in lsmem output. And I asked for the kernel log
exactly to see how kernel sees the memory on the system.
 
Another question is do you really need ZONE_MOVABLE? Most of the time MM
core operates on the pageblock granularity and even if all the memory are
in ZONE_NORMAL the pageblocks are still movable.

-- 
Sincerely yours,
Mike.

