Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB38606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=E2Qm3wMj
Received: by kanga.kvack.org (Postfix)
	id 400F96B085F; Wed, 21 Oct 2026 23:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B336B0860; Wed, 21 Oct 2026 23:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22ADA6B0861; Wed, 21 Oct 2026 23:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E00F36B085F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:32:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B859A8299
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:32:58 +0000 (UTC)
X-FDA: 85348840836.26.562DE16
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id E21D61C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:32:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E2Qm3wMj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792639976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
	b=jllJVIuvT6rKdTr3ZdmrzSx9uq552hn771cVQdTxnTYJAgxCtRd/SuUewQFRxO5eGawFjc
	9H9pavUmywrBhsVNek02NwjtGSEj/cUXNHL2GDNK+EDEjcdIWe1IWmdrMLDtq1lfNQi7qR
	B6F4mWWh7qDNMDB4jOztl+I/15qUeUQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E2Qm3wMj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792639976;
	b=ODKSSgcq67pxkLBUlaNRMbXIXBEjVlzPqSLFu7rnr3pQ75OK2lTa4QCFahGiji7MF9nRhu
	UYMv+yRR9hmgbt70Gw+aOTQeeTNCQnXcc8RoqeHGbw5Pz9SGiwPxdlNIg1AOjGl2f0KMUq
	iv2ybuYR7+uJ25WGsMHScWHFLy2rwQg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso1125830a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792639974; cv=none;
        d=google.com; s=arc-20260327;
        b=EFZ+6msm2B40ML4kBBwbolqzmiXwL7HfZityl48Lp4QbYQcy7ZtkFdrRLekupywCxE
         8g5nbXOZsnylPox7AbzyKvSbe9JQYfyYk2jIe/tyM6Xhz5E+uYJc0AUvOb5OH2g/QllW
         WlUHTk5P+ciKR7rYWTBkDi+fYQCuy3hF6O0kOziw4cg27Uan4ge+09a0CulaXRFP4pW6
         4N0f2UjVK0vdcgiOlBW5uVzdcvJPJVyoI+oN2bkWe/W1lOiV55aua+MAj/kIoz1YM0oT
         EpJzpvZ5ADBAS8BzW+G3zf73YV95PD0fOPUKdzIUZpE6cl4MJJsqfQX+KeDR48m0re7A
         bN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
        fh=J33jm9fFEruXVBP1RWTWopRUGo09wTCBq5TieLj/li4=;
        b=D7ssWXQf2OpUcd30O7KF7U9/c+BDlluozE0Dsec1tmvGxEt4uoqUz3eMxu2GeaeOHc
         2iPuxNUpwkq1AjpFrTKFxJEtMua0NS6quKEGZRskLhiWRPI4ClbdqIzTiAc7nsc5O4U7
         3y1THkdupnxVWPf5A5YmCVLpvLj+15h+Hy0a9IVKwvGzEOPl6HmzukG6fL9rpB72dTfO
         FdiDc1a4cWUDbJKfQME6ixj82ZetfJ7QIL/8mQrgDVOagPcjXi1cenXZ+y1InSWlTNlQ
         fwbQtg4eh5+ySHzoZoXzs6qszVfdSAbRI8HkO7A4nRQ2YWZEUSUKSpgwwbvIJ/YwG+uX
         yw/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792639974; x=1793244774; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
        b=E2Qm3wMjXBuIu545sb5O47f0zTT68wBumPJhVtxsZdspVi5Ehnpy64LNv+rjMQKFrW
         NE22RwlXoXs1s4SsPteAItqMB5xk4Q59flsVbkarDjz2bzXcakc7+GOUVViKgooXyfbF
         FC7AJNMi0fqAZTOv06pcL+RHZNUrNnlEV/4wRjyqNXO78JwAvokgJ0DI0j6H6viS5fNe
         trocpUtnahKAI5+MMThloYFgcxqE0dA+pQs/cuns4AgQWOffCLXU44QlbjGycgVxiJMc
         vc/T1lONQ+jhcQPJp+KreiwjnCccG7ee468L2E02ER6FWwjRV9PjanV+/9JVJEcrtzig
         5PDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792639974; x=1793244774;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Un0pCsebAGgOHU5j/UFuxo61lM6ZZUr6aOfHjWXDb9g=;
        b=x4BQT68FWmq0Y5ZWtP5fveNhoF7J0eNELLHC5vuidlfE6XzHmIjCl5lO2f0TDxJ+eb
         JRH9mhTDsQiydyG/ldfkTcvdf7Glu4fa8R3P+u80WID2PAtV40nF4K/kJbAM/bToZFpV
         96OVFngqK0i5vIwe9DzpYySpAmPnEgWqv2N8/pFO56JCaUpND/Fx3Fo1JDnTJSTGX6eK
         BPc4XEvALt/Vwj6/IwQNL0CRFfXxc5j4obVVLR83XDx2bVBkTlJPIp98Y1OIQ9MYXHrp
         t8yIO0nIf6QtsN7YhthqWccJI+2DjPqwc/u7oB2KR21Y8B1QaE1u1UOa0jbW5I3O5qFd
         5A7w==
