Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A29ECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C098E00B8; Fri, 22 Aug 2025 13:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB758E009D; Fri, 22 Aug 2025 13:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CAFB8E00B8; Fri, 22 Aug 2025 13:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7738F8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:18:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45209830B4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:18:22 +0000 (UTC)
X-FDA: 83805052044.14.E6EFFFD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E45020002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:18:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EFGePOGa
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgAdJ3j72gnDK10Zxbk1Jlr1gL3qO4aUda16rZ52SIc=;
	b=3teHM3h6MG+Q8RAWc0CEqAYgXQm7nGL/cJNOd+NVj4I8nNnQzyr5f9MYXCRAD0ZkTs/PkI
	Lnz8Bh1xX5EfgSy9P8DVyuPPY/5maA+5EMV8b8ZlLu1UCuK0bnDF4ryJVqyoFG2GOkQoQ1
	sZ5JTK9lMdLnTUCWgPh2b+/4SQEibps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755883100; a=rsa-sha256;
	cv=none;
	b=b+69J8DVq4CliKgAbBfWMrjeWj0YK+LmiiAJVBHvtFSIDHRhVIK44IabMliAQoCA6EnX5l
	znRvgUtKgToZ5NsWgIBnu15/HoaQ7XDR2QC7cY6gN3OJVACaJn6/XQET4R3QDiNGYHT1BX
	n2Gk7eZZ9592TQWC+O/+TMPRWw30hjQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EFGePOGa;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TgAdJ3j72gnDK10Zxbk1Jlr1gL3qO4aUda16rZ52SIc=; b=EFGePOGa6D2SXlxUpDRnjmCtgR
	yQtukIuL7IB5xaiOeg3u1jG2TssWZ64qIqI+TewseLBkChcx2+xSm69lZLM8FK8WbJSGoY/RP23yI
	WY79LyvzwIAlAGiTsyvo6Q18e/Vd5vjxYbX/xNsdnpB2PWx4T+LFGTbVFKmLwVotVNS7nKPPSlRO0
	b1ymmdHBMN4a8A1fm6/889OWlGZTj5Qg9/WWlpshs2MrPhbVhrfCXx1yImIwU4XUiU5D8rja0sY9q
	TdedtQXlnhupdQLxVtQDduSnCJYRRocNwY99v/JzUKhHUOFwo/SrCRGNTXFSwB5W5THmjkl5ec5JK
	HGWRWnyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upVP1-0000000ASDO-1DGI;
	Fri, 22 Aug 2025 17:18:11 +0000
Date: Fri, 22 Aug 2025 18:18:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>, peterz@infradead.org,
	bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com,
	tglx@linutronix.de, akpm@linux-foundation.org, david@redhat.com,
	derkling@google.com, junaids@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz,
	x86@kernel.org, yosry.ahmed@linux.dev,
	Liam Howlett <liam.howlett@oracle.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
Message-ID: <aKimU6tf7-RnwISE@casper.infradead.org>
References: <20250812173109.295750-1-jackmanb@google.com>
 <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
 <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
 <05c32a14-805c-4603-9afc-80e8f29b7957@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c32a14-805c-4603-9afc-80e8f29b7957@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E45020002
