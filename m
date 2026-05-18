Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC386CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1228D6B0005; Mon, 18 May 2026 06:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D33A6B0088; Mon, 18 May 2026 06:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B176B008C; Mon, 18 May 2026 06:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1BF36B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:33:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85577C2C7D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:33:33 +0000 (UTC)
X-FDA: 84780179106.24.69D0E46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9A9618000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:33:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VLVkSYKG;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779100411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZsfi5JZcGm+Tih8Xee9MOBDq19QPkalRuKtYDEo9m0=;
	b=fOmCdK56kxfQDeecJjL2rxhcLZU5WjsouTv40ldWeNTHVORP7MTq40j5VE/eqacT52UT/u
	pWZQJs4MVBIQG/H3gRXeOL0yu9uEm2t/RwPX+0x6IWB+ib0q+hlyF8w9r3SXdNKGMM71Jn
	BZHtMPEnM+QxLBo2iqOqHXpnD+7IRhM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VLVkSYKG;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779100411; a=rsa-sha256;
	cv=none;
	b=3NaR97Q2MR6X2Kac4sCXRLLsRkwHKsnm/eA+IbFiYf8/OmwogE5yNwCTNc43OsIfrP0QWy
	yKKvdh2kml0D8GcMIMnguu9eprkOSJJ0PUbo5mTU1APlZJlSpQP270XxLCVPkAmbIK9z/a
	IWhNOaKH0m33TZ/r1htecMg8JKG6fzg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD40841AFF;
	Mon, 18 May 2026 10:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADDEC2BCC6;
	Mon, 18 May 2026 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779100410;
	bh=u93+sg/d4a/yYhdFKkbXPqWWlGAKMuSIVbj8UC10Akc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VLVkSYKGhlOIw9YJkL938jmsDiqk6f2uyJLs3o0oBRFaVCY8p98MNs5ttwnOF85Gl
	 1352rh3QR/kX3Si1BI8Ljc+AtOETgVhYXzh0L+r/1Va1M1Io/5bqVbT2Es/qX1nLC8
	 KZAb2fKwOPjYefzh3zOjJQsxD/hwpizZVIjaDKA4GYyDQQih1BvokkqAQ9otFi43ww
	 NKnm/swgf8Vf59lzxvQvKtX9PrMYoZIynpzRX1kR5jw60wSqYgVlACBENJr03fNQUo
	 EnegsOss8k9G/2v9GDhsyvTH4M4kCzcK8YNQS0XFDekmcSB2JBLyAdx1qD2DHiNgFy
	 c1dsm4vHzcCbQ==
