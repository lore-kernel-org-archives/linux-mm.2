Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7512C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2BD6B00B5; Tue, 25 Aug 2026 06:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83886B00B7; Tue, 25 Aug 2026 06:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99EB6B00B6; Tue, 25 Aug 2026 06:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 948816B00C5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:44:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D6751A039D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:44:39 +0000 (UTC)
X-FDA: 85139458278.21.0EE6386
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7937918000F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:44:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MnbPkSUg;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654677;
	b=p+36LHue6p6LFdpNoT+pG46xBJR0o75mrlCioGM/Eslo22b8xJqU/g89BYR9o20c7UQ0YJ
	25K135pYn6FnFX9gPPJ88QsVf40Wfrf66rNBqZMP8qP0YsWUV9LSjIHlkEDwnAYDlikLU0
	SAxUkyXj2slPPL/px7Xpfj483XGTJpg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MnbPkSUg;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdMg1fd/nLmt54Fd6YaLbChI//Uem2/WNbMOl8JDKdA=;
	b=qVpE58OWyxOuVh6r7i+fWRrA388fJPGRmoaUvbqMtrGaiQF7YwLA7WxM7IeJVPCnDZREMY
	2twsbL6Q0rWZmZCnBBsWLLW6irPgeDWIMINe4H+JmrkvXXayQOzowvbPrqlXA7ja357y07
	y+bzkAXHIfGr0DXtOpJgh3w1EvNOiXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6624419BF;
	Tue, 25 Aug 2026 10:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784FE1F000E9;
	Tue, 25 Aug 2026 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787654676;
	bh=AdMg1fd/nLmt54Fd6YaLbChI//Uem2/WNbMOl8JDKdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MnbPkSUgtNYDc5Btnke6OSE5T/lysSA0MMRliw5RkFFRI9xTVDdyA+Jj00+qTNZOu
	 SEEoXy5myd9kgbC4XO+jZyGtBwnMpH0J+EHpiDOh1gnN0PUTzPZO9DB1/f1IQopk8A
	 2dZWHgpzD21uwffcQ/fVfWBL+HxLdKv+SzQaJvCLufKrYkcBILTl+7lCeyl+IC2SGp
	 +o4cC1/w5ryYqFF+Fd/c0FGFJKryPdKTxTXj3Py+QiykBmck3uJoY5cSg0G+iTRspX
	 G8/p7fhngiSdd6x7GRfSIYM8Ll2YkJGcgjzPfLUajHSP41pLs/eHh+xIgAxS+fxQKF
	 sE1v9i2GBULlQ==
Date: Tue, 25 Aug 2026 11:44:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Artem Lytkin <iprintercanon@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>, 
	Carlos Llamas <cmllamas@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Deborah Brouwer <deborah.brouwer@collabora.com>, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rust_binder: check ownership before using vma
Message-ID: <ao1KrhWs7m1aTy0l@gremlin>
References: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
 <20260824194808.216021-1-iprintercanon@gmail.com>
 <ao1E_6yo9hE17e2E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao1E_6yo9hE17e2E@google.com>
