Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3E5606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UH8BzPZP
Received: by kanga.kvack.org (Postfix)
	id 742B56B00EF; Tue,  3 Nov 2026 13:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3406B05B2; Tue,  3 Nov 2026 13:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608DC6B05B4; Tue,  3 Nov 2026 13:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4710D6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:36:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE6C64050F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:36:10 +0000 (UTC)
X-FDA: 85394662500.05.2AC9AC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 00CA340002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:36:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UH8BzPZP;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXtqewBsP373CPIOAi6YTJNiMe9FVQMK+bBEbUQClZU=;
	b=A+lxuOEizsx6yVKTN9d/7wgQ8jkBW2GsXhtfSrE5rZ6zDFFO4m8mLngTzf6tqxoyjYI+t+
	1Kf23wm/zqBohj1tvmyJKdDVu85LdLgiimpc0lg0i/1LdGfaCTFr/xvFTgEcTFaQXwHsFE
	LVAAQ7INadMndjvxfG2t+wPH1wfIeV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730969;
	b=ukTJ4eL5wTJS2zGxlQWC42PZcyt55KeJ5m4eu7EIt1Dj8IXp2io9OrcESO2LQKlxEv6GRD
	VJxzma6ON6z6RqKUXkf/Nx1qnmGvjRPg2CnGAsswg7sQaHDSoFC4tHXY+23Pir9Ia+fTUV
	JMYGH/qd3ISS8UtWdVAjrEySn2PgKXM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UH8BzPZP;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43A8A43DAB;
	Tue,  3 Nov 2026 18:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16B61F00A15;
	Tue,  3 Nov 2026 18:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730968;
	bh=BXtqewBsP373CPIOAi6YTJNiMe9FVQMK+bBEbUQClZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UH8BzPZP8cqAcgbW0cJ2L2+EeGFa8v1ugJxgyujaVpJRuRY+sSCplVUE39iUvpYeu
	 D6ecFGlEC6/3TCkletVwNohOQv2BJNrNjwk7jIgifq72h/eagD0XCTcNzHg9FYs0Wj
	 HlsU+MQghxeeGnDEUZNxmhKoSDPp8ER3jnt71KYlUs8BJsH3yp3I56jFVTzAPJDi3T
	 cI/VO1uVPhFX8+5NWFOi4/0yk7U/i8sJgZkThrJDsHx98cnlkrRyhWZk+pz6MJC5lV
	 ovSEHcqvAE49zuIHSkwCpalvys7U15hZlL6DBvwTR10SnI2vHvMkF3Nfb27NjxX9ow
	 DLArzvkvQGnTg==
Date: Tue, 3 Nov 2026 20:36:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] kho: fix bootmem sizing
Message-ID: <auopkIsiqxzg4anJ@kernel.org>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
 <20261103-kho-bootmem-sizing-v1-2-45aa74098f34@kernel.org>
 <2vxz5wydnbuj.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz5wydnbuj.fsf@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: d7ixdzxwrzh6redy96689wtkzkta6kis
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 00CA340002
X-Rspam-User: 
X-HE-Tag: 1793730968-909145
X-HE-Meta: U2FsdGVkX19ECFc3y8cQfO8QsW+1bdXhFNtkmFqAoAiOZDmgBDDaCPu8It6Sc+JLJ2vCOn0NYi/KXG+9+VLP66R75ZxZKUiAlFIRMb+QMQTquc1ffuX/hxTmeSv9UtyQ5izUL70P8q9zWhj1MS+QcjcxBlIfoN1pStC1YJdGZtTR3CWCDj1I9jcASfKz3aULAnS9pfjG6j2vE/Gp2pYj3tKC4jlsqk05Ji2x048T8go9fhknLwS/bNNEgiJlxwmK7c0VaMq+kjKzmsJxLAaJldIpOon2pTSInRf/exn5zNlQZU9lSeFMQcWvtOJZL+iyX8YUVtvvlERnNa70nOt2IJ0ccWtor088GBmF7HqHNmZDAYh6gABjuLfu0tsJWytih/W1ch45YEOZCqWx0rFH6TGQExtWgvuOApUifll2f539Pzo2CEmBrF5vfqwJGQ10KSpcBxN98jsa3eFjnjXHks4uAFhs/bEze0/lSe6MDf22sIosd7RX6gbIpKtus75mUugK9PkWjmT5BSLaHM56ubr2IXb4HcH/i3IlmNnBTipiEe2l2qHhHNUGQhmKyTJYnmuqZP0Ox1tyse0y8QPEo8jeyyKnBx6z2XtTMhfIi9UAlpZEEj+OZoBTt1o+J1v5Aqc4PK6v6U+ER+CxiUcfuEOiKUADuNPFDZcCyS4B+tH+O8MBr1D3MU7Kha1fUbBNP1xiAYWcMInVnhpFb9UduVZ3cFLBvOamuO9cvAR+PWywjaT4/eGEnezbkgxmngwHCNE0ZmIucZGTHJVjeS8ZJeVOS75EJk+ROpMVBeC6BtgCFUaFrBPeYtJls/RMj3Jdb2tGPRfQoaDR8VR/vS/v1xb4tMbyB9xJ8KjSXKRbhi3buG3euDqqMhl221fFTur3aBa27IMvwwzINwGC6bjb1Ft68YPfYRhLXAZ4WJghGQubEELQcaD6F4v7swg0b62PJ7TaQadHNCC2ejPhkQn
 g3fTSZwh
 FKcM2zTejukNwSS6f2xsdTw+U8Gn4GMoS33W7JiyyZH6jlYj9ZKZ4J37ifRknzTFs8z304jBq7e+AI5TJW/C7udE2YZfrbKAC4YAzJO9wfewkVvz0me+oUQ1/A7/PnggHaeKDu1U1pytLTOqQ/6YZUTht33CzTIGYlJ5u+aS0scy+N7isLUICgm6O4mU45Rb/CZKnaDp8X3g9YfYS2VmAgU5cebt9amMoL73ArFmwgkvvOPR7JXD8UBeVki6P5ymkxiKGpebl08uFG1GXPNpH2ePjDHm2AIhdnx0Vp166oO5+lKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 05:01:08PM +0100, Pratyush Yadav wrote:
