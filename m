Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F23ACFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06966B002B; Sun, 23 Nov 2025 13:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7196B002C; Sun, 23 Nov 2025 13:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5CD6B002D; Sun, 23 Nov 2025 13:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B38CB6B002B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:24:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EFD5C015E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:24:31 +0000 (UTC)
X-FDA: 84142697142.11.8E97050
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4651A40008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:24:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="DZXqAed/";
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763922269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFe56QyFLZ7C1O66/b75IN12Xd7/FCpS86VjcSFE1yk=;
	b=OGZt1RBvXeeBxGtU3MmmxIb1UuIp3oNWB9XjBVQCBPyVagd58u6di9NDr6/zv8yRn3Mhhl
	wdtfoP18Ld7OMBBLFSO9iVY7dHGMGU6fy8G3VnyesWQIphS1BaPXzPFkn/cC3h4c6fMqfL
	7bZi+FwwUWv3d0M5Cw1bjvoFB4QQwn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763922269; a=rsa-sha256;
	cv=none;
	b=0dfGWacSjCZludoZI9YsfS/VMyRYK0xtCoiPj/m18IzY1wPFPNOKctJ5C6VWUJp8TU0cC+
	djY4UmlxhjshIMA1oq5q7WbpshdgUE0DkV+KtWAGXZzwx/6Pi/R4tyuzDlSj5b+W8UFR3r
	lm6kKS3BfJ6pSg1s1Q8zcAYUD0gT2bk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="DZXqAed/";
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so5674255a12.2
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763922268; x=1764527068; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFe56QyFLZ7C1O66/b75IN12Xd7/FCpS86VjcSFE1yk=;
        b=DZXqAed/bqLvRqLL5SNXyV46JAnQzu2nR4KgcQnOL8SZVJjV2VK7o0gYuVNAZqIxpl
         CpBodhjkw2D+fa8f6VDDwR6l0f6y+p0QsqhrYg6xlcsSLVZ1B8kFGPGVPf3Cl52Ih2tp
         xY14M6fqWPcdXgps1l5clG/vE1UElMBACPXdvCx4BcU6mF3/xRAVeijh8YAySGt+Fxtj
         X4wu5gPgQk3hof/MdwoSysZK8aT2xXmRwYdOBbZnXhiDvE5P15BPqsdHJM7lcmvhzSV/
         9ssDyYn/CZFfi1goKpQWUd1Mg3ZhuhbAhImlz6997O+AhVM04e3o+E5QkFFQCyZ2LtNX
         WkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763922268; x=1764527068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HFe56QyFLZ7C1O66/b75IN12Xd7/FCpS86VjcSFE1yk=;
        b=bBMyoP6cQvoHgfT1K260fuoBR9X6J3UXOo1M4pIMaEYaJFN7CGk2Xp2qqRZNeDFPs3
         I53+9S+zHTpBX4v2uVXkTyfcnlCJILhg31q8xkAHJ0kNUG1dWWE1RTACMCo2jBmkV1qt
         0z0SiUUlIywVE9GMo0wHN+rRbunVaGBhJPlUNK+28Y7Jr3BsaOVwSYplUmYFRpU7eCSR
         707nkHNzjPMSGen5DrGcjjlJ1auolpssjgRMJLxcu+Hlr4hIKzqd9Q/i7/5Bau3gqRL8
         4K8TaQ8OfB8RCACwg/9qHXBIBu8CrqANRDKBcH9cOM7Z2M7yohEqBgTKnayvlLxOU3B1
         Lk0w==
X-Forwarded-Encrypted: i=1; AJvYcCUnnPSpSAVa6AgBhXKH3JVCuqF6fShJ81Vt+YwCIKpNehhHXN5dy+c00u3rzempZrk6y4PcM9tEnA==@kvack.org
X-Gm-Message-State: AOJu0Yw9qZ3F2SJjU1GqDe5COV+VMVS4vo30MhhHc8eukLVEfHphXcCS
	Fh9R9c6TKt6AWSXVwxP3ylAkYQlfUCeq3VTOEtfE77SApZQBH+z8NWcpeF9UDip4KQPxK+LlaH7
	Jaapa5atrBECB2F1p/JagBunnXmjF7kPeopPEGc6qxA==
