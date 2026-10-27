Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF73606A332
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DVrTuZc6
Received: by kanga.kvack.org (Postfix)
	id E89626B066B; Tue, 27 Oct 2026 05:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A7A6B066D; Tue, 27 Oct 2026 05:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28FF6B066E; Tue, 27 Oct 2026 05:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACF486B066B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:42:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3386DA84ED
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:42:57 +0000 (UTC)
X-FDA: 85367917194.20.94B4FCC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9E4F180005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:42:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DVrTuZc6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
	b=poIsjyWzGvhgZCwvOcyiSWS1na3rjUcFGVjfc+D0EErhSO9JfiRDKbEi9ApmxQCG2TySbN
	IV0gTf5cCQ+d4k2Cczz78tJay0jmtOITC653j9BEKCCeDYFubZUr1aZf242Cl0sMDfvPnM
	Jy/Kt/Ldj2MxbU5KUTj7kRp87fzrF1M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DVrTuZc6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094175;
	b=aoyGSHWOTaXJBVmxQKo8gnE8IPGeNFmJz7QmyJkda+uCzw2nSKlhYivfRVIDozNGhUcfF2
	LQ3biq2B3utgc05OJb6Dbd22lOlaOA4n3TvKOUIXDSmR/QkgsBY0X1XbldMuiZ4i1JcvNL
	yFzeNgyw/ewj8pyyU13cEvWgYjewpxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793094174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
	b=DVrTuZc6aN+ZiCxZU6SP/cuYh2ldVZ2ZoQK7fsNDVA8kpEqzbnXduZLsAwsGUrkjHK9esw
	+0eJwOt6Q9QMCH5fCxhiKJgLUhyP0PRVEsDUd1hHSbxauoOdWgaNIX0vv+LZnF/lsLiUbL
	q8xct7s/8KmPhoYVwd1LtoXV/6FBb9o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-FaMB1H7OMDafwW2EfTvj2w-1; Tue, 27 Oct 2026 05:42:53 -0400
X-MC-Unique: FaMB1H7OMDafwW2EfTvj2w-1
X-Mimecast-MFC-AGG-ID: FaMB1H7OMDafwW2EfTvj2w_1793094172
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48e17d30a79so2369689f8f.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793094172; x=1793698972;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+oMimfwV7cZjftt0OWdyMqPpN9ija5vYYfza+1oRCE4=;
        b=OAJZrYn3NPvakL/3uzzrKfR8r/o/XdyG2SOQAHSc0lQGUqfVTztCrQntCBBkgTodG5
         3TXW0NMi6mHMCZnAqOshHx9tKlPFmk5Y/yy7JEU4asEh0lI6rQmoBj30lcs5kjR001lB
         MkaIbjrIiB2nWNWMAHRdUzGN2byIBZT0lOblAIRjDelwQcE1+gQqD9r1NvavH/jvtUtm
         MqF0/eAxED9KM0nPd3wEgAYFLUaW8F/qAwF3CTGEmnKwqWDq+SsZ/hi2PU9pkGAPA5y1
         SVZ6V9F6Lg3oIga4qsiS4dkwn3QUw3Mq4adDm+ZgsnuN4QoeHDIYR6fiDk8IR/TKZ++b
         vdAg==
X-Forwarded-Encrypted: i=1; AKwUvBzv4SnaBi57KuB3j+sQmJ7i8BxpMQPgdf2ATTqVsfXNk7r0qCf17EOQkWvbhaBFDWft7uJyI731Nw==@kvack.org
X-Gm-Message-State: AFq9FYIKT8dY0Kel1CwDwzD+oTnv41I9f9kG63pUYy53Te6YamEFnANW
	P5bVljXMs2lM8OKJ4zvPSj1O7YC10aT3kr5vWVpKXx9o024FWN9ywEyPkX/1cDOYOkFPBzzr6Yd
	m9xrtSaPkHvLB7eoA/PclWef2kpFz592nV4qrhK1Kr1ZISWOvbaiC
