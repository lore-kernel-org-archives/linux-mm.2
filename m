Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8338CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 08:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384078E0002; Sat, 30 Aug 2025 04:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3344A8E0001; Sat, 30 Aug 2025 04:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2245D8E0002; Sat, 30 Aug 2025 04:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5BA8E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:35:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81142140AB3
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:35:30 +0000 (UTC)
X-FDA: 83832764820.12.FE7DCCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BB54D40009
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:35:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QJ2Gq9Q4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756542929; a=rsa-sha256;
	cv=none;
	b=dbC6DoUQyqCjxoLHM3WJWVjHSpEtELZFhEu5epsQQS3Dah6jGbc2vgDwvQo5Khw/Q9sgOf
	bkIsW0C+vSfbFuT+e6r2t1MGd+fJIDYLxGDyLqgYQJA0vuAaXBcwfm3Ox5sz5bE/IQCLsx
	xKkI2zReUXikugwncKPCC0y9hj3M3v0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QJ2Gq9Q4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756542929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJzYHt2ZArNdlTsg/DAqjD5db7Vf+z01tY/frqkBGLQ=;
	b=cEqDvx39ujXEUJwJssIHTKGm6T9fGkh/u76syRVC/Wx0nuVnyAON7uhL5Fa7COM23MHo/d
	hx6HgWWHEAHgUdji60hdyP3F+1N8Q8dVxRvIHf5hDeTpGiLsCzz61FzCRIOyjSjUnpVwUR
	+M0VTAeABNMuYgGCzrk/xWgUHvq68XU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7AB642B66;
	Sat, 30 Aug 2025 08:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DCBC4CEEB;
	Sat, 30 Aug 2025 08:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756542926;
	bh=oKvjDljPLSRg2x/aOWCyZgodbMjJIdmSCcxy/Ed/RYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJ2Gq9Q41CFdV6Q+M16uVYmCXPBnCX6Mtf7wOUYVVkWOIgfiBBx0jlaPa180Cf10s
	 WYotg2neDOLYCEklciQmDeMW3qUzX0UkTa6QROBFiA93CP1SFlmZBKYFWkLmubtmF8
	 6IjAbqmqeDZeZGMSSgPx6Y/SnyNOHjZmt+g7kXUXwVENrl/uCuBffvAtsL/jMM2lEc
	 0lQ2G1Jorwlhp+I8wSJzRGlMX7OxHmQgPe3ubKgbY3jw3rfN6RBNzm/jw+2U86JKgV
	 hRdhGKSEIEL5Sdf+8dpRe+3XW9gqx3VoLY6G1z5UzYe5mU1jAx5nzCn+phxkVTEV28
	 TMP4NOKcmoVjw==
