Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86E6CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CB58E0030; Fri, 19 Sep 2025 06:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13B58E0008; Fri, 19 Sep 2025 06:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29C38E0030; Fri, 19 Sep 2025 06:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAE518E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:10:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F72B160612
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:10:54 +0000 (UTC)
X-FDA: 83905581228.06.D5585B5
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFC74C000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:10:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3KyzNaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3KyzNaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758276652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=S0iL4gam6jy/j+Q1w1Wozm+FmZ2/+1+dtAyUrkE2lBk=;
	b=6T947qqqz1y421EId/YWHcHT9RXPIoyTkzTxQRtVAL+pNipC00uR/Thw3cFHNjpL3mkYyy
	I+sk17PDNrt3fHq+rix9OG86ze2/aM6gSJgL9ji43tJbS8FhJYu8wqGFBPgFfXlmZXMDcC
	jp65S7KMNaCAf+aTiu568O6J3yjCClg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3KyzNaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3KyzNaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758276652; a=rsa-sha256;
	cv=none;
	b=wSyY4Zfao+GH+d2M2fpNN2TzdChg62QPPoRf/dc/VVdMeI0pVAUR5nLZSzbWY5YMpxXhQL
	RWv9BxfbnnXhncf4l8e5rTLUxkqrgW684SO1jqNEvS5ohw+mwu9wG5Yzwkzb2RiHX9Hdpj
	nmQNpkdC6Zzl5/dupGKgL8pNbb2+7SI=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-42486f6da6fso2434655ab.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758276652; x=1758881452;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0iL4gam6jy/j+Q1w1Wozm+FmZ2/+1+dtAyUrkE2lBk=;
        b=hJL9PvPCUSwXw0cLZ07FFOVuPnOZNNXh3TXTXon6l0TUgvI3pUieAyGb+9KtiJtPeK
         DAPGq1B0bF35bWkIrS2WGBlLwupVQcnqFy84cDansR7uE0tLa0NeYgLuw/B14EHoIPGG
         bfI5Q1lxO/c9OIiplyhY34APu9xaAeoSHScBRtTN0iZhWRZ21qZBsRdpfaTIqL1IFQkT
         5canWPbXqdC/bLtk/KyKjq5gBiVP0fMEC3Ns4XPLVJOMlBUy97dSshDmBq6ieRBgaDNG
         VSx75nYD5jhlLxeVjxqlH1BolCDfz2n4tVaBe7EaXMJt3S/9TMwn7JWKoLWNpoVbkJAh
         hTKw==
X-Forwarded-Encrypted: i=1; AJvYcCVWHqD9EiR+FUlw23mpBasVHQTrzwMaIxdu8uN6LcnjwaNZ78fyB2pOzrg0xid+lASAAD7GQzV52g==@kvack.org
X-Gm-Message-State: AOJu0Yyfw4KPa/flkZBXhbQA8E7pXuQ+GEz5Yww4vMWXeHI3bdQ+w/2U
	xIK3Yw+NFYoLfaLcbiO5cdI0hj0QwYIWOJPB8HjDqh2RFKnaDsdLBWMbTv+SVfv7yqoq8bKJo2e
	Kq94uWgmOeO8J2qJFQGHuUA+AGzOJczyrDNas2IEvXw6XLJzRc1cEDrNxLrg=
X-Google-Smtp-Source: AGHT+IEydYfL6yv9HwG5VYgb+FBhHRzUkvTIcN6Lm+clEXUkyuuYyrC7hJyHRrmbjZo4+BPh3aN4tJYkRMIBe6lzWBeRycfQT/uQ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2509:b0:423:51e8:366c with SMTP id
 e9e14a558f8ab-4248192a6cemr41508645ab.9.1758276651826; Fri, 19 Sep 2025
 03:10:51 -0700 (PDT)
Date: Fri, 19 Sep 2025 03:10:51 -0700
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cd2c2b.a00a0220.37dadf.001a.GAE@google.com>
Subject: [syzbot ci] Re: kernel: Introduce multikernel architecture support
From: syzbot ci <syzbot+ci5a8560c05ff0980d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bhe@redhat.com, changyuanl@google.com, 
	cwang@multikernel.io, graf@amazon.com, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	rppt@kernel.org, xiyou.wangcong@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BFC74C000F
