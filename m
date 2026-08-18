Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B73C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2290D6B018D; Tue, 18 Aug 2026 09:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9916B018E; Tue, 18 Aug 2026 09:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8C16B0190; Tue, 18 Aug 2026 09:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E806E6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:29:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61C861401AE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:29:57 +0000 (UTC)
X-FDA: 85114473234.09.C04C0C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A273E4000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:29:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhKgXKmP;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787059795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9rUv4TdujbZ6/XxkM7SFbymVzpaYaqLUiO3R4LX8BY=;
	b=ELZx68fiIXX/TWvTHY7kk1as/EH4TRCkJVzlZ37sCtAy9/eevonqqCHkv22QWqITlAsMCX
	Q0UhuhBIIF3zQTMaYH35JmfpF6MYHHU5m9NvbxG+9zvcfdUd4Yp5faO247DF0SKNa7fATu
	V0OWRY/XClkGaXCOnlDJFnYLAOj4Hg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787059795;
	b=w2HwANXr35rg/NzzF8d29kyoJ/d681PdO7e8RFQiJ+J6EMG+dI51X09FSYNJ1+kjfSuH+t
	kUnqr82Nleybm99QygX1GKCr9no7EOqVCS4QbCy6gF1swrOaZbehMyQGew/Su4+XK8MtMO
	DcvkIunYYGiGXLlHrEqifP8f/xekYn0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhKgXKmP;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C65B143D03;
	Tue, 18 Aug 2026 13:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5166D1F000E9;
	Tue, 18 Aug 2026 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787059794;
	bh=N9rUv4TdujbZ6/XxkM7SFbymVzpaYaqLUiO3R4LX8BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PhKgXKmPhaLMzw9XPrcieo79uQDMA03R6DrXspM/ddU2BF3zoc2D9RP3+9ywMsPGQ
	 wgbkqFGoiAQS4Bidix2KKA2cys14vJbFcaiSIUKCkUML1UMpO/5y/g/te2G6JJtFtI
	 mT3+joG7lapBBRFcihK8rH1bh4aPFQez1gd2GGavkSz9SNk6uaI/ya2inHaLpKI67N
	 wCffB/E4eLIOmJ6rGpIIBdBkDKODZtzg6cpAY1pzZxTs0UrJLjNj4CVsInHkq+jgKk
	 +YbqwHss5uhCtsh1MypAXf/TqiCkSc2CPJo4NnohNID/NThsTNhC8Zxx4g7DmwQm4x
	 QARzujdhkA1EQ==
Date: Tue, 18 Aug 2026 14:29:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hemanth Selam <hemanth.selam@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Yury Khrustalev <yury.khrustalev@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Message-ID: <aoRcdLGWaNhUFIPU@lucifer>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
 <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org>
