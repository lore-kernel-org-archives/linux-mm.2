Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569FFCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 09:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2F16B0088; Mon,  8 Jun 2026 05:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C516B008C; Mon,  8 Jun 2026 05:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04816B0092; Mon,  8 Jun 2026 05:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8898C6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 05:12:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A2EF40980
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:12:21 +0000 (UTC)
X-FDA: 84856179282.07.B41EE8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82246C0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:12:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eU9PyMYQ;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780909939;
	b=5Pxojz7etG7uCq5I6rsg3Zybg+Khh/sDvH9UCWdi390Q/Yoy9YQ6HLXMvzSG1z6KMksF57
	0jQZvXsPwqDg5z7SQU2H/6gTCc81XdCDCC8cCzDlDQFf3bSK2wZC64VaBs0gIkEZqTCYRy
	XCNa8Gc+KNmpHoHyxdN0a9u2aHDXMl0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eU9PyMYQ;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780909939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iERoe27+MYrdO8H4QFZ3r3a7HKS5A6vCqgmgUIRzcA=;
	b=dIRfEcJBlAJHuLouCAAG0ro2m2rFMJjLwlOHL/pOZXsS/OUIMrwkmxaY4gmSCc3i9v+UNQ
	CCk4nEJjJvmtNVT18tZ7XvLbqx6Txj9toDyG8moeCm0RcR1EX6aFQUBnBbzMVwwwm5pNsG
	LRriluj0VZU/8AG2Wlmhj/sEqvleLfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4A6241664;
	Mon,  8 Jun 2026 09:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1891F00893;
	Mon,  8 Jun 2026 09:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780909938;
	bh=0iERoe27+MYrdO8H4QFZ3r3a7HKS5A6vCqgmgUIRzcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eU9PyMYQzKJA1f/XM2FG2/vwX3G4uJSPuHMlzSIliNNuxmbbaZwSjPPzEqTFxM+Sm
	 54Y7m4qdd1/jN7vvRCkSRUUwqgTJoPa3aS6od0Hb6imqUHhO09OuEd+s5XjOzqEYSo
	 cSBsLSe1CO+5F47uRRvmK6mASknS0kWeI37+QjBgB3pCbqFmO/xtO2BhvupYikyj3x
	 dqZ5mBvfbYMHajtagemxACsY1sVSuzZOBiN6QrGKrB2//bDxLDxOmCpv7491JGZWVQ
	 Ygk0oNSCrXvQZfMiH8aUea91VJN1vkVVrdZNDno1NwWOQqNTZDyYRyj1WGTun387UA
	 ZRVVZfNddtAdw==
Date: Mon, 8 Jun 2026 10:12:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 10/37] mm: add folio_zero_user stub for configs
 without THP/HUGETLBFS
