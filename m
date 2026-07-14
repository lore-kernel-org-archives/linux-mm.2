Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0336C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A77B6B0096; Tue, 14 Jul 2026 08:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F156B0098; Tue, 14 Jul 2026 08:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC3D6B0099; Tue, 14 Jul 2026 08:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43DFD6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:17:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED8C9140385
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:17:03 +0000 (UTC)
X-FDA: 84987281526.23.2908F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1CD71C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:17:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daQnjhci;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031422;
	b=J79vPiDd3ptWfwgPz6X6jqFSc92hx/A4+IsW+ElpvAWNGAnjpWTBwp0itnTsazMRJ0NVyy
	b0q6rNjVsimWdmuNwxtL4+fU30E4sAVQz6uKcv0cfke8lYuT8oNYexu8hqpGVvmc54DNQo
	BtaDp9VD1vdw4Vk/UHKINJpUbrFqhdQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daQnjhci;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObYWkLNfQi85p38uahLx6yranNyzKYkaSbUyvi+K6ZM=;
	b=ofBeSMVawGJvisX75QuNHvbe7pYjxJGmRbyq7yaYXCXthGnPF62NI/2ktU9fbXEGkAUXtU
	OxhZrV9D8ciTvn0e+JBlqy3g5W+HqRYx46kvCL7AhG8etX4jaQoLh6RuPhIeETrMsNsSCi
	PEqc33iegyGXESsj+Jt9g1JIgdHcYdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7514E601EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6861F000E9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784031421;
	bh=ObYWkLNfQi85p38uahLx6yranNyzKYkaSbUyvi+K6ZM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=daQnjhcicbJzzzDaAuFYC6b8ZcYAs9CAE+dZjOfq5dbSgkVQwiNPgO9MRAxwXqH3M
	 frDdW60C9rIy4AQot91BiEaZCb0SCnuGD61TraVaNNcc5VsahjP/J8WpPGZthzFyE3
	 wqHvAQmiLyFXK8cFDxO5QeMIdXDFc7fWF/UcVBYpg8XrvEZIMixtV9kxHwgSz4HZvR
	 gJzt3e4715WhNhMLe2N7EbbM8orlnN7teYudfE692wxRhsI1aVImOeJaucjq2DZ2/t
	 QC7jxAMJ+OrLhzuv9LF7i3GZ9sqF1S0C/Ie48KpNLLEiDr5Gb8IRo9oVZx9NVlnO7b
	 zZFswpfh9K8pg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-698ab9aae16so1692385a12.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:17:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrR/7ATZUa/TNY3lcpxDj3svKuOUe9oYTUr797hjobVnMv9S27LxehY82cw8BT0jODOJteSAkEKNA==@kvack.org
X-Gm-Message-State: AOJu0Ywzh9EM/pKQYrnQhHCJ3PkUyPHvEF0JfJXOTyGkDRfF18whdu3R
	ZAKuoDCxOrdgotlJBA1h7hlGnfjqxVO0cq8W/Sv89CGI74R6eTT5TXmL2LRYLh9BHSa0W6e33eK
	SOknvBLge0eK4pwCEyLWraAmAOshh3YA=
X-Received: by 2002:a05:6402:5187:b0:698:5610:76e5 with SMTP id
 4fb4d7f45d1cf-69c5ef85585mr5895270a12.6.1784031419744; Tue, 14 Jul 2026
 05:16:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
 <20260601093930.112758-1-dongtai.guo@linux.dev> <2vxzjyqzj8s2.fsf@kernel.org>
In-Reply-To: <2vxzjyqzj8s2.fsf@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 14 Jul 2026 20:17:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5B6Mj2-AffkstJ4f8EEmvvPOGXoDy2QNudKD2kSz2XkA@mail.gmail.com>
X-Gm-Features: AUfX_mxp11E4giDW39QHMMI9j_IZOTy-7xjXpv5wTuK8FeqnLx4XCv9zSCzZnnY
Message-ID: <CAAhV-H5B6Mj2-AffkstJ4f8EEmvvPOGXoDy2QNudKD2kSz2XkA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] LoongArch: kexec: add KHO support for FDT-based
To: Pratyush Yadav <pratyush@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <shuah@kernel.org>, 
	George Guo <guodongtai@kylinos.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Alexander Graf <graf@amazon.com>, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, Kexin Liu <liukexin@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1CD71C0003
