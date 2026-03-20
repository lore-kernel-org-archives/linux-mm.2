Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93F0108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE056B008C; Fri, 20 Mar 2026 06:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FAE6B0092; Fri, 20 Mar 2026 06:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D074C6B0093; Fri, 20 Mar 2026 06:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B614E6B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:42:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 653BF553DF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:42:25 +0000 (UTC)
X-FDA: 84566102250.19.5B05BB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D223E180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:42:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HoQLSeAL;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ807pLspQ+l45eky1f3EJwrb4VLL9SLJGFki6UsDpc=;
	b=XFduvzU6ScHLaTevbyVaKNt4teqCSkTVGuQYOEIbGhA/WFWerdTKuUM3DHEtehZCJSc7wq
	ukhcQEIHThiuiICXrttLm+cM/LKN+51TOjHaVnLBlTdFCy7hTUBqo6u+KMZKUK95lAQVgR
	RgvPKU0BuNdeFWS8KIPHS0DSqLTFbcs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HoQLSeAL;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003343; a=rsa-sha256;
	cv=none;
	b=MMxOJntAL1sCBlaGYmw6+frOZQOpmuTrHNIMBWFXrj33OuRcuQEBWDVkfSIzklP/dqyhVD
	FNA+YSYUDOgJAZu7bCswkNLZiUwjY7THppQ1oqbwAIn9Ycmv4ey4wRbEi9wV5ESTM1VWZm
	PhcMwV0ZOIROUGX0oFyFM79qTRm89F0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D8DD60121;
	Fri, 20 Mar 2026 10:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648B2C4CEF7;
	Fri, 20 Mar 2026 10:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774003342;
	bh=wQ807pLspQ+l45eky1f3EJwrb4VLL9SLJGFki6UsDpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HoQLSeALB31/G5kLiQEb7EWs1D5QKT/EPUJ59i3ZXTvGFlzXXRjBv6jGXTIZX/x1S
	 UuiuYAdtYDPuPEKuM/c33j76Gc1juJF+LO+Zlm2fsVktmtVtoLB4PzRFUnussZX7oJ
	 9RenX3fGuAbmSwTFECBtDqhPoTWygdVMpeW0lgOX7/A+q9ZsRj9mR1qQViqrTfvWQi
	 4lMdv6AvQSHfW73ToqIkrnB2qFYF+4HjkBdjQxJEX6eWhovuYhNS4I+EEvymwiQZ+4
	 7caWjm0qSNwGIxVqJqhzmVTUDz1/xIyr//NHJGe5ptZykUDBglO83MlQRyTnazNhhB
	 r5cB//gBqBvHA==
Date: Fri, 20 Mar 2026 10:42:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/mprotect: special-case small folios when applying
 write permissions
Message-ID: <c6bdc9bd-733a-45e7-bf2a-f8b64a5c2423@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-5-pfalcato@suse.de>
 <1cfe61ec-a910-4cb7-9714-410e37f692c9@lucifer.local>
 <zg67zwx2rplbebv6qsnuvtsv25utscwoxzud7c7vvjjxcdkn2c@23n3rqfpiifn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zg67zwx2rplbebv6qsnuvtsv25utscwoxzud7c7vvjjxcdkn2c@23n3rqfpiifn>
X-Rspam-User: 
X-Rspamd-Queue-Id: D223E180002
X-Rspamd-Server: rspam08
X-Stat-Signature: 8to7yhjssp9awssdqtwfy8ckd57isu9k
X-HE-Tag: 1774003343-187920
X-HE-Meta: U2FsdGVkX190fppE87HhRuwwUBG2v+CeasMklZkMdnaNLOCxZEXqGsHk/vUd+xOPfPl+izRnnn/o8kDyyfgzXBBrToVloksVEsVdKbjDjrg9OQNtNikVjyH1q8jIWHYfDNzZSpDowdNGDF/BcZYpZtK8yiGTvV3YiGKqU+n7riFvgORIWqFErPEBqCLoNUqSjCLNBjLS8O4cldS/Xi6EMkQWdgG54kW1ZQ50rVwB04W1ycSrQPVLzn1fyj+cCbCRTZLgda1FpRoE2ovdpaRmY59b0ByIL1YGJ8s30Ft/9ErtbracwYg6I1wcgLb8gA8wBJFArhKh+FAiSGNBGjFslI9MlGKocyXOuVIqzicDX0d6PHP1fvWq5aRlQJCuX/Dw95zv/GAxhiLEKI6ZzyRaY5di2ZyOxKcc+qLagSNfrMOydE/ETcpa+a6ANr4T7n8qs/grPd49MJahKlXXuHQlVtsfutzkpDoEMPqX55YWiuYKDFyfiwfbVconq/4l5VF6CERO1jB9QCfhW2DDfoyUmsmDNc2r+EstIlU+VuG+uNsrnWfrqbSSZwcqLn/mvoj2P0eQGntr0yDpkpZp20E9+hruhF96asX0IZ8VkCINMraTHv+HpdzQy6O4QpK34okVA0dLUUCu6MePi1mD76kqVOY9e5evXwJeEJ5OYAtODUo9fPqKz7YCujALXEqCmTUhEnB/694epUZ8EwH/7intrL/wAbjAgeC65Mk4ZLLv3tmHTNeyhDZE1t7Qd9vdx6B7xQHTz6mfJj1YSHuOHY21/F4XLruXd7O73vleis9jvWvEKKC22FXm9ky6G8hYrvT5T7ltFwHxv7S1wLS1OcY/ehxDPWblN4I4qXY7T/SNYG/ykqQeRGYTAXQFRsR3L3xHQU69pzOdo3EiO4ggty81dZh9xg9gt1qJNOpXbG8fkd0U7GCWOcO6x0kXTw0st9mY2d/+OQXROwRwOsVzCoF
 uncOsFLQ
 VDo9i4L4PeOU4B5Nvyc6ZYyuEpPLCGd6FrWMs1OfPk9HxvAOq9oVyIo8SZjrivTae/3iWXShrF5eqpUNL3obrvGmjrTe39Q6+WK/aOhdTIApVCIor/3IpJnH3TD98biJHrwtZDMbxTfjay44fbg2jyt7hZZ08N7qt9Syz9Lq6+cS7JI+BImiX3F0GbZeCqEw0WDBuNgje/UWrce7yVp0hIsw98dhxeRtbpkG21fz0UlGvLaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 10:36:17AM +0000, Pedro Falcato wrote:
> On Thu, Mar 19, 2026 at 07:17:31PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 19, 2026 at 06:31:08PM +0000, Pedro Falcato wrote:
> > > The common order-0 case is important enough to want its own branch, and
> > > avoids the hairy, large loop logic that the CPU does not seem to handle
> > > particularly well.
> > >
> >
> > I think it'd be good to get a sense per-commit what the perf impact is.
>
> I added some numbers on the cover letter - this patch + the __always_inline
> one do the heavy lifting.

I mean again this makes me wonder if we shouldn't have some generalised batch
logic to handle order-0 cases.

>
> >
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >
> > I am iffy on the likely() in the same way I am always iffy on non-profile backed
> > likely()/unlikely() but this change seems sensible enough so:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Thanks for the review!
>
> --
> Pedro

