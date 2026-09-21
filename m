Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66724C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 01:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123026B00D7; Sun, 20 Sep 2026 21:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACBD6B00DF; Sun, 20 Sep 2026 21:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB60A6B00E1; Sun, 20 Sep 2026 21:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7126B00D7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:03:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64448A624A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:03:36 +0000 (UTC)
X-FDA: 85235971632.29.956B45F
Received: from mail-oo2-f7.google.com (mail-oo2-f7.google.com [74.125.231.135])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1B721C0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:03:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3ZYKwagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.135 as permitted sender) smtp.mailfrom=3ZYKwagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789952614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=h/JWRPDnmTzkO48RL49AOEHMRmvJYjnSTPOTUHlxfVU=;
	b=2cw9Jbz9AA3jEq54MyIq7d/RE7fN+9/NMXSgZvfSpU6sCLTuQ1mcCh1f33MBKFhkcec0ai
	ZGBoc6O6PheGP2PP3G1mwtq+EVfkPLtGAWgENv0mIt4cp2xZNgjpf5SbjdjABuSGUszIGG
	hW6V9HOBzhG5RdMGec9tHS0m66h//PE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789952614;
	b=YnRyhCrmLQAxMdH8Aq3LJVDplaNIS8oHR5inHtE2OqYxgptsFcaOygwGwqaZX2x4SBSXM9
	NhnOXIAOsHOu6/rJw8lxuuicg3w/fn8+ZE3a0IirBP+5j5nIWosTB1snmUpi3NC01EOW8X
	1K8xnqWckLOrxdohtkGS2/JGEeBQv6Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3ZYKwagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.135 as permitted sender) smtp.mailfrom=3ZYKwagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f7.google.com with SMTP id 006d021491bc7-6b1bebb3ae8so1236577eaf.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 18:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789952613; x=1790557413;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/JWRPDnmTzkO48RL49AOEHMRmvJYjnSTPOTUHlxfVU=;
        b=mF62RPfF0chvVIRzB0RW+r5U0dR0P3Q21USvHUmmysBCrqoiVBaSif/OSoqYiOFyJR
         CALev+la+FZ5gDOh6OFO0flsn2l1rGvYah/u0yKmw1zNgjH7ihbvrselW35tfHDSsSIM
         I66PIWfK6y9/yC4l6fkOhLp2Qe770IacHZUZ0GmdBr7r98z/9Hekf/wSMG0f/MkWRmPy
         GHRgGB6kPQuhhW7HToaXiCFuuc8JwF9WQdpyllKqvqtP9i4p+73GmxM6Fgasfu3fr4Rj
         jtLXkfP5w+aJHiaZ/6ME50dWVfc52dPtN11asDWDrZOLUspcrKx9RvySt9gaAMQ5t2e5
         rapg==
X-Forwarded-Encrypted: i=1; AKwUvBzD7ZaEkiAfCrJ9FtqeUxWXLIubmOsrfqv5kNZbDxY0mFb0Pq4qqa5VsbHdn5/Zm3jIzFFbMh8WgQ==@kvack.org
X-Gm-Message-State: AFuF++n2+cF3S4nOFfVBLIAyBwfQQFpq4syqjM7OTV6BeAntnuSE1Wkv
	ezzD2JP07yl+CKNPT4p5hxOhFmGECME2UJjJ2paI7A0FOmQzrcNmhv4JJjE5b9h+uC2rg0sxH7D
	s4rlIS5YyOntnWJUeLizwuhlQnWwsxSJRcfW6KlplCI2nPm0W7awIxa01Zw8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f036:b0:6b1:2f12:6c0c with SMTP id
 006d021491bc7-6ca9bf4f83amr8557844eaf.34.1789952613686; Sun, 20 Sep 2026
 18:03:33 -0700 (PDT)
