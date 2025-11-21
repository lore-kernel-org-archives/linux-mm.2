Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B27CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C906B0093; Fri, 21 Nov 2025 13:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8445B6B0096; Fri, 21 Nov 2025 13:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A126B009B; Fri, 21 Nov 2025 13:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 688E26B0093
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:39:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDABEC0701
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:39:49 +0000 (UTC)
X-FDA: 84135478098.02.9B9849D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5897180012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:39:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=spGMPaAp;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763750388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGim1gFQlbp4awWQERSAAqCxeHwBEmhY5jT9R2HIaaw=;
	b=T1ec+otb7Ox6FlD3+Kr6ENnjT/gla8jCcmce/AIiD991oadaWdOix0QY51UN8RXZ9O+xgD
	cMIAU2G2x2FzsYMKYs9+EaIlLInCeNnJocdHgETE8pfe4aiK6JmI9fKLpB5yOnC5To1TAU
	XoCkTG1jUjjvTxRZQ186FydCRSO41dU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763750388; a=rsa-sha256;
	cv=none;
	b=SaYvA7XTvjF2gEPf5gl2WMNCOgtRsZVQlON/W3IWFdOUwj2snDZahNIYq0SdTt3yeAoOJl
	GLHfsr3ddG4rwnhzW1uzdspGNeU2MRLHCDYIXVA4HWmO0nJiDCuyd15GkkISCJ0iz7MOud
	J0wLoQ40z0ZpBghjFkzad/JL/u66xfY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=spGMPaAp;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8659A43E12;
	Fri, 21 Nov 2025 18:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27F4C4CEF1;
	Fri, 21 Nov 2025 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763750386;
	bh=xo7srbGSrW7nCdBJFc8o6YWFx33eFaPj7TzvMtB85Bk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=spGMPaApavWt1fTH/GtxgRQiZ0pXFd/cKYklzrnPQcS8A7yQrI8oYy3oAXcoDVeop
	 VsiUpeDvQckxRNqo8AkxPJSwv9TDG/+X5hYy3DPJnelcRNmTfHFDXV7zWO9a2aQb0R
	 qhi4E83PExiupLftMLBKrcOZ6sgjUCETE5iPhutA=
Date: Fri, 21 Nov 2025 10:39:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-Id: <20251121103945.13934959041672e76dd34ecb@linux-foundation.org>
In-Reply-To: <31B02667-2F69-442B-AD91-6C0A7823BA05@nvidia.com>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
	<20251117012239.lqm33uu4vl4y5zqc@master>
	<337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
	<20251118033339.7rukw7vvjvlbj5jb@master>
	<51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
	<20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
	<2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
	<20251118140658.9078de6aab719b2308996387@linux-foundation.org>
	<20251119005248.ddlbhokgjdmlkhkr@master>
	<20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
	<20251121090048.3n25tjhusu45xpoo@master>
	<E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
	<20251121085034.d8092d312da961b23c33a22c@linux-foundation.org>
	<31B02667-2F69-442B-AD91-6C0A7823BA05@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pt33hgq9yqo4tpmnndn4rttuzjnmpxfb
