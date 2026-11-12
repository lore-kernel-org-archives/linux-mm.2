Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0713606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=trl+XZ4x
Received: by kanga.kvack.org (Postfix)
	id BEEA16B05B3; Thu, 12 Nov 2026 02:54:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F426B05B4; Thu, 12 Nov 2026 02:54:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB37F6B05B7; Thu, 12 Nov 2026 02:54:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91D386B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:54:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C8761C35EC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:48 +0000 (UTC)
X-FDA: 85425705456.04.2B161D5
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf22.hostedemail.com (Postfix) with ESMTP id 479B2C0009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=trl+XZ4x;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOyscFKrcf3HoEJx6DsofUhA5XV1u8geAqpYw/YcyDI=;
	b=YTEJ0u/0MeBVgvs+OIN9leI13yjFQOHildc62WKyksxnFBgTju3eaQ1ZKjIJcn7oj911M2
	01zW1gK9xUewFwI64Jawq3SCmYR1LoV6t8P61BW1/fgjIWEGFAvhkzstPvOevD4Imm6PDi
	oFE8tuAh4OAQ3Pe2o/56qigStU86IWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470086;
	b=JsnnRVhpf+rxfrpwqg3lDGZeCX319mDd6lD7BS0rhtbDPhklllOW7URAEQbnQY5q5LePSF
	L4TPhOPAn5rBdfZ6w2CTTeBNXaRNbhdWI9FlCTEMPe/c8lCI9gqOSIT9GeZUm3shO0s4Q+
	nm2tVlOUANR3a2bvxiB6wQyDvqWoWNQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=trl+XZ4x;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F1KV9kfLOuuKpASrj84EFbYg1WhgMuoDLqyIrj1tqDg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794470084; v=1; x=1795074884;
 b=trl+XZ4xOQJCHNmSKbDaI/7F9e2Y0ilzx2oFKYKdUfKkHZ1DhCkki/6gxky811EDDsFADVXB
 hXYSwyBOG9GDUOElAW2Fj+BzvDXp78y96zi4zzgg3zYPIsePgNk7I5AyYT5Chq8NbOGNVbCT6wk
 j9tpRuvZM4hjsj5zOK8XPoNQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 30a148ff905e7f1e;
	Thu, 12 Nov 2026 07:54:44 +0000
X-Mizu-Trace-ID: 30a148ff905e7f1e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 12 Nov 2026 15:54:34 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: harry@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm/slab: don't set SLAB_MAY_ACCOUNT for
 KMALLOC_PARTITION_CACHES
Message-ID: <avVnuWCQW56qznll@fedora>
References: <20261111125628.375624-1-hao.li@linux.dev>
 <e2d1dc9f-59ff-4dfb-8ca4-35c584d14b35@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2d1dc9f-59ff-4dfb-8ca4-35c584d14b35@kernel.org>