X-Gm-Gg: AYBFou04ncHYvv28wB2cO9HtNlBgdPJUrZHCSfxHo5a9Q94DvgMUv8sWP7A0zeKiueQ
	7MZDXSZM/T2xRQJyA65EvVHGOBNfIWMvq0uTX1Oefv3WKfwV07xL1XtwlP5KdsyjfRFz6iHFNB9
	c5uFB8oi9KKm5/ynjJYqXaPlDOj3oVwiFi4C69fR1xwrQFBt/OwcAS6ov5ZCb27px3GDV/Hkajx
	V8CcaJE8mxki9TgMfp34jYfinIigggi4O5Izh4Uae8lZ9vpvMIz1F4su3Z7lTsbyUUjmTFic0Mt
	DUJkwpWjHwUNX/gMcCb6Dkf/ug0pcYP7O3wKOuc8MojEh5nW6vbQiVbq/EDED1wj1QA=
X-Received: by 2002:a05:6000:2289:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-48e3eb9fe3emr17684501f8f.47.1793094171554;
        Tue, 27 Oct 2026 02:42:51 -0700 (PDT)
X-Received: by 2002:a05:6000:2289:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-48e3eb9fe3emr17684427f8f.47.1793094170889;
        Tue, 27 Oct 2026 02:42:50 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm25694707f8f.45.2026.10.27.02.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 02:42:49 -0700 (PDT)
Date: Tue, 27 Oct 2026 05:42:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 01/13] virtio_ring: support per-virtqueue DMA mapping ops
Message-ID: <20261027053843-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-2-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261027025616.1632690-2-kevinloughlin@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RdBIPfAWXkoW8COmBwQcabw1sGPVfkMi9cQt3Qo6OEc_1793094172
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: C9E4F180005
X-Stat-Signature: 3pscwqfpogrm13owxhe9no7smjb5oyc7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793094174-839578
X-HE-Meta: U2FsdGVkX18dL29VY3hxVt3xd/NgFdHw78G+NmrJqrkAIrDj/RJc6z7ztJofGH5Nyxm79I8tPnyBWjPSep/vBhHouCc2PXGFCUKT571TAZfd3Fm9P5QiL3EOgTOwvN/loZlVJRcaxR0d3l0RoSxRfydqh79JvhiNMESUpHqT7H4SWFW5HtF8ZWDqWSHWnm+tFYiQua+Umn/Pz+PmtEhR8RUPb2zwX20SgdasQplHI80pajpee2bBQdO6YfhmtfPqF+uYJOgwXoFY4Rx9c6wQfHvqLLk7PpjNawO6GQksb2kqNQNBB/97Tc3Lou1V1O5c3QtDgPvRFoZ+78SKF4P3uIkPIFqymfyOfGRSsVVqp/OKl6FbBihbn+6e1tCHV1T9Bm6YOrP00PD8V2pTofSSs14wtvmFV/lwGwhP76yvaibKU98YLsBTqX64DpCY/4hKg+rM8FyIW7BqIZSAq6CA5Rh+5Bd4wa4lLyQKNCtqQWA8W2+2pw0lBgC0yIYqRBx0SznEtdkj59/ehCJWAupbFLW7meyv+E8yHKLFmna0OkzebZvsidePH9PCctUXgri5tfCu6i8lygXr+rn+JDKbWFk1EiY09bsrGWKDAJIcnlVs2X80qKMchr6NikXd1OdiNmRqqDDn4sjQri9PxOeCG7wnzn7NlfOhBQjXxVIYci6xSKagcaYSGVU1QvqnzoSbmL0Kpgz6nyX0fQFohE7BS/xuJI5E8/aqwE1XjI29vdetPcNNWg8gUiSm399VbxeJla8C/wQG6O4TtD+1DfE5Wn4kIJXbFu4pGG2WHQ3HvyWR+Tm1Xx/kF0RRE6NPV4/XVAtMlTO8q91LvGrD8cDG1NzezAmGGASQ95iEeK8h8wisU7eSkHG1KBMSvRyshwteKtLD8cHQnd+TJWAqnvGffn9LuXjgZskSoO/yX3olknB8Symi0GGV8Zy14uUH7ITpH7YgQUXXnnVHxdjvcL8
 hXYNB2ke
 2myaNo4R1UHW5Mi9vcqOKPCOUBwBaz/z3vIwKbGUr/0JkU0E1m6R36G1aqJY40uYKQhlJFsqO9p4IL2kJf0jxp1bG4AMs2J5bWVv+vBsvmawgApUJpXIPYmvira86Zyau13byEqy1y1lkRwouoNSA6weCcFMNPw9jI3gbqcJ9/VGhUqimk0IvLOZOKKtqPp9EOyP7TGChwrkHfiXxKd2mL727rOVZ56P7wjdHhCCtqfRInIYuZ/u6G6Bu2nK0eWrh2/3NU/gCv1b0pOiChuQxcG8+GKYd2zmyqX4Q1CYQXQ3sQ9KrZfmlu+9ZkWCBAV3A9pQAcVu/hCKBcNJTKtbBZdb9/yYkQJbPiNgod8ZhRAa3UG2Z6wJJuip2LZG7e7L1xKijQ4u9DwAELoBQDIHzEC4ngom5nRpFdZ9lBBEypog45VorwvlT3LFY+avLLgncvsw3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 02:56:04AM +0000, Kevin Loughlin wrote:
> Allow individual virtqueues to override the device-wide DMA mapping
> operations via virtqueue_set_map_ops(). When custom per-virtqueue
> mapping operations are configured, vring_map_one_sg(), vring_unmap_one(),
> vring_mapping_error(), and the DMA sync helpers dispatch through
> vq->map_ops instead of the parent virtio_device DMA API path.
> 
> Replace vring_map_single() with vring_map_indirect() and
> vring_unmap_indirect() using the device-level mapping path (vdev->map
> or dma_map_page_attrs()) so that indirect descriptor tables continue to
> be DMA-mapped for host VMM access even when a virtqueue overrides buffer
> mapping via vq->map_ops.
> 
> Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>

Please, don't. The automatic mappings inside virtio core are there
to keep simple things, simple.

Everyone doing something funky with mappings should use the premapped API.


> ---
>  drivers/virtio/virtio_ring.c | 136 ++++++++++++++++++++++++-----------
>  include/linux/virtio.h       |   4 ++
>  2 files changed, 98 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index db678f5a80e0..9c6a1e9f0a0b 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -261,6 +261,7 @@ struct vring_virtqueue {
>  	bool we_own_ring;
>  
>  	union virtio_map map;
> +	const struct virtio_map_ops *map_ops;
>  
>  #ifdef DEBUG
>  	/* They're supposed to lock for us. */
> @@ -477,16 +478,32 @@ static struct device *vring_dma_dev(const struct vring_virtqueue *vq)
>  	return vq->map.dma_dev;
>  }
>  
> +static inline const struct virtio_map_ops *vring_get_map_ops(const struct vring_virtqueue *vq)
> +{
> +	if (vq->map_ops)
> +		return vq->map_ops;
> +	return vq->vq.vdev->map;
> +}
> +
> +void virtqueue_set_map_ops(struct virtqueue *_vq,
> +			   const struct virtio_map_ops *map_ops)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +	vq->map_ops = map_ops;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_set_map_ops);
> +
>  static int vring_mapping_error(const struct vring_virtqueue *vq,
>  			       dma_addr_t addr)
>  {
> -	struct virtio_device *vdev = vq->vq.vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return 0;
>  
> -	if (vdev->map)
> -		return vdev->map->mapping_error(vq->map, addr);
> +	if (map_ops)
> +		return map_ops->mapping_error(vq->map, addr);
>  	else
>  		return dma_mapping_error(vring_dma_dev(vq), addr);
>  }
> @@ -530,15 +547,45 @@ static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist
>  	return 0;
>  }
>  
> -static dma_addr_t vring_map_single(const struct vring_virtqueue *vq,
> -				   void *cpu_addr, size_t size,
> -				   enum dma_data_direction direction)
> +static int vring_map_indirect(const struct vring_virtqueue *vq, void *cpu_addr,
> +			      size_t size, dma_addr_t *addr)
>  {
> -	if (!vq->use_map_api)
> -		return (dma_addr_t)virt_to_phys(cpu_addr);
> +	struct virtio_device *vdev = vq->vq.vdev;
> +
> +	if (!vq->use_map_api) {
> +		kmsan_handle_dma(virt_to_phys(cpu_addr), size, DMA_TO_DEVICE);
> +		*addr = (dma_addr_t)virt_to_phys(cpu_addr);
> +		return 0;
> +	}
> +
> +	if (vdev->map) {
> +		*addr = vdev->map->map_page(vq->map, virt_to_page(cpu_addr),
> +					    offset_in_page(cpu_addr), size,
> +					    DMA_TO_DEVICE, 0);
> +		if (vdev->map->mapping_error(vq->map, *addr))
> +			return -ENOMEM;
> +		return 0;
> +	}
> +
> +	*addr = dma_map_page_attrs(vring_dma_dev(vq), virt_to_page(cpu_addr),
> +				   offset_in_page(cpu_addr), size,
> +				   DMA_TO_DEVICE, 0);
> +	if (dma_mapping_error(vring_dma_dev(vq), *addr))
> +		return -ENOMEM;
>  
> -	return virtqueue_map_single_attrs(&vq->vq, cpu_addr,
> -					  size, direction, 0);
> +	return 0;
> +}
> +
> +static void vring_unmap_indirect(const struct vring_virtqueue *vq,
> +				 dma_addr_t addr, size_t size)
> +{
> +	struct virtio_device *vdev = vq->vq.vdev;
> +
> +	if (vdev->map)
> +		vdev->map->unmap_page(vq->map, addr, size, DMA_TO_DEVICE, 0);
> +	else
> +		dma_unmap_page_attrs(vring_dma_dev(vq), addr, size,
> +				     DMA_TO_DEVICE, 0);
>  }
>  
>  static void virtqueue_init(struct vring_virtqueue *vq, u32 num)
> @@ -576,6 +623,8 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	if (flags & VRING_DESC_F_INDIRECT) {
>  		if (!vq->use_map_api)
>  			goto out;
> +		vring_unmap_indirect(vq, extra->addr, extra->len);
> +		goto out;
>  	} else if (!vring_need_unmap_buffer(vq, extra))
>  		goto out;
>  
> @@ -761,10 +810,11 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
>  
>  	if (indirect) {
>  		/* Now that the indirect table is filled in, map it. */
> -		dma_addr_t addr = vring_map_single(
> -			vq, desc, total_sg * sizeof(struct vring_desc),
> -			DMA_TO_DEVICE);
> -		if (vring_mapping_error(vq, addr))
> +		dma_addr_t addr;
> +
> +		if (vring_map_indirect(vq, desc,
> +				       total_sg * sizeof(struct vring_desc),
> +				       &addr))
>  			goto unmap_release;
>  
>  		virtqueue_add_desc_split(vq, vq->split.vring.desc,
> @@ -1370,6 +1420,7 @@ static struct virtqueue *__vring_new_virtqueue_split(unsigned int index,
>  #endif
>  	vq->map = map;
>  	vq->use_map_api = vring_use_map_api(vdev);
> +	vq->map_ops = NULL;
>  
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
> @@ -1488,6 +1539,8 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
>  	if (flags & VRING_DESC_F_INDIRECT) {
>  		if (!vq->use_map_api)
>  			return;
> +		vring_unmap_indirect(vq, extra->addr, extra->len);
> +		return;
>  	} else if (!vring_need_unmap_buffer(vq, extra))
>  		return;
>  
> @@ -1585,10 +1638,9 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
>  	}
>  
>  	/* Now that the indirect table is filled in, map it. */
> -	addr = vring_map_single(vq, desc,
> -			total_sg * sizeof(struct vring_packed_desc),
> -			DMA_TO_DEVICE);
> -	if (vring_mapping_error(vq, addr))
> +	if (vring_map_indirect(vq, desc,
> +			       total_sg * sizeof(struct vring_packed_desc),
> +			       &addr))
>  		goto unmap_release;
>  
>  	vq->packed.vring.desc[head].addr = cpu_to_le64(addr);
> @@ -2620,6 +2672,7 @@ static struct virtqueue *__vring_new_virtqueue_packed(unsigned int index,
>  #endif
>  	vq->map = map;
>  	vq->use_map_api = vring_use_map_api(vdev);
> +	vq->map_ops = NULL;
>  
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
> @@ -3064,7 +3117,7 @@ struct device *virtqueue_dma_dev(struct virtqueue *_vq)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
>  
> -	if (vq->use_map_api && !_vq->vdev->map)
> +	if (vq->use_map_api && !vring_get_map_ops(vq))
>  		return vq->map.dma_dev;
>  	else
>  		return NULL;
> @@ -3809,18 +3862,17 @@ EXPORT_SYMBOL_GPL(virtqueue_map_free_coherent);
>   */
>  dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
>  				    struct page *page,
> -				    unsigned long offset,
> -				    size_t size,
> +				    unsigned long offset, size_t size,
>  				    enum dma_data_direction dir,
>  				    unsigned long attrs)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
> -	if (vdev->map)
> -		return vdev->map->map_page(vq->map,
> -					   page, offset, size,
> -					   dir, attrs);
> +	if (map_ops)
> +		return map_ops->map_page(vq->map,
> +					 page, offset, size,
> +					 dir, attrs);
>  
>  	return dma_map_page_attrs(vring_dma_dev(vq),
>  				  page, offset, size,
> @@ -3842,11 +3894,11 @@ void virtqueue_unmap_page_attrs(const struct virtqueue *_vq,
>  				unsigned long attrs)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
> -	if (vdev->map)
> -		vdev->map->unmap_page(vq->map,
> -				      map_handle, size, dir, attrs);
> +	if (map_ops)
> +		map_ops->unmap_page(vq->map,
> +				    map_handle, size, dir, attrs);
>  	else
>  		dma_unmap_page_attrs(vring_dma_dev(vq), map_handle,
>  				     size, dir, attrs);
> @@ -3941,13 +3993,13 @@ EXPORT_SYMBOL_GPL(virtqueue_map_mapping_error);
>  bool virtqueue_map_need_sync(const struct virtqueue *_vq, dma_addr_t addr)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return false;
>  
> -	if (vdev->map)
> -		return vdev->map->need_sync(vq->map, addr);
> +	if (map_ops)
> +		return map_ops->need_sync(vq->map, addr);
>  	else
>  		return dma_need_sync(vring_dma_dev(vq), addr);
>  }
> @@ -3971,14 +4023,14 @@ void virtqueue_map_sync_single_range_for_cpu(const struct virtqueue *_vq,
>  					     enum dma_data_direction dir)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return;
>  
> -	if (vdev->map)
> -		vdev->map->sync_single_for_cpu(vq->map,
> -					       addr + offset, size, dir);
> +	if (map_ops)
> +		map_ops->sync_single_for_cpu(vq->map,
> +					     addr + offset, size, dir);
>  	else
>  		dma_sync_single_range_for_cpu(vring_dma_dev(vq),
>  					      addr, offset, size, dir);
> @@ -4002,15 +4054,15 @@ void virtqueue_map_sync_single_range_for_device(const struct virtqueue *_vq,
>  						enum dma_data_direction dir)
>  {
>  	const struct vring_virtqueue *vq = to_vvq(_vq);
> -	struct virtio_device *vdev = _vq->vdev;
> +	const struct virtio_map_ops *map_ops = vring_get_map_ops(vq);
>  
>  	if (!vq->use_map_api)
>  		return;
>  
> -	if (vdev->map)
> -		vdev->map->sync_single_for_device(vq->map,
> -						  addr + offset,
> -						  size, dir);
> +	if (map_ops)
> +		map_ops->sync_single_for_device(vq->map,
> +						addr + offset,
> +						size, dir);
>  	else
>  		dma_sync_single_range_for_device(vring_dma_dev(vq), addr,
>  						 offset, size, dir);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index f923e42cfd01..20fe333d6778 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -44,6 +44,7 @@ struct virtqueue {
>  };
>  
>  struct vduse_vq_group;
> +struct virtio_map_ops;
>  
>  union virtio_map {
>  	/* Device that performs DMA */
> @@ -294,6 +295,9 @@ void virtqueue_map_free_coherent(struct virtio_device *vdev,
>  				 size_t size, void *vaddr,
>  				 dma_addr_t dma_handle);
>  
> +void virtqueue_set_map_ops(struct virtqueue *_vq,
> +			   const struct virtio_map_ops *map_ops);
> +
>  dma_addr_t virtqueue_map_page_attrs(const struct virtqueue *_vq,
>  				    struct page *page,
>  				    unsigned long offset,
> -- 
> 2.56.0.307.g5fe7bd680c-goog


