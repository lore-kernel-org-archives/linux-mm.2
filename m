Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EA6C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47076B008A; Sun, 18 Jan 2026 07:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EE56B008C; Sun, 18 Jan 2026 07:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9200E6B0092; Sun, 18 Jan 2026 07:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EBEC6B008A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:16:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 119F68BF5D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:16:44 +0000 (UTC)
X-FDA: 84344983128.02.181006A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8555A20003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:16:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kPKKUPNL;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768738602; a=rsa-sha256;
	cv=none;
	b=ETTv6YEilhR6D4Zms/73QHccrtLFIwPGB/gbgo8vK8xyrpFHLqhDImkbeV7GRsT6gO5MzM
	xY4wL7iZH1xJkNw9Gmg96t6UjQZ+qbtJmd6tW3C+m+gAbkMH/7rBwP8aQQLW8q8jXZyday
	MYUNo6NbgI9IPBW8788x5xiPHOc/ywc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kPKKUPNL;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768738602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFBnWOh1Hw/rPWlfuxf1cyW+AyiguOS5AieRNy1N54E=;
	b=73Kvw9lnosUjkXsh21CVLA5HfLKDaZJGimz32WPs8VI8TGj1lK4JY6n27HC7ZqO0S1M0Xm
	jP6vdq4d/8Bwcjtzu74v31IK16jx/91t1OdSI0I0+uJD+BvngyGG7AaiklGOdM0pYzBF+W
	r4FIhBqZSiy0cFaVc5lpGljddkkGUJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80BE560126;
	Sun, 18 Jan 2026 12:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2C9C116D0;
	Sun, 18 Jan 2026 12:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768738601;
	bh=GNLKijSufyMywtxmWVA+8J1TEZuTFKnq101th6Vg7vI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kPKKUPNLIgdW1FVtu6t0pHQsFANoX0X/bfdI+nnOOtyQoWwUbEywGQkG0rtvqmvGJ
	 I3fAz5b927vx35wgy9mmIcb/LEBGigkxdXVsXS79z3NI6I+Di69mAqfOaHBu+2L+yB
	 ELOdNY+us7iSLo3Lny9KrYowyJ5s2dyobs+AHGfsLddWBdxC8LbYHSyhkbvTJ9gAtj
	 BMpNCeNJZaLY8IGUm3MUR/Ke2Dt1HhIc6DFtQuShEuOKMN9UpecLCWh0BM36d1Z+Fc
	 Ld6sNLxtkUbxn+jDOi0025JJGv9MvgPnsRrK6n4r380JHjlwt3SOGRbH+6FfkNESVb
	 8pCvlPCJUbhkw==
Date: Sun, 18 Jan 2026 14:16:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, nh-open-source@amazon.com
Subject: Re: [PATCH] kho: skip memoryless NUMA nodes when reserving scratch
 areas
Message-ID: <aWzPIfZ0WeH0vca8@kernel.org>
References: <20260116112640.64900-1-epetron@amazon.de>
 <2vxzsec57oth.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzsec57oth.fsf@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8555A20003