> Hi Mike,
> 
> On Tue, Nov 03 2026, Mike Rapoport (Microsoft) wrote:
> 
> > Bootmem areas are sized from overlapping views of the memory reserved in
> > memblock:
> >
> > * the global area is sized from all reserved memory, including memory
> >   allocated on specific nodes, so on NUMA systems everything allocated
> >   on a node is accounted in both the global area and the area of that
> >   node.
> > * per-node sizes are calculated after the lowmem and the global areas
> >   are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
> >   so the lowmem and the global areas are accounted in the size of node 0
> >   area and scaled once again.
> >
> > As a result, bootmem is about twice bigger than it should be on NUMA
> > systems and about four times bigger with CONFIG_NUMA=n. On small systems
> > reservation of the bootmem may fail and then KHO gets disabled.
> >
> > Make the areas cover separate parts of the reserved memory: the lowmem
> > area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
> > cover allocations above it on each node and the global area covers
> > allocations that are not bound to any node. Calculate all sizes before
> > reserving any of the areas.
> >
> > With CONFIG_NUMA=n the global area becomes empty and it is not reserved.
> >
> > Bootmem sizes in MiB in x86 QEMU VMs, before -> after:
> >
> >                      CONFIG_NUMA=y     CONFIG_NUMA=n
> >   1G,  1 node         176 ->   92       320 ->   80
> >   4G,  1 node         508 ->  332      1264 ->  316
> >   16G, 2 nodes       1268 ->  704      2944 ->  736
> >   32G, 4 nodes       2296 -> 1224      5196 -> 1300
> >   64G, 4 nodes       4344 -> 2248      9664 -> 2420
> >
> > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> > Reported-by: Kexin Liu <liukexin@kylinos.cn>
> > Reported-by: George Guo <guodongtai@kylinos.cn>
> > Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
> > Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> > Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks for the patch! My LLM caught an interesting problems that is
> worth considering.
> 
> On arm64, ARCH_LOW_ADDRESS_LIMIT is arm64_dma_phys_limit - 1, and
> dma_limits_init() sets the default value to PHYS_MASK + 1, and it can
> also be memblock_end_of_dram() in some cases. So on arm64, it is
> possible for lowmem to span the entire RAM.
> 
> Currently, that results in over-allocation of bootmem, and it ends up
> being 4x what it should be. While obviously problematic, it should still
> work. With this patch, all memory is in lowmem, and nothing ever goes to
> per-node bootmem (except for the node that hosts the lowmem area).
> 
> All this is from reading the code, I haven't tried anything out yet.
> 
> Not sure how to fix this though. Should we perhaps use
> min(ARCH_LOW_ADDRESS_LIMIT, U32_MAX) for the lowmem limit?

Argh :)

Maybe we reset lowmem to zero if memblock_end_of_DRAM() <
ARCH_LOW_ADDRESS_LIMIT?
 
> Also, a couple nitpicks below.
> 
> > ---
> >  kernel/liveupdate/kexec_handover.c | 83 ++++++++++++++++++++------------------
> >  1 file changed, 44 insertions(+), 39 deletions(-)
> >
> > +
> > +		lowmem = reserved_mem_size(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE);
> > +		global = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE);
> > +		global -= lowmem;
> 
> Nit: Please add a short comment above this to explain why you remove
> lowmem from global.

I prefer to extend the comment above the function to say that calculations
for global and node that includes lowmem remove that.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

