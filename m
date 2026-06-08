Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B20CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 06:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6463A6B008A; Mon,  8 Jun 2026 02:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6F16B008C; Mon,  8 Jun 2026 02:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E55E6B0092; Mon,  8 Jun 2026 02:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6EC6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:25:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF3D6A09E4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:25:54 +0000 (UTC)
X-FDA: 84855759828.09.19162C1
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id E16701C0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:25:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ENvQaRzi;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780899953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwl6bxoedBil6zkKjzP3xhadcmpC2ohFviRs8deqyrM=;
	b=lUk41orcL8/KzpEBFedrh8afqSPYk6KDmXcfN8/Btp369Fw9NObicIgXJgdCIPiwuhnAEo
	FIq6adaiVXeJJWlI8CPjRoSySfA3ffOHOiqz1jIEuy6qYj6hWSrKiMb4f3EJJEDVmYAlE0
	2aPt2LkDeZXxV4L9zWG9YuQlvdUvDvE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780899953;
	b=Pfdb25ea9vcQRTilCJ4k4Y8XHy+QJnbVubTr9Z4rszGbpVBuPqgMcHum6gN7mlTupSbh2r
	RTce4PSRZvaewATu1MQkSZkJqQ1j1LhiIpKMS+SFN7cWWYYOE4NDaU0nMpVmYg5NiIyjXM
	1Tl6kvukfLaMTHwgtZoAr9NHerXGLuc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ENvQaRzi;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef616daf6so3478736f8f.3
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 23:25:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780899951; cv=none;
        d=google.com; s=arc-20240605;
        b=fAhHtkZ78TG1BFjD9vuqSyBlbbC5vnrAkOwACH/fRoOqzJSrs1bfTooXFx+1+10C8p
         ZyIyIaYz9CTaPygQ/3bBhofpOnYpajI/JRrvxq7bzKp79+XamUh3HJbrAIEVfg2I07SP
         Oj3AEh5Pa5tvfVaGqrNpds6rd00SotVez8vAqm3d0BtQ8pHUh1YkSA+klZOVZxWTqYky
         pneoT4z33jdJdzGytClMsKVkA9FR17u1UC3xjaOviNqLJsRnxKNMS7myt+l50HcAIIey
         /yodO6nHpFMnukxlPR9GylCc243ebM0poFf/YhthNLh/ZcMvZz5xqDqzh8CydDX2gnTb
         U0xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gwl6bxoedBil6zkKjzP3xhadcmpC2ohFviRs8deqyrM=;
        fh=C8b6lZPtrB2LD7MBO+6F3n+PqcmJOfb95NDq1lhAU2o=;
        b=hkCEQpS+ITGQaVEHYiVsCODqbgZvQLue/zB2ufZmBv5yfwiCjcUyd8cydg4/1RK3Q9
         jB1+QwhH/ZbqmnhpP4sjuOGecHYza16HWRzW4u3dQhc+emNfupDQDtT8XJQXtPfxBRrz
         yabeMma3/wlavq1c02OS7gUmqrMWTqQjbwC/0Nt0r5RRq5gYqzFxWqH22oeIKG/0fRg7
         Q4N11pGSAVupXxMW7mtP/sZdr4FwtC5HUkJ1bS1P6E5h1RByXpKliu7jXfcQNXdCIbUV
         jsEw391q21yn+YGk999H/4wVEG6yEpFpoEEyeDksnMjvE9SWrqTvYMcGaUjMzZFKQ1ee
         s23Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780899951; x=1781504751; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gwl6bxoedBil6zkKjzP3xhadcmpC2ohFviRs8deqyrM=;
        b=ENvQaRzieDr6b3arDEFvPjEKwBteEeFXLciHVsIKo8iSVyJkaS8XSJG+1T96YZLJhh
         VR2iKtzCcZeLWqc4snjI77a3boKFl7WcIQ2TxIjQDWypRKny4++jygvP28qNdXdTjo0o
         YFFkif1xiI2afEtVKeBtAtvjXIt9uC2O9ZFZxwzkOvkZY/LaT1Hvtm6bUpRnPDBkbD42
         UYiRA2zEOfB9AjyNlhQTHqJ83ArEvVQr79Z/RuPN/CHKbmPp6X004V3i9FWGe7otyYkv
         Qo58oFqLi9ez4my2Orl3s/b1QrwjK8KGsMFtaM/IGIIqb7q/hNYS5AxAzrB6U5bgHRqM
         3SMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780899951; x=1781504751;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwl6bxoedBil6zkKjzP3xhadcmpC2ohFviRs8deqyrM=;
        b=ib9Xi6UqUGNHsg3QmvuHGE6wUdJZR3JDk1OxUh6C10z3U4cfUirzUT59BBTMjb/Dio
         ODWmKpLezSIfFe2cH28P8bMpVS/Q+wf04H58eB6tnRXp8zyHH3rWAGPYx+LLd+bv6G9J
         gqOXJJbksO/c/e0yBXGgHcQVzwSGYkcMESrcMeKCkADyJAyuuoefPYy6wmuMbV0x20fT
         z1DeS7slnJAwgzHfY1+P5eV5rVx2CL3X7vmqcCkV7DH5GxjmMuwzp33tc69k6dOVMyUG
         aew7+FI5hEBSDzmQQUcVBqMLH/f16iNpq7ZIkLWaZBABjm9uKeweT/galz0vQ80F9ANA
         VXpw==
