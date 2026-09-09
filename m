Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C63C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5CB6B00A0; Wed,  9 Sep 2026 09:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D9A6B00A2; Wed,  9 Sep 2026 09:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CAA76B00A3; Wed,  9 Sep 2026 09:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCA46B00A0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:19:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63FE8C01FF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:19:15 +0000 (UTC)
X-FDA: 85194279870.21.AD5C55C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF4CF18000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:19:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jifU7nYa;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959953;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VF44nhzHiC16881Gb5iN9h+Bgx6pDfvd8nvJKSSNfOA=;
	b=aLkDlOiT5s1v2luNJdocAORxlwENGyFHzoU0SDmaUgoV1o204TVBiiA/Mnd8KVm3UhoPmR
	VBOleseuS2uJPibRuV96d+dsvgklYufTPw8bfrO12JyrbmBmVSwGN31OAPJaiGZABnarHc
	Nc7pxRqHyqmC1z6j9K52Tx20kpAdWT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959953;
	b=Vu9kM6km0zwgZZEhkHlzxstp0xXwM1SHrm39Q2k9TibkX2pJUk9nP6HUN1+yrSqW0OW6jJ
	tb2exPykXuSBTjarxOqp5EnyciIyZQUDBNByi2A2ezSm5Z5a3ndsNWcz7eBgmqcdIu2k+K
	KgLyCmZxj5oVp3TSxYhPNbZvepcC2T0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jifU7nYa;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5134260213;
	Wed,  9 Sep 2026 13:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D361F00A3A;
	Wed,  9 Sep 2026 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959953;
	bh=VF44nhzHiC16881Gb5iN9h+Bgx6pDfvd8nvJKSSNfOA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jifU7nYaAmhEue3ZYS6hL0mgYz8TAE2Dz8MLMyM0RGevIig9ehKh8qykWRHAfYsiA
	 z1r8vfttWhtJrvznAsmQdAhsI/5V6KgHMyMbZ/wH2+uJ2FV0zXLba5O84c8wX2KyOO
	 Q7Y3zuCqdn+GB6I4hS8XN9KVqJgl7OnRW79NXrj2KrVp4RyTXQ6ceX9oCDWI52ZRyt
	 HhNRMTB96EMZ47gBlPlLYwLjBDhkZTbdV5P4lhJsbs6/6bxgnjoFay7J0A1QF71p1D
	 Sb7KNx7hgZzzTIj/pbNoW+dmFMMwYtT6Bn3s5MjKIaX6Szh+RRcbCsIuBuHJbes2yo
	 FFL2fdsv3bxnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Breno Leitao" <leitao@debian.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Ingo Molnar" <mingo@redhat.com>, "Zi
 Yan" <ziy@nvidia.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "H. Peter Anvin" <hpa@zytor.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb@kernel.org>, kas@kernel.org, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Liam R. Howlett" <liam@infradead.org>, x86@kernel.org, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: harry@kernel.org, linux-efi@vger.kernel.org, riel@surriel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, rmikey@meta.com, kernel-team@meta.com