X-Gm-Gg: ASbGncswKuX7Gicf8UD8GSY4zNhwLulusJ2EMYMyeF8NwoL9Qxd4sqS4PFmUYxa8mb5
	2CbxT5RYU1IYKPzNNs2TFvTTyiAqkrzJOXEO6TjWBvJkDbmqNnYiC/fGywwSvzb0wOXlBCn/cta
	6X2sY9uvI43nxEqAp1qAExSYBRHNSGllUHqJINivmwzPBe4wDVWiatSPSst37cOCj7GgX1HYoGA
	J51Fcj10hWlriGD/NThhqRGl1saR3c3O3jO8sW4xwzd2nG0pJjb15kOVJ0pLp96JgHw
X-Google-Smtp-Source: AGHT+IF8Y2WxTfuU5MKgGu/HRLPR42VugdjCMxiGE2PPrS+V8RKZs1QDvf+5KSflk2e8n9lkLkfU7mQyoaO5u4Z1Zt0=
X-Received: by 2002:a05:6402:4146:b0:645:cdc7:ed91 with SMTP id
 4fb4d7f45d1cf-645cdc7f149mr424897a12.32.1763922267598; Sun, 23 Nov 2025
 10:24:27 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com> <aSLvo0uXLOaE2JW6@kernel.org>
 <CA+CK2bCj2OAQjM-0rD+DP0t4v71j70A=HHdQ212ASxX=xoREXw@mail.gmail.com> <aSMXUKMhroThYrlU@kernel.org>
In-Reply-To: <aSMXUKMhroThYrlU@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 13:23:51 -0500
X-Gm-Features: AWmQ_bmZE4Rym1x6vlKRuOiWr1iby3GXQ6wajNbHf1G86dfGYpyZynlDRpPIzZY
Message-ID: <CA+CK2bABbDYfu8r4xG3n30HY4cKFe74_RJP5nYJeOtAOOj+OUQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: utrutba8axtta7u5kckfigm4yedepkz9
X-Rspam-User: 
X-Rspamd-Queue-Id: 4651A40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763922269-165814
X-HE-Meta: U2FsdGVkX19MNLAgN990WhtedS4J7jslXLvysdjLqy8ahtsopdnyU9AID5Q6OopuXbxiJCdNJvWIUEp4nRjrCOSPay9THpBKq2Hd+quh05pfVI6aNYjd1Pw9Yg4C8oVWt6DvyTGNds1lGYoKx6iwdtTDO0T2gESWQdE0tv6BgUSu/CZvc+LNYpuOasYf7SNBBNSkBrr4ZUEk1l/iUTx3wedx7AetkDNSLSwSxfWynfjMavYHIV6a54j7pk2OqXMxqrsAw/1OXBvV190zY0inUnEVUAKoNeGY9O0qQognd7ia4ADeHzLWuy+9SclwpKrWCAatSguFedVtn+FQfTGwnINfPGJbNIVS6ci3ivTxfh73UKBdhP76tiLua7tIkefHEcjeNIOYY37tAmLZiiwyVObhw03tkVPbfAB+txL+OTR24dVL85lNTJTHyCrgfbAFS8cS9fPOeyBPwt8RfZiSg3oMk85wGb9PgaI9nH0CKj/pY/whbVW51iDfumYZNRtIZSQC8Pz4zzkhBc8swigNkgO7WyzZ4EDpxFAPX1llkJ0PHSCi0e0dqwf5bhBhshFCfbO/P75Una1lYsBgs56fbyiBMPuFw+kdnrA54zE0WrEEXAtbewuT6TWG5NBiBUlIS1Lq4/HGNFXekZO9pZ3RL1QDDahvzpayieIH591MtKE1t/6qf4MV1JTar+LEq7dYoXDxUzFqro3UxpB91E4HKB4cElmsvjo47Mi0f3sOSH/h25Xxz4I2FLX2pMCOguHYlhoH61Ccwp+WGUxQHyf4OeByEH8zSPPegnqpd4aR/b563UPZ2ZqWvm2KOJR035QC1d7i4Q+RuIlJe7pUD/jorGqBW/mKhWdqI3I2Yta1uYxqNx5JRrf5ZOgPoKQdLdizG6mrFxDLALs+6kE27fc4S+zBYknEuE7xKKCBQO7j1PcuteWn3SXUV8HbB6xpOeCzA1tm8aHZdAg9mXK/Y/8
 1SqT13fD
 DjVzbDGwn4p8fl5sLbeSYlZDsxqw8ikepwzeRUGQYPGItybZ8HjfBufbOg6SuRQf5Oye7SlxedE9QlT/BQfE8/zLMomSAl1gEisebk8bzNbUWsnH6kS1Y8R6YK8Egn5afBzTRTjvfKygwdjTj7Nsfac/D8wuD13B7JA0RDuaiS5Skmgr2gQ/2F9fIjlvxYyt/JdqSdFLJuTeuai/KWyK0QqFIXxWdHvE1+1SJLQ4+5BGMxjkDbIYe+Iemvf1OwaPJE2j8wGzW/MxJlCSZB+RIuNcd6shAWcZp18rxGbctf+vfobcWjBCABl7ePrAWJMhXyPdeN41LIOhecoQD3gvbQOaC8naHyuI3Shd1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 9:17=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sun, Nov 23, 2025 at 07:03:19AM -0500, Pasha Tatashin wrote:
> > On Sun, Nov 23, 2025 at 6:27=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Sat, Nov 22, 2025 at 05:23:29PM -0500, Pasha Tatashin wrote:
> > > > Integrate the LUO with the KHO framework to enable passing LUO stat=
e
> > > > across a kexec reboot.
> > > >
> > > > This patch implements the lifecycle integration with KHO:
> > > >
> > > > 1. Incoming State: During early boot (`early_initcall`), LUO checks=
 if
> > > >    KHO is active. If so, it retrieves the "LUO" subtree, verifies t=
he
> > > >    "luo-v1" compatibility string, and reads the `liveupdate-number`=
 to
> > > >    track the update count.
> > > >
> > > > 2. Outgoing State: During late initialization (`late_initcall`), LU=
O
> > > >    allocates a new FDT for the next kernel, populates it with the b=
asic
> > > >    header (compatible string and incremented update number), and
> > > >    registers it with KHO (`kho_add_subtree`).
> > > >
> > > > 3. Finalization: The `liveupdate_reboot()` notifier is updated to i=
nvoke
> > > >    `kho_finalize()`. This ensures that all memory segments marked f=
or
> > > >    preservation are properly serialized before the kexec jump.
> > > >
> > > > LUO now depends on `CONFIG_KEXEC_HANDOVER`.
> > > >
> > > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > ---
> > > >  include/linux/kho/abi/luo.h      |  54 +++++++++++
> > > >  kernel/liveupdate/luo_core.c     | 154 +++++++++++++++++++++++++++=
+++-
> > > >  kernel/liveupdate/luo_internal.h |  22 +++++
> > > >  3 files changed, 229 insertions(+), 1 deletion(-)
> > > >  create mode 100644 include/linux/kho/abi/luo.h
> > > >  create mode 100644 kernel/liveupdate/luo_internal.h
> > > >
> > > > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/lu=
o.h
> > > > new file mode 100644
> > > > index 000000000000..8523b3ff82d1
> > > > --- /dev/null
> > > > +++ b/include/linux/kho/abi/luo.h
> > > > @@ -0,0 +1,54 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > +
> > > > +/*
> > > > + * Copyright (c) 2025, Google LLC.
> > > > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > + */
> > > > +
> > > > +/**
> > > > + * DOC: Live Update Orchestrator ABI
> > > > + *
> > > > + * This header defines the stable Application Binary Interface use=
d by the
> > > > + * Live Update Orchestrator to pass state from a pre-update kernel=
 to a
> > > > + * post-update kernel. The ABI is built upon the Kexec HandOver fr=
amework
> > > > + * and uses a Flattened Device Tree to describe the preserved data=
.
> > > > + *
> > > > + * This interface is a contract. Any modification to the FDT struc=
ture, node
> > > > + * properties, compatible strings, or the layout of the `__packed`=
 serialization
> > > > + * structures defined here constitutes a breaking change. Such cha=
nges require
> > > > + * incrementing the version number in the relevant `_COMPATIBLE` s=
tring to
> > > > + * prevent a new kernel from misinterpreting data from an old kern=
el.
> > >
> > > From v6 thread:
> > >
> > > > > I'd add a sentence that stresses that ABI changes are possible as=
 long they
> > > > > include changes to the FDT version.
> > > > > This is indeed implied by the last paragraph, but I think it's wo=
rth
> > > > > spelling it explicitly.
> > > > >
> > > > > Another thing that I think this should mention is that compatibil=
ity is
> > > > > only guaranteed for the kernels that use the same ABI version.
> > > >
> > > > Sure, I will add both.
> > >
> > > Looks like it fell between the cracks :/
> >
> > Hm, when I was updating the patches, I included the first part, and
> > then re-read the content, and I think it covers all points:
> >
> > 1. Changes are possible
> > This interface is a contract. Any modification to the FDT structure, no=
de
> >  * properties, compatible strings, or the layout of the `__packed` seri=
alization
> >  * structures defined here constitutes a breaking change. Such changes =
require
> >  * incrementing the version number in the relevant `_COMPATIBLE` string
> >
> > So, change as long as you update versioning number
> >
> > 2. Breaking if version is different:
> > to prevent a new kernel from misinterpreting data from an old kernel.
> >
> > So, the next kernel can interpret only if the version is the same.
> >
> > Which point do you think is not covered?
>
> As I said, it's covered, but it's implied. I'd prefer these stated
> explicitly.

Added, thanks.

>
> > > > +static int __init liveupdate_early_init(void)
> > > > +{
> > > > +     int err;
> > > > +
> > > > +     err =3D luo_early_startup();
> > > > +     if (err) {
> > > > +             luo_global.enabled =3D false;
> > > > +             luo_restore_fail("The incoming tree failed to initial=
ize properly [%pe], disabling live update\n",
> > > > +                              ERR_PTR(err));
> > >
> > > What's wrong with a plain panic()?
> >
> > Jason suggested using the luo_restore_fail() function instead of
> > inserting panic() right in code somewhere in LUOv3 or earlier. It
> > helps avoid sprinkling panics in different places, and also in case if
> > we add the maintenance mode that we have discussed in LUOv6, we could
> > update this function as a place where that mode would be switched on.
>
> I'd agree if we were to have a bunch of panic()s sprinkled in the code.
> With a single one it's easier to parse panic() than lookup what
> luo_restore_fail() means.

The issue is that removing luo_restore_fail() removes the only
dependency on luo_internal.h in this patch. This would require me to
move the introduction of that header file to a later patch in the
series, which is difficult to handle via a simple fix-up.

Additionally, I still believe the abstraction is cleaner for future
extensibility (like the maintenance mode), even if it currently wraps
a single panic (which is actually a good thing, I have cleaned-up
things substantially to have  a single point  of panic since v2).
Therefore, it is my preference to keep it as is, unless a full series
is needed to be re-sent.

Pasha

