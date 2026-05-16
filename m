Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B07A1CD4F25
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 06:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941D36B0088; Sat, 16 May 2026 02:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2736B008A; Sat, 16 May 2026 02:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807676B008C; Sat, 16 May 2026 02:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6F96B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 02:58:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77498C17B8
	for <linux-mm@kvack.org>; Sat, 16 May 2026 06:58:36 +0000 (UTC)
X-FDA: 84772379832.27.FE786A6
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf21.hostedemail.com (Postfix) with ESMTP id B4E281C0007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 06:58:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3mRUIagkbADwqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3mRUIagkbADwqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778914714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=lwSP8NA9NX4+ziNnxsMZYgv7MI6qgmjM/3UjebHnW6A=;
	b=4LGI41Z1sXND0MC40p8GYgYeMNIp0+5JRIfo1fUkJotWkcgrdLqwKZ9gDSg1EeVnGARLZ9
	g7WoGUkqbn3usMRSTbQwRmes8DTTYlBV47SSjvkPEhjs8KSqcivL/jLGy//Dv74b9psoZC
	7qM1fvk0wDFELmQMmydggH25/KOwNR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778914714; a=rsa-sha256;
	cv=none;
	b=d3ejTZGAk9FdTLc/4hY2NiYLfOATPq1wW5VpT2Nu3eIDuCAxij2hMBt/2T7Nge5v1qcHtK
	LyPn3pFG51+gKSd+6+wTKwB7Ge5cQ7Ax0jM/U8753xcKO7JU5shr5WkZnkKfnuSHUOJnmk
	aVjVPcTMEK6zIzSvbaWnIXGzMEdzovk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3mRUIagkbADwqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3mRUIagkbADwqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6853c2438b9so736095eaf.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 23:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778914714; x=1779519514;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwSP8NA9NX4+ziNnxsMZYgv7MI6qgmjM/3UjebHnW6A=;
        b=f7X+aLJ2w5fu6eAkIqdwQteYtQsnN6vjMfvZ83lqG8Xl+5JM21inQu04ehf8fmMPjV
         tIAhlHpIMgnSiKzjRIMjjrLLWWeAGdewYtSWgRUVt+o+Y5dzB1gyDlFTMabS/EE8yhUC
         vsc/p/X0auKjmBy5Abppe/O+NSoS4pqGHL8KqrraaEWZCnsEcDGgFIMBLiFq7ghGjayU
         PWVS3fH0e7nJ3mxg8+dTZop9h96hAo4HGeD76aZlGIIMLgQRf6T0i1CeyM6vCL/mt6Yt
         QQfxPJzlnFKubD7XTjFDpmWvkVn5Wtfbe69W2dvrHVg1CNF040BYL9ZKAy1Y5VSYRwLt
         AyvA==
X-Forwarded-Encrypted: i=1; AFNElJ8HuE4PwgtfDIVrK+pf7gmktsMACtCuuyG0cJZM8h2xPoVQu7FMWdkanwtX75otNkH9xWNNZw0MYw==@kvack.org
X-Gm-Message-State: AOJu0YxHKHn+Wbq3dIcjBoOenVorvPaShavs84J0y0sh67SdBXnuBsAi
	XmR4dW860oCHVSM+JRRPvJ6egKPdUG5CQa6ktsT90JErVhJAeJya2NMKw7k0nHTCpGJJFfcCgPB
	iC4rE1lLZYabF/LDd7MzPdAvC4PQuIMqHjZMFNJVGBoFMSVpPq8Kgl416MZI=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f005:b0:696:8c3f:d7d8 with SMTP id
 006d021491bc7-69c9437be21mr4084981eaf.37.1778914713816; Fri, 15 May 2026
 23:58:33 -0700 (PDT)
Date: Fri, 15 May 2026 23:58:33 -0700
In-Reply-To: <20260515171953.2224503-1-shakeel.butt@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a081599.170a0220.4530d.0003.GAE@google.com>
Subject: [syzbot ci] Re: memcg: cache obj_stock by memcg, not by objcg pointer
From: syzbot ci <syzbot+cid9f726b45197a5e5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, muchun.song@linux.dev, oliver.sang@intel.com, 
	qi.zheng@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4E281C0007
