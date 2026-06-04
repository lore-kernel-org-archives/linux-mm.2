Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A47CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA886B0005; Thu,  4 Jun 2026 03:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1746B0088; Thu,  4 Jun 2026 03:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7A76B008A; Thu,  4 Jun 2026 03:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B48B6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:22:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1E17C1D34
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:22:05 +0000 (UTC)
X-FDA: 84841386210.04.A3DB883
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92869180002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:22:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=CLqqatZU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrvkDQfBnoMGYCzLOCiivKkoiHfHm/OTQW0RCIfHRHg=;
	b=Yiv9vJU10pM596Up2bT6Wb1YNhB4E6v1E3r21vL5qEov/Qj+C62Z6RNLqktOLOyxyK8gYt
	jr9qEHkitbrTxYFtkEcPrQsy48mtZDhV0fpZ5fn9cFm4Aqu40qtZUbG0HSA9f5TB/qd8+M
	zkT82RLf23HOWh1G4qgRvL4TUyOxfJw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=CLqqatZU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.208.45 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780557723;
	b=QXK3Xvg0u3Tyg7UCdnEVN5Hg7TyQQUIDVU34pU4T/N2B6UVCgbzbBgZjftZFNTNkf3dDXY
	o0LKriF2u7B/A/QsMN7ZubRo3ArV3u1ZowuI1DEmKlPvPeAg5bBIwtmondnRPMa9GbvC7n
	E2UsIeqET/Z5MNXTwhh1xPbQ0NQw9YE=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68bd9fce347so592397a12.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 00:22:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780557722; cv=none;
        d=google.com; s=arc-20240605;
        b=lac4aviFO0di37315TDZbxrAzZB4oU1KgE+V6QSjhJ1nmwJoAwTCURPMT0Rns3AOS6
         S/xTmflEvccl5zBLlx5s8r/e0PAQFDXo/P5C14bATyQ4PYtsBebHhk0K/RXWwrwKcqhG
         Y2ay/fcEnnDRLYrb+0S3hZUESMn0dvFD8hGIY1vDKgKLcp+g3X2rgI4dCxbO5ysph55E
         9MpKFeFcpPYJmfBM4olFky6MBkYJ8KGlZi9UFKwYuTq6zGSfJbelnBw7ueiWMRwcTiuv
         kX3iv1EokQbicukrEjp8JH5UnMK0LmqlGTKauFPx0BtujUi3cV3hgmeJqRt0gQEPx+FI
         MCYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lrvkDQfBnoMGYCzLOCiivKkoiHfHm/OTQW0RCIfHRHg=;
        fh=GWcqvjeA0ZbQUlKNKFKQO0myCNXGJmemMfgv3G/3Low=;
        b=PhNmXMYyA13smqWIiyPK2u47OSfEn1inCvlMDb1xr9ilOqZz7Iqsci2dMmIRoCp11o
         UZDjvoR1HAXYjXR81MEZd2I6wbkrxid+dayqQF10+j5dLFYBLdaNfkKYQ7+Jqh5ksx2x
         76wETjtGqqDm3DQ1ZxqXJYSzjYUwoRKuChwHhSYfKslYAxedpuxfh4UZoV9JcHo61Fo+
         yZnvxCQLkxG3ncPynQKsDSVJzgx2Dfi6Fb+KJMf3QKddwqvvsXtrwijdF2rnFloV0BRb
         2cRCu2AEph6gAKC3zkkVkvUxlfCbq4t9ptF86Ljy0+/uokylqJFteeGNnwtnbwFwG9Yk
         df0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1780557722; x=1781162522; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lrvkDQfBnoMGYCzLOCiivKkoiHfHm/OTQW0RCIfHRHg=;
        b=CLqqatZU9B3HOYqtBHO4CiRs7NzFm5Q3kSxKWzRvIkOIZMlp0wE1RyCMoPUvCZAONw
         p1Zmm5StQ8BtOmeGGUGmJ/D9Q4zbdyutV+2NErICz4Ddi/Z/kv/rXVoR0jpqOwO6pLu3
         24gnk2NdS+BnZ5IhVBndIRaEK+gP4SBwttu/Rbd01DI4HpdXgFUGanD7d+ntic7kroCl
         e5BIUlUw0hVZY+VBUr+vrZZO/3HJmxSYxriHNtlewGHnbVzaEZ3E+WGhBObDXzyVXY8m
         dUeF3r+CZPXvQRfcVgR7gq1WWTv83eeY0cNec6h7SgtPk3eHZ/173cN0E5ofhh/GUN/R
         u2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780557722; x=1781162522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrvkDQfBnoMGYCzLOCiivKkoiHfHm/OTQW0RCIfHRHg=;
        b=NB6B7livvB+jZWWiMOazIU7tXo5fFkhSDJIOsNSyx2um0zfi9akjp45GeZEXRjXEc/
         thb0D11wAC5oxKaAsJwsDzAe5EFxqXd0pQpfbqX5SgaSxNbfHuXu9y1PmU38nsKdvRb2
         Ybrc7jtoVzZOXigvtOD6s1e/Cx0MbiK5FjoR1on21uhn3i/5PWXDrqHemIN+1ZjAQ0uT
         Krud0VnLyUyLODkCLE0AtUu5cFsraUBBbDvBWg2Yr9VTBsYVuBak2h4S2gw5esyEypy6
         U8nujSdMLZptQZP2MJCG3oO0fhaOCQZuBpTDbky5vFwduzyr83aq2GFW5GC3XZFadIPj
         3azw==
