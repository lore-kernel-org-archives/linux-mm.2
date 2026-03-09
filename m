Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A71FCA188
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C28E6B0088; Mon,  9 Mar 2026 16:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA446B0089; Mon,  9 Mar 2026 16:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACE56B008A; Mon,  9 Mar 2026 16:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7BA6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:45:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD0191C37D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:45:47 +0000 (UTC)
X-FDA: 84527705934.26.C2EF265
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F30F1C0004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:45:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RTmHBwoM;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773089146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4yNy3lRvtr7DNqjSe9i+ak2Rs4uSSCRK8vrL3F+Og0=;
	b=3HFZ9tBFzH6SduztRfIqG/lALU1PM1kYl37TwcEJxFmpPHzUqtCh1apUVdXsznPUHSQPWz
	Oy/xcdx0JGg5XlSrHtBT1A7QTagqrez4tQ6ruwxZj26kWJys28H6crUugyRvxxvw0TXboL
	Hitq9Y3A56B1qXaxSnCmB1F6Ta/Fy/o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RTmHBwoM;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773089146; a=rsa-sha256;
	cv=none;
	b=pBe4HBCT4ylRoP3kaXvd3jT5IFyMcD3teOsRmDME/SS9jcALCHg8yzUUHyfbrfDQbfN0mf
	xPu0LouImVLbXPntltZ/wEXWSeFIC222nEgLDNCfcapxg1Wwlr2lpF8D9T7oZAk53yWvIz
	uZE/lrJZ88Q3VzELltop08OUkkAb/Io=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r4yNy3lRvtr7DNqjSe9i+ak2Rs4uSSCRK8vrL3F+Og0=; b=RTmHBwoMEWEWandsONyKrPQGnH
	H3WB7HuaACFWcRvvHFroDFbJLPNirJlH0cZpU0QDFzhHQsJ9ZIuHtymJymuxR3SnZ2pWnqAQmyJ/Q
	wm6R3jCgcLv4qlmbCZv9V0sqVthPMyJQof+WqqLM1DZIzOkLPIE4F3tFi6EusZtbnL1EiX0U5C/aR
	X2tlk5bceSWqNSSD90PAkvsqSWB/8WEdv+NcHFJr6Udia05d7sVYQFNPqmDt5HP+6C7EOg3SJ/0bx
	Bok5XbWq3pQhXWvgfKEsd7A1FoXLhL6s83nE8mPkjyTOIKRjYGMxi1xQ3KYj3RGTEpyzj5MzgKqJO
	X0QkEUhg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzhTo-00000006XCe-07wa;
	Mon, 09 Mar 2026 20:45:32 +0000
Date: Mon, 9 Mar 2026 20:45:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <aa8xawMxLeUjkyHx@casper.infradead.org>
References: <cover.1772206930.git.d@ilvokhin.com>
 <aa7G1nD7Rd9F4eBH@casper.infradead.org>
 <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
 <aa7dgQDMEz34eadj@casper.infradead.org>
 <20260309151317.7bba06dd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309151317.7bba06dd@gandalf.local.home>
