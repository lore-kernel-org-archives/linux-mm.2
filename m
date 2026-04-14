Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0D4F9D0D5
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB946B0088; Tue, 14 Apr 2026 11:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B916B008A; Tue, 14 Apr 2026 11:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842CD6B0092; Tue, 14 Apr 2026 11:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 72DBB6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:10:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 026D6E0AEE
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:10:24 +0000 (UTC)
X-FDA: 84657497610.10.46ADE9E
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8BC7160014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:10:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TXqpFC8a;
	spf=pass (imf08.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776179423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7c7tKPqaKq3NgFiv2DNK8q/BvKoh1wbxDHgCCrA1+c=;
	b=uNfJQXAC2pTJkaO5wndyayMp3hQ52XF+p85ZlTIVSlVNYtl2n+ah48b+1qYFWX3yWfqCkN
	4y1k0P+I2I27BMP7SFaa560Rpxl4fDKUYJyfYEIJg2Dp9D/rsiTxbqvYeKQrCMyZs1kxa5
	5DD07A42qNpxDr75qc+vYs0ZbH6nu/g=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TXqpFC8a;
	spf=pass (imf08.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776179423; a=rsa-sha256;
	cv=pass;
	b=di9Awjs2hsUhrlbPT7rx3mImQ+8Z79MnjflpoYo+A42zIOQjlVP7B+wggxAMd81AxRnq3F
	CwawTfZY5jUGS3gH59HVBfp2zJhJaRO8y7J/SNND2y+tQF5CW2kgUb002IygmGIZpowh60
	rzFd3ZQ1tlQLrSq+cBCUVf5YV32bicg=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d734223e4so1665837f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:10:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776179421; cv=none;
        d=google.com; s=arc-20240605;
        b=FIuEPaVPMz0UJj/NwbQboalXRJl4/YGdTFwC+lgjvtkwqDlaBkudC9I3w2FlisOJI2
         52XdHhrJazrc5IQkZ9tBg66ZZBAUgL8xGsvfjb0OgOELiL8ZQWDq+g1TWh/qIBQDQ9xg
         UkNBQz0P6+bDFrf+E96kqmaYZ8zlCDTqCnFiAwCFV3P9MzRYijXy0HZ4hF5jV4atQq3P
         /+NhqkALp2Ud24keI7Ijlpl46ESN3IcrKs8NhHZVU9RC8y0MuyEu8CsLBNEnEin4W2Wl
         B0onR1vz7NEXSBk/4ZtGir2vqiAxKhGTVKWcuHSfdNlUHD1wHeXQBdyBgmCuPalCLLXH
         nhBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A7c7tKPqaKq3NgFiv2DNK8q/BvKoh1wbxDHgCCrA1+c=;
        fh=eqrWCDeJuqd/RespjtXK2hMd3yOmrO03s5JWUsRGL9k=;
        b=CaZEZeAjiOoypOdB4KfPQaVGCxCwQcyHIG8QBzRmvzFJY5lENvT8PMmaJOEpUgW/Zl
         dQQXwpqB0C9p3l8a143mEvDwM0btDvKcaBftH9GTJvnMC1LTiAwME/h0dgMuCLgPyizg
         DDGHUxGptpl0+ricdXn+qeg6tg/lM76zcNW8sG3A9+gfY8JkyMdMkpRJZ2hzlyrvJs7M
         RqZKNxNBSpgiu8dsOxWegiG1wqQuxAAmpNszEwEbmzb/PGcDdH47OSSENAfx277rGEb4
         4uOV+hjbBgx0XLU525R86FonaNBoVcTR6NXHqmeSyo7T1qp5Q/t9cmMsdG2GyVYxJLiv
         NPfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776179421; x=1776784221; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7c7tKPqaKq3NgFiv2DNK8q/BvKoh1wbxDHgCCrA1+c=;
        b=TXqpFC8a/BD/A18gZ0RJ1KZQbtCszjFBDu8oi5458/uXpycmaYom0WXXSzlT+KmF/O
         J/Y5JzZEgE/fr+UneAQvPOStNtPWGYNCf6Wu7+6u23398WEl1P1+B5Cw75dHYmOyXRVO
         Yq1/ma8M0A1OqPKoNP3s/IeeEA7yQxlqXQZorIhbziuxsFp7DNMhA6M3w+i2XU4NZYE1
         Hr01PNpvjvx4NjXNu3kLZkZ57dEYInK6brAuodudMx0ABHjE1PnjkowFGgL8dDm7vQfM
         4hlAuV0dGQsAPUNpxejsaBncXyv74QNIVpD5x49Y1JRqbZEOyj5NoZZVK7NtqGMUlaWo
         1Dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776179421; x=1776784221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A7c7tKPqaKq3NgFiv2DNK8q/BvKoh1wbxDHgCCrA1+c=;
        b=fk2ehDGMD1uXGLQxNDZjw9RcAKTDp8dPWcVkiQf180eV9Pb+/k0KccZylcAbzIwqq3
         RI5ImGoQbcJpwJqPCvaBrkeRnLn9Fmm1nDiCq0FekCXDCV3MWWUTaoL1UZdaH9/dgJ+V
         bT2vtnxh8yWkLFe/NdUN3CkjZCiGmhW61F4RNTWwRqqqopVv/r54FGguq0e37nbZEjZ6
         l0wQaVKwlrPJZPT6cJ03XpRkTf7RZ+Q9EIpIFA21lJGEskzWkdq/67AcaoN7vU/lS3CV
         7tmlp/65UYELsuI1hi6PZJeyl3OryudjYWBy7fSdECzZ4wtUROWRENgIUCwmgPraM2Me
         9Emg==
X-Forwarded-Encrypted: i=1; AFNElJ+6/scYBRRTfVi7WgEjj9D9nmG+nIO3ifJQvfuk6LYLrw8O8Ot6OxW1xGry0T7LDvp4Z6iaUdciBQ==@kvack.org
X-Gm-Message-State: AOJu0Yzbze8/+qE5Iw4ms0F+4CvdnVP2TxRdT/K0LPmtoYoVPXxzEjS1
	BeTf/6Sql/jcOJTYHleOze1B7LfwyNaQuI6a9EwEMgkowBa9wAfEy79kHK/uOyDnraLQFRBUWs5
	GoSPjwdWpQvTBr3DRo52qNyG2BSw2Rrs=
X-Gm-Gg: AeBDies0GBRvMrJZ5AI6DUZrl+CjTmUD9wrbQFcR/28elEhP/yY8pYIizxbv1Riv9ee
	veBESlo3yyoKr3HWjoyhoFNriVWaldIDcmBDJSYOVo74sSYenoY5Ob+tFZi/Ce9r37pL+W5tsb0
	mr//A7wV7yC/vHkNKABvKj3aI05327Xp3qMAWnpg6ZyLG1abUBPeqv3mSKgFXdU5IK9VBIOPCFK
	pcLq5B7d/lj+Om0dyZBXuidtLxFwwM6y1ed/RYISBCNrMysRm4D2QBOBhDTi4ApObzldondwgh3
	ZyAidsy8WBe8D4HYEzQ3idaOxQZi/oJHDUUWWusd
X-Received: by 2002:a05:6000:4110:b0:43e:a8cc:89b7 with SMTP id
 ffacd0b85a97d-43ea8cc8c24mr1517128f8f.3.1776179420992; Tue, 14 Apr 2026
 08:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
 <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com> <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
In-Reply-To: <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 14 Apr 2026 17:10:08 +0200
X-Gm-Features: AQROBzAtXSFwPeCMpZ2dGca-DBLsSXREgEyBZSQFf7Waht1WxQ2QIbb8WTtAIYs
Message-ID: <CA+fCnZd31GzdpEqR8VhfK4JtUKyyRMgbBoAbeGACJgm7WvB6Vw@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?UTF-8?Q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org, 
	Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8BC7160014
X-Stat-Signature: qesaa6t3ctyy7z3f81m4yn8udoabonrh
X-Rspam-User: 
X-HE-Tag: 1776179422-385269
X-HE-Meta: U2FsdGVkX18LG/vmP+lSNsA0wMkp7g5ueAz0DUtsnrYYprGWedDWgkZmmpx/jA9XRSMQv3RmTLT7ACVL8PNRNKHhNBVQxJ4pcj8++Wl1Mx6iyBgp7odz7TRODXtloTDy5L3GJHNxEn8pC61jFpAyhifPAwvTSA+Qd8jNukmZVkMDYBdNTW/8E1qK1FCMEmZ5e3fLVd0FFwXI8Q58bI5QPr8qQvTbaWm+UgN2B8IqOFFk26Aj1zKtyOXUoJqoJ2FXGYhckMK3frdykaTAVzum2mCyJklak0qKEMRKWgSAbLVbqn572NVC+o+zdyZi1qkPAhfdYgbAiVq6S8aHqV2iaFt5eEHYVk97ub21XmpktnqJVigU7CfR3xfjS3PmV1j2hjQ6nCSYmxCc+JqwNDwQkrw5Fxp8P9fhoSONzxdluj7jcVjPUbRSap0ji1khKwXml+NQUfTjEDldrSE3+W1q/wOmRFW0Hg+EY1bTBa9BSNSUd9JpL77PzqmUxHDFvJjiiYTzwD5teZ6iIOCXqzvN1zXAuo9rNT4an81O2iOqiE3eDPdTMJduBZWHkqkzPm9+wpCcVZjy/RGOgVWCHimiHkj6T27Y8RPK2PgthvUwMWjy5xM2r+4q2Y6GJIFLgKyXjhVXHipfw3QMpwf5OksUzeHgDYiXwBH6tDjKkS0noyQgSy8Sz2s4bVdRhf+hER9Uv11aHTWuKtoPWtKfEs//iSve9j+xLSm+h4wlNWjZNPT+MbkOmd2qc+wrXqh45WKGBhebndwv22K2JxNUsY+aQP0f62DqsfxeW0S7klJqGCdE8S+qmMXi49vzgrBWUgxDTVHUF9dBc52jvFHRRuiDRj027E/rwqv70ue2ww6jFbOlJyKzmuiIf9FqsSUPOu+sstXTaI8zpgBwVSdow8w9nu2ESbgAeacEdbw3V0jQfbRH2bRUMpMziW3POTR90gAHw4gkzH2AqFBcU2S5p5K
 z+/TASf+
 ZoS4YIZR+15L3Key5C+PSqQSVYU/cNsyablyfeoM6VilB2vsKj9h9htOej7BTEQDBpZWpzW7pbg/TuVCUaZtxfFO/szTxCR3MrIO89X3+kCWB1DEqV+XFUl7PvMThzKgKrRw25d7fwEj7WjH/fiKOhgMjXBE0fqEox/FPsZkVSGfT9C33951oKBWrVRZlDG+gZ4ghy99Roi9PGSkURsmCFX+L0rStZWSn0uFWTxcBWaHwsekjYTCvzflz13KxS1XxMvy+QkNY8JSZSCWF3kVcKOI09fCHdRw3VO+ZgOWXnjfTimRaWWaAZLrMr8eEuv3rIaKs+R2pOKEdxZogAAv+2A2OFE2RQ3Uh31/qWercPnOGUEGbprhCbYwIkRpUsHHQtkhBwuOuX55ljMerjU0SmelTLeljmye9IYtsXqTXU3ydO9/mKO4cO7SalUMhnKbskeRTT7biLWW3Wvm6pywaWvOI3zwR0uzDN0i7cjsQTxVz//4SkiHghT0UaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 4:36=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> > ACK, I'll try to use those kasan_check_read and kasan_check_write rathe=
r
> > than __asan_{load,store}X.
>
> No. The performance penalty will be too high.

With using __asan_load/storeX(), it will be one function call to get
to check_region_inline(): __asan_load/storeX->check_region_inline.

With kasan_check_read/write(), right now, it would be two function
calls: __kasan_check_read->kasan_check_range->check_region_inline.

I doubt an extra function call would make a difference in terms of
performance: the shadow checking itself is also expensive.

But if the second call is a concern, we can move kasan_check_range()
and lower-level functions into mm/kasan/generic.h and include it into
shadow.c, and then it will be just one function call.

To improve performance further, the JIT compiler could emit inlined
shadow checking instructions, same as the C compiler does with
KASAN_INLINE=3Dy.

> hw_tags won't work without corresponding JIT work.

You probably meant SW_TAGS here.

HW_TAGS will likely just work without any JIT changes (even the
kasan_check_byte() thing I mentioned should not be required), assuming
JIT'ed BPF code just accesses kernel-returned pointers as is.

> I see no point sacrificing performance for aesthetics.

With the change I suggested above, there would be no performance
difference. And the code stays cleaner.

> __asan_load/storeX is what compilers emit.

For Generic mode. For SW_TAGS, the function names are different.
Keeping this detail within the KASAN code is cleaner.


> In that sense JIT is a compiler it should emit exactly the same.

