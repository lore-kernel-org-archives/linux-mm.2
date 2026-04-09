Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A73E9DE5F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36BB6B0005; Thu,  9 Apr 2026 03:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8806B0088; Thu,  9 Apr 2026 03:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCED6B008A; Thu,  9 Apr 2026 03:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBDAD6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:59:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66B5E13B25E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:59:02 +0000 (UTC)
X-FDA: 84638266524.24.FC3B87B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C82681A0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:59:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y5C3Nu4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775721540; a=rsa-sha256;
	cv=none;
	b=TRbPLB+rk/sOc/RgSQtlrSVkUc5Vv/Sek+8LQIHKsMpKuHnbN3Mhp9RguMUTWNHcE9g1DW
	BkSzAgzoSbWprNCXS2zAy53uz18nDlHQ5GadJwYDX3GofnkCfKt3sSRwcTaRHO9V1JZsgJ
	k3WfDDOequUAjUGhF2ihgU+Qgw03/4I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y5C3Nu4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775721540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBbDNSBHtp7HZRUrPrLAaAwZ6qZc2fYLwlE6qDGmZSU=;
	b=kgxACNhI+nBWvt5u2qlfM2RyjbzS6j6aqe4ypmHPuB0+StDREdTGQg9VwrN9jIQ2oWULmZ
	aRJRjBA+1mcBZzaDEovRevXBkvXQYnzMVj8Kw9URTyyz5C6O64QltOctx+47dEXV5FhtZ9
	e+6/oEVzKP6cT3MApG7d36yD3HvnmOw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04348600CB;
	Thu,  9 Apr 2026 07:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C7AC4CEF7;
	Thu,  9 Apr 2026 07:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775721539;
	bh=vWlsbBNlV4qxxJh+mktKzb+dE9BzzFofWF3ur8Ob5iM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y5C3Nu4w/fCBUkGKprgozESwjJS2l94AULTHqMmwU6SJoUNQDRtJDsLEwRobzzi4z
	 dMFUXS8mGNN4q6a2djyCGMWuNIB30YAfU34um99BNH928/q4kVBmFQJUM73ou7ZABi
	 K6GWcorGWf0WTlaFMoTcrwhWfGOMGqdmEgZWwdQp9xGGJiUlT50QqndTBEVnE93MPP
	 iz5f1T1ZqbMbfTHPobvw9rE1AzXoyuulPMyFFwKIhjgNMDPpBwYc67TdzDGXbulj7o
	 uTftzrY7E+0TzoL4uQ2oDMe2RsNIjr75HKWklfIfgOhXi7mw4l6GhKKWXInNJ76BJj
	 5EtRQ2+Jukm+A==
Date: Thu, 9 Apr 2026 08:58:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Denis M. Karpov" <komlomal@gmail.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, rppt@kernel.org, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, jannh@google.com, peterx@redhat.com, 
	pfalcato@suse.de, brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <addXVDMjY89-cJ4A@lucifer>
References: <20260407081442.6256-1-komlomal@gmail.com>
 <adXJop1d0QdH2Mwm@hyeyoo>
 <CADtiZd3AcY2LwPfCkb782TaY1h50dTPpEzhfLSyMeQeXG6VXfA@mail.gmail.com>
 <adcUHx27oZLftSjS@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adcUHx27oZLftSjS@hyeyoo>
X-Rspamd-Queue-Id: C82681A0005
X-Stat-Signature: 19wt51sheeme67t7t3si8axjn7i1wk8u
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775721540-919993
X-HE-Meta: U2FsdGVkX1/D+ZRx6GO/u31R7rNj0GHZoE74V1lEfolyIH5CHVZLk6U6VBE+6Z5Ztd8TNCA7Bu6IxGkOE39uzBTKBBw98OPshZHf5w++ksakv/wRNc+6U64DJNssoTrh/i1U6IlIgXkyeeC/3orxtDcMp/x0SCaH1rw/nD/2/W78jQ49hf46WNZU0q56iGpaBqjpw7Ut12kCR/LSDga/BLOnMDdYUM+WrhDODF91BTiM0zDHgRj1MWI93D/hvnN70M9fpCA7TQs6UMNCasK4SCDzpHe1vqNnlR6pDuvp3/dm/ERfaoD1Qlq0SZTxZfr2AqV0BOdgSQQPFIo/ln7rjh8uCvxIRO8ZD8/94cfxK6ro4Ap/1QyS3OeyUN2e2INRGuu1zav+ysgO05N7qRBHU3LkRDrQ2as+M7bmDgzPbgzSLSUqrHyb611pkiQLHtTIu65Rhe9zxUrdOHAJyJDjusjySbFSnL5c0edp6S/RKRkk1QDBxLU0WfFaiR/+lAq/oYM5bVJQm8jtW/vcYmIpKuRQB2d7PBZq+UQu8vaTgizrVqad4mduP1otlUl6CQ5Mjs3J/fFZOkI2k9Wc6trN/OxqkP1L1jC7FMNwouskmJbjUp71upCLKaX01IfNWu5/SR/iB4vR6pDIaOhEmbV2maL1k7nYeCTaqKjdVfP2bKNreZ/XhaWLp9HGb6gX40jy3BV5UH1oXeq/+/i+Z0eyZq9E/HC+4E8nyVAOGxkGxQgld06vI4fJ7PTCYo2eyPfduvEHfTanjck7+7V6m11uQuBZOsrblTR7h/lJNvCNpMNhOgZ2TPayUBD005GAc0BxBLCJWTTJBUe7Nx1uMycH0vm952aWiYlDOFxXjebGyI1ZZOzwN+0ahHtH7hkbeSRHlnHwqZTp1HYvGouBFAQRkVYqK0MN84w8TFWm6QHsb+qjRwxUGXbG3UARUeL/7WiutLhe/pfDnIamJZhDPG5
 R/7b0Ptq
 JfXojM2IfZl9KIFyuK62OdgQJzf3tyYsLF8xdISp0VTGnM3c+90oGNpe/0T1OrE1P/9GUz2PPy7KQy93Z8VPQbDxJNTXX4rp60sxuHfbujWzFvvzUSqE0hPXWFBFTuoPphqo2Tp+lZNXSlXEUKnURN29SnHXpUajvoZda7NV7y2Yepy8ymxVzfhNHO3KfLJYKEDBEUCF9sY+BYt9uFPO6GqOoR63aBEut7/E+2QVMCAvfYBDp8TC9JbGfcLLcZmxQuMfsinNToLkeQDhTBmoZzOMeacdb2aWne6XILZHul6dMp5Yw/ABg9SNTSpWHuaC/rxJRWOQVB+QNcOz3e0n40AdrfIOBdX6C+sPm0DOuaHWGs53GRkCSG8yeWhTYY9NNCvzpJ7hmQzOkg636x8pP7NbrbOYEBp++bzKu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:51:11AM +0900, Harry Yoo (Oracle) wrote:
