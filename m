Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8D6CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559A46B008C; Fri, 19 Jun 2026 08:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3766B0092; Fri, 19 Jun 2026 08:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA766B0093; Fri, 19 Jun 2026 08:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10AF16B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:43:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 760E61A0421
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:43:22 +0000 (UTC)
X-FDA: 84896627844.17.BF07AC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C909920005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:43:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X4LFkCu+;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781873000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdAH1fg1BglGsXnpOa+ztXQ4TCh8zWq536kA12FE2bI=;
	b=R4bAb+vgfdDNUlURPTa8J/KqwG7HTMkQ2vTOlFwnG0HNg3ADbHoD856kkuMyEKPCw3SXLA
	zLI14Deh9WdbTU9RJPc+6kRTQbV912VH7wVD6fMXDqb+vEQkAqvQuzTd+WpRonwMEziKeh
	JwRt8DsIYo1tLcreOpvWCipxTAO/a1E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X4LFkCu+;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781873000;
	b=b+6j3fk41EyP24XB4NZTryKuWPgxWxOnSDDv1ztLBaD1EpEZoMNRm+G0atnrBycT82HRA3
	+z+upGT0PMoaUt17lAyU/n1NWqgZD9rZpZk0nYMUekqWDxbGpXNWsp9KDplVfDBYgwvOxC
	9no/RxIq6B22o6RbExwpsehaTJ2opcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 382F3601E1;
	Fri, 19 Jun 2026 12:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D870E1F000E9;
	Fri, 19 Jun 2026 12:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781872999;
	bh=pdAH1fg1BglGsXnpOa+ztXQ4TCh8zWq536kA12FE2bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X4LFkCu+98rUfmehrCuzIs0/gz4ZMmxlORSl0FJdpY6wV5/1bsHrc0WX3mrxNsoAj
	 qfvv8Nm+wGR4cLIzevGd2DnrPIcqijICAMKcgH3CgSpASKOcZO7HZcHvP6XJItdzEl
	 k8FGDNBZ8o0wsFT7RHUGbtn0gBv7UCDMyByNIHCMH0NlivH8vzG0/2Mel9SJD9lzgp
	 UHuAwurPDISTUNaTVJ21Gu0MtBD15tagHmsQeriDTCjmHefT56YcNGzfyg6/R00KlW
	 D130egq/iTqaelaubtVD5CcnOuvCZqxxx6CxSc7CNv2bJNkXh7FDnvx5xkFw5re6/P
	 cx7E65uQnly8A==
Date: Fri, 19 Jun 2026 13:43:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
Message-ID: <ajU3q1e6mpWsJ6Xa@lucifer>
References: <20260616190300.1509639-1-riel@surriel.com>
 <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
 <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
 <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C909920005
X-Stat-Signature: 7ex9eexzii18rpkd4pf3a518sq5h7hgx
X-Rspam-User: 
X-HE-Tag: 1781873000-764025
X-HE-Meta: U2FsdGVkX19N64GdsCOACbfRn73hZVJY8RzGgcg/jzS4aWJB8KIVNaQzIG6NyTLvZxiU1LZnwuVzGAUyLgTKRcIttZkAecXLhOIjBwF9KgHMpRHkqh7ZxnQC4AwLdXR+H/w+j7CIJb8McGkjGT3LhGERYoR7AXzTPZPXxWuYkGmTD0IkAVqwnBLXxNnHhVA0D37gp7+JwSGSxXID2K1J8+tK5sXCcNcZsaZzOZccIwxwKpturYq0DwMOHgWpGOJmvAFdoXbU1hiKh7shP7IlAh3kygaDW0geZa5rnRFyMvgglE7Qdn5MzHCJPyhW4u3F9yz05AbwHdpIzH3ftbSSClFpBK7msipMzkmkx172O2RJ6pzPZr0SXvg+5LkpDiQYXXTsTNx4ougMN1Akr2+6rScZaavm8c3hl3tKP+RgGuR2fAb1Pp7vhB40B3XDE6RakSbcqkx9Co0MO7FB6NFrHsTXX0J/f4eRY20PAsudLMuCG9Ggb0ovZ31knq2QGJc6eSLRUhni2+Aq+SoUdybfMnz9Tct2Gjwz6qZhD+wtvI+S1Alt4qU/LXoFDSyMOYnzirT7lkQRBX8W+ltgNi8d6SZrg2Dvul7MUFeDQqq1EyLVEjpcIbJ5UrpajYm+ik1/N2gaAIMsuJOBiaCiZbeTAEphdJII9oJqlN3sq9YEoNbcHC9UjYWcpRMq9K+B+WT9HVJZc1Et4YSIPxL+3QM0+n9ND4hMFlyXbjZnG5coZe+/IYvtorHOcQ27/W1n/xQN34hKnE9+gmtEBBCcT1lSHDUImG/3bEfkhVnahu4f+FzypUfIlgpVyONxBXIHsEAnSn7nMDjBclzNo9dyhalQLxXi9BvHpW59064wPFTEzs4GwkjFmrVSPlvRhfPqO0MXxTzk8BKho5edz5XR7I+ehiwyBzWc7BwAS/j0bO6wamtvHZusnmufuxof3I5g3XwjsDHZoqoDGPIimx5Gv/E
 LxKQVXXf
 w2VXbJJi9ay02ZTWMWcOiSV2fGvxXJwrhubOpaItQ0LP9JEziDnwD0uZ76drCz/gAOtlJq6rxcNaaYZagY6QXJxHnK2mBq9QcxX3p8HSspzFtlMqHKj+86FFHxlYaKkqV2LNi3lStA9w2HWU1N//1l+etzSlb2i3cSQlzptSDL4IER0IYaEHqRcAUAkuX5kWe2gRUgt67DfAbwC4RzofJS5sZDkIux3G7g62ffU88kgfIICMsTNOdfCWsxlJ6JNXsQgGXC0tEzwvPBK/h62IVOmM4CQg76cnm6PeUSF5E+EVb/RkC3tUoI2/LuOzeD0EFKDr3hEZuPXqmsbc+ekBUDikusq8gC1b744Rw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:37:03PM +0200, David Hildenbrand (Arm) wrote:
> On 6/17/26 15:33, Suren Baghdasaryan wrote:
> > On Wed, Jun 17, 2026 at 2:42 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 6/17/26 03:10, Suren Baghdasaryan wrote:
> >>>
> >>> Thanks for the patchset Rik!
> >>> Previously when I looked into using per-VMA locks in
> >>> access_remote_vm(), the biggest hurdle was get_user_pages_remote(),
> >>> which required mmap_lock. Your implementation avoids altogether and
> >>> keeps the code much simpler than what I expected.
> >>
> >> But, wouldn't we, in general, also want to teach GUP to just work with per-VMA
> >> locks?
> >
> > Matthew suggested using gup_fast in access_remote_vm before, and I
> > looked into that. The biggest issue there is that gup_fast assumes it
> > always operates on current->mm, not on the remote one. Reworking that
> > is quite an undertaking.
>
> Right, that's more tricky, IIRC the CPU from a remote MM might not get an IPI
> sent to sync. (but my memory is fuzzy on that)
>
> > Teaching GUP in general to work with per-VMA locks I think would also
> > be much harder than what this patchset does and would require a GUP
> > expert (which I am unfortunately not).
>
> Well, "harder" is not really an excuse ;)

Agreed.

We shouldn't just tack on new features like this without improving what already
exists.

Really a series that adds a new feature should have patches that first clean
things up to lay the foundations.

I think we've been a bit too permissive of 'just add more code' series in mm in
general when we know the ground around it is already shakey.

We all need to do our part in improving the codebase.

>
> Where a folio_walk really shines at is that you can just walk a PMD entry and
> process it all at once, instead of returning 512. Where it doesn't shine is that
> you have to walk the complete page table again for each individual PTE.
>
> ... which is also what we do right now through get_user_page_vma_remote(), which
> is rather suboptimal.
>
> Ideally, you'd obtain multiple page ranges (with upper limit on the ranges) in
> one shot, whereby each page range belongs to the same compound page, and there
> is exactly one page/folio ref on a range. [we discussed that in other context
> recently]
>
> Then, you can just let GUP do the GUP work, without re-implementing it for some
> special cases elsewhere. And others can benefit from the work.
>
>
> So I'd really like us to find out what it would take to teach ordinary GUP (or
> better, some new GUP interface) to run under the VMA lock. We can start with the
> existing interface to GUP a single page to KIS.
>
> Maybe having a new GUP interface that consumes a VMA instead of an MM could be
> the first start to enable per-VMA locks?
>
> All GUP does is walk page tables and call fault handlers. userfaultfd is nasty,
> but existing page faults must also deal with that having to fallback to the MM
> lock, so it sounds like a solvable problem with some churn?

Well I think a critical problem here, as pointed out by Suren, is that holding a
VMA lock means that the VMAs around you can change and in ways that are quite
problematic.

E.g. The moment you drop the VMA lock that VMA might get freed and then merged
with something else, and the next VMA you consume is the same one you just
partially walked, for instance.

Now perhaps you could reason your way around this, but I'm pretty sure there are
cases where you might actually miss VMAs due to races (Suren knows best).

And also without an mmap lock people can unmap and map new VMAs in the range as
you go through which might cause weirdness as well.

Really, unless you are dealing with a single VMA in the range, I suspect GUP
needs to stabilise that whole range.

If we could find a way to have GUP fast-path the single VMA case sensibly, then
that's probably workable?

And I agree special-casing only one place but not others sucks.

Perhaps we could find a way to get this improvement without it being quite so
'tacked on' but without needing significant rework of GUP, but in either case I
broadly agree we need to improve the codebase as part of the changes.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

