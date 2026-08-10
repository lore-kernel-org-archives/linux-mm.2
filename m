Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB9BC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8AC6B008A; Mon, 10 Aug 2026 04:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0886B008C; Mon, 10 Aug 2026 04:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D286B0092; Mon, 10 Aug 2026 04:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B33346B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:24:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BC9E16044B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:24:09 +0000 (UTC)
X-FDA: 85084672218.13.D6CEEF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75CCDA000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:24:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kDf0pMZ6;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786350247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=za/dgLTVAKpnAfno98BQIXcUPCYXTejUD5HWiea1RH4=;
	b=ZuXBLqriEyCZgTKgvKvd3Mtg4PRaoGz65xwMknxejyU/yuk08z+hSHOxsH8KZ9SCBHRGnH
	oEVHgJ3ahNIispMCsiHsbCRm1pwrxygvbHocZB1WcWdbXZt4FcOdnivLRWcsv2E1Et89U/
	/m83yNOpS3luIs4Y8Z2rUDP133KkpSM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kDf0pMZ6;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786350247;
	b=0f6+swa7a0DBAKZXxK+p/aPVGn+OBAbrUasXLZ9Bzw5g9/kkoDxLr6Afer+V27ZfVO0Ycw
	gvihN20n9hDcjxmRkXgJOaIH1hPhTFUepQuMUSGL6GVBf3HccmhJ1dth8HCduVbF79yLpI
	hcHfe6HOjH0gERhOPXm1A3l/VA6NHJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65671423E4;
	Mon, 10 Aug 2026 08:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ABA1F000E9;
	Mon, 10 Aug 2026 08:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786350246;
	bh=za/dgLTVAKpnAfno98BQIXcUPCYXTejUD5HWiea1RH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kDf0pMZ6OrhTueAr8AycS7nuhFdWoL9WvStErXhNm3cYqWa7kU6wjtfmC+OyLrVpv
	 4vcetwy4RP5rGzvLxz/ApRu7FEj2/8mu0Fh6OkbeAkVHL0lYg/YY1rtEXL3U34Y0TE
	 h/SotQuCdSuIzeWasbGnrYi5yUA8CXqyCUUIcb96YUOQV1vHmzJa8E/I7DIdaXfJVH
	 knYSokPq7zwOwZF+tta9poedyBEfuUZEQezEhdexuDZ9331hbNSKqpN/by80TRaAK7
	 2Br7Dnjo0gE0pQovl+l+bj5eaQqyd33PsRgF+ysKBRRemFMcwTWr4U33sHePjaQ7Mf
	 j/Fiqqabfzcmw==
Date: Mon, 10 Aug 2026 11:23:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Maxi Saparov <maxi.saparov@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sdimitropoulos@coreweave.com,
	Maxi Saparov <masaparov@coreweave.com>, stable@vger.kernel.org
