Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5B8EBFD38
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84026B00A0; Mon, 13 Apr 2026 06:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35586B00A1; Mon, 13 Apr 2026 06:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B246B00A2; Mon, 13 Apr 2026 06:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C34FF6B00A0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:57:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CD19C0284
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:57:58 +0000 (UTC)
X-FDA: 84653232636.16.038E6FF
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5779440013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:57:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=nmmX5epE;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf01.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yOlosg+cVYV8+u47sLzjplPhc3Rbe3BWWgSNY8/iuQ=;
	b=xB6mfZncjvtOYmBx78SFwDL6ezgkiP2DC7w/ET1mdWgK5gPW27HdvAL1wPq8sJvCEpyvDo
	nBJWjqy6YJ/QYTWKKkh0MDFaz0xahzX7LJ5zHoWYLLjEbNDb0RAAZmHe1fNPpe+R2EzFKA
	mFq6qOTZUOPaljFkpa06K4t9Z+dC1k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077876; a=rsa-sha256;
	cv=none;
	b=tCvUb8+Qw0aivBt2zuSZU4ArSx56VruMQhFMrIV9RVJLo8jl8VFjzVKIsLZFX8w7EWgWho
	/BvTuOon50NLiPpZWTuc93g8JCD7pYY8+cnso6aCHKmsX3DvtMOCuslYUqu7WsnLtPh4VZ
	JvnLvUKXi7FJ/qJKrAB51AisR27VtAU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=nmmX5epE;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf01.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=6yOlosg+cVYV8+u47sLzjplPhc3Rbe3BWWgSNY8/iuQ=; t=1776077876;
	x=1776682676; b=nmmX5epEd9gUhdgDJoWWB8uI+77Bv0t1j/MDdgIOLgjHxlFCAT9+4uW8M0eS1
	IFjn4pJsLCh9bfxWyptrOLZ9/iheHVhd25dWGwJKVJ/GpxUvjx2IUp+1d0HGy+d4K7M+oOYCYP6j8
	fzGqgDVwJl/iu66k4SlTM09CEohUK0JfSv0UgwucQvucnqRSnxahfRfZzPpQKX16wJQMaO7Hop2vl
	1t7ninXDYhvUODrAXvabGAyVaQ06nk2GFYw6v4eibdRrzQfNmAbKds3Mnf31rd1OIDUHWdMsrRv2T
	7KWq6UgZJ8g6Oc/B5e/hG7cjWVQwtQzs2b351iawUTD52oso9Q==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1wCEzG-00000002T6c-1k78; Mon, 13 Apr 2026 12:57:50 +0200