X-Forwarded-Encrypted: i=1; AKwUvBwKZC5vxP9cmuyldvEcpfe2hpts1+Tg2Bmxvkb1Jo/wdGKoZ8Ixv6niNqc0e6Zny3SEdQfbtL5lfQ==@kvack.org
X-Gm-Message-State: AFq9FYIq0Md83ySLTI4U6dGFhF1huIR3e2HXbdGCpCOrkGeHXUhKiWlS
	aFNpVvTO1GdsuzYHTCNXQp2gbp0fYD0NhmdjvdA7A0hOfpIu8YxpY4prLR4ihwkLy0t2V8mYZgt
	YyrSK9GlWI/TSHvyunOpdHH0ymW3CJDi8M1F9myJQ3Q==
X-Gm-Gg: AYBFou231btGGod3RPgvMOWUnQ8m6Xf6yGOhFQO4ddgTeA3vltKpnvW1sSCWvx9RP4V
	PaUoabHgupD+5m5PpeR4TRD4kSOQ5PRClIuE7q8QQATpVP2m+BqsaZD18W14SiFsPR0uVHZjm9m
	QMmBq+LU7KmSzseK6QoR5AWFh08GJz4krBu4yrZu4HxmB+g51t//VpBZBFrSly4ZDYLcmHGk7c1
	Hhbyy2Hq5nxkoAW3N3UGbdDmOlkzGz+Sluk0rR92/O/XzfCe6GFIB/HROvmdd55QxwcSurAnyX7
	wEYveuZPBS3VfrES/uni8ymebwszVFOeK7779Df4jjBwGk77oOBMRXU4nkHhLD1FVvv6D9E/Zr4
	Dh6LrBhpdtgp70tchAxOHqtzK1UAZLEbOuqrxUlCxj5jwmN80ZBqmxtL88sfIxjpdssjc
X-Received: by 2002:a05:6402:2355:b0:6af:d794:4a8 with SMTP id
 4fb4d7f45d1cf-6b41d595e9cmr1157408a12.12.1792639974111; Wed, 21 Oct 2026
 20:32:54 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com> <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
