Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2D7606D807
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ApjvTxv+
Received: by kanga.kvack.org (Postfix)
	id 536B56B05B2; Wed,  4 Nov 2026 12:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8576B05B3; Wed,  4 Nov 2026 12:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEF76B05B4; Wed,  4 Nov 2026 12:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13B636B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:23:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 905C912078A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:23:37 +0000 (UTC)
X-FDA: 85398108474.11.B5B639F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F1F09180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:23:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApjvTxv+;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793813016;
	b=IUvlq1oKNDXIfrpDnseT/s8G8nfYKQmf4Cc+vjaY2X9R3qT+OjOh0OxikDKn2EKrcZmtyy
	Qw9xYLR44f29NUgdl4eilh3LuAhQH+lZS1ozH9KWWNlwLrP0Dj+9bBmyjq6KsE56CSCeo+
	h4UO0QB8H40W7KbDRTa0eiDgHtkb6ow=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ApjvTxv+;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793813016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jf+fsnmGIryZf3OQ6Nnm/qTexCHP5OkJmTCMajaRAPc=;
	b=VAjoDYq0pvt/u/2uVy0iVhmFkXiA5/lRP24w0mc2XskTCr2GVehIYwT17cq5Kb1yXlua//
	tWftAqrb5OXEG4Ay2eRuysLnTor9+E+UoKQxsDWP9aB/Nn2v96lce6VLcMwb7SCA/tzN4Y
	7ZqJtK2JmgtoEKPmJfpv1iOYMumpyjk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81A0C601F0;
	Wed,  4 Nov 2026 17:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C761F000C1;
	Wed,  4 Nov 2026 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793813015;
	bh=Jf+fsnmGIryZf3OQ6Nnm/qTexCHP5OkJmTCMajaRAPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ApjvTxv+ADLbOjqM3lRPCeOqwPSRSuzNxz+D5QFXxKZEpVzQ/EFeKhrIDwv8VEdM8
	 i9RvCnt/KyKcFM8ISXIjcUxUxOfvAJL5tJLn8T3QSTU3A1m6zCq8HrIiugsso4IK8x
	 SBGDr1kxsyYCidMpPztvPalv93jum4bx40RUEvbeoD3Tj4FPlBsNeZmz/YZBU+Y7wv
	 QHNVgyMX2F+C/k+J4JEQyhmDcIwhurdn+mLvbljUR4WuBLEp8JvXhxiuoBk8utBvkD
	 6gFRFRk2JACDzEb6seZjcCs81SF8R3xvTCzbx3drnNuheB2smeO32cq+evv3RiXX42
	 MATu3FSRICB/w==
