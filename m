Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468F2CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64C08E0022; Tue,  9 Sep 2025 11:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C0A8E0003; Tue,  9 Sep 2025 11:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952178E0022; Tue,  9 Sep 2025 11:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 841028E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:40:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 357571A03A6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:40:59 +0000 (UTC)
X-FDA: 83870125038.03.A1EAB0C
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7BE368000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:40:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RiFh2ERb;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757432457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRWX0gy62EFsM5r2pNvxcPyoBc+pc5A2tLFR+LFtsLM=;
	b=OtbN8/zrCclon0pqKWauPAEF6BYteXNjNndPYqo9Fov8Lx+c8ujk7AuqFjNPz/sbvmmaM0
	He4ps9GKRmLZb233RcC0eVrbw50q64cK4ijb33Nc+akt0+beYgOr+c/RVqluJJQTC2d63J
	pGSbGB3hviADkJ/g5qi0bWH6J5XtNo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757432457; a=rsa-sha256;
	cv=none;
	b=5uxs2a3lLjuHi/UDDVBs6dTv7fq/CEtL6ITfZOCdwjd9AgYlHfjmqjni7t8DsKPX/3Ir0G
	lQDMdAB+T4fqqV1zkVab93S+oYEIb3/yIem7rT6BrwHBIhDr+cwNLaugtNlCogT6G/rn5Y
	X+KJcdcuyILD9liUl2m2nljwoKiuF54=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RiFh2ERb;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b5fb2f7295so29619301cf.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1757432456; x=1758037256; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRWX0gy62EFsM5r2pNvxcPyoBc+pc5A2tLFR+LFtsLM=;
        b=RiFh2ERbqiunzrN7kl0iLzwDqfj1tw9Ha6BXGsZjJ6oN/Pv3skocZ9Of/1QSULPx8h
         YfFXFgmlf3momjLgHIlqCnbuSefWqJFRiZufEwX6WNPeDEwawwWXfAuTqnqIUxf7FHTc
         0ei7nBmd2y6gxvoSMS5joALpR4gQZ+CpJnIIOkkA5x5VOTdzao3PRIrMKnzvyaMvzjn8
         OAQDaRNlmtGOUAJAgOIHPKY9sBdFrQK35HY1Nd1VWPAG9vLuW+NsENSI3ckO/x1pQI3t
         vXlruH1kI9aoIJGK3HR3wPlcdF/uZ8dHYr8sfF2M3kgh0e7XjLoqSawl3SYgev0vuqe3
         GIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757432456; x=1758037256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRWX0gy62EFsM5r2pNvxcPyoBc+pc5A2tLFR+LFtsLM=;
        b=Mb5SDr5e8zx/x5c8ox2nKXvrgTOZyUytooCREaFL3feeeKVpK4yWO85NXHSuFtOUjZ
         QSw/fwZY3OR4d57DxY8vIxXLR28cTIA2AM1h8TB50i4o64V7CclDRGxRY3AD5iQqff0C
         Jo3kPZhadNt1YLmm4nmvck2kMIDRO8gNW79vUazxaXlhlMXnkJS0ll6pNF3d8lAt9VjD
         XnkyPpto8LyS5i2eR+5AxWOMg29J51rZMLSfZLP1ZSdzEXmBiXkoFUU65GTgO5B202MR
         y3ufGWNgi/9nPH3N3P1X9SE0ewejWyGS1Ds+EqesgLz0NWxI8y2UCla/Ez65R+kDoYU2
         qzOw==
X-Forwarded-Encrypted: i=1; AJvYcCWWy36sA2soyphFk/G4bMZ7FMkyqBjzzD87vQlUKC29TUK+9JMyaPEiALJubLokPtf643IxbB4dyg==@kvack.org
X-Gm-Message-State: AOJu0YznZyjuPxXm6KgYHHtXOzywFMak8RNFZjlAFhUPmW2EGw/15hhJ
	LxsTGbxNYK5opsEHbaKcxjjo6u30n+CZP6m0Nv1jIs8miGRIifKtZM7wcQoAySszdfBBTmQVuYe
	XnnyLvRR52XMapUGuybqzajus/vg8RFOqa6/iQPegjQ==