X-Rspamd-Server: rspam05
X-Stat-Signature: 914qgow4a65gsnkpswpgsyk6pepwayu9
X-Rspam-User: 
X-HE-Tag: 1758276652-464828
X-HE-Meta: U2FsdGVkX18qdLMnjegaliEr+cGRQhu226PxNc5ztVKDyOXfwBWO9AvMLKe++eUbF6+k80V1UV8XC9ty9/86atCRp4xOOsk2GM7GeZslD+37flRE/ZMiT4+1NOURN4TsRNVkDCU0BUxB++BapLNJsUJtl1UOqPiXuksHgXlT2G+XUx1pJ8vzR8KK257rA65OufrdxhR7A7n7kFkyFllPaPFPKUWdj/nv1gBtoc+t5BZuTCViGzcBO7DXB+kqL+ywV1QDK9QuxmPnUKdETiKALXhEHq6v437dfXMN50lIegtyB21Mj+DHFfGv8iRIC2kRqpawZzcxVTZO/A8gjDN+mh130Cd9CcDb8MV6CATVXGbm4tNXCb1gLQFmBvLdVGa6vqQHas7PkAQHkzOQmuBmC8/l06TW1Nxkq7/RLdk5SB5YvuYUjfZv0htjGEh/n7ChdmeYck9HI5kVN7IzQ8u3bJkdjfnfHU95z1FKkWnjHmWQWZ0Vf59KdIas5KvEv5DI5vVM9gJdBm+wVnSYxoGecXIWfpP8imw6XuYQgiZ+P/gTB9FjIkSXcukxkdrDawK2L+1An4wcjHUNE9EQgtDiLniFFRzE6RapXlwfBXYJoNB0+X2rBqZfBKZ7h5HEGTj7sjN5R+HiCx+oVS8r8XND4EBT4c4m4KrOc+00amW+8+ujJsIrlKTaHuHhqdhVCqXoAU7DIEyuWotTcfqx3IQ/+AWG3Hn9BSmaBbgdCTQlLkC6sKlvEDYbZV+w03p29BDGlOmCqas6U7GHfbxT+DGP+MlvXqQGHV1KuTygpXDrEYLsSlP+lyE7xrEVQbFyLNKSrVM+iy9XTiieO/JzIb74BZV8IMpYiTAWV9WYY/ogKm1FiFKJOfQoqmINVNzKfzGEAqbHSisYhveGPPoiChugsiSJ4RGjsMlLOeUTHt8nswrQZuJ3IpToNvZtV00fdTrrEh1+jobPwrlh1qUr7Nu
 3CGsH/Vn
 K4w/fimkE4+elyq9iHR+y6JZfTateOgQ2TRhNhECpgEk7d7K+BB9gXDaIN/ATEfOh3Ao1hAcmnCcshXQTG4VBdOMC8m/q9f9j0arVjsAOaHiuNrjviL97xbJp9dROytMmpwqTLIhNwQcyiEikDQHcHHemAm/PMbtH2VJSXH6ZipUdw2JLQ9CYsgg+entSlGlKxnwnYgUHFRW1wDLKH4wi39lZVCwThDShNnFBJ4KnsirgSADrnp/IqiNFqDGoNSaw2W36gycsHjxP1VaroNUfg4AbtCvjbvuJ9Qq3Eh6qImkBEZ+uTPDN9K1AbBmuRFQMlzEPJs/EQq78KsvFzALzp+24GF94anfgJV+XcER2/n6l3fLzcsMztaqFzp9tkiJKaS8oNkJgVESk+XEN0/m8k10HIxgc3yytpW+7/oXwqet4jKa27g8fZa0RGIDi9sDXuQ4QzNshaIRTsx4Yre+nZmRU/2RDQpd1oCkbaJoNml4DPCwT8Xc1aFbJ5mPIB5gywX/HewKfiorBt2XFKis0BnsChkOKqNmqQ/DIIOUdmdPtSUUdCbsrrJ/xSDZUYeBwz8ktbgVhc13A3PQdUBh/V5VWI/VGJjVjHGM0P4ulLUGZ1xgIk9+yhtJAuS1VxNvmoIy8G88teRlVQTpll9tbyOlQTwkhddNYErqq8KuJmuhW5o+8k6mtv4NtyjnX8HJU12usP83a3N6HIuYPsevyi6/0o0dQUxls8+KQ0If2rWP7AlXVVvPH1qzju6HrL/VXRte3PyPQZTlihQx00N71kGLMaoqX2URIfaJ/7zC12xf0hrgV3nSJSqHpKfNTlFZ/h0UKcTn/aKQiH3txQH93zDSb7zn1nU2e1mxiUDj5jEL6ZCW8thDv1aqR5GZapFNlGQaVJuRu7M8Y0ZK0hY0qeYro+S6PuIRR5y38y5+ByOnC7ehChq7uqwThOhy0y7QU0FzjzxLDGdzxEP4MUQuWt6Gx6ijI
 p6bRcr1y
 yCun64Bt67Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] kernel: Introduce multikernel architecture support
