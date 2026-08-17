Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104FDC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158106B08CE; Mon, 17 Aug 2026 05:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12FA36B0924; Mon, 17 Aug 2026 05:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046546B0926; Mon, 17 Aug 2026 05:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA1436B08CE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:14:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49318C06C2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:14:34 +0000 (UTC)
X-FDA: 85110200868.18.2338A9C
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94D99160008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:14:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 399CCagkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=399CCagkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786958072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=0YnkKb4Fet8hxhNIWn1tISjKYbWQvuS7wogHoFnXdVU=;
	b=ggeQ6avmvKrPIH8qxU98MelUjBGGZmd/pwySE9zz+ufTQvnHXN/kPKPgvRAr648RUAUgnQ
	WT/Zht8Tcyq0N2CKkwmq2Ut1eFSZzjkNYRpcOc3zA+O9boS6nfPQfbIkUG81DIbe9YA6+o
	hskZuSbfiXDn6uz1FdrzZFXXiosqFvs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 399CCagkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=399CCagkbAP4y45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786958072;
	b=vtZMounDNsmCiHBOrbyKHGlcSRJed8EmljYXDEl0JVMKQB+C66BMvPgJK6o7owPrx76Exo
	a24r02BZlLwCuPm8P4U6y4UtzLp3D5bj6+o6Z1f37x7JLdM6yA3ntV5W6AG0oe6OpqVmJ/
	Rb+kYQNwaYE5veKSvgFSGPlmCT2E8R8=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7f4071ad0d0so1743834a34.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786958071; x=1787562871;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0YnkKb4Fet8hxhNIWn1tISjKYbWQvuS7wogHoFnXdVU=;
        b=ifGX0aI/o4OsiJ1LZjw85Cmd6ITtYnFWdDdcW2lreGH3v0YRHq2abVpcdXgQWF/qun
         7r7mNNQ0D07zyozYrmo6iGfIE7IXuZ5O4yj/eoLSi5Zw6T1DJLKHkjNmdR+G/zjllQWG
         JxmHE40QNHS9n/po496Bt+Hr+54BJIjM8nT3w7EthrXgM/zASo3GLEuX4OkiMVc6n4QP
         s4AzZglIrkupmrYdHgBFnAlLKGMgko4P8PLqyVRUQgJ4RI5ndLuzHEXmXJhCqIdgcdEi
         EP+8r8xGV6QRSsn2YyY2ueyIPChzIUbndIHTWj9xkn6My1BCpI1sUSpfqFAI7xqWJZj/
         sCjw==
X-Forwarded-Encrypted: i=1; AHgh+RqXOBVpEkULoiy3RAJ8Zi6zPw2lvV9dMbxG5D7BLzCRtNIreSs2PevkOXEJLd2AvFhEEjc2F71xFg==@kvack.org
X-Gm-Message-State: AOJu0YwtX1fEEe174zU2wylV17KD+4ctn8Poz8MXwmIky96JDDcq3mMf
	lUqbsDFEmZ62gWFZ7pcLDgFvpXonPG3J7fhodlaEgzorgPicyrEFy5qmgW0mCIGIrBa7GL5ACrY
	TkXcrQ7JUQ8TKP24/hN/SA1Mz+0IrAjemsP1DbKd6NO2L3Eu1OTGOLuxeLo8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca2:b0:6aa:f0fd:3f0a with SMTP id
 006d021491bc7-6b0d68ebd55mr19778363eaf.30.1786958071630; Mon, 17 Aug 2026
 02:14:31 -0700 (PDT)
