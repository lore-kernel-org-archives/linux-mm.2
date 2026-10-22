Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F55606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wrrawjN4
Received: by kanga.kvack.org (Postfix)
	id DA6856B09CD; Thu, 22 Oct 2026 17:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57AF6B09CE; Thu, 22 Oct 2026 17:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D956B09CF; Thu, 22 Oct 2026 17:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71646B09CD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:17:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0E9C802B2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:17:58 +0000 (UTC)
X-FDA: 85351524636.16.381B7B4
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	by imf02.hostedemail.com (Postfix) with ESMTP id E7D2480002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:17:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wrrawjN4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792703876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCGGzZyU61kJ6IDawbKZzEOK2Mn7ancoajfi8twfHqg=;
	b=3oeX3Gbj5fPH/clIksgxWHZyO1g3e1D8lwrRjSJ8pXVtEE9l2FVcybkeaKQAhdLP6E5ghJ
	h9OCF3gQdO7xBUQ77I30Z6TJ/T2kBjuk4KixETtteBzBwwEgAxvWUCAn8MPd+5OJiL2mBm
	T253+FnEaBQdVYuX4QwWylDQiSDxVVY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wrrawjN4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792703876;
	b=hiXi1pxyYd+w2GuDqRnPBQMZURW7ce+Rp+Hajz46SWlUvQR6x8vQ5zoRcb8j8ViaMLQPQq
	+t29e9GOoOE38at1qMxaRe8hQa94+X77lPlxBJMQcdR6FFerzLQ12kx792K/CIDkqFXgdG
	GFeuxhXCveD7uUb0y7LNkoTmFncSero=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=h0J8OgpZrOv3Sfgzgz7uTRPJyJ8BCDfUJCwW+8yZSG0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792703871; v=1; x=1793308671;
 b=wrrawjN44aodaSGm07ZrQDkU52fkNTAPfuDARmJ2fz01DGuv7GMM5RSk4RTU3iqqf8v72P6K
 Jmc0uFnIuEtP0VIvCZHnGZo5WvwQFD//A4klg5kClMuOOvTw+rG9yP8mDbtSHyW/eZVHTQZLpGD
 SR6CSObUb4aQXTQX+7FSK8gg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 76616d6bd444bd51;
	Thu, 22 Oct 2026 21:17:51 +0000
X-Mizu-Trace-ID: 76616d6bd444bd51
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 14:17:45 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] mm: move LRU size stat updates out of lru_lock in
 folio batches