X-Gm-Gg: ASbGncvxqqLctJr72dzAfJFhuN2XugdD0JmHkEfIIv8xRa+VGd/rJrX4CpE3mXkqbRD
	CsXIQejWCXZuUVK3r7TlylsfCbqWtPI8mMdy4ztW2/c07vZXYeWbKciuNvnfIELweFMewZJXsii
	znKlSiRfrzN5YDJua7fjbOO48jOzGu964LN6TwHXw8GM6KirABS3bTDayhGoBb+2PiH9kO4Peoq
	+3Vh8ANoQCCrDs=
X-Google-Smtp-Source: AGHT+IFIyhmzGWFTrUx5qTZBLu9qAAH3OqD11kjv9JWMaCvsLsEFvRfp7eNadU4BDO41Wf/Ch0HESERQxsGjvKdRSzY=
X-Received: by 2002:ac8:5d4b:0:b0:4b5:ebe7:ac16 with SMTP id
 d75a77b69052e-4b5f85694b2mr112159801cf.58.1757432456172; Tue, 09 Sep 2025
 08:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <mafs0bjo0yffo.fsf@kernel.org> <20250828124320.GB7333@nvidia.com>
 <mafs0h5xmw12a.fsf@kernel.org> <20250902134846.GN186519@nvidia.com>
 <mafs0v7lzvd7m.fsf@kernel.org> <20250903150157.GH470103@nvidia.com>
 <mafs0a53av0hs.fsf@kernel.org> <20250904144240.GO470103@nvidia.com> <mafs0cy7zllsn.fsf@yadavpratyush.com>
In-Reply-To: <mafs0cy7zllsn.fsf@yadavpratyush.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 9 Sep 2025 11:40:18 -0400
X-Gm-Features: Ac12FXxeog2W-sndMgfE-Kiuw70lrrt6PwppqWI5s8CYKqzXaWa3HgK79sNYiwg
Message-ID: <CA+CK2bAKL-gyER2abOV-f4M6HOx9=xDE+=jtcDL6YFbQf1-6og@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Pratyush Yadav <me@yadavpratyush.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7BE368000B
X-Stat-Signature: drsnbadazreqk1sb8fycb8s3si4jg8zh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757432457-930172
X-HE-Meta: U2FsdGVkX19CMdLeXfWf9YfckgpLCv+XgTlUSauPjLOEYAFNO43iGW7unAn6ikTNexUpP3XsI03Za/PhsML3/2ZiAHUMSE071dO6F7dWp6qUaqtPZoaRYoUYEGiL11ygkfq6PfkstKdV2Bppw9bfmzY435Lq38ZvhZHe5J7Nsg08CpNrtuo0GxWftUCt4huDhGhkiVOJpyxsUPD6fgHF3mx5D35+A8MLNOtXXxaICaRnvtZS3P2TMRwaKoKYHZY1rOmFd7GQMQU4gHjQI9DpArvbUUjqsB4xoxoGry983xP/MUkmzvp6O4JfPetROOYqQBgmkeuZZ8faETiwW2LCs9mZdxKkEfQKhadhbwq2vpxPBLj+pSqDvL6Vqtvr9Mx5HWtZW+r5mdjMqLrq5Ihy6P7BKq8sP+L6HWGPz8BvD5jTMuXAKxyRLmbkJMP+0Fd1r0sBkh43jYgB4Bnaq374BSah2HpWNDio8bvd9FWQ8VM/KkVR2KKsHuOwGAu55wQUzV9s4XAb9DR2Wm2BgmOOQrt5P3rqNX0Vu9xYotR8qKA4WEBMttoZYEpujtahFdiQ1/6GiynQRZlCvkQCBbHBM1Z/7YOVxQHWz/Zp3wwccrRFrM5rEY3y7d/b1lHi5zcQH9qTq+5N97byewk5GWdaI/71hQ3gj/jUHP0ANI7fgFPYsnlrUb8rpFej/3ljSfIb/jPCH7zpbOToh49HY2j9b9RcfAkAa7A5v4XcORC4aRsOOh2veSyOe1hPxEltNSrFhECqhTnUbPUqi8k1YPX9tXZskNhwOjEUlcWO9scL053jsQO+zjwClbrnyVp0zcNAaSVTak4tVcQVS2tB6P6fQzLl2qMXg54VRPSab+JJfSjOUnQi4B8WQEMPcN19gVTPNSurrBolL6NBkTHzM9Dxa+w8lHR9nACz/7LbjtgsAgO3fRvDYGEeneijZd461YuMCJxYrQDo11UhrXl8H/2
 Mf3kvX9s
 G0StZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 10:53=E2=80=AFAM Pratyush Yadav <me@yadavpratyush.co=
