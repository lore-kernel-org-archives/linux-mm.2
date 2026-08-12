Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3805EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F5E6B011E; Wed, 12 Aug 2026 08:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608F46B0120; Wed, 12 Aug 2026 08:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1916B0121; Wed, 12 Aug 2026 08:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21D6C6B011E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AE7B16025D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:55 +0000 (UTC)
X-FDA: 85092521430.30.33BB6FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 050E2C0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XR1ELGkY;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMpFTc+g6IgE1WuvBF2vZgzKnR0zlmMW9uPYcbdXHdc=;
	b=uo/ltWaQ24gHimNCdsAjeFqNYLbbAA1Eir/VDp7k+ywe2ICtTmTJUUor9XmyjbzBrBh+Ji
	+Ze8LY40jm+LJzmX5K6ejeofNCYGtPYdmQHuJzNHSNVeSenAe7WL4pykSuPJ/MKL86y85W
	+3upVzWm/67Z5M5MZwc4Z+vwjDfugZk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XR1ELGkY;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537134;
	b=vx/Y6Bb2NgWy418ITp3nQnObHz5fPC2Z3kXC+dWg8I/gs4IDUtxltwrVtsBc1aj9C3ezkk
	vx2MkgCJi9Zs7ojWlr6v2I0UkSC2PnCOUTyQEv/ImkQCrs6jZjMHN27jzHijhnGjVPDYor
	NpitUHuHFYlw+pyHLmvB3EqXHKiB03M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46383400B8;
	Wed, 12 Aug 2026 12:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD871F00A3D;
	Wed, 12 Aug 2026 12:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537133;
	bh=AMpFTc+g6IgE1WuvBF2vZgzKnR0zlmMW9uPYcbdXHdc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XR1ELGkYJUV0I3g+KHTQYwCBvRLMrofKznvS8I2nDwtcAyO0VcBpHl04RQkcUVAGd
	 PA/06i9bIQZ0fUD2+LzJXHKLuGZr5I9B4/mB2dslmOh0rgPdMIXsJUt9zq4UyQHOHt
	 4Evh2ualwdkzQ3p/qB/M/StBLdKPE2iArtvP33SDgYsES544piVbjcoYRLikb7IPzO
	 08dwiQhROIEA7O87PDxzOvAPfdyEO31fQkFlzOaOTJIigT6stfi9A9uOP+3dOCDc8d
	 DsGbQTy5Uy9AoSMI64EBBLauPv8n6dbYhhr1lSoBCwm8aVN1AXNgwhO2DuM9zeQlsO
	 IrlkxLoizi2iQ==
Content-Type: multipart/mixed; boundary="===============4269150414782578171=="
MIME-Version: 1.0
Message-Id: <5c6c4c0dc10821a217412145a7ecce31849d0f2375ab6fb51b69db49acad7e22@mail.kernel.org>
In-Reply-To: <20260812111140.7762-3-tasos.papagiannnis@gmail.com>
References: <20260812111140.7762-3-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for linux_binprm
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 12 Aug 2026 12:18:52 +0000 (UTC)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 050E2C0004
X-Stat-Signature: 35zshfkdwqmhq1gq4oco6ojre9wcxsbi
X-Rspam-User: 
X-HE-Tag: 1786537133-858470
X-HE-Meta: U2FsdGVkX18PIChU9KxsGyq2tx0IYnUFAhN1+gDpPslQtKO/zgyX63TJ/erX8epNYxCYswNJJMrULhIOsFV146wDIUtKpnaaMPCaGd4964EyjAblvvSs+6bsl2DEQQ2tXJ8Eicgo0m0enKyM8qtJ+CTcIEZ2ahs/UMfoI0acUU9f9rWQ1JZZe3yRFDlrKirRK5bMBHKq3wlKtEdxLzOpSWH8b6oKjOhZJQ9jLkCkzE3a62/ig1HN9WfwPLu78Abm45xfbQu6YZEiA/sM2iUgM112P24JA+8u6/ytuEHlqnkXjU+UCWBSJiaz9ZnQYySWoCFZTn/JEd9BnB/jyaVy3VArtTQyofnXm4Gs1opAPRWgJYuFQC/Tezj6HFQFDGkUZ+kwBXJXSKJ84DS+CnBIOz8xIkeajdBo+3oAey8LF+q12IwwyNvRa30xKtIXYh69kdcn82NAl6bCl6Gf7GCusPTeRydmTlC0gQrGJiNIqiYGuWnd5cIYZwdZWnR//k5Oge6n4bl/JmmooeRSSoQZfqfv3z4z4zgn9s6kC1QKktOyplPSLJ6aF6kav4eYYD+keMlj1VEQDmiXyktHLmRZJ6A0EP7KhPPV0u7uvcO4or4cJACU3ggtu9hZhwQpf170M86jlRfYhUiW26b3nUVJ8O2R8KXcEqLH9cjXmIR8sb7lRyFmrKQX07+IsIwSSff6M9e26fQwBOpXpkej9YRIoifeC16AvCDROqU00WaN4h7QUN2xmMRbIwCcZxaODmcNGg4SpB7qASizPIFNwAD+aIN6Po6nL1RbjgvmeQUXTGcyHFlplkzAFfC1Uvb9eifSN11jf7OTx+iU/p4JTjI7nrvXJSqFZGuUMAfZ0BEyObnVL0KBpQ9Y3uNCpcJKd3XugSHjMEC67c62LYWIDtjDHhrRtlcCC/WXTSk6SDJBueHa+I5WQ2m7c9oFg74l6gqsRvmGU3oXkMCPVjYJC3x
 pClhGbBQ
 SJcBNvUDuxBo7HfiwgU+pXyQdqOqEfv4MDjYUcEPHNiwdHkv1z4PyekRRoEUTNs0FTmxr9wU7hyxbnvNOAIJnz+xKp1rt3Q+19en8H5rqZoq4M+AsgO9byiygsmA3pKBpTo35T9w6sCHtAG56s4Ui3VPJr1ToY6gyjaO51NvqxjZRE0MfCnaYUAGjHSMwWHN61hq0NqXRta/m6uVuGev3hoZ8jU4n9/Gtal53uXYiVCnhqipEPikoBhD9j5rylVUTC2YqFb7qOzgiEKLV5gPPgRt/qZyHg9RhT/Jkn0pMYWJxYkBdWx0qLlWZqwyi+jhbhnpEqQKQP1Iaccd6KpJtcCkaHlH3U4J0pQZNeRGFRpCkfidaOTfLNDleiyXKdGBjhTjGmEwTYvGYXCauJIOPcOsCtLg2b/HegOye36ZQs2bQRMktBdGXW3YOVi2syBzcyvqiMBnPpOXP7O9HFt01tMoCweW6O8W3sYhDhcB5lTZNobrLMwlXpc8jDj9solPIOjVM2SaaAKRnmlwDVLh1lvzeXW1Y0rArzUxm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4269150414782578171==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

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

[ ... ]

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

[ ... ]

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

[ ... ]

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
>  BTF_KFUNCS_END(bpf_fs_kfunc_set_ids)
>
>  static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)

This isn't a bug, but since the bodies are still built on NOMMU with no
possible caller, would it be tidier to put the CONFIG_MMU guard around
the two function definitions as well as the BTF_ID_FLAGS entries?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31592551940
--===============4269150414782578171==--