Date: Sat, 30 Aug 2025 11:35:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 09/30] liveupdate: kho: move to kernel/liveupdate
Message-ID: <aLK3trXYYYIUaV4Q@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-10-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BB54D40009
X-Stat-Signature: mprus15yqe76egk9j98nwn66yht81u6s
X-HE-Tag: 1756542928-138725
X-HE-Meta: U2FsdGVkX1/TxXUoJv+gjYqIcDZaQY3he/53OmU9Vy/KOnQpgOqK8r5dEhgWsn4WBUYyEDT1QL0rpCrWn9zowkWyWmc43DN1D+8nICJoJZ1vgIpoCBPq467LwpJgLAPa0I1agdObPz1iP3ni2WoO0Q9s+SLP2M7pYSF/gsy/JWfB/UxIcWu7gr47aoqtSETcbNxi9dmfHLRssuT/ZmLq7nHBrb6vMwMFu1KCYgF9Uod09lfbOAQ8UdJ9QhHIuJZ1mLXH6QuTFPD8wfS0pt6t/mRSgA8xfmUBgm5blSQ53THAPvZTBH7jc2ZWCpvclOXPD8P1M7K42nAuSHLCiGUD3yFOhXZNaRSq6MYwgU7BPJmPhyS8ysdzqnYtrgJmac3yA9dJDruI8gCL7P92XmoTQWMnt7zdnOLzuvIgybCSnxHjpDYhu39WprbH+H5sMVA4qx3/SsaXpse8gScx5d5IRCqXQSyc4vZqcSs9VsYc9VeHd5NSxQaiJbZxPIGC5yjhoi8pb2nzkiHSVbbj7Yyhdsx/Ed07pOB4zLew18BPhk2n3jnsYogq7xi7h3DHJg2Rih0uaWqOvP/CDKMVTJyF7nB6kdiKfKkwUw+Qs/Ad66TqefI9SoWv5zKlJSP169RMt5V1TE+H8WO2NgfbBhlLkLSVifvbc3Pz8aDzbZbVS92kV+OmkJ5/TGCA4cS5CC9/eR4eyjWYFRJM79P2aYHgAO4sHT4AvDPumbdJnGavCsvBDlaTSvHDERIklkyMuPFdhvtAxrklxGPC7xfvBjBS+PkUvXoMYm6fF3RIrJyQKcXo6k/VYWDEuXhzbdXyMIT9XwfO/py3P1hqOnM8ccbvusp/5BCLiLTSeTsr49ZbxU0hNpmf+GQ4Cc790FOPEWq0WSxs/yLeQ/r72pRjUZmC+SRwIGDp125PkphnHW1jNEtd0CbpNcvmrPN7UUe4vLPJu2aoi7kzRL57RkbnKEz
 FScyhUwp
 ITQTMmjr/xEQ9TXkqxKzf7o8evKY/LL7NOwsC2QhrnVz2rvtF2fkq+bEVhburnxblkkR72mBRiFDqvQyNvWuaHNIzTbseP7xvCLooTuQrrXQ2S0QzQ3ur2PDn/Gk3O2a8aoCTi0GQoO1gcqrmdaQ7MU4YGgVE0YsQ0fxkcMLH7SJAj04oSoJCG6WOHKa+7Fi92XS1vlsyV5WAmXuBQbYJLrUAptMBDFiuzkaZGPyBPwMfQkgk/3biGVBDVO00Et8+j0MmCTv+VIVFbAOuRgAE1NVCU3nYxXi8vrfg+tY1fWefRv0yfKxDVxnxUk/DhisiOre1JfV0ta9xeTq/rWF9wH2EsAPQ7ybRk+13wBgUQGFbR8ud192mTBD3eLBW8LU0kci+1tUUoxr32ZkiWbvAbvrRVnxZsVeknq79nV/zemcM9XNz0gN3wxUqLq29/vVXo+iI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:44:15AM +0000, Pasha Tatashin wrote:
> Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
> core kernel related files to the same place.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> ---
> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> new file mode 100644
> index 000000000000..72cf7a8e6739
> --- /dev/null
> +++ b/kernel/liveupdate/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for the linux kernel.

Nit: this line does not provide much, let's drop it

> +
> +obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
> +obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
> diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> similarity index 99%
> rename from kernel/kexec_handover.c
> rename to kernel/liveupdate/kexec_handover.c
> index 07755184f44b..05f5694ea057 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -23,8 +23,8 @@
>   * KHO is tightly coupled with mm init and needs access to some of mm
>   * internal APIs.
>   */
> -#include "../mm/internal.h"
> -#include "kexec_internal.h"
> +#include "../../mm/internal.h"
> +#include "../kexec_internal.h"
>  #include "kexec_handover_internal.h"
>  
>  #define KHO_FDT_COMPATIBLE "kho-v1"
> @@ -824,7 +824,7 @@ static int __kho_finalize(void)
>  	err |= fdt_finish_reservemap(root);
>  	err |= fdt_begin_node(root, "");
>  	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
> -	/**
> +	/*
>  	 * Reserve the preserved-memory-map property in the root FDT, so
>  	 * that all property definitions will precede subnodes created by
>  	 * KHO callers.
> diff --git a/kernel/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
> similarity index 100%
> rename from kernel/kexec_handover_debug.c
> rename to kernel/liveupdate/kexec_handover_debug.c
> diff --git a/kernel/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
> similarity index 100%
> rename from kernel/kexec_handover_internal.h
> rename to kernel/liveupdate/kexec_handover_internal.h
> -- 
> 2.50.1.565.gc32cd1483b-goog
> 

-- 
Sincerely yours,
Mike.

