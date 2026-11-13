Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C2D606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DpNmXlrE
Received: by kanga.kvack.org (Postfix)
	id 5944E6B063E; Thu, 12 Nov 2026 21:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56BA36B0640; Thu, 12 Nov 2026 21:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4819F6B0641; Thu, 12 Nov 2026 21:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21BB46B063E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:29:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A475280246
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:29:30 +0000 (UTC)
X-FDA: 85428514500.27.53CF0FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB7B020003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:29:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DpNmXlrE;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794536969;
	b=6Ihfjys0/2wEaFdhBQW+6uAm2LmDTfWL/DpxRwNH/aR73UtrSULnSggB4ILZmG+Srb0J2+
	gFZeq5raLj6ntQtyP5uC6gQXP72BODdscMrn1gEaNtWcpdRx1zrLr2Da5JxpiD/AydRhOM
	NeGmXpF7SkaEUAD0/qoRI5wFUPLJOq8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DpNmXlrE;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794536969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Raodpl8vL3TKabak0c6oEO9mzM/EGv53fn3bT+vKQ4=;
	b=eU+WE9Tv6H8fswvs4qGnccFMWIZewlXaPWKYvoT2WOTDBvP5jGZibdx+B45tSVb7vABvjp
	RQ+zN7ebtJlrUXL5+j8+OL8wn7h/VWRC7SrGG0PRcqf9lCMZIDPd2ukexmZjWuJv/RK7Ya
	56tRifBf5Z1ItnL3L2lEZK5A7R7TVDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F4AD4484A;
	Fri, 13 Nov 2026 02:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373D81F000C5;
	Fri, 13 Nov 2026 02:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794536967;
	bh=3Raodpl8vL3TKabak0c6oEO9mzM/EGv53fn3bT+vKQ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DpNmXlrEQvDVvglPuf+1xK3d6VyatMSOfSp9Nwd5YSKyaYMcPJWknK9bPWrRtfmPO
	 E8D3nr1+eAAKcqnnr11SLSDjXz6zjLjdh1BKIUK+Fz/hh8KxeOoSlwhPCeQ3HvexuB
	 M2Wp4WK/bjvmjZCNWalm7fFis28J5dMyDNUjFYNo=
Date: Thu, 12 Nov 2026 18:29:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 <x86@kernel.org>, William Kucharski <william.kucharski@linux.dev>, Vishal
 Moola <vishal.moola@gmail.com>, "Alex Williamson" <alex@shazbot.org>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] mm/huge_memory: don't warn when a page table
 blocks a huge pfn insert
Message-Id: <20261112182925.6ce741ec3584e9401ed94238@linux-foundation.org>
In-Reply-To: <20261112051440.16140-4-farbere@amazon.com>
References: <20261112051440.16140-1-farbere@amazon.com>
	<20261112051440.16140-4-farbere@amazon.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB7B020003
