Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BD3CFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 19:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5D86B000D; Sat, 29 Nov 2025 14:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F4F6B0010; Sat, 29 Nov 2025 14:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606AE6B0012; Sat, 29 Nov 2025 14:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4CE6B000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 14:52:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED2F2BCCB8
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 19:52:09 +0000 (UTC)
X-FDA: 84164690778.08.FAFEA20
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 109281C0003
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 19:52:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ap4MYF7i;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764445928; a=rsa-sha256;
	cv=none;
	b=UOScMNHJFbEMogoYjZdCQSJ383jawRLMpOi0+uhiECsE7U9HvQ56umsOdEtI4QEI2nnnsf
	WelUbiF84hZjjJPGSPiWXrL89cSBKZf8NuRc0qlNes/uQ7Y1U5nov6tiZhcTIixT3eiuLZ
	xERqlCKpqoiyQfN+o2J2/asLm/3YTZc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ap4MYF7i;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764445928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUeLWvyACxGaCf4GzfDj2Zf5qGJH4Y9rmObQPo3NL+0=;
	b=3uWBsJGto6N4osWBwPEi9nDvAJw6+rlwdtvji2gT2ooxS0RJy5eUPINbGuZFa1qz74dj8M
	LN2VWpRKtCOzRQVypt4UJdBvHqjxatWfXm8DauTyNDKrVMswiXy4DNeoD5uYLN8Illpot+
	Rnw+ZL7ZXoAjC2M8MpEu2S88+F7cOxQ=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so4422010a12.0
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 11:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764445926; x=1765050726; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUeLWvyACxGaCf4GzfDj2Zf5qGJH4Y9rmObQPo3NL+0=;
        b=Ap4MYF7ii/2ydk30RRCCqIarB823qdBxnPHwAm4bAvDRp2+XRZx5tMrKcTkndRF4Rn
         o47U0uduH+GfFP5iX9PbvzDfehZG28GsAm/NqP8ocfuJCbD/jTp5uYopR0G4gn/z9gJy
         8KD3gebHu3r7rUWHHag0ZYklytnfnklDbab8SkJrK1C+6WXBjydFheESv1TzVYp5ro2t
         G0Sw+eyImeaWkzyhQGSDW/k5GHfJLQSgwyVungJlO3l81T1wzhA2JaH5W3Y00QmgeP2U
         zJl6VOnb9l4PqTFkyvvHp6seQ9tOSqJwsulypJDgUKd8V9Lr7xK/zKkZeXC57KY5MAyy
         RTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764445926; x=1765050726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YUeLWvyACxGaCf4GzfDj2Zf5qGJH4Y9rmObQPo3NL+0=;
        b=JnBmFGvDl/7pieC0Mxvcqq2innFkGhU2x/AsVa9kOOCNVlUmXqqhVYkrkL1Q5JOm51
         jqdmvI41VAElEmRqVGYLxVUhNNt1Xk7u6ByrjiwA814AYfLYBMW2JA5kYbdfqUNthAmm
         XH2Y7tj248Cv7VPU/7rKm3wgrVqmaVmpLMWK6WCh70nY9KwQVjwGVB8J2DFhn26n7IFj
         wPgWnz+vj3HmdPh2PSXaf0pSwUp/hVUV0PTYk0CH7W0MWV1cworfrX5V+1v+byL9b5Pw
         x4jpPKeZJfxw7HzDYnzQwOxYSUnkhxrCug1Gg1/Rxq7g5+qF0AnSctvN+DXBUqkwcP6i
         Q53Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLJ+YRDhKHuBtZG3zm4mIVb/VFlUONOlPXioGIggiRaXqkjrGTtsL+bdq+qzWqKUD69M+U1fbgsw==@kvack.org
X-Gm-Message-State: AOJu0YycQjnhBO4y9IK09TUAjQKELYDpKh96pQ2aHDiwUSqg4+uDmjkx
	WUj+adOKL6pZZPvB2/tROu65AdLlaW9LlNfJVwRNHRFu/uZlO6GWts1j22IQZI3YDFEp69TEozE
	KOH2GTRwuxlGAcalHMF9GQFM8+1VZqshlYGkRa/3f4g==
