Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1145DC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 07:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806286B009A; Wed,  6 Aug 2025 03:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7516B009C; Wed,  6 Aug 2025 03:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC806B009D; Wed,  6 Aug 2025 03:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5896B009A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:43:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03B1111516C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:43:40 +0000 (UTC)
X-FDA: 83745543042.12.BC5F48B
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50CD818000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 07:43:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3qgeTaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3qgeTaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754466219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=uRGuKT6QrKliWgsUCET6ezjgzIPpJgz36J4X3QKXBxI=;
	b=rdp077J2HLSDXO3hCIID8bpFllkQ5XN3xYzAEI0PgX+UuDnmAah8rXWHGHJn1/o6Am1rqq
	tCOFWAP61csO6bECuwK9YUx8jdEwxGPy/LIbmgaASSents9bcEEbLbpx234NvCh+41fdNp
	blW1Q1qALBRaarA/NlmbLGRRw++Sfww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754466219; a=rsa-sha256;
	cv=none;
	b=BMdS2iVyk0Z7gBUQD0TA1htd7quYJ/2Ax7csdEo+c9w+8rs28E/Z62xHAIsH9JPBFejuRl
	Jgmr0j28tOVcCUfYOQDR/2/C9SKAoxVO3T3VAZZLdyUIw4Pkl8/0Xcuja2ZKbCd5HLznTa
	NYYuX04J7Qu660gh+uvN922+uDUaiVs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3qgeTaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3qgeTaAkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-881776a2c22so711051939f.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 00:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754466218; x=1755071018;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uRGuKT6QrKliWgsUCET6ezjgzIPpJgz36J4X3QKXBxI=;
        b=Sf2wXD7J37HtO48VGEZFKFFQSlJfxWWeUPePGBl9ZM01NYZ83PLXCs1ogJSQn5cn/z
         obRuoyqVgEQmraAQGF6Gta07NzjOFSHmvHJWtXi8wLW++ZzD0+D6+UfAiot++sNcbPMN
         W1y1qCuf6k7nQHZd3e4/tZJkDHeqZqyGcRvDtm8aMmSD7AerSP77uGBWZCGUy7IeRSyS
         AT8dY9mAGe+x95gndtxFz1neMrwXKUZZ50ewnS3qkf4ayAnhqarX5PFJQCHvlA/fvvai
         QZdw1cLDqTzUcdekGzFAFIMgzY2ATK23nRITHzYgJBPdeqG4yIsoHul2k7I8f895+QIp
         vJRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHQ3tbur1AZE80peyR+ccy0+x1XMNC5I1Dhvjf9Voi+Uikk1yw00+0SLfZqMyEkBFLCk/sdTRiNA==@kvack.org
X-Gm-Message-State: AOJu0YwCws+HWqD5EkmSY5WUCSvIWCfzJNqZrSaP8uJOkN3BfSIEbqRj
	+xr3ENxQ30WaUMrooZb2GzJJGus4Rz5w1eAcgcGlvPqOLgrihtBbhdDFSl+NohzNikG9IWnq0x2
	HK3pdOYw6cGE7CZU3h4rYVeWBlShRti4Oc0V4oeUzzktccseOdp7nhY+rVq0=
X-Google-Smtp-Source: AGHT+IFssaKUpcvjB89EazSePj/sDisMWSpwHZ2yGmOn3v0iZWw+w8izZFUWIAQleFm1s54vcLfKjBSPYWpQ3QSUeSOJGKUJh0VT
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6b07:b0:881:81b7:1058 with SMTP id
 ca18e2360f4ac-8819f070216mr352963239f.7.1754466218392; Wed, 06 Aug 2025
 00:43:38 -0700 (PDT)
