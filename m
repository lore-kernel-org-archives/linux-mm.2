Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B87CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 08:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E32D8E0101; Tue,  4 Nov 2025 03:59:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BABC8E00E7; Tue,  4 Nov 2025 03:59:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7348E0101; Tue,  4 Nov 2025 03:59:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4598E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:59:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F20CC4A6F7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:59:50 +0000 (UTC)
X-FDA: 84072326940.03.7962AEC
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 337D61C0006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:59:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rkA5MSK0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762246789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACoxnsLPwifItDCLqYhT5k8XWG0ViCrKK5nRSuUSDtc=;
	b=EZuyCxw45SKcnU/DX+YPG2H/yAnLlOBwUgAMbEbOE25h/sAWfxR6KFFjXw5kwHLODuBACF
	Iy82x6GA/JAnAdBM9R5SaaabC7Bo+QLMyBgwfR+q0AEPNB5OPdrsXggO6ByAWYFNqGddkK
	0v+faBdiIKq2ZCX16ZC9zGQZwnqGF6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762246789; a=rsa-sha256;
	cv=none;
	b=xes4aUIb4VGrTqyNJQEhOrV/8EdTXYTNzIhl8FBNVZfjUPYC1HENRhmneYzGVf1V/3ENWd
	ueA0kRcqj2ZY+Cwi5KQ5OtFnFCVCcJMp6O8zvL6xQ+gIG77YURabx6Ps40YAe75Rpi5tsM
	zViLXSiFBkYw7EfAtj3ItSm8/cKDedQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rkA5MSK0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <9e4b1242-a4a0-4292-be0e-cfd24c640d3c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762246786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ACoxnsLPwifItDCLqYhT5k8XWG0ViCrKK5nRSuUSDtc=;
	b=rkA5MSK0BMXWXwjbNLCwrj3u4Fv4kpzo9wawRX6o70dvqp7dWu3z9EJU6RtFsxtf4MIKfo
	jH60YzITDWU5qvfBCRfmr1vjQDlkhBVvgTtIAVUObBKzz5OOshhE9g2oitRB0BXXZoi6VN
	NVRxzpbihEUnPNBKhCMsuj8VNiQUHY4=
Date: Tue, 4 Nov 2025 16:59:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 21/26] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
References: <202511041421.784bbd5e-lkp@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <202511041421.784bbd5e-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qkgfmydg4kcbjurdetb5h86gn6t8q5nj
X-Rspam-User: 
X-Rspamd-Queue-Id: 337D61C0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762246789-246975
X-HE-Meta: U2FsdGVkX1+SaBBilbDSdvJKt3Noc1mOq1usmDIeowT5sCMHNhMN+WSWfHcbaPZg0h/1bayYdhkN2wd7nElG+cJ3KEPBb9klcRXfl6vk4RI/W0fcx69sJTO/kvijABoCdEuit0wF/BioECEOgszAc/t5CVAs3PAtzZY7+4Sdjmis58TYPOwqo23uhtt0wD13TV+sp5SxW/k8jfYVJmrNRgWp/hnBmxubJc1S8BZRDZs7AhahVWLyFKQquK8KewLuxNFkhTHWq2YaKGzvZb+/uGErqb0HuF2xW2zG17vtDs+BXyyjc6+8wEUlq8pxSC93oUgVhTwCpIELFPZWvKRI1doGAt6YL4wCcQoP8c0or3rtyDl9/1ut2KLDUl25VFXN3C65X4lQij7/x3XyC03jQmKD/lWvjJgcuRCog2pdjzYV8TSfbDLIxjMrzgn8CifcG+RKI9FgAPuQauHLjsDx+ERGTuUPpMxtXbwdoAl8OVO0Ys6fOKBOdwSWnogls5Ov1VUo3nkok/Xa+Dd1QoUJ60xxTXVXZDm0X0KLG16xkMAByNgwFzDTOQKOSi/+WJ14cpBylqn854t/s2mmU/ToLkaMF21l7kld+F4Z9M0TxZj3EZJhPEmbO3w81bLZURmpI+CbrNDtC8grSPnic4785+vrLvPN4ArKWmeBgGRsi+1s+JCZhe6YlHBwJe+eESrpmW7yv0H29qlMny1DPTxxNOHyucHdyF2P58DEdyOUfE829FWGtoVM0lMLhAAqddqW/8S+26qxMvtkG7Q/yipSshZTsua4KDwSs5YnYBwaE85Wy1YMgjN3wLCIQZR9VG4WRguGGhRQUPWRHREqG3UfoH7CCi1w6obQk0lQvHI7XvAhJ+P8AIbRbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/4/25 2:49 PM, kernel test robot wrote:
> 