Message-ID: <aiaEOe0j0hIeNa31@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <60d48e3c6f03238f385cdb8e48f6d8ffd4cff387.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d48e3c6f03238f385cdb8e48f6d8ffd4cff387.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82246C0003
X-Rspam-User: 
X-Stat-Signature: i5akjr13zn9u6b87joq5yk8an59z5fwz
X-HE-Tag: 1780909939-212363
X-HE-Meta: U2FsdGVkX19SA+jRQapjQeX0TOWZ3rjdIYHzXBI3OMhje2rsMCNBdMdtYaWrZeFaJm8W5JLy6BsxiMYa0qYjTM7f8ho+y5SLzZBiSMveqGL4D+78pO1TPEOYpHaAUT7g3xwplmFeNI7IphLvU/9+LHaKzOHaEQM2ySTp26ZmeTuYTCLxH2wj9+93Eo3Gq46wZoJR5yanKKIVyvl/O+XRXbyt7HuhaOXRuRAi1czDr0Nls3AY0YyLl7u0h/mkyzvcecwPaSTYM9Qs1xXziyv6t4cf8ND83gfcCGXH3kbz2fmWUwVjcJNoWVCGV0wGxRypDnjt0QQH19mk88nwcF0jCKg1jJPwmdzZ7sCr3Z4s1THsDhXVy0i8Tej/rS0Mz3uRAMncFJbKDQ0MuH57j+fnIrSu/tmydz9WuEeDBbF6RCoObctzHyn41lHVrnSJK9vBjfAs8GGgpYro7WHeMnp8YycY+L9EJC6PL1homzcGeZTH47d0NnlA3FAjidRQbN9cmmMR/zZtTeg9PhLOGxgTcm19NC0MTh0BXyJ24qQ2UaHKmyUG2Yhh+CG5vFuXCU3qlzsblsCRrY68VVw7a20vFdGfBYQ6sCDGTAMDPWoXe+O+MygjjHENrnnOSNvD/RkW6VuRTs9KlGd+zIZOR96tnDCe6UxD4QwGiP+Xw6nOqNxVhKuyghpXui88CGxumbZNmWZ1SwhdLqD2JJOJ55eWEo3XPvRh6srmLgsuq0LnUI9uxQIxo4ByHAf9AJZDjr2Xf4eJRRi6HXTFZBqhK5cJR2di21UV5CaqYLpIlfDa7DVLAzEBNbYpvzJZMi57IuRibsqvnxNEjrZJEJl4ahSQnGJnGr01n3pGiJRubasUqxvkQ0FyATJ+xyOL3IHEME60Rn+Yut0lqBM2x7hBAKzNV5oncgjQJW4zBgStal74UBGMcpuagb7VSxU0ttgteMdY0oUgVu4Fb+hjIOIjesq
 dKsqibOn
 dDmMWO1oIWwzBjgrbrH6fLEMf8UPIqivtVAzEVLstkXbX3lF8Q/kFgbO5w+WPtzdUKltFH8p03vZVOYyk228NB5oxSOxLKf24SeGcsuQqVKPfZObbf+mosR2l44RkiCHVqxyE2dV/Sr4bUixcDOMAQhKxcIYQ8rLdh2reqGCjol9l5Wky01XWOYDOEQKAQGIlQ6yyyAtLG2hrGlLRWARnPdsPBOhuUEvdWPlG0qyOqbyMuaAXLPid6OuEPNMIuGotkJsUJZH1XPhBWxyNNiwMqQV6LsPcHE655/dkGLwF+Qh19uh9/xheqjtYsHmE2qFFqxVP1gIqsaASXD2/qvte1664eV8QuWmrfLG0ApNTY5Z9QRUE9S4r9QdfqXdD0eruRBhMAWE0SF+hUU3Wk17W1183BLn9oc3R3metjpKAQYaJYdFBNCWgLseW9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:36:02AM -0400, Michael S. Tsirkin wrote:
> folio_zero_user() is defined in mm/memory.c under
> CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS.  A subsequent patch
> will call it from post_alloc_hook() for all user page zeroing, so
> configs without THP or HUGETLBFS will need a stub.
>
> Add a stub that uses clear_user_highpages() with aligned
> addr_hint.

It's not a stub? You're doing default behaviour for !THP || hugetlbfs?

>
> Without THP/HUGETLBFS, only order-0 user pages are allocated, so
> the locality optimization in the real folio_zero_user() (zero near
> the faulting address last) is not needed.

The 'real' folio_zero_user()?

But they're both real? In what sense is this unreal?

This commit message is pretty confusing.

> This also matches what vma_alloc_zeroed_movable_folio currently does.

You're also not explaining why we need a random new file just for a single
define, this is really weird?

And please don't add new files without adding an entry to MAINTAINERS.

While we're here, can we just move this function somewhere else? memory.c is
like the junkyard of mm. Maybe util.c.

Anyway this seems like it belongs in mm/internal.h.

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  mm/folio_zero.h | 18 ++++++++++++++++++
>  mm/page_alloc.c |  1 +
>  2 files changed, 19 insertions(+)
>  create mode 100644 mm/folio_zero.h
>
> diff --git a/mm/folio_zero.h b/mm/folio_zero.h
> new file mode 100644
> index 000000000000..c135b3a34da8
> --- /dev/null
> +++ b/mm/folio_zero.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef MM_FOLIO_ZERO_H
> +#define MM_FOLIO_ZERO_H
> +
> +#include <linux/highmem.h>
> +
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
> +void folio_zero_user(struct folio *folio, unsigned long addr_hint);
> +#else

No comment explaining what this does in comparison to the THP/hugetlbfs version?
Let's have a kdoc comment here.

> +static inline void folio_zero_user(struct folio *folio, unsigned long addr_hint)

So we have a folio (physical metadata) and an adress hint?

> +{
> +	unsigned long base = ALIGN_DOWN(addr_hint, folio_size(folio));

const please.

> +
> +	clear_user_highpages(&folio->page, base, folio_nr_pages(folio));
> +}
> +#endif
> +
> +#endif /* MM_FOLIO_ZERO_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6d3f284c607d..0943ab724032 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -17,6 +17,7 @@
>  #include <linux/stddef.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> +#include "folio_zero.h"
>  #include <linux/interrupt.h>
>  #include <linux/jiffies.h>
>  #include <linux/compiler.h>
> --
> MST
>

Thanks, Lorenzo

