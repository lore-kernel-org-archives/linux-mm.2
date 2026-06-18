Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E433CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1066B00A4; Thu, 18 Jun 2026 04:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8A16B00A7; Thu, 18 Jun 2026 04:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5C76B00A8; Thu, 18 Jun 2026 04:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2DF6B00A4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:43:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B375AA0634
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:43:53 +0000 (UTC)
X-FDA: 84892395546.08.CA1976F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 15C6A180002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:43:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UR41z7fP;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uMHM7UuTf2do2f7Hpoqk2j+rviNJ44WWlkZ4oTbhXQI=;
	b=A90ZL63Up7z5blSLm9rRXoJCa44qOf5APuFz9sLr7nnTqZsDiP3kBW3rSZPJV/YuCqktYF
	5fMVfMzy9vpEfXyqrIIYm/bw7UhbHCcFeivpDD8WeFxcIRpChWueCtokxaOkca727UidOB
	+B2cFsG4IOZJILFIPSrxh0f935IubLw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UR41z7fP;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772232;
	b=TBhkhMpGA51NqM470PQd1+KtjISnIzE3N07ZbIVhqp8DMjzkNLynq667ksKpui1Pj4NhDQ
	k8OMCSPkJttqG+laE3TshPKJnMHh+gvpUuVd+lYHkm3lo0YcHiMgFvajCPGDpvMYpM/HoG
	QmKWrXDwsmp36buC5x0CA9bZ1ZW7+No=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35D9F4412E;
	Thu, 18 Jun 2026 08:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5241F000E9;
	Thu, 18 Jun 2026 08:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781772231;
	bh=uMHM7UuTf2do2f7Hpoqk2j+rviNJ44WWlkZ4oTbhXQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UR41z7fPG6eVHeAWjFEh8fwBtmodmDzk+F3Lk7VGgBEcVCo7xuYoZlzv7ajxbUgqL
	 8NHszgXK/0ld2fcayuwb183RFUP1LmOuiz8CbdQgQ+g0aO0woiBL8P+QQK+hbRFoDO
	 scrCxeHw9o6SozJBMF197xUAr85od+/VUepcFepPuO7ob6AsDpPB7baAHXFqQU9bze
	 tLh/Di3w+K881gfrWsflutns/P2W3oo92/VVrZ4xA6cB4Z+qMlmLgc5MtZAvTm2jQo
	 anD2gB94b5c2C0p9yp04vf7bSzD4EtsceR/sSm0clC8omBqYDROVEDgjC8FNutME9t
	 0mcXH1jXo+WWA==
