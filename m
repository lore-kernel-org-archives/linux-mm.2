Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9A4CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 12:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038EF6B00A0; Sun, 23 Nov 2025 07:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0108E6B00A3; Sun, 23 Nov 2025 07:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68BF6B00A4; Sun, 23 Nov 2025 07:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB12D6B00A0
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 07:04:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B8E15C7A3
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 12:04:00 +0000 (UTC)
X-FDA: 84141738240.22.31E7AA9
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54C44A0003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 12:03:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Vj/1OL7A";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763899438; a=rsa-sha256;
	cv=none;
	b=cYUNOOjme39vFGJ+Z27oI8VMzIhzsYMvYs64f7AbQIylmancW5gVTwpi0TxR4MmVujme1Q
	xGT/CR9ojhLVw5qr4MpRsMVZJr/lJAyHaQymZf/hOC83nx/qraqCqps+6e/9bfXUDSPDZt
	8tSVcXpv64t1a9PgQ80z8Vdozd+T5G8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Vj/1OL7A";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763899438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZ6437ATus0ug/QEfcQ75ODju9BI6cshDa1KKSODRwE=;
	b=RkPlkqScg0JJdb+WwZo3g2aSuiseFXfCdIgE6LXNTF8q1lGtX2byPuFmHmkY1xirpCP6QP
	Mj8Im+p46sJ5PQh0+jD/g8jX/Ce6pgksY4u8qocQXTQ5Cq0w6U4SIn0+RAyK9QuQU2/Fqv
	bkt0DlfL4xi6cIZ78lAvDnJ+Mug3Cds=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so5334870a12.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 04:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763899437; x=1764504237; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZ6437ATus0ug/QEfcQ75ODju9BI6cshDa1KKSODRwE=;
        b=Vj/1OL7Aao+R9B5q1r4t1+gnviSwPr7b+hw+W/yJ3FOnA7r4dyUo8F1/nabjUBbKrW
         onsZVfujMskzVO8isBQGh5iClNF67duxPzfsNHGcZTh2K6mBkSNyy7/oruBSloXrVtGK
         g2rGoazbAHL7JIBn+8fv9YhLmMCjvZCM312ESh9wI0qRQqiu5zuWaUFJlG20n8PTNQFT
         gVbd4zw//q2PSOm4ktxjo2FEAhtsIA8XRQSJGmuS7/vtPsUbuvOqjhIjhGQ3mcirlbw8
         LkJNKSefdhj9AX6dWD4JhhHreoxDY77X4JdhIQsuqHj7O3EMPzWwtPfcFYpsvNToiN/6
         nvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763899437; x=1764504237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yZ6437ATus0ug/QEfcQ75ODju9BI6cshDa1KKSODRwE=;
        b=CBJtguSuELuNWgOoYFwu5OBWeRNLTeR2Vr2YRUHl3LC2JquHLjsHjOkmihTOgU5nKn
         1QwRWeSaMJJ/EqBeziPe8WH6hmjNs7aX5qKOAuf0Ex3yuAbWK/NJ3wR4yfbEV7UOgUKO
         tiWqpx4ZCSjUdsTvgBKeTxC9P/37TUpdHlsJtAnzi3IjdCZYevU4/ns3PMPbZZYyeVXf
         7KubD6C/qkfMXrdQ18qJScD38GI+x9eMXp4p5rppN4kHR4TqZkum/McqLW/TxMILnsSB
         bhoeFqUE+dybkG/A2atVJXLDq1Gf2mowyPc0NVHq1bliIzkveGA7fmwHduAQUYV45hdu
         skvg==
X-Forwarded-Encrypted: i=1; AJvYcCWmlu0iOyf2Oyjl3PDKPlMVwYeOAuDZAzumfdCdGA179yPAMrun8HGbdXLbMgVkQzXbJuZ9p740sQ==@kvack.org
X-Gm-Message-State: AOJu0YyXiqwTjt0klanLDtrVwEDJbNynQ0r7EDDtJiqWY1aVCrI+qAUg
	tysDnjHj6kOvgeYaVAOzcYnM86EsrOYIkW4AxPKV+5awmVyRIH5ZLNAXWa+c9nSfptzHeRJuwrX
	T8f6M7QnEeJlu5QFDNFVNclp2KXwSCcpwHMWoYz2kmw==
