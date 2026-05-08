Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2512FCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1836B028A; Fri,  8 May 2026 16:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A16B6B028B; Fri,  8 May 2026 16:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B76A6B028C; Fri,  8 May 2026 16:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7786B028A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:39:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 559331602D1
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:39:37 +0000 (UTC)
X-FDA: 84745418394.20.47A05DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9821216000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:39:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQ2L9Xzj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778272775; a=rsa-sha256;
	cv=none;
	b=SnkZtG3tuF07WTrsr7rcD0jMirHfOAVbqNEXxVNnQfcjBWWd+F3g+5AEfszxOl9tiwA0vZ
	SH65We+QiLRiddxesVsxh6sANR5WEw5lyNBnhmdDQgKhktprrNPEo1br34P/EiteJudnEY
	WcbzDIKP7E1G9tMNGyJQKInCNBaOuiM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQ2L9Xzj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778272775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mnwflnUp3/2Yhijb9VZ8vX/YlzkuStlD4Lq9fKGvyc=;
	b=GPYy9KV4Ts0/KBbi7HF9xZyObJ/kaA0SpmpJa95Xf3HaY7vPWi/G6u9HCJwdEKhPeGMili
	sPm+0gJwGra3xGymWnuR1K0rJW5sIH5+odQsl1GJ3RJ5KwlbJJebVWCRq874Ok9OSR2hjR
	jiviMgJk7HO8PuNlSoYbTQiY0zDaZQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81A484184D;
	Fri,  8 May 2026 20:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C45C2BCB0;
	Fri,  8 May 2026 20:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778272774;
	bh=8ByH4XNJREL9RmlRSIBl4stPa2ebMaCxJC8vM7O7IY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TQ2L9XzjRsHODgvxNz/dhX7J+0LDrWdTr8QLleOcUqDqEsBCt/c3NH8BLyajI4i3+
	 fCcRhNd5JATBsN+87G1Z+J2tzDED2MVy+G1XYU8fauMxAyXcN5mnl5zhcjUC7gZwWk
	 9NUuqppobfz9Ysw11zhnrdeTwBpyG6f68+ZD4j+AyURK0tixfSLO5phFgj64XObXZ9
	 S1cWIn9z0GdCkZKjY8GB91FraTFTVRxDmesfkQ+HrXfCQ4CJgMg/UePbgmEDGKYNZB
	 c1asuqhXvZf/tX9KNnmyc5i4ARPX+ovs7fLWHdQ29VcIm2d+YENOXXKnQmtRZM+ouQ
	 qODigW93daPLg==
Date: Fri, 8 May 2026 21:39:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"surenb@google.com" <surenb@google.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast
 path
Message-ID: <af5Iqr7oLukvdJVJ@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182005.00BF70D8@davehans-spike.ostc.intel.com>
 <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
 <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com>
X-Stat-Signature: 1ufwyw4dgddo8o5om7da9x18mebcwd9f
X-Rspam-User: 
X-Rspamd-Queue-Id: 9821216000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778272775-754082
X-HE-Meta: U2FsdGVkX1+3Hg2bLQC24pPboUQffhnTiNRsWAlWXMGZfB+xId410SNKTvnX06XWKewT06uSVIjA0NZ9aWhISO+UxOBYQ1oAkYVujklvh9MfaFDRkN9U67biFND0s9YjRH7kThi+niAjDvdrJ/rtgiBUv2YMVM/VEDjr2lejaldm8V/sIfroCWmIlj4sTJtoiL1TJd1AK8L+NXiMs4nE9jUDJ8egWOWcLMPsToaMJ96oUFiDCoxDIfMEedhbdwLDk4tTkRO4ljl2GDLm5g0eHqxOOl2SZOjqUmfV9AJR313bDzQFSBvifzAw2tx0DWfPjNBm/3ERY7yIylfEFM9gGAkG4cXLWlq0+4lTlmyh/Aj/cCSgvyGisqILpzHTldWvA+MrW7bbysSeyzm+R4SyJY/JrRYZqYlj31AXE0WSpj08kkG+C5l+8VEaPUMr4Rc6l1INqgGDzK6hed+LzvRb4GRbWc93EHBhGn9kohJuedqIq8sIyHrLBfxEYI89w4L9XB+qnG9sH9CBLQ5NBqbZ/ftbeNQZysOhiSvFd9t+1bbgFGvg2bdvxnQBa5hh341NxVHFSy7ZGxZQ/jFlS6xCfm8tpfChoR8K3S1gisrcaeos9q8SdQ/n4SSsxVKfYwxcJJhS7NWaNwufoyS5Pz3A5HVO4LGynqD4jSytJ8UnCq6wSZ6UjELbgJqV8rsIkTYtgXc5JO1jFCaj9ooUX6Lapz05dUT5Yw/PgPPz5Qgih5j42cKTPSYHaGEWViQBeoWchC0Owd3WdMwlg72R3gI5s3Oucx4lwi6SyxZe6/k4cVmlWLgg1YQYtQuUD4MF9NUEJnFRWp03YDzNAiLmzvp11V4L0qW8gqF2TOWJ3Rvi6hJTzU6Yt2QYPL5bgN0Q9JkWFn3k5BaFwYP2WAoMR+IDTHj8J6BkM5qQ5zkDBVJ4p80A+jHGBSM1Vo01C7+F3Q+F72JwRCNMWtHxqPeinqH
 jT2FP8pl
 Pi/sAecRWtMXbC3Mnjnlad28b33yng2Uv0BUESblcU+aCMs2PLxiH2OOhX+f09xRn1AQMrw+8GTYHzVTgdWT1w/lH0IDtlFE8fwJSumEg0R7UeJRo9XYHrK3l4tdd88MjUOo2h2hgWagdQ+ooTlVv8SM6XvSO5MJVX8nLSgdVHCCqEYKh6EgL9IW/ShmlYEvjYK8wfuhqto8PcY00WTLtEHbNlCWdSYeZCTK4IEJ6rLtKmKUhSBO1FvcYePxhd6WNWC6j27MmqMuIoS9weOnB5sfS/UNw3S4wnK8POtHorcAMS8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 09:39:09AM -0700, Dave Hansen wrote:
