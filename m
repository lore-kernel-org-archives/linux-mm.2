Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F64CF8854
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5053A6B0029; Thu, 20 Nov 2025 08:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5316B002A; Thu, 20 Nov 2025 08:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3FF6B002C; Thu, 20 Nov 2025 08:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 291556B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:01:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8487F160869
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:01:30 +0000 (UTC)
X-FDA: 84130996740.29.2AA3231
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id 104B0180010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:01:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=usJJd61n;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763643688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Appw5O9xn9vKWf0A+16v30yLtvA63IpanK+xECauBoM=;
	b=vrKJHU/oO9ShyQOLC6BvDgQEGk6AwNPDPO4rQWm0rXiDXyFjogw7Zfo299nGxuiwoBIua7
	QZS+gPHjvzA2JqbhvM0ZJVk8bHCwr3BMqQyEKWs9ZlKQyTtrv7sy5Pm0iBL9BG5PFLkFRh
	dDe7XVmPRKgyr8vkmirpciGmOpYhFuM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=usJJd61n;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763643688; a=rsa-sha256;
	cv=none;
	b=ukpnYl0b+LI8IjRwg5M6yzijCtxlLwOL8bMToYPGGG9KYDiEiWAglLUcRdLza7hN2A+B5V
	1h6O87jCmNLBcYkuHZ7kAG/8aisaN17MdSgk/LAE21wXTM2pBhttGErgYGgSnX3gnoy7bB
	cY5DPqRgSScIse4XPW2kVAJE1E+ZAEg=
Message-ID: <f4652d26-a0f0-4ffe-ad53-74a3418c75e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763643685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Appw5O9xn9vKWf0A+16v30yLtvA63IpanK+xECauBoM=;
	b=usJJd61nfgOrgJv9VkEZ3PMKtrtJaJEjNlVH8RWyyQmyKQb+9SiV7pZ0w1OZPZ1n9HBCc9
	xoFEYp8owtU2QvVmNzWY2cX9h/gQJ517YAyli+xGAvQDmkG+LAEU3kpCek5pkniDCNt3vG
	saFS6TwzqYvcFwtasFMFWmyOzqAjkI0=
Date: Thu, 20 Nov 2025 21:01:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V2 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Content-Language: en-US
To: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, David Hildenbrand <david@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Branden Moore <Branden.Moore@amd.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-8-shivankg@amd.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251120065043.41738-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 104B0180010
X-Stat-Signature: 63f63ko3aitt34pkeytwkrwiepchuc9s
X-Rspam-User: 
X-HE-Tag: 1763643687-828517
X-HE-Meta: U2FsdGVkX18k2OvMrJU8VBSbVbz1Ep6rdJimZvRFya4kZ3sQMCF3NWL/ZywWr85jzUfVtkegqasG2cfouk1qsmQm7saaEAWBNvev6DM/Ta3YUygSiuXBemYR3C318fI+WmtBrcfAnHj5omtY96jwjK74Ha0mdC78aXCtuol0hTzOkdv/lE86stCzTb6iiNGEPai8VjBsydaoX33d0SbDUVSMuwotqIbNKWRBS8t4XfHh1HCqZwbVcrVqCQIrD9x6X3HlU/QHTOWDJHp7kLJbOcfnJik1B3BnVyFkHkjcvPKADyP/uKaHHCJFXBnRPhefUJ6Zy9gsDblvDTBwzm39WFQOd45yxIEuwileNr90NDIJh9MVtgNichnn4MFXItTdBFySOiohJWcRdk9uDlLlkSHSo03Msk8dYZ1ruLXaMnQCF7N+rGWXwt3I/8P4ZIdCh7EMBSbEeAWAAtaS8dgOXTeYUrPN70WlqhPsQ+E8oTNRm91kVSjWgD0jbcwOANjwW1Vvb4a0uP3t+QeaEiC1FBOb1Mb/EbB2kZR0A7tjU3ugLZNFrkTT6Yd/S9EmlZqCk3sAzFIDuKWzkHIBHl5s6Z4PggRljtc5GpKn/32A/OlbCchxZm+knzNaAKylMQHtLbgVfnwElpXDu71kAqcNBXRX8klbVVdKhJZoz0qW602vWKuyiuK050XkREyWq3RGffrdIPbPv2F97wO2rtRSzgXTqRAZm0n+y29hmHI3Eez8IiXDAqYbzPBZN0yYQqwIJo2X3SLwwUnC4gvxC23iDh9FodBFHUMH7To2yVU1pcyWp8kScW0dXBIrVusHUOp/FfY6IJZBbhxAq01P/y22UbENzpL45rpFeZ4GA84/fi7JsKCZTxP4jRZmQKw5ZXjrxduYFwJxNlUl3WounX0u1aSn7A/HA7P2DfEpC1jko3yjBQSFadwqWNeiWWC1nQqQxgq2LXqKA/XLwdNpWT5
 ync/3ALG
 OMBqFO+0K/gwh5GYlyXJ2daJ0gb+D8ZglMqbGdp5lJv/uRm52jy029+tpu57iCWgQXOdWv0+SKK+OvFGBrgJw1UHfe1cMy0RWN6d8lCpUMlSzhOvWTzCAF04f8fUy9BD9evU3bUZPZGTbcioJwxBXDE9FvGoxLxfvfyA9N7R/HhZBm+hL3Cyhd0h9jaqBphyFxKvsM1LL+vx/sYZQi4jFP3tM+dQC9IW0hgnPs9/XLosi5B6XiozFJdyT4QDjpx8qtCLKLm0Bcy3cZ+5f7KZtlgqOyUkVxwQH2hYLDVLjSKLcMfRVydiTQq6gPiYRwtWXMHH49iFZ2x/eVbfZjTK/6cSwdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/20 14:50, Shivank Garg wrote:
> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> text sections), the pages may still be dirty from recent writes and
> cause collapse to fail with -EINVAL. This is particularly problematic
> for freshly copied executables on filesystems, where page cache folios
> remain dirty until background writeback completes.
> 
> The current code in collapse_file() triggers async writeback via
> filemap_flush() and expects khugepaged to revisit the page later.
> However, MADV_COLLAPSE is a synchronous operation where userspace
> expects immediate results.
> 
> Perform synchronous writeback in madvise_collapse() before attempting
> collapse to avoid failing on first attempt.

Thanks!

> 
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   mm/khugepaged.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386..066a332c76ad 100644
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
> @@ -2784,6 +2785,31 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>   	hend = end & HPAGE_PMD_MASK;
>   
> +	/*
> +	 * For file-backed VMAs, perform synchronous writeback to ensure
> +	 * dirty folios are flushed before attempting collapse. This avoids
> +	 * failing on the first attempt when freshly-written executable text
> +	 * is still dirty in the page cache.
> +	 */
> +	if (!vma_is_anonymous(vma) && vma->vm_file) {
> +		struct address_space *mapping = vma->vm_file->f_mapping;
> +
> +		if (mapping_can_writeback(mapping)) {
> +			pgoff_t pgoff_start = linear_page_index(vma, hstart);
> +			pgoff_t pgoff_end = linear_page_index(vma, hend);
> +			loff_t lstart = (loff_t)pgoff_start << PAGE_SHIFT;
> +			loff_t lend = ((loff_t)pgoff_end << PAGE_SHIFT) - 1;

It looks like we need to hold a reference to the file here before
dropping the mmap lock :)

			file = get_file(vma->vm_file);

Without it, the vma could be destroyed by a concurrent munmap() while
we are waiting in filemap_write_and_wait_range(), leading to a UAF
on mapping, IIUC ...

> +
> +			mmap_read_unlock(mm);
> +			mmap_locked = false;
> +
> +			if (filemap_write_and_wait_range(mapping, lstart, lend)) {

And drop the reference :)

				fput(file);


> +				last_fail = SCAN_FAIL;
> +				goto out_maybelock;
> +			}

Same here :)

			fput(file);


> +		}
> +	}
> +
>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>   		int result = SCAN_FAIL;
>   

Cheers,
Lance

