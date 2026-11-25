Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA32606A697
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvreFhGE
Received: by kanga.kvack.org (Postfix)
	id CDD5B6B0A27; Wed, 25 Nov 2026 09:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4196B0A29; Wed, 25 Nov 2026 09:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2436B0A2A; Wed, 25 Nov 2026 09:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2F96B0A27
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:10:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FF1F140ED5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:10:50 +0000 (UTC)
X-FDA: 85473827460.22.F225BB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B0AC16000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:10:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvreFhGE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795615848;
	b=1zBgwvxINknEe7y7tLVsn4RCB5Jwu2MLZgjgI8yR4qvoXAptleLYw1o86iV26pR7r05IZI
	V1X/ZAnrrxoPMUsWrMoRTwpIUC+9g3mtx/Ev+LQ3sulJyOJE7+P9Op3YvFDeRp+s4wIcHa
	RllvdK5JSTjDoXhyO60PVgutlJ66eTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795615848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvG2udng3DFxjfopgd41WWndiQho+1dwKgg/AssAfVI=;
	b=lWZWwyIXUhS5OrHBGL0Adguwmx3SfR1wWysmitk6J28Jx94W0D8QPPB59p/mpNEpMuuPfJ
	4hjeHGJa6EiXEe1uKS14kkQxGjznlieOUkH4Cia7XAYuruWrdKlQb0usAD5vYN2AWeUMu/
	BTiH+9vzcQnUslOKcKxA9QpvgA4+uYM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvreFhGE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAE68437A3;
	Wed, 25 Nov 2026 14:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0251F000D8;
	Wed, 25 Nov 2026 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615847;
	bh=MvG2udng3DFxjfopgd41WWndiQho+1dwKgg/AssAfVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jvreFhGEoi3Y/lF1wD38ln+TGJjPKI1JP0HS83P5ZxOskLDIjKRLeIWgdbwgXcsGF
	 6IizzYlr9SfX2BnT+55b15GqS69UG4Jog9LlEZW8Yv+C1UIUdFeqEwXbexsD4cpWI5
	 xzbYO9KXDH97oUJlEQWhTUwMUcylgH6SQAXA1CI4aPX/zxgKQHmqwgm+lUk5puw9FL
	 9N/LBVRBnkem9GNTesf70W1YPHLfKQbn+QgCeLVIQGrYtwm/ynwMevPBbkjr6Zw0X8
	 DfvHA1I9gRLvdQ7IvqaXadd1UEfPo695geFLtoPnE5q/rG1q2SW0bOfh5OEqpWdW65
	 NxlYpSm4/Gwzg==
Date: Wed, 25 Nov 2026 14:10:45 +0000
From: Harry Yoo <harry@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] mm/slub: don't let kmemleak report rcu sheaves
Message-ID: <awbq19zVSt5cqM2V@thinkstation>
References: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
 <0e626675-c6f9-40d7-a4ae-de069154ada2@kernel.org>
 <avzduIJralOKBgxK@arm.com>
 <av3NBYxYXyYk_tjS@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av3NBYxYXyYk_tjS@arm.com>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: xkynwr3fxtsckdm43j9p31rrcibdh5ug
