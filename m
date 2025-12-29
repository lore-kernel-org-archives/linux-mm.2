Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9214FE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 10:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C996B0088; Mon, 29 Dec 2025 05:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B002E6B0089; Mon, 29 Dec 2025 05:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B9C6B008A; Mon, 29 Dec 2025 05:21:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA286B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:21:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24D6614045F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:21:15 +0000 (UTC)
X-FDA: 84272116110.22.E4627E6
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B4BB1C0010
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:21:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3GFZSaQkbAF8PVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3GFZSaQkbAF8PVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767003673; a=rsa-sha256;
	cv=none;
	b=oVZcpb5///mZR8sCcS5EjtUwkjriIumnA4AZSGoOsBU1njHDTxUvc/+rWcAne3gkP9FziT
	ZO9K2BYItOnfM470VCEyiK0b8juL/x8jepWy+G04fgca4r9LudU4jGmGAjO21JG6J+pmAp
	LVXgthpjnHJYSDyLotnkQwdO96oGP6I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3GFZSaQkbAF8PVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3GFZSaQkbAF8PVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767003673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Ox/JblUcwCOD3ZgrWg9WrGCpSYzfvgdXBXhPwxfKuIE=;
	b=N8XDsm1Gks8KZt8JgGRWlvKHnGPH14Uhv3ObJoGfBFvxL3qVpxnFTlqBQ8KsbG+n4qPDAr
	fHkKq1d75VUpv5J6fV2KaBZ395GoVkpHKEeLkPFTSV4alVgJM8j0gnGvF7cDgZO5+D9f6B
	19YH3DVl9oFTyK4VGa4jpYo1NgKEjrc=
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c7032a5b40so9071044a34.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 02:21:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767003672; x=1767608472;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox/JblUcwCOD3ZgrWg9WrGCpSYzfvgdXBXhPwxfKuIE=;
        b=RlpNcpR0EycVBQFp9cMSYnwW/N/EXHejOqTDotwNNUS9Obb2H/r0hG1xT5ZCOom5Zx
         CHdUgkXxeHMD19YtxOX1Pcf7k/ZeOOq/8pBthCqGqozYXqIoWrmHSMruBm4RxVHNMQjs
         wOWVZmy6Gk1czwbtvqKZ+h+tC2hNDOrzMwqhgt7AUDdqeop6ZD8BYGbHsfVskDWxsQg5
         GTO0eMH9HmFca1UyjWoSqYU061YceuGyfv0qc28+KE6DKAvi8lfMGz47d3IgRx9Gl9xh
         LJwz9PFtBg/vlSZPwvAXeETc8lxLIlaCEtG8syu03up1Sqng51epYsMxu1kAR9NV5usg
         FHPA==
X-Forwarded-Encrypted: i=1; AJvYcCWap107RNuzkeIP5954RiC4fU1d7iLDPjv7E8RZ+rARBdBjbX5/L8Gd/1KjaTQ9tmsEjOTmSIqN4g==@kvack.org
X-Gm-Message-State: AOJu0Yx2lU6BrM6x2bQH+cpnY8doFNCfMD3hb19NKD05AjboRxmWGkwA
	Ei75yUEZKgi8oaVxdNKM0xY02IrqGBRNoelVzf5nluC9b8j8ch1+ZdqQXzkOv/Y9uS1LgDv2Vhu
	bTxk8wvDlCEgIbDG5eVVSHqsxyxYpQCvabmZF4Qtwsx9CO5PQa4RqBe+BGzc=
X-Google-Smtp-Source: AGHT+IFpWCdL4QrEBSygiVaHr4fo6u1s6eHPbXeWm+VlW7aCSUqPVhYeV8lwJAV9yWeuo8qMVDlOXxenUqwlRmyHrJRbuMalMSZS
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca1:b0:65b:387a:8362 with SMTP id
 006d021491bc7-65d0eb56659mr13532225eaf.55.1767003672640; Mon, 29 Dec 2025
 02:21:12 -0800 (PST)
Date: Mon, 29 Dec 2025 02:21:12 -0800
In-Reply-To: <20251229055151.54887-1-yanglincheng@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69525618.a70a0220.c527.0026.GAE@google.com>
Subject: [syzbot ci] Re: Improve khugepaged scan logic
From: syzbot ci <syzbot+ci74fd370f54089b9b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, david@kernel.org, 
	dev.jain@arm.com, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com, 
	vernon2gm@gmail.com, yanglincheng@kylinos.cn, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B4BB1C0010
