Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255C5CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F4D9000FC; Thu, 14 Aug 2025 03:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFF5900088; Thu, 14 Aug 2025 03:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE8B9000FC; Thu, 14 Aug 2025 03:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39C4A900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:15:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4E1F14055A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:15:43 +0000 (UTC)
X-FDA: 83774502966.11.AEEBA45
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id 08CF7C0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:15:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1IKT2zw;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755155742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6l0i4NfoPjd3dy49dR5GfraE/UtvtCZLrPT1jjwn6yI=;
	b=MyxAjULvB8LXufQ7FuWjsmH5SiQqOOdBrXnqOYEauSckhO18ggQc4PqDg3GWOw7/dh+Y9q
	Jhk2E66bWdvJt1rMJackD3c52C7O5G36xLckpJnYHVTytYLuvPwtRilumq156mD564C9QT
	L8mlF4W9IppeT7UIwCbdfvaiF4hrAYM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1IKT2zw;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755155742; a=rsa-sha256;
	cv=none;
	b=MIiWapC7WRtbC8QPYaymmZ3ycIywf+WWUsLo1+YCz7N+ZYfyJk9nvmadUnhu7Tokf+Z599
	qYhkpirP/w+fmgQrKJHZUKSVfL63JazS+1fstvvXfuRlGmxWHlfHCR72supbKplgch3UaB
	W7mclDoQSB9Fhh4fmjgJTCGVMb2ohe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 680755C6209;
	Thu, 14 Aug 2025 07:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A94C4CEEF;
	Thu, 14 Aug 2025 07:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755155740;
	bh=SaB56iFHq9R1lIIJgY1jOBN/SbTeOE8emRCvNnsEoq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i1IKT2zwhssHQnjqKIWtvjwXerI6qQ1PNJ4VSL+eAdBxYbqVIjTYRDr4HQdDI2lyQ
	 u6nsFBnRLyaqgFWWbzOeyOQEECfpnB7HFRoM6E3hO6sGlgss41eOmCgTCj8UDbGGiV
	 kcOFxGN3h7q6PRJ0LFnpAK1twBP/I25c5bcY/wvp+piLO9bOEem5o1u/IyOlnGVqs5
	 L90FI8Llj1gEjlrSGyhD/ENLft+kX+3j3yL1mUP3JUHnDXG1H78KF3wqJLtE+umkB6
	 9qj4v3Wff5u7Gq6G5C3vOrkknrJVOKySTv9AXEbB2AQ2VTkv5un2lOKqSHyQjbbKCj
	 5qil2ya53k7Hw==
Date: Thu, 14 Aug 2025 10:15:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: nathan@kernel.org, arnd@arndb.de, broonie@kernel.org,
	Liam.Howlett@oracle.com, urezki@gmail.com, will@kernel.org,
	kaleshsingh@google.com, leitao@debian.org, coxu@redhat.com,
	surenb@google.com, akpm@linux-foundation.org, luto@kernel.org,
	jpoimboe@kernel.org, changyuanl@google.com, hpa@zytor.com,
	dvyukov@google.com, kas@kernel.org, corbet@lwn.net,
	vincenzo.frascino@arm.com, smostafa@google.com,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	andreyknvl@gmail.com, alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org, catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com, jan.kiszka@siemens.com, jbohac@suse.cz,
	dan.j.williams@intel.com, joel.granados@kernel.org,
	baohua@kernel.org, kevin.brodsky@arm.com, nicolas.schier@linux.dev,
	pcc@google.com, andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org, bp@alien8.de, ada.coupriediaz@arm.com,
	xin@zytor.com, pankaj.gupta@amd.com, vbabka@suse.cz,
	glider@google.com, jgross@suse.com, kees@kernel.org,
	jhubbard@nvidia.com, joey.gouly@arm.com, ardb@kernel.org,
	thuth@redhat.com, pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de,
	lorenzo.stoakes@oracle.com, jason.andryuk@amd.com, david@redhat.com,
	graf@amazon.com, wangkefeng.wang@huawei.com, ziy@nvidia.com,
	mark.rutland@arm.com, dave.hansen@linux.intel.com,
	samuel.holland@sifive.com, kbingham@kernel.org,
	trintaeoitogc@gmail.com, scott@os.amperecomputing.com,
	justinstitt@google.com, kuan-ying.lee@canonical.com, maz@kernel.org,
	tglx@linutronix.de, samitolvanen@google.com, mhocko@suse.com,
	nunodasneves@linux.microsoft.com, brgerst@gmail.com,
	willy@infradead.org, ubizjak@gmail.com, peterz@infradead.org,
	mingo@redhat.com, sohil.mehta@intel.com, linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, llvm@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/18] x86: Reset tag for virtual to physical address
 conversions
