Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF82606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=b7pFSSAx
Received: by kanga.kvack.org (Postfix)
	id 7E6516B067F; Thu, 19 Nov 2026 10:13:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797FE6B0681; Thu, 19 Nov 2026 10:13:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683956B067F; Thu, 19 Nov 2026 10:13:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3AC6B067F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:13:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92F90A89E1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:13:14 +0000 (UTC)
X-FDA: 85452211908.06.A8C7694
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 320104000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:13:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b7pFSSAx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795101192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
	b=axoY1FCIc1SAl76I1jQ2BNS8w4CsDvYmvFUtSXM0SY2/4nJg9ZWu+n70n8QF6KDBXNILK6
	a+fyfKWej3chpJWWTBo1betKzkqzeEweVv3EhSWD4nt6n044ZJpdppuDQSr5UbN481TRH6
	GuYPEUP+F+olQNC5Wy5QHjniY+9wyws=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b7pFSSAx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795101192;
	b=GSUH80MWR3PMCQ0e/qQD+vEEN4nrJX/iz4r8gBXljHFUWsHJv3EkDvm8izNCJCQrEZfbki
	n6SERuvliKGej9LA+xQDuvGrOoXYTqeKJGrmOY1m/eT/ES6wb2PMHZgEjmRasEa4wJ3qvS
	Q4finkfz43vRkBcNvVcisVSoS65pmSI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795101191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
	b=b7pFSSAxI+E9EaZtsEfbolehGk2Tu+XE3olI4Vs/ypKruP6HT5txdO/AAW6Kw6DOBoGuQD
	KjM+SJ9zqBvEX0Tf2YD1b2Ppz8GrMZzCjINvDF5x6gQW6ncfqjiD7zXGFlsYZrAVw3vo4j
	GJuplVbUUZPlYyzsJRv6NkbPDFHGjvI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-YVlH4leNOU6AEk_fJ006_A-1; Thu, 19 Nov 2026 10:13:08 -0500
X-MC-Unique: YVlH4leNOU6AEk_fJ006_A-1
X-Mimecast-MFC-AGG-ID: YVlH4leNOU6AEk_fJ006_A_1795101186
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a35db2d6b3so17129555e9.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:13:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795101186; x=1795705986;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aUaUnGVOD0AnB0qQi2tHlDtmvMhT+a6tdGKKo0EDxDI=;
        b=FApV9vWgUuPyLmAjcVOsEmy/abpWt7N2/jPnDoMFckZFrVFU1ELebIsWQOlTckw0WX
         bcruOz2uC+9/dKdop87J2OlT0IuL0j46qChaTX3260t17SMhq8ovrwm7TUHaZstE3Ign
         BTsd5AHnB3zrFmv7+yAUC81b1cpvuEL5xboJMEjqjHmbexELrOley4jVEokiF1DBJwmL
         GIRvyBSsL0EwSqjhhxo03AJLU8A5M1paSQV1TpalctXncmLqP8gfBeOgRvrSbHgSajZJ
         LTw8w1batm1XkCOfGVmIZ6K++45DV7U7a2LaQ6jllMmXf95j4CXhq123/VtiZJx7Kzku
         1vAg==
X-Forwarded-Encrypted: i=1; AL+hErHuAad/8DcItbJbJr51bw2kMP28bNv61tcmzB52Q8uiI1v9xp8ZQEZmd04ydyC/vZ7fpbwDowUKxg==@kvack.org
X-Gm-Message-State: APuU4Z9xRyvQ7fQh1Y6dIDHXY737wku9QZ+CzblCGBhp4+ZUb/iLK+MU
	BQZlAhSko224V+sF03mEbAXWiRQfvGrzExxQLxlBUob9qO2mDVGwcIAeFY+4S4H4xFPf9yAkVjS
	UmR+Zegej41fAdOY3tD2HkRPlUjFp1PA06JzakoPul2kKQleF7nhS
X-Gm-Gg: AYBFou1hz5wEqZOn3CAnt8i9Q//iKbyHSLH9hUXeojdsF52zkku6KVm5zZIm9Np+YEG
	h6syCUz2gg5SxyH+Cn9c5HKjLcEQdLDfjuikHy7pa2RC2Xg12GPZFARz2v/hCdaQkwP8ImVEWYR
	ZgMEfZQiRbffVeXQgmKKTFrg6mv1f1HWF4L6ry5AtGvVBgT6Z0Sn7+14cldSMa3S5wMj09g5IXk
	b3JJEsjQVzH+w8+X/PFFdB+GHtJuhPheXCswTatXwtBAthDWMlwZOR2YOvDa7NIQGDN+fDUZCJH
	8Dx9jhowa9Vmf7tsg1I3iWXcihwuUy9Bj3k2dzqLaN3Nbp/zycEvulY3sf0555DzNt96nPoZGGx
	v0l904cplD/xqrG3oPlV8tfeywyZCDtqWvmuzmZfSDg==