X-Gm-Gg: ASbGncvIbDshnzxTvyGTfm3fxRpR+ZsqebTso4MVbbYKWaWAyGN9c7qS0kqMMpRHB8z
	KqUpqkQTOrSJVCLDnE4722Hoshudo0eKoGTmlO1JrbsDW4cHFoxSNafST14jet8HXHYEjHZ/nK9
	QwelccQ4Gi9qDNVXZLO9KsY8Gi8Vp5PImPrdGI/684dTYF8hN0t/S1p1oWLzpQRJXUVwcTffNS2
	8k3Z84WdqSUGH1l4M0yqX0cMUv2dHRZXd2qG1IwKv7CVcR5HrRBTt+aXl2uwEReXEN/
X-Google-Smtp-Source: AGHT+IFrwqbaIeWdJib8FrG2mDeH9cpmV3Xd1JNcESoDRG6rLym64mFEzXP+GMLcdbvXtvEDkr4BWumbOiH/BtJqycw=
X-Received: by 2002:a05:6402:1ed2:b0:640:8348:6a82 with SMTP id
 4fb4d7f45d1cf-645eb7872afmr16547077a12.24.1764445925596; Sat, 29 Nov 2025
 11:52:05 -0800 (PST)
MIME-Version: 1.0
References: <202511280300.6pvBmXUS-lkp@intel.com>
In-Reply-To: <202511280300.6pvBmXUS-lkp@intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 29 Nov 2025 14:51:28 -0500
X-Gm-Features: AWmQ_bnFhg4fTSb2cmgYMQtzbTBVTpNXxCQJRN9-QkYD3rk0FAtL0ZYOt9H_zqA
Message-ID: <CA+CK2bCmp4gjpyND2=Chdz-EfRAF20unYzO2dwQb+ZTEihgk3w@mail.gmail.com>
Subject: Re: [linux-next:master 12118/12398] kernel/liveupdate/luo_core.c:402
 luo_ioctl() warn: unsigned 'nr' is never less than zero.
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 109281C0003
X-Stat-Signature: eu3dfppmxtrqbdzrpmrmzfcun7ucp4mz
X-Rspam-User: 
X-HE-Tag: 1764445927-496187
X-HE-Meta: U2FsdGVkX1/Y7VmJHzVF6RpRs9m+I+g/xfcNOzHBW0I/hJw1q5ptKudvEzzHmP7Y8HSBUSVE6OnWXdRNzWLRz/HexLt3BgjlERjm0VThx0kP+X/h4SJ3Rg0y29gApkYQXRy04vcJ0iMT4rS9Jpzcz1DUwiuju5Of+VY/unxzOyXLa5os/Jl9vAQJHsVWRA8YbpD2KucWH5gQtgmADeU4x9oe7A74LjVzRIm58Ma5XkWJFF6uNnzBd7Nffk5uCxSG1UpY/5Lup/+CmqU6k5CLWaYf0/AkUP/GsDA8QNBon+ZPfb5eE4mGALN9tsILbd0tGEl0djgHwQhh+DIa5QgysBYMGuMWIKmsv4wfmjPJq1I61hutmIR9Sqmp1fbMEjX5h+Xa4s2QKrn7jWWSfbTaW4e0fr0oCqPavOiHL1yEK1To87bZY6JOLnzaVKe4olq8CTws43x7fUJDMDtpD/2TCq7eZ0SqzqE/GP7b5M/GNanoFQwZTpsbQXZReDDfuan3PfgSm8gVFwo3XN3HYBAcZvfcfQC5B5GKUEP5b6DWF+Wp+SE3FdfXyM3mgLoU+Mqpc+E2iZt6Ef6WDGLBD45uNWe77P0JFkhnjcrn6SlJ4iwJMAnRvA81suB1zGHYuwqJYSGGWTFk1NnBNTIZ5jok3juysYDncUqAQ6h035JSqJLFgmPBnRsLVmoFg8RNo/W9+Lr4j7EngeCaZxqVyxgu72T1OFBuGKE4B7iodr0wgY/CZch8ocictXERZdj1VpjGLhGABkSS9+MGuiRmV/9R54W0GQfc6suaV8dx2VMbT1T6JFzEfB3eC4NHqtDxsXao4riYlYc2vXrSuBp01/xs/ElW/AuvhM+c/EzI2lKg3fm7BDhOJdPNJ7j38ZTbgWRhfldzX9wMakhVCKocCdash0QD4RsuciwBwtriwrQAXhWip0sJ0H0Eu84GgXSG3bt+qL1XEgQwt9Qjdc98yxK
 ww0rfhzh
 Vt9eb4FbMPPNyf7zMUZ/r0W0sOkevJ8RcQ0/5dKIQHsJ0z0YUlP7BPBIVbFU96Q1liAHJs5vJp2xMsuoNhkoWT+qsc70I9Fe7O9aCtDgm+8vWNgDYZ4biM6p3RqPvBdJpYJsn2xTyVwdNWWeLTwA279KVjym3DhfoXAtAHwM0/rPy2cgnMdgj2gAA3I7m/OZXVDokfRU7PX/4xwz57cSveRxQq3pSiLptqMbW4f6PYfCD7YfzOuGy2qxz9gO6bS+CW9Vb778WnS7S8STwFPA6jn3xpVU4FUoIe+Y/1TRSKFZHLcISDpyzLufoauc+KLqtFHJVCVl+fuEuo7mfel8v0JDWxzXfFbp6GEeciySvjdqh2LU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 2:29=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   ef68bf704646690aba5e81c2f7be8d6ef13d7ad8
