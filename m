Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC84BCD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE708E0006; Thu, 13 Nov 2025 02:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE568E0003; Thu, 13 Nov 2025 02:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D978E0006; Thu, 13 Nov 2025 02:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 338018E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:15:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFE16C0896
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:15:24 +0000 (UTC)
X-FDA: 84104722968.14.9E2CFAF
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id B09014000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:15:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y0lnWIWV;
	spf=pass (imf11.hostedemail.com: domain of ubizjak@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=ubizjak@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqJtc6nctLL296A0D8g+RFLLJKY4jF/ch+KnAKR18is=;
	b=jjpC311h8rPjKL8b96/xJvXCz8YosIoEMOGB82mZQj88un5GnJscQgL/W4aQAfnS/UAEGV
	TqnkN3keTyW/2oaryfimP8e8jMV6A438qtCZnHr0dZavEzZR6M0Ex0zM4wF3vGdMCSIPmg
	GUkHNNcZQpHdIYbjrvOBODU0JbOYgy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018122; a=rsa-sha256;
	cv=none;
	b=sIvsIUWjPe6oMREfuIiwrKRFsWsxgDw6zmGbTjWUy8WsqEDGd9JhAk3GMYsa6CNunPEoA3
	IrRVAc6SAeRsJUxeteaU8t094g1PQHd6/xqXMP47mKeorkE8sKAXgc52aTeAbon52vjRTS
	uNteKyX26R2czN86FGVg7kjorZ/MTq4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y0lnWIWV;
	spf=pass (imf11.hostedemail.com: domain of ubizjak@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=ubizjak@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37b9d8122fdso2647501fa.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763018121; x=1763622921; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqJtc6nctLL296A0D8g+RFLLJKY4jF/ch+KnAKR18is=;
        b=Y0lnWIWVsrsaJCfyUcMh6ZgD/myObdKlXIzeqF5SYNREzzbcv/a/758YN8rCPnb9U3
         Gya/PF1kGrY1whlpuILpnse4EMIqKQzxyG80a2LDiKFAbw5qnQQNuoX8AQDOm40ij6SY
         A3Agpf9I2ANnP7V5NbCNxwkNXUqG4oo9bwqRIA8H8CLqR7UFxBVZuNL59eNybMAbeTaM
         5ynTrBk8RhN+yPzPxM87lJB4qpACW/fmQO+yTzV0GmVn8rUNyDs1k2gThxRkRwpe5ZdR
         gr+O/1rmUa7XQ8oFp2NxELLYvs0ri0xpKKzAQygwxyFeI/ORPNbHSzYRYbd3doDee947
         oDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763018121; x=1763622921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lqJtc6nctLL296A0D8g+RFLLJKY4jF/ch+KnAKR18is=;
        b=pjWYOO5a5oh2a1/08CsMBCNS0om3CNvOsFvoYujmr53osBawW53N/kDE7fL2TNhdvg
         kw+gT++CUAbtbqHGuW76Kg4ryMMavbCnFBNTlG/0aRdQMtIGzW7yDnK2zlsORNBTg5Wl
         Mrv+qA6vSZvT7kXgT/CiqVtz71hVsGubO1abjIU09x844/c3L9MNUtB/xDzv6U8wBFwu
         rKCVNxRFXD7G/o5z8DRa8MbBrjKAOOl1w5GJjVAf2Df7GZ2bOC/cLhCoKK565G9Qt5AK
         xkIPtoWVl9pXyOAVLMmi26oFeEDPruRHjhvqQ4w0yqYozFlpwq4PDZycXh+dOH8Z0+32
         RYnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRUC214hXr120YxsHS0bLVEyMppJ252z3lO7obY6awIT2a+DdQ9N/Oblq8xKfg50AJsrgaDLmyeA==@kvack.org
X-Gm-Message-State: AOJu0YzEMI5tsTN2NN2ZIJyxlQj0YDNAdtQlyfvywGzPS9/ekKelVv/C
	ewMsI+533LUBuypWPq3PB9vBsXmNHfd0sfr6xU6mLf66qr0vXamQUg6YaCb33LjSyTMcTOsZ2jO
	SYvTCTwg83CDaKhzxPkqdPnB1TRlRwko=
X-Gm-Gg: ASbGncucdiYXxNDsIrr1frgiCWO8NuU+x1kggM7gX9ebdokjeD7BRDH9pzhGmHwdgSw
	lTMZHNUP8USeyO3flf2dMwSYtdRf5aYqPkhcXe6Iza1NpXqF6Bi5NHGKZleiYNovweSnUBkQ2Xf
	2RIyhL6PiYnEB/4Eb6pEJdUE0Psf2M+2ONrIfzQUbsIPnj4gbb/gxS/uviY2XtSu8lYIyWkVXXw
	C+wHo8jPidbiMw6wd2CT5MFiZtbWGCvBp2gbS8jK4q6k3hDJ3H9PatCq0eDIrF1Z0nqvLw=
X-Google-Smtp-Source: AGHT+IH06bOdyKarVLIhwFMJ182ryvbHyCSiMCHvWXATRskyshzs0BRRyhF/MSZVLle+D6Cn1SH8KSCA7r6aIB1kImo=
X-Received: by 2002:a05:651c:3043:b0:37a:7c41:79e with SMTP id
 38308e7fff4ca-37b8c2e5f7bmr13698611fa.13.1763018120526; Wed, 12 Nov 2025
 23:15:20 -0800 (PST)
MIME-Version: 1.0
References: <20251112043730.992152-1-hpa@zytor.com> <20251112043730.992152-8-hpa@zytor.com>
 <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com> <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
In-Reply-To: <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 13 Nov 2025 08:15:08 +0100
X-Gm-Features: AWmQ_bmJP9AwfP8znrA5yY9Ud6xnrgSPvI_XaneFw49MCSp3ohPB7gxGYKTmaBA
Message-ID: <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
To: "H. Peter Anvin" <hpa@zytor.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, 
	Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4qpc13hpczh3jyrprgob67ocxh6piuwj
X-Rspam-User: 
X-Rspamd-Queue-Id: B09014000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763018122-755003
X-HE-Meta: U2FsdGVkX18XeN9p9I6bMY++IYuBV/iv/8MSmIhRzp5kiXuttmios2WxB1XrGOH5Ow22hJ+MtFx6SXrDIq4Y/N7lp6qsWLEY03gTKeNb6rqvRC+c7S7bE1dJ/jWYvuTmWActEwMsRQRDYEBRSzRJkG5BP1JiUyIOuVJdT+TdTt4SoUfsxsSixk/5sunCjbHlEg5E51Dcz4JXn790JTibo3ib261hQQrHfFRKkg9wsf7hEvH8rc+aS6K3U4ctSZ0XJZyU3Z30KoWtk7FjMAunXXQZT/sANoo2HFcSu1TzBtvFdOWEH1zklu7Sh7Lvfn4eGgiL8Z0DNXi4SrkbOweoliznyq3mSf7AWKAbaSa7N4oPh+PIm8IIsoqyY0U25Y9TBi0xaE+Lf1BvupDKMAiqTjO8yv6tNt/1KHZmJmuF2m2RWdmrqDIoRGH8DKUs7C1r1eacfIa7WCjS6wJSGreN1W4XQK1OBMcp4WJoxFYkc83DE1OkmBMDooXV7ih1xvVT6Tb+Goc0GLVx00oT+RWy8Q72Ec5RI+z2Bn1ICT0kVqbDZ+Lez+Xz/g6ufWSGQlQB8aEtid2ZLi2WcHDq6E3RY1ghvNSRUfSTdq9EH3p42f6j6qi7/dJ5nSiasPYHXxdQaCU+RfyPj+9aUtNlCpNfdChnDXdkPetvqynSUg6pTZpbqqxkKEUdej5EdPGGoyXy0CUNUBxjugQBK3H2lg9WIN5YMUA2nFMR6ia+ZAjyJ9Pq55iPRZiZ7jZfZg9vhJxzJ5H1g73ad16IKcKPJV2yxIrCgnRBZojcdA2LwLxZ+OEqImMBicnmRIAfsOQizx0qk0eJoLrzhgq+nnRgH/8dXHJOJ8SZA55ZVma9OfuPe2ast/cjApvYhduLkZBnxUqn7o2MwJCy8fNF5VEPMH2cnWzqQKzMB0G/r6x4MuYOPbfdpDoThSIkJXaJO5Xk0uhqpuwmBeKzB1muEf87kiL
 T8WRLGvv
 nbC2IWJ4D/JCe5Hg3Uqnmlkx/mkkgpR98sfzHD6QV8lTw7WJDMDFQnaqTvq1LgQZ05R+mDb91hlovUskR18mIKhSy4IxoiQBCplarpL1l6GYOG8UhYxcbd6XLVIY5PBg55ONeRStzEaAMYJxSyBZr/qczg82QGnK4biR95VcO/TXsqQiQUOvaXh0isgPdAMAxj15GcedZh189fLUEhJuIiXGaSqdQrZc+XNEiUdK3y+di5KD7sZHlhPrkPFFCThZOjf3jBPoZVzl2FGWFnhcuhS+P5ee94RTzk4XNxoIqyOb3mJ8MtBG0ECW5Hl6XpywpTHPoQyW2AUtm6Z4hlJXYNYbsNi8c6cX2K+YKDLIRmmFiXJCqHa77+DSMonDQytepaS1KaXuWVplIh4t1adJ51PNaeV4McvdU0enf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:25=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wro=
te:
>
> On 2025-11-12 02:31, Uros Bizjak wrote:
> >
> > Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
> > using "ebp" as _sys_arg6 on 32-bit targets will result in:
> >
> > error: bp cannot be used in =E2=80=98asm=E2=80=99 here
> >
> > Please see how %ebp register is handled in
> > arch/x86/include/asm/vmware.h, vmware_hypercall_hb_out() and
> > vmware_hypercall_hb_in().
> >
>
> #ifdef CONFIG_X86_64
> #define VMW_BP_CONSTRAINT "r"
> #else
> #define VMW_BP_CONSTRAINT "m"
> #endif
>
>         asm_inline volatile (
>                 UNWIND_HINT_SAVE
>                 "push %%" _ASM_BP "\n\t"
>                 UNWIND_HINT_UNDEFINED
>                 "mov %[in6], %%" _ASM_BP "\n\t"
>                 "rep outsb\n\t"
>                 "pop %%" _ASM_BP "\n\t"
>                 UNWIND_HINT_RESTORE
>                 : "=3Da" (out0), "=3Db" (*out1)
>                 : "a" (VMWARE_HYPERVISOR_MAGIC),
>                   "b" (cmd),
>                   "c" (in2),
>                   "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
>                   "S" (in4),
>                   "D" (in5),
>                   [in6] VMW_BP_CONSTRAINT (in6)
>                 : "cc", "memory");
>         return out0;
>
> That code is actually incorrect, in at least two ways:
>
>
> 1. It should be conditioned on frame pointers enabled, not x86-64 vs i386=
.
> 2. The compiler is perfectly within its right to emit an %esp-relative
>    reference for the "m"-constrained [in6]. This is particularly likely
>    when *not* compiled with frame pointers, see #1.
>
> A better sequence might be:
>
>         pushl %[in6]
>         push %ebp
>         mov 4(%esp),%ebp
>         <stuff>
>         pop %ebp
>         pop %[junk]
>
> Then %[in6] can even safely be a "g" constraint (hence pushl).

If we want to also handle x86_64, the above code (including push)
needs to be 64-bit, with "rme" constraint for the pushed value.

I have CC'd the author of the above code, he might be interested in
the above discussion.

Uros.

