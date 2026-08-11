Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 133D6C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9276B007B; Tue, 11 Aug 2026 08:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42FC6B008A; Tue, 11 Aug 2026 08:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32146B008C; Tue, 11 Aug 2026 08:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85A266B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:40:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AF381403DC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:40:12 +0000 (UTC)
X-FDA: 85088946264.25.4695648
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 948C440005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:40:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9N8+DZv;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxrOVr5HxDqaoiC9WxtikIvK4xWnONmhDLyUEnlmH2o=;
	b=0gxeUzKp6wtPguIsq9EfIw5dpAKsA3oI2bqhTHgBWBycp1HtqPtIrgZf+nl8pqsDGntbFU
	GHDendZQ2x/Nd05Y8WOi3BPylGiaNNBO5zsVrrJYfOcUHg0hJBE0zlYEJGgRgT7HwqYk33
	LnTewkmxi1o2VOP9FjM6UNb630UpFJs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452010;
	b=4QOSaVhufMYaeKXnwbsfSJYta/3TA/PXCZp9Fvm/F6PQCfpWrTWXTFPiZvVoD2vi7hxS5/
	l+pa/pZ786lVNQY+KgWYrHOFt/UeGpqH2PlsyU/hYwR+/Yuye2nDcb1VOPvTsTI0Fe4q6P
	rL4hZVDKU7nFMx6XlEj27cF6xbr6p0Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g9N8+DZv;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB502600AD;
	Tue, 11 Aug 2026 12:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE181F000E9;
	Tue, 11 Aug 2026 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786452009;
	bh=XxrOVr5HxDqaoiC9WxtikIvK4xWnONmhDLyUEnlmH2o=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=g9N8+DZvbLkOsMZrOVrA/iDVvSGk3BAWNF3H/vcBxvOI8bw+qBquB+D++W1n+56tc
	 g2btHK/nuktiHGAO6A7X5t1mobFhhRQqlpAIYNsBUcd5GtEpeStOiMmA1DI7uX0pbC
	 bWSOvFaNWKaONlr3fwRi9Qw7knPiJ5HqFuSv4faho5J7y5fPTCBukM85Xtea41znYy
	 QMQ3qLmEuY39BVP7VFVjRktEg6xFxbuF/4dn8vLuadRzOQZi5KqUwcYQnyaWV/LBPD
	 Doqf8y7kmb+Gy3fwNm8uYqK1M9kgKHwzvMcua9UeqUh2hzEzMv+85luGww3TDChk4z
	 nakxeo2Gmry0A==
