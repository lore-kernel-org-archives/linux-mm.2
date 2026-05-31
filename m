Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355D0CD6E4A
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 02:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B866B00DA; Sat, 30 May 2026 22:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ECAA6B00DC; Sat, 30 May 2026 22:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9B96B00DD; Sat, 30 May 2026 22:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 560666B00DA
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:05:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7AB1A03EE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 02:05:38 +0000 (UTC)
X-FDA: 84826073556.26.819C815
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf24.hostedemail.com (Postfix) with ESMTP id 468D0180006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 02:05:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of 3cJcbagkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3cJcbagkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780193137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Ne4GzdzdnKm+4BhwlEFgMY6GWR7zMb3d/gEca9fJHag=;
	b=aWwojGYPJj3sbIKtZnHSxfSuvrhqsjpfDYZK1fUcqzQnpZ1+PzqV01/kTPnNH+ZjQkBpiU
	kbn+uIK2My5ZOmuJiSoDtnyoseLqKiA8egWdLV9fg3wzeXEmwSRZAzn+GiBwpSZyhbOWfN
	JvmL4nO/Wgzj/CpQzaiKLaaZ+21TrNQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of 3cJcbagkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3cJcbagkbAGUVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780193137; a=rsa-sha256;
	cv=none;
	b=VgRrtpUf6E9tmxR41JBLTxnAcYa1GanJX6YRkKAnfLkCqgiyciNW4D/kGDea6SOZ5D87PM
	A+u1KSSeXSdwQ5Pzlv3b0ForAXLYa/u9Dvw+TPs6TQbOEJYCwU508/bs4FQfVK+7AORw+I
	p3QauenV/49LrMnxrLb1bC3Dk++JFnk=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69e0757d642so887511eaf.3
        for <linux-mm@kvack.org>; Sat, 30 May 2026 19:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780193136; x=1780797936;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ne4GzdzdnKm+4BhwlEFgMY6GWR7zMb3d/gEca9fJHag=;
        b=eM0bTrTK9kTFuBTuOCSkIzaEsGDbcI4QZNtSKkLyGiCh28TsyO8xWUo0gS5AO3hZr+
         RybYReKhwwDaiDFCKtTL3MADj2B0ToIFl3KGbZAIgecXnsT8AyTxFvXro5Bg+A7i2QWW
         CXQszrQ+uCP5aRxYDU5rUSOsfJePdVPWT+46MTrkxdboqhJzyl5zZ//0T1pB1KtYeT2+
         rtdoS0PhMKUBvBpCccR3D+OfB4IB84EToG+pGWUr6zkWicOhdhuZz0pLh7OjPQnEcv9W
         iW1TmBIOBz/lW4Ju4D06bIISwJHNWcla7gUwsk8ltjTtMipAdS4VPbPIEm64GVQukxVf
         u1ew==
X-Forwarded-Encrypted: i=1; AFNElJ9kMbxuiu/AoxloraR7b+oLIbKqPGR5lj5/VGryyQtz9oV0khgsu2VFsx83II6H46gJ3i+Ec6P5qA==@kvack.org
X-Gm-Message-State: AOJu0YzZ4lcVO3zKv73aRG4EU7C4rJxx7PsiB3qf6k+FLoJmqJlmStos
	LxwBL3Zw+a/aHmrm9l5NYuBWtjepXARD1Y+F8pJbm0mNEW2JpQ1pZDiHno/5rAiMHgCjwqUTq6u
	wy7Swa9niJ7ht0/hSjpY9lVYgtjBtnrDAk897NGDBLgb2drRbgNUzTiSJ3bc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d0b:b0:69d:9e7c:cb67 with SMTP id
 006d021491bc7-69e103fb737mr2454780eaf.53.1780193136287; Sat, 30 May 2026
 19:05:36 -0700 (PDT)
