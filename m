Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8C5CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 04:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444146B000E; Mon,  1 Dec 2025 23:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5356B0010; Mon,  1 Dec 2025 23:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BCD6B0011; Mon,  1 Dec 2025 23:50:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3AD6B000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:50:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFBC5B99F8
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:50:25 +0000 (UTC)
X-FDA: 84173304810.18.7CB75D4
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB2BC8000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:50:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vhf4fPTv;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764651024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGcwHsaLozazj4k3fLuhDAgiJq4CZqWj7W2bZnDVz00=;
	b=vV7yWbewZaY7o7kTDeISL5sOM3sUe4sDtTC++jvaMPHEAkJVe0lPRTK+PfFXpELO9g0v19
	Qb7DeQsIPe79ubGpUWsT2G5yakVZM9LO21tGUVmKf2xTdMWXRTANIk+tNI9kx3JMB1wjum
	vjfUsTL2Dx298FBb1DXo5Iyc1sknzRg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vhf4fPTv;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764651024; a=rsa-sha256;
	cv=none;
	b=KEwTEZm9RRU1GJKypzCfh4ctWmJCTmUM2rkn2DVMEUpzv0dbTn9UgBRt+GMkAeHNHK3Zpa
	MQakFJxMvGihRGon8GFxnVzyqqLuiuMeCH34vHL6vyniHMMgZrTJf09/R38+GYIg7oAbQf
	zFkWu+ApaHNIiNnufLIm1CQIlmeN76o=
Message-ID: <a8cf9fd2-4521-4068-b436-9a251a6eb15b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764651021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jGcwHsaLozazj4k3fLuhDAgiJq4CZqWj7W2bZnDVz00=;
	b=Vhf4fPTv9xrM0TVReTjEl9+EMYLp0tEVePWzanveohCdmTef90eIKFHknogXNKZ6Le/z0o
	I61Y4XwSd4fu3+0t7bqLxX3HSqN+jT8VusYx/USEQ34m668NGVbuciyZShZdeDO+u2yYS+
	H1D/xZ5EkUmxb/QqNVzS6uP7R+KOe2U=
Date: Tue, 2 Dec 2025 12:50:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V3 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song
 <baohua@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Branden Moore <Branden.Moore@amd.com>
References: <20251201185604.210634-6-shivankg@amd.com>
 <20251201185604.210634-10-shivankg@amd.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251201185604.210634-10-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BB2BC8000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fgoegj38ge9onp8ti1dexyd4e686dywp
