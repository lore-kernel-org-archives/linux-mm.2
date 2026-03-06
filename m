Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF005F0180A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105096B0005; Fri,  6 Mar 2026 03:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3456B0089; Fri,  6 Mar 2026 03:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6296B008A; Fri,  6 Mar 2026 03:32:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBFEA6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:32:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 551398B549
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:32:30 +0000 (UTC)
X-FDA: 84514971660.20.0DC98FD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id D1DDD2000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:32:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="f+c+/YVH";
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772785948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUuJEsEmzdv4bF/ObRt5BSjkLwqw8Tv550TKHPFoo1M=;
	b=C17RoiEwl4Z98cKARpDDgW61kJ2r6o2lKMyADDKSiYivF//GgH3GZM7LPhFidesl5jLp2e
	mCIfoFqyhzuB4pgNCi1+xobZnvmhwp70/oAuVA2q05VtIQKUjdDUA1Nv7hk+piMoisO+g3
	jaHkohSsa0dfH4stSKNYCKzZ+E7WKHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772785948; a=rsa-sha256;
	cv=none;
	b=fH3l9LdIPQbbWCKXVZeAw1XKV9AnASvQkh5aLKUOEx6NYspdITxZbUElLc/KZxzmvcnylA
	XIQv5xVQqz+ZRSAcCq6DviJi/+SBlX3OnZGY5uT2wSh1UDxa7xD4uBGCjQe+lyhXfunfyf
	ZFx54nUN8CH9gnR6VyLH4SjTAgaUD5Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="f+c+/YVH";
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 6 Mar 2026 16:32:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772785944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XUuJEsEmzdv4bF/ObRt5BSjkLwqw8Tv550TKHPFoo1M=;
	b=f+c+/YVHtaPhVlZINm1g+UlreDEE/PO8KOCbsTGYrcHY7eQ7LUNOhanjzzPaNAdRKsQgc3
	GciY4mex1L/z1D6HaGlO1om7aV5V5cXqxKcs+nln+15SQM9T7wJ72W4+95lshCso1bdBHC
	TmAg5o7YkP0aQiFIgbTiUVka0iyiSpo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <mhyjdgxppdu6bfnt2ksyltj5hqcn53ztbh4bmnwctt6phxzucb@x4qcnhjs2c2x>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
 <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org>
 <aapeVb_L5zohWRRe@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aapeVb_L5zohWRRe@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1DDD2000F
X-Stat-Signature: 1gm5ugcqa4ctre5s5qryq8aguxfmf6a6
X-Rspam-User: 
X-HE-Tag: 1772785946-635489
X-HE-Meta: U2FsdGVkX188naZoBSFLqFEBn/Gm9UJsLBjM4KebBU/FYXqfeYmVuQ+6KvfA/ubQSfOxduxFWADke98AHdBkJS7NzHrgREKY+caVeq9hVJfJPw7QYREHRRpJW99nxyVO385okja9MOSpzfyWN46fyGURpN4uQhNfQJ+ZO4iAoy73hON26MMq+s94TBbNg8BIXGBt7aIv4uigVuWuHeldL8zPYj940nJV8nHM8N31kY5HphuVlv64kkM5uAfIs9B829tlsCBLic3WZLO4hZYuar7rHvWxbsb2jy1VmUZgjZjHsmjC1mwErdsyZP+YuCtWwU2CqJnVAyTY096OuH2KO/sUtBdiqBq9SeXfRuCrl8yMui5ktoBqsrU/MgvR7bYjCX3xTKna86Hic61aXBvaX/5qF3O7tRfFXfCFlIjhT8+jV7SkaB3GRmiAqDGD7vDrovdpBOSBvjztvXEzJQU+ImhsIzivyuY14xeCuUerT9zXgP4rzeATE257lKEt5VSuhAifXdqgvhF6t+sIRBQsPp9PQr25diIRDpI4b2GV1IRmkVpIMPVXm24w9O6LqSV5m7MpYXNLhnWuB1UJmInH+JpNh8ch2CqikB1o9VO5LsAikc/r1M/ranprIUC/VJwBtwWOP2lPgeopIdm5fHzQG5399wbzeCxPCQsAR52quEU8WsHqazJLfJ1smBfSP54B3i8okmgsAs6gS3BYctmqSO9MY8ciBked4kWa7SW0YaIERpzMRcSOZJJKKUAWhZPyFrczrWYjV303vQUG0BVS2CA/0EMWYWz+Gg54hKRbs17PgBb9rBDUwMYj8lE7mLtebNMWkTL6RpnxaEqkHUYPnpDp5AJJ4wxHUXa3uxjzD7EMsYOiGvH1dZXXJZy5MI8CB6n/D1h40+DZ6BNTagbwUTPiK7DQPb7outEV2n+lnsFNEdpjr7c4GpGTKCp8DZXCbjcRfmeDlGhs1j8kSGu
 t4KCbWo8
 hR4qnbSMmSQEJ1hmocII22RmYxHS4FffX37kNzPoeOOLRSYfP/+kdICGwDw8lRmLfG8OwsaYSgVSyaV53l5tI31cN/cMaeI76gR7BnzJB6vcZxTdKgN1WzvUYIc5Xlx7A4v4ITZE3h35RXJ2oHY2DMuU5ZD/Po1URFwWle2C9sDjTtdiauC7Uo/q2w+zX3Q+3bzi4bdN9mjVWnnxfmvV6txH5tcMqEj6sCZj7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 01:55:49PM +0900, Harry Yoo wrote:
> On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) wrote:
> > On 2/25/26 10:31, Ming Lei wrote:
> > > Hi Vlastimil,
> > > 
> > > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
> > >> On 2/24/26 21:27, Vlastimil Babka wrote:
> > >> > 
> > >> > It made sense to me not to refill sheaves when we can't reclaim, but I
> > >> > didn't anticipate this interaction with mempools. We could change them
> > >> > but there might be others using a similar pattern. Maybe it would be for
> > >> > the best to just drop that heuristic from __pcs_replace_empty_main()
> > >> > (but carefully as some deadlock avoidance depends on it, we might need
> > >> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> > >> > tomorrow to test this theory, unless someone beats me to it (feel free to).
> > >> Could you try this then, please? Thanks!
> > > 
> > > Thanks for working on this issue!
> > > 
> > > Unfortunately the patch doesn't make a difference on IOPS in the perf test,
> > > follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):
> > 
> > what about this patch in addition to the previous one? Thanks.
> > 
> > ----8<----
> > From d3e8118c078996d1372a9f89285179d93971fdb2 Mon Sep 17 00:00:00 2001
> > From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> > Date: Thu, 26 Feb 2026 18:59:56 +0100
> > Subject: [PATCH] mm/slab: put barn on every online node
> > 
> > Including memoryless nodes.
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
> 
> Just taking a quick grasp...
> 
> > @@ -6121,7 +6122,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
> >  	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> >  		return;
> >  
> > -	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
> > +	if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) == numa_mem_id())
> > +			|| !node_isset(slab_nid(slab), slab_nodes))
> 
> I think you intended !node_isset(numa_mem_id(), slab_nodes)?

This is a good catch! and it could explain why CPUs on memoryless nodes can have
higher barn_get_fail. They have too less sheaves in barn...

> 
> "Skip freeing to pcs if it's remote free, but memoryless nodes is
>  an exception".
> 
> >  	    && likely(!slab_test_pfmemalloc(slab))) {
> >  		if (likely(free_to_pcs(s, object, true)))
> >  			return;
> 
> -- 
> Cheers,
> Harry / Hyeonggon

