Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96A0D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 15:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531806B0022; Fri, 28 Nov 2025 10:52:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509896B0023; Fri, 28 Nov 2025 10:52:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4208C6B0027; Fri, 28 Nov 2025 10:52:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 315C36B0022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:52:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD0DA1A0642
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:52:21 +0000 (UTC)
X-FDA: 84160457682.05.3DA8D9C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1E19A0003
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:52:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ZeMJqQZ/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764345140; a=rsa-sha256;
	cv=none;
	b=wqYC5puoZUKMW03EhScmNbz+cW1XFBxM/9anVWpZ9cKJ5cEwOq9gJdTt8wXoh7LEObGT+U
	Aabqg+GFwFQ5IDiO+hHn5n6E1urGmuNSknY/Xrw8z5vHui+B2McAJkgUIA0fixMv6Kws4v
	N2IKI0zzV9qrBH5atRpSMukRxjbgFmk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ZeMJqQZ/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764345140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwIfzuOMPHq6x0Po0VRTjIWxG7bx5EXE+Jc0r5XKfzo=;
	b=3JwuJhwiDt268pDa7ZN6yvEMjDcSKsFljd0QwF2ymzqVo4sHbGoJGvgNbEbjuzZ12HX6E/
	A74QwJ+Uawwkurn2ieaE76Zi5iwKoWa+uZfT+Y+1BXEWQPHCvqY9oC/tLvafpKwHZGsiko
	HKexuIyv9MkMu8aKjcTWoo4S3aLjk4o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AwIfzuOMPHq6x0Po0VRTjIWxG7bx5EXE+Jc0r5XKfzo=; b=ZeMJqQZ/VV1LbFDf2VICimbXD9
	ifBgs4nlsqh+ACjxEzEBFxWHJhgPC7NwOj5+eivXO1rdA6tTyUhVIM/Fah9CWG7v52OGmfbfH3J6x
	FfX1x4eOWLYsN+skpfPqYdBonvAcmn1bSVtT7bhFMANfB+FPvEojTM3yKC6n4dKY1z3xHsVHzRbDR
	zimoxfjQXang4gXfzzTA2YvryoMgrH7KXWTe7kTgVlgWxM2OMDUuZGH2HOAOB3zQJ1xjuyR+pS5pi
	XjEzlGdO0wIzpUtltaa2nvmeKhwncRvk451mTJaMB7OlDMD/tP9k/DiSQihAZDSyDxkKX0HO3PVJ6
	cxhMe7hg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vP0ld-0000000DObj-0oco;
	Fri, 28 Nov 2025 15:52:17 +0000
Date: Fri, 28 Nov 2025 15:52:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Sokolowski, Jan" <jan.sokolowski@intel.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Message-ID: <aSnFME6-LqQXKazB@casper.infradead.org>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
 <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
 <aShb9lLyR537WDNq@casper.infradead.org>
 <aShmW2gMTyRwyC6m@casper.infradead.org>
 <IA4PR11MB9251BBCF39B18A557BF08C0799DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <IA4PR11MB9251BBCF39B18A557BF08C0799DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1E19A0003
