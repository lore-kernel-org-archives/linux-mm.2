Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01778109B467
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF946B0092; Tue, 31 Mar 2026 09:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7246B0095; Tue, 31 Mar 2026 09:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3139D6B0096; Tue, 31 Mar 2026 09:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCBA6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:30:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF189E0263
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:30:15 +0000 (UTC)
X-FDA: 84606441990.11.F7A35F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D43A8180003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:30:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lF4B6pby;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774963814; a=rsa-sha256;
	cv=none;
	b=1SmcNj6vAv/7f0CQmNxH0Va5AYVyd+kTTZgbPC/DIKsveBtNyn6jia1BvA1XVNtzk626/n
	aW77Gi5Re/8wlc9bws8Na8T45SUhf+1dRoLc0vJzNeqmrdDiSeYtI5//UMsj7qqj3bRUlr
	s5IjcfLQcMnCteQLzq/ChUtOcaZaMs8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lF4B6pby;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774963814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBBK30fCkNm1lUdVhCyyJK6HKTW0gxFVTBMvejrE/Lc=;
	b=HTAJSbe/OOh9x9mA8N5gqSSDFmDLkW0l03Nreo09Lcac4ui9wHYFySctzSj5HcakAzWeYI
	MGh3oF3XPiMjrB8G06pjVWTn8yjOhjfFoQiTGoyHzzcse354SYdOy7ApDkiOe4qnzf+C4K
	r1UTrqBN2TwhOWaL0J2JWBHg74R2VPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6B7F41B3C;
	Tue, 31 Mar 2026 13:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E409AC19423;
	Tue, 31 Mar 2026 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774963812;
	bh=UeZZK6K4qJ6/l95AkoqbqsJOmBEmzy446L6mESN+wLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lF4B6pbyVM6USIUyTtPDT54iNbFVWiTse/2OX2uSfDWt0j0aKV1JH0vjzEk3SpQQt
	 6nADLQAF0A+YQF+vuoHcv2gQP3rnG9uuwOFjGK6ORxvUYL78lBKOVYSDWFxhKY9/8L
	 pOrOfYs05VxJ005QYMo+O2O+NMKCpF9BklAm2emaGpTyidMF9x5xBPBU5WCztz86IO
	 90y3lkWINYEUGeRq4SdPaZfzlWGkBIUBHJlamNt9e3Naia+FtEq+3ET7uAGUxRdJVw
	 FUfzU/APYb0dI16oJ90Zgkw005LXteztjyB6hp7a8Nk9BMjiUHSLMDh0TtImIJ+zV/
	 xuEDPJ92W1VMQ==
Date: Tue, 31 Mar 2026 14:30:09 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Sechang Lim <rhkrqnwk98@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: fix memory leak in __mmap_region()
Message-ID: <e08a4b07-b067-4eaa-9848-4bf2cccceafa@lucifer.local>
References: <20260331121906.1301155-1-rhkrqnwk98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331121906.1301155-1-rhkrqnwk98@gmail.com>
X-Rspamd-Queue-Id: D43A8180003
X-Stat-Signature: kq37jfrwpfxpojbc8jry7oeshd6f4zor
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774963813-647015
X-HE-Meta: U2FsdGVkX19xpWG6krG1bE5J7XD0USLQE9IO8CkpQ8P4pGMuebKjHSMXTdRkV6CBsmcr5AnOcM69cxL+PJ9AzP2CPeToIjOr/W/A7RXSS4y1G8cpi1zmp7aK7QuKUUxckRsl2th+Nikj0G6Ejin4a2kvki30jaHncMov767zP8c0AMgb0YgKBfdKXMlfJa7J7aBgdkTtDSSK7UtNdMDasY+xh63+FEkwmb4t4w/9m7OeG7NFZp6UgOw8FSNbm5R6g39apMo1K4SDcRMXHziXqF6vUE88Ud90x744bEs0lUEuXLe8dhXvKsZOpeuZ0DZUOpdzY6brH61gOAOONj5fMS+YStvmQ0mXQ1WAcZ9JwbbJgfqQMR7oeHI1HXp/PFy5UVmlF5dE+bDrw8zJQ6FbTQrfVNDWHpiywh1rSo21Rfoj4a7sIvaAo6dqPNfS5Ofxx7A4M1bA5053YFKIwUQyy0IskjfuqI2IW+SxSaWn+lQsCTN6dvBpLTFd4At4POsq2+u88VzH9zAlpGsEiyXpf3uJWs3oBaui7eSmqgXpkOfELmi2HI3f+91engsnb/mJ3B7ATzzPCaOCxzVbYmiAjh7Px0bml4hMLv18/L8m4I2rmf9InvLd9v+UD1fc26Fc3h7200Cqejpy4H6RjFc39PQjVnJgQrXiFmHj2ZWKQva/QBZWW0epIwvEoQW6lJCKWip7fgswm9vMnSMrYbSMbR8gZ7GwYl2jdn5OLdoKao/YjA8Il7s+FPQEqV/mvXtrJ6+PBl36KUkph10oyy6GV275F5iHURg81x+MfNGPKQ6/PUVPoGGF5+qirz5Zy7epy+liYe+LWkC00PVyrKyLXaZQDxaO/BSVsAkS/+0h0ouvszXG+ndELO6ZNrnmgJZfWxec8gO7hjOQpmYH8mf/yHi38tuji8BYdWVK9yFxOGYXoHadEiEHd9G2XFyOyLzv6QY7EYz3NeGCHme4QOX
 3fZivocm
 YCHfh23cHZlnI47q/Elkjw9n/TtsBT9385ryV/9ZotZ+wLZoGorAOId+b0NEi4+vWgrVzWqT0osoCAQLWh236tC3hZWneWBlMcLTGzVb/dsuTqTMSkAPSnuTrR/GTfpUHJjvu/6B3U/DKdr/PiA2MPomQypV9P6274QIcAdbL0otvYQ84rUNmcYjNXv2/2JIexidVG/E+NKz8HvZtOwppVEKH6hk6QPp3iGjFT7ixzQT2uOvr/mS+4zgwVyOv2xHWDSRFntzJ3aVqIlpYLw7g1tJVTDr88fd5opRoWZHwctZL74JfrmnlKf+zmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 12:19:06PM +0000, Sechang Lim wrote:
> commit 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare
> swaps the file") handled the success path by skipping get_file() via
> file_doesnt_need_get, but missed the error path.
>
> When /dev/zero is mmap'd with MAP_SHARED, mmap_zero_prepare() calls
> shmem_zero_setup_desc() which allocates a new shmem file to back the
> mapping. If __mmap_new_vma() subsequently fails, this replacement
> file is never fput()'d - the original is released by
> ksys_mmap_pgoff(), but nobody releases the new one.
>
> Add fput() for the swapped file in the error path.
>
> Reproducible with fault injection.
>
> FAULT_INJECTION: forcing a failure.
> name failslab, interval 1, probability 0, space 0, times 1
> CPU: 2 UID: 0 PID: 366 Comm: syz.7.14 Not tainted 7.0.0-rc6 #2 PREEMPT(full)
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x164/0x1f0
>  should_fail_ex+0x525/0x650
>  should_failslab+0xdf/0x140
>  kmem_cache_alloc_noprof+0x78/0x630
>  vm_area_alloc+0x24/0x160
>  __mmap_region+0xf6b/0x2660
>  mmap_region+0x2eb/0x3a0
>  do_mmap+0xc79/0x1240
>  vm_mmap_pgoff+0x252/0x4c0
>  ksys_mmap_pgoff+0xf8/0x120
>  __x64_sys_mmap+0x12a/0x190
>  do_syscall_64+0xa9/0x580
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>  </TASK>
>
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> BUG: memory leak
> unreferenced object 0xffff8881118aca80 (size 360):
>   comm "syz.7.14", pid 366, jiffies 4294913255
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff c0 28 4d ae ff ff ff ff  .........(M.....
>   backtrace (crc db0f53bc):
>     kmem_cache_alloc_noprof+0x3ab/0x630
>     alloc_empty_file+0x5a/0x1e0
>     alloc_file_pseudo+0x135/0x220
>     __shmem_file_setup+0x274/0x42
>     shmem_zero_setup_desc+0x9c/0x170
>     mmap_zero_prepare+0x123/0x140
>     __mmap_region+0xdda/0x2660
>     mmap_region+0x2eb/0x3a0
>     do_mmap+0xc79/0x1240
>     vm_mmap_pgoff+0x252/0x4c0
>     ksys_mmap_pgoff+0xf8/0x120
>     __x64_sys_mmap+0x12a/0x190
>     do_syscall_64+0xa9/0x580
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> Found by syzkaller.

Which syzkaller, a private implementation?

>
> Fixes: 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare swaps the file")

Probably don't need a cc: stable as we're at -rc6 and this is from 6.19.

> Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>

Logic looks correct to me, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

But please adjust the logic as per the below and maybe respin for ease, where
you can add my tag also.

Thanks, Lorenzo

> ---
>  mm/vma.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..89073980de46 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2781,6 +2781,8 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  	if (map.charged)
>  		vm_unacct_memory(map.charged);
>  abort_munmap:
> +	if (map.file_doesnt_need_get && map.file)

Let's add a comment please. It would be broken to set map.file to NULL, so we
don't need that check. Comment can be something like:

	/*
	 * This indicates that .mmap_prepare has set a new file, differing from
	 * desc->vm_file. But since we're aborting the operation, only the
	 * original file will be cleaned up. Ensure we clean up both.
	 */
	if (map.file_doesnt_need_get)
		fput(map.file);


> +		fput(map.file);


>  	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>  	return error;
>  }
> --
> 2.43.0
>