https://lore.kernel.org/all/20250918222607.186488-1-xiyou.wangcong@gmail.com
* [RFC Patch 1/7] kexec: Introduce multikernel support via kexec
* [RFC Patch 2/7] x86: Introduce SMP INIT trampoline for multikernel CPU bootstrap
* [RFC Patch 3/7] x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
* [RFC Patch 4/7] kernel: Introduce generic multikernel IPI communication framework
* [RFC Patch 5/7] x86: Introduce arch_cpu_physical_id() to obtain physical CPU ID
* [RFC Patch 6/7] kexec: Implement dynamic kimage tracking
* [RFC Patch 7/7] kexec: Add /proc/multikernel interface for kimage tracking

and found the following issue:
WARNING in note_page

Full report is available here:
https://ci.syzbot.org/series/9ca759c7-776a-4d45-a2f9-5e6ca245e989

***

WARNING in note_page

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f83ec76bf285bea5727f478a68b894f5543ca76e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/645f543b-aa06-4977-81f2-45a0b44a2133/config

Key type fscrypt-provisioning registered
kAFS: Red Hat AFS client v0.1 registering.
Btrfs loaded, assert=on, ref-verify=on, zoned=yes, fsverity=yes
Key type big_key registered
Key type encrypted registered
AppArmor: AppArmor sha256 policy hashing enabled
ima: No TPM chip found, activating TPM-bypass!
Loading compiled-in module X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: 75e3f237904f24df4a2b6e4eae1a8f34effb6643'
ima: Allocated hash algorithm: sha256
ima: No architecture policies found
evm: Initialising EVM extended attributes:
evm: security.selinux (disabled)
evm: security.SMACK64 (disabled)
evm: security.SMACK64EXEC (disabled)
evm: security.SMACK64TRANSMUTE (disabled)
evm: security.SMACK64MMAP (disabled)
evm: security.apparmor
evm: security.ima
evm: security.capability
evm: HMAC attrs: 0x1
PM:   Magic number: 9:738:504
usb usb41-port1: hash matches
usb usb40-port2: hash matches
netconsole: network logging started
gtp: GTP module loaded (pdp ctx size 128 bytes)
rdma_rxe: loaded
cfg80211: Loading compiled-in X.509 certificates for regulatory database
Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
clk: Disabling unused clocks
ALSA device list:
  #0: Dummy 1
  #1: Loopback 1
  #2: Virtual MIDI Card 1
check access for rdinit=/init failed: -2, ignoring
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 ro with ordered data mode. Quota mode: none.
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
devtmpfs: mounted
Freeing unused kernel image (initmem) memory: 26168K
Write protecting the kernel read-only data: 210944k
Freeing unused kernel image (text/rodata gap) memory: 104K
Freeing unused kernel image (rodata/data gap) memory: 300K
------------[ cut here ]------------
x86/mm: Found insecure W+X mapping at address 0xffff888000096000
WARNING: CPU: 1 PID: 1 at arch/x86/mm/dump_pagetables.c:248 note_page+0x12a5/0x14a0
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:note_page+0x12a5/0x14a0
Code: d5 49 00 c6 05 bd 7d 17 0e 01 90 43 80 3c 2e 00 74 08 4c 89 ff e8 9b 47 ad 00 49 8b 37 48 c7 c7 40 98 88 8b e8 1c 53 0d 00 90 <0f> 0b 90 90 49 bd 00 00 00 00 00 fc ff df e9 5a f1 ff ff 44 89 f9
RSP: 0000:ffffc90000047678 EFLAGS: 00010246
RAX: 0829288c8ce4fa00 RBX: ffffc90000047cf0 RCX: ffff88801c2d0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: 0000000000000001 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bfa274 R12: ffffffffffffffff
R13: dffffc0000000000 R14: 1ffff92000008fb2 R15: ffffc90000047d90
FS:  0000000000000000(0000) GS:ffff8881a3c09000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ptdump_pte_entry+0xc6/0xe0
 walk_pte_range_inner+0x1ba/0x380
 walk_pgd_range+0x1467/0x1d40
 walk_page_range_debug+0x312/0x3d0
 ptdump_walk_pgd+0x126/0x320
 ptdump_walk_pgd_level_core+0x260/0x3e0
 kernel_init+0x53/0x1d0
 ret_from_fork+0x439/0x7d0
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

