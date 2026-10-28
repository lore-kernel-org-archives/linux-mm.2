Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55758606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=WQTo7RRj
Received: by kanga.kvack.org (Postfix)
	id 4DE326B05C1; Wed, 28 Oct 2026 09:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48EF66B05C2; Wed, 28 Oct 2026 09:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DD56B05C3; Wed, 28 Oct 2026 09:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1446B05C1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:34:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA0A340CC4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:34:51 +0000 (UTC)
X-FDA: 85372130382.18.C833D08
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD7CB4000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:34:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=WQTo7RRj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5sU8ZAJRz6gFhM4gDWxCHu2kvyqTC/PTTWhoAieCGY=;
	b=k1M+oT4KQZTRDtZN9tzl+04s9vQXhorI4OS2bumnC3GfovoOIknSDoaCqBPVWXAUWKRVF/
	RS6Ywn69CAJlxVjhcncsQgJKC0H8v+BKM9bbIxHnISEjiNAa0akmKnVz/PUKDznd7tTZKH
	BusMmbM3AeMscu5J3secYyFO+r6VNIs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=WQTo7RRj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194490;
	b=ONhX/6ngSw+Gm3lYLsPYGQvL0ItVXbCss4UzSOyK/3P/jWkL/vsWSXXNv4aWSaIdj3tVoq
	G5da9CdBRLwBpRO18rtzjRGzQdNKLn8i6vkV1SYESxrfS2I0xlOCT2qrMaK65Pvm5xc7G7
	+EKdRvEh6hV9dfasQAhOg4TrPB2qifc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K5sU8ZAJRz6gFhM4gDWxCHu2kvyqTC/PTTWhoAieCGY=; b=WQTo7RRjUws4wLzC6TxpAmx57w
	qcq5fCMagtfKad2FmcZhLNiyNmxBTF8/cvyU5FhHuyznlY2ota9MN31xYDxFIv2Erfp4aIicHdOEl
	E2jxLk1iu6UVgBFuNZDHQbP8i5O71tuJIGJbKRCf70a3PNnSQKK+sWlOzaRMzfKYFkbHgL5lDL9Vp
	ZvXgetdmOXoLVKHD/1ZDYuRo7eMc1PaJvukhM56Ia68PICeBLH2PimR6BGNHj7GsDJbTI86FtVG5t
	W0wLnsMXdRptmezamho6yQr8A3y96kAxjX7Nk07pkHXtbr6zoq0TtEiKMjF427WJnVaamNRv1dQ0Y
	/t33+Xow==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM3ne-0000000G0rh-0VGE;
	Wed, 28 Oct 2026 13:34:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E42F1300DB9; Wed, 28 Oct 2026 14:34:39 +0100 (CET)
Date: Wed, 28 Oct 2026 14:34:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
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
Message-ID: <20261028133439.GK2668804@noisy.programming.kicks-ass.net>
References: <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
 <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
 <auDkbDlgSZxqlk2G@thinkstation>
 <7cb3dd91-f518-49b6-b311-9ec807b3c63b@linux.dev>
 <20261028080635.GD2668804@noisy.programming.kicks-ass.net>
 <auHxIORufMbldrBr@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auHxIORufMbldrBr@thinkstation>