X-Rspamd-Queue-Id: 7B0AC16000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795615848-37640
X-HE-Meta: U2FsdGVkX19zHMSbScRBMXeuuPyV9a1S/lmmCXxm9hz6vog+cVbf4dsPzaQVL8yx2lilHDrHYltbrn5fFtF3lQZL5O2LtVJnYU2IE5xCmvGn1fucrymYyDnOv5tDnWe2XZ7qlbKmAJHj+2hnxlZNFYgzyNP0khpXC+Eqa5utiBqG7SjLTQWDJ5yPn+3lofyYXINIpqETON+MXpHmk+9+7OR2q3Tf43wXd5gJ8w6EoZMNaZ9nCMv/XL2lysvRRNWAqRvIPaJ1ISYzn0AbW1Q/4cjkyAg0i4Eir9TOxGYxH7DLuiZMpq5sgNAzdBdxIYnHHBYmyEnBDuE6IoiV54o08VcYW2vYaz+ivmWdPZs14O0IviSYYSacn4j0Da0IWlWibhjKy2LdbVj2VsFIxhyZ34QLUBI6o3nVyYlHcqqJogV5xsCpGd6c8q4Ms5c/YGglpHNrbSSX+ZfeyIIx+B2tWvKBHTlCQJ7Rt/Gzm1Kxgn1apeoTmbTQ5fPTP73T6goNymLBVl/q8zxSCZIH8biARq7UppchwqIFnkgwPaVfgy8EZIawBsPs/8iLnyNkjyVFKLSTjnCDuEhbH91kiBFOs/ebGPAwXXZoUc3MvIgWFJXFp11NPslas0FX1znDRj3bMk8/3M40uj48JUCDdDEywlNGkyOMNqiebDx1DQcY1S40MBKBziGVMT9wDB9PNBau4NzGBmrQWxTVICFA3cfQlDUUU0AmnMpFRqrwiE7/WqdXfKD4oBj7lrYIDu7pMUjTBV9c56yFSw4C2RhDLQ1alXU/yGAm2jYtIAqObyzTEsbo2Ve3LLh7zWcxQH07SB9NrWnrurbRB+jpJ5iQDgwFzasKzE0RxB+5XokuyUqfT6+JvsPlhLi87Tj2E5L/15NGbcABNe0hJyyAuAbfSiueWktSEgu1GOsdLU3cxY7SijWjlJqMe9KsMbDwxOrrJJ7yhNtvWiGyM2ljvsw8aLV
 v49jbX16
 gTQ6kaZhKKqCRMId+QhZvXMwA5CXxCAJ2s8Zg8XP7WlZ1C9vScet9Q6sVSEJiBM0J7G7MWe9c8Y5wk6pb+zrG1qQkn2SslTf+8Lbv4OZ24E/VCZK7QSkHB2+gAS2/yCsLUQyYKcaaFEq8iZ5jkqJ6tN33o4d7J4ZbE4Jy2vgxD+XQ8LJ/OFYL4X7fvpWwFAf30XlizUcJ35rsCT/cijbEeFkHaoUEtfMPwgA84Iq7jr//+Ob6BlPM+LOeQU2S/Wuyw/xfUQjmA7JD+gX0764kRteiD6wb8EHGHHIyuizlDR4ZCQxP6nj/Ea040FXBZlKhA3n5jsdhvuxT1GJgGeWU0upk7qa6BJCi+Z/x7MOC4CJlhqCwAFa65ntsqSlZg3kwxTx36/NwgN+UhyJ10WwUMMhn6XQdqOYCt/dmxJlmzs1kL2+SO9G4h4FZYvbh6tZvnQt8ZXP4LpmLiTUPiAXf7BZAICabMiInlfvVhSFuW6UAK80fTjAwiR/osbJfULGlvJEYb9wcrudu28CEeVItYmEqRcY21wmyndLqjBiABAusqhYh5JGNdwLTUuMXzrpkAo/dG6jKJQxnTWWWLpdTyMK4zsf59DPNvZhxcizL5jn/C/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 04:06:29PM +0000, Catalin Marinas wrote:
> On Tue, Nov 17, 2026 at 11:05:28PM +0000, Catalin Marinas wrote:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 45e077c7526c..13b8e57d6dae 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6278,6 +6278,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
> > 
> >  		local_unlock(&s->cpu_sheaves->lock);
> > 
> > +		/*
> > +		 * A sheaf allocated with kmalloc_nolock() is not tracked by
> > +		 * kmemleak, so neither its objects nor the rcu callback queued
> > +		 * after it would be scanned. Fall back to defer_kfree_rcu().
> > +		 */
> > +		if (IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) && !allow_spin)
> > +			goto fail;
> > +
> >  		/* Don't wake up kswapd, it will cause deadlock under pi_lock */
> >  		empty = alloc_empty_sheaf(s, __GFP_NOWARN, alloc_flags);
> >  
> 
> For the objects queued in a sheaf, rather than the !allow_spin fallback
> above, it's simpler to move the kmemleak_ignore() call in
> kvfree_call_rcu() before kfree_rcu_sheaf(), so they are treated the same
> as on the non-sheaf path.

No strong opinion on this but kmemleak_not_leak() would let kmemleak
track objects queued in a sheaf?

Wondering it'd make sense to mark bnodes with kmemleak_not_leak() as
well instead of calling kmemleak_ignore() on all objects.

> To Vlastimil's earlier point, kmemleak could follow these rcu chains
> instead of relying on kmemleak_not_leak(). However, with chain breaks at
> any _nolock or SLAB_NOLEAKTRACE object (including kmemleak's own
> metadata) and walking the rcu callback lists directly means digging
> into rcu internals. The annotation is easier to maintain.

Fair enough.

> (got lost in all the slub code, it was much simpler 17 years ago when we
> merged kmemleak ;))

Good old days :')

-- 
Cheers,
Harry / Hyeonggon

