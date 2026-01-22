Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC66D6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4716B02E1; Thu, 22 Jan 2026 13:00:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E7B6B02E2; Thu, 22 Jan 2026 13:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0766B02E3; Thu, 22 Jan 2026 13:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B72E06B02E1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:00:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3080D1AFDAD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:00:00 +0000 (UTC)
X-FDA: 84360363360.09.D69C292
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A1AF20005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:59:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLlvmX+r;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769104798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3XFsHPN3VXtnh1Xfwn3CF8obsxLbBANgMnaypz5ktc=;
	b=U+AIhx17mTZoT1w1bbpFWQmDhvhGMHIf83WFxMwVN9bzqueP2S70vKSzuN9ZxiST5o4cLu
	US9mEkAlxJGMuDzCtaBbwa0y+FBJPNxQylXJix7PzOhTVy48FQVz2XkainDfq8Ola0zQla
	sMpnnGzi8aGq7DJZ0LwSE2SXRhR8XSI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLlvmX+r;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769104798; a=rsa-sha256;
	cv=none;
	b=cYXSo8fxJcbloUu0fvYMYLWK3lBSMje0ycViG9rGzglr5iJdetwrm9soHAZvwpSosiRd9/
	7KZRsUg+ouDKO3tteKnv37AZYnypm/6G6UpfCSJTnuGzoX1asxMiK4BKrcLDTrsp7F9BNx
	5irYdlV5uNAI/bV6bOcROkDuE8oOUkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED6BF42A61;
	Thu, 22 Jan 2026 17:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64684C4AF09;
	Thu, 22 Jan 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769104796;
	bh=cT6/GvZiYYHD0xqjiEm6vn61jo1kWgmPBjWYhruQBGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nLlvmX+rUAV/wP9W2HSOKnCa/Yi0hhubfryeblW9MzVofTRkVYppTlgazbjSCisdT
	 5YHRNDzOXKKhVuZq39994vf/eg9XqcFZIeIkoqWslXyFxEYDnKxMIpLTrhMIVppgtf
	 8W3NTQW/CL/3AUdJS6uSkfva06AcwSEGR2JaXqVDGsRUDi8e6VHXW+l5V4vYy048tF
	 sgAs51t6HcuFIJvLWlZ02srIzy1SVotbQckF4lHuQ2vDFsUbjxXJCT/w1KpkdCth5v
	 7rWqn725m5NkcVbg90hA0Cb2hcu4evS6JC5x3uBRVKbzk8AEBFURh+pOcd9yZDXtov
	 2B8CumLbMaaVQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 62201F40068;
	Thu, 22 Jan 2026 12:59:55 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 22 Jan 2026 12:59:55 -0500
X-ME-Sender: <xms:m2VyaXcIYubd4xlywkDlA0x1DRJmN-3o8H88RhSw5HiP3A63Vw040Q>
    <xme:m2VyafSKvVe4AJvHPGbEk49reSDK3dl6oGY3jjR89nJgu82dbeEz5LMhxb5gADhd7
    _ou_kFcICztd3hseJgJZW6b-Qie0WJ1YpbcnCvTqmPsjBdZ1no-YTw>
X-ME-Received: <xmr:m2Vyaamp5spSRu5V2FTwctZNDu4vs1Ejpafq-Dc9RP9Oue2kdKX-K6QwDAUeBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeikedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegrkh
    hpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhi
    ugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:m2VyaTr-GJw4uzn9FXbpJzttI2akIIHUxKD2JGVF_Rb2_imDh0t4gg>
    <xmx:m2VyaaaE6TLy7fzbO2l9h2xEYX5BN9WEA5bZS94-UrBhXb22t95EPw>
    <xmx:m2VyafxoxH80fwXZ_jMLwgY6U5VtgM0BOxvPVPCvoZt6X37nkVNxOA>
    <xmx:m2Vyafh1pwBQrYmk-huetlLk9RpDyqvw96VnmWj34_qEHT8aK0YAiA>
    <xmx:m2VyaXJtVBN_FBu8tF19Fw6TpJn2JEwPvypG_uCJkw-TgmKzZgDos0yd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 12:59:54 -0500 (EST)
