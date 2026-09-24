Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E137C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F816B0088; Thu, 24 Sep 2026 15:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528586B008A; Thu, 24 Sep 2026 15:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4170B6B008C; Thu, 24 Sep 2026 15:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F078E6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:50:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A3BC1A0165
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:50:18 +0000 (UTC)
X-FDA: 85249697316.26.8EE6A2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7ED5280011
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:50:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MjHBmkcQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790279416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7GRre8UKUgbIjQqpBFebYRVHyGQlunCInkDxKufszI=;
	b=ZbC9uyj+doWxz5EAX7AUyGHwhcjvjUUMFzC0dzvNK8NVwDqwomkWCDebweg2pi9Vy4OPqG
	brRcSkCVC9YKJ+onjdZByHGC1XKEbjF/55m60X0Zmm36m+DDS/KI+4onNYMyNY4ByFk+VC
	6utVvWa/S6i1WVM0GMTnSJ4vlLaIQ9Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MjHBmkcQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790279416;
	b=2icjVM8xiznfZfXBAfdVp9QlEE2y0vFIIjGP6gqF5TP+/raYz184mh8WVh7n4Rku8/r8br
	04Ang2WP5m1YK9711MwxyyufpU4X2sYXXAjjPV/OGLThdTEusRgw3AAns7cHFDxC/Zv0r7
	Mc+H6IzIda3eZK0Wdz5k7i+M2qdEL+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF9CA40670;
	Thu, 24 Sep 2026 19:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453CB1F000FF;
	Thu, 24 Sep 2026 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790279415;
	bh=R7GRre8UKUgbIjQqpBFebYRVHyGQlunCInkDxKufszI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MjHBmkcQ/qd9t49haNxYHlTYpGVQk37oxGdxBtQQZoCApRCZIkkpIH62vPL3/Hkz4
	 +y3DiPqZ3dq0Cw37qn86Jgoisgo6S07xcFsmhtTC5ViMb7uRJ7PjwZho/fEDnfEO4j
	 RgEJYQhP27rF5OGwAOMOp/i3S6x4y5NL6oAhY6AacCRC/++DowaWH4hOj0dDRE6cwJ
	 4KMhXGS665+F63XbcZEv9Q6qa4Zq1Oka5xIOZmsDNu8ZB4EKwwd4xJXzl14TZ06BuI
	 XTW7jfK5RqrUgQhUeuIe9IJGy+nE8bc6SNuOaQX9CyOUx0/++A+FJM/0rMpkIg+Geb
	 7z3+Pr2a8Ut8Q==
Message-ID: <b6069b5e-4e67-4ac5-ae20-51301d926e97@kernel.org>
Date: Thu, 24 Sep 2026 21:50:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260903182943.662461-1-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3fjqto3droecdz4ofzb5cmdhg7fmrgia
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7ED5280011
X-HE-Tag: 1790279416-734908
X-HE-Meta: U2FsdGVkX1/HUuXFTbEcKBPh3AwK6uPZxhHeGkm9cQ6a6LOTGXvGHoCV6s43Ps2u2orcUL+Lw4YlZez1rY/IYdGFgfE5N43Pe5EzeHFydZpZJgbsCHZWUJjv7GcVhnmqS1KPqapwM13U4mrjXmFia5NjTHGImyVfjZqcEbK+WdpjeHB3Zzqd6xtLfO5mqo5w9LJOsIOeGlY7T+6jD86Cl8pvkAKWzX8tcMTb6D0qu3TXDcMU/1G0+eC1VRLJalZ5x6oe+ZZxP5heQvrQndwqiJNAZG3TizoFt78178tCVTI56yhJ2PLpbw50PZi+hpoUylKJTmlI71EO7KTVC0zHuKSY2wZCLeLSX7vqpD/c+vF29qsWwXJ6m0nG7mu7+GubXuax5xLQUt9hTyGlwGpvTiKlnOOywVQsOeMZrvecQHWhafFNW3FkP/WP0UmvQKIlMBg221RHmQnO7sacsuu9xNQVbteOTJ+usowwQMX2hF2hlyUtDmfqpRuv0ZByet2XzYcuioVfDAL2z0MA/pxxW7BHaYSmf89YhsatHuW+WtgLcG4SPcCiOGHad/IE/Cb7c22ShIOM9lLNkRJwAuR6t5cjmYGzh4/HY8rLysCClIRRDeA/a5QgCwF0/jkVgYZW9JQ0MoBI03v1fB2NbCw1GR0IDS9wRT23JNfAJ+431QRrsKXV/3mzFgp+7ne0O9MRVeRxwEGYUZIZiUD4Xsp3by3qTCAjxFRFSdkvLz3MAYuSsRS4IaC2X4QnBhXl60gB2xN8C9kdkYwXezEobXrIufZMRKlWqHKyWRgXpqyGhpwuxJQT33lMshtI9UvUsLy+0OAfoprBLCqeDT8NaBpgqP4bCBNUzDoNe0QaDPYCUQyNHGYpcg50+wj+1xPtSS9PQt2U3+KToEayMRj75PRZ1gygDFcPeFpOy+X+G8/HZFN+4vgcJKHldC573vUpT5dlMkkOCihd9pwB403CsGI
 qkEPrOmy
 K7/Lq75foUvHMy2gyv6JFlKwg4ydM6lr79uDJLVKZuRxaWdWy7EDZVfXWIyK6s2i4B8oFuLs8mhXmwwq6F9fpCbQtXS2E1Yy3+dwqLvV5Ur6HhZmAFyZcDeVgYOBr3MpAxzkfb3toLuMB2Jb55Z5dffJnntYGvFLem845A5HJI2ZWhGgXKsx6DmTrAcDugehN0s8kKx2hSmvHBDvnotdAmq7csxLXNuD6ckum3rroWgQ0X1P/ZRF6mHIYSuR8D05rD3A+cmxyBd1avCLc52yEbWsRIsVZIpe+e9TI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 20:29, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A store through a shared file mapping dirties the whole folio. With large
> page cache folios that turns a 4K store into 2M of writeback: one dirty
> bit per folio, and writeback has no way to know which part changed.
> 
> XFS already knows better. iomap tracks dirty state per block and
> iomap_writeback_folio() submits only the dirty ranges, and the buffered
> write path sets just the range it copied. Only the mmap path throws that
> away, because iomap_dirty_folio() covers the whole folio.
> 
> Narrowing the dirtying at page_mkwrite() time does not work on its own:
> set_pte_range() batch-maps a whole folio writable on the first shared
> write fault, so the stores that follow never fault and never reach the
> filesystem.
> 
> So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> folio and throws it away. Those bits are the only record of which parts
> of a large folio were written through a mapping. Collect them there and
> hand the filesystem the runs that were dirty, through a new
> a_ops->dirty_folio_range().
> 
> All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> it keeps writing back whole. Keeping shared write faults off PMDs is a
> separate patch and not part of this posting.
> 
> On a 512M file in 2M folios on XFS, storing one byte per folio and
> calling msync() wrote 512M before and writes 1M after, with identical
> minor fault counts.

Just a note that with things like cont-pte we see the trend that we only have a
single logical dirty bit for the entire coalesced PTE. Similar to having only a
single dirty bit for a PMD-mapped THP.

-- 
Cheers,

David

