Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C42D9108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6E86B0005; Fri, 20 Mar 2026 06:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACC16B0088; Fri, 20 Mar 2026 06:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BED6B0089; Fri, 20 Mar 2026 06:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18C4B6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:34:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA1BB877DD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:34:35 +0000 (UTC)
X-FDA: 84566082510.04.0DC41C5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94B02A000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:34:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GBuIK9cz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7eFXcray;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GBuIK9cz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7eFXcray;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rr2HH/mXE4DtnCZAC40NI/g1eA8b/90QNz+3aga+2w=;
	b=uM+YipGmUhdRv3aBUxPlCOOOHMhYErHIzOMl3x7rrmGRlKyvHp9vdDxXQETyNnT7KDXQAF
	mDd4IcVN/YrSFUorUexFvnZBMUo7MzYy9a3Vr9qxN91Rnet0Mso2+PcIhq4JwVT2Zs0Nix
	cYLssiSkGeGcNx5Ad/eYhaSv7NCohhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002874; a=rsa-sha256;
	cv=none;
	b=N8T0pjmKLhcY+g/S0FJrrLPakq8FcQY/5D+lzLt32fCXL/0C4TlEOVwVXW+dmSmbIaBogR
	UGszXu2yapj6oFiD1tfe8Pj9scGVFnD4APomrVEwaFWSKBt1tRgmksjtDUvWRRk0+xVzbp
	SdYNIJVDgJbPahIz/wrrvAPWi1yyrEg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GBuIK9cz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7eFXcray;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GBuIK9cz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7eFXcray;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B4735BD59;
	Fri, 20 Mar 2026 10:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774002872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rr2HH/mXE4DtnCZAC40NI/g1eA8b/90QNz+3aga+2w=;
	b=GBuIK9cztp1dRLblIPpDNC7s3RBVSzaFGUq6KZVYGNkVncFzaDh8B4BwcD2OhLZKRGYU8L
	7374JZUzVmPLsjPUaSTWB9rXaODR5QU1NQjuLG2WqGKMJ3SrLU3NmUDYM/ME0qXUE3V9Qf
	/YJvzifmGMwnT52Ktm/1v3gLJJtg5fU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774002872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rr2HH/mXE4DtnCZAC40NI/g1eA8b/90QNz+3aga+2w=;
	b=7eFXcrayp40rPL3qaMzpQYB1VuyfTv8Qer6KbV4V00vrvYQCrMIkBWUe9WjhrrDJ9hfTUB
	D+K3SJvotwurwBCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774002872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rr2HH/mXE4DtnCZAC40NI/g1eA8b/90QNz+3aga+2w=;
	b=GBuIK9cztp1dRLblIPpDNC7s3RBVSzaFGUq6KZVYGNkVncFzaDh8B4BwcD2OhLZKRGYU8L
	7374JZUzVmPLsjPUaSTWB9rXaODR5QU1NQjuLG2WqGKMJ3SrLU3NmUDYM/ME0qXUE3V9Qf
	/YJvzifmGMwnT52Ktm/1v3gLJJtg5fU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774002872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rr2HH/mXE4DtnCZAC40NI/g1eA8b/90QNz+3aga+2w=;
	b=7eFXcrayp40rPL3qaMzpQYB1VuyfTv8Qer6KbV4V00vrvYQCrMIkBWUe9WjhrrDJ9hfTUB
	D+K3SJvotwurwBCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D0A64273B;
	Fri, 20 Mar 2026 10:34:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ArxrC7civWngRAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Mar 2026 10:34:31 +0000
