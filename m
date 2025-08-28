Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76276CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7538E0002; Wed, 27 Aug 2025 22:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFD58E0001; Wed, 27 Aug 2025 22:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC368E0002; Wed, 27 Aug 2025 22:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1578E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E27C13A3B9
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:05:54 +0000 (UTC)
X-FDA: 83824525428.11.741CFB9
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5630A1C0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:05:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3f7mvaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3f7mvaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756346752; a=rsa-sha256;
	cv=none;
	b=mj0W3uTi7jTZJ/qy8YrxmjSJ+yzF1Bu7A+aCEcUQc/soUhjf1JJDBRfUGdeUJcG6dDcH8G
	oWWG2fuZ3L6+0ZFQCV5Jwd2Pqs3HA+r+H/LPjuacRBGm2mqNEUnnbHsCA7sERGLTbXgi5C
	NkU8b/FT7T1lADYpDYcKfc0eZBcDPRk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3f7mvaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3f7mvaAkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756346752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=6fLYr0rEBIUJmLgLSw15rt7QhdRgunDSyaRqr6iiuJ4=;
	b=rukGymV1N0RHF567mILxm/fHA1HkeNdzoaO6DwhaUG+whepi8kLsQWpnO4EetJ3/o6sjHg
	36NkiSEkr3RgHL+IhP0GJnjK7a5V8oKYuF6mDmC/FbzsGk1vZ4VUe6N3aowcEXR3EsHPq2
	ZHJ6iUjyx1z2Zea97BVJF3vXStmdDQs=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3eee0110eb5so11424495ab.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756346751; x=1756951551;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fLYr0rEBIUJmLgLSw15rt7QhdRgunDSyaRqr6iiuJ4=;
        b=hXHE6Lbo8v+KLzSeumGEcn7mDh/193YHNC1kzBk52Avd2oPOEqZ0DbudoVXuMihool
         FFrgE/4f0NxAxnmYx9+eMqINrGcfC7PAWzNfGjz5k4wsvOYBNmOOaMG/0BCFuDB0BH+n
         YiJ7S7jSdV8x9WduvBg6anntwoxnjfq8qshsQu9g+ntTN87thANVlZ8RD/UYIM6XdFDf
         /0sozi/jnZgy9RYPN3/abu1fm6M7oGF1Dn/qjrW+GUB+O0MVMeQaJRkW+G0eQaBnJjOH
         Z8yFYdM7NvU6AbGuvMt7R8+6D8GapphtggoPs8ZEn4rWLxyjZIz8J8biM2fWADg43vcw
         ZHYg==
X-Forwarded-Encrypted: i=1; AJvYcCV78ErDfBteM5t7okjhJpCev4LRkMUY6VXyfT6JfJ+VW8FRpFo1h5D/Wy+lve3PpZH5kgaf2XKX0Q==@kvack.org
X-Gm-Message-State: AOJu0YyIpKsmTdQHNpz+T1EOD+o/z4Q9YIaWcg4ul4THZiCEs7V1/v93
	9t5YsWlvZzm3RstrzHlKkL8n7fIxKKL5gJLlRoMmn18hbjWHc5cnrqeL8Q1ZT+VuPgvMkV0OGDS
	RpjQ2uN5WFHVo3XE88w5JqHFNKLi8BdkfCjbQcSwBPJzQASikIza4yjfcd6I=
X-Google-Smtp-Source: AGHT+IHQnfgj6KFNnJDo9F67RX3OW4oqprjEVfXF4GMFauuE+Qj2q2mksiiDUOfCaKar5c+FZL5do+LpPoA96RnzoyCp4xubvOsC
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2141:b0:3e5:4b2e:3afd with SMTP id
 e9e14a558f8ab-3e9201fcc4amr294693705ab.8.1756346751414; Wed, 27 Aug 2025
 19:05:51 -0700 (PDT)
