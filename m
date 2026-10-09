Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F0CCA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DF26B0088; Fri,  9 Oct 2026 13:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E696B008A; Fri,  9 Oct 2026 13:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FC76B0099; Fri,  9 Oct 2026 13:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA03B6B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:01:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BF80160484
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:01:19 +0000 (UTC)
X-FDA: 85303703478.26.F698468
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0D98DC0016
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:01:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OKCsDWz3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7ihvZr9z;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d91JU66W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KcOgOphY;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vW0Z2YAuAu+y8eIrdsV6xo/3lhL0j96EwTJkuyKSiGc=;
	b=PxsodDFcChD9QWOUy8VBf5H/nAla9bFt0iyh9I7GI+X+KYK7K6ByoQQpQRefqTQDRKArhl
	HI5sL/bf4iC6fv2cGBriNnhWX0PXkH5YYMNxA97Z2gDrQQvmBTUANbqEGb0iFHddcT3kOr
	TFbaXnJ7dmyL6NGs/2qbfVN6vX52+f0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565277;
	b=mDbtn98pNUJ0FL2aEq1V4Y1pGT3cX9O/jcWm+pLg4VtnZNFSNIBMwP7j6EujCjvJ7f71bX
	TUo31A+ytef1DbOTVameBVN7NBTp0/OsgYKPvNd0aqrHJzj/Ta+z6uUKktviY7XSEWVAWy
	IIfftZ0s/O5N4rQVx1kBe+4iL+AwVwg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OKCsDWz3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7ihvZr9z;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d91JU66W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KcOgOphY;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8AA341F38F;
	Fri,  9 Oct 2026 17:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791565275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW0Z2YAuAu+y8eIrdsV6xo/3lhL0j96EwTJkuyKSiGc=;
	b=OKCsDWz3wZV/8UaBe+UwL8bAGZn28d4+ndjd2+913xamP3KKFqiOuRWdmQOSPqjhHfKe1I
	8XxN95oMrOeYsTgm0GwbCfgFaHvuD22uAsam9qRnIwsdvs27dSVq7eEZRxEuJqvPAqZB3T
	LJAWbkl+4VWbApHIGCmK0vfoBAbZf9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791565275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW0Z2YAuAu+y8eIrdsV6xo/3lhL0j96EwTJkuyKSiGc=;
	b=7ihvZr9zEtieha8PAh591N/iiz0shJn69GqfbBgcXSetCQHxVkUGU++BFLHFBhEsheaJ7/
	ShMpCIES+yjXZcBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791565274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW0Z2YAuAu+y8eIrdsV6xo/3lhL0j96EwTJkuyKSiGc=;
	b=d91JU66WRMzXd7zRM6eggu3mIm+JqAdqCRcNy0PkpaQYmeQLLxs4IEEjC2/apuUrMzv54n
	85kZJh8uFRuPwnRPCl3o9SpCW4zLZG5oOeznc4uogR9B0shOyP0rnFgWPzUDoS42oQ00j5
	spzO3QAnbRdxiwddAGDD+Bz5u4Ehbkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791565274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW0Z2YAuAu+y8eIrdsV6xo/3lhL0j96EwTJkuyKSiGc=;
	b=KcOgOphYjoBpLH5XvcGPKwluCvsx/EtxvBd50Y30X38vBcdx9NA46So2xq9bLLEhZ/kRZY
	PDiBDxf9xLeCgnCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 761371326D;
	Fri,  9 Oct 2026 17:01:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +KsMEdkdyWouRAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 09 Oct 2026 17:01:13 +0000
Date: Fri, 9 Oct 2026 18:01:11 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memory: fix truncation removing mapped folios
Message-ID: <askdZgd5P986OSMx@pedro-suse.tail5790ac.ts.net>
References: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
 <asjXJZap53yJWMYi@gremlin>
 <asjr2zCp1BVtfpTV@pedro-suse.tail5790ac.ts.net>
 <62e0ce97-1016-4f82-af38-7703c8cffefa@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62e0ce97-1016-4f82-af38-7703c8cffefa@linux.alibaba.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D98DC0016
