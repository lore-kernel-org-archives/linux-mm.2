Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20758D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 12:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE686B0005; Tue,  9 Dec 2025 07:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077726B0007; Tue,  9 Dec 2025 07:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8866B0008; Tue,  9 Dec 2025 07:16:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D01016B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:16:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F8A18A822
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:16:30 +0000 (UTC)
X-FDA: 84199830540.20.F70336E
Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8A94F2000A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:16:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 3GxM4aQkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3GxM4aQkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765282588; a=rsa-sha256;
	cv=none;
	b=5CZfCJhEJaYNUPtKyGBa0NB33FluAVbc4uBcr9NoPZ4JiyOr5trdogEM/fe1Ln2k7PjgOw
	g7SPOAKYdlMHA2PI3GOYgedu7wN8IH8EXrWW5Z3LALg0U24pNtC4auXsOiY6xgk40zRDFt
	FGWD7Py/yO20B3nC/tjsgn7UxxI2zsk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 3GxM4aQkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3GxM4aQkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765282588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=N/uM2X39VK9KGgzHBxwgtTqja8IFkuw/J5CQxJyGUM4=;
	b=EED1OWsidt1m+hj0acd1Fs4GpVGGJjPI0lyP6JXb2xD5nBqgjFFsiqvoHLTrdMB48PCoAK
	pv2TZ+94FsYY2AH7ASdt7fvvVJe4dzgXZlBvOtq3pnTP2Ul8mxWKr3RZ/lIhyjmci3t8q1
	7YyDX7vWQ3zRlBn3k4NXdbPKirZozaA=
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7c7032a5b40so5400199a34.1
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 04:16:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765282587; x=1765887387;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N/uM2X39VK9KGgzHBxwgtTqja8IFkuw/J5CQxJyGUM4=;
        b=j6Ia9qa8YxcLDFLEVPbxp4r/CN3BV236cv4l6yDYIkAuGRAAVDcjc5sipfgQ+OHhcj
         0jK0AU9CNo9r7PeOPixJdh1xKBA4RqGY/mxD5sww+VqG+Y5jXg2lGzQ48LVUQF/p2Ki/
         NAugi7qPzYtVGJcrD2nFnNLj+SiBdE0POuxnHvhCAM0OwxNhNg9abBAR50xQGtx9yvwL
         LMavwaq9itRgiHMEqNVOOoZZg2TuKUqiT5Yyvo/wE8gNa1HnHTD8cQ25KQaQIYE8u+SQ
         nu1YpS5ziXx6feZmVu9ROchdpMXEFC8rHGlfSJdcH4XKhUFWeS7i2wDyq/E2WUVzK2fg
         Fi6w==
X-Forwarded-Encrypted: i=1; AJvYcCUGgDIZFGesyD1G7e3ZWN6k8cAs82ZIZZx0vH3b1gkCje1au79aVeQLdNyOPsPcLKc4Lz/DLh+MCg==@kvack.org
X-Gm-Message-State: AOJu0Yw/UoIRLuo8BPYPf/wZKDG0gvkwBySZqIVFcIpND8dj7IShS1wO
	HpyozyzNcHNc7/ijLe2iqF+nNZ3F9a5QXolxlF5r9RjI10H2PJLZUE0QFhGu3k4ffbdJyM2+szj
	KMdzCxLERJ3P+7XsiITGUCfeVJsrsV9oHy9iTwqsGgrJzegzk0EJoyjFvx0Q=
X-Google-Smtp-Source: AGHT+IHDa9f5juZBS+Zx6u44j1CWhoT2+BzGGjqYDErBrr8VbE8OglzIH0QZqyauT5Q9M9GGrLyFTZD/tJvIe2YRmp/HhStVLnCL
MIME-Version: 1.0
X-Received: by 2002:a05:6820:607:b0:659:9a49:8dd9 with SMTP id
 006d021491bc7-6599a8e96fbmr3928732eaf.27.1765282587547; Tue, 09 Dec 2025
 04:16:27 -0800 (PST)
