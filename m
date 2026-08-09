Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74ED0C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 04:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260EF6B0106; Sun,  9 Aug 2026 00:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236D16B0107; Sun,  9 Aug 2026 00:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125C96B0108; Sun,  9 Aug 2026 00:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2BB26B0106
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:16:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 224BD1404A5
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:16:42 +0000 (UTC)
X-FDA: 85080419844.24.0049636
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 297A080011
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:16:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xsif203G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786249000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEJfTEDHJt9NLvc9wWmqXGDB9HdtwB+EfSEcVZv5fUE=;
	b=uelY53yFNGCrKqTSTF5BmOBu8VlEwUz1t89wEtShWeCudGh/oYz07/zBXwE+Z+BNhKnQM+
	cBjiwnEIlrWGvV+SQq5Tf2ujAaiagea9ksXrebQ6vlLHZZnsAcjvKSOMXhwnUeW1WgJEJH
	vthkFINi1UC35faI8Rmxuf0m8SGb+mA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xsif203G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786249000;
	b=Uo8WUXWbcFF1O9VXw6pJ2T5b1nWsEqWyY3/GRH1UqxSBWtFtutxGepk5705oBap0/bGx0m
	j+NTDOFGX31+Epg0AVfM13s51Z77vOlq8G86X3mpV2lvFuIT3IF4jtiYhmkZgcgWfqyEjh
	dajq4aVLr6Ohl11cADHBrS5J7Jo7MUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24E7C43E83
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24921F00ADE
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786248998;
	bh=WEJfTEDHJt9NLvc9wWmqXGDB9HdtwB+EfSEcVZv5fUE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Xsif203G7VaCiG1PzPp0/RgnSSQfomKj7Kse/6bOn1VHXaop30K6haKnOAjMUY3Tj
	 paKF5D+xUzXjmf4x3xQCk2eiN+n8no5VvwZxhYg1idvcIPFqEa3Sp1DYIRembuocMu
	 Hzx2RTRxB6BSKfKu8NtMZNeYERcEvHQCIWwkohbYj0Kg8DKKOoyLZC/R4NtbBocuPV
	 hW54pk8rqAxUdxqHZKKUXbcI2TugBAqQx6/BaaJRNiEMAr1geSKFblNn7FGMZEldhB
	 xa3WceM6CrRQbJXL4yXsl138USOVgPxo5mlV6nmzlQ5HCCiyP84SMXA+iFGynQW7ms
	 1tROfhJPh9sYA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so861742a12.2
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 21:16:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq85LuXKOgqI+6tvpkZ/T7Vxzv3ItfsfZoIycBMumFH9v4JezQNtt7cxjMYvpX6iy7AS8dM2VBHeg==@kvack.org
X-Gm-Message-State: AOJu0Yz+zT2PbNrJRiSUzfbcrt+/4y44psvqbhmBC3117pr/0QBM2OcG
	TVMdzJlK1UxWplAltnY0HrQsb1wP/Ff+aTtO6Ub/IwS8UlhQ4NauWfLZl2oOu6mRZLZoTxKKRh7
	B/Fw0KZYV420dzaC89b37qamBSU11ogE=
X-Received: by 2002:a05:6402:916:b0:6a1:2efd:8687 with SMTP id
 4fb4d7f45d1cf-6a14f132690mr17469409a12.14.1786248997461; Sat, 08 Aug 2026
 21:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-5-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-5-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 9 Aug 2026 12:16:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
X-Gm-Features: AUfX_mznkXpFMDYsM8EQmNDhdR03Th0a7eD16k8LboAyBQB4rd5wtvUyIPPIU6w
Message-ID: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org, 
	Kexin Liu <liukexin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: wr1r7nieee8ujdb5x57cx35zmpgp1od5
