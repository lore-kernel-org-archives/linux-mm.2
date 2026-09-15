Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376EFC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0C46B0095; Tue, 15 Sep 2026 09:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2B46B0096; Tue, 15 Sep 2026 09:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D256B0098; Tue, 15 Sep 2026 09:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01D9D6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:36:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C381803E5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:36:34 +0000 (UTC)
X-FDA: 85216096308.28.326D653
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4A77BC000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:36:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZqVJGAm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZqVJGAm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789479392;
	b=zxS4SpqYnR98rmVb/2uCpcR/LFkIAzR1PHsCWQRuXzYCDTw6qB8DPIaWwmAHGWVDyTcjqo
	+1B9GErlxN3FnH78H1V18CkiBY9JMysXYPUbydmhKvAH2uGD/SU3zu0/0s54qWXqFTwH0m
	vK5ZqkHM2bdMigbhv2vEh+oF6p68dqo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789479392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD1C1sFiLo886bWFCF4yCVjFbhAC5ORHunqhsih89BI=;
	b=ugt5bZSRoCvOCy2bO2SXZ4qSgl5amXHj6D8nkzE0LNlUjWVt1aApjzXEsmCUmlV/t+OA7y
	qPhsT/oOJCCBNvOpId4On1xXBGyp1b8ayYaCXv3ySRyEKjtN7MFVY8s/veMUq9itq78FOE
	EN2hiUM3Lx+q+R8ghN6zcVMzI6pu2A8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78072400FD;
	Tue, 15 Sep 2026 13:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700EE1F000FF;
	Tue, 15 Sep 2026 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479391;
	bh=UD1C1sFiLo886bWFCF4yCVjFbhAC5ORHunqhsih89BI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SZqVJGAm8yvcnbN40xI+hqlsdqMDLkdt+phXQtPX68AzkVtujfWWbbiGfXbUa2Uym
	 GVn/Nt/2dfvQsCKfCKY5JX4TDRFYeUywiiZtEQoSyMDnNFAB58WVP3gyPlYfr2gLzW
	 46i7sA6/3GwFqCAkXxGegqIiREYKDnXnFYbG1IWUedOQs3dlPwWKAIFvt88csCqqJB
	 JhrYK8GNSnhKAnI3Vd7VcyfPulYz/1mfzI61CW6idvYDRk1L0h0bM3cgCGE/lu9XqC
	 I0p1GADYpzRWQgYCXbBM6PXsUZCYGyyJPl+mIfv7Aztx0DqxKRTslvqj0jpq9mMRRc
	 5Y/PrfNGoeEZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/9] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, kas@kernel.org, "Zi
 Yan" <ziy@nvidia.com>, "Breno Leitao" <leitao@debian.org>, hannes@cmpxchg.or, shakeel.butt@linux.dev, "Liam
 R. Howlett" <liam@infradead.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, x86@kernel.org, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Danilo Krummrich" <dakr@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Oscar
 Salvador" <osalvador@suse.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: kernel-team@meta.com, kexec@lists.infradead.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, driver-core@lists.linux.dev, riel@surriel.com, harry@kernel.org
In-Reply-To: <20260915-hwpoison-kho-v5-5-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-5-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:36:29 +0000
Message-Id: <20260915133629.700EE1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A77BC000E
X-Stat-Signature: ctnfzagshum8jjn11x4ygpj4dns5cgrx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789479392-550392
X-HE-Meta: U2FsdGVkX1+fjUXzNqdz+gnJ3/WGiB+q8/Xy/VLu1Rg8KxPRyAeTII1Xw0mFSDKsC6UWBQX80T29MzDEm4DdjgGDjosZq5HYR1kBxxx57Xf3zMNgE0kAr1Pw9YKJksEb1xMJoibm/kJsdTMFx4qediI2SL1A2WLCxo48GktbikI9OQt7PkGPtgYNIJ0tpzebvuGulvF8GXWX7vJa6dAC9IzZ4f3tOvHAF8hdwdWQ5iY7nsnLYA2WH7CtMnuF1bBIqvvHt6IipY2s0VA01j4ccGUkb1FXuvO+sjyGrj4qoC8QignP9Qhd8YTj2pkQWOFWGBWjtIspuPM3hHG49dypZzD9Z8/L1dq/ULkNnJrm32d7lMJvVTl+TjQ1RUAyJzpsmNg2psIi0BIg+d/ekQ5IN6SHh0v/OrpwrSKl5H2E6yY6v+Vi/Mf/x/Lbj+rISBPZaosJaSBqWHViHBsTN0WMtwatQ/Ctqn0NZOTYPlTLJI3iO18hCcWWNMngH+zsLSO3N091jLV25+kM7HSBsW5A51jrlvMI19lSTPbGAzvnm0ZDZau7fKWH9sACa8h2Y8RpYBGm93Ca3NiE1RZW+7AnxHqBexbyV8vC1LJNbpwuZOybUv3ynx4OQ4OntVg+plpVXVdL2FacfoTGweqhwv0Lg8g9+Aa7aVCvQkRI4CuQc9Ov+WttJMYrZNUdgS0JbbI9dSJ0+slH1FXadq0Pj45sV+vwThu+CdZjxsRBp2fLlzwll8TS1O8ARpB8rAU4u2UZZEefkyGQWtzACvloSo4gszWkGEnhCHzR41lEZR482HuogeNE1vVH6SsycOPRj28Ai4vlXtfcfMcm/MualIqI/q98HBTBmcJv/xHUuMGf49uB34hGgxuuHpFNJjmRpKQyhg+V1a3BqmZWSBL1uzHbzfgzr1Nte0TUNggVVbkoe9M9ES0TpaeOU2CPDNdngmhRRunhZ1cMKu7Hi9I0orc
 8oBFnJZW
 knlmba0eFJKjvdtuZ1FleRPSqqUVwsFSO5zLoHv/zaG+EFEJwMa+43pFk4eYNIYL0ZnbZ/qPQGE1HQ/nsLVi07EWnyY+CbTslep7r5R9F+b6hKdjEtkC2hObGMnbl5tZ3nv4nMBBM1ONzy0m23naboMxEsNMx2+SSEeCABsu/Pcy921Kikqt6QXzgF+SNerPM1iQbU5GX0smLSwk0NiRyQ/0kUbYFsoYFJoECgXNIFDjHGoJC31Wr/XbQLiw10Oug4Xdfo2K7s1+bHiXhzRx6Lu87M9IwYRQhVnkXJ1XOdJLy89kaI4LIDeHsVN1uYXT24VbYUHr43MV+WoEccDLSYafk6Z7w77t5bP2hYyTjNSfxbTkHeiooxTGrlsS0RrYJtGuc9ZIcfNavmd45+XDO3MeeKbv+CbUBnYu82rCPNBjeBSp5I4uT7y1NwEKRFp2D8a6UId1In1gonvWV+DYX5l6XlyY1yTdtT/1BDzu70sgU44a1z1pApHNzGlRxIW7k9rbbTm6a/7n7GcKNpvo5aXLmR4yezkvneSl5XsEZmfnKXohWDNJM/+piznHl47zG5seOyE22P79qepxQHuFgUgbQ3OSwHjiBHpRuuo6ZAoef2G+yLvS3AC9mlncddgmHjoIX1RU9TywoV8OioFS4iPlANiEnEgVT/uSCXiCLfKjLnaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] efi: memblock_add() with PAGE_ALIGN_DOWN forces adjacent MMIO =
