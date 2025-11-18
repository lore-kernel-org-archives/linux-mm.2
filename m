Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44FA3CEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E54E8E0006; Tue, 18 Nov 2025 03:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EBA8E0002; Tue, 18 Nov 2025 03:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756368E0006; Tue, 18 Nov 2025 03:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4C18E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:46:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED156C042A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:46:16 +0000 (UTC)
X-FDA: 84123095952.13.2068E6E
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1BCC61C0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:46:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3VjIcaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3VjIcaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763455575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=gRIBR7nKyt0lzCZDU7BoFwtHeQyo2pGhv6COg15G0gU=;
	b=iaZ0RVgCDQtg5zXQBI4PWsTjgJqPiD+v4Csr2kdoPbVOcKbUhZHQUNrw3hVcudXNCMay2O
	Hd4ygPRVr+uBmRhCOOYI9bc7UPO62Tf1mrBZeBalSqPMqRi+WbV+MW7EObwkoRIXu7Iowo
	mLPQM/BVVk1z/nNbELce55/d/7oENg8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3VjIcaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3VjIcaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763455575; a=rsa-sha256;
	cv=none;
	b=UlQ2ZqLnMSI30nGQE/PglIcaVVxABWiInA2LdIXVrYdZfMyWfUM7HybZzOfsXnFelHBnFq
	D+Oy7vdWzc1EM9i2bb6pmoaM+FvjiA0cW1NVuOM+1pUOfp15GdGyP33ZiHszq8RgpiJI9M
	BYjIuYHEhnu7sd0mQVCOt+H5oh9+PJg=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4337853ffbbso52402185ab.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763455574; x=1764060374;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gRIBR7nKyt0lzCZDU7BoFwtHeQyo2pGhv6COg15G0gU=;
        b=Tr+znAKvfpqSBaMTiRc9cARdPYE/glqzKAodQ6mkFQPQguTrxXY1jrXzdrRA3j9388
         JgKkLnZ+Ndp79tXkp706YyuyL3cO2wJ0IKpRGFviE2mhkbnqJkvHxqCNvCBFKbEzxKCT
         9AtfX4vYl+xpp0Kp+0S+3OuJGb+qPfpDUqZF+iVbfrjGGet4SZgxBirqa7n6Yf7e+3Ah
         eAKvxQWPtvLfI6IOywH0OAxK9ijqkEqnu/6FWlWr1MulZjBUuC0tM8xC7x6OtS+HjjAG
         pvUipsqwuEsSuu8XDE8JDfeYhM78Kdq28sTvJJOf0Cz7yQSiByqsxZrHf/Oyi/4InjhG
         ptuw==
X-Forwarded-Encrypted: i=1; AJvYcCUHdD8Og3jP2ElYJc31rr4p4kBlCNl40Uc2rNhQ7RTsYFB8OImXxYI+rjue4t4jf9owyCJ5Fv1tQw==@kvack.org
X-Gm-Message-State: AOJu0Ywd39TLkmC2PE3gCNjMsTKjA0DqNmdMH9yviKZKFQEHpw45zMaN
	LPUwBIFJrS6vEqYR9OEEdgQTsynQSdskE3twf+oPmF91Oqi1IsPObCk5EO1+8PPwH2Gde0hzKnB
	A0FbYn/Dc+DinshA5/1AX62vBYXRcn97Uuqmvbo57nyUPeemZQKUNwrS9e+k=
X-Google-Smtp-Source: AGHT+IH1E+VLDYIvY3O0hSevd7z7LwPjZPul6wO2Yab5t2z9KIJZhyauwcLSrmMyLZHPIDK6aVt2fFg3D4gWyhBIYHNum4R38hnT
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8a:b0:433:7d04:55da with SMTP id
 e9e14a558f8ab-4348c93ebf0mr201382765ab.31.1763455574118; Tue, 18 Nov 2025
 00:46:14 -0800 (PST)
Date: Tue, 18 Nov 2025 00:46:14 -0800
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c3256.a70a0220.3124cb.00b6.GAE@google.com>
Subject: [syzbot ci] Re: Extend xas_split* to support splitting arbitrarily
 large entries
From: syzbot ci <syzbot+ci3962cf5917af9819@syzkaller.appspotmail.com>
To: ackerleytng@google.com, akpm@linux-foundation.org, david@redhat.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, michael.roth@amd.com, vannapurve@google.com, 
	willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1BCC61C0010
