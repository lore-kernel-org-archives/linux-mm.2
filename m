Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B69DC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 10:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A466B0140; Thu, 22 Jan 2026 05:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9123B6B0141; Thu, 22 Jan 2026 05:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848786B0142; Thu, 22 Jan 2026 05:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7234B6B0140
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:58:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0566F8A849
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:58:01 +0000 (UTC)
X-FDA: 84359299962.17.C1340D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A10BA000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:57:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sk36rrz1;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769079479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcIwbPjjskvdEkIc3aDCzrypxtW93ZbELEpwBs0ihF4=;
	b=3wrG85TkLWMI3bdPsLDdiXbpuMYvtYIaqzIq75MmCNUOZUiaR599Zu/OUM52DlIsab/BHP
	QIaylxYcAprkIAQ0osbqcaBlfLuKUrbTFDIfk2PZGNBKGkjDlHuK3O7SMooAUWIcFLc7KB
	tBQJ9dJqzdkNY2VsCYM+FKRjqCyB2qw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sk36rrz1;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769079479; a=rsa-sha256;
	cv=none;
	b=nrZ+VHfdOQc8EZzpZWQV9BR11B2/SgpsLnhQJEK0UekeLoexxTFOIQMaManaCoMlkvWQLT
	SYtaRPLPawPMw04SOtV7zAffB8tqwTOgWvhPaAQZVYZzoMHulNtBo0nl2dUawqXZD2ejW1
	zUVFnUmQto7PJ7Bqd99zRDWEhT2DXjM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CA9743BF0;
	Thu, 22 Jan 2026 10:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0631C19423;
	Thu, 22 Jan 2026 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769079478;
	bh=21xm7f0Mz2IMq1aSJDqBtT3vmDj0mwL9hRZ69a2vul8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sk36rrz1lHFTrwIzHYCFaYZmTlcopkOYJNutw9p7SwlvWgOwlo8LNwh7UGr/QrxGq
	 Y/4rC/JdWWhNb/lWg69SqV9OzHX8ORX4UrblhHVXBDholvSyGoUmtPHH9lkZTgF8uZ
	 zLiWOxTPx5zNMyeFxCuKfKD4qZ3A321buNLcNJo934wJUEbw1bCNe3tC6IOhUQI/F1
	 gS2xnR/9kUU1B5hZfNIr9fmHI/HP3m2c6PnC/iDDvZ1KQOqKmPpQFVhvqCd46WyTZ2
	 M0z+IqXjBFZcDdoma8BJwJZr8YekEnonRlLiO+L6RJLlPCwtUgV1H474XbPot4sZyu
	 7X9EBs2PB3Bqw==
