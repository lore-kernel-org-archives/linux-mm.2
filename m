Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82FC6F3026D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 18:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44106B0093; Sun, 15 Mar 2026 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BC46B0096; Sun, 15 Mar 2026 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9729B6B009B; Sun, 15 Mar 2026 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 857826B0093
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 14:37:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2423B1D380
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:37:31 +0000 (UTC)
X-FDA: 84549155502.12.7591A13
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf17.hostedemail.com (Postfix) with ESMTP id 75D6740006
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:37:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3aPy2aQkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3aPy2aQkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773599849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=1Q3XCO42nOkqTUqTNl+vHMDdRVXOogorZ6E04CyeEUY=;
	b=oHYZCVrv2IrWXUnlAizuZwwDhPKCGeq91DJZUp6a0FqzmuZOVKBj5eWGjvb9Vgxwc3oksf
	xsxkoJQggyWiFe97WEelRip2dxGKJw3GXpb2ek3SoRX1d2ecIZ6FlnZtgwrjFI2s1IyzDG
	bxNljf2JAbh2fVgqM9A0geQ2yXW4DMQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3aPy2aQkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3aPy2aQkbAJEDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773599849; a=rsa-sha256;
	cv=none;
	b=kclndMMXJB9L5ROfxN3XOij/MLxafG4jgasreetgbJkS7NAAP6h396ecbVKZk5ah7ZxNzm
	8I8+64OVbTX/8yfV1Dj5w6B3tMFDEYJ07MOZ6awKDny7NRTWHgSmE5MVlZUygT7vmHY5Z7
	6o6E4k7f+8yt2QmNoEj5h5bAOrp4MaQ=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-67bd1b317dfso72809446eaf.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 11:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773599848; x=1774204648;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Q3XCO42nOkqTUqTNl+vHMDdRVXOogorZ6E04CyeEUY=;
        b=WeU2aJ9cKvA0p6OQBiSpRKB56/M2vdQKhVDpyvRRL3djjudY8gvyPgIJ36CkgOzd5O
         F2xj0f2Ni1VbrgLbwV9tEKgjNDLD7RKOIoadukdilz51fe/v17ub4PZEbNCcoY49eYfC
         v1uZdLtxpIiBvBl1k5sEimzxBn6CZw1YzVExVHEFNJGOsbnGLf9evEw+YEtcrE2lEOrI
         N1xrpVfggcJHnSQIc9d717uA2owJtjKrpAvBEFY+LR9Uyvt/iNIL0o4uToOQIrUpKv51
         Bm6uO7kz0oLe9QgPD7a4pY7eeGEuZC28pgYGS78HzOP1mb247D0WogjHovqyNsNLB+9o
         L7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNeIy3cJYlSEQjkzYzREYLdW33CaOgGinNDEsF+RJDIq4O/eh5okF3vRTQ/qjfN+rWkau8jaBilA==@kvack.org
X-Gm-Message-State: AOJu0YwOM5mY0iGMFKs0FxUIvavq4Sd/zI7F9FMQRDxE7NFwieUzU4e7
	K2OrgzmgEXKyKqi6mc8JplWga6CAMiuS0XZGp6njdKUYX0bL3SZ/cMSx1KVX8eV1jmlw/k47IfG
	I2FzAMN48oVpfUuXEniOvHaVwlYbWxPie4nWx47ORw3gej6Ufp9WBXRKMN5Q=
MIME-Version: 1.0
X-Received: by 2002:a4a:dd92:0:b0:67b:dad6:dbdc with SMTP id
 006d021491bc7-67bdad6dc6dmr5013569eaf.55.1773599848438; Sun, 15 Mar 2026
 11:37:28 -0700 (PDT)
