Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F90ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 20:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC548E0045; Wed,  8 Oct 2025 16:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3A98E0002; Wed,  8 Oct 2025 16:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0F68E0045; Wed,  8 Oct 2025 16:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC688E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:27:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8E7A88193
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:27:20 +0000 (UTC)
X-FDA: 83976081840.08.9351D1B
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id E2E3740006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:27:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XlAcSH8Z;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759955239; a=rsa-sha256;
	cv=none;
	b=ctYVowIH5J5VPMqc/FOSdVLdtj3l2UpiIFmHFOr8kb+FtgqpkjsIIfRn/UO8mKlQc/Ssic
	1Sw8o7/Ug/ZQSmqTc74nDFj92iCVUICNRQItZHP+XzU9/cc9RMEy8qvhmyelQtwsj8kVye
	XlUK03HvFm8INddHaj6zVd91eaCmdV4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XlAcSH8Z;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759955239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft9wlTfMhhvdI9XX1KOPoXEFZYD/S9J3oHik50ZJpxk=;
	b=WY7wpPhgbgtcLGhSJHTDsETFMZTRjWEsRK7/uFo2jDuKJNRHLxoIjsDaOmmNfb4LWr8wpe
	tK7gz/qswumjHnaqn+vwOUOei9odixflSdJJYohHtsjgvGivnzlK+Rl12S1JWCnEEPIOya
	HjNM5tSq6iaWBI8xetpWziIe+T7x6ZQ=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4df2911ac5aso1107571cf.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 13:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759955238; x=1760560038; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ft9wlTfMhhvdI9XX1KOPoXEFZYD/S9J3oHik50ZJpxk=;
        b=XlAcSH8ZIYcTzLOhvZaPGpdxtWjna6IVAoB9CBl5lXjPEZFABHDhrZlP8ValezJbVK
         ShOt79Qe4PJJBFnLcvUsbmFHTVY2E0sNew9kvkKLWo6I1wnZNCuh9eqeCvJj4LZwowZ4
         HkcsqKUTIpoH6B6o+QR/ox273JKWbjf4Mb9Z1h3FyJf3yB9DA5Sj+oDBeec2/YyADeHq
         kuaLHoeTTsOPQsAn9+RJD8RJ/6oQASCK2Gh6LRr8ULqvfAWp4GD8OiMnzs+1DwCOdX+O
         Du7JQ5O5hlo6qByt6f0JOPyhpowcSBPhzkcwcsNll2rGS35uWELnEJtsPprs7wiPJVQ7
         sPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759955238; x=1760560038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ft9wlTfMhhvdI9XX1KOPoXEFZYD/S9J3oHik50ZJpxk=;
        b=lNb4biN1RaH5wu1yXsoX8+Kd1aoLxocLyYGIE4PgUERneD6d4HxEDrXB1U46GSvvB5
         272iOL9x7ha+u8nZC/PaXYw5bZoWOODjqT8UnHCBOdEHKoFcce0Qo7H345VnMO0RUpPr
         NTJ2/WKRqdRa7qvnWQHIv4UPyjsI9FQQYdDQg9RQoVMlAYWZ6rR26retSstvC7yC1x7Q
         QQw2PG5cjaR0PyRcACzWFi3w8Ckf8EFDOI2dpi0ofVtQyFtCIBnRqz6pNPhl5eDjMivW
         R9r4b9Qs4I4QWURX9L3TN14394xQyYpQ2zqK+dBjSoiRh+JxDBB5/zMiEaDOEc/G9GbP
         nR+g==
X-Forwarded-Encrypted: i=1; AJvYcCUjaIxXCCgBvMV5sVpAxGQ+Yb028UjWIh0U1M6rrJZFGj9mMDq8O2iJBnKOhy5y/1LcxpbcAQDH6Q==@kvack.org
X-Gm-Message-State: AOJu0YzQ0+g7260PC2M44TTbpGQsN+oCoiso51xoyVfceDvJRWYu7CU2
	IYi60a2wForoEA95S8/BrNONOr2BIAgK2c7patzcawf+HY7+EIylP896sHEI+sVtsF0c6exygH+
	gaeD/uPYiyCcEYlWn4rh94PfQt1/LQWgMnmXtbMxr+w==
X-Gm-Gg: ASbGncsiNgYTMdJ1Y6Meipj26B1fUxEuZzxABQUO2pbu8eK5uWhHf+MRvarR8qEeurx
	Jd6OZHctGYvE1cUmSN735/v9qfQcFT+9aRvYYPezfjiKcfSYhqJoKbPXB7J2vXcuedpDiHMPUPl
	8nagFCxLCv/wQd57TAmqoqoPoALUOnWOL3OWNVjJJ7e82e8hbMkN4xAhGo3C9UlPLEwctzqoytG
	Sx09j5PD7wHEJvt9lzUgMX7k2NH
X-Google-Smtp-Source: AGHT+IGAPqmJcgL16UIg0d4+RNt3XKw0htJPMbSHIFhskDVjDGNvAxn7Z6jrk84cREgUa1kvsB4Hz5CuCuJTQ1VRagg=
X-Received: by 2002:ac8:5e4d:0:b0:4e5:6c5e:430a with SMTP id
 d75a77b69052e-4e6ead671a1mr74767911cf.64.1759955237650; Wed, 08 Oct 2025
 13:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com> <20251008193551.GA3839422@nvidia.com>
