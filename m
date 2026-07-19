Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DC4C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 23:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26B96B0088; Sun, 19 Jul 2026 19:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7666B008A; Sun, 19 Jul 2026 19:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECF36B008C; Sun, 19 Jul 2026 19:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB296B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 19:00:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9E55A0D9F
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:00:10 +0000 (UTC)
X-FDA: 85007046180.17.FF19BA7
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [185.125.25.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id C12F8C000D
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:00:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=ylRpRYNj;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf28.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 185.125.25.9 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784502009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJBl0FdlICAYYYTQiV3xnuCWcw9phxxvhoXrl3+SMO4=;
	b=1TiJWUXqO5PowLVDPjfsyaPLywTc4feBX3NHfx6R+J3Ig5h5HPp/l4NwsrNKOFAp078cej
	xRPgfFc6ZKJdvsLmanTpt1EnKErDHF0Rd3PFkaefIUHBj7avAbStuuzOMqxyZqAGR0J0SM
	k0K+xlm9xPiKd3F4j/khQ8H2gsFIUV8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=ylRpRYNj;
	dmarc=pass (policy=reject) header.from=ik.me;
	spf=pass (imf28.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 185.125.25.9 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784502009;
	b=VaRL7Vp1n+MtVVSJx1DFzAgFtVZHJAIfZK0S/e5nsd/IkiYDsE6kwU7BSBKpyLl8UmAl43
	GiGKA3FgtJbkte9llhAtfqRU+um7wN5WvAz5fKUVG5A8dEQqKR7+rxOM5gZnRkQByCAnIl
	O3j3rop9HklLcFzpVMJDRg2KxLQEq8M=
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h3JyG6Bx9zDdK;
	Mon, 20 Jul 2026 01:00:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784502006; bh=aJBl0FdlICAYYYTQiV3xnuCWcw9phxxvhoXrl3+SMO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ylRpRYNjVv7knoKzC2KLAQeA7Zr2FDlpf2PXLOw1I7QIbpLRcRFLtHfWc5Wq25lMr
	 1oRhPqNIX0syzyOEQz+J7YD4lfs7L5eyEa3iqD2kVCcs6cJCIyxU35+l4XKPxCIUGv
	 3T2kVSac6iaj3aAVYse8pVhzfJlsYDqcsSzn5OeI=
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4h3JyD5cCgzW55;
	Mon, 20 Jul 2026 01:00:04 +0200 (CEST)
Date: Mon, 20 Jul 2026 01:00:03 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <al1QhWX0eS2iGo8N@ik.me>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <aZdMqub5RsukLvnv@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZdMqub5RsukLvnv@casper.infradead.org>
Feedback-ID: :c73c7b77566af2c:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspamd-Queue-Id: C12F8C000D
X-Stat-Signature: 5zgpy7isz98wd36e7dtqwrstnkmwnyu4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784502008-947738
X-HE-Meta: U2FsdGVkX1/rxEWpbJ/dSHmyQVOVyswYtbOogOgsQgJabJJTft21RHjxcU/lOpobJUf23t5qP1o96ed3hUh9OVWwxZoroxPIYjiRtOOYeEiiKqDgQGqq+p8yWjx7dDKxUG7BCbwdo35MpDsByUJeiDU9nRUucwr5M0vy60pL3dmb5PLJ7sxLZOcpkcOpLKdpzEmhem85YeoXVLvaBwsVti1Co1OJKE/05uoZDr1iPSpG5/8J2D1j8c3nYAe7e9pGr7fVeqPBiET80ZNogekgxb1CspPSDZY+INJktYD1mPKkieO6EM79ulRINY1SPN6e5A66pxLEcbgHibKRmDaSSYCh/a4MInJ+Lj02M4vaHS+6mRYTGF35CENjqaedHkzmSRunnKAhLs7mYpu62a5hFnekGkUk2mjDfLy0yEsiqjVK+mxov55OwCgz9p4BN7xzgmURe0QW+JEYs4otmlOXiQUQb9ba6Wq97Dfh1miIjwAYIfyDead7TBLYTyusVsBlmQ/lyFX/LBV6KeQBniF9Rbs5nptsAm1UkN8a3yBugt92M4h0ValgAqQRNQ59SwKm/RECTn7vYq6ARheFMW7AJvfrMWXSlzZYGnswCy3RWA8qH6QaOsTTlORWr1dR3hjnLLCUvfO0/N3o1Hj5R4UWC4G4sgeUp4pkR0MF2/3vqyXB0tN8alvHxUEQy/MLgRDqzr87rpQ+Jk18/PAKhBWX89+nsu2eOwsveIK1+8hMMr8kwKa9okZU709KrfAOhe45FzAya7ORQeNwqSR5hH+NtWMDZBaV4QmwlBYEHvRuokolY7bMYjq/iF3LnDDGzZqG0c1HjUJwh3Aq2zjdA0fdHqvHTDOhFyGhUDtpybeLd/2h7CQolCpkOvxL1GeqGvDj7azSrzYcr6LbQffFVr/0wp9YU7xgkg4J+GnjNfJGkF492eVdPPlteSqHj+BSb0eVsXA9M9AQajK5Vdcpyw9
 3UQ78afp
 IexStI3VD7kgJBDAzU2JM0SWYDd6iPWQtB0BGf1Y1qBfSoAe1dZzN9qOD5zthKeUZfjgJSLcXNMzBL5bfoWdGbXuIMrb1++Bavf6NfkCmzp5CwzNOI0MM0YdFpDCT2WAK0JN7cVUJlMPDvthvp8DTpsnbRJpNZKARfCytKrR0WyBfFK1HeGZEfNmYLJbzkXxzlNrYCeKoZUxakws+EyCvOakU9SDSkCIUldF4510ufCQj+yHf9AAwv70eOGWW4gGAhTBPECSXDslI/xnOda0e7oFPiMlLQlEaA51D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
>> On x86, page tables are allocated from the buddy allocator and if PG_SIZE
>> is greater than 4 KB, we need a way to pack multiple page tables into a
>> single page. We could use the slab allocator for this, but it would
>> require relocating the page-table metadata out of struct page.

Am Do, Feb 19, 2026 um 17:47:22 +0000, Matthew Wilcox schrieb:
> Have you looked at the s390/ppc implementations (yes, they're different,
> no, that sucks)?  slab seems like the wrong approach to me.

Yes, they both required fair amounts of debugging. I don't remember what
went wrong in s390 early boot. ppc64 mm/slub.c item-within-page indices
ended up notably overflowing 16-bit counters. PA-RISC had some issues
surrounding a race with setup or teardown of I think accounting data
structures for some IO bus among other things. SPARC had an interesting
issue because its page order growth increment / Sprungweite was 3 where
the PAGE_MMUSHIFT increment used in testing was 2. Something odd
happened with SHMLBA on a bunch of architectures and I can't remember
whether there were hardware factors involved or if it was just include
and config messes leaking PAGE_SIZE.


Am Do, Feb 19, 2026 um 17:47:22 +0000, Matthew Wilcox schrieb:
> There's a third approach that I've never looked at which is to allocate
> the larger size, then just use it for N consecutive entries.

Strangely, I think the mechanical assistant did that for MIPS and few or
no others. It was simpler in various ways, but I didn't like the space or
locking overheads. Given the chance, I'll likely redo it bes. if I ever
get to demo MIPS' 1 KiB PageGrain extension running high performance
with a near-VAX minimum MMU/TLB mapping granularity.

My energies are more likely to be directed elsewhere if anywhere at all
from what you're telling me, though.


-- nyc

