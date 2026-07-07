Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D779C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5376B0005; Tue,  7 Jul 2026 09:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78CA46B009E; Tue,  7 Jul 2026 09:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1EE6B00A0; Tue,  7 Jul 2026 09:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 406D26B0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:17:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDE921C38C4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:17:27 +0000 (UTC)
X-FDA: 84962032134.08.49DBBDA
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6CAA180002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:17:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uyVahiJw;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783430246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXqxsT2REYcN58ckChjdU8/v9QTtwid7lase85JBTGA=;
	b=wQbby3WTfv2TI8QeCOP3mz31WES3C7n8gsSzQ+EeRrdLDsP0L7s3rot0j5S5dSjVNbkZhS
	xIHj6CUAUIH1cB81OSjWpwYaiIGdVHP61jR1Zj8PlLf/1/RDL/Jb0Ko+Pb3AyfsW8ozyQG
	37quo7jcBMDFYmSm6mGhdCWE6M9Aiss=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uyVahiJw;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783430246;
	b=6Qa6Ll+CMxOpgO2WdN3hkgbaOFScQRtM5JqZZvbvGVkt9OxJlPCBQaz+EvRQUZAgwVmdz7
	qbepJqqxzgjryUkcPJnoaRWT0deaK5AGfWEev9NAJy+/P23qRbWZ0iiDR9k9YiDF9gRBYA
	GyEAFSI/EzU06G21CuO+urrmFypKxiE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783430243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXqxsT2REYcN58ckChjdU8/v9QTtwid7lase85JBTGA=;
	b=uyVahiJwyDi3GxwsD9aKVkH9twZUpL0EMKPBoUMClVlHBHnGpBmgLuAjpqTC6M0xvYGh6V
	8Cilb7uKUD0vtYJBXCMwEPpX0QkdZhChuJg/yt1Vq2Ev9f6qaV1RqTHZdCoUfEm0BqnNDR
	BEHoqWn70c7b+Rc59aA+EPeXJU4SWQU=
From: Usama Arif <usama.arif@linux.dev>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v3 1/3] mm: make persistent huge zero folio read-only
Date: Tue,  7 Jul 2026 06:17:12 -0700
Message-ID: <20260707131714.3266156-1-usama.arif@linux.dev>
In-Reply-To: <20260706130440.9295-2-xueyuan.chen21@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C6CAA180002
X-Stat-Signature: hsprxmxde5jxwsj6piukp9nroh5cgbmp
X-HE-Tag: 1783430245-853481
X-HE-Meta: U2FsdGVkX19A0c79JmKnKvI68IhLOzqSv4F9Er3Ts2nhaC5tZWL5jlP8istPXd+CSv5+e23oUzelklaSJV810MoNg/UdLKvpUj8MWjNGA6dsnL0Da1ev/e1cR5COx9de0AHxYS6eWBwP7VczNVOq81s0/RmGjDPsB73Wung33FIBpkopY39rr2DFEFJYbSou95dwV+su16/907pkS4Y/kPUo4nSRKBKUQKnUIPIEddipocJwIPwv8fSjH1oBi3w4v1nqMv4kS/2c4jfveWx45fdGVYXhWSD8MhzZjztYJLRChRD9EjPCV/OYYv1k/+WMI02vgmvx5IA56rVslZ6MxxoojtxdQGAGwmFa2wlJmcrUbR6egUpQSmGo9UqqjI4wQDgCUrFGTBy2xS/3ia198Dt7HW0V1K0yqjVGauTP/lKfpnanZwZ4GCumBlfsMlZowpqxWabqS9jzu59g/k3Jku8lnqbViwFUTyzckAAknYjuo4f8OWMdQn+ZIgOQ/chTpbayQUFeFHc91yIO/pKdVFwBFlJg7y/CwY+c3xf2ai5pNib1wFOd3ul5HGhrEt0m2Y1ZCQFg1uetYuEptzhc6QFdb1mF7qzOYYyakezZfs+xmavlkPSlU8A2OVgrGPZqhdKMr6MTqZkOIXL2NwMaUarZm/jlgmlxlDR9kNA2LiNTk7WVJpKUvKVgn2F94RRlGOrrm4R5UxfLS0FVlnPB7glZW/aZp/TZ6hG//YkGJDV14Wcs9J0T0jaliNvTuHKlegLp7DTcD+ez0UmCCJfwRcEMlqo1RmvYj34hFPPrpVEP2gJjWODXLJW25zQielvhMejCpJ/IpmI9A4s8y9Xqag9Q/tmCq6R3eC46FNnfatttDqtpI5w4S2KG6Sw4TNT2arm2uAArcUoJsNrV0/T2yBdFccDb+MKOJlNFI4xjpFMykHzbb0B7qTJ6ZDFNnKoToyMMYz9CtVseWk9RoeH
 MLI4qyMG
 DreCQO3yqJHB+n4pqWH744Z4/4LtOjPMRedlMxYzcF8rRp1dx+wfz5lYFFdT3Z69eXqXykg8Ddg5vaIPNg+RbuYIXIzkERmtM7bxppR0Rfy6iev4EQeOSgRF0AL2teeENoe67yLisGiXEA1HQnz+MboRN0oBB42qdjPSwyOlF2TEJG7wQC6eivnotqons5XeIZ08TUm2THek3ty2cnoagkIsPzp0vWO7QwphVrQnQz/ycvJ45s6HoaCS+lEsVsZShKc+WeiqRdVYkI0XsdP3ggPCjw/1JoMJucM3tHw7pNn/Dq1ffQ4gInHxtJtq6BqGdRwEdwKRLg+f6tMjNIukxWGN70w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 21:04:38 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> From: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> The persistent huge zero folio is shared globally and should stay zero