X-Stat-Signature: gk5ryh6pqufeejmdhtstn4yxp6nzxr5s
X-HE-Tag: 1784031421-323860
X-HE-Meta: U2FsdGVkX19TMt8nJIYE9ttKHqcTURAGa0tmpBYRKDI1WqyHMULyg5LdiEYnoOT3XE8R75jteDtQeem2g937vEISY+L55tJz6Ir7hWoE7wjalA1b8m8A/FAI2JQjivsUkwdzHtwv2nEySJzAhtkQCWSclUXYr6Y2ldH37lIRc5bdZebodLCK9sJ+ASwybyYBCW0wwa7oXMs/u0hZr0nndk82c1jnTqXawdHYHtkzoPfPQDCLdFhbVNxM4cVtP1FlJkHDD0HBPsmVOYe3EQ8s/o0y/tdyMhKyuWrzOjZI/zoZcDjEgP7/dNI2go6rtc7ZOOPxgdBh3AkKb2ma9FT/DRxwB/JIHyKieINs5mtLyeY/O6aL6GRVCtro23D0tBDAiDCUVjmnrSxIVS+UHNOClQoyTwTm3SEzkRYAoGyzNaXHGiCzTW2GTJ1HxfF4Hdj+xvh0Ll6ODmTNKbnIxR9nkeEyN3S6RxODUZCIiFUgB6bDVhqDUlLhyAzRo/kWVHRl4Pieeruk3RkV82lqoeM+hdYPXLSl/OOLr8VYbdIOameL5DkGmgR/6di4JsKBfzf8wzzmTQFTc9g/LMfFloFQbztBEXIlGQjppsTxQaSeyj3YuuxwtCcew9pI1oKeR/kX83zyJeGRelYELO8kEmhzHOJmtcwUjjPTNUZ/1NjPUh8wvwYhPgNOq3U/vfkxF0yp9oyMhDLXB4P2A8Y9VSW2203+86ruNHE22wL6vemAhnc09DYHb5FgG00GWUkk4ljq6MS7c4Ey2Tt5Dw1tRc8upRg/67pFOEs/valfgRqOqR4Pt9mssSi7LrsjiPqWejNDdKicLL2gjFnoTXGuOOPSEYmtIIcJSDGAWnjLYxgqCwIeyM9cBXk+ZSNFJFpXzWBdYtV0TJao+aYw1MyelUPFrI5uFdFCZ8h9VIc0qv0vNjaBdBO3RzK44m3gtb5qD7oFgQcjdavpRPz1t6l+BKP
 e6Sbfkk1
 9aPnRPeO2eVAXeyKGLS03qr62cqWZsJaSFicV5Ye2EJrQNxIsRQwPN135Z0QMqb5hagP73CcJPt1TCyvNBqMrAB5R734DRuQ/TnLQLTOSQmWv5wzwFJS6TETyDATFJb9PsbQIvAgQNALT+/s+zQKpTfJTMoQf96zx3LBPd77ZrnAEJUL9xQu7wlNxnX6cNQXx0ynzh6cb4ns/OXiCyfRJtsgk8KXgNBupK1XsPbSNktMBxSK0f5yr48ekKO71BmVOO+C+NKmzSctZTpoq2B4bIVX22XF0jJUASau3E4HW0vYKcyZGPW2ApOC6J4KreTWzsFyO25XcqgZAvecMSnlogLyg/LtfuDcZXgjKc9p7roFC6MFcIJ4rz3orsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Pratyush,

