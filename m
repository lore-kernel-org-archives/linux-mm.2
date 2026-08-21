Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BB0C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FD96B00A2; Fri, 21 Aug 2026 10:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10616B00A3; Fri, 21 Aug 2026 10:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C013B6B00A4; Fri, 21 Aug 2026 10:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A08F46B00A2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:53:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3ABFA4011A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:53:41 +0000 (UTC)
X-FDA: 85125570642.25.CF133F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C6F98000E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:53:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEqLsZh8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787324019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjevPVNDI3BMq67YKVjzwksfTaXW8pJVyyPC7ES6lEo=;
	b=jYNlF2pFvi/3GzbG8ES85Vavd8MKeLKjPPzqMlhxn5G4DFwYHquBN/veGdgoZK/BXrpUdn
	meB6Z3P3gW2Qhn4hKJoiY/lgOyKgIjk6UJUacIj032GRKCfPZQIHPZC5mXL4OfRhCYMFS7
	sE744S8j0Gb0G9YtAoOSyYhTCcEQQx8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEqLsZh8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787324019;
	b=ZWk9MkwJZln1/ArvmuZxRUq+N+1vzvzBtQzO4w2W5HF/oA/mT1CRekvJcowcMVavR+gmrF
	nMmwJ1PjG7UlBvDMizzrh6VfZjOkyzfElNR4eM2n0bVsyJfHQxF2eVItUWURC5Ny0BYMk9
	ndTFAPkpjSZowrbaj0Rx3Vuvykf9dls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7422D41FAC;
	Fri, 21 Aug 2026 14:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A11F00A3A;
	Fri, 21 Aug 2026 14:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787324018;
	bh=gjevPVNDI3BMq67YKVjzwksfTaXW8pJVyyPC7ES6lEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PEqLsZh8icemV6iCXLH8M1lwsuZIi3ppcJsoYkHbdgbhu48kCp/fzBVJmA+oO0f10
	 A3T8kuGkGfXWM3lFtPhlABSA/ZLi5QI1UlAez8YchNUOWf6MIbU+Sq4O/RMx+ddJzd
	 zX6mfViDwm9H4ky1grMR/7zMfO1HJVHZDI3kQdGakxl87mqdNfF2T069ytU4DpBR1R
	 uUfOlu07HhdXWSEZcB7TpoBFiRx5U3OuBGcOl/m1t38yanYpaMdnHgb6oRM9K+QoCP
	 Eur4/KYp8ziJXcXNbn3YRLL+yg8AgCvW4WKrQs5/fx9CGAIg6Vr6CfnI0j0QFnUrbm
	 1CtXL9ud/p8iw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 686B8198003A;
	Fri, 21 Aug 2026 10:53:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 21 Aug 2026 10:53:36 -0400
X-ME-Sender: <xms:bWaIahUo1Hb5TY7rwvXWZqiIQCsFm7HQZRTqnTRCmeUTDs2vDO3M7g>
    <xme:bWaIavA0jrACtIJfZNvxMZnB6LY5W3K6xw9sI5Oyjio_OXkiu-Rald-HEwNdcbwFs
    EFnhJ08yslj1tzcI-YdxlzsNHQDfk7etgZCI4hvkpXcYkXmd4O0sY1J>
X-ME-Received: <xmr:bWaIatXlrPt1A9pRHHG3TomUuLeZgaxqix4gL1TQUGJ1yocmnUjHoi5KShA>
X-ME-Proxy-Cause: dmFkZTEbg+VVSOlsbnGiy6K3W4JLvpYCkMXlScxQEGLLdOvOtuyrQIKV5vXx+5KSTZnied
    1BL05bKU0wpXElyHPT96soPhyznOA9yhQkJWdpXI71jCNZvHn/c8VAuX2g4/alGQJvz1qd
    B6T1tx9pKoO/3Xnvauupxnqq2zICVzTk4UBlHScruUUmAP9mnk/qzNvZQc+jf4jpBBOpED
    xE+2fgXCydrOnnCVlfS603l+zfBqCrVei/CtHb7spiwvo3P4OCFzG/j5TiRRMOyLcK4pgg
    ZSlRN9jwxfCyD9ZxG09NOzC4Ou0Dq8l4ppVyOBSA9VAPYEjjLuSug642uKL0/SMdJGusT8
    FyQeFVv5+gCq6v82m5C+dc3R+HvKciPH93C1bDuVeIW4IkUVggKfOTqwr4KKZy3emCTP+n
    DBukM1AbkGCTiOllFIoIrYoui9xfTNkWipsxWRgRoasgv7YwnRXH5aQZquW9snqERvi/Xs
    R0upe+kYPe/qNbREEIgpWHKovwhkbXElaYqKpMSBzNUq1tliCfVcEBRiTFlkTSmPwDqgrW
    ibYpBtd+fq2PrhOJ9Bklg/CSpV2hTOVcWUlpUl15BIC4Ze+TqxA907+2A7dBb9OARMk/T8
    nYgNX66kQKWXnHcaCI9pVHv1DteFjCk363spGtTWHEjy145SOc0yJlhjjcWg
