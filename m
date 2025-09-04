Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648A5CA1017
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7DB8E0011; Thu,  4 Sep 2025 10:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF418E0002; Thu,  4 Sep 2025 10:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5918E0011; Thu,  4 Sep 2025 10:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBE18E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:58:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 438C31A024C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:58:53 +0000 (UTC)
X-FDA: 83851874946.29.3B40F21
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4126A4000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:58:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F5XMMvif;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756997931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjoOxNGipBZMZSrHgnJO7zIqbW8l/mlQVhOAOi/XHNk=;
	b=f7qkXQKSLKnKrsve+wjNmmfdnpJx8zabIQs172QGGxrpHFxBifIsIWJ6jbyhGo0BoJist/
	64jaq1mIeG7rbBZForVSop6BRSd8+TZoPbZDqCFn0QuUXBGWhUyrVi+dL3Wh9DKueuqmIc
	3ajK/32ga9XoJwAUiRBU/Q2s03SsVlM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756997931; a=rsa-sha256;
	cv=none;
	b=6t56IJxP19g/S7ahlHrvetihTVLZ7Smk51+JePIM60XX8RqWv3znJ9uahLXqJuoNyVv0Yp
	WxQCKValkgkbRIkXG8AiARY4CmIiN6ps++9uMSnAVxrT8T28ETnIgmg1w810YEKiu4ZnAV
	uPCpC6eszxnrOFngwLHj+Nh11WHpFhM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F5XMMvif;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3dce6eed889so841554f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 07:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756997930; x=1757602730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjoOxNGipBZMZSrHgnJO7zIqbW8l/mlQVhOAOi/XHNk=;
        b=F5XMMvif51qwzjwKHR+wwo7JnX0jNUBAOo5Us9JUiuFrtcFQXmYZgdY4eBJUmpH8rU
         2zQrnGl3VFaAzMya4VWJLAX3bs0qtZLSTTryaszo/qgFgBd2q4qS4sADQ9brgVvqRiKK
         mfybV1KzbUxnshbr+LwoAVv1LNm3n7XRZOwvjBkAW4PD1TSAB7hXlUZqRtJX2KimctEs
         zwLF/maKTaSwaT6N03NP1IHBSiYRJ05MbxPXOQVfBWHXXcMvFgwDH91Lewn2b88ELs1c
         VVLyzqm/5AkMBnI2rkOu1nAJxl8k5lTBLolhjlFN6IfFbZiMDp2TmDIhE7ZKrvjj63j0
         VlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756997930; x=1757602730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jjoOxNGipBZMZSrHgnJO7zIqbW8l/mlQVhOAOi/XHNk=;
        b=hUvfnbrn55DKQPqIYs+BhXMrJX9s91jVVcSveiOLAWmQxt2KWvr2NACwst6JLk1IUn
         DSEu2FLazbfLAm/NESB7lT8f8FJTNf57dvajxfJX1TWbImj/18LGSObqlej43P+94e5n
         KVEkhTn5Ug/Y3E2htaKYW9RNNsmQS01aonZJLUxiOgNGgkdKBjBzC6CutDNA01BHBoiv
         ZLpzeVsCUfI5NmrAISXezVRZ1k5YI4R2txHrLQLrFCIkgApZ9GVi/Q8gC3SPEpgKljF9
         ii6QETjgR0K2FfIRUBOD2Kszo3f0WepfOtmp0V8F6tPffVubB3INLsB/WZ1p5oYRcj1K
         DUeg==
X-Forwarded-Encrypted: i=1; AJvYcCXsPcmgiCHKVOzK6IbkuLLCO4xmSBJ2aut6+bxTlwC15lzEUGiJBK8TKxWqRhNIyGczT1Fn8yemSw==@kvack.org
X-Gm-Message-State: AOJu0YyMHpUFPG1WeY9JZjvVH6Topty4B7cVD+7+G9xPRTUJIK3v2MRn
	E3tO5ae6rqTGun9CyPGzk8Gg812EfhStDtU8J8OACaxm3yMRfvKr0HcvAq1oYwiCDo2b2mnvXS8
	5stt20Hshrbp4XcBaXoHOv1IhcaTrBVI=
X-Gm-Gg: ASbGncs3OmI+oU0ADVpy9wXG7FrZQc89Z/hDy87ZC7y6HZK1EKgxLxUkmsKyEWvXSB5
	CRkK4+ZqsucdUXYiltWG7IbkH1VWjcyVAByGSR9phh6lr2WZACP+vazyuL87sqCBY8aF0NCKeDo
	9zqnopUF/6FuxGHxn6GRX6oCVwXxE1bhxUlTLEgcEGSDb8UfuYtwxlbonvWZcTCdlGfPb+sbUNL
	FRiJb8=
