Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EBBCD8CBD
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19B68E000B; Thu, 13 Nov 2025 13:38:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1238E0002; Thu, 13 Nov 2025 13:38:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06D38E000B; Thu, 13 Nov 2025 13:38:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5708E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:38:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A5BD1A0A07
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:38:42 +0000 (UTC)
X-FDA: 84106444884.07.DFA2983
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 363D4140004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:38:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RqY5UiGN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763059120; a=rsa-sha256;
	cv=none;
	b=u1VG85KKyd3dXxYuP+NSBxPdH6X0y1D3QkW4k6Fue0UapuGijEv/9Wr0/GNV8MiVed4O2e
	SQAGGP4eg2HtWKuPk1m4ww/A2W3cbxPUQBJRxVYMQTYTI0WrUK6Ii0+gxMSBlQAmjQsuN4
	Iei8Ej4IBPAbJsmSDi5TOVHCAciNxls=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RqY5UiGN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763059120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QzIZolLw0TWeicvPUi5XAG3YGoC32FLVnv2N+ZATiw=;
	b=1GswI2jbctVGQQ7hqWm5NMI0CI2gnjjF7C6+whjTdVgpIGGSE0xZYQyNFiCyfOTgKM6z62
	Fnh2TunqDxYP9mHOeF3zfkwFKWExAmB4IA6/gR5vvcREsXA1aFU7JSK0TOmRktI2fdC2JI
	cgMlDkCZQc3w5IS4dFso967462OdrEA=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so2000878a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763059118; x=1763663918; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5QzIZolLw0TWeicvPUi5XAG3YGoC32FLVnv2N+ZATiw=;
        b=RqY5UiGNvsIWMbSOn15NknTFj8utIpb2r82cNNWfBM53azwFegl2oZ/igx3m6dcccF
         KY7FxPUOOxr6MqCuNBIEc0+dJcVq0BWk3dGBlXzAeZ+1f1Pxab1VHa7zslq+9WfFUs/p
         0p4pjWyRgktZ/LJOncAHwFM9z9nuhpZ6ATwgCXytFtnWxYy1/n0PYF27BgrRL5a7LWJd
         3yCGkIaLT+9bi2vKsKzCOKNHnsRl85J+BnM0IU39s1TKm3ySXozbAgdU0b/jSdvkFUBQ
         w+R9uOw4Dq5KN56M339A2POF5EXklGR67DbPcdmaKD5Beew+sEJKKveBv9H74ktptHB4
         19OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059118; x=1763663918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5QzIZolLw0TWeicvPUi5XAG3YGoC32FLVnv2N+ZATiw=;
        b=aF/zBRdTD+si3NFTeHR6TcV2T0jaCCaBfIVrG9aD53NHmV79ZYwZOVngjRbxO3RSht
         01ZvJOnf4WNamR841WgD+2xWyLJ3ZDpy4PTRTTKl/fHv1DTxQ5HD6kraiEvEAjVwY99/
         lKmHsHZa9Tnw0aunHqESKtvJ9dmLwjD8zkZpsnxMuycJiF3RTvDkAl0q3L8cryePhNDH
         y8GnLqth0TDkql6QepdAoGQlZA0VZ2qGH2Rg6bX2pSOUmxRbc9DSMvfrEpcI0Tasu4Qz
         e9byL6ZMe920A1TzAviUBCelYR1YIVk59Xtni/PeD1c6g6j9oMAhfLOlY3WU93h3TIos
         Dh7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXtMsIP9bL/Smfvt5lh+lr5O5A+x8AEOs+3y0cJ6UmaEYQB26emU8FEnZC5Aq5qUcCkBKHXAvga2Q==@kvack.org
X-Gm-Message-State: AOJu0YwZSz91HZe/enCgrR1gaqhvFNsiIS1MHb4+oKU7oGZ25gMBSTr7
	TQ7hWfia7soQlXNekEtf4WAeMci2LjYK7J/VwSCnGouc8y7MlOdhnx+96CT0YGiBfl2M4iy9vIe
	HIdHbr7MDreU6tyFTcpIsV7kOHsryVYG/N6ky0FWrAg==