On Mon, Jul 13, 2026 at 9:53=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Mon, Jun 01 2026, George Guo wrote:
>
> > From: George Guo <guodongtai@kylinos.cn>
> >
> > Enable Kexec Handover (KHO) on LoongArch64 for FDT-based systems.
> >
> > - Kconfig: select ARCH_SUPPORTS_KEXEC_HANDOVER for CONFIG_64BIT
> > - kexec.h: add fdt/fdt_mem fields to kimage_arch to hold the KHO FDT
> >   kexec segment virtual and physical addresses
> > - machine_kexec_file.c: add kho_load_fdt() which copies the running
> >   kernel's FDT (initial_boot_params), appends linux,kho-fdt and
> >   linux,kho-scratch properties to /chosen, and loads the result as a
> >   kexec segment; called from load_other_segments().  Returns -EINVAL
> >   when initial_boot_params is NULL (ACPI-only boot) since that path
> >   requires separate handling.
> > - machine_kexec.c: before jumping to the new kernel, update the
> >   DEVICE_TREE_GUID entry in the EFI config table to point to the KHO
> >   FDT segment so the second kernel finds it via efi_fdt_pointer() and
> >   early_init_dt_check_kho() calls kho_populate()
> >
> > Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> > Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> > Signed-off-by: George Guo <guodongtai@kylinos.cn>
> > ---
> >  arch/loongarch/Kconfig                     |   3 +
> >  arch/loongarch/include/asm/kexec.h         |   4 +
> >  arch/loongarch/kernel/machine_kexec.c      |  27 +++++
> >  arch/loongarch/kernel/machine_kexec_file.c | 118 +++++++++++++++++++++
> >  4 files changed, 152 insertions(+)
> >
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index 606597da46b8..d494418545f5 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -684,6 +684,9 @@ config ARCH_SUPPORTS_KEXEC
> >  config ARCH_SUPPORTS_KEXEC_FILE
> >       def_bool 64BIT
> >
> > +config ARCH_SUPPORTS_KEXEC_HANDOVER
> > +     def_bool 64BIT
> > +
> >  config ARCH_SELECTS_KEXEC_FILE
> >       def_bool 64BIT
> >       depends on KEXEC_FILE
> > diff --git a/arch/loongarch/include/asm/kexec.h b/arch/loongarch/includ=
e/asm/kexec.h
> > index 209fa43222e1..adf54bfcdd49 100644
> > --- a/arch/loongarch/include/asm/kexec.h
> > +++ b/arch/loongarch/include/asm/kexec.h
> > @@ -39,6 +39,10 @@ struct kimage_arch {
> >       unsigned long efi_boot;
> >       unsigned long cmdline_ptr;
> >       unsigned long systable_ptr;
> > +#ifdef CONFIG_KEXEC_HANDOVER
> > +     void *fdt;              /* virtual address of KHO FDT segment buf=
fer */
> > +     unsigned long fdt_mem;  /* physical address of KHO FDT segment */
> > +#endif
> >  };
> >
> >  #ifdef CONFIG_KEXEC_FILE
> > diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/ker=
nel/machine_kexec.c
> > index ad27fef098f1..98529c71d001 100644
> > --- a/arch/loongarch/kernel/machine_kexec.c
> > +++ b/arch/loongarch/kernel/machine_kexec.c
> > @@ -6,6 +6,7 @@
> >   */
> >  #include <linux/compiler.h>
> >  #include <linux/cpu.h>
> > +#include <linux/efi.h>
> >  #include <linux/kexec.h>
> >  #include <linux/crash_dump.h>
> >  #include <linux/delay.h>
> > @@ -289,6 +290,32 @@ void machine_kexec(struct kimage *image)
> >       pr_notice("We will call new kernel at 0x%lx\n", start_addr);
> >       pr_notice("Bye ...\n");
> >
> > +#ifdef CONFIG_KEXEC_HANDOVER
> > +     /*
> > +      * Point the EFI FDTPTR config table entry at the modified FDT so=
 the
> > +      * second kernel picks up the linux,kho-fdt and linux,kho-scratch
> > +      * properties via early_init_dt_check_kho().
> > +      */
> > +     if (internal->fdt_mem) {
> > +             /*
> > +              * FDT-based system: DEVICE_TREE_GUID already exists in t=
he EFI
> > +              * config table; just update its pointer to our KHO FDT.
> > +              */
> > +             efi_system_table_t *st =3D
> > +                     (efi_system_table_t *)TO_CACHE(systable_ptr);
> > +             efi_config_table_t *ct =3D
> > +                     (efi_config_table_t *)TO_CACHE((unsigned long)st-=
>tables);
> > +             unsigned long i;
> > +
> > +             for (i =3D 0; i < st->nr_tables; i++) {
> > +                     if (!efi_guidcmp(ct[i].guid, DEVICE_TREE_GUID)) {
> > +                             ct[i].table =3D (void *)internal->fdt_mem=
;
> > +                             break;
> > +                     }
> > +             }
> > +     }
> > +#endif
>
> Honestly this and the ACPI stuff looks worse to me than what your
> previous version did. Now I am not an expert on EFI and architecture
> stuff, and know nothing about Loongarch, but to me this looks hacky and
> I am not sure if it is doing the right thing.
>
> I think you should get some alignment with Loongarch maintainers on what
> the kexec boot protocol looks like. It looked odd to me, but if the
> Loongarch maintainers are fine with using the kernel cmdline for
> bootloader to pass data to the kernel, then I think we should go back to
> that.
>
> Huacai, do you have any thoughts? For KHO we essentially need a way for
> the pre-kexec kernel to tell the post-kexec kernel about a blob of
> memory that has some information it can use. For x86, we do that via
> setup data. See arch/x86/include/uapi/asm/setup_data.h and struct
> kho_data for example. On arm64, we use the boot FDT's /chosen node. See
> kho_add_chosen() in drivers/of/kexec.c.
>
> Ideally, all device tree platforms should use the FDT path. But
> Loongarch also has ACPI only and I don't know what a good idea for that
> is.
>
> So, do you have any suggestions on where to best place a pointer to this
> blob of data on Loongarch? v1 of this series put it in the kernel
> commandline, but I found that odd and asked if it can be done via DT
> instead. But to me, this code looks even more hacky.
I don't know which is the best way, but I can give some information.

ARM64 and RISC-V create a FDT to contain all needed boot information
(EFI system table, command line, etc.) in efistub. In other words,
both ACPI booting and FDT booting have an existing FDT to pass the
blob.

But LoongArch is different, the efistub doesn't create a FDT, instead
it passes the EFI system table and command line to the core kernel
directly.


Huacai

>
> > +
> >       /* Make reboot code buffer available to the boot CPU. */
> >       flush_cache_all();
> >
> [...]
>
> --
> Regards,
> Pratyush Yadav