X-Google-Smtp-Source: AGHT+IEOLYmXnNodyTdeKUcsNwKRu/qrjmwe1/I99spM8q/MVj2nsHb/yfnDKG0O9PUqtUVGjpAX+llHDS6iNPSghBc=
X-Received: by 2002:a05:6000:430c:b0:3e0:4d29:80be with SMTP id
 ffacd0b85a97d-3e04d29815cmr2637642f8f.49.1756997929274; Thu, 04 Sep 2025
 07:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
In-Reply-To: <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Sep 2025 16:58:38 +0200
X-Gm-Features: Ac12FXyGDcz59ifSydw05MuQg_P1V6YF0m9gsQ5VWAu0_B8ZIjHvT6en0L_OHZQ
Message-ID: <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>, snovitoll@gmail.com
Cc: glider@google.com, dvyukov@google.com, elver@google.com, 
	linux-mm@kvack.org, ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, 
	akpm@linux-foundation.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4126A4000D
X-Stat-Signature: 8kkhx3yufhehiy4awhuj1pkjra4dmrao
X-Rspam-User: 
X-HE-Tag: 1756997931-7813
X-HE-Meta: U2FsdGVkX19zHNj3znsfZwz13nmw/kGAJJXAhsnsXSTGScz5no9HisyYn6A+dDK8TvbKJYqO+n94EBjrr2xRjADxBC9D2EU3ggH+nOyETz27Aprp3UTv+qOzRcUZfQHIelGy2xar7IgZt6IafLC1AMDhxMHwknAOLfdgTTq+poMkiGfcCR8FCDOs7/3h1EtZQ67WNIShQ15PR78EE+Lmiivj2H1x+iUpwEofiP8PBjVCFYzvJbZerAzyxBfejkiaS91FwXQ4PdIgG4bVpOoRnSTvcmrG83ff63Y8cICbyFuN0wl8N6pRPwCW27ERe3DQUWF6MNTL6b+uFdEGVmwYQyuhlwFtpsv9aAkDM/zF1Onwy4Gemygr4KzAmRmPQwYrLFODv29sJtcpdFPYCavu2y66tMJdydoN8v9/XjLln+P8OsPj5hULI1D3V+Py4jxIuJ2eMHJitca7j1z1T5ACAQWPu/Za6CiJyA4PIJzq6o/LAlA9jskknHj4Z/gtZlUXjmMtjl+vQSdAnhhPfLnrLUp66G4XoMswSDU6MDn9FYYhITmBzHCeHuy375VKrzp1VJdhTih70an1SEZ5VhbahNp+VMWZLUpe3EpWD/pFkRBCy6l8vrB42bExAl5hTK3Uiipr0itbHIDvzcAp4Z2ArJXgKJCAbmDkntHDiud2z/zTWbovJdrjGHw6HKDelHZGHsO2JOBNnYLklL2gsQZfmU6FXMJHDVwtvqo6pIKQogscUd6EXh8sqLIFMOQ9G2p+d2gMLGmm6StOn083OR24SG7tf7QRXUkJp5XS9ppa+eJ8pt8JNtOiqOHSYCMXqwYKEQQZy/qUFuNWqNcq6aiKdpXOtQROvLSOvzCr4tg4PzAt+ZmKkP7hC72KiUjCE0J3c/2EwIb3oKczmBVw57ntEJnRsXKHZrb4hRTuW9nXYAh3M5UBkwLphsSVEa0YUkqCV86iML1nBRsBMmZhb+j
 DUihbCI5
 lqb2eka8hLMLxt2ke398XtIa+uLdygSNEte5X158gxke5Zv7k6TAolGCnyCXrDiAJAUQeuuwb34TOPOw3ivX4pPCV8oLVOiZ8PGWh5elvU7lGA3TgOz04z5Jcx8MWAzyl51GhVQJia2ProakwVtl/HCnCtJzDPQc5g+U4W4gRKbc92OtoQ2A3J3aNj/PNqBSzazBLJbblQqgRhnXRjZ5dkRjy57FnT7Heb+g9ok1JBML9Qh+L9uugf+2hTcfi9Fs9OzxNeDXXfZ3sOwhkD0L4lH+lfTt+Qe8TboR+8663U9LYruBB++wjlf6MmT0V576IEHPhr+wNNEttNLuUA/xfvMYFE5ndBR3mDIBaU1nTYBMaRmFVSVW/mjyak0obVp7+HoVro1UKSgD5hf9OhQ0b4gE8X2tcGGmO+Q9XFfwxxQo1t5zqZIHL+xITMaEPAUaAjEJR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 10:11=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> > If so, would it help if we make the kasan.vmalloc command-line
