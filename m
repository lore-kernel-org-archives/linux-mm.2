Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075C6C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1476B0092; Thu, 24 Sep 2026 05:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192496B0093; Thu, 24 Sep 2026 05:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A83C6B0095; Thu, 24 Sep 2026 05:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6BE86B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:16:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D2561202AB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:16:39 +0000 (UTC)
X-FDA: 85248100518.16.EACEF92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 747BD1C000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:16:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHIt26i2;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790241397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YY5WjYIG3f1uBQp6Ur0QabUoDMRyYOAvdBu7ScI7FM4=;
	b=SA7xW41gH51ZID5A7OiM6uXkeE2i5b8P1UpaiHSICsR6n6WNC8aNklFEnLAIGG0KKwBsxS
	3q00fyEAK4jiTld6ATvjoijVJ4msvXox/Xj9YGS1vGMNQJXz1fAt98nPAEwDcQO9DJrE3Z
	gHBAIsJQbbm56AZp1x0nboCQELGe5PQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHIt26i2;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790241397;
	b=tjfPMYfHYwlzVfJ/vb751fah+wV+kO1HiGcisMW0kGrUvEXTPYea8qYSXkD/RAHNFhlRei
	dFAyV/J1qCfbmg3yaIMks46Sy3sFp43ncEoiyxD7GijX2xa17YCp3xIqs85RWASaV21MXF
	ySBVnxzhkaTXSOBMztONUP1nUpNhO6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6B0F600AA;
	Thu, 24 Sep 2026 09:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3911F000FF;
	Thu, 24 Sep 2026 09:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790241396;
	bh=YY5WjYIG3f1uBQp6Ur0QabUoDMRyYOAvdBu7ScI7FM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bHIt26i2rpFUu/t1xBUBlDEnXD7TMOtgmGguf0DBwAO/nDy+IX6JYlaDG85TQHMfW
	 iJp0dQsVPG6t/RDJhyt8bkU2hFukJeCVcrd9BItaM8+HmvUFlON07i271HLS+BGGNf
	 7DiDo0hEQNhzm3+Q63XHGmvZmwDfq9Bg09tTheAmx//43o5PYG666yUSwuf1MREhxi
	 M9pXIeSNLb7+y1RlcW0Q2f7HjRec3jzPri2RJO/itywk9YzGiAgY+5qwqq/1fpCkHb
	 VuHhVKrgs7WG+imjMEIM/KugPaT6+Fg+xKBzdfsjqGLWhkQQFjG+EAWLNMIbh/LFQK
	 W4zqvLVAj4/zA==
Date: Thu, 24 Sep 2026 10:16:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
Message-ID: <arTmmxwNEBJx4683@gremlin>
References: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
 <arTlHBgXSP64U7ky@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTlHBgXSP64U7ky@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 747BD1C000C
X-Stat-Signature: ee7qi4ynm9m4s5i331shkebw1ruk98d7
X-Rspam-User: 
X-HE-Tag: 1790241397-714633
X-HE-Meta: U2FsdGVkX1+ArqLbxxMNoMMnFWn7GyPH9iJATUyd6597+uy7k9Q+c66WIGbUxrIRvZh8oWkOhjG7m7gEfUl8GM6aTJPlIntGR/VTI31rreJ52YbwalOPnf1GQx0J8dQ2PmJBqo6Z6NmhID3WhedymEmFzm6j+c5ywO1zdiMOsuMqJhvcUsHCvFhFBd9ITjmiZaD+DB6upbtmPRmLGn1IoHu8+Dua7y+SYmOdNW/y5ima7RWxUGAk4NnlgPgV4+bf32q/7Y42Mrwwbd2kFsTW7a8bTM6W6fNQr+P45Um9UjI7+jdwPNUvoJ0uVT3fsN7TnL8WPAvEnnqfvoe8GCI29ifJgCSSr/feRAUFQmLG69w742RGEgDPeYxgt+u0NQ0OIv1XkW6JNobRN7JBEZQjrpArokPcOEIZNZtTbVAgx4w3LTSM73xa/ofeTwwYH+3xeUHKUT/+axXQ3SmUMWPeXyiMcGRRaLJLH5yX072OGBNTdg1o5C8kXLvR5PhEmRqSkfnsEAJXn3RtdcQ34aVHAT3cBjjT63CNMsCe4JPIrJCwR6qUHrygzT78dQ9Tzlc8sYii0halqNV1JV3wxRB3fSeniIHhmN6/R2PwuKfyEzIVe+ZwEmSGgW4NBbLzxVxg839+inDZW/kac+b4MZuEsXhNbdyBOAl/2M2AkB3zt4Ux7absjgrxFAud6U8b9zoFaUj7vyqowfZJkedic71fFfR1zsNnyPCmDTYrVftDDK6UWfPd5nvKN1HHzqUcUFNB6bHHGT+k8W/Czh2BzTuNBrmScuBUyuhdleL7gpKJXbkk72D5Xblg+86dnFOO5VjVc0TdGF24l0jbTZO1/9+rwDU82WiwizhrrkjNFH7DorJPZfsmuPUUsm4Qo/plOjQT43pdCQIQBnpNf0PBJyjJ13FbjZTE4l7ufY0NLqJOfm+XWHsyeBf/LSnh0hmuZsZU870zkxinlV/1b1L6x0Z
 R2d6uY5d
 t8czCk4B5lHAjhUe2riRJRVuSRr5vUyKDvk6m2YMatJav5KcpU4lPFvfAWf3hCjMygufTFmgP9arYkqU9xwZqfjUrDeU5+bvKWt2Ti50RH8DfBdFRxmsnWKj2YBQR+bbjhE2zlAdkHeyTzc4aKYmojEu6zxzHDe9TuNghdvdQTsR6cpCLkIMb/10Wh3QiSH2O+LBx7t4ikkhQGpg2p0oZ5pOg6DGyTfR9EldM4nrk9sGnhvl96NycfsD1IGmRzo8cBGHB03P61xwerm2QsHkOCqhkHm2VN3IPUtyIr5DanBq/xYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:57:03AM +0100, Pedro Falcato wrote:
> On Wed, Sep 23, 2026 at 06:45:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> > It only makes sense to manipulate VMA fields if a new VMA was allocated,
> > rather than merged.
> >
> > VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> > keeps its own, which is also what the legacy f_op->mmap path does since it
> > never touches an existing VMA.
> >
> > Currently, these fields will get overwritten by whatever state is
> > established in the mmap_prepare hook, and if the VMA was merged,
> > vm_ops->mapped will not have been called, so this could destructively clear
> > existing state without replacing it with anything valid.
> >
> > There is an implicit requirement that vm_private_data and vm_ops are
> > fungible across VMAs which means that losing the 'new' state is
> > fine.
>
> Hmm, can you explain how this is safe? I was wondering if _any_ kind of
> mismatch should be a WARN_ON (sounds like something odd is happening if
> they don't match). But if the new state is practically discardable, that
> doesn't make sense.

I mean this is asking me to defend how the kernel has worked forever :) don't
make me responsible for that...

For the VAST majority of cases, vm_ops is static. So they WILL be identical.

shmem does something really stupid with that which it shouldn't do (vary the
vm_ops on whether the file is unlinked or not), and maybe that needs a follow
up.

But anyway, one thing that saves us from a lot of this crap is that the majority
of things that store meaningful state there are non-mergeable,
i.e. VMA_PFNMAP_BIT, et al.

Of those that remain, the state is very often simply forwarding file state,
like:

	vma->vm_private_data = file->private_data;

At which point you already have equality.

Even if shared file state things might be tied to VMAs, but that should always
come out in the wash.

If you, for instance, stored the number of mappings there as a reference count (I
think fairly typical) then you automatically get the correct number because
vm_ops->close() will be called on a fully merged VMA (but not a partially merged
one which is correct).

Typical usage for legacy hook is mmap -> set refcount 1, open refcount++
(e.g. on split), close refcount--.

The mmap_prepare equivalent for that is vm_ops->mapped set refcount 1 (you
mustn't set state like that in mmap_prepare), and open/close as usual.

Another thing here is the idea that vm_private_data is ephemeral state _tied to
the VMA_.

It is already the case that that state will not be updated on expand/shrink of a
VMA, and so it is the case that if the VMA is unmapped for any reason the state
disappears.

So this ephemeral quality extends, by convention, to not impacting merge.

Anyway, I sent that 40 patch series (sorry for the size) in large part to
_strengthen_ assumptions about mmap_prepare (and, via legacy, mmap) hook
behaviour.

In general part of the mmap_prepare project is to allow us to get rid of
vagueries of the past and be able to make strong assumptions about behaviour.

So in the same vein, I'll do an audit of the codebase to make sure nothing
relies on this.

It might be interesting as well to audit what this data is actually set
to.

Maybe it makes sense to enforce that vm_private_data is always set to file
private dataa?

But that then implies that the VMA private data is unnecessary.

I do think requiring equivalent vm_ops might be a good thing to change, and
then to at least document the fact that vm_private_data is ephemeral like
this on merge.

Let me investigate how they're used and I can figure out how to improve
things.

>
> --
> Pedro

--
Cheers, Lorenzo

