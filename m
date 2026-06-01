Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F59CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F1D6B02A2; Mon,  1 Jun 2026 03:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0501B6B02A3; Mon,  1 Jun 2026 03:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8176B02A4; Mon,  1 Jun 2026 03:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA4B86B02A2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:42:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 897211A04EE
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:42:59 +0000 (UTC)
X-FDA: 84830552478.15.61F1AAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB6FDC0007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:42:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJ1pWFC1;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780299777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6E/427vKjNMrNFnfzJ5w/oioAQsHShjLOWHUrX6Zb8=;
	b=kV1B4S5z8AayBzZQ4agIC4NeU5JM8zkvJ0DH+Cm0brhZIuXl7FD/Wp2To/iZ4pt+C4JCpF
	13AGqbDHaMLr9TyGMwYLTv8Qle63fDHR2LVcCP4RJckpV2f/KgyfkN9GNDXFJwHXwsEQcr
	YEVM3SdLvXw88hRoboqRf3Y7i2rpXR0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJ1pWFC1;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780299777; a=rsa-sha256;
	cv=none;
	b=Tl+yWIqMxG7eZw3r4VfKUWgmvKSW+7PENdw0T8x0wuxYYgUHyBgo6ob9VpUvMixKrICUKA
	09egKYyEnSAtAVTtux7wGe7lZWKNTy2NiqyHEvEvxpsmS7BbMBObA4L2DNWjIqWHnioAA3
	XQ4QGhxrow7SIyA+pPr6DRzf94JADlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62EE660018;
	Mon,  1 Jun 2026 07:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342CD1F00893;
	Mon,  1 Jun 2026 07:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780299777;
	bh=G6E/427vKjNMrNFnfzJ5w/oioAQsHShjLOWHUrX6Zb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RJ1pWFC19TPXp/omPArHxv5x2qOq16KOXdKlqOHHweNUSE0B0kXCuHNmYIa29VeAv
	 x1xukkrYT0vEFqTjKybI9CMv+G5k3YQfnYB7JlHdtGpKnzVF72J3cklM5PUgBuWYPT
	 Zb85JfREbCwhnT+mX5TVtU5r6x789OLRNYsvMsTkvBSMq9BEmXMyFMwfSMfWkTM+YD
	 zJfWmnK/xP4OSww3ENvvdeuDgg8mYVJjxGxRuRKS8rHEcyubNuUc6uwlcM8SfIhTRP
	 fN0lzfo7D0m4HnqdibY2CcGk5s9ocXceGp/B64TNx44+GE5hErGZbYDwEUb79kCi5M
	 xO2iV1myeeJyw==
Date: Mon, 1 Jun 2026 08:42:48 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	peterx@redhat.com, david@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ah03yn_FLO_ca6eE@lucifer>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
 <ahmQvfNk7S4F0LBj@lucifer>
 <ahsVyQZ5UXhJLct2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahsVyQZ5UXhJLct2@kernel.org>
X-Stat-Signature: weekjtiz6j1setyjjyuz5bk61yardkru
X-Rspamd-Queue-Id: EB6FDC0007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780299777-182719
X-HE-Meta: U2FsdGVkX18HMeefGDbTZOvcRXrt7rMVLGxj3+EXwP/KP4c4JQlwI7YeL/ofGb8mFCsEmt75T1ifC63QYVdQ5k+azEP7E9Tkz3b5TkxTHbDJ0fpA702A2r+iIRgpdvIK54EjJkOpCwIYs3G11WH3EgD5Ka4sBH/04Viy82tzvXpx6oAr3lFvYUpo7R4g19yv0mrCR+fTmNnfgid/xYGi2IyJMQ11kCocb4cRKb8PvVx0GynW0v4mvBslGVxPkEds1nAkOvgwSsljk4kHkVGnQsCwptz09j8KvN2P4GeLPva39F/KAL/bFPqtAQaNGC5HVUclW8uDAewH2IkR8gCuHRHhC5pCcxT6FpDsxD3OTOxqHCQul1yS0JRRQqHI77N/IFCDuQSlE4/BcvPEM/ET+W7l8G0BE0MNZRRJYrpMqKnRWp1JVI6RBHwKHANhKs+ih7TxKmA9UwTqA8/28sXf2I0assFHWccEM3Pmk2YTVwmpePTSABq9kc985VOcN+laR0rXK9ffJ/b3hQer5fw10LgkQdMZkCji1zE9txwk0v793GNgFVejd9lg3G+n+uvRojpxxCEo8GWOK7zb0V+ewzRkwbY55Fbu5e/Lu+vjvsd9Yl68Lyk31o0w70r5y4kW4sldDuMVR4ej5llg39XDvY/hSEceUsavu/gWoM9Vrhi/Y9egGpVCg3nmIGeZE4vZUO6wKB4F4/kzEI9XAtXCcmyWZN2oLv8bhlzUR6wL2Odzw1bj4o6cnwoWwfaGfK1WU00OsWN/O1+zpOXMRjD6oDDMm8zt4W05MOfuwTIzTuE3DCzFJs1DR49PO6uuHS7uphiuTwsFijq9VMbt+WoYHmsrGKNtLnAds9zpzYCYPIw/os6BFeISVFl3jPQRDwY3WZwo4e4i4+NRwu4wn1kr6/D3OsJ4Fps/75zx/0vb8ehYxyengmk9qWBvg0dz0rDGglkAk64qUY9GOVftJVl
 /oU8FFI1
 6uugXEYn0nPc45uDNtDF4GTgw59BI9RaKiRYiAONxb6qIVukLwMReY4iFmEv0woNuEps0PzSDklvBIX8DpH2ThoCQHE1CS7b0LChgmKV3y9tQwr2rN2g5Yr15OBE2uTjUKT0LlW2yHboL4CPxDFPGVyJHQNlBmFZdmcgJLzpkqGFtMho6CJcyGfZOZfZKWBbp2noJggtX35vlTyOrtKYlYEM3u56ZjIkCm28s6hBfmfmNMQBiy6zRbDd7syiSlO4ZyFnXbp68NqW0FyMA1nmvUil27sZ52mS38xbwzet78MH4f6vb3pfniXbnGJp9TakPn6Qz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 07:52:25PM +0300, Mike Rapoport wrote:
> On Fri, May 29, 2026 at 03:00:14PM +0100, Lorenzo Stoakes wrote:
> > On Tue, May 26, 2026 at 02:04:52PM +0100, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > >
> > > vma_flags_t is one unsigned long on 32-bit -- NUM_VMA_FLAG_BITS ==
> > > BITS_PER_LONG by design, so VM_xxx-declared bits sit in the first
> > > word and hit the single-long fast path. But the bit enum declares
> > > some bits unconditionally above BITS_PER_LONG (VMA_UFFD_MINOR_BIT
> > > == 41 today, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
> > > actually carries the bit).
> >
> > Yeah ugh.
> >
> > > Passing such a bit to mk_vma_flags() goes through __set_bit(41,
> > > &one_long) and writes one word past the end. The compiler folds
> > > the OOB store with wraparound (1UL << (41 % 32) == bit 9) into
> > > the first word. Bit 9 is already in __VMA_UFFD_FLAGS so the mask
> > > happens to come out right today, but any high-numbered bit whose
> >
> > That is... helpful :) but not great that this is the situation, an
> > oversight, clearly! How I hate 32-bit kernels :)
> >
> > > mod-BITS_PER_LONG position is otherwise unused would silently OR
> > > an extra bit into the mask.
> > >
> > > Add VMA_NO_BIT and have DECLARE_VMA_BIT() resolve any bitnum out
> > > of range to it. vma_flags_set_flag() drops negative bit values.
> > > The ternary collapses at compile time, the runtime check folds
> > > away when the bit is in range, and the common path is unchanged.
> >
> > Hmm are you sure it does?
> >
> > A key design goal was that mk_vma_flags() generates compile-time constants
> > the same as if the bitmap were constructed independently.
> >
> > This surely must generate code? Or at least runs a significant risk of it?
>
> ...
>
> > A simple solution that doesn't require change to the core is to just uglify
> > userfaultfd_k.h a bit with:
> >
> > #ifdef HAVE_ARCH_USERFAULTFD_MINOR
> > #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> > 				      VMA_UFFD_MINOR_BIT)
> > #else
> > #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT)
> > #endif
> >
> > But of course that becomes much more horrible with your changes...
> >
> > Another alternative, which I used for VMA_DROPPABLE is to add something
> > like this in mm.h:
> >
> > #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
> > #define VM_UFFD_MINOR	INIT_VM_FLAG(UFFD_MINOR)
> > +define VMA_UFFD_MINOR	mk_vma_flags(VMA_UFFD_MINOR_BIT)
> > #else
> > #define VM_UFFD_MINOR	VM_NONE
> > +define VMA_UFFD_MINOR	EMPTY_VMA_FLAGS
> > #endif
>
> I have a PoC of yet another alternative:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=uffd/vm-flags
>
> The idea there is to keep a single VMA flag, VMA_UFFD_BIT/VM_UFFD and move
> all the rest into what's now struct vm_userfaultfd_ctx.

*Gives Mike a big kiss*

YES PLEASE!

>
> --
> Sincerely yours,
> Mike.

Thanks, Lorenzo

