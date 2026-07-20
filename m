Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D41BC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8CF6B0088; Mon, 20 Jul 2026 12:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143766B008A; Mon, 20 Jul 2026 12:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00AE76B008C; Mon, 20 Jul 2026 12:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5FAD6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:20:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68595140150
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:20:27 +0000 (UTC)
X-FDA: 85009667694.01.8A5554B
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D1CF40004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:20:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MWwZE8b3;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784564425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vFiPyyxqygcPr9AB+QzIanv6PSd6terHfc4F9kMV64=;
	b=TudVRgyfn4cUDmislDBmZI3Z3+irWVI0YjPzMpEKw4mpAWYhzyrxbz7DATQCAWRxHbE7j1
	l7OZkD+PA8+Xtjnsp1pMmzaPGQzxFKLRu96hNabVxSVwc+ly4PoGxmh8OM9dw2hajsysBy
	ykEJVPCtohvXstRk5VnK6RC/LFFGpso=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784564425;
	b=wmgyKGeuKXqeKvccaMYHdeybsTH5RTX6bGSTJDKa/E+Q2KjIJNKK+O0zDveHKwephlx5oE
	SnSZf9gP20hOFpBf139S/WMc98QfzpQQh0Nf8H98xwq+Df91Po5yS83nXJQQypGIutSYoq
	jtyCWzpcV3T4J1Gpw24ZsmY12melN0A=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MWwZE8b3;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f73d9c177so1255940f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:20:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784564424; cv=none;
        d=google.com; s=arc-20260327;
        b=hDkWDxL3BZ+1K/fk7sGE+emIWfnHeiGBL3q+cFJ56IeF1qeZARAakA4R+iD7lAgtOi
         rUyM4iLCBtzzScHzYN6WCpHkGF/2yTcmd3zzU9r3J9MsFC3/valmLCev1VEGVPZL3ugp
         kPuE1L7b1Gewxfi+YlBd4diHeTxD6CV39K9iy24aymKEckQysOvJIorLXK5VwZ0WxhXd
         EhjxuII5ljlRZo74wnpAne9uklwnhkkCq+B50FAjPEyIHM8rL6cS/tDgtRMbqTQN3P69
         Mk8DqEkbWi1/G/+4yUN7M4Kt7QxPS0QhjbLXb9EUPrvROCgK269ovgg6Z7MAFI6dJa6v
         HysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/vFiPyyxqygcPr9AB+QzIanv6PSd6terHfc4F9kMV64=;
        fh=GvBBnbYTFlz+PRxp9IsB0T6XE925HSKjwZKZP+igWX4=;
        b=e8BRdR6LGsswgCzu4Tc8tWMhjEnHbVyzlNOhmDaxT7suTuIqWw8rux8vGN0R99Z/Nu
         2yotBtDTw7teMd5b+tJgfKnR6LqfC/EsvOaNlRh31SWyDswm6TnmSUa30neMg2oM6dEK
         yx2hTByAKMRMylSufe+GLhqewPfhUWuPONjXAm96rA0fV5mxNgmqIHsLP/dV4cWY0Vju
         GgP6ctiDrDQgqYBLLzEs1A9/bk+gRmlrgmwLffD116BmNOeUN5hAFieuh8r2imLeynEp
         ucb1EISlXYz7mPB1FGg/xsqHmRsprEigW/AdRXflUJKyKOk+iNsnio6suHI1msutK+LB
         cIzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784564424; x=1785169224; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vFiPyyxqygcPr9AB+QzIanv6PSd6terHfc4F9kMV64=;
        b=MWwZE8b3sJRdZITk1ytcnhVcwnYAEvRP+VOepSoxIYdkCaenZU/dagSkudMVHsunVu
         +fWUaXRlsPnGE+8GOZF8dLClAKK77O+Gwv36KbLuHoHkCnCWLieORUMuXrxPx3DSADsI
         7RcgEvoKfXIkN2nxTcgL0xcSlmnScQe1Xw5E+IerpkeSOw9G0eYOZePyZdmq1HHkeqq9
         WAmpuMNW40tcYe4U3GsUq3kTa6OWvuhDK98qHcEjV3ruEFy1190WN/ZeVy/8zaQfismm
         7guP5Ewt1B6cM0wZflN3xVIz92sh9kEEimwUXmzyIA8DXslf2szsRRpo4MsD75diLJOI
         HdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784564424; x=1785169224;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vFiPyyxqygcPr9AB+QzIanv6PSd6terHfc4F9kMV64=;
        b=bw1HSLSTWqmGV3eJyCzhsAw9qhAZ/mtZoiB8Lra+xpKknd6xyJWpXWH4hSOcZHjFDT
         r3utrpb28XxwjfUKvjAVPVgCGKZ2eqindZAjXCv6yEXmijFa41gsosaQJ+ICQjFzhz+B
         eXBVP3sMFl0CqacVBH24ZXdPWdZtS1vFTT58P3bImKFJMakqtxcTOYsK28ClV9Qv3hQC
         pRCyyo3gNh77pwZS6e4WWW/EnqVuKEiIb6fkjByBWpyDzm5oKkXlgtG4t4k91+q2zOXb
         4V6kSUBKbLNKmaHbX5m0kC5bidEJ6rAvd7SnoZiiJW6ShU75KOhpOUWkXmEouH3XJPGi
         ek+g==
