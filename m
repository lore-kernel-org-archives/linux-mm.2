Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31DECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351068E0002; Mon, 22 Sep 2025 10:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328D78E0001; Mon, 22 Sep 2025 10:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E5D8E0002; Mon, 22 Sep 2025 10:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 128918E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:58:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABA58C06AE
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:58:19 +0000 (UTC)
X-FDA: 83917191918.17.1999261
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD689A001B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:58:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GJskqpTx;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758553097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFVWZlAioBD8f+qAHkBJ/aidH/GZeFQvA+qClIUvAWI=;
	b=27TSjzJukarHOUnpbN778YXX+wBKKuT8+6Pym1Cpk+YPUcRmmEyS4Sgzs/bGq2kzUn3I8M
	tF4RdE/d+YEPCcB7ClxtCsSTodesbBkPjyjnIbJgHR9fVQkwx2GPj7PSQj71P3VH2S7Efd
	QsCMxO/+S+KOY88kNitLtOPsfVtsxfk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GJskqpTx;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758553097; a=rsa-sha256;
	cv=none;
	b=yo2kb9/wlTmYl44VQQQfup4NE7Jl5aWsG9z44fbgY2qznHF6gmH/XEkm9WLy8krys1BO4y
	eGWCocjv8YEZt0IbhXqX8mpfjesc3wcxaSYuXsrEbMCEvQ6LiftLRBVb2YbnMO2/ylJoX+
	mBW0HIod+s1iEzigI/WOSp0y7LS0x6E=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b548745253so76198881cf.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758553097; x=1759157897; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFVWZlAioBD8f+qAHkBJ/aidH/GZeFQvA+qClIUvAWI=;
        b=GJskqpTx/shRPO/X6T4PnT3Cnpi/lm4LBFt6e6lPOX/e2aSbwZsNtL3lglNR4Vkrii
         5fuQWcLRRpIdVW2dnfYfmXfR7iACdnPDspZdyfcP8BaDMLqEkuPbDx6Qyy4tiza86eND
         8fnTYLCefo1yFXEfPOQ4u5cMhWRyy81e1hESNqAAWHQACs/9uNvhI01lzbREj5BH487K
         99f1YHRXVyVLO7rCYa9UQ7sFz8hhAi2T3oss00YRWFURzVQtd46PrYAVPwo2kt1sGia8
         NEhLIEGrHIat4pNlkeE0lx+8ZKiYVw3DMhpRn9wFtnpi8lsCfxuCR6qD3RZrzIqOizJ6
         KVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758553097; x=1759157897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eFVWZlAioBD8f+qAHkBJ/aidH/GZeFQvA+qClIUvAWI=;
        b=twoGXfjgu04Wzv4IWBSJrO7sdGhiJj7+pknMuIFnN/vzOyMEymIe+T+RXyXcUidl9O
         8+sE8kwWJcqma/p/3ekq40KwhuQBgrDHH663+7NeYgDPvyBdQbShT0hueBsw7F/gAO2c
         vHBW4eJnekvXttjSl/T+Ne2i7RiavdKtrbTN/Dh2ZSVjsBeqG5IfBn9TRqAV4KOqV4Xm
         qJPoOCXQZuMwZEF4+fiyNeI6XGAZbph6ZR/g3xeJH/ZIkc2wEwADZ34B7GExcenbo9QV
         uC0XRIGfcBwQYcoVtYw14X6xRm4fl0YpkNuUAdENciPbjFx4ywH4+hhrktQ5lNWBn0y0
         QvFw==
X-Forwarded-Encrypted: i=1; AJvYcCUzXMmdcZgf9g593rgGZdmQLV342jiUa9ruwp8O8IFdkOEMKHLSYBoop15xCu927wp3rxAFi1fKyw==@kvack.org
X-Gm-Message-State: AOJu0YzdwPO7O3uijrwp3M8QdjER4Cmac86nP1xhlAgl760GZZvT4ylQ
	xHayuoyqPh9O6+WOpwaxlKvQv7NrhCTVEsEcz2nbzkW5kNSU6Pbp5EtjKbnxt2UWrsuOk1mem0U
	dWedMNPYlxEzxe9iVKhY4O2UY3DE5AD3rGAUbI1fuEA==
X-Gm-Gg: ASbGncub/5MHthxr9EfuiFxCjEpGfvRacKbya0ZXXqpXx5+BKK9vyJaUL29WJiz8iyU
	g0xrquK0wbdDk40H+2irzDs1X4gvZM1Z8DvclK9ipXQzdKu4LIG7Inhf0dxdk0Tgv7ttk2U7LZ6
	A5Zs/yHDd9b2ebsgTVEHumxVk/5C4nWzi0Td6VwBUR2ujM/S5RwbuN/t17Ne2okmAN6R7oTFrbA
	Qrn
X-Google-Smtp-Source: AGHT+IFB/CQ+Stx8wqmihXNU+u019GIyHx6IROg0+AJtIcKFDHMuxhnTyNrT+0blnUsLunK7sMerRGUSSQ0zeNBJCw8=
X-Received: by 2002:a05:622a:1aa0:b0:4b5:d70a:2245 with SMTP id
 d75a77b69052e-4c073ab0d34mr174036401cf.77.1758553096737; Mon, 22 Sep 2025
 07:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-9-pasha.tatashin@soleen.com> <20250814133009.GC802098@nvidia.com>
