Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA09C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F106B008A; Thu, 10 Sep 2026 03:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676EC6B008C; Thu, 10 Sep 2026 03:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58E466B0093; Thu, 10 Sep 2026 03:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3516B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:24:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78F441C2362
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:24:19 +0000 (UTC)
X-FDA: 85197014238.24.B2E2C6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0074C0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:24:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nGNmtk/u";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789025057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H0fpNs1u2zA59LHwwiy7WHc6/WIJfww4jvMkei3i1w=;
	b=t4XMJQw4jEVnz8RLa3zJtcg6Lwk7CtNjRB7zjI7mEtVXTFvTeeqmHLhjwetvj9IOjRfVfE
	tLW2n8WGoBfBiLojs513iy3H72HrFyGvbewn5/vP2fwswNyXXPZqy+t5s783qy/0GspJPT
	cds0Nk6tQDZGo8lwkp7uBb5e/bmAc7E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nGNmtk/u";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789025057;
	b=exomJPwtKteW2RlFGVdR8ldytpQMawMCiBCbwTBqfQlySl2BF83vsdwGZWDwrPnnR9CslM
	J7eUqJHOZhXI7S96KBNY5Xf5vK+XJgSDo/D5bk5IMz/wpPe73iklzJXpgbEGBGbXf9xBXE
	eL5Wdh1JRIgtIgEJvF58Nc+baRaIC5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8E5441FB1;
	Thu, 10 Sep 2026 07:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D771F00893;
	Thu, 10 Sep 2026 07:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025056;
	bh=5H0fpNs1u2zA59LHwwiy7WHc6/WIJfww4jvMkei3i1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nGNmtk/uUfrvTANOP4Z71YxO05bFTpamO/8A3iABLVEZ0H5p58w4eKN4eDoxZMawr
	 u2Qo+FzRBiKnOi4Ut0BI5PjVKJ8UCnbphj/n7kwx+HsMYerTZNtZSf9TZy4mCuBKEx
	 GTqOpjgvxWXOpM/LV5M5WO3dgUGgkaA69lsELeiMaOV07HAwo2+yOi3d/12/XGPqAe
	 DbQUSH7ZDKsYJP1GRszmNRlCszWRZCUP5nsQ3XtmpPxUrN4MMvGRGMebRcM+I4T1OF
	 YpWFa/BbpRw1lnLTJau/r1dkERdMVkVYkNL4dYaSkg0bwyDi8/CkxjyB3XZ9Vm7jBL
	 J1MEL62jLCcuw==
Date: Thu, 10 Sep 2026 10:24:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
	ljs@kernel.org, usama.arif@linux.dev, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Message-ID: <aqJbFXjU53_D7SoP@kernel.org>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
 <CA+qSx6yjiXJkQm=hi=F8=_=DU0x_usSuXnL_1yuy0fUU9UU-Zg@mail.gmail.com>
 <d3723be0-46f4-4025-b526-e1bb3cc2cad6@kernel.org>
 <CA+qSx6x2-Md9uVZo+HV0z5CfmGPDzhL482eJNnM2VYVtn_e72w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+qSx6x2-Md9uVZo+HV0z5CfmGPDzhL482eJNnM2VYVtn_e72w@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0074C0009
