Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43A5CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6576B0005; Mon, 22 Jun 2026 09:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD7C6B008A; Mon, 22 Jun 2026 09:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5BF6B008C; Mon, 22 Jun 2026 09:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACBE6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:52:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B49E7C07E8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:52:03 +0000 (UTC)
X-FDA: 84907687326.11.778F00F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 07FB980010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:52:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XKIj/76l";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782136322;
	b=Sh29Imgmd3NAIQg6NhA5qow64gNzXIH2Pe7pxZzLHSjRc9eD8VNwYUzDofPlrb9zd6YXAm
	1eika4J8DSJVfQSjkdvx1nSUDZTJYHuMBB7SO6GK9QJhZv3hCUTc9SGXtgqFM16nUABtil
	WTjIJw7isClosT2h9QfglKrC3P8K57w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XKIj/76l";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782136322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5Tf1aK8g+ZKENypXzO/+sigvN9tcOrY12gLHfs9mT8=;
	b=FA1YLPQOPv2m7cdhwPti3ubIsO/Du2nSRl3r/1eKw3UpUcuUmPxv4k5N3kyceVin4EakFa
	ILHQ5rXNv54ML0yuZGrhlbMEpTAylUJlwYsS0ZQnFSgBxAsesIoixSWfPQYbVddIGktPgk
	4kXi+97MyKlvo0KYVFbZrV3jpbMpRX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81A55601F3;
	Mon, 22 Jun 2026 13:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46E51F000E9;
	Mon, 22 Jun 2026 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782136321;
	bh=+5Tf1aK8g+ZKENypXzO/+sigvN9tcOrY12gLHfs9mT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XKIj/76lzwCjYTe0OCB1syC6OIZS4opDFHSpcAOShdAxVLbcMoHwHT24XI0JGh4ht
	 hvtpOdPC9EWhEH+9VaFoW1ZCZ1rxVPEVOuy3ytIwwUE28r5vrV17ZH05Ehu6ikN5Is
	 fbOQwnKJVik1ypbS0twm6A0g4YKmfvFkcZL2qWKV8x0NK1USdldjnv4fvvqxUMMZI/
	 XTrk7R5NsMU+45i2Xf6zbnyIpa16r0CMmD14eEzVYliiLF1uJnGLOq/zj6Ck9T2Kxv
	 XcdQGZ/3zoptUGQbndRGBXw6rskmhVidDxoKf+N3+VXXnKjHRvUzkuLsSipkF0dQVu
	 JsFQUVhOsZmRA==
