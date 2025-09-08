Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7CDCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 05:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D646B0008; Mon,  8 Sep 2025 01:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4E26B000C; Mon,  8 Sep 2025 01:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2216A6B000D; Mon,  8 Sep 2025 01:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10C176B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:50:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F61311B128
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:50:57 +0000 (UTC)
X-FDA: 83865009354.16.5C4FF77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 96A2240007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:50:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eqEyEaRu;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757310655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iWJ8X5B9+sCLtOTikQAELV3gEVXsp9NUo/jVMMCq+8=;
	b=q/I0UTqyCoRzuNhBZre4Pi8nHvhjzGFbCO3jxQvi58RhdqGgF1Fznu/OhanzcaaWrjuFhX
	BIlTpjHKoirW6IpM6vtp9REHi54NTFQn6dTQqmoWGSxOuG9J6IYS1GeCHxyiyYcB7jwAZU
	qYgstZOSJP31PqPckCDqwH4hEoJ93ts=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eqEyEaRu;
	spf=pass (imf27.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757310655; a=rsa-sha256;
	cv=none;
	b=gBsKlcLgsy5tYE1Nb27dv2hGcOoKMN7btN11PZ6y4WEoqTStrMmBL5ZgjL3sxLB8bj7Pza
	l6sMsCMLNjlVrgcLo9YtRtzVHLDfuoPHHcl6oJMQtBNfCea+7FSMZ8kGLDfC5EqgUuzsqv
	iA0/emcadqq/abKZBbekkPnnHHeHJ4Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 417D9440E7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2591BC113CF
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757310654;
	bh=GINqdprG7It+egCrjMUFqxjobyN5ZaYR3gYB4TpViCY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eqEyEaRuhNunHE3meUU+OuoeHwAkGzIcX9usvYpVewBuHj2C3F7wHa8HZU9upo1Uz
	 s1VkxCRZF56OvA8sxNngOPt5NZ6pnkOCEulUlriyWxUo1E4eL43H7rH7690cbD5eqZ
	 HJaJya4gAhtb768C9GG8JjPPhvxMGBoAsAPWThKZM9HnQO4NKTYBxCL2MUulH9YBUU
	 DeQjZUYww54kwZqauuvIoQ/6Zc2xB4ygjAntlYYqg5OmvgKAH3n2EGAI4N7ku6FiU8
	 OpNacVHWw9Y6OuUu7HhWlzydOCTx8iWQVPVvmY5YSEPiPVQcOgH9sjep/xGJVpejzx
	 UG+3z+4InK5qw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-560888dc903so1695268e87.2
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 22:50:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUnPonxFlyDLomJ5GBvbH9PgR/84ICR95qB5Qoa18UB1pz3QwE6SIvCaj6B7R0wqqXqYE+6apJf1w==@kvack.org
X-Gm-Message-State: AOJu0YygQbnAHl1QTsDFsCTDTAGBieH6LVyh/C+//7jdNsHYOhVqirIZ
	bWG/24AOf7tBnXWFSgKfNw3v4V2XtGf9qsTsqETMuQbiz5v/jigtmF74eoFXPyhLgT09XdScurJ
	ke0CTHFG1s+TyxGSekqmRfKc11dNvKu4=
X-Google-Smtp-Source: AGHT+IHj3nVEJWnBkVlJaXrN5K6OwmGDBEDQK/Rmk6FQrn4LOuQl1f6hmY4bY5Osqcf46rysjnySFniHWM+nuYqAYng=
X-Received: by 2002:ac2:4e0e:0:b0:55b:9796:5d5a with SMTP id
 2adb3069b0e04-562637cbf62mr1664560e87.26.1757310652405; Sun, 07 Sep 2025
 22:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755721529.git.epetron@amazon.de> <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
 <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com>
 <CAMj1kXFzKzpoqczq7Rk-u+kKLFO057XEXMD+KM=iRMMsoUZbJA@mail.gmail.com>
 <20250904093455.73184-1-epetron@amazon.de> <CAMj1kXHTJxBMFX6J-QwcPRojLGMQsTNOH5Bz9kHk7CFdt1JApw@mail.gmail.com>
 <20250904125917.78112-1-epetron@amazon.de>
In-Reply-To: <20250904125917.78112-1-epetron@amazon.de>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 8 Sep 2025 07:50:38 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGUOFN_W_8c3a6BnsXDy4xsF+9DUV3wcPr2s7-1K_xUUQ@mail.gmail.com>
X-Gm-Features: Ac12FXy43MFxOfSIccwrzkLM_Cl2hPp8-URkzEi5uCzgUR5RgZV-_I5_vZSbyeQ
Message-ID: <CAMj1kXGUOFN_W_8c3a6BnsXDy4xsF+9DUV3wcPr2s7-1K_xUUQ@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: akpm@linux-foundation.org, bhe@redhat.com, changyuanl@google.com, 
	graf@amazon.com, ilias.apalodimas@linaro.org, kexec@lists.infradead.org, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nh-open-source@amazon.com, rppt@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 96A2240007
X-Rspam-User: 
X-Stat-Signature: 5a1en3w5q3pzxkm6z9yzs989seejhhy4
X-Rspamd-Server: rspam09
X-HE-Tag: 1757310655-630691
X-HE-Meta: U2FsdGVkX19Re6sY9UBt3yivfoZpMq0Ps46tPmVj6aZuCXTJHcLgpBeSIibYdlLDx28+ozBCzpO+BrATpxG0maCYSTp3qtc5x01u4rd1gLHnOLsBiwHuIA3uIdu+Rjfi3GrAGwS2Ld9v8ZmUZvp41VsxUirrdstMu1R0eilJuJbxvSsjozoxLNzhhHUlkHmVgE5ITPetNBgxdKgeziWXyNoeFWBzF1q+26qFm80ih9DEU4KSEENTD8YTXON1A3CkELHgNH2k7ZVGQhnurXcTAgCsjHywUU0S/Z1FcFHsj+oLy5ehjrqru4TpOI7lzhRIn8aMz2FffR7jUq55mvsFJK9zznvMuOEUjR/2253BcVAg56BIpYX3TzFAQP3ztQYFfZcTkHJBQTDXPZi6WurP645O2fDPOCC6NHeqjqRXXLnU3BxuFmPNcR7Mjq8tgFVXqCVbi889OslO5f0ku1xigAb8MGKDJffy2CgPqPsVV1T5L2OQnO+lZNEVkWThLGCDRSv0O8gLahDcQ1r0Uhf1g7IGLjELqOPira52PoeKrRK1q4QmZnPpRQwW/Szz4zBWE87h5dnYwDxjI4CRoJP4AJt/r2/VqzqfgHXnP7Hd5o+2DYVQYY8mJoWPZCf709SR1x9acdO83v1cNgV8ogM4OGEkQjHI2xzbxdM7A4NIdZ4tKJlV4wgedpIlrAxsNCaHOPXNx0KWafyZJuKTHYxr4Q2S0tM/ZilfXXl0ogqBQGsu7FdjB/fsETGvey5ROD+05DpCjqRq1t0cxGUjVCAhNWhIwYuzUFQd441u7i1t2X8HloztUB4u1dlyQLIPFnZv+x8961oR+adUEMPdEjKDEX4LnUVVIIRO30BtGHEG7qf4AMQX6gaSbscuroJjGpxexFcKfsshBsQREucSNL/4FzE2UYjJdm37box6HX7+DRyoMZhnVBRwm6/btV9UC7yBjaVPt7ah0YxAm4se/3P
 BUaLDgO5
 uYovI0MtE3uNBUFpnCUItXdEHDwNnINdrylgN4e0X92DXhwMHet8rpP7Qh9vrr+vh0zM5+vtvDHLEZMac3rpDCPUt8oq7iuuHLPTVCJIUmxcb48ohOX906MrP/++nQ2av4ZVpMlkag7AaPCY2MHAkhnV4endBe2QWdL75Euiv3q84ioaTD2JkE4FuONcQAz9tTlgs8GcRVNhaZ+SDixloBQkJeeprC9Fs4XpfwXgPGUqfRrsxHJ1HoBZYWqbkh+ociLDhYS+kZAakXoce5WYQKKvpXhHM++Nehfbh5MJzad+pOgNcrbnIUEU+pnZPxNwhEEEOiIwTASkZK/9fZuvnkrcQWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sept 2025 at 14:59, Evangelos Petrongonas <epetron@amazon.de> wrote:
>
> On Thu, 4 Sep 2025 11:39:02 +0200, Ard Biesheuvel <ardb@kernel.org> wrote:
> > On Thu, 4 Sept 2025 at 11:36, Evangelos Petrongonas <epetron@amazon.de> wrote:
> > >
> > > On Thu, 4 Sep 2025 09:19:21 +0200, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > On Sat, 23 Aug 2025 at 23:47, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > >
> > > > > (cc Ilias)
> > > > >
> > > > > Note to akpm: please drop this series for now.
> > > > >
> > > > > On Fri, 22 Aug 2025 at 04:00, Evangelos Petrongonas <epetron@amazon.de> wrote:
> > > > > >
> > > > > > When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> > > > > > early during device tree scanning. After kexec, the new kernel
> > > > > > exclusively uses this region for memory allocations during boot up to
> > > > > > the initialization of the page allocator
> > > > > >
> > > > > > However, when booting with EFI, EFI's reserve_regions() uses
> > > > > > memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> > > > > > rebuilding them from EFI data. This destroys KHO scratch regions and
> > > > > > their flags, thus causing a kernel panic, as there are no scratch
> > > > > > memory regions.
> > > > > >
> > > > > > Instead of wholesale removal, iterate through memory regions and only
> > > > > > remove non-KHO ones. This preserves KHO scratch regions, which are
> > > > > > good known memory, while still allowing EFI to rebuild its memory map.
> > > > > >
> > > > > > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > > > > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > > > > > ---
> > > > > > Changes in v3:
> > > > > >         - Improve the code comments, by stating that the scratch regions are
> > > > > >         good known memory
> > > > > >
> > > > > > Changes in v2:
> > > > > >         - Replace the for loop with for_each_mem_region
> > > > > >         - Fix comment indentation
> > > > > >         - Amend commit message to specify that scratch regions
> > > > > >         are known good regions
> > > > > >
> > > > > >  drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
> > > > > >  1 file changed, 25 insertions(+), 4 deletions(-)
> > > > > >
> > > > >
> > > > > I'd rather drop the memblock_remove() entirely if possible. Could we
> > > > > get some insight into whether memblocks are generally already
> > > > > populated at this point during the boot?
> > > > >
> > > > >
> > > >
> > > > Ping?
> > >
> > > Hey Ard I was AFK travelling. I am back now and will get to it.
> > > PS: Keen to meet you later today in the KVM Forum.
> > >
> >
> > Yes, let's catch up!
> >
> >
>
> I did some testing on qemu with memblock and EFI debug enabled
>
> (`memblock=debug efi=debug`) and no KHO.
> We see that `memblock_dump_all()` in `reserve_regions()` outputs:
> ```
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0x0000000200000000 reserved size = 0x000000000db5383e
> [    0.000000]  memory.cnt  = 0x7
> [    0.000000]  memory[0x0]     [0x0000000040000000-0x000000023c76ffff], 0x00000001fc770000 bytes on node 0 flags: 0x0
> ...
> [    0.000000]  reserved.cnt  = 0xf
> [    0.000000]  reserved[0x0]   [0x00000000fe000000-0x00000000ffffffff], 0x0000000002000000 bytes flags: 0x20
> ```
>
> Moreover checking the code, the boot flow  (at least on arm64)
> populates memblocks from DT memory nodes via
> `early_init_dt_add_memory_arch()` before `efi_init()` is called
>
> `setup_arch()` -> `setup_machine_fdt()` -> `early_init_dt_scan()` ->
> `early_init_dt_scan_memory()` -> `early_init_dt_add_memory_arch()` ->
> `memblock_add()`
>
> As a result, it seems that memblocks ARE populated when calling the
> `reserve_regions()`. So looks like  we still need the
> `memblock_remove()` (?)
>

Indeed.

For the series,

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