X-Received: by 2002:a05:600c:3107:b0:4ba:eb:eb9b with SMTP id 5b1f17b1804b1-4bb7da1272cmr124141865e9.8.1795101185749;
        Thu, 19 Nov 2026 07:13:05 -0800 (PST)
X-Received: by 2002:a05:600c:3107:b0:4ba:eb:eb9b with SMTP id 5b1f17b1804b1-4bb7da1272cmr124141275e9.8.1795101185168;
        Thu, 19 Nov 2026 07:13:05 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1522:6500:ac93:c62:f076:48c6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884a3a3dsm3221365e9.10.2026.11.19.07.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:13:04 -0800 (PST)
Date: Thu, 19 Nov 2026 10:12:58 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
	jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk,
	linux-mm@kvack.org, James.Bottomley@hansenpartnership.com,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	phasta@kernel.org, joro@8bytes.org, will@kernel.org,
	linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
	tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
	cuitao@kylinos.cn
Subject: Re: [PATCH 3/7] vhost: account the per-device kernel allocations to
 memcg
Message-ID: <20261119101239-mutt-send-email-mst@kernel.org>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-4-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261106131829.3228926-4-cui.tao@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EfJyPfJTQ3EIZm9rsxUbbVY3tw5fV8jjvMxHrAo3Iwc_1795101186
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 320104000B
X-Stat-Signature: h7zi3fwcb9qc7357u58aex3g4ppxmjpm
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795101192-535516
X-HE-Meta: U2FsdGVkX19Lq1Jb5Bn+7MuFH/HSKHYZNIkyftg//pruLvHZWYaP4Iu3NjuIMSc0/U5I8uJM2mUsxouLCVpzEBwTUnPkVm27HfJTV111Awk2w4/BAh2KJHbiQzAofTNmXB03hIbTStO3PZEB18OP+kuEcLlypuf6PmIELIzlMISBpGV/8IY/MSxQbuYbUsHSMc2HCbcl7Wn9LFF6e1n7THFiCREinW3nCi/zIN07dtpCnRj10bLP9IH7rywcRMVPiuzrEZYHhDIXSoxk4SPgJc3EzOEG/92uLLGZr8cr9OHTV6+RXhweutACqYyqU3/VNdc5w81xvaky+/O5VsplvspuDNUxkSkAHu6EqHN8o3G++A4GIgCZm1PE5IX6nTEvNr/V0DxDzmtv03JBoY09CXW8cfDd2t6/fqjS1U5hvjVE5uJoPhGXQFIADUIFvSM5mYPHwMqqC28px3ttOKWuwihLaNxUo4RdxXxeTksqhrdSmbMnGzB7Rv6MmFQiAQ7mp0AuCd5VtI+zT5+WyaqqePQb9L1UdjMI6/p4gNy5wOtAyS2itywiata6d6CIKXXBEeg32S8k3aL74ltZ9d5pMg8CyXM9pTw0v7d2OjFLcyzD9KqBWYn1OM9zt1rF4f4bYzr4CvC1UA2H+taKYDBDutUXOh4QJcEC+ZrRMmwDGFwmR//pOwV8GG30hjfo/0Af9dmHgxea9LYrUDEvDJzSMYG8Xmaso5myUT6p3Dbc2zjM7VaJN7PbkVVrr638A+0AZpg80Ct6GZBQNvHQBNQBYtaJUTrU7Tp7ZYXUEvBgMZlDP8gnwKM+DC2fXqbWVTt4pZ3aXLAPSceYlP7H9W7TTukYeab/mGzwsjzZpmrK30kyuHRmrlXMOJsNdtgdYIB1iwIisKPPjBwoEYm3lxQc36+PH8fxr8pCtZb9g1Q4I+1oFFI3jbZ2gNXZd2LKzL8xcwDvbOfXzBygzWIGcFe
 SF+p1gZX
 tqGmPFQX8gvQSAQxf0urRCnRqvXQcVoVtNpMsNXg0voAqoPX6TSWw2K39qEtvHaYDUjG2QPFtYQQzJWlmQ5IHh48ROtpE/tH6sp7eOfQFIAoUBscPMTrw6tTlemy4+WxVSMFZB+vumelCkm6UE0TgJWX8vSpJPE435d0dbw6QuXCr6qI1RY6nar/AlhFWSkCUQmsMHtlQxmjggnVfoh8v+AiKS0+1eY2IM430nhEpD4gL9AnHFqpO5yiKRSBLgGsoGAF+hUONSUCvIXAwjWmsUt6Cnr1RLTGlj6U1XZVm/zTwGPr7A8sMcJMS+oSK7O4YgPk9m7xvaXnog7PmZRuVLoCmdtxMawjhLWn+w/aDRsWuZmknKyGpeNeC1crcME8rulJMlTLiBVvOwYys+nzKpeyl0NwfSOHvdePaX/Jn+qbjxizWH8qXx4BJqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:18:25PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Everything except the worker struct is allocated with plain GFP_KERNEL:
> the per-vq iovec and log arrays at VHOST_SET_OWNER, the memory table at
> VHOST_SET_MEM_TABLE whose size follows the user supplied region count,
> the pending message nodes, and the vhost_net/vhost_vsock device structs
> with their fallback to vmalloc.  The worker has been accounted since the
> vhost_task conversion.
> 
> A container that can open /dev/vhost-net or /dev/vhost-vsock, which
> device plugins hand out with passthrough, holds roughly 150KB of
> resident kernel memory per device after SET_OWNER.  Charge the rest the
> same way the worker already is.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

should each patch be merged individually?


> ---
>  drivers/vhost/net.c   | 14 ++++++++------
>  drivers/vhost/vhost.c | 16 ++++++++++------
>  drivers/vhost/vsock.c |  5 +++--
>  3 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 4570a4ffbab2..bab6597c696d 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -249,7 +249,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  	/* No zero copy backend? Nothing to count. */
>  	if (!zcopy)
>  		return NULL;
> -	ubufs = kmalloc_obj(*ubufs);
> +	ubufs = kmalloc_obj(*ubufs, GFP_KERNEL_ACCOUNT);
>  	if (!ubufs)
>  		return ERR_PTR(-ENOMEM);
>  	atomic_set(&ubufs->refcount, 1);
> @@ -302,7 +302,8 @@ static int vhost_net_set_ubuf_info(struct vhost_net *n)
>  		if (!zcopy)
>  			continue;
>  		n->vqs[i].ubuf_info =
> -			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV);
> +			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV,
> +				     GFP_KERNEL_ACCOUNT);
>  		if  (!n->vqs[i].ubuf_info)
>  			goto err;
>  	}
> @@ -1344,17 +1345,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  	struct xdp_buff *xdp;
>  	int i;
>  
> -	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
> +			 __GFP_ACCOUNT);
>  	if (!n)
>  		return -ENOMEM;
> -	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX);
> +	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX, GFP_KERNEL_ACCOUNT);
>  	if (!vqs) {
>  		kvfree(n);
>  		return -ENOMEM;
>  	}
>  
>  	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
> -			      GFP_KERNEL);
> +			      GFP_KERNEL_ACCOUNT);
>  	if (!queue) {
>  		kfree(vqs);
>  		kvfree(n);
> @@ -1362,7 +1364,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  	}
>  	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
>  
> -	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH);
> +	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH, GFP_KERNEL_ACCOUNT);
>  	if (!xdp) {
>  		kfree(vqs);
>  		kvfree(n);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index ea127af58ada..d1274106ad5d 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -526,11 +526,14 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
> -		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV);
> -		vq->log = kmalloc_objs(*vq->log, dev->iov_limit);
> -		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit);
> +		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV,
> +					    GFP_KERNEL_ACCOUNT);
> +		vq->log = kmalloc_objs(*vq->log, dev->iov_limit,
> +				       GFP_KERNEL_ACCOUNT);
> +		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit,
> +					 GFP_KERNEL_ACCOUNT);
>  		vq->nheads = kmalloc_array(dev->iov_limit, sizeof(*vq->nheads),
> -					   GFP_KERNEL);
> +					   GFP_KERNEL_ACCOUNT);
>  		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
>  			goto err_nomem;
>  	}
> @@ -2053,7 +2056,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>  		return -E2BIG;
>  	if (max_iotlb_entries <= 0)
>  		return -EINVAL;
> -	newmem = kvzalloc_flex(*newmem, regions, mem.nregions);
> +	newmem = kvzalloc_flex(*newmem, regions, mem.nregions,
> +			       GFP_KERNEL_ACCOUNT);
>  	if (!newmem)
>  		return -ENOMEM;
>  
> @@ -3405,7 +3409,7 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
>  struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
>  {
>  	/* Make sure all padding within the structure is initialized. */
> -	struct vhost_msg_node *node = kzalloc_obj(*node);
> +	struct vhost_msg_node *node = kzalloc_obj(*node, GFP_KERNEL_ACCOUNT);
>  	if (!node)
>  		return NULL;
>  
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 0cb87971d749..600daeb05e7b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -721,11 +721,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>  	/* This struct is large and allocation could fail, fall back to vmalloc
>  	 * if there is no other way.
>  	 */
> -	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
> +			     __GFP_ACCOUNT);
>  	if (!vsock)
>  		return -ENOMEM;
>  
> -	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs));
> +	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs), GFP_KERNEL_ACCOUNT);
>  	if (!vqs) {
>  		ret = -ENOMEM;
>  		goto out;
> -- 
> 2.43.0