X-Forwarded-Encrypted: i=1; AFNElJ+xBrwOQQrslUTfrPszhqfjcLqj+3W0/oK7n9YLDyeewb13XruIHrkzDG/4p+DvaJDG524/23tkvw==@kvack.org
X-Gm-Message-State: AOJu0Yy/v+YlatJ+i8UzRpKOYHxOo8sr/U6wWt1869fDdpMSrV76CUHh
	zYpCyZgDDjS+7kQWFKWg6yM0F0P/kk4DbdS6+nQJJjA4FwW/LLhqS2skXgJdVd78Y0xhc3Sg/el
	1u64Vv57AWOsxNoBbMEF4KIweH0XUxEpkl49zP1AUaw==
X-Gm-Gg: Acq92OHPfce8tmVC6fNB7OMDDhrZ5XwRogwSJ6QAax05p5ixeGopzrgQQbxMtcOM5Vl
	JXESR2nVoFMehrQXa93ih/Z54C8ovt5yIkFztsDCd1klks8x4s7IiTWdmf+W6i84P7dpx8jWYK7
	hrwkQtYaHsDbcCx+c9dOapxLthnMUzSrEbJq6P2qjnnuNnt0s8bGTQmYF4YFFYfWZ8mzElGD4Fm
	HL7E6pZT/OTlYAbXaK2GXCzNCipiMfaUd3Wn8efI0kPEaveOQl64GzH16kigh0tMdze6irVLzdK
	+2vb86BYw9iVbIqt/rnw7hyXkE4mT0GTXdMKhjBWXglQjwOH7w==
X-Received: by 2002:a17:907:cb89:b0:bee:45f5:3e with SMTP id
 a640c23a62f3a-bf0b4395beemr416640866b.47.1780557721718; Thu, 04 Jun 2026
 00:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260522225853.878411-1-tjmercier@google.com> <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca> <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
In-Reply-To: <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 4 Jun 2026 12:51:49 +0530
X-Gm-Features: AVHnY4LN7rgVW4AsJ6ueOLy3-gj_m35-QjBHqySb09IN1JOBtBY4T1wqgFsSviE
Message-ID: <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and set_memory_decrypted
To: Maxime Ripard <mripard@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@infradead.org>, 
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, 
	lkp@intel.com, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-mm@kvack.org, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-s390@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 92869180002
