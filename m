Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B0BD489A4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C69A6B0088; Fri, 16 Jan 2026 08:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374716B0089; Fri, 16 Jan 2026 08:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273636B008A; Fri, 16 Jan 2026 08:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 119F56B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:51:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B73551AA81
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:51:03 +0000 (UTC)
X-FDA: 84337963206.17.C90E959
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E4D7140006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:51:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3RUJqaQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3RUJqaQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768571462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Y4JgLRVrbzPt97b/QHVeuTdomTm+YW2wBi/KzvmtIZM=;
	b=Tw6BX5DdDEEUnOTN1VDZ/cfnVYujJYgW1j1OXATceNDCARsmJVqCSwyLWtSf44KTGex/PS
	0BTi7lzxL8OY3TGnkXp4U5PtOeXV67yRS2L3vWP9rig5VOPh96THdyCCOwGPFOWQR+xcoX
	Ihd+csjTuV9wYeXfA7D/pFLuHlWoeSg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3RUJqaQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3RUJqaQkbAMQ289ukvvo1kzzsn.qyyqvo42o1myx3ox3.myw@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768571462; a=rsa-sha256;
	cv=none;
	b=PU96Mgv84vY9GQemagA8R8mSzp4h7R6Enr3v0Wg/Zx8pStnlofdSE8OCvVf9D1j+krHD14
	BYT20+3lPs4Ka1EMNeZNCU3fPS1uQl/QWcRlh3ARHzr1CQW3D0Kh9l8oGbWPA3jTYh2xxX
	mOWsa/+AX1uBz0v7lrV4DZN9aVG4nhk=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-661042be97cso5649266eaf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:51:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768571461; x=1769176261;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4JgLRVrbzPt97b/QHVeuTdomTm+YW2wBi/KzvmtIZM=;
        b=Yya19L/6+8wnsoCzQ0Vus+hNo1Hd+/zEsTU+DmFnPjoCl+IRDEbNFQVBWlN0A9c37H
         JgDAVh8A0iU49rQffCo775BxEGygPKpaho28eQUTvZw1fow6EG71vprbb+sYsoR3MleL
         x7WZhvlyBH7SM5i/6ZnZIv7RBUqr2Wvd3R0lss0BMDS6B3Fz8m24cvcP0y0ZNyxRrIlu
         P3SUjYYrb9Mv8v7eNppT91HTG5Izf6KmbosIYxdh2UaYhwzy/PQczWVXOOG5DXwpqNPC
         73AfBWQCbmCGnFcKdvfYzWmsl8SgW+o86aqiCPphEfyWXzdXoLLc2lDuv8XIwzzPjGFB
         W/Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVyQhCdoX1fnA1+NY5JBe8wuOHxmzd5DyhKDRKDrw7ckas8PVHDKjoYfnDamhxGQZ7DLakCvfTkWw==@kvack.org
X-Gm-Message-State: AOJu0Yxwn6Rbm28vKuQc+BkaRX5//GIW4bEbigehzqqb4qev//aNAw4j
	/zRb9nGYRqg84RlT+jxV0pE8RAjI7niYaqx3RzNv7RPnN9so3hF7Vcv1m8KYY0zXdvxc0Dr+8pm
	DRa+n2bT1i0adV/4hqpCGqq+U88rgtYaTinFl0degwnkwnZf/M6CxUzdJnJU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:22a6:b0:65c:fdbc:666c with SMTP id
 006d021491bc7-661179d826cmr1308628eaf.42.1768571461092; Fri, 16 Jan 2026
 05:51:01 -0800 (PST)
