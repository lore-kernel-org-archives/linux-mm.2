Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B398EC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DFC6B0092; Tue, 22 Jul 2025 14:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6376B0093; Tue, 22 Jul 2025 14:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322866B0095; Tue, 22 Jul 2025 14:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2308E6B0092
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:21:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5A53B99A2
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:21:34 +0000 (UTC)
X-FDA: 83692718508.05.B6D4851
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id F1965A0003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:21:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J8I5MNY5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753208493; a=rsa-sha256;
	cv=none;
	b=mJJqPVKvWL6j8yxPH6hKSjzQEbddQTqUMv2kC5LgpbgplEqAq3u5uBYNTbtIUNb/UnnLsX
	QidNJ59EQVTL3J28qRTamuEUfaxllaQ8U7gtu/x/8dA9Ohc/ETJXcXkh4TGGFo7M/xVN5N
	ogQUJYmqsQuRJygksKL7rPe/um67IeM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J8I5MNY5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1bfHAcPl/XMz8xDguK3teTl09r5v0kLVciBst2DtbI=;
	b=BhlsU1NwoFUzy3w2PVbcz93rvJuhDA+px6GgbZBas8wpE6RKNCkyNTGhrJOvbXEMLJDoHa
	p8FP51yenCYSS0KwORboHMjPm1Mwtat9RRCkwO7iLEGKcr+m3/dVX2O8j1eiXkm/spRVDx
	rJ0MLuZt4FnMOfodukcYpKl5rM2c668=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55a2604ebc1so5096786e87.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753208491; x=1753813291; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1bfHAcPl/XMz8xDguK3teTl09r5v0kLVciBst2DtbI=;
        b=J8I5MNY5SEKjTSjQIqYav/SjaiOxvm/tzZGrS1nTGz1BOod/lszSxFkKb+mDo9+uaa
         yk88NI+emU4gFf2wbXI0O7fplS4CvMnlRKD1TygmfdlskPaLPxZaL5lFA4Ocw0wogg9N
         BMwGYGAlN2rg9UREQrSrdKsWAzzGhMG2hwNo29mQp3JOVtKoW7ZuWrG2NnOWXSKnTpcw
         nog5MSB/Y7EUc602IhsgnkeDX6HBhEMT1+fIVKSkEis+plSy+bwTkmuelRGxoxnO2btB
         FBkHyy8FPWVgYH27M9znciP0khDgfquzLcG3MwhvFllosY7TXSvcWRRHpDkyCuvZYNyK
         rQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753208491; x=1753813291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s1bfHAcPl/XMz8xDguK3teTl09r5v0kLVciBst2DtbI=;
        b=QdYRybJD60+ZjYT8AOQ4/OjrbFD81mWdEgy2+33HcmNtusoTvagwSO8D2wjz8Yi+s6
         BcBGbeYgcoudIOAZBFNLrTbUCqc2eWKcJFG0YrNYmkAkgqR4K6HVpa0Tf5z2+9+rzB4b
         dT2j0MFAl0SkZ2vytrzLwNftyEWb8TtRjdOLhsRl2gnStp+zXJpobotWLQAsTntdhef4
         TIzkze/uZlGJiiMUuMRWNcqSBB7Ythb76/l5VSKjJD42pBPkRBztDl3AIkESpa3Kv95N
         GYIENzXZCZ8qVCaGha585Q70SU3hREvrbbQSnJpkOHtH1U2ajdSeODKix/xbiYMco1kW
         NG9g==
X-Forwarded-Encrypted: i=1; AJvYcCW2p6u4f4djEshNNeKjqSyL4lsj9MS2vQgUt9Vr8gvW1qGf5V8hgf4HpxFPjMdsnmD/aDcbEaQIJA==@kvack.org
X-Gm-Message-State: AOJu0Yy/GzUAD7rtLNRKqwut22052ujEkaba98MW5hl2eM2NuiNy0Ek7
	XGMhI8l8bWOV6Bzjo0zop6fN+dLPWwYmUgxCF2u/NIQcNS3RvalXqMXsJgn/KROtwZFUOiJ6Dlz
	To4bZ4WwC90pCqumkIVcTgtMXk7R90kA=
X-Gm-Gg: ASbGncv5YU4+PrzcrHzjc5/Ru/aEn+w3eINfeYtMAeW+4oBMVPpXS5XXTGx6JqrOe2+
	Ifz+PavkMq2wLsu7i4iIZlBeCQA9RSX2k8cEpwTokXoKvwVtmlnYrXY4e6JQpL+qObUJrrErsCn
	xX1uzQwcZrFgAKgdqOiGEWTngFVO5IADUlqTk+CVafzNraSi052KmXeOiz/SUEsiYn80f8cWcLP
	ZkdCpc=
