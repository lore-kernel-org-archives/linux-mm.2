Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875A7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775146B00A8; Wed,  1 Jul 2026 10:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726646B00B6; Wed,  1 Jul 2026 10:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615826B00B7; Wed,  1 Jul 2026 10:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0DD6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:45:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 954C78DA25
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:45:48 +0000 (UTC)
X-FDA: 84940481976.25.3955D94
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id A9C984000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:45:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JwW398S0;
	spf=pass (imf11.hostedemail.com: domain of voytikd@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=voytikd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782917146;
	b=aJ3gtJEdl8oZJpp3en2HKhX1DIF+IzECZFyFJDqZrIy3i7urUUSc3EbUqSPpAs2rKHUROY
	TdnDOJ/SGcRW94M1QEjUodymD9t+ehJf+szQJ+pSCC3zzkBPE7IRjz/TSsUNlsblMq1wtK
	bkB4BG5/zTEm6yqOEBgqxhsfUEhMbo0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4VxbfrJ8p894B+QfqkDR2gI77xQ9xtwNKhqCLX8M/Y=;
	b=KBkS2jTO1W9YOHsJfkUta8QAx/F7V5HjuS62lfhS0jlkiUmpBXj6LU3/SDzJbAFF6d0VsA
	i7Tm3EGAKnUCsFF3Nccxz2rdVihBXU0zJWLn0TqbCcKZnLdJahtTzYnr+T2U4c+cEDuvZ1
	t3dk36l+9l4suljPj9zv8qxiD4ZaTI8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JwW398S0;
	spf=pass (imf11.hostedemail.com: domain of voytikd@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=voytikd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-697564cb69eso1799224a12.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 07:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782917145; cv=none;
        d=google.com; s=arc-20260327;
        b=l5WycZEXz2BI/nusb5owDT4ToQ5FsQzRksaDjQvsewTJhRXwE3TImdrjVraLvbxJs9
         PPKMdN9nHpVFjW/zckcTVpvG2zcYUkUbOSidiasXMJPthuanxYl0OkERF5sx84z/1L5x
         2NtctwPcl4lBSNBeGb7klrqEnE9OJvxVZ3XWqQZOfIdpmLvPJE626PEhgePQYCgPtD9J
         A8oCqZcIHzEqtwTkrZyOP9BFNchNOzsVekQiLeQTSoGcbxcQ/hKUH8HhvGm0sIhNofHI
         EaAb85P43Uo9MZupcIB1eptSmq2F/qRVqfrUMZYMGpGLWyU5g8+V+86c1CWKw483bdoh
         /Brg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e4VxbfrJ8p894B+QfqkDR2gI77xQ9xtwNKhqCLX8M/Y=;
        fh=ffbl+jlktzkCV2iPAxZavpJjJa3vP1i6cWh/zRfVuhg=;
        b=SRkXCgnPrQXvPEHd+e/9Xbn3BNIIQkFbV0tDFaYuB+nphGwAnW6McvHSqlteH56rSO
         sGoAXv57LftAdA2pASwRpeJGB7CT+UQfqDodL38xbwvL5RTQHdiSJAAG8NIQylFiC15A
         nj+SjbzDcYPk0+ShAE2w5RFWzNX6V2BWha8+FWeW6cbWwTpxpUJvXS/cMDIRDZVByhE8
         3LMBpBUx40Fkpu7FdzPo13fsy9GxLL+qj/xt3ebGgcSOXNWsiA/Byt9Yufj+p8W4fmN6
         nYMKEHxwZeURIHKKhevwQV2Gq9ACiPMV4az2Mddf93jBsaEYiitwT9E6BPSUNM4YXJbH
         wyWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782917145; x=1783521945; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4VxbfrJ8p894B+QfqkDR2gI77xQ9xtwNKhqCLX8M/Y=;
        b=JwW398S0vdxMhmsVazfLpBWaUa+nSqIx1NKx/hXpHazUHVlF+PJdsgVqZuGKUzPFQb
         wWXUGn0RoPVvGI2w3NmYs8ngDaGOa38Q4Nr0FWdlZ+oVM1qmEIvkGXWAVgW5E6T63lVg
         b0OIoIH4tFEili3ARXpJWuzjT+IhFNps5dMRowl86WfYQRAgeRbs9KvRFOZ7VEfuvH0k
         bZ0QQ9rYJLK5ov0IFgkG8AGZEy+PE4wGCqZC3j3JEeZNhEoWTmboZKo1B+E8tnSahrnT
         aecHWHBP202zr3zAUHGXkJaM83oT3YgZ6Fgz7JDHjq4wKYpyV8UvsHgdu6RIEtP3BI+y
         nbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782917145; x=1783521945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e4VxbfrJ8p894B+QfqkDR2gI77xQ9xtwNKhqCLX8M/Y=;
        b=K0ZnVNafPmWn9NXP7j6Bof3LFZ78GvwlGOUQZoHgzBKlN79WpnWGsuUosgSKCulmCR
         OMX1YpM5UNwWesQVEn0MccZEGxKiUmIDGwg/1JfoYZnYs43hdD/O0BpX+zAg1wk4kWnF
         vs+IcNoAJBR4K7ZkB008VChDNSRc5X19j9xg8UiNh16rfduOWV9QtUKk9GR6Kia2WT5G
         aNkwJvclxQAkGFl+3mXpXgaBJkcxi318+EutnmpVL32pzvQxeJ+vg4lWAvBECXGKevGq
         f+0NKjjBZAocje7RXsGzAeJXqrxYpsuyNRo3jVVknnkjDUdY344H/PzW9NZewjp3wPit
         U8SQ==
X-Forwarded-Encrypted: i=1; AHgh+RpKtV6DsgRToWYI3Os14vLm+nWku3QM5qSb0ZcS49Pw7aOItO2NNxw7gG4q2xtMJAecjiDqDtdyWQ==@kvack.org
X-Gm-Message-State: AOJu0YwWGPSmRZP0+8FPKFbKtxA+rfZ/Eq5GLDCRsjSXW7huXIBabHee
	Rbw9tmWBgKGab7fheKMmolmDOKcqEIMKQSL8VOoo6u20IGjBKeqpvPbqMLOAtr0GKcp31TYuo3o
	EeAI2QnnitsQFrq0HIdsEzQcVfhojfhg=
X-Gm-Gg: AfdE7clF0ZQvE18BBFJbHgVw69S/EFkw/AjSpz8jHb18BBto6cY7R/gAuzUGeUkoNGr
	ApQT4+d35zcS2c2LEgOpx+0hcN4ErdmMWsGd9v9gvXKGlslDigOfho8C6I9QF3M0ItvFsg3S3GC
	V6VtVGRGSW3gE8qgzKtyLHB44w3r4XMAks6vp2urgmIWJ3WBo+1X1mEhK9GwP8mYHG1I7gLy7se
	Sv0yKcMvrnK52A8tovODKVDVrFxrdGp6MKbfhZf3yb38dptdBCHZVFWMMwYZlF2FlMapcWkhWnN
	J1UyytFcNqfMRdYRpnl2L7cMIlk34e2X3MZS2B18DVG1JVOJ1xLleeJZmKbrCSBX/ZXzBkMNPfl
	QTed6PzKydQ==
X-Received: by 2002:a17:906:209c:b0:bd5:7c2:7622 with SMTP id
 a640c23a62f3a-c12ae84ed2emr37794766b.49.1782917144825; Wed, 01 Jul 2026
 07:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260701125151.352632-1-voytikd@gmail.com> <CAG_fn=Wor0586c077D+0D+NYh+bkhqPhVVzoAANsaLGxbjLpTQ@mail.gmail.com>
In-Reply-To: <CAG_fn=Wor0586c077D+0D+NYh+bkhqPhVVzoAANsaLGxbjLpTQ@mail.gmail.com>
From: Dmitry Voytik <voytikd@gmail.com>
Date: Wed, 1 Jul 2026 16:45:18 +0200
X-Gm-Features: AVVi8Cc5uxeIqIiWFOkSKOfAxIKeqvxsA19JWQ6Lc_aOQEpsu8EAzjAqokjWnsY
Message-ID: <CAAX90H31D3y-q1RJ=ah+hhPj2_apUh-rGtmwwp8vBzDNZcLH5A@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
To: Alexander Potapenko <glider@google.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9C984000D
X-Stat-Signature: 6qf5fraagzsohbg5soj73yy68t9rhx17
X-HE-Tag: 1782917146-104319
X-HE-Meta: U2FsdGVkX18PMoDHNrLAsNCzB3Dcgvfno3uA0hUuDwkox/Ai2UIxi4b7CHMLMqmtOMpkZSooYsThkSxpHiBcvfXM8EMixpuGNL8x9zs2i7co6q2Kw7nMjE8RyOTMrhwrPNcmgtN8A65DirS6xHRmD8ioANPD6dY0yXFE1ErT+Kmf4YrNVEg5xNrJRvbTU1tEvswJMHptlxOxZ8RYnrJnQGaDN5dkzBzgxLL2c49MDlpa62WzNi/gtYX4smuNrgbD/wksGrDIgHKrEpXpISVblJ0Enbr4ya4zlJ8QPlzIYR0yT/nh9bd42JxkzswYX5IwvpKTLJgZs8Mx5DQ6m10eNJCx8E8EQQZvF4duQ4O6lCU3umiJJLHm1Fhc0R98G8gMXC8coAr9/kjdccjG67p8r9hWGuMVxScCNQrf02RqxE2wa11t13kHRJLhRD0SUeWrb05Z6gQRlpKNMY/IXlNRpCwqv0tE5eLOFmB2NeFLgh1AwjlNXGSZLr45p2J/xKLVYzzPtf7m7hWrcAY7+xMM0lKzsds/Oh+3hglf+9gK0GK4alMDSKG44U+gUuANwIpLkQGpoPg9zgww9vKZofBDuoa9k24B2QuhZWu7O7YVsfvHAXSprJuVIiHfS3gyGExyptkB+ToELilMrBVzCDaQpUHeJbJFgELQnW4a3FbVT9KCNyZciGvjaRMvUneoM2pcpFkFsmQnq5hdY9IsYgP+JaDM08JZ7Qh3FMrQKWmEgJxR88FuATY70H4WOjrYb8wgzjb56ic8AiIuWHzgH7Q8TWN/fuGTWXFdU9WPfgiTiVlvBQTzr1vUNaGie0jXxJHEfgFlo2qNxx1BMJyoqRDT5KLsgkRmVupN7p/AvdYw4EXtAabH1/n2/GUn7/pKRQCmUn8leJH61V/7UHjwIyEL+C7+fCpkoITMMT5KrzfeyBFMJRcjD6drIRI6nWhtaSUbA3rgmO4M5w8UuiBVxDA
 Nqy0fmQC
 D3tkfEOkDpppZy3XphpdEdMPXd/VZhYBjW5qEWcPnH0IEXOFRdAuWso3b5UmGrv+pRHr/fNGoOi9i3jHLO7YwbXgLX800JbyaG6TKqZB7XXPT4z29SA+sR0UPOvHBqfrtkBan0DV4OfxV5LyOC/BK9S7MLWiwp1IK0KZnOhyptWkCKKpCU7JoHy6ovoVuM8wQ+UJrR2UaQFwdKDIss6dcD97XBez+FQPukEBrOMaSRdjWnDxEY1+7WZdZDkQe6/n1XhDiH4uCuBs2kT4CbhfnemMLfIHCJXwMdO0uwuN3kRak1cZZG7y5NL/sAtr6JrlBg3NcyEgnA5Wv0+MnfYp6PA6bOEcrg281+CSLlXvdsNaft++Fs4FSQys2+KCByPwrHMTnm+w1Aa0GRbhR7yokHBznmk7WY5qzbISqZu8ph5+SFHR1d6dvFq5kX0VfKWaxbEIqd9mcYZfMQ5ljVv5M0uqbCVhh6OUgyvBxzgAegEB/kYHNNS9VqmrksDOOeTJuPHL1hlfXLCLz7MHJhE4SDl7rk7bSR4yZqgUe3xKVQMeiPFjCN+iVl1C0a/wIHp+z9HMvzd1TSkxr3yl5/aoNKLMDoOH5emuMU9wBcKfzNGGKaM6WzBTdusl2NomHa4jCAYLJYVOCnDvd73U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

On Wed, Jul 1, 2026 at 3:18=E2=80=AFPM Alexander Potapenko <glider@google.c=
om> wrote:
>
> On Wed, Jul 1, 2026 at 2:51=E2=80=AFPM Dmitry Voytik <voytikd@gmail.com> =
wrote:
> >
> > This patch fixes broken builds with defconfig + CONFIG_KMSAN +
> > CONFIG_DEBUG_INFO_*.
> >
> > To reproduce the issue before the fix:
> >   make mrproper
> >   make LLVM=3D1 defconfig
> >   ./scripts/config -e CONFIG_KMSAN \
> >     -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
> >   make LLVM=3D1 olddefconfig
> >   make LLVM=3D1 -j(nproc) vmlinux
> >   ...
> >     LD      vmlinux.o
> >   vmlinux.o: warning: objtool: folio_zero_user+0x801: undefined stack s=
tate
> >   vmlinux.o: error: objtool: folio_zero_user+0x801: unknown CFA base re=
g -1
> >   make[2]: *** [scripts/Makefile.vmlinux_o:76: vmlinux.o] Error 255
> >
> > objtool in verbose mode shows how the frame pointer is omitted:
> >   make LLVM=3D1 OBJTOOL_VERBOSE=3D1 -j(nproc) vmlinux
> >   ...
> >   b15a2c:  folio_zero_user+0x7fc      xor    %eax,%eax
> >   b15a2e:  folio_zero_user+0x7fe      mov    %rcx,%rsp
> >   b15a31:  folio_zero_user+0x801      mov    %r14,%rdi
> >   b15a34:  folio_zero_user+0x804      mov    %rbx,%rcx
> >   b15a37:  folio_zero_user+0x807      call   0xb15a3c <__clear_pages_un=
rol
> >
> > After the fix, the frame pointer is back:
> >   b15a37: 31 c0                       xor    %eax,%eax
> >   b15a39: 48 89 ec                    mov    %rbp,%rsp
> >   b15a3c: 4c 89 f7                    mov    %r14,%rdi
> >   b15a3f: 48 89 d9                    mov    %rbx,%rcx
> >   b15a42: e8 00 00 00 00              call   b15a47 <folio_zero_user+0x=
817>
> >
> > It seems the issue was introduced by
> > commit 54a6b89a3db2 ("x86/mm: simplify clear_page_*")
> >
> > The actual fix is to revert the change how ASM_CALL_CONSTRAINT is
> > positioned.
> > Additionally, reintroduce asm_inline to prevent potential compiler
> > rejection of inlining.
> >
> > Link: https://lore.kernel.org/CAAX90H2_RPnZL_dFYN7cQF6yt-wAweKKSx2=3D6e=
2aZ0kv+Pm+NQ@mail.gmail.com
> > Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
> Have you tried running KMSAN with this fix?
>
> I tried running with the config that Thomas posted at
> https://lore.kernel.org/all/87tsqjq3i3.ffs@fw13/
> (https://tglx.de/~tglx/config.fail), and it still hangs for me.

I only tested the fix with defconfig + CONFIG_KMSAN +
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT + olddefconfig.

qemu-system-x86_64 \
    -kernel arch/x86/boot/bzImage \
    -append "console=3DttyS0" \
    -nographic \
    -m 8G -smp 4 \
    -serial file:serial_output.log

Booting from ROM..
[    0.000000] Linux version 7.1.0-14280-g3dd2bc904bda
(voyt@voyt-laptop-dell) (clang version 22.1.6, LLD 22.1.6) #2 SMP
PREEMPT_DYNAMIC Wed Jul  1 16:25:28 CEST 2026
...
[    2.274314] Starting KernelMemorySanitizer
[    2.274356] ATTENTION: KMSAN is a debugging tool! Do not use it on
production machines!
[    2.357699] Dynamic Preempt: lazy
[    2.390793] rcu: Preemptible hierarchical RCU implementation.
[    2.391032] rcu:     RCU event tracing is enabled.
[    2.391256] rcu:     RCU restricting CPUs from NR_CPUS=3D64 to nr_cpu_id=
s=3D4.
...
[   53.009112] /dev/root: Can't open blockdev
[   53.012357] VFS: Cannot open root device "" or unknown-block(0,0): error=
 -6
[   53.013186] Please append a correct "root=3D" boot option; here are
the available partitions:
...

