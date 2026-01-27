Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70889D25959
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7F16B0088; Tue, 27 Jan 2026 02:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65C46B0089; Tue, 27 Jan 2026 02:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971D06B008A; Tue, 27 Jan 2026 02:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86E766B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:32:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 062F7160B8F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:32:01 +0000 (UTC)
X-FDA: 84376924884.13.19689EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70F89C0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:32:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6woip7n;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769499120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMs202ls6I1mHL4u4/keg5ULSM/qkR7dvbuMz1TL4NU=;
	b=SQjLGLzylG+qK8F+7EsdXWPI/yfGt3z+/NZYRwL096O1VfBQO/Mu2KeDJ63BWDEVfd8qZq
	UZYnHImtkWVS/WqpMm7gEho2KogzttcBbeYsdUnIvTO80z3SyMrEWD5hqFX6NNuBuEKX/U
	3aqUxZb2R2BQajWXETw8LxMfF657qSs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6woip7n;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769499120; a=rsa-sha256;
	cv=none;
	b=BxHiR449TZRdinAOTgbVlUVS1OeTs4dl5Nml2exSLCsE0VNvc6jdtP0dZ5loTWh2xZangj
	OIZPSXV2Lfdz5p3+Msi31ZuCxZfq7Opkgz6/Sh2zd5kW5NK7k7HzXr3uT/wqRkVADkzBSs
	8coktnON6c3OfOaMJqpmJ+Sewdyu7BE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB8F660097;
	Tue, 27 Jan 2026 07:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC3CC116C6;
	Tue, 27 Jan 2026 07:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769499119;
	bh=RlBJGa1qa6Olo8efDWcRWJLbj1v7PDFyAEadNj37KbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e6woip7ntNeXOmzDiTKg3LLAfc1enMO4l8ZkLD2IKmLhRIaGTQOQvYA4CiXPXZjgt
	 DKWYmoaCFW2rn8hQv4qzVYcYbjcxYtm8BG6fUH9hG4h6J0lUe4qAC/FXmwMbZz+oCC
	 ElqCSjF48IHd2ul9DumyOGhjWSUQ35xOnKmcJ42LGz0iRulL+3QdTsqWqnPYyKapgo
	 5ZRWCtHBfmzCk3skHSDMXACnzFSoAnMo89jW0zHKUdNqIhG3oiQ6SEpjP+jaeGQipI
	 H7XuBMPcU/m+fredxnl0Xo8advRkI/i9Ks8cVRNHAWeh9R8M27F1Nkx2Y5Idvo+0C+
	 e2gk+E5OQwEvw==
Date: Tue, 27 Jan 2026 09:31:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXhp5ZDKtXG5n9sB@kernel.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
 <20260126-kho-v5-3-7cd0f69ab204@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-kho-v5-3-7cd0f69ab204@debian.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70F89C0003
X-Stat-Signature: aijsasmj3eruymjgzda79pzd7d493cjs
X-Rspam-User: 
X-HE-Tag: 1769499120-985842
X-HE-Meta: U2FsdGVkX19QxhyhcFchm7wNEWyw6Sph/oIpCg7IoB16UVLD927tIkhFo/VdtM+HX5geu9dM/dMI36JM7/q++kjRkm6rawNS59Gthl91lfexDAwK/Q3y8LUewWvw5hqdCeNqVjTEkqx6rBWmg1vhh4NMA872ped/d/esZC5XcYo8u9fhopqYvdq9BPtvXnhDlCpxO/fBWtLa8hUePmFcSzGXh2MBM0eYFBC+Pcl4EiFbqAfkx6oLVcaNwKKi0kpMvVa9OWzhPB87GSefeORYqjjTtcHiim3WGmcKbiAK2vlM/2Qm9N45LJHlV5EUZHxePT74sh0CelfTNEc3YrHO5wdG7/mTWryVMHr7bUp9QfupFW5tAOYLLyAvObdRhIwITel6vcXG3Jx/bHCI3uC1ZOENj1IeBp0xukr2IHYAw6nZUxow55JHTlMiI3yvoy0h7TyhA0x8w9gEQfzMmETIQtPKGxR63zELvwLTlFOKNHI4xv5oygIjuuVJKm1NAQWHTBzOrwlwRo4wEgDrC75XJm5bAoK3y6VIqfTMDYh2LNkhKCxHV1yPUbxbmhn/id1irA6/jbC9vUICgYkzrqSbTMFt7zFf9W+smJNKlMwpw+j+2AjvpYHykUrgF1gJaYzrNhqv4NUUK4ZyHIXipeJm+0s0TrUaGrxVZZ2CknIzd0q/V29ZA/FPg544FNDdIdpMQ2Osit5FD4rdnpRI5jGo66WlsXbcTHxrf0iuacdhAHqraFgcxbmRLmg0QooYFt7L4URcDGWe5IFhav2vwXbEBO/cJbNOSBAYYw5rbMCXP3+f+cJwc0bI5PtKfAClMciCQnbp2kNLF5O5XZjXqXgx3vHOZolRMQ5iovsWJbcop4xaVLX1OEpnthCC2s3phARbZD7gTC3WRf76kIKBKpi6Za29jRSK3ZDlzPj/pztyz8C8GfGbpHlrKZpNI/Q5r02Ew6KyMqVrNEoyS7p/Eo2
 kCVVIWkV
 x5TdfwuOAbTFEkvjK8V+YkNLL5sv3YIl425znSxL0YTKmpZdQ22iCkeDIr+lp6couvka+EZBhYTstf2ad2/ZjfyLAEhlvUmgu/7ljinfcudHR79ADo90D0ortpqVrUNxkjoVeYDx2CAAHspIgo1LNOkp6qAI2VfhulYwVdGXutD+FKJ6S8pcZ/uX07+B5Cq+cMvQMqMsASaimF9btrXY6KC5ItzNoXTesGpb6jlet5o+xVkCrRFTfMNEoF397Ywl7endUEUqlJTxTB/B5lWIHfkZWoyfYQrAce9U70KfSca9wDhI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 08:07:25AM -0800, Breno Leitao wrote:
> Use Kexec Handover (KHO) to pass the previous kernel's version string
> and the number of kexec reboots since the last cold boot to the next
> kernel, and print it at boot time.
> 
> Example output:
>     [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
> 
> Motivation
> ==========
> 
> Bugs that only reproduce when kexecing from specific kernel versions
> are difficult to diagnose. These issues occur when a buggy kernel
> kexecs into a new kernel, with the bug manifesting only in the second
> kernel.
> 
> Recent examples include the following commits:
> 
>  * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
>  * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
>  * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
> 
> As kexec-based reboots become more common, these version-dependent bugs
> are appearing more frequently. At scale, correlating crashes to the
> previous kernel version is challenging, especially when issues only
> occur in specific transition scenarios.
> 
> Implementation
> ==============
> 
> The kexec metadata is stored as a plain C struct (struct kho_kexec_metadata)
> rather than FDT format, for simplicity and direct field access. It is
> registered via kho_add_subtree() as a separate subtree, keeping it
> independent from the core KHO ABI. This design choice:
> 
>  - Keeps the core KHO ABI minimal and stable
>  - Allows the metadata format to evolve independently
>  - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
>    when the metadata format changes
> 
> The struct kho_metadata contains two fields:
>  - previous_release: The kernel version that initiated the kexec
>  - kexec_count: Number of kexec boots since last cold boot
> 
> On cold boot, kexec_count starts at 0 and increments with each kexec.
> The count helps identify issues that only manifest after multiple
> consecutive kexec reboots.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Acked-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a small nit below

> ---
>  include/linux/kho/abi/kexec_handover.h | 31 ++++++++++++++
>  kernel/liveupdate/kexec_handover.c     | 74 ++++++++++++++++++++++++++++++++++
>  2 files changed, 105 insertions(+)
> 
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 2201a0d2c159a..1f017756e9991 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -11,6 +11,7 @@
>  #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
>  
>  #include <linux/types.h>
> +#include <linux/utsname.h>
>  
>  /**
>   * DOC: Kexec Handover ABI
> @@ -84,6 +85,36 @@
>  /* The FDT property for sub-FDTs. */
>  #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
>  
> +/**
> + * DOC: Kexec Metadata ABI
> + *
> + * The "kexec-metadata" subtree stores optional metadata about the kexec chain.
> + * It is registered via kho_add_subtree(), keeping it independent from the core
> + * KHO ABI. This allows the metadata format to evolve without affecting other
> + * KHO consumers.
> + *
> + * The metadata is stored as a plain C struct rather than FDT format for
> + * simplicity and direct field access.
> + */
> +
> +/**
> + * struct kho_kexec_metadata - Kexec metadata passed between kernels
> + * @previous_release: Kernel version string that initiated the kexec
> + * @kexec_count: Number of kexec boots since last cold boot
> + *
> + * This structure is preserved across kexec and allows the new kernel to
> + * identify which kernel it was booted from and how many kexec reboots
> + * have occurred.
> + *
> + * __NEW_UTS_LEN is part of UAPI, so it safe to use it in here.

Nit: it's usually referred to as uABI.

> + */
> +struct kho_kexec_metadata {
> +	char previous_release[__NEW_UTS_LEN + 1];
> +	u32 kexec_count;
> +} __packed;
> +
> +#define KHO_METADATA_NODE_NAME "kexec-metadata"
> +
>  /**
>   * DOC: Kexec Handover ABI for vmalloc Preservation
>   *

-- 
Sincerely yours,
Mike.

