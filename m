Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B825C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97A46B0088; Fri,  1 Aug 2025 13:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D703F6B0089; Fri,  1 Aug 2025 13:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC546B0093; Fri,  1 Aug 2025 13:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B845D6B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:38:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B88B113F9B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:38:40 +0000 (UTC)
X-FDA: 83728898400.29.02E8751
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf03.hostedemail.com (Postfix) with ESMTP id B3CF820009
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:38:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3nfuMaAkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3nfuMaAkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754069918; a=rsa-sha256;
	cv=none;
	b=Y/nyOrtWUdnaHADXCRtHnL+mu9lZhfOSCx5m79Kr1BJv5PiTAPa9Ls1NkbWaKHkia21FFg
	aHRxIxsiCssp6ATOQz6DuueiUmLbE/wld2oZSa41TH26askhsXTSOZ0cNHw+3DUY6l9phm
	LTijPRcoleGRg4eZkhrcwaFCuBb7Q/8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3nfuMaAkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3nfuMaAkbABQCIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754069918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=jC6+HaDPuCHZJYlINPrCsO+9NjDfze3yT/eVSA8l9YA=;
	b=A/MzQ9b5IEonO8rKZZvtTck3XVNRlioqVc732CQ5Tf05XFqkWaJ9dHSAyD3VdUjmrhLyUi
	za4SYN/xe5Aafivo7KI7BecbQ/YZ15n9AzSD96HiHyd/lqpRKI4xsdETdEUah4A2oP+7R7
	MmgzeYKNdCP0GrR6S/elGamCsglnUBY=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3e3e69b2951so20988115ab.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 10:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754069918; x=1754674718;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jC6+HaDPuCHZJYlINPrCsO+9NjDfze3yT/eVSA8l9YA=;
        b=E5zI3hxLoJKgJ3dWgneYhvDjXSS90jhvzd5GOobNmaJOFxOEBNxA1cyZV89x51UMQp
         kcTQgTBvKPp+CVGf0Iqn7FTnNJV+PxaQoUcRAahMHzS96Nx6PfjpgwKiuKnGM+Pcc04X
         9nGsqTGL27mD5kntmQ1XxwF+b0MYktf4DEIP/T3RgMhodd3IOBRYypZNZB/gZ74K9jkm
         dyVEY2NWqvAPu1z13c9M5yIKdOFMDBlwl8wJGccHqBFsEjrr4pUX+r87KNTdS/Adp1Mh
         AmUt7Uhq29C8rXfYK87sN+9ICns+SFbA/0OZhwQTXLxjN1R2cJJJZflXtijNzyHNlo12
         yJig==
X-Forwarded-Encrypted: i=1; AJvYcCWGwfiwwrrOROuTi3LVM7pmMykemF/rHyIVmQTRGc2rvOZ0T6NHg0MBZFxhnr53xa5k0ozo6S7/ng==@kvack.org
X-Gm-Message-State: AOJu0YzrvpNVmngxhGCKl1tViZjViYFXbTzGRJZ1Sdo517NSV8KiWSsX
	hvz5WDKmKGLJe89ckNP3GsQ9teRBQce0grJrDWVRyeTR281ctIpmkl6drdu4Qmkwnt8nK1ChNXa
	W4aMp2UI2S8LI6RP1meE8PULtTzeYhKqRBGD2FMUJm1/Tne3mPR8vAfFmbxk=
X-Google-Smtp-Source: AGHT+IEgrz79XLf17kxz+VSuZ/DrVwHlAKwGFOv3ARCEw+DM/XZ9vs9zQlH1y9gTYLROUBFW4w95QdOgEB3lvUsw5NVxl/nCNqdT
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2166:b0:3e3:dcfa:eadb with SMTP id
 e9e14a558f8ab-3e4057ce907mr111020085ab.1.1754069917770; Fri, 01 Aug 2025
 10:38:37 -0700 (PDT)
Date: Fri, 01 Aug 2025 10:38:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688cfb9d.050a0220.f0410.012f.GAE@google.com>
Subject: [syzbot] [mm?] [ntfs3?] kernel BUG in set_page_refcounted
From: syzbot <syzbot+2a0d2af125c01db73079@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, almaz.alexandrovich@paragon-software.com, 
	apopple@nvidia.com, byungchul@sk.com, david@redhat.com, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, ntfs3@lists.linux.dev, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zs6ippms1i5xkyr136w3np6dnfrz5abw
