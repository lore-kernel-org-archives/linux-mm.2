Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA56C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 10:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D846B0099; Mon, 24 Aug 2026 06:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F4F6B009B; Mon, 24 Aug 2026 06:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208FC6B009D; Mon, 24 Aug 2026 06:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E34BF6B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:12:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FE55804A8
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:12:34 +0000 (UTC)
X-FDA: 85135748628.19.EFADDF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CE71A0005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:12:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WozWsLt+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787566352;
	b=yycm3nAOc6JGp++55s6CJqUw7okUFkj/VpTqkxWm1iHa4OwpAl8wyIc1RnN7eyvMFpJJ8z
	CCBoTU5qRtUASyFR3xpqwaDna1tdK6XFCpmhK2qeDvawpsYnWefE7jzELNVCQfcPhHUVhO
	FgS6K3LQRPsfPIy1at+nyw57CjTVD20=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WozWsLt+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787566352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhPzGv/jLYWIV5rqDmfbQ8SCSY37BPj6+XKV+nPgTVw=;
	b=8Eo1R8NND6IQhQV8XkSldMXqObqzI4PdvhxnYqQec/V7UJk3xiqneOh9dAzw9BTL8a05hS
	3wxTRvGTqgNuye03pAi/l64Nt6YjDzJSAQZjQSAFNnPrvZDmky51URvluBPvcol2jPSyeX
	DxDpCpO5z5vIZ+v+DnWfJyqQu1tId0c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C532E42D54;
	Mon, 24 Aug 2026 10:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE80D1F000E9;
	Mon, 24 Aug 2026 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787566351;
	bh=WhPzGv/jLYWIV5rqDmfbQ8SCSY37BPj6+XKV+nPgTVw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WozWsLt+jB/GwRyOYpg2/YGtYULCzHHuEJpJhazxcp8ETvCFkDdwRoNSym+MQGejs
	 sw07//fH8xUWLNlxFkxJBqDzZsOv+VCC2oqyFOow2V8rtcYQJKa2W4zk5uWoXRe2wp
	 vf4lN/qY4ylXf6s3RQURtB7g2gceM8spgXjsx7diC+PjElapTxuzpe8ejROVGvwVCq
	 jVuk7WRd/TamkCkgLV08AarxtRCXlQ7pPvAKelcSJWZyn1W5+T3XUBGRlPRxXAj7vc
	 RWD+iWeIXKXjzq+5rHjyQnKXZCkHlwJvaYoyfO1OE3Fv210uvY1zUsJYQrH1aX/jSN
	 rKQjxGzwSEZvg==
Message-ID: <19de764c-467d-4472-8c85-a84de87bb702@kernel.org>
Date: Mon, 24 Aug 2026 12:12:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: Fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
To: Eric Dumazet <edumazet@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
 syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
References: <20260821170407.3721004-1-edumazet@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821170407.3721004-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9CE71A0005
X-Stat-Signature: ddhrm6mtqfydbaq3gf6mjh4tnpkjfght
X-HE-Tag: 1787566352-97700
X-HE-Meta: U2FsdGVkX19iP2spKLydWg+WQ76LqNJBWruB5GpDlaeIcanfs3fwpZo8dKKkoITGajCYbhwpTPzsCm0+ZJ/E099qP6cGVgfzYN5FqBkfR36mRfe0oI5N7mX5p2SmnO3K74yrgetMSssV//2clH+8MpnwSfjn9gZWAew2z4QVUCbW0Dr6AdTdqzh73b6abkluWRVaNl1cRlYieRytwLcBGfF5N/KqK2TB+EUzMF1EsSgQ61nbNYEXVn/5B+5h3RpYpSN3YWr6UC2O47SHwFICAS22IHfSjOYkZ2gliAbY5PaE6rYKDOOJF0ERSY1mWW1HtJflg/ajiJTRX7Y2qApZn4trzWT/K5I4Q+tmVLRREVEWs+O6ENgBepXNu7SdrHUxUaI8XJK5yVtiu2UefZnQkKC8JHGQaIwokorfwFwKnaSurc/PjwegpBst/vrb6zsNlfoJM1mFUn5hsJ4trBG4oFfnQ6vmdeQsGu2QKKmHDL3cpo6yBUXf6xU8IyDazSVnSfPEsqESRlfplmVc/9Qy0TKmNkigLrcIkTsjI+Ccb/0F2JAv3iGUwNycLKXLGVCxdXITE3d6h5JqegRoiItFra7DE3DOyL6gHorYmjKKg8jUqncVSmw1jgPW3mFoXiNiEicdl4aUqEQidudSnP0I7pX2Mal892Mz3DGwBREFZovVw1PiTJHBkfnZvIwYfjuuz2+Zt1wV0SEcwKUVnU4EpeNuMn3CWWCaWIliyFR09XBOtFIQsONBqFLwUXjeDJ9cBAwwRZm6TAfqXk6oVej5qnVssY9B6ugYw9ui+vxHtgSheciFvKH3SSE3e2jHRYFaYJAhEZUSCfaOeTDECK2Zll7y9T8ZjEZd/3lnvVrfgD7zleyfj0l67J5JNnxgCrzOsjWukV7+4WQ8yz7WEeGb4mVtppPdcHjx3CGn5gh7YGkeyTewSsZGRY1NcJ2gvxRttGOKQXzaGCAHBygh5J2
 ZTEgmLdn
 f6apPzx/z58v7M4p0vcEuzAbPW078h/VGAH4Onv8gEgWkYgg8WAqegSvL2KFySAtQ53p6mZ+2TONGStp/WD8LQLkz/SB0osaezj1AxerJYmJECWTlcaIkj8DbYUhcHKBt5GW/fpJv0e2XHKc/2LyAlJaKzjOGxM4HQelwZVf3XQr3rngCouVp3b88FNyGeKW+ULOpjU4zrMuu5yBETmn5nSLfrgFtgR80JgI4nxqikrQ/32ibTGv0vH94CdsbtYXjrPiVeNwSIRrU7nwG9Kq6y64d7yrrwDRsP8Z1/FZHcQiVqNRh4E7BJAcHI96RKv3aXp06DO1zcugFY5+GMOQ9taDycXOBO21yrLgU8Buy368+01UsRREKwTw+LOLCwoxgh3QB5mMAQ6wZjs90OBhkWnD3XgULwTg6g26tqqAo2DvvVQnKJ5GqdcdJa9+quTySJf1SDxMvxjEVJuXhqG7OteDBoMVuw09/CDc9+vWXeu7izbTimMqEj9hdKIUGsXWkNnOb9jEagKLi6I3iBQbAuklzWW6861zxrUIfOPL0sZ6CfeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 19:04, Eric Dumazet wrote:
> syzbot reported a sleeping function called from invalid context splat
> in bucket_table_alloc().
> 
> When rhashtable_insert_slow() rehashes the table under rcu_read_lock(),
> it calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).
> If the bucket table allocation uses vmalloc, __vmalloc_node_range_noprof()
> invokes vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with
> the passed GFP_ATOMIC flags.
> 
> If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
> alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
> GFP_KERNEL when allocating the temporary weights array, triggering
> a might_alloc() splat in atomic/RCU contexts.
> 
> Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
> zone modifiers like __GFP_HIGHMEM) received by
> alloc_pages_bulk_weighted_interleave() to kmalloc() instead of
> hardcoding GFP_KERNEL. Since the weights buffer is immediately
> initialized in full, kmalloc() is sufficient.
> 
> Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
> Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

