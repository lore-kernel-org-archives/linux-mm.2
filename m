Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC85CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601256B0092; Fri, 15 May 2026 12:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1FF6B0093; Fri, 15 May 2026 12:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1A86B0095; Fri, 15 May 2026 12:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3ACD96B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:04:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30F21C0300
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:04:11 +0000 (UTC)
X-FDA: 84770125902.05.5AC4416
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC56620016
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:04:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gcO1/Vok";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778861049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IR0rNGcBnxTQKxjl29BD/qgYqn9i6pUVwOw+iwSnTf0=;
	b=kKbFNk99mn5L2F5BkeMPZzMZbi9KTuXS3KDVaIKW/EkUGhdsK1GcNgvRLVMcKkUGAOBF3Q
	sBZrCm22/YFCJ+o+IHBVNiAxVVkDuOcZpL0saW9TmNaLbkCS4AQSMq1wFeoY830MASpGld
	EFMpj0ENxjKw1STOgvIXz8lfzZdPTv4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gcO1/Vok";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778861049; a=rsa-sha256;
	cv=none;
	b=Uk03XIQqW5JDZpEaR/AmoJOettpgbj9P9/PpVQGN0Y2BwP0YhgytE5HfrfbthqZ68YnPkv
	h3tTcRvDCaswV8fmVihqrEjE+k+PQNaLEZFrMPP/vYd9P/9YQkmhyYtrDYuGOLMP3rZ6YO
	AZQ1zn7BcgZGEZjIRrduIOmWaRi+/ec=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1329fc4bf77so1913212c88.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778861048; x=1779465848; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IR0rNGcBnxTQKxjl29BD/qgYqn9i6pUVwOw+iwSnTf0=;
        b=gcO1/Vok0miY9Oj6lvHt+WfmM2NWHenGUztNXil3OqwTNcVLNQMxg6/jBydmSgb9GU
         /yMaK/hfNH++WgdHlcdd0hsCFu32B6SRbE1kQy2w7df3oBmhhwIM7MiTtjuNZ1t7Ahql
         OK8vgx2Gk/HTaRdrrk83DBcHwWwuctFnms+E+zC2rl92sNo+Uphamv/3oGCKZgKNlCLo
         JqxW+gReyrToSgGNJJCQ+npXAT2wWxknH/kHg2Y4W+QpywgusFa964F9ML081MRGhjJM
         KMk70fbZsRKIZl/Yymsokria+R4jbnw34rKHKRhumY+Er7zhc8nihJPiIKXAhZPUDzaR
         IwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778861048; x=1779465848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IR0rNGcBnxTQKxjl29BD/qgYqn9i6pUVwOw+iwSnTf0=;
        b=ZLckP1IQRln9oco1wXcAmX1o2/vk1chiNv26Jox/aBeMLxS0unFq0K/7pby6mixgjT
         e1tkqHME4nUlPbsGtINYfw68Cg8Bayi2KTq1T7DvY/Vqmf0cGgjfXsUnBFOBY8PoLgwc
         bLmIG4QvTOyl0xHDPCJMAtzW/Q3xTwxT4zuD2Lgqm73DCqcKcavemw15FltFQKcm+BqZ
         qGOiIuJoFdlJrW1oAL9KCCMAWO5q4S9Vrq42XzXM2CdbovzQaIuRVNGTy75ZF2aGtkCz
         MkGKlsZk/Exk5KnGO93V6FNYZ4IQHjEBy4B3VjUIYMxS7ZYnOAVA8Lm4CDzTJ2Sl3hYh
         RdgA==
X-Forwarded-Encrypted: i=1; AFNElJ8DnVDMyTLP+zcY9ht/JXlrDtU5nTG71jjit2CKgtEyP6dFt2lwGN84cIavF70Aef0rQiTFwHkxiw==@kvack.org
X-Gm-Message-State: AOJu0YyqaQ1gYA86mjIdsK2QRBEEP+MIQ+9evYxdF1y9S7iwsoGrPRj9
	jHrzSh9hIr/+aOikXdw+0ja1FYCNAlNNZkqUeEVa2Tqz+2Kf45Ik/ZUHbGTA2MxWvP4=
