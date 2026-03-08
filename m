Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6EDEA8537
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 17:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAFB6B0005; Sun,  8 Mar 2026 13:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27E6A6B0089; Sun,  8 Mar 2026 13:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177826B008A; Sun,  8 Mar 2026 13:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 013FA6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 13:02:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 863281C835
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:02:35 +0000 (UTC)
X-FDA: 84523514670.05.7A0FF69
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id D324D1C0007
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:02:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3qKutaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3qKutaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772989353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=zN0q9lKBFwsdqHp6xbvxHbqvSChILtAn23S4mYB4vqk=;
	b=L88Mtzt6cSCIbm+VwG10hZJ02DP7mOdoexgREQv55X+eWdvT1SJOcsemPCdijZpOA9BA1I
	vc8c2D8Gwc7uJQy30WjbLIiHgtD6eZoUWeurx/8ztbnVCUFfVbkFLoqj/LQARaaiWWG8ap
	PemtU1zZiGWSHRIJc7zTeuxosZFMdSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772989353; a=rsa-sha256;
	cv=none;
	b=zSbb5Z9fcuXRKosk1pAlGRE/JgbEiu+AEy964NPKEbS8IholDdh9S7UtSpEh/wC4zCZ20n
	1vHUArqtavGXi1IUYiI6i0vHPBm1DNsg71CvP87KUdRKxT/7l+YlBJL6S4wTKhqHGo2jpm
	ydWu3M7tmopKrUOqJ8i3dehBl59BADM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3qKutaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3qKutaQkbAAs39Avlwwp2l00to.rzzrwp53p2nzy4py4.nzx@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-40a4d2264abso45006968fac.2
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 10:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772989353; x=1773594153;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zN0q9lKBFwsdqHp6xbvxHbqvSChILtAn23S4mYB4vqk=;
        b=ZCb71KsAoiSaGLkbFH1rv49uCTPatuueGN3GQsfdy+tqdebd28zsVAfa/VqJfMqXyJ
         H/jylEqpRGLndXYHoeiRd+iatuGEgnrXKyRRfd1T2H5H+v7rcYVKzyD4rPvNqEZrsU5a
         Nehb6vakvzsumOI07WN7EEF8kH8n3Xi/3tGUUrLHGecF84uxy50haT7RtGfxmLVx/xBP
         0hcZW+WLj5M06KtfnNqOzBqHw77a2mJaHKk84A6GmRRPnTEMpVChIjY7PayjdRiaN9zN
         0iYmK+DlvybS2kxFzmdumoSBjmzK3A8DssbJnUGNUR/Qh+oHMueY+7gfYkCw2JkfXmTM
         bwiw==
X-Forwarded-Encrypted: i=1; AJvYcCXg2bQswgWBUa/W9P2jS6Sd9WYIzIrAMyhtAnADboqQ3II2gd0Hp2hsXdsGhXjnW9pESgUzUolE1w==@kvack.org
X-Gm-Message-State: AOJu0YwI5inNUaWmif92hhZORFSeI2pPZ1MYThKTsiZ4pkmJGsIcw1ko
	TbxkjD2SvFmlHNnAxdkwulC0Ysw0oG0EkWMHupTmKtaf0X2LthUuup46XTQTdcvcOGze3oF7T4T
	okKUKSoAbJoxCZdaf0iQgIdfU6cFlOwmiaLzct0iirmourkLcmi6uSbwId2M=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:5049:b0:67b:a667:f539 with SMTP id
 006d021491bc7-67ba667f920mr2330499eaf.7.1772989352954; Sun, 08 Mar 2026
 10:02:32 -0700 (PDT)