Date: Sun, 15 Mar 2026 11:37:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b6fc68.a00a0220.3b25d1.001e.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in mfill_get_vma
From: syzbot <syzbot+c473aa669b5e8a6f48d2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, peterx@redhat.com, rppt@kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kpa1adf9us3cg9zhusisbxpy4mj9x3w4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 75D6740006
X-HE-Tag: 1773599849-593653
X-HE-Meta: U2FsdGVkX1/a5JCE/ApH3o2r4LBYmfFqCy8ojqDZVwNHiAjd+ncB+B3ArG0qwwLjw2chbC1sEyofjyAGU4LgAliSWDVqpmLcyXtOz4790ogB2mw2bz0se6fLetDfW6Lnmoy47VBvuw98yfBJy+P40EfNZJOhyVRInL4ydNOe2t7qB9gzBCngPRRZ+VzXnoaoo2K3sZUE2jzlwi7BzrTkBkxexAq3jggRo8OBBYqQOISQnrX178K+zFYnUJbYT2jK7c9gEJ0Yvsplsz0ArKxGSns9B2FM35Iwd8JWF1nPYwrVAaIDxaV72owxc0BFgHKQp6w6+9QYYWH2d2tcz/S+Lu3rzA4QhQSkWB0vIo7TxBYk0szZC4pOnZWhWs6BKj4k4Kpkd4f3Mfa6C2jYIDJia5tkwPaa5ftrOT6ZTvqSBXiHwkrSaiozakYGvAXSpwb8F1e7Kuk9KrV4wmcUSkHsMx+jeQrisAryX8BHO9kPQnYjTEk+WlLrpBaLr+0AbkSKWYbcWDoZXDwNYZjTooStOrbDY41PLezYSEsrmEa3Ddfx5GxcsN+0UTk8V0z5d5QGUBXyaPjEDSViEzt2rkAR6aGrrKTj7jFhNc7GxqJs+fE5ZFVSAOUwghTZYVnXgCj8y4FVhV2y84wrvkH17tPMunX7ao0Mq9axGrGD5NZZ0001Ytmi8CaLAm7x6fLsIWyTr5c564+6SO4Y3tdT/HbmlUEbQ2GDeNVLjsZBbtqIZVxLCMyqFi2ljp2ToC3SBn4izyob6CnIq9LY7wa2Pe0iMxgRA679CQmAfrbT6SiSuxEV3JHb5OFbiS9Cwl86Pr3nQgpyrXNE9M5lsmJlQA0rD5/LIzDTAaHl4XkAy/EwLtx0YtaZb63Ij+0CaNEq1t6PGII/mN6Tvva+vObSEbHFEJSY+gmxPkFwIAcPC3FBJcEQ8eIMBRVm8ED6+lJJj5yg/R31z6NzCLD/OGzpskO
 EyFRlkyW
 seRnapAnWYCUIGDPnMFDog8GvsDXTlWQ4bR6JiC34B6cJGzeaAU9HFEw7m5BZ/EBPbZ7S0QjJeZHoW/ZEDmsQACFYQ0DmNGpEXNI5nB6I22QQjm9nZmgaVSShE//eon9k4aE4cZxkW1EJCoXMfyR1q/V1PZLqZUaGYyD++O+ld9MrtoGkd2uwCL8Hyo2OHEfIqpVBGtw8lqesF3oIq2SfFh+tGlWPqNH+M0o8iJnYZ73tnfe39D9j4V4eaGwlNMOkGqwrYoCpdtWoBRvKiz8PkVIhVnSrbMesQW6UgKyChKxBc/Er4yZSkSoUPNy1RNTobwekynLIB562Ujkx5AoY/v2qG4zI4GD8RUWGVh01LAzoVP5SDFTCyibFLQr+GFCVTN/rzwQjP30NtjXvNe3besfQvQVfAeFB2EKidaqYaVRTgx4Q86/YokQc6V/uGBymxT1RIxkAyYZ6IRPvoeeIWaPeW5IwaZ5hsQC2h/wPZ/kEk9XomHqe/GKGNI2jxLlQdd2O5KFn7OAxNDp2iYQnx5IJfMW0dK+bNvTyg+g6nbpKoDQW2Uo5UqMeMuz8etvr5r01ZonnQNQ1Hkv79fPc67XjF/YDI9XbrUGeNYLQAvmdP4psBx8QO302cxkcNG+sndjt3PNkq9JGjxS0aNY6Mvy3vvDWY3cRsYPtnNnbapL2NUDIwMTJ7x+7nNXuAIgLKszN4vq0ch+ogO0UIiA4eeVg+/T3Nky/q/6hLCIsQX5bWNcxvqkgGBoUtnmD7Jr2hFoFe+ZRaqXPABITWXzf/amftUa2zt2HlJkAWgxQTpYXU9uem8szbJ3n3S6fHz5RyJEwQQQDwwOTAzbGsCE43rKhGOKZKg0Kw4rIfC0/VrplP6eoXHjulTVk2Uh2PqxBaW4bk9c8ksDa75kd22UEOl/IgaQ0fVvlzVmzIHEPSOZ6LSiQ6Y2ypAGfpOCrdShEUI5ofIORYZ3p5d2IAPVb0wCGeDwe
 0G1nYy0Y
 lhqDMNcV8kIn6QHdcD43bEBVLp0qZ97f87qnn3qZBZfNyvtapUEMY3Wc78tUP2nyUqwbdEiKfPp2dw8nPPk5UxVDNGBcCyFTI/y9/q5VNvjHZv4bO+TXchsy8cc3coHClwST1B/7i74WRnnWgID+r2eiOYTDzzbGEcfGCjVo31VOWIxHQCZjeuh/c3ae99b4SXoF/5BMtor/rCkU7I8wIjK4iMsNa6Wz2sxD069QT8lhjj/KvICbsjRz05isbC4eGXSfP2p1yhN75gqhN8iQmF3vj82IsHoB1+q7Y092C3fx3G8iaNVBDpeOBfvfry/MOXj2DIUfEaAZNnX+2fHFY2jhWI+1l9/FlzEv0YnuZg/mtE4IgMMuN0h4T1WgH1zoJFGw42bRU9wTLtcXvVF+rO/+awj3AAOs7LGis4a3gss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=131ab8da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