Date: Wed, 27 Aug 2025 19:05:51 -0700
In-Reply-To: <gbp663voo42lmhht3mzhxrmxyfwpdwaion4jz7symvuj6xgwhe@e6tektpig64u>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68afb97f.050a0220.8762d.0003.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
From: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
To: liam.howlett@oracle.com
Cc: akpm@linux-foundation.org, jannh@google.com, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5630A1C0005
X-Stat-Signature: 77obou8ddxkmuejsisjjcgqaxmbj4qyd
X-Rspam-User: 
X-HE-Tag: 1756346752-663997
X-HE-Meta: U2FsdGVkX1/xJCbzAGrdSS2BIwAjwwQgjt+CJgz8nFsQZ1oFupVj+m4jTXOEz+z/PhR7vLIeE2+7nP4qLhFd0CuZXeaajS7xmGPjlXXMUpqJCVirl8LNd+okrxlRKmutd/WIob4SJ8BPySYvcJSoMDoE302LoXCObaizNbNRtCx3G+rqaqdKmJj4dNPlqYB2g/Uk0ldIftII/af9MBycf93KNTpP1XCnzzcJRYFkspypn2WRLdEtsnCMmB78J35Y3ZMJ/J6wKT1lqGqUmEncX0sAL7wwk/gT1kTSXQatt+kgseAR0Km1aYdB+fSHJYiQ2YK4gwX1Ft6RX1Wt8Jq4ApyYk0VjAXUN0SIcy0mKFoHFAdLxYyyQb3mYix7qPlEkE7+CwRgOBHFhmeFzcMMrC2ENO8bCIAnmR9Zi4svgXGoV3fUlPlOw36SRO3ctCCK96x4EM3O59q2B57Aqn1JvAPe6x8vhwQDnHUQmoiU62aRQ9/pr4PrZQf7t6BmrrJBo3emqpSVYVIQCny3prna/Il6Ey3lEWtJ8cJ2pjBA2YgPEDhBgycZ3UqbuTXpgJ8XiIIgaUYC9vnKouW5XT9ChjugTWT08Cg9JtsPIqfYK5Me/GG8H+D6xy+Uurxw0+6171TpCMhbl8Y6jrWohMhdca0a0hoW6Yq3V39wLRGQj/xYBcgXjXNOOWVcTNz0+Y9pUfM1frdkWwhwI8lwJz9NlErqNhsy6tZIuPZ8yV0tMOyf4px/O/WFJbB164iI+S1Jh8THfGrud7nEH/3YLPDyybut8kVQ4c97YtxtGHa554AMRnxUYlNh+DyD9BAUgjeIbymgKbD7HhQsZLqGNuBC5RtMBX+8owLw9xgxt4AQl0trnjwpW4SYzU/nJuBm5GiunKug9ra4P2QEOLW/Ec8JX8MeSJVG8WaCp0wjeeNHs+iJ7rnxNJnTKWBSpsaiHli1avvPwkceil06Xt5RyBCg
 EZAffcKS
 obFXloJtl/nsHzFYMKnRCqbgTTUi8ZknklsmXtAWXdXDUHKM51a+2yyiDlZVvlN5dxOCcn661zncPOPihf4UNfo6AFXZBZaqtrFFk5PVPKXImEZxpIj/MpI+RtlRzm19ZtC8jML5fM056i879Gg0uejnj1n/R5WQBmZtaRCRkyt/KigNIdXzE69IVA/HyJxQ82R/nZobsvzB+afr+dqygLMC/XrA/TUsbib1RGhGEtblsodU1F2T/Fk3hIVLLS0OEi3btXQoF10mstVdjFz2h05BTe8UF6idgzkMgEEp4/paO6n0pPh0jc5kSQmdaHlBe3tjjTVG9jbJSv1FRe5m0wmw006vLZAkVY5d/klGGlTvdl2NsquTGUEzna3GMYbFFoWjp3rgNe40Cp7txevB5sGnuoLmRhe7Rd1KHh1hGMUEQnUtEziBRquGw1A3GnicxKAQ1rEjfmUXnvw2S8nItwm4Okf0/ilOGiIE9dIlO+QcmdKUdmA8Q1eOfW8RtE43nWs9qHsc6cdU1jfyBUcg4mpurTbWklDEW8mrVciXP5+Q9rsOnIpKpoS3Fue/5UKr8Al2jCX95vuKDUU6b+hDMVzdN//cVMSVpFAbtbmeobi4kxR1FwJilRDfaqfBRUd0PKeoG6qbxw/oGLOeLozewbSagb6Pikrshhwug8IMJEprL2TCdfF0MMsGE9fr0ruwFjRJBQsNg6ZeVMTNF1U74e0HMcOxGrGTBYwsBBH16sKCKrX5kyQ7zyeOgx95XxPK9UMqdKizJKJ+RhtgPgxQbZe+lxettBFSdJ+oafsyU73IOAMvW5OIi6EDXcBj+YyeF1cmKSKmoy6D5buDmdbD+qFpkpU3gfQpLpibcBdL41s5MYST5BrUAEKCrnFF9bhjrhJ9rY83XGvEyHXcEQXwjF1cTK9TdmGSH+aLFhMieyYMBi2+g/JajhGxpFetNHsE5a1USi20GhCtnJ3nNZ22zQia9Qs2l
 6w9MBXlw
 7sVcvoaE55e93cioV+SZ1OrtJNNwRZKsL4dhhzLbP4XyWJlnsVwA7R6p1DtVgcJqmXtQXNKaIgvmQ1krSElihOi2kU5ueJXpvIBtlln4k5qpBknfyd1WNrmYg8E0u/4KYyQ8SMbDmB469129PWBbYNSY/TAyYgUN4QTiDj3kq96YyiJD3Vslqj7jFsBYcJXHsMGUAssVYiwEj+InF96F5xdWQXRNLrVsTCxH6nfCK2dr23zVviGs+c8rbkclnt3xN3kl1LJ/x7AN7IhmKpZ2RTPKJ9Su20zfEWVGnxo9kRjDbxXDjSf/SCWSg0KSZi+EBC3knfKZu1LSFhk6BTpxv0Imnhr86uC1FzEPeuXXUPAOfxa6t/LI0U3kjn0XVWfOeoWmw5y0k/OxyxU+om+Z1Z+1s6qnLXu5qixg7Zrggeg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> * syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com> [250822 00:15]:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    be48bcf004f9 Merge tag 'for-6.17-rc2-tag' of git://git.ker..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=136dfba2580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=142508fb116c212f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
>> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107a43bc580000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/24fd400c6842/disk-be48bcf0.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/59146305635d/vmlinux-be48bcf0.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/b3e5f65cbcc8/bzImage-be48bcf0.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
>> 
>> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6029/1:b..l P1208/1:b..l P6031/3:b..l P6030/1:b..l
>> rcu: 	(detected by 1, t=10502 jiffies, g=6285, q=421 ncpus=2)
>> task:dhcpcd          state:R  running task     stack:28896 pid:6030  tgid:6030  ppid:5513   task_flags:0x400040 flags:0x00004002
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5357 [inline]
>>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>>  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
>> RIP: 0010:unwind_next_frame+0xfe7/0x20a0 arch/x86/kernel/unwind_orc.c:664
>> Code: 85 80 0c 00 00 49 89 6d 40 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 56 10 00 00 <41> 39 5d 00 0f 84 10 06 00 00 bd 01 00 00 00 e9 de f3 ff ff 48 b8
>> RSP: 0018:ffffc90003cdf6a8 EFLAGS: 00000246
>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc90003ce0000
>> RDX: 1ffff9200079bee3 RSI: ffffc90003cdfa70 RDI: ffffc90003cdf758
>> RBP: ffffc90003cdfae0 R08: 0000000000000001 R09: 0000000000000000
>> R10: ffffc90003cdf718 R11: 00000000000121e6 R12: ffffc90003cdf768
>> R13: ffffc90003cdf718 R14: ffffc90003cdfa80 R15: ffffc90003cdf74c
>>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:548
>>  slab_free_hook mm/slub.c:2378 [inline]
>>  slab_free mm/slub.c:4680 [inline]
>>  kmem_cache_free+0x15a/0x4d0 mm/slub.c:4782
>>  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
>>  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
>>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
>>  __vm_munmap+0x19a/0x390 mm/vma.c:3155
>>  __do_sys_munmap mm/mmap.c:1080 [inline]
>>  __se_sys_munmap mm/mmap.c:1077 [inline]
>>  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fb13ec2f2e7
>> RSP: 002b:00007fffe10fae78 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
>> RAX: ffffffffffffffda RBX: 0000562bd1443510 RCX: 00007fb13ec2f2e7
>> RDX: 0000000000000002 RSI: 0000000000004028 RDI: 00007fb13ea1b000
>> RBP: 00007fffe10faf80 R08: 0000562bd1432470 R09: 0000000000000001
>> R10: 00007fffe10fadb0 R11: 0000000000000206 R12: 00007fffe10faea0
>> R13: 00007fb13ec42000 R14: 0000562bd1443510 R15: 0000000000000000
>>  </TASK>
>> task:syz-executor    state:R  running task     stack:27632 pid:6031  tgid:6031  ppid:5870   task_flags:0x400000 flags:0x00004000
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5357 [inline]
>>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>>  preempt_schedule_common+0x44/0xc0 kernel/sched/core.c:7145
>>  preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
>>  __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
>>  _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
>>  spin_unlock include/linux/spinlock.h:391 [inline]
>>  filemap_map_pages+0xe15/0x1670 mm/filemap.c:3791
>>  do_fault_around mm/memory.c:5531 [inline]
>>  do_read_fault mm/memory.c:5564 [inline]
>>  do_fault mm/memory.c:5707 [inline]
>>  do_pte_missing+0xe39/0x3ba0 mm/memory.c:4234
>>  handle_pte_fault mm/memory.c:6052 [inline]
>>  __handle_mm_fault+0x152a/0x2a50 mm/memory.c:6195
>>  handle_mm_fault+0x589/0xd10 mm/memory.c:6364
>>  do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>>  exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
>>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
>> RIP: 0033:0x7f54cd7177c7
>> RSP: 002b:00007fffb79a5b40 EFLAGS: 00010246
>> RAX: 00007f54ce525000 RBX: 0000000000000000 RCX: 0000000000000064
>> RDX: 00007fffb79a5de9 RSI: 0000000000000002 RDI: 00007fffb79a5dd8
>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>> R13: 00007fffb79a5c48 R14: 0000000000000000 R15: 0000000000000000
>>  </TASK>
>> task:kworker/0:3     state:R  running task     stack:25368 pid:1208  tgid:1208  ppid:2      task_flags:0x4208060 flags:0x00004000
>> Workqueue: events_power_efficient gc_worker
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5357 [inline]
>>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>>  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
>> RIP: 0010:write_comp_data+0x0/0x90 kernel/kcov.c:240
>> Code: 48 8b 05 db b4 1a 12 48 8b 80 30 16 00 00 e9 97 05 db 09 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <49> 89 d2 49 89 f8 49 89 f1 65 48 8b 15 a7 b4 1a 12 65 8b 05 b8 b4
>> RSP: 0018:ffffc9000441fb50 EFLAGS: 00000293
>> RAX: 0000000000000000 RBX: 0000000000040000 RCX: ffffffff89ba2a52
>> RDX: 0000000000040000 RSI: 0000000000000433 RDI: 0000000000000004
>> RBP: ffffffff9b2c41ec R08: 0000000000000004 R09: 0000000000000000
>> R10: 0000000000000000 R11: ffffffff9b030610 R12: ffff888031800000
>> R13: 0000000000000433 R14: dffffc0000000000 R15: 0000000000001770
>>  gc_worker+0x342/0x16e0 net/netfilter/nf_conntrack_core.c:1549
>>  process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
>>  process_scheduled_works kernel/workqueue.c:3319 [inline]
>>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
>>  kthread+0x3c5/0x780 kernel/kthread.c:463
>>  ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>  </TASK>
>> task:dhcpcd          state:R  running task     stack:26072 pid:6029  tgid:6029  ppid:5513   task_flags:0x400040 flags:0x00004002
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5357 [inline]
>>  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
>>  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
>>  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
>>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
>> RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:80 [inline]
>> RIP: 0010:__orc_find+0x7e/0xf0 arch/x86/kernel/unwind_orc.c:102
>> Code: ea 3f 48 c1 fe 02 48 01 f2 48 d1 fa 48 8d 5c 95 00 48 89 da 48 c1 ea 03 0f b6 34 0a 48 89 da 83 e2 07 83 c2 03 40 38 f2 7c 05 <40> 84 f6 75 4b 48 63 13 48 01 da 49 39 d5 73 af 4c 8d 63 fc 49 39
>> RSP: 0018:ffffc90003337648 EFLAGS: 00000202
>> RAX: ffffffff914e0dd8 RBX: ffffffff90c5215c RCX: dffffc0000000000
>> RDX: 0000000000000007 RSI: 0000000000000000 RDI: ffffffff90c52148
>> RBP: ffffffff90c52148 R08: ffffffff914e0e1a R09: 0000000000000000
>> R10: ffffc900033376f8 R11: 0000000000011271 R12: ffffffff90c52170
>> R13: ffffffff82127173 R14: ffffffff90c52148 R15: ffffffff90c52148
>>  orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
>>  unwind_next_frame+0x2ec/0x20a0 arch/x86/kernel/unwind_orc.c:494
>>  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
>>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
>>  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
>>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>>  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:405
>>  kmalloc_noprof include/linux/slab.h:905 [inline]
>>  slab_free_hook mm/slub.c:2369 [inline]
>>  slab_free mm/slub.c:4680 [inline]
>>  kmem_cache_free+0x142/0x4d0 mm/slub.c:4782
>>  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
>>  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
>>  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
>>  __vm_munmap+0x19a/0x390 mm/vma.c:3155
>>  __do_sys_munmap mm/mmap.c:1080 [inline]
>>  __se_sys_munmap mm/mmap.c:1077 [inline]
>>  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fb13ec2f2e7
>> RSP: 002b:00007fffe10fae78 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
>> RAX: ffffffffffffffda RBX: 0000562bd1443f00 RCX: 00007fb13ec2f2e7
>> RDX: 0000000000000001 RSI: 000000000002f6d0 RDI: 00007fb13e9c1000
>> RBP: 00007fffe10faf80 R08: 00000000000004f0 R09: 0000000000000002
>> R10: 00007fffe10fadb0 R11: 0000000000000202 R12: 00007fffe10faec0
>> R13: 00007fb13ec42000 R14: 0000562bd1443f00 R15: 0000000000000000
>>  </TASK>
>> 
>> 
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> 
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>> 
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>> 
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>> 
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>> 
>> If you want to undo deduplication, reply with:
>> #syz undup
>
> Let's see if speeding up the debug helps.
>
> #syz test:

"---" does not look like a valid git repo address.

>
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -648,6 +648,7 @@ void validate_mm(struct mm_struct *mm)
>         struct vm_area_struct *vma;
>         VMA_ITERATOR(vmi, mm, 0);
>  
> +       return;
>         mt_validate(&mm->mm_mt);
>         for_each_vma(vmi, vma) {
>  #ifdef CONFIG_DEBUG_VM_RB
>