X-Rspam-User: 
X-Stat-Signature: w8rog3tycj8hbwqy4p1ujoijzomg4xbw
X-HE-Tag: 1791565276-295817
X-HE-Meta: U2FsdGVkX1+pMeRMGo4VyxgejyAQzqQK16ccdUTvZg6nmDDa/vbgAtHAb2GnR6P3awuloQN1H/eVNlCL1TNucwgZO1VzAZwmNpYYyYuswqXpRrrWNwi+wOVooQv+VcCQrNR7COqr0ECSX3Jti/CH/4maDXqZE62zmIrYCSY1J3zZ27pg8pRmZ8F/60I7qDi9iet59XkKi7OgzjmzRA6mcCCjGprlVGrOq72O0chmc3TF2/wEV2gOp7HctQ0LDX8j2HjUuRo7NqGn57sOdbTvVkN8xKHYOzbXlL5vN27/L0pqNJ1JtEbAfw97U/01YpT5nVI56LSE1tbPWxnjMpeTeZuO7kJM4/tj3onma2S2mGhm+E+RWEQKBo1P8VQCVWjccNKPR2Fs5fZ9u53eTCK0mC3k62FkTERqHORoo89rY1WJoUVkN5ClwJBlb2rKRznUQG0az+j8VEPya1JlllBMs8ZXeoBI2eqphImjQ+2/LUEOsafC+77yZs2HqC/GW8Zce25Yexe9J3tFHkyRSUb+ONGeGM3iZR3ctFHIjstlk2PxIIH4WrpgDSPTmhw3q6GqxuFGZjwMEbSIDoBRqQ9uijdPMDg2Dr/GNMM5P/yoVTIUKacXVGr4YZ4LSVl59XVLsM/+d/NNP7ceV7zw6cYxzjsgLvb0mbobf+9tMxNHDiPy2qXRKJNEbrpWAgwkN9vhdri9WByGk0MFjumeSATr+l1EDMVirNxEErz88KM8KCS8pl3Hyk2PdC54+KDYeDZ0/k+TDYt6irynKSo1r3WaGbQ0cRQpzMlxWAhfgKMXHEOx2X6FctUQ39uUozFauU1JzBWnBNFZ+27SFtnr7NE6f3p5wjnN5NFvDpOaZemmregyZa0ZMygMyNWEbXWLdmIP2r6VUISDAryJIVektplS4MogOnl2FyJoF80edizC03I7jmDcku3NA2vG7IFv0wyusKvN+bqc4BFh/xbH6Rt
 zZmTWLLc
 DU7U7U/JtV+PGXWObGS3CrKL7RJk/5MhVrCLMIAeJoYJz/p0pY+IXBdXpqJF5jJiItdxnK3JwWrnOQlvaCF9SyG03wqiuDFWazK/kWHHEv6chqJPfNq/7g5eNAn1Xh1HaQHOKdECKwQ5Aron3JvOf39DFlfI1v0+owJwF2pebha58utyqQos/wRB0Aw7Qc/Y3ealOP128VCWmhDPgTRP6ul+MONoyWTPU28yarPSBcxz7UaWlA/dE0TCEoDm+1s6647uQU9DA1Nrqcpman0Vd3knUrnvDV74A9GKZPbcbz8NI9lUaDbGeKBVAROXvIYGrkXrsreP4vHxZl+tPOmTsOicfvc0a7BtXDtnF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 09:53:55PM +0800, Baolin Wang wrote:
> 
> 
> On 10/9/26 9:36 PM, Pedro Falcato wrote:
> > On Fri, Oct 09, 2026 at 01:00:52PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Fri, Oct 09, 2026 at 06:12:03PM +0800, Baolin Wang wrote:
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index 1f5d5f7d39cd..0272217ad7b0 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > 
> > > > @@ -2044,16 +2053,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
> > > >   	 * to ensure they are still none, thereby preventing the pte entries
> > > >   	 * from being repopulated by another thread.
> > > >   	 */
> > > > -	if (can_reclaim_pt && direct_reclaim && addr == end)
> > > > +	if (can_reclaim_pt && direct_reclaim && addr == end) {
> > > > +		/* rmap changes need to be observed before e.g PTEs get zapped. */
> > > > +		smp_wmb();
> > > 
> > > What does this pair with? You should always say what in the comment.
> > 
> > Yep, this is missing a rmb to pair with. The diff I posted at
> > https://lore.kernel.org/linux-mm/asigKktcrSY80A_2@pedro-suse.tail5790ac.ts.net/
> > had one in zap_pmd_range(), which admittedly isn't the greatest. I'm not sure if
> > there's a better way to do this.
> 
> I don't think we need an rmb to pair with. This is because the
> folio_mapped() check in __filemap_remove_folio() cannot be reordered
> (guarded by spinlock) with the pmd_none() check in zap_pmd_range().

Why? spin_lock has ACQUIRE semantics, which are one-way permeable. Earlier
loads and stores do not necessarily happen-before anything after the ACQUIRE.
Unless you mean something else.

> 
> We just need to guarantee that when we find a pmd_none(), the removal of the
> folio's mapping (via tlb_flush_rmaps()) is already observed.
> 
> 
> > > rmb/wmb are generally not needed vs. acquire/release. Are you sure a wmb is
> > > right here?
> > 
> > I don't think that works, because __folio_remove_rmap has a ton of stuff going
> > on, some implying full ordering, others not. Plus you'd need to switch the pmd
> > dereference to something like an smp_load_acquire().
> 
> Agree.

-- 
Pedro