X-Stat-Signature: byxf46y68zckhhubajr6y6g3439eykz8
X-Rspamd-Queue-Id: 479B2C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794470086-126065
X-HE-Meta: U2FsdGVkX1/nzwUapjshc01341/KD9nVFBA4CHyMJIk4pNo85DStVz9Y7I6OFN/xcJiPue3MTx3oR65S3MXb76BU1kx42qrMnO8dg68qV+ryXWOsdRM4cLk0pkolQM+60Ooado68Q1nrtBMxjL8IlU9CYUymuV+9qh4mQnvNWlRrc/NmsUD0hv4N4Vnq7wIeCHTCEhx/oDgSMzqiShBNK43ryXWdOM04vlXOyMjRjxnpctcuCN6fyVjg8nUpaf1/oagoF74Gft9YGCK5o9/uJzV4/LQNxC6jD9Bn/RLBC1FKbB1DRUJPZoooCv048gwEUtFxkkRPMcfunqTLChARgNhpMlHXNRT/yI420kxMYME1CgUt6WiXapLT8Mc4Rgso0OJ6yN06NKMU+dmpZ2s6rfUnmCGNwSJLQd3f+D54GJn9lzPxb+CPSqAgzHiDAvlUV2KLemRmlgf+d1XD1wS3tL5PNg7Idq704ndczWEzn1jcGcQws9DMuFK3TNye971y4019vV6+4vXdon4hS39HTZqD2HPDcs5ts7NJrSxeJpFMHyxGYibMC50Kq6fuN694Y67GDvyF9ks6CEyXij81G3PbCjYT2/RXQOiosvsHpDKLz8ZkMQHSSPKzyB63ze+JFaj8aTWyoTYRgQxofAN/SWXkglIIxyCbx3QrEu1rlZzTy9IVKXqpqMyi6YA2k6CT289XX6hWczs+JRRct5QYb+bnrY8mdVjgTHMLusbD3UIr683v3lLI89gza3u44BGd07SJT7VjVEOnRUyu/ZzynOOhUVpBn514+4cvn05SF8neeA4NuHDTu6huPQITjf8+S8nzZDKXb/JMeGnJ+mrpdrCYPC1ljHQO8YJYu5w4hBJ6N0FSake+846yC7xxmzkGlrfLNAgdGDMAL9nX3L0L5kW4kLPKk/9+eiy7SH5YbT1MQNVqW5yaoA3uxKeQg5DTQuMCicq5YYKrx0VLoMa
 oBtmZOF3
 TVB1ADekpoug6yseVaKw9yCa1CPWRG2fxTeF1A2EMecNsGoynUvXGMa9N563KoysocHiTTtalY0cxViTk0FAc8voO7IceY7fMeUXlKXdI2NSi2bfMK+RrU8IIjym5vrFvKByw1vntjPWNkvfKY+6BGzUE+PX5xtCBrsakbQRTX1qiPFRaDRCLIFRQUrfLPmdJAjsnkX2yU0L38pNbf0WEwX7/uC6FXcyyLjY7zAEX2NH2l+veyxvhtnMgz7hHpCmKJ1gUEk6WQNddDcdemr4XFLsZtxgPnNyy/ElEmN4hFwwEGubG8PyVHr/o/BAsw9/vf65z2Ys8VvLljv5BbfbBETfyoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 02:08:40PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/11/26 13:49, Hao Li wrote:
> > An allocation with __GFP_ACCOUNT set (without __GFP_DMA or
> > __GFP_RECLAIMABLE) is redirected to KMALLOC_CGROUP and will never hit
> > KMALLOC_NORMAL or KMALLOC_PARTITION_CACHES. Consequently, neither of
> > these caches requires objcg slots in obj_exts.
> > 
> > While KMALLOC_NORMAL already skips setting SLAB_MAY_ACCOUNT,
> > KMALLOC_PARTITION_CACHES still carries it unnecessarily.
> > 
> > Extend the check to skip KMALLOC_PARTITION_CACHES as well, saving
> > unnecessary objcg slots in obj_exts.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> 
> > ---
> > This doesn't seem like a real bug to me, just a small waste of memory, so I
> > didn't add a Fixes tag.
> 
> Hmm I'd add
> Fixes: 7def2e8549e5 ("mm/slab: add cache_ and slab_needs_objcg() helpers")

Ah right, I mixed up Fixes with cc stable. Thanks for pointing it out!

> 
> The question is whether cc stable as well. 7.3 LTS will be used for Android
> and IIRC they have memory allocation profiling enabled. Not sure about
> kmalloc partitions. Cc'ing Suren.

Makes sense. If Android uses partitioned caches, then it looks like we should
cc stable.

> 
> > ---
> >  mm/slab_common.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 2befd24b4d09..f0ea1fa178e7 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1000,16 +1000,18 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
> >  #endif
> >  
> >  	/*
> > -	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and not
> > -	 * aliased with any other type, make sure it's never merged with any other
> > -	 * cache.
> > +	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL or
> > +	 * KMALLOC_PARTITION_CACHES cache and not aliased with any other type,
> > +	 * make sure it's never merged with any other cache.
> >  	 *
> >  	 * In other cases the kmalloc cache may end up being used for a
> >  	 * __GFP_ACCOUNT allocation so mark it as such. The exception is a
> >  	 * KMALLOC_NO_OBJ_EXT cache.
> >  	 */
> >  	if (!mem_cgroup_kmem_disabled()) {
> > -		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> > +		if (type >= KMALLOC_PARTITION_START &&
> > +		    type <= KMALLOC_PARTITION_END &&
> > +		    KMALLOC_RECLAIM != KMALLOC_NORMAL)
> >  			flags |= SLAB_NO_MERGE;
> >  		else if (!(flags & SLAB_NO_OBJ_EXT))
> >  			flags |= SLAB_MAY_ACCOUNT;
> 

