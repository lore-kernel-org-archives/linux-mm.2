Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB84FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50246B0095; Tue, 28 Apr 2026 10:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A266B6B0096; Tue, 28 Apr 2026 10:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963616B0098; Tue, 28 Apr 2026 10:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 856036B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:22:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C8741A01A5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:22:20 +0000 (UTC)
X-FDA: 84708179640.01.FF5EBB0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86B2B4000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:22:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kkTKQMnK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777386138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0Te1SqwkV5UqcpbbzTNHO6gbbaHS7L3dF8jXDrZ4q4=;
	b=Nb0topBAmdb2iqjLnEfYhwUeP7WSkldyc9YodfHr3tSUYWPrwQ6/HvX/ycxNzE7tnYPP1x
	pgPezy6faW/uP91WfX+7qxxfkUNEqqBWHnZpv/ZePisp0mdwegvlqud3SD2yjomi1AZP6t
	KVj0qjHE0sB36d9TMKE8vb1cLPvXWcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777386138; a=rsa-sha256;
	cv=none;
	b=QmeDfBwuATeXMwFJUAQOLtXjOwwiGrbefj3jGHmGs/q7ZWEalWC+uKbG+rQi+0AS1Ty30K
	BYujgGAw0fmQHbCQrmdD7Twx7Cjp2erC4ep7Tdt/78er+Z9emx7CzydJHhsAI32+mpvDYG
	ZZdJYhQGPWroY8tf9czzDROUNUHraxI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kkTKQMnK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W0Te1SqwkV5UqcpbbzTNHO6gbbaHS7L3dF8jXDrZ4q4=; b=kkTKQMnKwtrXqCNKc0z1+J1ku5
	Ms8qXs30K3/sdRV7uij5DXh0HTcXn9L9KT4sPPzRw/gsCgl00XoeLU77f+Nu/s2Nlde0dc/O+kmYN
	LgNhv27w1UFREraZJOEsjQ+VlDjYcXRo7tzlBvzY2y1s5VjOqobTOrpHYZh7c3TGPSQDMBB6KHqu1
	Kd4KJhznO7F35fQpihg4H4pQXFoDr+/6HKC6UNbelBYV+pFJANHJLZdqWoXQMN/gjd4vPLbxhyd2I
	W2No7s7hRvN36oog2fI0qb290Nkw71zvIEs5Oqsm2CGwt7cshYriElYDM9O3I5kmeHBgDZ/dtpdCP
	T2CELHZw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wHjKB-00000001dTc-28ed;
	Tue, 28 Apr 2026 14:22:07 +0000
Date: Tue, 28 Apr 2026 10:22:00 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] mm: Fix vmemmap optimization accounting and
 initialization