In-Reply-To: <20251008193551.GA3839422@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 8 Oct 2025 16:26:39 -0400
X-Gm-Features: AS18NWDStUB3aziIoEu9unN2oxgQKkUZyxSI_-rUVqTnIsSkLapICWThr2gCAYY
Message-ID: <CA+CK2bDs1JsRCNFXkdUhdu5V-KMJXVTgETSHPvCtXKjkpD79Sw@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: yrgz6ghabdzq4fiec5rada56jyrt87hi
X-Rspamd-Queue-Id: E2E3740006
X-Rspamd-Server: rspam09
X-HE-Tag: 1759955238-458455
X-HE-Meta: U2FsdGVkX18tgx5GRYLyT+U+alEYEE0gTqiYNF74ahb+NSZmEDwB8We5qHDgGvO7WB9u+z5WxMxpXnRbRwc7Y3SdhrvCHDtMaZ4jm7dL10Ez8Mo2rUEWacBxXx4AnarzzU/stL/PCM1e/iy0dRwcyUPpFHk/GSM3x1YiqNhkvu98cW/COdcfogGrV3/D4Qdch8pbKmPUNVqPI4qQ7TSj2NRioTCbul3fk4vCrqu8K7bs4KIaZ9VpNMQr5z4JLupARTCWWNa2/MXYj/zE6bzI50OZAOs8W28dAAnNSGhBbjplc6eU1rvlzFO4egjhsBZUhaIlgtLOjGi1eeLwv7IsIyxtgKk+KqIF7BcXXk0sLdj3XlXM1kFMF4VhMDpVOOwX0o6aiJYWs7AIFoMA2Beox9UG9vFclq0dyv3vkBwTPDmGIsIsCOtqJ1i47VAJH/tFE1dsC21OMVRZNrugQmMCUO52ptscRrEzmnHr5FFw3xRH6yJowHVQSyZKfoMTAohQOIDUEsaCRVvZFUtDC1XnIHZf3fJbwQJWPg7p04MUDpNZUOWMNtW7bmP6JxzGJniO+sdne7YINU0tgID+HwX+bW2tkWK7f6hVaPU/uFkxMMAh0/1VFgEX1fAigq31NCUxO9q7hSZ1JwApJ3v0NGzLi7ZuaJVI8nxSj8oh4llLCtmHsKhaih6SNgxWPVAOphc593dzZNAishVmNK64c36uzQiDBXWMBPEdAsQ999oSnhQ5EhHE77hyq5dQCcg10XujlHvfaICCiJhmCSVXgx3hR92E67SSAKF4N//7TRq7sas5GKbx6v5DwwrcSWg3pOY40HqbIVJXk7FQDSbiJQ1RqwYdvH0MI0jKRYotpCvTMkP5UMd3tHNdM0yHMGMNec6fchH8OuTAxzbkRkrSYyeyEEAUccRrgHxnRevhupIS8t8wBcSLUj4Z6tFQHq8VXolWt30WDCe6JUiygw4Cf5X
 FEbO8BbN
 RhnUCuYQwzdQtOnuFQmIxLpAPAoh6FOgT6JiQD10No3iqj6jV6z17IHh4R9GYY+tyLDvTJ0Z9jQCto9GHj6y/nR/lf14OdawVAufFDFd+4umeWAF6m2iuG30FtTMNPh8wNx9ncwEVddHuc/0ouYaaYrZGcchjIAsTFXan7UZD0WAIGCgaoE35jihyPELKyICMH6er10TJekHMjbBfJD/uQleJ+6ufNGBCdDzP/jMOKIRUT6VntJKnK0CjkbrMgRpRI901s1ma9sMGXJHyvwMCygqx0Qpk6RAYs5le
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 3:36=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Wed, Oct 08, 2025 at 12:40:34PM -0400, Pasha Tatashin wrote:
> > 1. Ordered Un-preservation
> > The un-preservation of file descriptors must also be ordered and must
> > occur in the reverse order of preservation. For example, if a user
> > preserves a memfd first and then an iommufd that depends on it, the
> > iommufd must be un-preserved before the memfd when the session is
> > closed or the FDs are explicitly un-preserved.
>
> Why?
>
> I imagined the first to unpreserve would restore the struct file * -
> that would satisfy the order.

In my description, "un-preserve" refers to the action of canceling a
preservation request in the outgoing kernel, before kexec ever
happens. It's the pre-reboot counterpart to the PRESERVE_FD ioctl,
used when a user decides not to go through with the live update for a
specific FD.

The terminology I am using:
preserve: Put FD into LUO in the outgoing kernel
unpreserve: Remove FD from LUO from the outgoing kernel
retrieve: Restore FD and return it to user in the next kernel

For the retrieval part, we are going to be using FIFO order, the same
as preserve.

> The ioctl version that is to get back a FD would recover the struct
> file and fd_install it.
>
> Meaning preserve side is retaining a database of labels to restored
> struct file *'s.
>
> As discussed unpreserve a FD does not imply unfreeze, which is the
> opposite of how preserver works.
>
> > 2. New API to Check Preservation Status
> > A new LUO API will be needed to check if a struct file is already
> > preserved within a session. This is needed for dependency validation.
> > The proposed function would look like this:
>
> This doesn't seem right, the API should be more like 'luo get
> serialization handle for this file *'

How about:

int liveupdate_find_token(struct liveupdate_session *session,
                          struct file *file, u64 *token);

And if needed:
int liveupdate_find_file(struct liveupdate_session *session,
                         u64 token, struct file **file);

Return: 0 on success, or -ENOENT if the file is not preserved.

Pasha