> after initialization. As Jann Horn pointed out[1], kernel bugs have ended
> up writing to pages that were meant to be read-only, including in
> security-sensitive cases. Making the persistent huge zero folio read-only
> in the direct map turns such writes into faults instead of silent zero-page
> corruption.
> 
> Add set_direct_map_ro_noflush() so mm code can make a direct-map range
> read-only. Use an address-based signature to match ongoing direct-map
> helper work[2], where existing page-based helpers may move the same way.
> The helper is direct-map specific and does not flush TLBs. Architectures
> without direct-map permission support keep existing behavior through the
> generic stub.
> 
> Persistent huge zero folio setup happens during early boot, so no explicit
> TLB flush is needed.
> 
> Inspired by Jann Horn's read-only zero page work[1] and follow-up
> discussion[3] with Yang Shi.
> 
> [1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
> [2] https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/
> [3] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/set_memory.h | 26 ++++++++++++++++++++++++++
>  mm/huge_memory.c           |  9 ++++++++-
>  2 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..a905074fb21d 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -40,6 +40,22 @@ static inline int set_direct_map_valid_noflush(struct page *page,
>  	return 0;
>  }
>  
> +/**
> + * set_direct_map_ro_noflush - make direct-map mappings read-only
> + * @addr: start address in the direct map
> + * @nr_pages: number of pages starting at @addr
> + *
> + * Make the direct-map mappings for @nr_pages pages starting at @addr
> + * read-only, without flushing TLBs.
> + *
> + * Return: 0 on success or when unsupported, negative error code on failure.
> + */
> +static inline int set_direct_map_ro_noflush(const void *addr,
> +					    unsigned long nr_pages)
> +{
> +	return 0;
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
> @@ -56,6 +72,16 @@ static inline bool can_set_direct_map(void)
>  }
>  #define can_set_direct_map can_set_direct_map
>  #endif
> +
> +#ifndef set_direct_map_ro_noflush
> +static inline int set_direct_map_ro_noflush(const void *addr,
> +					    unsigned long nr_pages)
> +{
> +	return 0;
> +}
> +
> +#define set_direct_map_ro_noflush set_direct_map_ro_noflush
> +#endif
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  
>  #ifdef CONFIG_X86_64
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bdd8635922f9..6633217b10dc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -41,6 +41,7 @@
>  #include <linux/pgalloc.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/pagewalk.h>
> +#include <linux/set_memory.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -981,8 +982,14 @@ static int __init thp_shrinker_init(void)
>  		 * that get_huge_zero_folio() will most likely not fail as
>  		 * thp_shrinker_init() is invoked early on during boot.
>  		 */
> -		if (!get_huge_zero_folio())
> +		if (!get_huge_zero_folio()) {
>  			pr_warn("Allocating persistent huge zero folio failed\n");
> +			return 0;
> +		}
> +
> +		/* Set up during early boot; no explicit TLB flush is needed here. */
> +		set_direct_map_ro_noflush(folio_address(huge_zero_folio),
> +					  HPAGE_PMD_NR);

Hi,

Can this really skip the TLB flush here?  This runs from a
subsys_initcall, after smp_init() and after the folio was allocated and
zeroed through the writable direct map.  The noflush helper updates the
direct-map PTEs but does not invalidate stale writable kernel TLB entries.

I think we need a TLB flush here?

>  		return 0;
>  	}
>  
> -- 
> 2.49.0
> 
> 

