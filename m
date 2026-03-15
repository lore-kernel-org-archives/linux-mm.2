Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0DCF30280
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 19:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94B36B00A8; Sun, 15 Mar 2026 15:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55536B00A9; Sun, 15 Mar 2026 15:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54656B00AA; Sun, 15 Mar 2026 15:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF5976B00A8
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:09:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6887E1B8F02
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:09:29 +0000 (UTC)
X-FDA: 84549236058.28.47BE465
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf05.hostedemail.com (Postfix) with ESMTP id C94A5100011
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:09:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 35gO3aQkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=35gO3aQkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773601767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=l1kDM73VAJj2BEBh16gE80dBPKbI2Ip+vgvGfrp96OE=;
	b=EjPFtMlY3wxmqWVgRII1GDzse913/jZsX7wly6y3LndnErG3PZkrxkOWl951CUIthNIrxM
	xA/m6GFav5DWRfubtCxM2QjhgxJoM/8skQUYDkBIfIfQV8UCU4HXxQV7hvaaqvpVrXiiNR
	J0rnDyza0Qq0kCFiW5TLvoY3HXileo0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 35gO3aQkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=35gO3aQkbAB8NTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773601767; a=rsa-sha256;
	cv=none;
	b=8aKrdnjrjwPqLDMLPtqa6E5/wxbSicKgScvAlHc8Md3wq7jyTakIH/oG8qCLJxZMgqAHPk
	J0fLZeCAe62O6lES07Z9+7EGAxX/cPXepurtyDWp0lBghUVFMRNmGn0lOyio/Lmf36yZJp
	6h1JdU4v4ND6Xfw0sbqSvkdIvOMriBc=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-679c51b2d6cso53159890eaf.2
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 12:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773601767; x=1774206567;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l1kDM73VAJj2BEBh16gE80dBPKbI2Ip+vgvGfrp96OE=;
        b=kLnzQjGIYdZQ/ixqTfvLAxXVfW13tBkdhbrUU8+6KlX1j2Twtas5YxtQdnAd+CPeMw
         ufiuVVP2IzEAZW/00Qwqavf81GEeyQTHF4gqD9v1iptoK4v0BXAQpu7v+UtFKyFaOclS
         KGfcRaFp4mcSaobHCV3F5KOI1PIjRhvYwGtEBhTxa4CATtu7KNbjdaWC6AOhsRnQSSdH
         OjqpMzujXFny0j+UpQHU1uI51sDnFG7wjrkDhpitYMsDp8L8MhKm3A79LotpbNxImGwr
         fEPG10amhg20gc17SPJfQyrNCqV07R2EPrs4/hxMj+PsAiPFFzTHF7jcn/OwxdR5TC46
         2GdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhHsewc4Oego6cBZ5vYhQEWDyO+TiGMDlhWnjMfWIvAZkBE+tjAnIR/7vc767UOEoCZzeDMXwYCw==@kvack.org
X-Gm-Message-State: AOJu0YyziR4S07zg5Gmotrbvk/pcu9+5Cvfj73pwXtY1fZ5KQcwZz797
	9iJUwBL18dejcsbYMdGfBYTambrFrKXDacBJzDmTOpLMDz1H4lKPTmRJmmALq7S+EIvJ4aqVFaT
	k3vU3XbRD6k+3EdYsE01u5tdG/UVpemiJpwFfKk3/YQCd73Ai2X/gbUsK/rk=
MIME-Version: 1.0
X-Received: by 2002:a4a:e8c6:0:b0:67b:db2e:a91e with SMTP id
 006d021491bc7-67bdb2eaa89mr6221556eaf.17.1773601766913; Sun, 15 Mar 2026
 12:09:26 -0700 (PDT)
