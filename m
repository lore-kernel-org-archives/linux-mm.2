Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1FF606EEA1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlwcYR8B
Received: by kanga.kvack.org (Postfix)
	id 93B7A6B05B0; Thu,  5 Nov 2026 10:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAC56B05B3; Thu,  5 Nov 2026 10:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA8C6B05B4; Thu,  5 Nov 2026 10:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 520036B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:19:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBE4F160A52
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:19:06 +0000 (UTC)
X-FDA: 85401423492.14.E999CF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 464924000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:19:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlwcYR8B;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793891945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKiZ/1xYg1mZQ+x77zJSdGqKILLfHb0uloTlfc1un2E=;
	b=JRpurGmiyQWzvFf5B1oshwKadRi1RFtfrh9/JFKwaHeXW8+a8HPMEDsJbEf/RkLMiEQXUn
	gzmcl6KB0n08isdxgA4hCdzHJDUDcLrnpxVk4oTioMAy2q2D86vxcmN7pXhUGqWugjgmEk
	gMd0x36sVTC6eIUcMYP8Lbhz3uJcoK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793891945;
	b=ZoL+C4ndZK+k0cE9s4ZfPAEqO9rI57sndCXMPg6NizBQgjlzRLtSobeBDsvlqtd6OK/LZ8
	4N7RmWB6qr151eoEYHxB/nae3+y3DEVIA4uKH3vLjLheAIg+dBfCypIobmGf1cK8TxGecr
	s+XPwcnkGmtgH7hyx4ZCecArtpGF6NI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlwcYR8B;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCD13609EE;
	Thu,  5 Nov 2026 15:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA61F0093A;
	Thu,  5 Nov 2026 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793891943;
	bh=pKiZ/1xYg1mZQ+x77zJSdGqKILLfHb0uloTlfc1un2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IlwcYR8Bp6ILBV55zCVNHC4X/M5nI648eWO+3aRqrOSYFZr2gIkhNnVHlHDmX0vmh
	 KvK8m4Vsdu0VvAux0EyoBKYYLMG53jKFuue3+i2tkx0XYh5VNG9B8slKvR2K38dErT
	 NBThJe9I2fNLqwONdQr+Kmgb2ArT93XFw1z9nJySjDgbTluiZjInIkVw4n+2dgkDL9
	 /NGGP42LZhHDVy+4l2iTNB+Q8hId/+/Tb3Fml7Kb4kPRKbcqB3ouXvRCELSiV64GDg
	 P1zw+LAFWWg2z0uvcgU1CG9ALbOpLczIit/+8zd1xv5Sm0euiGP69ey1r+xrHZAq60
	 b4bxLpZwmQyYg==
Date: Thu, 5 Nov 2026 15:19:01 +0000
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
Message-ID: <auycUvCC2mL_EQ1r@thinkstation>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
 <auHcj2G78VkXy-Vz@fedora>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auHcj2G78VkXy-Vz@fedora>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 464924000D
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p8uqot9m64yhz9mxpijc3hu4ywsj4g4z
X-Rspam-User: 
X-HE-Tag: 1793891945-970621
X-HE-Meta: U2FsdGVkX1/0DETCqGBeTF5vWewAZVHPg4gYVQQfCZa5SHXrDhoSOf9JErHPWIMwnc8fBBvnJS+7PMziHNbV2uT9GofcVLeM3/NcyZu/90oDyRJmZtukSyTihNd09PYP8qwV35Mxy4VV6eDTz9w4odL/1JPgLmdOLJ7ROztmCoGt6/LWB0HYqAA6QKp/0xK6xtXYhzS+TMfWA7Twtt4e8iM8mDkjfhv4RtNRyuIihQgWgE1ucshQwfs8r9KOvrpjMAwSw1uGo+XNFV0jDy3HqRx1TABJc8rObFEuQmG77zyddLjtO7e7kAzQZbmju3kAoRP7e701H7NV0+7zPNNYgMA/G3RHFUYzXhKvSiKROtWyT4Ztq3lt8MKanEiugu5uqbIpxoLFH1EGj8nkB2dQTEavACpHcPOqQyxN2i5MFO/P7TyO+3DrrWsDZWcQEL5lzI+4E+OtBxo1sUAVVtUFI+B88WfPNLfVEJkGCaSqOubdhN3kZuqz+Eh4c/dZbN80ZLZaEZYlJQCMKgtJOXoyqfY1STmFRJrjvDXU4+RYp43rCzNvPC3l6v56l0avAYiFCh4GYdY+ITJTOPvCN+HDF9zDmOof+zj9m2sqIKtu+Mv1AKQt9kSvxKrfDPfmanYFwTy5CQw0Lcg6dPMFQfpNxYxd4xBxPWCqylMDB70L945AJpekbKqKNQP0hQDnTItBiP5HZNYEo2xN1nwvxDJjhcWrN9qXUpSgNMsXLVjZuFWEdl6Ady3OiRjZ/TIED0OXzEKFcQnP2koZ2lkR3P31YvCN9DpSTsmgLUwfkHq2pLA5AY/n0dDLrH48DpcrMLtsQcC4UR/eq5zHEmDFeVKLejGIqFws4AmkpuVkL5B5Jjh4UR2LY4WBLxSwLpgyxFiVGFFcdQAseZccM61Z5RuCi85Zrjw3ShbcgN1EKpJXiX81Ox18jNhj7zUtcQpkvMMTmKcN+SB7xL9082/dBlF
 Y4+kGvq2
 hX31F8/CIUTu+4UO+LoUXA9mrc+Ke5A0ZpNz/eXS50/azNXhk3iKrfNVphpStPajFMvtUfIAcW8j8/hoDvUKjZv1vB1JPPvb06TsBGNmybgSW+R0LWx//gm/Wbl8EDq819CdJmT3AhWf2d9t7AKQ9xTe5zY0FGfruwQCnN9nCvF9kpWihfbp8RPmxJO20wBzbYvosyPsH4D7dT7kr1tpyQdVrTKtANj/oRxfG4OiPapcZHPCr9PabKqZzcaVgG1RUh/lJOqKl7aBprBOh3oO00gZeACaEz/SX4zkqnY9yC8oW8+vKVn8cAaOA9J6Ft31crcRy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 07:43:14PM +0800, Hao Li wrote:
