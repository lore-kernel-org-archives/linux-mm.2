Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D478606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ExxhoTgL
Received: by kanga.kvack.org (Postfix)
	id 96FD76B05B1; Thu, 29 Oct 2026 09:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947336B05B2; Thu, 29 Oct 2026 09:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DE06B05B4; Thu, 29 Oct 2026 09:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA146B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:17:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 085E71603CC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:17:16 +0000 (UTC)
X-FDA: 85375714872.09.50ACFE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18B532000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:17:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExxhoTgL;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793279834;
	b=ISx0nEqGc0L4Dgc/oEtBvD+ismtsCk/vpbAuW2La1afp9eIMAYRYc0Q2Rm964zaDUfGdbA
	52tuVxRkUxvmNsA9m9LF/Kksrv88k5cOcrLd1ALR2qMGOsvniDA1S7k549iZ5ro9dtrZta
	jTdPS9Xox8bgCPnBnFUUE9qNFfXbdA0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ExxhoTgL;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793279834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRA+EBscIjB3Wf85Kdsp3ZllP4NjhEMks6pJspoVgFI=;
	b=F11JkFaGdi5tH7eVUjIAVDXMX58qxNFHFomsLDZyBw5d2dToPXlH7zDPulH+3mJnL+kHkI
	PGzC4xoHXkGcYNTRWE1IuJN6zc5l47foRJGABS292f+asuNipv/kO90syk/3ajPjki2VkR
	OIvRs1cVW+7xaDmLwHQ3RiBhYSY7XlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFBEA60210;
	Thu, 29 Oct 2026 13:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B59C1F01825;
	Thu, 29 Oct 2026 13:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793279833;
	bh=JRA+EBscIjB3Wf85Kdsp3ZllP4NjhEMks6pJspoVgFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ExxhoTgLpmardw03fYqQ5Z99pOOg/9EAf9OCNy5IikWuNrxOwziwwMHkyQVfLkB8e
	 sMzz0mutTiCjvLQoDVRf098zOXBcYIFzKeEtegeOIRrRxv5orNNGPegzkhjdfoZJC1
	 /gAMFi2JSfCWG2LXfQ5EAHCGJY1yfFPmHsKvuHaE0Y/CUHe2z6j1Mz6L0cKItab5S7
	 ZwqCTD2Qy9UrXj7q1MjE9mdA8HFWbcFJZn9h3xdU8PHdI8qH/53okMpOnQuPVgNCu8
	 besGbjfbWqJvlZMND2HOyHx+USOJ/tUzdAyH4SLjOp9EN2Ydz3dU82NTDCzxsGS9ci
	 hcfDaDdOB+LSw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4A423198003A;
	Thu, 29 Oct 2026 09:17:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 29 Oct 2026 09:17:11 -0400
X-ME-Sender: <xms:VEfjaiBdtk8eSqQZZC_siWUNjp2XkmnUYdgaj_pO0fwEO7m7hQs9cw>
    <xme:VEfjas8tPX1HCuciZcBjCntcbHreNpgolp2GChr-f4BKtzxEk8d1FBsFUejZbGQkA
    OuR06tY5PjhdvrZ0XjtW24VnSOn5h004S36m3veDe3entpZ2FSRV8IM>
X-ME-Received: <xmr:VEfjarC-xtsABZe4qugdnyGgA8JROjkZxr1Liqcf_I5F6ZpseHmNL6d-zj4>
X-ME-Proxy-Cause: dmFkZTG2EVxsiXqZOd32Nkq2kAun5pY6dWfNhhCiR95p6LBReaqvq03sPl8TN9erfkk0z1
    KTntpfrqVGeL9x1bmG/wkYLrULDdbe73UgZsxUYteqXu1qb0r7PB55VdGOox5cUZ8co7/u
    dZbZ+V6ErfeNzekxowVgsvUXTTLpyn1piwccOyRtMMzxlCZuo0WPOsQWlntSkDidJIMQOv
    M6pCN+bMHlsgaa39ZsrwapEieXGuHAHcOWGc5Xhy0nxxCCPOwgRQYpCME/wA2YaTZmhDqi
    4EI4t32GKL0L2I+7TH+Z4hmIQymqAMCSwo/Eo6zjbX7Z0/2jj2hpmJ+TCsn8bdUzJkaNMO
    NCOMRe0lPsiH+E7VCC1pn/jknH5q21qyXXvkMF8BvXyNlwqi8BXYHqrbSYz/p+kTM8ppnc
    Glxuv07CuB9+LYt8gGuoZ8+RyNP+ugGlrw8bUKCJxfD1iA+n/nbk0fl84/DHo7JF7OJSL/
    azpUfXoZIrzopbX6exR9zJfgSx/M+Pmb9BdzqThL04B/Me6eoaNpqmsqarnS1hSCcvP4Ko
    dWs8Swn0FcYhOmmn7GISdaF5jIHXSOukDmxJyK2yDIP4JnbymtkEZAMjs1EMZZIIFZieew
    GOaKtvWvMdRwmDdQ2BrXWWW3bcgwJxHRQ8J1XCaToGBh8UV/zjIuwFKJ6DrA
X-ME-Proxy: <xmx:VEfjauunaaMeRiuKnHXbsJmtOYDrSpyOKPD_sZ91W3zgIVDdz9W_GA>
    <xmx:VEfjarEZNQ-xtc-qWG5wZA7FreBVZRVlal7OLQ2HM6ZcNhqEY7Gb9A>
    <xmx:VEfjap_9pXFINOd-m61pulQfv17tnFFdF-8FxB6GVj0zSQFmfG9cNg>
    <xmx:VEfjahO835ydd3R2iOG1LVa_p0gwkiasQ3O0Wqv_cXxfCxMiJnTn-A>
    <xmx:VEfjavjM0W98gr5mnFSzoc1pt3ZiuXwUD3I6pRrj-E6pcUAlkgjqXSB3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 09:17:07 -0400 (EDT)
