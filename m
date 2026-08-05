Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21333C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E596B0098; Wed,  5 Aug 2026 12:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226426B0099; Wed,  5 Aug 2026 12:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162D86B009B; Wed,  5 Aug 2026 12:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E59016B0098
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:54:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7468AA04E9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:54:21 +0000 (UTC)
X-FDA: 85067813922.08.F8C0793
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CD8E010000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:54:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hiYXXsf5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LomNrTwfUghBLtw8pruEIdjOnzBlW2jy2hvg6IDyNQc=;
	b=NdUEZknh8jV81KgTWuftJyCWQl4kMGG+3atlrgGOGODEcxlT/NmLA2gDEEeN/th6821HdC
	r6kK3WQy1dBXx80EdUyY+tUr98HM+gD7LADbQGQ4YKC5oNMI8ab31TNkfk1l25k4nyiaXn
	bGR2/33g+CBwlkMIhCwYfPoAOuisYWk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hiYXXsf5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785948859;
	b=XH5pOvOFsNKg8lIDi3AdbN/0vcVEhKJrkgjZxFVwwuYtJVqSDKoKHyrvHNbmSHqT7YVF5x
	MLeGVxeQSEIFHOorEa5F4GBBHIrIJEIqnM+iGNOwTpXH+iFVde1F9wRtZRyVaynUfvBAkC
	xoMHRVPHkrhMOjXTW786uPKI5HUJ/9E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13AB460A83;
	Wed,  5 Aug 2026 16:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53211F000E9;
	Wed,  5 Aug 2026 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785948858;
	bh=LomNrTwfUghBLtw8pruEIdjOnzBlW2jy2hvg6IDyNQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hiYXXsf5l4ipSWL+908ZrIFpoqj4OiBmGzprF59jomn0pXAbbV56oHNsxUmOyg/ZX
	 lf2kqn/kxqzB7KjuWPhfApxRkWxGfvFv7KlCrfFqw8YxXg7CR36Q5lDU3g89Rtmrso
	 fvWjixVKzCDpWgc0UPGqCyY7TgpmpnCJRZxsZcFhaSurgnE/OY8+CJdb5I5Mf3wvCl
	 QPOJnObFtBnmK0GnjSLVbDxBcrm4cTCICaHwnoDEb//lUts7+SHamUQWdWvObefjtF
	 DISvPODt1AWo2x4d/07mdpV030QtMItr6BIxX+CYHkmU2FnkNmqPLVudgGVWbVWi11
	 1aYMtS+2AxsnQ==
Date: Wed, 5 Aug 2026 17:54:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <anNqcgYx08JXvm94@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <20260805121524.GM27883@nvidia.com>
 <anNkjl0qNHK47WTD@lucifer>
 <20260805165240.GR27883@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260805165240.GR27883@nvidia.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD8E010000D
X-Stat-Signature: qjnedq6n4ktmgui859sszai9fcshpfex
X-Rspam-User: 
X-HE-Tag: 1785948859-42063
X-HE-Meta: U2FsdGVkX19RTxuY1f8BChoNdVxVkM06sNgWiOGqpm8XnQzP94qgKtmXeVOr3bEf/iUO+a2Nh0NwLAHiRhgbBreCVLCSjzWdFLkPVSxjcpiz3SqqBMPbib743IdugxDLD6kbOXRW/Pdbf/pku9vLOqX2R+CqdBDNPlR7pzveS6Z5OZpF9FCkGd6MqWIjYEcXUtCRmpua140jcB4028NKclKBNSvSFntmTgmYdw7YjC+61VSvZQlgGG4J/gGOGjLeLWltN2kiZuIX0kZlHk/XZ1lThVvj0kDV/3bG3moKeyQxnMxgx0kRh2rV8bEI9evaQOo1wCInKNGYKv46kA0r856Yf0+PNE+wlAHgkRRb4CPMs377tjdaDYGbENR6PF2oWdXR0g4+ACN3a5JchTJRrf6zkSsdVhjz526k1jJhrcOk1QofG6yhusZ9QhC0oPGt6kgT7tI0umcTrifZNWS5RcC8j0TMgbI+v3BNFKHz1QVy4DbX+57I5nMIMPTbTTwKpSv6zaGIv0pl22IckcY9VnN7oJpOdlKoDAE+mPC3lifwZ95aLiiAmLeAAmbc+Ivrpuc18DbdY9n389nrIsdgQkS3BCwo2VQvzX8U+UonxjM71e88D2DOFyohnvR7EE95GOjcF+LG/+dUEUeeTU1/CrIHh8KEXbSKnFNtVlpZUSZYaYhA/1TubeD8j+eT1GKqTxhXT4n2Mc27xXrLVBojzyA+uaoMDWDP0UL/DiIxyEzWrO5jdTeOX6LUJACKdewxIxnTj7D+zn8DXag4dYQ5W/yEaMlmESCXnd9rRYMwgD63lIOYFV17NZ6qRo9zep00jXsZYGZnwZ9Nk9GpdHoG91/4yKsacNZNpJDkARbXJSTX2fkbKqso9Jv1o6F36PTW04LQK7xVRJ5yehzRAgVuPsYSbzqSf4KGOz3mV01RddPGvRSCE3U3UctoZrpA394v2tdkVIgd5rLYkoJGw2w
 6zPyS6wz
 6OC0boTOKl228lO65k+BTUEg8H5h1po6tfSGJQAlHqajsW8mkNF8bVJHPSJhkV6IvZqoFLqdycOzUEt4GKwXfL/ZnYpjYZovlyhfpd1XhRYES+HBv5GpcUNJ2rqkpiJN3v3QKfAKcXA5hBq3Ysu8FA1rL4jkBLukWVkPfCuH6uJ5Y49kw/TGHjXA45HZR5+gyAoJGQGS6WPNwzYuzC8xJTTSqXOa1eiT1PLtPptM8u+TaoT1/7Y4jaJGG6uJwFlzC3kJPIy+NtcYHo50dhiAV/o/pO+9kGVnMF2dfy0RWOKxmNJHB5bmD7hp5TCaQ0kHUgygl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 01:52:40PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 05, 2026 at 05:29:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Aug 05, 2026 at 09:15:24AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Aug 05, 2026 at 07:55:40AM +0200, Cédric Le Goater wrote:
> > >
> > > > The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
> > > > page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
> > > > with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
> > > > severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.
> > >
> > > Broadly upstream we expect people to use iommufd and dmabuf for these
> > > configurations to avoid all this nonsense overhead. :\
> >
> > Point taken on that :) but I think it's generally reasonable in line with the
> > huge PFN map changes to do something like I suggested.
>
> Yeah, for cases like this working with pure PFNs from some non-folio
> source the size should be entirely delegated to the driver, and driver
> should always have the opportunity to place a maximally sized PTE.
>
> It is definately wrong to intermix it with any THP logic. DAX isn't a
> special case, it was just the first place to partially implement
> something that looks like this.

Might actually be worth getting rid of this dumb DAX special case and putting it
in the new thing too actually so it's actually normalised as 'statically mapped
stuff that doesn't allocate isn't gated on THP tunables' alongside huge PFN.

>
> Jason

--
Cheers, Lorenzo