Date: Tue, 09 Dec 2025 04:16:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6938131b.050a0220.4004e.0007.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in shrink_lruvec
From: syzbot <syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@kernel.org, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A94F2000A
X-Rspamd-Server: rspam10
X-Stat-Signature: j7runax8zmki7so7u6mjqt5m1w1f8u5x
X-HE-Tag: 1765282588-880645
X-HE-Meta: U2FsdGVkX1/v8w/vNPTPbgc0mG0UHxpkyq7mB9bO2Tp/C9ufxNCVFThY2bor2gIq1oPQ5SGb/4vVVdZ++4879xyYSjSzwKiXAdxhbdFX6gHFhIhFCEOBMUNEix/yANTpTn6RpLhPZORsCVl20KIo6YHYbfC5SB50vJmVl9i10b1f0G944cjD0E7YLSNZTXNLPoiQsGqmqN8rTPlNo8wk/B7Q2G0iYP2zx+HerlX0QMH+ZGm046AKnM/WLWA4n9dL7rFlcL7fFNCT+6bMEqeAmm7NicLyc+OQU+autxfWDoCIQWhkHshJ/k91VJhJ+WjVLZxWNN4pMQKko2TsO8NwL5xa/8B/RXLwR+vdSuj2s7iiNUMXImQGduG6PlzcLXvEG0j9C+Xe3tCwJz/gPx5cHmbttXHHyLeHgt0Xk2+FjGWTPYM+znirku71421SgW8rTfcf93FCdN1knEcfq0Wr89IBvMO/QmWjNprInRb3TUlmcdWYdAT1FOsEXbS6wmhpZzv8L2EwMtEmg3xehWcGrFqfRHY2pX8d+U79th0FTku2cjJKqWJDjS/B8Ng9o6KwH1HMj4+auD+MJp4IR9Phvj5FT0o5SWxlhz9llLPMZyENJnwS4OlC2ZZRz4/wfUV4yHkK5/WVCcx5QCwvWSmkKNy1ObldJl3cAJdDjm0GP00FD5tqvyzUMUvCetBBYAi+673WPmxQBNKMrhDMBOq6dFiYzU8nVH9uvU1yJ9NYHfMpurxueFXM95hpm5QBAvDkWiXeUuEQWWDCECV8Cu8E02Tz+5wPg8nHgh7HFsa5CIwA/MasOyFUf+0rtP3Y8h0cTBqrjc+mDBFkpFBAyMa+V3YtEM/lJRZtn+vmCOOVz5qSOC5fs4EdDgHnicooyWw8kfay7evi0Pu6B7TuGCe8Hghsv9blFNz1CZjgnUHre689QLMGdNlwn40TKb9HtthL93eBDBEpe1xqKomgdtg
 u5njAUH/
 DAKX5JIGN3eGcDgU1hqbN//6MTcZOmkKeAXYv4lurZq9TJcdHsMOiXjEUF6RxjwcGPKQ+6WkHBp+zvoz3NxcZmWGuMGwMTWtB0I0GCOuQQJN7SXZQwsuwIkQZXpSqNx7GmWhl6BjmYJ8ziLWGDfBEumJLEJbUg1WvzKnjMwFScq9E0w44i4e5G3vsaYnUBIXhZtHD/Jjf40ecrwS8k4Zg7rHecu0g1cWJNelTKYyrwmKtvCL1T+aSEqg9xNBbqUDlsVnxhCCGd8enxOj+e2RxHuX998H3JIzlPI46SQdoyTPGxt27AMtp69yQYLR5goKIPZ/NUsZp9+1esKdyC17oMw2F9lybH3rYO/0dJ2KlnpEBw9XOWa0lWBetVdqPXW7y+OXBgABhNt/Jh446WaigPh7xacpcdwybEJFX6bZKSNg598Qzf/ocOyPdINk+sQ2a1+3yB/cswvoM0W5yFzCsjtYKcxSJIgBYIiEr8vnYZjY/qN8lak7OsckUYdn2eF+fLQhDzL6VNqARiXxrTO9i98zSxu3yVv3YrcXImIejU7xDtKybhLfbiyGDPk8lzG5kAy5xQKOc+ur/rZOC/dQ4dzZUEHT/ibWiiO9tvZQhtpIaiIfztlJMowxeOivRS/8LMrhHMBaiGcYhUNzUH7SQpXizoO1djHtaNVu+8WR3r9nmNAKlID0OHMnYfPGyq0p96zQ9OKRj2utmZEnx9IeBOv4JswTqFO4uGzw8wZ3wVsHaDJPHOyQIQPfll4t9PeP+oNq/40UNs7iYPEouDs0WOjvhqdUjaANhEFzy2TPoqfq7ETBfY43z6eyg3LlBcOS9FbT8/0vz6XIRD9t0IIiYDrNTBWyd3cpIN8Oc9rhofRB6JdcBu89yn2FiufzazEDwtKSHPKXU7K52ed8Ufj6E8WXETVUYGHY1G8EEjOxZV2R83IpiNW5RHiV4Byr8+HLejsJTPQ28sYBkuVUdHd1tmS7pUbrE
 vCs9vd/G
 CFp64WUu7+qW9uauRvy4qJu+a4JRYNeYZJIDgoPmPBbCwBkwQtYK/JnsXoyGiwEbFwTrd604fSY8kXfjqljr1Q9Dn5G2wn2uMIqdSq5xSL1VaGeQFGoQ/JP/fGJ88ekztdOyMV30HaEDQDnZV2mYv6L6GvlwOSrwXjVxTcbrelD/20I9TC7ZMmVfNcZKjConWFQvwZfTXCurGw50ORp4U0DfSItOl4ZigludSeWyMnP24QGs0cuy+KjO58ItrwhqjtwSddTgGprX8pWDfSdP32TK6UYm30A37kjeZ2II1QMMirBxGFqtAvobEVeKvCrNZ5f2qju7WARUVk3wqgnBGUQashvdR/AJFnKGK2PVzkIJKRuwFh3tRvzkP7Xt1faJINUkdKu+mLJ9F7gpBt8G8oRt+SCog2yt11Ts7NnXA16unTsj23MVad/GiOxKyqrMgR2DDnOzvQKZWnOA4pTY/QrFLCORjCUSI5WIb7bo2qrrQraCFONVygzZWUAwbq8q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    2061f18ad76e Merge tag 'caps-pr-20251204' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=151cc41a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=879619bdbc37e7fc