Message-ID: <atp7tN-UfEAu3wdk@linux.dev>
References: <20261022200313.2354350-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022200313.2354350-1-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: E7D2480002
X-Stat-Signature: ahdx7czxdy9ppryt5g99swawntk5xk1e
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792703874-954091
X-HE-Meta: U2FsdGVkX1+Jje8gZcTkCV+3oY7+kZD/I6KSXepv02ot8TYIWOpwxFQfw1GaxjG5e8eQW6kW/juN0omxwpn6DU/h/hS3MEPPNTHAbO1DWRjUONh4bTpLpk16fHWlS5ptmdpEKIprz3ktrcAGLrZWUC86m4DbIiZYuwGjMe/XhcHgaLI4NzrCd+vhV8rQu9No3/hVtdu28v7eMV/1RIwVByiSkL8u7e6wonDv/ShhEopEE0jrjfcQ5qLFwVPOX6VkCcZ1qLRXquPyQ8y1XdwFgvOnqFMlVAmSC1TT0cS0mZHMfttzDegSePm+AB2HhmqukkKpmbbxPrXzNx4rIOVoeDKncJWa50ddAE0gG/G86nISviRmoNIcvOWkU0c98VFlAEOzK7LY5EW6t1+mUyV+pF6CWadbram7X2YYiHaClDL3MJbRnRZqkSwq7rB/BFXtt+ksOURa/RzKUfHhOVKaPdlK4wpB6X0u05NaPdPo/Sp2RDM9HtkTfm54czzA3rPt7fqIOUpJXxyJXKLPQMmW/FhVi0q/dshQSjnhzfl7M/Ml9XBow4HugA8fmM5qjIwXLAi0wP6OZVVERxh+KLKUPzx948q8rLvkOoPWs6r1xsDeiaIlzY3zLCE3M+AwNnmva3TTCmN0fo3wS3Jwzs80qB1rwRr4wSa2vEs7Bv8V32JavezJKfLUH2AFHk8APDzqKqDG3Nu8tEtaGvtjBIuVdyriLQVqgLKG9fKeztj0IsSzrnkMsmTpbiTSBWypvXhLljKVBEI3fgYu4uLN+7ZjbmjnUmukfir01qlqDBoBbgxQ+/Z1PKm6478s40vlv8GzfUuf/p6SIDgl6BkHIPa9XC8TjvP/YynqBYlr0Em/otyTDte6foG6FResbk3MOz35csMVhO65fHywG6swwnTkLNu44xQmCMMfi/MDwuaB3j5jnXTYq/pe7DG3Gx1IhgFZD6T5BNcbn6k8MiPLyjB
 xKNgg1Ui
 zbHHUqwpOyKO9Kq1R51VoWX9Y2DJnUpzabvUOae6QEPk9CmaM42q+jDLcckYv2WAeJpR9cBKC+lKcfm7P7tuWHQ4bqB7iAF8Q5OXDnnKELI5pNzgQAwQSA5w6VBGFF7EDvG1MwHaHbK3KqYaeLkCsTXbL6/6ixQoqOmZYuC2uTUicJfs+3CGoc7k+6aIpQ0p8SoY9cZ+xM/MdjBZG+syO3LJx5jiXP8mbrW8vAH3j8cZix/Cyd8rqkjjE258+QGj5btzvDnVnZ/mXrJ60s6AhjbVBLSTc71eNEMdF+9BB1R4+6Nn7z6pibPtbJNV0lA5O2IOlC5dE3fqgFtigPnN9usGxkjSqGNwuacbOUUtBD1YYrFYZ04mSG3HHJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 01:03:13PM -0700, Joanne Koong wrote:
> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
> once per batch, but they update the node and memcg lruvec stats for
> every folio in the batch while holding the lock. Only the LRU lists and
> the memcg lru_zone_size need lru_lock. Updating the stats while holding
> the lru_lock is unnecessary, and they make up a large part of the
> critical section, as seen in [1]. 

Can you please add a tldr from [1] here? Too much text in that link.

> With many threads faulting and freeing
> memory in a single memcg, about half of all cycles are spent waiting for
> lru_lock, and the hold time of the lru_lock directly limits throughput.

Do you have perf profile showing this? Mainly I want to know where in stats
update we are spending the CPU most.

I wonder if we can find a lower bound here by removing the stats update
altogether in this code path (just for experimentation) and measure the
throughput we get.

> 
> Accumulate the stat changes per LRU list while holding the lock instead,
> and only apply them after dropping the lock (while still inside
> the RCU read section that keeps the lruvec's memcg alive). This moves
> the stat updates out of the lru_lock critical section and turns the
> per-folio updates into at most one update per LRU list per batch.
> 
> The batch is attached to the lruvec while lru_lock is held so that the
> LRU add/del helpers don't need to pass it down. To keep struct lruvec
> from growing, cost_lock is moved into the hole after lru_lock, which
> leaves room for the batch pointer in the same cacheline as lru_lock.
> 
> The stats can now lag behind the LRU lists by one batch, which is well
> within the per-cpu batching they already have.
> 
> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> CPUs repeatedly faulting in and freeing memory in a single memcg,
> average pages per second over 7 freshly created memcgs per run, 2 boots
> each:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.47M   (+15%)
>   shmem, 80 threads  7.94M    10.33M   (+30%)
>   anon,  20 threads  3.04M     3.35M   (+10%)
>   anon,  80 threads  3.23M     3.41M   (+5%)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
> An alternative that avoids adding the lru_size_batch pointer to the lruvec
> struct is to pass the batch down explicitly, but the plumbing for this is a
> bit ugly (and doesn't cover mglru paths). The code looks like [2]. Happy to go
> with this if that is preferred.

Do you expect there might be opportunity to batch the stats other than LRU stats
you batched in this patch? If there is then I think we should at least explore
if a more general stat batching can be done.

This code looks good though.

