Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AD6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4E66B0882; Mon, 17 Aug 2026 18:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385996B0884; Mon, 17 Aug 2026 18:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DEA6B0886; Mon, 17 Aug 2026 18:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 032746B0882
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:15:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 896AAA3583
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:15:54 +0000 (UTC)
X-FDA: 85112169828.24.80743F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C949140004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:15:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sr3KJOYt;
	spf=pass (imf12.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8PHYNwnPwjD4P97/aLgG+IksMysTOlP/5dyI7THzj8=;
	b=aPnL47GAFE/upjk7fFZuwb/KiNYg3eQ5faFEOy/S1GJZrqKixinxPAfh+7pk98YnKMtu8u
	KCIszOoxOuwZzneEAn/yoB+PDN7nasAEYdGqHlejMnv9N+Y5gS1tc8oTCgiz5FjHj2RzcL
	vWxZTSqwOxw+wiCLXKvzWB39NCMm7os=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787004953;
	b=R6Di+jA30WqrpKsyEq73LfEZYlPBPj/knb/XSFUrjXX7M6WL7KjzsVM2mLWjJus29SPfDk
	RDVoymiOMnF+4URGMT5TWviQYArfW2Jel6h7x4vebg4SJDCrnBXFX2YRufRdFOz3s5i3Tc
	+re2xd/vXrvqCHno5E5a+FuUAJ4v8CQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sr3KJOYt;
	spf=pass (imf12.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09FA942B1B;
	Mon, 17 Aug 2026 22:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE95A1F000E9;
	Mon, 17 Aug 2026 22:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787004951;
	bh=b8PHYNwnPwjD4P97/aLgG+IksMysTOlP/5dyI7THzj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sr3KJOYtA2N9Ih00IL2TrShVL95fPeug79m6BzsdBenS9EW8b/GYJt6IlS4XqDdU1
	 VpEJ+V63urYa7sVFZRT7NlHGGmLMljPQsbSpJL75plPkdo3WzgVgRID3ZMV2yH2SCO
	 vD6Y8Yz5PGQsPBixTO30keh07tcDVuMIhWRK+Q+Ot++nGdijdQ/R7aDviaaoQ6+M4P
	 vf9BBfxXXnzvJnj28Jl+DwgU62BSFXRUaLAYkYMbpgYAuIVOcHjA3Cgg82jSLDXRsv
	 8EKKsN6e11vKzhiWEKKcniQR37+0WysYviGimti8r37wehgI7p0GsUy4U1MDlYET62
	 jKFzGvMmtazlA==
Date: Tue, 18 Aug 2026 08:15:43 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: xfs: properly account xfs_buf items as reclaimable
Message-ID: <aoOID47x9csJo_W9@dread>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <an7D_9YRVDG-0Qjq@dread>
 <11c14c65-8609-4482-b3d1-23d4d36afd66@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11c14c65-8609-4482-b3d1-23d4d36afd66@sandeen.net>
X-Rspam-User: 
X-Stat-Signature: 9yyjqpdugjb9joi3b6npf11h5b3ruwpj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C949140004
X-HE-Tag: 1787004952-547361
X-HE-Meta: U2FsdGVkX19we5qjQJuFWVBZFbAXGDF5gDsjqowYimNcRndQ90K/SBYOPfis1KIkajB/wRB1yPf9yA9YRwaK97CgjuaQk/KrjZNtPlMVMaHjtLDEjExc7csREBzOni64b+e83Ib5zkY7P+I8OkinUebopded5BkiqsGCFxj4QxrFyhqiJdSznsMy1Ad0PahV5+QWlMtD1v2yCaob9pw/Q6ao3ufn/DEkITp7qq7F84MZfiAz5LjHBHn2dO+1WCFB+jZ0Jojw9aWfmNnRej4POQrDDdBS1unyFBb5EgRAx88fGFjoUtIrXjm3eOA10tWGB0hlcYHKJmNm365g5c/l7v7cYbmrCVLTpWEYEwYCRwWtp6tH9jj0MMvBUQvQR8MjJcwRmFN1bxzPNdLAhu5ktOHNKuxmOuMxtuf9KHPbAC0WbydKZAt5f1Z5If5W7cnkiCNP0poqyTT3vidG/fnN9deDhVquXES/4ySDdS74x50Cru97ArlopNnH5xXPXnoXAGf7F3QaYFtGHRgsYpq626fiyRvm5rx+CI45bDm0W3QtM0Ygud3AtPXYbEZ3lmDQEIoUNxevg9ADLd9zfuXsj6oWm5/HEpG5OQx+e0g7habXaErFOTY8dHS2csdpLPVxxccqtt0kJ8yoxJgM+he8NMoyPgdk3HQj5feIKeGsE1peMTXLXHRXzkrSvHA/I1D8z9XMD9/G/z2ON4UWFBedGo02lOlh96yW3tjor024F8ap2LAsY8XFUDiTFUH+SrUP1wstoSDZrvRCsIXmQSsos3tcdOQoLW5CZ44tmQYrT20Pvj3t5GSUT0CzQww8cBA7JvbtWhKlkLBfdl9jB/e+dbahVAyJWv9kvE6rPtl3kFjELWy+xB0gAtW7iUutwTzcuQBb0ou0oxXwkYHAyKz1bX+ggAc+0JCkCWk2pBefILkQtojJcqfb6dLa3Odfqvf4/f3diTAyDotiZI1RKA+
 g4b6b0kq
 XvPbtnVqcXogzDt/P9qqsmvXDK+LjAuM6BFUWduPPwu4DqWWDwhP6YF99SzjRBdKWnFxmah4akOYaBNUVa204Tb+LcJY5YUfuqvDF6A3qYFYZUP4r4nSQV0Duhi65njYIgnr6lacMN9nrJZ2QXqPj9964wUP2ZzAhZYdC61cPohqRiOFPM2JUCabyef0+F0K4gFU//NxVSJYAF3TqSO8yu/qb7eYUJ6m+LxiIWpbXn2uZQmup4ddfzANxPQVvnAG+rHI6PsIak2mFhep0UqVNWA7dFJY/cVmjDC+R+JQc3WpLpm8Cx15yXw8lQZQOoR2SVdB7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 11:07:45AM -0500, Eric Sandeen wrote:
> On 8/14/26 2:30 AM, Dave Chinner wrote:
> > On Thu, Aug 13, 2026 at 03:40:51PM -0500, Eric Sandeen wrote:
> > We don't use the size of that memory for reclaim
> > purposes, hence we haven't ever tracked it. It is, however, fed back
> > into shrinker based memory reclaim via mm_account_reclaimed_pages()
> > in xfs_buf_free() and hence memory reclaim correctly tracks how much
> > memory was released by the xfs_buf shrinker scan, even if the user
> > visible stats don't show it.
> 
> I guess that's the crux of the question: should those stats show it?

Filesystem metadata is often cached on the block device address
space (e.g. anything that uses sb_getblk() like extN and various
other filesystems do) and that shows up as "Buffers" in meminfo.
i.e. cached file data shows up a page cache (i.e. NR_FILE...),
cached metadata shows up as "buffers". 

The XFS buffer cache is caching metadata buffers, but it's not in
the block dev address space like bufferhead based filesystems do so
the nr_blockdev_pages() does not automatically account for it.
Unfortunately, this isn't accounted by a vmstat counter, but by
iterating the list of block device inodes and counting the number of
pages attached to each bdev mapping....

> >> I was not sure how to handle xfs_buf_alloc_vmalloc but I think
> >> that's a relatively rare path, and the above two will capture
> >> the majority of xfs_buf allocations.
> > 
> > I think both folio and vmalloc should be accounted in the same
> > manner - as a number of pages based on the size of the buffer (i.e.
> > same as mm_account_reclaimed_pages() does already). It doesn't
> > matter if it is vmalloc or a high order folio, the amount of memory
> > is the same.  If it gets accounted to the node of the first folio,
> > then it will at least always be consistently accounted, if not
> > always 100% accurate for the vmalloc case.
> 
> OK fair.
> 
> >> I've cc:d linux-mm just because i think this is the first
> >> user of NR_KERNEL_MISC_RECLAIMABLE in the tree?
> > 
> > These are fs buffers - shouldn't they be accounted as something that
> > reports as "cached" or "buffers" in /proc/meminfo? I mean, if you're
> > going to do this to make meminfo/vmstat report the memory usage,
> > shouldn't we make the effort to classify the memory usage correctly
> > for the user?
> 
> I'm not sure. NR_KERNEL_MISC_RECLAIMABLE says it's for
> "reclaimable non-slab kernel pages" and that seemed appropriate for
> this case; they really aren't the same as page cache?

Bufferram is "double accounted" in meminfo output. The folios are
accounted to the bdev page cache, but also to the "buffer" output.
the meinfo code then calculates "cached" as (page cache - swap -
buffers) - i.e. cached file data - so that buffers + cache totals
all the cached filesystem data + metadata....

Yes, XFS buffers don't fit into that, either, because we don't use
the page cache for the bdev buffer cache, but my point is that most
filesystems report cached metadata as "buffers" and users have long
expected "cached" to be the total of cached file data, and buffers
to be the total of cached metadata...

IMO, if we are going to report how much metadata we are caching in
the XFS buffer cache, we should try to make it match all the other
filesystem accounting...

> The commit (b29940c1abd7) that created NR_KERNEL_MISC_RECLAIMABLE
> renamed it from NR_INDIRECTLY_RECLAIMABLE_BYTES, and said it was
> "still useful for accounting direct page allocations (i.e. not slab)
> with a shrinker" so it seemed appropriate but clearly I'm a bit out
> of my depth here.

It would be appropriate if there wasn't already stats that are
supposed to report cached filesystem metadata. I could use the
example of shrinker reclaimed DRM memory pools as an example of a
valid use of NR_KERNEL_MISC_RECLAIMABLE because there is no other
equivalent functionality. However, a few months back they made the
DRM accounting a first class citizen via commit 2232ba9c7931 (mm:
add gpu active/reclaim per-node stat counters (v2)).

And that's kinda my point: if we need to expose the memory usage to
userspace, we should be presenting it the right way - consistent
with other filesystems - rather doing that requires minimal code but
requires all sorts of mental gymnastics for the user to determine
that some of their weird "MISC" memory usage is actually XFS
metadata.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