X-Stat-Signature: t97cggzqqjnfxqhh9kwuctbr71mgwh5t
X-HE-Tag: 1755883100-287241
X-HE-Meta: U2FsdGVkX1/LAQ/IqmKDqIAo3b4l3s7QzvsPImo4At5et1tsDTwTIdlYNEOTKlurwnzbNTmAhmg4a1KKJlBQlQevM1zLZbabchOUxFjT+smWNllokGKMU27EuqbzlvCPvXwId1VwjQ3rn/HJFLrbVvA6mTDZiioIGo9Rn2MqFzXw9LXDPXt6pd5N3b9RQPXspnO8BM0O72+WU85DQo7WcQi7eDMSEgxfIlcNo9lg3SHA43tz9jZPSpXC7vuuO2hrjtDXGXNOjpO2ikF1fzAfvjU0A+mdDNpjoeptcIz3+/3u583uKoWTb+KU4d7NftX0NKBg0dlgulKuCGL/0v4as36cqzub2Q705UUe/T5FEL6y4BISvdF50FdLnIjhJVd9EAKFlso3cBxYQrRXOm6mTEAMqDbiMsGNCd8vqxypfrEysKFVmeJ3lpQWf/oln7L9smXfaRen+ERFCnmynnXPNp6X0Nc8KtlHhq7S2ZTao6EuVbzR00j79Ps+qEePRLFNtJyuNeTYE4xlFA0bAss/NK/oMHnXX3HDLBGmBq5r8bb7IttSt2dTpqQyMMTuw1PpdAi131e8TmtDwlIMmdjEsy87hV8RGNrF/yZy9tT0LoukkVM8PiF12H+gQ3qdcgcaJZaBj3Nrfj1X1crxKiighIXyOFvsOlS5pyAEw4RP1L2gyco9IhtrsHLMxIhjJjZCvV1U6+n4Nf7j5fyOkMTFP0KUb/QiMepEMci9Xgn2n7nMDNCQKkZxiy3HBhJTS5jeO5dCHKC32FKQebb8fUqwHHz+PPEBT5N4v+irssuMFj8eRaaIUefPzlb0k0TkK7L4g1vGJYLChwUNLi6Ewvbfh9v5Abz6nZUfVNFusKcppL7Bi00IPmF3ZHIy8g+JAX9y7dMtKgiRUciFgGamdRbcoi65mYY4JpIREkNA0QVBms95/gRd9LUDPpN+CwrQt0fpZKwydBDisjjDwWojA3G
 CLj4PfWQ
 7q8sky2YfP7ll4klzNvfVXCl6uJVDebHZwKLgZtax/t0WjR9LlX9IHBvIi4yjoHlNCV95bYLJ4wmFaGKly4LySs0nMiK1q21piIvVwyPibxdFaILMUQYu4L3Jpfvh1sX7AF2ZTyPMfFoewV/OAj/gWF6NW/Iys5X2zBsfEq5eXfe0c6UbeJKf0fqmKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 03:22:04PM +0100, Lorenzo Stoakes wrote:
> > What I think we can do is an mm-global flush whenever there's a
> > possibility that the process is losing logical access to a physical
> > page. So basically I think that's whenever we evict from the page cache,
> > or the user closes a file.
> >
> > ("Logical access" = we would let them do a read() that gives them the
> > contents of the page).
> >
> > The key insight is that a) those events are reeelatively rare and b)
> > already often involve big TLB flushes. So doing global flushes there is
> > not that bad, and this allows us to forget about all the particular
> > details of which pages might have TLB entries on which CPUs and just say
> > "_some_ CPU in this MM might have _some_ stale TLB entry", which is
> > simple and efficient to track.
> 
> I guess rare to get truncation mid-way through a read(), closing it mid-way
> would be... a bug surely? :P

Truncation isn't a problem.  The contents of the file were visible to
the process before.  The folio can't get recycled while we have a
reference to it.  You might get stale data, but that's just the race
going one way instead of the other.

> > > Hmm, CoW generally a pain. Could you go into more detail as to what's the issue
> > > here?
> >
> > It's just that you have two user pages that you wanna touch at once
> > (src, dst). This crappy ephmap implementation doesn't suppport two
> > mappings at once in the same context, so the second allocation fails, so
> > you always get an asi_exit().
> 
> Right... well like can we just have space for 2 then? ;) it's mappings not
> actually allocating pages so... :)

For reference, kmap_local/atomic supports up to 16 at once.  That may
be excessive, but it's cheap.  Of course, kmap only supports a single
page at a time, not an entire folio.  Now, the tradeoffs for kmap_local
are based on how much address space is available to a 32-bit process (ie
1GB, shared between lowmem, vmalloc space, ioremap space, kmap space,
and probably a bunch of things I'm forgetting.

There's MUCH more space available on 64-bit and I'm sure we can find
32MB to allow us to map 16 * 2MB folios.  We can even make it easy and
always map on 2MB boundaries.  We might get into A Bit Of Trouble if
we decide that we want to map x86 1GB pages or ARM 512MB (I think ARM
actually goes up to 4TB theoretically).

If we're going this way, we might want to rework
folio_test_partial_kmap() callers to instead ask "what is the mapped
boundary of this folio", which might actually clean them up a bit.