dashboard link: https://syzkaller.appspot.com/bug?extid=c473aa669b5e8a6f48d2
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126c98ba580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1644a2d6580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/09145161a8a9/disk-b84a0ebe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b64c254e474c/vmlinux-b84a0ebe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a7c33f5f7f45/bzImage-b84a0ebe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c473aa669b5e8a6f48d2@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5990 is trying to acquire lock:
ffff88802caef3b8 (&mm->mmap_lock){++++}-{4:4}, at: __might_fault+0xaf/0x130 mm/memory.c:7249

but task is already holding lock:
ffff88807cdbccf0 (&ctx->map_changing_lock){.+.+}-{4:4}, at: mfill_get_vma+0x162/0x660 mm/userfaultfd.c:226

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ctx->map_changing_lock){.+.+}-{4:4}:
       down_read+0x47/0x2e0 kernel/locking/rwsem.c:1568
       mfill_get_vma+0x162/0x660 mm/userfaultfd.c:226
       mfill_atomic mm/userfaultfd.c:900 [inline]
       mfill_atomic_continue+0x189/0x12c0 mm/userfaultfd.c:974
       userfaultfd_continue fs/userfaultfd.c:1806 [inline]
       userfaultfd_ioctl+0x232d/0x4c70 fs/userfaultfd.c:2071
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (vm_lock){++++}-{0:0}:
       __vma_start_exclude_readers+0x28a/0x940 mm/mmap_lock.c:125
       __vma_start_write+0xdc/0x290 mm/mmap_lock.c:148
       vma_start_write include/linux/mmap_lock.h:303 [inline]
       mprotect_fixup+0x5eb/0xa80 mm/mprotect.c:768
       setup_arg_pages+0x565/0xac0 fs/exec.c:670
       load_elf_binary+0xc5e/0x2980 fs/binfmt_elf.c:1029
       search_binary_handler fs/exec.c:1664 [inline]
       exec_binprm fs/exec.c:1696 [inline]
       bprm_execve+0x949/0x1470 fs/exec.c:1748
       kernel_execve+0x844/0x930 fs/exec.c:1892
       try_to_run_init_process+0x13/0x60 init/main.c:1514
       kernel_init+0xad/0x1d0 init/main.c:1642
       ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (&mm->mmap_lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
       __might_fault+0xcb/0x130 mm/memory.c:7249
       userfaultfd_continue fs/userfaultfd.c:1813 [inline]
       userfaultfd_ioctl+0x2372/0x4c70 fs/userfaultfd.c:2071
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock --> vm_lock --> &ctx->map_changing_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&ctx->map_changing_lock);
                               lock(vm_lock);
                               lock(&ctx->map_changing_lock);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

2 locks held by syz.0.17/5990:
 #0: ffff88807c119d08 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0x500 mm/mmap_lock.c:310
 #1: ffff88807cdbccf0 (&ctx->map_changing_lock){.+.+}-{4:4}, at: mfill_get_vma+0x162/0x660 mm/userfaultfd.c:226

stack backtrace:
CPU: 0 UID: 0 PID: 5990 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
 __might_fault+0xcb/0x130 mm/memory.c:7249
 userfaultfd_continue fs/userfaultfd.c:1813 [inline]
 userfaultfd_ioctl+0x2372/0x4c70 fs/userfaultfd.c:2071
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f478759c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcc2bbac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4787815fa0 RCX: 00007f478759c799
RDX: 0000200000000080 RSI: 00000000c020aa07 RDI: 0000000000000003
RBP: 00007f4787632c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4787815fac R14: 00007f4787815fa0 R15: 00007f4787815fa0
 </TASK>


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

