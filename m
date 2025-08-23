Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC75ECA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 21:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115136B009F; Sat, 23 Aug 2025 17:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED836B00A0; Sat, 23 Aug 2025 17:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002E56B00A1; Sat, 23 Aug 2025 17:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDF2A6B009F
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 17:48:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C748BAE6F
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:48:06 +0000 (UTC)
X-FDA: 83809360572.02.052331C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73EF740005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:48:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okdJjChS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755985684; a=rsa-sha256;
	cv=none;
	b=1vDMkBlNHRiJfq9nggBFQIsdGLA7UZn7p809PcmEpxo9bLp8Yu+PyHW6AsPOKPY4nVR4eH
	bkDd2jONFZCZbDOhLSYScWIvfLxYQb6Uxtaqx7eQ0M0litJCx+kOOORvPL2v3uB9eHRSLg
	bPm3399S7GcEdAInHGBgLMAimlo8J8s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okdJjChS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755985684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlJ8kmojnc5frOfQVVYbz5CdVJHYb5UepPbqTiauKpA=;
	b=3nrK8kIa9kL9Bzflg79K0QJwFnpn4AabqQRiSvxhrxMBVQTAU8xEZzVGK4R6A1nJWikRx1
	UPgSxT9FqjKEsPBx6w+Y9Sp+CuVK2SxgYpFv9k6t9yzmrsbpBCxJnDnfkuDemiQmXty/ik
	yXgp7K1ay4YGqfzqVn8xCsZDnERA3FQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 89D8FA58C95
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F27C116C6
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755985682;
	bh=f+2e1mjfdrM4u6c20rSZEJrXZ7DiDa0vXieudZxMy4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=okdJjChS8xDJKozutDClByY1QI8HxqsxfRLN6XIOhW4F/CD2Vmv8revUE77i4D9b7
	 YLiPtKcKWgfl455V3ZjOLSEw02BJCLdhrnl5bIKjFB+nyPwFDemhrqxOFfdFBFy6r1
	 SW0aUch9FILfVp+0p24u5UAwhERO/pGUQViOJlqLu58EG72cNvs5Aiz1ifThpzFCQC
	 0wYPPkHothpsuuu0sPoBd/RDnfS1segsfiwrGEw7i9TeP1bnsvJp433DhH5bAz5axK
	 /xzW7BQTM6AA+njIvacRoJWNR4OQkq8PK/u3O877KELm4+FphSMcl9XeXSf4fgF95d
	 1IJ+hgeBIqE8A==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55ce522d6deso3296616e87.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:48:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXtncaztMMUvLN8KcDux1Glz4BwZVJ0iYNJVJwKHuTi1INj3IAw0i9MkPVHIzFAS5VUfk1joX5AgQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5OvVSSZG5GwcuB4CfbPbycPGwM3R2kiwOtOEakTMWOXIW0VJR
	KW+aYEHOotVhN+srgHHp7xb2xT2NPc7M8JMRhahDg8ALE1wRSWIoZCx1CNt4k/nuFqaT1WONzXl
	zqZbJsoxgSIsrxO/1i6tTewy4P1ey25Q=
X-Google-Smtp-Source: AGHT+IHpU7xCroubPXDWGgYJBrip4rxJYyc1NgWuY2GTM1r2YZ/KwreaPY1ko02JrW08q1BaBbIhh9myTEwFob0bbAM=
X-Received: by 2002:a05:6512:61d0:20b0:55f:34e8:b1b0 with SMTP id
 2adb3069b0e04-55f34e8ca18mr774083e87.15.1755985681198; Sat, 23 Aug 2025
 14:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755721529.git.epetron@amazon.de> <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
