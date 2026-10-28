Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965F1606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZSkH9Agj
Received: by kanga.kvack.org (Postfix)
	id 94C926B05B1; Wed, 28 Oct 2026 10:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7246B05B3; Wed, 28 Oct 2026 10:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C97B6B05B4; Wed, 28 Oct 2026 10:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51CB16B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:39:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C55C1160CEC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:39:26 +0000 (UTC)
X-FDA: 85372293132.20.538C07E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2DE27100005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:39:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSkH9Agj;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCisLb2VRu0iADmHFVpreIQCwjhWOtNKh8jVGOYf+aI=;
	b=h9l6q6S2MBHZGw+zC4EFovFxTpZMn9wgBhM2slLP1PwJrS1HiX41/ESS/uCZfxa51fgtys
	vVWw9izgkm8qq9C+WCZ4huvxIA7RVNSTw1RT9aKftMZmjtzBS3J0e5M8fM32pb5bJis9Gn
	mTjIofbzzeQV1tandBRYeevOeHFSxAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793198365;
	b=OgWPrKVhicFIwfCquuOAAW0LBrcjtYPu1Z+3dcjfR0zH5x+Zv8Cfo7IIX4yvJP4w983YAj
	W0BDzk3dO/wEWiYaoSPLHBgU8jpsBLKzt9SY9UEzMqDu/X8NewHl22TZaJcLilnZLyaQT7
	FBofgYIFwUx+mXuxHJ0Pnv6vUNHlejo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSkH9Agj;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66ED643DC1;
	Wed, 28 Oct 2026 14:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E39C1F01825;
	Wed, 28 Oct 2026 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793198364;
	bh=eCisLb2VRu0iADmHFVpreIQCwjhWOtNKh8jVGOYf+aI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZSkH9Agjre8913zHh4b1HLO9CLoDWHGYpW+eB4gbdBiovVJe478t24Jn9yGHNxstR
	 NP3qWYlZcSww8LVEBJOay+6O1zVCQb6abwW/yWG4rGwnOdaZEGKWV9TWCiRcQCL1Iu
	 ZxCZ7HPgK+ObNzmXs5+bwip4YNAuEJerqJYRdb3ojfheEifO+CePt7FLeoKRUuWYt4
	 BV2heYqLTv8c1MrxPK5dWzc/kblnBlMKbNVu/dmqaJjvCzMsPCOO3YeB2DJSPpQJ1g
	 ninPoUCoeJstjgmxEhmJCf2v43wqA6MB5Aqf56sdir1SyzSj5+WAzPGa9MdivRK4kQ
	 asfMvotu/x3Og==