X-ME-Proxy: <xmx:bWaIal_Su38VzUHm5aZb5ee-a0Xap4tAuQbnDctK1GAi4ze5g8Uy-Q>
    <xmx:bWaIarlEUp7XaB1sCVXjYocrfIRLRmUk01Zsvst5zTvva0SwLs4H5Q>
    <xmx:bWaIaoKqrww3YI_6W-VqhpR6EMrBfw132AL-VJxCcnDhIAw2aruieA>
    <xmx:bWaIaprOpW83gjEzL46Meqyz_1QQ8ZhkWmKqehA-02uQYv0Zk58lew>
    <xmx:bWaIatSyPscqY50xMTnar5di4kwbi2endQokP4zfKYafYoSxjsRuGgoR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 10:53:33 -0400 (EDT)
Date: Fri, 21 Aug 2026 15:53:32 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aohldTtzE2GJ76md@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aohIF6MmjiQpbz5j@gmail.com>
X-Rspamd-Queue-Id: 3C6F98000E
X-Stat-Signature: 3w67kezyfi48a883sbc6kdfqewjumozm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787324019-392551
X-HE-Meta: U2FsdGVkX18sy7uJPGGuEOKPWC8q8m/u1SFxtzA6USXOF0WWRED1RkEiKyLimtNYNYacxyZDtxtUejvao9AZIsqed3ChSyA01QCUdhovItyWdx7r0vzRWvYAy0pT8uqdmSOEmJ7LBdidDGYZcJZdkfuFSwHwXkEBLGdEVGwEbpoa0z7FBHXEtoLyA/fZm4dczROYi7QeRacncOKX6PRMBiY5r9xei+FTZYd8gEshxott6DQfprhhz3w5NTwDZLT+AWqOKwyFFtcSI46EXFM1FeJB++49fNQ10clzz5TMmlUbEfb/wZBf976XcRIh3BLnWrGCmF3d5loZ+E4Z8LNLnoEesuBvPq367XF0/iCDSnpThNDVqSwRsMK5+zj9szaMqybPq6U+g62DYaIyi3/DGXi+rKtp/28LXK7TMQh85mUc5vracywDgY4J4WDff2yqt5epjahHuv7HoiY0FcDzViJQBDEy8J5VwPpWH+euEy7fGC4/d7RawaDFYqo3A9thHH8ZFGQuhI5uZ0KOScMNG/1e5w/616ov46cJNapTLjL02df0apfn3jNRqxL90sjnBuUll+sPus6ADHgSpbP/jrB0twNos98Z91QFIN5XZGJ02mYYiHy17X5vcRvyWC+WdLMv4QOgG1zJX2w0XPJ5sVDuM6gsE4HxSsxripnzgzMlVBZTPr0qxy/cZ4HwYCzuQd5O36QAgQuhX5z79QsJ/5NtVwZDFfPXiV7TboL4eoCppPuqHN5EjrIiVJKhN1eL2CJqUQQiBmrsoWYCJL4rN660SMDGNnyzm6uk4NPK97pMo1KLjRMlLBF4hoUxI8WRW0wNP1q122dPBvfCgk/MxTt5uRFWe+5agJeGIJjC7n6aQcy4q8u37k3dolRebqzwl8qoLRWCxPGpZ7hYoA9aQDiVV0wFKhulitixAXDpqJtHPYW9NQpvciuWTvk5Ukq1L7LYEgFP4kV0Lo/1PL9
 ng6pTrgQ
 4NcK97waXRC0Sh2d/2SioyaTCFgo6nBlJeHI+hMKbcvPZgvjPxrE8Gi3C+23Ic+dGcFutGX7N6YW5nvWlqSxFXds4JuKGp6/jG1zx7euXn48bNIvTcpu/9YPraF658JBAkN0RBFVer/UVDT8od6hPyBlHaIiUM6lmSpIl1upCkxhJ7+LpANvaogoVS0ihFgjrL/5BAwFYiywK1roKGpr3a7H2PdDam6uOT8CfC05oqJaqYqMe8bO6DHIr3bj9LBtWXtfjZ/X3jlF+Hw6GKOBWagvvYUKRvWvwweUWd4IvqnYmHbURbSJ8UWng9Pqts/Pjshnm+0ai+qBATd4GdpiTvQNJoPT1P1We4xWL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 07:03:06AM -0700, Breno Leitao wrote:
> On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > > +	/* Reserve the table itself so it survives a further kexec. */
> > > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > > +			 PAGE_ALIGN_DOWN(ppm));
> > 
> > Hm. I don't think it is enough.
> > 
> > On x86, kernel doesn't keep memblock around after boot (see
> > CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> > from page allocator. But kexec can place the image there.
> 
> You mean the third kexec?
> 
> 1) Kernel A hits an ECC error and marks page X poisoned.
> 2) Kernel A kexecs into kernel B, which won't use that page since
>    it's in EFI_POISONED_PAGE and memblock-reserved.
> 3) Kernel B kexecs into kernel C, which doesn't respect
>    EFI_POISONED_PAGE.
> 
> Is this the scenario you mean?

No. I think nothing prevents kernel B from putting kernel C image into
the reserved space in !CONFIG_ARCH_KEEP_MEMBLOCK case.

Kernel B excludes poisoned memory from buddy allocator, but kexec
doesn't care about this when look for placement for the next image.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

