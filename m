Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F02CEE327
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E6D6B0062; Tue, 18 Nov 2025 10:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476366B00A4; Tue, 18 Nov 2025 10:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2B66B00A5; Tue, 18 Nov 2025 10:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE606B0062
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:46:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE57BBA3AA
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:46:14 +0000 (UTC)
X-FDA: 84124154268.16.EEEA088
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5630AC0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:46:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ct0PkeIs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763480773; a=rsa-sha256;
	cv=none;
	b=31t/6LsyKYXSZMGiUcu36skRVo+wl9PZo0ITWRI5RF3uBkPcJG7dTnUCEKsqGrJML4+dmj
	s3aPvG7+uWYQLHEhKbjQvh2+nn2x6XCL1WdEalipIjojIfKtxoHWXxHJvKNKL/3wOAqCVu
	6nDAzBy0/iQ5xAd6wAAxp+JVloN8hfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ct0PkeIs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763480773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtsS7C8yIMTREBBn3R48M3vH5ibHHbeU/zW99MbkXqo=;
	b=SAn1cFc86f+YFUsi5OGxTyYyr/SjR0+anPfeDXXVTTmrEtvw8TNA7NEQUJqYvXspuE5OxK
	Zd2Szrngu8UIg8MwithqEFlI1U0k39OgVZcQAW85b4gHdAz3SbYmh6K0SM8hOW7LSE3qBb
	RwVB9ogxaWyKHbFAQloD8zY4wswwiP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C99F60125;
	Tue, 18 Nov 2025 15:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA31C2BCB3;
	Tue, 18 Nov 2025 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763480771;
	bh=NvD+wD7hmOypGfZvut1BGQBiSML9gfkbHDd/jrJynOE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Ct0PkeIs59PlX7LBGwYra2RgxeAFbO3eu3CW387XaQ0vnkjlGKnXy1w+S0G/oOYtF
	 3ZEbbLXi1D05J9bfC9Kp3vmdRxAT/lXrLySZHirFUBiRot+9TB2RrRq26O7Vyp+RfT
	 gNP+w3+ra/xuIrI2I1+G366IiaCHP516oJrICW32YHHy2eRDL990BKAN74RCPNZofw
	 fpDz1EdIYhN3k5zNwgWwtSRzGcmztFet9HWsWS4eqFTwcAMlf1L0X+iaqRkb9oxm/M
	 p287zHialGlUvSLnD7038deHegCI7IXtkUuXEri/bq2MleKqO/m3O6QK9Fw7NLVrbR
	 +OOcRa9wAkakg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v6 01/20] liveupdate: luo_core: luo_ioctl: Live Update
 Orchestrator
