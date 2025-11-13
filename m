Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE029CD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495B48E001C; Thu, 13 Nov 2025 15:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445738E0003; Thu, 13 Nov 2025 15:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3356F8E001C; Thu, 13 Nov 2025 15:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20BF28E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:14:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C002E14014D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:14:01 +0000 (UTC)
X-FDA: 84106685082.01.4356C3D
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0220440014
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:13:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Di054Tsu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763064840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5WVCcQA0Nc9ynxNx/rxTvZahrW/VbsfxFWCQnWaLJk=;
	b=x3llH4dTOLHDVkwLTrArVEcPHzJG8cMwKKsFEz3ZsKyfnTgpNblFe3kjincQBGgQmz6SsN
	XH/mYjdYyjV1MlaW1FfgKhGbZ1N7NusRGtImaNQSVAeSoOC26pcXPmQMRv4S1WQmwijwI3
	R8B/dvTHq3LF5tOjdWjkPBs1wGEyjUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763064840; a=rsa-sha256;
	cv=none;
	b=BliFhpBHa6WCIZpMcpl+3d2uRjbym+ru9rhBbMRTLeXsCgNBdnMqnSyZ36gtQBArzW3tN7
	0dW7GP5l1X43CllmIoytGyZhxLBDXA4z6+lYKESeDd6EK342zjC9FBKW2TTv0QO4Fm5SbU
	G2TLTNfLZO0Lxp50yqvWEu5csIyZT1E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Di054Tsu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so1968131a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763064838; x=1763669638; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5WVCcQA0Nc9ynxNx/rxTvZahrW/VbsfxFWCQnWaLJk=;
        b=Di054Tsutb/kPgXXFf9T/iI8vaGZZKQhkrahqkHgpFanUOJIDECIKdcYflikyVOyLv
         j83jggi7UYD7wzG7JMr3jkdRsfMwRzOdOkPyb7g+9vAOxloneSmCTI7MhFebFjpqTfA1
         WeDk4OTMNgBlvaf/W5lqDIjeyQWZ6EVjbTm5tKLhDO1OmxwJNxiyFXKvftzqQivpN5BB
         GDEdey3415uxLhEt+IYJFqrRzF4DBWccnO0mIGQe843bWHGCkJHNYV7yaWknsXtwuXuG
         kHWk1jTaqVDfjbf6iNt8eG69ZCD2Rf5PDBV8ZeSctZPteoFCIqOSnL67mp/IOPRLtQ3E
         G38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763064838; x=1763669638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f5WVCcQA0Nc9ynxNx/rxTvZahrW/VbsfxFWCQnWaLJk=;
        b=Dmx/b68HVTlj8LCjDdcKR8JKI+M9wEvtIHKyl8MLtS3LIVPKK44Cd7NQq+8YYXOxSt
         lQyGRq9UMaIfwbv87+weQG+MCzik6RmoFw/jbyI3K8UodXNqOYoFiSaE/MmFu4NWnYFj
         8nxv2NGsaByayp4BROZyeN4g2RCIdXTnzSVLLAU6sfWX1YkmbsVFWySJEqBewt+9IQoE
         A555tAaU17KgnehcUEna6AhcTD3oSStBoDj/Vx0PIHb4cRNtdlRLEc22UsWerhrCPaq8
         r2lBlklAhrc8EHdoCkFViZoO9j1ZXGcAp6xSSodwTz3W8C2/iRv2GLRYUagGcrDhsEIe
         6iAA==
X-Forwarded-Encrypted: i=1; AJvYcCWC9MAVej62ydN+3ES8nHScJoTOxQis3gQ2527LmhWZVVdzyuvCqHLhJUWT026liZvXIbP1UtPf6A==@kvack.org
X-Gm-Message-State: AOJu0YzbD2QvYqJ75O+pT2Qax8B35fRuqelvfOFp/FpRUmL0rlhhmGN4
	9wXMI0Fy+HH0S39PruoGC5g2Wz4iwAojACJXUHu+Dwx/fAC4SjXu+n445AXB/UZSF39M6wu6pYx
	uAEGEfc0TyqJUKo7421nDoqNtbKiYVhE4fTkuuyWOFQ==
X-Gm-Gg: ASbGnctjzHVDADTZhVqSrqbEpxabQ5kNpNKHEWHzzWXzSOGNYYAlU2Rvpi2LlpDMMg1
	ZE/U0Ug7z7ohe5a5tNxt+y/y0ihFrATWVYVbQc8yFXfdQ7r/g9lK5PCNaYr3wZ/fc0A9VrURvex
	KZbt+4e/jw6HOL85wahtZfzczl6dUgZdr9yialrYrezWyxpeQwhDi7dOkDyivKhaAFZL1Sb5qI7
	5nTtpNEojrB6GWD8akCKG/Him5usgjSFSvVYnBUpUsdw4FF2yCyrBLr9g==
