Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E963CFC51F
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 15:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8528E6B000D; Sat, 22 Nov 2025 10:15:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803276B0010; Sat, 22 Nov 2025 10:15:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718966B0011; Sat, 22 Nov 2025 10:15:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C62B6B000D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 10:15:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6C541308B5
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 15:15:26 +0000 (UTC)
X-FDA: 84138591852.10.1AF1CCB
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf29.hostedemail.com (Postfix) with ESMTP id 210D812000B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 15:15:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3jNMhaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3jNMhaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763824525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=AU/O7/Z0dqPQ9UvCKH8MGsukSiWCHv6ThrapqzKdzZ8=;
	b=eMByra4BC1z/XZgYTqGqecX34g57YPZVMNds873wQhE8j9K0s6pfgNv4zn7wM2NX3CI5PD
	4P5hxZQy2cfhQ7ovr7Ot7Za/mc+jYN/7AymIBUG9hdZfH6n+O3MG5e48trziqqOnokRi6H
	obpKJMGXDM2hbUFskTuHpQuTh9hWp0k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3jNMhaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3jNMhaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763824525; a=rsa-sha256;
	cv=none;
	b=PrGe34UwHN12YrNb4qB5boC19Wlf/uUN2fOg2k+VRVrY3naRLJBVBQiE0syxWk8WA0pZ1d
	0wodkdAaBPLAAZ6H9TOwMvAtFr9/howmWmXd7yenUGuBMEiKksCPq6FzLT+u+EcjFsYirI
	Y+Upqexp0+ojVz7MIJlEb/UO9fF4cHo=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-433770ba913so33155605ab.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:15:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763824524; x=1764429324;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AU/O7/Z0dqPQ9UvCKH8MGsukSiWCHv6ThrapqzKdzZ8=;
        b=pHqKjrtZRhKZJqLqKVne2BpO78+rt7owE3ONJam51CsG2vHtlJMFNq9piU+nSuV5FM
         SBBfoTM9ptHbZkoRc9xlMdBYT50epRSTT5rlYySNqC5Kg/xCntnx2FQZ1CThDBhDl4mW
         4TbbiSo6xpbkAzfkkkYj8WRhgPgNXz7bhrfhIm7G/pqe9g+bf/H5MmShQh9r800szV6t
         GwMpWbwg1nJAAPNFRUts7pMHJUiJl8a7DIj/Comvf8nfbqgfdYtMedZgKyc7bABHf0vU
         EsRdYWlj4hcy9ltTrZTMxtNxLezppgXuyHNUk+g8It+bdr+pFV/SP9Dtg46QbzBbxkFL
         z69w==
X-Forwarded-Encrypted: i=1; AJvYcCXfP1zAT61T24uP4KtGoj9R9ToyO8BKEA2DHsJLcgg/oDMt8goZa1urESQj6+2YH85lcrS0cM4/9w==@kvack.org
X-Gm-Message-State: AOJu0Yz73UlHKr3PygdSKq82PY9HO5Lh4ln2Ni6yfDP7inIn3YlciRsJ
	lQGGfzCEhbNBdx79cm5967tCABKeVEkvQ6aBYAcmLnG8sQfUu+jmTxdQTXyKy+zKiXdGCg22i3O
	kYbUShG/fguyiEG8IQz6i61RlCNSoyiiQi6lruy8AFvpw3yngsnoQS8f6IZE=
X-Google-Smtp-Source: AGHT+IHIFviwdQvavYW7rTJuBE9YhBXOLa3bnChirEIvAqejFgHji3eqKhav+qAycjvy+ONKIyY2jCQjB4L2HLqxTyWip3ZJ8WHP
MIME-Version: 1.0
X-Received: by 2002:a92:c24e:0:b0:434:70bd:8b36 with SMTP id
 e9e14a558f8ab-435b8e3d704mr53687375ab.7.1763824524199; Sat, 22 Nov 2025
 07:15:24 -0800 (PST)
