Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A17C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010316B00B8; Fri, 31 Jul 2026 03:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F031E6B00B9; Fri, 31 Jul 2026 03:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19DB6B00BA; Fri, 31 Jul 2026 03:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9E4C6B00B8
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:37:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 521B9A15F3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:37:43 +0000 (UTC)
X-FDA: 85048267206.25.D6B4FEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 80EBD1C0004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:37:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeW+P7az;
	spf=pass (imf18.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785483461;
	b=Gq/ONQJAq1/Q1gHLgd8mNCbxrxbReEpuklGIq6JwH2SlO5TG5BUFYNMrPA1AmVuNFNK03C
	qvWn3Fpd3OCHa6ctk1MfIseM+4D3/kVYnn7xBM1g5JYhj2sgbuBF8eZDKLIhk1V6S736hY
	L3WxUDmKQZ9VWHxpC8FXe3S7kfdtZHI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeW+P7az;
	spf=pass (imf18.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785483461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iZQHz7NeGZMsBVItQcixhsFj58C0OgYWDKDkF6Dau0=;
	b=dl5dMTw8vEJWpZFNrMOzZYmdxaxtheYFBzm0a7BmsOrFBlm6y3I43VP1wRoOE1rYGA2DJq
	Zjm/l0wdPRiqAmfBPjhUFVIM/my0AJ9D9FifGFaXN1EEyvMrExoyB7ta35OdXlaPHq2RZC
	UEQt+SLf45ZnTFzX4Jq3wSBDlfzML5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD60F600AD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D661F000E9
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785483460;
	bh=0iZQHz7NeGZMsBVItQcixhsFj58C0OgYWDKDkF6Dau0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aeW+P7azcEYrHe4APercn3sqTRSCmhLfiQydckmu95XOSwR5slHPjMPKNfiiO+QIk
	 MjpaHYQS87Iwp62b/ZOxFoxaXIXEsw013z04i7iXlXlKryDdsrhYOhQuJO70p6XqUJ
	 8AZTyUcOsFG0Zhj+yyo/LE1xMp+Sre+E9pO1F86eDnf5tX1TS/qAwRkgHYhq/lKgIv
	 DRMlTwyq24QHCTmw+mTMRrwF5xrJqYgBulqNZjIPPdKI5ZZMpS6UcMKAOBrzepRQUx
	 sO59Jp+/TnHl6XkE+TftXu83SPycyKXJMC115uN1uMPkJoywOERNDwr8b4pwFLhxOj
	 ZtQkF/ZYlT5MQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a08a2b7e5bso1015120a12.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:37:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw/K0h3h9jzLo5aWIElqHKrRSQXLJw/J7xH0gmpoo94ce+ANPVP
	YghMIFHoUpXpfWxHzMXsO+ULBOglGiyFA2NST0O/6mA57QpgGYBOVYCv366Lxxkl4GnZLqiedy6
	dgXgSh4fp0vufLzPFYuJwOW7rHGLtAQQ=
X-Received: by 2002:a05:6402:44d9:b0:697:eb97:a4ed with SMTP id
 4fb4d7f45d1cf-6a09ba1f2f9mr302833a12.7.1785483459137; Fri, 31 Jul 2026
 00:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260721090606.8982-1-yangtiezhu@loongson.cn> <20260721090606.8982-3-yangtiezhu@loongson.cn>
 <11c42b7c-7805-cce7-305d-6e52c14db20e@loongson.cn>
In-Reply-To: <11c42b7c-7805-cce7-305d-6e52c14db20e@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 31 Jul 2026 15:38:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H47kc-=A2syzJNLWOD1=TWumvyYWObL+xutrbSRy=WpWA@mail.gmail.com>
X-Gm-Features: AUfX_mwnrI87ZsEoe4v5LzD35XC58e3JtwAHKXTs3OkJso5rEbEdY1NBlQ3IO_I
Message-ID: <CAAhV-H47kc-=A2syzJNLWOD1=TWumvyYWObL+xutrbSRy=WpWA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] LoongArch: Skip address pairing for non-exec sections
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: linux-mm@kvack.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80EBD1C0004
X-Stat-Signature: wauyyhswitqn8qsq7bada3fodxzrc8d4
X-Rspam-User: 
X-HE-Tag: 1785483461-337589
X-HE-Meta: U2FsdGVkX1+8+RYlgopcm1hH3fPMjogefdFaS4QweOnNKXrLLa5ZXcEzIe6kHhA56+oVnoKStfJOHWSMBIs4Kp4nyGnTyUnH7CTXogbwMJUwPTevpL2RMJh34HYIKIE/iipMiPTFELXlvBQck0AFQUsHFP1qMMIPwDbJJ0E+x9Nd45lXpgqLS9jBkcGTW1gRYP6rZSBz4My/PCil0XRT72nKBIv+rMfE8VXprKSFW0SPGwscQ0zLHj3uX9K4+VwnSSdlVVmJJHMGuDRCNYwQGEdouv7/o1twHiFcN7RsT2cf0JCWSjulvubsoh2rDLDb1UFwBkmSwZLRe28ZRRd738kxdL+lcI8YjA2f9Hkd9XuwFNmTNj9lcLludUmJlEW/BSe/TFWGDW7j3GT3SESi+84/qZtXb6t+u/AAITiUizYH7/zqvKI9MHqWEb+Z/hsuv5I5jNFyaoyn4vjpkcVQuHxLfwICGjasV+L3wi8c12Yto4YRenkJd9ew6qxID9/hgEgV2IRuU7VzPVqCK7MmfamAc3S+cZ7/PddkHVs4LRhWRK2gYSwFfjwl49Ic2hfhppcZSY90YwII9FSGAXCb8DBLjPu7/ZFAJQ5Wpl7diIjT6a5eg7qfG8buxPDZ0zgy45NdJOJ4tY22eZm2HlviVGXmzCykqzpH8hu3pr6FADc6snaI0U+6zCz8ZpE/Lb+jjOZukvZHyH272sUuuikzQYfyXZRsYvogV13mNzUOqJRobkLwLf48JboJq0F3e/sZB+SciRYofWHHPNmbongRNgTmNAkgHg9e5WVd4G0dBcH4cUVsyWE90LAkXP4XF+otJvp+o8Sxp5JoJijXwlfqpZQ2Px5vknWCEGb4EHt9fbEGy0gkxm2o91xk1odrwIsniZ0/eC4GY1ly/Ibcn1UQTmd1V0rMfJEKjHOwcsdmKJCkzib3HmSH62uoMogWvNc03T87zYTOSLcU/et/Omh
 eSKvAYZd
 Wv9d0k6IwHK+ibTQDHh0a1t0FY70CpRebcWZU0U0zn/PftsH/HhlUokTdkiJGGgTHDBWoJ0L466ywav099yK/0zL7vvVagDPownLrZPEZzQMxFFwHg4xwe2dcP1J36B4bbzYV76BAQ1CwEsiZDft7cEkL314Bs+v2XQ08bGP1u9htTeQMMRboMjP3TR5bxBg5TwteVc0gyFMLstvZdh4hg35xSdINs5JNuyDhRPCMwIqaUL5IUpre87mQbj+oK/UX7yzHtQwEPnZ9ksRkhgra6y+DZvlo+TBM/SW6FWOEtvjpQyIEEnNk5StPOKvARNVmikS2l17j4TiZJUb/llVIndl1jo4UQ8V56/zYHDZ2QDvLuXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Tiezhu,

On Fri, Jul 24, 2026 at 2:07=E2=80=AFPM Tiezhu Yang <yangtiezhu@loongson.cn=
> wrote:
>
> On 2026/7/21 =E4=B8=8B=E5=8D=885:06, Tiezhu Yang wrote:
> > The module loader currently runs expensive address pairing logic for al=
l
> > sections blindly during relocation. For massive modules like amdgpu, th=
is
> > causes the loader to waste lots of CPU cycles analyzing non-exec sectio=
ns.
> >
> > Furthermore, there is an inconsistency since module_frob_arch_sections(=
)
> > already ignores non-exec sections during the counting phase.
> >
> > Check the SHF_EXECINSTR flag in apply_relocate_add(). If the section is
> > non-exec, skip address pairing and then jump to normal relocation. This
> > eliminates redundant search loops to improve module loading efficiency.
> >
> > Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> > ---
> >   arch/loongarch/kernel/module.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/mod=
ule.c
> > index 7d4d571ee55e..c84ac1546dc6 100644
> > --- a/arch/loongarch/kernel/module.c
> > +++ b/arch/loongarch/kernel/module.c
> > @@ -484,6 +484,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const cha=
r *strtab,
> >       Elf_Addr v;
> >       Elf_Sym *sym;
> >       Elf_Rela *rel =3D (void *) sechdrs[relsec].sh_addr;
> > +     Elf_Shdr *dst_sec =3D sechdrs + sechdrs[relsec].sh_info;
> >
> >       pr_debug("%s: Applying relocate section %u to %u\n", __func__, re=
lsec,
> >              sechdrs[relsec].sh_info);
> > @@ -522,6 +523,10 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const ch=
ar *strtab,
> >
> >               v =3D sym->st_value + rel[i].r_addend;
> >
> > +             /* Skip address pairing for non-exec sections */
> > +             if (!(dst_sec->sh_flags & SHF_EXECINSTR))
> > +                     goto apply_normal;
> > +
> >               if (type =3D=3D R_LARCH_PCADD_LO12 || type =3D=3D R_LARCH=
_GOT_PCADD_LO12) {
> >                       bool found =3D false;
> >                       unsigned int j =3D idx;
> > @@ -562,6 +567,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const cha=
r *strtab,
> >                       idx =3D j; /* Record the previous j-loop end inde=
x */
> >               }
> >
> > +apply_normal:
> >               switch (type) {
> >               case R_LARCH_B26:
> >                       err =3D apply_r_larch_b26(mod, sechdrs, location,
> >
>
> According to the LoongArch ABI specification, the following relocation
> types exist exclusively in executable code sections:
>
> R_LARCH_PCADD_LO12
> R_LARCH_GOT_PCADD_LO12
> R_LARCH_B26
> R_LARCH_GOT_PC_HI20...R_LARCH_GOT_PC_LO12
> R_LARCH_GOT_PCADD_HI20...R_LARCH_GOT_PCADD_LO12
> R_LARCH_SOP_PUSH_PLT_PCREL
>
> https://github.com/loongson/la-abi-specs/blob/release/laelf.adoc
>
> Thus, here is a better way:
>
> ```
> diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/modul=
e.c
> index 7d4d571ee55e..b1452b8adc63 100644
> --- a/arch/loongarch/kernel/module.c
> +++ b/arch/loongarch/kernel/module.c
> @@ -484,6 +484,8 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char
> *strtab,
>          Elf_Addr v;
>          Elf_Sym *sym;
>          Elf_Rela *rel =3D (void *) sechdrs[relsec].sh_addr;
> +       Elf_Shdr *dst_sec =3D sechdrs + sechdrs[relsec].sh_info;
> +       bool is_exec =3D !!(dst_sec->sh_flags & SHF_EXECINSTR);
>
>          pr_debug("%s: Applying relocate section %u to %u\n", __func__,
> relsec,
>                 sechdrs[relsec].sh_info);
> @@ -522,6 +524,14 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const
> char *strtab,
>
>                  v =3D sym->st_value + rel[i].r_addend;
>
> +               /* Skip relocation types that exist exclusively in
> executable sections */
> +               if (!is_exec) {
> +                       err =3D handler(mod, location, v, rela_stack,
> &rela_stack_top, type);
> +                       if (err)
> +                               return err;
> +                       continue;
> +               }
> +
>                  if (type =3D=3D R_LARCH_PCADD_LO12 || type =3D=3D
> R_LARCH_GOT_PCADD_LO12) {
>                          bool found =3D false;
>                          unsigned int j =3D idx;
> ```
>
> For the non-exec sections such as .orc_unwind_ip:
>
> fedora@linux:~/7.2-rc3.git$ objdump -h
> drivers/gpu/drm/amd/amdgpu/amdgpu.ko | grep -A 1 .orc_unwind_ip
>   32 .orc_unwind_ip 000ac104  0000000000000000  0000000000000000
> 18592470  2**0
>                    CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
>
> there are 176193 relocation entries:
>
> fedora@linux:~/7.2-rc3.git$ readelf -rW
> drivers/gpu/drm/amd/amdgpu/amdgpu.o | grep .rela.orc_unwind_ip
> Relocation section '.rela.orc_unwind_ip' at offset 0x3a5321e8 contains
> 176193 entries:
>
> Using the section flag check reduces the operation to a single check for
> massive data sections; otherwise, the loader would have to perform six
> redundant type comparisons across the if-statement and switch-case for
> every single relocation entry.
Please just drop this patch and make the first one better.

Now the first patch has a risk that the distance between .init.text
and .text of the same module exceeds 128MB. I solved it and you can
verify:
https://github.com/chenhuacai/linux/commit/f87f9d82869ebc71dca4c02bdff1cd20=
3913a98f

Huacai
>
> Thanks,
> Tiezhu
>

