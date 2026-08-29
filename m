Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE1EC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AA16B0092; Fri, 28 Aug 2026 21:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02586B0095; Fri, 28 Aug 2026 21:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9189A6B0096; Fri, 28 Aug 2026 21:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C78C6B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:05:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 691BF120600
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:05:08 +0000 (UTC)
X-FDA: 85152513096.19.D35135A
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id 267E2160002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:05:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=LsGt0bNu;
	spf=pass (imf08.hostedemail.com: domain of "prvs=694d194d3=zcgao@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=694d194d3=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787965506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnDR6DMNIm8190T9Mj0ZWeFFqjC7wiMNtZlDelqgd7U=;
	b=WxZ5I9LtyJPMJi2ZGPR0myoxmeHLEgDc65I1MF9jmdn4785yisaBnvPhB+2n3cmGFc/+q+
	9sl59eF82ZuJ3ZqBlMykuh4kK6eWEOLjGQcUouZqhKdvMS6lroP130OFq6rjZ3M9ihi9rH
	anc2TNj5ye5uDyokhvPAReA56Q+00Ws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=LsGt0bNu;
	spf=pass (imf08.hostedemail.com: domain of "prvs=694d194d3=zcgao@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=694d194d3=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787965506;
	b=2mmmAIplO+k9AbU1TcmEuX3PP7kDC4L7jmAV7L/fQWPXS25hILE5XDR4pyg/jq2qjsrVUM
	XO69TfI6+8ju0910kyL4oDWA+JdonV5gXprL48amEvWVOdytB8kHd/BcRXcYFd8ovLoOrM
	WX+WB8MJw7qxoZlDCfHYrRikR6hHDdQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787965506; x=1819501506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnDR6DMNIm8190T9Mj0ZWeFFqjC7wiMNtZlDelqgd7U=;
  b=LsGt0bNu2JEEn+J5FPFutmvA/H2kcIqnsg+qRM61Yn+E4egqkc5nZi1b
   XIj+4h4CBGYclO626Uv1AohqHsKXwUORWVbjTOcDs6q4fwO5mpTeLAtGh
   ORYbS/uQAOIHXZr2qCr32fdDpc3L3OZk1UvZCXjbY17Lb/WGvoR4TIZ9a
   EO0baXhgTJFIq8tBnCqizkcgDlkcnf6HAvCElPuc01ugzPCbGaRoInwko
   1TBE/5QO/DnqNisQ7HtMU/wbIwveKZ76tESPf8++AxiMkYYF/hcljVt5m
   vCEUbVjxZ0WixkyzLIUdFiMo/Bo2E8k3nYwBRTRyW3yk/rLmMgvklh7UN
   A==;
X-CSE-ConnectionGUID: l3w405B6Q3qTp7vJELniRA==
X-CSE-MsgGUID: XfIREu1fQeiEvPbPMsGFZQ==
X-IronPort-AV: E=Sophos;i="6.25,249,1779148800"; 
   d="scan'208";a="27259169"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2026 01:05:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:17926]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.13:2525] with esmtp (Farcaster)
 id b56c57eb-15a2-4d68-b802-e011e4869232; Sat, 29 Aug 2026 01:05:04 +0000 (UTC)
X-Farcaster-Flow-ID: b56c57eb-15a2-4d68-b802-e011e4869232
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Sat, 29 Aug 2026 01:05:04 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.170.21) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Sat, 29 Aug 2026 01:05:03 +0000
From: Nathan Gao <zcgao@amazon.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <baolin.wang@linux.alibaba.com>,
	<damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <stable@vger.kernel.org>, <zcgao@amazon.com>