X-Gm-Message-State: AOJu0YzLAwghHdXDNkEOxUHIu5s5vBQiS0G8U/ykhc45QpZl0uBSxh8y
	24n6Q/V+eVpVN4ZyNXS8HGxCXn1fYT/wcj7F7vfz3SrLSJCQr7sHAWxfraJAbd3QaVzQ4RqxWcL
	VFQoNgdPGWviI3u2zSJbpZeI+GDHPmmI=
X-Gm-Gg: Acq92OFaBy257Le1gI4lhxAYIy5luabk06XNDIXk+dNgB9eY2jgSTM6inTrhVExsLh+
	PvwBKFdKzV6kr8iQfE5qb7//woU+0lSnB0IkxDM82JyxR4gIXtPblHXXxXpLpCfltQ6glyXcnVF
	RSOq9+3CM/C99w+mR3dEHRoZMLlAHK98lgTO05HAow89W/unfvo9ha1s7HRzYJieR5SLENiOveQ
	qLE4euI5iUxwqB0OX9HiKqOXStgZqNqzcKl1PXvwUaCyIc35mYjDjyvp031PtSBp0SwkXChBWVm
	FOaPQUgjYwaJSSZmMTs=
X-Received: by 2002:adf:eac3:0:b0:45e:ce28:666a with SMTP id
 ffacd0b85a97d-460302dcc75mr15718432f8f.1.1780899950996; Sun, 07 Jun 2026
 23:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-5-jiangwenxiaomi@gmail.com> <46b0f2a7-3c0d-4372-a45d-946d8259d410@arm.com>
 <CAHKocdEfX3dgUr3O6q1WOe4PddN2=LKfX6Y5DfrfTwF9MM5J3w@mail.gmail.com> <53a51128-8ad5-4faa-9151-1245084bdd4c@arm.com>
