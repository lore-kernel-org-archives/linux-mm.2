Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE86CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865948E0085; Wed, 29 Oct 2025 11:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CFE8E0045; Wed, 29 Oct 2025 11:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B248E0085; Wed, 29 Oct 2025 11:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63FE18E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:19:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CF1713BD5E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:19:51 +0000 (UTC)
X-FDA: 84051511782.21.E2EF5B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4EB9120011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:19:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGlaV1NL;
	spf=pass (imf13.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761751189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=905SiZeBai+UQSJRdiY9CUAdZ9Uv6Hkt/YZhTiImmes=;
	b=T9zGi+oHVvXdkkLy8GtIyrFdP9SwjIeZgSLu1dBLdT8cjUD/+DZ/VZQU2A2KE4AeuJwG+/
	D8ZlZJyoUAqfTaKvmSdk7Wr3Vr2nh0zDyMpovmSKKp/GhssMIZZD4VwX+P+USbHw6wzmRr
	Kvx87tmtXZYnWjwzUpxzeUWGpbqXUmY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGlaV1NL;
	spf=pass (imf13.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761751189; a=rsa-sha256;
	cv=none;
	b=7WJwxXeS0gnjxosZ9POyu7bT2DgaVi1HLxlE9o6jvHTec8bsU0g2JchDRCao01LZwcbBGx
	bGY/atVfYtqGGzLk6sa/FMnbgSmIhrx9kZpJn6vKqG6Q+8Mt1cpcnVKLBZYeGIpwjg1jx3
	nQjPGk6z6weYuyc23rfxWn3FU4WeULU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5519144CF8;
	Wed, 29 Oct 2025 15:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27021C4CEF7;
	Wed, 29 Oct 2025 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761751188;
	bh=qbQeMVbo3l/1GuPlXKkSxZu63+LRj3CaWonnsm1omOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WGlaV1NLoi8Trlg7yWiQ4wTETMtoEv8SYUn51u6cYoJZDz1zsKrhloR22pgobKrtL
	 gZme/C19Cq/w9BkaBXGaAhYFqPphMZEox3vaLKF/hKQGrj4C7ktY+hd8iTjBNJWQ8U
	 ak4QYOswrIHVC7pytc+ndXaQFAEwMC1IZhPkQb4MlD6/yerKL8saSrBcz2K6QIBpG2
	 yd6Qxr0fqSIldgKyCk7PlcKquqckQ1AqLRnJDekHy8IDrnxAAcfXnqzaBg2yyt5KYa
	 nw6r6bx6jLEVJYKq8PfrrYB31z6oaeIvZv3nHtF/Y+oQXsGMMwgyqBtBJSCMTSF85x
	 CXeoVFZdWVrdA==
Date: Wed, 29 Oct 2025 08:19:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <20251029151947.GM6174@frogsfrogsfrogs>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
 <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
 <qte6322kbhn3xydiukyitgn73lbepaqlhqq43mdwhyycgdeuho@5b6wty5mcclt>
 <eaa8023f-f3e1-239d-a020-52f50df873e7@google.com>
 <xsjoxeleyacvqxmxmrw6dxzvo7ilfo7uuvlyli5kohfy4ay6uh@hsrz5jtkgpzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xsjoxeleyacvqxmxmrw6dxzvo7ilfo7uuvlyli5kohfy4ay6uh@hsrz5jtkgpzp>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EB9120011
X-Stat-Signature: dhw8wntba37q4d7ed6w1bqnriqz54e7z
X-Rspam-User: 
X-HE-Tag: 1761751189-199949
X-HE-Meta: U2FsdGVkX19ZJgkW06zY8jqFq/Pgc+AKc1P44LCUoPTyCvySBbTdPIvERjbYWE+4+rD+Wg+Bk9uVTCTSsUF8a1WXmZSbEwp5E3dcBojCZ9U/vZNAk5vSOrtFmectd8duvPXSAg7N15W09e0CUDUdJZVf3LnYXZx2osC06s1ae5ikZetTKS32DazpoIeU8N1yoZrZJnpFh04RTqsALosp9YiRO82Ba3LFpX44rqPF6qCnBo55/0RTa699PxaS3/B7Uh4f9e9yaTzohIJYfn377Qkv75WKcBjmil3eUVGDN9DpSaIgxKNHhGpYd16LgcFLEP4GCwvz1MrFK3vfZJpnBsmJk9EC9mJ9lmAiyZM/gfehhYVPAdtgRgrOiusMVbJYumAGb3jygs2DfXOmbDYrO+K2Cy/QuupqjkAEjeAQTdSI6ax3WZmGcjTCuggY9r1YbUVLbd1E45LS+WgWZWZ4F/QE+Ds9otnl01+AerrUnMDEpf8RIVrE564qpC0ugoOiM2dgaqjv6+mVvTgRyFJewYKzrNqlX8HQuKsUPJ4X0tlr+vfnDZCmkafc0oF4uU+U8qRe0X6d9A4ElARmBflCneFJXSOdFktXEHCcDCam7yWV4r55a+781iBaf70IF8+cZlGou3aHRo7qzU+I56EMtG8Ow+wnkyuFZKDpxhIKoY0LphZ8Ps1moRYtcFdGf7dz8U4s4Cn6ZxezWs7CxlR4Lep76x4EE92qC0Q1kFKpApqzLFy60SgMVI0rrv6hBSoSWTcygSMsuKgDb6FjSO66D+3O6rBc+Dgrw5FA2Ic2W8Ty81EXDDnwX+1GQUd4SLLV7UhOgM3BWRH0uCuA0fZEWneMo5VRpNwGvA3VK+Iu7AJBwVVXF6+ucFEn5Jswbx3/1jBR+0OVOAEn5jNXP7K6Wt5ifxLapTp2qK8/7GOz7P33VPbbmZMbGncIWnqMmyrkLmWhE21ZYRKfuzD0Ib+
 fkuxZCMD
 4LgDnIH4aRojUU/u+5sqsrqnGAZcki+VkpS86S+yU4cPvP98pqW7pGgQWJu27kiloJ+5VcwO8xJ2dyS4U4ggOpcIDP2bGtl9KJfuz0JVq4Qubmy7DJJ05O9csRvPcrI00rBJJVAKQ/tLUEE7HSP0GJ6RSSKh7+Zb8lsOhKXlB3JgdVn+kDOlcpOQoE7bkirkUVQn3daNg8MgPWSvLdj/7uofF3gIrA5WYRuMsJjNgAc4oDhz8HKhlY7NYfey57mX0zcRo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 10:21:53AM +0000, Kiryl Shutsemau wrote:
> On Wed, Oct 29, 2025 at 02:12:48AM -0700, Hugh Dickins wrote:
> > On Mon, 27 Oct 2025, Kiryl Shutsemau wrote:
> > > On Mon, Oct 27, 2025 at 03:10:29AM -0700, Hugh Dickins wrote:
> > ...
> > > 
> > > > Aside from shmem/tmpfs, it does seem to me that this patch is
> > > > doing more work than it needs to (but how many lines of source
> > > > do we want to add to avoid doing work in the failed split case?):
> > > > 
> > > > The intent is to enable SIGBUS beyond EOF: but the changes are
> > > > being applied unnecessarily to hole-punch in addition to truncation.
> > > 
> > > I am not sure much it should apply to hole-punch. Filesystem folks talk
> > > about writing to a folio beyond round_up(i_size, PAGE_SIZE) being
> > > problematic for correctness. I have no clue if the same applies to
> > > writing to hole-punched parts of the folio.
> > > 
> > > Dave, any comments?
> > > 
> > > Hm. But if it is problematic it has be caught on fault. We don't do
> > > this. It will be silently mapped.
> > 
> > There are strict rules about what happens beyond i_size, hence this
> > patch.  But hole-punch has no persistent "i_size" to define it, and
> > silently remapping in a fresh zeroed page is the correct behaviour.
> 
> I missed that we seems to be issuing vm_ops->page_mkwrite() on remaping
> the page, so it is not completely silent for filesystem and can do its
> thing to re-allocate metadata (or whatever) after hole-punch.
> 
> So, I see unmap on punch-hole being justified.

Most hole punching implementations in filesystems will take i_rwsem and
mmap_invalidate lock, flush the range to disk and unmap the pagecache
for all the fsblocks around that range, and only then update the file
space mappings.  If the unmap fails because a PMD couldn't be split,
then we'll just return that error to userspace and they can decide what
to do when fallocate() fails.

--D

> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov
> 