X-Stat-Signature: y9fqi3z51ts33emtra51gecgxkqx5bet
X-Rspam-User: 
X-HE-Tag: 1764345139-929007
X-HE-Meta: U2FsdGVkX1/Ppf8/8VdSrcYdXOCTtUNQHBNqlDOhjbQmq4xRjMFMyX211CzdKwqAEnRCnsDxbtBJAegcdMEZ83Seer4xmoFHkfd09uYf24RutF/SmB5SrOjUq97nRhzkJaPkdkMG39XaDjuRAEKiJ/XBqyScoRT73/di9HLjvQNMThoYtJNJMjFPjotZpuT9WaGVIPapAu8KV485K3lTQf5k9VJQMqiSKEYlETnT2WPKZ/OPSSTWA0SL7+EgG7XtiLqszazZfnGM4fi0x+7/ynwYeQj4VM50g59Qk/2sJdRzryjvbyUSlXAGxmc+FXUYfpnXA1Z0xy+kRwY8FIAE9PSb6JKTT3AUWe8OYXwPgWu0Ylj8nnf9d3eJL/3FEagDi5S7eLP8IUpfyb8lxW2KKi4zng4P8InOtPh7iF0pEswBrWg3c9ucQ4Pj/oYs5l1eQKbdYEeCp3NcbWENmQ7PTrUl26cRb+qkzBBtHeqoOX9uVD8DY2eREBEhT6g3Nyj3wtzZFoPFA3I4fuIXgmS5IgnH+Y/dwIPpdt/uctYOOld0JkSWKSDDwCwRsfhtEDHGwOPh4R/q8+IyCtrpOEGdtKf1ypbIwpZpevcAw0fdIMPHfmAULG95PD04dIcsOb8b1XM6/4Ajy1KL1GnwhmZPuaDrF3RMp+BoSev54XIC2yWGVlqmLJipYOESnA+TyAsANEjiQ6BmrfgwT8yQJRxxXyBdk2daKDWBemAcG0PCEhpudlpjCdoOVgGcv8yl2+Uk9hRHsT07i2yujbvTWPbUB5Kk7I13GpdqOyzXsL0e4UeChu39zhBkZC+tATrg2yRcZDJFJEJSbP/N/dt4sjiTNhsd/riMBamu9qTw32Nv0qbvoaROcBmCiWj0ySdQLD4OMCc3GOKjqg7uiLYofFDzGVuFWxZ3wmETLFCcwRIX1pauTgPdazxtHy//apJReWrV1GsIkbZcprj/EwOxv8e
 FTpE3dxr
 D61zB6tbwS1B5WR25+oehfQBt8DvlYhfEDBrTy2AZeDndK4U4jUuRH5kHwzsJq/1TDHvuOxDAKd7ctm3pPqDfA/QtuNXISHF4BpTAubmVWWWz3+4S6tuj7EvHsr6I0JXC60ObfqoPuoPTToEQs6XRBNCmFtIjL6uFKfDO2wOnbvp9J+zndrC1epsBvRvQ1fNAV4oKRCtLOCScg5Kejsv/m1TDmVRE+5ELSAagvQV1qc75agzScYdIjcpq629CKfEif/eClNRtAA27vbzUaYnFG6/hoxpKT2GUY3lkn+BBCzVcbhy9eSAHeOy1OSNtcuN4/3/dkA/78J/YfW+tRoOQ4lHYlDj1NoQkE3C9phf1znbAs89qXSjWoRwGKn7mExhFpgq0X1S2ksDTmzIMY3bekViHDegDkP4Whl8CWIItXR9EaRv2bxNXmVLFfgGnSE/7mQ/peOX1fBqAvQUdf6a9gqhDHFDEB3FiR9oon7GQFTnTScrXF0SoKIVQIK+7IIvpdd7d+2ZlWDmc+M3inkbtG28S8/ae3HaOJnIGMzpnD+nXx9VriIsYh4VUD/JbaLR3EOEcmkpGNMgzrN49vze9unb9pgsEve4f5JV0eFF9MnBr4C7YWNDugCtxjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 09:03:08AM +0000, Sokolowski, Jan wrote:
> So, shall I send a V2 of that patch and add you as co-developer there?

No.  You didn't co-develop anything.  You reported the bug, badly.

What I'm trying to do right now is figure out what the syzbot report
actually was.  In all the DRM specialness, you've lost the original
information, so I can't add the original syzbot links.  All I can find
is https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6449
which doesn't link to a syzbot report, so that's a dead end.

> Regards
> Jan
> 
> > -----Original Message-----
> > From: Matthew Wilcox <willy@infradead.org>
> > Sent: Thursday, November 27, 2025 3:55 PM
> > To: Christian König <christian.koenig@amd.com>
> > Cc: Sokolowski, Jan <jan.sokolowski@intel.com>; linux-
> > kernel@vger.kernel.org; Andrew Morton <akpm@linux-foundation.org>;
> > linux-fsdevel@vger.kernel.org; linux-mm@kvack.org
> > Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be outside
> > given range
> > 
> > On Thu, Nov 27, 2025 at 02:11:02PM +0000, Matthew Wilcox wrote:
> > > Hm.  That's not what it does for me.  It gives me id == 1, which isn't
> > > correct!  I'll look into that, but it'd be helpful to know what
> > > combination of inputs gives us 2.
> > 
> > Oh, never mind, I see what's happening.
> > 
> > int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
> > 
> >         ret = idr_alloc_u32(idr, ptr, &id, end > 0 ? end - 1 : INT_MAX, gfp);
> > so it's passing 0 as 'max' to idr_alloc_u32() which does:
> > 
> >         slot = idr_get_free(&idr->idr_rt, &iter, gfp, max - base);
> > 
> > and max - base becomes -1 or rather ULONG_MAX, and so we'll literally
> > allocate any number.  If the first slot is full, we'll get back 1
> > and then add 'base' to it, giving 2.
> > 
> > Here's the new test-case:
> > 
> > +void idr_alloc2_test(void)
> > +{
> > +       int id;
> > +       struct idr idr = IDR_INIT_BASE(idr, 1);
> > +
> > +       id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> > +       assert(id == -ENOSPC);
> > +
> > +       id = idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
> > +       assert(id == 1);
> > +
> > +       id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> > +       assert(id == -ENOSPC);
> > +
> > +       id = idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
> > +       assert(id == -ENOSPC);
> > +
> > +       idr_destroy(&idr);
> > +}
> > 
> > and with this patch, it passes:
> > 
> > +++ b/lib/idr.c
> > @@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void *ptr, u32 *nextid,
> > 
> >         if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
> >                 idr->idr_rt.xa_flags |= IDR_RT_MARKER;
> > +       if (max < base)
> > +               return -ENOSPC;
> > 
> >         id = (id < base) ? 0 : id - base;
> >         radix_tree_iter_init(&iter, id);
> 

