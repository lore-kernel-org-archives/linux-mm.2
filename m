Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27047CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5384D8E00E5; Tue, 14 Oct 2025 07:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50EDA8E000D; Tue, 14 Oct 2025 07:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BB48E00E5; Tue, 14 Oct 2025 07:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5738E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:22:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B01521408C2
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:22:31 +0000 (UTC)
X-FDA: 83996481702.23.F9C84F3
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B1E3160010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:22:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3dTLuaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3dTLuaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760440950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ZlvmqkdNIV9+7iUIDE30YuWq23qFAdlP503srGLc0RQ=;
	b=QzzkVesj5G1e2Xb4HhD4ecEpb1tGJt7oi+b8zQ3WQjp2x1sZN8/VtbGCsbIxVNHmYD9oU6
	hEpW4FZaqUqfWz9KMtPmXGlsUzEM7lii2t+pV0dtuD2CGaEVCoPuduN0Qk3X8TFyGIxz9R
	WVFohMMydVwuZCMWVSAzmYyuoidJDZI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3dTLuaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.208 as permitted sender) smtp.mailfrom=3dTLuaAkbAOAUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760440950; a=rsa-sha256;
	cv=none;
	b=0qnVeDzpd2cMNEwFFz5TC2woMtwOuN3CkmyBwImyNFHARugqffe39hfnanJgyfsx4GC/HQ
	A/sagI7WPkLuSpvNUuYTXgyzHUbNdtMZPga8B2wPgFP9V4s0uWIpEuCIAsLWPAWf9Wxobf
	JLfZI9TjOV/iijSfwzraat566KcFEdw=
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-42f86e96381so143739865ab.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760440949; x=1761045749;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZlvmqkdNIV9+7iUIDE30YuWq23qFAdlP503srGLc0RQ=;
        b=Ts1DLLz6hUQswGXmigD6yjEPoBMlo2VLl12RWKdV+bejH/igrJFeLg/jprucMKUrJg
         bhxjm4XewAPGA2SjjteD1RU4TTFHSvu61oXEdFvL9alqhivMNlGidFBR/yCXZVAx8Mln
         bQHa6tPIL2beA7JsjiZWtu380FBbNj9Ud5W3Pd8rQywXZhbEa3EeY1L3IJJW+S2y4Mfg
         5dwGSGUWRCB7w7eUCpJHOC9XYbSSkNvcQ9/XXX0SgCHEZcibsA3fYCNmlSSXBm7vhgfh
         NG5jjyYzCv6lXBV28e0nM1U7tdBgn3Iv7oxvkhi1vNrXq7Y3O5vZNopd9ap3WSXVZUfG
         4sug==
X-Forwarded-Encrypted: i=1; AJvYcCX3/0jaXH8jGdq5Ua427iKS1fofqZZGt728EI+Q1JipwNk5yurvYLctTMawb0Tb2sDalrcwabaj5g==@kvack.org
X-Gm-Message-State: AOJu0Yz9xcppdVaXfWVELV3el8MPRSfyK4rT/ccjJtCJ8JuPwYDUn3w5
	l58pIiwaq87SQgbNyA0HaUOwIxjgehZSSdatmuZmKts6QEVSgmuezfXQ5w7xUra2EPZWo9R9TMc
	rgte0DFZOpZMwOE9cqyJiVpQsvS/7zWD/Tw7YLgpPJZ2uQYNs0ah437fLwh0=
X-Google-Smtp-Source: AGHT+IHBc+6nX6M44fQ1kDfbGruOPgZXzxBeLykvnAo5stWBgtzwS3shiyAOy+CriRvGJT3CZgCC9dZ4EODb0A6bvUDMR/ng2e3j
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184c:b0:42f:9c5d:81b1 with SMTP id
 e9e14a558f8ab-42f9c5d821fmr180067085ab.32.1760440949025; Tue, 14 Oct 2025
 04:22:29 -0700 (PDT)
