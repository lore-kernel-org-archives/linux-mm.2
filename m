Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31E6C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73126B0159; Tue,  1 Sep 2026 07:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C238A6B015A; Tue,  1 Sep 2026 07:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EDA6B015B; Tue,  1 Sep 2026 07:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 917EE6B0159
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:42:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0111E1602FF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:42:51 +0000 (UTC)
X-FDA: 85165006584.22.57BA940
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id BFF421C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:42:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lfsvrvti;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788262970;
	b=khBp8GNOy6h0FC0nG+B+XdRjUZ2U9okvudOs2DFF7m99T1JOLuaeMHAIoW+wGyv34CmqhS
	tyHcDBTiZoLUegDKozTq2diVbv1Jt6Op4iEfz8LEp+bsaipoNZ2PUDgiV0EW5LUVYjvRja
	BH05aOV4TGUajEBaI3S+JxGcez1UmgA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lfsvrvti;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788262970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pS9KZmY3PJHTmnoRHEE+2rh7VUosEcufjq7+4Sj5SOs=;
	b=vK5GVsKgjV6DyxxpiJLEp0OFC13ywMPgLXN283JHCPV+JQE0BDnH3PLYrIHZw3pchirDxQ
	hsvprnqwrNif+O8xv0hTdU08hlKVjY02pik/pvbgqCzVj1EscvpHYIYspIgXI/WCBh0N1p
	r2jwG7Hjcbpigk1d6GK9whtMBDsAjw4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jW/g7skipUiySI9QtwdH2wDkEYlVS/kGmkog5T/rBHE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788262965; v=1; x=1788867765;
 b=LfsvrvtibHhBUHVY2X6xwFevKlEDCA0r9Kmf0y37jwH7WvQnTg97nb5/qhva3BPmAlE6WliB
 JLC+El2ftJ2d7Yh+ioGfVnr+vo7wJaCBiRGdwaphjJx/M1VblEBLu+JkKKiadPIGtpM8lOC5/x3
 eGmUXzogX6YYYRGW996jvEs4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ff2d6d342cf5eee9;
	Tue, 01 Sep 2026 11:42:35 +0000
X-Mizu-Trace-ID: ff2d6d342cf5eee9
X-Migadu-Flow: FLOW_OUT
Message-ID: <f4c568ad-a17a-4982-b8d2-d5852a789a4d@linux.dev>
Date: Tue, 1 Sep 2026 19:42:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/14] mips: move has_transparent_hugepage() out of THP
 guard
Content-Language: en-US
To: Luiz Capitulino <luizcap@redhat.com>
Cc: corbet@lwn.net, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, david@kernel.org,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 yintirui@huawei.com, dev.jain@arm.com, usama.arif@linux.dev,
 linux-mm@kvack.org
References: <cover.1788232334.git.luizcap@redhat.com>
 <371e2d3a7bcac265ac748ad3c67b74abfa238422.1788232334.git.luizcap@redhat.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <371e2d3a7bcac265ac748ad3c67b74abfa238422.1788232334.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BFF421C0007
