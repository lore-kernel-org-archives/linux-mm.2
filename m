Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B118EE4983
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E186B0088; Tue, 30 Dec 2025 11:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8626B0089; Tue, 30 Dec 2025 11:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAED6B008A; Tue, 30 Dec 2025 11:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 703EB6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:27:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A6C31ABED
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:27:14 +0000 (UTC)
X-FDA: 84276667188.02.D2AF46E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7AD844000C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:27:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nJFe4Uey;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767112032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cc7YiftCyK4iK6kMX/CRY41z53S9XjUdaMgEdWd8gxU=;
	b=mOIOZMJKVOAzsp/7en8Ln/hO7659uC6pOIBHA5zF4dLigt2B2WMqY81u+8owDFAFMMbzRn
	KpqNX3e8/azF8pIO56MGjgA+4+WNW3DDRUtNLD7nWCYO4nf3sg9/2JOZM3nS26MNna/GF0
	Po4d7CU6Yp6arCm09+hN7UmkfG3EsJA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nJFe4Uey;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767112032; a=rsa-sha256;
	cv=none;
	b=8lkAiITeR3XGIYtkvyA7OFFxBBEamWhaGWQBoum5TTNOf9yFnAg/CxZSgXeHu00uW9rTBJ
	fkHsDi5wVwvNsZScVDOUuWM9jB2O1MTbzYYIMlihcKVf7olNSOCc8zU2othKd9YYmCGZ/9
	EBweNCx5YtcvquorTdgbOC0FH/8s7XI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00E406000A;
	Tue, 30 Dec 2025 16:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB010C19421;
	Tue, 30 Dec 2025 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767112031;
	bh=URTkQfEAZsZH5uYz347syQqM6OdY1oUoieji2FfUxl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nJFe4UeyWaKz9zZyFi8M/Yl+ti0cC3DNxJmjnyVILaLigSgcAWjL8c1z9/GRVLeg+
	 KZ53Fb9hyXY9X8B4D4oq9cfhoPbHE6j6+UnCLGPZGmog29rqEGZdXHartFEUbkbP6c
	 Hq+A4VymM2CId3nuCPUst9T+/SdYG7s4dO5p3zKgL4Vojbt4N3hrv37CiWXplVVDFo
	 JwLMQfLGxq+H5HjIp2z/mYIoGmdyuMCe2Au9ISc+X1FcVN3Ls3MHz7RhctN4ZDPCD6
	 yL8mTOaZDUe2CV8+esu8STEotLp4kP0s9FdYSHzDiXPYc862olBt1Hid09o2F33bfg
	 jUiE0Oq3Az5cg==
Date: Tue, 30 Dec 2025 18:27:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, pratyush@kernel.org
Subject: Re: [PATCH v3] liveupdate: separate memfd support into
 LIVEUPDATE_MEMFD
Message-ID: <aVP9Wr65uJtq35wR@kernel.org>
References: <20251230161402.1542099-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230161402.1542099-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: ao54y874qne9399fy5jd17kzppy7f5pm
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AD844000C
X-HE-Tag: 1767112032-749794
X-HE-Meta: U2FsdGVkX1/+ULIAIZPV6YDl51p3CM7H81EnfWx52g6qefr3hcAdRoCqZVyrzJa/JeC/h+JkiYJ++nUCHNsSxAyo7FyejKs6dnZ8Mnu+56yAVNlHj57h5R1H5RC+5wlOHSYIwwQUgox2S5Lrjwm/Ktmd9fBAxfgoi4cIqp+wKiixfr73DmbVgD5FGi7MQrBOs9GltV6yG6I1F5kgWOuFn9G0Kwb99NJoUGhtyC2PSyf6E6575m53rS/i62FEJ8IW+RSzF2rs3umzbVAPAYeAL97WyiT/PfVtUQ30ePp2Ok1SLRstoYL5PFI7DrHKOX6KoKHRgO3h3UV6suv3WjbF3mzItu9kuORmcPIROhJjtZ3KqpEj5n1vyb+xAKqM6rNQoFRmX+oSt50g+LX3N2Y/k3k5SN53DMRkzE66vJ+dYCPU8OaqjO4k9sEawASVN3CXOb9vdjIAoRJPCtYmhz6ewjitbm8i8q2r5pOK6GR+6FGsnYD9qM7amo4QXaEOLkEYEBttdmA+YNoXrVUEuIOLQD8bPc3Ar3sXGVl9u6WELEryHxcr8faFuNJD7q6bDVMS7gAhH5eXf4wuJ+2ElG8f0l1AleIcS9mDPEpq4dBmA0GZDsokPtlp8DNm3RFNuudjHOhLvdHQeqUYY+q4jFW5TGH66V2+TSUnnFQF8W7Oib9Iz3T/EPYre4P09nYJXGa9hBPCfQfEeW0ZLyYWgUoVuftpk7gJnQ4O4zoSWYzMcb3efvjD9Nz9MfAoQOzp+u9cPisdMsw4g3JKI5+itUh+2glzbfp0IsUeZcccZ5Tan5FNImw/Ru/lUfDF2kq0Uejp8gzPtnNOxgQPgoNvxq3xtPDH8pHMDPgv3z1wrvYIeTbpzWO65YffEXn2nzfKYgJPUAwVoyK7uNkuSj14sAHexWhp0J0UnH7BDgnBrMQcXEhfHsB/MIx7+jPywfJzIKVXp31MTPwPFruMPMPi56e
 Syba2TkM
 31Siuyay05kEmkAVLl0DRMopWiAE4e7o1AdZmbqL4a/jHiZxF22mXRiy3g6jFWL1KsqPIjOnYxQoMWkIy3QmzWOA7PjvtOTsu+E/YAxzmMoOwT5sR9i6TKBdG5fVu32Mk5WkD+pdkoNhj50GGbhuxGI0kLrMm34tiVWJ2ppTEAmtX3ojvCD8poreDiBT1vTK/wWojoSaBXIp1Z91WIg43SBah5eBAXkI3nuuaBvWMc6KWIXjQZclL2H3bfXZFPlccIiwZeEbCVd9PNtc12xFGO7jtUG5c7mAYu/cyhVxlP3xkT3/qdhCH8RSKsrc/7VHae4vmrG7C94Hs4HU6iT8XSkRQhSHNlrRIk7w/uGlIgt+buWZ0CWHpvHKWMALCXi++NNx0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:14:02AM -0500, Pasha Tatashin wrote:
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes v3
> - Addressed Mike's suggestion: added default LIVEUPDATE, and removed
>   config from selftests.
> 
>  kernel/liveupdate/Kconfig | 17 ++++++++++++++++-
>  mm/Makefile               |  2 +-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index d2aeaf13c3ac..1a8513f16ef7 100644
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
> @@ -73,4 +72,20 @@ config LIVEUPDATE
>  
>  	  If unsure, say N.
>  
> +config LIVEUPDATE_MEMFD
> +	bool "Live update support for memfd"
> +	depends on LIVEUPDATE
> +	depends on MEMFD_CREATE
> +	depends on SHMEM
> +	default LIVEUPDATE
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
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

-- 
Sincerely yours,
Mike.