X-Rspamd-Queue-Id: 297A080011
X-HE-Tag: 1786249000-795897
X-HE-Meta: U2FsdGVkX18dPkLB6BIhW060iN6uAEmpncYXrok1TVLhmHajUdBdr35thvap2RhvtSU21E+2sHk623ryfY0lab2f8/BD5REWEuLiZJhXK9t3cxeJHAYKXaCq9EjTWZJsLiVp98lpeLvQwV4aZh8P/Ni+PSVnejpkXXJJw0Sbc5bbmLOK2ZEwKST6Rgo4pGUm8iZ3pWEGZso5GuXO/Io2zbJTGBUVYWtv8OwgLcuetFmdHbpiSvkeJNh9Zu33CL2EradeIBfS7040S3riFYuEHctJohHgvrqK8B4viKYu7KShQDV1r7ma3jXB+nr2dWDVaEm+NfIV97JdqxNa92dJxX76v38z8LMwV+iLIZb3hgtF60QLZsydJK/vNuBs6BSEQ5HJE4PezKEnrgtOHt3XRGLNWAUzLyQO3znxkZjedg6ZBkCJEwyEoLSeLxwx64nmGx0PwlJLXPnJqr5+KxMp5a95H6t0+dG40Ix6oO4isAphZdJ51tu8oY1BPI8fnmtZAzuZXMdUWIshG1OQUoNPzzKL30/ClUkXxRVo3qfn+6e82jZ0s9Y19/F8obqkJZoxCmoBHCwWpJUsB0qKvOtTI6TmCtTyvNmKfNP2Hh50X6hOOsrS6Wlur+5My5jzVPUOunPgtsBK71GPZTfxQc5cHFw2audsa4B4w2NDZ3s12fSdTh3bjOiLv5rkRpYosPHr0pNzi3Uv3E8BBAsdgWod7QfuX31x0hd4J3/kplbEiZHHq2Nq6jjrveTIO5BzZ+Rn5fIstfBQAf764cyXhIIaozMNVyZjueZ52trXfBvNlWHJqYuLHXRqRTCjplsfvr5Xmb/PKCgkAjFcPPeThLlYUtSta/y2wWBMr+ONElS72lfdEOeFWnFVWUYklkdvFVzb75RXS5EZNVuJJ09C36qLKVMW24J9kwzqb2yW2a2YB4C2cOdJswZ8bSCUU1AAFBpwWg1mhfU9NL5hlpKYTXu
 CKxiH1+V
 jOpCokuR589kiyt+SXyBG4o8YxYLZSnwjcrd7xEiXlVKjI5yOOKHeB7/fb/e07YQYxiDxiGGfVqAL6kHiita3x2J9uiuD3XU2dPvro6Cc+JjcwlTMzilFkusKUYL0fq9rodX+zZ9kU5GoSL8NIkVY4tzlOOzujLzoSFUb3oFIgcNLFf94ZM4YSg1gpE/4hg5QTeg6FBxu22k/9fQjX03FQT6KYLsi5DtOyr/fbzhXJr+ExrA/j+Poc282cgCwGqxb0bECNrKRHx618bEkE23i0gSIAMN3Cj6DCquT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, George,

On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> Add loongarch.conf to configure QEMU's LoongArch virtual machine (VM)
> with a la464 CPU, enable the 8250 serial console, and set the kernel
> image to vmlinux.efi.  Extend vmtest.sh to recognise loongarch64 as a
> supported target and map it to the 'loongarch' kernel arch name.
>
> QEMU's LoongArch VM provides no ACPI tables and relies on FDT to
> describe hardware.  Without 'earlycon' on the kernel command line, the
> FDT is not scanned for a console UART, no output reaches the console,
> and vmtest.sh's console log stays empty causing the test to always
> fail.  Add 'earlycon' to KERNEL_CMDLINE in loongarch.conf.
>
> QEMU's LoongArch VM has no i8042 PS/2 controller.  When PNP detection
> finds nothing, i8042_init() falls back to probing the ports directly.
> On LoongArch the I/O ports are memory-mapped, and the i8042 port
> addresses are not backed by any device on the VM, so i8042_flush() takes
> a page fault and the kernel panics:
>
>   i8042: PNP: No PS/2 controller found.
>   i8042: Probing ports directly.
>   CPU 0 Unable to handle kernel paging request at virtual address ffff800=
000008064
>   ERA: i8042_flush+0x50/0x198
>    RA: i8042_init+0x2a8/0x35c
>   Kernel panic - not syncing: Attempted to kill init!
You never answer me why in your test you should disable i8042 from V1
until V4. In normal use we use a single kernel for both host and
guest.

