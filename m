Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398D910F92EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A006B009B; Tue, 31 Mar 2026 15:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1646B009D; Tue, 31 Mar 2026 15:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E766B009E; Tue, 31 Mar 2026 15:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 831BC6B009B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:24:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37EFFE05F3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:24:46 +0000 (UTC)
X-FDA: 84607335372.14.01AEB38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C071080004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:24:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXB1Wwua;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v88Xlicu5Fth/vTAfZFiC2OrbqIQebe4y607Kzfir8Q=;
	b=8cN813ESKtjeL/jSwxihJVQbpkl2vPdBsgJCMWxKxPiSAAiOhFWkRf+kJDSAZIYVnPgZD+
	oOwj2n9dLaPr+1YTA3bFKtYdCH0vah1cVKSck7FOgotRx9UbvjjjyIQyGiTDr/tcFlJs0S
	iV6a434CeYFPtU6uMv6YwGtxYfjwvqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774985084; a=rsa-sha256;
	cv=none;
	b=wkLCSZBpZwoZj8M78NA8Np8o0a6Onl1cJHHqU66sXBFkAi6OF6ieqUI+GCee69cM7Lnogf
	+CBcscBjmALN3AAbD2E79N1V+3CKfLPAVUKFZIpfDUcpOjHshqSYLnW2WRJQV+RpUD+BvZ
	TrYjEktJf8HzW9z1n9sfAC5Y+e23ooI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXB1Wwua;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 490546013A;
	Tue, 31 Mar 2026 19:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C99AC19423;
	Tue, 31 Mar 2026 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774985084;
	bh=xemZwA+DY10NubdNr9MMZk8IhNI5I3mPETxcp984L5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jXB1WwuaRMLJEpiF8u1Rw9d+0Mr6Dl2E/B+nqK7LduRIU/y75dEkLU60Fd5oI4PWb
	 dhxTdBAIq8NYz7HQSXzwIo+jOo+sirpPj2gheTly+ZVPDBiaB2EsboQLlh1i6wZdDy
	 Lo5pOqWtNxXWVn3kXC6+aGYA6iSw2246skPskzKLafBXPzuh3tytojlTDDgq32Z2x4
	 YQEQNhkRO54aMF3Jd3Wi+BRtWCayJOWoytqcvt4d76HHiYZW/aOCtLKsbivlvYafcC
	 rk+r24jA7CtxCRHmRDr5n2cIS1YwJEpQuOI6OohDsOEqGcnK0trAkT4jg/0fACWRZ5
	 SfPGgStID+KYw==
Date: Tue, 31 Mar 2026 20:24:41 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Sechang Lim <rhkrqnwk98@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vma: fix memory leak in __mmap_region()
Message-ID: <0bb29c9d-2b9e-415e-8456-03806467f7d8@lucifer.local>
References: <20260331180811.1333348-1-rhkrqnwk98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331180811.1333348-1-rhkrqnwk98@gmail.com>
X-Rspamd-Queue-Id: C071080004
X-Stat-Signature: a6bepn97uwqpr95pgp7dmhddmwbr114i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774985084-459584
X-HE-Meta: U2FsdGVkX18S4oHzkY/51B8wwICCuNVx0C9NVuybQKaKLGNtgNqp7lFN9fBZcCdh7dZmw92G56XnPNO4NAyvP3HWDHcZEps4X75hlhp40zSeWRJpqVjbX0vEwQYDbmUvL6QILO8b1g9g9yVi8fss4J32PoX2LAGvacy96MJb9DJ5vrTb7ztYdJo72jbqeZ8HWB7QwNksqVMdWtzlTe9EPCEX5ZmgjcpeiT1ESQP5KKxunp5PXL3F4GkI69bkQH0rxjfcy4rbYp2riQzA55XCiTrOUJ1jXmeZSixNBBPCNAEt0jlyjovS2TWlWoeGEp6X0x7ts0ENSMk9wWU5hpu4UJvHgAznlOyiH10+kNuaRftsKGLz1ADJe2QQpeO79dSmAwkYoipcCwmgxe0g7xNjg6CsdPEvGz1Dhulkdwhbcr7lnlX9R2lyBw6VZwNryBJvkJVlerc4SQs5YoKRSLBTz57S3Vzy8ClbCCuELF9GuwmYFeasK/jr6+VYZodgL22ixHrW5NGQzQNgRm9VG6Ci5/sASxgQK5OFhK68Y6IqyftUAhmxc+OUB5DhR6jPrVtgwtdNVLq3jdaPp0l2fiaIY4iskyYKoRbNlaaJuHHSx+62GmGaDQ2lnqQZuD8NHm+gEY3aRC+aoIXfie+as3E6PTb2U/8IW2kjImcgji1ux/yFMSuilt8p6Fycp0MNTRZJAa3F+6yORGZy/xIWvNvAXLmmGlpub4dilhJOCkV76hwnjOBC8QmSR7S70yH5RHlpb79X20T+cukRFxMHFo3hB917FY0T1oWgJNt9LeqR3aaoj50PH0EGmM5e0Y+ecGxX/khnHsZ0/OjZqw6/zAHvye4AgFUnrstmYl/titAq6wkUasKejJpNKp7cT0HW3jXa4Y/QYn9OBwCnXi3xYGdgmGpEZWAMQFoHXabWLNWiY5YghuvAqhYM/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 06:08:11PM +0000, Sechang Lim wrote:
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
>     __shmem_file_setup+0x274/0x420
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
>
> Fixes: 605f6586ecf7 ("mm/vma: do not leak memory when .mmap_prepare swaps the file")

Sorry I was having a senior moment when I said no cc: Stable, we should have that :)

Andrew could you add:

Cc: <stable@vger.kernel.org>

Here? Thanks!

> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
> -------
> v2:
>  - Drop redundant map.file NULL check (Lorenzo)
>  - Add comment explaining the fput() (Lorenzo)
> v1: https://lore.kernel.org/linux-mm/20260331121906.1301155-1-rhkrqnwk98@gmail.com/
>  mm/vma.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..c8df5f561ad7 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2781,6 +2781,13 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  	if (map.charged)
>  		vm_unacct_memory(map.charged);
>  abort_munmap:
> +	/*
> +	 * This indicates that .mmap_prepare has set a new file, differing from
> +	 * desc->vm_file. But since we're aborting the operation, only the
> +	 * original file will be cleaned up. Ensure we clean up both.
> +	 */
> +	if (map.file_doesnt_need_get)
> +		fput(map.file);
>  	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>  	return error;
>  }
> --
> 2.43.0
>

