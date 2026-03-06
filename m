Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA47F01829
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C08C6B0005; Fri,  6 Mar 2026 06:19:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243BF6B0089; Fri,  6 Mar 2026 06:19:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F9D6B008A; Fri,  6 Mar 2026 06:19:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0581E6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:19:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABD311A057E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:19:12 +0000 (UTC)
X-FDA: 84515391744.07.932A230
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 243DA40012
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:19:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SIoEzS/D";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mao5sDzSUZ+f9uQRGE4C9WfuIvF/XWcry+r5NOvZOYk=;
	b=jnqraN0L1ZsHmFBGfbxt3/5yZn4CzTH7gIoUvu2aN5wo6te3dzg1zaAPjkGK0I9L97mMV5
	PgdX5cVvsdvFoiAjP4lKbIXg2CJSvWjPMWX6yWpOjRRTF4gIyd6zx4pelanRSb/ZakIfwn
	MXgpzFdhEkMBD2opkEvptzlZuK5yY/c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SIoEzS/D";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772795951; a=rsa-sha256;
	cv=none;
	b=wq86csWuqavV+4Hakt7o2iX4qmhisT4s3uT92lA2TvIWNyKLRfBS5fdN9Xpt6fMIpvcnSv
	ar4Q5x+S1ReVRwd3o2WuVsUc0uTZEyKRkkDD1okgNgN6lYmMaOXXczvS7V0gO7hxx9iwN2
	1vSRXXwVjObwHYBO6dQrwgjhhGYQRTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9820460127;
	Fri,  6 Mar 2026 11:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD33C4CEF7;
	Fri,  6 Mar 2026 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795950;
	bh=Mao5sDzSUZ+f9uQRGE4C9WfuIvF/XWcry+r5NOvZOYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SIoEzS/DxNjqL5S12WR+Z4yk2+4eKi12ei99kZadEHX7MESoV5Wv16WGPtc0njmef
	 y90QEYTXb5wJZglbt0twBS0mvmRICjSm+Pf4pNVSyOyHKbWu/l+0AES9uhiEQcOvDj
	 kh9D9puozrjzimBHTc3sbXUJPclGB4LyqpXKH2lNjcq9sZ/0S+5RJbLGfNQij8sk07
	 mEgagnudwYDACrGUEXJGJRHldgqqHPbw2M4hPETiptO3fvQnUBFuVUWhwsn15OIe8O
	 Nd8cqwkuH0f6HODDVKq1OY5MrRDFUqGhe3otSE6QZyqmDQt7e1ZTflx4ufrWF8MyJf
	 iV3kpykXdQjkw==
Date: Fri, 6 Mar 2026 11:19:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 243DA40012
X-Stat-Signature: d8xqmcze3rnsaryokucnugnt4m65y63u
X-Rspam-User: 
X-HE-Tag: 1772795951-198954
X-HE-Meta: U2FsdGVkX18e9XhAVTSEWhcLc5AfEuwn+1oIEXwF0SdeF0Ne4nmdaZSUB8TIzyKg2/R3O8XvcKcJ7uHUUhKmowspiD2ZATHYLhrx69FFlSF4JArOjBSfBx/q/gRAs1hLnDw3n8nXpdmkB8qjmQ4zhwbovZ1YKnFELsjaheBnqjdwP1DSiXcJItPAd8RDFxWDpAFKmNWeTj97WnOMl7jRrKgN20GJ4fdgHO0sTBCTskn4w8OUpylrsRNAnwYfCA5vP4IlfoF3YSTczBorugOpFG+IHM8Qn/JMQNX4PrRDHw/EiGpEraIUqCJRpMZurTPTYxJahgSZ+yEQ7q0SZUkgFf3m32HIMz8bSt2VuGT7z6OKzdJsdlFrOtHfKFZJMez1ZUIeNAsIj+hP/1BO9Jd2R9eVGJCNlyg4F8wJt9pdZZuxppJg17zLz5hslLGeh1Lcmt7eQC5xCkmUeh/GjHSvjDoxpwhjmPEl++7QnucqRfggD1j6OaKKuj8JrQGBosRs+ZBeaH9N2UNnvJkTbUuTErXJgeG0vnaLvbEku1iHU3c3Afx9h4YKHDBk3RsMYtpN4XVabiwNvMhFtEW8BzgSPFSSXe1BGLL9Pq5czpyI1GFkRlFoMNBfgic4gRgBlVD475Jm4Pgs0Q1VVHm2I/wgB5wU+KeQLd7qL/yD+P2R64mWgv/BbtoUHCMB+AfAxrk5QXRhNy+EpVNqbbE0qahwcVUQy07m0qIZvjm70y6vN/KUlYu0WkgrjFUYXNopyTf/LP1vw6MAFgFq9JMwUaUsCf5894PrA3TTD275A9gQjz0JntKRQYvqh5D6lVUa/MLrOZknoPccTjCS60fF8bCB01k0acdFXv+0rDAhlBz4y+FIJqAomoywe/ygr911LU0ZmDjoZ/YdTGLacf/TlkOU1UBNmH58YOcHrt88KaX0HQxqM/vqkaI6ljrw6faMAYiEF2O0QM6mt5oLXkb20Zh
 ffyQgGJt
 9VbpSeiEOiVu7Lkgt0FG5C2SjrdYiYssiCjvzcC6MX1cQzBUal0/jx0sTKdODwfauhWVwHsZhCRLOYDSz2ZRxTAy8tBuicCH61viWeQxbj3FGwQ+YOKmzo128pFT7oAzznhxkycLZtRwnWgXjviUGMdnQEmHyTWy/NGlgxwO7+QMCKWXu7b0/JV5JUwNWfxKaaDJm+lKhGUDNh7H614N9YSujQ32RwdOEPLZ07BUTvQhdiFs4VMhfjEEqB+zmDy3gC00P2TxQ5dLTIzOu0qolwiv1iqhguksitSOr8qvaZ2W7T1p55hh9n6FawWYG923ue8sFIdHOwdvPS36/U376ZfsB5WvUzn7MjgV5nC+7gal5tHymCE3wo4C6P93DrVNP7/SX8uYR6b41FIVuOujGDHxgjymQoQNQHG5y+GgBsw8H53WB7+qOtvadEZD/jhy1Ljq8Q9UlafreUazvgoBPcAYe5Aa1o1egI3F9IRtSan8EKYL+Ld4jT2qTdr3N82jpWdAh9hEGpNYP8DGetWQjwjqM72VRq6G5QBnm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:13:41AM +0000, Pedro Falcato wrote:
> On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> > Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> > scenario where DAX would not do the right thing when the kernel is
> > not compiled with hugetlb support.
> >
> > Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> > PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> > code.
> >
> > Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> > I don't think this is stable material, but am not 100% sure.
> >
> > Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> > inclusion from KVM code.
> >
> > Cross-compiled heavily.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> > Cc: Nicholas Piggin <npiggin@gmail.com>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
>
> Although we all love less mail, FYI it seems like this didn't work properly
> for the patches (no CC's on there).
>
> Did you try git-email --cc-cover?

Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
:P

>
> --
> Pedro

Cheers, Lorenzo

