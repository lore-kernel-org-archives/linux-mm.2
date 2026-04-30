Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F537FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7278F6B0088; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FEEE6B0092; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE5D6B0095; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9926B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:21:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E35838BA5B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:21:37 +0000 (UTC)
X-FDA: 84714377034.01.CB26D6B
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4AAF718000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:21:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777533696; a=rsa-sha256;
	cv=none;
	b=qkaBeKuBC7nItqocJJWkotGRdmdSLo8XMc+SfQBNKCr9FUjpEkmUOOw6mbPHrG3iwFk6RC
	3UOYHO/TePdaW5bVpqkmeRc4/dO2hLJIdSr/Q7ANdoTb/7tbBk4KiWCtjP3LyqzAL789Tg
	A/e+pZETPrbygZimPSFEwU8WrHzmJeI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3_wLzaQkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777533696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=r//CU6HuwR7E2ZL48Hf4GCxfGXx9MMWo4dBoAMxQudA=;
	b=DHE85/hx++oXB2ptH8pQRJTyiyaWsg7RRcyZ78zhp6lQW/DmxmVbN7n0M/3ExeJcb7SKFk
	1X5OPktlmAYZf8csCOLTOVJgIpFZvaeyZMrLMtcA7RWVqV8lFGZCsCcL8nFy+4+qGa17E4
	Idym9JrXxqBAXFcV4WKmNrr4v18/zdE=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6961e8fa90bso1290233eaf.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777533695; x=1778138495;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r//CU6HuwR7E2ZL48Hf4GCxfGXx9MMWo4dBoAMxQudA=;
        b=dci/VDNmDDjnEem05FU+W1yvEJsP04uOOg3VP87aBSlqCsR2+UJ6gXgZwKhkSCSxml
         6exaCZ0Vp9StrZG7RbrfEM6dCnN77edRFNNob6koSyAY5pvDSBI5DYD343firLH4vQ4d
         bMiGcwjDxhu8WVqBScWmijZvAHI8slZiGrCDS23KQ9rzmUECzvG3x5qidbD1r7gsz7Za
         WuMOOxvphXrdail8/75DSZSJuVqrW33BODBuZ1ZJPWqucARwFzBpCasG1mJn5X69mo+F
         0F86rQQEp2KxD4Ty6sG1O2CRUsKHcQlg0NnJHrkA8JyUKGIjIB6v9PDeaxRquC6SSDLf
         s95A==
X-Forwarded-Encrypted: i=1; AFNElJ/snPDvocTZpb5FTCdzEU5bxBqNwn8u8jOYmYdk07gDhAJq9l++osyBzjyI7dAK7PD0uBz7bl3qyg==@kvack.org
X-Gm-Message-State: AOJu0YzCRko0nKXMthhMkQvG0wErxr9XTWhnjl34ah7cCLXzB5Iw4oBm
	X6xI1g+p9yqYFk61IeMCUmt/RCIXslimCfyTbmEiIMuuvxSEULEwT3YtkL4lv+RJY6n7Bu3uMof
	mMRG7E4I28B+gi36vtgT/EGQa5vhJiRot4xxwQFrh/zJ1doxTwqj3K4FSwrQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7815:b0:696:7f04:eca2 with SMTP id
 006d021491bc7-6967f04ef40mr115403eaf.9.1777533695324; Thu, 30 Apr 2026
 00:21:35 -0700 (PDT)
