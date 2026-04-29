Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2771FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651756B008C; Wed, 29 Apr 2026 10:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627F36B0095; Wed, 29 Apr 2026 10:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D676B0096; Wed, 29 Apr 2026 10:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 427886B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:39:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0093B1202DD
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:39:26 +0000 (UTC)
X-FDA: 84711851574.19.863FE3A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id E46A5160008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:39:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lTQRCUMq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRbeh6wzSFJBhsD1IBNYmNNlFjofOgPhy7oVVu0x4xk=;
	b=ymFwSN4aUHvZ9iwwKw7Z2rq+9D6luNoQJtUpKmPNcVpinlHfyJbEpQU2FIZWLclU9IncwS
	oL05PEiOEDyhNTOUlkDlESXkRqHBCKcIA/G9s9+fWGAIPLb8W4eT7gQf9X61MW4jZLRwFU
	YeKNShADZUFqpTkE7LUzLB7jUWKpqZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473565; a=rsa-sha256;
	cv=none;
	b=Bif/M0YZORCV7hy6mBlmpjTNi+o0i3JxPuNwmS7ipIirBaLxC520KHxqx3fxq00QWyj5G5
	M5djPLRV1Q1GtfpJptQlkgnB4GtRtu/vvOT6JFCr4DvSTmngL3mUTRAGFoBYimYAcZtvMA
	g5ksCOuT9fHgx2R9k0eusNH+aoQmkRU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lTQRCUMq;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kRbeh6wzSFJBhsD1IBNYmNNlFjofOgPhy7oVVu0x4xk=; b=lTQRCUMqGKMlpPmKbESczV0lP3
	PCdOi4thZ2sDEeaUsYySlcjyAfRXoPLDpPhKSBHXuLOXpuDdmqNIrb9S787c/lPu4VdK8EIdLmRh2
	c9Lgecuet664qWDe5OP8sZ99WOMzCdqYiDlF3iCwpgwhqvXVu5c0AbiX5TBt1U7dMHsUDyJP3DaeK
	Mf+3Gf0w/JI9o9CqKynpAGQtC7UkgC4fjesH8RwJZAdpY0H6ZIKG5SjFoyKrLV8zM6Vfj7l76L/8y
	OPNMWKKpdjU1jZNG7gvmI0waWPZn4UIw9D9TFBfozuKsIfK2fxWS9lKVFbW+OqZ7vAuVNN4VfyBkW
	RuyIo+9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wI64N-00000005i97-09x5;
	Wed, 29 Apr 2026 14:39:19 +0000
Date: Wed, 29 Apr 2026 15:39:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <afIYFtL6KrBs38rT@casper.infradead.org>
References: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: E46A5160008
X-Rspamd-Server: rspam04
X-Stat-Signature: 6dbyrm44ywakc5skycspae7rb4d8iips
X-HE-Tag: 1777473563-588267
X-HE-Meta: U2FsdGVkX1/tmFVsUK/H/3MX8/+2iQCLEd5slkdgBvhvGYah3Kiwf3qbIWA/6kqP8QI9QJ5vs0BmUuAhtPfv/z8GmIQf3Tq1Mt3ByA7tIGvdBpWECF7jJn7oX1QMf0Vx3Wa1yBnwdXg6fDM3XdexcxslX6S/VO30vEPLvcrC/XDFDMFsre5YLEC1dM/9hu288fp6Oq12Oq7sj9qBE3IJnn95LDIWCWf1EVb2P2asKJNlEwy0ZZLPD+SlKz+h7426fNKWJ1Jp+5x8rSjKJYypX3nQ97D4fZOrARSJWtLkAZN/ctYVP5JRB8bNUBnXCt16sYs8I5Sf969iFZbs3S1e0xEuRHyxjdQ6+9EmN0nYYgcMFFbMhXVWtHUaDzYnMtgARwbsM9eM0NKHuK1ZUG/4Ae3d1tioJx46Csh0pwUJoFYnYRnJRXbOMxP8IR1QMBR5BIJL3tvEEFS/MiPxzLpVm+XRo9+Fx0afMrOCxDU4Z/0q7nNv7gA5uVyo0EjLzXSKCHeCXXY1yqzi5oGR6D0MYG64/J2syh1lLRk2PpErbJIIF0XpXd1b4oataCjUMbM2aRNjNhj8HgUVLN0Fvwao2oiFCmiDP4Hv0PtkYBkmYxdMACCgMk9PzdE6pecgcctuf8Zt9rkvJpuHWjbzw9szu7+S0E8CbaZX3VVS4TLV3gaEXhzO8w6FT/pm2H4hkZboITb70e0e6lgHRQ/vTv54kVvWvTiZp4A83a6RZMfzkE/Dl/BkQ3nnHWlnUHDTAGBQH4ZasBDmESo6SBBwtyDCC2paEOPgTNVwBcN2VpKp5MvCC/PidbPg/utxfGAXNTnzuV1nQV6LqK4Qq7NYYuEcCjuqBw7kToAMElpF1zkFkxwHhsErHkgGNQcsoWNimG//s+d+BNjztz22skpfkumYXAeRKrx1eF5oaDcZ7i5ObGf1qKuizM4Tqs99M2il6ZTo/1ALhXRUJojhrTFKNbC
 M7BRlY45
 arFuE68+W8gqA/W2tPaCfr9OswKKOsiXv8V2xHUC2zkKXB+tWBcC/duGU1K1VyM79cjD/r7VohXXftyCtaH+wErID/mG+ezb+BM9Lp00Uhcig1XNptnJiuEYEdLwoKwM9+XzTc6TtKgV36LsxQSZDVED20wL1ud1TBiqRBDMJyLE2nmW0uM7hobt1Yg4aJH3w4Zh+O/IEZSnK4xm9/xF/whZTU9Y8BYIQBqEGMbZS77Ueg+xgVs+1aKdxS3RMZZWjnlBP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> No, there's no new hardware (that I know of). I want to explore what page size
> means.
> 
> The kernel uses the same value - PAGE_SIZE - for two things:
> 
>   - the order-0 buddy allocation size;
> 
>   - the granularity of virtual address space mapping;
> 
> I think we can benefit from separating these two meanings and allowing
> order-0 allocations to be larger than the virtual address space covered by a
> PTE entry.

I actually want to go in the other direction.  I once came up with a
name -- POTAM -- which stands for Power Of Two Allocator with Metadata.
The use case was something like XFS's buffer cache where we want a
filesystem block size of data (so 0.5KiB to 64KiB) with some metadata
attached (xfs_buf is 664 bytes with debugging enabled!)

I set this aside to work on folios, but folios offer a back door to
unifying this with the buddy allocator.  It's a long road, but here's
a sketch:

First, we separate memdescs from pages.  I believe this lets us shrink
struct page down to 8 bytes (previously presented as various LSFMMs).

Second, we get rid of 'page' in things like sglist and bvec.  This is
already in progress for various other good reasons.

Third (this bit is new), we replace memmap with something like a maple
tree.  That lets us lookup memdescs by physical address (typically
a memdesc will contain either the physical or virtual address of the
memory it controls).

Fourth, we change the unit of the lookup in the maple tree from being
a PFN to being address / 512 (or whatever size we want to use as our
minimum).

Now we can have memdescs for an arbitrary power of two which means we
can ditch all the awful code from ppc/s390 page table handling where
they try to share one memdesc between several different page tables.

It's going to be "fun" avoiding allocation deadlocks where we want to
rebalance the maple tree containing the memdescs ... that's a five year
away problem.