X-Stat-Signature: jsuheurs4u6eejpsbb9wb3hyr5i6g5qe
X-Rspam-User: 
X-HE-Tag: 1778914714-212652
X-HE-Meta: U2FsdGVkX19b5RT6jVdQgPfefZEh65NJrhXRMiyib9T85NWRRRv6Fby4eZ/06pInKCM9qlXUMTw/mo+yvkyi4ebNgWmRy/tVGg5vfF/PLWyRjDjEHel8uLzw58RIrfYN+rIyA9oRtSmNzp4zY2V7DxCsCNK/jAUNv4tawl2YthRLkqPIbxD/YUsf1R9LteS8umkob6ogr7zXQKteKV7zO74DX5vuk/BAoWsb2g/T1mXLnyQOo7kyaOdVrNfSm/4nKoyQ0F6QQPUUQwO5YItcWSF5mJJLbxMmqa9cygQECf12ENr77zGgGhoXUn992//ETfLyQJS/u572hnrr2R2NYsn4wgJrMcoOStTQC5CdvvVdJCNQ32zeqny7E5K0zX9jwKHWFQOgivk9/9GxN1PXdcrFe6YoivjL07OQDOL2sFWHXACrr92aBFr41FKIAvQQQWUs3r0dWadce6+q8+P4VbOolKv2d3JJlNFq9p9hGAqcWdM7yh3A+vmeS/wVIPXIDZ4zSpOgQEWx5BrY85rNnwOs7LhIbb/vV7o2LogzjWw7J29I1TzyufrEVfa4+7xmMFCpo0yUneaso27bTIYrFsB7ddt6Ag5n6fb+xSx0khOr2goHtB5CEKdT3OjKtCWhIbpWZl+VWur/oM8nrQQ/rrko6mtHCoOxW0O5ok9vChNh/ZHlNr84RHw5TgCIyeI5eXZ2HMJd9gQE4GXoA7SqTw7pRfg3GYTEReJpC96b6kjt/CBaI+Wq7IMNdIjqudJwHC80/gsa3K/wcp/wLjmLTKxrLUUUgN1Ihgqev0G3GPjq5B5x4hA2b8lxhMx5ZHZN8zXOhveOpYvJFmBfMVpJfhyCqrqXi78sRfdOnb7zxkb4E9JZyr+eBZIdM6LxjqJoDR7RpSR0F41LgZcfAtU8c67GxeYIzaVUoibC20VjQV8FXO9/aoQ6VSz3mS7amvqdY3RLnUGkDKMJGTzQBkC
 59cVWn5K
 itjZG1/dYMQ3Q/weu2xS+2kdBgcHHix2CoRIxEIcbTIPyGALLorq5QAM5KjqgZsgHEpnR6+9JMXkxTnkGFXOhc1EV98WGD8wNW/EcuMtas9O5OqHrZY0D9PM6zY+/TLiOwvS/URaeGDkgiZunGaB1l2Khup/C25oROkZLRYI4SL2480jNV68KbdvQz1/6rsfqVFXSyoaH+wCeKhhMW/7AGePTqB064HbTY3N3Qk5YH7RVWw5DbanZWqLNi7tJoPCE61qTMeNWmlLjBcG8Xa3VarWe5JKbYILUhJltz6nLxDZBgEs9LkpvuGKVY/yXDchUhei8gntV6GarVTNyhAeh9emMPVzMLQjK/zaxADodpIeO0BhCnOucVTF0qMaKQngdBDo911ptwVGjAUF38Yvb4GzX1E3DU7KqQ8yraArxZE754LUoMBo1m9TpWF/1FXj2N4QX5n3xFhTwVMFbCTH3xomDpkuI1tXeB3a+v64SR9BYTbESdqDslOLG97UFNcOBqFWt8Hx/Oz9+jo0vfwNykfPdVRXqppziuQuVcOlOqFN+LfepuA/5oBGFVJorIgOfytW+s3Nlxkeqal3u62Tw/VENcGt4CA5p7Z2jhmvT3TUJ8+BCxV4cEXhyB1Pi5axD+qfW82R330dMDrnFVvSObxHYHjtSUfbmR537jGP5ut2RiwBb+3xPhW6t2M+b3Uw0zXcGQol+jI+vIQH7BSKuPtukR9ysesYjFmX710MJR1nuWakr830F5M3pKz+giD+5vutJedivWppFttk0JFq4UnSaknI7Ku+6cZe8zLR11X4YgIX91cKd5n245LzwMfA3tq3VJtz51v5QMLFrt3l315knY85c/aluAtZk8w51JdjsXN//Z6SBOvPRpcHU0mdZJ1d1eMh3N6kFMg80ZXpW+ZSzCCMbvNRjbLRGwbnibfKkOiWLeydYtNpOGbVw+IFha0MLeq8HAZGo+Ao0/0mNLiJILIgZ
 NaXr56a3
 MGYiD+4rrXWINIp6e7mkECcHOR3SilHqFwkg+Aj4clXw90Nd1NOkmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] memcg: cache obj_stock by memcg, not by objcg pointer
