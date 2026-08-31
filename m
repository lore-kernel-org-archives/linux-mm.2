Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7F2C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 22:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742886B0088; Mon, 31 Aug 2026 18:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F14D6B008A; Mon, 31 Aug 2026 18:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608BA6B008C; Mon, 31 Aug 2026 18:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3662D6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:50:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA13A1A0283
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:50:48 +0000 (UTC)
X-FDA: 85163060976.24.F2C69E2
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf29.hostedemail.com (Postfix) with ESMTP id 66B6C120009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:50:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qCilTKkm;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf29.hostedemail.com: domain of "prvs=696c8a93a=zcgao@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=696c8a93a=zcgao@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788216646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4AASk5pAsuqCt1k3uv39yeWLbs5DBs7DdYUaOL2uKk=;
	b=CHnheG4FNKn5+tTqmIbRbzYxWq9kWy8bV53E6t2/Tvkaefbc9bw2pHqMGU/dQYf1nQPtG8
	TCmfMrrfBOvY0PjEJzNDhYPWckqNhyKSPLzldEdwOGKPcx+hVEa4KMGDvsDcuAE+5MLI1n
	F0ddR+NfgdIT8sOI96x0SI+6ty+EhG8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qCilTKkm;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf29.hostedemail.com: domain of "prvs=696c8a93a=zcgao@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=696c8a93a=zcgao@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788216646;
	b=x8k6GCGNlYepwudWeOSRFjivrsGb5BvYlEcJtBtLyk9uN5lwpCpW8nARmpi3w4QAOAnN71
	+nGuJdMhUfupNeML6IhSJkFGRpQV8uLYXIM7hwf7EAUY5XO7T2Cx6wMwlK2Im8acAAx4vG
	7yjc8TsqOPZJTeZ0+uMbnNp1SiW7Qnk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788216646; x=1819752646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F4AASk5pAsuqCt1k3uv39yeWLbs5DBs7DdYUaOL2uKk=;
  b=qCilTKkmnht7vOyp0bgGWOstnRsQwRGYzlbCJIVEZcbG5H54U8d1sy6x
   7lwO6YQSseNSC/vGq1FIQ2/GYFfpUj/7HY/VSP3bO8uDQfN6DrZIY78bR
   stoNYTFtWhLFmshNbuLqHipnANeHYtzaDtGDmeTDwCtZueS2Cu6tq4a+C
   BvTUAOXZ+lpFwBvZE3l6zYdqLwDoYwz6jCbHBVittuyNrWiuNLa4QDpty
   W9JGyD6MM7ZEaSD0tMaSWWWTD6wqj2zisiONj1uYgcE/knswnnlfrCZxO
   OIXanvSdrK3d9SCq1szspXnaXSFhHX6dBTweg65XnaR6Sm8EefYgY81HK
   w==;
X-CSE-ConnectionGUID: emM68SDdSm+SCPe6EuNcWA==
X-CSE-MsgGUID: yJqCWLVLREuX1wKcmHNf8A==
X-IronPort-AV: E=Sophos;i="6.25,254,1779148800"; 
   d="scan'208";a="26947124"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 22:50:45 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:10815]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.234:2525] with esmtp (Farcaster)
 id 8ef9c425-d43b-4df8-8b37-7b1ddf3e28ba; Mon, 31 Aug 2026 22:50:44 +0000 (UTC)
X-Farcaster-Flow-ID: 8ef9c425-d43b-4df8-8b37-7b1ddf3e28ba
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 31 Aug 2026 22:50:44 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.171.29) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Mon, 31 Aug 2026 22:50:44 +0000
From: Nathan Gao <zcgao@amazon.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <baolin.wang@linux.alibaba.com>,
	<damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <stable@vger.kernel.org>, <zcgao@amazon.com>