[...]

> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202511041421.784bbd5e-lkp@intel.com
> 
> 
> [    1.392214][   T45] WARNING: bad unlock balance detected!
> [    1.393285][   T45] 6.18.0-rc3-00251-gdd9e066d9677 #1 Not tainted
> [    1.394579][   T45] -------------------------------------
> [    1.395442][   T45] kworker/u9:1/45 is trying to release lock (rcu_read_lock) at:
> [    1.396977][   T45] rcu_read_unlock (include/linux/rcupdate.h:341 include/linux/rcupdate.h:897)
> [    1.398160][   T45] but there are no more locks to release!
> [    1.399337][   T45]
> [    1.399337][   T45] other info that might help us debug this:
> [    1.399707][   T45] 5 locks held by kworker/u9:1/45:
> [    1.399707][   T45]  #0: c01ad6c4 ((wq_completion)async){+.+.}-{0:0}, at: process_one_work (kernel/workqueue.c:3238)
> [    1.399707][   T45]  #1: c08e9f18 ((work_completion)(&entry->work)){+.+.}-{0:0}, at: process_one_work (kernel/workqueue.c:3239)
> [    1.399707][   T45]  #2: c02ed27c (sb_writers#2){.+.+}-{0:0}, at: file_start_write+0x1e/0x30
> [    1.399707][   T45]  #3: c042e0ec (&sb->s_type->i_mutex_key){++++}-{4:4}, at: generic_file_write_iter (mm/filemap.c:4404)
> [    1.399707][   T45]  #4: eaa771a0 (lock#3){+.+.}-{3:3}, at: local_lock_acquire (include/linux/local_lock_internal.h:40)
> [    1.399707][   T45]
> [    1.399707][   T45] stack backtrace:
> [    1.399707][   T45] CPU: 0 UID: 0 PID: 45 Comm: kworker/u9:1 Not tainted 6.18.0-rc3-00251-gdd9e066d9677 #1 PREEMPT(none)
> [    1.399707][   T45] Workqueue: async async_run_entry_fn
> [    1.399707][   T45] Call Trace:
> [    1.399707][   T45]  dump_stack_lvl (lib/dump_stack.c:122)
> [    1.399707][   T45]  ? rcu_read_unlock (include/linux/rcupdate.h:341 include/linux/rcupdate.h:897)
> [    1.399707][   T45]  dump_stack (lib/dump_stack.c:130)
> [    1.399707][   T45]  print_unlock_imbalance_bug (kernel/locking/lockdep.c:5300 kernel/locking/lockdep.c:5272)
> [    1.399707][   T45]  ? rcu_read_unlock (include/linux/rcupdate.h:341 include/linux/rcupdate.h:897)
> [    1.399707][   T45]  __lock_release+0x5e/0x150
> [    1.399707][   T45]  ? rcu_read_unlock (include/linux/rcupdate.h:341 include/linux/rcupdate.h:897)
> [    1.399707][   T45]  lock_release (kernel/locking/lockdep.c:470 kernel/locking/lockdep.c:5891 kernel/locking/lockdep.c:5875)
> [    1.399707][   T45]  ? lru_deactivate_file (mm/swap.c:119)
> [    1.399707][   T45]  rcu_read_unlock (include/linux/rcupdate.h:899)
> [    1.399707][   T45]  lruvec_unlock_irqrestore (include/linux/memcontrol.h:1522)
> [    1.399707][   T45]  folio_batch_move_lru (include/linux/mm.h:1501 mm/swap.c:179)
> [    1.399707][   T45]  __folio_batch_add_and_move (mm/swap.c:196 (discriminator 2))
> [    1.399707][   T45]  ? lru_deactivate_file (mm/swap.c:119)
> [    1.399707][   T45]  folio_add_lru (mm/swap.c:514)
> [    1.399707][   T45]  filemap_add_folio (mm/filemap.c:996)
> [    1.399707][   T45]  __filemap_get_folio (mm/filemap.c:2023)
> [    1.399707][   T45]  simple_write_begin (fs/libfs.c:932 (discriminator 1))
> [    1.399707][   T45]  generic_perform_write (mm/filemap.c:4263)
> [    1.399707][   T45]  __generic_file_write_iter (mm/filemap.c:4380)
> [    1.399707][   T45]  generic_file_write_iter (mm/filemap.c:4406)
> [    1.399707][   T45]  __kernel_write_iter (fs/read_write.c:619)
> [    1.399707][   T45]  __kernel_write (fs/read_write.c:640)
> [    1.399707][   T45]  kernel_write (fs/read_write.c:660 fs/read_write.c:650)
> [    1.399707][   T45]  xwrite+0x27/0x80
> [    1.399707][   T45]  do_copy (init/initramfs.c:417 (discriminator 1))
> [    1.399707][   T45]  write_buffer (init/initramfs.c:470 (discriminator 1))
> [    1.399707][   T45]  flush_buffer (init/initramfs.c:482 (discriminator 1))
> [    1.399707][   T45]  __gunzip+0x21d/0x2c0
> [    1.399707][   T45]  ? bunzip2 (lib/decompress_inflate.c:39)
> [    1.399707][   T45]  ? __gunzip+0x2c0/0x2c0
> [    1.399707][   T45]  gunzip (lib/decompress_inflate.c:208)
> [    1.399707][   T45]  ? write_buffer (init/initramfs.c:476)
> [    1.399707][   T45]  ? initrd_load (init/initramfs.c:64)
> [    1.399707][   T45]  unpack_to_rootfs (init/initramfs.c:553)
> [    1.399707][   T45]  ? write_buffer (init/initramfs.c:476)
> [    1.399707][   T45]  ? initrd_load (init/initramfs.c:64)
> [    1.399707][   T45]  ? reserve_initrd_mem (init/initramfs.c:719)
> [    1.399707][   T45]  do_populate_rootfs (init/initramfs.c:734)
> [    1.399707][   T45]  async_run_entry_fn (kernel/async.c:136 (discriminator 1))
> [    1.399707][   T45]  ? async_schedule_node (kernel/async.c:118)
> [    1.399707][   T45]  process_one_work (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/jump_label.h:262 include/trace/events/workqueue.h:110 kernel/workqueue.c:3268)
> [    1.399707][   T45]  process_scheduled_works (kernel/workqueue.c:3346)
> [    1.399707][   T45]  worker_thread (include/linux/list.h:381 (discriminator 2) kernel/workqueue.c:952 (discriminator 2) kernel/workqueue.c:3428 (discriminator 2))
> [    1.399707][   T45]  kthread (kernel/kthread.c:465)
> [    1.399707][   T45]  ? process_scheduled_works (kernel/workqueue.c:3373)
> [    1.399707][   T45]  ? kthread_is_per_cpu (kernel/kthread.c:412)
> [    1.399707][   T45]  ret_from_fork (arch/x86/kernel/process.c:164)
> [    1.399707][   T45]  ? kthread_is_per_cpu (kernel/kthread.c:412)
> [    1.399707][   T45]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
> [    1.399707][   T45]  entry_INT80_32 (arch/x86/entry/entry_32.S:945)
> [    1.467118][   T32] Callback from call_rcu_tasks() invoked.
> [    1.468370][   T45] ------------[ cut here ]------------
> [    1.469508][   T45] WARNING: CPU: 0 PID: 45 at kernel/rcu/tree_plugin.h:443 __rcu_read_unlock (kernel/rcu/tree_plugin.h:443)
> [    1.471711][   T45] Modules linked in:
> [    1.472490][   T45] CPU: 0 UID: 0 PID: 45 Comm: kworker/u9:1 Not tainted 6.18.0-rc3-00251-gdd9e066d9677 #1 PREEMPT(none)
> [    1.474777][   T45] Workqueue: async async_run_entry_fn
> [    1.475823][   T45] EIP: __rcu_read_unlock (kernel/rcu/tree_plugin.h:443)
> [    1.476872][   T45] Code: 0c d0 56 c2 ff 8b a4 02 00 00 75 11 8b 83 a8 02 00 00 85 c0 74 07 89 d8 e8 7c fe ff ff 8b 83 a4 02 00 00 3d ff ff ff 3f 76 02 <0f> 0b 5b 5d 31 c0 c3 2e 8d b4 26 00 00 00 00 55 89 e5 57 56 89 c6
> All code
> ========
>     0:	0c d0                	or     $0xd0,%al
>     2:	56                   	push   %rsi
>     3:	c2 ff 8b             	ret    $0x8bff
>     6:	a4                   	movsb  %ds:(%rsi),%es:(%rdi)
>     7:	02 00                	add    (%rax),%al
>     9:	00 75 11             	add    %dh,0x11(%rbp)
>     c:	8b 83 a8 02 00 00    	mov    0x2a8(%rbx),%eax
>    12:	85 c0                	test   %eax,%eax
>    14:	74 07                	je     0x1d
>    16:	89 d8                	mov    %ebx,%eax
>    18:	e8 7c fe ff ff       	call   0xfffffffffffffe99
>    1d:	8b 83 a4 02 00 00    	mov    0x2a4(%rbx),%eax
>    23:	3d ff ff ff 3f       	cmp    $0x3fffffff,%eax
>    28:	76 02                	jbe    0x2c
>    2a:*	0f 0b                	ud2		<-- trapping instruction
>    2c:	5b                   	pop    %rbx
>    2d:	5d                   	pop    %rbp
>    2e:	31 c0                	xor    %eax,%eax
>    30:	c3                   	ret
>    31:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
>    38:	00
>    39:	55                   	push   %rbp
>    3a:	89 e5                	mov    %esp,%ebp
>    3c:	57                   	push   %rdi
>    3d:	56                   	push   %rsi
>    3e:	89 c6                	mov    %eax,%esi
> 
> Code starting with the faulting instruction
> ===========================================
>     0:	0f 0b                	ud2
>     2:	5b                   	pop    %rbx
>     3:	5d                   	pop    %rbp
>     4:	31 c0                	xor    %eax,%eax
>     6:	c3                   	ret
>     7:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
>     e:	00
>     f:	55                   	push   %rbp
>    10:	89 e5                	mov    %esp,%ebp
>    12:	57                   	push   %rdi
>    13:	56                   	push   %rsi
>    14:	89 c6                	mov    %eax,%esi
> [    1.480862][   T45] EAX: ffffffff EBX: c0bfd640 ECX: 00000000 EDX: 00000000
> [    1.482292][   T45] ESI: eaa771c0 EDI: c119e160 EBP: c08e9c0c ESP: c08e9c08
> [    1.483721][   T45] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010286
> [    1.485350][   T45] CR0: 80050033 CR2: ffbff000 CR3: 026c6000 CR4: 000006f0
> [    1.486725][   T45] Call Trace:
> [    1.487465][   T45]  rcu_read_unlock (include/linux/rcupdate.h:900)
> [    1.488404][   T45]  lruvec_unlock_irqrestore (include/linux/memcontrol.h:1522)
> [    1.489570][   T45]  folio_batch_move_lru (include/linux/mm.h:1501 mm/swap.c:179)
> [    1.491100][   T45]  __folio_batch_add_and_move (mm/swap.c:196 (discriminator 2))
> [    1.492318][   T45]  ? lru_deactivate_file (mm/swap.c:119)
> [    1.493827][   T45]  folio_add_lru (mm/swap.c:514)
> [    1.494817][   T45]  filemap_add_folio (mm/filemap.c:996)
> [    1.495891][   T45]  __filemap_get_folio (mm/filemap.c:2023)
> [    1.497735][   T45]  simple_write_begin (fs/libfs.c:932 (discriminator 1))
> [    1.498813][   T45]  generic_perform_write (mm/filemap.c:4263)
> [    1.500292][   T45]  __generic_file_write_iter (mm/filemap.c:4380)
> [    1.501552][   T45]  generic_file_write_iter (mm/filemap.c:4406)
> [    1.502790][   T45]  __kernel_write_iter (fs/read_write.c:619)
> [    1.504090][   T45]  __kernel_write (fs/read_write.c:640)
> [    1.505377][   T45]  kernel_write (fs/read_write.c:660 fs/read_write.c:650)
> [    1.506306][   T45]  xwrite+0x27/0x80
> [    1.507429][   T45]  do_copy (init/initramfs.c:417 (discriminator 1))
> [    1.508361][   T45]  write_buffer (init/initramfs.c:470 (discriminator 1))
> [    1.509300][   T45]  flush_buffer (init/initramfs.c:482 (discriminator 1))
> [    1.510307][   T45]  __gunzip+0x21d/0x2c0
> [    1.511424][   T45]  ? bunzip2 (lib/decompress_inflate.c:39)
> [    1.512312][   T45]  ? __gunzip+0x2c0/0x2c0
> [    1.513515][   T45]  gunzip (lib/decompress_inflate.c:208)
> [    1.514359][   T45]  ? write_buffer (init/initramfs.c:476)
> [    1.515304][   T45]  ? initrd_load (init/initramfs.c:64)
> [    1.516217][   T45]  unpack_to_rootfs (init/initramfs.c:553)
> [    1.517220][   T45]  ? write_buffer (init/initramfs.c:476)
> [    1.518175][   T45]  ? initrd_load (init/initramfs.c:64)
> [    1.519172][   T45]  ? reserve_initrd_mem (init/initramfs.c:719)
> [    1.520375][   T45]  do_populate_rootfs (init/initramfs.c:734)
> [    1.521401][   T45]  async_run_entry_fn (kernel/async.c:136 (discriminator 1))
> [    1.522378][   T45]  ? async_schedule_node (kernel/async.c:118)
> [    1.523492][   T45]  process_one_work (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/jump_label.h:262 include/trace/events/workqueue.h:110 kernel/workqueue.c:3268)
> [    1.526446][   T45]  process_scheduled_works (kernel/workqueue.c:3346)
> [    1.527578][   T45]  worker_thread (include/linux/list.h:381 (discriminator 2) kernel/workqueue.c:952 (discriminator 2) kernel/workqueue.c:3428 (discriminator 2))
> [    1.528573][   T45]  kthread (kernel/kthread.c:465)
> [    1.529483][   T45]  ? process_scheduled_works (kernel/workqueue.c:3373)
> [    1.530780][   T45]  ? kthread_is_per_cpu (kernel/kthread.c:412)
> [    1.531779][   T45]  ret_from_fork (arch/x86/kernel/process.c:164)
> [    1.532664][   T45]  ? kthread_is_per_cpu (kernel/kthread.c:412)
> [    1.533736][   T45]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
> [    1.534846][   T45]  entry_INT80_32 (arch/x86/entry/entry_32.S:945)
> [    1.536182][   T45] irq event stamp: 2161
> [    1.536994][   T45] hardirqs last  enabled at (2161): _raw_spin_unlock_irqrestore (arch/x86/include/asm/irqflags.h:26 arch/x86/include/asm/irqflags.h:109 arch/x86/include/asm/irqflags.h:151 include/linux/spinlock_api_smp.h:151 kernel/locking/spinlock.c:194)
> [    1.538763][   T45] hardirqs last disabled at (2160): _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:109 kernel/locking/spinlock.c:162)
> [    1.540674][   T45] softirqs last  enabled at (1956): handle_softirqs (kernel/softirq.c:469 (discriminator 2) kernel/softirq.c:650 (discriminator 2))
> [    1.542454][   T45] softirqs last disabled at (1949): __do_softirq (kernel/softirq.c:657)
> [    1.544105][   T45] ---[ end trace 0000000000000000 ]---
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20251104/202511041421.784bbd5e-lkp@intel.com

In this config file, CONFIG_MEMCG is not set:

# CONFIG_MEMCG is not set

In this case, folio_lruvec_lock*() was not modified (add
rcu_read_lock()), will fix it in the next version.

Thanks,
Qi

> 
> 
> 