https://lore.kernel.org/all/20260515171953.2224503-1-shakeel.butt@linux.dev
* [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer

and found the following issue:
WARNING in __refill_obj_stock

Full report is available here:
https://ci.syzbot.org/series/8efc6e46-4b2e-43ab-90a0-62552bdc14a6

***

WARNING in __refill_obj_stock

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      0cec77cfd5314c0b3b03530abe1a4b32e991f639
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/fda0a69d-af56-4b9f-8b30-b63ea4756923/config

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:380 at __refill_obj_stock+0x4fd/0x610, CPU#0: syz.1.48/5712
Modules linked in:

CPU: 0 UID: 0 PID: 5712 Comm: syz.1.48 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__refill_obj_stock+0x4fd/0x610
Code: 89 e7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 d8 ba 00 00 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 90 <0f> 0b 90 e9 a8 fb ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 60
RSP: 0018:ffffc9000483f4b0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810beb0f80 RCX: 0000000080000001
RDX: 0000000000000110 RSI: ffffffff8e21e93e RDI: ffffffff8c28b8e0
RBP: 0000000000000001 R08: ffffffff8239a83c R09: ffff88812103c600
R10: dffffc0000000000 R11: ffffed102d89bae9 R12: 1ffff110242078c8
R13: ffff88810beb0d80 R14: dffffc0000000000 R15: ffff88812103c600
FS:  0000000000000000(0000) GS:ffff88818dc89000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f80ad948060 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __memcg_slab_free_hook+0x2ed/0x4b0
 kmem_cache_free+0x381/0x650
 __put_anon_vma+0x12b/0x2d0
 unlink_anon_vmas+0x58b/0x730
 free_pgtables+0x802/0xb40
 exit_mmap+0x490/0x9e0
 __mmput+0x118/0x430
 exit_mm+0x18e/0x250
 do_exit+0x6a2/0x22c0
 do_group_exit+0x21b/0x2d0
 get_signal+0x1284/0x1330
 arch_do_signal_or_restart+0xbc/0x840
 exit_to_user_mode_loop+0x8c/0x4d0
 do_syscall_64+0x33e/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6eea99ce59
Code: Unable to access opcode bytes at 0x7f6eea99ce2f.
RSP: 002b:00007f6eeb8240e8 EFLAGS: 00000246
 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 00007f6eeac15fa8 RCX: 00007f6eea99ce59
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6eeac15fac
RBP: 00007f6eeac15fa0 R08: 3fffffffffffffff R09: 0000000000000000
R10: 0000200001000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6eeac16038 R14: 00007fffdc60cea0 R15: 00007fffdc60cf88
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