Date: Sat, 30 May 2026 19:05:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1b9770.fd5edf16.2e7427.0008.GAE@google.com>
Subject: [syzbot] [mm?] [fs?] possible deadlock in page_cache_ra_order
From: syzbot <syzbot+8bd419f88e25ab12cb75@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 468D0180006
X-Stat-Signature: pucffjiigimkj9esyj96a5ryx7yu6nn7
X-HE-Tag: 1780193137-473341
X-HE-Meta: U2FsdGVkX19Yk7L+0Hb+QzhN7ONdIdhXq/Gptm2RiB1UwRQbqAmAeMeHjPHvXWmBIolaWquDQFn1zh03xAOuqx1RsK1VTdJDTnheD2r4mLXudBRzqCXW1UxwzT5eC2ojZ1VtwXGaiKN95QVOOgovyAcW1GtxRCQcHkn2QOa28PWsEhdLQ+wVl2iHBVlSqrBhb4IhYWsRnXOUcjcCLfysoB1JgwE68rqRivY4WMSSrUrMvsEohJw7djNznJwniortklAIJCM6rzgdWid/La5srfn+NINpitbL4Dh21oFqtEuK0ZZCeQIoJ2OpcIpAue9gSKljxrZA0E15FRhNumAoCpHpyo5dYZXyiQ5XXjct2isjaw00mw8anLMH2Tol5G6hwMi4Ryg/447GcNkiWLLbTX227bfPe3uuBds804jKNJLz6GTHdxsBEeeJIbbPuZSrBqFpRpMEAkpN4zwdPOMf7khMoDMp1IdZotmmw4+1RytoeM9MHKVvro6NzFqhcQZnKMvkWzAxfrZtSGmlzJpEOslQPrpdYJllEDTOH7kBXg0fsFbKLgsQbCF8qXij8fQfP7t0mv9+RraNJjvseEk+eZ/ZIjitUlX+vieCNCKUzgdE/L5y/i+TKsU4ID3cTLXP/bzMsNER5OkI9vCWF0cQlZ2RH9IGnI3/pQZoJj7I8DvasjrbsjegvlSy87R93ZIZ8hD6wHF/UyP588cBElHr8IlNpCFjn0jP4MuykHiKg8r1l7Ys1EcZuwRugeyBbyTM0I5ZCDXdGFrcRXjnW/8ZlWa7XqvWz4/aYXGu/L8qwlTnOQD9zYxIZholLDE20NArXYfUV6bN7Ol++P6OOOcxCrkVwOYPR90zXF/xfuzD8iRKjK6r9VccSynQSMrZKcrcWDs3LnLZk+4bKt5U/CqT0my3GppXHGhW/fK6mkYJlspD87GoLQ1KONX3i2ytRJRhA/5/gqqqCVSOvml2zhL
 CafD7yLA
 P8b2dzj64EFXZRbq/wGqy5eM9cB8l8ddaGZ6rHjmcKnCMhWSJYxMQcFIZgh3GuUUkPDQLR1TO6Bi2pE9b/1zEnLv50HHtHM4K5vST5V4rUNEzGw23eOab/jdIwOM5nHuBfyU1q3H/DLa2f+SnjyYs1tCfqty75cTE6J5Qxx5BCUgejd/vad0njJMG3d6pcuRcZlhgQQkxxcwoKO8sc/AGFqi9tlKeqzVqR3HWSdUdSSeQgTfU6sMMtDpiy50qBBpbnOwOT0gvrYOGGG7bn/MBaXNyYc9eizWKiGOu6he790aByY3HK6Fet2+sgW8cCMTNN/1Ys3hAXwjVSHNaH+Z2xIl1qI4wkZkaktEGfQGizum0e8AVM3JFgHKdBcboYspGX/um1GO5QU/06rj6wwjtBAaY/GBtOy8D9rpZ/9rENyvfFig85uq69TnJES3n8rWG04R1cgqBjXAOcwqpUTGNIDJBdBQkGrgmoXTZqTJizUsxgtr+uZur+CSFzGKcP23lcmBI+SeKW+WenFp162tZIGxU/w1y72iHAN3bTqaTACYx65yence3OQg0JHpqbSFxG00H+XsVrREl/m2o5+Uqr2iq2+V6oOM97i1QQ2MOzXkFwWh9cPO4azn6fbib7dUdBSoig1cItHDksRNbCz9AK6YZYGxCRx7KbJfYkF9MAmO0d3zs78/hirtpDCwqAqS7WDpZ1KRBxcDT9M5TUHc+klXWVDow1nunLOm3jGCc9vmJVYfXsDX+kDm33QO8u2tJNEhp2LSCIiXIjk9Zrk+BDCwC9FvQjAu64PK6ow2/88iukRbnszDHYmYQxf1lnlm6Eil6Wwppy2Xddz34G2bgAgHypny3xvI/S3JxEutswPKf/7g6+snBhT1v/FTCKdmq/Qj2/JE27+OdAIsfJUt5mwM6OoKx+slUESJqnbj8DMNL0zB1ZUSpsoe6Zh6jhGhDhQErrAs8Is1xJJB6S5t2AIN69eJB
 ysK1cgKc
 UiM9HHxTDz9sOcB3ZajDQW3iv7yaO4opTA7n1WopoDalsEsKeCd5N9so859Ke9zfCHGNBjRuYX3+ssER7jMFqqscfK/9s/MtSYvzsAgLaDtGHBJn8ySulbP10N3lDmh2hpj1xOQN1bn9bQmaLqBxgGXP0gXmvIRV8wL0xRjEl6Kqa/scIQqrIFON68tQesXEzYnIQOuf4jxUK0o2hED4mW9ktpxtXNSU/FnIsNkXx0+Av8+GMWLE58xykxvMw5CI5m0gR0uUdvrFjLK7uwDVQzDVVbI8Wcvu0YT5Bq8qY58ZT+Pny9ix5eG2j/3Bf1nZm3LAPjz9L5qU7i4OGkoBMVA9YE9ua7amksL+MnNb6Td0bwWk058pCQ0gNnAaIS3/C82ecEWotHZjrGo/Woghp1ZqZqSTIfkpxBYxl3vdot0Y9f73J3xuhjktNO0SNymkKeLq0BlCdCB4bl/+FtAbDhMRNCbzKEjR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e7e28506af98 Add linux-next specific files for 20260526
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1377f67e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1701da6552dd9b8
dashboard link: https://syzkaller.appspot.com/bug?extid=8bd419f88e25ab12cb75
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0060088615f7/disk-e7e28506.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bee8a0723af7/vmlinux-e7e28506.xz
kernel image: https://storage.googleapis.com/syzbot-assets/040209574106/bzImage-e7e28506.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bd419f88e25ab12cb75@syzkaller.appspotmail.com

