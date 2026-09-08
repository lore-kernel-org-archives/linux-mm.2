Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910D1C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B2F6B008A; Tue,  8 Sep 2026 07:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71296B008C; Tue,  8 Sep 2026 07:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987076B009B; Tue,  8 Sep 2026 07:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 747F56B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:57:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13359A05E4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:14 +0000 (UTC)
X-FDA: 85190444388.07.EC18FEC
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3DA5FC000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bobrowski.net header.s=google header.b=MVdgFRcu;
	spf=pass (imf28.hostedemail.com: domain of matt@bobrowski.net designates 209.85.217.50 as permitted sender) smtp.mailfrom=matt@bobrowski.net;
	dmarc=pass (policy=none) header.from=bobrowski.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788868632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGzdGIl2437Zrr1mgAS/9CkFREf8A7GElbXp8vqEddU=;
	b=nlnFpxMFt8pd6/XzgKE1iZTp+JgdsA2RTeAXCyvd3J0zsCwQDdDOqwPpx4Mn4+j1sVqxKG
	aAGIP2s3KXC2cygmCLLETgHqtVjDBAMDAnS9Y546LLwkfUbMURr1tgaYqkLJEjfEdMHFWx
	d+/9ToVNQLB3BNHmV0tuNzj+yvoZWtU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bobrowski.net header.s=google header.b=MVdgFRcu;
	spf=pass (imf28.hostedemail.com: domain of matt@bobrowski.net designates 209.85.217.50 as permitted sender) smtp.mailfrom=matt@bobrowski.net;
	dmarc=pass (policy=none) header.from=bobrowski.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788868632;
	b=wgJCNuhXs2N0ELyvR/7e8IhqqSEdBVj5nSBAWFNvHpTm3IX9hMSSRXETOZ3wEex/3quAiz
	ZdbPIuVywFOktqpegbiZaYarEu/woZ0tXr8TuaXqI+XEQ1T7uUp62OIAxHeixTWWD2dEcv
	oAdsFf+TGaVW1VQ77tHT9MKx1K1JNz4=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-784980b88acso1423783137.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 04:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobrowski.net; s=google; t=1788868631; x=1789473431; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dGzdGIl2437Zrr1mgAS/9CkFREf8A7GElbXp8vqEddU=;
        b=MVdgFRcuyOUWqLwe7UAMlzNTCohKKokMKpY3VEE1G3OmDG4MuQMe+CqnuBqddVA0Yg
         OCSEf+IhNZ5A7tIbxf3C8p/FcZz/IAL4XQipTdyKpqb0HCbCWKfaYpdvY2PjklfwcoaY
         D7r/11ZqPIvx/cGaTfZZoUvZOGFvNQB04p/fcClhZ8j/orA2XvIa2cdsIv/3syA9FpbO
         uKNBmGOZFB4pXohhYW+PLe6eZofquL4vTyixFZ6sTAKaloPdOZ+fciJxnFKfOsoxbulA
         4iPY0Snu+v5VK+HPqwS3CsDJhlNg/KFDYqp83AVrypjuxpFKIHxgolF4hDcI5Gp1V35t
         EbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788868631; x=1789473431;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dGzdGIl2437Zrr1mgAS/9CkFREf8A7GElbXp8vqEddU=;
        b=Di1CpuUAJyYkYVqk0MR3xouUXAjFx/Ite9mojJHfdFmKzKQ4G30kCqLegieIN2Cm7M
         wu+iPw+z8FV7fVhy9Ul4p8C/DUWtQXSBoxqnK1hiQE0wFXiijvVPsuy3uYOQPH//NLja
         Ik1k2T9PVL1w8tZwfx+pGFrMhVqwyTEAoqwTOZ6U7hobfPzdviXhZ3mj+5lsHKxP5eV5
         af8FoOeWCtrNsMVVaUNppuOl1Ep0JPtwSMN7F1wRD076QeQgXgPBST6guSeUgFcOIYht
         lYiA470S4k7ULjO5qmIgYl5xyjn7/ScWEIhpkiurO2ewITykC37VDZhqc2Ru0XdYbgMv
         Gg3w==
X-Forwarded-Encrypted: i=1; AKwUvBxjp4JZBW+6SrtXtOMhCRultJxFsQZbDIYFI28Zo21Rrqr8kHBLszbwdTjP67ZvwRBwfKDKVnCx3A==@kvack.org
X-Gm-Message-State: AFuF++kASUloiCKpR3wP+XrO7uWU9+JbvKGddbxhmheVzbGPwce5R4E/
	o9Hn9gKifENlNEKgYGq7lhBy8g34vN91aAzu3WrBlYyBvo6waIofePbaH4+WVJLO8Mfv
