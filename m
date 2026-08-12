Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA160C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896D76B0131; Wed, 12 Aug 2026 08:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E426B01FE; Wed, 12 Aug 2026 08:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C096B01FF; Wed, 12 Aug 2026 08:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB1C6B0131
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:33:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2470880348
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:33:30 +0000 (UTC)
X-FDA: 85092558180.19.D3FA1CA
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B65C40005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:33:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BXsszRBI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786538008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8keOZILRO+hA/w6RNVNhXJ75VzJNzahD3Vhsnf0uDM=;
	b=Y6At0xTBlmCA9J+r6eR+5Fk6QMbFI6wP4gwJMGjOg+48PCmWwomzvC+sRf9H6XNuy8pS85
	NABP5MprIGrYsPe7V7bMe3BC9aiFkSELfjTz5ohrkwMhtLQqcHa0nRIv79AhFOBOdnSsIK
	7BUZYYpM+wLWI2rDDN6NO2rG06fYCCg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BXsszRBI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786538008;
	b=zNYsqrWVQwv8RBmhc6ZU+VSlF0L5WmDGxyRGkktN8W80oASUArrpb+XajfmdoxggaWRkgL
	meNHFWAsIWAQGJPttg0stRes8iCc8/rYdvU4csAMhglA7s5AmQV7Y4pWeuW0X0sWce1+aS
	FWylJ1Zwn+3sUcWC4auqe+/fFyLjx14=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cab97c86bdso92355ad.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786538007; x=1787142807; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S8keOZILRO+hA/w6RNVNhXJ75VzJNzahD3Vhsnf0uDM=;
        b=BXsszRBIRS1c2PXdCGksvOaXPi1W0UNO20wkdTyBisOCytEI70mUD+XiSxV95L7aNF
         41bybWvTW+APG9deRdxM8AsoGdI4rhvNb8oyI4uWqNPf++ouEF5aHHeWTbAxgPMd11mR
         nt9uXuRdmHoxszOSmy3FsDjtcPbKp1lZn6lEvwSlYu4guzI1QlFpgJvHnIB8x4U4iImD
         ULzf8ErlUHIyw3RPiDUixbvCNsZx5SF8EBLeOB0VVSD25kpYpJBVuUDgqLvLj48t6yKf
         2S/WZ5V753GEa0aOpk7gP10YD/rYYqc8oGgpvQhBZJnGLSRdI9p+kQUsEGEIzTpuJRU0
         U8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538007; x=1787142807;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S8keOZILRO+hA/w6RNVNhXJ75VzJNzahD3Vhsnf0uDM=;
        b=niMDOfo1/xDwvr2BDqDLXR49sv5xldaVU7UIdOPumQQjOpD3mVdDqnD88offbEZWcv
         ojSl6kBhdpBaBLg5wzCMgVIVGoNo+8gyLFrHF8Tf/di0qEDkhtssvUMSzvX0pNzDhJ+9
         HQ99ZoiE/1dkPSS+ac1HtWc/6x1KJoOJzuKngYHDPj+JTRMxo2RkMqhlaT5jbd4d4kn3
         WFrinFKTJecqBAZWnzZy2wv7OJ5ElABUbnDBjW3QIHNFOwR6BPi18GVe94vA2gBCQT/L
         PyxZruyKDv0Dz6DVIlrzQ+xlQFiQWDFccwltmal2ZOu13X1B85E6tsCyQ1wo2o9tNqP7
         mVTA==
X-Forwarded-Encrypted: i=1; AHgh+RoLBa+esatV3sYX6w+cPuLP/6D02s+klJEUEoIeT4HzS/R9B/ZDJX2g7hhBNqC+e5BrCu54CKT2fg==@kvack.org
X-Gm-Message-State: AOJu0Yz7MFxOUdqZ/uSQgT1AEOs4+Mu1Goq6SZK8p41/V5kdDyiJxzJ3
	TlnZRn71bY2dQpeuD5vyM2C8Jv9/4QNTIxs8J2OXPAA6irTEBIfk9cSPysBctGuULw==
