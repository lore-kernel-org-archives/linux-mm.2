Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9D3CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 11:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1846B0022; Sun, 23 Nov 2025 06:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389286B0023; Sun, 23 Nov 2025 06:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5636B00A4; Sun, 23 Nov 2025 06:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE816B0022
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:12:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5FE5130C72
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:12:38 +0000 (UTC)
X-FDA: 84141608796.28.C271582
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26E22140007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:12:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DD70297O;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763896357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbIAvYwMReu617r0r/eOdYEsD6bsMKtyldGLszVFpLc=;
	b=gY4Hw5Jk0VK0WgaNB1npH6Ent5NqGFfX04TuL7BWbSd5PiNGASHh8Y7OHojySsR2ErdDEQ
	7jZgnfQ2H7sDPuNNsTWIrsw00rX8WLZPTrTeYFrtApkvEeRJpaVwP70CycoYJtSliZMIXf
	MP4TVkoCZ4LjrjtkMCHVJcFcXdIdJGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763896357; a=rsa-sha256;
	cv=none;
	b=bfd07r6nvDnKZpPuMt5maYYiN4Q7R607WIZRy5ZffM02kwOuW/OJOP3+R3s5fnxMofKxPJ
	06Vp7vpxHcKpLkGpv8yWYCQvVM4KgpYsqBnoEjBI+9OzP8PBCISzocfnkZ675iLip/QwkI
	R6hJpAQrU0IidLPzf4DU4TqzVOFsNKU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DD70297O;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34E0360154;
	Sun, 23 Nov 2025 11:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E672EC113D0;
	Sun, 23 Nov 2025 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763896355;
	bh=Akr26sM3VEhR3kKN7o52n5Q0IG8yNVh9gdExmJrI8ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DD70297OscX5jW+1bL2L8Z5+6LxRLvMSuqNcQmzITuFPIzMzmkRtlD/mIf3T2D858
	 mLjthfkdI3QvX5wzmOddr/fDz3ZYEbjtxPo1YEND1/rowOhEwrqrpzC2boUYmSqpWC
	 LJa9Y4iSUVo8vPl4T49RkU+H90guNy7wohSE0KXct5W8r9dxLkD1p0m6pifzJ+NS+d
	 gQ4atTXM+NBkfw97j9VlyFdkIVV9vi3HLQHWP2WLZ7acpq+JnxntA0ebpsXBDISpJN
	 uF6MX92LSt9PIFptSK1yfDhmlyBzzfbfcjg9RYfN9IA5CBhLECVurLPXjqk1yT2SZV
	 LiaEhMRjyjibg==
Date: Sun, 23 Nov 2025 13:12:11 +0200
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
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
Subject: Re: [PATCH v7 01/22] liveupdate: luo_core: Live Update Orchestrator
Message-ID: <aSLsCxLhrnyUlcy4@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-2-pasha.tatashin@soleen.com>
X-Stat-Signature: 7d38n5e59aiophudnqfw8f43a6z4m8fd
X-Rspam-User: 
X-Rspamd-Queue-Id: 26E22140007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763896356-1532
X-HE-Meta: U2FsdGVkX1+WsTcQUpstknhouhSbCYqWDTXCoOjUbnaM75MKfOcZ55cRCnWpLvt46no0rB1TCGW0NLF2eILIKxLRuFFIGf5Kf5vYJfHAEwYy6JTJX9bihWLCIsSBFoNlcchBIiUxrz7C/SUAnwn2QcsdSP2JfiXf8C2ZMBwhPU3imOAxFUFWEseV5O1LVNd5WfRd3rmDt80hc+SQ4PgT4Zr+WpT2eBDsoafKA3Xc9tIN/IdDu4ZHwqsr7HY3DySCC28eJtuh0aJsYezs2a9ldxAuZBY+sDJtFSjaX+rOjsE/UAlkaMsqTgzyQ5ZT9Pik3piQtPBYa0ssE2Jk4qMBvjq8u6JfFnia6qrc6UOa/RHOXe+boLdmb5Pvc7a868sv4OsaLE3Wh8LF+8dPDpPb0Fao1PTSCeWeTaiejS/2/O1OWAwbzX0PhZbW5X5t8089JT/2m8WpMz2DKKTI4Ss8yAaFeLZyojaMkYoZGj/xI6yUvGZQTl7PGQox6yUFzp0jw5qF+g4XFeoDy0BCrx49PMUEQ/QXBf/EyNFSqPmJreY7q0dVXkpVbo+t5f3Q85swJpKA5PkJNJMLh4iP6Blxern0IMnWYY0y67ltH5Ejs5vJL2HenjoiIZbZauMxh+vmWJAQZbXnxWBfiCruV/ribN4hxmFtsaZKpTw/RWdopxHzxo2+LMqBuOM8Un1Spprs8rhEcL+nwxf4ngE5zA9R2uHWVDdqmrIKMmIk6gvCeZ2CXbSXPtmhPgnHWkiW8ilacXLtgqHNEjeRoEks/stwtOlsb0JFK7ijpCO0NCA7t709Eb7PQBpjbwVFgPsAOsZIt89dOqZYcFx9DC1BX+Q7x8j4qpNWYQjRz6Y5Ds4Jz2mAyjb66MTuTBpHsrnJ6/mwEX/MbEOi6HsF+HPuANAgytHsMWec1LpTEqrYP5GUXMRxP3Q/9z+iAvwdwui+uNttfutCM/8eQEvCtm2cgZU
 F0umXum6
 qQIFQdmlvtTs9hfjsfDsCzi/ol9DmWDU1YE/sZCPPfdcRj9YFTGu+jqckGDUxFFGLKvcAN6dra/pFyN5XJ0gxUdUtgxEHa5eNrIkLZjZ922r5ywrKlhYkA8sRsBvKYt4OHpf3meJ2VgYrcQ2DJs9U7VveAZ8qovzim0yDB4ZkwU9CCjO0m3+eAszmlaNIu6XicoxFpqU2O9E0LtaC62ikJwJh5jVich0aMxoYrlgTdZ3UGydRw+12B33EprtI8j8vi2nGR4A+nMuanqkqGd4nweNXJxSpduKHyDQGQwwEKPa8qPlXO3/wzlOxaDHJhdJg3HBQMW5jors1O2EKhLpBzNpXPtQKOtsCdQs9muLERleYtaH/mjEfhi6CkrVYK68HlvW3A8kqH6LardwK4fQZv3PHwC95C2+LzH/jRK+urQR4bpjL0wWON62/3JFJ7XztPOY0clqkfRvb2E8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:28PM -0500, Pasha Tatashin wrote:
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
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a few nits below

> ---

> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index a973a54447de..90857dccb359 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -1,4 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Copyright (c) 2025, Google LLC.
> +# Pasha Tatashin <pasha.tatashin@soleen.com>
> +#
> +# Live Update Orchestrator
> +#

If you are adding copyrights it should have Amazon and Microsoft as well.
I believe those from kexec_handover.c would work.

@Alex?

>  menu "Live Update and Kexec HandOver"
>  	depends on !DEFERRED_STRUCT_PAGE_INIT
> @@ -51,4 +57,25 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
>  	  The default behavior can still be overridden at boot time by
>  	  passing 'kho=off'.
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

Sorry, somehow this slipped during v6 review.
These days LUO is less about devices and more about file descriptors :) 

> +
> +	  This feature primarily targets virtual machine hosts to quickly update
> +	  the kernel hypervisor with minimal disruption to the running virtual
> +	  machines.
> +
> +	  If unsure, say N.
> +
>  endmenu

-- 
Sincerely yours,
Mike.

