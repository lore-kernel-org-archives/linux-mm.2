Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E7AFF364B1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CD16B008A; Thu,  9 Apr 2026 14:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CFF6B008C; Thu,  9 Apr 2026 14:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A096B0092; Thu,  9 Apr 2026 14:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 555056B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:47:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00492138C7B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:47:40 +0000 (UTC)
X-FDA: 84639901122.14.B7ACD48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DA9240002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:47:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdxt77ps;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775760459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ynxQXlOG28vT+Qv0GCJ2ea7lAJsvOFo3WspRgJbUf4=;
	b=nIHp44zjx5LexOhu+IcyDtrCGUyQEO9rm7j+2h6pbZMPrHkE8xMVocwh5zt03zT79P9Ppg
	PAJAJ7gIEIhS5tt1Z2vBaKWLi5ZH18RGeHa11N6FN2efdyfgsXyFZg1ZoS3V/lWLxIZ/lp
	FwFY7aGDwa/DtRTVvkMi5S/r2HuqgBs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdxt77ps;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775760459; a=rsa-sha256;
	cv=none;
	b=N72S80pXN0GO68Pr+ChH9hieziMtkfFwX+npb5KXOrdMN3QErfj7gKfDOhI8aJXYGsshzD
	9pa+5/057p/loF5dfPRxz5SnFN4u5N+Huao/BijM9kNzaVALB08nFNksj9QPyrPL0Gq/BM
	mqYPEg84f7Z6LOB5qSfBqknjTStTfI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9723943F84;
	Thu,  9 Apr 2026 18:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1735DC4CEF7;
	Thu,  9 Apr 2026 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775760458;
	bh=9hyJHbfFEUwXp5G3u37Z51sC8+W3u2u16Ri8A5G5bWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tdxt77psaSManp8RwTtMljaONd8XKkvy+BI0xBuX8TWyQrhWmgmSLlhsKOXcaFt6g
	 0X/KUwJw/psdQ+OVJML4OZct+J7Ja/rHBkJkyBsQW0Z9Q/dtRUcDlSP0Ii4IcYWy8D
	 oyknISWY8cuoYmXGMnA8wn6qP4gBNR4db//fXZsQP1BoaNjEq09V07gtKf0iTqLeXo
	 DODHhOKA5l8VZZX3jVNEYuWlc21fPJEV1RXZ7RZmI5iYCVDw97lFMWkcOjvsZ9GM3H
	 xDc5SRaKVtb3iSHWF4swYaijPGVrYjPdj8B04VRnGVgidqN1X5QETOFrx11507JGkB
	 BIyIeC7qeTgRQ==
Date: Thu, 9 Apr 2026 19:47:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>, 
	Joseph Salisbury <joseph.salisbury@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Message-ID: <adfz3ySoHakewmx2@lucifer>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
 <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com>
 <adfhGOHcg4AF3IFn@lucifer>
 <2cec5f0a-93cc-4572-9793-17f9fd123d2c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cec5f0a-93cc-4572-9793-17f9fd123d2c@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DA9240002
X-Stat-Signature: w4znr8z7zy1x8aug51wu6jqkodj7ss8y
X-Rspamd-Server: rspam06
X-HE-Tag: 1775760459-118014
X-HE-Meta: U2FsdGVkX1+MQWlwjZw8eJQ0Y605sPVYRBGbSIK/UoZJ7myTZYzSXr9yxaNYcoBMqJI6L7mlbh5dxcgEUxkQZiCOBJoWeU4dOC4dNtYSJJbe/YN6qOOLcrJWkv4DW4fY27pY5QuvoOM5XbRIeJ0kFhvQPqx0kZgZsU/SmaDpSZEUvILl91wcmUP5pyad9VXwUZpLCAchqSE2+g+M9kAcO+SDv1tXbB1P6xjeeU3wObq+qtxrrACo2pxDsOMVWDjyGBryVulPUVM4N7xHUbneH9TYubwIa4RveVTRjEJ31hQPiRlJ/ldJVPEIJzHXCu1VAfrSb754o+Xc6lyCKEeUsqyHzW7puRgHZECWttM5AOCXMCrsCi8mdo6RjKIBFY7dsODw+g7PlYCNAu73unOPVCtrOfEQLpy3BT+AMUeXb2nDwTAL0AhL5T6KWKKYxalOZK2QYz42vxiVWArTM8HTbyAItbv3NOQcSV+SDeDpTK7w9UMux/XkKdMYtAY4ZZILic1YjYBF1/+Se6vPGbU0BanYVf3fGulCeHCga8vdJqptd7z89C1k2D3+EwzNtqvc4c7d5wwVx3qJ5GufjXnhlouoplFqrcM9TxvRiIzCR1gFPFQlB0twiJS5+MR4H0KPRLEQ6fadAyYZMNx8dznK+WOzhDv57LU6HIPw3edRXVlZ9V5w3l0OKWR/6hKf23j6+Ga2LArc2gK1qDd2KOp7OIOAC7eOOAsSV3QgY2mGajBvmhAICtARfZULaDn1B0On+Ydf7qXhnwx/remv3Nv7KvRR3aUcoX2wnFyjwHmXpw8bqw+5THOZ48Y5IeLejWibjMG6hdsJzD8mjYezCuC063NGVm5s9fSGBzd/SG/mUpj7w8j2sfVeSJQQpEkPRIV0NXTEbLQun+in4z1Uh44Y2cBA2CdF5jPe7hTJfObtozUdXEMQ0SD5lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:12:39AM -0700, John Hubbard wrote:
>
> ...
> >>> +	 * Read VM_LOCKED before __get_user_pages(), which may drop
> >>> +	 * mmap_lock when FOLL_UNLOCKABLE is set, after which the vma
> >>> +	 * must not be accessed. The read is stable: mmap_lock is held
> >>> +	 * for read here, so mlock() (which needs the write lock)
> >>> +	 * cannot change VM_LOCKED concurrently.
> >>> +	 */
> >
> > BTW, not to nitpick (OK, maybe to nitpick :) this comments feels a bit
> > redundant. Maybe useful to note that the lock might be dropped (but you don't
> > indicate why it's OK to still assume state about the VMA), and it's a known
> > thing that you need a VMA write lock to alter flags, if we had to comment this
> > each time mm would be mostly comments :)
> >
> > So if you want a comment here I'd say something like 'the lock might be dropped
> > due to FOLL_UNLOCKABLE, but that's ok, we would simply end up doing a redundant
> > drain in this case'.
> >
> > But I'm not sure it's needed?
>
> I'm OK with just dropping the whole comment. I've lost my way lately with
> comment density. :)

Thanks, yeah I get this wrong myself often - I think tending towards more
comments is the better default :)

>
> >
> >>> +	need_drain = vma->vm_flags & VM_LOCKED;
> >
> > Please use the new VMA flag interface :)
>
> Oops, yes.

It's entirely forgiveable because this is massively new and pretty much nobody
but me and people who've bumped into it on review are all that aware :P

I mean I'll end up converting it all later anyway.

>
> I'm on the fence about whether to post an updated version of this.
> Maybe wait until someone pops up with a real need for it?
>
> Thoughts?

Yeah, let's wait for a real world case, otherwise we'll never be sure that we're
not solving the wrong problem I think.

>
> thanks,
> --
> John Hubbard
>

Cheers, Lorenzo

