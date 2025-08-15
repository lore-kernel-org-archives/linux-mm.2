Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8306CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BAA8E01E2; Fri, 15 Aug 2025 04:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4139F8E0002; Fri, 15 Aug 2025 04:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350BA8E01E2; Fri, 15 Aug 2025 04:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 233C18E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:50:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D33A31181A3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:50 +0000 (UTC)
X-FDA: 83778371460.17.B4B43D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0473180009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PbW+Lki5;
	spf=pass (imf06.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755247849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BS5mq5xmrljgDToC2dHxxtMWqLV6gMkzshrhDBsTsnQ=;
	b=ddqIME7oJSVpKwlTnTDMq+eNGMZuHIDNGuzEj1Prkzm60nkfibBY5DMo0obovmtjNNEzz/
	VpDDTYodcExks5wMud+c3VIcdrjyjWNHaCxCss4TEYP++cwlaip4yuFXomq9QEE6ZWP5do
	IPEXSLz6VcIoU+64LMkg//L9rdlJ7zA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PbW+Lki5;
	spf=pass (imf06.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755247849; a=rsa-sha256;
	cv=none;
	b=zGHvDaXTeVQS8gEdFOTaLPzD/pZ92otH8g2AsogtMb824RFtDTEj36aewaVTzczbAhgAWd
	OQ8LohzNLMlH89VeABfWLJE98CwUlMujdZRVs2oOdPKf+m3+FZbJnG7NPiHbG/FKA1OUiI
	L5Tr94HriBDhpSrULkvvv4bWNt5Lh8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 664D646061
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47846C4CEF5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755247847;
	bh=tFZ3dQRjUlI5OEsCU7Ae9mW17LHD+V/Wk9uO9K/WBhY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PbW+Lki5GdtgPRWk6KJHakW5fq3skKRHg3Tjd7HfkKceyASIol5k3IhD8AgRZzUWx
	 1JuJgF27o3H3SOLmxi8Pa7TJgus526rKsrRxulrOkoYwSpaY4WqmV1j7/7fCv/USMN
	 M4UhPKa0JR6Pk24SqUvJn/VO/MdeoLIk3aPUmbdFZZufY6FGJMxiGCKZsDQONWhO+p
	 p2Y7O0l8J+4aawypmZTvTmzWslQ//IaMoWp2l5Tm1Qwi9LhoXAL9JDgVDwRuJVq4Xe
	 uo9CWt9/ofd5UzuzeE+PXzRWwsL0Q8aZ5XY0nhFUmp5G6OybZgjCBmVgD+b/Ox4Jjn
	 mPfdQ/Qt+1Evg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6188b656159so2902965a12.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:50:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUmrypEwOr71QemoKwllopBajy6ZNf5VAIPV261b1dS4KuxeB3mHw2q0C8vYl0jE04nAgePN90wJg==@kvack.org
X-Gm-Message-State: AOJu0YwdgeX9RSFIPBCVObeqLB231+a9yVrwi2KzUAhvvQM861taUIvy
	YUVfRIdkLJD4ZekF/kNjyZd1aldx6khOrvPtMqO9/HRQs1N33YObvDxPhGvNXdCv/qRLD5UdXZY
	rCgA9Diqi6uIRTQMDgG2w76JcE66DfM0=
X-Google-Smtp-Source: AGHT+IHGCpf4wRlB5ShJISeqNfHm1ljWIRp3fTE5KL5hhOU/yg6wagjRCoeo9Wgjye7juXOhgtVcmtt1IGZWWoeFvbE=
X-Received: by 2002:a05:6402:51ca:b0:618:aea9:725b with SMTP id
 4fb4d7f45d1cf-618b050d1f4mr851259a12.6.1755247845748; Fri, 15 Aug 2025
 01:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250721101343.3283480-1-chenhuacai@loongson.cn> <20250811185635.f51ddda72f36bc0c2ba20600@linux-foundation.org>
In-Reply-To: <20250811185635.f51ddda72f36bc0c2ba20600@linux-foundation.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 15 Aug 2025 16:50:34 +0800
X-Gmail-Original-Message-ID: <CAAhV-H60uwMpuwOi1Jb0sgQO5oE=5AioMONAt3MtGTWzgm6uyw@mail.gmail.com>
X-Gm-Features: Ac12FXxMi_qLVWq4FNkYvA5_28kW1mRomx7voeDtiMJFOvKVKYCDp8Jp6A_eE9Q
Message-ID: <CAAhV-H60uwMpuwOi1Jb0sgQO5oE=5AioMONAt3MtGTWzgm6uyw@mail.gmail.com>
Subject: Re: [PATCH V3] init: Handle bootloader identifier in kernel parameters
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, linux-mm@kvack.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: da31ehx3jhak7q6k95t1brdim1oous7z
X-Rspam-User: 
X-Rspamd-Queue-Id: C0473180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755247848-197249
X-HE-Meta: U2FsdGVkX1+uJi8Hgfuw4K19qHkP61ZGpmd/BAPBl4kxb5yEpHNlKkpbZkgrpta7EXJoHFo3A62YSo9Jizn01Ben9w0nuE4ceRaWxfn5d2d5LsiHmUvW8ACtOnv/TzD0aEqiMz0a4Nucw/DifMFJLlzBjRPlGJkMYIvf70eytJkETdp0A3knFDsnGBHc2slfZLOR3w42JYD+IQpFAFvGODkAQJdoMIMblYjBntr8V+O/+JCoSPORx/B6d0nTREiFw02sqXyN+Np/2kHdce0EO8nn89AGVj11eGIA4GiNCIjbIldVr9at0PpDGF+nRMiANpRDFsaz3w0LDcasolEzHrRM7PrunSpmxWy/Q92e0pwXGnW03N0/Sj2494LXD4hQpmjlQGSnha2ZZ9Azy2nKrd7Y6rjQGyoC/Z8LzW383nhQSdwc3lWME14q+4YJKb5+/+3+aq2payfY+bDifGOHzSwTDSPMP3cQMuOSkPcEzoBWlwXrusIsvqp+Oa2I3tPwObBCLyq88VnfeyD51xt9CCqBg/mPt35BSWxmlB6RabfLEOipi90jW1u4GobgrQvlTQ/Yugw8RU6olUGA9CdbmrtDj79cRVLcQyEzP9XHqqH2ZD38i6H3w0CAeU31mf+PLo8ik3aWR650rTM9U6HWPX3QHdqdwPBDXBWx3DrhzRDEHayZVVfIpp1rOEcPLp13HdTIfXqGv9pEfYImS2XWvni9ddoWe3HUdSiO2M6RXky90EOCeTkWaPRfL9eWmMfliwEbie4kwhRpZqKHCoc+cKqYpff3eVcoIkWPa+ZaJD1sPpM7Rvzms8hVan8tVavxe2CxBWFgITCkBotH76ueTyqPYUfWNhavkvJeIPkMEvUt62jgPOIudzoUaR7IvAlpdR2yIKyYlKux3cs4P6tbe0d6CBoXRyi1te7lyNxjTIuiZNNv+WPe6Y43Cn0X73jcKc/nH+F6VoY8E2tn2ZP
 ga9ELuCU
 ZzHYS6sKyKM6356nqC8RSZsSvmik+reQTjasm/L6RUxm5wtmErysFs2vkUuiexnHU4FGOJBXTynCY0m0nTHwr5EFTsvM0D1/kDEe8fOcMeGx4LYRzznfr+ub14OKOBMn0nFDG7+UHG16yQxGMZ0aCvAlxG6WQj3PHp73/rxx7BRQDolvvhX5dEEBj+/t91Jjey/MgpTXjEBNMTqUN4SDgRnvRP5UEiUmFZTuFvvKzAPtfGyODeefBPap+/hgCbEUltswi5hju0Amzq8Zzge91eGIVh2d7vYBVEi0zBETAWuLeNI+ANZY9huRz5eVcWuWDWylYBenJ6e6yJCo4kCVRr4jX7QEtPbcjvzTI3fg47MdodiOqzS7Y1UyE7cCmZ7C07kSAva/UkvupC+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 9:56=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 21 Jul 2025 18:13:43 +0800 Huacai Chen <chenhuacai@loongson.cn> w=
rote:
>
> > BootLoader (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
=3D
> > /boot/vmlinuz-x.y.z" to kernel parameters. But these identifiers are no=
t
> > recognized by the kernel itself so will be passed to user space. Howeve=
r
> > user space init program also doesn't recognized it.
> >
> > KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" o=
n
> > some architectures.
> >
> > We cannot change BootLoader's behavior, because this behavior exists fo=
r
> > many years, and there are already user space programs search BOOT_IMAGE=
=3D
> > in /proc/cmdline to obtain the kernel image locations:
> >
> > https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
> > (search getBootOptions)
> > https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
> > (search getKernelReleaseWithBootOption)
> >
> > So the the best way is handle (ignore) it by the kernel itself, which
> > can avoid such boot warnings (if we use something like init=3D/bin/bash=
,
> > bootloader identifier can even cause a crash):
> >
> > Kernel command line: BOOT_IMAGE=3D(hd0,1)/vmlinuz-6.x root=3D/dev/sda3 =
ro console=3Dtty
> > Unknown kernel command line parameters "BOOT_IMAGE=3D(hd0,1)/vmlinuz-6.=
x", will be passed to user space.
> >
> > Cc: stable@vger.kernel.org
>
> I think I'll keep this in -next until 6.18-rc1 - I suspect any issues
> here will take a while to discover.
>
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -545,6 +545,12 @@ static int __init unknown_bootoption(char *param, =
char *val,
> >                                    const char *unused, void *arg)
> >  {
> >       size_t len =3D strlen(param);
> > +     /*
> > +      * Well-known bootloader identifiers:
> > +      * 1. LILO/Grub pass "BOOT_IMAGE=3D...";
> > +      * 2. kexec/kdump (kexec-tools) pass "kexec".
> > +      */
> > +     const char *bootloader[] =3D { "BOOT_IMAGE=3D", "kexec", NULL };
> >
> >       /* Handle params aliased to sysctls */
> >       if (sysctl_is_alias(param))
> > @@ -552,6 +558,12 @@ static int __init unknown_bootoption(char *param, =
char *val,
> >
> >       repair_env_string(param, val);
> >
> > +     /* Handle bootloader identifier */
> > +     for (int i =3D 0; bootloader[i]; i++) {
> > +             if (!strncmp(param, bootloader[i], strlen(bootloader[i]))=
)
> > +                     return 0;
> > +     }
>
> We have str_has_prefix().
>
> And strstarts()!  Both of which are awfully similar and both of which
> lamely do two passes across a string.
OK, I will send V4 with strstarts().

Huacai