Date: Sun, 08 Mar 2026 10:02:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69adaba8.a00a0220.b130.0005.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in create_strip_zones
From: syzbot <syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D324D1C0007
X-Stat-Signature: zyitiwtjjyrg1s8rx99wh86uyrr8ppae
X-HE-Tag: 1772989353-541166
X-HE-Meta: U2FsdGVkX19Hn/X01nI3xDWonKEiEW/qGmWpY/acBVFv+Qt+BZKkl4KPNoiJYNYLScF86mhPYTTM2Zj+7cpqrVgiu/Lq3MZLKPhavAONpaHSh4vbMW6eLokO0rdEjrIMZ6OBzaAHgj/p83gvV2GIbvfSGSwgoenCrPapy+O0p9iPwRBzJilZ2+kgTI4RkxAdGKQaGk3rdRiLq35tt0Mollxv+Yl3Tofa0epycPefCXDc9fzBt7jqayhY2q6RN3tjM6FMcUOk4hS6fl3Hl7BpXk+q8B+yu1iuyIrHDFdBszjhRGXaEzJQqJ1SGlTfNHSBnN7cJMMRosWcGQlXANdDdCjNYhxwYwYg44m4J9jSiNvcidDKJh1Rfy/Rk2l7qteCepundaO0A9uFPM9fZ8yTQk/SY/9BaqoKXbESnyxqosfX1uTInV/u7JEJSHzCAr3h83u37uSopyC/fpgJQWmROESdMG+dePkxeehrMtN5uHGp30g9Mc7Vh61QHQ5SAgutuP/iMXPEgVWXsLC8dW9j5EzRhFGVwsRzbxmE+PrhEX8CzPwg6LddBjmQZIJXO+C0bAtcMQWO37D4JjAMD3XenJyqxFdAYhYUe34pLcCT8HosKYRvRqZqBmg5AmYDjyfySTqtEWTdEuDOsOLqQh+bKB/G63eOy2KdGThlAu5xl8/UpqfuuG4rKCFc+RkxrCjqTAa/3cePqQDJKCKsqtw9xK66mYYrowkhl7b7Q8iG3WNNS0lZHfE8bPL7DJTQ9v8Kw1DXAVLepAsHHqRfMzfcSxxEAzMbkG7Pc3pLVsv6kSnjHis1ykUb7W8ZQiDh2I51faxKJzgdwvgJFinWaJMcJYLN4mVt0R4W5t18OnzTP6WP2SktDGwdz8xY47AezxIEtxR2B60Aj12VXGmF2pY4Y4oB8/wAsYIebV+9eBF/VmG2rPxK1yfYUsL6xZu6GU1VmqEakcA4ErApnOXq4t4
 9KgODv6e
 deDaCBPVGkEUvdgPUv4eMA2QWfOtaElVvXYpg+fAa8dSqlltshIy4V0jpYIY787w5GrBaLXEv5FA6791A1WBrVD2FUAzG62TD69qv1yozmPOA+BHIRIB4wQgikTfDn1TaWl2TS9Cas2+/JEu/PfPLeogqBJXHNGMcvg3uBMoKBqiAWyW56Ufl7MCpNC+1nQTfGfcxj4AWUNd7BLrAKuaTHMn3oy3YjtN3ULQI+oD/TzySm4CfU4vDv3LNUeGVw5vxQXSPwdHeS3YqKn3Hs+vn5FPb0cruUzF7tOaoyF7tqboZvp3lmmUDJVKZBR0/luj7D1rc560uyoR4OteiWgPCrEZmUo70HlwQ3lGpZL2771FwYUqaV+RLplNFz3iGo4I7RsTlwbgY2WB+MR/AL+XIBXW7juqmh8zvRf1fJ4KBySYrWHyxusZZdrqSeBG/RexbRpnOgWTnz6szLggUgE4ckoXgiE15fvIJoIqTNkonHpROZciH7qA+LgJ3snlDVFB4C0eiokAvQZLEPrG5FIcIYQLPkfXgz0LKgf+BQoxESAS1L8eUzkP9kDev3ZziG65t3cDIakRO2c2j7kk707y8cd1Ds1DHIpaxcS77y46HmdMV9dhltvNdgMJi2riETkLmKpn4Q7ra6UFJNn6fMnOIQV7mU0CSGt8t4x48D/Nw+bNA9HCtbipd8VP/FakEqeSb0dkK2wGJdA60o5Sq9S6NzbvMuCeJuZGstn0z70aM+8gNSmbYobgd3k317VEVbBsioF2Hqj65WLrXfaUsF6elx9LqwtmmTFI7M0lLXEbfqK7OmvHr0+Km5+cqjs6wnWogiwMlk+GHUA//SJTUvE/k+HKoIg/rveszBaRf8wFqjg0lPtiwTwcXHEzsMDFhDCnPIDU7/xdIpZ+4z4mYjrdt5Gg67cskpe6pbHe2N5BAcdtgvGQUkQ3YJYFjh2wSnkDpL2IZv60NHW4V1wVaaTk6kPTTK7HU
 ELCB8UyO
 k5MfIjRbNKy+ZVEZelymeEspV54a/630CXHRzSHWaYmdAs9zhK5bfYxuLPWacSNGah9Uu+ZEzxVKJLgrSAik4yLmOqAGgS+V3o4apkE8kk1dovCzJix1SW8UYPwsrJRudl643oS2x7iwJ599uVqZqG8cUSqEVeXhNkMSvM30UsW+BtZoitp41D2leR702/1EuGfWS8fQxJq0qcnQQHHo4+WVW3NOLAix4prSmOt+ELgynBfXX0VOsTdxtZXbkkvOiEAUMfQU+BlcH+X9VNPAIkf9CAPAOG7S8/j9SUbWowIW6Gs+jDqFICVbk+75shV3vHluinwkp/KoFYZFChuhjnhqbmBKCeYth3OVRUxNYxRv5NBzIPJhhy/McNbBoU94Z+Jit+C66etDJVUL22lO3Tl5ULmGo7+//7eReDN3/jl/hUjze0l9RTo2gEML6LBGUy26Spu+mDAn4xX3wy/OwzSRfgXGIMq5zIvGFfi6agn2GrEs3uwhqLTThuaSYZVNWGlvbN4C2ME0in0W4a2jUo8w41XPUgT4OQKD8awFL4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ecc64d2dc9ff Merge tag 'sysctl-7.00-fixes-rc3' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11667006580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=976ba5a93c4add9e
