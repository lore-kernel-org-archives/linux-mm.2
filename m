Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4964FCD4842
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E418E0009; Wed, 12 Nov 2025 15:47:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A663A8E0006; Wed, 12 Nov 2025 15:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C948E0009; Wed, 12 Nov 2025 15:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8722A8E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:47:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BD771606D4
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:46 +0000 (UTC)
X-FDA: 84103141332.17.60889B2
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3784EA0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=chvQossl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762980464; a=rsa-sha256;
	cv=none;
	b=dQZovMSyiq5j2p6PQZB1hOVccrSHlBNMwGVDm2JzktIls7k2qPi+oCwSB9q4gsAWsU4aXO
	5X9JtW8641R03bxW1/0eUoI1YLYToe7WKhLYaIdP1SNCkbXV8Cmzr0DxTtbEBS1LiyVzQ9
	hJ5GEBqi57+eAD7XPa+pMog7H3Wsp34=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=chvQossl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762980464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dB48jiAJQmCTSUKKfFbF2w4Wvbq8+BICA0uZNvppCf0=;
	b=LIVKWdcfz1WDPdKKXx1abVGm/vIeiWQd4DnX0klDSTnc8jhrnT9pMfXr6P6G4Afbv74xbz
	T/y/Un3fYeHxmHbUByxdrdJRVAHkDaTDQie2CXNWGvdy1YYqMn4RuVBTbgccKPHrCfgAp0
	bMqJUG+EkRfUAT8uBWt0rDSr9rJ+Fec=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso279504a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762980462; x=1763585262; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dB48jiAJQmCTSUKKfFbF2w4Wvbq8+BICA0uZNvppCf0=;
        b=chvQosslxoEYV6YTkdH52Eqt/ngka6IEb/1m+iqnbgB/9pidlAdWHppnq0QPnP2cFv
         O6Elv3KS3YmNo4WQTol4MSIyOef63zN0Zms+68PP67sb9NnblKEORWWHyzCnhphg/YLL
         7zCGgCvLf37CsHr2jyKmHhReXAoJsxUpRX8jPNROAcnSl5X3A0dQPX6QuTmewG+uKy6c
         0R+72caq6WPuI1Z9DA3IQKKwP9bzINKt1Z2QOJV5d7pR0e7l9lHqHjo2De3OFcG78TNa
         BWBgVOFcswlcoInOJ2i9U5fF0Oju0TddwGaqI5OJaVEz+DbzxmyT2Fbv0gNEuJHxghKT
         BEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762980462; x=1763585262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dB48jiAJQmCTSUKKfFbF2w4Wvbq8+BICA0uZNvppCf0=;
        b=Aspws6/d9tP9nKCYEqUYPW4ye2vIelEz7w+JdVyV+LdKQkYrX7fvlSy20RHYpb7jHT
         Q1ymWSC+8+JHcyfxnL6YzomZmScsVZsPxg1vUc1JbPeUOW5InsA4IBQoTKp6HoksO93q
         hbkcZ644Ma2w48/JA1SozzZbyZmiooCP0TkqpmKUNz9BXVok1EwxqXXDSY/W0trX07mv
         yEzlSfBCbOAN/EImxPqXy2szrrR4PnOC//LVqBzuYwTlRrBvCz4f6v+HV49ZUmTE0CW5
         9dBRrLEWM4OOd2vf3PG2k8bXpFUSJnc0CFnW3wc8JJpo5nRGTtBPupq6PWex4RNoCxi0
         xlhA==
X-Forwarded-Encrypted: i=1; AJvYcCVJfh4uOf2AiWxCxDxy7OSzPxj6EX2+U4J7Z7xmfTi2gGjAyVMzauuYmaaQuV54e3FrC7AUhatIpw==@kvack.org
X-Gm-Message-State: AOJu0Yybro/yzZ7YJ0AP3C7fs0cH0SAGHm9SBslXn/6Jr8P85ZPDK0ul
	eDk+kryu4Il5iI/o0QcX0q1gjwt8ZCxRO4IArdwQYL/+v4yASwkJ/fbianJ+Wtub+vIvyHwju9D
	WmXmbBVo2DNvMRD34oAaA4NtvxJow8ZRZchu1yHnAgA==
