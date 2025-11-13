Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CE5CD6E5D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C168E000F; Thu, 13 Nov 2025 08:38:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74898E0002; Thu, 13 Nov 2025 08:38:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0958E000F; Thu, 13 Nov 2025 08:38:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967D18E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:38:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A25F12E738
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:38:13 +0000 (UTC)
X-FDA: 84105687666.23.6E25EE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84A4912000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:38:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2SPT7ui;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763041091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfD2GOhmqGS/IRFGsSYTtE2Apqd3m8sQLxlr+K/TGnI=;
	b=Eie5QAS3R/k+bgzaLKG2Kfph5n8StS1UgGucX8UtZpvYyzPYXCgOV0ZKa80CV4ilZN2+bd
	BBo/A/kcDpxUTm/PuKVdmcOQWoP0dndGyofiKAjeHFrLFch6pkMpPxg47SWMgctOD6buoa
	nQgcp3EhUqMir0T9OCrH6Y8G8tMJGOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763041091; a=rsa-sha256;
	cv=none;
	b=MTehnXlyr/0qCbXEiG62vwmecrTUqJqnVuZR/3BehmKmTZ6Nh/0aohKWqRw5GhUCcP7sjb
	2uh46DucwNBCAwkg2RPww5SJt45OkExWI3M/lcqeJZnYBh7heABjF+HGsMhV2CG25232/U
	4LlQSXEeW7qIrHuQcVAC3KMZacFGwVg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2SPT7ui;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 441AC403F1;
	Thu, 13 Nov 2025 13:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363CCC16AAE;
	Thu, 13 Nov 2025 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763041090;
	bh=TanqNDDou92JeIIiWS3c/wMf1Ii6b9BkUyE/vwk57VY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U2SPT7uiGDnCCG6zb5qV815Sdj+r/uoSMOEc9j/lDhdWJRl6ShlV3SlTJuqDT9Tgk
	 RFqKZr6iJlXWjCYWomACcsJ9ChroZfCyo9zV3HtJ+rhsSZp8cOA5ZLSvx9UykS0IlE
	 sObeATI2JOfkex303JF7L8VsylgtKzcJMtxpc5OB2cLwBE0nBgoPsmDmbuFkOY/lYw
	 IHqX06nHuXISwbnGRAH11InGI6hhbI8mTYsSN1dTFb5KoYyEe9EtrJBRCEg2qK0fhB
	 H1BCrwQp8B38S+H3T7Xw/MFbxm0/tJwuhV0uHb4Iaum1bU+pryW8wlml6fPOM/Fadb
	 TVU+5ngjiikxw==
Date: Thu, 13 Nov 2025 15:37:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
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
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 01/22] liveupdate: luo_core: luo_ioctl: Live Update
 Orchestrator
Message-ID: <aRXfKPfoi96B68Ef@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-2-pasha.tatashin@soleen.com>
X-Stat-Signature: jya45asp935fen3ux741cjhbe1jy5jqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 84A4912000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763041091-140800
X-HE-Meta: U2FsdGVkX197SnFdlCG2E6FVPk8lzctYtQYxPIUJRFjt2c1PrJoIVZ9vDt70SCb2DxuQk230IdZTKCOXOszd4HWiDvoOidovWQkqtKfpReqwQhiTcNrt9nyfXaE4CAPpqv3b0YsMp4p4iK4pPQg4crJhKg0y04WSxuKRsu8AlssbCZzDJ70NxW+tr4Q77GQaRvEfr4ZxaWSyxDL0vXsQpD7HL6nqtczW9++gQgrD+9GDvudIdbvsBFIDHBtdUz2LzV+tcVnZZoBQ3BUe+jBJagKIkujAbI9LoAAgTG2Uy6Vl8rg2B0mS7oX62A0VNquLGWecWT97S6LVp3Bb5tg80r4V5aqVS63fMwt8OrKI10QEBcahATFPqfYtyLCicEx3S5JKuMA3sLIqj4+9598PXeGK3iW+vBn9Q5JZQRzMHFuG3u6M6iAHpwIbLBKVq7PsI5TTYcznevzPXtEAf6GnMQ1bZqEZn3Z1/6qU/J89zHRIJVzM6ZjstX5DOFRm55/bZ2PzCeYqB2wxj4aPoYqC2KtnNRIH1e3kIZoDbu28Hk4LPPbekXJLNPFQZdaZC2SkbCJD3QAihBUssV2uK8DcOtCUO2AF2oEK3G84g8uLZmriBOZJV6SBBHUnorqPHqRpblV28R0D82kEc6wwUs6T+a+LiA9Oz08zK11R+kix7CvJe4FR0ov3LAmN3/twrJdW+w0lZE4YerCvMRXIXVL/F6+2bfLzkcsU7QOy1ame9MPz9YoZSMwTbI/7Z9w6KHSPyjYNk7D9rNieL1AB2pQP+IL74xSQbbO7PIqPnmPqUnK47N6CqJ6Py7W/I2glQTD1TUazJ3QcZZ8c8MtX9ufhlOsjRRaDue/tWsacEcysff8cmGDK1dVNkwyduiQsTyTcE3AftkCHt8h8DU7mnQKQ4mHleG4BUWSFtILZyjCa7IRfpBQXu8T5jloVua63vixl9pWyzo0QIl+qXhgIGBN
 G04QeAdC
 OX/6a+yJKczYs4tZ+FvZ0lROaVNgG+dCZW1VwdR695LKY1o/JYjHfECHmq1ahGn8AxAna6chzAuFsUqRbePom25DrBDpqOEHtLdHMQLjhm7K9mVjTxxreWsyuZl+0/Wbuds6MHjR/vxkv7H9ULr0NoPulAAupbnqa51AhyoZ4umtgpDvqH2E3eP2Fcg+hRIsBUQXjaIqn4UGwgBpvtGeJbtFk0wtOsQ0ZXl35lECd3HP+plbugyzKfU4jfWkEx3f16U+hDl72hmqOXI2aDp50fzoOpAdPeXaziiz5rvtAkiofxqTzQhjsUDc/3I8FncP9ltt5hkFLNSvZjyAfPxD0G9Wcv4sWfXoa0QHs7P90pd35i6TMPUQbvPNkc9gMb4ZJH6ISLnOg6/EwaqIIvjNc/qbePuq6hVHcFWsxJjNzZn/oU93o45RaLUMr4XCIDH6amwSYE9FgZyCjPNyCTTKgukpVZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:02:59PM -0500, Pasha Tatashin wrote:
> Introduce LUO, a mechanism intended to facilitate kernel updates while
> keeping designated devices operational across the transition (e.g., via
> kexec). The primary use case is updating hypervisors with minimal
> disruption to running virtual machines. For userspace side of hypervisor
> update we have copyless migration. LUO is for updating the kernel.
> 
> This initial patch lays the groundwork for the LUO subsystem.
> 
> Further functionality, including the implementation of state transition
> logic, integration with KHO, and hooks for subsystems and file
> descriptors, will be added in subsequent patches.
> 
> Create a character device at /dev/liveupdate.
> 
> A new uAPI header, <uapi/linux/liveupdate.h>, will define the necessary
> structures. The magic number for IOCTL is registered in
> Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---

...

> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +
> +/*
> + * Userspace interface for /dev/liveupdate
> + * Live Update Orchestrator
> + *
> + * Copyright (c) 2025, Google LLC.
> + * Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +#ifndef _UAPI_LIVEUPDATE_H
> +#define _UAPI_LIVEUPDATE_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +/**
> + * DOC: General ioctl format
> + *

It seems it's not linked from Documentation/.../liveupdate.rst

> + * The ioctl interface follows a general format to allow for extensibility. Each
> + * ioctl is passed in a structure pointer as the argument providing the size of
> + * the structure in the first u32. The kernel checks that any structure space
> + * beyond what it understands is 0. This allows userspace to use the backward
> + * compatible portion while consistently using the newer, larger, structures.
> + *
> + * ioctls use a standard meaning for common errnos:
> + *
> + *  - ENOTTY: The IOCTL number itself is not supported at all
> + *  - E2BIG: The IOCTL number is supported, but the provided structure has
> + *    non-zero in a part the kernel does not understand.
> + *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
> + *    understood, however a known field has a value the kernel does not
> + *    understand or support.
> + *  - EINVAL: Everything about the IOCTL was understood, but a field is not
> + *    correct.
> + *  - ENOENT: A provided token does not exist.
> + *  - ENOMEM: Out of memory.
> + *  - EOVERFLOW: Mathematics overflowed.
> + *
> + * As well as additional errnos, within specific ioctls.

...

> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -1,7 +1,34 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Copyright (c) 2025, Google LLC.
> +# Pasha Tatashin <pasha.tatashin@soleen.com>
> +#
> +# Live Update Orchestrator
> +#
>  
>  menu "Live Update and Kexec HandOver"
>  
> +config LIVEUPDATE
> +	bool "Live Update Orchestrator"
> +	depends on KEXEC_HANDOVER
> +	help
> +	  Enable the Live Update Orchestrator. Live Update is a mechanism,
> +	  typically based on kexec, that allows the kernel to be updated
> +	  while keeping selected devices operational across the transition.
> +	  These devices are intended to be reclaimed by the new kernel and
> +	  re-attached to their original workload without requiring a device
> +	  reset.
> +
> +	  Ability to handover a device from current to the next kernel depends
> +	  on specific support within device drivers and related kernel
> +	  subsystems.
> +
> +	  This feature primarily targets virtual machine hosts to quickly update
> +	  the kernel hypervisor with minimal disruption to the running virtual
> +	  machines.
> +
> +	  If unsure, say N.
> +

Not a big deal, but since LIVEUPDATE depends on KEXEC_HANDOVER, shouldn't
it go after KEXEC_HANDOVER?

>  config KEXEC_HANDOVER
>  	bool "kexec handover"
>  	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE

-- 
Sincerely yours,
Mike.