Date: Fri, 20 Mar 2026 10:34:29 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <7rr3jgdcjiizwzfivhrcqdacq5bt6hschv2isnfsmrqpuhr4c7@vbmtp5qtbs7x>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94B02A000B
X-Stat-Signature: 34a6mf9cqkgkc7iiagcb4h8mz6mgwkmn
X-Rspam-User: 
X-HE-Tag: 1774002873-140992
X-HE-Meta: U2FsdGVkX18FWUc/wl0R8kzPVSh5pIJWvQ6VK+OMP9lB63O8X4NngS+H/fqDIW86Un1Bj4rP8hJylufYs0SmXGubpaJb5NDF/QjWhDHmSBz272xW3YzQd5Jq3kStR7plTiQZPbT/0DODeTTvnVgP8ImuJp7sOzR/VF8necndZPoDmRP+cj3ZYtBwfA0HgujV7K/x9R4iYnInrXdu9M8B7Rq3XPS7c0rTX6YA5/JeqjdZLc+GZPpa9LDBOcKvinEHKsilF7bzJNTeTBFCUqKQaE4tG4ebK+TQFREHZVGkiGI+mu/8sJK5DKE5l/g8dLGCcovBX675AT4nwh87LTsy4OUeLj6eUKsvUhdpfp6whWCHnvYTRcLWtwD9ZICGOYdpFt3zp+vCkYsmkCYApzQGcVibIC1md1DZBcB84797bWbWLj0P9j5ad45N5kjdJfV74WCtLlfJjvQe42wQI7pfQVI54WJ+e2dRczut0ErEuGpdPYWdECUl8p+0Y7Pva6HALb+f3M5IWRp4tY6frHWGavmJCbwDXeo5+8vNPsZz0zXUVXbW+MnZNdRIJhXEozTYxOzy86XsoUeuALG2pYxAXLG4xFVIge3/V9Vx2/jh3K1Pmu0k6ZfxnOB2KaJrnNWcXKX3pH/Q/VjMe7tfqr3Z+JB2QWWSvz9gIzsKigWN52ifpoXgcNFQWgvnEfYTRMfY+zPsHFWBjBBEENLJ1lyr6SApAbKZrF/HoiUbLmO5ZmxMWxDETWmUVk4IdBlMubgRGTD7apgoHLIU5IB9FR3ro1W5sAgWuvBdOjmy2hwpO6667z+GAdBft3WVWR11Zx50pQIj2IjQ4VMhEDDEA0PSspF4Y/uJrZLZPYz/PuPWljZOavNLa8JHr7r22TUo6hASKJjSh+OqxIBD8OOlXelqS76QFyAJ7anEGAD1ex1/VR/0duEOR61ZA2EQcW4UdrdXtpt7x3vzdZrVoOeLATe
 HvhRNMO8
 p+WyBHOY+03fLmtJ3ZnDlFMqc4ydaZR4dXR0LPE4awv4ONjv+lk+DDdcfzaHJzRffu9OsKnAfYONiblbawSlmD5EaL3F+UOJ7x2FfLibNWveTbTjiCpXCTLhafzLx8FV13elBdm42KPBjbaWwYhZWfUtjdxCeW2wZsQmXCjU9G0li7JvRf3whR+N08PHvQqo+/QYQG0SbAjEyU7vnS0/GHaqlwqeRkLZKcwRwWbEgAKKSqAIeWxLG6CYwJ+hUCUXJZV2GZqM1b7DrFfuD+NsMEGzD/H4r2p4EdLDM/duKueTMviiZdrI9nSygDHgrPPPlpFIJPIhqIPDpUcTQRpiJHBRYg+pp8tOLyWpX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 07:14:38PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 06:31:07PM +0000, Pedro Falcato wrote:
> > Hoist some previous, important to be inlined checks to the main loop
> > and noinline the entirety of folio_pte_batch_flags(). The loop itself is
> > quite large and whether it is inlined or not should not matter, as we
> > are ideally dealing with larger orders.
> >
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  mm/mprotect.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 8d4fa38a8a26..aa845f5bf14d 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -103,16 +103,9 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
> >  	return can_change_shared_pte_writable(vma, pte);
> >  }
> >
> > -static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> > +static noinline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> 
> Hmm I'm iffy about noinline-ing a 1 line function now?

Well, it's a 1 line function that itself (probably) has an inlined
folio_pte_batch_flags() with a bunch of inlined functions, calls, etc. But yes, I
see your point.

> 
> And now yu're noinlining something that contains an inline (but not guaranteed
> to be function, it's a bit strange overall?
> 
> >  				    pte_t pte, int max_nr_ptes, fpb_t flags)
> >  {
> > -	/* No underlying folio, so cannot batch */
> > -	if (!folio)
> > -		return 1;
> > -
> > -	if (!folio_test_large(folio))
> > -		return 1;
> > -
> >  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
> >  }
> >
> > @@ -333,7 +326,12 @@ static long change_pte_range(struct mmu_gather *tlb,
> >  				continue;
> >  			}
> >
> 
> ^^^ up here is a mprotect_folio_pte_batch() invocation for the prot_numa case,
> which now won't be doing:

Yep, this is a bug (that sashiko also caught!)

> 
> 	if (!folio)
> 		return 1;
> 
> 	if (!folio_test_large(folio))
> 		return 1;
> 
> At all, so isn't that potentially a pessimisation in itself?
> 
> 
> > -			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> > +			/* No underlying folio (or not large), so cannot batch */
> > +			if (likely(!folio || !folio_test_large(folio)))
> 
> We actually sure of this likely()? Is there data to support it? Am not a fan of
> using likely()/unlikey() without something to back it.

I did a small little test yesterday with bpftrace + a kernel build +
filemap_get_folio. I got a staggering majority of order-0 folios, with some
smaller folios spread out across a bunch of orders (up to 8, iirc). Of course
I'm on x86 so I don't have mTHP, etc enabled, so those will all be order-0 or
PMD_ORDER folios (which we won't see here).

> 
> > +				nr_ptes = 1;
> > +			else
> > +				nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> > +					  max_nr_ptes, flags);
> 
> It's also pretty gross to throw this out into a massive function.
> 
> >
> >  			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> >  			ptent = pte_modify(oldpte, newprot);
> > --
> > 2.53.0
> >
> 
> This is all seems VERY delicate, and subject to somebody else coming along and
> breaking it/causing some of these noinline/__always_inline invocations to make
> things far worse.

Who told you optimization isn't delicate?!

> 
> I also reserve the right to seriously rework this pile of crap software.
> 
> I'd rather we try to find less fragile ways to optimise!

But yes, I understand your point. Hm. I'll need to think about this some more.
There's nothing I would love more than to simply slap a

if (pte_batch_hint(ptep, pte) == 1)
	nr_ptes = 1;

on !contpte archs. I don't see where most of the wins for those architectures
would exist, but apparently they do. Confusing :/

> 
> Maybe there's some steps that are bigger wins than others?

Definitely :) So yeah I'll probably be dropping this patch, or at least
reworking this one a good bit.

-- 
Pedro

