Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DC2CDE007
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB5A6B00AF; Thu, 25 Jun 2026 08:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383666B0128; Thu, 25 Jun 2026 08:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272706B012F; Thu, 25 Jun 2026 08:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2B1D6B00AF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:03:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7962CA062A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:03:03 +0000 (UTC)
X-FDA: 84918299046.27.34DC45D
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf21.hostedemail.com (Postfix) with ESMTP id C6D221C000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:02:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pDGoeaE1;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782388981;
	b=b1av/h9BurbWXOC+gpTtXqFioBsWc3wTb6y3cmw3jbD1AXgkh4NwAnRH93XRLzyJ6qhv9w
	LDt7KxgARzIWRPqFf2Dg+0sRp1JeGr2JU6ijKe79uvGgQ/gAU+I8ahdkk8VPKKg4GyJegR
	ajCIne7McpfPGTv0BSUpOKsrdlf+r40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4j6eh/6cDVnwatb6KUay56xQddDfixH7xVv0MM7dHQ=;
	b=VKDQ8NZB7TLwewO14ZT38Sv3bTrD+8D8FCFSRvOkvJ549ZOLsS0DtQRWt2QuaaS/jzE8mB
	VlWxFbKdbQn9OmGLy90tdpzVR/4uot/WBOV86Uxq8W4q9FJmSv4XQck20aBW/Db78up+vV
	kX9/MLOCNnzBbkHIklQVayWUfkwpcGI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pDGoeaE1;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a4j6eh/6cDVnwatb6KUay56xQddDfixH7xVv0MM7dHQ=;
	b=pDGoeaE1orqaJuUJF3YlL+Vnw287fopT68i+dG6xsA9o5W7Z/5+UeuoCGW+WptLLR4UURY6IL
	xZNK5JwLo+OpKLANAFYGC9as9LVvkWPIpklDpvXfHHJo2ajLvwl+LTek1d3/1AFfaQBZZchBLx7
	820A4Szmx7RopIm47ARiuvw=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gmHJP1w0Cz1prnF;
	Thu, 25 Jun 2026 19:53:41 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 47D4B40537;
	Thu, 25 Jun 2026 20:02:49 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Jun 2026 20:02:49 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Jun 2026 20:02:47 +0800