X-Rspamd-Queue-Id: 7937918000F
X-Rspam-User: 
X-Stat-Signature: asn51idfd4j3j5ad4oo5wn6zbynuff4p
X-Rspamd-Server: rspam06
X-HE-Tag: 1787654677-718618
X-HE-Meta: U2FsdGVkX1+TKD6Y9K8WRVChAHTG8ODGWCtcT4Asj6g+Zv9flj/stUz7y9NdQoBqhz0dWIKIYWf78xSJUgbgAEtp/x4N2czVkXoZKYD5ZI8b1ZXxsV9DCGmWrDHXEr9xV0EOXmPcneG1JlvI+PuKXl+KHl4U5NwUpAvu2Xj+fnM7l6MMtKnnoSG1ZrCbTXsIDj/OCeoxYqimEADh7agbXvAmyYIRFTgIyCokYWrPqoCj9XUxfULx4DCEFDi4cS0icY5P1UMfAEASTbSmlN/BX9wN9szoeHMGArPi0kGBX+Tv1EhZ5zVZPCOnmAzp04Izh6UK1yTguvmT1ie4y6EhChxIRaoEQ4Fhy+uSXJBtQTzZ2Yp4Y6a/RUYT15vfIRAZrsuiTUOk2zMkHJWUUrog/lKa/TZQNOq6BTS8C/DVFROaK5y7sfrhe5/9rCEW82Z2NwVAgWEopFIL+AX0LlVUV4k7ZgXqpLxCGZrfWXKkmGDM/d0pbZHMy9Jh0VX9OBV165jUqzUKxjKQMxlJObtU4FahTu+PPhdawpDxZgJxuGHcna5H8M4OtC/6V7OHVsU8IFtMkuEKjX2i9JEXBtckbfAw0zGLknOnf1i41Eb+TSP+/W8KaI+y9nWj28bKYtXgsRWOg5p73HXHACzXaUU71+hwfvzcoyVZA89+GyIdhirYR3xjs3LtuPAfMifJi4ZgCQTiWGRzbdw0UCpe6JzQkEsj44dQNYg74LB+u4Daztaaf+YrBAXgtpsfUqNopS24PkbTF7ClkOH0TnXd541ofXRrEpSVw4dvDF0iBWgbmfI5cZx3fDrvutq0qdpPrf/lvTKT8K8EJ6wPXM+OCD77mynwNSnzkc6s7dEefLl9YQFuqlMB4bD6BMOdIgdTr9xpIEJiozGTOZ6yjJ44a/ThfS32zsNNjaIzMatu++7uGBRnHI+irpbDKuSBsGzhbgxPLq6nwjLF6NiROwabMv9
 aef2+AfG
 qiPuU1ZBJuJdAmb2nzLRTZAy1PFyduXlAX/CNvs+y7I9qOrxKlY2X8L/gemDxPu8tEVIP4UQ8LfZ9HEDBO5zAetlLW0GLDGHT+l7l5aoob6EyjFdK/ge475yODir8SJYUzVAutY3bHGlStgDFlDuYPiV93YogRyv/J9ZcuV3+r0sYmBzSBKJRJKtUddN/38iqAEMKm4A1VWUxmSFwH6TBWT4iJ3Td/j1tnME9AoGurvTYJk/MliIujuNZmcJ2eBmfsiudSAhc1HoU5Uza0LXFI2qcjjT59ecwUK8+U7/ZIRFKfh0j52ELcLcFc0ttlmLpq2OFi6Bi5NzeQy58Wy+UPRG35I1iUWcPvzgBGMHRlltJNLfJNE3/8FGDeZx0N2vRh1i6d3K/hvKmyyNee7Eyo3C/njv4dSm6lzwO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 07:32:15AM +0000, Alice Ryhl wrote:
> On Mon, Aug 24, 2026 at 10:48:08PM +0300, Artem Lytkin wrote:
> > On Wed, Feb 18, 2026, Alice Ryhl wrote:
> > > The plan is to introduce more vma
> > > abstractions to avoid this unsafe access to vm_ops and vm_private_data,
> > > but for now let's start with the simplest possible fix.
> > [...]
> > > (We probably still want to do both, but
> > > the vm_ops->close callback will be added later as part of the follow-up
> > > vma API changes.)
> >
> > Alice, is that follow-up still on your list, or would you rather someone
> > else took it?
> >
> > I'd like to add the missing pieces to kernel::mm::virt: a VmOperations
> > trait with open, close and fault, a typed way to install it together
> > with the private data on a VmaNew, a VmFault wrapper, and a PFN-map
> > typestate next to VmaMixedMap with vmf_insert_pfn_prot() on it. Binder
> > would then drop BINDER_VM_OPS and the raw vm_ops pointer compare and get
> > a close callback like the C driver has. Tyr needs the fault and PFN-map
> > half of that for its user MMIO mmap. The first two patches of
> > Collabora's Tyr series are the pgprot_noncached and pgoff helpers; they
> > have had no replies since 7 May, so I'd build on those rather than
> > duplicate them:
> >
> >   https://lore.kernel.org/all/20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com/
>
> I have a draft for the vm_open callback somewhere and it's still on my
> todo-list, but I'm not actively working on it right now. I'd be happy to
> let someone else work on it, but it's somewhat nontrivial, so perhaps we
> should have a call to discuss the design to work out the details?
>
> > One design question first, for you and Lorenzo. f_op->mmap is
> > deprecated in favour of mmap_prepare, where a driver sets desc->vm_ops
> > instead of touching the vma, and the Rust side only has the old mmap
> > path today. Should the vm_ops abstraction be built around mmap_prepare
> > from the start, with a Rust mmap_prepare hook for miscdevice next to
> > it, or is landing it on the existing VmaNew an acceptable first step?
>
> Lorenzo, where can I learn more about this new mmap_prepare API? What
> are the main differences?

