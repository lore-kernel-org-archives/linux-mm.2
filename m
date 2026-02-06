Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D11EB28D4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3562A6B0005; Fri,  6 Feb 2026 02:24:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECC16B00A6; Fri,  6 Feb 2026 02:24:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216466B00A9; Fri,  6 Feb 2026 02:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10E4F6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:24:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE6291607DC
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:24:26 +0000 (UTC)
X-FDA: 84413193732.19.4AA2CC3
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D3B51C0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:24:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3KJeFaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3KJeFaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770362665; a=rsa-sha256;
	cv=none;
	b=X5XFsVD5OirQz2uKZYYPCrlN7tOnsjUT2ZQHvuepmF3TrVJgIf9OF1gi1iJuiMfFyOZbOq
	awUKb3hHPSIZXfymF6nw3sxac4Vz59Old4ulBiAszn5ZWZz4M05sMax+mtQ+Zrksa7vIo6
	0vPMEt7qSCnYlYmbtam0JYQtYwJRD18=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3KJeFaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3KJeFaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770362665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ot6ual0l9jo2XolXnfpiqkyLpmBuznoc4sQK0e9mC6I=;
	b=A5ll9+YinIlMIOwfViEr6Xde0LFOvdO579bqHkPdGd1i9UkqeINE1RnU9UvMMh4ddG7kO2
	KUQacJWxjhTMhnqt9mXQ0JYZBHey/gcSdWBBip4aeraPKwyJNMV1uSNrMx7+84EUbxiVvt
	85B/FcdR9T+4Qh0VUnnl1/Bb5S0Tq1o=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-662f738c3bfso6605458eaf.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770362664; x=1770967464;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ot6ual0l9jo2XolXnfpiqkyLpmBuznoc4sQK0e9mC6I=;
        b=avvB+P6Crn3+FzmLR5o4JgFsSxCR3ooXswMOoom1+rg242eXOTAcDioTOvDA9BgbUZ
         Eb48q2LUia5e0BtG9DsHPIEUb8SnyGuTe+n1vlv6MBv1ydQMSppulLEKkN4BRg7DuJY8
         vZTVnvja9N5+mkZPnRRG9qkmVOF6IojfIlYega4wRLTT21Vpxg4StngUKSsBWy3/t7o0
         vUQJpQ/HYLwabdD/r/45SgPeA+UDbV1psDQWvL3lYxvYGwUjR6NDo52C/TWDeiUadFxC
         NkbAGTRRxyYFRy75MhSEtwJe4xETGujo0+nx3UwOPX0blgVcaC2x2jI8EPgPvU1LwNq3
         +CWg==
X-Forwarded-Encrypted: i=1; AJvYcCWggtQ8W5h+Jfa+fRaAeCCpIHysaHMTUYl+jhLLfjSyKANZQjyHbSAz9uEEkggoRfxiB++SF/XOCQ==@kvack.org
X-Gm-Message-State: AOJu0YyxWFuTSss5xsPKczfEyRBYUacYx4CgBmMOhWnAByJOfYR68fw1
	V0KClj0XIB1wOgXJBwE4FwNwQzFuTKI7r80AF15DEJHHMGGghbsvxDyVTgo6UvQYWwMkCVRAR+P
	b+mTKRGGs3qQO+Xv/yWDyk2TFLC1+aEOL5823dbn7Ay/6m3btjfN1uTMXUbE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2202:b0:663:d06:81e2 with SMTP id
 006d021491bc7-66d09cabe40mr920061eaf.1.1770362664044; Thu, 05 Feb 2026
 23:24:24 -0800 (PST)
Date: Thu, 05 Feb 2026 23:24:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69859728.050a0220.3b3015.0033.GAE@google.com>
Subject: [syzbot] [cgroups?] [mm?] KASAN: wild-memory-access Read in
 lookup_swap_cgroup_id (2)