X-Google-Smtp-Source: AGHT+IHgqZRO4CHZDXwO8i4qviF6GOSHLcIqgaK9MAu32BIYgiKkWD327bPslpy0X0mdn5DHRJd+TcwlCu2XTW4y0IA=
X-Received: by 2002:a05:6512:4021:b0:553:2190:fef8 with SMTP id
 2adb3069b0e04-55a513998a5mr31899e87.7.1753208490745; Tue, 22 Jul 2025
 11:21:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250717142732.292822-1-snovitoll@gmail.com> <f10f3599-509d-4455-94a3-fcbeeffd8219@gmail.com>
In-Reply-To: <f10f3599-509d-4455-94a3-fcbeeffd8219@gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Tue, 22 Jul 2025 23:21:13 +0500
X-Gm-Features: Ac12FXzOVMCIvnTEhZltt3TS4XKarYeDIkGkWcMAqG0GgJ62pPTw9Xni6fYiOgs
Message-ID: <CACzwLxjD0oXGGm2dkDdXjX0sxoNC2asQbjigkDWGCn48bitxSw@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] kasan: unify kasan_arch_is_ready() and remove
 arch-specific implementations
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com, 
	agordeev@linux.ibm.com, akpm@linux-foundation.org, glider@google.com, 
	dvyukov@google.com, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1965A0003
X-Stat-Signature: gpjnsi18c1xyt4ey8jx5prmfwwmr946t
X-Rspam-User: 
X-HE-Tag: 1753208492-203523
X-HE-Meta: U2FsdGVkX1+WcMCySTbihoVWaWwEmxo9xo2sLdrS+PVQ7sT2rZ97dJRa0Gfp/SvHMiqP9men0hWZBUggq6z00qpQULibHJACCpINgIr11aof2fHhYcl6eM6hwvxdGqQpNgeInsWQciKBbecUmHJ3q09dZOMc77lVV4Ylu/SXwzCFRFFpaq3+LGekW0T2EiyQjZScMlQl6yi7mUAbfa+xykL28VrmhdgWLArdusFiXOMUB3nxTNT5lSdqY15P6iCSEZjJ740mmFuVUKBzmbXhW22L27uwk/9KQYeAFaXdG+ObWaY7axkX8rr7S1yxw8l7fuNtom9ueabJnYgQw/r8dlFumZxzm96o0zU9uepPtP6q4GOV/ey6CezJwWxmdvLPCQYso/Q7qSG+zhY3S1ZVopRm1Vz/ZSMlY99n4lczFEWQCJgmcPrYxcnwvlwQepuxwXgNjN3V4ffJleVE6AyGsS90EjPNYax9Hhqnj+IqupbV68depYouiR170Yxch0zIE2Qo5Lu43ler1CmO0Uo3J0qYFf5/QWUUgkH1ZdO8T7l0KyEgF+Stb0wXHATuqPn8LAqbT4mIyS1pcGvdTeDlNTOtg7ARRAY5YDeOVxtgx3q2fFbLEOo8Wx97AiOJ/EB1vHQZIVxcmVue0/EVr0Pa8SRPegcF1trwdquLS6vTwplOWEG3S/wjLDrBvxJqY9GnucuiHzLFZDSxJ14cJxh4ZSKylDMO1wdlSGyUPzEKmRXWnfxgEtyZYeR7j3pzFyy/Fk/J9j7jMde6ZTMbYKDmcVfX2jFVIZ+hzl1+FaSXkMsySaWvaZry3OK78lQwWmn3rGxt9YtHJtaZv4H1h96nIIOn9adjY5en7WX3LgBSWaTU2XEHQnvbtbCN7aB03d+x/D5lYokOTi004ryURDqs7bWSoeyEt2sh5a8zIxY3XqvwA9hpVwozv1l9gHj6txrsQN4+WtH476bFlAx/8Kg
 Ot5MFi3r
 jcDnXfMC/+n86jBlTTQEIvTbfswd7SJUaLSUROuDNs032H+9UyLoKQg3v3TlbqfDn+0Bq2oCPHn6SXRhqAYZyignGt7mtkBFbZxVo69BCwZoJnuo7/hon7XcA/7MS7xhgdzdaNAYVoOdHD5ROqIZJo6c72DgYD2MqKp1DXf2Ur52hUzeyBxSkemVTbA80/2M+ovb2NMFtLyXlTRZHG4kdr296ZuLalGKOyCAjG32aq346mAwRN6oko5wg2j7v7undDM7J5tgyOst8C/DCFAqIqocR2rWMfD5ubJ536xpj/dzC6q/HeyeiqSyFyD0IcOtr6c/scSQ2FZ2VQJ3qsKm0sjOixoHEkFXgedLBiomP+gXCNnbfhknxTu9buHL+lli9ndZKtOzQ2aTUd2yNSMJESshFsjOSDADON2ls2yqDhqiSIvoWRzSJp/y29KoAF64SOgGqJJpzZx05ps1GgdhHb5mszP1BXTIOrKK4psnbshrza00R0yUNroPtCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 3:59=E2=80=AFAM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
