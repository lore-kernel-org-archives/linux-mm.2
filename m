Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C90EEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381EB6B009F; Tue,  3 Mar 2026 05:32:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FF56B00C7; Tue,  3 Mar 2026 05:32:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D186B00CC; Tue,  3 Mar 2026 05:32:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11A8B6B009F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:32:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B96A18B7A9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:32:18 +0000 (UTC)
X-FDA: 84504387156.17.746C643
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id D9C101A000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:32:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772533937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ctRnACVBoLQpUKzEAzMqfy9YYlIogWllPoguMyiuHQk=;
	b=4aZBCfp44hJ6aZIWeZ4ZpTcfzM+DSqQaea/hX5gVSQX0zvRwBjLA0mzG9tqkJ/8MRCHWW1
	4qypGRFHS5e+rD4q6hO59RV5Z2mP0cIJ2eqKGAbQJPK+1woC12hnPKRz2wh2a/sNMfHf8C
	oxEPM+ruBi3b3BcUQfVxPbQQkO4RQ0M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772533937; a=rsa-sha256;
	cv=none;
	b=yyoHKPkV2Fplz5dIfmIQhdfrPQB5VLKN5ejFoGgszlDrT1LlD8UDXYd3IQPo356q6DqGU6
	27TmuG5Oyz+wR0NFawHtV8pO868PNUjACXhBO2xn8EXZ2jpJ4xi8eZ1B3xU1f7x48m0jPm
	7Y7LosooHCSrVhsW1gbtSwCD4pRbluY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A34D7497;
	Tue,  3 Mar 2026 02:32:09 -0800 (PST)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB6553F7BD;
	Tue,  3 Mar 2026 02:32:11 -0800 (PST)
Message-ID: <56d607c0-dc72-431a-bc86-6dae100f1708@arm.com>
Date: Tue, 3 Mar 2026 16:02:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com
Cc: riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 harry.yoo@oracle.com, jannh@google.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable <stable@kernel.org>
References: <20260303061528.2429162-1-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260303061528.2429162-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9C101A000B
X-Stat-Signature: p7zuc5d6buxaayhcx6xmdw657yrhkoy9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772533936-258760
X-HE-Meta: U2FsdGVkX1/VgYqpJr6YqB7uTN5aXLyA/zZTR3wTJ9HE1qu2JH/u9uvr/OL/WC+Pppa7nf2oTC7Bp8tlDzLivDFOyBLIvnH0Nj56A2NEq1ERFgZ28pZDJ1r0GGyPd/uoIAMNsxBelzpZ/wW5CVyDEJDsS0v0gJNylzNJlgwopIivrdxEIYkhoRLzZ2xUUj7CBrrunh/GHVLXZh93SlIb1HTfvm0m8OPie8SW/ToUng/2WN0NcKotY3mUP7vpfXxiSa14+GGxdTZKuTMAYInGeSIlfsm5oc44n7ZfWsbxhBuGv6gLOkBB1RzS5qhJW32i1Fr2z9GZif3P1kFSxePTe3fGS/P44x08qKfPttoxxRX8UycV5EjkdtqdoJ5s2CPvfgh1v/wOAt2q2sQElEIg709huaDg3ijjUZjRVeN6Bk7nX1YhegGwTh/IEWgrZvJmr3w5J3YStNLPebwPp6KK7sOIPptrSbrPNv87Bvfi4Mk/UUuswcFJ318iAjLSlXwNCynfuncadik4UenfaGDnPY1xrtxrhDGf8nE0Cld+twTbMecdqa3htmUvGySiYMWzTm3KgJ9yB2fH1GEnCIl+Nw2qp+/97pclgtedpO1nUdHiTDpMA8HyYSQIb1tPL+67+ptEm+y6VBwRg6BeNTkTD4pYrbVqW+1z2wnZU9Bz0pxG+nQBhNa1aQ64f3CROi0FerkRzcDY8NdDSmgwNudH4FcVNAGIe8O14Z4ByGTctIvUzEIcQwX735NBSsjKdVpNlcbTn8b9qsAOztiz+YTi8UuGEFFCqDUfDIDj2GQp2ocsR9LFLioXb6l1ivilIRdLDtyLwTK3mieJj5hB7GdLit8LKcrWlfNt7jARAcLKrRX/n4Y0U1eVPjdxj8sXm4AOnzlASPYtyCG5occcMRi8ESan1u6j3KWXP/H/smz/Qvi9p1i3KhrQu02XgfXKCmXGfWceVAEoZhVz1nOh0qO
 ELbNyuJ6
 4KldjTiF3AJ+Vjy9c7gpwzIDEyhrEl49d6FfqYkjkpAsuGs0P9FMSRIf1ktFWIoWZJndga+r40uq6kacbHoPSxMJm4RoBhs3Xd0ZqIUGmWWOt5fzZBN3nhNWCj1YpGrbVLucUKQGzJpei4DRpD8VkmiYa2zSOWbXADyGYobeHQdewq1TDhYLsHKlSq62kvemehJ97hAOqRH3R3FN6x8Hp0/f4r36CRGgsdI7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/03/26 11:45 am, Dev Jain wrote:
> We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
> If the batch has a mix of writable and non-writable bits, we may end up
> setting the entire batch writable. Fix this by respecting writable bit
> during batching.
> Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
> lost, preserve it on pte restoration by respecting the bit during batching,
> to make the fix consistent w.r.t both writable bit and soft-dirty bit.
> 
> I was able to write the below reproducer and crash the kernel.
> Explanation of reproducer (set 64K mTHP to always):
> 
> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
> fork() - parent points to the folio with 8 writable ptes and 8 non-writable
> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
> the folio as lazyfree. Write to the memory to dirty the pte, eventually
> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
> restoration path, and the kernel will crash with the following trace:

Andrew, could you convert the last line to the following:


..restoration path, and the kernel will crash with the trace given
below. The BUG happens at:

BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);

The code path is asking for anonymous page to be mapped writable into
the pagetable. The BUG_ON() firing implies that such a writable page has
been mapped into the pagetables of more than one process, which breaks
anonymous memory/CoW semantics.


> 
> [   21.134473] kernel BUG at mm/page_table_check.c:118!
> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   21.135917] Modules linked in:
> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
> [   21.136858] Hardware name: linux,dummy-virt (DT)
> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
> [   21.137607] lr : page_table_check_set+0x134/0x2a8
> [   21.137885] sp : ffff80008a3b3340
> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
> [   21.141991] Call trace:
> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
> [   21.142766]  contpte_set_ptes+0xe8/0x140
> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
> [   21.143177]  rmap_walk_anon+0x100/0x250
> [   21.143315]  try_to_unmap+0xa0/0xc8
> [   21.143441]  shrink_folio_list+0x59c/0x18a8
> [   21.143759]  shrink_lruvec+0x664/0xbf0
> [   21.144043]  shrink_node+0x218/0x878
> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
> [   21.145056]  reclaim_store+0x3c/0x60
> [   21.145216]  dev_attr_store+0x20/0x40
> [   21.145585]  sysfs_kf_write+0x84/0xa8
> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
> [   21.145994]  vfs_write+0x2b8/0x368
> [   21.146119]  ksys_write+0x70/0x110
> [   21.146240]  __arm64_sys_write+0x24/0x38
> [   21.146380]  invoke_syscall+0x50/0x120
> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
> [   21.146679]  do_el0_svc+0x28/0x40
> [   21.146798]  el0_svc+0x34/0x110
> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
> [   21.147074]  el0t_64_sync+0x198/0x1a0
> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
> [   21.147440] ---[ end trace 0000000000000000 ]---
> 
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/wait.h>
> #include <sched.h>
> #include <fcntl.h>
> 
> void write_to_reclaim() {
>     const char *path = "/sys/devices/system/node/node0/reclaim";
>     const char *value = "409600000000";
>     int fd = open(path, O_WRONLY);
>     if (fd == -1) {
>         perror("open");
>         exit(EXIT_FAILURE);
>     }
> 
>     if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>         perror("write");
>         close(fd);
>         exit(EXIT_FAILURE);
>     }
> 
>     printf("Successfully wrote %s to %s\n", value, path);
>     close(fd);
> }
> 
> int main()
> {
> 	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
> 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	if ((unsigned long)ptr != (1UL << 30)) {
> 		perror("mmap");
> 		return 1;
> 	}
> 	
> 	/* a 64K folio gets faulted in */
> 	memset(ptr, 0, 1UL << 16);
> 
> 	/* 32K half will not be shared into child */
> 	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
> 		perror("madvise madv dontfork");
> 		return 1;
> 	}
> 
> 	pid_t pid = fork();
> 
> 	if (pid < 0) {
> 		perror("fork");
> 		return 1;
> 	} else if (pid == 0) {
> 		sleep(15);
> 	} else {
> 		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
> 		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
> 			perror("madvise madv fork");
> 			return 1;
> 		}
> 		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
> 			perror("madvise madv free");
> 			return 1;
> 		}
> 
> 		/* dirty the large folio */
> 		(*ptr) += 10;
> 
> 		write_to_reclaim();
> 		// sleep(10);
> 		waitpid(pid, NULL, 0);
> 
> 	}
> }
> 
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Patch applies on mm-unstable (9af4957ef127).
> 
> v2->v3:
>  - Don't special case for anon folios
> 
> v1->v2:
>  - Just respect the writable bit instead of hacking in a pte_wrprotect() in
>    failure path
>  - Also handle soft-dirty bit
> 
>  mm/rmap.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bff8f222004e4..5a3e408e3f179 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1955,7 +1955,14 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	if (userfaultfd_wp(vma))
>  		return 1;
>  
> -	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> +	/*
> +	 * If unmap fails, we need to restore the ptes. To avoid accidentally
> +	 * upgrading write permissions for ptes that were not originally
> +	 * writable, and to avoid losing the soft-dirty bit, use the
> +	 * appropriate FPB flags.
> +	 */
> +	return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
> +				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>  
>  /*