From: syzbot <syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0D3B51C0004
X-Stat-Signature: t9bfo4e5mkeabhssea59uuurecqzj4xb
X-HE-Tag: 1770362664-64526
X-HE-Meta: U2FsdGVkX1/HqpLGLSp0BwWT6gzZBayD7K7uqqz8v4mXEn6+BeVWeW3R0eareAKcC+ER7KI28XGkrwPRGL/S3N3zzEk3EM9RQVfKFy4/ib8DVTl+Id1uXNhDJ+TIn1z9hjDuGyey6FE0q9FVtvACO/2RdL3+DVMIrkysSG4q1AJBnQX5ZHVSFzMoBE5RqGz993KT22YxYSBkK4kARI5ZaIKijtuOMWTcKfxDGE1YM35gKPnGfGA1UYmao4Fmh4UzsFNH4BhSpZnqHVXe9MK0VWlG8boMtF85533fSFJkTTBX0IGwXDYI0xjTWa1tlM3sn2Pw7nrPs6+YtzPYr8U1h0LX+/yvQaWh+2ark3lWy5y9Z5Gx/fQVaR/ANJGJdNj4Inwww1uxySR9uLBYZaR03EJt9Q+GkZxoynea+r7XFyAfxeMHEQdVvMOhHYx5sm0DfDXULkrwlJS3yqmK6Ey4UC4RMinE9K/pjGkpeowVJwG5AVWo7bjoAy1fiTbXoUvObQqOu9xXIJWB31zU32HbYK0h+4SZUAEUOqStZ7jNQcwB6W0/zFRKy2kZQabyo1EQqv+Ci0Y928Vu8wiQ+9QoUMgEySFPx07iVpALIOk6RtC6rFl/zv2+rf01coypx3MW+SyfzaXT1pQUxjJ/uv1S7s34TVpm5rzfjOd4T5XHVASekShRGB2htIMNU3PrHt6OkEES8FmquWGmjqr6IyCwS9Q9ASoQMsOAcp1A8lliQevpIZG8aX3Hl5OUCnOU+/Q+M145C6n4yYuO1mAsoZOelZepipWQfBCO+oQ3BNdwHM6q8QYceTpNbXLYERIGgfvS2DCSOc0zpxiyqcodRIArPxDyF0rCjNlSI4xgJclkwTFSyOW0CPmK2A1MPhw3qs/L3s+4LH8V/TxWVUiwLzDYuemGB8Kke0wR12UWO7AZB2yeiu4uUlsC+Hw1dbRN+EHIw++fWvsADUwhW9YK74n
 Rd9K5edm
 b3S2BBX2II2J88AJiiWDY1/+7u26urIXUrXeuQDKweGd/NpxiPgOM9Ywe0c+9LG59nY8JaBTwNgO8qBDxQggAQyb7kdrERm4FRIPf06UytK7MA8/l0boaUFtj9mTe+rG0dVZZ1nl9pqZfhhkvMlmZ6rmqbL/yeGwzvUrguu6VeoucWhw0EmlpOYxoQC2b+QX45JMqlNlKMU/yuwzVxepdun+rBIHWyAV0IN4dsBq7XKDyMfX+dvem7h434jg665jnBFBahrO1WTEfPUWLs1RXxmqM42/7dLL0PcygwVFgoX+k16EVB9EEo7Uv6mI/tcHiRapqH7hE1W6tobN2UEFqq+Tw6I3ZFyOvpctBmxai2DJ+iY0gNPULa6OzsZJeGeq0PJvyFS6bmiR2AkveLmQrETlmKsIa2kZsfKppbG5ok//u5XOGJI8+1TBuUtou4xc5W7mKPl6qjNUJAf9eBheMKLvcdBounCxe3No6j2dLMxmcGFr2lPw8Vk/GqdLD/o4NMSCDna7qEGWfPVODO/aAh5cl9Dbr3ZshkDLzwvfDOJNg0U9MwUa46kQqbJMUYhyp3UAnnp9nfP/AoVBTdAUUlCHeFJkSh7YgPyfrxi7rVl6XgAFg9eNabN2ob8r7H3A078MRbhLzXvvuyOTNOHS6adIEcCoDLKhX6SMuP141+CDcj49h381uTPX2jS4ITSpCbShINZpVZZDyMXhH2OsCMQEUZdyvoQIBPXNqr90wzZ5hkHV8dINLVZHcUCqGq70lsksahTlg7y9+sjUH9Oam4S+JxzMH3enXW95HNobHafAtM5a3p4xnO+RmqyZsMp5tfqwiKn1gmD87LHnuKHAIqabZ4Q4c6SS5yIz8JuZK5Nbcl+Z5f0L+MYY0PXNbOhgHH/FaZRSYSzV4dE04N88ePVrSfKqQV+x9c0sQHNC58+0li4GDAFNael7ZFKyvPfy8bBQ9fB//7hLFIWLeWcWc7DksPxIC
 6GY8cmP0
 xdb7RGIAofA3MtH80+Qec/gQsPoZNrPjzU1k+dib2I46yKkmV+HDNCsmOVWR6YelOG2723vofcl0kxsdJwm1RaR72a66ctLqde/T/0H0WzmM8egPNDlBK8rPIyYBBcjwjXRsxQnbpR4aOiqP+8DX1VxbcG1wZpenNO9SC5rAhpjX7uILt2h9WJdiqJhm6JWrTeQMRLZ+btDQhfh+uBSkaPTTgblOLOWfUTPELJqOvTImfiuO2kVtVqlHjiVz5KQgr7oRSp2qn42twh54SSj57BZnm8QE6fxqKGVy7ujbSaTkWlDtnrD542WC7+Ds42u3GK05xF7zLdbbT1zYqrO0+CTyl6lfLJWTqSdEqVGb3y1zetjS0zJCwuJfFIb1JEW3Jo9BEV9s4MIIArq/NtMV7L3dzLJiOi4gxEj40OiBxcwKeTwJoUgbHjaF6WriVl/IcPCGGFon+G4zLcfM/mtGCDEQ7arEpci5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    18f7fcd5e69a Linux 6.19-rc8
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1428fc5a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
dashboard link: https://syzkaller.appspot.com/bug?extid=e12bd9ca48157add237a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2c19d9acc149/disk-18f7fcd5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/02cf07c94e58/vmlinux-18f7fcd5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/84011cec9819/bzImage-18f7fcd5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: wild-memory-access in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: wild-memory-access in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
BUG: KASAN: wild-memory-access in __swap_cgroup_id_lookup mm/swap_cgroup.c:28 [inline]
BUG: KASAN: wild-memory-access in lookup_swap_cgroup_id+0xf9/0x1a0 mm/swap_cgroup.c:127
Read of size 4 at addr 0007fffffffffffc by task syz.5.3598/20029

