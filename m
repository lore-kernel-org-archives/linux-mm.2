Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46889CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 01:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C848E0005; Sun,  9 Nov 2025 20:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824058E0002; Sun,  9 Nov 2025 20:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7129B8E0005; Sun,  9 Nov 2025 20:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 531318E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 20:06:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F158589BC1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:06:33 +0000 (UTC)
X-FDA: 84092907066.08.A7D3F64
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4E96A1C0010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:06:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3lzoRaQkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3lzoRaQkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762736792; a=rsa-sha256;
	cv=none;
	b=sH6/lRQ3exX1As3kRnH8hb1kdPF/5gyz57JlBaQgr/QWbY4K0ZZos+mh4VZ8/YB334qmHH
	jG9Bqqqr9CHjF4+Az+hoa5kiTgAgLpsI7hUXE/G4IBhVNQgllTICH2b8XZ/rNgCJ3To3uB
	2NU4PIWpf+OxcsULFQ9bDWGOBruBzcc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3lzoRaQkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3lzoRaQkbAKASYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762736792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=fJYY9I31QSgwXfBrwnURolXxvjVKBBrQvM8l6cR7Z3c=;
	b=6uOLl2SITpW5CtD1uTpDXbzNNvl43sCpi5TjUrUh327wYeveQEl0x5mbXRlJHPKXRwLP1f
	92Rrpl2lsf9xbx9HHLAREInMROY5OQQWS0TDG2znpFIR8rAgnCHrs+pc2iTHSdp9FcNTZ6
	M+np4UvoqBZPejKIvqOqtqZptgqsvIc=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4330ead8432so23059305ab.0
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 17:06:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762736791; x=1763341591;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fJYY9I31QSgwXfBrwnURolXxvjVKBBrQvM8l6cR7Z3c=;
        b=T0a9FY5GnuPDHKtzkwc+Srmiu/rzw+8ciG9kIvBOc3DRrYF4SdNf7bjRZewn2EGwSo
         csiidx/mA8YdOndAiaxVDsmG3Tnjf73ulDu+mM5GnUoZIFA+cTc5oxjJPL4oDOgbt+zo
         kMWGSK2ysNIpxEVO/WF9pLQqLxDpKvk3MVKqAoKsUWDAShSqoHEQZsJTqWBWuILFFpaO
         5AD0Z2nOKeplVpX8D+X9Y5uzdq+GW6+kFok3fHUCetIwrPlePDjfFByc8tSf34jKJCf9
         7B2k1FQ8w7PdtfPNfs+DY9wcK+6eBoQFooRHQJ+/3DV1sUVLI7UfS7VGgpiC8265A0yW
         h5Sw==
X-Forwarded-Encrypted: i=1; AJvYcCWqO8Zclz6Couqya3kTgT+ZjSBPAkLk/OCX+qhVAdGJZgr+W0myjojmBPbY5hOmEUqCmcuYRI4oPg==@kvack.org
X-Gm-Message-State: AOJu0YxZbgN86V9kOYIgP078AXLkuVV6fX4MKYVvl78uHIU0h0+9es1j
	DFjT1pKmNwVy7aH2JUz4JzCBx2qvvVK0apf/Tvcedoi4xmU+OUg4UzNTioFlNpz4dt2awbPdM6L
	C02DBKdQVOVbB+Cr35jOQe1CDmm9r+z0q2Remz9MSMW9UIRA845y24Uxq9xc=
X-Google-Smtp-Source: AGHT+IG/UjQ6NXshDpXlXJ3b2kemimE9cKvvRB6ea6lPS1suoXqRr2gPQqGafZAM9l3CEo548QS8UrINIy6k7+o8wwY7f2I8JAlV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2191:b0:433:7fc8:7ca8 with SMTP id
 e9e14a558f8ab-4337fc88263mr27844285ab.17.1762736791377; Sun, 09 Nov 2025
 17:06:31 -0800 (PST)
