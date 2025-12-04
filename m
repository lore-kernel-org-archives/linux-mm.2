Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C16D216B2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 16:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D6C6B00B9; Thu,  4 Dec 2025 11:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A243F6B00BB; Thu,  4 Dec 2025 11:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961516B00BD; Thu,  4 Dec 2025 11:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 869E66B00B9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:39:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16882580DE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:06 +0000 (UTC)
X-FDA: 84182348292.17.178036B
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35842A0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U03lgmr2;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764866344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUx19gRPJQTm4oWcB8wA8j6Dup+z8ZZpv7z/N3R45CY=;
	b=WZGFboIc2Oepd03Gg/ACWbWM8KVTM7O2APc90qjv3FSdaJVMuWbDfAFiPSRq6aLbsrhTAF
	Kg1f1fOGoB+pPZ3gWv0l3o2SdNpRmp9xF3rlJrN7TxJZM5ET2Ncedavb/yYXQX2eN5BJDh
	IAegFICwlOjZMM98mj0fd4zFvhp/Q2o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U03lgmr2;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764866344; a=rsa-sha256;
	cv=none;
	b=TkcISqplU/y3Exb7/hNH4Gfq8VborxsYby+fhCZc0fkvj+Ih0bhryJYUxpLI02viwwosB1
	ziifX8LNw14aOFkn/cmaZRcFEArL1ZpuV833Jyu97alo988r4gbmGjC8vq2Pmr0SqGU+uF
	DW+at7kqjzsd7OUvmA12wLTNNjOXq1Y=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42e2ba54a6fso497935f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 08:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764866342; x=1765471142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUx19gRPJQTm4oWcB8wA8j6Dup+z8ZZpv7z/N3R45CY=;
        b=U03lgmr2JkEA36OmBnFJLCl2Y/XtMwO4sEsQ8SCEFROpihkD6Y55lCv6qs01xYHFJz
         OLwUKxHCtluN3DU5t8WpDwfB7Omtx+k2Q8buyJXjFpaHhx1mQWIKzSCNU0Y3/MZyEv+5
         6pjuOypB2xbZB28eAVNCaTEpBQRQSPJcbcMKxf9ldPdytWI/lysH0kZEcsTxgK8S9Lkr
         TyJVBgUQRPOA9pdvNfiUMSr3El7IobXBoh7q8K0xxADAfeUlPT+F0a8H3xLyPC2aUTiE
         5yRvGjxfQfHCEvtRfQgbEdaEI5uuy+yEDVi7lbmLeUbQkkrpbBpTMO4GIRZsA7OfKcUi
         2DhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764866342; x=1765471142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rUx19gRPJQTm4oWcB8wA8j6Dup+z8ZZpv7z/N3R45CY=;
        b=oZhW2ySJx+pRmsjZaTzKn6bPwVGFSWTv5jl/VJHAdlpRUpfIzyJzTmhqa+Opz3WMpj
         Z/ZMCzndYLlteUbv2aUkx/oqqNhiO/gVrJRuzUg7/e3ETB3zwmBX1ShthKeqpkBObct+
         IVc0FArsOM8L/ZbJdI5rb81MNsprHohgsmmkaLrp3Q2RQXrf92sc8dVXrlZsF6DVpO51
         CDjzqLkYvLGKGWI4RxZhcGJTflIY+mAQdBpAYNCNf0iGhOSYDcQtxrRnVEtY/EftmRCh
         QbvQvs6pwiJSaa4LDmNRq665i/zA+obBwO/O16MsEpdDlXHJ3+E+4VMQQFInZ36dpoD2
         5jzw==
X-Gm-Message-State: AOJu0YyuEmA0bMGwVS97pXsCcau0W/iVjn7UPU0kNDtOBCiMpddK95Uc
	nUdxkkskVz9GjtB3gF4bc4UPIHXCZuQBufMhHm/MBGr70vhahzsadcl94uQLCrAJ5brIriH3onj
	MizMWmptD0J/atKZ8+qIkWAFn3lVxFvE=
