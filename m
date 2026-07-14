Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203E8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BA16B0005; Tue, 14 Jul 2026 05:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2542F6B0088; Tue, 14 Jul 2026 05:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169EB6B008C; Tue, 14 Jul 2026 05:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92636B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:33:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7165D802AB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:33:28 +0000 (UTC)
X-FDA: 84986869296.08.25C292E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5ABD0180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:33:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KXxvkJW5;
	spf=pass (imf16.hostedemail.com: domain of hao_zhang_kdev@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=hao_zhang_kdev@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021606;
	b=SRCIBNhTOnWlTxQ1QCM2zeCQzwdC3eP5osjHVr0JZkCqAvTTWokeipA5bsb2xGPK8IzD/i
	0voqAQhys7EdvoRVvPZffVWi9dXbmkt5ZvU9Ht50dHsXx9nMXTOupxraig6ATphglWYDfr
	qxofSDcKxQO7djZk5tg7I1IYgKiAbnM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KXxvkJW5;
	spf=pass (imf16.hostedemail.com: domain of hao_zhang_kdev@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=hao_zhang_kdev@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qzNxwvELyI5zS8RpXz5v+APocgBr04Pl9V8u8CWoQE=;
	b=0Tyxh5GYax1hDZvld6056jlhPD+7qmv+3Ka6bTBYeoWwsiRH7jcDu5xDC/SVcr1ZccpifW
	G3jBEJltmiPqOuOcPZ62q6JMn6S1CS10bYhP10IGx9StWF1ptbdwMcATRpBFX/vaE4JULB
	sSrmFSLAxbKGAG9j7/vICENn+g5Op2A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=2qzNxwvELyI5zS8RpXz5v+APocgBr04Pl9V8u8CWoQE=;
	b=KXxvkJW5RXc0FgnmdjnvFDWyoI/8sb10OJuZ0NwxIm3QX8W2rs7dbDNDOmqogb
	wI6HUYBmBD0nQRzRkLOtQzh98zoK1rCD5owM3vPBfSc1nLR/3DhG1hcR4iiyWcPW
	LS3BEUTKoeBWVVdvFXoVQSjeHnGFut0JeyIRqqaYayYX4=
Received: from zh-pc (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wA39tRVAlZqCZnzJQ--.18632S2;
	Tue, 14 Jul 2026 17:33:11 +0800 (CST)
Date: Tue, 14 Jul 2026 17:33:09 +0800
From: Hao Zhang <hao_zhang_kdev@163.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <20260714093309.GA153839@zh-pc>
References: <20260710071344.GA106129@zh-pc>
 <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215>
 <alEg6ZPc-ao7s6o6@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alEg6ZPc-ao7s6o6@thinkstation>
X-CM-TRANSID:_____wA39tRVAlZqCZnzJQ--.18632S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKr4xuFyruFy8Cr48WFyxGrg_yoWDGFW7pr
	ykWa9xJr4DXryv9F4Iyr1q9r10vayDWa4UCryfKr1xC3Z0qw17KF4jkF1UCw1jgr1kAayr
	Xa1UJ398ua4Dt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jgNVgUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pkdrs65kdqwshngh4qqrwthudrp/xtbC3hfFuGpWAld1BQAA3t
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5ABD0180003
X-Stat-Signature: qhy6fnczwuabh3s7kzd6jrypexakbfp6
X-HE-Tag: 1784021604-129441
X-HE-Meta: U2FsdGVkX19K9oshGQ5Kz48bgb3x99NaU9jFYTHJ3lywMH/Bw9effmr8968u6KKwviGWbLl8NOA2PvPyIF/MWDcdvxdizYI+1VsUOZQnRivEdfSUlQAXQLIbyDOXrzuJOMaTDir35eK1EHrAN5PeaCBETHC8GlfbpXmomSccLSbV7Zu8YiFWQKQ0hWPAqbycgY9rMdvhPWm4/YY1oI7i4+WuOGxc6JsbM4krbTYBB8t1NR5r9kQqpUa9HLeoRDWFRv9TouwqjJfTq6IlElMOxDMBPkkd+R9s+SIPCwGc6Wo7biMwtUBS9M+dSaeXQsCpfiW51QGhmd+VN3cKQYoZ/04gJ4pbME1OLddZvz7p6/3s4a9v+SJtn8SZeHi84fM8REQGTpG8khKy3uUVpCx7LMqAlj5im4riCseDmQRVJi3RREfFQV0zDSjWV8IYB9GYXP6hsK0svfoopDuRS4HLmHPamsrD/2LvGCPh46rWyPnUTqCeBuvA/3Rg+te5POIToPPWOb+e8e8mpW6w0NOH/n3siIay/CL2s0DVhMgBxm9dHgOkZQjb8E2uIvndx2rS/fo9N3jwbXjEHomG8gzBfAWAX3s6aIr9dVwNC3luisrOuY0SS1aYfYLrDUXts+tLS4HANgc0mKPOaooZD65/OsxvOVg0t3OidelyuXCoJpNrpJbsG+r5GcPzS8kxIorXBAnRi0phptsHLfS4Hx58x+/c2yMnyrLfMqW/+M01CoewExkaEmUXxLZjrF8xcYEmz+ZJdwi6+uIOLvEX6jbyV/rSNEZyBiGFjJL2c/MGU+nQ7V/uNDzF82Jah2HusPjKupgk9jSUSJn2nf1C/Hvmwf4kWhgQWi9c2iu6AX+mPN5GkT8Oud/HJcFE+JxrzJsnV6lsDzZakZCUncoMUEMcN8ilSX3ob1hyN8sECs6BVfhphaOfuGDArM1xEBHJlu82XxW8HZ2iavo7QuZ/xAm
 xpQ45gbW
 /LA2UhFWsKlTzymWAogypxXqbcn1kS6KDf47b/re7oY6dcdf5z8WIYae5gTgLF8Gkclif0iksyvjhG9RmF+CySqQQCe33ZyR0r3dmHDSQkf150sc4w9vsmtW7pAQUkNp5zmYYvS8a259xBjp24UXwEn/rW3WiqggCe3s1l/9zvDTcIPrXpT8NJipkVZj+MTzW4XMYApjXxbtW6lyhwmAPfKpegvBXrzubDrmGAB0br3bqE1GZE0j4IeQaVmiz91oy9+T+eAIJhd7hKXw2f9RQqaxfRASen5g09CQUABypxx2fZlsA/9LswmoBmCAi5xu9dp2Ur5oV5bsOkG+kFHewYquLjEf6YUZYWCDwh/bKgToJOW955uf81wTw+tL/ChD+Hbq9Vx4ixb9DW0jfamvx9qyY6pLmrU5t1Rglh78d+oXmWxLc4DNxS4qyoDjK41zoUdzyJcOgSIFKS1jJLJb8qXZ9pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
> On Fri, Jul 10, 2026 at 11:56:00PM +0800, Hao Zhang wrote:
> > On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
> > > On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
> > > > From: Hao Zhang <zhanghao1@kylinos.cn>
> > > > Date: Thu, 9 Jul 2026 16:30:00 +0800
> > > > 
> > > > __folio_split() takes mapping->i_mmap_rwsem while unmapping and
> > > > splitting a file-backed large folio. The lock is currently released
> > > > only after the split folios that are not returned locked to the caller
> > > > have been unlocked and put.
> > > > 
> > > > That leaves a lifetime hole. Once the split folios are unlocked and
> > > > their references are dropped, inode eviction can make progress through
> > > > the final page-cache truncation path. After the folios are removed from
> > > > the page cache and the last inode reference is dropped, the inode that
> > > > embeds the address_space can be freed after an RCU grace period. A later
> > > > i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
> > > > from freed memory.
> > > > 
> > > > A possible race is:
> > > > 
> > > >   CPU0                                    CPU1
> > > >   __folio_split()
> > > >     i_mmap_lock_read(mapping)
> > > >     ...
> > > >     remap_page()
> > > >     folio_unlock(new_folio)
> > > >     free_folio_and_swap_cache(new_folio)
> > > >                                           evict inode
> > > >                                           truncate_inode_pages_final()
> > > >                                           destroy_inode()
> > > >                                           call_rcu()
> > > >                                           RCU callback frees inode
> > > >     i_mmap_unlock_read(mapping)
> > > > 
> > > > Release mapping->i_mmap_rwsem after the page-cache and reverse-mapping
> > > > work has completed, but before unlocking and putting any of the split
> > > > folios. Clear the local mapping pointer after the early unlock so the
> > > > common exit path does not unlock it a second time.
> > > 
> > > I don't buy this analysis. We still have the lock_at page which is locked
> > > and still in the page cache. Inode eviction cannot complete past
> > > truncate_inode_pages_final() until it is unlocked, which only happens
> > > after __folio_split() has released i_mmap_rwsem.
> > > 
> > > One possible path how this can be hit is if lock_at ends up in an
> > > after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
> > > removes it from the page cache. Note the drop loop starts at
> > > folio_next(folio), so this requires splitting at a tail page (e.g.
> > > memory-failure) racing with truncate.
> > > 
> > > But that's not what your analysis claims. Please share the actual crash
> > > reports. Let's get to the bottom of the situation before changing the
> > > code.
> > > 
> > > -- 
> > >   Kiryl Shutsemau / Kirill A. Shutemov
> > >
> > 
> > Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
> > Injecting memory failure for pfn 0x81bfe at process virtual address 0x200000ffe000
> > ==================================================================
> > BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
> > Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874
> > 
> > CPU: 0 UID: 0 PID: 45874 Comm: syz.2.11034 Not tainted 7.0.0-rc3base+ #62 PREEMPT(full)
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack data/linux/lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0xbe/0x130 data/linux/lib/dump_stack.c:120
> >  print_address_description data/linux/mm/kasan/report.c:378 [inline]
> >  print_report+0xd1/0x660 data/linux/mm/kasan/report.c:482
> >  kasan_report+0xec/0x130 data/linux/mm/kasan/report.c:595
> >  __asan_report_load8_noabort+0x14/0x30 data/linux/mm/kasan/report_generic.c:381
> >  __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
> >  up_read+0x22/0x30 data/linux/kernel/locking/rwsem.c:1633
> >  i_mmap_unlock_read data/linux/include/linux/fs.h:537 [inline]
> >  __folio_split+0x732/0x1640 data/linux/mm/huge_memory.c:4100
> >  __split_huge_page_to_list_to_order+0x7b/0x140 data/linux/mm/huge_memory.c:4203
> >  split_huge_page_to_list_to_order data/linux/include/linux/huge_mm.h:385 [inline]
> >  split_huge_page_to_order data/linux/include/linux/huge_mm.h:389 [inline]
> >  try_to_split_thp_page+0xab/0x390 data/linux/mm/memory-failure.c:1675
> >  memory_failure+0x1394/0x26e0 data/linux/mm/memory-failure.c:2470
> >  madvise_inject_error data/linux/mm/madvise.c:1487 [inline]
> >  madvise_do_behavior+0x4ae/0x8a0 data/linux/mm/madvise.c:1925
> >  do_madvise+0x162/0x230 data/linux/mm/madvise.c:2028
> >  __do_sys_madvise data/linux/mm/madvise.c:2037 [inline]
> >  __se_sys_madvise data/linux/mm/madvise.c:2035 [inline]
> >  __x64_sys_madvise+0xae/0x120 data/linux/mm/madvise.c:2035
> >  x64_sys_call+0x1bed/0x25e0 data/linux/arch/x86/include/generated/asm/syscalls_64.h:29
> >  do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> ...
> 
> > Memory failure: 0x81bfe: recovery action for already truncated LRU page: Ignored
> 
> This log line confirms my suspicion.
> 
> The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
> still holds the poisoned page locked. For the inode to be freed at that
> point, eviction must have completed truncation, which is impossible
> while a locked folio remains in the page cache. So the after-split folio
> containing lock_at was no longer in the page cache — and the only way to
> remove a locked folio is the split itself: the new_folio->index >= end
> drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
> tail page, which is what memory-failure passes.
> 
>         CPU0                                    CPU1
>   i_mmap_lock_read(mapping)
>   __folio_freeze_and_split_unmapped()
>     __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays LOCKED
> 
>   /* no locked folio pins the inode */
>                                         evict()
>                                           truncate_inode_pages_final()  /* nothing to block on */
>                                           call_rcu() -> free inode
> 
>   i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode
> 
> Your fix moves i_mmap_unlock_read() out of the window, but I don't think
> it is complete: shmem_uncharge(mapping->host) a few lines up also touches
> the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
> that triggers this. So it is in the same freed window; the patch just
> relocates the one dereference KASAN caught.
> 
> This is a lifetime problem, not a lock-ordering one: __folio_split()
> relies on the caller's locked folio in the page cache to keep the inode
> alive, then removes that very folio. I'd rather fix it by pinning the
> inode explicitly -- igrab(mapping->host) up front, so the inode is
> alive), iput() after i_mmap_unlock_read(). That covers shmem_uncharge()
> and the rwsem both, and won't regress if someone adds another mapping
> deref later.
> 
> See the patch below. Untested.
> 
> Any opinions?
> 
> Hao, could you give it a try?
> 

Hi,

  The original KASAN report was found during a ~6 hour syzkaller fuzzing
  run, not from a small deterministic reproducer. After applying the patch,
  I also ran another ~6 hour fuzzing/replay test with the same syzkaller
  setup, and I did not see the original KASAN UAF again.

  Test setup:
    target: linux/amd64
    kernel: 7.0-rc3 based tree, commit 1f318b96cc84 ("Linux 7.0-rc3")
    config highlights:
      CONFIG_KASAN=y
      CONFIG_KCOV=y
      CONFIG_DEBUG_VM=y
      CONFIG_PREEMPT=y
      CONFIG_TRANSPARENT_HUGEPAGE=y
      CONFIG_MEMORY_FAILURE=y
      CONFIG_KVM=y
      CONFIG_SHMEM=y
      CONFIG_TMPFS=y
    VM:
      qemu, -enable-kvm -cpu host,migratable=off
      4 VMs, 2 vCPUs each, 3072M memory
      syz-manager procs: 6

  I also reran the original syzkaller crash logs with syz-repro.

  Relevant replay results:

    fs_log1_20260713-110727.log:
      reproducing took 19m50s
      program did not crash
      replaying the whole log did not cause a kernel crash
      EXIT=0

    fs_log1_rerun_20260713-160230.log:
      reproducing took 19m51s
      program did not crash
      replaying the whole log did not cause a kernel crash
      EXIT=0

    fs_log0_rerun_20260713-154007.log:
      reproducing took 19m09s
      program did not crash
      replaying the whole log did not cause a kernel crash
      EXIT=0

  So far I have not reproduced the original report after applying your patch.

  I do not have a stable generated .prog/.c reproducer artifact left from
  these runs.

  Thanks,
  Hao

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..9bfa3a879453 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3982,6 +3982,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	bool is_anon = folio_test_anon(folio);
>  	struct address_space *mapping = NULL;
>  	struct anon_vma *anon_vma = NULL;
> +	struct inode *inode = NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
> @@ -4053,6 +4054,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		}
>  
>  		anon_vma = NULL;
> +
> +		/*
> +		 * The locked @lock_at folio keeps the inode alive: eviction
> +		 * cannot remove it from the page cache while it is locked. But
> +		 * the split drops it if it lies beyond EOF, after which we
> +		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
> +		 * Hold an inode reference across the split to be safe.
> +		 */
> +		inode = igrab(mapping->host);
> +		if (!inode) {
> +			/* Inode is being evicted; nothing to split. */
> +			ret = -EBUSY;
> +			goto out;
> +		}
>  		i_mmap_lock_read(mapping);
>  
>  		/*
> @@ -4135,6 +4150,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	}
>  	if (mapping)
>  		i_mmap_unlock_read(mapping);
> +	if (inode)
> +		iput(inode);
>  out:
>  	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov
> 