Date: Wed, 4 Nov 2026 17:23:24 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm: split out memory-failure declarations from internal.h
Message-ID: <autp6fWoGnnsPkbL@gremlin>
References: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org>
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1F09180002
X-Stat-Signature: ksgwymn8zyr37d7kpf3zxheyq145tr1o
X-Rspam-User: 
X-HE-Tag: 1793813015-152950
X-HE-Meta: U2FsdGVkX18SQR1zHdvuyrymwuDSVJRM4S1pP4uj1wUNxkvv7mLKGNaWCAFWsOLd02AW4pFDtwqNtP9xML1cDmBErrEx84XBEFAcWvsMlaG6S5oDmM0K/e2Cfo9E+tqBc3XEO/2ELlyu+Ij3yEfZZ+iDx6Zf3dTlhqlZLbLdJGOb2tRxszLD+3sbjS9jSAZocf9/8ve2bWpAkwgCXzWErE5maIX78A0XIAg/QY2OF/9g/WVrOkyiTpcoirE+aLXX4uf5EjZn1qTNMUgtct/w9ukrxFLUYlvHTZtiBj5u5jz4t9P7/Xe2+pfJwVGtTanN6tXW218gcs9NbFVsM5wzqVzxIPtR1k4zRCgM3Nw3aQIJt6kOIxWnOvs9ckZzAgi0z65f/q312M4n35JdrK+rfHrsAFUwnLfLJwxnaEhz587LOcYDWBdDofbIm4o/8gzr3jLa6IAwDxmGVYgiGiacxPcrB25Y/PsZdgEFoSTQ5btBZ5Sr2SsV+vhVm3uzMPCFG+ky8ynxUinZfdEHDGvalv0TzLQhD048YT6rVm4vOorPNh9eWdL5NJ6g2pspZYft0IcMlx1jmVP6irmBJgQ42nh7wL+2M0jQmkqzVkKsbYrnt2D4LxwAuV9OTQUS9HNOV/j/+hujt2t7OyO7wKNb3HAxZT2X5A4+z+29PghjUiWACYUeCCNDNz5erZMaCUcTRxafuajK4B1fQEma3TC1KMTM1DNz6JYNGD4Tb9/1+4w7DGQfzkwdDtFb1xpq+Zev5tmC9yPiN+tE1WqKIjXW6IvQN8im6toFhYXAhu5DoINeVoKEaq0oq9Mtixblp8sJBj3qZTTlVOslSxK6ZEJ5s7LBeFgurebm4xYEK6rcU08cnRCwddUQP/Cm3ZRlbMENhS3hzO9UpO0BZiCxZWAoA/U7Ghuhpnt8IGj/krKhnws+v0+OeZaNf/QY4kfIS/De7uObHZGTS2qLgpHUihN
 Ktlg0eue
 vR/WGKpga4gXAMrQgj3l8O5eO/jGulDM+DHpQM6lT/C4o2y+Qiz6Pvlg0Drdyw74HM9Efy9wMZ2FMnfRkOTYrREmCFkmJk6CtkyASFAjPwvYi5qzQb0GN3LEICUq4It0NoD+pmBifVyksv/lg2dXYAxlj3MEPnL7dtdBJ9Aarbh9WuLrEXOGqyzFoQjZkPA6Jk6FlP8WaBVjh/UdBJNRHaAWFveagtU9xwqW3kta+dtl0pLny2SLtoLlncnmlLdb/pK/6VC3VKUi3/FOvR7zH2cvA8P/gh/dUoIGlmlIZJa4PIoFjbBzu5jvI7bCMob9MrStmXPzrpNUSmu2Un4KJgkzh1Vespi5mBzd0cozrxIynfL7qakcDAvhmNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 08:45:34AM -0800, Breno Leitao wrote:
> mm/internal.h carries the memory failure declarations, but only seven
> of the 81 .c files that include it use them.
>
> Move memory failure declarations to a new mm/memory-failure.h and
> include that from those seven files that need them.
>
> Move the block as is, including take_page_off_buddy(),
> put_page_back_buddy() and page_mapped_in_vma(): they live in
> page_alloc.c and page_vma_mapped.c, but are built only for
> CONFIG_MEMORY_FAILURE and called only from memory-failure.c.
>
> Keep the declarations private to mm/.
>
> No functional change.
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
> Signed-off-by: Breno Leitao <leitao@debian.org>