X-Gm-Gg: ASbGncsnTdruT2C5THVo3lrzWuMtWBM5oiuiSHT0hgx/tkmDFV64bDRCsoJtfQXe6fi
	KRDRTtCJa1EQZ5XJ6vdiLfQOpDAj6wS8HznLdgyIIY0FTl7IVRyalj3qTqqCBWyJf++d/7ABDfj
	hBa6dOfIzf7bMMYSnxc7+a7Qcj/f8S7bIWiVH9ibAxZFltRdJp9xUa2NapBaHGW1N1VpP6xj1Iu
	KCLEYH0t2GCdg1ZPbPWDv6xzgSxZf0kp6q0c/2P/4IyKVzhbwDiz2vI5zGnQW2U3TPU1wMkKnDK
	b2eW+Cvw9/sKH/qKDR+PiDQ0vpcI
X-Google-Smtp-Source: AGHT+IGchSnUrQ/wDgunFbKiGCgSohOTthx/72He3/1KfLAp2MSCE2NdUITIhsFDOGle4TG+EFrRDmD4Qe376vybhIo=
X-Received: by 2002:a5d:64c5:0:b0:42b:383d:9c8e with SMTP id
 ffacd0b85a97d-42f731c2e72mr7003661f8f.41.1764866342105; Thu, 04 Dec 2025
 08:39:02 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 17:38:49 +0100
X-Gm-Features: AWmQ_bmhKUWGLOGRduhfezxTuPYTkb1LvtYgmV18KfelSCQT0T4sQ7pI9eJTnYc
Message-ID: <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35842A0005
X-Stat-Signature: r747k3mcfc9o4f1u75myt7js4848uo9o
X-Rspam-User: 
X-HE-Tag: 1764866343-417550
X-HE-Meta: U2FsdGVkX1+I3mvEcwyg9+bHKyBikKvbU14T2HOa2CogWU5KIAc1iAE0AX8Fcyf7wpKilpEYxyJYZU9Y1n+wKtJHBzgctORpPo5TZVqFvhem7lAY5nsa+GVuMGmsnboIn4nMb5cST79UDToliuMGfFI1kgdqJii25xd1GI8n0bgRiJFzC7MuvGCeFvgfiXEDwQHmzLPT9toGCGFVFK3I6b66xnha4Xao5TlT4T7nUNFpZ4Btj90Hmb8+lggXrx/TbaPDip2wgjGiqmLP5EY+w7WeJevBIN6C31omZiAN09xFq64fagOA5fiC7WxwLjzOkYFIFY/Fodybj+xVQ/8QrEUB6OfiRQUkSvL+dpio7YOYRuj9hLNSIsq6HZFHzKC90A5vhP5V/nKPIXlEXjBb1uUqPnlmFRZXMsO4kj42L0VaU6aW7aTXk0BI4d+X31mQKZRm+HAyccLBT2fuAk7R3fo9UY4Iae+SkKUV/DCHjJ+djVUaKGgVK5L2jAXZvmvaNf6IEOz2X6TrDKEChHS30bO5cS1WlAe3ZDzaXfGsMB7WDjGJV+hzCLvnSrJ5Y+A4cRk+FEFXrFQCY5ea8cs1Te911pd9kz+lw8cKbKtV5D1jfbGcBDp962yRsBx9zgAadvRhbXe8v/ab9s/DabR/viMLioQLlTtDUUFmDZcbL78Ru0xgQQy5ICt+fID6slVglw+NI5FUTcwDQOBtsfomsHoRR5B/jy3tU//2hhUEGY4ku14CQIF5j8fkF+6T+4ieyZmE3oZbE2puW8U6EHeOanE1fXp3apwO/MPveLD+ktvl84qmk+n0SJzWIJ/KwzdIL4jyq76FBKczpxYbI8wZxxD+SGAXWhKnFw1b2DBAPyu4iN57SsLunLkrDHNZz7pRB8+1ITfI0EmMfFVdm2+OY2c51UhefzsIbToyD5BpbsU/pBJUdQE8WbyDKNR/Z/hb9ucpZHZXqPft0D1ks3A
 7GY8Jkui
 SryPs7QK2zvn1o+0G0DqCKsAY15l/yPoOFSQOIq72PU7wLI7Eumnws25ecHyVCexbPkF/Xyh3sy8V290R5fKQeVBH/FUrnNC9fnLXtYJmgLDHHpOVOEVTWOojHFPsKt5C2Y1cyLPwLXo5O3WeRG7TViGaJzayfRzDDfM3EEICcUadFySs0FAtJEKng5AFWZ3CQyQPpFKdPAQPej7ND98jmB7UVxJrTCcYo7nPn2X2KYUGnRwTWwp7YVXf4wMxxcr9+ySzwl8cCfxEVqb0FSEW5o33lCNFnyfyuuYUd60+6hrVN/YW2mW5qxx8aTWE8vQvmvYo52Cm6MVBXBJVrdLfHnG3hEE/B6YbP0XkHt1+cuSQGPp3eoq+G6hzFFRBq2tUmR3RIircwmHh/L1fiEkqV8P/ik95KLDmNNg9Fmqat2rqjPAGwQ0JQxvnLnapnZClmirkvYLnNqVr+DMbl5HHrGB65sY6n5pmOVUv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:33=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=3Don|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built.