Content-Type: multipart/mixed; boundary="===============0710016926348867863=="
MIME-Version: 1.0
Message-Id: <299058c99d38b45741b08ee0e3a85006536716ae7d54de805c7873d32690cf62@mail.kernel.org>
In-Reply-To: <20260811112154.94053-2-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-2-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next 1/5] mm: Add copy_remote_mm_str()
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 11 Aug 2026 12:40:08 +0000 (UTC)
X-Rspamd-Queue-Id: 948C440005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rnc91nogjw1r54gfk8ac1k61nohepais
X-HE-Tag: 1786452010-927765
X-HE-Meta: U2FsdGVkX19x+Q+NRdmcM0HJEpxip76DL9SHr0/HfC+2zEt8Cw7OmsAgR479ZzYQTTFB4QR6nnr210FyO+9T0HXdxsh1t77Q3C1JV2COtt4Gs000BI07WnOYO7pyrzBuwZkF00hQKb9sXsDfyWQdkvtMnyg+nDTnvSrJB6VXnCetMlqGAfgAyZD3R07vy78TwPCXs59MRdscakhZFIgtKwArwX7g+qOgUXNIUHmENt+uw2tqUj+4R7LrWdKRjXKO/vqr8Aj1TpZq4K5NQDcGiSxEwareVY7k+PosrTgsPXNCp+usBQZXFCT69UQbdgKps9Rzh03aqsMQN7o4cpTHOIgvU5fyNbbWb40TvUbsm933pmBT0mUb1WndCPsMCd/vRjt1+GFWvVNa4W9fJHkenLnb7BFnvOIsVDluLzoQHs9RAGhBBh43/bYP5mwmbX45VuOklxzeFyVoF9cD6+kObveGglMSy+60+2alZ9qSGljmMyd//9fHRuqL7p3U9XZL5HSYn5R1ghfvxvmhsZgc+jBnB6rsPgUpkzCLq09vWoBr9XdQQMguBO9xUhgUOKMJacvHUzvL9Is/9CUIoTZMhNTWc31/aZjvGHV4CLMGM8vgili6WM06AAk0CuOxLouxTlVGjUpr7ydHOqs6zHvEpwnJFYOjJLytyO661KF1syTPujbJ8+GKOJSvIHinNde/Ci9s8WuIaHQ/Fmi/opKPT7mYVjpmPXKBiNCgazsUdn6XHZ75WT0kh0BYCrnXO8sfPRsb6wzR7auYme06Rtaidxi3F23LB7KSD3BiIBdqq/A5Pljo7yhK0qA1ViP4s1smLdqMk2cxCtPm4Xn+Oou55YoyN1um2L4gLpr/i1ndCiM14hM62KLjEV29l7WY0iOcILhaVp/BCqdlMPdQB0Xx4h/Wp9hOezVEinU/0b18vwXioHz1WFLg8lbKT+EcUxk+7PAqXB0Wgss0FggGybj
 i++SgBGr
 JhK/Loh7fqPdMUojexT+dyyiGRzUTrIULePnzwD5nK3Kavuvs+lm7LXrVLAnLf356jVyjTrO2k4KxceKcAd5ppG3r0nR5kO1MDw+K2OMPIbHh7wVIf7sbXrMzt8MBc90CLz4x9pQMsILUt6dxlPrljC/dkIUWueYXUb2JkMU83AyJv5Tyczyr09v4Q2LkXxY/jZx5ilJSNmI5FUkJaXNKQEom7gaXrIRIzyAmMEzO9WLtduQsCQ63g8QMT98qb+DBCGGHmIc1di2fsdWf/NgwFpsEncFJy0xe84CQBZ+LZKAsyxM59/zlzNbEFYKmdH4E7io7NCOxWXioRu9Hq8idG40pfKIDQwPIiNtsW8roKwp0+W1DXZ5jvHbobiydIqYiF8mrC43QM/TjUwVR0oG9LEPne7rZIN0ri50LQIZDcjpBwbgPF80nFkCA+qkrW2WaZIifONCdd+uJy52HpDh1SLf6qGxZhkUOzxUg38hg+zfZOhw+u0Elx62csuPS/wHvVMJMVNtMS/qfiZO9IGAztYsmlfO48cABZbbW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0710016926348867863==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm: Add copy_remote_mm_str()
>
> copy_remote_vm_str() gets the target address space from a struct
> task_struct. This does not work for an address space that exists but is
> not yet associated with a task_struct, such as the mm held by struct
> linux_binprm during exec.
>
> This patch adds copy_remote_mm_str(), which operates directly on a struct
> mm_struct.

This isn't a bug, but could this last paragraph be reworded in the
imperative, e.g. "Add copy_remote_mm_str(), which operates directly on a
struct mm_struct", to match the changelog style asked for in
submitting-patches.rst?

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbddb..eede435bf4a3f 100644
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
> index 6b8280cfc1dbe..03cbd3b02befb 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7218,6 +7218,29 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	return buf - old_buf;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour

This isn't a bug, but would it be worth using a tab after the parameter
colons here, to match the copy_remote_vm_str and access_remote_vm
kernel-doc blocks in the same files? This is the only kernel-doc block in
mm/memory.c that aligns parameter descriptions with spaces rather than a
tab.

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


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31488001112
--===============0710016926348867863==--