X-Stat-Signature: oshkpst79twkpsjhkpgth7opf9tudqpa
X-Rspam-User: 
X-HE-Tag: 1780557723-933383
X-HE-Meta: U2FsdGVkX19z3GwMfUSD+6d5ExvdyyFe6DBHqC1IVMg5TPUSgw7J8rhe6Mf4m0YtVAKZsbcc7c2GEUUAqI6ttzVO0S0PwDSYJUGx7MO/S50Swts/MD+rRzUPfC1KhOwrBq/5kNUCuizd7BFsLAeCtu3X6EwuVEVcqEz+2qEWIj0C6YZUK65EggZuE4LLu3BVYWliEsHGOHMb1eBBZD+LpYgPS4erXOGCGYpf3n2xxvhQAXtNNE/kHsWzHRqU6N+l09rQHrv5d6dMO+HMm1DxTL54YvnJqjA31fGl1h0Du+bT5GqCOiZw1RXV2DNMNpExeqAl15fIfLc3SQpE6e/D7/vgzNIo6Heu3QW6/YYDPeP076sk2EoMG+d798M2rLI6GiAmofA2uoQP58sJ7NZh19seA//9wIrh43kfp0O/sb+OmweqTV5YvT3dHXuwqy/jVpS0UvOPRHvrtSJGFx3uIMr2YOl1NtAyAcnfkgBNf0qibM1uWPbFuhie7ZNlPjZQX1TvBUfvgHLTVILobQcFQZ5KrrmK2JhTfQGeARaBcP7i9UN1/vLimnKUqJDeZVTYq2mVgT4vLp2ezfykj0/UMhSyd6dqP2SbrgFzX8E2Zwy9RoXGFxntb+IAeWsNiRx86i14ATb+aCtl0I+a8yU9aIzhoHJMjBzL6PdRpsdWOlnHrzXAlPOiDzyGpkZYUo2ZfHFvENUb7Wm7+fN8BoUeoBI49kfI7GDZQGHQK5R6T089EsY1i9FS2jzBpf4A5E5EPaKOBMheVxesHix96HCDEhij/rhJ7BjkOompe3ispJG/qSpt53io3w04ssvuINYpDk2BOVQDl+qyHrnS+uXgmbovgYUIeMy3zCdwlqzUxAE7c0uKa4Lby7vM3IIBoKRhHq7OFqPNMSP3nBGzlmwXEzwEHNu+tu/2jqio4nSafyt9kPb7FSuJ6XQSgwQm2utVTP6NGxcoH7pOjFF5aKV
 /kRliexZ
 oUj+FzRdEEQK8JhNet7lZqTMaCtTI5mz8bO5NAbvtvA4uqF9LrhqiPmr5TrNdq47t9TVKmUXtpnVq9gRKsgnEEx2sbzIuNNVhCrVHDsMlnLu7TPzQnqwguFzc2/3vkyEtPpNd/KzgIqhVmax+PXMXKt8kZQ85+uf4iRbnr5/a+hDCd5G8h6aYrFU+bTkBPqjraXQTwR+OwwCSytTTyweHuWf5SUIO/qFOe0FV6EMpPpCYeam6m7b+JTAQaZ/Tq9PSg3my7Qu07zfEP8uQMUiCCnFhV5ZRt+7H6Pvztb8YpdSjDkVdjCviHbi7tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

On Thu, 4 Jun 2026 at 11:04, Maxime Ripard <mripard@kernel.org> wrote:
>
> On Wed, May 27, 2026 at 01:07:16PM -0300, Jason Gunthorpe wrote:
> > On Sun, May 24, 2026 at 11:21:33PM -0700, Christoph Hellwig wrote:
> > > On Fri, May 22, 2026 at 03:58:53PM -0700, T.J. Mercier wrote:
> > > > After commit fd55edff8a0a ("dma-buf: heaps: system: Turn the heap into a
> > > > module") the system dma-buf heaps can be built as a module. The
> > > > system_cc_shared heap uses set_memory_encrypted and set_memory_decrypted
> > > > but those functions are not exported on powerpc. This can result in a
> > > > build error like:
> > >
> > > I'd much rather revert the above commit.  Yes, x86 has exported these
> > > since 2017, but that's a really bad idea, and we should fix it instead
> > > of spreading the export.
> > >
> > > Setting memory decrypted is a dangerous operations and should only
> > > be available to core code.  We should have various allocators for
> > > decrypted code, but not export the functionality to random code.
> >
> > At the very least an EXPORT_SYMBOL_NS.
> >
> > Looks like there are about 3 modules using it already..
>
> So, I'm not really sure how to fix this now. Should we revert the patch
> making the system heap a module, or should we export the symbols for all
> archs?

Given that Christoph's objection is not really about the modules part,
but that the set_memory_{encrypted,decrypted} should not be used here,
one option is to revert 78b30c50a7ac until that issue is sorted out?

Jiri, any thoughts from you?
>
> Maxime

Best,
Sumit.