Date: Sun, 09 Nov 2025 17:06:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69113a97.a70a0220.22f260.00ca.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in __hugetlb_zap_begin
From: syzbot <syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E96A1C0010
X-Stat-Signature: odmo95pxe5toue1cp1pr5q5s7cxehhca
X-Rspam-User: 
X-HE-Tag: 1762736792-698303
X-HE-Meta: U2FsdGVkX18/1mfnZT9m5oT7wTtFqboqZIa8mGib7YUGi45DcEddpbvlC8zbIs6DViU0kEBeM+AwWRRxKYsVW9BB1ArBZ5VnjHvS8QvbHFkadxYn0cNe1uXa0aO2+3yK2zcq8YKA8kFQAwzz0YjS8VOroxX6caypr93uUWrW/Aq3LAABaJkIG3hU3OLem3Xrr3usa1P9zRi/O7hcfqHXkyt92Ef+gRoyLDRSNoESxtJlYwP6WLRrH4E0SGZuCHx3NaQsird6HOgFeZ8YgLmrHdOE5JcJifczQaoqO2gwG5oohPaEi1l34uyC1PIgN/TEpKQuzuG79B7K95mN9aCy2vPVisNzZMsylZuqYDGN5gG8HYPGo+uSMiQ/ogYoAbwsvBq2LEN+IDYJE5yMQyfXIUCoNc79XjbV+CKWZ8O/PH+wtabkz9M69HS2VGO7lytPo057OHvoSHWlt+U3VDvi6EnFMLaKx5ITQsS5RIvqw8z+xzHQC+9QjaSpFj61mJibf3GaWgk1r8D4+oS1hDPYWq5gYc+6w0NfjtmkfgZN7SfFvOEZXtXDIIDVi86VqsPo4201OIppVCM+UeEI46Htr8AkaFceBr6Cfa3wsq3316sQaUh/dO3tb3e01/pV9GssWrRR5ayC84Iwf40RX2MaWT0QD9XUzD/POmgvfA5SHrDSX2Xp7dhFUcjVuXhhCiUCqe9Rvh8jIbRrV3F0NEo2cQIfzH+rmGONGGfudgKaAbKDcCxHttVLa+H2XfCo8p1lxnba5mbgEUQvRt7CX16gqBFQsfYPbYg1DW+r06yjGh5xvE2kkYxgYL2yB53dGbQAiK6RBXXzgy8698+Ri4rLml1Io5kbJim2dzRLubcF7iAklTiL9Mql3ii4qQ8aQlDI0wT4dYw+mRncLOtsecqaQLFwU1DWR2fFWt+Y2mJFxB/kzClcHJ9q6pS3v6TDFF1Ilhcc6Z1zB/xMw9IjYaE
 ItEGpOs8
 61/mevd/n1xqX3lPUTH4GKJwaRuofSa6Q/PXObM3ixXWFyiS0P1et7izwXLqPf273E+wZPsJIc2U5Znm4qm15ksXbaJ61gHaClwg6hPqF10q0dTNAaC/6V+RcwrJrC2amdGfpoWsUV3pdx2mTwLxu1OIC0kl+cyx7NA7ZyWydtgtZYb994iCwepneujntFTVGMHcrNE1Ja/Btuijh+HfXbC0gOh0q/r+XcCPEmU2KdzKtOD3TZUnOSpGA6VsAsVp96aNQRV1xnwvs0pNj+AIh2x4GPXsRU/cKc+7deFJMAx3qPNV+yheYtfCJq3vs76M86Zx4KMXCWmaJDh8UuwqrQW6pftDJJ/7qoCIGbLGhEirOuQu58NHly7XlGg3N9lgeYEj14/GNGi6xeh+Z7ku81zArJFThqtJnJeEvLIQkQu3+U/DHrOn/tAfAwgmxjl2XOv+p/FrtxtX1d+iJgN96k88lRawlaxoiPbEuVNMgsuaitldQ1Es3iz3x1LIKzs3Kzsv8xqM/kJTKj/j+y1rtnowZSzncEmgdwbnndHKhg0Qvu1eaF/xQnmOVV9QLpMSIS6Vxm/eUV2WLNH7N9LOy8mc9JFkWtMnH78V3GQZUtNFci029FAS00aBo0+wLUzGiIqzzQKvJ/IymigzsobOLpKq3GH80/V1NYwcnNXHuE2+T7T4dR+TauqHg07dH1vW5H8S+UgeqBFYmRimDshzPN8SBEomMhb0nsO5lbxi3yeJVUAs82AUGrpVeKKyNMseRvBNSra7YH/cMxaanXhqm1w6pzUj2weGdmuGK+7L09BwTwroVSUGY4b3zELsWKlG01SfkKXxL8H2IIM/U+HW+14rJktPP4KxbWZPXXDQPBQ3Y38zlaLnyQQpNEv2q2QWfdKOsaw5r0L0N6q4TFqksggWuMa1euXH38EfKFSHKMavPG8KrEf0QsDvI/hn1buOl+9IZOGd8muICRZOtJxlh1AQdQSfw
 y4KnJy1y
 TO1X0PXCjV2lRoSQhVNTrhIc+//L3dWoRJRcNHzlYn79PDQiMTLz2utSxozev7HbUrvHgOBaXjwxox43RNaEHnKUyq+U2DWG7p0JPBaMIuZH5qLxjcL86RzW/jOKjnO4YGKXSYCiwbnWAgJgwBxEBUqinZeYd+P5i5TQ061LwUX7RFu7Fsc6sVmKlZ24mzydZR8DLrscgfnIath+ko9CFUnnZ+1E9vW9O2usuWO7TLWUm8BWbiC8720dJQNqg5sp2SKo1ukb9qaC26kiyMFyAfaRGxpS47adM2C1m2Q20oXocCB/Mw3WUe1C0PVTYX871OB9P77ls7cfo8roxC11rviv8X0mU33Dzxq38yJfHERtALziDaVLy3s57yGgxBZkOjfKu9C9xSb4cLMtQCiqkXQZa8pzl5Fq4+HAHSdMqYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dc77806cf3b4 Merge tag 'rust-fixes-6.18' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1676ca58580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19d831c6d0386a9c
