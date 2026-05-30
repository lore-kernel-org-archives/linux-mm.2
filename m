Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD6FCD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 19:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D0F6B00A2; Sat, 30 May 2026 15:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4268B6B00A4; Sat, 30 May 2026 15:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC146B00A5; Sat, 30 May 2026 15:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1898D6B00A2
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:40:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AB9B1C0111
	for <linux-mm@kvack.org>; Sat, 30 May 2026 19:40:47 +0000 (UTC)
X-FDA: 84825103734.13.E66F5F0
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id A06071A0004
	for <linux-mm@kvack.org>; Sat, 30 May 2026 19:40:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=C+bvRNeq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780170045; a=rsa-sha256;
	cv=pass;
	b=a46tqGH9RGko+q1UeEaVwQzyGiooRUt5LtryANlbw3chESuh0gdVFD/LHaUb6pnBu5EAWi
	IjwQ18AWYG+SnBFLQWSydVw0ys+wBSqwrQ8mxWOOoVxoCdK+OREWAXeElUb1YwYjdoCQu+
	yWVsWxy6/pBmfrObfbPIllWNxRwRfYc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=C+bvRNeq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780170045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhMPXpo5C9bO9KiY6ITYmWYOylh8Rc870xEi824FVCY=;
	b=dqZXpe0OD9okjuzvR5AT1DrOB8p96ZzZWmipM7mtx21Nw0YJR5w3Z0wvh0Y1R3ZcVfaZYP
	f6+lfL+Ykj+jpw+PSkpgLXgSrq0hyX2CQnbXcHC9VFyQ3NM8u9gk+ZEKhhA63O1fAXWdqa
	YhRy9nEiYOAPknHqZQRuWUzFg8zuIsM=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7dee6b76a73so15844187b3.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 12:40:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780170045; cv=none;
        d=google.com; s=arc-20240605;
        b=bo4yvgSvFEZwxMGgDbNhWgBc+R1TwHcE+zshgRyqgKaKwUOd4op+ScAS7/kdPrkDgj
         vPSGVGrhNXA894ssIurAAcOGXJQFZSJSNRfqTONzLe0F1eZPoAHf0Fd1aSFnE+p7Iy0Z
         GIXXT/H9aH5c7u7EMGAAGIyqhUX3Zlb1yhY6mU4lHUSl1TTYBLoUlNF56Y9VRX86uFxh
         nh+UlxbiO/2GDSaknP8ohUGvspfKJz3Om98ei7KH8PG2pyN1fp++1hRq0Yml2WpjtXdT
         3MB4Iu51dTiO0XULih6m7fp0MedAUn1q1/2O7zKmvCKHW3qkRli6FAZq+MDmTqvHza6q
         3gYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZhMPXpo5C9bO9KiY6ITYmWYOylh8Rc870xEi824FVCY=;
        fh=OUfL4yQApVfQZPrpAWwN2SV435gaLOPf6CeWVWJ0+9M=;
        b=BCgLi0UaQkiXOhd2+K6ywhd5FYQs130ZqRZiFSwI/rfXAQVo1I/g6NYt7WqfScCSXx
         z2RXlJxw1WxMbp+3ch4ChavC9126WiFpvZJvrF+HsmNXw7BZgv75XlDQGf2oedtGZG/I
         5a98cuUGWp5sIQbqP1+dKF8WG2eronPFSx9rABUk28PEtC274/JsfZHrqMOLgZ4fRS+L
         YziYVBJWkXeFNtSu05ty1q7HVf/PXwUZuJ3Ooot9hwAX5rCeWt0wzTTy0Kfr7wleaYzN
         dVMj+2F0TL6f+QNUhVUkxKtpUrjPR0hnQwOO0IiOUZi7VUFRjhDvfQhq23K58rYKzmvs
         Uo5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1780170045; x=1780774845; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZhMPXpo5C9bO9KiY6ITYmWYOylh8Rc870xEi824FVCY=;
        b=C+bvRNeqsEnzYl8nrRw8lpdytqhWu0fsFFw0pKm3nsOT1f9PXLf6cSsJmZ23M744MZ
         5KNj5/QW+LSTA+bVV48w523FMgPIusxnIhWcZqqyClIitVeJMIigD1pUxmyU9EBhP+oc
         Sh68zOaqPxT97v2VWncQstxU9WyA41UIX45H7ynQ9HqTaKXQfPTQSN28aSgAKEGmqnom
         7dvvG11UjzzQd7PiJSqJ3LvcQgfFlUcvZvW4o7MfBYsHgLrCyCM7mXy5VF74y4OVCYPH
         TPlDoMYagW50bGWP1s2VBLVaUx8P64fTCtWja2faSzHQEQqU6+aPJ2qWQ0iY0MQ7p3Sg
         RuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780170045; x=1780774845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZhMPXpo5C9bO9KiY6ITYmWYOylh8Rc870xEi824FVCY=;
        b=RHmY6Zgz/mUs1X5s4t7rn00PRTHjDD27nLMIBthAcfFXZQkkgGs6wM3yhLv7O5kxtq
         rn8Ix+c6/kdv7kHkFdrHrr11RbCzcn6WFcLZAZ1mgCl09Zi/dnxmmh1EUdHn71znmPjv
         y3Bp4I6dGRq8rodIZhQki3mvDeU7rwGrJ7oEF3bClf4ozGSyKJk2z3CKnIFbz01ZMBcU
         nTzteyZFBpe2iR/xy3VsWD7FrQV2tqbOhR5cJ4Oe0iXYVYVyq+z9O3DLfjooj72I5bSi
         IhjgjjYefbZE2LTG4a/pn1256uSLLSlwmkW8xRnbFRWTwK4u5B25ZS7Z5Pd51J9K48Mn
         z/jw==
