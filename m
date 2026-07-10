Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F7AAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5656B0005; Fri, 10 Jul 2026 14:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5FD6B0088; Fri, 10 Jul 2026 14:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD006B008A; Fri, 10 Jul 2026 14:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 450386B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:53:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C56DC12055D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:53:33 +0000 (UTC)
X-FDA: 84973765506.30.DBF4C57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34832A0010
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:53:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nDhZgh/3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783709612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWuowyvRtMvxp1pzf+XL1dPHmwjcwsc8o84lhpxUjy8=;
	b=F4JWIOztnQPh4jbxDP84pUODvUkDKm8YPyheOy5QWdxbL/GAb5+lXaWyPSFxMhVTjGvywE
	T+WRRFtlioMv+kEeVCt5Gw0XZxVYm16yOGw+hw9nZhi7OVU/rRt4fowFpjKiKLF+rD0w0x
	QXsMOOlGAxsfWV3IoKrcpX9hSZSoMWE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nDhZgh/3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783709612;
	b=N4R9GhX1A9e9PxyNLCNWIW+KG0GAIqGC9hXJKiq6GRe7IrbVb5JRXOEMrwSwJvzhQmHRSG
	8nw8B5oKmgysvTAcvS2LoJvafLi6IRUqF8sZlgz1tfV0DENbW4qdO6nN1LbGEd3SPDk9NT
	587I1pjt2Hvk86ZvFldjr+eOghmBCzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91DD96111A;
	Fri, 10 Jul 2026 18:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F03D1F000E9;
	Fri, 10 Jul 2026 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783709611;
	bh=FWuowyvRtMvxp1pzf+XL1dPHmwjcwsc8o84lhpxUjy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nDhZgh/30Is3FEvL9cBN4+RE07BsiX5vquCpx0YGR4R77YJwGw3V6vuu+e3KDwjkY
	 xE1KdGXHs8//VoP4+HeSYghjkWrTfj3sAIm9JCtQgyDY3teYqnzpEyIJNHaSF0oIap
	 wvN5ncJ+wLhH9wkOKDRjcxv7PYE2iB5UFe8d50zc6h7h1nKgGMIQ+7+fcdsx4R97uc
	 NqFcnFGQ75mp7gAitC3ITJDH/vBS/4Cwt8nq2HWkSUqk+7xDybMaCPv7LxzG+Almxt
	 Yg7Ld21F69mTc3CmDydEZ3eyW6TKnoAtL7DRpmU7B85oPUytWzAruhS3LDhFge+1Pk
	 YnLMjKx8pf/0w==
Date: Fri, 10 Jul 2026 19:53:17 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to
 avoid ptdump UAF
Message-ID: <alE6fUJZzELlUfxP@lucifer>
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
 <529e37eb-ad4c-4b0f-8ba3-c5608aa7a893@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529e37eb-ad4c-4b0f-8ba3-c5608aa7a893@intel.com>
X-Rspamd-Queue-Id: 34832A0010
X-Stat-Signature: jqs9ceqrkmmj63i6ef96gfkxzcdr93qp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783709612-277968
X-HE-Meta: U2FsdGVkX1+YkwPBamkwG/BLOlDkfz9gVjNLNF8EJom7ns0DCHI7hLlrVzsOORjOlyzwNvlttXuw+sCOVp7TH/kIbWSh68zvff3Cluks6oPEFJ7H/CCmVhxny0lGNZfwDH3nzDpwGDuPNLucMhoKu73sf3fcKzI96FoQjeEX3xS43xxMFz6EkQrQoZhjCp3SWqxf+vn18bXmWK6CkVaIiqkgPcW+B6wRuyxQ9RQnr+TTBX0UMs1TvpUApxYmxpLasS7QZ7q8viwYHMAKia6jKbuNxdhoAhaHdteZamJxT5+e0x1zSXrv8D/n5At6nyQFGlYAq+RoTM/7GeaTH4sDmQdpsL6L6n0a/wXpEK5a7EFuunskmwCw/4hfpZ9HH+tqCEtTrnrx5k4HXCyQ/JkqMVLhP0KELsGTK5MyfraL3WLfgCxI1ROq80VSCJYjaAuU1yKXdyNZlfT52rBU2g2jPpcf73n3j1jRTXwmEx2lrD16EYcVowTIjQ/ZkDejBjBkXF+OHI1VDs05EJRNvUDM1OlQpLGPF50O7DTxOQUhMDa0ry/B9RW0AhA/vgSQA60lAyNUrbgAot0ifcOkVwGL3ud9bnA3PdjjnGrOgAnW+7a1IQC5hVIR+NusWcl7EhDwx8vQjL00V1xfjDY0H8Z2ve4FyoWxiUkHqcektQUsjPb1I41BhhyzvwG8F9GQFtb3cbYkAWWD3xYM9+2up1qKZqZQAYz+i2fBWdTQhU9hmzQr6jltdLwc90I3E0NFqvGCg9Oq64Uv9TM9z3y+a2D+FZFF87QP84eynl4wwxaM6RO9sUahWEdWyAkxfUed+svD/WbqB3YUqyP6DdJjupoD/76fG4ymQ/UXcFhhLqMAIgShRPS15h/aEja/v53QYMA9Sn066VV8e4KOHKfWax5PateaDyxYQhZNYUJZCBFMZqxiNbV00avW5QoiModlUGVjEEClWPdppjN4QMZrNgQ
 TjpomSc1
 jFzT7e6cJVVaJYgPaw6an9oJ5DbgePGOLd7sfm1aDlGJkS7Yq6KC5oBlAGg3dSWY0gRFXHUXW2+x4kEGs78psng7efEycJ46bKUR2Dao0Gl34MbCiISvyp2Ex6aaG8ZL+Ahl4eZsbMuLpQ6pKy0Yik3sGFPujtwTuHEglZiSkgoywaRkkOouWBEJV3feZniGuQ9bPt8hAA/QJosXGlaCYOxqLATlfYr9CuAyNEnMyI5KOLbe+EqhFV95ca0FQGtdQ0rnCD+5mtqHAedVTyadRRJditw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:48AM -0700, Dave Hansen wrote:
> On 7/10/26 04:56, Lorenzo Stoakes wrote:
> > This patch resolves the issue by acquiring the mmap read lock on init_mm to
> > provide mutual exclusion against ptdump, which acquires the init_mm write
> > lock.
>
> Hey Lorenzo,
>
> Thanks for looking at this!
>
> This isn't wrong per-se. ptdump does _sometimes_ acquire the init_mm
> write lock.
>
> But the fun comes when ptdump_curknl_show() passes current->mm in to the
> ptdump code. In that case, there's no init_mm locking. I think the
> 'efi_mm' code has the same issue since it shares some of the kernel page
> tables.
>
> Is that your read on it too?

Yeah sashiko reminded me of this, I had glossed over it :)

I already came up with a fix at [0], I think it's fine to just take the init_mm
lock in this case.

x86 is the only case in which an arbitrary process mm is read (fun!) arm64 does
the efi_mm thing too.

>
> In the end, I think the issue is that there's not even *a* correct mmap
> lock to take. The userspace half of the address space needs the
> current->mm mmap lock and the kernel half needs the init_mm mmap lock.

Well there's 2 that are correct because you are actually traversing both
ranges...

>
> The naming here doesn't help because the "current_kernel" file doesn't
> dump the current kernel page tables, it dumps the whole kernel *copy*
> (the only copy with PTI off) which includes userspace.

Yeah this is misleading, and I misunderstood on assumption x86 wouldn't and
 be so silly to... and didn't read the code too closely assuming you did
 this PAGE_OFFSET split and... yeah :)) guys :)

>
> (Note: maybe we should hide "current_user" when PTI is off at runtime)
>
> So what do we do?
>
> 1. We could just bite the bullet and have separate ptdump files for the
>    top and bottom of the address space:
> 	current_kernel_top
> 	current_kernel_bottom
> 	current_user_top
> 	current_user_bottom
> 	etc..
>    Then the lock you take is dictated by the file.

I mean that'd break userspace though wouldn't it?

> 2. We could always take both init_mm and current->mm locks. That seems
>    icky.

It's actually the least awful of all of these I think :) and the one I
implemented ([0]).

It logically makes sense because there's nothing that relies on an
arbitrary mm in order to acquire an mmap lock around the init_mm. None of
the mitigation relies on that.

Also the user mappings (modulo PTI obv) share kernel mappings, so it's
actually logical and reasonable to hold both.

> 3. We could have ptdump_walk_pgd() take a different lock for each
>    'range'. Logically:
>
> 	if (range->start < PAGE_OFFSET)
> 		mmap_write_lock(mm);
> 	else
> 		mmap_write_lock(&init_mm);

I don't love this. It feels a hack for x86 that's put in the wrong place,
i.e. core code.

And can you can make this assumption for efi_mm for all arches? Could other
arches might be weird about this?

>
>    That's icky too and it means a range can't cross PAGE_OFFSET, but
>    that doesn't seem too bad (it could also WARN() if it sees bad
>    ranges).
> 4. We do something fancier with the free like RCU (I think this may have
>    been discussed already).

No :) please no.

 Implementing a crazy RCU scheme just for ptdump was already mad enough,
but this is begging for an RCU stall. It's just not the right tool for
this.

Literally the issue is vmap (and CPA it turns out) not properly locking
when freeing page tables.

The convention already exists that the mmap lock on init_mm is how we
handle this kind of thing and everything fits except vmap, CPA which I've
now fixed.

And with [0] I fix this too :)

It's icky but the least bad IMO.

>
> I'm kinda leaning toward #3.

Another way forwards might be simply have the caller _call
ptdump_walk_pgd() twice_ once with the range set to [0, PAGE_OFFSET) passing whatever mm
!= init_mm, and again for [PAGE_OFFSET, ~0) passing init_mm?

Are there cases where you expect to see a delta in the kernel range in x86
for an arbitrary mm?

And would this work for efi_mm and also for arm64?

So far I think the 2 locks thing, as horrid as it is is the least fraught
way. And we have a live UAF here so good to get a fix in ASAP.

Thanks, Lorenzo

[0]:https://lore.kernel.org/linux-mm/20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org/

