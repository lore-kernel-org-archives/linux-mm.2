Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE928C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1736B0088; Wed, 15 Jul 2026 09:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0889C6B008A; Wed, 15 Jul 2026 09:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07B66B0092; Wed, 15 Jul 2026 09:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0D2C6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:59:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79C0AC0119
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:33:16 +0000 (UTC)
X-FDA: 84990799992.20.5438632
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0B7BA0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:33:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bscw2GOx;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784115194;
	b=mdzv55HDskBVyHi3N24DsMeEoj4LaW1HQPyWN1DziELcaI0V/nQ6thL++ABehl0GBBPc9c
	FjhuMbHnnuEDIUqj1VRSdbeazlQBVODJ4eiMXwL/jjuB8300vkAJLxnYqdu52XPuEDmtbj
	javPY9pbvWrKrINu0Ltgl7frFpTYutc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bscw2GOx;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784115194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCDqEALQukdy48lYCnyqwpZMutqK5Js8PtN9MiPr3Po=;
	b=4GDpfpyLUWIgbLS5Jn2X4h6JJ8pHD7bRSr7AAkJAqyuyDhlYRTa7Lhc25MvK6CqLgT7wY+
	ZP341Ya1abXWLmP7fXJELPnrIlwL+qzwiBlP+Ks5jlVk3A59qhefsbc4n/GiWob/1yhbzz
	e/eyOsmFKx0kuvYnX6ahb++II7AntyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD83D600BB;
	Wed, 15 Jul 2026 11:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141C81F000E9;
	Wed, 15 Jul 2026 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784115193;
	bh=LCDqEALQukdy48lYCnyqwpZMutqK5Js8PtN9MiPr3Po=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bscw2GOxvcq7zy/uL4d2iR32U2VH/nFsAt0vLQ1y4PKosX/mVdfhsHAWOXa5z1kjt
	 zsX1ykm4LBRa4oe/Q/S2zOE4Tco09jVjJIwmPZ2S63mDJ/lcoBaAxZJ9JWJ6WLd0j2
	 P0IgyX2poBYgNq4qNtgg1vE+FPViT3Q9HDY8sWbS+8RuXLLBUTUdlYmeOk+x7HkrqW
	 arGZPkjmYmXvqpTAqJnIhBHusfgWxIVO1kPqGRJu6RB/JIc2qzff07tvSJA4VvxaEH
	 WHNKJkewg75wt1S+QTcPc2DaHURIv2qV60CA1Wlc3TaqxsJZ3KS/rBIwgpy3IbVWYg
	 Z3qmvKg2BYBgw==
Date: Wed, 15 Jul 2026 14:33:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-ID: <aldv8U-lzCn0SCBL@kernel.org>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
 <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
 <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0B7BA0005
