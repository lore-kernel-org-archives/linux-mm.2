Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAE1FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFDBB6B0095; Tue, 31 Mar 2026 06:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5886B0096; Tue, 31 Mar 2026 06:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12846B0098; Tue, 31 Mar 2026 06:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF2616B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:52:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BE4B160C5A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:52:07 +0000 (UTC)
X-FDA: 84606043494.24.1F92C75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A4A640006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:52:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g6OGmEHW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lELFGLYY8AB9ksuiN14GxiWpV03CkrVBSvz+tzXW6c=;
	b=tjv32klNZHecP1HGYl1kRgtrSgSqbS6Y43bEFMI8uuIZI/lfeRIHcFmEoflPL7ZFkVebvz
	HJTGb79dTiSA9jWdfx8ScpGIl+azTbaE24weEMPAQymlnHEm2vm9B0fLetYhVo+yR2rg2a
	4tyAOw0MLksNg67tEPbZTLhYaS2/47E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g6OGmEHW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954325; a=rsa-sha256;
	cv=none;
	b=xoATxZAP1yiQqG0UcGrkg7v5XwcjwoyawUDX4YEMcOcYw/nh3LeTXpirm8Xq/um4QF6QVg
	ZI+antNBRyk61033FKUvF8haOggRkyhlp0VVaVSO4F3sSjne4Pgj5qlCrNChfJbSJapDmE
	48w73KbvPqx1dutqEruHrv++EgNujoA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5793043974;
	Tue, 31 Mar 2026 10:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0BCC19423;
	Tue, 31 Mar 2026 10:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774954324;
	bh=3slSO+Xj7aiQ5jmPThrrCW3btR8Ri8AI7lpowmwb4vA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g6OGmEHWm+elUwOT70y0J+eUPTh8h6cSiH4aexDWQtILfZGtsWJLuo+BwpRywwDmL
	 kSR4XfLbtD03QinHNDMTMOPfhkMkXS2eYSIIUJwzUBcsqjZOGr09fGBPaESaaY5fH0
	 mGJiev1p4Q4E5ZeTn9rR3jEdaHMKM5KNZKE5c6siqNYnhCRU95Ov4GD3VzHfMXgqDI
	 7gJ7yctME/JWURoAxFwZes/+S3z0YDA0gQ7L0Ma6p53KUoCqi+99ETdB+C+p/TvqfE
	 rShtD/IgDcSJY9cMhZefljUFP0EU2R8dt8iWIKhuU53SSRjHp/BFbl0ZXs6O3TJ5g6
	 2WU9HO9aGoRkA==
Date: Tue, 31 Mar 2026 11:52:00 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: syzbot <syzbot+001b9efd14d3e8fac896@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in
 madvise_walk_vmas
