Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CBDEE75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D5F6B00BB; Wed, 24 Dec 2025 09:09:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94ED66B00BD; Wed, 24 Dec 2025 09:09:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BDC6B00BE; Wed, 24 Dec 2025 09:09:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75D3A6B00BB
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:09:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 439D4C0A89
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:09:58 +0000 (UTC)
X-FDA: 84254548476.15.DD426F9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95341100008
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:09:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766585396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s1K8sju+3/f8VFtV3zmY2c4SgwInjt4BE3PIxN+F7AI=;
	b=pov4WUXxv7e3OktKLy7wsQXD8ZgUHRtWLTI2DSsiqLDI/QIPGJl3wMcYdeVMZkmiplPDjR
	qWV9xpPRg0rySpE+kqJUJTjgFuW8P76/RKjRCCMp6IhPI/y4g88w127hCdEAY6TIM05TFA
	wVf5p1Yk1yDqbi0UO7bB7Ul/lFRviK0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766585396; a=rsa-sha256;
	cv=none;
	b=QuvALMhDV8YEN24ODCMrCesSheIYrdciswyZ1m4TOIV7AXxtyP82Sdk3l4P+GijEGt6ftj
	cNPswxc5w/ry39KWBd5JWar7VTmWeT9LsTAGZfJgoAsDVNkqFxdO736qSt0QRYr+SdX4Nn
	HelK9yzRi+kuUUNi0KJ7v533jKh4nrw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E5FA497;
	Wed, 24 Dec 2025 06:09:48 -0800 (PST)
Received: from [10.57.93.190] (unknown [10.57.93.190])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C61E3F5A1;
	Wed, 24 Dec 2025 06:09:52 -0800 (PST)
Message-ID: <ca465273-13ec-4397-a4f0-a38ad0dab2dc@arm.com>
Date: Wed, 24 Dec 2025 14:09:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <e1e57d89fed939e3f7ff877e4f406d807a7eebd4.1766455378.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <e1e57d89fed939e3f7ff877e4f406d807a7eebd4.1766455378.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95341100008
X-Stat-Signature: umqrdkiktdekpxsnrozbekwg4ds66bax
X-HE-Tag: 1766585396-954555
X-HE-Meta: U2FsdGVkX18hHl2HAAo8f6Bj+KRC504iV1gRrZucmPUOVSI5Gv5OWgKh+m2U7BThujScFOB8I81CR+N1crYpYJDSkDMrKEJfYGKBNufwD4vufym9a+LWEcDiS4rtqmzBgPsooqrQ3MXoFPH6xmxVpawJu/9VvPE4Qc5vJRnYSTecNA6ChpeT/LYzZIfzGA107rxOApD3SJ/Y9DKDIw6oNYIB03s3SaGwYhBFB2oUyph3PD5YesrHAR4LJ4umvGS+0NDpQL4M/mnUItIR2+fT4jw1/7ViB/c0TNId9pwnesyp8cGm3mFiKkUp3yQyblkkzT//vmHvnIw98tC/4zqYVYHh6KRTD99euk80BupSPjP3WVnFK74YsrTda4GIq/5HRc0Cq1kWs4gehTnqt8mLGHhNROX+TJ0F0QVxfTgqgtQJZ2JVmBCDHDi9lzrl41y2Y4iLpMd/Whycgr+oLererPLkGtIsQHqm/xuJz2ITXaWfEzQrz4AJBhyEFKQaHg/uUQIRJ7hVMZ8sFKxXJMaO0E2cCxrJ6GFoGLCDWLjRDOIEXGTuLu5H25A3HE4p9h3dwe/2ALYZSCQPSIBLH5AhkdN6UdcWwc//sP3ZlYqRmlhvVWrFD2ObIBeXF70phZGOSmHHEGlI3C8mCMw1dq/MGTrRjSQyRYiZxHZafquxSS4WVD0sN+Vj6UPOpi0Smg3+ohnPrwODUpyV0rncLHaHdBBq42khEEwKgRSRUlkk9py7DlJ8NSOxksgoZkCffNhgWOMT6YbmA+kjZzBwOvzFLBaqQF1YUZ2QY0X+hP0mkAziR2d9cneMSWQI97XBa9Q+odBFz+888jrKNpB64sJWR2oPVAgiTzpXaYyIBF12hY1X3yv5W2OzRjAQGIhGeeRsJFnIsIWptWV82xzOE3lPBQVgoV0xokV15AdmSqR2e49MhoJ1uJFJpyd5VcFNsn0YaraHDeG97LxbqqAknQT
 o2kbYg50
 887JFHJvbevwPQBkmH/xdWxYVeT04DQ34cPBzYgkuzg7p24dSaMqrem1V9pdWzu07kPb5bGY1WjuTyJOp3ciDtRyz55075SA7UoMSs16dtCZdDl7Mphd20fXLjzaSOfFaEK/m5A9IZ5G5pD93kAIHH7t1iRkYN4ozTpfYzd2UXmWzXp9iA1bm0AexAZhJFgEuiv8+zthPrM50aBlncXtFoiRYsEmS0x6NZFzaxpneHZ8+hIVi1FqM7kN2ZQl0RwRq9zwpYiWPUjLeyhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/12/2025 05:48, Baolin Wang wrote:
> Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
> batched checking of young flags and TLB flushing, improving performance during
> large folio reclamation.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
> from approximately 35% to around 5%.
> 
> W/o patchset:
> real	0m1.518s
> user	0m0.000s
> sys	0m1.518s
> 
> W/ patchset:
> real	0m1.018s
> user	0m0.000s
> sys	0m1.018s
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index d5fbe72e820a..84a6bdabb1f9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>  
> +#define clear_flush_young_ptes clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					unsigned long addr, pte_t *ptep,
> +					unsigned int nr)
> +{
> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
> +		return __ptep_clear_flush_young(vma, addr, ptep);
> +
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> +}
> +
>  #define wrprotect_ptes wrprotect_ptes
>  static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep, unsigned int nr)