X-Stat-Signature: 96shkmbbj8pp9qi3nu5ai3ths56wnjhb
X-Rspam-User: 
X-HE-Tag: 1767003673-497567
X-HE-Meta: U2FsdGVkX1/d4yCqznC6ftVSsP7yy42x6lG9jbMx/ZBOOCNUovw5Lyxym0WvpJJKuEGHdHODleDoOfut8tNJi4rvzx1MJ467kWXfNufWZBtdMvievIcnrXMxOj93v2xNod9W4iIHefqj6CDXsS3VyS716lQ10h2XJWt3e1JRT8WM5gd/Y2l/LCmHrmO/SaKDVJzc31VB0WnmZFO43NgmXATMY8WKs1PKO1mreFgkeYK3FHaz2rElO47yjOorqDniyp1jLfSJMGDqXThYN3qnZHTbPdi1LT31pOxwvsC3ukSh1E1uFNZAG9t2PCtSmmepSL5jrBmh+3ExXjJTUYChmHKhd7D1/4nDxFZcdJz4SolrbGhRtrVTt1XAUxhrMbhwihkg5xlBQ1w2uc0kI7dNzABnAh66maJY1BO9EHel+S9xq60TCCOVTS3I2u0rgdZf8vJt/FfFKUKrSz3BECyzcXN2rZrPLnK44qk4x69GCsecx/AACai5FAo15jjqUhNUGX8DvOOxuz535HBwRJGKFRBe05iZbVz3fSqLEI1mipJ9dj5quwdYhlkH4G2noQO6a8F9+uIdyhuW9BhHJDrnjd5mEOOGgDp5gbfjZpOEZ29e0F5UOeD9BKxB7ZqH0WTedsuqWkgVdPygjT5DI7GBVSbZ/AOnYkTqiZhN1o5t7XPuFVThcj07llKKUjMJhq2WNXgPawlPAGdZ8frEKQVksv3ISWGJ7aI1JHlgNdOyromdiUcFvtjjpX7r2Xv9BoGvEnIUbSst1VYDwT7FEqDl3VapX4xUJbqTtFs0eGA5OScAywjgDXgGHJTnULaYLpuIUgIjw7dTKf+PIrxSoAmZozwhorziPh2r8ehirpS0RY4lZ9e+gglY2EcB2pjC8ov6katLzJTGU9ZowFQVdJwz6+x0runfnMhICFt+khfHdj9fyyCDgdyMwxxtD77s+dSv+PrtXn7HIcEcySnasoF
 QajFu6ag
 TUnFEUdPcg8B25l3qKlHNJpPJMI2BnEbZAi3btOnTe0SEZNklOMBUiHcDA4+FDi0ViyFSGpkUYIVACUqFmfNL8TaQAIP89BHoNsyN3STrarilw94ATXOMk/ShT+qMvTXXIojnndR03zwTZmx0HAE174JXL3HVLdXo3wLVYOC+cX1UbEfDKlJvzB+uPudtqyOj2nPy3bVCcV+g83kq2VqS51xmwrnldG3j613DIIFA5wn8ErmmNaOTuVZG2jJNXFq3WBCPWVtMQB3SUK2M7cdgypiF04RRxWWIxsMnxBsOm91y3xmMjB7CJNX3Gnaa+1BSGce52Og1bWjw/JZrKhY/hJJYREth/diNUqj6KML2xOlEEXJG716UpcFFukQv9ZpqzP9VZ8c0/2fOTjLnmHmTORojFAL7WZilsX8eYu8o4DQhDP/c4DKYaOFGVJEYMQg+pJpNgpLwdnxIchTvBmB834JyjFCeBWSU0+IgKqEsuHPWzmXDhu3Rd0MrQBZ1/BywoE5sUSEncrbxOBUnqq0Q49yQrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] Improve khugepaged scan logic
https://lore.kernel.org/all/20251229055151.54887-1-yanglincheng@kylinos.cn
* [PATCH v2 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
* [PATCH v2 2/4] mm: khugepaged: just skip when the memory has been collapsed
* [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE
* [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY

and found the following issue:
WARNING in madvise_dontneed_free

Full report is available here:
https://ci.syzbot.org/series/f936dff1-2423-4f46-a59a-ea041c1d741a

***

WARNING in madvise_dontneed_free

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      33b485bade996a9d0154cf0888b7a5c23723121e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/81f62216-5094-4281-a942-238b7448a3be/config
C repro:   https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3c3ca3/c_repro
syz repro: https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3c3ca3/syz_repro

------------[ cut here ]------------
WARNING: mm/madvise.c:795 at get_walk_lock mm/madvise.c:795 [inline], CPU#0: syz.0.17/5977
WARNING: mm/madvise.c:795 at madvise_free_single_vma mm/madvise.c:830 [inline], CPU#0: syz.0.17/5977
WARNING: mm/madvise.c:795 at madvise_dontneed_free+0xb52/0xe10 mm/madvise.c:960, CPU#0: syz.0.17/5977
Modules linked in:
CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:get_walk_lock mm/madvise.c:795 [inline]
RIP: 0010:madvise_free_single_vma mm/madvise.c:830 [inline]
RIP: 0010:madvise_dontneed_free+0xb52/0xe10 mm/madvise.c:960
Code: c7 c6 b0 6e 25 8e e8 7d 4c a3 ff 48 83 fb 01 74 0c 83 fb 03 75 0e e8 ed 46 a3 ff eb 12 e8 e6 46 a3 ff eb 09 e8 df 46 a3 ff 90 <0f> 0b 90 31 db 89 9c 24 08 01 00 00 48 8b 74 24 68 48 8b 54 24 70
RSP: 0018:ffffc90004a17400 EFLAGS: 00010293
RAX: ffffffff821e7411 RBX: 0000000000000002 RCX: ffff888169b7d7c0
RDX: 0000000000000000 RSI: ffffffff8e256eb0 RDI: 0000000000000002
RBP: ffffc90004a175b0 R08: ffff888169b7d7c0 R09: 0000000000000002
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000100 R15: 1ffff92000942e88
FS:  0000555555761500(0000) GS:ffff88818e62f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe49d72b600 CR3: 00000001b85b6000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 madvise_vma_behavior+0xd57/0x3680 mm/madvise.c:1385
 madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1730
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1944
 do_madvise+0x1bc/0x270 mm/madvise.c:2037
 __do_sys_madvise mm/madvise.c:2046 [inline]
 __se_sys_madvise mm/madvise.c:2044 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2044
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe49d78f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff39cea178 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fe49d9e5fa0 RCX: 00007fe49d78f7c9
RDX: 0000000000000008 RSI: 0000000000600002 RDI: 0000200000000000
RBP: 00007fe49d7f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe49d9e5fa0 R14: 00007fe49d9e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