Date: Sun, 15 Mar 2026 12:09:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b703e6.050a0220.248e02.0101.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in folio_add_new_anon_rmap
From: syzbot <syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 77o4xcgwsuywwoz3f7f4eq56dj99c44j
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C94A5100011
X-HE-Tag: 1773601767-28541
X-HE-Meta: U2FsdGVkX19a3TQA7g0DGsh2Nzjm9Ea+ttZGJY47GwJEE3jJqSwCgoXELkHcyw1Mn7ZR3Laz9HvGwpBaH4WaWxLt+FBmKPb4YZ39zUa4jNIOS9ss7pciDhLauhmJUTEfL/i1WUCDxlEHMg1jLVZkYgDy5MDsDg3drz845eLqhDYRTy2yx5+n4TNh8L2VY4yKJ6s/t6XaqGJDgGE1GpvNsXC8HUgVEWEiy6UQgNDkiIiDyz6I5+IQvV2Jyy6wYM1Iy1ctM9/MKE7gQtPhEx/HZ0YxhmLQd5flpdOnbRofC7a7KBCK0hg8zkQqz+LblXi0lxKr+YOr4Qu4xXhDQTdYVCxddy+kZ7902SAvBccUI3tv1mkjxIQwPd7RQeFS6HCVADi1ga4Pvn2E2NqYbvclUX+KOljofBMGABBAdEBB7YfwY6WdBlnvYHV9LQuC73CVXz7f5Q1xF74QYeozr0ULEW1ihHSjnW4b2hUCix14ZWvMzGYpfespd4IMq2gGQFT4jbi1/U3UJuDZtp237Nhue22nOslJk/XLnGAY2TAUR95ae6Sn1ddyOxRVg5LQbxvcAH5VIOVr0Eb8RpyUiI2oPqAS8+hvN9shNg+yBjbZAd+r3MTNjsrn5eRpbofQYi6A+VCGZOBf0JAVQ4IdB4KFHaxZKn00kfBaHgl73RHrDaUhDO98yOYpb0qtu8n5ChZxwE7YHRvw2XwjxNSZybqSfowrqTkoyKD9QQnH9VY/uCyW+gm7YFoAZ9DJaJ1MQDfJn4BsUIUBaVPmK0nYzuCRxQZgmEpAfOydyfqKlKYs/86ayPmjUtz129mNNqMOEzNhYaSmrrG6Uanm8oUc6IeHFmDTTb8OOgQ/cUiMOGeuQT8w83MdBiOjngzM7L1oHYrvPT7v3mQOGcrP3c24q8iXt9+qM5sbsYbIDj6PG//4jiZ3Qz8D7PjmN4cw7K8jW+wGDJaySc6lv5/F+oHJvzz
 ibd+oaol
 P8XtHsOgW8jK2HlpGLHejOdBZi4kFla03a3iHHQr3JQULTm3E3Gg4A2+vHpPsYQSQCbn04KLTyhvBhv03fEvsEdwkxSAYupC73/SJ+oxkCT8LpQwWgtI2PdkrvEDOfcSRTQY0GE/a8jMWcMMOsGL4wUVOBJIM17mYG+p/xJIffs/WliucZDivGz9fCXr5JNXE6ADEPeUIwXP1jFuIHIDE2Vzu8uejG0H/my2RqK+fsCifhsKWrJmZ1Qk+M+vJckwUzT3gjYlFnq0e3VUZNjAscjH98S+CWMKjC0Sn5N3k9RwOZS/MB0XsWKjT/F+o8WgQWvcz+RNdP9P+YV7tGsPalkylyNqcIqKnPXuvpnbOMzkVpxS11rED7j754PsW0/x2FWYhVmlqOaxDPMujI5p9O0YUUJWDGNUSkwqqSlh++IvKDfGkFSoQLoXUnVHk32O3zcN9bHhZoh/yXKSlM/AI7aAtUIs19RmvVwd8yN2qao1TFmWm6qn6fb4muuOw7tRbLBj0sueW3Y9gT0sK/Mq+6Yc6Sq596x+ZOAU9aEpjTyg7UX3MmhU2eld0cMe+f2MLWBL782TWMVaEjkJx08bYQ6OgIhQukS8GQwX+G0Hu+KzCBBnPSqXTgZlzbYEPJUYJDsR9LKgEeezrqYfL0bbM1bLJy5NkXeY/pxLXKnqyuVSmxXNTdMZhsTDoF6EZLdcUBqK8gqxrOw4FRbSEoIuFFa9+I8NGDT/IS7qRqzdTK9WlQzp7ZFvFslvEzO3Bw7lMdsWEviRY3jQQWdPv49RhxW72dTWLQSINGxrWiSWQQnMVClFN9x2c2yrg4YnT8Rdpsc7T2dKVGTdYbAbq1wFMnYZaueMCkeBRikpTGlMW4TWN01q00q+qDwbEnfS2TFZBTPx/0XD3Lf8r02ffdiJd+ODf8bs3Xa/SKcwTUq2WRe7GjqiUlZhlC489rDMJeG8z5y4l5XX33t7VA4X98CUKX9J+Bdk9
 4w7l5iC0
 gYOpw6V1PEjPrpEBSm894EGZmicmOUU90X8kB+yMnxCdhP4kGaOVTpJEzRRuwgZYPv4u6GWXtOf52CYhziP87cFTKDgaUuLzzMaFC+ajzfh0nUg9FhLwm8O/QQCh2BXRjnXb3zksFFXXxhuAi3GStVRZnnDKR/oiOWPjPfSOmqbMoyxipO1HstQQV63lJN3WrfjY8/VW/xs4Hhu83dYb5XZv4ZWFrcVczwl3D2puh6DWSf7jVt5h11hAIe8fXxPmr9UaMz/KyE6AtyPtihGF/npXhqqaYHRvsOPX0ddQlUavXcacUrowvSME2ldePoarpnJvmi+QGEJuKxMtZ1YfFlKsh102Yw0dxaGA0bjHlK+yqxf6Oq8fM92J/aAfvEsc5oo2GBEWOijijgROHBlSGWiwhSUJqxUmxDzOwLx2SxhsNWzWf/UiOET2SIFIfQZ5nwd0Gcwy00m1A3fP2mq95fmK5CyMQJwC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    f90aadf1c67c Add linux-next specific files for 20260311
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12309806580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b10825359140979
dashboard link: https://syzkaller.appspot.com/bug?extid=e24a2e34fad0efbac047
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cb575a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14db4d52580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aca9c54a7de2/disk-f90aadf1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/736fd5e68863/vmlinux-f90aadf1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eb13b7d81d1b/bzImage-f90aadf1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com