Date: Fri, 16 Jan 2026 05:51:01 -0800
In-Reply-To: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696a4245.050a0220.58bed.004e.GAE@google.com>
Subject: [syzbot ci] Re: add and use vma_assert_stabilised() helper
From: syzbot ci <syzbot+ci80398e89ae0989e0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, jannh@google.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: hksnfh7d788pxrsi8fz4m1nwfog1s9rf
X-Rspamd-Queue-Id: 0E4D7140006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768571461-838353
X-HE-Meta: U2FsdGVkX18UQ1c1bJCfjfF67rINYvBcclQF2HrpmywypR9aEE8e2aPldjT+bxp7fYF7pLkP3to4rReLFY1JZ4St6wYQ0kyhdyjHar4+6KPpkmyj2FZ37B6o5JZ5+LCwncCcHTigCAOCE68GxexDaUveiaX1wNqTPAM3DXh3fPiThaQ7WNlBnp4j0XUNl4iXitVRdsrygmlsXDiW+ghWgenbJ60hV1lcJWPrQrBIyybVjxlDDuZhJmF4nkdnDWUpwTIPOLExUep09GQB+0l1Howut8XMLpJUPgRs74T00og0NeSnwsv4qnhaRbmUKow5xKtLcHFJdbA8Z1i4Ih4koxFJAiu2+0swMkAB6oCeySc36rwJdQqEz3NUk8Ea8J4f+9snuALSsdCu+YilH4V+WJSseC20PrnpWLwsNYaRNxohlTxOkOS6v7k7DOCnuUYw6pb/SC+EmrwleMwyTPyoqvOq6v0R75PMHARj8l5eJCV1XvHSHtnaQ6PJSkPGS82bFmF0qe6/SlzxaQ/XdLYFD+qSpix0j1KpoFAzqwHZdKZVWqwrkqgpt8HxP5TZFgpOjDpCweBFqcNTKEJqVU3g40nEplbW1jtAxJS1quRD98H9EKNceQpMdXHMcDzkbEPxzmSqx8US8mqybLG6Z7q601VvatZ3Ss6QKsf7jBaAibuSD0kAY2e5WN+W6qS6DUn0DyMtyAIbr0c9Uh+7o0n4kMD7GwYi7Je/gvf1AB8Xxye9dt+1SiKrIRqcVD+wbh3OkszMI4C943pkYf7SN+t9cC2ISxL95qIr4YsCEipilucX3zMyxg3Lh90MBzoCh8pclUYGHZP+ZICHHGa7P7B7SK3BaZ3vSOE6KSVA3g5ZBAWLI+ic629ES6IIVQ8Z8qjnPETlULC4EzMrAxDQEXV+hBpowMEiFlCnF84KKx6zSk2IFuj+K2QBCkuj3GTaqqwP48RjX0wr6M2VYG5JuED
 gJKDVQBy
 17KvLaqIcnqjhj3IBeMPwmcpVTddWnoIApeFcTDlmbZ1FMi4BJjhlY+8GXQ2ox7sFrAwrTVTjGqIMBi2I6NY9gROsFth8jraRTHf9NmDDkAACHZ6R2STINx0Hc3NUiOQxRiG5GyeD/mAhKxHSkBEZ9BeMwZG7eGeB+vEmlWgbuTCI7AuYYnZHOuUUA0TCXR7sOv34jbDZJbjzx7c2oHLKPh88jeLHUea2MTJ6pHQ67oyjlskDyqBjNrfZm8FhLZtWPnQ3KfoV/vc5baAYc4fqh73MZ+05HhAzU/xQXmicCJPU4EKgOjky6L7VIyOZ1Ruz7NRI28Pn/cdMLd9SOHZvslFULtyhlEemWQNy8Ymmycy75SX4lZASYzcrPuB1YpVCQJKkxosbVQesMzYM3YVSGhtxmAf8a9Mu9h0IHo6ZhRHvrpuoF2RcFhAHsjlK9KpnAe48mVYYe82OKrrBVLNHGIEzGALMXjF1M+jWGHzebxamc84r6w7S+qbHGacU4izNQT+xdpy5sIsozHGbI5gn3kHJK3TJEiIa51WJ6iXEgVA4AzrZtTrioZH548lmoayVO91RM+Zkc0V7Oi7BBfFPVIQYnagvmd3pzl+5WkfokEkqoH680Kyc8rhAU5ZMRoLYHzwt9bcATTUrFf16GYkm98qLB58+qd9sjsmjgVO7rKfJvsHphIMApkeE+kHEG8Gkcntlklf1anHAA8k7BwgnU4ngtcdxV0NUG3O7cLytERPIZskZVvADxZgE58JqfQ7yR2xTxSYOUqFwNCktx7PK0I+syh+Y3MXCag/DSwGJQNceNxUb7llrStYD+M49xr/GxArKGmVIAmqlT+glDgE7OH+C30Izl9c7W7PfkrrFDsFoM/bLGudwUQ41RnUk9pBhDGcYvW+jqN7i5Qtb75tszsoCLtoRzMpAUji5Q0TJcvmDuM2SecwNFQTG1aZySopkn1ACEBofmxAB0HYKxBqIfPh7+zaF
 Uv/nrleJ
 sxX0OMMi01ez26ZrRYHCW0HxWsJRJI+hiyh9SEauMHDtb2Sj+1PQryLKOfltnx30qEz/rWaPVoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] add and use vma_assert_stabilised() helper
