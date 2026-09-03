Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2C6C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CA436B008A; Thu,  3 Sep 2026 10:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AF96B008C; Thu,  3 Sep 2026 10:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2911E6B0096; Thu,  3 Sep 2026 10:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1986B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:54:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81BD08051D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:54:16 +0000 (UTC)
X-FDA: 85172746512.26.782CC42
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	by imf31.hostedemail.com (Postfix) with ESMTP id C541220002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:54:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uB0/z+i/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788447254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+e7df8WN90L1ia7KrjaholRCEtnF5KH4TCQauv94ZE=;
	b=pewfmfsZEoSe29Zp4vC7+u2a1e/ntSFciU3IIEWTJS9fq6zHJ7oWhOVOzMPHFRAcz+dnOj
	6Y4SKJerDq4Pp53eiOjVoBqkfZx+Y5h6uXiJM/h+rAnoyKHt4L21lB709KThyg4ZfPjqPN
	fkYKuld2XXR2zuIN43rFDat4kaxHc7A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uB0/z+i/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788447254;
	b=Bx09SIpqONtatcuNU6slah3n+AmJp5SJgGS+Q6/OZzJ9Fu8f9sQrYmimsjRnFxI5ue7eb7
	td0ts40LG6L2RYlu9IeBr65MQHlkoBryrzFa8K6XRK1ANkZiP7GkFyQ0QZY7lUoPPyyF3l
	zfgp0Ab1ucrCBz/wiRDsSFUBAWRIfow=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tkk36hhnqCNnAczCtVtvfHNcA6tWuFttAc23e/8SJ3E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788447248; v=1; x=1789052048;
 b=uB0/z+i/q9paYjePbOzH5+160ViJFjL597QWxJVF0x4ZSHPkgbe0yIHocKdANkm1GXcloo82
 9AR1P9+iwpR3DXbDSQSM/WEbG2h/pbq6B6fF3c8Q/36qtkDBOQ82fOuimF0/pM+rm89Lb/lJhPn
 X7sZFBnVS9/MBrNVJNWwQMpM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 05c2eb3fd5c9c093;
	Thu, 03 Sep 2026 14:54:08 +0000
X-Mizu-Trace-ID: 05c2eb3fd5c9c093
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 22:53:51 +0800
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/slab: take n->list_lock in
 __slab_try_return_freelist() to avoid race
Message-ID: <apmJiWakiBw3VAgb@fedora>
References: <20260903-slab-fix-aba-v3-1-b44cb6badd54@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903-slab-fix-aba-v3-1-b44cb6badd54@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3qphtmdohujywjtypycztb5xuz5raf84
X-Rspamd-Queue-Id: C541220002
X-HE-Tag: 1788447251-230771
X-HE-Meta: U2FsdGVkX19gm6JjadBQL+HGoeIzCdk32sV3J1ZbDaBlHsuafALMTrSSCOjcdEOk68zYam8b6zPNsIIIWUnW1Goced17wd5QIABvbsuaHQaYYFAAp/NhbYzOwxU9iDJ5Zz2Tqgjvar+Hx5ThHcd/pxR+l9QuTf2+cq2pyx0G7nrckb3kP8DMBt+1dkxkr4X8XbbKQ4ZqYv+foMybCDUQAy40JLt73Z26dkSfVDmrF535tqkyr7KtZ2e4XwX+xdaRUb2iXIh1JHokm+wZmjX3rGHU6wFV4Layds7Ye2JUHfijJr28avwOQjYq3hN6C2Ko1uKEuPDS6Z8FWf/xkG11o38yHNNQ0rkvfBU2weAh+hKmbZSRytnslIILv2sIrfzMHKPPTHhAvanSrf+AuS+FsTBNMk/xmud7mLTYpyT4fIVJ09YcyPq8+eYoKFF3tfdKyc/et0xhhGdtrRUAFClB2JGE93F1Lz6I4hcZQyCPyA3TXsuep7ndStBUKiw2eJcdyT6cXKTDVB+Y0vOFUeO1KR6NKAtM6QQICe6XxPZLd5EOn0sggrdMGQ9uG4hpNKq21MQfEZfAOQGBzi/4nK7bCfBldiOxENYXyu0oe2plWEQ5kvLmkvUM6/ViIAx8HS2KW72QML+0AIdnvtCT3NM8zwwX4SQdtpp6IIhk6c+5zR++ruXEw30FP8t+g8yYD7GvqAVj6afe8DT8XMlXZVifKgeN9rpLxYDguiUrD3eUU30y5ocnmy1uMdth+CV8gN7TzskKvEHWeJkw8wjVssGpwtiRQcFTA3jAq1ogaPTvt1sT47Hu0xgfnoypOVrbhTW0u4E32v3XAds0PjYtfgOJfJzlB8hOeBLBaBDF3sS+k9mVxyWeMlY6qLaYwmqTW8Y3dRaxd+kC1m3vLYL+BezvHBMnxOTQiQkjUQ/zpq4ZBsIgKzWAJ4cWg7c6slBbsgBlJ+J7oTlw6fECXKrm9mz
 h8XNfMym
 lXTyaPN6Rqy2fPgMViI1jcpJqhw9C5SmTDxEvmrOuOgjsNAj2l2hiHfRMwGFOCI4XyBJUQlOU8X4hQ9uoD0gACNaGNJWPDlnnwgdZtO6d9pey8PH0GRtcnXEVjaj53nM7sW8Y069pZxYNhqZLXl8dT4r1+jw4pomolClf1Z6FBg/DLEoLeu/q+riXKxbXd/rFIiDea6W/H1opgddPZcM+mT/PIQ0A1aD149yWVT84D8h7d44x9HPhCmzKy+/9pi0F6sSlPMgVoI0fuoEskqWY2gFG4yv8sKzuQTKYRK+DFGTCaS9feJBc04MyRMJdeqU+ojj8RVzJsys0zgjNhmQQD4OdFyZC+kF0sL9yqjGVDbA+sAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 03:32:26PM +0100, Harry Yoo (Meta) wrote:
