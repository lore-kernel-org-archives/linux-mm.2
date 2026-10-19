Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A918CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F646B00D6; Mon, 19 Oct 2026 08:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47306B00D8; Mon, 19 Oct 2026 08:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CD96B00DA; Mon, 19 Oct 2026 08:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765B16B00D6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:19:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 088EB1C3F85
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:19:54 +0000 (UTC)
X-FDA: 85339282308.26.3530886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 78E9480005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:19:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZZ40E/VC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792412392;
	b=M69MMxoDnZB1pQbfQ/0GNV55GmXt5yzcPCsNRA2sSrM9WA5qXur0jf0GYqs4K0ErPh+65S
	36n4Ro/0sBxjHOE/AZKMVMLgngt9l1gPWnTZdr1G0KnOTiNOblzCzMwcn2Yt8RxQxWsT4q
	o0HYRdXdCYR64JUZPhnxeI1r65mgIaU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZZ40E/VC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9hc5cIkyPezjts4c8r6cEvhiZGbSkNeXgJkba3+Ks0=;
	b=pGIIVf77YPzc6GnW9gyyTCP8m9tlkwA/qU9P9Um1+UaSjdJ0fGsSJfkRq/T+nRKFKTSBE5
	90Fp/BIpQke6M4rKQUDWnRqgmnkXC4prR0CQPWsJfTZQG+gcOTfwZYBlzsoBTCdN+HMoM1
	Wq9YompTFNy2/9tpDhLB03oC8HqdVxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E961560142;
	Mon, 19 Oct 2026 12:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0014D1F000C4;
	Mon, 19 Oct 2026 12:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412391;
	bh=Q9hc5cIkyPezjts4c8r6cEvhiZGbSkNeXgJkba3+Ks0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZZ40E/VCmFDgut286wgaCHh17UAGwN+J1SGcdJ1lynmahPLbL8fK+Vq7XLtg8A79R
	 4k+/Y8JK01Vmt2melYAgFaFLvB/EJ2FcIftKpK1wQWIB3WNUTB3GfothUMQ1Np2jlc
	 3PEU/mOIZBlGJuDf6Lc2PrgGIQrrQ/lAAZKxo9iBfbdK71hGst9X2E8TltCLqWFUMb
	 wTImVBTPBY6WmRlIHA9Ie6MYtizSsfToOxumT/vyix9yGLaC6n+gGfs4wFvpHXwIlk
	 vY15WF/wkS2EEKq7C2MKgYjGV5W6UHVsr1ckHmJ/eGUegcoyIH9hj05ZG4M+oTg46y
	 vEFzh2mwJXDUQ==
Date: Mon, 19 Oct 2026 13:19:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <atYJA7nIu_RwpoCC@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Queue-Id: 78E9480005
X-Stat-Signature: 8cicgzcb6mw6qhze64tmnj8i7nokmwaj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792412392-44217
X-HE-Meta: U2FsdGVkX18sZSpzdFMfUTKNtXWHU5VoBmbbGX6g/JQ6yHCi9B2wlyHeZqqcOGcEQHJyYRnia5r4cybrhtPJMJ0VcS8OF4rU/Y2rxDirk8uxvNQ1bGleuncJXGG7KGwALkrtDiwRs6e7K5Y+DY+J9/8/5S+fPE0jiL9x+LJ7yrLBv5RmNPSno8rQW8fcASlzoiWzQEjxdnLHA0+WbJQapBr6bb05o6msFVnpq6GHC+QwjUruX4VvywRzhYhSi4AshQMPV5bPSs1tdxJ1f0LMtAwrpan05s8Ndx7dMC5R8wF5GyGDrb6zupB1iy0unKvCqxG6BQchcOJq7xNgzLSKuR9L8hp6SI0UwI9Ymel2SzQvKR2GfWG1GLV8Gla4pwKDe3D0GfaPjOgIQZMnrcb6O/AVkMonyPIuWhFgAyoi2znAeMCfRfVZe6OSDl/+hHUl6TQ0Uq41xkmqf5q+Qk4piAKwZZfjHqYdvhLTFSDXDXvy3ttd/1/ceU3l0+EvseUK+CHwRhk0iTL3CKjRnpV2lNJi6U37rIqNmVfF2nVa2OncwVMMW5c6h9O1FRjTKX6e+akrvRLfgbvoOGLRO7KcQYhAm1NfHqVV0X8ukJq5rmMAW31SfT08gsu8kD3Yb/w2l1icrb/cD16udZR4/VLwhCZh050ycipcDcTjXXUpFFDZ+wR6A+V/qAVfWVw3E7xtbkW2mYJNFVr+NsfIxk12KWXXsQho1PS1yuHbuWsIh0E4aal709x8HgacAMcmWe510DwWKYd7NUe5SUFNzBeNjLdtdmL22FIQNFp/RZ2bZ4JDT6XgYtLloc4ZTxKS5tvkCVWWlvxlytupub0OZDS8/UEE0C/fftagZGXYJU4q3Mdn684WvelODmyutHCQ6GQL3kSl1KzbpnMoQSfM1SMU4xStYCXcNGhjb7CE1EpAGjj2YSDdWOcNnRGoVznDY93mXnILzkAUmoAMCjlxLT5
 xJ1fBbSb
 qfes2U5OvEsls3preIBmwCq8Q+zhh1ErqE7pUMTwD/31bJPZHA4ITYr/5Lx95FtGEuh+zmqr3NoXT1QeQZtMZ72Oap74FUhKs4utqVzI0IlMP/0FN2mh428B3qF6xPDl4jSKzlmAUlwhIMsYdv/PPoW4D3sJr/ayYauWaNkTbMbSit5S7gfJWiAKaOWVDKisJj+Mgwj/UDF8QK/rq+jERtmZecHPdjuARlV4Ad3y1x8YL6Vux7FinhlW9A1ll8cEzipchaDFwRNbyM5akQqphWXfH8wJyUgv4fzZyaHIjeXBZw70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 10:53:27AM +0100, Pedro Falcato wrote:
