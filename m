Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC01CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 14:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287278E0009; Sun, 16 Nov 2025 09:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237B68E0005; Sun, 16 Nov 2025 09:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1267C8E0009; Sun, 16 Nov 2025 09:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDC408E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 09:56:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A74061A0979
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 14:56:10 +0000 (UTC)
X-FDA: 84116770500.08.1310374
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id A496A180010
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 14:56:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ne17iGBK;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763304968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/CQAuhHNkCADrkQvHG3hd8paJ2zmTnw1jvvtqelozg=;
	b=Hpb8L069mcH6V1GClYg6RU2ixb+BftzOeodwKsqT9Jn03w6PuORBWt21+MlTrj3CPIgwF9
	xFtUHdn08xPBZpW1AlSDnGUY/totFUZF8qurg3Bjam+xs/AE70o4W730wqGIG6t/VwhHYN
	j0X88quZ5r3rvPQ/jdoev5xqpLCzUJg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ne17iGBK;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763304968; a=rsa-sha256;
	cv=none;
	b=p3WamZFTtnjWmwlQDx9vnRl8hvyHRJoz3U6HdnJJaPX62ZeKr0NQRlKm7bUf1YaWhVdcgD
	08pLGCYaCElQF3gVi0Do+dZr5AUCQps/aI6YwZ5v0HNspqZKJ7aSC1s/j1oguD66OT2oWg
	kO7IrVkhlvLWMClf8BgGjX45ZvtEF70=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso6555257a12.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763304967; x=1763909767; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/CQAuhHNkCADrkQvHG3hd8paJ2zmTnw1jvvtqelozg=;
        b=Ne17iGBKIEr/Lv7GKEjaEQkSYhX2O4wRe6/Ikc9UTsuONxN36+uMNjvYrmEyx6b9aj
         J9Wkjt5iiaQpHCb3MWHrR8T46HMOny/OqNG9KR8ULV8XS1MmYZHxbKm9RO3d76jz4AZN
         JcqqY6p8U6udlYcWXx3TfDQHCc6K4lO1ANlx95qtLT4YgeeY70FHB1VED+iDh+F3oA3i
         9kAYK5JCjR4ReAgrx8Sys5pzOxSw2vix+RAqz1Wkx4sq2kCgPjj8pO3Dz+6Y4MS+WrM5
         lLFig/UTQPZVvI+Qi+O/BqGW+bIqZxsLO39oHaRla5yWUAfHyFDRunICtDfrcrsMPdWF
         J98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763304967; x=1763909767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0/CQAuhHNkCADrkQvHG3hd8paJ2zmTnw1jvvtqelozg=;
        b=PSI+RgbNfELCP2UzV/om14ZgTyD6reL9qefx9aGBp+VwcgYbJnu7EVMWraOAVkeNaN
         41fQfZyxOxnibbQ7gh2lLtmIobBuq+HuqO2Mub4z8PApWKFMEw8feN3ReDP5zzSf/AeK
         YKIqeVGVHmpBnlBs/ddrTlG5JDgt2SOkqpLgq7HDFy+dn3NU8Ynr+nf8+G2gyQNgU7WY
         fggzZ9BfwU2VoT0yeneYN7Wnbz2l8e/jlj7iwLG/oEU+kwzXHatAh5ApBDsD+VyreWa6
         PN6W4lNgy8cpCmYnOlpcoBKVzsdQqQeDJxrKZAl9FrQAkqArVqXQbZpAq24o5uNiCI3M
         tUuw==
X-Forwarded-Encrypted: i=1; AJvYcCXry9i11d9M1dEzxflgrR1AQGQq8pLYIxqVAy48xPuULcnaF8w7B4t2pmzK+lu3yh141mWDOjOlmg==@kvack.org
X-Gm-Message-State: AOJu0Yy8Fm9YN8t4fMg1xOXIuvtxOnKw1b9WrynO25UhhbgSGydSoaFN
	QCKd06nvyhk3roJ/zvIrCFs0AxKBJAdSHXNkwQiyg7mlgwKL6wd8T1FWSjekgCCYDlyHnsxgXQe
	NHj8hqVkBBev63uU2rZR/94SjZIDo0BgZ/eV++60RAg==