X-Rspamd-Queue-Id: AD7CB4000B
X-Stat-Signature: tyh3h3znaikht3bq9sm89tokwmq34i8y
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793194489-777563
X-HE-Meta: U2FsdGVkX1/Pn3LfEX3H5ql+WlmlCd5gnePjHsPyjNZ+NEY+guYu9keryb+nK9J12MPx4i1p7R4ox9uqG4cD7dpuagdOFKQz7zSTorlzK/K/6bFIp1BrvAxfJ7yRhEBIWm9DI3CDZ8UWjzn401nS5Vgq2w2Pxv7ZLGje7TEn6doq2gWqMRkpfQStp4CObDQ9zEgOWw0sEkkffoaBlPCN/7g3L4lXfe5Y8wfkKzLUT92vUTQ1pvGOCcAX2nAnQzpO2i+8wDZMXBgSYSZGbs3bjV0qMjODwY9TWZ1pIv3qCPrGzUagV+VY5POMdpvgA8pNs1iOrVNgQ6VI42MMe4mrebSmQYs2ODkWTfXu/XzLbP/pn/qrL7pgUOpw7F0ha3HaxxS5VU6YnsAErzqEBD0VBnifw0w2DOFkKpSYDw7sk/N8BcDtauWYKrjv6zt5c9E92UcTTJr1U1bdKuAzkQaM1oHx81Gcs8/VwkeSOTpXvpkNmG3L4ggXwUDBeElhG/+Y8oDZ8gUr5R4nfaffGfSbYIRBS7QcE6P3x8ubx3MYow7yrRkXSR+dWP+7LvrtRO6ZyyAw/G/E6oib5wS/F9XTMmqHJtZEuixh48LCc6bOE9mDpIS/pEE/lyjyucmU+7HefLLkkYI9+MPK59Niq7y9XN4akEgJ3JzjcG+4ewtUciCnBABKFkAki6R5G0uYFAwtvQzi632DYtrhLX1584Qfw385rSc1OkN2efImVI7z5fEujbEZtFicF2FWiH36gNUaornTTI+52XDaxvifNDbnibB5umeqZr35qqFMqqym43snt3H2DcjDK3GqweRD7dhGYLN/DWTRX0LfrRxoys8tiYEACQfsQmFrLjICjxj9K4Ik4ovOhqK3MlQ8x5j8iVMhxaQagEXqJrYAXRgYFZ59NPZ7bwizp7FcEdQGYc6BvMri4J8+Sdy3Wu7hIBIROFxE9kgBtqzDlfNz0dUNwVV
 IKFIpUwa
 Wq3gWG/nf+IHKMblVLriJR1zRzdUu0JMEHL4PcO0W4gt0a40pMiO5P5jhtdB7vogxuLuFuwcGy3vJd++pAJEUnCZ+D1VoJEkK3JPAAqsBFiPGcBfcGJtYDNWedpVpkK44UyRhX7te8GZ8lWEDsb3RuISz6X1SauIk4DKSYI7zQQm5Q9gYezr8a3xuDBVQY53vU6y/edspnpjW0Tk6v7jvjtDVIm725fFXqSKRLcyyRAkqKL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:58:11PM +0000, Kiryl Shutsemau wrote:
> On Wed, Oct 28, 2026 at 09:06:35AM +0100, Peter Zijlstra wrote:
> > On Wed, Oct 28, 2026 at 10:38:22AM +0800, Muchun Song wrote:
> > > 
> > > 
> > > On 2026/10/28 01:51, Kiryl Shutsemau wrote:
> > > > On Tue, Oct 27, 2026 at 10:03:54PM +0800, Muchun Song wrote:
> > > > > Therefore, I am kind of leaning towards removing the RO protection
> > > > > and restoring RW permissions to solve the race.
> > > > Okay, what about this:
> > > > 
> > > >  From e23ab850837b53cc79d57d58f1cfb4266e745c3d Mon Sep 17 00:00:00 2001
> > > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > > Date: Tue, 27 Oct 2026 17:23:47 +0000
> > > > Subject: [PATCH] mm/hugetlb_vmemmap: map the shared tail page writable
> > > > 
> > > > page_ref_add_unless_zero() reads the refcount and then updates it with
> > > > a cmpxchg.  A lockless get, such as a page cache lookup or a PFN
> > > > scanner, can read a non-zero refcount from a page that is then freed
> > > > and reused as a hugetlb tail page.  If HVO remaps its struct page to
> > > > the shared tail page in between, the cmpxchg writes to read-only
> > > > vmemmap:
> > > > 
> > > >      CPU0 (lockless get)               CPU1
> > > >      c = atomic_read(&page->_refcount)
> > > >                                        page freed
> > > >                                        page allocated as a hugetlb tail
> > > >                                        HVO remaps the struct page RO
> > > >      try_cmpxchg(&page->_refcount, &c, c + 1)
> > > >        -> write fault on read-only vmemmap
> > > > 
> > > > The refcount is zero by then and the compare fails, but LOCK CMPXCHG on
> > > > x86 writes anyway.  The kernel oopses when hugetlb pages are allocated
> > > 
> > > Is this an X86-specific issue? If not, I suggest a more generic
> > > description.
> > 
> > AFAICT most architectures that implement single compare-and-swap
> > instructions are affected, with the possible exception of s390.
> > 
> > That is, sparc, arm64-lse, riscv-Zacas, loonarch-amocas, openrisc (and
> > ia64 for those people keeping the out-of-tree port alive) all require
> > write protection to begin cmpxchg.
> > 
> > All the LL/SC architectures should be fine, they'll never get to the SC
> > part.
> 
> Only architectures with HVO matter here: x86-64, riscv and loongarch.
> arm64 has had it disabled since 060a2c92d1b6.

Per that commit, could it be re-enabled now that its no longer marked RO?

> riscv and loongarch implement atomic_fetch_add_unless() with LL/SC only,
> no CAS variant, so they see the zero at the load. That leaves x86.

Ah yes, I only looked at the cmpxchg implementation rather than the
fetch_add_unless :/


