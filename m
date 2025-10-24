Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C58CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894678E0027; Thu, 23 Oct 2025 21:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845138E0002; Thu, 23 Oct 2025 21:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B068E0027; Thu, 23 Oct 2025 21:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65A548E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:24:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0453DC0D15
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:24:10 +0000 (UTC)
X-FDA: 84031261902.15.7FFB3BB
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E4B02000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:24:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="e/Nb3QYk";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761269049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+Ewuo9a/2we8RgcxmU8qjQ8t+tF8hL7x4+dIkq7Jb0=;
	b=q8b/tBob9SXmoe1ns1ASY9WN3LCXKA/mhXI9U5FR/PGrg5exjT1bKKyvDA+cGux1K1VPZh
	1Mgbmp+H5IwlO2gt/qIbE5WZvLq0UCtx3VIn7vgQOd5iGyWeK/d7XYH10KgGybJtiS5gSW
	W3XK2E0svkTBhkTh5rf0zFw86lZyEAs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="e/Nb3QYk";
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761269049; a=rsa-sha256;
	cv=none;
	b=VjwximPR7FY7vox7LMZzZbfpGvC5rurR4Z6scVVoXWKiPXNLP9fzw5vvgD7NnCTzGN5+x4
	vH8aZWK2gy8iqSVHbOpuuifO/Fi1RIA/RNl/no7QmGzzJRhyMNj6ziheMBnmvwRfGNrcQL
	I5xKbU4EA9QS2IUFOGOZ/BduPFi0UF0=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b64cdbb949cso325390166b.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761269047; x=1761873847; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+Ewuo9a/2we8RgcxmU8qjQ8t+tF8hL7x4+dIkq7Jb0=;
        b=e/Nb3QYkc7vJjfPeedrrFvb4NG47J0Zj0STRjktDjR4zYr+T4L4zX0PRIkOURp/3Kd
         tyHH6ZZ6p/ncjSiJvvb2cbklxdv9hoU+s/IHGPp0NZxlM3HqN8MXUGAe9RlGs5YRnSJ7
         yFpeie3V40IJ6fpJ5cEEzqTSPWbABYo2g08DDFDFiBgsIG7E7DeCW/STJnPXPFqBmVG4
         cfYoK+VfMb3JErQEVGc/vnMhIUevX/X30RZXp7eTcYltJ4tS+GefNtYFFG0UxNJBU4Aj
         55noNw0mpVU+2lVN5ZY9cyAIPiUII3YcugrgMfzA/2l/h1TzqgTVaV5g18ijzVfXsRo+
         L+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761269047; x=1761873847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+Ewuo9a/2we8RgcxmU8qjQ8t+tF8hL7x4+dIkq7Jb0=;
        b=RYKFh01ncFRPKMZuwH19UqHGVL4LiHhdAE64R7G51BcwHcpZTyXgoe9cMVNRD3R7gV
         1gwovLt97EBAFgORtO01AlTfLUD/ccJplNBV1Tc1N/9TJB96Z8bHmqF8CIoC9hFpgmid
         mOZHFM+/f0Nqm9F1tPXEQCC0xbduvJpf8ptIRc1JtleMCEKabrqCq/6uJZgxI8ICpmgm
         6QG3AF36AY87MEXw4/lZSPHg3z100HFjIPgwMOCchLt7K5bu68KB6uYJcbt4BFyI9RR8
         4CiKQbPb2w7j+FJVTj7nFs93eSWiHdXUOHG3Kvs5D/Gwk2rCnvfOvTKUpPJ9/QrqcEs6
         s+IQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAkIcluMge4E5GHBq+jaEVHpy6ADZifb43a0ZjJgYamVtXmWhN6ARRUpkMnedTH8RdzyyEXB70GA==@kvack.org
X-Gm-Message-State: AOJu0YzsDCRHlGvI2uoxZlLgkG6foGgfLfm2keLpXG+BsCph1QFezf6m
	s8IuAEZXrvjPnSdGqCg8wcnXHAjMDRpSaZ+0TRYr5/YA9j2M7Q4psp0v65j026/uhySNHfq2kMW
	CnBBG1kfwVx6eyvs+QYIUgFQS3LxnrVozYvk8BOF7sg==
X-Gm-Gg: ASbGncupKKAlfCT7ZXR2VB2LbDoi0h5LnCuOcekS5LCps0wdXbXX3B/V+WAhLMyCKXs
	7VE8VoFkaQZOvIh1JFzGGCiSoWSIT0MZgNBCqhPALi4tzGUQj2xvNGgRgzVYDa0MwCiensDsg2C
	vfoUARl6I0YRkC2P5TTYgK2634GiFOJD+5HmUt1DBpDSs333rKx62HJRwmQgJlLwtrm9U69lyZS
	kPLNOtmiRAo64Cb3z0q5wZv5v0tEkobDDcckAMzm74lzDQVlMp60o0MEnrLkDodG60lKhyoiKdP
	2d8=
