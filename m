Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DD5CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 17:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEC78E000F; Tue,  7 Oct 2025 13:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696AE8E0003; Tue,  7 Oct 2025 13:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2CA8E000F; Tue,  7 Oct 2025 13:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8AE8E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:02:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7CF0119316
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:02:00 +0000 (UTC)
X-FDA: 83971935600.28.7583898
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27F3D180028
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:01:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GVsXKOAn;
	spf=pass (imf24.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759856519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9l0/6zUDNO+xCl8q1KIbKj7hrUlRaLHv0kidIMcKjU=;
	b=yzYy3f14K5p1U72aEB+1ahrK2CUcX8vLWex1ZKiEMOS7TWBFd7a6ZLr2DsnpnsDBYJBS3A
	wsZywW/ZCckeSroLZ8pIL9C1B7HqW8NUhL1xYArRm7+s6G/ku+rYMmORcoffr4kGyQnNq2
	tHWa6r2zZXiwur2ip+ZLjTtLgXy+6z4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GVsXKOAn;
	spf=pass (imf24.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759856519; a=rsa-sha256;
	cv=none;
	b=sZchaconQYExVV4oZYTymUqB9m2LQEAKXzQp31Sa7ZKGeyu7Frf95asBBowTc4j8eapfC5
	1NQTJZ5qtF+h9Fc/mH/3PSAVbUB5nBl2bMLTLNv+NCuVGvmtbwHCoBvq+CntwOvnXLz+xf
	DC3zxsJ8IR+zUbRlZyduKIxhX24Pu6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB1E3407BE;
	Tue,  7 Oct 2025 17:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8520DC4CEF1;
	Tue,  7 Oct 2025 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759856517;
	bh=MR5qWTAOW1zVyTLdPwwD9muosMP83f5qZfp7s+T/8Hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GVsXKOAnGQWHMUvRXJC+HD5Ptm4rKk3wxOY0m04k1/vuFPLEHYh1doW38jWqMNOMW
	 L/7qM0gkru7kkBntPfDcFUXYAL1plH+dhqEAgp+KQ6vTxlekXWdDnfOns9KPwLbeXH
	 Elolz6FA56YCumDWpBov0HylXOdE0TORtEJ8uImPWRAVl/pzLNrlxZgxIFye24JnY2
	 J5+nyBymaFOYpMgWzoep6qXlaii0EaJtnDWnfxt+SO/HNj+0bkgOqNlQbtV/G+dOlz
	 GeHfdBkrc7bZc9x2Nx172su4AQjqB0A+lLDzUAZQS0AUQTskSrERr7EU1U5QnEltLP
	 5wtZOGCn+mO5w==
Date: Tue, 7 Oct 2025 10:01:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: acsjakub@amazon.de, akpm@linux-foundation.org, axelrasmussen@google.com,
	chengming.zhou@linux.dev, david@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterx@redhat.com, xu.xin16@zte.com.cn,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] mm: use enum for vm_flags
Message-ID: <20251007170156.GQ1587915@frogsfrogsfrogs>
References: <20251002075202.11306-1-acsjakub@amazon.de>
 <20251007162136.1885546-1-aliceryhl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007162136.1885546-1-aliceryhl@google.com>
X-Rspamd-Queue-Id: 27F3D180028
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: oqoiwmskqiz1swia5abwqg33ohg784fp
X-HE-Tag: 1759856518-226994
X-HE-Meta: U2FsdGVkX19fws1ExEsXRQHqRAAUC+UfNfOGRtwkXgJNCsAgR8z0N89+mlB2lidSRmwgfIEUSvR3j6Hu+ggFWXFFGgPpn017Izqflxm2Cq/TBJXkQ7bC/wtcFTp828oLVL3k3DYs7fmbxgg24qQy/H9TvZE84Irp/Sf7s0PIAdvYoSI9b4LnpuuAcjhtj7Fypkyjnovm2tUy0sip4YrmmAmOzv1//0kniGEA/lxCd8R7ZFNx0fev7pTOn2QvS+uXG5ERPbx8rBXkbotl0B0koa2dFU0nwjrGBOQlHbsjX5BaftNY5ZCDdVBedN9XxeY+VxS00HNnF724eGC5d/LEBpAcGGm9uf2263fhGh+QCcjXcF9+qBRAH2MITtz7CL8uq7O7WF+3/tkHawpL9AagoYIQ825YAJDj4AFciZ8iAAFBUrtg/YX4nEfLHivqF13p97KbKeCD6Os/NhqNdrbfKgG5VaAsVdRgVfdByMQS43hXxVXR0GsUgl+rrqSyOvtfeu5P7YS6NaWT62FC+YPwty2hXVGywvs+bTLHmjNC4bahHhn0ktHzP7+yKiHj014BYwnulN0C5Bp54bV/8WR9x/NEesGngkfaoiGvvIDounJQcG6aXXKoEmTEFePMnKtlWeB5JxYM5MhP5v8snBoaSa8ZWzFdqmG2bSISECxxnfvQhZFNSsBXw7BFmZyP/xQxWGNNUcP3MhlvuBjGOchzBo0Vufj9aaXW7N1mEuSANKcZTw5bmf2y9w7Fq6dIUgwIYUTG1lNR7cA89rDZicVu54h2f1w8Zh3vS1iY2jEfMDBLQKs4GUf3ho2bQd34ErEXlfZGkUlQhl4eG+c8JgAFUMTlaYM+Z2ahGsVopsMA1fGewVB292UGTin5FMtpJVW0ssPNaLb4Sq7GMccHh4RU4Uzps020lcolAzU1yyLSWRM7H6KsxRUQ2wRTiuoges10P+P8AXRjKTBJvawec+S
 ZytyA8L9
 rXU2t9r1oOhK5dTNlGyZNG3PtzOziETwDSzNToWdjJxXtEQw26CEEHfJtcQsaNggBw9Lm6E8xXQMN/MT+MjSkiP42zvhrhwrBl48MW6yvyj3SAJ1hxzyVEG32DgQCYNVHaeWONjf1Tq0jD1zDlT6nAwJWv54rO7mQZBmhuc7Q4nGuuJ/PYMQqzjgT4u5Q+neGqKtaGYgul/I5VL8dMZGBaym1LMVo+Yd5cVsxdsaLBLerpFs6pvqgvE9t1bU10/fnC42l/Evw7HYTp9hBpYLL+1+hZlc8JcKRSB8n/BpvNVVMo9h9Yu4B+6tXB9DUq2kUtyrtsJttFOtnubDKwxAL1BMLTc4QmYIxgzKKl7wT3LU4c83568PLoMYyjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 04:21:36PM +0000, Alice Ryhl wrote:
> The bindgen tool is better able to handle BIT(_) declarations when used
> in an enum.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Hi Jakub,
> 
> what do you think about modifying the patch like this to use an enum? It
> resolves the issues brought up in
> 	https://lore.kernel.org/all/CAH5fLghTu-Zcm9e3Hy07nNtvB_-hRjojAWDoq-hhBYGE7LPEbQ@mail.gmail.com/
> 
> Feel free to squash this patch into your patch.
> 
>  include/linux/mm.h              | 90 +++++++++++++++++----------------
>  rust/bindings/bindings_helper.h |  1 -
>  2 files changed, 46 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7916d527f687..69da7ce13e50 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -273,57 +273,58 @@ extern unsigned int kobjsize(const void *objp);
>   * vm_flags in vm_area_struct, see mm_types.h.
>   * When changing, update also include/trace/events/mmflags.h
>   */
> -#define VM_NONE		0
> +enum {
> +	VM_NONE		= 0,
>  
> -#define VM_READ		BIT(0)		/* currently active flags */
> -#define VM_WRITE	BIT(1)
> -#define VM_EXEC		BIT(2)
> -#define VM_SHARED	BIT(3)
> +	VM_READ		= BIT(0),		/* currently active flags */
> +	VM_WRITE	= BIT(1),
> +	VM_EXEC		= BIT(2),
> +	VM_SHARED	= BIT(3),

mmflags.h contains ... a lot of macros, but I think if you change the
vmflags to an enum, you have to wrap every value of that enum in a
TRACE_DEFINE_ENUM or else __print_flags on an array(?) of {value,
string} pairs stops working.

Concretely, I think show_vma_flags (which uses __def_vmaflag_names) will
stop working here.  I'm no ftrace magician here, but AFAICT the third
argument to __print_flags is stored verbatim in the tracefs format file,
and the userspace ftrace tools use that to convert the raw data into a
user friendly string.  For whatever reason, enumerations aren't
converted to their underlying integer values by default, so the
userspace program can't do the translation.  TRACE_DEFINE_ENUM is a
magic that makes that happen.

<shrug> Don't mind me :)

--D

>  
>  /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> -#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
> -#define VM_MAYWRITE	BIT(5)
> -#define VM_MAYEXEC	BIT(6)
> -#define VM_MAYSHARE	BIT(7)
> +	VM_MAYREAD	= BIT(4),		/* limits for mprotect() etc */
> +	VM_MAYWRITE	= BIT(5),
> +	VM_MAYEXEC	= BIT(6),
> +	VM_MAYSHARE	= BIT(7),
>  
> -#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
> +	VM_GROWSDOWN	= BIT(8),		/* general info on the segment */
>  #ifdef CONFIG_MMU
> -#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
> +	VM_UFFD_MISSING	= BIT(9),		/* missing pages tracking */
>  #else /* CONFIG_MMU */
> -#define VM_MAYOVERLAY	BIT(9)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> +	VM_MAYOVERLAY	= BIT(9),		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
>  #define VM_UFFD_MISSING	0
>  #endif /* CONFIG_MMU */
> -#define VM_PFNMAP	BIT(10)		/* Page-ranges managed without "struct page", just pure PFN */
> -#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
> -
> -#define VM_LOCKED	BIT(13)
> -#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
> -
> -					/* Used by sys_madvise() */
> -#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
> -#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
> -
> -#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
> -#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
> -#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
> -#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
> -#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
> -#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
> -#define VM_SYNC		BIT(23)		/* Synchronous page faults */
> -#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
> -#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
> -#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
> +	VM_PFNMAP	= BIT(10),		/* Page-ranges managed without "struct page", just pure PFN */
> +	VM_UFFD_WP	= BIT(12),		/* wrprotect pages tracking */
> +
> +	VM_LOCKED	= BIT(13),
> +	VM_IO           = BIT(14),		/* Memory mapped I/O or similar */
> +
> +						/* Used by sys_madvise() */
> +	VM_SEQ_READ	= BIT(15),		/* App will access data sequentially */
> +	VM_RAND_READ	= BIT(16),		/* App will not benefit from clustered reads */
> +
> +	VM_DONTCOPY	= BIT(17),		/* Do not copy this vma on fork */
> +	VM_DONTEXPAND	= BIT(18),		/* Cannot expand with mremap() */
> +	VM_LOCKONFAULT	= BIT(19),		/* Lock the pages covered when they are faulted in */
> +	VM_ACCOUNT	= BIT(20),		/* Is a VM accounted object */
> +	VM_NORESERVE	= BIT(21),		/* should the VM suppress accounting */
> +	VM_HUGETLB	= BIT(22),		/* Huge TLB Page VM */
> +	VM_SYNC		= BIT(23),		/* Synchronous page faults */
> +	VM_ARCH_1	= BIT(24),		/* Architecture-specific flag */
> +	VM_WIPEONFORK	= BIT(25),		/* Wipe VMA contents in child. */
> +	VM_DONTDUMP	= BIT(26),		/* Do not include in the core dump */
>  
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
> +	VM_SOFTDIRTY	= BIT(27),		/* Not soft dirty clean area */
>  #else
>  # define VM_SOFTDIRTY	0
>  #endif
>  
> -#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
> -#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
> -#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
> -#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
> +	VM_MIXEDMAP	= BIT(28),		/* Can contain "struct page" and pure PFN pages */
> +	VM_HUGEPAGE	= BIT(29),		/* MADV_HUGEPAGE marked this vma */
> +	VM_NOHUGEPAGE	= BIT(30),		/* MADV_NOHUGEPAGE marked this vma */
> +	VM_MERGEABLE	= BIT(31),		/* KSM may merge identical pages */
>  
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>  #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
> @@ -333,14 +334,15 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
>  #define VM_HIGH_ARCH_BIT_5	37	/* bit only usable on 64-bit architectures */
>  #define VM_HIGH_ARCH_BIT_6	38	/* bit only usable on 64-bit architectures */
> -#define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
> -#define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
> -#define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
> -#define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
> -#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
> -#define VM_HIGH_ARCH_5	BIT(VM_HIGH_ARCH_BIT_5)
> -#define VM_HIGH_ARCH_6	BIT(VM_HIGH_ARCH_BIT_6)
> +	VM_HIGH_ARCH_0	= BIT(VM_HIGH_ARCH_BIT_0),
> +	VM_HIGH_ARCH_1	= BIT(VM_HIGH_ARCH_BIT_1),
> +	VM_HIGH_ARCH_2	= BIT(VM_HIGH_ARCH_BIT_2),
> +	VM_HIGH_ARCH_3	= BIT(VM_HIGH_ARCH_BIT_3),
> +	VM_HIGH_ARCH_4	= BIT(VM_HIGH_ARCH_BIT_4),
> +	VM_HIGH_ARCH_5	= BIT(VM_HIGH_ARCH_BIT_5),
> +	VM_HIGH_ARCH_6	= BIT(VM_HIGH_ARCH_BIT_6),
>  #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
> +};
>  
>  #ifdef CONFIG_ARCH_HAS_PKEYS
>  # define VM_PKEY_SHIFT VM_HIGH_ARCH_BIT_0
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 2e43c66635a2..04b75d4d01c3 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -108,7 +108,6 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
>  
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> -const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
>  
>  #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
>  #include "../../drivers/android/binder/rust_binder.h"
> -- 
> 2.51.0.618.g983fd99d29-goog
> 
> 