Message-ID: <25ec7ad0-2ace-48b7-b4fb-17a0782a391f@lucifer.local>
References: <69cb8ed0.050a0220.183828.0027.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69cb8ed0.050a0220.183828.0027.GAE@google.com>
X-Rspam-User: 
X-Stat-Signature: zbus4m5rayk38t9sioeo5ocmtzky3qzh
X-Rspamd-Queue-Id: 3A4A640006
X-Rspamd-Server: rspam09
X-HE-Tag: 1774954325-852392
X-HE-Meta: U2FsdGVkX18Sf1Sk0UntsDT+kzhcxkPDqhJfYch4g7tegkRUUTszGuDKsjKm/oTiNUb0PQFY5wvPH4GJzmp56ZqNyGE8HnI0WTinKtfwLQaycnHtkxuZUR2DlmodyrzsEYqUgqt1t2AScLvvQ1HN3v+lBBTxR0LR46ojf32VA2Rte8yTiuFg7rjrzJYdGb/mONWBY3gz1RJlhXkVoNTdeqBGFyKe2eORRWQIspOx5Y5DNLyAsPSm3XWAC2cYvf2gVDhIMzB+jBelqj3zqrs4rhuaTGHjEyqRm1igP4bQVhzWgxtZTQmsokkD0HOw4CGU1k1yr8JzssCuj1/EH5Sc0mFyDSROR/n1+hAcsVBQt1T+haHfh/IEKwtFQF1dQs6p58jL1LPW8Qf7/ZL4LTzbZsKWcg4dDZYJ3BFzSOGK0xpXA2sDOONvudZz2L8O3hdMogph/2bOvORVHTGzRtJX2/gGScC702HT9zMwdUSXK9u7L3WVVAIcrikaDWTGfN3nt90xhgzwEPksRZbUjktPBICcZlVq/Vud82E/21feJSo8TkbNeTRg6h+ox/nbAFT/07nvB7lRyPIIschc1xo0lD8+DsHgfJIagxfgV5+Q8pIZkODsXve0U/XX+d19LZJa5IcgswDiyehBL0LNgIkUsQATGA//k+/sfqAi6cGxOuax+bxJ/5hYp2vk99IzLG5g10Nw8TFpdwohmHqw0dL6u00aYOCdgcGo1+3BzdkipdOgq2luzGe9KRgParOMe5irqB8kWfSGKBoUNai7z/M5Ai6A9m2Fz2Gq7xinQF1D8JaYLriOtSTrBcAOkbcpw2B2KW23mBfoFNDOpeOcHP7dQ3f9182Bhmv6oYgMGV56kSvPhb0jAw4MRZ8Npl8063kTCPIE/AcO3UVZeMmsLUjj+UVBkW+GeSh4Q3GFb1LCoSeSe5r0cjxek73sDiEYUQJ0xUmbkmyUobOHCWErjHC
 d31ocTcK
 qJTSbsWah/825NJS7PNdYkvdAJSUQph8rKCGpWrsDcrEuo87jN9xDanENFiVADL0fHRT4DA8SHul8Awt6sJmcfyE1UaFbLNprIcZrqUCsWnJji4UOOUGHecHIlKU8etKco2hEORqZz/vfXPnQT28+fIbnG21gaacPukmJKKmfBUIfeB9rEEJyc/fNXmkhIDqPcS5jtiUcFeWO0Q5MgAd6b4mMQffhUadFhG87Sclf/SXr/70mCcDbYyCwSpxQw7XwS3ApyUIqsFQT93+xUga2BgWQfcYNcwqLbVzk9chXw6C2Q6bg74ON54slnXEZusGRTgnBevHS91+cEB9skaVmryaLYx7Z2zmaqRb62SrKI+o2jirHnHyPydvBxrBn9+FeEE0SAf38jDIHmCK+Y7V5EGjdWkMAG3pswyqgbRudHtSDlDNsOa/IgULWAn/k+m/WuuhwKoebipvdN/HwU+spM/YoPazhv0eD/cHwLvj1V/tH09Ik8cXfVqq0hfwJcGdvOQgi4mPGowN/9uvE7jzt4W3bVd9SjDhAPfxgzo+OouSZZfRFivCpeB6AAzb9lpr9IgrhDblBWJTwh+3QVcT4Y1GjPAI29au2mZQwbjQQZ3Kmy1cIJhUn4hn4JY0t/8k7cE/YcJbF4tNrWHmsCd3jMFdB+k/XScKV9VVKpEzkBTpnpo4ehAAHhT19Ya+v8SQXfGijGq5IWavItcdbYDDCQmzSeYc4sdPeKqJIpIDrwhPuGAOl2gyAHst+00fntEh2diMoHw6GCh4NJIKcTgX7fhFyvUfP0VLCsGapEWFoQC90LGP/219I8EjjasKwqGOe6OIHTI4tB3IBU9EcGVJ0n+Pz7n7V7XoMPBBF67G1zTB8NGe5CJWB44zP+YzSWVxrZ4qr0HHCW92bs6Y3u02X9/Z7GDkMPeZffpyovKTBK8q6a13XjP3ce6gqmKWGDfQYbWzWeoz5nSQFdc1tLfIorMqiir60
 R/dpR9zf
 tp0s1SNqv+vj45e8AvnK7I/FYbUGvDKUgqP9UXihYzRG79x7AzSVrxCK0enwIKUgslbq8i4+lViNQ4+n4EUHsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 02:07:28AM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    e77a5a5cfe43 Add linux-next specific files for 20260326
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13640f52580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=51ca7cbda5f81780
> dashboard link: https://syzkaller.appspot.com/bug?extid=001b9efd14d3e8fac896
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/63883a48e879/disk-e77a5a5c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cfdff9b548ab/vmlinux-e77a5a5c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f2e4eca37d44/bzImage-e77a5a5c.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+001b9efd14d3e8fac896@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: slab-use-after-free in madvise_walk_vmas+0x661/0xae0 mm/madvise.c:1726

Thanks, this is code from a patch of mine so taking a look.

