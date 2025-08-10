Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB650C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 14:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A5B6B00B5; Sun, 10 Aug 2025 10:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772196B00B6; Sun, 10 Aug 2025 10:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6880B6B00B7; Sun, 10 Aug 2025 10:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 501CB6B00B5
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 10:34:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF6011A0528
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:34:32 +0000 (UTC)
X-FDA: 83761093584.27.029AC02
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 09BBF40006
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:34:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bE/b6jb8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chenhuacai@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754836471; a=rsa-sha256;
	cv=none;
	b=RkFYvOhYweQT7m1+aSuDo8SErQJg56OkSTR7S2Dn4LxQULVVD7qQUF/g5qB74dgSSaYGS/
	O5B/JqJLqTm5a5hdhPGWNz1267Tqqb1mUBySxns9eXGJ6VRekTGlCYDryDfSt442+h8wz7
	gAPiMKAzTaIE50H5etBmU+5rkmUYhGE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bE/b6jb8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of chenhuacai@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754836471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifH3Ecmw1QsoyRMJWkehe3NqX8B/gPIoSIFYx2/dAFw=;
	b=j1DQfFxNVal6gDXCFJXSrM6nCRM095iLFNcCl8LhcS+cTfSB90OhA/uXWdctJyYgVfN1XP
	91XfEX/++NfZjdssGIwonQ3l289HPg5ASaRj6Jad56pPUD346fTvaC2SUGHrlqCAmgJxZI
	vvlLoDW+bbuMUjZw2QndjS9WEWleYWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4ABB9A526F6
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ED4C4CEF6
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754836469;
	bh=Vs6zCVzNYOOBeaFgHyVlLxbYIuRdFhTAig9mwdgEfDQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bE/b6jb8qYgeLQqPPzjS7lIcQt7MSLTioMwQiWOl4zLFfoQVSokaOMVi0HbJ+q99U
	 1HhhWeTBO/p9pYEfQ2T3irZMpCLD3c/n1e216b7sH8xAJ2NFPo16mtxeFJgNTfBxWV
	 GMeL/6fSnEIR8DXApCWYNRqWkFEuBMtfkVRziWWctxZZEM1xYTbx6/B6aGqH5iX+JQ
	 pqrqutzB0iftz3Xkdg171jGKWT6+wx+8a+/rc5NKdjbJzfpenaOVB/gqHT4/nOAvx8
	 Fy4g+IRIogu8REQOk9flilF1eSzWQLi0zqj6TnbEz4StoUq3nqnZiafwNtHBhkuzVo
	 XcZpRvEquyhHQ==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6182ea5a6c0so131583a12.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 07:34:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUYYa198Gd7kD8pXKusd5qLYrp4ivULztu745CQmGSoaAS/nrmRI1+4ecG/stxpL7UDAr1nmQLuFQ==@kvack.org
X-Gm-Message-State: AOJu0YykXtDZEFTcjzrlnFBeu50LZ7mE/5UMy4QG4aO0c8JxwYkZgLal
	kE8IE9lj28NC/FerY0f4p/3Tw5baxJz2lMH9IotHuelPyEKEiFTG0MobgSumOezgKmn8XPWST5p
	VGRp0UdzNOum3lu7Y6t4ux2dkzs0TpQ0=
X-Google-Smtp-Source: AGHT+IG4o84/rM7QVQPWh7TEB1TD66BC3/NtSFnHTksgcfeKzFYNg4vkE3t6ZzTFlBzTgE7WDqS1OXBxCK5OvRJhOis=
X-Received: by 2002:a17:906:d542:b0:af9:1ee4:a30c with SMTP id
 a640c23a62f3a-af9c64d3cfbmr962040166b.36.1754836468386; Sun, 10 Aug 2025
 07:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250721101343.3283480-1-chenhuacai@loongson.cn>
