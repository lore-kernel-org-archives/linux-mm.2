Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6B9606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q70IX0lu
Received: by kanga.kvack.org (Postfix)
	id 920676B064D; Thu, 19 Nov 2026 18:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D11F6B06AE; Thu, 19 Nov 2026 18:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A526B06F0; Thu, 19 Nov 2026 18:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE476B064D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:54:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2757A878C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:54:19 +0000 (UTC)
X-FDA: 85453525038.07.D13EAA2
Received: from mta0.migadu.com (out-217.mta0.migadu.com [91.218.175.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id 009034000E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:54:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q70IX0lu;
	spf=pass (imf27.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795132458;
	b=6cS8KUnfCbf2O13pI/JUA/UxhXST9OfW3yasvH9T+GGblgUHdbbhTlOQxq+IBlNiK0vkmN
	bkZc6u1rwO6gjyKGJDSux06t1yiwLMzWB173PH3t1a9gCnL56TIhVhSJ97Fxpd5YBJ2PmU
	InlTDYjt0kN19AFz4g+lKqytdmibdxU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795132458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8Jkl3D6PyKBQ9flRwdsQA2PhUfjW1xzSb0OsieXFqU=;
	b=Q23wX4vktyewZDUSVNaNZ5eEORFvOu9QkJD/cjEcbz46YRfUOYCDSPc0GIY50euBlYt+s8
	IYUK0VmHSjE0s9fehQh67GHUogzPJ898lrRYym1Gwwqhq7LFnKPsI+qahjx9fstXZPJDIh
	GBVj6uiLBebzXmO/jG7o0U8LRxmagDg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q70IX0lu;
	spf=pass (imf27.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SVZrlJks8sXPVt3xrpYdTAoVZmdk9CSrl7P148bcFmU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795132454; v=1; x=1795737254;
 b=q70IX0luUcbU6FCiJYBpmUfdNrXaCDzDyverVa5nohERhVo++3RcTQWOyKaGqDjVgz3oc5Fx
 VBY96WxGxsdaNk3gHTfIfp6AF/YK/SO2tPRF0sI/OQFkm0I4B33qwJ5F3URCKw0ij+tnYR3yJa0
 Gw0mzX4e9eiXeXHZeFdigyFI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eca0a2cac3c52e86;
	Thu, 19 Nov 2026 23:54:14 +0000
X-Mizu-Trace-ID: eca0a2cac3c52e86
X-Migadu-Flow: FLOW_OUT
Message-ID: <1ea66d73-4d40-4d95-855f-4235cbd1d809@linux.dev>
Date: Fri, 20 Nov 2026 07:53:53 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, akpm@linux-foundation.org, dgilbert@interlog.com,
 mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
 vivek.kasireddy@intel.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
 James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
 mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org,
 aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
 cuitao@kylinos.cn
Subject: Re: [PATCH 3/7] vhost: account the per-device kernel allocations to
 memcg
To: "Michael S. Tsirkin" <mst@redhat.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-4-cui.tao@linux.dev>
 <20261119101239-mutt-send-email-mst@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261119101239-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 009034000E
X-Rspam-User:
X-Stat-Signature: 7gfbsmmxcq49ycyo1mzsh6swcz5rdxw4
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795132455-92781
X-HE-Meta: U2FsdGVkX1+cqdFTexU+r0aiM5wC8SYbKjWu5C2h2k8SWWQbjDbtIbXb4SRwfspiIlSsF9aDD0M2xn/ViG2UyFML9rR1fsGv5VIS8eo7IT1Woohmo0Eu/jKFgxDvlsYhCqjtPfb0ymSfr5mIy6FoIcwki0WUuQ3ZPM3WKrvZI4ZbboCJRzjylcWWpf0Z9E/6DcdikWAzqFBRo7VdI2yr1PKsEbTk8NU2mQfkGUzRDjWfBwe31uhaf1HmmQtgLn308mVXCv9rvew7gj1myGGKOWeeWnq0DDrLG2IjpwsYrpZL7nJRTy1xQGUuDts8sE/SK8AnlupA2M+Sf3l1Kv4cDD5t67B2HUMsFkr5W8wDft7rFuVfDxhcczi3fvu+VWtC2Kr65hDHAQxhhiQYFCkrMy2nvSufZi3jrpFPzfZNeL8ZB3Lmb1dV3GWxU2arj5KuMhE1n/s/krhKhaVkDfAmqHpFAhX/motmnrdKq/b0S6P0y3rzX2Z65CTnqOCBMmXCZZwxa8fSL1UC4670ab9DBD92k6Y4e9N9De5idwf0LU+YtvHtYphr2iMXU+bdxjYd5zZY/Ym8FB7PKGDJeprrZUHaT5Lh/oD+yAfRO3bugiO7a9Hg8ahKcqsFmNhe6Ja1e6RHVIjjt8bbVkKcw9EOBxh2vsWA1inYKxz+lqhc1BTlxkwWxroo2HHuQK3iJQ5NFt2/1GJlIW3iGbvVQkYNeSXeBls/9T6txIwKr8tDbDA7O45SDNY+wGVT347hSU7cRqYTefpfBB73xxGnYnVg6/GLPnHnGOWTZLG3QigF3qb/KaBZlgZKQ3+sXSmfIklyyMsS5cqySX64m6KBTSRzKdqqffqb5Fap/u67RSELR1xd6EwY/XakDtQUr9PVOrd/1IZYlk5eyX/QwI0NIQOzZzpXed2jSgzJ0c6/nkPCCMLyWZZTdrWOADNJ8W+uipiKqCc407HqJaWsICsuOU3
 g/n4U6rv
 iHQQURn7vY6hrAAn7RGPyUB0gF35KgJH3YJccB28a36uzdnoPkg+wo4iJJ2g7WfYrBv06I+jnMQqTLW6s3LMNRCcABUU6VWJesq94VdLvcJxK7rVRFTiHhnc5CF0hHg5bwI0wbgnSZdQ7l6crW1xED1OrXo01VvMSHBmZBTXnJMubLel2QeRjaA/nQNVCFKsaMf8vb61mN6gXs2dbCgGTYy27w0b5ktB+4Lo2jbEvKx88WQLn7Lpo/09FALtlUhfb1kxkbC53dRjbTpAxY7d9QlFKRDNb2siViueqaz52k6kKfvGMLVWhdBOlF/Vk2s8wLmc6cRrf98LUqp9qDwWEaHKRoFfak8Roat2qFBYsJUXGn2egSylpnqwfjGForldYH+3RwMSQeZeHKQB00dq0iC1fLWw43oF0TYLwWWz+QCklOvrUg3zLWbbz2UvlNZk+QqkFj9q1ioQ2FyEsg1QLn4+LqiIyVdoCqHWVHg5Qoi+Nm94C562L+x1Zkpn/s1Yh+2Iy4mRkxCQywxYEttS/FJCyAvzFLD1OJw/9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Michael,

在 2026/11/19 23:12, Michael S. Tsirkin 写道:
> On Fri, Nov 06, 2026 at 09:18:25PM +0800, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> Everything except the worker struct is allocated with plain GFP_KERNEL:
>> the per-vq iovec and log arrays at VHOST_SET_OWNER, the memory table at
>> VHOST_SET_MEM_TABLE whose size follows the user supplied region count,
>> the pending message nodes, and the vhost_net/vhost_vsock device structs
>> with their fallback to vmalloc.  The worker has been accounted since the
>> vhost_task conversion.
>>
>> A container that can open /dev/vhost-net or /dev/vhost-vsock, which
>> device plugins hand out with passthrough, holds roughly 150KB of
>> resident kernel memory per device after SET_OWNER.  Charge the rest the
>> same way the worker already is.
>>
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> should each patch be merged individually?
> 
Yes, I think merging them individually is the cleaner path here: the series spans six subsystems, and each maintainer taking their own piece keeps things simple. Jason has already taken patch 5 into iommufd.  Please feel free to take patch 3 through your tree.

Thanks,
Tao
> 
>> ---
>>  drivers/vhost/net.c   | 14 ++++++++------
>>  drivers/vhost/vhost.c | 16 ++++++++++------
>>  drivers/vhost/vsock.c |  5 +++--
>>  3 files changed, 21 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index 4570a4ffbab2..bab6597c696d 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -249,7 +249,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>>  	/* No zero copy backend? Nothing to count. */
>>  	if (!zcopy)
>>  		return NULL;
>> -	ubufs = kmalloc_obj(*ubufs);
>> +	ubufs = kmalloc_obj(*ubufs, GFP_KERNEL_ACCOUNT);
>>  	if (!ubufs)
>>  		return ERR_PTR(-ENOMEM);
>>  	atomic_set(&ubufs->refcount, 1);
>> @@ -302,7 +302,8 @@ static int vhost_net_set_ubuf_info(struct vhost_net *n)
>>  		if (!zcopy)
>>  			continue;
>>  		n->vqs[i].ubuf_info =
>> -			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV);
>> +			kmalloc_objs(*n->vqs[i].ubuf_info, UIO_MAXIOV,
>> +				     GFP_KERNEL_ACCOUNT);
>>  		if  (!n->vqs[i].ubuf_info)
>>  			goto err;
>>  	}
>> @@ -1344,17 +1345,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>>  	struct xdp_buff *xdp;
>>  	int i;
>>  
>> -	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>> +	n = kvmalloc_obj(*n, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
>> +			 __GFP_ACCOUNT);
>>  	if (!n)
>>  		return -ENOMEM;
>> -	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX);
>> +	vqs = kmalloc_objs(*vqs, VHOST_NET_VQ_MAX, GFP_KERNEL_ACCOUNT);
>>  	if (!vqs) {
>>  		kvfree(n);
>>  		return -ENOMEM;
>>  	}
>>  
>>  	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
>> -			      GFP_KERNEL);
>> +			      GFP_KERNEL_ACCOUNT);
>>  	if (!queue) {
>>  		kfree(vqs);
>>  		kvfree(n);
>> @@ -1362,7 +1364,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>>  	}
>>  	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
>>  
>> -	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH);
>> +	xdp = kmalloc_objs(*xdp, VHOST_NET_BATCH, GFP_KERNEL_ACCOUNT);
>>  	if (!xdp) {
>>  		kfree(vqs);
>>  		kvfree(n);
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index ea127af58ada..d1274106ad5d 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -526,11 +526,14 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>>  
>>  	for (i = 0; i < dev->nvqs; ++i) {
>>  		vq = dev->vqs[i];
>> -		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV);
>> -		vq->log = kmalloc_objs(*vq->log, dev->iov_limit);
>> -		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit);
>> +		vq->indirect = kmalloc_objs(*vq->indirect, UIO_MAXIOV,
>> +					    GFP_KERNEL_ACCOUNT);
>> +		vq->log = kmalloc_objs(*vq->log, dev->iov_limit,
>> +				       GFP_KERNEL_ACCOUNT);
>> +		vq->heads = kmalloc_objs(*vq->heads, dev->iov_limit,
>> +					 GFP_KERNEL_ACCOUNT);
>>  		vq->nheads = kmalloc_array(dev->iov_limit, sizeof(*vq->nheads),
>> -					   GFP_KERNEL);
>> +					   GFP_KERNEL_ACCOUNT);
>>  		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
>>  			goto err_nomem;
>>  	}
>> @@ -2053,7 +2056,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>>  		return -E2BIG;
>>  	if (max_iotlb_entries <= 0)
>>  		return -EINVAL;
>> -	newmem = kvzalloc_flex(*newmem, regions, mem.nregions);
>> +	newmem = kvzalloc_flex(*newmem, regions, mem.nregions,
>> +			       GFP_KERNEL_ACCOUNT);
>>  	if (!newmem)
>>  		return -ENOMEM;
>>  
>> @@ -3405,7 +3409,7 @@ EXPORT_SYMBOL_GPL(vhost_disable_notify);
>>  struct vhost_msg_node *vhost_new_msg(struct vhost_virtqueue *vq, int type)
>>  {
>>  	/* Make sure all padding within the structure is initialized. */
>> -	struct vhost_msg_node *node = kzalloc_obj(*node);
>> +	struct vhost_msg_node *node = kzalloc_obj(*node, GFP_KERNEL_ACCOUNT);
>>  	if (!node)
>>  		return NULL;
>>  
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 0cb87971d749..600daeb05e7b 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -721,11 +721,12 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>>  	/* This struct is large and allocation could fail, fall back to vmalloc
>>  	 * if there is no other way.
>>  	 */
>> -	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>> +	vsock = kvmalloc_obj(*vsock, GFP_KERNEL | __GFP_RETRY_MAYFAIL |
>> +			     __GFP_ACCOUNT);
>>  	if (!vsock)
>>  		return -ENOMEM;
>>  
>> -	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs));
>> +	vqs = kmalloc_objs(*vqs, ARRAY_SIZE(vsock->vqs), GFP_KERNEL_ACCOUNT);
>>  	if (!vqs) {
>>  		ret = -ENOMEM;
>>  		goto out;
>> -- 
>> 2.43.0
> 


