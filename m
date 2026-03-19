Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A173E1090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E515E6B04DE; Thu, 19 Mar 2026 10:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02856B04E0; Thu, 19 Mar 2026 10:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF18B6B04E1; Thu, 19 Mar 2026 10:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB4AE6B04DE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:28:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61D431A0529
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:28:03 +0000 (UTC)
X-FDA: 84563042046.02.2CC3DA0
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id D677E1A0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:28:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fG/AdbOy";
	spf=pass (imf19.hostedemail.com: domain of andybnac@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andybnac@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEYdsi/UQnV1ulkUEVFM3uerucLpRLXH0M0xgNStZdI=;
	b=cCYTrZkz8YDUHm5keaeCQqNrNYPoYXICc++1Ji9FaHwEG43X2sNIvzBr6P1kuYgkDR7ae/
	Xb6xv8bz58lUcGO0BX3HX3n3K2R2G1TPe3+zEyWQfW5R+wdnnANz+0v3xJpQc0SwwFpRZ1
	sR/asddJmV6WWLTKKJBvWqsissxJKdk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fG/AdbOy";
	spf=pass (imf19.hostedemail.com: domain of andybnac@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andybnac@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773930481; a=rsa-sha256;
	cv=pass;
	b=J/NUa4QlHB6efuoK8ybJ5eobW9dr4b1fA5mf49FSGfPkPlgXXvf8euM44/Rwyayii83hPd
	vP+x3j2tOJjI69OnltgQOtV8h9BtUsVBc97PkDd1o4U+M/g0SlWU+iyYfPxhl4/6yma2C0
	O3X0wx03WpwpaE7rUTt26nirY6km8uk=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so155788166b.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773930479; cv=none;
        d=google.com; s=arc-20240605;
        b=aONeyEBbkCvMauMCyD9DT9dN2djrxjvZFruuGRmh6PITcBrJqMIgDoUp+z4UOzuZ4c
         Gh0fAxZ6QVfcqusu/0BH+FtQqPVGB6oI+kRQulZeQbQ03RAhdzT75vGbm8lxRIrDZ4wE
         /u6p9pcJjupD7f+qwC8XbOVWBKokUUdJh/gFy617RokEq68d0cp9CxbdK9ZV5JHyeYsB
         2sJUsFBQnqz7/FL5DrYFxLGcruQSvmVq0c1p4oJ+SAq+It+Et5IYo0c5xjMsN+dhY8sC
         6rCbrWWGKErBLlfj2L3KsbMcsOUtKx3eONhDMMmn9KtkQPRrlRKoiG3sIfAUf4ClWkL/
         afjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wEYdsi/UQnV1ulkUEVFM3uerucLpRLXH0M0xgNStZdI=;
        fh=+Vz9l/66WqfNKuxyOmy0zvjg3meIZgyDLmF55ryD/zc=;
        b=aorVf4SKsmTuAfvqe+P656bUHlwbLrfe800vI6S1R9huHRR6in+85iXddliDea2/qq
         7jMT0JHrJwH5yksix45AY+jhgHUi+8dKb6R/JXgl3ldoGjUYmLklSIEX/n2pS2M+pRSA
         TJ/hooLv2RpVSbACC+7pfjZMrOTjZIMmq7L/a/0tCmJxs0yws28b7bfgQeXKAvXmkpE8
         GH5j6C1VD0Uj1x4MdBWiIKyLKCSf8qq+OGgBYrwfC03D0l+bQoyrpDa1QQa8zbh81euM
         rScE2jzbvl1cU/tbH/YS22MqeyZs6TYbjBDvp5tDeA1Kdn3Qjg1+7VliXRbCmpb3bCUt
         jVUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773930479; x=1774535279; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEYdsi/UQnV1ulkUEVFM3uerucLpRLXH0M0xgNStZdI=;
        b=fG/AdbOyaSkr0y5lJx8e7Xuzk1lp2E4fdUiPEOpNEhWygUafIE5XyCyuz5d8fQBDFd
         YPWbDFi218OmsqkeF1pfJMk9LVwWovt6cRwJjifoH3zGtd3N0NVodd1T9P05gSPbyrxJ
         aiMwynXybbr6xhfE50n6H4hM2sN0VF/R2NoEX5bGJfRYtgtT2wsK8sW8hKwClDI0/n/X
         ySECFBAalsv8QTXGhemeccbfXqlM2Lud7ZhY7K9qt4jxvbzRXCy5KSQzQnKRYDlUjzNj
         ULExpNK+E4m6+6DCkIXyGF6TfN5zz/EJBQhAiaz3jbRnSBZ0/5S9A3lBYICyChiUa1Xa
         OaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773930479; x=1774535279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEYdsi/UQnV1ulkUEVFM3uerucLpRLXH0M0xgNStZdI=;
        b=hiSHdhxTfRZcdkVTRykeUK5V+5TYkcHefS7wgvseBeBHNxqXJTbEep8KzTe2PL1PKJ
         zdMk8Xnl/d5RvKI1v1ux65qf1U+SXdoX/0v/ttNstb3BTQjuK17n3dIYOJ6rLo7u5Vm/
         Gb2aGHvZ8UuU+r8WYBq87FVZreUPfgfNMch/6gMTg9TETb/gX4vNxDMIRVW8P0y++tMz
         1yNwnGmrdFp0RloAaMA9pAG7crldKHvUQDjv85Lp2cMA5sJBJRosoKAKdjAvru8a4Xv1
         t2jB4xvCUo9JQZczgpmR28skQB/OdHPB566ZNQ8qmqt8h53A3rXxfsPkhAJXvMoz8c3+
         U7Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUjF4wCBf+s5TfkjnzDMugS74Q3eKf3hrY8lIX4FI91lZhHDNMoipsX9LVRxbGIBi24+Pj0qDZnCQ==@kvack.org
X-Gm-Message-State: AOJu0Yzxwx9IF7GOpn2VZXrYTc99ojgZUIr5GLcUDoRwqOjGSP+mLtio
	lB7udIytEByfE930jC/1Uqd3R71b1bwsz56fhBn97hf0Gu1YpJ+PVTamHJLUJylciJbR4Srjcrp
	+ENDnlVqJfwHmm2C3LJntoH9G8fQ0AyQ=
X-Gm-Gg: ATEYQzzMmsBgLivZ8JUDnt8+5S0xIdaxv4GyyTPgsZ/xBryNcwdaWuUqjkIcz5lTW9o
	dyA0TI2ZCkVjyj8JJTTEFooP+0NgQoZfoX53cxzL9FUGkOyRcexDNMIKFKsWl05wXq22qJ74RKi
	yPYbe2lM9RI71zO1QRu65Yi3rJO94PjOJwhyNMpGk7C4/tOHbs+DcG9oSmeELPkEHjCBNHOzk2k
	wWyBqTkf5Zwjtf2q+NsCqeU9K9g/criRQP1lSn5LPIwwSrHYbW9MhNLTBx06DEFfoHUEPWCmvAE
	7OGuaxLfzg==
X-Received: by 2002:a17:906:ee83:b0:b96:db93:5d0e with SMTP id
 a640c23a62f3a-b97f4ab7799mr545864466b.41.1773930478856; Thu, 19 Mar 2026
 07:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de> <20260302-at-vector-size-arch-v1-7-a11f03ba2ca8@linutronix.de>
In-Reply-To: <20260302-at-vector-size-arch-v1-7-a11f03ba2ca8@linutronix.de>
From: Andy Chiu <andybnac@gmail.com>
Date: Thu, 19 Mar 2026 09:27:47 -0500
X-Gm-Features: AaiRm52wQD6uRKulnt1Y_ioaRFL-b1bqEKDLHZMA0LYwV13CAWHAV79Bf5laR-o
Message-ID: <CAFTtA3O74BTJz8d87CJFQpa8Sub_ouKyyAB8cTXUxd=BnUzS7Q@mail.gmail.com>
Subject: Re: [PATCH 07/15] RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-alpha@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bgiizcfcitrn3bntsnogdm5ptmqwh7p4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D677E1A0002
X-HE-Tag: 1773930480-579956
X-HE-Meta: U2FsdGVkX19rw1ilnCiWvgTL0K3o/nr1w1k8dKhZe3ogNeoEeGSlAJ4Umw7aR06HjX8v/oE0Uov1p7YVehXVL1ZTTbCyi7KBu/DcxaU8Y0G+PFua1OvNSYGwaS77ELg6vACi+rnm3SjKjFAV5GD+1ANLTCjApxY4qAsH2uVyIACPN+B89o3Ul5hKc2kA5OyUPMc2lmEVsE65/Pasw7C5y3YblCGb2Cae5L+zBYbqYa9rAPiOrmjZSEkbrt6eHlkLxmuyNhAz4OfTqNKNJOhyNwJWT4GrBbaLfaB2Hn/XlsQEDJ9Znp5HlrtKa4n6dJIqYjLacP+Wg3JSau8vC0Kz2zwNXLEXG26+VD54FuI9qZOJeF9rA6t79uT4iNrMG3ve7aT5ncrj3c6Ow4R5MxFwPIMcTPhCiGCUXEr2fNbmNgHIF45M4jP0ZJhQ1zQ46XsRAZw/qX/Sm6KKmPjRR0/nDg9+4WJjbVRiyr73jM1/+oGmRYIGkneg/+va08sU6AN87G2v9LuDFfwBcYEOieBakUYoDxiVWf3AqbydN+z0mMZU3SDXlm31XeIEufUXVyS8iQx8XHEfx5GqwEcAxWyZ9f+KtIU1HrmhTVdgz6xp/kKatUO+D3KJRfvYcAjyejwJ2Z5NBVZvvX1pzMInrFnxrqpTXHSUlHCc2w9Xn1dnrMmrFno09gnRKVH+TqGIgjVD4YtdXKttwrRLiuvJHnM/QFYU3n1o4K8lSLFLLm11T6qwbw26Atk/oW1wed8BWWrHhRdNQMQTBZQBtUpuBiimT7JYHt+zaoJp2BXZdsEounQuoygOpc3iGtoObPgPoZO3U35EzY9lIWKyrNw/OoE3oMDqMPKOjqfFvM3CDYuihaHUHWnt6ehbwba93JxZuE2fxWErA+7ZWc73JCk8iC66nuAIfjyae+yju1KPjEfONrUIjECs1eaibTQF6O0dE7AOlCPGlLyq49EKABicEqE
 Tj75IRX1
 UFylbi+R8hDwOZl5CXVKzstvFZqPPCmupfnWH6hJk6mlDs/YTZXZ3H9ZwJpLAOpw2xkNu1OF71Y8TxEwPFBftIIIb0RBHhO8sB8vYRh7dXQNPckVZgD3u1N9cMMx0xeGJ7w0V6goQirLCMzVSRYKz49OtvuX15H2g8LrANk0UFIINzxYbKm3StDI4RXv0Orwj21SkLqRSMVGskNgWSseuV9wqFRE1bNWDmmdZbO5+Mrvz9u9lLQcoBa2ZC/Pr9DQ5DFw48WpWrpwB1KoPLAAteX/onupa2oyrywCkso9/gYoyt3kRr64wJdGyJ8M6CBJBO/3O2kXklCw2lGwxRf+g8/I42r5R5bD7HxN4huQnwZGznx7mE00GYJe/4Ukm9i+tBzA0JllfYetaLciNZhsPdNmDTHXWWeB+nq8DVB5IpQr/A//asLBLhKGYmYlS7lc30Q0Px7wQKkRmCndaBY5JlYgMwnJY4umyT80l2hzrM3vICA8AlPBHWM1URDsr11Vh9UK8qfXlHtbSpaTMzpRKv49xVh3N2KseqoLo5XWAYGSbMuO2lKG0PMTj/91hVl3BP9aO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 6:27=E2=80=AFAM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> There is nothing userspace can do with this value. In the kernel is
> always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
> userspace and also changes from time to time.
>
> Move the symbol to a kernel-internal header.
>
> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

Reviewed-by: Andy Chiu <andybnac@gmail.com>

> ---
>  arch/riscv/include/asm/auxvec.h      | 13 +++++++++++++
>  arch/riscv/include/uapi/asm/auxvec.h |  2 --
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/auxvec.h b/arch/riscv/include/asm/aux=
vec.h
> new file mode 100644
> index 000000000000..fb4233445276
> --- /dev/null
> +++ b/arch/riscv/include/asm/auxvec.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + * Copyright (C) 2015 Regents of the University of California
> + */
> +
> +#ifndef _ASM_RISCV_AUXVEC_H
> +#define _ASM_RISCV_AUXVEC_H
> +
> +/* entries in ARCH_DLINFO */
> +#define AT_VECTOR_SIZE_ARCH    10
> +
> +#endif /* _UAPI_ASM_RISCV_AUXVEC_H */
> diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/ua=
pi/asm/auxvec.h
> index 95050ebe9ad0..0a725f2aa2e7 100644
> --- a/arch/riscv/include/uapi/asm/auxvec.h
> +++ b/arch/riscv/include/uapi/asm/auxvec.h
> @@ -33,8 +33,6 @@
>  #define AT_L3_CACHESIZE                46
>  #define AT_L3_CACHEGEOMETRY    47
>
> -/* entries in ARCH_DLINFO */
> -#define AT_VECTOR_SIZE_ARCH    10
>  #define AT_MINSIGSTKSZ         51
>
>  #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
>
> --
> 2.53.0
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