into system RAM
- [High] efi: ABI breakage in linux_efi_poisoned_memory due to native word =
size
- [Medium] mm: hard memory failures on soft-offlined pages are omitted from=
 EFI table
--

commit e69689c81050c18119d69206dc9a7cb1e2fa4eeb
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-m=
emory table

This commit hooks memory_failure() hard offline reports into the EFI
poisoned memory table so that they persist across kexec. Soft-offlined
pages are deliberately excluded to prevent predictive offlining from
becoming a permanent loss.

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> index 3f12db3dc9b84..847592862f01d 100644
> --- a/drivers/firmware/efi/poison.c
> +++ b/drivers/firmware/efi/poison.c
> @@ -91,3 +91,30 @@ void __init efi_poisoned_memory_reserve(void)
>  	memblock_add(start, end - start);
>  	memblock_reserve(start, end - start);

[Severity: Critical]
Does this forcefully override the firmware's memory map for adjacent 4KB
chunks on larger page architectures?=20

On architectures like ARM64 where the kernel page size can be 16KB or
64KB, EFI memory descriptors remain 4KB. If the EFI poisoned memory table
occupies a 4KB region within a 64KB page, rounding down to the kernel
page boundary expands the range.

This could force adjacent 4KB EFI regions containing firmware MMIO or
reserved non-RAM regions into system RAM via memblock_add(). If the
kernel later maps these regions with Write-Back caching attributes in the
direct map, could this cause fatal Machine Check Exceptions or SError
panics during speculative CPU accesses?

[ ... ]

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index dd3263456dd4a..56402fdccd114 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1288,8 +1288,10 @@ struct linux_efi_poisoned_memory {

[Severity: High]
Does the linux_efi_poisoned_memory ABI structure break on architectures
where the native word size differs from the firmware?=20

The struct uses an unsigned long flexible array for the bitmap, which
alters the element size depending on the kernel bitness (4 bytes on 32-bit
and 8 bytes on 64-bit). efi_poison_geometry_valid() rejects tables where
the size is not a multiple of sizeof(unsigned long).=20

If a 32-bit EFI firmware generates this table, it will use 4-byte alignment
and a 32-bit word array. Because CONFIG_EFI_POISONED_MEMORY is 64-bit only,
the 64-bit kernel will evaluate sizeof(unsigned long) as 8 and reject
perfectly valid 32-bit firmware tables as malformed.=20

Since bit array layouts also differ across word sizes on big-endian
architectures, should this firmware-to-kernel ABI boundary use fixed-size
types like u32 or u64 instead?

> =20
>  #ifdef CONFIG_EFI_POISONED_MEMORY
>  void __init efi_poisoned_memory_reserve(void);
> +void efi_hwpoison_record_pfn(unsigned long pfn);

[ ... ]

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a2ca8df501cae..d9b8be696aac3 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
[ ... ]
> @@ -1326,6 +1327,8 @@ static int action_result(unsigned long pfn, enum mf=
_action_page_type type,
>  	if (type !=3D MF_MSG_ALREADY_POISONED && type !=3D MF_MSG_PFN_MAP) {
>  		num_poisoned_pages_inc(pfn);
>  		update_per_node_mf_stats(pfn, result);
> +		/* Only hard offlines are carried over to the next kernel. */
> +		efi_hwpoison_record_pfn(pfn);
>  	}

[Severity: Medium]
Does placing efi_hwpoison_record_pfn() inside this conditional block
unintentionally skip recording hard errors on previously soft-offlined
pages?=20

Soft-offline marks a page with PageHWPoison but intentionally does not
record it in the EFI table to avoid permanent loss for predictive errors.=20

If a genuine hard, uncorrectable error later occurs on that same page,
memory_failure() will see the existing PageHWPoison flag and pass
MF_MSG_ALREADY_POISONED to action_result().=20

By coupling the EFI recording to the meminfo stat increments, genuine
hard errors on soft-offlined pages are omitted from the EFI table. Could
this allow the next kernel to map and crash on physically broken RAM?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D5

