Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0A0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39286B008C; Fri, 10 Jul 2026 13:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11A96B0092; Fri, 10 Jul 2026 13:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00D56B0093; Fri, 10 Jul 2026 13:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEA96B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:17:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 270E01C8C05
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:17:40 +0000 (UTC)
X-FDA: 84973523880.10.0C65619
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1F6774000F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:17:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="FFd/C3Rz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="h 4/tycQ";
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783703858;
	b=NpJt2K4vJSAVBOGLwl33AI4RfDOEcMEG6xe6NXvttwKmEAk2eVAbXgli5uy5E1PSpYK8OH
	ug1T/h5zbuC8PhYoyqIJQvLv+P9sVKXCYlIEkmXLepehAo75bFVkmf77Be2MnvlSunHSeT
	+LL09btlddjBS6yP38E4z+FXuKFYuCM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="FFd/C3Rz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="h 4/tycQ";
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783703858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYhHPwBE4c8jNRDuFYUWeYr285Qyxb4VdNUx76AR8AQ=;
	b=vUcTfnvyFQ3hi9q5NYc9GDnFoj/XXIqD2IeuxVTI3zuCapuYvg08JLbJdp9EgrKrZoD7Vg
	sUf4sTdGoB7mqIz3+hvs3OlQg6P7MF7SCQd6R390HdmhbIs0io9944BgjhwUodIFVYCbv6
	GJGvsS0ZhBnLeToTc6SGYl2U2M3AjFQ=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 693FFEC0067;
	Fri, 10 Jul 2026 13:17:37 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 10 Jul 2026 13:17:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783703857; x=1783790257; bh=GYhHPwBE4c8jNRDuFYUWeYr285Qyxb4V
	dNUx76AR8AQ=; b=FFd/C3RztaCoWiQxvOssd8+y2bEU0U6XAZJ34IHiLAyQvv77
	UalWpEZcg4GiiCJ4QPkU4vd2pmWcmPTfsZHwDGSLZ1jV5YxRMj91wyZ18TpsWT6/
	FxXoasRtr7owBSI168ImiGlS7JMV4fSlPFpIBtkfuNSyvI0yFlR9KDe9iIfw6p8l
	2Ak3A55r3iGwVsYmweXwm8A96H91wprnm7zF2ihb5weYq3C6RjVbJ88vMahnIxrK
	e6VU7Bc/6Tsbdyf7wqpqDkbQGiguYizdljHSTtTY43m7lGJBdoxRbyULw2Lrq6QH
	QL4jwcKHcuiGCXIV5G6/lryd6BoHXflCYSWjbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783703857; x=
	1783790257; bh=GYhHPwBE4c8jNRDuFYUWeYr285Qyxb4VdNUx76AR8AQ=; b=h
	4/tycQ+O7VRalnqvyo4pczbXhofsU+r16wC6NmH51cpNTdRvr9pX7XD67i3i6fUY
	NJeMwnBFBKctd85YVPmkkylVqC/kR5tHK8phFKmqCIa5P6f1mfy0qptU7Yb6qIhR
	GrcQfH5rTnFA/QXmf7+tP52GfA1xmUyGtVyUi4mq+LrSANmFQ46SG+DMw9mSnNhn
	wdJ4dgOdUwPerEIAzYDysX4RGbt8o5QtCxiVAMyGHgaMrhkwEx4quV+13fTcBO+7
	nLT2D7bX3LmB7NafJUnEjAQrvD0HMHgHZImtASG/68z7DaYLSMwq/h8v4MAyCfM1
	ygDBErspqj1iuiTXQSDhA==
X-ME-Sender: <xms:MSlRarU_Zb2Nt_lQC__5jm6awihHfdNraRKfmdUJewYVLii9H8yjsg>
    <xme:MSlRalK6OxXJeb06e9MMAkOOj98lXRf1F5o30FTKrtDoDg1t_gxCdnMz_z1BPvuog
    HfCkfuAAmbgeLu4UmsnK6YkKTXTcicfzb_aCS5d3dKQXO3iolt8GA>
