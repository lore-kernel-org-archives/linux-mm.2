Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE30606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BTAmTlEP
Received: by kanga.kvack.org (Postfix)
	id DC2D76B00EF; Sun, 22 Nov 2026 02:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73A96B05B0; Sun, 22 Nov 2026 02:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62606B05B1; Sun, 22 Nov 2026 02:30:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3DE06B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:30:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47DA71A05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:30:11 +0000 (UTC)
X-FDA: 85461931422.02.2828894
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 56AEA4000C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:30:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BTAmTlEP;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795332609;
	b=JhOeC6X87fXq9WZfLTU6WtZ0p8vesy23YS8D3hT5dnBASlfQ/DFeXZSXJm4DV2ow3diJeS
	fjAk7wPmzGNlAtSLgp2odu/Cjfo/bQVE8mZhiavcgHbfzqq8VPPwlwMgBrDlJP5ixvMfQm
	y4/rjPdq6lQVsPccgayLkHiD/STRLOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795332609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXWNYjPxX6wVtAP9DzJE75Av2qUwSEdpN8RkrP8QOpw=;
	b=toBnZLky9F1lShfzDSyxEyDnWL9U3Fkt7lepEqpN36gBqSqWUyw7q4HVf3kR/wJ25GKeTj
	tkCQr1tRRf7qsnNZ9+CoeYjPcbLBoHHF7PqNPnA6oe9AZl4TJv96lL9+Q6VrWBpwh1LOxo
	7wPnMflbzyG5Gx1J77ixIVDH0amEOYY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BTAmTlEP;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B17D40760;
	Sun, 22 Nov 2026 07:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB921F000C4;
	Sun, 22 Nov 2026 07:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795332607;
	bh=uXWNYjPxX6wVtAP9DzJE75Av2qUwSEdpN8RkrP8QOpw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BTAmTlEPmIlgFRIx7pww1JhEV/sRwv8Ng2+2iKg4j6PzgRMqGv8JHOaw42mKXj1PQ
	 sM7+AGtDcm8o9O7CfamNPvuyk5C5YNACkYV+YjlZkzN0zYEwAYTR+9zcTmLWp3Dv7L
	 s+bN1UUxXk1Y7l9a/bXUa2cijblzhbqciIoFoE7s=
Date: Sat, 21 Nov 2026 23:30:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shivank Garg <shivankg@amd.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Borislav Petkov
 <bp@alien8.de>, Ankur Arora <ankur.a.arora@oracle.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "Thomas Gleixner" <tglx@kernel.org>, Bharata
 B Rao <bharata@amd.com>, "Hrushikesh Salunke" <hsalunke@amd.com>, Ingo
 Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, David Laight
 <david.laight.linux@gmail.com>, David Rientjes <rientjes@google.com>, Linus
 Torvalds <torvalds@linuxfoundation.org>, "Teja Vojjala"
 <tejavojjala@google.com>, Huan Nguyen <nhuhuan@google.com>, "Pedro Falcato"
 <pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Message-Id: <20261121233006.bc03ca9b7889c93a482791aa@linux-foundation.org>