Date: Sat, 22 Nov 2025 07:15:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6921d38c.050a0220.2ffa18.0009.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in qlist_free_all (3)
From: syzbot <syzbot+c2d8be6880c81b4308a0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 210D812000B
X-Stat-Signature: p7ur6qq9gkx7j16cbz4oxx4xfcptb6pg
X-Rspam-User: 
X-HE-Tag: 1763824524-646451
X-HE-Meta: U2FsdGVkX18fCHwwq8vraXFC1PCxICUdFMYmABagwkUs7eN7mj7utot2IHaflcHy89quSABkbu82wYqo3ZLQHnGZf5wQvBkjdu+IHuhdyeZEprolwbmsw5I2Ngw8udp5adGXSByZPsgMzFWr6jlYfoFi3T2HP6aDPpbEspKivqqbKgE/5w8euyEPDMtPNDZl/cFv7PSQvcOuOxdbKS5qsSJ5qy48osuP+v++VRpn5lnHbLvVexkOGoPNEAQ6INiTL+duEZsjTLj5XYgjh8gnNvBKzErvB7Tc4pjotdjE6wRErx/uyyxvJXVCSzN/uaAHcIqFm3PTUJ/xtiidC2TVqRVrom4/SCzOUCXiJeFn1/7Ad0i7EDLhtLdLicQ2fP3Sfxi2tC4bWRCNlYfEBdpZ76hKg8RtSzbSfWi6gEZbbhnFbMXSsbvPRLq02bH3RPus6bglDL5NBpZ+Ebrr3PYwH/sBPaR1+iiYjCjqsnTVzWEKXTgp51Q4oud+bCDa/yebDJYOxKITKYzFp3GesCNuu5XcKh1szS7wmP114yGEhppSdh23vznmXoimwxwVStZaXj64WHDg1z5N/DmIajiaJRU3FdJD2Hk+tiTQ3CCs3mjjj+PDbM3KQTC+gKZAP/hHUr6xNl2OtIrbyIiQbxZ6JEa5jjMvYeI3AFf4z2tYBvu/irIVqmN97qxY/as/azUXtHmDME71QdMNVTBKoPl03VBIrfLIAqgNGhPp2mnK42pnc7echq1dbvO73M7aEphTd+bXUZpq8swafwhKMgeaM7ABaHDq73dpDa+JMFQQX9mwdXKehE2afOYsCXDYyamFyPiKzErxYJcwgeS738C4m1HzpwNTHYmANr/sF2By9LHfRWzudCYXrYEOBQidLnria8MhtW271Kav+ci5Rdr+UJ6kZibwY2btBpUqi3wUZa2TJJ/DA8nYopH9ug4WB0jyzloOlg6kg7kqtUWZ6Ji
 TO+UcdSs
 BAi+6dwXZrJR6r6udJAJRM+MOIrjRusRl0kIorL7c94Thf+RGaX3uvkDpRZ5fsWFFuhecnbkl+A9Woha10NcUZE2NJzzQ5sNm3Jz6hEXOMzzG+pFynrs9H/pgQJLRrEF/P9cJuEMVYKyimlESXPedVh4wz08uZWi4oSQFmKv8DEb9GVua0Rf9RRiQnJa82DvCygP1Q/n5ZHDuJjY7cWqrwrT+/13D0/dX/ZepU99qycIfe9fyGebgltRg+lgDMAD1rJ4qoghXoxdUAZ0vBJYDofqxO6BnqRxneNvWfLepR0u8wiV5bbKDshjH/5vXZDFd4AKsGwmkf5xe7jRa/WlFb36CsU8MZKMg/8ak5+Sk1WBSIyb5V9rA6w4W7CUjNB/WH2PY7OUmLfkUiVxOzKFncNf+gPs3TGbezlZJsGqqdoAsiC2fmMm0C82rZ47RigBnXO0OfUfwzJ5+Cl3hoHye8ui8PrsBC/WlZ6IqN3d7PW8DdOhZEWPOhKNl5pgS161LxhGS6jTrsD8PlpjMQqqF49jq9qPMZNTkg3hoFLG+AnZF9sAF2gs6bhYfFraItvpVYQ0SqOVPDewHop4kbxiT7K8zNdTOLNE3H4jFlReMA0KD4RU/wtxFPwcPWUpfr8CPzQd71lyqUYui7EOX4Qus4RiH5nnFeIdpxsOyVMwZma2chvMnfjse/97QAQj+vAU+hvUlCDO5TWEOEbX/If/oRDmRLFuXzWEeeJf2ic/d1mBpyuN+tPRiid8KkIrKDVluCx0w4pIUSwpnkdZj6BEtXkvSYkoCBDzSTT6648sNMWi3ic8ggM/wxtn86uk00n2u8VVhltdxI3Vmr94wse9/bWGoVwsU6cDmDOu399epYB4L/rjmu/F3QxF9pFbsBIc2JLenY5WLKgHjw35DA9WtuxceDgc44gQmA1ZVJ1Whp8QQ5bFWvlKhE/cKXmScqe9C4rJnHnxEQ5eltV7fRDa1jF8bAMFi
 MEmt9QXw
 iKZSkUXSm2tfUrJwgKqz+++genLtM9DpxBqUDOaCVLK9OouWTmVk6XEgpLJl9XEG4JtXr+ifPOBQnuUO7wTTUH+uMjSPCvFjuvpMZ92CDyN1Hk+fK1RFzRxyyHU1T+v3NaSXuPcgCFOB28Mq7JqU+aeniArUqvlsnlj6o1Xdnn7k+tTb4r4y7TZXl1nEEi96FAqia+swGtRkI/jRIDdHWigyz7WlXrLH5bXjTiZ3fJ4om6YHNqWEMGJO3PcveD/ScQTe8kpOJ4N9nAWFjbNcSmKELkJ1gQh1cN8oBoOFwg1jn/hDeTbZ/DEKyHZvRi9BiDFp4tggBdBJGIb9aOgZhBQyoFltyxhJK2TWPf6gmaA73IXHgPJ73MvyxdmrzZcqoa+aCgYlFTd8U1v4xsbVGMXvBxxb2QvAMLjg4lDMI8UoZ2Sx76uwgjaCllOpl6LvznXRmuEEmMbXCycnCBDXnFUMPivyvg7uCZOUGC3ZBuJbhY/ODOQ2wHW4usI+45Ig
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e7c375b18160 Merge tag 'vfs-6.18-rc7.fixes' of gitolite.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=174ce692580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cd7f786c0f5182f
dashboard link: https://syzkaller.appspot.com/bug?extid=c2d8be6880c81b4308a0
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1fcb660703f1/disk-e7c375b1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4bf314965321/vmlinux-e7c375b1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/456b373fea36/bzImage-e7c375b1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c2d8be6880c81b4308a0@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:28!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5199 Comm: udevd Tainted: G          I         syzkaller #0 PREEMPT(full) 
Tainted: [I]=FIRMWARE_WORKAROUND
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__phys_addr+0xfa/0x180 arch/x86/mm/physaddr.c:28
Code: 48 d3 e8 48 89 c3 48 89 c6 e8 92 c0 4e 00 48 85 db 75 11 e8 18 c5 4e 00 48 89 e8 5b 5d 41 5c c3 cc cc cc cc e8 07 c5 4e 00 90 <0f> 0b e8 ff c4 4e 00 48 c7 c0 10 d0 1a 8e 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc900030976c0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 77ffff890029ae0a RCX: ffffffff816d91f3
RDX: ffff88807e69dac0 RSI: ffffffff816d9279 RDI: 0000000000000006
RBP: 780077088029ae0a R08: 0000000000000006 R09: 77ffff890029ae0a
R10: 780077088029ae0a R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: ffffc90003097718 R15: ffff88807e730001
FS:  00007f359dd9a880(0000) GS:ffff888124a0d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000005e000 CR3: 000000007e0a2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 virt_to_folio include/linux/mm.h:1245 [inline]
 virt_to_slab mm/slab.h:191 [inline]
 qlink_to_cache mm/kasan/quarantine.c:131 [inline]
 qlist_free_all+0x65/0x120 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:352
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_lru_noprof+0x254/0x6e0 mm/slub.c:5307
 shmem_alloc_inode+0x25/0x50 mm/shmem.c:5149
 alloc_inode+0x64/0x240 fs/inode.c:346
 new_inode+0x22/0x1c0 fs/inode.c:1145
 __shmem_get_inode mm/shmem.c:3048 [inline]
 shmem_get_inode+0x19a/0xfb0 mm/shmem.c:3122
 shmem_mknod+0x1a8/0x450 mm/shmem.c:3843
 lookup_open.isra.0+0x11d3/0x1580 fs/namei.c:3796
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x893/0x2cb0 fs/namei.c:4131
 do_filp_open+0x20b/0x470 fs/namei.c:4161
 do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x174/0x210 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f359d6a7407
Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffeb2981680 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f359dd9a880 RCX: 00007f359d6a7407
RDX: 0000000000080141 RSI: 000055a5a8bca02e RDI: ffffffffffffff9c
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001a4 R11: 0000000000000202 R12: 00000000ffffffff
R13: 00000000ffffffff R14: ffffffffffffffff R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0xfa/0x180 arch/x86/mm/physaddr.c:28
Code: 48 d3 e8 48 89 c3 48 89 c6 e8 92 c0 4e 00 48 85 db 75 11 e8 18 c5 4e 00 48 89 e8 5b 5d 41 5c c3 cc cc cc cc e8 07 c5 4e 00 90 <0f> 0b e8 ff c4 4e 00 48 c7 c0 10 d0 1a 8e 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc900030976c0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 77ffff890029ae0a RCX: ffffffff816d91f3
RDX: ffff88807e69dac0 RSI: ffffffff816d9279 RDI: 0000000000000006
RBP: 780077088029ae0a R08: 0000000000000006 R09: 77ffff890029ae0a
R10: 780077088029ae0a R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: ffffc90003097718 R15: ffff88807e730001
FS:  00007f359dd9a880(0000) GS:ffff888124a0d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000005e000 CR3: 000000007e0a2000 CR4: 00000000003526f0


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

