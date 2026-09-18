Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6FDC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC306B0092; Fri, 18 Sep 2026 04:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2833D6B0095; Fri, 18 Sep 2026 04:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198DF6B0096; Fri, 18 Sep 2026 04:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE45F6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:09:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 842BDA05EB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:09:57 +0000 (UTC)
X-FDA: 85226159634.30.F6579A5
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	by imf30.hostedemail.com (Postfix) with ESMTP id 918CC80008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:09:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADFQDA+8;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajXDT72SASPlUAIpfN0KU7YI2VHhEl8UztFZ5ElJ3Lc=;
	b=ur8XrQbae7hZmlmaxU7UgZiwFIgVC4XGBRlW57ncA8YCd7IGJPAh24ce7apgIjf98pBNqJ
	XDrt8UnVgExS0HPIcnutlKid4v/GH2baHDyWFGj+o0sH5eTiKHDCqQcL6tZjkYuexe97rT
	uNdeDMAb0GZSRcMlPcJZNM4XwXqdcp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718995;
	b=OQqazCGHJ6R4FvCrDeZaW23I9w5U9b7r1qzPTt/5pM6biKP/gBE0yLEZM/sbZSGg4+F5Iv
	owZGwR7K1FJMcFAszMF7FTd/n8IhbL8dJkllw09+FRK/uTBjBbPn/rRQ6AE8I2v+hWYGC4
	Fsyk8uUL0Whxj8mkEj7ivKcr8IEXVYI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADFQDA+8;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nOrA6LUUXVDyAS34aH1r5AVGEJg8nxE5D7IKoW8+wIQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718994; v=1; x=1790323794;
 b=ADFQDA+8TsnOkukS5fm8rZm9Oyd+Iw4z2srzzl8WrTbKLBBVgPWXUyKgqFQPgR/K+hDwYhDb
 B7cGxqBI2yqG31O7adiQ76NoqZ5urKgGQZj3OxckVHflyNIep9ss948jyETzhw6XZeHIrjthTbY
 RT0ebUOZjFCZglV1SThXrPuE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id db6dbc05fe83f0e0;
	Fri, 18 Sep 2026 08:09:53 +0000
X-Mizu-Trace-ID: db6dbc05fe83f0e0
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 16:09:37 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 10/10] crash_core: skip MEMBLOCK_NODUMP regions when
 building vmcore ELF header
Message-ID: <aqzxwd6TXxbempxx@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-11-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-11-chenwandun1@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fnzf1487zo5ustfk6f6pyxys1nu791i9
X-Rspamd-Queue-Id: 918CC80008
X-HE-Tag: 1789718995-75341
X-HE-Meta: U2FsdGVkX19fSEe/T8e72RzIgbqCFz/rt9sV2nHhT/sEjmPFf8JbdBuM6YMndelPsXbovqG7xK4Ns/eitzi6eljDs2rnDLKjh8rNLvSs3Ma5g2EpGWG0kcijp5ByguRrQZNoLDiKqeJ7QF1YK0NKKj2Tj0f7QRLuujcsIyKjBgPH6FBTYIoUtAb6VE5/Sp6ZQaRgFTJ5EuoCZm+juFztbJQIP8i/GxsSh4uaKapmhxYM7ciBS5+QLnzVwgiMzHZcNEkTGY3rMjIfM9xH3+/WCWBDRGqbyvcppaUay3zeiKo44QekqXLNB03XRn6I7PwfWHYmvB1KUCO1oNWtb+7aRYcg3Z6th+QJE8FjHQ+GhS34TbFvqGjW/fzBca/sJU10xVcIngZd5NyjVHyN4xOKbwZnWHvUEZGvPQxjJo7xaCuWdBq1xvU9YL3aCdcx7Oxl2tuAHu7vRaWHsLRsQujavgUnLGrbV0Oj1Oh9o2h8WgESiCVhmk6G4JjuIafcscMjfBFJ++3IltzGBJuPaQkND0EsT7wdTW/f2AXOgPep+0aSifTlGakjhnXzN4ac6/Vc6dFDIivtVYIFBXCpMKCIr3WIrf5wjXifbBfoC1keU6Yh02kcHs/fIt+rmFftIxzx2+1ofdbn66DaWW063sVQD2zW0Qp22U/zcQGc70rbdN9/2Uif9OSVpHwp8jSblhx0039j9hUyfuZb34KKiIv4YP1/DuufTT8xwrqAbOT+Kf23BiIPxl1XoGTXsrOxZ4JsfE+cj5cSDBmA7UgL8Q+pKhuDQ4vbDSzd9nSKt9kbz+QtonSOsGu0RV5NHn6ldsDbhfHaOicqhCv5HthHCIXviC3LbeuwzuOd/BLKJvrWVjOAIq8blbzPmRQPli0nXvI9LPSYP92sXaSRftTXDQ4F1WHQJ91DJk1P3ueCykpYwClwmcXBIaHH2nP1VBCctwjF4dZ4SzHQwgOngYsI6M0
 9eYHNW7l
 kzU2nO8p13BrU7wK83LCaVRPyIrHeykaRsnco1liMXMvshXUBSrGSYXhf6J60Drrikixi/+HPGzaHSaKbHdN4ftRu4uvLdr8pX3DpkxZLmu2T83hakJQotLBMZ0RpbS1yQH2rXDZnUlaLkSu15tHM6I2ETWjR+wE2f4hsqrHIRDLvM5sGiCM0RP/uqKTIQ4S7ORiH+0K6EKHY+gOdGD3yp4xXiuCtJY+LR02JO8c3wXNk088kHbyiM5uNJJ/W0zwGSmhrIpaYoH2ogWhUByNisNZh5GjXX+A4XBXuXXz5ZOmRaX0S7CzJkqmquv/rp/tsyNt5oXTuOSRyg05ivxSzwhacQ9nIunwgNo0Qp2Mb/dC7O1bcN4n0VvsF4gKqW4hcB+Z+KucFAYQemJhOP7xw8IaIe4qxywgcTB4p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Reserve regions (for GPU, DSP, ...) carry no data useful for crash
> analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
> reduce vmcore size and capture time. crash_should_skip_region() now also
> returns true for MEMBLOCK_NODUMP.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  kernel/crash_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index bd64cf585795..b0e618e13588 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -270,10 +270,10 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
>  	return 0;
>  }
>  
> -/* Exclude NOMAP regions from the vmcore. */
> +/* Exclude NOMAP and NODUMP regions from the vmcore. */
>  static bool crash_should_skip_region(struct memblock_region *reg)
>  {
> -	return memblock_is_nomap(reg);
> +	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
>  }
>  
>  static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
> -- 
> 2.43.0
> 