In-Reply-To: <20250721101343.3283480-1-chenhuacai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 10 Aug 2025 22:34:10 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4TToP7AY8yMUjikTLChMpMQMB1=HRaMDS7Ern5nf92Fg@mail.gmail.com>
X-Gm-Features: Ac12FXxpVhYI7CqxcRy_NIXh4NRe49UwUMvXTV70a1B4VMSu132CrmAPg_2WB9I
Message-ID: <CAAhV-H4TToP7AY8yMUjikTLChMpMQMB1=HRaMDS7Ern5nf92Fg@mail.gmail.com>
Subject: Re: [PATCH V3] init: Handle bootloader identifier in kernel parameters
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 09BBF40006
X-Stat-Signature: phjtcahypaewwjg7da7na6r8dg6a7xg5
X-HE-Tag: 1754836470-643172
X-HE-Meta: U2FsdGVkX1+J+VIkTLjjCQyDlc/Ebo8iDV8oF12woJ5qbW84BuDYqvzLFq/YMLMqQtaSgXqQVzdyaXrIoAcvXnMiu51CcpyyFK4Y26pOaz+CmvAFiZTn6+rl2c900Z6urMiDdOwuyvay5WTTnxlprg8HLLkIw8QNs+6GGPxIzaruioTsLGTxz+d3Ra0qU5r5a0C3UOvYXQKTAR0Wm0zpWG4mQ9rkKUnfB5LPGuGt+DCXK1B2NXDITobZovgbnQQAYwTjL3KJzCcnCiFw3f40CJCHVUhoex4jDoSH4H7AjGcToSojtdmlAie7BP48vPLIDNvv3RsvmG2TvZk0oPEBD45PuqbZbCcwhSPGEn8OEmwNA341CUd4zhW6KrZtNK/2UbUVC187YAVZdX3pc+t4KCMmgVY4Nda2OJJIeQPgK8gb8HSYuMqDPOmsHCzM2+YjFZvk5n2k1+F3cA/G41CdHvoIaX0GFM2IYOTQ8+ROqjKtUi7RzqWkLCmaFWUCLY27dDQn0BYKHUU1XkMwEuhOvxtfnudqJy8TzIeD9/FH8u2Dji2H7ajYpqe0eFHno3hmU0b3GLEAJK+Io7hOMSd2FST+Y7dIeLkOgZEMqK1Uw8Ronj65KYeKJzYfwmSnFgftYp9rF1fAlwBsmgdDuFhTUNoaR48g2zInJJJo8Jt2jpaf7MrjvqupK+QoN9Y5VnpTwXBNxKu9zxKHmofByqFxxx66eCtV6oFADfQCwXRwJScXu1Y7Kot3NcKCS4zHGz67ZKCfDNDd3wjor/F7d8B+L8OifYOvFB7I/3LS/9iKALaTZwOS7njaGHcTVTECSqz/yAv6P0oIMFM0WdCexjg78Zgu8P4IGsBgdzmrZ0In7pR/nPOR5vTa2GUZA6sC6yX49pg0f0QD2ikQc+Ta73wgR0bUxH18PqGhbMGY/J9dYt1lmKQip6+6ynseKK2P2yICg4NBcHA9rxdeGydDWMN
 PS0+v7rt
 ymNX/GHKwulN8V0RZTPcQ+pqdcOgCaOA2E5RPg1glhWghfAT2woQhidAIDAQ8L8tNJJo3iWXdk7SCGVt4X6l1szKFePRziKd206j56l87I5rlXKwHUjpSBzYxriB8skr94TRS/uZJwK2wIaejZR1Sx2J/Fe8MHLr+SreYBAFlrrPDSZFLQs/0AvWNrP7YxuAD13gBgn9oP9ud5Q/MJ7Isc1F/AB7jInlGJoxFa15V3NAkHSy+LApmaD5aZ1TXeTL9yLv+drWADXJiW3lxM31H7wgKN6/88slL40i0pDNciasLVdAMLkfwc6dlGOHfZiUOPMATlm6tIaWohjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew,

Can you take this patch to linux-mm (seems the best tree for it)?

Huacai

On Mon, Jul 21, 2025 at 6:14=E2=80=AFPM Huacai Chen <chenhuacai@loongson.cn=
> wrote:
>
> BootLoader (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
=3D
> /boot/vmlinuz-x.y.z" to kernel parameters. But these identifiers are not
> recognized by the kernel itself so will be passed to user space. However
> user space init program also doesn't recognized it.
>
> KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" on
> some architectures.
>
> We cannot change BootLoader's behavior, because this behavior exists for
> many years, and there are already user space programs search BOOT_IMAGE=
=3D
> in /proc/cmdline to obtain the kernel image locations:
>
> https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
> (search getBootOptions)
> https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
> (search getKernelReleaseWithBootOption)
>
> So the the best way is handle (ignore) it by the kernel itself, which
> can avoid such boot warnings (if we use something like init=3D/bin/bash,
> bootloader identifier can even cause a crash):
>
> Kernel command line: BOOT_IMAGE=3D(hd0,1)/vmlinuz-6.x root=3D/dev/sda3 ro=
 console=3Dtty
> Unknown kernel command line parameters "BOOT_IMAGE=3D(hd0,1)/vmlinuz-6.x"=
, will be passed to user space.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> V2: Update comments and commit messages.
> V3: Document bootloader identifiers.
>
>  init/main.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/init/main.c b/init/main.c
> index 225a58279acd..b25e7da5347a 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -545,6 +545,12 @@ static int __init unknown_bootoption(char *param, ch=
ar *val,
>                                      const char *unused, void *arg)
>  {
>         size_t len =3D strlen(param);
> +       /*
> +        * Well-known bootloader identifiers:
> +        * 1. LILO/Grub pass "BOOT_IMAGE=3D...";
> +        * 2. kexec/kdump (kexec-tools) pass "kexec".
> +        */
> +       const char *bootloader[] =3D { "BOOT_IMAGE=3D", "kexec", NULL };
>
>         /* Handle params aliased to sysctls */
>         if (sysctl_is_alias(param))
> @@ -552,6 +558,12 @@ static int __init unknown_bootoption(char *param, ch=
ar *val,
>
>         repair_env_string(param, val);
>
> +       /* Handle bootloader identifier */
> +       for (int i =3D 0; bootloader[i]; i++) {
> +               if (!strncmp(param, bootloader[i], strlen(bootloader[i]))=
)
> +                       return 0;
> +       }
> +
>         /* Handle obsolete-style parameters */
>         if (obsolete_checksetup(param))
>                 return 0;
> --
> 2.47.3
>

