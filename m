Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42C2CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372BC6B0005; Fri, 29 May 2026 14:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323B76B00C8; Fri, 29 May 2026 14:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239A56B00CF; Fri, 29 May 2026 14:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 137E96B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:41:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A074DC1457
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:41:06 +0000 (UTC)
X-FDA: 84821324532.14.B79AE58
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB9C510000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:41:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="IyW+gY/y";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780080064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG2Yp6iNC/83YtFKga+pv9BmUEKJyvbZYWLhtH4z0Rg=;
	b=AvS7oH/xDsbAgRIfGQx//gbh4kJGQDHhlPLqfnPQGcnWk/LARe8WwP5vKIOOo3PaWPORQZ
	aKlceO+iY+nagPwxyqGm2mBAPcMfZdVT3YES0/flaxDWBTpiUbxXrh3W0FAZSjKU94gH+e
	VQp2Eb09ebDez4hCCnEhBsxbNusCHNQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="IyW+gY/y";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780080064; a=rsa-sha256;
	cv=none;
	b=1ciBXSu/toVrML7X/PErXthi49UL3eiSxehBfmQHmTNC1r9pjz88zmtIvQhGgdx+kVHXMB
	labIWnTsp3+3bNmDIujNFfZmiLN5MrPaCry1gfpCOeFro9yn9iv8U/RlA+Swv+ejlFFQoY
	1CCEYCXkgct5e2L2C1stvZp+iag661M=
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-694891f8f62so7530690eaf.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780080064; x=1780684864; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VG2Yp6iNC/83YtFKga+pv9BmUEKJyvbZYWLhtH4z0Rg=;
        b=IyW+gY/y6GgVGDz3S2MWuUtnzPjcDaLX48A76DF0yojN2wde5No4o2dYJyov5pXDJ4
         Mw+JnuiYT6qCOmbyld3S3ukXzHiaxFxP0zVo0F8QOamrzwU8tLS46AWmI4aiWeJCnee4
         etpMqXVNEP+ALtEjMt45hAdFThTskKDkAgvSTW8h12DF+smxf319Ga8RtM5yr/AqbXtO
         pw3O1+8aIPySEH4MO4/wGIy78HscBdXMy7S+hciuYe4yb+LmxxzCwLmr0fFKz/apxuAr
         K6Nkg2PmZMRftaana7rAPbraL3+5GnQhXRg+MHUgfi5s/5UnmeZHGEQ+kIQ2LmMdUx7Q
         jh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780080064; x=1780684864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VG2Yp6iNC/83YtFKga+pv9BmUEKJyvbZYWLhtH4z0Rg=;
        b=d1C6HYeiBQJLwFuG8OQ7bmZzDvMcefegDiAvX9ll7UtUsTVfQUTNkjXyafTZb99G6r
         Dt7qqj09NfB9axXQuMSWvIA4mmMU/HTxhPb6+Z7y8f5h4bRgRNP+EeULJQbPGYOTjQZb
         qyZwktwDA8FYaSSVqDdBLr7NipjgrbtoI70JFNZt2XDZBe1z4G/CLKcP7V+OoqE5Ax5y
         hG3YvQhPVVvoccBle1wb110uznCbv951HGWSBmMIjrtjLHUAJV+MMzxMYPbRVGb7M22/
         X+6FARMOIG0dSXMUxxutIGsPTHhvfsE4xMM6DiD93WplC7HcSagjhEElEVXI8sWI6xpN
         hK3Q==
X-Forwarded-Encrypted: i=1; AFNElJ9tfLFKU13v1J4SqCtraDZyoGOYka3MEzi7cz+1/YXIPtbp5Kzvv56KP2+zWALw/mRzfJDXxxXc/g==@kvack.org
X-Gm-Message-State: AOJu0Yyla5f7vIRk1mZTmlJbx/eBA+ZrYXuq0KRTryVFz0/zD6fay88q
	PuH8CTe3MFotAfqWiuuy7dYI/hro7XcaOJtzZRXsKuO0fLeeYH2AqQjN
X-Gm-Gg: Acq92OGxV/xY+C/sAcHqFEq+/KC/q2JY2V1T0iohjBxGFvtClNppoulT0HXQoSq2QK+
	EPsuuPYxhIf436qPh1FwqMHZa4059uesAsny8VK0Um5S8EJEH8mgNQYGLL+OflZj0nLRQzG6gCD
	GMERPXD6el6hb+xwzNkyxjQz+P/jdmw8V4jxsnPuqjd3Am3FmdPPrC+nhe6m8OX2yhl6dYyGiHC
	nbeVjY3f9qO4aPLEvIFRnaLF+vForqVARYG24AhR5Ut/7ENwEDj8Num+PraxyqpLmN70UTA4SVa
	JZmkeX3hYkliHIqgP92ctRV+I0w1lCnUPFZVrhy5OwYcbqQwBLO15Xb0Ikx9RemXs4BaJq7ztwF
	oqiPrZlZv4/vJ0QAbJjrrUe8+L0ustNjL+QqiM4ojehGZlEj1ojqvrkWcVV1fBAsWcAAyjCNMJ3
	TtNFcLLXBBUvntoa8Ws6yLb6V2UArLYXf1QED96Me82izrwMRSnGF3XU83eB+jLDw=
