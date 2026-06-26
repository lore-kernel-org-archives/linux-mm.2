Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B53CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB216B0005; Thu, 25 Jun 2026 21:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3256B0088; Thu, 25 Jun 2026 21:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC38D6B008A; Thu, 25 Jun 2026 21:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 841E86B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:54:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA1871C2441
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:10 +0000 (UTC)
X-FDA: 84920393460.14.FBE997E
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf08.hostedemail.com (Postfix) with ESMTP id 335BB160007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438849;
	b=aJA8SitZbC1QAu6gnCZa9wSDsnSVYrNXvZ5nZWXjagIjGs2NQDDv8CS3W/wUuUl7WJCJSn
	C/ymouvDpD8oyGqL7M5ULeOxn9Q6sAmPOVl05F/kH2khXVmh3aGUsxditzL+AGqcBcjIh0
	avpl6ze2HLJiEF+cNkJt5iSxAYMzYhs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/rxUe511QTiZYuuzL9v0nBo9M5EuXuo0Z/EKRWWPFyI=;
	b=1l72i5SATyAIo3L2ZMsdj6evYAuHjfFnyRbWZPB7FKYrDw83u83RdAmdIbLoMnuy8SlLTA
	OJkBNK3YKRZPQdq4zArRfQ73dsRiEoiz7eatUUBMc/HJrCZY7EF3OCLlAZOYgs6ehiWHY5
	MftNUrprYNcx8RWZ/FcIWYAdnpSR7IU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gmdy14cptz58fcB;
	Fri, 26 Jun 2026 09:54:01 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 65Q1rq0H079877;
	Fri, 26 Jun 2026 09:53:53 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 26 Jun 2026 09:53:53 +0800 (CST)
X-Zmail-TransId: 2afb6a3ddbb165c-a276d
X-Mailer: Zmail v1.0
Message-ID: <202606260953538236I--tWPSDQ3bIndNt9XTX@zte.com.cn>
In-Reply-To: <e82b9b33-af72-4665-bc9b-c2e2cf55c338@kernel.org>
References: 20260624172234202jw3y4yP1YfgOYbPCQdVIw@zte.com.cn,e82b9b33-af72-4665-bc9b-c2e2cf55c338@kernel.org
Date: Fri, 26 Jun 2026 09:53:53 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <hao.li@linux.dev>, <cl@gentwo.org>,
        <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBmb3ItbmV4dCB2MyA3LzldIG1tL3NsYWI6IGludHJvZHVjZSBrZnJlZV9yY3Vfbm9sb2NrKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65Q1rq0H079877
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 26 Jun 2026 09:54:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A3DDBB9.000/4gmdy14cptz58fcB
X-Stat-Signature: xcynn37ooxikhwwnguwckkaq1uzu1ud7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 335BB160007
X-HE-Tag: 1782438848-567262
X-HE-Meta: U2FsdGVkX18ZT/mj9gOdQ3apnf3JW1AVfURGTuV1VpWXVXVBWKLi5HeA9mkHmTKOPXSmyiKue/DS7rNYuIzxUdifKEsLmGd7vcyONqBWbpu/to6y35O98OOr27+fHAvraX9HOMINtOmKarz/6Hzvc3xxcdRNFZayHZ7IWh/AHJZvLpCnKkg6/LcmmCe9kGfEeLtL8YFi0RrM5z7jDWNuDCKDSPHm7FOF6nTyXPZnGwPWIA2uuVclb2KGqgy0KqPgS0zjQ0AJJLFOPag8TrLz6tOb4pRwFIB78kGZc/eiZlKVPXz59vcWmYvcnEpvAiP13R+Kc8hTv0VnJjW3y0H56Ql5nb6Avo5iN1k2g7MHpYuvE91IuzPCq6oeK849R6ZNCI6D2A1DJxWbtNrP+TUvT9GxY74SxV56mhjvdp2wQQsIzc+z9om+Lr0TbfNpyBym9b6GVGB3rTYDae8GlSopRT+Anm+8Iiuj/h3lBUw14GZvLLw6JJ69N7cVgdEAsaxiwTlTO9kjXQl29nQoTZuceq/LMFfEGKUir5iuaeG530l2EaarJ2QYt4o842sS3nUkebUbdWXZI/Bhg/bf/zl7nakegoOjTtD3RlYC6x29ra6LZo0Bce7A+l77CJAy41Q/iAoV9pjXv58PQuGJU4bp6jF3dune5vkn7N3wX/ZMTZXFEJVYyAnm40p92Yg6nOf+/CXB3+bs2psO8Xoa5QfWvV5wVMskxLEvz0r6OFHysB0v5CXqBFv/hHhHSJ4mcpVYLluDC8Qez/Gz3DcrqeKoMdzPPyuBz/HJbtlgnT0RRIzC1TV+2p2U/pRZZVIWkTOm1J0BYaynT3FcE22n4xejzXzKz2TsPJzBK4qOIPD6n1+K6Wc/DPsSoB7fzNN7IkSchX4O5iJccbgcJh+Ix0YoMCI8wxWvdh+xe+hLAras6qIOwYwQW9EoOF64VUjICWporNZVPWyLX7gSFbBxKJA
 d2UTzf7n
 aachXdVlX1ZD2+eQsmLGrfGNfY5PLY77Be1uJuy+7UUQ3UxdC+SI/hKioXFH6pA3FZLuC9tabiWTkkgZKE4kYdRqTDeyxer5XnfzY5l1wmldzkZl5pxCa47rALmoRPmc1ci6RnLM0XBsZbj9lZuN8xD/ZysOQW/Qqc9RgC0w8VHtxYALoWepU71RnL0Iu52HBM40+2YxI5lWi95pUgkVDEyufdfOLAZWzyQeScrWNGVhKtVNredszy/SuqHBu4MD3V62CQxuCe/pF2jcPng3FDPZI/l59MErGrKux
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 6/24/26 6:22 PM, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> >> Currently, k[v]free_rcu() cannot be called in unknown context since
> >> it could lead to a deadlock when called in the middle of k[v]free_rcu().
> >>
> >> Make users' lives easier by introducing kfree_rcu_nolock() variant,
> >> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
> >> __kfree_rcu_sheaf() handles unknown context.
> >>
> >> Unlike k[v]free_rcu(), kfree_rcu_nolock() does not fall back to
> >> the kvfree_rcu batching when the sheaves path fails, and falls back to
> >> defer_kfree_rcu() instead. In most cases, the sheaves path is expected
> >> to succeed and it's unnecessary to add complexity to the existing
> >> kvfree_rcu batching.
> >>
> >> Since defer_kfree_rcu() can be called on caches without sheaves, move
> >> deferred_work_barrier() and rcu_barrier() outside the branch in
> >> kvfree_rcu_barrier_on_cache().
> >>
> >> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> > 
> > Hi Harry,
> > 
> > Thanks for the series. These patches fill a clear functional gap in the
> > existing free APIs by adding an RCU-deferred free interface for contexts
> > where kfree_rcu() cannot safely be used.
> 
> Thanks for looking into this, Shengming.

Happy to review. :)

> >> ---
> >>  include/linux/rcupdate.h | 12 ++++++++++++
> >>  mm/slab.h                |  1 +
> >>  mm/slab_common.c         | 22 ++++++++++++++++++++--
> >>  mm/slub.c                | 23 ++++++++++++++++++++++-
> >>  4 files changed, 55 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >> index 807924a94fb0..5a39e6225160 100644
> >> --- a/mm/slab_common.c
> >> +++ b/mm/slab_common.c
> >> @@ -1263,6 +1263,23 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
> >>  EXPORT_TRACEPOINT_SYMBOL(kfree);
> >>  EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
> >>  
> >> +void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
> >> +{
> >> +    struct slab *slab;
> >> +    struct kmem_cache *s;
> >> +
> >> +    VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
> >> +
> >> +    slab = virt_to_slab(ptr);
> >> +    s = slab->slab_cache;
> >> +
> >> +    if (__kfree_rcu_sheaf(s, ptr, /* allow_spin = */ false))
> >> +        return;
> >> +
> > 
> > One consistency issue to address here: kfree_rcu_sheaf() only calls
> > __kfree_rcu_sheaf() for objects belonging to the local NUMA node. This
> > avoids filling a CPU's per-CPU sheaves with objects from remote slabs.
> > 
> > kfree_call_rcu_nolock() currently skips that check and may therefore
> > place remote-node objects into the local CPU's RCU sheaf.
> 
> That was intentional, but actually, this is a good point. Thanks.
> 
> > Could you add the same local-node check used by kfree_rcu_sheaf()
> > before calling __kfree_rcu_sheaf(), and route remote-node objects
> > directly to the defer_kfree_rcu() fallback path instead?
> 
> Falling back to defer_kfree_rcu() in v3 didn't make much sense
> as the object is inserted to a global list which would cause more
> troubles than NUMA miss.
> 

Thanks for the clarification.

That makes sense. With the current fallback implementation, routing
remote-node objects directly to defer_kfree_rcu() would put them on the
global deferred list, which could be worse than keeping them in the local
CPU's sheaf despite the NUMA miss.

> But once we make the fallback path percpu, your suggestion would make
> more sense.
> 

Fair point. That said, converting the fallback path to per-CPU seems to
diverge from what was implemented in patch 8 of the v3 series.

--
With Best Regards,
Shengming

