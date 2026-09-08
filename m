Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F56C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC8F6B00AB; Tue,  8 Sep 2026 09:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C850D6B00AC; Tue,  8 Sep 2026 09:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C4E6B00AD; Tue,  8 Sep 2026 09:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 953D36B00AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:16:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27A7380628
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:16:42 +0000 (UTC)
X-FDA: 85190644644.23.930A15D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7060FA000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:16:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqeTVtVP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873400;
	b=zzw68yOXMq85h6ptyC+crEsdYh5gSjmLlTfsl/2TGICWa1bNErUep9royKfg3dbolnktoD
	PQV2QFazfQXEw4zlqTUM+dIsxC4BEWXYFAul02QhpRH1ZIYZgUUIYsLo7iU/paOhAPkMG7
	i9BcGIh5hOimjc32dgpm64+9z7+gQks=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqeTVtVP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGoipUCnVkQSnrYlG4JuuefvC9x1Ssr7yfDjVV3fi44=;
	b=UfJ49VoQs/ORz9saRZc0GVuQe6Z3qgN0r7kyM5J/bYls0otWSp5vluKMks+OxZzfP2TxA4
	1wx/iCQBCixknZSq7DZx1x8QXKEoIZ+XJkSkMipoj4rlQFVowzYoGZMJ1wvqa9X+BdaDKM
	nwUj0vYqiugsuIM6kXB0bGaDNAXM02A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97C7A40A68;
	Tue,  8 Sep 2026 13:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0B31F00A3A;
	Tue,  8 Sep 2026 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788873399;
	bh=eGoipUCnVkQSnrYlG4JuuefvC9x1Ssr7yfDjVV3fi44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oqeTVtVP8J4gmkOV/vgaJdwrdFmePsueOXneNkP0K3ZCZxNy/XbNk+Mz3u8yPvv8B
	 rSJcvMVytF2Wex2GWEtxw3Jmo/U6steSK88MCOpPV2qzOXxtFldeoPnZu/oJdcDjjM
	 mhW11GCOVUtyhlrgmqkMBozE9lYJzkTafjcL7YGglsbBZ90n9rZK1JNJBFwQBLyX3i
	 laZwDs0zTiur85XZaUXHRw3RmT77Vb9vNnQ7FsJYwfisjB5J6eGu5yI97mQ74KEz+f
	 9Bj/yI275o/CX6460g5dfvsVUaGHS9oLnUWg3xP8vYkXlOQL1RZnt0vrBDmJZTYTvW
	 htwTGDeZI9OXQ==
Date: Tue, 8 Sep 2026 14:16:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org, 
	andrii@kernel.org, ast@kernel.org, brauner@kernel.org, daniel@iogearbox.net, 
	eddyz87@gmail.com, kpsingh@kernel.org, matt@bobrowski.net, memxor@gmail.com, 
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com, 
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v5 1/7] mm: Add copy_remote_mm_str()
Message-ID: <aqAKY6dtdxN_cUMi@gremlin>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
 <20260907165220.52431-2-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907165220.52431-2-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7060FA000C
