Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E84C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D696B0095; Fri, 18 Sep 2026 08:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774E96B009B; Fri, 18 Sep 2026 08:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AFF6B009D; Fri, 18 Sep 2026 08:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 497756B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:10:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 980AF1A060D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:10:01 +0000 (UTC)
X-FDA: 85226764602.21.B99C737
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E384718000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:09:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="clNlP/xG";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733399;
	b=T4JiavgAeXsl3bhH6+187k/R8LCT7S9eamcUcVPPV2tW4lzAWxWiQqvx6kGcCibQ6HeR2H
	RenO/lpvpeGWETwqnZm43xhtuFNNCfDkcF4rBo1lTM/ekfOyFrB5qys3oKcw52Fuf23e3X
	mpm3tUgfBW4sf0MNq31e95NqUjnTFls=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="clNlP/xG";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Dehqwl8OGnNMvcjzS5vLDo1ZS/hlXfR5Zt4WV//DR0=;
	b=tn7zDE43rUe+5IzMdZy8ilK/w/gdPaS5Rk/vAVQVo1u8Ve9UsZ5XzC+sHOZljJ1LklwzCi
	4YH1e17JN56zW4DezQiPKTnFTNnSkL4uQombNrQvqX38ziUJgVkIll9ri8gBSWUQ7kj9Ub
	RhUNXsX0ptWPSwRKsRFZj8hOFBhgZCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7213360A82;
	Fri, 18 Sep 2026 12:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B61F000FF;
	Fri, 18 Sep 2026 12:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733399;
	bh=3Dehqwl8OGnNMvcjzS5vLDo1ZS/hlXfR5Zt4WV//DR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=clNlP/xGNon7MI8X0RjFpqvHuijI7yEviOueWkwQNnOTpUBtP0pbS9wIjxljNYqRU
	 +QVzNz+3n0uAYKkQP0jJ97EYpcKgrs8BwsxaD/W1oGuLVMGjv9JcVoGH3bVOnWDpXG
	 41S624vt1Z9GU/9sG6gKST+Pl/dSR+8fTSh76gwlQlkWDjOIlBl+pRsJSLNoOpHDAS
	 YSdpL2ltenZ3wQD1k4fLqpWaHRSRX3ri0qQRmL/YCc2u/ldqY+s0K+tRgBCA7ZHwVK
	 SwdMKABhOtCpc9oyOImFGdzGXroxWLxMj+kS4i928FZc/EapKOMrS1cYPD8+kGZnj0
	 BeyFnnNNj9Qjg==
Message-ID: <0b276f0a-39b7-46ae-b72f-6ba92f65380f@kernel.org>
Date: Fri, 18 Sep 2026 14:09:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v8 1/5] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>, bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, andrii@kernel.org,
 ast@kernel.org, brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 kpsingh@kernel.org, ljs@kernel.org, matt@bobrowski.net, memxor@gmail.com,
 song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
 viro@zeniv.linux.org.uk
References: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
 <20260918091058.297740-2-tasos.papagiannnis@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260918091058.297740-2-tasos.papagiannnis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E384718000D
