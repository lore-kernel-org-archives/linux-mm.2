Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D68FCA18E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 21:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECEB76B0088; Mon,  9 Mar 2026 17:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99926B0089; Mon,  9 Mar 2026 17:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6C26B008A; Mon,  9 Mar 2026 17:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBF096B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:17:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F9C3B8218
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:17:03 +0000 (UTC)
X-FDA: 84527784726.18.2BFD21E
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf11.hostedemail.com (Postfix) with ESMTP id 967D740015
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:17:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773091021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+868kNUUD5WPI+uOXWp+EGYXEJ+hP8g36QeyBREC8TA=;
	b=oJhVPqa88jmX2R/v8S5DwMy4PFxFSWGkHKDoI+9hlDRm55E9Wb1VUhRQ00qbpNyC54roUN
	Zq4iAQ3eUOQKYhKy554YR/uZo7E9O0WhUcV0bNRNIHAL5phnLkwjUNQvv61KPrkXkVj9XJ
	r7e2MGqYRscBntQUhxVQr93b/FJT1is=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773091021; a=rsa-sha256;
	cv=none;
	b=tcthcIk0WLl5Pc3ZdlTKe4R+FXgvFYDe5zkW4RIHOMJn64qrJewBaMzFtnJfAuD8mP0VXe
	atPilO1DSNQG93rwPq6q6xRgf+a6yXLT7i8Om51rhMhIjXIj2HVPcS8tHHsj/77qj8AJV0
	c9EWL/NwD4sXYeP33tJU01pAgBTzI7c=
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 758CD13A869;
	Mon,  9 Mar 2026 21:16:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id D268820023;
	Mon,  9 Mar 2026 21:16:52 +0000 (UTC)
Date: Mon, 9 Mar 2026 17:17:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar
 Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <20260309171700.063318b5@gandalf.local.home>
In-Reply-To: <aa8xawMxLeUjkyHx@casper.infradead.org>
References: <cover.1772206930.git.d@ilvokhin.com>
	<aa7G1nD7Rd9F4eBH@casper.infradead.org>
	<aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
	<aa7dgQDMEz34eadj@casper.infradead.org>
	<20260309151317.7bba06dd@gandalf.local.home>
	<aa8xawMxLeUjkyHx@casper.infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/XFN/gdyLIxDXgLJKAoUlEX1WfcjSP714=
X-HE-Meta: U2FsdGVkX1+E5+zEFu4ouTTuiZydJXGiJVkVKdHWUvbBjy0A4ia2YfSTyqoJGij9+DgAvjweOf+TnyK615f48JvD9s1RuHfJZado60mdmfqgJJ7byQ52vlgQ15huzT2Mhmb2QKsL/SDQw7IheFGj/3BTI6j5nd8jRE4Y8lrR3/zc3b4j9yCDC7Htw7SsvgBcV7RPqLl6gaQB1jtkSoY0hY8X3SVQW1sT3ljl0RQzi5RGmBTU7hvQjIApbEKCso7g+rYLK9oZIRwO9+pKEjTl8uXPyDtQl3PNrK+GDCI9ogqSJQBJEFVq8oyS2DAHL9y2gWhpp+Kix9+yY0dkIGhQETrhMy3kOgMQWYVF3PTc+zFIRt6a+DK9tE1nUM7iwCh8YJV42PxUfgL1xozBUsfgrJgf7BJXda1f
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 967D740015
X-Stat-Signature: 85atxshodzddo8khrdghk5z6bbmhyb1j
X-HE-Tag-Orig: 1773091012-906581
X-Rspam-User: 
X-HE-Tag: 1773091021-337237
X-HE-Meta: U2FsdGVkX19r7eANrZwsyFgdUN9ZA459df6Q8X+HwUpAhUmmnGmigUPgIbtzn9zKGUqjXuTVJeeVj+DrcrSTvW8L9AtgiBeYQO3VdY+oy6uoNbgz1jDEyRs/E1Fz9gnszCR25aWdyI6A/CIZZP8WRTlz/eO6jR0wl8/4JPZGaM3CsoYGbkYE0XOV43wOadtMDSerOvUtQPu82u2npsRtsd3l4cLRRNBohk6sudJ1HQ6UdUfecUn0PI7DtP2W4u7ghaQzx4OLjDWZwhHsBOKmqosMs2WF0EIsJRH9uQfD2FEU18wL842GXruMDwXmaiV8d+MsrZfdf1lysaaJIQqNTQmDitm4bJBZvAuwcACWtDHcXuXNWI3I30HCu0S4ZaD2NU08erwD1nhPBMrFk8buHaOPHTDIAiS63nvjB1/4CZHIRUZw294cDj4QJP8G1u4cpekuoMHzF8zJodCAQjsPrYV3ViGNLX3LPGoOE3ih6dHGWy8WHDjunSsu4nm8J4Gfu8bPGw1P/F36kLrMKfQ0eMs/HIyIsD9TSwVnEO31uLCkuxz6iIL4WInhRpo42qK6tZT4kTRpogz/q5QmjrcQRuq4JaV4HIsoml1HP0MhQN1xZejjAJhR38j349E9/tNXLuS0EAUEa83ItRBM4bgEZHJWWv+wIUOu9EkSs6TGfu5BIlgoMQerQ2iSyWkcwLS4J0BizXHXp8ObHvXuysZfEjFxV6qFqS6l8NegwoLEggM4mktkG8Nrs0+W0Bq4gW61Nb4rbjQ6eGYujSp9KalZVPf0DQ0sAIZLYRbjo+zgIIGTDyKynPh2wwOk/LFQuoL/NZufcY5a/jjipuNxE4ydwrkf5lz/uBksh4W3JjexfK0HRetxFIbj5fTiZzvUmyUgOC/Y6C2JmctekYU7NDVX5hCMQKZhQLIPk3athgCOVZtTXjkSX7pSzJdgdhzGPo3MRJsPFipHPIlHmtiTB1g
 vTpTb8bc
 G/iNrO8l3/U6ICJsRA1AyFuv4nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 9 Mar 2026 20:45:31 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Mar 09, 2026 at 03:13:17PM -0400, Steven Rostedt wrote:
> > The biggest issue with making a generic light weight LOCK_STAT is that
> > locks are extremely optimized. Any addition of generic lock encoding will
> > cause a noticeable overhead when compiled in, even when disabled.  
> 
> I'm not sure that's true.  Taking the current Debian kernel config
> leads to a "call" instruction to acquire a spinlock:
> 
> void __insert_inode_hash(struct inode *inode, unsigned long hashval)
> {
>         struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);
> 
>         spin_lock(&inode_hash_lock);
>         spin_lock(&inode->i_lock);
>         hlist_add_head_rcu(&inode->i_hash, b);
>         spin_unlock(&inode->i_lock);
>         spin_unlock(&inode_hash_lock);
> }
> 
> compiles to:
> 
> [...]
>      280:       23 35 00 00 00 00       and    0x0(%rip),%esi        # 286 <__insert_inode_hash+0x56>
>                         282: R_X86_64_PC32      .data..ro_after_init+0x10
>      286:       48 8d 2c f0             lea    (%rax,%rsi,8),%rbp
>      28a:       e8 00 00 00 00          call   28f <__insert_inode_hash+0x5f>
>                         28b: R_X86_64_PLT32     _raw_spin_lock-0x4
>      28f:       4c 89 e7                mov    %r12,%rdi
>      292:       e8 00 00 00 00          call   297 <__insert_inode_hash+0x67>
>                         293: R_X86_64_PLT32     _raw_spin_lock-0x4
> [...]

Ah, you're correct. Looks like it's an arch specific thing. I was going
back to my memory from around 2006, but it appears that only a few archs
inline spinlocks anymore. Thomas made it a bit easier to see what does and
does not do that (in 2009).

  6beb000923882 ("locking: Make inlining decision Kconfig based")

So, perhaps adding code to the spinlocks will not be as much of a hit on I$.

> (The spinlock code is too complex for me to follow what config options
> influence whether it's a function call; you probably have enough of it
> in your head that you'd know)

Yeah, I feel like I'm always relearning the code every time I have to jump
in and understand it again.

> 
> > The other issue is the data we store for the lock. A lock is usually just a
> > word (or long) in size, embedded in a structure. LOCKDEP and LOCK_STAT adds
> > a key per lock. This increases the data size of the kernel.  
> 
> It does, but perhaps for a light weight lockstat, we could do better
> than that.  For example it could use the return address to look up
> which lock is being accessed rather than embedding a key in each lock.

Right.

-- Steve