Subject: Re: [PATCH] mm/damon: use a page-aligned sampling address
Date: Fri, 28 Aug 2026 18:04:55 -0700
Message-ID: <20260829010455.28607-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260828002211.61987-1-sj@kernel.org>
References: <20260828002211.61987-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.21]
X-ClientProxiedBy: EX19D037UWB001.ant.amazon.com (10.13.138.123) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: jn7iseejwarowix18u68sam9eghi4toc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 267E2160002
X-Rspam-User: 
X-HE-Tag: 1787965505-164177
X-HE-Meta: U2FsdGVkX1+V+kkqW9l/ROdV/HsG2NEqkbYN1FyWOFTN77Ou/umTzUH0dfZXuVOYcMlfIhHy28Yn0574KXCNys/kw5Qa9NbLfhGRmZY/b9N9QRxkvPLbpmelnzlMF6aA5VCd2Bk4Kk1aq52oufaKQ+vT97wU2vXATiQ21Al0sHjK3nvD4RgJAHAeADkJ9r2jlJ+IXtCyaZsCs6sr6q1inBT1ryUflWvLozLZtJnJHVI3AmxLD7jKXcZRxA/fDEYwbPDsCMJGgBXWGSN7xHgcthFEr4fota4F8j+tQejBfGSFqOQMb5W60iGU0cH4YVvZh/7/7dIjMEyhsrPKxKmB/vXvm8yx8okxj93RK+NwG9t0DfpLIcBpXlLVnCqaKC9TWio4DpIReEPLW+mu7QGbbv9hk6lje8X4sQYOTAQgHt/uA23VGfJgYyNHE+5bBsdGaw+b92iOuvTNTrh9EJtklW4lUi6BcKWhaJjh5hrefOwBQB2yTRQP1I1eb2obXr3/dxzpJsuj3zo+w2q7D464ceK4q4N0/CG8qXnIhQ4Yg2eJwV6GRKUV7Xbu3tUCVTxFS00a+awEBXW0JEgHSGn03qi74NiyE9vJP3N3F08NFhm1zxbLIi6x3ReMaczIkuX1kDsUqOwfQEiQAJpcKLcsGEV84ACkgsI+ThW3+9th6spuNdSaZ8fBtOq00zfXkOj9Bp+N6eckKQG8d+8PPMl1iqTUlMxI9k2xjCXSQBRuSFaNBJm/OEniXKze39njQD9zLueY6jNRyuM4dLzKCPXFv925faxTOKYuW2oTu2sMlltKDNBx6n8thguFn0CVCeSX5AP71fm2eHhp54obCj1fWYqqUyLR7kNOWCwJHFsSwiLca65UCs8+R15EECDQ/8gPoQqI1Op1+TCJLWaMaWHIxOMvBWad2QJJm6QRiRcMItC5MvWtFZkoHvNMDSySwOZXZb7159u4fvn7/nAzQXW
 Qqhr9wZ8
 NjIpRF8AB52gRHpzt1EsGRvEWt29Bwz+ZT/OcebjHY7sOV3HtKnCdsHHZWCGUy6ry4L6RWC2f1RO7Mg5nIwQE10Gf7nc4mFhQurTtaNp9KC3Keb81AJk0fLkzfOP+F9HYDeGi4tXnSrPV3i3NbOqU1t3aaGD4ABZcUwDiPLSDjchc63Cs+EfPk8RvvXeB5PIFUrvkTmN1N+6UPchsu7/Pjzi4xpSiD/uTNnqj86jqsVRFrLQ7/fqC0kvrmX7+GBP9Z65fQd1gWQxoMX5HdpHEsSDUzpUEZ1yu/L/QWjSsYE0PJPi8Ou8MUBmsnpnVjyh02sGulpv54BE+9lBHa6JrWagyoMju8WMaYqYw3fql/aRb4gPZSsiqCat29PptKn3J7dv3ECKsRvjI7P+QaViVRV2nvi3ZoUH+8NanF8JuLJaJUViNrTRH1hpVnUPmWww38tDEZUfLkl7ZhOtXQBbTUlAujzO7O338a0onuH2MYTyi4sw3hwUyC/rt6MN/Wk28Ed9QE6O7b965ocjmDVovJ4XrVzE/gykk+U8Pgs+V/y0ekvsmZv64pWQ1ctGnTtozDJq8qV5e52vo+lHNfQYfOaHg1x0NE0lMeh5FBB4cHj2PWkEmYMQ/3+anNNadj12IQ+N8WgKHh+BvuTQrrMEYLtKy4fpy3h3Y1BpppEFSSRqJRvp/hg/a65o566EnnTZD8eGok3/rM+LBpGlappClqb2vBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thanks for your review!

On Thu, 27 Aug 2026 17:22:11 -0700 SJ Park <sj@kernel.org> wrote:

> Hello Nathan,
> 
> On Thu, 27 Aug 2026 12:38:21 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> 
> > __damon_va_prepare_access_check() picks a random byte address within the
> > region and stores it in r->sampling_addr. There are two users of
> > r->sampling_addr in vaddr.c that pass it into a page table walk, and
> > both use it as the address of a page.
> > 
> >   damon_va_mkold(mm, r->sampling_addr)
> >     damon_va_walk_page_range(mm, addr, addr + 1)
> >       damon_mkold_pmd_entry()
> >         damon_ptep_mkold(pte, vma, addr)
> >           ptep_test_and_clear_young(vma, addr, pte)
> >           mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> > 
> >   damon_va_young(mm, r->sampling_addr, &folio_sz)
> >     damon_va_walk_page_range(mm, addr, addr + 1)
> >       damon_young_pmd_entry()
> >         ptep_get(pte)
> >         mmu_notifier_test_young(walk->mm, addr)
> > 
> > test_and_clear_young_ptes(), which backs ptep_test_and_clear_young() on
> > arm64, documents @addr as "Address the first page is mapped at".
> > 
> > For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> > clearing of the young flag for large folios"),
> 
> The @addr documentation is also introduced by this commit.  This commit is
> authored at 2026-02-09.
> 
> > the contpte helper walked
> > exactly CONT_PTES entries from the aligned-down page table pointer and
> > used @addr only to pass down to each entry, so an unaligned value was
> > harmless:
> > 
> >         ptep = contpte_align_down(ptep);
> >         addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> >         for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> 
> So, there was no issue before the commit.
> 

Right. Before 6f0e1142173a, unaligned addresses were tolerated but I don't
think this is guaranteed.

> > 
> > Align the sampled address down to a page boundary. It is the address of
> > the page to sample, so this matches its intended meaning and fixes both
> > users in vaddr.c.
> 
> This indeed sounds like can fix the issue to me.  However, was it a clear rule
> that we should pass only contepte-aligned addrss to
> ptep_test_and_clear_young()?  And is DAMON the only ptep_test_and_clear_young()
> caller that is mistakenly passing the unaligned address?
> 

It is not spelled out as an explicit rule, but the documented "Address
the first page is mapped at" implies it, and these callers are using
aligned addresses:

 mm/page_idle.c: page_idle_clear_pte_refs_one()
 fs/proc/task_mmu.c: clear_refs_pte_range()

> If not, it might make sense to make contpte_test_and_clear_young_ptes() support
> unaligned adress again in my opinion.  May I ask your opinion, Baolin?
> 
> > 
> > Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
> 
> I think 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for
> large folios") would be mroe correct 'Fixes:', if there was no issue before the
> commit.
> 

Will use that in v2.

> > -	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
> > +	r->sampling_addr = PAGE_ALIGN_DOWN(damon_rand(ctx, r->ar.start,
> > +						      r->ar.end));
> 
> If we need to have the fix in DAMON, this kind of change would be needed.
> 
> However, what happens if the address is backed by large folios?
> 
> Before the commit 6f0e1142173a, also, it was aligning to CONT_PTE_SIZE.  Should
> we do same?

Passing a page-aligned address restores the pre-6f0e1142173a behavior.
Before the change, the helper aligned ptep down to the block start and
walked a fixed CONT_PTES entries, regardless of addr.  After the
change, the walk covers [ALIGN_DOWN(addr, CONT_PTE_SIZE),
ALIGN(addr + nr * PAGE_SIZE, CONT_PTE_SIZE)).  With a sub-page offset,
addr + PAGE_SIZE lands just past the block boundary, so the round-up
extends the walk a whole block further.  With a page-aligned addr,
addr + PAGE_SIZE is at most the block end, so the round-up lands
exactly on the block end and the walk covers the same CONT_PTES
entries as before the commit.

We also can't align to CONT_PTE_SIZE in DAMON since it's defined only under
arch/arm64/:

  #define CONT_PTES		(1 << (CONT_PTE_SHIFT - PAGE_SHIFT))
  #define CONT_PTE_SIZE		(CONT_PTES * PAGE_SIZE)


> Also, I think we should pass aligned address to only the functions that
> require alignement.  Making the alignment to the sampling address in general
> sounds too much to me.  Particularly, we are working on supporting new page
> access check primitives other than PTE Accessed bit, like AMd IBS.  In the
> case, we might support <PAGE_SIZE granularity monitoring.  Aligning sampling
> address in general will make it more complicated.

Makes sense. I will keep sampling_addr as is and align inside damon_va_mkold()
and damon_va_young() in v2.

Thanks,
Nathan