> On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:

> > So I think it's fine to just send it (early :) in the merge window.
> > ---
> > v2:
> > * Updated comment in vma_seqcount_is_write_locked() to mention the VMA
> >   being attached.
> > * Renamed reset_vma_seqcounts() to __mm_reset_vma_seqcounts().
> > * Used acquire semantics in vma_start_reads() to avoid race with reset -
> >   there is another acquire immediately after this one so it should just be
> >   noise perf-wise.
> > * Removed stable tag, will do the backports manually (just make the value
> >   64 bits...)
>
> I guess you're fitting this where __vm_anon_pgoff_lo now sits? If so, then
> this patch probably wants backporting to 7.3.

Ack.

> > +/*
> > + * Called with mmap write lock held after mm->mm_lock_seq just overflowed (and
> > + * therefore zero), with all VMA write locks now released.
> > + *
> > + * The stores below follow the smp_wmb() in do_raw_write_seqcount_end(), so
> > + * a reader that observes a reset value also observes this cycle's VMA
> > + * modifications (ordered by the ACQUIRE on vma->vm_lock_seq in
> > + * vma_start_read()).
> > + */
> > +void __mm_reset_vma_seqcounts(struct mm_struct *mm)
> > +{
> > +	struct vm_area_struct *vma;
> > +	VMA_ITERATOR(vmi, mm, 0);
> > +
> > +	mmap_assert_write_locked(mm);
> > +	VM_WARN_ON_ONCE(mm->mm_lock_seq.sequence);
> > +
> > +	/*
> > +	 * Failing to reset means stale vma->vm_lock_seq values could result in
> > +	 * those VMAs becoming spuriously write locked when mm->mm_lock_seq
> > +	 * happens to match their values.
> > +	 *
> > +	 * This is problematic, as it causes the VMA write lock to not exclude
> > +	 * readers, which can result in concurrent readers while a VMA write
> > +	 * lock is held.
> > +	 *
> > +	 * Avoid this by resetting to an even value (indicates no write lock
> > +	 * held).
> > +	 *
> > +	 * Readers will either observe zero (not write locked) or the previous
> > +	 * value, so this is safe.
> > +	 */
> > +	for_each_vma(vmi, vma)
> > +		WRITE_ONCE(vma->vm_lock_seq, 0);
>
> I'm concerned by the possible latency when doing this to many VMAs. Do you
> have any numbers?

No, somebody schloppened a patch for a real issue and I haven't the time to do
even the things I need to do let alone 'here's a new task' stuff :)

However, this is a simple write to every VMA, done at the point the mmap write
lock is held with all VMA write locks dropped.

It was implemented such that:

* No VMA write lock is taken on the VMAs.
* VMA read locks can proceed.

I.e. it amounts to a loop over VMAs and a write to a field.

I don't think you could possibly do more to reduce latency here, and you
absolutely have to update this field across the board.

Under any realistic workloads this will occur at worst ~days intervals, often
far longer, and likely you will see quite some gaps between separate processes
experiencing it.

There's also an upper bound of vm.max_map_count per-process, so it can't explode
into something truly insane.

Most processes don't have that many VMAs, other than certain steam games :) so
it's hard to imagine there really would be that much latency here.

And the latency is occurring on one thread, which is performing an mmap unlock,
so nobody sane will put that on a hot path.

--
Cheers, Lorenzo