Subject: Re: [PATCH] mm/damon: use a page-aligned sampling address
Date: Mon, 31 Aug 2026 15:50:32 -0700
Message-ID: <20260831225032.58045-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260829015511.74221-1-sj@kernel.org>
References: <20260829015511.74221-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.29]
X-ClientProxiedBy: EX19D032UWB001.ant.amazon.com (10.13.139.152) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: oar7ic7h4p86aik1u65gg1xqt4shymsp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66B6C120009
X-Rspam-User: 
X-HE-Tag: 1788216646-534687
X-HE-Meta: U2FsdGVkX197+FJ3vh9ECvnQllUUpztUbXpBmcTGKT2C8mYjLezdFnRtySLYngunYHowtkB8QGlaLlMvLNGILklkvdTQg5VTu8XvkJLR5punTE5YQROZJZdgN8FKiUX+/5VTWqRu8+OGcivZuIKs1to1JuolienoGdwomRHuIcsesrlwREmxkQyh8i6aJlI7B8SCP+L7kwduNg1UAKAMgzr44MtlNC6rweSgntockB0To8xftpHuUKCMkRyppz5gFxZ2jpdgG70uZnQn2ZvcyUB7ODZtajHIYvYKkSGQzpyg6LzaknpYe16duSRay6wbFQZ2Sw5uFnD3foDqN/exj8K//6lXkmo0nMl+EzMyc4Kxh6eYPTtP7U3LvsoB3CAOUB8gXIMGj6ntdjLR8NKUawWwsvmVhPYNIy1F8WmZcFlpxPpQhnH5Kx1AN225Qs+XwCBLhJ8ogzD14KTrYi9JYlv+oEg0A81ym9s9jVKwH4ShXieKqlge0I5xzrzoATKFXBEhUGX7cpwHsywbhfEtJ5lbAmJk6iceKEv6e9lpTYkas2IlS2lnHJVx2HfF/XQuHrgjd4F8M2iw6kubHn7sPz9GEFSrJkVJD7++4fMG0RReFDwFT5RWvOORTilUlAJwNmKH9t4NjYf+cAqOdYlnOjG1/f9ML0nuuZddec1n7N5PzOLzx2YcwxCssJ/UXgNhKVo6uEuOwDXgN9BqU6FwOEDLBp0Z+Lcd0CPcTN4OvWaXQ/3IHtcx3JJ7EBJYdPpF1UcySwsVSDfiHvzhb6o8B7B3KyA15JZgP3OG4dVjpYzTv+BmCqjXsl5M0zUcfD9isrdcy2Tl7SeL5Be2+rZOT518mdJE0xlzlR6+E7IYKr2kq40KKTF7Kh0ZmJEwwXxArI2EgtynV2z+yaChudUQaubmaBIifdSAXnWcaJaR6YcYOoKuFkjfDAj0UMj1CKMT8w1k8N4LW5pmVry+fgW
 AYWUB5Hk
 e/K3Eq8NUx0Y+GNCh8OjAUn4legl8GI2NZZ2RUgVJsLNp4P7IV6mahsL3VKflm0Zt+E4UM+3NkUzG3TXJCKzeGqAgzVCATORFkw+zNipp6eJvlnEtnRwYSDT1/bvzRBmCcbKyXy8H9O6HjdEsJmmfVwdEE3x5RxCUXCmMrNhjrfrHZtdMHJK/Hm+MGUqSivt+YNhQLmPcursEIx0fsjDX6hoACvU2YqUiszQZfimeDvnKRmFcB4vaKdcyIEoMbeKw6lLIyFSOaK/2q5hPlNxlSg9VbiPzcAmPI6ivgvQyS6JOiHdjrrwPzMdWIlRrY/xQHCmUvuvicStn/2GNQRMtBeIlpij2m0AoiBH6pwyVwmD3923PgtlN9+IM0K0oSENVIUdP2sngDPlMJoibloRckdqAyy0X9xivtFrQX9dWMRYeBB3nZhOUY6+0Q7ROcUnIG45zdSEZiN4nZsPguZ8BLHqTKgafU/W2d+81yru2ZaKm0+rgJJrGWEXtm0zJGqIxFmRopTHe7rx/SPDHJC5JoIrJvodd+JsIDEh6Q+bTiSCEFhqvuoFRBJZpDGPPilgH4r0Mu9yzeQ/VLlIQktthS8ruVp/6J9FX8RZ2pd51uxh6dBX3hL0P8nRtkAL8ihSO1h3A6ApZYnqQcgdSHb9/COXU8FjaqEmPJ/1yADYlPTfr1FPER7M6lZnOCiacVgGf804uzBqeDuzUw6vCIEopzJ10yIcc3rM5t/A+9IjYCH88rEzJT+GrQB7QNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 18:55:11 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 28 Aug 2026 18:04:55 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> 