m> wrote:
>
> On Thu, Sep 04 2025, Jason Gunthorpe wrote:
>
> > On Thu, Sep 04, 2025 at 02:57:35PM +0200, Pratyush Yadav wrote:
> >
> >> I don't think it matters if they are preserved or not. The serializati=
on
> >> and deserialization is independent of that. You can very well create a
> >> KHO array that you don't KHO-preserve. On next boot, you can still use
> >> it, you just have to be careful of doing it while scratch-only. Same a=
s
> >> we do now.
> >
> > The KHO array machinery itself can't preserve its own memory
> > either.
>
> It can. Maybe it couldn't in the version I showed you, but now it can.
> See kho_array_preserve() in
> https://lore.kernel.org/linux-mm/20250909144426.33274-2-pratyush@kernel.o=
rg/
>
> >
> >> For the _hypervisor_ live update case, sure. Though even there, I have=
 a
> >> feeling we will start seeing userspace components on the hypervisor us=
e
> >> memfd for stashing some of their state.
> >
> > Sure, but don't make excessively sparse memfds for kexec use, why
> > should that be hard?
>
> Sure, I don't think they should be excessively sparse. But _some_ level
> of sparseness can be there.

This is right; loosely sparse memfd support is needed. However, an
excessively sparse preservation will be inefficient for LU, unless we
change the backing to be from a separate pool of physical pages that
is always preserved. If we do that, it would probably make sense only
for guestmemfd and only if we ever decide to support overcommitted
VMs. I suspect it is not something that we currently need to worry
about.

> >> applications. Think big storage nodes with memory in order of TiB. Tho=
se
> >> can use a memfd to back their caches so on a kernel upgrade the caches
> >> don't have to be re-fetched. Sparseness is to be expected for such use
> >> cases.
> >
> > Oh? I'm surpised you'd have sparseness there. sparseness seems like
> > such a weird feature to want to rely on :\
> >
> >> But perhaps it might be a better idea to come up with a mechanism for
> >> the kernel to discover which formats the "next" kernel speaks so it ca=
n
> >> for one decide whether it can do the live update at all, and for anoth=
er
> >> which formats it should use. Maybe we give a way for luod to choose
> >> formats, and give it the responsibility for doing these checks?
> >
> > I have felt that we should catalog the formats&versions the kernel can
> > read/write in some way during kbuild.
> >
> > Maybe this turns into a sysfs directory of all the data with an
> > 'enable_write' flag that luod could set to 0 to optimize.
> >
> > And maybe this could be a kbuild report that luod could parse to do
> > this optimization.
>
> Or maybe we put that information in a ELF section in the kernel image?
> Not sure how feasible it would be for tooling to read but I think that
> would very closely associate the versions info with the kernel. The
> other option might be to put it somewhere with modules I guess.

To me, all this sounds like hardening, which, while important, can be
added later. The pre-kexec check for compatibility can be defined and
implemented once we have all live update components ready
(KHO/LUO/PCI/IOMMU/VFIO/MEMFD), once we stabilize the versioning
story, and once we start discussing update stability.

Currently, we've agreed that there are no stability guarantees.
Sometime in the future, we may guarantee minor-to-minor stability, and
later, stable-to-stable. Once we start working on minor-to-minor
stability, it would be a good idea to also add hardening where a
pre-live update would check for compatibility.

In reality, this is not something that is high priority for cloud
providers, because these kinds of incompatibilities would be found
during qualification; the kernel will fail to update by detecting a
version mismatch during boot instead of during shutdown.

> > And maybe distro/csps use this information mechanically to check if
> > version pairs are kexec compatible.
> >
> > Which re-enforces my feeling that the formats/version should be first
> > class concepts, every version should be registered and luo should
> > sequence calling the code for the right version at the right time.
> >
> > Jason
>
> --
> Regards,
> Pratyush Yadav