> Read of size 8 at addr ffff88803322aa08 by task syz.0.3603/14995
>
> CPU: 1 UID: 0 PID: 14995 Comm: syz.0.3603 Tainted: G             L      syzkaller #0 PREEMPT(full)
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  madvise_walk_vmas+0x661/0xae0 mm/madvise.c:1726
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
>  __do_sys_madvise mm/madvise.c:2031 [inline]
>  __se_sys_madvise mm/madvise.c:2029 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6f8599c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f6f8681a028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f6f85c16090 RCX: 00007f6f8599c799
> RDX: 0000000000000019 RSI: 0000000008000000 RDI: 0000200000000000
> RBP: 00007f6f85a32c99 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6f85c16128 R14: 00007f6f85c16090 R15: 00007ffd2a0e3548
>  </TASK>
>
> Allocated by task 5846:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4569 [inline]
>  slab_alloc_node mm/slub.c:4898 [inline]
>  kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4905
>  vm_area_dup+0x2b/0x680 mm/vma_init.c:123
>  dup_mmap+0x8b1/0x1d90 mm/mmap.c:1786
>  dup_mm kernel/fork.c:1533 [inline]
>  copy_mm+0x13b/0x4a0 kernel/fork.c:1585
>  copy_process+0x1efd/0x4430 kernel/fork.c:2260
>  kernel_clone+0x26d/0x8e0 kernel/fork.c:2709
>  __do_sys_clone kernel/fork.c:2850 [inline]
>  __se_sys_clone kernel/fork.c:2834 [inline]
>  __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2834
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 15002:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2689 [inline]
>  slab_free_after_rcu_debug+0x12a/0x220 mm/slub.c:6304
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  do_softirq+0x76/0xd0 kernel/softirq.c:523
>  __local_bh_enable_ip+0xf8/0x130 kernel/softirq.c:450
>  lock_sock include/net/sock.h:1713 [inline]
>  packet_do_bind+0x33/0xe10 net/packet/af_packet.c:3198
>  __sys_bind_socket net/socket.c:1932 [inline]
>  __sys_bind+0x2e3/0x410 net/socket.c:1963
>  __do_sys_bind net/socket.c:1968 [inline]
>  __se_sys_bind net/socket.c:1966 [inline]
>  __x64_sys_bind+0x7a/0x90 net/socket.c:1966
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  slab_free_hook mm/slub.c:2650 [inline]
>  slab_free mm/slub.c:6242 [inline]
>  kmem_cache_free+0x44f/0x650 mm/slub.c:6369
>  remove_vma mm/vma.c:473 [inline]
>  vms_complete_munmap_vmas+0x929/0xc60 mm/vma.c:1361
>  do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
>  do_munmap+0xf9/0x170 mm/mmap.c:1067
>  mremap_to+0x353/0x880 mm/mremap.c:1448
>  do_mremap mm/mremap.c:1999 [inline]
>  __do_sys_mremap mm/mremap.c:2055 [inline]
>  __se_sys_mremap+0xe6d/0x11d0 mm/mremap.c:2023
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88803322aa00
>  which belongs to the cache vm_area_struct of size 256
> The buggy address is located 8 bytes inside of
>  freed 256-byte region [ffff88803322aa00, ffff88803322ab00)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88803322adc0 pfn:0x3322a
> memcg:ffff88803322af01
> flags: 0xfff00000000200(workingset|node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000200 ffff88801c294b40 ffffea0001163f90 ffffea0001dba810
> raw: ffff88803322adc0 00000008000c000b 00000000f5000000 ffff88803322af01
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 11045, tgid 11045 (syz.0.2085), ts 233915893282, free_ts 233883108694
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1850
>  prep_new_page mm/page_alloc.c:1858 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3938
>  __alloc_frozen_pages_noprof+0x233/0x3d0 mm/page_alloc.c:5218
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7247
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
>  alloc_from_pcs mm/slub.c:4749 [inline]
>  slab_alloc_node mm/slub.c:4883 [inline]
>  kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4905
>  vm_area_dup+0x2b/0x680 mm/vma_init.c:123
>  __split_vma+0x1dc/0xa40 mm/vma.c:516
>  split_vma mm/vma.c:599 [inline]
>  vma_modify+0x88a/0x1e10 mm/vma.c:1691
>  vma_modify_flags+0x24b/0x330 mm/vma.c:1719
>  mprotect_fixup+0x62a/0xb60 mm/mprotect.c:759
>  do_mprotect_pkey+0x8d5/0xd20 mm/mprotect.c:937
>  __do_sys_mprotect mm/mprotect.c:958 [inline]
>  __se_sys_mprotect mm/mprotect.c:955 [inline]
>  __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:955
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 23 tgid 23 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1394 [inline]
>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2935
>  __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88803322a900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88803322a980: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >ffff88803322aa00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                       ^
>  ffff88803322aa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88803322ab00: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

