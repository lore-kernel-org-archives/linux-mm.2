Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B9C7C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD2D6B02F4; Fri, 14 Aug 2026 04:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE0B6B02F5; Fri, 14 Aug 2026 04:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D0A6B02F8; Fri, 14 Aug 2026 04:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF956B02F4
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:26:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E4461403E9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:26:19 +0000 (UTC)
X-FDA: 85099192878.12.054B080
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7EC6E40005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:26:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMgOxtmN;
	spf=pass (imf12.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786695977;
	b=qFoO3/9CITPtMN3yIQBFbC+5KymFuRD3mgpP0SbEGbtxHWXdfhEXlQs1KbPNDfvLqFv3Wf
	A+FSuO14KrjKpSRM4GgzhyGgwDA3lxU2zTDwxTUBYqnh5peAJE5Dq0b6b6Y5jGkHEptL5I
	I7IARxfA6kZd7DxqNaJgm3LRqM6g6fo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SMgOxtmN;
	spf=pass (imf12.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786695977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WNFzfxSWW15fOIdnEaHeTYbpQjdQsx6jTbj9dE4ksY=;
	b=3cvQ+fomxlBZSwAHn/uAaR70g1cvQifOwmY9SJYO9mhgj27nnPB27SaJ1opiOH/soK2OVp
	OeHnkF9H52N4dmCtk+dM4azAnBt2BLeNEdSb2GXz8PQ5hgRMSbvCREvzShVyhleqOGYY/x
	TPxknJuPTQDy3i5DfBhIfSrfeqZzxGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90D6143F2B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F191F00ADE
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786695976;
	bh=+WNFzfxSWW15fOIdnEaHeTYbpQjdQsx6jTbj9dE4ksY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SMgOxtmN8Vf5EkQdQSMB+lyU6zdP5E/rVzeaMaT5tG37DvvceG22rBwtS4b3YBjJP
	 LHtiprxppMxk76P3Tqs4D2P3wkaJoyHFi9y3e8+bupmb/8bQHh0OKCECOJLmpMa6ES
	 X2ZxouX3gnn7Ahe/4T/D86o/e9/V4HlxSBV8rGnm8XQQxx/9GgKKxaVF97SzsJNfUj
	 gs8dlFaRo7VPgUqJWmlibmGcv1jTfIVtSk6ZmDdMsIfFszF5GC+uTcdNJ/OHcED9f/
	 m/dz0wP+llgLEZCa7RYZ8APKi76J7sFVFVR+Z31p4fgNuL0bbNFOjkMSjwOq5MBuEq
	 DGiLti1auW0Dg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a386a34603so1436630a12.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:26:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpO0TmcjXnxQm9roa5obO58IIx1Phv4i8Qw4xDruyqJ6sC7pE1XoZ+U3sZQeTj8pBqg6XKiGqkK4A==@kvack.org
X-Gm-Message-State: AOJu0YwHRIKvJqOyT74f2nfa5voxzWEeB55ZoomAzd/JPkRG9LD1ztQ9
	NTVVxdgBA/Y978HtanFvOmQwM1/b3sNLgwQDoA0wfezICz9axLdQ9JFPsS8KwbB970cFzHEcM4J
	6U39awORzQhzlLSWxiRE+yQOw/3uH9Ms=
X-Received: by 2002:a05:6402:324d:b0:6a1:332a:83c1 with SMTP id
 4fb4d7f45d1cf-6a38aedabdamr1544094a12.6.1786695974968; Fri, 14 Aug 2026
 01:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
 <20260813160307.15130-1-dongtai.guo@linux.dev>
In-Reply-To: <20260813160307.15130-1-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 14 Aug 2026 16:26:41 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
X-Gm-Features: AUfX_mxWy0zifyMkCT_MNsH5vELQu4FCKCmOeWL2rt6IE_4N76SZIZUTr8aX0ys
Message-ID: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, liukexin@kylinos.cn, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7EC6E40005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wtgz3bgnbzifeqkg63xt1utztbh1u7t1
X-HE-Tag: 1786695977-739310
X-HE-Meta: U2FsdGVkX1/+192CVvZom5RSfIH7Mwp1T3cLYhaCbvP51MVayA/QrlPOYKOKs11yy35l06XgoSWOL/eSU5VFPGs7W8UA2yYYGsA/pPObcY0fqcA/U0qZ6AH7MG1Rnvon8Vr6lhhBDq4Fb4wEYXKdDp6MRhirVgSlaydB1VkOnS4TjPH6WCfuYLlS/ggCBaVBYwK+I97FOJBWJMTih5z0ANe4B0my1Z97Wh9NQmVnbTtE1lSsvGg6R45T0oyxejM9LhNKXLx1LXuYotsS0bRZ3WWuc5d4pci+LD00mJnp4gN0m3vZ0XqZFCsDPfAyl3DOg+ZhfS2BGDrF6PCG5Rch74AOYb95bb4z0xQFh/1N3KPEA0PliRwB9pkZadAxOL3BkJUfIxhURkONbkG2ixxjkeuvPYSliImSTL/clcYBPL0Hvrit+WqV+SJgBXVGavAyA618ZLwVmSHDtRHexcK8p+Tj5TR9zYf7cKebJ1c2fmAvm5KEZAhC3z0enOonyUjXshKnCLHFg4eeHogwf+rCEd7FKIne+mNtr2MAymTgVPrtrnbrAdXI6KKLEo1Wau1IGmWomiPJl4RxMuCF2Q6vBeQPeMGROplALJqHwrb5Y3n0mXUmBEh2ZPz/715C7Qu8c70F9m95RtGySZM+DoDBAjC2f3nO/HG2ZUJc9amQehJcunVJZgLI7KBndsL0EIKGvGKDpH5YjVg6Xfh+SU1Y7tV6o8vpgF2ynR1WzrmL1CA89slZh7um5Ej3kpZJ0hV0YfwiJ7nxievpNBj59V9hYUHRrGg5qCZ30gjb3TXFqagIs/z6qNjfLTNb41DCw2kEyAVrp6rMKXiRBRYcNOu/0424IX6DP3D44LYcYY8xyoHRn54WisA14p7cdDDXj2/wc4eQJxmiwQ6Ks+bLgdXtKT1wNOvCfzrgbgvgqJDDS1yTbXypp8WF1F78ZT+Ba6sIMGOxG0Q8i9RBJ7XijFQ
 V1emmvqC
 UcZjrOYfDCgVvtFE36hDytYtAhkFPw3w1Js2M+nyIB5Sk1LiSeC1g/3Gs8sNnrK+IZ+MrDYX2wcBzrSrjqKYYN4noZTdilK7sm/n3cAHztgsZwArVTZ3/DurtcojV1OByijAAab/NRNWILnShcW8aAiCP5JAyrHQ/RLIaUEptHWOy47BPnFjeCdtOJOrK1rXSSJdU02ieIr8Q5atkEdVgvHeloz60JEaeAGYQj9NNYKw0fBVkJMahRTE/y6l2SK3HGF8oEJBhzdkjmT8BUvqMJGlGHuqK+z+7BCpYxxQbB5VuQaRdwv7EYYmYdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:03=E2=80=AFAM George Guo <dongtai.guo@linux.dev>=
 wrote:
>
> Hi Huacai,
>
> On Sun, 9 Aug 2026 at 12:16, Huacai Chen <chenhuacai@kernel.org> wrote:
> > You never answer me why in your test you should disable i8042 from V1
> > until V4. In normal use we use a single kernel for both host and guest.
>
> I owe you an apology: I did not actually understand your question. I
> thought the commit message had already explained the reason (the
> i8042_flush() panic), so I treated it as answered and never addressed
> what you were really asking. Let me answer it directly now.
>
> You are right that this is not just a selftest detail. i8042 is built on
> every LoongArch kernel: arch/loongarch/Kconfig selects
> ARCH_MIGHT_HAVE_PC_SERIO, and KEYBOARD_ATKBD and MOUSE_PS2 (both default
> y) select SERIO_I8042 under it. So your "single kernel for host and
> guest" point is correct -- a normal defconfig kernel has i8042 built in.
>
> On the QEMU virtual machine there is no i8042, so PNP finds nothing and
> i8042_pnp_init() falls back to probing the i8042 status and data
> registers (I8042_STATUS_REG, I8042_DATA_REG) directly. On LoongArch those
> registers are memory-mapped, and on the virtual machine they are not back=
ed
> by any device, so i8042_flush() takes a page fault and the kernel panics
> before userspace. A normal LoongArch defconfig kernel booted as a QEMU
> guest hits the same panic -- the "# CONFIG_SERIO_I8042 is not set" in
> loongarch.conf is only a workaround to let the KHO selftest boot, not a
> fix.
>
> The real fix is separate from the KHO series: make i8042 bail out on
> LoongArch when ACPI/PNP does not describe a controller, so the direct-por=
t
> fallback never runs. I have prepared that as a standalone patch -- the
> relevant hunk is below -- and will send the full patch separately. The
> selftest workaround can be dropped once it lands.
You nearly answered nothing.

Does your employer use different kernels for host and guest in KylinOS?

Huacai

>
> diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/=
i8042-acpipnpio.h
> --- a/drivers/input/serio/i8042-acpipnpio.h
> +++ b/drivers/input/serio/i8042-acpipnpio.h
> @@ -1633,8 +1633,14 @@ static int __init i8042_pnp_init(void)
>  #else
>                 pr_info("PNP: No PS/2 controller found.\n");
>  #if defined(__loongarch__)
> -               if (acpi_disabled =3D=3D 0)
> -                       return -ENODEV;
> +               /*
> +                * LoongArch legacy I/O ports are memory-mapped and are n=
ot
> +                * safely probeable when no controller is present: a dire=
ct
> +                * probe faults on the QEMU virtual machine and on any FD=
T-based
> +                * boot.  Do not fall back to probing them directly; if A=
CPI/PNP
> +                * did not describe a controller, assume there is none.
> +                */
> +               return -ENODEV;
>  #else
>                 if (x86_platform.legacy.i8042 !=3D
>                                 X86_LEGACY_I8042_EXPECTED_PRESENT)
>
> Thanks,
> George