> On 5/4/26 16:15, Edgecombe, Rick P wrote:
> >
> > I guess the problem is the lock ordering. Not sure if there is any slow path
> > avoidance details that could make this splat a false positive. But how about
> > this simpler munmap() case:
> >
> > Shadow stack signal                          munmap()
> > -------------------                          --------
> > vma_start_read() (VM_SHADOW_STACK check)
> >                                              mmap_write_lock()
> > mmap_read_lock() (user fault) <- deadlock
> >                                              vma_start_write() <-deadlock
>
> It's a little more complicated than that in practice, but I think you're
> right.
>
> I'm not sure when this would happen in practice because the fault is
> actually on the VMA that's being held for read. So I think another
> writer would have had to sneak in there and zap the VMA.

Honestly I think any work around is just going to be more complicated than the
existing code, which sort of defeats the purpose of the series.

There's not really a way to speculate with a VMA seqnum because you'd have to be
able to observe its vma->vm_lock_seq and to do that you'd have to find it again
immediately afterwards and then you'd looked up twice, got the lock twice only
to confirm its the same damn thing :)

The issue is that a page fault on the same thread is always going to risk an
mmap read lock being taken (possibly due to I/O waiting and fault retry for
one). And faults/zaps are inherently racey and neither acquire the write lock so
the read lock doesn't preclude them.

And you can't realy disable page faults because you're potentially relying on
them to populate what you're touching...

Also there's some tricky stuff done on initial stack initialisation that can
cause a headache as well (when stack is set up), see relocate_vma_down() to make
life more painful.

So I think the existing code is simpler.

It doesn't mean it isn't still useful to move towards having VMA locks
everywhere though :) unless Suren or others can find a flaw with that...

>
> The funny thing is that the fault handler is really just trying to find
> the VMA. The thing causing the fault *has* the VMA. So it's as simple as
> just passing the VMA down into the fault handler, right? How hard could
> it be? ;)
>
> There are still games to play, but they all involve dropping locks and
> retrying, like:
>
> retry:
> 	vma = lock_vma_under_rcu()
> 	// muck with VMA
> 	pagefault_disable() // avoid deadlock
> 	ret = copy_from_user()
> 	pagefault_enable()
> 	vma_end_read();
>
> 	if (!ret)
> 		return SUCCESS;
>
> 	mmap_read_lock()
> 	vma = vma_lookup()
> 	mmap_read_unlock() // avoid deadlock before touching userspace
> 	// check for valid VMA to avoid looping when there is no VMA
> 	if (!vma)
> 		return -ERRNO;
>
> 	// uh oh, slow path, something faulted
> 	get_user_pages()??
> 	//or
> 	copy_from_user() without the VMA??
>
> 	goto retry;
>
>
> This also needs some very careful thought, but something like this
> should work, where we avoid fault handling (and lock taking) in the
> actual #PF and do it in a context where the VMA lock is held:
>
> 	vma = lock_vma_under_rcu();
> 	pagefault_disable() // avoid deadlock
>
> 	while (1) {
> 		ret = copy_from_user()
> 		if (!ret)
> 			break;
> 		handle_mm_fault(vma, address, FAULT_FLAG_VMA_LOCK...);
> 	};
>
> 	pagefault_enable()
> 	vma_end_read();
>
> That's effectively just short-circuiting the #PF code which does the:
>
>         vma = lock_vma_under_rcu(mm, address);
> 	...
>         fault = handle_mm_fault(vma, address, ... FAULT_FLAG_VMA_LOCK)
>
> sequence _itself_.

