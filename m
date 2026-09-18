Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1557AC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D986B008A; Thu, 17 Sep 2026 21:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E0B6B008C; Thu, 17 Sep 2026 21:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE086B0092; Thu, 17 Sep 2026 21:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80A056B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:05:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1289640538
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:05:09 +0000 (UTC)
X-FDA: 85225089138.24.857EC39
Received: from mail-oo2-f40.google.com (mail-oo2-f40.google.com [74.125.231.168])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18B5C14000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:05:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bobrowski.net header.s=google header.b=KkbSsoNo;
	spf=pass (imf26.hostedemail.com: domain of matt@bobrowski.net designates 74.125.231.168 as permitted sender) smtp.mailfrom=matt@bobrowski.net;
	dmarc=pass (policy=none) header.from=bobrowski.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789693507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luKWt0kKmWjdQ8jTRpB2Q7txnP5JpBdLjM73GX2ZxbI=;
	b=2kQu72mAWpJ2OTi58YTgj5IVZ12ninDxO3jVRisovWt+meY0Sg6J7gwtaE5M88zlruWMem
	iQQyFY30JdnGItWVIRzEIUIm3V8H8/bx1DP8JkSR9wvwl2w4AgwCOtiMOjbzWaKo4xpIBc
	WFc+PEotyMZu9MB7DO4MZIre1TKXudM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bobrowski.net header.s=google header.b=KkbSsoNo;
	spf=pass (imf26.hostedemail.com: domain of matt@bobrowski.net designates 74.125.231.168 as permitted sender) smtp.mailfrom=matt@bobrowski.net;
	dmarc=pass (policy=none) header.from=bobrowski.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789693507;
	b=6nB05QuK+VA4ZXTKpAbO5pmx0z09XHQDyvIhBy+Jq+BJIn1YL3IqYR7sj2zW9wNoOyS520
	yX5KZOWcRbjm6cvOdXziv89ValyeMT2G8KfN7jkHii8htdtnEY6DfxuRya7bWQDKpiLJV2
	IbVlq4eGcQPQUZH1fsrucdgEhRE3Tn0=
Received: by mail-oo2-f40.google.com with SMTP id 006d021491bc7-6b1ae6b2010so130600eaf.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobrowski.net; s=google; t=1789693506; x=1790298306; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=luKWt0kKmWjdQ8jTRpB2Q7txnP5JpBdLjM73GX2ZxbI=;
        b=KkbSsoNoVqQQ5eJeVlno/E6J4C2XZejJ3ELp+sk5AVMRKsVMAVw/24qmLfybdf5WSz
         NduyyFuFn8sG81ziUQjXB9VkPbDa+CD37Jo/ewvGiZTbLOECgByjdhxxldMaYAx9u5K1
         7W8ttwmvMcLea3VDpO56pQzns9kys7teuRyEb7hEvIMDSZDdyMht0XLRd7ybtKMvMVpc
         UtRRt1/S6knpq1t4gVAvROh3VLg4hubgiFOIVM1RMdwNMkzAqqpVNuSlG7+KJ/QCnqrR
         zz8db7uYaRck4wQDZWr/3V3StyoxlGYmtyxXcdRrN9uh/STPIBSl9DvdxjlApUthgPKM
         yCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789693506; x=1790298306;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=luKWt0kKmWjdQ8jTRpB2Q7txnP5JpBdLjM73GX2ZxbI=;
        b=F/a0IR+EvsqDhwh4FnHtSgSrZrucUNTRZmuxqz+Gla2Yd4bAHO5iMgcpsskiA3AtE9
         2MvRnhFWGvpdwOkapvC/jb71x4yFV47hP2Pl4zLpjqcAMOjMLvLdt7cVl3a7W42ec7Tr
         Lkj53//kapvA9tRXrlR8N1ffIdApQKnO48bgE4fBCPhbMKt/s1nvHGH/rUGXbg8qnZhV
         82BVpZyeaVDeUTwOgX8kfh8DOIqSj3pOUeQEZxV9YO13zq1CoU1JHciw4sLImEo46WXN
         +haY/80o0isSOZ/QuZbu8mefyyPiq+QxRsbu4iuSs/XjlJ6Mcs9tokjnU/TOkazowMAw
         Hr1g==