Date: Wed, 28 Oct 2026 15:39:16 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frank van der Linden <fvdl@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, kernel-team@meta.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_vmemmap: map the shared tail page writable
Message-ID: <auIJFHg1haY5c937@localhost.localdomain>
References: <20261028132623.2560146-1-kirill@shutemov.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028132623.2560146-1-kirill@shutemov.name>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2DE27100005
X-Stat-Signature: qwqmwdkaqyf76btsrgaugpzfk3o4ijcg
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793198365-654756
X-HE-Meta: U2FsdGVkX1/KdIqQUEuFhmoecRaIGQDCAIQ4PxLXlGvNLLWJK+ZtnMYdRAwrf+q5IKmzaFOUY3N4LxkAzZJ4WtEabFRaKQKnkZpi7dZzYW+uPITINAuzJxekMZFZ9VhzoH0T9sgFgTJfxhIOpDNlJIShcdlXICt+76xIEoCcqEtelP5NGieFg7nrIe69emmLPqghg9WuCWuSwbXeKBpYw7Tk+dSxK76oaBv4UF+R/3GtMc4NxBBl55VSx2Nnyc8J/98ECPUIe5OALp8PjvZb5OfbBoT0H9z7O8HRlfl3JuOF2mba1ZePEOCGYXSYxAnLbg5hAC1rAos9GgE6mYyECtY1pWb5He7pMp5FWldZNBNXewQt6fUeudc3mRDonu3nK+VYrDGO3sEP+oo20tsQsi9HdZJ3PqGwBT4dqgTkt18JFaEeLoFtQFsS8Nwzn3NkyIYbkIrvAySD4Hn4eptKKV69lvJctoEuo1IIeKFQIrZdiTMXV8KMPTUoC505hobaKPpyeT7n7scnafNnsjRugXbELq+rl7r15mARPk4ujpLVDM4RoJ70sLzabfI36uYDCsou9CC/ybwWOUSsRrsiRIEMmHhK7ib5+0+XAqou04anuPcTdxmStM8X25Xv7zGb5aJBE4EnKSXvwNOYSgA1DzFigQyVaIDBgfxtZG9vbCzpFimxnnjMSuW1KNCkDbsl4lX1bmfD3/bsmQ71CTe5avT4jTuuhejlo6SyxscSpo2YUvzk4z/SPnt6YavKdEjzB7mxQypMtSi792I7qFGDY3PVj59D3/HHGbNIO53naiK0ATr/qKszWgk+/VrG0H5dmDJW+VbCvTX/dN0KcWJbXsHy4JNTge8CNiQ+0DKGRAuip6Y/iUY09AV0A4xE5wZJ2ZW5tfQBlydm4e+BV/BrBstfPsz21dPf5tNrvgjhbyNrgfy/Valygy41sOfN55+hQK6zet4da8OBrXpjxag
 MhkHYwBj
 A8D9g245QzYGbCmfmdBuTV7+tNkUnznv8SxJur4/jjUCFaS7I4EehK/EbdnCjrZe2hn9XRCxtrFNOzKywK1rCUKQOld/cylvGP6iFelNxiYS/NRhqc4QZDmFvBRnMMwNjVcQgQqwI5aZjC7xixzq1pgGeXEMlgfLHsJW8RQbE0A86o6KCIHnGVqwMmPDNLenneFxbwpkVoSXEQw9UsvS8Vc9q057IyuK1LIuZvCHLTwv6zmlPgTKvY1AyqWS3EKAJVrH+KFZpy91iU5Reqs+14p/SnWkT6LkZSZnl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 01:26:21PM +0000, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> page_ref_add_unless_zero() reads the refcount and then updates it with
> a cmpxchg.  A lockless get, such as a page cache lookup or a PFN
> scanner, can read a non-zero refcount from a page that is then freed
> and reused as a hugetlb tail page.  If HVO remaps its struct page to
> the shared tail page in between, the cmpxchg writes to read-only
> vmemmap:
> 
>     CPU0 (lockless get)               CPU1
>     c = atomic_read(&page->_refcount)
>                                       page freed
>                                       page allocated as a hugetlb tail
>                                       HVO remaps the struct page RO
>     try_cmpxchg(&page->_refcount, &c, c + 1)
>       -> write fault on read-only vmemmap
> 
> The refcount is zero by then and the compare fails, but a
> compare-and-swap instruction needs write access whether or not it
> succeeds.  The kernel oopses when hugetlb pages are allocated at
> runtime with HVO enabled while a lockless get races with it.
> 
> Commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN
> walkers") closed the window with RCU on both sides.  The RCU was removed
> together with fake heads, on the wrong belief that it was only needed
> for them.
> 
> Map the shared tail page writable instead of restoring the RCU.  Every
> struct page on it is a tail with a zero refcount, so a late cmpxchg
> fails and leaves the page unchanged.  RCU would put rcu_read_lock()
> back around every get and synchronize_rcu() back into hugetlb
> allocation and freeing.
> 
> The cost is the protection against stray writes to tail struct pages.
> The shared page is shared by all hugetlb folios of the same order in
> the zone, so such a write now corrupts all of them instead of oopsing.
> 
> Bootmem folios optimized when the memmap is set up keep their tails
> read-only.  Nothing does a lockless get on them before hugetlb takes
> them over.
> 
> Fixes: 32c440d67e6c ("mm: drop fake head checks")
> Fixes: 01b1d0ffb6f7 ("hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU")
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Closes: https://lore.kernel.org/r/ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>



-- 
Oscar Salvador
SUSE Labs