In-Reply-To: <atl7peoVHdP5hz7z@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 23:32:17 -0400
X-Gm-Features: AclHuK8_AnwdTvKegXWFQaKFyzs_ctZH_O_1uRYIa-PRh8yAhLXciiK9Gp-4xIE
Message-ID: <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E21D61C0004
X-Rspam-User: 
X-Stat-Signature: hqua9bm6yn9nsd5f5kxsdwr35waz9qa9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792639975-106322
X-HE-Meta: U2FsdGVkX18SJNVUcqZTnsxD5RR/kyCkBnutKgFGK9VU1e6lfYHU7QbjrpXLDH/z2AMrEFaqBP9QgEI6/TAyZ+8KI0bfyDrGPImc5+/xQ8sLt3LvQiBoZAvwd7E6ntJBwNHK5igX9ZICPWGH0iW0yGi/CTusvhQqyuOF+zFi9u+TOS3HF/ttlb7g9hVuXFQq6Ke5bRBhMHvsmzY7RnCNUgfvUhGpPm2UaLdagnOUeawui+Bwhdn0kKW8b1UvnuZodNfv0JH1C3SzBOD5Ynv1xhWEtj/rWNs1lhXvwhXjf8zyAOie6OdqkW/i0c5LoyjoSTHx4+PqefL3Mpaz0P2YBoJzthW7+dI6+Kt/imQ7o6mV/5MEPz8fvboJ2+RiyokbAknJBbjJLAm/nhEphtFW1Kf+yxe8A+2rb5+8ITe++hGp7i9KhDU3HQYeTTDCyVDNEHwX741O1KQN7U+18ACv1/Ns9ZAJag9Y/ovzsedY4vOcHWzPPjbCLsciPhIOwzAl2YJReMIZaNuWxZA9MWVE/LR5B+Tt3kCXcOEBiOmNWOm71jg23THAQMqpbbQwuyl1XVT5vc9mFIZnsOGffvyBrN9XP+1qeaCBGX3c52elnnynoVxcVXF07KJBgUnQ+tpGMUblr6ky3oX2fJ8cMgc/F236wdgvDStHqWIoSVuu4ykxzi1gO26t5Gg9T0daSBpRLuE7GhSafTFwAQ9Qcgj8UlKtnhfLLfQPXR0eQ575Rz4FmqQE/j89i7YtPhLB9riqMwYDys4MhCPzGhKRAlfXgsMoIkKG3AWi2Z41GQW8gztQKaZOp4SnnpYgRZh+zVuM9+rK63XhKvOhlqTmT6gZn3IHK7AlY10AFNqi3zWhvabzjVxWTTNwrVyllH5i6vWr4BArajM8rqJ7F66e8x70mS0GalTYC9/wEZ2v4EacZE+PbbFoKAbMKGVSUXSwqB95skSmuMGCafNHQORqw7X
 h6v0C8kE
 KWkwEO30fsiW261pajbJnWUklcdAo/PvdP3suRDBebX2YT/0+a2ul08SFEcvxIuxdRsR47Oi3AtN8vWsjxm0ntVHYL6aLXvdaSpAnffJk/a3reyt1s5gpGOCPrZS2U4WJ+X1AJOVNEDf2t2O4FeWaHoyV/E/gAzylAosdAMcmwgsbmcXz3+2l1aWA+Mvi3YKzpPTX1TFSJ75rcDu1l2vJyV7lLCp4mY9Wv2lEFtQDLc2W++ci2PmCaIrRCXLeG+AuVOGijmgcQnVGlgL6e9W3K5cj8NOe3ifDODOP1ajnzYE/1G1lJoLtEu8MadWYw9HWdxyQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:57=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 7:28=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > > On Wed, Oct 21, 2026 at 2:47=E2=80=AFPM David Matlack <dmatlack@goo=
gle.com> wrote:
> > > > >
> > > > > On Wed, Oct 21, 2026 at 11:40=E2=80=AFAM <tarunsahu@google.com> w=
rote:
> > > > > >
> > > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > > >
> > > > > > > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsah=
u@google.com> wrote:
> > > > > > >>
> > > > > > >> LUO and its file handlers validate handed-over state with mo=
nolithic
> > > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to =
a serialized
> > > > > > >> structure, even an optional additive one, must bump the stri=
ng, which
> > > > > > >> breaks live update between adjacent kernels. Replace the str=
ing in
> > > > > > >> struct luo_ser with a feature header, so that the target ker=
nel can
> > > > > > >> accept or reject the source kernel state per feature.
> > > > > > >>
> > > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the seria=
lized
> > > > > > >
> > > > > > > This patch is all wrong; 128 bytes is far too large. For ever=
y _ser
> > > > > > > struct, we only need 8 bytes instead.
> > > > > >
> > > > > > NOO, It is not. It is intended to avoid complex mess with unnec=
essary
> > > > > > over-engineering.
> > > >
> > > > 128-byte per serialized struct is not starter.
> > > >
> > > > > >
> > > > > > >
> > > > > > > The first 4 bytes are the size, and the next 4 bytes are flag=
s (i.e.,
> > > > > > > 30 feature flags + 2 reserved bits for flags extension). The =
last two
> > > > > > > bits of the flags indicate whether an extended flags field is=
 present.