CPU: 1 UID: 0 PID: 20029 Comm: syz.5.3598 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
 __swap_cgroup_id_lookup mm/swap_cgroup.c:28 [inline]
 lookup_swap_cgroup_id+0xf9/0x1a0 mm/swap_cgroup.c:127
 swap_pte_batch+0x3c3/0x720 mm/internal.h:390
 zap_nonpresent_ptes mm/memory.c:1749 [inline]
 do_zap_pte_range mm/memory.c:1818 [inline]
 zap_pte_range mm/memory.c:1858 [inline]
 zap_pmd_range mm/memory.c:1950 [inline]
 zap_pud_range mm/memory.c:1978 [inline]
 zap_p4d_range mm/memory.c:1999 [inline]
 unmap_page_range+0x1f6f/0x43e0 mm/memory.c:2020
 unmap_single_vma+0x153/0x240 mm/memory.c:2062
 unmap_vmas+0x218/0x470 mm/memory.c:2104
 exit_mmap+0x181/0xae0 mm/mmap.c:1277
 __mmput+0x12a/0x410 kernel/fork.c:1173
 mmput+0x67/0x80 kernel/fork.c:1196
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x78a/0x2a30 kernel/exit.c:959
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x86/0x4b0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4fe/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2f8f19aeb9
Code: Unable to access opcode bytes at 0x7f2f8f19ae8f.
RSP: 002b:00007f2f900350e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f2f8f416098 RCX: 00007f2f8f19aeb9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f2f8f416098
RBP: 00007f2f8f416090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2f8f416128 R14: 00007ffc0c8cc050 R15: 00007ffc0c8cc138
 </TASK>
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