Date: Sun, 20 Sep 2026 18:03:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab08265.71f81b7d.15fa6d.001d.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in copy_mm / lru_gen_del_mm (3)
From: syzbot <syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1B721C0006
X-Stat-Signature: rg1fscx1n4kewto84uoeikzodjmxcn8h
X-Rspam-User: 
X-HE-Tag: 1789952614-436313
X-HE-Meta: U2FsdGVkX1/2mgGnLDnsEVm1MsdTSaHTTc8HzFbBjesenGajByWWbdK9ibq99GO3ASKLtvuOemLx3kPQXqdzq2YIq0cILZz0byVcxsL5Q7PsUMASab4L3nF9LW1uRUgWNKM7r0O90Uox8mvOeoGYF3jnBP5CSh+ceDRe2Gi9pjs25rks7VL+jOh5y99AkGSNBrLz9u8eVpVJhCcrLx/L/KOhmpy8Glr8Mt9vqYuIEvLL3HXeUZz4B8lPVhmLnBIL2um897WRwAQk7k+A506vJRy7HlIDX2Dl36vYgppKp7Zlta9TphPv7wTRzepSgvIqEWVBDYQPlzsToSXrVDjvBalZqJiY99Wm5A+2NA1kTTStO2UpG4JedOg7NTmHAcSDWjJiqBM1Gi/S1gD1+pcOF5BGOoLuQN6loWvawj3Hdh+punSJODetJ2ZSkBmJJKvxt2a/AYfnM/o6yjKbjPmZATTzeTJ9KCDBr6nVz0i6kfwtsT8M/zf9Xu+JbxjUyz5RoIfQt+QpsYQ5h1eNi7LSbmmBWWTNO24SJi7eyf2FkVpIJiMYbk1Rwx8Tzh8MGdL99Fpo+xDFoSztkzvMrGcSa48H8Byv9aCLLqfeF4oE6nRZUMEh1TUba42pJaktgAJ6hfup5OioVCBYuKP0U+NcXNsXAOwTNDzhNIs8l/3VdLtHlnpW41lv75/f6Y2tFJ00Z9Z4oRf/t3shW6J5f04ftuJyVmlcHsQFG+zWK7erV4CpUXZAIkcI57w6kJYqgDzTVo4v5i8VcL7uYeJA/6wSx6tTAq33XujLGZwEyDheQM2MhB2CCQijz9N1yW3Y+WGqHmtV87/tJwUHru4NoPOBAxPKpkp5pykbJxTriLA9i3QulR/m/0/Ku/0JTrddJkCtcMKsXmkbovXEE9+VQdDuTulvfxHGTYCChmOGO20JuDHXospKhi6o6PmZ6hALEVnZ1TK1bbY75ALmUbG3UkD
 TPZA6EAq
 vTzRTbjBOO0JBVkjwvzhLIJZ0ivMWA9LXX9yghuRAQTPIRPFThQr1tGrxMwug/nzvSUaMYMaeSlpX5gI+1lWqiI7TZLGUTNjB20+EH5bO+AH2oJxnRDVI7wv42ghSelvQyurxbt8s6miktqtTGlAiuhYVI7gRu3N95cwljv9dROhGX9IXBo1HBBv+F+glswki39U8Fu+MWaeT5coSxddXiU2eG7YhdujJGhwV9kFFvP0yKa3bVFHhFttGLdrC5RgxAVPkbfZQX+4G3sga8p70wk4hyBWGNolAtyFXbV85rarQGb8soM4bM3vHY7N4dvshqIV4i4s0AS8KWdLlFsFuIHOcOItstsYfnqG9M/s4YqkEdLU5vyHv8J9pU2qMkQ1TltLqa55dYs06gPJ8XFmbcaFRuBNJ2UynE1VSK/WzKjVIzJjehhpbULI8EXRSFIS6Qm5+u6Yn6GtGsff1gAA4hR6uim+LJBG0hP6PPCVvRBLhveJJKlxTpmKN754S97dIaPVbxsP3VLu0TgLgFi8D592bZyTj0JKmqfF6iaMjy6vBeBA6WzQWjwdJUXnJFnlCxhk72my4DdsKU/koWc8uNyGfn8aq4I1P5hB++kqQ10eCDgimwgoat9/Nan15ORPc2uMg3hMCGZyKwWGYSqS359uAHfAfhTLA9e6BwNPlcFZeXu0x3KNICgjRdcEO3UiHy3g/sPrEw4K+PTBpm1VxbHHx20NxXQ1xRrpAyvQChg0w+1D6oSkwRHe86FaVoSn1VmI3NheEnlZuiVr6iI/NhKlUTKtujgNVUm/sBxMzz49lwIKIhO/quPWZ+ViEmlvNFcL04HVRRHfPpnxWnolvHJiQ3Bv1LPyR09io+yqnvkSA5pAqtRvg3ckd+7mVUKjOqBdx4bZYm4GyQZfVQyo/JyxlNlqY/Pak6484Rj5SZEGkBrfdpCf5+rXLdw7OVwA4OaYLhXtQPV5bZpwwAyigp1txyiXc
 22tMM6cj
 7BHLFfuW31jKtuJ4oH4pfp5/FWk364zj8RJtX6K3fglMQE6jNcWVZB3GYz0xLu8d/A7HPoQnDaTDy7msBvnUQtSnkUxMMd+xfpLBktGymhoU38dY2AMwIuz3V73vC4AVe6wfx4fJR6n4Yz/hFMd6K+5sfHkrRfX2etKZxmdZy0HKuQWu9dUvHpSHaz7ErXl68yMuGOJeYxOqLqSi7imr7+7G0S4/RTp87/HnjP0nOZEhpp/elxCz+UMBrHo34e3Slq5L2QF2H4PfAIi+5jzhJBaLiZ+WxZcUnMORSOEk0aV1CUG5Bay9sZDK4H/Dt10PF0BBagMT3ItuqvbGv6M+y6iJbz/NA26rMt7dkxCys7FsUwTxylEMVswLnLSyaenoU7H5iUm467NB1JdVuTDEg4MF/IKJiUE0UkNPgNqUBSWXzNZXAd1+THVCHqHsWxJi+GhYQriT3Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    17e7b8eacf4c Merge tag 'cifs-fixes-7.3-rc4' of https://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d6c525580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8372e2cd52628d4f
