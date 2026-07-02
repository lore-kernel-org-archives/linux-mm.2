Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6CBDC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696C66B00D1; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B356B00D3; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538C76B00D9; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 276EC6B00D1
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:46:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B5568CD18
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:56:26 +0000 (UTC)
X-FDA: 84944893572.13.9134031
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB825180004
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:56:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/FWB6jt";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783022184;
	b=aFgLMmmjYDTwHJmhWO1fw4b8h7fwMfNf/VhiaysPSMmohCoQEwsgXz4QfZF7+uO+Ykyqmn
	7D1CxhIEYahJKPFFOk/VMG0M7Fceqx1vMK8JsGD11U0J+js1QqLrMkGajGLcrbGb/KM0JT
	woJwaTLw/TMhWzWxuya9s5P2lMhw/rM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783022184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8pPyJqfnMYXXqo+RHQk7hHYPHe8mO9fxIeSu/W46PMI=;
	b=0tugRrQOQHMonrnqj+4872OiuwmeWnP7tVVz1qRehfmvG4C1VGlk+1ItXVUDlwkOXMFgep
	GDqUIqIeQIE8rGQsMvuksoXB4zx69D518GeQ3AoFKAK/dbP+SNaw5TmQkW8blyLL1MvorX
	iY2cbFX3KjNrhRnDlyUs21ajtJF5SoE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/FWB6jt";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB8CD40B45;
	Thu,  2 Jul 2026 19:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A4F1F000E9;
	Thu,  2 Jul 2026 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022183;
	bh=8pPyJqfnMYXXqo+RHQk7hHYPHe8mO9fxIeSu/W46PMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/FWB6jt/dWaj9Km4IL7UnuVEtMf+BFcFz2ur9eOgAlxhIq72KfufKL9vRuwm+hWc
	 ccEGRd6j6VI9qoSwL7i/dNhwpp+UdizZdh9oWDjT71rAYGFqkdwHW0EON7p+vwnS+8
	 cOwvxG17Z2cJktUpux8Dl5E/YNbfwxPFOaC34VqPeioGIGoVauLzv9KWQxHfj79FLC
	 aJSJqIgTeo9RF98anzhicX/8I8Y9XHTpXGWN9nrdDBZ3hkeDnOpBc4QoqSxHNZ6DTK
	 MZuKmdpziG2uSJ7lieXuXiwb0ayj+uhZZPfn+NbJ9vIli6yP5sSDuNzYnwwn52xPFE
	 esJuiGkOUKfPA==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com
Subject: Re: [RESEND RFC PATCH v2 3/5] mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
Date: Thu,  2 Jul 2026 12:56:17 -0700
Message-ID: <20260702195617.91982-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702094633.75658-4-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB825180004
X-Rspam-User: 
X-Stat-Signature: po5rercj1p3hoodonsh6k94a77eoj8by
X-HE-Tag: 1783022184-42108
X-HE-Meta: U2FsdGVkX19v/PPBGoHulJ5fgtq8ZFbzi1uiWkphYxphbP4/IJA3huV+kHfCkBNgWuyPkeoKAKRkkgZCW2hclL7M7KtFkIBLzLUO9Wlz6/tUQ0GQuETwedDRJ0Tt3AM2bUow/cLdGoipUdAzcQsslrIVDKp3WSmT7jl1ay4HdJtUYU9h0xbqugSoloUHV5aRrnojJgQt3WNAi+5z1FMomAe+3eKbeYDYOrrweSgdc3QqcLoeyZWbfivnGJ5Np+C4/QLyK+NUVWjDmCxaEQOr2bswt9PXCBN8h2JtGnNxX7bvnGIQVW+AkVU3X6rnzNZdGagqb1c/IxH7cYwJWDoPjeVfWKUen0b1gCa7i1K3t39kjiIi80kQ511JUiLGanQpF2Ru5p74UJ9GXDG8EGsDyGUOSZPpAzsMINTE23jXu5dMdSaknxCjcsCRXx+BBIgSwLUhvgEHK3hE8E9Hb4Gp/XE7ii7TFys5P7xFOk7VCEKpqrNn5wWxOsbFgTcWdWvplV0q6vF71YgHwStAMRAu9ABNKKjumi6692WUnL6mxfpg5du++y8u64ma+WonuPABHVGV8oTw/ODuISrBdVxC+umQW85F3Bof9PvZVK8C6eVXDFIa/mxN/n0Gnlw/TfxKIei3BJHx3RW1F2VwAsjFp67dqZmXUMUjCS6mdmXp9gTaak/9b71w64B0WWyAxsv9GtPYyWucKBjlwzje5IVFuqGB2EGXxMrB1/+jbvSNXNSVucguyUl0L1Mpd+cWW+ekbq4EZyCknSF6Ijyjr5v0nahu+L23xbyo6qVkmh4gHD/Q/U52BmrBXlSd99cBJlrFZC3GF2/CXElG3VAFU6zfiIEOZa/BbGHCnX2M6Z01gFXwQ5AS/idoGcNrdqOFlVjRbRCFLd9VVql7wGeGDb5oojTH1lkpkjhmjDK5if/WcqB+ex9eTuMX2J41ruSDy8pX2+/jUofK/abj4bKgrTu
 ZHiA2PaO
 XsA4OC8bvGKG0SqpjXJbnx7u9Rshi9h2yJ57o+ZNW92gkCqtNEOI4va+jqldkUA/Syu0eSOXKs0ROMEA0ZIuHcMaffdy+CT2Slrlhjn/DEwMe/jiaQezL8/uGF3dFAfGjSzECjdDYhV9z7yvaTxA65I8kt5XncN2fHGC04cZ9cqt3L94Iz4B/3Goigu1E8o3y6suKVHVFmxSqwGLgkzN2B4I+kgfM+57iOkpbRWNVFYg3obsUpMouq/G5/VWHk1Yc4iI94CdLEAIc0YCnuBCqLhQP4nZB8nw+qNqTFBzdKva8mV7m6eiXSUUKzE/AtT4miEKNHjdQuJi2R0lnGvzy2UEH75XQL3iG7ujlMbwVhCGbmsWWq6Lbt5g43ofyi+WXx2BU6pJkI1yLaOSEsegWnpaLLwjUA9OMW+h4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 17:46:31 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> When target_order is set (non-zero), the DAMOS_COLLAPSE handler now calls