X-ME-Received: <xmr:MSlRatvnNwuk5-MGGtnGSQQULBRdzEYbPzbHVoFCLPdk9z1ZQPBtAwNacu7wdg>
X-ME-Proxy-Cause: dmFkZTGoWflz57AfKjcgctpyIdt8yO/UZVzUtZA3o88CQIGMtNEq8IJZR/2f40kD5cQVJZ
    47uMI+QRAhlF5Hurgsn8f6BLAyON60yT0o8AEDIE2qXgt/WJETwQwxLD4a2MsBCbtSJa7+
    +hLCTB0f9vIuEUGsgj2ffcBq2YTQSbW2SQljo1tWOS6XbdWXp9jdIaspps9F0tO3K0WDh0
    uoiwaij41CpkE5XuOI/VUVXme9x/iE0UgrIWqW2Rp/2EE+HEHkjnfA/glzRRRbwFo3eSIH
    pNhAZ9H2oSHF/CO9EClxh2nTzBHHJiBgjD8s5hwNzW5Ab+ac1xLWrk/g/mQ9bd4MaNnRPa
    RxUKKKsegsTo4n1exOSauwyJLrcNXG9tsV/D9MH1C2cc6hrdqaDwNjXIur9YvxWAc42pqa
    AQ140SNE+BC0zyZNkV+otugWxdc0WVTdAs2Zf+7H06R3GKe+XE/D/PlUNkMHNQvv8Xm5Q3
    Ro5qzLiAzQd7UJWuVXS/5ca5LmQWfVtJI/TQqJ/4gTTdyhYBLpBYgkRhFLe/R/Jyc9UG7X
    ZmJ6pQjWrFXzMhl6Cn1K29ioZ7MXEpeqIEWshXYxASyWQVhas8FWrZ2A/vUkbESNpTXhDf
    B/vFrA97n7jg1xjV9fIdE5VlHB2jgdSJCIYL6IoXt5qboDXkPuZsGctxuE4A
X-ME-Proxy: <xmx:MSlRaiKzphzGUTNqk-I0c_wWFkGfUyCjA6a0DeZ9kZ1GrYxerBEmWQ>
    <xmx:MSlRatPSt8cENlVOqKByiNZaSpnG9wvaKM5f_-RsfLJUkb0CKJAxSg>
    <xmx:MSlRatUtUOGlClnJytpQF8DVBa75Vnky_i0QVAwx6gpnFrjdw5cgKQ>
    <xmx:MSlRajlZr8daX-JJuyY6Yepxuh7r4dT0A1lvxr-5UGinLLfQeJabdQ>
    <xmx:MSlRaliMffgkxRHFMVm5L1U89l18FiJd09P0PVq3waWR4JV-Ns6HOg_u>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Jul 2026 13:17:36 -0400 (EDT)
Date: Fri, 10 Jul 2026 18:17:35 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hao Zhang <hao_zhang_kdev@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <alEg6ZPc-ao7s6o6@thinkstation>
References: <20260710071344.GA106129@zh-pc>
 <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alEWEColDdwQboYX@192.168.1.215>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F6774000F