In-Reply-To: <53a51128-8ad5-4faa-9151-1245084bdd4c@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Mon, 8 Jun 2026 14:25:39 +0800
X-Gm-Features: AVVi8CdO-brXKZ74Vn--3CvlX_bimsMhmTttfAtKo0-xwHV3Y_noAP8U2d808V4
Message-ID: <CAHKocdHNAWzvYwu_mpekix+fH4ePn7ZMfmvxVsgb6VWYJAdZkg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E16701C0003
X-Rspam-User: 
X-Stat-Signature: bm1rmfbjjppyhqnn9ro7ynnitrbgrgn3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780899952-316783
X-HE-Meta: U2FsdGVkX1/BCe2Gmxu7zSgro6v9g1toyub4yY4J13+c/XTZKs+ZVJOGOqibBcb0KYUEX4fmkOQqysiV0uMC/dtUsGJKZqY2b6v+ByHElFCJweqXN6pCXj2V3MxAy4w5+YF0wKEUITptJPiipr3W+Fn3ncO5a6ChX6Tem4AhmqQ166e/4GB721uzzwj45wBatyAz/X8ITzZJWyTEssmReNLSaFnJUerq2s5rt45RSIVdkAHSiGmc43Pccnnr2jz6XB0o27LVux8R0GdMyPKqjIBpGfp6+nr62qsf/P8Z/bzy3KV+ACP5cnO+RGhmYbnVtMb/WFkw/Sj5CXGn9ablRTT3kAG8zaiyijwCPiIoGuB3I7WdLgmAlqpm9SSrJISrBsD88CJrwPc8LnbE2fOUxQiKQAfd9yR18xb7FK+o66PHm3N6n0vFVXRxElEupgCfrPwIb2wcjwbiipBO7iCIwjCcfAfwdTbI8zaF0PmAOjIN85GSqYKIKBQ9esa4h84I9s8LLfFxrcqmfX8XbPp60dkK9JZIoDHWF+cafT0t8DzdXWxRaT+YLWGCXymKWhqPp5i2JjTWdQKPeQE4WAGQJsLj9jk4sqZ2Y2k+shujy4DM7JXpMSKhvf9KQIBT4lq755u+Hk4x2EEW4fpuMsKLX67ZPYJtD6wrcGyivJKZecXeCqnTFUjBcSfJ6bd/twtc9CXqACSUZXt56vGrzgtAhl9NTw0js6I1NrLVTgBPwacUNfB4edi8I5ngaAwzWXe2i/NKEiTgjpMPL4tG3gSiuHnE+K5HgcpEj+pfIG0SEHOj+g6mfVYWl877QKUModbR2UYZUBHEA1RyRAgXgNF9tYC9zRHpHYYwgtNZ1yGThEyrgDNDd4aXKzOYCpQXsoQEZixHoKp7qwQuJCQHhgTpd3Uz7eohEW/Lemnxyi6absKjltPnGgRvpHQW1cWTHNwv8rAQaadEXXEee6NI3wq
 lxzsc8HK
 SbaECPleiaI4kDqyEpotRR8DGwuqogdIUh5J0sev9nRtr6YJ3bR25HB+nE5jJBCaiO/qdzdcpRqQ9v+0JdFdLAXpBtGFOQ8+/x/1U5z0UjKV62LkZjV5mMjHn8hOfPwZ/7FJT8uZVv1+AYdemZzLwTGNda4N0pOW3WI4/nBtT+ohYlPTRtgRpXVIKxSD0w11Q4Fey23BqaRi7MHKuEe4rugO3aZSOvTJSSPjtkib6wzbaRDrmd5xpzrTbTKm13e58nGtO5pk8Rh6dBsKrxBo4qDJl9YfxUpUsbvAzq67lgGCkKN5ro0k0K0QkvKwtJS+xxpECT8xvJ6ZZaPcsDCrC7htq5JGS2O/URn8HKlomfWMIRDee4ICTytxdPkeCgJPT8dvMGfUF6Td1LvTr2L5906IG4MjD2U+ta9z0LGnQDtSp7u3w1jIZveCGZsX4mejMVZEtEP6xISvS+rOWt5BHUF6Ii9r0z0cf3PcNPS2UkjW2ZKDPNZUueA6vNv7BkLLTw6U9LqUzJp8ZOgLSfI8v+ApPD9z0ayKtwA4C/YRlEqt2nju95DoUKCdmhnyfmZfRcFExNN8HXZ5a5vLMKxks8fN94RNPHT9Fby5f9T5SZkM43W4Uekr3ihAMDwKWhbz2725mYfdCuFlRTFW7qClODJiloA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 14:02, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 28/05/26 9:09 am, Wen Jiang wrote:
> > On Wed, 27 May 2026 at 13:59, Dev Jain <dev.jain@arm.com> wrote:
> >>
> >>
> >>
> >> On 22/05/26 11:01 am, Wen Jiang wrote:
> >> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >>
> >> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> >> provides a clean interface by taking struct page **pages and mapping them
> >> via direct PTE iteration. This avoids the page table rewalk seen when
> >> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> >>
> >> Extend it to support larger page_shift values, and add PMD- and
> >> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
> >> since it now handles more than just small pages.
> >>
> >> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> >> iterate over pages one by one via vmap_range_noflush(), which would
> >> otherwise lead to page table rewalk. The code is now unified with the
> >> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
> >>
> >> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> >> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> >> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> >> ---
> >>  mm/vmalloc.c | 71 +++++++++++++++++++++++++++++-----------------------
> >>  1 file changed, 40 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >> index 53fd4ee460ea4..deb764abc0571 100644
> >> --- a/mm/vmalloc.c
> >> +++ b/mm/vmalloc.c
> >> @@ -543,8 +543,10 @@ void vunmap_range(unsigned long addr, unsigned long end)
> >>
> >>  static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> >> -             pgtbl_mod_mask *mask)
> >> +             pgtbl_mod_mask *mask, unsigned int shift)
> >>  {
> >> +     unsigned long pfn, size;
> >> +     unsigned int steps;
> >>       int err = 0;
> >>       pte_t *pte;
> >>
> >> @@ -575,9 +577,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >>                       break;
> >>               }
> >>
> >> -             set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> >> -             (*nr)++;
> >> -     } while (pte++, addr += PAGE_SIZE, addr != end);
> >> +             pfn = page_to_pfn(page);
> >> +             size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
> >> +             steps = PFN_DOWN(size);
> >> +     } while (pte += steps, *nr += steps, addr += size, addr != end);
> >>
> >>       lazy_mmu_mode_disable();
> >>       *mask |= PGTBL_PTE_MODIFIED;
> >> @@ -587,7 +590,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
> >>
> >>  static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> >> -             pgtbl_mod_mask *mask)
> >> +             pgtbl_mod_mask *mask, unsigned int shift)
> >>  {
> >>       pmd_t *pmd;
> >>       unsigned long next;
> >>> @@ -597,7 +600,27 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >>>               return -ENOMEM;
> >>>       do {
> >>>               next = pmd_addr_end(addr, end);
> >>> -             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> >>> +
> >>> +             if (shift == PMD_SHIFT) {
> >>> +                     struct page *page = pages[*nr];
> >>> +                     phys_addr_t phys_addr;
> >>> +
> >>> +                     if (WARN_ON(!page))
> >>> +                             return -ENOMEM;
> >>> +                     if (WARN_ON(!pfn_valid(page_to_pfn(page))))
> >>> +                             return -EINVAL;
> >>
> >>
> >> So I know these !page and !pfn_valid checks have been copied from vmap_pages_pte_range,
> >> but do they mean anything?
> >>
> >> I think pfn_valid() makes sense in that someone may take a random VA/PA, convert it into a struct
> >> page and pass to vmap layer. But I don't see how anyone would pass page == NULL? At the
> >> very least, returning ENOMEM does not make sense because the pages are not being
> >> allocated by vmap() but have already been allocated.
> >
> > Hi Dev,
> >
> > vmap() is EXPORT_SYMBOL with many callers across drivers, each
> > constructing the pages array differently. The !page check guards
> > against malformed arrays at this API boundary.
> >
> > The same -ENOMEM issue also exists in vmap_pages_pte_range().
> > Should I fix both in this patchset or leave it as a separate cleanup?
> >
> >>
> >>> +
> >>> +                     phys_addr = page_to_phys(page);
> >>> +
> >>> +                     if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
> >>> +                                             shift)) {
> >>> +                             *mask |= PGTBL_PMD_MODIFIED;
> >>> +                             *nr += 1 << (shift - PAGE_SHIFT);
> >>> +                             continue;
> >>> +                     }
> >>> +             }
> >>> +
> >>> +             if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
> >>>                       return -ENOMEM;
> >>>       } while (pmd++, addr = next, addr != end);
> >>>       return 0;
> >>> @@ -605,7 +628,7 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
> >>>
> >>>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >>>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> >>> -             pgtbl_mod_mask *mask)
> >>> +             pgtbl_mod_mask *mask, unsigned int shift)
> >>>  {
> >>>       pud_t *pud;
> >>>       unsigned long next;
> >>> @@ -615,7 +638,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >>>               return -ENOMEM;
> >>>       do {
> >>>               next = pud_addr_end(addr, end);
> >>> -             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> >>> +             if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
> >>>                       return -ENOMEM;
> >>>       } while (pud++, addr = next, addr != end);
> >>>       return 0;
> >>> @@ -623,7 +646,7 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >>>
> >>>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> >>>               unsigned long end, pgprot_t prot, struct page **pages, int *nr,
> >>> -             pgtbl_mod_mask *mask)
> >>> +             pgtbl_mod_mask *mask, unsigned int shift)
> >>>  {
> >>>       p4d_t *p4d;
> >>>       unsigned long next;
> >>> @@ -633,14 +656,14 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> >>>               return -ENOMEM;
> >>>       do {
> >>>               next = p4d_addr_end(addr, end);
> >>> -             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> >>> +             if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
> >>>                       return -ENOMEM;
> >>>       } while (p4d++, addr = next, addr != end);
> >>>       return 0;
> >>>  }
> >>>
> >>> -static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >>> -             pgprot_t prot, struct page **pages)
> >>> +static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
> >>> +             pgprot_t prot, struct page **pages, unsigned int shift)
> >>>  {
> >>>       unsigned long start = addr;
> >>>       pgd_t *pgd;
> >>> @@ -655,7 +678,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>               next = pgd_addr_end(addr, end);
> >>>               if (pgd_bad(*pgd))
> >>>                       mask |= PGTBL_PGD_MODIFIED;
> >>> -             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
> >>> +             err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
> >>>               if (err)
> >>>                       break;
> >>>       } while (pgd++, addr = next, addr != end);
> >>> @@ -678,27 +701,13 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>>               pgprot_t prot, struct page **pages, unsigned int page_shift)
> >>>  {
> >>> -     unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> >>> -
> >>>       WARN_ON(page_shift < PAGE_SHIFT);
> >>>
> >>> -     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> >>> -                     page_shift == PAGE_SHIFT)
> >>> -             return vmap_small_pages_range_noflush(addr, end, prot, pages);
> >>> +     if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
> >>> +             page_shift = PAGE_SHIFT;
> >>>
> >>> -     for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> >>> -             int err;
> >>> -
> >>> -             err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> >>> -                                     page_to_phys(pages[i]), prot,
> >>> -                                     page_shift);
> >>> -             if (err)
> >>> -                     return err;
> >>> -
> >>> -             addr += 1UL << page_shift;
> >>> -     }
> >>> -
> >>> -     return 0;
> >>> +     return vmap_pages_range_noflush_walk(addr, end, prot, pages,
> >>> +                     min(page_shift, PMD_SHIFT));
> >>
> >>
> >> We can easily extend to PUD huge mappings right? Not sure whether we
> >> should keep everything symmetric to how vmap_range_noflush() operates
> >> right now, since P4D mappings don't exist, but PUD looks worthwhile.
> >>
> >
> > PUD mapping requires 1GB of contiguous physical memory, but the buddy
> > allocator's MAX_PAGE_ORDER is 10 (4MB on 4K pages). So page_shift
> > passed to vmap_pages_range_noflush_walk() never exceeds PMD_SHIFT.
>
> Can we then just drop the min()? You can guard the try_huge_pmd with
> shift >= PMD_SHIFT - the walker has the necessary ingredients to work
> with a shift > PMD_SHIFT, so let us not confuse by this min() truncation.
>

Will Drop the min() here.
Thanks.

> >
> > Thanks,
> > Wen
> >>>  }
> >>>
> >>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> >>
>