> damon_collapse_folio_range() to collapse pages into the requested mTHP
> size, iterating over the target region in order-aligned chunks.  When
> target_order is 0 (default), the existing madvise(MADV_COLLAPSE) path is
> used, preserving backwards compatibility.
> 
> Region boundaries are expanded outward to the covering aligned range
> (ALIGN_DOWN start, ALIGN end) so that collapse works even after
> kdamond_split_regions reduces region sizes below the chunk size.
> collapse_huge_page() internally validates VMA bounds, so expanding
> beyond the original region is safe.
> 
> No external mmap lock is held: collapse_huge_page() acquires
> mmap_read_lock internally for validation, releases it, then acquires
> mmap_write_lock for the actual collapse.  Holding an outer
> mmap_read_lock would cause a self-deadlock when the same thread
> attempts the inner mmap_write_lock.
> 
> Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.wang@processmission.com>
> ---
>  mm/damon/vaddr.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index d27147603564..98a87609376b 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -14,6 +14,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/pagewalk.h>
>  #include <linux/sched/mm.h>
> +#include <linux/khugepaged.h>
>  
>  #include "../internal.h"
>  #include "ops-common.h"
> @@ -899,6 +900,50 @@ static unsigned long damos_va_stat(struct damon_target *target,
>  	return 0;
>  }
>  
> +static unsigned long damos_va_collapse(struct damon_target *target,
> +		struct damon_region *r, struct damos *s,
> +		unsigned long *sz_filter_passed)
> +{
> +	unsigned long addr, end, chunk_sz;
> +	unsigned long last_chunk = ULONG_MAX;
> +	unsigned int target_order = s->target_order;
> +	unsigned long applied = 0;
> +	struct mm_struct *mm;
> +	int ret;
> +
> +	if (target_order < 2 || target_order > HPAGE_PMD_ORDER)
> +		return 0;

I think this validation should be done by the caller, or whoever before this
function is called.  Let's remove this.

> +
> +	chunk_sz = PAGE_SIZE << target_order;
> +	addr = ALIGN_DOWN(r->ar.start, chunk_sz);
> +	end = ALIGN(r->ar.end, chunk_sz);

How about ALIGN() for addr and ALIGN_DOWN() for end?  I show madvise_collapse()
is doing so and being consistent to that is maybe a good idea to less confusing
users.

> +	if (end < addr)
> +		return 0;

Let's early-return for end == addr case, too.

> +
> +	mm = damon_get_mm(target);
> +	if (!mm)
> +		return 0;
> +
> +	while (addr < end) {
> +		if (addr + chunk_sz < addr)
> +			break;
> +		if (addr == last_chunk)
> +			goto next;
> +		last_chunk = addr;
> +
> +		ret = damon_collapse_folio_range(mm, addr, target_order);
> +		if (!ret)
> +			applied += chunk_sz;
> +		*sz_filter_passed += chunk_sz;

Shouldn't this call damos_va_filter_out() before damos_collapse_folio_range()?

> +next:
> +		addr += chunk_sz;
> +		cond_resched();
> +	}
> +
> +	mmput(mm);
> +	return applied;
> +}
> +
>  static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  		struct damon_target *t, struct damon_region *r,
>  		struct damos *scheme, unsigned long *sz_filter_passed)
> @@ -922,6 +967,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  		madv_action = MADV_NOHUGEPAGE;
>  		break;
>  	case DAMOS_COLLAPSE:
> +		if (scheme->target_order)
> +			return damos_va_collapse(t, r, scheme,
> +						 sz_filter_passed);

Let's use two tabs indentation on the second line of parameters, instead of
aligning things with the mix of tabs and spaces.

>  		madv_action = MADV_COLLAPSE;
>  		break;
>  	case DAMOS_MIGRATE_HOT:


Thanks,
SJ