Date: Mon, 22 Jun 2026 14:51:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: mm/mprotect.c:700:43: sparse: sparse: cast to non-scalar
Message-ID: <ajk9RsbGcMjFIpxL@lucifer>
References: <202606221720.CGRCyQ8e-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202606221720.CGRCyQ8e-lkp@intel.com>
X-Stat-Signature: iet7txrhxyabgg664b8sjcpm6hizrgji
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07FB980010
X-HE-Tag: 1782136321-786295
X-HE-Meta: U2FsdGVkX1+wjisU4JqFxJQxX8gqL50E/fJ5eQ2y993V2FSf4OgX4ZGalRP1s+GMh0U2Wc5JDqryvbCpfxfRBHZ8vgRp8HT+vt/jI41MkRA/p+v7S0z37qZUYi4ciAzV04AWdifEb8wcFILq8l5eZPoBfnIfGCV42HKbHy7gCOusoeIQwN2vzS3iMv+1tuT8yEw5TfxJaqzYcDbl3ur7OZU3P8lEp4UL0JCjd2nt2uJRnKt6JQoNusG8YxAbNhYByBJJH4d8NLOgqcq6qCuH/xUsh89tO91WMOCRzBdac05w3jlMfZtcrqQGsz7T6FTOZ+ZOR2O3taHgmZZCYCJ5yZsyjoLs1b+I9YMJlFula4ikvUwrBwPiBi1drba2Tvo2ssG7o9qLLDkYX+3EA9fW424m6/Rmu6mjvXYzuJYnMHa9A39zkaIQsp6BD4cU3HiQPWOAqgFfmwGuZNWJ/johDwMUhhdTvFin0sXc4hVzn821PrRbN/wlC++LG63Y2qLMUeaoLpfQX63x8cIMO9D9DF9Ud5dcX0j0ylp6PG8yNgq0ONT1983Abkc9k+it0COc3KMyZKb7SfFJPxDNvOATXXrlvR0bU8vSfPsv8Q7DtesfQ6U8l/aRyYeQikgVtUI8zM/ObHKKJpZmg6+49PPXlYdyHCxxGjAhr/Xnr2Q+PvFELBtjQlKGq56qZq7kIA1+ZTNsDCbxBH7zCoZdB0xKfhLDsfDXn7WSZcltwaJ1g8A0WGD72ZRQeEZ54JD4+Qb4cGS3Y98qir+WQEUGeJaIebKgfwt91/Agd4R3B5JDuvlLxq58mqEPCx8EHwwKUnsacRuZLPJ4hZuSELxwKz5Ii4pHtMb+RTCXABfos7OvXLzvcoIDNS5zV8gqK/7zYQkqsZxQRwp4Cy9rqxPBp5jfEP/vaj7g6sFu3y4s+ljX1i4oRj7WHGihwq3pDsKXmA7o2izUfvHi3GEkO40NPoj
 SEfEpflI
 HgnAKkLhmbQmqWPdCzEst9s6J0Ni47V91i9nwIy6AMEH334NiOtVoyg5j4jwfgJa6mCJJHhwgNIa2dYu/INq48ssDrsj6sYTACcbozFiay2+EYllpCQqogKcccUn4K6Eu7S90OENgVeQZXFitb9wOzDWKDuaJM09pmMi5C85f7jERMNj/uGa9KpvKlOYBP0l7t5WMJkv5lZ6ibUfy3XH6HXrGKV18hhAHlP3hxMF7FSNQPx2kUjR4/7zFqTo66a1LupTiqTVENQryyIQwxW4EMHjawyKYC259BB7o+kswYdOhe55e4ZKPpWtXt1WMMT0J8+anqDi2fVCfwBdm/PCO+0t6CZU+zQY4g71j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 06:02:20PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   ef0c9f75a19532d7675384708fc8621e10850104
> commit: 3a6455d56bd7c4cfb1ea35ddae052943065e338e mm: convert do_brk_flags() to use vma_flags_t
> date:   3 months ago
> config: alpha-randconfig-r111-20260618 (https://download.01.org/0day-ci/archive/20260622/202606221720.CGRCyQ8e-lkp@intel.com/config)
> compiler: alpha-linux-gcc (GCC) 10.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260622/202606221720.CGRCyQ8e-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: 3a6455d56bd7 ("mm: convert do_brk_flags() to use vma_flags_t")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606221720.CGRCyQ8e-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> mm/mprotect.c:700:43: sparse: sparse: cast to non-scalar
> >> mm/mprotect.c:700:43: sparse: sparse: cast from non-scalar
>    mm/mprotect.c: note: in included file (through include/linux/mm.h, include/linux/pagewalk.h):
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    mm/mprotect.c: note: in included file (through include/linux/pgtable.h, include/linux/mm.h, include/linux/pagewalk.h):
>    arch/alpha/include/asm/pgtable.h:272:21: sparse: sparse: cast to non-scalar
>    arch/alpha/include/asm/pgtable.h:272:21: sparse: sparse: cast from non-scalar
>    arch/alpha/include/asm/pgtable.h:272:21: sparse: sparse: cast to non-scalar
>    arch/alpha/include/asm/pgtable.h:272:21: sparse: sparse: cast from non-scalar
>    mm/mprotect.c: note: in included file (through include/linux/mm.h, include/linux/pagewalk.h):
>    include/linux/pgtable.h:475:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:475:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:468:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:468:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>
> vim +700 mm/mprotect.c
>
>    693
>    694	int
>    695	mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>    696		       struct vm_area_struct *vma, struct vm_area_struct **pprev,
>    697		       unsigned long start, unsigned long end, vm_flags_t newflags)
>    698	{
>    699		struct mm_struct *mm = vma->vm_mm;
>  > 700		const vma_flags_t old_vma_flags = READ_ONCE(vma->flags);

Ah yeah... this works right now but is actually sketchy, as we need to copy not assign.

Will come up with a fix for this, but I think it needn't be backported as this
all works correctly right now.

Thanks, Lorenzo