> Commit ba7425312607 ("mm, slab: add an optimistic
> __slab_try_return_freelist()") incorrectly assumed that nobody has freed
> an object to the slab as long as slab->freelist is NULL and cmpxchg
> succeeds.
> 
> However, as reported by Hyunwoo Kim [1], other CPUs might have freed
> an object to the slab, insert the slab to the partial list, then
> allocated an object from the slab, and be in the middle of removing
> the slab from the list under n->list_lock.
> 
> Since __refill_objects_node() puts the slab back on pc.slabs
> outside n->list_lock, it might insert the slab into that list while
> the slab is concurrently being removed from n->partial.
> This led to a list corruption [1]:
> 
>   list_add corruption. next->prev should be prev
>   (ffff888100000248), but was dead000000000122.
>   (next=ffffea000416e410).
>   kernel BUG at lib/list_debug.c:29!
>   Oops: invalid opcode: 0000 [#1] SMP NOPTI
>   CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
>   7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
>   RIP: 0010:__list_add_valid_or_report+0x80/0xd0
>   ...
>   Call Trace:
>    alloc_from_new_slab+0x183/0x300
>    ___slab_alloc+0x31c/0x890
>    __kmalloc_noprof+0x3d4/0x800
>    lsm_blob_alloc+0x2d/0x50
>    security_msg_msg_alloc+0x26/0x90
>    load_msg+0x1aa/0x210
>    do_msgsnd+0x91/0x800
>    do_syscall_64+0x109/0x5d0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   ...
>   Kernel panic - not syncing: Fatal exception
> 
> This is a classic ABA problem where cmpxchg succeeds but the state has
> changed since __refill_objects_node() took the freelist from the slab.
> 
> As Vlastimil Babka mentioned [2], it should be rare to return more than
> one slab (due to the racy read of slab->counters in
> get_partial_node_bulk()). Therefore, instead of introducing additional
> complexity, acquire and release n->list_lock twice in the worst case.
> 
> Return the slab directly to the partial list and hold n->list_lock
> across the cmpxchg and add_partial(). This is similar to the initial
> version of commit ba7425312607 [3]. This is enough to avoid the race as
> the list manipulation is serialized by n->list_lock. While at it,
> bring back unlikely() hint now that the condition is unlikely.
> 
> Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/apPa-cGLcyt90l-E@v4bel [1]
> Link: https://lore.kernel.org/linux-mm/ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org [2]
> Link: https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org [3]
> Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
> Changes in v3:
> - Don't repeat "As reported by Hyunwoo Kim" in changelog (Vlastimil)
> - Pass kmem_cache_node pointer directly to __slab_try_return_freelist() (Vlastimil)
> - Link to v2: https://lore.kernel.org/r/20260902-slab-fix-aba-v2-1-d1ece15a8417@kernel.org
> 
> Changes in v2:
> - Simplify the code to hold n->list_lock across cmpxchg + add_partial()
>   and acquire the lock twice in the rare worst case.
> - Link to v1: https://lore.kernel.org/r/apPa-cGLcyt90l-E@v4bel
> ---
>  mm/slub.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 

Looks good to me! Thanks for the fix!
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

