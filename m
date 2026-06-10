Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37EECD98CE
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 18:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72EB6B0005; Wed, 10 Jun 2026 14:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49EB6B0088; Wed, 10 Jun 2026 14:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39CD6B008C; Wed, 10 Jun 2026 14:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B20A56B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:39:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 480C91C21D7
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:39:35 +0000 (UTC)
X-FDA: 84864866310.17.ED362C2
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2FF9B1C0010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:39:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GPmcdXu3;
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781116773;
	b=5pOhKXAmkbPk+GzSLg3ia7IznEiASZ6IzKZXd8n6g2NH35TfR+HJ3ihMWOi9YD8C4O2MGD
	4yqmI1YQsT0k6jJBqU/M3ju1k73wrSG5J/yPHHrOkNKdyEbHcxbi8WC5AC2N4oAAABAjwL
	Psrbk3X35ARMC7i2QeYPUwssHqC9RJY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GPmcdXu3;
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781116773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAI5rGE1lcochlZ5iYlpDGay/XmnlZU+2TzD3/+oOuo=;
	b=cPLegBSyLjckzwJuNOLDHI1ioh+CW9ha/F/u2To8unNfBDadzNUA4XYVM9FOJp/Udx4CyV
	a4djVcanzrTmx9aqDLLzNrC91WXSdvpyMjtejlZawAHICo2wKpg+PXCWYINNbYOaqCo97b
	kWcOkvpCryk1gMyremAI/0V/jx0EaO4=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4905529b933so76270495e9.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:39:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781116772; cv=none;
        d=google.com; s=arc-20240605;
        b=eWb8nGC7Ako186BU+nscdp9yeZil6U5F7xY7/NaNyWZBDk+laUfdy6w0rxmitaj4gV
         die78ly+ltppqfkevzJFMqsaFaNdXB913zgLiowBLoYhBExRCpdz1GQgWLTqFzl9oTf5
         vpqLN9NE/lIbhFzOi1E4nSG+SnU+5nQujjkmUjZZIEdml40LoV0+Q5lkhv7DstSp26f4
         yaMonQQoQZMpwrCGUOOcrkifI2J3ocZuBn2/laflXW4nZh04KMes5NQkEzEDc+ryiJzh
         okqX5Cuh5eTLttaJ3TPoXxf8euLzW7dNfD7sFjsLUXGS+FEGoTLoBM9KkiwYkMRZ7yc/
         hRgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QAI5rGE1lcochlZ5iYlpDGay/XmnlZU+2TzD3/+oOuo=;
        fh=5escOOZtvpyeK9ietshRV1Q1W2n3qNiqyKFTmJ+aLsI=;
        b=jRE/EChPd4nMk74f49barW2KJojh9TjUU7IRyA4x8vPuKmi6OIQuhn0YPAkE7UIiYY
         7FKAonXreyipQYA8ovi7cXtvp9K8nn7o9Em1RQWQwHkXnwxfc/wmxqkOoJxyLIiwgZRD
         iOux2AICxLNdg71Ti1vM0LXuRdx73pd7j1u8IClLipoUlErzcDalSI0wpWT9WKFj2s5o
         GqvG4w7xxEAynGLYfa+ueGA3nijG7MwQRj9QyMkVMaPquT0vEJkFhYgfzk026ylYxMwS
         3k1ywzi/tCXdqdX9fOmZofwgFjOeoSCBnoxkFJUfcIT4OmfOpSyln6li/aEmVggbju1W
         n6HQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781116772; x=1781721572; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAI5rGE1lcochlZ5iYlpDGay/XmnlZU+2TzD3/+oOuo=;
        b=GPmcdXu3vP+u/S87CPut/D+1iVBlia07ZTCvhd/UYXSgk9ugNFUy4gL5V/+ZshexVP
         7ojRc8+iUFiNaLMrqs7HVRGPCe9evx2+XjFczl5tQ5C75qBqMZVRleObcepT0GDoUm4q
         pqU7Gvz7Rxwl7mJncbGccsDV+2rUxdDBguWoW8Oapj/SFqA3p+P6fhm3EfBYz+Jo4DhM
         ScWmV8FTULi3TMREja9pAComiYLQ1MKkiPrXtzgz2XW4nc5tnyhMtFpme92H5HG5dWe7
         1OgtG+yEsB1fgEzGOq2FSjaUS9monl86kjLTNQoCgIiTpTYZgupEcsABlt2KM7LHO7fU
         PBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781116772; x=1781721572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QAI5rGE1lcochlZ5iYlpDGay/XmnlZU+2TzD3/+oOuo=;
        b=EwYqlmgY0MXxU680zjksjwEF8bSg/lvVegGO7StfMguTzugjU1OCNMkJko3W8w6I0n
         0nBs6HHGS5OF4N9AuXRqh2jDBZG4zvpndBnDadu7gFZozZVyFUcay+6VQ/8wYa4KVZLy
         vcXv+HDSfof5SWeUYOrmwLt/ggg+A29rQJA9+ghmzo91/BsccFUzh1scG+vSrbWTdpYX
         2ryNQskxmxqbJ2dZb4qZm9A+cqkQLhhbrUk1KpyG3Fd/DHJ2hCgcvcHctfn9f/CMqZ+l
         q+lunNRlQbIIcJlQ/4Kw/BVB29TJYn/TAul6854IT7tS0p8h4vzSCTucb66SrBX8qc5d
         7NeA==
