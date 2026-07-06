Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E2BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692946B00C0; Mon,  6 Jul 2026 08:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A316B00C1; Mon,  6 Jul 2026 08:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581196B00C2; Mon,  6 Jul 2026 08:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 317D36B00C0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:22:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CE3D8DC3D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:22:23 +0000 (UTC)
X-FDA: 84958264566.26.1BD1F09
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EF87A0008
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:22:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ao6wcOs8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783340541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqwiknrRupuJ+YbQZhTDPFtrox28ElGL/EoIq2WfmbY=;
	b=7SYjU2CVo93DSzZ+0iPHCsqIV/EW08Dwqgl+iuhpsUp1EUBQVCPSPJAeL1ro/QCaBz2P/9
	x96bCD8420lIQz8+XS6uutZWvvVVdweGeItZkqOlwwc3DyQovJL4sFQLQ3xWwfLX95adea
	6i+Kx399OhZoy4kBDK87RsIZAQeVlnQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ao6wcOs8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783340541;
	b=I0nAHWm43Rwm/juS8S3l66Yk1S0LzV+Xp42Kp4XAvqblcscxb0L1Kqu9Mltict6sQFlzAW
	HPjiGhI3zg/XU5DYBBXEUWMQ9hQE1g2Vs9zlmbonnmxcyK7pEUxmnJM6Lc4PrDbLLuNbv5
	ylooBnqLJmxDOiD8CwfbrJ1ZU2R/+Jw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FqwiknrRupuJ+YbQZhTDPFtrox28ElGL/EoIq2WfmbY=;
	b=ao6wcOs8Q5O0NVhjycbAW1PzuYgJP4S9ueRwTqolkKu7NjzVYtgU476ZL2YoTz0GZ5CYUG9hW
	q3AhbPYdUrsp0tNVvxM+DIUtCw7piYh62hyoJk4gJwHwEkAjpB4nlSbIveM55jgeWUnNVqe9Xdg
	1IY7cu9UXDg/xwQ3nqpH2MA=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gv3Cw5ZCKz1T4Fk;
	Mon,  6 Jul 2026 20:13:16 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C382A40561;
	Mon,  6 Jul 2026 20:22:14 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 20:22:14 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 20:22:13 +0800
