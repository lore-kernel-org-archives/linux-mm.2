Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F75C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5696B00A3; Wed,  1 Jul 2026 11:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C9C6B00A5; Wed,  1 Jul 2026 11:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C596B00A6; Wed,  1 Jul 2026 11:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBFD6B00A3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:16:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95DC01683AA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:16:20 +0000 (UTC)
X-FDA: 84940558920.18.5F2E2DD
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id A8B5540014
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:16:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Odau8ccw;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of glider@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782918978;
	b=vBG49Wg3dCwe5O7lWQo+PFhPjLsUx63Wne8y2NvFU0XVwOVCsfcpcp0N5gQilNDs70qMuY
	ohsPMgFB6wqVbB7dV7hMxW6avbWPJj46v7GkPHamb6T8kc70Rq8QpgPjyvqG2IEhkFEQwz
	1a/8EmI3brUFqVdeyKm3HJu41a3MMqE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782918978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9Ct1t4oI3eGFO4X7XoqoWi2Q8Pv35qR9dPP8CVLRfQ=;
	b=w1+cBGxbh4k+FdOu8WtcXkEiZ82CyX02hsAUcH66cOG+Jrg+3JvkzRO8unNiF1jKNQBDd1
	t8EuO+3cbVs+3T/EKiC3rUPv5rQpzQuuAsy9ms/9crnRIcw9k9vLc2rKft4vooUq2UeHfS
	3MHlOFO7qDrDMe8w42EvWn8nTAlJI4k=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Odau8ccw;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of glider@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=glider@google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-68bd9fce347so1577624a12.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:16:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782918977; cv=none;
        d=google.com; s=arc-20260327;
        b=bvSQGvDeSSWMSEEAXyMvGQlNbhXlY1E3NuvfWdxzdctIDZzpmjBKdXdoEgKyWhWxqa
         bzjdHCer5TKjjjGszhYGqI9Xqz9PRphJnC+PStOWKguHPyi9rEHiVsdGzy4qYaJJlAEj
         cQ9JlhEBZX3TAq/s4n3JDw1lC81p/hT20zgqV+m4B/K34XSCkTQNHdcGNeRd0OZu11uc
         62Oo/emg29Nw51vfnU5sSC4tLnl998RGCA8V2lCH0GB6gTiE/USaPHZ22P+GeUyUQ9Dw
         9UOcpbaXZKynL9zXxHOjxLoQMhRX9cWwgoywJNKyqnRz58wrwTN2HEkW0hdMr9LqL6yy
         BcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g9Ct1t4oI3eGFO4X7XoqoWi2Q8Pv35qR9dPP8CVLRfQ=;
        fh=e223hhFe+a2UWcAaJ7VmoYOT63J9ZcVfdRNeYU1SyTE=;
        b=DNYACU8WtOtooDI0CgzenT1pNz/VirweVQXsAe39ZQafd81W2ZuKvY7UvYEriu9IiJ
         roirJnYC+dG6PdPF5a2S2kWmRUg2GK56C1fsHbZka2RO2bYIVjhTa1ScEjilFp+1TPIp
         GJNQ1mU7E8vT7bMbvrxaejM/InqD0OoAowLTR5HZfU0mGyMtMVi8XY8B55bqFzVqW4yT
         MtRV9M+6+IFh47dYfpBav45bpBg8iKLDPbatrAVWxSAGAnBTN20XQiLKptQ3ZKcC8dXy
         4RNeN0AAvMYQedxYVnTjf6Cxf8BpV8wq0W/R73W66wwBrz+RLAkXQ4BNdxqNEq5Z2nvx
         qKqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782918977; x=1783523777; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9Ct1t4oI3eGFO4X7XoqoWi2Q8Pv35qR9dPP8CVLRfQ=;
        b=Odau8ccwOa6dJdLC2x6GCI57aG4NDMV9wsLqj+S9c4KVCsv5373FPklWggN9x3dq2v
         qLXvTcQw/z8m+chItxj/GJDwe0eMXe+qyfOI27vhNDvcDHcmp5uvt8C5wVpsfms6qV3d
         Cv2ZGex4WOjU3BeRDdtkv9W+XF8dH0++t2srjZNWLQvauHCDluuvZOY78bLA9Zd4hRYF
         9LwfI7O/NMizB4L+ysTHBy3LVa/M0s32q2mKU8uF/PiIZ1h/g5G0MSS+8+4HO0ndYalT
         F5glAJPZ+Mqq9WAJN/hSsIbQUbu8u3CGj0fcnoV5WoUmlRhDQXJU8xvm0gmCeKcepFC2
         EvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782918977; x=1783523777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g9Ct1t4oI3eGFO4X7XoqoWi2Q8Pv35qR9dPP8CVLRfQ=;
        b=sreNYBi3bdvNyT/hwb82FF3oEKI4rfBTGF0vh5gvISnvmS6iaoiW23VEZzAP0a7igV
         ml4aiIZoUveuoQG3R9jlcvdXOdJTrZPwMYu7HiXbw9/AKdyW92W94GdRK77wrwFNxSc8
         7eKUxUbvNsjXDEY7LvnFh6hxRYsk/tQdny+U7dVMgqS/kzir4s29aPQA49ZvnggWs+Vz
         BIBhdM7yZQeJttsjXRvucQp8oSsamOhURY1gyZuutoF8r9DsXMk67/kArf87SMbAhHNF
         7VlPcRLNJE6CPwMxaUC/uyHcirZPRRVYy11SpKByyOjKzRpg2ZGpGqhbF1uUoTctCc78
         KzBw==
