Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02564EC1103
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 055766B0092; Mon, 23 Feb 2026 11:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF07D6B0093; Mon, 23 Feb 2026 11:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1D36B0095; Mon, 23 Feb 2026 11:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8F056B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:14:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64C1D56D5F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:14:36 +0000 (UTC)
X-FDA: 84476219352.15.12CE863
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 108CF40003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:14:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CfrqWhtw;
	spf=pass (imf04.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771863274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRIkg/BYhLPQ8g8f8DScTuB2QESp5uVFZC6HG+ckSTg=;
	b=AwTDgajyVq+y64Fhh8jyo01NqVXntd+40vE/9J4TOIH7xY6CfnDOVK2AMJ8ZRf/1umXD7p
	yqinZtTunIscReX3IjsLaAYhXmXwpzHOvN9f1EC2t4swDPb/E4j0ASOjbc2acF82gnKFGJ
	zn6izAh9t2weiyhSQ4nfhcOKZtBalDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771863274; a=rsa-sha256;
	cv=none;
	b=MjxGffyY3svwOV5gdzKne6ODcbh58YGL/UbSOHDhTsskCRVmFBM0GkoPlLaRFyOVgkQ8eM
	JotCSSqrOczieb+WwBjBeNBx36u3HIyhziFuynXOHl2DeFX23AA/bWk0h2iiRm6oAZvRik
	FkQm04pRP//ASCCiGzTJRkjEGZ+l9CQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CfrqWhtw;
	spf=pass (imf04.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771863273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRIkg/BYhLPQ8g8f8DScTuB2QESp5uVFZC6HG+ckSTg=;
	b=CfrqWhtwHwsqlGb9RMyc0jTFj7btcUkY9xetR/GkwXIjksa1bO+iqXWtG3c6nI0mY5P9WM
	RqOICxu5YxO/KcOcoj8E9GYP81tSwbFHhwatpp5idYZcbfxa5OhYTUWiD7XACeuax8UvMH
	HwlY8QQQMw7siRpebRbLesqVEM8NxX0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-3rmFB_ADOW2roUNbtduCUA-1; Mon, 23 Feb 2026 11:14:31 -0500
X-MC-Unique: 3rmFB_ADOW2roUNbtduCUA-1
X-Mimecast-MFC-AGG-ID: 3rmFB_ADOW2roUNbtduCUA_1771863271
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-506bac14430so200802391cf.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:14:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771863271; x=1772468071;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRIkg/BYhLPQ8g8f8DScTuB2QESp5uVFZC6HG+ckSTg=;
        b=fK6XMFLdE5GifmT9I2eFwCiUKWlPj+c1Wvm3b7Vn2Y4T8K46HQxSqxDFmalsLEunId
         iU8EQNI1ptDHUvmIRA+WMesL2SikH8eoWsU6CAm6bk2F4snmfys+HxTEnnLvsAuzWVlH
         JmAGdiZtPizyolwDkRZknQdArMJ8kgeFnIn4t5uON5wDn1QM8cfSVDbwQH+wSJOBnA0E
         JdZVR00WQaXAV+w5B93FilISFtdKAz/LasXGczbHbddPERh0MKgfKplxHyCuW4P/OeQm
         jd3SvK6Pvw9x7RxnBtlfEhoa30GwM0vYTvWKtfOv+NhYIJccHcDJs1QZgqR8iK6fTB2B
         lt0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBx+vbOV88PMIdXOtEdFpLkKF7ahJo5enzPdd8vqm3RxLxMC6oZa0wWgbFsY4p1SydU8I2tjk/5Q==@kvack.org
X-Gm-Message-State: AOJu0Yxl3SaK40Oaz2Bp9ywYWKgHZPV4aJwVtwRlKn0t8d2KgaQw6Tdc
	KLq3cGezlDC6DVWTeSSY5yfvR02lSSExwgrWgKPkJKJii3ckNI2xK2nSb53VAIQnX0p2tGBYhyC
	pT0Lsog1MqRpX84kRBASlAXjBdxxmefBGciaTAMgP2mN7uDxbCk3t
X-Gm-Gg: AZuq6aKrtltsGfmXO5/DO1rBaDJo3eEvD5DJUTN12DTcMH05ou/j8oFpEdQRNrilmyc
	rf3iX88OJ18b86a+/k0esFOJvH5k4xe+yT3dcK/XOu5XNL2R6zas0iqZbX5tB5SFzEI7it7VpWg
	C+S8encnOb/uXHL0kLVO77xqZ1ZDxqA1wGxdswOms/WsCsqpl5/Z2asW5+mgWIWkbWIiO7Omoz8
	oU8wmp9mujXLZeKCm9QJhOtVLgagqrojVT8808nfxm3m8lsCAw6JL7dZeKBBMfoV4Gc5qrdKkVT
	TXQLIMijOE78Q7dvnL4WW1RjSX3gPhdrz3Z8qmArsAVZqKUmeiJIDgC4vmbyRoPiXzcN5SiuZnJ
	1W3TJXOIXwZI+maJWDTTmQGeEanj60QfH9k0PyOdONjQeQ/LnIOJs936kpd0RVLg=
X-Received: by 2002:a05:622a:1b9e:b0:501:17a9:5ff5 with SMTP id d75a77b69052e-5070bbd86aemr127614881cf.21.1771863270830;
        Mon, 23 Feb 2026 08:14:30 -0800 (PST)
X-Received: by 2002:a05:622a:1b9e:b0:501:17a9:5ff5 with SMTP id d75a77b69052e-5070bbd86aemr127614251cf.21.1771863270296;
        Mon, 23 Feb 2026 08:14:30 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d6a1ddasm71793581cf.21.2026.02.23.08.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:14:29 -0800 (PST)
Date: Mon, 23 Feb 2026 11:14:29 -0500
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
Message-ID: <aZxxGNRHvURLXU3E@x1nano>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
 <435330fd-ecdd-43c7-8527-f285c03c6421@amd.com>
 <aZdAOMBRdRw59fa0@fedora>
 <0ff02d77-13e8-4b2c-b714-38037595d535@amd.com>
MIME-Version: 1.0
In-Reply-To: <0ff02d77-13e8-4b2c-b714-38037595d535@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LhoDLr6ni53H1vMf-6Vt-l8gla7Pd_j4bnWLTITPOiQ_1771863271
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: gkd5mcauwo6kytxfuucch388ekoggdza
X-Rspamd-Queue-Id: 108CF40003
X-Rspam-User: 
X-HE-Tag: 1771863273-677589
X-HE-Meta: U2FsdGVkX1+KDOBEwRIcsnzA1O0CkR6yJyyuP7WTFDfHodE4qy7VtUZe5yvHtuUdj7n5ygdF6Qia8iTTcupDOJdo7tcAPPGODRwQvMmI6V2Bx0KKDNcX0cvmPTKBLiOg0VqEjuXhJ0T1bWQHvbiUPrgBg9bkNrnGViPDFFX8P9oIrcryPycF21kC2Y1aql8FGmot2cb8F2BCAwVPELiXe0LppLXctz2F+lth+XjRq1jv7uJmMpvV3hNg3kdXyjb5izU007pZoOLQPy1tVD5k7AE6kyame6hlK7m5Ih7UIC1D9yEYwHdoXOSjYVlvkGdFxv4jZIEGUweA55f0TDtm6eJKECjQ8+ZcJgSmLmpPGoT3Qizb+B7fOVYy6w4uY5fhNGbs9+Qcfns6sZdHje5qBocwDwhCG7E4xIMN65+TnfqWx43rJpFVlxT9jbSOLnP+CY3PTL8vY8TOm3+sCfXGWzwP/v2Dj9SGhb0X1so7eyjDWyn3+koLuJ3tE12k7oz7D5nB3tfniHOhwLNdS5ya1aFSdNakdIL0cduYyLYj2Zm05PEEZz80dQ6zggQZmgy5hQqqxqhRf5G30erJXLSbQYoP4uCoO23I0DD+vptNK/hWUmG/2jkL+bBe7fJ2qrOmTs6SbYt87WIjD/mNEStxj+zq0AsR+kAtElR08BvLeX+Nm/CoK3YKBMQnEjXXg8jKO5KVRB09/npfJQBKq4LUV7xR3h8660sk9cSoJd0bpFC4x5rexrbAyVD/jFmDVgLXmLYu7H5MS6VNp8BtBLPZ4oDRq6Z0e1K0HjW6KDrIDiRck0IGpuye9KjMCOSWfYgYn+BO7/SMxWgWUQNPpmowDeo2uH6QEd3BP0JQAb2ckfcKHmsI6Lb6XS+tUa4Ke+6yIYVV5Of9pqm7i/s5zYXSrvIGmbdFuVvJ04q6ooTpBc9zArPbZ+WSCbBFV+HpFp7g3OJFe38NLP8fKst4Jna
 n+WaqtYf
 9+ZbF29D+3pGWXz04sa952wQl05ZyTIGXdmVwcbtnSjhd0OvnSDlmvJ62rMNfhgwV/URWxcvL1d7zNnO/84KDW+aKt4DK+TbYJmKu9XCvVBqS8aMK/FrlC693A2vvXqVGmlp0adTG+uxBm9mzDzlsNLpj8VrnRvu5VGhlJX23iNKdiANeAnCqhNA8Vl00iXazKCMyXqvFSGucNIgAiMmrYoyWSZ/4D2kquwL1rIo/WF6mHz+7fm3pTI3zSaEplDsZ1J2xrJfwnAJJRo9absukNqB6lTxKmYId9LA2kKTC/Y6oimTkMvT2gYBtKwJwXqJ4SNUhzmuWAd1+MUmYb+onK7fWuRmjERd98byVY+sdk0r/z6YH3NCiU3RBMBvuXYO0JYj/vq260c6EImUwo35TwG1OIWCK/4i79KRw4b2T00Cm5PybIoZwpxAP2Pw5iAN7GfKcSc3PLmbTzbiPZaus8f9/xEuWy1uYi+ntL0RSeq1nRmPtV5G8fj1LzkCzNcAjulb+RxTJTmsq2omDY4SkzvKpSwBoDIUPiHk4h8wY1wa+m7fGAydw0NPWJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 09:16:15AM +0100, Christian König wrote:
> On 2/19/26 18:10, Eric Chanudet wrote:
> > On Thu, Feb 19, 2026 at 08:17:28AM +0100, Christian König wrote:
> >>
> >>
> >> On 2/18/26 18:14, Eric Chanudet wrote:
> >>> The cma dma-buf heaps let userspace allocate buffers in CMA regions
> >>> without enforcing limits. Since each cma region registers in dmem,
> >>> charge against it when allocating a buffer in a cma heap.
> >>>
> >>> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> >>> ---
> >>>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
> >>>  1 file changed, 14 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
> >>> index 49cc45fb42dd7200c3c14384bcfdbe85323454b1..bbd4f9495808da19256d97bd6a4dca3e1b0a30a0 100644
> >>> --- a/drivers/dma-buf/heaps/cma_heap.c
> >>> +++ b/drivers/dma-buf/heaps/cma_heap.c
> >>> @@ -27,6 +27,7 @@
> >>>  #include <linux/scatterlist.h>
> >>>  #include <linux/slab.h>
> >>>  #include <linux/vmalloc.h>
> >>> +#include <linux/cgroup_dmem.h>
> >>>  
> >>>  #define DEFAULT_CMA_NAME "default_cma_region"
> >>>  
> >>> @@ -58,6 +59,7 @@ struct cma_heap_buffer {
> >>>  	pgoff_t pagecount;
> >>>  	int vmap_cnt;
> >>>  	void *vaddr;
> >>> +	struct dmem_cgroup_pool_state *pool;
> >>>  };
> >>>  
> >>>  struct dma_heap_attachment {
> >>> @@ -276,6 +278,7 @@ static void cma_heap_dma_buf_release(struct dma_buf *dmabuf)
> >>>  	kfree(buffer->pages);
> >>>  	/* release memory */
> >>>  	cma_release(cma_heap->cma, buffer->cma_pages, buffer->pagecount);
> >>> +	dmem_cgroup_uncharge(buffer->pool, buffer->len);
> >>>  	kfree(buffer);
> >>>  }
> >>>  
> >>> @@ -319,9 +322,17 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> >>>  	if (align > CONFIG_CMA_ALIGNMENT)
> >>>  		align = CONFIG_CMA_ALIGNMENT;
> >>>  
> >>> +	if (mem_accounting) {
> >>
> >> Since mem_accounting is a module parameter it is possible to make it changeable during runtime.
> >>
> >> IIRC it currently is read only, but maybe add a one line comment that the cma heap now depends on that.
> >>
> > 
> > Agreed, while read-only it is easily missed without at least a comment.
> > Alternatively, should that value be captured in the init callback to
> > guaranty it is set once and make this requirement clearer?
> 
> It probably makes more sense to make nails with heads and make it runtime configurable.
> 
> I'm not sure how exactly dmem_cgroup_try_charge()/dmem_cgroup_uncharge() works, could be that it works correctly out of the box and you just need to initialize buffer->pool to NULL when mem_accounting is not enabled.
> 

dmem_cgroup_uncharge() is called unconditionally and checks for NULL
while buffer is kzalloc(), so buffer->pool is NULL from
cma_heap_allocate() if mem_accounting is not set.

Some buffers will be accounted for and some won't depending on when it's
toggled and when buffers are requested, which didn't seem to serve much
use and is why it's set read-only.

> Regards,
> Christian.
> 
> > 
> > Thanks,
> > 
> >> Apart from that the series looks totally sane to me.
> >>
> >> Regards,
> >> Christian.
> >>
> >>> +		ret = dmem_cgroup_try_charge(
> >>> +			cma_get_dmem_cgroup_region(cma_heap->cma), size,
> >>> +			&buffer->pool, NULL);
> >>> +		if (ret)
> >>> +			goto free_buffer;
> >>> +	}
> >>> +
> >>>  	cma_pages = cma_alloc(cma_heap->cma, pagecount, align, false);
> >>>  	if (!cma_pages)
> >>> -		goto free_buffer;
> >>> +		goto uncharge_cgroup;
> >>>  
> >>>  	/* Clear the cma pages */
> >>>  	if (PageHighMem(cma_pages)) {
> >>> @@ -376,6 +387,8 @@ static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> >>>  	kfree(buffer->pages);
> >>>  free_cma:
> >>>  	cma_release(cma_heap->cma, cma_pages, pagecount);
> >>> +uncharge_cgroup:
> >>> +	dmem_cgroup_uncharge(buffer->pool, size);
> >>>  free_buffer:
> >>>  	kfree(buffer);
> >>>  
> >>>
> >>
> > 
> 

-- 
Eric Chanudet