X-HE-Tag: 1764651023-213477
X-HE-Meta: U2FsdGVkX19Aqc/Nx19hmOn1rGDD1Ngdq8mhVG7+xFQ9hZEKVtW5+2ls1jdX0aMTt5A24GiEe+fbJvodx7gaCKMhwsOPvAH9kULesXJ9Mtr8MLEwapBYu+J9EF7SjHTTcoG8ccpdjVaV1AHM+YEquolZcsIAIzWg8u0U6hwhKRDgiOmMpsCt9JWxRjiMc6xZkZIdYyjiZ0uZ8kFs9wRmYk8MWg49qzMWQS2j5qUHt3hIoyqZWYjNvbC87FVvRDqoWQYevKISg+SDbv/57xcFQFyQeGKK/KAh1qBjljzCGQdZYT2UJPxiIwQn+Atc0FOxvDWTTAZCra9GJ/+GAxfgCtoJDiKAGirbfcN1Gj5sxzyiX6f6oFAXRhgHIbhXzoip+clvOF+21A4p/3AbUYHda5KdUT59iElFas0C145wvwZzWd6j0/Wvde1zYGr9QNwi47Zl7d1Wz/fzUHknuS31VguRK85UguI1qgze2mcSDbBYLf0yFkIQB1sNB1evtbt+1H/mBcuq9Im07AbX5zqL+wGD6TbUugWFKQU6QKKNeHAYVjRlT6ryFZTaXiXJqdGGlSHP/JYMN8+zrh/Ac5FYxXoQEhYgm3uzAygCsIyM5mW6oAFYB6YNnlvu0c2pmnyP7U8koI6FO9chxkVdPRcPhaGc2v/C1mLFl8tIfRMcOuisAjTzzFubhMTosYEnEtMm539FWojtkvUI0H8y6Uv3//aMd37Lxu+aZ5XVNB38OwY3oNskS3uGBSB9hst5gjYpG6M7lQjvD5ObYjlwZ7sV2R3oNYjOXhx8vlif+1IGUuumLY5BKCxoEXG5jpCs/mX70dBwTNJ88m4ukubxgFbyU6Yk6xEYAT8eAQ4joC4Zo2m8AHOoKDs8E5sWQ9NHcF+q5P6WxpLXJBkn62rXREe8llSLN2fULVOMqBg6KnKV7Lnurp0/7bT8LWCEToy9scYDOnK4J8y95tY9vEhDk/r
 juIxGstd
 EgkQIZbwgZ3eptDxxwTAluxf9IsuKfG3RWBXUCq8aGXp0KhO9DnzFwov43jnomll03nMt49LRfzqddtm0HcWeHQXeQ6VdYSZuCXuIxXgbB09A+H1HlAh9NgdRoGsVfEwqbwSuZHw6VZu+kQcUEOKKb2NbMGdYONJqTqelZNAUhFqR6JVtaQ1rg6mNcSbNfuZkjFZuIeH58aYHOmFR31J3A6q4PuwcSUhO5xkiHJdF29l9JXPA/UBp1dTcnZz4UIWCku/79IFpyHmDQolJVK+qcwMgBoiv0NTe6JaDBkZe7FcmhkPvS91jOYFLYVxZ1cYvBts27tqb7uBWmyRJu4LE4EDjrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/2 02:56, Shivank Garg wrote:
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
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   mm/khugepaged.c | 41 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 219dfa2e523c..7a12e9ef30b4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -22,6 +22,7 @@
>   #include <linux/dax.h>
>   #include <linux/ksm.h>
>   #include <linux/pgalloc.h>
> +#include <linux/backing-dev.h>
>   
>   #include <asm/tlb.h>
>   #include "internal.h"
> @@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   	hend = end & HPAGE_PMD_MASK;
>   
>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> +		bool retried = false;
>   		int result = SCAN_FAIL;
>   
>   		if (!mmap_locked) {
> +retry:
>   			cond_resched();
>   			mmap_read_lock(mm);
>   			mmap_locked = true;
> @@ -2819,6 +2822,44 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   		if (!mmap_locked)
>   			*lock_dropped = true;
>   
> +		/*
> +		 * If the file-backed VMA has dirty pages, the scan triggers
> +		 * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
> +		 * Since MADV_COLLAPSE is sync, we force sync writeback and
> +		 * retry once.
> +		 */
> +		if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
> +			/*
> +			 * File scan drops the lock. We must re-acquire it to
> +			 * safely inspect the VMA and hold the file reference.
> +			 */
> +			if (!mmap_locked) {
> +				cond_resched();
> +				mmap_read_lock(mm);
> +				mmap_locked = true;
> +				result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
> +				if (result != SCAN_SUCCEED)
> +					goto handle_result;
> +			}
> +
> +			if (!vma_is_anonymous(vma) && vma->vm_file &&
> +			    mapping_can_writeback(vma->vm_file->f_mapping)) {
> +				struct file *file = get_file(vma->vm_file);
> +				pgoff_t pgoff = linear_page_index(vma, addr);
> +				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +				mmap_read_unlock(mm);
> +				mmap_locked = false;
> +				*lock_dropped = true;
> +				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +				fput(file);
> +				retried = true;
> +				goto retry;
> +			}
> +		}
> +
> +

Nit: spurious blank line.

>   handle_result:
>   		switch (result) {
>   		case SCAN_SUCCEED:


