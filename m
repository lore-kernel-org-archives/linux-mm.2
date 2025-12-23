Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F9AE6F090
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 13:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681656B0005; Tue, 23 Dec 2025 08:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658EB6B0089; Tue, 23 Dec 2025 08:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564C86B008A; Tue, 23 Dec 2025 08:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4759A6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:40:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAF311A01A4
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:40:30 +0000 (UTC)
X-FDA: 84250845420.17.B15BC5B
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D4E618000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:40:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CUU3hrBw;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766497229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I6XlXAEilN0X40BgO/Y75hBFwj9rzVL3WYipFqiWfY=;
	b=oAnDPJ1ZKjCbt6379YdMI42xr0Isn/v6+mZlXY7qO0EOoqxbATNIflTzOMmSnUFIyVB+61
	lARP/TfXVWwsWSr1eacYwOu2egqtctmZOqlnv7iytfYZB6bVeDlRNKGLgSQMGwcodJP24H
	SeOZhi2aQiwGF7R1IT6Xi6PvzLMaddc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CUU3hrBw;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766497229; a=rsa-sha256;
	cv=none;
	b=nMbtwBzuonlIe8q3vrgw1Vo8z67KbzVzeWmyeaOP6+l5k4iJlwW3YgCtS48RLFlHd5r4ZO
	MfMalbnMhNSyeXhqDinkY36lCBDRZ1AWLEBe919c3zu3Pcz5N+ppppADT7NHHa570yNQCV
	tUDLJO/63NuLNtXvPwB8fmSxHsfcl7s=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso5280925a12.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766497227; x=1767102027; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/I6XlXAEilN0X40BgO/Y75hBFwj9rzVL3WYipFqiWfY=;
        b=CUU3hrBwN2zIDKhZNTsL1tuQRja1CR/S4BqSLaCaWx1Q8XAzOaEEK680/QWFH9r2wc
         U+uE+mR6k4VwUJPPFezlEeeX/e5UzV/9I/di/KtSd3CmK75qqf7gb7VlbO2pSthtzQdx
         KwZ2yYyOiu7EN1Qsek7vyD4wlYjBGEiLHt6rs0odpG/i8jkPYWf3MCo3fM6k9qzn8lzN
         3d6JG+t0SJbnClWAj3zsTffLZ92lRPDcwJV0ivV7mBZZOIe2FWVLAN8Jb/Gu7yP27Tf6
         Cl/hu6KR//FjWtQixExTbO1L/zTA+TZmBEKaGi0rHzuwo7WLJH3Uos/qHd+3fbpCiyKt
         YLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766497227; x=1767102027;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/I6XlXAEilN0X40BgO/Y75hBFwj9rzVL3WYipFqiWfY=;
        b=wxdM7vyHTrNDwqPuKd8tvnJilNEF03es+krqWTgse77u5UDfOIlJqBNK9IBRsw9PVf
         OWNZhLgwARnOm8bMVCtcIO4bAQmyFjhI7zxopDUwKZZpJx5BFP43qiSQQ7ZfipnQRGPt
         Rgx5wCPXo4xs8TEAdML0p8Tatsn76hdtspm+ZKLTn9DcE1WjcKtrylbYhsvLUjGhsDB+
         Y0sHIgngPHbJD261/xSlKUV8fax6Br0lweHF0w7nj2TPMmOqcpcE2P9x3Q2Mk4xK8ZoU
         lr2RcW9iIJl0Wtk3pJtpOgmFZJD/QFYV2ViQIk25/TE4rtbqI3CYRBGtgjyDIEoZh5l/
         Vb2w==
X-Forwarded-Encrypted: i=1; AJvYcCVPjNtfxx4DANtY0aIDugSHVnY8RDBFpa4oOXKIoXqGUPeSB//2ueRu+No192JFdqA/wJOa/UwU6A==@kvack.org
X-Gm-Message-State: AOJu0YwT5uEpUFmj+90zb17XlLsUfNOzXO3e9uorbjrAtYjoldsI1Ot/
	162f/VbzEc6kEur+bkRS0ztn+RnIIb5F/YafSKin0yrtLTvHxHONbR4I/ZWqA8OlxV2Ulj0Aclr
	2oLhBC6xaALyZydy2glOxujhQe4ug0kwjQFl+k1ZD2g==
X-Gm-Gg: AY/fxX7EZvUViZ94iYIuPnIS9Iiw7QRD1BLnj1KQWQ0844GN4PUaD2LMBVd2EOUmYzs
	hhdpLR50Xn7ILjaXavWuAdjk/Cs1ZTerwGdi7tphpFrHKxV2/gm8AYY0Ynx7KnA7PfXB9ioPwbj
	I+TuVvCE0xHYbK7BEMtQjCduosg4z+37bVwPDIKBTm4p6qmbO0fQhGX1RPn3pUp9L64lTEg2keq
	cKQJ8uo3TaMY2jjIjDpvvFNdXAU2kPudy3MWxmfMY+HfhRjFxpCrw5QoKGMO3bPpxOdxU/2FkS+
	sg5L0W9CXp0JtFA/DtDhbIt8
X-Google-Smtp-Source: AGHT+IEFQU33sVmeVFLErlX5wqjQ/4hBqKHnBwdxQHFQ80Xv+FpUyXlCV3CzWOpTQJ3IoFiUA/3yOMoYcOwx4IV8FXE=
X-Received: by 2002:a05:6402:13c9:b0:64d:1294:42e8 with SMTP id
 4fb4d7f45d1cf-64d12944806mr11460426a12.6.1766497226898; Tue, 23 Dec 2025
 05:40:26 -0800 (PST)