Huacai

>
> Disable SERIO_I8042 and its dependents (KEYBOARD_ATKBD, MOUSE_PS2) in
> the QEMU_KCONFIG fragment to prevent the driver from being built.
> All three options are scoped to loongarch.conf; no other architecture
> is affected.
>
> Wrap the QEMU invocation in run_qemu() with timeout(1) using a local
> time limit so the test always terminates, even when QEMU does not exit
> on its own.  This is useful for every architecture; on LoongArch, for
> example, QEMU provides no EFI runtime services and machine_restart()
> falls through to an idle loop after kexec, so QEMU would never exit
> otherwise.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  tools/testing/selftests/kho/loongarch.conf | 11 +++++++++++
>  tools/testing/selftests/kho/vmtest.sh      | 22 +++++++++++++++-------
>  2 files changed, 26 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/kho/loongarch.conf
>
> diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/s=
elftests/kho/loongarch.conf
> new file mode 100644
> index 000000000000..e45fe1014cf3
> --- /dev/null
> +++ b/tools/testing/selftests/kho/loongarch.conf
> @@ -0,0 +1,11 @@
> +QEMU_CMD=3D"qemu-system-loongarch64 -M virt -cpu la464"
> +QEMU_KCONFIG=3D"
> +CONFIG_SERIAL_8250=3Dy
> +CONFIG_SERIAL_8250_CONSOLE=3Dy
> +CONFIG_SPARSEMEM_MANUAL=3Dy
> +# CONFIG_KEYBOARD_ATKBD is not set
> +# CONFIG_MOUSE_PS2 is not set
> +# CONFIG_SERIO_I8042 is not set
> +"
> +KERNEL_IMAGE=3D"vmlinux.efi"
> +KERNEL_CMDLINE=3D"console=3DttyS0 earlycon kho_scratch=3D16M,16M,16M"
> diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selfte=
sts/kho/vmtest.sh
> index 0014bd76e88d..de6aa59cf5a0 100755
> --- a/tools/testing/selftests/kho/vmtest.sh
> +++ b/tools/testing/selftests/kho/vmtest.sh
> @@ -21,7 +21,7 @@ Options:
>         -d)     path to the kernel build directory
>         -j)     number of jobs for compilation, similar to -j in make
>         -t)     run test for target_arch, requires CROSS_COMPILE set
> -               supported targets: aarch64, x86_64
> +               supported targets: aarch64, x86_64, loongarch64
>         -h)     display this help
>  EOF
>  }
> @@ -111,12 +111,19 @@ function run_qemu() {
>
>         cmdline=3D"$cmdline kho=3Don panic=3D-1"
>
> -       $qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
> -                 -accel kvm -accel hvf -accel tcg  \
> -                 -serial file:"$serial" \
> -                 -append "$cmdline" \
> -                 -kernel "$kernel" \
> -                 -initrd "$initrd"
> +       local qemu_args=3D(
> +               -m 1G -smp 2 -no-reboot -nographic -nodefaults
> +               -accel kvm -accel hvf -accel tcg
> +               -serial file:"$serial"
> +               -append "$cmdline"
> +               -kernel "$kernel"
> +               -initrd "$initrd"
> +       )
> +
> +       # Bound the QEMU run so the test always terminates, even when QEM=
U
> +       # does not exit on its own (e.g. no EFI runtime services after ke=
xec).
> +       local qemu_timeout=3D60
> +       timeout "$qemu_timeout" $qemu_cmd "${qemu_args[@]}" || true
>
>         grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO =
failed"
>  }
> @@ -127,6 +134,7 @@ function target_to_arch() {
>         case $target in
>              aarch64) echo "arm64" ;;
>              x86_64) echo "x86" ;;
> +            loongarch64) echo "loongarch" ;;
>              *) skip "architecture $target is not supported"
>         esac
>  }
> --
> 2.53.0
>