In-Reply-To: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56AEA4000C
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3tafebpftf7cjoobiaxeb89aty4d7q1u
X-HE-Tag: 1795332609-290577
X-HE-Meta: U2FsdGVkX1/dwLgiRRFLSvntS8zPW4wGn2aQS3GtMhaTbYtvPw/jLOMaWuu7obT8MKTDqRd8uhrO0MojH0l8gtAu31k9LhVO2rOdNm9HRDY7d0lKQdqKPDv6S3fs8J4WFBEJS4XF0gOoVNMcCy327jzrmge9enlioIsg8mLqyeHQFgVOS/luVJnUsuzbz6yIalTzBgr2ff87sajd4Jxxe5brRtoAAe2jETAu2NbZSV/xkYlEL0grF3+UvROgLeeYbXkItnrEmt6Kcf19otBnhUJGJj4DpToaX9vLbdNGS2CDK0EWAGyeqTyQqV4+TcJeeYe6FvtZuzZgM6MEVYFL2NXQUcFYvu7lquCTEpwOx/PMP5JLxeMAg/QqSL9nkmjVCudhHOzze8qotBtZVXqFcFHIhB+ARlRuP6KqwqOeD4jCpixBmKphNf4H8MnXcjg3mTtHGfO9Bczg18rkbpf7JhGNsek+f3WZ2QmRXkJA+X3i9Im8BoxbS8TqzK1sIZTEHLez/DH66G3znh8ZghEKevAd8T/v8N4Y+Xu0hcn14MzuKtsE9JLNcJti+Bvuz7f2uu4O5MLMVx3TVmliPx4yxDJarlb6ClffZqXOGxsYsnXC3OhbxpoxAbxOjcr85FEjmgqAx1LRy7uaDIDA8o6WMP9GIubQhwLajjbNV1ZeWw5u4+RPpc/i5Hv5t2hbW5fNVWm7Gm8am5kOB7kujaBXF+mx1QjueYjfQylB7m190KL79E71WXwgj5UbVe0XKOhLYAjGA1RKGubTs/KgFYYDCs6k+UVxYxKhMBtdrOLEZURsrFzWrOin3lURcFWwC0H6Nti+ryQHZM35kEO61a/Dif9RoUz/qGbDLsB1WRHG67u+XmE6m/OpWAkqOjbIT04Gz3TcTFCtdSZI9Sj/xTBajZGNnUFiN3iHhUhmAh2Vs5QUgCWduTm4S+vQh1vcEOA8Vf53PXWrBal7LkYsWEC
 +h56lcUN
 qb4ef6wrV9ietHBQEJq6nNaFgEsRt6aRQJr9jlmr23Rn3Bk37n2bQWW9hGjrvzjw1KdrtaA/3Yvw7diKmV/rN+FAnSMOKK9A+iO0izVAzRclgFVrqpaYuImH1VPgXxe8LUQck2pitBVbGu2E+rQDM29WoU+PwCzlgQtTwdhIsuinkHn+dNIahmXJFzKGe9V21Vn/7SpJPH7R8B8d1kcrh/n9oYL0siPvUIsi6PSELX96y80HfmWV0RQdCqc6M+21SpRodDdzX4zgTLOURnpv67v8Wr0qUIeqDsuiCEreTkPf9ZJ/RtpDKnbL8oHE39SVK9FT1YesO6udRbXcaeQ3wHcaJ0TkWvZ1lFx5dAHSiuH7zW3H8VGC48l0WYcni5KYkr9DiaXypXSnwoEDbGvEHEaNDd5lH9puhk+WEtL/Sd0XAkxzm43rvM0yfH+0/TCJbE2igbK1iHfRxbgveZV8dkidJ7cK0DhxHDVGi89RTAwS16Ac5qdJvhhGQziyhcXMH0F3PeM7V+dUSfLnh4vdDPpeux5iLgM7M5KezWTNGpsGqID63nzODMVKr1U3zanGfS+fislD9ban0tOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 17:09:21 +0000 Shivank Garg <shivankg@amd.com> wrote:

> folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> so a 2MB folio makes 512 separate copy_mc_to_kernel() calls. Each page
> pays the startup cost of the string instruction ("REP; MOVSB" on x86
> CPUs with ERMS) plus a cond_resched().
> 
> Introduce copy_mc_highpages(), the page range variant of
> copy_mc_highpage(). When copy_mc_to_kernel() is available and the pages
> are in the linear map, copy the whole range with a single
> copy_mc_to_kernel() call, so the CPU can optimize for the larger extent.
> Otherwise, fall back to copy_mc_highpage() one page at a time.
> 
> On a machine check, queue the poisoned source page for memory_failure(),
> as copy_mc_highpage() does, and return -EHWPOISON, as folio_mc_copy()
> does today.
> 
> copy_mc_to_kernel() cannot reschedule, so only take the single-call path
> when CONFIG_PREEMPTION is set and the copy can be preempted. Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes"), x86 and
> powerpc, the only architectures that select ARCH_HAS_COPY_MC, only offer
> the full, lazy and RT preemption models, also with PREEMPT_DYNAMIC, so
> they always take this path. The per-page fallback calls cond_resched()
> before each page, as clear_contig_highpages() does. Other architectures
> keep copying one page at a time.
> 
> Switch folio_mc_copy() to copy the whole folio with copy_mc_highpages().

OK.

> ---
> On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for
> 2MB THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).
> When demoting to CXL, kswapd uses ~31% less CPU per GB demoted.

But that's the most important part!  It's the whole point of the patch!
Yet here it is below the ---, which means "throw this away".  It
should be the first paragraph, in all caps.

<edit edit fixed>

OK, thanks, queued,

nit: does it really need cond_resched()?  That's not appropriate for
current mainline kernels.  I guess "yes", because this patch looks like
something which downstream people will eagerly backport into older
kernels, even though we didn't cc:stable.

And we care about downstream people.  Globally: "Roughly 60% are on 6.x
and 30% are on 5.x (with the remaining ~10% split between 7.x and 4.x
or older)".

I'll take a look at that Sashiko thing.


