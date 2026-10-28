Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F61606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=JeUmYbrV
Received: by kanga.kvack.org (Postfix)
	id ED0D16B05B1; Wed, 28 Oct 2026 04:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81196B05B2; Wed, 28 Oct 2026 04:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48886B05B3; Wed, 28 Oct 2026 04:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD9C66B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:06:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99F09C0BE2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:06:53 +0000 (UTC)
X-FDA: 85371303906.07.8852610
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5041DC0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:06:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JeUmYbrV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793174812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c240DR83JuR63BMG4/5b1ZEcsT+lI3V8H+zMAtuhVW4=;
	b=FArKy0cOSRS4xHBoeK/9aI0Ygjj3eK9hkagjjLsfYAGtMG+ozheKLhxdpP1sd62nXwkHjm
	tMk5cIYUlMGKr/QI8gOYV6AKYiC3ico8BJH4PGqsvpBI9rS1Lo2OWkkJx5IrxbCug0cVVY
	0k81V58aHdH0M8t3eBOhGJgCSzOuWnQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JeUmYbrV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793174812;
	b=60xmguzPjTnVjrtZ9/wOtO3ARJ4ZzIudYEyrWRmbzJ9ZEfdPdXS0Fv3HRxxIPPePGrQJJ3
	1JZMZV9LSVN++X0ADi0JupLQ2FVsAYcHXexWiv32aft9WShMs4dDXIhgpVfciM3EYXupnJ
	VV8aO9UKuNZ7hLVjxMHk//G1tsbFz78=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c240DR83JuR63BMG4/5b1ZEcsT+lI3V8H+zMAtuhVW4=; b=JeUmYbrVJ5hVNkMe52I30pmZwb
	L+n8t3cHN2+9FUJIQE15d3lhvXFlG4ucACiZ0nBTW+0PzzZLkZNMT67Ef8gqakJ4JJPxpvHRdamWC
	JVoCh5fhQu1TgksInJTUjpzBJ3rbH4WH1gVgyCb8kuRXJw9sn7t33KaNmdCLZ8WEaw0ZjnR8ocks8
	CU8OoqRi4TMb/SF3TUlzO/5+tzoBDD1Qp2K1+Uaukof1vxIdis56J+A6BLdVKWz01rJQzblygcKN1
	gZxkSxBjuuVpqKS7RL1cwX500QdpU5nvVEqkWZi25MP4gCisv7FCpv3jk/mgXBHj/enb6KgwlrH7C
	GvanlsQw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLyg8-000000025sx-1dmn;
	Wed, 28 Oct 2026 08:06:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4FE7A30120E; Wed, 28 Oct 2026 09:06:35 +0100 (CET)
Date: Wed, 28 Oct 2026 09:06:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <20261028080635.GD2668804@noisy.programming.kicks-ass.net>
References: <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
 <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
 <auDkbDlgSZxqlk2G@thinkstation>
 <7cb3dd91-f518-49b6-b311-9ec807b3c63b@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb3dd91-f518-49b6-b311-9ec807b3c63b@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5041DC0007
