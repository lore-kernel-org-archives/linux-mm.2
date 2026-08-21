Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57BAC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3226B00A1; Fri, 21 Aug 2026 13:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C747E6B00A2; Fri, 21 Aug 2026 13:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BC46B00A3; Fri, 21 Aug 2026 13:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 911166B00A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:40:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 224ECA01DC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:40:47 +0000 (UTC)
X-FDA: 85125991734.11.568A2DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4EB8E40007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:40:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LsjNT4Gx;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787334045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpocrNT/gbphpP2uFGBQ6vPM0EP71cQkKN+OiupwOJs=;
	b=cJ5n/OB2UKbgPBu2/WS9MKxZZBAWGS491t9iaAR/DXFW35AU6FpJdWMuvXpeXjpezgDs+o
	sy49c3261SBNL8FI3cYHhHujA3YqGEDODS3iro4CdCLGSUgwk5iUmEihWjJdWcXfWiWzMR
	loIKyEy1KP/OvdEVwtKAbYXlf9QFWXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787334045;
	b=AZQndUncIH0RqSQHFRKkPuQppVJqWwRUgB8tWRkztraxkxqbmn8pmeqysRNPanm9EgkxXp
	utHM+I8pGYpEKrvP/4qbfuOmahJUTXCv+tXH0iQ0cDtQa2k7qUVnbIUR8Q/62GbHGkvYKl
	YSN8tXY/smVYyEzksSdmc1/Fd8vFQZQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LsjNT4Gx;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6450600E2;
	Fri, 21 Aug 2026 17:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA46A1F000E9;
	Fri, 21 Aug 2026 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787334044;
	bh=hpocrNT/gbphpP2uFGBQ6vPM0EP71cQkKN+OiupwOJs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LsjNT4GxUrx/fs/tLKpvdqHBFGBdL/p4ML74ZQcFzP3t86xFFPWcoHvzctu/VHV7L
	 amJ2q7KxElIo65xyGPV86jcqVSV97pGVDwGJJYgEl2MWaZy01R7fvQHcBB7PU4BEcJ
	 NtT0tGAfvYR5lm7Yl9/lGj6CDy8EdkaXsgSgzeNs=
Date: Fri, 21 Aug 2026 10:40:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <edumazet@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
 syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: Fix sleeping allocation in
 alloc_pages_bulk_weighted_interleave()
Message-Id: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
In-Reply-To: <20260821170407.3721004-1-edumazet@google.com>
References: <20260821170407.3721004-1-edumazet@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: bjx94ibmi5mj9ay7mx1ft4gmjzmc57xh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4EB8E40007
X-HE-Tag: 1787334045-2237
X-HE-Meta: U2FsdGVkX192Ri1rpzI2lyVq49B9S22kvjVTDA7fRXcFDjq39R9FA6iihju84+x8XwFLAdc8SXQjArqNeVjvLW2hcpzCLzOUa2Rri1sircfGRiGT5n/AhU+Rm/msbHw1+xbtYSwupfXNd0SfU5sl7hmEylI1fYoZvrhtQVH6eBfJhimq07gL6rb7LdDiQWv8WVO/ro5Lt2yuMBuLHqX9pvkYEOEQ5kflAupJyrcVw40iE0eYpchcKKDB81dJVo8ZoaDSANRAgN1tLQzVTh0/B5VSmlHVTNZRg+8PUMpLOGX0r3JhgpfV2sX0jSZ/Ks0U23FQiQ9DNA3yzFoFNvV8UrnWef0EzOTZPyn+mheONFe/4/YBb+0+JZ4M368x3dHKV94/FiV3Mtu4xTFQZMjlxWdsKPq9QQy+nDt2n7LFM7L1m37NnRACE6IXXEO69/AodroudrkFiptnq2Uu6z7Q5oZpULrBuXCCqgQd7zrCpjgk4YVehAIaaNv2LGE6C05l+O/BcPldnf4JgVKsiMH+ema6J3yiqUXYXeQILHKL42TIrftgELXLwVcOyl1xdRUikenyT+FDbJ2ZGUrdN0vo09OGVHxp6BAZiOCT14nBAd76eyHp+gi5J4s5V7+2vKUY9UHNuJqXdVrTxe+B6Lv3aUenhmSTJlBeoHo5Oakg0EPb7yTWGqiTpgUaryQcrlH+HSLqNBLdkOg98JcRplfgCiXHaV5t+psRlHvVQE3MXlcEHu6f9vjvJGLtztuhKtoUmBZrt8+L8EkYngB5MzttRNRKmK978GD57dH9Oqlk0d42TILn+HCdpzCun7civasU4TGfRjbh/9WKsyIhZmmZtrNUxhx0GbtFR3H2UZNvlo0fHSZQ3ZCUO02jXVbxrCzx6oWjl1xvQWVXStie42DlX3aL3hTN75KxSFFw757tED2dLo6D3T/yrGHb/emQG5BNrB03sMpddhZrUjur3dX
 8d6agXhk
 MQMHhgY0SP/lsrIwXXu88tI8sLZYAsnhxVQ/8TdA4IdHGYvHVi1sd9aN8Vulk8oSv8CM0jmbK7gPgCxebjzreNkgVnEZ7K/zNo0Ze8cQxW2BqAEGSBF83+j7Wm7iOTc332zv2+mPMKcoj0NeGIaParKtlVX0FjZ0Dp9HmGv8LdCoxI/3zIqjO2wF4W5X48SqSvpE0ZesC1pZT+FkwNdc7BGnIzbQhACwE/twJtmgn9/yABhyQptDMw8QE2oi5f94CfertzGOgr+qYUc2GNjTaddYpBQ4BXZuv8en8Hn8jJUa+1aPeyFA+6fqefFXibM+Ghsawm4qhP2bf+KSgPCAOUbLL9UaCXffRN2psG4+CbpU7CTHPbS254L5iH1mDRn7ErVhGzrCcq3ivh5lYsyUtx8Edva00j7bnQkhHrjljXB9DkNlbh0ILQrgJ7Ll/rHv2TLpQNWeSu8zOdaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 17:04:07 +0000 Eric Dumazet <edumazet@google.com> wrote:

> syzbot reported a sleeping function called from invalid context splat
> in bucket_table_alloc().

That was quick (7 minutes!).  I was just looking at this.

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

2 years ago.  Why are we discovering this now?

> Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
> zone modifiers like __GFP_HIGHMEM) received by
> alloc_pages_bulk_weighted_interleave() to kmalloc() instead of
> hardcoding GFP_KERNEL. Since the weights buffer is immediately
> initialized in full, kmalloc() is sufficient.
> 
> Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")

I'll add cc:stable

> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2688,7 +2688,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
>  	prev_node = node;
>  
>  	/* create a local copy of node weights to operate on outside rcu */
> -	weights = kzalloc(nr_node_ids, GFP_KERNEL);
> +	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);

lgtm, thanks.

I wonder if we *really* need the local copy of state->iw_table. 
Perhaps with appropriate care we can directly use state->iw_table in
here.

How much would it hurt to expand the rcu_read_lock() coverage?

A local array of MAX_NUMNODES bytes isn't attractive - 1k of stack.

A spinlock-protected static array would work, if super-rare slowpath.

>  	if (!weights)
>  		return total_allocated;


