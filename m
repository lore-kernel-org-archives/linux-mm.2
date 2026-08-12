Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17497C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67426B017D; Wed, 12 Aug 2026 08:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF20D6B017F; Wed, 12 Aug 2026 08:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9946B0180; Wed, 12 Aug 2026 08:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9129C6B017D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:03:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2029316032F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:03:15 +0000 (UTC)
X-FDA: 85092481950.19.CF54F26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71C87C0009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:03:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYZJHZAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xXHJa1Wu10ODBgrINvgPzFGBKsN0vS4f5IbQsSc8mk=;
	b=jnSQUFUXRrtL1KtbsQ9elBoi5Cvx3OOzHZVM9249j7FaDcz0Uep/MlWLKR1ONFsZ+wzLPw
	y8WgOlxkMyO2jiJYbqC52odfZEB1JoLUSIH8pqgZIuxfVOM1NA8LyD0OLQWZ+giYVHUzVL
	Fq99cy5astAyL8V1g+xMohF9lVACriI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYZJHZAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536193;
	b=1PTvMrJpHSSq1QK406oCns3eF5SCbLIF9Lg8YL3kKfiaGIvefo/dyrtsXKucT8al1PA3Qq
	UmkxIFRIf6LhzNprU0YwQoGEW0E391XXOwEQO+lnkdMmbaYxBUxHbK89YW/pu3VV3kIqye
	o5Mh9V+qIWDk9MBo3d4CvLdNr+KoWrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6580F41E6F;
	Wed, 12 Aug 2026 12:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FB41F000E9;
	Wed, 12 Aug 2026 12:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786536192;
	bh=6xXHJa1Wu10ODBgrINvgPzFGBKsN0vS4f5IbQsSc8mk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=lYZJHZAAoDoW9UdBtVy5MxZkhseCtk9QRv5XB6BdTKbDnknG6MxDeFLiMNIl/192l
	 b3JirXWGs25gOgHIXUvsS+mJMzKo2ThqunZz9NrMojoFpovsXQKpq/YSq8BjW58Fcs
	 tSU3avpnnDHP9p62FI3Sd0WFBcZFP9sweGonaBK6ktUrzUb2JG9xuAQXe5RXyMi+7z
	 M2WFb1w1dlNRm3j8aU6j6tAr1qq8xuuyEcWo947EPJ7czIrzkzjPQuzj9+0V8/OxO4
	 rHeCMvCh+qO9BYf2dGWXVMk+prwgz0juEYvC2+Wixc6hqcMVcV0u0ZDbQ+y68odA1/
	 yaRy2HMSO85uA==
Content-Type: multipart/mixed; boundary="===============3128931104168357247=="
MIME-Version: 1.0
Message-Id: <56a41abb674851cde452dab2c56ca3e4b629acc62a982f418ac6a4ee3b32cb56@mail.kernel.org>
In-Reply-To: <20260812111140.7762-2-tasos.papagiannnis@gmail.com>
References: <20260812111140.7762-2-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next 1/3] mm: Add copy_remote_mm_str()
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 12 Aug 2026 12:03:11 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: undgoq7qkb1qbdifhdnfcdbch6rorjzn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71C87C0009
X-HE-Tag: 1786536193-458459
X-HE-Meta: U2FsdGVkX183w0Mef/mJXZa3sbD20S7DYiJ8VXBCoFof6nZr+FrtFdjyyds/hyMLv7vl1o/6ks3a6v32iwLZyXO83AfSOrsowQ+7HA+RNGrMpDcOcA/TX0tzlgVm/1Be6bBBTRp0IdjIq0teQHOvmcbbWm30NaENEOlSpIL++aAnYChF6bF45HVkgPLmgWBiKs0cPCD2/P5yWTPiKzMdtFkLcpZ7r4/imnrhLynXoPVBYbzmdlincpzNJKjm+7m0IVPcIDTVSnYWQVgIWkVxUrlJmxc3XN6z0olkUAD6mSe1Br9UugNUtXIZ4H+7Su9xk4kh7u6JPB5poyVgzEwkdL/nz/1BNU21mjJE/oF6Je/SvQKot9893gmX+YeE9liGFBhGrhqA9IPeBfAo0OhLiB0xbjgsrJaHy/yt1uSRhv+928Aw2I9uDfu3uxWN/8O6/DQDoZOiRNBT7h4r+wXgxPW5ClH7sHgfmE9nGFELQ+xb+sBLjMzHj2K0J0DVs7D/E9id8egmJsZa4i3Gea449mKVzsH72bkA5JllaNS29Y0+HtYfSq//hyQ1eebXE7kceLQhQtiWiFA8Ft5Ys0beJe3jijU29CCAE22xUQD96+Q4wu4yn2SslXZH7oz5tFuG5nm3Sr0CuitS9Cfv6x4/1Yw8uubxuWSEW0rwui8u+IZS7AfLx79J1cMQDn4TV5e/W8VduJ40HgCTPO/l5IU6UD68lHXBwuol33XTGH79Dre4mtc+upZ8LK/+mWOpAyxRLRKTjx4gmJwWJQsx0A7ZKYeofQDpjc6CXfy8xpPQjHmXxD49ba6mEkPHrf7qRx/pRwqBNkbzB+1wVm327LC7YvF6Bza1CUi90JY5tNKpn7UsBT/x/+SvVo9eJK/U4eTjpIgov3rmiLYGi6T+nDg6tZtsI6k8jwJPPpf8YqiID72VJ1Vh6IOZ3Hig7ToKFLryHMS0pHMWQYtGc2QGUN1
 SxkyXOYY
 E9ICq6ixjeiMER7s19//ToGfpsPJASFPJmMvabnNgumYvf2/AYE0Js9pMX0JifH1nLOipuoqM2z+K72jEDfiL6zx79a46z5UYIEQ5iDMZ+4qBLSMpVWZknLgmrYpfpari8ZBvht/g+R1Txt4406gKGq9yXm+tDBlP7KDfUbGk6nr+mmZGVhZaqvx7IBrN154WlvYdLYvomyOYKw9W+L66P/9Mwb8zlIYautDofbg/cyBx/zrbAvOfRA/mEy+NJm0OQ780Jshtji8LiKl8Fxqxla+QiLuDXjCHHunjm3TFZ5fZIDnxsjpvIilEzBwsc3tXDYw6srUur5My4T5VoxN1VOe65Pop8IL3d6Si2p533A2lrtooJGJYCkCE/WfVq/vtGmNzUdmbrdevjOB9SHSt458ax54uJ9N0/CupNNRIK4lXzfHl/NSIOh4UhjDDSg9EpssPWnhB1cWGFheM0fSolIHean/aEgcOebuqdzunlrScDs/NYGoLIff0iUW2VjZSzSeISYt9XPisraeBF9drL8r0gD2ldfo45u8Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3128931104168357247==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..eede435bf4a3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3222,6 +3222,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>