Date: Thu, 29 Oct 2026 13:17:06 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/cma: accept memory of CMA areas reserved with
 memblock_reserve()
Message-ID: <auNE2XEGreHRKoPO@thinkstation>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <auM6lKGAeUI26jCj@thinkstation>
 <auM-tYrdV4TJgJ6K@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auM-tYrdV4TJgJ6K@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 18B532000C
X-Stat-Signature: pbqbjw6rq5cyewxi5y6eguer1nofqr5q
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793279833-389151
X-HE-Meta: U2FsdGVkX19vYF36mzmci+btpt512DdJrg+eqp3Ho7wQW4ABobApDlFBZqJUR69TClgKgSd9j+O+vempWBtrpabAOcmgKWfWEjv/rbbXclRaqoGhg31s56NiTHeUAczzyyN3gX1WTBtJP/KVn0arL5xLFEJokZ3HO4rl8hUsTOTExtUOGHjxuNEtIWjHonzkyRHcN3T7hykGn07/2gdQTH9vDiExRhmUD80FJgo5VT8q58QeDhtZtWzTS9PyFPToPpy9kwc1F7JC3hSmH4cpgMcrJsTZuKLR2Ic44f2nkg8lCRppVYdfDp3MJi98fE9VrHK/yqlc0VfhSBUHJa8aPkQn/FNEVozWDYNuyJSC50m+V4p5HZWLvDiaOQaN42EKxXJhejur3yjyij/tpBRGuC9+vJaZmtCf3SzTIIBNj/xtBMonJ4tQO5GD3r2UNUUcrKm0GsCjIYe5VTIm3PFW+j1f/NnoEjOJxZn2DUenUVrWXov8Gqh7ERMdNeSBzUiwP5R968H+PnlMI31FFeiunYhERSGa8LJFxNOD56yuypRd91J0JaY4gE+g9SjnK5tb9wvsVdW/CErVAQ3vngznVXh8W1G0k/6BDSWMAs5nKyvSytimb/tWcY/hzeQqxB1PZ6xQxUv8P69MHR6o1PxJ/+7KsHhcr4bDgxojpAsUdWgA4WxaSrfk7H53Q7CWThx6+lbgfhFYlUWCWqO3Ahvi0gkNXfgFD287sOur8kQ6CjoCHxDsjhAOz11kJhWZD+99mmeQzHRU0QnVgqxO9TeytjEsybIhtX6PTsCLXVbA8Op36w1ABDlIqn1My7ZaoldBl5LT4MP5enlTnzUayRFFw7NcxdmXn8qLl1iFu9OvQW90swKqzFflHJP/bWYowz+a8SADk7uVvhQOp0fwRSchCc2CPEAwkV7cGDiT7xTBnLxDhfh6AUQoqnlKU3w+yhtVr39nNa8MsdLnSgpQEq6
 rzVuRE9B
 GCZ0i5mcNfaXCGERtEj7Um6dEGGaKpqx6BsTOfwY+EOi0daY5ghldQ57HZ5aVu05K85rzp/YDatTF9XBQW0DmNxZxDmPaa9D0NLhnT4Zl+kSB+d5haYMkl+jDH2F7DzQMjh4FfHj8hz5op5SaYf93nKepKHfwtCBkSHvfepaBGLLqkVNcHh676xCy9qYzjxn/ZkbA6L7rKcG8EHDYp6+oGA04dGCa1HukcYV4pXGKyXSV+QhvyTB6waEAj4r88TtwSUXp+MCLyuZdzqtoWPtC7H9zOyInmVgVFmxmBnwuAMGXneKjseJvMLnWGOAKv6pb7R8f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:40:21PM +0200, Mike Rapoport wrote:
> On Thu, Oct 29, 2026 at 12:27:23PM +0000, Kiryl Shutsemau wrote:
> > On Thu, Oct 29, 2026 at 12:18:36PM +0200, Mike Rapoport (Microsoft) wrote:
> > > Pages of allocated CMA areas are released to the buddy allocator with
> > > __free_pages(), which does not check for unaccepted memory.
> > > 
> > > This usually works because memblock accepts the memory it allocates.
> > > 
> > > However, multi-range CMA areas, used by hugetlb_cma, and fixed CMA areas
> > > requested with cma=<size>@<base> are reserved with memblock_reserve() and
> > > their memory is never accepted.
> > 
> > It feels like memblock_reserve() abuse, no?
> > 
> > crashkernel=size@base already uses memblock_phys_alloc_range() for this.
> > Should the fixed and multi-range CMA paths go through the allocation API
> > as well.
> 
> Fixed path already has the range, why would it use allocation APIs?

Having the range doesn't make it a reservation. Both paths take free
memory for the kernel's use, which is an allocation, and an allocation
has to be accepted. memblock_reserve() is for memory that is already in
use: kernel image, initrd, firmware tables. Using it for allocations
leaves acceptance to every caller, and both CMA paths missed it.

If memblock_phys_alloc_range() is the wrong tool, let's add a
memblock_*alloc*() helper that takes the exact range and does the reserve
plus memblock_prep_allocation(), the way memblock_alloc_hugetlb() finishes
its own search. There is no search, so the multi-range path doesn't get
slower, and accept_memory() stays inside memblock.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