> commit: b30a1fee674c8446bebd9e399b267ac824093bc8 [12118/12398] liveupdate=
: luo_core: add user interface
> config: x86_64-randconfig-161-20251127 (https://download.01.org/0day-ci/a=
rchive/20251128/202511280300.6pvBmXUS-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0=
227cb60147a26a1eeb4fb06e3b505e9c7261)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp=
@intel.com/
>
> smatch warnings:
> kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is never=
 less than zero.
>
> vim +/nr +402 kernel/liveupdate/luo_core.c
>
>    392
>    393  static long luo_ioctl(struct file *filep, unsigned int cmd, unsig=
ned long arg)
>    394  {
>    395          const struct luo_ioctl_op *op;
>    396          struct luo_ucmd ucmd =3D {};
>    397          union ucmd_buffer buf;
>    398          unsigned int nr;
>    399          int err;
>    400
>    401          nr =3D _IOC_NR(cmd);
>  > 402          if (nr < LIVEUPDATE_CMD_BASE ||
>    403              (nr - LIVEUPDATE_CMD_BASE) >=3D ARRAY_SIZE(luo_ioctl_=
ops)) {

This is a false positive. The logic is designed to work generically
for any base, similar to how it is handled in session ioctl and
iommufd ictl. The warning only triggers because LIVEUPDATE_CMD_BASE
happens to be 0 in this specific case.

>    404                  return -EINVAL;
>    405          }
>    406
>    407          ucmd.ubuffer =3D (void __user *)arg;
>    408          err =3D get_user(ucmd.user_size, (u32 __user *)ucmd.ubuff=
er);
>    409          if (err)
>    410                  return err;
>    411
>    412          op =3D &luo_ioctl_ops[nr - LIVEUPDATE_CMD_BASE];
>    413          if (op->ioctl_num !=3D cmd)
>    414                  return -ENOIOCTLCMD;
>    415          if (ucmd.user_size < op->min_size)
>    416                  return -EINVAL;
>    417
>    418          ucmd.cmd =3D &buf;
>    419          err =3D copy_struct_from_user(ucmd.cmd, op->size, ucmd.ub=
uffer,
>    420                                      ucmd.user_size);
>    421          if (err)
>    422                  return err;
>    423
>    424          return op->execute(&ucmd);
>    425  }
>    426
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