>
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> while in fact it's meaningless to have kasan in kdump kernel
>
> There are two parts of big amount of memory requiring for kasan enabed
> kernel. One is the direct memory mapping shadow of kasan, which is 1/8
> of system RAM in generic mode and 1/16 of system RAM in sw_tags mode;
> the other is the shadow meomry for vmalloc which causes big meomry
> usage in kdump kernel because of lazy vmap freeing. By introducing
> "kasan=3Doff|on", if we specify 'kasan=3Doff', the former is avoided by s=
kipping
> the kasan_init(), and the latter is avoided by not building the vmalloc
> shadow for vmalloc.
>
> So this patchset moves the kasan=3Don|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=3Doff in kdump kernel to reduce the unneeded meomry cost fo=
r
> kasan.
>
> Testing:
> =3D=3D=3D=3D=3D=3D=3D=3D
> - Testing on x86_64 and arm64 for generic mode passed when kasan=3Don or
>   kasan=3Doff.
>
> - Testing on arm64 with sw_tags mode passed when kasan=3Doff is set. But
>   when I tried to test sw_tags on arm64, the system bootup failed. It's
>   not introduced by my patchset, the original code has the bug. I have
>   reported it to upstream.
>   - System is broken in KASAN sw_tags mode during bootup
>     - https://lore.kernel.org/all/aSXKqJTkZPNskFop@MiWiFi-R3L-srv/T/#u

This will hopefully be fixed soon, so you'll be able to test.

>
> - Haven't found hardware to test hw_tags. If anybody has the system,
>   please help take a test.

You don't need hardware to run the HW_TAGS mode, just pass -machine
virt,mte=3Don to QEMU.

I also wonder if we should keep this kasan=3Doff functionality
conservative and limit it to x86 and arm64 (since these are the only
two tested architectures).

>
> Changelog:
> =3D=3D=3D=3D
> v3->v4:
> - Rebase code to the latest linux-next/master to make the whole patchset
>   set on top of
>   [PATCH 0/2] kasan: cleanups for kasan_enabled() checks
>   [PATCH v6 0/2] kasan: unify kasan_enabled() and remove arch-specific im=
plementations

Note that are also:

[PATCH 1/2] kasan: remove __kasan_save_free_info wrapper
[PATCH 2/2] kasan: cleanup of kasan_enabled() checks

But I don't know if there will be any conflicts with these.