> On Sat, Oct 24, 2026 at 09:07:25PM +0200, Vlastimil Babka (SUSE) wrote:
> > One (relatively minor) aspect of CONFIG_SLUB_TINY is the assumption that
> > letting reclaimable and non-reclaimable caches merge will save more
> > memory, which is more important on small systems than the page allocator
> > level fragmentation (where distinguishing reclaimable slabs should
> > help).
> > 
> > For now that has been achieved by #ifdefs that result in making the
> > SLAB_RECLAIM_ACCOUNT no-op and aliasing KMALLOC_RECLAIM to
> > KMALLOC_NORMAL on the enum values level.
> > 
> > With the goal of converting CONFIG_SLUB_TINY to a boot-time decision,
> > rework this so that SLAB_RECLAIM_ACCOUNT and KMALLOC_RECLAIM are
> > distinctly defined always. Now, creation of kmalloc-rcl caches is
> > avoided by assigning a pointer to the normal kmalloc cache on the
> > kmalloc_caches array level.
> > 
> > To prepare disconnecting of this boot-time decision (and the evaluation
> > of the need for kmalloc_no_objext) from CONFIG_SLUB_TINY, introduce a
> > slub_tiny_enabled variable that's initialized to the CONFIG_SLUB_TINY
> > state.
> > 
> > There is one minor functional change for CONFIG_SLUB_TINY=y. Since
> > SLAB_RECLAIM_ACCOUNT is not 0 anymore, caches that differ only in that
> > flag will stop being mergeable. If that turns out to have a noticeable
> > impact on memory footprint, we can adjust the merging decisions to
> > ignore SLAB_RECLAIM_ACCOUNT when slub_tiny_enabled is true.
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
> >  include/linux/slab.h | 10 ----------
> >  mm/slab.h            |  5 +++--
> >  mm/slab_common.c     | 12 ++++++------
> >  mm/slub.c            |  2 ++
> 
> [...]
> 
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 02dfe4351e8b..33e76a0c3084 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1009,7 +1009,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
> >  	 * KMALLOC_NO_OBJ_EXT cache.
> >  	 */
> >  	if (!mem_cgroup_kmem_disabled()) {
> > -		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> > +		if (type == KMALLOC_NORMAL && !slab_tiny_enabled)
> 
> (While reviewing Harry's patch [1], I happened to notice a small inconsistency
> in the current code. Since these lines are being touched in this series, I
> figured I'd bring it up here, even though I haven't properly started reviewing
> this series yet :D)
> 
> IIUC, for both KMALLOC_NORMAL and KMALLOC_PARTITION_START + n, if gfp has
> __GFP_ACCOUNT set (and without __GFP_DMA/__GFP_RECLAIMABLE), the allocation is
> redirected to KMALLOC_CGROUP.

Right.

> This seems to mean that neither KMALLOC_NORMAL
> nor KMALLOC_PARTITION_START + n actually needs an objcg slot in obj_exts.

Right.

> Right now, KMALLOC_NORMAL already doesn't carry SLAB_MAY_ACCOUNT, but
> KMALLOC_PARTITION_START + n still does.

Ouch, good catch!

> Given that, would it make sense to
> change this line to something like:
> 
> if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END &&
> 	!slab_tiny_enabled)

Maybe you could send a patch as it's a separate issue from the patchset?

> [1] https://lore.kernel.org/linux-mm/20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org/

-- 
Cheers,
Harry / Hyeonggon