>
>
> On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
>
> > =3D=3D=3D Testing with patches
> >
> > Testing in v3:
> >
> > - Compiled every affected arch with no errors:
> >
> > $ make CC=3Dclang LD=3Dld.lld AR=3Dllvm-ar NM=3Dllvm-nm STRIP=3Dllvm-st=
rip \
> >       OBJCOPY=3Dllvm-objcopy OBJDUMP=3Dllvm-objdump READELF=3Dllvm-read=
elf \
> >       HOSTCC=3Dclang HOSTCXX=3Dclang++ HOSTAR=3Dllvm-ar HOSTLD=3Dld.lld=
 \
> >       ARCH=3D$ARCH
> >
> > $ clang --version
> > ClangBuiltLinux clang version 19.1.4
> > Target: x86_64-unknown-linux-gnu
> > Thread model: posix
> >
> > - make ARCH=3Dum produces the warning during compiling:
> >       MODPOST Module.symvers
> >       WARNING: modpost: vmlinux: section mismatch in reference: \
> >               kasan_init+0x43 (section: .ltext) -> \
> >               kasan_init_generic (section: .init.text)
> >
> > AFAIU, it's due to the code in arch/um/kernel/mem.c, where kasan_init()
> > is placed in own section ".kasan_init", which calls kasan_init_generic(=
)
> > which is marked with "__init".
> >
> > - Booting via qemu-system- and running KUnit tests:
> >
> > * arm64  (GENERIC, HW_TAGS, SW_TAGS): no regression, same above results=
.
> > * x86_64 (GENERIC): no regression, no errors
> >
>
> It would be interesting to see whether ARCH_DEFER_KASAN=3Dy arches work.
> These series add static key into __asan_load*()/_store*() which are calle=
d
> from everywhere, including the code patching static branches during the s=
witch.
>
> I have suspicion that the code patching static branches during static key=
 switch
> might not be prepared to the fact the current CPU might try to execute th=
is static
> branch in the middle of switch.

AFAIU, you're referring to this function in mm/kasan/generic.c:

static __always_inline bool check_region_inline(const void *addr,

      size_t size, bool write,

      unsigned long ret_ip)
{
        if (!kasan_shadow_initialized())
                return true;
...
}

and particularly, to architectures that selects ARCH_DEFER_KASAN=3Dy, which=
 are
loongarch, powerpc, um. So when these arch try to enable the static key:

1. static_branch_enable(&kasan_flag_enabled) called
2. Kernel patches code - changes jump instructions
3. Code patching involves memory writes
4. Memory writes can trigger any KASAN wrapper function
5. Wrapper calls kasan_shadow_initialized()
6. kasan_shadow_initialized() calls static_branch_likely(&kasan_flag_enable=
d)
7. This reads the static key being patched --- this is the potential issue?

The current runtime check is following in tis v3 patch series:

#ifdef CONFIG_ARCH_DEFER_KASAN
...
static __always_inline bool kasan_shadow_initialized(void)
{
        return static_branch_likely(&kasan_flag_enabled);
}
...
#endif

I wonder, if I should add some protection only for KASAN_GENERIC,
where check_region_inline() is called (or for all KASAN modes?):

#ifdef CONFIG_ARCH_DEFER_KASAN
...
static __always_inline bool kasan_shadow_initialized(void)
{
        /* Avoid recursion (?) during static key patching */
        if (static_key_count(&kasan_flag_enabled.key) < 0)
                return false;
        return static_branch_likely(&kasan_flag_enabled);
}
...
#endif

Please suggest where the issue is and if I understood the problem.
I might try to run QEMU on powerpc with KUnits to see if I see any logs.