dashboard link: https://syzkaller.appspot.com/bug?extid=90fcab4d88cffed6d0d8
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5fcfff6f18cf/disk-2061f18a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/36b7247e87d2/vmlinux-2061f18a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e2f1eee5ec54/bzImage-2061f18a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/vmscan.c:5049 at lru_gen_shrink_lruvec mm/vmscan.c:5049 [inline], CPU#1: syz.0.6406/391
WARNING: mm/vmscan.c:5049 at shrink_lruvec+0x253b/0x2b50 mm/vmscan.c:5818, CPU#1: syz.0.6406/391
Modules linked in:
CPU: 1 UID: 0 PID: 391 Comm: syz.0.6406 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:lru_gen_shrink_lruvec mm/vmscan.c:5049 [inline]
RIP: 0010:shrink_lruvec+0x253b/0x2b50 mm/vmscan.c:5818
Code: 89 de e8 78 78 bf ff 49 8d 46 34 48 89 44 24 38 84 db 0f 84 cf 00 00 00 31 ff b9 02 00 00 00 e9 42 df ff ff e8 06 7e bf ff 90 <0f> 0b 90 e9 45 dd ff ff 48 8b bc 24 98 00 00 00 e8 e0 90 27 00 e9
RSP: 0018:ffffc9000d5def60 EFLAGS: 00010283
RAX: 0000000000001170 RBX: ffffc9000d5df120 RCX: ffffc90014135000
RDX: 0000000000080000 RSI: ffffffff81fe1a6a RDI: 0000000000000001
RBP: ffffc9000d5df2e0 R08: 0000000000000001 R09: 0000000000000030
R10: 0000000000000020 R11: 00000000622d1f49 R12: 0000000000000020
R13: ffff88807cd00d40 R14: ffffc9000d5df628 R15: 1ffff92001abbe0a
FS:  00007f36a7b6f6c0(0000) GS:ffff888124a67000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30008ff8 CR3: 000000005c3e2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 shrink_node_memcgs mm/vmscan.c:6054 [inline]
 shrink_node+0x988/0x3da0 mm/vmscan.c:6095
 shrink_zones mm/vmscan.c:6339 [inline]
 do_try_to_free_pages+0x362/0x1920 mm/vmscan.c:6401
 try_to_free_mem_cgroup_pages+0x31b/0x740 mm/vmscan.c:6729
 mem_cgroup_resize_max+0x113/0x2b0 mm/memcontrol-v1.c:1480
 mem_cgroup_write+0x295/0x3a0 mm/memcontrol-v1.c:1662
 cgroup_file_write+0x1ef/0x7a0 kernel/cgroup/cgroup.c:4312
 kernfs_fop_write_iter+0x3af/0x570 fs/kernfs/file.c:352
 iter_file_splice_write+0xa24/0x12b0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x192/0x6c0 fs/splice.c:1161
 splice_direct_to_actor+0x345/0xa30 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x174/0x240 fs/splice.c:1230
 do_sendfile+0xb06/0xe50 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64 fs/read_write.c:1417 [inline]
 __x64_sys_sendfile64+0x1d8/0x220 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f36a6d8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f36a7b6f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f36a6fe5fa0 RCX: 00007f36a6d8f7c9
RDX: 0000000000000000 RSI: 000000000000000b RDI: 000000000000000b
RBP: 00007f36a6e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f36a6fe6038 R14: 00007f36a6fe5fa0 R15: 00007ffd83c52c98
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

