Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1396EE020B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E0E6B008C; Tue, 30 Dec 2025 10:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235236B0092; Tue, 30 Dec 2025 10:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15ED56B0093; Tue, 30 Dec 2025 10:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03DDD6B008C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:30:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4D6C1A0659
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:30:29 +0000 (UTC)
X-FDA: 84276524178.07.642B0FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 234F64000B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:30:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6pLAvqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767108628; a=rsa-sha256;
	cv=none;
	b=eFkJOLvxmkjayU8Fa4todwjatYhxmeEElu9kTYYiOBS0jeTZ0CUJ0DPH4QqEu76EJqDQiH
	zMCzmz6qYRTWyiTRwH+btGs1/oDZ7xDPhYUV0Qy0/mtFDOXx8FAxB86abVXn3J1h8BEN5Q
	R/S9lxXB5nZCAtvVewSxv6v6cwaY828=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6pLAvqJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767108628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4vStQySbnFbRSc3fL5cUUesJh1Q9sJH3CZFhqbQfcI=;
	b=dteTUtDNa5YizehyMX+vtIbhxkkXzn2xLEk0G74WiZsVM+7FwMp/ab4XafX++hpwlWQyAu
	aDq1NMJUf7rs15ftp62IWmfeM91kPNwPuIlUek9ygQwmK+LETfH40wR6pgpINK9nOxskxR
	vVHVdlW8T+Iys+6nSH+6yD4t7k2P5HQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 445C76000A;
	Tue, 30 Dec 2025 15:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6F1C4CEFB;
	Tue, 30 Dec 2025 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767108627;
	bh=0dE68WcD60xA8yJuQhucOpbV5dnLhWL8/6hmbXn+bXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B6pLAvqJoD2wkhHEwaUeuV+6xL06aIliQcnWlG9oU1oj25ZNAGaHe5rWYLCgXpLDW
	 uGFVrQviJPfhgjNIKlrW/m13muQqTcV+GswjaxkP2P2ybi9YBQwTC9TUYuObN/4y/J
	 +aQGP+OLr5YiU3UEh8mmXz8uNVzMS10agnfuvaGmJhOQ70q76bzpTdJx6cDyNvGGSk
	 O/xPfislK8xkeC31BvDqZcpPr4mZguZ+RVmVrJSyLZfDCgEMSeKUE2tY/jNEn84sIq
	 /Tw2aI4CLTzBxyERKIFIBg4ZgiozidmfdbRBgErhUdsJVVmdTPvdQFVgzYl4edpz98
	 +wMvmhvQXjrDw==
Date: Tue, 30 Dec 2025 17:30:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, pratyush@kernel.org
Subject: Re: [PATCH v2] liveupdate: separate memfd support into
 LIVEUPDATE_MEMFD