Subject: Re: [PATCH v10 2/6] mm/memory-failure: surface unhandlable kernel
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
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-2-c6ed5b62eea2@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <157b0e23-9f1e-1af2-bb44-44f1f2cab8a5@huawei.com>
Date: Mon, 6 Jul 2026 20:22:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260630-ecc_panic-v10-2-c6ed5b62eea2@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: mdnuhy6d41m3uaa9o9czowrpc3axkk1p
X-Rspamd-Queue-Id: 1EF87A0008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783340539-262171
X-HE-Meta: U2FsdGVkX1/shVaxjaammEoF9AivL52+2r9JmzVCp4S/GNN62xvUDcykTkyaUnsWSt1BzTXr7CHh1cmm5G72DA2oMg1Izf9IWOPPnRzDpiprpFFRpPN3Bs2UBs5/hIcX0CxWz2/AVXy+bfK6K4q59ppHZRpdpVF/QY1Bmera8YeDjwHlUwZT2VvtXzReVSTcjk2gwNXJF6Y6e1ltQL0pePQHRSzuaq19nQWhmPYMai+hO9tAzH31q4HbUfe1HPa69V3do+iNydNJZgvpZ6cvc2N3nfMcVyc+JLAFGfi/ksbKVtqGYHu4A22AfWuH7l19d21pktP62TjneT/6UIDII+3rVzP3DxCfgWPHQT8q3YosY1g3wUjfqKQ7rpO5HVy6WORhysFJlpzuM+hEVK0X/KTrm2oC6CsQN9Q7GwaTjRsgF9FKp1dR0sDYVi5F8Y4nRXjPuR13oBQF8WE4UDX6MB8x2jgb2Q5HCXkVfmQU7kDsTJiCHBoaVtQkDn0EQyPPCeD7aV0ZyO6x1UQSYvh/0WEyWKTt+701FiAiPOynqVUS9DcejgHQYIrMY2l4XDrukmMdouK5O9Ba71r82oQqRP3RoMKEOqM9A4wP+TCa1SZGFlCEQknfPzO4nKabTiZUzi5oiWixODO7Y1DMaqUQ5WFnvB+lAPKWPVVi2mzJ+xhUCy9/nScJux0Bd3l8G/UE9MPZPOdJYaOINQ/0znuf65CeEeXqEqi8XvvsHHsZvsKPwScKKyD+m422zyguNBoZeR+PUXW0m89q62l4vvxZlhQnjMGkompRVubLwFyC8TaHauEgpnwm6XjlWPxBAnQeORVxkYvJsU1a6v/AAlfuubvgYocRZMIAyDH9RELMOEGVaarZ624dyVqk48+x9DWJGDV+EvbXbZnJnXMILYcvnmuvRKOipK8XfZh89lWjrifN+Tj3O2E6nvwkdKKNZt2zmLTCN8jYiGabKSaEuJJ
 6W2deRIT
 84n5EUTmtm4yXor0xevT/pvUxgNuyVK++ZsuCOuAt2baW8tP9hTxgsO+L568w0NSNIYU473soNAbqV0w+aF+nl3O/OvNHNJj/o6qWoaTpqWv2LE//H4heB7+p0yxSlQ1DLZPGjBGphZ4kHQ2BPJHCc4WXxnOZQb6oaaNsZfAypc8dki68WZR0UurIgcutCzzRTZkhVPo4/k14SLOGlUUd0M+CCsxfsZ6bN2s4/4Q6+D1XhJEyTPf8nLUbJdUsqsx51Nuo9KdgfzeKDdiC6ar9oD1tNjYTguD17QavxHQXsVbeMyS1y/4TZHMPJ2/CfaQXO8B/ApEjW+eD17mOYo53Bjll7IcM1MPoN1GBPfA0CBbEgec7+h+jIh8SMGbLdDOOgk66vjH3SHyLseij38r3mDImwD9sz9/SvGFlBGGebq6YplU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/30 20:46, Breno Leitao wrote:
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
> Introduce is_kernel_owned_page(), a small predicate that positively
> identifies pages the hwpoison handler cannot recover from:
> 
>   is_kernel_owned_page(p) :=
>       PageReserved(p) ||
>       PageSlab(head) || PageTable(head) || PageLargeKmalloc(head)
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
> No MF_SOFT_OFFLINE / page_has_movable_ops() opt-out is needed: a
> movable_ops page is always PageOffline or PageZsmalloc, whose
> page_type is mutually exclusive with slab, page-table and
> large-kmalloc, and it never carries PG_reserved, so it can never
> match any of the checks above.
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
>  mm/memory-failure.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f4d3e6e20e13f..087658484e242 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1325,6 +1325,38 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
>  	return PageLRU(page) || is_free_buddy_page(page);
>  }
>  
> +/*
> + * Positive identification of pages the hwpoison handler cannot recover:
> + * pages owned by kernel internals with no userspace mapping to unmap, no
> + * file mapping to invalidate, and no migration target.
> + */
> +static inline bool is_kernel_owned_page(struct page *page)
> +{
> +	struct page *head;
> +	bool kernel_owned;
> +
> +	/* PG_reserved is a per-page flag, never set on a compound page. */
> +	if (PageReserved(page))
> +		return true;
> +
> +	/*
> +	 * Page-type bits live only on the head page, so resolve any tail
> +	 * first.  The check takes no refcount; recheck the head afterwards
> +	 * so a concurrent split or compound free cannot leave us trusting
> +	 * a stale view.  A residual free->alloc->free cannot be closed here
> +	 * (frozen slab and large-kmalloc pages cannot be pinned), but is
> +	 * harmless: where a wrong verdict could panic, memory_failure() has
> +	 * already set PageHWPoison, which bars the page from the allocator.
> +	 */
> +retry:
> +	head = compound_head(page);

It's irrelevant to this issue but should we use folio?
Anyway, this patch looks good to me.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