Date: Thu, 30 Apr 2026 00:21:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f302ff.170a0220.3c4978.0017.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: bad unlock balance in folio_remove_rmap_ptes
From: syzbot <syzbot+29efe1495eb3dffd2662@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gjo1aqcqyku6d7scy71azhc314mkfy4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AAF718000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1777533696-969328
X-HE-Meta: U2FsdGVkX1+puT53Swdd2jWc5fq+5Ss4JyFh5jaftXwyUGqW8qDpPnMb4S+EsR3gOU4ltUvFuSiAW1/BXQ+xLEBhkkH3xcJKzDPhWW01d9Mm4f6nWQehQG3eyxzJejsdhzUl++pL93MqdnsyhoPEh8ZAALN7c9h+Gb4rLEpiMBPIy+oJckHVuXQqdoxTXMhdTeqQWSaZ5jYTO15g5ipSYZCw0Uqla0yIROM4+f+6MHyw/jU/iIhx5rBGDqNxx5fybSeZ8odaVHuJ+W5cWhowNOlNvchiGhIHPtbI0qk19Xpg8eUQPKlmW4G0cUKmOWVTlTiJWKKKeKXAoQlmWDxcYyPNBeFS6BfeTyKYkCKT6vddQJnfaKu6CqOIrAaMuGgpvS+EvBkziUq9GgsdhXHoiaIC1FxGILuUy7tjojcSiljghL+f8xoqdIhizv7grZddZiJcnMK10NJFISat/zJrjfBdWYafT/XeKlAq098DG0BF99M010pKohzc3CSxSa85UtyBpEpUXTGgo2fSAThYKU3E7NoQSd87QRMWDHs/cXcQojY//iRVf+0X+OUSjOb5TlX7V0N5vrsGnRQ76ZhE2gy1Y8ua/1SHk2pVOArKy4ccOIMautTKjddg+solk1VEadX855kJ+cYkDWe4kjsd80A3AB+8yrzDEJNPghoTMT3cNpYZvFdCoq9YcrJTRt+VMurqkJJwnDFc/TgPHvNjZd6oJ6MuuGQvBJxM5v2wzeZmkrEF6u5GjZzJsr11YORWL+8uGWvfAsPclX3+CXdpjs2eRie8O2Eqt12FzvVPV99r6RudseMBNBYAFWgUJf48c8szPOmExrmz/CqutiNFnwaBlhB/K6rv4lHMf7NMxDK+Du4CTJvuVnDGg3gSF4/vmqJZt85DdQxgEj3PYbyBy+RLhqszC1C98DKv1cgjTuIeuvw+3ukSePKo2vTwhiEmqzQJOjdkEgcRfexEXCS
 RgwJpTEk
 121ECJybsTpykYS0+FjCZ2Q8DANmvioOqEOyWIJvHQezNPjYKdyTRU53Ve29WyapYj1W58eeBLEmKbPCy0c6NMgI357P9HHA2kBeilUo/S8gO5Bhp5MnnG5JVwSYSR0Brd5sdaHnE4sD0nOTb8lCa9E+PMMnRG/qpIfcnTPUdEhexksqehZVOL51zqXf6LlRs1vxro66Qd5QC42gVjnCmZ8/mpwTwmD6bxxzv39K0dLKmLOCVdeLYSmHSwMF/Vu0E7Q32bH0lpIpC0ToRGTFxGdI8/6oBij+KvTOKcUAWN0W7VoWTj/+B/3yFZSi3Fdt6FUDYq45dQcP858//Vd2DBxM8GlautKEJhwpVOKVbT3CKKp4In0Py/bvWA2pPRs5kVHKc8wnWXwr9TINC0TPDWDqUMlIo9soWTKcCAg1S+ZluSwScsksq9Hd91KkfEe8v0s9daOoUdsxNyUOgtrXZTLEgreaaS+lyvDK+dNniUYMpBs9BCfHbG5/dyURpi6Zfp8sS1pG5JMmOLRsX2QC0frxF9HmT4Fi65zIvO64C+9Qyizbx3cMJCVraWx2b4KimZmOLDJS0++KOs8iyCB3U7XKKQRCjOjNg+s+vI+W+EFTzXC/KJz/zpqZuXDjhoB/iBrsAzBLW113TPY8VaJOzzusmFzlAsUzyevMsnlUjmv9NSU2+qR4UZImSBUUIbPopjFBPbSzE1J64KA2QJcJ4auRB9/f9uv6ayHfYoVg9G4ymFPNCRCNBb+SdnlfYpw42LL8IknpHkN2fAOqtAU0dK7R70Lc36HmcuF1aby6LMxAUtqqRSwg94Ul4CH62vRAZCQ5iFVvTYv6IXTQwutXYJSyos3/7A16Ic6APYtZVf+FMI5cqncxncZPm5dJpCG32BOr7ZphIlbZNz4rSP+4oPjzRyOvt9PLTORvmPL0Xyvecc+Dh82r9AFNR9EMpm5IHoz/KtRjNgOsZMWZbDloegBPVgnFM
 m5KuWg3v
 EgTVmTrclfmHjszR84xmx2+GmC/PoyTHR4b29SuTcY2OfuyeaAcfVRAScMmHumMs1L161r2uoWp9vvOdIYN7a6LlgyC801z4PsT0iVb1JFBtMLixI8FBrY4hvhzeeMntLyKncevk35A9OhdZpgu8UDs6GCy4ECDODj9U75R/dF9+xvya+4RiniegQsxLlEpX5lkJuFxbkJy8tT7sKacvxsdp1slHty+6o2lzniueHhBm4fgDdVsP5qE12dKvz9Qesquetr6/KJlXTfQ8USUuS6akidPvUVQoAvEzuzci/AuFgpMvJdugBL/P4mZu5btU3ykNie+eBsEkDYeT03JJw3iJTjUhatoEXrVVpvKwy1Kp8sUgqjXlMciRa9qIhZSBY6pRpcidj0vCoAjbMFv1ajgNRc8daKPGvs19sPFA0GWmY/m50qoOXp6/Cw47GYNGzB/TrMP0UgkEMAxBIesRmgb4b972aJ78
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    897d54018cc9 Merge tag 'fbdev-for-7.1-rc1-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123409ba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59da38148f3a3d24
dashboard link: https://syzkaller.appspot.com/bug?extid=29efe1495eb3dffd2662
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-897d5401.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/20848bcda8fe/vmlinux-897d5401.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2351a3d1bb73/bzImage-897d5401.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+29efe1495eb3dffd2662@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
dhcpcd-run-hook/5684 is trying to release lock (rcu_read_lock) at:
[<ffffffff827e7b17>] rcu_lock_release include/linux/rcupdate.h:310 [inline]
[<ffffffff827e7b17>] rcu_read_unlock+0x17/0x60 include/linux/rcupdate.h:869
but there are no more locks to release!