X-Stat-Signature: g18gyrd1tdy3bjiod3cuqsmwoxdywhp6
X-Rspam-User: 
X-HE-Tag: 1788262969-955837
X-HE-Meta: U2FsdGVkX19XvFz+2UMuGPZcXWBhBjeclXuoD1cw5ukTq2JQ3afhz9rjEX1HdBD9sv71SFjli7zHAqABHIb/eiAhitF7KIo8ZcNHxUEExWxicB4zF56eOhJrJ1Y5yT6+ayTUFaV3GSpXTZ5GZN2zwbv171PZqea6OEbrzdJxhi52NkL58D4CnZKjVKq/gFyIPUU1GCq7h1kaoC2TNil569YcK4D+aIMXCuevdl98+UgRwxZnWwR7YWJfvxBcbQog5IbsT2SAHSAPDX8H4mPWT5Q461rpRAex0kjqfXhDEWPYpn1QxuiG0VhJgZxn+8V1DmNK+GjzlAGgovfBMSAd4XgBJbwb0XPEbyYd4gsUCXfNYrEiGMTN2X9k1NW90cOG+yWMLp3dsh+w7sFALvjdC28nuXSh6en7QDAxgRw5/KxSczv9vYByRQu5oIMlYvZrwHawNThwdN9sp2KhIF/9WEHB7jLgDJ8LGABH+BAb6oDEjOKr96a/c12DTikR7hyYQg3VY+bymGxGwdNAaBO6ErhAIQzBO/aSLyVJlA2nVuwV/J7egO70W5DOUAyTZZAWBtjwGunTR3UL5BYWpFFCbZ21gEEqGnb48v4ErFvV88KvpHcNNYhD+zWX8NperSzzJsLa0FrXg2IB1l231PyzrDhXKisdPccgU+klWoK04u08doCv9h+Get9IefbKldyth1MXD/sfXymyBr7unzzZrOCEvquBP37X9aR+ENn9UZjbJlcLBVgnKT4ye3HG2gWtANawrzpiMbtWYugtL/sXyAUh3nxCUGmafCV3o01UMdrNwbhhwNd0uq8+wRNK7FGLUvvo0uhZZZts8uKJXlc7NA2vk3Ek6l/CtiKqqEYm5jk1knhzyXTgUfl+wAhQL7i7kjEcZvOdhnz94d5OEbEyh0R8iP6uXio3w4Ah3imhvjrq3gQsFsG/0/idW37LwyIwN/d4t6ZfffK8PgqlAcb
 TUp+vvkx
 G5tg+WrJ0kZLpcHvNk9x+7OQJUSw0c38hrdQB8QuPBW8sTbhEAioWxqVqLkTa5jOnDjI70PYW7LxT5zKrBnhwTsDB8WaTsUVf/Z5uUak69Oz13Qm91eidsgPLqveAHbUtu4Pm1H6cT2cgRrjqaqRHl89CMiM1+epEfkaNXdC08hk44bAGAYHAYliK9bwcUVMvFsEeZmS7gniEQ62L0gxn2ceFI3eNGos3jr1O8gdV8J2lqIXqBILL1BCzown3UHPSXZA4Ya1TUj6yc3u4ROj6/roUHzQpO4SydfDaEEuy7iKiauXyAXt4W4Us4AyL1owI0ZSt7r9P/vx8FFysCtVuA+0LcebrcTlGLlfv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/1 11:12, Luiz Capitulino wrote:
> A future commit will introduce a kernel API to allow for checking if the
> CPU supports PMD-sized pages. This API will be based on the
> has_transparent_hugepage() implementation but will be orthogonal to THP
> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
> 
> Move its definition out of the THP guard.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   arch/mips/include/asm/pgtable.h | 6 +++---
>   arch/mips/mm/tlb-r4k.c          | 4 ----
>   2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
> index fa7b935f947c..b038da872ec6 100644
> --- a/arch/mips/include/asm/pgtable.h
> +++ b/arch/mips/include/asm/pgtable.h
> @@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>   /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>   #define pmdp_establish generic_pmdp_establish
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -extern int has_transparent_hugepage(void);

Assume a decstation_defconfig build. CPU_R3000 selects CPU_R3K_TLB, so the
Makefile builds tlb-r3k.o but not tlb-r4k.o IIUC ...

The only MIPS definition is in tlb-r4k.c, so R3000 would fail to link with
an undefined reference ... no?

Cheers, Lance

> -
>   static inline int pmd_trans_huge(pmd_t pmd)
>   {
>   	return !!(pmd_val(pmd) & _PAGE_HUGE);
> @@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> +#define has_transparent_hugepage has_transparent_hugepage
> +extern int has_transparent_hugepage(void);
> +
>   #ifdef _PAGE_HUGE
>   #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
>   #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
> index 24fe85fa169d..f4e369342a56 100644
> --- a/arch/mips/mm/tlb-r4k.c
> +++ b/arch/mips/mm/tlb-r4k.c
> @@ -432,8 +432,6 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
>   #endif
>   }
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -
>   int has_transparent_hugepage(void)
>   {
>   	static unsigned int mask = -1;
> @@ -452,8 +450,6 @@ int has_transparent_hugepage(void)
>   }
>   EXPORT_SYMBOL(has_transparent_hugepage);
>   
> -#endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
> -
>   /*
>    * Used for loading TLB entries before trap_init() has started, when we
>    * don't actually want to add a wired entry which remains throughout the


