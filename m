Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41476C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4406B00F4; Tue,  4 Aug 2026 10:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D0F6B0101; Tue,  4 Aug 2026 10:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B0A6B0104; Tue,  4 Aug 2026 10:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE8D46B00F4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:46:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4199112016C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:46:32 +0000 (UTC)
X-FDA: 85063863024.03.800AB07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85929C000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:46:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkxaN2ik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUvC+y0j8JFjtE+XMJ9UQGtCiCNbH3kOeZKEuG06DWw=;
	b=QwHbp8dOww9TYuB2cnPMjQGVqhX0NedC9kAS5xE7pTS57HHKXP+4WrxdblSY/afNhUbewT
	NMVRFBPCtxNvCZsC2v4zm41Q5bFzNVkwmy56s8KZpzJd3+0xTVJA/B32qKcc9YAlbsu/oj
	5dTtu05Gm1mMvdPm5PYNp5d73E8AiDM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkxaN2ik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854790;
	b=jKebLHzYV3owyTmEeEyul+p6IKkQsLWCMi3qL7K2z9mxPAlx0w33QSSusl88gacDTX1WaY
	sk90AL4fYvlE6avI2p+PZM2i5GGKpg+4TuApgO2lnX+GZxaMjfgIBj9nVvznS4XnwEXzQB
	EPUP/1TBuSDSXnI5DTelokbMYGetvR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7611040BFE;
	Tue,  4 Aug 2026 14:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2510B1F000E9;
	Tue,  4 Aug 2026 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785854789;
	bh=uUvC+y0j8JFjtE+XMJ9UQGtCiCNbH3kOeZKEuG06DWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RkxaN2ik9P4rS1+/q3KgKb/2D2Eh7uomzp+QNGTLlcFGiVoRdD2vuChwYpMjwFQp5
	 ECUUHTxHFDlqwTii01KYRocgyxJj35A2kS9tX/ei31yWKYaIN9L9YFhsn2ZlSdxdyB
	 gu0aWTswPsa/XnAveSiWQSG8fjaOZEZV1PuVweKw3vJk8stnyIOtCX8KUpkc7OCrsx
	 n5diT9WhcnlnZyAygOsDSKKw9mkehqfM6GW24BR59cBzv+d7NN+rcYhlTya9qTqOqf
	 dxbLbJyZSgtJtNT8G+GckekF/SFjztBDfoEeCQENfohv6Y+9YdnN1HvSiqsu4FzBxO
	 kMbSJgWnIjbXQ==
Date: Tue, 4 Aug 2026 15:46:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, surenb@google.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, david@kernel.org, linux-kernel@vger.kernel.org, 
	zhanghongru@xiaomi.com, willy@infradead.org, zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on
 user addresses
Message-ID: <anH3jVrBlUMLd-28@lucifer>
References: <20260802074018.73887-1-baohua@kernel.org>
 <20260802074018.73887-2-baohua@kernel.org>
 <anCu3DOrXDeMrwi5@lucifer>
 <CAGsJ_4xM7mmv_Xa3g2mB_0gW0_VtYhMtwz0idgYLyoAYiHFmfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xM7mmv_Xa3g2mB_0gW0_VtYhMtwz0idgYLyoAYiHFmfg@mail.gmail.com>