Luckily I wrote up a guide at
https://docs.kernel.org/filesystems/mmap_prepare.html which should be helpful in
general! :)

The TL;DR of mmap_prepare is that the mmap hook is problematic because it gives
a driver access to a vma with much state that it shouldn't touch and it does so
at a point before the VMA is mapped into the maple tree (or locked) but after
merge attempts and quite far into the mapping process making failure teardown
problematic.

mmap_prepare fixes this by:

a. running right at the start of the mapping operation
b. getting a pointer to a descriptor whose fields you update to affect changes
   you need
c. being able to do actions such as ioremap, etc. by setting state in the same
   descriptor, in C abstracted by helper functions.

It's idempotent in general - if you need to set state like a refcount or similar
you should do it elsewhere (the VMA might get merged or an error might occur so
it's not the right place to do iit).

In implementation:

In general, looking at the file_operations struct in include/linux/fs.h:

struct file_operations {
	...
	int (*mmap) (struct file *, struct vm_area_struct *);
	...
	int (*mmap_prepare)(struct vm_area_desc *);
};

(file->f_op)

struct vm_operations_struct {
	/**
	 * @mapped: Called when the VMA is first mapped in the MM. Not called if
	 * the new VMA is merged with an adjacent VMA.
	 *
	 * The @vm_private_data field is an output field allowing the user to
	 * modify vma->vm_private_data as necessary.
	 *
	 * ONLY valid if set from f_op->mmap_prepare. Will result in an error if
	 * set from f_op->mmap.
	 *
	 * Returns %0 on success, or an error otherwise. On error, the VMA will
	 * be unmapped.
	 *
	 * Context: User context.  May sleep.  Caller holds mmap_lock.
	 */
	int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgoff,
		      const struct file *file, void **vm_private_data);
};

(vma->vm_ops)

Basically instead of getting a VMA you get a struct vm_area_desc:

struct vm_area_desc {
	/* Immutable state. */
	struct mm_struct *mm;
	struct file *file; /* May vary from vm_file in stacked callers. */
	unsigned long start;
	unsigned long end;

	/* Mutable fields. Populated with initial state. */
	pgoff_t pgoff;
	struct file *vm_file;
	vma_flags_t vma_flags;
	pgprot_t page_prot;

	/* Write-only fields. */
	const struct vm_operations_struct *vm_ops;
	void *private_data;

	/* Take further action? */
	struct mmap_action action;
};


You get given a pointer to this on the stack, you read what you need to and then
update mutable/write-only fields (the guide goes into detail on that).

If you want to take actions such as ioremap etc. there are helper inlines for
that in mm.h, e.g. mmap_action_remap_full() (you'd possibly have to port these
to rust) which makes doing a PFN remap really easy, e.g.:

	mmap_action_remap_full(desc, desc->pgoff);

This sets state in the descriptor that tells the kernel to go do this work
itself (a nice byproduct of this is that any buggy stuff drivers did is now
replaced with one code path).

The VMA mapped callback can be used to set state in vma->vm_private_data (you
are given a pointer to a void *vm_private_data on the stack which is assigned to
the VMA afterwards to avoid any driver container_of() abuse :)

BTW if you're going to LPC this year happy to chat in person about it if that'd
be helpful!

>
> Alice

--
Cheers, Lorenzo

