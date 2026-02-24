Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3A3EFB7FD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82B66B0089; Tue, 24 Feb 2026 00:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C407C6B008A; Tue, 24 Feb 2026 00:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97B46B008C; Tue, 24 Feb 2026 00:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18826B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:56:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 443E5C1C2F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:56:28 +0000 (UTC)
X-FDA: 84478290456.04.F53EFBC
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2944140008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:56:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771912586; a=rsa-sha256;
	cv=none;
	b=JhHv9t/ig7sqqTIwhcFnmtGB7bIAY+Ti28gAS0bepIT9E02cXp4meVa57zUfH5K9R6FPaK
	0dGqB6IECLbJ7vWBvvBEIGkI9yJycsehEwbe7VsQsOtcL8iKFYFGj9cXW0Cp58G3rLKBqQ
	w0QEKJO9nPkZWdkcRvPNJ3rjm4h6HsM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771912586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wDBCpnI5KoYz2BOoYnai+wDvgL2J+wvlH93qJ4Liqh8=;
	b=tVhBNuuAHhLgQLvYUaA4WFpqsXqTfw4NtTbjehMGEYO1eVRVpjZACVdDMXmON8rqcjPeaJ
	rY0yIv3G81m80DKYcOoccEhvuqYKh3NPL19VNw63Io86kkaZR7DehDK9h/HbEt1LwAvHEQ
	+MHRQB6kRhjunymYshcYRhbC3+Heat8=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61O5uCfa945109;
	Mon, 23 Feb 2026 23:56:12 -0600
Message-ID: <4093878f7fc5ad08a91aef981165860276dc92fa.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Tue, 24 Feb 2026 16:56:11 +1100
In-Reply-To: <aZgkrVWmcz_mcn6b@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
	 <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
	 <1ef0f899dd03928651d2e07cff14e062be25d5cd.camel@kernel.crashing.org>
	 <aZgkrVWmcz_mcn6b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Stat-Signature: fxkzewg3ed4ph6otxnbkb433edgwsrce
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D2944140008
X-HE-Tag: 1771912584-33249
X-HE-Meta: U2FsdGVkX1/4RtGoCWufHqHed3LMjZr4XSRfia/Y8t1L2b/ZFg5r+H5bn/6QPpHNTSV8lJZfeedUX/JE8AHkY00b48/qt8FNwPWXkzkT055MUIgTUSYoT84qmuevzK/i3D8fNCPljN0HoIAJMVJoC4sFqP54tnvSYiYmsj6S1osw1k+nqPCgdRg66W6ylnsULQgnSu/urMn3ayYGUKTj3EYsrYN/gmZ/4mowbFhR9jlMYHbEMNnQnrrbY/SRhSCoOfoFLCMAvFl7n5ooUDUNfsLhznb0xKYAwG3MTCBC8nY2PqSXly442kdIDeLK6WN74z+5xesSy6mKEQE2jktJ/k38BgN1MGL6Dumlznh6sryI3Wmsnvn8HIkYnKHcYWDTw04tDseBWKrRZRwZ7XvOkvHka4hyIiMPFHEzgSvStiFlbMwZbZAIeG3mfDE6hg892yTeZ6F0lNOXDVwu45H3aZ5NGtb4z6F5enmiQAoYZjemWgClm2cKNYWlb6ckDB1idwCMauMSmVmIno6+TNX7d+0APq1FzO/NkTp9i3V30xgNol3umoeKOF/HczL7D/sMVlqFHdOEfDkTsU20AaSld1Z2jdtDE/SNKZATbyD+LEPokx7CKp3YAWHTIP0HpsKgY1JUUTyBAjtr81hqywnkzvzvdYF4NvKOJIQ+PG3p0LRPl22m4DVEt/l+7qBlLef7Ut2nAH5nC98vB27+UJsnN8LtAk7qUsLc9x1kK5QkwHF9U7WKv26Pl9kMenPuYEHJKeovbqvLhrv670/ifMDjUSXGyN27bNuDUIS2BEwIsM1DmtGFxgnIzHuMrSLJMC59/tsw+1FHXJfdQ7FRbyZe9jWGF0cKKCg4Ic+i/OMw0+dom/Yf/pIKOc8Z4hj31w90coCy3Ilvrm97rxAmZCeWRbeXw5Sr7hg7BDt0SIDlfqBb2znn38Z3ani8UnIIr9cZbx3kxn2bnQXDiWhSPXk
 TYNjCHFA
 swWAMAf3XQEJ4dB2j6BYxqKCwr4MAMhOAFuvcbXHs9v5Y7RVLIFomRl9mK6aVIjRsNQ3dfmMg0L3Gb9v9+Nk1028OWDpuYm9suRew42svy2ELES7hHsRI8TfIgDnCYgIGYta0Q9ssgp2We46jBnpVl7NOwCefsTAHtAvsRZm/F+mIBwpveLIWCXIOIJ0WamsIrj+lKXPEEpWe+3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-02-20 at 11:09 +0200, Mike Rapoport wrote:
