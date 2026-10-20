Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEE4606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F1hGJ6pA
Received: by kanga.kvack.org (Postfix)
	id 5E8926B03C6; Mon, 19 Oct 2026 20:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B346B03C8; Mon, 19 Oct 2026 20:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4891F6B03C9; Mon, 19 Oct 2026 20:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245666B03C6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:47:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 958D714067D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:47:03 +0000 (UTC)
X-FDA: 85341165126.27.D8D3566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DD8F1180002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:47:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F1hGJ6pA;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792457222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THCDFH8janu1MCJy9xPLeuhEIpEIYRM+RVgL+pWhx/0=;
	b=ti9GXrVefSNc4MHwWBVFzJGr6x9D9GuTkv4vS4HPsu/cQAggNvb3bwXyNB/gJjAb9EFP8E
	U85wKgt0NCDdsqie7BSY4uV+O4Fc+Rceuy/64U/cyZUV5ir8rjJobWFIcmjPfyDmmV76SO
	hyDU68+r6MzqJfeikz2JS5RL6tzKWXY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F1hGJ6pA;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792457222;
	b=pg2yg094TGSB7Tp3n/55KCXai4hJpMs6Z/oyehogqgW0lceFS3hynzVNWymn+MRdOS3oI0
	h85OD4xMrEakc7+rtzU8YZ/NEH6LNyIOm3GrfjSxViC4oEmrq0ioZMbe7po3YLtbdTLRhj
	UBwbBzFTtWyxFZ2DEtwYGXqpY9H5Th4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BBD960098;
	Tue, 20 Oct 2026 00:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC5D1F000C4;
	Tue, 20 Oct 2026 00:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792457220;
	bh=THCDFH8janu1MCJy9xPLeuhEIpEIYRM+RVgL+pWhx/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F1hGJ6pAbEUEAurSVOl+WnA5fdZw+wqQYEUu6cMp/lLLjBcE34O+QMYZC1x8+DJ2L
	 tZo9oDX/oObaWYdmkLnukB8KWe+mtc0V7Gi16c3hsyRRrsrCokqr9XZAgasJQrkZ6X
	 iOJ5bwpX2VfuWZPHlXUn/QEmaQRKpWVU0E7jwHqs=
Date: Mon, 19 Oct 2026 17:46:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ngoc Quy <ngocquy0700@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Muhammad
 Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Message-Id: <20261019174659.42c3529d5e35563cc6e5244c@linux-foundation.org>
