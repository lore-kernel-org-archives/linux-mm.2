Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478C1C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 07:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411F16B0005; Sat, 11 Jul 2026 03:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0686B0088; Sat, 11 Jul 2026 03:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8F76B008A; Sat, 11 Jul 2026 03:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB7F6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:57:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A2F390BB0
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:57:27 +0000 (UTC)
X-FDA: 84975740934.05.E9104EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED2771C000B
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 07:57:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cn9iJo9m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783756646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGBD6eys3oSJOzBh2wVwyNhlnj3y2BQokjMnJnf2UHY=;
	b=jUQf/VWkDR8Gu/EhqpjcFWF+C5T2iucMo8WucDBkgqiSBf3RevfjLQlVpFL56OFZN5Ix/w
	8wOx4T2I/p5Q5mYA8mM/H3lIxsU2eCG4aGx1FqfR+itBHQXgwV1AsysTbKUX5uI7mlypXY
	laS6y6Dqdq+KHMmedxZ2m2kXCb5BYGs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cn9iJo9m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783756646;
	b=KrYlOclyM8vk88x9cT4jkQfrIMRdSJmynFR4RycLn/bCXbtYSTZiO4j3DFl+riPPhqx5Xi
	Y8VyiNS7Y7OcH4wMIUdcNKhuEId1YKGF/B74oUlZXUqnJMw7zzuGpKLtVSsTrHtHcN0odA
	zMaZwaI9RRQdByPQHrRVZ6NKMhhzzsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C8F460051;
	Sat, 11 Jul 2026 07:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0653B1F000E9;
	Sat, 11 Jul 2026 07:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783756644;
	bh=HGBD6eys3oSJOzBh2wVwyNhlnj3y2BQokjMnJnf2UHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cn9iJo9md/MwFYwAzyLoYrqYt5mAoRSggYoNNsTZlt23XN0eBnV+cm5tManxJL5Yu
	 XX+vyHyocflbtbYRXTsK+6WDr5H73np0gDj9MkiQU/QXD92C+3YiNvXH0cGqGxDrXo
	 kVMwVCAuww5i4GXFAe3EiBn/N9osMU28Qn7rfllYiF0LBoWPQiOcM8U+joaCuRBN4c
	 MvnCKEnxeJYNS2rg+y4mLcU9X8dQl43rMmPs1pF+J34LyoIxm+CqfZL6mwNIO7z0E6
	 LChfII7fP1dBEHIWmV1H8r/NWFOy1WP+sw4B7yp1dyDGIKHlnBn6EJU+KQ6VddPr62
	 UXIOmHnAh3Asg==
Date: Sat, 11 Jul 2026 08:57:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Will Deacon <will@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mm/ptdump: always stabilise against page table freeing
 using init_mm
Message-ID: <alH27K6kvUVxJ672@lucifer>
References: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
 <20260710132954.49c85be140500c59c1fcb773@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710132954.49c85be140500c59c1fcb773@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ED2771C000B
