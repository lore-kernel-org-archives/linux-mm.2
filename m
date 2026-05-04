Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B6FFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 17:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69EBB6B0088; Mon,  4 May 2026 13:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FAC6B008A; Mon,  4 May 2026 13:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518346B008C; Mon,  4 May 2026 13:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4766B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:54:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD2BBA0244
	for <linux-mm@kvack.org>; Mon,  4 May 2026 17:54:36 +0000 (UTC)
X-FDA: 84730487352.18.4E4EF6E
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA2351C0016
	for <linux-mm@kvack.org>; Mon,  4 May 2026 17:54:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3Wd34aQkbAE48EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3Wd34aQkbAE48EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777917274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=yf1acHnuMkvLtJHbgF3Z56jQ1gcWmSXrdwsWfpDSszg=;
	b=bO8wi+hO9/7Q0flOxJ3ibqH4xJvOnSkSFULgQtk6jcBjH0y9XwUqz3asGxdVYEvjY4Tovg
	0Cfsez7Uf3TiM+kNd0I23XZYOWu1gT+QwSYmGuT1tHeQ0dx/bgh2T3r1+w9OTVUfRMHkA7
	cDwfAyQ2zEpsKltWk8JyoagOJ1KeQJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777917274; a=rsa-sha256;
	cv=none;
	b=Thhyqgfhc+j/7lFw2lGGfsCFBFl6kE07+78xQkFAz84lpPfhMO6WufZw+765Ic1Ul1t/1D
	UtTnSLtpo/7C4VaWwGrLoh2yPcEc24b+AOJLtR7e9ocBPRjterVasG10mCiTIGbBAY3wat
	t5l8j20oHx6S4kH+t+vd3S8zsA1Y7VE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3Wd34aQkbAE48EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3Wd34aQkbAE48EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6853c2438b9so8476642eaf.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 10:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777917274; x=1778522074;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yf1acHnuMkvLtJHbgF3Z56jQ1gcWmSXrdwsWfpDSszg=;
        b=oiS0jM/k7bvoMVSuhh6ZT2RY9vsBqRUWiBX3E9CQIrznm1K2aV0QJH0qXDfXZrfx/6
         FIsGC8X156+MUXNeqtIg0CVHpngchMSNZrH5REWfcCY1A4pTo+vvirSt7HGld7NWuzPL
         Ge/4QGgTAZk12XvkWZjEu5+wGNQQ1Y67yj+u5+4HICvrWh/8/3qvRDoENTgtNXJoa9Oq
         MNn1XXaX56Vz62q/4kSoRjAgHIFiYfubHBSU7NFbBpQPvQx9rsy4J/xqgaZz1E17qgH/
         l/d1JCAqekeoc1GYfDKh13QGGqeHlFxYI4wSLKpRmdhV76P7HCnaA9QTXFaoKKDk4BiJ
         h7RQ==
X-Forwarded-Encrypted: i=1; AFNElJ/uWdMUfgAOWULHlhYkTxl79VHxQOHtXvfYXg3l/NSrtzB6l8W0seNx0sWVDd+OImpfvMHK9dakew==@kvack.org
X-Gm-Message-State: AOJu0Yw7p+y+nCI+cbfprNDamzVDDhbssQaM/iFKL+eoVc3ByKh1p7VR
	fVpWFrIVURREoZ+QLTYasvQdS6wuSq3pynn/YT+4rgekzeQM+IUICfSl6UwLjPmMlAdWsG64599
	82R2MsNnO/xxLGJfOSRqQ7IjTgPHvpdp0XrWuWrN/3giPL/Eey01ByuCYtr0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f022:b0:68a:e01a:9b99 with SMTP id
 006d021491bc7-69697df9a6cmr5304663eaf.50.1777917273794; Mon, 04 May 2026
 10:54:33 -0700 (PDT)
Date: Mon, 04 May 2026 10:54:33 -0700
In-Reply-To: <6936812a.a70a0220.38f243.0090.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f8dd59.170a0220.bb392.0004.GAE@google.com>
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid context
 in kvm_mmu_notifier_invalidate_range_start
From: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dwmw@amazon.co.uk, kvm@vger.kernel.org, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, lkp@intel.com, llvm@lists.linux.dev, 
	lorenzo.stoakes@oracle.com, me@brighamcampbell.com, mhocko@suse.com, 
	oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, rientjes@google.com, 
	rppt@kernel.org, seanjc@google.com, shaikhkamal2012@gmail.com, 
	shakeel.butt@linux.dev, skhan@linuxfoundation.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA2351C0016