> > > > > > > Each extended flags field is 8 bytes, and its last two bits i=
ndicate
> > > > > > > that yet another extended flags field follows.
> > > > > >
> > > > > > If we will have dynamic extension of flags, Think about this.
> > > > >
> > > > > To support dynamic extensions in a backward compatible way you wa=
nt
> > > > > something like this:
> > > > >
> > > > > struct luo_feature_hdr {
> > > > >    size
> > > > >    flags
> > > >
> > > > __u32 size
> > > > __u32 flags
> > > >
> > > > >    extensions  // offset of first luo_feature_extensions (or 0)
> > > >
> > > > __u64 extensions[0]  --> but the size should be specificed in
> > > > declaration macro that I showed in the next patch.
> > >
> > > I think you may have misunderstood what I meant. In my proposal,
> > > extensions is an offset to the first extension, not an array of
> > > extensions that immediately follow the header.
> > >
> > > If the extensions immediately follow the header, then the number of
> > > extensions is baked into the struct layout. Every field after them si=
ts
> > > at an offset that depends on how many extensions there are. If we eve=
r
> > > need one more extension, all the fields shift and old and new kernels
> > > can no longer read each other's struct. That is the problem Tarun
> >
> > We can structure it cleanly by nesting the payload: something like
> > struct { struct header {...}h; struct serialize_data { ... }p; };
> > That way, the header can expand dynamically at the front, while all
> > fields inside `serialize_data` stay at fixed offsets relative to the
> > start
> > of the payload.
> >
> > Since the header size is self-describing via continuation bits (e.g.,
> > the last two bits indicating whether another flag word follows), LUO
> > can
> > easily compute where the payload begins in the incoming blob. This
> > keeps the implementation simple, avoids linked lists of offsets.
>
> Oh interesting. I agree a dynamically sized header at the front can work
> and is simpler than a linked list.
>
> So the header and the payload need to be separate, and the payload is
> located with pointer arithmetic on the header. For example:
>
> struct luo_ser_hdr {
>     u32 size;    /* Size of the payload in bytes */
>     u32 flags;    /* Bits [31:30] indicate an extension word follows */
>     /* u64 extension words follow while the continuation bits are set */
> };
>
> /* Size of the header, including any extension words. */
> size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);
>
> static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> {
>     return (void *)hdr + luo_ser_hdr_size(hdr);
> }
>
> On preserve:
>
>     hdr =3D kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(*ser=
));
>     luo_ser_hdr_init(hdr, sizeof(*ser), ...);
>     ser =3D luo_ser_payload(hdr);
>     ...
>     args->serialized_data =3D virt_to_phys(hdr);
>
> On retrieve:
>
>     hdr =3D phys_to_virt(args->serialized_data);
>     err =3D luo_ser_hdr_validate(hdr, ...);
>     if (err)
>         return err;
>
>     ser =3D luo_ser_payload(hdr);
>
> What would size mean in luo_ser_hdr? The size of the payload or the size
> of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing so
> maybe it's just the size of the payload?

> What would size mean in luo_ser_hdr? The size of the payload or the size
> of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing so
> maybe it's just the size of the payload?

Either works, but having size cover the combined hdr + payload
provides a few extra guarantees:

1. A single static_assert validates the entire serialized struct at
compile time, including the header and the number of ext_flags
elements.
2. Bounds checking while traversing the header continuation bits on
retrieve: we can sanity-check that luo_ser_hdr_size(hdr) <=3D hdr->size
so we never walk past the end of the serialized blob if there is
memory corruption.

If we declare the payload struct separately and pass it into the
macro, handlers also get a clean type for luo_ser_payload(hdr):

#define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_type)=
 \
    struct name {                                                          =
 \
        __u32 size;                                                        =
 \
        __u32 flags;                                                       =
 \
        __u64 ext_flags[ext_flags_count];                                  =
 \
        payload_type payload;                                              =
 \
    };                                                                     =
 \
    static_assert(sizeof(struct name) =3D=3D (expected_size),              =
     \
                  "LUO struct " #name " size mismatch!")

For example:

struct luo_memfd_payload {
    __u64 pos;
    __u64 size;
};

DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);

