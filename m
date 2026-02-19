Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9880BE9A053
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0924E6B0089; Thu, 19 Feb 2026 12:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05CBD6B0093; Thu, 19 Feb 2026 12:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAB96B0095; Thu, 19 Feb 2026 12:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D60EA6B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:10:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F079BA5E8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:10:49 +0000 (UTC)
X-FDA: 84461845818.22.7CB0FB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8B41320015
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:10:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YD3SyL0D;
	spf=pass (imf13.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771521046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ufSHZcVh+Dpk6NOIfY9tkcU2Fx29sq1FQcHOa9iMf4=;
	b=JhJHozmhsnQo7/0Q3/oaGT8Q2MsbdpGr8oOdoxnevE4Zk0iLRk5ydrEF+pzuzB+si7vO7q
	6bC0DE/hWbrmIhHHnS41k3CZklbbE6JFJMC5Qxmv+eyZqcYpJsLNzYxYXM/p8Ez4o2bw4N
	54kFMmTzBTtfO1FfGncbTTS0pNWnvjU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YD3SyL0D;
	spf=pass (imf13.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771521046; a=rsa-sha256;
	cv=none;
	b=sk8wBZukfWF8ZCRTJIjoyByEhQCPCf40RC0omw9DynGRXuuQTsyw9mNqFCpL9tck0uRM6Z
	Giyf2aVDFg9y41eGXn6my6jZJ2s9Rhynu9yY1+48zRDV0o+JP5TDldipjOXSp/Knc3Db0p
	FXGHnMwrZbQfLLYX7V4bhr8JNGcPMoY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771521045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ufSHZcVh+Dpk6NOIfY9tkcU2Fx29sq1FQcHOa9iMf4=;
	b=YD3SyL0DtxRA91L5WAKXCYQ49f11bVorKkKPHTjx76X12k2V8XY093Hmdx/kmeAwV2kQIB
	c/Jfb1c0SKNR5acXyF7CZzISngRFYbe3wTfO3a6i8FAYN2X7mJaAMT9CCqjvcbIjPjedn2
	91+ainb9FsRHvogQ74qW1FkNQuY+aoU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-dJyYmdKyPcSLEzc13uDXNg-1; Thu, 19 Feb 2026 12:10:43 -0500
X-MC-Unique: dJyYmdKyPcSLEzc13uDXNg-1
X-Mimecast-MFC-AGG-ID: dJyYmdKyPcSLEzc13uDXNg_1771521043
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c71655aa11so1166424985a.3
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521043; x=1772125843;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ufSHZcVh+Dpk6NOIfY9tkcU2Fx29sq1FQcHOa9iMf4=;
        b=rszIKZezqIIq/LMQ2rN6Qyl6Ec/Ya0fl5CMurlVik5JY7w6cjelR+XFcaw5xoB4x8o
         UFwWWUZ0DIjyxSRP1e2dbj0IAeJPKXMQ100k6Wvpv8a2hz9UpbRCFAyoAReyrTp6Xx/G
         L3Yf+lkl+ajE6Mg1mMdXyBRc17Gbxc3/62ymWguaQWXLqgemdtkdBPpVdvy4TDr7uEgl
         xxa0mme0eWnzzP8HRGtIyoUxG3lLJhinU8uAiFk5MRKJH1QRi86uxa0f6UdRycjnAE8C
         pDJBTPrajKm7n/PqDAO53C/59a0rPdNMJqS/la0bkc6AYnIEp4H+hPToqd0Kd9i6B9Lu
         VL9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxNziiomEield21E/k9dhd9ov2WaAnIDc8eIZ6G6ACPrJ5bG/zfeUTFO50ZBeDGYVPuQdh2PGjyQ==@kvack.org
X-Gm-Message-State: AOJu0YyAv08lIzWjJl/inRlQcHDAepffZQc6xVKvIMLXV1HgB7gXKVgZ
	ccjIi3iq2Avx+LE3p+PRy9M10jmk0WXJalSvciMjMUnSfOfJxbxZojr2nFzksgPskysdnGipg+8
	B8co9FBY9nJEWLUfl5N9pO+1/77eRYAOL/vMLEWP4lrWdIbQTw21e
X-Gm-Gg: AZuq6aJLTMJa3IX0WhYPKZ8JYEQr61VnpS4DKaCY1i8oWlCsScQTZ0TQrvV77/E1vAG
	Dqvzax+5waB0tQXCj8t3ptBSmnGhf6yYrdOXhy9q1u7+X6zIAX+ObyWDXRztWJr3SCid0Ig3vu6
	azrKa+vtMHbt/L6RpVySpT3SwUmA3dE41AplB1/WdxP5OkjY1yKXdfU4+ekQ+SYIaCtT+aUUYXX
	5F66LaXFRbSPTzHDAZ/h8QVBuwb3+S4uzSB/CHzOj2CXTPkIVZNehPP8MXI8Ueepex8hBeHuOIZ
	eYb2j0B7hHSClw5qWZDL96FCctI4Em2DLg4XtCVc+UZqTplvfTFH60XPFUor/0uXl3Nb8J5A53I
	0dXSTXDS4jUu+sVPNBTS3viZFlP7qQmoFYzIuqmmONf2lBBxa/Xan14ga/Cmefx8=
X-Received: by 2002:a05:620a:44c2:b0:8c7:fdc:e877 with SMTP id af79cd13be357-8cb740b5c53mr703610385a.41.1771521043238;
        Thu, 19 Feb 2026 09:10:43 -0800 (PST)
X-Received: by 2002:a05:620a:44c2:b0:8c7:fdc:e877 with SMTP id af79cd13be357-8cb740b5c53mr703604885a.41.1771521042525;
        Thu, 19 Feb 2026 09:10:42 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b0e12eesm2128955585a.15.2026.02.19.09.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:10:42 -0800 (PST)
Date: Thu, 19 Feb 2026 12:10:41 -0500
From: Eric Chanudet <echanude@redhat.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] dma-buf: heaps: cma: charge each cma heap's dmem
Message-ID: <aZdAOMBRdRw59fa0@fedora>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
 <435330fd-ecdd-43c7-8527-f285c03c6421@amd.com>
MIME-Version: 1.0
In-Reply-To: <435330fd-ecdd-43c7-8527-f285c03c6421@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EYjvavuUBrX5iggDuOu0celvLeVdsPVdHpdgyUCm7Hg_1771521043
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B41320015
X-Rspamd-Server: rspam02
X-Stat-Signature: mwtwcmh1179pu5abwuobkd853fto3rsr
X-HE-Tag: 1771521046-932268
X-HE-Meta: U2FsdGVkX18Rb8ZpEsLD3lzWKnHdyXrBVJHvnwfROuq5ExeI2S1MzWbq9M7CxHws4y5wG/urkJvSsyVMYN7IEzaE6xS0qJPX/LDpcW0SMzuVErre7cvub/SDNEyoavbBc4HuVB479VCmvLdUAt+GETIjcwVQQW81mvUDwqUYTK5pcNjhhZ0Ii0D/O2eUvmPqavIa84YwmD1YD2ch7bDQ4Upa+MNfwDEySpnmDFhLZEZ6kfAUVYBS8PAgVqrTj4R8OLsT++VlEbFVKoQxc/cLqIOhVteHWoJpGMwCJgnfcday1Z+ibtw6YF1nKCDFJlEQFs6EF56zN31Az57EswkGsXJsfvnrVEB4AaTzG6bSJCHTF5n1skMfDVKehAcQ4Wb1tMvbENiHGkA7KVa2HbBeHIIxoEkOOFNlOTNoCeNtLE3vgNi+2XiiPyhq5FPvFVw9l+O5OsmC1eJmJ8fWNnKgKFA7vD1WnvFlPmz/mbkCslkec6YxwxekRkM7On+8Md0sK81RQiKjWERkN9qbqZcRQ6bq0QIaMABFi9mMFec6DXTpnV/LRBGvzdydjHZZ3bZK8AWuvD2o+26tJIGM+LUrkU4xs35sqIBHCv06tuAFrs3FELIyRmHwuyzNWyH11bkH0MGq2A5EG+wqDOeTBOvmQm/p9VWiKRFH6vcgDuhRRpHq3KIWXBHXbln0k6JZEoMbFJqM5MhYzKP/YcEVXYxP5uj/A5Cx2SVuJw4vQEDLS2n3dqvCkeSkQJ5H/vqwK71cRN3A0zutuyO+S9UXJIZ8I2rDppThJsaMrjbzVGcftLdeOAZsifpcMmNlBumaxq6m/37RFLnKQ91bsJ8JTWrWVjzZUU7RlSD3T1pqdQDD5BtYYLLcvmTkX78hTR+aQqFqNKNV70P99XXxhym78w+T3Aj403nuII3A52X8EhbwY4tlHXcnSWPIolrdWOZf4iv5Yr993cJ5B0EyNL1EwNY
 4xL4Bf+L
 q3nmpZAWUYIWQ24mK0TCfLtO2Xo0gmeQ+L0BzVLSYf0LoiML5HJiGZ/UN3blhRELjkcjFjxpjd9KsQakhIG6nBfwKVIY6D2xddmKGFeQUZ64Nc9EzYo5lxp1mGB1tW5RL0VbncIocntR+u+4KM6IjrsLmlSD/kHUQfE+VA7WvD4QjadZCHSXgEc4TgEYhnZIhVUt23d01wwDHTuDGB6+gO1Qt6Owpe0F3EqlE9htDXG7kIdcgVDYH2nD/a97EVG9KivABvBN6u8HG99ZndterQLRzo+b7Kgmo1Ie+VivaiWVctCrksewNROz6C1N10x5onVdHjnDgfxLtvNBnhnLRu5qgx3mESxn3NV+Baq51By8clZXWLPb5WiC9dzxE6d0RNWMmtX+9iz43VThu0DW+p3SDOQfWlI6mfTwS6t1wNeHnsDBfYYhyW58qfROmWQ7H4a6LY+/iQsyNGa6NhnvbMeA/Xy+BwRJryt7eGD1nPY7nKPqj0Qf82H1+MHRHsQwJHQYuv7XJu75SBQPWJcc6JqbaAhDKLWixuNQ4ZJBujaW9CuQq9bjyqdOMkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 08:17:28AM +0100, Christian König wrote:
> 
> 
> On 2/18/26 18:14, Eric Chanudet wrote:
> > The cma dma-buf heaps let userspace allocate buffers in CMA regions
> > without enforcing limits. Since each cma region registers in dmem,
> > charge against it when allocating a buffer in a cma heap.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> >  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
> > index 49cc45fb42dd7200c3c14384bcfdbe85323454b1..bbd4f9495808da19256d97bd6a4dca3e1b0a30a0 100644
> > --- a/drivers/dma-buf/heaps/cma_heap.c
> > +++ b/drivers/dma-buf/heaps/cma_heap.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/scatterlist.h>
> >  #include <linux/slab.h>
> >  #include <linux/vmalloc.h>
> > +#include <linux/cgroup_dmem.h>
> >  
> >  #define DEFAULT_CMA_NAME "default_cma_region"
> >  
> > @@ -58,6 +59,7 @@ struct cma_heap_buffer {
> >  	pgoff_t pagecount;
> >  	int vmap_cnt;
> >  	void *vaddr;
> > +	struct dmem_cgroup_pool_state *pool;
> >  };
> >  
> >  struct dma_heap_attachment {
> > @@ -276,6 +278,7 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
> >  	kfree(buffer->pages);
> >  	/* release memory */
> >  	cma_release(cma_heap->cma, buffer->cma_pages, buffer->pagecount);
> > +	dmem_cgroup_uncharge(buffer->pool, buffer->len);
> >  	kfree(buffer);
> >  }
> >  
> > @@ -319,9 +322,17 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> >  	if (align > CONFIG_CMA_ALIGNMENT)
> >  		align = CONFIG_CMA_ALIGNMENT;
> >  
> > +	if (mem_accounting) {
> 
> Since mem_accounting is a module parameter it is possible to make it changeable during runtime.
> 
> IIRC it currently is read only, but maybe add a one line comment that the cma heap now depends on that.
> 

Agreed, while read-only it is easily missed without at least a comment.
Alternatively, should that value be captured in the init callback to
guaranty it is set once and make this requirement clearer?

Thanks,

> Apart from that the series looks totally sane to me.
> 
> Regards,
> Christian.
> 
> > +		ret = dmem_cgroup_try_charge(
> > +			cma_get_dmem_cgroup_region(cma_heap->cma), size,
> > +			&buffer->pool, NULL);
> > +		if (ret)
> > +			goto free_buffer;
> > +	}
> > +
> >  	cma_pages = cma_alloc(cma_heap->cma, pagecount, align, false);
> >  	if (!cma_pages)
> > -		goto free_buffer;
> > +		goto uncharge_cgroup;
> >  
> >  	/* Clear the cma pages */
> >  	if (PageHighMem(cma_pages)) {
> > @@ -376,6 +387,8 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> >  	kfree(buffer->pages);
> >  free_cma:
> >  	cma_release(cma_heap->cma, cma_pages, pagecount);
> > +uncharge_cgroup:
> > +	dmem_cgroup_uncharge(buffer->pool, size);
> >  free_buffer:
> >  	kfree(buffer);
> >  
> > 
> 

-- 
Eric Chanudet