X-Rspam-User: 
X-Rspamd-Queue-Id: C5897180012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763750387-708185
X-HE-Meta: U2FsdGVkX18tBIgnYAtQ+givIywrdMzr78g9yg83tQHGfXNUt/tFJmVf2MBJCI/UvozoUu1tDC515tvwjzO1E3FvmYkCWlm2NCgQWFffM01ovtzp5ELW7c5IKCzKE1FhPgMcRM2nT1+3SCtWDAmsAyI0qTHkBDUP62kU5VHiFOtfNQ6Ej9D4i5czId6Z0Ru/VhCKZ3UYzGnZs8Ao+abg1pOOmWKO4UYqcmt8EYuQ04YwYRW6OZzI4HSbDf/PlnSRU3VwaJOoGPMKmcqYe0SXOyorYABHZ7LaHMdPvIgBdi1xEr5ZPOiM6Rg3doD5bJuH66RmGQbIlE63t9PQi4UyRfOTXSBDpzUO3cqlnYFzdI0JASi3WO1E28yzL67+0lt/gTRH1OQrMa1qI7ff5r56hKCRF/DJXWjfwsnnq7lnDZdr3gu6dlHX9xmuZJyDoAxgREZOIs6qOpvlbZPhC2DvIlAZmghDOONqw558Y8mHHQXTYDNBy4EWfO2VBf3qsPUyzw9rkIdq5T+Au/H30T7GPkxa1KwiiyxKlUFwTv3rmCT89aIdoHzJBylA4cc852cRl/hiHCezYC7DEf04giYQ7TVSvF6ZdouZqoAH/pJa8sqQW7aYpK0mtvHGplhopNugKC5yCOxIKyE0QU3Wv9jAEC72yln5c4cTHSs6QLwL4ypDuVZikg/dpfbxioFNUb5NlpQI0UTFXHwE78lKfXBPXQUyaLhHozycH54rMafyBGA6ypsR9oWv82nvjgIltm+xoSXAL1vazqLP342hqfW18JV6LFW38mt9bDVTe8iu4qRtTsidqrnqiVGnxtjn92I/BJsUZE8DYSf2ejTpm6C5X6NQbrp2X0+C5JPJk+GJ2sIgyHi6K83lqChCjG+elSMDLNl/nIQi+T2HS6/Zzc7C4Oh9C8ZksSfZwFJsT0IsGC66C4dexVHZ0SwM4rbdJUR2W5NDaEZHtZrgRIzJAc0
 jZzSQ+cT
 exT9YrH8x+ESSC8Gg+W9LCSGCNSNWV3jyiuPE9H3USS4EGluJEnAkGywKM8vOti4W88rInJqmftXADp8h0M1P7SKyUeZjWxMRaW9xFBouKRAKClQmTLnkWpP/7mOM4aG+qCcbzLy/qGcRQ3P8HhdeN879jtfUmEcJ25sjKXC3tA4JS6DlT4RIbp4L/FYDFY8/l+ue0XAMz1YCMeKQyd4dFkIOu3nLx2XUHIlf6hNDvI7MDGv1IIOoxs0/y2jz6ML5rGZrUYxAu3ncmeYE3Mz4W39ZBijb0i1UPBG4iKekYgBFybJ6X3jCwi5J6xBeqEoHtCln6E2R3rDPBRMiAYXweGnF6KgvTbi6+LqkncI62mouABHj/reYATCs5ez3L0yi2s+s8+pZSyBdLDOphaTB68JIllCxAfsmHwSW4GHuF5Drjtoc62aXW2bj2OKCA1eLKpncK1qbRhmhMcUyF4Hg08OAAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 12:00:51 -0500 Zi Yan <ziy@nvidia.com> wrote:

> On 21 Nov 2025, at 11:50, Andrew Morton wrote:
> 
> > On Fri, 21 Nov 2025 09:59:42 -0500 Zi Yan <ziy@nvidia.com> wrote:
> >
> >>>
> >>> 2. A further cleanup attempt:
> >>>
> >>>  https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
> >>>
> >>> This one is the related mail.
> >>>
> >>> I proposed one version in
> >>>
> >>>  http://lkml.kernel.org/r/20251114075703.10434-1-richard.weiyang@gmail.com
> >>>
> >>> But it is not proper, will do follow up work later.
> >>
> >> Please refrain from sending more patches related to __folio_split() and its
> >> related functions until the above hotfix is merged.
> >
> > You're referring to
> > https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com?
> 
> Yes.
> 
> >
> >> I also have an ongoing
> >> cleanup patchset[1] and want to get it in before any other changes.
> >
> > I remain unclear on the status of this patchset.  Is it considered good
> > to upstream or is additional work required?
> 
> I am still having a discussion with David Hildenbrand about it and hopefully
> get it sorted out soon. The reason is that the above hotfix is good for
> backport but future user of folio_split_supported() can still dereference
> a NULL folio->mapping unless they check folio->mapping != NULL beforehand.
> I would like to avoid that by refactoring folio_split_support().
> 
> Wei’s further cleanup patch can come after my refactoring by just moving
> a code hunk above.
> 

This is coming down to the wire.  I'm considering dropping

mm-huge_memory-introduce-enum-split_type-for-clarity.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch

and

mm-huge_memoryc-introduce-folio_split_unmapped.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch

and we can revisit after the upcoming merge window.  Thoughts?

