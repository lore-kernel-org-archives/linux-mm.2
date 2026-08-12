Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C5AC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2FE6B02E0; Wed, 12 Aug 2026 14:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792B26B02E1; Wed, 12 Aug 2026 14:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680E96B02E2; Wed, 12 Aug 2026 14:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9976B02E0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:40:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAD3AC0434
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:40:27 +0000 (UTC)
X-FDA: 85093482894.17.C6A6CBE
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id EC5FD4000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:40:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xn2YV7DD;
	spf=pass (imf07.hostedemail.com: domain of utilityemal77@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKggjgOfMYzIGeOhc+tmd9M/20f2SVgkeM+/VOJ2kP0=;
	b=XOxbUaA4O28uYAQuMOHI6x2LgpxIwxeULQF7IfcI1MUc5oeHyKYAU07coyog+0k0DNAZ5/
	IkwPRM9hKt7UYNQdyHTqIs+TT/wviMCEJFIp4eW6pVR9EJloxh5XL1sCN66FAbrPaubG5X
	rxMGjQwMuzWKeDn1VlSiSrChodnk0Vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560026;
	b=ejpMz2UJRiJrfyh/vBD5UB3XrHJBTlGatjJSrtxwS08t3P+65vuSGCOcVuumsOLo6/La7+
	73mBUNSxKyldy/kcCCysJs7T2SqctiN9UkyfXJVaj0IG/Upfsm3TpaWghs6ZjUtW8XwZ3o
	XbD0en0uLX78sBq4SaCX9DbNjq7ESqY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xn2YV7DD;
	spf=pass (imf07.hostedemail.com: domain of utilityemal77@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=utilityemal77@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-668296d0ff3so2174859d50.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786560025; x=1787164825; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKggjgOfMYzIGeOhc+tmd9M/20f2SVgkeM+/VOJ2kP0=;
        b=Xn2YV7DDADtoMA4waxq3q/nhJgeNM5HJ9rXwitthHGPhUAmB6H2X6u0qb/ihWQ917s
         aUUGfkSu+xo6y8DfUm9OoEqP1NW1wkjZkR/lg1od/k8A3bhPiet9KnkxB9Qcrb8JHbNi
         kyzy+ZKfDK47IK6en5tkNUtC6l5PU6YCGVpDludvVWLyoxqywQZSrFCZ7yorbTnL87LC
         qy0LyQ+8QoYAdHzltq1awRa8cDbb4pUlHlyZFd7+77Tp0tHoBz448wOwnll0WDVazD1i
         U3NTfmWKwDsn78sdmQm0WOG/70FNB9XBehiUWaMsYzWdvI//7bI9+h7JNXPp/qSNseMM
         bpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786560025; x=1787164825;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKggjgOfMYzIGeOhc+tmd9M/20f2SVgkeM+/VOJ2kP0=;
        b=dPnrjqicBweHyD8BvqxRpVBziW6e43N2W+LQl81/lDWXcIXxn7cwrV0acgcD3ovkVX
         44sy6zZH414fcK9dYPu7DTcmFl37ZrGqrl7VdSZ7dJRzS8DscIr7XQ9LcStgVXNPP+VV
         xxGmTk9ECOmAsGuc/FIHS0ynEaBT+GHbZLcCumZdbRSEx4ImJaidSKRoO/rAwR/73YGM
         8ntIZIqaeQGbPmnX/ufJadFAXiW1HOkGtwTh33GLu4OBRIMPIkffjndGnjX/majVZVxO
         DcQKQJ3qfA+Ntubin5VeJuawjkG1NdGemovbylOMlr8IHMExb5jpnDisSf/BqggoCxjm
         tLtw==
X-Forwarded-Encrypted: i=1; AHgh+Rqd5GA9egKA4U9d+4q5+WE3xtdEXn1o3GuTc+RxRsvqNotrqa349CBdZN2PLHk5AY7r/iR9dZOiEw==@kvack.org
X-Gm-Message-State: AOJu0Yz0rNpuOI4blrcHLeXarJ6alaycL/lVEBFnIdK87EJCaj4nO/8K
	fbNrZr3EviaxnFAPS+kGATo77tN8kV2I3z10wt1S6C556oLj79sLTlKT
X-Gm-Gg: AR+sD10EVhODt7vnfMgsjUwzsb3T9s5sSILG4zQI1D9AF9lC8wqc+L5FopaJ23zWj9M
	Xp4UHqQn3xei17URt5BUPPwPs024kQlC9+X0J/SQoMk0SOtIdLD7SlJX7hRzbojzaNUkR0b2OcE
	ImF/3bmjg15lThzrcQTXL3cno+ciRb1GkcsHY9d2tGdqJuVibTHxUbl5XT4ak4I4Xpa4f3so5Jh
	rlQD9mjjQmBZOOcGF+jQ1mlUJ/RKerIKCKbp75TkDH/Z4S4hNn733TbJwflL6vYeofgVoJtUdRk
	Xx1cYnw8fbRJ8qZ7hW7wTP2YiIYrzF2r0zz2pmecKbjMIw+1jJKyJtRr7xujJI8nHx3o2pn4I+O
	OeSAD/c+Xagiv3w9oI98yaUGEt5Gh2Q1/Ts+Tv9/xqEWiQKoA4gFKSLELJ5IliH37m6YEq6GdAU
	qK20wSNQ3xyHAgvRxjanVw0Ypt72Z6bzBJ55esV2PMt3sXel9HjW7j0XFCBfAS/ACvrgnvYUiEk
	EOuNRkiZoB9uXfI+NBtWw==
X-Received: by 2002:a05:690e:15d4:b0:66c:4937:d319 with SMTP id 956f58d0204a3-66c517f3293mr140199d50.46.1786560024796;
        Wed, 12 Aug 2026 11:40:24 -0700 (PDT)
Received: from zenbox ([2600:1700:18fb:6011:3077:a5d:da73:f5b4])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66c4f16adc9sm324552d50.10.2026.08.12.11.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 11:40:24 -0700 (PDT)
Date: Wed, 12 Aug 2026 14:40:23 -0400
From: Justin Suess <utilityemal77@gmail.com>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, kpsingh@kernel.org, 
	matt@bobrowski.net, song@kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for
 linux_binprm
Message-ID: <any3wCj66dWbwgwT@zenbox>
References: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
 <20260812111140.7762-3-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812111140.7762-3-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 3qk5whxhdofqt1ro5g6etchh5ecgy44t
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC5FD4000C
X-HE-Tag: 1786560025-528294
X-HE-Meta: U2FsdGVkX18gqOh36qwGxWfY9jHGVH9Z4euJuK7ZLJ+7t4qNG6xdp7PYTRyxdGXVeAGZ5LpM5KYigUnla+yHLjgaoTIpNeY+SbWcuSlVdXYK+UnZ2yMZPtj4vB3HvVYJiXX1vkM7EsCYP7Myr1UpFAQiib98BG2YcoTC4CBWv6zeoRPQeVzVs4uSFQNHCUMSu6gbwnspPU2ZCXAwfoPnZUmAi7/stlmvCZGeeuXj1mQ+U6Ljpy89ehoLrp5IIxJZZRE9jQkh4tDOww2R/6l9EF02q5dlHbZXjcbhSLl4X0SNPLXH+ZWzxpIjUjtG0fI6sJXda0ZbdNiIaMUrxZ5BGiUcAFn5FPCOhK5mWHy9ySnaHMFKfFWdOLn9OCm/0jJzxh600J/eSom1SHYy0x0tsrv0ACQ2H4FvN/9oGl+YT85W+W4BwqbzUWcMGjhnSClmfIfo/SPr0xjK1O+JZq5uO4XbNb2OplI+Pugs63+iUs2X9NywTUiWngGeOJdNXshEuM8ORwZBYsb8+HFgQHCfYG9PNlRcsMkFVFvtS+9Zt+fByv+QqWQ20OMVZ2z+XIBEfJ67q8ckrnYFWy5YTV7Kir9EojXunZZKSNu1FfFq/dd8JKoDFOJVa9nTNO22jjvlkb5njAHx9TROw6PppQ0y51z/nCfJTuCvxKt1g+d5UMeY5qv21bXLEM7HQELtT8GF1aVtGSeqmeV+wp1jNuOgT0UTQHekDrbVfqEw/7WXSae8Xw1k0vlx+dMFEeawVMO9oDjKx0NmMCO00arMwGi1+VaL3Fu8n6VFTNsaL5fIWtt+hqHyh9HAq0kYCRmew9g2DaH+PulUyK7lMsws1VjGfGCoaZ5JZvtlyrzNWVyW5nXskUYSsWFw4uS6ZKwCkioHir5xfQhPN6793zDxLB8nCzWVi+PMz1z3HsMUoQT4+A0OwA1WM9FDzVNwcImv6DB/Mfi4ipKskStVq5a1v3q
 GHpfPEHV
 eQXqSFU4h1UVziFhuQNkoGSTwtZkqo2bmZbPDwKpQlfHNbCUzM50Lz5NX1zLTrf6cML7EMmAXC2oU5D/zWIqBQxih+4eAKmFEgX0dLCYQKvYEtJQQ4OGZT6M4+8UdIo17qOM9xUAEvjCXwbrG/u8rwVmLPuGUbsGv1ZyO/wwKmnL1WMYZX6I4BkqB/U3dB8q5Le/+FlvlXGzci60y8BXL2M6W4NSJWfzJSpcNHWHGETnXdYCMsPt2mEaLIv9eQIxakK/hU/Btvob6RsoUt+CxmpJKxsMGe/itmBruRAa1G0p8Vj/e/B7DFacntHqDxXbX049qImv6CpN5G3SojmUg2fjKw5NBlmxY5+tBuoq1OyD/SY+OMtBZ9E/vADYk/jacTRO1ohvrPe5Uo9IvH7ZhNsXVio9rx0COs8pyDGnw4urnDSabOcfM9iGCMd4FThrzxFaQjbQ5jvdDv33aEFdX9OCkC04wMv2ztW16iqeGSB9Snsl2XWrR/ttdBUlcVKaKOaXuBlRMWXhYa1StJU+X1qPRcb3nc5ew6sbLDRaCw7jSSIdybvDbM7E2moZrNLwQvWSKJUsOM7XSIGcxV14twTB50u+b+nycL6+RSSNkOw0qv3DvuDeOwQvbVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 02:11:39PM +0300, Anastasios Papagiannis wrote:
> When security_bprm_check runs, the arg and env strings for the exec have
> been copied into bprm->mm. The new address space has not been associated
> yet with a task_struct until exec_mmap(), so existing BPF user memory
> helpers can only read from the calling task's old address space.
> 
> This patch adds bpf_copy_from_user_bprm() and
> bpf_copy_from_user_bprm_str() kfuncs. Both use the mm_struct provided by
> struct linux_binprm.
> 
> Register these kfuncs only when CONFIG_MMU is enabled. On NOMMU systems,
> exec arguments are staged in bprm->page[] rather than mapped in bprm->mm,
> so these accessors cannot read them.
Would it be better to handle that case transparently rather than
requiring introducing a new kfunc / leaving that gap open for NOMMU?

Either return an error or perform the copy from bprm->page[].

Unless there's some reason I'm not seeing.

It would also be better for portability across NOMMU / CONFIG_MMU
systems (the exisiting kfunc is never registered, so a program using it
would be rejected rather than able to handle the error).
> 
> bpf_copy_from_user_bprm() has similar semantics as
> bpf_copy_from_user_task(). bpf_copy_from_user_bprm_str() copies one
> NUL-terminated string and returns its size including the NUL terminator.
> It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.
> 
> This patch registers both kfuncs with KF_SLEEPABLE because accessing the
> remote address space can fault. This allows BPF LSM programs attached to
> security_bprm_check to read arguments beginning at bprm->p and reject an
> exec based on its command-line arguments.
> 
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---

These patches are nice, I would like a feature like this.

(useful for security tools needing to make a decision based on
env/arguments as you said).

>  fs/bpf_fs_kfuncs.c | 112 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
> 
> diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> index f1863a891db6..74befdadad68 100644
> --- a/fs/bpf_fs_kfuncs.c
> +++ b/fs/bpf_fs_kfuncs.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2024 Google LLC. */
>  
> +#include <linux/binfmts.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/btf.h>
> @@ -379,6 +380,112 @@ __bpf_kfunc struct inode *bpf_real_data_inode(struct file *file)
>  	return d_real_inode(file_dentry(file));
>  }
>  
> +/**
> + * bpf_copy_from_user_bprm - Copy data from a binary parameter address space
> + * @dst:             Destination address, in kernel space
> + * @dst__sz:         Number of bytes to copy
> + * @unsafe_ptr__ign: Source address in the binary parameter address space
> + * @bprm:            Binary parameters whose address space will be used
> + * @flags:           Reserved for future use; must be zero
> + *
> + * Copies data from the nascent address space associated with @bprm. This is
> + * useful for reading the argument and environment strings before the new
> + * address space is installed by exec_mmap(). For example, at the
> + * bprm_check_security LSM hook, @bprm->p points at the first argument string.
> + *
> + * The destination is zeroed if the requested number of bytes cannot be copied
> + * in full.
> + *
> + * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
> + * fails or is partial.
> + */
> +__bpf_kfunc int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
> +					const void __user *unsafe_ptr__ign,
> +					const struct linux_binprm *bprm, u64 flags)
> +{
> +	struct mm_struct *mm;
> +	int ret;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;
> +
> +	if (unlikely(!dst__sz))
> +		return 0;
> +
> +	mm = bprm->mm;
> +	if (!mm) {
> +		memset(dst, 0, dst__sz);
> +		return -EFAULT;
> +	}
> +
> +	ret = access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
> +			       dst, dst__sz, 0);
> +	if (ret != dst__sz) {
> +		memset(dst, 0, dst__sz);
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * bpf_copy_from_user_bprm_str - Copy a string from binary parameter memory
> + * @dst:             Destination address, in kernel space. This buffer must be
> + *                   at least @dst__sz bytes long
> + * @dst__sz:         Maximum number of bytes to copy, including the trailing NUL
> + * @unsafe_ptr__ign: Source address in the binary parameter address space
> + * @bprm:            Binary parameters whose address space will be used
> + * @flags:           The only supported flag is BPF_F_PAD_ZEROS
> + *
> + * Copies a NUL-terminated string from the nascent address space associated
> + * with @bprm. If the string is too long, @dst is still NUL-terminated unless
> + * @dst__sz is zero.
> + *
> + * If BPF_F_PAD_ZEROS is set, the unused portion of @dst is cleared on success
> + * and all of @dst is cleared on failure.
> + *
> + * Return: The number of copied bytes including the NUL terminator on success,
> + * or a negative error code on failure.
> + */
> +__bpf_kfunc int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
> +					    const void __user *unsafe_ptr__ign,
> +					    const struct linux_binprm *bprm,
> +					    u64 flags)
> +{
> +	struct mm_struct *mm;
> +	int ret;
> +
> +	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> +		return -EINVAL;
> +
> +	if (unlikely(!dst__sz))
> +		return 0;
> +
> +	mm = bprm->mm;
> +	if (!mm) {
> +		if (flags & BPF_F_PAD_ZEROS)
> +			memset(dst, 0, dst__sz);
> +		else
> +			*(char *)dst = '\0';
> +
> +		return -EFAULT;
> +	}
> +
> +	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign,
> +				 dst, dst__sz, 0);
> +	if (ret < 0) {
> +		if (flags & BPF_F_PAD_ZEROS)
> +			memset(dst, 0, dst__sz);
> +
> +		return ret;
> +	}
> +
> +	if (flags & BPF_F_PAD_ZEROS)
> +		memset(dst + ret, 0, dst__sz - ret);
> +
> +	return ret + 1;
> +}
> +
>  __bpf_kfunc_end_defs();
>  
>  BTF_KFUNCS_START(bpf_fs_kfunc_set_ids)
> @@ -390,6 +497,11 @@ BTF_ID_FLAGS(func, bpf_get_file_xattr, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_set_dentry_xattr, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_remove_dentry_xattr, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_real_data_inode, KF_SLEEPABLE | KF_RET_NULL)
> +#ifdef CONFIG_MMU
> +/* NOMMU keeps the staged arguments in bprm->page[], not bprm->mm. */
> +BTF_ID_FLAGS(func, bpf_copy_from_user_bprm, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_copy_from_user_bprm_str, KF_SLEEPABLE)
> +#endif
See above, you may be able to handle the NOMMU case and get rid of this
awkward ifdef block / verifier rejection.

Code looks correct otherwise.

Justin
>  BTF_KFUNCS_END(bpf_fs_kfunc_set_ids)
>  
>  static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)
> -- 
> 2.55.0
> 

