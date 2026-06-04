Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53CB3CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9918A6B0088; Thu,  4 Jun 2026 06:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942BF6B008A; Thu,  4 Jun 2026 06:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858606B008C; Thu,  4 Jun 2026 06:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74F816B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:37:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 042B61406BF
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:37:53 +0000 (UTC)
X-FDA: 84841879668.21.2E7118F
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95C3FC0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:37:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780569472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ptpfFyV8bo7e02DTHzaT9ELHBmjD31YV7wFptnl/wM=;
	b=V6a8HE+u9hKYJVBPm34RsNdKblfyaeLaoXUM0/1NcunVYlFQPME8hFFaWGza/UPtmHuahR
	qVI+++i/hSmtf65LWUSYfGTYPmwA9FKDqjSyy8ieJ6Hpr99hoSdmUfxvt2xdPwqIi1UJoo
	dCNcM2x9nbZKQPXHNYntqRLN0fw/fKs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780569472;
	b=mBVXrMntDFQx5Ch0w6/xxtNg9ordF8qkqIxLJZ/MNgMOYwkNJU4pduzzWH70ROn5Lujgc4
	xYPqDQeCUF3fmfbA7iph4xjPc5ScZ/UWA7NoZvXMBrlao2v5MPKPC3RTzOt4yt7q0h4jjx
	TDcWE2zntdo47bvv1utbY1Rd2t7QkZo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gWLcQ1fYxz52SGX;
	Thu, 04 Jun 2026 18:37:42 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 654Abeih063231;
	Thu, 4 Jun 2026 18:37:40 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 4 Jun 2026 18:37:43 +0800 (CST)
