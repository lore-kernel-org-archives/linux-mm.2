Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CC7C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 08:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C146B0088; Sun, 12 Jul 2026 04:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E606B008A; Sun, 12 Jul 2026 04:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCE16B008C; Sun, 12 Jul 2026 04:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29BDC6B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:56:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C82112011D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:56:58 +0000 (UTC)
X-FDA: 84979519716.26.25D63FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0EC1B100004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:56:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8NirJNo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783846617;
	b=eH37moUI7HjKBjQBKAFlGtK40DhGEy4b7JILTHmUvsdDda3zd4pZ4ZYC25Mdgf9L1RfjW8
	W0WQmVBl0zN5i69Rn25bFhCj6A2dSM8tUTTfp1+4W2r7OznlY+Kh0TsTWRGKmGAt4xR6a2
	sTHOUm97auXDp6DvCLBbA9yrn/alEFc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8NirJNo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783846617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1QX3hTGyK7nmH+TWYo3ib3paeMzWZv8UTRh9r0nU6A=;
	b=RxOrpLwIif9x7VZOCbJB/xCeUJdnx1WV1ug0/QAG/4JYJ++MGt8XgrfUKmus6ckFaEAf4y
	eRxzF0UiRBZm949ewQ6ogMQSGpd6Iw1/B2WPTHU7p3mkRgJfmPrqOTg+HGE4wo+6n7VoSf
	umRY9DyxCvIaThzE+d8AjJWi5j2fC7U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BC516004E;
	Sun, 12 Jul 2026 08:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D902B1F000E9;
	Sun, 12 Jul 2026 08:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783846616;
	bh=w1QX3hTGyK7nmH+TWYo3ib3paeMzWZv8UTRh9r0nU6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G8NirJNogPgfVQStzR93ILsQkLo2BuDodADXa7j2U2HKGcUuBSxHAB/1xQ+C4pNTA
	 tFEwuEv4Q1XThXD2hfBkx8dxi/kSJCSJgfW2xdKsng/Glkv5jgvOOpNhtEky7rU/RQ
	 Qyk1xWkUZA0v4Tjq2VGnVnOXyJ6949OgkXyNKWy5Qa0/y7HjI0v+H5l6qdabltTH9J
	 wYDS2P0HwwuRTqTMgjRTuCVahT40r/OGHgiJympxHvzIQeSPvCB4anE5PgHVcHSV8h
	 QzDfHUW1JHXMtkgYRtrD6a8AzCkEl7KqptGR6Q5EAvXKyucQvMHgmGY+zYhCVRxqss
	 9Uao4jecSE1Nw==
Date: Sun, 12 Jul 2026 09:56:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to
 avoid ptdump UAF
Message-ID: <alNWRKkOTIwJx-x7@lucifer>
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
 <alIVXHrcjaHhaFQo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alIVXHrcjaHhaFQo@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EC1B100004
