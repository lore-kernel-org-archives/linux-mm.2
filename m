Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC41C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78436B0144; Thu, 22 Jan 2026 06:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A261F6B0145; Thu, 22 Jan 2026 06:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952516B0146; Thu, 22 Jan 2026 06:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 819016B0144
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:08:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 207EA578AB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:08:02 +0000 (UTC)
X-FDA: 84359325204.27.8C93130
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13F87100006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:07:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769080080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uq+U7+WOerYXBavyw2dlRsIWjL7Q133qV3ayFU7Mivk=;
	b=wxpn9xlObZxRKSHs8IBb5y2GHigReic5R9tXi5yym9+Eoz3kH4OD4arI7oyq8YLMPdEfkg
	6DWV25fmei4XNAowY8sOn2ASizpt7ArgjsZclQR2JmaVw8dSL+RgXUkMt3l8EwPPTR1wpV
	oC3HAJIEACzGmmI3YntBs/8r3pJRxH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769080080; a=rsa-sha256;
	cv=none;
	b=dIB2OwSMPVfhk0iTlndgyDCUrz6/6oANnaNiuEIzsbrWBBZa+3Nn8GPPaLvB+rJRrQS3s1
	TqVokjKP56xjFTO0iAxA5XExgkqT7mqh2RQZeasK/vej0lGHLs+yS+oblHbPjkU3WSpewk
	Ftg3kdCSThn5XTdsJhV7vd9cEuSidSo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DF911476;
	Thu, 22 Jan 2026 03:07:52 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD5E93F632;
	Thu, 22 Jan 2026 03:07:53 -0800 (PST)
Message-ID: <3aaa3e5d-7f66-40fc-a5b0-ea6a384a88a8@arm.com>
Date: Thu, 22 Jan 2026 16:37:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, linux-trace-kernel@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 Branden Moore <Branden.Moore@amd.com>
References: <20260118190939.8986-2-shivankg@amd.com>
 <20260118190939.8986-7-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260118190939.8986-7-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13F87100006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u6eh63yhdaghiywyf18bt45f9s4p1tc1
X-HE-Tag: 1769080079-211690
X-HE-Meta: U2FsdGVkX19ChRoVG7BeiyQQ67le++eAWBjh13Nh9BYpHIBeRsExBqcHdzUOmYB6I9ydKlizliqr0Alm1fLfxRYgmY/5Qz0ecUCRCoO3tM8KPWmkhoL+A4fctgwObvphtTIGf4UtF956IRHiObn9mBIixV/bJ99ZL3ut8Uta+j3N/gpkB2raSNTdYRSc6x/ita99r6eHwppWtDqaJWOQgVaxZcqUOli2pNKsqgm5m6qQqxRxW1LRheOA/eASXVxJqxs1Lo8TIvhE7k5j2P/AUHdETrDTM4tDIyl6mG7n99WTmcZUXuCz3JQVNbQbDh2rdnnwIV6Zft9mG8Iy3wAIe1+Yh44occGT/pgRDBsDRLf4lJ3mFOaxd/0Yen0e4LUAqtmZuiwJ+3aHWCvW/PbuRRepnckbcn+gzxNJ3Piud74mtEHPJtMq20HVF7ym4m0/V+E9eP23XK7f0YI3QcV4zyDu59BpfLz0ADeN065J/t6Eth8L4JsntvOcA1cSDsxqB6NNVLnMObkrX5ZgyOFokllwsfIe79vJ5qhpnLlg+xWvcWdyB/djJwUivwwL+daUOYab368cx0+qgaTaptHw6wXhHkLyfUPo6wMLYJ/XQf0cu3gE6IM01HpKRBuVi/vHp8eP/PT7S+8uKiz0NKoRHvueN0oAoVyspz2XlFooyDVUae9uvwX/UH5gQz5fJhnPnPG/qkjrahNo6PmkoeY/01NF+E8LNa+7EtV3k7ybFgycyOd41NHOdT8DhXg3pEgZxIFTWq02l9b5mS3NHxvQwkxlin7z4Urgy8XoMxU4n0v3NC+yHOyl/ZF+/rRv4jqgfPUte/Se8/Efk9njdsq7irH9PqpAuIzVnNpJYnNLOh7p9hA2xKoONo2juoH8JwgqlOkhC4NLp5To7YlUnE28zO1T2JnWVdAINSezQxAkKgMe/QcBFaI881/dRPBVvhqb3arK6X+eQumL1FU96/E
 siyblLFP
 geZ2W1IgUWAE8RUB5LZx0TPycoQ5rzrdLUQPCQebx/hCA5dytuPdLUg/urTJr1TkEOXXgxVT1mfDEgZ8yvzXOZrsJV7/Ckd4sQZ4pCspLLLRH2MoDZI8k39tSxEfxyD1VwekuRy+dzTxQK5B1ozYl945msZT/mCnTlE4BdRmHYe+7p+W6SI8N952NtvlheYd1vNc9oD8Bqmd6Nmz4Of/RFmePbnr2ja01634Zgc+8bWoZSxQ7aTkyweCB74GF4METPgl1kuYMBeq7Oi2FSNiwAIZLpfIgSHscKi7kua2HKSBFw1yM6QWqCVb/1eVcnT/wOJ2+fR99gf3Ye1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 12:39 am, Shivank Garg wrote:
> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> text sections), the pages may still be dirty from recent writes.
> collapse_file() will trigger async writeback and fail with
> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
>
> MADV_COLLAPSE is a synchronous operation where userspace expects
> immediate results. If the collapse fails due to dirty pages, perform
> synchronous writeback on the specific range and retry once.
>
> This avoids spurious failures for freshly written executables while
> avoiding unnecessary synchronous I/O for mappings that are already clean.
>
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/khugepaged.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 219dfa2e523c..16582bdcb6ff 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -22,6 +22,7 @@
>  #include <linux/dax.h>
>  #include <linux/ksm.h>
>  #include <linux/pgalloc.h>
> +#include <linux/backing-dev.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -2788,7 +2789,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		int result = SCAN_FAIL;
> +		bool triggered_wb = false;
>  
> +retry:
>  		if (!mmap_locked) {
>  			cond_resched();
>  			mmap_read_lock(mm);
> @@ -2809,8 +2812,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  
>  			mmap_read_unlock(mm);
>  			mmap_locked = false;
> +			*lock_dropped = true;
>  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>  							  cc);
> +
> +			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> +			    mapping_can_writeback(file->f_mapping)) {
> +				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +				filemap_write_and_wait_range(file->f_mapping, lstart, lend);

So we don't care about the return value here because this is best-effort.
I really wish we had in our coding-style.rst to typecast such things to (void),
so we know explicitly that we are ignoring the return value, and not that the
function itself returns void.

Nothing jumps out at me,

Reviewed-by: Dev Jain <dev.jain@arm.com>

> +				triggered_wb = true;
> +				fput(file);
> +				goto retry;
> +			}
>  			fput(file);
>  		} else {
>  			result = hpage_collapse_scan_pmd(mm, vma, addr,