https://lore.kernel.org/all/cover.1768558900.git.lorenzo.stoakes@oracle.com
* [PATCH 1/2] mm/vma: add vma_is_*_locked() helpers
* [PATCH 2/2] mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers

and found the following issue:
kernel BUG in anon_vma_name

Full report is available here:
https://ci.syzbot.org/series/a3867085-bae4-4416-9704-3b23ef9c6006

***

kernel BUG in anon_vma_name

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      eeb33083cc4749bdb61582eaeb5c200702607703
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2e5b4d7e-a1a9-48c8-ae3b-654d3ac32e5c/config

Loaded X.509 cert 'Build time autogenerated kernel key: 65176d093d4baf94ab1e788ee9f46804766f83ba'
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
PM:   Magic number: 10:472:582
tty ptyc0: hash matches
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
Freeing unused kernel image (initmem) memory: 26044K
Write protecting the kernel read-only data: 212992k
Freeing unused kernel image (text/rodata gap) memory: 388K
Freeing unused kernel image (rodata/data gap) memory: 1776K
x86/mm: Checked W+X mappings: passed, no W+X pages found.
x86/mm: Checking user space page tables
x86/mm: Checked W+X mappings: passed, no W+X pages found.
Failed to set sysctl parameter 'max_rcu_stall_to_panic=1': parameter not found
Run /sbin/init as init process
vma ffff888175272d80 start 00007fffffffe000 end 00007ffffffff000 mm ffff888100079880
prot 8000000000000025 anon_vma ffff888110bf8000 vm_ops 0000000000000000
pgoff 7fffffffe file 0000000000000000 private_data 0000000000000000
refcnt 1
flags: 0x8118173(read|write|mayread|maywrite|mayexec|growsdown|seqread|randread|account|softdirty)
------------[ cut here ]------------
kernel BUG at ./include/linux/mmap_lock.h:476!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:anon_vma_name+0x253/0x260
Code: ff 4c 89 ff e8 8e 7d 0a 00 e9 e9 fe ff ff e8 34 db a2 ff eb 0c e8 2d db a2 ff eb 05 e8 26 db a2 ff 48 89 df e8 6e 77 08 ff 90 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffc90000067550 EFLAGS: 00010286
RAX: 000000000000014c RBX: ffff888175272d80 RCX: 37717524f4bb9000
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1c3ae40 R12: dffffc0000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88818e405000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 0000000110c5a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vma_modify_flags+0x203/0x330
 mprotect_fixup+0x46a/0xa50
 setup_arg_pages+0x565/0xae0
 load_elf_binary+0xc5e/0x2980
 bprm_execve+0x93d/0x1410
 kernel_execve+0x8ef/0x9e0
 try_to_run_init_process+0x13/0x60
 kernel_init+0xad/0x1d0
 ret_from_fork+0x51b/0xa40
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:anon_vma_name+0x253/0x260
Code: ff 4c 89 ff e8 8e 7d 0a 00 e9 e9 fe ff ff e8 34 db a2 ff eb 0c e8 2d db a2 ff eb 05 e8 26 db a2 ff 48 89 df e8 6e 77 08 ff 90 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffc90000067550 EFLAGS: 00010286
RAX: 000000000000014c RBX: ffff888175272d80 RCX: 37717524f4bb9000
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1c3ae40 R12: dffffc0000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88818e405000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 0000000110c5a000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

