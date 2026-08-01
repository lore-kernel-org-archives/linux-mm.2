Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD03AC55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE34A6B007B; Fri, 31 Jul 2026 20:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93896B0092; Fri, 31 Jul 2026 20:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA336B0093; Fri, 31 Jul 2026 20:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1AE6B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:36:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F73A01FA
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:36:43 +0000 (UTC)
X-FDA: 85050835086.19.4354EED
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48879120002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:36:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3mT9tagkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3mT9tagkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785544602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=FUoHlSVYyRWQcZ6/7tjmj01mDGscNWRNSzyTEDtffAc=;
	b=RQtUeA7q7Fxf3/6pSB9BDb9rnUVglvxXMOp/FbNcW44Pb64pRdsws7+4myW+n0YxhpIDJ/
	8/KjxJFGtRcZmRRtGOk807SFcgo9C8m7/G3QzoZpXQpPBq24ElS+yHjB8nSseVLg9AV0TM
	cUGj+I3x7f5X5npF4sraGf1+qsxkRuA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3mT9tagkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3mT9tagkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785544602;
	b=I09F84KFTRJKVP+DwJ8pW5NET4iZRLVXuxmydqUPTGLVF1r/jRn+EtXgxlRPr1IYvYlImM
	paD356bcKh+M/Cji422FXqHLebiY6D5GeVAlzjHO2GA3G4ZfmpgA41bFvnUQCxkLu2shaw
	INYE7wYUMkEHEOm2iZFf+fdAFGCSwXs=
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-495b0cf250dso1039430b6e.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:36:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785544601; x=1786149401;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FUoHlSVYyRWQcZ6/7tjmj01mDGscNWRNSzyTEDtffAc=;
        b=VUCbQlzDGxR34o13svRr5Uqrh2K6J+H5j4ys2HXunVOITbi66pLfxu6rPunBWhLdwD
         B0GP9GS92zkmngMTs2BVEWPtVPAOVNYioX0x+VUDYx9wJBe0KEFhYUxTarcyhIdAiGBR
         gD53Hsx7thAoHqEeULtfBrAOD4kFjEeJdakcXSP7vVm9EgvpZpayqSJf7//ejBIk7mPo
         gq+kefQRLKkvfKhM2VqSQqeBEQWIL7SMTKGdHHq70ER8uwtH4jrl7EFF2jf3q/i4Wg9c
         4/VwUy2pCZ30n5fuHkhuLB5l2IY5PtGa9ObYueoOocwBgtBmEDy6VC55pYUE3nQ2UkJP
         e+ow==
X-Forwarded-Encrypted: i=1; AHgh+RrfRy92awnSeC4888trPcBgpYBrzh64iHZLX04ySaQMZo9tZEbOzG5Z7l0rknRtfGxhmShguUzO8Q==@kvack.org
X-Gm-Message-State: AOJu0YxK7F9O2F/XYcRI3CmVC+cEOE0svMbvD5a0qzmqtMdDH8LIdfVj
	fwKleMrpZHqx4IE0zNp4CTZAOGPMN1JVIMsZvJDyu41UU+mPn5QD5tZDQMwXcR4KIBiaVTErKhC
	BD/tZ5E+nPOr1L/++iisNgSoB86/NUBXsWGT7ED5WGTv989lb7AX/b2Gc9W0=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1484:b0:48a:ddd4:d36f with SMTP id
 5614622812f47-4af5e0c2e55mr3930519b6e.8.1785544601341; Fri, 31 Jul 2026
 17:36:41 -0700 (PDT)
Date: Fri, 31 Jul 2026 17:36:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6d3f99.13bfb6d0.1ecdd5.0255.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in alloc_vmap_area
From: syzbot <syzbot+a308ee836af04d1d6fa6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org, 
	dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org, 
	kprateek.nayak@amd.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48879120002