Subject: Re: [PATCH v9 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
	<lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
 <20260609-ecc_panic-v9-2-432a74002e74@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ce2757e8-cb90-bf97-866a-b0a094411235@huawei.com>
Date: Thu, 25 Jun 2026 20:02:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260609-ecc_panic-v9-2-432a74002e74@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6D221C000D
X-Stat-Signature: 6a3uaru1fq35sej6fcfcd7h6tddctu6y
X-HE-Tag: 1782388979-775331
X-HE-Meta: U2FsdGVkX18aEYCzHmU6U829UNWQwBf6CYf3QDiIsi4WXEUlEE3fsY8X/ktgYh45XS7x7gHvYCoPPL/ZSZQX5hN8VwKbMNq8+EmUhXhSdyT1pkm/X3fDlEgXFSVCJxTR/0NT5GCONwndIiXxTFEhWQvXiQFCeBonYrvY5DYDVh5d5biAyhJ0Vuyf9JfIIrNVw16YzVsoRq8uCbnKQ6OJ45bjKLtbHPESXzUvbV1rhkGDbvM2Xt9r+reJ1n0hdDM+E5023X/RNkyuRy29UYvS1YlP9qQOFK6K9fWHSMAHp0PjtAv9Ts7+vjXAIxQXjo7ZNDeJxavala+0Hu4FI96ln5TfLptobpfspeUb4K/KC3j+6M/qZv90zN7myZDLu3CxLabdWU34TgnrlbJYbtlREc2BbjvniDb7itkbWSll7j0gu6OYZgpi/Nh0K2TE3E1i2gGm59I3gIHM1XsNgYLBGkxAN1k9KJWbXI19785tPIyGlO67Ttalb232R9RWkn/QwpRKnuirXPthKmtZ4lfgJOsMELq/ZuKQ2IC+u26kq11ZyzqvHR7fd156dZJppn7qdF0artteaQKi7OU4dryKpB6ERWd/NaHqTh+OarkC17VO+0zUQ4tUOSvt6j3+errsQ7tc0orIUkDEb3DsJsCBLzLSK/TcZ0R/gL+tUrLY/YtzWrNEt3WudjEXETPutzSb+ZNphCJDN7v/OzOadnVUj5Xk6Yu2GKr8+aYcdVgrsG6jvjwqkp+MEBXURqz1xJ/phNA4sMrVRhtgaFTtReXh0dBxThxGx3LK4+Sq1uRw1vMOmgnK6gaMSxDheHZ/sI89p9FqYG7+1KUnhP1CVkU14+Edm0inzBcbpjgO5ntj6ZUIN/sZz0c4B8BgiUgpPOh+KhgbBEbF3/cBFXaHy9XePyCmOchNwvb4BDUttIVmfWpoulZBo5tVl8PDhELXjhThM6s+ruQP30ZOIHfStv6
 kObQGkAY
 QzVqzY54tvoo+XU9n2Q/45WZDTcFtDaO4OjrrdnAav7g/voZsHu+V+Tcw+eD60x0VkrBdGFqX0SlVPFhu82SLKF+FLCu13LcUEMppLXVmnQQZYwzeI1KFkGUymzLaheDBqGBiIgGBQPg5ioOFTbSj72t+G0XW/bnu5YN/Dtmm6FduIQ5gq+keQbaf9XEfI2eu/9D9Ibgr5qx86GgAkikJlhiK4l8PNAlFfDC/5WmI3/HZWf5onbq5tO+9vFRM2s8a0VBP1eyt264+qLKh7LDIS6fzdaACVZrNj6KQXmIg56kpxvDcEC13E/7eqAnWbtgAL+KJI3NHv3CdsLkULFcAgSgSKi7N/NmY/HHUhuEwe9UIi0b+v21RaiMHA9LLcewjs4ucunpz9KH3AKrRxB17QKfFKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/9 18:56, Breno Leitao wrote:
> get_any_page() collapses every HWPoisonHandlable() rejection into a
> single -EIO via the __get_hwpoison_page() -> -EBUSY -> shake_page()
> -> retry path.  That is correct for the transient case (a userspace
> folio briefly off LRU during migration or compaction, which a later
> shake can drag back), but wrong for stable kernel-owned pages: slab,
> page-table, large-kmalloc and PG_reserved pages will never become
> HWPoisonHandlable(), so the retry loop is wasted work and the final
> -EIO loses the "this is structurally unrecoverable" information.
> memory_failure() then maps -EIO into MF_MSG_GET_HWPOISON, which the
> panic-on-unrecoverable sysctl deliberately does not act on.
> 
> Introduce HWPoisonKernelOwned(), a small predicate that positively
> identifies pages the hwpoison handler cannot recover from:
> 
>   HWPoisonKernelOwned(p, flags) :=
>       !(MF_SOFT_OFFLINE && page_has_movable_ops(p)) &&
>       (PageReserved(p) ||
>        PageSlab(head) || PageTable(head) || PageLargeKmalloc(head))
> 
>   where head = compound_head(p).
> 
> PG_reserved is a per-page flag (PF_NO_COMPOUND) and is tested on the
> page directly.  The slab, page-table and large-kmalloc page-type bits
> are only stored on the head page, so those tests resolve the compound
> head first, then re-read compound_head(page) afterwards: a concurrent
> split or compound free that moves head invalidates the just-read flags
> and the loop retries.  The lookup still takes no refcount, mirroring
> the rest of get_any_page(); the recheck closes the common split race,
> and a residual free->alloc->free in the same window can only mis-tag
> a genuinely poisoned page, never reclassify a handlable one.
> 
> The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors the
> same exception in HWPoisonHandlable(): soft-offline is allowed to
> migrate movable_ops pages even though they are not on the LRU, and
> we must not pre-empt that with an unrecoverable verdict.
> 
> The list is intentionally not exhaustive.  vmalloc and kernel-stack
> pages, for example, do not carry a page_type bit and would need a
> different oracle; they keep going through the existing retry path
> unchanged.  This is the smallest set we can identify with certainty
> by page type.
> 
> Wire the helper into the top of get_any_page() to short-circuit
> those pages before the retry loop runs.  On a hit, drop the caller's
> MF_COUNT_INCREASED reference (if any) and return -ENOTRECOVERABLE
> straight away.  Pages outside the helper's positive list still take
> the existing retry path and return -EIO, leaving operator-visible
> behaviour for those cases unchanged.
> 
> Extend the unhandlable-page pr_err() to fire for either errno and
> update the get_hwpoison_page() kerneldoc to document the new return.
> 
> memory_failure() still folds every negative return into
> MF_MSG_GET_HWPOISON via its existing "else if (res < 0)" branch, so
> this patch on its own only changes the errno that soft_offline_page()
> can propagate to its callers.  A follow-up wires -ENOTRECOVERABLE
> through memory_failure() and reports MF_MSG_KERNEL for the
> unrecoverable cases, which is what the
> panic_on_unrecoverable_memory_failure sysctl observes.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f4d3e6e20e13..eed9de387694 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1325,6 +1325,46 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
>  	return PageLRU(page) || is_free_buddy_page(page);
>  }
>  
> +/*
> + * Positive identification of pages the hwpoison handler cannot recover.
> + * These page types are owned by kernel internals (no userspace mapping
> + * to unmap, no file mapping to invalidate, no migration target), so the
> + * shake_page() / retry loop in get_any_page() can never turn them into
> + * something HWPoisonHandlable() will accept.  Short-circuit them to
> + * -ENOTRECOVERABLE so callers can panic on operator request instead of
> + * spinning through retries that exit as a transient-looking -EIO.
> + *
> + * The MF_SOFT_OFFLINE / page_has_movable_ops() opt-out mirrors
> + * HWPoisonHandlable(): soft-offline is allowed to migrate movable_ops
> + * pages even though they are not on the LRU.
> + */
> +static inline bool HWPoisonKernelOwned(struct page *page, unsigned long flags)
> +{
> +	struct page *head;
> +
> +	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
> +		return false;
> +
> +	/* PG_reserved is a per-page flag, never set on a compound page. */
> +	if (PageReserved(page))
> +		return true;
> +
> +	/*
> +	 * Page-type bits live only on the head page, so resolve any tail
> +	 * first.  The check takes no refcount; recheck the head afterwards
> +	 * so a concurrent split or compound free cannot leave us trusting
> +	 * a stale view.  A free->alloc->free in the same window is still
> +	 * possible but closing it would require taking a reference here.
> +	 */
> +retry:
> +	head = compound_head(page);
> +	if (!(PageSlab(head) || PageTable(head) || PageLargeKmalloc(head)))
> +		return false;
> +	if (head != compound_head(page))
> +		goto retry;

Looks good to me with one comment: should we write above as something like below:

	bool kernel_owned;
retry:
	head = compound_head(page);
	kernel_owned = PageSlab(head) || PageTable(head) || PageLargeKmalloc(head);
	if (head != compound_head(page))
		goto retry;

I.e. we should always check whether compound_head has changed, regardless of whether
the page is owned by the kernel, so we can obtain a relatively stable result?

Thanks.
.


