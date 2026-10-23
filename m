Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A088E606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jLZduzWw
Received: by kanga.kvack.org (Postfix)
	id C07DE6B0B2D; Fri, 23 Oct 2026 06:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2146B0B2E; Fri, 23 Oct 2026 06:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0DA6B0B2F; Fri, 23 Oct 2026 06:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83A9B6B0B2D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:17:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02DAC14039C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:17:27 +0000 (UTC)
X-FDA: 85353488976.29.107A4B3
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 224CA1A000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:17:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jLZduzWw;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792750646;
	b=VBG4zsCnaEv8rfqdrb7S+6/u1r9X+6Dkn5dn3iGWs0/N3WYEwSaOPKXdyavl96KjXFr+Wh
	BDBiCJ4pcXqZrpD9/ceLs2jBqy9XfVzzpi3ecfPrQp3K/GRjli4c7FKZC2CdzFnhKmBnim
	DDq3/a9ofZ9Z5Cs5kFsT6FQhvGKxBzA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jLZduzWw;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792750646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRvL7cCOwql5SCXnVx//aKAs5MwNxaXVUpZx/G3l3gY=;
	b=2dQJwSZF1/yF720BHXl8a4O8WJLOiJxZ08BcdozgAcOqUs5kBlyUN0MJmDfnbTbtP6jva7
	JSb9TlpL/iEuQXp8pkkoc0OWLV3kM0n8ttpHlNdjowk/HnjbIB2UBjIO0TKLhfNbeyjj8N
	1HqfIQGgcN90STfA+0Hzu8vSHfUXQBM=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so1075094a12.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792750644; x=1793355444; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mRvL7cCOwql5SCXnVx//aKAs5MwNxaXVUpZx/G3l3gY=;
        b=jLZduzWwxD3AMl1w3tG01JDITfVxcmP92hShvI4xDd5t1gbk3AeN5jCBJEe4KnKPy3
         /abd7c7rszVgWdzo1LG+P1TSKFXQNUX8DkLp/tqWjP3Z97B5zxyq9Vzhy5Mf0lJFzLsc
         IgtNrg358PWrvMGCL0wHl1sa5uUnYDavC1wgEqK8iIbZiHMtHgLIhgQWZcmR+RGcTjYM
         VCVmtAN/7eJnvxZsQ71Kwoy/b0yf8+rbhe5YmbY+2opvMytNMzoIX4fYA3HlmdNW8Gjb
         gp82JJdlpGsf75ErhmZg4iIMWCjvo2ec0v5wpxD7O0K+pIHG5cyOwsi45wCaH1OR5aYU
         mU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792750644; x=1793355444;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mRvL7cCOwql5SCXnVx//aKAs5MwNxaXVUpZx/G3l3gY=;
        b=fM7esUrMUkZpa6skOG7Uyjlm7iI3sf+FuBWVsiWy6e6GEfBauqNFb7yOHAmHBBJ4GI
         53Noxp9iFLkSdSiscdVxQIMAnB6ns/QTdW4qqxRXvWQVkNxS+Iab3tZJhKTuqVkEyIV2
         8qqvNfHkjA9AhZXK64X1WU95U4rPcObeCf2hdBHg9tFEEKhVr29o1e834G5MefI+vM5T
         z/tqZyaiTi/tkmXmQiR9021I/Gp0bQaUCsUMBAI+FQIhw7y4aAbZb1a2WttZNsGpkYas
         R9giTmR3UZ8hQekwNNliD5NSpGVyS/o3gSSP8PXUSlXibyYTO63Y1PoVPev67REjYkrp
         kFGQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7JDhvyxKowLfgvD8quEfPla2CZ3fWe24aQXe5hZD8PDRNrGDeHr0efCzl6BXD1UgryjR5XspQGw==@kvack.org
X-Gm-Message-State: AFq9FYJQQLnLW3SCb1accKHc2lhEYWEf4Zx7QvJZErnKTDTjnEEWGW7c
	xiNqt8owfLLsbsvk/PxdHYNAkEmUPpj3YlUs+ZVPm+qhEoDwj1pXXXqD
