Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0674F483DE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5267A6B0005; Mon, 23 Mar 2026 13:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE3D6B0088; Mon, 23 Mar 2026 13:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C3F6B008A; Mon, 23 Mar 2026 13:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33A2B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:53:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 073195C9A9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:53:26 +0000 (UTC)
X-FDA: 84578074812.23.39A4303
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D9C420004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:53:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bV7mxTWB;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reWwq5ua+u6vmCZuUTKVBM0ZLloWVsOJt7na7m30eIU=;
	b=gHFHtMQlX+8Zfp9DhdGiGOO1oO4DM2I9NtNs15MKst5O1nMfgPsMpMDGcQz0+BNkkh2j4G
	jNUwSRZF1Qj0f8l/h46uTRrzgCxZAaKN1+BCft02ExsG+Ql3XACaBme+hMDgTJU6JQ2Ze+
	Ug046Ws8d/lgVUTJWtHaYkeYl2y16cg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bV7mxTWB;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288404; a=rsa-sha256;
	cv=none;
	b=ELfDA4Y0IsuxnRgmVApVB4odPdmi7mPYPHbOzba4EY4kmVrh1abN7oc1/Z6O/4T6CowxPo
	CuetgrOtF2ZpY3B3s1sWFIMuo1JVhS9hjvoEFH2tXnbMK1alkkQBS1KhuGiWo33yjajXXu
	Ns4s4wDxQVucRYcETM14DkK3WYqQKdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A97444486;
	Mon, 23 Mar 2026 17:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC77C2BCB0;
	Mon, 23 Mar 2026 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774288403;
	bh=AE6bvPRBuu/wn9CJ9Bc0lzK1gYt9cBL0a+aIcWO4eCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bV7mxTWBukFmR5V1TfAE3U4PHdCw+B18jcmZLFiYDg7lovpoVi6W/EcoLDOyawoWb
	 c0G+I1soK0HNQ46qHJ+Kjhzxtr3DmCXIVcBDdGHe7lZgMwdP8lE4dOiU+1frxh5Oxk
	 tg1wgR+cFyGJUFixQBX2maEdDM0hOlThkIbVZFptqw91KGyr/5gFVsKpksHc8l7FYm
	 Zch52RON9+hDZ0Z7iCImIZ9bbmdEUsIctlSMiYO8s9e9QpKd6up+CSD0A/rQcEGzcG
	 /9mMQ/b/RZUqQx95MmexN/E+miQtL0jHPA0oXOyJeIypJzez/ho+OREMjiHEL+dFS5
	 JqIYFBD77kcJQ==
Date: Mon, 23 Mar 2026 17:53:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 3/4] KVM: s390: avoid kvm_s390_handle_pv() error
 overwrite
Message-ID: <fb38ecc9-36f8-49a1-bf20-a2c03244e574@lucifer.local>
References: <20260322054309.898214-1-surenb@google.com>
 <20260322054309.898214-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322054309.898214-4-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D9C420004
X-Stat-Signature: 7f3bos9zs66a917ub1kfkk5xnbr8431j
X-Rspamd-Server: rspam06
X-HE-Tag: 1774288404-260754
X-HE-Meta: U2FsdGVkX1/NbVNRu+eX5xe+8UdpC+tViA4TSNrI21O/pxcDWIbTOTVeuRCp36FatK6yH7Bn8TzExcLOnkxml+Z58nHprj8lYbLwF/lJtQOv4BhUWwgg7/Rq3YAeRc7VCWxfeGhHOtCUaJ0ZXVfpL3FkI3/7Y/v+W15kmofVuD6r0Ka/KNzdYC8I7DPOJan0l0hQChOHQsvCzgoWudjh1iURj6asnrRgOPfoRJxhQ9OrdAajUdYS7tEtodWbe0guqQ34POLYjbk74Csfbc39wPm8sJyuZD8KZKlDRmxMarYtbpe0l5Z6y2IcfMXc9W1UhSobhXWHq3YoiLVxS0P9/63kFbHt+AS+YHmWv5Ux/vLf+MCtOTpQfOlWMbEqNDeG2rnLcQGxemQdDwYaoa4U5YKSnSVnrvSDjP74oSJ/6TRAwLHVnTfoPT1XuyJEeI4vcF5U6paviPLC/WKVCOv2m/drodzZ8vuUNi2OwCaUPH97ysWCgYiuklvEjt2/JW7M3vT4LBGgFbPoeB/uastCFp7voElz8X09FTxYy/4xB6y2k8GjFz8J/To6Z0NItufO8XEN68DnAQVROESGiv79B+k3xYYLMbdg/g/UVC1wPjGA7dzBca66MGLY5EqX0FL8CiW1vIrZtJnuatowLVSoaJGjYsL/C2c6nqk9KOyEKYAqj2xgErSrbtIzHI6N14Tc/zDIDo35GoUfNr7XdBHG0q4Az8SheKM1K/lcQd+RtKUAGEk8D/rmHRGR6yigDAptqOa5o5kTTKfOQQJfytJEvN+gnO+QGPDyJyngSpGhgea+A5q2rVaw7Zl7vI6UcqLaMpP3TdrHMv+/MxcrIUtpkREGX5llF/DeU0rkTY4QLyxyRXXuXfEYzsJe26DdIHkLnTVEVh016Kk1Rc8EwuMA6jUFUlYtd0Nx4oncVm775Bv2TsO7hQj2C9DBZ+rqhE60FlUdMYIfiTXy2j+xRlo
 s6CkvPbz
 H5CHAbNBRRXLwHSogszDz3bNG0v0NUukCe4kLpXADmeUL3c2LMxoBer6mpoGwMBOmQojp78Dwe74RccXckzA9d5Cqnl55niLVNG7RRtLLV0YMhOtvwoAKr9ozGnYuYQmNgQ0B1lFoL63nsvl/1o5RXR4RjOlI0py4fvc3v1PSs13MZs63w8GulT3h0FhLuWjrn3XBCjh4+2UDK+Y3UKH9KVvfxKG61x+HlcQkP8rcS7kzf9PNmZF7YB6RvFpUUZyez+p3JUt7wACKHFogxBlhg/1jld68fu1rF9GYepVagiY4H3VCgorRLJBXKwqXA+ZvftSBhSpTHB3nyHAWoXIjwzBTN/I2kV9P6Ww5X7g3DU+GZbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 10:43:07PM -0700, Suren Baghdasaryan wrote:
> If kvm_s390_handle_pv() call fails its error code gets recorded but
> execution proceeds as if the call was successful. If the next call to
> copy_to_user() fails then the original error is overwritten.

Is that really a big deal though, as you're returning an error in either case?

> The follow-up patch adds fatal signal checks during VMA walk, which
> makes it possible for kvm_s390_handle_pv() to return EINTR error.
> Without this fix any error including EINTR can be overwritten and
> original error will be lost.
>
> Change error handling for kvm_s390_handle_pv() to alter normal flow
> once failure happens. This is consistent with how kvm_arch_vm_ioctl
> handles errors for other ioctl commands.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 3eb60aa932ec..ddad08c0926f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2947,6 +2947,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		}
>  		/* must be called without kvm->lock */
>  		r = kvm_s390_handle_pv(kvm, &args);
> +		if (r)
> +			break;
>  		if (copy_to_user(argp, &args, sizeof(args))) {

Yeah as per Sashiko we probably need to copy_to_user() still.

But in that case, do we even need a change at all? I'm not sure it really
matters which error code terminates things does it?

>  			r = -EFAULT;
>  			break;
> --
> 2.53.0.1018.g2bb0e51243-goog
>

Thanks, Lorenzo