X-Rspamd-Queue-Id: 4F30F1C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: wzu11xydfp67rwfmuewo6gnnsh9xp9xz
X-Rspam-User: 
X-HE-Tag: 1773089145-280361
X-HE-Meta: U2FsdGVkX1/feBfq93rTdHSANTYZgH/VVE8Td795FydKZEF7Xz5J4k5OzGYIgG8mycX7YjtlHQHGIZkV5ZHmLHCI2mWViO8CmsYkgWUhGaWafrNnc+p6blLwpHvZ0Viol/UnkmAs9ayPwsU8DYO3qOOGjOpM/8uj3T8u0plUSKloXgpYjPtctj/UwN+sVGtksgsGS/bB9yxYGm2N/jP3bCI1JDAd8l0wMjzvVLD6ev/pZssddCQkVE+tucJyt9dpPrh4Xyq96GwVZiqkbMjYa49zZsYcgifwGiUBmop6XEtoOaYtVh2jsv5+feKJepU9qe5vZaBpdWwmacrunBHXI10ohsvgsvvQl4zm2rY226iusfhzug5iuODHnuDk0cGEVCo8Ef5DtKD5PYf1R8RRZQ9JeEpNpZin2CoxKuNDEGkFCXVWU+01ckRt/WwhjRkfZQEscqA27yQOIEhqB8KjkblbGpiP8ooKalwmuqJOFG6FCi0kzypZVG+Wt7Ie6T+fcKggtdIPxYYU4k3uekV0lYzLe1eFKF0Bdi+ul6Za5DvAfNvn4Vv+2LK199tlbzD5qY+stpcoDGYA5fDUpjGBt5q744kbDYL3Uabw+qHGXF4Y5zPHqcpAM6zG7i+UMkDWIfKK7c/9H/j8f45sXBYw0pde0wXf1a67mHIHFZoSM1mJZzwQB0IQseRN+2VoniKvkdlVn1/YQVWeAD3w8iCo5Jv2sUqZbflLlTz45kZnwOAmOoTyEwAO7JNV+q3MmhGlqCVPOBtWN35WJFQeBZse4zCT494naZCQ+FTTzGt2isTf0UEzn0RUJSsyO1RSCJOqkP0ZloHPdeCZaslOv2kLUdxroZwlNhaU3cR9DrEymrBL+yMohIec1EOqtozJ2R0W8dF9ZxopZ4YZwYHSQ4bdEJRq5J5QQ2YWQJTx1S3FLcjd8gYq+ONLa/88F0H1zEDB8x3ZaJoQiu/wIYcDRZQ
 P/+XfaPV
 9Ue+G1rGcGF2vw9Q811uzSQ1LbJGolERqmOwNMPWoxphB37WngjFlxZ3SIBi7Cvmo6D8LpVh9KRaQBZZHw1cKi7OPVNuWGNe5f+G/uD/KSwAWAenmd7gw1MZbUA+FWcwG3HhtNn6kPfbiEr+v10o4bAK52BBYvobMaXgo+kXW8Hot5S99Erckw5b15eqsTlRt6uz5X+Bebea4B7wW8mTGMSlFGYTbGFuPgBNWflmp8YrbpDihgK2xYmNY5Rv0AMYnpGbQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 03:13:17PM -0400, Steven Rostedt wrote:
> The biggest issue with making a generic light weight LOCK_STAT is that
> locks are extremely optimized. Any addition of generic lock encoding will
> cause a noticeable overhead when compiled in, even when disabled.

I'm not sure that's true.  Taking the current Debian kernel config
leads to a "call" instruction to acquire a spinlock:

void __insert_inode_hash(struct inode *inode, unsigned long hashval)
{
        struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);

        spin_lock(&inode_hash_lock);
        spin_lock(&inode->i_lock);
        hlist_add_head_rcu(&inode->i_hash, b);
        spin_unlock(&inode->i_lock);
        spin_unlock(&inode_hash_lock);
}

compiles to:

[...]
     280:       23 35 00 00 00 00       and    0x0(%rip),%esi        # 286 <__insert_inode_hash+0x56>
                        282: R_X86_64_PC32      .data..ro_after_init+0x10
     286:       48 8d 2c f0             lea    (%rax,%rsi,8),%rbp
     28a:       e8 00 00 00 00          call   28f <__insert_inode_hash+0x5f>
                        28b: R_X86_64_PLT32     _raw_spin_lock-0x4
     28f:       4c 89 e7                mov    %r12,%rdi
     292:       e8 00 00 00 00          call   297 <__insert_inode_hash+0x67>
                        293: R_X86_64_PLT32     _raw_spin_lock-0x4
[...]

Debian doesn't do anything too weird here:

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set

(The spinlock code is too complex for me to follow what config options
influence whether it's a function call; you probably have enough of it
in your head that you'd know)

> The other issue is the data we store for the lock. A lock is usually just a
> word (or long) in size, embedded in a structure. LOCKDEP and LOCK_STAT adds
> a key per lock. This increases the data size of the kernel.

It does, but perhaps for a light weight lockstat, we could do better
than that.  For example it could use the return address to look up
which lock is being accessed rather than embedding a key in each lock.