X-Stat-Signature: xt11uqoomeu5jqyfzzh8gib1hdes4dkf
X-HE-Tag: 1783703857-773432
X-HE-Meta: U2FsdGVkX1/ufddS4U57M3kH08xRA8YA48Ftqr/IFn1kuJNxZcm2VfZOxIFs+tjRYz5DCb5yM+4abaTGkNYeBexAAyYTOx7jY/KqliLl+osg36niOeJ0yKt+bKYEnz5h8f5hrgRIjEWKHANeKihoFQk5GUaHTq99dFKn4bzhRnnozDbKUguYb9aAiTV+lCbtKZXPKpjXg5Pwcv6jc3M/uDEfKyZpu9xdBGuOKPrZjnu+W5opdz1iCa9gaDHhjfY4mrUJFyqnAEQDr0V4lzOUr0if+LnsOgdWdpW8Igc9MJylohsp9HtvL2t8xC0NBj3FODZiUAfLxmCyYVvWapKsw5OumPxNBmioWZEtrsC5fr22MMQeXPu52iLIoSW153phGNalIR/sSmXpq7ihQOlevV2g6eSp+PeU05NRqh2thunBKDrhqenIrEsRj6eki6YxvVR9XV1qSMb3IXzxR9OfJoN+SgvFbUXUJkE4yt2qu/4YSZsf31r9KKtPbBdmnUChvY3OHeV27XGKwmu/5fQrbMbZkDu6Le5DfoaISurl2EkwqkZfNFlLgOevrFrYO/4N0RYn2dtli298dbO1c8EPMddDneey2fQJ+GM8Yfx5ebS7gwpJPCdf4Ti0eRUVb1jCYv/f/Cl89pdh2tF+wAXY4JtMutiPIEsx0CzJE+zpS1FunlcxygCgQ8hppYRuCRCDkli4RmeF6JFXW7sO1mq53CP/yFCKhUGDR4N7gk9udJxEHmZgIobtdG2s0CNbeLtknHGfAsjk6L5oh0XKRI7VHGfINE4FnMUHLj3dMiYl/IqDYmNZYHwY+L8VEFLQJshsra4abfZT5DckGmgMpmK+5VhXOrB37LjSJ2CuQb52gyLitkjVJ2Cpqs+M+ev7vLataPmn933Sxpc0+p97RyUX8IaRU6tBlpIGTy+sA6k3zI29HkYdCCkA1Jqn1u322ZcIdgsDcjmFXfvN0X8kBof
 liyoaVzy
 c1bKixxyxTgAdBzKdl0ibL9LJi9XV6KTpbQN1wXCJ5/mL04Zyt9fs6jAPij3HmDSduzGFxWIhdbanLywonxfGjTM287RB2nATq/5RQVfSo/WQgXX/syAuSXIeM0vf2izsNgQcXOKVHTQemLGJ0h0b0yDCZGD+XLUW+vOk9BN30zeULjRLVnBAzfT2nM20o9MYJyNuPQKA/Zds+px9o6ybOXwhsR/D5EcK17AxmFtIpFuSYmEn4enBVRzKumvQh6nGfdF2Um17Y+Gp6pX1jJFdZKQ714Mvkgsw54o3nH5nSJAPX+g60nFxEt2mzrWt9Ulirf8CwQXlmJHvpP4eD8SPkolQ1nNgVcX6X0VPch2EUnRSvjSQRr+2h0rWRNeFa5RDXn7U/aXUCWuBtqp11+1z6fdWO+0hw1+NbA518Jdp6tiYJUC1valg/W3vUfXrE0EUnJUKJt+aRsBd7OMXSf0pngQKOhshr1DBohImlZhOhNJoPjcyW2l0qgDJ/QWVgQEqtRG6MdVH0+CL8nxw0FLe9UOl9+pxf53YBhi5+m6PiLWKlHcjISrA2gyzk+jYXSIaqfVH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:56:00PM +0800, Hao Zhang wrote:
> On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
> > On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
> > > From: Hao Zhang <zhanghao1@kylinos.cn>
> > > Date: Thu, 9 Jul 2026 16:30:00 +0800
> > > 
> > > __folio_split() takes mapping->i_mmap_rwsem while unmapping and
> > > splitting a file-backed large folio. The lock is currently released
> > > only after the split folios that are not returned locked to the caller
> > > have been unlocked and put.
> > > 
> > > That leaves a lifetime hole. Once the split folios are unlocked and
> > > their references are dropped, inode eviction can make progress through
> > > the final page-cache truncation path. After the folios are removed from
> > > the page cache and the last inode reference is dropped, the inode that
> > > embeds the address_space can be freed after an RCU grace period. A later
> > > i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
> > > from freed memory.
> > > 
> > > A possible race is:
> > > 
> > >   CPU0                                    CPU1
> > >   __folio_split()
> > >     i_mmap_lock_read(mapping)
> > >     ...
> > >     remap_page()
> > >     folio_unlock(new_folio)
> > >     free_folio_and_swap_cache(new_folio)
> > >                                           evict inode
> > >                                           truncate_inode_pages_final()
> > >                                           destroy_inode()
> > >                                           call_rcu()
> > >                                           RCU callback frees inode
> > >     i_mmap_unlock_read(mapping)
> > > 
> > > Release mapping->i_mmap_rwsem after the page-cache and reverse-mapping
> > > work has completed, but before unlocking and putting any of the split
> > > folios. Clear the local mapping pointer after the early unlock so the
> > > common exit path does not unlock it a second time.
> > 
> > I don't buy this analysis. We still have the lock_at page which is locked
> > and still in the page cache. Inode eviction cannot complete past
> > truncate_inode_pages_final() until it is unlocked, which only happens
> > after __folio_split() has released i_mmap_rwsem.
> > 
> > One possible path how this can be hit is if lock_at ends up in an
> > after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
> > removes it from the page cache. Note the drop loop starts at
> > folio_next(folio), so this requires splitting at a tail page (e.g.
> > memory-failure) racing with truncate.
> > 
> > But that's not what your analysis claims. Please share the actual crash
> > reports. Let's get to the bottom of the situation before changing the
> > code.
> > 
> > -- 
> >   Kiryl Shutsemau / Kirill A. Shutemov
> >
> 
> Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
> Injecting memory failure for pfn 0x81bfe at process virtual address 0x200000ffe000
> ==================================================================
> BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
> Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874
> 
> CPU: 0 UID: 0 PID: 45874 Comm: syz.2.11034 Not tainted 7.0.0-rc3base+ #62 PREEMPT(full)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack data/linux/lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0xbe/0x130 data/linux/lib/dump_stack.c:120
>  print_address_description data/linux/mm/kasan/report.c:378 [inline]
>  print_report+0xd1/0x660 data/linux/mm/kasan/report.c:482
>  kasan_report+0xec/0x130 data/linux/mm/kasan/report.c:595
>  __asan_report_load8_noabort+0x14/0x30 data/linux/mm/kasan/report_generic.c:381
>  __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
>  up_read+0x22/0x30 data/linux/kernel/locking/rwsem.c:1633
>  i_mmap_unlock_read data/linux/include/linux/fs.h:537 [inline]
>  __folio_split+0x732/0x1640 data/linux/mm/huge_memory.c:4100
>  __split_huge_page_to_list_to_order+0x7b/0x140 data/linux/mm/huge_memory.c:4203
>  split_huge_page_to_list_to_order data/linux/include/linux/huge_mm.h:385 [inline]
>  split_huge_page_to_order data/linux/include/linux/huge_mm.h:389 [inline]
>  try_to_split_thp_page+0xab/0x390 data/linux/mm/memory-failure.c:1675
>  memory_failure+0x1394/0x26e0 data/linux/mm/memory-failure.c:2470
>  madvise_inject_error data/linux/mm/madvise.c:1487 [inline]
>  madvise_do_behavior+0x4ae/0x8a0 data/linux/mm/madvise.c:1925
>  do_madvise+0x162/0x230 data/linux/mm/madvise.c:2028
>  __do_sys_madvise data/linux/mm/madvise.c:2037 [inline]
>  __se_sys_madvise data/linux/mm/madvise.c:2035 [inline]
>  __x64_sys_madvise+0xae/0x120 data/linux/mm/madvise.c:2035
>  x64_sys_call+0x1bed/0x25e0 data/linux/arch/x86/include/generated/asm/syscalls_64.h:29
>  do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e

