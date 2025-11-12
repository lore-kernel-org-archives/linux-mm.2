Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E85CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419BD8E0018; Wed, 12 Nov 2025 09:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1BB8E0011; Wed, 12 Nov 2025 09:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307FC8E0018; Wed, 12 Nov 2025 09:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE228E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:59:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCDB2C047E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:59:08 +0000 (UTC)
X-FDA: 84102262776.06.F6B0D8F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id B81BD40009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:59:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BPJqGA+B;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762959546; a=rsa-sha256;
	cv=none;
	b=kMQVthjZlKH3eS1SVorGKYKMTKNuSh6CvenW5c/G/4qLNkRX3mZGLp5H5j+TXbwaYpaNRa
	e6A/pRF6rGb14AhmEo54iqME5wZEEEsjtBHVKXEtVfIP7GkU9mpp3kVa/S0/CbPEjLPeg9
	kHfgz0QxT9RTcEoYAnfQA3felVPO/3w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BPJqGA+B;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762959546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MTLQ2+KzlbyAQxckoGWY8C9+me/+LObO2aCT3fFijI=;
	b=Lq72wO45qfDtn3jwlNdNdPkpJvFz4AwGEOI/XNAT1W1/pd7n74hmUsq+9tcmxC4mb208zO
	0cy4qb1aNd/tuyj6J78yzgqqZe5znrOmapCHOXHGofSo7Lz9VpCdLoNPnPmuI4MwyP0KHw
	skx/ZIXOh0BO/KP7/iX5aPATe421qiI=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so1569536a12.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762959545; x=1763564345; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MTLQ2+KzlbyAQxckoGWY8C9+me/+LObO2aCT3fFijI=;
        b=BPJqGA+BoqBhxNdNaIDnWjyRcJ1h+mDfr8NKjJYEDEQ1ESSbXNyUwAqqrJtpoZwlMX
         tD3pJDCzMohWK9DWYyKUGO8G+YkxJmn07vBL4IlVuhUf8xgGrLHdUjFrjqHKkjH+1kgh
         QdkVejwFWV66LC/navKeZGL+A8WDrROMSxazt4BBlgnMS5ozh92ERTqhLLGvz5ugKe/q
         xg9QdbgS6CH5o6phgaSUI/dKLDhVLsmlmSXvGKXCXD9+Pf9ZsfNHF1pGPR3RcG/hdx3X
         UsUmZRVDWJun7fTZVP8kTRE49PqpEeI1b0sIinPZybJpFFgKG9ujxeI/Yu72HvIA0Qtm
         f5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762959545; x=1763564345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0MTLQ2+KzlbyAQxckoGWY8C9+me/+LObO2aCT3fFijI=;
        b=GAQaEWqLJ7q7Zyh992pWaKw1unNFWA5yEUJnw/ZRXJTgLenK/Bwecx3Oev635GLYNW
         EaAE1hCaChKDv8mmS7EtBslwOqFTxy3w8dQDl8yermLtwjFyesVPvxoEVx/ezm8Ea/9N
         YSN1onGjL1gMa/r+xiaqATA0FH1uuSj8AnzgOo6RPr+gr7V5rX4vg5b83DmtaVYlOUjz
         oUa2XOsU7wrbSoEUQRNQ8i+6p0sDvbMs93hq1alsvFkElgnOJ0XeCXsEDe1UCUdE0mhU
         StwhHtCHgR+Ria2HkIzb+WXlGjuXvESuOL1rxJutaCpNZn5+wjMTXVi1yglc7bbTZlUk
         qLGA==
X-Forwarded-Encrypted: i=1; AJvYcCV2o9mBC3H8c7sNgsY18XUukhQDADfyb34bTkMkt+N3mBN++zVWVVrn3hWdVa4zd8tBCkQC/zhisQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8vcPbxA/7fkyL4EGd2D0rhOZbGUhG8Wz2CETPHbHdYjWWztGr
	xM4vIuyRdVYD05kKmfcHQqiYHDQPG5Ihki9OGJ8ZS6n0d0NCOiwPH6qJqk3+hKGi+eEzpNdGmtO
	vIdsTpztwHkOBqXCiquggSaeVGBkBdYwhc/GkGsICVw==
X-Gm-Gg: ASbGncvcJLRj2SrvIBbioQ2r3Wcw5ECeAtQy1Qhj6pBs3NssKJyPGm5sqvdsaT/MHN4
	aVrdzfEmEVgTK3K7BQX53PXGQMq4DPCxVsUkeQKN/Nn57DDOQfOFlbPzFlZx6Zp9lOpTeCNgMrz
	JPY5SujsAIZ+4HXVdxAiM1cQ357zLQSMsJepgtot+kqPPUDiKkJlibkUWVIEc+AdAZE7YV2WzcE
	SEg3FNFi6TaeB2oioGs1lW+enzYPYuS7Hei+xvXlVn+P+2qrCG+SjKr3w==