X-Stat-Signature: ira1tf6yy4q73iepfrpugcmgz41dtu57
X-HE-Tag: 1783846616-838337
X-HE-Meta: U2FsdGVkX19PN2lfQJZLCgY7CCvuPdVRkBDbQ7lgXWXKmaneFFpQenYitDyTvogeuz2IfXO0/wbp57aYGdZN3DdVvR9F95mqStHpx5tuTCohrXLR/Q8lPiZRe1AOORSpLxbXbGT7BztlBZK/ExwxAjrpA3kbZXA6kYzQOF9yi0D++hnvMjnsf3AZ3QvaarELiZFwnQynJ6GF7lIhZKlbdV7Bzrwff5AVrlZZ0CDwPw1XxV0WBCunRN+1biO7Hyc+xBkd4l9vmCKulzR8hLyYb2AkkPaml8pTn+yXlbhlKZ53ZzSaX5VZw3TxRnSA3SSg3RbZR5ceMOKFULvTEX588zLPQ2YNrotdPYzSF8hvdoB6gULFIcPNZaM4Go5BlH1S5vplwHIlkm07oOzVR1xaau/VjIpR8+3dcpgOJXsfUNXB9nLqQKbPZC23ecXzg6H454l6tRi3fQIXGN/z/KunRVzAzT+lEJNonn+3tXauHPWEVobtkAVt9VgZHe8+0FeBC07CLDe/R5L9Mqm/wMA1VpuEjyrBxZOD0UoqBym/TQGTDOn19yAlOEx8QyYkBvm+rkWKzUEaD221WIiH7jR7ZwJCASXqb0R0DCIWFZgnXcim5FflZ0rTEljO1MPsNSieF90efMYTcl/kiHrtSlFWj0x8viM88j6pyhcnGf0ejeb5tZegMv2zjWzH1ebaAzSwc2ZDF3fqZLigMc7EKwY56Bo0k64ajnOsohazY+y0K5H8kjl46D8ezFPuVTbM/CVJRqo+aCd6I/0Y1PES8wdNTd6Su/bzYLh4PkDOC807TXP++MPZSMHYNiAl09lLbftZMk7fGd0YEB1hDTCDS+5RxFKYJbDFmoSvfvcxa2UR9hPN4gpKuXO/9iPP09Bdj5iC7DC7x3m0QYvPVZTDH2tBh7uYLvzQwbRYmPLup+oh46RBu4tI2l0QBqn3GwdyDuB4q78FQHT5KuDqzTL+OIi
 gKK/FCT0
 OiHNM7+Gpu2xr4SlM/BE6wTcDF+EALNIxXmdYGKko7QCo7dv+zYBPNmPOEBtlovmZO4/7+dkYo0P1IHBBSlt1+Ub435vzbxopN2W3QtDrig/+EVcrz7QtDDct+36iOqn7qu2uOYYfNiCGL8e5B+QJTbozaHMCXptZ/9ZIaSv3P+tKjO5fT5UtEMprWAZZQqJ1QnlJK8Z4cMZhhQJ5ojbq8TarzLvEbkrDUsZRWzPgyeJhhTdh9ZIKMiysC4X5ZqrZr2fS39Qlaz/4qMXXC0r+qa6ukQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 01:05:16PM +0300, Mike Rapoport wrote:
> On Fri, Jul 10, 2026 at 12:56:40PM +0100, Lorenzo Stoakes wrote:
> > x86 implements page attribute modification using its Change Page
> > Attributes (CPA) mechanism.
> >
> > This tracks properties of ranges such as cache mode through x86 page
> > attributes, and as part of that logic manipulates kernel page tables.
> >
> > Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
> > fragmentation") ranges of kernel page table entries can be collapsed into
> > huge page table entries as part of this logic.
> >
> > As part of this collapse, it frees the page tables which the collapsed
> > entries previously pointed to, and it does so without any relevant locks
> > being held to preclude concurrent kernel page table walkers.
> >
> > The only way this code can be reached is if CPA_COLLAPSE is specified, and
> > this is only set in set_memory_rox() via:
> >
> > set_memory_rox()
> > -> change_page_attr_set_clr()
> > -> cpa_flush()
> > -> cpa_collapse_large_pages()
> >
> > Notable users of this are execmem and bpf when manipulating executable
> > mappings.
> >
> > However, this is problematic for ptdump, as it walks ranges it does not own
> > and thus runs the risk of a use-after-free on page tables freed underneath
> > it.
> >
> > This patch resolves the issue by acquiring the mmap read lock on init_mm to
> > provide mutual exclusion against ptdump, which acquires the init_mm write
> > lock.
> >
> > It is safe to acquire a sleeping lock as all the callers invoke
> > set_memory_rox() from process context and in any case,
> > change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
> > mutex, disallowing atomic context here.
> >
> > We also include cleanup.h in order to use a scoped_guard() to implement
> > this cleanly.
>
> This is a part of another patch, isn't it?

Yeah, as discussed off-list, I think the easiest way now is for me to resend the
whole thing as a 4 patch series.

I was avoiding this, as it makes the stable stuff tricky and means we end up
with a series with different Fixes tags and some stuff requiring ordering
dependencies and some not, but hopefully Andrew will be forgiving :)

And likely I'll just handle the stable stuff manually, ultimately.

>
> > Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

>
> > ---
> >  arch/x86/mm/pat/set_memory.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