dashboard link: https://syzkaller.appspot.com/bug?extid=c6e1b1b32ff2fc3b7d60
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/60ea54622289/disk-17e7b8ea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/675e38c8bebf/vmlinux-17e7b8ea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1006b8efd827/bzImage-17e7b8ea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in copy_mm / lru_gen_del_mm

write to 0xffff8881077eb088 of 8 bytes by task 7336 on cpu 0:
 __list_del include/linux/list.h:241 [inline]
 __list_del_entry include/linux/list.h:264 [inline]
 list_del_init include/linux/list.h:333 [inline]
 lru_gen_del_mm+0x299/0x3e0 mm/vmscan.c:2998
 __mmput+0x17a/0x1c0 kernel/fork.c:1203
 mmput+0x40/0x50 kernel/fork.c:1216
 exit_mm+0x113/0x1a0 kernel/exit.c:617
 do_exit+0x438/0x1510 kernel/exit.c:999
 do_group_exit+0x138/0x140 kernel/exit.c:1154
 __do_sys_exit_group kernel/exit.c:1165 [inline]
 __se_sys_exit_group kernel/exit.c:1163 [inline]
 __x64_sys_exit_group+0x1f/0x20 kernel/exit.c:1163
 x64_sys_call+0x254f/0x2550 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff8881077eaa00 of 1728 bytes by task 7337 on cpu 1:
 dup_mm kernel/fork.c:1537 [inline]
 copy_mm+0xd6/0x340 kernel/fork.c:1595
 copy_process+0x10ad/0x2340 kernel/fork.c:2310
 kernel_clone+0x1c0/0x5f0 kernel/fork.c:2769
 __do_sys_clone kernel/fork.c:2911 [inline]
 __se_sys_clone kernel/fork.c:2895 [inline]
 __x64_sys_clone+0x143/0x180 kernel/fork.c:2895
 x64_sys_call+0x2479/0x2550 arch/x86/include/generated/asm/syscalls_64.h:57
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x112/0x360 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 7337 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
==================================================================


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