In-Reply-To: <20250814133009.GC802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 10:57:39 -0400
X-Gm-Features: AS18NWDigaezp8KdbFsh6YfrVI9s8S_j72gr5tDnCBaGxghJTTvfOltyGvHBbhQ
Message-ID: <CA+CK2bDDo7xVxFd=-vkkXuUyStj9ShmURmGNPkMyJvi96KrV7Q@mail.gmail.com>
Subject: Re: [PATCH v3 08/30] kho: don't unpreserve memory during abort
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
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
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8ystw86ciup4rz93akmhaedr1rkpn1ks
X-Rspam-User: 
X-Rspamd-Queue-Id: BD689A001B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758553097-217182
X-HE-Meta: U2FsdGVkX193JY7EVJkNljnDsAS3dNmuS1IFMOwisFd7iCF1Xt6tI37Oqy0eXRrv8jL02YZPBOyM5TTO9U+wok8/Q5IdnmZJjmd+Z3U2yyjx55W8RM4B0++ZDXe36n2BNxMuPUgi6a6MDgs4lCcnV3Z6PLsbt75Q0/Q9YlgEv/jGKkHiA2NOmVEb9oSR+vFoc0ajpsAlaiAqjk5EjjFwGioF0X7XjRYhDFBagffsR5Cu2TUXvKh7OsxWDWtW9e6SrX4y8CFUXq9BJFkTEcb/e+Ar6HnXOcHHrAmIH8J6oBnuD0aUua7nsIw+a2BazL8dy36yP4kehYGFQ3VOPT2jOd8jaBAMYgv0X0ZFq5Dz2ZRWsoj6RWA2oOzX+KQXxuokwazpt5UeD3Pretui7nYa582mtY/AOQul8/ni4iheQtZAIj+PbMH7rNgSyAii3W6n0iKulgm+EltSkISVvodOvDhWZFH5R+KG6VpFTwDtPjSMnSHyofO3Vvl125WZZis8Jx+tLBI8IGXXLApPKIYcRhs7GMlYlEgxmGU5Uiy//rI9MIPCd4Y3FR35Ghj291eizChbJXQ0jlw0z3itrp8jpr0zDyHKvAhmNMUCPGUea4T+lX6a4RH9RE/wdTdWQARzRPtHvtCTVcpoSCLx1PfYkvCpPSE5ZILGoFIVZ7tcPh/AYHqrj+KOfTqMaTRiEyXRujxmX7+lUY/b44f+67kp03kgLJrxVky+pPQite8J5fkPDQOrbreYMa1FvEx3dpCQ8BHmpt+aZunsAgrXVBnUaQywPG8LONvggoTuj257SULA4io6tU30xNY3Gv9GFUykjCj8Iwv6WawIPaqy0oOtFhic148Vff53ETWIXa0B81DYRURYie6qGAP1DkWhT9xMs8dcW2EHWQqbHyEHGR0HmDbl6P7tdbYSNbvdZSzxFldnAQCGkJnJjMCmZ/lTbFGnMMoPeCr5bLjjR3KNbRY
 mTLdWXD8
 nDFHNOi+TCYzNUfegx+V1ITDAmW9tU/ctF3CmMqetuyRPbbOnzFPwNZOyvXrmY4KZeVfu3hAp1pw9tGDlxlmEjnuFT8p+oqPz1jOstjF5umV6FO3CosdBSI8MdfPsxMTmv+WiGrboNWdULWfRQYDQobjEzzwPJp7Nz00CkNL3bgkg/hGUqXEg1pnncC6C9M+PmJG/kpHglMOXJ4vqxJWOCthdOUJIldhnPHSxfICXX4V6XIGiUlq5R0TXVKhs5TltY0Nf4nqWjkH72G+wObj2RRD8WoUhUNrQllSH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 9:30=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Aug 07, 2025 at 01:44:14AM +0000, Pasha Tatashin wrote:
> >  static int __kho_abort(void)
> >  {
> > -     int err =3D 0;
> > -     unsigned long order;
> > -     struct kho_mem_phys *physxa;
> > -
> > -     xa_for_each(&kho_out.track.orders, order, physxa) {
> > -             struct kho_mem_phys_bits *bits;
> > -             unsigned long phys;
> > -
> > -             xa_for_each(&physxa->phys_bits, phys, bits)
> > -                     kfree(bits);
> > -
> > -             xa_destroy(&physxa->phys_bits);
> > -             kfree(physxa);
> > -     }
> > -     xa_destroy(&kho_out.track.orders);
>
> Now nothing ever cleans this up :\

It is solved with stateless KHO. The current implementation is broken,
dropping everything in abort should never happen for stuff that was
independently preserved.

> Are you sure the issue isn't in the caller that it shouldn't be
> calling kho abort until all the other stuff is cleaned up first?
>
> I feel like this is another case of absuing globals gives an unclear
> lifecycle model.

Yes. But, we have a fix for that.

Pasha