X-Google-Smtp-Source: AGHT+IEdmxSCUrDpzYYdeQ7xGZMZCFuRazVHOEq301lv0Np/o4OtNdmIj/Fd7MlLr72XZf02Ov5bYrL1l7CAevQmQsg=
X-Received: by 2002:a05:6402:20d5:20b0:640:6650:9173 with SMTP id
 4fb4d7f45d1cf-6431a5906c4mr2199942a12.33.1762959544759; Wed, 12 Nov 2025
 06:59:04 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRHiCxoJnEGmj17q@kernel.org>
 <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
 <aROZi043lxtegqWE@kernel.org> <CA+CK2bAsrEqpt9d3s0KXpjcO9WPTJjymdwtiiyWVS6uq5KKNgA@mail.gmail.com>
 <aRSKrxfAb_GG_2Mw@kernel.org>
In-Reply-To: <aRSKrxfAb_GG_2Mw@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 12 Nov 2025 09:58:27 -0500
X-Gm-Features: AWmQ_bnbzArXLN8aoATNdiGHp809pzMOSngeRCNP27w6LsiaaRY3i_BJDeNIl5I
Message-ID: <CA+CK2bAq-0Vz4jSRWnb_ut9AqG3RcH67JQj76GhoH0BaspWs2A@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B81BD40009
X-Stat-Signature: g7mg6ph5aoadrehbrnb9phnhxk1in6yw
X-HE-Tag: 1762959546-571428
X-HE-Meta: U2FsdGVkX19S/5/a8/cXY5g0A+KZzxUUgHl3sdh7xX3rGMut8S4Md8Nwy0ye6F9II36voVzrJd58q94v7H2T2Thg4Da+Dlfg+7ArFtbOEAZCtHeRqhPZrC83wDWEMwB4H4yr74iuthMTXK5RcOhEWtrqCfEFB9w0M+fxCjdL4xzjznHQ3lZXQWBMx7djlTM5iXYKrhkUQPRHOGaT3Abar9EcI2mHfKoC0WNJlfHFRDmWiafbehNHRxIAFq5r07Gpg3/TFTjmgaDwoI+hQZgrnvXxmu32nXf2sVVOql+XymHMB0CAeP+TL80MLIRaJD4y0Ldr6MiOxVMJVLNMPhoOCKIGhwR9LExLvXyOxMrP7B0/8odRHc2CNiC0fopd/+NiiqQlvEsXS41WEgOisLmPBk4pRbRXmvlpEI6orsEtSZHPyPYeG8mUpQ2S2H2ct/i66eZNZk8s7OVEl04NTcU5/hRlse8EYmegF51mA8AyxLxb05eVA/M1Mr3HNC13CiFW3XKdTm3gYCmVOhbaCa7mwveXUTVYRBjZ0ZvFXJX82mryHd2z0o5gboo7tfOstMqabv0rhmySCuBDVR8oC2l6WeVsJMHaVh0SQPQ/xpraXbVuuI2A1EbrefG3ceq23BTXoIKPf9xRgsXrx0AHAyr15QzPqWKUV9aw5ghpXBqE+tk1YVWGEJ97DWjvK0+Ctaf33sz2CJA4+euW5iJM7Ihm/qAzKycWnOTVzYGm68QSxIBI55kfqeDMRl1GGUSOlGev1+m382V/I506/u7AtRGNxQkgUlmvN2GPDqibgT5DzTbz84R1NhaUTKyRTGsrG6Mx1LO7u7SBhuMy/zjmDdlBTDAGJf88kZmrIHwb154OwIE4IgsDkgc/wXbjopVTmXhfKIvkTEgLUJrFsflACsr/WJcrcU3Qa9jBcMD7zc89ejigSsvCtXhRLBIgCZHlfThSFLs0/C4RB4pKV/4an+u
 eRUPhL26
 3BKJ7BZWy13/qxLOYXJ5e+ZxL+9xRc0Zug/1VZyno5e4FEGFr5GJiFqd4Z9k7XuDwmubMfcizseJfXiZjD78uPbQLpU0ycRlGR06Pzb3h/64GR+bCQcAFaVjg+Bofj7VqtZ0lNzp8otv/d+4/zRrXTPh2NyThs9HjF5oQLePAlr6Bj+ys7fIBFfJSCJZoIPo0McfrJq4RCMuvQY8X/CAEXMHj95iWvKkmvFayHi1jEqxlE3fqMC5x3XbAt0tJoYtZc7tSt3A+JvM74YHQdfuSJ/ygbfyYsibfqUbctKmza/YbIvpVQpKRU2/CdoNNmmAjOdI3pqYsq6KbzGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 8:25=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Pasha,