X-Forwarded-Encrypted: i=1; AHgh+Rp3Onqe+8XDqHqFNeKV/IqYpI/50aqARs9k/DZrb3z1ft7o8lvhmoECHozvpZ5vpE8SLcX3ctghyA==@kvack.org
X-Gm-Message-State: AOJu0YzGK066iwW1yq5V6KOuZF0AvTFlRZJGxBtHy+HSfwF3ODFwrSlR
	AAqydm3SXRHcFs4ycRgqU475S/Vr8PQAU8t3gTO2oiq9NCQDIBSZOET+6S1YF8DGK8obuuRV5J1
	9uB1xod0lrZR+jke6UxDJeEaO76a59anSt+Ym9wbG
X-Gm-Gg: AfdE7clVXtMjFMUkEKNRAR1+Z4YGJVqOma07qsKGRbQOoaiMqRUc+0LjT9Cfr1Wz0AH
	qlYJynkOiMeJsLp505X9tVMpot/I3Y5LThfbh/VkPhYjIKeSdAdcSC7Ttjkfb4bGQWqYa0H+9yx
	f8dvTuK8kczvD/1kJhFoV3LR1rSNR6eAEOokc2p0HJxfk0U0JHIxCtpQMYN3gKZVntjC0NpLyD4
	40wynA33rQRs84nl0ZJxNxUDAfdf1dM8tEdb8ARk2DG1temOPP4mtnvv2JoDhu5sc8EvqAZg48v
	wEiYWw/XpNgMaPXqljDPZ8vqjemxJ0OmPmsC
X-Received: by 2002:a05:6402:34d2:b0:698:4699:59d with SMTP id
 4fb4d7f45d1cf-6989f33c106mr1053721a12.17.1782918976573; Wed, 01 Jul 2026
 08:16:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260701125151.352632-1-voytikd@gmail.com> <CAG_fn=Wor0586c077D+0D+NYh+bkhqPhVVzoAANsaLGxbjLpTQ@mail.gmail.com>
 <CAAX90H31D3y-q1RJ=ah+hhPj2_apUh-rGtmwwp8vBzDNZcLH5A@mail.gmail.com>