Date: Thu, 22 Jan 2026 12:57:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, kernel-team@meta.com,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXICriRKbYB5f3li@kernel.org>
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: ci4nnbueqnjqddecomukfnshbmibu7ho
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A10BA000B
X-HE-Tag: 1769079479-76942
X-HE-Meta: U2FsdGVkX19cCMRkvKEBEi2LduDIrGnyudjMCkgHfcch957RQsdITwonKHjC3nN911mafzCB7+C2D4Q7LsKpRuRZ4tFf49dyUfAfQA3lImFtLCfhl5UK0xNyhlAvEiAEzPcYMq6k8Pvp2Sl+y85w/I2xjW1bBkvRdOY6JK6T1QAr2tNYZkgb7Ks9hwW+FuGfFvg0xqw9LpYbxrqXve00a8kO/Q9Kq1dc+Xs+w8YCqXnEaRZ97mqfkwvZS24ab2EhyR9k5sgUkD8HCpggOUiGKGaat1gx8alWYqFF5IIK9Boxr+k6bGiPMOrnu+Fy1UG99FEF77sx9SXlJTQHT0pZ4/AUDV9k/uUFiPzv7zyy+l8huPlptvGjvmXUlpNcEVTY3YUZTKFDt2pai08VPKnNAHQnwzwhA+LLmHEqb/b5zwHoVYs36l119vKUnTztzHgXhX4zHrxEwMwUnDxAjvP4ky+RYBug5GKRFlMYSTVh7zUmdZRjFHaNYA81GuH2qLkGo0txFqf6hindPvwHz0p0btOhoB0EN7SAoEVX84TzeNJtfj5flWSOygC91RZS3PVS7F3o2P9LrbdcFaXC4cjliMs8j6hd70NiovcmxuQMYNjgYQRtPERguQYrTckBQmzoSfoo7hB69bQWWdiS+f398mG9kDy45UDT7jIQZqfQbWqM8n0233WTYTTcB78mhZ4S/ylANyJJg9uLJOBoLXaAtuYZg1Xo49EFWhH5XvQzAYE1RsQzUzQ+ozIlCqA3XJLXO0zJ+3DZ8UpLfgCIYKEUs6UpFPMcgM4IppohNAO7RzQ+WJ21Piwy6VA6ZhDa4XRdzXpV5i9hGnS7HPUuHmtOVpmqhVznc9oXIR9IbxjSzGQx0jAfZUAnxEtPDqbE9diu5d9bBOg1MGnXR+LBd1ThZ2lL/GTWnphSm90Ud7OcqBCdDUnWoCPRBHouH7cx6AfAyR9yom/TFG07yDqmx1O
 nK7OPALZ
 vAFX0X6tArKKw9GInXL3lcpIBPsgc70FZAUtpHnTHsI8Rn9o+f+MfOOE5jd5SExjHejtgJJUMQgo2eGD2HfFI9cyevSqP+Pq1ZCUKT3D4DQxirmvwO2ZXss39EHgnNzKN1y9B7E2PBcCcsTbOodxsOT1LVsNvUjHHlUolcTwMK5bru6V3bSMZf6LA7XV8PyXLsIQQtWtcgefS/iCZ55WLAxAWUghVSNYbiFbGxS8Mjq5VZjlMZKZUAl/1pp/zf8MSaNxiPqYHMrFQISkqtevITYIOh5isjf9zdIGM2bACjcIm05+I0Y/c2zBw5szHSdKV4Inl81TT5WExqx/DzqYAlYcEIBav2PYTx7XGBBi2dxZQhzsEaHbxY86MpeL6/tErSBCp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Wed, Jan 21, 2026 at 06:50:38AM -0800, Breno Leitao wrote:
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
> ---
> Changes in v4:
> - Squashed everything in a single commit
> - Moved from FDT to C structs (Pratyush)
> - Usage of subtress intead of FDT directly (Pratyush)
> - Renamed a bunch of variables and functions.
> - Link to v3: https://patch.msgid.link/20260108-kho-v3-0-b1d6b7a89342@debian.org
> 
> Changes in v3:
> - Remove the extra CONFIG for this feature.
> - Reworded some identifiers, properties and printks.
> - Better documented the questions raised during v2.
> - Link to v2: https://patch.msgid.link/20260102-kho-v2-0-1747b1a3a1d6@debian.org
> 
> Changes from v2 to v1 (RFC)
> - Track the number of kexecs since cold boot (Pasha)
> - Change the printk() order compared to KHO
> - Rewording of the commit summary
> - Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org
> ---
>  include/linux/kho/abi/kexec_handover.h | 29 +++++++++++++++
>  kernel/liveupdate/kexec_handover.c     | 65 ++++++++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
> 
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

It would be nice to link it from Documentation/ as well ;-)

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
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c

...

>  static __init int kho_init(void)
>  {
>  	const void *fdt = kho_get_fdt();
> @@ -1357,6 +1413,15 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
>  
> +	if (fdt)
> +		kho_process_kexec_metadata();

Can't we move it into the existing if (fdt) below?
 
> +
> +	/* Populate kexec metadata for the possible next kexec */
> +	err = kho_populate_kexec_metadata();
> +	if (err)
> +		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
> +			err);

Please follow if (err) goto err_ pattern.

kho_populate_kexec_metadata() failure essentially means that we failed to
allocate memory. This shouldn't happen that early in boot, but if it did,
then something is utterly wrong.

> +
>  	if (fdt) {
>  		kho_in_debugfs_init(&kho_in.dbg, fdt);
>  		return 0;

-- 
Sincerely yours,
Mike.

