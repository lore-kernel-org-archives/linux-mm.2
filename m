Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AC7C44511
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE206B009E; Wed, 15 Jul 2026 15:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E7E6B00A0; Wed, 15 Jul 2026 15:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A752B6B00A1; Wed, 15 Jul 2026 15:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5E36B009E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:14:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D99671A02B7
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:14:56 +0000 (UTC)
X-FDA: 84991963392.16.64778F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CABB840004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:14:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wM3fu0hQ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784142895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViHw0i/Ol3YgTRIw9C4EDJ0sBKCT3F9/+wZKL98nwYI=;
	b=rV63FC7X+co/IEjE9zc9LPdW8Da/riiBPGaTZdv9E2qrRHVn3pV22Hwr5IkLo9yvHtKWvB
	3qK5/oXU8m+UoTNHsUMGwHr9jyzBFXKs0cUPBTKxYxVl2D+Lh18U8ZDaU+KHOFk6jk/FH/
	/jerZjns0qFZiR+be98Kqmb2tRcVuA0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wM3fu0hQ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784142895;
	b=5DD1tVDal5p2H1cu2QTzbhyheqjGHUwT5QAoatILVf4dAAxRqpm3S6X2gNlFUcB2YBuc6N
	PAfcWtSnH/rNM1EoLY4iyRZZqyeYdstVkOUgKPAre2lySLsA1xC1qwxVwRtIpCRyHyj9X5
	Yd8R65/B/XsCR9jd6wBeyIDAgbtqQ2w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EABF61878;
	Wed, 15 Jul 2026 19:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D151F00ADB;
	Wed, 15 Jul 2026 19:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784142893;
	bh=ViHw0i/Ol3YgTRIw9C4EDJ0sBKCT3F9/+wZKL98nwYI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wM3fu0hQUE2ZXeszCzbkXLBbR0dCG5bwf0UQtBQA7nGKj9H0vkzsdRCLcRDBHDRvl
	 oW/UCFp1zjFYwiluqA8Anl7AliHSWpMayahnYCHmlv73JUX7cea0fqZAmvYU/9P40A
	 C3SsVY8UUbuFctRY81KY8OGqMm6+JX0KWy6eVf38=
Date: Wed, 15 Jul 2026 12:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Toshi Kani
 <toshi.kani@hpe.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, David Carlier
 <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v3 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
Message-Id: <20260715121452.3e8047663eeaaa3048f80985@linux-foundation.org>
In-Reply-To: <178412496800.59347.11482869717348078349.b4-reply@b4>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
	<20260714-series-vmap-race-fix-v3-1-b812eccfa0f9@kernel.org>
	<aldhVdwj9oMRN1Lk@thinkstation>
	<178412496800.59347.11482869717348078349.b4-reply@b4>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CABB840004
X-Stat-Signature: iicy3t6ic3fo3c1xo55rswq1foyafiay
X-Rspam-User: 
X-HE-Tag: 1784142894-386602
X-HE-Meta: U2FsdGVkX1/RRa0xVUWB4yJZgKr7uePmvWcdW5az5lgRY+mcYi2e36XWAWvKE9rKIogzCJaOJvBJg27h941B13G9VLrsNaYO2Z/ENg6XAxOQV0BbJJWu0OURDk05qZn3cgVAK7V2nGx5v4wGDwG5YOSAlvjH27uaHOeNQLjfwXiMbtYh5ePJmadiU43mHfjGRbxg4Y7R1PKlQnx3BYJ7f5EW7X8Zz3Fbylnuw+RwoOi76MjgHWA0TjRK3ZUlocsG9b/qe+FQTm1ZqFO4Iia9U3Iv3HusczYEbRJpRL+9oVymqR2Pf4oJXGDEntqpPG8SrxtI7X5JHE41NqCM9+0bq6RVq6nlwxM8i952wyj2DQNmEjNdS5LhjYHsBhBhLOnHGqVp8YpZHjMp0QpkZVtkXAB3lRzRRCLI1jFzQuOa86/JsGm9mmT8GqbXZmDTAPdxb5vawmeJaamGgJaeGLfUw/4I6HIiDROj0jvF6IBMkDrVEeq35/fFheaf8lODg65TjgzcbMNF0F9NmQlQVeLOF8OmcsmnSTXB+7/dSvVn38J3DZDRrk1KTTVWuNbMkrkVIlcQFDBc2gpKnOZvjEaxmBlEaWTb7glUwdDLInR+gSx9bqk8R/hZZ7zFaFab2Sl5OEv6OC10dZM3Gr/BfxeHdfdkCP1qiQ2I5o1Xd84PFzygvASPEXjjlbpIBFDeQ+2VX08/0nN8oFHxBNC3JLTpU7rjaX/was0Ka+NQvmBuOac7vC0kcWYIlxyAUPIWe7hDWHGe6lF3hB7Fxo9mzGuA6X8gCQ9hEXtS4aHf/rwPSEd36i4mWD8bHtNst55OK5hfJyPaXFT7YPNqDCMMaCBpddu0EgbjdPr+unZbhLNanq+umLTL+WxaMVeOLFhefo34xA1hEUaJMgXjjpZlmt2DhN2yEki8QeqK8Bh0wn40nbkfSxejLPVorTHAsIUdbOlXJOa2rWF5U1zWG8T6U2a
 3N1x2hip
 AmSNma08I0ir2OrbtYizH+nmKNaoObkzmFarPKGdrPzWb4i+dyEh6UL74LWlW4wHPQJYexqdX65BpoWGCqAO3DRAOEPpu77iaUIRzPUkKqOog9H9yveb0l/DHIUQlg5qMz1k6U6JDE6LU2BgArGodj/AZM9kjWzGk/Ent/hStaHk3hdMZ5XkGEHABlS9oLaozkQzdX9TnrqTvoyOIWRYH/xZSAfXZPbBZ1iAK33eZu/8Ha/1yHO+ABA/eZwjRNQXg6AZQwLL8T824gul/WkUmmjn3JrxoCYej7/HO5NaNr5/HKVKrBIqrKozDQ0JcJQh1fCskd42SrTtMjdnM71GFX5xr5A7eEOTbKrsOrOVW5aqcloWd2U9W2kqeNbgMkTyJbxX4WlhC+5c6cv8G1ID/4xR8nJZduafjyivw2bMR+iMwociJw3sUGe1tmxlkqKP+degrpQGGYm9MWrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 15:16:08 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On 2026-07-15 11:34 +0100, Kiryl Shutsemau wrote:
> > On Tue, Jul 14, 2026 at 06:24:23PM +0100, Lorenzo Stoakes wrote:
> > > Currently there is a nasty race between ptdump and vmap when attempting to
> > > map a huge P4D, PMD or PUD entry:
> >
> > Nit: that's a strange order of levels :P
> 
> Ha, seems I couldn't decide on ordering so went with something random :P
> 
> Let's try 'P4D, PUD or PMD' instead :))
> 
> >
> > > Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
> > > page tables.
> >
> > How about adding here something like:
> >
> >   The read lock is sufficient: ptdump is the only walker that must be
> >   excluded and it holds the mmap write lock. Other holders of the read
> >   lock may run concurrently, but each exclusively owns the range it
> >   operates on and cannot reach the page tables freed here.
> 
> You mean maybe I put the commit message on _too_ much of a diet? :)
> 
> Yeah sure, sounds good.

I made this changelog alteration:

--- a/txt/mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.txt
+++ b/txt/mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.txt
@@ -103,6 +103,11 @@ walk_page_range_debug(), vmap takes no relevant locks at all.
 Fix this by holding the mmap read lock in vmap_try_huge_*() when freeing
 page tables.
 
+The read lock is sufficient: ptdump is the only walker that must be
+excluded and it holds the mmap write lock.  Other holders of the read lock
+may run concurrently, but each exclusively owns the range it operates on
+and cannot reach the page tables freed here.
+
 We also hold the lock while assigning the huge page table entry, which
 means page table walkers observe only the huge or non-huge page table
 entry.

> >
> > > +	/*
> > > +	 * Kernel page table walkers either walk ranges they own exclusively or
> > > +	 * hold the mmap write lock on init_mm (ptdump being the motivating
> > > +	 * case).
> > > +	 *
> > > +	 * Therefore, acquire the mmap read lock to prevent use-after-free when
> > > +	 * freeing page tables.
> > > +	 */
> >
> > Same for the comment, maybe:
> >
> >       /*
> >        * Acquire the mmap read lock to exclude ptdump, which walks
> >        * kernel page tables it does not own under the mmap write lock.
> +	 *
> >        * Concurrent read lock holders are safe: each exclusively owns
> >        * the range it operates on and cannot reach this page table.
> >        */
> 
> Yeah that's better agreed.
> 
> Let's replace it, but I think (being super nitty) with an extra blank line as
> above.

This?

--- a/mm/vmalloc.c~mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf-fix
+++ a/mm/vmalloc.c
@@ -163,12 +163,11 @@ static int vmap_try_huge_pmd(pmd_t *pmd,
 		return pmd_set_huge(pmd, phys_addr, prot);
 
 	/*
-	 * Kernel page table walkers either walk ranges they own exclusively or
-	 * hold the mmap write lock on init_mm (ptdump being the motivating
-	 * case).
+	 * Acquire the mmap read lock to exclude ptdump, which walks kernel
+	 * page tables it does not own under the mmap write lock.
 	 *
-	 * Therefore, acquire the mmap read lock to prevent use-after-free when
-	 * freeing page tables.
+	 * Concurrent read lock holders are safe: each exclusively owns the
+	 * range it operates on and cannot reach this page table.
 	 */
 #ifndef CONFIG_ARM64
 	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
_



