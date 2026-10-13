Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96EDBCC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7806B0088; Tue, 13 Oct 2026 09:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961076B0092; Tue, 13 Oct 2026 09:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F4D6B0095; Tue, 13 Oct 2026 09:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA016B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:52:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0F1E40BF5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:51:59 +0000 (UTC)
X-FDA: 85317741558.01.AC391F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38CC114000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:51:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LqPyW75b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791899518;
	b=J1pklXUs7ug9iPc7VBah/U23TXC0Umkj2vcLmPgD9OTKZ0+AdmkN/Pi9rNNrLtzj88oXUT
	3b4L9sB5fAyHH/kDRex1RmqgPGTqoG6hWi90ZFLjWtcsVRSIfOCKUCvrcby6L0lmbcJYyT
	FAtZgqCFLoOJLsgEBdgIutPGg8GJI6Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LqPyW75b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791899518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8yMgqqvpPrYc+O4zjIJ+aEtoQ4Uhcu65nRUnv/vI7s=;
	b=JELUA0UKFvB2pEhkJSBUlWdUIJbMSIZRgrZR61TLzcsjQ4b2flfy0P3SZB9sOzfL5Gsh7X
	N521yGzKbtRJvdAgYySDKCUDaW7i1a7KZKwDsctZkSVDVmGNn0ypvF8G0E41taByLTFAfQ
	G1F9A9uKqwqPI04pNmOVJ4puIDnSVwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3806E437E6;
	Tue, 13 Oct 2026 13:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6321F000FF;
	Tue, 13 Oct 2026 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791899517;
	bh=q8yMgqqvpPrYc+O4zjIJ+aEtoQ4Uhcu65nRUnv/vI7s=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LqPyW75bM0UxAfU1SR5UuFQ7ewiND++tATeDK9B7cZXSodj3VR2N6K/bBC2IRkUFq
	 LOZ4q0v+ijAu7eHvC8OLLQc2TCClvrDAn9nxyNkQlA9Ydx+UmzLKR6orn15ahfZ1cS
	 j86iloNPPHVkS8aoXUvGJ7EbOHqyYcGBiHV9zMkFM3m70qQWE2F5U7SAmE8GklKeWR
	 f1enQvRt3Zamm4guW6OrTCk467GPakE4vpciTKePeIWSG/G9hXK2FfcsPh5sZwsOUg
	 L7rv7F0UwLP/bYRcIaQIPd135vWNaKYlqNEtyP4LK+lAvrTxQIruOy/gti+dY+ptvA
	 JwU7nEM0unxbQ==
