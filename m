Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE887C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5850B6B007B; Tue, 11 Aug 2026 00:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535966B008A; Tue, 11 Aug 2026 00:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C5B6B008C; Tue, 11 Aug 2026 00:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7276B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:14:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A036D40149
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:14:14 +0000 (UTC)
X-FDA: 85087671228.10.D93904A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id C64D940004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:14:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RisPRFYq;
	spf=pass (imf04.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786421653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgnpJ28vans1RntJYD4IuvfP0AmT4NAbCO4b8APJluQ=;
	b=qqGLwiTAHLJ/CRYJSmEOPeo3UvXymn1M7KnKafAskC8mSGdU5nOjuS2uYxGGQS0fFa9aJv
	DtWY16hM0WKYMTJXNBcgOSeAIR5u+DwAA0ibjtNLx3xbEV6jJg8erP+mo4Bb7HU8YLjiYU
	XNClIupVPYInS1MPWozZDXPhB+yKxfQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RisPRFYq;
	spf=pass (imf04.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786421653;
	b=v66+h9AUhC2IgZzcS6FkN/Z0h9m8F/phqK+W+Aq+M7rNGgehzVIrFiiyNGA9VG+LW5uwc+
	LMx3+2rUkuZ+1KMn5OtezqwuIF07Cwj4Bdv7cvc5pZ0WIqgvEJAocDFc62L9sFci3OUvyw
	malfHm30CTXPycasnVhgxrhbCp/LLqw=
Message-ID: <7864bd62-7289-4741-a905-23593130cea9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786421650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GgnpJ28vans1RntJYD4IuvfP0AmT4NAbCO4b8APJluQ=;
	b=RisPRFYqIgCnz1LNYTT0ra4MLK5/CZN+AT1pr362E9KitMbGDyIDueq/I2NNKXdddpBG2X
	3wg30r2zPOtmIzV3VzBc/WVympEASKLpvXX2afZeR53fDSVgIsUf7Ki0N7Dpcq2uItR+e4
	CaO1NWARimcCBTFCMHyyjeCz27w2EPY=
Date: Tue, 11 Aug 2026 12:13:56 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcg-v1: fix memsw and TCP failcnt accounting
To: Guopeng Zhang <guopeng.zhang@linux.dev>, hannes@cmpxchg.org,
 mhocko@kernel.org, akpm@linux-foundation.org
References: <20260811030843.109104-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260811030843.109104-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C64D940004
X-Stat-Signature: sybcsosthfgqinuqxgb55zd7h869gusj
X-HE-Tag: 1786421652-735860
X-HE-Meta: U2FsdGVkX19gJYKFeiuBhxwWzRxnSrmCupbqFeZBPBjRlkMjqlwj8slMyT/lYLmZFjg9wJDMSDdHwtumfhu/bpF6i1DlkrxxX+yYzY9IoIQxP9BndsRX4qGZsUqZ5KmKLp7/kVPVnOYZiRnsNOPdQpvejMnqyQ1Lr+Fm7bJWEwqdxAAHISU/qD1zYOIIL/6TfOImxWdlh3YrM64+eogMbrzR2e3lIuUB8BbiHOS71PhKUd62hFLzwE+6KtPcbI29NpZT8bmExeqFzL2ZfokBZI4tOX/ycGf5hT3tBEk0siMNlF5GO1VxtZvT+aPjIvEBd7lI+T/6g3mLS7e+R4vRUzUeSz08um+DIqerYUXcSWzru1o//vOy8GWOWk5+x48hWgR4ksFd/4a+av4B0XyAYsSH4Cd4kT9Fbcwli970n1vWk903G9g7oE+n51zDA/l4iVu2sblhlCv50fE6LYiW8gRkthiwSXRYdDjLWxSBgarQVDsHb6eBiVPh3RW5jYyMnncKUUMeJYwKw2GGcb29AEZotnakYte+onE6ZrY/KZ+0Px335MfaZlImF63HX87Txgn32QPzawQtcHUhhMOl1W9BYz4lBOX5beBcD/YnRAXnXhER/8p5W6Hh3QD41cAxaiXCYBvripwBCfewOmChjTYidotRpj1YYa6LTbWyhPHvG/zRTY8Hq9U2VSR4acuiMay5vsiT5wIuQbIEtYU6NPeHvYdkRjshl9Z3HLNYG6Lqsnk6Hg1nBDgbw0ghxSTUFhOILB9jQnVAd/283TbAfCEfMW6/T6kNvHdQw/tqWDQtU5XxjOoU6jQgbqJiVL4RCmSNKb3W58UQ1ujZr9bljONMiHb1sZvpSv68JQcBPkePJmScN+T3ANS3i3PL9SFhoCbmLD8Hh2aGTsTbM028SWkp/MHAbiI93YyQukTlbzinxTPTsGvslgOKcacBxrg2/+/M2CNVXJ/Qc56oERv
 Eh1ukNfq
 kcigsKRQK8OHKxy9mrRaW+X8ugsj4H/JPoQp4KgZILu712cR2jRvGR7QM+I8eOoPQfL7zMtZ9fBbJSM/FCMLdhAShNL7SMKW+Q2IIcUL9ydO7aJjz3fEIVyCFCNNwjNZUFUlXGgsB5QSR3NZZt6A4EXMeMYdmUXMKYXluCUl/+HCL540USrYIIY5NPAdTM7C1++l5YsXXTO+kxPwZPltH6YTBkW4meC/wiFbttn6SmckBW8w6TNQ1XYVkM4xFZI9ippOLlI98qnZ0bKoIkM3O2jIuprmHwQCFLeO5cKkk5Bi+XnsdvZESnycCZuYX+nhoertWR5dUE/02Lfhx1HPB8gEIk6jXJ6zo9xucXcjlg0ZXZK7XEbn8/qsQbhVV/A/9BBRKX5+LhzG4wMpDG+LY0S6gMG3imfCXvW02lxnm/QZgOQ9qmfka/EbpHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/11 11:08, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw or
> memcg->tcpmem.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. memory.kmem.tcp.limit_in_bytes still sets
> memcg->tcpmem.max, but TCP charge failures are not reflected in
> memory.kmem.tcp.failcnt.
> 
> Enable failcnt accounting for both v1 counters.
> 
> To reproduce memory.memsw.failcnt:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.
> 
> To reproduce memory.kmem.tcp.failcnt:
> 
>     CG=/sys/fs/cgroup/memory/tcpmem-test
>     LIMIT=65536
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"
> 
> Start a child process in the cgroup, create a TCP socket, and reserve
> 1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
> ENOMEM.
> 
>     cat "$CG/memory.kmem.tcp.failcnt"
> 
> Without the patch, memory.kmem.tcp.failcnt is 0. With the patch,
> memory.kmem.tcp.failcnt is greater than 0.
> 
> Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Cc: stable@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
> Changes in v2:
> - Enable failcnt tracking for tcpmem as suggested by Johannes Weiner.
> - Add the memory.kmem.tcp.failcnt reproducer and test result.
> - Update the subject and changelog to cover both counters.
> - Add Cc: stable@vger.kernel.org and the received Acked-by tags.
> 
> Link to v1: https://lore.kernel.org/r/20260810074247.52747-1-guopeng.zhang@linux.dev
> 
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 70806373d5a9..17da1f43b7d3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4235,9 +4235,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  #ifdef CONFIG_MEMCG_V1
>  		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>  		memcg->memory.track_failcnt = !memcg_on_dfl;
> +		memcg->memsw.track_failcnt = !memcg_on_dfl;
>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
> +		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
>  #endif
>  	} else {
>  		init_memcg_stats();
Reviewed-by: Tao Cui <cuitao@kylinos.cn>


