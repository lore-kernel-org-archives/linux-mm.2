Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9519C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E9D6B0099; Thu, 27 Aug 2026 15:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75DB6B009B; Thu, 27 Aug 2026 15:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BEF6B009D; Thu, 27 Aug 2026 15:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76F906B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:11:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07CF7A2E79
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:11:06 +0000 (UTC)
X-FDA: 85147992132.25.7517E98
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0161914000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:11:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=gnaQUmfT;
	dkim=pass header.d=ruivo.org header.s=mail header.b=LUkbk2eV;
	spf=pass (imf23.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787857864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elmByU+1ierFwo9YCiA5YorOkefa7BWeb/5m4YD73uE=;
	b=b/zBIk70TUYelyp3NEQLA01izFiT7fuI8Q91INi4XiemQ+PKTmjsfzpHuPp3rrXk93uncX
	myEpwitGM1T2ib6bAG/FkIOiQ9TybDg97lV3cuzVzZncVmwIt80I4ghreFJ0KJXzlgrjlm
	xO48ptr8VQ3jHp2Qk5BvlRRQolqGztg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787857864;
	b=HFtfNFwxVRjaGJF/WlP4AZIIKDYx29nCZTzcky7xXrAQJhBly+Zdwb/5sKi5AMwNvyEc1s
	B6dxU9ldRIzG3yguKwLLQWXh6ao4vXuoLhlxCtqtCfmpZtKuudZdrfgDldONTPUdBSo8SW
	SWQ2HVLnNPAAO60qlRBG2u/LEC1+NTU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=gnaQUmfT;
	dkim=pass header.d=ruivo.org header.s=mail header.b=LUkbk2eV;
	spf=pass (imf23.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787857863; bh=6XzRGsssykdC7xrSnl8vFhrBjk3esfMCNdCea5J3lxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gnaQUmfTdMHt8yPtAF9cPamAfg24p5w1chfcfyd44Pw7URTbq/GjNG9Wgltmucjvm
	 1wW6Vdtyj4e98jsTtTFBPz+ikeKGbLX4sVgVt29dl0EKJ7+yaFjXN7WcNBR2yx5CNI
	 lFD/u7EeAsBpu1pH6F+YOXpKpMtulE9IOW/FHbW8=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 1E518531ED; Thu, 27 Aug 2026 15:11:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787857842; bh=6XzRGsssykdC7xrSnl8vFhrBjk3esfMCNdCea5J3lxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LUkbk2eVqQlyNMLc39buVLL/19t1CEGVWjJKxtZCDFNtmyTME+GjJk/b5ncDn6IHZ
	 iqE5oXnmlErcjQHsXaxOqK2xVvG0lIFs+32dstCe9BeRcUlJGcStpCFNLPtrTmSv5m
	 7qnTc4p566JoAnAlCHpiqydIgNOc4QxMKku1FlkM=
Received: from jake.ruivo.org (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 4E9F552609;
	Thu, 27 Aug 2026 15:10:42 -0400 (EDT)
Received: by jake.ruivo.org (Postfix, from userid 1000)
	id 38F2715C6A88; Thu, 27 Aug 2026 15:10:42 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:10:42 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 0/2] mm: gup: cleanup gup_fast call chain
Message-ID: <20260827191042.GN1736962@cathedrallabs.org>
References: <20260805035847.936054733@ruivo.org>
 <dab040ff-e495-4e7f-9932-c60b8299b89f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dab040ff-e495-4e7f-9932-c60b8299b89f@kernel.org>
User-Agent: Mutt/2.4.0 (2026-06-19)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0161914000A
X-Stat-Signature: r46mm5xfrdkpcf1zsp1ofujpuuswd7kz
X-HE-Tag: 1787857863-514806
X-HE-Meta: U2FsdGVkX1/r7owePUqbVqQwrIRy8UdowthhWnLqRgjIvroAdvOK1n+N0t88cb9aisO9/tngvp/szUg3ShMkKKHaKie26seTDmAttJ2H4/TeljmeSbIp7J+nf38ngUWVXcfvOlhkrsUk1sUhfMlBCW6XkuEDLhiL3m++Pu041VkJu4s6UQQqVyQsGzSuQcHxPFc72dDLF5hMW0RsgUk/+0dsC3VyZ9RI2XUZusXUqL89+a+/hnJGLICzaNHTDCIvNAHHaFeY2LteK02mWnhNVF6Lzm/yotQzOhcEJnW4SfWataIeJPWerrDIM7AXXRIuKNN2Zr2Nrr3Hf4BJPvr6rRaiEK5sn8qi3ttZ1CVkaDIWHL6uufi03V+RvTcHSiFXES+svjZJ5RgmdIlmn5MKrBblYUm4YLTYEG2/PDG2TG51hH4vcWRzBVrwLKvCWizbYxcgY7RHnbhUkvNxrxgJcw+izYBnKHtEmygtmrujbL27dDV1WX+zoSzoSjyI0tEO0z8eznLhlTkKbs6quPnht0blPK/3hLk0RH5fnHYzdA+/jSGZxPvtRMlZzkXoo3JzqrFU/Av188M8XODfAFC+WI268wg5XSge+YKZ72tYWicygErP+XcN+eBs+EJNMJsfbRvL8QAajJ2nBaRTWSoiLld4eU9C8YUQn9D4bBYKtdNaB1mto3QvsYGHv8PM2v0zuDc99vWGyOZ4ioKr291NFOqj9nxD5f1qKmZeOE0BFCUoo0OkF9jKjXwxqBW0gw3xlX0ZCvDSOVjF42LghU87u3gLOcIm1hqjdb3lW1RU+qPGO2RTjDrabZSvRq4HUQeMUqWytcbMkV9SN//pPoJNIJIu9RzBnW0A1fe/i5rr+wEyY7aBpQVkjI5zGu9utB1lc28BWGjaazkc7JMEbOZqOenyH3UCF1fSINu+VxSwSg9HXSw+l7D5nCsmDKPPDnfy6XTDFIzC2nijrvFAL8A
 xQgXYXz2
 XLqTbAVDqHIPMJeBN490OytJOTUF2L8tQwSS8Q/6Ix2j5oom3iCHPOIOms3yHWN271YRrqkJZINplWWoAEqd42/8r/FEUgJ+R8ffhmpMXgQzUVQrpslnaV/OfGR2aECO1MbA6Q6ebrWXRe3iqIL4lAtwHFGqnNmceYpo4X1/Tn5zmvX/MBebNYNvhL7LmR5ifvPs75Pxuwtrp17PeVdO+RaC807RIJ2nY7lPENARlYNw8Ur8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:01:17PM +0200, David Hildenbrand (Arm) wrote:
> CI flagged that some test cases fail:
> 
> https://github.com/linux-mm/linux-mm/actions/runs/33031249149/job/98384037627?pr=3620
> 
> ==========================================
> ✗ memory failure test failed:
> # not ok 1 memory_failure.madv_hard.anon
> # not ok 2 memory_failure.madv_hard.clean_pagecache
> # not ok 3 memory_failure.madv_hard.dirty_pagecache
> # not ok 4 memory_failure.madv_soft.anon
> # not ok 5 memory_failure.madv_soft.clean_pagecache
> # not ok 6 memory_failure.madv_soft.dirty_pagecache
> 
> and I can reproduce locally.
> 
> They do use get_user_pages_fast(), so it checks out.
> 
> The following fixes most issues for me (there is still one failure on my machine
> but it reproduces even without your patches, so might be specific to my machine):
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 9b68242b6b602..a4036c02e2137 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3010,7 +3010,7 @@ static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t
> pud,
>                 unsigned long addr, unsigned long end,
>                 unsigned int flags, struct page **pages)
>  {
> -       unsigned long next, nr_pages, chunk_nr_pages;
> +       unsigned long next, nr_pages = 0, chunk_nr_pages;
>         pmd_t *pmdp;
> 
>         pmdp = pmd_offset_lockless(pudp, pud, addr);

oof. You want me to post a v3, followup, or you fixed it already?

-- 
Aristeu