X-Forwarded-Encrypted: i=1; AFNElJ/mnU4nyFHN6dt/HvxulTizY6/T95hhJAotv1JbMykxLW/UKqRvFjVS61I3sj/mvbj5NpK9Mrg3iQ==@kvack.org
X-Gm-Message-State: AOJu0YwWCpj9/sBKXY0GI364fPkKMgCAR3JLpTx3gAIiY6hL6puElXam
	MTDLuB1G91lCDzr1n8o/3oFSCgMAU3a+MhJV3l+v8Pmyb8zkMrCLhgmgOp67+93cr4+Gf9N3j7c
	X65m39fmjDvq0bzarfFn2Q9n61GmdAOM=
X-Gm-Gg: Acq92OESC5Z9H55aX0DiMdFiAbzLsgGyKCDrlSYITMhUzXJxeDIfCtbCaaFSo46Y2AE
	mJFu1/JScahnQ8lm7ClgAcPaOC8IW334C+jOY0vhKravG78PS4F7IjcO5OoK0VDmC4Ot+COSy4B
	pzYq0oqX/sWPTBaE8TIFRoeRcfsQ7SZOJN4VYgo9AqOr52iliu7TVKKwTsIJmTkbK4Ovqs6MP55
	F2gZ+G1QCkkuSzsG74ieKetGkEc74NBNM7yU+9D5GHHGcMyB11bDstmxIPETuQF7LeZdtixMvWJ
	JhbQmmWke7jcujUfZksClsaOyqCcwYhziNaIvEOdWv0+rkiU9Qe9
X-Received: by 2002:a05:600c:c059:10b0:488:b187:3c with SMTP id
 5b1f17b1804b1-490c265b439mr323245315e9.14.1781116771269; Wed, 10 Jun 2026
 11:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