Date: Thu, 18 Jun 2026 11:43:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <ajOvwGs5xhnfBu-k@kernel.org>
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajOtfdGgFQYL-T6f@kernel.org>
X-Rspamd-Queue-Id: 15C6A180002
X-Stat-Signature: 5h3m6bxiokg3fxzss8jb1ddx14saz5xu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781772231-716361
X-HE-Meta: U2FsdGVkX19aAZxUQh98Y4gbDxwH6+/FxhcO9OLi9iyGgWo7l4k03LUVfEqea/aVu5a0dKBKtIss89+UCmvIEJWYUW5NmAj4C/0T9OQsHUw/XpiwTidrhpy7C+GwbQVzZGn/KmPlVJOQqyUCYuC07GDLylsfxd65+jCVSMZ5WwYhg46IEn6Q5VTlQ6FlGtJvD2qiiOYEE9d0OzgZhBd0/8TGfASZbWR2206fsdS/jG5o8sWPM36ycdiQ+DNFr/KRu34abSp+3PEivlQAjLae0kh930WWUb07HOQ7+gfZNNLq6kFP++CXQpx2wVvqC3C4oPDEcjwjngLhhGDOEq2+1+TJh1Mp3+g4xr07AJL0GaULFOjYWnIJfVgNXBOevbFVEU+8ok95yMhzLmsgfYsfutEVLBrJpaQhKTReCtCfTdCoQnWB//r+Z59HGEoP1BjfaS1yZRM6cdtcJ/txJYK7OkPte847ey+IpTRmstrvxbuFPGizyiH63PuQECHIEvxKXylQj+MWgxC9b60C4TzHxt8PMWbqjyDvZPOAf3n9CNLX/2O/an7YzN30BlMSp0HuzFy7K/lkpbiTweMFIE/kLLQv4sGMOrT6rj14iRh62TVyFyWhinj+kmIrmEey6286y2u/dWKGRBpXhM1BRbvt8Rl037BrIHpLi+b1vdQSzvrmJkOvJ2N1LBqh8nhPNO0Luc15MXf07bkMdJqa5mOjFodJOBaxT7HsYjShvf0y6HXwgJug0jlA04gtXXWHOfPWEZv3VRAWWh1/BCPkK2Q5yhJkRLi3axfuvU9AFBaYQY9vFqOml6eNoWCpraE63knBG8Wmc/Z9YcPv6ycRDQAJ2KHQTGSe+VFRCixj72vIs6+fW7SPvqShUKUvKaIjIZLAWg5CBY0i3uCU4DVqlgTbCJGeKJjagHdD9295b0BxXZTmBy7i/dTVh0rp1cTFDrxn272AIV/6UwCwkkfA7Ks
 jbc1ObEH
 BPBygqvcvsJKy5HYufz6Hc7I+gUxzaaVKlxsJ5KhiHcT8Nw//RJtr2q+Bt1qQqcktTHBTnWtapJc/1t0QaIngA7uzW0gboszuWpMu9YADuNFvMdrQI1RrXbAPqUbJl4Qxzjjw2AQfLLJvxd+C5umQ4P0e1cUF3IpyozZso/9W2Myz+Og4SgQav2FdRSlNrH5TofoOIOarLCEDHk33TwUfX05J2BMuhzxw4XheDzDsczLPeHx2YwSuloB8XzRB+c+jmX8GHskoKMVa63T4hHF7T5hQcTh/xeGKWF94Hoi/HtCylNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:34:12AM +0300, Mike Rapoport wrote:
> On Thu, Jun 18, 2026 at 10:19:17AM +0200, David Hildenbrand (Arm) wrote:
> > On 6/17/26 21:40, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > Vova Tokarev says:
> > > 
> > >   userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
> > >   access, you can register on the shadow stack, discard a page ... and
> > >   inject a page with chosen return addresses via UFFDIO_COPY.
> > > 
> > > Update vma_can_userfault() to reject VM_SHADOW_STACK.
> > > 
> > > While on it, also reject VM_IO, VM_MIXEDMAP and VM_PFNMAP so that if a
> > > driver would implement vm_uffd_ops, it wouldn't be possible to register
> > > special VMAs with userfaultfd.
> > > 
> > > Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
> > > Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  mm/userfaultfd.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index 246af12bf801..b8d2d87ce8d7 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -2111,7 +2111,8 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> > >  {
> > >  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> > >  
> > > -	if (vma->vm_flags & VM_DROPPABLE)
> > > +	if (vma->vm_flags & (VM_DROPPABLE | VM_IO | VM_MIXEDMAP | VM_PFNMAP |
> > > +			     VM_SHADOW_STACK))
> > 
> > I'm sure you considered VM_SPECIAL, which additionally includes VM_DONTEXPAND.
> > 
> > Would that be better, or what was the reason to allow VM_DONTEXPAND?
> 
> By itself VM_DONTEXPAND won't matter, as uffd can't resize a VMA.
> But thinking more about it, it's better to make vma_can_userfault() more
> restrictive and just use VM_SPECIAL.

Ah, hugetlb sets VM_DONTEXPAND, so it must me excluded to allow uffd with
hugetlb.

-- 
Sincerely yours,
Mike.