loop4: detected capacity change from 0 to 4096
ntfs3(loop4): failed to convert "0080" to koi8-ru
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.4.188/6496 is trying to acquire lock:
ffff888062d66830 (mapping.invalidate_lock#3){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
ffff888062d66830 (mapping.invalidate_lock#3){++++}-{4:4}, at: do_page_cache_ra mm/readahead.c:349 [inline]
ffff888062d66830 (mapping.invalidate_lock#3){++++}-{4:4}, at: page_cache_ra_order+0x2b4/0x4a0 mm/readahead.c:562

but task is already holding lock:
ffff88803fd78888 (&ni->ni_lock/5){+.+.}-{4:4}, at: ni_lock fs/ntfs3/ntfs_fs.h:1214 [inline]
ffff88803fd78888 (&ni->ni_lock/5){+.+.}-{4:4}, at: ntfs_readdir+0x6c9/0xf40 fs/ntfs3/dir.c:497

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ni->ni_lock/5){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       ni_lock fs/ntfs3/ntfs_fs.h:1214 [inline]
       ntfs_fallocate+0x59f/0x1230 fs/ntfs3/file.c:543
       vfs_fallocate+0x672/0x7f0 fs/open.c:338
       ioctl_preallocate fs/ioctl.c:289 [inline]
       file_ioctl+0x64b/0x870 fs/ioctl.c:332
       do_vfs_ioctl+0xc29/0x1540 fs/ioctl.c:576
       __do_sys_ioctl fs/ioctl.c:595 [inline]
       __se_sys_ioctl+0x82/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (mapping.invalidate_lock#3){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3167 [inline]
       check_prevs_add kernel/locking/lockdep.c:3286 [inline]
       validate_chain kernel/locking/lockdep.c:3910 [inline]
       __lock_acquire+0x15a5/0x2d10 kernel/locking/lockdep.c:5239
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5870
       down_read+0x97/0x200 kernel/locking/rwsem.c:1568
       filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
       do_page_cache_ra mm/readahead.c:349 [inline]
       page_cache_ra_order+0x2b4/0x4a0 mm/readahead.c:562
       do_sync_mmap_readahead+0x698/0x7b0 mm/filemap.c:3409
       filemap_fault+0x790/0x13a0 mm/filemap.c:3559
       __do_fault+0x138/0x2a0 mm/memory.c:5421
       do_shared_fault mm/memory.c:5920 [inline]
       do_fault mm/memory.c:5994 [inline]
       do_pte_missing+0x65b/0x2940 mm/memory.c:4566
       handle_pte_fault mm/memory.c:6375 [inline]
       __handle_mm_fault mm/memory.c:6513 [inline]
       handle_mm_fault+0xdc2/0x14d0 mm/memory.c:6682
       do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1390
       handle_page_fault arch/x86/mm/fault.c:1479 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
       filldir64+0x2b2/0x640 fs/readdir.c:368
       dir_emit include/linux/fs.h:3587 [inline]
       ntfs_dir_emit fs/ntfs3/dir.c:344 [inline]
       ntfs_read_hdr+0x8fb/0xc80 fs/ntfs3/dir.c:385
       ntfs_readdir+0x98e/0xf40 fs/ntfs3/dir.c:545
       iterate_dir+0x3a5/0x580 fs/readdir.c:110
       __do_sys_getdents64 fs/readdir.c:399 [inline]
       __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ni->ni_lock/5);
                               lock(mapping.invalidate_lock#3);
                               lock(&ni->ni_lock/5);
  rlock(mapping.invalidate_lock#3);

 *** DEADLOCK ***

3 locks held by syz.4.188/6496:
 #0: ffff888037dde928 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x252/0x320 fs/file.c:1260
 #1: ffff88803fd78b40 (&type->i_mutex_dir_key#10){++++}-{4:4}, at: iterate_dir+0x29e/0x580 fs/readdir.c:103
 #2: ffff88803fd78888 (&ni->ni_lock/5){+.+.}-{4:4}, at: ni_lock fs/ntfs3/ntfs_fs.h:1214 [inline]
 #2: ffff88803fd78888 (&ni->ni_lock/5){+.+.}-{4:4}, at: ntfs_readdir+0x6c9/0xf40 fs/ntfs3/dir.c:497

stack backtrace:
CPU: 0 UID: 0 PID: 6496 Comm: syz.4.188 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2045
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3167 [inline]
 check_prevs_add kernel/locking/lockdep.c:3286 [inline]
 validate_chain kernel/locking/lockdep.c:3910 [inline]
 __lock_acquire+0x15a5/0x2d10 kernel/locking/lockdep.c:5239
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5870
 down_read+0x97/0x200 kernel/locking/rwsem.c:1568
 filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 do_page_cache_ra mm/readahead.c:349 [inline]
 page_cache_ra_order+0x2b4/0x4a0 mm/readahead.c:562
 do_sync_mmap_readahead+0x698/0x7b0 mm/filemap.c:3409
 filemap_fault+0x790/0x13a0 mm/filemap.c:3559
 __do_fault+0x138/0x2a0 mm/memory.c:5421
 do_shared_fault mm/memory.c:5920 [inline]
 do_fault mm/memory.c:5994 [inline]
 do_pte_missing+0x65b/0x2940 mm/memory.c:4566
 handle_pte_fault mm/memory.c:6375 [inline]
 __handle_mm_fault mm/memory.c:6513 [inline]
 handle_mm_fault+0xdc2/0x14d0 mm/memory.c:6682
 do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1390
 handle_page_fault arch/x86/mm/fault.c:1479 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0010:filldir64+0x2b2/0x640 fs/readdir.c:369
Code: 00 48 39 c8 48 0f 47 c1 0f 01 cb 48 8b 4c 24 28 48 89 48 08 48 bd 00 00 00 00 00 fc ff df 48 8b 44 24 60 48 89 02 8b 44 24 04 <66> 89 42 10 41 80 e7 0f 44 88 7a 12 42 c6 44 2a 13 00 48 89 54 24
RSP: 0018:ffffc9000e517aa8 EFLAGS: 00050287
RAX: 0000000000000020 RBX: ffffc9000e517e38 RCX: 00000000000008c0
RDX: 0000200000000ff0 RSI: 0000000000000a29 RDI: 0000000000000a2a
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10054a03e1 R12: ffff88802699c000
R13: 0000000000000009 R14: 0000000000000009 R15: 0000000000000008
 dir_emit include/linux/fs.h:3587 [inline]
 ntfs_dir_emit fs/ntfs3/dir.c:344 [inline]
 ntfs_read_hdr+0x8fb/0xc80 fs/ntfs3/dir.c:385
 ntfs_readdir+0x98e/0xf40 fs/ntfs3/dir.c:545
 iterate_dir+0x3a5/0x580 fs/readdir.c:110
 __do_sys_getdents64 fs/readdir.c:399 [inline]
 __se_sys_getdents64+0xf1/0x280 fs/readdir.c:384
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feadcacce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feadad1e028 EFLAGS: 00000246 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 00007feadcd45fa0 RCX: 00007feadcacce59
RDX: 00000000000000e0 RSI: 0000200000000fc0 RDI: 0000000000000006
RBP: 00007feadcb62d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007feadcd46038 R14: 00007feadcd45fa0 R15: 00007ffebb7a32a8
 </TASK>
ntfs3(loop4): failed to convert name for inode 1e.
ntfs3(loop4): ino=1f, mi_enum_attr
----------------
Code disassembly (best guess):
   0:	00 48 39             	add    %cl,0x39(%rax)
   3:	c8 48 0f 47          	enter  $0xf48,$0x47
   7:	c1 0f 01             	rorl   $0x1,(%rdi)
   a:	cb                   	lret
   b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  10:	48 89 48 08          	mov    %rcx,0x8(%rax)
  14:	48 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%rbp
  1b:	fc ff df
  1e:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  23:	48 89 02             	mov    %rax,(%rdx)
  26:	8b 44 24 04          	mov    0x4(%rsp),%eax
* 2a:	66 89 42 10          	mov    %ax,0x10(%rdx) <-- trapping instruction
  2e:	41 80 e7 0f          	and    $0xf,%r15b
  32:	44 88 7a 12          	mov    %r15b,0x12(%rdx)
  36:	42 c6 44 2a 13 00    	movb   $0x0,0x13(%rdx,%r13,1)
  3c:	48                   	rex.W
  3d:	89                   	.byte 0x89
  3e:	54                   	push   %rsp
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