Content-Type: multipart/mixed; boundary="===============6230471068222945793=="
MIME-Version: 1.0
Message-Id: <f21dc3bab390094709065af0809fef22464aa3b98dcb48983716b6476ae35bd1@mail.kernel.org>
In-Reply-To: <20261013122125.843451-3-zhen.ni@easystack.cn>
References: <20261013122125.843451-3-zhen.ni@easystack.cn>
Subject: Re: [PATCH v2 2/6] mm/page_owner: add bpf_iter target "page_owner"
From: bot+bpf-ci@kernel.org
To: zhen.ni@easystack.cn,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,brendan.jackman@linux.dev,hannes@cmpxchg.org,ziy@nvidia.com,shuah@kernel.org
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,zhen.ni@easystack.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 13 Oct 2026 13:51:54 +0000 (UTC)
X-Stat-Signature: 19ow4c546ags66xzi7rfhm4ortf6zaca
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38CC114000D
X-HE-Tag: 1791899518-908528
X-HE-Meta: U2FsdGVkX19vUc1uqBLGfAIquW5iooZIXB+Xs07BCAM/4ibKXSh9bMx150jOPDFE6u8RpY/TiwN58vfEJFFBkJuJuwTb6M4NxEUWVo18RnBsNM4vBVVPIa1goCBQZiZgg9E7A9Y3yVYY0t3RpLDbxxWCKaCY/KsXdwoxmKfha4RqZj0bc+Wp+ZSrmGXK7xA3VbHBZn0kWeE1vZoGinvZnk/bU49SdWFE2YmKHQDSSGfuI9v0ePLIo95kfASGEvTtq/gAH2FxlwYJ9pSalYmD9plUxwUdk9YKzn+3Inzo7htxnD7siR6/JOFL+dpC2DUuA8evzYPRpilfR1QGHf91WN3vPlOVljLipwlBBPMhfsQaCsQZ9Zp9/VBbFtQXTp3RHOMwS6/7VX2vhIkwJyyEUpQG3yA5KFyuVx6AAVTHOxWRuiAmJr2ACaQMJ/8Pl5m885qgfQ5SZQ4OPubbcK80uRM4F2azzwqWpAOiL4SmhaDxU4vvYKZx51MbQ79NMMkEJiIR4+g9mUspdS/61NGWJs33O3Wtr98KE+kgriWjKByKKyxnx8gPg2w4T4gMHfCcWGKz0F8kAkCGDNIia1LAmpz5p9jTRXLGBGUFofUqGwGHnNP8XuPrARphW9fRQ08L9bcMgWz4b/w/FSemeDPHi9oinhky+m9mK29ILDYqxqYMaDInqEY6LgdSW2tr44tghvphGonTWUdyvp0x8Qq70p09ChgiRpC7JC+Vx4sTr9Outxi2hBw/iX1ezMF+wkdYktoUoYvOHxEPdow/bGGJMgKjzRHhp+5xnEgHG44TiSiM0X2LOwSy+JQzn4LDAhZiM9SA7fElgQgxYARiaQMsz0y20PMbrIbqwA7GVX7uX95RHTWOwLatSxGmlcRrb6U/XR1b9Ho5LtlU1gwoNaL/trZ70mloEsWTEquRBZjMvDCKYBnj+aiaYr+qqSEpn/bh9TN6LINCXTiE9DMaN/m
 M04Kbr3P
 sRwh+64H26sIFjSzGiOCbNG8aNEHeMIrFYu46Q1U/s1QJpZtanuRv++itKgG34XEhfUUw1E5qt5vULCZz/YP1YWauBxuil1Krqtf+PKrOGDfSap30aMTeHmYVuw7edd1Mnb9kQmDDsViABvxYTnnv1nrKlypseEI/uhwImQcv17MQTrMK7uXhtmEKkdgi/KUPqUPPtX4TZKT7CbM3E/utw+zmyh9LmNFaUhFKhWeqogiqgJKJwqogA3yEqkMnZnnypHpVYIE6omS5Bi3b30/NCnieTrRH7WbugsWkrN5CcWL07iNrBOvdWPJ2hf6/mhYfPYqws+JvgObUOvMypKxhb4gq/KHLCnnPfaQGOMLRWp5FvHUDPipaw29Wpjw2QUL5HQRFTYayfpQ7Af/ylMRvYo6tQToYyVip9xByuItcL7AeysSyxTK5mcMmvHJ24HYlwdnbAIW+bZjqm4+QBqV6cwQM3mcYuEOjkPja1HRmBORVKsXTEenmTFHYLxgBpN9j/amZrrn7mbsTaU6Xf1F51bOXrBldAuFG0iqj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6230471068222945793==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm/page_owner: add bpf_iter target "page_owner"

TL;DR:
- Missing BPF_ITER_RESCHED may let one read() loop up to 1M objects without
  yielding, risking RCU stalls on !PREEMPT
- Commit message bpftrace example counts allocations, not pages