In-Reply-To: <CAAX90H31D3y-q1RJ=ah+hhPj2_apUh-rGtmwwp8vBzDNZcLH5A@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 1 Jul 2026 17:15:36 +0200
X-Gm-Features: AVVi8CcT-ikLzaLh0i71cpWmg-Xsyf2H8TgZcmrLinyuDA6tKonIkBw_YC0GzxI
Message-ID: <CAG_fn=VA4P2YVNHSHxzeChFg45LhoYLnj4jrLMq+jVGnt__wPQ@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
To: Dmitry Voytik <voytikd@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankur Arora <ankur.a.arora@oracle.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Marco Elver <elver@google.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8B5540014
X-Rspam-User: 
X-Stat-Signature: mkijmngqfc7k5okdxbx59n8apxhtj75m
X-HE-Tag: 1782918978-281817
X-HE-Meta: U2FsdGVkX1+cI6Ld3HshI8Qm84/UyutVqZ48fJWtW5i44U4vdy0PTY+8zvGPSZEFkM4tV7upQmeB40nkdMlt7LmiumopqAz8EI2xQHlLZt6iZlE+HOkbht1siu7ceEMNSZis6irIZxC6HF+M7tPMFzVQoEJ2qfvna4qhqb3jTpJsiF4mKJYVTogC9z1N2qLWhkVmLeGfxmt4Ts8Kg/y2vuCzao8354uD7sif7glL/4lUuwrM8I/f9ODol2EVOayiSIZy8nHMp243/IwfAtv5RvzRRJjKlGJJL9zHH0ahIuI3tKO3I71ilyNZPD/S9fyiMjCgHqbKKj1ty+xFnlutpXabb8vYbBaZImXJZXYjW1UdsrrEWon+CkSYQUk3eXp41aZdoijS08gea1Dk8J/czybHsAwwV8T0ucNqkyqHTT2hCpReKlqIh2TS4C+bfsz8TAZ1e53hihbK9jolEoDhgFx5KKXX08xgZmiOwT95zAA9b4RiualDS7SU1Jp3O8E8hmAdyL4NfIiUOQDBA6GO598sMMsTC9lZM1Qshrue8q+xLEUEZ63bG0GCFkTgriatPXtHFSNP0hT4reqczGOJBUH4Xl/eElzhwW9SIByS9QX9+SakTXs2tJlucyUjQnAWZberqjnzwYlIAlgoiwXIM6THCt5PW9dJ6G5B8KH0Ps5UECd6syw7QKCaQ6KrwkNq59tRjZBYCX8erkBLv6uomXKTK7GpDrLjqar16Wxs5UX9/jLTnLEC3qr5xH9wCn9CjJTMQ3P8eQFDG0krHB6Z1+y0XqsVhPmTVbLZxNF1woKLSr1KB8upYLSMcHNQorsUbyQbM+CYN9PfHYagijjCNPdi6dB7ZZAIb9AiFNzWD8ciijk7rdxB4AlwPEV8IrDfuogzOICsZApxYMg9RURGcJRdhgwjuqqZYG35Olwusa1STkPtNeZMxZU7kcrsWub+i8JK+o+55bvk4GrP1DT
 koKNAX3v
 8G3X1XBSwfmQnM087/pnK9WmH7YMKoKKOIXGbzlxY7jh+BrA8DiExNmSzQaZhPxDRM4b8TH3x0Jn4q9COmHqq5BznQLdxjy/9/kGoL4oaGkYIpDwhGb8WIy/J7ThtWyiJMIIJvsx+Sv9tCp8XOPgvWuGEfXnQ012zy4F3skBNEIHLZbwpSIBS26pfCdzVfSAKI7KRTXmbdGUS3o9Cu2eVMWBExoqWyNqIQDrqqi7oTiFbPFcPxFpaqw+BDjRebxPEjmQbCkYI1Mb0aA0owrJhZ6No1F6s1ugNvX/iUFsa0Dw389oPh6NlHkDOTxOzea0FoWIkchZURJihwUmhS6G6oJgG3QqxjfFncKgjba8A+old5WlGpb9uZsiK+Wj21T0ubvkNe+VUZ95otsiBMg1npEPcvnu7F7JYh0SifTHVClm6EDBK0fOyrsrPmcYu7qLzV6EutDA09aWJHkpmgD3R1i8CcDtrPy0m/3X4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 4:45=E2=80=AFPM Dmitry Voytik <voytikd@gmail.com> wr=
