Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AF8C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 21:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37316B00AF; Thu, 16 Jul 2026 17:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7FE6B00B0; Thu, 16 Jul 2026 17:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9D06B00B1; Thu, 16 Jul 2026 17:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0A5D6B00AF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:06:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B38940307
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:06:32 +0000 (UTC)
X-FDA: 84995873424.13.E40CE62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F093100008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 21:06:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOC8CeGi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784235990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oucStQnRyawORtPI7Wj+qEZX9FA99Twpl/PrB1SpiMs=;
	b=zXmsmJgOpM8QMxQOO2u377dNaKD9mo42y6bCBj3WFuQAI/yAWVMuL6KvfPGGRm448B+X27
	a/zKUE+7KDNuDUr0qR44MQulLY5GEXNoNBWgTEbtJMT5P+fQC+Orenth1tHxeVSbkE5Sln
	qcEbjeNFz2E69yjabZeq4Q6eMmM46ks=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOC8CeGi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784235990;
	b=EoOMv3XIYiGC4/hRPZ23cq9sc8BERRlk5JLEc1o5+0u4zVZ9s/Zs1pb2qQifThB4nfnRTy
	YNu0DlE9uFZ8iQI/m703ajBYVUI1ScH+Ha/qBWoAsuH5XOveSVCKCI+K86jd1xkGZl9G7G
	P+XcMDami0nltKOfEtVF0Z0veYlvixM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C40A411FD;
	Thu, 16 Jul 2026 21:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859721F000E9;
	Thu, 16 Jul 2026 21:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784235989;
	bh=oucStQnRyawORtPI7Wj+qEZX9FA99Twpl/PrB1SpiMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOC8CeGi42U+SdUKidcJPeWP6ZY4+ga7NyPiOUDh79HKDJUjX0/fAvYuU4zHGvfR5
	 HQCjCcs8mYgluWNtJzcWXoGF996LfTAFtzmJ5jFHo63T7NRCIw9CxmGePcNdTPdEMR
	 OMaak/ENhnvrB1SlY/b+v/QVqL3/mxpe0HG+pb2j17Y+j198b2SRNxecu3PWemJuXe
	 yWYrK66ibJzgTJdjdJq+7dUWCs57xiGlurrXoJkgWIJQA6/J1Jfh20qQs+81U22lEe
	 29I0zLtHNmMyabxgk6lApS7oubGAZvAiAn9D3VXdFj705DLbr+H4zKIbd5oibckO5A
	 hlYWVxCVcMH4A==
Date: Fri, 17 Jul 2026 00:06:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Clapinski <mclapinski@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
Message-ID: <allHznJ3EyI-dytV@kernel.org>
References: <20260714205111.2497151-1-mclapinski@google.com>
 <178409777790.255896.16691338963510282908.b4-review@b4>
 <aljy_-Y7OT6s0kj0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aljy_-Y7OT6s0kj0@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F093100008
