Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4450DC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 10:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515476B008A; Sat, 29 Aug 2026 06:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C69F6B008C; Sat, 29 Aug 2026 06:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD5F6B0092; Sat, 29 Aug 2026 06:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14DE16B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:35:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93C358069F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:35:19 +0000 (UTC)
X-FDA: 85153949958.27.0A6677E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E165480002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:35:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4hQnDvs;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787999718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cSRCs8wDnCpBsS5x9/4R2NQI4neq/3EffewAPnRfKA=;
	b=IO7LfYx1Nw/0pf7vhKf+sxPs7GzQlNwZSBQVsGOzTrsM3ZlAXRalQUB6IXBVN49OBlykuE
	RfeURVJvt7H9akbq7ZxXoinbPSNUkVgrFDruWaIKxqeJFs0bPanVOYE9QHd+1eIiX3inSH
	3+fQPkfiA5DPBdoUZXISP00aI6hvhjo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787999718;
	b=Ml62+bTvoPUiiZ3+vZbxutDoibPdR6GgKpHVbrLdIQLlYYdRfVALu7iHoieOl5bHTnPzDW
	AQNMJaQE09V0QMwT694XhX5Vkw1McK/vYbzmC2ltJVqErGT+SzspjsAblGvxhyxYyEXWZI
	2VjEOVMcWKuKlJX1iESxywHZ3XyTYAU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4hQnDvs;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FAD043CDB;
	Sat, 29 Aug 2026 10:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1854E1F000E9;
	Sat, 29 Aug 2026 10:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787999716;
	bh=2cSRCs8wDnCpBsS5x9/4R2NQI4neq/3EffewAPnRfKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O4hQnDvsR3xz25zX0vx3nLmgtgXidRy0h4sWYehV2mXaWQF9J/8/dCttJ+E6EWeiL
	 AU5vXmX8gEuh+eiBybVN36gcL9arMMcSOSmanqnA1H0jUHcst2QpkRCuZYvOQ1utna
	 CmwIa3FMYIznrNaOU5idsntYbhRRO3HxdH82sL2QSmZq4KSQ//9h/0e1+1QzkyWNZ0
	 0rU3vqxq8xzjrVdcdZh5qOVfsw3iXccSIzOadiD6bqnoMbprP3lZK1UtNz4gXJHS5C
	 0O9KudEm0w62SpmKO8x56+dxacucnGq4B3gGwuAtRjfi6EA2/TmEU4oUb4c3BtwI86
	 LMFxBKkcdwmyA==
Date: Sat, 29 Aug 2026 13:35:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>,
	Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
Message-ID: <apK13danJIU2PD8f@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E165480002
X-Stat-Signature: c3bgcor46y3hmmqih6gyiys58yd5zqk3
X-HE-Tag: 1787999717-580031
X-HE-Meta: U2FsdGVkX1/PeaR8uC0l0EyXGpyQhO+c5DKeI81gD9o2RHW3Pz1BTo5isjFvZ7FhMsI/OEhZ8WQCTgunYxcQcFW3QCHLcfewpfej4jjUHZYPa0fksyP4aSbNZERKRDFWsUEVz9S301YeM2P07lEZPUV1JhYrKJoxQcclhU/iJ0k0Rp/MhMG1/uk3rgHaHgkdFc/o+Dk2JVUJiYutpkui54BzIfNBpUzgvVKQIoTdUHl4x5Rhr6nbq/KNSG4KecpQFyY8HYFjnXGNk4fQOPhswWC7gMuiFj9K8LFuXEeRmRPY2OqHeiESxwnlehoXGP+Ht8rjuONd2vARxYTHdb9Ai6ZtwnFy9DIKC8u8M0ddpxqB8mxNWMHwjb24x2zhevkeH/58kuzlnskzctSIarEIfMjh7t4X517OLZfQbJUB++cQTBALwu5LYUj0ilQZMNaSkFFA9ZtnCt2ZX/sClf4QHzQJ17JRCTw9Irbdyzp7XZqfw7xgjKJWfZXQoJpdNedZPTanQ3Ydu2vJvuRnlLMr5Q6crDZStPDEzaYgZWYdjDEvQRU1S4Lg0E8YrnNd+XRcO7gp6o+mCxejWbFGrIUAlbYNtGHYFLYX+zc/Jmzsukf3tRRVWODsqrBoiv5k7O7n3kmefbbxk0jQJk8L3QPyprP1vjXCbyroh3hlYCCulumXDrQGfrB9vFZ/XFHHLOi3G6yByoALBX6eRSe8LyAWBT8R6IlZBC2xfs9aq0wEN4AIwkEE62mka8kLZAuntOWcVvu5wU37XUpesdrbBCngqBk9ppBM2hTVybt2DDVpxYHbU9NDCRKZbdA2avJfNi6CTbcoW8kZHLnHJNl6aYfAxGSxU6GwK/p4lXNPBTUxTDc2eUgRfX6FNF5qRlCSB5bGzb7fn2Tzdhiv7gX7/jmMH8IQzim3CjjQ4Jeiu3MniwWJnjKXW1lONz4e3YMmFE7xPuWaOcNRhg7YWIkeqwi
 lQqldcHD
 gdCPr39il67oW3g2kHGLOgBAbukJ8t7O3KbtFICK33fSW2Y76rCTwW5YtWXwR36PUgzlPyJKjFYs9xETzKnWqKSVlPMEtyy6sliH55qApLQ818W3ylqSnJMppxcGsXGJ7agmZDrFRGH0g+b4R1jVJ/7WXJV62Ys+xfJvc3Pd5NhOYJxbRzcFytfFm9yJjkdxj95tronVppOAjVO6RoyML7Gf/GojnUjltCP7TCPWE3DI2RZQN+TXhSoKztt0VFOY/gMq7I9sE7DO1Z/Ufqt/MdZXYpAXtw/bRRyE0CJX8qIMRv87yIi4kTj2xmZ4cwje1Nbp6ZSHRxa6h4fdd1yqbe0wDmj+nemqdc08mOOIB7uVsXe9FAaSibmUS5PbRVpoUKbM0n7JuIXGWAhQjQaLk/Lz1uhPRS32zJF6xptCIu3VHHZwd34WIUjd7ZHSduniAKPD5yqiriGetTMjXJdjMDgT4tsqJrJ2EtQeWo84/Yk/QQCNzINnkga3fabJygftGjbOC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Martin,

This seems to fall between the cracks.

Do you want me to resend?

On Sat, Jul 04, 2026 at 09:13:33AM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/scsi
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 
> 
> ---
> v2 changes:
> * replace GFP_ATOMIC with GFP_NOIO in ipr driver
> 
> v1: https://patch.msgid.link/20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org
> 
> ---
> Mike Rapoport (Microsoft) (4):
>       scsi: target: file: use kmalloc() to allocate temporary protection buffer
>       scsi: proc: use kmalloc() in proc writers
>       scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
>       scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()
> 
>  drivers/scsi/ipr.c                  | 4 ++--
>  drivers/scsi/scsi_devinfo.c         | 5 +++--
>  drivers/scsi/scsi_proc.c            | 9 +++++----
>  drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
>  drivers/target/target_core_file.c   | 4 ++--
>  5 files changed, 14 insertions(+), 12 deletions(-)
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260611-b4-scsi-d0b0eb4895f4
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