>
> On Tue, Nov 11, 2025 at 03:57:39PM -0500, Pasha Tatashin wrote:
> > Hi Mike,
> >
> > Thank you for review, my comments below:
> >
> > > > This is why this call is placed first in reboot(), before any
> > > > irreversible reboot notifiers or shutdown callbacks are performed. =
If
> > > > an allocation problem occurs in KHO, the error is simply reported b=
ack
> > > > to userspace, and the live update update is safely aborted.
>
> The call to liveupdate_reboot() is just before kernel_kexec(). Why we don=
't
> move it there?

Yes, I can move that call into kernel_kexec().

> And all the liveupdate_reboot() does if kho_finalize() fails it's massagi=
ng
> the error value before returning it to userspace. Why kernel_kexec() can'=
t
> do the same?

We could do that. It would look something like this:

if (liveupdate_enabled())
   kho_finalize();

Because we want to do kho_finalize() from kernel_kexec only when we do
live update.

> > > This is fine. But what I don't like is that we can't use kho without
> > > liveupdate. We are making debugfs optional, we have a way to call

This is exactly the fix I proposed:

1. When live-update is enabled, always disable "finalize" debugfs API.
2. When live-update is disabled, always enable "finalize" debugfs API.

Once KHO is stateless the "finalize" debugfs API is going to be
removed, and KHO debugfs itself can be optional.

> > Yes you can: you can disable liveupdate (i.e. not supply liveupdate=3D1
> > via kernel parameter) and use KHO the old way: drive it from the
> > userspace. However, if liveupdate is enabled, liveupdate becomes the
> > driver of KHO as unfortunately KHO has these weird states at the
> > moment.
>
> The "weird state" is the point where KHO builds its FDT. Replacing the
> current memory tracker with one that does not require serialization won't
> change it. We still need a way to tell KHO that "there won't be new nodes
> in FDT, pack it".
>

see my answer below

> > > kho_finalize() on the reboot path and it does not seem an issue to do=
 it
> > > even without liveupdate. But then we force kho_finalize() into
> > > liveupdate_reboot() allowing weird configurations where kho is there =
but
> > > it's unusable.
> >
> > What do you mean KHO is there but unusable, we should not have such a s=
tate...
>
> If you compile a kernel with KEXEC_HANDOVER=3Dy, KEXEC_HANDOVER_DEBUGFS=
=3Dn and
> LIVEUPDATE=3Dn and boot with kho=3D1 there is nothing to trigger
> kho_finalize().
>
> > > What I'd like to see is that we can finalize KHO on kexec reboot path=
 even
> > > when liveupdate is not compiled and until then the patch that makes K=
HO
> > > debugfs optional should not go further IMO.
> > >
> > > Another thing I didn't check in this series yet is how finalization d=
riven
> > > from debugfs interacts with liveupdate internal handling?
> >
> > I think what we can do is the following:
> > - Remove "Kconfig: make debugfs optional" from this series, and
> > instead make that change as part of stateless KHO work.
> > - This will ensure that when liveupdate=3D0 always KHO finalize is full=
y
> > support the old way.
> > - When liveupdate=3D1 always disable KHO debugfs "finalize" API, and
> > allow liveupdate to drive it automatically. It would add another
> > liveupdate_enable() check to KHO, and is going to be removed as part
> > of stateless KHO work.
>
> KHO should not call into liveupdate. That's layering violation.
> And "stateless KHO" does not really make it stateless, it only removes th=
e
> memory serialization from kho_finalize(), but it's still required to pack
> the FDT.

This touches on a point I've raised in the KHO sync meetings: to be
effective, the "stateless KHO" work must also make subtree add/remove
stateless. There should not be a separate "finalize" state just to
finish the FDT. The KHO FDT is tiny (only one page), and there are
only a handful of subtrees. Adding and removing subtrees is cheap; we
should be able to open FDT, modify it, and finish FDT on every
operation. There's no need for a special finalization state at kexec
time. KHO should be totally stateless.

> I think we should allow kho finalization in some form from kernel_kexec()=
.

If we achieve that, we wouldn't need a kho_finalize() call from
kernel_kexec() at all. All KHO operations should be allowed at any
time once KHO is initialized, and they shouldn't depend on the machine
state. So, even late in shutdown or early in boot, it should be
possible to preserve KHO memory or a subtree. I'm not saying it's a
good idea to do that late in shutdown (as preservation may fail), but
that should be the caller's problem.

Thanks,
Pasha