In-Reply-To: <20261014095540.3261469-1-ngocquy0700@gmail.com>
References: <20261014095540.3261469-1-ngocquy0700@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD8F1180002
X-Stat-Signature: tfh1u9hm1bkri9jnqm7ui46zg1kx6r6u
X-Rspam-User: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792457221-991020
X-HE-Meta: U2FsdGVkX19A1PJ/Lyj7seFZnBRkaZbpuNxBIA6ApMDCtLQqCmwHodrd+B0LtlwRZ2ey1v6AHSs0Pnn7/85AWyGiF1EZlxyrBw9KPqL5krMNFOKEo5viLH2V9xzXmfOAjgMwkWpZt10ntatA+XHl4muIBUeP4yM3pHXOu8j+2/tDWpFC/eHd29Lk2TbQkCNtfhrl0cDcqCd45RX77vidqpBF8zIX7qyxO2jhxNLtLP4qsBBGU/raOdAWvI9LvJJYWnD8wVVBLg72yeU0bsdqNuEWbMLtDaoYQlqqhFOr8cun7rIL56NAY1oYEG08E0VGRbWqBsp/FSNGIIxDzgyYF0P9+EO89PkwGC1POxQjnQIqQLMdmima2Jzf8KxINuntbQvK0xxd9mx08Xcx1PovNS/nAW/nAzV7ughyisBjhMnx6Z4fRXTvH119zreXCxz/JmOsHlZOmjFVnrCIy39woYVxuQx7ZwfuRs3Lbynu6xm0iT4fAXZGhkXN6WcyY5hU5hAOOZvxgwQbBv29lEBEVIZYS6KTWhFq8Op1iqquEjcCYHEvWW18yGVVlUhKmAFKauq9p3GwN1cP47Pk+I+g3PVkLdp+y9Gk0r+U7Xs8F/F+7Jnb8uITnSR2qT5DkvgbfpjD0oKS2mWq7QYUUDJBYismSb+VKCJDXDI/zlUDmQvGfdBQiOIi5fiqXe1qb7WjNKAEiyJNiyqGCkifAvdsLwdaGMDfanD8Z8KB0uqQnG5SWYmzMXtjWl7HGOULZa5eZXrJz9PDqdL9DyPE0APYY9jcboMxvDyXcDjoFjT4mMmU4EsQSPRXSlnk9XPaTJnB3wlYlcjlzfSoDvPeMQtpCQdDLvmUxjK72IOR1Wzw1tbYYeXXOVTAS99l+LUyIyE3dO6Qo6LAIS2T/9EanT3cmIYT8gRozs6dxhZwf9/fHUt2W2UZxQ6tBPdFiOwOQ8qt2s52uzK2Y1X7F8Ww0cL
 1xT7BEfV
 KzEOgEI7TP9frNyTz7YxvGXF82mO4S2ox0ZMOpWRUwsdaURhHVJ6c1HB1gWy4r+NmFgjhdJizbZlN1XTjWbWXHRKkLOWLJJ1JShpWFff78R6Xa/4ppPpA61KAx/LAM1YxF9ZNSsBaTcCdMIvE1YDnNpehfggcpoFZ6JoIWOeDrz2rZquaSL9p00xJF4KTnUjyWOEXTD22o8aIg/8J5i9Gt91Ef6Z+IfqpaVjwJgl4zcuyMVpJh2n4gnLPGhbkW2gwI4sZwEj/alDmSGx7kQ9U1xJ6mvcl6vBeLwKxDq4uEnydhxc95iaOktIyMfQad5nwDrUD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 14 Oct 2026 16:55:40 +0700 Ngoc Quy <ngocquy0700@gmail.com> wrote:

> The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
> /proc/<pid>/pagemap without holding a reference to mm_users.
> 
> proc_mem_open() deliberately grabs only mm_count, so a consumer that
> touches the address space has to call mmget_not_zero() first. Every
> other consumer in this file does -- m_start(), do_procmap_query(),
> show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does
> not.
> 
> Without that reference the target can reach exit_mmap() concurrently,
> and exit_mmap() calls unmap_vmas() while holding mmap_lock only for
> reading, which does not exclude the scanner. For ordinary VMAs this is
> harmless, as free_pgtables() and remove_vma() run afterwards under
> mmap_write_lock. A shared hugetlb VMA is different: __hugetlb_zap_end()
> frees the VMA's hugetlb_vma_lock inside the read-locked phase.
> 
> walk_hugetlb_range() can therefore load vma->vm_private_data, have the
> lock freed underneath it, and then down_read() a freed rw_semaphore.
> The load happens before the freeing side clears the pointer, so this is
> a use-after-free and not a NULL dereference. Any unprivileged user can
> reach it with no huge pages configured, as hugetlb_reserve_pages()
> allocates the lock before the VM_NORESERVE early return.
> 
> Pin mm_users across the scan, the way the other consumers do. mmput()
> from the exiting task can then no longer reach exit_mmap() while a walk
> is in progress.

All looks good and checks out for me, thanks.

Except...

> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -3231,15 +3231,18 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
>  	size_t n_ranges_out = 0;
>  	int ret;
>  
> +	if (!mm || !mmget_not_zero(mm))
> +		return -ESRCH;

Why the new test for !mm?  The current call chain guarantees this is a
cant-happen and the current do_pagemap_scan will cheerfully oops if
mm==NULL.

If we start getting mm==NULL passed into the function then we want to
know why, and an oops is a good way of bringing attention, Quietly
accepting it reduces our ability to find stuff we did wrong,