X-Zmail-TransId: 2afc6a215577c4d-2e562
X-Mailer: Zmail v1.0
Message-ID: <202606041837430694Sp1c5i67IfsI_-jaAX9v@zte.com.cn>
In-Reply-To: <a6cac07f-5509-4821-b0a8-dd3afb89c26e@kernel.org>
References: 20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn,07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org,a6cac07f-5509-4821-b0a8-dd3afb89c26e@kernel.org
Date: Thu, 4 Jun 2026 18:37:43 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogcHJlc2VydmUgb3JpZ2luYWwgc2l6ZSBpbiBfa21hbGxvY19ub2xvY2tfbm9wcm9mIHJldHJ5IHBhdGg=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 654Abeih063231
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 04 Jun 2026 18:37:42 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A215576.000/4gWLcQ1fYxz52SGX
X-Rspamd-Queue-Id: 95C3FC0006
X-Rspam-User: 
X-Stat-Signature: f4p5kpa7ah1zc7rb6fayqnm7sssrxmno
X-Rspamd-Server: rspam08
X-HE-Tag: 1780569470-262660
X-HE-Meta: U2FsdGVkX1/NwXvslE0634R8c/iuin46N0GdHpbDpcPYomQoPyk47h4iSKHoI11oNoFSjaqZJhh34/vl11vTJdTIPW+cGZe/OxRQCP+9/tW29INRzwdI3VgCypq6jWKFPsutzPX4SHqUidsvk25JSBAPv5/RhjbSZHOADG7lF5AxTkLEIP/HrwyVLoq4oXWD8C6kIgqMUT9p/EeGl7MoP28QZhz59VqnFlLJugSdeH0pReqVeQiuaSJpZFK+paeaeEMHyut/d9a/H04sKXTeuAo5sRW1C8qgCjTV4c5ZB5puiDbuph4CC+H4+3wNNqD3lWc62bpkfu4Hv+i1avChRWBbX0YHT+u6ZjYEudJYVeTdkGzO+tYU2tKqJvaMU8/tJqovQE9a50KFtKrkP8nA+Un3L2UlJfZV6O9V13+ec5yw7OcU6xPxjzOuRGfaH4y0j4M3BFyGdFUOdDmLWvjcuLfBGufGoWRmVTm+EcUQGc0uvoxpd63Lwv/6/LnDkqf+baY9nwcpu0d8BujtzuHijByrXoTUfhiAAvHGzDIZiFWp+1j8YYiJ5NqNRVsyCNnyJQFrmWjjFCZQNVZJ/8/yZJNvyfUF8icvR7/r57w5Gi6XcNOpZJGUwO/EnssjVtRvDTUJsS/dRMRrZxasnInemDiIRItK7Sz/8mOUAq6LtoK3omEoPDX3u8Fc1pKyrQQLZ06v66SBvqqKFLkpRzKgt2UqQ6gLnU0w1eIcCQT7QRecdjd1j3HMubo9QbuHhlPZtsc1EwyFuNfuJR2kLJ2hyymS8Sm53DN0UQr74b2EZmjj4y8yKS3DujTT7OpnWBQBRoZPM+FJrrulsHEmTPjbZN5gaVgND/5/zJsX786LXZpn9PwQSjx5wjj4AEgoYDXPMtNrhniQIxA+r0bf4HVarw7KUK7EoEypyGpEFSZ/j4t/57E91y6n08nhwEi4JtHtQuuFYYva/TmowPnAXJR
 HNgQ2V7N
 2rBPLxvhDSzTenlUV+jvhP5QZSEup4ZU899qbFIQBk3mGXtM58wLvZzct3u+krB6xeeBz710FStWlZ3jI5S4+R0fIfHmzPjC+TQF1O7IL4jFyvtr69lngwRLXOU/FBz2EdztvwWaQl1PjqLOKJ6WWFWUtvi2SK6yL921n/8ROzWT4bVzsqoziUAzt9plS6VddcK2xVc5wGxjYiCZZhtEkcYrjED8wY2aLvOYoyleV7nXGbFXrp1SOCFFGF1TpUR3yk1rOGUwxipgYaRldU9D4jVCvmtXnOvODdDam
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VlastimilBabka(SUSE)<vbabka@kernel.org> wrote:
> On 6/4/26 07:46, Harry Yoo wrote:
> > 
> > 
> > On 6/3/26 10:10 PM, hu.shengming@zte.com.cn wrote:
> >> From: Shengming Hu <hu.shengming@zte.com.cn>
> >> 
> >> _kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
> >> initial allocation fails. The retry currently reuses `size` as the
> >> bucket selector and overwrites it with s->object_size + 1.
> >> 
> >> That value is later passed as the original allocation size to
> >> __slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
> >> successful retry this makes KASAN/slub-debug observe the retry bucket
> >> selector rather than the caller requested size, potentially widening the
> >> valid kmalloc range and hiding overflows.
> > 
> > Good catch!
> > 
> >> Keep a separate `bucket_size` for choosing the retry cache and preserve
> >> `size`.
> >> 
> >> Fixes: <af92793e52c3> ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
> >> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> >> ---
> > 
> > I want to note that this conflicts with Vlastimil's work-in-progress
> > feature [1] where it separately stores orig_size in struct
> > slab_alloc_context which naturally solves the problem.
> 
> Thanks, didn't realize it was solving this problem as a side-effect, hehe.
> 
> > [1]
> > https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags
> > 
> > No strong opinion on whether to queue this patch and then rebase
> > Vlastimil's work on top, or wait for Vlastimil's work to solve the
> > problem instead...
> 
> It's better to queue fixes separately first, in case someone wants to
> backport them, even though stable shouldn't be really necessary here.
> This fix could still go to 7.2 but my series only to 7.3.
> 

Hi Vlastimil,

I'll send a v2, it should be easy to rebase your
slab_alloc_context work on top.

> >>  mm/slub.c | 7 ++++---
> >>  1 file changed, 4 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 67abbbf68fc1..6a2b3ade3611 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
> >>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
> >>  {
> >>      gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
> >> +    size_t bucket_size = size;
> >>      struct kmem_cache *s;
> >>      bool can_retry = true;
> >>      void *ret;
> > 
> > But in either way, I think it's more straightforward to introduce
> > orig_size as a variable to keep the original size and pass it to
> > __slab_alloc_node().
> 
> Agree. Because above, we wouldn't initialize bucket_size to a real bucket
> size, but a <=bucket size so it's misleading.
> 

Agreed, it makes sense.

> >> @@ -5372,9 +5373,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
> >>          return NULL;
> >> 
> >>  retry:
> >> -    if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> >> +    if (unlikely(bucket_size > KMALLOC_MAX_CACHE_SIZE))
> >>          return NULL;
> >> -    s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
> >> +    s = kmalloc_slab(bucket_size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
> >> 
> >>      if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
> >>          /*
> >> @@ -5408,7 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
> >>       */
> >>      if (!ret && can_retry) {
> >>          /* pick the next kmalloc bucket */
> >> -        size = s->object_size + 1;
> >> +        bucket_size = s->object_size + 1;
> >>          /*
> >>           * Another alternative is to
> >>           * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
> >