Message-ID: <aJ2M_eKPvBluyLKJ@kernel.org>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <01e62233dcc39aeb8d640eb3ee794f5da533f2a3.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e62233dcc39aeb8d640eb3ee794f5da533f2a3.1755004923.git.maciej.wieczor-retman@intel.com>
X-Rspamd-Queue-Id: 08CF7C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gexu45ku468mrgm3zw1r85habygxkotj
X-HE-Tag: 1755155741-750538
X-HE-Meta: U2FsdGVkX18L9e3eLwsgrdv4sLCLEI5YdE+cpzlNyxg4Pffx3PcN8nyno6YVJv5eMsFIxQm0Ikt4ErAEdcO5ZOezpKL4LBtbQK7bshhvUCTw+OZz/Te+e/XA7jq5McoInM6iqGFK/n6meVk01M3mr3EBbZV+oMpkxFI/3O4fszCAVswYZNwFvhIrBm6lYpVnNyk03ydqkjXMf1aXWNl92gWII1p50qfp34gtf+KJCV9DF/cCW3f88CcxHkE8eMF2yZ5JlnwoL86YUSYpJwnMxwNfsErdwS8n+PxZI6BCqmrgzpfssaZ97NulW7dI6QWpkiP0t+Scy3fTVRlRIExLvrd49idVedg2JNJrRWrlNjt5Tia9mrxAoVW7tuHcNzu2hTu7PUuXZboUojKr3tiwQt2F/Qt8VPyjJoEN4Kxc7jUFXDkeA4KVv8J+AX4XyKfjqLsOn6x3mmiv+A2yr+fQMtimqvACB4o75zWMyCNh/YzhF6EW3BgMng78H2zLKkNrBXgk0fWlFIlbUXSIKhVMd/c+ysUa2W5CZdI3yOvxT/3SnbzZ/Ngc8+zhTjcVNTT0kVSgOY0bnO2m/8j0vzKbywRfE0jLbTYCyj5V3J0/TQqDKgjed/iw9ddaLnPa0HqtdVWYjqa3Zr2S80277IIe8qiXVVrUhIiTutKU4rqewWOs7LbKNOE36PiKh9JvZNCbk4RHhr1J+9y1JfSo1jXgSN/QlxG85sRfP+C7Q05KzvMTZEv1g+CCOqQULuu/j9Hv4/6iAHa4yEJDxerz9kfaLy6Uv0mO5lShT6iy3FRlkGjW7Tki8pY56FvH060xWTMfI1vDWejP+tmRcJga2ShMSJa/JxXyK1nVj2bl+Hbshk2saARmc8zEmdjfmUvKFOhY08w36m5mOXHIuGCoqFpxmw4XBy7sJX0Ck/aItw94lGto8CDZAF9DY8FWPy7TcE4J9/smpNGYkWWrdUltrUG
 a5QomlK8
 5hfupFBqXAjW3moAcvKGoIwMtofhkIlaL1MuT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 03:23:42PM +0200, Maciej Wieczor-Retman wrote:
> Any place where pointer arithmetic is used to convert a virtual address
> into a physical one can raise errors if the virtual address is tagged.
> 
> Reset the pointer's tag by sign extending the tag bits in macros that do
> pointer arithmetic in address conversions. There will be no change in
> compiled code with KASAN disabled since the compiler will optimize the
> __tag_reset() out.
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Simplify page_to_virt() by removing pointless casts.
> - Remove change in __is_canonical_address() because it's taken care of
>   in a later patch due to a LAM compatible definition of canonical.
> 
>  arch/x86/include/asm/page.h    | 14 +++++++++++---
>  arch/x86/include/asm/page_64.h |  2 +-
>  arch/x86/mm/physaddr.c         |  1 +
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index 9265f2fca99a..15c95e96fd15 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -7,6 +7,7 @@
>  #ifdef __KERNEL__
>  
>  #include <asm/page_types.h>
> +#include <asm/kasan.h>
>  
>  #ifdef CONFIG_X86_64
>  #include <asm/page_64.h>
> @@ -41,7 +42,7 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>  #define __pa(x)		__phys_addr((unsigned long)(x))
>  #endif
>  
> -#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
> +#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(__tag_reset(x)))

Why not reset the tag inside __phys_addr_nodebug() and __phys_addr()?

>  /* __pa_symbol should be used for C visible symbols.
>     This seems to be the official gcc blessed way to do such arithmetic. */
>  /*
> @@ -65,9 +66,16 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>   * virt_to_page(kaddr) returns a valid pointer if and only if
>   * virt_addr_valid(kaddr) returns true.
>   */
> -#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
> +
> +#ifdef CONFIG_KASAN_SW_TAGS
> +#define page_to_virt(x) ({							\
> +	void *__addr = __va(page_to_pfn((struct page *)x) << PAGE_SHIFT);	\
> +	__tag_set(__addr, page_kasan_tag(x));					\
> +})
> +#endif
> +#define virt_to_page(kaddr)	pfn_to_page(__pa((void *)__tag_reset(kaddr)) >> PAGE_SHIFT)

then virt_to_page() will remain the same, no?

>  extern bool __virt_addr_valid(unsigned long kaddr);
> -#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
> +#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long)(__tag_reset(kaddr)))

The same here, I think tag_reset() should be inside __virt_addr_valid()
  
>  static __always_inline void *pfn_to_kaddr(unsigned long pfn)
>  {
> diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
> index 015d23f3e01f..de68ac40dba2 100644
> --- a/arch/x86/include/asm/page_64.h
> +++ b/arch/x86/include/asm/page_64.h
> @@ -33,7 +33,7 @@ static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
>  extern unsigned long __phys_addr(unsigned long);
>  extern unsigned long __phys_addr_symbol(unsigned long);
>  #else
> -#define __phys_addr(x)		__phys_addr_nodebug(x)
> +#define __phys_addr(x)		__phys_addr_nodebug(__tag_reset(x))
>  #define __phys_addr_symbol(x) \
>  	((unsigned long)(x) - __START_KERNEL_map + phys_base)
>  #endif
> diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
> index fc3f3d3e2ef2..7f2b11308245 100644
> --- a/arch/x86/mm/physaddr.c
> +++ b/arch/x86/mm/physaddr.c
> @@ -14,6 +14,7 @@
>  #ifdef CONFIG_DEBUG_VIRTUAL
>  unsigned long __phys_addr(unsigned long x)
>  {
> +	x = __tag_reset(x);
>  	unsigned long y = x - __START_KERNEL_map;
>  
>  	/* use the carry flag to determine if x was < __START_KERNEL_map */
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