In-Reply-To: <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:19:11 +0000
Message-Id: <20260909131911.76D361F00A3A@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3hs3gzn1n16n9rreuopebmcdukz9f787
X-Rspamd-Queue-Id: AF4CF18000D
X-HE-Tag: 1788959953-79277
X-HE-Meta: U2FsdGVkX1/pyHd0YKsV/+kidW07ytUf14fQfe15vmd+vf0pKFTLCVG/o3mLoExmgCIVvnS+zMY2ns7Dhc0bD8qjQNGzQQgULRAikd+3su1GRPeazE+zCdcXjbjRBA5J1fsxzTepdlmLqh+45FagSnme1Zhrrc2+8H1vXBBR48decZXrhbwaX2UtIMLp8cktX9UTq9u/D1mG9G/ZIJsAehEo0hE+KagOoWDo06G1KzOXTJEfjT+y+np9UnRutnYux5r9SihATxYu9yKLWM0GsFzSuBD2IBmS0e7bJrHwYhq7fxBNZHd2BwwmVjKU1as9V7rG+1SfpOxRFbOlSkoimGF01OwnBtCZK39N8jeQ66gdlnwZzpHZnLZJaDtFuwcgmFBok4GuhTQtD0mbYQPNoYEAubYNDlQ3Cf72MPU0aJ2eALHSzY21e3EsVu33uwoonb7t6U043EE3i2g/m3Oz3t7EZWoSIn0kc/q1sU4nZqE54XvSSxiwNs0XkRT9U2aD5KbEzldwsaJOeLsMQJW8irb+DnioXUq9qEmPkUjOOoTzW+ddQgEAVVsDp4n2yxRJ86yoqWqf81oonkVTGL0yP+AR7X9+O1vznvlt5c8lBPWzH2gEfh+zqiA4rUdhr3JlUKyt5xmIcjJhmUVd7h7dZS+0MJjExHlNfo8ISfNVqOihNfgQYQ9Vj7pT5Ue7c/d+wSjd7pYvF/pPTY5GcJuWGL0D2z35b35FirOFnmFtSQe7XpPMUhCyf85dgNUvEaTyfrjBK7Ix2PdvXPyl1PrWe2K+8c+42w8VWcUruWikA1Utv9dlaf03aphyqLpiSjVwUJxdlCebC7QmyLFa1gt9FDHQZUh+rSYTFFEoLPiQd5CVfvgjVcCJUusek+rpcmBWslwNOGPoOBrYMc5We8UAli+sK+GXPusbhPI4MuaT/Ty1HjGV859cC++otqvBFENIdvvhmsqxRFCJip1h2cG
 y3+MeZPX
 CUxsRcpnnPKsx4mpqDDmN1xpyHuj0qp1cZ7pf+QvGxDz7dO7uTa218e/DYHOQOwMYUk6vNKeFXxtqHsAtQ9+WLCOzvbG1mXau/Izzz/WkGmPci9a/WV6NmXuFLBqUUaFwZaw9jxXUZgOA6lhLdY6O25oyS9LR3M1wJcC4skFkdf/ZyOYxrrpeyLVK/jDsW0IOFrfSd9Sa0pzktUpfBUNJiircXVl6IVGOBDlO+g535zVvJnAx1JjGOOTcn0ppfREaUJxTBurZXynQj57UjPxz3dIJxwAKAONPIx2JxS67wc+umjh71ZoJUDAZ55erfjwqOE+bQaOa5vet5YvabJiXfug512WSOcKvB4IH5wy3QxmOscsBXMB3678io5sChftK2JJXRKiMh20WVtr99fxzIjH3JH+9AymCxwSqGJu1HYKQtPJGh4zFG3opf0Se9gHq2qFPz4Pr0/XpB8QE9mXFAaKdJSViDqXLRt5KXfyW9r4s8iMu3V/IyZGc5pRW1lVe4kGlkvO16o4BmAOnpNcbRvAHvT8NMDOys8Uw3DCVSgmXR+FQ1XBq3KyH301aYptC6UHkR6bwZwDMGA6OlTrWaq5cLDEmoP6iQBACXRjMrELx1TuDhKgNCNqQIuQ/f2RjZ4cM9lp7EjrqOUrTM+7H4A4PhYFke05lL03X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Integer truncation in efi_poison_alloc leads to a massive heap=
 buffer overflow during memset on 32-bit or mixed-mode systems.
--

commit 626632820fe1fdcddc73aaeb109705cbddc9828c
Author: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: libstub: install the poisoned-memory EFI table

This patch introduces functionality in the EFI stub to create and install a
poisoned-memory EFI configuration table. It walks the UEFI memory map to fi=
nd
the RAM range and allocates a bitmap to track poisoned memory granules.

> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/fir=
mware/efi/libstub/efi-stub-helper.c
> index 48f93f7758e9e..5cbe675491333 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
[ ... ]
> +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> +							  u64 bitmap_size)
> +{
> +	struct linux_efi_poisoned_memory *pm;
> +	efi_status_t status;
> +
> +	status =3D efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> +			     sizeof(*pm) + bitmap_size, (void **)&pm);

[Severity: Critical]
Could sizeof(*pm) + bitmap_size overflow 32 bits on 32-bit or mixed-mode
systems? If the EFI memory map describes a very large physical address space
(such as a 32PB physical address provided by an untrusted hypervisor in a
TDX/SEV environment), bitmap_size could approach 4GB.

Because the size argument to allocate_pool is a UINTN, a value like
0x100000008 (sizeof(*pm) + 0xFFFFFFF0) would truncate to 8 bytes on 32-bit
EFI systems, resulting in an undersized allocation.

> +	if (status !=3D EFI_SUCCESS)
> +		return NULL;
> +
> +	pm->version =3D 1;
> +	pm->unit_size =3D EFI_POISON_UNIT_SIZE;
> +	pm->phys_base =3D phys_base;
> +	pm->size =3D bitmap_size;
> +	memset(pm->bitmap, 0, bitmap_size);

[Severity: Critical]
If the allocate_pool calculation overflowed and truncated as described abov=
e,
does this memset trigger an out-of-bounds write regression?

Since bitmap_size (e.g., 0xFFFFFFF0) fits within a 32-bit size_t, memset
will use the large untruncated size, potentially overwriting up to 4GB of E=
FI
boot services memory following the undersized allocation.

> +
> +	return pm;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D2

