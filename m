Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256CAD13C0D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E016B0088; Mon, 26 Jan 2026 08:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BA36B0089; Mon, 26 Jan 2026 08:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357946B008A; Mon, 26 Jan 2026 08:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 257266B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:35:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A61F61407A8
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:35:11 +0000 (UTC)
X-FDA: 84374211222.21.A453832
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE393180003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:35:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ujPNyDAl;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769434510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUyrsf7RrBDFWYGI9KCAX3IKjesWO0yJ5/FqS32bLYg=;
	b=QYP9W1E51G8uXR16oC1QSb9MrMKDpn4BNwoz/gJhrKKqELcrfGCpawNxS4+xG8flQGGlBp
	7cEAGGIaA+6fKTWZULRVCCph3DgtXeBlLtYKTmejvF3HvnitKMeTtX+07TTAIMx64H2OoB
	C5cdF3bhmOktq1ZfPNOylhw2yagm24o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ujPNyDAl;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769434510; a=rsa-sha256;
	cv=none;
	b=svTd9bKP3cW0JbThd8P3oRnkXLMCuxTJ79kRao4iQ6mpUEO0p68ooTssGMEWxpXAmKaWv9
	fVcjysGe3LPeIKjUmbiHMownjFqeOXUqWRFDXWjDZVfYBYQtlFv5JhgeIH+a1NgtEmYER0
	Pk5ea/GzlieG+iXWmfA0WXwvcQlq+/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B827A41B4B;
	Mon, 26 Jan 2026 13:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05144C116C6;
	Mon, 26 Jan 2026 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769434508;
	bh=lBIMffzY+AoU7PgBcVkFtZWf5SUwXZYGLlR6MmjFL0I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ujPNyDAlvmvq1uH3VAd4uhLhXWSRnpoMj/JhFhOM6dOhkRkZ+oIJRfhA5OzcIiSAN
	 +pd7/+GMCZQDqdQh3l2OZ+xvcaTMePLQ3TlozpebC7q3WoEPrC1Gy8ZseQfjBoMdJ1
	 3mVShCMAnwfpRtPIOdTUntFgYHV5bpBiIPyu6HG30utiRcn/8Skq41nixqSwVk8f3y
	 RLoOW/ZbEIqly2xRmvM9JyROZtrdHpfmmBo9+O8htLanBmbQRN9J7e9LOe1ZV6K3lk
	 27v51ZExeMjOcmUUZ8/nMGmoAQDOfpwuQZ0+r8UIyOVsaBt0GF5d3J4WpGL6dQ95ca
	 LaPDpL/aTbRnw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com,
  SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
In-Reply-To: <20260121-kho-v4-1-5c8fe77b6804@debian.org> (Breno Leitao's
	message of "Wed, 21 Jan 2026 06:50:38 -0800")
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
Date: Mon, 26 Jan 2026 14:35:04 +0100
Message-ID: <2vxzecnca453.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: omgrm6uuy8o6jqjwi19s9npz55gp1jqi
X-Rspamd-Queue-Id: DE393180003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769434509-553781
X-HE-Meta: U2FsdGVkX1/HDZl8eTWPsjjLKQHeohmBlMysLcY+xCjN+fBtCIFvNXLCojr0drn3M/oIVuByCzajJGgMYokYdR0ntMAfrW/RyfUjbUm3M0CH2U8t227x/tHFGtQiTmrfQsky+AatBmVsaYdSnK+k8galWwS5K406IjmmME+OY6UxXsxpMJMEtpZnNikf4LKQ6ktl+XAq9hPB7gva+JioyEnLvwnUxnsKHaGDvEBVnSh/m9ujnsXeq2SF3ElcZotXKxTBKFwfgc6CCkGcyRbo8yDS1FClcZ113wZCTSoo8TI8XtSPX73NpaKuuhGtDpggwKwjzB1hgx8YWapGb0r1IqgBUq/EUHu7hbXbynVdb5v21u6V2pFqLRG35Ag89d33JpzXFadrdMdUH3OkPn7tUYNcd9NkiAVJ/USH705Ov/mrOaKXqNYmxC9bkrcFdB0iJ5eXzYRm4Ds0zuJWSWQbov/J4Ms4ZcHYsLTj2lyzcdvX2uupMPJcc2VQCVsLOXl0JNRhRg2fIfppptbQKBk2Jan4c0peQt846FBU8BAhZ6PRnL9eibGp+bkLMClb7GHQ1MmPlKGXoGZbhAfPTJDPo/R/SseZn9PFfzhJx+DJF1L33jACypfuYJjaWnzVAIZ7kFtYJ7HEJVhzQn9+mgIjgNvL4WjRfY4heiGbRGXsJNT3ARl6NVCG7Gg+WBVyqWsvKLAH56d4Pb5eztBH/4ZL35wvtXhJkIvePaip2lxG5Cuop7co5k5lw/65Vo670q2CsEb6vZ9H9i262HgmHI/tzkMud+SD3wPKhyrdIPG3wBuN5oosh7SLVkXbur4LNEIueBpq/3S5Qw9dePRpfa9hNPigOE84wkuWdXjCXJ4i784hMh9RlIih8DetK1AC/KBmQJwui1GaNU1FUCww855GLB7iYi93/pSpmU6hkO/k5UI0riAo8qD9lVN/ealdZ2w9+iNfm7TWxSjNnYuLt0M
 zfA6Owje
 fvKsyU0gyY8GP1sZ2HzMaICupPzIWlBtkO5m2DvEj7tHVOQEIeBeAdoLx+f6j+WqSDb2itat9J8gpDJMEdP2FN/LFTIwrjV5F8D5XYqveuYYjTlC3mVvwABoHOVVcydNJhEMzMkH3BBXYSOgy0LxzYcjfdzWAEArtJkyK5u35ohSfeDyuhQXsX70zmrC3qkQ92g9luCbTl9ER5QscAZw99Bblpl4kg8YxS72z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Wed, Jan 21 2026, Breno Leitao wrote:

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
[...]
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 285eda8a36e45..e18022a4e664d 100644
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
> @@ -84,6 +85,34 @@
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

Other than Mike's comments, I only have a small nitpick. Please add a
comment here that using __NEW_UTS_LEN in the ABI is safe here since it
is a part of UAPI.

LGTM otherwise.

> + * @kexec_count: Number of kexec boots since last cold boot
> + *
> + * This structure is preserved across kexec and allows the new kernel to
> + * identify which kernel it was booted from and how many kexec reboots
> + * have occurred.
> + */
> +struct kho_kexec_metadata {
> +	char previous_release[__NEW_UTS_LEN + 1];
> +	u32 kexec_count;
> +} __packed;
> +
[...]

-- 
Regards,
Pratyush Yadav