Message-ID: <2sdehw5xhmw6fufvdhztlfbm2zgjycj74jstxhqkmxwtyu4unc@nxrx77iwmep4>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 86B2B4000D
X-Rspamd-Server: rspam04
X-Stat-Signature: ouk9yzojc15e49p49bt7xekgfk687nu6
X-HE-Tag: 1777386137-674068
X-HE-Meta: U2FsdGVkX1/iXix5+ixQILd7FBfWQ/ShXIDTmT8lKp3ugB/Modo2yEw6G9hBfJd0E2agcBjsqOqWKSbUv5Z0b83Yv9nedb4GwzE0CLV6TJb4IBdPnk/cBIy5KIym634qciF7zqOXJo9MNCF56LfSxNdlJ9R69S6tw7u7ty194LscjpJP2MPN04qSAe1U2RvGQI6/UkVGZWbJlRsROeRjKFZXslwa0MYfQFFPKRgu3i5dbeyQ7hIMAlAyZwN0+z0FtRvIhkG9lvpRJyGkAD1lqunA+wwuoF0ZkYTCSNkmfEpWfZigodlkjgEu+frk78XsqShNhB70umQXACMsB4SAbOArY+O4EKcm1d19FRJ4WPMnh3ySUpArUQ0n8DZptMen9GbuSyKb6Cw5QpkhTNNf798zmSaks79Haug1eoMkkw/jxxgdRTz3hYw4pABMvCze74ThUTw+cij9X7zhFsXnCzXedyPFnma0VflYTwIgxMJixcEZmsWQjHrMfPQS0r4rH/qEM67JngJLSoEnYMCV1rQG6dA071W8+BTLCitAdDduIm/z1ke5ljBy9i5Sf6v2xtnKH24DSTFFHWztA9uvaxpR/Emyfxssxj693u6pExxhjWlOss2OGnM2onvdVC68JA4X9ETUWk0/bu9XfX/5Z8iY8CYyefOQO2ToYP0QklI4BoJOzCC5+HA8hBKuX+q8tU0sMdO2JSAbkVcAtGhrXtVBhBWDFQyJDSfz1S9dpo7YbBHRAf2G5f3OIYAUQQy5jMfEwLW3Gji0uCXHsKAMB6k8ThqDJIhevYedVYphgbLJr8O1B+11o85P/VDv4E4+pZNEgAUxqNsxE18faTE4KCT/h+VmQWatYwRJAUaxyjYZxHcWOWSuwT8KPV5gnWAXUGNDU8sJHjTi75RW4Nejc+iG1nG56435Lg5LWLnLb12gHGJ5yMcGRk5F2Acya+CxMBCSh/iUJ0Bb+pxYoby
 iYM6c9Y0
 jIIg4XYpHfPP9tdlGtuoyPtnSOS+1tHSfZ2ccp2DA7G8ydUlHcgEnG/nOWdY4xTUxK+86/iyoQ+sC1S93zOX79LKdCF1w+mUIJKBSTNLXpblqH1e7vXUthC7+MACEwu20dCpsLE3Nqk1wcKB950/p1x581X9EmDWzdTgKrN7wchQbsFokI/ETRBGkaLUVvynn0QBfQm+QZkrVwP3N1BP0eR7LVSYdkNLJMoKJhmHWp+r8Eg9YyDIVlJJseYdq8QU8Zdi7tAzv853G0anaHAcaT0MZiRmqIa9rafG0PYghnH5cWAZnZPgKJ/6DdtP8IcLu6qSvmjaq2SdzfL7F1ynjkhHlOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/28 04:18PM, Muchun Song wrote:
> The series fixes several bugs in vmemmap optimization, mainly around
> incorrect page accounting and memmap initialization in DAX and memory
> hotplug paths. It also fixes pageblock migratetype initialization and
> struct page initialization for ZONE_DEVICE compound pages.
> 
> Patches 1-4 fix vmemmap accounting issues. Patch 1 fixes an accounting
> underflow in the section activation failure path by moving vmemmap page
> accounting into the lower-level allocation and freeing helpers. Patch 2
> fixes incorrect altmap passing in the memory hotplug error path. Patch 3
> passes pgmap through memory deactivation paths so the teardown side can
> determine whether vmemmap optimization was in effect. Patch 4 uses that
> information to account the optimized DAX vmemmap size correctly.
> 
> Patches 5-6 fix initialization issues in mm/mm_init. One makes sure all
> pageblocks in ZONE_DEVICE compound pages get their migratetype
> initialized. The other fixes a case where DAX memory hotplug reuses an
> unoptimized early-section memmap while compound_nr_pages() still assumes
> vmemmap optimization, leaving tail struct pages uninitialized.
> 
> Changes in v8:
> - In patch 4, move VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION) to the
>   top of section_nr_vmemmap_pages().
> - In patch 4, add Acked-by from David Hildenbrand.

Thanks!

Acked-by: Liam R. Howlett <liam@infradead.org>

> 
> Muchun Song (6):
>   mm/sparse-vmemmap: Fix vmemmap accounting underflow
>   mm/memory_hotplug: Fix incorrect altmap passing in error path
>   mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
>   mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
>   mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
>   mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
> 
>  arch/arm64/mm/mmu.c            |  5 +--
>  arch/loongarch/mm/init.c       |  5 +--
>  arch/powerpc/mm/mem.c          |  5 +--
>  arch/riscv/mm/init.c           |  5 +--
>  arch/s390/mm/init.c            |  5 +--
>  arch/x86/mm/init_64.c          |  5 +--
>  include/linux/memory_hotplug.h |  8 +++--
>  mm/memory_hotplug.c            | 13 ++++----
>  mm/memremap.c                  |  4 +--
>  mm/mm_init.c                   | 47 ++++++++++++++++-----------
>  mm/sparse-vmemmap.c            | 58 ++++++++++++++++++++++++++--------
>  11 files changed, 105 insertions(+), 55 deletions(-)
> 
> 
> base-commit: 39704f00f747aba3144289870b5fd8ac230a9aaf
> -- 
> 2.20.1
> 
> 