Date: Wed, 06 Aug 2025 00:43:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689307aa.050a0220.7f033.003c.GAE@google.com>
Subject: [syzbot] [mm?] general protection fault in __pte_offset_map_lock (2)
From: syzbot <syzbot+45ad2baf16fce6bc81f3@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 50CD818000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 19ph5uqifgngx5hc7pw3n8symqdqkiuu
X-HE-Tag: 1754466219-115082
X-HE-Meta: U2FsdGVkX19MRpqmeUEzGzYNmZJbxDttHO0Qon3mun0AJacS+GBgxEVYHZUyURAUrqpcFW6TaRLSt7sRZNgP+7PIq+WhSXwnNZmCqlUHsMmtWlyYaHN4RJSKSkEt1Tk4v9QH/TDxU3YFv9CaNFqu99EquD+pd5x3XE4GEgD9+5l75lTdHPAlchqDxoTwV8ubByh38aZ8RGZahRSUc8TIfgZA5y6s37THpZdO7bF84gNxBcvjCLIyzxWyHEliBjbxCHvpis8cuZ+vCz3UIPn/I1low3Jo7Zo4SNqNZTWc2dqpfHGgf1mP1MLHJLHQaC0KgccpIwWO66R1WV+DPl1AyP5c7F/2kTJ2uoYEMMSmdHaQBTHh2/RnebuFh63/xKMPRAbuCB3+HSddMDAt8Qa8/hTkencF2hMPhqTixFl4pje71L79xbuGwbrbITqB5xWmlu6iI/995HxZAvf5x2TYvd/W5uxITfWdTzmBpIrMCvAR5uBaqgFKmUd7tRZaEJexcbbzhj4m1v4X+85gHwSi4e2ATJmxLHUEkCmmJTeuE8uP+EAgUTcyk0k6s9nkNKDgYrFO2pW7IARJ0VQ5dd09DSRQzKNIS0Y/6e2YLH4UbeZE5YFR4204dhzwVbh1Qh7YbSW0vBx7cV8Grgjgc2CgWDe7h/nwHql8Muoj4PCLVmSifuqPwdKAH2QhA0jPxFTu5W40LHwt9+tC4squaaDAWNQumduqj/QP8VJ6zUs8h1JI5c8sghXsSwdPoMtLYRdUf2TZDZf9D5kgHQRKgUPHYXEu9DCg5AAMgUEXlG72tSZEAf9pnh8ucAQAzA+cL50NH+2BNzcntP5t21IUkz7xH7H8EOkbf7KCch673CTF37DV38vIiPq0199ede8TOk5T+ugtjVZKVf5keQYxoinJaIaQUgupMkdVtYcLhRTUasMs7/wFDVIWGt2Rs+ulL2MhPuPnkeb9M4zeZufr820
 Di4h8lX+
 dBpAo7QHatEjJMiuTHyc646XSR0O9qZyVC5AWhv9UsFAXWrWrmZzZoyQqej3BmE+Pw/JNZoXgJ4lkVkFj/iOJWsT2302qWC19GeHFiiQH9XkTfCgd1tWRh5k1CoZYfQuBZptnBbbs69nLzr+TZqz+K/dikVuBnqFIzx2zxYn6Y0a/syR6smZOepeqHbfCRRj/KiPETXsXFnUwRGb8WWIT1sJFKthHWVRJNlpJYJ71Cv+SxrQIrFy7uxMttW8OxxpnmLk9vJMJYh5zbufrZbG97HkgkidFJ0oxvmq8EsqKD8tNeFwck0u5L+AAkR0bmzBC1uTxwhT1/ckKrvV1Ww9vmiQzlvPJ5a8WOWpotbcAQr+1k5sscEHsxV0Rdyrk7uZyqq4/jp9E1VyU4NvlcOm1a9ahAcBBuLvhkMwwkJS5MIcxj+U52CgnGC4U1MiFY8eaD4swe2VkKm8hrJckkKtwduilJfeUZhmn7OUxA+3Ia7fbml0Tf2SSG2dwGfGm+EMbaCgNctz4xHsHPi3TKLuBJfneVOoCqIbHVnQQwoZAxw7NFo0x7eaXTVsORZ/hVIwMM601av//ONreGFk5WIs3o2o/qEAQOz+Ah2ArSckP2QHfYQNrmnkVrqNf9tGX1sXgHrUu0ZlVKaGius40VH4PKF+YsorYkOnHZNxED9UF7E67MNsNvjavPPbEwDNdsl0m0wvZ4NDXUcJ6hDCihDRMbooTViipM9OrVx2YehY31CPwC4gcOgsZgAk7T5H3dJNoyuRvr6m50aw3wTskt+sljlj0izUIsxOCTPWP8gzSLVU1KzPhu3A52RmXVWkZFEIsifcj3zhgD1pMhB7MPlrli4tnVK79UZ/Ne6wr2mvnpNcJB4wwMdkGUJW1LkO93pKoPs6CGe4XFz4iZ6Xkf2105dRSAo0CDI99F+1yIjCnCn9n6BlRF4zV2HOOOTk7vLLqhAOh4rt+09amfiXblJLny+f8dtwQ
 lLnsY++e
 p00SK5FzkjeoKvBCXh8QpNgXsnERdy4oZYNMDrbIzM6Fe7UyS+BI/8nKL+aPKmG78fQTI4GAw125xlWlriRPfmRrslK0pPt847KuJwz9hFQWYrWeRW1JMt0bGMuARYSxEZ+z7iKN3h1fSL2V6IGmiwKT/6UHWaMZI5n2ro5H3+A1ejzfwOnPq9Sna8QW6DRU6H15u94irL76MSbEY4dpdojJQ7kerP/d+KIIIMFdiBk4u1RkvlDo8m7epUESucn7aHcCXgLjrg4oSMllL1EmD19lYHHEQIFrTygSa4MuhP0m5G5WBKw7kZNnDFfstM+SptVLscMefHxEz8NyxVk45qZ5JWudM1NgxNL2zR1V1JLTb6Vu/f/JMCGUeXoj0OLOjAciibk3b+wTqxhb72sH1nNaSnOTplxN9vkdU/WdMhweojZKwIgoCOIIvatLIpf2NVbPAgo+e81qmEhYXCautwvsPMmQnMfdVnkbiXXS9yv3U/I3FXj+ACX0KUjs6RqS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5998f2bca43e Merge tag 'exfat-for-6.17-rc1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136cc434580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb90b5976661bfd8