X-Stat-Signature: apca6n7gn4dnoxoab9bjasa4cjdc3jfp
X-Rspam-User: 
X-HE-Tag: 1777917274-884216
X-HE-Meta: U2FsdGVkX19/qtKQDYniBDnUKUV+A5TAzO4U1jLLND/47puVyYtP6RaaOuVlYn6O/XBJcXnEF90BV+yzfuN/S4OdCXf0fipcjy2YTRuLGRUyAD9JjFyxBlmt31FbiION4DE6oEpm7575NYF/M9MFDPb+HrvNmQxuG9SQGsPVD6cwbdcawORXKD2GbBf0uXb5TblcACGP861ZvUCtzQ95t7L+fUzrWi7vZzcWbnCIpy5ulE/1PKaGTawOvwCet/JeaNFU+RozvaLQvhilfRyzVhD9XXuOERSoDnEVlHzvUNMT7bh/FYxB+642Eg07XedVVBLt6BJbbynDOUo3CHJ5/0aNVPHak9lhlpsSnpdBB7DTiy1v4YMv4wcP2X4dp2IKMteH5DnO1+jTi2W3qbJJ0v7H6zhHmnReS8PGxcKSDF8Bj2B39cgHi1xhiFnVEdPGpB5/8QdL4b7GsT+rEGcdqNxZ0MlXNJHgH6/ROIZGZNV/alUW6jZeA+mfui7JiCzJdW4IRPmQA32yGM7kqtd/FGKFWu5rS4cm+j6KsaSo952/xmIU3nqDsQRuXmdZNCS1pJY64AYl4M3VHIN0Rz5KeIePF/zwTYvMsCBFz74OJUdJ6LbWeDocK9nfv8rHBzl28lF8A+ANC/3aW26TiAvvfrFSyvpSaY7TngafkuaLvCYIn5xdX4Kofq5WAgJt/aJ5X1mire/XLN4MUi25aQpHasH2k05dv1WFlQZqLMo8bdz2vzK7ZUwee0KxvJRYm0q94rCSBG1Gv+4Sl596jvcFU3jrm3MeBQ+QfyKA4AfhpYSg6K+wpE2zPLDsektPS9tFBywXA+GTC4QQl3pFWewKMGbDXE3quSWusGuZgMk3k36x/d9d9RujmEnQ/53YJgzPMuDFsS+AIJqQ0tbApV96qw0Xv4YvimfyHK0IrK5IJVTx8doOiKOV1nUloK76k4UUhyJmWFmID7tZ+a/q628
 c6XuazAu
 UBkEQVmOjzREZtY+7l+NfM5R8h9BKJHvmpS9oU/c7PCutNN7B47pubKhacPcodCfA2VPcem2mdr+KNbqvKNxDnccUEKNlz6IK3bmbn/Aix2utoVJZNLGinJvT52ghXtO0PlWLHKlSvT2tG2Fazap0APOIF9+eHrXLFDVTKhnX1yvBrHzI4nv7kXh/jgfGgfd7pa/iinT8eA8KbxWJD8WzSPCsoCx+ozqmX2jR7ddEoq2xSIj8pAkfXVPy+LW8h0lE28muzDHoeq/PsgTgtYxKf2NFCSvIBP2QyzTgF8fF1BSf3aEcTpJyomdrs0Se1EEykY6GRDkkrqKCydeoBqKmZS+faAwTFm6j0N3OkLCA370jvg9G/m7oIBC2kYxz4osWFMyN7OB2IWBUPoHWqe8U+VIuHqzVMc0D9X4khRDqUEmTbw7Gj5lrOeSRx2sCzvf2sO9vCWob70fzcqCz3Y/6V8cMrPbvjPzFkEb5dQ7mInNKuOqw9UlCm7zVEioriD5HOpIYZbyG8hy6YnMX5wAStuEPsa+nnxWTJHvbWPF/fuwQW7Q3Y1PukKbPwLf3E5/QhXzwnlfSYDqskB5QlYRqESRLDVLKuXkyH2rED+TNZXOvh20Xv6aOqH99u3rHSgtdeCw/ZCVjLiHznZGBA9yciUYqEHYqnU3l1S6R0QtIBLW3heyUrHxsh3uWyvMNgHHv1CT8JIFTW3Ao2pnWCb+S3N48816EfgfCbh5ESXufkszfBBH89o8/IyR3ETmtrYMni7hghFRLLA2M1itJsI8LP0dfiqBfYXU+F7sRNYm1UwnHl089IQ6Z1DsXxcmzrdi9Vo5Ye1SP17yll4qQctTkqeUWFDV1QgWwGvQC5W1tmvlo2pLga6X22s2lc5KTxeG0N1gNdSAtWWmJbmbfZQaeFJlIQ8nKsvBPhdUW4MkZtHjW5LBqZrKQx1+s0RUdwLRI7Puse+aWTXOllurLggDJ+U6jN8eh
 6jkNfV8h
 h3NE9eYKz3MhbzEbZMOFMsjgyDW8oTDiFNJd/7mpaLpOeMavrZoKi5gQZKpbSD4ygvyg1aimagDXVGoMZsMUvHRJF4xUr3Z+lJnS+mRN1IuUDefbExLKV8JknCNP+CuOfnh2TV+bCPRML4iNm3NqrGOJ1Ds5TdXv8JgYY7HtuOh2zdnkuPcNLGGnhmOgSzu9Zwd43xiqJ1qACibA/oguihMsP6Zaq0fkmmihKM8T1LzcHV6XcdDfKBNVMe/3zgX9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    b9303e6bff70 Add linux-next specific files for 20260430
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13745dba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5474e13c6d20d45c
dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125dd748580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b3a0a2e50f73/disk-b9303e6b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d3d481b220d4/vmlinux-b9303e6b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d6e012913960/bzImage-b9303e6b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 40, name: oom_reaper
preempt_count: 0, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by oom_reaper/40:
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:566 [inline]
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:609 [inline]
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x2bb/0xc10 mm/oom_kill.c:650
 #1: ffffffff8e3066c0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:495 [inline]
 #1: ffffffff8e3066c0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: zap_vma_for_reaping+0x193/0x380 mm/memory.c:2119
 #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:187 [inline]
 #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:294 [inline]
 #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: mn_hlist_invalidate_range_start mm/mmu_notifier.c:515 [inline]
 #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_start+0x5a1/0xb60 mm/mmu_notifier.c:580
 #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x1b7/0xc00 virt/kvm/kvm_main.c:744
