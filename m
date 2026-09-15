Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D252C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32FBD6B0088; Tue, 15 Sep 2026 05:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1B36B008C; Tue, 15 Sep 2026 05:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F80C6B0092; Tue, 15 Sep 2026 05:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DACFC6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:01:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D95BC0392
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:01:47 +0000 (UTC)
X-FDA: 85215403854.24.51B1AA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF65740008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:01:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NHD62V57;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789462905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJ8CbAqVK2aEgiqfWN4NFXkmv4VYk8DZM71F2uwFagc=;
	b=y0D3OGRlJmJ4oGeAg+uV8jqib5ruZDRKPZ0UTft8gYtV6jujrPKRxWRDK/I6pbMXkdxC6Z
	Zk0Aj3bYv03Qwr09eqCctbvUH2e5Gq8XrwqgXAEAVIpEyQ0grUP2igKT5ZcdS6jf+/GgRq
	iA/lV3+8tRVm6vAKfPiulUggz6IxRwM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NHD62V57;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789462905;
	b=BHk7WPS2KBwD7hXEIgdAW3Vwjd/sJ7DT+fO4dw6EWSMF/pf1JuIazJyCpud3Jb1y+yFVd8
	wEe3BXHqf/xAHo8iev3Id2Pg/8WPfRzYTWxoB0xsiWWpagVmoB5p9IVNRv/+sdqfST9bDv
	PwAWqE0kzEq8KfYTpWn9iPgC6t/GFeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42AA86025F;
	Tue, 15 Sep 2026 09:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D5B1F000FF;
	Tue, 15 Sep 2026 09:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789462905;
	bh=xJ8CbAqVK2aEgiqfWN4NFXkmv4VYk8DZM71F2uwFagc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=NHD62V572xPJ/b/UFoosJzqQZDLqRIj7lYKIwbmiidi3PShI4GU5dw1eZ/fPw/E1w
	 dxOluJN3f5MdHNtsU9guU18PH3jkdDOAUK6im4SFyEoBal3FyClbCXMEDCUMK1w+js
	 kkrE2rlEqZpuaf1hxP7uMo5IcfleTm3+9BDk/pbsnxBbDvEQ0cBdhoRRVcG6j0ATDB
	 I0QcViQB0xgY/DEkvc35yPFUILp1223U6DXOhcrK4NojzL82ZZE1UA79sqGsD5EuRx
	 X3r2YohU6WP7Kz9DSBzyQlTcG5xAxr2DIesZhaHtu3kdkptRpThd5/0qWIkEuQpftK
	 QgNHCGSmBD14g==