X-Stat-Signature: fguiaj6dmob57i7jky7xtdd59wypukum
X-HE-Tag: 1784115194-540622
X-HE-Meta: U2FsdGVkX18c7Q2vyy8fOKaDAlqltZ+OdGZ+gXvuv8Q75t5mqpIa0XlZUo2Ir6HXWAXCrcg8YFteLocU58VJDDtZkoh4R2V/I+/KsIx+K+IeSJ4dw7HwjQBMcGL9tXK+u5AUOdJpv1ilmjlIto2GlwHDs9ogM9zfqTiGMjSw6m/iP6wQ6jJ3Ox8GJ9AwnGRpTo8h+3BgQ/uiaXHYWoUtL2X0mEY5Ri98E8DYelC4B1ev8nd7OaivkWqqVlS7Y1S9nzxyUay+eSqVp0cmqs//murnaJMB9jTkXsGPej8nqdUDSEaY0gUZLBC9h0lDA0ojKhVh81NP4CyYFlDFMogqek2Pmg8OIKBcTmtUQMJOGKCixMR99kyVD76nmGGq/ndm0Y8HDkNyEIuldOQj33IIUvD0HgoTNs/DRRZJLhWd5uu+9wn9h7OCO0TLbM1cpxlYnHo14PNF7t9ATPkH16NcFnQZ+i8YmURkRAx1RkrKSkwNwsI/aVAh+pfp99I5NpfYMVDYmS7LrIi+MfQrf0CsljObqHzl7iPdIyAp7kWHCSnIfpWFxXkdLvOYDLSfGz/RAQtVLRchsJfUbVSCWcTuxehBevU6Eu+YM7zbrjdWxrcCMq1Fkg+YQ8zbgaWXnmLKOqc71Oqom/z4W63Y49Iv8n3q+7wCyAWQy+fUMdkOnjcaUx3019Kq8DwOC4tzekqDh5xUyppbe1qhV6KBot7p62yjFcttZlCnTA1e1ItwDQY0QwCe+EzbmJEmDC2e6sSz7Kpyd2T/ioj+J6fjdXpOfs934ZocRtvaQXRn95fL5Vgt88pLTTh+QrJJcXcU33/J1OQ+mWcjQHtX1jLorbAOKwqUTn3YciWPvBaB29bsLz55A/x9kvrdrXnDtnTUFOOJRK+CRw/USi0BwBP99hcQsypQKTBQReOwR50r9jDonbnU63CZCtpBOfCpesimOY3pAjXcvHDe0uRv2tqOwod
 nxEw+24V
 /PG2t/fAzDL2KEnOIg7iATpMOaPQKPigMPUcbmuT90SxjY6xBMBWYRhokQO6swGXRIPPLQlNvf9OrKFSiHwiHDNF3D7MRdPrr6wAcIUh3IQvbOHI2w0C+5eKG+FPd6CinnENv2cMgeQl3/MbXA0JWpbh+p0k1hjKB3ufrOrobX6aa8t5/KAGyPwVENU5T0wb4cLyEFjhzfehoRt6uslRLtZfFt4qnqY7C3EmU0i4nBY7c64YYOHaoCOLAIJONhySJvGBo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 11:22:33AM +0000, Brendan Jackman wrote:
> On Mon Jul 6, 2026 at 8:42 AM UTC, David Hildenbrand (Arm) wrote:
> > On 7/5/26 13:34, Mike Rapoport wrote:
> >> On Sun, Jul 05, 2026 at 10:46:19AM +0000, Brendan Jackman wrote:
> >>> On Sun Jul 5, 2026 at 2:26 AM UTC, Andrew Morton wrote:
> >>>>
> >>>> Well OK, but the secretmem code is still wrong.  The patch protects
> >>>> people from hitting the bug but leaves the bug in place.  Surely it would be
> >>>> better to fix the bug?
> >>>
> >>> I don't think the code is wrong if highmem is disabled. Certainly
> >>> there is an implicit coupling between the .c file and the Kconfig file,
> >>> but we could always add a BUILD_BUG_ON(IS_ENABLED(CONFIG_SECRETMEM)) to
> >>> the relevant bit of code to make it explicit.
> >>>
> >>>> Is that as simple as adding the folio_test_highmem() test?  
> >>>
> >>> This would fix the WARN+SIGBUS but I don't think it resolves the fact
> >>> that this configuration is completely untested - there are likely other
> >>> functional bugs? But more importantly, I am not sure if secretmem
> >>> actually does its security job if kmap_local_page() isn't a NOP. I
> >>> think shipping a "security feature" that doesn't do what it says would
> >>> be really terrible. (It might work totally fine, I dunno, but it would
> >>> require some research and deep thinking that I don't really want to do
> >>> for a configuration with no users).
> >>>
> >>>> Or switching to GFP_KERNEL?  
> >>>
> >>> ... Oh, that's a nice idea though :)
> >> 
> >> GFP_USER if anything :)
> >
> > Right.
> >
> >> 
> >> But still with kmap() and friends not being an NOP the promise "kernel does
> >> not map this memory" does not hold.
> >> 
> >> I think that keeping SECRETMEM and HIGHMEM mutually exclusive is
> >> conceptually correct.
> >
> > We could even limit it to 64BIT ;)
> 
> I fear this in limbo, we have quite a wide range of opinions from "fix
> the broken configuration" all the way to "disable secretmem completely on
> 32bit". I'm not passionately committed to any one answer but I do think
> we need to pick something.
> 
> Mike's position seems to be roughly "in the middle" of the spectrum, and

Right :)
Supporting 32-bit without HIGHMEM is easy, so I don't think we should limit
it to 64BIT at this point.

> (conveniently for me) happens to align with what I did in the [PATCH].
> So... could we go ahead with this?


-- 
Sincerely yours,
Mike.