X-Rspam-User: 
X-Rspamd-Queue-Id: B3CF820009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754069918-267476
X-HE-Meta: U2FsdGVkX18DYyNjpo/bpIhbRAU5p5Ck8q4/9kJLVadYG3zdRvJU2ZqWZ4rIH9HAQXNwvFNzaqqsniFJSIjdl8x/+2m3gvkmjIObRz4zC9r1xHl0DPkEMVicZgehqa2yBA2DceLDa1hunun+ZmTGY9Z0a/j3wyDydxbb7i26SgVFsoUKw+v+h/fJBTz31cnFRRVca9wEu+bRMN9223MZvnB2jlSr2ONJ9XnAmHmPMjlvULnQbpZnzSKl7n4UopWtKJoUMuJqN0En50gr9hS37IMSBeVGZAzYo571SaHSD01kA3ypprKKIZ+M2jwhHLeo+7Eh2AyIa+nQcxSIF0BpIgTZz5tzP0qOy3eusgtTLr36PcbqNlRnpe1vGeekXFYO7ysd4susL5/ktw7avfCMZr5YYfLtyor236lJyxddVQDLE7R9E/u8P+ep5cWcEUb87TBG6uKaSPGxE5KdG9U5QolbGAzfqLyOsoAnF7ZZn+BPDAtch7nrtbVs9DzLlsMFoPMkWnE5en3UX+1NDVTeaRgEw+LsW/18QcW1AKphahLOnti/cZB4k8KrECXtkp56oNt/f/UEToaE4KY6u7mPXyZXFrl8A384a6IpbMe9SJz5T8h4PKqsiIesLvG0yxvo5PJ6QEZaL3YDZapqB5dGD+h8l1X8LJPT+t5JP8DOxlpcxmlR08zhsS/SANkDq49T2i8q7nkVPtiIoEDhn3FLwqF7l2jqovrBf+e+LWIjmEsoj7/AavDpTnS8fQG+cOEi/82gNnkaimJrowh2sklXuX3yWkwLauk31p56kwd/jIso8cw6XPS9U3qkCNJjLiE20oxmlUOQpPGJncuxjV9lX+pzQFuT745+0ldnaoF//fty024X1/jcr0th8StS/I5lGXdz0mpK0X7e4He+mohdY24vSqBzAirfNldvN3WNg8y5GKA4SToQqfXGimAYksR7U8Wn0mGNeu9lE6aSVZD
 XtsFrwZr
 Z//Wlwd3O+upoOpwCW9U4UWsmZ0B9bwXrk+Li4ZozkUBEdDmxtPlpMhGGrDLH+BeYZlpAns6QrPPadRVSuJZ4/sTPDR6Xght514ogLs6L44HyJBDY6buC1R8ZBBEKTLHbv3TyUh723j9ycJgRJZgvst/moiABTee8skCT0mwGaseFKA55b/R40kjXPUHYr8N0plME+mhJpFLukByr/9n4zN51EnKA8w/r7qoaBS8S1acUnaQ2Ln4FTEuBoZg9dC1Y6SrW1RXs7ejOXyF6CwmNigXXNQyEyqILnlvwMRkWP1oyoo36Ti9Li8wtJTe8minc+zSMU8lsYaA9mDV+CQe6mjHcXq90yWUGM+kcDYqOC9YyIWs0gKek5pElLD4uagYn3jBdsyg6urgH1A86YFkKABlCT1pu2ANiLkLPhus8/Vix3ybs85v09aGUOXvgrXJVsU2luKig0X3kqwNNzriosrPlXEmOnIogt1UbEOkAeXamj3uPOUeuH+6FJ7qXJWNcTz83+EJQ3UiM5Wx/+G8wyG79tkNtW+Gal2yAT2Qfe7xicnCd1YNFwzlusnFEbih8KGngM6/36st2CvktX9Wq2Q+xBRxH+RHRujrHk0V+uOQI53KT9A6ycWodh8O++E3ADMVSrvggh1MnzTkjU66D3Clevs4DgHj00ctYJkFfgnpsYFcDI8MnQAnRJMUgHKanbcEUsuwualba2hLw7s+Fzu0lVuGMJKiEUfA11mTZOfVUMCzRbVh42DNCH9HD9yu8JCJMLK/7c73tYMltdxs77/pwm77C2jVTZxlD07KFBI6Nb/gpWBu/4yFrJ0QSF0z+ovExLDrMLFRWRaoqFvYIGkNGXQiVsegwCA9jxR3HKHmNP2UMycOXrPrbu46PqkNX6SbBBrsuzxcoBGY5IVTgoYA1yUZ0i+h22jZ8DaAmLZ1pt6P40nhqYFlQzBmiBDvfdIpSf7Ym4CqhILOVSsuTvcWBA8n+
 9FeHV9tt
 ELxhy+Mx3b7VDNvdrQ+dWLTwA4JMnoEKxKS+KRh5hCAe97Xg0KKHVWahZ4E+2dyP0rfGO0J3OMPyELNGhkC7grC1jYTYbgxvqSl21GoMLCZap9Wvxfh43jN8ev/oj21wrRYdkoPROGCUmqTC0yA1k4BXGWjrjM61YQzBDmxXLGRi/hgwhxjS+BBoWywT2kRo/T2a8gpGbHtkmDR8X13JNREjuRfWZGWbO5VR1d3Xe+/ApaKvo9hUp6CqwVaGn+wDvLPayfa0uFTRSe+tiSShZQQZt46xGfxauI80U5Yeu/w/hNTWj7qjs1uF1OqoDZWTpqg8dBIxljqzOCUeqpVcjEbbehMdKycMpHqGh0TgvsjvazUe/b8N/5prMalGWdWUYjpjaZqXVuV98PNCmAtk3J5LydC6bF8oLwzeDiCFKOBt8Dawp7YHVP1IpzFfQe6ZuPELz96S39SVumlm0tfOKqhF2BMAWoIQ/2VyomYacPLLAVcdBZJJ52KFX+a6vzEz6bw7EjU8Na0itv2gnpUUEhd6lLYORBkUZJIxOU1jh5xKSijlSO24IroueWv3/5QYipmNA2o7HeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    260f6f4fda93 Merge tag 'drm-next-2025-07-30' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c31834580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb7581d3fb1bb0d7