>=20
>=20
> Subject: [PATCH] x86/efi: defer freeing of boot services memory
>=20
> ...
>=20
> Make efi_free_boot_services() collect ranges that should be freed into
       ^^^^^^^^^^^^^^^^^^^^^^^

Reword "split efi_free_boot_services() in two. First
efi_unmap_boot_services() collects ..... then efi_free_boot_services()
later frees them after deferred init is complete."

IE. Your commit message still has the old names :)


That's my only comment.

Reviewed-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Link: https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12=
a.camel@kernel.crashing.org
> Fixes: 916f676f8dc0 ("x86, efi: Retain boot service code until after swit=
ching to virtual mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> =C2=A0arch/x86/include/asm/efi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/x86/platform/efi/efi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/x86/platform/efi/quirks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 55 +=
++++++++++++++++++++++++++--
> =C2=A0drivers/firmware/efi/mokvar-table.c |=C2=A0 2 +-
> =C2=A04 files changed, 55 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index f227a70ac91f..51b4cdbea061 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -138,7 +138,7 @@ extern void __init efi_apply_memmap_quirks(void);
> =C2=A0extern int __init efi_reuse_config(u64 tables, int nr_tables);
> =C2=A0extern void efi_delete_dummy_variable(void);
> =C2=A0extern void efi_crash_gracefully_on_page_fault(unsigned long phys_a=
ddr);
> -extern void efi_free_boot_services(void);
> +extern void efi_unmap_boot_services(void);
> =C2=A0
> =C2=A0void arch_efi_call_virt_setup(void);
> =C2=A0void arch_efi_call_virt_teardown(void);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 463b784499a8..791c52c8393f 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -837,7 +837,7 @@ static void __init __efi_enter_virtual_mode(void)
> =C2=A0	}
> =C2=A0
> =C2=A0	efi_check_for_embedded_firmwares();
> -	efi_free_boot_services();
> +	efi_unmap_boot_services();
> =C2=A0
> =C2=A0	if (!efi_is_mixed())
> =C2=A0		efi_native_runtime_setup();
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirk=
s.c
> index 553f330198f2..35caa5746115 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -341,7 +341,7 @@ void __init efi_reserve_boot_services(void)
> =C2=A0
> =C2=A0		/*
> =C2=A0		 * Because the following memblock_reserve() is paired
> -		 * with memblock_free_late() for this region in
> +		 * with free_reserved_area() for this region in
> =C2=A0		 * efi_free_boot_services(), we must be extremely
> =C2=A0		 * careful not to reserve, and subsequently free,
> =C2=A0		 * critical regions of memory (like the kernel image) or
> @@ -404,17 +404,33 @@ static void __init efi_unmap_pages(efi_memory_desc_=
t *md)
> =C2=A0		pr_err("Failed to unmap VA mapping for 0x%llx\n", va);
> =C2=A0}
> =C2=A0
> -void __init efi_free_boot_services(void)
> +struct efi_freeable_range {
> +	u64 start;
> +	u64 end;
> +};
> +
> +static struct efi_freeable_range *ranges_to_free;
> +
> +void __init efi_unmap_boot_services(void)
> =C2=A0{
> =C2=A0	struct efi_memory_map_data data =3D { 0 };
> =C2=A0	efi_memory_desc_t *md;
> =C2=A0	int num_entries =3D 0;
> +	int idx =3D 0;
> +	size_t sz;
> =C2=A0	void *new, *new_md;
> =C2=A0
> =C2=A0	/* Keep all regions for /sys/kernel/debug/efi */
> =C2=A0	if (efi_enabled(EFI_DBG))
> =C2=A0		return;
> =C2=A0
> +	sz =3D sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> +	ranges_to_free =3D kzalloc(sz, GFP_KERNEL);
> +	if (!ranges_to_free) {
> +		pr_err("Failed to allocate storage for freeable EFI regions\n");
> +		return;
> +	}
> +
> =C2=A0	for_each_efi_memory_desc(md) {
> =C2=A0		unsigned long long start =3D md->phys_addr;
> =C2=A0		unsigned long long size =3D md->num_pages << EFI_PAGE_SHIFT;
> @@ -471,7 +487,15 @@ void __init efi_free_boot_services(void)