X-Forwarded-Encrypted: i=1; AFNElJ/TA05vi0a8c8bML6kFwFJYbl/kVZSUd0Oxd4PICS+laJYr1KiKnqEpcIVgGfIZQsqErC4us9B88A==@kvack.org
X-Gm-Message-State: AOJu0Yx2OkoeCSF8aJ52759i9WnITPOlxboSj8DtIi1bYDxkoycIPpJQ
	FEjoLQrRLwgZF8GK96cmuvm5pu3zW3wI1MSOcqIjhWI3TsPRrqJ4WYFH9AHFcMejOeNkdamNz8J
	QxxAPGaYBAeHTDungn8JiFhlrX3ex5P8sP8BVEaOk7Q==
X-Gm-Gg: Acq92OFpEZ7nXV1CVDJXpuGIOG0zT+EPlLBrBZ3l9xBDWzLFeKPnNjPXHWeupOU+4Lk
	HUr0n7A6CtaxWFghNOo1w9wGJYm7ScMd9FFb0i2wBRxzzmIJmBlCDOaDD3YyRq1MrdJfwKOYtpQ
	M5WFgFuDmiD1yd88QksFzQlwDkQ0iAACj6krQPkdAmqGHsij26TfNV+uKm0kzfJu5P07Tvq7Jaq
	f1Nn27V3z/H9oQvqk8YrLnOKrlgOwqt53odPd0NOGkJH7vsBi5YHt/189MLZYBwDINoIk7W7Quy
	DDdp+KMRmjISUPa/CSL7p5A2hb4b4UeCqy1WbZNNnhc0LGgZzoo=
X-Received: by 2002:a05:690c:f04:b0:7b2:513b:34d7 with SMTP id
 00721157ae682-7e05c664b30mr45779587b3.29.1780170044578; Sat, 30 May 2026
 12:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
 <20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com> <87jyslndo4.fsf@igel.home>
In-Reply-To: <87jyslndo4.fsf@igel.home>
From: Deepak Gupta <debug@rivosinc.com>
Date: Sat, 30 May 2026 12:40:33 -0700
X-Gm-Features: AVHnY4L_dtmKXZYG4oLZDjuNSTdF7bCgCYfC8yAIbkNUuu6y-j26ASIyCiMoR50
Message-ID: <CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
	kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
	evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
	samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A06071A0004
