Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69332C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC026B00DE; Tue, 14 Jul 2026 11:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56BD26B00E5; Tue, 14 Jul 2026 11:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4339C6B00E6; Tue, 14 Jul 2026 11:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 186DC6B00DE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:09:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2BDCC03ED
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:09:32 +0000 (UTC)
X-FDA: 84987716184.27.B96596D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8A3518000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:09:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zu45SdRD;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784041770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Go9xu294vQ/xZtWM33cFG/GQMdagVD3s+eiqGDNT+vo=;
	b=ChI6+4HdIXun5SHN7k4Cx2Qox5wQCo/g9EDCXn+KXYeFiURxejMEQk9fxMlus8JPU/05tc
	SVQIzSEHNkG3ILG81hHEWmPByze6rYVPsDruF/2mCq7BYtvIHdFj6EU+R/1DyyuU6phagE
	ZX1kUOClFNS0nUFRSeTVh/Irqzv7fPs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zu45SdRD;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784041770;
	b=aLcpqNhOF6MrN02aIcq25N2Wd7fdWm1JH9+lE2MImlINvgyB1r8tpxq2foFg/TASphGfS8
	RXLmx5mrSYW23Yq9Rpyn6qVEeIAnO2WhH0R/B9r/nkbB4d+zGVw/LxCThXjEbEo8eGv741
	OLMzkt68aVENiniUdlz7L58otnVeyss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784041770; x=1815577770;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SHzp4jQz8eCvIdV8ejmgEgUpbyhbt03HpKcF+s/pm00=;
  b=Zu45SdRDUpTedchym1+CAPSKVM3OLxjH46haJbX64zEWibFBVyGX5Hyu
   irekaMSiTwRkBKD2bjw6BNloegglXhfKpw6twcKT5RfVXP9Grd4VvZRPZ
   GHvkEmtqWfW+G58L781tlaZQXx+3dTAIriSwcRbdKPBG81nA05KK63tO5
   JPTjBEGJ0KdxZ+u91bkOibpnzkFKxC3T9R3VQkxFiK6kU6iIswLtCer5R
   w9Kp7hxavztIYEeLTzPH4+PhRAC/tt+/m+/vBqi8I3DKzJaDvY3SIHQkH
   kj2AQcddH3MZgpBSrB2At3+vZX9aWoEJUsQZToOT2m7RYvxzEQxRtKISr
   A==;
X-CSE-ConnectionGUID: cqBNoTBvRL2yXyzCQGyCXA==
X-CSE-MsgGUID: KCBAslVAQhusv/ZF/wRWZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88344357"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="88344357"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:09:28 -0700
X-CSE-ConnectionGUID: b6dfcSKcQJiv0EAhPLDFYA==
X-CSE-MsgGUID: 47aAtZOESKmlSCqMXmHYjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="260186915"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.120]) ([10.125.108.120])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:09:12 -0700
Message-ID: <bd773d0e-557e-4d87-8c34-7e20cef52135@intel.com>
Date: Tue, 14 Jul 2026 08:09:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/22] x86/mm: use mm_is_kernel() for kernel mm checks
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-12-44be8a7685d7@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-12-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8A3518000F
X-Stat-Signature: 9dp6opisy39qof4s4wtam7cxjcfdwqmj
X-HE-Tag: 1784041769-728990
X-HE-Meta: U2FsdGVkX19p+70AUeve6rSfJ5kAgXQ+MOEe6++RTthlKNDcfTrLFmUclkRHaVSvCZIwLWSF87ZcddneZ3sPKZLoFrmzCru9evpDDCyBLu9LuF3IrHrAhL+KuqY1FkkT5BiOwwc8lCpfuadlI2MrYgQ/IP36dYdk2Wv/AUXRdC78k7LzqboaIYtlWO/LJVO6XgDyWRSR5QkhmWyA+1ue92vA0aPectIBCy/79Pxm3ACm1ObuYOrNAGriB3q+Oe3QeZ/0fjRJWruvhE7vo06IaXv10r3Mwn+l4Nbht9stSAADQxZ3BeFsI3tBFsZzYDdsRKaCrq1VCoRFGiBmO7K3+T13zGQ/kve0ACkHisDQTE4RJ8P1WmhZ+QqlFEmP2AKBUltEwfZhwuD+a/TmFazcek2Fb67iuGgUlHqg/1yXC8G1pQzNArN/hhBUid+b0i7O5qgtg/E2iWKDbg+3UvEGnBESiifhLC8yR60bvv4sss70jQncLOAKDpGmTcOpom6p2wJm6z1tiY09qUD6V0QlFRobALf3YF1BtKRpZnR3yg7O5ha0lFW5gaqxrR+eIAVLd5qYGCGEvk+uiU3sU8hoDCnc2RvR7Np55iVRJ6pebxO3UYjM8ZmZLSFFt/XasL459ZJP4POkVF9s9uUaHiAL0PmrGDBVUEvSqwxeAyFdzEauuXNeQLnrrsOcaaN3Z5sI/F729ZkpXesw8in9dRRbgMoK1jccBohHXaQFgyBQ0xZa2UpqZrxW++9NwymUFGcw3UyJRHIF212sXbHirUfyqcLrwbSMyhVW0oFrAOkkMTdhu4db7Jt6c2pkHsL2qcDU6tcNwij7dxPvkREtAL8my8Etu5nV/ldfYaIISJb1qtYZwObm9tfxhmQDdeeySu1KQCJwMT7rASTcYemgHvnKVGM0PaZkQCPeXjY8AMPRmpkmQv8pz+BpzoNJHo3Nydi/RpXRIxLqxNulBEPAMAj
 abc9MKb2
 TOgBeILdMahgyxBeca8Zj6wD8doEVgHXbKK59Y5TR8LMbehxctr4LcyL3CseBthOI1owg+nAosa4p2RjGN7GkRFO4svTd0QrjWzpNw0bdJ0oHOynWC7hb3ZeXFiC3s0Mr/pQC1Ud/Z9HQljwbyviEoc69QMrDiJh3OymrkD5uroztKeZnJICoMNmkqlA2EPSGuyfI6A1z/FYbDUlIrHriA3FaR2r6MY4CkWuiCrUwS2vjkHSjrrUdUDqBmIpLxc2psZeN4+nmYog0U4Pd2OxoiQKx+ap/Q51g/o6fXFpJbS+9FxlmHhHu8f22UlvaUrhENOM3GX87mnBiBDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 07:04, Kevin Brodsky wrote:
...
> @@ -188,7 +188,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state_shared, cpu_tlbstate_shared);
>  #define enter_lazy_tlb enter_lazy_tlb
>  static __always_inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
>  {
> -	if (this_cpu_read(cpu_tlbstate.loaded_mm) == &init_mm)
> +	if (mm_is_kernel(this_cpu_read(cpu_tlbstate.loaded_mm)))
>  		return;
>  
>  	this_cpu_write(cpu_tlbstate_shared.is_lazy, true);

This one makes me nervous, especially combined with the efi_mm changes
later in the series. init_mm really is special. Before this patch,
running on init_mm qualifies as being in lazy tlb mode. After this
patch, efi_mm qualifies too.

Is that OK?

> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index f32facdb3035..91d2a6f2ac5a 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -168,7 +168,7 @@ static int preallocate_pmds(struct mm_struct *mm, pmd_t *pmds[], int count)
>  	bool failed = false;
>  	gfp_t gfp = GFP_PGTABLE_USER;
>  
> -	if (mm == &init_mm)
> +	if (mm_is_kernel(mm))
>  		gfp &= ~__GFP_ACCOUNT;
>  	gfp &= ~__GFP_HIGHMEM;

This hunk is probably fine.

> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 1023acadd8f8..5517cab8ad00 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -594,7 +594,7 @@ void leave_mm(void)
>  	 * This needs to happen before any other sanity checks due to
>  	 * intel_idle's shenanigans.
>  	 */
> -	if (loaded_mm == &init_mm)
> +	if (mm_is_kernel(loaded_mm))
>  		return;

This one is almost *certainly* buggy.

The efi_mm stuff uses leave_mm(). In fact, I think it's what's
responsible for switching the hardware back over to use the init_mm page
tables. If this check trips for init_mm, then the kernel will stay
running on efi_mm when it's not intended to.

Remember when I asked about whether there was going to be *a* kernel mm
or lots? This is where it starts to matter. It's outside the diff
context but the code here is basically:

        if (loaded_mm == &init_mm)
                return;
        switch_mm(NULL, &init_mm, NULL);

So either all kernel mm's are equivalent or this code doesn't quite work.

>  	/* Warn if we're not lazy. */
> @@ -855,7 +855,7 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
>  		 * cpu_tlbstate_shared.is_lazy whether or not to send an IPI.
>  		 */
>  		if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> -		    WARN_ON_ONCE(prev != &init_mm && !is_notrack_mm(prev) &&
> +		    WARN_ON_ONCE(!mm_is_kernel(prev) && !is_notrack_mm(prev) &&
>  				 !cpumask_test_cpu(cpu, mm_cpumask(next))))
>  			cpumask_set_cpu(cpu, mm_cpumask(next));
>  
> @@ -932,7 +932,8 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
>  		 * This way switch_mm() must see the new tlb_gen or
>  		 * flush_tlb_mm_range() must see the new loaded_mm, or both.
>  		 */
> -		if (next != &init_mm && !cpumask_test_cpu(cpu, mm_cpumask(next)))
> +		if (!mm_is_kernel(next) &&
> +		    !cpumask_test_cpu(cpu, mm_cpumask(next)))
>  			cpumask_set_cpu(cpu, mm_cpumask(next));
>  		else
>  			smp_mb();

This one is interesting. It's basically saying that init_mm doesn't get
mm_cpumask() updates. That makes sense since it has special TLB flushing
rules. But what does this mean for efi_mm? Does it needs mm_cpumask()
updates?

