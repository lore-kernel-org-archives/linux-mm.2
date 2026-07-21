Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A53C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 04:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399D56B008A; Tue, 21 Jul 2026 00:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323B06B008C; Tue, 21 Jul 2026 00:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE3C6B0092; Tue, 21 Jul 2026 00:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD0896B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:57:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DC15A03EB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:57:02 +0000 (UTC)
X-FDA: 85011574284.09.28CCCE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 66FF620006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:57:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0rnIU6k;
	spf=pass (imf13.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784609820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMvV8zHJ0YWHZpZGjoLFxMf7FQLHmiNjNa68W8trvtc=;
	b=EoLi1PeDZEoyQetxsPlPn0dfbSF/HKOQLzzD1OkjJZSU0UhKC5/0rgRkB/F8NgpHmMicGD
	Cx1hdnwfyJkvVwSzTGf1WyQXKQFzW3rgxpBTttKti5yEC4DjqXc7Dl8BBDyGkOb8XR29jt
	8WDeEOX+g5PZZnwIWWmY12fjnmWFWuc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784609820;
	b=XZh/6oZg7wYWu/mHbMTpgXb51GjNYfeLSatDAKtktQbI+xyzUp182uBqT/aWhtOTN97B+U
	hy8wb3GVlla44C9ucrEuuVllcb/ra2ozXsjLMNopBEJpHOSy0R1wl1wpMaPSTXwWh8v+AL
	xkjAdKwknnNB4FieAneo/PneQXSbQ68=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0rnIU6k;
	spf=pass (imf13.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD6BD60A7C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780C01F00A3E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784609819;
	bh=RMvV8zHJ0YWHZpZGjoLFxMf7FQLHmiNjNa68W8trvtc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=D0rnIU6k/uzIevZydGbdnTO56J2zR9h2KH3xByy0JssQKCjXpCCY7mOxkUIsuUbXe
	 ROpeyFVUQET291WIy3gA+hXM8bz1hwEkEB1xIPm8z0Lm5p1mv0q3DLqyGC59yhyade
	 URjhQ1GqOWps/o0gOTZAeBSqaAyjeATVb7bndZvJ2Jc2UB3kE85XeR6t6xIDGAtkv3
	 FPVqIjcTiZcKcCfzmGytNCKqTttPSpoDa0jNsG4RgY3DDbSGrCu0XeMXcPpAN52PHl
	 VNfjLuuP04v1VBaDQnotE0tLFDjJtyn/IyHvRrH2MV+86CZdh015sf61fNbPBaSt07
	 6CtWFdyem1Wyw==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-69c1220bd51so12528499a12.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:56:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr21j/GXXBM5u6Ghw6ZJVMRTZ0/9pu2bNYDK1wrGGz8lAbXasy+eZX9osxMsyrrb4AxVjnYm3N6Eg==@kvack.org
X-Gm-Message-State: AOJu0Yxn5CtrT7eHjtAbSuYgN72y0URuRXoId5pnItRUf1YmwF3uwpg5
	uBK6nZWy3wJGwcRnh5wavQIdLxkmFxPrOR5m9p7gBKq9Cffmz8uW5XetiyA7TXsU+37XJKJeJIs
	1LkhkWc9s+obhE/Jjcal/3h0AbG9moxQ=
X-Received: by 2002:a05:6402:5286:b0:698:ade9:757f with SMTP id
 4fb4d7f45d1cf-69e652e0c81mr6223233a12.19.1784609818044; Mon, 20 Jul 2026
 21:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260717075715.25513-1-yangtiezhu@loongson.cn>
 <20260717075715.25513-3-yangtiezhu@loongson.cn> <alySgaaQen6ZtwSo@kernel.org>
 <ba8b2723b563cd290c5c00fb4ec2402626fba06c.camel@xry111.site> <38d130e6-7036-e296-e058-433c8ba7a265@loongson.cn>
In-Reply-To: <38d130e6-7036-e296-e058-433c8ba7a265@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 21 Jul 2026 12:56:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4huLS_G+TMDKZ5sFwFH9BJsQbQeADtyH3CSnkHirCnaw@mail.gmail.com>
X-Gm-Features: AUfX_mzM6qRkuX0HyFLmmwRdjcJKwGwcwAnFR5p5zb2EUUQxAoEkjSBvo-LZGaI
Message-ID: <CAAhV-H4huLS_G+TMDKZ5sFwFH9BJsQbQeADtyH3CSnkHirCnaw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] LoongArch: mm: Expand modules virtual address
 space to 2GB
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Xi Ruoyao <xry111@xry111.site>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 66FF620006
X-Stat-Signature: 96ssbwo8b1z8wsmdc9hfahixb1cw7oqu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784609820-780098
X-HE-Meta: U2FsdGVkX18YpBM75Mp2aTJFCPOTfXJXGOqECLPM4M4Ao3JiXdtHAsj4Q5TO2Fno5DVoKwNR8YDCHLqrzSHW1O8UKDVlRfCwgZeAkTSQ+JQRSHouPvCAwnPKXdVvEzA9MZjvzilnddJlpAyUwzQGSsjKwLidgFvgeeGkuPgg2JgaozAm+FPM9er70LShgn1WJaHWC53CYJz93IAsvnxJS8ohd4N+H6V2hy1FyYG+oimqo7uQGexm9pmloSYDBmUyzsZ+nC7OCbNbNfi688+RCTTRBI3R/i7Vn5udAfG9UXPpq/Q7Al2D7pzqnyEkedFONdPnExSm3QS5uZWO5Wg9S539UNamtwA7Ks/QET51Nv/C6NPwPr333LN4+YqbN5KnrPpPf8OqlMQ7kZgcAe/K8JNOF0W1XrEsoSucqP/f3DFGD7SBRawpLFoSxBOZuhA24YiBqKUtvJoLfOv4RfaOFHFWAiCzC5oyOVaOZKPKT6CrZG1WPuTNVNjl8KzfgwdW8jMASPE5IY6St97/AhwOt31VjKzMH3ubyW4AkPgfEX5jyEZ3acJFhD+aPp2jKj/kUaw0D9NQQMOwPJglZ/izoSRBycpX1yT/XEZD8Cyc6K9sJ0csNcc3Uey1kpy/Jsg9oXaYN+QtNBlEKkQ7S7VC/pkjtdoHB8egXBPtw6Gn8RzLGggRf9AcfTgjiPWhn5gesTz7jNfmMdGwp05qFSdF0gSnBDI+4NDYJ05pYPyvitwfL/xmtCw/zEqO5QlxZBkTAjbzQOBwkro17DY4XY2mY26veMRfUYzLIWVN43/S+WRG8wx4CcUD9pS4r9wJ23Mg3Um1MXuyNZRU76AtlFurVSHapO+J5VJSpnhuPN4Upi8BR4MfBWVTg1nslYXkPg1IGu3LCEPuT8Yskrmv+2B1v16MsO9m6NweRzOJkkPP1nY6mrz+Je1F2LA7wRf68FbHZfqj5aMpNV1ySJQQ/iX
 hCWXzT6Q
 qwy63wsYGHpFNyarkonF36Ovy2xsJC4ot6rDJZins7CKS2U03zzuPOprcyZ0+3zXiC5vRYtJCudN8ec3TrwxU12gUPlKH0dRIszro6pr1KMD7/XybwM070Fxo0gY47K0D3h49OFI65V2Zor5UyYCutwNAGelU1ML70BCrawkKkM02KXo0ncSlLf0e+MGhlQkCPFEhha8jcEYTA57mSkFK93x14d4L1/YqMXKRUjzlmvCflSVpQunWbu3U6LpJgNfV8ZkEJc4aFlTCCKQzMQcvi6vHGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 6:40=E2=80=AFPM Tiezhu Yang <yangtiezhu@loongson.cn=
> wrote:
>
> On 2026/7/19 =E4=B8=8B=E5=8D=8811:28, Xi Ruoyao wrote:
> > On Sun, 2026-07-19 at 12:01 +0300, Mike Rapoport wrote:
> >> On Fri, Jul 17, 2026 at 03:57:15PM +0800, Tiezhu Yang wrote:
> >>> Frequent "execmem: unable to allocate memory" warnings are observed
> >>> during kernel module loading when updating the latest kernel.
> >>>
> >>> This is because the modules virtual address region on LoongArch is
> >>> tightly constrained to 256MB, while ARM64 and RISC-V are natively
> >>> configured with a spacious 2GB region.
> >>
> >> The constraint follows architecture ability to address kernel instruct=
ions
> >> and data from modules code.
> >>
> >> I don't know what are loongarch requirements, but I remember that arm6=
4
> >> added a layer of relocation support to allow 2G module address space.
> >
> > IIUC on LoongArch the size of one module is limited to 256MB, but the
> > total size of modules can be up to 2GB, as the module loader creates PL=
T
> > entries for calls across the module boundary.
Unfortunately, the one module size also limits the MODULE REGION size,
we have observed that the distance between .init.text and .text of the
same module is too large and the module loader prints an error.

Huacai

> >
> > I'd seen the "execmem: unable to allocate memory" error loading the
> > large amdgpu module.  But after I stripped the amdgpu module those
> > warnings gone away.  To me this is very strange: shouldn't the module
> > loader just ignore the debug info even if it's not stripped instead of
> > requesting execmem for it???
>
> I did the following changes based on the original 7.2-rc4 for debugging:
>
> ```
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index 46dd8d25a605..5eab1ab8b195 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2972,7 +2972,6 @@ static struct module *layout_and_allocate(struct
> load_info *info, int flags)
>           * special cases for the architectures.
>           */
>          layout_sections(info->mod, info);
> -       layout_symtab(info->mod, info);
>
>          /* Allocate and move to the final place */
>          err =3D move_module(info->mod, info);
> @@ -3013,9 +3012,6 @@ static int post_relocation(struct module *mod,
> const struct load_info *info)
>          percpu_modcopy(mod, (void
> *)info->sechdrs[info->index.pcpu].sh_addr,
>                         info->sechdrs[info->index.pcpu].sh_size);
>
> -       /* Setup kallsyms-specific fields. */
> -       add_kallsyms(mod, info);
> -
>          /* Arch-specific module finalizing. */
>          return module_finalize(info->hdr, info->sechdrs, mod);
>   }
> ```
>
> With this diff, the "execmem: unable to allocate memory" warnings disappe=
ar
> completely:
>
> fedora@linux:~/7.2-rc4.git$ dmesg -t | grep "execmem:"
> fedora@linux:~/7.2-rc4.git$ readelf -S
> drivers/gpu/drm/amd/amdgpu/amdgpu.ko | grep -A 1 -E "debug_info|symtab"
>    [23] .debug_info       PROGBITS         0000000000000000  00b73fa9
>         000000000bfde1bc  0000000000000000           0     0     1
>    [24] .rela.debug_info  RELA             0000000000000000  280f2e40
>         0000000011f754a8  0000000000000018   I      75    23     8
> --
>    [75] .symtab           SYMTAB           0000000000000000  18934e78
>         000000000f1a0dd8  0000000000000018          76   10548226     8
>
> This test proves that the "execmem: unable to allocate memory" warning is
> entirely triggered by the massive unstripped .symtab section (~241.63 MB)
> rather than the debug sections themselves.
>
> As the readelf data shows, the ~500MB debug sections remain fully present
> in the static file, yet the memory allocation succeeds without any errors=
.
>
> This confirms that the generic loader successfully ignores non-SHF_ALLOC
> sections during layout_sections().
>
> However, layout_symtab() must put the massive .symtab into memory to
> support kallsyms and oops backtraces. Combined with the driver core code,
> the total memory request reaches ~252.86 MB. This immediately triggers
> allocation failures because 252.86 MB is too close to the narrow 256MB
> limit on LoongArch, especially when virtual memory fragmentation exists.
>
> We cannot strip modules or remove layout_symtab() because we need
> backtrace symbols for debugging. Therefore, the ~252MB memory demand is
> a hard requirement, and expanding MODULES_END to 2GB is necessary for
> large modern drivers on LoongArch.
>
> Thanks,
> Tiezhu
>