Content-Type: multipart/mixed; boundary="===============3452030992566982035=="
MIME-Version: 1.0
Message-Id: <18aa34104b455963bb39e0b34a5c5285543cec411c701b59d803dce126d8c40e@mail.kernel.org>
In-Reply-To: <20260915080255.48929-2-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-2-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v7 1/5] mm: Add copy_remote_mm_str()
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,david@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,ast@kernel.org,brauner@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,kpsingh@kernel.org,ljs@kernel.org,matt@bobrowski.net,memxor@gmail.com,song@kernel.org,sun.jian.kdev@gmail.com,utilityemal77@gmail.com,viro@zeniv.linux.org.uk,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 15 Sep 2026 09:01:43 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: zy6tope649at3nhmkw7zbtjwpx6zdy6q
X-Rspamd-Queue-Id: CF65740008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789462905-342834
X-HE-Meta: U2FsdGVkX1/vBRsAh93hcrcbtgLBAsMhDuGxzLklw6qBGj4fMz2OLdDSpQ7SwfABbQpo0BvFMzeKzOhJdb7Q5edvZ4BKWoIa5q6PcoYpCgFZNMfLODS/JOr5q1xwqG7wuy8QHN8GDI9/HQG1iEYA3ZlGWCjbKqhYSShQaeHjKJc0CTEoNBT9s762mU3BnRFIDh5Of9LHPpV+7jb1vIVOTCVCho0mNm8qHyayyy18RmifvhHWZc5zEXNJQPbNrGKqrSAn7bkFnO2FZhvQ53JXt1Kpwbh8XiK29C13IkmMo03YpVM3iGgmq8RaIikATZdyqLEUGMh2tmdCUNx+EmzoucpxG8Ze+iG5T4pRdMQFyUpEh97xsMO2kT4UfMKhrvx/R3IZRaMA3kQwhvQf2kK1A7/Tuuk04clRPZq91M3fd0WTxBFIM7jCvBbAmk8Yv0+EaccbZ69P++kuaB++T9UPCvRdydr4Uh85QKuwGf0Hy5P1EJq+ooJ3GVS/LqHtjQ2WVGyuflo3XQe6pMy8T/kF87a9FtXqdyAxaSTivpqkpkw1Tj2TJN0AK6BHAb3j+x/V7fBdmPMUK3QJcB0tIrylEHnOzPyXj0xtFeF9eTWxTjrPBykaNTZxq1vlR75IiHexBeeaWdUaU27XRdOFiNWK28mD5AKrvdeaRjJtzAZ4kh4zpXmuzCQLUQYm+mZ/iK7xmRjVyWKqdpqHMfQ1M7NK8ivOd/L5PJR9QDm3Fgk27Cnu1dJvmVxZtJdlUKw1p6uTu9rn2CUfJcFTz7bKdEw5Frm7/vOYSHIIIspSWlC3r2NQQfNmb+lUHgiR9d9E7hJm16pIC+m7JK9l7h652GRDyfusQ3dJ5IrSNWoRt8P145xfUnL/UDqR9z0PEGxMrczcO7ICcLYNKfsg/iBFkNbh/QYb5rFAw9TsXrnZmX9djnQsVVGrn9r+D4dOx0kxa6bkypPMn41/DchFYgxTh3r
 Vv2ViJK4
 wFTV/nqbi6jhHrZJFTlBd1xNlke5xSVoxJYK7vnzdd6VzjoOa2AsfWhMPnbX3ThGQoKvC+dsll42KeNdoGcwWZ3kj4eqUsYXbXNNwx3f1EuuzdDDnVWG1w1izD1PtGY2XF/vsmpD1thc8jE3Sap+yzeVB+t44X/8FSALDbPSNjK0tNxyGapxj7xNm5/w2OeR3KUu3wrtOMoLp2HmKC5Fpp3sdX6dzjEvhYj0Vf2DtzjJ5jWMR3qiH3iM48veVdL7Terc8jFNaQyn5O8LhJt1q45tyPHd49R1fE7eypYkw74BQp4fLSrByBfC1dzHljyJayTN4AJegoeifE5+TfoWF8V198qd2SIH3b1vdpuZArUT8X5xBV/HGGcjCHD/xaSeY4wuJ6ROwIvpOddG41th2umejMMBcjkWhMcbNuk+iL+ujL6zUHy3/73Ucz2N1aSjhko9GYQc10jB5mfQUNOqTqZSht67nt0uZo81Mlx/uQpRxTuOqEsNzlbJNrllpTMQ6oCb7ZMLSqikvAptvtYcv7rJ37AiX3cF3JO2m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3452030992566982035==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23e..63f40e615754d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3325,10 +3325,10 @@ extern int access_process_vm(struct task_struct *tsk, unsigned long addr,
>  extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>
> -#ifdef CONFIG_BPF_SYSCALL
> -extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> -			      void *buf, int len, unsigned int gup_flags);
> -#endif
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		void *buf, int len, unsigned int gup_flags);
> +int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> +		void *buf, int len, unsigned int gup_flags);
>
>  long get_user_pages_remote(struct mm_struct *mm,
>  			   unsigned long start, unsigned long nr_pages,

[ ... ]

> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3de..fe2f5e988fb90 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7331,8 +7331,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
> -				void *buf, int len, unsigned int gup_flags)
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags)
>  {
>  	void *old_buf = buf;
>  	int err = 0;

[ ... ]

> @@ -7407,43 +7407,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  		return err;
>  	return buf - old_buf;
>  }
> -
> -/**
> - * copy_remote_vm_str - copy a string from another process's address space.
> - * @tsk:	the task of the target address space
> - * @addr:	start address to read from
> - * @buf:	destination buffer
> - * @len:	number of bytes to copy
> - * @gup_flags:	flags modifying lookup behaviour
> - *
> - * The caller must hold a reference on @mm.
> - *
> - * Return: number of bytes copied from @addr (source) to @buf (destination);
> - * not including the trailing NUL. Always guaranteed to leave NUL-terminated
> - * buffer. On any error, return -EFAULT.
> - */
> -int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> -		       void *buf, int len, unsigned int gup_flags)
> -{
> -	struct mm_struct *mm;
> -	int ret;
> -
> -	if (unlikely(len == 0))
> -		return 0;
> -
> -	mm = get_task_mm(tsk);
> -	if (!mm) {
> -		*(char *)buf = '\0';
> -		return -EFAULT;
> -	}
> -
> -	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> -
> -	mmput(mm);
> -
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(copy_remote_vm_str);
>  #endif /* CONFIG_BPF_SYSCALL */

[ ... ]

> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d08..47c2e3ae84961 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1061,6 +1061,68 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen)
>  	return res;
>  }
>
> +#ifdef CONFIG_BPF_SYSCALL
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. If @len is zero, return 0 without accessing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		void *buf, int len, unsigned int gup_flags)
> +{
> +	if (unlikely(len == 0))
> +		return 0;
> +
> +	return __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
> +}
> +
> +/**
> + * copy_remote_vm_str - copy a string from another process's address space.
> + * @tsk:	the task of the target address space
> + * @addr:	start address to read from
> + * @buf:	destination buffer
> + * @len:	number of bytes to copy
> + * @gup_flags:	flags modifying lookup behaviour
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. If @len is zero, return 0 without accessing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> +		void *buf, int len, unsigned int gup_flags)
> +{
> +	struct mm_struct *mm;
> +	int ret;
> +
> +	if (unlikely(len == 0))
> +		return 0;
> +
> +	mm = get_task_mm(tsk);
> +	if (!mm) {
> +		*(char *)buf = '\0';
> +		return -EFAULT;
> +	}
> +
> +	ret = __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
> +
> +	mmput(mm);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(copy_remote_vm_str);
> +#endif /* CONFIG_BPF_SYSCALL */