X-Stat-Signature: 3nzrx5t9yszfo4emoncbymrgchtiwib7
X-Rspam-User: 
X-HE-Tag: 1794536968-303358
X-HE-Meta: U2FsdGVkX1+75COL8rKx83ePAnMoP6R8eYGmq/GAXVvbgQf9+4PCBGSwkXK3pWrY3yTPs0/rFThit3fJSUIuU7Jc+tBUJxLImQOUVki2MBXI/fJyWjCy38J/6SDaqnMiPESiBIsdO2bjZMGuKzqPpQJB7IIlKwdHQDlNqImQhDUCMU/WAl3iY/FbZssvKEOGIbZSgUTKv1HV2bkXfp6gHe81Nj3VFhb60VavsX8h1Wvhl0DBQCH58Vg//6LqhlFiH1zTW/TfIQ+o80ckEKdX3AUCJWNUMdqwuh02GkE6WFMRvSdbB0cIPCSOHYSHBu5TCVRX6PWZIIjkN22w7uSulFU0ZcQINRxKAuyhjE1D697foAy0YmJL3NQmU6lEvWEe3wbkFJaebyXkcuSOiAhm9hgSpOiEJpw7FsY4vN+m9A05tRvLCYcT4MhrPqabr+N4r4R5UKfeJo+c91iTQrs9uUcvCxsSFzVkBTraOml7P5MR0llLaH7OcaY8t1ERehJiLlkhUMFk0ThFyF14XpCKj4FAorIOuo3Y1K9My7C33aAlj8AUPwUKECEc8ZZ/O8zsYpai+lpf9WE4KW/1U467zp4XYDiojEBF5xkwtLHD0fxS+cF+QlcItP0zhepUZhszt0yxjP3H5acrhFtWrw7hiN0k3B0mRXtijKAoCBr5wZghyarqzc/B5xPT4BLA/9xL1VY4GIFTVUHCnawDykF0vp8s/nV83KgoVxDRkHT8nGMFC5fWl0fmCO2w+dcC+3AkBtLx4WDSFf7Btsp0sfaV5qejqGaqBeEjkLTSshRlRvOsCyuKT/gDznCOptM50+d8gIlM3LsUzZfYqwRSysw+LXUUITq513VtsbyHt/8BsEO53ltx+RW7ChCtDW+AKOvpIoARMsZpVSBb3oWz71sHqBLlAg+znNDtatTlpXDN0HR8LGYXzZEcjrw/Lqxj67svTz/PL9zpNwjnwBd8VJm
 w7ELzRlL
 gQa/KR32HkIRzJFSF4lcaiLXAPToxqmB3UDh57b1Yv7O2famPHZgLdaDyI0HG/9ykZ9w/tL+3+jPe8Zxd6zu0sfOhpPN0EmQLBlDyTVQhjYoFQRYnetwiXdykq0sneIQuv2bOYY+w278QbisiHT3PT5sae99N+2/436WFllFzO9+oGSnIN5h26F5ttyTPOpM3MGaNheMWB9sCVBXcGCfEI3uIaxu9nw16X3nIpHn5/d9Rl57kXF0OxFI0W6HFznpQBeq+kQ/5A0SYqUVJbEbf1hJVnhk9p/kaWTSgXBWNBbF2QnFZpZqzb+ePMCFNh8iLBJ6vO/KcDQnXQc8Bj+6pJiitP1To4pGu4cBorsFjFDiAwwlcUChN+hRqilz6l3ZrrmDLNBSXkKKdvATBispRHEXFsAbFHSB3Sb1AP/SPuaho8xYfs8aZlcXBJM+3jJXmjUs1k3jCnoiZIBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 05:14:39 +0000 Eliav Farber <farbere@amazon.com> wrote:

> insert_pmd() and insert_pud() treat a non-empty entry at their own level
> as a leaf and compare its PFN against the one being inserted. A page
> table installed by a concurrent order-0 fault also makes the entry
> non-empty, and pmd_pfn()/pud_pfn() then report the PFN of that table,
> which never matches. insert_pmd() warns unless the entry is the huge
> zero PMD, and insert_pud() warns on any mismatch.
> 
> A VM_PFNMAP mapping with both ->fault and ->huge_fault can produce the
> mixed orders: an order-0 fault installs a page table over an address
> while a concurrent huge fault on the same address reaches insert_pmd().
> Changing an mm's THP policy while another thread faults the same PMD,
> for example with prctl(PR_SET_THP_DISABLE), is enough to do it.
> 
> Compare the PFN only for a leaf entry. A page table is not an error, so
> take the existing out_unlock path, which returns VM_FAULT_NOPAGE and
> lets the access refault onto the smaller entry.

Thanks.  Sashiko says this fixes a cant-happen.

	https://sashiko.dev/#/patchset/20261112051440.16140-1-farbere@amazon.com

> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")

But that's because Sashiko only considered f9e54c3a2f5b.

It seems that DRM shmem and Panthor and mshv pass FAULT_FLAG_WRITE and
can reach the warnings.

So... patch looks good but the Fixes: might be inaccurate.  

Fixes: c6f3c5ee40c1 ("mm/huge_memory.c: fix modifying of page protection by insert_pfn_pmd()")

might be better.

Also, we don't want current production kernels to do this so please
consider adding an explicit cc:stable to the patch.


