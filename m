Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94FEFD530C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060846B0088; Fri, 27 Feb 2026 03:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037296B0089; Fri, 27 Feb 2026 03:07:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78186B008A; Fri, 27 Feb 2026 03:07:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD9956B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:07:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8638EBA0DF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:07:01 +0000 (UTC)
X-FDA: 84489505842.10.7221C69
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8B93DA0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:06:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BH3JEO9B;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772179619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTeZz0F/xvyPF1EACAmjGDgdsxghstNqLCL/uyUX4X4=;
	b=iY5VKY9nV7YmGVGzogeLiCNoTnwaHQpivK6ZKoup0XufUdk2errRlMVBiIZwNwzEi1ortX
	5jx8Ua25sIeCJoxZ6rK3QUnbBgHBQ/1cPF6+tMNMBTqQH5qz6ACgnjp3k24YcX9puu52Ir
	EvZYp0sA36m3Isa6gyC4Mtgay0sYeZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772179619; a=rsa-sha256;
	cv=none;
	b=eTL9RzFbUKFAEkP+hbjtR0LcICctiheVR7XKotvzFa7g+5D2PBvfPMW/OrpDPuDkEW3NNw
	LTq+6xOeEXkAw/28thrtJRGdEs/QW1LvQ+7NSroqBL0MInD6YCXpTvlK0Nyx5PZMJu3EN4
	xRR4wCRVoN08DEWF1uyx7KiNPdxyoRk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BH3JEO9B;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 27 Feb 2026 16:06:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772179617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cTeZz0F/xvyPF1EACAmjGDgdsxghstNqLCL/uyUX4X4=;
	b=BH3JEO9Be6RKFr0ulxlKgajovzOPjD3SVKEk8f7tvapHX/F9vwCYOS/1cfL8VYubbKdHqN
	KnqNmAcGDfq7Y9h0i2MPyBX6x7MPr3br8N9KQs8X9xELHZZX3rBVjxJKNHf7I7OjM+ujKW
	zaeW/qL2IbjcwgEdAklxvl60e9BmVnw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-mm@kvack.org, 
	Dmitry Vyukov <dvyukov@google.com>, lkmm@lists.linux.dev, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Fernandes <joelagnelf@nvidia.com>, 
	Daniel Lustig <dlustig@nvidia.com>, Akira Yokosawa <akiyks@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Luc Maranget <luc.maranget@inria.fr>, 
	Jade Alglave <j.alglave@ucl.ac.uk>, David Howells <dhowells@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Andrea Parri <parri.andrea@gmail.com>, Pedro Falcato <pfalcato@suse.de>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
Message-ID: <yf7gon3s3efwiwpsdytujnhohnxjc3fgu7oabmia4tbhwqgcs7@rzb7sfy2wrbu>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
 <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu>
 <aaByMLSAIJM8HdbO@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaByMLSAIJM8HdbO@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8B93DA0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hfkn6ecb1bbeus93ngrezrozqpzcu8uq
X-HE-Tag: 1772179619-567123
X-HE-Meta: U2FsdGVkX18gHOflgZHk3HFk865+O9i5mK9oHwzEdDHczbkNrSiyGtNK1GC5yV3daxOPa6zzVpscDrnfCTm7nbSiEZ10n8tqGw07A6jU64S9iRmiqVdsUrPdjG07SVGuPnCaf6px3BIYDj/dauZHjt5Dkug3kOPmLWAF5HbMVDNpwQVFgSx4MiNYGKk5NCvEkYCmCQRct8pE81R0uEIjwKN40hLWdLp/+IGLVi2Kfm0uSWV9N4vQMXcYYBKDfry9u7sj52RMnS9ECdHFI8DhstHmtqXmvTvfm2jbdw6DB058F7VXaGYVvCtXj29iRlGo2V34akW002/kKpMPl8y41DaXjaizD1cchUFRCN70WDwDodox5tLasMHt893mLcWYuS3GDOnunl2XM2cNWohoffKKXh8wB4o7CnwiDXavHGhX8snFLKREkx9PWu7Syigeo9nKdgx0ZA244LKis3WYdOP6lvz3FKlleM2lRlbM7DnXQHV0Wmh+3AyUtz9yUi1cZrHv1EC492Z1/2OWcCjFXXIXuN78kl5e+X5C9m1pPEsz9gzvs09s5dwlxDmla7+1p+7nJ7SzvWt5Hoq4W/E7bxmtBfobRsOH4lD5XOQvtZucV33ObrmxepBWfIWb9CnOVpHNMILI3AArZLGQkiKvl2taTqnThgsTU8JBL2RobNZBUa6dBrkgJwQu2WvvP5qCm6Gm+cDcpdTzxdbaWQwqKJOc1WEXVDmy4lc60Mgd9VVKT7vp0FPoITQA7wPANBWRxAJfqNShL41UtWmbvWp0q4dugvEYGHbalXlBJ7hrXafoeRJeKwjoxB9aE0PV3v3ZUwf09KhK1IGKuoJFYbq81t6AsTzMrJs56hk5bmCNRaiE0STVhsFbV1l9DFNL2KwTNUeCy2wuwmbSkMPJdtJVJ97TGwkwXt8Z8oF5or0G23xXe2/7OQWDIwTlCVFEsR1yYKozAku16Vj9TFzl9LV
 mFLDN4w7
 8hlXC8onx1MshhxnqWYt0yF8v63vg+AotsuUH2VHmawR09jinHkS+xEDfrcPWIGtp3PJ56FNky7HAo+Jizya+8w2O4t5+0MMY1hsD7ERyKMThToFFcn3APshDe6mAehEEkE69kGDVweOrwVmBPdpRc87Ul4+U9pjpFuKekOd45OtQatSbqCVwoAscBljh8jQVGpZYGoCtLABGf2Zxr9i66+d1D7YV6zx0KY79h0gwW2KLM+q/6vBM+BDouoU5pR+ApGpAlrV4xDHhnfxrsDw6v+F+3Lug4jt13G03bVEi6HKWGlI30LeJeV3yvXMU27qpRWlZNaMvdoeZtP9b8n+Tz131iyRr0jzjVmRwcnAiGVslQEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 01:17:52AM +0900, Harry Yoo wrote:
> On Thu, Feb 26, 2026 at 10:45:55AM -0500, Alan Stern wrote:
> > On Thu, Feb 26, 2026 at 03:35:08PM +0900, Harry Yoo wrote:
> > > Hello, SLAB, LKMM, and KCSAN folks!
> > > 
> > > I'd like to discuss slab's assumption on users regarding memory ordering.
> > > 
> > > Recently, I've been investigating an interesting slab memory ordering
> > > issue [3] [4] in v7.0-rc1, which made me think about memory ordering
> > > for slab objects.
> > > 
> > > But without answering "What does slab expect users to do for correct
> > > operation?", I kept getting puzzled, and my brain hurt too much :/
> > > I'm writing things down to stop getting confused :)
> > > 
> > > Since I have never thought about this before, my reasoning could be
> > > partially or entirely incorrect. If so, please kindly let me know.
> > > 
> > > # Slab's assumption: Stores to object, its metadata, or struct slab
> > > # must be visible to the CPU that frees the object, when it is
> > > # passed to kfree(). It's users' responsibility to guarantee that.
> > > 
> > > When the slab allocator allocates an object, it updates its metadata and
> > > struct slab fields. After allocation, the user of slab updates object's
> > > content. As long as the object is freed on the same CPU that it was
> > > allocated, kfree() can see those stores (A CPU must be able to see
> > > what's in its store buffer), so no problem!
> > > 
> > > However, when e.g.) the pointer to object is stored in a shared variable
> > > and then freed on a different CPU, things become trickier.
> > > 
> > > In this case, I think it's fair for the slab allocator to assume that:
> > > 
> > >   1) Such stores must involve _at least_ a release barrier
> > >      (for example, via {cmp,}xchg{,_release}, or smp_store_release())
> > >      to ensure preceding stores are visible to other CPUs before
> > >      the pointer store becomes visible, and
> > > 
> > >   2) The CPU that frees an object must invoke at least an acquire
> > >      barrier to ensure that stores to object content / metadata, etc.,
> > >      are visible to the freeing CPU when it calls kfree().
> > > 
> > > Because the slab allocator itself doesn't guarantee that such
> > > barriers are invoked within the allocator, it relies on users to
> > > do this when needed.
> > 
> > It doesn't?  Then how does the slab allocator guarantee that two 
> > different CPUs won't try to perform allocations or deallocations from 
> > the same slab at the same time, messing everything up?
> 
> Ah, alloc/free slowpaths do use cmpxchg128 or spinlock and
> don't mess things up.
> 
> But fastpath allocs/frees are served from percpu array that is protected
> by a local_lock. local_lock has a compiler barrier in it, but that's
> not enough.

Hmm, this memory-ordering issue is indeed pretty mind-bending. I'd like to
share a few thoughts as well. Happy to be corrected!

For our current problem, I think the key lies in the relative ordering between
the two variables, stride and obj_exts. To address it, we need to ensure that
on the writer side, stride is assigned before obj_exts. And on the reader
side, we need to guarantee that if it can observe the latest value of
obj_exts, then it must also be able to observe the latest value of stride. If
this understanding is correct, then even if the slab API caller inserts a
memory barrier between alloc and free, or uses a spinlock (or any statement
that provides an equivalent memory-barrier effect), it would only ensure that
the writes to the pair {stride, obj_exts} as a whole happen-before the reads
of {stride, obj_exts} as a whole. However, it still wouldn't be able to
guarantee the ordering between the two variables: stride and obj_exts.

-- 
Thanks,
Hao