------------[ cut here ]------------
address < vma->vm_start || address + (nr << 12) > vma->vm_end
WARNING: mm/rmap.c:1682 at folio_add_new_anon_rmap+0x5fe/0x14b0 mm/rmap.c:1681, CPU#1: syz.2.19/6118
Modules linked in:
CPU: 1 UID: 0 PID: 6118 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/27/2026
RIP: 0010:folio_add_new_anon_rmap+0x5fe/0x14b0 mm/rmap.c:1681
Code: 89 f5 4d 8b 36 4c 89 e7 4c 89 f6 e8 ec aa a9 ff 4d 39 f4 73 1a e8 82 a8 a9 ff 4c 8b 74 24 10 49 bc 00 00 00 00 00 fc ff df 90 <0f> 0b 90 eb 5a 44 89 f8 c1 e0 0c 48 98 49 01 c4 49 83 c5 08 4c 89
RSP: 0018:ffffc900036675a0 EFLAGS: 00010293
RAX: ffffffff821d041e RBX: ffffea0001c0c1c0 RCX: ffff888060bf5b80
RDX: 0000000000000000 RSI: 00002000004ca000 RDI: 00002000004cb000
RBP: 0000000000000000 R08: ffffea0001c0c1c7 R09: 1ffffd4000381838
R10: dffffc0000000000 R11: fffff94000381839 R12: dffffc0000000000
R13: ffff8880784ad788 R14: ffffea0001c0c1c8 R15: 0000000000000001
FS:  00007f9a968ce6c0(0000) GS:ffff88812553e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000002b8000 CR3: 000000007c646000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 mfill_atomic_install_pte+0x578/0x870 mm/userfaultfd.c:390
 __mfill_atomic_pte+0x3c4/0x5f0 mm/userfaultfd.c:523
 mfill_atomic_pte_copy mm/userfaultfd.c:557 [inline]
 mfill_atomic_pte mm/userfaultfd.c:865 [inline]
 mfill_atomic mm/userfaultfd.c:923 [inline]
 mfill_atomic_copy+0x4d9/0x1330 mm/userfaultfd.c:950
 userfaultfd_copy fs/userfaultfd.c:1642 [inline]
 userfaultfd_ioctl+0x2b8a/0x4b00 fs/userfaultfd.c:2059
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9a9599c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9a968ce028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9a95c15fa0 RCX: 00007f9a9599c799
RDX: 0000200000000040 RSI: 00000000c028aa03 RDI: 0000000000000003
RBP: 00007f9a95a32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9a95c16038 R14: 00007f9a95c15fa0 R15: 00007ffd373c5448
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

