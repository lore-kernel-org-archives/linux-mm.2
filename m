Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77511CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FC06B008C; Tue, 19 May 2026 09:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20726B0092; Tue, 19 May 2026 09:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36366B0093; Tue, 19 May 2026 09:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 915266B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:39:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13378C1952
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:39:51 +0000 (UTC)
X-FDA: 84784277382.12.A759C7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6273920002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:39:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZePrlUUj;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779197989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWF5XfW9chsqGrjXYDJmzWSs3rM+V79PPtuBQCit/f8=;
	b=710ZUJttS9m2yEFb32BgL1wnVhHMwwK9xsBvqi7+MCe1sZseKagM5g9Hi+SujR3/UCVerh
	uP7+2O4Xn68tu1yr7uAtz71gBU4g6tYCL0KqMWySad6Xhbt4ldg/5jZ5Bc1v4fJoYXgPXF
	oiZI09poNJvlgy53WEWaO4St5QQEBFs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZePrlUUj;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779197989; a=rsa-sha256;
	cv=none;
	b=C4Vc31AVM1TGMSqGlcIZT6q2lg+5oXWeDuvzDjyYeUdXDU7JPJiV9aOTrAPlOgX515XLEb
	7EbYr8vAbOkBPYLMi+gpDWmFhRSSf5o7zrWvxKP4nba9UN+wOkWIhbz8t80J9hrlHTnV2g
	QAxNaXIuvVQTVNwkBxSRG9n9NEb3cD8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D9A943C24;
	Tue, 19 May 2026 13:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FE8C2BCB3;
	Tue, 19 May 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779197988;
	bh=D+t330bY9theuHhQ7vQ9fk2hC/8pGFvUL2f87DQe0QQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZePrlUUjoJ6SRML9KTxFEObiSG/GUCVskJopia2OR/NHWF6W+fo2AUoXx/To3zWWb
	 VdFfdF5cL7Dr7E5H6/FcZR0Mk/DI7CxgdxvQLx0rIlIz9/yGZtLcI+6fw3Px7X5xRS
	 /+pxvp2iSCV6J2igJobyEQO5YqAqmSCe5Fdrd4BbRBbRPRUfOZzFXyT8bjqBKlkoGV
	 FFVFOTFSR+yl/lIgyRxF273rU0nwoh/xIf98oDAucm/68fnhiB5diwWjSDoZ0rVmam
	 MgNbD3EuMgIzR9wpMwcKmyM2IpEgfnF1Pv+9MLoF6/BTWGGcSu0LjK+iIfhejRQJxJ
	 nEGvcqVGx0kUA==
Date: Tue, 19 May 2026 14:39:38 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yang Shi <shy828301@gmail.com>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	surenb@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <agxnJ8R-G3CRjeTR@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
 <agxfLNuLCAT3F4cW@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agxfLNuLCAT3F4cW@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6273920002
X-Stat-Signature: fbw36m15wxnjn9jubxijrujg4mat6n5u
X-HE-Tag: 1779197989-722894
X-HE-Meta: U2FsdGVkX196SPCSgH2l2vtzmMvlnDdDdANOkV7PZNyxFaZrbEjVKirsEjl1bskpIpUkWkJLI9eY0TphOzdWOB5EYdtVbV9RYP2NCLx511jcbIavT1m46mnRD1a6I2y5AKl1zptE+rJaQylE/sRRZeYugoXAEOkyY8Qsx9csAv+k+6VGmq18wi48Rir9Cmlg4OsIfSaTM8bElXJd8KLGwvaEk2TBGobbZc6JHSifV//nNQ2n6NFd7XsMhM3r84DjbXCHVR6Efm24Ji8nE5foW4y8RiKLf81l2sc5Vv4oAH4rAYJqmmN+FbHM8fvT85VAeul5DEY835OPRvzaMnInN0ephJJsbxzT8YnHNSlvwPnyjphSDK4d7syUo/XHiuCkzHBVQ8AAkqjs2uH0ChtKb4NSbDVGAHkacVsB3clA/FRukMOvgbvd/rhWhzhpD+zScxosQb1Aa/BVUFKN6E6UHPj/pEbryvgfPtE0rhKcmU2fkAyOdvQpRHk/NTuKb6Bgbd33IfcCrZWRK9BkJ/qh1ZW2poiN3FRON5oPEn5gaGinET83vn7rLmW4jjI2ZoY54o0gZIFSUooPnSePpgH3chjkKW2eVBexqhtRrnbD7ZC6+AP8b8+xy2tAA1Z0SVklUQDX9lyLBdIyzg8rlluKqShZl0LL19sW/FLP0RIBQ+2zdmOi8YYhMOL+MiNiDaHwtlq6gGBMJQm9tqhLDj+GIz4G6nkdmKqPhQRFJJfvl+DWo91WUcbm4N6Soan2XKUmiUVbPPly3x5sm/dRE9hEF1jqW//8aM35Fx8PLaWNXyEMRwmLKnew9uuDKNXTKGRx/erJdYnTsblW1dduOb0LGZzgl+kpjV0X49WotRThNIk3hv6ojJbjdPH0p4/S2dMan5YkdW/l1+kQpobEjPL4c+sd5nIJjp6Gm7AgwDlIqo1aq4y8a6OoFHDLCIlW45cbvWN60DeRm7yN8G90VfU
 LxfK70WP
 IQmje28yeZ0UnWQDZviHwPqFyCL2MxwMEDtZEz7M/7VjsHKEe4XJBhTVlL6Xt71XlLEJtyTyTVrjrgZfhfCLhjpND/1sWx1nWrrBiJJn3cvl73TJHWe+6TMLpuRbkyR+X+f2KheFiSfQneLJSvAjAPIelWN1ud9JaRPlm51k2Qd+wEmD63lDH/e0Td2tQUU6N0KUtAWKxbIaEa7bZWm8UivUnjbOwEK1fK/KoDq7udtQ92oT3mSsGXmI7gMXMBeC1Iy0A/xyca49cHc2n2cOZIKeTeuq2tBuPfFg2elLjoLncEXLVv3pMC5RZoQig3ifR53muJHB38QDfcrnUG1SVFXdfxhx92XR7xKyF1oOQAIhtMO81KMB79RRICgQzefH2kl09AbSTCjiDKd8pY8T2qiaGA5ZuFopF0jSznaKrP4wMDXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 02:12:10PM +0100, Lorenzo Stoakes wrote:
> On Mon, May 18, 2026 at 02:21:14PM -0700, Yang Shi wrote:
> > Maybe a little bit off topic. This is an interesting idea. It seems
> > possible we don't have to take vma write lock unconditionally. IIUC
> > the write lock is mainly used to serialize against page fault and
> > madvise, right? I got a crazy idea off the top of my head. We may be
>
> Err no, it serialises against literally any modification or read of any
> characteristic of VMAs.
>
> > able to just take vma write lock iff vma->anon_vma is not NULL.
>
> Except if we don't take it and vma->anon_vma is NULL, then somebody can
> anon_vma_prepare() and change vma->anon_vma midway through a fork and completely
> screw up the anon_vma fork hierarchy.

correction: this won't happen as per Barry (see - I managed to confuse myself
here :), since for vma->anon_vma install we take the mmap read lock.

BUT we also have to consider other cases.

>
> So no.
>
> >
> > First of all, write mmap_lock is held, so the vma can't go or be
> > changed under us.
>
> vma->anon_vma can be changed.

Correction: no it can't :)

>
> >
> > Secondly, if vma->anon_vma is NULL, it basically means either no page
> > fault happened or no cow happened, so there is no page table to copy,
> > this is also what copy_page_range() does currently. So we can shrink
> > the critical section to:
>
> Firstly, with no VMA write lock, !vma->anon_vma means a fault can race and
> secondly copy_page_range() checks vma_needs_copy(), there are other cases - PFN
> maps, mixed maps, UFFD W/P (ugh), guard regions.
>
> So yeah this isn't sufficient.

However this is true...

>
> >
> > if (vma->anon_vma) {
> >     vma_start_write_killable(src_vma);
> >     anon_vma_fork(dst_vma, src_vma);
> >     copy_page_range(dst_vma, src_vma);
> > }
>
> Yeah that's totally broken fo reasons above as I said :)
>
> >
> > But page fault can happen before write mmap_lock is taken, when we
> > check vma->anon_vma, it is possible it has not been set up yet. But it
> > seems to be equivalent to page fault after fork and won't break the
> > semantic.
>
> It will totally break how the anon_vma hierarchy works :) See the links at the
> top of https://ljs.io/talks for a link to various slides on anon_vma behaviour
> (it's really a pain to think about because it's a super broken abstraction).
>
> You could end up with a CoW mapping that's unreachable from rmap and you could
> get some nasty issues with page table entries pointing at freed folios :)

Correction: actually we should be safe given mmap read lock on anon_vma install.

>
> >
> > Anyway, just a crazy idea, I may miss some corner cases.
>
> Yeah sorry to push back here but this is just not a viable approach.
>
> And this is forgetting that we have relied on page faults being blocked by fork
> _forever_, who knows what else has baked in assumptions about that
> serialisation.
>
> Forking is one of the nastiest parts of mm and has had multiple, subtle, corner
> case breakages that have been a nightmare to deal with.
>
> So I'm very much against changing this behaviour to try to fix something in the
> fault path.
>
> We should address the fault path issues in the fault path :)

Above still all true though.

>
> >
> > Thanks,
> > Yang
> >
> > }
> >
> > >
> > > Based on the above, we may want to re-check whether fork()
> > > can be blocked by page faults. At the same time, if Suren,
> > > you, or anyone else has any comments, please feel free to
> > > share them.
> > >
> > > Best Regards
> > > Barry
> > >
>
> Cheers, Lorenzo

So still a nope :)

Cheers, Lorenzo

