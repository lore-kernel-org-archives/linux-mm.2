Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A138ECD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8736B0005; Mon, 25 May 2026 06:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3892F6B0088; Mon, 25 May 2026 06:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2779F6B008A; Mon, 25 May 2026 06:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 113F96B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:24:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BE401617C8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:24:51 +0000 (UTC)
X-FDA: 84805558782.09.77F1B73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D28B380003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:24:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bf8jOchE;
	spf=pass (imf02.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779704689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TRhXlL7M+bh0nA0422zvkrUv8DgtfhlLo+sCPkC9ec=;
	b=uLnDl+mOpQDIVVpCz6cLwbOgh0IGZ5zLFB0WL3+3gRPEuob4oDWEUdmuXWOvShY4yfTEAr
	qVXyhZvZVHjWey+Lv4AbnaEcO+8wNNMbU6LJM4EYLvTp0uUouoF9J59GEQLt5Iw2YQx9Q0
	Xc3MEpda95lLzH79s71I6zyqlxNt2po=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bf8jOchE;
	spf=pass (imf02.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779704689; a=rsa-sha256;
	cv=none;
	b=zzWDTmkBSgwMpqFLF3QnXmR1CvpSxeOyYbBfIB8Tn2KSHbfM6dv5TGeqQTbmZgIUO+GX2o
	aoIcIrtz2MWrE0xKhIm0S2m6Ru9JQtuJOFAumB2ZhhaTG+uRg6waE3yYN9Qw7UzK0phD22
	YQ2zcIdSn7JbU1M02M4LCv9CZ2OcmZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BA38600FF
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DBD1F00A3E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779704688;
	bh=/TRhXlL7M+bh0nA0422zvkrUv8DgtfhlLo+sCPkC9ec=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bf8jOchER9UmNKlRNawyfjT1ivoJbbX7MT8VhTo5F9z75N9pO7kJWma7lGm2m/kHn
	 I1QhvcGCNQQ959H+Iprj7T7YtUPqToevhsV9cjOvPTugFQcrE4VSaJ9e89NtmJ2Gbn
	 wSoQIo7Mk/kQscLsnw8D6Hn2AD+T8usnAbwODg84DK057URyMq/ffh3YrYex4N5fou
	 fU0q/B2ilf3olT08OalSriAvL81oPOcPhZl8UoCm0VfjJDFtwrx6jrgIw0M3w4zgwC
	 gnRyCF3XJTAt0kYZ0+YH+4dXUoPDSLFQrGOiIEMVZJ5nS6ixOvnuIJ1vnYN8E9LDkh
	 VFyPdNxtyHRRQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd8d0e4e341so1311075866b.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 03:24:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9dpqPFrL+v/X7VY5+aijA29hPVmHyewLHl/CTC1MSjXsh5VlpGRewTIhB6uybMkihUy0zTCfgYxA==@kvack.org
X-Gm-Message-State: AOJu0YzRwP8nwfJZpWVgmPA8Iwg/cfu+XT7wEg/ywuQ5+9gIToTOhVSa
	X/CF2N5yuVyetAXBmuVamlFOpOIR4fShGIlgpAa3zflW493rYjtgEuaCuqrcgGZFjXwTT5tY5z7
	c624hxHdwd/kamcGNUT6uKuKFGYEPJqo=
X-Received: by 2002:a17:906:dc8b:b0:bd2:aeaf:470c with SMTP id
 a640c23a62f3a-bdd267c8024mr853835966b.40.1779704687546; Mon, 25 May 2026
 03:24:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260525062810.103367-1-dongtai.guo@linux.dev> <177969529480.4047269.2120994507098781563.b4-review@b4>
In-Reply-To: <177969529480.4047269.2120994507098781563.b4-review@b4>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 25 May 2026 18:25:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4p8xe_Hfx81kjxNrp5g7RKvi4f1QM7avLvnf_r+VazFA@mail.gmail.com>
X-Gm-Features: AVHnY4LTd0Kg3PKCCZqbfiXECjfM-2DhE2l34GPEKNdQUAn6_sdoLxbmWOkvxmI
Message-ID: <CAAhV-H4p8xe_Hfx81kjxNrp5g7RKvi4f1QM7avLvnf_r+VazFA@mail.gmail.com>
Subject: Re: [PATCH 0/7] LoongArch: add KHO support and selftests
To: Mike Rapoport <rppt@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	kernel@xen0n.name, graf@amazon.com, shuah@kernel.org, 
	loongarch@lists.linux.dev, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	George Guo <guodongtai@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D28B380003
X-Rspam-User: 
X-Stat-Signature: 6w37hkt9cupswxuzadb7gy4xpeaq9qrh
X-HE-Tag: 1779704689-647785
X-HE-Meta: U2FsdGVkX1/Kiq+QqjdLqxVqkYMTTCAk3GsOHItj7+mHWBbwLcYtL8VRNMkZShxKYKArAGCzzwmmu8Ym7KhrdJlwWQ6gDcFJz2Pp6n4D8GjTliz37K5kVl+zkT2ytjJ6cG7tiIyF1/pPEn382KjWMOC9uNOw8u8Zc/OGSSd1xv0xU/6GZz1MHh/VXXnVKZCS5vmSm+erl4FoUeOFYvoIXtjDgMRUws+IjLnQbtBAfu8okMCAyp53mMib2EvGqPNaR/1jhLmgY8JLCQpC2hQhH74jK04yS3dS6U//ZtXHtqj3E5drP8f789miaZrtZzgL6/DpPfvSXr3cBIVS89LQHEXrFnGQU3hivTHGI5IvBEEJjxsOaYHdATo35EtbGIU0tR7bFqc2Jm9WaW9ooPHyG25ZFjT44vsRaOPx7mKhkXjODHGdYrgXoY3goQ7nBB86Atz8Za5yG93+lfuFZTPnv+DOQ5xLU6zxuHrsr30qW6rYNRei+ooHsp/A46k2Xn9RYNZRDlaKWl8IUOB3ct4nhq4uDDmMwku8TmGqIsla4NiKk/XHKe1kigrdI+JeC925GDHKU41BERUqdWr2Rs6Itup3XyFpJIJs5S50sL26ZKKYCy2y28AMqHOiUqTBYqpaKZPvMEEA2K4AsVW3VEfQR4JH8f8nweGAZ+57bWCwsh3bU0I+e1t+8bHVnMaH5Lx1jBper5Ym53gRMZXdE9FjeMBpIvhh22e5bWOaPRoU8wtU9St5Tq4EuESYMeC0lLgogBI3YScYLLPlc18fuDvanBIJQqWJA2FUa+IkF9oF/VDJE5tXUG+FaY6UDhORdRiH5jxXLcgrpIoR85CnwmOgOVEynGz16+CprzO2lP2H8Lu3Hx4Jf0j4PxqEf4BkeCWJ0vy+dQaXgwavbSzfM8PeR7emPjQui2MPUpyFKG90Ik+pnviLxRXHoDKkc1Y09YsfI11srKf7h/LYZQV6SwK
 zLUU9srF
 NBeF/JZ6SzwT3/gix6dEOvmQ1tobldQ/3LHEZYyxU79oNIOIh3nr+viT29T8Am3fd2VCKn7C3IL2Xcf9au4P2CLD7dVu5sVlB2vROuZWpcWUlTadOpAjbnmi5h2dHPyVMVyn2fdBKidaUtj/db2Cal49k4iddrSqIAZFP7UL6v1P0Lsf9r/LcwTHa+h0cCm84FMmKp4sdEU1zy96raxRUPmO2M5huOKMGJP6K3GzPA4aE0i4ozvSUxh/s/7fJpQg86La9EYvEeJQCNBJEtKfR8KL+A0AkPHZFBGrn7ZjKwQRaIpZ41ioSRxnqNvUNvCdOroQiivb1kEfqS4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike,

On Mon, May 25, 2026 at 3:48=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, 25 May 2026 14:28:03 +0800, George Guo <dongtai.guo@linux.dev> wr=
ote:
>
> Hi,
>
> > [...]
> >
> > Bug fixes (patches 3-4)
> > ------------------------
> > Patch 3 fixes a build failure with CONFIG_KFENCE=3Dy: virt_to_phys() an=
d
> > phys_to_virt() in asm/io.h expand to use offset_in_page() and
> > page_address(), which require <linux/mm.h> that was not included.
>
> This fix looks unrelated to KHO, it makes sense to send it as a separate
> patch.
He tried, but it causes new problems, but I agree this patch has
nothing to do with KHO.
https://lore.kernel.org/loongarch/202605211925.DbDvQ6ii-lkp@intel.com/T/#t

>
> >
> > Patch 4 moves KEXEC_CONTROL_CODE from 0x100000 to 0x180000.  QEMU
> > places its machine FDT at 0x100000 when booting with '-kernel'; the
> > previous placement silently overwrote the FDT with the relocation
>
> And I believe that patch 2 and patch 4 can be folded into patch 1 so
> that addition of KHO support will be a single patch.
Patch 2 should be folded, but Patch 4 can be separate, because it
should be backported.

>
> > trampoline, breaking earlycon in the kexec'd kernel.
> >
> > Selftest support (patches 5-7)
> > -------------------------------
> > Patch 5 adds loongarch.conf and extends vmtest.sh to recognise
> > loongarch64 as a build target.  QEMU's LoongArch virt machine is
> > FDT-only (no ACPI), so 'earlycon' must appear on the kernel cmdline or
> > the console UART is never discovered and the test log stays empty.
> >
> > Patch 6 disables SERIO_I8042 and its dependents in the QEMU_KCONFIG
> > fragment.  QEMU's LoongArch virt machine has no i8042 controller; the
> > fallback port probe hits a page fault on the memory-mapped I/O range an=
d
> > panics before reaching userspace.
>
> This should be folded into patch 5 for sure.
I completely don't know why Patch 6 is needed, for normal use I8042
doesn't cause problems in virtual machines.

Huacai

>
> >
> > Patch 7 polls the serial output for the test verdict and kills QEMU onc=
e
> > it appears.  QEMU provides no EFI runtime services on LoongArch, so
> > machine_restart() falls through to an infinite idle loop and QEMU never
> > exits after kexec.
>
> And since without this selftest would hang on loongarch, the timeout
> handing should be folded into patch 5.
>
> In general, the rationale when adding new features is to make sure that
> after each patch there are no regressions and the new functionality
> either works or cannot be enabled until completely implemented.
>
> --
> Sincerely yours,
> Mike.
>