Date: Tue, 14 Oct 2025 04:22:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee3275.050a0220.91a22.0209.GAE@google.com>
Subject: [syzbot] [mm?] INFO: task hung in migrate_pages_batch (4)
From: syzbot <syzbot+f523acb98cd782b4872e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B1E3160010
X-Rspamd-Server: rspam03
X-Stat-Signature: jhhijkjswm1ykprfq18o6assir8pyxrn
X-HE-Tag: 1760440949-478659
X-HE-Meta: U2FsdGVkX1+8P2+OnKlGIP4OF21leVIBoA6UQMLeIcPQ7Bcx1ivi4oaST8O435Wu9/yO949CrApMbfx4w3ZSl/UN9bZvWsnxPCme4AEu/pwf1qg2t+vcciaeZJhE7O9wc2mhqCW8xHG4XL69iOD0ouUWl37Q9qvxNcfr1PDrjeXVIW8CfUggUJciC5SxF8idNY6kDY+63zRfB3YZPX8HG/5cxmNzzrue2R9slcEWpqXQEKaKiOs4WmUxubGwmgUajWBjt/3zc9jmiHSjZ8W9f8aYnw2/AKEtObRtEAV6vykmpvlAnKyomFRGtQJ4UMXTxXp+BEUXAu5X2qbplcW+45nnPpNaWPfZm/p6CIHvorFysEobYnTjYx5iwLkDULg1ABU6LOxYhIlzUnIYblDP+gCvNoHpK7CiaHPb3MwBXWJE1ICTz8vlMqXq4Cf/QEgUOSQc5IocVFhuQGeFWUgnc6EVuMf5BYUUvKQLNv8e3gVH8KV5KBYsBv65s2ztd84AeyfCW4xPzUhshL+qO2282bRvn2nS9LYAH0mIZFylhh2+oMZik2YykpsYHOypJS6B0Q+CqNkEjfKmv7aHcwPgGdqgmNkjGN7nq7BXzg+SH4A6Kw7rSoDKNSqBJqULEoEQFpAQIvZdwSrm0a/1usZBXj7Npp2t+4GMOz7LWK5tYHhKbotkwcc/Y4B4bfBnMuQx8a/JozbVYos0HspMU50AkSlzQDcen3Hy2CJU69FTBkCq1tGYZ0metSeBn7wCjPdDzbmyQ+PLvBWY5w4xfi2XQTWRxK6Fvffi5mgW8OXJx5RnASd01ncO9w0xPjn8662z+czqPghAAjdfNWb8xtatdsKuDn6FOenGe663DcgDx/jmt+c0NbM/02rE9v7CLGjxpdJo7zIi5sRYORMUhJE2sj75xcdQJyhUsqEfo5wpcQYqFTMblCm8x+IMgKW8e5TLxbvIgvmHyPP5EOxB9Qd
 wF9V3eZf
 tR5pS1Nnow1W394jlVPNpQ0zatwBnrGAlWeo7vKKiyhibfIeHJicEHM/NJMS3v3RoxpQniAGyybFKce0PJv+WlcLQfGEOjwWo5iHBqsyHaFyykkixAkIJ7DW9tx+6Rgx1qo00eWKM9y/9qbbhBi16QKWORLSAI31tgdvzNPwyyeL3SrsqgJPsmQpItZk/KJYXAlD4Wz8sutMb7OjLjrmfI8u0IycwC5REq2p4GBZHwnAXkgRGwl7Qh8smGjiKEIUyvKyTmRRyb3rQI9DXBZt1DhJxE7KS2NCxWnVfbIV8iftMrAQsPSMxFXcQ7k7dMUwVcqI4LJyrhPuCymnxEOI/knG/DkvZkpdw1DWbyGX3soAhqdckDU+cUNa+UiZajs6mbv2BtfGnwlNY9yxEoZCD5Zo/baErPQ49COn33jj0+xS5s5wkmvb618GNyE90m2Pq0462+fSsJGq1idrBQgj3c86QatuHjTLTY0dD7fgoqNE0Pz2kEnkfO0RviI6dOurgPkgt/GySG8XEP3uevx57tcUwFoI0fE7hx0ZGWnox2SsqJk4m3X0i6H0m988xLoq3eiGNRCrLDdIs8S51W1deceJHNYhmQqIOzy1xDTvk7NKV/kTOzUIp2WEjqhf0kjJM1shyvIDBzdwS54UFN0Kj8QHHHkDW8y/qEDGdl7kaPiphCH5LRoek9CkwBiomx6pefRV32p5gYW1EZoxx4dQTKJNjHAP1kJBh/2aqi1xYen9BFm6MjcRtwRbtPWP9LfziJuRofiUh3kyiJVIwsykvY7f8ulnpg53CHtZOEv0pgL48zkoyo/GRH/toI+wwkiu1XaqkeCuIWGsrrWG9fNhL8oBS3OPK0Q7JRhPL8/G9NaKAtgY7sdCoIJJqHfj0yjJRhZiJjYjgYF3iPGQ/oFxOsA8VMvFIeJSXobVoTraJ5iTUyxWPkxeeTFjHoPv24aYxfEcT5mvnqRvVV3hZckt8d3bA6WF8
 RLx8KZpV
 EQmr27qOLdT61K7gfsnwhHr9t0mUQ5FmWsJAv/HXghkOtxSCihloHho/jjCnA86OLQRF5xAnpJS67oxUP/MDZaHdwxeQDg+/YG5Br9xJo4Vad9JnXdTvB8uxc2kQxZkjqAwVYEKWmvxAHJoYXM4+JYv7r3SdQAGpOxDKwFmS6B+A7e0HEKK7DJcVmbz2cqjVcPtKdvOPEeHgzQrSK1WPMe7P1UeC3eYHCGnFDVPRV3gspiZczuECKtG5I0K4nqHV0fLy6Br3IQexl3jyz/+AY+7HU6t8HJpr5ip7lH0ZZX2QrK98W+A841p+WY9Lqz2HQgjLc1pb6HNMSetSuN4/QgVWmEExwRpclCOq5BNVLjVnuHqW8PiCvTspvHQpJgl9RtHj652TgEjCc9yOdv2dV7iEmyA0gVbfMVo5xu2wKL7856473BxAYX116t8Pb9r81PO0iE226ozHmVIN2h08IHOhwK9P4x8XG1icDUnx66sfqHQ9LPsMP9x8QdIYt7kje1SYl8rstWJKxBlUHAD3gskXfQMnrvuJJoZqbreYjjPFlp3lWVIOZXOzeaNW+rwuJm625kpzuTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5472d60c129f Merge tag 'trace-v6.18-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=129bba7c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8dbddd36d9f68a5e
