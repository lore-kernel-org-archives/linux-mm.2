Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686ABC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CD78E0018; Thu, 28 Aug 2025 10:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44308E0006; Thu, 28 Aug 2025 10:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80CB8E0018; Thu, 28 Aug 2025 10:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 966048E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:51:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5029FAC875
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:51:02 +0000 (UTC)
X-FDA: 83826453564.14.850F3F0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F9DA40009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:51:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756392660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4TsqXsFjyHvqX/18/wQyF9FUdKDomX/ph28jF4Cpyro=;
	b=GbNxO8IeRaLvNZoWZsLhdaFtHem+YviGATOPqq4Dut2Pmme0ejSF6opfkKCViWntsfyjLe
	ApxAt6c283N5CMnSwqLoHw6D/cWZFUjnjbt0EFcoXKvcfVzmqPrBjT8I2dWzZVjjP3fN8k
	Ej/V1M9QgU58ZCydRiGBC2e9JrqIVxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756392660; a=rsa-sha256;
	cv=none;
	b=8ox8gAWuklxgqDHlRmUa75uowAQunn8KYs276QlwOVtibjKVF4rvJkUtckpZMXy0H6elZ2
	jXOUAEoV9znNezdDLu4ehSXS1d8tpz6/crtiynxMrNmhlWSWuGPoG48mhsLfiNBc1Zgc5Z
	W/9C5QWmnX6MnyoF40gdz94jQ+lLu3E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BB081688;
	Thu, 28 Aug 2025 07:50:50 -0700 (PDT)