Date: Mon, 18 May 2026 11:33:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Andy Shevchenko <andriy.shevchenko@intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] lib/bitmap: use bytes_to_page_end() helper
Message-ID: <agrpVfiBkTl3Vf-t@lucifer>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-6-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123428.1181981-6-thorsten.blum@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9A9618000F
X-Rspam-User: 
X-Stat-Signature: 87qkgb5h6prcm3daugpipip58me8cb9i
X-HE-Tag: 1779100411-529861
X-HE-Meta: U2FsdGVkX19t+H2Rg4cAPw1zDeHWaAAVOeR3jBCCb8FxRxXGa15644FGcekcsk+htzgEDPuKLESrZcUGvULG+92TTI+sZM6+p6p5efh7YtZiWyQA0Vkb4VnsUZLDPW89TJKl5VbJvYXJ2WmJiqkt/Lp1h3a0HEwIqhnzBBRkFj2aPNeVjlOMOCTr4iRwmXnhpOy5XEFaj3sHBjBBzHNSafkomztCtN+axIiZE65NwFnpnfuoCksoVlra7p1K0F+Nn9QM/lFb5mUlwrTc74jVUtu/ZsHEicrKAe78j/DP2eKxZXFRH//R+qscUsyo2pK1m4bN3JD/X/POLy4gcwBCMm5lBQKz8Ulh8gv+EU3tu7XSmSnhE/JqsYzmFwP8PhB0Psf7JnS59ZyGx+g/zPDP2CUrloYXiqL58hayp9HwlObVkpv83SK48r/x+HBtLiITw05b7s35U4nnFJkuhmD+TSUMZnVOc+15n1/lygdqaVMNt5AvVRbMZH/43ETWmmbZl6VkwBCSHfYHHbXF0tGeRfjqVA8v44G+ON8kniWyCRTKcWZMsxpGlf0gi8rtxu7sEuz2Rmi4uVGjf+B9ZR4+rRaiPzZFs15AAcecdADfR3TzZiFoBLHMexgG2RRJhmUQCPQ3+ZwDfecnXK88hqG+Fzh7qPuEngBgrDqSZQgZ9ASPuZ4+5A5FXqi4d0saX+B46wrSik0EIAVvPLpB/tw9ErNqcmKDqBGfGa2MjaPB/4f3qjxVI228pHZpwIkJVRnlU3zHhd5WM5AbrHSCQIgRBn8gNOV9q2O1VMIP0qsy4UVxfiBEV2yti4OyVpwFpLMJvc/NpHbooc6GPOQvhgEIFVjobciAMB3hPthLwb/kHYcmEDXtU2GN1l4zFnw+sPumfmcgjftEtPkSak4g0bqx64KSuZcHzMJInPHyVrJGRHs8kj/PN1Wp0Zo87933dCZ3FfxudwCSgUBIB/Yqdn3
 yZ2A/Zky
 O5FGrx7extLG+MZoi05mWcQMXgUAbg9cfeFQXpgDnwocOXgMx1/tq92WBMKnoSe6ZNVBE1WB6JOF5yEyCUTEvGMtd/8M5wfZBBZeJ3uW0pHDzey9qjrozFL/N0QgUpTw6TOlh73SF2cVZd0BsWOT15Ro3/4g8K6D7YDnvFtgKlvupb2BnrZJVDhw7bhpTp9NdLYRrlmN9g30VZq7vjHCEFwOGRhfrLtDWkvy06TKEXiO0qnUyIabHRagr01A78FQH0KUC3C3ziNuugqlcHAS/sLuDWfRwTfIdc+8imX9nKUyrl8pWK6FKZB2CTYx8Ux5X8JJMj2Ib3yJv6YFbWQdm9LwFb4KzKoCk+LNz5UzsD01HATnsENzg2kvtMBL/sio26kOFpuoBQpjC4y5Cj5ZQCgRCHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 02:34:31PM +0200, Thorsten Blum wrote:
> bitmap-str.c includes linux/mm.h for offset_in_page() and kfree().

I'd specifically say that it's including linux/mm.h which in turn includes
linux/slab.h and that you're fixing this, because saying you include mm.h for
kfree() is a little confusing.

> Instead, include linux/page_helpers.h and linux/slab.h directly, and
> use bytes_to_page_end() to simplify the code.

This is again, a useless commit message. You're not explaining why what for, how
etc., you're putting in words what the code is doing.

And I'm still very confused as to what the motive is here overall. What's so
problematic about including that header? Longer compile times, somehow? If so,
what are the measurements before/after this change? What was the problem that
led to it? Etc.

We could end up with hundreds of super specific headers files for things, so
there really has to be a good reason for it.


>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  lib/bitmap-str.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/lib/bitmap-str.c b/lib/bitmap-str.c
> index be745209507a..bf245a3eae4a 100644
> --- a/lib/bitmap-str.c
> +++ b/lib/bitmap-str.c
> @@ -7,7 +7,8 @@
>  #include <linux/export.h>
>  #include <linux/hex.h>
>  #include <linux/kernel.h>
> -#include <linux/mm.h>
> +#include <linux/page_helpers.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>
>  #include "kstrtox.h"
> @@ -58,7 +59,7 @@ EXPORT_SYMBOL(bitmap_parse_user);
>  int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
>  			    int nmaskbits)
>  {
> -	ptrdiff_t len = PAGE_SIZE - offset_in_page(buf);
> +	ptrdiff_t len = bytes_to_page_end(buf);

yeah this is kind of nasty, going from a clear thing to a 'I wonder how that is
implemented' mystery meat function. I think the original is better.

>
>  	return list ? scnprintf(buf, len, "%*pbl\n", nmaskbits, maskp) :
>  		      scnprintf(buf, len, "%*pb\n", nmaskbits, maskp);

Thanks, Lorenzo