X-Stat-Signature: z1h6bnczhs3uewwc6aho9if53wxfhsji
X-HE-Tag: 1789733399-32653
X-HE-Meta: U2FsdGVkX19w0JKOu/cnVUdHGGgvk8VSszOhUWF/r94r/++6eHeycX7PgObAlis7Xx0Vrq/67Ju9XgMeeODcpADqHTvH2RR9MdfsjEj2zvcSDuFumichS9oYiPpQFpbBf/+dJKkrBcD3ketNbkfFieP+nUZ18tPRDPzKzJVxaJoqcBjn5LnpTzmO5Eb+RQMfQwX77Wx8XuvpGy73nxjd0kxAKmgMt6b4KIzc9rtH4JmGcu+LpcoufaJHxyjd6fxTgOmsuZ11evkqjb0qk4+55DsBwLrVgCHN2VxrRFcPfOU/eA8/HQVj8nFW0pqyuJBua36CY3PmkpiQs4Pomb95czKcZ9AyfmwjtDh+ToYeYh5fNDGpCNGJF3tbwtYLsNuDM7CGS7MwGZfks4/eDGSpGkYhCinViKt9BabZW/CB4nBJMSALKzeh9jnlUUYY3R0IqYlCWKWt+jOJWWr0MphP/UZZbuKY08jUpUN3dDFYkBJHtCmNQ0edsLegH+yKCxlqw/3NEJ35RbMNyYQZro9kf6RXz5FjcmouhbC5oxMJXuRzvkfVSPlX0VEvHmIpw6LTwijUnnvMfwooMv0FaDS/XE4/vX4RmcMZPCDSkzvWYWxu056FdOdHvoySz+CTNpsjnpvdIAAbSHSxxOWPTC6VKlefNWzYAv5yyr4hCu7O7c8KhLGyZQUbI54xNDODaxrf0wcd26MEcS1XWziMiqEKhxxiUoH+8CGk961pHaWo3WnA4J3yBxUZTYF81F08dIPZdCrYAg2L/h0cL9/3141zWCyhcpUwdl36RmjMA1Y40E8WDv/cyDvB0rgMDu3ii4xkpJHLSPQ7E7/VM2xJIB2T5twrcT32yi7ZC5Wskl39tW6tny+anWudNdA2fMn9ZifnpF2rfzIhDS+V5iAnxfV8fF9HMefPRkqoHmSRwlUTp1wLH+JGXI4NwJEssYOoTOMLDAbCXyG4eztQgymjsBT
 9QxUXh1O
 En02f+wcGe0zBuenBcmkDBd6MOOjhO/G9xs/fRPYz0XBpJCIlgAKMydXoGZBdGb80HL8S0yC5pMLhvoMyHr1tLf8oer1539q0ycTmLZFhp2Z59YP/nHJeXHzlnZGPbM8dtWT0KT/VBokuZdQjU3+rklPD9V4F0tI+5Prs1/nJ95Tb5kcjXydTWS6BY701xElVqC7bPDO5S4dJrihbQTGr4OzKm9/eTqVtV7OVQ/5/jmRbPUfUwidS1XV8PVBQevUhnBFbgRaj1Cv8GBrXUARPTaxKL/UbNoamDEjH5MYqQJUHn3Oo62RHU4Sn18eRGw4MeZZQy4WGS+iUYbxp6p9jPhpooBIX6JoT0/+MQuf+fatg9eMMF7W28UrUy8NT7U17f4BXP1BiuzseNjP3E8G+oArln7Uy+ARXveVGR7Xq+wo6kZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 11:10, Anastasios Papagiannis wrote:
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
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mm.h |  8 +++---
>  mm/internal.h      |  3 +++
>  mm/memory.c        | 43 ++------------------------------
>  mm/nommu.c         | 43 ++------------------------------
>  mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 73 insertions(+), 86 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..63f40e615754 100644
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
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..557b29381355 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -25,6 +25,9 @@
>  struct folio_batch;
>  struct hstate;
>  
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags);

Two tabs please. (I thought I commented on that already)

> +
>  struct huge_bootmem_page {
>  	struct list_head list;
>  	struct hstate *hstate;
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..fc6933d7e9d3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7326,13 +7326,12 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr,
>  }
>  EXPORT_SYMBOL_GPL(access_process_vm);
>  
> -#ifdef CONFIG_BPF_SYSCALL
>  /*
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
> @@ -7408,44 +7407,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  	return buf - old_buf;
>  }
>  
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

Dito.

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
> -#endif /* CONFIG_BPF_SYSCALL */
> -
>  /*
>   * Print the name of a VMA.
>   */
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b0..9a810c35e7e9 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1741,13 +1741,12 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>  }
>  EXPORT_SYMBOL_GPL(access_process_vm);
>  
> -#ifdef CONFIG_BPF_SYSCALL
>  /*
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
> -				void *buf, int len)
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +			 void *buf, int len, unsigned int gup_flags)

Dito.


I really couldn't care less about the pedantic doc things from the bpf bot.

-- 
Cheers,

David