X-Stat-Signature: 74frnunuab8315zpf5cnbnbydappjf98
X-Rspam-User: 
X-HE-Tag: 1789025057-245317
X-HE-Meta: U2FsdGVkX19HQDkPa2IFW/XtJDybkidmnx6clsS9kBMp7oTHNu8+tu0YWKmsrTbAICjodlItcE3g+WHbanJchXuQSFMI7tlNr1JNVOUIXpNV0MG8NE7Jhf6P0Yfd8BFuiqGTOXajmziGFUD2ApNK+Hvd2mwMGHUkS1OEY/CqsEDsko46BbdwxmActH0Zh4Tunc8ac5k3P4Ol9OFK3KaOpxjuDUxglc/joH3TXwnUGRjs3ritDHvHwLfbtzRUvFSa4MqkxF5srMRAVhm7Fg+hTNIhd4hzPCwTKqSoWva6a7iz+RgmV4cqzoWUATR90WP4N/zYen0RUod0uBjwMHVay3l1y5wLJM4FtPTsuq8PMqQPaI7yNoX8y6Uro3JdJ0kyPDS9DjM/srvz5ieMM9W3ui1qIEo1NquRTb1dVlH/gTRvGnye0T6S10pGYW1h6pmR78SBzD7nOxEbZzwoUyoWQr9bynEEWvk07eppiTHBBv2b7xq6hs7YvcrGkaYTRzowWD892QPizb/S/dKzCs/bZX0a5L8XXaiuRD41nnGSQRW1u9326YEjYSfZkThhkI5XlOZw8QzEV3/CRBAWkprhl46ocbdgQ9IezZoS8JlbgB09szXIY8HE5+qhZuwRSOYsT4+Xt09lPVGARTjuApHRQ0WXz781ZYI+LnIw8tTlVvbdTLslLUxaM9234cvKO1LwIQyl5PNgYG9hJrprIBJA84FjXThiaSK1uiyL0g7YduI5QSCPukgJOYUTYdol5hhgotHTjw+Qf0XX0yc+MXvPOx14PHXX8oh4Pe86ebbaLojBc8UGR30Gizma2FuVAB+b5j1tq0r82B1+yZ1k9cY40CeumZvhofXBdTBAT6i+GMNciUPydkFAs/FKfrW98wQJCRqZ4P7PyIYFUnsrza7uAVcpEYBuUEg4LrndG1nbF1wXOr0j1CFde4lPCysPYINbwnG2IdxPp00JBGkCPr3
 V6fvpvZ5
 gxc+OZgaYkU1NMKsYSmIgivVXklWTboNdCmtDbQRgBgXynMIqP9e6jAa4GIJ05PoFWco0gAvWJztixC5cIAdfN76T1Ypp8F28i4WwIWDsGuf9mSjxWAec/TqZX2hkgRGb7Z433V+3VXw1qirZb4t70GnOkUZOzIRSqRq8hJON3sMyc4ggNKIy4CrnZRTprI3lhJU0chDoZRmCQ1RlG0L+dcCOR7NVuEYk1uPSBhrDRerleYDCwys4Snq8HL6hDF7dgQ69WWrqRp9JJEJiUimtVKsPgZwvHnCuy/E2eRM9ef7+G9kSDC5Y0YvVlfo4rImhxzGVOn9fAUVHp6UmPq7qVpc6q9wN9G8/YpT8y18w6Tvo1eCqKEJf6uCdr07GzoOHHozMQ72sExIBDp0hGhpzDY4spGcbfPgN2+JGzUf/v8MWHmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:22:25PM +0800, Xueyuan Chen wrote:
> On Wed, Sep 9, 2026 at 11:18 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/8/26 16:48, Xueyuan Chen wrote:
> > > On Tue, Sep 8, 2026 at 4:30 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> > >>
> > >> On 9/1/26 17:18, Xueyuan Chen wrote:
> > >>> The persistent huge zero folio is shared globally and should stay zero
> > >>> after initialization. As Jann Horn pointed out [1], kernel bugs have
> > >>> ended up writing to pages that were meant to be read-only, including in
> > >>> security-sensitive cases. Making the folio read-only in the direct map
> > >>> turns such writes into faults instead of silent zero-page corruption.
> > >>>
> > >>> Add a page-based helper consistent with the existing direct-map interfaces.
> > >>> Handle TLB invalidation in the architecture implementation; unsupported
> > >>> architectures retain their current behavior.
> > >>>
> > >>> Protect the folio after initialization. Skip highmem folios, which have no
> > >>> permanent direct-map mapping.
> > >>>
> > >>> Inspired by Jann Horn's read-only zero page work [1] and follow-up
> > >>> discussion [3] with Yang Shi.
> > >>>
> > >>> Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
> > >>> Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
> > >>> Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]
> > >>>
> > >>> Suggested-by: David Hildenbrand <david@kernel.org>
> > >>> Suggested-by: Usama Arif <usama.arif@linux.dev>
> > >>> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > >>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > >>> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > >>> ---
> > >>>  include/linux/set_memory.h | 17 +++++++++++++++++
> > >>>  mm/huge_memory.c           | 13 ++++++++++---
> > >>>  2 files changed, 27 insertions(+), 3 deletions(-)
> > >>>
> > >>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> > >>> index 3fe293cfed8c..ed9ce04b18a1 100644
> > >>> --- a/include/linux/set_memory.h
> > >>> +++ b/include/linux/set_memory.h
> > >>> @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
> > >>>  #endif
> > >>>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> > >>>
> > >>> +#ifndef set_direct_map_ro
> > >>> +/**
> > >>> + * set_direct_map_ro - make a direct-map range read-only
> > >>> + * @page: first page in the direct-map range
> > >>> + * @nr: number of pages in the range
> > >>> + *
> > >>> + * Make the direct-map range starting at @page read-only and invalidate stale
> > >>> + * writable translations before returning.
> > >>> + *
> > >>> + * Return: 0 on success, or a negative error code on failure.
> > >>> + */
> > >>> +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
> > >>> +{
> > >>> +     return 0;
> > >>> +}
> > >>> +#endif
> > >>> +
> > >>>  #ifdef CONFIG_X86_64
> > >>>  int set_mce_nospec(unsigned long pfn);
> > >>>  int clear_mce_nospec(unsigned long pfn);
> > >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > >>> index 54494c3fa983..742283b36d74 100644
> > >>> --- a/mm/huge_memory.c
> > >>> +++ b/mm/huge_memory.c
> > >>> @@ -42,6 +42,7 @@
> > >>>  #include <linux/pgalloc_tag.h>
> > >>>  #include <linux/pagewalk.h>
> > >>>  #include <linux/cleanup.h>
> > >>> +#include <linux/set_memory.h>
> > >>>
> > >>>  #include <asm/tlb.h>
> > >>>  #include "internal.h"
> > >>> @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
> > >>>       huge_zero_folio = alloc_huge_zero_folio();
> > >>>       if (!huge_zero_folio) {
> > >>>               pr_warn("Allocating persistent huge zero folio failed\n");
> > >>> -     } else {
> > >>> -             huge_zero_pfn = folio_pfn(huge_zero_folio);
> > >>> -             count_vm_event(THP_ZERO_PAGE_ALLOC);
> > >>> +             return 0;
> > >>>       }
> > >>> +
> > >>> +     huge_zero_pfn = folio_pfn(huge_zero_folio);
> > >>> +     count_vm_event(THP_ZERO_PAGE_ALLOC);
> > >>> +
> > >>> +     /* Highmem folios have no permanent direct-map mapping to protect. */
> > >>> +     if (!folio_test_highmem(huge_zero_folio))
> > >>> +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_PMD_NR);
> > >>
> > >> Assuming we keep the page-based approach, can't we just move the highmem test in
> > >> there?
> > >
> > > Hi David,
> > >
> > > We can move the check into set_direct_map_ro(). However, on x86,
> > > set_direct_map_invalid_noflush() and set_direct_map_default_noflush()
> > > also expect callers to exclude highmem pages.
> > >
> > > Would it make sense to make highmem a documented no-op for those
> > > helpers as well, so the direct-map APIs handle it consistently?
> >
> > I think getting something consistent for now is the most important thing. :)
> >
> Hi David,
> 
> OK, I'll move the highmem check into set_direct_map_ro().

Consistent means leaving highmem check in the caller ...
 
> Should I also update the x86 set_direct_map_invalid_noflush() and
> set_direct_map_default_noflush() helpers in this series to skip
> highmem pages?

... or checking it in all set_direct_map functions.

I'd keep the check in huge_zero_init() in this patchset.

> Thanks,
> Xueyuan
> > --
> > Cheers,
> >
> > David

-- 
Sincerely yours,
Mike.