>     mm/page_owner: add bpf_iter target "page_owner"
>
>     Register a bpf_iter target "page_owner" that walks the pages eligible
>     for page_owner output, with the same eligibility rules as the
>     /sys/kernel/debug/page_owner read path.
>
>     For each eligible page the attached BPF program receives the pfn, the
>     page and the page_owner record, and can freely filter and format output.
>
>     The po_snap record in the scan cursor is taken inside the page_ext
>     RCU window and handed to the BPF program as a copy, so no RCU window
>     is needed at consumption time. Torn reads remain possible if the
>     record is concurrently updated while it is copied, but this is the
>     same best-effort behavior as the read path has always had.
>
>     The target is registered from pageowner_init() when both
>     CONFIG_PAGE_OWNER and CONFIG_BPF_SYSCALL are enabled; a registration
>     failure only disables the bpf_iter target.
>
>     Userspace tools such as bpftrace can attach to this target like any
>     other bpf_iter. For example, to count pages owned by init (pid 1):
>
>         bpftrace -e 'iter:page_owner / ctx->po->pid == 1 / { @ = count(); }'
>
>     Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

The example in the commit message says it counts pages owned by init:

    For example, to count pages owned by init (pid 1):
        bpftrace -e 'iter:page_owner / ctx->po->pid == 1 / { @ = count(); }'

Is that accurate?  The iterator produces one record per allocation, not one
per page, because page_owner_next_eligible() skips the tail pages of
high-order allocations:

    /*
     * Don't print "tail" pages of high-order allocations as that
     * would inflate the stats.
     */
    if (!IS_ALIGNED(pfn, 1 << page_owner->order))
        goto ext_put_continue;

So '@ = count()' counts allocations made by pid 1.  An order-9 THP
allocation is counted as 1 instead of 512 pages.

Could the example or its description be corrected so that it reports what
it claims, for instance with '@ = sum(1 << ctx->po->order)' to count pages?

> diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
> new file mode 100644
> index 000000000000..938cb42ab7d7
> --- /dev/null
> +++ b/mm/page_owner_iter.c
> @@ -0,0 +1,124 @@

[ ... ]

> +static struct bpf_iter_reg page_owner_iter_reg_info = {
> +	.target			= "page_owner",
> +	.ctx_arg_info_size	= 2,
> +	.ctx_arg_info		= {
> +		{ offsetof(struct bpf_iter__page_owner, page),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +		{ offsetof(struct bpf_iter__page_owner, po),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +	},
> +	.seq_info		= &page_owner_iter_seq_info,
> +};

Should page_owner_iter_reg_info set .feature = BPF_ITER_RESCHED?

Without it, bpf_seq_read() never calls cond_resched() between objects for
this target, because can_resched = bpf_iter_support_resched(seq) is false.

page_owner_next_eligible() has no scheduling point on its hit path either:

    scan->po_snap = *page_owner;
    if (!scan->po_snap.handle)
        goto ext_put_continue;
    page_ext_put(page_ext);
    return true;

cond_resched() only runs on the ext_put_continue miss path.

When hits are back to back (runs of allocated order-0 pages, which is the
normal case for anon and page cache memory) and the BPF program writes less
than the user buffer size (the commit message's own '@ = count()' example
writes nothing to the seq_file), a single read() loops up to
MAX_ITER_OBJECTS (1,000,000) times.  Each pass does page_ext_get/put, a
struct copy and a BPF program run, with nothing yielding in between.  On
!PREEMPT kernels that holds the CPU and delays RCU quiescent states for the
whole loop.

This is the situation commit cf83b2d2e2b6 ("bpf: Permit cond_resched for
some iterators") hit in the same bpf_seq_read() loop, an rcu_sched
self-detected stall under load.  The debugfs read path doesn't have this
problem because read_page_owner() returns to userspace after every record.

The requirement for the flag looks satisfied, since nothing is held across
next() -> show(): page_owner_next_eligible() drops the page_ext RCU read
lock before returning, and already calls cond_resched() itself.  The other
iterators that can safely reschedule (task, task_file, task_vma, cgroup,
kmem_cache, dmabuf, kallsyms) all set BPF_ITER_RESCHED.

Later commits in this series (54a9d79ddbf5..e52345a241ae) do not add it.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/38403671988
--===============6230471068222945793==--

