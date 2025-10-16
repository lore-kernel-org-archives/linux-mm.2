Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38082CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5C38E000D; Thu, 16 Oct 2025 13:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48CF98E0002; Thu, 16 Oct 2025 13:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9DC8E000D; Thu, 16 Oct 2025 13:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1978E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:23:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B958A1403B9
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:23:38 +0000 (UTC)
X-FDA: 84004649316.13.61E0749
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F289940009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:23:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Cptmv/rQ";
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760635417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rCT4znV237QOkBlxQoKrSlSCe6zr1l4d7Z1n6pK7lg=;
	b=liHO8wizUr2LqzFfooj3sEt05LxRY0b9SzfCq267g4Aw9r0EIKe2rPA2T13DvgNv7Hdqzd
	MZsb8J4afTkqyFjpIANWHG+UFCxsa/MkkxIaZ2JA1pEqHkAwpqvkFTxHXzg2xuuPJQMlns
	IsfVXjNgd0YWk9xRl0QaiQyblk3Tr/c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Cptmv/rQ";
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760635417; a=rsa-sha256;
	cv=none;
	b=EojlXVwx/SBTAy6pTqVV0kiICk7DY9Jt1lmVC0BPVTnDRoLmkYcRCM8V4t8f57sidfjVF+
	ZX3Go1bH8oaGntj7wYJBwGkAkcSVKpc8zuLGxqCDYYGPzH5BLFU8qI+fQKQTWwX96vzcW3
	zdp/hNf4XRopRL6qWKaANDwQ9xzT7K8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ACEF43905;
	Thu, 16 Oct 2025 17:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6947C4CEFB;
	Thu, 16 Oct 2025 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760635415;
	bh=8KRuOdH4Sfs4m7wXTsUqeB7BF0nvFp/6nP6RfB3vC9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cptmv/rQwjCU+10SBpptRWsJuD63lNF0MMf7RXVIGHafcknkln+9JuU26krey9Zgo
	 kcGIqczaJhZyLB3waJHIP5ZXdqg+wtuNtSlxX5xgvpADcvRia4n6jX/gfBfLpL9ZoB
	 WADQbY7H39rjtZPZmB53I7xcSTigi08z+2KlmEvKJ/RkH3W6pMSSnrp0jnm5+e8R3C
	 wQDKgLdN/ylAeZYEEK9aGbO2waDGwWIsu4G+kwXodzQGj+EFUMRO8I1f/ghku16Ps5
	 OgIGHEimWmIAwf2O/knQxg6WunIwkTCgCFMpmEEN0kpnpye3PD4BwJlfvIBjyWChTA
	 A8x4NSp6Io+4g==
Date: Thu, 16 Oct 2025 20:23:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
Message-ID: <aPEqDfajAlNnhoeN@kernel.org>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-2-pasha.tatashin@soleen.com>
 <aO9ZiERHff7vQiBL@kernel.org>
 <CA+CK2bA5Eyz6TUMTy3pa5HBvZ7KkiHX3EHn17T=d6LX_X5i3bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bA5Eyz6TUMTy3pa5HBvZ7KkiHX3EHn17T=d6LX_X5i3bg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F289940009