dashboard link: https://syzkaller.appspot.com/bug?extid=45ad2baf16fce6bc81f3
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102eb6a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134d16a2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/616a65da77ea/disk-5998f2bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0f3838a6bd07/vmlinux-5998f2bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/298a57ed56ee/bzImage-5998f2bc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+45ad2baf16fce6bc81f3@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 UID: 0 PID: 6221 Comm: syz.2.42 Not tainted 6.16.0-syzkaller-11741-g5998f2bca43e #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:kasan_byte_accessible+0x15/0x30 mm/kasan/generic.c:199
Code: 00 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ef 03 48 01 c7 <0f> b6 07 3c 07 0f 96 c0 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffffc90003cdf6d8 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8b92232e RDI: dffffc0000000003
RBP: 0000000000000018 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8b92232e
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881246ce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3e8b1dff98 CR3: 000000000e380000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __kasan_check_byte+0x13/0x50 mm/kasan/common.c:567
 kasan_check_byte include/linux/kasan.h:399 [inline]
 lock_acquire kernel/locking/lockdep.c:5842 [inline]
 lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5825
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 __pte_offset_map_lock+0x10f/0x310 mm/pgtable-generic.c:401
 pte_offset_map_lock include/linux/mm.h:3029 [inline]
 zap_pte_range mm/memory.c:1712 [inline]
 zap_pmd_range mm/memory.c:1818 [inline]
 zap_pud_range mm/memory.c:1847 [inline]
 zap_p4d_range mm/memory.c:1868 [inline]
 unmap_page_range+0xacf/0x42c0 mm/memory.c:1889
 unmap_single_vma.constprop.0+0x153/0x240 mm/memory.c:1932
 unmap_vmas+0x218/0x470 mm/memory.c:1976
 exit_mmap+0x1b9/0xb90 mm/mmap.c:1280
 __mmput+0x12a/0x410 kernel/fork.c:1129
 mmput+0x62/0x70 kernel/fork.c:1152
 exit_mm kernel/exit.c:582 [inline]
 do_exit+0x7c7/0x2bf0 kernel/exit.c:949
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1102
 __do_sys_exit_group kernel/exit.c:1113 [inline]
 __se_sys_exit_group kernel/exit.c:1111 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1111
 x64_sys_call+0x14fa/0x1720 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f412178eb69
Code: Unable to access opcode bytes at 0x7f412178eb3f.
RSP: 002b:00007ffcf2965e78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f412178eb69
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007ffcf2965edc R08: 0000000af2965f6f R09: 00000000000927c0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 00000000000927c0 R14: 00000000000215e0 R15: 00007ffcf2965f30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kasan_byte_accessible+0x15/0x30 mm/kasan/generic.c:199
Code: 00 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ef 03 48 01 c7 <0f> b6 07 3c 07 0f 96 c0 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffffc90003cdf6d8 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8b92232e RDI: dffffc0000000003
RBP: 0000000000000018 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8b92232e
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881246ce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3e8b1dff98 CR3: 000000000e380000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	0f 1f 00             	nopl   (%rax)
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	66 0f 1f 00          	nopw   (%rax)
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 c1 ef 03          	shr    $0x3,%rdi
  27:	48 01 c7             	add    %rax,%rdi
* 2a:	0f b6 07             	movzbl (%rdi),%eax <-- trapping instruction
  2d:	3c 07                	cmp    $0x7,%al
  2f:	0f 96 c0             	setbe  %al
  32:	c3                   	ret
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	66                   	data16
  38:	66                   	data16
  39:	2e                   	cs
  3a:	0f                   	.byte 0xf
  3b:	1f                   	(bad)
  3c:	84 00                	test   %al,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