X-Forwarded-Encrypted: i=1; AKwUvBwEhRb4tzrlsqembDGWYZCAXU4qFS9YgGjdB4LdY+b0Itk98KnFUPgGFi0BaklrlZxhTdv18P8dYg==@kvack.org
X-Gm-Message-State: AFuF++ntV3xcx4qKgC2ZVAfURIjygBlZXGzT7PPdKF9ldhIS90VFsB0a
	TLcByE0uqvfmIsIVZ+2OPbPAnSkblYNFT0szMnnU9ybfrjxtJ5KPuATYhbYTndRzyqv4
X-Gm-Gg: AYBFou2xsmhR6R0TtiiHRy97Q9yqZos7Zo5TExMF8jqEYXL4nj/fExtwHgfNPPUsfG1
	X/rdj7kX0dBL8rpvjMykFkqvMDbIJhDXZtOzOO25SgkULqRtnpn76fSuVGMRNV/ZwifBSBW9utA
	iyloyuNVpLDgIUYF02FsX1B8JKMUHfqoaVYhEt0dHXMxzdrvXANbylj8c2+HDnGBXf9wbm31tw8
	vQLgCpiU0dETcnq3PJwPrBz4eUg56E4JS/yPZK1dnHeRm1raDQJUCXbfZ/GsYYwIZE2HQgqfZRq
	3+I8Q9E4rjaQiBO82lDxyD0ADGcgJX8tbl19Vj7wCD2yvRIvkLkbqGcI5kog/fdo3vAjmkKbqPL
	fkwxm0jrVUghqQEjX3iMU4EfS/URfkULqPOv3ZCRUoDWdpCCKofUsV7iWvlMKcMn9qHtD3WEpmO
	sLmWi0ZGWpuOjaPObVP2zmT3gfw/UPMC5GVARPI6Pve68=
X-Received: by 2002:a05:6820:2019:b0:6bd:5506:aae0 with SMTP id 006d021491bc7-6ca9a748585mr824155eaf.22.1789693505875;
        Thu, 17 Sep 2026 18:05:05 -0700 (PDT)
Received: from lima-development ([75.104.94.190])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4870b53dfdasm343751fac.11.2026.09.17.18.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 18:05:05 -0700 (PDT)
Date: Thu, 17 Sep 2026 21:04:37 -0400
From: Matt Bobrowski <matt@bobrowski.net>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
	akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
	brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
	kpsingh@kernel.org, ljs@kernel.org, memxor@gmail.com,
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v7 3/5] bpf: Add user memory access kfuncs for
 mm_struct
Message-ID: <aqyOJVeiJrglQ7Up@lima-development>
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
 <20260915080255.48929-4-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915080255.48929-4-tasos.papagiannnis@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18B5C14000E
