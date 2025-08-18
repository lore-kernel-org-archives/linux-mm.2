Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27983CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 09:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15C48E0029; Mon, 18 Aug 2025 05:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED508E001E; Mon, 18 Aug 2025 05:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A2F8E0029; Mon, 18 Aug 2025 05:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8568E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:42:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38CD9C0850
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:42:31 +0000 (UTC)
X-FDA: 83789388102.05.2156C90
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D372180009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:42:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3hPWiaAkbAEc178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3hPWiaAkbAEc178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755510149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=9wGHxTryICtLob43ykIoK53i3l3ypoaoPwteFMzyRHA=;
	b=P1oPi4yfEIvCNJ2wqW1z2okHHiVGJvIZPwmASR0fE8ty559YW8+hAOy3VFwKRgji3BgWVY
	K+Goeg/a7qGv34EkgvLoHH4dFX4N7mwRqpk9NRXh/X2vC5Ek2zyHgZs/io0ayEx9GiOqQx
	zNVJeBxlIAHIkSgz6+9IgqcRFPqYjME=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3hPWiaAkbAEc178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3hPWiaAkbAEc178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755510149; a=rsa-sha256;
	cv=none;
	b=NBZvIqfH73HcbKyxl7mK2Tp7H5Rs44tjhYZOLX9WHbKklhX71YOZ7QtKxI+eD8ZKD6l9CK
	byXIdw/BKm9+I820x8bVU4hUr1AdN98HKf/t6Ez7Dq8Jxc6D2Un41x0PD95m/ZNPFGVvHh
	Lxnnh+hCakbfPR82eSKFp/AEJ+I4us4=
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-88432e3c4ffso423269639f.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755510148; x=1756114948;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wGHxTryICtLob43ykIoK53i3l3ypoaoPwteFMzyRHA=;
        b=aj4ICkooyENfFbtL+SuHV+ZvQZCypZwoa6Ra3s+uPSd+nsK4OdBCoru87pm48FtJrf
         3YgW1oTG+ly9QzfVwYFZQ0FAH+X2zKTMUoNuxy6bZxt05YVna1wvZjR8XKYWEqGncIJY
         RAKuzZh7HGm+C++nFYh8v9xEKo7Je1R8OeyuHyBU2zukAaUVdXOYB+5Vo4jY6xcN1pSB
         nJvCeauoJ1rSIQOFs+xr21BqzyPkuX1kpeg0aMPBfhf4wdyuYywOnTvde/hHG2hmxGcr
         EYvcDzF6MorOk8gOYXhDiUevNiezR07uCmD14g72OMbvmi1cyPyXig10QAecOKyh2t28
         d3gA==
X-Forwarded-Encrypted: i=1; AJvYcCW7+/tlfxxc/eE+h82dUBOxbPElskKwbyupRsUl/2clSn25CqA7J5MB0aBltKtV1iLlEltLerfqvg==@kvack.org
X-Gm-Message-State: AOJu0YwMwjOSP3D7h2XPYyCa7YN5bW7CpbrflNrkZhWtx314ijgxZ+8w
	eAb7JJpWf26pJgUk7VGb9HdobGlSsWnw3+iFCtrMY4P37pbnnFrx+HkyfoMjR/eG11WMZoQYaUW
	mEINbku2U7wlIGE5DkwQG3E74sCbb0/+/tFN6O00xRegpy3MmFdx6kX4ZcjM=
X-Google-Smtp-Source: AGHT+IEy+DhZF0kVCFcwYxkEZCvaNAN8vkbPi0qS1D0Zb3xGehBLux0c/k5Qeuv219SQUXlqM/N0D3HZuKAkgonfrZqKlOKyUmIL
MIME-Version: 1.0
X-Received: by 2002:a05:6602:60c5:b0:87c:1d65:3aeb with SMTP id
 ca18e2360f4ac-8843e35ceebmr2227386839f.2.1755510148497; Mon, 18 Aug 2025
 02:42:28 -0700 (PDT)
