Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66840CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 07:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF0A8E0008; Mon, 20 Oct 2025 03:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD68D8E0007; Mon, 20 Oct 2025 03:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12FE8E0008; Mon, 20 Oct 2025 03:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90AE18E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:56:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 235BE160761
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:56:43 +0000 (UTC)
X-FDA: 84017735886.02.0FED9CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98479100004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:56:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPvzBrud;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760947001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/ZcBmXO73drWyKg86mBkjRSYkA8unrIJR4HoLPBir0=;
	b=ZknNkP+S0y1HjKtKOQt7RyAJUO6JJdbhKrcQ69FizShd2LysLFZkfc4OCfBwxy4hKcvrZ4
	s0JRvHY9GmdZ4otoSQKS0jj+GSEziNDf334CQBR4ZutQmpwl5MZ35+nNhyItX+fL87q0ce
	+b6Hmxxn+AXemyV1RhKlcIqVoZ4HIK4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPvzBrud;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760947001; a=rsa-sha256;
	cv=none;
	b=ddfCVrHJ9BNW1Ipp6zPYBmzTEr7sZx01qEvFDU8e6xilO2pxekdhvxt3Mv6udYO45+6osV
	2nAfY91rkCjNdtCShmoRNFnwvZSBl4G0N3+crMWV8GeRjKoGFaHjZhLaGGOCv+53fTSVqP
	SI0nD/AlOjX6karSzWRBtpeT+eHcOeQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 010946149B;
	Mon, 20 Oct 2025 07:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB5C4CEF9;
	Mon, 20 Oct 2025 07:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760947000;
	bh=vHuyvyDutqP074TwQ/Do5qMwy1i/7b3uTyvUv4SmVP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPvzBruduJpLGbmc+gGMxSqlCZGgUaMYOmotAJNyAGv8lconA3N54WyhQvJYaKpAN
	 wVlVdDJgtLaOv4mAqQnf7+FeDC/ig0Kdg3+yGfj2Hbh1L23LBMblmmdlQkmWruz8IS
	 1fTIRQs58pOwelCT2s9zGARgTZVnNE3Pm8+UErk0klGpDVBfNrxbC8RPxsbecx1zIu
	 QHBG4rNFlOITsbRfgMu6XzWoOajmopGnocmA4baJH2oKjpPKPhZlfT7BtlBdsODQuv
	 X8XbfS5V/8aV0l/vbtv5A7Ofh8MhISvZA/jlKUcnMypOMZrd135ADs/PA/q1/kCzCk
	 ceO6mE5UiSMNA==
Date: Mon, 20 Oct 2025 10:56:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v6 08/10] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
Message-ID: <aPXrLy8BmblbLpCG@kernel.org>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018171756.1724191-9-pasha.tatashin@soleen.com>
X-Stat-Signature: k56sp9k1dc9kgmhajjfw5r1yco31a93b
X-Rspamd-Queue-Id: 98479100004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760947001-328803
X-HE-Meta: U2FsdGVkX1/fMlRhRgB6mBZPmdETDhj4I/aZb9y57uUfioHatJW0C+O54yeYCkR3cXhB4qQz1Z2gxWpcPWN9VsWuywK3MNSYc3CTn5xEPmm8vyyzMNX4418zisqzDlk+MKc09VDyTHXRp+p05uy41J7NBms07b36RLUtu+QWAmMwbRMI4iQfEmmJiqNWBckxVJnjC1/87YCyNVjLtjUnNH2ZGZE9mBaIAgrZF/KaZIHsBAG5Gk9Mkx3zUQInqZzzMWdMfveWz3P7tyCmXm5cq+oYi1zSzo2bz6f8hP2aHnPsjT7Sjsr1jvday9M/wFPOitnsKfYIvKI3KUlpnxAPgI0k/+Pe90pgd+mKOxwePwp8iTdS7GtB0B8Z6GKehXaffyyr+5upkJM/4bJ2aj1E5cOdyiANtfIpa4BhbWJSvTwUirOFd2wp4PZ0sa6H1XncYeK2PA1D5c9FYuorUzrBjVwQDGXUbJpMhINVAHKKTPEVuYBzhjsQVWXhWGWqilVC6pLhly0+F2eun7nYi7gymPViYSBnAMOHzhrdBRT0ZvJ+2AMnJO+iB1g7fTCGFfIecJrxZfxaxad8unMSZZT8XdIlfXntbpOf/aswCGenwI1SYJj5Juv0rbipY7dNP9AhSwDgq/l0m/5iix/RuDexJijie1KP7SCJYLs+rbadhnnxgzl2xRur7rAGTgAZ5+tAkOSGobUgH1WnrfzIPoV+IW85tsGaaG7p/3+bm0mQ8KHpWVW4+WmEyRZLCv6x3TXiihU3ji5n7/BTKprDlEWmE4ePh1fsBnvzz8NFfW8AdE29ShNVzU1IJukrmu7H9I0G1wjNCllXo2k/MVsTtlji7Gp3CrLa9jbs3jB7cWS13OnGwW1EfmHjmm686JLN2Uh0k0V7GhFdpXJtDwv/1lCMOIcoeCtNysjHbKyr76uU+b8UMcIER7wWBg1jtWEDnevqSbZQit7NyGRzrcBNoaZ
 LSVkWkMT
 FqBGA6jMIuJGGxDqZV74j+fgVWVGoZE2GDjTTzYsCxd8OR2nut+S+oPmeZVV3y+t2atXim3efLuA2ACYzxLj7W3K1pcZ+SqapEvpChfW+xffl9l0VUTOzVMq1G4rD1UYLzrYINmrBV8z26uBTGDkaJYLVMrH9uwWUxjbHxX9HPZ4wdn/rOXtfKfS1wsT17H87o/qMHwuB6la/BJTrjRWW+R8ZWPxEzPt4ktayU7uoLuW6YNA893e1jLr5uadtJCyRO+gG9aBweGkv6cRPmOFxTXQvc7s/ncHUTWc0etRXFj12G4uAF5Vscn5KnKz32KgY6zgwFGKx3v7aIUUmmRtGa4px30d+78JVWLEVhwtV+xnlJP2KohjaT3E65o/WkCDRv4q8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 01:17:54PM -0400, Pasha Tatashin wrote:
> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel. This can
> lead to memory corruption.
> 
> Adds checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region. If an overlap
> is detected, the operation will fail and a WARN_ON is triggered. To
> avoid performance overhead in production kernels, these checks are
> enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/Kconfig                   |  8 ++++
>  kernel/liveupdate/Makefile                  |  1 +
>  kernel/liveupdate/kexec_handover.c          | 52 ++++++++++++++-------
>  kernel/liveupdate/kexec_handover_debug.c    | 25 ++++++++++
>  kernel/liveupdate/kexec_handover_internal.h |  9 ++++
>  5 files changed, 78 insertions(+), 17 deletions(-)
>  create mode 100644 kernel/liveupdate/kexec_handover_debug.c
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index cea287842475..851d1a22b4c5 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -27,4 +27,12 @@ config KEXEC_HANDOVER_DEBUGFS
>  	  Also, enables inspecting the KHO fdt trees with the debugfs binary
>  	  blobs.
>  
> +config KEXEC_HANDOVER_DEBUG
> +	bool "Enable Kexec Handover debug checks"
> +	depends on KEXEC_HANDOVER_DEBUGFS
> +	help
> +	  This option enables extra sanity checks for the Kexec Handover
> +	  subsystem. Since, KHO performance is crucial in live update
> +	  scenarios and the extra code might be adding overhead it is
> +	  only optionally enabled.

And empty line here would be nice.

>  endmenu
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index c87d00c40c82..ebfc31814d16 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -8,6 +8,7 @@
>  
>  #define pr_fmt(fmt) "KHO: " fmt
>  
> +#include <linux/cleanup.h>
>  #include <linux/cma.h>
>  #include <linux/count_zeros.h>
>  #include <linux/kexec.h>
> @@ -131,26 +132,26 @@ static struct kho_out kho_out = {
>  
>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  {
> -	void *elm, *res;
> +	void *res = xa_load(xa, index);
>  
> -	elm = xa_load(xa, index);
> -	if (elm)
> -		return elm;
> +	if (res)
> +		return res;
> +
> +	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
>  
> -	elm = kzalloc(sz, GFP_KERNEL);
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))

I'd move the WARN_ON into kho_scratch_overlap().

> +		return ERR_PTR(-EINVAL);
> +
>  	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
>  	if (xa_is_err(res))
> -		res = ERR_PTR(xa_err(res));
> -
> -	if (res) {
> -		kfree(elm);
> +		return ERR_PTR(xa_err(res));
> +	else if (res)
>  		return res;
> -	}
>  
> -	return elm;
> +	return no_free_ptr(elm);
>  }
  
...

> @@ -379,14 +384,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  	struct khoser_mem_chunk *chunk = NULL;
>  	struct kho_mem_phys *physxa;
>  	unsigned long order;
> +	int ret = -ENOMEM;

Nit: s/ret/err/

>  
>  	xa_for_each(&kho_out->track.orders, order, physxa) {
>  		struct kho_mem_phys_bits *bits;
>  		unsigned long phys;
>  
> diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
> new file mode 100644
> index 000000000000..7986dcc63047
> --- /dev/null
> +++ b/kernel/liveupdate/kexec_handover_debug.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * kexec_handover_debug.c - kexec handover optional debug functionality
> + * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +#define pr_fmt(fmt) "KHO: " fmt
> +
> +#include "kexec_handover_internal.h"
> +
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	phys_addr_t scratch_start, scratch_end;
> +	unsigned int i;
> +
> +	for (i = 0; i < kho_scratch_cnt; i++) {
> +		scratch_start = kho_scratch[i].addr;
> +		scratch_end = kho_scratch[i].addr + kho_scratch[i].size - 1;

I agree with Pratyush that 

		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;

		if (phys < scratch_end ...

is clearer.

> +		if (phys <= scratch_end && (phys + size) > scratch_start)
> +			return true;
> +	}
> +
> +	return false;
> +}

-- 
Sincerely yours,
Mike.