X-Gm-Gg: ASbGnctQj89urUI1O2MLm5hYnedVIGU/bKokLV9gZblR6OX51AaUa312C82zIweIhU0
	MHEHWioqQze4TSfg+7Hn84NSANiJB1HQ0vY/FUAuQrUlY6nTLBnCGmYMN6lhs3IYY4A/i2tCffP
	+vji29x733qf8rQ7p0jXGhZSa/YHSMl/UgZ7MMRxYTjYoHjHrPbmHbB+GKpqzuwvVn2ovNDYqZs
	+UwjO7Fx+8QMnVZD8Ho/0tkDYdw7VYbuMQEnkswfX2JpUagU1glxSpRoNhOFfKTg9VThygvtYT+
	Z9ndS534xNXed/yAMnBb8oRJpgAn
X-Google-Smtp-Source: AGHT+IGNPxKwLz6m1hNQQtO/HUlURpwzye7xb9Bg+A8R04/hYPqwQLHKZYopHY79DJqzQnd0DKSzDXSuqpY0Dvll30c=
X-Received: by 2002:a05:6402:34c6:b0:640:ceef:7e44 with SMTP id
 4fb4d7f45d1cf-64350e9ff14mr9315924a12.28.1763304966695; Sun, 16 Nov 2025
 06:56:06 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com> <aRnG8wDSSAtkEI_z@kernel.org>
In-Reply-To: <aRnG8wDSSAtkEI_z@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 16 Nov 2025 09:55:30 -0500
X-Gm-Features: AWmQ_bmM-aRBqtNYsNPIqAwGT0quxlyXWlezggSpTwsXJzseK1QN4lUsqunxqQU
Message-ID: <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A496A180010
X-Stat-Signature: etj4g1cufwf6rr63fc4bi641ohpqmrai
X-Rspam-User: 
X-HE-Tag: 1763304968-804840
X-HE-Meta: U2FsdGVkX1/o1TzjCcRohyfstEmlcc/vUNXOXfLbUTfkkKy3ILvl1CTWfkO+HQJzBZ8/kELLb2SSE3IrVMagd/ePox7A+4SAp2sY5VQs8/GO2/h46SikxftFgGbjB68qnshCj+OSZtznhswEEjeVwnZmbTHvVa8rqXeT6LN0pPMk+1OjUIot5fpyZ2+CSlPkh94Mwf8afAqMgtPKXwd7wS06jQwgzPzoplSPDYaDc5NkpBAhqO/TgZK1RlU0wej08DYyRP4jrgGrJoJk/hMmrT3XUMogVnUrbaRuf+zhQH8XvuPK3NM7CnfyRDjeYM19NyIMDse+1JFwKRhZ1blfWnK7lQBrtQ84zlFizBbsQO3R02pGV0kKgz2t4DB8T9KMR17aAM99HAcNGkzRkSUCcLeg8neTKKJ+dYBb3KbVezMwnH9tn9yiO2GMQS/94uYM6nufZ9XyJVZmIPr5ckW7VDAoNVlJiCDtfv5o/w8tIwGtL8svq/SXfnqraHEXMxJpFHlUq92574f/GSlc+53F0gGvDQYEgFHKDe/wYhZjdXZEY+dJZ/fkJAfhFnHQ4L0HNZCmrLwygYk44gqlc6DTe42jZds1bxVAX8c4/uytYR+ULYa0rzSXCyeu+9A75qpwvi3nPtNA6T5k2vargTYp2nft+OnBQIKnEB8Wu50pms2JXo/y7dosimfdbHImZ1flzdfo3XU4b+uMln1Dw4GKiUec8h4Rc8BuEx45rsUY65I+weGxO7p2fgffdhmCcyM2iUCCX3GonlXbF4XlPMR4ViAMd+7JIANb+FrzPxCB48EmkTILjrnHigQdCAXAed3LcD9020a/EFakjri2Gvl2elRVC0CG/Jdb5R4Rn0DDwc4FAr3EcnP3XSiHXmQau5yqBHYVYtCqA/o0kJY7/OrlS2haWZqcFMmop+uEvBERH3+Sa4WaQ3Kj95Sa73kaW/q9T04wsKOekUc7Gyq/ReG
 m/Pkh12I
 ma1aPe7bWcy8X2nHBPsJTdmMXojSsWWHA/qaVFTsMr5z6ftiswZO/LD3g9EVv8qJZe9odJUjE0db/KncFbx12EuSxM1reWSG/4Bbs5rrAG9ueDsf07bWhFplaVTRb84qC6/6b7IWt0Esc7GfgxCpbdZGxbom6IGFL7Ps3jCKqB1I6V3seKnvSWYXFJIkFqHHdChlD4UvH7q9x4zkB5IdkwEmQPjY5IhxVLok9lVt0y+9D92G0DgnfJlUpC9fXlA/MaA7lL1b2YDCI5tVDMGxIpSUm8YX0l0mrM0xwecvVFJHMPH8MPrJZXUYwCHl5wAuYJXqqhk8zdJ0cscJbJgSdhZYkK0co16/ntCGpTusZgHpzc27bZBMq6T6gEZdCyib19OGOMiSjwV1q9Ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 7:43=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 15, 2025 at 06:33:48PM -0500, Pasha Tatashin wrote:
> > Integrate the LUO with the KHO framework to enable passing LUO state
> > across a kexec reboot.
> >
> > When LUO is transitioned to a "prepared" state, it tells KHO to
> > finalize, so all memory segments that were added to KHO preservation
> > list are getting preserved. After "Prepared" state no new segments
> > can be preserved. If LUO is canceled, it also tells KHO to cancel the
> > serialization, and therefore, later LUO can go back into the prepared
> > state.
> >
> > This patch introduces the following changes:
> > - During the KHO finalization phase allocate FDT blob.
>
> This happens much earlier, isn't it?

It is, this commit log needs to be updated, it still talks about
prepare/cancel, where they are since v5 replaced with
preserve/unfreeze.

>
> > - Populate this FDT with a LUO compatibility string ("luo-v1").
> >
> > LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
> > logic (`luo_do_*_calls`) remains unimplemented in this patch.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/liveupdate/abi/luo.h |  54 ++++++++++
> >  kernel/liveupdate/luo_core.c       | 153 ++++++++++++++++++++++++++++-
> >  2 files changed, 206 insertions(+), 1 deletion(-)
> >  create mode 100644 include/linux/liveupdate/abi/luo.h
> >
> > diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupd=
ate/abi/luo.h
> > new file mode 100644
> > index 000000000000..9483a294287f
> > --- /dev/null
> > +++ b/include/linux/liveupdate/abi/luo.h
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
> I'd add a sentence that stresses that ABI changes are possible as long th=
ey
> include changes to the FDT version.
> This is indeed implied by the last paragraph, but I think it's worth
> spelling it explicitly.
>
> Another thing that I think this should mention is that compatibility is
> only guaranteed for the kernels that use the same ABI version.

Sure, I will add both.

> > + *
> > + * FDT Structure Overview:
> > + *   The entire LUO state is encapsulated within a single KHO entry na=
med "LUO".
> > + *   This entry contains an FDT with the following layout:
> > + *
> > + *   .. code-block:: none
> > + *
> > + *     / {
> > + *         compatible =3D "luo-v1";
> > + *         liveupdate-number =3D <...>;
> > + *     };
> > + *
> > + * Main LUO Node (/):
> > + *
> > + *   - compatible: "luo-v1"
> > + *     Identifies the overall LUO ABI version.
> > + *   - liveupdate-number: u64
> > + *     A counter tracking the number of successful live updates perfor=
med.
> > + */
> ...
>
> > +static int __init liveupdate_early_init(void)
> > +{
> > +     int err;
> > +
> > +     err =3D luo_early_startup();
> > +     if (err) {
> > +             pr_err("The incoming tree failed to initialize properly [=
%pe], disabling live update\n",
> > +                    ERR_PTR(err));
>
> How do we report this to the userspace?
> I think the decision what to do in this case belongs there. Even if it's
> down to choosing between plain kexec and full reboot, it's still a policy
> that should be implemented in userspace.

I agree that policy belongs in userspace, and that is how we designed
it. In this specific failure case (ABI mismatch or corrupt FDT), the
preserved state is unrecoverable by the kernel. We cannot parse the
incoming data, so we cannot offer it to userspace.

We report this state by not registering the /dev/liveupdate device.
When the userspace agent attempts to initialize, it receives ENOENT.
At that point, the agent exercises its policy:

- Check dmesg for the specific error and report the failure to the
fleet control plane.
- Trigger a fresh (kexec or cold) reboot to reset unreclaimable resources.

Pasha