other info that might help us debug this:
2 locks held by dhcpcd-run-hook/5684:
 #0: ffff888036590338 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:592 [inline]
 #0: ffff888036590338 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x124/0xa10 mm/mmap.c:1284
 #1: ffff88803e19f558 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
 #1: ffff88803e19f558 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x10f/0x320 mm/pgtable-generic.c:404

stack backtrace:
CPU: 2 UID: 0 PID: 5684 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_unlock_imbalance_bug.part.0+0xfb/0x106 kernel/locking/lockdep.c:5298
 print_unlock_imbalance_bug kernel/locking/lockdep.c:5278 [inline]
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release kernel/locking/lockdep.c:5889 [inline]
 lock_release+0x28d/0x310 kernel/locking/lockdep.c:5875
 rcu_lock_release include/linux/rcupdate.h:310 [inline]
 rcu_read_unlock+0x1c/0x60 include/linux/rcupdate.h:869
 __folio_mod_stat mm/rmap.c:1336 [inline]
 __folio_remove_rmap mm/rmap.c:1873 [inline]
 folio_remove_rmap_ptes+0x79a/0xdd0 mm/rmap.c:1900
 zap_present_folio_ptes mm/memory.c:1656 [inline]
 zap_present_ptes mm/memory.c:1714 [inline]
 do_zap_pte_range mm/memory.c:1816 [inline]
 zap_pte_range mm/memory.c:1918 [inline]
 zap_pmd_range mm/memory.c:2004 [inline]
 zap_pud_range mm/memory.c:2032 [inline]
 zap_p4d_range mm/memory.c:2053 [inline]
 __zap_vma_range+0x1f72/0x4bf0 mm/memory.c:2093
 unmap_vmas+0x299/0x5f0 mm/memory.c:2162
 exit_mmap+0x1ef/0xa10 mm/mmap.c:1300
 __mmput+0x12a/0x410 kernel/fork.c:1178
 mmput+0x67/0x80 kernel/fork.c:1201
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x833/0x2a60 kernel/exit.c:963
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f86edb946c5
Code: Unable to access opcode bytes at 0x7f86edb9469b.
RSP: 002b:00007ffe0360d588 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000556aa8bde2c0 RCX: 00007f86edb946c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 00007ffe0360d8b8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe0360d8b0
R13: 00007ffe0360d8c0 R14: 00007f86edda4000 R15: 0000556a73d27d98
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline], CPU#2: dhcpcd-run-hook/5684
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430, CPU#2: dhcpcd-run-hook/5684
Modules linked in:
CPU: 2 UID: 0 PID: 5684 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline]
RIP: 0010:__rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430
Code: 74 11 c7 45 58 01 00 00 00 bf 09 00 00 00 e8 c2 6f da ff e8 9d ff 22 00 9c 58 f6 c4 02 0f 85 dd 02 00 00 fb e9 57 fe ff ff 90 <0f> 0b 90 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 54 76 88
RSP: 0018:ffffc90003bdf718 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff8880285b2500 RCX: ffffffff81e7b7ae
RDX: 0000000000000000 RSI: ffffffff8def8e2a RDI: ffff8880285b29c4
RBP: ffffea0000f25740 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000001 R11: 0000000000000001 R12: 0000000000000001
R13: ffff88803e85cc80 R14: 0000000000000000 R15: ffffea0000f25770
FS:  0000000000000000(0000) GS:ffff8880d6579000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556aa8be3b11 CR3: 000000002c8aa000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __folio_mod_stat mm/rmap.c:1336 [inline]
 __folio_remove_rmap mm/rmap.c:1873 [inline]
 folio_remove_rmap_ptes+0x79a/0xdd0 mm/rmap.c:1900
 zap_present_folio_ptes mm/memory.c:1656 [inline]
 zap_present_ptes mm/memory.c:1714 [inline]
 do_zap_pte_range mm/memory.c:1816 [inline]
 zap_pte_range mm/memory.c:1918 [inline]
 zap_pmd_range mm/memory.c:2004 [inline]
 zap_pud_range mm/memory.c:2032 [inline]
 zap_p4d_range mm/memory.c:2053 [inline]
 __zap_vma_range+0x1f72/0x4bf0 mm/memory.c:2093
 unmap_vmas+0x299/0x5f0 mm/memory.c:2162
 exit_mmap+0x1ef/0xa10 mm/mmap.c:1300
 __mmput+0x12a/0x410 kernel/fork.c:1178
 mmput+0x67/0x80 kernel/fork.c:1201
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x833/0x2a60 kernel/exit.c:963
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1117
 __do_sys_exit_group kernel/exit.c:1128 [inline]
 __se_sys_exit_group kernel/exit.c:1126 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1126
 x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f86edb946c5
Code: Unable to access opcode bytes at 0x7f86edb9469b.
RSP: 002b:00007ffe0360d588 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000556aa8bde2c0 RCX: 00007f86edb946c5
RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
RBP: 00007ffe0360d8b8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe0360d8b0
R13: 00007ffe0360d8c0 R14: 00007f86edda4000 R15: 0000556a73d27d98
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