X-Stat-Signature: zk3dx4tpo79kters4iitpsh8ausohytk
X-HE-Tag: 1788873400-671956
X-HE-Meta: U2FsdGVkX1/fVvPk3EGA3YWJoAMw4gQvPuZhBhpAhhXP6diU6cAu+ENTtboGH14JFPRmpkvsec/tw9McZe4NhIfG7icpewPE6VyLLNxcNk+lc160TYR0PGxHQEH6jIuXxJpcVIvs+hSGGYmFIOb4FcTiKQBGRpcpzEWB3KB7MMj2GCNsAJrqwXuURiviqoZA7UfyAYwe98o3Lj1xAazC5qShAbbsbkzBkABNwD/NNh4HC0Rbs95TtlLuBPtgTKHYIz1Dt6qQv/K2JuoOwHX4Hg3qGhOkChS0nJzrAV612xjMYZSbs0NZPp/Atenl9f7esME8kVhirl3x3yrTOVgds/+ECCXyIVlsrpxpi0dRAK1c8HVpu96A+vlDWWrXkMu5o5hKqI13R/dC5fADv7CqhzNPZewCrCguHfWOGbLTcTobSiCXbmPLBq2IP8Y4rExLW+Zbye4+ap7XZnaarfRv+aXWzAYqs6G4b7yiJa94tgfafkfunw4z2XGTcFfChJq/jy2fSt6LuzFhahXODntW1Wols/v558ckhG60fKiDYx7scuq5mlosuBnUHJBKSPYuF+yML+jgxQfFOJkeIqQ8zMYTlappw2auCTTwYq7NSc7HlJHGDFJ+wstCOoXeIR5VZnNY1RG7J1xb4dstUN1K54btllxInxYDZRLydeZHTo6yWsyHbqlVlSQwongaIazVVaU5ZdwbeeL6DeLLewyB0m5P8HBKH3v8ds5l4q1f4jS48uVQ82kfjdeKEvbd6obfXkI065K7ZuhTipgY/eCLr5zo3B20RKKjfPZe6RP6IlonBR6YOd8tn53y4P6u11yGiOTMR82e9hbZpQNxP5d0bJYQgHom8QLXqOGT6LR/cZ9AykxaQhYRBNBCAvs+YlRzPed5gsASxyuJPz4gFzWnJwtStk/r07nklT6MpsYT1dV8qLpuUpYAT/nmKp4mIqC1ZByIB00oN0MaSqQSnPF
 aBSd+xLr
 oh1cwid7F2Mzaq2LUcfgxnuFpP+13KlraGAs0fSLl1UpzpNqhtBaWFVWeHARQh5KG74yFIht9d2GhraFCxzEfwHdfK6vYdczKdhqDv7cuZJam2xY44TAvBlgUMMm0lWKzU2pRHw2Uaz+GGOApFt+XJsLbawRIfkUGpRMm26Y5uRZNzaYAnnpY+0qqJJ8oYPE4U6vqp5nrD2LinWna2Yo1CcMmqje5xS82TPxG1rJ5rmap9VXxd+/86z63aLrmlxwV4ErgOimSmPs0rjO1YJvb45nhIUF1Sx2SzOrKMbKLLlhBFlU1UoI5dnuamIHABYCU36ryMU/tm0Ai9z8jCahmlXModVwzYgyEqRXPCdov66hQhwz3AcdVDzIH+w2iX62h0yZAhMPk3SRwvpbLZRoW0CXzVh8/74HDn3g6yw2GeAd7mmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:52:14PM +0300, Anastasios Papagiannis wrote:
> copy_remote_vm_str() gets the target address space from a struct
> task_struct. This does not work for an address space that exists but is
> not yet associated with a task_struct, such as the mm held by struct
> linux_binprm during exec.
>
> Add copy_remote_mm_str(), which operates directly on a struct mm_struct.
>
> Use a common internal interface for the MMU and NOMMU implementations
> and define both public wrappers in mm/util.c. Preserve the existing
> copy_remote_vm_str() behavior, including handling zero-length requests
> before acquiring the task's mm.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

OK actually doing it this way means we don't have to worry about
__copy_remote_mm_str() at all since we abstract it with
copy_remote_mm_str().

With David's comments addressed LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h |  2 ++
>  mm/internal.h      |  5 ++++
>  mm/memory.c        | 41 ++----------------------------
>  mm/nommu.c         | 41 ++----------------------------
>  mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 73 insertions(+), 78 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..d5bde1f71a97 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3326,6 +3326,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>
>  #ifdef CONFIG_BPF_SYSCALL
> +extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			      void *buf, int len, unsigned int gup_flags);
>  extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
>  			      void *buf, int len, unsigned int gup_flags);
>  #endif

Same comments as David :>)

> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..8264a346d18a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -25,6 +25,11 @@
>  struct folio_batch;
>  struct hstate;
>
> +#ifdef CONFIG_BPF_SYSCALL
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags);
> +#endif
> +
>  struct huge_bootmem_page {
>  	struct list_head list;
>  	struct hstate *hstate;
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..fe2f5e988fb9 100644
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
>
>  /*
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b0..98596e60311f 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1746,8 +1746,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
> -				void *buf, int len)
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags)
>  {
>  	unsigned long addr_end;
>  	struct vm_area_struct *vma;
> @@ -1781,43 +1781,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	mmap_read_unlock(mm);
>  	return ret;
>  }
> -
> -/**
> - * copy_remote_vm_str - copy a string from another process's address space.
> - * @tsk:	the task of the target address space
> - * @addr:	start address to read from
> - * @buf:	destination buffer
> - * @len:	number of bytes to copy
> - * @gup_flags:	flags modifying lookup behaviour (unused)
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
> -	ret = __copy_remote_vm_str(mm, addr, buf, len);
> -
> -	mmput(mm);
> -
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(copy_remote_vm_str);
>  #endif /* CONFIG_BPF_SYSCALL */
>
>  /**
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..2eca27b02791 100644
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
> +		       void *buf, int len, unsigned int gup_flags)
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
> +		       void *buf, int len, unsigned int gup_flags)
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
> +
>  int __weak memcmp_pages(struct page *page1, struct page *page2)
>  {
>  	char *addr1, *addr2;
> --
> 2.55.0
>

--
Cheers, Lorenzo