Date: Thu, 22 Jan 2026 17:59:48 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Message-ID: <aXJHI8El7QHXQuwT@thinkstation>
References: <aXIaHZ5kNFelmuJi@thinkstation>
 <554FD2AA-16B5-498B-9F79-296798194DF7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <554FD2AA-16B5-498B-9F79-296798194DF7@linux.dev>
X-Rspamd-Server: rspam11
X-Stat-Signature: g4sbowwf9q84gps476mm8nhy6bxf1bsc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A1AF20005
X-HE-Tag: 1769104797-562947
X-HE-Meta: U2FsdGVkX18Trxb5Xr8TiHjf0jwWFxD9pNqur4lKDFe1r6zuZLyTHX9dYch6o0UjqXkn4UECmr6m1PsPb2Y7rczulJFQJQu9dhH31RiLQ7MGpF/qz9OpPGlg5RPYQqj42Ur9svYaMJyh2im0XcEGarK069LLJx0mbAahb/j+H/p7d5AuiLhKNsU3RSQHRFHC9DcEKNXAOVuzHwQO6tj1UdraanvsqhZ+yleMoEresQjlIzpEABdCTm73Da0r6Hp9LKxz3uL1QJJbdrpsqNOmH6CmH4czISRRYR1spc3fWSMpqem+xaw7flMt0Pk+YEqiqEQH5sjgU9XbrvtzMg2o70SIvhI4LDQhFiA8eAdsH+B/hRPFgTjRJMdlCk0lmoeLE/XLFjlTBXDlsLrPZG5b25lfI0JdDxiyF2teTTcUTNZ/8kXD4jtO7ewZrWiAcVKl73jDRdPZJJP/P4MRj12UkVlPSjj9yrcz+yElIn4xiOKad9syhA8Q8NM55II2MF+Wv88w82hpBT5E/ekBUqW459c98m/KfiyKQutUnZnPwPI3tbmPIsZ3KejAcGiPuHlrGjtsZry/gdPVB2PByahik0g3h0guQvaVyr4I8EAy1ljSLn4c7YBycva0C+JW0PtfFWPvHPYfwvdBsZA2k8OG12ef4MV5VfZo5FRoCRoOcADcLdTa050KV9ZJLWZLMtu+KNOZpdL8aSxHeiBHiHT8KxEn+hNCgQhL+JfAXdf6nipJLb0giimXJvZJ3HBOryshSF6u9TmcgXx7N8oll82Ho9RuOjWt4eo7BXfnfMCWo8bcbmctbEgBkicjPcRJMycK9hgz+tHhDrzSaeOQpOTtm8JNSwn+kqwx27qCO9VOzLTQs+dNInrnZ1Hhma54pKwXmL0Nh2weVuETaSyVD2bfkBnk6hNf3tB3g+xqudFoRhrZgEmMiGfFjEUD7d4pt4T4xBKrN/Hv/OEhj9Qvhsg
 smn7PF8H
 hulLA5t1mKFc1eIGnkmOFWrHvafj+Ac2zFOumRDb72WbGgBUQ5gsuZa4Q0UwsB74fl6oZRLA5Tz2B9Rungcyz2Et+Q1TqLRI/AO7zMIWE2PZoIL+1FsmKBqeamHeKNEGN2xT5d/zIO70T0+/VbP6WXKE5cCakvIkun54qyLejXB7UmX/il7/s8hNkSovUQHB/EJLu+g+CzmbL47bia1bMkQ3ROpX7tm7NpuUksn950Cu+Sqi790nI+i2hyK8CIDyBU4/ps0sZwVgCwihgEkdilzjE7wq9mpzxLHW/R+NtPk0EtbPxdVjs9TsziKG+W+qYbmW+9E29cQoRhyg2X1vq2FaCVXY4TaAL4bhAS1rrcLH/oE+Xh8zE5SUgNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:02:24PM +0800, Muchun Song wrote:
> 
> 
> > On Jan 22, 2026, at 20:43, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > ﻿On Thu, Jan 22, 2026 at 07:42:47PM +0800, Muchun Song wrote:
> >> 
> >> 
> >>>> On Jan 22, 2026, at 19:33, Muchun Song <muchun.song@linux.dev> wrote:
> >>> 
> >>> 
> >>> 
> >>>> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>>> 
> >>>> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
> >>>>> 
> >>>>> 
> >>>>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
> >>>>>> 
> >>>>>> If page->compound_info encodes a mask, it is expected that memmap to be
> >>>>>> naturally aligned to the maximum folio size.
> >>>>>> 
> >>>>>> Add a warning if it is not.
> >>>>>> 
> >>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> >>>>>> kernel is still likely to be functional if this strict check fails.
> >>>>>> 
> >>>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> >>>>>> ---
> >>>>>> include/linux/mmzone.h | 1 +
> >>>>>> mm/sparse.c            | 5 +++++
> >>>>>> 2 files changed, 6 insertions(+)
> >>>>>> 
> >>>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >>>>>> index 390ce11b3765..7e4f69b9d760 100644
> >>>>>> --- a/include/linux/mmzone.h
> >>>>>> +++ b/include/linux/mmzone.h
> >>>>>> @@ -91,6 +91,7 @@
> >>>>>> #endif
> >>>>>> 
> >>>>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
> >>>>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
> >>>>>> 
> >>>>>> enum migratetype {
> >>>>>> MIGRATE_UNMOVABLE,
> >>>>>> diff --git a/mm/sparse.c b/mm/sparse.c
> >>>>>> index 17c50a6415c2..5f41a3edcc24 100644
> >>>>>> --- a/mm/sparse.c
> >>>>>> +++ b/mm/sparse.c
> >>>>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
> >>>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> >>>>>> memblocks_present();
> >>>>>> 
> >>>>>> +  if (compound_info_has_mask()) {
> >>>>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> >>>>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
> >>>>> 
> >>>>> I still have concerns about this. If certain architectures or configurations,
> >>>>> especially when KASLR is enabled, do not meet the requirements during the
> >>>>> boot stage, only specific folios larger than a certain size might end up with
> >>>>> incorrect struct page entries as the system runs. How can we detect issues
> >>>>> arising from either updating the struct page or making incorrect logical
> >>>>> judgments based on information retrieved from the struct page?
> >>>>> 
> >>>>> After all, when we see this warning, we don't know when or if a problem will
> >>>>> occur in the future. It's like a time bomb in the system, isn't it? Therefore,
> >>>>> I would like to add a warning check to the memory allocation place, for
> >>>>> example:
> >>>>> 
> >>>>> WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / sizeof(struct page)));
> >>>> 
> >>>> I don't think it is needed. Any compound page usage would trigger the
> >>>> problem. It should happen pretty early.
> >>> 
> >>> Why would you think it would be discovered early? If the alignment of struct page
> >>> can only meet the needs of 4M pages (i.e., the largest pages that buddy can
> >>> allocate), how can you be sure that there will be a similar path using CMA
> >>> early on if the system allocates through CMA in the future (after all, CMA
> >>> is used much less than buddy)?
> > 
> > True.
> > 
> >> Suppose we are more aggressive. If the alignment requirement of struct page
> >> cannot meet the needs of 2GB pages (which is an uncommon memory allocation
> >> requirement), then users might not care about such a warning message after
> >> the system boots. And if there is no allocation of pages greater than or
> >> equal to 2GB for a period of time in the future, the system will have no
> >> problems. But once some path allocates pages greater than or equal to 2GB,
> >> the system will go into chaos. And by that time, the system log may no
> >> longer have this warning message. Is that not the case?
> > 
> > It is.
> > 
> > I expect the warning to be reported early if we have configurations that
> > do not satisfy the alignment requirement even in absence of the crash.
> 
> If you’re saying the issue was only caught during
> testing, keep in mind that with KASLR enabled the
> warning is triggered at run-time; you can’t assume it
> will never appear in production.

Let's look at what architectures actually do with vmemmap.

On 64-bit machines, we want vmemmap to be naturally aligned to
accommodate 16GiB pages.

Assuming 64 byte struct page, it requires 256 MiB alignment for 4K
PAGE_SIZE, 64MiB for 16K PAGE_SIZE and 16MiB for 64K PAGE_SIZE.

Only 3 architectures support HVO (select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP):
loongarch, riscv and x86. We should make the feature conditional to HVO
to limit exposure.

I am not sure why arm64 is not in the club.

x86 aligns vmemmap to 1G - OK.

loongarch aligns vmemmap to PMD_SIZE does not fit us with 4K and 16K
PAGE_SIZE. It should be easily fixable. No KALSR.

riscv aligns vmemmap to section size (128MiB) which is not enough.
Again, easily fixable.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