X-Stat-Signature: c5wp31rb8jmjje1i1f4shdzyq1wukngd
X-HE-Tag: 1785544602-178026
X-HE-Meta: U2FsdGVkX1+86QZoU2u/zjEjpDTNIwAG8Rn/PGAMuVpTD1k8l0LKMbD0QMCjm+rg6lGo/yYzYxcbj5YMxtQ9wMg4w0N7/CpgTZY0GMM7Bb8IB79KSvxwp9p4WnBKwwRlvptIiGsxmtF3AZEjNoU2gNqwxTvuhZ7qpL3945X3+yEQX2VzEX8yo3tvFDEtfWf95P76JfVTr6Hy1lWbRJhGTquVWW7ltxgG7jPbopvFXx+Lk6mi0fEDHnWxnPlE7z2GkC/dnKq4REYpNt82dFRghNADq3kv4Ej8UMvXE6N60+5O3HGqAdSQ1MxkyuAppKc1wALv4YJcw0oM6VC8/dATrIlbSOLbZz6HhFZq2FWLIoVwkBxXVPwxWogmGIjEeJI0Q3R4tJHtraStBm1fQQ/GKgbxZRNGz8L3hQRQvVJ92i48PMVt1x9ClJGYWQcnDSVBe2rdZ+dpP9TraNIgEaHfnCCTmSO3mRtA/XhyxyJBgG+xnx9KSmjO2nqyN7WnsbHt75Zbj6VMENxXbpeFomC8Q4LxuPESi5hiD67egH8pAhYE7d3znSVsVPM3kc50gXMOUYQHK0gcFsr7TKfIliehbbEHjqXsG7yoZvn9DGcxnkUCNkgqMpL2r7flr3pR+dADcfEtFhFFb3Pdas5lSozogEGPCGj5BlM44OIO8o+Z3bgCWv0hlWj3WqilFmfsmb4pIElYH2HnDcUWPX5PfguHWF/xyKVIaBxdBknnc3v+J6Zb3sfBdUg4cXX3ZD3RujOqmZcgFWu4V7yykwTDAAvobaIzrMTn3O6fs2+Yn2oqudP+xlXe0tca3EF5/goYzv00li2FhY4yONTqTv+i2xDLGBFDrUFxW0qn2oHHLUzCyX2ZwgimJpjM9iIA6JV4tMiS2EdVJQQMv0rYcO+BI8l8FnlNW0t3h4eMPlc9iBmLlv8WBT4r/0atWKj6Ev4ynK/1EPdiXL8zyX23p4ujBvo
 zZl9wsBg
 82m1UmoUX29ZQofsZfQK8XJiy9ekambP2g1AESR/lHhSDW7+stJF6EJR8aLxR4NdWclmctiBIWsemoxLF/Bp8LcfqPtAmiDZn0wKIBLuCwLvLzU9ZftnbWUnyeG9aUFPuorTfy0aQiovJZ33pfOezXX6buwCrTOpTnmY2Do0hn5eeaLjgo75jOX6bwc0yVs7qroSg1p7pA4hHy3LmQXrwENRj7+u+MD+DwfZUAyzfcgkCYyhuYEuNwF2R3CWa7zrd800dLPs3meB8gMnG3vCTxiII7uyGEBiRJtepXj3MYKdMb9vVs+hIvZYmzvf+6x6SS+nNB9eXxgwr+ij3672xJ2WWd3/mdx10lukkxIEtOc8gQdjVSZAVOFVUXOyXwnk30wcHHpbaczwO9fFeXgDs0Iaqu9vjeIV8tY03DFrSrtpJa0IShNIcFfItwN2vXPi6OzuJUpsVkgnl+7z5wybuWO0QYz6OEPfWGsCsUVObgHJJTwxffqENyE5tz/LbrEayOo9aR07M2SUr8kCUVC0U8kf96hn9vFQjr8NKAe0PexbeMiy35uG9P4EmYYIs6aoHX/hdl2JfvEG16bIutTLoluJdKuKeRonOVfOrgzputvqMLO2P9/IFDTn8VdG5CDWuomY4vWzywFouCKg6cl973Ux0J/StGxoq3zi56gu/nuPj2pkpU8bqQCNel1+G4wjS3/4X2n8vN8HlsrUBKQuWEU9pbJbXbujmtbXhXPZ1/2L79/VNKIly3ahB1z4dY1d0scSCIDeQ1L82KWgl0stdO3onl9zf5mAtl5VDXD2CAYLbMmCyIVrgVXB7d86pfi/EZwnbrrqgrs7/twkF/OOziCzmx5aNzT3hq4hPHAZhCHbimhLpm8dYtMtSZ/GZBB0vqCRmE9nNwHLZCKFk9m7LrUSvISQvRb45NdkH2BiKXmJ81Qcuj99HJwg78NNiOXBjJNrZfP0bz9k0xzBVJcw2WgudSZRZ
 PF7lXNKV
 sEVnc0VSWdanv7zqiOnkqwAXvicoBHklsO6u8UNmrn5PzePTpxi5ik4ObNLA72MT30kXzqSCTDXt9GTQmzE7bTjTdSiQBFJKUS3SUh0QN3rltDXhS3o0Spv6KGr6j8EiU5WJw1zevs78c5Xr46kWXv89eRhZmkGsLe2lIQIVC3cpJabfeAvGEEPo8JcDZryJ7HNci0WmSUt2pqXV5bz2fFqQakcj6fYDqBASyG2KaDo4sqvIzL+GS2k9i4h0rsN10Pe0sgt/7+eqrc//mxy+6yOV3IZlE47jvbPujTFAlwgN6kPw+ISPMCmhbd6R1yUgDKhwPBpgYnrY7V7oKlXfWQ8nvkBdTYmMzW1KebkD8Q0LtXManEASEs6nC8uylEkA90IEoBO/jP8bh8sVM6pui+dQUnmgLbos/LiG7f+tNvDN941x3QhdKdkI3eIc2hCkY2XLR1LUCBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    11028ab62899 Merge tag 'probes-fixes-v7.2-rc5' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165f9499580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f221a1b5d497ed15
