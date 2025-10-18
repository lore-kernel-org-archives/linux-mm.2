Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF35CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 09:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD5E8E0006; Sat, 18 Oct 2025 05:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795388E0002; Sat, 18 Oct 2025 05:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB3F8E0006; Sat, 18 Oct 2025 05:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58A2C8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 05:53:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A2D41A040C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:53:14 +0000 (UTC)
X-FDA: 84010771908.27.C12C7D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39E59A0005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:53:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PVM7dGcE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760781192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5m34w+YJySeDMAg4oYbPewI29W2a9gKFrrQ6A/Z98U=;
	b=8Rw+wXC1KJngTrDVL9j0RTri5P4UlJcvcszHL9kO6j1QNsBaNj5DDCA2k6Ct8oswTvFnDT
	pNHpbAmbZBLyzC/E/NAZUdTbOdqNzRVWrAPSFq9P6WR+Bt/iO8n7ylRaSgsoYR4ekALggy
	rTcAF5BX4szT2apg0zRTQ3mKq5OWEvE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PVM7dGcE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760781192; a=rsa-sha256;
	cv=none;
	b=qREAUDQVo8VDrbmsccdphIzmqPqxpidHZa4/ikro/DyFEUS5Xi51aq53dugDlqwBMtziDQ
	7b3XJBl0doWpSf88EZkCl+b7G9lB0gOf3zOehi3ogij8d8RhgohrGTwHrJag5gLqppmFbq
	RMuxg+HSlXiZAWhCA2YNcl0ng5nEIA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A913045000;
	Sat, 18 Oct 2025 09:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A979DC113D0;
	Sat, 18 Oct 2025 09:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760781190;
	bh=bOSmYzha9caq7PhodKTKcCoPiLt+2LlIcLfZyClR6tI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PVM7dGcEYXCuz8kq+FQlif5GkokSxvCHTzAFAGwTnR8/6weD/vKEUQASmePsYFC3h
	 +euqjGf0PMyAFk0ZJUt5YM7wZxnuKR0UvscN4IWjm71nso3T24TfhImRIqQfyI4ss6
	 cv+7XmuLUObCGPTep6i88M7y6u+ifbhyfVbe1BHS4zD5ALzPNDk/kx15zhKRwL0t27
	 dMmFhLM5KTioGdUJieNshqGCPzeMSFbHvJviFEJxzNeYiuG1A5BFkxDb8ilKL2vLrA
	 8jv3n05kf1if0vj2NPnC/QhhCj3HuD1WtyN73Zhx+EyOOZxPqW3faoSHxWvYSohg6r
	 KlyEFQZJR/qhA==