Received: from dynamic-093-128-043-080.93.128.pool.telefonica.de ([93.128.43.80] helo=[192.168.178.50])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1wCEzG-000000023DI-0ooC; Mon, 13 Apr 2026 12:57:50 +0200
Message-ID: <44fcae62f14a4020483b8a2f867c94045155fdb9.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 00/10] sh: remove NUMA and SPARSEMEM support
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Mike Rapoport <rppt@kernel.org>, linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann
 <arnd@arndb.de>,  Rich Felker <dalias@libc.org>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Date: Mon, 13 Apr 2026 12:57:49 +0200
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 93.128.43.80
X-ZEDAT-Hint: PO
X-Rspamd-Queue-Id: 5779440013
X-Stat-Signature: juquzogxx3iceb8nbs6osujhpmiuwejz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776077876-308048
X-HE-Meta: U2FsdGVkX19H3UcCHyzeszylP3R3MhkM8F2wD6/K4pLwNgYcVFv8rWwBeTGAe1CQKjs9yOEMn57lEw1NuAb11ADepdqsKZqHe+LgfTevYXTHNrvDQF8CTht4uPCzjAhQJfxyf1aXJnyw53mLggWNYMRom2z57APZlVi6RMwAWVTB301tdMY7YqaMjWPB6Iuod2Nxd4ty12ZgBzi6TB6l+WdQHfc/he9esXZ+GzGSwNWLsjmvZT4xbBNSbci/hbYQSFvEJrl2rIOTDMi/fBp4n+RJjTLxxwdmrCca5MSzBoG6VZKeGCzupBKa6Fhc9kwxXKqZErGj3Tm4E3s3eBwijk80/GZMlGc4qJAp+IuuFL0J2uBIac1K2iSDMJUSDX2fGcYfBBemg2b7im7/1q/JLYw+WJFDHekefKP55fW/Wthy3EoCDipVhD3lQnhP5upBHonavooFomuWMrtJP+iOhpoXvwqT0akoAcVINJ2qtkUhBCc5IgBHP0sxjj+oSl4hlZ62b4quaD06hUndCyA5efW+U3UAishR7SdnNb+qzDogXC5EzKkUVRD+97t3V3NT5Nsb7SWQGGZP+NybGWl6Je5FrLgJgrFTpEVp34YPjkNeU+Ua1JSVT0L1tpb7STJ7qY5hlUw1bBO5kFNksX4GUSlK5YxFLxcYrO9xqXASPpunmeWvZ8Yyzr1bu+1w5Ml45eYmBLTahRMALsecRlqGtO7iDuAEBcm4eIZg6cmZdvsFg4UjrrTD59+La7Vuqd9idPBF3/0noot68XblzFY6lfOyd2ENYZbCbS7QyN6djfuxHeX+yxsuPdAgdb/GzUST8/wlhbeOHNwSHAeX+XGF70FVXhJgtgA0ikoRWSgIGUHZnVCb7eYGf0K5VT/xNOhLyAyLRB+kP3XIv5pFPmHA0xtUUAA7RgRmHsmoY6Cm0KvK9zUxHfPNz5KG2gLYtIhOlj078P3TyirV/8SXRMU
 qNOXknBT
 2nf0FUx8evc2EHK0Bd7LykxaZ7JTeD1S+rp/XpkRLOlt8unOW3O9FX1qJH7KVNjg2po12bBGQ6Pdc5C4Txx3P/5wavtcbPIVbtaoTMb+xW8IshzIEMw12sEORqG6I94mL56QFG3fywrGhFe7WRgST1v/crIbTPl704uqhYt7e3hiG4TR4+Ymg9GeePFUvmBAMilLhL0VabQskNmdNUQP5zpWmXf5SnfthkldHQ0zM5lhHse3Qi3GN+wwjNoN+X2A3cjvZXSkVlV8FWqpU/BbckHSTKRIjZxKWLYbZ2uyv31Im55+Dr2ymPeCJXoIbRaGUIdCX6VKP2eDThtZPqtaWX/dqF0jSO1PKngInrgMTLf9DVQup5j77HHBMPsp62Z5MTla/L6I+MejyzBkqW+8U0hH5QLUOe4KFY0HHuIvWXWT3Z301mdI884Hq3zCmVqvcz9xfGQMS5sBXrHTd5//Flk32bZ4hjFPxB0EY5bCUVhzf1RjW9ihQ1S7pqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Mon, 2026-04-13 at 13:46 +0300, Mike Rapoport wrote:
> NUMA support for SuperH was introduced a long time ago by commit
> b241cb0c885e ("sh: Support for multiple nodes.")
>=20
> 	"... for boards with many different memory blocks that are
> 	 otherwise unused (SH7722/SH7785 URAM and so forth)"
>=20
> In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
> shx3 at the expense of all the NUMA related code in the kernel.
>=20
> For build of v7.0-rc7 with defconfig and the same configuration with
> CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
> CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
> overhead in code and static data that does not take into the account data
> structures allocated at run time.
>=20
> And all this overhead has been there for nothing for almost 8 years
> because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
> those additional "nodes" could not be used by the core MM because the
> maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.
>=20
> Mike Rapoport (Microsoft) (10):
>   sh: remove CONFIG_NUMA and realted configuration options
>   sh: mm: remove numa.c
>   sh: mm: drop allocate_pgdat()
>   sh: remove setup_bootmem_node() and plat_mem_setup()
>   sh: drop dead code guarded by #ifdef CONFIG_NUMA
>   sh: drop include/asm/mmzone.h
>   init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
>   sh: init: remove call the memblock_set_node()
>   sh: remove SPARSEMEM related entries from Kconfig
>   sh: drop include/asm/sparsemem.h

Thanks a lot for the series. It will take me some time to review and I expe=
ct
it to be taken for v7.2. FWIW, I actually own several boards using the SH-7=
785LCR
CPU and I issues booting kernels newer than 6.5 on these so I'm wondering w=
hether
this broken feature might be to blame?

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