X-Stat-Signature: wdm9r9ss3sa9xa7r6sikkcctdxzezqwu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85929C000D
X-HE-Tag: 1785854790-524475
X-HE-Meta: U2FsdGVkX1+BfvS58ES9ZsTXOAbNarLTlO8X9NcqLf4dloC3O+sEQVoF0GBbrPGIMlZtIWxTTpQCXMbv+Z8eBS2AdxR6yef++VQhH7eabDsarlcNDaplWd876gbWZOIZqX+Zj6J5etVgnG36TT85C4s+nUZT6fEYma7dYRnd8Ql801PdB2kh1QZtAOAQ9lIqkhtcVjQ9tKTJrnk4EUGZVtDH+9bLCRlur5Ziq1LR5FAZtZ5RRD0LyPHdNqlnaKz688xi4k7oWj4NCHerb2Re3eaOcFWTGn61+2D1jPPYFrU9u2E4Xo/NMj58DXeoocWDKctNewbGY+kspanNDRxtl/E6L7uflFwd4Z4yGEDgXIoSOlHz/vqZDVb5YZ0HEqUOJFPJIySX+2xX6uUTX3mUA7vbdRvYNFVRXXKJ/IjL/D9Zvck0gOvlR3+zdEa4zrXG+MBb+B8NB1/T50Nk+T3mPHolk9kpThRPsaVRcgPaIVpnxGVgC8UEK0+Qk10UKk9BH7pGG9fTqtYiZDma3rJZvPD/Zgio6OdTRlKnLeCPpT9qq06VFr2KRM7zPkV8VmfiDE5+56TVetFrIlNp7aYSSk84OmzczqTmwjDy50+l4xe1q4Xg9TuG2bMSZV8jiQe5pJTWOBLAlH38MXfRX6ur2ZwAq6vQwoVwsZUTu7QM7jlNfCPFw0++KCk7MNi9FzlyZ4SsCt/op/6bhKU+MjRLy6wsiyiqxbO9wKWI5CSwcN81n8NtYWU5JwBxwPNrK646fMdRnfkx7rArbtwI22GdvsM5NhG/0ikv9nXDUWTJCu2sTUIrxk4gOmklex1fPEr2Mlajjl0V2TZmWKzSfcM8CNk5HVgdODRlTPHXa5C68+Kg4fRAyNEB28hGZ+xi82PHfy2UdJRbEsmoNG333gjOzA2FYmOEG785xintw4ibjr6hKOYpxsIQuD49uzT9UiA9rQFoU2oGjQpMggUSTSc
 2bctVvtO
 AAHfKmJrdwOw4oJ+CHYyQp+hN2iEJVolPwaAXBz5mvmUhRxQaF77+23ZJ5G2vNigbxyaN+JLBXQgeTkOZ/bQs9+3siVAPaL4ew23bBxzAEhWvcMIpVp4FRSrSRZMCB4TkI1AjpapFLcmYK9ZF/lqeFcsd4cw8QsNoOSwZfXqQZbvELDpDoXP7V9QmL/EjE8yOO4EPYRvxqKoi1XBswYhqezLyWXjz0uohGphyipnL4nN3aWynKZPM05i1yQIA0LQfierp2ibCHKou2uwmJ+bWdlJP3/i2Syx12B6+mTyS8/cKPLy/rkt7dGZAvLxsnB4BrvWL57Q9pBwYwAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 06:37:31AM +0800, Barry Song wrote:
> On Mon, Aug 3, 2026 at 11:18 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Sun, Aug 02, 2026 at 03:40:17PM +0800, Barry Song (Xiaomi) wrote:
> > > Use the VMA lock for kernel faults on user addresses. This also
> > > makes the existing code below meaningful:
> > >
> > >   /* Quick path to respond to signals */
> > >   if (fault_signal_pending(fault, regs)) {
> > >           if (!user_mode(regs))
> > >                   kernelmode_fixup_or_oops(regs, error_code, address,
> > >                                            SIGBUS, BUS_ADRERR,
> > >                                            ARCH_DEFAULT_PKEY);
> > >           return;
> > >   }
> >
> > Hmm yeah :)
> >
> > Bit weird it uses user_mode(regs) and the early exit uses the just-set
> > 'flags & FAULT_FLAG_USER' too.
> >
> > Some horrible duplication here too... the user_mod_regs() etc. code is just
> > duplicated in the mmap lock path.
> >
> > I think you mentioned it on Suren/Dave's series but vma_start_read_unlocked()
> > would avoid all this and could lead to a nicely red patch.
>
> vma_start_read_unlocked() could completely avoid falling back to
> mmap_lock for binder. For page faults, however, there are still
> paths that must retry under mmap_lock, such as
> __vmf_anon_prepare() and swapcache_is_device_private().
> So we may not end up with something as clean as binder, but I
> think we can still achieve a cleaner design than what we have
> today.
>

Right, and also fault retrying (though Hongru's series is looking at giving at
least 1 more try under VMA lock there).

Let's maybe wait for that to settle first and see how that looks :)

> >
> > >
> > > Right now, the code above is dead because !user_mode always
> > > takes the mmap_lock path.
> > >
> > > Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
> > > Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  arch/x86/mm/fault.c | 3 ---
> > >  1 file changed, 3 deletions(-)
> > >
> > > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > > index 45b99c3b1442..c22b74e0eeaf 100644
> > > --- a/arch/x86/mm/fault.c
> > > +++ b/arch/x86/mm/fault.c
> > > @@ -1328,9 +1328,6 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >       }
> > >  #endif
> > >
> > > -     if (!(flags & FAULT_FLAG_USER))
> > > -             goto lock_mmap;
> > > -
> >
> > I'm not sure why kernel faults of userland memory were excluded initially
> > (Suren?)
> >
> > Given that it's OK to take the mmap lock here and we're necessarily in process
> > context anyway surely it's OK to take the VMA lock?
> >
> > It looks fine to me but want Suren's input.
> >
> > Also given vma_start_read_unlocked() is coming maybe that's better for a
> > cleanup.
> >
> > And finally - Willy is working on a grand clean up of this stuff _I think_ so
> > you probably should coordinate with him also?
>
> I have no problem waiting for Matthew's work. It is the right
> thing to refactor the duplicated code across architectures for
> the VMA lock page fault path.

Seems sensible thanks!

>
> Thanks
> Barry

--
Cheers, Lorenzo

