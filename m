Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE27CCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257D78E0010; Thu, 23 Oct 2025 16:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22FE48E0002; Thu, 23 Oct 2025 16:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CBE8E0010; Thu, 23 Oct 2025 16:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03B988E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:49:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ED0813C241
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:49:33 +0000 (UTC)
X-FDA: 84030569826.14.50A92C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BEA214000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:49:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N2obuoXM;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761252571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NFj/MEBadiilTVjlma23Y3vSFBmUz2bMx9GhmaXqOg=;
	b=Uzkz1s082F/W/3n5lRFN4QFZXN+wmfZXGppMdk/1RPsz/uD3d8G6LSZ+BGlM86n5fjGQGh
	KGAYdqTY3RHrcbxz4u0JAo0stiZU4NUZAtCCEY0icXgc9xxN2ezazvc5S7YmnR/gIOl7ij
	J4Gu70EUVNcB2MsT/cyZv2yQNHhvM4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761252571; a=rsa-sha256;
	cv=none;
	b=qD1e+RDr7oGhR0NDkF4yPcIFWVJcltf8YZhkriat2FlsAey1/5YGbERENe4U1G6MQ8Resu
	qGVNCDwjDY91oyawfRBFdCJxXP3juA0ts0rYD0mIx+wT6FdFZdEgyDz6vKR4bW/X3Rhz1s
	eV8xrvQjp42oXlnVlhRtsoJlYXFzJPc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N2obuoXM;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 966B64B0B8;
	Thu, 23 Oct 2025 20:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B691EC4CEE7;
	Thu, 23 Oct 2025 20:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761252570;
	bh=Zw7HUoU/mxy6anYY+mNGF83QxOEilwzO+J/cvE9hvo4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N2obuoXM9Upw3c9OeUsYyJNs0Wk4sPv787zfdDZnSst/fqNqtgiC914hOUgO0a7Dh
	 wRl85JFjBtECY82WuxEi0OSdiiYllkoB7AWvjI2QpVrHGLkVAgPK9prcwDiXMbOGNX
	 YUMV0PUqlvq4DsU0o0g1qnlfIDYydyka3fnn11xg=
Date: Thu, 23 Oct 2025 13:49:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-Id: <20251023134929.b72ab75a8c132a17ae68a582@linux-foundation.org>
In-Reply-To: <20251023093251.54146-2-kirill@shutemov.name>
References: <20251023093251.54146-1-kirill@shutemov.name>
	<20251023093251.54146-2-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: z5t8omb5ugorebnxqsu83g1dw4adcxp6
X-Rspam-User: 
X-Rspamd-Queue-Id: BEA214000D
X-HE-Tag: 1761252571-559120
X-HE-Meta: U2FsdGVkX18EiS0FxdN0m5Psb3XzHXUHNTeMHnGABvzmE4bVwCPjL+pu6umsi1gaG7qUOtfYqouu2UdkHApnN9z0HwLI4LOlYRhtIshYTHitubtJ9b5oypGUUZ7LPAW3DvESVgrlFOovMT0eDahB/Od55wFdpJbkhYtmL0NkUKbAbLBBdet3hwp+Pn8pOnM9xkCrXf0I+iw/ZryCTnJmasm1d4+Az4/SbFvx/dZI50OCISnzsRxnmmrE6lR3bdyS7naAFHUyL5FQxsY5/95VQqAXdAIFbdKz+6rKNiNBAB785AZzGHMpCdOMPmhuN7L/hNTiyMD/wMh7NZgodcI+ageDvru19HohMIXxCGFGKQMBMHqAxiOc304AZVXWn7wcFwr4ArrNfgtTt0DUg0A1qYR4R40Xx6vIOjrzbPrdZFSzvmKXa19oMuGncJSHga6SacbjplYlzVX6uju+nbTw32TgVY8prsbS2+eOVwukbQpvTBWa9r9wvbfiB2zXtmnoljEWIiPWSzCcBdwr/E/CHQfwtc3CKxoxfJacaTjF+qbnNfpVncsgs38OZFoY32LGzzLMpMfrXQSdjJdIfFqjAMxPDb88+nD6Lf01sF1N4j9ZiiFMDd5XkZ7ZEoxpnYrsvFjOaNHclMae3oKfuVTchkJ+GWu8iTesdXdMGQztan7eMdMB0mDFryGhmUldJQ0Pvb7WyD0JK/aUSk5TGZ3oseyNn8NJQgz5CS7VqDq3QBfn3dVHvqvvYENSFF7iX7e50Wg9+4k4GuM/Q9h0vkyvFZOtJJGlijIfrgF8+j7RFij2twbKI7mQs0COgc4uP7QpiUd7sMCK7pRtYO66Xyg/gVn4xh1j/EoME/knlcI8UGn6d+USe9B0xqMcxR3m10607fQnQzSGtQhvXvU0FZ8PlADBQQMHOuwTlx9XJM44LjnOBDNamyuYNwE480zraIcr/luLdqzh5VfFEynhgNs
 6I/QTenD
 amZLoxuw/bcjWhgUCnW+yXm26KId9rewyj1WJ39xoTcLIb50iU8PsbrcL7SY8Xz0saZRZQ0694R+7196W+1XXwv0edNfC0NfNOF62XS56oSiL28AOm/BRTzgYSDoiY9esIaRoAdPjlmmVsSiKB65jnnjzoyr6RCoVewWhEAw0rYWLbUqw8k+9wIO20/HdaxqHfGd9koxtJc/HPDDeUxY66D3WmTcrRNfWOfp22qfQZuSinhOblYW+tyBX5mhtpQdBjk/4YFnMfPeXtsj8/+ZecTXauC78w+KphQ3gxo9oGASksQfXlhpTLHBQ8pXv3pap37bL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 10:32:50 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> Recent changes attempted to fault in full folio where possible. They did
> not respect i_size, which led to populating PTEs beyond i_size and
> breaking SIGBUS semantics.
> 
> Darrick reported generic/749 breakage because of this.
> 
> However, the problem existed before the recent changes. With huge=always
> tmpfs, any write to a file leads to PMD-size allocation. Following the
> fault-in of the folio will install PMD mapping regardless of i_size.
> 
> Fix filemap_map_pages() and finish_fault() to not install:
>   - PTEs beyond i_size;
>   - PMD mappings across i_size;
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")

Sep 28 2025

> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")

Sep 28 2025

> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")

Jul 26 2016

eek, what's this one doing here?  Are we asking -stable maintainers
to backport this patch into nine years worth of kernels?

I'll remove this Fixes: line for now...