X-Forwarded-Encrypted: i=1; AHgh+RrKRrjof4egxy95MEHNLI4jO69TMWTi5dP1+1ulTZsSS6NaK2LmdYzsf541We2DCMMSYOzj2iQ0Hg==@kvack.org
X-Gm-Message-State: AOJu0YxtpQkwoSZ08cQGeotN3cyLUDGlrLUfIc4yEKKviLOTUoroUwJn
	FvEgzzN18lGHCbzNHkqrA7rLqDsAOaEAqAaiqoTWA1eGYhpt6gYYVoJ9gLyV882FyluJNsoNrk7
	6avT7bnZtZE4e69UnjWmSqEFObzPsKX4=
X-Gm-Gg: AR+sD124/VwudrUd4BIDyWoDJCyxAw0wAc9lp2+ddxljL4hytDINjXL3dGANVqm9ggQ
	bUS+1vdbl9LuURdYY/ggZ/4zwgbjxufhhfL2bxvdu5Zj75JOw85qImaDiRXuEAJfy3ex82Xtjlw
	NL0Oxltao+1ocp+cKjb27NqsYM1UewjZDbFgVzBTPx/L2tJeOtTSCO4NMEAV0b0yGzDM/nMcAEF
	377ndqeZ7DCo0k06z12EhBTwg6R1DXZ/iWuu4QWE9KMH7lY78CU0WRvrlax7F4qEUoyZHZthA==
X-Received: by 2002:a05:6000:1867:b0:474:18d9:8371 with SMTP id
 ffacd0b85a97d-47f6232f892mr18800180f8f.28.1784564423558; Mon, 20 Jul 2026
 09:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-7-jiangwen6@xiaomi.com> <fbea7f50-ee00-4466-8788-1cc78303f5bc@kernel.org>
 <e650604f-316c-48f6-8279-05c162bcdf21@arm.com>
In-Reply-To: <e650604f-316c-48f6-8279-05c162bcdf21@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 21 Jul 2026 00:20:11 +0800
X-Gm-Features: AUfX_mzdfBVwd0mjN4bJsO5McXaUPCM3nRHEVhS23VrexlpfVv3MRB_TTgQn5iw
Message-ID: <CAHKocdEeYvdWq2hoot2cbJ1jhKnZbkbayRX841_gdv5gntQ4cw@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	linux-mm@kvack.org, urezki@gmail.com, will@kernel.org, 
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, baohua@kernel.org, 
	Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D1CF40004
