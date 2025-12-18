Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F856D65C7F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 02:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A3E6B0088; Wed, 17 Dec 2025 21:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7386B008A; Wed, 17 Dec 2025 21:16:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BBF6B008C; Wed, 17 Dec 2025 21:16:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 278156B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:16:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA0FC140C8E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:16:24 +0000 (UTC)
X-FDA: 84230977488.27.B95ED1D
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4742180006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:16:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QAxt629K;
	spf=pass (imf16.hostedemail.com: domain of brgerst@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=brgerst@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766024182; a=rsa-sha256;
	cv=none;
	b=0rqrEfQqcU0p6nTilC4QrDmR+z4oqyl1MbHEteSbk92+y5OyNxxhF9WbhIXvM6YBPSCMbq
	Ots1SBfHEXADV4Xr/16lyf7jMED9QiGUHkmmvB/gVLwmQM6qVRsen55bXJaeTjz3xXiUDc
	6hYPV5Z9/e+f8zUFrAarsn0OzRFG174=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QAxt629K;
	spf=pass (imf16.hostedemail.com: domain of brgerst@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=brgerst@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766024182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AN9sEG2AE52fSnYh2OeNG8uWEMWv3JCgynDFEzzgMU=;
	b=KzD/2JQhXpSPD1utYqryEYE8UDLKJFIm864Tvz/WMsUAWFP9dqIf3UXqX1dPcKLwTC88PN
	XJiCMASonZ8AuyL3eS8GBTyls5gWBqQOH2fZNmJAMynFozRddcoimkpNDjwsLReA5ASS5E
	pjjh1V6Mg1/QqrEfAa0ERbWfTidFjiM=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-37bb8bef4cdso834031fa.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766024181; x=1766628981; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AN9sEG2AE52fSnYh2OeNG8uWEMWv3JCgynDFEzzgMU=;
        b=QAxt629Kc/T9zQ9D2ZmGkbSsWcYyTsh7Y2lv4UWd/k/uRbvwVxKSjNNPU1n+bGnTKv
         T/zizwP1AW3kqoVpwIvdRUGFS2+m0r2dDRBpLGBpF/j8y9n0foXrYVZWLg2UTRmXqMH1
         VBnJZUvf7D2qf0haBY6vWqQuXXDWN2eV+9evCDT2JCO6XQd2uTbTB1CZdojG51Akx21r
         Lk2q9ZMy7OKu936e87rQ8p3N2M2BqVR0PuoGECLjOFiJZzQ98WXz0+2wXP6WFaJBT6dX
         5gA0bO1rJalIEK6ElB0Js7iguBJxeHRs2h9ChDd8n5ACrpq3WfJojA+5Xc8plZL6CLQD
         tZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766024181; x=1766628981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9AN9sEG2AE52fSnYh2OeNG8uWEMWv3JCgynDFEzzgMU=;
        b=bdouYeUMxhMUXJnlnHoQDD4x8Sx3tneGEvPSt4BHWw8VFt0pNg6Sp9hGNAHGToKYyl
         wNQP3L51ZcQ8hGXPaV8wZH7HhfihTuGAFpnwNhRWqwokFb73AHvt5faTpeb8czgVSGS7
         BD0/hP9qG0mxAuaCApJRac0kOi5Rw1pUOGq7xyNCfd70udxhr3lNObDednN18eXK5soT
         AiqROJ58L+FWF5ZWrBl0bFcoFcoD9yh0YkqHm8IUVrY9iz0LR8WFGjeSrw8lQe/Te/zb
         j6yMBoIZ+AOOb7ibNy1M47oIfU35E7I0xpBWtUXlbKqF2KDopOB2QAfsQic+1oTqt/Jm
         8BPw==
X-Forwarded-Encrypted: i=1; AJvYcCUhz7bjyGngo50dDs1vsN41pDN3ipb2gr14zqIu7OAaj6H0DlTJCk3DIq1pEkpTTasjlZ3pZL+gdQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0toB/fI8wzxxBvvl/h9bwxFh9Ihx0oKUsUdCUwK9+Mu4T+WD8
	B+YtinrGfnVu4j2PuKkAZRvTW/8YyxxYAvlFJNLKcFvsQLcGaoiAMP03DaISqyL+NS5zH4psLBM
	HXcScJUj2Kdv96YMKg7NdPsS5vYp5zA==
X-Gm-Gg: AY/fxX4VQPftOCV4DUz8Bjd9pU5qZhliov9pjsU6oXJeDexZkZVBCWWn4XWvcz0qY83
	JKKyc0XGr+lnPngW1QcKhJ2jIfYQj6UAgMMT+raeQ97yPRiGSNNBY3Hsgu/ttSLc1aW6AJ/ET/h
	XjYWFnla5LGivulEco5n1NTFO8yVgHOoFlWgvIdGsaEfdGNJ0CILUWpeFCNCzX61rsI8UhDE+ce
	jDXoG3yN3/uyB+JFsidwlojgZO8rrwM0lOGyp+qQxQVjIujKmmIYqV3h8Sa066SbRnePeJO4LAa
	VxMwE7WMbg2DdYIvtLWA
X-Google-Smtp-Source: AGHT+IH+OADZ6GESLoGiMPu8hoFMOP7s7nP4zFXC7YbnBNR5dFco3tMJoPvVr4wWL3ocwWAFY/G13MIXPc5nmNaijSc=
X-Received: by 2002:a2e:a801:0:b0:37b:95ee:f605 with SMTP id
 38308e7fff4ca-37fd077cfd2mr59325781fa.10.1766024180565; Wed, 17 Dec 2025
 18:16:20 -0800 (PST)
MIME-Version: 1.0
References: <20251216212606.1325678-1-hpa@zytor.com> <20251216212606.1325678-8-hpa@zytor.com>
In-Reply-To: <20251216212606.1325678-8-hpa@zytor.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 17 Dec 2025 21:16:08 -0500
X-Gm-Features: AQt7F2p9l8UeuqBazA8cYojN0tIogcUvjCrbiceup-Wji5NWm9gKMgC-Lp1qUmc
Message-ID: <CAMzpN2g9QNnYhxkGvkO2YcOJTmJGf75qFhKiEQQY18ZaEPQNdw@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86/entry/vdso: include GNU_PROPERTY and
 GNU_STACK PHDRs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sgx@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C4742180006
X-Rspamd-Server: rspam04
X-Stat-Signature: zmbf8bxr58h1zbpra7wby7kc434u5rjg
X-HE-Tag: 1766024182-119248
X-HE-Meta: U2FsdGVkX18x8XTXn5pmwFF/bz5x3hjESpRZZ02tRFIClhTlDfmev+/Ep5SB4SMRrWpFqR06gLBYxbhNESFiNLkLkDvbF0tk91Ijz4bdnDfzpMZEb/d6PqytJHP7NFZEPd4dE4QpvAMLtnna7jmRMnuo+vR+wCsERtmxGx7z1Qr6XYYR9JCVEO07qmb7wo9fCG5vgsXZal1JazEDRBahJb2dqeIINd5U6yxMcyoX+/WqFxXiLt5V9cukSJP5JxGYA8xwxulDAnVEnUcD2/28YSdVdC2QDBXtLqQnSgwXLtnpI3WLVwxK3eK7dv116dOIX5svfNhOXlzTrJ4TwR3dbDjkFJyJAr2oIxreiynGlhgHTKMHIB4AcsMZAs4j542xPNHxXkFlclin7plZ1fndFXn/J1gZAGkqsit7vztwOIp5Rv3FfPtO2Sd593uqFW+orV9AS3437DUOirC64yowxbSXd3KfDqof9Z1F7SmvIoKNBnYMk8z2EsAvN9NuAJALAc0ZO2te8rOPEwQDaP1A54sj8vU/lDZPOqyyzo2VoIDPyuLsQUQUsGM3+VLsGltAxz+P1VXmu8V/tzBe7GnIZccsUDkvtcZ6Av7yE8+3siu3pWZMCaC9jMXip0qEMpOVT1iVA0ZtfuPm5A3E5EmbfIewYUgaBg428HYMqgXa7qRBPYh4Sx/B063Cxb2bBcI5qSVHjN2NlkAEzUGWFsESpZIf5T+t1sQuVp2Bjsp5gRnnUi1P/YyfaTvMGw/sYFu6mdBb4gIn0PnclBmZAV+VtHR0n8ItTXKrXwvs7Tea2eAKf7JLT7XRtc8WYQEiCxaGSSo09XFwXesGX+qVB2nzEKCZcxkmGMYt6EAgTwibme+5NIKGbtsDOGsDI2OSdq/p6FwDgiXhfwYlDjEsjPiIn2WH2g1dM/RfgcV+ib5N0jvRtYlEQgc11oaCZYH79XVH3jiCKGbaARmdvZfMrzC
 J94sTG6X
 gTuGxax5ZHmIn45P+FDFwq3P7d/iYjWYQWW5oiXDs8wPAivb0SrRvLFGZWxMVFkJnha0GOpkGyVaDpNdBxe3dKVY5RsW7vhwWRDGgUJZsyYxauzr2caHlmYbkPiKFH97d/c+0uko/NBWngzDiVFfbyc+1vyqvr8z91zpEQ2jCYRRlk4B5buzA8oylkTAReICt6vXjWW/0E0HyhQKyx6wHRF6O+ZPsBTmMNgsWIow15+xyBQfkyAaD0qRfYVpiO9Ys1BtavITTwDKzqPu0bhEuCB+Wn4dzVXzsxmo6fTNrlm5WqKZRKf+VhiSEgr2+GVPAloORWXmEYvyi34MVV65Lfg5TdzPU9/CX+e2oL7TJkUeviVbZBO3Qt4vsxCT4IeyCkY6GzQ3ORGERt/wr0oeMPc7RCEZigkHFKiH/gYHOkx3VzHua3Wn377hRdA2R9VusXjLQ9hQIrK9srbXNvWPerlbgcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 4:26=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> Currently the vdso doesn't include .note.gnu.property or a GNU noexec
> stack annotation (the -z noexecstack in the linker script is
> ineffective because we specify PHDRs explicitly.)
>
> The motivation is that the dynamic linker currently do not check
> these.
>
> However, this is a weak excuse: the vdso*.so are also supposed to be
> usable at link libraries, and there is no reason why the dynamic
> linker might not want or need to check these in the future, so add
> them back in -- it is trivial enough.
>
> Use symbolic constants for the PHDR permission flags.
>
> [ v4: drop unrelated formatting changes ]
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> ---
>  arch/x86/entry/vdso/common/vdso-layout.lds.S | 38 ++++++++++++--------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entr=
y/vdso/common/vdso-layout.lds.S
> index ec1ac191a057..a1e30be3e83d 100644
> --- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
> +++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> @@ -47,18 +47,18 @@ SECTIONS
>                 *(.gnu.linkonce.b.*)
>         }                                               :text
>
> -       /*
> -        * Discard .note.gnu.property sections which are unused and have
> -        * different alignment requirement from vDSO note sections.
> -        */
> -       /DISCARD/ : {
> +       .note.gnu.property : {
>                 *(.note.gnu.property)
> -       }
> -       .note           : { *(.note.*) }                :text   :note
> -
> -       .eh_frame_hdr   : { *(.eh_frame_hdr) }          :text   :eh_frame=
_hdr
> -       .eh_frame       : { KEEP (*(.eh_frame)) }       :text
> +       }                                       :text :note :gnu_property
> +       .note           : {
> +               *(.note*)
> +       }                                       :text :note
>
> +       .eh_frame_hdr   : { *(.eh_frame_hdr) }  :text :eh_frame_hdr
> +       .eh_frame       : {
> +               KEEP (*(.eh_frame))
> +               *(.eh_frame.*)
> +       }                                       :text
>
>         /*
>          * Text is well-separated from actual data: there's plenty of
> @@ -87,15 +87,23 @@ SECTIONS
>   * Very old versions of ld do not recognize this name token; use the con=
stant.
>   */
>  #define PT_GNU_EH_FRAME        0x6474e550
> +#define PT_GNU_STACK   0x6474e551
> +#define PT_GNU_PROPERTY        0x6474e553

Do we even still support the old linkers that need these constants?


Brian Gerst