X-Stat-Signature: pg997bftafj5xmncnrymugjzppy61p71
X-Rspam-User: 
X-HE-Tag: 1760635416-502061
X-HE-Meta: U2FsdGVkX1/F6rfUbW9S7l6ajj/Vx0G+O8xZruTjIymhOQGi1F3VV1hECqUQ2oAG9zGrxboAENfC/vo5DCo59UkAEenXUjJ3TEpfvHjsv59K4IptYScAGEO/pO6xFk9Grcrpdf3JZrkULKRbrcKfb/iG8TyDThu8oDcNDCPgpp+CjC0o8Xl7gQ81e/XfE00zsmSQN3e4WmaYBG14s+lDzuNNNQ4cintulQ6Lao8eZJ/G2q1Gu8cohM5lP7rPkuZhdxKb3x0Yrx5ygkaltzaJFnulssZzVPXkcOyMeGIRvA1Hw9HikDSLitzCb50VoIVgTNKGWxITC1YIMgU/oi+gPCvpilg6tZdlJfNFL8ej52clQMpA3ehy9o6oiPIlDOM3ay3oHQJhgstnrbZSqNTID9cMJX9bSNJ6YQaz0LGVxRrV8qko1dTjXRuK8KGYjYX1ugoa3I/mTamwHJul27bcjV/Fwv6tMoAvovEjdxvdXmrzKEL8+6OQndOwD5Od9Gk6az+gxUYHIDZ7esgGml6E7b8ULVzKf71vGyRCoZvPuzGE/fYbpnXXr0qECVfT0P+bkBV5Wz6KXsCkVhoRh5/chy7YsyvjrJSZP/bmVWrO6r7rmZ4fhSnKGOJxWllmq+jDqj4Hbk9022p5s87nrwX77pCCUsQIZR2Lg5mKdSsFIbVTXqlVmNUy2QnRRfOFzJzyzxqRDa7zfHrEFSvVnJc1plkIcvHf+wbbAsdN2YHbL+10APPRrLeqO5CODRKo2YBur67dGfLEbgVrI7d6z5gZEtNDBtf2yUKAUYSpu0+dLtHvAfOyKu2BdPmwc1FQ3/TynCxtxzeyEFjlp7wpTCbs8rRczROIwfCHMhR/o2mII7ENDplvBznLMayd5FvJ7KntYdUGJT5GUnWPFP1DqdQf+htnGatm03BccZZ6+g0MJiPlLn7ePoxmf9xJZJUvZGWu60vKFUWNhKa47O8V2rJ
 Pw5ezE4e
 UfDc/Hw6R4Q3wSDl1e9HQg7hBCnaWdDT/EC/15Rrxcns6f+2iER8EWUXM+mQJBLOa/iyOztujqa8MJOn22NDyQB2wEMvPL5VmoqJwx+mRfTTIrHp5ORNRxmYRc1M4Wj1Fwq7Xrkr6EKg5CDvVmM5faICwNojvrQppLLsZabP31qdyzB0jXIQoJfW1rTBZXWzj+02wC+HQKO5NagGbeLFXTnEO/i53HzbvOWlQtseVA7w4TIy3I+HWXZass60BvfcON8b+3Je0vxWsnyvLysEYInI8Kj/9dEbQLOrX/CgpIR8lvxBOO/G+O3IH4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:36:25AM -0400, Pasha Tatashin wrote:
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > ---
> > >  kernel/liveupdate/Kconfig                   | 15 ++++++++++
> >
> > Feels like kernel/liveupdate/Makefile change is missing
> 
> It's not, we already have KEXEC_HANDOVER_DEBUGFS that pulls in
> kexec_handover_debug.c
> 
> That debug file contains KHO debugfs and debug code. The debug code
> adds KEXEC_HANDOVER_DEBUGFS as a dependency, which I think is
> appropriate for a debug build.
> 
> However, I do not like ugly ifdefs in .c, so perhaps, we should have two files:
> kexec_handover_debugfs.c for debugfs and kexec_handover_debug.c ? What
> do you think?
> 
> > >  kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
> > >  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
> > >  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
> > >  4 files changed, 70 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > > index 522b9f74d605..d119f4f3f4b1 100644
> > > --- a/kernel/liveupdate/Kconfig
> > > +++ b/kernel/liveupdate/Kconfig
> > > @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
> > >         Also, enables inspecting the KHO fdt trees with the debugfs binary
> > >         blobs.
> > >
> > > +config KEXEC_HANDOVER_DEBUG
> > > +     bool "Enable Kexec Handover debug checks"
> > > +     depends on KEXEC_HANDOVER_DEBUGFS
> > > +     help
> > > +       This option enables extra sanity checks for the Kexec Handover
> > > +       subsystem.
> > > +
> > > +       These checks verify that neither preserved memory regions nor KHO's
> > > +       internal metadata are allocated from within a KHO scratch area.
> > > +       An overlap can lead to memory corruption during a subsequent kexec
> > > +       operation.
> > > +
> > > +       If an overlap is detected, the kernel will print a warning and the
> > > +       offending operation will fail. This should only be enabled for
> > > +       debugging purposes due to runtime overhead.
> > >  endmenu
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > > index 5da21f1510cc..ef1e6f7a234b 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
> > >       if (!elm)
> > >               return ERR_PTR(-ENOMEM);
> > >
> > > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> > > +             kfree(elm);
> >
> > I think __free() cleanup would be better than this.
> 
> Sorry, not sure what do you mean. kfree() is already is in this
> function in case of failure.

There's __free(kfree) cleanup function defined in include/linux/cleanup.h
that ensures that on return from a function resources are not leaked.
With kfree we could do something like

	void *elm __free(kfree) = NULL;

	if (error)
		return ERR_PTR(errno);

	return no_free_ptr(elm);

There's no __free() definition for free_page() though :(

The second best IMHO is to use goto for error handling rather than free()
inside if (error).

> > > +             return ERR_PTR(-EINVAL);
> > > +     }
> > > +
> > >       res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> > >       if (xa_is_err(res))
> > >               res = ERR_PTR(xa_err(res));
> > > @@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
> > >
> > >       chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > >       if (!chunk)
> > > -             return NULL;
> > > +             return ERR_PTR(-ENOMEM);
> >
> > I don't think it's important to return -errno here, it's not that it's
> > called from a syscall and we need to set errno for the userspace.
> > BTW, the same applies to xa_load_or_alloc() IMO.
> 
> HM, but they are very different errors: ENOMEM, the KHO user can try
> again after more memory is available, but the new -EINVAL return from
> this function tells the caller that there is something broken in the
> system, and using KHO is futile until this bug is fixed.

Do you really see the callers handling this differently? 
And we already have WARN_ON() because something is broken in the system.
 
> > > +
> > > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE))) {
> > > +             kfree(chunk);
> > > +             return ERR_PTR(-EINVAL);
> > > +     }
> > > +

-- 
Sincerely yours,
Mike.

