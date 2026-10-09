Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96245CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850436B008A; Fri,  9 Oct 2026 03:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800EA6B008C; Fri,  9 Oct 2026 03:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EFEB6B0092; Fri,  9 Oct 2026 03:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC586B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:59:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E7D4A029C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:59:20 +0000 (UTC)
X-FDA: 85302337680.23.AA2D637
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf11.hostedemail.com (Postfix) with ESMTP id BDE5440008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:59:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MPoyoE5+;
	spf=pass (imf11.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791532758;
	b=fAbs869RF02h1+AluVIVtsU9g7U7LADhFN26hNdohna7VBXYH8mDAIVAG4U0J1f4ik93YY
	fRkkMOAbTe0czhzvUwX+jmyHGUWcabO2hyZiVyAAgsC436uiOmi1N2uVaD0KLieYzvzOsx
	r50rlFSp82cwWN8+CltZ9FMV/WLyqx4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MPoyoE5+;
	spf=pass (imf11.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791532758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFnfiaxbm20FTKmlvYwgvRjnMOXRmAw+Vmpc1lTVynI=;
	b=ngSYiji13uu9PG7hsyo6aQRHwJ+RD4wrceq6f4Q8Rdft7SAZMryByXKnB5U3ZGYeaH+gZ0
	UZTBVdPxmtDCy67Zbi6QcXrxerE8EV8SBAkCSpvfsb48lye5YU9bcuIxAKwZ0X8qs/LBIt
	5aatHVOLgY7A8n6G60MCdTnnqUjIQ9A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791532749; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bFnfiaxbm20FTKmlvYwgvRjnMOXRmAw+Vmpc1lTVynI=;
 b=MPoyoE5+3eJO/bvZmoQrtaAH+tCkpez2ikUb3IW2nWhWQ5yYsSqdseixR1q2tDMFDFZF4J
 OKyDR4MJYfrqpQFVMUsY+CFT67/PYtkNcZeNm3SoFxRv5dBBVhUDrNYg66ccVEPsDiEyVn
 6c5lnXIx+AhwMO/h+Cp3iyDfITm69SY76muosyG7DCoi6eg+cO5cHa3PYCclyxiJ7BpNVF
 h3ujv4zX/18c1RN+s/sfnljjZhle7tz7Ezu91Gli/SHbFRb5w7YL7LRlBf/KQu9jJTWAQs
 pg1lAogXu9DDfCv6yFyFnlf+9SlsCy2dhuZwhIMTJB/CrIRPVJxfUwBDGs2T+g==
In-Reply-To: <202610091403.d1d8080b-lkp@intel.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Date: Fri, 9 Oct 2026 15:58:46 +0800
Mime-Version: 1.0
References: <202610091403.d1d8080b-lkp@intel.com>
X-Lms-Return-Path: <lba+26ac89ecb+d2cf18+kvack.org+zhengqi.arch@bytedance.com>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
To: "kernel test robot" <yi1.lai@intel.com>
Subject: Re: [linux-next:master] [mm] b9b1861d4f: WARNING:possible_circular_locking_dependency_detected
Cc: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Baolin Wang" <baolin.wang@linux.alibaba.com>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"David Hildenbrand" <david@kernel.org>, 
	"Hugh Dickins" <hughd@google.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	"Michal Hocko" <mhocko@kernel.org>, 
	"Muchun Song" <muchun.song@linux.dev>, 
	"Roman Gushchin" <roman.gushchin@linux.dev>, 
	"Shakeel Butt" <shakeel.butt@linux.dev>, 
	"Qinyun Tan" <qinyuntan@linux.alibaba.com>, <linux-mm@kvack.org>
Message-Id: <36a0604d-b0ff-4f14-9203-0ffb36e0917b@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDE5440008
X-Stat-Signature: j67yupwn6ejxamzmaznj4ozrh7dfraxg
X-HE-Tag: 1791532756-734556
X-HE-Meta: U2FsdGVkX1/eHtccsS7UgH+MGTudCBhuCg2c9+qg/mrcl07NloNv59UIIE2hTgXrZTH5rq4U6+HZbv75ADReQ/3nkK3HrRR+iDC6AKtQUc0F2rzwlZyhkvL4U8CZCffzl7ImqEokJVeMy5gHvDHmwhJlw1G2+fpl4HOvTuVeqOiobz70rBdHrTQF2LQipcSRxs7t8fHqZrQl1Ga8FzPXTvy2Zl2BDqa0NYPnw+G+cW4++f/S0c8erPlGT7BbHIGUhXCX92Z5uXr2dvNC8XZb4f5Pp/giUo/TXn5Mu89zjkG+2zInTWF/jlNek2Pvn4XxbAHsqxddbrbTGaCn+mUYajCEgn9NI8jIU5P6LjJGZ/JkjTjwjQLnxX781iSKYRun7RW9CkiF6hDx5Z7oR34netD6Cx195E5t17ztXHKDFVSWY8c5TK7MqtyWUDb/uxZeUgUsgRenVIABxVtQGvpKbDQ3tFdc6q+0o9MUItfh7jKn1rtRV3hKC7yc92naNl4XdwAGU63wlcBKu8lZ34B1EpgYnLU1VytPwx/6DEfmIjbg6e2fxsQtHgNJmW+dczhGzLEc/4AnraBE8sr6b/ko3PH/bdlD4ehiusWpwXn1wPPVkw24z0igDM3UDYatwvvT8BVy+7MVn27qo9Ef0MixSFQL0AX/J2//WufY32cGcmX7IxLT6ns57JkHeFuaJqFuBAPyfX6hoMlduKAzkLUYJFdTT+Fj8h7zIQHPfBgcKN7iCFvP1Hx3iPO6XAR1N4OvRzB717ZhwHcfzGdZL+5/tIBHro4zMaSaX7q4XuU9AT0gQTgT8j9TuemIIDjLxVgsjzNPburL8TXwZ8Bnd8lbpLBOzIWQ4IzuEafRZzH/VHPBPPn+FgR25b/1YcZfK4rXquljUmn2OS27dGutaJwSBHM1bc6eO3XI/U7Cf9PfRJy1pYHGtPNu0gF9nRXsty6tkoUOZX0qC2eEMXKgTi5
 UqqzBW62
 ChttikjHtCjnp/gVDS2YILq/pQMOmjoOGucA7kzIR1Gm3i2yXp5g/eLQIK+HQV/ZyZYe7Ds/5nv68rY5E9lMf2S5ELWeKKRX512efUpLqTVD/MTjP17En83ZtbR4EZ17jqZplNlKUg63KvRc9Dh2lJUuY/z0LRxDecNHk3w3S7QNnyZfFw9U6nxnEmrze4f32M7lMjJL9evcDQ5CnhHoNMNKbrjJaahMiqMr6KyHELzHjwTz7RlLcpNPhX9FTLSZVxBeZjo39O2+S6t40aaYj68dzW6ZJsuo4+DPGtC2xQQqLkcydFOLXdUI9C0ULQ3p+DTCbmp3l6k9Uv37vPjJpFNXI1Gc2QzQWAkcYSEM8pfCoF3tPbHXVLrwT6uvTELSyoszLNFGhu29R1P9eeTwbRdWRZL0r5peqZcjOzHfefIXEwNG95IgrxIzZqt6FdZgBySKQmulyqDjs+no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the report!

On 10/9/26 2:46 PM, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "WARNING:possible_circular_locking_dependency_detected" on:
> 
> commit: b9b1861d4f7ae63b15228c744d504a86ab48a5a2 ("mm: shmem: make unused huge shrinker memcg aware") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master f5f84daefcd92d7a630066635ecea1433ed5eac7]
> 
> in testcase: boot
> 
> config: i386-randconfig-053-20260902
> compiler: clang-22
> test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 4 -m 4G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yi1.lai@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202610091403.d1d8080b-lkp@intel.com
> 
> [   64.638596][  T203] ======================================================
> [   64.643742][  T203] WARNING: possible circular locking dependency detected
> [   64.649127][  T203] 7.3.0-rc4+ #1 Not tainted
> [   64.652392][  T203] ------------------------------------------------------

This does not look like an actual deadlock.  The list_lru lock held by
shmem_unused_huge_isolate() belongs to the shmem unused huge shrinklist,
while the existing dependency was recorded for the dentry LRU.  These
are distinct lock instances.

However, both locks use the default list_lru lock class, so lockdep
treats them as the same lock and combines their dependency chains.

Could you please help test whether the following change makes the
lockdep warning go away?

diff --git a/mm/shmem.c b/mm/shmem.c
index 5a9bcc7c66926..8ee767dccc1f6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5162,6 +5162,8 @@ static const struct dentry_operations 
shmem_ci_dentry_ops = {
  };
  #endif

+static struct lock_class_key shmem_unused_huge_lock_key;
+
  static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
  {
         struct shmem_options *ctx = fc->fs_private;
@@ -5243,7 +5245,8 @@ static int shmem_fill_super(struct super_block 
*sb, struct fs_context *fc)
                 goto failed;

  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-       if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
+       if (list_lru_init_memcg_key(&sbinfo->shrinklist, sb->s_shrink,
+                                   &shmem_unused_huge_lock_key))
                 goto failed;
  #endif


Thanks,
Qi


> [   64.657842][  T203] systemd-udevd/203 is trying to acquire lock:
> [   64.663589][  T203] f5835900 (&sb->s_type->i_lock_key){+.+.}-{3:3}, at: igrab+0x44/0xc0
> [   64.669221][  T203]
> [   64.669221][  T203] but task is already holding lock:
> [   64.669221][  T203]
> [   64.669221][  T203] but task is already holding lock:
> [   64.669221][  T203]
> [   64.669221][  T203] but task is already holding lock:
> [   64.674183][  T203] f5c5a61c (&l->lock){+.+.}-{3:3}, at: __list_lru_walk_one+0x55/0x180
> [   64.679737][  T203]
> [   64.679737][  T203] which lock already depends on the new lock.
> [   64.679737][  T203]
> [   64.679737][  T203] which lock already depends on the new lock.
> [   64.679737][  T203]
> [   64.679737][  T203] which lock already depends on the new lock.
> [   64.679737][  T203]
> [   64.686427][  T203]
> [   64.686427][  T203] the existing dependency chain (in reverse order) is:
> [   64.686427][  T203]
> [   64.686427][  T203] the existing dependency chain (in reverse order) is:
> [   64.686427][  T203]
> [   64.686427][  T203] the existing dependency chain (in reverse order) is:
> [   64.691963][  T203]
> [   64.691963][  T203] -> #2 (&l->lock){+.+.}-{3:3}:
> [   64.691963][  T203]
> [   64.691963][  T203] -> #2 (&l->lock){+.+.}-{3:3}:
> [   64.691963][  T203]
> [   64.691963][  T203] -> #2 (&l->lock){+.+.}-{3:3}:
> [   64.695874][  T203]        _raw_spin_lock+0x26/0x40
> [   64.699072][  T203]        list_lru_add_obj+0x3c/0xc0
> [   64.702561][  T203]        d_lru_add+0x40/0x80
> [   64.705640][  T203]        fast_dput+0x1c7/0x200
> [   64.708794][  T203]        dput+0x25/0x40
> [   64.711603][  T203]        pick_link+0x1ed/0x340
> [   64.714612][  T203]        step_into_slowpath+0x1af/0x200
> [   64.718143][  T203]        path_lookupat+0x109/0x1c0
> [   64.721512][  T203]        filename_lookup+0xc1/0x200
> [   64.725044][  T203]        user_path_at+0x2f/0xc0
> [   64.728522][  T203]        __ia32_sys_mount+0x134/0x1c0
> [   64.732025][  T203]        ia32_sys_call+0x39/0x14c0
> [   64.735800][  T203]        __do_fast_syscall_32+0x16c/0x340
> [   64.740069][  T203]        do_fast_syscall_32+0x28/0x80
> [   64.743715][  T203]        do_SYSENTER_32+0x12/0x40
> [   64.747337][  T203]        entry_SYSENTER_32+0x98/0xfd
> [   64.750971][  T203]
> [   64.750971][  T203] -> #1 (&lockref->lock){+.+.}-{3:3}:
> [   64.750971][  T203]
> [   64.750971][  T203] -> #1 (&lockref->lock){+.+.}-{3:3}:
> [   64.750971][  T203]
> [   64.750971][  T203] -> #1 (&lockref->lock){+.+.}-{3:3}:
> [   64.756528][  T203]        _raw_spin_lock+0x26/0x40
> [   64.760072][  T203]        d_instantiate+0x34/0x80
> [   64.763562][  T203]        d_make_root+0x29/0x40
> [   64.766867][  T203]        shmem_fill_super+0x292/0x340
> [   64.770617][  T203]        get_tree_nodev+0x3e/0x80
> [   64.774112][  T203]        shmem_get_tree+0x12/0x40
> [   64.777728][  T203]        vfs_get_tree+0x1e/0xc0
> [   64.781170][  T203]        vfs_kern_mount+0x6e/0xc0
> [   64.784747][  T203]        kern_mount+0x16/0x40
> [   64.787998][  T203]        shmem_init+0x26/0x100
> [   64.791525][  T203]        mnt_init+0xfd/0x140
> [   64.794594][  T203]        vfs_caches_init+0x26/0x40
> [   64.798341][  T203]        start_kernel+0x2df/0x380
> [   64.801707][  T203]        i386_start_kernel+0xc5/0x100
> [   64.805611][  T203]        startup_32_smp+0x151/0x160
> [   64.809276][  T203]
> [   64.809276][  T203] -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
> [   64.809276][  T203]
> [   64.809276][  T203] -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
> [   64.809276][  T203]
> [   64.809276][  T203] -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
> [   64.815036][  T203]        __lock_acquire+0x1851/0x2a40
> [   64.818649][  T203]        lock_acquire+0x96/0x200
> [   64.821879][  T203]        _raw_spin_lock+0x26/0x40
> [   64.825139][  T203]        igrab+0x44/0xc0
> [   64.828067][  T203]        shmem_unused_huge_isolate+0x2e/0xc0
> [   64.832099][  T203]        __list_lru_walk_one+0x98/0x180
> [   64.835960][  T203]        list_lru_walk_node+0x1b/0x40
> [   64.839660][  T203]        shmem_unused_huge_shrink+0x62/0x500
> [   64.843880][  T203]        shmem_alloc_and_add_folio+0x1b8/0x480
> [   64.847901][  T203]        shmem_get_folio_gfp+0x1af/0x880
> [   64.851755][  T203]        shmem_write_begin+0x5c/0x100
> [   64.855571][  T203]        generic_perform_write+0xc1/0x340
> [   64.859545][  T203]        shmem_file_write_iter+0x5f/0x80
> [   64.863719][  T203]        vfs_write+0x263/0x340
> [   64.867230][  T203]        ksys_write+0x6a/0x100
> [   64.870798][  T203]        __ia32_sys_write+0x18/0x40
> [   64.874740][  T203]        ia32_sys_call+0x1365/0x14c0
> [   64.878135][  T203]        __do_fast_syscall_32+0x16c/0x340
> [   64.881546][  T203]        do_fast_syscall_32+0x28/0x80
> [   64.885606][  T203]        do_SYSENTER_32+0x12/0x40
> [   64.889087][  T203]        entry_SYSENTER_32+0x98/0xfd
> [   64.892908][  T203]
> [   64.892908][  T203] other info that might help us debug this:
> [   64.892908][  T203]
> [   64.892908][  T203] other info that might help us debug this:
> [   64.892908][  T203]
> [   64.892908][  T203] other info that might help us debug this:
> [   64.892908][  T203]
> [   64.900253][  T203] Chain exists of:
> [   64.900253][  T203]   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
> [   64.900253][  T203]
> [   64.900253][  T203] Chain exists of:
> [   64.900253][  T203]   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
> [   64.900253][  T203]
> [   64.900253][  T203] Chain exists of:
> [   64.900253][  T203]   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
> [   64.900253][  T203]
> [   64.909551][  T203]  Possible unsafe locking scenario:
> [   64.909551][  T203]
> [   64.909551][  T203]  Possible unsafe locking scenario:
> [   64.909551][  T203]
> [   64.909551][  T203]  Possible unsafe locking scenario:
> [   64.909551][  T203]
> [   64.915049][  T203]        CPU0                    CPU1
> [   64.918939][  T203]        ----                    ----
> [   64.922808][  T203]   lock(&l->lock);
> [   64.925634][  T203]                                lock(&lockref->lock);
> [   64.930586][  T203]                                lock(&l->lock);
> [   64.934913][  T203]   lock(&sb->s_type->i_lock_key);
> [   64.938686][  T203]
> [   64.938686][  T203]  *** DEADLOCK ***
> [   64.938686][  T203]
> [   64.938686][  T203]  *** DEADLOCK ***
> [   64.938686][  T203]
> [   64.938686][  T203]  *** DEADLOCK ***
> [   64.938686][  T203]
> [   64.944491][  T203] locks held by systemd-udevd/203: 4, last CPU#0:
> [   64.949046][  T203]  #0: f5c50a6c (sb_writers#6){.+.+}-{0:0}, at: vfs_write+0xb7/0x340
> [   64.954944][  T203]  #1: f5655658 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: shmem_file_write_iter+0x28/0x80
> [   64.962274][  T203]  #2: f5c5a61c (&l->lock){+.+.}-{3:3}, at: __list_lru_walk_one+0x55/0x180
> [   64.968148][  T203]  #3: f5835810 (&info->lock){+.+.}-{3:3}, at: shmem_unused_huge_isolate+0x1f/0xc0
> [   64.974409][  T203]
> [   64.974409][  T203] stack backtrace:
> [   64.974409][  T203]
> [   64.974409][  T203] stack backtrace:
> [   64.974409][  T203]
> [   64.974409][  T203] stack backtrace:
> [   64.978786][  T203] CPU: 0 UID: 0 PID: 203 Comm: systemd-udevd Not tainted 7.3.0-rc4+ #1 PREEMPT  2f9698b0cc81084abb5f3c5754f76765d21e2bf0
> [   64.987668][  T203] Call Trace:
> [   64.990012][  T203]  __dump_stack+0x18/0x40
> [   64.993281][  T203]  dump_stack_lvl+0x20/0x40
> [   64.996699][  T203]  dump_stack+0xd/0x12
> [   64.999644][  T203]  print_circular_bug+0x2bf/0x300
> [   65.003228][  T203]  check_noncircular+0xd7/0x100
> [   65.006753][  T203]  __lock_acquire+0x1851/0x2a40
> [   65.009733][  T203]  ? _raw_spin_unlock_irqrestore+0x20/0x80
> [   65.013953][  T203]  lock_acquire+0x96/0x200
> [   65.017236][  T203]  ? igrab+0x44/0xc0
> [   65.020072][  T203]  _raw_spin_lock+0x26/0x40
> [   65.023308][  T203]  ? igrab+0x44/0xc0
> [   65.025972][  T203]  igrab+0x44/0xc0
> [   65.028647][  T203]  shmem_unused_huge_isolate+0x2e/0xc0
> [   65.032472][  T203]  __list_lru_walk_one+0x98/0x180
> [   65.035619][  T203]  ? shmem_unused_huge_shrink+0x500/0x500
> [   65.039875][  T203]  list_lru_walk_node+0x1b/0x40
> [   65.043576][  T203]  ? shmem_unused_huge_shrink+0x500/0x500
> [   65.047582][  T203]  shmem_unused_huge_shrink+0x62/0x500
> [   65.051774][  T203]  ? shmem_inode_acct_blocks+0x218/0x280
> [   65.055593][  T203]  shmem_alloc_and_add_folio+0x1b8/0x480
> [   65.059093][  T203]  shmem_get_folio_gfp+0x1af/0x880
> [   65.062996][  T203]  shmem_write_begin+0x5c/0x100
> [   65.066769][  T203]  generic_perform_write+0xc1/0x340
> [   65.070595][  T203]  shmem_file_write_iter+0x5f/0x80
> [   65.074058][  T203]  vfs_write+0x263/0x340
> [   65.077047][  T203]  ? shmem_file_read_iter+0x400/0x400
> [   65.081058][  T203]  ksys_write+0x6a/0x100
> [   65.084028][  T203]  __ia32_sys_write+0x18/0x40
> [   65.087227][  T203]  ia32_sys_call+0x1365/0x14c0
> [   65.090769][  T203]  __do_fast_syscall_32+0x16c/0x340
> [   65.094701][  T203]  ? do_fast_syscall_32+0x28/0x80
> [   65.098687][  T203]  do_fast_syscall_32+0x28/0x80
> [   65.102284][  T203]  do_SYSENTER_32+0x12/0x40
> [   65.105857][  T203]  entry_SYSENTER_32+0x98/0xfd
> [   65.109406][  T203] EIP: 0xa7fbbc4c
> [   65.112302][  T203] Code: c0 74 05 c1 e9 0c 89 08 31 c0 5e 5d 31 c9 31 d2 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 8d 76 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 58 b8
> [   65.127608][  T203] EAX: ffffffda EBX: 00000010 ECX: 0238cb60 EDX: 00000023
> [   65.133201][  T203] ESI: 00000023 EDI: 0238cb60 EBP: 0238a5e0 ESP: afef94f0
> [   65.138647][  T203] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200246
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20261009/202610091403.d1d8080b-lkp@intel.com
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 