Date: Mon, 18 Aug 2025 02:42:28 -0700
In-Reply-To: <67555b72.050a0220.2477f.0026.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a2f584.050a0220.e29e5.009d.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_umount (3)
From: syzbot <syzbot+1ec0f904ba50d06110b1@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bigeasy@linutronix.de, 
	bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net, 
	davem@davemloft.net, eddyz87@gmail.com, edumazet@google.com, 
	haoluo@google.com, jack@suse.cz, jiri@resnulli.us, john.fastabend@gmail.com, 
	jolsa@kernel.org, kerneljasonxing@gmail.com, kpsingh@kernel.org, 
	kuba@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, martin.lau@linux.dev, netdev@vger.kernel.org, 
	pabeni@redhat.com, sdf@fomichev.me, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, 
	yonghong.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7D372180009
X-Rspam-User: 
X-Stat-Signature: 66juujk3rardhaqegioh9k17c7g8mzxk
X-Rspamd-Server: rspam09
X-HE-Tag: 1755510149-263247
X-HE-Meta: U2FsdGVkX1+Df0luYric538sTA//cHumFP1IqygtEyJC5H97g5lRDgcFxZg/sWD+r7D6Gw8m+3vNyN4/98oFCq2RVivigPVwduknbUNkH3WtF9XAOVRPGb3n+clT9vsJuosLqdqr77wgFqv0Rlefgdo7WGhU8vcdNSEfK2SXJvDHQpZy2XmlFnWZX1OiQHnvMvLzYwrS8XIH0dtG3obbDB9QgJgaI4tNVOYVL5IFj/HYaZ60iC1XfVjm9/hzxMOulUpZRp/PjBlL0eSmTHTeZ3eaAn4clBRSbA6n3qJJLJKBY6PzpByl7pk0M0/ErtEijBoQR1+1PLZgGvjHXuT7ahUlcT6XWJ1QQ/YlknhSfiWLggD+I8ScjiXI2/ozTFL9gW5Ip2UMu14DuQJfGJal+qIsiIu97lw8XP4zI7Z2ezrZSL9OLlMNRJVDC93jupeDKQO+VsVvww7ArgvKeLgvtPygUv2Ss1XRiGXh/BPqib9OLCf0rWqCBpZGIwOTfKUUeMBPlniK425IFOu5ByBUzhHgoIHWWuC56LgNJ4IosqkCSeus/ANDnW4Ilg9Wy/1DwSuKPsHsYOV6AEGTHXSqasaWpdSXfkUotakCtIa9mRhO6Q2dP1bItSRBMuqRqaA3JDN9OkbxOtKESaF7cK61Wf5k4XIvrjkfDUzS3qFOk8V6uruaxwkGtJPSzRUE1nhRHq2TeQUmpSclNstTonIf9vXCUeSAe/VijNaepTF02B32xobMCCziGcLMB2sqBnH4p/PTw/T+S0dY46YiBJgaALQ3NEsZ54O9+Gs8Tgb9hyIeUW4/E+pO+m9/DnJSQ5TDLGgyVyX9/3Ex88VNLDVY89i+r5tRzH1K9uDQAaDZctVCXIGDFu7eiFamWhURhzGdQoVGRCWETaZ+4ywqddbtpm4D8YxRGjM6OrXMmC//EcOyQsBJMk7Q7yGgD1Jhw+ATPhCcFYauGrvW1Dg2RTa
 J60BohrQ
 f12Ps6Je5Lgwo2S5no2vlQYCQaiGnnlm5LcGMyVoYlQYMLppbqHu28sk92qgB3rcvPy3b2CyogRFRJVTzt37B8sxQutczop2oP2ZDUW0HUZWz+8lOLJ9ymlbiYpkEvxI/JKuqyhOsGJlktGGwSpGgmB3FIXuiUKftSmF86o9m5lOxG13Dbn//r9SeA9jiak66UXBxEktoWMHlEVIgEC9x7qoRjCx6DqzviJn7SxVblqOgA+GldQ0uL/FAar6Pz9ov9no/x7Mkm0Kj8+NaS9mndpXlkPU+nIEw0i60GKYepUhV+7/ocPH3u39mKDswPM1oONP1ZWO3tR+qYHFfdc92rICBaW2+CNuKMjn9ERXFwf8o85KVoSrpueLid0pepDqOaeSGjD5/dRMRHBwXzpjugUvgyJiVFFmP9Zmt5J5dBxx+5x+tW3gnM2dvIGfEgTJa14/B+jsmm6WDUr01sHHRSr0Ac7PDYNQIbBp8lyBCcRw4BJTEtRbdkLcIdTvpJ95oiUiiNpaacBQ8+hMUo4MeCKGpck7Ea9eEgFXdGdx1sR7Qw3Y7iEqR+81/4uTK6ed0uXi6AGDAJ/OVtAlIgsxL5ZQLycVYZEYF0QWZL+5lljd5i/th+Bdzj9zW5nIHZYwmFI6Xrdq6LTXwmFQcgJ4GdUIkGRrsUiyYvmuT9u/zCD5Qwq7l1PNVLaZciFitkhWHqG20nt8LmDgB4HhysO2bkPGSiL/PWWNJAPq0ugqU6Db0adwi9LByvMa4plZwLADT4NLKFbTlDfPvlmALwQWNSbgd+J0mxvtf9+lMNZiOGMnFnodpRA7SBDDcz6FBxJ2pM4tXVLpIBu5k4AF7tnqw28uhn5IBg8d17q8AReOkvBNXqD067zjv2f+JrArtscEYDklvUiTM9ZHsXaww/NmxPTjKh2rbxpFMftDnS2uim6fEyE8EAcczXsYJ3wVHN25f7P+FId/fmnBwy5xqfG04GXc5PoAs
 hBbHKnkr
 l9mch0B2APYjH0aK5SpLrNxj1NR5XU7s3XNQRb50RD8Gfn6Ahz/nh4hP0xgcC2NLJRI14iUzDhV6vcCIctAIvSBt7kXWZanJnuHpvLQ1asRxFEYhZECkHQQ2ECObU4TAvj1JK3f7LThGDLDy6RBD8n8Ap+KdmV0NdwgeuwxfNTXSr2GIBEtJxPe6DyzImuiTin/T/nZw6tkAXShGws22qSckORH7LUmnCUKNU3FaRMaqZKgIbU+lE99VueGczaAKn7rKwswYTZyZXNKsr1oON8hacbtIi9MGQEd56I1jqHAsMNUf+vx/74ZssawIkITzaOmdE8x0tulzlQ05kt/IdNz4DqQAuGRyC328x4kWvgzsmjBc2kSiTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1321eba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=1ec0f904ba50d06110b1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cba442580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a1eba2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/43186d9e448c/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=174ba442580000)