X-Gm-Gg: AYBFou1DOW+fCv1nOa3NmHxi0jFriTO7fhr5surx5eFL89iHlmanpZ6lWIXTcV0EgoZ
	JGJzxcULpKPEzYA3FzoN0RFCERJFaRM0pgGQs7ydNiIiIjhM18zSEB04UUosjLUM7BgJEaML4Ql
	EpzTxymQFRYVxhiAZcmh1UIRq5MTX1UzAtwpsIfQfSFUg1Okh8T9elmUKcwk2DJrIKsvsa1E2LG
	T9/PK/QwvJ0dkQboK3XJRgg2mnKg1d6OnzJc/5KOGWWD+L3QOD9TKdeMrQRTq1dIHD77MeXxMH0
	DwkBiMfbZlMfBQB+c+yjkJS888SgdAYSfSKbRympQOCFPfBYAJfmXWHDMkrgG0ix03A1O4PyvID
	aS7vHd6lpJg4R+BV394gtMO6Wu+bxnQ3xQH/1CFIYCYymaNos8jHcTU9VmZ9GojWyPDA8NGKiOy
	yRT/iZuPtPKN2/t85TbsJA/Op4u6DnkyCgroyWkrBcZ50c57Jj9T4v2rdtuCwde2QRb1VerELKv
	vkccOaQECLarZxuYESG
X-Received: by 2002:aa7:d503:0:b0:6b2:3b5:d078 with SMTP id 4fb4d7f45d1cf-6b432bd64bamr1847191a12.30.1792750644149;
        Fri, 23 Oct 2026 03:17:24 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b432c00eaasm986570a12.5.2026.10.23.03.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 03:17:23 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 23 Oct 2026 12:17:21 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, sashiko-reviews@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
Message-ID: <ats0Me6ON2QDrS6L@milan>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev>
 <sashiko-outbox-178439@kernel.org>
 <2b83dfaa-424b-4464-830e-a7714a816d5c@linux.dev>
 <d1ed2d7f-3999-4e8a-a290-1f812a0439af@linux.dev>
 <ateD6VVhyiUAtsER@milan>
 <e58f1712-cfd1-4757-a47f-f8df53b8baf9@linux.dev>
 <atpHuSch1sbl9Cz3@milan>
 <b838b389-c4a4-47d9-b723-b3a89714c885@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b838b389-c4a4-47d9-b723-b3a89714c885@linux.dev>