>
> v2->v3:
> - Fix a building error on UML ARCH when CONFIG_KASAN is not set. The
>   change of fixing is appended into patch patch 11. This is reported
>   by LKP, thanks to them.
>
> v1->v2:
> - Add __ro_after_init for kasan_arg_disabled, and remove redundant blank
>   lines in mm/kasan/common.c. Thanks to Marco.
> - Fix a code bug in <linux/kasan-enabled.h> when CONFIG_KASAN is unset,
>   this is found out by SeongJae and Lorenzo, and also reported by LKP
>   report, thanks to them.
> - Add a missing kasan_enabled() checking in kasan_report(). This will
>   cause below KASAN report info even though kasan=3Doff is set:
>      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>      BUG: KASAN: stack-out-of-bounds in tick_program_event+0x130/0x150
>      Read of size 4 at addr ffff00005f747778 by task swapper/0/1
>
>      CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.16.0+ #8 PREEMPT(=
voluntary)
>      Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F31n (SCP: 2.1=
0.20220810) 09/30/2022
>      Call trace:
>       show_stack+0x30/0x90 (C)
>       dump_stack_lvl+0x7c/0xa0
>       print_address_description.constprop.0+0x90/0x310
>       print_report+0x104/0x1f0
>       kasan_report+0xc8/0x110
>       __asan_report_load4_noabort+0x20/0x30
>       tick_program_event+0x130/0x150
>       ......snip...
>      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> - Add jump_label_init() calling before kasan_init() in setup_arch() in th=
ese
>   architectures: xtensa, arm. Because they currenly rely on
>   jump_label_init() in main() which is a little late. Then the early stat=
ic
>   key kasan_flag_enabled in kasan_init() won't work.
>
> - In UML architecture, change to enable kasan_flag_enabled in arch_mm_pre=
init()
>   because kasan_init() is enabled before main(), there's no chance to ope=
rate
>   on static key in kasan_init().
>
> Baoquan He (12):
>   mm/kasan: add conditional checks in functions to return directly if
>     kasan is disabled
>   mm/kasan: move kasan=3D code to common place
>   mm/kasan/sw_tags: don't initialize kasan if it's disabled
>   arch/arm: don't initialize kasan if it's disabled
>   arch/arm64: don't initialize kasan if it's disabled
>   arch/loongarch: don't initialize kasan if it's disabled
>   arch/powerpc: don't initialize kasan if it's disabled
>   arch/riscv: don't initialize kasan if it's disabled
>   arch/x86: don't initialize kasan if it's disabled
>   arch/xtensa: don't initialize kasan if it's disabled
>   arch/um: don't initialize kasan if it's disabled
>   mm/kasan: make kasan=3Don|off take effect for all three modes
>
>  arch/arm/kernel/setup.c                |  6 ++++++
>  arch/arm/mm/kasan_init.c               |  2 ++
>  arch/arm64/mm/kasan_init.c             |  6 ++++++
>  arch/loongarch/mm/kasan_init.c         |  2 ++
>  arch/powerpc/mm/kasan/init_32.c        |  5 ++++-
>  arch/powerpc/mm/kasan/init_book3e_64.c |  3 +++
>  arch/powerpc/mm/kasan/init_book3s_64.c |  3 +++
>  arch/riscv/mm/kasan_init.c             |  3 +++
>  arch/um/kernel/mem.c                   |  5 ++++-
>  arch/x86/mm/kasan_init_64.c            |  3 +++
>  arch/xtensa/kernel/setup.c             |  1 +
>  arch/xtensa/mm/kasan_init.c            |  3 +++
>  include/linux/kasan-enabled.h          |  6 ++++--
>  mm/kasan/common.c                      | 20 ++++++++++++++++--
>  mm/kasan/generic.c                     | 17 ++++++++++++++--
>  mm/kasan/hw_tags.c                     | 28 ++------------------------
>  mm/kasan/init.c                        |  6 ++++++
>  mm/kasan/quarantine.c                  |  3 +++
>  mm/kasan/report.c                      |  4 +++-
>  mm/kasan/shadow.c                      | 11 +++++++++-
>  mm/kasan/sw_tags.c                     |  6 ++++++
>  21 files changed, 107 insertions(+), 36 deletions(-)

One part that's still missing is a Documentation change.


>
> --
> 2.41.0
>