X-Stat-Signature: ki3yazpaujpu3dyatjhcw1mwjcg7jpo8
X-Rspam-User: 
X-HE-Tag: 1789693506-601311
X-HE-Meta: U2FsdGVkX198UVRROdl1Ueof1UzRRSlsHrQjuPRtu7sjJJ6IOGaneZOLim031wc6xVzvnd8oiwg8FZY6xOXDaIW9uON3N6LxXiOkn9WeyjrjsAhOoXWSHP1MredkqiTMa7rWpQIylL6mei+ecOy7ZO7BWfVtacULOorZBwmk1T7BFEZPWyO6RleiYdp1k34nAVQnbY3hvcwx5spdNPx+KixJsUnN/D/505pRDybYAy/Ag+J9sYQ06U43E80WH7J+k/fpuGoi40D39Jfz0s1aZZ8Z2JF8UsyZiM6Gh687uMSCXQYSOggcDqabNTm5OhpgIALCnn7Da7DVHMFnGlc98KvIFuRAAAJ1J1O2CJ85Vf1Shti+D4wdPVGl51BLgdA94NM70lYNIfxWxgjS9eM931LRXb1RZlxwShXiK4MMg6LvhdK3tUTpWEOU/D1guaOQGv9klUE6ZOFCSXjt2Cr9JRPSFF4svJa2Dk/tbol1tpTKisBr39HQ2RjFuZjnwuyLQB7bOVHcrTwJ6jYfdVrC4S9PIY6yWb2HDaBuN8Njj8tGVRGdsldoJJQ34Vgj74kIJ3Z7HEhwWM35EgTrUSkA1WTbiu5YRee/CEh0XudXG6Mu6FY7XWN5dWtzzOD0OoVkPztcC8N0BUcdap/vr97PKqe9j9lnPFaQE1TGhY72Kmrvw17QUpALA/77eGG5AGW/XYHLsB4lpjLaFEodJrav2GrJfpkimC86FD7VOvIRrA34ZbFpdnYZLUGz1T+OrYxiCbnX7zDt+a/X5fS9QGSiD34eCqmNPHzH9Hx0mvCreDC3DdMu3s/1/VEDw4tq2nhDB7+k3HY1KcaHLLNnI7BH4XqVLBsVgma4PM6In4mwM+UemPPKSIlEq+nf2beX3bkbl2TJGeFRX/tYXRQMAaUeH1nlNQjLYoY2ZvjgVEBRutHyvhuOqoCy1ndA/jY5X/AfrQdDrP6rLDEgQHNPOwJ
 w3n0XnSk
 u8buVZzP39csn3pfgXePY5JwhYGdYN5h75RfkZhNoRj+zg5BEm/V5+IfTTtYVelKL3Aqmux/l33ZOnhIhPBWzJ0SHozSQbBUcbSa7+JwnfDehBNTeVbQ0ShBFzWg+eU1upNpztw2tO5ofwW8jFwmLNBCVlvx3TxZtzs8/4Io0fEQ+HoCjW7JdP4vw9p+ktl5gBK84bp3x8wKM8yWGIgKDu4dbqzeHavWPFbUcCCXEMUoDTmWuO5QqDQOxZgDgbRhIw3EVmyJVqP041exir1iU46DtaAgFOWEnc1NIVx7nNCy2c2x9Y34M9WmF/babyqqY8gvg27YzrIfUr6Ihk+jXXu61PCtsIwxV+pKNwqWyREUyF4g2J8OAvCJMBb8Ar+KTBes0Cahj9qkmTfaRra5uHO5XcAbnFfkvHo1I/jNJuflvqTYMtOf2hS1qO3/KhqK1aQpgPqqrnxdOS3Cn3d5WjuaTaKsgom0r0LzPKRlNqxyOjmuSJFAa/3Qo/KqGfAb2ENm+p0qku+2PP/WLW41uce2Naw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 11:02:53AM +0300, Anastasios Papagiannis wrote:
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
> Refactor the task-based helpers and the new mm-based kfuncs to share
> static internal implementations. The task-based interfaces validate their
> arguments before acquiring and holding a reference to the task's mm for
> the copy. No behavior change is intended for the existing task-based
> interfaces.
> 
> Register both new kfuncs and mark them KF_SLEEPABLE because accessing a
> remote address space can fault.

Thank you for employing my suggestions. I think this looks much better to me
now. Feel free to add:

Reviewed-by: Matt Bobrowski <matt@bobrowski.net> 

> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  kernel/bpf/helpers.c | 130 +++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 118 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 051b6654e57c..f6b3eee6098a 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -679,9 +679,44 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
>  	.arg3_type	= ARG_ANYTHING,
>  };
>  
> +static int __bpf_copy_from_user_mm(void *dst, u32 size,
> +				   const void __user *user_ptr,
> +				   struct mm_struct *mm)
> +{
> +	int ret;
> +
> +	ret = access_remote_vm(mm, (unsigned long)user_ptr, dst, size, 0);
> +	if (ret == size)
> +		return 0;
> +
> +	memset(dst, 0, size);
> +	/* Return -EFAULT for partial read */
> +	return ret < 0 ? ret : -EFAULT;
> +}
> +
> +static int __bpf_copy_from_user_mm_str(void *dst, u32 size,
> +				       const void __user *user_ptr,
> +				       struct mm_struct *mm, u64 flags)
> +{
> +	int ret;
> +
> +	ret = copy_remote_mm_str(mm, (unsigned long)user_ptr, dst, size, 0);
> +	if (ret < 0) {
> +		if (flags & BPF_F_PAD_ZEROS)
> +			memset(dst, 0, size);
> +		return ret;
> +	}
> +
> +	if (flags & BPF_F_PAD_ZEROS)
> +		memset(dst + ret, 0, size - ret);
> +
> +	return ret + 1;
> +}
> +
>  BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
>  	   const void __user *, user_ptr, struct task_struct *, tsk, u64, flags)
>  {
> +	struct mm_struct *mm;
>  	int ret;
>  
>  	/* flags is not used yet */
> @@ -691,13 +726,16 @@ BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
>  	if (unlikely(!size))
>  		return 0;
>  
> -	ret = access_process_vm(tsk, (unsigned long)user_ptr, dst, size, 0);
> -	if (ret == size)
> -		return 0;
> +	mm = get_task_mm(tsk);
> +	if (!mm) {
> +		memset(dst, 0, size);
> +		return -EFAULT;
> +	}
>  
> -	memset(dst, 0, size);
> -	/* Return -EFAULT for partial read */
> -	return ret < 0 ? ret : -EFAULT;
> +	ret = __bpf_copy_from_user_mm(dst, size, user_ptr, mm);
> +	mmput(mm);
> +
> +	return ret;
>  }
>  
>  const struct bpf_func_proto bpf_copy_from_user_task_proto = {
> @@ -3659,6 +3697,68 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
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
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	if (unlikely(!dst__sz))
> +		return 0;
> +
> +	return __bpf_copy_from_user_mm(dst, dst__sz, unsafe_ptr__ign, mm);
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
> +	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> +		return -EINVAL;
> +
> +	if (unlikely(dst__sz == 0))
> +		return 0;
> +
> +	return __bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
> +					   mm, flags);
> +}
> +
>  /**
>   * bpf_copy_from_user_task_str() - Copy a string from an task's address space
>   * @dst:             Destination address, in kernel space.  This buffer must be
> @@ -3682,6 +3782,7 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
>  					    const void __user *unsafe_ptr__ign,
>  					    struct task_struct *tsk, u64 flags)
>  {
> +	struct mm_struct *mm;
>  	int ret;
>  
>  	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> @@ -3690,17 +3791,20 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
>  	if (unlikely(dst__sz == 0))
>  		return 0;
>  
> -	ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
> -	if (ret < 0) {
> +	mm = get_task_mm(tsk);
> +	if (!mm) {
>  		if (flags & BPF_F_PAD_ZEROS)
>  			memset(dst, 0, dst__sz);
> -		return ret;
> +		else
> +			*(char *)dst = '\0';
> +		return -EFAULT;
>  	}
>  
> -	if (flags & BPF_F_PAD_ZEROS)
> -		memset(dst + ret, 0, dst__sz - ret);
> +	ret = __bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
> +					  mm, flags);
> +	mmput(mm);
>  
> -	return ret + 1;
> +	return ret;
>  }
>  
>  /* Keep unsigned long in prototype so that kfunc is usable when emitted to
> @@ -4925,6 +5029,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
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