X-Stat-Signature: rzwi8cfbzm455cudduhdkpbu56g4tdsz
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 224CA1A000A
X-Rspam-User: 
X-HE-Tag: 1792750645-382358
X-HE-Meta: U2FsdGVkX18ewmPk63YowXaiGKgpjPai+6RMio6lPdv+8C+M0BpT+k2n55oTKE2m70lrIHLFMhQvD2yIqGcRcGiP4fEPBAQKfrzgsvVxNESfSMK63YDPz09vD3sAqQnl++uXxCCthtIonivBbjJ5sYTVfGQNTg+3sXh/riY9/seti6Kn94YY7UPOauLzI0fYvlD34RZhDtmUSRp+WwNFoO72lrHlvcePNkgUXTB3nfd1B5lLzmoc76NhtcPNgNxwvF0EE0HD+aB1Q6PS5UEeEV9yOx0VoaVXLsxcukP2cR0WAewcSZJuJ+piEJMi6hZDMMojZWogBpeLn8R/8h8SEolYVxBczb2Mam1w68vJcVGQQEig0xR13lxVvCEM+qUkqnaYqGP+eNYsAjEwkQIiWjiB9hGrGiOZ+WXj5/NwkytyaY82dypZRbLnkW5IfHbbA4Q2FNBCTbnB3eGJdCYqmfpwlep6mNBu7GKbie4PPWhkqTu6xffIpD3hoVNqLLY8ZBNMCjTu0J2LfsDWp5A3n/0LmiAfXc7dyXog+3AU/vDxjFtJmh9kE8T/2z/72ji7yA53AZYFUlV29LFgRP2PXHrTAOPqYQTAGAKG3LA4QMtWHFNrE6MEZ0md+hWJFptrssMZwY1v4hqqWZjXvpt8sbM6KmGbQOmJl7xHm09oC63MKra2cRTaQU73+QPCPySUqJ1mfpb7jgtxbX6gKTym4F3CYpsJ8DCuIZVXteGjtBp/uGtcnixPbQK2ZMHm7LNAMP549sZXxjtb2iHUgAM/AACB/wFwcRu6FUnjPi6O4VIAaRosFHixfBk/3Zl8Sex4s1r5PyaRlKzhcy9hLHstKamgZfq2alF79TUm0Tu4okEhNQlf0UMqHxG6WXATW0ctgNaRUYm9LatJCi0A6KMiLvdLcoBlPy62p0356Zc/KY4ZWe5M2AstDnuCTjB4PdHpbWKMBnpVd4FI1mWp97k
 sWhJaVPO
 1m/85Ne+j3WYuNfN3CQ4+uZ/XEQ5gHbNTjS+N6IZjcgb6UYYMOED726Bu3VUtlNipsiFGbCcfbAujX9rCbakfuFyNweC1zgtLYOmVyARF9eJwjAOocyzF8dgKL32M4J5F9mAPxHu9UwASYQopWCdQH9MYozMl/3CaWA63tEDy6E9uFEzP7lrZay783enbMN7QKdwlljC9zCAybbf61f7jf6cf10El+wk4mpjbHHEAYPb/CJSV5M7341WrfUra1Iu5CLYW/XAC0Nbqky9dgjSLJmW61H7tFZwkmbxju8urIWhZ3jyrFrRWIw1LuZn+ICQWDUMwc65bblmnF1wBQPJ3kaHQyHKv5eeowOexUF4JZVk5Nt/GRN7650XHtPGGigT7+0Jcgw3/4SA+AWI8GyQe00e9RdFHbOJZ42kaiXoHbTFrV9RnkNdeU0dAvCyQQt/Iq+nsywZeVsJTU1nSgOdU/u60U7T1NV3KccuwhdtDcPe/iBaieZcrPjTmBAuPETvVPdNOaxwR8aqCCUKgMRzXXgoenDxM4quBbTFT28M2eE0gGGTK++PiqgrczEJ1KXfSI70eAne3oeCbQ5zEjrIYwemgBq2uTEsXfSZQQbUI1INE9ETSqyItlD7Bdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:18:57AM +0800, Hao Ge wrote:
> 
> 
> On 2026/10/23 01:28, Uladzislau Rezki wrote:
> > On Thu, Oct 22, 2026 at 09:33:19PM +0800, Hao Ge wrote:
> >> Hi Uladzislau and Suren
> >>
> >> On 2026/10/20 23:08, Uladzislau Rezki wrote:
> >>> On Tue, Oct 20, 2026 at 09:27:14PM +0800, Hao Ge wrote:
> >>>>
> >>>> On 10/20/26 18:03, Hao Ge wrote:
> >>>>> Hi Suren and Ulad
> >>>>>
> >>>>> Sashiko reported several issues, and they all look real.
> >>>>> I have some ideas for fixing the first few;
> >>>>> of course, please correct me if I get anything wrong.
> >>>>>
> >>>>> I'd like to discuss the last issue with you all.
> >>>>>
> >>>>>
> >>>>> On 2026/10/20 13:45, sashiko-bot@kernel.org wrote:
> >>>>>> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> >>>>>> - [High] mm/vmalloc: infinite loop in vunmap_pte_range() on unaligned error rollback
> >>>>>> - [High] mm/vmalloc: __vmap_pages_range_noflush() calls cond_resched() in atomic context
> >>>>>> - [Medium] mm/vmalloc: vmap_page_range() calls flush_cache_vmap() before error rollback
> >>>>>> --
> >>>>>>
> >>>>>> commit 043026437ba63b051df5d14470fe69ce8fa8825c
> >>>>>> Author: Hao Ge <hao.ge@linux.dev>
> >>>>>>
> >>>>>> mm/vmalloc: undo partial mappings inside the mapping functions
> >>>>>>
> >>>>>> This commit adds rollback logic using __vunmap_range_noflush() and
> >>>>>> kmsan_vunmap_range_noflush() into vmap_page_range(),
> >>>>>> __vmap_pages_range_noflush(), and vmap_pages_range_noflush() when page
> >>>>>> table installation or KMSAN metadata setup fails. It also adds range and
> >>>>>> page_shift validation in __vmap_pages_range_noflush().
> >>>>>>
> >>>>>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>>>>>> index 44e0eb32708f1..75aa5acf55660 100644
> >>>>>>> --- a/mm/vmalloc.c
> >>>>>>> +++ b/mm/vmalloc.c
> >>>>>>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
> >>>>>>>   	if (!err)
> >>>>>>>   		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> >>>>>>>   					       ioremap_max_page_shift);
> >>>>>>> +	if (err)
> >>>>>>> +		__vunmap_range_noflush(addr, end);
> >>>>>>> +
> >>>>>>>   	return err;
> >>>>>>>   }
> >>>>>> [Severity: High]
> >>>>>> What happens here when vmap_range_noflush() returns -EINVAL for a range
> >>>>>> where end - addr is not PAGE_SIZE-aligned?
> >>>>>>
> >>>>>> In vmap_pte_range(), commit a739e6b557af09 added a check to bail out on
> >>>>>> unaligned ranges specifically to avoid an infinite loop:
> >>>>>>
> >>>>>> mm/vmalloc.c:vmap_pte_range() {
> >>>>>> 	...
> >>>>>> 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> >>>>>> 		return -EINVAL;
> >>>>>> }
> >>>>>>
> >>>>>> This can be reached on 64KB page kernels via pci_remap_iospace() ->
> >>>>>> vmap_page_range() with 16KB/32KB/48KB PCI I/O ranges (for example via
> >>>>>> loongson_pci_probe() or acpi_pci_root_remap_iospace()).
> >>>>>>
> >>>>>> When vmap_pte_range() returns -EINVAL, vmap_page_range() now calls
> >>>>>> __vunmap_range_noflush(addr, end) with the unaligned range. Whenever a PMD
> >>>>>> in [addr, end) is already populated with a PTE table (such as the
> >>>>>> PCI_IOBASE PMD populated during early boot by reserve_pio_range(), or an
> >>>>>> earlier PMD mapped in the same call), __vunmap_range_noflush() descends
> >>>>>> into vunmap_pte_range(), which has no alignment check:
> >>>>>>
> >>>>>> mm/vmalloc.c:vunmap_pte_range() {
> >>>>>> 	...
> >>>>>> 	do {
> >>>>>> 		...
> >>>>>> 			ptent = ptep_get_and_clear(&init_mm, addr, pte);
> >>>>>> 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
> >>>>>> 	} while (pte += (size >> PAGE_SHIFT), addr += size, addr != end);
> >>>>>> }
> >>>>>>
> >>>>>> Because end - addr is not a multiple of PAGE_SIZE, won't addr step past end
> >>>>>> and loop infinitely, clearing unrelated kernel PTEs and corrupting memory
> >>>>>> past the PTE table?
> >>>>>>
> >>>>> That sounds reasonable. I will add a separate patch in the next version to fix
> >>>>> this problem.
> >>>>>
> >>>>>> [Severity: Medium]
> >>>>>> Also in vmap_page_range(), flush_cache_vmap(addr, end) is called
> >>>>>> unconditionally before checking err and before rolling back with
> >>>>>> __vunmap_range_noflush(addr, end):
> >>>>>>
> >>>>>> mm/vmalloc.c:vmap_page_range() {
> >>>>>> 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> >>>>>> 				 ioremap_max_page_shift);
> >>>>>> 	flush_cache_vmap(addr, end);
> >>>>>> 	if (!err)
> >>>>>> 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> >>>>>> 					       ioremap_max_page_shift);
> >>>>>> 	if (err)
> >>>>>> 		__vunmap_range_noflush(addr, end);
> >>>>>>
> >>>>>> 	return err;
> >>>>>> }
> >>>>>>
> >>>>>> On UML, flush_cache_vmap is defined as flush_tlb_kernel_range:
> >>>>>>
> >>>>>> arch/um/include/asm/cacheflush.h:
> >>>>>> #define flush_cache_vmap flush_tlb_kernel_range
> >>>>>>
> >>>>>> When vmap_range_noflush() fails partway through or
> >>>>>> kmsan_ioremap_page_range() fails, flush_cache_vmap() runs while the
> >>>>>> partially installed PTEs are still pte_present(), causing
> >>>>>> update_pte_range() in arch/um/kernel/tlb.c to map them into the host OS via
> >>>>>> ops->mmap() and clear _PAGE_NEEDSYNC:
> >>>>>>
> >>>>>> arch/um/kernel/tlb.c:update_pte_range() {
> >>>>>> 	...
> >>>>>> 		if (pte_present(*pte)) {
> >>>>>> 			...
> >>>>>> 			ret = ops->mmap(ops->mm_idp, addr, PAGE_SIZE,
> >>>>>> 					prot, fd, offset);
> >>>>>> 		} else
> >>>>>> 			ret = ops->unmap(ops->mm_idp, addr, PAGE_SIZE);
> >>>>>>
> >>>>>> 		*pte = pte_mkuptodate(*pte);
> >>>>>> }
> >>>>>>
> >>>>>> When __vunmap_range_noflush(addr, end) then clears the software PTEs
> >>>>>> without a subsequent TLB flush or unmap notification, won't those host OS
> >>>>>> mmap mappings be left behind? Should flush_cache_vmap(addr, end) only be
> >>>>>> called after both vmap_range_noflush() and kmsan_ioremap_page_range()
> >>>>>> succeed?
> >>>>>>
> >>>>> That sounds reasonable. I will add this logic in the next version.
> >>>>>
> >>>>>>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>>>>>   		pgprot_t prot, struct page **pages, unsigned int page_shift)
> >>>>>>>   {
> >>>>>>>   	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> >>>>>>> +	unsigned long start = addr;
> >>>>>>> +	int err = 0;
> >>>>>>> +
> >>>>>>> +	if (WARN_ON_ONCE(addr >= end))
> >>>>>>> +		return -EINVAL;
> >>>>>>>   	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
> >>>>>>>   		return -EINVAL;
> >>>>>>>   	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> >>>>>>> -			page_shift == PAGE_SHIFT)
> >>>>>>> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> >>>>>>> -
> >>>>>>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> >>>>>>> -		int err;
> >>>>>>> -
> >>>>>>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> >>>>>>> +			page_shift == PAGE_SHIFT) {
> >>>>>>> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
> >>>>>>> +	} else {
> >>>>>>> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> >>>>>>> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> >>>>>>>   					page_to_phys(pages[i]), prot,
> >>>>>>>   					page_shift);
> >>>>>>> -		if (err)
> >>>>>>> -			return err;
> >>>>>>> +			if (err)
> >>>>>>> +				break;
> >>>>>>> -		addr += 1UL << page_shift;
> >>>>>>> +			addr += 1UL << page_shift;
> >>>>>>> +		}
> >>>>>>>   	}
> >>>>>>> -	return 0;
> >>>>>>> +	/* Undo the PTEs installed before the failure. */
> >>>>>>> +	if (err)
> >>>>>>> +		__vunmap_range_noflush(start, end);
> >>>>>>> +
> >>>>>>> +	return err;
> >>>>>>>   }
> >>>>>> [Severity: High]
> >>>>>> Similarly here, __vmap_pages_range_noflush() checks addr >= end, but does
> >>>>>> not check PAGE_ALIGNED(addr) or PAGE_ALIGNED(end).
> >>>>>>
> >>>>>> If a caller passes a sub-page or unaligned range (for example, 0 < end -
> >>>>>> addr < PAGE_SIZE), nr = (end - addr) >> PAGE_SHIFT evaluates to 0, so the
> >>>>>> huge-page path still maps nothing and returns 0, while the small-page path
> >>>>>> loops infinitely in vmap_pages_pte_range(). And if the huge-page path fails
> >>>>>> on an unaligned range, __vunmap_range_noflush(start, end) will hit the same
> >>>>>> infinite loop in vunmap_pte_range().
> >>>>>>
> >>>>>> Should both vmap_page_range() and __vmap_pages_range_noflush() validate
> >>>>>> PAGE_ALIGNED(addr) && PAGE_ALIGNED(end) upfront before attempting to map or
> >>>>>> unmap?
> >>>>>>
> >>>>> I think We need to check both PAGE_ALIGNED(addr) and PAGE_ALIGNED(end).
> >>>>> As an example: if addr is PAGE-aligned, end is not, and end - addr < PAGE_SIZE,
> >>>>> then nr becomes zero. On the huge page path, we simply return 0 with no work performed.
> >>>>>
> >>>>> At the same time, vmap_pages_pte_range() needs the same guard as commit
> >>>>> a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned"),
> >>>>> to protect against unaligned ranges.
> >>>>>
> >>>>> So will do next version.
> >>>>>
> >>>>>>>   int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>>>>> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>>>>>   	if (ret)
> >>>>>>>   		return ret;
> >>>>>>> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> >>>>>>> +
> >>>>>>> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> >>>>>>> +	/*
> >>>>>>> +	 * The page tables undo themselves on failure. Tear down the
> >>>>>>> +	 * metadata that was fully set up before the mapping failed.
> >>>>>>> +	 */
> >>>>>>> +	if (ret)
> >>>>>>> +		kmsan_vunmap_range_noflush(addr, end);
> >>>>>>> +
> >>>>>>> +	return ret;
> >>>>>>>   }
> >>>>>> [Severity: High]
> >>>>>> Can calling __vunmap_range_noflush() and kmsan_vunmap_range_noflush() here
> >>>>>> trigger a sleeping-in-atomic-context bug when __vmalloc() or kvmalloc() is
> >>>>>> called with GFP_ATOMIC or GFP_NOWAIT?
> >>>>>>
> >>>>>> __vmalloc_area_node() supports non-blocking allocations by wrapping
> >>>>>> __vmap_pages_range() in memalloc_apply_gfp_scope(gfp_mask):
> >>>>>>
> >>>>>> mm/vmalloc.c:__vmalloc_area_node() {
> >>>>>> 	...
> >>>>>> 	flags = memalloc_apply_gfp_scope(gfp_mask);
> >>>>>> 	do {
> >>>>>> 		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
> >>>>>> 				page_shift, nested_gfp);
> >>>>>> 	} while ((gfp_mask & __GFP_NOFAIL) && (ret < 0));
> >>>>>> 	memalloc_restore_gfp_scope(flags);
> >>>>>> }
> >>>>>>
> >>>>>> When a GFP_ATOMIC or GFP_NOWAIT allocation runs in atomic context (such as
> >>>>>> under a spinlock, preempt_disable(), or rcu_read_lock()) and page table
> >>>>>> allocation fails in vmap_small_pages_range_noflush() after at least one PMD
> >>>>>> in [start, end) is populated (or after kmsan_vmap_pages_range_noflush()
> >>>>>> populated the KMSAN shadow/origin ranges), __vmap_pages_range_noflush() and
> >>>>>> kmsan_vunmap_range_noflush() synchronously call __vunmap_range_noflush().
> >>>>>>
> >>>>>> __vunmap_range_noflush() walks the populated PMDs via vunmap_pmd_range(),
> >>>>>> which unconditionally calls cond_resched():
> >>>>>>
> >>>>>> mm/vmalloc.c:vunmap_pmd_range() {
> >>>>>> 	...
> >>>>>> 	do {
> >>>>>> 		next = pmd_addr_end(addr, end);
> >>>>>> 		if (pmd_none_or_clear_bad(pmd))
> >>>>>> 			continue;
> >>>>>> 		vunmap_pte_range(pmd, addr, next, mask);
> >>>>>>
> >>>>>> 		cond_resched();
> >>>>>> 	} while (pmd++, addr = next, addr != end);
> >>>>>> }
> >>>>>>
> >>>>>> Commit 9c47753167a6 ("mm/vmalloc: defer freeing partly initialized
> >>>>>> vm_struct") deferred error-path cleanup in __vmalloc_area_node() to a
> >>>>>> workqueue specifically because unmapping on failure can sleep. Doesn't
> >>>>>> calling __vunmap_range_noflush() synchronously inside
> >>>>>> __vmap_pages_range_noflush() and vmap_pages_range_noflush() reintroduce
> >>>>>> cond_resched() in atomic context?
> >>>>>>
> >>>>> This issue also appears real. One possible approach is to plumb the caller's gfp_mask into vunmap_pmd_range()
> >>>>> to conditionally skip cond_resched().
> >>>>> Suren, Ulad, do you have any preferred or cleaner way to handle this?
> >>>>
> >>>>
> >>>> Alternatively, we can follow the approach from commit 9c47753167a6
> >>>> ("mm/vmalloc: defer freeing partly initialized vm_struct"):
> >>>>
> >>>> defer the cleanup to a workqueue when |gfp_mask| has GFP_ATOMIC or
> >>>> GFP_NOWAIT，and perform cleanup synchronously
> >>>>
> >>>> if we are already in process context. Anyway, I will look into this further
> >>>> tomorrow.
> >>>>
> >>> I will check the AI concern.
> >>>
> >>
> >> Thank you very much for the quick reply and for offering to check
> >> the AI concern. Much appreciated!
> >>
> >> Here is a summary of what I have found over the last few days.
> >> I went through the history first. The cond_resched() in vunmap_pmd_range()
> >> was added by commit e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range"),
> >> modeled after zap_pte_range(). It fixed a real soft lockup: on a non-preemptible
> >> kernel, unmapping a large persistent-memory namespace (hence a large I/O map region)
> >> kept a CPU busy for 23 seconds inside the walk:
> >>
> >> 	watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
> >>
> >> Then I looked at how vfree() handles atomic contexts: it defers the
> >> whole free to a workqueue from interrupt context (vfree_atomic()),
> >> and 9c47753167a6 does the same for a partly initialized vm_struct.
> >>
> >> Unfortunately I do not think deferral works for this rollback case.
> >> A deferred rollback returns with the PTEs still installed, and if
> >> that range is mapped again before the workqueue runs, the mapping
> >> hits the leftovers: a warning and -EBUSY on the small-page path, a
> >> BUG() on the huge path.
> >>
> >> So I kept it simple: plumb the caller's gfp_mask down to the unmap
> >> walk and call cond_resched() conditionally, like
> >> commit 660654f90e7f ("mm/vmalloc.c: add a schedule point to vmalloc()")
> >> did:
> >> 	if (gfp_mask & __GFP_WAIT)
> >> 		cond_resched();
> >>
> > Sounds good to me. But we have the helper: gfpflags_allow_blocking(gfp_mask))
> 
> Right.
> 
> > Another option is probably we can remove cond_resched(); from unmap path?
> 
> I'm wondering if removing cond_resched() from the unmap path would reintroduce
> the softlockup issue fixed by below commit:
> 
> commit e47110e90584a22e9980510b00d0dfad3a83354e
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Date:   Thu Aug 20 17:42:05 2020 -0700
> 
>     mm/vunmap: add cond_resched() in vunmap_pmd_range
>     
>     Like zap_pte_range add cond_resched so that we can avoid softlockups as
>     reported below.  On non-preemptible kernel with large I/O map region (like
>     the one we get when using persistent memory with sector mode), an unmap of
>     the namespace can report below softlockups.
>     
>     22724.027334] watchdog: BUG: soft lockup - CPU#49 stuck for 23s! [ndctl:50777]
>      NIP [c0000000000dc224] plpar_hcall+0x38/0x58
>      LR [c0000000000d8898] pSeries_lpar_hpte_invalidate+0x68/0xb0
>      Call Trace:
>         flush_hash_page+0x114/0x200
>         hpte_need_flush+0x2dc/0x540
>         vunmap_page_range+0x538/0x6f0
>         free_unmap_vmap_area+0x30/0x70
>         remove_vm_area+0xfc/0x140
>         __vunmap+0x68/0x270
>         __iounmap.part.0+0x34/0x60
>         memunmap+0x54/0x70
>         release_nodes+0x28c/0x300
>         device_release_driver_internal+0x16c/0x280
>         unbind_store+0x124/0x170
>         drv_attr_store+0x44/0x60
>         sysfs_kf_write+0x64/0x90
>         kernfs_fop_write+0x1b0/0x290
>         __vfs_write+0x3c/0x70
>         vfs_write+0xd8/0x260
>         ksys_write+0xdc/0x130
>         system_call+0x5c/0x70
> 
> Even though we gained lazy MMU mode after that issue was fixed, I suspect I
> may be missing some technical details. Could you walk me through the reasoning
> for removing this cond_resched()?
> 
This is a good point. And you showed the good example why it is
a bad idea to remove it. I was thinking about this as preventing
CPU hogging by unmap path and you proved it.

Checking gfp sounds like is a correct away to address AI concern
which is correct.

--
Uladzislau Rezki