> On Wed, Apr 08, 2026 at 11:09:00AM +0300, Denis M. Karpov wrote:
> > > Hmm but it looks bit strange to check capability for address that is
> > > already mapped by mmap(). Why is this required?
> >
> > Actually, it's not obvious to me either, but I may miss something.
> > My intent was to replace the current restrictive check with a more flexible one.
>
> Technically, it's less restrictive only if start < mmap_min_addr
> (setting aside the discussion of whether this is an appropriate check).
>
> Otherwise (start >= mmap_min_addr) it's more restrictive? (now, the process
> should have the capability when registering an existing VMA to userfaultfd)
>
> > I think performing this check here allows us to deny invalid requests early,
> > before locks or VMA lookups occur.
>
> But we're not trying to optimize it and we shouldn't add checks without
> a proper explanation for the sake of optimization.

Duplicating this kind of logic in the already horribly duplicative (and more
generally, horrible) UFFD implementation is actively buggy and incorrect IMO.

I also find it extremely odd that we are validating that a... source
address... is... mapped that way (in userfaultfd_copy(), we validate
uffdio_copy.src using validate_unaligned_range(), as well as the destination via
validate_range()).

It just makes no sense to me at all.

Let's get rid of it.

>
> > Removing this check entirely would also allow using UFFD in cases where a task
> > drops privileges after the initial mmap(). This seems reasonable because the
> > VMA already exists, i.e. kernel already allowed this mapping.
>
> Yeah, that seems reasonable to me.
>
> IOW, I don't think "creating a VMA on a specific address (w/ proper
> capabilities) is okay but once it is registered to userfaultfd,
> it becomes a security hole" is a valid argument.

Yes.

>
> And we don't unmap those mappings when the process loses the capability
> to map them anyway.

Once it's mapped it's mapped...?

>
> > In the [BUG] thread discussion
>
> Was it a private discussion? I can't find Andrea's emails on the thread.
>
> > Andrea Arcangeli also suggested adding a check for
> > FIRST_USER_ADDRESS to handle architectural constraints.
>
> Again, what's the point of checking this on the VMA that is already created?
> *checks why FIRST_USER_ADDRESS was introduced*

Yeah this is just the exact same thing with a different thing to compare
against no?

copy_from_user() will handle this in mfill_copy_folio_locked(), returning an
error if a user tried to copy from somewhere they shouldn't have (the same way
as if the user tried to copy from somewhere else they shouldn't have).

Let's not block on off-list sidebars.

>
> commit e2cdef8c847b480529b7e26991926aab4be008e6
> Author: Hugh Dickins <hugh@veritas.com>
> Date:   Tue Apr 19 13:29:19 2005 -0700
>
>     [PATCH] freepgt: free_pgtables from FIRST_USER_ADDRESS
>
>     The patches to free_pgtables by vma left problems on any architectures which
>     leave some user address page table entries unencapsulated by vma.  Andi has
>     fixed the 32-bit vDSO on x86_64 to use a vma.  Now fix arm (and arm26), whose
>     first PAGE_SIZE is reserved (perhaps) for machine vectors.
>
>     Our calls to free_pgtables must not touch that area, and exit_mmap's
>     BUG_ON(nr_ptes) must allow that arm's get_pgd_slow may (or may not) have
>     allocated an extra page table, which its free_pgd_slow would free later.
>
>     FIRST_USER_PGD_NR has misled me and others: until all the arches define
>     FIRST_USER_ADDRESS instead, a hack in mmap.c to derive one from t'other.  This
>     patch fixes the bugs, the remaining patches just clean it up.
>
>     Signed-off-by: Hugh Dickins <hugh@veritas.com>
>     Signed-off-by: Andrew Morton <akpm@osdl.org>
>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
>
> Oh, ok. there might be a raw mapping without VMA below FIRST_USER_ADDRESS.
>
> Adding such a check wouldn't hurt... but if there is no VMA, you can't
> register the range to userfaultfd anyway?

Exactly... and I don't want to see us randomly do checks that already happened
previously.

Putting duplicated bitrot-baiting code in what is one of the worst areas of
mm is not something I want us to do, and would like us to actively remove
anything that already exists like this.

And the fact that this is in an fs/ file is even more annoying to me. Really I
don't think _any_ meaningful uffd logic belongs there. Especially since we have
a bunch of other uffd crap in mm/userfaultfd.c.

The fs/userfaultfd.c file should be a bare-bones thing that handles the fs side
of uffd _only_.

Cheers, Lorenzo