X-Rspam-User: 
X-Stat-Signature: qfpjo4kfnufbq7hwnsrurk14idt9cmh6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A273E4000F
X-HE-Tag: 1787059795-97764
X-HE-Meta: U2FsdGVkX1/utTvW7nzWff/KmKhY/zBotfS8joOhjX+0MZo1+5/YLZQiAKXJd/iXrh0ZnkGyUOKgGT1topRKoNFKiz2i/3GO6IvbmuGqoQlC3b+0dnnoBfBegxZGCyiooqi83Tk5nfACmOlxOWoc5xddxupKyQhyM7YNxw+g9JsNCVcufKv6U8G7KBptZYaQBaN+LOf0s+JbIQO1dpF6CK53TD3Uo5MoVjQP90ThcA/bFhOba2MDZoaIi0AxlrGOmLLoAJU7afyFrvOk6lnt10OisWKwfAeVy9XFvLI+MPJkbUiZY0gr4ekNevWds/YeTwuqk6Y1dAMwpTDXhmVqM4jq/NHJ2hZqhJyM23POt5DlduDuaEFTsydREjIhB3742nOC2XLMm7L4s9+5FbfMIYuStm+8Bj6I0rtMbr3iLLX1E6ZCBQY4XBir0qHqK9FE45OxtAHVBh2eIrqB+yJOVWPaqIV4amNGJn8wLQ+l3on4Mlb7pzF+bb1aHtOqZ4SMemv4SNPmcBH4QnU/Nn8B7Gxi74qnLqBcwVyg/iSwcDidZxcLTcB7vc6nkxsq7DuMGcAOjLhGwgfzDTxzb89rgaj7ErVjZnLU3l9k+9MOrqybOFww9sKEu4whR04oXPFnjmeRajLMb/s6IZRGVq9tnC5edtwNQYOyfdkvL1b5XieP/YtrSGjtIeXAYfosxHBlDTCeilLCCLSjORoU3+fIZpXOQ54NhvhDcnbcy8KRydgoEe44AeRPeESCg1LfHFrtJNAz3DnXHIufgq/x40nzZIwORJj6qpfK40jFEOQWyiXV9IBTvWC2Wsdhnr5cVjOLYIz/g0QNFVBh2DkzEYU+pOCOjfzpG/blQ9imOBOGyGQEp7+wRV0DF1tA07XcdWRIOuZf043P+U+out74xC4BZnrcUU2XwWKgcEyjIQdnZlRdNi3+ghSBkpR8JGnun7wgkPKBoSyD2ev4DX1JgHi
 DFNuvK60
 HizF2Wfr4txhknEQR0PYPG8ItkWQjIv6WIxwEGF1WG4P8Um2UzTbQ+ga91XEJRf8wlA7VRTOrIhIe8+W+Iy8qazLWPqd2NwxlJJQzFU1ojEw+srXb4ZtJEN6U8ya8cexJaHh07Ug1+gOSs1Odc9z/FSxJiEQecAt3UbEEGjRGFMmFbO646iiSYaywbgrTHg3gBgeOkv45JF2dgsWbluODQ4Trl+J00hOrKmcJXlvROqsXebvjMnK/7BPz2RGDdBW4oetAIEMs7Kkzy+WGQhzOM0SBBW5jMTW+0i7enH/XOLpP7LT4H1wkvBZqOx+vvv5O9HlN7m03vSUnOElDLFkIRrXiJBpuLUQCaS311KqUK30Cn0nD3jNJDRitTigLcDi6zS//ks0rxbh5bqsRezMXyxIZuyQZxZV5sBX7mPMq5s5LzjlW4tDCHmxhHB5qbphQlv6v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 03:11:50PM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 13:49, Hemanth Selam wrote:
> > pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
> > already known, a stopgap from when the generic definition was still
> > under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
> > Add PKEY_UNRESTRICTED macro"), and pkey-helpers.h already includes
> > <linux/mman.h>, so the guard is never taken.  Honour the FIXME and drop
> > it.
> >
> > The mm selftests build against the headers of the kernel source, see
> > Documentation/dev-tools/kselftest.rst.  Building them without "make

This is incorrect. We explicitly do not have this requirement in mm selftests,
and they're often built without having to do this step and tooling has been
provided _explicitly_ to allow for that, which is why this kind of thing exists
right now.

> > headers", against system headers predating the macro, now fails to
> > compile instead of quietly falling back.
> >
> > No functional change intended.
> >
> > Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> > ---
> >  tools/testing/selftests/mm/pkey-helpers.h | 7 -------
> >  1 file changed, 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> > index 2c377f4e9df1..626c2e1655dc 100644
> > --- a/tools/testing/selftests/mm/pkey-helpers.h
> > +++ b/tools/testing/selftests/mm/pkey-helpers.h
> > @@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
> >  #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
> >  #endif
> >
> > -/*
> > - * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
> > - */
> > -#ifndef PKEY_UNRESTRICTED
> > -#define PKEY_UNRESTRICTED 0x0
> > -#endif
> > -
> >  #ifndef set_pkey_bits
> >  static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
> >  {
>
> tools/include/uapi/asm-generic/mman-common.h:#define PKEY_UNRESTRICTED  0x0
>
> So that looks good.
>
> But we seem to have the same ifdef also in
> tools/testing/selftests/powerpc/include/pkeys.h.
>
> So likely that should be removed as well (after making sure that it compiles?)

It will break people right now :) it might compile on one system but not
another.

There's been a bunch of discussion on this, often quite painful. See [0] and
surrounding thread for some history on this...

IOW - this isn't really costing us much so I'd prefer we kept this kind of
thing.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/all/5b0b8e1e-6f50-4e18-bf46-39b00376c26e@nvidia.com/