X-Google-Smtp-Source: AGHT+IGPGFOQwXjv/FxDxf/tnyuTjxtvPtbnk93Nmt5FLlBDIFGiWQ5Zxzwcgqg1tu3cm4Iarmy9Tfwt6vB7TvUL9y4=
X-Received: by 2002:a17:907:d649:b0:b3c:200b:4364 with SMTP id
 a640c23a62f3a-b6d6fe0424amr55993066b.27.1761269046741; Thu, 23 Oct 2025
 18:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com> <20251020100306.2709352-2-jasonmiu@google.com>
 <20251023234532.GA846943@nvidia.com>
In-Reply-To: <20251023234532.GA846943@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 23 Oct 2025 21:23:30 -0400
X-Gm-Features: AWmQ_bmMOAwY_P1hjpj1ykwuacULXmguJ7YYyQlMD3h9K2SSIMuIchdHSzMvpu8
Message-ID: <CA+CK2bCR0r61cnVxff6XSPoVN+ZxxS8rLHy0Mp6922xypCP8jA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kho: Adopt KHO radix tree data structures
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Changyuan Lyu <changyuanl@google.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e57kgbcx97ouxqjehxkdxjypqss964pk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E4B02000D
X-HE-Tag: 1761269048-550127
X-HE-Meta: U2FsdGVkX19i99+90nnzXGJNfPqgEiWhmwVmSmqrK3cQSNqpe5VpGbK5zvEGuEGXTRTdfDTM8chz/vXRanB4PHV//tij14AeoAHQdHInIx0bsAteGngWdUYNBLVb18fhIEQxPuVFnXdvawpc/rhTWJNMDgycfPioIXmpG5xIJWKHsIzb9yvB2jFEJmx/2wdhX4YDiwS70e9daEQ6Rvhcl9g9FXGeUV8I9kbt1zAbpPpbC0r3F2I2xwovIpPeZSTMKEFsjXeni+sRjuIC96PILfEfiDE1GAsKxrl+G9gwVXWqhavXD+8LcLtzrXQ2F42WlYTtZcXKOzlhrBlu37S37Z2ZnlpU8zwBVu3RrZI/1EoDMo99cP/rKWvQI0pPx5rONj5nrU64k0cWvVgJAY8sqTVPtvpjsxTGLOXFyoI86kTp5G54JMFPg64mhI4nDCJ+RpmcwjgMihnEpbBFbG/UoaxdiBWOItWLyz+MXi3uiQYTxIW+sPEEy+EUMSl35PPAPID7Rt0j6OQfWTipfOKDVoTytxsmHdUQeNyBdsEpv+rhOZFLGkJa9bqCy5aoFxNljFQt7LuSkBwcafudYVFiKVl6lUblJfkyJXPprdV3l447lZ+4nWQDgki/9vPqw5qngpQKZ5cVuI/f0bUMi4xKZngOw7s5znxTEJ5ehlc/ksxHUdwvFQbT+KtiOJaIgJr6cTjzFVleBA+GkoWlnNmXF5LCjxTvnPoGrgCFSCunZ/yG6nfJd5XYRRw8mBtWtgu9Oh5gPpa/bP3bVjJgJ+qLJh4FiF9EzHgNXQJZrzYO/mtC0lD5qj8e8Rf6lqy39IimWMcsyCPD70qOE80MJ8hCNyVTCV5JTUjgdGi2+3LfWtAl8iziBodkvNlmjSTI90PRWL+u2nUj/xlZBtCz3uyKugj/WsI05RqsTFEGsnR+22eZEoBWnqUpud6puppuimvFfRstv48Jr0/o/EbLddK
 CuZeMeyU
 I0mpi3TRSByyW4VeEmLKqm22TyTsecrFebg3WCZHWTzGhOhx3n+F4MpYD1aoK20qMYQVeDheoUkoinIQoTztjdpMlX8ARONluqOys7d1UXIz3wbbYhv7yFr7qMyMg39chm+1fXZAbyXUNVT1B0IBoYyTweCN0gnvR9r0Gr2BwoRemK30hGbPh2TEn0QktwKOVDXsMaSZNnUueq77PCDUiwdPHH90VX4Qz1rLppwLXsX8pAuJy9IvnsbyNboli0Vmq/GkE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 7:45=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Mon, Oct 20, 2025 at 03:03:04AM -0700, Jason Miu wrote:
>
> > +static struct kho_radix_tree *kho_alloc_radix_tree(void)
> >  {
> > +     return (struct kho_radix_tree *)get_zeroed_page(GFP_KERNEL);
> > +}
>
> I was reading the thread over here:
>
> https://lore.kernel.org/all/20151222210435.GB20997@ZenIV.linux.org.uk/
>
> And I guess this stuff should just use
>   kzalloc(sizeof(struct kho_radix_tree), GFP_KERNEL);

kzalloc() uses slab, which in turn may use kfence objects, and kfence
can allocate memory from KHO scratch area, leading to memory
corruptions. Let's not use slab allocator for KHO preserved and
metadata memory, it is not a good choice.

Pasha

