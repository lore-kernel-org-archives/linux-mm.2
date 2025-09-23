Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B770DCAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18AB8E0001; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC868E0018; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62768E0001; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 807B28E0014
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:03:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11413B968E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:03:32 +0000 (UTC)
X-FDA: 83919926664.04.A87A23F
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40653A0003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:03:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758618210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0DBJDn6xDaiOhYMo2RaF4q11GLTSm+nfoJ4hteBQ+HQ=;
	b=zwPKPn5xsJD0ilV85QfleOJVDXeZG+sd3urDsixAKQXIbNwo+xBEUuk9ZdUsJ3pE4hWywZ
	jX3M89uKrX/inSrvAJf10lPXZZ/lHfR9asv4YaYlrL2SMsWvAEGSy5ClmMSBEJUc8kBxHf
	KwPtrrtLxhkVm4Mfhc5z4PMzh2RoGtQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3YWLSaAkbALwu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758618210; a=rsa-sha256;
	cv=none;
	b=syzF/scaxAxxO/plrMRzT5HaJIhzQoEFWUPOK1y+G3CZdNbNKwk10qSOzAdN3fxxjmFQXP
	townyQLdBEHSyI8hsrgmtTXkPV8YTdkDY0xY3+OkHamUiaujS67Tbn9qX+mtqpGSRh9+bD
	ntuZNVIhSxjR6qaRGS8RMpro9Qdsbeo=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4248d44a345so42685985ab.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758618209; x=1759223009;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0DBJDn6xDaiOhYMo2RaF4q11GLTSm+nfoJ4hteBQ+HQ=;
        b=KuW0U58zGPxuGtBlNduLGsO1LPIF1xQiAUhH0dgnVrY/7gx5DP/gWhtcfs1vpgVKt6
         MZD3+6oNNV9AS/+m6R15bSNsqmC+PlNnZs93VlvCN1P617KXBJk+G0N2DY1aqc2VorqR
         jfUnNO6wPlZ+m9NHtm9yK2n1cJZs+MG+hvAIqrR+7yKAnV7xOyMHqOOEF9eE9FJjV2zT
         02DH4s7f3f4PiUmIHp/QEx2nX4RRdAAmqf2jNfco5LpGHS23gIqNJm/hEnZa/LRBQfAe
         GrLBwPoa2O1l8SbsNtmFVuMVBPw/A1rb9s5H99AK40b6HYbe5DJUuGH8cx2civYCQH0u
         r2BA==
X-Forwarded-Encrypted: i=1; AJvYcCWOyz/jppdy5lxsBTwSpEgZIDQMbpzH9X5TjwLVO1TT9JN3WhKOsURQqXZguaBfh+DaLI2UK8HyIw==@kvack.org
X-Gm-Message-State: AOJu0YzKCeumCdbiOfAI8zZkkqvB/DoAEMyXir2rmu5VPcyhmf3JLu1U
	I9Dx6YwPDt7/vcpLPcdqzguZWsIgZFCDrj8pa9Lg3inXVXdHq9eBarCvrA+JBG5DLpELPCH3tlU
	+4ZyTnfNXisRAUQ5uIDrEY6yCMHn4Hh+aY/dAsCJXLXLqj/1S8gal4oLFgaA=
X-Google-Smtp-Source: AGHT+IE/1nhaPRURoqVDgGdxyupjZFT/6ioLFhQOG75Ih/hNH2NvNvEsaKQZwfJVfUbEhIe0M8hJycznVzxXLNPubyRxPiFEKLtK
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c86:b0:3f2:a771:9fb3 with SMTP id
 e9e14a558f8ab-42581ebcee2mr27557375ab.27.1758618209337; Tue, 23 Sep 2025
 02:03:29 -0700 (PDT)