In-Reply-To: <20260610175651.647515-1-ihor.solodrai@linux.dev>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 10 Jun 2026 20:39:19 +0200
X-Gm-Features: AVVi8CcOmKKzzKpfqJi3RQYIzBaDejV9oYlpv_30ztPULZsRV2up2gs-F5uqBVw
Message-ID: <CA+fCnZcRLZS4r=FBB6EX-G3+=X675q96hkdR_wLJexeuW-tPVw@mail.gmail.com>
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FF9B1C0010
X-Rspam-User: 
X-Stat-Signature: m7fq55gsq3ttn46srgkkqui3u7jio4gc
X-HE-Tag: 1781116772-921129
X-HE-Meta: U2FsdGVkX1+M9iBK8w/xMnh3eKTCfqC46e3kDZnmSsyhvyCJ7TDqawOUx3fvjjK9VGK+t7apWA9VDHPN08SlIn5vO64IZOfoMWN5da+dWW/C/3osL2+2hsoRrjQSmWOyIfy+K5j8BMetghwtcwkrei6uASV1aGRDeCelC/4c4bwSeEVLDqHThHM4pwHW0V+rA4DB4VX8QoLoATRs8p+vIOD2yyR1hdauMF0f+bC6Yv91ZD7k2YC9OZ7DqV28/y7n7XB6D90ZoGHvvdqvqq83tmkI1xmvbbLni/AgaDEnLSuvXmxwrMIcTvgujEhGyt5zS6e1cAKCgjXlB6s6v0Xkru4eBpKcKcywQmGXNLYoZ8c3EOKHIaSxhYy/lfPVniw8XnLpG75HcLCzWZ8aA3fw9pqlGsInDDJ1gkc9hYqkywOC7piaYvp+BtLMRawEc/uCUBcMWymLkXN1AcSWrZNaBPrc5sLVZMTgnfCX1eVxvhwA3JAyZh1CG02rDg60ZyDsWeYMGD25OAd5tsCUUMNExDqAmggLlcqVSe33TZ2wjyYVa5Nss5bPnnkZT0andacAa1QUVYKZwcgYNpZ0jY/qUzzY3z9ZEeAIvlJxoU0we1+O4aldcapoZVSjld+GSodsn/Urj1B98tDgRyvHNkHSl25DvxQtqTJ0JDl3m6f19M9WEhoIb2VjYJ5lUOjfxIdfyZjMIyCP5T2rizlghTNlj3zlo253EvZTnAD8JDRgIoW3czQugXfLEN35elJTVGN6CfEInW3s3d5fG+GxDZ6MXyd237nM7L1lSSlvw9U60giUe980NwgDaRB0UbA3neQJn63fiIMjDyl7F36LgiEv5ShPMbxSgrPVVLghXOBLVq2TJtL9RE6O8zeztRn5SuNDMgnSKyssvZcWHncJN2NjgqBXt8E87/b1LZWbiFDtgc6y+m1I4NVMNAhy35fOVlkVehKsdy6z85a6o8WgCsu
 m91RIDqh
 fOH5C0fZRQd7Sfw3u3KzCsWE0ffI23ufHGpeI1jdcCDy4Hu8VF6I7sPPZtEHOqxaQahTbXA5e5jfAvlqbIYnj/6AVq4G5X+MHvTo0YqMDoWDaWoOg2GIVP78KKB40V9CtvapGEK+dOSZx0AjMTkidbiIApEpGjv/oc7/HtoL8j/L7sTHVkF6dKFvoapNgAeusXRvuaNRSq9YErdWHp8SnoHvHsmXfkfL+BfYf/pFD7zl4egJIiCvcRRI1xAj6DnRofcukB9K+Ly4Gn2a+KBDtds301FMB/BnXjVf9V+sQtJr+awoZB6IYpUlWiDNUHzt9jPuVudYfQXicrrQLVNnvevpqWT1WTN+/XG0C59QiOcAYgNfHcmLKCMCXweaBYkz638Br/8jHEAAhLWMXZCOrWAfAcbmrHExB5eRLU9lSmXqShMUBUkHHGPYZEFbFG/qHcHNvbJJ2d8FtcU0ItQw6KdqxVWdOoKGsHIzt+pehjnk0D/DxVatRwQu5gPIlmk60IxD3h8i7Un4A+iYOZdqUTbWLSERqF/een9owQLzOCVvIIyq/uKtMJpSJVj92JobVOUmxO+W4hqlSHrpWWuOi7dK1kEXmJmXtHJMTmrcMdJ+gcNmskhxO3OqNeMAX38XDuuTcr/pLCyPYZrlW1+8/RiseRxceLWdPwmDKJDFy7P1djzbWRJokOk37Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 7:57=E2=80=AFPM Ihor Solodrai <ihor.solodrai@linux.=
dev> wrote:
>
> On x86_64 with 5-level paging (LA57) and inline generic KASAN, the
> following flaky splat may be observed on boot:
>
>     BUG: KASAN: wild-memory-access in do_raw_spin_lock+0xcf/0x260
>     Write of size 4 at addr ff110001000c90b8 by task swapper/0/0
>
>     CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.1.0-rc5-gcba33e0b2=
907 #1 PREEMPT(full)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,=
 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <IRQ>