X-Gm-Gg: Acq92OFj99uylVzKOU/Apky/wWP/fVMuU90vG9Nqo42CmeyWLMM0LSJa8pgaBuR1xxp
	93sEWmvHKE4YZGw1NsNacn0dnr1STCeC4KDf6t+XmxIxVFHfZQH6xOtozDKnxiMtrb5EX9xk1Es
	xOkWKV4uFLMwz+KqAZGm8DM5yJPYnIDkYDl3v4Ar93chOmLOKFLHSthnTw3A4iNQ3g1DKmnB9uy
	KxBe12KeeRGRPx+DyeGy8UUz6I5O8GOZVe0NP/1GmMxcXgBd4ar/kmXCJPuQt/c8sBvCe5SAbz8
	STf1t9s0DAJGRov6vIfd/BMv5NKqpyarRQik4YJmXLYXp0dEPQQZK+rueqbXx3OPeeMPAUYbGeO
	U/VA308R8SLwhKhOs3522LJyxaHXbbPW7Lz0P3fxAjC3svmLcNNfPA9b98b9fmRQ/6db4EulR4i
	VRHkg/0CNTvzqP+b4WySNld+CKVpJkwhCbE2Qzk92UJ2s8E7j4nlkW/+m4TQCWmas6OXQm9rE0f
	OzlGElpt4U8
X-Received: by 2002:a05:7022:41a7:b0:134:def6:e70b with SMTP id a92af1059eb24-1350451e322mr2242686c88.6.1778861047934;
        Fri, 15 May 2026 09:04:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba36e638sm580427285a.9.2026.05.15.09.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 09:04:07 -0700 (PDT)
Date: Fri, 15 May 2026 12:04:05 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
Message-ID: <agdD9SrJem9-oETy@gourry-fedora-PF4VCD3F>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
 <DIHPURUMTESI.1LP37OYJN1N31@google.com>
 <agS0tVCwESC0rC9E@gourry-fedora-PF4VCD3F>
 <dbbee174-aeaf-40e9-8942-425580a8ef3b@kernel.org>
 <agS76pNPlPVLgpFA@gourry-fedora-PF4VCD3F>
 <DIJ59AT4F3Q9.1JN2FOZZ47H4Q@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DIJ59AT4F3Q9.1JN2FOZZ47H4Q@google.com>
X-Stat-Signature: rugrkdyzpcgd4op5k7jn11gwr1d34rhn
X-Rspamd-Queue-Id: BC56620016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778861049-717959
X-HE-Meta: U2FsdGVkX1+8BcT8itdi34CUJQloqIKS6s0mFbH+ibG8YzP6mNhtfCbO9JXHgVCTVAMAJh2Bwa2umUD/mRmrF+dYlvyd2qCnBre/0EsXWYGUQdvW/hk1bTJXnIQS+PNhQzJfGzr2LtS4rMQR3sVFc/cQd1cvTNN5xlTXWw0ZDs3Ryb2gLU03Rey6XIotFiaLqkDj9lLB9uRWmQ/CaccuIGe+ZCt3sIurIq85TXzmt+3VJTZupmUPegRFIKmsw9f8x40LfjuFPOGWL//uZbgiLTel6odB+NhreOzU8fz4l0FJZY9LrQEgdZteuS5/A294pr4zojHX6rWmmnaKa1GB6e0/V76KlAjQ2Mzior5eqBV3L6peJwWWiEBISb+hIAZHOWqaCKR2NkJio6YCxda7KfuGG+jv7ctuLcVpmujMaAinwBYq3R0D5M2OHddktAu3kf0uKGrVAsgz7YPDByrMyMlJbhbUDmfUzJYI8ZsMbOX8YGqaYRqBJJZ3TO8lic4BjhNJsqlG+KAJ9ZlQNelF6+YiDjlrCppw582hoxgFYL04mhdV7/oajjuSmdagCa1RvfYPwtEaPzGhtWK+oNvaBj14isQu3Os0dCzEJfVYZeRvayRZn6lemk7sIixCZINdWWXfgMhzZNfGWxCW1KIReki+ws5WBaPSSf9Ld1eanAIzdTJ3v++dK8VFiALnFSuNkdjpbYV5kMgR5FRgiLGi9PmbYDRSN8XtWS5UydmO1+aqvFb5Epv74TWS/S7EGb7aj4OuQRN0PWMkgAfoJDkXOcXBrP5DRNRSih7Xg12J80K/BWScKUC1eh8pKW7XlTrRrlgDHec+gIxy9ENdwCf9LOYij45oyD3oQDTg9sVnC+3R0cLZ7RcgV6OhUKtlARDUzVkwZPCDTO9f8pP/BKcg4MhPzEnX60bNuz2MIlzzTKewJ0yGv+WSrkneJh4lvE5OaoyjC60j1mshpVe6dXc
 ADhMjRHU
 0QkgmOSWUyb0aXdnn/CDLvCK+38e7MVOMUDV4XLL2krXCnfS1VchdhN+McQr9CyxyLZjyociue5YuYaUbRvbwg/hUmnwXrzNoiSSkC+2kHgbJtfsVPEjdZleDtGUNgz7/blvdOgWRgDqSIUaekIhwtA6WOzMBWzC+BWmAeC3RK87D9dN0zL5hp2/z406zg28TNYBYg2O4AyDDhFOG9G+PXOtwif7SejLnun/2CqVsA6IfcbkzDF4ezybvdk3uW9tcmSrgr3/PXVGcEEKa2xvDdrl1vL8FO+8vpUqimvYrJuKxAcx+aeBmXXO1W2D6l1HJUEmgWU0rB9RB0VwYVT7YW1ZXZOpyDYg7v42FbT3VBM1l/XqJyUTzt9LB0MsuRHptSrHtrXh5vHiWzDvnmTeUTmfXt0tS3IxVqxwo+lOF1OXZlsA7y+5gPmR2UrN70QP934/9p/AGTvD5JR+lLOXGDmW8+zyVU6GCRHNWQPhldefCt84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 09:31:15AM +0000, Brendan Jackman wrote:
> On Wed May 13, 2026 at 5:59 PM UTC, Gregory Price wrote:
> >
> > struct page *
> > alloc_pages_special(enum buddy_context ctxt, gfp_t gfp_mask, ...)
> > {
> >     switch (ctxt) {
> >        ... internal-only details about how that case is handled ...
> >     }
> > }
> >
> > and just go ahead and allow the buddy to grow internally without adding
> > new gfp flags or an infinite number of interfaces.
> 
> Yeah, this is what I'm thinking too. I don't think growing the interface
> is such a big deal if we can put it in mm/internal.h. For __GFP_UNMAPPED
> and ASI's equivalent, we would eventually want to expose the functionality
> outside of mm/, but that doesn't mean we have to directly expose the
> page allocator interface itself. Do you think it's a similar story for
> __GFP_PRIVATE?
> 

The important thing is that the API growth, if there is one, needs to be
extensible and not specific to a particular user case.

alloc_pages_unmapped() is just replacing a GFP flag with a function
call.  Now we've encourage alloc_pages_foobarbazbazinga() to be
implemented.

So we should give some careful thought to whether growing the allocator
interface is a good idea at all - and if so very intentionally.

I made a similar comment on MST's virtio series [0] about trying not to
increase the buddy surface - because it makes it harder to test and
easier for people to do the wrong thing.

So if we are going to increase the surface, maybe the intent should be
to have an eventual migration, rather than a permanent surface increase.

[0] https://lore.kernel.org/linux-mm/aeozRZ9AvW2jTQkX@gourry-fedora-PF4VCD3F/

> Anyway my initial thought was a variant of alloc_pages that lets you
> directly specify alloc flags alongside/instead of GFP flags. This is
> actually a bit fiddly though since the GFP flags -> alloc flags thing
> isn't a clean division. Maybe it should be?
> 

This is actually what i meant about some GFP flags may more accurately
be described as alloc flags.  They say something about where to allocate
from rather than something about the page itself (ZONE_DMA vs ZONE_CMA
vs ZONE_MOVABLE, etc).

> > Of course that means users have to know the context in which they're
> > being allocated.  Right now you can kind of "transiently cheat" by
> > passing a GFP flag through a bunch of interfaces and that makes certain
> > allocations reachable - but maybe we should not be encouraging that kind
> > of design for these kinds of allocator extensions?
> 
> Hm, for __GFP_UNMAPPED (and __GFP_SENSITIVE in the future), it is
> nothing to do with the allocation context. It's really expressing
> something about the page, i.e:
> 
> - __GFP_SENSITIVE means "We might put user data in this page"
> 

That sounds more like an allocation context which implies a set of GFP
flags, rather a specific directive to give the allocator.

> - __GFP_UNMAPPED means "We might put user data in this page, and I know
>   the kernel doesn't need to access it in the direct map" 
> 

I don't think this necessarily implies user data, it just implies
wanting an unmapped page.  The caller's intent isn't necessarily encoded
by this flag (although we can derive it from existing use cases, who
knows what crazy stuff people will come up with).

> So, for those cases, I think a GFP flag is actually conceptually
> correct, the only reason I can see to avoid it is because of bitmap
> space.
> 

I don't know that we can call any particular idea "conceptionally
correct" when GFP flags themselves are a mishmash of ideas already :]
which is actually the core of the issue isn't it? n_n;;;


~Gregory