MIME-Version: 1.0
References: <20251219071209.3696755-1-pasha.tatashin@soleen.com> <867buecxll.fsf@kernel.org>
In-Reply-To: <867buecxll.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 08:39:50 -0500
X-Gm-Features: AQt7F2rhzmWJRK8-ihyTcUhLpQ6OBksFDfKd9ZX8sznEaOMe2EFoKSqVAgzv50g
Message-ID: <CA+CK2bC2BQBgtgudZ3-Tpc9ctJEaiFJjx9gNuysXLU1LGpf6OA@mail.gmail.com>
Subject: Re: [PATCH v3] kho: validate preserved memory map during population
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, graf@amazon.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	ricardo.neri-calderon@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D4E618000F
X-Stat-Signature: sjtqc83abig3gewag1exdqsou8pzztrr
X-Rspam-User: 
X-HE-Tag: 1766497228-999628
X-HE-Meta: U2FsdGVkX1/ptr6DoqpEDolX2pA15mQilBdeRIvBfHRaHBl53U2Qa38w0yq0pMncVylmttJFkYFjUaZEg/EOti8OwqO9CBlb+0P9aPuW2PlkdAiGxSk4MK1ZXqLHNj88QDhll1328yMnCUaOCU25eJWfj0oU9ydSJjFtoS0JMG++9crCr9x0+KYNIfIGMgNQX00pU/7plGGr7gY+FcSayog0gPclM50Z+cIALfQjHprp4CLHJMfuTpnqYw4wJfbjEUPxZe7KRe+uxPHX6hUlDzn8OZyTRvn09skf1o5OGK6XclhoVe+TYATW3dNuqJNifPs9oZdT/qrmjWYW1PL9GvD4UKWkdUlHxPOGyHKj9d5ub17r5nu75cTDRxKd2y6yQeNupts0k0FUlgIdTGM654nVSFNd+fxHqMe/avis+QJ0hdwonRo3fxGKR17A/Qup79xw5xxqvVVqVjYymGiMM4YKGel+WegxxT/GG9Nb6kC3k0+oXRUuEj5/l/Q4QKm0vAqLHmZhnUsnRBpUG1MEtGUiGmHhGiRvDT9VNp9neK1BYO2zrf41FwvRqQSS4yAuKNSrcGFmlNnn/VnF1I2z9jYLOBW8tcDs9ePHRpMEEi2Eq86Qnd6gX8qXLLwNkbdLswwExKwYVJiDjUh2OMe+km7BuIEGqfgObcU1TG+arsCxQsmXpwPa5ZlIe+N7ru9PufSATS+0pHt33Z/IHTv0Gr99SHSS9hhbIacCzsLcPccCbYSvsL56NG7GrUrpsUdomqwYfMgNh0p0ANKYyWz3sFhNf0rIoKsB4YzdD63x49hPGnV5NcP+HGJmEbO1u+JlCR0TQiIxM/Si3KZm9it7rBZUtpvUcoYAAnGxt7FtP35P5oKYb/7EFuEIgup8H+BzyWQcgndj5cOtRijUEcvJlTgCLPXkeZyPvRMC4QqUprp7ZqzoChWEe/SzH2ILsQ53x1QifIMWZDVzI3Gy9m2
 DrsZidJf
 XM6a+vlO75W4urkLbHN/fcXuhU984Pb3ZPAJZUGCMuZGEc7yvHW0AETgOasTMdBkQB20c8tk3DMTIGTC7N44MvEExgTbSXuXRNJ5R8DkQ5zw0OWiY9Yd575RldpzT9nqqyYF+OJPqnxwf2ygqaG+twAgJ5pMPzHRpQVfp+3iDjSV0kD90SrO1vOJFOtgYcMu2us7B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Previously, kho_populate() would succeed regardless of the memory map's
> > state, reserving the incoming scratch regions in memblock. However,
> > kho_memory_init() would later fail to deserialize the empty map. By that
> > time, the scratch regions were already registered, leading to partial
> > initialization and subsequent list corruption (double-free) during
> > kho_init().
>
> Nit: I am guessing the double-free is the scratch regions being freed
> twice? Can you please write that out explicitly?

Sure.

> > +     mem_map_phys = kho_get_mem_map_phys(fdt);
> > +     if (!mem_map_phys) {
> > +             pr_warn("setup: handover FDT (0x%llx) present but no preserved memory found\n",
> > +                     fdt_phys);
>
> Enabling KHO but not using it is a perfectly normal use case. This
> should not be a warning. I don't think we should print anything here
> TBH.

That is fair, I considered pr_info(), but I think you are right, lets
just remove print.

>
> > +             err = -ENOENT;
> > +             goto out;
> > +     }
> > +
> >       scratch = early_memremap(scratch_phys, scratch_len);
> >       if (!scratch) {
> >               pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
> > @@ -1515,6 +1517,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >
> >       kho_in.fdt_phys = fdt_phys;
> >       kho_in.scratch_phys = scratch_phys;
> > +     kho_in.mem_map_phys = mem_map_phys;
>
> Nit: not a fan of duplicating information. This is already contained in
> the FDT. Perhaps make kho_memory_init() also call
> kho_get_mem_map_phys()? And while at it, perhaps make it
> kho_get_mem_map() and the return type struct khoser_mem_chunk * ?

I prefer the current approach, fetch from FDT once, it is just a single address.

> No strong opinion, so fine either way, but I do think it is cleaner.

Thank you for the review.

Pasha