>      dump_stack_lvl+0x54/0x70
>      kasan_report+0x117/0x150
>      ? do_raw_spin_lock+0xcf/0x260
>      kasan_check_range+0x264/0x2c0
>      do_raw_spin_lock+0xcf/0x260
>      handle_edge_irq+0x35/0x770
>      ? do_raw_spin_unlock+0x51/0x2a0
>      __common_interrupt+0xae/0x120
>      common_interrupt+0x7c/0x90
>      </IRQ>
>      <TASK>
>      asm_common_interrupt+0x26/0x40
>     RIP: 0010:identify_cpu+0x2b2/0x3460
>     Code: 00 41 c7 07 00 00 00 00 4d 89 e6 49 c1 ee 03 43 0f b6 04 06 84 =
c0 0f 85 a3 1c 00 00 41 c7 04 24 00 00 00 00 31 c0 31 c9 0f a2 <89> c7 42 0=
f b6 44 05 00 84 c0 0f 85 ad 1c 00 00 41 89 3f 48 8b 44
>     RSP: 0000:ffffffff97807df0 EFLAGS: 00000246
>     RAX: 0000000000000020 RBX: 00000000756e6547 RCX: 000000006c65746e
>     RDX: 0000000049656e69 RSI: 0000000000000000 RDI: ffffffff98632fd8
>     RBP: 1ffffffff30c65fc R08: dffffc0000000000 R09: 0000000000000004
>     R10: ffffffff98632fc4 R11: fffffbfff30c65fb R12: ffffffff98633050
>     R13: ffffffff98633048 R14: 1ffffffff30c660a R15: ffffffff98632fe0
>      identify_boot_cpu+0xd/0xd0
>      arch_cpu_finalize_init+0x24/0x1f0
>      start_kernel+0x31e/0x3e0
>      x86_64_start_reservations+0x24/0x30
>      x86_64_start_kernel+0x13a/0x140
>      common_startup_64+0x12c/0x137
>      </TASK>
>
> It fires very early in boot. If kasan_multi_shot is set, the reports
> are non-fatal and keep repeating, and the boot CPU wedges before
> userspace is reached. The accessed addresses are valid 5-level kernel
> pointers, so the report is a false positive.
>
> The root cause is in generic KASAN not seeing
> cpu_feature_enabled(X86_FEATURE_LA57) set, because the bit is cleared
> in identify_cpu() when the offending interrupt happens [1]:
>
>   memset(&c->x86_capability, 0, ...);   /* clears X86_FEATURE_LA57 */
>   ...
>   get_cpu_cap(c);                       /* re-reads CPUID, restores it */
>
> addr_has_metadata() then uses the 4-level threshold, and 5-level
> kernel addresses fall below it, so kasan_check_range() reports them as
> wild-memory-access.
>
> Define USE_EARLY_PGTABLE_L5 in mm/kasan/generic.c so
> addr_has_metadata() uses the stable variable, as
> arch/x86/mm/kasan_init_64.c already does.

It took me some digging to find which stable variable you refer to
here; I think this needs to be better explained.

>
> Some context on how this was noticed and reproduced below.
>
> We started seeing flaky splats as above [2][3] on BPF CI runs after
> runner hardware has been upgraded. Specifically, new x86 runners are
> c7i.metal-24xl AWS EC2 instances, which are Intel Sapphire Rapids
> machines that support LA57 feature, and have it enabled.
>
> The splats can be reproduced with qemu on any x86_64 host with
>   -cpu max -accel tcg
>
> Build a kernel with:
>   CONFIG_KASAN=3Dy
>   CONFIG_KASAN_GENERIC=3Dy
>   CONFIG_KASAN_INLINE=3Dy
>
> Boot it with kasan_multi_shot. The fault fires fast before userspace,
> so no rootfs is required. For example:
>
>   qemu-system-x86_64 -display none -serial stdio -no-reboot \
>     -smp 4 -m 5G -cpu max -accel tcg \
>     -kernel arch/x86/boot/bzImage \
>     -append "console=3DttyS0,115200 earlyprintk=3Dserial,0,115200 panic=
=3D-1 kasan_multi_shot nokaslr"
>
> It's a timing race, so a single boot hits it only sometimes.
> However running several qemu instances in parallel on the same host
> significantly increases the hitrate.
>
> I confirmed the proposed fix eliminates the splats.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/arch/x86/kernel/cpu/common.c?h=3Dv7.1-rc7#n2001
> [2] https://github.com/kernel-patches/bpf/actions/runs/27271262414/job/80=
542509369
> [3] https://github.com/kernel-patches/bpf/actions/runs/27260143782/job/80=
505353689
>
> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
> ---
>  mm/kasan/generic.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 2b8e73f5f6a7..b5f430f2dbb6 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -9,6 +9,13 @@
>   *        Andrey Konovalov <andreyknvl@gmail.com>
>   */
>
> +/*
> + * check_region_inline() and addr_has_metadata() can run very early.
> + * For example, in an interrupt taken while identify_cpu() has the CPU
> + * capability bits temporarily cleared.
> + */
> +#define USE_EARLY_PGTABLE_L5

There are other users of addr_has_metadata(), besides ones in generic.c.

Thus, should we place this definition into mm/kasan/kasan.h? And
likely guard it with ifdef KASAN_GENERIC || KASAN_SW_TAGS (HW_TAGS
should not be affected by this AFAIU).

And let's also extend the comment to explain better what's going on. I
like the way the issue is explained here:

https://elixir.bootlin.com/linux/v7.0.12/source/arch/x86/boot/startup/sme.c=
#L36

> +
>  #include <linux/export.h>
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
> --
> 2.54.0
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/20260610175651.647515-1-ihor.solodrai%40linux.dev.

