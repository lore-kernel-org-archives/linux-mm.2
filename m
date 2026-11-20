Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C77606A716
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 20:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=AIlfUdj1
Received: by kanga.kvack.org (Postfix)
	id 3A88E6B00EF; Fri, 20 Nov 2026 15:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359116B05B0; Fri, 20 Nov 2026 15:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248E66B05B1; Fri, 20 Nov 2026 15:47:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9B316B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:47:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 612D014012D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:47:11 +0000 (UTC)
X-FDA: 85456682262.13.971A87E
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F1121C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:47:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=AIlfUdj1;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=9784609d09=bobbyeshleman@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9784609d09=bobbyeshleman@meta.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795207629;
	b=4gy0jiZ/gC05bb40/mxte1SzAFsZfk3AcmEDcvrrAKogBZnirMNwXkwvWL5O68p8gi2Wh1
	/jeelHIPW66o+MkpLIiVkv6FP0l2eWk3xtco6kf7nDfBtbK3L+43tPud0OTLKtELGeCmA/
	NN7n/qzM4YzMQvHvq1gIz+4pCYuS+58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795207629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVEZdfrqnWoREnyQLPgTpyCdDOhNLBO5hd1CUBjj4Qg=;
	b=7TJYmZZZq2v2k9rvpro3Vwd+E9bjCjV61StzZX/uKDmI3UTLyzcSptE8jjJ60GXPecQXFc
	WC1Y9q11kW9oebSUoyMButO+iz2OM6+YU+uw/lItfbTPSRFutyrsIobjhkZbx4r6lgOrF8
	n7NhiozuonQdfgJlq49LFEdlevdVr2s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=AIlfUdj1;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=9784609d09=bobbyeshleman@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9784609d09=bobbyeshleman@meta.com"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKHA4km1877707;
	Fri, 20 Nov 2026 12:47:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=yVEZdfrqnWo
	REnyQLPgTpyCdDOhNLBO5hd1CUBjj4Qg=; b=AIlfUdj1UWpwHAKlNe10VDFmUMi
	rgn3PmdUOrYQqUaOe3M5TrEW5FxLSPZeIw7XHmGEZaKY4zS1m9UsBes6uxfpGhDK
	Zy12zzS1umyDlAYRUseJSRtMNklW3Gob6oFwDSFckoqiS7wo1hBG5WnY1fTYcmxv
	lIN2NIAAKqV5FFzu9LwXfx0L3kzvWjPKF9qU7NsTE79CzCkhpjOVOYqXvcuyQcm6
	8goQ+fHF/F2k2gb7nAAki1tZowd4kGOqFAcQupo3nJngCuTo5tdAHrHIsfa5PKQ+
	83nLgwPR8TsmkxRHbPkCtUrEFd8dOB43VpIO3IlbhHp6UBperhRO7KmksOw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j2tc41pjv-18
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 20 Nov 2026 12:47:07 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 20 Nov
 2026 20:47:07 +0000
Date: Fri, 20 Nov 2026 12:47:06 -0800
From: Bobby Eshleman <bobbyeshleman@meta.com>
To: Tao Cui <cui.tao@linux.dev>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Stefan Hajnoczi
	<stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey
 Drobyshev <andrey.drobyshev@virtuozzo.com>,
        <virtualization@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] vhost: account the per-device kernel allocations to
 memcg
Message-ID: <awCxyqE/9iSYBjZF@devvm29614.prn0.facebook.com>
References: <20261120054517.526275-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261120054517.526275-1-cui.tao@linux.dev>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA4MiBTYWx0ZWRfX4xJSOFOxWakw
 f0+6TcEAk+PtYtOm+LJafn/EIiSWnGMpUHlq7Ynou6Qm90/9/nkMRLNtF1Zmgre7RHXF+3L//9N
 YhQnGqBqFtrXFo3jCpCd6EVEsGN1PQ4=