X-Stat-Signature: y4ewfefiejoz6dewy6z531ne7gt5k397
X-Rspam-User: 
X-HE-Tag: 1768738602-514932
X-HE-Meta: U2FsdGVkX1+lkETgXFKbqMesw6u0J3X0PohhZDmJ8xnkNBi69NZT/g28DXEGcmIVAywt9VDUZ7THsOEfl0KuuUy1+PAn4D/2wMikS1uZXXQx3ReG9+GlHufjgmExC9v17D3x3Fv/OyjMAZmKUES/HDZXe7H9T/tZ91C+j5G8gCTQruQdtnZNoRvRhqp8IG8jy4IsFSpkfhy9ADZ/uei4j6MJN7/BrZdp2/eOWco7U/bV7anu8gKdQDjW97vLqr+IKhTvm85xwghdGBXAP5NhTu9t89YNRP1h7j5AQfeF+ihV0MzEa8rPVhJIFYbulTH7vCdw2uLS2+nkB1G/Q3pqU4RNgMptW4tXMaeA0tfl/Ij2RMKEKjwaytCnTgZlUXnBuHKt+NVFxrFdoqFXz0vzklIqmo7m9yA4d63R8H71kxige41RAFDIZyqeDxz+IJ9JgchvTDrHvjjZzl8Vg8ljFSoVhSZPFWbvLcTuDsE9d3SRYKf9DVjTB8iT6Gcg1G2G5Yv6LqLN0uWN+Iz7Ql4kFqrD2odBTRSpl1QNThWzGbR1xEPt+RRh1cMigHZKyKFQVqGBY+lqijHhgXCc2/PxkRsIJ8l+ZhDv11LhAn2Yf8v66XgiIiSY4IIaE2c8v7JhHz2xrGk6ofjI1YvgqwnRmJlrorR9hxUIZ5WR3L1UJfmS4gfEhWE72g9w6luEq2zWFsG+zKFCCLYbhPZjGI6BiJZeybTeWk4s2MRvBcF5l+5cVPEJbHTPjFInGOOeXl1rvBWGABbSsP9FT6FiApvQRSkkgI5OZFR3PQlTdUPCDPD1EJAFWoxHjbC5ypjYHbmelEsAIJu4PHCaTCRQ7wpf7Zt+VwizbsVF2w9CmWmm5BjOqchMq1PYj8tOS1ebngnE6ikWppfNPlG4x63jYC3NWs4Cuf6ihDry07LOo8xoElSkMTbH9uHNRceDMT6CHj8LcTLTB0yj89xPy5fGhrI
 ZZWp4BEv
 8tk5odkKs0jD1WOUPXCJ8JMGAR4wlrBnf1S6QEXXKAp48pOaUywi/qqYwK64qrPIbd4CRkBORtZABKHuJmjRpb6miW3EoX89jg8IKNSQwJON1O7hz1qV1F9a8zVRypLfVabgmFv1vGYwy2O/xFGz7oILW5l4jtXXW+3Ozaso6WNo4gpPBcZGW+KxCgKMR3bAKtyxC01cx45wgzM8pulv4ZxQsYW7gf4w7+mfMgM94VRrZtcGwsiyEZTIi10T6sMYLnMAN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 11:57:14AM +0000, Pratyush Yadav wrote:
> Hi Evangelos,
> 
> On Fri, Jan 16 2026, Evangelos Petrongonas wrote:
> 
> > kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> > per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> > that have CPUs but no memory), memblock_alloc_range_nid() fails because
> > there is no memory available on that node. This causes KHO initialization
> > to fail and kho_enable to be set to false.
> >
> > Some ARM64 systems have NUMA topologies where certain nodes contain only
> > CPUs without any associated memory. These configurations are valid and
> > should not prevent KHO from functioning.
> >
> > Fix this by introducing kho_mem_nodes_count() which counts only nodes
> > that have memory (N_MEMORY state), and skip memoryless nodes in the
> > per-node scratch allocation loop.
> >
> > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 9dc51fab604f..c970ed08b477 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -623,6 +623,23 @@ static phys_addr_t __init scratch_size_node(int nid)
> >  	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
> >  }
> >  
> > +/*
> > + * Count online NUMA nodes that have memory. Memoryless nodes cannot have
> > + * scratch memory and should be excluded.
> > + */
> > +static unsigned int __init kho_mem_nodes_count(void)
> > +{
> > +	unsigned int cnt = 0;
> > +	int nid;
> > +
> > +	for_each_online_node(nid) {
> > +		if (node_state(nid, N_MEMORY))
> > +			cnt++;
> > +	}
> > +
> > +	return cnt;
> > +}
> > +
> 
> You don't need this. You can use nodes_weight(nodes_state[N_MEMORY])
> directly. Other than this, LGTM.
> 
> >  /**
> >   * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
> >   *
> > @@ -643,7 +660,7 @@ static void __init kho_reserve_scratch(void)
> >  	scratch_size_update();
> >  
> >  	/* FIXME: deal with node hot-plug/remove */
> > -	kho_scratch_cnt = num_online_nodes() + 2;
> > +	kho_scratch_cnt = kho_mem_nodes_count() + 2;
> >  	size = kho_scratch_cnt * sizeof(*kho_scratch);
> >  	kho_scratch = memblock_alloc(size, PAGE_SIZE);
> >  	if (!kho_scratch)
> > @@ -674,6 +691,10 @@ static void __init kho_reserve_scratch(void)
> >  	i++;
> >  
> >  	for_each_online_node(nid) {
> > +		/* Skip memoryless nodes - we cannot allocate scratch memory there */
> > +		if (!node_state(nid, N_MEMORY))
> > +			continue;
> > +

And here you can use for_each_node_state(nid, N_MEMORY)

> >  		size = scratch_size_node(nid);
> >  		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
> >  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