X-Stat-Signature: ernw6awgdqxwpija5sz78riaysc9a9zg
X-Rspam-User: 
X-HE-Tag: 1784235990-733639
X-HE-Meta: U2FsdGVkX19SKCa5FQpH6XweKebOl1f8FW+HtcJKi/fyfE8uVQJIijyTm4bzZFs6ak4zp4DanryPJlYxDiW95O2YsFLqaJXKyo6FS/5rWw5XRg80ka2Ak/P3htm5VhM0sg7nCxEQdzgrGDObycaVMCOrujZrFDeUiIsWbaUDcFA8J36gULT46gMrtrtq3dF/5/Lko1UC8edgcpmKFm0DSw3pLLmfzTYedDc+jbMfy3rjZtSMcsI88q3qBX4/RtV9QFcDC2Wb33xUc+yC1pYPbdCAgreF4zxEHmKRr13lW62D0ZWVTx/I2rWRmUAw+63stxwjPtC1SexB3bGr4YpQLETaprTNHtXFkt02drunJS/2Fk5HxMc61jTQa/zaXNGWaWpAR6aIg6FRKyFiJ4RwRR7t18aG/0CPb/3XMQ90qVpSaDNLXXGdPwysvirpNQ7hDYpmt2oWee/HL4+g7LPJkM/ZCI7yHudUUx0Kcji35PmgAusoTtgMIoD4YPe5mWJhmJLQy6Vf1P7wqVxH6YBTI7mSinbJO7cJwoW8y6dHNNLohneIPpuI1nEIk4stmoq6XCWDgDknHkPOHcFYJJ+x8rcojqSf9oRhwESBvwvCicoiR1qxSzLzG+4MlL7zEzmZqMp43n0kX7mB4PrOU4daB3gmAYDcvzHLl09S6d7uG/MhzbqN+3oS1T6RAMOS/wE2zCtkPuKUZyLR6DayWhm9sGWc5NszgBMpETJG9LKc0h/m4GfZqNA9y8sx5RV2wjMgR1/D2QjANiiyKjvBxmIuQc5Don/6dNQ7wv2O+BafvJ/kll8tO50jHYlq8DP/AbRWUp/tFyL3f4wZxce6HP3rcH9PdxrcriRF2kmdkPf9yMxnpKglPm9oR0QY23qpT+T308jCHP5Ph8EXckfBLI03seFY8o32Cnf1owFJVrP6u5cXRl9dBi2HDRG12EVddoI91uaDxqkirbfkFC9SB1E
 jPD0b4Bg
 sTKZpj7bpzTqS/PPmTcveif5m6G47EVxS1DYpGHtp8gEPDqjFYYPJ0jSiWCmxcRH90TfPm7Otl9tkEaXmxtRsgTJbO5zX4pQDzpKZa5AscnYBsuI/9F4AwQ2c+DwhKzv1MZ/O0zYDqKvP3zL5Tz14Oe0XtixkoaXgG1vaL9HMgTH8S+E8BW9ViDyeSZgsELKMOFr+FApBMBPFXlxlqsGO1AmgGQPL5XH1iial74UbCcGxdgrjR5FcGQp/q4n/QJZC2NUW39WN/+Q2lGMoJbZ/OCG1Sp2X7xTj6v6IBGzP2V3zulBjQdOJ0jYX3hdS+RiA+iah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:04:31AM -0400, Pasha Tatashin wrote:
> On 07-15 09:42, Mike Rapoport wrote:
> > Hi Michal,
> > 
> > > I caught this crash:
> > > BUG: unable to handle page fault for address: ff19164fffff8328
> > > RIP: 0010:__free_one_page+0x1a1/0x6b0
> > > Call Trace:
> > >  <TASK>
> > >  [<ffffffff913208bf>] free_one_page+0xaf/0x240
> > >  [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
> > >  [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
> > >  [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
> > >  [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
> > >  [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
> > >  [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
> > >  [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
> > >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> > >  [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
> > >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> > >  [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
> > >  </TASK>
> > > 
> > > deferred_init_memmap_chunk() works fine without KHO because free
> > > regions will never be neighbors. However, with KHO, free memory
> > > will be split into (free && scratch) and (free && !scratch).
> > > KHO scratch is aligned to CMA_MIN_ALIGNMENT_BYTES (which on my setup
> > > is equal to 1 << 9 pages) but buddy can look at the neighborhood of
> > > MAX_ORDER_NR_PAGES pages (which is equal to 1 << 10 pages).
> > > This sometimes crashes when one half of the neighborhood is being
> > > initialized but the other part is yet to be initialized.
> > > 
> > > To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.
> > > 
> > > Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferred struct page init")
> > > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > >
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > > index 4834a809985ab..50928aaa33710 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -38,6 +38,16 @@
> > >  #include "../kexec_internal.h"
> > >  #include "kexec_handover_internal.h"
> > >  
> > > +/*
> > > + * This is the minimal alignment required by deferred struct page init.
> > > + * deferred_init_memmap_chunk frees memory to the buddy allocator, which looks
> > > + * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
> > > + * If KHO scratch is not aligned to that value, buddy can access uninitialized
> > > + * struct pages, which can cause a crash.
> > > + */
> > > +#define SCRATCH_ALIGNMENT_BYTES (1 << (PAGE_SHIFT + MAX_PAGE_ORDER))
> > > +static_assert(SCRATCH_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
> > 
> > Maybe make it a variable and set it at runtime?
> > We won't need to worry about different confugurations that override
> > MAX_ORDER and potentail divergence of pageblock size from MAX_ORDER in
> 
> Do those architectures reduce MAX_ORDER when they override it? I would 
> hope we could set the alignment once and make it large enough to work 
> everywhere, rather than depending on dynamic changes even during boot...

They could, e.g. arm64 has this:

config ARCH_FORCE_MAX_ORDER
	int
	default "13" if ARM64_64K_PAGES
	default "11" if ARM64_16K_PAGES
	default "10"
 
> > the future.
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> > 

-- 
Sincerely yours,
Mike.