dashboard link: https://syzkaller.appspot.com/bug?extid=2a0d2af125c01db73079
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149062a2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1fce1d4d56ce/disk-260f6f4f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/01688cdba884/vmlinux-260f6f4f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eba9b2f77e6a/bzImage-260f6f4f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/95ad5335ac08/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2a0d2af125c01db73079@syzkaller.appspotmail.com

 do_group_exit+0x21c/0x2d0 kernel/exit.c:1105
 __do_sys_exit_group kernel/exit.c:1116 [inline]
 __se_sys_exit_group kernel/exit.c:1114 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1114
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/internal.h:491!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 7687 Comm: syz.0.738 Tainted: G        W           6.16.0-syzkaller-08685-g260f6f4fda93 #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:set_page_refcounted+0x142/0x1e0 mm/internal.h:491
Code: 48 89 d8 48 25 ff 0f 00 00 74 21 e8 18 4e a4 ff e9 2c ff ff ff e8 0e 4e a4 ff 48 89 df 48 c7 c6 a0 47 17 8b e8 4f 05 e9 ff 90 <0f> 0b 48 89 df be 08 00 00 00 e8 3f 27 03 00 48 89 d8 48 c1 e8 03
RSP: 0018:ffffc900065f7670 EFLAGS: 00010246
RAX: 0ebb44fe4874cf00 RBX: ffffea00011839ff RCX: 0ebb44fe4874cf00
RDX: 0000000000000001 RSI: ffffffff8d1dbecc RDI: ffff88802f581dc0
RBP: 00000000000000ff R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1017124863 R12: 1ffffd4000230746
R13: 0000000000000000 R14: ffffea0001183a33 R15: dffffc0000000000
FS:  00007f4368d266c0(0000) GS:ffff888126c1e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feecfc73000 CR3: 0000000034c06000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 alloc_pages_noprof+0xe4/0x1e0 mm/mempolicy.c:2513
 folio_alloc_noprof+0x22/0xc0 mm/mempolicy.c:2520
 filemap_alloc_folio_noprof+0xdf/0x510 mm/filemap.c:1007
 do_read_cache_folio+0x1c0/0x560 mm/filemap.c:3885
 do_read_cache_page mm/filemap.c:3989 [inline]
 read_cache_page+0x5d/0x170 mm/filemap.c:3998
 read_mapping_page include/linux/pagemap.h:993 [inline]
 inode_read_data+0xa7/0x480 fs/ntfs3/inode.c:1054
 ntfs_fill_super+0x39c8/0x40b0 fs/ntfs3/super.c:1533
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4369ac030a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4368d25e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f4368d25ef0 RCX: 00007f4369ac030a
RDX: 0000200000000080 RSI: 000020000001f740 RDI: 00007f4368d25eb0
RBP: 0000200000000080 R08: 00007f4368d25ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000020000001f740
R13: 00007f4368d25eb0 R14: 000000000001f771 R15: 0000200000000100
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:set_page_refcounted+0x142/0x1e0 mm/internal.h:491
Code: 48 89 d8 48 25 ff 0f 00 00 74 21 e8 18 4e a4 ff e9 2c ff ff ff e8 0e 4e a4 ff 48 89 df 48 c7 c6 a0 47 17 8b e8 4f 05 e9 ff 90 <0f> 0b 48 89 df be 08 00 00 00 e8 3f 27 03 00 48 89 d8 48 c1 e8 03
RSP: 0018:ffffc900065f7670 EFLAGS: 00010246
RAX: 0ebb44fe4874cf00 RBX: ffffea00011839ff RCX: 0ebb44fe4874cf00
RDX: 0000000000000001 RSI: ffffffff8d1dbecc RDI: ffff88802f581dc0
RBP: 00000000000000ff R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1017124863 R12: 1ffffd4000230746
R13: 0000000000000000 R14: ffffea0001183a33 R15: dffffc0000000000
FS:  00007f4368d266c0(0000) GS:ffff888126c1e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feecfc73000 CR3: 0000000034c06000 CR4: 00000000003526f0


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