X-Gm-Gg: AR+sD13OoNl7QhY4krdbdin/z1Fhv3Fvd5ppYhabYW5eACjqjcrveE7TWeR7wCNFvH9
	Vp1Fuky418eyaLwbLe/oPvr7Hg6IEzYN1L40HiTya+l1lQUuBw+TvCvYrNAyLf6Zu+sYacpJ5VR
	8ZW949uglaC2iypnVY2MUgyRSj97skqQm7MUlvPNLr6y4NG6pvkQB+m4rYU4msZxIJfDwUdRAxa
	NnW4T25vxo5TPbBOYBNq7YgV1he1BWSKnuAcr33BO3lpCOBYOmO2ZtL04dbfnkNxKOCqsUjlGU+
	xJ7vIWFzY6hGaDnyCz5poQZaWywXrhUhaCVuQEHkXf7WnkijOR6Rf13Hiin0IrMXmt898mrGFLi
	RIQ6rB/dvi0UQRPZfdz+Yxbs6Bql3fiUdHAj1/k3HROuvECDWjm9rxAQ7Jaicpj3DLanSa4ayOB
	G5nwOqhiTYVBY9ffwfq5JvJVPrND2aMVoDwk4L5PqQ0MJ96sDR2LaPMGGVhyLJ43XIij1hom8MN
	p+pBm+u9Se3oX2sg4vOxwI=
X-Received: by 2002:a17:903:2acc:b0:2ce:b436:272a with SMTP id d9443c01a7336-2d34aa4449dmr5490875ad.3.1786538006669;
        Wed, 12 Aug 2026 05:33:26 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d352218b5bsm5554125ad.70.2026.08.12.05.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:33:25 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:33:19 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] kho: Introduce a helper to init high order pages
Message-ID: <anxoD5OGtBkiDLMo@google.com>
References: <20260803113944.3694290-1-praan@google.com>
 <20260803113944.3694290-2-praan@google.com>
 <2vxzqzk338y2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzqzk338y2.fsf@kernel.org>
X-Stat-Signature: zfmcabspnsexjhi7efzeso9cppho3kqs
X-Rspamd-Queue-Id: 5B65C40005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786538008-501843
X-HE-Meta: U2FsdGVkX1+R+Ahi1EQ/rAWyqKQZcndvD88BA+uWJNd8wTAnsjpKuhwHyBWG1Qz3/AYNpQ6OL4Y+PtmzLHq0Jn0PSZeqVXc23Wf7O/xs2rn6xKRUJ7CeCJVS/ldnbcdd22lHqE6Eya4pDQZRXIth8sQiOq+8nR7S0VWF3so4kiSiFjKle6OC3iJ2zb/ULDWbnAtc9EyQa2accS25kzVyWCrEC3ls87VJ4uWGpCPgSJLykcTgCZrJEkYPU8KMEMj78vgHPS7KvJ15ArTRrmwV7Ht7PomQ1DdKo+dWho/YusXfokGW9atLD/PHVUFA06htuXcFN1ebvwvSWKCZmVL8T7nufXdDtd7+pmW49ZdvdkYMIQFUR065LjOWfv/x5zpsoipON5u7DRAlBgZVs9S3lfaehAUThOT//agE2+3jh7xsdCQUlnWOwq5bw0KTjmDMsHkeN494uof/YGQJ96U7Uhp1FpRp6Xk6iw0alj69i5Ar2Zjrsoqv6ASTi08dEIqQUzTekNFeoCMYSDNpvHIvOd0kA/2IBjNYyrNDUWCI8JwvzmIjXKvfw26FXLf+007d4GpJQqqsWMc2oIn7p7nCv9pH1dcYpkrgMhaq8JrJBruJiIk8fl6QlZOKVJl1/z59wHvF0fBsrBgm2Pfdzee7KoUJDUVwM77xM/kFfj29ieh3Z9KdeDB+4W0cqDXs7iq9NU/B7my9puPbn0uL5t5WmUMsK4GLnKDqakh3WW6d5pnf/1LgdslVRqv4LGQsnIlRztYy4VwUiayNFiP96DBZ+RV0gNZJeD/HfPpxSKRzJbXoXk5E/pTYL9h4DOLfPtWiBYlArluluMKm5F471+cJNYXS6D6DJwwqveflAqHlclGLLK8WfwEY7tKrobZcW7noImtP6RqxF1spMzcJxyuELRvXzUkqXHB1JrX3HWM4tNIkyqvTWeg2/X07Iu6351bdaYyJuC300sedBqJt0d9
 sPzXc9d6
 6e/JpEyJJHOV+2bad3ZqxI1ORrSs1mP7axhiHYWFPswveBrusXbxaiK9Guu3cXLs80vgeOKb2ZkyhduJxnzaP3C86s+lWcXu13riwTC/1dAD+DyUIV5vP1kER3TngKaCyre/0pyR/+c6WT0k2xKIXL808IA8aV9togmlXDkm1AX4vhoQ/iz3WdTvGMrJq0mLxXVZuj9kOI6S1/F0D3lDDHk7fFPBBe8w/ld1P37tEObmQQROWkvJ5pA29W2mM2cLt7yLWR8dm5YREf7nzoHi6/7mbdhg9eaAsDTUWjyCRuB/3CO5F7+jMsKUb0d2E5gOW6EJR1+rjiAksqMzkWPFLmcQE+qjtQ1fewR3NKBREohD1L6ZuG4LNEksB4ljoAk3Aio4WOgZY/EHH7T6xw4k30mb9GRSIhMfsoFr0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:54:45PM +0200, Pratyush Yadav wrote:
> On Mon, Aug 03 2026, Pranjal Shrivastava wrote:
> 
> > The current KHO restoration logic assumes all multi-page blocks are
> > split into independent 4KB pages. Break out a helper to prepare for
> > supporting high-order non-compound pages.
> >
> > Extract kho_init_high_order_page() to handle the refcount pattern
> > where only the head page is refcounted. Use the helper for folio
> > restoration that requires a similar refcount logic.
> >
> > Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
> >  1 file changed, 19 insertions(+), 10 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 4834a809985a..e836efd98795 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
> >  }
> >  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
> >  
> > +/* For physically contiguous pages. */
> > +static void kho_init_high_order_page(struct page *page, unsigned int order)
> > +{
> > +	unsigned long nr_pages = (1UL << order);
> > +
> > +	/* Head page gets refcount of 1. */
> > +	set_page_count(page, 1);
> > +	/* Clear head page's codetag to avoid accounting mismatch. */
> > +	clear_page_tag_ref(page);
> > +
> > +	/* For high-order blocks, tail pages get a page count of zero. */
> > +	for (unsigned long i = 1; i < nr_pages; i++) {
> > +		set_page_count(page + i, 0);
> > +		/* Clear each page's codetag to avoid accounting mismatch. */
> > +		clear_page_tag_ref(page + i);
> > +	}
> 
> That's sneaky...
> 
> The patch _almost_ looks like pure code movement, but then adds this
> little change. I'm not saying this is intentionally sneaky or anything
> of the sort, but these kind of things are easy to miss during code
> movement and should get a patch of their own or at least be called out
> in the commit message.
> 
> I don't know how page tags work, but IIRC when the change was originally
> added by Ran, he said that we don't need to clear the tag for tail
> pages. That held true for folios, does it not hold true for non-compound
> high-order pages?
> 

Hmm.. I added it here because I saw pgalloc_tag_add(..., 1 << order, ..);
being called in the post_alloc_hook [1] but digging deeper I see it
doesn't set a tag_ref on the tail pages for non-compound high-order
pages (i.e. it doesn't loop over 1 << order pages) [2]

We seem to clear tag refs which shouldn't be set in the first place,
I'll remove the clear_page_tag_ref(page + i); in the tail loop.

Thanks,
Praan 

[1] https://elixir.bootlin.com/linux/v7.2-rc3/source/mm/page_alloc.c#L1861
[2] https://elixir.bootlin.com/linux/v7.2-rc3/source/mm/page_alloc.c#L1255