X-Proofpoint-ORIG-GUID: sbvE7vr0sW5nObX-GRT6i78cDrRadJ8W
X-Authority-Analysis: v=2.4 cv=PuMG/AM3 c=1 sm=1 tr=0 ts=6b00b1cb cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=JnKecZnUtZousrUlYMGU:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VabnemYjAAAA:8 a=je9U-9MI8qmF_auVsecA:9 a=CjuIK1q_8ugA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: sbvE7vr0sW5nObX-GRT6i78cDrRadJ8W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA4MiBTYWx0ZWRfX3tINTm8axShi
 +1eTy2E3e4veKEtl8JzihHLuiMVfs8cD04Qb/vCI2OV4fPa1paI1r6hBZXt0H6fzsTeA4wNZYXJ
 0vnhQ4GlMyBFODqEUBLvkuXvi1EJRj5YRHhHhK+kIXNf4kz5D3TfslknX/USx/elFeQkijcNy4L
 4OIyud5pc2ZAq+HUJMNCtkvgfsZQDlMYRfaKWwzQFjXKVys9VeXbjILL9zUpaslbCE74ZrSHaur
 ubsPYUTA/3O40T2Yk56omgcfBvVGD8iv1YuB52sctsySvWu4Y1I4Fhir7pyskat8pgamrYTPgHH
 CFUD+4zWTp3hRtNAvuIdeLEpBvL3HCoVwmRZDNdnsIZeY8364z81gBF8gDX5G0iSZENSgJrIVdp
 B7SqnYav3WXOJl43gTaDF2uqo7/if+3RKrgpqj5NYKc27JK+r+Qo0c0k1SKu/PpNicS2a4KGy7l
 R+Hq812rDBCQ3OU3m6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Stat-Signature: c45hxeqpq4y83t143z5adxbi1rbsaw1a
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F1121C0004
X-HE-Tag: 1795207629-829257
X-HE-Meta: U2FsdGVkX19yuxYS48RD9MYf/ouegZuq6tVXsSPWbgHbIfIfxYN86+TiDnaTC7bTwYoQoPkDnKvjHpJcnNejjaeRG0hs55LES8Ggt7tTc4UT+FxcCnqw4BxGT1mED1w1Jy/Uq1sdwkygYXndsTqo2FHEdPH/EIuF/Hm8WZElQapFIVWQaCEGFTleP7djSEwsaAMa9ZWczuutWP/uYkYR9hgkBEzLThIbIUh8sGVEZMMNekK62lYARWclyGHOzFClnrVG9KRLYQyRj1gRVSpjD1xhA8R9OVAkCf89iXydxg9+pgTJK9erDLV1egIQLzaxRcmeAYJq/4+8AXy75iPvN6ND1E8DxSfRYCUucIFUDZ3KgZRheDYvlHjld3yPY6AeThjAM3GrOhqw7N68GEL6gkV386qnf5yvyRh82UbYfve+D3FYKp9f1a25TGsR7tY2UUqtElkY4Yk6RjWnnhOox9ErkxL55Jq6PGHsU4fvotCDks86pRACLY/VN7LLixuaa7WGuOQrI2d2ruMuEmlnGj4pwGKBbXzIG6W+nbJUEcl/yODcinzrsOdfj50FzDPXihQmz+Z0k3kYNQuQVw+i9/SOsFF2e4aiNdKmoUC/jlVTkZpiAFADwQRV1GBkBGr8d3aBl9ZI5TFwY+mveSi7kHJppUrC/iVy++TW30oM/bWz51xuUhsyH8rxxfgzrq2uX07iYecHKgoqDg0YBKgkyRq1dZr/+mgO+QRdWlSydoybMFrmndPG4iTe0cfpodGUm8ieY/Y6wm374QmaMPiaIcNzGa7TEYYskBNL9o2q+UqGWoN+ot9sRNTZhvUoP7UruoaOCANgBI3ZRKe3HqLzMS+sp5Jw+hze6H6+WyF2i+1l+OlMSkZmKvtT+TewlH+hEgHVymmnK38yLmS+fngkePdtzA+qTNYZ9hz4uX22IliaxUuuy6VrUfbS5YBsl5zz9Wmj0lfuJUDHZdagAWf
 puiaNe/z
 DEZRAosjJa539rhZfIR1wugHBJNpN7vjRR4WdQvqgCHGjA8CNy7DtyfbDeCRMQv24WlK/ttwXBJja/uaWBG9n0kSJn7tre9bm1lswxxVw0bKj78FZ19mxI4GegxDX2DIXGykCMP440XNgjHS+OR327gyEg9wcavLbSyU9fxrdoglFja363VlBE4xu9G+QiHt51/q+qFx0eZV9hM6MLj7lytSBX2uw7CAyeKgLuFxKqYkN+Ch9nE0TvI8xU8DfGJkRO6N3RAeC7Y0aZ67GG22VZQ6HaO1qDAuJ7sCoJT9a4IwZb3Zy0+h7Gd1o2AFkionfjPKqGm4s9AbmNuGBfOWhMfM9KR0uvZjZiVvrqPo2fPMrpp2zF/bUzABNHL7LgYGsd7EAOiCQnRQt3GG2eCuJ7rPTDisBjEZn53MJm18Kzosh/IDqhlqkI56Fdb/4sChOTjcYQwnMFTvgLbjaTQQi8/p3PI+90iuGYQn3bUOkrarWY7G6YBpV1QGToQd0ZxgkDPlRSFIyFjN0Ozueq5H5OYdfRXfWHxNe5C39iNnRRzx4DyqIvj+3qK/vz8n1i1DPo35hfFaml0gdVuGh2+dVYzXZo0y5NROmiRrKONrRU6uJTYiMDgytZ+11tS4wl+VKHYyCNjxXKhEYibacPuSdms4hGU6v006XWmFXyI5yIiWWywRyFxf9YKxIEPhgDlJ7dCdC4kkqFchqO2lTRASq8fOZgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:45:17PM +0800, Tao Cui wrote:
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
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
> Changes in v2:
> - rebased on next-20261118, where the vq->nheads allocation now uses
>   kmalloc_objs(); the flag addition follows the new form.  No
>   functional change.  Carries Michael's Acked-by from v1.
> Link to v1: https://lore.kernel.org/r/20261106131829.3228926-4-cui.tao@linux.dev
> 
>  drivers/vhost/net.c   | 14 ++++++++------
>  drivers/vhost/vhost.c | 17 +++++++++++------
>  drivers/vhost/vsock.c |  5 +++--
>  3 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 435d8ed3851f..390858056d20 100644
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
> @@ -1340,17 +1341,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
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
> @@ -1358,7 +1360,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  	}
>  	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
>  
> -	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH);
> +	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH, GFP_KERNEL_ACCOUNT);
>  	if (!xdp) {
>  		kfree(vqs);
>  		kvfree(n);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index dc973287567c..e8f9dce52aa7 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -526,10 +526,14 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>  
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
> -		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV);
> -		vq->log = kmalloc_objs(*vq->log, dev->iov_limit);
> -		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit);
> -		vq->nheads = kmalloc_objs(*vq->nheads, dev->iov_limit);
> +		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV,
> +					    GFP_KERNEL_ACCOUNT);
> +		vq->log = kmalloc_objs(*vq->log, dev->iov_limit,
> +				       GFP_KERNEL_ACCOUNT);
> +		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit,
> +					 GFP_KERNEL_ACCOUNT);
> +		vq->nheads = kmalloc_objs(*vq->nheads, dev->iov_limit,
> +					  GFP_KERNEL_ACCOUNT);
>  		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
>  			goto err_nomem;
>  	}
> @@ -2052,7 +2056,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>  		return -E2BIG;
>  	if (max_iotlb_entries <= 0)
>  		return -EINVAL;
> -	newmem = kvzalloc_flex(*newmem, regions, mem.nregions);
> +	newmem = kvzalloc_flex(*newmem, regions, mem.nregions,
> +			       GFP_KERNEL_ACCOUNT);
>  	if (!newmem)
>  		return -ENOMEM;
>  
> @@ -3407,7 +3412,7 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
>  struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
>  {
>  	/* Make sure all padding within the structure is initialized. */
> -	struct vhost_msg_node *node = kzalloc_obj(*node);
> +	struct vhost_msg_node *node = kzalloc_obj(*node, GFP_KERNEL_ACCOUNT);
>  	if (!node)
>  		return NULL;
>  
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 88a310390eb0..2fa205967f8a 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -719,11 +719,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
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
> 2.53.0
> 

The vsock bits look good to me!

Acked-by: Bobby Eshleman <bobbyeshleman@meta.com>