X-Gm-Gg: ASbGnctKHBn5SpmkqBPSnzWkPZYh7zuWAHJsXpO+eBbra5wCmTL0ckhRS9lva+HL6MF
	dTnx9aWXeFhYVK03DHtZVzJ2hI6zD9qG4NwtNb1Ar9Hp2pQEg049MYV0eN8kS2rvjeRJsiCW2Yp
	gcAR1Evp6SmjmNmpAoffHYrDY7j83KNwzDH8AYoO53PWwgf6VNJM2iBf6DuIlIfRwQuOjjM9wSh
	VARvRSk/vAwiybLWkTEKgBxQFXS/24U5m3oJECmS2xnQG8K7QUZpUfRdhGrQfJjV34k
X-Google-Smtp-Source: AGHT+IHY4DpDIVQj3DszXOkjPRhgk1igiuds0AT/lVzEITdo2CXMJTFn5D87cQjW3K+5NSqSzXFewu7L010slYHUxPQ=
X-Received: by 2002:a05:6402:1ed2:b0:640:80cc:f08e with SMTP id
 4fb4d7f45d1cf-645546926damr7284637a12.26.1763899435959; Sun, 23 Nov 2025
 04:03:55 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-3-pasha.tatashin@soleen.com> <aSLvo0uXLOaE2JW6@kernel.org>
In-Reply-To: <aSLvo0uXLOaE2JW6@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 07:03:19 -0500
X-Gm-Features: AWmQ_blpSM5U1pU28FozBhcwrN7bmkenjnD3bgD84GHtMLQK1GWO_h-EYfP_LEg
Message-ID: <CA+CK2bCj2OAQjM-0rD+DP0t4v71j70A=HHdQ212ASxX=xoREXw@mail.gmail.com>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 54C44A0003
X-Stat-Signature: 8kejsbkmxwffagyt7e41nookjii1td7o
X-Rspam-User: 
X-HE-Tag: 1763899438-366960
X-HE-Meta: U2FsdGVkX19aWSUH22894e0vGzL5bmqbt+OKaH8VnKqesU1L/xVMk/Bd3WAx+Obx6mgz6sLV230dxEHTDxBr5n75hTVjHV4utTgS7//BuyL8q6Nh27b894g7hKkmmtF3OzL2qR/+04aazkxDN5a8vpdotLnRKiW3hprK0L9WDxqOZ/gk1TDijmGI8il1UXnjjKPXXk1fG9+u+DmojMO3Kc7nntQRuYOtRyzWStjOvcHShtcaBnpancfPSpql6O0hJdMk6am5DXXgk933ev39OkUHxN4Dsev2IVvdJKDw+dd6BmZaMQBlIcNT/BdqvQZ/rhgycRaPNmkAeugPMjBPg0nJpUfyulQy+N/WFfJkCFeNeBVuRrJBEmrOoW7kJdmS5cv/2EDILGsiCX4ZGd01vWqtEf/SCu8HZSsUHuWIJcFjpsSSYD2MmRK27Tn+PU7QB9uE+YiYyoDw5FaofYGlLYMyVOksQLfvIB8kS9tUeGxp8A2MH5Lb7IsAs+rJRdqOSWuw9/V2y1a2EiVmCoABWiR5ZMLnzPObXoYLiLjvvj4PCoUQV47OYHhPVI3XSIzb5MsLMjVmTC8MbPjq+TFgN4Ga1tl7FiAnkk+lrZOBs59tSpV3ZYYAwSVoOlsKA6WSC4Y+oNt2FXlBy/wa+AWwBl8JPuvdt2XLuzJe32rLnM+1rxlIpOJeZFLpvibzcq6rKrE0Q25Y3/TJrTW6nrLZvm+J/WOT+j/h4K1U3IkEOfUom/kxeiigyfX5a5n85OANMkJcWaFtEsbID0AIUPpW4TWC3ZTqSWOuJCHgkf7SoMF4N8MClixqRI+Zo4amCFIBtbrbrcGk4YnNf7yT8xZwfVB/d+o3TEc9KcpsSK2MHT8vR7ZUu7zHL0NS+nLbrFOfS82PYcndC4mdbJqfi5nPzMzikkn+1txBLtoQB2MBnIjk2qVZqacumFco9OkFINwlSGfaSW4WBJaP/hoK5bJ
 B5zHsOyl
 AeWuJZr238y7Zhv2+KDITrzYSigSapBcYCxD5kUfEPu/1lbEuUJ6HOoQxMDPU+LA/hx8R9o9l3v5+y6v6WUYP1oloVELum5K+1IkZe6WDgM+eFEsVbp7XB+nX80L+/Gxn1ZD3dfmSrlSvVW+r9UjnZaDLMFTOs3HuK0yEeQDHZuXPk718MTYwOdNuYHpSHtHLjf+vYqs4k6Hvz40M74ZFBHWhaGOHPTtNFGq8Jf6nS16TK3zfruwuCu/Tr7Inj9pJ44pqj4eAxbGRiqA7pHZls1EeDfLQEUcPtb/anTa4MYmYfnVCrP665B20QoyXH6cR3RrnPYcP3b5MxFzVj49DtEH8osU94Q6uC/9C3yssZ+UMCcnGmh+X3819Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 6:27=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 22, 2025 at 05:23:29PM -0500, Pasha Tatashin wrote:
> > Integrate the LUO with the KHO framework to enable passing LUO state
> > across a kexec reboot.
> >
> > This patch implements the lifecycle integration with KHO:
> >
> > 1. Incoming State: During early boot (`early_initcall`), LUO checks if
> >    KHO is active. If so, it retrieves the "LUO" subtree, verifies the
> >    "luo-v1" compatibility string, and reads the `liveupdate-number` to
> >    track the update count.
> >
> > 2. Outgoing State: During late initialization (`late_initcall`), LUO
> >    allocates a new FDT for the next kernel, populates it with the basic
> >    header (compatible string and incremented update number), and
> >    registers it with KHO (`kho_add_subtree`).
> >
> > 3. Finalization: The `liveupdate_reboot()` notifier is updated to invok=
e
> >    `kho_finalize()`. This ensures that all memory segments marked for
> >    preservation are properly serialized before the kexec jump.
> >
> > LUO now depends on `CONFIG_KEXEC_HANDOVER`.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      |  54 +++++++++++
> >  kernel/liveupdate/luo_core.c     | 154 ++++++++++++++++++++++++++++++-
> >  kernel/liveupdate/luo_internal.h |  22 +++++
> >  3 files changed, 229 insertions(+), 1 deletion(-)
> >  create mode 100644 include/linux/kho/abi/luo.h
> >  create mode 100644 kernel/liveupdate/luo_internal.h
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > new file mode 100644
> > index 000000000000..8523b3ff82d1
> > --- /dev/null
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -0,0 +1,54 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +/*
> > + * Copyright (c) 2025, Google LLC.
> > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > + */
> > +
> > +/**
> > + * DOC: Live Update Orchestrator ABI
> > + *
> > + * This header defines the stable Application Binary Interface used by=
 the
> > + * Live Update Orchestrator to pass state from a pre-update kernel to =
a
> > + * post-update kernel. The ABI is built upon the Kexec HandOver framew=
ork
> > + * and uses a Flattened Device Tree to describe the preserved data.
> > + *
> > + * This interface is a contract. Any modification to the FDT structure=
, node
> > + * properties, compatible strings, or the layout of the `__packed` ser=
ialization
> > + * structures defined here constitutes a breaking change. Such changes=
 require
> > + * incrementing the version number in the relevant `_COMPATIBLE` strin=
g to
> > + * prevent a new kernel from misinterpreting data from an old kernel.
>
> From v6 thread:
>
> > > I'd add a sentence that stresses that ABI changes are possible as lon=
g they
> > > include changes to the FDT version.
> > > This is indeed implied by the last paragraph, but I think it's worth
> > > spelling it explicitly.
> > >
> > > Another thing that I think this should mention is that compatibility =
is
> > > only guaranteed for the kernels that use the same ABI version.
> >
> > Sure, I will add both.
>
> Looks like it fell between the cracks :/

Hm, when I was updating the patches, I included the first part, and
then re-read the content, and I think it covers all points:

1. Changes are possible
This interface is a contract. Any modification to the FDT structure, node
 * properties, compatible strings, or the layout of the `__packed` serializ=
ation
 * structures defined here constitutes a breaking change. Such changes requ=
ire
 * incrementing the version number in the relevant `_COMPATIBLE` string

So, change as long as you update versioning number

2. Breaking if version is different:
to prevent a new kernel from misinterpreting data from an old kernel.

So, the next kernel can interpret only if the version is the same.

Which point do you think is not covered?

>
> > +static int __init liveupdate_early_init(void)
> > +{
> > +     int err;
> > +
> > +     err =3D luo_early_startup();
> > +     if (err) {
> > +             luo_global.enabled =3D false;
> > +             luo_restore_fail("The incoming tree failed to initialize =
properly [%pe], disabling live update\n",
> > +                              ERR_PTR(err));
>
> What's wrong with a plain panic()?

Jason suggested using the luo_restore_fail() function instead of
inserting panic() right in code somewhere in LUOv3 or earlier. It
helps avoid sprinkling panics in different places, and also in case if
we add the maintenance mode that we have discussed in LUOv6, we could
update this function as a place where that mode would be switched on.

> > +     }
> > +
> > +     return err;
> > +}
> > +early_initcall(liveupdate_early_init);
> > +
>
> ...
>
> >  int liveupdate_reboot(void)
> >  {
> > -     return 0;
> > +     int err;
> > +
> > +     if (!liveupdate_enabled())
> > +             return 0;
> > +
> > +     err =3D kho_finalize();
> > +     if (err) {
> > +             pr_err("kho_finalize failed %d\n", err);
>
> Nit: why not %pe?

I believe, before my last clean-up of KHO it could return FDT error in
addition to standard errno; but anyways, this code is going to be
removed soon with stateless KHO, keeping err instead of %pe is fine (I
can change this if I update this patch).

> > +             /*
> > +              * kho_finalize() may return libfdt errors, to aboid pass=
ing to
> > +              * userspace unknown errors, change this to EAGAIN.
> > +              */
> > +             err =3D -EAGAIN;
> > +     }
> > +
> > +     return err;
> >  }
> >
> >  /**
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_i=
nternal.h
> > new file mode 100644
> > index 000000000000..8612687b2000
> > --- /dev/null
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -0,0 +1,22 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +/*
> > + * Copyright (c) 2025, Google LLC.
> > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > + */
> > +
> > +#ifndef _LINUX_LUO_INTERNAL_H
> > +#define _LINUX_LUO_INTERNAL_H
> > +
> > +#include <linux/liveupdate.h>
> > +
> > +/*
> > + * Handles a deserialization failure: devices and memory is in unpredi=
ctable
> > + * state.
> > + *
> > + * Continuing the boot process after a failure is dangerous because it=
 could
> > + * lead to leaks of private data.
> > + */
> > +#define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
>
> Let's add this when we have more than a single callsite.
> Just use panic() in liveupdate_early_init() and add the comment there.

https://lore.kernel.org/all/CA+CK2bBEX6C6v63DrK-Fx2sE7fvLTZM=3DHX0y_j4aVDYc=
frCXOg@mail.gmail.com/

This is the reason I added this function. I like the current approach.

Pasha

