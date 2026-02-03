Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A9FE8307C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9C96B008C; Tue,  3 Feb 2026 05:17:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363B46B0092; Tue,  3 Feb 2026 05:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2525E6B0093; Tue,  3 Feb 2026 05:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1347B6B008C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:17:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC21014041B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:17:17 +0000 (UTC)
X-FDA: 84402742914.07.103DCDF
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf22.hostedemail.com (Postfix) with ESMTP id BA080C000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:17:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=lUAE2uVq;
	spf=pass (imf22.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770113835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIz4RVwkv6KARy4MwQOhUdd22JeZFr0fFrNF7J4bRPM=;
	b=6mtqhtKnFrtKfw+sG0O0LyCAptmP4WVquNC6zIOeJSpoqlWMbodB7h8GLZQTtHiz0E4bdt
	iWxHN6Pc5rK7jQM0Nv7dNLr7R7DRcXn1GJF16b9WTes/ZmKGXe9jcj7GgDKA5kyZuPfovr
	Y1gDbF1327aPUjX5dnzSvUeJdyeH2Ws=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=lUAE2uVq;
	spf=pass (imf22.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770113835; a=rsa-sha256;
	cv=none;
	b=xWDmd13cV+PtaJ/lXtgmCFp1Xv+MBbd7pl6di3FuJO+gRMxE/iGOsOctT03nAvnAeTBluE
	7bhZ3gSmTubXPmSWOcLhWKsAfWI9t+32aZsf23RE8g4Qe9N58DMN2T3zzkuiUK2zGgV8pz
	sJ8S0pCNJ6vZEhc0RR+JAsyrEA0yzzI=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4f4ztd00Nsz1FDXZ;
	Tue,  3 Feb 2026 11:17:13 +0100 (CET)
Received: from [10.10.15.18] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4f4ztY1CK4z1DHbc;
	Tue,  3 Feb 2026 11:17:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1770113832;
	bh=bIz4RVwkv6KARy4MwQOhUdd22JeZFr0fFrNF7J4bRPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lUAE2uVqAzYhZ1sm97fYuqy+vlFYURoO/ESgRDOLYwoPcj+AJLYcKftxzXr+4y/HX
	 2YOyDda3zoXt+26+AX8pMM7QHh5T+XJuM4W03HRzJukix5g8rdsb/fjilKm09oxzSx
	 tBwy+nern6bg1a50/KfLMYddppMeG7txUbC4/AmsAXT1tuu3+smPwBXiUUqokjSpVv
	 UUsrhLX04O7HNQNLLVmIA6iNk0y72m91fWDt4UXVjn71WutyJfQfTM3K8uFvvtoUBz
	 jIXUHdgIYTlrZQBjHS4KV4lgMsEWYt8Uw9Kgk+K14XLmF28umAniXCSL8090kqia/S
	 lC0jknJm/j/RQ==
Message-ID: <ec965a79-dad8-4358-a8e9-ebc9f330b67b@gaisler.com>
Date: Tue, 3 Feb 2026 11:17:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260124095628.668870-1-rppt@kernel.org>
 <2157220c-0394-40fa-9918-a8514171bd10@gaisler.com>
 <aXj_x5CyUeys7ONM@kernel.org>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <aXj_x5CyUeys7ONM@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA080C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: mbkkq3gutm5uytow1mkqchbnyj9ca7x1
X-HE-Tag: 1770113834-367313
X-HE-Meta: U2FsdGVkX1+gBpTWX+CQGX96+Vz8aaFiobAZV8uSyGIty1G7NE5f8kH70XYffavCdhJs4wpi8N0Of5dThZn1XOHjSZKr83mc19hIFDcVLZysa4E1w7MJSyfeTGjhZ0BSevGhTRyTw/NtdJoUFNY6nJq+1LX03GZXwayXUW3XPKG5oyChDoQS6dZAwHuPYUWi+8fCozS6O2B5UEJmimlajIiOEWKAP+A+INqcESK2c+qh0vb5n29qgVTTT2NUJmKP9plHlrXnBiQXbOe14yfA8O4tXTsFqZvJvU3S88pBG/haAntNNshnbb19pXrlEd4z9VW+QyQ59D1vXY6XMnKYKT6AKb+CvFA53LC88c2/B8nADTwUYXVpDnGXSrJuOElpAySGrQqUUD0MUlMxWwww915ddzbRN7ykVw4mBfWtHMC5zoa8CH8t00jnbpp9hDZuFhh7PVkyHGMhIBC7ZeEmBH29o1nzWuuVaSazbnMZewM2g9unfKDPBvbuD8QtQT4rZvLVeFA5jRaPSzN3AtdAz1Q8WezkzgDXNV8leZdV0pUQ5wQemMYMk+lJ3f41WTPnlDLPBwHFsAdcTixWdJce1B2tqlOdVXQDtR43Xe22KVgfnEvyREOJRXnpF9ekLYK9LrgOhJ2ZFDDR+Rn406gdSDa7VP3TeIx/b5FGKLdgZwFEBqtceO1psHSs5mvcJwezjJ/XokUk0M7Bv/MdKBRTemihsdxmOuOb85njxtyo+5G8SWtiGHE4MJfg631ZGwjU1/KZStbCzS0l3SU1/q8oOMMcdiwSahmYOLovAri6YwjOFWXeC2XpNniM+LEZy20LWkhF4nvjwIeSM+9PZLpS65z3MbzwpKRDZeIbKFFPmDTMPG7hp+FPm44KHdpak2uLuCHFo0tzr5j1JezjOJlP2D51R0wXagqDEZftUy+VHW7LGeQnNXmESr/jFU2whscykCEoSHr7Vc+bMuxhBx6
 +Z+B/ay2
 lOdNTRot0P65xqtSnNnyEID0LBfgEal4Fhr5ZAZ1YIeENsUK7jmWbNRH8mB3B27ZLTBKz1FOeLNzg+ndUoTNG4kHUNH79gutU93PoHv7r1hYOoBaCiFX6imqXETPXj0qDF0y8GUWQAQd/dP4bkR8FjWT7OPc5G35O+xmgqj69FnMfC06Ej/OmhW8nE0hXOfzK51gFdgAmiWT6szqEtxyrBOP3OHgx0V4COrVZdAZ1rR4l2aG8/fbn6T3T/ZdBlrUhcevgZAC7+VR8c2m5fywiF4o6GiP97jJGgJS75P7MhNBDjaD09JXrug/Br/8JNSnaV4w4H5VTLJYNeNU2HCTRlfJNl0QAAGOw9qrH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-27 19:11, Mike Rapoport wrote:
> On Tue, Jan 27, 2026 at 05:02:39PM +0100, Andreas Larsson wrote:
>> On 2026-01-24 10:56, Mike Rapoport wrote:
>>
>>> Every architecture defines empty_zero_page that way or another, but for the
>>> most of them it is always a page aligned page in BSS and most definitions
>>> of ZERO_PAGE do virt_to_page(empty_zero_page).
>>
>> Running this in an LDOM on an UltraSparc T4 sparc64, the entire LDOM
>> hangs after a while during boot.
>>
>>> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
>>> index c2d19c9a9244..2bd99944176d 100644
>>> --- a/arch/sparc/mm/init_64.c
>>> +++ b/arch/sparc/mm/init_64.c
>>> @@ -177,9 +177,6 @@ extern unsigned long sparc_ramdisk_image64;
>>>  extern unsigned int sparc_ramdisk_image;
>>>  extern unsigned int sparc_ramdisk_size;
>>>  
>>> -struct page *mem_map_zero __read_mostly;
>>> -EXPORT_SYMBOL(mem_map_zero);
>>> -
>>>  unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
>>>  
>>>  unsigned long sparc64_kern_pri_context __read_mostly;
>>> @@ -2506,18 +2503,6 @@ void __init mem_init(void)
>>>  	 */
>>>  	register_page_bootmem_info();
>>>  
>>> -	/*
>>> -	 * Set up the zero page, mark it reserved, so that page count
>>> -	 * is not manipulated when freeing the page from user ptes.
>>> -	 */
>>> -	mem_map_zero = alloc_pages(GFP_KERNEL|__GFP_ZERO, 0);
>>> -	if (mem_map_zero == NULL) {
>>> -		prom_printf("paging_init: Cannot alloc zero page.\n");
>>> -		prom_halt();
>>> -	}
>>> -	mark_page_reserved(mem_map_zero);
>>> -
>>> -
>>>  	if (tlb_type == cheetah || tlb_type == cheetah_plus)
>>>  		cheetah_ecache_flush_init();
>>>  }
>>
>> This just removes the mark_page_reserved(mem_map_zero) without 
>> replacing it with something corresponding to that. Perhaps part
>> of the problem?
> 
> I don't think so, empty_zero_page is in BSS now an it's reserved as a part
> of the kernel image.
> 
> I suspect that virt_to_page() does not work BSS symbols on sparc64. Can you
> please try with this patch:
> 
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index 74ede706fb32..0578c5172d4e 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -22,6 +22,7 @@
>  #include <asm/adi.h>
>  #include <asm/page.h>
>  #include <asm/processor.h>
> +#include <asm/vaddrs.h>
>  
>  /* The kernel image occupies 0x4000000 to 0x6000000 (4MB --> 96MB).
>   * The page copy blockops can use 0x6000000 to 0x8000000.
> @@ -210,6 +211,11 @@ extern unsigned long _PAGE_CACHE;
>  extern unsigned long pg_iobits;
>  extern unsigned long _PAGE_ALL_SZ_BITS;
>  
> +extern unsigned long kern_base;
> +#define ZERO_PAGE(vaddr)						   \
> +	(virt_to_page(empty_zero_page + ((unsigned long)__va(kern_base)) - \
> +		      ((unsigned long)KERNBASE)))
> +
>  /* PFNs are real physical page numbers.  However, mem_map only begins to record
>   * per-page information starting at pfn_base.  This is to handle systems where
>   * the first physical page in the machine is at some huge physical address,
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index 2bd99944176d..d2d724ba4f83 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -170,6 +170,8 @@ static void __init read_obp_memory(const char *property,
>  
>  /* Kernel physical address base and size in bytes.  */
>  unsigned long kern_base __read_mostly;
> +EXPORT_SYMBOL(kern_base);
> +
>  unsigned long kern_size __read_mostly;
>  
>  /* Initial ramdisk setup */
Hi,

Unfortunately, that does not help. The LDOM goes down in the same fashion.

In QEMU, with or without this extra patch, I get this:

[    3.310674] BUG: Bad page map in process mount  pte:ffffc800016436b0
[    3.310778] pgd:027dc000 p4d:027dc000 pud:027d8000 pmd:0269a000
[    3.311686] addr:000001000020a000 vm_flags:00100077 anon_vma:fffff80002688548 mapping:0000000000000000 index:8000105
[    3.312449] file:(null) fault:0x0 mmap:0x0 mmap_prepare: 0x0 read_folio:0x0
[    3.313622] CPU: 0 UID: 0 PID: 46 Comm: mount Not tainted 6.19.0-rc5-00269-g28acabacf9b0 #22 VOLUNTARY 
[    3.314056] Call Trace:
[    3.314182] [<00000000005e822c>] print_bad_page_map+0x10c/0x260
[    3.314375] [<00000000005e9f30>] vm_normal_page+0x70/0x80
[    3.314400] [<00000000005ea5a8>] unmap_page_range+0x4e8/0x13c0
[    3.314421] [<00000000005eb54c>] unmap_vmas+0x2c/0x120
[    3.314440] [<00000000005f781c>] exit_mmap+0xdc/0x440
[    3.314457] [<000000000047193c>] mmput+0x3c/0x100
[    3.314477] [<0000000000479e94>] do_exit+0x1f4/0xa00
[    3.314494] [<000000000047a83c>] do_group_exit+0x1c/0xa0
[    3.314511] [<0000000000489b28>] get_signal+0x8a8/0x8e0
[    3.314529] [<000000000043be24>] do_notify_resume+0xa4/0x5a0
[    3.314549] [<0000000000404b48>] __handle_signal+0xc/0x30
[    3.314687] Disabling lock debugging due to kernel taint

Cheers,
Andreas