X-Received: by 2002:a05:6820:2082:b0:69d:9e3d:4e19 with SMTP id 006d021491bc7-69e1038541emr288425eaf.30.1780080063615;
        Fri, 29 May 2026 11:41:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43c93a22989sm1468687fac.1.2026.05.29.11.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 11:41:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
Date: Fri, 29 May 2026 11:40:59 -0700
Message-ID: <20260529184101.294638-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <ahnRIDBk4bQ3xX2q@yury>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tnk43qhmqu6t39njjodednucyh4gw8fq
X-Rspamd-Queue-Id: BB9C510000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780080064-392999
X-HE-Meta: U2FsdGVkX1/x6+Z7FmYzRx/Ri7jYy/f55YnZ2pfdcOk4JkHWXgTZJxHPtWYO1YC4JKoN7dZA5MwJCde8L9XkV5R+PISS9+xqM/zvIl8bFhR7UBlKHk46zuXzqCJB9hcmWtyMOziKshiH2jrH7IND/J45bJZKytDvwBEAa4vzcn/zORw/r2bWPLSxGtXjaanBx0oTnaoAt3jlEKDrmYYskRzUVNOQaem80DD0R0yso/E7nLITlopBiB267VNn+0C7zssphczt54Z6pHL3M3n/eu/mWxG9q8o74UKawGR8dezuQvlEYik03cvOJ506wVrtELpugbyFUKS+JiSMNHo4O1647E+iPH0LgmpViQdWxtGQGFnxLtDxkXtGhhGgMlU0WovbMrkW9coW1dfyBcRlFdm+i/vilcpb/hehlcr9nSRznc4A8HF8/CvMj6M7XGW8VhgI/9Ppsk8+8nK1nag3h9h9Bu0Sau0Xlyf9wMpx4zd9KnoKrPLiwAHIVvEkPus6218G58C2StYvLZOE0yRY2lTyEukKxT/tWvo21s6vOoGwqxbtAlieG9eAkiufnD5bOq9OpBIqkQQ2wipTcR+xuy/557MbH6v2kDCvCUzgJnAu6DPGZt6YqY8hBPvnRnR+oh31trdi1deizCjbKExIatphsFpftWllK28rIsHN2xVsD6NwvvgtEeC+OauAO2FEDcthZezvp2/ydDE71N11RrTwMjwrkbLX4H5YiJN9AqQPGPHDe2X0QFLlSSrYIv9fSfdFhNBXDwPh39OygYDwofqerQtq58ZS5/fDgOnimbqqdLhaEir8IMv+8uiqroUDQM+nGg0tN4H2a0tVPKbkLjldFrphYgwkZWkf7HXsO/Rwao9G9Wk23NHWm2Fo1RetIvw5A2s5XUBwGlQ6aT9erP7cizELuNIS+9sLtMgZfbkZI/gsrgaLL+Z7m7j27Sl1O//cVWJuCDrzcRXVb5I
 6maywe/X
 KOJ/MDq1Z32eK5YqPzXPtFjpeYYOTK92PV+BtnNR//C/oJQE9JdLfJrW8zQbuX2kBvlPbRAkpTYMnLapyJjjNFlaFg71Erd7wZXLrSnXSjI5XGmrBc8r7ujCkhpgj/BeI4shylrUNhCWW/qbqs5OfVw8WF4/P83CXjpNHcGQHFxQbtAHxjV9Z0/Oz8CfnJXSEAHyShO9edtmQDqcWvJAivMcD+uYfxuACdTUK8wp62qNHtBroEenxt5BlQiVVmrnKBfkKJjMoD93HBM29CqgLvxqUK02oacQuWmzT9b9SUjbTa77Fitm90O2f871jmf5Iy//VHVQh5aw/p+3d/zqHbTAp1Y5ysvGTUAQpjZiqAR8iqaUOFPZemtgdjnbkTAkXNxBvKlztII4HPqocmUvnLf7tIh1/gQ3lo13+7l46Uy05gpt9ytZpz6wiDON2SGZHnhQa8l12x1zeyO4fzD4cIqjKImyXldpmqN5sjog7qoGagpCqh1gXSOn8SpLReABMAdngkRo6Kfvm/z68WtTW4c61HyvUOKNdZ8UIAb/RA/NFR4VOd/tE8tGMSyfdtBV6srgYbeYmiXOusn9OicCc6VRkkbJenX100W+VLqhz2F8cyJkKSrQ6+Wyvhs7R0eWktOTKx05gr9vgRqgvnakUiCKawQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 13:47:12 -0400 Yury Norov <ynorov@nvidia.com> wrote:

> On Fri, May 29, 2026 at 08:26:15AM -0700, Joshua Hahn wrote:
> > On Thu, 28 May 2026 12:41:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 28 May 2026 15:03:37 -0400 Yury Norov <ynorov@nvidia.com> wrote:
> > > 
> > > > Reassigning nodes relative an empty user-provided nodemask is useless,
> > > > and triggers divide-by-zero in the function.
> > > > 
> > > > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > > > Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
> > > 
> > > Thanks both.
> > > 
> > > It looks like this is very old code, so we'll be wanting a cc:stable in
> > > this.
> > > 
> > > > --- a/mm/mempolicy.c
> > > > +++ b/mm/mempolicy.c
> > > > @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
> > > >  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
> > > >  				   const nodemask_t *rel)
> > > >  {
> > > > +	unsigned int w = nodes_weight(*rel);
> > > >  	nodemask_t tmp;
> > > > -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> > > > +
> > > > +	if (w == 0)
> > > > +		return -EINVAL;
> > > > +
> > > > +	nodes_fold(tmp, *orig, w);
> > > >  	nodes_onto(*ret, tmp, *rel);
> > > >  }
> > > 
> > > I suspect we should address this at the mpol level - it should never
> > > have got that far.  Hopefully the mempolicy maintainers can have a
> > > think.
> > 
> > Hello Andrew, hello Yury,
> > 
> > I agree with Andrew here.
> > mpol_relative_nodemask is called from two places, the first being
> > mpol_rebind_nodemask which is the calling function seen in the bug report as
> > well.
> > 
> > The other place is mpol_set_nodemask, which has a helpful comment that notes:
> > "mpol_set_nodemask is called after mpol_new() [...snip...] mpol_new() has
> > already validated the nodes parameter with respect to the policy mode and
> > flags".
> > 
> > So it seems like we are missing the big if-else if-else if block from mpol_new
> > in other places that should in fact have it, like mpol_rebind_nodemask.
> > 
> > The approach proposed here of just checking whether the node weight is 0
> > won't work for a few cases, namely for MPOL_DEFAULT and MPOL_PREFERRED where
> > empty nodemasks are actually allowed. So what should really be done here is to
> > do the full policy-nodemask checking section in mpol_new and call that from
> > mpol_set_nodemask as well.
> > 
> > Thank you for taking a shot at fixing the bug report, please let me know what
> > you think! Have a great day : -)
> 
> Hi Joshua.
> 
> Indeed, quick and dirty shot.
> 
> The problem is that nodes_fold() can't work with the sz == 0. In
> other words, folding to a 0-bit bitmap is an error. We don't check
> that on bitmaps level because it's an internal helper, and it's a
> caller's responsibility to validate the parameters.
> 
> nodes_onto(), or more specifically bitmap_onto(), is a different
> story. In case of empty relmap, the function actually clears all the
> bits in dst and returns.

I see, thank you for helping me understand. Yeah, we probably don't want
an empty nodemask here regardless of policy, as long as MPOL_F_RELATIVE_NODES
is set.

> I see 2 options to move this forward.
> 
> 1. Simply disallow empty relmap in mpol_relative_nodemask(). There's
> no valid cases for it, AFAIK, so the nodes_fold() limitation looks
> reasonable. We can consider it as a new policy.
> 
> We've got 2 users for mpol_relative_nodemask(). In mpol_set_nodemask()
> we can simply propagate the error; and in mpol_rebind_nodemask() we
> can throw a warning and do nothing.

I think we should never be able to reach mpol_set_nodemask with an empty
nodemask if MPOL_F_RELATIVE_NODES is set. Not sure if we need to be extra
defensive here.

For mpol_rebind_nodemask I think we should actually do some more checks,
I think we should do it in mpol_rebind_policy since it gives us an opportunity
to catch other sources of failure too, like calling mpol_rebind_preferred 
with an empty nodemask as well (which shouldn't be allowed for MPOL_F_{
RELATIVE, STATIC}_NODES) as far as I can tell from the checks in mpol_new.

Setting empty nodemask for mpol_rebind_preferred won't throw a div0 error
like for mpol_rebind_nodemask but we can at least throw a warning like you
suggested. 

Does that make sense? This is your fix and if you would prefer to address only
the div0 case, that makes sense too, since the empty nodemask for preferred
is more of a semantic incorrectness and will not cause panics.
Entirely up to you! : -)

> 2. Follow the spirit of the nodes_onto(), and in case of empty
> relmask, clean the ret mask and bail out
> 
> I'm in a favor for the 1st option, because empty relmask looks buggy
> anyways.
> 
> > The approach proposed here of just checking whether the node weight is 0
> > won't work for a few cases, namely for MPOL_DEFAULT and MPOL_PREFERRED where
> > empty nodemasks are actually allowed.
> 
> Not sure I understand this. The mpol_relative_nodemask() is called
> only if MPOL_F_RELATIVE_NODES is set. In mpol_rebind_nodemask(), if
> both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES are set, the former
> wins. How would the RELATIVE mode mess with the others?

Yes, you're right, the case that MPOL_DEFAULT and MPOL_PREFERRED allows empty
nodemasks is precisely when !STATIC && !RELATIVE :p this is my bad for missing
that case completely.

> Anyways, I'm not really deep in mempolicy domain, so please educate me if
> I miss something.

Thank you, I have also learned a lot looking into this to think about what the
best solution is!
Joshua

