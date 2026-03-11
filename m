Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCE31049527
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1DA6B0005; Wed, 11 Mar 2026 06:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375A76B0089; Wed, 11 Mar 2026 06:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223C36B008A; Wed, 11 Mar 2026 06:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1BCC6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:16:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80AD98C374
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:16:12 +0000 (UTC)
X-FDA: 84533376984.12.7CA13D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 53BDB40010
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:16:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LFNGv0wF;
	spf=pass (imf27.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScqAB1pPNilAlzHe4XpHePGh9uVJkCnzlqRgNeOGVw8=;
	b=ztoZ3SoQVw6+mtcB0+H2tm3iUm06rWOdS0qCdLPL0BLHF3Ea3JOv26d1ByLNON0DaDqJSa
	lVzyvtgNl+QxQrybMgggyOMmkmbvW5tmd8Zpp1xzMWafxQrQovmV/LMRu00h/BF+F2C5fD
	IRDSu42zr0+zQZBSTkGh69BOlSpv32w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224170; a=rsa-sha256;
	cv=none;
	b=Gr4n65v2QegL0hLExyWozcfxxHhLxxcPupj+Ux31s+Ik+2cPfCtKj+ClCuDVlrz+cA2g+h
	uo0wmkeLRhR/Xb/ZsCS1WvtJjs8NISchqNtQA4nWic/ojrDWHouOsT0QrfMs2NpPbmrvKe
	KJxe9s2ed3mdBgv7E6jd7sutHaEsGfE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LFNGv0wF;
	spf=pass (imf27.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773224169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ScqAB1pPNilAlzHe4XpHePGh9uVJkCnzlqRgNeOGVw8=;
	b=LFNGv0wF7rR3zI8M7011oIXXxcsoPRMc8wXqjEWqK7GPI9n+LAGp48g79xmTlEYp6GkDul
	Fl5hPlnfWp3ufG6808SFSojBj/iJwjvkM+pxyWC2oWfIBj7wnaBhkF8sGH3jTnojDU0gZX
	cfdnrcYlQ1mwcZoBwswc8MODEiuVX0M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-nIKYXTN6MSiF-HWLli9IXg-1; Wed,
 11 Mar 2026 06:16:05 -0400
X-MC-Unique: nIKYXTN6MSiF-HWLli9IXg-1
X-Mimecast-MFC-AGG-ID: nIKYXTN6MSiF-HWLli9IXg_1773224163
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 728AB1955F39;
	Wed, 11 Mar 2026 10:16:03 +0000 (UTC)
Received: from fedora (unknown [10.72.116.147])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 056531800576;
	Wed, 11 Mar 2026 10:15:56 +0000 (UTC)
Date: Wed, 11 Mar 2026 18:15:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <abFA17ZmsW6RgcYI@fedora>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
 <aZ7BbosIr2FvZFAe@fedora>
 <c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org>
 <aapeVb_L5zohWRRe@hyeyoo>
 <d5cd4eb4-1703-41af-9c71-842ae33edbdf@kernel.org>
 <aaqq7YmUcOht3GWH@fedora>
 <abDA9UrJBT1wXh22@hyeyoo>
MIME-Version: 1.0
In-Reply-To: <abDA9UrJBT1wXh22@hyeyoo>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 7VQkcfy17Us8EkNYgqPv0OYQx7fKB3tkORc57SFX8gY_1773224163
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: ynbrjzo4kuxhmzgn58kdtwkjdk6mij1f
X-Rspamd-Queue-Id: 53BDB40010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773224170-815508
X-HE-Meta: U2FsdGVkX19KmQQsDx8vt+SlbxRJUR9m8JzAtaK0HXYUUwdKt5OJrWYu27NjRPuRNuUTE4bNSF9c5LI8OQXWyCpSHko0LMXFUE2njfkXEyYjzqwibhjrXsLPP4DUg4e+Yg24skhsiMN3Bd5X6w2YkIFZSqmt5KaAb31O7uZiEJiZO7QhIb5RRhagfhx/JwmJcBwlg7aG8jXTQB/3UC63Y7vAIICeFsHocpYXoLKQH9DFk9dURXWreFMSQWpKMNA65lQKmd6Oqaujwag39EJLSkIteEYtwBzUFPtoQEh/ksBMMu17fLJoau/UyshaxU6RohesVwuYhuiqzjGUvzGoqfPrFV3Q6GC/aEeSSwVH9U3hVbnSwwEoN03hzbdVrF0H0lLq/a85ozj3bpna4fPxhKyibzV0arYEgsvxQyqB2CutHG+8vWsDj1tO/Bm9bat8Yuiuv6Sq8sZlPJJTse5AspOwAHibH+2bv63ec1eEN12L5fz4gLUCfNO4n8jQ81FOVtsYXgK/0xq9TrjlBY6G0PTJc7lvvOHi6mNN0cM/6z/o1XZ+t/QgPxjTtZ8dRP2g8iuiEEWBm1MygpjSZxZURmYJWNRiapeAfnFTXWp+LuZ2SkXDMtsu/hBrMdIuLcUHF+TMz/pJ1wXngqn/RzvKZsDWLVhwSn49qCQroTlHU1jMgJPmiKva/CWM8pVXQ+HOJiFR4d3Lq1GLRz35Ht56YBEo8SAhDgxC5fRQg5eWQfH8tj2JOZc5pJiKdKgrcvRT3ehSAYjKZsxGE3CJbCBf+wjQenlFf9V02cvOXDP+ItsX9Y/BRNNIjmmbbVPyvxpIlzMbNA6Lr+R9l3r4nSL+YxURV87At7aJc4j0KrYymBtOW/OdQQyvJaMRJdvefNVsVAF1ttApuy7mmmH1EA3/scHe7gLQcwO0ebs7AJKX5WRvW9kqXOa+4O+YTmpjpI9vDjW1O+0JiBSUoX+78kg
 CsRUje+8
 dhwNg+lXllBimI7Y2FOt77ZxmO52KeWtyJFzSoUX/JfhxNgiYWFw9GTCdIjF/zytVZgO+9sIuc6pyE0elw6NfOg4wkJ88HcYNqEZIjHNC/IKZ/ufnG6RC5ZgWe06q5+OuS3hwea2ZyLxK10IBF8mXfLVXqbhCSfucLf/eif34xlbcgvLOdKjP53BPztgRnMTqaTWZlf1k2dGD1FYUWe+ATd94CHn9gJkt4qavUrOD+dWV3s+rB4J5igYoRNk9AfUgH7Ltie0v5ju1ATrz2Ca0SHFEQHKGpaCpmJySygZG+POqJtJN9kK7N8a80yB8a3LNJ7nExpEhjulscc8KHR4nEZ+a9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 10:10:13AM +0900, Harry Yoo wrote:
> On Fri, Mar 06, 2026 at 06:22:37PM +0800, Ming Lei wrote:
> > On Fri, Mar 06, 2026 at 09:47:27AM +0100, Vlastimil Babka (SUSE) wrote:
> > > On 3/6/26 05:55, Harry Yoo wrote:
> > > > On Thu, Feb 26, 2026 at 07:02:11PM +0100, Vlastimil Babka (SUSE) wrote:
> > > >> On 2/25/26 10:31, Ming Lei wrote:
> > > >> > Hi Vlastimil,
> > > >> > 
> > > >> > On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
> > > >> >> On 2/24/26 21:27, Vlastimil Babka wrote:
> > > >> >> > 
> > > >> >> > It made sense to me not to refill sheaves when we can't reclaim, but I
> > > >> >> > didn't anticipate this interaction with mempools. We could change them
> > > >> >> > but there might be others using a similar pattern. Maybe it would be for
> > > >> >> > the best to just drop that heuristic from __pcs_replace_empty_main()
> > > >> >> > (but carefully as some deadlock avoidance depends on it, we might need
> > > >> >> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> > > >> >> > tomorrow to test this theory, unless someone beats me to it (feel free to).
> > > >> >> Could you try this then, please? Thanks!
> > > >> > 
> > > >> > Thanks for working on this issue!
> > > >> > 
> > > >> > Unfortunately the patch doesn't make a difference on IOPS in the perf test,
> > > >> > follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):
> > > >> 
> > > >> what about this patch in addition to the previous one? Thanks.
> > > >> 
> > > >> ----8<----
> > > >> From d3e8118c078996d1372a9f89285179d93971fdb2 Mon Sep 17 00:00:00 2001
> > > >> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> > > >> Date: Thu, 26 Feb 2026 18:59:56 +0100
> > > >> Subject: [PATCH] mm/slab: put barn on every online node
> > > >> 
> > > >> Including memoryless nodes.
> > > >> 
> > > >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > > >> ---
> > > > 
> > > > Just taking a quick grasp...
> > > > 
> > > >> @@ -6121,7 +6122,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
> > > >>  	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
> > > >>  		return;
> > > >>  
> > > >> -	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
> > > >> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) == numa_mem_id())
> > > >> +			|| !node_isset(slab_nid(slab), slab_nodes))
> > > > 
> > > > I think you intended !node_isset(numa_mem_id(), slab_nodes)?
> > > > 
> > > > "Skip freeing to pcs if it's remote free, but memoryless nodes is
> > > >  an exception".
> > > 
> > > Indeed, thanks! Ming, could you retry with that fixed up please?
> > 
> > After applying the following change, IOPS is ~25M:
> > 
> > - delta change on the two patches
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 085fe49eec68..56fe8bd956c0 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6142,7 +6142,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
> >                 return;
> >  
> >         if (likely(!IS_ENABLED(CONFIG_NUMA) || (slab_nid(slab) == numa_mem_id())
> > -                       || !node_isset(slab_nid(slab), slab_nodes))
> > +                       || !node_isset(numa_mem_id(), slab_nodes))
> >             && likely(!slab_test_pfmemalloc(slab))) {
> >                 if (likely(free_to_pcs(s, object, true)))
> >                         return;
> >
> 
> Hi Ming, thanks a lot for helping testing!
> 
> The stats look quite fine to me, but we're still seeing suboptimal IOPS.
> 
> > - slab stat on patched `815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next`
> 
> Does that doesn't include Vlastimil's (fb1091febd66 mm/slab: allow sheaf
> refill if blocking is not allowed)?

No, because fb1091febd66 isn't included into `815c8e35511d Merge branch
'slab/for-7.0/sheaves'.

> 
> Next time when testing it, could you please test on top of 7.0-rc3 w/
> the memoryless node patch (w/ the delta above) applied?

IOPS is same between `815c8e35511d Merge branch 'slab/for-7.0/sheaves' into slab/for-next`
and 7.0-rc3 with the two patches.

IMO, it should be more easier to compare & investigate by focusing on
815c8e35511d, given there is only 41 patches between v6.19-rc5 and
commit 815c8e35511d.

> 
> Also, let us check a few things...
> 
> 1) Does bumping up sheaf capacity change the slab stats & IOPS?
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 0c906fefc31b..5207279417e2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7611,13 +7611,13 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
>  	 * should result in similar lock contention (barn or list_lock)
>  	 */
>  	if (s->size >= PAGE_SIZE)
> -		capacity = 4;
> +		capacity = 6;
>  	else if (s->size >= 1024)
> -		capacity = 12;
> +		capacity = 24;
>  	else if (s->size >= 256)
> -		capacity = 26;
> +		capacity = 52;
>  	else
> -		capacity = 60;
> +		capacity = 120;
>  
>  	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
>  	size = struct_size_t(struct slab_sheaf, objects, capacity);

IOPS can be increased from 24M to 29M with this patch, against 7.0-rc3 with
Vlastimil's today patchset.

> 
> 2) Is there any change in NUMA locality between v6.19 vs. v7.0-rc3 (patched)?
>    (e.g., measured via
>     perf stat -e node-loads,node-load-misses,node-stores,node-store-misses)

root@tomsrv:~/temp/mm/7.0-rc3/patched# perf stat -a -e node-loads,node-load-misses,node-stores,node-store-misses
Error:
No supported events found.
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (node-loads).
"dmesg | grep -i perf" may provide additional information.

Looks the events are not supported on AMD Zen4 machine.

> 
> 3) It's quite strange that blk_mq_sched_bio_merge() completely
>    disappeared in v7.0-rc2 profile [1] . Is there any change
>    in read/write io merge rate? (/proc/diskstats) between v6.19 and
>    v7.0-rc3?

It isn't strange.

Because IOPS drops to 13M on v7.0-rc2 from 34M on v6.19-rc5, so blk_mq_sched_bio_merge
can't be shown obviously, which code path is run for each bio(IO).

It is one totally random READ IO, and IO merge shouldn't happen.

Thanks, 
Ming