> > Hi SJ,
> > 
> > Thanks for your review!
> > 
> > On Thu, 27 Aug 2026 17:22:11 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > Hello Nathan,
> > > 
> > > On Thu, 27 Aug 2026 12:38:21 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> > > 
> > > > __damon_va_prepare_access_check() picks a random byte address within the
> > > > region and stores it in r->sampling_addr. There are two users of
> > > > r->sampling_addr in vaddr.c that pass it into a page table walk, and
> > > > both use it as the address of a page.
> > > > 
> > > >   damon_va_mkold(mm, r->sampling_addr)
> > > >     damon_va_walk_page_range(mm, addr, addr + 1)
> > > >       damon_mkold_pmd_entry()
> > > >         damon_ptep_mkold(pte, vma, addr)
> > > >           ptep_test_and_clear_young(vma, addr, pte)
> > > >           mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> > > > 
> > > >   damon_va_young(mm, r->sampling_addr, &folio_sz)
> > > >     damon_va_walk_page_range(mm, addr, addr + 1)
> > > >       damon_young_pmd_entry()
> > > >         ptep_get(pte)
> > > >         mmu_notifier_test_young(walk->mm, addr)
> > > > 
> > > > test_and_clear_young_ptes(), which backs ptep_test_and_clear_young() on
> > > > arm64, documents @addr as "Address the first page is mapped at".
> > > > 
> > > > For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> > > > clearing of the young flag for large folios"),
> > > 
> > > The @addr documentation is also introduced by this commit.  This commit is
> > > authored at 2026-02-09.
> 
> I was wrong.  The documentation was introduced by commit 6d7237dda44f ("mm: add
> a batched helper to clear the young flag for large folios"), which was authored
> by Baolin on 2026-03-06.
> 
> > > 
> > > > the contpte helper walked
> > > > exactly CONT_PTES entries from the aligned-down page table pointer and
> > > > used @addr only to pass down to each entry, so an unaligned value was
> > > > harmless:
> > > > 
> > > >         ptep = contpte_align_down(ptep);
> > > >         addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> > > >         for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> > > 
> > > So, there was no issue before the commit.
> > > 
> > 
> > Right. Before 6f0e1142173a, unaligned addresses were tolerated but I don't
> > think this is guaranteed.
> > 
> > > > 
> > > > Align the sampled address down to a page boundary. It is the address of
> > > > the page to sample, so this matches its intended meaning and fixes both
> > > > users in vaddr.c.
> > > 
> > > This indeed sounds like can fix the issue to me.  However, was it a clear rule
> > > that we should pass only contepte-aligned addrss to
> > > ptep_test_and_clear_young()?  And is DAMON the only ptep_test_and_clear_young()
> > > caller that is mistakenly passing the unaligned address?
> > > 
> > 
> > It is not spelled out as an explicit rule, but the documented "Address
> > the first page is mapped at" implies it,
> 
> You mean the comment on test_and_clear_young_ptes(), right?  But as I mentioned
> above, the comment was introduced by Baolin's patch that was authored on
> 2026-03-06.  I'd still appreciate Baolin's opinion.
> 

I think you are right. I shouldn't reference this and I dropped it in v2 commit
message. 

> > and these callers are using
> > aligned addresses:
> > 
> >  mm/page_idle.c: page_idle_clear_pte_refs_one()
> >  fs/proc/task_mmu.c: clear_refs_pte_range()
> > 
> > > If not, it might make sense to make contpte_test_and_clear_young_ptes() support
> > > unaligned adress again in my opinion.  May I ask your opinion, Baolin?
> > > 
> > > > 
> > > > Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
> > > 
> > > I think 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for
> > > large folios") would be mroe correct 'Fixes:', if there was no issue before the
> > > commit.
> > > 
> > 
> > Will use that in v2.
> > 
> > > > -	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
> > > > +	r->sampling_addr = PAGE_ALIGN_DOWN(damon_rand(ctx, r->ar.start,
> > > > +						      r->ar.end));
> > > 
> > > If we need to have the fix in DAMON, this kind of change would be needed.
> > > 
> > > However, what happens if the address is backed by large folios?
> > > 
> > > Before the commit 6f0e1142173a, also, it was aligning to CONT_PTE_SIZE.  Should
> > > we do same?
> > 
> > Passing a page-aligned address restores the pre-6f0e1142173a behavior.
> > Before the change, the helper aligned ptep down to the block start and
> > walked a fixed CONT_PTES entries, regardless of addr.  After the
> > change, the walk covers [ALIGN_DOWN(addr, CONT_PTE_SIZE),
> > ALIGN(addr + nr * PAGE_SIZE, CONT_PTE_SIZE)).  With a sub-page offset,
> > addr + PAGE_SIZE lands just past the block boundary, so the round-up
> > extends the walk a whole block further.  With a page-aligned addr,
> > addr + PAGE_SIZE is at most the block end, so the round-up lands
> > exactly on the block end and the walk covers the same CONT_PTES
> > entries as before the commit.
> > 
> > We also can't align to CONT_PTE_SIZE in DAMON since it's defined only under
> > arch/arm64/:
> > 
> >   #define CONT_PTES		(1 << (CONT_PTE_SHIFT - PAGE_SHIFT))
> >   #define CONT_PTE_SIZE		(CONT_PTES * PAGE_SIZE)
> 
> DAMON cares only exactly the byte of the address, so I agree this would work
> for DAMON and be safe.  But, still the behavior is not exactly same to
> pre-6f0e1142173a, isn't it?  I'm not really sure if this is really the correct
> use of the function.  Again, I'd appreciate Baolin's comment.
> 

I'd appreciate Baolin's clarification as well here.


> > 
> > 
> > > Also, I think we should pass aligned address to only the functions that
> > > require alignement.  Making the alignment to the sampling address in general
> > > sounds too much to me.  Particularly, we are working on supporting new page
> > > access check primitives other than PTE Accessed bit, like AMd IBS.  In the
> > > case, we might support <PAGE_SIZE granularity monitoring.  Aligning sampling
> > > address in general will make it more complicated.
> > 
> > Makes sense. I will keep sampling_addr as is and align inside damon_va_mkold()
> > and damon_va_young() in v2.
> 
> Regardless of Baolin's comment, let's fix this issue.  So the v2 would be
> appreciated.  In the v2, could you also add more details about how the issue
> can be reproduced, and the user impact?  You mentioned you found memory
> corruption from DAMON selftets.  It would be nice if you could make it more
> detailed, such as what selftest reproduces the issue and what symptoms it
> showed you.

Added the crash stack trace and the impact to the v2 commit message:
https://lore.kernel.org/all/20260831221151.50561-1-zcgao@amazon.com/

> 
> Nevertheless I'm also wondering if supporting unaligned address again, like
> below also works.
> 
> '''
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -519,9 +519,12 @@ bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>          * of the same large folio in a single VMA and a single page table.
>          */
> 
> -       unsigned long end = addr + nr * PAGE_SIZE;
> +       unsigned long end;
>         bool young = false;
> 
> +       ptep = contpte_align_down(ptep);
> +       addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> +       end = addr + nr * PAGE_SIZE;
>         ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>         for (; addr != end; ptep++, addr += PAGE_SIZE)
>                 young |= __ptep_test_and_clear_young(vma, addr, ptep);
> '''
> 
> Nathan, what do you think?  If it makes sense to you, could you also test this?

I think this may introduce an issue for the case that nr > 1.  If the
address is in the middle of the block, an align like this would move it
to the beginning of the block, so the walk would cover the wrong entries.

> 
> 
> Thanks,
> SJ
> 
> [...]

Thanks,
Nathan

Sent using hkml (https://github.com/sjp38/hackermail)