The issue was bisected to:

commit d15121be7485655129101f3960ae6add40204463
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Mon May 8 06:17:44 2023 +0000

    Revert "softirq: Let ksoftirqd do its job"

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1066f9f8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1266f9f8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1466f9f8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1ec0f904ba50d06110b1@syzkaller.appspotmail.com
Fixes: d15121be7485 ("Revert "softirq: Let ksoftirqd do its job"")

watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [syz-executor:6662]
Modules linked in:
irq event stamp: 355416
hardirqs last  enabled at (355415): [<ffff80008b00487c>] __exit_to_kernel_mode arch/arm64/kernel/entry-common.c:86 [inline]
hardirqs last  enabled at (355415): [<ffff80008b00487c>] exit_to_kernel_mode+0xc0/0xf0 arch/arm64/kernel/entry-common.c:96
hardirqs last disabled at (355416): [<ffff80008b001cbc>] __el1_irq arch/arm64/kernel/entry-common.c:650 [inline]
hardirqs last disabled at (355416): [<ffff80008b001cbc>] el1_interrupt+0x24/0x54 arch/arm64/kernel/entry-common.c:668
softirqs last  enabled at (355404): [<ffff8000803d88a0>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (355404): [<ffff8000803d88a0>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (355387): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
CPU: 1 UID: 0 PID: 6662 Comm: syz-executor Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : propagation_source fs/pnode.c:77 [inline]
pc : change_mnt_propagation+0xec/0x77c fs/pnode.c:114
lr : propagation_source fs/pnode.c:78 [inline]
lr : change_mnt_propagation+0x120/0x77c fs/pnode.c:114
sp : ffff8000a4a07a90
x29: ffff8000a4a07ac0 x28: dfff800000000000 x27: ffff0000efa88b60
x26: ffff0000efa88bb0 x25: 1fffe0001df51176 x24: ffff0000efa88b18
x23: ffff0000f331b238 x22: ffff0000efa88a80 x21: ffff0000efa88a80
x20: 0000000000040000 x19: ffff0000f3339500 x18: 1fffe000337a0688
x17: ffff80008f7be000 x16: ffff80008af6de48 x15: 0000000000000002
x14: 1fffe0001df5116f x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001df51171 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000f33395b8 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000008 x3 : 0000000000000000
x2 : 0000000000000008 x1 : 0000000000000001 x0 : 0000000000000000
Call trace:
 next_peer fs/pnode.c:19 [inline] (P)
 propagation_source fs/pnode.c:77 [inline] (P)
 change_mnt_propagation+0xec/0x77c fs/pnode.c:114 (P)
 umount_tree+0x7e4/0xbbc fs/namespace.c:1872
 do_umount fs/namespace.c:-1 [inline]
 path_umount+0x90c/0x980 fs/namespace.c:2095
 ksys_umount fs/namespace.c:2118 [inline]
 __do_sys_umount fs/namespace.c:2123 [inline]
 __se_sys_umount fs/namespace.c:2121 [inline]
 __arm64_sys_umount+0x128/0x174 fs/namespace.c:2121
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6746 Comm: syz-executor Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : cpu_relax arch/arm64/include/asm/vdso/processor.h:12 [inline]
pc : path_init+0xdc0/0xe98 fs/namei.c:2537
lr : path_init+0xdc0/0xe98 fs/namei.c:2537
sp : ffff8000a4247680
x29: ffff8000a42476e0 x28: dfff800000000000 x27: 1fffe00019832884
x26: ffff0000cc194420 x25: 0000000000000101 x24: 1ffff00014848f43
x23: ffff80008f745840 x22: ffff8000a4247a1c x21: 0000000000000100
x20: ffff8000a42479e0 x19: 000000000004a017 x18: 0000000000000000
x17: 0000000000000000 x16: ffff80008b007230 x15: 0000000000000001
x14: 1ffff00011ee8b08 x13: 0000000000000000 x12: 0000000000000000
x11: ffff700011ee8b09 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000da1e0000 x7 : ffff800080daa4c4 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800080da8a84
x2 : 0000000000000000 x1 : 0000000000000004 x0 : 0000000000000001
Call trace:
 path_init+0xdc0/0xe98 fs/namei.c:2537 (P)
 path_openat+0x13c/0x2c40 fs/namei.c:4041
 do_filp_open+0x18c/0x36c fs/namei.c:4073
 do_open_execat+0x124/0x4d8 fs/exec.c:783
 alloc_bprm+0x3c/0x548 fs/exec.c:1410
 do_execveat_common+0x168/0x834 fs/exec.c:1811
 do_execve fs/exec.c:1934 [inline]
 __do_sys_execve fs/exec.c:2010 [inline]
 __se_sys_execve fs/exec.c:2005 [inline]
 __arm64_sys_execve+0x9c/0xb4 fs/exec.c:2005
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