Date: Mon, 17 Aug 2026 02:14:31 -0700
In-Reply-To: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a82d0f7.dbb3a75c.20434b.004d.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
From: syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, gregkh@linuxfoundation.org, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: snba9jef6cbpziug513tcz9azzyqbzwo
X-Rspamd-Queue-Id: 94D99160008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786958072-292102
X-HE-Meta: U2FsdGVkX19K5iIHqjG5C85wJcgUWQzbvKxfAVRHTyWWH/0/jb1lfknQfrOHSu0+y/ODLQnYKAyyqYFafTMOr6cproRDcag6kM96/m9EKIJN2qwVWVeGs77wmzv5CswBrchyMk+kDGq6I87MiTHemczU6V7EZzQeHvDOsK9WHCAbFQAdrsJehHKW1jZBHmmobZ2eYIARhMvFE/ZgWb5vpFpX//YZG+yJKWZ/Un6UiNHGb0Tiz7osxO1IpVDq9e1p1EV/LmUoFl948plij8VlmB/HV+U/YCKg56k3992cfkfi002/4/yAnWG5sJOZBrqJtPhUeqh+qjo0825doc8FKQj/7ijKc40aQ8W5cXxlK4hT+/GydpbDCE0rxFT/+Jn+l/7Oe3TQEDhVCPQ4YxwcX8eoF5zSToYEEeev1denIIbNK0OpS0RNeaxrBb5z+scOy3zAPW5zyVJYZhZOW1jW+10jF48XX9eqrMiXlCbzEl+Fr4jL+O6kIvnthGbj/7Thj2C3Rs6iGMK5P3NLX5bDpmEy38ViWUJXNZYdq3x+Sh1X0oPMaunxL6ZXKy3v1oyedUg1sqTpzc2WU92hZds/Tuvyxmj/7aCZRa6V9mVGvYSmU8rkB1Rt5hNLUixtuH0hU+L7pdL6wqScqZd4eVKdwStAu6Yhme9O5YH6HJv3sMseuKInn1/9mZEBYXEw9hARRs/Tnmq03CGJKE75DLmL9+390tY2ResO+NWl1ekbj9EmJYYLd+yrsDajjT9L/KJyyMwHN+3Gex4v4vkKvARhypuupiN85pETWRAN/s2TfrlgeZDn361UFssQiXHiVSgPlhvOgctLnbTEFRJPxhNoo/PBD+E5PMyJnxt6HUt5eT3VRgGTM41e4Ic3vAuHssqx6hxG0xGAva+CD/R2AMoNzSYGAjUKgTzoPiBjEHYSiSGGAQVDQkpE8ONERNCDiKsQFxm/P9cW5YBdcd1rSRj
 y/08O7AR
 rAzsgj4CLPJNU5V5Bfhh+rl1ywQYJXplzYLI+TMmR3zLfj2S5+DSQwEvZ+w0rY219+9s7HPPlaKWM63DEjAnfB4/p3o6SkHOCZdQr1YJHOXwrblE0T/Ux91x1entenBZrgUdpoFejqpJxVauF/csyAE7CgO/5VLOt3aJaUkCUq0yoAcGgNPpZoQrqIEYyI7EHHAfUGOSzW0S1qWpozaIQV1zhlDl9k87v0qYXyunHpLKF9ZKM7UcQDb3RUyMo+e3j5V0iEDypqxhN2H5YZ7C5G0g0MuZAHVXaoLssbKn4J1qODMMgOV5bKGF3KtSXD4XgC5SsePU68BNIQVhOiNq29dNaUQ1gYhDwkQmV6693LuwxAKTlXAdImv3/S22cDWqHMySLb0S16I/zfTyX+yfh94qwx0IynXH4znAFKqQZifX7XxwexxLiij4E43weTLay7TPOH7+kRt535z6ZOKp7+2X6PnqQJvpyGU1xgHV3f6Vf9Dp+ffon7sjsi9Wk4eIsNqb2pHPMmgNBjnzrYJ6ni2BvT6+IAnYETvcwcs5gJZv32yGmZVIvulX0KFIkCoXbFBAQzRTu+Ic9EcpKs4PNaxNmBbcNjYfsbF6J3Z9tbFe5jtsyXsoUtMxBzRsEQcyicqbZ9dnXDids5KBBsSICaDriyLSxFcqdlElnRB3xX2fMtzxvr96QX8nnzz9NqanYNpNxaGsPRiWahu48iyPPimdJMx0/lUOcz8D7gfDL835MOwYD2UOYGY3gmkQQqsg4obhkpZCgMgFyxjy5swGYgUoj7DVW1AZT3HjkikWdKVd9gOkE8Ip0C8Ln2s4g59hDCOwPCBXxgWaEs65Oa/jh4jRdwnwCoZiz4GrzM+e1a79KY4i3fLGCtPgNWPBKLyp/p0NzOKSu5CmNH8T5VJVEyP9OdY8tOr3qClQ/VG9gYjdK/yvnhUcrIlVISTpWzWxmBaDw3MdoG2r2mPDZ+u9M6l8gmuwU
 DwJE1vPJ
 TQjMpVzkrLuUIfffeAEv00kJ9v3/b1rhwX522gip5fm3a2BuBuOLEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d3ae59288f1 Linux 7.2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13bad949580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d67342c314f228d
dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1637ea25580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com

gadgetfs: bound to dummy_udc driver
------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2427/0x2dc0 mm/page_alloc.c:5280, CPU#2: syz-executor421/6034
Modules linked in:
CPU: 2 UID: 0 PID: 6034 Comm: syz-executor421 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x2427/0x2dc0 mm/page_alloc.c:5280
Code: e9 8d fb ff ff 31 d2 be 28 12 00 00 48 c7 c7 a0 74 01 8c e8 7b 95 68 ff 2e 2e 2e 31 c0 e9 02 ed ff ff c6 05 85 90 bc 0e 01 90 <0f> 0b 90 e9 6f df ff ff 48 c7 c7 80 be f3 8e 45 89 f7 44 8b 74 24
RSP: 0018:ffffc900048c7810 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffff92000918f1c RDI: 0000000000040cc0
RBP: 0000000000000013 R08: 0000000000000005 R09: 0000000000000009
R10: 0000000000000013 R11: 0000000000000000 R12: 0000000000040cc0
R13: 1ffff92000918f5a R14: ffffffff9b95c444 R15: 0000000000000001
FS:  00005555738a6400(0000) GS:ffff8880d5dde000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd5f5d6fe8 CR3: 0000000020943000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 ___kmalloc_large_node+0xe5/0x120 mm/slub.c:5274
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5305
 __do_kmalloc_node mm/slub.c:5322 [inline]
 __kmalloc_noprof+0x5a1/0x820 mm/slub.c:5359
 _kmalloc_noprof include/linux/slab.h:992 [inline]
 ep_write_iter+0x180/0xbc0 drivers/usb/gadget/legacy/inode.c:669
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6ac/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7cc18b5cb7
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffd5f5d76e0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00005555738a6400 RCX: 00007f7cc18b5cb7
RDX: 000000007fffffff RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007ffd5f5d7730 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffd5f5d7930
R13: 00007f7cc18ea039 R14: 00007ffd5f5d7b30 R15: 0000000000000002
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