X-Gm-Gg: AYBFou3JE3Xj+eChEHD2EykHrRDCDBs2POdwFh5uNLAkNyoC5pK0j4YyI4wGadWH8VK
	RCehEZS0X9X6SUVPL/X0YcEv3aONc6Sk9bC9nzZ0N1mwxwDDCEjhZX5uZU1lmfvpGEOGxz804LN
	WlkHzbyrtCRJkwlZ5NsAHATBOQzuHI+HctMxX+gzz/4gBDXBc6O/53rIvK+em1pwgOEctQ2HgVZ
	5AhQwsBVspsSL5MZ291XDPmU3fibJQn/cEAaiaQUPT9wO4XUUkTQCNwL3WJRX3eav2Cz/YYcQiB
	JQt/DGrZRXd3tV03PSdccVdwTtUSYjEPx8i3jJ3LhT4TDZiZpxqMXoK/QwBBpjVr10Z4vk5m2uR
	LS2hA6qb8SGBGM2PzxeoEIq+hA0vsAO5Gmk9xUPaas/2Bccz1oRXbA+3BmjvE2ZW8kSlCAlMHL0
	3gptMS/KB7zMebyUBz7dbGxrzInyYqIMwE6xhkJ3Wf0y7ay8/ygo5plPU469Acby3aXWJXz3WI0
	4kLWMfomjoVZQZ83BAQxxL5p/03ktmPtWs9LRzl
X-Received: by 2002:a05:6102:41a9:b0:784:4d38:ef58 with SMTP id ada2fe7eead31-78a4a57f683mr9329411137.0.1788868631172;
        Tue, 08 Sep 2026 04:57:11 -0700 (PDT)
Received: from lima-development (163-53-146-23.ip4.superloop.au. [163.53.146.23])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-78a47ae301fsm8384438137.7.2026.09.08.04.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 04:57:10 -0700 (PDT)
Date: Tue, 8 Sep 2026 21:56:53 +1000
From: Matt Bobrowski <matt@bobrowski.net>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
	akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
	brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
	kpsingh@kernel.org, ljs@kernel.org, memxor@gmail.com,
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v5 3/7] bpf: Add user memory access kfuncs for
 mm_struct
Message-ID: <ap_4Bf61N4AtZWB2@lima-development>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
 <20260907165220.52431-4-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907165220.52431-4-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Stat-Signature: t1brbx55gtow5b85frocz7u345bzynkw
X-Rspamd-Queue-Id: 3DA5FC000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1788868632-338519
X-HE-Meta: U2FsdGVkX19R5/X91IMxTePHRkcuYTo+/3tWxrXGpTaoU9rSjMwU9RzG/z2TXYskj7NDK6sBpFap0BtTYudhx9PLXYBtal15s2OFVrA8T3wGKeT4JIbr5Qkj58rbKwqWzaq8CIl0UlgpcwW5cf0fGKdIXJMSxlhQo6NBj0DtIqQ1OLtSya5MfdOGS8hB6SJi871im9RhKKu/OBSwcP8jweZda3NdRXWnON89hQ7ugdkVPt/W7uM2GuUt9+kWJ8jqadbSvKFVOoJQWNeL1KfieQNEvD7woAKvS/8U2F6Ox9hFDa7yGE+Uup2b+9IU1OcJWHwiDyA2myogp90JAUatJBiW5DbPagovtZkTjiN3sNX76gth9ntr2tWix7crNxgjp/5CmUSkQwYdYjrOY+7hfuIP4nW08yhNx3sjT7w/t/oanWg1XjMpRXPQ+pBL4t6Dff3n8/JhDqwSrvzB7zXu9C1HH/Tr1AX0gnJVHaW1DgQglc3hR8eNMDLChEORasRG+GYANba/lxPCpF7+0snpsgi+sGqmQsy1USO7SzJ+9g0oh58x7dOqEHFnmejt2Ybspu3viUcDNggAcn3elVuwHgLQNS2TokGWq8+zQzVDUBi5HbDKwjxnC5vIFbe0/amwrBB/QkK4p5+KAI0TGopOLr1Qd5v4ONyCkcu1OKkPBbLRIqY/XolCdwSr9B1w//5fdqgcJZ3np9autOfdeR0SpbCOc3Ddxc8PUpW3pZ3U1PAelrALHdZ/CLa/2fi2IwVlCE++E55pBx+SOaQ22ZDfm0wCo/6cS99PfmwwSmlZiQDw3d1+Qa0cGMzsRlK+Oo6+gVRpL2EKWk89XJFy2D4pDdGGBzeVBoyNak23Kpogt8GG0jsR7xOgESjC+cLkLeES8VsBxJmz5HwzIGbdJgjld1XH6Ty2MHopKuB94GKMfEfbSn7/8ZtCtnnZUVdMSAeooR+iEMz+XxtPPmJ+onR
 Q5Llvid+
 ZqPwJVG3qPy5efKE15vG4zTtfDDy7jsc9tpOhiP+MTHnYf/hWTcVE0OTrZxte/37d1RIGz/p8isDot55zQptzHQy5tKZYTVpiAXbz+4avXlYyEVh8UEpFwcKEEyXkJNbxr30hN8s2DyBlk7aO1qMHT7Qtb0FLCIcHZoGUuXK8HRSvCwExt+4Yn5gashdBkPqcZ03Z+C9nA/Ntd+9K1B4L1C+4pchsoDvSDxU8jZHEQOxKRSkIvVZE2HHZ1poreSSw7Y7qWLt2OHyPV636qVrRZGXGHwR0qLrQjqAYPnPdcLb99i9lwn7+w0WFwVPTXMM5OxqdBqWmqP7SEa0gAm5yFymwQS3ykmMJgeKyFxDTjdofggQBS76K4LECpcuspDjYqc1RnORSywavRIycVrS8KplYRr/bgnFhulrMVGU7wWfeWGhM9RG1LYo95AwLf5PtnVwFYccGk5+K9MFbEZsKYB/6Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:52:16PM +0300, Anastasios Papagiannis wrote:
> On CONFIG_MMU kernels, when security_bprm_check() runs, the argument and
> environment strings for the exec have been copied into bprm->mm. The new
> address space is not associated with a task_struct until exec_mmap(), so
> existing BPF user memory helpers cannot access it.
> 
> Add bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() kfuncs. Both
> take a struct mm_struct pointer directly, allowing callers to access
> trusted address spaces that are not associated with a task_struct.
> 
> bpf_copy_from_user_mm() has similar semantics to
> bpf_copy_from_user_task(). bpf_copy_from_user_mm_str() copies one
> NUL-terminated string and returns its size including the NUL terminator.
> It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.
> 
> Refactor bpf_copy_from_user_task() and bpf_copy_from_user_task_str() to
> acquire the task's mm with get_task_mm() and delegate to the corresponding
> mm-based implementations. No behavior change is intended for the existing
> task-based interfaces.
> 
> Register both new kfuncs and mark them KF_SLEEPABLE because accessing a
> remote address space can fault.
> 
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

A couple nits here.

> ---
>  kernel/bpf/helpers.c | 142 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 113 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index b3cc5c8fc875..d3c564437ad0 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -32,6 +32,10 @@
>  
>  #include "../../lib/kstrtox.h"
>  
> +__bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
> +				      const void __user *unsafe_ptr__ign,
> +				      struct mm_struct *mm, u64 flags);
> +

This shouldn't be needed. kfuncs are prototype-free by design, which is
what the -Wmissing-prototypes suppression in __bpf_kfunc_start_defs() is
for, and __bpf_kfuncs expands to __used __retain noinline, which are
definition attributes.

Additionally, I feel as though any shared pieces of infrastructure
amongst these kfuncs/helpers should live within their own static
internal helpers (__bpf_copy_from_user_mm() and
__bpf_copy_from_user_mm_str() or something like that. Callers should
also guarantee that a live mm is being passed into each respective
helper). That also lets the compiler inline them, rather than being
blocked by noinline on both ends.

>  /* If kernel subsystem is allowing eBPF programs to call this function,
>   * inside its own verifier_ops->get_func_proto() callback it should return
>   * bpf_map_lookup_elem_proto, so that verifier can properly check the arguments
> @@ -682,22 +686,15 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
>  BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
>  	   const void __user *, user_ptr, struct task_struct *, tsk, u64, flags)
>  {
> +	struct mm_struct *mm;
>  	int ret;
>  
> -	/* flags is not used yet */
> -	if (unlikely(flags))
> -		return -EINVAL;
> -
> -	if (unlikely(!size))
> -		return 0;
> -
> -	ret = access_process_vm(tsk, (unsigned long)user_ptr, dst, size, 0);
> -	if (ret == size)
> -		return 0;
> +	mm = get_task_mm(tsk);

I'd keep the flags and size checks before get_task_mm(). Otherwise a bad
flags value or size results in us taking a task_lock() and an mm
reference before returning -EINVAL. So I'd argue that you changing these
semantics alone doesn't allow you to uphold your statement around there
being "no behavior change".