dashboard link: https://syzkaller.appspot.com/bug?extid=3f5f9a0d292454409ca6
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a1c9259ca92c/disk-dc77806c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98d084f2ad8b/vmlinux-dc77806c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c25e628e3491/bzImage-dc77806c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kworker/0:1/10 is trying to acquire lock:
ffff8881446f6c18
 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:548 [inline]
 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: __hugetlb_zap_begin+0x233/0x2a0 mm/hugetlb.c:6033

but task is already holding lock:
ffff88805f3dda78 (&vma_lock->rw_sema){++++}-{4:4}, at: hugetlb_vma_lock_write+0xac/0x130 mm/hugetlb.c:327

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #10 (&vma_lock->rw_sema){++++}-{4:4}:
       down_read+0x9b/0x480 kernel/locking/rwsem.c:1537
       hugetlb_vma_lock_read+0xac/0x130 mm/hugetlb.c:301
       hugetlb_fault+0x30a/0x2f40 mm/hugetlb.c:6706
       handle_mm_fault+0xbfa/0xd10 mm/memory.c:6485
       do_user_addr_fault+0x7a6/0x1370 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
       do_strncpy_from_user lib/strncpy_from_user.c:41 [inline]
       strncpy_from_user+0x147/0x2e0 lib/strncpy_from_user.c:130
       getname_flags.part.0+0x8f/0x550 fs/namei.c:157
       getname_flags+0x93/0xf0 include/linux/audit.h:345
       getname include/linux/fs.h:2922 [inline]
       do_sys_openat2+0xb8/0x1d0 fs/open.c:1431
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x174/0x210 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #9 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       hugetlb_fault+0x302/0x2f40 mm/hugetlb.c:6699
       handle_mm_fault+0xbfa/0xd10 mm/memory.c:6485
       do_user_addr_fault+0x7a6/0x1370 arch/x86/mm/fault.c:1387
       handle_page_fault arch/x86/mm/fault.c:1476 [inline]
       exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
       rep_movs_alternative+0x4a/0x90 arch/x86/lib/copy_user_64.S:68
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
       copy_from_user_iter lib/iov_iter.c:55 [inline]
       iterate_ubuf include/linux/iov_iter.h:30 [inline]
       iterate_and_advance2 include/linux/iov_iter.h:302 [inline]
       iterate_and_advance include/linux/iov_iter.h:330 [inline]
       __copy_from_iter lib/iov_iter.c:249 [inline]
       _copy_from_iter+0x383/0x1720 lib/iov_iter.c:260
       copy_from_iter include/linux/uio.h:228 [inline]
       copy_from_iter_full include/linux/uio.h:245 [inline]
       skb_do_copy_data_nocache include/net/sock.h:2269 [inline]
       skb_copy_to_page_nocache include/net/sock.h:2295 [inline]
       tcp_sendmsg_locked+0x2900/0x42e0 net/ipv4/tcp.c:1272
       tcp_sendmsg+0x2e/0x50 net/ipv4/tcp.c:1413
       inet_sendmsg+0xb9/0x140 net/ipv4/af_inet.c:853
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       sock_write_iter+0x509/0x610 net/socket.c:1195
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x7d3/0x11d0 fs/read_write.c:686
       ksys_write+0x1f8/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #8 (k-sk_lock-AF_INET){+.+.}-{0:0}:
       lock_sock_nested+0x41/0xf0 net/core/sock.c:3720
       lock_sock include/net/sock.h:1679 [inline]
       mptcp_sendmsg_fastopen net/mptcp/protocol.c:1737 [inline]
       mptcp_sendmsg+0x1449/0x1ec0 net/mptcp/protocol.c:1840
       inet_sendmsg+0x11c/0x140 net/ipv4/af_inet.c:853
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0x973/0xc70 net/socket.c:2630
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
       __sys_sendmsg+0x16d/0x220 net/socket.c:2716
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (sk_lock-AF_INET){+.+.}-{0:0}:
       lock_sock_nested+0x41/0xf0 net/core/sock.c:3720
       lock_sock include/net/sock.h:1679 [inline]
       inet_shutdown+0x67/0x440 net/ipv4/af_inet.c:907
       nbd_mark_nsock_dead+0xae/0x5d0 drivers/block/nbd.c:319
       recv_work+0x671/0xa80 drivers/block/nbd.c:1024
       process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
       process_scheduled_works kernel/workqueue.c:3346 [inline]
       worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
       kthread+0x3c5/0x780 kernel/kthread.c:463
       ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #6 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       nbd_handle_cmd drivers/block/nbd.c:1146 [inline]
       nbd_queue_rq+0x423/0x12d0 drivers/block/nbd.c:1210
       blk_mq_dispatch_rq_list+0x416/0x1e20 block/blk-mq.c:2129
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xcb7/0x15f0 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd8/0x1b0 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x239/0x670 block/blk-mq.c:2367
       blk_mq_dispatch_list+0x514/0x1310 block/blk-mq.c:2928
       blk_mq_flush_plug_list block/blk-mq.c:2976 [inline]
       blk_mq_flush_plug_list+0x130/0x600 block/blk-mq.c:2948
       __blk_flush_plug+0x2c4/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       blk_finish_plug block/blk-core.c:1249 [inline]
       __submit_bio+0x545/0x690 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x53d/0xc10 block/blk-core.c:755
       submit_bio_noacct+0x5bd/0x1f60 block/blk-core.c:879
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x4db/0x850 fs/buffer.c:2461
       filemap_read_folio+0xc8/0x2a0 mm/filemap.c:2444
       do_read_cache_folio+0x263/0x5c0 mm/filemap.c:4024
       read_mapping_folio include/linux/pagemap.h:999 [inline]
       read_part_sector+0xd4/0x370 block/partitions/core.c:722
       adfspart_check_ICS+0x93/0x940 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x723/0x1520 block/partitions/core.c:693
       blkdev_get_whole+0x187/0x290 block/bdev.c:748
       bdev_open+0x2c7/0xe40 block/bdev.c:957
       blkdev_open+0x34e/0x4f0 block/fops.c:701
       do_dentry_open+0x982/0x1530 fs/open.c:965
       vfs_open+0x82/0x3f0 fs/open.c:1097
       do_open fs/namei.c:3975 [inline]
       path_openat+0x1de4/0x2cb0 fs/namei.c:4134
       do_filp_open+0x20b/0x470 fs/namei.c:4161
       do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x174/0x210 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       nbd_queue_rq+0xbd/0x12d0 drivers/block/nbd.c:1202
       blk_mq_dispatch_rq_list+0x416/0x1e20 block/blk-mq.c:2129
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xcb7/0x15f0 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd8/0x1b0 block/blk-mq-sched.c:329
       blk_mq_run_hw_queue+0x239/0x670 block/blk-mq.c:2367
       blk_mq_dispatch_list+0x514/0x1310 block/blk-mq.c:2928
       blk_mq_flush_plug_list block/blk-mq.c:2976 [inline]
       blk_mq_flush_plug_list+0x130/0x600 block/blk-mq.c:2948
       __blk_flush_plug+0x2c4/0x4b0 block/blk-core.c:1225
       blk_finish_plug block/blk-core.c:1252 [inline]
       blk_finish_plug block/blk-core.c:1249 [inline]
       __submit_bio+0x545/0x690 block/blk-core.c:651
       __submit_bio_noacct_mq block/blk-core.c:724 [inline]
       submit_bio_noacct_nocheck+0x53d/0xc10 block/blk-core.c:755
       submit_bio_noacct+0x5bd/0x1f60 block/blk-core.c:879
       submit_bh fs/buffer.c:2829 [inline]
       block_read_full_folio+0x4db/0x850 fs/buffer.c:2461
       filemap_read_folio+0xc8/0x2a0 mm/filemap.c:2444
       do_read_cache_folio+0x263/0x5c0 mm/filemap.c:4024
       read_mapping_folio include/linux/pagemap.h:999 [inline]
       read_part_sector+0xd4/0x370 block/partitions/core.c:722
       adfspart_check_ICS+0x93/0x940 block/partitions/acorn.c:360
       check_partition block/partitions/core.c:141 [inline]
       blk_add_partitions block/partitions/core.c:589 [inline]
       bdev_disk_changed+0x723/0x1520 block/partitions/core.c:693
       blkdev_get_whole+0x187/0x290 block/bdev.c:748
       bdev_open+0x2c7/0xe40 block/bdev.c:957
       blkdev_open+0x34e/0x4f0 block/fops.c:701
       do_dentry_open+0x982/0x1530 fs/open.c:965
       vfs_open+0x82/0x3f0 fs/open.c:1097
       do_open fs/namei.c:3975 [inline]
       path_openat+0x1de4/0x2cb0 fs/namei.c:4134
       do_filp_open+0x20b/0x470 fs/namei.c:4161
       do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
       do_sys_open fs/open.c:1452 [inline]
       __do_sys_openat fs/open.c:1468 [inline]
       __se_sys_openat fs/open.c:1463 [inline]
       __x64_sys_openat+0x174/0x210 fs/open.c:1463
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #4 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:173 [inline]
       __synchronize_srcu+0xa1/0x290 kernel/rcu/srcutree.c:1439
       blk_mq_wait_quiesce_done block/blk-mq.c:283 [inline]
       blk_mq_wait_quiesce_done block/blk-mq.c:280 [inline]
       blk_mq_quiesce_queue block/blk-mq.c:303 [inline]
       blk_mq_quiesce_queue+0x149/0x1b0 block/blk-mq.c:298
       elevator_switch+0x17d/0x810 block/elevator.c:588
       elevator_change+0x391/0x5d0 block/elevator.c:691
       elevator_set_default+0x2e9/0x380 block/elevator.c:767
       blk_register_queue+0x384/0x4e0 block/blk-sysfs.c:942
       __add_disk+0x74a/0xf00 block/genhd.c:528
       add_disk_fwnode+0x13f/0x5d0 block/genhd.c:597
       add_disk include/linux/blkdev.h:775 [inline]
       nbd_dev_add+0x783/0xbb0 drivers/block/nbd.c:1987
       nbd_init+0x1a2/0x3c0 drivers/block/nbd.c:2702
       do_one_initcall+0x123/0x6e0 init/main.c:1283
       do_initcall_level init/main.c:1345 [inline]
       do_initcalls init/main.c:1361 [inline]
       do_basic_setup init/main.c:1380 [inline]
       kernel_init_freeable+0x5c8/0x920 init/main.c:1593
       kernel_init+0x1c/0x2b0 init/main.c:1483
       ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #3 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
       queue_requests_store+0x3a7/0x670 block/blk-sysfs.c:117
       queue_attr_store+0x26b/0x310 block/blk-sysfs.c:869
       sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:142
       kernfs_fop_write_iter+0x3af/0x570 fs/kernfs/file.c:352
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x7d3/0x11d0 fs/read_write.c:686
       ksys_write+0x12a/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#63){++++}-{0:0}:
       blk_alloc_queue+0x619/0x760 block/blk-core.c:461
       blk_mq_alloc_queue+0x172/0x280 block/blk-mq.c:4399
       __blk_mq_alloc_disk+0x29/0x120 block/blk-mq.c:4446
       nbd_dev_add+0x492/0xbb0 drivers/block/nbd.c:1957
       nbd_init+0x1a2/0x3c0 drivers/block/nbd.c:2702
       do_one_initcall+0x123/0x6e0 init/main.c:1283
       do_initcall_level init/main.c:1345 [inline]
       do_initcalls init/main.c:1361 [inline]
       do_basic_setup init/main.c:1380 [inline]
       kernel_init_freeable+0x5c8/0x920 init/main.c:1593
       kernel_init+0x1c/0x2b0 init/main.c:1483
       ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4269 [inline]
       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:4283
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4921 [inline]
       slab_alloc_node mm/slub.c:5256 [inline]
       __kmalloc_cache_noprof+0x58/0x780 mm/slub.c:5758
       kmalloc_noprof include/linux/slab.h:957 [inline]
       allocate_file_region_entries+0x1a0/0x620 mm/hugetlb.c:697
       region_chg+0x85/0x140 mm/hugetlb.c:817
       __vma_reservation_common+0x43b/0x740 mm/hugetlb.c:2580
       vma_needs_reservation mm/hugetlb.c:2647 [inline]
       __unmap_hugepage_range+0xeb9/0x1a00 mm/hugetlb.c:5983
       unmap_single_vma.constprop.0+0x1ea/0x240 mm/memory.c:2056
       unmap_vmas+0x218/0x470 mm/memory.c:2104
       exit_mmap+0x1b2/0xb90 mm/mmap.c:1280
       __mmput+0x12a/0x410 kernel/fork.c:1133
       mmput+0x62/0x70 kernel/fork.c:1156
       exit_mm kernel/exit.c:582 [inline]
       do_exit+0x7c7/0x2bf0 kernel/exit.c:954
       do_group_exit+0xd3/0x2a0 kernel/exit.c:1107
       get_signal+0x2671/0x26d0 kernel/signal.c:3034
       arch_do_signal_or_restart+0x8f/0x790 arch/x86/kernel/signal.c:337
       exit_to_user_mode_loop+0x85/0x130 kernel/entry/common.c:40
       exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
       syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
       syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
       do_syscall_64+0x426/0xfa0 arch/x86/entry/syscall_64.c:100
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
       down_write+0x92/0x200 kernel/locking/rwsem.c:1590
       i_mmap_lock_write include/linux/fs.h:548 [inline]
       __hugetlb_zap_begin+0x233/0x2a0 mm/hugetlb.c:6033
       hugetlb_zap_begin include/linux/hugetlb.h:258 [inline]
       unmap_vmas+0x2e9/0x470 mm/memory.c:2103
       exit_mmap+0x1b2/0xb90 mm/mmap.c:1280
       __mmput+0x12a/0x410 kernel/fork.c:1133
       process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
       process_scheduled_works kernel/workqueue.c:3346 [inline]
       worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
       kthread+0x3c5/0x780 kernel/kthread.c:463
       ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  &hugetlbfs_i_mmap_rwsem_key --> &hugetlb_fault_mutex_table[i] --> &vma_lock->rw_sema

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&vma_lock->rw_sema);
                               lock(&hugetlb_fault_mutex_table[i]);
                               lock(&vma_lock->rw_sema);
  lock(&hugetlbfs_i_mmap_rwsem_key);

 *** DEADLOCK ***