...

> Memory failure: 0x81bfe: recovery action for already truncated LRU page: Ignored

This log line confirms my suspicion.

The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
still holds the poisoned page locked. For the inode to be freed at that
point, eviction must have completed truncation, which is impossible
while a locked folio remains in the page cache. So the after-split folio
containing lock_at was no longer in the page cache — and the only way to
remove a locked folio is the split itself: the new_folio->index >= end
drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
tail page, which is what memory-failure passes.

        CPU0                                    CPU1
  i_mmap_lock_read(mapping)
  __folio_freeze_and_split_unmapped()
    __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays LOCKED

  /* no locked folio pins the inode */
                                        evict()
                                          truncate_inode_pages_final()  /* nothing to block on */
                                          call_rcu() -> free inode

  i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode

Your fix moves i_mmap_unlock_read() out of the window, but I don't think
it is complete: shmem_uncharge(mapping->host) a few lines up also touches
the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
that triggers this. So it is in the same freed window; the patch just
relocates the one dereference KASAN caught.

This is a lifetime problem, not a lock-ordering one: __folio_split()
relies on the caller's locked folio in the page cache to keep the inode
alive, then removes that very folio. I'd rather fix it by pinning the
inode explicitly -- igrab(mapping->host) up front, so the inode is
alive), iput() after i_mmap_unlock_read(). That covers shmem_uncharge()
and the rwsem both, and won't regress if someone adds another mapping
deref later.

See the patch below. Untested.

Any opinions?

Hao, could you give it a try?

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..9bfa3a879453 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3982,6 +3982,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
+	struct inode *inode = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4053,6 +4054,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		}
 
 		anon_vma = NULL;
+
+		/*
+		 * The locked @lock_at folio keeps the inode alive: eviction
+		 * cannot remove it from the page cache while it is locked. But
+		 * the split drops it if it lies beyond EOF, after which we
+		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
+		 * Hold an inode reference across the split to be safe.
+		 */
+		inode = igrab(mapping->host);
+		if (!inode) {
+			/* Inode is being evicted; nothing to split. */
+			ret = -EBUSY;
+			goto out;
+		}
 		i_mmap_lock_read(mapping);
 
 		/*
@@ -4135,6 +4150,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 	if (mapping)
 		i_mmap_unlock_read(mapping);
+	if (inode)
+		iput(inode);
 out:
 	xas_destroy(&xas);
 	if (is_pmd_order(old_order))
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