Received: from [10.1.30.134] (XHFQ2J9959.cambridge.arm.com [10.1.30.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E605F3F694;
	Thu, 28 Aug 2025 07:50:56 -0700 (PDT)
Message-ID: <261fceba-8485-4015-af72-582c4507cadc@arm.com>
Date: Thu, 28 Aug 2025 15:50:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] selftests/mm/uffd-stress: Make test operate on less
 hugetlb memory
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
 shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, npache@redhat.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250826070705.53841-1-dev.jain@arm.com>
 <20250826070705.53841-2-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250826070705.53841-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F9DA40009
X-Stat-Signature: 6m3px1iceqp4stmxy63j648nnc8n3e57
X-HE-Tag: 1756392660-540271
X-HE-Meta: U2FsdGVkX1+Bk+P6pKAOkmP95BG5pH6wyig+sXEF22ptlvOuza4hECJQBPIa+NZoO973LETUcpC1KtxP5kREX/fztIM+ZsJW2oPQSgbZIwcMS+mKu9g2ks4Iokot7HyyZlYRN7scEgCZL8m7H1MzScWqCqrcm0vvxyR2VXSRyEamTNrUYEus0MKGWQN+q5VLXWnE4k8jPqXYGP6pLt8bQkV5yG/HjpkJK0YHDwSWDWvDWnjqJ/oskA/VEuqFEklqChsjhOLMF3llX5/qTmSN6oiKjspsq81fOqgb0/AuRRAyZlVsP0dfdXpDdpoG5VKtWn54zLX3Echgx5Y7W3+l1aE/m5iuYk7JFd1NxVnVkcRuNaGcgVann5Ifg5aeBQeLOX3LADwMXsLE3v0uP0f7djJTThpAnv9myDVasQUmk+ytDOfWkrfuZnXT3jPbnlK6wr2b1EdtQ1Kv4OT8tOO386UIozTlPbOSOMizEaf1CcEW5+MaFx87gIIrEC4vhFSD3vtBCtlXJb9iKXn82MU5iIzr2zsn8J3XfPgko9pv2Hz9dUxD+n8quqFqr+dheASMwfL36jw3GHBUl1HK5zceJ/zs80ypZUdthe3VzzY/doR6/pKlZeK4fAoeupMA4ekklFBBUwh8E7Gg2RvIr3B8vTcdw1KwiQgIRnz72JzCI8nfWN7DrAljPIqeBXKWqvXSBBIIImxrRGaItiLU/1ZbQkeEb/gZcQIpKha8NRW3zLsVJywYSlGHzNQTLVYEtSm5KHk1K4fN4t+T+CLYktCJvZSUYLOp9vrHiq03WME9Yfux8DpLtnLC50JdLjt1pnmENVZVj9UxaXlxgWoggq/t4K3LFvxzLhSqA58n8wduR3V129mgdUIY5f26WC9pPb3iy7ggNup+tVVhaAAP/atTCGQMTJ/9dY/Z3rKNmpDgtXYevXZlfyusr2YCg/CsKfKEfQpW6UxECg1KIcCJg3E
 XxWC7X4i
 H3CJ+TsmwB1y8fBjBT1+phX1Kw+5/af5/kcGM+O+cRE7Jin+QWd9yYwKgWXxhMwpFvJy0f2b5VT12DTaiVr8xQDxEUuUFYUJbdO+K4XbGFarQM3E8WEQh5rGL7YESBlXc60Dfh0FA9bkEY/30aFmmKPmuo2BkAmYshmB4QFdSO9mxBRMgBiCXtAuQJpxXE1IplcvTg9D+OGLGA0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/2025 08:07, Dev Jain wrote:
> We observed uffd-stress selftest failure on arm64 and intermittent failures
> on x86 too:
> running ./uffd-stress hugetlb-private 128 32
> 
> bounces: 17, mode: rnd read, ERROR: UFFDIO_COPY error: -12 (errno=12, @uffd-common.c:617) [FAIL]
> not ok 18 uffd-stress hugetlb-private 128 32 # exit=1
> 
> For this particular case, the number of free hugepages from run_vmtests.sh
> will be 128, and the test will allocate 64 hugepages in the source
> location. The stress() function will start spawning threads which will
> operate on the destination location, triggering uffd-operations like
> UFFDIO_COPY from src to dst, which means that we will require 64 more
> hugepages for the dst location.
> 
> Let us observe the locking_thread() function. It will lock the mutex kept
> at dst, triggering uffd-copy. Suppose that 127 (64 for src and 63 for dst)
> hugepages have been reserved. In case of BOUNCE_RANDOM, it may happen that
> two threads trying to lock the mutex at dst, try to do so at the same
> hugepage number. If one thread succeeds in reserving the last hugepage,
> then the other thread may fail in alloc_hugetlb_folio(), returning -ENOMEM.
> I can confirm that this is indeed the case by this hacky patch:
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..39eb21d8a91b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6929,6 +6929,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  
>  		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
>  		if (IS_ERR(folio)) {
> +			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
> +			if (actual_pte) {
> +				ret = -EEXIST;
> +				goto out;
> +			}
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> 
> This code path gets triggered indicating that the PMD at which one thread
> is trying to map a hugepage, gets filled by a racing thread.
> 
> Therefore, instead of using freepgs to compute the amount of memory,
> use freepgs - 10, so that the test still has some extra hugepages to use.
> Note that, in case this value underflows, there is a check for the number
> of free hugepages in the test itself, which will fail, so we are safe.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 471e539d82b8..6a9f435be7a1 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -326,7 +326,7 @@ CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
>  # the size of the free pages we have, which is used for *each*.
>  # uffd-stress expects a region expressed in MiB, so we adjust
>  # half_ufd_size_MB accordingly.
> -half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
> +half_ufd_size_MB=$((((freepgs - 10) * hpgsize_KB) / 1024 / 2))

Why 10? I don't know much about uffd-stress but the comment at the top says it
runs 3 threads per CPU, so does the number of potential races increase with the
number of CPUs? Perhaps this number needs to be a function of nrcpu?

I tested it and it works though so:

Tested-by: Ryan Roberts <ryan.roberts@arm.com>

>  CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
>  CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
>  CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16


