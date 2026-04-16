Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF29F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6366B008A; Thu, 16 Apr 2026 06:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57336B008C; Thu, 16 Apr 2026 06:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45FF6B0092; Thu, 16 Apr 2026 06:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29486B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:16:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 314F61A0851
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:16:26 +0000 (UTC)
X-FDA: 84664014372.01.9A2D8C7
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F95F1A000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:16:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nj4xrW6v;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776334584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCUE0FtecZrc6HnRwBw4UDWGBXzIIrS1LjxSdgGqBRc=;
	b=Br4FRICMY89S3fvoWkLUyLLMavs1XUZqI3ecBVZae2DIe2nb2XLOf2TkgvGlDX+Vyj51fu
	rJ3s+vHbXoOxIFFjv61DuHP63LhSLTzfv85myAIVKe+i2egoboAv9dvB+MbaCGhn9tnfHU
	A284V3GxRysMpw+x/gTTJxrIHN3Zw5c=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nj4xrW6v;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776334584; a=rsa-sha256;
	cv=pass;
	b=TTv052XLvlQvpCCEZXnpzVCGsiP7aodEbP4w5RJIXHFQtPemsHsmi5eGqWax6WKt2OQNVz
	obxnAOhGZ/kjhlXqWb8yN+Bz/Rt1UDFwzR9pSOEGqztw89QaqaP4ZChMBnpunVGKDDrAOF
	uqs6fUVnFejvdRlbnQhNIsGStJtTbA4=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7991db3dc98so92657617b3.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776334583; cv=none;
        d=google.com; s=arc-20240605;
        b=JN8TyIlhDEOKuLu9LMqfIeUsrrORvWh6azZCCFNe0LfcZd0wdCF4DoJVyisqTQez7x
         AM9RjS7aLP+/bxWffRz7KMZLFSHxTcKICXWiNQi5cvNAxLKKSLGspV75/LGSpWMf4CTB
         1LMVq/ATBGlptD1Ru2A9jI5xamNY3bWRv4+hjhprN5AKP/kqAUguL5a6/GS8XhcvDaWd
         78TfAdK3x+gMVTSlROA8yHChJ4Yy5xVTPTtwM7RLjA7Ma6+M4h4OhfKoL1/uOUoEyn04
         22vabV3hMo6RKbyRffZIMdjqDvNB1FI9i4qnYPsfH4Pel0n024MRSuC4CHwmiXiN77hP
         eX/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JCUE0FtecZrc6HnRwBw4UDWGBXzIIrS1LjxSdgGqBRc=;
        fh=vYcP2nuRtF3Pc+PO/u2XwocjCsphDNm6ghfmJh4XYRQ=;
        b=fgvEU24XShrw11W3Z2jZ3u2LLH4pbFd9GWxibTcJSoWKqWXwpvBl96LKEweJce+0YD
         1a94c+ANDPm9PwUk3pEaXweI1hxXWb6G9DECgISokzu+ED7Dgjt/9RNPsMWT4E5xEbJf
         S9vJ31zhBa0yOoNaciI5FJR7h2SoC+wq6NawXEDzLTBy7vQdybGIk0zBNUegtREce+Hj
         YBJiXbt9Tsu9dc+oRjwil8ljGWTU+EK9ZfEKFI9mlC5Oorsjb5kNfk1N77ihRsNIcW4N
         7YN1is3kAf5KyUXDgf4FgUiZGqae9Ifb+E+paN3s9wORy41iWqvziQsucDTTYZcPy+nh
         5agQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776334583; x=1776939383; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCUE0FtecZrc6HnRwBw4UDWGBXzIIrS1LjxSdgGqBRc=;
        b=nj4xrW6vxbhKgsMC5EkHEsFeeqP3HGnwh4zXzyDBAIE6JLLA2GGoDfPEhGZm/3aSiF
         irZkHhOtDKhHA12PRuYz0NTyBZNIXDywOG8dEowjZ7E+PNifjzoQ/UUxNYtR/n6JSDdv
         +OEpd29EWmPSNsk6KG4YxvpdjwWv0+hl+Hg78/j6KA7cLNi5Y6YjqDMRCUxL9NWKe5s/
         p3OgnRutSf9I1zXrpXuLZIwHenuIWnbA3D9Xbtub8N/tS+ePexWiHiooMYIwa9r1mpRq
         BD2QbSTGZQmEfmLshnkYyLFeNeg1L9oB1PM8kHmgcNjjJpW+DlU+8QwYYPMbV/Yn8lfq
         h6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776334583; x=1776939383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JCUE0FtecZrc6HnRwBw4UDWGBXzIIrS1LjxSdgGqBRc=;
        b=YUQTN00hkqAhTxFKNpFj6ocOQqaRe/bdayG0hz6ogleQP9ZR35sPw91Ixdsc2oyBn+
         hofYUgld0zp+7d93GmKv91Kh6SaAtcCczU1czGR/RXW2UFopiOglZSBnplqmrdX+dOzo
         oz1ggBS3QDMRR8tVPMyyLs2Hf7nRWdS54jVFcJ/gt+iAVtpIK42V9zCVSEG+GK0VmS7d
         rGt/gNIi21azLg61/hdzLMEbJWAwZEdvgrTYx01ZPzreCRfWj/xiJf5GQM88eiG/TQPX
         cItnr7H+xBu08Ks4RJkjyGOEVKoNpORLBwbPwyj7Z0Mx4EE/sD980UFBA/oaBwB0HRte
         mWqg==
