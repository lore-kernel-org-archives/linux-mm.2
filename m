Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13090CA5FA0
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7488A6B044D; Tue, 20 Jan 2026 11:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5E26B044E; Tue, 20 Jan 2026 11:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C776B044F; Tue, 20 Jan 2026 11:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5313C6B044D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:09:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 062A71A0661
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:09:02 +0000 (UTC)
X-FDA: 84352826124.02.BC880AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62FE7120010
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:09:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9Tg7woK;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768925340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaNZKx3aitCjIZUu8i1aQUcjkyqufyS/EzpiGQL6i8g=;
	b=HjcYjeqtsSNLf6g9BqIRu5QSo+Rl3WlbdmzxspDhxOgxBNguXVlPIVIssFEiP49D04VjFk
	FyyLNthoFHp3dVgRz1i1z6oQktgRzT6mbjd1W5lp3ADjHgHDMPun1hOhd+z/XqMbK40aSt
	ybe7MwBe7/l4jcJ0xAjn88sdiQbml0Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9Tg7woK;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768925340; a=rsa-sha256;
	cv=none;
	b=eUF3yJzREbc110Fw73gvDrVE4MyK3sOOjIvA8o40Rzv9TLR+HO0GOVJ1OJ/oiI79sF4MCA
	ISufpElJAEFgXRM+OZJLBsIlLgw/FlBfnXEgtZTCGqizVFuHRB0c2XBZ8sR0vPJOlxTk3N
	cs//e/YjpGkmN9MhmHfOuFuS4w5gduc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A28EF600CB;
	Tue, 20 Jan 2026 16:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BFBC16AAE;
	Tue, 20 Jan 2026 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768925339;
	bh=os1EwFT5nvnw99r6n/Mg19gaCUrjgTrNjKTqCnEbqzs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=g9Tg7woKpvI/KsMGSfnoNo0YwIS4G+sKz+BWpN2P7V68wE1XLyYkmeEbL6WPngR5d
	 WkiLXBu2+bGWI55uOYf7LogQY9MXJl2Q91vZ9qcSfQkn0PVRmsQ7BfQzTlmLho6Ng1
	 GDrlV4HyJL2I2MFnEE9rlwIV6tQkKxrSWljL3OWyynWhc6XZa6EjvKauM+iD1qzfjW
	 eJb+IPurbeVcPvU0DGnYpcmYkd8JJHXXLCq1igkdDqD7zeW+OLcwAt9gAXf6li+nWi
	 9HqJe2cEhrvP/9TKUOs1F5w8QzNZ0rAnyWvZk5H74XHpR1m63VP9FGvXP+9GqjxMih
	 1L8/mL8J3iHcQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 3/6] kho: docs: combine concepts and FDT documentation
In-Reply-To: <20260105165839.285270-4-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:36 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-4-rppt@kernel.org>
Date: Tue, 20 Jan 2026 16:08:56 +0000
Message-ID: <2vxz7btce06f.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 7qat8azk5shzo9io74o1mae4gmgm3cnp
X-Rspamd-Queue-Id: 62FE7120010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768925340-922795
X-HE-Meta: U2FsdGVkX18KTWM+vw9kZCsAjzPRZV3W/c7CiXq28VMzcxohoqit3aEqTW+/ZozcN4ozrWlq0OlMTbYShvoR+TD5d0/hziN1Hwqz+KosVQtiyYyYK9pc2+NIH41+iYmvuQdqUXaGzIgGLsPkxcgHFbT+Ut1TllFiTD+LzIMH2k2mBpfORiX2AGPA5txlC3LXQDf6KVv4mIBmuoNRQ05vbcUL0nSZnvMMuSz4cnLOkDpBnZ/P+N4+Q3hRNyiulAdMmY886PxFAZxeaGH0HSGq9ooYifucXKv3OVKglOdOIH4woWmW6GiAH2lvihdp5QdQnCjcUFCGN4yINLGpvd8Iwtq68XFjLY9EkS+FcMRc7zLR17hVFDnZOszrfPgPA2/PYfu3Ir2+8XexvRkx/48uFRQ3h3EhlBNjJIJL3WohsHlpb8FzOh+NYxKuXQXs9W/J73Es0qk0eHgZSqdOM1Zzwcv0MXo81RbmppeC5HdOQmYcsjMhs3KWOF8h5WrJQ+H+EUf0mH37tIlIQpS2ovOfbrbDdF6eWbl14XHefZoFDT1lBnNEPP6x4A3A34CEUH7yNklODA6KWl4AVLmTdWm8mXn3f6GIjEJOkFwkM8URNOfW1RWaEyIjsJhDgBl8C9vTIsLQqFLMoEU107Q2xp9SHRtOjgMDIMp7wLHHzvh7QJ9tB47Cp5yNe3WEXwshbCG3sDG9ql4VlMrKTsCex2SbU6N6iBlFVy8qECGqeGcOGdp/6FidXi8pfnDoygu5ysmd1qQaOHjOTi6FKfSCLJ50/9Vgb+uBtNqOViuq71di1VIz05lntbBvgwfc6uL7nsIkxZkrQS+HhmW23NNwE8N9l2CWI6TIFYNlaxpZwDlc6mCQSOXHwVkkX54m37UfTVZbVCYXeiXYK/sVjwx6lnAqM2bbTcffSFtELXIQxZKisj9Xb3KQOMkd/7kOBGBv6ZWm45rkRv6zDlZtJo/ucN3
 dlhwTTYV
 TSZrH5Ow+qp+5t9b4lJeCALE/X3oHKjcIDOncl4WZjRuwphtSVyDTJAlALBjZpWzcAC9iqGvLJtvM0PGMR8DVlQowDwG4slkLshhUticLf5p+w1nn5kh2Ukn221CDQfbbx3nyXrw9jOuyWIEFtOS7AQd7dr7w15Dlt6lIf/ohLqNqQiqDDQOsDh7sKfakvm9Mk1C+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Currently index.rst in KHO documentation looks empty and sad as it only
> contains links to "Kexec Handover Concepts" and "KHO FDT" chapters.
>
> Inline contents of these chapters into index.rst to provide a single
> coherent chapter describing KHO.
>
> While on it, drop parts of the KHO FDT description that will be superseded
> by addition of KHO ABI documentation.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
[...]
> diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
> index 0c63b0c5c143..03cd9afbdb2e 100644
> --- a/Documentation/core-api/kho/index.rst
> +++ b/Documentation/core-api/kho/index.rst
> @@ -4,10 +4,73 @@
>  Kexec Handover Subsystem
>  ========================
>  
> -.. toctree::
> -   :maxdepth: 1
> +Overview
> +========

I ran a test build and Sphinx complains about:

    Documentation/admin-guide/mm/kho.rst:10: WARNING: undefined label: 'kho-concepts' [ref.ref]
    Documentation/admin-guide/mm/kho.rst:31: WARNING: undefined label: 'kho-finalization-phase' [ref.ref]

I suppose you should add these labels here.

Otherwise LGTM.

>  
> -   concepts
> -   fdt
> +Kexec HandOver (KHO) is a mechanism that allows Linux to preserve memory
> +regions, which could contain serialized system states, across kexec.
>  
> -.. only::  subproject and html
> +KHO uses :ref:`flattened device tree (FDT) <kho_fdt>` to pass information about
> +the preserved state from pre-exec kernel to post-kexec kernel and :ref:`scratch
> +memory regions <kho_scratch>` to ensure integrity of the preserved memory.
> +
> +.. _kho_fdt:
> +
> +KHO FDT
> +=======
> +Every KHO kexec carries a KHO specific flattened device tree (FDT) blob that
> +describes the preserved state. The FDT includes properties describing preserved
> +memory regions and nodes that hold subsystem specific state.
> +
> +The preserved memory regions contain either serialized subsystem states, or
> +in-memory data that shall not be touched across kexec. After KHO, subsystems
> +can retrieve and restore the preserved state from KHO FDT.
> +
> +Subsystems participating in KHO can define their own format for state
> +serialization and preservation.
> +
> +.. _kho_scratch:
> +
> +Scratch Regions
> +===============
> +
> +To boot into kexec, we need to have a physically contiguous memory range that
> +contains no handed over memory. Kexec then places the target kernel and initrd
> +into that region. The new kernel exclusively uses this region for memory
> +allocations before during boot up to the initialization of the page allocator.
> +
> +We guarantee that we always have such regions through the scratch regions: On
> +first boot KHO allocates several physically contiguous memory regions. Since
> +after kexec these regions will be used by early memory allocations, there is a
> +scratch region per NUMA node plus a scratch region to satisfy allocations
> +requests that do not require particular NUMA node assignment.
> +By default, size of the scratch region is calculated based on amount of memory
> +allocated during boot. The ``kho_scratch`` kernel command line option may be
> +used to explicitly define size of the scratch regions.
> +The scratch regions are declared as CMA when page allocator is initialized so
> +that their memory can be used during system lifetime. CMA gives us the
> +guarantee that no handover pages land in that region, because handover pages
> +must be at a static physical memory location and CMA enforces that only
> +movable pages can be located inside.
> +
> +After KHO kexec, we ignore the ``kho_scratch`` kernel command line option and
> +instead reuse the exact same region that was originally allocated. This allows
> +us to recursively execute any amount of KHO kexecs. Because we used this region
> +for boot memory allocations and as target memory for kexec blobs, some parts
> +of that memory region may be reserved. These reservations are irrelevant for
> +the next KHO, because kexec can overwrite even the original kernel.
> +
> +KHO finalization phase
> +======================
> +
> +To enable user space based kexec file loader, the kernel needs to be able to
> +provide the FDT that describes the current kernel's state before
> +performing the actual kexec. The process of generating that FDT is
> +called serialization. When the FDT is generated, some properties
> +of the system may become immutable because they are already written down
> +in the FDT. That state is called the KHO finalization phase.
> +
> +See Also
> +========
> +
> +- :doc:`/admin-guide/mm/kho`
> diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
> index 7960eb15a81f..e2aba13494cf 100644
> --- a/Documentation/core-api/liveupdate.rst
> +++ b/Documentation/core-api/liveupdate.rst
> @@ -58,4 +58,4 @@ See Also
>  ========
>  
>  - :doc:`Live Update uAPI </userspace-api/liveupdate>`
> -- :doc:`/core-api/kho/concepts`
>
> +- :doc:`/core-api/kho/index`
>
> diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
> index 66e0fb6d5ef0..a8a5b476afd3 100644
> --- a/Documentation/mm/memfd_preservation.rst
> +++ b/Documentation/mm/memfd_preservation.rst
> @@ -20,4 +20,4 @@ See Also
>  ========
>  
>  - :doc:`/core-api/liveupdate`
> -- :doc:`/core-api/kho/concepts`
>
> +- :doc:`/core-api/kho/index`

-- 
Regards,
Pratyush Yadav