X-Gm-Gg: ASbGncsyKwKWnbte+aQfylg1ZHoSGJTdY9FkZ0z+Nt0Yigs6DsX+vsHKF+o/vYEUdkq
	ZkqGZXa+n7CD9sjzZ/mU0i2sjPMCqsg0CzIF4z9kI2soS2dUHNxlftdzcP959nre3x/y+dKuOi8
	dhbUZ2lFeSLaN88bcavXdYQ7Lp9Yiq+HhlFbXi6672wci8rzd4SNv35AzZqt6rSA5ekfs/EZ0M3
	OZTGLl/0vCsJpDGF7Qs7/aBVagmOB3oVXTLGbT29zTKBI7pZUd+fA2KyQ==
X-Google-Smtp-Source: AGHT+IEDdgrLTNweUjb0jeGLJZI3hwXTN5B+vwJRTiRZj6uuz96RHszyffXikSiDLB6+TEf6KwvdNmtJbHmHq1QzP+8=
X-Received: by 2002:a05:6402:3056:10b0:640:b1cf:f7f7 with SMTP id
 4fb4d7f45d1cf-64350ebf795mr201526a12.35.1763059118370; Thu, 13 Nov 2025
 10:38:38 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRHiCxoJnEGmj17q@kernel.org>
 <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
 <aROZi043lxtegqWE@kernel.org> <CA+CK2bAsrEqpt9d3s0KXpjcO9WPTJjymdwtiiyWVS6uq5KKNgA@mail.gmail.com>
 <aRSKrxfAb_GG_2Mw@kernel.org> <CA+CK2bAq-0Vz4jSRWnb_ut9AqG3RcH67JQj76GhoH0BaspWs2A@mail.gmail.com>
 <aRYH_Ugp1IiUQdlM@kernel.org>
In-Reply-To: <aRYH_Ugp1IiUQdlM@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 13:38:01 -0500
X-Gm-Features: AWmQ_bneOtiUV_-OT7VkHtp8xKlM72B3fH-AsO6J1uV7zz_LDIJjB88yI7q7RiE
Message-ID: <CA+CK2bC_m=pUHt1uOoW9UMssDATqabHKHRyq7QNbzrb9Vm13Cw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 363D4140004
X-Rspamd-Server: rspam07
X-Stat-Signature: 5t697haa7rs5czzpznurgwn433yrku3t
X-Rspam-User: 
X-HE-Tag: 1763059119-797825
X-HE-Meta: U2FsdGVkX18q93mKVSlgWShjh6HVXakG1GGAjla87mh8XPtATKbjhvndu5Su9CD9pXZSIYfjK1P4n1At60oSVSbWQf9gc2Houy6Qp1ITDubyxRGJTZN7uCFSVZ0la2HV+4ddqReOIkyfF1APc2dAJ7f3xajHWfYuV5rrbv7tc6khyg+0MjrkKg+Bj3+u3TblBXCJQGC7YVBz6rRjoHsIDyXculzpbIRvX3EvONDgqeyLKtXzxWPVb5FZxXPrmN/o6CFOw2VY8OWXDhOZt6RYNsurNzk6tv9uDUZMgo8dVlvtjZHWD2v5HyRYczA+fRCah8LlTlRYiGa8YOYjtgHr/z0fRkVZFb40mhZODQa5psSpgaJhinCKt/9V2YZn6+Gs8685qLHUuzjNXlWrqcLgzQp78srwoXkEu3rwvc9TuTdLIBaaCN59tyWbwTKMyG5muqpXuQVefu48gxv2K9e3td/fh8A3rNaykC+DfHbG1PWR+A++Xz7EDQAXomYYaVltnVvlY9DbHnj8NOTL4cma5BTV+X+fz5X6RZXy6BwfLWnnOE+N7PFJk9IjzyF5Y6//qZKESpP0eJD6PGZlS9gv1XbEayeqHz9114tbEOVSQ0uWK+Y2XNIQI/QSKvPy7ZgpXVhMmd87KjmE7RqnvOFi+/ngZcg5do6xhpoqOjsyV6FHAsKF+H7t99pEU+yAbmIjqFlTkY/G07nCoD68A8IMoHOiNiunysi/DSk+WW4KDV5Iz8XqJ3j+B/yB0/ui3rjifm4ZwDvgvOx2DaEmu7bmKWRZqFzqV2cIINmdgXUjr2of/4Pq8Ti2xVYAsX1/s9TgsEE5KhhbGWRhlTupY4mL30zOBbLJ+0BU/qMVK1EncFMuDcJbPGi67xGb5hbRqh1JqwjYqIrxiLbQY2InnOv9ch/KE6BbLznK06XG0U2zbi9EFkaLQlLUTFSmEM0OgRr5Ef3Z6e7M46iuzN5NNvI
 2r0bw0Q2
 1s7+n+CowLYWibEXz8UGgunXJvjQ1E8HdEWQvk2d1zjZ4Wb9j7x4Vk9n/6W+GhQuRNTSZH6O9xXagE12K6CFJYoxEKaUkE3LOXMtnr8PxG/tD+UzUfiPgIQnaRb2in7YHE5BADf8CNFwr1YGtcXXfPR2YUh4+O42RpfHBUlxZylQusa7mT2fibXM6u9gcVp+RqohwhtToYjNTrzjvaOMvUWAM76VN1Ztjiys6y2VhhnSO2zX7F5qnLlT2dy1BAMWhlCfyuUhu6Mqwv+Fqbz+YkuQPxCC0bKfF0SN7kJSqy/SwBWaVae5TDxDmASapKW+E4Z7Vj/Bu9X8iwhQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:32=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Wed, Nov 12, 2025 at 09:58:27AM -0500, Pasha Tatashin wrote:
> > On Wed, Nov 12, 2025 at 8:25=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > Hi Pasha,
> > >
> > > On Tue, Nov 11, 2025 at 03:57:39PM -0500, Pasha Tatashin wrote:
> > > > Hi Mike,
> > > >
> > > > Thank you for review, my comments below:
> > > >
> > > > > > This is why this call is placed first in reboot(), before any
> > > > > > irreversible reboot notifiers or shutdown callbacks are perform=
ed. If
> > > > > > an allocation problem occurs in KHO, the error is simply report=
ed back
> > > > > > to userspace, and the live update update is safely aborted.
> > >
> > > The call to liveupdate_reboot() is just before kernel_kexec(). Why we=
 don't
> > > move it there?
> >
> > Yes, I can move that call into kernel_kexec().
> >
> > > And all the liveupdate_reboot() does if kho_finalize() fails it's mas=
saging
> > > the error value before returning it to userspace. Why kernel_kexec() =
can't
> > > do the same?
> >
> > We could do that. It would look something like this:
> >
> > if (liveupdate_enabled())
> >    kho_finalize();
> >
> > Because we want to do kho_finalize() from kernel_kexec only when we do
> > live update.
> >
> > > > > This is fine. But what I don't like is that we can't use kho with=
out
> > > > > liveupdate. We are making debugfs optional, we have a way to call
> >
> > This is exactly the fix I proposed:
> >
> > 1. When live-update is enabled, always disable "finalize" debugfs API.
> > 2. When live-update is disabled, always enable "finalize" debugfs API.
>
> I don't mind the concept, what I do mind is sprinkling liveupdate_enabled=
()
> in KHO.

Sure, let's just unconditionally do kho_fill_kimage().

> How about we kill debugfs/kho/out/abort and make kho_finalize() overwrite
> an existing FDT if there was any?
>
> Abort was required to allow rollback for subsystems that had kho notifier=
s,
> but now notifiers are gone and kho_abort() only frees the memory
> serialization data. I don't see an issue with kho_finalize() from debugfs
> being a tad slower because of a call to kho_abort() and the liveupdate pa=
th
> anyway won't incur that penalty.

Sounds good to me.

> > > KHO should not call into liveupdate. That's layering violation.
> > > And "stateless KHO" does not really make it stateless, it only remove=
s the
> > > memory serialization from kho_finalize(), but it's still required to =
pack
> > > the FDT.
> >
> > This touches on a point I've raised in the KHO sync meetings: to be
> > effective, the "stateless KHO" work must also make subtree add/remove
> > stateless. There should not be a separate "finalize" state just to
> > finish the FDT. The KHO FDT is tiny (only one page), and there are
> > only a handful of subtrees. Adding and removing subtrees is cheap; we
> > should be able to open FDT, modify it, and finish FDT on every
> > operation. There's no need for a special finalization state at kexec
> > time. KHO should be totally stateless.
>
> And as the first step we can drop 'if (!kho_out.finalized)' from
> kho_fill_kimage(). We might need to massage the check for valid FDT in
> kho_populate() to avoid unnecessary noise, but largely there's no issue
> with always passing KHO data in kimage.

Sounds good, let me work on this patch.

Pasha