Thanks, nice to break this up a bit!

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS          |  1 +
>  mm/hwpoison-inject.c |  1 +
>  mm/internal.h        | 29 -----------------------------
>  mm/ksm.c             |  1 +
>  mm/memory-failure.c  |  1 +
>  mm/memory-failure.h  | 36 ++++++++++++++++++++++++++++++++++++
>  mm/memory_hotplug.c  |  1 +
>  mm/page_alloc.c      |  1 +
>  mm/page_vma_mapped.c |  1 +
>  mm/vmscan.c          |  1 +
>  10 files changed, 44 insertions(+), 29 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 27d5b599558ae7..cc973903fda09d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12441,6 +12441,7 @@ F:	include/linux/memory-failure.h
>  F:	include/trace/events/memory-failure.h
>  F:	mm/hwpoison-inject.c
>  F:	mm/memory-failure.c
> +F:	mm/memory-failure.h
>  F:	tools/testing/selftests/mm/memory-failure.c
>
>  HYCON HY46XX TOUCHSCREEN SUPPORT
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index a11222572f9789..07032ec63080e8 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -10,6 +10,7 @@
>  #include <linux/page-flags.h>
>  #include <linux/memcontrol.h>
>  #include "internal.h"
> +#include "memory-failure.h"
>
>  static u32 hwpoison_filter_enable;
>  static u32 hwpoison_filter_dev_major = ~0U;
> diff --git a/mm/internal.h b/mm/internal.h
> index 3e15dcdd8af768..b9278329f9a239 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1196,35 +1196,6 @@ static inline bool node_reclaim_enabled(void)
>  	return node_reclaim_mode & (RECLAIM_ZONE|RECLAIM_WRITE|RECLAIM_UNMAP);
>  }
>
> -/*
> - * mm/memory-failure.c
> - */
> -#ifdef CONFIG_MEMORY_FAILURE
> -int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
> -void shake_folio(struct folio *folio);
> -typedef int hwpoison_filter_func_t(struct page *p);
> -void hwpoison_filter_register(hwpoison_filter_func_t *filter);
> -void hwpoison_filter_unregister(void);
> -
> -#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
> -void SetPageHWPoisonTakenOff(struct page *page);
> -void ClearPageHWPoisonTakenOff(struct page *page);
> -bool take_page_off_buddy(struct page *page);
> -bool put_page_back_buddy(struct page *page);
> -struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
> -void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
> -		     struct vm_area_struct *vma, struct list_head *to_kill,
> -		     unsigned long ksm_addr);
> -unsigned long page_mapped_in_vma(const struct page *page,
> -		struct vm_area_struct *vma);
> -
> -#else
> -static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
> -{
> -	return -EBUSY;
> -}
> -#endif
> -
>  extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
>          unsigned long, unsigned long,
>          unsigned long, unsigned long);
> diff --git a/mm/ksm.c b/mm/ksm.c
> index d24b129932bf79..623a2cdb392428 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -44,6 +44,7 @@
>
>  #include <asm/tlbflush.h>
>  #include "internal.h"
> +#include "memory-failure.h"
>  #include "mm_slot.h"
>
>  #define CREATE_TRACE_POINTS
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b215312f261b83..78f0a13349cb3e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -68,6 +68,7 @@
>  #include "swap.h"
>  #include "page_alloc.h"
>  #include "internal.h"
> +#include "memory-failure.h"
>
>  static int sysctl_memory_failure_early_kill __read_mostly;
>
> diff --git a/mm/memory-failure.h b/mm/memory-failure.h
> new file mode 100644
> index 00000000000000..153aea6c610c03
> --- /dev/null
> +++ b/mm/memory-failure.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * mm/ internal memory failure declarations
> + */
> +#ifndef __MM_MEMORY_FAILURE_H
> +#define __MM_MEMORY_FAILURE_H
> +
> +#include <linux/mm.h>
> +
> +#ifdef CONFIG_MEMORY_FAILURE
> +int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
> +void shake_folio(struct folio *folio);
> +typedef int hwpoison_filter_func_t(struct page *p);
> +void hwpoison_filter_register(hwpoison_filter_func_t *filter);
> +void hwpoison_filter_unregister(void);
> +
> +#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
> +void SetPageHWPoisonTakenOff(struct page *page);
> +void ClearPageHWPoisonTakenOff(struct page *page);
> +bool take_page_off_buddy(struct page *page);
> +bool put_page_back_buddy(struct page *page);
> +struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
> +void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
> +		     struct vm_area_struct *vma, struct list_head *to_kill,
> +		     unsigned long ksm_addr);
> +unsigned long page_mapped_in_vma(const struct page *page,
> +		struct vm_area_struct *vma);
> +
> +#else
> +static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
> +{
> +	return -EBUSY;
> +}
> +#endif
> +
> +#endif /* __MM_MEMORY_FAILURE_H */
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 41fcdc04e54042..b0971404f0ac0a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -40,6 +40,7 @@
>  #include <asm/tlbflush.h>
>
>  #include "internal.h"
> +#include "memory-failure.h"
>  #include "mm_init.h"
>  #include "page_alloc.h"
>  #include "shuffle.h"
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index abebfb1f202e9b..b6d9f2c9cdef53 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -57,6 +57,7 @@
>  #include <linux/pgalloc_tag.h>
>  #include <asm/div64.h>
>  #include "internal.h"
> +#include "memory-failure.h"
>  #include "mm_init.h"
>  #include "page_alloc.h"
>  #include "shuffle.h"
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index e6b6170c2f4f72..d45d52436f99a0 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -6,6 +6,7 @@
>  #include <linux/leafops.h>
>
>  #include "internal.h"
> +#include "memory-failure.h"
>
>  static inline bool not_found(struct page_vma_mapped_walk *pvmw)
>  {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 50c352e9ffefc4..3db2db65319c00 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -67,6 +67,7 @@
>  #include <linux/sched/sysctl.h>
>
>  #include "internal.h"
> +#include "memory-failure.h"
>  #include "page_alloc.h"
>  #include "swap.h"
>
>
> ---
> base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
> base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> change-id: 20261104-memory-failure-split-4c7abedbe0dc
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

--
Cheers, Lorenzo