dashboard link: https://syzkaller.appspot.com/bug?extid=924649752adf0d3ac9dd
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ecc64d2d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/69399e740888/vmlinux-ecc64d2d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bc08c6900a4a/bzImage-ecc64d2d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com

------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5226 at __alloc_frozen_pages_noprof+0x23ea/0x2ba0 mm/page_alloc.c:5226, CPU#3: syz.7.23364/10844
Modules linked in:
CPU: 3 UID: 0 PID: 10844 Comm: syz.7.23364 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x23ea/0x2ba0 mm/page_alloc.c:5226
Code: 00 45 31 c9 49 83 bc 24 70 05 00 00 00 4c 89 4c 24 50 0f 85 5f f8 ff ff c6 44 24 10 00 e9 f3 ea ff ff c6 05 d4 93 5a 0e 01 90 <0f> 0b 90 e9 69 df ff ff 83 7c 24 40 03 41 bc 04 00 00 00 7f 06 41
RSP: 0018:ffffc900050b75f8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000040dc0
RBP: 0000000000000011 R08: 0000000000000005 R09: 0000000000000009
R10: 0000000000000011 R11: 0000000000000000 R12: 0000000000040dc0
R13: 1ffff92000a16f0e R14: 0000000000000011 R15: 1ffff92000a16ed8
FS:  00007f782a8cc6c0(0000) GS:ffff8880d6645000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000040 CR3: 000000003e49e000 CR4: 0000000000352ef0
DR0: ffffffffffffffff DR1: 00000000000001f8 DR2: 0000000000000083
DR3: ffffffffefffff15 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2484
 ___kmalloc_large_node+0x104/0x150 mm/slub.c:5179
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5210
 __do_kmalloc_node mm/slub.c:5226 [inline]
 __kmalloc_noprof+0x5be/0x850 mm/slub.c:5250
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 create_strip_zones+0x56b/0x1f90 drivers/md/raid0.c:149
 raid0_run+0x341/0x410 drivers/md/raid0.c:421
 md_run+0xc2f/0x24b0 drivers/md/md.c:6601
 do_md_run+0x36/0x660 drivers/md/md.c:6698
 md_ioctl+0x27b2/0x37b0 drivers/md/md.c:8321
 blkdev_ioctl+0x5ad/0x6f0 block/ioctl.c:804
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f782999c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f782a8cc028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f7829c15fa0 RCX: 00007f782999c799
RDX: 0000200000000005 RSI: 00000000400c0930 RDI: 0000000000000004
RBP: 00007f7829a32bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7829c16038 R14: 00007f7829c15fa0 R15: 00007fff9111c658
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