X-Google-Smtp-Source: AGHT+IHk2DiUUy/xNwDtwZautO7acJDvr0M6jMmicQX7WgglAjHdW5I4cD1JskoIx/tv/1OALKLJImDpFRebYAI4FVg=
X-Received: by 2002:a05:6402:3506:b0:640:9b62:a8bb with SMTP id
 4fb4d7f45d1cf-64350e89ad2mr411863a12.22.1763064838507; Thu, 13 Nov 2025
 12:13:58 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev> <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev> <mafs0qzu69gei.fsf@kernel.org>
 <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com>
 <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev> <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
 <9e144e21-a5e7-4c12-b8b0-07172787ab37@linux.dev> <CA+CK2bBQxB7ihmhBa76vJbdD988B+8PBrV4arDSNqjv_VB4DVw@mail.gmail.com>
In-Reply-To: <CA+CK2bBQxB7ihmhBa76vJbdD988B+8PBrV4arDSNqjv_VB4DVw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 15:13:20 -0500
X-Gm-Features: AWmQ_bk1wk0wGCneUvxEMQLoqh3QSRk09hjuZwzxox1hVPC9Dl6J8B2vKcwHXN0
Message-ID: <CA+CK2bCUN6SH7x=DnTFvCgEYGKoyOrCMzwQjHCY0LK35Hd-_zA@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 94o5stnmyeuxe5i54yse6e9168uhjp9b
X-Rspam-User: 
X-Rspamd-Queue-Id: 0220440014
X-Rspamd-Server: rspam10
X-HE-Tag: 1763064839-494917
X-HE-Meta: U2FsdGVkX18NOfyi+GbJMD6KWy74p5MNeDDoH7O05WiTcTkGLBxo7Ve95F9PqUPLVAMfGY7FSAczCBsSdZOUl7CQ70H7HlfExTKtYJKvxYFyFv8q9DYaz5VTTUf1igJNyn1/SBcj5SViTMN9FQX8s3POvnXzy7Ltcza2e2qPuA8wHHGdWbQdjFAC8VVH1W5h0p4Z/OFAOTdgaPAXIHjRMgziJO424AEC8LumQ2m7Wvn9IcQW3Q3Iux47DqQrjVK7Cgz3PuzAih8QxlCSbDZwf/O+bNJpf4k+Hy/qCPdsXtrnklQxX8J5vevOJB9QFwuoAW26pcPn0/Ol6rn5I9pJIhPsM+z9t1rGom9J09km+NGbN3P58Jr27QHiwjFYkF0AmjBwL9wUa89Xu9kRodwrW0GerQgZTPBNZ+OvQ8T68sKHAAkmix+as9GTj3JxQWrI3dxm1byesvrpG9bUffQZi7GqG3IC5RwUof9/GaT2F/e4CnYt4liuNoQ6Pnrswek5AjuNZrrH+CtjMNRmhrAZbOU4deeG7btUaP1Ea1QbrNpuRlV41DkhadLVV2nOvdte1hp2tnGKtAxfTw2qTLowGOuVw9NTaIUoB9SIewmBFZOYeIXUnJ5JhSI3XgNrgp3z6bBfhJo4RpTXqVEbuKDwLoDdLWaJlF47HP3lMfDA7M70d727X6AmKoGGAwn6TieefBEsazOYulJM+MtkTdJh9iVZGdj4Wzvhl19TIhDaV2dq/0Q1mBgRFguYsQdgl5j9x58AcBkEz6a6Yw4R2EFgITuPyLmMPns4AoosI7ZzbeO3RU8BMCVXSR4IK4tAb+kucM36oS10/MuTLhmZ68uQKKlzQR85YJFld282K03m1ft0dgguKFSy1khtkBKd9TLvp+aCxXm0Jx1MXUHtwRt/pknF2cv9omLK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 3:10=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> >   set -e
> >
> > -kexec -l -s --reuse-cmdline /boot/bzImage
> > +kexec -l -s --reuse-cmdline /boot/bzImage --initrd
> > /boot/initramfs-`uname -r`.img
>
> Thank you for your suggestion, in the next version, I am going to add
> initramfs optionally, I am thinking to update script to something like

Optionally, because in some environments (like in mine), it is built
into bzImage.

> this:
>
> #!/bin/sh
> # SPDX-License-Identifier: GPL-2.0
> set -e
>
> # Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramfs
>
> KERNEL=3D"${KERNEL:-/boot/bzImage}"
> set -- -l -s --reuse-cmdline "$KERNEL"
>
> INITRAMFS=3D"${INITRAMFS:-/boot/initramfs}"
> if [ -f "$INITRAMFS" ]; then
>     set -- "$@" --initrd=3D"$INITRAMFS"
> fi
>
> kexec "$@"
> kexec -e