Date: Sat, 18 Oct 2025 12:52:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: Re: [PATCH v3 05/13] mm: introduce CONFIG_ARCH_LAZY_MMU
Message-ID: <aPNjd2dg3YN-TZKH@kernel.org>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-6-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015082727.2395128-6-kevin.brodsky@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 39E59A0005
X-Rspamd-Server: rspam03
X-Stat-Signature: 4pr1t7dnni6kkcwqcg4mbpp5jutiqoii
X-HE-Tag: 1760781192-351970
X-HE-Meta: U2FsdGVkX1+wsxUsyV6XtWvki4zE2vObIiIlP7AQQlwm6B9TJ+IhsYiAzuAF2jqzKw4O9QkR5bxHXvI8ymfMLj3SkZbxulhImYxuzBZv6Q++mHnqaHySWuIYTr1MM5J8ELJEl+b4YzfBDdYYTErVAx1iScLPJ+i+IZtVTwMoB/JEMAVDdZqd5lpSTj2/BTtxlN8uk/p3vY8ZVGmo5VK2ll894q2WDXLcutNsWzGt20lUSibLgSQepqwFpzPppmxn75kfJDBl94UX4C0SQN/aLfgZN2FuS8mXOghA2PXXblZMtrT5p2pkZDPsZqm/IVMZwUeSzZ2cseXvs59650ZrcINmjSUb9dW3hEdXR4ctz75QXJTUWDe3lyKoXGgdV/bAUV7sPevTdN0R+VeGJgEbmiHtJHYYo4SzVAdZEeF7yCVR5bmryxFI76qxwDSbeefWCgpHC50Q7OntXrSb9SB03x6174cR+fFgSWht8nRWVioYM1uCgTpmPqPGT9oXHKyKmkEJCswbBips4YbMUGH7Sy7hVN7Akeb/LWfFVLfhK65hnVGora2gkq7070bbrLWlJuZoO6RS2TWXt3I7tG3sWZoIz/qqfUG+wMw0sr45+uIoJ+CFi5xEzMFcye2ecGPKLO/DFZnwuBth8lA97AhttfuGxRkvN7bhz0sfjp7CMRvQvTgo5rZGEsGa9fjx3Z1sHpiyYWPPcO/cZBz10PibDqVhA5bmgJMPjFcDGLUwsnzAElDjBZRYK+TqYQEOUEFWQ+Et22yRJPJEJPs5gmonxl4tyyud6Doz84ZIAEqgR+vxkUUXzaTs3Rec8FMJkWUVAilFcq0kHXHS0r2JhZLU3LSmEJ9/Kl+Zm+/DztlDqvsYxQxYn2EYucvg605milOYTQVRhn2G8ce+7Cofxn0MH20kX+IsH/PDGTuwGIFXOA3lAkmtcKd872xx8wVDOn160m9yhCJdXDtIDOrWvIY
 uTiAIrXz
 YBRZkN/0EzSgKNAsVDWEQs6aXQaXEUK/pv7qhbbiYJIygPB4xJBeJhpIMeUwXnraYECvMM/ljw75fxQ88sYLNrir68wwEUw3ga/7HW8dRK7jvkrMVNWPTgZrzHaTQMTU8Ftab6uDSIldfH5mwbYekXCe2CMw53xe+lKM1RYE5x8EkTs3mX6fD5fTJc2Q2bgzGEtGO9tNd7iPDNKKmQi9/3rTvWyCtIJc/xEHTWSX6rNOgfcDh0DwdpQGKVlQSU4TsVGqKG6Ez/QODNEtoj1nrt6+67bDvgSCgaYjZD2B2yqQhRViSyR7s6twE4tWthuNnuuvnlcHYGrb2XAQk5sz+mP+WN+sWAXLsuIsYYy0FM3rRyQaapLUp7Q+jBqzd2OPe3zdZz3/xyUBnUOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 09:27:19AM +0100, Kevin Brodsky wrote:
> Architectures currently opt in for implementing lazy_mmu helpers by
> defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.
> 
> In preparation for introducing a generic lazy_mmu layer that will
> require storage in task_struct, let's switch to a cleaner approach:
> instead of defining a macro, select a CONFIG option.
> 
> This patch introduces CONFIG_ARCH_LAZY_MMU and has each arch select
> it when it implements lazy_mmu helpers.
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
> relies on the new CONFIG instead.
> 
> On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
> selected. This creates some complications in arch/x86/boot/, because
> a few files manually undefine PARAVIRT* options. As a result
> <asm/paravirt.h> does not define the lazy_mmu helpers, but this
> breaks the build as <linux/pgtable.h> only defines them if
> !CONFIG_ARCH_LAZY_MMU. There does not seem to be a clean way out of
> this - let's just undefine that new CONFIG too.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

...

> @@ -231,7 +231,7 @@ static inline int pmd_dirty(pmd_t pmd)
>   * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
>   * and the mode cannot be used in interrupt context.
>   */
> -#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> +#ifndef CONFIG_ARCH_LAZY_MMU
>  static inline void arch_enter_lazy_mmu_mode(void) {}
>  static inline void arch_leave_lazy_mmu_mode(void) {}
>  static inline void arch_flush_lazy_mmu_mode(void) {}
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717..2fdcb42ca1a1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1372,6 +1372,9 @@ config PT_RECLAIM
>  config FIND_NORMAL_PAGE
>  	def_bool n
>  
> +config ARCH_LAZY_MMU
> +	bool
> +

I think a better name would be ARCH_HAS_LAZY_MMU and the config option fits
better to arch/Kconfig.

>  source "mm/damon/Kconfig"
>  
>  endmenu
> -- 
> 2.47.0
> 

-- 
Sincerely yours,
Mike.