X-Stat-Signature: 3utzbkx7r1f1xyp9xogrf1xicq6ymzt1
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793174811-493004
X-HE-Meta: U2FsdGVkX1/amfjDaKH33I3BLVACsFf2Btr1RTrMikpxj8YUkW6qzGA6H6py0+WKR5WTi9fSDN9a506F/u9dqq36xMgX4J1NXPVX1xeBe0zKmKGECiTu5tEdbgdHZV+kLM1eJweveleJg5OpFq9RoZwra3vkJg8gsqCWh9siCPrMNC9qbnAqZk4FFLYEb+akR+0aWKFz6kllkxTAE8JKTwwiGdBh4st7RBN80GRptBatRz6XKjzRk2r/Hzj9N0R7sxXrK3Up5F9vkgAac72WbRPX3wlORPHm3d/YkTUEGLGy72mEKqi9EuqxY37E06axjtD9HvigpeuQxnwMz+h4mjpkijmFbAjxb0DcKXdIQJWdBS9VRG1/wVpH/Mj4q8pI8cddB7uh/R98yrnxKK+1k4HD1RRbCt9deo95s1kiuGTh6788zzwvPOe0o/roFSVTM7dWC4SYW9iVMIcXC2AXa0/eOtBgtk+RxkcYUJllkJjUkLUw/J52chK3YKIX3wFRsHwpzJP+Z//CnHvxukzqJlktLO9by9nz8uNvwgmpjlxdmIoaGFEhlqvVYZITyLQP43F5x59IaNRhgjmsjG2fK1sDO5whadAFVMq8hXbMm73D1+708lmCWroWV15K2tVXK5SlTsAy31IlV9TFNVdA6hhGQyqDbtKcFaVJeTJ2uk9g68O3dxtshQoxGf+i2ZRNqlAtnhroZ2LrkcATt66fPsNsEz1C9Zy5qItyXxKMSwzH13B3DkJsUzQ0SrOQ6IOvUVO9Ldljk3NqWQmJPwRVGFLTFG+A56+VaghShXDAuWlrmdFShGIehS1h/8BCwRyZzxW25hL/HhX/q2l739sm7MxhDU7+0KWcAwGxJTKCyYiPsCVZitqL9ILtW/iS4PLmSJ4/1ZyvL8sit+w9IwIWIb1x5zU/2jEsKCyaXiOsegjNvKiztnKhsvlvbQK9a0Fxve5BReiWlaygjZ/z81G
 teJZW01R
 wX1Ne/kI/pJ8UrXwSR+jF0DSHkZwuSCizfs3Dw4dgLdMUt17MqTXBxCbR0/q25+g79BDGqSfQO1DtmkCxDAcGKbmNDKagRwgTUOyRNxIU9Ts4ftdSej7LKv1cpzjhqx5Z51l00uwfbAmdw/CXZdCtBPi9FNRhdf2A9xV9/ynmmZs+u63g2o3+3EoJ9GP+4Dli7he+Rxe2kE9uIIBfoMCZvTHWTkPzUCs46Do+pH8/OCvNvTJcJ0/CIfGEuAuCuWApctHp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:38:22AM +0800, Muchun Song wrote:
> 
> 
> On 2026/10/28 01:51, Kiryl Shutsemau wrote:
> > On Tue, Oct 27, 2026 at 10:03:54PM +0800, Muchun Song wrote:
> > > Therefore, I am kind of leaning towards removing the RO protection
> > > and restoring RW permissions to solve the race.
> > Okay, what about this:
> > 
> >  From e23ab850837b53cc79d57d58f1cfb4266e745c3d Mon Sep 17 00:00:00 2001
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > Date: Tue, 27 Oct 2026 17:23:47 +0000
> > Subject: [PATCH] mm/hugetlb_vmemmap: map the shared tail page writable
> > 
> > page_ref_add_unless_zero() reads the refcount and then updates it with
> > a cmpxchg.  A lockless get, such as a page cache lookup or a PFN
> > scanner, can read a non-zero refcount from a page that is then freed
> > and reused as a hugetlb tail page.  If HVO remaps its struct page to
> > the shared tail page in between, the cmpxchg writes to read-only
> > vmemmap:
> > 
> >      CPU0 (lockless get)               CPU1
> >      c = atomic_read(&page->_refcount)
> >                                        page freed
> >                                        page allocated as a hugetlb tail
> >                                        HVO remaps the struct page RO
> >      try_cmpxchg(&page->_refcount, &c, c + 1)
> >        -> write fault on read-only vmemmap
> > 
> > The refcount is zero by then and the compare fails, but LOCK CMPXCHG on
> > x86 writes anyway.  The kernel oopses when hugetlb pages are allocated
> 
> Is this an X86-specific issue? If not, I suggest a more generic
> description.

AFAICT most architectures that implement single compare-and-swap
instructions are affected, with the possible exception of s390.

That is, sparc, arm64-lse, riscv-Zacas, loonarch-amocas, openrisc (and
ia64 for those people keeping the out-of-tree port alive) all require
write protection to begin cmpxchg.

All the LL/SC architectures should be fine, they'll never get to the SC
part.