Does this silently drop the kernel-doc from the generated documentation?

Before this patch, copy_remote_vm_str() had both its kernel-doc block
and EXPORT_SYMBOL_GPL() in mm/memory.c. Documentation/core-api/mm-api.rst
pulls mm/memory.c wholesale for exported symbols:

    .. kernel-doc:: mm/memory.c
       :export:

so its documentation was rendered by that directive.

After this patch both copy_remote_vm_str() and the new
copy_remote_mm_str() live in mm/util.c. But mm/util.c is never pulled in
with ':export:'. Every kernel-doc directive for it uses an explicit
':functions:' allowlist:

    Documentation/core-api/mm-api.rst:46   :functions: kfree_const kvmalloc_node kvfree
    Documentation/core-api/mm-api.rst:111  :functions: folio_mapping
    Documentation/core-api/kernel-api.rst:42 :functions: kstrdup kstrdup_const ...

So after the move, the kernel-doc blocks at mm/util.c:1089-1101
(copy_remote_vm_str) and mm/util.c:1065-1079 (copy_remote_mm_str) are no
longer rendered anywhere.

As a side effect, neither block is checked by the kernel-doc build, so
future mistakes in them will go unnoticed.

None of the follow-up commits in the series touch Documentation/, so this
is not restored later. Adding the two names to one of the existing
mm/util.c ':functions:' lists would preserve the previous documentation
coverage.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34946192265
--===============3452030992566982035==--