X-Forwarded-Encrypted: i=1; AFNElJ9F9o2zodlknWXLfk9mE0Rh8uwROeKXhE8E199RjDolMPfmaGmMU752stH7lZEsQ+qgBf1pFrdfjw==@kvack.org
X-Gm-Message-State: AOJu0Yy9XXw02ionBVApwj88ee696osYbQLwGiTR3vmhxBjjpWm5wTuT
	hdwkBKjiyZNHl8kI0lLNmpb1kexRiLHjKKovDM/NzbyreDt0mzsTO2vLg7Gb7Il1KDwS9aZh5QG
	uRSVtsiFmgiStHhNVmDzuEFVLRUv/uoc=
X-Gm-Gg: AeBDiesv0ziNxu/BuJlSJikbzHFNaGViXaHlm+m6HzW4fmwBmk54AqzXgQAR0v0WVi6
	ezG6ndfuczwTC0uYfxyfhXsaUvB6IONDdWV9XWzfcK+izDUbhaR6lkd7wXgIfRg8zOeqQUjmXLF
	3UKk11cVaVX6+Rp9fs+SDkvFLtmOO1sxS3mEtUNJd63GqsAWjYl4gM4rmYFymnmDUwyEBSsDDQs
	WDOojeZBRQ21X1RFJ9UWAqlc0gqRkcmCDNe8HjjFtSq8c60X+xVzfO+f8yppKtBkF6tjqKbbwGS
	Um+P+lAvzUeKOkU=
X-Received: by 2002:a05:690c:c508:b0:7b6:f4f:f057 with SMTP id
 00721157ae682-7b60f4ff70emr104867447b3.24.1776334583043; Thu, 16 Apr 2026
 03:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260413154438.396031-1-ekffu200098@gmail.com>
 <20260413154438.396031-3-ekffu200098@gmail.com> <ad41JQ_MjuPNhC3M@kernel.org>