Subject: Re: [PATCH] kho: do not reserve scratch memory in the kdump kernel
Message-ID: <anmKnlBmOssfqdbL@kernel.org>
References: <20260803193938.8778-1-maxi.saparov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803193938.8778-1-maxi.saparov@gmail.com>
X-Stat-Signature: ujugirpd37s64s59bb3os1z8ekspzre1
X-Rspamd-Queue-Id: 75CCDA000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786350247-55169
X-HE-Meta: U2FsdGVkX1/vXnkXE4cM2p24BkMU9JErRBcdgie6Q6scL1T3JI337mhrwobcnmhV+iGUoWz3py39qkmQlDZquEyb9GWFP61htqQyyNKNzA0qIZT7vUIPrL6Le0Dcp1lQMO9nb5tH7Q/hK5bL+Q+TEeai2Pxu8uKdtD6TiR5jH6LpB9/yO3vog3sKqQWvsxl/MknhOd+LFTOO1H5N3edvjYtNMYASHOt3LQ9vgKKPoi06i2vEqoT5Gz0ctZ4zdZ5PgS7F0vZc5aqUQhHIQGe5NdpBfpbO4kyhReXtXZx+wD9Q/PmwIVipddnqpOm19tdnl9/QDqhrkuEHNZDA9VXHJpZaJhbrqjtXy7VrGPhGUpqyQtdgp9d7r623WiHGw0Hxh53vZ551jXnkcqPD6gzuow9HUHHzOQTmS+qi7rR47zjdbhoeZ2h2/8vCxkXyUgVfl27qSz6dvBg5Jg8w/+ENWcQNU/VJ96OKqtWow9uO4/vbfbWyDfO5KXR5FefQ+q2Nfys/S/irRTSnIh0q6LggInqSMkmELADuqNBZwkzeNoVmHo4EJp/2ox4IRUGSSfofJOOC0T73yE5LKjvxeYR5c64Icn7lAQScjr/B0559F2j+/jG6P6REU14wsdIfbYruoK37HYZwguws2/IucpE7kECp6R0M4lrNu8aqea5VnZc9ZXUK9fDazlLhl6sfuZ47IcgCgflLXbi03RAHt+F7vDpOJUNDEvc1d2iHSkRAz/gMb6vsnfvnjvryLwWRRVGps/DkXzvxNzLgFFzDiEFatFdu5m2LNirHCFkIB5pTBAPPusqkZ5dDVHJu4LCpaNX8r7BZ+mz2DhdFr2l8jK7mB+oyzWGe1h65+NYOStsIxfTBV5EUdDDfbVFm7Yycpbona7lVAgJsP8q7cgmBTTAGX0mezzDJ2p/3i23sAGPEnT1OXYKPZpQJG1zrn5mBBCGrj6F9nTCvIAnr5fhFNES
 95yy+z1Q
 zK3enZvsJ1gfb40vLFZOlITjcrOV+X4Ao4bs5+mf3Yg64hDMeDLvK1wOf+s+w+QkgixDp5296EFHjh1rE7cbErznElU8yjHmr6/wMeflARkaaBCL6NJ9SaNh7WWqqlQfK4k7UUExWD3FWVzypYBETrMTt5FrRuSCxv3l/yXuAAyuSYaP+MsQwM0OYKSEK3iG1o2dlshbvZG1WlY3rlU4eLnrYayIlA4KOOqNxSRhYKDAUL5tNk7BBGCE3/p+ZplM5s0b4DI6Kz5frnR7dz0MROz0lrt62Ib2pvKCXzt7VKINLyjjDTYnK6e7fe4VMlQcSD8Ew9kGDq7i0xvaPOfhy0aVOJEcHYITTgdXSE9zXsGXCvcUJDNqH5NpZpwhmEzTc1aZr4sB2295mUfqdHD98weu8A0fqmK+V3BYZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Aug 03, 2026 at 03:39:38PM -0400, Maxi Saparov wrote:
> From: Maxi Saparov <masaparov@coreweave.com>
> 
> If a kernel with CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y (or kho=on)
> does not receive a handover FDT, it reserves KHO scratch memory in
> kho_reserve_scratch(). The function computes the sizes from the early
> memblock reservations of the kernel. The default scratch_scale is
> 200%. The lowmem and global scratch areas each get twice the size of
> the early reservations. Each NUMA node gets one more scratch area at
> the same scale.
> 
> The kdump kernel always takes this path. Since commit a6715d7ec472
> ("kho: skip KHO for crash kernel"), the kernel does not add KHO
> metadata to the crash kimage. As a result, the kdump kernel never
> receives a handover FDT and always reserves scratch memory.
> 
> The kdump kernel boots in the small crashkernel= memory reservation.
> On our x86 hosts, the kernel and initramfs make approximately 176 MB
> of early reservations. The scratch areas then use approximately
> 650 MB more of the crashkernel memory. When a large early allocation
> fails, the kdump kernel panics:
> 
>   bio: can't create integrity buf pool
> 
> A kdump kernel has nothing to hand over: its only task is to dump the
> memory of the old kernel and reboot. Disable KHO in the kdump kernel
> so that it does not reserve scratch memory.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxi Saparov <masaparov@coreweave.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6fad9152387a..53b59edb5b36 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cma.h>
> +#include <linux/crash_dump.h>
>  #include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
>  #include <linux/kasan.h>
> @@ -1636,6 +1637,9 @@ void __init kho_memory_init(void)
>  
>  		if (kho_mem_retrieve(kho_get_fdt()))
>  			kho_in.fdt_phys = 0;
> +	} else if (is_kdump_kernel()) {
> +		kho_enable = false;
> +		pr_info("disabled in the kdump kernel\n");

Can we put this on top as a separate if, like

	if (is_kdump_kernel()) {
		/* disable KHO */
		return;
	}

>  	} else {
>  		kho_reserve_scratch();
>  	}
> 
> base-commit: 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