ote:
>
> Hi Alexander,
>
> On Wed, Jul 1, 2026 at 3:18=E2=80=AFPM Alexander Potapenko <glider@google=
.com> wrote:
> >
> > On Wed, Jul 1, 2026 at 2:51=E2=80=AFPM Dmitry Voytik <voytikd@gmail.com=
> wrote:
> > >
> > > This patch fixes broken builds with defconfig + CONFIG_KMSAN +
> > > CONFIG_DEBUG_INFO_*.
> > >
> > > To reproduce the issue before the fix:
> > >   make mrproper
> > >   make LLVM=3D1 defconfig
> > >   ./scripts/config -e CONFIG_KMSAN \
> > >     -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
> > >   make LLVM=3D1 olddefconfig
> > >   make LLVM=3D1 -j(nproc) vmlinux
> > >   ...
> > >     LD      vmlinux.o
> > >   vmlinux.o: warning: objtool: folio_zero_user+0x801: undefined stack=
 state
> > >   vmlinux.o: error: objtool: folio_zero_user+0x801: unknown CFA base =
reg -1
> > >   make[2]: *** [scripts/Makefile.vmlinux_o:76: vmlinux.o] Error 255
> > >
> > > objtool in verbose mode shows how the frame pointer is omitted:
> > >   make LLVM=3D1 OBJTOOL_VERBOSE=3D1 -j(nproc) vmlinux
> > >   ...
> > >   b15a2c:  folio_zero_user+0x7fc      xor    %eax,%eax
> > >   b15a2e:  folio_zero_user+0x7fe      mov    %rcx,%rsp
> > >   b15a31:  folio_zero_user+0x801      mov    %r14,%rdi
> > >   b15a34:  folio_zero_user+0x804      mov    %rbx,%rcx
> > >   b15a37:  folio_zero_user+0x807      call   0xb15a3c <__clear_pages_=
unrol
> > >
> > > After the fix, the frame pointer is back:
> > >   b15a37: 31 c0                       xor    %eax,%eax
> > >   b15a39: 48 89 ec                    mov    %rbp,%rsp
> > >   b15a3c: 4c 89 f7                    mov    %r14,%rdi
> > >   b15a3f: 48 89 d9                    mov    %rbx,%rcx
> > >   b15a42: e8 00 00 00 00              call   b15a47 <folio_zero_user+=
0x817>
> > >
> > > It seems the issue was introduced by
> > > commit 54a6b89a3db2 ("x86/mm: simplify clear_page_*")
> > >
> > > The actual fix is to revert the change how ASM_CALL_CONSTRAINT is
> > > positioned.
> > > Additionally, reintroduce asm_inline to prevent potential compiler
> > > rejection of inlining.
> > >
> > > Link: https://lore.kernel.org/CAAX90H2_RPnZL_dFYN7cQF6yt-wAweKKSx2=3D=
6e2aZ0kv+Pm+NQ@mail.gmail.com
> > > Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
> > Have you tried running KMSAN with this fix?
> >
> > I tried running with the config that Thomas posted at
> > https://lore.kernel.org/all/87tsqjq3i3.ffs@fw13/
> > (https://tglx.de/~tglx/config.fail), and it still hangs for me.
>
> I only tested the fix with defconfig + CONFIG_KMSAN +
> CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT + olddefconfig.
>
> qemu-system-x86_64 \
>     -kernel arch/x86/boot/bzImage \
>     -append "console=3DttyS0" \
>     -nographic \
>     -m 8G -smp 4 \
>     -serial file:serial_output.log
>
> Booting from ROM..
> [    0.000000] Linux version 7.1.0-14280-g3dd2bc904bda
> (voyt@voyt-laptop-dell) (clang version 22.1.6, LLD 22.1.6) #2 SMP
> PREEMPT_DYNAMIC Wed Jul  1 16:25:28 CEST 2026
> ...

In fact I think the hangs are being caused by CONFIG_UNWINDER_ORC=3Dy,
sorry for the noise.