dashboard link: https://syzkaller.appspot.com/bug?extid=f523acb98cd782b4872e
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3726636cb074/disk-5472d60c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c893bfa7d66d/vmlinux-5472d60c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b93fdd7cec90/bzImage-5472d60c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f523acb98cd782b4872e@syzkaller.appspotmail.com

INFO: task syz.4.865:9483 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.865       state:D stack:25592 pid:9483  tgid:9481  ppid:5824   task_flags:0x400040 flags:0x00080003
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5325 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6929
 __schedule_loop kernel/sched/core.c:7011 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:7026
 io_schedule+0xbf/0x130 kernel/sched/core.c:7871
 folio_wait_bit_common+0x3d5/0x9e0 mm/filemap.c:1330
 folio_lock include/linux/pagemap.h:1141 [inline]
 migrate_folio_unmap mm/migrate.c:1241 [inline]
 migrate_pages_batch+0x1487/0x3bb0 mm/migrate.c:1882
 migrate_pages_sync+0x4c5/0x8a0 mm/migrate.c:2026
 migrate_pages+0x1b5f/0x23a0 mm/migrate.c:2108
 compact_zone+0x2018/0x4750 mm/compaction.c:2647
 compact_node+0x1a3/0x2c0 mm/compaction.c:2916
 compact_nodes mm/compaction.c:2938 [inline]
 sysctl_compaction_handler mm/compaction.c:2989 [inline]
 sysctl_compaction_handler+0x141/0x210 mm/compaction.c:2976
 proc_sys_call_handler+0x442/0x570 fs/proc/proc_sysctl.c:600
 iter_file_splice_write+0xa24/0x12e0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x18f/0x6c0 fs/splice.c:1161
 splice_direct_to_actor+0x342/0xa30 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x174/0x240 fs/splice.c:1230
 do_sendfile+0xb06/0xe50 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1425 [inline]
 __se_sys_sendfile64 fs/read_write.c:1417 [inline]
 __x64_sys_sendfile64+0x154/0x220 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f298278eec9
RSP: 002b:00007f2983563038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f29829e6090 RCX: 00007f298278eec9
RDX: 00002000000000c0 RSI: 0000000000000006 RDI: 0000000000000007
RBP: 00007f2982811f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f29829e6128 R14: 00007f29829e6090 R15: 00007ffdc1780a28
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/0:1/10:
 #0: ffff88813ff51948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3238
 #1: ffffc900000f7d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3239
 #2: ffff88807d510240 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x1b6/0x6da0 drivers/net/netdevsim/fib.c:1490
1 lock held by khungtaskd/31:
 #0: ffffffff8e3c44a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e3c44a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e3c44a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0 kernel/locking/lockdep.c:6775
