Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307F4CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B3E6B037F; Mon,  1 Jun 2026 08:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952426B0381; Mon,  1 Jun 2026 08:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FD56B0382; Mon,  1 Jun 2026 08:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 797906B037F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:29:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 250A8120597
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:29:00 +0000 (UTC)
X-FDA: 84831273240.10.9667684
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7B64E10000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:28:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Cnn6g6+O;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHRyrguBPu7WjFl1OHUlddAxvq9NBpFCk9kVGplZSR0=;
	b=XaifDESh67ufKYML7HeD+KQ4wIjJoJr7bBKFgIAeIFe4TRmU6vXmkP59xrsV0AfRN4+45A
	CeBXoYw8HDP9RwhLiyKIFFe0vzrMv5sUoKlaM3YPlZccs7kNTCmrIraNvhFyCy9U/W3VsS
	HEI9iSrsIwC2Tt5EnNCHrn5EChBu0Yo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Cnn6g6+O;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316938; a=rsa-sha256;
	cv=none;
	b=D/rNn8aKZg/S0j5nnb0I9BSmbcXRCqPvFUPud9mVJCNFINGFtBK5T5WV9crOS75Zzcevfk
	tv+GYw0OaHE4M+JTE3Ngs6PI8UhwqLeVSH0sibDKk84cXho0Gkv409Fm/qolP/+W3TXEYI
	260YFFYWYt070ZZtRLoeeZ4yNJTfr84=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RHRyrguBPu7WjFl1OHUlddAxvq9NBpFCk9kVGplZSR0=;
	b=Cnn6g6+ODFK5wT4XaBHnaTObdw/QAowqd8m5e/D1t6KdWIMpekWyf/wMlVDUoi/FgBj4WI8sL
	hHTe87/L/JKvtrBfk8gISf7rANXbXLO23ONE0J5rx7EC9zCFKxs9/faVTOqGiV8K+ul03BlKouf
	owJHccQmj/dOTETfgKp3ewE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gTY2c5HP5z1T4GP;
	Mon,  1 Jun 2026 20:20:40 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D9DC4056D;
	Mon,  1 Jun 2026 20:28:49 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Jun 2026 20:28:49 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Jun 2026 20:28:47 +0800
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Lance Yang
	<lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
	<shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett"
	<liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
Date: Mon, 1 Jun 2026 20:28:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: aguawixs3tiru7mzo38wj4hp84kq9tx3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B64E10000F
X-HE-Tag: 1780316936-204982
X-HE-Meta: U2FsdGVkX19nlTeYygKdbaHv+UAYB+QAmnjFKHbjIAUFCzjcN5xVkcIAarZz/6P/VXCMui+VlNB2QdFoc29W64mxhew7jaG8AvAVY7XUVCHD8dokVXPHG+G2f6YkESx4usdgEf71CyG4fx4uPrN29j9Dc2pK8ZHsZD+ORaHtWOWY/Xj4XdoV6/6itYIYpfOu4nxrkS74KulvjVkrLQxVCpYvwvkN7I78+967fObV+0uVtnsAqlCee5RjqkuRzlh0j9pI204oIaK/eVQu7SNKsb1rkMChDOCR3kXdkAsT2QCULF/5unt2WWkGUtjdlGtbuyQff3Z8T+mudYWvnuG6kH7rtzrnADuI7TFUPYkOQIthfrluTYzI2j3EFOf22oz8Up6hzLxZGfgcmB7ZtSQ1WvmAV/zbJi8ffrUj3eDhR7JPzSwtqSNe4a/NHlPvm2UI4+oJUAPzzgXi0EKA8exjWuAixS5LvKsiPhFBRpZ4x8F7zYKcXrtM1MNU4KlN+1otylVTb9qy+iib22+yKTZLlK2mnLLQ4KC32uyOm1UmdQFWN2WEHzxjgN7TP/5Wfrz/7fS8bDtVSIM4VQ2XzegnPdBvVDyBJWcm4zdSz7NxXIP3qWGNKOfBYPGUEPV8Y+23URF0AbdSO2yOsXk8Y/lSfHpd1rjoQZr6eV/UDI1R612YBByz2yCa4zzUZbuo2Z1+ROynl3+jwcXPkWsCtE7BwKCuKF56VWVI7dJgar+BmNn7n9Tpj5iDDZSmMcz8Zf1QOANv46l8qbt8Dkcf3MnHwZn9qkueUiRbxsqxTVkF27+idVYuMIPmzTduIeHA2ZwxVJlGTZOSC5RNMvjGnEsYoa6fydhX8Ol+AYxJzseT9ManrszRvsoLIZ/yBHeyDciS1wRhOksmsV1Hfw2FHw31uf+EYv+KmYb/GI12SsNktSZfQzs15MpP1u/DlMXEDfGhBdSklJ35sgfcDQfQlnw
 CGaxQ91Z
 nzQ6uF/W8nTDVObcIpa1397BxBSCmeTdLCZBjLOlqU64Z8d6D0SxcnqmuKHrX0+UkdrEJruiPlFRwoxmglvXCjAid7ymvoKzP7OVXTV6La6udZUIwKzs1y4bGKIqbp+RXdJKeioAGKyKDDra8Wcu3joE6LBzPvvYJWbUccPyZclIJds7VX3dGYnjX/zzGn36ToFtoti3l8pKOvSImp7J9PoYlN6MYtc9qVHTnawkWWCh4v30xVCzX9Vbd5mwo719NUvn0ldYf2V3kjaB9Tp+5++4Qri5TEpmoqYa0jfqbNL0BrHLngNT6Ultgy0BRJlZln6jlCfMrKUVy+HrordwaRqat1HGhs4pnURzruiqv8XNCnjHcRLC96gXHJ4NNMsgoQwNkQxfR4DKmRBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/27 22:06, Breno Leitao wrote:
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
>       (PageReserved(p) || PageSlab(p) ||
>        PageTable(p)    || PageLargeKmalloc(p))
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

Thanks for your patch.

> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f4d3e6e20e13..8f63bdfeff8f 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1325,6 +1325,28 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
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
> +	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
> +		return false;
> +
> +	return PageReserved(page) || PageSlab(page) ||

Once shake_page finds a lightweight range-based way to shrink slab, slab pages could be freed
into buddy and above PageSlab test should be removed then. Maybe add a TODO or XXX here?

> +	       PageTable(page) || PageLargeKmalloc(page);

I'm not sure but is it safe or a common way to test PageReserved, PageSlab,
PageTable and PageLargeKmalloc without extra page refcnt?

Apart from the above nits, this patch looks good to me.

Thanks.
.