dashboard link: https://syzkaller.appspot.com/bug?extid=a308ee836af04d1d6fa6
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-11028ab6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/50d1387eb51d/vmlinux-11028ab6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/30ffbd0f8cd4/bzImage-11028ab6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a308ee836af04d1d6fa6@syzkaller.appspotmail.com

ret
WARNING: mm/vmalloc.c:1820 at va_alloc mm/vmalloc.c:1820 [inline], CPU#3: kworker/u33:7/821
WARNING: mm/vmalloc.c:1820 at __alloc_vmap_area mm/vmalloc.c:1855 [inline], CPU#3: kworker/u33:7/821
WARNING: mm/vmalloc.c:1820 at alloc_vmap_area+0x17f6/0x2bb0 mm/vmalloc.c:2073, CPU#3: kworker/u33:7/821
Modules linked in:
CPU: 3 UID: 0 PID: 821 Comm: kworker/u33:7 Tainted: G S                  syzkaller #0 PREEMPT(full) 
Tainted: [S]=CPU_OUT_OF_SPEC
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_unbound call_usermodehelper_exec_work
RIP: 0010:va_alloc mm/vmalloc.c:1820 [inline]
RIP: 0010:__alloc_vmap_area mm/vmalloc.c:1855 [inline]
RIP: 0010:alloc_vmap_area+0x17f6/0x2bb0 mm/vmalloc.c:2073
Code: 48 8d 3d 8d d8 c0 0e 8b 74 24 10 67 48 0f b9 3a c7 44 24 70 00 00 00 00 e9 95 ed ff ff 48 c7 c3 ea ff ff ff e8 7b b0 a2 ff 90 <0f> 0b 90 41 be 01 00 00 00 e9 ae f9 ff ff 41 be 01 00 00 00 48 c7
RSP: 0018:ffffc90004627458 EFLAGS: 00010293
RAX: 0000000000000000 RBX: fffffffffffffff4 RCX: 0000000000002800
RDX: ffff888025aa8000 RSI: ffffffff8266fbe5 RDI: ffffffff8e46c938
RBP: ffffc90003389000 R08: 00000000ffffffff R09: fffffbfff1dbda96
R10: ffffffff8eded4b3 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90003399000 R14: ffffe8ffffffffff R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888096ee3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f7f3a190 CR3: 000000002228f000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __get_vm_area_node+0x1ca/0x330 mm/vmalloc.c:3226
 __vmalloc_node_range_noprof+0x228/0x1630 mm/vmalloc.c:4042
 __vmalloc_node_noprof+0xad/0xf0 mm/vmalloc.c:4143
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct kernel/fork.c:929 [inline]
 copy_process+0x7fb/0x8030 kernel/fork.c:2115
 kernel_clone+0x176/0x9d0 kernel/fork.c:2748
 user_mode_thread+0xcc/0x110 kernel/fork.c:2824
 call_usermodehelper_exec_sync kernel/umh.c:132 [inline]
 call_usermodehelper_exec_work+0x6b/0x180 kernel/umh.c:163
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
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