In-Reply-To: <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 24 Aug 2025 07:47:49 +1000
X-Gmail-Original-Message-ID: <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com>
X-Gm-Features: Ac12FXzn0qCCniv9JuLvANrQaphyB7rl0h7KLf3cn0PE7oJ7DT-dRyUUwZAdnF8
Message-ID: <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
To: Evangelos Petrongonas <epetron@amazon.de>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Changyuan Lyu <changyuanl@google.com>, Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 73EF740005
X-Stat-Signature: 51zuj6npsuc4usg6ijzfywthfrstrmfm
X-HE-Tag: 1755985684-681516
X-HE-Meta: U2FsdGVkX19jU8FyZdoK28Q/bswNHqjEO+1LjjYZY6Rnsvn9tw4awHZKjGNPsJ7o+gPjwVfjN71U77psUgx5SUiziZAGUlpNbWbZf+k3qXXOiFKKX44D6hqHO5K2fuXH5lM9bDMYydIa0tfK0IN/+8T1LSFLvhBMJTNUM2npu2OHtVituZ7Ywaf/o/OvUyH8T2srj/GXgu/6tMwgpk4svdL1QsZmCIEZJoC0rbTVOg5zf8Fh7TJgr+mSTVI1Kg5oikiAs2HRDofh0und9nTzc+sUhX5/pW8xE/sTcckzr6myRT7l6ZG31aSA6iVeIenCxNrixBzNUUq0fmQwLvGgXuzcgc29QbcTImlnzJ/FLLf3T7KGN7XSECFONmRsVIDn15Poml789qQLjcPSqJxcdLNJ7gWtIe1ULmk1JBgOdWDJjjhlVwcMLPkOCvZiNJPbrkKHjrn+jIzKz5CTPhTbOFch82oWmohWFpEOZJ2wtHXAPggY0RfcEZ0dhIC38Je31Xr3I5xBeCTRZH9n4CEzsAIjelVYh2lfEELZ0ysy8q/DAQ2YgsNW0n1z9Ksa/a7zli2DzNFtrJ+sy4EpWIoxlRRHVxoWyZSlCRuLF/y+xK4e1YEfSNVmZvjjhcoykrGfwiU7Yj9dJPP5t1TSBM899JpRrOWb2/oMbq6o8qUGCxMvRBG0+vTkUk9U3iWnqNJVrpy4LsSznuD2VP+6idBVxRYNm639Zf9EDeIf5P/o6yReXVJhWLqvBr9ecd5DSZhoXlO7U/bMO2TlTxZVXEvgP9al5KYkseWbig8NkXgMxmnxPWvyhC2aHL3ATo4gyfDPAHT7mHVblV9Ze0E4x8QpLSrl+GlOJwt8yOuO5b6yq5uRzaDnv/QY2oLVuw37wXlpQDhtU/MpkYRxtjbJJ2dUFJi4RxvKkGtpT+WsKmorFuTjq0HfGAyTu3WWUpJka68roE1H9HKMDcfVM1E3j4H
 qC7rDnmg
 0s6H15XtLD0eaWshHXLxxyuOANZgdwA43ChJTtPfGpAsrjtV73cqxJZWurll2mxOIeLmd0mFKw3hivbqSYUb9qpZqqEDAYwKA0YCh7H4PSfp+lvpoE0uk36yZ/xMmOsfYbYRpKJmCvRMeytGjhx9+b7UpppVOmX7vt5b84zzhaatUYtsXh6raGkSPv0b4bXklxm7OvUKJ4nvfemESPpbOumPHy55TJ4Pp7kWn8hDSwrRb3Gp4RlNdaPVbapsOfa6/ofiX1Sa8Ap9v8cIQLn3+ZySWJKy3ExR3TNThmgjNxLTvSWeOQHwTlynxLDmETf3qCFmFtaifdbSmmnM7I4NpeAu1TVl3rEDsUKPHZg1d0BtnL+42XM6DwdgUcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc Ilias)

Note to akpm: please drop this series for now.

On Fri, 22 Aug 2025 at 04:00, Evangelos Petrongonas <epetron@amazon.de> wrote:
>
> When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> early during device tree scanning. After kexec, the new kernel
> exclusively uses this region for memory allocations during boot up to
> the initialization of the page allocator
>
> However, when booting with EFI, EFI's reserve_regions() uses
> memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> rebuilding them from EFI data. This destroys KHO scratch regions and
> their flags, thus causing a kernel panic, as there are no scratch
> memory regions.
>
> Instead of wholesale removal, iterate through memory regions and only
> remove non-KHO ones. This preserves KHO scratch regions, which are
> good known memory, while still allowing EFI to rebuild its memory map.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> ---
> Changes in v3:
>         - Improve the code comments, by stating that the scratch regions are
>         good known memory
>
> Changes in v2:
>         - Replace the for loop with for_each_mem_region
>         - Fix comment indentation
>         - Amend commit message to specify that scratch regions
>         are known good regions
>
>  drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>

I'd rather drop the memblock_remove() entirely if possible. Could we
get some insight into whether memblocks are generally already
populated at this point during the boot?


> diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
> index a00e07b853f2..a65c2d5b9e7b 100644
> --- a/drivers/firmware/efi/efi-init.c
> +++ b/drivers/firmware/efi/efi-init.c
> @@ -12,6 +12,7 @@
>  #include <linux/efi.h>
>  #include <linux/fwnode.h>
>  #include <linux/init.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/memblock.h>
>  #include <linux/mm_types.h>
>  #include <linux/of.h>
> @@ -164,12 +165,32 @@ static __init void reserve_regions(void)
>                 pr_info("Processing EFI memory map:\n");
>
>         /*
> -        * Discard memblocks discovered so far: if there are any at this
> -        * point, they originate from memory nodes in the DT, and UEFI
> -        * uses its own memory map instead.
> +        * Discard memblocks discovered so far except for KHO scratch
> +        * regions. Most memblocks at this point originate from memory nodes
> +        * in the DT and UEFI uses its own memory map instead. However, if
> +        * KHO is enabled, scratch regions, which are good known memory
> +        * must be preserved.
>          */
>         memblock_dump_all();
> -       memblock_remove(0, PHYS_ADDR_MAX);
> +
> +       if (is_kho_boot()) {
> +               struct memblock_region *r;
> +
> +               /* Remove all non-KHO regions */
> +               for_each_mem_region(r) {
> +                       if (!memblock_is_kho_scratch(r)) {
> +                               memblock_remove(r->base, r->size);
> +                               r--;
> +                       }
> +               }
> +       } else {
> +               /*
> +                * KHO is disabled. Discard memblocks discovered so far:
> +                * if there are any at this point, they originate from memory
> +                * nodes in the DT, and UEFI uses its own memory map instead.
> +                */
> +               memblock_remove(0, PHYS_ADDR_MAX);
> +       }
>
>         for_each_efi_memory_desc(md) {
>                 paddr = md->phys_addr;
> --
> 2.47.3
>
>
>
>
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
>

