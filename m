Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5412C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 10:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5B56B00B6; Fri,  3 Jul 2026 06:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8CA06B00B7; Fri,  3 Jul 2026 06:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2D76B00B8; Fri,  3 Jul 2026 06:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2AB6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:34:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4D3B1C3810
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:34:46 +0000 (UTC)
X-FDA: 84947106972.24.743B3AC
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE44E180006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:34:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EFMvkBP0;
	spf=pass (imf16.hostedemail.com: domain of voytikd@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=voytikd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783074884;
	b=KFqo3nDpLmY10xPZJSoAS6XDvFdhH05Z9DQNFK2Yfu4ln/mB92vfbEttMwNVVO+Auzx/YE
	bWECXoFWLla31rqYI5zC5H0Jt3UucqXo21MsNj4CYSmbZ92uGIdc7KfFSbZOLodod86ocj
	JfQJ/eEvHh/QV7M/Pkro0BSmVHEJPg0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783074884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8LUR4Sbsf/2HA6eQ/tW5neVxNihHuerj3teR8ao+Zg=;
	b=yvwR4fRATLlkbtrKcy4knpnZOuprf9gLnF/AaiWbS8VZs0szUWtc/hooGMmP4QFcZeNf2Q
	2aV0j5bK8Pltwd8HMnGPVdb80bi7BuQHkW93HAiQTdMBbHyzCCoemZWQOGDd7j396KfGJz
	9tCOtyb2I0G1qQskWL3Ehe7bYH54vwk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EFMvkBP0;
	spf=pass (imf16.hostedemail.com: domain of voytikd@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=voytikd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c125bce2294so38081666b.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 03:34:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783074883; cv=none;
        d=google.com; s=arc-20260327;
        b=Kt17orse5ZoZ6fiqA9hG3R/ka8djnwNzJMWGeqbDOUDrw8+msBsx7WZo4RxySc3WB+
         TLLPEDAr0bowUxfbyt7yhPCBCR54hrFPPU7vgmAdeNxVU8miw6xTAId0ZYkRSg13stjs
         zzXUv3uapYSIEAKV3YfgtGNBRgeQVOeCNK/rIp4oQYPdmMG6CNxSRgpfZDC00x03uU9h
         I/UUf1+LZiM3kjglIMHfQpPxmE81eyBAnReAq8ZN2As1t/IQv0A0FhRThpvjxhDonqQJ
         BcJ5q6VEFoxoZKWFI51F1Y+8ywtVBpvfTbVEpxL5dcxyzfnM1xp9uIocuvcg4TiQ0IrQ
         6YpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h8LUR4Sbsf/2HA6eQ/tW5neVxNihHuerj3teR8ao+Zg=;
        fh=5eUokobw6fl++Ct2HRjljEwcYGdLm5CR/Wx75OeSF0M=;
        b=WQ2hWv+Rlj/jRWGW1/DmoOOoyBVXACbWAZbVxPNk+T37PNqs45Vu5fDmdPxo04O33h
         pGxsZXta4h/zEp9Zq8hhWZLyaI4nYZXj4TZAP5gtgVHQdAIUeIEuy5xcBlrNF3z7ttwY
         NjT7R15IdqTRmugFsuSov4JeHMEjnASiN9xuSMNLCRLgzhfoV0AvVFAcqVbGuhs65jB4
         NdlUpz8nKa4YkFalizL9qmlNdCSTtHZap79DD9xRNJJp+R8em7xBam2zUiu/fCoR+R1t
         0KRd0x177bNnluiXfTPaPtz5cwlFRvz3nbo/uDmw+zOOJZA7k7PAfJZaMRQBh4/sFbCM
         nHUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783074883; x=1783679683; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h8LUR4Sbsf/2HA6eQ/tW5neVxNihHuerj3teR8ao+Zg=;
        b=EFMvkBP0EeWwKFNxAKbDeQLZNspWAhjHvwKKBZM2OMrOGda2LFhYzfWXyR3vyjGTjf
         YeKfkcudtoeVqsNnIctRI8ruqybXw18WfPIfcQAasZJVxV6pN2h+nTKP2N6XdHx0CKv+
         RUIMZ11IatyXqKNLfguMW5pKg0NtYBTpRZq/YZYISOPLyLmgIUm02z1JZFtCzaxHHH6X
         2y4qMSTD5mT1Uk3zDDoGoGym0z+t1bjDzjXxx8vFhWUVbyJiDzHWyTStRm82DY3OaFRP
         wpc+GD/jnaZlMBz8Rcxh0H2c+QwzIf3Sj/Xs2iGKmNuze7xKH8UYAtezfyIZX3Is/lgV
         O/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783074883; x=1783679683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h8LUR4Sbsf/2HA6eQ/tW5neVxNihHuerj3teR8ao+Zg=;
        b=WTlpR1w7sGZQ0TKtckFFvZyDOpefoGYa3QSf0q55jg7gdzhtTOBxd9dgetOo2VFBPo
         S0bSvBJ/LHnnTtiuvHX+vkGxrcMw0VST58NG4+gNvHJbFfTq9OYelJcpdLvPtoOrTrib
         yDXeZnRieR0Rw5xrW9NAYet1Y4X0f9AUwiyQiaHJuAWe+OevN3QcyMzfNxKht3eFCkRF
         luCw47gSHEzjA8OUAnu8wyBItgMXH5t+8tCMVyMqj6SyUmnOD+RHFHVsv9D5OyW0YIMu
         sxSQ1sMw0dL+Wghp/2P7AXbFtitp2p4wNDsKWGOdmnYRm1K2uFBfOGrv2KixipPTwzIf
         tibg==
X-Forwarded-Encrypted: i=1; AHgh+RqPsbTJ7HZjGdTHtHer2e5upsp7gEEvukGBi1lk10/3bHh+2m7jU70NH9KXlrHMWzPl67wAZ0VRdw==@kvack.org
X-Gm-Message-State: AOJu0Yx7iApNHeFAcx8Jz499UBpT7gcxQsP9BvjobedXmQABPr9OU+Ea
	FtLygshist9BKg2UOwXJeBRpla+i+lJlcm4JzbDugWFBC2QnO+U3cgN+K3gcz34hb2NP8hrWnoE
	YnWtRpYeUVNvopCgCPL68GBpcajNnwbE=
X-Gm-Gg: AfdE7clPPvbo9LIESAmXkm8mz2XlMSYimhbGGNbzRCyNVQgv11Ub/MgKqLnP5B9IOOX
	Z4LTJopN6GTcW4OQHOxq6PX2YQyCpYhD+LL8OTMlrEdBfhJ7QmNbIjNYR/Mtw/5T1B5lvR4aTCG
	9iH6QkZyThhRVZFcN1F/DqYpTinVzaFxL+9aLK9hzPfvO5sMQDYZeDi15sU2/dog5aZAlRIbfrv
	ScpLgzPfIgdvKJzKPqP9j0arxkZ6KU3WI35KtOeixFet71JeSaGJ0OvDeeIR2tTVkgAeHWCfO/2
	561BeG64vT/SyhJkbnhcXANzTFrO6tAEPGaCXrYBQNMiK7kzHs4Wobm1dodgi9Tk8/YOieegQGg
	h2mdxyA4xBZHwLZV85PJ+
X-Received: by 2002:a17:907:3c96:b0:c12:39b4:413a with SMTP id
 a640c23a62f3a-c12ae4a691dmr467743866b.23.1783074880994; Fri, 03 Jul 2026
 03:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260701125151.352632-1-voytikd@gmail.com> <20260702025342.GJakXStrsCmIRnEwFD@fat_crate.local>
 <CAAX90H0V-=Gy1FyBT9qop2=RvhBxbOPLu6+DYpPH2pTehT=nRw@mail.gmail.com>
 <20260702111550.GH751831@noisy.programming.kicks-ass.net> <87se61npie.ffs@fw13>
 <87mrw9nonk.ffs@fw13>
In-Reply-To: <87mrw9nonk.ffs@fw13>
From: Dmitry Voytik <voytikd@gmail.com>
Date: Fri, 3 Jul 2026 12:34:14 +0200
X-Gm-Features: AVVi8CeNxREOJYVsvGFt7qdLJ3ZpuKcTnebSQ9SjudTefEGZU-k9b63Ysrg3hes
Message-ID: <CAAX90H3Nw+=gKOxPXpOwvDrbvWzUjgtyGoRJhCwsWz61s2XbQw@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
To: Thomas Gleixner <tglx@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, linux-toolchains@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankur Arora <ankur.a.arora@oracle.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Marco Elver <elver@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j3s8z883e4c5ewnd77kijs8m54x94zw8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE44E180006
X-HE-Tag: 1783074884-153687
X-HE-Meta: U2FsdGVkX18ix/TK9sCOAVyE6sbTWVfB7rrzqINfvtPxd+wae+mBQCobtBXJxIeUXXUAhTG7AeT4CnlqNkz0/nf6BY6KO6O5+FZbsLWXGaq9sgZfqTjOp8UAVlt+IHLgt4nzsOGaIZxWljk2tjrEy+n4d0XfSvOV2Z68Z4SQWfFGKpY6YxOQTLqAPl2bDIEbvbXDpIAgx40xWf7xd5FGwdQcSjtsRFZ6zuN8cyHRCxWFvUPmVDR9Ogq382u++vbHfHRMhgkw0k6/G6Takh8qY38XXSeyDiBzR6/l7d8sa3dSqgXbcW7+W5ZauX2rKJlmn43iMBbmcot+qZgeYnCP4B1UmC5EdxvrlVvN3Lkav8y0C0VmlyEEVHYivJk8MiF3CoeJTHrGQJNxNgoj68hlq16x+0ArSONjuVO0As9qMuGcPdeOBeEN4cd2lZE/5haSge3u9ImLE3JY/E26khdZrXY7oTjDhAC5CJ/QpUVTViNPbc3uagYjEMdKZzz3dXT/i0v3hvHodGdlU/lIbPohiPubIYdFn3KLKh405CLDxKnwIn9rj5dfU0WEHsfGtDltn1sNknS81+OYfxEyMLUlAHyzmDBOTtDfxU1jrcbXNhX4FTugl+Dyul8UrAnDkWO+oVK+qmySHWdW4rktfGH+0pDUUUeTBj7FljcsSdovBghxelIUBgnhs8Zk9y0SybvII6OWOEpX67eb6ugLOsp8Ef0uAPHyvikeNsf0GbeJiO04FSzXgt0DZ6hb7ejNIhXHzVR16rX0Zn2bVsxHKqY3k0qxYKwJ7ZQgVTb5r/pyqBjbjBWVWiNNerUIIBgS4XpgRAGqewRF+2A4kEzua2PLxUwHp7aJxCAKro7k/96DzJkU6vY7LUcx6vmWFefbnivLCy5Ly6b6xb/PoTti++MNou4l9mNmmEKzwJ4yJR5uaIEwZONkPtWW8CJ8h15ZNSYdyYuQFHNzUcT+cAMA4Pq
 ASXXXznr
 Pn+bwd9592J7qTh6xyPnvdSEhKcfaawLKLKRVc/+ffD+YWvaoMTpjFG8/oJ/FMZnTvkvIMm8ANprq8gITRdhFo49shGsPwnsEha/qZq0rJGi3vmyhE5iLquIvQ5T+QjbOD5agvcZljYR57cO+y4vjJwFk4Z3jc+voxy+mA73E/Vne1TFwAblgpdX37igIyVr/XuVt3y50hxBSSfT7ymAdTV4jhWcKa2VMP2VaLhNwXUEmH6sOlCYyOmrOthCp6uyR6luBccOCCeTAa+wUc4s5mpCGP5GYjh0/e89KFq9XQaZ4UhZsMaUewZ6FIAw3uggSqT/+lo9BkG8ZxQads+JmdE1yHsLSpJOo+Ww19q97rc7RdlDrkedaIBlKNJEPsqA7mElGeAYga9bFALpySRjFhyfW51prnFzEqoLUoZFh3jSIEKSUVKKlyXNYbik72QmKuEvsvv3O9Zi0Cdmz8bfofz5dCHXqpHm/QGsmW59Slt6NUxwrGlFM/1xs46AQoz5ks/Pi/eKItyyFVAuGLP4oluevtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On Thu, Jul 2, 2026 at 10:05=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> On Thu, Jul 02 2026 at 21:46, Thomas Gleixner wrote:
> > On Thu, Jul 02 2026 at 13:15, Peter Zijlstra wrote:
> >> A quick test with folio_zero_user() seems to suggest the
> >> ASM_CALL_CONSTRAINT movement (your patch) generates the same code for
> >> defconfg as does the unmodified code. The change from the thread linke=
d
> >> above (input constraint on __builtin_frame_address(0)) generates
> >> different code.
> >>
> >> A third option is to force FRAME_POINTER=3Dy for KMSAN builds -- for n=
ow,
> >> until clang is taught to be less insane.
> >
> > With FRAME_POINTER=3Dy I get now with clang-22
> >
> > vmlinux.o: warning: objtool: folio_zero_user+0xa7b: stack state mismatc=
h: reg1[4]=3D-1+0 reg2[4]=3D-2-336
> > vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x64: relocation to !END=
BR: machine_kexec_prepare+0x8f0
> >
> > That's with your objtool patch applied. When I remove that then the
> > folio_zero_user one goes away. The relocation to !ENDBR stays.
> >
> > Oh well...
>
> And none of this boots when KMSAN=3Dy ....

Thanks for checking this!
I wonder if we are debugging clang here because I just retested the patch w=
ith
CONFIG_FRAME_POINTER on the current Linus' tree and it works in my env:

clang --version
clang version 22.1.6

git pull -r
git show -s --oneline -2
21f3d2b2069e (HEAD -> master) x86/mm: fix objtool failure with KMSAN enable=
d
d2c9a99135da (origin/master, origin/HEAD) Merge tag 'device-id-rework'
of git://git.kernel.org/pub/scm/linux/kernel/git/ukleinek/linux

make mrproper
make LLVM=3D1 defconfig
./scripts/config \
  -e CONFIG_KMSAN \
  -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
  -e UNWINDER_FRAME_POINTER
make LLVM=3D1 olddefconfig
make LLVM=3D1 W=3Dce -j(nproc) bzImage

grep -e CONFIG_KMSAN=3D -e CONFIG_FRAME_POINTER \
  -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT .config

CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=3Dy
CONFIG_FRAME_POINTER=3Dy
CONFIG_KMSAN=3Dy

qemu-system-x86_64 \
  -kernel arch/x86/boot/bzImage \
  -accel kvm \
  -append "console=3DttyS0" \
  -nographic \
  -m 8G -smp 4 \
  -serial file:serial_out.log

grep -e 'Linux version' -A1 -e KernelMemorySanitizer -e 'append a
correct' serial_out.log

[    0.000000] Linux version 7.2.0-rc1-00009-gb0b29f0286be
(voyt@voyt-laptop-dell) (clang version 22.1.6, LLD 22.1.6) #1 SMP
PREEMPT_DYNAMIC Fri Jul  3 11:55:02 CEST 2026
[    0.000000] Command line: console=3DttyS0
--
[    0.218380] Starting KernelMemorySanitizer
[    0.218382] ATTENTION: KMSAN is a debugging tool! Do not use it on
production machines!
--
[    4.037384] Please append a correct "root=3D" boot option; here are
the available partitions:
[    4.037772] 0b00         1048575 sr0


Could another CONFIG_ be the culprit on your side? Or, has your clang
version some different (buggy?) behaviour?