X-Stat-Signature: yskhj34gzzhaw1o8xeip9yy38r17hwym
X-Rspam-User: 
X-HE-Tag: 1763455574-29207
X-HE-Meta: U2FsdGVkX18lyCIH+Akif/FVRzCy3L0iYkAvoL6XkE6zZLy38FEFYiX0ZcDeuRb0JouDFQbucISqnA3H/9/IBAIqyddX0o1lieb62NPxIcohKzl8246qG4T21/Xgxoj0uK7U/EbLGioWYEZilm2SoSZrg/d9o55ZtprEvBHWNp2/r+ZpyGMjQuzd/lr5S5pvSHbwL5TjDOSg9jYhA4CE5s6tqA2m5cW3KMnafPJkw8hf9NmBOjaG50ed962pNkOpo+73finQVtxbIuP5u0Gj+KnBdfHHdWdfyI+IbJweYArEuwIvBO+o2FFYVbq2ZxwEJaKlRyLGtN++Nq4gxynXeLTEe40Wuerb0FILPMJPCrnvzQTh67VZT5t1PtIJDWDACq1iSd9jZN9TGvasHs2GsSpLyFR4Bn+QGEcwBC65TwbiCNgESBZGFryrDhikjPU/LrpTTThrUoLaai7ouVo8MZ9+GnMwJCSlghX1PtCZspxuYPTlYncRuYYLwXOjAxMFu3i7Sx2OpMqTLZ0GhUj+a7WFjbA1XnSmp022gvnVBDGjnHQqk3EUnLSw8dY01z238PH6tcrsxyqAUFxEGxdjMl6T69RZ42lu0jEraGK0xkBYaj2mvlYHQGl9MNzWv6KqqnyyOlFWPY9jBElGwbnWDJ+wf17ccnDpsYCkaqm/QO328cUdZhkmdEqyjpDJlPk2s4ji+ySel3qlrL6PQ9Pf+RtwzqjOplqns6hz7Wg/roHg7nEPDS0b62k2KDeevxzS9HRePXDcpGr7HTAeJmMVwknZMHMSryyRjIDd0L1kBH2eQzEbKCMZjrhiW9MFFMcptmatK8msfpvPqZLHNy9eI0c0iIT308jddoVgX2UQUMdQrfuYDItCR6kJN8xIDx4URsL4wPz8Z+mZ1+G50X/cAqRH51N2AezIPQd7+bWsH/RS6VbdoN6bV7to7cMttikurpjkSwN+7QXzWv8EdsO
 OyGbHd2y
 p3mIh/NJM3Sz3TGlcfrbMip9wMKKE5Kzl8X6ekb5X/2Qt7ElQJVfUI67t08enLt7LCnFeYQtt1EbhNhqLu0fh9RzFV3chamuBgTP9g7VYEXPZRrAr2Mtfvd/dEKHq27GpSRv3e1AVuTxCRmSZVE0gbrNYvHhghA11aJ4Pd6PxtYN4vkOdI1U9zH4M6QSWjvlyjDuJPs78TYJrn7f9M4leAvk9QDTdEWG7Sxbxqjc/u+Eub0TM2k+FKB4elCwFuwRxf7eKZ9ATYQrJEJwP4xiwfm2c6OMVSLASpYtsh0EEkMaJnWNHZyTlwk5Bc3P9gR4BLicrp30f8ewo4UMwOdfcdMRICi5F/iw2D6y2JM3j9mOyLllmCGMUGzNZ2+Dq2LtY8GtaVHJSFKBQIh0QtduU1mLUtpky9VJuGatHg13Y7I+a9oLGrmyHZlPy2jdq6XAcvZXuyHOuAyb79iOSzVmC8ThwhJl+L8zMscd7hAbJn8xZ/P/LNSb+G+Z1L6rRZzTEv6iJflzRHSS+6gyyKEu6fGTaa+pcbaGLrLVv65mKRHn58BRHMe8XyqHDFYZwR8B67sL+VXllhhKoPICPjYkgcIPDYEYaeLZ6sCxlnL2rgJ5fsRcIUOjvieyrB7MiETCsYtzYA+R6Xh5XgT/ORsjFggsVs6eVQUEjKRhsXRz/q5Wzz0Q4R6IRkF8tCpx8B3WUlJARp3PcG0g70k/GzVmBZrCXyQLz9XzldlFt+8PbdARAkJMk/Iwl1jjdlZXTT5PwIcLVp6fSwGE0pLf1VfJkQqNnBPiUznadMjDKZx0fIADjlYLrl+9CHhbtgj2PZj/Otd+LTHcuYy7eaY2Ci9bni3A0oP7E799dYnUVY0CXLy9QowtbiNqnxOCS4KdmrfZlHHchrsUsw/w6N+mI8p7iaNyU8ASB8lsFNp/MPytHs11oWVcs+6eHbZ/Mhdz5lU2jBQLdzA76yRohMlFK8PrxrTT/Wr8A
 S+/CI860
 81yZNfwZYSvjXiZS/W5Ke+YO5PG/+3QYhoHHog/ZC4TrMcu2vkwbt0GMUKAdre5pWKSzLFTILVzfLRxDslV9OhlgBM9z8cZk+gZBSnuSmI0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Extend xas_split* to support splitting arbitrarily large entries
https://lore.kernel.org/all/20251117224701.1279139-1-ackerleytng@google.com
* [RFC PATCH 1/4] XArray: Initialize nodes while splitting instead of while allocating
* [RFC PATCH 2/4] XArray: Update xas_split_alloc() to allocate enough nodes to split large entries
* [RFC PATCH 3/4] XArray: Support splitting for arbitrarily large entries
* [RFC PATCH 4/4] XArray: test: Increase split order test range in check_split()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/aa74d39d-0773-4398-bb90-0a6d21365c3d

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/c26972f6-b81e-4d6f-bead-3d77003cf075/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 0 PID: 6465 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 0 UID: 0 PID: 6465 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 75 2b 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90005d7fb00 EFLAGS: 00010246
RAX: 6e85c22fb4362300 RBX: 0000000000000dc0 RCX: ffff888176898000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90005d7fb98 R08: ffff888121224293 R09: 1ffff11024244852
R10: dffffc0000000000 R11: ffffed1024244853 R12: 1ffff92000baff60
R13: dffffc0000000000 R14: ffffc90005d7fb20 R15: ffffc90005d7fb30
FS:  000055555be14500(0000) GS:ffff88818eb36000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f653e85c470 CR3: 00000001139ec000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_create_from_user+0xa7/0x440
 do_seccomp+0x7b1/0xd90
 __se_sys_prctl+0xc3c/0x1830
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f653e990b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007fffbd3687c0 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007f653ea2cf80 RCX: 00007f653e990b0d
RDX: 00007fffbd368820 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007fffbd368830 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007fffbd368c58 R14: 00007fffbd368ed8 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