In-Reply-To: <20251115233409.768044-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 15 Nov 2025 18:33:47 -0500")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-2-pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 16:45:57 +0100
Message-ID: <mafs0ecpv4a4q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5630AC0008
X-Stat-Signature: pdsicdpry8yjewuxk6yrshoe4niz67of
X-Rspam-User: 
X-HE-Tag: 1763480773-235205
X-HE-Meta: U2FsdGVkX1/+tfILlrWdy3paIMRQ0NpfL01+42y9TZvlw4Xng6A4lumAFZLinXMlxzXEVwZ+G9SO7+zuel/Mc4g7QizqsjlwoE8pGdwvTZMmSF43y5EdRnXwrND3K/g3+n5hDxQ9Im7yUXoJJBeQaXprpZUKKSJljlfsBZMLCi7ZZhjYnv8WeTuPqbSyERYvP42/gcWbqgAvJAsCdj4DZIVze/tknKb03C+WWOxypzGT7rxZ87IOCE95FAN51eDUuXP53R1lVl4LL8yEnJb2x2yimLJ3TLjDRD64Qnr6kg2ck5pEH1A8Nu+fzrRedb559/voTVihQzCapb1xkWv5Po2b1jPiVaMlZsC55AfdqFgOJH/AVsozj9kb+lMEpKNZE3FQ5hXbH1ZYJBp1liw7KEGp3Ob8LAD3ui4mj81O7h4vtb+73WaZA7cqOhqEkXySiy7L0OJEKi96xGJPAv+5M3Ka5tIQ0u4H4Xh0PCbiGxOIYxTsCZSQmr+T5zcoGpfPWmmK2Qfpp7stvn1Xad9ve2Kz/V5PncowB4xplCy5Ru0LnR30ovAiPbkEKDzlXXYT1TU1W+ipRfNADcIuiO97VOI4qQ22jvha8PSjDJx2Q8gj42EVUjJmX+hI4K9sC3SYpDaUfXhFUHtL79rvO/4iZW+ycGin5M+iqRnLeeqUlUpMuw9ebt3qx9G2Aj63CmhqxflDe4Oj1bu+D0fsAC/jNwqaPIxPjEl3ybCBbREFBiGDgtgAxgdMUIo5104jCB5ALOgp90CMQp3gOX7RCTs6fsebxqwr9B/BeCxAzS0ToT+KpKQ0+BIQYai02gRxB0LABd6/lwdPA8ngBddFQ0nVunjGDYZfwYcVHUK9qJ9hxT9eqd0yrt0ijRxoJmbDvZIWH1hyr4j9qbPpRaIvedMcPDE9zXVCmoZXsZuIKgE8YCuNdzSHyKr0uI2kcFJDV7F5LScJeWXKKip7+fLJWrR
 bJbq3zBD
 in0zIrG9gZnxEovwmQpdhXW4JSs0yxevm9ZGZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15 2025, Pasha Tatashin wrote:

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
[...]
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> new file mode 100644
> index 000000000000..0e1ab19fa1cd
> --- /dev/null
> +++ b/kernel/liveupdate/luo_core.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * Pasha Tatashin <pasha.tatashin@soleen.com>
> + */
> +
> +/**
> + * DOC: Live Update Orchestrator (LUO)
> + *
> + * Live Update is a specialized, kexec-based reboot process that allows a
> + * running kernel to be updated from one version to another while preserving
> + * the state of selected resources and keeping designated hardware devices
> + * operational. For these devices, DMA activity may continue throughout the
> + * kernel transition.
> + *
> + * While the primary use case driving this work is supporting live updates of
> + * the Linux kernel when it is used as a hypervisor in cloud environments, the
> + * LUO framework itself is designed to be workload-agnostic. Much like Kernel
> + * Live Patching, which applies security fixes regardless of the workload,
> + * Live Update facilitates a full kernel version upgrade for any type of system.

Nit: I think live update is very different from live patching. It has
very different limitations and advantages. In fact, I view live patching
and live update on two opposite ends of the "applying security patches"
spectrum. I think this line is going to mislead or confuse people.

I think it would better to either spend more lines explaining the
difference between the two, or just drop it from here.

> + *
> + * For example, a non-hypervisor system running an in-memory cache like
> + * memcached with many gigabytes of data can use LUO. The userspace service
> + * can place its cache into a memfd, have its state preserved by LUO, and
> + * restore it immediately after the kernel kexec.
> + *
> + * Whether the system is running virtual machines, containers, a
> + * high-performance database, or networking services, LUO's primary goal is to
> + * enable a full kernel update by preserving critical userspace state and
> + * keeping essential devices operational.
> + *
> + * The core of LUO is a mechanism that tracks the progress of a live update,
> + * along with a callback API that allows other kernel subsystems to participate
> + * in the process. Example subsystems that can hook into LUO include: kvm,
> + * iommu, interrupts, vfio, participating filesystems, and memory management.
> + *
> + * LUO uses Kexec Handover to transfer memory state from the current kernel to
> + * the next kernel. For more details see
> + * Documentation/core-api/kho/concepts.rst.
> + */
> +
[...]
> diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
> new file mode 100644
> index 000000000000..44d365185f7c
> --- /dev/null
> +++ b/kernel/liveupdate/luo_ioctl.c
[...]
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Pasha Tatashin");
> +MODULE_DESCRIPTION("Live Update Orchestrator");
> +MODULE_VERSION("0.1");

Nit: do we really need the module version? I don't think LUO can even be
used as a module. What does this number mean then?

Other than these two nitpicks,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