X-Stat-Signature: mfpkr7boj55yo3frhx8ijcamkctjmcze
X-HE-Tag: 1783756645-458012
X-HE-Meta: U2FsdGVkX1/ZYenTOlYb5Thl0LT5pUdRpOAOckqTlbAK6QE4TecC7y9XaatgrK2OqqaGAt1tPQ9WZpouYKKuiLOSnzJc/vzXNyBF6yFLe3t4KH75IDdXAGQwkZx3JXwK/ZV/L0wPrwuQiwlOwcKmWEziZ2Qeb2CUgZ8jG74pVKZk1V/UTdFJaTgLst4ScXSEa8p8iSyuVoOvGtNvffFOnaudDZjfPJyEJZYbYAbIy/vJiJTx+/ANDY41Fe4/UsJFLZ0MfYy2GMGfzNgKzrZLQiznT8hJnOZpp4FbuCRNn14Oi06W7bQ6/aUY4bRhtOs2WiNh+qPxvyrO92/5tVpbg13bOYzoGn6S9YjHoSCjN4uvNjvOgUKDxQymn2IVoVkh9YpVQzg4uGBYVxEU0o1wLNQ08Od/HNUbAHIvA493d0dQEHnXJ5F3/9AM7FOtFXiwVJLCYWPZbQhJCCdzhJejNNjrPaqeZjSkvj+UbOWxJxe/W1+WentXsGozIOh9ayl5Iwq2LYS6Ye489V4pLvQ4HpQViyxC5fOgR0WPi2XAvnIBzp1gIVnUnHQIwXd5Xpsccv26yK1fwfEGCr6qdFFQbBLx52SfFLVlbSo920jV/Ugxw1S6+MkAzB5dhxnBSLAccMGgXBurO2SzKS/X7KRTM7GSGyj+JQu4l0u0MDPGtQKIS7TPaaZ5T2jaxt38OA1mGKzPPIKfEgm4TsuXdUFOiWxkEIsNd9wdTyiicYktxjgTy28oDmy6XmYAdwpuFIV7Tjr7+clooTAV/4NxDRbdC4hIG1GLVWpQwxPX/b2tGi0geBsvTlDjCjNBMWLKIQmp/g0+SgD7cAau31udwh637BvmnNKNpsz1vzpHschZhRVCq8YZs1zg+XQ9DTHuuiHv31+cTZuHvyRORGRhEnAxG1x+1snjxtuuVnIyammzziMqfofUfDfsjDjGUg15uWsUV7x02a6pFIiMM9Ouq1D
 bybcNhP6
 HRjwHvCctR3xOYaShXWElKFWHXgIHC7LnQkAutDhrBs432Gs8rUYUGnl+qzSGsf5F5NJ1wHTlNq+Qp3moxSaYTWGg8C7SjIjCZDiGoSxu7MADRAZKCV4slGd1infdrcFsWZvRn0ooW38QFXUhi3vgzGsnVZjumXkBBq1DEiftFdyixHpxD7k93YXrg/54za/5LGRdguC5ghqS7Ml3PPOID6LPPwHq+12J7f6TlhlLBRtWGki+pdYYOHBaOeglAo2j+JS+pBw+pXwvj1WhI6D/aKhI7W8Xu+Oag4vsPz9jUtAN/XQm34xLWgJ93uD0mE3EIfEL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(+cc Dave as we were discussing on another thread)

On Fri, Jul 10, 2026 at 01:29:54PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:29:21 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> > x86 and arm64 invokes ptdump_walk_pgd() with non-init_mm mm whilst still
> > walking kernel page table ranges.
> >
> > For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
> > first passing current->mm, and the second passing efi_mm (we reach kernel
> > mappings that init_mm protects for current->mm due to x86 cloning shared
> > kernel page tables for arbitrary mm's).
> >
> > arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
> > for efi ranges against efi_mm.
> >
> > The init_mm mmap lock is used to stabilise page table freeing against
> > ptdump, so take a nested lock on init_mm to ensure that we are correctly
> > stabilised.
> >
> > We take this after mmap write locking the non-init_mm mm. Nothing acquires
> > the init_mm lock first before locking an arbitrary mm, so no deadlock is
> > possible.
> >
> > Other fixes have been sent which update the two cases which can cause races
> > with ptdump in init_mm ranges to acquire the init_mm mmap write lock - vmap
> > and x86 CPA huge page promotion.
> >
> > For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> > already provides exclusion against init_mm for the vmap case, which this
> > patch also pairs with.
> >
> > The first point at which ptdump can race kernel page table freeing is
> > commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
> > table"), so we target this in the Fixes tag.
>
> Does this have any known userspace impact?

Taken in conjunction with the other fixes mentioned it resolves a UAF, so yes :)

>
> > Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
>
> Since 2018, so I won't make this a hotfix, OK?
>

No, this has to be a hotfix, it is part of solving a live UAF issue.

Cheers, Lorenzo

