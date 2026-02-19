Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966E0E9A055
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC9A6B0005; Thu, 19 Feb 2026 12:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89B16B0089; Thu, 19 Feb 2026 12:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996056B008A; Thu, 19 Feb 2026 12:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 861906B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:21:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1819F1B5902
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:21:32 +0000 (UTC)
X-FDA: 84461872824.29.8A05AEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA2E8140012
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:21:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iVa8clUG;
	spf=pass (imf26.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771521689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+MlxWO2a/5NxxDnoLl6rDcBacWRef25tqpr85yXgBM=;
	b=zfMrKtlGYmD+34GE02yWJiuF/ZsNJpCTaU6f2XbGbzV00Q/rjiRHuxeh2ekk324aFQbPt0
	4YyF/qwWgsJWJ+GpBHB4uC59mggiUQDyhZ9DqPKmyLpvP/E+Jy7LDmtdZbA0BXySKe2Q+A
	ynJWBh0ZMHWvxEkfLNwl5/7FkQ4X7SQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iVa8clUG;
	spf=pass (imf26.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771521690; a=rsa-sha256;
	cv=none;
	b=Djd5fvUsye0haD8lb4aTabQyBeaP6aD5IF9nocrh14oYIS8AIM80eo0UL1NsvHoWHQLhgK
	fzaqRMd1u4CV/TH9p5DEPBeXV8dEUaaRcRMZ/+MjUxJXsFcL/8YCHswiy1lGYMgB5Lbm2v
	zqj9NAZ9gpz7eA3HeLZC4pYmvtFwJzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771521689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a+MlxWO2a/5NxxDnoLl6rDcBacWRef25tqpr85yXgBM=;
	b=iVa8clUGt25Yn7/Ou6fR0hC0Oz8zoKWVYf9KkjjDunhSzrCgN4qXOE5fPiI5R2kErvNfxO
	xyvsSK1c3hK5HBPrfvdqhQMYGMEgoWW9XV0vLrR3TDNUnat0AuQwd9IX62HmnhNrOWRDLe
	Shy2J6Kg/mB7NAzq1DEWMa+XRohpXG8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-35dvKW_FMESsLwfCC4qSZw-1; Thu, 19 Feb 2026 12:21:25 -0500
X-MC-Unique: 35dvKW_FMESsLwfCC4qSZw-1
X-Mimecast-MFC-AGG-ID: 35dvKW_FMESsLwfCC4qSZw_1771521685
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c70ef98116so975808985a.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:21:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521685; x=1772126485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+MlxWO2a/5NxxDnoLl6rDcBacWRef25tqpr85yXgBM=;
        b=QyBtAAZoZ2RWL7EQTLElvj1wAG3o26rxMV8j2yutXM+h/6cfPX1CnL+KRy15Bs6pNT
         HSJgSVV/v4fGx/y48tRqeMkQlenMe0yhkEJC0fqRcG1LNp67s8gngLQR5P87Fkynd84N
         c6qrPrhENkTjZtJOrzMLBTDbDiY7GgFoEA2EGK2pieUWpKkSHmZc7h3bVXTmAXMvzo1f
         epfqDYIVuv7NtiBggFEgT7Otzez+KPAcWPySUxwW8RWEoaATd4Fr1LF0kblHhE2t9mev
         Y6onuxa9vWNLU515EbRi0VE8Ti4W0CqMb3/bnlc7Mrv5CoVk5gTLSM6gImm1PoZU+pNu
         beJg==
X-Forwarded-Encrypted: i=1; AJvYcCUHhlgD25fjt+qdeR7GQr0LcQsa3kOvolpneQ4rCaS35amvJa6ewBnvifK2eDrgXiWNIBvCNIj57A==@kvack.org
X-Gm-Message-State: AOJu0YyhkM1YoZjaeBxr9sGwn3PB1a1c9Aeg8S0qBM2fYcoBNXmd59Bt
	EhSx0lUqHYchTFgRY0KpyQFXvYsEnM9lpPYbf/cibAQ+U21sOaXsNwP+9PpsH7Wke7SV860ivj4
	EQ1vDOKBcrvTJPYw/D7EO7zLpl92aJu/PEkPnvrGKTAbMJTfkyGlg
X-Gm-Gg: AZuq6aLplgx+1LqVBcQmZ277aMKUtphhS1wknHi8Zi+f4I221WmIis5NM0VJ8/72wuc
	0RcYV/6Be1a1gpB0nvRTuMlIrCejEyNpB2o1Q6FD0eDX1tMp/FLrURHLlfkkPfhwKmu8I9REaX5
	QAjiHsc5gXRii6ZkhbcMjoOGdZLCPVnmKsStxcyQtyOYQ9CLaum9hEbdue4wMBYh2H0DDh5gqqb
	/KO53/diu6cpFFX1+KqUuHVBv/VnXxrsJRy8mIqbikNrNESWIr83E2HolIod9Rxt4YLQhpcvBRH
	LbJNWoNj7CbbmaTdjXHp27GzSjQgy3uKTaIbnV72qf8197kV3h7dq2uMtAZKNR2usT+7eOu29O9
	okhp7GphIuh0WjrE7KO4QDrFpvmbV5IgIEKwsid38dj9N13PzRf+TtqDzwjux6Gg=
X-Received: by 2002:a05:620a:4148:b0:8cb:3f0e:7740 with SMTP id af79cd13be357-8cb79f3269dmr425870985a.51.1771521685047;
        Thu, 19 Feb 2026 09:21:25 -0800 (PST)
X-Received: by 2002:a05:620a:4148:b0:8cb:3f0e:7740 with SMTP id af79cd13be357-8cb79f3269dmr425866385a.51.1771521684499;
        Thu, 19 Feb 2026 09:21:24 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50684b94e9fsm210902201cf.24.2026.02.19.09.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:21:24 -0800 (PST)
Date: Thu, 19 Feb 2026 12:21:23 -0500
From: Eric Chanudet <echanude@redhat.com>
To: Maxime Ripard <mripard@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, Albert Esteve <aesteve@redhat.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] dma-buf: heaps: cma: charge each cma heap's dmem
Message-ID: <aZdEMlKE_kGheI-b@fedora>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
 <20260219-illustrious-tungsten-starfish-5dad8c@houat>
MIME-Version: 1.0
In-Reply-To: <20260219-illustrious-tungsten-starfish-5dad8c@houat>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NGP5bfH5pBO2U5DoZa9QrTGyalcaDi5NFPAG5QfSohQ_1771521685
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA2E8140012
X-Stat-Signature: hu86wc73fb6bi3grxotqw3cywy7t9dj5
X-Rspam-User: 
X-HE-Tag: 1771521689-831667
X-HE-Meta: U2FsdGVkX1+86nMXZNsmxinBY2LdD1K0lONPEmPFRl2hPub9GfQinJq4TL+qJihdAqI5/+RE+rVRtjDusbRXrDLfdQbKhNW3SzR43n/XsDFtM9LP8K4Ha1XhHTEG5oMJPMS8UV/1Yve+3clsfbMiCPNfvsTFNnupk2eAh6AC1vp6FT7NWeOwUh+YyifHOq5gYI9a3/wMlOmNS+jLgNCUmDaw75YRuJuqejhlZmVuNoMruKSw8B6PgX7vUew8p1DzZnljrBn9bQbN/tfMKGfhsx9iwj3z4r55eeQH/C5OIHswsJuk8u/WzxRv8Cpl3rC7vTIGLVI080jaLjjIyS+alM7wv+H7alrFPJc11CFr/IpAvUFiK+EeAuyEaxnbFw95xhGnhmZ1sgW7vOU+tC2nQCTJIB8HgHyfJupGafxtjJ37CtozPEBaXP9Y6Q7OnoWC5/LBhtCIcAOpwzc6NAOGbFeiEcw43diIAkScFxoJR7DLlMHSX5rno1xPEbVr4/YdYhwL5wT7Vy19bqRdgPgFFg9QlVMgdWZwJmQ91nyLWXRZIPQFjixExZ3oYJFAAqnS0PBRcFQuDZIQBhWBLd60rLdZx0ClTJtKPj1ACElnYQRq4RKM/awlipHncuqkF1NqaR1uF/OIvDnQZkVq5zkKBfN1Qy0ipUPYAxjCA2iawrpiXVOMJ5sIbQES0owp34W6nRtsh7EpzaHEefbM17Yq5SyBv5XnWomVQKiqVRgcLCXVq1kzVwFdyWeGkRpyIhdsxfo0sELpOQA7HiMgEsTmjUQf5GfdXVxP3aVUFIQwirE4GkO0xVsP0Sx/Tme1SYkcc/Rmh6xKRsTmPT9nPMFIuUkFhVMfLixDmBO0V72qXkLptuyCmxtn6DzrkKq1QEbTJsBo7Mfu6X2hU6AjbWy1rXWNH2wb1DAqWaK2LIJUQ7TzREN/zS8wE6J1liRy/ag7J7XSzvPepVp1k5RyQMo
 pOZHh6rR
 M45Mf5flWzc47Phx15pTs5u52KHFJ3SYs/E8h+ik3v5ZJnlv8TxDvW53xQPdGfDpbqTFmTlWPzntWuR34b2f7DHaBCpys9qanpkQaWGc9lWEY6cPtX0tCi06mL8Yq21zJwYQ6PJR6MQBBj3ozKCWfNCzeMTLr40jCjAyF/W+G4Bw5tJyW3HYIrVtBWgZnwIQLmKrMndKp+Ksl8FJKisVMq6ddZmJ1K4NPPu1IpQEYWLoDxy70l3VzU6YqDyOvyZ2/BRV1f4T7rfTKJmtlRAldVNdpsVCUQ2Eq1PBiolfbl8fyVEe1Vm2eUVWU4lESpgiqnmcHIY58jjG/o4ozTlS9n0eW+1Qe9YUlcOw4N/9QJ+3UyJWqREDgLrUcxln3aBxFKcNnidcGmE3gRGuzLX6LJHNQXsZ8EVdFniWMAoIBiUTo5loY4ElDg5KjY/eyRpAGqYjRxKoKOCMAL+Ya9/05f7a46m+KLmvqDJIo3R9PYWGLTaaOKcWmMhmXDPd2W+vLNpIxaDWR8lXzLU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 10:16:37AM +0100, Maxime Ripard wrote:
> Hi,
> 
> On Wed, Feb 18, 2026 at 12:14:12PM -0500, Eric Chanudet wrote:
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
> 
> I guess we should add an #if IS_ENABLED #endif guard for dmem?
> 

Sure, I saw the other user (ttm) didn't, but that makes sense as the
field is useless if dmem is not enabled.

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
> > +		ret = dmem_cgroup_try_charge(
> > +			cma_get_dmem_cgroup_region(cma_heap->cma), size,
> > +			&buffer->pool, NULL);
> 
> This alone doesn't call for a new version, but adhering to the kernel
> coding style would look like this:
> 
> +		ret = dmem_cgroup_try_charge(cma_get_dmem_cgroup_region(cma_heap->cma),
> +					     size, &buffer->pool, NULL);

Will add to v3 with the other changes.

Thanks,

> 
> It looks good to me otherwise,
> Acked-by: Maxime Ripard <mripard@kernel.org>
> 
> Maxime



-- 
Eric Chanudet