> +	ret = bpf_copy_from_user_mm(dst, size, user_ptr, mm, flags);
> +	if (mm)
> +		mmput(mm);
>  
> -	memset(dst, 0, size);
> -	/* Return -EFAULT for partial read */
> -	return ret < 0 ? ret : -EFAULT;
> +	return ret;
>  }
>  
>  const struct bpf_func_proto bpf_copy_from_user_task_proto = {
> @@ -3658,6 +3655,100 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
>  	return ret + 1;
>  }
>  
> +/**
> + * bpf_copy_from_user_mm() - Copy data from an address space
> + * @dst:             Destination address, in kernel space
> + * @dst__sz:         Number of bytes to copy
> + * @unsafe_ptr__ign: Source address in the address space
> + * @mm:              Address space to copy from
> + * @flags:           Reserved for future use; must be zero
> + *
> + * Copies data from the user address space associated with @mm. The destination
> + * is zeroed if an attempted copy cannot be completed in full. Unsupported
> + * flags return -EINVAL without modifying @dst.
> + *
> + * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
> + * fails or is partial.
> + */
> +__bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
> +				      const void __user *unsafe_ptr__ign,
> +				      struct mm_struct *mm, u64 flags)
> +{
> +	int ret;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	if (unlikely(!dst__sz))
> +		return 0;
> +
> +	if (unlikely(!mm)) {
> +		memset(dst, 0, dst__sz);
> +		return -EFAULT;
> +	}
> +
> +	ret = access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
> +			       dst, dst__sz, 0);
> +	if (ret == dst__sz)
> +		return 0;
> +
> +	memset(dst, 0, dst__sz);
> +	return ret < 0 ? ret : -EFAULT;
> +}
> +
> +/**
> + * bpf_copy_from_user_mm_str() - Copy a string from an address space
> + * @dst:             Destination address, in kernel space. This buffer must be
> + *                   at least @dst__sz bytes long
> + * @dst__sz:         Maximum number of bytes to copy, including the trailing NUL
> + * @unsafe_ptr__ign: Source address in the address space
> + * @mm:              Address space to copy from
> + * @flags:           The only supported flag is BPF_F_PAD_ZEROS
> + *
> + * Copies a NUL-terminated string from the user address space associated with
> + * @mm. If the string is too long, @dst is still NUL-terminated unless @dst__sz
> + * is zero.
> + *
> + * If the flags are valid and BPF_F_PAD_ZEROS is set, the unused portion of
> + * @dst is cleared on success and all of @dst is cleared on a copy failure.
> + * Unsupported flags return -EINVAL without modifying @dst.
> + *
> + * Return: The number of copied bytes including the NUL terminator on success,
> + * or a negative error code on failure.
> + */
> +__bpf_kfunc int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
> +					  const void __user *unsafe_ptr__ign,
> +					  struct mm_struct *mm, u64 flags)
> +{
> +	int ret;
> +
> +	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> +		return -EINVAL;
> +
> +	if (unlikely(dst__sz == 0))
> +		return 0;
> +
> +	if (unlikely(!mm)) {
> +		if (flags & BPF_F_PAD_ZEROS)
> +			memset(dst, 0, dst__sz);
> +		else
> +			*(char *)dst = '\0';
> +		return -EFAULT;
> +	}
> +
> +	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
> +	if (ret < 0) {
> +		if (flags & BPF_F_PAD_ZEROS)
> +			memset(dst, 0, dst__sz);
> +		return ret;
> +	}
> +
> +	if (flags & BPF_F_PAD_ZEROS)
> +		memset(dst + ret, 0, dst__sz - ret);
> +
> +	return ret + 1;
> +}
> +
>  /**
>   * bpf_copy_from_user_task_str() - Copy a string from an task's address space
>   * @dst:             Destination address, in kernel space.  This buffer must be
> @@ -3681,25 +3772,16 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
>  					    const void __user *unsafe_ptr__ign,
>  					    struct task_struct *tsk, u64 flags)
>  {
> +	struct mm_struct *mm;
>  	int ret;
>  
> -	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> -		return -EINVAL;
> -
> -	if (unlikely(dst__sz == 0))
> -		return 0;
> +	mm = get_task_mm(tsk);
> +	ret = bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
> +					mm, flags);
> +	if (mm)
> +		mmput(mm);
>  
> -	ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
> -	if (ret < 0) {
> -		if (flags & BPF_F_PAD_ZEROS)
> -			memset(dst, 0, dst__sz);
> -		return ret;
> -	}
> -
> -	if (flags & BPF_F_PAD_ZEROS)
> -		memset(dst + ret, 0, dst__sz - ret);
> -
> -	return ret + 1;
> +	return ret;
>  }
>  
>  /* Keep unsigned long in prototype so that kfunc is usable when emitted to
> @@ -4924,6 +5006,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
>  BTF_ID_FLAGS(func, bpf_iter_bits_next, KF_ITER_NEXT | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_iter_bits_destroy, KF_ITER_DESTROY)
>  BTF_ID_FLAGS(func, bpf_copy_from_user_str, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_copy_from_user_mm, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_copy_from_user_mm_str, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_copy_from_user_task_str, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_get_kmem_cache)
>  BTF_ID_FLAGS(func, bpf_iter_kmem_cache_new, KF_ITER_NEW | KF_SLEEPABLE)
> -- 
> 2.55.0
> 