X-Gm-Gg: ASbGncuY8Gza2z0LgcBvSBLremiCraD3bfZl3FY/Mp8xKZ3h66Od33lpDOAm0eBQzve
	a9ucRDqK/W20xRkAf7o+xoDgvAnY9u59b+gIS34ZY/pPsN7RQYDGG7pY/reXKP20j0WwZG3lbQV
	8d/mQIcFcq3z/dNnucKyZQ6WP/mE9A8ZkjewC4PZ4tGDSCk+FB1ByGNov6l4c/0X1IBktCbDvh2
	MpxRiA3HwXGR1HSxgBl/z0y9YbxIHD+3Vj0zO/jj4RGvkWxFGpnpB32NQ==
X-Google-Smtp-Source: AGHT+IHnCxJ5sXULWNZ4xyt6eOXGzcL5bRRpxTbpBkagcIsWqapM9iv+G712dgCOMjYDLl8hNWljgh4gZ1/4nXWnvWg=
X-Received: by 2002:a05:6402:280d:b0:641:270:2c8a with SMTP id
 4fb4d7f45d1cf-64334ce2bf2mr656038a12.14.1762980462571; Wed, 12 Nov 2025
 12:47:42 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-7-pasha.tatashin@soleen.com> <aRTwZNKFvDqb1NG5@kernel.org>
In-Reply-To: <aRTwZNKFvDqb1NG5@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 12 Nov 2025 15:47:05 -0500
X-Gm-Features: AWmQ_bkVh8Sk3xM0csiNTGOKzpW_RilqarlOG4vqEffeEKya7lO37kZmCW2_pO8
Message-ID: <CA+CK2bAhJ+Lbm6v375RuZKs40q34gsKHE-N+dD8gKqgzsHCqww@mail.gmail.com>
Subject: Re: [PATCH v5 06/22] liveupdate: luo_session: add sessions support
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
X-Rspamd-Queue-Id: 3784EA0009
X-Stat-Signature: 4d7cub1s86mb7ptowwoyzi6qgsa6q5qg
X-HE-Tag: 1762980464-562466
X-HE-Meta: U2FsdGVkX1/SAF+lDpCxvyqqZFBnJljbi0CwB55qOuidFth/eHfFJpkfYu62DQLj6P1UMIuGPEtIGzdnAFu2n+zxSaZTppp1LZMOVQnM5l8G1GEzTgetMBEltqmzejJ8t1CGVloF/n9cCglWoJOBFeqterfNqOHWzhmoAt26f1sRVdPytLQTH66AC6iJO+id9SK5DAf2TUslPLSClIthHJWJps41nAVpPxH03SlWQcHVPmw7LJK9i5m8N5Twb6YrHG7PWt1pJTz84eQ5HoOgvoKI3/H4dnPTbbzOp7Lh7V6fBFX/3gxAmW3gFM4+wLFi+jABh4gSpMQUFCqWTm62hqRTeUPlQEFYWnhZeGqhqKAPLzI1+Gz0FJD1vlV8JaohQR/hz0+Eba2ETV9uPlBW3XM7CGkHqc5hda7WXhciokM2V3tsviZLvRqPXFgji9Sq8Z7j2Yz+k0rVSRfxj05EVsJhnT8/gm2gEWy17/G8fMaSzOk75Xi15xTpWiEHYw8cyNf1/ADqGNz8CuBjBsw5xghAEUPFM3iJcquBrhvwbbAysDFPJVt3lWsZ/AwRM9hxUDiRMObLWAWP23xiVPi8x+Fjq20oRIdL06IvoRtSGOVZdFpdY4TGZclKonDYZ1jPLlhmxi/8aJkPr3jUc2XJUFqu3rhgHipPyHS1y2u1lDS4HN+Gj/2Y7G9FnVUqDcoe6FUcJF1e71p/luMRpCuVBdZkZ29Ury0agkPc1wld/6tzNRizsuNDSyhv/tDiLrXOdx58iGmdAwdAVUWH8s738vPhbulLhJKscucZxsTNGktA6GuRTp6mnVY57eY015A73P0mubbj/fD4MXt1ECa1vudS8/aS0vu7cc8EjbJhu/dlNTv1PurqNhdrgddinEC+80B6TkkraHFTMvhJ5wYBw+OMtawRIgj821k3h6O94SEwTHe3UqkELTlqeM1Xkal+iCeRuEvWc8KO7e6isak
 yjMAXpCk
 YhXwMEt1KG/h5aKTO/RW3Tv0EmaVtaRaZzCcQp9xh6vqmqGATz3Xa5Cf3Z2xB+aiUq9LyMdMfe4VuMqujWAsoiRcBCOgo4b+lItbPsmnlnF5kqp4p+2+PGZCGLW8M1oUHW1akZuXN0BGLgE55d84mWZ1IalyCm8SW/VosQpP0sxWemo6JUzXLnU5vvAH6g6WXk1ZQrp50nUtuFy9Wm9/4hcRGB9NJShMjaMtsV6o4EwScRGQLcf9wyNlt7kdPrbSwRadzoxLfRhJzo92fK9ni2/n1o4+46F0+n2e6eaHHgCyzosTNcdLcdpp+FGgnwWyBC32O3r9OgzUTXsA+HxoS+u/Oi6KYH+566qkW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 3:39=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 07, 2025 at 04:03:04PM -0500, Pasha Tatashin wrote:
> > Introduce concept of "Live Update Sessions" within the LUO framework.
> > LUO sessions provide a mechanism to group and manage `struct file *`
> > instances (representing file descriptors) that need to be preserved
> > across a kexec-based live update.
> >
> > Each session is identified by a unique name and acts as a container
> > for file objects whose state is critical to a userspace workload, such
> > as a virtual machine or a high-performance database, aiming to maintain
> > their functionality across a kernel transition.
> >
> > This groundwork establishes the framework for preserving file-backed
> > state across kernel updates, with the actual file data preservation
> > mechanisms to be implemented in subsequent patches.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/liveupdate/abi/luo.h |  81 ++++++
> >  include/uapi/linux/liveupdate.h    |   3 +
> >  kernel/liveupdate/Makefile         |   3 +-
> >  kernel/liveupdate/luo_core.c       |   9 +
> >  kernel/liveupdate/luo_internal.h   |  39 +++
> >  kernel/liveupdate/luo_session.c    | 405 +++++++++++++++++++++++++++++
> >  6 files changed, 539 insertions(+), 1 deletion(-)
> >  create mode 100644 kernel/liveupdate/luo_session.c
> >
> > diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupd=
ate/abi/luo.h
> > index 9483a294287f..37b9fecef3f7 100644
> > --- a/include/linux/liveupdate/abi/luo.h
> > +++ b/include/linux/liveupdate/abi/luo.h
> > @@ -28,6 +28,11 @@
> >   *     / {
> >   *         compatible =3D "luo-v1";
> >   *         liveupdate-number =3D <...>;
> > + *
> > + *         luo-session {
> > + *             compatible =3D "luo-session-v1";
> > + *             luo-session-head =3D <phys_addr_of_session_head_ser>;
>
> 'head' reads to me as list head rather than a header. I'd use 'hdr' for t=
he
> latter.

Or just use the full name: "header" ? It is not too long as well.

Pasha

>
> --
> Sincerely yours,
> Mike.