>  #ifdef CONFIG_BPF_SYSCALL
> +extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			      void *buf, int len, unsigned int gup_flags);
>  extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  			      void *buf, int len, unsigned int gup_flags);
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index 6b8280cfc1db..a70c43d9b17e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c

[ ... ]

> @@ -7218,6 +7218,29 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	return buf - old_buf;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:	the remote address space
> + * @addr:	start address to read from
> + * @buf:	destination buffer
> + * @len:	number of bytes to copy
> + * @gup_flags:	flags modifying lookup behaviour
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. Always guarantees a NUL-terminated buffer.
> + * On any error, return -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		       void *buf, int len, unsigned int gup_flags)
> +{
> +	if (unlikely(len == 0))
> +		return 0;
> +
> +	return __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> +}
> +

Does the kernel-doc accurately describe the len == 0 case? The contract
says "Always guarantees a NUL-terminated buffer", but when len == 0 the
function returns 0 without touching @buf, so a caller trusting the
documented guarantee would read uninitialized memory if they then treat
@buf as a C string.

Every other write path does honor this claim (__copy_remote_vm_str()
opens with `*(char *)buf = '\0';`), which makes len == 0 the sole
exception. Both current callers pre-filter len == 0 (copy_remote_vm_str
below and the forward-range bpf_copy_from_user_bprm_str), so there's no
live memory bug, but the contract is what future non-BPF callers will
read. The caveat is stated correctly elsewhere in the series:
bpf_copy_from_user_task_str says "unless buffer size is 0" and
bpf_copy_from_user_bprm_str says "unless @dst__sz is zero".

Would it make sense to mirror that caveat here, or to drop the early
return and let the callee's `*(char *)buf = '\0'` run?

>  /**
>   * copy_remote_vm_str - copy a string from another process's address space.
>   * @tsk:	the task of the target address space
> @@ -7247,7 +7270,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  		return -EFAULT;
>  	}
>
> -	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> +	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
>
>  	mmput(mm);
>

[ ... ]

> diff --git a/mm/nommu.c b/mm/nommu.c
> index ed3934bc2de4..8fbe6306d074 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c

[ ... ]

> @@ -1752,6 +1752,29 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	return ret;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour (unused)
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. Always guarantees a NUL-terminated buffer.
> + * On any error, return -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		       void *buf, int len, unsigned int gup_flags)
> +{
> +	if (unlikely(len == 0))
> +		return 0;
> +
> +	return __copy_remote_vm_str(mm, addr, buf, len);
> +}
> +

Same question for the NOMMU copy: the documented "Always guarantees a
NUL-terminated buffer" claim doesn't hold when len == 0 returns without
writing to @buf. The NOMMU __copy_remote_vm_str also opens with
`*(char *)buf = '\0';`, so len == 0 is again the only path that leaves
@buf unwritten. Should both copies carry the "unless @len is 0" caveat?

>  /**
>   * copy_remote_vm_str - copy a string from another process's address space.
>   * @tsk:	the task of the target address space
> @@ -1781,7 +1804,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  		return -EFAULT;
>  	}
>
> -	ret = __copy_remote_vm_str(mm, addr, buf, len);
> +	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
>
>  	mmput(mm);


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31592551940
--===============3128931104168357247==--

