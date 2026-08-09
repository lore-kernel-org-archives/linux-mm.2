Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE97C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 04:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151BB6B0107; Sun,  9 Aug 2026 00:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129E76B0109; Sun,  9 Aug 2026 00:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03EA96B010A; Sun,  9 Aug 2026 00:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B07996B0107
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 00:18:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0955D40351
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:18:19 +0000 (UTC)
X-FDA: 85080423918.21.33C4F56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D0DA40003
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:18:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWqR2OoK;
	spf=pass (imf01.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786249097;
	b=cAmTiWbR43H0cLIJzzRLss/Idykf3bIxhthA0Nbnq95Q6lVuzOTH/JTyDA3DEso4gO88ON
	p/HOOTjPyOcUKYYB2vT/Uinbgz3E2sYSL1jiwBWgqIZG+xSc/JX/ncmTpwJOAFF5OnKAUd
	hbCATeXRJ/DEc7fxH5rdy+bFZj6EWKI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWqR2OoK;
	spf=pass (imf01.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786249097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3nl1oGlrcfuCJuGBdIMdIDErS4NCVUDQGrDn8WbrKY=;
	b=qJyOaf41PYdpVbLLvfVKdxWtaWrJTLILRcJaE7T+xHDoBafjXF2cZrBjE2nNSmDCHM7ilB
	GNfr6pDlg+oNhBJkgNHMExpRh/e8EcgGErBsCAIU5jYZuGu/OydOwfB8xjg9sLB1iEPjQD
	qTOrzMTwQoAoXIZmB4IFcjRnTKZ5D7U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 583A4600DA
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A6A1F01558
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786249096;
	bh=j3nl1oGlrcfuCJuGBdIMdIDErS4NCVUDQGrDn8WbrKY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BWqR2OoKgA28BeVh3Tm2EUcOjEZnC39w2oYDR+RumJ0+Zfy9UrFNzlUMMWe6DTogV
	 Wf+sIzEfuyhbUINfv+0VurPDdJG51M2uZWhkBBvaqJ8kwgtV1U7fjfd5HytQtxk++J
	 gBB0qGmAr3XMfYyfSES3OSr3PgNSmBkhzFArQlrCuaLeKQrjm8/7N6n6/dywaNFU8m
	 OFgCa6oc6mUFIs4oRxh/1pEyFqxwCZk10TWBqIurV8I0ZHQb1XBwxoYXgQ+skJjr+G
	 EVcz/4EdA5ZZ0Qwqiw49wfVW+xBjgZuUyjgTeaIUnvn5XGib+ONyHzpMT7C6m7LY1j
	 cftS7HORAGe4A==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a1b51723a9so1237165a12.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 21:18:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpv4l1M6linxhNuN7jDGuRWwFTMMS81FBlDaxcKs1tmvN4Dydl4nZM7cHVg21qqeijs7gfyOhD2Xg==@kvack.org
X-Gm-Message-State: AOJu0YxJKwW7ZF5pi3zEA5Ti03ZJxEYjuFQcR6JNV9tYKdTOdkamZoSQ
	2Vhh83VAoukNtnNpiOOtFIvorjMphSJAMiyDh6GPphGQBNzwhDOE44xgBhV0P9dIEgRneVV0z+5
	Rsg9/ccpreMXZw7WsNLnjeuUj2kUKZAU=
X-Received: by 2002:a05:6402:5d0:b0:6a1:245e:525a with SMTP id
 4fb4d7f45d1cf-6a14f26eb8emr17244030a12.19.1786249094682; Sat, 08 Aug 2026
 21:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-2-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-2-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 9 Aug 2026 12:18:04 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com>
X-Gm-Features: AUfX_mzdXzAu0LbrcSZLHxk0mDTfusrkGeDoTo4UC_Q7T6b0NAW8AH8IYMcYy6c
Message-ID: <CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] efi: add a KHO configuration table GUID
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org, ardb@kernel.org, guodongtai@kylinos.cn, kernel@xen0n.name, 
	graf@amazon.com, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D0DA40003
X-Stat-Signature: 1yejyn4ck7sk6twdq9bx89s6u86ffaso
X-Rspam-User: 
X-HE-Tag: 1786249097-683819
X-HE-Meta: U2FsdGVkX19/5Ya045nrDdVwqSgSvNIBuav0zZCaEN1rRzb2gDKCU0PJpC8INpaQBQdy2YliTzm6rchMC9a40D9RSSE898h1lEaGQiGgI6KlJT61nBJUVFZU+w7/6cOtF7Tb7SWzg+oudzyLaCvqOPgIwKHEAMvq7cogDl5laGDKFoID4l8kmuJbcMs78P+JSZ69A1UAXT4C4xgwrlBtgj0OkbkbGmJ7dE4v6x9QV8gIXDzHu8Qb6DKKY8Z5bAtoSgxXTkgeXXvkRrDBuqLfj7EcQ+Q1IQ9u8vxVPeQuqhYIByy1ULRXSS3O7dfs/5WV3mkHgJxkclJaSaT/YIFn3f3uJufeUvqU9Df/g5Tgv3E5X3qMk2ygjceB/Zs2eJ2deazO5tOOQ0WJEk3PQbL3N5LayNiyJMf6km+50wJuGqT7QgFsYFRdhN/9TjlEmSB+ja1Q1fEUMIokMB6cZXToHj4Y8/ipR7XI22lEWklQpP9wmrorJoKeQL5OgPw+2xCSKhbM0Q4r5zXulH72bjFwGt4CCxqpsacDe1Kyf/8JruxSm8vMqt8meUMlpNqe8gUgweagCUMjtdhFRBTBGmA9ikN+GGQC3NMT+VdG0BSJo80VipGzlgBF7qZExm82hLQwGcT9f+OZTidGjT+dAIF8XVMTRviZVcyh4UvPOxWj7O4Yn7ajye0tTAl9CTceIWB2wP59V/hl3a/LCfY9GrOUbMpz49F8I1cSeW0sT4gA+NFrkOCmcCdlF7ZwdZC5T/zHwjY9gu8S4FVW6mxPpzzceO16huBlX5OC/0cY0e5QpS8h9pA/RakCHljqaYM+o6R9Y2rWoFNZgMccHcYbxfKLV8LzZJMt/Miq2gdYME2mWdQfLR8FdlnQy8eSm5fEdXxJ79txF+HZv7OsCbUYFllP4ySVDmTEEVY6PZKe2NYxO1vEpVR0JkyNpwkjlVyunLKueAoiVcdM6akAkOJKaM1
 F7mgxjl0
 yveR9jnVcjr/iLh5AVeejiGw/mFy3+m2CGPyuVPZ6k+ngGTNHfUfyKGba/JzsKO/qPJfzB3xdmyvV2WCEeprWGMlsTjCLAmM4NMDNQC9Mgi+7NWOStPFjiSV8dJoFHmMa1Slv/LoDmh41LuqtyJuESDlp7z9q/FRUy8CpVm0Md1/8Uvk+Ew8CX6CyzxMphE9C6a7wLVp+e9ufkRVonZmHGxdu2HUsqC6aiIUf8qVs3WhcF2kklL7vjPm+Ei9O3RTZo+hY1lqiugxkZG/QdAjhwH13FMADValQhJwG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, George,

On Fri, Aug 7, 2026 at 6:38=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> Kexec Handover (KHO) passes the address of its state FDT and of its
> scratch area from the current kernel to the next one.  On architectures
> that boot with a device tree, the current kernel writes the
> linux,kho-fdt and linux,kho-scratch properties into /chosen, and the next
> kernel reads them back in early_init_dt_check_kho().
>
> Architectures that boot through EFI without a device tree have no such
> channel.  LoongArch is one of them: its efistub passes the EFI system
> table and the command line to the core kernel directly and never creates
> an FDT.  x86 has the same problem and carries the state out of band
> instead, in a struct kho_data in the setup_data chain of its boot
> protocol.
>
> Add an out-of-band channel for EFI: a LINUX_EFI_KHO_TABLE_GUID
> configuration table entry, under a randomly generated GUID, pointing at a
> struct linux_efi_kho_data.  The
> current kernel loads the structure and an extended configuration table as
> kexec segments, then switches the EFI system table to the new table
> before jumping.  The next kernel finds the entry by GUID and calls
> kho_populate().
>
> The structure carries no version field.  An incompatible change to the
> layout must use a new GUID, which is the usual rule for EFI configuration
> tables.  The handover payload itself is versioned separately, by the
> compatible string of the KHO state FDT that kho_populate() checks.
>
> This patch adds the definitions only.  LoongArch is the first user; any
> other EFI architecture without a boot FDT can use the same channel.
>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  include/linux/efi.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index ccbc35479684..789ab9e4312a 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
>  #define LINUX_EFI_COCO_SECRET_AREA_GUID                EFI_GUID(0xadf956=
ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
>  #define LINUX_EFI_BOOT_MEMMAP_GUID             EFI_GUID(0x800f683f, 0xd0=
8b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID    EFI_GUID(0xd5d1de3c, 0x10=
5c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> +#define LINUX_EFI_KHO_TABLE_GUID               EFI_GUID(0xc941b6c7, 0x7b=
3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
I don't know whether it is allowed to define a new TABLE ID while
doesn't touch the UEFI SPEC.

Huacai

>
>  #define RISCV_EFI_BOOT_PROTOCOL_GUID           EFI_GUID(0xccd15fec, 0x6f=
73, 0x4eec,  0x83, 0x95, 0x3e, 0x69, 0xe4, 0xb9, 0x40, 0xbf)
>
> @@ -1271,6 +1272,29 @@ struct linux_efi_memreserve {
>
>  void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
>
> +/*
> + * The LINUX_EFI_KHO_TABLE_GUID config table points to this structure.  =
It
> + * carries the kexec handover (KHO) state from the current kernel to the=
 next
> + * one: the addresses of the KHO state FDT and of the scratch area.
> + *
> + * This is the handover channel for architectures that boot through EFI =
without
> + * a device tree, where the /chosen linux,kho-fdt and linux,kho-scratch
> + * properties read by early_init_dt_check_kho() are not available.  The =
current
> + * kernel loads the structure and an extended configuration table as kex=
ec
> + * segments; the next kernel finds it by GUID and calls kho_populate().
> + *
> + * The layout is an ABI between the two kernels and is fixed.  It carrie=
s no
> + * version field: an incompatible change must use a new GUID, and the ha=
ndover
> + * payload itself is versioned separately by the compatible string of th=
e KHO
> + * state FDT, which kho_populate() checks.
> + */
> +struct linux_efi_kho_data {
> +       u64 fdt_addr;
> +       u64 fdt_size;
> +       u64 scratch_addr;
> +       u64 scratch_size;
> +} __packed;
> +
>  /*
>   * The LINUX_EFI_MOK_VARIABLE_TABLE_GUID config table can be provided
>   * to the kernel by an EFI boot loader. The table contains a packed
> --
> 2.53.0
>