X-Stat-Signature: meeg1ze5gorigfu5ahrxweqtccmeh943
X-Rspam-User: 
X-HE-Tag: 1784564425-418262
X-HE-Meta: U2FsdGVkX18MKUGVipEiRa4iGWtKawFvVDX/ptJuaidnz4B1JWw+W6K2ivLuapzvbpQQJlnyn79Ct9EN0x28uX4qVU8XFRepwA1ERt5mRtcuKtiKFj6BsxVEP33ibQIfaaYM0MrcBC0BeLFChEiRuAQJ8RofWovwi5jZDrkW6dwSqsawBYqOtz2U62MfUkOBYkx8bzmAGhjsdNey0EIpco7pf53tRJCIUUdzwFVkcJmvEzJDnH8kssukU0TLYCyWTBrVp7IYPlfWBSJn3XdubmMFomxvOUsdc34QZ5DofitYx3kryIDB07C5IimuQucJupJtis7nvd9W6fg0AFU0pAY43rS8ykW0lN9zwmQM3HwB7oW0EaZWCr3Mfo9W6nGIAo7K9tmxxWiidy0aT9Kq30nTw08vU8W7iqA1ssxeBZGdjJuuvboZGJbSHjCKJPPWFwwLB9TkHE8d3g3Ll6i66wqTKkKLwj3Sb2S++iNXJe7Lf9ykzQYS18QAno4dBOkzRuMdwLIo1q6Wb0ariRLG75PAL1LFnlRrBe/O/uSaw3ii3Jc+WNXfwkD3yqpAe4JbBme/TNx0gCA03rBn4DLiHsxWIVz6jheax0QQ1GoQy/u7UOLxBcUUEWM+PAkdcQSR60o2Wjh9cXlmWt1R9/RxZ9DcCTZHYCTzJP1TOIfBaTFs0y3qIIDVTt72+CMmTkYvc9Z/ioyFHPIGFSAtGq4Ty9LlisOQ3bGdFNORQr00UC2TgC8L+9foHy8MvdaF1ftHczqL397AV2L1KCvbBHV90YOf1tO9Pv/YcanfMVfEBmfRHbJ5VK9w5Lnuj+NQx8F6cphXfeLkJ8Wv0Tbx7OhomYo4+Ypk/LEVxkRN6gkzM2ND9cj80xzrmB/iaYhbGbO/PfKqLN785ZgDqeRusFUINxkeJluENLZeOvtxP6C1Gw3o23QsQ8usG+bCWSPdERlWqkyoXBz4h57KZjOX3HJ
 Hnb70vrX
 gL/oo+bnqLbksk1qtdjonitU+/3oznitSxgD/SZzA4irN3fyMaDNabrgZwEGOpTJ4jKGF8kWUm+RVC/z5RdaerShtPZqDTr2XN+9Xw/mk3iso6WVzUeyDYncrHstNd7OgHpKR8BHsHy1x0aREgzLDfJ6PBdn8iVzU5a51SwMPk2BDpn4xj7gRfzhcATPPf2tPPILxkmyWXXxbgCNrjjzCCWyHNO6so48Awur9OnOYTxZ5BSJ+WwVS3ZKkC8bDxLqq4Iy59NryPfrRcUPxicHhfSyAaHGZ9pobdk0gyZWZmmYCUozwsuE7lWRlUcIUEw5j74rLbkxC38OYOTrazfZlihcrN+qMi1BTWPdb5fHpEKCNP4lmGcCboh+TjNo9KHrNbCtS6Pog5hPCjuovSTG9mT8nORfUtQN/qX4IJ6or4esCnNKkGWXCeiA/2fX5Xn0OBkTgVcvMzBoZdS3KURLGHEFfeTqQWimKlq5bhX/5lLw7GPjO2UsAnjR1nPtbbJPdBmmpEmEC7ItSGDf2gTSVsvmFC2UsfxiVgwWl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 at 15:50, Dev Jain <dev.jain@arm.com> wrote:
>
> [------]
>
> >> +
> >> +    nr_contig = num_pages_contiguous(&pages[idx], max_steps);
> >> +    if (nr_contig < 2)
> >> +            return 0;
> >> +
> >> +    order = ilog2(nr_contig);
> >> +    pfn = page_to_pfn(pages[idx]);
> >> +
> >> +    /* Limit order by pfn alignment */
> >> +    if (pfn > 0)
> >> +            order = min_t(int, order, __ffs(pfn));
> >
> > Wouldn't it make sense to determine that before you call num_pages_contiguous?
> > Because then, you can just scan to that maximum instead of the given nr_pages.
>
> Right!
>
>