> > parameter work with the non-HW_TAGS modes (and make it do the same
> > thing as disabling CONFIG_KASAN_VMALLOC)?
> >
> > What I don't like about introducing kasan=3Doff for non-HW_TAGS modes i=
s
> > that this parameter does not actually disable KASAN. It just
> > suppresses KASAN code for mapping proper shadow memory. But the
> > compiler-added instrumentation is still executing (and I suspect this
> > might break the inline instrumentation mode).
>
> I may not follow your saying it doesn't disable KASAN. In this patchset,
> not only do I disable the code for mapping shadow memory, but also I
> skip any KASAN checking. Please see change of check_region_inline() in
> mm/kasan/generic.c and kasan_check_range() in mm/kasan/sw_tags.c. It
> will skip any KASAN checking when accessing memory.
>
> Yeah, the compiler added instrumentation will be called, but the if
> (!kasan_enabled()) checking will decide if going further into KASAN code
> or just return directly.

This all is true for the outline instrumentation mode.

However, with the inline instrumentation, check_region_inline() is not
called (in many cases, at least) and instead the compiler embeds the
instructions to calculate the shadow memory address and check its
value directly (this is why we have CONFIG_KASAN_SHADOW_OFFSET, whose
value has to be known at compile time).

> I tried inline mode on x86_64 and arm64, it
> works well when one reviewer said inline mode could cost much more
> memory, I don't see any breakage w or w/o kasan=3Doff when this patchset
> applied..

This is interesting. I guess what happens is that we still have the
early shadow memory mapped so the shadow memory accesses inserted by
the inline instrumentation do not crash.

But have you tried running kasan=3Doff + CONFIG_KASAN_STACK=3Dy +
CONFIG_VMAP_STACK=3Dy (+ CONFIG_KASAN_VMALLOC=3Dy)? I would expect this
should causes crashes, as the early shadow is mapped as read-only and
the inline stack instrumentation will try writing into it (or do the
writes into the early shadow somehow get ignored?..).

> > Perhaps, we could instead add a new kasan.shadow=3Don/off parameter to
> > make it more explicit that KASAN is not off, it's just that it stops
> > mapping shadow memory.
>
> Hmm, as I explained at above, kasan=3Doff will stop mapping shadow memory=
,
> and also stop executing KASAN code to poison/unpoison memory and check th=
e
> shadow. It may be inappropriate to say it only stops mapping shadow.

That's true, but we can only achieve this for the outline instrumentation m=
ode.

With the inline instrumentation mode, the (early) shadow memory would
still get accessed all the time even with kasan=3Doff. Which can be
considered inappropriate, as you pointed out (though this is what
happens for vmalloc allocations when CONFIG_KASAN_VMALLOC is disabled
and it does seem to work; but the inline stack instrumentation might
be a problem).

We could limit kasan=3Doff to only the outline instrumentation mode, but
I guess that defeats the purpose.

I'm not completely opposed to making kasan=3Doff work with all KASAN
modes (assuming it works with the inline instrumentation), but then we
will need to thoroughly document the behavior it creates.

And let's also wait for an opinion from the other KASAN maintainers on this=
.

> > Dmitry, Alexander, Marco, do you have any opinion on kasan=3Doff for
> > non-HW_TAGS modes?
> >
> > On a side note, this series will need to be rebased onto Sabyrzhan's
> > patches [1] - those are close to being ready. But perhaps let's wait
> > for v7 first.
>
> I replied to Sabyrzhan's patchset, on top of this patchset, it's much
> easier and cleaner to remove kasan_arch_is_ready(). We don't need
> introduce CONFIG_ARCH_DEFER_KASAN. Please see below patchset which is
> based on this patchset introducing 'kasan=3Doff|on' to genric|sw_tags
> mode.

Based on a brief look, both patch series seem to be doing similar
things (except yours also allows using kasan=3Doff for all modes).

But I like the Sabyrzhan's approach of hiding the explicit
static_branch_enable() calls under CONFIG_ARCH_DEFER_KASAN for the
architectures where they are actually required.

So I propose we moved forward with the Sabyrzhan's series and then
apply additional patches for supporting kasan=3Doff on top (but again,
assuming they work with the inline instrumentation).

Thank you!