Date: Tue, 23 Sep 2025 02:03:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d26261.a70a0220.4f78.0003.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in hugetlb_vma_assert_locked
From: syzbot <syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 40653A0003
X-Rspamd-Server: rspam05
X-Stat-Signature: uzyh6ecaaghkkopmghwj3unkah747qtd
X-Rspam-User: 
X-HE-Tag: 1758618210-158302
X-HE-Meta: U2FsdGVkX19o1wRm6o/SGjdEJCx9sJugJnIbdV4l96xOQ/txgc88SqNzpCwe9zWBz03SM6Wy3RuDB4rYowMKcvtuszk1Qgh7BHGE7IJuL/VFbbzEUiuvduMd7Qjl7+3hyh6L+WKRtnknLzLykNzoVDLhuPNHJzbLco2A5DEpzbDLn9P1a0J9Wfl4vNvv1zvc27lK2HgsnYwplzApeahl177XJyLBjrR19rqt+iHZhYuOuwm3u4RYfj9xCyE9wOwVYw/IVXo1KqReg+qPtLdMae4I8aOW2/NvTQznD7oRO950UKpz5TpYpsniiSOtaZixyuL1nbMq4K6xhKK/tPTddAQ7jIq3glJNloybSzNIps4977T+TOgMBR7icoZn/bNwOaLbYt8m4N/Ek1gPT7EAs1t+/HKdpEchG+lc8D49YrM8n0kqV9U7CLJQKD2GFQDkfmD291Top+Ifs7YtavQJqcF/24J2Jvb5+p0iCbFepCRiBnNJxwxRImqr5pcta9EpL+HmllPjG0Elydg23v5dwxbKk01M9/IK85qF22bhvjm5nw0bHzLsIR2/RGVSSyUUBlFjrVn0MQHSU8E23wmEJS/r0fqvh0F6ektpMKMH/edFoke4H8r7Ll9yGHmSgS+m1I4vZGYsyGDoNnSr5ld1u2LlrdfYMSnnpNKw5d0LIT4zv6iItN9ly1ePFUjY4BCX8YgI83+TRaPLnqPOugKEEyO3rFViKw2e/SUnMclY3F4B9FqToFK+ASv4asXmt285w1emeN4wO6fEgnIZsrBV8PWoFRnHENuam6ARg4elB8wjW4pYWns3C/NdVUSHTD6Bm3+nkHUYq9grF1f3p+O9XmuHbBqBxXYwVI7gw1hSD0KquB9cGBVyJrl2bm9bd3tHdjQfO+DDrKg4F4Dsb6KS5ysS8+TUSRVk6oCEpGsvFfYu/8m/2+pFyOq8HlB2NN/+A6yG+wwJtve6fmaJm5L
 UPLcFYhD
 4IiyRcmmvqcv6+xHicld11KBIsnvSntiuMWhH8mQ8iGAKc2QNmxdiMqy4zWIkYZgmTGhv0IKr2EBnIc6hJFukdYaqrEdD2ZKrU/OEkRPUkaTT+vxjGq/3fpj1yv3tqAYJPpK5nKVOPEd6nqXSQ8EKp8ePb13mvGHbu4BzxLK5chx/o8nzMM0eHxqqxo83tdZ5fT9nSVmnJKkmJliS3VFmHk+byuBnihIfMxJmIKOUFaL9u3SzprNaw1zybUXDXDE0iEm2iONFBpNPmkN4NHi7LuCLx0hX+mfhY53s/Ydm8NUZhz7GKSbYBEZOPN3+xqqStDaKZUI034tolEX4ac+st0XtSaChveUzi8WMDLQoT7iD4h2gfRPxrsBlg4mteZ+RkROvOGR71eO+qBMq3RYCbFUK+QHFw41gni/5iZXjUyri1ixFHGgBtRofnt+BQY5QZqPvHBI3QRv2FI4yh6ACWB6UUBQZgjVqxtwsNJUP043tEpkg+n7PhrAgsOAP7Qlf2yziHNPHP47vIslJuFrK49AygTfVnLZ3p0C7q8dPVuXTBHhacJK9JHKfOSJMLC0i+PqTkcQCXDCCbK3ESaTxC7hILuUBHqeETMV44vgWce4BPMcKYCr8Ebmk4vzN1M1UggYv98Fyv/qH6RPdgJRb6hkelMAuuCPO796TJBGy3ytvmq1GaFUlNDSBiRmIBoIw9vB7BVhzHtrjnLsGMgKeoCixJkv8vt5VJcbQ79FELu8VROjL5LB3YKsbkvHf8nAbP9i1dlSbA+iIGwWMTGIfPjE2EBX8CgAG6Fbp3/uTpRe2b5wiesg0qgxNj1oc4tKZ4PGzStTWdc1DMkGDpONhcRjugHKUGdp/LQGdKN9Gl6PcB+exrU0MLmKTJa32wJEsa9fcbaGG3yPLiYpDPCC5yQrGtWQTgu38xSolx8D6iYw3IzWKKHxqevusM1CVZmR6sc6MlAp4xXlq8yrcaJl1DHj9IcGm
 +MNHnkNv
 4zzlAbc1BCZqVGWdzlaEa3a0Kipq8nN8LNUfJcDlpuV20AiJQd1ZB4xE3BB9LDkmZT2pJHWv6NDPDjhmDkDbGMPYcTKuuybmILSZUI2OBiaK+iHOzDBbLwlPhGSgkdAbxxpPmlkQyNyLZDF+kPc4BFnbrl9TuyA3aLVr+nlz/FCNm0D+bKB4ys+paHBLFMliElGTd5DiADp0De3DcZLcL6mW9DEi4VTirGBr+VO6bK1kI2r7E4cpYdFdOg9HztQVYk774ULiukjx5Wx9XzXIJUBKdsoWtxgccUi5ZKvBojCyz415FWSADl/Avm1tRDwmw33ycSGIMsxq+Bk8k2EHKyutwHClWcTVso+WTpnB2R5xemsorYKBUR56uHSZ2QBK/H0+nNJ1NkDSrwqsinVeHKFK4Jm6/6BSmP19oVtP6t42avNaVU8GgRxLfF7glAlHC/dn9Q6IfoNU1r4kscJF+sboFb93YnRBF1AYfiyUo+oxnBhDQ2MqN74DCxghViV2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    846bd2225ec3 Add linux-next specific files for 20250919
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=162ab8e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=135377594f35b576
dashboard link: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b4142580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f504e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c53d48022f8a/disk-846bd222.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/483534e784c8/vmlinux-846bd222.xz
kernel image: https://storage.googleapis.com/syzbot-assets/721b36eec9b3/bzImage-846bd222.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/hugetlb.c:368 at hugetlb_vma_assert_locked+0x1dd/0x250 mm/hugetlb.c:368, CPU#0: syz.0.366/7101
Modules linked in:
CPU: 0 UID: 0 PID: 7101 Comm: syz.0.366 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:hugetlb_vma_assert_locked+0x1dd/0x250 mm/hugetlb.c:368
Code: 2e e8 17 e8 a1 ff eb 0c e8 10 e8 a1 ff eb 05 e8 09 e8 a1 ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 f4 e7 a1 ff 90 <0f> 0b 90 eb e5 e8 e9 e7 a1 ff 90 0f 0b 90 eb da 48 c7 c1 70 0b e5
RSP: 0018:ffffc900036b7388 EFLAGS: 00010293
RAX: ffffffff821e312c RBX: 0000000000000000 RCX: ffff88807bc95ac0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520006d6e74 R12: ffff888033642a00
R13: 1ffff1100f12319c R14: dffffc0000000000 R15: 0000000000000080
FS:  00007fa9ba21d6c0(0000) GS:ffff8881257a2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa9ba21cf98 CR3: 0000000078830000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 huge_pmd_unshare+0x2c8/0x540 mm/hugetlb.c:7622
 __unmap_hugepage_range+0x6e3/0x1aa0 mm/hugetlb.c:5901
 unmap_hugepage_range+0x32e/0x410 mm/hugetlb.c:6089
 hugetlb_vmdelete_list+0x171/0x1c0 fs/hugetlbfs/inode.c:494
 hugetlb_vmtruncate fs/hugetlbfs/inode.c:641 [inline]
 hugetlbfs_setattr+0x4d1/0x6d0 fs/hugetlbfs/inode.c:879
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3516 [inline]
 do_open fs/namei.c:3899 [inline]
 path_openat+0x306c/0x3830 fs/namei.c:4054
 do_filp_open+0x1fa/0x410 fs/namei.c:4081
 do_sys_openat2+0x121/0x1c0 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_open fs/open.c:1458 [inline]
 __se_sys_open fs/open.c:1454 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa9b938eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa9ba21d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fa9b95e5fa0 RCX: 00007fa9b938eec9
RDX: 0000000000000100 RSI: 000000000014927e RDI: 0000200000000340
RBP: 00007fa9b9411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa9b95e6038 R14: 00007fa9b95e5fa0 R15: 00007ffdd776dfc8
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