4 locks held by kworker/0:1/10:
 #0: ffff88813ff15948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3238
 #1: ffffc900000f7d00 ((work_completion)(&mm->async_put_work)#2){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3239
 #2: ffff8880596b4d20 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:368 [inline]
 #2: ffff8880596b4d20 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x103/0xb90 mm/mmap.c:1265
 #3: ffff88805f3dda78 (&vma_lock->rw_sema){++++}-{4:4}, at: hugetlb_vma_lock_write+0xac/0x130 mm/hugetlb.c:327

stack backtrace:
CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Workqueue: events mmput_async_fn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x350 kernel/locking/lockdep.c:2043
 check_noncircular+0x14c/0x170 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
 down_write+0x92/0x200 kernel/locking/rwsem.c:1590
 i_mmap_lock_write include/linux/fs.h:548 [inline]
 __hugetlb_zap_begin+0x233/0x2a0 mm/hugetlb.c:6033
 hugetlb_zap_begin include/linux/hugetlb.h:258 [inline]
 unmap_vmas+0x2e9/0x470 mm/memory.c:2103
 exit_mmap+0x1b2/0xb90 mm/mmap.c:1280
 __mmput+0x12a/0x410 kernel/fork.c:1133
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
 process_scheduled_works kernel/workqueue.c:3346 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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

