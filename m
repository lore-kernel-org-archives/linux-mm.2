Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8BACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5948E0012; Wed,  3 Sep 2025 12:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56D08E0001; Wed,  3 Sep 2025 12:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44908E0012; Wed,  3 Sep 2025 12:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EBE08E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:25:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EF451607C6
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:25:58 +0000 (UTC)
X-FDA: 83848465596.25.305155E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5876A0017
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:25:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756916756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naiguCmQixdnHGLdSeGC1JbSxxv+Z9dT+/IMsE9bOUs=;
	b=tn/piyksClF9SnkRyDY/YlExpXP0NSx3IMxBw8uldsoyVW96An0YRau1Xl1BgWEaDrf2Kw
	om2vr/8tvRa5uZM9blX5P3Vd/pJZkeXYXgfSq29+pNOhcCJuukhSkywqjEKVWfuMVcIDTR
	T85dv4g0kQC+zwDpzIDTfEKPAEbhpf0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756916756; a=rsa-sha256;
	cv=none;
	b=OTjJ4gRhnyzeIuqGI2lkxaDtT/ETxBEwGTI7C2miF5rNUvkt2V11XI3/zHE0d1Za6zb1tU
	xpFMo72QOXijVSBFleFA6rQuX+g9DjgJX89OCE17dxWm7lhkO7ZMtXdZEcnR/5UTehTSMg
	ZGCDBQcwOInugi+BjcCDk6IY3V9CTk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50E486025C;
	Wed,  3 Sep 2025 16:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F67C4CEE7;
	Wed,  3 Sep 2025 16:25:51 +0000 (UTC)
Date: Wed, 3 Sep 2025 17:25:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: james.morse@arm.com, linux-cxl@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	Will Deacon <will@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Yicong Yang <yangyicong@huawei.com>, linuxarm@huawei.com,
	Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 5/8] arm64: Select GENERIC_CPU_CACHE_MAINTENANCE and
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <aLhsDCcMcqhXM0x6@arm.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
 <20250820102950.175065-6-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820102950.175065-6-Jonathan.Cameron@huawei.com>
X-Rspamd-Queue-Id: C5876A0017
X-Rspam-User: 
X-Stat-Signature: uu3zmnemha9rksgpxmseem4btqpdsjiw
X-Rspamd-Server: rspam09
X-HE-Tag: 1756916756-49286
X-HE-Meta: U2FsdGVkX1+VVU8ZWlFVl4NCDdQDMUFyv6MyipxneZv3ECa8p1nf57FL+OddNMLA57ghDDikSDtxiDSLii4BbFUMtOsjFS4m5JrTGayxFHusrdEpVwy6Skp6rUM/5krH4+tAieVUvliXjEbvTPB86PYKv1b7LHawZP7cUPJv9QAYKqrbWL0uhtWG1a7EF8quCIx3gutK2+GPeL3P7OJVdJTSAH4l+urIrXoWi8eODgP+CL/JMLjg+QsfI57JVo7QJ3gOQpU0T2HVSu9tEG7eM5kcS1uqjTSs1MfvsGx2VCMhyEk4MTMnp+oqyyzgzrETPrVTSUVH7bwEeZLmI7uWCK+QEledUXsDnAFljBrzCrORE3/wD/rG9N32maUJbZgMHE+unPJM805dXvYi1W3nB/GWEpWJziTODo4PGu6pcweTOtVUEdG0C7lg4FvDNcsEFlIC/40f76OynPtW05kp3cnAkfETmOJEo33gtQzmF0w/ed0t9ctXRDHKor5wPOEJws8tD4mqBore9bb15tusewo/YwQXmOrXqCVmJIb5XMlRX/hXlsqxbBbsjQli9nygBzBGH2VGQEB7Rv2gKRETuP+kmSDOZkig+L6uOe2NtqWBCihzFPRylapKFDDm7IkL/HngWB8tFsTRCAYh2r7wqsCuRoGg13fnaC0St2NmvYigwZXP3q+YD113LC/duGMZ12KrzAEGwOjFNBblgyfBYLVyXsJ7HO5/0cEUG7teOb8mt0o562ie/u7byZ1xWeB32AE0wjDBm9E6H4garWWtqfqXZsc1V4/C+W3HXuwvzlVD7N9y2406zebu0BwRiTAc2FXkjOKlB+bAnzpBGISOi4JW0y1bHQjRw1R+45cvBj1/fKROvPznj18KQhQJfXie/q74DIaCJsWaUO6TCvo0vNN8tvwSXtDnhPIjdaqHRGzk4gXaXPJcdQ4lFAMnZL9/z1ztcvyuv6Aku1cqshO
 /tYGMwur
 moQCGxSBce1q9S3YtT3QYH3sNe69qMPyMZQjUOSjRlyefEa7CQ2hhu53i8pZyqhRzQPmUdkiqSpgw5gv9Fp3IkZDqCwjePRfHj7vo27ohI8vnasMOVnz0d+r6MlphMvdMQTNoSZARbPQ1o0v5id5kjuk4dSLOgyca99AZRQ8RqTYSa3bBoBQUH9xWgNWXysXyF2qc3/C06Vf5qQXNI/ir3aqrDl9f/F4lZUFzNh3Ovjtip2Kc2ICPgMxJvhn2tvK15GN7D+pJYN+PX7pHDtE0Xpy4BGzLdOGsrV+SX/Z5fRSupc7c3slgRkS59NeuOpfrTpuBFz5bffroNnWeUhZYAEtFrzbkAWSIdZBdrfw+U7Q4ncw962mQekrlWPsg/DkJIcZqgJyt5g2aXH5paZVUTx2iLtodAHm/DVlkNzzAQg5XDVCSUYOwyF/tTvm0aLjBcgk2/6NrELDgHP+AVjsEU718qyzaFwb2axSV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 11:29:47AM +0100, Jonathan Cameron wrote:
> Ensure the hooks that the generic cache maintenance framework uses are
> available on ARM64 by selecting ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION.
> 
> The generic CPU cache maintenance framework provides a way to register
> drivers for devices implementing the underlying support for
> cpu_cache_has_invalidate_memregion().
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  arch/arm64/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a6..15bf429b3f59 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -21,6 +21,7 @@ config ARM64
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_CACHE_LINE_SIZE
>  	select ARCH_HAS_CC_PLATFORM
> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION

We could drop this if GENERIC_CPU_CACHE_MAINTENANCE selects it.

>  	select ARCH_HAS_CURRENT_STACK_POINTER
>  	select ARCH_HAS_DEBUG_VIRTUAL
>  	select ARCH_HAS_DEBUG_VM_PGTABLE
> @@ -146,6 +147,7 @@ config ARM64
>  	select GENERIC_ARCH_TOPOLOGY
>  	select GENERIC_CLOCKEVENTS_BROADCAST
>  	select GENERIC_CPU_AUTOPROBE
> +	select GENERIC_CPU_CACHE_MAINTENANCE

Either way:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