In-Reply-To: <ad41JQ_MjuPNhC3M@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 16 Apr 2026 19:16:11 +0900
X-Gm-Features: AQROBzAdDJRXGmn4Yw8HGKVv04u_A-oZ47LJ1GVhzm3jtUqCU2UPrjjU4Km51t4
Message-ID: <CABFDxMEmsM9gCqZsPahHAQ-LDvb=EucOvA_mjSTYCQtbpvR_-g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mm/fake-numa: fix outdated return value comment
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F95F1A000D
X-Stat-Signature: 7oezg7oxydum9gp4qu8dhjsg8zqz6be1
X-Rspam-User: 
X-HE-Tag: 1776334584-771633
X-HE-Meta: U2FsdGVkX19iEAB/GF4I6w7je53xxLJR9TC3fdibg5vLHEbn4u6G3/bTPDi7IWyT1l1MezBH2HKeSR4RM0CmBng7zrAMK3JjKhqtMRx+hg1Gbr9TFfPBQIz5EZaKlnf5VoMCuPKiwE1mgPF1x8ofvI0lET531As2FyO4qQVzlmCSLXUJOW65gOx4L2V7FqaX+nuC7RFu4yQxj3XZBslK3WF4gN+cPIcLtiSISXlGKbB+/7fK8CBPxBg8VnMJo1cXkhvmur64EA0pRroL7NOr8mUHjesx3lwowijRAshTPhrggP0dI0w6pxwwLTfKqUTUPOCrsMaIy7qyB42WZ/TZGQEbgWCmFyFuZEOG0hZABFbT4jBjhajwXfF3V/PdVaIqWfCMQInMPV+BpL1ypA6itQXh7KO8zJxTpWBuTfxOMMPN3ud0oi83D91jpWLDuHaMlUpRkJxpJXvAQ/mlwwD9I9q+GnoLA2gHD4b3B3Cpq6OsmKtEmMoHnIWfiC1glucjqg1FV3u/4aA4dkkiaT0cjHDZbf+Jxk3UHwLVHyBE/AcbvXknOCNS2VYdWNQhpChRMMuan563P4B3dBwmBBJmErTgCcem58ouobQTgT3WRNGvTSLeE4o5sbn1RpggojO1Ppgn/QOFsyfnZQQfNCOhcvsuXTy3ebc3neXevsWnKhmXr4qPBScH7IfV2CzevX/GdTKgqNZDVvIXOD2dys9zRYWwCl9hQZwAlAjl+U2R08zjs1WccQ2RzxoMzi7dzQtfiSVC36vjoM4wke255T/Aa0ACHzo3elQujVonB/bKLahPpINkXi6rzeuzGI2DPCOy/3JeP8FJMFv8chycEpNx6RpN8S6jvoJlshTNW1sFnjp5fQS+AkqC6Cn9vYT9vpNRBmwXEONET+d+6l7r42uqMliZY186TqlKIlqBl/BkOuEt0XA5aeYkfaTmSPK9LFSlnOGs+7Ioa6zMxrbHSOY
 hLJ63y6S
 gxB50NzBctZdttpWaR+aIy3Of7VvAqajziEvIGrx0NkxXDsrV0PC3H2mKLNo8AqD5OxGBd9ze43jit50aALVXMjh2ccpftC8QGKtaXTZl50puKWC0vDzDo5ZRy0qaB+sXIY9KaP8y+6iPKRAKiTtKNv/f28LaV0Fis4lRFMovFdcdRrkaokQI3omK/S6yL0qteDtafUZtiAAwxOaWDAfBHUkYB51tC3xmH6at6CCP5cTFj677xtSREACagmjROrJlpqR7vV7lZ4uihq6rpVdF6RXUgejQUD+rmeW2TahR4CE5yovCXjTe0+B542qhSLeMetIJne8PiCEI10eJK9yPqPjT4aNLNbl/Qwp4ZM2SfFMbeR+4pwrQ1xj2NDbI5GtT9pUx+tiHrBR4SexYt8IAIPsNFxdCXW/Gbx5O+XLpkvmJrkjM5YSvEBatUcjPP8kT5nBq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Apr 14, 2026 at 9:38=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi,
>
> On Tue, Apr 14, 2026 at 12:44:38AM +0900, Sang-Heon Jeon wrote:
> > split_nodes_size_interleave_uniform() returns absolute node ID when
> > succeed, not zero.
> >
> > Fix the outdated comment to match the actual return value.
>
> This should be merged in the previous patch.

I got it. I'll include it in the v2 patch.

> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  mm/numa_emulation.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > index e7f856c8f2a1..c1d0a76aef64 100644
> > --- a/mm/numa_emulation.c
> > +++ b/mm/numa_emulation.c
> > @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64=
 hole, int nr_nodes)
> >   * Sets up fake nodes of `size' interleaved over physical nodes rangin=
g from
> >   * `addr' to `max_addr'.
> >   *
> > - * Returns zero on success or negative on error.
> > + * Returns absolute node ID on success or negative on error.
> >   */
> >  static int __init split_nodes_size_interleave_uniform(struct numa_memi=
nfo *ei,
> >                                             struct numa_meminfo *pi,
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