Agreed. I will check the PFN alignment limit first before calling
num_pages_contiguous() to avoid unnecessary scanning.

> >> +    unsigned int prev_shift = 0, idx = 0;
> >> +    unsigned long map_addr = addr, batch_end = addr;
> >> +    int err;
> >> +
> >> +    err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> >> +                                         PAGE_SHIFT, GFP_KERNEL);
> >
> > Is the indentation on the second parameter line off?
> >

Will check this, thanks.

> >> +    if (err)
> >> +            goto out;
> >> +
> >> +    for (unsigned int i = 0; i < count; ) {
> >> +            unsigned int shift = PAGE_SHIFT +
> >> +                    get_vmap_batch_order(pages, prot, count - i, i);
> >
> > Having two indices, i and idx, is just confusing.
> >

How about renaming idx to batch_start? I think using i and batch_start
will make the logic much clearer.

> > The whole function is a bit overly complicated. Does it really buy us much to
> > batch over vmap_pages_range_noflush_walk() calling with the same shift?
>
> It will buy us more in the sense that, vmap() speed is sensitive to the number
> of pagetable walks. I think that is reflected by the ioremap(1MB) 1.35x speedup
> mentioned in the cover letter.
>
> In terms of callers, not sure. I would expect a caller to get the highest
> power of 2 from the total needed nr_pages, then get the next highest power
> of 2 from the remaining, and so on.
>
> For the arm64 TRBE usecase, the relevant code is the rb_alloc_aux_page() caller in
> kernel/events/ring_buffer.c. We may get multiple same order requests if can't
> get the first requested higher order.
>
> Since on the cover letter I see Wen and team have tested on boards, I lean
> towards saying it is reasonable to assume a usecase where such order
> fallback can happen.
>

Thanks. The batching is necessary because it significantly reduces
page table walks and effectively handles fallback scenarios (such as
the arm64 TRBE use case).

> But yeah the code for this currently is not so nice I agree.
>
> >
> >> +
> >> +            if (!i)
> >> +                    prev_shift = shift;
> >> +
> >> +            if (shift != prev_shift) {
> >> +                    err = vmap_pages_range_noflush_walk(map_addr, batch_end,
> >> +                                    prot, pages + idx, prev_shift);
> >> +                    if (err)
> >> +                            goto out;
> >> +                    prev_shift = shift;
> >> +                    map_addr = batch_end;
> >> +                    idx = i;
> >> +            }
> >> +
> >> +            /*
> >> +             * Once small pages are encountered, the remaining pages
> >> +             * are likely small as well.
> >
> > "small pages" is odd. Maybe
> >
> > "Once we fail to batch pages, we expect to fail batching for all remaining
> > pages, so just give up."
> >

Will update the comment.

> >> +             */
> >> +            if (shift == PAGE_SHIFT)
> >> +                    break;
> >> +
> >> +            batch_end += 1UL << shift;
> >> +            i += 1U << (shift - PAGE_SHIFT);
> >> +    }
> >> +
> >> +    /* Remaining */
> >> +    if (map_addr < end)
> >> +            err = vmap_pages_range_noflush_walk(map_addr, end,
> >> +                            prot, pages + idx, prev_shift);
> >> +
> >> +out:
> >> +    flush_cache_vmap(addr, end);
> >> +    return err;
> >> +}
> >> +
> >>  /**
> >>   * vmap - map an array of pages into virtually contiguous space
> >>   * @pages: array of page pointers
> >> @@ -3600,8 +3678,8 @@ void *vmap(struct page **pages, unsigned int count,
> >>              return NULL;
> >>
> >>      addr = (unsigned long)area->addr;
> >> -    if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> >> -                            pages, PAGE_SHIFT) < 0) {
> >> +    if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
> >> +                            pages) < 0) {
> >
> > Nit: single line would make that nicer to read.
> >
>

Once you confirm, I will send out a diff to address all the points
mentioned above. Thanks again for the review!

Best regards,
Wen