CPU: 0 UID: 0 PID: 40 Comm: oom_reaper Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x329/0x480 kernel/sched/core.c:9163
 __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]
 rt_spin_lock+0xc2/0x400 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:45 [inline]
 kvm_mmu_notifier_invalidate_range_start+0x1b7/0xc00 virt/kvm/kvm_main.c:744
 mn_hlist_invalidate_range_start mm/mmu_notifier.c:525 [inline]
 __mmu_notifier_invalidate_range_start+0x6e4/0xb60 mm/mmu_notifier.c:580
 mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:498 [inline]
 zap_vma_for_reaping+0x1f7/0x380 mm/memory.c:2119
 __oom_reap_task_mm mm/oom_kill.c:548 [inline]
 oom_reap_task_mm mm/oom_kill.c:585 [inline]
 oom_reap_task mm/oom_kill.c:609 [inline]
 oom_reaper+0x51e/0xc10 mm/oom_kill.c:650
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 40, name: oom_reaper
preempt_count: 0, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by oom_reaper/40:
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:611 [inline]
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:566 [inline]
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:609 [inline]
 #0: ffff8880335ed1b0 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x2bb/0xc10 mm/oom_kill.c:650
 #1: ffffffff8e3066c0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: __mmu_notifier_invalidate_range_end+0x67/0x400 mm/mmu_notifier.c:611
 #2: ffffffff8e306718 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_end+0x67/0x400 mm/mmu_notifier.c:611
 #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:45 [inline]
 #3: ffff88803996caf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_end+0x1d6/0x3d0 virt/kvm/kvm_main.c:814
CPU: 0 UID: 0 PID: 40 Comm: oom_reaper Tainted: G        W           syzkaller #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x329/0x480 kernel/sched/core.c:9163
 __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]
 rt_spin_lock+0xc2/0x400 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:45 [inline]
 kvm_mmu_notifier_invalidate_range_end+0x1d6/0x3d0 virt/kvm/kvm_main.c:814
 mn_hlist_invalidate_end mm/mmu_notifier.c:597 [inline]
 __mmu_notifier_invalidate_range_end+0x23b/0x400 mm/mmu_notifier.c:616
 mmu_notifier_invalidate_range_end include/linux/mmu_notifier.h:511 [inline]
 zap_vma_for_reaping+0x2d9/0x380 mm/memory.c:2124
 __oom_reap_task_mm mm/oom_kill.c:548 [inline]
 oom_reap_task_mm mm/oom_kill.c:585 [inline]
 oom_reap_task mm/oom_kill.c:609 [inline]
 oom_reaper+0x51e/0xc10 mm/oom_kill.c:650
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
oom_reaper: reaped process 6034 (syz.0.24), now anon-rss:0kB, file-rss:64kB, shmem-rss:0kB


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