Message-ID: <aVPwDdUpNTZ7gUT7@kernel.org>
References: <20251230145321.1512630-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230145321.1512630-1-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 234F64000B
X-Rspamd-Server: rspam10
X-Stat-Signature: 4yyp9ccs4ofj1ju5jtx7wyzb1a8ok9yd
X-HE-Tag: 1767108627-824925
X-HE-Meta: U2FsdGVkX1+gNueteHv078iZTFQYVVGTbZFXMhROAnpucly9dtp4gQ6w5j5HfKm3e2gM1gYwLj5Q5eMZVFVOLlbdbh+VHW/mvkWZ4ZEGax0oD1sOBWSv4CrFyk7mUvF16AAWJxhTIBnV+A0dKoTrRqM6SFsD4NNppkfm754/OljSYW2P/Hi7JWJeMLLvx+K7yVfr0m3VdFqu2xhJCRgrcQFvZ3ANWsu+JXZEmuPlrW+kQO7//EP/CqIuivFv+ZqsXumXOJ3Do6s97TQBlKBhOEuRqAmURNFcis9SUpzcrkjFxIcaFo2jpXj50TZOCHUnxbnVvHSbs9cPiv6oehINdXSGbMLnksV6MiRCWyv2DRT7xp/P7FwjHje1IL5/5xuY8dRqNUPRJ5ZH7Ax14iuNy9KKu7PcjrmmJe/3WMRmFKAGQsmOmXT5RfZvCtvuqdF7097bGQDFMoTmKnnH6nB6wAci8YjwG3D6q7ZMGUyeAxsBbKAcuFNFB/NkF+NWDeLVCBjVH60aYpslB6xVqR6U7mzBNwdw9me8+T1w8ZY/SjXQgUOUtKQrl3SgR5A7kybK1KVPoh+vS+4Ogqx7uy+Ck8a2ZG6nMYf5ejh8Fktl1eZ6pIZ0meTEFh28Q4+bcwRpBTjqZaxbYfGBbXr0TlZ+WGebLiP0kpjbsSF+qjS9w4KdaQr5lVW0kI1NxgBq/pgqIpdeo4NdvXc7KeYi2FwT2ZkhWQVAYh3FwGeQsED2ZjhUfDPWAjh1HOrj2phcOYdbcBf4OyKTDeZvqpoVp8q3VxbQpRMaf5F3ofBdOEw7ugzBsla808z4vAeoU+0kw9Ew6xnzTfZ9kwvrZMZlyH8v0dLPTv3vBU2zekxl6qfz2X70jYz51R4Yv8Cau86lafsszMESQOh9bRfO7h8VwZPV9YASEouW3iViwd0rdPlKkE5Cg2dHBoCSOT7C498EAOUN9i+yV78ODpj/wa0uUsO
 +z61TY23
 N6j2nS7RbZuA34MbooFKH0tx6rn5mLul5MxhLGb8lSCO37+AnRceF9EGDmUwdZt2AeUDfEKFjyuRqxqNhzK5ofUCxlB/LMmT3iUFq3DJTxqChnZN+1eWOF1KXS6oNnF7OXcfhXwon4DOudJCZMzwtN7nBqXkpV2QbKLosHqjvUpPawbb9xsrOjFNtxyM3XmKxfWr0yAyEy4RpP52W7z0LImJbX+/whz/T3tkdxETNRwXIJUMoYbtRXp6fOHvFIWE2xI032+FOihPBQVV5X3jvEIep5eHwohXjbWS43ipINXCuYk0feSKvBirFBEcxHb0ChCMuGGa3U2LoC6imYUAVqx7ppWVd4orrV/Z9bPNgYFGPbTCMTxLbrjTSrQMWws8KDMsn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 09:53:21AM -0500, Pasha Tatashin wrote:
> Decouple memfd preservation support from the core Live Update
> Orchestrator configuration.
> 
> Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
> CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
> Update may be used for purposes that do not require memfd-backed memory
> preservation.
> 
> Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
> SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
> them, allowing the base LIVEUPDATE option to be selected independently
> of shared memory support.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
> Changes v2:
> - Updated testing config
> - Added review-by
> 
>  kernel/liveupdate/Kconfig                 | 16 +++++++++++++++-
>  mm/Makefile                               |  2 +-
>  tools/testing/selftests/liveupdate/config |  1 +
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index d2aeaf13c3ac..9a1a8cdcf16c 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
>  config LIVEUPDATE
>  	bool "Live Update Orchestrator"
>  	depends on KEXEC_HANDOVER
> -	depends on SHMEM
>  	help
>  	  Enable the Live Update Orchestrator. Live Update is a mechanism,
>  	  typically based on kexec, that allows the kernel to be updated
> @@ -73,4 +72,19 @@ config LIVEUPDATE
>  
>  	  If unsure, say N.
>  
> +config LIVEUPDATE_MEMFD
> +	bool "Live update support for memfd"
> +	depends on LIVEUPDATE
> +	depends on MEMFD_CREATE
> +	depends on SHMEM

Maybe also

	default LIVEUPDATE 

> +	help
> +	  Enable live update support for memfd regions. This allows preserving
> +	  memfd-backed memory across kernel live updates.
> +
> +	  This can be used to back VM memory with memfds, allowing the guest
> +	  memory to persist, or for other user workloads needing to preserve
> +	  pages.
> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index 9175f8cc6565..798f04233d71 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
>  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
> -obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
> +obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
>  obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
>  obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>  ifdef CONFIG_SWAP
> diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
> index 91d03f9a6a39..1bfc708041bd 100644
> --- a/tools/testing/selftests/liveupdate/config
> +++ b/tools/testing/selftests/liveupdate/config
> @@ -5,6 +5,7 @@ CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
>  CONFIG_KEXEC_HANDOVER_DEBUGFS=y
>  CONFIG_KEXEC_HANDOVER_DEBUG=y
>  CONFIG_LIVEUPDATE=y
> +CONFIG_LIVEUPDATE_MEMFD=y

then this is not needed :)

>  CONFIG_LIVEUPDATE_TEST=y
>  CONFIG_MEMFD_CREATE=y
>  CONFIG_TMPFS=y
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

-- 
Sincerely yours,
Mike.

