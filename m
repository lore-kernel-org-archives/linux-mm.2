Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A5CEE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9AA6B0089; Fri,  6 Feb 2026 12:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1716B0092; Fri,  6 Feb 2026 12:42:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607DD6B0098; Fri,  6 Feb 2026 12:42:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CBD06B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:42:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E6231B24F2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:42:52 +0000 (UTC)
X-FDA: 84414752184.04.F3B793C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 78D2B20002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:42:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G3jOW1Tz;
	spf=pass (imf13.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WAzbxq5wmJ5b5FT+s2VwYQ4C4V0MNVHCU3p+8lzON8=;
	b=MEqt1arDEjcaAxf4dtdMZT0X3xTYn6E/uJIiP3SIWtTZG8tg62B/gjEvMvKbwBLTn/bMZc
	AWgVFqDopTCKMoPNzb6blzM+WTcXMi6DQyTt/m49jvKxHEOdqkeZZQ07kJROVbEbb9T88o
	WnWeaBvVYQMPreA1wS3zDqM6zRcsPXo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G3jOW1Tz;
	spf=pass (imf13.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399770; a=rsa-sha256;
	cv=none;
	b=pMBVANoNlAkQEnhbcMrX/E163kIh+X+kRRqTXry2s6ecNTdn7QDwHLfzsikwiLR6c/FWtt
	2Bo8HqUwuY83AiN84CxQKPiPVZYIzNOLzrJozYm0pSy5chiUUGyGcorAZxHR5eDI/gB41u
	vUKrY88+0ddwZXzjHbcnoMAOlAFU5lk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DBE1B6011F;
	Fri,  6 Feb 2026 17:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB0DC19422;
	Fri,  6 Feb 2026 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770399769;
	bh=eNJmIb5koQUG9PEJGuhNbm5WYTOM+0rPQAPgKszuWSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G3jOW1TzFYHRzH4c888JMdxPstz1/9vFvXCkJpcLhWaJMTAxyxj2mv5Jcv+StTe0C
	 cdG4mcL8mzrXPDSwgnvyd6ahvvF2quNcAo+YJzixcBs0FaMj66HNsWNrkTrMLrzO3i
	 lbaQONTMuph4klV2qdeTMS2HTUmIr3jtPyXUuyjIw+Vz3BwhELaQJ8Mz8bUepxDmQD
	 fP293XajWgIZAlcJT7CPsEiKde0U06muNpZevnHzNM6u3LMODWAtC2S9Zg3LDoxG5G
	 79PHvNVhQGsJGEMg5g93uw2geo0a9sX8qzr+4o9QbjYBTSq3srJBZeoqiYdJUgAtAU
	 nIhA7tg0BHDKA==
Date: Fri, 6 Feb 2026 09:42:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260206174248.GZ7712@frogsfrogsfrogs>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
 <aXEvAD5Rf5QLp4Ma@bfoster>
 <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
 <aXN3EtxKFXX8DEbl@bfoster>
 <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
 <20260206062527.GA25841@lst.de>
 <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78D2B20002
X-Stat-Signature: 81f4jhrfh951fu3h9r697dg9fxwhuxb1
X-Rspam-User: 
X-HE-Tag: 1770399770-541638
X-HE-Meta: U2FsdGVkX1/dd+PRtsbVMOFWInDi1tCVzv5MyREMuVadTjbmrP1mDDaBQsI3EFdVb1SmlbQmsNPt068vW3HGpIQ9Bakz5/SaxPXwZdngIVfhdGlK+lNW9wiw8MBKajgvLqMf09I3Yw5WWSqTbRAfX4H0dMZGo1imv2L7VSpkbrKrIxQcTMElNUbajgA96/mnoiYW9mensEIV1Jy7p81LEjV3wrFAOdVkoOd3OtVp56eIW0TgUfoZtDNTCHkHGROd6aN+Ae4+CSIlmLHZQ85HnmJ2Gs/AddFtUQyeHwv4WiyZpbJZw1TMAIpBWCeJxelvPqhFRNq7DQoD381eKrOM62CNflOGxN3bdu3ctcBbryNoZX8Yod9ZJ8JXGiW6gg+V8a1BCWgizQgsUKJW9Od33w3BXSBQwtzA6gvB0GAlv6mu0dcEut5Nj0ooQbGJkJaQxyH0+dVSFlT+6NZrwBnIDgOpaRlcOn4Zc31fh0WTC1scnqNX6/z7UNccx1etK0Mg0oU23IWDVrvUEiOGWUE/FQenyyJhEQ2utJOx+bquATKVHawXdwZ4YQ23FPjoOb7/qsezfZJG/wDBWLLralL22y0XYk2BWUH/mjH738cBc8QkVUgy4rfgMLVFBtMtIQ9GQh7BCwnkwhKHf/F26xeJoXGP8isCmCd/I1Zy6FcOMw2J4nLtnH6wO8bHGVFm5KggT7yoBtCKIoO4ODUHs7UEpv0iTGoB481PtYLiMJrdlV1qzTsRQ8ZnoE7be9G4ih1ERss5POSm7ZOWzsFjekjjrzrOMe1sZhlAmmlThQy4MN40Agn8S3dwUxgqdoHfRiO+0zAgOa6A3rJigOyXWVFWhua98iMglFhPIsgTDbCCWlJpDejXBSOnxTdc1tqySIKijklUSiHdb7IecgNSbIWZd4bGO4xhRni1McOWczOzqN32Fxwq8Eumkg7z5LrW486GS562yLm5WVKKioxLfgx
 /eBl0185
 sHxYaIviqtYp6JKFaQmruy2qG25LI4zNg3fOe1PsKO8HXb2dGxfqglQ5uIgzY61SbceGKc84z9py/I0ZSkXXxCmVj9uupzmzZZtucD4++mXGIAZFIm1BEAm50+/brc5xreWL3flgvGEdRRp3/VSa+uyDosb/qYMPiwyYHrFSLKdlqQSpFsTKoOngj8XxwFxETARKk7MVt489wAWyKfKunHLWIx3JOY1sM0equJQhUdgL7cChUYyH0a/O7D73VfiQVaQphL2e7iHHB8DZso7cZ+a77sEBrPy4kng9RXNvNyq84YWdgJo8M8EH8sB1jluX+1SlwPMU0jOFR0n+/CUa1m/C1UNr3DjvDrqK2tGm4KsAxXi062umH1LNtqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:37:38PM +0530, Kundan Kumar wrote:
> On 2/6/2026 11:55 AM, Christoph Hellwig wrote:
> > I fear we're deep down a rabbit hole solving the wrong problem here.
> > Traditionally block allocation, in XFS and in general, was about finding
> > the "best" location to avoid seeks.  With SSDs the seeks themselves are
> > kinda pointless, although large sequential write streams are still very
> > useful of course, as is avoiding both freespace and bmap fragmentation.
> > On the other hand avoiding contention from multiple writers is a good
> > thing.  (this is discounting the HDD case, where the industry is very
> > rapidly moving to zoned device, for which zoned XFS has a totally
> > different allocator)
> > 
> > With multi-threaded writeback this become important for writeback, but
> > even before this would be useful for direct and uncached I/O.
> > 
> > So I think the first thing I'd look into it to tune the allocator to
> > avoid that contention, by by spreading different allocation streams from
> > different core to different AGs, and relax the very sophisticated and
> > detailed placement done by the XFS allocator.
> 
> When you say "coarse-grained sharding", do you mean tracking a single
> "home AG" per inode (no per-folio tagging) and using it as a best-effort
> hint for writeback routing?
> 
> If so, we can align with that and keep the threading model generic by
> relying on bdi writeback contexts. Concretely, XFS would set up a 
> bounded number of bdi wb contexts at mount time, and route each inode to 
> its home shard. Does this align with what you have in mind?
> 
> We had implemented a similar approach in earlier versions of this
> series[1]. But the feedback[2] that we got was that mapping high level
> writeback to eventual AG allocation can be sometimes inaccurate (aged
> filesystems, inode spanning accross multiple AGs, etc.), so we moved to
> per folio tagging to make the routing decision closer to the actual IO.
> That said, I agree that the per folio approach is complex.
> 
> Darrick, does this direction look reasonable to you as well?

Yeah, I think a simpler scheme would be a better starting place; we can
make things more complex later once we can show that there's a need.

--D

> 
> [1] 
> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
> [2] https://lore.kernel.org/all/20251107133742.GA5596@lst.de/
> 
> 