6 locks held by kworker/1:2/3733:
 #0: ffff888144ec0d48 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3238
 #1: ffffc9000d22fd00 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3239
 #2: ffff8881447a3198 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:914 [inline]
 #2: ffff8881447a3198 (&dev->mutex){....}-{4:4}, at: hub_event+0x1c0/0x4fe0 drivers/usb/core/hub.c:5898
 #3: ffff88801b7bb198 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:914 [inline]
 #3: ffff88801b7bb198 (&dev->mutex){....}-{4:4}, at: __device_attach+0x7e/0x4b0 drivers/base/dd.c:1006
 #4: ffff888053dad160 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:914 [inline]
 #4: ffff888053dad160 (&dev->mutex){....}-{4:4}, at: __device_attach+0x7e/0x4b0 drivers/base/dd.c:1006
 #5: ffff888075830068 (&state->mutex){+.+.}-{4:4}, at: az6007_write drivers/media/usb/dvb-usb-v2/az6007.c:178 [inline]
 #5: ffff888075830068 (&state->mutex){+.+.}-{4:4}, at: az6007_power_ctrl+0x2f0/0x800 drivers/media/usb/dvb-usb-v2/az6007.c:703
1 lock held by acpid/5169:
 #0: ffffffff8e3cfa38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock+0x1a3/0x3c0 kernel/rcu/tree_exp.h:343
2 locks held by getty/5577:
 #0: ffff88814d0060a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41b/0x14f0 drivers/tty/n_tty.c:2222
1 lock held by syz-executor/5797:
4 locks held by udevd/5809:
 #0: ffff8880496228b8 (&p->lock){+.+.}-{4:4}, at: seq_read_iter+0xe1/0x12d0 fs/seq_file.c:182
 #1: ffff888034640088 (&of->mutex#2){+.+.}-{4:4}, at: kernfs_seq_start+0x4f/0x2a0 fs/kernfs/file.c:172
 #2: ffff88804ae63008 (kn->active#24){++++}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:80 [inline]
 #2: ffff88804ae63008 (kn->active#24){++++}-{0:0}, at: kernfs_seq_start+0xbc/0x2a0 fs/kernfs/file.c:173
 #3: ffff88801b7bb198 (&dev->mutex){....}-{4:4}, at: device_lock_interruptible include/linux/device.h:919 [inline]
 #3: ffff88801b7bb198 (&dev->mutex){....}-{4:4}, at: manufacturer_show+0x26/0xa0 drivers/usb/core/sysfs.c:142
1 lock held by syz-executor/5814:
 #0: ffffffff8e3cfa38 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock+0x1a3/0x3c0 kernel/rcu/tree_exp.h:343
4 locks held by kworker/0:4/5869:
 #0: ffff888144ec0d48 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3238
 #1: ffffc900043a7d00 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3239
 #2: ffff888029493198 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:914 [inline]
 #2: ffff888029493198 (&dev->mutex){....}-{4:4}, at: hub_event+0x1c0/0x4fe0 drivers/usb/core/hub.c:5898
 #3: ffff888031acf198 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:914 [inline]
 #3: ffff888031acf198 (&dev->mutex){....}-{4:4}, at: __device_attach+0x7e/0x4b0 drivers/base/dd.c:1006
1 lock held by udevd/8053:
 #0: ffff888142f51358 (&disk->open_mutex){+.+.}-{4:4}, at: bdev_open+0x41a/0xe40 block/bdev.c:945
1 lock held by syz.4.865/9483:
 #0: ffff88803451c420 (sb_writers#3){.+.+}-{0:0}, at: splice_direct_to_actor+0x342/0xa30 fs/splice.c:1105
1 lock held by syz.3.1367/11417:
 #0: ffffffff8e3cf900 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barrier+0x48/0x6e0 kernel/rcu/tree.c:3820

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x27b/0x390 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x29c/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
 watchdog+0xf3f/0x1170 kernel/hung_task.c:495
 kthread+0x3c2/0x780 kernel/kthread.c:463
 ret_from_fork+0x672/0x7d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:82
Code: d7 75 02 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d d3 e6 24 00 fb f4 <e9> 0c 0a 03 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffffff8e007df8 EFLAGS: 000002c2
RAX: 000000000252e2c3 RBX: 0000000000000000 RCX: ffffffff8b6532d9
RDX: 0000000000000000 RSI: ffffffff8db02c74 RDI: ffffffff8bf1d240
RBP: fffffbfff1c12f40 R08: 0000000000000001 R09: ffffed1017086655
R10: ffff8880b84332ab R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff8e097a00 R14: ffffffff908329d0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881249dd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fc0eff8 CR3: 000000007dd80000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:190 [inline]
 do_idle+0x38d/0x500 kernel/sched/idle.c:330
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:428
 rest_init+0x16b/0x2b0 init/main.c:757
 start_kernel+0x3f3/0x4e0 init/main.c:1111
 x86_64_start_reservations+0x18/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x130/0x190 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x148
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