X-Stat-Signature: bai7eg97qanx4gdt1pcdfhihh5r9yz4a
X-HE-Tag: 1780170045-286194
X-HE-Meta: U2FsdGVkX19Ah66h5dBvaG4XxTjuEAG17ScBjAEEk3AMMGGittDu5eqdXNYThVb33z3XzAKzkRCEUqGCBJxDZ0la4aexMKetNCyZ/urKm5dx598uY6uIty4TnhGe2tI+1axazjxOYIeYB/G8gLXG5DsQxPVYXZWmiCucubd6+zv4sKB1xQ4ZGk9hMSD+uizYKwVSmvXHMTJhwSORLSj4BpkLx3hWJ0vQH2ZQ1j6qy/aP6+TCHgGGddG8xJlfNRyPh/CGnyOhUaKER8wYqk2uBzJjWDVOUYlU/J5/XfEJd8bAIRkM8IKqhLEqY2AqP9/s9YzXfWJUihNjMVc99mpplXTj8b2mkIFKF9IY5Fd/Rvi/EJV3jv1Qri8/EJwvbUPmky2ymjP4eUxwFAru7pfnlzfTkWkL7/mchTMnLruuVAof1vMT/VZNaU7iPljaaYMBioctoQwhImsmtjTjvttLzkdx9Lat0fM5tkf3Jfi62U8EefMXXHT1Q9KkxBaCGD8M+Y7SOAIeylEjoX01Jdg59KKyMwQhy/uWtvzxmUHbJOHKLqGG6a+7BeWqUTpHmeBXVJTl5ELQfb5IadiuONFmg/+kmwCG2iH9xgawE2O6poN+B37ZWAaimzfuv++yd/eSRnxm/NDYo9mrkJWNDi2vLsvxY0tDKIJJxXM4VqSIR6INtzg6BaE/QI4ZDc8vsz+2K3rMTHwDk5avyGcxRLJeLoKmb7nQGXk10T6bqNxsAPQ2qkeJYi6fMbc5IrtPuz81HWpIJr/vmPngCfODJl53LEvRUeMPn/xL4ai7S1v+ry04/WLboFd3TgFzRM7pakh/33U2rby2V3pbN4bsDl6GFkAWoiAaApZvuFzn5p8kHEUnmomn3HxRrnacW5N7si9dXYHoFGSfK/c8udaYl+7m5tf6R5Pu/oJOCN1hG+C4l2fTSTeBf58NRisQV3cPfLYfKN0PTLf08XkwvW6iWsP
 dHOCkd86
 OZrHZnaf8FnycAb7bKZCsgpksdOiRZDrUE4cmc8MiLeVe1W7/9aKAjwecgLIRlO+7tNB4saLez1VPkF5UndpPgxf7DTnSUrz62UTuh+GmZG6almV0qfgxQads/6GahDnDELFE7VSwxnaO9Fp/2EfQZdgNNiuawhPBtLOJ4kLYJhe9GVwSH8ZQ1hTF2M/Hngi+PQtmz4ujJZFcRWUejTDXvjgxuhbPbsSCQwQ+xX5i3pT4O8ZaruHDrE4IGd3wprYcYK7ixI0N9cMuvdIJ6Luj7cebsaWp/TYBg3lbYS7nq8+ghFV2DZvqAC5UfgXE5AWOm5gQvNPqzsYZgKwswAj8oYU34kRaO9y4g2ag3LvH5vzZ/FrrYVgjdB+1QmlAVR5bVpe5hbnJByhxs5brDxx4TomykFcRqrAqxOwzaRtd0iPa7mPFqPOtCqfT8X1I4H4mpOaV2qI7JGtto4IJ952I4kMOMu9l5AoHrWYuOyA37TEkJ1hyGLQ46qLbYLwSZYP2YifB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 8:02=E2=80=AFAM Andreas Schwab <schwab@linux-m68k.o=
rg> wrote:
>
> On Nov 12 2025, Deepak Gupta via B4 Relay wrote:
>
> > From: Deepak Gupta <debug@rivosinc.com>
> >
> > `arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
> > VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
> > updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
> > This is to make sure that any existing apps using PROT_WRITE still work=
.
> >
> > Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encoding=
s.
> > Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
> > encodings for shadow stack. Above changes ensure that existing apps
> > continue to work because underneath kernel will be picking
> > `protection_map[VM_WRITE|VM_READ]` PTE encodings.
>
> This breaks LTP mmap04:
>
> $ ./mmap04
> tst_test.c:2042: TINFO: LTP version: 20260529.5ccf816f
> tst_test.c:2045: TINFO: Tested kernel: 7.0.10-5-default #1 SMP PREEMPT_DY=
NAMIC Sat May 23 12:09:09 UTC 2026 (bb95589) riscv64
> tst_kconfig.c:90: TINFO: Parsing kernel config '/proc/config.gz'
> tst_kconfig.c:753: TINFO: CONFIG_FAULT_INJECTION kernel option detected w=
hich might slow the execution
> tst_test.c:1870: TINFO: Overall timeout per run is 0h 04m 00s
> mmap04.c:66: TPASS: mapping permissions in /proc matched: ---p
> mmap04.c:66: TPASS: mapping permissions in /proc matched: ---s
> mmap04.c:66: TPASS: mapping permissions in /proc matched: r--p
> mmap04.c:66: TPASS: mapping permissions in /proc matched: r--s
> mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -w=
-p, found: rw-p
> mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -w=
-s, found: rw-s
> mmap04.c:66: TPASS: mapping permissions in /proc matched: rw-p
> mmap04.c:66: TPASS: mapping permissions in /proc matched: rw-s
> mmap04.c:66: TPASS: mapping permissions in /proc matched: r-xp
> mmap04.c:66: TPASS: mapping permissions in /proc matched: r-xs
> mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -w=
xp, found: rwxp
> mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -w=
xs, found: rwxs
> mmap04.c:66: TPASS: mapping permissions in /proc matched: rwxp
> mmap04.c:66: TPASS: mapping permissions in /proc matched: rwxs

But what does a writable only mapping even mean? It can always be read.
I see two ways forward:

- It can be done in generic way where incoming PROT_WRITE means
  PROT_READ | PROT_WRITE irrespective of RISC-V. Although others
  (x86, arm, etc) would have to weigh in.

OR

- mmap04 LTP test can be updated to expect either of "rw-p" or "-w-p"
  whenever only PROT_WRITE was specified.

I think latter (updating mmap04 test) is the easier path.

>
> Summary:
> passed   10
> failed   4
> broken   0
> skipped  0
> warnings 0
>
> --
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint =3D 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC=
1
> "And now for something completely different."

